unit unMPSR110_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPSR110_Query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR110_Query: TFrmMPSR110_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR110_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�_�l�Ͳ�����G');
  Label2.Caption:=CheckLang('�Ȥ�s���G');
  Label3.Caption:=CheckLang('���t(��2�X)�G');
  Label4.Caption:=CheckLang('�Ȥ�,���t�h�ӭȥγr��('','')���j');
  Label5.Caption:=CheckLang('�p��(4�X)�G');
  Label6.Caption:=CheckLang('��');
  dtp.Date:=Date;
end;

procedure TFrmMPSR110_Query.btn_okClick(Sender: TObject);
var
  len:Integer;
begin
  len:=Length(Trim(Edit3.Text));
  if (len>0) and (len<>4) then
  begin
    ShowMsg('�p�׽п�J4�X',48);
    Edit3.SetFocus;
    Exit;
  end;

  len:=Length(Trim(Edit4.Text));
  if (len>0) and (len<>4) then
  begin
    ShowMsg('�p�׽п�J4�X',48);
    Edit4.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
