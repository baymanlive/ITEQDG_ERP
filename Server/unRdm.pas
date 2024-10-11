unit unRdm;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  Windows, Classes, SysUtils, ComServ, ComObj, VCLCom, DataBkr,
  ERPServer_TLB, Variants, ADODB, DB, DBClient, Provider, unGlobal,
  unFuns, unPoolManager, unUserManager, StdVcl;

type
  TRdm = class(TRemoteDataModule, IRdm)
    FADOStoredProc: TADOStoredProc;
    FADOCommand: TADOCommand;
    FADOQuery: TADOQuery;
    FDsp: TDataSetProvider;
    procedure FDspUpdateError(Sender: TObject;
      DataSet: TCustomClientDataSet; E: EUpdateError;
      UpdateKind: TUpdateKind; var Response: TResolverResponse);
  private
    l_Error:string;
    { Private declarations }
  protected
    class procedure UpdateRegistry(Register: Boolean; const ClassID, ProgID: string); override;
    function Login(const IP, ComputerName, Bu, UserId, Password: WideString;
      out ID, Err: WideString): WordBool; safecall;
    function LogOut(const ID: WideString; out Err: WideString): WordBool;
      safecall;
    function QueryBySQL(const ID, ProcId, Dbtype, SelectSQL: WideString;
      out Data: OleVariant; out Err: WideString): WordBool; safecall;
    function PostByDelta(const ID, ProcId, Dbtype, UpdateTable: WideString;
      Delta: OleVariant; out Err: WideString): WordBool; safecall;
    function PostBySQL(const ID, ProcId, Dbtype, CommandText: WideString;
      out Err: WideString): WordBool; safecall;
    function QueryOneCR(const ID, ProcId, Dbtype, SelectSQL: WideString;
      out Value: OleVariant; out Err: WideString): WordBool; safecall;
    function QueryExists(const ID, ProcId, Dbtype, SelectSQL: WideString;
      out isExist: WordBool; out Err: WideString): WordBool; safecall;
    function ExecStoredProc(const ID, ProcId, Dbtype,
      StoredProcName: WideString; ArrPars: OleVariant;
      out Data: OleVariant; out Err: WideString): WordBool; safecall;
    function GetBu(const Dbtype: WideString; out Data: OleVariant;
      out Err: WideString): WordBool; safecall;
    function PostByJoinSQL(const ID, ProcId, Dbtype, JoinSQL: WideString;
      Delta: OleVariant; out Err: WideString): WordBool; safecall;
    function CheckLockProc(const ProcId: WideString; out IsLock: WordBool;
      out Err: WideString): WordBool; safecall;
    function LockProc(const ProcId, UserId: WideString;
      out Err: WideString): WordBool; safecall;
    function UnLockProc(const ProcId: WideString;
      out Err: WideString): WordBool; safecall;
    function GetMPSEmptyOZ(const Jitem, Filter: WideString; out OZ,
      Err: WideString): WordBool; safecall;
    function COCEmail(const Dbtype: WideString; out Err: WideString): WordBool;
      safecall;
  public
    { Public declarations }
  end;

var
  l_PoolManager : TPoolManager;
  l_UserManager : TUserManager;

implementation

{$R *.DFM}

{登入系統
IP, ComputerName, UserId, Password(IP,電腦名稱,登入的帳號,登入的密碼)
ID:調用成功時，返回唯一客戶端ID
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.Login(const IP, ComputerName, Bu, UserId,
  Password: WideString; out ID, Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  ID:='';
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(g_DefDBType,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('Login(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Clear;
      SQL.Add('Select Password From Sys_User Where IsNull(Not_Use,0)=0');
      SQL.Add('And Bu=:Bu And UserId=:UserId');
      Parameters.ParamByName('Bu').Value:=Bu;
      Parameters.ParamByName('UserId').Value:=UserId;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('Login(Open):'+Err);
          Exit;
        end;
      end;

      if IsEmpty or (Fields[0].AsString<>Password) then
      begin
        Err:='帳號或密碼錯誤';
        Exit;
      end;
    end;

    ID:=l_UserManager.Login(IP, ComputerName, UserId);
    Err:='';
    Result:=True;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,False);
  end;
end;

{登出系統
ID:服務器分配給客戶端的ID
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.LogOut(const ID: WideString; out Err: WideString): WordBool;
begin
  Err:='';
  Result:=True;

  l_UserManager.Logout(ID);
end;

{通過SQL語句查詢數據
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
SelectSQ:SQL查詢語句
Data:查詢結果返回的數據包
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.QueryBySQL(const ID, ProcId, Dbtype, SelectSQL: WideString;
  out Data: OleVariant; out Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  Data:=null;
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('QueryBySQL(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE',UpperCase(Dbtype))>0 then
         EnableBCD:=False
      else
         EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('QueryBySQL(Open):'+Err+#13#10+SelectSQL);
          Exit;
        end;
      end;
    end;

    Data:=FDsp.Data;
    Err:='';
    Result := True;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{單表通過Delta提交數據
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
UpdateTable:更新的資料表名稱
Delta:客戶端修改過的數據包
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.PostByDelta(const ID, ProcId, Dbtype,
  UpdateTable: WideString; Delta: OleVariant;
  out Err: WideString): WordBool;
const sql='Select * From %s Where 1=2';
var
  ErrCount:Integer;
  tmpSQL:string;
  tmpADOConn:TADOConnection;
begin
  Err:='';
  Result:=False;

  //if not l_UserManager.CheckLoginByID(ID, Err) then
  //   Exit;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('PostByDelta(LockADOConn):'+Err);
    Exit;
  end;

  try
    tmpSQL:=Format(sql,[UpdateTable]);
    FADOQuery.Close;
    if Pos('ORACLE',UpperCase(Dbtype))>0 then
       FADOQuery.EnableBCD:=False
    else
       FADOQuery.EnableBCD:=True;
    FADOQuery.Connection:=tmpADOConn;
    FDsp.Options:=FDsp.Options-[poAllowCommandText];
    FDsp.ResolveToDataSet:=False;
    FADOQuery.SQL.Text:=tmpSQL;
    try
      FADOQuery.Open;
    except
      on E:Exception do
      begin
        Err:=E.Message;
        LogInfo('PostByDelta(Open):'+Err+#13#10+tmpSQL);
        Exit;
      end;
    end;

    if FADOQuery.Connection.InTransaction then
    begin
      Err:=g_InTransaction;
      LogInfo('PostByDelta(InTransaction):'+Err+#13#10+tmpSQL);
      Exit;
    end;

    l_Error:='';
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
          LogInfo('PostByDelta(CommitTrans):'+Err+#13#10+tmpSQL);
          if FADOQuery.Connection.InTransaction then
             FADOQuery.Connection.RollbackTrans;
        end;
      end;
    end else
    begin
      Err:=l_Error;
      LogInfo('PostByDelta(ApplyUpdates):'+Err+#13#10+tmpSQL);
      FADOQuery.Connection.RollbackTrans;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{多表連接通過Delta提交數據
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
JoinSQL:多表連接的SQL語句
Delta:客戶端修改過的數據包
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.PostByJoinSQL(const ID, ProcId, Dbtype, JoinSQL: WideString;
  Delta: OleVariant; out Err: WideString): WordBool;
var
  ErrCount:Integer;
  tmpADOConn:TADOConnection;
begin
  Err:='';
  Result:=False;

  //if not l_UserManager.CheckLoginByID(ID, Err) then
  //   Exit;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('PostByJoinSQL(LockADOConn):'+Err);
    Exit;
  end;

  try
    FADOQuery.Close;
    if Pos('ORACLE',UpperCase(Dbtype))>0 then
       FADOQuery.EnableBCD:=False
    else
       FADOQuery.EnableBCD:=True;
    FADOQuery.Connection:=tmpADOConn;
    FDsp.Options:=FDsp.Options+[poAllowCommandText];
    FDsp.ResolveToDataSet:=True;
    FADOQuery.SQL.Text:=JoinSQL;
    try
      FADOQuery.Open;
    except
      on E:Exception do
      begin
        Err:=E.Message;
        LogInfo('PostByJoinSQL(Open):'+Err+#13#10+JoinSQL);
        Exit;
      end;
    end;

    if FADOQuery.Connection.InTransaction then
    begin
      Err:=g_InTransaction;
      LogInfo('PostByJoinSQL(InTransaction):'+Err+#13#10+JoinSQL);
      Exit;
    end;

    l_Error:='';
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
          LogInfo('PostByJoinSQL(CommitTrans):'+Err+#13#10+JoinSQL);
          if FADOQuery.Connection.InTransaction then
             FADOQuery.Connection.RollbackTrans;
        end;
      end;
    end else
    begin
      Err:=l_Error;
      LogInfo('PostByJoinSQL(ApplyUpdates):'+Err+#13#10+JoinSQL);
      FADOQuery.Connection.RollbackTrans;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{執行SQL語句
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
CommandText:SQL語句，允許多條SQL
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.PostBySQL(const ID, ProcId, Dbtype, CommandText: WideString;
  out Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  Err:='';
  Result:=False;

  //if not l_UserManager.CheckLoginByID(ID, Err) then
  //   Exit;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('PostBySQL(LockADOConn):'+Err);
    Exit;
  end;

  try
    FADOCommand.Connection:=tmpADOConn;

    if FADOCommand.Connection.InTransaction then
    begin
      Err:=g_InTransaction;
      LogInfo('PostBySQL(InTransaction):'+Err+#13#10+CommandText);
      Exit;
    end;

    FADOCommand.CommandText:=CommandText;
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
        LogInfo('PostBySQL(Execute):'+Err+#13#10+CommandText);
        if FADOCommand.Connection.InTransaction then
           FADOCommand.Connection.RollbackTrans;
      end;
    end;
  finally
    FADOCommand.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{查詢一行一列
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
SelectSQ:SQL查詢語句
Value:調用成功時,查詢結果返回的值
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.QueryOneCR(const ID, ProcId, Dbtype, SelectSQL: WideString;
  out Value: OleVariant; out Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  Value:=null;
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('QueryOneCR(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE',UpperCase(Dbtype))>0 then
         EnableBCD:=False
      else
         EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('QueryOneCR(Open):'+Err+#13#10+SelectSQL);
          Exit;
        end;
      end;

      Value:=Fields[0].Value;
      Err:='';
      Result := True;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{查詢結果真/假
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
SelectSQ:SQL查詢語句
isExist:調用成功時,查詢結果返回的true/false值
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.QueryExists(const ID, ProcId, Dbtype, SelectSQL: WideString;
  out isExist: WordBool; out Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  isExist:=False;
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('QueryExists(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE',UpperCase(Dbtype))>0 then
         EnableBCD:=False
      else
         EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Text := SelectSQL;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('QueryExists(Open):'+Err+#13#10+SelectSQL);
          Exit;
        end;
      end;

      isExist:=not IsEmpty;
      Err:='';
      Result:=True;
    end;

  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,Pos('ORA-',Err)>0);
  end;
end;

{執行存儲過程
ID:服務器分配給客戶端的ID
ProcId:程序代碼
Dbtype:數據庫類型
StoreProcName:存儲過程名稱
ArrayPars:存儲過程參數; n X 4二維變體矩陣
  若無參數則隨便傳一個值或傳空值
  其中列0..4表示:name,TFieldType,TParameterDirection,size,value
Data:執行成功時,返回n X 1二維變體矩陣
Err:錯誤信息,調用此函數為false時，可取err值}
function TRdm.ExecStoredProc(const ID, ProcId, Dbtype,
  StoredProcName: WideString; ArrPars: OleVariant; out Data: OleVariant;
  out Err: WideString): WordBool;
var
  i,low1,high1:integer;
  tmpStr:string;
  tmpFT:TFieldType;
  tmpPD:TParameterDirection;
  tmpList:TStringList;
  tmpData:OleVariant;
  tmpADOConn:TADOConnection;
begin
  Data:=null;
  Err:='';
  Result:=False;

  //if not l_UserManager.CheckLoginByID(ID, Err) then
  //   Exit;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('ExecStoredProc(LockADOConn):'+Err);
    Exit;
  end;

  tmpList:=TStringList.Create;
  try
    FADOStoredProc.Connection:=tmpADOConn;
    FADOStoredProc.ProcedureName:=StoredProcName;
    FADOStoredProc.Parameters.Clear;
    if VarIsArray(ArrPars) then
    begin
      low1:=VarArrayLowBound(ArrPars, 1);
      high1:=VarArrayHighBound(ArrPars, 1);
      for i:=low1 to high1 do
      begin
        tmpStr:=VarToStr(ArrPars[i,0]);
        tmpFT:=GetParFieldType(VarToStr(ArrPars[i,1]));
        tmpPD:=GetParDirction(VarToStr(ArrPars[i,2]));
        if tmpPD in [pdOutput, pdInputOutput,pdReturnValue] then
           tmpList.Add(tmpStr);
        FADOStoredProc.Parameters.CreateParameter(tmpstr, tmpFT, tmpPD, ArrPars[i,3], ArrPars[i,4]);
      end;
    end;
    try
    FADOStoredProc.ExecProc;
    except
      on E:Exception do
      begin
        Err:=E.Message;
        LogInfo('ExecStoredProc(ExecProc):'+Err+#13#10+StoredProcName);
        Exit;
      end;
    end;
    if tmpList.Count>0 then
    begin
      tmpData:=VarArrayCreate([0,tmpList.Count-1],varVariant);
      for i:=0 to tmpList.Count-1 do
        tmpData[i]:=FADOStoredProc.Parameters.ParamValues[tmpList.Strings[i]];
    end else
      tmpData:='';

    Data:=tmpData;
    Err:='';
    Result:=True;
  finally
    FreeAndNil(tmpList);
    FADOStoredProc.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,False);
  end;
end;

{獲取營管中心,不檢驗是否登入系統}
function TRdm.GetBu(const Dbtype: WideString; out Data: OleVariant;
  out Err: WideString): WordBool;
var
  tmpADOConn:TADOConnection;
begin
  Data:=null;
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(Dbtype,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('GetBu(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      if Pos('ORACLE',UpperCase(Dbtype))>0 then
         EnableBCD:=False
      else
         EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Text := 'Select * From Sys_Bu';
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('GetBu(Open):'+Err);
          Exit;
        end;
      end;

      Data:=FDsp.Data;
      Err:='';
      Result := True;
    end;
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,False);
  end;
end;

//檢查是否作業鎖定
function TRdm.CheckLockProc(const ProcId: WideString; out IsLock: WordBool;
  out Err: WideString): WordBool;
var
  SelectSQL:string;
begin
  IsLock:=False;
  Err:='';
  SelectSQL:='Select 1 From Sys_Lock Where ProcId='+Quotedstr(ProcId);
  Result:=QueryExists('@', ProcId, g_DefDBType, SelectSQL, IsLock, Err);
end;

//鍋定作業
function TRdm.LockProc(const ProcId, UserId: WideString;
  out Err: WideString): WordBool;
var
  UpdateSQL:string;
begin
  Err:='';
  Result:=UnLockProc(ProcId, Err);
  if Result then
  begin
    UpdateSQL:='Insert Into Sys_Lock(ProcId, Iuser, Idate)'
              +' Values('+Quotedstr(ProcId)+','+Quotedstr(UserId)+',getdate())';
    Result:=PostBySQL('@', ProcId, g_DefDBType, UpdateSQL, Err);
  end;
end;

//解鎖作業
function TRdm.UnLockProc(const ProcId: WideString;
  out Err: WideString): WordBool;
var
  UpdateSQL:string;
begin
  Err:='';
  UpdateSQL:='Delete From Sys_Lock Where ProcId='+Quotedstr(ProcId);
  Result:=PostBySQL('@', ProcId, g_DefDBType, UpdateSQL, Err);
end;

//取空行的銅箔
function TRdm.GetMPSEmptyOZ(const Jitem, Filter: WideString; out OZ,
  Err: WideString): WordBool;
var
  tmpStr:string;
  tmpADOConn:TADOConnection;
begin
  OZ:='';
  Err:='';
  Result:=False;

  tmpADOConn:=l_PoolManager.LockADOConn(g_DefDBType,Err);
  if tmpADOConn=nil then
  begin
    LogInfo('GetMPSEmptyOZ(LockADOConn):'+Err);
    Exit;
  end;

  try
    with FADOQuery do
    begin
      Close;
      EnableBCD:=True;
      Connection:=tmpADOConn;
      SQL.Text := 'Select oz From mps010 Where Jitem='+Jitem+Filter
                 +' And isnull(emptyflag,0)=0 And isnull(errorflag,0)=0'
                 +' Group By oz Order By oz';;
      try
        Open;
      except
        on e: exception do
        begin
          Err := e.Message;
          LogInfo('GetMPSEmptyOZ(Open):'+Err);
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
  finally
    FADOQuery.Close;
    FADOQuery.Connection:=nil;
    l_PoolManager.UnlockADOConn(tmpADOConn.Tag,False);
  end;
end;

function TRdm.COCEmail(const Dbtype: WideString;
  out Err: WideString): WordBool;
begin
  Err:='';
  Result:=FileExists(g_CocEmail);
  if Result then
     WinExec(PChar(g_CocEmail+' coc '+string(Dbtype)+' '+DateToStr(Date)+' test'), SW_SHOWNORMAL);
end;

procedure TRdm.FDspUpdateError(Sender: TObject;
  DataSet: TCustomClientDataSet; E: EUpdateError; UpdateKind: TUpdateKind;
  var Response: TResolverResponse);
begin
  l_Error:=E.Message;
end;

class procedure TRdm.UpdateRegistry(Register: Boolean; const ClassID, ProgID: string);
begin
  if Register then
  begin
    inherited UpdateRegistry(Register, ClassID, ProgID);
    EnableSocketTransport(ClassID);
    EnableWebTransport(ClassID);
  end else
  begin
    DisableSocketTransport(ClassID);
    DisableWebTransport(ClassID);
    inherited UpdateRegistry(Register, ClassID, ProgID);
  end;
end;

initialization
  l_PoolManager := TPoolManager.Create;
  l_UserManager := TUserManager.Create;
 
  TComponentFactory.Create(ComServer, TRdm,
    Class_Rdm, ciMultiInstance, tmApartment);

finalization
  FreeAndNil(l_PoolManager);
  FreeAndNil(l_UserManager);

end.
