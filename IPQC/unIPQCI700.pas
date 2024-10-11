unit unIPQCI700;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmIPQCI700 = class(TFrmSTDI031)
    CDSid: TAutoIncField;
    CDSA01: TStringField;
    CDSA02: TStringField;
    CDSA03: TStringField;
    CDSA04: TStringField;
    CDSA05: TStringField;
    CDSA06: TStringField;
    CDSA07: TStringField;
    CDSA08: TStringField;
    CDSA09: TStringField;
    CDSA10: TStringField;
    CDSA11: TStringField;
    CDSA12: TStringField;
    CDSA13: TStringField;
    CDSA14: TStringField;
    CDSA15: TStringField;
    CDSA16: TStringField;
    CDSA17: TStringField;
    CDSA18: TStringField;
    CDSA19: TStringField;
    CDSA20: TStringField;
    CDSA21: TStringField;
    CDSA22: TStringField;
    CDSA23: TStringField;
    CDSA24: TStringField;
    CDSA25: TStringField;
    CDSA26: TStringField;
    CDSA27: TStringField;
    CDSA28: TStringField;
    CDSA29: TStringField;
    CDSA30: TStringField;
    CDSBu: TWideStringField;
    CDSIuser: TStringField;
    CDSIdate: TDateTimeField;
    CDSMuser: TStringField;
    CDSMdate: TDateTimeField;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmIPQCI700: TFrmIPQCI700;

implementation

{$R *.dfm}

{ TFrmIPQCI700 }

uses
  unGlobal, unCommon;

procedure TFrmIPQCI700.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From IPQC700 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter + ' Order By id desc';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;
  inherited;
end;

procedure TFrmIPQCI700.FormCreate(Sender: TObject);
begin
  p_SysId:='IPQC';
  p_TableName:='IPQC700';
  p_GridDesignAns:=True;
  inherited;
end;

end.

