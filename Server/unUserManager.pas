unit unUserManager;

interface

uses
  Windows, SysUtils, Classes, SyncObjs, ExtCtrls, ActiveX, unGlobal;

type
  TUserManager = class(TObject)
  private
    FCriticalSection:TCriticalSection;
    FList:TList;
    FTimer:TTimer;
    FHtmlList:TStrings;
    procedure LoadData;
    procedure SaveData;
    procedure RefreshData;
    procedure RefreshUI;
    procedure MyTimer(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function Login(IP, ComputerName, UserId: WideString): WideString;
    procedure Logout(ID: WideString);
    function CheckLoginByID(ID: WideString; out Err:WideString): Boolean;
  end;

implementation

uses unMain;

{ TUserManager }

constructor TUserManager.Create;
var
  headtxt:string;
begin
  headtxt:=g_SysPath+'head.txt';

  FCriticalSection:=TCriticalSection.Create;
  FList:=TList.Create;
  FHtmlList:=TStringList.Create;
  if FileExists(headtxt) then
    FHtmlList.LoadFromFile(headtxt);
    
  FTimer:=TTimer.Create(nil);
  FTimer.Interval:=1000;
  FTimer.OnTimer:=MyTimer;
  FTimer.Enabled:=True;

  LoadData;
end;

destructor TUserManager.Destroy;
var
  i:Integer;
begin
  FreeAndNil(FCriticalSection);
  FreeAndNil(FHtmlList);
  FTimer.Enabled:=False;
  FreeAndNil(FTimer);
  
  for i:=0 to FList.Count - 1 do
    Dispose(FList[i]);
  FreeAndNil(FList);

  inherited Destroy;
end;

procedure TUserManager.LoadData;
const strValue='@1(2)3@';
var
  i:Integer;
  tmpStr:string;
  tmpList1,tmpList2:TStrings;
  P:PUser;
begin
  tmpStr:=g_SysPath+'log.txt';
  if not FileExists(tmpStr) then
     Exit;

  FCriticalSection.Enter;
  tmpList1:=TStringList.Create;
  tmpList2:=TStringList.Create;
  try
    tmpList2.Delimiter:=g_SPKey;
    tmpList1.LoadFromFile(tmpStr);
    for i:=0 to tmpList1.Count -1 do
    begin
      tmpStr:=Trim(tmpList1.Strings[i]);
      if Length(tmpStr)>0 then
      begin
        tmpList2.DelimitedText:=StringReplace(tmpStr,' ',strValue,[rfReplaceAll]);
        New(P);
        if tmpList2.Count>0 then
           P^.ClientId:=tmpList2.Strings[0];
        if tmpList2.Count>1 then
           P^.UserId:=tmpList2.Strings[1];
        if tmpList2.Count>2 then
           P^.IPAddress:=tmpList2.Strings[2];
        if tmpList2.Count>3 then
           P^.Host:=StringReplace(tmpList2.Strings[3],strValue,' ',[rfReplaceAll]);
        if tmpList2.Count>4 then
        begin
          tmpStr:=StringReplace(tmpList2.Strings[4],strValue,' ',[rfReplaceAll]);
          if DateSeparator='/' then
             tmpStr:=StringReplace(tmpStr,'-',DateSeparator,[rfReplaceAll])
          else
             tmpStr:=StringReplace(tmpStr,'/',DateSeparator,[rfReplaceAll]);
          try
            P^.LoginTime:=StrToDateTime(tmpStr);
          except
            P^.LoginTime:=Now;
          end;
        end;
        P^.IsLogout:=False;
        FList.Add(P);
      end;
    end;
  finally
    FreeAndNil(tmpList1);
    FreeAndNil(tmpList2);
    FCriticalSection.Leave;
  end;
end;

procedure TUserManager.SaveData;
var
  i:Integer;
  tmpStr:string;
  txt:TextFile;
  P:PUser;
begin
  if FList.Count=0 then
     Exit;
  
  FCriticalSection.Enter;
  try
    tmpStr:=g_SysPath+'log.txt';
    if FileExists(tmpStr) then
       DeleteFile(tmpstr);
    AssignFile(txt, tmpStr);
    if not FileExists(tmpStr) then
       Rewrite(txt);
    for i:=0 to FList.Count-1 do
    begin
      P:=PUser(FList.Items[i]);
      if not P.IsLogout then
      begin
        tmpStr:=P^.ClientId+g_SPKey+
                P^.UserId+g_SPKey+
                P^.IPAddress+g_SPKey+
                P^.Host+g_SPKey+FormatDateTime(g_LongTimeSP, P^.LoginTime)+#13#10;
        Append(txt);
        Write(txt, tmpStr);
      end;
    end;
    CloseFile(txt);
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TUserManager.RefreshData;
var
  i:Integer;
  P:PUser;
begin
  FCriticalSection.Enter;
  try
    for i:=FList.Count-1 downto 0 do
    begin
      P:=PUser(FList.Items[i]);
      if P^.IsLogout or (P^.LoginTime<=Date-5) then
      begin
        Dispose(P);
        FList.Delete(i);
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TUserManager.RefreshUI;
var
  i,tmpCount,tmpOnline:Integer;
  tmpHtml:string;
  SS:TStringStream;
  P:PUser;
begin
  tmpCount:=0;
  tmpOnline:=0;
  tmpHtml:='';

  FCriticalSection.Enter;
  try
    for i:=0 to FList.Count-1 do
    begin
      P:=PUser(FList.Items[i]);

      Inc(tmpCount);
      tmpHtml:=tmpHtml+'<tr>'
                      +'<td>'+P^.ClientId+'</td>'
                      +'<td>'+P^.UserId+'</td>'
                      +'<td>'+P^.IPAddress+'</td>'
                      +'<td>'+P^.Host+'</td>'
                      +'<td>'+FormatDateTime(g_LongTimeSP, P^.LoginTime)+'</td>';
      if P^.IsLogout then
         tmpHtml:=tmpHtml+'<td>'+FormatDateTime(g_LongTimeSP, P^.LogoutTime)+'</td>'
      else begin
         Inc(tmpOnline);
         tmpHtml:=tmpHtml+'<td></td>'
      end;

      tmpHtml:=tmpHtml+'</tr>';
    end;

    tmpHtml:=FHtmlList.Text+tmpHtml+'</tbody></table></body></html>';
    SS:=TStringStream.Create(tmpHtml);
    try
      SS.Position:=0;
      if FrmMain.SB.Tag=0 then
      begin
        FrmMain.WB.Navigate('about:blank');
        FrmMain.SB.Tag:=1;
      end;
      (FrmMain.WB.Document as IPersistStreamInit).Load(TStreamadapter.Create(SS));
      FrmMain.SB.Panels[0].Text:='count:'+IntToStr(tmpCount)+' | online:'+IntToStr(tmpOnline);
    finally
      FreeAndNil(SS);
    end;

  finally
    FCriticalSection.Leave;
  end;
end;

function TUserManager.Login(IP, ComputerName, UserId: WideString): WideString;
var
  P:PUser;
begin
  FCriticalSection.Enter;
  try
    New(P);
    P^.ClientId:=FormatDateTime('YYYYMMDDHHNNSSZZZ', Now);
    P^.UserId:=UserId;
    P^.IPAddress:=IP;
    P^.Host:=ComputerName;
    P^.LoginTime:=Now;
    P^.IsLogout:=False;
    FList.Add(P);

    g_RefreshUser:=uUI;
    Result:=P^.ClientId;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TUserManager.Logout(ID: WideString);
var
  i:Integer;
  P:PUser;
begin
  FCriticalSection.Enter;
  try
    for i:=0 to FList.Count-1 do
    begin
      P:=PUser(FList.Items[i]);
      if P^.ClientId=ID then
      begin
        P^.LogoutTime:=Now;
        P^.IsLogout:=True;
        Break;
      end;
    end;
    g_RefreshUser:=uUI;
  finally
    FCriticalSection.Leave;
  end;
end;

function TUserManager.CheckLoginByID(ID: WideString; out Err:WideString): Boolean;
var
  i:Integer;
  P:PUser;
begin
  if SameText(ID,'@') then
     Result:=True
  else begin
    Result:=False;

    FCriticalSection.Enter;
    try
      for i:=0 to FList.Count-1 do
      begin
        P:=PUser(FList.Items[i]);
        if (P^.ClientId=ID) and (not P^.IsLogout) then
        begin
          Result:=True;
          Break;
        end;
      end;

      if not Result then
         Err:='請重新登錄系統';
    finally
      FCriticalSection.Leave;
    end;
  end;
end;

procedure TUserManager.MyTimer;
begin
  FTimer.Enabled:=False;
  try
    if (g_RefreshUser=uDataUI) or (FormatDateTime('HH:NN:SS', Now)='04:30:02') then
       RefreshData;

    if g_IsSaveUser then
       SaveData;
    g_IsSaveUser:=False;

    if g_RefreshUser<>uNone then
       RefreshUI;
    g_RefreshUser:=uNone;

  finally
    FTimer.Enabled:=True;
  end;
end;

end.
