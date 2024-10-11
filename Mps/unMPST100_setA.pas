unit unMPST100_setA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI033, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin, Buttons, EhLibJPegImage;

type
  TFrmMPST100_setA = class(TFrmSTDI033)
    OpenDialog1: TOpenDialog;
    lblMPST100_setAmsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1Columns2EditButtonClick(Sender: TObject; var Handled: Boolean);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST100_setA: TFrmMPST100_setA;


implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST100_setA.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if strFilter = g_cFilterNothing then
    tmpSQL := ''
  else
    tmpSQL := strFilter;
  tmpSQL := 'select * from mps101 where bu=' + Quotedstr(g_UInfo^.BU) + ' ' + tmpSQL;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST100_setA.FormCreate(Sender: TObject);
begin
  p_TableName := 'mps101';

  inherited;
  Tblobfield(CDS.FieldByName('img')).BlobType := ftGraphic;
  Tblobfield(CDS.FieldByName('img2')).BlobType := ftGraphic;
  Tblobfield(CDS.FieldByName('img3')).BlobType := ftGraphic;
  Tblobfield(CDS.FieldByName('img4')).BlobType := ftGraphic;
end;

procedure TFrmMPST100_setA.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
    CDS.CancelUpdates;
  if DataSet.IsEmpty then
  begin
    SetToolBar;
    SetSBars;
  end;
end;

procedure TFrmMPST100_setA.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
    CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmMPST100_setA.CDSBeforePost(DataSet: TDataSet);
var
  ErrFName: string;

  procedure ShowM(fName: string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(fName);
    Abort;
  end;

begin
  //inherited;

  if Length(Trim(CDS.FieldByName('custno').AsString)) = 0 then
    ShowM('custno');
  if Length(Trim(CDS.FieldByName('value').AsString)) = 0 then
    ShowM('value');

  if not CheckPK(CDS, p_TableName, ErrFName) then
    Abort;
end;

procedure TFrmMPST100_setA.DBGridEh1Columns2EditButtonClick(Sender: TObject; var Handled: Boolean);
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    CDS.Edit;
    TBlobField(CDS.FieldByName(DBGridEh1.SelectedField.FieldName)).LoadFromFile(OpenDialog1.FileName);
  end;
end;

end.

