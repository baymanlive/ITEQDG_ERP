unit unMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, jpeg, StdCtrls, DB, DBClient, StrUtils,
  unFrmBaseEmpty, unGlobal, unCommon, TLHelp32, KImage, ImgList, ShellApi, XPMan,
  unSvr;

//舊
type
  PUserInfo_old = ^TUserInfo_old;

  TUserInfo_old = packed record  //客戶端記錄
    BU,                          //廠別
    UserId,                      //帳號
    UserName,                    //姓名
    Depart,                      //部門
    Room,                        //課室
    Title,                       //職務
    Wk_no,                       //工號
    Host,                        //Rdm IP
    ServerName,                  //Rdm 名稱
    ClientID: string;          //Rdm返回給客戶端ID
    Port: Integer;         //Rdm端口號
  end;

type
  PMenuInfo_old = ^TMenuInfo_old;

  TMenuInfo_old = packed record     //作業記錄
    PId,                         //上級Id
    NId: Integer;          //Id
    ProcId,                      //程式代號
    ProcName,                    //程式名稱
    DllPath,                     //Dll路徑
    Actions: string;           //作業操作
    R_visible,                   //顯示
    R_new,                       //新建
    R_edit,                      //更改
    R_delete,                    //刪除
    R_copy,                      //複製
    R_garbage,                   //無效
    R_query,                     //查詢
    R_print,                     //列印
    R_export,                    //導出Excel
    R_rptDesign: Boolean;        //報表設計
  end;

type
  PDllRecord_old = ^TDllRecord_old;

  TDllRecord_old = packed record
    ProcId: string;
    DllHandle, FormHandle: HWnd;
  end;

type
  TCallBackProc_old = procedure(ProcId: Pchar; DllHandle, FormHandle: HWnd); stdcall;

type
  TDllFunc_old = procedure(AppH, DllHandle: HWnd; UInfo: PUserInfo_old; MInfo: PMenuInfo_old; cbpx: TCallBackProc_old); stdcall;

procedure RefrshList_old(ProcId: PChar; DllHandle, FormHandle: HWnd); stdcall;
//舊

type
  PDllRecord = ^TDllRecord;

  TDllRecord = packed record     //DLL記錄
    ProcId,                      //作業id
    ProcName,                    //作業name
    SBText: string;        //StatusBar.Panels[1].Text
    DllHandle,                   //Dll Handle
    FormHandle: HWnd;          //Form Handle
  end;

type
  PImgLabel = ^TImgLabel;       //Image+Label

  TImgLabel = record
    kImage: TKImage;
    kLabel: TLabel;
    kProcId, kProcName: string;
    kLeft, kTop: Integer;
  end;

type
  TDllFunc = procedure(AppHandle, MainHandle, DllHandle: HWnd; UInfo: PUserInfo; MInfo: PMenuInfo; SBar: TStatusBar; PBar: TProgressBar; cbp: TCallBackProc); stdcall;

type
  TDllFunc_new = procedure(AppHandle, MainHandle, DllHandle: HWnd; UInfo: PUserInfo; MInfo: PMenuInfo; ConnData: TArrConnData; SBar: TStatusBar; PBar: TProgressBar; cbp: TCallBackProc); stdcall;

procedure RefrshList(ProcId, ProcName, SBText: PChar; DllHandle, FormHandle: HWnd; isClose: Boolean); stdcall;

type
  TFrmMain = class(TFrmBaseEmpty)
    Tab: TTabControl;
    pnlForm: TPanel;
    imgtop: TImage;
    pnlTop: TPanel;
    lbltitle: TLabel;
    Splitter1: TSplitter;
    TV: TTreeView;
    SB: TStatusBar;
    PB: TProgressBar;
    CDS: TClientDataSet;
    Timer1: TTimer;
    imglogo: TImage;
    Image1: TImage;
    imgexit: TKImage;
    imgpw: TKImage;
    imgfav: TKImage;
    imgfavX: TKImage;
    imgfavY: TKImage;
    imgfav1: TKImage;
    imgpw1: TKImage;
    imgexit1: TKImage;
    imgfav2: TKImage;
    imgpw2: TKImage;
    imgexit2: TKImage;
    imghelp: TKImage;
    imghelp1: TKImage;
    imghelp2: TKImage;
    imgsp: TImage;
    XPManifest1: TXPManifest;
    Timer2: TTimer;
    Edit1: TEdit;
    procedure TabChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TVDblClick(Sender: TObject);
    procedure SBDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure Timer1Timer(Sender: TObject);
    procedure imgpwMouseEnter(Sender: TObject);
    procedure pnlFormResize(Sender: TObject);
    procedure imgexitMouseEnter(Sender: TObject);
    procedure imgexitMouseLeave(Sender: TObject);
    procedure imgpwMouseLeave(Sender: TObject);
    procedure imgfavMouseLeave(Sender: TObject);
    procedure imgexitClick(Sender: TObject);
    procedure imgpwClick(Sender: TObject);
    procedure imgfavClick(Sender: TObject);
    procedure imgfavMouseEnter(Sender: TObject);
    procedure imghelpMouseEnter(Sender: TObject);
    procedure imghelpMouseLeave(Sender: TObject);
    procedure imghelpClick(Sender: TObject);
    procedure imgspClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    l_Close: Boolean;
    l_DllList: TList;
    l_ImgLabelList: TList;
    l_ClrList: TStringList;

    //舊變量
    l_MenuInfoList: TList;
    l_UInfo_old: PUserInfo_old;
    //舊變量

    procedure SetPnlForm;
    procedure SetSplitter;
    function GetParentTreeNode(PId: Integer): TTreeNode;
    procedure LoadMenu;
    procedure LoadFavorite;
    function CheckDllForm_old(ProcId: string): Boolean;
    procedure ShowForm_old(const tn: TTreeNode); overload;
    procedure ShowForm_old(const P: PMenuInfo); overload;
    function CheckForm(const ProcId, ProcName: string): Boolean;
    procedure ShowForm(const tn: TTreeNode);
    procedure CreateImgLabel(const ProcId, ProcName: string);
    procedure imgfavXYMouseEnter(Sender: TObject);
    procedure imgfavXYMouseLeave(Sender: TObject);
    procedure imgfavXYClick(Sender: TObject);
    //舊
    procedure CreateOldInfo;
    procedure FreeOldInfo;
    //舊
    { Private declarations }
  public    { Public declarations }
    procedure MyMessage(var msg: TWmCopyData); message WM_CopyData;
  end;

var
  FrmMain: TFrmMain;
  l_LockList: TRTLCriticalSection;      //互斥變量
  //舊
  l_LockList_old: TRTLCriticalSection;
  l_List_old: TList;
  //舊

implementation

uses
  unPW, unFavorite;

const
  l_configfile = 'iteqerp.txt';

{$R *.dfm}
//舊回詷函數
procedure RefrshList_old(ProcId: PChar; DllHandle, FormHandle: HWnd); stdcall;
var
  find_bo: Boolean;
  i: Integer;
  PDllRec: PDllRecord_old;
begin
  EnterCriticalSection(l_LockList_old);
  try
    find_bo := False;
    for i := l_List_old.Count - 1 downto 0 do
    begin
      PDllRec := PDllRecord_old(l_List_old.Items[i]);
      if (PDllRec^.ProcId = ProcId) and (PDllRec^.DllHandle = DllHandle) and (PDllRec^.FormHandle = FormHandle) then
      begin
        FrmMain.l_ClrList.Add(IntToStr(DllHandle));
        Dispose(PDllRec);
        l_List_old.Delete(i);
        find_bo := True;
        Break;
      end;
    end;

    if not find_bo then
    begin
      New(PDllRec);
      PDllRec^.ProcId := ProcId;
      PDllRec^.DllHandle := DllHandle;
      PDllRec^.FormHandle := FormHandle;
      l_List_old.Add(PDllRec);
    end;
  finally
    LeaveCriticalSection(l_LockList_old);
  end;
end;

//dll回調函數
procedure RefrshList(ProcId, ProcName, SBText: PChar; DllHandle, FormHandle: HWnd; isClose: Boolean); stdcall;
var
  i, j, newIndex: Integer;
  PDllRec: PDllRecord;
begin
  EnterCriticalSection(l_LockList);
  try
    if isClose then
    begin
      for i := FrmMain.l_DllList.Count - 1 downto 0 do
      begin
        PDllRec := PDllRecord(FrmMain.l_DllList.Items[i]);
        if (PDllRec^.ProcId = ProcId) and (PDllRec^.DllHandle = DllHandle) and (PDllRec^.FormHandle = FormHandle) then
        begin
          //改變TabIndex
          for j := 0 to FrmMain.Tab.Tabs.Count - 1 do
            if FrmMain.Tab.Tabs[j] = PDllRec^.ProcName then
            begin
              FrmMain.Tab.Tabs.BeginUpdate;
              FrmMain.Tab.Tabs.Delete(j);
              if j = FrmMain.Tab.Tabs.Count then
                newIndex := j - 1
              else
                newIndex := j;
              FrmMain.Tab.TabIndex := newIndex;
              FrmMain.Tab.Tabs.EndUpdate;
              Break;
            end;

          //刪除l_DllList項目
          Dispose(PDllRec);
          FrmMain.l_DllList.Delete(i);

          //設置新的Form顯示
          FrmMain.SB.Panels[1].Text := '';
          FrmMain.SB.Panels[2].Text := '';
          for j := 0 to FrmMain.l_DllList.Count - 1 do
          begin
            PDllRec := PDllRecord(FrmMain.l_DllList.Items[j]);
            if PDllRec^.ProcName = FrmMain.Tab.Tabs[FrmMain.Tab.TabIndex] then
            begin
              ShowWindow(PDllRec^.FormHandle, SW_RESTORE);
              FrmMain.SB.Panels[1].Text := PDllRec^.SBText;
              FrmMain.SB.Panels[2].Text := PDllRec^.ProcId;
            end
            else
              ShowWindow(PDllRec^.FormHandle, SW_HIDE);
          end;

          //FreeLibrary dll
          FrmMain.l_ClrList.Add(IntToStr(DllHandle));
          FrmMain.SetPnlForm;
          Break;
        end;
      end;
    end
    else
    begin
      for j := 0 to FrmMain.l_DllList.Count - 1 do
        ShowWindow(PDllRecord(FrmMain.l_DllList.Items[j])^.FormHandle, SW_HIDE);
      New(PDllRec);
      PDllRec^.ProcId := StrPas(ProcId);
      PDllRec^.ProcName := StrPas(ProcName);
      PDllRec^.SBText := StrPas(SBText);
      PDllRec^.DllHandle := DllHandle;
      PDllRec^.FormHandle := FormHandle;
      FrmMain.l_DllList.Add(PDllRec);
      Windows.SetParent(PDllRec^.FormHandle, FrmMain.pnlForm.Handle);
      FrmMain.Tab.Tabs.Add(PDllRec^.ProcName);
      FrmMain.Tab.TabIndex := FrmMain.Tab.Tabs.Count - 1;
      FrmMain.SB.Panels[1].Text := PDllRec^.SBText;
      FrmMain.SB.Panels[2].Text := PDllRec^.ProcId;
      FrmMain.SetPnlForm;
    end;
  finally
    LeaveCriticalSection(l_LockList);
  end;
end;

//強制結束進程
procedure EndProcess(PID: Cardinal);
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  while Integer(ContinueLoop) <> 0 do
  begin
    if FProcessEntry32.th32ProcessID = PID then
    begin
      TerminateProcess(OpenProcess(PROCESS_TERMINATE, BOOL(0), FProcessEntry32.th32ProcessID), 0);
      Break;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

//來自dll消息
procedure TFrmMain.MyMessage(var msg: TWmCopyData);
var
  i: Integer;
  str: string;
begin
  str := LowerCase(StrPas(msg.CopyDataStruct^.lpData));
  if SameText(Copy(str, 1, 5), 'open,') then
  begin
    str := Copy(str, 6, 20);
    for i := 0 to TV.Items.Count - 1 do
      if SameText(PMenuInfo(TV.Items[i].Data)^.ProcId, str) then
      begin
        ShowForm(TV.Items[i]);
        Break;
      end;
  end
  else if SameText(str, 'help') then
    imghelpClick(imghelp);
  //inherited;  TFrmBaseEmpty->MyMessage
end;

//設置pnlForm Size
procedure TFrmMain.SetPnlForm;
var
  i: Integer;
  ProcName: string;
  rc: TRect;
begin
  if GetWindowRect(pnlForm.Handle, rc) then
  begin
    ProcName := Tab.Tabs.Strings[Tab.TabIndex];
    for i := 0 to l_DllList.Count - 1 do
      if PDllRecord(l_DllList.Items[i])^.ProcName = ProcName then
        SetWindowPos(PDllRecord(l_DllList.Items[i])^.FormHandle, 0, 0, 0, rc.Right - rc.Left, rc.Bottom - rc.Top, SWP_NOACTIVATE);
  end;
end;

//設置Splitter Location
procedure TFrmMain.SetSplitter;
begin
  Splitter1.Left := TV.Left + TV.Width;
  imgsp.Left := Splitter1.Left;
  imgsp.Top := Round(TV.Height / 2 + TV.Top);
end;

//Get Parent Tree Node
function TFrmMain.GetParentTreeNode(PId: Integer): TTreeNode;
var
  i: Integer;
begin
  Result := nil;
  for i := TV.Items.Count - 1 downto 0 do
  begin
    if PMenuInfo(TV.Items[i].Data)^.NId = PId then
    begin
      Result := TV.Items[i];
      Break;
    end;
  end;
end;

//加載菜單
procedure TFrmMain.LoadMenu;
var
  tmpSQL: string;
  P: PMenuInfo;
  tn: TTreeNode;
  Data: OleVariant;
begin
  TV.Items.BeginUpdate;
  try
    tmpSQL := 'Select A.*,B.R_visible,B.R_new,B.R_edit,B.R_delete,B.R_copy,B.R_garbage,' + ' B.R_conf,B.R_check,B.R_query,B.R_print,B.R_export,B.R_rptDesign' + ' From Sys_Menu A Left Join Sys_UserRight B' + ' ON A.ProcId=B.ProcId' + ' Where B.Bu=' + Quotedstr(g_UInfo^.BU) + ' And B.UserId=' + Quotedstr(g_UInfo^.UserId) + ' Order By A.PId,A.SnoASC';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;

    CDS.Data := Data;
    with CDS do
      while not Eof do
      begin
        if FieldByName('R_visible').AsBoolean then
        begin
          tn := nil;
          if FieldByName('PId').AsInteger >= 0 then
          begin
            tn := GetParentTreeNode(FieldByName('PId').AsInteger);
            if tn = nil then
            begin
              Next;
              Continue;
            end;
          end;

          New(P);
          P^.PID := FieldByName('PId').AsInteger;
          P^.NId := FieldByName('NId').AsInteger;
          P^.ProcId := FieldByName('ProcId').AsString;
          P^.ProcName := FieldByName('ProcName').AsString;
          P^.DllPath := FieldByName('DllPath').AsString;
          P^.Actions := FieldByName('Actions').AsString;
          P^.IsExe := FieldByName('IsExe').AsBoolean;
          P^.IsPop := FieldByName('IsPop').AsBoolean;
          if RightStr(P^.DllPath, 1) <> '\' then
            P^.DllPath := P^.DllPath + '\';
          P^.R_visible := FieldByName('R_visible').AsBoolean;
          P^.R_new := FieldByName('R_new').AsBoolean;
          P^.R_edit := FieldByName('R_edit').AsBoolean;
          P^.R_delete := FieldByName('R_delete').AsBoolean;
          P^.R_copy := FieldByName('R_copy').AsBoolean;
          P^.R_garbage := FieldByName('R_garbage').AsBoolean;
          P^.R_conf := FieldByName('R_conf').AsBoolean;
          P^.R_check := FieldByName('R_check').AsBoolean;
          P^.R_query := FieldByName('R_query').AsBoolean;
          P^.R_print := FieldByName('R_print').AsBoolean;
          P^.R_export := FieldByName('R_export').AsBoolean;
          P^.R_rptDesign := FieldByName('R_rptDesign').AsBoolean;
          if tn = nil then
            TV.Items.AddObject(nil, P^.ProcName + '(' + P^.ProcId + ')', P)
          else
            TV.Items.AddChildObject(tn, P^.ProcName + '(' + P^.ProcId + ')', P);
        end;

        Next;
      end;

    CDS.Active := False;
    if TV.Items.Count > 0 then
      TV.Items[0].Expanded := True;
  finally
    TV.Items.EndUpdate;
  end;
end;

procedure TFrmMain.LoadFavorite;
var
  I: Integer;
  tmpSQL: string;
  Data: OleVariant;
begin
  if TV.Items.Count = 0 then
    Exit;

  tmpSQL := 'Select A.ProcId,B.ProcName From Sys_Favorite A,Sys_Menu B' + ' Where A.ProcId=B.ProcId' + ' And A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.UserId=' + Quotedstr(g_UInfo^.UserId) + ' Order By A.SnoAsc,B.SnoAsc';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  CDS.Data := Data;
  with CDS do
    while not Eof do
    begin
      for I := 0 to TV.Items.Count - 1 do
        if SameText(PMenuInfo(TV.Items[I].Data)^.ProcId, Fields[0].AsString) then
          CreateImgLabel(Fields[0].AsString, Fields[1].AsString);
      Next;
    end;
end;

//舊:檢查是否顯示form
function TFrmMain.CheckDllForm_old(ProcId: string): Boolean;
var
  i: integer;
  PDllRec: PDllRecord_old;
begin
  Result := False;
  for i := l_list_old.Count - 1 downto 0 do
  begin
    PDllRec := PDllRecord_old(l_list_old.Items[i]);
    if PDllRec^.ProcId = ProcId then
    begin
      ShowWindow(PDllRec^.FormHandle, SW_RESTORE);
      SetForegroundWindow(PDllRec^.FormHandle);
      Result := True;
      Break;
    end;
  end;
end;

procedure TFrmMain.ShowForm_old(const P: PMenuInfo);
var
  isFind: Boolean;
  i: Integer;
  DllHandle: HWnd;
  DllFunc: TDllFunc_old;
  P_old: PMenuInfo_old;
begin
  if CheckDllForm_old(P^.ProcId) then
    Exit;

  isFind := False;
  P_old := nil;
  for i := 0 to l_MenuInfoList.Count - 1 do
  begin
    if PMenuInfo_old(l_MenuInfoList.Items[i])^.ProcId = P^.ProcId then
    begin
      P_old := PMenuInfo_old(l_MenuInfoList.Items[i]);
      isFind := True;
      Break;
    end;
  end;

  if not isFind then
  begin
    new(P_old);
    P_old^.PID := P^.PID;
    P_old^.NId := P^.NId;
    P_old^.ProcId := P^.ProcId;
    P_old^.ProcName := P^.ProcName;
    P_old^.DllPath := P^.DllPath;
    P_old^.Actions := P^.Actions;
    P_old^.R_visible := P^.R_visible;
    P_old^.R_new := P^.R_new;
    P_old^.R_edit := P^.R_edit;
    P_old^.R_delete := P^.R_delete;
    P_old^.R_copy := P^.R_copy;
    P_old^.R_garbage := P^.R_garbage;
    P_old^.R_query := P^.R_query;
    P_old^.R_print := P^.R_print;
    P_old^.R_export := P^.R_export;
    P_old^.R_rptDesign := P^.R_rptDesign;
    l_MenuInfoList.Add(P_old);
  end;

  if P_old = nil then
  begin
    ShowMsg('error', 48);
    Exit;
  end;

  DllHandle := LoadLibrary(PChar(P^.DllPath + P^.ProcId + '.dll'));
  if DllHandle <> 0 then
  begin
    @DllFunc := GetProcAddress(DllHandle, 'ShowDllForm');
    if @DllFunc <> nil then
      DllFunc(Application.Handle, DllHandle, l_UInfo_old, P_old, @RefrshList_old)
    else
      FreeLibrary(DllHandle);
  end;
end;


//舊:調用dll顯示form
procedure TFrmMain.ShowForm_old(const tn: TTreeNode);
begin
  ShowForm_old(tn.Data);
end;

//查詢from是否存在
function TFrmMain.CheckForm(const ProcId, ProcName: string): Boolean;
var
  i, j, index: integer;
  PDllRec: PDllRecord;
begin
  Result := False;

  if Tab.Tabs[Tab.TabIndex] = ProcName then
  begin
    Result := True;
    Exit;
  end;

  index := -1;
  for i := 0 to l_DllList.Count - 1 do
    if PDllRecord(l_DllList.Items[i])^.ProcId = ProcId then
    begin
      index := i;
      Break;
    end;

  SB.Panels[1].Text := '';
  SB.Panels[2].Text := '';
  if index <> -1 then
  begin
    for i := 0 to l_DllList.Count - 1 do
    begin
      PDllRec := PDllRecord(l_DllList.Items[i]);
      if i = index then
      begin
        ShowWindow(PDllRec^.FormHandle, SW_RESTORE);
        SB.Panels[1].Text := PDllRec^.SBText;
        SB.Panels[2].Text := PDllRec^.ProcId;
        for j := 0 to Tab.Tabs.Count - 1 do
          if Tab.Tabs[j] = ProcName then
          begin
            Tab.TabIndex := j;
            Break;
          end;
        SetPnlForm;
        Result := True;
      end
      else
        ShowWindow(PDllRec^.FormHandle, SW_HIDE);
    end;
  end;
end;

//調用dll顯示form
procedure TFrmMain.ShowForm(const tn: TTreeNode);
var
  DllHandle: HWnd;
  DllFunc: TDllFunc;
  DllFunc_new: TDllFunc_new;
  P: PMenuInfo;
begin
  P := PMenuInfo(tn.Data);

  if P^.IsPop then
  begin
    ShowForm_old(tn);
    Exit;
  end;

  if Length(P^.DllPath) = 0 then
    Exit;

  if P^.IsExe then
  begin
    WinExec(PAnsiChar(P^.DllPath + P^.ProcId + '.exe ' + g_UInfo^.BU + ' ' + g_UInfo^.UserId + ' ' + g_PW), SW_SHOWNORMAL);
    Exit;
  end;

  if CheckForm(P^.ProcId, P^.ProcName) then
    Exit;

  DllHandle := LoadLibrary(PChar(P^.DllPath + P^.ProcId + '.dll'));
  if DllHandle <> 0 then
  begin
    if P^.Actions = '1' then
    begin
      @DllFunc_new := GetProcAddress(DllHandle, 'ShowDllForm');
      if @DllFunc_new <> nil then
        DllFunc_new(Application.Handle, Self.Handle, DllHandle, g_UInfo, P, g_ConnData, SB, PB, @RefrshList)
      else
        FreeLibrary(DllHandle);
    end
    else
    begin
      @DllFunc := GetProcAddress(DllHandle, 'ShowDllForm');
      if @DllFunc <> nil then
        DllFunc(Application.Handle, Self.Handle, DllHandle, g_UInfo, P, SB, PB, @RefrshList)
      else
        FreeLibrary(DllHandle);
    end;
  end;
end;

//工作台快捷程式
procedure TFrmMain.CreateImgLabel(const ProcId, ProcName: string);
const
  num = 20;
var
  xleft, xtop: Integer;
  P: PImgLabel;
begin
  New(P);
  P^.kImage := TKImage.Create(Self);     //圖片
  with P^.kImage do
  begin
    Picture.Assign(imgfavX.Picture);
    Width := 64;
    Height := 64;
    Tag := l_ImgLabelList.Count;
    Cursor := crHandPoint;
    OnMouseEnter := imgfavXYMouseEnter;
    OnMouseLeave := imgfavXYMouseLeave;
    OnClick := imgfavXYClick;
    Parent := pnlForm;
  end;

  P^.kLabel := TLabel.Create(Self);      //標題
  with P^.kLabel do
  begin
    Caption := ProcId;
    AutoSize := False;
    Alignment := taCenter;
    Width := P^.kImage.Width;
    Tag := l_ImgLabelList.Count;
    Cursor := crHandPoint;
    Transparent := True;
    OnMouseEnter := imgfavXYMouseEnter;
    OnMouseLeave := imgfavXYMouseLeave;
    OnClick := imgfavXYClick;
    Parent := pnlForm;
  end;

  xleft := num;
  xtop := num;
  if l_ImgLabelList.Count > 0 then
  begin
    xleft := PImgLabel(l_ImgLabelList.Items[l_ImgLabelList.Count - 1])^.kLeft;
    xtop := PImgLabel(l_ImgLabelList.Items[l_ImgLabelList.Count - 1])^.kTop + P^.kImage.Height + P^.kLabel.Height + num;
  end;
  if xtop + P^.kImage.Height + P^.kLabel.Height > pnlForm.ClientHeight then
  begin
    xleft := xleft + P^.kImage.Width + 30;
    xtop := num;
  end;

  P^.kImage.Left := xleft;
  P^.kImage.Top := xtop;
  P^.kLabel.Left := xleft;
  P^.kLabel.Top := xtop + P^.kImage.Height;
  P^.kLeft := xleft;
  P^.ktop := xtop;
  P^.kProcId := ProcId;
  P^.kProcName := ProcName;
  l_ImgLabelList.Add(P);
end;

//鼠標進入控件
procedure TFrmMain.imgfavXYMouseEnter(Sender: TObject);
var
  index: Integer;
  P: PImgLabel;
begin
  if Sender is TKImage then
    index := TKImage(Sender).Tag
  else
    index := TLabel(Sender).Tag;
  if index < 0 then
    Exit;

  P := PImgLabel(l_ImgLabelList.Items[index]);
  P^.kImage.Picture.Assign(imgfavY.Picture);
  SB.Panels[0].Text := P^.kProcName;
end;

//鼠標離開控件
procedure TFrmMain.imgfavXYMouseLeave(Sender: TObject);
var
  index: Integer;
  P: PImgLabel;
begin
  if Sender is TKImage then
    index := TKImage(Sender).Tag
  else
    index := TLabel(Sender).Tag;
  if index < 0 then
    Exit;

  P := PImgLabel(l_ImgLabelList.Items[index]);
  P^.kImage.Picture.Assign(imgfavX.Picture);
  SB.Panels[0].Text := '';
end;

//圖片點擊事件
procedure TFrmMain.imgfavXYClick(Sender: TObject);
var
  index: Integer;
  P: PImgLabel;
begin
  inherited;
  if Sender is TKImage then
    index := TKImage(Sender).Tag
  else
    index := TLabel(Sender).Tag;

  P := PImgLabel(l_ImgLabelList.Items[index]);
  for index := 0 to TV.Items.Count - 1 do
    if SameText(PMenuInfo(TV.Items[index].Data)^.ProcId, P^.kProcId) then
      ShowForm(TV.Items[index]);
end;

procedure TFrmMain.CreateOldInfo;
begin
  l_List_old := TList.Create;
  l_MenuInfoList := TList.Create;
  New(l_UInfo_old);
  l_UInfo_old^.BU := g_UInfo^.BU;
  l_UInfo_old^.UserId := g_UInfo^.UserId;
  l_UInfo_old^.UserName := g_UInfo^.UserName;
  l_UInfo_old^.Depart := g_UInfo^.Depart;
  l_UInfo_old^.Room := g_UInfo^.Room;
  l_UInfo_old^.Title := g_UInfo^.Title;
  l_UInfo_old^.Wk_no := g_UInfo^.Wk_no;
  l_UInfo_old^.Host := g_UInfo^.Host;
  l_UInfo_old^.ServerName := g_UInfo^.ServerName;
  l_UInfo_old^.ClientID := g_UInfo^.ClientID;
  l_UInfo_old^.Port := g_UInfo^.Port;
  InitializeCriticalSection(l_LockList_old);
end;

procedure TFrmMain.FreeOldInfo;
var
  i: Integer;
begin
  for i := l_List_old.Count - 1 downto 0 do
    Dispose(PDllRecord_old(l_List_old.Items[i]));
  l_List_old.Clear;
  FreeAndNil(l_List_old);

  for i := l_MenuInfoList.Count - 1 downto 0 do
    Dispose(PMenuInfo_old(l_MenuInfoList.Items[i]));
  l_MenuInfoList.Clear;
  FreeAndNil(l_MenuInfoList);

  Dispose(l_UInfo_old);
  DeleteCriticalSection(l_LockList_old);
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  tmpList: TStrings;
  ProgressBarStyle: Integer;
begin
  inherited;
  tmpList := TStringList.Create;
  try
    if FileExists(g_UInfo^.TempPath + l_configfile) then
      tmpList.LoadFromFile(g_UInfo^.TempPath + l_configfile);
    if tmpList.Count > 0 then
    begin
      TV.Width := StrToIntDef(tmpList.Strings[0], 220);
      if (TV.Width >= 500) or (TV.Width <= 10) then
        TV.Width := 220;
    end
    else
      TV.Width := 220;

  finally
    FreeAndNil(tmpList);
  end;

  Self.Caption := g_UInfo^.Cname;
  if Length(Trim(g_UInfo^.UserName)) = 0 then
    lbltitle.Caption := CheckLang('歡迎您|') + g_UInfo^.UserId
  else
    lbltitle.Caption := CheckLang('歡迎您|') + g_UInfo^.UserName;
  Tab.Tabs[0] := CheckLang('我的工作台');
  g_StatusBar := Self.SB;
  g_ProgressBar := Self.PB;
  pnlTop.Height := 58;
  imglogo.Width := 221;
  lbltitle.Left := imgtop.Left + 5;
  imgexit.Top := Round((pnlTop.Height - imgexit.Height) / 2);
  imgpw.Top := imgexit.Top;
  imgfav.Top := imgexit.Top;
  imghelp.Top := imgexit.Top;
  lbltitle.Top := Round((pnlTop.Height - lbltitle.Height) / 2);
  imgexit.Left := pnlTop.ClientWidth - imgexit.Width - 5;
  imgpw.Left := imgexit.Left - imgpw.Width - 5;
  imgfav.Left := imgpw.Left - imgfav.Width - 5;
  imghelp.Left := imgfav.Left - imghelp.Width - 5;
  imglogo.Picture.LoadFromFile(g_UInfo^.SysPath + 'img\logo.jpg');
  imgtop.Picture.LoadFromFile(g_UInfo^.SysPath + 'img\top.jpg');
  imgsp.Parent := Self;

  PB.Visible := False;
  SB.Panels[3].Style := psOwnerDraw;
  PB.Parent := SB;
  ProgressBarStyle := GetWindowLong(PB.Handle, GWL_EXSTYLE);
  ProgressBarStyle := ProgressBarStyle - WS_EX_STATICEDGE;
  SetWindowLong(PB.Handle, GWL_EXSTYLE, ProgressBarStyle);

  l_DllList := TList.Create;
  l_ImgLabelList := TList.Create;
  l_ClrList := TStringList.Create;
  LoadMenu;
  LoadFavorite;

  CreateOldInfo;

  InitializeCriticalSection(l_LockList);
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  tmpErr: string;
  PID: DWORD;
  tmpList: TStrings;
begin
  if ShowMsg('確定退出系統嗎?', 33) = IdCancel then
  begin
    Action := caNone;
    Exit;
  end;

  TSvr.LogOut(g_UInfo^.ClientID, tmpErr);

  l_Close := True;

  tmpList := TStringList.Create;
  try
    if FileExists(g_UInfo^.TempPath + l_configfile) then
      tmpList.LoadFromFile(g_UInfo^.TempPath + l_configfile);
    if tmpList.Count = 0 then
      tmpList.Add(IntToStr(TV.Width))
    else
      tmpList.Strings[0] := IntToStr(TV.Width);
    if TV.Width <= 10 then
      tmpList.Strings[0] := '220';
    tmpList.SaveToFile(g_UInfo^.TempPath + l_configfile);
  finally
    FreeAndNil(tmpList);
  end;

  for i := 0 to l_ImgLabelList.Count - 1 do
  begin
    FreeAndNil(PImgLabel(l_ImgLabelList.Items[i])^.kImage);
    FreeAndNil(PImgLabel(l_ImgLabelList.Items[i])^.kLabel);
    Dispose(PImgLabel(l_ImgLabelList.Items[i]));
  end;
  l_ImgLabelList.Clear;

  for i := 0 to TV.Items.Count - 1 do
    Dispose(PMenuInfo(TV.Items[i].Data));

  for i := l_DllList.Count - 1 downto 0 do
  begin
    CopyDataSendMsg(PDllRecord(l_DllList.Items[i])^.FormHandle, 'close'); //向作業發送關閉消息
    Dispose(PDllRecord(l_DllList.Items[i]));
  end;

  for i := Low(g_ConnData) to High(g_ConnData) do
  begin
    g_ConnData[i].ADOConn.Connected := False;
    FreeAndNil(g_ConnData[i].ADOConn);
  end;
  SetLength(g_ConnData, 0);

  for i := Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);

  l_DllList.Clear;
  FreeAndNil(l_DllList);
  FreeAndNil(l_ClrList);
  Dispose(g_UInfo);
  Dispose(g_MInfo);
  DeleteCriticalSection(l_LockList);
  FreeOldInfo;

  GetWindowThreadProcessid(Handle, PID);
  EndProcess(PID);
end;

procedure TFrmMain.TVDblClick(Sender: TObject);
var
  Node: TTreeNode;
  X, Y: Integer;
  ht: THitTests;
begin
  if l_ClrList.Count > 0 then
  begin
    ShowMsg('正在處理上次關閉的作業,請稍後重試!', 48);
    Exit;
  end;

  with TV do
  begin
    X := ScreenToClient(Mouse.CursorPos).X;
    Y := ScreenToClient(Mouse.CursorPos).Y;
    ht := GetHitTestInfoAt(X, Y);
    if htOnItem in ht then
    begin
      Node := GetNodeAt(X, Y);
      if Node <> nil then
      begin
        ShowForm(Node);
        //Tab.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmMain.TabChange(Sender: TObject);
var
  i: Integer;
  PDllRec: PDllRecord;
begin
  SB.Panels[1].Text := '';
  SB.Panels[2].Text := '';
  with l_DllList do
    for i := 0 to Count - 1 do
    begin
      PDllRec := PDllRecord(l_DllList.Items[i]);
      if PDllRec^.ProcName = Tab.Tabs[Tab.TabIndex] then
      begin
        ShowWindow(PDllRec^.FormHandle, SW_RESTORE);
        SetPnlForm;
        SB.Panels[1].Text := PDllRec^.SBText;
        SB.Panels[2].Text := PDllRec^.ProcId;
      end
      else
        ShowWindow(PDllRec^.FormHandle, SW_HIDE);
    end;
end;

procedure TFrmMain.SBDrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
begin
  if Panel = StatusBar.Panels[3] then
    with PB do
    begin
      Top := Rect.Top;
      Left := Rect.Left;
      Width := Rect.Right - Rect.Left - 2;
      Height := Rect.Bottom - Rect.Top;
    end;
end;

procedure TFrmMain.pnlFormResize(Sender: TObject);
const
  num = 20;
var
  i: integer;
  xleft, xtop, newtop: Integer;
  P: PImgLabel;
begin
  if l_close then
    Exit;

  SetSplitter;
  SetPnlForm;

  xleft := num;
  xtop := num;
  for i := 0 to l_ImgLabelList.Count - 1 do
  begin
    P := PImgLabel(l_ImgLabelList.Items[i]);
    P^.kImage.Left := xleft;
    P^.kImage.Top := xtop;
    P^.kLabel.Left := xleft;
    P^.kLabel.Top := xtop + P^.kImage.Height;
    P^.kLeft := xleft;
    P^.ktop := xtop;

    newtop := P^.kImage.Height + P^.kLabel.Height;
    if xtop + newtop * 2 + num > pnlForm.ClientHeight then
    begin
      xleft := xleft + P^.kImage.Width + 30;
      xtop := num;
    end
    else
      xtop := xtop + newtop + num;
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
begin
  if l_ClrList.Count > 0 then
  begin
    Timer1.Enabled := False;
    FreeLibrary(StrToInt(l_ClrList.Strings[0]));
    l_ClrList.Delete(0);
    Timer1.Enabled := True;
  end;
end;

procedure TFrmMain.Timer2Timer(Sender: TObject);
var
  tmpErr: string;
begin
  inherited;
  try
    TSvr.OnLine(g_UInfo^.ClientID, g_UInfo^.UserId, g_UInfo^.UserName, g_UInfo^.Depart, g_UInfo^.LocalIP, g_UInfo^.LocalComputerName, tmpErr);
  except
  end;
end;

procedure TFrmMain.imgexitMouseEnter(Sender: TObject);
begin
  inherited;
  imgexit.Picture.Assign(imgexit2.Picture);
  SB.Panels[0].Text := CheckLang('關閉當前作業或退出系統');
end;

procedure TFrmMain.imgexitMouseLeave(Sender: TObject);
begin
  inherited;
  imgexit.Picture.Assign(imgexit1.Picture);
  SB.Panels[0].Text := '';
end;

procedure TFrmMain.imgpwMouseEnter(Sender: TObject);
begin
  imgpw.Picture.Assign(imgpw2.Picture);
  SB.Panels[0].Text := CheckLang('更改密碼');
end;

procedure TFrmMain.imgpwMouseLeave(Sender: TObject);
begin
  inherited;
  imgpw.Picture.Assign(imgpw1.Picture);
  SB.Panels[0].Text := '';
end;

procedure TFrmMain.imgfavMouseEnter(Sender: TObject);
begin
  inherited;
  imgfav.Picture.Assign(imgfav2.Picture);
  SB.Panels[0].Text := CheckLang('設置工作台程式');
end;

procedure TFrmMain.imgfavMouseLeave(Sender: TObject);
begin
  inherited;
  imgfav.Picture.Assign(imgfav1.Picture);
  SB.Panels[0].Text := '';
end;

procedure TFrmMain.imghelpMouseEnter(Sender: TObject);
begin
  inherited;
  imghelp.Picture.Assign(imghelp2.Picture);
  SB.Panels[0].Text := CheckLang('查看幫助文件');
end;

procedure TFrmMain.imghelpMouseLeave(Sender: TObject);
begin
  inherited;
  imghelp.Picture.Assign(imghelp1.Picture);
  SB.Panels[0].Text := '';
end;

procedure TFrmMain.imgexitClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  if (l_DllList.Count = 0) or (Tab.TabIndex = 0) then
    Close
  else if Tab.TabIndex > 0 then
  begin
    for i := 0 to l_DllList.Count - 1 do
      if Tab.Tabs.Strings[Tab.TabIndex] = PDllRecord(l_DllList.Items[i])^.ProcName then
      begin
        CopyDataSendMsg(PDllRecord(l_DllList.Items[i])^.FormHandle, 'quit'); //退出作業
        Break;
      end;
  end;
end;

procedure TFrmMain.imgpwClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmPW) then
    FrmPW := TFrmPW.Create(Application);
  FrmPW.ShowModal;
end;

procedure TFrmMain.imgfavClick(Sender: TObject);
begin
  inherited;
  FrmFavorite := TFrmFavorite.Create(nil);
  FrmFavorite.ShowModal;
  FreeAndNil(FrmFavorite);
end;

procedure TFrmMain.imghelpClick(Sender: TObject);
var
  i: Integer;
  str: string;
begin
  inherited;
  if Tab.TabIndex = 0 then
    str := 'main'
  else
  begin
    str := Tab.Tabs.Strings[Tab.TabIndex];
    for i := 0 to l_DllList.Count - 1 do
      if str = PDllRecord(l_DllList.Items[i])^.ProcName then
      begin
        str := PDllRecord(l_DllList.Items[i])^.ProcId;
        Break;
      end;
  end;

  ShellExecute(Handle, nil, PAnsiChar('Help\' + str + '.html'), nil, nil, SW_SHOWNORMAL);
end;

procedure TFrmMain.Edit1KeyPress(Sender: TObject; var Key: Char);
var
  DllHandle: HWnd;
  DllFunc: TDllFunc;
  DllFunc_new: TDllFunc_new;
  P: PMenuInfo;
  tmpSQL: string;
  Data: OleVariant;
  tmpcds: Tclientdataset;
begin
  if Key <> #13 then
    exit;
  tmpSQL := 'Select A.*,B.R_visible,B.R_new,B.R_edit,B.R_delete,B.R_copy,B.R_garbage,' + ' B.R_conf,B.R_check,B.R_query,B.R_print,B.R_export,B.R_rptDesign' + ' From Sys_Menu A Left Join Sys_UserRight B' + ' ON A.ProcId=B.ProcId' + ' Where B.Bu=' + Quotedstr(g_UInfo^.BU) + ' And B.UserId=' + Quotedstr(g_UInfo^.UserId) + ' And a.procid=' + Quotedstr(Trim(Edit1.Text)) + ' Order By A.PId,A.SnoASC';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpcds := TClientDataSet.Create(nil);
  New(P);
  try
    tmpcds.Data := Data;
    with tmpcds do
    begin
      if FieldByName('R_visible').AsBoolean then
      begin

        P^.PID := FieldByName('PId').AsInteger;
        P^.NId := FieldByName('NId').AsInteger;
        P^.ProcId := FieldByName('ProcId').AsString;
        P^.ProcName := FieldByName('ProcName').AsString;
        P^.DllPath := FieldByName('DllPath').AsString;
        P^.Actions := FieldByName('Actions').AsString;
        P^.IsExe := FieldByName('IsExe').AsBoolean;
        P^.IsPop := FieldByName('IsPop').AsBoolean;
        if RightStr(P^.DllPath, 1) <> '\' then
          P^.DllPath := P^.DllPath + '\';
        P^.R_visible := FieldByName('R_visible').AsBoolean;
        P^.R_new := FieldByName('R_new').AsBoolean;
        P^.R_edit := FieldByName('R_edit').AsBoolean;
        P^.R_delete := FieldByName('R_delete').AsBoolean;
        P^.R_copy := FieldByName('R_copy').AsBoolean;
        P^.R_garbage := FieldByName('R_garbage').AsBoolean;
        P^.R_conf := FieldByName('R_conf').AsBoolean;
        P^.R_check := FieldByName('R_check').AsBoolean;
        P^.R_query := FieldByName('R_query').AsBoolean;
        P^.R_print := FieldByName('R_print').AsBoolean;
        P^.R_export := FieldByName('R_export').AsBoolean;
        P^.R_rptDesign := FieldByName('R_rptDesign').AsBoolean;
      end;
    end;
  finally
    tmpcds.free;
  end;

  if P^.IsPop then
  begin
    ShowForm_old(P);
    Exit;
  end;

  if Length(P^.DllPath) = 0 then
    Exit;

  if P^.IsExe then
  begin
    WinExec(PAnsiChar(P^.DllPath + P^.ProcId + '.exe ' + g_UInfo^.BU + ' ' + g_UInfo^.UserId + ' ' + g_PW), SW_SHOWNORMAL);
    Exit;
  end;

  if CheckForm(P^.ProcId, P^.ProcName) then
    Exit;

  DllHandle := LoadLibrary(PChar(P^.DllPath + P^.ProcId + '.dll'));
  if DllHandle <> 0 then
  begin
    if P^.Actions = '1' then
    begin
      @DllFunc_new := GetProcAddress(DllHandle, 'ShowDllForm');
      if @DllFunc_new <> nil then
        DllFunc_new(Application.Handle, Self.Handle, DllHandle, g_UInfo, P, g_ConnData, SB, PB, @RefrshList)
      else
        FreeLibrary(DllHandle);
    end
    else
    begin
      @DllFunc := GetProcAddress(DllHandle, 'ShowDllForm');
      if @DllFunc <> nil then
        DllFunc(Application.Handle, Self.Handle, DllHandle, g_UInfo, P, SB, PB, @RefrshList)
      else
        FreeLibrary(DllHandle);
    end;
  end;
end;

procedure TFrmMain.imgspClick(Sender: TObject);
begin
  inherited;
  if TV.Width = 0 then
    TV.Width := TV.Tag
  else
  begin
    TV.Tag := TV.Width;
    TV.Width := 0;
  end;
  SetSplitter;
end;

end.

