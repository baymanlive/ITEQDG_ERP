library MPST130;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
  unGridDesign in '..\Common\unGridDesign.pas',
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unFind in '..\Common\unFind.pas' {FrmFind},
  unMPST130 in 'unMPST130.pas' {FrmMPST130},
  unMPST130_Query in 'unMPST130_Query.pas' {FrmMPST130_Query},
  unMPST130_Wono in 'unMPST130_Wono.pas',
  unMPST130_WonoList in 'unMPST130_WonoList.pas' {FrmMPST130_WonoList},
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
  FrmMPST130:=TFrmMPST130.Create(Application);
  FrmMPST130.Show;
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
