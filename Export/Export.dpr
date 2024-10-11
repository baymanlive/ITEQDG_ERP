library Export;

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
  ComCtrls,
  unExportXLS in 'unExportXLS.pas',
  unExport in 'unExport.pas' {FrmExport},
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas';

var
  DLLH: HWnd;

{$R *.res}

procedure ShowExportForm(AppH:HWnd; UInfo: PUserInfo;
  ConnData:TArrConnData; Data:OleVariant; RecNo:Integer;
  tb, ProcId, XlsCaption, IndexFieldNames: PChar; PBar:TProgressBar); stdcall;
var
  frm:TFrmExport;
begin
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^:=UInfo^;
  g_MInfo^.ProcId:=ProcId;
  g_ConnData:=ConnData;
  g_ExportObj.Data:=Data;
  g_ExportObj.RecNo:=RecNo;
  g_ExportObj.TableName:=tb;
  g_ExportObj.ProcId:=ProcId;
  g_ExportObj.XlsCaption:=XlsCaption;
  g_ExportObj.IndexFieldNames:=IndexFieldNames;
  g_ProgressBar:=PBar;
  DLLH:=Application.Handle;
  Application.Handle:=AppH;
  frm:=TFrmExport.Create(Application);
  try
    frm.ShowModal;
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
  ShowExportForm name 'ShowExportForm';

begin
  DllProc := @ExitDLL;
end.
