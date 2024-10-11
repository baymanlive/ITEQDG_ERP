unit unMPSI712;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmMPSI712 = class(TFrmSTDI031)
    ClientDataSet1: TClientDataSet;
    StringField1: TStringField;
    StringField2: TStringField;
    StringField3: TStringField;
    StringField4: TStringField;
    FloatField1: TFloatField;
    FloatField2: TFloatField;
    StringField5: TStringField;
    StringField6: TStringField;
    StringField7: TStringField;
    StringField8: TStringField;
    StringField9: TStringField;
    StringField10: TStringField;
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_importClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI712: TFrmMPSI712;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

{ TFrmMPSI712 }

procedure TFrmMPSI712.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS712 Where Bu=''ITEQDG'' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPSI712.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS712';
  p_GridDesignAns := True;
  inherited;
end;

procedure TFrmMPSI712.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.

