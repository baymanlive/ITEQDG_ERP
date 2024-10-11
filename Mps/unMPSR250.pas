unit unMPSR250;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmMPSR250 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSR250: TFrmMPSR250;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmMPSR250.RefreshDS(strFilter: string);
var
  data: OleVariant;
begin
  QueryBySQL('select * from mps700', data);
  CDS.data := data;
end;

procedure TFrmMPSR250.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPSR250';
  p_GridDesignAns := True;
  inherited;          //ÁcÊ^ ¦h? ¦hÁÂ
  //Â²Åé

end;

end.

