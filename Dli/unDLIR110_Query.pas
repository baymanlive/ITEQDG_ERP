unit unDLIR110_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, Mask, DBCtrlsEh, ComCtrls,
  ImgList, Buttons;

type
  TFrmDLIR110_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Dtp3: TDBDateTimeEditEh;
    lblto: TLabel;
    Label1: TLabel;
    Dtp4: TDBDateTimeEditEh;
    Label3: TLabel;
    lblcustno: TLabel;
    Edit1: TEdit;
    lblorderno: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    Edit3: TEdit;
    Rgp: TRadioGroup;
    lblsaledate: TLabel;
    Label4: TLabel;
    Dtp5: TDBDateTimeEditEh;
    Dtp6: TDBDateTimeEditEh;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR110_Query: TFrmDLIR110_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR110_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label3.Caption:=lblto.Caption;
  Label4.Caption:=lblto.Caption;
  Label5.Caption:=CheckLang('1. ���w[�Ȥ�s��]����,�i�d��90�Ѥ��q����');
  Label6.Caption:=CheckLang('2. �����w[�Ȥ�s��]����,�u�i�d��1�Ѥ��q����');
  Rgp.Items.Clear;
  Rgp.Items.Add(CheckLang('���X��'));
  Rgp.Items.Add(CheckLang('�w�X��'));
  Rgp.Items.Add(CheckLang('����'));
  Rgp.Columns:=3;
  Rgp.ItemIndex:=0;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR110_Query.btn_okClick(Sender: TObject);
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('�d�߭q�������I��������p��}�l���!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit1.Text))=0 then
  begin
    if Dtp1.Date<>Dtp2.Date then
    begin
      ShowMsg('�q�������ۦP'+#13#10+'�����w[�Ȥ�s��]����,�u�i�d��1�Ѥ��q����',48);
      Dtp1.SetFocus;
      Exit;
    end;
  end else
  begin
    if Dtp2.Date-Dtp1.Date>89 then
    begin
      ShowMsg('�d�߭q��������W�L90��!',48);
      Dtp1.SetFocus;
      Exit;
    end;
  end;

  if (not VarIsNull(Dtp3.Value)) and (not VarIsNull(Dtp4.Value)) then
  if Dtp3.Value>Dtp4.Value then
  begin
    ShowMsg('�d�߹F�Ȥ������I��������p��}�l���!',48);
    Dtp3.SetFocus;
    Exit;
  end;

  if (not VarIsNull(Dtp5.Value)) and (not VarIsNull(Dtp6.Value)) then
  if Dtp5.Value>Dtp6.Value then
  begin
    ShowMsg('�d�ߥX�f������I��������p��}�l���!',48);
    Dtp5.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
