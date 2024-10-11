library Stock;

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
  unStock in 'unStock.pas' {FrmStock},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unStock_booking2 in 'unStock_booking2.pas' {FrmStock_booking2},
  unStock_booking1 in 'unStock_booking1.pas' {FrmStock_booking1},
  unSvr in '..\Common\unSvr.pas',
  unDAL in '..\Common\unDAL.pas';

var
  DLLH: HWnd;

{$R *.res}

procedure ShowStockForm(AppH:HWnd; UInfo: PUserInfo; MInfo: PMenuInfo;
  Pno, isMPS:PChar); stdcall;
var
  frm:TFrmStock;
begin
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^:=UInfo^;
  g_MInfo^:=MInfo^;
  DLLH:=Application.Handle;
  Application.Handle:=AppH;
  frm:=TFrmStock.Create(Application);
  try
    frm.Edit3.Text:=Pno;
    frm.l_isMPS:=isMPS='1';
    frm.l_sourceProcid:='';
    frm.ShowModal;
  finally
    FreeAndNil(frm);
  end;
end;


procedure ShowStockForm2(AppH:HWnd; UInfo: PUserInfo; MInfo: PMenuInfo;
  Pno, SourceProcId:PChar); stdcall;
var
  frm:TFrmStock;
begin
  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^:=UInfo^;
  g_MInfo^:=MInfo^;
  DLLH:=Application.Handle;
  Application.Handle:=AppH;
  frm:=TFrmStock.Create(Application);
  try
    frm.Edit3.Text:=Pno;
    frm.l_sourceProcid:=SourceProcId;
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
  ShowStockForm name 'ShowStockForm',
  ShowStockForm2 name 'ShowStockForm2';

begin
  DllProc := @ExitDLL;
end.
