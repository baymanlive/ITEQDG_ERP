unit unDLIR180_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmDLIR180_query = class(TFrmSTDI051)
    rgp2: TRadioGroup;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR180_query: TFrmDLIR180_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR180_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�_�l����G');
  Label2.Caption:=CheckLang('�ܡG');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date+29;
end;

procedure TFrmDLIR180_query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�d�߶}�l�������j��I����!',48);
    dtp1.SetFocus;
    Exit;
  end;

  if Dtp2.Date-Dtp1.Date>180 then
  begin
    ShowMsg('�d�ߤ���S��̤j90��!',48);
    dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
