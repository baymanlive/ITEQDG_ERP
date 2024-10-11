//
// Created by kaikai.
// 2021/4/19 下午 15:17:15
//

unit unConnObj;

interface

uses
  System.SysUtils, Datasnap.DSConnect, Data.SqlExpr, System.IniFiles, Vcl.Forms;

type
  TConnObj = class(TObject)
  private
    FSvrIP:string;
    FPort:Integer;
    FSQLConnection: TSQLConnection;
    FDSProviderConnection: TDSProviderConnection;
    function Connect:string;
  public
    constructor Create;
    destructor Destroy; override;
    function GetSQLConnection(out Err:string):TSQLConnection;
  end;

implementation

{ TConnObj }

function TConnObj.Connect: string;
var
  retErr:string;
begin
  retErr:='';

  if not FSQLConnection.Connected then
  begin
    FSQLConnection.Params.Values['hostname']:=FSvrIP;
    FSQLConnection.Params.Values['port']:=IntToStr(FPort);
    try
      FSQLConnection.Connected:=True;
    except
      on e:exception do
      begin
        retErr:=e.Message+'(TConnObj.Connect)';
      end;
    end;
  end;

  Result:=retErr;
end;

constructor TConnObj.Create;
const strConfig='Config.ini';
var
  tmpSysPath,tmpStr:string;
  tmpIni:TIniFile;
begin
  tmpSysPath:=ExtractFilePath(Application.ExeName);

  FSQLConnection:=TSQLConnection.Create(nil);
  FDSProviderConnection:=TDSProviderConnection.Create(nil);

  FSQLConnection.ConnectionName:='DataSnapCONNECTION';
  FSQLConnection.DriverName:='DataSnap';
  FSQLConnection.LoginPrompt:=False;
  FDSProviderConnection.ServerClassName:='TServerMethods';
  FDSProviderConnection.SQLConnection:=FSQLConnection;

  FSvrIP:='192.168.0.1';
  FPort:=8901;
  if not FileExists(tmpSysPath+strConfig) then
  begin
    tmpStr:=Format('[%s] 配置檔案不存在(Svr.dll)', [strConfig]);
    Application.MessageBox(PChar(tmpStr), '提示', 16);
    Exit;
  end;

  tmpIni:=TIniFile.Create(tmpSysPath+'config.ini');
  try
    FSvrIP:=tmpIni.ReadString('SvrInfo', 'SvrIP', '192.168.0.1');
    FPort:=tmpIni.ReadInteger('SvrInfo', 'Port', 8901);
  finally
    FreeAndNil(tmpIni);
  end;
end;

destructor TConnObj.Destroy;
begin
  FSQLConnection.Connected:=False;
  FreeAndNil(FSQLConnection);
  FreeAndNil(FDSProviderConnection);

  inherited;
end;

function TConnObj.GetSQLConnection(out Err: string): TSQLConnection;
var
  retErr:string;
begin
  Result:=nil;
  Err:='';

  retErr:=Connect;
  if Length(retErr)>0 then
  begin
    Err:=retErr;
    Exit;
  end;

  Result:=FSQLConnection;
end;

end.
