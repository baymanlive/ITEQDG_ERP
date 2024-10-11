{***********************************************************}
{                                                           }
{                unSTDI030                                  }
{                Author: kaikai                             }
{                Create date:                               }
{                Description: �h���@�~:PageControl+DBGridEh }
{                Copyright (c) 2015-9999 by ITEQ            }
{                                                           }
{***********************************************************}

unit unSTDI030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, DB, StdCtrls, ExtCtrls, unFrmBaseEmpty,
  DBGridEh, DBCtrls, unGlobal, unCommon, DBClient, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, unGridDesign, DateUtils,
  unDAL;

type
  TFrmSTDI030 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    btn_copy: TToolButton;
    ToolButton2: TToolButton;
    btn_print: TToolButton;
    btn_export: TToolButton;
    btn_query: TToolButton;
    ToolButton4: TToolButton;
    btn_first: TToolButton;
    btn_prior: TToolButton;
    btn_next: TToolButton;
    btn_last: TToolButton;
    ToolButton5: TToolButton;
    btn_quit: TToolButton;
    btn_post: TToolButton;
    btn_cancel: TToolButton;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    DS: TDataSource;
    Panel1: TPanel;
    CDS: TClientDataSet;
    DBGridEh1: TDBGridEh;
    PCL: TPageControl;
    TabSheet1: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterCancel(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterInsert(DataSet: TDataSet);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1ColWidthsChanged(Sender: TObject);
  private
    { Private declarations }
    l_GridDesign: TGridDesign;                    //grid�]�w
  public
    { Public declarations }
  protected
    p_SysId,                       //�t��ID
    p_TableName,                   //CDS��ƪ�
    p_SBText: string;               //���A����ܫH��
    p_GridDesignAns: Boolean;       //grid�]�w
    procedure SetToolBar; virtual;  //�]�m�u�������
    procedure SetSBars(DataSet: TDataSet); virtual;    //�]�m���A�浧��
    procedure RefreshDS(strFilter: string); virtual;   //DataSet�d��
  end;

var
  FrmSTDI030: TFrmSTDI030;

implementation

{$R *.dfm}

procedure TFrmSTDI030.SetToolBar;
var
  isEdit: Boolean;
begin
  isEdit := CDS.State in [dsInsert, dsEdit];

  if not CDS.Active then
  begin
    btn_insert.Enabled := false;
    btn_edit.Enabled := false;
    btn_delete.Enabled := false;
    btn_copy.Enabled := false;
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_print.Enabled := false;
    btn_export.Enabled := false;
    btn_query.Enabled := false;
  end
  else if isEdit then
  begin
    btn_insert.Enabled := false;
    btn_edit.Enabled := false;
    btn_delete.Enabled := false;
    btn_copy.Enabled := false;
    btn_post.Enabled := true;
    btn_cancel.Enabled := true;
    btn_print.Enabled := false;
    btn_export.Enabled := false;
    btn_query.Enabled := false;
  end
  else if CDS.State = dsBrowse then
  begin
    btn_insert.Enabled := g_MInfo^.R_new;
    btn_edit.Enabled := (not CDS.IsEmpty) and g_MInfo^.R_edit;
    btn_delete.Enabled := (not CDS.IsEmpty) and g_MInfo^.R_delete;
    btn_copy.Enabled := (not CDS.IsEmpty) and g_MInfo^.R_copy;
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_print.Enabled := g_MInfo^.R_print;
    btn_export.Enabled := g_MInfo^.R_export;
    btn_query.Enabled := g_MInfo^.R_query;
  end;

  if CDS.State in [dsInsert, dsEdit] then
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;

  if Self.FindComponent('PnlRight') <> nil then
    if Self.FindComponent('PnlRight') is TPanel then
      SetPnlRightBtn(TPanel(Self.FindComponent('PnlRight')), isEdit);
end;

procedure TFrmSTDI030.SetSBars(DataSet: TDataSet);
var
  dis_bo: Boolean;
  minNum, maxNum: Integer;
begin
  if DataSet.Active then
  begin
    if DataSet.IsEmpty or (DataSet.RecNo = -1) then
      Edit1.Text := '0'
    else
      Edit1.Text := IntToStr(DataSet.RecNo);
    Edit2.Text := IntToStr(DataSet.RecordCount);
  end
  else
  begin
    Edit1.Text := '0';
    Edit2.Text := '0';
  end;

  dis_bo := (not DataSet.Active) or (DataSet.RecordCount < 2) or (DataSet.State in [dsInsert, dsEdit]);
  minNum := StrToIntDef(Edit1.Text, 0);
  maxNum := StrToIntDef(Edit2.Text, 0);

  btn_first.Enabled := (not dis_bo) and (minNum > 1);
  btn_prior.Enabled := (not dis_bo) and (minNum > 1);
  btn_next.Enabled := (not dis_bo) and (maxNum > minNum);
  btn_last.Enabled := (not dis_bo) and (maxNum > minNum);
end;

procedure TFrmSTDI030.RefreshDS(strFilter: string);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    SetToolBar;
    SetSBars(CDS);
  end;
end;

procedure TFrmSTDI030.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  Left := 0;
  Top := 0;
  Self.Caption := g_MInfo^.ProcName;
  SetLength(g_DAL, Length(g_ConnData));
  for i := Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i] := TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, p_TableName);
  SetGrdCaption(DBGridEh1, p_TableName);
  if p_GridDesignAns then
    l_GridDesign := TGridDesign.Create(DBGridEh1);
  RefreshDS(g_cFilterNothing);
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(p_SBText), g_DllHandle, Self.Handle, False);
end;

procedure TFrmSTDI030.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    FreeAndNil(l_GridDesign);
  for i := Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  CDS.Active := False;
  DBGridEh1.Free;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmSTDI030.btn_insertClick(Sender: TObject);
begin
  CDS.Append;
end;

procedure TFrmSTDI030.btn_editClick(Sender: TObject);
begin
  if CDS.IsEmpty then
    ShowMsg('�L��ƥi���!', 48)
  else
    CDS.Edit;
end;

procedure TFrmSTDI030.btn_deleteClick(Sender: TObject);
begin
  if CDS.IsEmpty then
    ShowMsg('�L��ƥi�R��!', 48)
  else if ShowMsg('�T�w�n�R��������ƶ�?', 33) = IDOK then
    CDS.Delete;
end;

procedure TFrmSTDI030.btn_copyClick(Sender: TObject);
var
  i: Integer;
  list: TStrings;
  arrFNE: array of TFieldNotifyEvent;
begin
  SetLength(arrFNE, CDS.FieldCount);
  for i := 0 to CDS.FieldCount - 1 do
  begin
    arrFNE[i] := CDS.Fields[i].OnChange;
    CDS.Fields[i].OnChange := nil;
  end;
  list := TStringList.Create;
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
      CDS.Fields[i].OnChange := arrFNE[i];
    arrFNE := nil;
  end;
end;

procedure TFrmSTDI030.btn_postClick(Sender: TObject);
begin
  CDS.Post;
end;

procedure TFrmSTDI030.btn_cancelClick(Sender: TObject);
begin
  if ShowMsg('�T�w����?', 33) = IDOK then
    CDS.Cancel;
end;

procedure TFrmSTDI030.btn_printClick(Sender: TObject);
var
  ArrPrintData: TArrPrintData;
begin
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data := CDS.Data;
  ArrPrintData[0].RecNo := CDS.RecNo;
  ArrPrintData[0].IndexFieldNames := CDS.IndexFieldNames;
  ArrPrintData[0].Filter := CDS.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData := nil;
end;

procedure TFrmSTDI030.btn_exportClick(Sender: TObject);
begin
  GetExportXls(CDS, p_TableName);
end;

procedure TFrmSTDI030.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  if GetQueryString(p_TableName, tmpStr) then
    RefreshDS(tmpStr);
end;

procedure TFrmSTDI030.btn_firstClick(Sender: TObject);
begin
  CDS.First;
end;

procedure TFrmSTDI030.btn_priorClick(Sender: TObject);
begin
  CDS.Prior;
end;

procedure TFrmSTDI030.btn_nextClick(Sender: TObject);
begin
  CDS.Next;
end;

procedure TFrmSTDI030.btn_lastClick(Sender: TObject);
begin
  CDS.Last;
end;

procedure TFrmSTDI030.btn_quitClick(Sender: TObject);
begin
  if CDS.State in [dsInsert, dsEdit] then
    CDS.Cancel
  else
    Close;
end;

procedure TFrmSTDI030.CDSAfterEdit(DataSet: TDataSet);
begin
  if DataSet.FindField('Muser') <> nil then
  begin
    DataSet.FieldByName('Muser').AsString := g_UInfo^.UserId;
    DataSet.FieldByName('Mdate').AsDateTime := Now;
  end;
  SetToolBar;
  SetSBars(DataSet);
end;

procedure TFrmSTDI030.CDSAfterInsert(DataSet: TDataSet);
begin
  SetToolBar;
  SetSBars(DataSet);
end;

procedure TFrmSTDI030.CDSAfterDelete(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_TableName) then
    if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
end;

procedure TFrmSTDI030.CDSAfterCancel(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Cancel;
  if CDS.ChangeCount > 0 then
    CDS.CancelUpdates;
  SetToolBar;
  SetSBars(DataSet);
end;

procedure TFrmSTDI030.CDSAfterPost(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_TableName) then
    if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
  SetToolBar;
  SetSBars(DataSet);
end;

procedure TFrmSTDI030.CDSAfterScroll(DataSet: TDataSet);
begin
  if DataSet.State = dsBrowse then  //AfterInsert, AfterCancel
  begin
    SetToolBar;
    SetSBars(DataSet);
  end;
end;

procedure TFrmSTDI030.CDSBeforeDelete(DataSet: TDataSet);
begin
  if not g_MInfo^.R_delete then
    Abort;
end;

procedure TFrmSTDI030.CDSBeforeEdit(DataSet: TDataSet);
begin
  if not g_MInfo^.R_edit then
    Abort;
end;

procedure TFrmSTDI030.CDSBeforeInsert(DataSet: TDataSet);
begin
  if not g_MInfo^.R_new then
    Abort;
end;

procedure TFrmSTDI030.CDSBeforePost(DataSet: TDataSet);
var
  ErrFName: string;
begin
  if not CheckPK(CDS, p_TableName, ErrFName) then
  begin
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(ErrFName);
    Abort;
  end;
end;

procedure TFrmSTDI030.CDSNewRecord(DataSet: TDataSet);
var
  i: Integer;
begin
  if DataSet.FindField('BU') <> nil then
    DataSet.FieldByName('BU').AsString := g_UInfo^.BU;
  if DataSet.FindField('Iuser') <> nil then
  begin
    DataSet.FieldByName('Iuser').AsString := g_UInfo^.UserId;
    DataSet.FieldByName('Idate').AsDateTime := Now;
  end;
  if DataSet.FindField('Muser') <> nil then
  begin
    DataSet.FieldByName('Muser').Clear;
    DataSet.FieldByName('Mdate').Clear;
  end;
  for i := 0 to DataSet.FieldCount - 1 do
    if DataSet.Fields[i].DataType = ftBoolean then
      DataSet.Fields[i].AsBoolean := False;
end;

procedure TFrmSTDI030.DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    l_GridDesign.MouseDown(Button = mbRight, X, Y);
end;

procedure TFrmSTDI030.DBGridEh1ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    l_GridDesign.ColWidthChange;
end;

end.
