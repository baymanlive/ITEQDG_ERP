unit unDLIR110_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, Mask, DBCtrlsEh, ComCtrls,
  ImgList, Buttons;

type
  TFrmDLIR110_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Dtp3: TDBDateTimeEditEh;
    lblto: TLabel;
    Label1: TLabel;
    Dtp4: TDBDateTimeEditEh;
    Label3: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Rgp: TRadioGroup;
    lblsaledate: TLabel;
    Label4: TLabel;
    Dtp5: TDBDateTimeEditEh;
    Dtp6: TDBDateTimeEditEh;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR110_Query: TFrmDLIR110_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR110_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label3.Caption:=lblto.Caption;
  Label4.Caption:=lblto.Caption;
  Label5.Caption:=CheckLang('1. 指定[客戶編號]條件,可查詢90天內訂單資料');
  Label6.Caption:=CheckLang('2. 未指定[客戶編號]條件,只可查詢1天內訂單資料');
  Rgp.Items.Clear;
  Rgp.Items.Add(CheckLang('未出完'));
  Rgp.Items.Add(CheckLang('已出完'));
  Rgp.Items.Add(CheckLang('全部'));
  Rgp.Columns:=3;
  Rgp.ItemIndex:=0;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR110_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('查詢訂單日期的截止日期不能小於開始日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit1.Text))=0 then
  begin
    if Dtp1.Date<>Dtp2.Date then
    begin
      ShowMsg('訂單日期不相同'+#13#10+'未指定[客戶編號]條件,只可查詢1天內訂單資料',48);
      Dtp1.SetFocus;
      Exit;
    end;
  end else
  begin
    if Dtp2.Date-Dtp1.Date>89 then
    begin
      ShowMsg('查詢訂單日期不能超過90天!',48);
      Dtp1.SetFocus;
      Exit;
    end;
  end;

  if (not VarIsNull(Dtp3.Value)) and (not VarIsNull(Dtp4.Value)) then
  if Dtp3.Value>Dtp4.Value then
  begin
    ShowMsg('查詢達客戶日期的截止日期不能小於開始日期!',48);
    Dtp3.SetFocus;
    Exit;
  end;

  if (not VarIsNull(Dtp5.Value)) and (not VarIsNull(Dtp6.Value)) then
  if Dtp5.Value>Dtp6.Value then
  begin
    ShowMsg('查詢出貨日期的截止日期不能小於開始日期!',48);
    Dtp5.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
