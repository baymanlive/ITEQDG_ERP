unit unDLIT600_export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmDLIT600_export = class(TFrmSTDI051)
    rgp: TRadioGroup;
    rgp2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT600_export: TFrmDLIT600_export;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIT600_export.FormCreate(Sender: TObject);
begin
  inherited;
  rgp2.Items.Strings[0]:=CheckLang('¤º¾P');
  rgp2.Items.Strings[1]:=CheckLang('¥~¾P');
end;

end.
