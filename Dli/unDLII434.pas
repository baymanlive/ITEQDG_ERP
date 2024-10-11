unit unDLII434;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmDLR202 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLR202: TFrmDLR202;

implementation

{$R *.dfm}

{ TFrmDLII434 }
uses
  unGlobal, unCommon;
procedure TFrmDLR202.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'select a.*,b.ddate from dli901 a join log002 b on a.orderno=b.dno left join dli014 c on ''JX-''+a.orderno=c.saleno where c.Bu is null';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLR202.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI434';
  p_GridDesignAns := True;

  inherited;
end;

end.
