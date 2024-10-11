unit unPW;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, unFrmBaseEmpty, ImgList, ExtCtrls;

type
  TFrmPW = class(TFrmBaseEmpty)
    pw1: TLabel;
    pw2: TLabel;
    pw3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPW: TFrmPW;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmPW.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, Self.Name);
end;

procedure TFrmPW.FormShow(Sender: TObject);
begin
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
end;

procedure TFrmPW.btn_okClick(Sender: TObject);
var
  pw1,pw2,pw3,tmpSQL:string;
  Data:OleVariant;
begin
  pw1:=Edit1.Text;
  pw2:=Edit2.Text;
  pw3:=Edit3.Text;

  if Length(Trim(pw2))=0 then
  begin
    ShowMsg('�K�X���i�ť�!', 48);
    Edit2.SetFocus;
    Exit;
  end;

  if pw2<>pw3 then
  begin
    ShowMsg('�T�{�s�K�X����!', 48);
    Edit2.SetFocus;
    Exit;
  end;

  if Length(pw2)>10 then
  begin
    ShowMsg('�K�X���פ��i�W�L10��!',48);
    Edit2.SetFocus;
    Exit;
  end;

  if Pos(','+pw2+',',',abc,1,11,111,1111,11111,111111,12,123,1234,12345,123456,1234567,12345678,123456789,1234567890,AAaa1234,AAaa123456,')>0 then
  begin
    ShowMsg('�K�X�L�_²��,�Э��s�]�w!',48);
    Edit2.SetFocus;
    Exit;
  end;

  tmpSQL:='exec dbo.proc_UpdatePW '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(pw1)+','+Quotedstr(pw2);
  if QueryOneCR(tmpSQL, Data) then
  begin
    case StrToInt(VarToStr(Data)) of
     -1:ShowMsg('�b�����s�b�αK�X���~!', 48);
      0:ShowMsg('��異��,�Э���!', 48);
      1:begin ShowMsg('��令�\!', 64); g_PW:=pw2; ModalResult:=mrOk; end;
     else
       ShowMsg('�������~,�Э���!', 48);
    end;
  end;
end;

procedure TFrmPW.btn_quitClick(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
