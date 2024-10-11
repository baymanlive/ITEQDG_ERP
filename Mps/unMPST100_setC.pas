unit unMPST100_setC;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI033, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmMPST100_setC = class(TFrmSTDI033)
    lblMPST100_setCmsg: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST100_setC: TFrmMPST100_setC;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST100_setC.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if strFilter=g_cFilterNothing then
     tmpSQL:=''
  else
     tmpSQL:=strFilter;
  tmpSQL:='select * from mps103 where bu='+Quotedstr(g_UInfo^.BU)+' '+tmpSQL;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPST100_setC.FormCreate(Sender: TObject);
begin
  p_TableName:='mps103';

  inherited;
end;

procedure TFrmMPST100_setC.CDSAfterDelete(DataSet: TDataSet);
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

procedure TFrmMPST100_setC.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

  if not CDSPost(CDS, p_TableName) then
     CDS.CancelUpdates;
  SetToolBar;
  SetSBars;
end;

procedure TFrmMPST100_setC.CDSBeforePost(DataSet: TDataSet);
var
  ErrFName:string;

  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  //inherited;

  if Length(Trim(CDS.FieldByName('oz').AsString))=0 then
     ShowM('oz');
  if Length(Trim(CDS.FieldByName('mil_l').AsString))<>4 then
     ShowM('mil_l');
  if Length(Trim(CDS.FieldByName('mil_h').AsString))<>4 then
     ShowM('mil_h');
  if CDS.FieldByName('value').AsInteger<=0 then
     ShowM('value');

  if not CheckPK(CDS, p_TableName, ErrFName) then
     Abort;
end;

end.
