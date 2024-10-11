unit unDLII430_units;

interface

uses
  SysUtils, Variants, DBClient, StrUtils, unGlobal, unCommon;

type
  TDLI430Rec = record
    TotCnt,
    FinCnt  :Integer;
    CCLSH1,
    CCLSH2,
    CCLPNL1,
    CCLPNL2,
    PPRL1,
    PPRL2,
    PPPNL1,
    PPPNL2  :Double;
  end;

function GetCustnoDetail(Indate:TDateTime; Custno:string):TDLI430Rec;

implementation

//計算排程數量、筆數、打單數
function GetCustnoDetail(Indate:TDateTime; Custno:string):TDLI430Rec;
var
  Rec:TDLI430Rec;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpSQL:='Select Saleno,Saleitem,Orderno,Orderitem,Pno,Notcount1 From DLI010'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(Indate))
         +' And CharIndex(Custno,'+Quotedstr(Custno)+')>0'
         +' And Len(IsNull(Dno_ditem,''''))=0 And IsNull(GarbageFlag,0)=0'
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    Rec.TotCnt:=tmpCDS.RecordCount;
    tmpSQL:='';

    with tmpCDS do
    while not Eof do
    begin
      if Length(Trim(FieldByName('Saleno').AsString))>0 then
      begin
        tmpSQL:=tmpSQL+' or (ogb01='+Quotedstr(FieldByName('Saleno').AsString)
                      +' and ogb03='+FieldByName('Saleitem').AsString+')';
        Rec.FinCnt:=Rec.FinCnt+1;
      end;

      if UpperCase(LeftStr(FieldByName('Pno').AsString,1))='A' then      //ml
         Rec.CCLSH1:=Rec.CCLSH1+FieldByName('Notcount1').AsFloat
      else if UpperCase(LeftStr(FieldByName('Pno').AsString,1))='C' then //鋁基板
         Rec.CCLPNL1:=Rec.CCLPNL1+FieldByName('Notcount1').AsFloat
      else                                                               //其它
         Rec.PPRL1:=Rec.PPRL1+FieldByName('Notcount1').AsFloat;
         
      Next;
    end;

    if Length(tmpSQL)>0 then
    begin
      Data:=null;
      Delete(tmpSQL,1,3);
      tmpSQL:='Select ogb04,ogb12 From oga_file Inner Join ogb_file'
             +' ON oga01=ogb01 Where ogaconf=''Y'' and ('+tmpSQL+')';
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        tmpCDS.Data:=Data;

        with tmpCDS do
        while not Eof do
        begin
          if UpperCase(LeftStr(FieldByName('ogb04').AsString,1))='A' then      //ml
             Rec.CCLSH2:=Rec.CCLSH2+FieldByName('ogb12').AsFloat
          else if UpperCase(LeftStr(FieldByName('ogb04').AsString,1))='C' then //鋁基板
             Rec.CCLPNL2:=Rec.CCLPNL2+FieldByName('ogb12').AsFloat
          else                                                                 //其它
             Rec.PPRL2:=Rec.PPRL2+FieldByName('ogb12').AsFloat;

          Next;
        end;
      end;
    end;

    Result:=Rec;

  finally
    tmpCDS.Free;
  end;
end;

end.
 