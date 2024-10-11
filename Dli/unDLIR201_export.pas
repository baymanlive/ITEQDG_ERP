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
  rgp.Items.Strings[0]:=CheckLang('明細表');
  rgp.Items.Strings[1]:=CheckLang('月分析表(物流商)');
  rgp.Items.Strings[2]:=CheckLang('月分析表(送貨區域)');
  rgp.Items.Strings[3]:=CheckLang('月分析表(每天)');
end;

end.
