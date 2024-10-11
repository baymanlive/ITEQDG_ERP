unit unDLIT803_showret;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIT803_showret = class(TFrmSTDI051)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT803_showret: TFrmDLIT803_showret;

implementation

{$R *.dfm}

procedure TFrmDLIT803_showret.FormCreate(Sender: TObject);
begin
  inherited;
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
end;

end.
