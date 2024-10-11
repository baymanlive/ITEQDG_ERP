unit unQUOI060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmQUOI060 = class(TFrmSTDI031)
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
  FrmQUOI060: TFrmQUOI060;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmQUOI060.FormCreate(Sender: TObject);
begin
  p_SysId := 'quo';
  p_TableName := 'quo060';
  p_GridDesignAns := True;
  btn_import.Visible := g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
    btn_import.Left := btn_quit.Left;

  inherited;
end;

procedure TFrmQUOI060.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From quo060 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter +
    ' Order By Adhesive,fiber,width,roll,sqft';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmQUOI060.CDSBeforePost(DataSet: TDataSet);

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
  if Length(Trim(CDS.FieldByName('fiber').AsString)) = 0 then
    ShowM('fiber');
  if Length(Trim(CDS.FieldByName('width').AsString)) = 0 then
    ShowM('width');
  if Length(Trim(CDS.FieldByName('roll').AsString)) = 0 then
    ShowM('roll');
  if Length(Trim(CDS.FieldByName('sqft').AsString)) = 0 then
    ShowM('sqft');
  inherited;
end;

procedure TFrmQUOI060.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.

