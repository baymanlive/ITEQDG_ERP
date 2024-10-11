unit unLBLR280;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmLBLR280 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLR280: TFrmLBLR280;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon;
{ TFrmLBLR280 }

procedure TFrmLBLR280.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;

begin
  if strFilter = g_cFilterNothing then
    strFilter := ' and tc_shz06>sysdate-1 ';
  tmpSQL := 'Select * from ' + g_uinfo^.BU + '.tc_shz_file where tc_shz04=''ccljyz''' + strFilter +
    ' order by tc_shz06 desc';


  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
    CDS.Data := Data;


  inherited;
end;

procedure TFrmLBLR280.FormCreate(Sender: TObject);
begin
  p_SysId := 'lbl';
  p_TableName := 'LBLR280';
  p_GridDesignAns := True;
  inherited;
end;

end.

