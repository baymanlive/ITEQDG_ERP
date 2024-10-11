unit unSvr;

interface

uses
  Windows, Classes, SysUtils, Forms, TypInfo, DB, ADODB, DBClient,
  Provider, Variants, Math;

type
  TSvr = Class
  public
    class function Login(const IP, ComputerName, Bu, UserId, Password: string;
      out ID: string; out Err: string): Boolean;
    class function LogOut(const ID: string; out Err: string): Boolean;
    class function GetBu(const Dbtype: string; out Data: OleVariant; out Err: string): Boolean;
    class function QueryBySQL(const ID, ProcId, UserId, Dbtype, SelectSQL: string;
      out Data: OleVariant; out Err: string): Boolean;
    class function QueryOneCR(const ID, ProcId, UserId, Dbtype, SelectSQL: string;
      out Value: OleVariant; out Err: string): Boolean;
    class function QueryExists(const ID, ProcId, UserId, Dbtype, SelectSQL: string;
      out isExist: Boolean; out Err: string): Boolean;
    class function PostBySQL(const ID, ProcId, UserId, Dbtype, CommandText: string;
      out Err: string): Boolean;
    class function PostByDelta(const ID, ProcId, UserId, Dbtype, UpdateTable: string;
      Delta: OleVariant; out Err: string): Boolean;
    class function CheckLockProc(const ProcId, UserId: string; out IsLock: Boolean;
      out Err: string): Boolean;
    class function LockProc(const ProcId, UserId: string; out Err: string): Boolean;
    class function UnLockProc(const ProcId, UserId: string; out Err: string): Boolean;
    class function GetMPSEmptyOZ(const Jitem, Filter: string;
      out OZ: string; out Err: string): Boolean;
    class function COCEmail(const Dbtype: string; out Err: string): Boolean;
    class function OnLine(const ID, UserId, UserName, Depart, IP, ComputerName: string;
      out Err: string): Boolean;
    class function GetConnStr(out ConnStr: string; out Err: string): Boolean;
  end;

implementation

  function LoginX(IP: PAnsiChar; ComputerName: PAnsiChar; Bu: PAnsiChar;
    UserId: PAnsiChar; Password: PAnsiChar; out ID: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'Login';

  function LogOutX(ID: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
    external 'Svr.dll' name 'LogOut';

  function GetBuX(Dbtype: PAnsiChar; out Data: OleVariant;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'GetBu';

  function QueryBySQLX(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
    Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out Data: OleVariant;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'QueryBySQL';

  function QueryOneCRX(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
    Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out Value: OleVariant;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'QueryOneCR';

  function QueryExistsX(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
    Dbtype: PAnsiChar; SelectSQL: PAnsiChar; out isExist: Boolean;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'QueryExists';

  function PostBySQLX(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
    Dbtype: PAnsiChar; CommandText: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'PostBySQL';

  function PostByDeltaX(ID: PAnsiChar; ProcId: PAnsiChar; UserId: PAnsiChar;
    Dbtype: PAnsiChar; UpdateTable: PAnsiChar; Delta: OleVariant;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'PostByDelta';

  function CheckLockProcX(ProcId: PAnsiChar; UserId: PAnsiChar; out IsLock: Boolean;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'CheckLockProc';

  function LockProcX(ProcId: PAnsiChar; UserId: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'LockProc';

  function UnLockProcX(ProcId: PAnsiChar; UserId: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'UnLockProc';

  function GetMPSEmptyOZX(Jitem: PAnsiChar; Filter: PAnsiChar; out OZ: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall;  external 'Svr.dll' name 'GetMPSEmptyOZ';

  function COCEmailX(Dbtype: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
    external 'Svr.dll' name 'COCEmail';

  function OnLineX(ID: PAnsiChar; UserId: PAnsiChar; UserName: PAnsiChar;
    Depart: PAnsiChar; IP: PAnsiChar; ComputerName: PAnsiChar;
    out Err: PAnsiChar): Boolean; stdcall; external 'Svr.dll' name 'OnLine';

  function GetConnStrX(out ConnStr: PAnsiChar; out Err: PAnsiChar): Boolean; stdcall;
    external 'Svr.dll' name 'GetConnStr';

{ TSvr }

class function TSvr.CheckLockProc(const ProcId, UserId: string;
  out IsLock: Boolean; out Err: string): Boolean;
var
  tmpProcId,tmpUserId,tmpErr:PAnsiChar;
begin
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  Result:=CheckLockProcX(tmpProcId,tmpUserId,isLock,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.COCEmail(const Dbtype: string; out Err: string): Boolean;
var
  tmpDBtype,tmpErr:PAnsiChar;
begin
  tmpDBtype:=PAnsiChar(AnsiString(Dbtype));
  Result:=COCEmailX(tmpDBtype,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.GetBu(const Dbtype: string; out Data: OleVariant;
  out Err: string): Boolean;
var
  tmpDBtype,tmpErr:PAnsiChar;
begin
  tmpDBtype:=PAnsiChar(AnsiString(Dbtype));
  Result:=GetBuX(tmpDBtype,Data,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.GetMPSEmptyOZ(const Jitem, Filter: string; out OZ,
  Err: string): Boolean;
var
  tmpJitem,tmpFilter,tmpOZ,tmpErr:PAnsiChar;
begin
  tmpJitem:=PAnsiChar(AnsiString(Jitem));
  tmpFilter:=PAnsiChar(AnsiString(Filter));
  Result:=GetMPSEmptyOZX(tmpJitem,tmpFilter,tmpOZ,tmpErr);
  OZ:=string(tmpOZ);
  Err:=string(tmpErr);
end;

class function TSvr.LockProc(const ProcId, UserId: string;
  out Err: string): Boolean;
var
  tmpProcId,tmpUserId,tmpErr:PAnsiChar;
begin
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  Result:=LockProcX(tmpProcId,tmpUserId,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.Login(const IP, ComputerName, Bu, UserId, Password: string;
  out ID, Err: string): Boolean;
var
  tmpIP,tmpComputerName,tmpBu,tmpUserId,tmpPassword,tmpID,tmpErr:PAnsiChar;
begin
  tmpIP:=PAnsiChar(AnsiString(IP));
  tmpComputerName:=PAnsiChar(AnsiString(ComputerName));
  tmpBu:=PAnsiChar(AnsiString(Bu));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpPassword:=PAnsiChar(AnsiString(Password));
  Result:=LoginX(tmpIP,tmpComputerName,tmpBu,tmpUserId,tmpPassword,tmpID,tmpErr);
  ID:=string(tmpID);
  Err:=string(tmpErr);
end;

class function TSvr.LogOut(const ID: string; out Err: string): Boolean;
var
  tmpID,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  Result:=LogOutX(tmpID,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.OnLine(const ID, UserId, UserName, Depart, IP,
  ComputerName: string; out Err: string): Boolean;
var
  tmpID,tmpUserId,tmpUserName,tmpDepart,tmpIP,tmpComputerName,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpUserName:=PAnsiChar(AnsiString(UserName));
  tmpDepart:=PAnsiChar(AnsiString(Depart));
  tmpIP:=PAnsiChar(AnsiString(IP));
  tmpComputerName:=PAnsiChar(AnsiString(ComputerName));
  Result:=OnLineX(tmpID,tmpUserId,tmpUserName,tmpDepart,tmpIP,tmpComputerName,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.PostByDelta(const ID, ProcId, UserId, Dbtype,
  UpdateTable: string; Delta: OleVariant; out Err: string): Boolean;
var
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpUpdateTable,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpDbtype:=PAnsiChar(AnsiString(Dbtype));
  tmpUpdateTable:=PAnsiChar(AnsiString(UpdateTable));
  Result:=PostByDeltaX(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpUpdateTable,Delta,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.PostBySQL(const ID, ProcId, UserId, Dbtype,
  CommandText: string; out Err: string): Boolean;
var
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpCommandText,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpDbtype:=PAnsiChar(AnsiString(Dbtype));
  tmpCommandText:=PAnsiChar(AnsiString(CommandText));
  Result:=PostBySQLX(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpCommandText,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.QueryBySQL(const ID, ProcId, UserId, Dbtype,
  SelectSQL: string; out Data: OleVariant; out Err: string): Boolean;
var
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpDbtype:=PAnsiChar(AnsiString(Dbtype));
  tmpSelectSQL:=PAnsiChar(AnsiString(SelectSQL));
  Result:=QueryBySQLX(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,Data,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.QueryExists(const ID, ProcId, UserId, Dbtype,
  SelectSQL: string; out isExist: Boolean; out Err: string): Boolean;
var
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpDbtype:=PAnsiChar(AnsiString(Dbtype));
  tmpSelectSQL:=PAnsiChar(AnsiString(SelectSQL));
  Result:=QueryExistsX(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,isExist,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.QueryOneCR(const ID, ProcId, UserId, Dbtype,
  SelectSQL: string; out Value: OleVariant; out Err: string): Boolean;
var
  tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,tmpErr:PAnsiChar;
begin
  tmpID:=PAnsiChar(AnsiString(ID));
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  tmpDbtype:=PAnsiChar(AnsiString(Dbtype));
  tmpSelectSQL:=PAnsiChar(AnsiString(SelectSQL));
  Result:=QueryOneCRX(tmpID,tmpProcId,tmpUserId,tmpDbtype,tmpSelectSQL,Value,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.UnLockProc(const ProcId, UserId: string;
  out Err: string): Boolean;
var
  tmpProcId,tmpUserId,tmpErr:PAnsiChar;
begin
  tmpProcId:=PAnsiChar(AnsiString(ProcId));
  tmpUserId:=PAnsiChar(AnsiString(UserId));
  Result:=UnLockProcX(tmpProcId,tmpUserId,tmpErr);
  Err:=string(tmpErr);
end;

class function TSvr.GetConnStr(out ConnStr: string; out Err: string): Boolean;
var
  tmpConnStr,tmpErr:PAnsiChar;
begin
  Result:=GetConnStrX(tmpConnStr,tmpErr);
  ConnStr:=string(tmpConnStr);
  Err:=string(tmpErr);
end;

end.
