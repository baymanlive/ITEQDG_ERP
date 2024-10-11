library ORDI120;

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
  ShareMem,
  SysUtils,
  Classes,
  Windows,
  Forms,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unSTDI030 in '..\Common\unSTDI030.pas' {FrmSTDI030},
  unORDI120 in 'unORDI120.pas' {FrmORDI120};

var
  DLLH: HWnd;

{$R *.res}

procedure ShowDllForm(AppH, DllHandle:HWnd; UInfo: PUserInfo;
  MInfo:PMenuInfo; cbp:TCallBackProc); stdcall;
begin
  g_DllHandle:=DllHandle;
  g_UInfo:=UInfo;
  g_MInfo:=MInfo;
  @g_cbp:=@cbp;
  DLLH:=Application.Handle;
  Application.Handle:=AppH;
  FrmORDI120:=TFrmORDI120.Create(Application);
  FrmORDI120.Show;
end;

procedure ExitDLL(Reason: Integer);
begin
  if Reason = DLL_PROCESS_DETACH then
     Application.Handle := DLLH;
end;

exports
  ShowDllForm name 'ShowDllForm';

begin
  DllProc := @ExitDLL;
end.
