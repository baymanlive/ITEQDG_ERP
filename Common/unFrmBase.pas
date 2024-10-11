{*******************************************************}
{                                                       }
{                unFrmBase                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 基類                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unFrmBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, DB, StdCtrls, ExtCtrls, unFrmBaseEmpty,
  DBGridEh, DBCtrls, unGlobal, unCommon, DBClient, DateUtils, unSvr, unDAL;

type
  TFrmBase = class(TFrmBaseEmpty)
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
    DS1: TDataSource;
    Panel1: TPanel;
    CDS1: TClientDataSet;
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
    procedure CDS1AfterEdit(DataSet: TDataSet);
    procedure CDS1NewRecord(DataSet: TDataSet);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure CDS1AfterPost(DataSet: TDataSet);
    procedure CDS1AfterCancel(DataSet: TDataSet);
    procedure CDS1AfterDelete(DataSet: TDataSet);
    procedure CDS1BeforeDelete(DataSet: TDataSet);
    procedure CDS1BeforeEdit(DataSet: TDataSet);
    procedure CDS1BeforeInsert(DataSet: TDataSet);
    procedure CDS1BeforePost(DataSet: TDataSet);
    procedure CDS1AfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
    procedure SetSBars;           //設置狀態欄筆數
  public
    { Public declarations }
  protected
    p_SysId,                       //系統ID
    p_TableName,                   //CDS1資料表
    p_SBText:string;               //狀態欄顯示信息
    p_FocusCtrl:TWinControl;       //編輯狀態,此控件獲得焦點
    procedure SetToolBar;virtual;  //設置工具按扭
    procedure RefreshDS(strFilter:string);virtual; //DataSet查詢
  end;

var
  FrmBase: TFrmBase;

implementation

{$R *.dfm}

procedure TFrmBase.SetToolBar;
begin
  if (not CDS1.Active) or (CDS1.State in [dsOpening,dsInactive])then
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
  end else
  if CDS1.State in [dsInsert, dsEdit] then
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
  end else
  if CDS1.State=dsBrowse then
  begin
    btn_insert.Enabled := g_MInfo^.R_new;
    btn_edit.Enabled := (not CDS1.IsEmpty) and g_MInfo^.R_edit;
    btn_delete.Enabled := (not CDS1.IsEmpty) and g_MInfo^.R_delete;
    btn_copy.Enabled := (not CDS1.IsEmpty) and g_MInfo^.R_copy;
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_print.Enabled := g_MInfo^.R_print;
    btn_export.Enabled := g_MInfo^.R_export;
    btn_query.Enabled := g_MInfo^.R_query;
  end;

  if CDS1.State in [dsInsert, dsEdit] then
  if (p_FocusCtrl<>nil) and p_FocusCtrl.CanFocus then
  begin
    p_FocusCtrl.SetFocus;
    if p_FocusCtrl is TDBEdit then
      (p_FocusCtrl as TDBEdit).SelectAll;
  end;
end;

procedure TFrmBase.SetSBars;
var
  dis_bo:Boolean;
  minNum, maxNum:Integer;
begin    
  if CDS1.Active then
  begin
    if CDS1.IsEmpty or (CDS1.RecNo=-1) then
       Edit1.Text:='0'
    else
       Edit1.Text:=IntToStr(CDS1.RecNo);
    Edit2.Text:=IntToStr(CDS1.RecordCount);
  end else
  begin
    Edit1.Text:='0';
    Edit2.Text:='0';
  end;

  dis_bo:=(not CDS1.Active) or (CDS1.RecordCount<2) or (CDS1.State in [dsInsert, dsEdit]);
  minNum:=StrToIntDef(Edit1.Text, 0);
  maxNum:=StrToIntDef(Edit2.Text, 0);

  btn_first.Enabled := (not dis_bo) and (minNum>1);
  btn_prior.Enabled := (not dis_bo) and (minNum>1);
  btn_next.Enabled := (not dis_bo) and (maxNum>minNum);
  btn_last.Enabled := (not dis_bo) and (maxNum>minNum);
end;

procedure TFrmBase.RefreshDS(strFilter:string);
begin
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
end;

procedure TFrmBase.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  Left:=0;
  Top:=0;  
  Self.Caption:=g_MInfo^.ProcName;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, p_TableName);
  RefreshDS(g_cFilterNothing);
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(p_SBText), g_DllHandle, Self.Handle, False);
end;

procedure TFrmBase.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  CDS1.Active:=False;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmBase.btn_insertClick(Sender: TObject);
begin
  CDS1.Append;
end;

procedure TFrmBase.btn_editClick(Sender: TObject);
begin
  if CDS1.IsEmpty then
     ShowMsg('無資料可更改!', 48)
  else
     CDS1.Edit;
end;

procedure TFrmBase.btn_deleteClick(Sender: TObject);
begin
  if CDS1.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定要刪除此筆資料嗎?', 33)=IDOK then
     CDS1.Delete;
end;

procedure TFrmBase.btn_copyClick(Sender: TObject);
var
  i:Integer;
  list: TStrings;
begin
  list:=TStringList.Create;
  try
    for i := 0 to CDS1.FieldCount - 1 do
      list.Add(Trim(CDS1.Fields[i].AsString));
    CDS1.Append;
    for i := 0 to CDS1.FieldCount - 1 do
      CDS1.Fields[i].AsString := list.Strings[i];
    CDS1NewRecord(CDS1);
  finally
    FreeAndNil(list);
  end;
end;

procedure TFrmBase.btn_postClick(Sender: TObject);
begin
  CDS1.Post;
end;

procedure TFrmBase.btn_cancelClick(Sender: TObject);
begin
  if ShowMsg('確定放棄嗎?', 33)=IDOK then
     CDS1.Cancel;
end;

procedure TFrmBase.btn_printClick(Sender: TObject);
begin
//
end;

procedure TFrmBase.btn_exportClick(Sender: TObject);
begin
//
end;

procedure TFrmBase.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  if GetQueryString(p_TableName, tmpStr) then
     RefreshDS(tmpStr);
end;

procedure TFrmBase.btn_firstClick(Sender: TObject);
begin
  CDS1.First;
end;

procedure TFrmBase.btn_priorClick(Sender: TObject);
begin
  CDS1.Prior;
end;

procedure TFrmBase.btn_nextClick(Sender: TObject);
begin
  CDS1.Next;
end;

procedure TFrmBase.btn_lastClick(Sender: TObject);
begin
  CDS1.Last;
end;

procedure TFrmBase.btn_quitClick(Sender: TObject);
begin
  if CDS1.State in [dsInsert, dsEdit] then
     CDS1.Cancel
  else
     Close;
end;

procedure TFrmBase.CDS1AfterEdit(DataSet: TDataSet);
begin
  if DataSet.FindField('Muser')<>nil then
  begin
    DataSet.FieldByName('Muser').AsString:=g_UInfo^.UserId;
    DataSet.FieldByName('Mdate').AsDateTime:=Now;
  end;
  SetToolBar;
  SetSBars;
end;

procedure TFrmBase.CDS1AfterInsert(DataSet: TDataSet);
begin
  SetToolBar;
  SetSBars;
end;

procedure TFrmBase.CDS1NewRecord(DataSet: TDataSet);
var
  i:Integer;
begin
  if DataSet.FindField('BU')<>nil then
     DataSet.FieldByName('BU').AsString:=g_UInfo^.BU;
  if DataSet.FindField('Iuser')<>nil then
  begin
    DataSet.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
    DataSet.FieldByName('Idate').AsDateTime:=Now;
  end;
  if DataSet.FindField('Muser')<>nil then
  begin
    DataSet.FieldByName('Muser').Clear;
    DataSet.FieldByName('Mdate').Clear;
  end;
  for i:=0 to DataSet.FieldCount-1 do
    if DataSet.Fields[i].DataType=ftBoolean then
       DataSet.Fields[i].AsBoolean:=False;
end;

procedure TFrmBase.CDS1AfterDelete(DataSet: TDataSet);
begin
  if not CDSPost(CDS1, p_TableName) then
     CDS1.CancelUpdates;
  if DataSet.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
end;

procedure TFrmBase.CDS1AfterCancel(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert,dsEdit] then
     DataSet.Cancel;
  if CDS1.ChangeCount>0 then
     CDS1.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmBase.CDS1AfterPost(DataSet: TDataSet);
begin
  if not CDSPost(CDS1, p_TableName) then
     CDS1.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmBase.CDS1AfterScroll(DataSet: TDataSet);
begin
  if DataSet.State=dsBrowse then  //AfterInsert, AfterCancel
  begin
    SetToolBar;
    SetSBars;
  end;    
end;

procedure TFrmBase.CDS1BeforeDelete(DataSet: TDataSet);
begin
  if not g_MInfo^.R_delete then
     Abort;
end;

procedure TFrmBase.CDS1BeforeEdit(DataSet: TDataSet);
begin
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmBase.CDS1BeforeInsert(DataSet: TDataSet);
begin
  if not g_MInfo^.R_new then
     Abort;
end;

procedure TFrmBase.CDS1BeforePost(DataSet: TDataSet);
var
  ErrFName:string;
begin
  if not CheckPK(CDS1, p_TableName, ErrFName) then
     Abort;
end;


end.
