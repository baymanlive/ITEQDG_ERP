unit unFrmWarn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TWarnFrm = class(TForm)
    Label1: TLabel;
    BitBtn1: TBitBtn;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WarnFrm: TWarnFrm;

implementation

{$R *.dfm}

procedure TWarnFrm.FormActivate(Sender: TObject);
begin
  BitBtn1.Enabled:=false;
  Application.ProcessMessages;
  BitBtn1.Caption:='2';
  Sleep(1000);
  BitBtn1.Caption:='1';
  Sleep(1000);
  BitBtn1.Caption:='½T©w';
  BitBtn1.Enabled:=true;
end;

end.
