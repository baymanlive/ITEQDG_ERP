unit unDLIT802;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin;

type
  TFrmDLIT802 = class(TFrmSTDI080)
    Label3: TLabel;
    Edit3: TEdit;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label4: TLabel;
    Memo1: TMemo;
    btn_conf: TToolButton;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_confClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT802: TFrmDLIT802;

implementation

uses unGlobal, unCommon, unDLIT802Service;

{$R *.dfm}

procedure TFrmDLIT802.FormCreate(Sender: TObject);
begin
  p_TableName:='@';
  btn_conf.Left:=btn_print.Left;

  inherited;
  
  btn_print.Visible:=False;
  btn_export.Visible:=False;
  btn_query.Visible:=False;
  Label3.Caption:=CheckLang('送貨單號');
  Label4.Caption:=CheckLang('儲位');
  Label5.Caption:=IntToStr(Memo1.Lines.Count);
end;

procedure TFrmDLIT802.Memo1Change(Sender: TObject);
begin
  inherited;
  Label5.Caption:=IntToStr(Memo1.Lines.Count);
end;

//此作業顯示即有權限進行操作
procedure TFrmDLIT802.btn_confClick(Sender: TObject);
var
  i:Integer;
  tmpSaleno,tmpArea,ret:string;
  Soap:DLIT802ServiceSoap;
begin
  inherited;

  tmpSaleno:=UpperCase(Trim(Edit3.Text));
  if (Length(tmpSaleno)<>10) or (Copy(tmpSaleno,4,1)<>'-') then
  begin
    ShowMsg('請輸入送貨單號!',48);
    Edit3.SetFocus;
    Exit;
  end;

  for i:=0 to Memo1.Lines.Count-1 do
  begin
    if Length(Trim(Memo1.Lines[i]))=0 then
    begin
      ShowMsg('第'+IntToStr(i+1)+'行,請輸入儲位!',48);
      Memo1.SetFocus;
      Exit;
    end;

    if Pos('|',Memo1.Lines[i])>0 then
    begin
      ShowMsg('第'+IntToStr(i+1)+'行,不可包含特殊字符"|"',48);
      Memo1.SetFocus;
      Exit;
    end;

    if Length(tmpArea)>0 then
       tmpArea:=tmpArea+'|';
    tmpArea:=tmpArea+UpperCase(Trim(Memo1.Lines[i]));
  end;

  Soap:=unDLIT802Service.GetDLIT802ServiceSoap;
  ret:=Soap.cimt324dw_add(g_UInfo^.BU, tmpSaleno, tmpArea, UpperCase(g_UInfo^.UserId));
  if Pos('成功', ret)>0 then
     ShowMsg(ret, 64)
  else
     ShowMsg(ret, 48);
end;

end.
