library DLIR050;

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
  unDLIR050 in 'unDLIR050.pas' {FrmDLIR050},
  unDLIR050_Query in 'unDLIR050_Query.pas' {FrmDLIR050_Query},
  unDLII040_prn in 'unDLII040_prn.pas' {FrmDLII040_prn},
  unDLII040_rpt in 'unDLII040_rpt.pas',
  unDLIR050_prn in 'unDLIR050_prn.pas' {FrmDLIR050_prn},
  unDLII040_lot in 'unDLII040_lot.pas' {FrmDLII040_lot},
  unDLII040_cocerr in 'unDLII040_cocerr.pas' {FrmDLII040_cocerr},
  unGridDesign in '..\Common\unGridDesign.pas',
  unDLIR050_units in 'unDLIR050_units.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unCheckC_sizes in 'unCheckC_sizes.pas',
  unSvr in '..\Common\unSvr.pas',
  unDLII041_prn in 'unDLII041_prn.pas' {FrmDLII041_prn},
  unDLII041_rpt in 'unDLII041_rpt.pas',
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
  FrmDLIR050:=TFrmDLIR050.Create(Application);
  FrmDLIR050.Show;
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
