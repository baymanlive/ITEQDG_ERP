unit unIPQCT621;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmIPQCT621 = class(TFrmSTDI041)
    btn_edit: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
  private
    l_UserCDS:TClientDataSet;
    procedure opt_uidChange(Sender:TField);
    procedure conf_uidChange(Sender:TField);
    procedure SetUname(xUidValue, xFName:string);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmIPQCT621: TFrmIPQCT621;

implementation

uses unGlobal, unCommon, unIPQCT621_edit;

{$R *.dfm}

{ TFrmIPQCT621 }

procedure TFrmIPQCT621.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.Bu)+' and isnull(garbageflag,0)=0 '+strFilter+' order by idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
     
  SetToolBar;

  inherited;
end;

procedure TFrmIPQCT621.SetToolBar;
begin
  btn_edit.Enabled:=(not CDS.IsEmpty) and g_MInfo^.R_edit;
  inherited;
end;

procedure TFrmIPQCT621.SetUname(xUidValue, xFName:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if not l_UserCDS.Active then
  begin
    tmpSQL:='select userid,username from sys_user where bu='+Quotedstr(g_UInfo^.BU)
           +' and isnull(not_use,0)=0';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    l_UserCDS.Data:=Data;
  end;

  CDS.FieldByName(xFname).Clear;
  if l_UserCDS.Active then
  if l_UserCDS.Locate('userid',xUidValue,[loCaseInsensitive]) then
     CDS.FieldByName(xFname).AsString:=l_UserCDS.Fields[1].AsString;
end;

procedure TFrmIPQCT621.conf_uidChange(Sender: TField);
begin
  SetUname(TField(Sender).AsString, 'conf_uname');
end;

procedure TFrmIPQCT621.opt_uidChange(Sender: TField);
begin
  SetUname(TField(Sender).AsString, 'opt_uname');
end;

procedure TFrmIPQCT621.FormCreate(Sender: TObject);
begin
  p_SysId:='ipqc';
  p_TableName:='ipqc620';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('鼠標雙擊記錄,可編輯資料');
  btn_edit.Left:=btn_print.Left;

  inherited;

  l_UserCDS:=TClientDataSet.Create(Self);
end;

procedure TFrmIPQCT621.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_UserCDS);
end;

procedure TFrmIPQCT621.btn_editClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmIPQCT621_edit) then
     FrmIPQCT621_edit:=TFrmIPQCT621_edit.Create(Application);
  FrmIPQCT621_edit.ShowModal;
end;

procedure TFrmIPQCT621.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if not btn_edit.Enabled then
     Exit;
     
  if not Assigned(FrmIPQCT621_edit) then
     FrmIPQCT621_edit:=TFrmIPQCT621_edit.Create(Application);
  FrmIPQCT621_edit.ShowModal;
end;

procedure TFrmIPQCT621.CDSAfterEdit(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
  CDS.FieldByName('mdate').AsDateTime:=Now;
end;

procedure TFrmIPQCT621.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('opt_uid').OnChange:=opt_uidChange;
  CDS.FieldByName('conf_uid').OnChange:=conf_uidChange;
end;

procedure TFrmIPQCT621.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    if Length(tmpStr)=0 then
       tmpStr:=' and idate>getdate()-180';
    RefreshDS(tmpStr);
  end;
end;

end.
