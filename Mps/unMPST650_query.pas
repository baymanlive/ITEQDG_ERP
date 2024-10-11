unit unMPST650_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons,
  CheckLst;

type
  TFrmMPST650_query = class(TFrmSTDI051)
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    CheckBox1: TCheckBox;
    lblto: TLabel;
    dtp3: TDateTimePicker;
    dtp4: TDateTimePicker;
    CheckBox2: TCheckBox;
    Label1: TLabel;
    dtp5: TDateTimePicker;
    dtp6: TDateTimePicker;
    CheckBox3: TCheckBox;
    Label8: TLabel;
    dtp7: TDateTimePicker;
    dtp8: TDateTimePicker;
    CheckBox4: TCheckBox;
    cbb1: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    cbb2: TComboBox;
    cbb3: TComboBox;
    Label11: TLabel;
    Label12: TLabel;
    cbb4: TComboBox;
    Label15: TLabel;
    dtp9: TDateTimePicker;
    dtp10: TDateTimePicker;
    CheckBox5: TCheckBox;
    GroupBox1: TGroupBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    Label13: TLabel;
    Edit6: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_sql:string;
    { Public declarations }
  end;

var
  FrmMPST650_query: TFrmMPST650_query;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmMPST650_query.FormCreate(Sender: TObject);
begin
  inherited;
  CheckBox1.Caption:=CheckLang('���ʤ���G');
  CheckBox2.Caption:=CheckLang('�q�����G');
  CheckBox3.Caption:=CheckLang('�w�p�X�t�G');
  CheckBox4.Caption:=CheckLang('��ڥX�t�G');
  CheckBox5.Caption:=CheckLang('�w�p��t�G');
  Label2.Caption:=lblto.Caption;
  Label1.Caption:=lblto.Caption;
  Label8.Caption:=lblto.Caption;
  Label15.Caption:=lblto.Caption;
  Label3.Caption:=CheckLang('���ʳ渹�G');
  Label4.Caption:=CheckLang('���ʳ渹�G');
  Label5.Caption:=CheckLang('�q��渹�G');
  Label6.Caption:=CheckLang('�Ȥ�N���G');
  Label7.Caption:=CheckLang('�Ƹ��G');
  Label9.Caption:=CheckLang('���סG');
  Label10.Caption:=CheckLang('�����G');
  Label11.Caption:=CheckLang('�^�t�ƶq�G');
  Label12.Caption:=CheckLang('���G');
  Label13.Caption:=CheckLang('���t�G');
  CheckBox6.Caption:=CheckLang('���');
  CheckBox7.Caption:=CheckLang('����');
  CheckBox8.Caption:=CheckLang('������');
  CheckBox9.Caption:=CheckLang('�C��');
  CheckBox10.Caption:=CheckLang('���');
  CheckBox11.Caption:=CheckLang('�L��PP');
  CheckBox12.Caption:=CheckLang('�L��CCL');
  CheckBox13.Caption:=CheckLang('�L���S���t');
  CheckBox14.Caption:=CheckLang('�O�WPP');
  CheckBox15.Caption:=CheckLang('�O�WCCL');
  CheckBox16.Caption:=CheckLang('�O�W�S���t');
  CheckBox17.Caption:=CheckLang('����PP');
  CheckBox18.Caption:=CheckLang('����CCL');
  CheckBox19.Caption:=CheckLang('����S���t');
  CheckBox20.Caption:=CheckLang('�ۥ�PP');

  with cbb1.Items do
  begin
    Clear;
    Add(CheckLang('������'));
    Add(CheckLang('�w����'));
    Add(CheckLang('����'));
  end;
  cbb1.ItemIndex:=0;

  with cbb2.Items do
  begin
    Clear;
    Add(CheckLang('������'));
    Add(CheckLang('�w����'));
    Add(CheckLang('����'));
  end;
  cbb2.ItemIndex:=2;

  with cbb3.Items do
  begin
    Clear;
    Add(CheckLang('�^�t�ƶq>0'));
    Add(CheckLang('�^�t�ƶq=0'));
    Add(CheckLang('����'));
  end;
  cbb3.ItemIndex:=2;

  with cbb4.Items do
  begin
    Clear;
    Add('SH');
    Add('RL');
    Add('M');
    Add('PN');
    Add(CheckLang('����'));
  end;
  cbb4.ItemIndex:=4;

  Dtp1.Date:=Date-29;
  Dtp2.Date:=Date;
  Dtp3.Date:=Dtp1.Date;
  Dtp4.Date:=Date;
  Dtp5.Date:=Dtp1.Date;
  Dtp6.Date:=Date;
  Dtp7.Date:=Dtp1.Date;
  Dtp8.Date:=Date;
  Dtp9.Date:=Dtp1.Date;
  Dtp10.Date:=Date;
end;

procedure TFrmMPST650_query.btn_okClick(Sender: TObject);
var
  tmpFilter:string;
begin
  l_sql:='';
  if CheckBox2.Checked then
  begin
    if dtp3.Date>dtp4.Date then
    begin
      ShowMsg('�q��_�l�������j�_�I����',48);
      Exit;
    end;

    l_sql:=l_sql+' and orderdate between '+Quotedstr(DateToStr(dtp3.Date))
                +' and '+Quotedstr(DateToStr(dtp4.Date));
  end;

  if CheckBox1.Checked then
  begin
    if dtp1.Date>dtp2.Date then
    begin
      ShowMsg('���ʰ_�l�������j�_�I����',48);
      Exit;
    end;

    l_sql:=l_sql+' and cdate between '+Quotedstr(DateToStr(dtp1.Date))
                +' and '+Quotedstr(DateToStr(dtp2.Date));
  end;

  if CheckBox3.Checked then
  begin
    if dtp5.Date>dtp6.Date then
    begin
      ShowMsg('�w�p�X�t�_�l�������j�_�I����',48);
      Exit;
    end;

    l_sql:=l_sql+' and date2 between '+Quotedstr(DateToStr(dtp5.Date))
                +' and '+Quotedstr(DateToStr(dtp6.Date));
  end;

  if CheckBox4.Checked then
  begin
    if dtp7.Date>dtp8.Date then
    begin
      ShowMsg('��ڥX�t�_�l�������j�_�I����',48);
      Exit;
    end;

    l_sql:=l_sql+' and date3 between '+Quotedstr(DateToStr(dtp7.Date))
                +' and '+Quotedstr(DateToStr(dtp8.Date));
  end;

  if CheckBox5.Checked then
  begin
    if dtp9.Date>dtp10.Date then
    begin
      ShowMsg('�w�p��t�_�l�������j�_�I����',48);
      Exit;
    end;

    l_sql:=l_sql+' and date4 between '+Quotedstr(DateToStr(dtp9.Date))
                +' and '+Quotedstr(DateToStr(dtp10.Date));
  end;

  if Length(Trim(Edit1.Text))>0 then
     l_sql:=l_sql+' and cno='+Quotedstr(Edit1.Text);

  if Length(Trim(Edit2.Text))>0 then
     l_sql:=l_sql+' and purcno='+Quotedstr(Edit2.Text);

  if Length(Trim(Edit3.Text))>0 then
     l_sql:=l_sql+' and orderno='+Quotedstr(Edit3.Text);

  if Length(Trim(Edit4.Text))>0 then
     l_sql:=l_sql+' and custno='+Quotedstr(Edit4.Text);

  if Length(Trim(Edit5.Text))>0 then
     l_sql:=l_sql+' and pno like '+Quotedstr(Edit5.Text+'%');
  if Length(Trim(Edit6.Text))>0 then
     l_sql:=l_sql+' and pno like '+Quotedstr('_'+copy(Edit6.Text,1,1)+'%');

  case cbb1.ItemIndex of
    0:l_sql:=l_sql+' and isnull(isfinish,0)=0';
    1:l_sql:=l_sql+' and isnull(isfinish,0)=1';
  end;

  case cbb2.ItemIndex of
    0:l_sql:=l_sql+' and date5 is null';
    1:l_sql:=l_sql+' and date5 is not null';
  end;

  case cbb3.ItemIndex of
    0:l_sql:=l_sql+' and isnull(outqty,0)>0';
    1:l_sql:=l_sql+' and isnull(outqty,0)=0';
  end;

  case cbb4.ItemIndex of
    0:l_sql:=l_sql+' and units=''SH''';
    1:l_sql:=l_sql+' and units=''RL''';
    2:l_sql:=l_sql+' and units=''M''';
    3:l_sql:=l_sql+' and units=''PN''';
  end;

  tmpFilter:='';
  if CheckBox6.Checked then
     tmpFilter:=tmpFilter+',1';
  if CheckBox7.Checked then
     tmpFilter:=tmpFilter+',2';
  if CheckBox8.Checked then
     tmpFilter:=tmpFilter+',3';
  if CheckBox9.Checked then
     tmpFilter:=tmpFilter+',4';
  if CheckBox10.Checked then
     tmpFilter:=tmpFilter+',5';

  if Length(tmpFilter)>0 then
  begin
    Delete(tmpFilter,1,1);
    l_sql:=l_sql+' and qtycolor in ('+tmpFilter+')';
  end;

  tmpFilter:='';
  if CheckBox11.Checked then
     tmpFilter:=tmpFilter+',''wxpp''';
  if CheckBox12.Checked then
     tmpFilter:=tmpFilter+',''wxccl''';
  if CheckBox14.Checked then
     tmpFilter:=tmpFilter+',''twpp''';
  if CheckBox15.Checked then
     tmpFilter:=tmpFilter+',''twccl''';
  if CheckBox17.Checked then
     tmpFilter:=tmpFilter+',''jxpp''';
  if CheckBox18.Checked then
     tmpFilter:=tmpFilter+',''jxccl''';
  if CheckBox13.Checked then
     tmpFilter:=tmpFilter+',''wx''';
  if CheckBox16.Checked then
     tmpFilter:=tmpFilter+',''tw''';
  if CheckBox19.Checked then
     tmpFilter:=tmpFilter+',''jx''';
  if CheckBox20.Checked then
     tmpFilter:=tmpFilter+',''pp''';

  if Length(tmpFilter)>0 then
  begin
    Delete(tmpFilter,1,1);
    l_sql:=l_sql+' and srcid in ('+tmpFilter+')';
  end;
  
  inherited;
end;

end.
