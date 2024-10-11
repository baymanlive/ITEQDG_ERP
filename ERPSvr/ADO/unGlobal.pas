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
  g_ArrUser       : array [0..499] of TUser;  //������Ҳ��Ӱ�

const g_strFreeMinute = 60;
const g_strCloseMinute = 20;
const g_strShortMonth = 'YYYYMM';
const g_strShortDate = 'YYYYMMDD';
const g_strCocEmail = 'COCEmail.exe';
const g_strAppTitle = 'ERP���÷�����';
const g_strMenu='�ˆ�';
const g_strMenuShow='�@ʾ';
const g_strMenuExit='�˳�';
const g_strHint = '��ʾ';
const g_strConfigNotExists='[%s] ���Ùn��������';
const g_strExit='ȷ���˳���?';
const g_strIsRUN=',�ѽ����_';
const g_strPWErr='��̖���ܴa�e�`';
const g_strInTransaction = 'ԓ�Y�ώ��B�ӵ���̎��δ���,Ո��ԇ';
const g_strBusy = '������æµ,Ո�Ժ���ԇ';
const g_strNoDBType = '�o���Y�ώ��B�����[%s]';
const g_strDBCount ='DB�B�� : ';
const g_strClientCount='�ھ� : ';
const g_strCId='�͑���ID';
const g_strUId='�Ñ�ID';
const g_strUName='����';
const g_strDepartment='���T';
const g_strIP='IP��ַ';
const g_strComputerName='Ӌ��C���Q';
const g_strLoginTime='��䛕r�g';
const g_strActiveTime='����z�y�r�g';
const g_strOnLine='�ھ��r�g(С�r)';
const g_strConnStrErr='�oMSSQL�Y�ώ��B���ַ���';

implementation

end.

