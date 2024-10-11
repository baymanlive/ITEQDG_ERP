unit unMPSI130_Update;

interface

uses
  Windows, SysUtils, Messages, unSTDI051, StdCtrls, Controls, ImgList, Buttons,
  Classes, ExtCtrls;

type
  TFrmMPSI130_Update = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSI130_Update: TFrmMPSI130_Update;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI130_Update.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
end;

procedure TFrmMPSI130_Update.btn_okClick(Sender: TObject);
const strMsg='�п�J�X��N�X1-999�I';
var
  tmpSQL:string;
  Num1,Num2:Integer;
begin
  try
    Num1:=StrToInt(Trim(Edit1.Text));
  except
    ShowMsg(strMsg, 48);
    Edit1.SetFocus;
    Exit;
  end;

  try
    Num2:=StrToInt(Trim(Edit2.Text));
  except
    ShowMsg(strMsg, 48);
    Edit2.SetFocus;
    Exit;
  end;

  if (Num1<1) or (Num1>999) then
  begin
    ShowMsg(strMsg, 48);
    Edit1.SetFocus;
    Exit;
  end;

  if (Num2<1) or (Num2>999) then
  begin
    ShowMsg(strMsg, 48);
    Edit2.SetFocus;
    Exit;
  end;

  if Num1=Num2 then
  begin
    ShowMsg('�п�J���P���N�X!', 64);
    Edit1.SetFocus;
    Exit;
  end;

  if ShowMsg('�нT�{�w�h�X�Ƶ{�@�~��A���榹�ާ@'#13#10'�T�w��s��?', 33)=IdCancel then
     Exit;

  tmpSQL:='Update MPS010 Set Adcode='+IntToStr(Num2)
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Sdate>getdate()-1 And Adcode='+IntToStr(Num1);
  if PostBySQL(tmpSQL) then
     ShowMsg('��s����!', 64)
  else
     ShowMsg('��s����,�Э���!', 48);

//  inherited;
end;

end.
