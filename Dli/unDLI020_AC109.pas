unit unDLI020_AC109;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ExtCtrls, DB, DBClient, Mask, DBCtrls, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ImgList, Buttons, Math;

type
  TFrmDLII020_AC109 = class(TFrmSTDI051)
    Panel1: TPanel;
    Panel2: TPanel;
    lblsaleno: TLabel;
    Edit1: TEdit;
    btn_query: TBitBtn;
    DBGridEh1: TDBGridEh;
    Panel3: TPanel;
    DBEdit1: TDBEdit;
    oea10: TLabel;
    DBEdit2: TDBEdit;
    oeb11: TLabel;
    DBEdit3: TDBEdit;
    ta_oeb10: TLabel;
    DBEdit4: TDBEdit;
    ogb12: TLabel;
    DBEdit5: TDBEdit;
    sfqty: TLabel;
    DBEdit6: TDBEdit;
    ogb14t: TLabel;
    DS: TDataSource;
    CDS: TClientDataSet;
    ima18: TLabel;
    DBEdit7: TDBEdit;
    nw: TLabel;
    DBEdit8: TDBEdit;
    gw: TLabel;
    DBEdit9: TDBEdit;
    qty: TLabel;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    oea10_1: TLabel;
    DBEdit12: TDBEdit;
    oeb11_1: TLabel;
    DBEdit13: TDBEdit;
    ta_oeb10_1: TLabel;
    DBEdit14: TDBEdit;
    ogb12_1: TLabel;
    DBEdit15: TDBEdit;
    sfqty_1: TLabel;
    DBEdit16: TDBEdit;
    ogb14t_1: TLabel;
    ima18_1: TLabel;
    DBEdit17: TDBEdit;
    nw_1: TLabel;
    DBEdit18: TDBEdit;
    gw_1: TLabel;
    DBEdit19: TDBEdit;
    qty_1: TLabel;
    DBEdit20: TDBEdit;
    Bevel1: TBevel;
    lblsf1: TLabel;
    lblsf2: TLabel;
    lblsf3: TLabel;
    lblsf4: TLabel;
    DBEdit21: TDBEdit;
    pnlrate: TLabel;
    procedure btn_queryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    procedure Qty_1Change(Sender:TField);
    procedure ima18_1Change(Sender:TField);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_AC109: TFrmDLII020_AC109;

implementation

uses unGlobal, unCommon, unDLII020_const;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="oga01" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="oga02" fieldtype="datetime"/>'
           +'<FIELD attrname="oga04" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="occ02" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ogb03" fieldtype="i4"/>'
           +'<FIELD attrname="ogb04" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ima02" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="ima021" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="oea10" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="oeb11" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ta_oeb10" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="ogb12" fieldtype="r8"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="sfqty" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ogb14t" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ima18" fieldtype="r8"/>'
           +'<FIELD attrname="nw" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="gw" fieldtype="string" WIDTH="50"/>'

           +'<FIELD attrname="oea10_1" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="oeb11_1" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ta_oeb10_1" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="ogb12_1" fieldtype="r8"/>'
           +'<FIELD attrname="qty_1" fieldtype="r8"/>'
           +'<FIELD attrname="sfqty_1" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ogb14t_1" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ima18_1" fieldtype="r8"/>'
           +'<FIELD attrname="nw_1" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="gw_1" fieldtype="string" WIDTH="50"/>'

           +'<FIELD attrname="pnlrate" fieldtype="i4"/>'

           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

function GetSF(Pno:string):double;
var
  fstcode:string;
  len:Integer;
begin
  Result:=1;

  fstcode:=Copy(Pno,1,1);
  len:=Length(Pno);

  //CCL SH
  if ((fstcode='E') or (fstcode='T')) and (len=17) then
  begin              
    if pos('370490',Pno)>0 then
       Result:=12
    else
    if pos('410490',Pno)>0 then
       Result:=13.33        
    else
    if pos('430490',Pno)>0 then
       Result:=14    
    else
    if pos('740490',Pno)>0 then
       Result:=24    
    else
    if pos('820490',Pno)>0 then
       Result:=26.67          
    else
    if pos('860490',Pno)>0 then
       Result:=28      
    else
    if pos('405425',Pno)>0 then
       Result:=11.67
    else
    if pos('555425',Pno)>0 then
       Result:=15.75
    else
    if pos('555426',Pno)>0 then
       Result:=15.75;  
  end;
  
  //PP RL    
  if ((fstcode='B') or (fstcode='R')) and (len=18) then
  begin
    if (pos('150495',Pno)>0) or (pos('150498',Pno)>0) then
       Result:=1968
    else
    if (pos('200495',Pno)>0) or (pos('200498',Pno)>0) then
       Result:=2624
    else
    if (pos('300495',Pno)>0) or (pos('300498',Pno)>0) then
       Result:=3936;
  end;
end;

function ReplaceC_size(c_size:string):string;
begin
  Result:=StringReplace(Result,'43''''*49.3''''','42*48',[]);
  Result:=StringReplace(Result,'43*49.3','42*48',[]);

  if Pos('37''''*49.''''',c_size)=0 then
     Result:=StringReplace(c_size,'37''''*49''''','36*48',[]);
  if Pos('37*49.',c_size)=0 then
     Result:=StringReplace(Result,'37*49','36*48',[]);

  if Pos('41''''*49.''''',c_size)=0 then
     Result:=StringReplace(Result,'41''''*49''''','40*48',[]);
  if Pos('41*49.',c_size)=0 then
     Result:=StringReplace(Result,'41*49','40*48',[]);

  if Pos('43''''*49.''''',c_size)=0 then
     Result:=StringReplace(Result,'43''''*49''''','42*48',[]);
  if Pos('43*49.',c_size)=0 then
     Result:=StringReplace(Result,'43*49','42*48',[]);

  if Pos('74''''*49.',c_size)=0 then
     Result:=StringReplace(Result,'74''''*49''''','72*48',[]);
  if Pos('74*49.',c_size)=0 then
     Result:=StringReplace(Result,'74*49','72*48',[]);

  if Pos('82''''*49.',c_size)=0 then
     Result:=StringReplace(Result,'82''''*49''''','80*48',[]);
  if Pos('82*49.',c_size)=0 then
     Result:=StringReplace(Result,'82*49','80*48',[]);

  if Pos('86''''*49.',c_size)=0 then
     Result:=StringReplace(Result,'86''''*49''''','84*48',[]);
  if Pos('86*49.',c_size)=0 then
     Result:=StringReplace(Result,'86*49','84*48',[]);
end;

function FormatDeci(value:string; deci:Integer):string;
const zero='000000';
var
  pos1:Integer;
begin
  pos1:=pos('.',value);
  if pos1=0 then
     Result:=value+'.'+Copy(zero,1,deci)
  else
  begin
    pos1:=deci-(Length(value)-pos1);
    if pos1>0 then
       Result:=value+Copy(zero,1,pos1)
    else
       Result:=value;
  end;
end;

procedure TFrmDLII020_AC109.Qty_1Change(Sender:TField);
var
  x,v:Double;
begin
  x:=CDS.FieldByName('pnlrate').AsFloat;
  if x<=0 then
     x:=1;

  if SameText(CDS.FieldByName('oga04').AsString,'AC994') then //先4舍5入
     v:=RoundTo(CDS.FieldByName('ogb12_1').AsFloat*RoundTo(CDS.FieldByName('qty_1').AsFloat/x,-3),-2)
  else
     v:=RoundTo(CDS.FieldByName('ogb12_1').AsFloat*CDS.FieldByName('qty_1').AsFloat/x,-2);
  CDS.FieldByName('sfqty_1').AsString:=FormatDeci(FloatToStr(v),2);
end;

procedure TFrmDLII020_AC109.ima18_1Change(Sender:TField);
var
  v:Double;
begin
  v:=RoundTo(CDS.FieldByName('ogb12_1').AsFloat*CDS.FieldByName('ima18_1').AsFloat,-3);
  CDS.FieldByName('nw_1').AsString:=FormatDeci(FloatToStr(v),3);
  CDS.FieldByName('gw_1').AsString:=FormatDeci(FloatToStr(v+30),3);
end;

procedure TFrmDLII020_AC109.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,Self.Name);
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS,l_Xml);
  CDS.Data:=l_CDS.Data;
end;

procedure TFrmDLII020_AC109.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLII020_AC109.btn_queryClick(Sender: TObject);
var
  isPP:Boolean;
  i,n:Integer;
  v:Double;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(lblsaleno.Caption));
    Exit;
  end;

  tmpsql:='select m.*,ima02,ima021,ima18'
         +' from (select x.*,occ02'
         +' from (select c.*,oeb11,ta_oeb10'
         +' from (select a.*,oea10'
         +' from (select oga01,oga02,oga04,ogb03,ogb04,ogb12,ogb14,ogb14t,ogb31,ogb32'
         +' from '+g_UInfo^.BU+'.oga_file inner join '+g_UInfo^.BU+'.ogb_file'
         +' on oga01=ogb01 where oga01='+Quotedstr(Trim(Edit1.Text))+') a inner join '+g_UInfo^.BU+'.oea_file b'
         +' on ogb31=oea01) c inner join '+g_UInfo^.BU+'.oeb_file d'
         +' on ogb31=oeb01 and ogb32=oeb03) x left join '+g_UInfo^.BU+'.occ_file y'
         +' on oga04=occ01) m left join '+g_UInfo^.BU+'.ima_file n'
         +' on ogb04=ima01';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  l_CDS.EmptyDataSet;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;

    if Pos(tmpCDS.FieldByName('oga04').AsString,g_strHT+'/ACB16')=0 then
    begin
      ShowMsg('不是華通客戶!',48);
      Exit;
    end;

    while not tmpCDS.Eof do
    begin
      l_CDS.Append;
      for i:=0 to tmpCDS.FieldCount-1 do
      begin
        tmpSQL:=tmpCDS.Fields[i].FieldName;
        if l_CDS.FindField(tmpSQL)<>nil then
           l_CDS.FieldByName(tmpSQL).Value:=tmpCDS.Fields[i].Value;
        if l_CDS.FindField(tmpSQL+'_1')<>nil then
           l_CDS.FieldByName(tmpSQL+'_1').Value:=tmpCDS.Fields[i].Value;
      end;

      //小料號,重新計算單重
      tmpSQL:=Copy(l_CDS.FieldByName('ogb04').AsString,1,1);
      if (((tmpSQL='E') or (tmpSQL='T')) and (Length(l_CDS.FieldByName('ogb04').AsString)=11)) or
         (((tmpSQL='N') or (tmpSQL='M')) and (Length(l_CDS.FieldByName('ogb04').AsString)=12)) then
      begin
        v:=GetKG(l_CDS.FieldByName('ogb01').AsString ,l_CDS.FieldByName('ogb03').AsInteger, 0);
        l_CDS.FieldByName('ima18').AsFloat:=v;
        l_CDS.FieldByName('ima18_1').AsFloat:=v;
      end;

      //單重倍數
      if (Length(l_CDS.FieldByName('ogb04').AsString)=18) and
         (Pos(Copy(l_CDS.FieldByName('ogb04').AsString,1,1),'BR')>0) then
      begin
        isPP:=True;
        n:=StrToInt(Copy(l_CDS.FieldByName('ogb04').AsString,11,3))
      end else
      begin
        isPP:=False;
        n:=1;
      end;

      //替換客戶品名
      if isPP then
      begin
        tmpSQL:=Copy(l_CDS.FieldByName('ogb04').AsString,11,3)+'M*'+
                Copy(l_CDS.FieldByName('ogb04').AsString,14,2)+'.'+
                Copy(l_CDS.FieldByName('ogb04').AsString,16,1);
        if Pos(tmpSQL,l_CDS.FieldByName('ta_oeb10_1').AsString)>0 then
           l_CDS.FieldByName('ta_oeb10_1').AsString:=StringReplace(l_CDS.FieldByName('ta_oeb10_1').AsString,tmpSQL,
              Copy(l_CDS.FieldByName('ogb04').AsString,11,3)+'M*48',[]);
      end else
        l_CDS.FieldByName('ta_oeb10_1').AsString:=ReplaceC_size(l_CDS.FieldByName('ta_oeb10_1').AsString);

      l_CDS.FieldByName('ima18').AsFloat:=l_CDS.FieldByName('ima18').AsFloat*n;
      l_CDS.FieldByName('ima18_1').AsFloat:=l_CDS.FieldByName('ima18_1').AsFloat*n;
      l_CDS.FieldByName('qty').AsFloat:=GetSF(l_CDS.FieldByName('ogb04').AsString);
      l_CDS.FieldByName('qty_1').AsFloat:=l_CDS.FieldByName('qty').AsFloat;

      v:=RoundTo(l_CDS.FieldByName('ogb12').AsFloat*l_CDS.FieldByName('qty').AsFloat,-2);
      l_CDS.FieldByName('sfqty').AsString:=FormatDeci(FloatToStr(v),2);
      l_CDS.FieldByName('sfqty_1').AsString:=l_CDS.FieldByName('sfqty').AsString;

      v:=RoundTo(l_CDS.FieldByName('ogb12').AsFloat*l_CDS.FieldByName('ima18').AsFloat,-3);
      l_CDS.FieldByName('nw').AsString:=FormatDeci(FloatToStr(v),3);
      l_CDS.FieldByName('nw_1').AsString:=l_CDS.FieldByName('nw').AsString;
      v:=v+30;
      l_CDS.FieldByName('gw').AsString:=FormatDeci(FloatToStr(v),3);;
      l_CDS.FieldByName('gw_1').AsString:=l_CDS.FieldByName('gw').AsString;

      if SameText(Copy(l_CDS.FieldByName('oea10').AsString,1,1),'V') then 
      begin
        l_CDS.FieldByName('ogb14t').Clear;
        l_CDS.FieldByName('ogb14t_1').Clear;
      end else
      begin
        l_CDS.FieldByName('ogb14t').AsString:=FormatDeci(FloatToStr(RoundTo(l_CDS.FieldByName('ogb14t').AsFloat,-2)),2);
        l_CDS.FieldByName('ogb14t_1').AsString:=FormatDeci(FloatToStr(RoundTo(l_CDS.FieldByName('ogb14t_1').AsFloat,-2)),2);
      end;

      //清空小料號sf面積,需手動輸入轉換率再計算
      if Length(l_CDS.FieldByName('ogb04').AsString) in [11,12,19,20] then
      begin
        l_CDS.FieldByName('qty').Clear;
        l_CDS.FieldByName('sfqty').Clear;
        l_CDS.FieldByName('pnlrate').Clear;
        l_CDS.FieldByName('qty_1').Clear;
        l_CDS.FieldByName('sfqty_1').Clear;
      end;

      l_CDS.Post;
      tmpCDS.Next;
    end;

    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
    CDS.Data:=l_CDS.Data;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII020_AC109.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('ogb12_1').OnChange:=Qty_1Change;
  CDS.FieldByName('qty_1').OnChange:=Qty_1Change;
  CDS.FieldByName('pnlrate').OnChange:=Qty_1Change;
  CDS.FieldByName('ima18_1').OnChange:=ima18_1Change;
  CDS.FieldByName('nw_1').OnChange:=ima18_1Change;
  Panel3.Enabled:=not CDS.IsEmpty;
end;

procedure TFrmDLII020_AC109.btn_okClick(Sender: TObject);
var
  tmpCDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  if CDS.State in [dsInsert, dsEdit] then
     CDS.Post;

  if CDS.IsEmpty then
  begin
    ShowMsg('無資料可列印!',48);
    Exit;
  end;

  if CDS.State in [dsInsert, dsEdit] then
     CDS.Post;
  if CDS.ChangeCount>0 then
     CDS.MergeChangeLog;

  if Pos(CDS.FieldByName('oga04').AsString,g_strHT+'/ACB16')=0 then
  begin
    ShowMsg('不是華通客戶不可列印!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    while not tmpCDS.Eof do
    begin
      if (Length(tmpCDS.FieldByName('ogb04').AsString) in [11,12,19,20]) and
         (tmpCDS.FieldByName('pnlrate').AsInteger<=0) then
      begin
        ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆,[PNL轉換率]未輸入或輸入錯誤!',48);
        DBEdit21.SetFocus;
        Exit;
      end;

      if tmpCDS.FieldByName('qty_1').AsFloat<=0 then
      begin
        ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆,[%s]未輸入或輸入錯誤',48,myStringReplace(qty_1.Caption));
        DBEdit20.SetFocus;
        Exit;
      end;

      if Length(Trim(tmpCDS.FieldByName('sfqty_1').AsString))=0 then
      begin
        ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆,[%s]未輸入或輸入錯誤',48,myStringReplace(sfqty_1.Caption));
        DBEdit15.SetFocus;
        Exit;
      end;

      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  ShowMsg(CDS.FieldByName('oga04').AsString+CDS.FieldByName('occ02').AsString,64);

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS.Filter;
  GetPrintObj('DLI', ArrPrintData, 'DLII020_AC109');
  ArrPrintData:=nil;
end;

end.
