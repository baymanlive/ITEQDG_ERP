unit unMPSR120_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmMPSR120_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    lblto: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Rgp: TRadioGroup;
    Label1: TLabel;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR120_Query: TFrmMPSR120_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR120_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
  if not SameText(g_UInfo^.BU,'ITEQDG') then
  if not SameText(g_UInfo^.BU,'ITEQGZ') then
  begin
    Rgp.Items.Strings[0]:=g_UInfo^.BU;
    Rgp.Visible:=False;
    Self.Height:=Self.Height-rgp.Height;
  end;
end;

procedure TFrmMPSR120_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('訂單截止日期不能小於開始日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  if Dtp2.Date-Dtp1.Date>30 then
  begin
    ShowMsg('查詢訂單日期不能超過30天!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  
  inherited;
end;

end.
