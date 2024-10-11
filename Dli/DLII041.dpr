library DLII041;

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
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unGlobal in '..\Common\unGlobal.pas',
  unGridDesign in '..\Common\unGridDesign.pas',
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
  unDLII041 in 'unDLII041.pas' {FrmDLII041},
  unDLII041_prn in 'unDLII041_prn.pas' {FrmDLII041_prn},
  unDLII041_rpt in 'unDLII041_rpt.pas',
  unCheckC_sizes in 'unCheckC_sizes.pas',
  unDLII040_cocerr in 'unDLII040_cocerr.pas' {FrmDLII040_cocerr},
  unDLIR050_units in 'unDLIR050_units.pas',
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unFrmWarn in '..\Common\unFrmWarn.pas' {WarnFrm};

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
  FrmDLII041:=TFrmDLII041.Create(Application);
  FrmDLII041.Show;
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
