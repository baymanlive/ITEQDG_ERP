unit unGlobal;

interface

uses
  Data.Win.ADODB, System.Classes;

type
  TDBRec = Record
    DBType,
    ConnStr     :string;
    InitCnt,
    ActiveCnt,
    InUseCnt    :Integer;
  end;

  TUser = Record
    ID,
    UserId,
    UserName,
    Depart,
    IP,
    ComputerName : string;
    Flag         : Integer;
  end;

  PConn = ^TConn;
  TConn = Record
    Conn          :TADOConnection;
    DBType        :string;
    InUse         :Boolean;
    InitTime,
    LastWorkTime  :TDateTime;
  end;

  TExeMail = Record
    Exe,
    Time       :string;
  end;

var
  g_SysPath       : string;
  g_DefDBType     : string;
  g_Port          : Integer;
  g_OnLine        : Integer;
  g_IsWriteLog    : Boolean;
  g_ArrUser       : array [0..499] of TUser;  //若用完也不影響

const g_strFreeMinute = 60;
const g_strCloseMinute = 20;
const g_strShortMonth = 'YYYYMM';
const g_strShortDate = 'YYYYMMDD';
const g_strCocEmail = 'COCEmail.exe';
const g_strAppTitle = 'ERP應用服務器';
const g_strMenu='菜單';
const g_strMenuShow='顯示';
const g_strMenuExit='退出';
const g_strHint = '提示';
const g_strConfigNotExists='[%s] 配置檔案不存在';
const g_strExit='确定退出嗎?';
const g_strIsRUN=',已經打開';
const g_strPWErr='帳號或密碼錯誤';
const g_strInTransaction = '該資料庫連接的事務處理未完成,請重試';
const g_strBusy = '服務器忙碌,請稍后重試';
const g_strNoDBType = '無此資料庫連接類型[%s]';
const g_strDBCount ='DB連接 : ';
const g_strClientCount='在線 : ';
const g_strCId='客戶端ID';
const g_strUId='用戶ID';
const g_strUName='姓名';
const g_strDepartment='部門';
const g_strIP='IP地址';
const g_strComputerName='計算機名稱';
const g_strLoginTime='登錄時間';
const g_strActiveTime='最近檢測時間';
const g_strOnLine='在線時間(小時)';
const g_strConnStrErr='無MSSQL資料庫連接字符串';

implementation

end.

