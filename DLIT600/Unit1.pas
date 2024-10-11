unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  ExtCtrls, DB, GridsEh, DBAxisGridsEh, DBGridEh, XPMan, StdCtrls, Buttons,
  DBClient, ComCtrls, Math, ImgList, ToolWin, StrUtils, ExcelXP, Provider,
  ADODB;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    DataSource1: TDataSource;
    OpenDialog1: TOpenDialog;
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    ProgressBar1: TProgressBar;
    ImageList1: TImageList;
    ToolBar: TToolBar;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    btn_copy: TToolButton;
    btn_post: TToolButton;
    btn_cancel: TToolButton;
    ToolButton2: TToolButton;
    btn_import: TToolButton;
    btn_export: TToolButton;
    btn_quit: TToolButton;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSAfterInsert(DataSet: TDataSet);
    procedure CDSAfterCancel(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure btn_quitClick(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    l_custno:string;
    procedure SetToolBar;
    procedure ToXls(ORADB:string; sType:Integer);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ComObj, Unit2;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="c_pno" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="adate" fieldtype="datetime" />'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="price" fieldtype="r8"/>'
           +'<FIELD attrname="oao04" fieldtype="i4"/>'
           +'<FIELD attrname="oao05" fieldtype="string" WIDTH="2"/>'
           +'<FIELD attrname="oao06" fieldtype="string" WIDTH="200"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';
const l_Hint='提示';

{$R *.dfm}

//初始化ClientDataSet
procedure InitCDS(DataSet:TClientDataSet; Xml:string);
var
  tmpList:TStrings;
  tmpMS:TMemoryStream;
begin
  tmpMS:=TMemoryStream.Create;
  tmpList:=TStringList.Create;
  try
    tmpList.Add(Xml);
    tmpList.SaveToStream(tmpMS);
    tmpMS.Position:=0;
    DataSet.LoadFromStream(tmpMS);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpMS);
  end;
end;

//處理dbgrideh回車鍵
procedure DBGridEhSelNext(const grdEh: TDBGridEh; var Key: Word);
begin
  if grdEh.SelectedIndex<grdEh.columns.Count-1 then
     grdEh.SelectedIndex:=grdEh.SelectedIndex+1
  else
  begin
    grdEh.DataSource.DataSet.Next;

    if grdEh.DataSource.DataSet.Eof then
      if (not grdEh.ReadOnly) and (grdEh.DataSource.DataSet.CanModify) then
         grdEh.DataSource.DataSet.Append;

    grdEh.SelectedIndex:=0;
  end;

  if not grdEh.FieldColumns[grdEh.SelectedField.FieldName].Visible then
     PostMessage(grdEh.Handle, WM_KEYDOWN, Key, 0);
end;

procedure TForm1.SetToolBar;
var
  isEdit:Boolean;
begin
  isEdit:=CDS.State in [dsInsert, dsEdit];

  if not CDS.Active then
  begin
    btn_insert.Enabled := false;
    btn_edit.Enabled := false;
    btn_delete.Enabled := false;
    btn_copy.Enabled := false;
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_export.Enabled := false;
    btn_import.Enabled := false;
  end else
  if isEdit then
  begin
    btn_insert.Enabled := false;
    btn_edit.Enabled := false;
    btn_delete.Enabled := false;
    btn_copy.Enabled := false;
    btn_post.Enabled := true;
    btn_cancel.Enabled := true;
    btn_export.Enabled := false;
    btn_import.Enabled := false;
  end else
  if CDS.State=dsBrowse then
  begin
    btn_insert.Enabled := True;
    btn_edit.Enabled := (not CDS.IsEmpty);
    btn_delete.Enabled := (not CDS.IsEmpty);
    btn_copy.Enabled := (not CDS.IsEmpty);
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_export.Enabled := True;
    btn_import.Enabled := True;
  end;
end;

procedure TForm1.ToXls(ORADB:string; sType:Integer);
var
  isXlsOK:Boolean;
  row:Integer;
  tmpQty:Double;
  tmpSQL,tmpFilter1,tmpFilter2:string;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;

  procedure AddXlsHead(col:Integer; value,comment:string);
  begin
    ExcelApp.Cells[1,col].Value:=value;
    ExcelApp.Cells[1,col].AddComment;     //添加備注
    ExcelApp.Cells[1,col].Comment.Visible:=False;
    ExcelApp.Cells[1,col].Comment.Text(comment);
    if col in [1,2,3,4,6,7,8,9,10,14,18,19] then
       ExcelApp.Columns[col].NumberFormat:='@';
  end;

begin
  if CDS.IsEmpty then
  begin
    Application.MessageBox('無資料!',l_Hint,48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    if CDS.ChangeCount>0 then
       CDS.MergeChangeLog;
    tmpCDS.Data:=CDS.Data;
    while not tmpCDS.Eof do
    begin
      if (Pos(tmpCDS.FieldByName('custno').AsString,tmpFilter1)=0) and
         (Length(Trim(tmpCDS.FieldByName('custno').AsString))>0) then
         tmpFilter1:=tmpFilter1+','+Quotedstr(tmpCDS.FieldByName('custno').AsString);

      if Length(Trim(tmpCDS.FieldByName('c_pno').AsString))>0 then
         tmpFilter2:=tmpFilter2+','+Quotedstr(tmpCDS.FieldByName('c_pno').AsString);
      tmpCDS.Next;
    end;

    if Length(tmpFilter1)>0 then
       Delete(tmpFilter1,1,1);
    if Length(tmpFilter2)>0 then
       Delete(tmpFilter2,1,1);
    if Pos(',',tmpFilter1)>0 then
       Application.MessageBox('多個客戶!',l_Hint,48);

    tmpSQL:='select * from '+ORADB+'.tc_ocn_file where 1=1';
    if (Length(tmpFilter1)=0) and (Length(tmpFilter2)=0) then
        tmpSQL:=tmpSQL+' and 1=2';
    if Length(tmpFilter1)>0 then
       tmpSQL:=tmpSQL+' and tc_ocn01 in ('+tmpFilter1+')';
    if Length(tmpFilter2)>0 then
       tmpSQL:=tmpSQL+' and tc_ocn02 in ('+tmpFilter2+')';
    if sType=0 then
       tmpSQL:=tmpSQL+' and substr(tc_ocn12,1,1) in (''B'',''M'',''T'',''Q'')'
    else
       tmpSQL:=tmpSQL+' and substr(tc_ocn12,1,1) in (''R'',''N'',''E'',''P'')';
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:=tmpSQL;
      try
        Open;
      except
        on e:Exception do
        begin
          Application.MessageBox(PAnsiChar(e.Message),l_Hint,48);
          Exit;
        end;  
      end;
    end;

    try
      ExcelApp:=CreateOleObject('Excel.Application');
    except
      Application.MessageBox('創建Excel失敗,請重試!',l_Hint,48);
      Exit;
    end;

    isXlsOK:=False;
    try
      row:=1;
      ProgressBar1.Position:=0;
      ProgressBar1.Max:=tmpCDS.RecordCount+16;
      ProgressBar1.Visible:=True;
      ExcelApp.DisplayAlerts:=False;
      ExcelApp.WorkBooks.Add;
      ExcelApp.WorkSheets[1].Activate;
      ExcelApp.Rows[1].NumberFormat:='@';
      AddXlsHead(1, '產品編號','oeb04');
      AddXlsHead(2, '客戶產品編號','oeb11');
      AddXlsHead(3, '客戶品名','ta_oeb10');
      AddXlsHead(4, '銷售單位','oeb05');
      AddXlsHead(5, '約定交貨日','oeb15');
      AddXlsHead(6, '玻布碼','ta_oeb05');
      AddXlsHead(7, '銅箔碼','ta_oeb06');
      AddXlsHead(8, '單位','ta_oeb03');
      AddXlsHead(9, 'CCL尺寸代碼','ta_oeb04');
      AddXlsHead(10,'裁剪方式','ta_oeb07');
      AddXlsHead(11,'併裁','ta_oeb08');
      AddXlsHead(12,'經度','ta_oeb01');
      AddXlsHead(13,'緯度','ta_oeb02');
      AddXlsHead(14,'導角','ta_oeb09');
      AddXlsHead(15,'數量','oeb12');
      AddXlsHead(16,'未稅單價','oeb13');
      AddXlsHead(17,'備註序號','oao04');
      AddXlsHead(18,'備註列印碼','oao05');
      AddXlsHead(19,'備註','oao06');
      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
        Inc(row);
        ProgressBar1.Position:=ProgressBar1.Position+1;
        Application.ProcessMessages;

        if ADOQuery1.Locate('tc_ocn01;tc_ocn02',
            VarArrayOf([tmpCDS.FieldByName('custno').AsString,
                        tmpCDS.FieldByName('c_pno').AsString]),[]) then
        begin
          ExcelApp.Cells[row,1].Value:=ADOQuery1.FieldByName('tc_ocn12').AsString;
          ExcelApp.Cells[row,3].Value:=ADOQuery1.FieldByName('tc_ocn03').AsString;
          ExcelApp.Cells[row,4].Value:=ADOQuery1.FieldByName('tc_ocn19').AsString;
          ExcelApp.Cells[row,6].Value:=ADOQuery1.FieldByName('tc_ocn09').AsString;
          ExcelApp.Cells[row,7].Value:=ADOQuery1.FieldByName('tc_ocn10').AsString;
          ExcelApp.Cells[row,8].Value:=ADOQuery1.FieldByName('tc_ocn08').AsString;
          if Length(ADOQuery1.FieldByName('tc_ocn12').AsString) in [11,12,19,20] then
          begin
            ExcelApp.Cells[row,9].Value:=ADOQuery1.FieldByName('tc_ocn04').AsString;
            ExcelApp.Cells[row,10].Value:=ADOQuery1.FieldByName('tc_ocn05').AsString;
            ExcelApp.Cells[row,12].Value:=ADOQuery1.FieldByName('ta_ocn01').AsFloat;
            ExcelApp.Cells[row,13].Value:=ADOQuery1.FieldByName('ta_ocn02').AsFloat;
          end;
          if not ADOQuery1.FieldByName('tc_ocn11').IsNull then
             ExcelApp.Cells[row,11].Value:=ADOQuery1.FieldByName('tc_ocn11').AsInteger;
          ExcelApp.Cells[row,14].Value:=ADOQuery1.FieldByName('tc_ocn20').AsString;
          if not ADOQuery1.FieldByName('tc_ocn21').IsNull then
             ExcelApp.Cells[row,16].Value:=ADOQuery1.FieldByName('tc_ocn21').AsFloat;
        end;

        ExcelApp.Cells[row,2].Value:=tmpCDS.FieldByName('c_pno').AsString;
        if not tmpCDS.FieldByName('adate').IsNull then
           ExcelApp.Cells[row,5].Value:=tmpCDS.FieldByName('adate').AsDateTime;

        //特殊客戶轉換數量,加上備注
        ExcelApp.Cells[row,19].Value:=tmpCDS.FieldByName('oao06').AsString;
        tmpQty:=tmpCDS.FieldByName('qty').AsFloat;
        if Pos(UpperCase(tmpCDS.FieldByName('custno').AsString),'AC093/AC394/AC152')>0 then
        begin
          tmpSQL:=ExcelApp.Cells[row,1].Value;
          if Pos(UpperCase(LeftStr(tmpSQL,1)),'BR')>0 then //PP
          begin
            tmpSQL:=Copy(tmpSQL,4,4);       //布種
            if Pos(tmpSQL,'7628/7627/1506')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/164,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' 1RL=164YDS');
            end
            else if Pos(tmpSQL,'2116/0106/1067/2113/2313/3313')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/218,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' 1RL=218YDS');
            end
            else if Pos(tmpSQL,'1080/1078/1086')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/328,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS.FieldByName('oao06').AsString+' 1RL=328YDS');
            end;
          end;
        end;
        ExcelApp.Cells[row,15].Value:=tmpQty;

        if not tmpCDS.FieldByName('Price').IsNull then
           ExcelApp.Cells[row,16].Value:=tmpCDS.FieldByName('Price').AsFloat;
        ExcelApp.Cells[row,17].Value:=tmpCDS.FieldByName('oao04').Value;
        ExcelApp.Cells[row,18].Value:=tmpCDS.FieldByName('oao05').AsString;
        tmpCDS.Next;
      end;

      ExcelApp.Range['A1:S'+IntToStr(row)].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideHorizontal].Weight:=xlThin;
      ExcelApp.Columns.EntireColumn.AutoFit;
      ExcelApp.Range['A2'].Select;
      ExcelApp.Visible:=True;
      isXlsOK:=True;

    finally
      if not isXlsOK then
         ExcelApp.Quit;
    end;
  finally
    FreeAndNil(tmpCDS);
    ProgressBar1.Visible:=False;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  InitCDS(CDS, l_Xml);
end;

procedure TForm1.CDSBeforeInsert(DataSet: TDataSet);
begin
  l_custno:=DataSet.FieldByName('custno').AsString;
end;

procedure TForm1.CDSNewRecord(DataSet: TDataSet);
begin
  if Length(l_custno)>0 then
     DataSet.FieldByName('custno').AsString:=l_custno;
end;

procedure TForm1.btn_importClick(Sender: TObject);
var
  isFind,isMerge:Boolean;
  i,j,sno:Integer;
  tmpStr:string;
  tmpDate:TDateTime;
  tmpList:TStrings;
  tmpCDS1,tmpCDS2:TClientDataSet;
  ExcelApp:Variant;

  function ShowMsgXls(xFname:string):string;
  begin
    Application.MessageBox(PAnsiChar('第'+IntToStr(i)+'行['+DBGridEh1.FieldColumns[xFname].Title.Caption+']欄位值錯誤!'),l_Hint,48);
  end;

begin
  inherited;
  isMerge:=Application.MessageBox('相同資料[數量]是否合并?',l_Hint,36)=IdYes;

  if not OpenDialog1.Execute then
     Exit;

  with DBGridEh1 do
  for i:=0 to Columns.Count -1 do
    CDS.FieldByName(Columns[i].FieldName).DisplayLabel:=Columns[i].Title.Caption;

  tmpList:=TStringList.Create;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to sno do
    begin
      isFind:=False;
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);

      if tmpStr<>'' then
      for j:=0 to CDS.FieldCount-1 do
      if CDS.Fields[j].DisplayLabel=tmpStr then
      begin
        tmpList.Add(IntToStr(j));
        isFind:=True;
        Break;
      end;

      if not isFind then
         tmpList.Add('-1');
    end;

    if tmpList.Count=0 then
    begin
      Application.MessageBox('Excel檔案第一行的欄位名稱與作業欄位名稱不符!',l_Hint,48);
      Exit;
    end;

    tmpDate:=EncodeDate(2011,1,1);
    ProgressBar1.Position:=0;
    ProgressBar1.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    ProgressBar1.Visible:=True;
    tmpCDS1.Data:=CDS.Data;
    i:=2;
    while True do
    begin
      ProgressBar1.Position:=ProgressBar1.Position+1;
      Application.ProcessMessages;

      //全為空值,退出
      for j:=0 to tmpList.Count-1 do
      if VarToStr(ExcelApp.Cells[i,j+1].Value)<>'' then
         Break;
      if j>=tmpList.Count then
         Break;

      tmpCDS1.Append;
      for j:=0 to tmpList.Count-1 do
        if tmpList.Strings[j]<>'-1' then
           tmpCDS1.Fields[StrToInt(tmpList.Strings[j])].Value:=ExcelApp.Cells[i,j+1].Value;
      if Length(Trim(tmpCDS1.FieldByName('custno').AsString))=0 then
      begin
        ShowMsgXls('custno');
        Exit;
      end;
      if Length(Trim(tmpCDS1.FieldByName('c_pno').AsString))=0 then
      begin
        ShowMsgXls('c_pno');
        Exit;
      end;
      tmpCDS1.Post;
      Inc(i);
    end;

    if tmpCDS1.ChangeCount>0 then
       tmpCDS1.MergeChangeLog;
    tmpCDS1.First;
    tmpCDS2.Data:=CDS.Data;
    tmpCDS2.EmptyDataSet;
    while not tmpCDS1.Eof do
    begin
      if isMerge then
      begin
        if tmpCDS1.FieldByName('adate').AsDateTime>tmpDate then
           isFind:=tmpCDS2.Locate('custno;c_pno;oao04;oao05;oao06;adate',
            VarArrayOf([tmpCDS1.FieldByName('custno').AsString,
                        tmpCDS1.FieldByName('c_pno').AsString,
                        tmpCDS1.FieldByName('oao04').AsInteger,
                        tmpCDS1.FieldByName('oao05').AsString,
                        tmpCDS1.FieldByName('oao06').AsString,
                        tmpCDS1.FieldByName('adate').AsDateTime]),[])
        else
           isFind:=tmpCDS2.Locate('custno;c_pno;oao04;oao05;oao06',
            VarArrayOf([tmpCDS1.FieldByName('custno').AsString,
                        tmpCDS1.FieldByName('c_pno').AsString,
                        tmpCDS1.FieldByName('oao04').AsInteger,
                        tmpCDS1.FieldByName('oao05').AsString,
                        tmpCDS1.FieldByName('oao06').AsString]),[]);
      end else
        isFind:=False;

      if isFind then
         tmpCDS2.Edit
      else begin
         tmpCDS2.Append;
         tmpCDS2.FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
         tmpCDS2.FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('c_pno').AsString;
         if tmpCDS1.FieldByName('adate').AsDateTime>tmpDate then
            tmpCDS2.FieldByName('adate').AsDateTime:=tmpCDS1.FieldByName('adate').AsDateTime;
         if tmpCDS1.FieldByName('price').AsFloat>0 then
            tmpCDS2.FieldByName('price').AsFloat:=RoundTo(tmpCDS1.FieldByName('price').AsFloat,-6);
         if tmpCDS1.FieldByName('oao04').AsInteger>0 then
            tmpCDS2.FieldByName('oao04').AsInteger:=tmpCDS1.FieldByName('oao04').AsInteger;
         tmpCDS2.FieldByName('oao05').AsString:=tmpCDS1.FieldByName('oao05').AsString;
         tmpCDS2.FieldByName('oao06').AsString:=tmpCDS1.FieldByName('oao06').AsString;
      end;
      tmpCDS2.FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('qty').AsFloat+tmpCDS1.FieldByName('qty').AsFloat;
      tmpCDS2.Post;
      tmpCDS1.Next;
    end;
    if tmpCDS2.ChangeCount>0 then
       tmpCDS2.MergeChangeLog;
    CDS.Data:=tmpCDS2.Data;
  finally
    ProgressBar1.Visible:=False;
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    ExcelApp.Quit;
  end;
end;

procedure TForm1.btn_exportClick(Sender: TObject);
begin
  if CDS.IsEmpty then
  begin
    Application.MessageBox('無資料!',l_Hint,48);
    Exit;
  end;
  
  if Form2.ShowModal=mrOK then
     ToXls(Form2.rgp1.Items.Strings[Form2.rgp1.ItemIndex],Form2.rgp2.ItemIndex);
end;

procedure TForm1.btn_insertClick(Sender: TObject);
begin
  CDS.Append;
end;

procedure TForm1.btn_editClick(Sender: TObject);
begin
  if not CDS.IsEmpty then
     CDS.Edit;
end;

procedure TForm1.btn_deleteClick(Sender: TObject);
begin
  if not CDS.IsEmpty then
  begin
    if CDS.RecordCount=1 then
       CDS.Delete
    else
    case Application.MessageBox('刪除全部資料請按[是]'+#13#10+'刪除當前此筆資料按[否]'+#13#10+'[取消]無操作',l_Hint,35) of
      IDYes:CDS.EmptyDataSet;
      IDNo:CDS.Delete;
    end;

    SetToolBar;
  end;
end;

procedure TForm1.btn_copyClick(Sender: TObject);
var
  i:Integer;
  list: TStrings;
  arrFNE:array of TFieldNotifyEvent;
begin
  SetLength(arrFNE, CDS.FieldCount);
  for i := 0 to CDS.FieldCount - 1 do
  begin
    arrFNE[i]:=CDS.Fields[i].OnChange;
    CDS.Fields[i].OnChange:=nil;
  end;
  list:=TStringList.Create;
  try
    for i := 0 to CDS.FieldCount - 1 do
      list.Add(Trim(CDS.Fields[i].AsString));
    CDS.Append;
    for i := 0 to CDS.FieldCount - 1 do
      CDS.Fields[i].AsString := list.Strings[i];
    CDS.OnNewRecord(CDS);
  finally
    FreeAndNil(list);
    for i := 0 to CDS.FieldCount - 1 do
      CDS.Fields[i].OnChange:=arrFNE[i];
    arrFNE:=nil;    
  end;
end;

procedure TForm1.btn_postClick(Sender: TObject);
begin
  CDS.Post;
end;

procedure TForm1.btn_cancelClick(Sender: TObject);
begin
  CDS.Cancel;
end;

procedure TForm1.btn_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.CDSAfterEdit(DataSet: TDataSet);
begin
  SetToolBar;
end;

procedure TForm1.CDSAfterInsert(DataSet: TDataSet);
begin
  SetToolBar;
end;

procedure TForm1.CDSAfterCancel(DataSet: TDataSet);
begin
  SetToolBar;
end;

procedure TForm1.CDSAfterPost(DataSet: TDataSet);
begin
  SetToolBar;
end;

procedure TForm1.CDSAfterOpen(DataSet: TDataSet);
begin
  SetToolBar;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  if ActiveControl is TDBGridEh then
     DBGridEhSelNext(TDBGridEh(ActiveControl), Key);
end;

end.
