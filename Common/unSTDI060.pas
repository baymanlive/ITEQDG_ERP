{***********************************************************}
{                                                           }
{                unSTDI060                                  }
{                Author: kaikai                             }
{                Create date:                               }
{                Description: 主從檔多筆作業                }
{                Copyright (c) 2015-9999 by ITEQ            }
{                                                           }
{***********************************************************}

unit unSTDI060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, DB, StdCtrls, ExtCtrls, unFrmBaseEmpty,
  DBGridEh, DBCtrls, unGlobal, unCommon, DBClient, 
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, unGridDesign, Menus, DateUtils, unDAL;

type
  //Grid1、Grid2是否可編輯:不可編輯、主檔可編輯、明細檔可編輯、兩者可編輯
  TEditFlag = (noEdit, mainEdit, detailEdit, allEdit);

  //Grid2位置:默認、tabsheet1右邊、 tabsheet1下面
  TGrid2Position = (isDefault, isRight, isBottom);

  //上下擺放時那一個grid高度可擴展
  TGridAnchors = (mainAnchors, detailAnchors);

type
  TFrmSTDI060 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    btn_copy: TToolButton;
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
    DBGridEh2: TDBGridEh;
    PCL: TPageControl;
    PCL2: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ToolButton1: TToolButton;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    PopupMenu1: TPopupMenu;
    N201: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    N301: TMenuItem;
    N204: TMenuItem;
    N205: TMenuItem;
    N302: TMenuItem;
    N206: TMenuItem;
    pnl: TPanel;
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
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1ColWidthsChanged(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N202Click(Sender: TObject);
    procedure N203Click(Sender: TObject);
    procedure N204Click(Sender: TObject);
    procedure N205Click(Sender: TObject);
    procedure CDS2AfterCancel(DataSet: TDataSet);
    procedure CDS2AfterDelete(DataSet: TDataSet);
    procedure CDS2AfterEdit(DataSet: TDataSet);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure CDS2BeforeDelete(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure N206Click(Sender: TObject);
    procedure DBGridEh1Exit(Sender: TObject);
    procedure DBGridEh2Exit(Sender: TObject);
  private
    { Private declarations }
    l_GridDesign1,                   //grid1設定
    l_GridDesign2:TGridDesign;       //grid2設定    
    procedure SetNewRecord(DataSet: TDataSet);   //新增設定默認值
  public
    { Public declarations }
  protected
    p_EditFlag:TEditFlag;            //主檔/明細檔可否編輯
    p_Grd2PosFlag:TGrid2Position;    //表格2位置
    p_GridAnchors:TGridAnchors;      //上下擺放時那一個grid高度可擴展

    p_SysId,                         //系統ID
    p_MainTableName,                 //CDS資料表
    p_DetailTableName,               //CDS2資料表
    p_SBText:string;                 //狀態欄顯示信息

    p_GridDesignAns1,                //grid1設定
    p_GridDesignAns2:Boolean;        //grid2設定

    procedure SetToolBar;virtual;    //設置工具欄按扭
    procedure SetSBars;virtual;      //設置狀態欄筆數
    procedure RefreshDS1(strFilter:string);virtual; //CDS查詢
    procedure RefreshDS2;virtual;                   //CDS2查詢
  end;

var
  FrmSTDI060: TFrmSTDI060;

implementation

{$R *.dfm}

procedure TFrmSTDI060.SetToolBar;
var
  isEdit,tmpBool:Boolean;
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
    btn_print.Enabled := false;
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
    btn_print.Enabled := false;
    btn_export.Enabled := false;
    btn_query.Enabled := false;
  end else
  if CDS.State=dsBrowse then
  begin
    tmpBool:=p_EditFlag in [mainEdit, allEdit];
    btn_insert.Enabled := tmpBool and g_MInfo^.R_new;
    btn_edit.Enabled := tmpBool and (not CDS.IsEmpty) and g_MInfo^.R_edit;
    btn_delete.Enabled := tmpBool and (not CDS.IsEmpty) and g_MInfo^.R_delete;
    btn_copy.Enabled := tmpBool and (not CDS.IsEmpty) and g_MInfo^.R_copy;
    btn_post.Enabled := false;
    btn_cancel.Enabled := false;
    btn_print.Enabled := g_MInfo^.R_print;
    btn_export.Enabled := g_MInfo^.R_export;
    btn_query.Enabled := g_MInfo^.R_query;
  end;

  DBGridEh1.ReadOnly:=not (p_EditFlag in [mainEdit, allEdit]);
  DBGridEh2.ReadOnly:=not (p_EditFlag in [detailEdit, allEdit]);
  if DBGridEh1.ReadOnly then
  begin
    btn_insert.Visible:=False;
    btn_edit.Visible:=False;
    btn_delete.Visible:=False;
    btn_copy.Visible:=False;
    btn_post.Visible:=False;
    btn_cancel.Visible:=false;
    ToolButton1.Visible:=false;
  end;

  if CDS.State in [dsInsert, dsEdit] then
  begin
    PCl.ActivePageIndex:=0;
    if DBGridEh1.CanFocus then
       DBGridEh1.SetFocus;
  end;

  if Self.FindComponent('PnlRight')<>nil then
  if Self.FindComponent('PnlRight') is TPanel then
     SetPnlRightBtn(TPanel(Self.FindComponent('PnlRight')),isEdit);
end;

procedure TFrmSTDI060.SetSBars;
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

procedure TFrmSTDI060.RefreshDS1(strFilter:string);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
  if CDS.Active and CDS.IsEmpty then
     RefreshDS2;
end;

procedure TFrmSTDI060.RefreshDS2;
begin
end;

procedure TFrmSTDI060.SetNewRecord(DataSet: TDataSet);
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

procedure TFrmSTDI060.FormCreate(Sender: TObject);
var
  i:Integer;
  tmpGrdEh:TGrdEh;
begin
  inherited;
  Left:=0;
  Top:=0;
  if p_Grd2PosFlag<>isDefault then
  begin
    DBGridEh2.Parent:=TabSheet1;
    PCL2.Visible:=False;
    if p_Grd2PosFlag=isRight then
    begin
      DBGridEh1.Align:=alLeft;
      DBGridEh1.Width:=450;
    end else
    if p_Grd2PosFlag=isBottom then
    begin
      if p_GridAnchors=mainAnchors then
      begin
        DBGridEh2.Align:=alBottom;
        DBGridEh2.Height:=200;
      end else
      begin
        DBGridEh1.Align:=alTop;
        DBGridEh1.Height:=200;
      end;
    end;
  end;
  Self.Caption:=g_MInfo^.ProcName;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, p_MainTableName);

  SetLength(tmpGrdEh.grdEh,2);
  SetLength(tmpGrdEh.tb,2);
  tmpGrdEh.grdEh[0]:=DBGridEh1;
  tmpGrdEh.grdEh[1]:=DBGridEh2;
  tmpGrdEh.tb[0]:=p_MainTableName;
  tmpGrdEh.tb[1]:=p_DetailTableName;
  SetMoreGrdCaption(tmpGrdEh);
  tmpGrdEh.grdEh:=nil;
  tmpGrdEh.tb:=nil;
  //SetGrdCaption(DBGridEh1, p_MainTableName);
  //SetGrdCaption(DBGridEh2, p_DetailTableName);
  
  if p_GridDesignAns1 then
     l_GridDesign1:=TGridDesign.Create(DBGridEh1, g_MInfo^.ProcId+'_1');
  if p_GridDesignAns2 then
     l_GridDesign2:=TGridDesign.Create(DBGridEh2, g_MInfo^.ProcId+'_2');
  N201.Caption:=btn_insert.Caption;
  N202.Caption:=btn_delete.Caption;
  N203.Caption:=btn_edit.Caption;
  N204.Caption:=btn_post.Caption;
  N205.Caption:=btn_cancel.Caption;
  N206.Caption:=btn_copy.Caption;
  PCl.ActivePageIndex:=0;
  RefreshDS1(g_cFilterNothing);
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(p_SBText), g_DllHandle, Self.Handle, False);
end;

procedure TFrmSTDI060.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  if p_GridDesignAns1 and Assigned(l_GridDesign1) then
     FreeAndNil(l_GridDesign1);
  if p_GridDesignAns2 and Assigned(l_GridDesign2) then
     FreeAndNil(l_GridDesign2);
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  CDS.Active:=False;
  CDS2.Active:=False;
  DBGridEh1.Free;
  DBGridEh2.Free;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmSTDI060.btn_insertClick(Sender: TObject);
begin
  CDS.Append;
end;

procedure TFrmSTDI060.btn_editClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可更改!', 48)
  else
     CDS.Edit;
end;

procedure TFrmSTDI060.btn_deleteClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定要刪除此筆資料嗎?', 33)=IDOK then
     CDS.Delete;
end;

procedure TFrmSTDI060.btn_copyClick(Sender: TObject);
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

procedure TFrmSTDI060.btn_postClick(Sender: TObject);
begin
  CDS.Post;
end;

procedure TFrmSTDI060.btn_cancelClick(Sender: TObject);
begin
  if ShowMsg('確定放棄嗎?', 33)=IDOK then
     CDS.Cancel;
end;

procedure TFrmSTDI060.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  SetLength(ArrPrintData, 2);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS.Filter;
  ArrPrintData[1].Data:=CDS2.Data;
  ArrPrintData[1].RecNo:=CDS2.RecNo;
  ArrPrintData[1].IndexFieldNames:=CDS2.IndexFieldNames;
  ArrPrintData[1].Filter:=CDS2.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmSTDI060.btn_exportClick(Sender: TObject);
begin
  case ShowMsg('匯出主檔請按[是]'+#13#10+'明細檔請按[否]'+#13#10+'取消操作請按[取消]',
     MB_YESNOCANCEL + MB_ICONQUESTION + MB_DEFBUTTON3) of
    IDYES:GetExportXls(CDS, p_MainTableName);
    IDNO:GetExportXls(CDS2, p_DetailTableName);
  end;
end;

procedure TFrmSTDI060.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  if GetQueryString(p_MainTableName, tmpStr) then
     RefreshDS1(tmpStr);
end;

procedure TFrmSTDI060.btn_firstClick(Sender: TObject);
begin
  CDS.First;
end;

procedure TFrmSTDI060.btn_priorClick(Sender: TObject);
begin
  CDS.Prior;
end;

procedure TFrmSTDI060.btn_nextClick(Sender: TObject);
begin
  CDS.Next;
end;

procedure TFrmSTDI060.btn_lastClick(Sender: TObject);
begin
  CDS.Last;
end;

procedure TFrmSTDI060.btn_quitClick(Sender: TObject);
begin
  if CDS.State in [dsInsert, dsEdit] then
     CDS.Cancel
  else if CDS2.State in [dsInsert, dsEdit] then
     CDS2.Cancel     
  else
     Close;
end;

procedure TFrmSTDI060.CDSAfterEdit(DataSet: TDataSet);
begin
  if DataSet.FindField('Muser')<>nil then
  begin
    DataSet.FieldByName('Muser').AsString:=g_UInfo^.UserId;
    DataSet.FieldByName('Mdate').AsDateTime:=Now;
  end;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI060.CDS2AfterEdit(DataSet: TDataSet);
begin
  inherited;
  if DataSet.FindField('Muser')<>nil then
  begin
    DataSet.FieldByName('Muser').AsString:=g_UInfo^.UserId;
    DataSet.FieldByName('Mdate').AsDateTime:=Now;
  end;
end;

procedure TFrmSTDI060.CDSAfterInsert(DataSet: TDataSet);
begin
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI060.CDSAfterDelete(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_MainTableName) then
  if CDS.ChangeCount>0 then
     CDS.CancelUpdates;
end;

procedure TFrmSTDI060.CDS2AfterDelete(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS2, p_DetailTableName) then
  if CDS2.ChangeCount>0 then
     CDS2.CancelUpdates;
end;

procedure TFrmSTDI060.CDSAfterCancel(DataSet: TDataSet);
begin
  if CDS.State in [dsInsert,dsEdit] then
     CDS.Cancel;
  if CDS.ChangeCount>0 then
     CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI060.CDS2AfterCancel(DataSet: TDataSet);
begin
  inherited;
  if CDS2.State in [dsInsert,dsEdit] then
     CDS2.Cancel;
  if CDS2.ChangeCount>0 then
     CDS2.CancelUpdates;
end;

procedure TFrmSTDI060.CDSAfterPost(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_MainTableName) then
  if CDS.ChangeCount>0 then
     CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSTDI060.CDS2AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS2, p_DetailTableName) then
  if CDS2.ChangeCount>0 then
     CDS2.CancelUpdates;
end;

procedure TFrmSTDI060.CDSAfterScroll(DataSet: TDataSet);
begin
  if DataSet.State=dsBrowse then  //AfterInsert, AfterCancel
  begin
    SetToolBar;
    SetSBars;
  end;

  RefreshDS2;
end;

procedure TFrmSTDI060.CDSBeforeDelete(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_delete) or (not (p_EditFlag in [mainEdit, allEdit])) then
     Abort;
end;

procedure TFrmSTDI060.CDS2BeforeDelete(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_edit) or (not (p_EditFlag in [detailEdit, allEdit])) then
     Abort;
end;

procedure TFrmSTDI060.CDSBeforeEdit(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_edit) or (not (p_EditFlag in [mainEdit, allEdit])) then
     Abort;
end;

procedure TFrmSTDI060.CDS2BeforeEdit(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_edit) or (not (p_EditFlag in [detailEdit, allEdit])) or CDS.IsEmpty then
     Abort;
end;

procedure TFrmSTDI060.CDSBeforeInsert(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_new) or (not (p_EditFlag in [mainEdit, allEdit])) then
     Abort;
end;

procedure TFrmSTDI060.CDS2BeforeInsert(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_edit) or (not (p_EditFlag in [detailEdit, allEdit])) or CDS.IsEmpty then
     Abort;
end;

procedure TFrmSTDI060.CDSBeforePost(DataSet: TDataSet);
var
  ErrFName:string;
begin
  if not CheckPK(CDS, p_MainTableName, ErrFName) then
  begin
    if DBGridEh1.CanFocus then
       DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(ErrFName);
    Abort;
  end;
end;

procedure TFrmSTDI060.CDS2BeforePost(DataSet: TDataSet);
var
  ErrFName:string;
begin
  if not CheckPK(CDS2, p_DetailTableName, ErrFName) then
  begin
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=CDS2.FieldByName(ErrFName);
    Abort;
  end;
end;

procedure TFrmSTDI060.CDSNewRecord(DataSet: TDataSet);
begin
  SetNewRecord(DataSet);
end;

procedure TFrmSTDI060.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  SetNewRecord(DataSet);
end;

procedure TFrmSTDI060.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N201.Visible:=CDS2.Active and g_MInfo^.R_edit and (p_EditFlag in [detailEdit, allEdit]);
  N202.Visible:=N201.Visible;
  N203.Visible:=N201.Visible;
  N204.Visible:=N201.Visible;
  N205.Visible:=N201.Visible;
  N206.Visible:=N201.Visible;

  if N201.Visible then
  begin
    if CDS2.State in [dsInsert,dsEdit] then
    begin
      N201.Enabled:=False;
      N202.Enabled:=False;
      N203.Enabled:=False;
      N204.Enabled:=True;
      N205.Enabled:=True;
      N206.Enabled:=False;
    end else
    begin
      N201.Enabled:=True;
      N202.Enabled:=not CDS2.IsEmpty;
      N203.Enabled:=N202.Enabled;
      N204.Enabled:=False;
      N205.Enabled:=False;
      N206.Enabled:=N202.Enabled;
    end;
  end;
end;

procedure TFrmSTDI060.N201Click(Sender: TObject);
begin
  inherited;
  CDS2.Append;
end;

procedure TFrmSTDI060.N202Click(Sender: TObject);
begin
  inherited;
  if ShowMsg('刪除後不可恢複,確定刪除嗎?',33)=IDCancel then
     Exit;
     
  CDS2.Delete;
end;

procedure TFrmSTDI060.N203Click(Sender: TObject);
begin
  inherited;
  CDS2.Edit;
end;

procedure TFrmSTDI060.N204Click(Sender: TObject);
begin
  inherited;
  if CDS2.State in [dsInsert,dsEdit] then
     CDS2.Post;
end;

procedure TFrmSTDI060.N205Click(Sender: TObject);
begin
  inherited;
  if CDS2.State in [dsInsert,dsEdit] then
     CDS2.Cancel;
end;

procedure TFrmSTDI060.N206Click(Sender: TObject);
var
  i:Integer;
  list: TStrings;
begin
  inherited;
  list:=TStringList.Create;
  try
    for i := 0 to CDS2.FieldCount - 1 do
      list.Add(Trim(CDS2.Fields[i].AsString));
    CDS2.Append;
    for i := 0 to CDS2.FieldCount - 1 do
      CDS2.Fields[i].AsString := list.Strings[i];
    CDS2NewRecord(CDS2);
  finally
    FreeAndNil(list);
  end;
end;

procedure TFrmSTDI060.DBGridEh1Exit(Sender: TObject);
begin
  inherited;
  if CDS.State in [dsInsert,dsEdit] then
     CDS.Post;
end;

procedure TFrmSTDI060.DBGridEh2Exit(Sender: TObject);
begin
  inherited;
  if CDS2.State in [dsInsert,dsEdit] then
     CDS2.Post;
end;

procedure TFrmSTDI060.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if p_GridDesignAns1 and Assigned(l_GridDesign1) then
     l_GridDesign1.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmSTDI060.DBGridEh1ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if p_GridDesignAns1 and Assigned(l_GridDesign1) then
     l_GridDesign1.ColWidthChange;
end;

procedure TFrmSTDI060.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if p_GridDesignAns2 and Assigned(l_GridDesign2) then
     l_GridDesign2.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmSTDI060.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if p_GridDesignAns2 and Assigned(l_GridDesign2) then
     l_GridDesign2.ColWidthChange;
end;

end.


