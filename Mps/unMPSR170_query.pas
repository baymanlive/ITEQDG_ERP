unit unMPSR170_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmMPSR170_query = class(TFrmSTDI051)
    rgp1: TRadioGroup;
    rgp2: TRadioGroup;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    lblto: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR170_query: TFrmMPSR170_query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR170_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�Ȥ�N��,�h�ӽХγr��(,)���}');
  Label2.Caption:=CheckLang('���t(��2�X),�h�ӽХγr��(,)���}');
  Label3.Caption:=CheckLang('�p�װ϶�(CCL��3~6�X)');
  Label4.Caption:=CheckLang('�F����');
  Label5.Caption:=lblto.Caption;
  dtp1.Date:=Date;
  dtp2.Date:=Date+90;
end;

procedure TFrmMPSR170_query.btn_okClick(Sender: TObject);
begin
  if rgp1.ItemIndex in [0,1] then
  begin
    if Length(Edit3.Text)>0 then
    begin
      if Length(Edit3.Text)<>4 then
      begin
        ShowMsg('�p�װ϶�(�_)���~!',48);
        Exit;
      end;

      if StrToIntDef(Edit3.Text,0)<0 then
      begin
        ShowMsg('�p�װ϶�(�_)���~!',48);
        Exit;
      end;
    end;

    if Length(Edit4.Text)>0 then
    begin
      if Length(Edit4.Text)<>4 then
      begin
        ShowMsg('�p�װ϶�(��)���~!',48);
        Exit;
      end;

      if StrToIntDef(Edit4.Text,0)<0 then
      begin
        ShowMsg('�p�װ϶�(��)���~!',48);
        Exit;
      end;
    end;
  end;

  if dtp1.Date<Date then
  begin
    ShowMsg('�d�߶}�l������i�p�_���!',48);
    Exit;
  end;

  if dtp2.Date>dtp1.Date+90 then
  begin
    ShowMsg('�d�ߤ���϶����i�j��90��!',48);
    Exit;
  end;

  inherited;
end;

end.
