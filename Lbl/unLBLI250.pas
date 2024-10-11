unit unLBLI250;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmLBLI250 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLI250: TFrmLBLI250;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

{ TFrmLBLI250 }

procedure TFrmLBLI250.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From LBL250 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter + '  order by metric';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmLBLI250.FormCreate(Sender: TObject);
begin
  p_SysId := 'LBL';
  p_TableName := 'LBL250';
  p_GridDesignAns := True;
  inherited;

end;

procedure TFrmLBLI250.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('uuid').AsString := guid;
end;

end.

