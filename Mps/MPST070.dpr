library MPST070;

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
  unFind in '..\Common\unFind.pas' {FrmFind},
  unGridDesign in '..\Common\unGridDesign.pas',
  unMPST070 in 'unMPST070.pas' {FrmMPST070},
  unMPST070_Order in 'unMPST070_Order.pas',
  unMPST070_Param in 'unMPST070_Param.pas',
  unMPST070_ShowErrList in 'unMPST070_ShowErrList.pas' {FrmMPST070_ShowErrList},
  unMPST070_GetCore in 'unMPST070_GetCore.pas' {FrmMPST070_GetCore},
  unMPST070_CtrlE in 'unMPST070_CtrlE.pas' {FrmMPS070_CtrlE},
  unMPST070_Orderno2Edit in 'unMPST070_Orderno2Edit.pas' {FrmMPST070_Orderno2Edit},
  unMPST070_EmptyFlagEdit in 'unMPST070_EmptyFlagEdit.pas' {FrmMPST070_EmptyFlagEdit},
  unMPST070_EmptyFlagAdd in 'unMPST070_EmptyFlagAdd.pas' {FrmMPST070_EmptyFlagAdd},
  unMPST070_Mps in 'unMPST070_Mps.pas',
  unMPST070_cdsxml in 'unMPST070_cdsxml.pas',
  unMPST070_Orderby in 'unMPST070_Orderby.pas' {FrmMPST070_Orderby},
  unMPST070_SetSdate in 'unMPST070_SetSdate.pas' {FrmMPST070_SetSdate},
  unMPST070_SwapSdate in 'unMPST070_SwapSdate.pas' {FrmMPST070_SwapSdate},
  unMPST070_UseCoreDetail in 'unMPST070_UseCoreDetail.pas' {FrmMPST070_UseCoreDetail},
  unMPST070_bom in 'unMPST070_bom.pas' {FrmMPST070_bom},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI030 in '..\Common\unSTDI030.pas' {FrmSTDI030},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  TWODbarcode in 'TWODbarcode.pas',
  unMPST070_Print in 'unMPST070_Print.pas' {FrmMPST070_Print},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unMPST070_UpdateWono in 'unMPST070_UpdateWono.pas' {FrmMPST070_UpdateWono},
  unMPST070_CalPP in 'unMPST070_CalPP.pas' {FrmMPST070_CalPP};

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
  FrmMPST070:=TFrmMPST070.Create(Application);
  FrmMPST070.Show;
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
