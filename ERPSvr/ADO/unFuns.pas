unit unFuns;

interface

uses
  System.SysUtils, Winapi.Windows, Vcl.Forms, System.Classes, unGlobal;

procedure LogInfo(Err: string);

function CheckIsRunning: Boolean;

implementation

//添加錯誤信息到記錄文件
procedure LogInfo(Err: string);
var
  tmpStr: string;
  txt: TextFile;
begin
  if g_IsWriteLog then
    Exit;

  g_IsWriteLog := True;
  try
    tmpStr := g_SysPath + 'SvrError';
    if not DirectoryExists(tmpStr) then
      CreateDir(tmpStr);
    tmpStr := tmpStr + '\' + FormatDateTime(g_strShortMonth, Date);
    if not DirectoryExists(tmpStr) then
      CreateDir(tmpStr);
    tmpStr := tmpStr + '\' + FormatDateTime(g_strShortDate, Date) + '.txt';
    AssignFile(txt, tmpStr);
    if not FileExists(tmpStr) then
      Rewrite(txt);
    Append(txt);
    Write(txt, DateTimeToStr(Now) + #13#10 + Err + #13#10);
    CloseFile(txt);
  finally
    g_IsWriteLog := False;
  end;
end;

//檢查是否已運行
function CheckIsRunning: Boolean;
var
  aTitle: string;
  hMutex: THandle;
begin
  Result := False;
  aTitle := Application.Title;
  hMutex := CreateMutex(nil, False, PChar(aTitle));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(hMutex);
    Application.MessageBox(PChar(aTitle + g_strIsRUN), g_strHint, 16);
    Result := True;
  end;
end;

end.

