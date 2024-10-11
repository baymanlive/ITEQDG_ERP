unit unLBLI202;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmLBLI202 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLI202: TFrmLBLI202;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

{ TFrmLBLI202 }

procedure TFrmLBLI202.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From ord150 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmLBLI202.FormCreate(Sender: TObject);
begin
  p_SysId := 'LBL';
  p_TableName := 'LBL202';
  p_GridDesignAns := True;

  inherited;

end;

end.

