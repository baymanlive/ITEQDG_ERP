{*******************************************************}
{                                                       }
{                unDLII020_btnopt                       }
{                Author: kaikai                         }
{                Create date: 2015/12/4                 }
{                Description: DLII020(DLII021)各按扭操作}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020_btnopt;

interface

uses
  Windows, Classes, SysUtils, Controls, Dialogs, DB, DBClient,
  Variants, Math, unGlobal, unCommon, unDLII020_upd;

type
  TDLII020_btnopt = class
  public
    constructor Create;
    destructor Destroy; override;
    function UpdateLot(CDS, CDS2:TClientDataSet):Boolean;
    function SplitQty(CDS:TClientDataSet):Boolean;
    function SplitQtyAll(IsML:Boolean):Boolean;
    function DeleteSaleNo(CDS:TClientDataSet):Boolean;
    function DeleteSaleItem(CDS:TClientDataSet):Boolean;
    function DeleteLot(CDS, CDS2:TClientDataSet):Boolean;
  end;

implementation

constructor TDLII020_btnopt.Create;
begin
  FrmDLII020_upd:=TFrmDLII020_upd.Create(nil);
end;

destructor TDLII020_btnopt.Destroy;
begin
  FreeAndNil(FrmDLII020_upd);
  inherited;
end;

//更改倉、儲、批
function TDLII020_btnopt.UpdateLot(CDS, CDS2:TClientDataSet):Boolean;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or (not CDS2.Active) or CDS.IsEmpty or CDS2.IsEmpty then
  begin
    ShowMsg('請選擇要更改的批號單據', 48);
    Exit;
  end;

  if Trim(CDS.FieldByName('Saleno').AsString)<>'' then
  begin
    ShowMsg('已產生出貨單,不可更改!', 48);
    Exit;
  end;

  with FrmDLII020_upd do
  begin
    Edit1.Text:=CDS2.FieldByName('Stkplace').AsString;
    Edit2.Text:=CDS2.FieldByName('Stkarea').AsString;
    Edit3.Text:=CDS2.FieldByName('Manfac').AsString;
    Edit4.Text:=FloatToStr(CDS2.FieldByName('Qty').AsFloat);
    if ShowModal=mrOK then
    begin
      tmpSQL:=' Declare @Bu nvarchar(10)'
             +' Declare @Dno nvarchar(20)'
             +' Declare @Ditem int'
             +' Set @Bu='+Quotedstr(CDS2.FieldByName('Bu').AsString)
             +' Set @Dno='+Quotedstr(CDS2.FieldByName('Dno').AsString)
             +' Set @Ditem='+Quotedstr(CDS2.FieldByName('Ditem').AsString)
             +' Update Dli020 Set Stkplace='+Quotedstr(UpperCase(Trim(Edit1.Text)))
             +' ,Stkarea='+Quotedstr(UpperCase(Trim(Edit2.Text)))
             +' ,Manfac='+Quotedstr(UpperCase(Trim(Edit3.Text)))
             +' ,Qty='+Quotedstr(Trim(Edit4.Text))
             +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem'
             +' And Sno='+CDS2.FieldByName('Sno').AsString
             +' exec dbo.proc_UpdateDelcount @Bu,@Dno,@Ditem'
             +' exec dbo.proc_UpdateBingbao @Bu,@Dno,@Ditem'
             +' Select Delcount,Jcount_old,Jcount_new,Bcount From DLI010'
             +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS:=TClientDataSet.Create(nil);
        try
          tmpCDS.Data:=Data;
          CDS.Edit;
          CDS.FieldByName('Delcount').AsFloat:=tmpCDS.Fields[0].AsFloat;
          CDS.FieldByName('Jcount_old').AsFloat:=tmpCDS.Fields[1].AsFloat;
          CDS.FieldByName('Jcount_new').AsFloat:=tmpCDS.Fields[2].AsFloat;
          CDS.FieldByName('Bcount').AsFloat:=tmpCDS.Fields[3].AsFloat;
          CDS.Post;
          CDS.MergeChangeLog;
        finally
          FreeAndNil(tmpCDS);
        end;
        ShowMsg('更新完畢!', 64);
        Result:=True;
      end;
    end;
  end;
end;

//拆分數量
function TDLII020_btnopt.SplitQty(CDS:TClientDataSet):Boolean;
var
  i,tmpDitem:Integer;
  tmpSQL:string;
  tmpQty1,tmpQty2:Double;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇要拆分的單據!', 48);
    Exit;
  end;

  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then
  begin
    ShowMsg('此訂單已拆分過一次,不可再拆!', 48);
    Exit;
  end;

  if ShowMsg('確定對第'+CDS.FieldByName('Sno').AsString+
             '項訂單['+CDS.FieldByName('Orderno').AsString+'/'+
                       CDS.FieldByName('Orderitem').AsString+
             ']進行數量拆分嗎?',33)=IdCancel then
     Exit;

  if not InputQuery(CheckLang('請輸入尾數'), 'Number', tmpSQL) then
     Exit;
  if tmpSQL = '' then
     Exit;
  try
    tmpQty1:=StrToFloat(tmpSQL);
  except
    ShowMsg('無效的數量!', 48);
    Exit;
  end;

  if tmpQty1<0 then
  begin
    ShowMsg('無效的數量!', 48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='Select Top 1 * From DLI010'
           +' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
           +' And Ditem='+CDS.FieldByName('Ditem').AsString;
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('單據不存在!', 48);
      Exit;
    end;

    //可能PDA拆過
    if Length(Trim(tmpCDS.FieldByName('Dno_Ditem').AsString))>0 then
    begin
      ShowMsg('此訂單已拆分過一次,不可再拆!', 48);
      Exit;
    end;

    if (tmpCDS.FieldByName('delcount').AsFloat=0) and
       (tmpQty1=tmpCDS.FieldByName('notcount').AsFloat) then
    begin
      ShowMsg('拆分後數量不能為0!', 48);
      Exit;
    end;

    tmpQty2:=RoundTo(tmpCDS.FieldByName('notcount').AsFloat-
                     tmpCDS.FieldByName('delcount').AsFloat+
                     tmpCDS.FieldByName('bcount').AsFloat,-3);
    if tmpQty1>tmpQty2 then
    begin
      ShowMsg('拆分後數量:'+FloatToStr(tmpQty1)+#13#10+'不能大於'+#13#10+'應出數量-檢貨數量+B級數量:'+FloatToStr(tmpQty2), 48);
      Exit;
    end;
    
    Data:=null;
    tmpSQL:='Select IsNull(Max(Ditem),0)+1 AS Sno From Dli010'
           +' Where Bu='+Quotedstr(CDS.FieldByName('Bu').AsString)
           +' And Dno='+Quotedstr(CDS.FieldByName('Dno').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;
    tmpDitem:=StrToInt(VarToStr(Data));

    with CDS do
    begin
      Edit;
      FieldByName('notcount').AsFloat:=RoundTo(tmpCDS.FieldByName('notcount').AsFloat-tmpQty1, -3);
      Post;
      Append;
      for i:=0 to tmpCDS.FieldCount -1 do
          FieldByName(tmpCDS.Fields[i].FieldName).Value:=tmpCDS.Fields[i].Value;
      FieldByName('Ditem').AsInteger:=tmpDitem;
      if Length(FieldByName('Dno_Ditem').AsString)=0 then //保存被拆單據
         FieldByName('Dno_Ditem').AsString:=tmpCDS.FieldByName('Dno').AsString+'@'+
                                            tmpCDS.FieldByName('Ditem').AsString;
      FieldByName('Saleno').Clear;
      FieldByName('Saleitem').Clear;
      FieldByName('notcount').AsFloat:=tmpQty1;
      FieldByName('notcount1').AsFloat:=0;
      FieldByName('delcount').AsFloat:=0;
      FieldByName('delcount1').AsFloat:=0;
      FieldByName('Jcount_old').AsFloat:=0;
      FieldByName('Jcount_new').AsFloat:=0;
      FieldByName('Bcount').AsFloat:=0;
      FieldByName('Chkcount').AsFloat:=0;
      FieldByName('Coccount').AsFloat:=0;
      FieldByName('Coccount1').AsFloat:=0;
      FieldByName('Check_ans').AsBoolean:=False;
      FieldByName('Check_user').Clear;
      FieldByName('Check_date').Clear;
      FieldByName('BingBao_ans').AsBoolean:=False;
      FieldByName('Coc_ans').AsBoolean:=False;
      FieldByName('Coc_no').Clear;
      FieldByName('Coc_user').Clear;
      FieldByName('Prn_ans').AsBoolean:=False;
      FieldByName('Coc_err').AsBoolean:=False;
      FieldByName('Coc_errid').Clear;
      FieldByName('Coc_erruser').Clear;
      FieldByName('Coc_errdate').Clear;
      FieldByName('Muser').Clear;
      FieldByName('Mdate').Clear;
      FieldByName('Scantime').Clear;
      FieldByName('SourceDitem').AsInteger:=0;
      FieldByName('QtyColor').AsInteger:=0;
      FieldByName('InsFlag').AsBoolean:=False;
      FieldByName('GarbageFlag').AsBoolean:=False;
      Post;
    end;
    if PostBySQLFromDelta(CDS, 'DLI010', 'Bu,Dno,Ditem') then
    begin
      ShowMsg('拆分完畢!', 64);
      Result:=True;
    end else
    begin
      if CDS.ChangeCount>0 then
         CDS.CancelUpdates;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//指定出貨日期已產生出貨單未出完貨的全部拆分
//IsML:True是M/L False是鋁基板
function TDLII020_btnopt.SplitQtyAll(IsML:Boolean):Boolean;
var
  tmpIndate:TDateTime;
  tmpSQL,tmpFlag:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  tmpSQL:=DateToStr(Date);
  if not InputQuery(CheckLang('請輸入出貨日期'), 'Date', tmpSQL) then
     Exit;
  if not ConvertDate(tmpSQL, tmpIndate) then
  begin
    ShowMsg('日期格式錯誤,請輸入yyyy/m/d或yyyy-m-d', 48);
    Exit;
  end;

  if ShowMsg('對出貨日期['+tmpSQL+']所有已產生出貨單,但未出完數量的單據,'+#13#10+
             '確定進行全部拆分嗎?',33)=IdCancel then
     Exit;

  if IsML then
     tmpFlag:='1'
  else
     tmpFlag:='0';

  tmpSQL:='exec dbo.proc_SplitDli010_All '+Quotedstr(g_UInfo^.BU)+','+
    Quotedstr(DateToStr(tmpIndate))+','+tmpFlag;
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if tmpCDS.FieldByName('errorcode').AsInteger=0 then
      begin
        ShowMsg('共'+IntToStr(tmpCDS.FieldByName('cnt').AsInteger)+'筆拆分完畢!', 64);
        Result:=True;
      end else
        ShowMsg('拆分失敗!'+IntToStr(tmpCDS.FieldByName('errorcode').AsInteger), 48);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//刪除整張出貨單
function TDLII020_btnopt.DeleteSaleNo(CDS:TClientDataSet):Boolean;
var
  P:TBookmark;
  tmpSQL,tmpSaleno:string;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or
     (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    ShowMsg('請選擇要刪除的出貨單!', 48);
    Exit;
  end;

  tmpSaleno:=CDS.FieldByName('Saleno').AsString;
  if ShowMsg('刪除後,請手動作廢TipTop中對應的出貨單'#13#10+
             '確定刪除['+tmpSaleno+']出貨單的所有項次嗎?',33)=IdCancel then
     Exit;

  tmpSQL:='exec proc_Dli010ClearSaleno '+Quotedstr(CDS.FieldByName('Bu').AsString)+','
                                        +Quotedstr(tmpSaleno)+',-1';  //-1項次
  if QueryOneCR(tmpSQL, Data) then
  begin
    if VarToStr(Data)='-1' then
    begin
      ShowMsg('此銷貨單號不存在,請重新查詢資料再重試!', 48);
      Exit;
    end
    else if VarToStr(Data)='1' then
    begin
      ShowMsg('更新失敗,請重試!', 48);
      Exit;
    end;

    with CDS do
    begin
      P:=GetBookmark;
      DisableControls;
      try
        First;
        while Locate('Saleno', tmpSaleno,[]) do
        begin
          Edit;
          FieldByName('Prn_ans').AsBoolean:=False;
          FieldByName('Saleno').Clear;
          FieldByName('Saleitem').Clear;
          Post;
        end;
        MergeChangeLog;
      finally
        GotoBookmark(P);
        EnableControls;
      end;
    end;

    ShowMsg('刪除完畢!', 48);
    Result:=True;
  end;
end;

//刪除出貨單某一項
function TDLII020_btnopt.DeleteSaleItem(CDS:TClientDataSet):Boolean;
var
  tmpSQL,tmpSaleno,tmpSaleitem:string;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or
     (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    ShowMsg('請選擇要刪除的出貨單項次!', 48);
    Exit;
  end;

  tmpSaleno:=CDS.FieldByName('Saleno').AsString;
  tmpSaleitem:=CDS.FieldByName('Saleitem').AsString;
  if ShowMsg('刪除後,請手動更改TipTop中對應的出貨單項次'#13#10+
             '確定刪除['+tmpSaleno+'/'+tmpSaleitem+']出貨單項次嗎?',33)=IdCancel then
     Exit;

  tmpSQL:='exec proc_Dli010ClearSaleno '+Quotedstr(CDS.FieldByName('Bu').AsString)+','
                                        +Quotedstr(tmpSaleno)+','
                                        +Quotedstr(tmpSaleitem);
  if QueryOneCR(tmpSQL, Data) then
  begin
    if VarToStr(Data)='-1' then
    begin
      ShowMsg('此銷貨單號不存在,請重新查詢資料再重試!', 48);
      Exit;
    end
    else if VarToStr(Data)='1' then
    begin
      ShowMsg('更新失敗,請重試!', 48);
      Exit;
    end;

    with CDS do
    begin
      Edit;
      FieldByName('Prn_ans').AsBoolean:=False;
      FieldByName('Saleno').Clear;
      FieldByName('Saleitem').Clear;
      Post;
      MergeChangeLog;
    end;

    ShowMsg('刪除完畢!', 64);
    Result:=True;
  end;
end;

//刪除某一項檢貨資料(並包不可刪除)
function TDLII020_btnopt.DeleteLot(CDS, CDS2:TClientDataSet):Boolean;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('請選擇要刪除的批號!', 48);
    Exit;
  end;

  if Length(CDS.FieldByName('Saleno').AsString)>0 then
  begin
    ShowMsg('已產生出貨單,不可刪除!', 48);
    Exit;
  end;

  if CDS2.FieldByName('JFlag').AsInteger=2 then
  begin
    ShowMsg('請先刪除[並包確認]的資料!', 48);
    Exit;
  end;

  if ShowMsg('確定刪除這筆批號資料嗎,刪除後不可恢複?'#13#10'倉庫：'+
       CDS2.FieldByName('StkPlace').AsString+#13#10'儲位：'+
       CDS2.FieldByName('StkArea').AsString+#13#10'批號：'+
       CDS2.FieldByName('Manfac').AsString+#13#10'數量：'+
       CDS2.FieldByName('Qty').AsString, 33)=IdCancel then
     Exit;

  tmpSQL:=' Declare @Bu nvarchar(10)'
         +' Declare @Dno nvarchar(20)'
         +' Declare @Ditem int'
         +' Set @Bu='+Quotedstr(CDS2.FieldByName('Bu').AsString)
         +' Set @Dno='+Quotedstr(CDS2.FieldByName('Dno').AsString)
         +' Set @Ditem='+Quotedstr(CDS2.FieldByName('Ditem').AsString)
         +' Delete From DLI020 Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem'
         +' And Sno='+CDS2.FieldByName('Sno').AsString
         +' exec dbo.proc_UpdateDelcount @Bu,@Dno,@Ditem'
         +' exec dbo.proc_UpdateBingbao @Bu,@Dno,@Ditem'
         +' Select Delcount,Jcount_old,Jcount_new,Bcount From DLI010'
         +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      CDS.Edit;
      CDS.FieldByName('Delcount').AsFloat:=tmpCDS.Fields[0].AsFloat;
      CDS.FieldByName('Jcount_old').AsFloat:=tmpCDS.Fields[1].AsFloat;
      CDS.FieldByName('Jcount_new').AsFloat:=tmpCDS.Fields[2].AsFloat;
      CDS.FieldByName('Bcount').AsFloat:=tmpCDS.Fields[3].AsFloat;
      CDS.Post;
      CDS.MergeChangeLog;
    finally
      FreeAndNil(tmpCDS);
    end;
    ShowMsg('刪除完畢!', 64);
    Result:=True;
  end;
end;

end.
 