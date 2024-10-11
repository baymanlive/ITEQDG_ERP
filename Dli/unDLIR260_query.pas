unit unDLIR260_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmDLIR260_query = class(TFrmSTDI051)
    rgp: TRadioGroup;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    l_sql,l_bu:string;
    { Public declarations }
  end;

var
  FrmDLIR260_query: TFrmDLIR260_query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR260_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('訂單日期：');
  Label2.Caption:=CheckLang('訂單單號：');
  Label3.Caption:=CheckLang('客戶編碼：');
  dtp1.Date:=Date-7;
  dtp2.Date:=Date;
end;

procedure TFrmDLIR260_query.btn_okClick(Sender: TObject);
var
  i:Integer;
  str1,str2:string;
  isbo1,isbo2:Boolean;
  tmpList:TStrings;
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('查詢起始日期不能大於截止日期!',48);
    Exit;
  end;

  isbo1:=Length(Trim(Edit1.Text))>0;
  isbo2:=Length(Trim(Edit2.Text))>0;
  if (not isbo1) and (not isbo2) then
  begin
    ShowMsg('請輸入訂單號碼或客戶編號!',48);
    if (not isbo1) and Edit1.CanFocus then
       Edit1.SetFocus;
    if (not isbo2) and Edit2.CanFocus then
       Edit2.SetFocus;
    Exit;
  end;

  l_bu:=rgp.Items.Strings[rgp.ItemIndex];
  str1:=StringReplace(FormatDateTime(g_cShortDate1,dtp1.Date),'-','/',[rfReplaceAll]);
  str2:=StringReplace(FormatDateTime(g_cShortDate1,dtp2.Date),'-','/',[rfReplaceAll]);
  l_sql:=' and to_char(oea02,''YYYY/MM/DD'') between '+Quotedstr(str1)+' and '+Quotedstr(str2);

  if isbo1 then
     l_sql:=l_sql+' and oea01='+Quotedstr(UpperCase(Trim(Edit1.Text)));
     
  if isbo2 then
  begin
    str2:='';
    tmpList:=TStringList.Create;
    try
      tmpList.DelimitedText:=UpperCase(Trim(Edit2.Text));
      for i:=0 to tmpList.Count-1 do
      begin
        str1:=Trim(tmpList.Strings[i]);
        if Length(str1)>0 then
           str2:=str2+','+Quotedstr(str1);
      end;
      if Length(str2)>0 then
      begin
        Delete(str2,1,1);
        l_sql:=l_sql+' and oea04 in ('+str2+')';
      end;
    finally
      FreeAndNil(tmpList);
    end;
  end;

  inherited;
end;

end.
