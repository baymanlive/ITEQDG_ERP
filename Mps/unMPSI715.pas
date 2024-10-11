unit unMPSI715;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmMPSI715 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI715: TFrmMPSI715;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon;
{ TFrmMPSI715 }

procedure TFrmMPSI715.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS715 Where 1=1 ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;
end;

procedure TFrmMPSI715.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS715';
  p_GridDesignAns := True;
  inherited;
end;

end.
