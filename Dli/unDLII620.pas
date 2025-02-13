{*******************************************************}
{                                                       }
{                unDLII620                              }
{                Author: KaiKai                         }
{                Create date: 2018/3/22                 }
{                Description: 客戶品名檢核              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII620;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII620 = class(TFrmSTDI030)
    dlii620_ts1: TTabSheet;
    dlii620_ts2: TTabSheet;
    dlii620_ts3: TTabSheet;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    DBGridEh4: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    CDS4: TClientDataSet;
    DS4: TDataSource;
    PopupMenu1: TPopupMenu;
    N201: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    N206: TMenuItem;
    N204: TMenuItem;
    N205: TMenuItem;
    dlii620_ts4: TTabSheet;
    dlii620_ts5: TTabSheet;
    dlii620_ts6: TTabSheet;
    dlii620_ts7: TTabSheet;
    DBGridEh5: TDBGridEh;
    DBGridEh6: TDBGridEh;
    DBGridEh7: TDBGridEh;
    DBGridEh8: TDBGridEh;
    CDS5: TClientDataSet;
    DS5: TDataSource;
    CDS6: TClientDataSet;
    DS6: TDataSource;
    CDS7: TClientDataSet;
    DS7: TDataSource;
    CDS8: TClientDataSet;
    DS8: TDataSource;
    btn_dlii620: TToolButton;
    dlii620_ts8: TTabSheet;
    DBGridEh9: TDBGridEh;
    CDS9: TClientDataSet;
    DS9: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N202Click(Sender: TObject);
    procedure N203Click(Sender: TObject);
    procedure N204Click(Sender: TObject);
    procedure N205Click(Sender: TObject);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure CDS4BeforePost(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure CDS2AfterEdit(DataSet: TDataSet);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSAfterInsert(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure CDS5BeforePost(DataSet: TDataSet);
    procedure CDS6BeforePost(DataSet: TDataSet);
    procedure CDS7BeforePost(DataSet: TDataSet);
    procedure CDS8BeforePost(DataSet: TDataSet);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_dlii620Click(Sender: TObject);
    procedure CDS9BeforePost(DataSet: TDataSet);
  private
    { Private declarations }
    function BeforePost(DataSet: TDataSet; grd:TDBGridEh):Boolean;
    procedure RefreshOthDS(Flag:Integer);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII620: TFrmDLII620;

implementation

uses unGlobal,unCommon, unDLII620_set;
   
{$R *.dfm}

procedure TFrmDLII620.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI620 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And CodeId=0 '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII620.RefreshOthDS(Flag:Integer);
var
  Data:OleVariant;

  function GetSQL(CodeId:Integer):string;
  begin
    Result:='Select * From '+p_TableName+' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And CodeId='+IntToStr(CodeId);
    if Flag=0 then
       Result:=Result+' '+g_cFilterNothing;
  end;
begin
  if not QueryBySQL(GetSQL(1), Data) then
     Exit;
  CDS2.Data:=Data;

  if Flag=0 then
  begin
    CDS3.Data:=Data;
    CDS4.Data:=Data;
    CDS5.Data:=Data;
    CDS6.Data:=Data;
    CDS7.Data:=Data;
    CDS8.Data:=Data;
    CDS9.Data:=Data;
    Exit;
  end;

  Data:=null;
  if not QueryBySQL(GetSQL(2), Data) then
     Exit;
  CDS3.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(3), Data) then
     Exit;
  CDS4.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(4), Data) then
     Exit;
  CDS5.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(5), Data) then
     Exit;
  CDS6.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(6), Data) then
     Exit;
  CDS7.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(7), Data) then
     Exit;
  CDS8.Data:=Data;

  Data:=null;
  if not QueryBySQL(GetSQL(8), Data) then
     Exit;
  CDS9.Data:=Data;
end;

procedure TFrmDLII620.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  p_SysId:='Dli';
  p_TableName:='DLI620';
  p_GridDesignAns:=False;
  p_SBText:=CheckLang('客戶=0:普通客戶,值=/:不檢查;第1頁使用工具欄操作,其它頁使用[右鍵]');
  btn_dlii620.Left:=btn_quit.Left;
  
  inherited;

  TabSheet1.Caption:=CheckLang('第2碼');
  RefreshOthDS(0);
  SetGrdCaption(DBGridEh4,'DLI620');
  for i:=0 to DBGridEh1.Columns.Count-1 do
  begin
    DBGridEh2.FieldColumns[DBGridEh1.Columns[i].FieldName].Title.Caption:=DBGridEh1.Columns[i].Title.Caption;
    DBGridEh3.FieldColumns[DBGridEh1.Columns[i].FieldName].Title.Caption:=DBGridEh1.Columns[i].Title.Caption;
    DBGridEh5.FieldColumns[DBGridEh1.Columns[i].FieldName].Title.Caption:=DBGridEh1.Columns[i].Title.Caption;
    DBGridEh7.FieldColumns[DBGridEh1.Columns[i].FieldName].Title.Caption:=DBGridEh1.Columns[i].Title.Caption;
    DBGridEh8.FieldColumns[DBGridEh1.Columns[i].FieldName].Title.Caption:=DBGridEh1.Columns[i].Title.Caption;

    DBGridEh2.FieldColumns[DBGridEh1.Columns[i].FieldName].Width:=DBGridEh1.Columns[i].Width;
    DBGridEh3.FieldColumns[DBGridEh1.Columns[i].FieldName].Width:=DBGridEh1.Columns[i].Width;
    DBGridEh5.FieldColumns[DBGridEh1.Columns[i].FieldName].Width:=DBGridEh1.Columns[i].Width;
    DBGridEh7.FieldColumns[DBGridEh1.Columns[i].FieldName].Width:=DBGridEh1.Columns[i].Width;
    DBGridEh8.FieldColumns[DBGridEh1.Columns[i].FieldName].Width:=DBGridEh1.Columns[i].Width;
  end;
  for i:=0 to DBGridEh4.Columns.Count-1 do
  begin
    DBGridEh6.FieldColumns[DBGridEh4.Columns[i].FieldName].Title.Caption:=DBGridEh4.Columns[i].Title.Caption;
    DBGridEh6.FieldColumns[DBGridEh4.Columns[i].FieldName].Width:=DBGridEh4.Columns[i].Width;
    DBGridEh9.FieldColumns[DBGridEh4.Columns[i].FieldName].Title.Caption:=DBGridEh4.Columns[i].Title.Caption;
    DBGridEh9.FieldColumns[DBGridEh4.Columns[i].FieldName].Width:=DBGridEh4.Columns[i].Width;
  end;
  DBGridEh2.FieldColumns['lstcode'].Title.Caption:=CheckLang('倒數第2碼');
  PCL.ActivePageIndex :=0;
end;

procedure TFrmDLII620.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  CDS4.Active:=False;
  CDS5.Active:=False;
  CDS6.Active:=False;
  CDS7.Active:=False;
  CDS8.Active:=False;
  CDS9.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
  DBGridEh5.Free;
  DBGridEh6.Free;
  DBGridEh7.Free;
  DBGridEh8.Free;
  DBGridEh9.Free;
end;

function TFrmDLII620.BeforePost(DataSet: TDataSet; grd:TDBGridEh):Boolean;
var
  ErrFName:string;

  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, grd.FieldColumns[fName].Title.Caption);
    if grd.CanFocus then
       grd.SetFocus;
    grd.SelectedField:=DataSet.FieldByName(fName);
  end;
begin
  Result:=False;
  if Length(Trim(DataSet.FieldByName('CustNo').AsString))=0 then
  begin
    ShowM('CustNo');
    Exit;
  end;

  if Length(Trim(DataSet.FieldByName('Code').AsString))=0 then
  begin
    ShowM('Code');
    Exit;
  end;

  if Length(Trim(DataSet.FieldByName('LstCode').AsString))=0 then
  begin
    ShowM('LstCode');
    Exit;
  end;

  if not CheckPK(DataSet, p_TableName, ErrFName) then
  begin
    if grd.CanFocus then
       grd.SetFocus;
    grd.SelectedField:=DataSet.FieldByName(ErrFName);
    Exit;
  end;

  Result:=True;
end;

procedure TFrmDLII620.CDSBeforePost(DataSet: TDataSet);
begin
  if not BeforePost(DataSet, DBGridEh1) then
     Abort;
end;

procedure TFrmDLII620.CDS2BeforePost(DataSet: TDataSet);
begin
  if not BeforePost(DataSet, DBGridEh2) then
     Abort;
end;

procedure TFrmDLII620.CDS3BeforePost(DataSet: TDataSet);
begin
  if not BeforePost(DataSet, DBGridEh3) then
     Abort;
end;

procedure TFrmDLII620.CDS4BeforePost(DataSet: TDataSet);
begin
  if not BeforePost(DataSet, DBGridEh4) then
     Abort;
end;

procedure TFrmDLII620.CDS5BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not BeforePost(DataSet, DBGridEh5) then
     Abort;
end;

procedure TFrmDLII620.CDS6BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not BeforePost(DataSet, DBGridEh6) then
     Abort;
end;

procedure TFrmDLII620.CDS7BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not BeforePost(DataSet, DBGridEh7) then
     Abort;
end;

procedure TFrmDLII620.CDS8BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not BeforePost(DataSet, DBGridEh8) then
     Abort;
end;

procedure TFrmDLII620.PopupMenu1Popup(Sender: TObject);
var
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpCDS:=nil;
  case PCL.ActivePageIndex of
    1:tmpCDS:=CDS2;
    2:tmpCDS:=CDS3;
    3:tmpCDS:=CDS4;
    4:tmpCDS:=CDS9;
    5:tmpCDS:=CDS5;
    6:tmpCDS:=CDS6;
    7:tmpCDS:=CDS7;
    8:tmpCDS:=CDS8;
  end;

  N201.Visible:=tmpCDS.Active and g_MInfo^.R_edit;
  N202.Visible:=N201.Visible;
  N203.Visible:=N201.Visible;
  N204.Visible:=N201.Visible;
  N205.Visible:=N201.Visible;

  if N201.Visible then
  begin
    if tmpCDS.State in [dsInsert,dsEdit] then
    begin
      N201.Enabled:=False;
      N202.Enabled:=False;
      N203.Enabled:=False;
      N204.Enabled:=True;
      N205.Enabled:=True;
    end else
    begin
      N201.Enabled:=True;
      N202.Enabled:=not tmpCDS.IsEmpty;
      N203.Enabled:=N202.Enabled;
      N204.Enabled:=False;
      N205.Enabled:=False;
    end;
  end;
end;

procedure TFrmDLII620.N201Click(Sender: TObject);
begin
  inherited;
  case PCL.ActivePageIndex of
    1:CDS2.Append;
    2:CDS3.Append;
    3:CDS4.Append;
    4:CDS9.Append;
    5:CDS5.Append;
    6:CDS6.Append;
    7:CDS7.Append;
    8:CDS8.Append;
  end;
end;

procedure TFrmDLII620.N202Click(Sender: TObject);
begin
  inherited;
  if ShowMsg('刪除後不可恢複,確定刪除嗎?',33)=IDCancel then
     Exit;

  case PCL.ActivePageIndex of
    1:begin
        CDS2.Delete;
        if not CDSPost(CDS2, p_TableName) then
           CDS2.CancelUpdates;
      end;
    2:begin
        CDS3.Delete;
        if not CDSPost(CDS3, p_TableName) then
           CDS3.CancelUpdates;
      end;
    3:begin
        CDS4.Delete;
        if not CDSPost(CDS4, p_TableName) then
           CDS4.CancelUpdates;
      end;
    4:begin
        CDS9.Delete;
        if not CDSPost(CDS9, p_TableName) then
           CDS9.CancelUpdates;
      end;
    5:begin
        CDS5.Delete;
        if not CDSPost(CDS5, p_TableName) then
           CDS5.CancelUpdates;
      end;
    6:begin
        CDS6.Delete;
        if not CDSPost(CDS6, p_TableName) then
           CDS6.CancelUpdates;
      end;
    7:begin
        CDS7.Delete;
        if not CDSPost(CDS7, p_TableName) then
           CDS7.CancelUpdates;
      end;
    8:begin
        CDS8.Delete;
        if not CDSPost(CDS8, p_TableName) then
           CDS8.CancelUpdates;
      end;
  end;
end;

procedure TFrmDLII620.N203Click(Sender: TObject);
begin
  inherited;
  case PCL.ActivePageIndex of
    1:CDS2.Edit;
    2:CDS3.Edit;
    3:CDS4.Edit;
    4:CDS9.Edit;
    5:CDS5.Edit;
    6:CDS6.Edit;
    7:CDS7.Edit;
    8:CDS8.Edit;
  end;
end;

procedure TFrmDLII620.N204Click(Sender: TObject);
begin
  inherited;
  case PCL.ActivePageIndex of
    1:if CDS2.State in [dsInsert,dsEdit] then CDS2.Post;
    2:if CDS3.State in [dsInsert,dsEdit] then CDS3.Post;
    3:if CDS4.State in [dsInsert,dsEdit] then CDS4.Post;
    4:if CDS9.State in [dsInsert,dsEdit] then CDS9.Post;
    5:if CDS5.State in [dsInsert,dsEdit] then CDS5.Post;
    6:if CDS6.State in [dsInsert,dsEdit] then CDS6.Post;
    7:if CDS7.State in [dsInsert,dsEdit] then CDS7.Post;
    8:if CDS8.State in [dsInsert,dsEdit] then CDS8.Post;
  end;
end;

procedure TFrmDLII620.N205Click(Sender: TObject);
begin
  inherited;
  case PCL.ActivePageIndex of
    1:if CDS2.State in [dsInsert,dsEdit] then CDS2.Cancel;
    2:if CDS3.State in [dsInsert,dsEdit] then CDS3.Cancel;
    3:if CDS4.State in [dsInsert,dsEdit] then CDS4.Cancel;
    4:if CDS9.State in [dsInsert,dsEdit] then CDS9.Cancel;
    5:if CDS5.State in [dsInsert,dsEdit] then CDS5.Cancel;
    6:if CDS6.State in [dsInsert,dsEdit] then CDS6.Cancel;
    7:if CDS7.State in [dsInsert,dsEdit] then CDS7.Cancel;
    8:if CDS8.State in [dsInsert,dsEdit] then CDS8.Cancel;
  end;
end;

procedure TFrmDLII620.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('CodeId').AsInteger:=0;
end;

procedure TFrmDLII620.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Bu').AsString:=g_UInfo^.BU;
  DataSet.FieldByName('Iuser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Idate').AsDateTime:=Now;
  case PCL.ActivePageIndex of
    1:DataSet.FieldByName('CodeId').AsInteger:=1;
    2:DataSet.FieldByName('CodeId').AsInteger:=2;
    3:DataSet.FieldByName('CodeId').AsInteger:=3;
    4:DataSet.FieldByName('CodeId').AsInteger:=8;
    5:DataSet.FieldByName('CodeId').AsInteger:=4;
    6:DataSet.FieldByName('CodeId').AsInteger:=5;
    7:DataSet.FieldByName('CodeId').AsInteger:=6;
    8:DataSet.FieldByName('CodeId').AsInteger:=7;
  end;
end;

procedure TFrmDLII620.CDS2BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_new then
     Abort;
end;

procedure TFrmDLII620.CDS2BeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmDLII620.CDS2AfterEdit(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Muser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Mdate').AsDateTime:=Now;
end;

procedure TFrmDLII620.CDS2AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(TClientDataSet(DataSet), p_TableName) then
     TClientDataSet(DataSet).CancelUpdates;
end;

procedure TFrmDLII620.CDSAfterEdit(DataSet: TDataSet);
begin
  inherited;
  PCL.ActivePageIndex:=0;
end;

procedure TFrmDLII620.CDSAfterInsert(DataSet: TDataSet);
begin
  inherited;
  PCL.ActivePageIndex:=0;
end;

procedure TFrmDLII620.btn_printClick(Sender: TObject);
begin
//  inherited;
end;

procedure TFrmDLII620.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case PCL.ActivePageIndex of
    0:GetExportXls(CDS, p_TableName);
    1:GetExportXls(CDS2, p_TableName);
    2:GetExportXls(CDS3, p_TableName);
    3:GetExportXls(CDS4, p_TableName);
    4:GetExportXls(CDS9, p_TableName);
    5:GetExportXls(CDS5, p_TableName);
    6:GetExportXls(CDS6, p_TableName);
    7:GetExportXls(CDS7, p_TableName);
    8:GetExportXls(CDS8, p_TableName);
  end;
end;

procedure TFrmDLII620.btn_queryClick(Sender: TObject);
begin
//  inherited;
  RefreshDS('');
  RefreshOthDS(1);
end;

procedure TFrmDLII620.btn_insertClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_editClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_deleteClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_copyClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_postClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_cancelClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_firstClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_priorClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_nextClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_lastClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLII620.btn_dlii620Click(Sender: TObject);
begin
  inherited;
  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,你沒有此操作權限!',48);
    Exit;
  end;

  if not Assigned(FrmDLII620_set) then
     FrmDLII620_set:=TFrmDLII620_set.Create(Application);
  FrmDLII620_set.ShowModal;
end;

procedure TFrmDLII620.CDS9BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not BeforePost(DataSet, DBGridEh9) then
     Abort;
end;

end.
