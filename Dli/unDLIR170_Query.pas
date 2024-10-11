unit unDLIR170_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ExtCtrls, ImgList, Buttons, DateUtils;

type
  TFrmDLIR170_Query = class(TFrmSTDI051)
    Label1: TLabel;
    rgp: TRadioGroup;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR170_Query: TFrmDLIR170_Query;

implementation

uses unGlobal, unCommon, unDLIR100;

{$R *.dfm}

procedure TFrmDLIR170_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=EncodeDate(YearOf(Date),MonthOf(Date),1);
  Dtp2.Date:=Date;
  Label1.Caption:=CheckLang('�X�f�����G');
  Label2.Caption:=CheckLang('��');
end;

procedure TFrmDLIR170_Query.btn_okClick(Sender: TObject);
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�d�߶}�l������i�j��I����',48);
    dtp1.SetFocus;
    Exit;
  end;

  if dtp1.Date>Date then
  begin
    ShowMsg('�d�߶}�l������i�j��t�Τ��',48);
    dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
