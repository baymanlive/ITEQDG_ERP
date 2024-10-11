library MPST160;

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unGridDesign in '..\Common\unGridDesign.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI030 in '..\Common\unSTDI030.pas' {FrmSTDI030},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unDAL in '..\Common\unDAL.pas',
  unSvr in '..\Common\unSvr.pas',
  unFrmWarn in '..\Common\unFrmWarn.pas' {WarnFrm},
  unMPST160 in 'unMPST160.pas' {FrmMPST160};

var
  DLLH: HWnd;

{$R *.res}

procedure ShowDllForm(AppHandle, MainHandle, DllHandle: HWnd; UInfo: PUserInfo; MInfo: PMenuInfo; ConnData: TArrConnData; SBar: TStatusBar; PBar: TProgressBar; cbp: TCallBackProc); stdcall;
begin
  g_MainHandle := MainHandle;
  g_DllHandle := DllHandle;
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^ := UInfo^;
  g_MInfo^ := MInfo^;
  g_ConnData := ConnData;
  g_StatusBar := SBar;
  g_ProgressBar := PBar;
  @g_cbp := @cbp;
  DLLH := Application.Handle;
  Application.Handle := AppHandle;
  FrmMPST160 := TFrmMPST160.Create(Application);
  FrmMPST160.Show;
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

