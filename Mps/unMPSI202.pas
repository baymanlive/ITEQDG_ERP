unit unMPSI202;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmMPSI202 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI202: TFrmMPSI202;


implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI202.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS202';
  p_GridDesignAns := True;
  inherited;

end;

procedure TFrmMPSI202.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS202 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

end.

