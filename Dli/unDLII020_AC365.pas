unit unDLII020_AC365;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, StdCtrls, ImgList, ComCtrls, Buttons, ExtCtrls;

type
  TFrmDLII020_AC365 = class(TFrmSTDI050)
    Label1: TLabel;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_AC365: TFrmDLII020_AC365;

implementation

uses unGlobal, unCommon, unAC365Service;

{$R *.dfm}

procedure TFrmDLII020_AC365.BitBtn1Click(Sender: TObject);
var
  Soap:AC365ServiceSoap;
  tmpSaleno,ret:string;
begin
  //inherited;
  tmpSaleno:=Trim(Memo1.Lines.DelimitedText);
  if Length(tmpSaleno)=0 then
  begin
    ShowMsg('請輸入出貨單號',48);
    Exit;
  end;

  Soap:=unAC365Service.GetAC365ServiceSoap;
  ret:=Soap.Check(g_UInfo^.BU, tmpSaleno);
  Memo2.Lines.DelimitedText:=StringReplace(StringReplace(ret,',','，',[rfReplaceAll]),' ','',[rfReplaceAll]);
  Memo2.Text:=StringReplace(Memo2.Text,'@@','',[rfReplaceAll]);
  PCL.ActivePageIndex:=1;
end;

procedure TFrmDLII020_AC365.btn_okClick(Sender: TObject);
var
  Soap:AC365ServiceSoap;
  tmpSaleno,ret:string;
begin
  //inherited;
  tmpSaleno:=Trim(Memo1.Lines.DelimitedText);
  if Length(tmpSaleno)=0 then
  begin
    ShowMsg('請輸入出貨單號',48);
    Exit;
  end;

  Soap:=unAC365Service.GetAC365ServiceSoap;
  ret:=Soap.AC365(g_UInfo^.BU, tmpSaleno, g_UInfo^.UserId);
  if Pos('成功', ret)>0 then
     ShowMsg(ret, 64)
  else
     ShowMsg(ret, 48);
end;

procedure TFrmDLII020_AC365.FormCreate(Sender: TObject);
begin
  inherited;
  TabSheet2.Caption:=CheckLang('檢查結果');
end;

end.
