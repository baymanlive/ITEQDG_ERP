{*******************************************************}
{                                                       }
{                unCommon                               }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: ¨ç¼Æ                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unCommon;

interface

uses
  Windows, Classes, SysUtils, Forms, Messages, StdCtrls, ExtCtrls, DBClient, DB, ComObj, ComCtrls, Variants, Controls,
  DBCtrls, StrUtils, DBGridEh, DBCtrlsEh, Buttons, Grids, //unFrmWarn,
  Dialogs, ShellApi, XMLDoc, XMLIntf, unGlobal, DateUtils, IniFiles, unDAL, unSvr;


function BIG5ToGB(BIG5Str: string): AnsiString;

function admin: boolean;

function Calc(expStr: string): Currency;

function CheckLang(Str: string): string;

function ShowMsg(Msg: string; Flags: Integer = 48; const FormatStr: string = ''): Integer;

function ShowAdm(Msg: string; Flags: Integer = 48; const FormatStr: string = ''): Integer;

procedure ShowSvrMsg(Msg: string);

  //*******¤¤¶¡¼h±µ¤f********
function QueryBySQL(SQL: string; var Data: OleVariant; const DBType: string = ''): Boolean;

function QueryOneCR(SQL: string; var Data: OleVariant; const DBType: string = ''): Boolean;

function QueryExists(SQL: string; var isExist: Boolean; const DBType: string = ''): Boolean;

function PostBySQL(SQL: string; const DBType: string = ''): Boolean;

function CDSPost(DataSet: TClientDataSet; TableName: string; const DBType: string = ''): Boolean;

function CheckLockProc(var isLock: Boolean; const ProcId: string = ''): Boolean;

function LockProc: Boolean;

function UnLockProc: Boolean;

function GetMPSEmptyOZ(Jitem, Filter: string; var OZ: string): Boolean;
  //*******¤¤¶¡¼h±µ¤f********

procedure SetPnlRightBtn(pnl: TPanel; isEdit: Boolean);

procedure DBGridEhSelNext(const grdEh: TDBGridEh; var Key: Word);

function GetSno(Kind: string; const Bu: string = ''): string;

function CheckPK(ds: TDataSet; TableName: string; var ErrFName: string): Boolean;

function StringToOleData(const AText: string): OleVariant;

//function JxRemark(const Remark: string; var custno: string): Boolean; overload;

function JxRemark(const Remark: string; var custInfo:TCustInfo): Boolean;

//function JxRemark(const Remark: string; var dno: string; var ditem :integer): Boolean;overload;

procedure GetPrintObj(SysId: string; ArrPrintData: TArrPrintData; const ProcId: string = '');

procedure GetExportXls(CDS: TClientDataSet; TableName: string);

function GetQueryString(TableName: string; var QueryStr: string): Boolean;

procedure GetQueryStock(Pno: string; isMPS: Boolean); overload;

procedure GetQueryStock(Pno, SourceProc: string); overload;

procedure SetGrdCaption(const grdEh: TDBGridEh; TableName: string);

procedure SetMoreGrdCaption(xGrdEh: TGrdEh);

procedure SetLabelCaption(WinCtrl: TWinControl; TableName: string);

procedure SetStrings(Dest: TStrings; const SrcFieldName, SrcTableName: string);

procedure SetAscDesc(CDS: TClientDataSet; Column: TColumnEh; var StrIndex, StrIndexDesc: string);

procedure RefreshGrdCaption(CDS: TClientDataSet; Grd: TDBGridEh; var StrIndex, StrIndexDesc: string);

function VarToSQL(Value: Variant): string;

function PostBySQLFromDelta(DataSet: TClientDataSet; TableName, PrimaryKey: string; const DBType: string = ''): Boolean;

procedure CMDDeleteFile(Path, Ext: string);

procedure InitCDS(DataSet: TClientDataSet; Xml: string);

procedure SetClipboardText(AStr: string);

function myStringReplace(Source: string): string;

procedure CopyDataSendMsg(H: HWND; Msg: string);

function GetKG(Saleno: string; Saleitem: Integer; Flag: Integer): Double;

function GetKG2(Orderno: string; Orderitem: Integer; Flag: Integer): Double;

procedure XlsImport(const TableName: string; DataSet: TClientDataSet; const grdEh: TDBGridEh; bu: string = '');

function GetYM: string;

function GetNewNo(id, no: string): string;

function GetSaleNo_Id(Orderno: string; vflag: Integer): string;

function GetC_Orderno(custno, oea10, oao06: string): string;

function GetLotDate(Lot: string; BaseDate: TDateTime): TDateTime;

function GetLotDateHJ(Lot: string; BaseDate: TDateTime): TDateTime;

function GetPrdDate1(xLot: string): string;

function GetPrdDate2(xLot: string): string;

function GetPrdDate3(xLot: string): string;

function GetLstDate1(xIsPP: Boolean; xPrdDate1: string): string;

function LstDate(BaseDate: TDateTime; pno1: string): TDateTime;

function GetPrd_LstDate(xDate: string): string;

function ConvertDate(Value: string; var D: TDateTime): Boolean;

function GetOea10(const orderno, remark, oea10: string): string;

function GetQRCodeSno(Custno: string; Wdate: TDateTime): Integer;

function SetQRCodeSno(Custno: string; Wdate: TDateTime; Sno: Integer): Boolean;

function LBLSno(Custno: string): string;

function MustChangePW(out xChangePW: Boolean): Boolean;

procedure RefreshSno(DataSet: TClientDataSet; xTb, xFname, xFvalue: string);

procedure InsertRec(DataSet: TClientDataSet);

function Get_PPMRL(pno, qty: string; DataSet: TClientDataSet): boolean;

function SetConf(DataSet: TClientDataSet; TableName: string): Boolean;

function CheckAsyncConf(xIsConf: Boolean; xTb, xFname, xFvalue: string; hasGarbage: Boolean): Boolean;

function GetDAL(DBtype: string): TDAL;

function guid: string;

function IsAdmin: Boolean;

function StringGridToXls(AGrid: TStringGrid): Boolean;

function RefToCell(ARow, ACol: Integer): string;

function occ02(occ01: string): string;

function SplitString(const Source, ch: string): TStringList;

//procedure Warn(msg:string;backGroundColor: TColor=clRed);

var _:string; _i:integer;

procedure GetMPSMachine;

implementation


//procedure Warn(msg:string;backGroundColor: TColor);
//begin
//  WarnFrm:=TWarnFrm.Create(nil);
//  try
//    WarnFrm.Label1.Caption:=msg;
//    WarnFrm.Color:=backGroundColor;
//    WarnFrm.ShowModal;
//  finally
//    WarnFrm.free;
//  end;
//end;


function SplitString(const Source, ch: string): TStringList;
var
  Temp: string;
  I: Integer;
  chLength: Integer;
begin
  Result := TStringList.Create;
  if Source = '' then
    Exit;
  Temp := Source;
  I := Pos(ch, Source);
  chLength := Length(ch);
  while I <> 0 do
  begin
    Result.Add(Copy(Temp, 0, I - 1));
    Delete(Temp, 1, I - 1 + chLength);
    I := Pos(ch, Temp);
  end;
  Result.Add(Temp);
end;

function occ02(occ01: string): string;
var
  data: OleVariant;
  sql: string;
begin
  result := '';
  sql := 'select occ02 from ' + g_uinfo^.BU + '.occ_file where occ01=' + QuotedStr(occ01);
  if QueryOneCR(sql, data, 'ORACLE') then
    result := VarToStr(data);
end;

function RefToCell(ARow, ACol: Integer): string;
begin
  Result := Chr(Ord('A') + ACol - 1) + IntToStr(ARow);
end;

function StringGridToXls(AGrid: TStringGrid): Boolean;//; ASheetName, AFileName: string): Boolean;
const
  xlWBATWorksheet = -4167;
var
  XLApp, Sheet, Data: OLEVariant;
  i, j: Integer;
  path: string;
  SaveDialog: TSaveDialog;
begin
  // Prepare Data
  Data := VarArrayCreate([1, AGrid.RowCount, 1, AGrid.ColCount], varVariant);
  for i := 0 to AGrid.ColCount - 1 do
    for j := 0 to AGrid.RowCount - 1 do
      Data[j + 1, i + 1] := AGrid.Cells[i, j];
  // Create Excel-OLE Object
  Result := False;
  XLApp := CreateOleObject('Excel.Application');
  SaveDialog := TSaveDialog.Create(nil);
  try
    // Hide Excel
    XLApp.Visible := False;
    // Add new Workbook
    XLApp.Workbooks.Add(xlWBatWorkSheet);
    Sheet := XLApp.Workbooks[1].WorkSheets[1];
    Sheet.Name := 'Sheet1'; //ASheetName;
    // Fill up the sheet
    Sheet.Range[RefToCell(1, 1), RefToCell(AGrid.RowCount, AGrid.ColCount)].Value := Data;
    // Save Excel Worksheet

    SaveDialog.Title := CheckLang('¸ê®Æ¥t¦s');
    SaveDialog.Filter := CheckLang('excel(*.xls)|*.xls');
    SaveDialog.DefaultExt := '.xls';
    if not SaveDialog.Execute then
      exit;
    try
      XLApp.Workbooks[1].SaveAs(SaveDialog.filename);
      Result := True;
//      ShellExecute(Application.Handle, 'open',PAnsiChar( path), nil, nil, SW_SHOWNORMAL);
    except
      // Error ?
    end;
  finally
    // Quit Excel
    if not VarIsEmpty(XLApp) then
    begin
      XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLApp := Unassigned;
      Sheet := Unassigned;
    end;
    SaveDialog.free;
  end;
end;

function IsAdmin: boolean;
begin
  result := sametext(g_uinfo^.UserId, 'ID150515');
end;

function guid: string;
begin
  result := CreateClassID;
  Delete(result, 1, 1);
  Delete(result, Length(result), 1);
end;

function Calc(expStr: string): Currency;
var
  js: OleVariant;
begin
  js := CreateOleObject('ScriptControl');
  js.Language := 'JavaScript';
  Result := strtofloat(js.Eval(expStr));
  js := Unassigned;
end;

//tw->cn
function BIG5ToGB(BIG5Str: string): AnsiString;
var
  Len: Integer;
  pBIG5Char: PChar;
  pCHSChar: PChar;
  pCHTChar: PChar;
  pUniCodeChar: PWideChar;
begin
  //String -> PChar
  pBIG5Char := PChar(BIG5Str);
  Len := MultiByteToWideChar(950, 0, pBIG5Char, -1, nil, 0);
  GetMem(pUniCodeChar, Len * 2);
  ZeroMemory(pUniCodeChar, Len * 2);
  //Big5 -> UniCode
  MultiByteToWideChar(950, 0, pBIG5Char, -1, pUniCodeChar, Len);
  Len := WideCharToMultiByte(936, 0, pUniCodeChar, -1, nil, 0, nil, nil);
  GetMem(pCHTChar, Len * 2);
  GetMem(pCHSChar, Len * 2);
  ZeroMemory(pCHTChar, Len * 2);
  ZeroMemory(pCHSChar, Len * 2);
  //UniCode->GB CHT
  WideCharToMultiByte(936, 0, pUniCodeChar, -1, pCHTChar, Len, nil, nil);
  //GB CHT -> GB CHS
  LCMapString($804, LCMAP_SIMPLIFIED_CHINESE, pCHTChar, -1, pCHSChar, Len);
  Result := string(pCHSChar);
  FreeMem(pCHTChar);
  FreeMem(pCHSChar);
  FreeMem(pUniCodeChar);
end;

//Âà´«»y¨¥œñ“Q
function CheckLang(Str: string): string;
begin
  if g_UInfo^.isCN then
    Result := BIG5ToGB(Str)
  else
    Result := Str
end;

//Åã¥Ü«H®§
//¦s¦bFormatStr°Ñ¼Æ,FormatStr¤£Âà´«»y¨¥,¨Ï¥Î%s®æ¦¡,Msg¥²»Ý±a%s
function ShowMsg(Msg: string; Flags: Integer = 48; const FormatStr: string = ''): Integer;
const
  strHint = '´£¥Ü';
var
  H: HWND;
  tmpMsg: string;
begin
  if Screen.ActiveForm = nil then
    H := Application.Handle
  else
    H := Screen.ActiveForm.Handle;
  tmpMsg := CheckLang(Msg);
  if Length(FormatStr) > 0 then
    tmpMsg := Format(tmpMsg, [FormatStr]);
  Result := MessageBox(H, PAnsiChar(tmpMsg), PAnsiChar(CheckLang(strHint)), Flags);
end;

function ShowAdm(Msg: string; Flags: Integer = 48; const FormatStr: string = ''): Integer;
begin
  if SameText(g_UInfo^.UserId, 'ID150515') then
    result := ShowMsg(Msg, Flags, FormatStr)
  else
    result := 0;
end;

//ªA°È¾¹ªð¦^«H®§´£¥Ü
procedure ShowSvrMsg(Msg: string);
const
  strHint = '´£¥Ü';
var
  H: HWND;
begin
  if Screen.ActiveForm = nil then
    H := Application.Handle
  else
    H := Screen.ActiveForm.Handle;
  MessageBox(H, PAnsiChar(Msg), PAnsiChar(CheckLang(strHint)), 48);
end;

//¬d¸ß¼Æ¾Ú
function QueryBySQL(SQL: string; var Data: OleVariant; const DBType: string = ''): Boolean;
var
  DB, Err: string;
  DAL: TDAL;
begin
  DB := DBType;
  if Length(DB) = 0 then
    DB := g_UInfo^.DBType;
  DAL := GetDAL(DB);
  if DAL <> nil then
    Result := DAL.QueryBySQL(SQL, Data, Err)
  else
    Result := TSvr.QueryBySQL(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, DB, SQL, Data, Err);
  if not Result then
    ShowSvrMsg('QueryBySQL Error:' + #13#10 + Err);
end;

//¬d¸ß¤@¦æ¤@¦C:Data¬°³æ¤@­È
function QueryOneCR(SQL: string; var Data: OleVariant; const DBType: string = ''): Boolean;
var
  DB, Err: string;
  DAL: TDAL;
begin
  Data := null;
  DB := DBType;
  if Length(DB) = 0 then
    DB := g_UInfo^.DBType;
  DAL := GetDAL(DB);
  if DAL <> nil then
    Result := DAL.QueryOneCR(SQL, Data, Err)
  else
    Result := TSvr.QueryOneCR(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, DB, SQL, Data, Err);
  if not Result then
    ShowSvrMsg('QueryOneCR Error:' + #13#10 + Err);
end;



//¬d¸ßµ²ªG¬O§_¦s¦b
function QueryExists(SQL: string; var isExist: Boolean; const DBType: string = ''): Boolean;
var
  DB, Err: string;
  DAL: TDAL;
begin
  DB := DBType;
  if Length(DB) = 0 then
    DB := g_UInfo^.DBType;
  DAL := GetDAL(DB);
  if DAL <> nil then
    Result := DAL.QueryExists(SQL, isExist, Err)
  else
    Result := TSvr.QueryExists(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, DB, SQL, isExist, Err);
  if not Result then
    ShowSvrMsg('QueryExists Error:' + #13#10 + Err);
end;

//¸ê®Æ´£¥æ: ³q¹L§ó·sªºSQL»y¥y
function PostBySQL(SQL: string; const DBType: string = ''): Boolean;
var
  DB, Err: string;
  DAL: TDAL;
begin
  DB := DBType;
  if Length(DB) = 0 then
    DB := g_UInfo^.DBType;
  DAL := GetDAL(DB);
  if DAL <> nil then
    Result := DAL.PostBySQL(SQL, Err)
  else
    Result := TSvr.PostBySQL(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, DB, SQL, Err);
  if not Result then
    ShowSvrMsg('PostBySQL Error:' + #13#10 + Err);
end;

//¸ê®Æ´£¥æ: ³q¹LDelta§ó·s
function CDSPost(DataSet: TClientDataSet; TableName: string; const DBType: string = ''): Boolean;
var
  DB, Err: string;
  DAL: TDAL;
begin
  if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Post;

  if DataSet.ChangeCount = 0 then
  begin
    Result := True;
    Exit;
  end;

  DB := DBType;
  if Length(DB) = 0 then
    DB := g_UInfo^.DBType;
  DAL := GetDAL(DB);
  if DAL <> nil then
    Result := DAL.CDSPost(DataSet.Delta, TableName, Err)
  else
    Result := TSvr.PostByDelta(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, DB, TableName, DataSet.Delta, Err);
  if Result then
    DataSet.MergeChangeLog
  else
    ShowSvrMsg('PostByDetla Error:' + #13#10 + Err);
end;

//ÀË¬d¬O§_¤wÂê©w¾Þ§@
//MsgÅã¥Ü«H®§
//LockAns:¤wÂê©w
function CheckLockProc(var isLock: Boolean; const ProcId: string = ''): Boolean;
var
  tmpProcId, Err: string;
begin
  if Length(ProcId) = 0 then
    tmpProcId := g_MInfo^.ProcId + '_' + RightStr(g_UInfo^.BU, 2)
  else
    tmpProcId := ProcId + '_' + RightStr(g_UInfo^.BU, 2);
  Result := GetDAL(g_UInfo^.DBType).CheckLockProc(tmpProcId, isLock, Err);
  if not Result then
    ShowSvrMsg('CheckLockProc Error:' + #13#10 + Err);
end;

//Âê©w¾Þ§@
function LockProc: Boolean;
var
  tmpProcId, Err: string;
begin
  tmpProcId := g_MInfo^.ProcId + '_' + RightStr(g_UInfo^.BU, 2);
  Result := GetDAL(g_UInfo^.DBType).LockProc(tmpProcId, Err);
  if not Result then
    ShowSvrMsg('LockProc Error:' + #13#10 + Err);
end;

//¸Ñ°£Âê©w
function UnLockProc: Boolean;
var
  tmpProcId, Err: string;
begin
  tmpProcId := g_MInfo^.ProcId + '_' + RightStr(g_UInfo^.BU, 2);
  Result := GetDAL(g_UInfo^.DBType).UnLockProc(tmpProcId, Err);
  if not Result then
    ShowSvrMsg('UnLockProc Error:' + #13#10 + Err);
end;

//¨úªÅÁç»Éºä
function GetMPSEmptyOZ(Jitem, Filter: string; var OZ: string): Boolean;
var
  Err: string;
begin
  Result := GetDAL(g_UInfo^.DBType).GetMPSEmptyOZ(Jitem, Filter, OZ, Err);
  if not Result then
    ShowSvrMsg('GetMPSEmptyOZ Error:' + #13#10 + Err);
end;

//³]¸m¥kÃä¤u¨ã«ö§áÅã¥Üª¬ºA»PÅã¥Ü¦ì¸m
//°£¤F½T©w©M©ñ±ó¡A¨ä¥¦«ö§átag»¡©ú:
//»Ý­n½s¿èÅv­­: 0¤@ª½Åã¥Ü,1½s¿èª¬ºAÅã¥Ü,2¥¿±`ª¬ºAÅã¥Ü
//¤£¥ÎÅv­­:     3¤@ª½Åã¥Ü,4½s¿èª¬ºAÅã¥Ü,5¥¿±`ª¬ºAÅã¥Ü
procedure SetPnlRightBtn(pnl: TPanel; isEdit: Boolean);
var
  i, tmpTop: Integer;
  tmpBtn: TBitBtn;
begin
  tmpTop := 10;
  for i := 0 to pnl.ControlCount - 1 do
  begin
    tmpBtn := TBitBtn(pnl.Controls[i]);

    with tmpBtn do
      case Tag of
        0:
          Visible := g_MInfo^.R_edit;
        1:
          Visible := isEdit and g_MInfo^.R_edit;
        2:
          Visible := (not isEdit) and g_MInfo^.R_edit;
        3:
          Visible := True;
        4:
          Visible := isEdit;
        5:
          Visible := not isEdit;
      else
        Visible := False;
      end;

    if not tmpBtn.Visible then
      Continue;

    tmpBtn.Top := tmpTop;
    tmpTop := tmpTop + tmpBtn.Height + 5;
  end;
end;

//³B²zdbgrideh¦^¨®Áä
procedure DBGridEhSelNext(const grdEh: TDBGridEh; var Key: Word);
begin
  if grdEh.SelectedIndex < grdEh.columns.Count - 1 then
    grdEh.SelectedIndex := grdEh.SelectedIndex + 1
  else
  begin
    grdEh.DataSource.DataSet.Next;

    if grdEh.DataSource.DataSet.Eof then
      if (not grdEh.ReadOnly) and (grdEh.DataSource.DataSet.CanModify) then
        grdEh.DataSource.DataSet.Append;

    grdEh.SelectedIndex := 0;
  end;

  if not grdEh.FieldColumns[grdEh.SelectedField.FieldName].Visible then
    PostMessage(grdEh.Handle, WM_KEYDOWN, Key, 0);
end;

//¨ú¬y¤ô¸¹
//Tb:ªí¦W(¦s©ñ¬y¤ô¸¹ªº¸ê®Æªí)mps080
//Kind:ÃþÃþ
//Result:·s¬y¤ô¸¹
function GetSno(Kind: string; const Bu: string = ''): string;
var
  tmpBu, tmpSQL, Err: string;
  RetData: OleVariant;
begin
  Result := '';

  tmpBu := Bu;
  if Length(tmpBu) = 0 then
    tmpBu := g_UInfo^.Bu;
  tmpSQL := 'declare @sno varchar(20)' + ' exec [dbo].[proc_getsno] ''mps080'',' + Quotedstr(tmpBu) + ',' + Quotedstr(Kind)
    + ',' + Quotedstr(g_UInfo^.UserId) + ', @sno output' + ' select @sno as id';
  if TSvr.QueryOneCR(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, g_UInfo^.DBType, tmpSQL, RetData, Err) then
    if not VarIsNull(RetData) then
      Result := VarToStr(RetData);

  if Length(Result) = 0 then
    ShowSvrMsg('¨ú¬y¤ô¸¹¥¢±Ñ,½Ð­«¸Õ' + #13#10 + Err);
end;

//ÀË¬dÄæ¦ì¥²»Ý¿é¤J,¬O§_­«½Æ
//TableName:¸ê®Æªí
//ErrFName:Result=False®Éªð¦^¿ù»~ªº¨ä¤¤¤@­ÓÄæ¦ì¦W(½Õ¥ÎªÌ¨Ï¥Î¦¹Äæ¦ì³]¸mµJÂI)
//Result=true½Õ¥Î¦¨¥\,¼Æ¾Ú¤£­«½Æ
function CheckPK(ds: TDataSet; TableName: string; var ErrFName: string): Boolean;
var
  tmpFlag: Integer;
  tmpS1, tmpS2, tmpS3, fName, fNameAll: string;
  fValue: Variant;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := False;
  ErrFName := '';

  tmpS1 := 'Select FieldName,Caption From Sys_TableDetail' + ' Where TableName=' + Quotedstr(TableName) + ' And IsPK=1';
  if QueryBySQL(tmpS1, Data) then
  begin
    tmpS1 := '';
    tmpS2 := '';
    tmpS3 := '';
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
      begin
        Result := True;
        Exit;
      end;

      tmpFlag := -1;
      while not tmpCDS.Eof do
      begin
        fName := tmpCDS.Fields[0].AsString;
        fValue := ds.FieldByName(fName).Value;

        if VarIsNull(fValue) or (Trim(VarToStrDef(fValue, '')) = '') then
        begin
          tmpS1 := '';
          ErrFName := fName;
          tmpFlag := 0;
          ShowMsg('½Ð¿é¤J[%s]!', 48, tmpCDS.Fields[1].AsString);
          Break;
        end;

        if tmpFlag = -1 then                //±N§PÂ_­«½Æ
        begin
          if ds.State in [dsInsert] then  //dsInsert·s«Ø
            tmpFlag := 1
          else                            //dsEdit­×§ï
if UpperCase(Widestring(fValue)) <> UpperCase(Widestring(ds.FieldByName(fName).OldValue)) then
            tmpFlag := 1;
        end;

        //Äæ¦ì(­^¤å)
        if fNameAll <> '' then
          fNameAll := fNameAll + ',';
        fNameAll := fNameAll + fName;

        //Äæ¦ì(¤¤¤å)
        if tmpS3 <> '' then
          tmpS3 := tmpS3 + ',';
        if Trim(tmpCDS.Fields[1].AsString) = '' then
          tmpS3 := tmpS3 + fName
        else
          tmpS3 := tmpS3 + tmpCDS.Fields[1].AsString;

        //¿é¤J­È
        if tmpS2 <> '' then
          tmpS2 := tmpS2 + ',';

        if ds.FieldByName(fName).DataType in [ftDateTime] then
        begin
          tmpS1 := tmpS1 + ' And ' + fName + '=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, fValue), '-',
            '/', [rfReplaceAll]));
          tmpS2 := tmpS2 + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, fValue), '-', '/', [rfReplaceAll]));
        end
        else if ds.FieldByName(fName).DataType in [ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD] then
        begin
          tmpS1 := tmpS1 + ' And ' + fName + '=' + VarToStr(fValue);
          tmpS2 := tmpS2 + VarToStr(fValue);
        end
        else
        begin
          tmpS1 := tmpS1 + ' And ' + fName + '=' + Quotedstr(fValue);
          tmpS2 := tmpS2 + Quotedstr(fValue);
        end;

        tmpCDS.Next;
      end;  // end while

      if tmpFlag = -1 then                   //-1²¤¹L,0¥¼¿é¤J­È,1§PÂ_­«½Æ
        Result := True
      else if (tmpFlag = 1) and (tmpS1 <> '') then
      begin
        Data := null;
        tmpS1 := 'Select Count(*) As Cnt From (' + ' Select ' + fNameAll + ' From ' + TableName + ' Where 1=1 ' + tmpS1
          + ' Union All Select ' + tmpS2 + ') As t Group By ' + fNameAll;
        if QueryBySQL(tmpS1, Data) then
        begin
          tmpCDS.Data := Data;
          if tmpCDS.Fields[0].AsInteger > 1 then
          begin
            ErrFName := fName;
            ShowMsg('[%s]¦s¦b­«½Æ!', 48, tmpS3);
          end
          else
          begin
            ErrFName := '';
            Result := True;
          end;
        end;
      end;

    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//string¤º®eÂà´«OleVariant
function StringToOleData(const AText: string): OleVariant;
var
  nSize: Integer;
  pData: Pointer;
begin
  nSize := Length(AText);
  if nSize = 0 then
    Result := null
  else
  begin
    Result := VarArrayCreate([0, nSize - 1], varByte);
    pData := VarArrayLock(Result);
    try
      Move(Pchar(AText)^, pData^, nSize);
    finally
      VarArrayUnlock(Result);
    end;
  end;
end;
//
//function JxRemark(const Remark: string; var dno: string; var ditem :integer): Boolean;
//var
//  ls: Tstringlist;
//begin              //JX-222-2B0672-3-AC365
//  result := false;
//  ls := TStringlist.create;
//  try
//    ls.Delimiter := '-';
//    ls.DelimitedText := Remark;
//    if ls.Count >= 5 then
//    begin
//      if (LeftStr(ls[4], 2) = 'AC') and (Length(ls[4]) = 5) then
//      begin
//        dno:= ls[1]+'-'+ls[2];
//        ditem:=StrToInt(ls[3]);
//        result := true;
//      end;
//    end;
//  finally
//    ls.free;
//  end;
//end;
//
//function JxRemark(const Remark: string; var custno: string): Boolean;
//var
//  ls: Tstringlist;
//begin              //JX-222-2B0672-3-AC365
//  result := false;
//  ls := TStringlist.create;
//  try
//    ls.Delimiter := '-';
//    ls.DelimitedText := Remark;
//    if ls.Count >= 5 then
//    begin
//      if (LeftStr(ls[4], 2) = 'AC') and (Length(ls[4]) = 5) then
//      begin
//        custno := ls[4];
//        result := true;
//      end;
//    end;
//  finally
//    ls.free;
//  end;
//end;

function JxRemark(const Remark: string;var custInfo:TCustInfo): Boolean;
var
  tmpCDS: TClientdataset;
  ls: TStrings;
  dno, sql: string;
//  cust_po_itm: integer;
  data: OleVariant;
begin    //JX-222-332389-1-AC121
  result := false;

  with custInfo do
  begin
    No := '';
    Name := '';
    PartNo := '';
    PartName := '';
    Po := '';
    PoItm := -1;
  end;
  
  if Pos('JX-', Remark) <> 1 then
  begin
    result := false;
    exit;
  end;

  ls := TStringList.create;
  try
    ls.Delimiter := '-';
    ls.DelimitedText := Remark;
    if ls.Count < 5 then
    begin
      result := false;
      exit;
    end;
    dno := ls[1] + '-' + ls[2];
    custInfo.PoItm := StrToIntDef(ls[3], -999);
    custInfo.No := copy(ls[4],1,5);
    if (custInfo.PoItm = -999) or (Length(custInfo.No) <> 5) then
    begin
      result := false;
      exit;
    end;
  finally
    ls.free;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    sql := 'select oea04,oeb11,ta_oeb10,occ02,occ18,oea10 from iteqjx.oeb_file,iteqjx.oea_file,iteqjx.occ_file' +
      ' where oea01=oeb01 and oea04=occ01 and oeb01=%s and oeb03=%d';
    sql := Format(sql, [QuotedStr(dno), custInfo.PoItm]);
    if not QueryBySQL(sql, data, 'ORACLE') then
    begin
      result := false;
      exit;
    end;
    tmpCDS.Data := data;
    custInfo.PartNo := tmpCDS.fieldbyname('oeb11').asstring;
    custInfo.PartName  := tmpCDS.fieldbyname('ta_oeb10').asstring;
    if Pos(tmpCDS.fieldbyname('oea04').asstring,'ACF29')>0 then
      custInfo.Name  := tmpCDS.fieldbyname('occ18').asstring
    else
      custInfo.Name  := tmpCDS.fieldbyname('occ02').asstring;
    custInfo.Po := tmpCDS.fieldbyname('oea10').asstring;
    result := true;
  finally
    tmpCDS.free;
  end;
end;

//
//function JxRemark(const Remark: string; var CustInfo): Boolean;
//var
//  tmpCDS: TClientdataset;
//  ls: TStrings;
//  dno, sql: string;
////  cust_po_itm: integer;
//  data: OleVariant;
//begin    //JX-222-332389-1-AC121
//  result := false;
//  if Pos('JX-', Remark) <> 1 then
//  begin
//    result := false;
//    exit;
//  end;
//
//  ls := TStringList.create;
//  try
//    ls.Delimiter := '-';
//    ls.DelimitedText := Remark;
//    if ls.Count < 5 then
//    begin
//      result := false;
//      exit;
//    end;
//    dno := ls[1] + '-' + ls[2];
//    cust_po_itm := StrToIntDef(ls[3], -999);
//    custno := copy(ls[4],1,5);
//    if (cust_po_itm = -999) or (Length(custno) <> 5) then
//    begin
//      result := false;
//      exit;
//    end;
//  finally
//    ls.free;
//  end;
//
//  tmpCDS := TClientDataSet.Create(nil);
//  try
//    sql := 'select oeb11,ta_oeb10,occ02,oea10 from iteqjx.oeb_file,iteqjx.oea_file,iteqjx.occ_file' +
//      ' where oea01=oeb01 and oea04=occ01 and oeb01=%s and oeb03=%d';
//    sql := Format(sql, [QuotedStr(dno), cust_po_itm]);
//    if not QueryBySQL(sql, data, 'ORACLE') then
//    begin
//      result := false;
//      exit;
//    end;
//    tmpCDS.Data := data;
//    custpno := tmpCDS.fieldbyname('oeb11').asstring;
//    custpname := tmpCDS.fieldbyname('ta_oeb10').asstring;
//    custname := tmpCDS.fieldbyname('occ02').asstring;
//    custpo := tmpCDS.fieldbyname('oea10').asstring;
//    result := true;
//  finally
//    tmpCDS.free;
//  end;
//end;

//¦C¦L
procedure GetPrintObj(SysId: string; ArrPrintData: TArrPrintData; const ProcId: string = '');
var
  i: Integer;
  tmpProcId: string;
  QDllHandle: HWnd;
  QDllFunc: TPrintDllFunc;
begin
  for i := Low(ArrPrintData) to High(ArrPrintData) do
  begin
    if VarIsNull(ArrPrintData[i].data) then
    begin
      ShowMsg('²Ä' + IntToStr(i + 1) + '­Ó¼Æ¾Ú¶°¬°ªÅ,¤£¥i¦C¦L,½ÐÁpµ¸ºÞ²z­û!', 48);
      Exit;
    end;
  end;
  QDllHandle := LoadLibrary('Def\Report.dll');
  try
    if QDllHandle <> 0 then
    begin
      tmpProcId := ProcId;
      if tmpProcId = '' then
        tmpProcId := g_MInfo^.ProcId;
      @QDllFunc := GetProcAddress(QDllHandle, 'ShowPrintForm');
      if @QDllFunc <> nil then
        QDllFunc(Application.Handle, g_UInfo, g_ConnData, ArrPrintData, PChar(SysId), PChar(tmpProcId), g_MInfo^.R_rptDesign)
      else
        ShowMsg('½Õ¥Î¦C¦L¼Ò¶ô¥¢±Ñ,½ÐÁpµ¸ºÞ²z­û!', 48);
    end
    else
      ShowMsg('µLªk¥[¸ü¦C¦L¼Ò¶ô,½ÐÁpµ¸ºÞ²z­û!', 48);
  finally
    FreeLibrary(QDllHandle);
  end;
end;

//¶×¥Xexcel
procedure GetExportXls(CDS: TClientDataSet; TableName: string);
var
  tmpPath: string;
  tmpList: TStrings;
  tmpOleData: OleVariant;
  QDllHandle: HWnd;
  QDllFunc: TExportDllFunc;
begin
  if not CDS.Active then
  begin
    ShowMsg('¼Æ¾Ú¶°¥¼¥´¶},½Ð¬d¸ß¼Æ¾Ú!', 48);
    Exit;
  end;
  QDllHandle := LoadLibrary('Def\Export.dll');
  try
    if QDllHandle <> 0 then
    begin
      tmpPath := g_UInfo^.TempPath + g_MInfo^.ProcId + '.xml';
      tmpList := TStringList.Create;
      try
        CDS.SaveToFile(tmpPath, dfXML);
        tmpList.LoadFromFile(tmpPath);
        tmpOleData := StringToOleData(tmpList.Text);
      finally
        FreeAndNil(tmpList);
        if FileExists(tmpPath) then
          DeleteFile(tmpPath);
      end;

      @QDllFunc := GetProcAddress(QDllHandle, 'ShowExportForm');
      if @QDllFunc <> nil then    //CDS¦³fixedÄæ¦ì®É,ª½±µ¨Ï¥ÎCDS.Data¶Ç­È¼Æ¾Ú¦³¿ù»~,©Ò¥H¼È®É¨Ï¥ÎtmpOleData¹L´ç
        QDllFunc(Application.Handle, g_UInfo, g_ConnData, tmpOleData, CDS.RecNo, PChar(TableName), PChar(g_MInfo^.ProcId),
          PChar(g_MInfo^.ProcName), PChar(CDS.IndexFieldNames), g_ProgressBar)
      else
        ShowMsg('½Õ¥Î¶×¥Xexcel¼Ò¶ô¥¢±Ñ,½ÐÁpµ¸ºÞ²z­û!', 48);
    end
    else
      ShowMsg('µLªk¥[¸ü¶×¥Xexcel¼Ò¶ô,½ÐÁpµ¸ºÞ²z­û!', 48);
  finally
    FreeLibrary(QDllHandle);
  end;
end;

//¬d¸ß
//result=true«hQueryStr¬°¬d¸ß±ø¥ó
function GetQueryString(TableName: string; var QueryStr: string): Boolean;
var
  QDllHandle: HWnd;
  QDllFunc: TQueryDllFunc;
  P: Pchar;
  QResult: Boolean;
begin
  QResult := False;
  QueryStr := '';
  QDllHandle := LoadLibrary('Def\Query.dll');
  try
    if QDllHandle <> 0 then
    begin
      @QDllFunc := GetProcAddress(QDllHandle, 'ShowQueryForm');
      if @QDllFunc <> nil then
      begin
        P := StrAlloc(2048);    //2K
        try
          QResult := QDllFunc(Application.Handle, g_UInfo, g_ConnData, PChar(TableName), PChar(g_MInfo^.ProcId), P);
          if QResult then
            QueryStr := P;
        finally
          StrDispose(P);
        end;
      end
      else
        ShowMsg('½Õ¥Î¬d¸ß¼Ò¶ô¥¢±Ñ,½ÐÁpµ¸ºÞ²z­û!', 48);
    end
    else
      ShowMsg('µLªk¥[¸ü¬d¸ß¼Ò¶ô,½ÐÁpµ¸ºÞ²z­û!', 48);
    Result := QResult;
  finally
    FreeLibrary(QDllHandle);
  end;
end;

//®w¦s¬d¸ß
//Pno:®Æ¸¹ isMPS:±Æµ{½Õ¥Î=1
procedure GetQueryStock(Pno: string; isMPS: Boolean);
var
  fMPS: string;
  QDllHandle: HWnd;
  QDllFunc: TStockDllFunc;
begin
  QDllHandle := LoadLibrary('Stock.dll');
  try
    if QDllHandle <> 0 then
    begin
      @QDllFunc := GetProcAddress(QDllHandle, 'ShowStockForm');
      if @QDllFunc <> nil then
      begin
        if isMPS then
          fMPS := '1'
        else
          fMPS := '0';
        QDllFunc(Application.Handle, g_UInfo, g_MInfo, PChar(Pno), PChar(fMPS));
      end
      else
        ShowMsg('½Õ¥Î®w¦s¬d¸ß¼Ò¶ô¥¢±Ñ,½ÐÁpµ¸ºÞ²z­û!', 48);
    end
    else
      ShowMsg('µLªk¥[¸ü®w¦s¬d¸ß¼Ò¶ô,½ÐÁpµ¸ºÞ²z­û!', 48);
  finally
    FreeLibrary(QDllHandle);
  end;
end;
//Pno:®Æ¸¹ SourceProc:½Õ¥Î§@·~

procedure GetQueryStock(Pno, SourceProc: string);
var
  QDllHandle: HWnd;
  QDllFunc: TStockDllFunc;
begin
  QDllHandle := LoadLibrary('Stock.dll');
  try
    if QDllHandle <> 0 then
    begin
      @QDllFunc := GetProcAddress(QDllHandle, 'ShowStockForm2');
      if @QDllFunc <> nil then
      begin
        QDllFunc(Application.Handle, g_UInfo, g_MInfo, PChar(Pno), PChar(SourceProc));
      end
      else
        ShowMsg('½Õ¥Î®w¦s¬d¸ß¼Ò¶ô¥¢±Ñ,½ÐÁpµ¸ºÞ²z­û!', 48);
    end
    else
      ShowMsg('µLªk¥[¸ü®w¦s¬d¸ß¼Ò¶ô,½ÐÁpµ¸ºÞ²z­û!', 48);
  finally
    FreeLibrary(QDllHandle);
  end;
end;

//³]¸mDBGridEh¦C¼ÐÃD,¼e«×
procedure SetGrdCaption(const grdEh: TDBGridEh; TableName: string);
var
  i: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  tmpSQL := 'Select FieldName,Caption,Width,IsNull(IsPK,0) IsPK' + ' From Sys_Tabledetail Where TableName=' + Quotedstr(TableName);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      for i := 0 to grdEh.Columns.Count - 1 do
      begin
        if tmpCDS.Locate('FieldName', grdEh.Columns[i].FieldName, [loCaseInsensitive]) then
        begin
          grdEh.Columns[i].Title.Caption := tmpCDS.Fields[1].AsString;
          grdEh.Columns[i].Width := tmpCDS.Fields[2].AsInteger;
          if tmpCDS.Fields[3].AsBoolean then
            grdEh.Columns[i].Tag := 1;
        end
        else
        begin
          grdEh.Columns[i].Title.Caption := LowerCase(grdEh.Columns[i].FieldName);
          grdEh.Columns[i].Width := 80;
        end;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  grdEh.Columns.ScaleWidths(96, Screen.PixelsPerInch);
end;

//¦P?³]¸m¦h­ÓDBGridEh¦C¼ÐÃD,¼e«×
procedure SetMoreGrdCaption(xGrdEh: TGrdEh);
var
  i, j: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  tmpSQL := 'Select TableName as tb,FieldName,Caption,Width,IsNull(IsPK,0) IsPK' + ' From Sys_Tabledetail Where 1=1';
  for i := Low(xGrdEh.tb) to High(xGrdEh.tb) do
    tmpSQL := tmpSQL + ' or TableName=' + Quotedstr(xGrdEh.tb[i]);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;

      for i := Low(xGrdEh.grdEh) to High(xGrdEh.grdEh) do
      begin
        for j := 0 to xGrdEh.grdEh[i].Columns.Count - 1 do
        begin
          if tmpCDS.Locate('tb;FieldName', VarArrayOf([xGrdEh.tb[i], xGrdEh.grdEh[i].Columns[j].FieldName]), [loCaseInsensitive])
            then
          begin
            xGrdEh.grdEh[i].Columns[j].Title.Caption := tmpCDS.Fields[2].AsString;
            xGrdEh.grdEh[i].Columns[j].Width := tmpCDS.Fields[3].AsInteger;
            if tmpCDS.Fields[4].AsBoolean then
              xGrdEh.grdEh[i].Columns[j].Tag := 1;
          end
          else
          begin
            xGrdEh.grdEh[i].Columns[j].Title.Caption := LowerCase(xGrdEh.grdEh[i].Columns[j].FieldName);
            xGrdEh.grdEh[i].Columns[j].Width := 80;
          end;
        end;
        xGrdEh.grdEh[i].Columns.ScaleWidths(96, Screen.PixelsPerInch);
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//³]¸m¼ÐÃ±caption
procedure SetLabelCaption(WinCtrl: TWinControl; TableName: string);
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;

  //»¼Âk³]¸mLabel

  procedure SetCaption(Ctrl: TWinControl);
  var
    i, j: Integer;
    tmpFName: string;
  begin
    for i := 0 to Ctrl.ControlCount - 1 do
    begin
      if Ctrl.Controls[i] is TLabel then
      begin
        tmpFName := LowerCase(TLabel(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
        begin
          if TLabel(Ctrl.Controls[i]).Tag = 1 then
            TLabel(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
          else
            TLabel(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString + ':';
          if TLabel(Ctrl.Controls[i]).FocusControl <> nil then
          begin
            TLabel(Ctrl.Controls[i]).FocusControl.Hint := tmpCDS.Fields[1].AsString;
            if tmpCDS.Fields[3].AsBoolean then
              TLabel(Ctrl.Controls[i]).Tag := 1;
          end;
        end
        else if TLabel(Ctrl.Controls[i]).Tag = 1 then
          TLabel(Ctrl.Controls[i]).Caption := tmpFName
        else
          TLabel(Ctrl.Controls[i]).Caption := tmpFName + ':';
      end
      else if Ctrl.Controls[i] is TDBCheckBox then
      begin
        tmpFName := LowerCase(TDBCheckBox(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TDBCheckBox(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TDBCheckBox(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TDBCheckBoxEh then
      begin
        tmpFName := LowerCase(TDBCheckBoxEh(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TDBCheckBoxEh(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TDBCheckBoxEh(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TCheckBox then
      begin
        tmpFName := LowerCase(TCheckBox(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TCheckBox(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TCheckBox(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TButton then
      begin
        tmpFName := LowerCase(TButton(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TButton(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TButton(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TToolButton then
      begin
        tmpFName := LowerCase(TToolButton(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TToolButton(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TToolButton(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TSpeedButton then
      begin
        tmpFName := LowerCase(TSpeedButton(Ctrl.Controls[i]).Name);
        if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
          TSpeedButton(Ctrl.Controls[i]).Caption := tmpCDS.Fields[1].AsString
        else
          TSpeedButton(Ctrl.Controls[i]).Caption := tmpFName;
      end
      else if Ctrl.Controls[i] is TPanel then
        SetCaption(TPanel(Ctrl.Controls[i]))
      else if Ctrl.Controls[i] is TPageControl then
      begin
        for j := 0 to TPageControl(Ctrl.Controls[i]).PageCount - 1 do
        begin
          tmpFName := LowerCase(TTabSheet(TPageControl(Ctrl.Controls[i]).Pages[j]).Name);
          if tmpCDS.Locate('fName', tmpFName, [loCaseInsensitive]) then
            TTabSheet(TPageControl(Ctrl.Controls[i]).Pages[j]).Caption := tmpCDS.Fields[1].AsString
          else
            TTabSheet(TPageControl(Ctrl.Controls[i]).Pages[j]).Caption := tmpFName;
        end;

        SetCaption(TPageControl(Ctrl.Controls[i]));
      end
      else if Ctrl.Controls[i] is TTabSheet then
        SetCaption(TTabSheet(Ctrl.Controls[i]))
      else if Ctrl.Controls[i] is TGroupBox then
      begin
        //if tmpCDS.Locate('fName',TGroupBox(Ctrl.Controls[i]).Name,[loCaseInsensitive]) then
        //   TGroupBox(Ctrl.Controls[i]).Caption:=tmpCDS.Fields[1].AsString; xpmanÂ²ÅéÅã¥Ü¦³°ÝÃD
        SetCaption(TGroupBox(Ctrl.Controls[i]));
      end
      else if Ctrl.Controls[i] is TToolBar then
        SetCaption(TToolBar(Ctrl.Controls[i]));
    end;
  end;

begin
  tmpSQL := 'Select Lower(FieldName) fName,Caption,Width,IsNull(IsPK,0) IsPK' + ' From Sys_Tabledetail Where TableName='
    + Quotedstr(TableName) + ' Union ALL' + ' Select Lower(FieldName) fName,Caption,Width,IsNull(IsPK,0) IsPK' +
    ' From Sys_Tabledetail Where TableName=''sys''';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if WinCtrl is TForm then
        if tmpCDS.Locate('fName', TForm(WinCtrl).Name, [loCaseInsensitive]) then
          TForm(WinCtrl).Caption := tmpCDS.Fields[1].AsString;
      SetCaption(WinCtrl);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure SetStrings(Dest: TStrings; const SrcFieldName, SrcTableName: string);
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  tmpSQL := 'Select Distinct ' + SrcFieldName + ' From ' + SrcTableName + ' Where Bu=' + Quotedstr(g_UInfo^.Bu);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    Dest.BeginUpdate;
    try
      Dest.Clear;
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        Dest.Add(tmpCDS.Fields[0].AsString);
        tmpCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS);
      Dest.EndUpdate;
    end;
  end;
end;

//StrIndex:±Æ§ÇÄæ¦ì
//StrIndexDesc:­Ë§ÇÄæ¦ì
procedure SetAscDesc(CDS: TClientDataSet; Column: TColumnEh; var StrIndex, StrIndexDesc: string);
var
  pos1: Integer;
  fName, fCaption: WideString;
begin
  if (not CDS.Active) or (CDS.RecordCount < 2) then
    Exit;

  fName := Column.FieldName;
  if SameText(fName, 'select') then
    Exit;

  fCaption := Column.Title.Caption;
  pos1 := Pos(g_Asc, fCaption);
  if pos1 > 0 then   //Asc->Desc
  begin
    Delete(fCaption, pos1, 2);
    fCaption := fCaption + g_Desc;
    if Length(StrIndexDesc) > 0 then
      StrIndexDesc := StrIndexDesc + ';' + fName
    else
      StrIndexDesc := fName;
  end
  else
  begin
    pos1 := Pos(g_Desc, fCaption);
    if pos1 > 0 then              //Desc->no
    begin
      Delete(fCaption, pos1, 2);
      if Length(StrIndexDesc) > 0 then
      begin
        StrIndexDesc := ';' + StrIndexDesc + ';';
        StrIndexDesc := StringReplace(StrIndexDesc, ';' + fName + ';', ';', []);
        if LeftStr(StrIndexDesc, 1) = ';' then
          Delete(StrIndexDesc, 1, 1);
        if RightStr(StrIndexDesc, 1) = ';' then
          Delete(StrIndexDesc, Length(StrIndexDesc), 1);
      end;

      if Length(StrIndex) > 0 then
      begin
        StrIndex := ';' + StrIndex + ';';
        StrIndex := StringReplace(StrIndex, ';' + fName + ';', ';', []);
        if LeftStr(StrIndex, 1) = ';' then
          Delete(StrIndex, 1, 1);
        if RightStr(StrIndex, 1) = ';' then
          Delete(StrIndex, Length(StrIndex), 1);
      end;
    end
    else                    //no->Asc
    begin
      fCaption := fCaption + g_Asc;
      if Length(StrIndex) > 0 then
        StrIndex := StrIndex + ';' + fName
      else
        StrIndex := fName;
    end;
  end;

  Column.Title.Caption := fCaption;

  if CDS.IndexName <> '' then
  begin
    CDS.DeleteIndex(CDS.IndexName);
    CDS.IndexName := '';
  end;

  if StrIndex <> '' then
  begin
    if StrIndexDesc <> '' then
      CDS.AddIndex('myIndex', StrIndex, [ixCaseInsensitive], StrIndexDesc)
    else
      CDS.AddIndex('myIndex', StrIndex, [ixCaseInsensitive]);
    CDS.IndexName := 'myIndex';
  end;

  CDS.First;
end;

//²M°£eh¼ÐÃD±Æ§Ç²Å¸¹
procedure RefreshGrdCaption(CDS: TClientDataSet; Grd: TDBGridEh; var StrIndex, StrIndexDesc: string);
var
  i, pos1, pos2: Integer;
  fCaption: WideString;
begin
  StrIndex := '';
  StrIndexDesc := '';
  if CDS.IndexName <> '' then
  begin
    CDS.DeleteIndex(CDS.IndexName);
    CDS.IndexName := '';
  end;

  for i := 0 to Grd.Columns.Count - 1 do
  begin
    fCaption := Grd.Columns[i].Title.Caption;

    pos1 := Pos(g_Asc, fCaption);
    if pos1 > 0 then
      Delete(fCaption, pos1, 2);

    pos2 := Pos(g_Desc, fCaption);
    if pos2 > 0 then
      Delete(fCaption, pos2, 2);

    if (pos1 > 0) or (pos2 > 0) then
      Grd.Columns[i].Title.Caption := fCaption;
  end;
end;

//®æ¦¡¤ÆSQL»y¥y°Ñ¼Æ­È
function VarToSQL(Value: Variant): string;
begin
  if VarIsNull(Value) or VarIsEmpty(Value) then
    Result := 'null'
  else
    case VarType(Value) of
      varDate:
        Result := Quotedstr(StringReplace(FormatDateTime(g_cLongTimeSP, VarToDatetime(Value)), '-', '/', [rfReplaceAll]));
      varString, varOleStr:
        Result := Quotedstr(VarToStr(Value));
      varBoolean:
        begin
          if Value then
            Result := '1'
          else
            Result := '0';
        end;
      varSmallint, varInteger, varDouble, varShortInt, varInt64, varLongWord, varCurrency:
        Result := VarToStr(Value);
    else
      Result := Quotedstr(VarToStr(Value));
    end;
end;

//DeleaÂà´«¦¨SQL»y¥yª½±µ§ó·s
function PostBySQLFromDelta(DataSet: TClientDataSet; TableName, PrimaryKey: string; const DBType: string = ''): Boolean;
var
  ArrKeyField: array of string;
  i: integer;
  str1, str2, tmpSQL: string;
  tmpCDS: TClientDataSet;
  tmpList, tmpUpdList: TStrings;
begin
  Result := False;

  if (Trim(TableName) = '') or (Trim(PrimaryKey) = '') then
  begin
    ShowMsg('Invalid TableName or PrimaryKey!', 48);
    Exit;
  end;

  if DataSet.State in [dsInsert, dsEdit] then
    DataSet.Post;

  if DataSet.ChangeCount = 0 then
  begin
    Result := True;
    Exit;
  end;

  tmpList := TStringList.Create;
  tmpUpdList := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpList.DelimitedText := PrimaryKey;
    SetLength(ArrKeyField, tmpList.Count);
    for i := Low(ArrKeyField) to High(ArrKeyField) do
      ArrKeyField[i] := tmpList.Strings[i];

    tmpCDS.Data := DataSet.Delta;
    with tmpCDS do
      while not Eof do
      begin
        str1 := '';
        str2 := '';
        case UpdateStatus of
          usUnmodified:
            begin
              tmpList.Clear;
              for i := Low(ArrKeyField) to High(ArrKeyField) do
                tmpList.Add(VarToSQL(FieldByName(ArrKeyField[i]).Value));
            end;

          usModified:
            begin
              for i := 0 to FieldCount - 1 do
                if not VarIsEmpty(Fields[i].NewValue) then
                  str1 := str1 + ',' + Fields[i].FieldName + '=' + VarToSQL(Fields[i].Value);
              if str1 <> '' then
              begin
                for i := Low(ArrKeyField) to High(ArrKeyField) do
                  str2 := str2 + ' and ' + ArrKeyField[i] + '=' + tmpList.Strings[i];
                System.Delete(str1, 1, 1);
                System.Delete(str2, 1, 5);
                tmpUpdList.Add('update ' + TableName + ' set ' + str1 + ' where ' + str2);
              end;
            end;

          usInserted:
            begin
              for i := 0 to FieldCount - 1 do
                if not VarIsEmpty(Fields[i].NewValue) then
                begin
                  str1 := str1 + ',' + Fields[i].FieldName;
                  str2 := str2 + ',' + VarToSQL(Fields[i].Value);
                end;
              if str1 <> '' then
              begin
                System.Delete(str1, 1, 1);
                System.Delete(str2, 1, 1);
                tmpUpdList.Add('insert into ' + TableName + '(' + str1 + ') values (' + str2 + ')');
              end;
            end;

          usDeleted:
            begin
              for i := Low(ArrKeyField) to High(ArrKeyField) do
                str1 := str1 + ' and ' + ArrKeyField[i] + '=' + VarToSQL(FieldByName(ArrKeyField[i]).Value);
              System.Delete(str1, 1, 5);
              tmpUpdList.Add('delete ' + TableName + ' where ' + str1);
            end;

        end;
        Next;
      end;

    if tmpUpdList.Count > 0 then
    begin
      //40±ø§ó·s¤@¦¸
      if tmpUpdList.Count > 50 then
      begin
        tmpSQL := '';
        for i := 0 to tmpUpdList.Count - 1 do
        begin
          tmpSQL := tmpSQL + ' ' + tmpUpdList.Strings[i];
          if (i mod 40 = 0) or (i = tmpUpdList.Count - 1) then
          begin
            Result := PostBySQL(tmpSQL);
            if not Result then
              Break;
            tmpSQL := '';
          end;
        end;
      end
      else
        Result := PostBySQL(tmpUpdList.Text);

      if Result then
        DataSet.MergeChangeLog
      else
        DataSet.CancelUpdates;
    end;
  finally
    ArrKeyField := nil;
    FreeAndNil(tmpList);
    FreeAndNil(tmpUpdList);
    FreeAndNil(tmpCDS);
  end;
end;

//½Õ¥ÎCMD§R°£Path¥Ø¿ý¤U,ExtÃþ«¬ªº©Ò¦³¤å¥ó
procedure CMDDeleteFile(Path, Ext: string);
var
  src: string;
begin
  if (Length(Path) = 0) or (Length(Ext) = 0) then
    Exit;

  src := Path;
  if src[Length(src)] <> '\' then
    src := src + '\';
  src := src + '*.' + Ext;
  ShellExecute(0, 'open', 'cmd.exe', PChar('/c del ' + src + ' /f /q'), nil, SW_HIDE);
end;

procedure InitCDS(DataSet: TClientDataSet; Xml: string);
var
  tmpList: TStrings;
  tmpMS: TMemoryStream;
begin
  tmpMS := TMemoryStream.Create;
  tmpList := TStringList.Create;
  try
    tmpList.Add(Xml);
    tmpList.SaveToStream(tmpMS);
    tmpMS.Position := 0;
    DataSet.LoadFromStream(tmpMS);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpMS);
  end;
end;

//¸Ñ¨M°ÅÖßªO¶Ã½X
procedure SetClipboardText(AStr: string);
var    // SetBuffer(CF_TEXT, PChar(Value)^, Length(Value) + 1);
  Data: THandle;
  DataPtr: Pointer;
  Size: Integer;
  WStr: PWideChar;
begin
  Size := Length(AStr) * 4;
  WStr := AllocMem(Size);
  try
    // convert to Unicode
    StringToWideChar(AStr, WStr, Size);
    OpenClipboard(0);
    EmptyClipboard;
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, Size);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(WStr^, DataPtr^, Size);
        SetClipboardData(CF_UNICODETEXT, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
    FreeMem(WStr);
  end;
end;

//´À´«²Å¸¹
function myStringReplace(Source: string): string;
var
  s: string;
begin
  s := StringReplace(Source, ':', '', [rfReplaceAll]);
  s := StringReplace(s, g_Asc, '', [rfReplaceAll]);
  s := StringReplace(s, g_Desc, '', [rfReplaceAll]);
  Result := s;
end;

//µo°e®ø®§TCopyDatastruct
procedure CopyDataSendMsg(H: HWND; Msg: string);
var
  ds: TCopyDatastruct;
begin
  ds.cbData := Length(Msg) + 1;
  GetMem(ds.lpData, ds.cbData);
  StrCopy(ds.lpData, PChar(Msg));
  SendMessage(H, WM_COPYDATA, 0, Cardinal(@ds));
  FreeMem(ds.lpData);
end;

//­pºâ³æ­«
//Saleno:Âê³f³æ½X
//Saleitem:Âê³f³æ¶µ¦¸
//Flag=0:¥u­pºâ¤p®Æ³æ­«,¤j®Æªð¦^-1 Flag=1:¤£°Ï¤À¤j¤p®Æ,³£­pºâ
function GetKG(Saleno: string; Saleitem: Integer; Flag: Integer): Double;
var
  tmpSQL, Err: string;
  RetData: OleVariant;
begin
  Result := 0;

  tmpSQL := 'declare @kg float' + ' exec [dbo].[proc_GetKG] ' + Quotedstr(g_UInfo^.Bu) + ',' + Quotedstr(Saleno) + ',' +
    IntToStr(Saleitem) + ',' + IntToStr(Flag) + ', @kg output' + ' select @kg as id';
  if not TSvr.QueryOneCR(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, g_UInfo^.DBType, tmpSQL, RetData, Err)
    then
    ShowSvrMsg('proc_GetKG Error:' + #13#10 + Err)
  else if not VarIsNull(RetData) then
    Result := StrToFloatDef(VarToStr(RetData), 0);
end;

//­pºâ³æ­«
//Orderno:­q³æ³æ½X
//Orderitem:­q³æ¶µ¦¸
//Flag=0:¥u­pºâ¤p®Æ³æ­«,¤j®Æªð¦^-1 Flag=1:¤£°Ï¤À¤j¤p®Æ,³£­pºâ
function GetKG2(Orderno: string; Orderitem: Integer; Flag: Integer): Double;
var
  tmpSQL, Err: string;
  RetData: OleVariant;
begin
  Result := 0;

  tmpSQL := 'declare @kg float' + ' exec [dbo].[proc_GetKG2] ' + Quotedstr(g_UInfo^.Bu) + ',' + Quotedstr(Orderno) + ','
    + IntToStr(Orderitem) + ',' + IntToStr(Flag) + ', @kg output' + ' select @kg as id';
  if not TSvr.QueryOneCR(g_UInfo^.ClientID, g_MInfo^.ProcId, g_UInfo^.UserId, g_UInfo^.DBType, tmpSQL, RetData, Err)
    then
    ShowSvrMsg('proc_GetKG2 Error:' + #13#10 + Err)
  else if not VarIsNull(RetData) then
    Result := StrToFloatDef(VarToStr(RetData), 0);
end;

//¶×¤J¸ê®Ædli050,dli060,dli150,dli340
//¾A¦X¥DÁä¬Obu+id¸ê®Æªí
//
procedure XlsImport(const TableName: string; DataSet: TClientDataSet; const grdEh: TDBGridEh; bu: string = '');
var
  isFind: Boolean;
  i, j, sno: Integer;
  tmpStr: string;
  tmpList: TStrings;
  tmpCDS: TClientDataSet;
  ExcelApp: Variant;
  OpenDialog: TOpenDialog;
  ddate: TDateTime;
begin
  OpenDialog := TOpenDialog.Create(nil);
  OpenDialog.Filter := CheckLang('ExcelÀÉ®×(*.xlsx)|*.xlsx|ExcelÀÉ®×(*.xls)|*.xls');
  if not OpenDialog.Execute then
  begin
    FreeAndNil(OpenDialog);
    Exit;
  end;
  ddate := Now;
  with grdEh do
    for i := 0 to Columns.Count - 1 do
      DataSet.FieldByName(Columns[i].FieldName).DisplayLabel := Columns[i].Title.Caption;

  tmpList := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno := ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i := 1 to sno do
    begin
      isFind := False;
      tmpStr := Trim(ExcelApp.Cells[1, i].Value);

      with grdEh do
        for j := 0 to Columns.Count - 1 do
          if (Columns[j].Title.Caption = tmpStr) and (Columns[j].Tag < 99) then
            Columns[j].Tag := Columns[j].Tag + 100;

      if tmpStr <> '' then
        for j := 0 to DataSet.FieldCount - 1 do
          if DataSet.Fields[j].DisplayLabel = tmpStr then
          begin
            tmpList.Add(IntToStr(j));
            isFind := True;
            Break;
          end;

      if not isFind then
        tmpList.Add('-1');
    end;

    with grdEh do
      for j := 0 to Columns.Count - 1 do
      begin
        if Columns[j].Tag < 99 then
        begin
          ShowMsg('ExcelÀÉ®×¯Ê¤ÖÄæ¦ì[%s]', 48, Columns[j].Title.Caption);
          Exit;
        end;
        Columns[j].Tag := Columns[j].Tag - 100;
      end;

    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible := True;
    tmpCDS.Data := DataSet.Data;
    tmpCDS.EmptyDataSet;
    i := 2;
    while True do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;
      Application.ProcessMessages;
      
      //¥þ¬°ªÅ­È,°h¥X
      tmpStr := '';
      for j := 1 to sno do
        tmpStr := tmpStr + Trim(VarToStr(ExcelApp.Cells[i, j].Value));
      if Length(tmpStr) = 0 then
        Break;

      tmpCDS.Append;
      for j := 0 to tmpList.Count - 1 do
        if tmpList.Strings[j] <> '-1' then
          tmpCDS.Fields[StrToInt(tmpList.Strings[j])].Value := ExcelApp.Cells[i, j + 1].Value;
      if tmpCDS.FindField('Bu') <> nil then
      begin
        if bu <> '' then
          tmpCDS.FieldByName('Bu').AsString := bu
        else
          tmpCDS.FieldByName('Bu').AsString := g_UInfo^.bu;
      end;
      if tmpCDS.FindField('Iuser') <> nil then
        tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
      if tmpCDS.FindField('Idate') <> nil then
        tmpCDS.FieldByName('Idate').AsDateTime := ddate;
      if tmpCDS.FindField('GUID') <> nil then
        tmpCDS.FieldByName('GUID').AsString := guid;
      tmpCDS.Post;
      Inc(i);
    end;

    if CDSPost(tmpCDS, TableName) then
    begin
      DataSet.EmptyDataSet;
      ShowMsg('¶×¤J§¹²¦!', 64);
      if MB_OK = ShowMsg('¬O§_§R°£ÂÂ¼Æ¾Ú?', 35) then
      begin
        tmpStr := 'Delete From ' + TableName + ' Where Bu=' + Quotedstr(g_UInfo^.bu) + ' and idate<' + QuotedStr(FormatDateTime
          ('yyyy-MM-d hh:mm:ss', ddate));
        if not PostBySQL(tmpStr) then
          ShowMsg('§R°£ÂÂ¼Æ¾Ú¥¢±Ñ!', 64);
      end;
    end;
  finally
    g_ProgressBar.Visible := False;
    FreeAndNil(OpenDialog);
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;

{
procedure XlsImport(const TableName: string; DataSet: TClientDataSet; const grdEh: TDBGridEh);
var
  isFind: Boolean;
  i, j, sno, maxid: Integer;
  tmpStr: string;
  tmpList: TStrings;
  tmpCDS: TClientDataSet;
  ExcelApp: Variant;
  OpenDialog: TOpenDialog;
  Data: OleVariant;
begin
  OpenDialog := TOpenDialog.Create(nil);
  OpenDialog.Filter := CheckLang('ExcelÀÉ®×(*.xlsx)|*.xlsx|ExcelÀÉ®×(*.xls)|*.xls');
  if not OpenDialog.Execute then
  begin
    FreeAndNil(OpenDialog);
    Exit;
  end;

  with grdEh do
    for i := 0 to Columns.Count - 1 do
      DataSet.FieldByName(Columns[i].FieldName).DisplayLabel := Columns[i].Title.Caption;

  tmpList := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno := ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i := 1 to sno do
    begin
      isFind := False;
      tmpStr := Trim(ExcelApp.Cells[1, i].Value);

      with grdEh do
        for j := 0 to Columns.Count - 1 do
          if (Columns[j].Title.Caption = tmpStr) and (Columns[j].Tag < 99) then
            Columns[j].Tag := Columns[j].Tag + 100;

      if tmpStr <> '' then
        for j := 0 to DataSet.FieldCount - 1 do
          if DataSet.Fields[j].DisplayLabel = tmpStr then
          begin
            tmpList.Add(IntToStr(j));
            isFind := True;
            Break;
          end;

      if not isFind then
        tmpList.Add('-1');
    end;

    with grdEh do
      for j := 0 to Columns.Count - 1 do
      begin
        if Columns[j].Tag < 99 then
        begin
          ShowMsg('ExcelÀÉ®×¯Ê¤ÖÄæ¦ì[%s]', 48, Columns[j].Title.Caption);
          Exit;
        end;
        Columns[j].Tag := Columns[j].Tag - 100;
      end;

    tmpStr := 'Select IsNull(Max(Id),0)+1 as Id From ' + TableName + ' Where Bu=' + Quotedstr(g_UInfo^.Bu);
    if not QueryOneCR(tmpStr, Data) then
      Exit;
    maxid := StrToInt(VarToStr(Data));

    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible := True;
    tmpCDS.Data := DataSet.Data;
    tmpCDS.EmptyDataSet;
    i := 2;
    while True do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;
      Application.ProcessMessages;
      
      //¥þ¬°ªÅ­È,°h¥X
      tmpStr := '';
      for j := 1 to sno do
        tmpStr := tmpStr + Trim(VarToStr(ExcelApp.Cells[i, j].Value));
      if Length(tmpStr) = 0 then
        Break;

      tmpCDS.Append;
      for j := 0 to tmpList.Count - 1 do
        if tmpList.Strings[j] <> '-1' then
          tmpCDS.Fields[StrToInt(tmpList.Strings[j])].Value := ExcelApp.Cells[i, j + 1].Value;
      tmpCDS.FieldByName('Bu').AsString := g_UInfo^.Bu;
      if maxid <> -1 then
          tmpCDS.FieldByName('Id').AsInteger := maxid + tmpCDS.RecordCount;
      tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
      tmpCDS.FieldByName('Idate').AsDateTime := Now;
      tmpCDS.Post;
      Inc(i);
    end;

    if CDSPost(tmpCDS, TableName) then
    begin
      DataSet.EmptyDataSet;

      maxid := maxid - 1;
      if maxid = 0 then
      begin
        ShowMsg('¶×¤J§¹²¦!', 64);
        Exit;
      end;

      tmpStr := 'Delete From ' + TableName + ' Where Bu=' + Quotedstr(g_UInfo^.Bu) + ' And Id<=' + IntToStr(maxid) + ' Update ' + TableName + ' Set Id=Id-' + IntToStr(maxid) + ' Where Bu=' + Quotedstr(g_UInfo^.Bu);
      if PostBySQL(tmpStr) then
        ShowMsg('¶×¤J§¹²¦!', 64)
      else
        ShowMsg('¶×¤J§¹²¦,¦ý§R°£ÂÂ¼Æ¾Ú¥¢±Ñ,½Ð­«¸Õ!', 48);
    end;
  finally
    g_ProgressBar.Visible := False;
    FreeAndNil(OpenDialog);
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;
}

//YYYYMM¨ú¦~¤ë5A(2½X)
function GetYM: string;
var
  y, m: string;
begin
  y := FormatDateTime(g_cShortDateYYMMDD, Date);
  m := Copy(y, 3, 2);
  if m = '10' then
    m := 'A'
  else if m = '11' then
    m := 'B'
  else if m = '12' then
    m := 'C'
  else
    m := Copy(m, 2, 1);

  y := Copy(y, 2, 1);
  Result := y + m;
end;

//¨ú·s¬y¤ô¸¹id:=xxx-ym no=¤W¤@­Ó½s¸¹
function GetNewNo(id, no: string): string;
var
  len, num: Integer;
begin
  len := Length(no);
  if len < 4 then
    Result := id + '0001'
  else
  begin
    num := 0;
    try
      num := StrToInt(Copy(no, len - 3, 4));
    except
    end;
    Result := id + Copy(IntToStr(10001 + num), 2, 4);
  end;
end;

//¨ú¾P³f³æ³æ§O:str1­q³æ§O->str2Âê³f³æ§O
//vflag:Àq»{0ªF²ð,¼s¦{ 1:M/L 2:¾T°òªO
function GetSaleNo_Id(Orderno: string; vflag: Integer): string;
const
  strdg1 = '222,227,22G,221,223,225,220,229,239,S11,SA1,SA4,S14,SB4,P11,P1L,P18,P2Z,P2Y,P1Q,P2N,237';
const
  strdg2 = '232,232,23G,235,602,600,233,233,233,S31,S31,S34,S34,S34,P31,P3L,P38,PAZ,PAY,P3Q,PAZ,602';
const
  strgz1 = '222,227,220,221,223,P1Z,P1T,P1Y,S1C,S1D,SAD,S3D,239,237';
const
  strgz2 = '232,232,233,235,602,P3Z,P3T,P3Y,S3C,S3D,S3D,SBD,235,602';
const
  strhjA = '222,227,22X,220,239,221,P1X,P1T';
const
  strhjB = '232,232,23X,233,233,235,P3X,P3T';
const
  strhjX = '222,227,22X,220,239,221,P1X,P1T';
const
  strhjY = '23M,23M,23X,23N,23N,235,P3X,P3T';
var
  pos1: Integer;
begin
  Result := '';
  if vflag = 0 then
  begin
    if SameText(g_UInfo^.Bu, 'ITEQGZ') then
    begin
      pos1 := Pos(UpperCase(LeftStr(Orderno, 3)), strgz1);
      if pos1 > 0 then
        Result := Copy(strgz2, pos1, 3)
    end
    else if SameText(g_UInfo^.Bu, 'ITEQDG') then
    begin
      pos1 := Pos(UpperCase(LeftStr(Orderno, 3)), strdg1);
      if pos1 > 0 then
        Result := Copy(strdg2, pos1, 3);
    end;
  end
  else if vflag = 1 then
  begin
    if SameText(g_UInfo^.Bu, 'ITEQHJ') then
    begin
      pos1 := Pos(UpperCase(LeftStr(Orderno, 3)), strhjA);
      if pos1 > 0 then
        Result := Copy(strhjB, pos1, 3);
    end;
  end
  else if vflag = 2 then
  begin
    if SameText(g_UInfo^.Bu, 'ITEQHJ') then
    begin
      pos1 := Pos(UpperCase(LeftStr(Orderno, 3)), strhjX);
      if pos1 > 0 then
        Result := Copy(strhjY, pos1, 3);
    end;
  end;
end;

//«È¤áPO¥i¯à¦boao_file:oao06Äæ¦ì:¶W¼Ý¶°¹Î¡B¤è¥¿¶°¹Î
function GetC_Orderno(custno, oea10, oao06: string): string;
const
  strCY = 'AC405/AC311/AC310/AC075/AC950';
  strFZ = 'AC114/AC365/AC388/AC434/ACD39/ACF29';
  strCD = 'AC121/AC526/ACA97/AC820/AC305/ACD57/ACG02';
var
  pos1, pos2: Integer;
  tmpStr: string;
  tmpSQL: string;
  RetData: OleVariant;
  custInfo:TCustInfo;
begin
  tmpStr := '';
  if Pos(custno, strCY) > 0 then
  begin
    if (Pos('RD0086-', UpperCase(oao06)) > 0) or (Pos('50249-', oao06) > 0) then
    begin
      tmpStr := oao06;
      pos1 := Pos(';', tmpStr);
      pos2 := Pos('¡F', tmpStr);
      if (pos1 = 0) or ((pos1 > pos2) and (pos2 > 0)) then
        pos1 := pos2;
      if pos1 > 0 then
        tmpStr := Copy(tmpStr, 1, pos1 - 1);

      //50249-xxxx-yyyy®æ¦¡¥u¨ú¤¤¶¡³¡¤Àxxxx
      if Pos('50249-', tmpStr) > 0 then
      begin
        tmpStr := StringReplace(tmpStr, '50249-', '', []);
        pos1 := Pos('-', tmpStr);
        if pos1 > 0 then
          tmpStr := Copy(tmpStr, 1, pos1 - 1);
      end;
    end;
  end
  else if Pos(LeftStr(oao06, 5), strFZ) > 0 then
  begin
    tmpSQL := 'declare @po varchar(50)' + ' exec [dbo].[proc_GetFZPO] ' + Quotedstr(g_UInfo^.Bu) + ',' + Quotedstr(oao06)
      + ',@po output' + ' select @po as po';
    if QueryOneCR(tmpSQL, RetData) then
      if not VarIsNull(RetData) then
        tmpStr := VarToStr(RetData);
  end
  else if Pos(custno, strFZ) > 0 then
  begin
    if (SameText(custno, 'ACD39') and (Copy(oao06, 1, 1) = '4')) or (Copy(oao06, 1, 2) = 'PO') then
    begin
      tmpStr := oao06;
      pos1 := Pos(',', tmpStr);
      if pos1 > 0 then
        tmpStr := Copy(tmpStr, 1, pos1 - 1);
    end;
  end;
//  else if Pos(custno, strCD) > 0 then
//  begin
//    JxRemark(oao06, custInfo);
//  end;

  if Length(custInfo.No) = 0 then
    tmpStr := oea10
  else
    tmpStr :=custInfo.Po;

  Result := tmpStr;
end;

//§å¸¹Âà´«¦¨¤é´Á
//lot¬°4½X¦p5A18ªí¥Ü2015-10-18, basedate¨ú¦~¥÷
function GetLotDate(Lot: string; BaseDate: TDateTime): TDateTime;
var
  aYear, aMonth, aDay: Word;
begin
  try
    DecodeDate(BaseDate, aYear, aMonth, aDay);
    aYear := StrToInt(LeftStr(IntToStr(aYear), 3) + Lot[1]);
    if aYear >= YearOf(BaseDate) + 5 then
      aYear := aYear - 10;
    if Lot[2] = 'A' then
      aMonth := 10
    else if Lot[2] = 'B' then
      aMonth := 11
    else if Lot[2] = 'C' then
      aMonth := 12
    else
      aMonth := StrToInt(Lot[2]);
    aDay := StrToInt(RightStr(Lot, 2));
    Result := EncodeDate(aYear, aMonth, aDay);
  except
    ShowMsg(Lot + '§å¸¹µLªkÂà´«¦¨¤é´Á', 48);
    Result := EncodeDate(1955, 1, 1);
  end;
end;



//­Z¦¨§å¸¹Âà´«¦¨¤é´Á
//lot¬°6½Xyymmdd
function GetLotDateHJ(Lot: string; BaseDate: TDateTime): TDateTime;
var
  aYear, aMonth, aDay: Word;
begin
  try
    DecodeDate(BaseDate, aYear, aMonth, aDay);
    aYear := StrToInt(LeftStr(IntToStr(aYear), 2) + LeftStr(Lot, 2));
    aMonth := StrToInt(Copy(Lot, 3, 2));
    aDay := StrToInt(RightStr(Lot, 2));
    Result := EncodeDate(aYear, aMonth, aDay);
  except
    ShowMsg(Lot + '§å¸¹µLªkÂà´«¦¨¤é´Á', 48);
    Result := EncodeDate(1955, 1, 1);
  end;
end;

//¨ú§å¸¹¥Í²£¤é´Á¡GYYYYMMDD
function GetPrdDate1(xLot: string): string;
var
  tmpDate: TDateTime;
begin
  Result := '';

  tmpDate := GetLotDate(Copy(xLot, 2, 4), Date);
  if tmpDate > EncodeDate(2014, 1, 1) then
    Result := FormatDateTime('YYYYMMDD', tmpDate);
end;

//¨ú§å¸¹¥Í²£¤é´Á¡GYYYY-MM-DD
function GetPrdDate2(xLot: string): string;
var
  tmpDate: TDateTime;
begin
  Result := '';

  tmpDate := GetLotDate(Copy(xLot, 2, 4), Date);
  if tmpDate > EncodeDate(2014, 1, 1) then
    Result := FormatDateTime('YYYY-MM-DD', tmpDate);
end;

//¨ú§å¸¹¥Í²£¤é´Á¡GYYYY/MM/DD
function GetPrdDate3(xLot: string): string;
var
  tmpDate: TDateTime;
begin
  Result := '';

  tmpDate := GetLotDate(Copy(xLot, 2, 4), Date);
  if tmpDate > EncodeDate(2014, 1, 1) then
    Result := FormatDateTime('YYYY/MM/DD', tmpDate);
end;

//¨ú§å¸¹¦³®Ä¤é´Á¡GYYYYMMDD
function GetLstDate1(xIsPP: Boolean; xPrdDate1: string): string;
var
  y, m, d: Word;
  tmpDate: TDateTime;
begin
  Result := '';

  if Length(xPrdDate1) = 8 then
  begin
    y := StrToInt(LeftStr(xPrdDate1, 4));
    m := StrToInt(Copy(xPrdDate1, 5, 2));
    d := StrToInt(RightStr(xPrdDate1, 2));
    tmpDate := EncodeDate(y, m, d);
    if xIsPP then
      tmpDate := IncMonth(tmpDate, 3) - 1
    else
      tmpDate := IncYear(tmpDate, 2) - 1;

    Result := FormatDateTime('YYYYMMDD', tmpDate);
  end
end;

//¥Í²£¤é´Á´«¦¨¦³®Ä¤é´Á
//¥Í²£¤é´Á;®Æ¸¹²Ä¤@½X
function LstDate(BaseDate: TDateTime; pno1: string): TDateTime;
begin
  if Pos('pno1', 'ETH') = 0 then
    result := IncMonth(BaseDate, 3) - 1
  else
    result := IncYear(BaseDate, 2) - 1;
end;




//¨ú§å¸¹¥Í²£¤é´Á(¦³®Ä¤é´Á)¡GYYYY-MM-DD
function GetPrd_LstDate(xDate: string): string;
begin
  Result := '';

  if Length(xDate) = 8 then
    Result := LeftStr(xDate, 4) + '-' + Copy(xDate, 5, 2) + '-' + RightStr(xDate, 2);
end;

//ÀË¬d¤é´Á®æ¦¡
function ConvertDate(Value: string; var D: TDateTime): Boolean;
var
  pos1: Integer;
  year1, month1, day1: Word;
  sp, str: string;
begin
  D := EncodeDate(1912, 1, 1);
  Result := False;

  sp := '/';
  str := Value;
  pos1 := Pos(sp, str);
  if pos1 = 0 then
  begin
    sp := '-';
    pos1 := Pos(sp, str);
  end;

  if pos1 = 0 then
    Exit;

  year1 := StrToIntDef(Copy(str, 1, pos1 - 1), -1);
  if (year1 > 2079) or (year1 < 1912) then
    Exit;

  str := Copy(str, pos1 + 1, 20);
  pos1 := Pos(sp, str);
  if pos1 = 0 then
    Exit;

  month1 := StrToIntDef(Copy(str, 1, pos1 - 1), -1);
  if (month1 > 12) or (month1 < 1) then
    Exit;

  day1 := StrToIntDef(Copy(str, pos1 + 1, 20), -1);
  if (day1 > 31) or (day1 < 1) then
    Exit;

  try
    D := EncodeDate(year1, month1, day1);
    Result := True;
  except
    D := EncodeDate(1912, 1, 1);
  end;
end;

//¨ú2¨¤­q³æ«È¤ápo
function GetOea10(const orderno, remark, oea10: string): string;
var
  Pos1: Integer;
  tmpOrderno, tmpRemark, tmpSQL: string;
  Data: OleVariant;
begin
  Result := oea10;

  tmpOrderno := orderno;
  if Pos(LeftStr(tmpOrderno, 3), 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z') = 0 then
    Exit;

  tmpRemark := remark;
  if Length(tmpRemark) = 0 then
    Exit;

  Pos1 := Pos('-', tmpRemark);
  if Pos1 = 0 then
    Exit;

  tmpRemark := Copy(tmpRemark, Pos1 + 1, 100);
  tmpOrderno := LeftStr(tmpRemark, 10);
  if (Pos('-', tmpOrderno) <> 4) or (Length(tmpOrderno) <> 10) then
    Exit;

  if SameText(g_UInfo^.Bu, 'ITEQDG') then
    tmpSQL := 'iteqgz'
  else if SameText(g_UInfo^.Bu, 'ITEQGZ') then
    tmpSQL := 'iteqdg'
  else
    tmpSQL := g_UInfo^.Bu;
  tmpSQL := 'select oea10 from ' + tmpSQL + '.oea_file' + ' where oea01=' + Quotedstr(tmpOrderno) + ' and rownum=1';
  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
    Exit;

  if not VarIsNull(Data) then
    Result := VarToStr(Data);
end;

//¨ú¤ô¸¹,ªð¦^-1¿ù»~
function GetQRCodeSno(Custno: string; Wdate: TDateTime): Integer;
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := -1;
  tmpSQL := 'Select Sno From MPS080 Where Bu=' + Quotedstr(g_UInfo^.Bu) + ' And Kind=' + Quotedstr(Custno + 'prn') +
    ' And Wdate=' + Quotedstr(DateToStr(Wdate));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
        Result := 0
      else
        Result := tmpCDS.Fields[0].AsInteger;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

function LBLSno(Custno: string): string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'exec proc_GetLBLSno ' + Quotedstr('ITEQDG') + ',' + Quotedstr(Custno);
  if QueryOneCR(tmpSQL, Data) then
    result := VarToStr(Data)
  else
    result := '';
end;

//§ó·s¬y¤ô¸¹
function SetQRCodeSno(Custno: string; Wdate: TDateTime; Sno: Integer): Boolean;
var
  tmpSQL, tmpKind: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := False;
  tmpKind := Custno + 'prn';
  tmpSQL := 'Select * From MPS080 Where Bu=' + Quotedstr(g_UInfo^.Bu) + ' And Kind=' + Quotedstr(tmpKind) +
    ' And Wdate=' + Quotedstr(DateToStr(Wdate));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString := g_UInfo^.Bu;
        tmpCDS.FieldByName('kind').AsString := tmpKind;
        tmpCDS.FieldByName('wdate').AsDateTime := Wdate;
        tmpCDS.FieldByName('iuser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime := Now;
      end
      else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('muser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime := Now;
      end;
      tmpCDS.FieldByName('sno').AsInteger := Sno;
      tmpCDS.Post;
      if not CDSPost(tmpCDS, 'MPS080') then
        Exit;

      Result := True;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//ÀË¬d¬O§_»Ý­n§ó§ï±K½X
function MustChangePW(out xChangePW: Boolean): Boolean;
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := False;
  xChangePW := False;
  tmpSQL := 'exec [dbo].[proc_MustChangePW] ' + Quotedstr(g_UInfo^.Bu) + ',' + Quotedstr(g_UInfo^.UserId);
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    xChangePW := tmpCDS.Fields[0].AsInteger = 1;
    Result := True;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//§ó·s¬y¤ô§Ç¸¹
procedure RefreshSno(DataSet: TClientDataSet; xTb, xFname, xFvalue: string);
var
  sno: Integer;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  tmpSQL := 'select * from ' + xTb + ' where bu=' + Quotedstr(g_UInfo^.Bu) + ' and ' + xFname + '=' + Quotedstr(xFvalue);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
        Exit;

      sno := DataSet.FieldByName('sno').AsInteger;
      while not tmpCDS.Eof do
      begin
        if tmpCDS.FieldByName('sno').AsInteger <> tmpCDS.RecNo then
        begin
          tmpCDS.Edit;
          tmpCDS.FieldByName('sno').AsInteger := tmpCDS.RecNo;
          tmpCDS.Post;
        end;
        tmpCDS.Next;
      end;
      if tmpCDS.ChangeCount > 0 then
        if CDSPost(tmpCDS, xTb) then
        begin
          DataSet.Data := tmpCDS.Data;
          if not DataSet.IsEmpty then
          begin
            DataSet.DisableControls;
            DataSet.Locate('sno', sno - 1, []);
            DataSet.EnableControls;
          end;
        end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//´¡¤J¼Æ¾Ú
procedure InsertRec(DataSet: TClientDataSet);
var
  sno1, sno2: Integer;
  DSNE2, DSNE3, DSNE4: TDataSetNotifyEvent;
begin
  with DataSet do
  begin
    if not Active then
      Exit;

    if State in [dsEdit, dsInsert] then
      Post;

    if IsEmpty then
      Append
    else
    begin
      sno1 := FieldByName('sno').AsInteger;
      sno2 := RecordCount + 1;
      
      //DSNE1:=BeforeEdit;
      DSNE2 := AfterEdit;
      DSNE3 := BeforePost;
      DSNE4 := AfterPost;
      //BeforeEdit:=nil;
      AfterEdit := nil;
      BeforePost := nil;
      AfterPost := nil;
      DisableControls;
      try
        Last;
        while not Bof do
        begin
          Edit;
          FieldByName('sno').AsInteger := sno2;
          Post;
          Prior;
          Dec(sno2);
          if sno2 = sno1 then
            Break;
        end;
        if not Bof then
          Next;
        Insert;
        FieldByName('sno').AsInteger := sno1;
      finally
        //BeforeEdit:=DSNE1;
        AfterEdit := DSNE2;
        BeforePost := DSNE3;
        AfterPost := DSNE4;
        EnableControls;
      end;
    end;
  end;
end;

//½T»{»P¨ú®ø½T»{
function SetConf(DataSet: TClientDataSet; TableName: string): Boolean;
var
  DSNE1, DSNE2, DSNE3, DSNE4: TDataSetNotifyEvent;
begin
  Result := False;

  with DataSet do
  begin
    if IsEmpty then
      Exit;

    if (FindField('Garbage') <> nil) and FieldByName('Garbage').AsBoolean then
    begin
      ShowMsg('³æ¾Ú¤w§@¼o!', 48);
      Exit;
    end;

    DSNE1 := BeforeEdit;
    DSNE2 := AfterEdit;
    DSNE3 := BeforePost;
    DSNE4 := AfterPost;
    BeforeEdit := nil;
    AfterEdit := nil;
    BeforePost := nil;
    AfterPost := nil;
    try
      Edit;
      FieldByName('Conf').AsBoolean := not FieldByName('Conf').AsBoolean;
      if FieldByName('Conf').AsBoolean then
      begin
        FieldByName('Confuser').AsString := g_UInfo^.UserId;
        FieldByName('Confdate').AsDateTime := Now;
      end
      else
      begin
        FieldByName('Confuser').Clear;
        FieldByName('Confdate').Clear;
      end;
      Post;
      Result := CDSPost(DataSet, TableName);
      if not Result then
        CancelUpdates;
    finally
      BeforeEdit := DSNE1;
      AfterEdit := DSNE2;
      BeforePost := DSNE3;
      AfterPost := DSNE4;
    end;
  end;
end;

//¦h¥Î¤á¾Þ§@°ÝÃD,­«·s¬d¸ß¬O§_½T»{
function CheckAsyncConf(xIsConf: Boolean; xTb, xFname, xFvalue: string; hasGarbage: Boolean): Boolean;
var
  isConf: Boolean;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Result := False;

  tmpSQL := 'select conf from ' + xTb + ' where bu=' + Quotedstr(g_UInfo^.Bu) + ' and ' + xFname + '=' + Quotedstr(xFvalue);
  if hasGarbage then
    tmpSQL := tmpSQL + ' and isnull(garbage,0)=0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      if hasGarbage then
        ShowMsg('³æ¾Ú¤£¦s¦b©Î¤w§@¼o!', 48)
      else
        ShowMsg('³æ¾Ú¤£¦s¦b!', 48);
      Exit;
    end;
    isConf := tmpCDS.Fields[0].AsBoolean;
  finally
    FreeAndNil(tmpCDS);
  end;

  if isConf and (not xIsConf) then
  begin
    ShowMsg('¨ä¥L¨Ï¥ÎªÌ¤w½T»{,½Ð­«·s¬d¸ß!', 48);
    Exit;
  end;

  if (not isConf) and xIsConf then
  begin
    ShowMsg('¨ä¥L¨Ï¥ÎªÌ¤w¨ú®ø½T»{,½Ð­«·s¬d¸ß!', 48);
    Exit;
  end;

  Result := True;
end;

function GetDAL(DBtype: string): TDAL;
var
  i: Integer;
begin
  for i := Low(g_DAL) to High(g_DAL) do
    if SameText(g_DAL[i].DBtype, DBtype) then
    begin
      Result := g_DAL[i];
      Exit;
    end;

  Result := nil;
end;

procedure GetMPSMachine;
var
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  g_MachineCCL := '@';
  g_MachinePP := '@';
  g_MachineCCL_DG := '@';
  g_MachineCCL_GZ := '@';
  g_MachinePP_DG := '@';
  g_MachinePP_GZ := '@';
  g_MPS012_Stype := '@';
  g_ThinSize := '9999';

  tmpSQL := 'exec [dbo].[proc_GetMPSMachine] ' + Quotedstr(g_UInfo^.Bu);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      g_MachineCCL := tmpCDS.Fields[0].AsString;
      g_MachinePP := tmpCDS.Fields[1].AsString;
      g_MachineCCL_DG := tmpCDS.Fields[2].AsString;
      g_MachineCCL_GZ := tmpCDS.Fields[3].AsString;
      g_MachinePP_DG := tmpCDS.Fields[4].AsString;
      g_MachinePP_GZ := tmpCDS.Fields[5].AsString;
      g_MPS012_Stype := tmpCDS.Fields[6].AsString;
      g_ThinSize := tmpCDS.Fields[7].AsString;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

function admin: Boolean;
begin
  Result := SameText(g_uinfo^.UserId, 'ID150515');
end;

function Get_PPMRL(pno, qty: string; DataSet: TClientDataSet): boolean;
var
  s, s1: string;
  s3: Double;
begin
  result := true;
  try
    with DataSet do
    begin
      first;
      while not eof do
      begin
        s := fieldbyname(pno).AsString;
        s1 := Copy(s, 1, 1);
        s3 := StrToFloat(Copy(s, 11, 3));

        if (s1 <> 'E') and (s1 <> 'T') and (Length(s) = 18) then
        begin
          edit;
          fieldbyname(qty).AsFloat := fieldbyname(qty).AsFloat / s3;
        end;
        next;
      end;
      first;
    end;
  except
    on ex: Exception do
    begin
      result := false;
      ShowMsg(ex.message, 48);
    end;
  end;
end;

end.

