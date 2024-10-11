unit unMPST021_WonoList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST021_WonoList = class(TFrmSTDI051)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST021_WonoList: TFrmMPST021_WonoList;

implementation

{$R *.dfm}

procedure TFrmMPST021_WonoList.FormCreate(Sender: TObject);
begin
  inherited;
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
end;

end.
