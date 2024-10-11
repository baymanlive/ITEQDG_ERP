library Query;

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
  unQuery in 'unQuery.pas' {FrmQuery},
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas';

var
  DLLH: HWnd;

{$R *.res}

function ShowQueryForm(AppH:HWnd; UInfo: PUserInfo;
  ConnData:TArrConnData; tb, ProcId, OutSQL:PChar):Boolean; stdcall;
var
  tmpStr:string;
  frm:TFrmQuery;
begin
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^:=UInfo^;
  g_MInfo^.ProcId:=ProcId;
  g_MInfo^.ProcName:=tb;
  g_ConnData:=ConnData;
  DLLH:=Application.Handle;
  Application.Handle:=AppH;
  frm:=TFrmQuery.Create(Application);
  try
    Result:=frm.ShowModal=mrOK;
    if Result then
       tmpStr:=frm.ResultSQL
    else
       tmpStr:='';
    StrPCopy(OutSQL, PChar(tmpStr));
  finally
    FreeAndNil(frm);
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
  ShowQueryForm name 'ShowQueryForm';

begin
  DllProc := @ExitDLL;
end.
