unit unDLII020_ACC58;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmDLII020_ACC58 = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_ACC58: TFrmDLII020_ACC58;

implementation

uses unGlobal, unCommon, unACC58Service;

{$R *.dfm}

procedure TFrmDLII020_ACC58.btn_okClick(Sender: TObject);
var
  Soap:ACC58ServiceSoap;
  tmpSaleno,ret:string;
begin
  //inherited;
  tmpSaleno:=Trim(Edit1.Text);
  if Length(tmpSaleno)=0 then
  begin
    ShowMsg('請輸入出貨單號',48);
    Exit;
  end;

  Soap:=unACC58Service.GetACC58ServiceSoap;
  ret:=Soap.ACC58(g_UInfo^.BU, tmpSaleno, g_UInfo^.UserId);
  if Pos('成功', ret)>0 then
     ShowMsg(ret, 64)
  else
     ShowMsg(ret, 48);
end;

end.
