unit unLBLI150;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmLBLI150 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLI150: TFrmLBLI150;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon;
{ TFrmLBLI150 }

procedure TFrmLBLI150.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From lbl150 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter + ' order by metric';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmLBLI150.FormCreate(Sender: TObject);
begin
  p_SysId := 'lbl';
  p_TableName := 'lbl150';
  p_GridDesignAns := True;
  inherited;
end;

end.

