unit unMPST100_setE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI033, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, jpeg,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin, Buttons, ADODB, EhLibJPegImage;

type
  TFrmMPST100_setE = class(TFrmSTDI033)
    OpenDialog1: TOpenDialog;
    lblMPST100_setEmsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1Columns2EditButtonClick(Sender: TObject; var Handled: Boolean);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST100_setE: TFrmMPST100_setE;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST100_setE.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if strFilter = g_cFilterNothing then
    tmpSQL := ''
  else
    tmpSQL := strFilter;
  tmpSQL := 'select * from mps016 where bu=' + Quotedstr(g_UInfo^.BU) + ' ' + tmpSQL;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST100_setE.FormCreate(Sender: TObject);
begin
  p_TableName := 'mps016';

  inherited;
  Tblobfield(CDS.FieldByName('img1')).BlobType := ftGraphic;
  Tblobfield(CDS.FieldByName('img2')).BlobType := ftGraphic;
end;

procedure TFrmMPST100_setE.CDSAfterDelete(DataSet: TDataSet);
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

procedure TFrmMPST100_setE.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
    CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmMPST100_setE.CDSBeforePost(DataSet: TDataSet);
begin
  //inherited;
end;

procedure TFrmMPST100_setE.DBGridEh1Columns2EditButtonClick(Sender: TObject; var Handled: Boolean);
begin
  inherited;
  if OpenDialog1.Execute then
  begin
    CDS.Edit;
    TBlobField(CDS.FieldByName('img')).LoadFromFile(OpenDialog1.FileName);
  end;
end;

procedure TFrmMPST100_setE.CDSNewRecord(DataSet: TDataSet);

  function NewId: string;
  var
    Guid: TGUID;
  begin
    CreateGUID(Guid);
    result := GUIDToString(Guid);
  end;

begin
  inherited;
  DataSet.FieldByName('uuid').AsString := NewId;
end;

procedure TFrmMPST100_setE.DBGridEh1EditButtonClick(Sender: TObject);
begin
  if Pos('img', LowerCase(DBGridEh1.SelectedField.FieldName)) = 0 then
    exit;
  if OpenDialog1.Execute then
  begin
    CDS.Edit;
    TBlobField(CDS.FieldByName(DBGridEh1.SelectedField.FieldName)).LoadFromFile(OpenDialog1.FileName);
  end;
end;

end.

