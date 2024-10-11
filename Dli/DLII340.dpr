library DLII340;



uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unDLII340 in 'unDLII340.pas' {FrmDLII340},
  unGridDesign in '..\Common\unGridDesign.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI031 in '..\Common\unSTDI031.pas' {FrmSTDI031},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas';

var
  DLLH: HWnd;

{$R *.res}

procedure ShowDllForm(AppHandle, MainHandle, DllHandle:HWnd; UInfo: PUserInfo;
  MInfo:PMenuInfo; ConnData:TArrConnData;
  SBar:TStatusBar; PBar:TProgressBar; cbp:TCallBackProc); stdcall;
begin
  g_MainHandle:=MainHandle;
  g_DllHandle:=DllHandle;
  New(g_UInfo);
  New(g_MInfo);
  
  g_UInfo^:=UInfo^;
  g_MInfo^:=MInfo^;
  
  g_ConnData:=ConnData;
  g_StatusBar:=SBar;
  g_ProgressBar:=PBar;
  @g_cbp:=@cbp;
  DLLH:=Application.Handle;
  Application.Handle:=AppHandle;
  FrmDLII340:=TFrmDLII340.Create(Application);
  FrmDLII340.Show;
end;

procedure ExitDLL(Reason: Integer);
begin
  if Reason = DLL_PROCESS_DETACH then
  begin
    Dispose(g_UInfo);
    Dispose(g_MInfo);
    
    Application.Handle := DLLH;
  end;
end;

exports
  ShowDllForm name 'ShowDllForm';

begin
  DllProc := @ExitDLL;
end.