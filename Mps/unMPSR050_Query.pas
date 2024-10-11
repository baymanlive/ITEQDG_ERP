unit unMPSR050_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPSR050_Query = class(TFrmSTDI051)
    Cbb: TComboBox;
    lblmachine: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure Dtp1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR050_Query: TFrmMPSR050_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR050_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date+6;
  GetMPSMachine;
  Cbb.Items.DelimitedText:=g_MachineCCL;
  Cbb.ItemIndex:=0;
end;

procedure TFrmMPSR050_Query.Dtp1Change(Sender: TObject);
begin
  inherited;
  Dtp2.Date:=Dtp1.Date+6;
end;

procedure TFrmMPSR050_Query.btn_okClick(Sender: TObject);
begin
  if Cbb.ItemIndex=-1 then
  begin
    ShowMsg('請選擇機台!', 48);
    Cbb.SetFocus;
    Exit;
  end;

  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢日期(起)不能大於查詢日期(迄)!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Dtp1.Date+7<Dtp2.Date then
  begin
    ShowMsg('查詢日期范圍不能超過7天!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
