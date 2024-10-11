unit unMain;

interface

uses
  Windows, Messages, SysUtils, Forms, ExtCtrls, Menus, ComCtrls, Classes, Controls,
  OleCtrls, SHDocVw, ShellApi, IniFiles, unGlobal, unFuns, AppEvnts;

Const WM_MyICON = WM_USER + 1299;

type
  TFrmMain = class(TForm)
    WB: TWebBrowser;
    PopupMenu2: TPopupMenu;
    n_close: TMenuItem;
    SB: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N3: TMenuItem;
    Timer1: TTimer;
    N5: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ApplicationEvents1Exception(Sender: TObject; E: Exception);
  private
    l_Icon:TNotifyIconData;
    procedure WMMyICON(var Msg: TMessage); Message WM_MyICON;
    procedure HideForm(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.HideForm(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_Hide);
  Self.Hide;
end;

procedure TFrmMain.WMMyICON(var Msg: TMessage);
var
  p:TPoint;
begin
  Case Msg.LParam of
    WM_LBUTTONDBLCLK:
    begin
      if Self.Visible then
         Application.BringToFront
      else
      begin
        //ShowWindow(Application.Handle, SW_Show);
        Self.Show;              //Close use visible
        Application.Restore;
        Application.BringToFront;
      end;
    end;
    WM_RBUTTONUP:
    begin
      SetForegroundWindow(Self.Handle);
      GetCursorPos(p);
      PopupMenu2.Popup(p.x,p.y);
    end;
  end;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  H:Thandle;
begin
  H:=FindWindow(nil,'scktsrvr');
  if H=0 then
  if FileExists('scktsrvr.exe') then
     ShellExecute(Handle, 'open', 'scktsrvr.exe', nil, nil, SW_SHOW);

  //添加托盤圖標
  with l_Icon do
  begin
    cbSize:=SizeOf(TNotifyIconData);
    hIcon:=Application.Icon.Handle;
    uCallbackMessage:= WM_MyICON;
    uFlags:=NIF_ICON or NIF_MESSAGE or NIF_TIP;
    uID:=WM_MyICON;
    Wnd:=Self.Handle;
    strCopy(szTip, PChar(Application.Title));
  end;
  Shell_NotifyIcon(NIM_ADD, @l_Icon);

  Application.OnMinimize:=HideForm;

  g_RefreshUser:=uUI;
end;

procedure TFrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Self.Visible and (Application.MessageBox('Exit?', 'Message', 33)=IDCancel) then
     Action:=caNone;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @l_Icon);
end;

procedure TFrmMain.N4Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.N2Click(Sender: TObject);
begin
  if not Timer1.Enabled then
     Timer1.Enabled:=True;
  g_RefreshUser:=uDataUI;
  LogInfo('RefreshUser');
end;

procedure TFrmMain.N5Click(Sender: TObject);
begin
  g_IsSaveUser:=True;
  LogInfo('SaveUser');
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  tmpStr:string;
begin
  tmpStr:=FormatDateTime('HH:NN:SS', Now);

  //強制重整內存
  if Pos(tmpStr, '23:44:55,12:54:55')>0 then
  begin
    Timer1.Enabled:=False;
    SetProcessWorkingSetSize(GetCurrentProcess, $FFFFFFFF, $FFFFFFFF);
    Application.ProcessMessages;
    Timer1.Enabled:=True;
  end;
end;

procedure TFrmMain.ApplicationEvents1Exception(Sender: TObject;
  E: Exception);
begin
  LogInfo('ApplicationEvents:'+E.Message);
end;

end.
