unit unDLIR202_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI051, ImgList, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TFrmDLIR202_query = class(TFrmSTDI051)
    label1: TLabel;
    dtp1: TDateTimePicker;
    label2: TLabel;
    dtp2: TDateTimePicker;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Label3: TLabel;
    saleno: TEdit;
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure disabledtp(value: boolean);
  public
    { Public declarations }
  end;

var
  FrmDLIR202_query: TFrmDLIR202_query;

implementation

uses
  unCommon;

{$R *.dfm}

procedure TFrmDLIR202_query.CheckBox2Click(Sender: TObject);
begin
  inherited;
  checkbox1.Checked := not checkbox2.Checked;
  disabledtp(checkbox2.Checked);
end;

procedure TFrmDLIR202_query.CheckBox1Click(Sender: TObject);
begin
  inherited;
  checkbox2.Checked := not checkbox1.Checked;
  disabledtp(checkbox2.Checked);
end;

procedure TFrmDLIR202_query.FormCreate(Sender: TObject);
begin
  inherited;
  CheckBox1.caption := checklang('全部');
  CheckBox2.caption := checklang('未出');
  label1.Caption := checklang('日期起');
  label2.caption := checklang('日期止');
  label3.caption := checklang('出貨單號');
  dtp1.date := date - 3;
  dtp2.Date := date;
  disabledtp(checkbox2.Checked);
end;

procedure TFrmDLIR202_query.disabledtp(value: boolean);
begin
  dtp1.Enabled := not value;
  dtp2.Enabled := not value;
end;

end.

