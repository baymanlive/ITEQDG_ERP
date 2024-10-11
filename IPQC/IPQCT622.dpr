library IPQCT622;

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
  unFrmBase in '..\Common\unFrmBase.pas' {FrmBase},
  unSTDI080 in '..\Common\unSTDI080.pas' {FrmSTDI080},
  unIPQCT622 in 'unIPQCT622.pas' {FrmIPQCT622},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unIPQCT622_query in 'unIPQCT622_query.pas' {FrmIPQCT622_query},
  unIPQCT622_lot in 'unIPQCT622_lot.pas' {FrmIPQCT622_lot},
  unIPQCT622_ad in 'unIPQCT622_ad.pas' {FrmIPQCT622_ad},
  unIPQCT622_detail in 'unIPQCT622_detail.pas' {FrmIPQCT622_detail},
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
  FrmIPQCT622:=TFrmIPQCT622.Create(Application);
  FrmIPQCT622.Show;
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
 