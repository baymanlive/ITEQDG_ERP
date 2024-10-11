unit unDLII672;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmDLII672 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII672: TFrmDLII672;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII672.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI672 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII672.FormCreate(Sender: TObject);
begin
  p_SysId:='DLI';
  p_TableName:='DLI672';
  p_GridDesignAns:=True;
  inherited;
  SetGrdCaption(DBGridEh1, p_TableName);
end;

procedure TFrmDLII672.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('lab2').AsString))=0 then
     ShowM('lab2');
  if Length(Trim(CDS.FieldByName('lab3_6').AsString))=0 then
     ShowM('lab3_6');
  if Length(Trim(CDS.FieldByName('lab15_old').AsString))=0 then
     ShowM('lab15_old');
  if Length(Trim(CDS.FieldByName('lab15_new').AsString))=0 then
     ShowM('lab15_new');
  inherited;
end;

end.
