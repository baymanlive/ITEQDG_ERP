library Report;

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
  Controls,
  unReport in 'unReport.pas' {FrmReport},
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unDLI020_prnmark in 'unDLI020_prnmark.pas' {FrmDLII020_prnmark},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas';

var
  DLLH: HWnd;

{$R *.res}

procedure ShowPrintForm(AppH:HWnd; UInfo: PUserInfo;
  ConnData:TArrConnData; ArrPrintData:TArrPrintData;
  SysId, ProcId: PChar; R_rptDesign: Boolean); stdcall;
var
  frm:TFrmReport;
begin
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^:=UInfo^;
  g_MInfo^.ProcId:=ProcId;
  g_MInfo^.ProcName:=SysId;
  g_MInfo^.R_rptDesign:=R_rptDesign;
  g_ConnData:=ConnData;
  g_PrintData:=ArrPrintData;
  DLLH:=Application.Handle;
  Application.Handle:=AppH; 
  frm:=TFrmReport.Create(Application);
  try
    frm.WindowState:=wsMaximized;
    frm.ShowModal;
  finally
    FreeAndNil(frm);
    g_PrintData:=nil;
  end;
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
  ShowPrintForm name 'ShowPrintForm';

begin
  DllProc := @ExitDLL;
end.
