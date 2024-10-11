library MPST040;

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
  unGridDesign in '..\Common\unGridDesign.pas',
  unMPST040 in 'unMPST040.pas' {FrmMPST040},
  unMPST040_IndateOrd in 'unMPST040_IndateOrd.pas' {FrmMPST040_IndateOrd},
  unMPST040_pnlwono in 'unMPST040_pnlwono.pas' {FrmMPST040_pnlwono},
  unFind in '..\Common\unFind.pas' {FrmFind},
  unMPST040_Indate in 'unMPST040_Indate.pas' {FrmMPST040_Indate},
  unMPST040_IndateClass in 'unMPST040_IndateClass.pas',
  unMPST040_ordlist in 'unMPST040_ordlist.pas' {FrmMPST040_ordlist},
  unMPST040_confirm in 'unMPST040_confirm.pas' {FrmMPST040_confirm},
  unMPST040_units in 'unMPST040_units.pas',
  unMPST040_mps in 'unMPST040_mps.pas' {FrmunMPST040_mps},
  unMPS_IcoFlag in 'unMPS_IcoFlag.pas',
  unMPST040_IndateChg in 'unMPST040_IndateChg.pas' {FrmMPST040_IndateChg},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI060 in '..\Common\unSTDI060.pas' {FrmSTDI060},
  unMPST040_UpdateCustOrderno in 'unMPST040_UpdateCustOrderno.pas' {FrmMPST040_UpdateCustOrderno},
  unMPST040_gz in 'unMPST040_gz.pas' {FrmMPST040_gz},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unCCLStruct in 'unCCLStruct.pas',
  unMPST040_Dtp in 'unMPST040_Dtp.pas' {FrmMPST040_Dtp},
  unExportXLS in '..\Export\unExportXLS.pas';

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
  FrmMPST040:=TFrmMPST040.Create(Application);
  FrmMPST040.Show;
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
