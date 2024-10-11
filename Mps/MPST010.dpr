library MPST010;



uses
  SysUtils,
  Classes,
  Windows,
  Forms,
  ComCtrls,
  unCommon in '..\Common\unCommon.pas',
  unGlobal in '..\Common\unGlobal.pas',
  unMPST010 in 'unMPST010.pas' {FrmMPST010},
  unMPST010_SingleBoiler in 'unMPST010_SingleBoiler.pas',
  unMPST010_SingleLine in 'unMPST010_SingleLine.pas',
  unMPST010_BoilerEdit in 'unMPST010_BoilerEdit.pas' {FrmBoilerEdit},
  unMPST010_Order in 'unMPST010_Order.pas',
  unMPST010_Orderno2Edit in 'unMPST010_Orderno2Edit.pas' {FrmOrderno2Edit},
  unMPST010_StealnoEdit in 'unMPST010_StealnoEdit.pas' {FrmStealnoEdit},
  unFind in '..\Common\unFind.pas' {FrmFind},
  unMPST010_EmptyFlagAdd in 'unMPST010_EmptyFlagAdd.pas' {FrmEmptyFlagAdd},
  unMPST010_EmptyFlagEdit in 'unMPST010_EmptyFlagEdit.pas' {FrmEmptyFlagEdit},
  unMPST010_SqtyEdit in 'unMPST010_SqtyEdit.pas' {FrmSqtyEdit},
  unMPST010_PlanChange in 'unMPST010_PlanChange.pas' {FrmPlanChange},
  unGridDesign in '..\Common\unGridDesign.pas',
  unMPST010_ShowErrList in 'unMPST010_ShowErrList.pas' {FrmShowErrList},
  unMPST010_CalcBooks in 'unMPST010_CalcBooks.pas' {FrmClacBooks},
  unMPST010_Param in 'unMPST010_Param.pas',
  unCustnoGroup in '..\Common\unCustnoGroup.pas' {FrmCustnoGroup},
  unMPST070_bom in 'unMPST070_bom.pas' {FrmMPST070_bom},
  unMPST010_UpdateRemainOrdqty in 'unMPST010_UpdateRemainOrdqty.pas' {FrmUpdateRemainOrdqty},
  unMPST010_UpdateCo in 'unMPST010_UpdateCo.pas' {FrmUpdateCo},
  unMPST010_GetCore in 'unMPST010_GetCore.pas' {FrmMPST010_GetCore},
  unFrmBaseEmpty in '..\Common\unFrmBaseEmpty.pas' {FrmBaseEmpty},
  unSTDI030 in '..\Common\unSTDI030.pas' {FrmSTDI030},
  unSTDI051 in '..\Common\unSTDI051.pas' {FrmSTDI051},
  unSTDI050 in '..\Common\unSTDI050.pas' {FrmSTDI050},
  unMPST010_units in 'unMPST010_units.pas',
  unMPST010_PnoSum in 'unMPST010_PnoSum.pas' {FrmMPST010_PnoSum},
  unDAL in '..\Common\unDAL.pas',
  unSvr in '..\Common\unSvr.pas',
  unCCLStruct in 'unCCLStruct.pas',
  unMPST010_UpdateWono in 'unMPST010_UpdateWono.pas' {FrmMPST010_UpdateWono},
  unFrmWarn in '..\Common\unFrmWarn.pas' {WarnFrm},
  unMPST020_WonoList in 'unMPST020_WonoList.pas' {FrmMPST020_WonoList},
  unMPST010_Wono in '..\mps\unMPST010_Wono.pas';

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
  FrmMPST010:=TFrmMPST010.Create(Application);
  FrmMPST010.Show;
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
