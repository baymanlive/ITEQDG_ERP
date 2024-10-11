unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls;

type
  TForm2 = class(TForm)
    dtp: TDateTimePicker;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TForm2.BitBtn1Click(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then
  begin
    ShowMessage('time error');
    Edit1.SetFocus;
    Exit;
  end;

  ModalResult:=mrOK;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  dtp.Date:=Date;
end;

end.
