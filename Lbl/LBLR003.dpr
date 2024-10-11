library LBLR003;

uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unGridDesign in '..\Common\unGridDesign.pas',
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unLBLR003 in 'unLBLR003.pas' {FrmLBLR003};

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
  FrmLBLR003 := TFrmLBLR003.Create(Application);
  FrmLBLR003.Show;
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

