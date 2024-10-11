unit unFuns;

interface

uses
  Windows, Classes, SysUtils, Forms, DB, ADODB, TypInfo, IniFiles, unGlobal;

procedure LogInfo(Err: string);
function GetParDirction(name:string):TParameterDirection;
function GetParFieldType(name:string):TFieldType;
function CheckIsRunning:Boolean;
function Decrypt(pw:string):string;
procedure InitDBTypeList(var DestList:TList);

implementation

//添加錯誤信息到記錄文件
procedure LogInfo(Err: string);
var
  tmpStr: string;
  txt: TextFile;
begin
  if g_IsWriteLog then
     Exit;

  g_IsWriteLog:=True;
  try
    tmpStr:=g_SysPath + 'Error';
    if not DirectoryExists(tmpStr) then
       CreateDir(tmpStr);
    tmpStr:=tmpStr + '\' +FormatDateTime(g_ShortMonth, Date);
    if not DirectoryExists(tmpStr) then
       CreateDir(tmpStr);
    tmpStr:= tmpStr + '\' +FormatDateTime(g_ShortDate, Date) + '.txt';
    AssignFile(txt, tmpStr);
    if not FileExists(tmpStr) then
       Rewrite(txt);
    Append(txt);
    Write(txt, DateTimeToStr(Now)+#13#10+Err+#13#10);
    CloseFile(txt);
  finally
    g_IsWriteLog:=False;
  end;
end;

//字符串轉換TParameterDirection枚舉類型
function GetParDirction(name:string):TParameterDirection;
begin
  Result:=TParameterDirection(GetEnumValue(TypeInfo(TParameterDirection), name));
end;

//字符串轉換TFieldType枚舉類型
function GetParFieldType(name:string):TFieldType;
begin
  Result:=TFieldType(GetEnumValue(TypeInfo(TFieldType), name));
end;

//檢查是否已運行
function CheckIsRunning:Boolean;
var
  aTitle:string;
  hMutex: THandle;
begin
  Result:=False;
  aTitle:=Application.Title;
  hMutex:= CreateMutex(nil, False, PChar(aTitle));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(hMutex);
    Application.MessageBox(PChar('The '+aTitle+' is already running'), 'Message', 16);
    Result:=True;
  end;
end;

//解密密碼
function Decrypt(pw:string):string;
type
  TEncrypt = procedure (SourceStr, DestStr:PChar);stdcall;
var
  DllHandle:HWnd;
  DllFunc:TEncrypt;
  P:PChar;
begin
  Result:=pw;
  DllHandle:=LoadLibrary('Encrypt.dll');
  if DllHandle<>0 then
  begin
    @DllFunc:=GetProcAddress(DllHandle, 'Decrypt');
    if @DllFunc<>nil then
    begin
      P:=StrAlloc(1024);
      try
        DllFunc(PChar(pw), P);
        Result:=P;
      finally
        StrDispose(P);
      end;
    end else
      raise Exception.Create('Invalid dll function ''Decrypt''');

    FreeLibrary(DllHandle);
  end else
    raise Exception.Create('Invalid dll name ''Encrypt''');
end;

//加載數據庫連接配置
procedure InitDBTypeList(var DestList:TList);
var
  i:Integer;
  tmpProvider,tmpHost,tmpUser,tmpPassword,tmpDatabase:string;
  tmpIni:TIniFile;
  tmpList:TStrings;
  P:PDBType;
begin
  g_SysPath:=ExtractFilePath(Application.ExeName);

  if not FileExists(g_SysPath+'SQLConfig.ini') then
     raise Exception.Create('Invalid ini name ''SQLConfig''');

  tmpList:=TStringList.Create;
  tmpIni:=TIniFile.Create(g_SysPath+'SQLConfig.ini');
  try
    tmpIni.ReadSections(tmpList);
    for i:=0 to tmpList.Count -1 do
    begin
      New(P);
      P^.InitCnt:=0;
      P^.ActiveCnt:=0;
      P^.InUseCnt:=0;
      P^.DBType:=tmpList.Strings[i];
      if tmpIni.ReadString(tmpList.Strings[i],'DefaultDB','')='1' then
         g_DefDBType:=P^.DBType;
      tmpProvider:=tmpIni.ReadString(tmpList.Strings[i],'Provider','');
      tmpHost:=tmpIni.ReadString(tmpList.Strings[i],'Host','');
      tmpUser:=tmpIni.ReadString(tmpList.Strings[i],'User','');
      tmpPassword:=tmpIni.ReadString(tmpList.Strings[i],'Password','');
      tmpDatabase:=tmpIni.ReadString(tmpList.Strings[i],'Database','');
      tmpPassword:=Decrypt(tmpPassword);
      if Pos('oracle',LowerCase(P^.DBType))>0 then
         P^.ConnStr:='Provider='+tmpProvider
                    +';Password='+Trim(tmpPassword)
                    +';Persist Security Info=True'
                    +';User ID='+trim(tmpUser)
                    +';Data Source='+Trim(tmpHost)
      else
         P^.ConnStr:='Provider='+tmpProvider
                    +';Password='+Trim(tmpPassword)
                    +';Persist Security Info=True'
                    +';User ID='+trim(tmpUser)
                    +';Initial Catalog='+Trim(tmpDatabase)
                    +';Data Source='+Trim(tmpHost);
      DestList.Add(P);
    end;
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpIni);
  end;
end;

end.
