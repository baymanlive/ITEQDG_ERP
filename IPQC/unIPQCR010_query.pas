unit unIPQCR010_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, DateUtils, StrUtils;

type
  TFrmIPQCR010_query = class(TFrmSTDI051)
    cbb: TComboBox;
    month: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    lot1_3:string;
    { Public declarations }
  end;

var
  FrmIPQCR010_query: TFrmIPQCR010_query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCR010_query.FormCreate(Sender: TObject);
var
  y,m:Integer;
begin
  inherited;
  Label1.Caption:=CheckLang('日期1~31');
  y:=YearOf(Date);
  m:=MonthOf(Date);
  with cbb do
  begin
    Items.Clear;
    while Items.Count<12 do
    begin
      if m<1 then
      begin
        m:=12;
        Dec(y);
      end;

      Items.Add(IntToStr(y*100+m));
      Dec(m);
    end;
    ItemIndex:=0;
  end;

  Edit1.Text:=IntToStr(DayOf(Date));
end;

procedure TFrmIPQCR010_query.btn_okClick(Sender: TObject);
var
  m:Integer;
  str:string;
begin
  if cbb.ItemIndex=-1 then
  begin
    ShowMsg('請選擇月份!',48);
    Exit;
  end;

  str:=cbb.Items[cbb.ItemIndex];
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     lot1_3:='D'+Copy(str,4,1)
  else
     lot1_3:='G'+Copy(str,4,1);

  m:=StrToInt(RightStr(str,2));
  case m of
    12:lot1_3:=lot1_3+'C';
    11:lot1_3:=lot1_3+'B';
    10:lot1_3:=lot1_3+'A';
    else
      lot1_3:=lot1_3+IntToStr(m);
  end;

  str:=Trim(Edit1.Text);
  if Length(str)>0 then
  begin
    m:=StrToIntDef(str,0);
    if (m<1) or (m>31) then
    begin
      ShowMsg('日期請輸入1~31!',48);
      Exit;
    end;

    lot1_3:=lot1_3+RightStr('0'+str,2);
  end;

  inherited;
end;

end.
