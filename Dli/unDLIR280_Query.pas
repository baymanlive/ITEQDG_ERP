unit unDLIR280_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR280_Query = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    lblto: TLabel;
    Dtp2: TDateTimePicker;
    rgp1: TRadioGroup;
    rgp2: TRadioGroup;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_QueryStr:string;
    { Public declarations }
  end;

var
  FrmDLIR280_Query: TFrmDLIR280_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR280_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('單據日期:');
  Label2.Caption:=CheckLang('異動單號:');
  Label3.Caption:=CheckLang('收貨單號:');
  Label4.Caption:=CheckLang('廠商編號:');
  rgp1.Items.Strings[2]:=CheckLang('原物料');
  rgp1.Items.Strings[3]:=CheckLang('耗材');
  rgp2.Items.Strings[0]:=CheckLang('未列印');
  rgp2.Items.Strings[1]:=CheckLang('已列印');
  rgp2.Items.Strings[2]:=CheckLang('全部');
  Dtp1.Date:=Date-7;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR280_Query.btn_okClick(Sender: TObject);
const xformat='YYYYMMDD';
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於截止日期!', 48);
    Exit;
  end;

  if Dtp2.Date-Dtp1.Date>31 then
  begin
    ShowMsg('日期範圍不能大于一個月!', 48);
    Exit;
  end;

  l_QueryStr:=' and to_char(rvu03,'+Quotedstr(xformat)+') between '+Quotedstr(FormatDateTime(xformat,Dtp1.Date))
             +' and '+Quotedstr(FormatDateTime(xformat,Dtp2.Date));
  if Length(Trim(Edit1.Text))>0 then
     l_QueryStr:=l_QueryStr+' and rvu01 like '+Quotedstr(Edit1.Text+'%');
  if Length(Trim(Edit2.Text))>0 then
     l_QueryStr:=l_QueryStr+' and rvu02 like '+Quotedstr(Edit2.Text+'%');
  if Length(Trim(Edit3.Text))>0 then
     l_QueryStr:=l_QueryStr+' and rvu04 like '+Quotedstr(Edit3.Text+'%');
  case rgp1.ItemIndex of
   0:l_QueryStr:=l_QueryStr+' and substr(rvv31,1,1) in (''E'',''T'')';
   1:l_QueryStr:=l_QueryStr+' and substr(rvv31,1,1) in (''B'',''R'',''M'',''N'',''P'',''Q'')';
   2:l_QueryStr:=l_QueryStr+' and rvv31 like ''1%''';
   3:l_QueryStr:=l_QueryStr+' and rvv31 like ''2%''';
  end;

  inherited;
end;

end.
