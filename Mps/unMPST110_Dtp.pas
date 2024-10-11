unit unMPST110_Dtp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ADODB, Grids, DBGrids;

type
  TFrmMPST110_Dtp = class(TFrmSTDI051)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Indate: TLabel;
    dtp1: TDateTimePicker;
    Panel2: TPanel;
    DS: TDataSource;
    lCategory: TLabel;
    cmbCategory: TComboBox;
    btn_export_rpt: TBitBtn;
    GroupBox2: TGroupBox;
    DBGridEh1: TDBGridEh;
    GroupBox3: TGroupBox;
    cbkE: TCheckBox;
    cbkT: TCheckBox;
    cbkB: TCheckBox;
    cbkR: TCheckBox;
    cbkN: TCheckBox;
    cbkM: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_export_rptClick(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure cmbCategorySelect(Sender: TObject);
  private
    l_CDS: TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST110_Dtp: TFrmMPST110_Dtp;

const fstCode='ETBRPMN';
const fstCode_ccl='ET';
const fstCode_pp='BRPMN';

implementation

uses unCommon, unGlobal, ComObj, StrUtils;

{$R *.dfm}

procedure TFrmMPST110_Dtp.FormShow(Sender: TObject);
begin
  inherited;
  
  with DBGridEh1 do
  begin

    FieldColumns['export_flg'].Title.Caption := CheckLang('����');
    FieldColumns['Custshort'].Title.Caption := CheckLang('�Ȥ�²��');
    FieldColumns['Stime'].Title.Caption := CheckLang('���f�ɶ�');
    FieldColumns['Remark5'].Title.Caption := CheckLang('�u��渹');
    FieldColumns['W_qty'].Title.Caption := CheckLang('�o�Ƽƶq(RL)');
    FieldColumns['Notcount1'].Title.Caption := CheckLang('�X�f�ƶq(RL)');
    FieldColumns['pno'].Title.Caption := CheckLang('���u�e�Ƹ�');
    FieldColumns['W_pno'].Title.Caption := CheckLang('���u��Ƹ�');
    FieldColumns['Remark4'].Title.Caption := CheckLang('�`�N�ƶ�');
    FieldColumns['Remark'].Title.Caption := CheckLang('���ҥ��k');
    FieldColumns['Custorderno'].Title.Caption := CheckLang('�Ȥ�q��渹');

    FieldColumns['export_flg'].Width := 60;
    FieldColumns['Custshort'].Width := 120;
    FieldColumns['Stime'].Width := 70;
    FieldColumns['Remark5'].Width := 120;
    FieldColumns['W_qty'].Width := 120;
    FieldColumns['Notcount1'].Width := 120;
    FieldColumns['pno'].Width := 140;
    FieldColumns['W_pno'].Width := 140;
    FieldColumns['Remark4'].Width := 120;
    FieldColumns['Remark'].Width := 120;
    FieldColumns['Custorderno'].Width := 120;

    ReadOnly := true;
    
  end;

  btn_export_rpt.Caption := CheckLang('���L����');

  l_CDS := TClientDataSet.Create(Self);
  DS.DataSet := l_CDS;

end;

procedure TFrmMPST110_Dtp.btn_quitClick(Sender: TObject);
begin
  inherited;
  close;
end;

procedure TFrmMPST110_Dtp.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST110_Dtp.btn_okClick(Sender: TObject);
var
  tmpDate:TDateTime;
  tmpStr,tmpSQL: string;
  Data: OleVariant;
  i:integer;
begin
  inherited;

  tmpDate:=dtp1.Date;

  tmpStr := '';

  {
  // PP
  if(cmbCategory.ItemIndex=1)then
     tmpStr := ' AND substring(A.pno,1,1) IN (''B'',''R'',''N'',''M'') ';

  // CCL
  if(cmbCategory.ItemIndex=2)then
     tmpStr := ' AND substring(A.pno,1,1) IN (''T'',''E'') ';
  }

  for i:=1 to Length(fstCode) do
  begin
    if (Self.FindComponent('cbk'+fstCode[i])<>nil) and
       (Self.FindComponent('cbk'+fstCode[i]) as TCheckBox).Enabled and
       (Self.FindComponent('cbk'+fstCode[i]) as TCheckBox).Checked then
    begin
      tmpStr:=tmpStr+','+Quotedstr(fstCode[i]);
    end;
  end;

  if(length(tmpStr)>0)then
  begin
     Delete(tmpStr,1,1);
     tmpStr:= ' AND substring(A.pno,1,1) IN (' + tmpStr + ') ';
  end;

  tmpSQL := ' select A.export_flg,A.Custno,A.Custshort,A.Stime, '
         +'  A.Remark5,A.W_qty,A.Notcount1,A.pno,A.W_pno,A.Remark4,A.Remark,A.Custorderno, '
         +'  A.Bu,A.Dno,A.Ditem '
         +'  from DLI010 A '
         +'  where A.Bu='+Quotedstr(g_UInfo^.BU) + ' AND A.Indate='+Quotedstr(DateToStr(tmpDate))
         +'  And Len(IsNull(A.W_pno,''''))>0 '
         +'  And IsNull(A.W_qty,0)>0 '
         +'  And Len(IsNull(A.Remark5,''''))>0 '
         +'  And IsNull(A.QtyColor,0)<>999 '
         +'  And IsNull(A.GarbageFlag,0)=0 '
         +'  And Len(IsNull(A.Dno_Ditem,''''))=0 '
         + tmpStr
         +'  Order By SUBSTRING(A.pno,1,1),A.Indate,A.InsFlag,A.Stime,A.Custno,A.Custshort,A.Units,A.Pno,A.Orderno,A.Orderitem,A.Sno;';


  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  l_CDS.Data := Data;

  ModalResult := mrNone;
end;

procedure TFrmMPST110_Dtp.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, 'DLI010');

  cbkE.Caption:=CheckLang('E');
  cbkT.Caption:=CheckLang('T');
  cbkB.Caption:=CheckLang('B');
  cbkR.Caption:=CheckLang('R');
  cbkN.Caption:=CheckLang('N');
  cbkM.Caption:=CheckLang('M');
end;

procedure TFrmMPST110_Dtp.btn_export_rptClick(Sender: TObject);
var
  tmpCDS:TClientDataSet;
  tmpCDS2:TClientDataSet;
  tmpStr:string;
  Data:OleVariant;
  ArrPrintData:TArrPrintData;
  tmpDate:TDateTime;
begin
  inherited;
  if (not l_CDS.Active) or (l_CDS.RecordCount=0) then exit;

  tmpDate:=dtp1.Date;

  try
    // 1. ����D�ƾڡG�w���L���O�����ѻP
    tmpCDS := TClientDataSet.Create(nil);
    tmpCDS.Data:=l_CDS.Data;

    {tmpCDS.Open;
    tmpCDS.Filtered:=false;
    tmpCDS.Filter:='export_flg = '+Quotedstr('N');
    tmpCDS.Filtered:=True;}
//
//    tmpCDS.First;
//    while not tmpCDS.Eof do
//    begin
//      tmpStr:=tmpCDS.FieldByName('export_flg').AsString;
//      if SameText(tmpStr,'Y') then
//      begin
//        tmpCDS.Delete;
//        continue;
//      end;
//      tmpCDS.Next;
//    end;


    // 2. ����ǻ��ѼơA�N�d�@�Ӽƾڶ�
    tmpCDS2 := TClientDataSet.Create(Self);
    Data:=null;
    if not QueryBySQL('select '+Quotedstr(cmbCategory.Text)+' as Category, CONVERT(varchar(100), ' + Quotedstr(DateToStr(tmpDate)) +', 111) as OutDate, CONVERT(varchar(100), GETDATE(), 21) as PrintDate', Data) then
       Exit;
    tmpCDS2.Data:=Data;

    // 3. �ǻ�����ƾ�
    SetLength(ArrPrintData, 2);
    ArrPrintData[0].Data:=tmpCDS.Data;
    ArrPrintData[0].RecNo:=tmpCDS.RecNo;

    ArrPrintData[1].Data:=tmpCDS2.Data;
    ArrPrintData[1].RecNo:=tmpCDS2.RecNo;

    GetPrintObj('MPS', ArrPrintData);
    ArrPrintData:=nil;

    // 4. �Ʀ�O��
    l_CDS.DisableControls;

    l_CDS.First;
    while not l_CDS.Eof do
    begin
      // �w�g�ɥX�����A�ɥX�O��
      tmpStr:=l_CDS.FieldByName('export_flg').AsString;
      if SameText(tmpStr,'Y') then
      begin
        l_CDS.next;
        continue;
      end;

      l_CDS.Edit;
      l_CDS.FieldByName('export_flg').AsString:='Y';
      l_CDS.Post;

      l_CDS.Next;
    end;

    if not CDSPost(l_CDS, 'DLI010') then
      if l_CDS.ChangeCount>0 then
        l_CDS.CancelUpdates;

    l_CDS.EnableControls;

    finally
      FreeAndNil(tmpCDS);
      FreeAndNil(tmpCDS2);
    end;
end;

{var
  isOK:Boolean;
  ExcelApp:Variant;
  i,row:Integer;
  tmpStr:string;
  fontSize:Integer;
  fontName:string;
var
  tmpCDS:TClientDataSet;
  tmpStr:string;
  ArrPrintData:TArrPrintData;
begin
  inherited;

    //frxReport1.LoadFromFile('Reports\'+g_MInfo^.ProcName+'\'+g_UInfo^.BU+'\mps110.fr3');

    if (not l_CDS.Active) or (l_CDS.RecordCount=0) then exit;

    tmpCDS := TClientDataSet.Create(Self);
    tmpCDS.Data:=l_CDS.Data;
    tmpCDS.Filtered:=false;
    tmpCDS.Filter:='export_flg is null';//+Quotedstr('Y');
    tmpCDS.Filtered:=True;


begin
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=tmpCDS.Data;
  ArrPrintData[0].RecNo:=tmpCDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=tmpCDS.IndexFieldNames;
  ArrPrintData[0].Filter:=tmpCDS.Filter;
  GetPrintObj('MPS', ArrPrintData);
  ArrPrintData:=nil;
end;

exit;


    frxDBDataset1.DataSet := tmpCDS;
    TfrxMemoView(frxReport1.FindObject('Memo1')).Memo.Text:= DateToStr(dtp1.Date) + CheckLang(' �X�f');
    TfrxMemoView(frxReport1.FindObject('Memo2')).Memo.Text:= CheckLang('���u���O�G') + cmbCategory.Text;
    TfrxMemoView(frxReport1.FindObject('Memo3')).Memo.Text:= CheckLang('���L����G') +formatdatetime('yyyy/mm/dd hh:mm',Now);

    TfrxMemoView(frxReport1.FindObject('Memo4')).Memo.Text:= CheckLang('�Ȥ�W��');
    TfrxMemoView(frxReport1.FindObject('Memo5')).Memo.Text:= CheckLang('���f�ɶ�');
    TfrxMemoView(frxReport1.FindObject('Memo6')).Memo.Text:= CheckLang('�u��X��');
    TfrxMemoView(frxReport1.FindObject('Memo7')).Memo.Text:= CheckLang('�o�ƶq');
    TfrxMemoView(frxReport1.FindObject('Memo8')).Memo.Text:= CheckLang('�X�f�q');
    TfrxMemoView(frxReport1.FindObject('Memo9')).Memo.Text:= CheckLang('���u�e�Ƹ�');
    TfrxMemoView(frxReport1.FindObject('Memo10')).Memo.Text:= CheckLang('���u��Ƹ�');
    TfrxMemoView(frxReport1.FindObject('Memo11')).Memo.Text:= CheckLang('�`�N�ƶ�');
    TfrxMemoView(frxReport1.FindObject('Memo12')).Memo.Text:= CheckLang('���ҥ��k');
    TfrxMemoView(frxReport1.FindObject('Memo13')).Memo.Text:= CheckLang('�Ȥ�PO');
    TfrxMemoView(frxReport1.FindObject('Memo20')).Memo.Text:= CheckLang('�u��X��');

    TfrxMemoView(frxReport1.FindObject('Memo21')).Memo.Text:= CheckLang('�`�G�Ы��ӫȤ���f�ɶ����u�@�~�C�p��Z�����u�����A�Х汵����Z�C���°t�X�I');
    TfrxMemoView(frxReport1.FindObject('Memo22')).Memo.Text:= CheckLang('���ˡG');
    TfrxMemoView(frxReport1.FindObject('Memo23')).Memo.Text:= CheckLang('�~�O�T�{�G');
    TfrxMemoView(frxReport1.FindObject('Memo24')).Memo.Text:= CheckLang('�f�֡G');
    TfrxMemoView(frxReport1.FindObject('Memo25')).Memo.Text:= CheckLang('�s��G');

    frxReport1.showreport;

    l_CDS.DisableControls;

    l_CDS.First;
    while not l_CDS.Eof do
    begin
      // �w�g�ɥX�����A�ɥX�O��
      tmpStr:=l_CDS.FieldByName('export_flg').AsString;
     if SameText(tmpStr,'Y') then
     begin
       l_CDS.next;
       continue;
     end;

     l_CDS.Edit;
     l_CDS.FieldByName('export_flg').AsString:='Y';
     l_CDS.Post;

     l_CDS.Next;
    end;

    if not CDSPost(l_CDS, 'DLI010') then
      if l_CDS.ChangeCount>0 then
        l_CDS.CancelUpdates;

    l_CDS.EnableControls;

    exit;

    if (not l_CDS.Active) or (l_CDS.RecordCount=0) then exit;

    fontSize := 28;
    fontName := 'C39HrP72DlTt';
    isOK := false;
    Application.ProcessMessages;

    try
      l_CDS.DisableControls;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=l_CDS.RecordCount;
      g_ProgressBar.Visible:=True;

      // a1: ��l EXCEL ��H
      try
        ExcelApp := CreateOleObject('Excel.Application');
        ExcelApp.Visible:=False;
        ExcelApp.DisplayAlerts:=False;
        ExcelApp.WorkBooks.Add;
        for i:=ExcelApp.WorkSheets.Count downto 2 do
        begin
          ExcelApp.WorkSheets[i].Select;
          ExcelApp.WorkSheets[i].Delete;
        end;
        ExcelApp.WorkSheets[1].Activate;
      except
        ShowMsg('Create Excel Application Error',16);
        Exit;
      end;
      // a1

      row := 1;

      ExcelApp.Columns[1].NumberFormatLocal:='@';
      ExcelApp.Columns[2].NumberFormatLocal:='@';
      ExcelApp.Columns[3].NumberFormatLocal:='@';
      ExcelApp.Columns[6].NumberFormatLocal:='@';
      ExcelApp.Columns[7].NumberFormatLocal:='@';
      ExcelApp.Columns[8].NumberFormatLocal:='@';
      ExcelApp.Columns[9].NumberFormatLocal:='@';
      ExcelApp.Columns[10].NumberFormatLocal:='@';
      ExcelApp.Columns[11].NumberFormatLocal:='@';
      ExcelApp.Columns[12].NumberFormatLocal:='@';
      ExcelApp.Columns[13].NumberFormatLocal:='@';

      //ExcelApp.Columns[11].WrapText:=True;

      // ��R���D
      ExcelApp.Cells[row,1].Value:='�Ȥ�W��';
      ExcelApp.Cells[row,2].Value:='���f�ɶ�';
      ExcelApp.Cells[row,3].Value:='�u��渹';
      ExcelApp.Cells[row,4].Value:='�o�Ƽƶq(RL)';
      ExcelApp.Cells[row,5].Value:='�X�f�ƶq(RL)';
      ExcelApp.Cells[row,6].Value:='���u�e�Ƹ�';
      ExcelApp.Cells[row,7].Value:='(�u��/�e�Ƹ�)';
      ExcelApp.Cells[row,8].Value:='(�u��/�e�Ƹ�)';
      ExcelApp.Cells[row,9].Value:='���u��Ƹ�';
      ExcelApp.Cells[row,10].Value:='�`�N�ƶ�';
      ExcelApp.Cells[row,11].Value:='���ҥ��k';
      ExcelApp.Cells[row,12].Value:='�Ȥ�q��渹';
      ExcelApp.Cells[row,13].Value:='�Ƶ�'; 

      l_CDS.First;

      while not l_CDS.Eof do
      begin

        // �w�g�ɥX�����A�ɥX�O��
        tmpStr:=l_CDS.FieldByName('export_flg').AsString;
        if SameText(tmpStr,'Y') then
        begin
          l_CDS.next;
          continue;
        end;

        Inc(row);
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        ExcelApp.Cells[row,1].Value:=l_CDS.FieldByName('Custshort').AsString;
        ExcelApp.Cells[row,2].Value:=FormatDateTime('HH:mm', l_CDS.FieldByName('Stime').AsDateTime);
        ExcelApp.Cells[row,3].Value:=l_CDS.FieldByName('Remark5').AsString;
        ExcelApp.Cells[row,4].Value:=l_CDS.FieldByName('W_qty').AsFloat;
        ExcelApp.Cells[row,5].Value:=l_CDS.FieldByName('Notcount1').AsFloat;
        ExcelApp.Cells[row,6].Value:=l_CDS.FieldByName('pno').AsString;

        if row mod 2=0 then
        begin
          ExcelApp.Cells[row,7].Font.Name:=fontName;
          ExcelApp.Cells[row,7].Font.Size:=fontSize;
          ExcelApp.Cells[row,7].Value:='*'+( l_CDS.FieldByName('Remark5').AsString + '/' + l_CDS.FieldByName('pno').AsString ) +'*';
        end else begin
          ExcelApp.Cells[row,8].Font.Name:=fontName;
          ExcelApp.Cells[row,8].Font.Size:=fontSize;
          ExcelApp.Cells[row,8].Value:='*'+( l_CDS.FieldByName('Remark5').AsString + '/' + l_CDS.FieldByName('pno').AsString ) +'*';
        end;

        ExcelApp.Cells[row,9].Value:=l_CDS.FieldByName('W_pno').AsString;
        ExcelApp.Cells[row,10].Value:=l_CDS.FieldByName('Remark4').AsString;
        ExcelApp.Cells[row,11].Value:=l_CDS.FieldByName('Remark').AsString;
        ExcelApp.Cells[row,12].Value:=l_CDS.FieldByName('Custorderno').AsString;

        ExcelApp.Cells[row,13].Font.Name:=fontName;
        ExcelApp.Cells[row,13].Font.Size:=fontSize;
        ExcelApp.Cells[row,13].Value:='*'+( l_CDS.FieldByName('pno').AsString ) +'*';

        l_CDS.Edit;
        l_CDS.FieldByName('export_flg').AsString:='Y';
        l_CDS.Post;

        l_CDS.Next;

      end;
      ExcelApp.Cells.Columns.autofit;
      ExcelApp.Visible:=True;

      if CDSPost(l_CDS, 'DLI010') then
        isOK:=True
      else
        if l_CDS.ChangeCount>0 then
          l_CDS.CancelUpdates;

    finally
      l_CDS.EnableControls;
      g_ProgressBar.Visible:=False;
      if not isOK then
        ExcelApp.Quit;
    end;
end;}

procedure TFrmMPST110_Dtp.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr:string;
begin
  inherited;
  if SameText(Column.FieldName, 'Stime') then
  begin

    // �B����l�O���G 1955-05-05 11:00:00.000
    tmpStr := FormatDateTime('HH:mm', l_CDS.FieldByName('Stime').AsDateTime);
    DBGridEh1.Canvas.TextOut(Rect.Left,Rect.Top+2, tmpStr + DupeString(' ',64));

  end;
end;

procedure TFrmMPST110_Dtp.cmbCategorySelect(Sender: TObject);
var
  i:integer;
begin
  inherited;

  // �����T��
  for i:=1 to Length(fstCode) do
    if (Self.FindComponent('cbk'+fstCode[i])<>nil) then
      (Self.FindComponent('cbk'+fstCode[i]) as TCheckBox).Enabled:=false;

  // �������}
  if(cmbCategory.ItemIndex=1)then
  begin
    for i:=1 to Length(fstCode_pp) do
      if (Self.FindComponent('cbk'+fstCode_pp[i])<>nil) then
        begin
          (Self.FindComponent('cbk'+fstCode_pp[i]) as TCheckBox).Enabled:=true; // ��} PP
          (Self.FindComponent('cbk'+fstCode_pp[i]) as TCheckBox).Checked:=true; // ��} PP
        end;
  end else if(cmbCategory.ItemIndex=2)then begin
      for i:=1 to Length(fstCode_ccl) do
      if (Self.FindComponent('cbk'+fstCode_ccl[i])<>nil) then
        begin
          (Self.FindComponent('cbk'+fstCode_ccl[i]) as TCheckBox).Enabled:=true; // ��} CCL
          (Self.FindComponent('cbk'+fstCode_ccl[i]) as TCheckBox).Checked:=true; // ��} CCL
        end;
  end else begin
    for i:=1 to Length(fstCode) do
      if (Self.FindComponent('cbk'+fstCode[i])<>nil) then
        begin
          (Self.FindComponent('cbk'+fstCode[i]) as TCheckBox).Enabled:=true; // ������}
          (Self.FindComponent('cbk'+fstCode[i]) as TCheckBox).Checked:=true; // ������}
        end;
  end;

end;

end.
