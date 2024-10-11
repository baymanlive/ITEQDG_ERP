unit unMPST070_bom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, StdCtrls, ExtCtrls, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  Buttons, DBClient;

type
  TFrmMPST070_bom = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    Label2: TLabel;
    Edit2: TEdit;
    rgp: TRadioGroup;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
  private
    l_BomCDS: TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_bom: TFrmMPST070_bom;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST070_bom.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption := CheckLang('物品料號：');
  Label2.Caption := CheckLang('數量：');
  with DBGridEh1 do
  begin
    FieldColumns['bmb03'].Title.Caption := CheckLang('元件料號');
    FieldColumns['ima02'].Title.Caption := CheckLang('品名');
    FieldColumns['ima021'].Title.Caption := CheckLang('規格');
    FieldColumns['bmb06'].Title.Caption := CheckLang('組成用量');
    FieldColumns['bmb10'].Title.Caption := CheckLang('單位');
    FieldColumns['bmb08'].Title.Caption := CheckLang('損耗率');
    FieldColumns['useqty'].Title.Caption := CheckLang('單位使用量');
    FieldColumns['totqty'].Title.Caption := CheckLang('合計使用量');
    FieldColumns['bmb03'].Width := 100;
    FieldColumns['ima02'].Width := 100;
    FieldColumns['ima021'].Width := 120;
    FieldColumns['bmb06'].Width := 70;
    FieldColumns['bmb10'].Width := 40;
    FieldColumns['bmb08'].Width := 70;
    FieldColumns['useqty'].Width := 100;
    FieldColumns['totqty'].Width := 70;
  end;
  l_BomCDS := TClientDataSet.Create(Self);
  DS.DataSet := l_BomCDS;

  rgp.ItemIndex := 0;
  if (not SameText(g_UInfo^.BU, 'ITEQDG')) and (not SameText(g_UInfo^.BU, 'ITEQGZ')) then
  begin
    rgp.Items.Strings[0] := g_UInfo^.BU;
    rgp.Visible := False;
  end;
end;

procedure TFrmMPST070_bom.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_BomCDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST070_bom.btn_okClick(Sender: TObject);
var
  tmpStr1: string;
  tmpQty: Double;
  Data: OleVariant;
begin
  //inherited;

  tmpStr1 := Trim(Edit1.Text);
  if Length(tmpStr1) = 0 then
  begin
    ShowMsg('請輸入物品料號!', 48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpQty := StrToFloatDef(Trim(Edit2.Text), 0);

  tmpStr1 := 'exec [dbo].[proc_GetBOM] ' + QuotedStr(rgp.Items[rgp.ItemIndex]) + ',' + QuotedStr(tmpStr1) + ',' + FloatToStr(tmpQty);
  if not QueryBySQL(tmpStr1, Data) then
    Exit;
  l_BomCDS.Data := Data;
end;

procedure TFrmMPST070_bom.btn_quitClick(Sender: TObject);
begin
//  inherited;
  close;
end;

end.

