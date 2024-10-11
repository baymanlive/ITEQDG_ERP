unit unMPSR160_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPSR160_Query = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    chk1: TCheckBox;
    chk2: TCheckBox;
    chk3: TCheckBox;
    chk4: TCheckBox;
    chk5: TCheckBox;
    chk6: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_ret:string;
    { Public declarations }
  end;

var
  FrmMPSR160_Query: TFrmMPSR160_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR160_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=CheckLang('至');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date+6;
  chk1.Caption:='L1';
  chk2.Caption:='L2';
  chk3.Caption:='L3';
  chk4.Caption:='L4';
  chk5.Caption:='L5';
  chk6.Caption:='L6';
end;

procedure TFrmMPSR160_Query.btn_okClick(Sender: TObject);
var
  str:string;
begin
  if Dtp2.Date<Dtp1.Date then
  begin
    ShowMsg('生產截止日期不能小於開始日期!',48);
    Exit;
  end;
  if Dtp2.Date-Dtp1.Date>30 then
  begin
    ShowMsg('查詢生產日期不能超過31天!',48);
    Exit;
  end;

  if (not chk1.Checked) and (not chk2.Checked) and (not chk3.Checked) and
     (not chk4.Checked) and (not chk5.Checked) and (not chk6.Checked) then
  begin
    ShowMsg('請選擇線別!',48);
    Exit;
  end;

  l_ret:=' and sdate between '+Quotedstr(DateToStr(dtp1.Date))+' and '+Quotedstr(DateToStr(dtp2.Date))
        +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0';
  if chk1.Checked then
     str:=str+' or machine='+Quotedstr('L1');
  if chk2.Checked then
     str:=str+' or machine='+Quotedstr('L2');
  if chk3.Checked then
     str:=str+' or machine='+Quotedstr('L3');
  if chk4.Checked then
     str:=str+' or machine='+Quotedstr('L4');
  if chk5.Checked then
     str:=str+' or machine='+Quotedstr('L5');
  if chk6.Checked then
     str:=str+' or machine='+Quotedstr('L6');
  Delete(str,1,4);
  l_ret:=l_ret+' and ('+str+')';

  inherited;
end;

end.
