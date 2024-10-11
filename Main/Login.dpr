program Login;

uses
  ShareMem,
  Forms,
  SysUtils,
  Controls,
  unMain in 'unMain.pas' {FrmMain},
  unLogin in 'unLogin.pas' {FrmLogin},
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unPW in 'unPW.pas' {FrmPW},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unFavorite in 'unFavorite.pas' {FrmFavorite},
  unDAL in '..\Common\unDAL.pas',
  unSvr in '..\Common\unSvr.pas';

{$R *.res}

begin
  Application.Initialize;
  FrmLogin:=TFrmLogin.Create(nil);
  if FrmLogin.ShowModal<>mrOK then
     Halt
  else
     FrmLogin.Hide;
  Application.Title := 'ITEQ ERP';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
