program ERPServer;

uses
  Forms,
  unMain in 'unMain.pas' {FrmMain},
  ERPServer_TLB in 'ERPServer_TLB.pas',
  unRdm in 'unRdm.pas' {Rdm: TRemoteDataModule} {Rdm: CoClass},
  unFuns in 'unFuns.pas',
  unUserManager in 'unUserManager.pas',
  unGlobal in 'unGlobal.pas',
  unPoolManager in 'unPoolManager.pas';

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ERP_APPServer';
  if CheckIsRunning then
     Application.Terminate
  else begin
    Application.CreateForm(TFrmMain, FrmMain);
    Application.Run;
  end;
end.
