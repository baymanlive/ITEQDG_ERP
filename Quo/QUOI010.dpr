library QUOI010;

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
  unSTDI031 in '..\Common\unSTDI031.pas' {FrmSTDI031},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unQUOI010 in 'unQUOI010.pas' {FrmQUII010};

var
  DLLH: HWnd;

{$R *.res}

procedure ShowDllForm(AppHandle, MainHandle, DllHandle: HWnd; UInfo: PUserInfo; MInfo: PMenuInfo; ConnData: TArrConnData;
  SBar: TStatusBar; PBar: TProgressBar; cbp: TCallBackProc); stdcall;
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
  FrmQUII010 := TFrmQUII010.Create(Application);
  FrmQUII010.Show;
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

