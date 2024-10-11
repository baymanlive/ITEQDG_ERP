library DLII020;

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
  unDLII020 in 'unDLII020.pas' {FrmDLII020},
  unDLII020_sale in 'unDLII020_sale.pas',
  unGridDesign in '..\Common\unGridDesign.pas',
  unDLII020_upd in 'unDLII020_upd.pas' {FrmDLII020_upd},
  unDLII020_btnopt in 'unDLII020_btnopt.pas',
  TWODbarcode in 'TWODbarcode.pas',
  unDLII020_const in 'unDLII020_const.pas',
  unDLII020_prn in 'unDLII020_prn.pas',
  unDLII020_prnconf in 'unDLII020_prnconf.pas' {FrmDLII020_prnconf},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unSTDI041 in '..\Common\unSTDI041.pas' {FrmSTDI041},
  unDLII020_qrcode in 'unDLII020_qrcode.pas' {FrmDLII020_qrcode},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas',
  unDLII020_AC101_remark in 'unDLII020_AC101_remark.pas' {FrmDLII020_AC101_remark};

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
  FrmDLII020:=TFrmDLII020.Create(Application);
  FrmDLII020.Show;
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
