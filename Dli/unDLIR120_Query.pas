unit unDLIR120_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmDLIR120_Query = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblsaleno: TLabel;
    Edit2: TEdit;
    Rgp1: TRadioGroup;
    Dtp2: TDateTimePicker;
    lblto2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR120_Query: TFrmDLIR120_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR120_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Rgp1.Items.DelimitedText:=CheckLang('未出廠,已出廠,全部');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR120_Query.btn_okClick(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入客戶編號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
