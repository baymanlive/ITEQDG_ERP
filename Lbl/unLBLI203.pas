unit unLBLI203;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmLBLI203 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLI203: TFrmLBLI203;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmLBLI203.FormCreate(Sender: TObject);
begin
  p_SysId := 'lbl';
  p_TableName := 'LBL203';
  p_GridDesignAns := True;
  inherited;
end;

procedure TFrmLBLI203.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * from LBL203 where 1=1 ' + strFilter + ' order by id';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

end.

