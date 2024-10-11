unit unDLIR201_export;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmDLIR201_export = class(TFrmSTDI051)
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR201_export: TFrmDLIR201_export;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR201_export.FormCreate(Sender: TObject);
begin
  inherited;
  rgp.Items.Strings[0]:=CheckLang('���Ӫ�');
  rgp.Items.Strings[1]:=CheckLang('����R��(���y��)');
  rgp.Items.Strings[2]:=CheckLang('����R��(�e�f�ϰ�)');
  rgp.Items.Strings[3]:=CheckLang('����R��(�C��)');
end;

end.
