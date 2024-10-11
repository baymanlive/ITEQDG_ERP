unit unDLIR210_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, Mask, DBCtrlsEh, ComCtrls,
  ImgList, Buttons;

type
  TFrmDLIR210_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    lblto: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Rgp1: TRadioGroup;
    Rgp2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR210_Query: TFrmDLIR210_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR210_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Rgp1.Items.Clear;
  Rgp1.Items.Add('未出完');
  Rgp1.Items.Add('已出完');
  Rgp1.Items.Add('全部');
  Rgp1.Columns:=3;
  Rgp1.ItemIndex:=0;
  Rgp2.Items.Clear;
  Rgp2.Items.Add('DG訂單');
  Rgp2.Items.Add('GZ訂單');
  Rgp2.Columns:=2;
  Rgp2.ItemIndex:=0;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR210_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('查詢訂單日期的截止日期不能小於開始日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  
  if Dtp2.Date-Dtp1.Date>6 then
  begin
    ShowMsg('查詢訂單日期不能超過7天!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入客戶編號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
