unit unMPSI710_Steal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, db, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  GridsEh, DBAxisGridsEh, DBGridEh, DBClient;

type
  TFrmMPSI710_Steal = class(TForm)
    DS: TDataSource;
    DBGridEh1: TDBGridEh;
  private
    FSourceCDS: TClientDataSet;
  public
    constructor Create(AOwner: TComponent; data: OleVariant); overload;
  end;

var
  FrmMPSI710_Steal: TFrmMPSI710_Steal;

implementation

{$R *.dfm}

{ TFrmMPSI710_Steal }

constructor TFrmMPSI710_Steal.Create(AOwner: TComponent; data: OleVariant);
begin
  inherited Create(AOwner);
  if data <> null then
  begin
    FSourceCDS := TClientDataSet.Create(Self);
    FSourceCDS.Data := data;
    DS.DataSet := FSourceCDS;
  end;
end;

end.

