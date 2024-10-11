unit unMPSR220_export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmMPSR220_export = class(TFrmSTDI051)
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR220_export: TFrmMPSR220_export;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR220_export.FormCreate(Sender: TObject);
begin
  inherited;
  rgp.Items.Strings[0]:=CheckLang('排程資料');
  rgp.Items.Strings[1]:=CheckLang('庫存資料');
end;

end.
