//
// Created by kaikai.
// 2021/4/19 ¤U¤È 15:17:15
//

unit unServerMethods;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap, Data.DBXJSON,
Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB, Data.SqlExpr,
Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect, System.Variants;

type
  TServerMethodsClient = class(TDSAdminClient)
  private
    FLoginCommand: TDBXCommand;
    FLogOutCommand: TDBXCommand;
    FQueryBySQLCommand: TDBXCommand;
    FQueryOneCRCommand: TDBXCommand;
    FQueryExistsCommand: TDBXCommand;
    FPostBySQLCommand: TDBXCommand;
    FPostByDeltaCommand: TDBXCommand;
    FCheckLockProcCommand: TDBXCommand;
    FLockProcCommand: TDBXCommand;
    FUnLockProcCommand: TDBXCommand;
    FGetMPSEmptyOZCommand: TDBXCommand;
    FGetBuCommand: TDBXCommand;
    FCOCEmailCommand: TDBXCommand;
    FOnLineCommand: TDBXCommand;
    FGetConnStrCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function Login(IP: string; ComputerName: string; Bu: string; UserId: string; Password: string; out ID: string; out Err: string): Boolean;
    function LogOut(ID: string; out Err: string): Boolean;
    function QueryBySQL(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out Data: OleVariant; out Err: string): Boolean;
    function QueryOneCR(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out Value: OleVariant; out Err: string): Boolean;
    function QueryExists(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out isExist: Boolean; out Err: string): Boolean;
    function PostBySQL(ID: string; ProcId: string; UserId: string; Dbtype: string; CommandText: string; out Err: string): Boolean;
    function PostByDelta(ID: string; ProcId: string; UserId: string; Dbtype: string; UpdateTable: string; Delta: OleVariant; out Err: string): Boolean;
    function CheckLockProc(ProcId: string; UserId: string; out IsLock: Boolean; out Err: string): Boolean;
    function LockProc(ProcId: string; UserId: string; out Err: string): Boolean;
    function UnLockProc(ProcId: string; UserId: string; out Err: string): Boolean;
    function GetMPSEmptyOZ(Jitem: string; Filter: string; out OZ: string; out Err: string): Boolean;
    function GetBu(Dbtype: string; out Data: OleVariant; out Err: string): Boolean;
    function COCEmail(Dbtype: string; out Err: string): Boolean;
    function OnLine(ID: string; UserId: string; UserName: string; Depart: string; IP: string; ComputerName: string; out Err: string): Boolean;
    function GetConnStr(out ConnStr: string; out Err: string): Boolean;
  end;

implementation

function TServerMethodsClient.Login(IP: string; ComputerName: string; Bu: string; UserId: string; Password: string; out ID: string; out Err: string): Boolean;
begin
  if FLoginCommand = nil then
  begin
    FLoginCommand := FDBXConnection.CreateCommand;
    FLoginCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FLoginCommand.Text := 'TServerMethods.Login';
    try
      FLoginCommand.Prepare;
    except
      on e:exception do
      begin
        ID:='';
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FLoginCommand.Parameters[0].Value.SetWideString(IP);
  FLoginCommand.Parameters[1].Value.SetWideString(ComputerName);
  FLoginCommand.Parameters[2].Value.SetWideString(Bu);
  FLoginCommand.Parameters[3].Value.SetWideString(UserId);
  FLoginCommand.Parameters[4].Value.SetWideString(Password);
  try
    FLoginCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      ID:='';
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  ID := FLoginCommand.Parameters[5].Value.GetWideString;
  Err := FLoginCommand.Parameters[6].Value.GetWideString;
  Result := FLoginCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.LogOut(ID: string; out Err: string): Boolean;
begin
  if FLogOutCommand = nil then
  begin
    FLogOutCommand := FDBXConnection.CreateCommand;
    FLogOutCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FLogOutCommand.Text := 'TServerMethods.LogOut';
    try
      FLogOutCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FLogOutCommand.Parameters[0].Value.SetWideString(ID);
  try
    FLogOutCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FLogOutCommand.Parameters[1].Value.GetWideString;
  Result := FLogOutCommand.Parameters[2].Value.GetBoolean;
end;

function TServerMethodsClient.QueryBySQL(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out Data: OleVariant; out Err: string): Boolean;
begin
  if FQueryBySQLCommand = nil then
  begin
    FQueryBySQLCommand := FDBXConnection.CreateCommand;
    FQueryBySQLCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FQueryBySQLCommand.Text := 'TServerMethods.QueryBySQL';
    try
      FQueryBySQLCommand.Prepare;
    except
      on e:exception do
      begin
        Data:=null;
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FQueryBySQLCommand.Parameters[0].Value.SetWideString(ID);
  FQueryBySQLCommand.Parameters[1].Value.SetWideString(ProcId);
  FQueryBySQLCommand.Parameters[2].Value.SetWideString(UserId);
  FQueryBySQLCommand.Parameters[3].Value.SetWideString(Dbtype);
  FQueryBySQLCommand.Parameters[4].Value.SetWideString(SelectSQL);
  try
    FQueryBySQLCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Data:=null;
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Data := FQueryBySQLCommand.Parameters[5].Value.AsVariant;
  Err := FQueryBySQLCommand.Parameters[6].Value.GetWideString;
  Result := FQueryBySQLCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.QueryOneCR(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out Value: OleVariant; out Err: string): Boolean;
begin
  if FQueryOneCRCommand = nil then
  begin
    FQueryOneCRCommand := FDBXConnection.CreateCommand;
    FQueryOneCRCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FQueryOneCRCommand.Text := 'TServerMethods.QueryOneCR';
    try
      FQueryOneCRCommand.Prepare;
    except
      on e:exception do
      begin
        Value:=null;
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FQueryOneCRCommand.Parameters[0].Value.SetWideString(ID);
  FQueryOneCRCommand.Parameters[1].Value.SetWideString(ProcId);
  FQueryOneCRCommand.Parameters[2].Value.SetWideString(UserId);
  FQueryOneCRCommand.Parameters[3].Value.SetWideString(Dbtype);
  FQueryOneCRCommand.Parameters[4].Value.SetWideString(SelectSQL);
  try
    FQueryOneCRCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Value:=null;
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Value := FQueryOneCRCommand.Parameters[5].Value.AsVariant;
  Err := FQueryOneCRCommand.Parameters[6].Value.GetWideString;
  Result := FQueryOneCRCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.QueryExists(ID: string; ProcId: string; UserId: string; Dbtype: string; SelectSQL: string; out isExist: Boolean; out Err: string): Boolean;
begin
  if FQueryExistsCommand = nil then
  begin
    FQueryExistsCommand := FDBXConnection.CreateCommand;
    FQueryExistsCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FQueryExistsCommand.Text := 'TServerMethods.QueryExists';
    try
      FQueryExistsCommand.Prepare;
    except
      on e:exception do
      begin
        isExist:=False;
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FQueryExistsCommand.Parameters[0].Value.SetWideString(ID);
  FQueryExistsCommand.Parameters[1].Value.SetWideString(ProcId);
  FQueryExistsCommand.Parameters[2].Value.SetWideString(UserId);
  FQueryExistsCommand.Parameters[3].Value.SetWideString(Dbtype);
  FQueryExistsCommand.Parameters[4].Value.SetWideString(SelectSQL);
  try
    FQueryExistsCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      isExist:=False;
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  isExist := FQueryExistsCommand.Parameters[5].Value.GetBoolean;
  Err := FQueryExistsCommand.Parameters[6].Value.GetWideString;
  Result := FQueryExistsCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.PostBySQL(ID: string; ProcId: string; UserId: string; Dbtype: string; CommandText: string; out Err: string): Boolean;
begin
  if FPostBySQLCommand = nil then
  begin
    FPostBySQLCommand := FDBXConnection.CreateCommand;
    FPostBySQLCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FPostBySQLCommand.Text := 'TServerMethods.PostBySQL';
    try
      FPostBySQLCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FPostBySQLCommand.Parameters[0].Value.SetWideString(ID);
  FPostBySQLCommand.Parameters[1].Value.SetWideString(ProcId);
  FPostBySQLCommand.Parameters[2].Value.SetWideString(UserId);
  FPostBySQLCommand.Parameters[3].Value.SetWideString(Dbtype);
  FPostBySQLCommand.Parameters[4].Value.SetWideString(CommandText);
  try
    FPostBySQLCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FPostBySQLCommand.Parameters[5].Value.GetWideString;
  Result := FPostBySQLCommand.Parameters[6].Value.GetBoolean;
end;

function TServerMethodsClient.PostByDelta(ID: string; ProcId: string; UserId: string; Dbtype: string; UpdateTable: string; Delta: OleVariant; out Err: string): Boolean;
begin
  if FPostByDeltaCommand = nil then
  begin
    FPostByDeltaCommand := FDBXConnection.CreateCommand;
    FPostByDeltaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FPostByDeltaCommand.Text := 'TServerMethods.PostByDelta';
    try
      FPostByDeltaCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FPostByDeltaCommand.Parameters[0].Value.SetWideString(ID);
  FPostByDeltaCommand.Parameters[1].Value.SetWideString(ProcId);
  FPostByDeltaCommand.Parameters[2].Value.SetWideString(UserId);
  FPostByDeltaCommand.Parameters[3].Value.SetWideString(Dbtype);
  FPostByDeltaCommand.Parameters[4].Value.SetWideString(UpdateTable);
  FPostByDeltaCommand.Parameters[5].Value.AsVariant := Delta;
  try
    FPostByDeltaCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FPostByDeltaCommand.Parameters[6].Value.GetWideString;
  Result := FPostByDeltaCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.CheckLockProc(ProcId: string; UserId: string; out IsLock: Boolean; out Err: string): Boolean;
begin
  if FCheckLockProcCommand = nil then
  begin
    FCheckLockProcCommand := FDBXConnection.CreateCommand;
    FCheckLockProcCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCheckLockProcCommand.Text := 'TServerMethods.CheckLockProc';
    try
      FCheckLockProcCommand.Prepare;
    except
      on e:exception do
      begin
        IsLock:=False;
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FCheckLockProcCommand.Parameters[0].Value.SetWideString(ProcId);
  FCheckLockProcCommand.Parameters[1].Value.SetWideString(UserId);
  try
    FCheckLockProcCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      IsLock:=False;
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  IsLock := FCheckLockProcCommand.Parameters[2].Value.GetBoolean;
  Err := FCheckLockProcCommand.Parameters[3].Value.GetWideString;
  Result := FCheckLockProcCommand.Parameters[4].Value.GetBoolean;
end;

function TServerMethodsClient.LockProc(ProcId: string; UserId: string; out Err: string): Boolean;
begin
  if FLockProcCommand = nil then
  begin
    FLockProcCommand := FDBXConnection.CreateCommand;
    FLockProcCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FLockProcCommand.Text := 'TServerMethods.LockProc';
    try
      FLockProcCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FLockProcCommand.Parameters[0].Value.SetWideString(ProcId);
  FLockProcCommand.Parameters[1].Value.SetWideString(UserId);
  try
    FLockProcCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FLockProcCommand.Parameters[2].Value.GetWideString;
  Result := FLockProcCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethodsClient.UnLockProc(ProcId: string; UserId: string; out Err: string): Boolean;
begin
  if FUnLockProcCommand = nil then
  begin
    FUnLockProcCommand := FDBXConnection.CreateCommand;
    FUnLockProcCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FUnLockProcCommand.Text := 'TServerMethods.UnLockProc';
    try
      FUnLockProcCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FUnLockProcCommand.Parameters[0].Value.SetWideString(ProcId);
  FUnLockProcCommand.Parameters[1].Value.SetWideString(UserId);
  try
    FUnLockProcCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FUnLockProcCommand.Parameters[2].Value.GetWideString;
  Result := FUnLockProcCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethodsClient.GetMPSEmptyOZ(Jitem: string; Filter: string; out OZ: string; out Err: string): Boolean;
begin
  if FGetMPSEmptyOZCommand = nil then
  begin
    FGetMPSEmptyOZCommand := FDBXConnection.CreateCommand;
    FGetMPSEmptyOZCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetMPSEmptyOZCommand.Text := 'TServerMethods.GetMPSEmptyOZ';
    try
      FGetMPSEmptyOZCommand.Prepare;
    except
      on e:exception do
      begin
        OZ:='';
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FGetMPSEmptyOZCommand.Parameters[0].Value.SetWideString(Jitem);
  FGetMPSEmptyOZCommand.Parameters[1].Value.SetWideString(Filter);
  try
    FGetMPSEmptyOZCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      OZ:='';
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  OZ := FGetMPSEmptyOZCommand.Parameters[2].Value.GetWideString;
  Err := FGetMPSEmptyOZCommand.Parameters[3].Value.GetWideString;
  Result := FGetMPSEmptyOZCommand.Parameters[4].Value.GetBoolean;
end;

function TServerMethodsClient.GetBu(Dbtype: string; out Data: OleVariant; out Err: string): Boolean;
begin
  if FGetBuCommand = nil then
  begin
    FGetBuCommand := FDBXConnection.CreateCommand;
    FGetBuCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetBuCommand.Text := 'TServerMethods.GetBu';
    try
      FGetBuCommand.Prepare;
    except
      on e:exception do
      begin
        Data:=null;
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FGetBuCommand.Parameters[0].Value.SetWideString(Dbtype);
  try
    FGetBuCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Data:=null;
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Data := FGetBuCommand.Parameters[1].Value.AsVariant;
  Err := FGetBuCommand.Parameters[2].Value.GetWideString;
  Result := FGetBuCommand.Parameters[3].Value.GetBoolean;
end;

function TServerMethodsClient.COCEmail(Dbtype: string; out Err: string): Boolean;
begin
  if FCOCEmailCommand = nil then
  begin
    FCOCEmailCommand := FDBXConnection.CreateCommand;
    FCOCEmailCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FCOCEmailCommand.Text := 'TServerMethods.COCEmail';
    try
      FCOCEmailCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FCOCEmailCommand.Parameters[0].Value.SetWideString(Dbtype);
  try
    FCOCEmailCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FCOCEmailCommand.Parameters[1].Value.GetWideString;
  Result := FCOCEmailCommand.Parameters[2].Value.GetBoolean;
end;

function TServerMethodsClient.OnLine(ID: string; UserId: string; UserName: string; Depart: string; IP: string; ComputerName: string; out Err: string): Boolean;
begin
  if FOnLineCommand = nil then
  begin
    FOnLineCommand := FDBXConnection.CreateCommand;
    FOnLineCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FOnLineCommand.Text := 'TServerMethods.OnLine';
    try
      FOnLineCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FOnLineCommand.Parameters[0].Value.SetWideString(ID);
  FOnLineCommand.Parameters[1].Value.SetWideString(UserId);
  FOnLineCommand.Parameters[2].Value.SetWideString(UserName);
  FOnLineCommand.Parameters[3].Value.SetWideString(Depart);
  FOnLineCommand.Parameters[4].Value.SetWideString(IP);
  FOnLineCommand.Parameters[5].Value.SetWideString(ComputerName);
  try
    FOnLineCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  Err := FOnLineCommand.Parameters[6].Value.GetWideString;
  Result := FOnLineCommand.Parameters[7].Value.GetBoolean;
end;

function TServerMethodsClient.GetConnStr(out ConnStr: string; out Err: string): Boolean;
begin
  if FGetConnStrCommand = nil then
  begin
    FGetConnStrCommand := FDBXConnection.CreateCommand;
    FGetConnStrCommand.CommandType := TDBXCommandTypes.DSServerMethod;
    FGetConnStrCommand.Text := 'TServerMethods.GetConnStr';
    try
      FGetConnStrCommand.Prepare;
    except
      on e:exception do
      begin
        Err:=e.Message;
        Result:=False;
        Exit;
      end;
    end;
  end;
  FGetConnStrCommand.Parameters[0].Value.SetWideString(ConnStr);
  FGetConnStrCommand.Parameters[1].Value.SetWideString(Err);
  try
    FGetConnStrCommand.ExecuteUpdate;
  except
    on e:exception do
    begin
      Err:=e.Message;
      Result:=False;
      Exit;
    end;
  end;
  ConnStr := FGetConnStrCommand.Parameters[0].Value.GetWideString;
  Err := FGetConnStrCommand.Parameters[1].Value.GetWideString;
  Result := FGetConnStrCommand.Parameters[2].Value.GetBoolean;
end;


constructor TServerMethodsClient.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;


constructor TServerMethodsClient.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;


destructor TServerMethodsClient.Destroy;
begin
  FLoginCommand.DisposeOf;
  FLogOutCommand.DisposeOf;
  FQueryBySQLCommand.DisposeOf;
  FQueryOneCRCommand.DisposeOf;
  FQueryExistsCommand.DisposeOf;
  FPostBySQLCommand.DisposeOf;
  FPostByDeltaCommand.DisposeOf;
  FCheckLockProcCommand.DisposeOf;
  FLockProcCommand.DisposeOf;
  FUnLockProcCommand.DisposeOf;
  FGetMPSEmptyOZCommand.DisposeOf;
  FGetBuCommand.DisposeOf;
  FCOCEmailCommand.DisposeOf;
  FOnLineCommand.DisposeOf;
  FGetConnStrCommand.DisposeOf;
  inherited;
end;

end.
