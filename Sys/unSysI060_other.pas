unit unSysI060_other;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI033, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmSysI060_other = class(TFrmSTDI033)
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmSysI060_other: TFrmSysI060_other;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmSysI060_other.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select * from sys_report where bu='+Quotedstr(g_UInfo^.BU)
         +' and procid like ''other%'' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmSysI060_other.FormCreate(Sender: TObject);
begin
  p_TableName:='Sys_Report';

  inherited;
end;

procedure TFrmSysI060_other.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
     CDS.CancelUpdates;
  if DataSet.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
end;

procedure TFrmSysI060_other.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
     CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmSysI060_other.CDSBeforePost(DataSet: TDataSet);
var
  ErrFName:string;
begin
  //inherited;

  if not SameText(Copy(DataSet.FieldByName('procid').AsString,1,5),'other') then
  begin
    ShowMsg('[%s]請以關鍵字"other"開始!', 48,DBGridEh1.FieldColumns['procid'].Title.Caption);
    Abort;
  end;

  if not CheckPK(CDS, p_TableName, ErrFName) then
     Abort;
end;

end.
