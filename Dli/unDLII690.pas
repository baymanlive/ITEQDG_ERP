unit unDLII690;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmDLII690 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLII690: TFrmDLII690;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

{ TFrmDLII690 }

procedure TFrmDLII690.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From DLI690 Where Bu=' + Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLII690.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI690';
  p_GridDesignAns := True;

  inherited;
end;

end.

