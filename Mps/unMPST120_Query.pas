unit unMPST120_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmMPST120_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    lblto: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Rgp3: TRadioGroup;
    Rgp2: TRadioGroup;
    lblpno: TLabel;
    Edit3: TEdit;
    Rgp1: TRadioGroup;
    Label1: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST120_Query: TFrmMPST120_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPST120_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('���t(�Ƹ���2�X):');
  Rgp1.Items.Strings[2]:=CheckLang('����');
  Rgp2.Items.Strings[0]:=CheckLang('������');
  Rgp2.Items.Strings[1]:=CheckLang('�w����');
  Rgp2.Items.Strings[2]:=CheckLang('����');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmMPST120_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('�q��I��������p��}�l���!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  if Dtp2.Date-Dtp1.Date>30 then
  begin
    ShowMsg('�d�߭q��������W�L30��!',48);
    Dtp1.SetFocus;
    Exit;
  end;
  
  inherited;
end;

end.
