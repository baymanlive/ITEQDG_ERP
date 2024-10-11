unit unDLIR080_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DateUtils;

type
  TFrmDLIR080_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Edit1: TEdit;
    lblto2: TLabel;
    Dtp2: TDateTimePicker;
    lblsaleno: TLabel;
    lblcustno: TLabel;
    Edit2: TEdit;
    Rgp1: TRadioGroup;
    Rgp2: TRadioGroup;
    Rgp3: TRadioGroup;
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
  FrmDLIR080_Query: TFrmDLIR080_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmDLIR080_Query.Rp(SourceStr:string):string;
begin
  if Length(SourceStr)>0 then
     Result:=StringReplace(SourceStr,'''','',[])
  else
     Result:='';

  Result:=''''''+UpperCase(Result)+'''''';
end;

procedure TFrmDLIR080_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR080_Query.btn_okClick(Sender: TObject);
const xformat='YYYYMMDD';
var
  str1,str2:string;
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於截止日期!', 48);
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>30 then
  begin
    ShowMsg('查詢訂單日期范圍不能大於30天!',48);
    Exit;
  end;

  str1:=StringReplace(FormatDateTime(g_cShortDate1, Dtp1.Date),'-','/',[rfReplaceAll]);
  str2:=StringReplace(FormatDateTime(g_cShortDate1, Dtp2.Date),'-','/',[rfReplaceAll]);
  l_QueryStr:=' and to_char(oga02,''''YYYY/MM/DD'''') between '''''+str1+''''' and '''''+str2+'''''';
  if Trim(Edit1.Text)<>'' then
     l_QueryStr:=l_QueryStr+' and oga01='+Rp(Edit1.Text);
  if Trim(Edit2.Text)<>'' then
     l_QueryStr:=l_QueryStr+' and oga04='+Rp(Edit2.Text);
  inherited;
end;

end.
