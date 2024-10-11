unit unMPST160;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls,
  StdCtrls, ExtCtrls, ToolWin;

type
  TFrmMPST160 = class(TFrmSTDI030)
    procedure btn_queryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST160: TFrmMPST160;


implementation

{$R *.dfm}
uses
  unGlobal, unCommon;

procedure TFrmMPST160.btn_queryClick(Sender: TObject);
var
  sql: string;
  data: OleVariant;
begin
  sql := 'select * from tc_shz_file where tc_shz04=''MPS160''';
  if QueryBySQL(sql, data, 'ORACLE') then
    CDS.data := data;
end;

procedure TFrmMPST160.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'TC_SHZ_FILE';
  p_GridDesignAns := True;
  inherited;
//  with DBGridEh1 do
//  begin
//    FindFieldColumn('tc_shz01').Title.Caption := checklang('工單號');
//    FindFieldColumn('tc_shz02').Title.Caption := checklang('料號');
//    FindFieldColumn('tc_shz03').Title.Caption := checklang('批號');
//    FindFieldColumn('tc_shz08').Title.Caption := checklang('異常類型');
//    FindFieldColumn('tc_shz09').Title.Caption := checklang('取樣位置');
//  end;
end;

procedure TFrmMPST160.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From tc_shz_file where 1<>1';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST160.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('tc_shz04').asstring := 'MPS160';
  DataSet.FieldByName('tc_shz06').AsDateTime := date;
  DataSet.FieldByName('tc_shz07').asstring := g_uinfo^.UserId;
end;

procedure TFrmMPST160.CDSAfterPost(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_TableName, 'ORACLE') then
    if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
  SetToolBar;
  SetSBars(DataSet);
end;

procedure TFrmMPST160.CDSAfterDelete(DataSet: TDataSet);
begin
  if not CDSPost(CDS, p_TableName, 'ORACLE') then
    if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
end;

procedure TFrmMPST160.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;

end;

end.

