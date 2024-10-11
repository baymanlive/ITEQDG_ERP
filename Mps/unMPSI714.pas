unit unMPSI714;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmMPSI714 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI714: TFrmMPSI714;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}
var TGCDS:TClientDataSet;
{ TFrmMPSI714 }

procedure TFrmMPSI714.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS714 Where 1=1 ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;
end;

procedure TFrmMPSI714.FormCreate(Sender: TObject);
var sql:string;  data:OleVariant;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS714';
  p_GridDesignAns := True;
  TGCDS:=TClientDataSet.Create(self);
  sql:='select * from mps714';
  QueryBySQL(sql,data);
  TGCDS.Data:=data;
  inherited;
end;

procedure TFrmMPSI714.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TGCDS.Free;
  inherited;

end;

end.

