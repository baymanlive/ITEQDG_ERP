{*******************************************************}
{                                                       }
{                unMPST030_Query                        }
{                Author: kaikai                         }
{                Create date: 2016/03/11                }
{                Description: 拆分交期作業查詢          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST030_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DateUtils;

type
  TFrmMPST030_Query = class(TFrmSTDI051)
    lblorderno: TLabel;
    lblcustno: TLabel;
    lblpno: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    RadioGroup4: TRadioGroup;
    lblorderdate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    function Rp(SourceStr: string): string;
    { Private declarations }
  public
    l_QueryStr:string;
    { Public declarations }
  end;

var
  FrmMPST030_Query: TFrmMPST030_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmMPST030_Query.Rp(SourceStr:string):string;
begin
  if Length(SourceStr)>0 then
     Result:=StringReplace(SourceStr,'''','',[])
  else
     Result:='';

  Result:=''''''+Result+'''''';
end;

procedure TFrmMPST030_Query.FormCreate(Sender: TObject);
begin
  inherited;
  RadioGroup1.Items.DelimitedText:=CheckLang('未確認,已確認,全部');
  RadioGroup2.Items.DelimitedText:=CheckLang('未結案,已結案,全部');
  RadioGroup3.Items.DelimitedText:=CheckLang('未出完貨,已出完貨,全部');
  RadioGroup4.Items.DelimitedText:=CheckLang('未拆交期,已拆交期,全部');
  Dtp1.Date:=IncMonth(Date,-3);
  Dtp2.Date:=Date;
end;

procedure TFrmMPST030_Query.btn_okClick(Sender: TObject);
var
  str1,str2:string;
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於結束日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>6 then
  if (Length(Trim(Edit1.Text))=0) and (Length(Trim(Edit2.Text))=0) and (Length(Trim(Edit3.Text))=0) then
  begin
    ShowMsg('查詢訂單日期范圍超過7天,需輸入條件[%s]',48,MyStringReplace(lblorderno.Caption+','+lblcustno.Caption+'或'+lblpno.Caption));
    Dtp1.SetFocus;
    Exit;
  end;

  str1:=StringReplace(FormatDateTime(g_cShortDate1, Dtp1.Date),'-','/',[rfReplaceAll]);
  str2:=StringReplace(FormatDateTime(g_cShortDate1, Dtp2.Date),'-','/',[rfReplaceAll]);
  l_QueryStr:=' and to_char(oea02,''''YYYY/MM/DD'''') between '''''+str1+''''' and '''''+str2+'''''';

  if Length(Trim(Edit1.Text))>0 then
     l_QueryStr:=l_QueryStr+' and oea01='+Rp(Edit1.Text);

  if Length(Trim(Edit2.Text))>0 then
     l_QueryStr:=l_QueryStr+' and oea04='+Rp(Edit2.Text);

  if Length(Trim(Edit3.Text))>0 then
     l_QueryStr:=l_QueryStr+' and oeb04='+Rp(Edit3.Text);

  case RadioGroup1.ItemIndex of
    0:l_QueryStr:=l_QueryStr+' and oeaconf=''''N''''';
    1:l_QueryStr:=l_QueryStr+' and oeaconf=''''Y''''';
  end;

//本地結案,需全部查出來再判斷 
{
  case RadioGroup2.ItemIndex of
    0:l_QueryStr:=l_QueryStr+' and oeb70=''''N''''';
    1:l_QueryStr:=l_QueryStr+' and oeb70=''''Y''''';
  end;
}
  case RadioGroup3.ItemIndex of
    0:l_QueryStr:=l_QueryStr+' and oeb12<>oeb24';
    1:l_QueryStr:=l_QueryStr+' and oeb12=oeb24';
  end;

  inherited;
end;

end.
