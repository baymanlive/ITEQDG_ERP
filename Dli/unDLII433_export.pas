unit unDLII433_export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmDLII433_export = class(TFrmSTDI051)
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII433_export: TFrmDLII433_export;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLII433_export.FormCreate(Sender: TObject);
begin
  inherited;
  rgp.Items.Strings[0]:=CheckLang('ÀË®Ö°O¿ý');
  rgp.Items.Strings[1]:=CheckLang('±½´y°O¿ý');
end;

end.
