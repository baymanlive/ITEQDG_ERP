library MDT060;

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
  unSTDI080 in '..\Common\unSTDI080.pas' {FrmSTDI080},
  unMDT060 in 'unMDT060.pas' {FrmMDT060},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unMDT060_img in 'unMDT060_img.pas' {FrmMDT060_img},
  unMDT060_lot in 'unMDT060_lot.pas' {FrmMDT060_lot},
  unMDT060_scrapcode in 'unMDT060_scrapcode.pas' {FrmMDT060_scrapcode},
  unMDT060_newlot in 'unMDT060_newlot.pas' {FrmMDT060_newlot},
  unMDT060_stopcode in 'unMDT060_stopcode.pas' {FrmMDT060_stopcode},
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
  FrmMDT060:=TFrmMDT060.Create(Application);
  FrmMDT060.Show;
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
