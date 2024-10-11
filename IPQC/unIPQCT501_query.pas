unit unIPQCT501_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmIPQCT501_query = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    l_ret:string;
    { Public declarations }
  end;

var
  FrmIPQCT501_query: TFrmIPQCT501_query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT501_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('移轉單號：');
  Label2.Caption:=CheckLang('批號：');
  Label4.Caption:=CheckLang('工單號碼：');
end;

procedure TFrmIPQCT501_query.btn_okClick(Sender: TObject);
var
  s1,s2,s3:string;
begin
  l_ret:='';
  s1:=UpperCase(Trim(Edit1.Text));
  s2:=UpperCase(Trim(Edit2.Text));
  s3:=UpperCase(Trim(Edit3.Text));
  if (Length(s1)=0) and (Length(s2)=0) and (Length(s3)=0) then
  begin
    ShowMsg('請輸入查詢條件！',48);
    Exit;
  end;

  if Length(s1)>0 then
     l_ret:=l_ret+' and tc_sia01 like '+Quotedstr(s1+'%');
  if Length(s2)>0 then
     l_ret:=l_ret+' and tc_sia02 like '+Quotedstr(s2+'%');
  if Length(s3)>0 then
     l_ret:=l_ret+' and shb05 like '+Quotedstr(s3+'%');

  inherited;
end;

procedure TFrmIPQCT501_query.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.SetFocus;
end;

end.
