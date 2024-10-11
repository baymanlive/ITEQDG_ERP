unit unQUOI010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmQUII010 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmQUII010: TFrmQUII010;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon;
{ TFrmQUII010 }

procedure TFrmQUII010.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From QUO010 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter +
    ' Order By Adhesive,mil,structure,stcode';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmQUII010.FormCreate(Sender: TObject);
begin
  p_SysId := 'quo';
  p_TableName := 'Quo010';
  p_GridDesignAns := True;
  btn_import.Visible := g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
    btn_import.Left := btn_quit.Left;

  inherited;
end;

procedure TFrmQUII010.CDSBeforePost(DataSet: TDataSet);

  procedure ShowM(fName: string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(fName);
    Abort;
  end;

begin
  if Length(Trim(CDS.FieldByName('Adhesive').AsString)) = 0 then
    ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('mil').AsString)) = 0 then
    ShowM('mil');
  if Length(Trim(CDS.FieldByName('structure').AsString)) = 0 then
    ShowM('structure');
  if Length(Trim(CDS.FieldByName('stcode').AsString)) = 0 then
    ShowM('stcode');
  inherited;
end;

procedure TFrmQUII010.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.

