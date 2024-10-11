{*******************************************************}
{                                                       }
{                unMPSR090_Query                        }
{                Author: kaikai                         }
{                Create date: 2016/04/6                 }
{                Description: Call貨日期更改作業查詢    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR090_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DateUtils;

type
  TFrmMPSR090_Query = class(TFrmSTDI051)
    lblorderno: TLabel;
    lblcustno: TLabel;
    lblpno: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
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
  FrmMPSR090_Query: TFrmMPSR090_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmMPSR090_Query.Rp(SourceStr:string):string;
begin
  if Length(SourceStr)>0 then
     Result:=StringReplace(SourceStr,'''','',[])
  else
     Result:='';

  Result:=''''''+UpperCase(Result)+'''''';
end;

procedure TFrmMPSR090_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date-1;
  Dtp2.Date:=Date;
end;

procedure TFrmMPSR090_Query.btn_okClick(Sender: TObject);
var
  str1,str2:string;
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於結束日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>30 then
  begin
    ShowMsg('查詢訂單日期范圍不能大於30天!',48);
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

  inherited;
end;

end.
