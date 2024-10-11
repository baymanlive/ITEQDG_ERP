{*******************************************************}
{                                                       }
{                unSTDI033                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 本地緩存多筆作業,不提交   }
{                             (非作業)                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unSTDI033;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, DB, StdCtrls, ExtCtrls, unFrmBaseEmpty,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DBClient, unGlobal, unCommon;

type
  TFrmSTDI033 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    btn_copy: TToolButton;
    ToolButton2: TToolButton;
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
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
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
    procedure CDSAfterInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    p_TableName:string;            //CDS資料表
    procedure SetToolBar;virtual;  //設置工具欄按扭
    procedure SetSBars;virtual;    //設置狀態欄筆數
    procedure RefreshDS(strFilter:string);virtual; //DataSet查詢
  end;

var
  FrmSTDI033: TFrmSTDI033;

implementation

{$R *.dfm}

procedure TFrmSTDI033.SetToolBar;
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
    btn_query.Enabled := false;
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
    btn_query.Enabled := false;
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
    btn_query.Enabled := True;
  end;
  
  if CDS.State in [dsInsert, dsEdit] then
  if DBGridEh1.CanFocus then
     DBGridEh1.SetFocus;

  if Self.FindComponent('PnlRight')<>nil then
  if Self.FindComponent('PnlRight') is TPanel then
     SetPnlRightBtn(TPanel(Self.FindComponent('PnlRight')),isEdit);
end;

procedure TFrmSTDI033.SetSBars;
var
  dis_bo:Boolean;
  minNum, maxNum:Integer;
begin    
  if CDS.Active then
  begin
    if CDS.IsEmpty or (CDS.RecNo=-1) then
       Edit1.Text:='0'
    else
       Edit1.Text:=IntToStr(CDS.RecNo);
    Edit2.Text:=IntToStr(CDS.RecordCount);
  end else
  begin
    Edit1.Text:='0';
    Edit2.Text:='0';
  end;

  dis_bo:=(not CDS.Active) or (CDS.RecordCount<2) or (CDS.State in [dsInsert, dsEdit]);
  minNum:=StrToIntDef(Edit1.Text, 0);
  maxNum:=StrToIntDef(Edit2.Text, 0);

  btn_first.Enabled := (not dis_bo) and (minNum>1);
  btn_prior.Enabled := (not dis_bo) and (minNum>1);
  btn_next.Enabled := (not dis_bo) and (maxNum>minNum);
  btn_last.Enabled := (not dis_bo) and (maxNum>minNum);
end;

procedure TFrmSTDI033.RefreshDS(strFilter:string);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
end;

procedure TFrmSTDI033.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Caption:=g_MInfo^.ProcName;
  SetLabelCaption(Self, p_TableName);
  SetGrdCaption(DBGridEh1, p_TableName);
  RefreshDS(g_cFilterNothing);
end;

procedure TFrmSTDI033.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  DBGridEh1.Free;
end;

procedure TFrmSTDI033.btn_insertClick(Sender: TObject);
begin
  CDS.Append;
end;

procedure TFrmSTDI033.btn_editClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可更改!', 48)
  else
     CDS.Edit;
end;

procedure TFrmSTDI033.btn_deleteClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定要刪除此筆資料嗎?', 33)=IDOK then
     CDS.Delete;
end;

procedure TFrmSTDI033.btn_copyClick(Sender: TObject);
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

procedure TFrmSTDI033.btn_postClick(Sender: TObject);
begin
  CDS.Post;
end;

procedure TFrmSTDI033.btn_cancelClick(Sender: TObject);
begin
  if ShowMsg('確定放棄嗎?', 33)=IDOK then
     CDS.Cancel;
end;

procedure TFrmSTDI033.btn_exportClick(Sender: TObject);
begin
  GetExportXls(CDS, p_TableName);
end;

procedure TFrmSTDI033.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  if GetQueryString(p_TableName, tmpStr) then
     RefreshDS(tmpStr);
end;

procedure TFrmSTDI033.btn_firstClick(Sender: TObject);
begin
  CDS.First;
end;

procedure TFrmSTDI033.btn_priorClick(Sender: TObject);
begin
  CDS.Prior;
end;

procedure TFrmSTDI033.btn_nextClick(Sender: TObject);
begin
  CDS.Next;
end;

procedure TFrmSTDI033.btn_lastClick(Sender: TObject);
begin
  CDS.Last;
end;

procedure TFrmSTDI033.btn_quitClick(Sender: TObject);
begin
  if CDS.State in [dsInsert, dsEdit] then
     CDS.Cancel
  else
     Close;
end;

procedure TFrmSTDI033.CDSAfterEdit(DataSet: TDataSet);
begin
  if DataSet.FindField('Muser')<>nil then
  begin
    DataSet.FieldByName('Muser').AsString:=g_UInfo^.UserId;
    DataSet.FieldByName('Mdate').AsDateTime:=Now;
  end;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI033.CDSAfterInsert(DataSet: TDataSet);
begin
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI033.CDSAfterDelete(DataSet: TDataSet);
begin
  CDS.MergeChangeLog;
end;

procedure TFrmSTDI033.CDSAfterCancel(DataSet: TDataSet);
begin
  if DataSet.State in [dsInsert,dsEdit] then
     DataSet.Cancel;
  if CDS.ChangeCount>0 then
     CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI033.CDSAfterPost(DataSet: TDataSet);
begin
  CDS.MergeChangeLog;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI033.CDSAfterScroll(DataSet: TDataSet);
begin
  if DataSet.State=dsBrowse then  //AfterInsert, AfterCancel
  begin
    SetToolBar;
    SetSBars;
  end;    
end;

procedure TFrmSTDI033.CDSNewRecord(DataSet: TDataSet);
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

end.
