unit unIPQCT620_login;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmIPQCT620_login = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    logo: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
     l_bu,l_uname:string;
     l_garbage:Boolean;
     { Public declarations }
  end;

var
  FrmIPQCT620_login: TFrmIPQCT620_login;

implementation

uses unIPQCT620;

const l_hint='提示';

{$R *.dfm}

procedure TFrmIPQCT620_login.FormCreate(Sender: TObject);
begin
  l_bu:='ITEQDG';
end;

procedure TFrmIPQCT620_login.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then
     SelectNext(ActiveControl, True, True)
  else if (Key=VK_ESCAPE) and (Application.MessageBox('確定退出程式嗎?',l_hint,33)=IdOK) then
     Close;
end;

procedure TFrmIPQCT620_login.BitBtn1Click(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    Application.MessageBox('請輸入帳號!',l_hint,48);
    Edit1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit2.Text))=0 then
  begin
    Application.MessageBox('請輸入密碼!',l_hint,48);
    Edit2.SetFocus;
    Exit;
  end;

  with FrmIPQCT620.ADOQuery2 do
  begin
    Close;
    SQL.Text:='select a.username,b.r_garbage from sys_user a,sys_userright b'
             +' where a.bu=b.bu and a.userid=b.userid'
             +' and a.bu='+Quotedstr(l_bu)
             +' and a.userid='+Quotedstr(Edit1.Text)
             +' and a.password='+Quotedstr(Edit2.Text)
             +' and isnull(a.not_use,0)=0 and b.procid=''IPQCT620'' and b.r_visible=1';
    try
      Open;
    except
      on e:Exception do
      begin
        Application.MessageBox(PAnsiChar('查詢資料失敗,請重試:'+#13#10+e.Message),l_hint,48);
        Exit;
      end;
    end;

    if IsEmpty then
    begin
      Application.MessageBox('帳號或密碼錯誤,或無此作業權限!',l_hint,48);
      Exit;
    end;

    l_uname:=FieldByName('username').AsString;
    l_garbage:=FieldByName('r_garbage').AsBoolean;
  end;

  ModalResult:=mrOK;
end;

procedure TFrmIPQCT620_login.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
