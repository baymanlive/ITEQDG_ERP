{*******************************************************}
{                                                       }
{                unMPST030_Nosplit                      }
{                Author: kaikai                         }
{                Create date: 2016/03/11                }
{                Description: 未拆分交期查詢            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST030_Nosplit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DateUtils;

type
  TFrmMPST030_Nosplit = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_QueryStr:string;
    { Public declarations }
  end;

var
  FrmMPST030_Nosplit: TFrmMPST030_Nosplit;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST030_Nosplit.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date-1;
  Dtp2.Date:=Date;
end;

procedure TFrmMPST030_Nosplit.btn_okClick(Sender: TObject);
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
  l_QueryStr:=' and to_char(oea02,''''YYYY/MM/DD'''') between '''''+str1
             +''''' and '''''+str2+''''''
             +' and oeaconf=''''Y'''' and oeb12<>oeb24';
  if SameText(g_UInfo^.BU, 'ITEQGZ') then
     l_QueryStr:=l_QueryStr+' and oea04<>''''N005''''';

  inherited;
end;

end.
