unit unDLIR090_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DateUtils;

type
  TFrmDLIR090_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    lblsaleno: TLabel;
    lblcustno: TLabel;
    Edit2: TEdit;
    Rgp1: TRadioGroup;
    Rgp2: TRadioGroup;
    Rgp3: TRadioGroup;
    RB1: TRadioButton;
    RB2: TRadioButton;
    Rgp4: TRadioGroup;
    Label3: TLabel;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure RB1Click(Sender: TObject);
  private
    function Rp(SourceStr: string): string;
    { Private declarations }
  public
    l_QueryStr:string;
    { Public declarations }
  end;

var
  FrmDLIR090_Query: TFrmDLIR090_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmDLIR090_Query.Rp(SourceStr:string):string;
begin
  if Length(SourceStr)>0 then
     Result:=StringReplace(SourceStr,'''','',[])
  else
     Result:='';

  Result:=''''''+UpperCase(Result)+'''''';
end;

procedure TFrmDLIR090_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�������(�_)�G');
  Label2.Caption:=CheckLang('�������(��)�G');
  Label3.Caption:=CheckLang('�����渹�G');
  Rgp1.Items.DelimitedText:=CheckLang('���X�t,�w�X�t,����');
  Rgp2.Items.DelimitedText:=CheckLang('���^�p,�w�^�p,����');
  Rgp3.Items.DelimitedText:=CheckLang('��ñ��,�wñ��,����');
  Rgp4.Items.DelimitedText:=CheckLang('���C�L,�w�C�L,����');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR090_Query.RB1Click(Sender: TObject);
begin
  inherited;
  if RB1.Checked then
  begin
    Label1.Caption:=CheckLang('�������(�_)�G');
    Label2.Caption:=CheckLang('�������(��)�G');
  end else
  begin
    Label1.Caption:=CheckLang('�e�f����(�_)�G');
    Label2.Caption:=CheckLang('�e�f����(��)�G');
  end
end;

procedure TFrmDLIR090_Query.btn_okClick(Sender: TObject);
const xformat='YYYYMMDD';
var
  str1,str2:string;
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�d�߶}�l�������j��I����!', 48);
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>=70 then
  begin
    ShowMsg('�d�ߤ���S�򤣯�j��70��!',48);
    Exit;
  end;

  if RB2.Checked then
  begin
    str1:=StringReplace(FormatDateTime(g_cShortDate1, Dtp1.Date),'-','/',[rfReplaceAll]);
    str2:=StringReplace(FormatDateTime(g_cShortDate1, Dtp2.Date),'-','/',[rfReplaceAll]);
    l_QueryStr:=' and to_char(oga02,''''YYYY/MM/DD'''') between '''''+str1+''''' and '''''+str2+'''''';
  end else
    l_QueryStr:='';
  if Trim(Edit1.Text)<>'' then
     l_QueryStr:=l_QueryStr+' and oga01='+Rp(Edit1.Text);
  if Trim(Edit2.Text)<>'' then
     l_QueryStr:=l_QueryStr+' and instr('+Rp(Edit2.Text)+',oga04,1,1)>0'; //oga04='+Rp(Edit2.Text)

  case Rgp4.ItemIndex of
    0:l_QueryStr:=l_QueryStr+' and ogaprsw=0';
    1:l_QueryStr:=l_QueryStr+' and ogaprsw>0';
  end;

  inherited;
end;

end.
