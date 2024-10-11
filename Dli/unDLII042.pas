unit unDLII042;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, TWODbarcode, DateUtils;

type
  TFrmDLII042 = class(TFrmSTDI080)
    Label3: TLabel;
    Edit3: TEdit;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    l_Fm_image:PTIMAGESTRUCT;
    l_CDS:TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmDLII042: TFrmDLII042;

implementation

uses unGlobal, unCommon;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="Custno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="Pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="C_pno" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="C_orderno" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="C_sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="Sno" fieldtype="i4"/>'
           +'<FIELD attrname="Lot" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="PrdDate2" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="LstDate1" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="LstDate2" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="Qty" fieldtype="r8"/>'
           +'<FIELD attrname="Qrcode" fieldtype="string" WIDTH="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLII042.FormCreate(Sender: TObject);
begin
  p_TableName:='@';

  inherited;

  btn_export.Visible:=False;
  btn_query.Visible:=False;
  Label3.Caption:=CheckLang('工單號碼');
  Label1.Caption:=CheckLang('掃描記錄');
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);
  CMDDeleteFile(g_UInfo^.TempPath,'bmp');
  PtInitImage(@l_Fm_image);
end;

procedure TFrmDLII042.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  PtFreeImage(@l_Fm_image);
end;

procedure TFrmDLII042.btn_printClick(Sender: TObject);
var
  wono,tmpLot,tmpStr,tmpSQL:string;
  tmpDate:TDateTime;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  Data:OleVariant;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  wono:=UpperCase(Trim(Edit3.Text));

  if Length(wono)=0 then
  begin
    ShowMsg('請輸入工單號碼!',48);
    Edit3.SetFocus;
    Exit;
  end;

  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢工單資料...');
  Application.ProcessMessages;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select b.*,occ02 from('
           +' select a.*,oea04,oea10 from ('
           +' select sfb05,oeb01,oeb03,oeb04,oeb11,ta_oeb10'
           +' from '+g_UInfo^.BU+'.sfb_file,'+g_UInfo^.BU+'.oeb_file'
           +' where sfb22=oeb01 and sfb221=oeb03 and sfb01='+Quotedstr(wono)
           +') a,'+g_UInfo^.BU+'.oea_file where oea01=oeb01) b, occ_file where oea04=occ01';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE')  then
       Exit;

    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('無此工單資料!',48);
      Exit;
    end;

    if tmpCDS1.FieldByName('oeb04').AsString<>tmpCDS1.FieldByName('sfb05').AsString then
    begin
      ShowMsg('此工單料號與訂單料號不相同!',48);
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢掃描資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select sno,pno,lot,qty from dli042 where bu='+Quotedstr(g_UInfo^.BU)
           +' and wono='+Quotedstr(wono)
           +' order by sno';
    if not QueryBySQL(tmpSQL, Data)  then
       Exit;

    tmpCDS2.Data:=Data;
    if tmpCDS2.IsEmpty then
    begin
      ShowMsg('無此工單掃描資料!',48);
      Exit;
    end;

    tmpLot:='';
    Memo1.Clear;
    Memo1.Lines.BeginUpdate;
    try
      with tmpCDS2 do
      while not Eof do
      begin
        tmpLot:=tmpLot+','+Quotedstr(FieldByName('lot').AsString);
        Memo1.Lines.Add(FieldByName('pno').AsString+';'+FieldByName('lot').AsString+';'+FloatToStr(FieldByName('qty').AsFloat));

        Next;
      end;
    finally
      Memo1.Lines.EndUpdate;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在檢查批號是否重複...');
    Application.ProcessMessages;
    //檢查批號重復
    Delete(tmpLot,1,1);
    Data:=null;
    tmpSQL:='select wono,lot from dli042 where bu='+Quotedstr(g_UInfo^.BU)
           +' and wono='+Quotedstr(wono)
           +' group by wono,lot having count(*)>1'
           +' union all'
           +' select distinct wono,lot from dli042 where bu='+Quotedstr(g_UInfo^.BU)
           +' and wono<>'+Quotedstr(wono)
           +' and lot in ('+tmpLot+')';
    if not QueryBySQL(tmpSQL, Data)  then
       Exit;

    tmpCDS3.Data:=Data;
    if not tmpCDS3.IsEmpty then
    begin
      tmpLot:='';
      while not tmpCDS3.Eof do
      begin
        tmpLot:=tmpLot+#13#10+tmpCDS3.FieldByName('lot').AsString+'->'+tmpCDS3.FieldByName('wono').AsString;
        tmpCDS3.Next;
      end;

      ShowMsg('下列批號重複：'+tmpLot,48);
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在處理資料...');
    Application.ProcessMessages;
    l_CDS.EmptyDataSet;
    tmpCDS2.First;
    while not tmpCDS2.Eof do
    begin
      if Copy(tmpCDS2.FieldByName('pno').AsString,2,30)<>Copy(tmpCDS1.FieldByName('sfb05').AsString,2,30) then //忽略第1碼
      begin
        ShowMsg('第'+IntToStr(tmpCDS2.RecNo)+'筆掃描料號與工單料號不相同!',48);
        Exit;
      end;

      l_CDS.Append;
      l_CDS.FieldByName('Custno').AsString:=tmpCDS1.FieldByName('oea04').AsString;
      l_CDS.FieldByName('Custabs').AsString:=tmpCDS1.FieldByName('occ02').AsString;
      l_CDS.FieldByName('Pno').AsString:=tmpCDS2.FieldByName('pno').AsString;
      l_CDS.FieldByName('C_pno').AsString:=tmpCDS1.FieldByName('oeb11').AsString;
      l_CDS.FieldByName('C_orderno').AsString:=tmpCDS1.FieldByName('oea10').AsString;
      l_CDS.FieldByName('C_sizes').AsString:=tmpCDS1.FieldByName('ta_oeb10').AsString;
      l_CDS.FieldByName('Sno').AsInteger:=tmpCDS2.FieldByName('sno').AsInteger;
      l_CDS.FieldByName('Lot').AsString:=tmpCDS2.FieldByName('lot').AsString;
      l_CDS.FieldByName('Qty').AsFloat:=tmpCDS2.FieldByName('qty').AsFloat;

      //生產日期與有效期
      tmpDate:=GetLotDate(Copy(l_CDS.FieldByName('lot').AsString,2,4), Date);
      l_CDS.FieldByName('PrdDate1').AsString:=FormatDateTime('YYYYMMDD', tmpDate);
      l_CDS.FieldByName('PrdDate2').AsString:=StringReplace(FormatDateTime('YYYY-MM-DD', tmpDate),'/','-',[rfReplaceAll]);
      if Pos(LeftStr(l_CDS.FieldByName('Pno').AsString,1),'ET')=0 then
      begin
        if SameText(l_CDS.FieldByName('Custno').AsString, 'AC172') then
           l_CDS.FieldByName('LstDate2').AsString:=FormatDateTime('YYYY-MM-DD', tmpDate+90)
        else
           l_CDS.FieldByName('LstDate2').AsString:=FormatDateTime('YYYY-MM-DD', IncMonth(tmpDate,3)-1)
      end else
         l_CDS.FieldByName('LstDate2').AsString:=FormatDateTime('YYYY-MM-DD', IncYear(tmpDate,2)-1);
      l_CDS.FieldByName('LstDate2').AsString:=StringReplace(l_CDS.FieldByName('LstDate2').AsString,'/','-',[rfReplaceAll]);
      l_CDS.FieldByName('LstDate1').AsString:=StringReplace(l_CDS.FieldByName('LstDate2').AsString,'-','',[rfReplaceAll]);

      l_CDS.FieldByName('PrdDate1').AsString:=RightStr(l_CDS.FieldByName('PrdDate1').AsString,6);
      l_CDS.FieldByName('LstDate1').AsString:=RightStr(l_CDS.FieldByName('LstDate1').AsString,6);
    
      tmpSQL:=Char(30)+Char(29)+l_CDS.FieldByName('C_pno').AsString+Char(29)+'100660'+Char(29)+
              l_CDS.FieldByName('lot').AsString+Char(29)+
              l_CDS.FieldByName('PrdDate1').AsString+Char(29)+
              l_CDS.FieldByName('LstDate1').AsString+Char(29)+
              l_CDS.FieldByName('C_orderno').AsString+Char(29)+
              FloatToStr(l_CDS.FieldByName('Qty').AsFloat)+Char(29)+'0001'+Char(29)+' '+Char(29)+Char(04);
      tmpStr:=g_UInfo^.TempPath+wono+'_'+IntToStr(l_CDS.FieldByName('Sno').AsInteger)+'.bmp';
      if getcode(tmpSQL, tmpStr, l_Fm_image) then
         l_CDS.FieldByName('qrcode').AsString:=tmpStr;
      l_CDS.Post;

      tmpCDS2.Next;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    g_StatusBar.Panels[0].Text:='';
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData);
  ArrPrintData:=nil;
end;

end.
