library MPST012;

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
  unMPST012 in 'unMPST012.pas' {FrmMPST012},
  unMPST012_Order in 'unMPST012_Order.pas',
  unFind in '..\Common\unFind.pas' {FrmFind},
  unGridDesign in '..\Common\unGridDesign.pas',
  unMPST010_ShowErrList in 'unMPST010_ShowErrList.pas' {FrmShowErrList},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI030 in '..\Common\unSTDI030.pas' {FrmSTDI030},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unMPST012_units in 'unMPST012_units.pas',
  unMPST012_clear0 in 'unMPST012_clear0.pas' {FrmMPST012_clear0},
  unMPST012_CtrlE in 'unMPST012_CtrlE.pas' {FrmMPST012_CtrlE},
  unMPST012_rqty in 'unMPST012_rqty.pas' {FrmMPST012_rqty},
  unMPST070_bom in 'unMPST070_bom.pas' {FrmMPST070_bom},
  unMPST012_cqty in 'unMPST012_cqty.pas' {FrmMPST012_cqty},
  unMPST012_adqty in 'unMPST012_adqty.pas' {FrmMPST012_adqty},
  unMPST012_adate_qty in 'unMPST012_adate_qty.pas' {FrmMPST012_adate_qty},
  unMPST012_PnoSum in 'unMPST012_PnoSum.pas' {FrmMPST012_PnoSum},
  unDAL in '..\Common\unDAL.pas',
  unMPST012_copy in 'unMPST012_copy.pas' {FrmMPST012_copy},
  unSvr in '..\Common\unSvr.pas',
  unMPST012_ClsStock in 'unMPST012_ClsStock.pas',
  unMPST012_Stck in 'unMPST012_Stck.pas' {FrmMPST012_Stck},
  unMPST070_CalCCL in 'unMPST070_CalCCL.pas' {FrmMPST070_CalCCL};

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
  FrmMPST012:=TFrmMPST012.Create(Application);
  FrmMPST012.Show;
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
