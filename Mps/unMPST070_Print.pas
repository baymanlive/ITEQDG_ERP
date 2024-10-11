unit unMPST070_Print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmMPST070_Print = class(TFrmSTDI051)
    lblsdate: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    RG1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_Print: TFrmMPST070_Print;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST070_Print.FormCreate(Sender: TObject);
begin
  inherited;
  RG1.Items.DelimitedText:=g_MachinePP;
  RG1.ItemIndex:=0;
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmMPST070_Print.btn_okClick(Sender: TObject);
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('開始日期不能大于截止日期!',48);
    Exit;
  end;

  inherited;
end;

end.
