unit unDLIR140_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, Buttons, ImgList;

type
  TFrmDLIR140_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    lblto: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    btn_sp: TSpeedButton;
    rgp: TRadioGroup;
    Label2: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR140_Query: TFrmDLIR140_Query;

implementation

uses unCommon, unAdSelect;

{$R *.dfm}

procedure TFrmDLIR140_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR140_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('查詢訂單日期的截止日期不能小於開始日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  
  if Dtp2.Date-Dtp1.Date>31 then
  begin
    ShowMsg('查詢訂單日期不能超過31天!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

procedure TFrmDLIR140_Query.btn_spClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmAdSelect) then
     FrmAdSelect:=TFrmAdSelect.Create(Application);
  if FrmAdSelect.ShowModal=mrOK then
     Edit3.Text:=FrmAdSelect.l_AdCode;
end;

end.
