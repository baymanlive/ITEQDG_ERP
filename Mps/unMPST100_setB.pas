unit unMPST100_setB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI033, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin, Buttons, EhLibJPegImage;

type
  TFrmMPST100_setB = class(TFrmSTDI033)
    OpenDialog1: TOpenDialog;
    lblMPST100_setBmsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1Columns3EditButtonClick(Sender: TObject;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST100_setB: TFrmMPST100_setB;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST100_setB.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if strFilter = g_cFilterNothing then
    tmpSQL := ''
  else
    tmpSQL := strFilter;
  tmpSQL := 'select * from mps102 where bu=' + Quotedstr(g_UInfo^.BU) + ' ' + tmpSQL;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST100_setB.FormCreate(Sender: TObject);
begin
  p_TableName := 'mps102';

  inherited;
  Tblobfield(CDS.FieldByName('img')).BlobType := ftGraphic;
end;

procedure TFrmMPST100_setB.CDSAfterDelete(DataSet: TDataSet);
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

procedure TFrmMPST100_setB.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
    CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmMPST100_setB.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('ad').AsString)) = 0 then
    ShowM('ad');
  if Length(Trim(CDS.FieldByName('value').AsString)) = 0 then
    ShowM('value');

  if not CheckPK(CDS, p_TableName, ErrFName) then
    Abort;
end;

procedure TFrmMPST100_setB.DBGridEh1Columns3EditButtonClick(
  Sender: TObject; var Handled: Boolean);
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    CDS.Edit;
    TBlobField(CDS.FieldByName('img')).LoadFromFile(OpenDialog1.FileName);
  end;
end;

end.

