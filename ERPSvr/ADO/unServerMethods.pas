unit unServerMethods;

interface

uses
  System.SysUtils, System.Classes, System.Json,
  DataSnap.DSProviderDataModuleAdapter, System.Variants, Datasnap.DSServer,
  Datasnap.DSAuth, Datasnap.DBClient, Winapi.Windows, System.StrUtils, Vcl.Forms,
  Data.Win.ADODB, Data.DB, Datasnap.Provider, unGlobal, unFuns, unPoolManager;

type
  TServerMethods = class(TDSServerModule)
    FDsp: TDataSetProvider;
    FADOQuery: TADOQuery;
    FADOCommand: TADOCommand;
    procedure FDspUpdateError(Sender: TObject; DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    l_Error: string;
    { Private declarations }
  public
    { Public declarations }
    function Login(IP, ComputerName, Bu, UserId, Password: string; out ID, Err: string): Boolean;
    function LogOut(ID: string; out Err: string): Boolean;
    function QueryBySQL(ID, ProcId, UserId, Dbtype, SelectSQL: string; out Data: OleVariant; out Err: string): Boolean;
    function QueryOneCR(ID, ProcId, UserId, Dbtype, SelectSQL: string; out Value: OleVariant; out Err: string): Boolean;
    function QueryExists(ID, ProcId, UserId, Dbtype, SelectSQL: string; out isExist: Boolean; out Err: string): Boolean;
    function PostBySQL(ID, ProcId, UserId, Dbtype, CommandText: string; out Err: string): Boolean;
    function PostByDelta(ID, ProcId, UserId, Dbtype, UpdateTable: string; Delta: OleVariant; out Err: string): Boolean;
    function CheckLockProc(ProcId, UserId: string; out IsLock: Boolean; out Err: string): Boolean;
    function LockProc(ProcId, UserId: string; out Err: string): Boolean;
    function UnLockProc(ProcId, UserId: string; out Err: string): Boolean;
    function GetMPSEmptyOZ(Jitem, Filter: string; out OZ, Err: string): Boolean;
    function GetBu(Dbtype: string; out Data: OleVariant; out Err: string): Boolean;
    function COCEmail(Dbtype: string; out Err: string): Boolean;
    function OnLine(ID, UserId, UserName, Depart, IP, ComputerName: string; out Err: string): Boolean;
    function GetConnStr(out ConnStr: string; out Err: string): Boolean;
  end;

var
  l_PoolManager: TPoolManager;

implementation

{$R *.dfm}

function TServerMethods.Login(IP, ComputerName, Bu, UserId, Password: string; out ID, Err: string): Boolean;
var
  i: Integer;
  tmpConn: TADOConnection;
begin
  ID := '';
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(g_DefDBType, Err);
  if tmpConn = nil then
  begin
    LogInfo('Login(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      EnableBCD := True;
      Connection := tmpConn;
      SQL.Clear;
      SQL.Add('Select UserId,UserName,Depart,Password From Sys_User');
      SQL.Add('Where IsNull(Not_Use,0)=0 And Bu=:Bu And UserId=:UserId');
      Parameters.ParamByName('Bu').Value := Bu;
      Parameters.ParamByName('UserId').Value := UserId;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo(UserId + ',Login(Open):' + Err);
          Exit;
        end;
      end;

      if IsEmpty or (FieldByName('Password').AsString <> Password) then
      begin
        Err := g_strPWErr;
        Exit;
      end;
    end;

    ID := FormatDateTime('YYYYMMDDHHNNSSZZZ', Now);
    Err := '';
    Result := True;
    for i := Low(g_ArrUser) to High(g_ArrUser) do
      if g_ArrUser[i].Flag = 0 then
      begin
        g_ArrUser[i].ID := ID;
        g_ArrUser[i].UserId := FADOQuery.FieldByName('UserId').AsString;
        g_ArrUser[i].UserName := FADOQuery.FieldByName('UserName').AsString;
        g_ArrUser[i].Depart := FADOQuery.FieldByName('Depart').AsString;
        g_ArrUser[i].IP := IP;
        g_ArrUser[i].ComputerName := ComputerName;
        g_ArrUser[i].Flag := 1;
        Break;
      end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, False);
  end;
end;

function TServerMethods.LogOut(ID: string; out Err: string): Boolean;
var
  i: Integer;
begin
  Err := '';
  Result := True;

  if Length(ID) > 0 then
    for i := Low(g_ArrUser) to High(g_ArrUser) do
      if g_ArrUser[i].Flag = 0 then
      begin
        g_ArrUser[i].ID := ID;
        g_ArrUser[i].Flag := 2;
        Break;
      end;
end;

function TServerMethods.QueryBySQL(ID, ProcId, UserId, Dbtype, SelectSQL: string; out Data: OleVariant; out Err: string): Boolean;
var
  tmpConn: TADOConnection;
begin
  Data := null;
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo(ProcId + ',' + UserId + ',QueryBySQL(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE', UpperCase(Dbtype)) > 0 then
        EnableBCD := False
      else
        EnableBCD := True;
      Connection := tmpConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo(ProcId + ',' + UserId + ',QueryBySQL(Open):' + Err + #13#10 + SelectSQL);
          Exit;
        end;
      end;
    end;

    Data := FDsp.Data;
    Err := '';
    Result := True;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, Pos('ORA-', Err) > 0);
  end;
end;

function TServerMethods.QueryOneCR(ID, ProcId, UserId, Dbtype, SelectSQL: string; out Value: OleVariant; out Err: string): Boolean;
var
  tmpConn: TADOConnection;
begin
  Value := null;
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo(ProcId + ',' + UserId + ',QueryOneCR(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE', UpperCase(Dbtype)) > 0 then
        EnableBCD := False
      else
        EnableBCD := True;
      Connection := tmpConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo(ProcId + ',' + UserId + ',QueryOneCR(Open):' + Err + #13#10 + SelectSQL);
          Exit;
        end;
      end;

      Value := Fields[0].Value;
      Err := '';
      Result := True;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, Pos('ORA-', Err) > 0);
  end;
end;

function TServerMethods.QueryExists(ID, ProcId, UserId, Dbtype, SelectSQL: string; out isExist: Boolean; out Err: string): Boolean;
var
  tmpConn: TADOConnection;
begin
  isExist := False;
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo(ProcId + ',' + UserId + ',QueryExists(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE', UpperCase(Dbtype)) > 0 then
        EnableBCD := False
      else
        EnableBCD := True;
      Connection := tmpConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo(ProcId + ',' + UserId + ',QueryExists(Open):' + Err + #13#10 + SelectSQL);
          Exit;
        end;
      end;

      isExist := not IsEmpty;
      Err := '';
      Result := True;
    end;

  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, Pos('ORA-', Err) > 0);
  end;
end;

function TServerMethods.PostBySQL(ID, ProcId, UserId, Dbtype, CommandText: string; out Err: string): Boolean;
var
  tmpConn: TADOConnection;
begin
  Err := '';
  Result := False;

  //修改資料應該檢查是否已登錄

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo(ProcId + ',' + UserId + ',PostBySQL(LockConn):' + Err);
    Exit;
  end;

  try
    FADOCommand.Connection := tmpConn;

    if FADOCommand.Connection.InTransaction then
    begin
      Err := g_strInTransaction;
      LogInfo(ProcId + ',' + UserId + ',PostBySQL(InTransaction):' + Err + #13#10 + CommandText);
      Exit;
    end;

    FADOCommand.CommandText := CommandText;
    FADOCommand.Connection.BeginTrans;
    try
      FADOCommand.Execute;
      FADOCommand.Connection.CommitTrans;
      Err := '';
      Result := True;
    except
      on E: Exception do
      begin
        Result := False;
        Err := E.Message;
        LogInfo(ProcId + ',' + UserId + ',PostBySQL(Execute):' + Err + #13#10 + CommandText);
        if FADOCommand.Connection.InTransaction then
          FADOCommand.Connection.RollbackTrans;
      end;
    end;
  finally
    FADOCommand.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, Pos('ORA-', Err) > 0);
  end;
end;

function TServerMethods.PostByDelta(ID, ProcId, UserId, Dbtype, UpdateTable: string; Delta: OleVariant; out Err: string): Boolean;
const
  sql = 'Select * From %s Where 1=2';
var
  ErrCount: Integer;
  tmpSQL: string;
  tmpConn: TADOConnection;
begin
  Err := '';
  Result := False;

  //修改資料應該檢查是否已登錄

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo(ProcId + ',' + UserId + ',PostByDelta(LockConn):' + Err);
    Exit;
  end;

  try
    tmpSQL := Format(sql, [UpdateTable]);
    FADOQuery.Close;
    if Pos('ORACLE', UpperCase(Dbtype)) > 0 then
      FADOQuery.EnableBCD := False
    else
      FADOQuery.EnableBCD := True;
    FADOQuery.Connection := tmpConn;
    FDsp.Options := FDsp.Options - [poAllowCommandText];
    FDsp.ResolveToDataSet := False;
    FADOQuery.SQL.Text := tmpSQL;
    try
      FADOQuery.Open;
    except
      on E: Exception do
      begin
        Err := E.Message;
        LogInfo(ProcId + ',' + UserId + ',PostByDelta(Open):' + Err + #13#10 + tmpSQL);
        Exit;
      end;
    end;

    if FADOQuery.Connection.InTransaction then
    begin
      Err := g_strInTransaction;
      LogInfo(ProcId + ',' + UserId + ',PostByDelta(InTransaction):' + Err + #13#10 + tmpSQL);
      Exit;
    end;

    l_Error := '';
    FADOQuery.Connection.BeginTrans;
    FDsp.ApplyUpdates(Delta, 0, ErrCount);
    Result := ErrCount = 0;
    if Result then
    begin
      try
        Err := '';
        FADOQuery.Connection.CommitTrans;
      except
        on E: Exception do
        begin
          Result := False;
          Err := E.Message;
          LogInfo(ProcId + ',' + UserId + ',PostByDelta(CommitTrans):' + Err + #13#10 + tmpSQL);
          if FADOQuery.Connection.InTransaction then
            FADOQuery.Connection.RollbackTrans;
        end;
      end;
    end
    else
    begin
      Err := l_Error;
      LogInfo(ProcId + ',' + UserId + ',PostByDelta(ApplyUpdates):' + Err + #13#10 + tmpSQL);
      FADOQuery.Connection.RollbackTrans;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, Pos('ORA-', Err) > 0);
  end;
end;

function TServerMethods.CheckLockProc(ProcId, UserId: string; out IsLock: Boolean; out Err: string): Boolean;
var
  SelectSQL: string;
begin
  IsLock := False;
  Err := '';
  SelectSQL := 'Select 1 From Sys_Lock Where ProcId=' + Quotedstr(ProcId);
  Result := QueryExists('@', ProcId, UserId, g_DefDBType, SelectSQL, IsLock, Err);
end;

function TServerMethods.LockProc(ProcId, UserId: string; out Err: string): Boolean;
var
  UpdateSQL: string;
begin
  Err := '';
  Result := UnLockProc(ProcId, UserId, Err);
  if Result then
  begin
    UpdateSQL := 'Insert Into Sys_Lock(ProcId, Iuser, Idate)' + ' Values(' + Quotedstr(ProcId) + ',' + Quotedstr(UserId) + ',getdate())';
    Result := PostBySQL('@', ProcId, UserId, g_DefDBType, UpdateSQL, Err);
  end;
end;

function TServerMethods.UnLockProc(ProcId, UserId: string; out Err: string): Boolean;
var
  UpdateSQL: string;
begin
  Err := '';
  UpdateSQL := 'Delete From Sys_Lock Where ProcId=' + Quotedstr(ProcId);
  Result := PostBySQL('@', ProcId, UserId, g_DefDBType, UpdateSQL, Err);
end;

function TServerMethods.GetMPSEmptyOZ(Jitem, Filter: string; out OZ, Err: string): Boolean;
var
  tmpStr: string;
  tmpConn: TADOConnection;
begin
  OZ := '';
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(g_DefDBType, Err);
  if tmpConn = nil then
  begin
    LogInfo('GetMPSEmptyOZ(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      EnableBCD := True;
      Connection := tmpConn;
      SQL.Text := 'Select oz From mps010 Where Jitem=' + Jitem + Filter + ' And isnull(emptyflag,0)=0 And isnull(errorflag,0)=0' + ' Group By oz Order By oz';
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('GetMPSEmptyOZ(Open):' + Err);
          Exit;
        end;
      end;

      while not Eof do
      begin
        tmpStr := Fields[0].AsString;
        if tmpStr <> '' then
        begin
          tmpStr := Copy(tmpStr, 1, 1);
          if pos(tmpStr, OZ) = 0 then
            OZ := OZ + tmpStr;
          if Length(OZ) = 2 then
            Break;
        end;
        Next;
      end;
    end;

    Err := '';
    Result := True;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, False);
  end;
end;

function TServerMethods.GetBu(Dbtype: string; out Data: OleVariant; out Err: string): Boolean;
var
  tmpConn: TADOConnection;
begin
  Data := null;
  Err := '';
  Result := False;

  tmpConn := l_PoolManager.LockConn(Dbtype, Err);
  if tmpConn = nil then
  begin
    LogInfo('GetBu(LockConn):' + Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      EnableBCD := True;
      Connection := tmpConn;
      SQL.Text := 'Select * From Sys_Bu';
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('GetBu(Open):' + Err);
          Exit;
        end;
      end;
    end;

    Data := FDsp.Data;
    Err := '';
    Result := True;
  finally
    FADOQuery.Close;
    FADOQuery.Connection := nil;
    l_PoolManager.UnlockConn(tmpConn.Tag, False);
  end;
end;

function TServerMethods.COCEmail(Dbtype: string; out Err: string): Boolean;
begin
  Err := '';
  Result := FileExists(g_SysPath + g_strCocEmail);
  if Result then
    WinExec(PAnsiChar(AnsiString(g_strCocEmail + ' coc ' + string(Dbtype) + ' ' + DateToStr(Date) + ' test')), SW_SHOWNORMAL);
end;

function TServerMethods.OnLine(ID, UserId, UserName, Depart, IP, ComputerName: string; out Err: string): Boolean;
var
  i: Integer;
begin
  if Length(ID) > 0 then
    for i := Low(g_ArrUser) to High(g_ArrUser) do
      if g_ArrUser[i].Flag = 0 then
      begin
        g_ArrUser[i].ID := ID;
        g_ArrUser[i].UserId := UserId;
        g_ArrUser[i].UserName := UserName;
        g_ArrUser[i].Depart := Depart;
        g_ArrUser[i].IP := IP;
        g_ArrUser[i].ComputerName := ComputerName;
        g_ArrUser[i].Flag := 1;
        Break;
      end;
  Err := '';
  Result := True;
end;

procedure TServerMethods.FDspUpdateError(Sender: TObject; DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind; var Response: TResolverResponse);
begin
  l_Error := E.Message;
end;

function TServerMethods.GetConnStr(out ConnStr: string; out Err: string): Boolean;
begin
  Result := l_PoolManager.GetConnStr(ConnStr, Err);
end;

initialization
  g_SysPath := ExtractFilePath(Application.ExeName);
  l_PoolManager := TPoolManager.Create;


finalization
  FreeAndNil(l_PoolManager);

end.

