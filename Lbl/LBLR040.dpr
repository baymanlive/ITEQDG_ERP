library LBLR040;

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unGlobal in '..\Common\unGlobal.pas',
  unCommon in '..\Common\unCommon.pas',
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unLBLR040 in 'unLBLR040.pas' {FrmLBLR040};

{$R *.res}

var
  DLLH: HWnd;


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
  FrmLBLR040 := TFrmLBLR040.Create(Application);
  FrmLBLR040.Show;
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

