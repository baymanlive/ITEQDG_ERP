library DLII040;

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
  unDLII040 in 'unDLII040.pas' {FrmDLII040},
  unDLII040_prn in 'unDLII040_prn.pas' {FrmDLII040_prn},
  unDLII040_rpt in 'unDLII040_rpt.pas',
  unDLII040_lot in 'unDLII040_lot.pas' {FrmDLII040_lot},
  unDLII040_cocerr in 'unDLII040_cocerr.pas' {FrmDLII040_cocerr},
  unGridDesign in '..\Common\unGridDesign.pas',
  unDLIR050_units in 'unDLIR050_units.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unCheckC_sizes in 'unCheckC_sizes.pas',
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
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
  FrmDLII040:=TFrmDLII040.Create(Application);
  FrmDLII040.Show;
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
