unit unReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Buttons, frxClass, frxPreview, ComCtrls, ToolWin, Menus,
  ImgList, frxDesgn, frxExportRTF, frxExportXLS, unFrmBaseEmpty, frxExportHTML,
  frxExportPDF, frxDBSet, frxExportText, frxExportTXT, frxBarcode, frxChBox,
  frxCross, frxRich, frxChart, frxOLE, comobj, DBClient, ExtCtrls, Mask,
  DBCtrlsEh, unDAL, frxExportBaseDialog;

type
  TFrmReport = class(TFrmBaseEmpty)
    ImgList1: TImageList;
    pmZooom: TPopupMenu;
    mi5001: TMenuItem;
    mi3001: TMenuItem;
    mi2001: TMenuItem;
    mi1501: TMenuItem;
    mi1251: TMenuItem;
    mi1001: TMenuItem;
    mi751: TMenuItem;
    mi501: TMenuItem;
    mi301: TMenuItem;
    mi201: TMenuItem;
    mi101: TMenuItem;
    ToolBar: TToolBar;
    btn_singlePage: TToolButton;
    btn_doublePages: TToolButton;
    btn_pageWidth: TToolButton;
    btn_zoom: TToolButton;
    ToolButton5: TToolButton;
    btn_firstPg: TToolButton;
    btn_priorPg: TToolButton;
    btn_nextPg: TToolButton;
    btn_lastPg: TToolButton;
    ToolButton10: TToolButton;
    btn_excel: TToolButton;
    btn_word: TToolButton;
    btn_pdf: TToolButton;
    btn_txt: TToolButton;
    btn_html: TToolButton;
    ToolButton16: TToolButton;
    btn_design: TToolButton;
    btn_print: TToolButton;
    ToolButton19: TToolButton;
    btn_quit: TToolButton;
    frxPreview1: TfrxPreview;
    frxDB1: TfrxDBDataSet;
    frxPDFExport1: TfrxPDFExport;
    frxHTMLExport1: TfrxHTMLExport;
    frxXLSExport1: TfrxXLSExport;
    frxRTFExport1: TfrxRTFExport;
    frxDesigner1: TfrxDesigner;
    frxTXTExport1: TfrxTXTExport;
    frxDB2: TfrxDBDataSet;
    frxDB3: TfrxDBDataSet;
    frxDB4: TfrxDBDataSet;
    frxDB5: TfrxDBDataSet;
    frxOLEObject1: TfrxOLEObject;
    frxRichObject1: TfrxRichObject;
    frxCrossObject1: TfrxCrossObject;
    frxCheckBoxObject1: TfrxCheckBoxObject;
    frxBarCodeObject1: TfrxBarCodeObject;
    frxChartObject1: TfrxChartObject;
    frxReport1: TfrxReport;
    frxDB6: TfrxDBDataSet;
    SaveDialog1: TSaveDialog;
    frxDB0: TfrxDBDataset;
    frxDB7: TfrxDBDataSet;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    CDS3: TClientDataSet;
    CDS4: TClientDataSet;
    CDS5: TClientDataSet;
    CDS6: TClientDataSet;
    CDS7: TClientDataSet;
    CDS0: TClientDataSet;
    ToolButton3: TToolButton;
    Panel1: TPanel;
    Cbb: TDBComboBoxEh;
    StatusBar1: TStatusBar;
    procedure btn_singlePageClick(Sender: TObject);
    procedure btn_doublePagesClick(Sender: TObject);
    procedure btn_pageWidthClick(Sender: TObject);
    procedure mi5001Click(Sender: TObject);
    procedure btn_firstPgClick(Sender: TObject);
    procedure btn_priorPgClick(Sender: TObject);
    procedure btn_nextPgClick(Sender: TObject);
    procedure btn_lastPgClick(Sender: TObject);
    procedure btn_excelClick(Sender: TObject);
    procedure btn_wordClick(Sender: TObject);
    procedure btn_pdfClick(Sender: TObject);
    procedure btn_txtClick(Sender: TObject);
    procedure btn_htmlClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure CbbChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function frxDesigner1SaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
    procedure m_designClick(Sender: TObject);
    procedure m_printClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    procedure SetCbb;
    procedure SetComp;
    procedure SetCDS(CDS: TClientDataSet; ArrIndex: Integer);
    function SetKG: Boolean;
    function SetPrnCnt: Boolean;
    function GetCOC_FileName: string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReport: TFrmReport;

implementation

uses
  unGlobal, unCommon, unDLI020_prnmark;

var
  isCOCPP: Boolean;
{$R *.dfm}

procedure TFrmReport.SetCbb;
var
  TmpSQL: string;
  Data: OleVariant;
begin
  Cbb.Items.BeginUpdate;
  try
    Cbb.Items.Clear;
    TmpSQL := 'Select ReportName,def From Sys_Report Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And ProcId=' + Quotedstr(g_MInfo^.ProcId) + ' Order By def desc,ReportName';
    if QueryBySQL(TmpSQL, Data) then
    begin
      CDS0.Data := Data;
      while not CDS0.Eof do
      begin
        Cbb.Items.Add(CDS0.Fields[0].AsString);
        CDS0.Next;
      end;
    end;
  finally
    Cbb.Items.EndUpdate;
  end;

  if Cbb.Items.Count > 0 then
    Cbb.ItemIndex := 0;
end;

procedure TFrmReport.SetComp;
var
  TmpSQL: string;
  Data: OleVariant;
begin
  TmpSQL := 'Select * From Sys_Bu Where Bu=' + Quotedstr(g_UInfo^.BU);
  if QueryBySQL(TmpSQL, Data) then
    CDS0.Data := Data;
end;

procedure TFrmReport.SetCDS(CDS: TClientDataSet; ArrIndex: Integer);
begin
  CDS.Data := g_PrintData[ArrIndex].Data;
  if CDS.IsEmpty then  //error: at end of table
  begin
    CDS.Append;
    CDS.Fields[0].Value := 0;
    CDS.Post;
    CDS.MergeChangeLog;
  end
  else
  begin
    if g_PrintData[ArrIndex].Filter <> '' then
    begin
      CDS.Filtered := False;
      CDS.Filter := g_PrintData[ArrIndex].Filter;
      CDS.Filtered := True;
    end;
    if g_PrintData[ArrIndex].RecNo > 0 then
      CDS.RecNo := g_PrintData[ArrIndex].RecNo;
    CDS.IndexFieldNames := g_PrintData[ArrIndex].IndexFieldNames;
  end;
  if isCOCPP then
  begin
    with frxDB3.DataSet do
    begin
      if (frxDB3.DataSet.FindField('vc') <> nil) then
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('vc').AsString := '';
          next;
        end;
      end;
    end;
  end;
end;

function TFrmReport.SetKG: Boolean;
var
  tmpSQL: string;
begin
  Result := False;

  with CDS2 do
    if Active and (FindField('kg_old') <> nil) then
    begin
      First;
      while not Eof do
      begin
        tmpSQL := ' declare @bu varchar(6)' + ' declare @saleno varchar(10)' + ' declare @saleitem int' + ' declare @kg float' + ' declare @date varchar(30)' + ' set @bu=' + Quotedstr(g_UInfo^.BU) + ' set @saleno=' + Quotedstr(FieldByName('dno').AsString) + ' set @saleitem=' + IntToStr(FieldByName('ditem').AsInteger) + ' set @kg=' + FloatToStr(FieldByName('kg_old').AsFloat) + ' set @date=' + Quotedstr(StringReplace(FormatDateTime(g_cLongTimeSP, Now), '/', '-', [rfReplaceAll])) +
          ' if exists(select 1 from dli027 where bu=@bu and saleno=@saleno and saleitem=@saleitem)' + '    update dli027 set kg=@kg,muser=' + quotedstr(g_uinfo^.userid) + ',mdate=@date' + '    where bu=@bu and saleno=@saleno and saleitem=@saleitem and kg<>@kg' + ' else' + '    insert into dli027(bu,saleno,saleitem,kg,iuser,idate)' + '    values(@bu,@saleno,@saleitem,@kg,' + Quotedstr(g_UInfo^.UserId) + ',@date)';
        if not PostBySQL(tmpSQL) then
          Exit;

        Next;
      end;
      First;
    end;

  Result := True;
end;

function TFrmReport.SetPrnCnt: Boolean;
var
  isSale: Boolean;
  i, pos1, tmpCnt, tmpSno: Integer;
  tmpSQL, tmpErr, tmpSaleno, tmpDno: string;
  Data: OleVariant;
  tmpList: TStrings;
  obj: TfrxMemoView;
begin
  Result := False;

  //出貨單
  isSale := CDS1.Active and (CDS1.FindField('IsSale') <> nil) and SameText(CDS1.FindField('IsSale').AsString, 'Y');

  if isSale then
  begin
    if not SetKG then
      Exit;

    //出貨明細(多個單號)
    if Length(CDS1.FieldByName('MoreSaleno').AsString) > 0 then
    begin
      tmpList := TStringList.Create;
      try
        tmpSQL := '';
        tmpList.DelimitedText := CDS1.FieldByName('MoreSaleno').AsString;
        for i := 0 to tmpList.Count - 1 do
          tmpSQL := tmpSQL + ',' + Quotedstr(tmpList.Strings[i]);
        Delete(tmpSQL, 1, 1);

        tmpSQL := 'update ' + g_UInfo^.BU + '.oga_file Set ogaprsw=nvl(ogaprsw,0)+1' + ' where oga01 in (' + tmpSQL + ')';
        if not PostBySQL(tmpSQL, 'ORACLE') then
          Exit;

        tmpDno := FormatDateTime('YYMMDD', Date);
        tmpSQL := ' declare @bu varchar(6)' + ' declare @dno varchar(20)' + ' declare @saleno varchar(800)' + ' set @bu=' + Quotedstr(g_UInfo^.BU) + ' set @saleno=' + Quotedstr(CDS1.FieldByName('MoreSaleno').AsString) + ' if exists(select 1 from dli024 where bu=@bu and saleno=@saleno and isnull(not_use,0)=0)' + '   select @dno=dno from dli024 where bu=@bu and saleno=@saleno and isnull(not_use,0)=0' + ' else begin' + '   select @dno=max(dno) from dli024 where bu=@bu and dno like ' + Quotedstr(tmpDno + '%') +
          '   if len(isnull(@dno,''''))=0' + '     set @dno=' + Quotedstr(tmpDno + '001') + '   else' + '     set @dno=cast((cast(@dno as int)+1) as varchar(20))' + '   insert into dli024(bu,dno,saleno,not_use)' + '   values(@bu,@dno,' + Quotedstr(CDS1.FieldByName('MoreSaleno').AsString) + ',0)' + ' end' + ' select @dno as dno';
        if not QueryOneCR(tmpSQL, Data) then
          Exit;

        CDS1.Edit;
        CDS1.FieldByName('Dno').AsString := VarToStr(Data);
        CDS1.Post;
        CDS1.MergeChangeLog;
      finally
        FreeAndNil(tmpList);
      end;
    end
    else //其它默認(一個單號)
    begin
      tmpSaleno := CDS1.FieldByName('Saleno').AsString;
      tmpCnt := CDS1.FieldByName('Printcnt').AsInteger + 1;
      if tmpCnt > 1 then //多次列印,選擇列印異常類型
      begin
        FrmDLII020_prnmark := TFrmDLII020_prnmark.Create(nil);
        try
          FrmDLII020_prnmark.SetAllMark(tmpSaleno, tmpCnt);
          with FrmDLII020_prnmark do
          begin
            if ShowModal = MrCancel then
              Exit;
            if RadioGroup1.ItemIndex = RadioGroup1.Items.Count - 1 then
              tmpErr := RichEdit1.Text
            else
              tmpErr := RadioGroup1.Items[RadioGroup1.ItemIndex];
          end;

          tmpSQL := ' delete from dli480 where bu=' + Quotedstr(g_UInfo^.BU) + ' and saleno=' + Quotedstr(tmpSaleno) + ' and times=' + IntToStr(tmpCnt) + ' insert into dli480(bu,saleno,times,memo,iuser,idate)' + ' values(' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(tmpSaleno) + ',' + IntToStr(tmpCnt) + ',' + Quotedstr(tmpErr) + ',' + Quotedstr(g_UInfo^.UserId) + ',' + Quotedstr(FormatDateTime(g_cLongTimeSP, Now)) + ')';
          if not PostBySQL(tmpSQL) then
            Exit;
        finally
          FreeAndNil(FrmDLII020_prnmark);
        end;
      end;

      tmpSQL := 'exec dbo.proc_GetSaleDno ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(tmpSaleno);
      if not QueryOneCR(tmpSQL, Data) then
        Exit;
      tmpDno := VarToStr(Data);
      if Length(tmpDno) = 0 then
        Exit;

      tmpSQL := 'update ' + g_UInfo^.BU + '.oga_file set ogaprsw=nvl(ogaprsw,0)+1' + ' where oga01=' + Quotedstr(tmpSaleno);
      if not PostBySQL(tmpSQL, 'ORACLE') then
        Exit
      else
      begin
        pos1 := Pos('-', tmpDno);
        if pos1 = 0 then
          tmpSno := 1
        else
          tmpSno := StrToInt(Copy(tmpDno, pos1 + 1, 2));
        if tmpSno <> tmpCnt then //mssql儲存的次數與oracle儲存的次數不一致,更新為一致,重新計算流水號
        begin
          tmpSQL := 'update dli012 set ditem=' + IntToStr(tmpCnt) + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and saleno=' + Quotedstr(tmpSaleno);
          if not PostBySQL(tmpSQL) then
            Exit;

          if pos1 = 0 then
            tmpDno := tmpDno + '-' + IntToStr(tmpCnt)
          else
            tmpDno := Copy(tmpDno, 1, pos1) + IntToStr(tmpCnt);
          pos1 := Pos('-', tmpDno);
          if (tmpCnt = 1) and (pos1 > 0) then
            tmpDno := Copy(tmpDno, 1, pos1 - 1);
        end;

        CDS1.Edit;
        CDS1.FieldByName('Printcnt').AsInteger := tmpCnt;
        CDS1.FieldByName('Dno').AsString := tmpDno;
        CDS1.Post;
        CDS1.MergeChangeLog;
      end;
    end;
  end;

  if isSale then
  begin
    obj := TfrxMemoView(frxReport1.FindComponent('Memo_prncnt'));
    if obj <> nil then
      obj.Text := '列印次數：' + IntToStr(CDS1.FieldByName('Printcnt').AsInteger);
    obj := TfrxMemoView(frxReport1.FindComponent('Memo_dno'));
    if obj <> nil then
      obj.Text := 'No.' + CDS1.FieldByName('Dno').AsString;
  end;

  frxPreview1.RefreshReport;
  Result := True;
end;

function TFrmReport.GetCOC_FileName: string;
var
  pos1: Integer;
  tmpCustno, ad, strip, oz, pp, rc, ret: string;
//  function RemoveQty(str: string): string;
//  var                     有批號數量外的括號存在
//    i, j: integer;
//  begin
//    i := Pos('(', str);
//    j := Pos(')', str);
//    while (i > 0) and (j > i) do
//    begin
//      str := Copy(str, 1, i - 1) + Copy(str, j + 1, 255);
//      i := Pos('(', str);
//      j := Pos(')', str);
//    end;
//  end;
begin
  Result := '';
  if (not CDS1.Active) or (not CDS2.Active) then
    Exit;

  if (CDS2.FindField('IsCCLCOC') = nil) and (CDS2.FindField('IsPPCOC') = nil) then
    Exit;

  ret := '';
  tmpCustno := UpperCase(CDS1.FieldByName('custno').AsString);
  if CDS2.FindField('IsCCLCOC') <> nil then //CCL
  begin
    if Pos(tmpCustno, 'AC121,ACG02,ACA97,AC820') > 0 then   //崇達
      ret := CDS2.FieldByName('c_sizes').AsString + ' ' + CDS2.FieldByName('fstlot').AsString else
    if Pos(tmpCustno, 'AC109,ACB16') > 0 then    //華通
      ret := CDS2.FieldByName('c_pno').AsString
    else if Pos(tmpCustno, 'AC310,AC075,AC311,AC405,AC950') > 0 then    //德麗、超毅集團
      ret := CDS2.FieldByName('c_pno').AsString + ' ' + FormatDateTime('YYYYMMDD', Date) + ' ' + CDS3.FieldByName('totqty').AsString
    else if Pos(tmpCustno, 'N006,N013,AC082,AC178,AC394,AC844,AC152,AC093') > 0 then  //無錫+茂成、美銳、美維、惠亞、惠亞線路、中山皆利士、廣州添利
    begin
      ad := '';
      pos1 := Pos('TC', CDS2.FieldByName('pname').AsString);
      if pos1 > 0 then
        ad := Copy(CDS2.FieldByName('pname').AsString, 1, pos1 - 1);
      strip := FloatToStr(StrToIntDef(Copy(CDS2.FieldByName('pno').AsString, 3, 4), 0) / 10000);
      oz := Copy(CDS2.FieldByName('pno').AsString, 7, 1) + '-' + Copy(CDS2.FieldByName('pno').AsString, 8, 1);

      ret := ad + ' ' + strip + ' ' + oz + ' ' + FormatDateTime('MMDD', Date) + ' ' + CDS3.FieldByName('totqty').AsString;
    end
    else    //其它
      ret := CDS2.FieldByName('c_sizes').AsString + ' ' + FormatDateTime('MMDD', Date) + ' ' + CDS3.FieldByName('totqty').AsString;
  end
  else
  begin
    if Pos(tmpCustno, 'AC121,ACA97,AC820') > 0 then   //崇達
    begin
      if (CDS2.FindField('IsPPCOC') <> nil) then
        ret := CDS2.FieldByName('c_sizes').AsString + ' ' + CDS2.FieldByName('C').AsString + ' ' + CDS2.FieldByName('fstlot').AsString
      else
        ret := CDS2.FieldByName('c_sizes').AsString + ' ' + CDS2.FieldByName('C').AsString;
    end
    else if Pos(tmpCustno, 'AC109,ACB16') > 0 then    //華通
      ret := CDS2.FieldByName('c_pno').AsString
    else if Pos(tmpCustno, 'AC310,AC075,AC311,AC405,AC950') > 0 then    //德麗、超毅集團
      ret := CDS2.FieldByName('c_pno').AsString + ' ' + FormatDateTime('YYYYMMDD', Date) + ' ' + CDS2.FieldByName('C').AsString
    else if Pos(tmpCustno, 'N006,N013,AC082,AC178,AC394,AC844,AC152,AC093') > 0 then  //無錫+江西+茂成、美銳、美維、惠亞、惠亞線路、中山皆利士、廣州添利
    begin
      ad := '';
      pos1 := Pos('BS', CDS2.FieldByName('pname').AsString);
      if pos1 > 0 then
        ad := Copy(CDS2.FieldByName('pname').AsString, 1, pos1 - 1);
      pp := Copy(CDS2.FieldByName('pno').AsString, 4, 4);
      if Copy(pp, 1, 1) = '0' then
        pp := Copy(pp, 2, 3);
      rc := FloatToStr(StrToIntDef(Copy(CDS2.FieldByName('pno').AsString, 8, 3), 0) / 10) + '%';

      ret := ad + ' ' + pp + ' ' + rc + ' ' + FormatDateTime('MMDD', Date) + ' ' + CDS2.FieldByName('C').AsString;
    end
    else    //其它
      ret := CDS2.FieldByName('c_sizes').AsString + ' ' + FormatDateTime('MMDD', Date) + ' ' + CDS2.FieldByName('C').AsString;
  end;
  if Pos(tmpCustno, 'N024') > 0 then
  begin
    if CDS3.FindField('totqty') <> nil then
      ret := CDS2.FieldByName('c_sizes').AsString + ' ' + FormatDateTime('MMDD', Date) + ' ' + CDS3.FieldByName('totqty').AsString
    else
      ret := CDS2.FieldByName('c_sizes').AsString + ' ' + FormatDateTime('MMDD', Date);
  end;
  if Length(ret) > 0 then
  begin
    ret := StringReplace(ret, '\', '-', [rfReplaceAll]);
    if Pos(tmpCustno, 'AC097') > 0 then
    begin
      ret := StringReplace(ret, '/', '', [rfReplaceAll]);
      ret := StringReplace(ret, '*', '', [rfReplaceAll]);
    end
    else
    begin
      ret := StringReplace(ret, '/', '-', [rfReplaceAll]);
      ret := StringReplace(ret, '*', 'x', [rfReplaceAll]);
    end;
    ret := StringReplace(ret, ':', '-', [rfReplaceAll]);
    ret := StringReplace(ret, '?', '-', [rfReplaceAll]);
    ret := StringReplace(ret, '"', '-', [rfReplaceAll]);
    ret := StringReplace(ret, '|', '-', [rfReplaceAll]);
    ret := StringReplace(ret, '<', '-', [rfReplaceAll]);
    Result := StringReplace(ret, '>', '-', [rfReplaceAll]);
  end
  else
    Result := '';
  if Pos(tmpCustno, 'AC093,AC082,AC178,AC152') > 0 then
    result := CDS2.FieldByName('c_pno').AsString + ' ' + Result;

  if (Pos(tmpCustno, 'AC136/ACA27/AC552') > 0) then   
    result := result + ' ' + CDS2.FieldByName('fstlot').AsString
  else if (Pos(tmpCustno, 'AC198') > 0) then
    result := result + ' ' + CDS3.FieldByName('lot1').AsString;
end;

procedure TFrmReport.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  SetLength(g_DAL, Length(g_ConnData));
  for i := Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i] := TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, 'FrmReport');
  SetCbb;
  SetComp;
  for i := Low(g_PrintData) to High(g_PrintData) do
  begin
    if i > 6 then
      Break
    else
      SetCDS(TCLientDataset(Self.FindComponent('CDS' + IntToStr(i + 1))), i);
  end;
  btn_design.Enabled := g_MInfo^.R_rptDesign and (Cbb.Items.Count > 0);
end;

procedure TFrmReport.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  inherited;
  for i := Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
end;

procedure TFrmReport.btn_singlePageClick(Sender: TObject);
begin
  frxPreview1.ZoomMode := zmWholePage;
end;

procedure TFrmReport.btn_doublePagesClick(Sender: TObject);
begin
  frxPreview1.ZoomMode := zmManyPages;
end;

procedure TFrmReport.btn_pageWidthClick(Sender: TObject);
begin
  frxPreview1.ZoomMode := zmPageWidth;
end;

procedure TFrmReport.mi5001Click(Sender: TObject);
begin
  frxPreview1.ZoomMode := zmDefault;
  case TMenuItem(Sender).Tag of
    1:
      frxPreview1.Zoom := 0.10;
    2:
      frxPreview1.Zoom := 0.20;
    3:
      frxPreview1.Zoom := 0.30;
    4:
      frxPreview1.Zoom := 0.50;
    5:
      frxPreview1.Zoom := 0.75;
    6:
      frxPreview1.Zoom := 1.00;
    7:
      frxPreview1.Zoom := 1.20;
    8:
      frxPreview1.Zoom := 1.50;
    9:
      frxPreview1.Zoom := 2.00;
    10:
      frxPreview1.Zoom := 3.00;
    11:
      frxPreview1.Zoom := 5.00;
  end;
end;

procedure TFrmReport.btn_firstPgClick(Sender: TObject);
begin
  frxPreview1.First;
end;

procedure TFrmReport.btn_priorPgClick(Sender: TObject);
begin
  frxPreview1.Prior;
end;

procedure TFrmReport.btn_nextPgClick(Sender: TObject);
begin
  frxPreview1.Next;
end;

procedure TFrmReport.btn_lastPgClick(Sender: TObject);
begin
  frxPreview1.Last;
end;

procedure TFrmReport.btn_excelClick(Sender: TObject);
var
  str: string;
begin
  str := GetCOC_FileName;
  if Length(str) > 0 then
    frxXLSExport1.FileName := str + '.xls';
  frxPreview1.Export(frxXLSExport1);
end;

procedure TFrmReport.btn_wordClick(Sender: TObject);
var
  str: string;
begin
  str := GetCOC_FileName;
  if Length(str) > 0 then
    frxRTFExport1.FileName := str + '.rtf';
  frxPreview1.export(frxRTFExport1);
end;

procedure TFrmReport.btn_pdfClick(Sender: TObject);
var
  str: string;
begin
  str := GetCOC_FileName;
  if Length(str) > 0 then
    frxPDFExport1.FileName := str + '.pdf';
  frxPreview1.export(frxPDFExport1);
end;

procedure TFrmReport.btn_txtClick(Sender: TObject);
begin
  frxPreview1.export(frxTXTExport1);
end;

procedure TFrmReport.btn_htmlClick(Sender: TObject);
begin
  frxPreview1.export(frxHTMLExport1);
end;

procedure TFrmReport.m_designClick(Sender: TObject);
begin
  frxReport1.Report.FileName := Cbb.Text + '.fr3';
  frxReport1.DesignReport;
  frxReport1.ShowReport();
end;

procedure TFrmReport.m_printClick(Sender: TObject);
var
  str: string;
  obj: TfrxMemoView;
begin
  if SetPrnCnt then
  begin
    obj := TfrxMemoView(frxReport1.FindComponent('Memo_prncnt'));
    if obj <> nil then
    begin
      str := Trim(obj.Text);
      str := StringReplace(str, '列印次數：', '', [rfReplaceAll]);
      if StrToIntDef(str, 0) <= 0 then
      begin
        ShowMsg('列印次數:' + str + ', 請重新列印!', 48);
        Exit;
      end;
    end;
    frxPreview1.Print;
  end;
end;

procedure TFrmReport.btn_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmReport.CbbChange(Sender: TObject);
var
  fr3,str,sub,newtext: string;
  i:integer;
  fmm:TfrxMemoView;
begin
  if Cbb.Items.IndexOf(Cbb.Text) <> -1 then
  begin
    fr3 := 'Reports\' + g_MInfo^.ProcName + '\' + g_UInfo^.BU + '\' + Cbb.Text + '.fr3';
    if not FileExists(g_UInfo^.SysPath + fr3) then
      StatusBar1.Panels[1].Text := 'not found ' + fr3
    else if frxReport1.LoadFromFile(g_UInfo^.SysPath + fr3) then
      frxReport1.ShowReport(); 
    frxReport1.ShowReport();
  end;
  if Pos('COC', Cbb.Text) > 0 then
  begin
    with frxReport1 do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i] is TfrxMemoView then
        begin
          str := TfrxMemoView(Components[i]).Text;
          if Pos('IPC-4101-E-WAM1', str) = 0 then
          begin
            if Pos('IPC-4101-E', str) > 0 then
              str := StringReplace(str, 'IPC-4101-E', 'IPC-4101-E-WAM1', [rfReplaceAll]);
            if Pos('IPC- 4101 -E', str) > 0 then
              str := StringReplace(str, 'IPC- 4101 -E', 'IPC-4101-E-WAM1', [rfReplaceAll]);
            if Pos('IPC- 4101-E', str) > 0 then
              str := StringReplace(str, 'IPC- 4101-E', 'IPC-4101-E-WAM1', [rfReplaceAll]);
          end;
          sub := '信息?業科';
          if Pos(sub, str) > 0 then
            str := StringReplace(str, sub,'信息產業科', [rfReplaceAll]);
          sub := '廣東省東莞市虎門鎮北柵村南坊工業區東坊路57號';
          if Pos(sub, str) > 0 then
            str := StringReplace(str, sub,'中國廣東省東莞市虎門鎮北柵東坊路57號。', [rfReplaceAll]);
          sub := '中國，廣東省，東莞市，虎門鎮，北柵東坊路57號。';
          if Pos(sub, str) > 0 then
            str := StringReplace(str, sub,'中國廣東省東莞市虎門鎮北柵東坊路57號。', [rfReplaceAll]);
          sub:= '57, Dongfang Road, Nanfang Industrial Park, Beice Village Humen Town, Dongguan City, Guangdong Province';
          if Pos(sub,str)>0 then
            str := StringReplace(str, sub,'No.57 Dongfang Road,Beice, Humen Town,Dongguan City, Guangdong Province, China', [rfReplaceAll]);
          sub:='E-4/105';
          if Pos(sub,str)>0 then
            str := StringReplace(str, sub,'', []);

          if SameText(TfrxMemoView(Components[i]).Name,'Memo208') then
             if trim(str) = '%' then
                str := '---';

          if 'CERTIFICATE  OF  CONFORMANCE' = Trim(str) then
          begin
            if Pos('COC-CCL', Cbb.Text) > 0 then
              str := ''// 'Laminate Test Report / 基板測試報告'
            else if Pos('COC-PP', Cbb.Text) > 0 then
              str := '';//'Prepreg Test Report / 膠片測試報告';
          end;

          if (pos('覆 ',trim(str))=1) and sametext('memo3',TfrxMemoView(Components[i]).Name) then
            str := 'Laminate Test Report / 基板測試報告'
          else if (pos('半 ',trim(str))=1) and sametext('memo3',TfrxMemoView(Components[i]).Name) then
            str := 'Prepreg Test Report / 膠片測試報告';
          if trim(str) = 'W-DQA-1401-03A' then
             str := 'W-DQA-1401-03B'
          else if trim(str) = 'W-DQA-1401-04A' then
             str := 'W-DQA-1401-04B';
          TfrxMemoView(Components[i]).Text := str;
        end;
      end;
    end;
  end;
  if Pos('COC-CCL', Cbb.Text) > 0 then
  begin
    with frxReport1 do
    begin
      for i := 0 to ComponentCount - 1 do
      begin
        if Components[i] is TfrxMemoView then
        begin
          str := Trim(TfrxMemoView(Components[i]).Text);
          if 'CERTIFICATE  OF  CONFORMANCE'=str then
            TfrxMemoView(Components[i]).Text := 'Laminate Test Report / 基板測試報告';
          if Pos('IPC- 4101 -E', str) > 0 then
            TfrxMemoView(Components[i]).Text := StringReplace(str, 'IPC- 4101 -E', 'IPC-4101-E-WAM1', [rfReplaceAll]);
          if Pos('IPC- 4101-E', str) > 0 then
            TfrxMemoView(Components[i]).Text := StringReplace(str, 'IPC- 4101-E', 'IPC-4101-E-WAM1', [rfReplaceAll]);
        end;
      end;
    end;
  end;
end;

function TFrmReport.frxDesigner1SaveReport(Report: TfrxReport; SaveAs: Boolean): Boolean;
var
  fr3: string;
begin
  Result := False;

  if SaveAs then
  begin
    if SaveDialog1.Execute then
      Report.SaveToFile(SaveDialog1.FileName)
    else
      Exit;
  end
  else
  begin
    fr3 := g_UInfo^.SysPath + 'Reports';
    if not DirectoryExists(fr3) then
      CreateDir(fr3);
    fr3 := fr3 + '\' + g_MInfo^.ProcName;
    if not DirectoryExists(fr3) then
      CreateDir(fr3);
    fr3 := fr3 + '\' + g_UInfo^.BU;
    if not DirectoryExists(fr3) then
      CreateDir(fr3);
    Report.SaveToFile(fr3 + '\' + Cbb.Text + '.fr3');
  end;

  Result := True;
  ShowMsg('報表儲存成功!', 64);
end;

end.

