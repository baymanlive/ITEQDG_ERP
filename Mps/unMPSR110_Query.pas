unit unMPSR110_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPSR110_Query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR110_Query: TFrmMPSR110_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR110_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('起始生產日期：');
  Label2.Caption:=CheckLang('客戶編號：');
  Label3.Caption:=CheckLang('膠系(第2碼)：');
  Label4.Caption:=CheckLang('客戶,膠系多個值用逗號('','')間隔');
  Label5.Caption:=CheckLang('厚度(4碼)：');
  Label6.Caption:=CheckLang('至');
  dtp.Date:=Date;
end;

procedure TFrmMPSR110_Query.btn_okClick(Sender: TObject);
var
  len:Integer;
begin
  len:=Length(Trim(Edit3.Text));
  if (len>0) and (len<>4) then
  begin
    ShowMsg('厚度請輸入4碼',48);
    Edit3.SetFocus;
    Exit;
  end;

  len:=Length(Trim(Edit4.Text));
  if (len>0) and (len<>4) then
  begin
    ShowMsg('厚度請輸入4碼',48);
    Edit4.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
