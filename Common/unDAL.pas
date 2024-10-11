{*******************************************************}
{                                                       }
{                unDAL                                  }
{                Author: ...                            }
{                Create date: ...                       }
{                Description: 數據庫操作                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDAL;

interface

uses
  Windows, Classes, SysUtils, Forms, TypInfo, DB, ADODB, DBClient,
  Provider, Variants, Math;

type
  TDAL = Class
  private
    FDBtype:string;
    FError:string;
    FUserId:string;
    FADOStoredProc: TADOStoredProc;
    FADOCommand: TADOCommand;
    FADOQuery: TADOQuery;
    FDsp: TDataSetProvider;
    procedure FDspUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  protected
  public
    constructor Create(AUserId,ADBtype:string; ADOConn:TADOConnection);
    destructor Destroy; override;
    function QueryBySQL(ASQL:string; var RetData:OleVariant; var Err:string):Boolean;
    function QueryOneCR(ASQL:string; var RetData:OleVariant; var Err:string):Boolean;
    function QueryExists(ASQL:string; var isExist: Boolean; var Err:string):Boolean;
    function PostBySQL(ASQL:string; var Err:string):Boolean;
    function CDSPost(Delta:OleVariant; TableName:string; var Err:string):Boolean;
    function CheckLockProc(ProcId:string; var isLock: Boolean; var Err:string): Boolean;
    function LockProc(ProcId:string; var Err:string): Boolean;
    function UnLockProc(ProcId:string; var Err:string): Boolean;
    function GetMPSEmptyOZ(Jitem, Filter: string; var OZ,Err:string):Boolean;
  published
    property DBtype: string read FDBtype;
  end;

implementation

{TDAL}

constructor TDAL.Create(AUserId,ADBtype:string; ADOConn:TADOConnection);
begin
  FUserId:=AUserId;
  FDBtype:=ADBtype;

  FADOStoredProc:=TADOStoredProc.Create(nil);
  FADOCommand:=TADOCommand.Create(nil);
  FADOQuery:=TADOQuery.Create(nil);
  FDsp:=TDataSetProvider.Create(nil);

  FDsp.DataSet:=FADOQuery;
  FDsp.OnUpdateError:=FDspUpdateError;

  FADOStoredProc.Connection:=ADOConn;
  FADOCommand.Connection:=ADOConn;
  FADOQuery.Connection:=ADOConn;

  FADOStoredProc.CommandTimeout:=300;
  FADOCommand.CommandTimeout:=300;
  FADOQuery.CommandTimeout:=300;

  FADOCommand.ParamCheck:=False;
end;

destructor TDAL.Destroy;
begin
  FADOQuery.Close;
  FADOStoredProc.Connection:=nil;
  FADOCommand.Connection:=nil;
  FADOQuery.Connection:=nil;
  FreeAndNil(FADOStoredProc);
  FreeAndNil(FADOCommand);
  FreeAndNil(FADOQuery);
  FreeAndNil(FDsp);

  inherited Destroy;
end;

//sql查詢
function TDAL.QueryBySQL(ASQL:string; var RetData:OleVariant; var Err:string):Boolean;
begin
  RetData:=null;
  Err:='';
  Result:=False;

  if Length(ASQL)=0 then
  begin
    Err:='IsNullOrEmpty(SQL)';
    Exit;
  end;

  with FADOQuery do
  begin
    Close;
    if Pos('ORACLE',UpperCase(FDBtype))>0 then
       EnableBCD:=False
    else
       EnableBCD:=True;
    SQL.Text := ASQL;
    try
      Open;
    except
      on e: exception do
      begin
        Err := e.Message;
        Exit;
      end;
    end;
  end;

  RetData:=FDsp.Data;
  Err:='';
  Result := True;
end;

//取1行1列數據
function TDAL.QueryOneCR(ASQL:string; var RetData:OleVariant; var Err:string):Boolean;
begin
  RetData:=null;
  Err:='';
  Result:=False;

  if Length(ASQL)=0 then
  begin
    Err:='IsNullOrEmpty(SQL)';
    Exit;
  end;

  with FADOQuery do
  begin
    Close;
    if Pos('ORACLE',UpperCase(FDBtype))>0 then
       EnableBCD:=False
    else
       EnableBCD:=True;
    SQL.Text := ASQL;
    try
      Open;
    except
      on e: exception do
      begin
        Err := e.Message;
        Exit;
      end;
    end;

    RetData:=Fields[0].Value;
    Err:='';
    Result := True;
  end;
end;

//查詢數據是否存在
function TDAL.QueryExists(ASQL:string; var isExist: Boolean; var Err:string):Boolean;
begin
  isExist:=False;
  Err:='';
  Result:=False;

  if Length(ASQL)=0 then
  begin
    Err:='IsNullOrEmpty(SQL)';
    Exit;
  end;

  with FADOQuery do
  begin
    Close;
    if Pos('ORACLE',UpperCase(FDBtype))>0 then
       EnableBCD:=False
    else
       EnableBCD:=True;
    SQL.Text := ASQL;
    try
      Open;
    except
      on e: exception do
      begin
        Err := e.Message;
        Exit;
      end;
    end;

    isExist:=not IsEmpty;
    Err:='';
    Result:=True;
  end;
end;

//sql更新
function TDAL.PostBySQL(ASQL:string; var Err:string):Boolean;
begin
  Err:='';
  Result:=False;

  if Length(ASQL)=0 then
  begin
    Err:='IsNullOrEmpty(SQL)';
    Exit;
  end;

  if FADOCommand.Connection.InTransaction then
  begin
    Err:='Prior Work InTransaction';
    Exit;
  end;

  FADOCommand.CommandText:=ASQL;
  FADOCommand.Connection.BeginTrans;
  try
    FADOCommand.Execute;
    FADOCommand.Connection.CommitTrans;
    Err:='';
    Result:=True;
  except
    on E:Exception do
    begin
      Result:=False;
      Err:=E.Message;
      if FADOCommand.Connection.InTransaction then
         FADOCommand.Connection.RollbackTrans;
    end;
  end;
end;

//Delea更新
function TDAL.CDSPost(Delta:OleVariant; TableName:string; var Err:string):Boolean;
const sql='Select * From %s Where 1=2';
var
  ErrCount:Integer;
begin
  Err:='';
  Result:=False;

  if Length(TableName)=0 then
  begin
    Err:='IsNullOrEmpty(TableName)';
    Exit;
  end;

  FADOQuery.Close;
  if Pos('ORACLE',UpperCase(FDBtype))>0 then
     FADOQuery.EnableBCD:=False
  else
     FADOQuery.EnableBCD:=True;
  FDsp.Options:=FDsp.Options-[poAllowCommandText];
  FDsp.ResolveToDataSet:=False;
  FADOQuery.SQL.Text:=Format(sql,[TableName]);
  try
    FADOQuery.Open;
  except
    on E:Exception do
    begin
      Err:=E.Message;
      Exit;
    end;
  end;

  if FADOQuery.Connection.InTransaction then
  begin
    Err:='Prior Work In Transaction';
    Exit;
  end;

  FError:='';
  FADOQuery.Connection.BeginTrans;
  FDsp.ApplyUpdates(Delta, 0, ErrCount);
  Result:=ErrCount=0;
  if Result then
  begin
    try
      Err:='';
      FADOQuery.Connection.CommitTrans;
    except
      on E:Exception do
      begin
        Result:=False;
        Err:=E.Message;
        if FADOQuery.Connection.InTransaction then
           FADOQuery.Connection.RollbackTrans;
      end;
    end;
  end else
  begin
    Err:=FError;
    FADOQuery.Connection.RollbackTrans;
  end;
end;

//檢查是否鎖定
function TDAL.CheckLockProc(ProcId:string; var isLock: Boolean; var Err:string): Boolean;
var
  tmpSQL:string;
begin
  IsLock:=False;
  Err:='';

  tmpSQL:='Select 1 From Sys_Lock Where ProcId='+Quotedstr(ProcId);
  Result:=QueryExists(tmpSQL, IsLock, Err);
end;

//鎖定
function TDAL.LockProc(ProcId:string; var Err:string): Boolean;
var
  tmpSQL:string;
begin
  Err:='';
  Result:=UnLockProc(ProcId, Err);
  if Result then
  begin
    tmpSQL:='Insert Into Sys_Lock(ProcId, Iuser, Idate)'
           +' Values('+Quotedstr(ProcId)+','+Quotedstr(FUserId)+',getdate())';
    Result:=PostBySQL(tmpSQL, Err);
  end;
end;

//解鎖
function TDAL.UnLockProc(ProcId:string; var Err:string): Boolean;
var
  tmpSQL:string;
begin
  Err:='';
  tmpSQL:='Delete From Sys_Lock Where ProcId='+Quotedstr(ProcId);
  Result:=PostBySQL(tmpSQL, Err);
end;

//取空行銅箔
function TDAL.GetMPSEmptyOZ(Jitem, Filter: string;
  var OZ,Err:string):Boolean;
var
  tmpStr:string;
begin
  OZ:='';
  Err:='';
  Result:=False;

  with FADOQuery do
  begin
    Close;
    EnableBCD:=True;
    SQL.Text := 'Select oz From mps010 Where Jitem='+Jitem+Filter
               +' And isnull(emptyflag,0)=0 And isnull(errorflag,0)=0'
               +' Group By oz Order By oz';;
    try
      Open;
    except
      on e: exception do
      begin
        Err := e.Message;
        Exit;
      end;
    end;

    while not Eof do
    begin
      tmpStr:=Fields[0].AsString;
      if tmpStr<>'' then
      begin
        tmpStr:=Copy(tmpStr,1,1);
        if pos(tmpStr, OZ)=0 then
           OZ:=OZ+tmpStr;
        if Length(OZ)=2 then
           Break;
      end;
      Next;
    end;
  end;

  Err:='';
  Result := True;
end;

procedure TDAL.FDspUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  FError:=E.Message;
end;

end.
