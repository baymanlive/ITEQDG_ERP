unit unPoolManager;

interface

uses
   System.SysUtils, System.Classes, System.SyncObjs, Vcl.ExtCtrls,
   Data.Win.ADODB, System.DateUtils, Vcl.Forms, System.IniFiles, unGlobal;

type
  TPoolManager = class(TObject)
  private
    FCriticalSection:TCriticalSection;
    FArrDB:array of TDBRec;
    FList:TList;
    FTimer:TTimer;
    FIndex:Integer;
    FMaxCount:Integer;
    procedure SetArrDB;
    procedure ADOConnectionExecuteComplete(Connection:TADOConnection;
      RecordsAffected:Integer; const Error:Error;
      var EventStatus:TEventStatus; const Command:_Command;
      const Recordset:_Recordset);
    procedure MyTime(Sender:TObject);
  public
    constructor Create;
    destructor Destroy; override;
    function LockConn(DBType:string; var Err:string):TADOConnection;
    procedure UnlockConn(xTag:Integer; xCloseConn:Boolean);
    function GetConnStr(var ConnStr:string; var Err:string):Boolean;
  end;

implementation

uses unMain;

{ TPoolManager }

//DBﬂBΩ”≈‰÷√
procedure TPoolManager.SetArrDB;
const strDBConfig='DB.ini';
var
  i:Integer;
  tmpStr:string;
  tmpIni:TIniFile;
  tmpList:TStrings;
begin
  if not FileExists(g_SysPath+strDBConfig) then
  begin
    tmpStr:=Format(g_strConfigNotExists, [strDBConfig]);
    Application.MessageBox(PChar(tmpStr), g_strHint, 16);
  end;

  tmpList:=TStringList.Create;
  tmpIni:=TIniFile.Create(g_SysPath+strDBConfig);
  try
    tmpIni.ReadSection('info', tmpList);
    SetLength(FArrDB, tmpList.Count);
    for i:=0 to tmpList.Count -1 do
    begin
      FArrDB[i].DBType:=UpperCase(tmpList.Strings[i]);
      FArrDB[i].ConnStr:=tmpIni.ReadString('info', FArrDB[i].DBType,'');
    end;
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpIni);
  end;
end;

procedure TPoolManager.ADOConnectionExecuteComplete(
  Connection:TADOConnection; RecordsAffected:Integer; const Error:Error;
  var EventStatus:TEventStatus; const Command:_Command;
  const Recordset:_Recordset);
begin
  if Error.Number=-2147467259 then //KeepConnectionÜñÓ},ﬂBæÄ ßî°,ÍPÈ]ﬂBΩ”
     Connection.Connected:=False;
end;

constructor TPoolManager.Create;
begin
  FIndex:=0;
  FMaxCount:=50;
  FCriticalSection:=TCriticalSection.Create;
  FList:=TList.Create;
  SetArrDB;

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

  for i:=0 to FList.Count - 1 do
  begin
    PConn(FList[i])^.Conn.Connected:=False;
    FreeAndNil(PConn(FList[i])^.Conn);
    Dispose(FList[i]);
  end;
  FreeAndNil(FList);

  SetLength(FArrDB,0);
  FArrDB:=nil;

  inherited Destroy;
end;

function TPoolManager.LockConn(DBType:string; var Err:String):TADOConnection;
var
  i,dbindex,cnt:Integer;
  tmpDBType:string;
  P:PConn;
begin
  Err:=g_strBusy;
  Result:=nil;

  FCriticalSection.Enter;
  try
    cnt:=0;
    tmpDBType:=UpperCase(DBType);
    for i:=0 to FList.Count - 1 do
    begin
      P:=PConn(FList[i]);
      if P^.DBType=tmpDBType then
      begin
        Inc(cnt);
        if not P^.InUse then
        if Round(MinuteSpan(Now, P^.InitTime)) < g_strFreeMinute then
        begin
          if not P^.Conn.Connected then
          begin
            try
              P^.Conn.Connected:=True;
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
          Result:=P^.Conn;
          Exit;
        end;
      end;
    end;

    if cnt < FMaxCount then
    begin
      dbindex:=-1;
      for i := Low(FArrDB) to High(FArrDB) do
      if FArrDB[i].DBType=tmpDBType then
      begin
        dbindex:=i;
        Break;
      end;

      if dbindex=-1 then
      begin
        Err:=Format(g_strNoDBType, [DBType]);
        Exit;
      end;

      New(P);
      P^.Conn:=TADOConnection.Create(nil);
      P^.Conn.OnExecuteComplete:=ADOConnectionExecuteComplete;
      P^.Conn.ConnectionString:=FArrDB[dbindex].ConnStr;
      P^.Conn.CommandTimeout:=300;
      P^.Conn.ConnectionTimeout:=10;
      P^.Conn.LoginPrompt:=False;
      try
        P^.Conn.Connected:=True;
      except
        on e:exception do
        begin
          FreeAndNil(P^.Conn);
          Dispose(P);
          Err:=e.Message;
          Exit;
        end;
      end;

      if FIndex>99999999 then
         FIndex:=1
      else
         Inc(FIndex);
      P^.Conn.Tag:=FIndex;
      P^.DBType:=DBType;
      P^.InUse:=True;
      P^.InitTime:=Now;
      P^.LastWorkTime:=Now;
      FList.Add(P);
      Result:=P^.Conn;
    end;
  finally
    FCriticalSection.Leave;
  end;
end;

procedure TPoolManager.UnlockConn(xTag:Integer; xCloseConn:Boolean);
var
  i,j:Integer;
  P:PConn;
begin
  FCriticalSection.Enter;
  try
    for i:=0 to FList.Count-1 do
    begin
      P:=PConn(FList[i]);
      if P^.Conn.Tag=xTag then
      begin
        P^.InUse:=False;
        for j:=P^.Conn.DataSetCount-1 downto 0 do
          P^.Conn.DataSets[j].Connection:=nil;

        if P^.Conn.InTransaction then
        begin
          try
            P^.Conn.RollbackTrans;
          except
          end;
        end;

        if xCloseConn and P^.Conn.Connected then
        if Pos('ORA', UpperCase(P^.DBType))>0 then
           P^.Conn.Connected:=False;

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
  P:PConn;
begin
  FTimer.Enabled:=False;
  FCriticalSection.Enter;
  try
    for i:=Low(FArrDB) to High(FArrDB) do
    begin
      FArrDB[i].InitCnt:=0;
      FArrDB[i].ActiveCnt:=0;
      FArrDB[i].InUseCnt:=0;

      for j:=FList.Count-1 downto 0 do
      begin
        P:=PConn(FList[j]);
        if P^.DBType=FArrDB[i].DBType then
        begin
          if P^.InUse then
             Inc(FArrDB[i].InUseCnt)
          else begin
            if Round(MinuteSpan(Now, P^.InitTime)) > g_strFreeMinute then
            begin
              P^.Conn.Connected:=False;
              FreeAndNil(P^.Conn);
              Dispose(P);
              FList.Delete(j);
              Continue;
            end else
            if Round(MinuteSpan(Now, P^.LastWorkTime)) > g_strCloseMinute then
               P^.Conn.Connected:=False;
          end;

          Inc(FArrDB[i].InitCnt);
          if P^.Conn.Connected then
             Inc(FArrDB[i].ActiveCnt);
        end;
      end;
    end;

    for i:=Low(FArrDB) to High(FArrDB) do
    begin
      tmpStr:=tmpStr+'  '+FArrDB[i].DBType+':'+IntToStr(FArrDB[i].InitCnt)+','+IntToStr(FArrDB[i].ActiveCnt)+','+IntToStr(FArrDB[i].InUseCnt);
    end;
    FrmMain.Label2.Caption:=g_strDBCount+LowerCase(Trim(tmpStr));
  finally
    FCriticalSection.Leave;
    FTimer.Enabled:=True;
  end;
end;

function TPoolManager.GetConnStr(var ConnStr:string; var Err:string):Boolean;
var
  i:Integer;
  tmpStr:string;
begin
  ConnStr:='';
  Err:='';
  Result:=False;

  tmpStr:='';
  for i:=Low(FArrDB) to High(FArrDB) do
  begin
    if Pos('ORACLE',FArrDB[i].DBType)=0 then
       tmpStr:=tmpStr+'|'+FArrDB[i].DBType+'|'+FArrDB[i].ConnStr;
  end;

  if Length(tmpStr)=0 then
     Err:=g_strConnStrErr
  else begin
    Delete(tmpStr,1,1);
    ConnStr:=tmpStr;
    Result:=True;
  end;
end;

end.

