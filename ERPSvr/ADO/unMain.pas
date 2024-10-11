unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.ExtCtrls, Vcl.Menus, Vcl.Controls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.Graphics, Vcl.Forms, Winapi.ShellAPI, System.IniFiles,
  System.StrUtils, System.DateUtils, System.Math, Midaslib, unGlobal, unFuns;

const
  l_WM_BARICON = WM_USER + 1399;

type
  TFrmMain = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    PopupMenu1: TPopupMenu;
    n_show: TMenuItem;
    n_exit: TMenuItem;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    Timer2: TTimer;
    Lv: TListView;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure n_showClick(Sender: TObject);
    procedure n_exitClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    l_datefmt: string;
    l_runexe, l_isRefresh: Boolean;
    l_cocList: TStrings;
    l_arrExeMail: array of TExeMail;
    procedure DoNotifyIconData(xType: string);
    procedure LoadCOCEmail;
    procedure LoadExeEMail;
    { Private declarations }
  public
    procedure WMSysCommand(var Msg: TMessage); message WM_SYSCOMMAND;
    procedure WMBarIcon(var Msg: TMessage); message l_WM_BARICON;
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.WMSysCommand(var Msg: TMessage);
begin
  if Msg.WParam = SC_ICON then
    Self.Visible := False
  else
    DefWindowProc(Self.Handle, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure TFrmMain.WMBarIcon(var Msg: TMessage);
var
  p: TPoint;
begin
  if Msg.LParam = WM_LBUTTONDBLCLK then
    Self.Visible := True
  else if Msg.LParam = WM_RButtonUp then
  begin
    GetCursorPos(p);
    PopupMenu1.Popup(p.X, p.Y);
  end;
end;

procedure TFrmMain.DoNotifyIconData(xType: string);
var
  lpData: PNotifyIconData;
begin
  lpData := new(PNotifyIconData);
  lpData.cbSize := 88;
  lpData.Wnd := Self.Handle;
  lpData.hIcon := Application.Icon.Handle;
  lpData.uCallbackMessage := l_WM_BARICON;
  lpData.uID := 0;
  lpData.szTip := 'ERPSvr';
  lpData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  if xType = 'add' then
    Shell_NotifyIcon(NIM_ADD, lpData)
  else
    Shell_NotifyIcon(NIM_DELETE, lpData);
  Dispose(lpData);
end;

procedure TFrmMain.LoadCOCEmail;
var
  i: Integer;
begin
  l_cocList.Clear;
  if not FileExists(g_SysPath + 'cocemail.txt') then
    Exit;

  try
    l_cocList.LoadFromFile(g_SysPath + 'cocemail.txt');
    i := l_cocList.IndexOf('test');
    if i <> -1 then
      l_cocList.Delete(i);
    LogInfo('LoadCOCEmail:' + l_cocList.DelimitedText);
  except
    on e: exception do
      LogInfo('LoadCOCEmail:' + e.Message);
  end;
end;

procedure TFrmMain.LoadExeEMail;
var
  i: Integer;
  tmpIni: TIniFile;
  tmpList: TStrings;
begin
  SetLength(l_arrExeMail, 0);
  if not FileExists(g_SysPath + 'MailConfig.ini') then
    Exit;

  tmpList := TStringList.Create;
  tmpIni := TIniFile.Create(g_SysPath + 'MailConfig.ini');
  try
    tmpIni.ReadSections(tmpList);
    SetLength(l_arrExeMail, tmpList.Count);
    for i := 0 to tmpList.Count - 1 do
    begin
      l_arrExeMail[i].Exe := LowerCase(tmpList.Strings[i]);
      l_arrExeMail[i].Time := tmpIni.ReadString(tmpList.Strings[i], 'Time', '');
    end;

    LogInfo('LoadExeEMail');
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpIni);
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
const
  strConfig = 'SvrConfig.ini';
var
  tmpStr: string;
  tmpRunExe: Integer;
  tmpIni: TIniFile;
begin
  if not FileExists(g_SysPath + strConfig) then
  begin
    tmpStr := Format(g_strConfigNotExists, [strConfig]);
    Application.MessageBox(PChar(tmpStr), g_strHint, 16);
    Halt;
  end;

  tmpIni := TIniFile.Create(g_SysPath + strConfig);
  try
    g_Port := tmpIni.ReadInteger('SvrInfo', 'Port', 8901);
    g_DefDBType := tmpIni.ReadString('SvrInfo', 'DBType', 'MSSQL');
    tmpRunExe := tmpIni.ReadInteger('SvrInfo', 'RunExe', 0);
    g_OnLine := tmpIni.ReadInteger('SvrInfo', 'OnLine', 3);
  finally
    FreeAndNil(tmpIni);
  end;

  if FormatSettings.DateSeparator = '/' then
    l_datefmt := 'YYYY/MM/DD HH:NN:SS'
  else
    l_datefmt := 'YYYY-MM-DD HH:NN:SS';

  Self.Width := 980;
  Self.Height := 560;
  Self.Caption := g_strAppTitle;
  Label1.Caption := g_strClientCount + '0';
  Label2.Caption := g_strDBCount + '0';
  Label2.Left := Self.ClientWidth - Label2.Width - 10;
  N1.Caption := g_strMenu;
  n_show.Caption := g_strMenuShow;
  n_exit.Caption := g_strMenuExit;
  Lv.DoubleBuffered := True;
  Lv.Columns[0].Caption := g_strCId;
  Lv.Columns[1].Caption := g_strUId;
  Lv.Columns[2].Caption := g_strUName;
  Lv.Columns[3].Caption := g_strDepartment;
  Lv.Columns[4].Caption := g_strIP;
  Lv.Columns[5].Caption := g_strComputerName;
  Lv.Columns[6].Caption := g_strLoginTime;
  Lv.Columns[7].Caption := g_strActiveTime;
  Lv.Columns[8].Caption := g_strOnLine;

  l_runexe := tmpRunExe = 1;
  l_cocList := TStringList.Create;
  LoadCOCEmail;
  LoadExeEMail;
  DoNotifyIconData('add');
  Timer1.Enabled := True;
  Timer2.Enabled := True;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Application.MessageBox(g_strExit, g_strHint, 33) = IDCancel then
  begin
    Action := caNone;
    Exit;
  end;

  Timer1.Enabled := False;
  FreeAndNil(l_cocList);
  SetLength(l_arrExeMail, 0);
  l_arrExeMail := nil;
  DoNotifyIconData('del');
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  LoadCOCEmail;
end;

procedure TFrmMain.N3Click(Sender: TObject);
begin
  LoadExeEMail;
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  if Lv.Selected <> nil then
    Lv.Selected.Delete;
end;

procedure TFrmMain.n_showClick(Sender: TObject);
begin
  Self.Visible := True;
end;

procedure TFrmMain.n_exitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  i: integer;
  tmpStr: string;
begin
  tmpStr := FormatDateTime('HH:NN:SS', Now);
  l_isRefresh := RightStr(tmpStr, 2) = '01';  //每分鐘更新一次用戶online

  if l_runexe then
  begin
    if FileExists(g_SysPath + g_strCocEmail) then
      for i := 0 to l_cocList.Count - 1 do
        if SameText(l_cocList.Strings[i], tmpStr) then
          WinExec(PAnsiChar(AnsiString(g_strCocEmail + ' coc iteqdg ' + DateToStr(Date) + ' ' + tmpStr)), SW_SHOWNORMAL);

    for i := Low(l_arrExeMail) to High(l_arrExeMail) do
      if (Length(l_arrExeMail[i].Time) > 0) and (Pos(tmpStr, l_arrExeMail[i].Time) > 0) and FileExists(g_SysPath + l_arrExeMail[i].Exe + '.exe') then
        WinExec(PAnsiChar(AnsiString(l_arrExeMail[i].Exe + '.exe' + ' ' + l_arrExeMail[i].Exe)), SW_SHOWNORMAL);
  end;

  if Pos(tmpStr, '23:44:55,12:54:55') > 0 then
  begin
    Timer1.Enabled := False;
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
    Timer1.Enabled := True;
  end;
end;

procedure TFrmMain.Timer2Timer(Sender: TObject);
var
  isBool: Boolean;
  i, j, m: Integer;
  tmpStr: string;
  tmpDate: TDateTime;
begin
  Timer2.Enabled := False;
  Lv.Items.BeginUpdate;
  try
    tmpDate := Now;
    tmpStr := FormatDateTime(l_datefmt, tmpDate);

    for i := Low(g_ArrUser) to High(g_ArrUser) do
    begin
      if g_ArrUser[i].Flag = 1 then
      begin
        isBool := False;

        for j := 0 to Lv.Items.Count - 1 do
          if Lv.Items[j].Caption = g_ArrUser[i].ID then
          begin
            isBool := True;
            Lv.Items[j].SubItems[6] := tmpStr;
            Break;
          end;

        if not isBool then
          if Length(g_ArrUser[i].ID) > 0 then
          begin
            with Lv.Items.Add do
            begin
              Caption := g_ArrUser[i].ID;
              SubItems.Add(g_ArrUser[i].UserId);
              SubItems.Add(g_ArrUser[i].UserName);
              SubItems.Add(g_ArrUser[i].Depart);
              SubItems.Add(g_ArrUser[i].IP);
              SubItems.Add(g_ArrUser[i].ComputerName);
            //SubItems.Add(tmpStr);
            //重連時候取原日期時間
              SubItems.Add(Copy(g_ArrUser[i].ID, 1, 4) + FormatSettings.DateSeparator + Copy(g_ArrUser[i].ID, 5, 2) + FormatSettings.DateSeparator + Copy(g_ArrUser[i].ID, 7, 2) + ' ' + Copy(g_ArrUser[i].ID, 9, 2) + ':' + Copy(g_ArrUser[i].ID, 11, 2) + ':' + Copy(g_ArrUser[i].ID, 13, 2));
              SubItems.Add(tmpStr);
              SubItems.Add('0');
            end;
          end;

        g_ArrUser[i].Flag := 0;
      end
      else if g_ArrUser[i].Flag = 2 then
      begin
        for j := Lv.Items.Count - 1 downto 0 do
          if Lv.Items[j].Caption = g_ArrUser[i].ID then
          begin
            Lv.Items[j].Delete;
            Break;
          end;

        g_ArrUser[i].Flag := 0;
      end;
    end;

    if l_isRefresh then
    begin
      for j := Lv.Items.Count - 1 downto 0 do
      begin
        m := MinutesBetween(StrToDateTime(Lv.Items[j].SubItems[6]), tmpDate);
        if m > g_OnLine then
          Lv.Items[j].Delete
        else
        begin
          m := MinutesBetween(StrToDateTime(Lv.Items[j].SubItems[5]), tmpDate);
          Lv.Items[j].SubItems[7] := FloatToStr(RoundTo(m / 60, -2));
        end;
      end;
    end;

  finally
    Lv.Items.EndUpdate;
    l_isRefresh := False;
    Label1.Caption := g_strClientCount + IntToStr(Lv.Items.Count);
    Timer2.Enabled := True;
  end;
end;

end.

