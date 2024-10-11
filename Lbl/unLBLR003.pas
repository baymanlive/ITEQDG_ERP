unit unLBLR003;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin;

type
  TFrmLBLR003 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmLBLR003: TFrmLBLR003;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon;

procedure TFrmLBLR003.FormCreate(Sender: TObject);
begin
  p_SysId := 'lbl';
  p_TableName := 'LBL003';
  p_GridDesignAns := True;
  inherited;
end;

procedure TFrmLBLR003.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * from LBL003 where 1=1 '+ strFilter +' order by id desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;

end;

end.

