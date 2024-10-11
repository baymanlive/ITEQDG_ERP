program ERPsvr;

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  unMain in 'unMain.pas' {FrmMain},
  unServerMethods in 'unServerMethods.pas' {ServerMethods: TDSServerModule},
  unServerContainer in 'unServerContainer.pas' {ServerContainer: TDataModule},
  unPoolManager in 'unPoolManager.pas',
  unGlobal in 'unGlobal.pas',
  unFuns in 'unFuns.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := g_strAppTitle;
  if CheckIsRunning then
    Application.Terminate
  else
  begin
    Application.CreateForm(TFrmMain, FrmMain);
    Application.CreateForm(TServerContainer, ServerContainer);
    Application.Run;
  end;
end.

