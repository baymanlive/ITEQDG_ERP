unit unExport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, Menus, ExtCtrls, ToolWin, StdCtrls,
  Buttons, DB, DBClient, MConnect, SConnect, Mask, DBCtrls, unFrmBaseEmpty,
  unGlobal, unCommon, ShellApi, unDAL;

type
  TFrmExport = class(TFrmBaseEmpty)
    Panel2: TPanel;
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    SrcList: TListBox;
    btn_IncludeBtn: TSpeedButton;
    btn_IncAllBtn: TSpeedButton;
    btn_ExcludeBtn: TSpeedButton;
    btn_ExcAllBtn: TSpeedButton;
    DstList: TListBox;
    btn_up: TSpeedButton;
    btn_down: TSpeedButton;
    gb1: TGroupBox;
    gb2: TGroupBox;
    btn_reset: TBitBtn;
    chkAll: TCheckBox;
    Panel1: TPanel;
    btn_save: TBitBtn;
    procedure m_quitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_IncludeBtnClick(Sender: TObject);
    procedure btn_IncAllBtnClick(Sender: TObject);
    procedure btn_ExcludeBtnClick(Sender: TObject);
    procedure btn_ExcAllBtnClick(Sender: TObject);
    procedure btn_upClick(Sender: TObject);
    procedure btn_downClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_resetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_saveClick(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    procedure MoveSelected(List: TCustomListBox; Items: TStrings);
    procedure SetItem(List: TListBox; Index: Integer);
    function GetFirstSelection(List: TCustomListBox): Integer;
    procedure SetButtons;
    procedure LoadDstList(isInit:Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmExport: TFrmExport;

implementation

uses unExportXLS;

{$R *.dfm}

procedure TFrmExport.MoveSelected(List: TCustomListBox; Items: TStrings);
var
  I: Integer;
begin
  for I := List.Items.Count - 1 downto 0 do
    if List.Selected[I] then
    begin
      Items.AddObject(List.Items[I], List.Items.Objects[I]);
      List.Items.Delete(I);
    end;
end;

procedure TFrmExport.SetButtons;
var
  SrcEmpty, DstEmpty: Boolean;
begin
  SrcEmpty := SrcList.Items.Count = 0;
  DstEmpty := DstList.Items.Count = 0;
  btn_IncludeBtn.Enabled := not SrcEmpty;
  btn_IncAllBtn.Enabled := not SrcEmpty;
  btn_ExcludeBtn.Enabled := not DstEmpty;
  btn_ExcAllBtn.Enabled := not DstEmpty;
  btn_up.Enabled := not DstEmpty;
  btn_down.Enabled := not DstEmpty;
end;

function TFrmExport.GetFirstSelection(List: TCustomListBox): Integer;
begin
  for Result := 0 to List.Items.Count - 1 do
    if List.Selected[Result] then Exit;
  Result := LB_ERR;
end;

procedure TFrmExport.SetItem(List: TListBox; Index: Integer);
var
  MaxIndex: Integer;
begin
  with List do
  begin
    SetFocus;
    MaxIndex := List.Items.Count - 1;
    if Index = LB_ERR then Index := 0
    else if Index > MaxIndex then Index := MaxIndex;
    Selected[Index] := True;
  end;
  SetButtons;
end;

procedure TFrmExport.LoadDstList(isInit:Boolean);
var
  k:Integer;
  tmpList:TStrings;
  tmpCDS1,tmpCDS2:TClientDataSet;
  tmpFname,tmpSQL:string;
  Data1,Data2:OleVariant;

  procedure LoadUserObj();
  var
    i,j:Integer;
  begin
    tmpSQL:='Select Lower(FName) FieldName From Sys_Export'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And UserId='+Quotedstr(g_UInfo^.UserId)
           +' And ProcId='+Quotedstr(g_ExportObj.ProcId)
           +' And TableName='+Quotedstr(g_ExportObj.TableName);
    if not QueryBySQL(tmpSQL, Data1) then
       Exit;

    tmpCDS1.Data:=Data1;
    if not tmpCDS1.IsEmpty then
    begin
      if Length(tmpCDS1.Fields[0].AsString)>0 then
         tmpList.DelimitedText:=tmpCDS1.Fields[0].AsString;
      for i:=0 to tmpList.Count -1 do
      begin
        tmpFname:=tmpList.Strings[i];
        if tmpCDS2.Locate('FieldName',tmpFname,[]) then
        begin
          tmpSQL:=tmpCDS2.Fields[1].AsString;
          if Trim(tmpSQL)='' then
             tmpSQL:=tmpCDS2.Fields[0].AsString;
          for j:=0 to l_CDS.FieldCount-1 do
          if SameText(l_CDS.Fields[j].FieldName,tmpFname) then
          begin
            l_CDS.Fields[j].DisplayLabel:=tmpSQL;
            l_CDS.Fields[j].Tag:=1;
          end;
          DstList.Items.Add(tmpSQL);
        end
      end;
    end;
  end;

begin
  SrcList.Clear;
  DstList.Clear;

  tmpSQL:='Select Lower(FieldName) FieldName,Caption From Sys_TableDetail'
         +' Where TableName='+Quotedstr(g_ExportObj.TableName)
         +' And IsExport=1';
  if not QueryBySQL(tmpSQL, Data2) then
     Exit;

  tmpList:=TStringList.Create;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS2.Data:=Data2;
    if isInit then
       LoadUserObj;

    for k:=0 to l_CDS.FieldCount -1 do
    begin
      tmpSQL:=LowerCase(l_CDS.Fields[k].FieldName);
      if tmpCDS2.Locate('FieldName',tmpSQL,[]) then
      begin
        tmpSQL:=tmpCDS2.Fields[1].AsString;
        if Trim(tmpSQL)='' then
           tmpSQL:=tmpCDS2.Fields[0].AsString;
        l_CDS.Fields[k].DisplayLabel:=tmpSQL;
        if tmpList.Count=0 then
           DstList.Items.Add(tmpSQL)
        else if DstList.Items.IndexOf(tmpSQL)=-1 then
           SrcList.Items.Add(tmpSQL);
        l_CDS.Fields[k].Tag:=1;
      end else
        l_CDS.Tag:=0;
    end;

  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmExport.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  l_CDS:=TClientDataSet.Create(Self);
  SetLabelCaption(Self, 'FrmExport');
end;

procedure TFrmExport.FormShow(Sender: TObject);
begin
  inherited;
  l_CDS.Data:=g_ExportObj.Data;
//  l_CDS.IndexFieldNames:=g_ExportObj.IndexFieldNames;
  LoadDstList(True);
  SetButtons;
  if Pos(UpperCase(g_ExportObj.TableName),'MPS010/MPS070/MPS650')>0 then
     chkAll.Visible:=False;
end;

procedure TFrmExport.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  l_CDS.Active:=False;
  FreeAndNil(l_CDS);
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
end;

procedure TFrmExport.m_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmExport.btn_okClick(Sender: TObject);
var
  Xls:TExportXls;
begin
  if DstList.Items.Count=0 then
  begin
    ShowMsg('請選取要匯出的欄位!', 48);
    Exit;
  end;

  if g_ExportObj.RecNo>0 then
     l_CDS.RecNo:=g_ExportObj.RecNo;
  Xls:=TExportXls.Create(l_CDS, DstList.Items);
  if UpperCase(g_ExportObj.TableName)='MPS010' then
     Xls.ToXls_MPSI010
  else
  if UpperCase(g_ExportObj.TableName)='MPS070' then
     Xls.ToXls_MPSI070
  else
     Xls.ToXls_Clipboard(chkAll.Checked, g_ExportObj.ProcId);
  Xls.Free;
  Close;
end;

procedure TFrmExport.btn_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmExport.btn_resetClick(Sender: TObject);
begin
  LoadDstList(False);
  SetButtons;
end;

procedure TFrmExport.btn_saveClick(Sender: TObject);
var
  i,j:Integer;
  tmpCDS:TClientDataSet;
  tmpFname,tmpSQL:string;
  Data:OleVariant;
begin
  if DstList.Count=0 then
  begin
    ShowMsg('請至少選擇一個匯出欄位!',48);
    Exit;
  end;

  tmpFname:='';
  for i:=0 to DstList.Items.Count-1 do
  for j:=0 to l_CDS.FieldCount-1 do
  if (l_CDS.Fields[j].Tag=1) and (DstList.Items.Strings[i]=l_CDS.Fields[j].DisplayLabel) then
  begin
    tmpFname:=tmpFname+','+l_CDS.Fields[j].FieldName;
    Break;
  end;

  if Length(tmpFname)=0 then
  begin
    ShowMsg('請至少選擇一個匯出欄位!',48);
    Exit;
  end;

  Delete(tmpFname,1,1);

  tmpSQL:='Select * From Sys_Export'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And UserId='+Quotedstr(g_UInfo^.UserId)
         +' And ProcId='+Quotedstr(g_ExportObj.ProcId)
         +' And TableName='+Quotedstr(g_ExportObj.TableName);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if IsEmpty then
      begin
        Append;
        FieldByName('Bu').AsString:=g_UInfo^.BU;
        FieldByName('UserId').AsString:=g_UInfo^.UserId;
        FieldByName('ProcId').AsString:=g_ExportObj.ProcId;
        FieldByName('TableName').AsString:=g_ExportObj.TableName;
        FieldByName('Iuser').AsString:=g_UInfo^.UserId;
        FieldByName('Idate').AsDateTime:=Now;
      end else
      begin
        Edit;
        FieldByName('Muser').AsString:=g_UInfo^.UserId;
        FieldByName('Mdate').AsDateTime:=Now;
      end;          
      FieldByName('FName').AsString:=tmpFname;
      Post;
    end;

    if CDSPost(tmpCDS,'Sys_Export') then
       ShowMsg('儲存成功!',64);
       
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmExport.btn_IncludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(SrcList);
  MoveSelected(SrcList, DstList.Items);
  SetItem(SrcList, Index);
end;

procedure TFrmExport.btn_ExcludeBtnClick(Sender: TObject);
var
  Index: Integer;
begin
  Index := GetFirstSelection(DstList);
  MoveSelected(DstList, SrcList.Items);
  SetItem(DstList, Index);
end;

procedure TFrmExport.btn_IncAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to SrcList.Items.Count - 1 do
    DstList.Items.AddObject(SrcList.Items[I],
      SrcList.Items.Objects[I]);
  SrcList.Items.Clear;
  SetItem(SrcList, 0);
end;

procedure TFrmExport.btn_ExcAllBtnClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to DstList.Items.Count - 1 do
    SrcList.Items.AddObject(DstList.Items[I], DstList.Items.Objects[I]);
  DstList.Items.Clear;
  SetItem(DstList, 0);
end;

procedure TFrmExport.btn_upClick(Sender: TObject);
var
  CurIndex, NewIndex: Integer;
begin
  if (DstList.Items.Count>0) and (DstList.ItemIndex >= 0) then
  begin
    CurIndex := DstList.ItemIndex;
    if CurIndex = 0 then
      NewIndex := DstList.Items.Count-1
    else
      NewIndex := CurIndex - 1;
    DstList.Items.Move(CurIndex, NewIndex);
    DstList.ItemIndex:= NewIndex;
    DstList.Selected[NewIndex]:=True;
  end;
end;

procedure TFrmExport.btn_downClick(Sender: TObject);
var
  CurIndex, NewIndex: Integer;
begin
  if (DstList.Items.Count>0) and (DstList.ItemIndex >= 0) then
  begin
    CurIndex := DstList.ItemIndex;
    if CurIndex = DstList.Items.Count-1 then
      NewIndex := 0
    else
      NewIndex := CurIndex + 1;
    DstList.Items.Move(CurIndex, NewIndex);
    DstList.ItemIndex := NewIndex;
    DstList.Selected[NewIndex]:=True;
  end;
end;

procedure TFrmExport.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then
     ShellExecute(Handle, nil, PAnsiChar('Help\export.html'), nil, nil, SW_SHOWNORMAL)
  else
     inherited;
end;

end.
