unit unDLII680;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, Menus, ImgList, StdCtrls,
  Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII680 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLII680: TFrmDLII680;


implementation

uses
  unGlobal, unCommon;
   
{$R *.dfm}

procedure TFrmDLII680.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From DLI680 Where Bu=' + Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLII680.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI680';
  p_GridDesignAns := True;

  inherited;
end;

end.

