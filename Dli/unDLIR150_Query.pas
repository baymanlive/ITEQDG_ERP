unit unDLIR150_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, Buttons, ImgList;

type
  TFrmDLIR150_Query = class(TFrmSTDI051)
    lblsaledate: TLabel;
    Dtp1: TDateTimePicker;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    btn_sp: TSpeedButton;
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR150_Query: TFrmDLIR150_Query;

implementation

uses unCommon, unAdSelect;

{$R *.dfm}

procedure TFrmDLIR150_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
end;

procedure TFrmDLIR150_Query.btn_spClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmAdSelect) then
     FrmAdSelect:=TFrmAdSelect.Create(Application);
  if FrmAdSelect.ShowModal=mrOK then
     Edit3.Text:=FrmAdSelect.l_AdCode;
end;

end.
