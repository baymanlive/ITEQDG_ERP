unit unMPST120_set;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST120_set = class(TFrmSTDI051)
    Memo1: TMemo;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST120_set: TFrmMPST120_set;

implementation

uses unGlobal, unCommon;

const l_bu='ITEQDG';

{$R *.dfm}

procedure TFrmMPST120_set.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('內銷單別,一行一個');
end;

procedure TFrmMPST120_set.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select top 1 id from mps014 where bu='+Quotedstr(l_bu);
  if QueryOneCR(tmpSQL, Data) then
     Memo1.Lines.DelimitedText:=VarToStr(Data);
end;

procedure TFrmMPST120_set.btn_okClick(Sender: TObject);
var
  i:Integer;
  tmpSQL:string;
begin
  //inherited;
  if Memo1.Lines.Count=0 then
  begin
    ShowMsg('請輸入內銷單別!',48);
    Exit;
  end;

  for i:=0 to Memo1.Lines.Count-1 do
  if Length(Memo1.Lines.Strings[i])<>3 then
  begin
    ShowMsg('第'+IntToStr(i+1)+'筆,單別錯誤!',48);
    Exit;
  end;

  tmpSQL:='update mps014 set id='+Quotedstr(Memo1.Lines.DelimitedText)
         +',muser='+Quotedstr(g_UInfo^.UserId)
         +',mdate='+Quotedstr(FormatDateTime(g_cLongTimeSP,Now))
         +' where bu='+Quotedstr(l_bu);
  if PostBySQL(tmpSQL) then
     ShowMsg('修改成功',64);
end;

end.
