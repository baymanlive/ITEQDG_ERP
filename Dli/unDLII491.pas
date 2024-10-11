unit unDLII491;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmDLII491 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLII491: TFrmDLII491;


implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmDLII491.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI491';
  p_GridDesignAns := True;
  inherited;
end;

procedure TFrmDLII491.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From DLI491 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

end.

