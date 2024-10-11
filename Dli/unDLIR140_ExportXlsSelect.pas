unit unDLIR140_ExportXlsSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmDLIR140_ExportXlsSelect = class(TFrmSTDI051)
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR140_ExportXlsSelect: TFrmDLIR140_ExportXlsSelect;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR140_ExportXlsSelect.FormCreate(Sender: TObject);
begin
  inherited;
  rgp.Caption:=CheckLang('匯出Excel選擇');
  rgp.Items.DelimitedText:=CheckLang('明細,客戶達成率,膠系達成率,膠系LT狀況');
  rgp.ItemIndex:=0;
end;

end.
