unit unDLIR120_ConfDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, Menus, ImgList, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, ToolWin, DB, DBClient, StrUtils, Math, DateUtils,
  Grids, Calendar, Spin, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP;

type
  TFrmDLIR120_ConfDetail = class(TFrmSTDI050)
    ToolBar: TToolBar;
    DBGridEh2: TDBGridEh;
    DBGridEh1: TDBGridEh;
    DS1: TDataSource;
    DS2: TDataSource;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    btn_export: TToolButton;
    btn_query: TToolButton;
    btn_print: TToolButton;
    btn1: TToolButton;
    btn2: TToolButton;
    btn3: TToolButton;
    btn4: TToolButton;
    btn5: TToolButton;
    btn_email: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    TabSheet2: TTabSheet;
    Monday: TLabel;
    Tuesday: TLabel;
    Wednesday: TLabel;
    Thurday: TLabel;
    Friday: TLabel;
    Saturday: TLabel;
    Sunday: TLabel;
    Edit1: TEdit;
    Month: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    cbb: TComboBox;
    lblhint: TLabel;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    Timer1: TTimer;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure cbbChange(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn_emailClick(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    l_sql2:string;
    l_list2:TStrings;
    l_xlspath1,l_xlspath2:string;//l_xlspath1帶單價、金額附件;  l_xlspath2不帶單價、金額
    procedure SetHolidayText;
    procedure CalcAmt(Pno,Units:string;Amt:Double;var SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt:double);
    procedure CalcNW(Pno,Units:string;NW:Double;var SH_NW,RL_NW,CCLPN_NW,PPPN_NW:double);
    procedure GetCDS1_data(xFilter:string);
    procedure GetCDS2_data;
    function Toxls(isAmt,isEmail:Boolean):Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR120_ConfDetail: TFrmDLIR120_ConfDetail;

implementation

uses unGlobal, unCommon, unDLIR120_unit, unDLIR120_ConfXlsQuery, Comobj, ExcelXP;

{$R *.dfm}

procedure TFrmDLIR120_ConfDetail.CalcAmt(Pno,Units:string;Amt:Double;var SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt:double);
begin
  if SameText(Units, 'SH') then
     SH_Amt:=SH_Amt+Amt
  else if SameText(Units, 'RL') or SameText(Units, 'ROL') then
     RL_Amt:=RL_Amt+Amt
  else if SameText(Units, 'PN') and (Pos(LeftStr(Pno,1), 'ET')>0) then
     CCLPN_Amt:=CCLPN_Amt+Amt
  else if SameText(Units, 'PN') and (Pos(LeftStr(Pno,1), 'MN')>0) then
     PPPN_Amt:=PPPN_Amt+Amt;
end;

procedure TFrmDLIR120_ConfDetail.CalcNW(Pno,Units:string;NW:Double;var SH_NW,RL_NW,CCLPN_NW,PPPN_NW:double);
begin
  if SameText(Units, 'SH') then
     SH_NW:=SH_NW+NW
  else if SameText(Units, 'RL') or SameText(Units, 'ROL') then
     RL_NW:=RL_NW+NW
  else if SameText(Units, 'PN') and (Pos(LeftStr(Pno,1), 'ET')>0) then
     CCLPN_NW:=CCLPN_NW+NW
  else if SameText(Units, 'PN') and (Pos(LeftStr(Pno,1), 'MN')>0) then
     PPPN_NW:=PPPN_NW+NW;
end;

procedure TFrmDLIR120_ConfDetail.GetCDS1_data(xFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select *,isnull(cclpnlqty,0)+isnull(pppnlqty,0) as pnlqty From DLI018'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)+xFilter
         +' Order By Cdate Desc,Custno,Cname';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS1.Data:=Data;
    if CDS1.IsEmpty then
       GetCDS2_data;
  end;
end;

procedure TFrmDLIR120_ConfDetail.GetCDS2_data;
var
  tmpSQL:string;
begin
  tmpSQL:='Select * From DLI019 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' Order By kw,kb';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLIR120_ConfDetail.SetHolidayText;
var
  i,week,lstday,v1:Integer;
  y,m,y1,y2,m1,m2:word;
  tmpSQL:String;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:=Cbb.Items.Strings[cbb.ItemIndex];
  y:=StrToInt(LeftStr(tmpSQL,4));
  m:=StrToInt(RightStr(tmpSQL,2));
  if m=1 then
  begin
    y1:=y-1;
    m1:=12;
    y2:=y;
    m2:=3;
  end else
  begin
    y1:=y;
    m1:=m-1;
    if m=11 then
    begin
      y2:=y+1;
      m2:=1;
    end
    else if m=12 then
    begin
      y2:=y+1;
      m2:=2;
    end else
    begin
      y2:=y;
      m2:=m+2;
    end;
  end;

  tmpSQL:='Select Cdate From DLI023 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Cdate Between '+Quotedstr(DateToStr(Encodedate(y1,m1,1)))
         +' And '+Quotedstr(DateToStr(Encodedate(y2,m2,1)));
  if not QueryBySQL(tmpSQL,Data) then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;

    //初始化
    for i:=1 to 42 do
    begin
      with TEdit(Self.FindComponent('Edit'+IntToStr(i))) do
      begin
        Tag:=0;
        if not (i in [6,7,13,14,20,21,27,28,34,35,41,42]) then
           Color:=clWindow;
      end;
    end;

    //當月
    v1:=0;
    y1:=y;
    m1:=m;
    week:=DayOfTheWeek(Encodedate(y,m,1));                //1號星期几:edit1~edit7
    lstday:=DayOf(EndOfTheMonth(Encodedate(y,m,1)));      //當月天數
    for i:=1 to lstday do
    begin
      v1:=week+i-1;
      with TEdit(Self.FindComponent('Edit'+IntToStr(v1))) do
      begin
        Text:=IntToStr(i);
        Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));   //tag:年月
        if tmpCDS.Locate('cdate',EncodeDate(y1,m1,i),[]) then
           Color:=clYellow;
      end;
    end;

    //1號不是星期1:補上個月
    if week>1 then
    begin
      //tag:年月
      if m=1 then
      begin
        y1:=y-1;
        m1:=12;
        lstday:=31;
      end else
      begin
        y1:=y;
        m1:=m-1;
        lstday:=DayOf(EndOfTheMonth(Encodedate(y,m-1,1)));
      end;

      while week>1 do
      begin
        Dec(week);
        with TEdit(Self.FindComponent('Edit'+IntToStr(week))) do
        begin
          Text:=IntToStr(lstday);
          Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));
          if tmpCDS.Locate('cdate',EncodeDate(y1,m1,lstday),[]) then
             Color:=clYellow
          else if not (week in [6,7]) then
             Color:=clSilver;
        end;
        Dec(lstday);
      end;
    end;

    //補下個月

    //tag:年月
    if m=12 then
    begin
      y1:=y+1;
      m1:=1;
    end else
    begin
      y1:=y;
      m1:=m+1;
    end;

    week:=1;
    v1:=v1+1;
    for i:=v1 to 42 do          //42個edit
    begin
      with TEdit(Self.FindComponent('Edit'+IntToStr(i))) do
      begin
        Text:=IntToStr(week);
        Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));
        if tmpCDS.Locate('cdate',EncodeDate(y1,m1,week),[]) then
           Color:=clYellow
        else if not (i in [34,35,41,42]) then
           Color:=clSilver;
      end;
      Inc(week);
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLIR120_ConfDetail.FormCreate(Sender: TObject);
var
  tmpStr:string;
  i,y,m:Integer;
begin
  inherited;
  lblhint.Caption:=CheckLang('雙擊欄位改變顏色,[黃色]表示發送Email附帶excel檔案');

  i:=1;
  y:=YearOf(Date);
  m:=MonthOf(Date);
  cbb.Items.Clear;
  cbb.Items.Add(IntToStr(y)+RightStr('0'+IntToStr(m),2));
  while i<4 do
  begin
    m:=m+1;
    if m=13 then
    begin
      y:=y+1;
      m:=1;
    end;
    cbb.Items.Add(IntToStr(y)+RightStr('0'+IntToStr(m),2));
    Inc(i);
  end;
  cbb.ItemIndex:=0;
  SetHolidayText;

  if not g_MInfo^.R_rptDesign then
  begin
    DBGridEh2.FieldColumns['price'].Visible:=False;
    DBGridEh2.FieldColumns['amt'].Visible:=False;
  end;

  SetGrdCaption(DBGridEh1, 'DLI018');
  SetGrdCaption(DBGridEh2, 'DLI019');

  tmpStr:=FormatDateTime(g_cLongTime, Now);
  l_xlspath1:=g_UInfo^.TempPath+tmpStr+'A.xlsx';
  l_xlspath2:=g_UInfo^.TempPath+tmpStr+'B.xlsx';

  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmDLIR120_ConfDetail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmDLIR120_ConfDetail.FormShow(Sender: TObject);
begin
  inherited;
  GetCDS1_data(' And Cdate='+Quotedstr(DateToStr(Date)));
end;

procedure TFrmDLIR120_ConfDetail.CDS1AfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetCDS2_data;
end;

procedure TFrmDLIR120_ConfDetail.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  if GetQueryString('DLI018', tmpStr) then
  if Length(tmpStr)=0 then
     GetCDS1_data(' and cdate>=getdate()-180')
  else
     GetCDS1_data(tmpStr);
end;

procedure TFrmDLIR120_ConfDetail.btn_exportClick(Sender: TObject);
begin
  inherited;
  Toxls(g_MInfo^.R_rptDesign, False);
end;

procedure TFrmDLIR120_ConfDetail.btn1Click(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if not Assigned(FrmDLIR120_ConfXlsQuery) then
     FrmDLIR120_ConfXlsQuery:=TFrmDLIR120_ConfXlsQuery.Create(Application);
  if FrmDLIR120_ConfXlsQuery.ShowModal=mrOK then
  begin
    tmpSQL:='Select B.* From DLI018 A, DLI019 B Where A.Bu=B.Bu And A.Dno=B.Dno'
           +' And A.Bu='+Quotedstr(g_UInfo^.BU)
           +' And A.CDate Between '+Quotedstr(DateToStr(FrmDLIR120_ConfXlsQuery.Dtp1.Date))
           +' And '+Quotedstr(DateToStr(FrmDLIR120_ConfXlsQuery.Dtp2.Date))
           +' And charindex(B.Custno,'+Quotedstr(FrmDLIR120_ConfXlsQuery.Edit1.Text)+')>0'
           +' Order By B.Dno,B.Custno,B.KW,B.KB';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not g_MInfo^.R_rptDesign then
      with tmpCDS do
      begin
        while not Eof do
        begin
          Edit;
          FieldByName('price').Clear;
          FieldByName('amt').Clear;
          Post;
          Next;
        end;
        if ChangeCount>0 then
           MergeChangeLog;
      end;
      GetExportXls(tmpCDS, 'DLI019');
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLIR120_ConfDetail.btn_printClick(Sender: TObject);
var
  totGW,totTare,SH_NW,RL_NW,CCLPN_NW,PPPN_NW,SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt:Double;
  tmpRecno,kw,kb,kbRowid,kwRowid,cclkb,ppkb:Integer;
  tmpCDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;

  while not g_CDS.IsEmpty do
     g_CDS.Delete;
  if g_CDS.ChangeCount>0 then
     g_CDS.MergeChangeLog;

  totGW:=0;
  totTare:=0;
  SH_Amt:=0;
  RL_Amt:=0;
  CCLPN_Amt:=0;
  PPPN_Amt:=0;
  SH_NW:=0;
  RL_NW:=0;
  CCLPN_NW:=0;
  PPPN_NW:=0;
  kw:=-9999;
  kb:=-9999;
  cclkb:=0;
  ppkb:=0;
  tmpRecno:=CDS2.RecNo;
  CDS2.DisableControls;
  CDS2.First;
  kbRowid:=CDS2.RecNo;
  kwRowid:=kbRowid;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS2.Data;
    while not CDS2.Eof do
    begin
      tmpCDS.RecNo:=CDS2.RecNo;

      if kw<>CDS2.FieldByName('kw').AsInteger then
      begin
        totGW:=totGW+CDS2.FieldByName('GW').AsFloat;
        totTare:=totTare+CDS2.FieldByName('Tare').AsFloat;
        if Pos(LeftStr(CDS2.FieldByName('Pno').AsString,1),'ET')>0 then
           Inc(cclkb)
        else
           Inc(ppkb);
      end;

      tmpCDS.Edit;
      tmpCDS.FieldByName('Iuser').AsString:='1';   //報表中kb合並項高度倍數
      tmpCDS.FieldByName('Muser').AsString:='1';   //報表中kw合並項高度倍數
      if not g_MInfo^.R_rptDesign then
      begin
        tmpCDS.FieldByName('Price').Clear;
        tmpCDS.FieldByName('Amt').Clear;
      end else
      begin
        tmpCDS.FieldByName('amt').AsFloat:=RoundTo(tmpCDS.FieldByName('amt').AsFloat,-2);
        CalcAmt(tmpCDS.FieldByName('Pno').AsString,tmpCDS.FieldByName('Units').AsString,tmpCDS.FieldByName('amt').AsFloat,SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt);
      end;
      CalcNW(tmpCDS.FieldByName('Pno').AsString,tmpCDS.FieldByName('Units').AsString,tmpCDS.FieldByName('nw').AsFloat,SH_NW,RL_NW,CCLPN_NW,PPPN_NW);
      tmpCDS.Post;
      if (CDS2.RecNo -1) mod 25 =0 then            //特別注意:報表每頁打印行數改變,此值需改變,當前每頁25筆
      begin
        kw:=-9999;
        kb:=-9999;
      end;

      if kb=CDS2.FieldByName('kb').AsInteger then  //kb值相同合並
      begin
        tmpCDS.RecNo:=kbRowid;
        tmpCDS.Edit;
        tmpCDS.FieldByName('Iuser').AsString:=IntToStr(StrToInt(tmpCDS.FieldByName('Iuser').AsString)+1);
        tmpCDS.Post;
        tmpCDS.RecNo:=CDS2.RecNo;
        tmpCDS.Edit;
        tmpCDS.FieldByName('kb').Clear;
        tmpCDS.Post;
      end else
        kbRowid:=CDS2.RecNo;

      if kw=CDS2.FieldByName('kw').AsInteger then  //kw值相同合並
      begin
        tmpCDS.RecNo:=kwRowid;
        tmpCDS.Edit;
        tmpCDS.FieldByName('Muser').AsString:=IntToStr(StrToInt(tmpCDS.FieldByName('Muser').AsString)+1);
        tmpCDS.Post;
        tmpCDS.RecNo:=CDS2.RecNo;
        tmpCDS.Edit;
        tmpCDS.FieldByName('kw').Clear;
        tmpCDS.Post;
      end else
        kwRowid:=CDS2.RecNo;

      kw:=CDS2.FieldByName('kw').AsInteger;
      kb:=CDS2.FieldByName('kb').AsInteger;
      CDS2.Next;
    end;

    if tmpCDS.ChangeCount>0 then
       tmpCDS.MergeChangeLog;
    tmpCDS.RecNo:=tmpRecno;
    CDS2.RecNo:=tmpRecno;

    g_CDS.Append;
    g_CDS.FieldByName('CCLKB').AsFloat:=cclkb;
    g_CDS.FieldByName('PPKB').AsFloat:=ppkb;
    g_CDS.FieldByName('TotKB').AsFloat:=cclkb+ppkb;
    g_CDS.FieldByName('TotGW').AsFloat:=totGW;
    g_CDS.FieldByName('TotTare').AsFloat:=totTare;
    g_CDS.FieldByName('SH_Amt').AsFloat:=RoundTo(SH_Amt,-6);
    g_CDS.FieldByName('RL_Amt').AsFloat:=RoundTo(RL_Amt,-6);
    g_CDS.FieldByName('CCLPN_Amt').AsFloat:=RoundTo(CCLPN_Amt,-6);
    g_CDS.FieldByName('PPPN_Amt').AsFloat:=RoundTo(PPPN_Amt,-6);
    g_CDS.FieldByName('TotAmt').AsFloat:=RoundTo(SH_Amt+RL_Amt+CCLPN_Amt+PPPN_Amt,-6);
    g_CDS.FieldByName('SH_NW').AsFloat:=RoundTo(SH_NW,-6);
    g_CDS.FieldByName('RL_NW').AsFloat:=RoundTo(RL_NW,-6);
    g_CDS.FieldByName('CCLPN_NW').AsFloat:=RoundTo(CCLPN_NW,-6);
    g_CDS.FieldByName('PPPN_NW').AsFloat:=RoundTo(PPPN_NW,-6);
    g_CDS.Post;
    g_CDS.MergeChangeLog;

    SetLength(ArrPrintData, 3);
    ArrPrintData[0].Data:=CDS1.Data;
    ArrPrintData[0].RecNo:=CDS1.RecNo;
    ArrPrintData[0].IndexFieldNames:=CDS1.IndexFieldNames;
    ArrPrintData[0].Filter:=CDS1.Filter;

    ArrPrintData[1].Data:=tmpCDS.Data;
    ArrPrintData[1].RecNo:=tmpCDS.RecNo;
    ArrPrintData[1].IndexFieldNames:=tmpCDS.IndexFieldNames;
    ArrPrintData[1].Filter:=tmpCDS.Filter;

    ArrPrintData[2].Data:=g_CDS.Data;
    ArrPrintData[2].RecNo:=g_CDS.RecNo;
    ArrPrintData[2].IndexFieldNames:=g_CDS.IndexFieldNames;
    ArrPrintData[2].Filter:=g_CDS.Filter;
    GetPrintObj('DLI', ArrPrintData);
    ArrPrintData:=nil;

  finally
    CDS2.EnableControls;
    FreeAndNil(tmpCDS);
  end;
end;

function TFrmDLIR120_ConfDetail.Toxls(isAmt,isEmail:Boolean):Boolean;
const ext='.xlsx';
var
  xlsPath:string;
  amt,totNW,totGW,totTare,SH_NW,RL_NW,CCLPN_NW,PPPN_NW,SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt:Double;
  r,r1,kw,cclkb,ppkb:Integer;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  inherited;
  Result:=False;

  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;
  if (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;

  if g_UInfo^.isCN then
     xlsPath:=ExtractFilePath(Application.Exename)+'Temp\傖こ堤億ь等'
  else
     xlsPath:=ExtractFilePath(Application.Exename)+'Temp\成品出貨清單';
  if not FileExists(xlsPath+ext) then
  begin
    ShowMsg('[Temp\成品出貨清單.xlsx]文件不存在',48);
    Exit;
  end;

  try
    ExcelApp := CreateOleObject('Excel.Application');
  except
    ShowMsg('建立Excel.Application失敗',48);
    Exit;
  end;

  r:=5; //excel第5行開始寫入數據
  r1:=5;
  totGW:=0;
  totTare:=0;
  SH_Amt:=0;
  RL_Amt:=0;
  CCLPN_Amt:=0;
  PPPN_Amt:=0;
  SH_NW:=0;
  RL_NW:=0;
  CCLPN_NW:=0;
  PPPN_NW:=0;
  kw:=-9999;
  cclkb:=0;
  ppkb:=0;
  g_ProgressBar.Position:=0;
  g_ProgressBar.Visible:=True;
  ExcelApp.DisplayAlerts:=False;
  ExcelApp.WorkBooks.Open(xlsPath+ext);
  ExcelApp.WorkSheets[1].Activate;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    ExcelApp.Columns[3].NumberFormat:='@';
    ExcelApp.Columns[4].NumberFormat:='@';
    ExcelApp.Columns[5].NumberFormat:='@';
    ExcelApp.Columns[6].NumberFormat:='@';
    ExcelApp.Columns[13].NumberFormat:='@';
    ExcelApp.Columns[14].NumberFormat:='@';
    ExcelApp.Columns[22].NumberFormat:='@';
    ExcelApp.Columns[24].NumberFormat:='@';
    ExcelApp.Columns[25].NumberFormat:='@';
    ExcelApp.Columns[26].NumberFormat:='@';
    ExcelApp.Columns[27].NumberFormat:='@';
    ExcelApp.Columns[28].NumberFormat:='@';
    tmpCDS.Data:=CDS2.Data;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    while not tmpCDS.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,1].Value:=tmpCDS.FieldByName('kw').Value;
      ExcelApp.Cells[r,2].Value:=tmpCDS.FieldByName('kb').Value;
      ExcelApp.Cells[r,3].Value:=tmpCDS.FieldByName('saleno').Value;
      ExcelApp.Cells[r,4].Value:=tmpCDS.FieldByName('pno').Value;
      ExcelApp.Cells[r,5].Value:=tmpCDS.FieldByName('pname').Value;
      ExcelApp.Cells[r,6].Value:=tmpCDS.FieldByName('sizes').Value;
      ExcelApp.Cells[r,7].Value:=tmpCDS.FieldByName('longitude').Value;
      ExcelApp.Cells[r,8].Value:=tmpCDS.FieldByName('latitude').Value;
      ExcelApp.Cells[r,9].Value:=tmpCDS.FieldByName('thickness').Value;
      ExcelApp.Cells[r,10].Value:=tmpCDS.FieldByName('totsf1').Value;
      ExcelApp.Cells[r,11].Value:=tmpCDS.FieldByName('gsf').Value;
      ExcelApp.Cells[r,12].Value:=tmpCDS.FieldByName('qty').Value;
      ExcelApp.Cells[r,13].Value:=tmpCDS.FieldByName('units').Value;
      ExcelApp.Cells[r,14].Value:=tmpCDS.FieldByName('cashtype').Value;
      if isAmt then
      begin
        ExcelApp.Cells[r,15].Value:=tmpCDS.FieldByName('price').Value;
        amt:=RoundTo(tmpCDS.FieldByName('amt').AsFloat,-2);
        ExcelApp.Cells[r,16].Value:=amt;
      end else
        amt:=0;
      ExcelApp.Cells[r,17].Value:=tmpCDS.FieldByName('kg').Value;
      ExcelApp.Cells[r,18].Value:=tmpCDS.FieldByName('nw').Value;
      ExcelApp.Cells[r,19].Value:=tmpCDS.FieldByName('totnw').Value;
      ExcelApp.Cells[r,20].Value:=tmpCDS.FieldByName('gw').Value;
      ExcelApp.Cells[r,21].Value:=tmpCDS.FieldByName('tare').Value;
      ExcelApp.Cells[r,22].Value:=tmpCDS.FieldByName('orderno').Value;
      ExcelApp.Cells[r,23].Value:=tmpCDS.FieldByName('orderitem').Value;
      ExcelApp.Cells[r,24].Value:=tmpCDS.FieldByName('custorderno').Value;
      ExcelApp.Cells[r,25].Value:=tmpCDS.FieldByName('custprono').Value;
      ExcelApp.Cells[r,26].Value:=tmpCDS.FieldByName('custname').AsString;
      ExcelApp.Cells[r,27].Value:=tmpCDS.FieldByName('remark').AsString;
      ExcelApp.Cells[r,28].Value:=tmpCDS.FieldByName('zcremark').AsString;

      if kw<>tmpCDS.FieldByName('kw').AsInteger then
      begin
        totGW:=totGW+tmpCDS.FieldByName('gw').AsFloat;
        totTare:=totTare+tmpCDS.FieldByName('tare').AsFloat;
        if Pos(LeftStr(tmpCDS.FieldByName('pno').AsString,1),'ET')>0 then
           Inc(cclkb)
        else
           Inc(ppkb);
      end;
      totNW:=totNW+tmpCDS.FieldByName('nw').AsFloat;

      CalcAmt(tmpCDS.FieldByName('pno').AsString,tmpCDS.FieldByName('units').AsString,amt,SH_Amt,RL_Amt,CCLPN_Amt,PPPN_Amt);
      CalcNW(tmpCDS.FieldByName('pno').AsString,tmpCDS.FieldByName('units').AsString,tmpCDS.FieldByName('nw').AsFloat,SH_NW,RL_NW,CCLPN_NW,PPPN_NW);
      Inc(r);
      kw:=tmpCDS.FieldByName('kw').AsInteger;
      tmpCDS.Next;

      //卡位不同合並單元格
      if tmpCDS.Eof or (kw<>tmpCDS.FieldByName('kw').AsInteger) then
      begin
        ExcelApp.Range['A'+IntToStr(r1)+':A'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
        ExcelApp.Range['S'+IntToStr(r1)+':S'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
        ExcelApp.Range['T'+IntToStr(r1)+':T'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
        ExcelApp.Range['U'+IntToStr(r1)+':U'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
        r1:=r;
      end;
    end;

    if g_UInfo^.isCN then
    begin
      ExcelApp.Cells[2,4].Value:='諦誧靡備ㄩ'+CDS1.FieldByName('custshort').AsString;
      if SameText(g_UInfo^.BU,'ITEQDG') then
         ExcelApp.Cells[3,4].Value:='鼎茼妀ㄩ陲搛薊簿萇赽褪撮衄癹鼠侗'
      else
         ExcelApp.Cells[3,4].Value:='鼎茼妀ㄩ嫘笣薊簿萇赽褪撮衄癹鼠侗';
      ExcelApp.Cells[3,26].Value:='堤億�梪琭�'+FormatDateTime(g_cShortDate,CDS1.FieldByName('cdate').AsDateTime);
    end else
    begin
      ExcelApp.Cells[2,4].Value:='客戶名稱：'+CDS1.FieldByName('custshort').Value;
      if SameText(g_UInfo^.BU,'ITEQDG') then
         ExcelApp.Cells[3,4].Value:='供應商：東莞聯茂電子科技有限公司'
      else
         ExcelApp.Cells[3,4].Value:='供應商：廣州聯茂電子科技有限公司';
      ExcelApp.Cells[3,26].Value:='出貨日期：'+FormatDateTime(g_cShortDate,CDS1.FieldByName('cdate').AsDateTime);
    end;

    //合並單元格
    ExcelApp.Range['A'+IntToStr(r)+':I'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['J'+IntToStr(r)+':K'+IntToStr(r)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['J'+IntToStr(r+1)+':K'+IntToStr(r+1)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['J'+IntToStr(r+2)+':K'+IntToStr(r+2)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['J'+IntToStr(r+3)+':K'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['N'+IntToStr(r)+':O'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['Q'+IntToStr(r)+':Q'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['S'+IntToStr(r)+':S'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['T'+IntToStr(r)+':T'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['U'+IntToStr(r)+':U'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['V'+IntToStr(r)+':W'+IntToStr(r)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['V'+IntToStr(r+1)+':W'+IntToStr(r+1)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['V'+IntToStr(r+2)+':W'+IntToStr(r+2)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['V'+IntToStr(r+3)+':W'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['X'+IntToStr(r)+':Y'+IntToStr(r)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['X'+IntToStr(r+1)+':Y'+IntToStr(r+1)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['X'+IntToStr(r+2)+':Y'+IntToStr(r+2)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['X'+IntToStr(r+3)+':Y'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;
    ExcelApp.Range['Z'+IntToStr(r)+':AB'+IntToStr(r+3)].Select;
    ExcelApp.Selection.Merge;

    //居中
    ExcelApp.Range['A5:B'+IntToStr(r-1)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Range['M5:N'+IntToStr(r-1)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Range['W5:W'+IntToStr(r-1)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Range['A'+IntToStr(r)+':I'+IntToStr(r+3)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Selection.VerticalAlignment:=xlcenter;
    ExcelApp.Range['J'+IntToStr(r)+':M'+IntToStr(r+3)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Selection.VerticalAlignment:=xlcenter;
    ExcelApp.Range['V'+IntToStr(r)+':W'+IntToStr(r+3)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Selection.VerticalAlignment:=xlcenter;
    ExcelApp.Range['X'+IntToStr(r)+':Y'+IntToStr(r+3)].Select;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.Selection.VerticalAlignment:=xlcenter;

    if g_UInfo^.isCN then
       ExcelApp.Cells[r,1].Value:='僕數'+IntToStr(cclkb+ppkb)+'縐啣ㄗ價啣ㄩ'+IntToStr(cclkb)+'縐啣ㄛPPㄩ'+IntToStr(ppkb)+'縐啣ㄘ'
    else
       ExcelApp.Cells[r,1].Value:='共計'+IntToStr(cclkb+ppkb)+'卡板（基板：'+IntToStr(cclkb)+'卡板，PP：'+IntToStr(ppkb)+'卡板）';

    ExcelApp.Cells[r,10].Value:='PP';
    ExcelApp.Cells[r,12].Value:=CDS1.FieldByName('ppqty').Value;
    ExcelApp.Cells[r,13].Value:='RL';
    ExcelApp.Cells[r,16].Value:=RL_Amt;
    ExcelApp.Cells[r,17].Value:=RoundTo(SH_Amt+RL_Amt+CCLPN_Amt+PPPN_Amt,-6);
    ExcelApp.Cells[r,18].Value:=RL_NW;
    ExcelApp.Cells[r,19].Value:=totNW;
    ExcelApp.Cells[r,20].Value:=totGW;
    ExcelApp.Cells[r,21].Value:=totTare;
    if g_UInfo^.isCN then
       ExcelApp.Cells[r,22].Value:='陬齪瘍'
    else
       ExcelApp.Cells[r,22].Value:='車牌號';
    ExcelApp.Cells[r,24].Value:=CDS1.FieldByName('carno').AsString;
    Inc(r);
    ExcelApp.Cells[r,10].Value:='PP';
    ExcelApp.Cells[r,12].Value:=CDS1.FieldByName('pppnlqty').Value;
    ExcelApp.Cells[r,13].Value:='PN';
    ExcelApp.Cells[r,16].Value:=PPPN_Amt;
    ExcelApp.Cells[r,18].Value:=PPPN_NW;
    if g_UInfo^.isCN then
       ExcelApp.Cells[r,22].Value:='萇趕'
    else
       ExcelApp.Cells[r,22].Value:='電話';
    ExcelApp.Cells[r,24].Value:=CDS1.FieldByName('tel').Value;
    Inc(r);
    ExcelApp.Cells[r,10].Value:='CCL';
    ExcelApp.Cells[r,12].Value:=CDS1.FieldByName('cclqty').Value;
    ExcelApp.Cells[r,13].Value:='SH';
    ExcelApp.Cells[r,16].Value:=SH_Amt;
    ExcelApp.Cells[r,18].Value:=SH_NW;
    if g_UInfo^.isCN then
       ExcelApp.Cells[r,22].Value:='侗儂俷靡'
    else
       ExcelApp.Cells[r,22].Value:='司機姓名';
    ExcelApp.Cells[r,24].Value:=CDS1.FieldByName('driver').AsString;
    Inc(r);
    ExcelApp.Cells[r,10].Value:='CCL';
    ExcelApp.Cells[r,12].Value:=CDS1.FieldByName('cclpnlqty').Value;
    ExcelApp.Cells[r,13].Value:='PN';
    ExcelApp.Cells[r,16].Value:=CCLPN_Amt;
    ExcelApp.Cells[r,18].Value:=CCLPN_NW;

    //框線
    ExcelApp.Range['A4:AB'+IntToStr(r)].Borders.LineStyle := xlContinuous;
    ExcelApp.Range['A4:AB'+IntToStr(r)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
    ExcelApp.Range['A4:AB'+IntToStr(r)].Borders[xlInsideVertical].Weight:=xlThin;
    ExcelApp.Range['A4:AB'+IntToStr(r)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
    ExcelApp.Range['A4:AB'+IntToStr(r)].Borders[xlInsideHorizontal].Weight:=xlThin;
    ExcelApp.Columns.EntireColumn.AutoFit;
    ExcelApp.Range['A5'].Select;
    if isEmail then
    begin
      ExcelApp.WorkSheets[1].SaveAs(l_xlspath1);
      if SameText(g_UInfo^.BU, 'ITEQDG') then      //東莞獨立再發送一份無金額附件
      begin
        for r1:=5 to r do
        begin
          ExcelApp.Cells[r1,15].Value:='';
          ExcelApp.Cells[r1,16].Value:='';
        end;
        ExcelApp.WorkSheets[1].SaveAs(l_xlspath2);
      end;
    end else
      ExcelApp.Visible:=True;

    Result:=True;
  finally
    FreeAndNil(tmpCDS);
    if isEmail then
       ExcelApp.Quit;
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmDLIR120_ConfDetail.Edit1DblClick(Sender: TObject);
var
  y,m,d:word;
  tmpSQL:String;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if not g_MInfo^.R_rptDesign then
  begin
    ShowMsg('對不起,你沒有權限進行更改!',48);
    Exit;
  end;

  with TEdit(Sender) do
  begin
    y:=StrToInt(LeftStr(IntToStr(Tag),4));
    m:=StrToInt(RightStr(IntToStr(Tag),2));
    d:=StrToInt(Text);
  end;

  tmpSQL:='Select * From DLI023 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Cdate='+Quotedstr(DateToStr(Encodedate(y,m,d)));
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      tmpCDS.Append;
      tmpCDS.FieldByName('Bu').AsString:=g_UInfo^.BU;
      tmpCDS.FieldByName('Cdate').AsDateTime:=Encodedate(y,m,d);
      tmpCDS.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      tmpCDS.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS.Post;
      if CDSPost(tmpCDS, 'DLI023') then
         TEdit(Sender).Color:=clYellow
      else if m=StrToInt(RightStr(cbb.Items[cbb.ItemIndex],2)) then
         TEdit(Sender).Color:=clWindow
      else
         TEdit(Sender).Color:=clSilver;
    end else
    begin
      tmpCDS.Delete;
      if CDSPost(tmpCDS, 'DLI023') then
      begin
        if m=StrToInt(RightStr(cbb.Items[cbb.ItemIndex],2)) then
           TEdit(Sender).Color:=clWindow
        else
           TEdit(Sender).Color:=clSilver;
      end else
         TEdit(Sender).Color:=clYellow;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLIR120_ConfDetail.cbbChange(Sender: TObject);
begin
  inherited;
  SetHolidayText;
end;

procedure TFrmDLIR120_ConfDetail.btn2Click(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;

  if (not SameText(g_UInfo^.Wk_no,'admin')) and (not SameText(g_UInfo^.UserId,'admin')) then
  if not SameText(CDS1.FieldByName('Iuser').AsString,g_UInfo^.Wk_no) then
  begin
    ShowMsg('對不起,你沒權限進行此操作,資料所有者['+CDS1.FieldByName('Iuser').AsString+']!',48);
    Exit;
  end;

  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,你沒權限進行此操作!',48);
    Exit;
  end;

  tmpSQL:='Select Top 1 Conf From DLI018 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' And Cdate='+Quotedstr(DateToStr(CDS1.FieldByName('Cdate').AsDateTime));
  if not QueryOneCR(tmpSQL, Data) then
     Exit;

  if VarToStr(Data)='Y' then
  begin
    if CDS1.FieldByName('Conf').AsString<>'Y' then
    begin
      CDS1.Edit;
      CDS1.FieldByName('Conf').AsString:='Y';
      CDS1.Post;
      CDS1.MergeChangeLog;
    end;
    ShowMsg('資料已審核,不可取消!',48);
    Exit;
  end;

  if ShowMsg('取消後不可恢複,確定取消嗎?',33)=IdCancel then
     Exit;

  tmpSQL:='Update DLI019 Set Flag=0 Where Bu='+QUotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +'Delete From DLI018 Where Bu='+QUotedstr(g_UInfo^.BU)
         +' And Cdate='+Quotedstr(DateToStr(CDS1.FieldByName('Cdate').AsDateTime))
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString);
  if not PostBySQL(tmpSQL) then
     Exit;

  CDS1.Delete;
  CDS1.MergeChangeLog;
  if CDS1.IsEmpty then
     CDS2.EmptyDataSet;
end;

procedure TFrmDLIR120_ConfDetail.btn_emailClick(Sender: TObject);
var
  isHoliday:Boolean;
  tmpSQL,tmpSubject,tmpBody:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;

  if (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  if ShowMsg('確定對第'+IntToStr(CDS1.RecNo)+'筆進行Email通知嗎?',33)=IdCancel then
     Exit;

  tmpSQL:='exec [dbo].[proc_DLIR120_MailAddr] '+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('proc_DLIR120_MailAddr未設定郵箱參數!',48);
      Exit;
    end;

    try
      IdSMTP1.Disconnect;
      IdSMTP1.Host:=tmpCDS.FieldByName('ip').AsString;
      IdSMTP1.Username:=tmpCDS.FieldByName('uid').AsString;
      IdSMTP1.Password:=tmpCDS.FieldByName('pw').AsString;
      idsmtp1.AuthenticationType:=atLogin;
      IdSMTP1.Connect;
      IdSMTP1.Authenticate;
    except
      on e:exception do
      begin
        ShowMsg('郵箱登入失敗:'+#13#10+e.Message,48);
        Exit;
      end;
    end;

    isHoliday:=DayOfTheWeek(Date) in [6,7];  //星期六、星期日
    if not isHoliday then
    begin
      Data:=null;
      tmpSQL:='Select Top 1 Bu From DLI023 Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Cdate='+Quotedstr(DateToStr(Date));
      if QueryOneCR(tmpSQL, Data) then
         isHoliday:=Length(VarToStr(Data))>0;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在導出excel,請稍候...');
    Application.ProcessMessages;
    if not Toxls(True,True) then
       g_StatusBar.Panels[0].Text:=CheckLang('導出excel失敗,請聯絡管理員')
    else begin
      g_StatusBar.Panels[0].Text:=CheckLang('正在發送Email,請稍候...');
      Application.ProcessMessages;

      tmpSubject:=CDS1.FieldByName('bu').AsString+'_'
                 +FormatDateTime('YYYYMMDD',CDS1.FieldByName('cdate').AsDateTime)+'_'
                 +CDS1.FieldByName('custno').AsString
                 +CDS1.FieldByName('custshort').AsString+'_成品出貨清單';

      tmpBody:='Dear ALL：'+#13#10
              +'    '+tmpSubject+'(檔案名稱：'+CDS1.FieldByName('cname').AsString+'，車牌號碼：'+CDS1.FieldByName('carno').AsString+')已建立完畢。'+#13#10
              +'詳細信息請進入ERP系統作業[成品出貨清單(DLIR120)]查看。'+#13#10#13#10
              +'本通知由系統自動發出，請勿回覆，若有疑問請聯絡相關人員，謝謝!'+#13#10
              +StringReplace(FormatDateTime('YYYY/MM/DD HH:NN:SS',Now),'-','/',[rfReplaceAll]);

      IdMessage1.MessageParts.Clear;
      IdMessage1.From.Address:=tmpCDS.FieldByName('fromaddr').AsString;               //發件人
      IdMessage1.Recipients.EMailAddresses:=tmpCDS.FieldByName('toaddr').AsString;    //收件人
      IdMessage1.Subject:=tmpSubject;                                                 //郵件主旨
      IdMessage1.Body.Text:=tmpBody;                                                  //郵件正文
      try
        IdSMTP1.Send(IdMessage1);
      except
        on e:exception do
        begin
          ShowMsg('1郵件發送失敗,請重試:'+#13#10+e.Message,48);
          Exit;
        end;
      end;

      //不帶金額附件
      if FileExists(l_xlspath2) and (Length(tmpCDS.FieldByName('toaddr_file').AsString)>0) then
      begin
        IdMessage1.MessageParts.Clear;
        TIdattachment.Create(IdMessage1.MessageParts,l_xlspath2);
        IdMessage1.From.Address:=tmpCDS.FieldByName('fromaddr').AsString;
        IdMessage1.Recipients.EMailAddresses:=tmpCDS.FieldByName('toaddr_file').AsString;
        IdMessage1.Subject:=tmpSubject;
        IdMessage1.Body.Text:=tmpBody;
        try
          IdSMTP1.Send(IdMessage1);
        except
          on e:exception do
          begin
            ShowMsg('2郵件發送失敗,請重試:'+#13#10+e.Message,48);
            Exit;
          end;
        end;
      end;

      //假期發送有單價,金額附件
      if isHoliday and FileExists(l_xlspath1) and (Length(tmpCDS.FieldByName('toaddr_amtfile').AsString)>0) then
      begin
        IdMessage1.MessageParts.Clear;
        TIdattachment.Create(IdMessage1.MessageParts,l_xlspath1);
        IdMessage1.From.Address:=tmpCDS.FieldByName('fromaddr').AsString;
        IdMessage1.Recipients.EMailAddresses:=tmpCDS.FieldByName('toaddr_amtfile').AsString;
        IdMessage1.Subject:=tmpSubject;
        IdMessage1.Body.Text:=tmpBody;
        try
          IdSMTP1.Send(IdMessage1);
        except
          on e:exception do
          begin
            ShowMsg('3郵件發送失敗,請重試:'+#13#10+e.Message,48);
            Exit;
          end;
        end;
      end;

      ShowMsg('發送Email通知完畢!',64);
    end;
    
  finally
    FreeAndNil(tmpCDS);
    if FileExists(l_xlspath1) then
       DeleteFile(l_xlspath1);
    if FileExists(l_xlspath2) then
       DeleteFile(l_xlspath2);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR120_ConfDetail.btn3Click(Sender: TObject);
var
  kg,nw:Double;
  len,kw,tmpDitem:Integer;
  tmpSQL,tmpPno,tmpDno:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  tmpDno:=CDS2.FieldByName('Dno').AsString;
  tmpDitem:=CDS2.FieldByName('Ditem').AsInteger;
  kw:=CDS2.FieldByName('kw').AsInteger;
  tmpPno:=CDS2.FieldByName('Pno').AsString;
  tmpSQL:='select ima18 from '+g_UInfo^.BU+'.ima_file where ima01='+Quotedstr(tmpPno);
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.RecordCount=0 then
    begin
      ShowMsg('此料號不存在!',48);
      Exit;
    end;

    len:=Length(tmpPno);
    tmpSQL:=Copy(tmpPno,1,1);
    if (Pos(tmpSQL,'MNET')>0) and (len<=12) then
       kg:=GetKG(CDS2.FieldByName('saleno').AsString,CDS2.FieldByName('saleitem').AsInteger,0)
    else if len=18 then
       kg:=tmpCDS.FieldByName('ima18').AsFloat*StrToInt(Copy(tmpPno,11,3))
    else
       kg:=tmpCDS.FieldByName('ima18').AsFloat;
    kg:=RoundTo(kg,-3);
    nw:=RoundTo(kg*CDS2.FieldByName('qty').AsFloat,-2);

    Data:=null;
    tmpSQL:=' declare @bu varchar(6)'
           +' declare @t table(fnw float,fgw float)'
           +' set @bu='+Quotedstr(g_UInfo^.BU)
           +' update dli019 set kg='+FloatToStr(kg)+',nw='+FloatToStr(nw)
           +' where bu=@bu and dno='+Quotedstr(tmpDno)
           +' and ditem='+IntToStr(tmpDitem)

           +' insert into @t select isnull(sum(nw),0) nw,isnull(min(gw),0) gw'
           +' from dli019 where bu=@bu and dno='+Quotedstr(tmpDno)
           +' and kw='+IntToStr(kw)

           +' update dli019 set totnw=fnw,tare=round(fgw-fnw,2)'
           +' from @t where bu=@bu and dno='+Quotedstr(tmpDno)
           +' and kw='+IntToStr(kw)

           +' select * from dli019 where bu=@bu and dno='+Quotedstr(tmpDno)
           +' order by kw,kb';
     if QueryBySQL(tmpSQL, Data) then
     begin
       CDS2.Data:=Data;
       ShowMsg('更新完畢!',64);
     end;  
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmDLIR120_ConfDetail.btn4Click(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  if not g_MInfo^.R_rptDesign then
  begin
    ShowMsg('對不起,你沒權限進行此操作!',48);
    Exit;
  end;

  tmpSQL:='Select Bu,Cdate,Dno,Conf From DLI018 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' And Cdate='+Quotedstr(DateToStr(CDS1.FieldByName('Cdate').AsDateTime));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if tmpCDS.RecordCount=0 then
      begin
        ShowMsg('此筆資料不存在,請確認!',48);
        Exit;
      end;

      if tmpCDS.FieldByName('Conf').AsString<>'Y' then
      begin
        if ShowMsg('確定[審核]嗎,審核後不可[取消確認]?',33)=IdCancel then
           Exit;
      end else
      if ShowMsg('確定[取消審核]嗎?',33)=IdCancel then
         Exit;

      tmpCDS.Edit;
      if tmpCDS.FieldByName('Conf').AsString<>'Y' then
         tmpCDS.FieldByName('Conf').AsString:='Y'
      else
         tmpCDS.FieldByName('Conf').AsString:='N';
      tmpCDS.Post;
      if CDSPost(tmpCDS, 'DLI018') then
      begin
        CDS1.Edit;
        CDS1.FieldByName('Conf').AsString:=tmpCDS.FieldByName('Conf').AsString;
        CDS1.Post;
        CDS1.MergeChangeLog;
        if CDS1.FieldByName('Conf').AsString='Y' then
           ShowMsg('審核完畢!',64)
        else
           ShowMsg('取消審核完畢!',64);
      end;
    finally
      tmpCDS.Free;
    end;
  end;
end;

procedure TFrmDLIR120_ConfDetail.btn5Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TFrmDLIR120_ConfDetail.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer1.Enabled:=False;
  try
    if l_List2.Count=0 then
       Exit;

    while l_List2.Count>1 do
      l_List2.Delete(l_List2.Count-1);

    tmpSQL:=l_List2.Strings[0];
    if tmpSQL=l_SQL2 then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
