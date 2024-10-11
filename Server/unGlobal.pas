unit unGlobal;

interface

uses
  ADODB;

type
  PDBType = ^TDBType;
  TDBType = Record
    DBType,
    ConnStr     :string;
    InitCnt,
    ActiveCnt,
    InUseCnt    :Integer;
  end;

  PADOConn = ^TADOConn;
  TADOConn = Record
    ADOConn       :TADOConnection;
    DBType        :string;
    InUse         :Boolean;
    InitTime,
    LastWorkTime  :TDateTime;
  end;

  PUser = ^TUser;
  TUser = Record
    ClientId,
    UserId,
    IPAddress,
    Host       : string;
    LoginTime,
    LogoutTime : TDateTime;
    IsLogout   : Boolean;
  end;

TRefreshUser = (uNone, uUI, uDataUI);

var
  g_SysPath     : string;
  g_DefDBType   : string;
  g_RefreshUser : TRefreshUser;
  g_IsSaveUser    : Boolean;
  g_IsWriteLog  : Boolean;

const g_SPKey = #9;
const g_FreeMinute = 60;
const g_CloseMinute = 20;
const g_ShortMonth = 'YYYYMM';
const g_ShortDate = 'YYYYMMDD';
const g_LongTimeSP = 'YYYY/MM/DD HH:NN:SS';
const g_CocEmail = 'COCEmail.exe';

const g_InTransaction = '該資料庫連接的事務處理未完成,請重試';
const g_Busy = '服務器忙碌,請稍后重試';
const g_NoDBType = '無此資料庫連接類型[%s]';

implementation

end.
