unit unMPST120_supplier;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmMPST120_supplier = class(TFrmSTDI051)
    Rgp1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST120_supplier: TFrmMPST120_supplier;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPST120_supplier.FormCreate(Sender: TObject);
begin
  inherited;
  with rgp1.Items do
  begin
    Strings[0]:=CheckLang('N006 無錫聯茂');
    Strings[1]:=CheckLang('N023 臺灣聯茂');
    Strings[2]:=CheckLang('N024 江西聯茂');
    Strings[3]:=CheckLang('N005 東莞聯茂');
    Strings[4]:=CheckLang('N012 廣州聯茂');
  end;
end;

end.
