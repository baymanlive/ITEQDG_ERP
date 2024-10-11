//
// Created by kaikai.
// 2021/4/19 ¤U¤È 15:17:15
//

library Svr;

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
  WinAPI.Windows,
  System.SysUtils,
  System.Classes,
  Data.SqlExpr,
  MidasLib,
  IPPeerClient,
  System.Variants,
  unServerMethods in 'unServerMethods.pas',
  unConnObj in 'unConnObj.pas';

 var
  l_ConnObj:TConnObj;
  OldExitProc:pointer;

const l_strSocketErr='socket';
const l_strConnectErr='connection';

{$R *.res}

function Login(IP: PAnsiChar; ComputerName: PAnsiChar; Bu: PAnsiChar;
  UserId: PAnsiChar; Password: PAnsiChar; out ID: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpIP,tmpComputerName,tmpBu,tmpUserId,tmpPassword,tmpID,tmpErr:string;
begin
  Result:=False;
  ID:='';
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpIP:=string(IP);
  tmpComputerName:=string(ComputerName);
  tmpBu:=string(Bu);
  tmpUserId:=string(UserId);
  tmpPassword:=string(Password);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.Login(tmpIP,tmpComputerName,tmpBu,tmpUserId,tmpPassword,tmpID,tmpErr);
    ID:=PAnsiChar(AnsiString(tmpID));
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function LogOut(ID: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.LogOut(tmpID,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function QueryBySQL(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
  Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out Data: OleVariant;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:string;
begin
  Result:=False;
  Data:=null;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  tmpDbtype:=string(Dbtype);
  tmpSelectSQL:=string(SelectSQL);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.QueryBySQL(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,Data,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function QueryOneCR(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
  Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out Value: OleVariant;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:string;
begin
  Result:=False;
  Value:=null;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  tmpDbtype:=string(Dbtype);
  tmpSelectSQL:=string(SelectSQL);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.QueryOneCR(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,Value,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function QueryExists(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
  Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out isExist: Boolean;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:string;
begin
  Result:=False;
  isExist:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  tmpDbtype:=string(Dbtype);
  tmpSelectSQL:=string(SelectSQL);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.QueryExists(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,isExist,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function PostBySQL(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
  Dbtype: PAnsiChar; CommandText: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpCommandText,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  tmpDbtype:=string(Dbtype);
  tmpCommandText:=string(CommandText);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.PostBySQL(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpCommandText,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function PostByDelta(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
  Dbtype: PAnsiChar; UpdateTable: PAnsiChar; Delta: OleVariant;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpUpdateTable,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  tmpDbtype:=string(Dbtype);
  tmpUpdateTable:=string(UpdateTable);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.PostByDelta(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpUpdateTable,Delta,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function CheckLockProc(ProcId: PAnsiChar; UserId: PAnsiChar; out IsLock: Boolean;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpProcId,tmpUserId,tmpErr:string;
begin
  Result:=False;
  IsLock:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.CheckLockProc(tmpProcId,tmpUserId,IsLock,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function LockProc(ProcId: PAnsiChar; UserId: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpProcId,tmpUserId,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.LockProc(tmpProcId,tmpUserId,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function UnLockProc(ProcId: PAnsiChar; UserId: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpProcId,tmpUserId,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpProcId:=string(ProcId);
  tmpUserId:=string(UserId);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.UnLockProc(tmpProcId,tmpUserId,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function GetMPSEmptyOZ(Jitem: PAnsiChar; Filter: PAnsiChar; out OZ: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpJitem,tmpFilter,tmpOZ,tmpErr:string;
begin
  Result:=False;
  OZ:='';
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpJitem:=string(Jitem);
  tmpFilter:=string(Filter);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.GetMPSEmptyOZ(tmpJitem,tmpFilter,tmpOZ,tmpErr);
    OZ:=PAnsiChar(AnsiString(tmpOZ));
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function GetBu(Dbtype: PAnsiChar; out Data: OleVariant; out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpDbtype,tmpErr:string;
begin
  Result:=False;
  Data:=null;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpDbtype:=string(Dbtype);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.GetBu(tmpDbtype,Data,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function COCEmail(Dbtype: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpDbtype,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpDbtype:=string(Dbtype);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.COCEmail(tmpDbtype,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function OnLine(ID: PAnsiChar; UserId: PAnsiChar; UserName: PAnsiChar;
  Depart: PAnsiChar; IP: PAnsiChar; ComputerName: PAnsiChar;
  out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpID,tmpUserId,tmpUserName,tmpDepart,tmpIP,tmpComputerName,tmpErr:string;
begin
  Result:=False;
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  tmpID:=string(ID);
  tmpUserId:=string(UserId);
  tmpUserName:=string(UserName);
  tmpDepart:=string(Depart);
  tmpIP:=string(IP);
  tmpComputerName:=string(ComputerName);
  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.OnLine(tmpID,tmpUserId,tmpUserName,tmpDepart,tmpIP,tmpComputerName,tmpErr);
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

function GetConnStr(out ConnStr: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
var
  conn:TSQLConnection;
  dm:TServerMethodsClient;
  tmpConnStr,tmpErr:string;
begin
  Result:=False;
  ConnStr:='';
  Err:='';

  conn:=l_ConnObj.GetSQLConnection(tmpErr);
  if (conn=nil) or (Length(tmpErr)>0) then
  begin
    Err:=PAnsiChar(AnsiString(tmpErr));
    Exit;
  end;

  dm:=TServerMethodsClient.Create(conn.DBXConnection);
  try
    Result:=dm.GetConnStr(tmpConnStr,tmpErr);
    ConnStr:=PAnsiChar(AnsiString(tmpConnStr));
    Err:=PAnsiChar(AnsiString(tmpErr));
    if (not Result) and (Length(tmpErr)>0) then
    begin
      tmpErr:=LowerCase(tmpErr);
      if (Pos(l_strSocketErr, tmpErr)>0) or (Pos(l_strConnectErr, tmpErr)>0) then
         conn.Connected:=False;
    end;
  finally
    FreeAndNil(dm);
  end;
end;

procedure InitDLL(Reasion:Integer);
begin
  if Reasion=DLL_PROCESS_ATTACH then
     l_ConnObj:=TConnObj.Create;
end;

procedure ExitDLL(Reasion:Integer);
begin
  if Reasion=DLL_PROCESS_DETACH then
  begin
    FreeAndNil(l_ConnObj);
    ExitProc:=OldExitProc;
  end;
end;

exports
  Login,
  LogOut,
  QueryBySQL,
  QueryOneCR,
  QueryExists,
  PostBySQL,
  PostByDelta,
  CheckLockProc,
  LockProc,
  UnLockProc,
  GetMPSEmptyOZ,
  GetBu,
  COCEmail,
  OnLine,
  GetConnStr;

begin
  OldExitProc:=ExitProc;
  ExitProc:=@ExitDLL;
  DLLProc:=@InitDLL;
  InitDLL(DLL_PROCESS_ATTACH);
end.
