unit unPoolManager;

interface

uses
   SysUtils, Classes, SyncObjs, ADODB, ExtCtrls, DateUtils, unGlobal, unFuns;

type
  TPoolManager = class(TObject)
  private
    FCriticalSection:TCriticalSection;
    FDBTypeList:TList;
    FList:TList;
    FTimer:TTimer;
    FIndex:Integer;
    FMaxCount:Integer;
    procedure ADOConnectionExecuteComplete(Connection:TADOConnection;
      RecordsAffected:Integer; const Error:Error;
      var EventStatus:TEventStatus; const Command:_Command;
      const Recordset:_Recordset);
    procedure MyTime(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function LockADOConn(DBType:string; var Err:WideString):TADOConnection;
    procedure UnlockADOConn(xTag:Integer; xCloseConn:Boolean);
  end;

implementation

uses unMain;

{ TPoolManager }

procedure TPoolManager.ADOConnectionExecuteComplete(
  Connection:TADOConnection; RecordsAffected:Integer; const Error:Error;
  var EventStatus:TEventStatus; const Command:_Command;
  const Recordset:_Recordset);
begin
  if Error.Number=-2147467259 then //KeepConnection問題,連線失敗,關閉連接
     Connection.Connected:=False;
end;

constructor TPoolManager.Create;
begin
  FIndex:=0;
  FMaxCount:=50;
  FCriticalSection:=TCriticalSection.Create;
  FDBTypeList:=TList.Create;
  FList:=TList.Create;
  InitDBTypeList(FDBTypeList);

  FTimer:=TTimer.Create(nil);
  FTimer.Interval:=60000;
  FTimer.OnTimer:=MyTime;
  FTimer.Enabled:=True;
end;

destructor TPoolManager.Destroy;
var
  i:Integer;
begin
  FreeAndNil(FCriticalSection);
  FTimer.Enabled:=False;
  FreeAndNil(FTimer);

  for i:=0 to FDBTypeList.Count - 1 do
    Dispose(FDBTypeList[i]);
  FreeAndNil(FDBTypeList);

  for i:=0 to FList.Count - 1 do
  begin
    PADOConn(FList[i])^.ADOConn.Connected:=False;
    FreeAndNil(PADOConn(FList[i])^.ADOConn);
    Dispose(FList[i]);
  end;
  FreeAndNil(FList);

  inherited Destroy;
end;

function TPoolManager.LockADOConn(DBType:string; var Err:WideString):TADOConnection;
var
  i,dbIndex,cnt:Integer;
  P:PADOConn;
begin
  Err:=g_Busy;
  Result:=nil;
  
  FCriticalSection.Enter;
  try
    cnt:=0;
    for i:=0 to FList.Count - 1 do
    begin
      P:=PADOConn(FList[i]);
      if SameText(P^.DBType, DBType) then
      begin
        Inc(cnt);
        if not P^.InUse then
        if Round(MinuteSpan(Now, P^.InitTime)) < g_FreeMinute then
        begin
          if not P^.ADOConn.Connected then
          begin
            try
              P^.ADOConn.Connected:=True;
            except
              on e:exception do
              begin
                Err:=e.Message;
                Exit;
              end;
            end;
          end;

          P^.InUse:=True;
          P^.LastWorkTime:=Now;
          Result:=P^.ADOConn;
          Exit;
        end;
      end;
    end;

    if cnt < FMaxCount then
    begin
      dbIndex:=-1;
      for i:=0 to FDBTypeList.Count - 1 do
      begin
        if SameText(PDBType(FDBTypeList[i])^.DBType, DBType) then
        begin
          dbIndex:=i;
          Break;
        end;
      end;

      if dbIndex=-1 then
      begin
        Err:=Format(g_NoDBType, [DBType]);
        Exit;
      end;

      New(P);
      P^.ADOConn:=TADOConnection.Create(nil);
      P^.ADOConn.OnExecuteComplete:=ADOConnectionExecuteComplete;
      P^.ADOConn.ConnectionString:=PDBType(FDBTypeList[dbIndex])^.ConnStr;
      P^.ADOConn.CommandTimeout:=300;
      P^.ADOConn.ConnectionTimeout:=10;
      P^.ADOConn.LoginPrompt:=False;
      try
        P^.ADOConn.Connected:=True;
      except
        on e:exception do
        begin
          FreeAndNil(P^.ADOConn);
          Dispose(P);
          Err:=e.Message;
          Exit;
        end;
      end;

      if FIndex>99999999 then
         FIndex:=1
      else
         Inc(FIndex);
      P^.ADOConn.Tag:=FIndex;
      P^.DBType:=DBType;
      P^.InUse:=True;
      P^.InitTime:=Now;
      P^.LastWorkTime:=Now;      
      FList.Add(P);
      Result:=P^.ADOConn;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPoolManager.UnlockADOConn(xTag:Integer; xCloseConn:Boolean);
var
  i,j:Integer;
  P:PADOConn;
begin
  FCriticalSection.Enter;
  try
    for i:=0 to FList.Count-1 do
    begin
      P:=PADOConn(FList[i]);
      if P^.ADOConn.Tag=xTag then
      begin
        P^.InUse:=False;
        for j:=P^.ADOConn.DataSetCount-1 downto 0 do
          P^.ADOConn.DataSets[j].Connection:=nil;

        if P^.ADOConn.InTransaction then
        begin
          try
            P^.ADOConn.RollbackTrans;
          except
          end;
        end;

        if xCloseConn and P^.ADOConn.Connected then
        if Pos('ORA', UpperCase(P^.DBType))>0 then
           P^.ADOConn.Connected:=False;

        Break;
      end;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPoolManager.MyTime(Sender:TObject);
var
  i,j:Integer;
  tmpStr:string;
  P1:PDBType;
  P2:PADOConn;
begin
  FTimer.Enabled:=False;
  FCriticalSection.Enter;
  try
    for i:=0 to FDBTypeList.Count-1 do
    begin
      P1:=PDBType(FDBTypeList[i]);
      P1^.InitCnt:=0;
      P1^.ActiveCnt:=0;
      p1^.InUseCnt:=0;

      for j:=FList.Count-1 downto 0 do
      begin
        P2:=PADOConn(FList[j]);
        if SameText(P1^.DBType, P2^.DBType) then
        begin
          if not P2^.InUse then
          begin
            if Round(MinuteSpan(Now, P2^.InitTime)) > g_FreeMinute then
            begin
              P2^.ADOConn.Connected:=False;
              FreeAndNil(P2^.ADOConn);
              Dispose(P2);
              FList.Delete(j);
              Continue;
            end else
            if Round(MinuteSpan(Now, P2^.LastWorkTime)) > g_CloseMinute then
               P2^.ADOConn.Connected:=False;
          end else
            Inc(P1^.InUseCnt);

          Inc(P1^.InitCnt);
          if P2^.ADOConn.Connected then
             Inc(P1^.ActiveCnt);
        end;
      end;
    end;

    for i:=0 to FDBTypeList.Count-1 do
    begin
      P1:=PDBType(FDBTypeList[i]);
      tmpStr:=tmpStr+'  '+P1^.DBType+':'+IntToStr(P1^.InitCnt)+','+IntToStr(P1^.ActiveCnt)+','+IntToStr(P1^.InUseCnt);
    end;
    FrmMain.SB.Panels[1].Text:=LowerCase(Trim(tmpStr))+'  '+FormatDateTime('HH:NN:SS',Now) ;
  finally
    FCriticalSection.Leave;
    FTimer.Enabled:=True;
  end;
end;

end.
 