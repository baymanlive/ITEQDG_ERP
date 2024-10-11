unit unLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Buttons, unFrmBaseEmpty, DBClient, iniFiles,
  WinSock, DB, DBCtrlsEh, ExtCtrls, ImgList, DateUtils, ADODB, unDAL, unSvr;

type
  TFrmLogin = class(TFrmBaseEmpty)
    id: TLabel;
    pw: TLabel;
    logo: TLabel;
    bu: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    BtnOk: TBitBtn;
    BtnQuit: TBitBtn;
    Cbb: TDBComboBoxEh;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnQuitClick(Sender: TObject);
  private
    procedure FreeRes;
    procedure ADOConnExecuteComplete(Connection:TADOConnection;
      RecordsAffected:Integer; const Error:Error;
      var EventStatus:TEventStatus; const Command:_Command;
      const Recordset:_Recordset);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses unGlobal, unCommon, unPW;

{$R *.dfm}

//本機電腦名
function GetLocalComputerName:string;
var
  cpName:PChar;
  cpSize:DWord;
  cpBool:Boolean;
begin
  cpSize:=255;
  getmem(cpName,cpSize);
  cpBool:=GetComputerName(cpName,cpSize);
  if cpBool then
    Result:=StrPas(cpName)
  else
    Result:='';
  FreeMem(cpName,cpSize);
end;

//取本機IP
function GetLocalIPByName(cpName:PChar):string;
var
  WSAData:TWSAData;
  HostEnt:PHostEnt;
begin
  Result:='0.0.0.0';
  if length(StrPas(cpName))=0 then
     Exit;
  WSAStartup(2, WSAData);
  HostEnt:=GetHostByName(cpName);
  if HostEnt <> nil then
  with HostEnt^ do
    Result:= Format('%d.%d.%d.%d',[Byte(h_addr^[0]), Byte(h_addr^[1]),Byte(h_addr^[2]), Byte(h_addr^[3])]);
  WSACleanup;
end;

//系統臨時路徑
function GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := StrPas(Buffer);
end;

procedure TFrmLogin.FreeRes;
var
  i:Integer;
begin
  CDS1.Active:=False;
  CDS2.Active:=False;
  Dispose(g_UInfo);
  Dispose(g_MInfo);

  for i:=Low(g_ConnData) to High(g_ConnData) do
  begin
    g_ConnData[i].ADOConn.Connected:=False;
    FreeAndNil(g_ConnData[i].ADOConn);
  end;
  SetLength(g_ConnData, 0);

  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
end;

procedure TFrmLogin.ADOConnExecuteComplete(
  Connection:TADOConnection; RecordsAffected:Integer; const Error:Error;
  var EventStatus:TEventStatus; const Command:_Command;
  const Recordset:_Recordset);
begin
  if Error.Number=-2147467259 then
     Connection.Connected:=False;
end;

procedure TFrmLogin.FormCreate(Sender: TObject);
const fini='Config.ini';
var
  i,pos1:Integer;
  tmpSQL,tmpConnStr,tmpErr:string;
  Data:OleVariant;
  ini:TIniFile;
  tmpList:TStrings;
begin

  New(g_UInfo);
  New(g_MInfo);
  g_UInfo^.isCN:=GetSystemDefaultLangID=$804;

  inherited;

  g_UInfo^.SysPath:=ExtractFilePath(Application.ExeName);
  g_UInfo^.TempPath:=GetTempDir;
  g_UInfo^.LocalComputerName:=GetLocalComputerName;
  g_UInfo^.LocalIP:=GetLocalIPByName(PChar(g_UInfo^.LocalComputerName));
  g_UInfo^.UserId:='sys';
  g_MInfo^.ProcId:='sys';
  g_MInfo^.ProcName:='sys';

  if not FileExists(g_UInfo^.SysPath+fini) then
  begin
    ShowMsg('Not Found Config.ini',48);
    FreeRes;
    Halt;
  end;

  //取配置文件
  ini:=TIniFile.Create(g_UInfo^.SysPath+fini);
  try
    g_UInfo^.Host:=ini.ReadString('RDMInfo','SocketIP','');
    g_UInfo^.ServerName:=ini.ReadString('RDMInfo','SocketName','');
    g_UInfo^.Port:=StrToIntDef(ini.ReadString('RDMInfo','Port',''),0);
    g_UInfo^.DBType:=ini.ReadString('RDMInfo','DBType','');
    g_UInfo^.IsWideString:=ini.ReadString('RDMInfo','WideString','0')='1';
  finally
    FreeAndNil(ini);
  end;

  if not TSvr.GetConnStr(tmpConnStr, tmpErr) then
  begin
    ShowSvrMsg(tmpErr);
    FreeRes;
    Halt;
  end;

  tmpList:=TStringList.Create;
  try
    pos1:=Pos('|',tmpConnStr);
    while pos1>0 do
    begin
      tmpList.Add(Copy(tmpConnStr,1,pos1-1));
      Delete(tmpConnStr,1,pos1);
      pos1:=Pos('|',tmpConnStr);
      if pos1=0 then
         tmpList.Add(tmpConnStr);
    end;

    i:=0;
    SetLength(g_ConnData, Round(tmpList.Count/2));
    while tmpList.Count>0 do
    begin
      g_ConnData[i].DBtype:=tmpList.Strings[0];
      g_ConnData[i].ADOConn:=TADOConnection.Create(Self);
      g_ConnData[i].ADOConn.OnExecuteComplete:=ADOConnExecuteComplete;
      g_ConnData[i].ADOConn.ConnectionString:=tmpList.Strings[1];
      g_ConnData[i].ADOConn.CommandTimeout:=300;
      g_ConnData[i].ADOConn.ConnectionTimeout:=10;
      g_ConnData[i].ADOConn.LoginPrompt:=False;
      Inc(i);
      tmpList.Delete(0);
      tmpList.Delete(0);
    end;
  finally
    FreeAndNil(tmpList);
  end;

  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);

  Data:=null;
  tmpSQL:='select bu,shortname,cname from sys_bu';
  if not QueryBySQL(tmpSQL, Data) then
  begin
    FreeRes;
    Halt;
  end;
  CDS1.Data:=Data;

  Cbb.Items.BeginUpdate;
  try
    while not CDS1.Eof do
    begin
      Cbb.Items.Add(CDS1.FieldByName('ShortName').AsString);
      CDS1.Next;
    end;
  finally
    Cbb.Items.EndUpdate;
  end;

  if Cbb.Items.Count>0 then
     Cbb.ItemIndex:=0;

  SetLabelCaption(Self, Self.Name);
//  if FileExists('id150515.txt') then
//  begin
//    tmpList:=TStringList.Create;
//    try
//      tmpList.LoadFromFile('id150515.txt');
//      Edit1.text:=tmpList[0];
//      Edit2.text:=tmpList[1];
//      Cbb.ItemIndex:=StrToInt( tmpList[2]);
//    finally
//      tmpList.free;
//    end;
//  end;
end;

procedure TFrmLogin.BtnOkClick(Sender: TObject);
var
  tmpSQL,tmpID,tmpErr:string;
  Data:OleVariant;
  isChangePW:Boolean;
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    Edit1.SetFocus;
    ShowMsg('請輸入帳號!',48);
    Exit;
  end;

  if Cbb.ItemIndex=-1 then
  begin
    Edit1.SetFocus;
    ShowMsg('請選擇營運中心!',48);
    Exit;
  end;

  g_UInfo^.BU:='';
  g_UInfo^.UserId:=Edit1.Text;
  g_PW:=Edit2.Text;

  with CDS1 do
  begin
    First;
    while not Eof do
    begin
      if SameText(Cbb.Items[Cbb.ItemIndex], FieldByName('ShortName').AsString) then
      begin
        g_UInfo^.BU:=FieldByName('Bu').AsString;
        g_UInfo^.ShortName:=FieldByName('ShortName').AsString;
        g_UInfo^.Cname:=FieldByName('Cname').AsString;
        Break;
      end;
      Next;
    end;
  end;

  if Length(g_UInfo^.BU)=0 then
  begin
    Edit1.SetFocus;
    ShowMsg('請選擇營運中心!',48);
    Exit;
  end;

  //是否需要修改密碼
  if not MustChangePW(isChangePW) then
     Exit;
  if isChangePW then
  begin
    if not Assigned(FrmPW) then
       FrmPW:=TFrmPW.Create(Application);
    FrmPW.Edit1.Text:=g_PW;
    if FrmPW.ShowModal<>mrOK then
       Exit;
  end;

  tmpSQL:='select * from sys_user where bu='+Quotedstr(g_UInfo^.BU)
         +' and userid='+Quotedstr(g_UInfo^.UserId)
         +' and isnull(not_use,0)=0';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  CDS2.Data:=Data;
  with CDS2 do
  begin
    if IsEmpty or (FieldByName('password').AsString<>g_PW) then
    begin
      Edit2.SetFocus;
      ShowMsg('帳號或密碼錯誤', 48);
      Exit;
    end;

    g_UInfo^.UserId:=FieldByName('UserId').AsString;
    g_UInfo^.UserName:=FieldByName('UserName').AsString;
    g_UInfo^.Depart:=FieldByName('Depart').AsString;
    g_UInfo^.Room:=FieldByName('Room').AsString;
    g_UInfo^.Title:=FieldByName('Title').AsString;
    g_UInfo^.Wk_no:=FieldByName('Wk_no').AsString;
  end;
  
  if Length(g_UInfo^.Wk_no)=0 then
     g_UInfo^.Wk_no:=g_UInfo^.UserId;

  if not TSvr.Login(g_UInfo^.LocalIP, g_UInfo^.LocalComputerName, g_UInfo^.BU, g_UInfo^.UserId, g_PW, tmpID, tmpErr) then
  begin
    ShowMsg(tmpErr,48);
    Exit;
  end;
  g_UInfo^.ClientID:=tmpID;

  ModalResult:=mrOk;
end;

procedure TFrmLogin.BtnQuitClick(Sender: TObject);
begin
  FreeRes;
  ModalResult:=mrCancel;
end;

end.
