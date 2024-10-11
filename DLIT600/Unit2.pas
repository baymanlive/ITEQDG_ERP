unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm2 = class(TForm)
    rgp1: TRadioGroup;
    rgp2: TRadioGroup;
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.btn_okClick(Sender: TObject);
begin
  ModalResult:=mrOK;
end;

procedure TForm2.btn_quitClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
 