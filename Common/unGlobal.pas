{*******************************************************}
{                                                       }
{                unGlobal                               }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 常量                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unGlobal;

interface

uses
  Windows, ComCtrls, Forms, DBClient, DBGridEh, ADODB, unDAL;

type
  TConnData = Record               //ADO連接記錄
    DBtype  :  String;             //資料庫類別
    ADOConn :  TADOConnection;     //TADOConnection
  end;

  TCustInfo = record
    No: string;
    Name: string;
    PartNo: string;
    PartName: string;
    Po: string;
    PoItm: integer;
  end;

type
  TArrConnData = Array of TConnData;   //ADO連接數組
  TArrDAL = Array of TDAL;             //ADO數據庫操作數組

type
  PUserInfo = ^ TUserInfo;
  TUserInfo = Packed Record      //用戶記錄
    BU,                          //廠別
    ShortName,                   //簡稱
    Cname,                       //中文名稱
    UserId,                      //帳號
    UserName,                    //姓名
    Depart,                      //部門
    Room,                        //課室
    Title,                       //職務
    Wk_no,                       //工號
    SysPath,                     //系統路徑
    TempPath,                    //OS臨時文件路徑
    LocalComputerName,           //Local ComputerName
    LocalIP,                     //Local IP
    Host,                        //Rdm IP
    ServerName,                  //Rdm 名稱
    ClientID,                    //Rdm返回給客戶端ID
    DBType          :String;     //默認資料庫
    Port            :Integer;    //Rdm端口號
    isCN,                        //系統語言
    isWideString    :Boolean;    //SQL使用雙字節
end;

type
  PMenuInfo = ^ TMenuInfo;
  TMenuInfo =  Packed Record     //作業記錄
    PId,                         //上級Id
    NId         : Integer;       //Id
    ProcId,                      //菜單編號
    ProcName,                    //菜單名稱
    DllPath,                     //Dll路徑
    Actions     : String;        //顯示按扭
    SnoAsc      : Integer;       //菜單位置
    IsExe,                       //此程式是可執行文件exe
    IsPop,                       //原作業模式:彈出作業
    R_visible,                   //顯示
    R_new,                       //新建
    R_edit,                      //更改
    R_delete,                    //刪除
    R_copy,                      //複製
    R_garbage,                   //作癈
    R_conf,                      //確認
    R_check,                     //審核
    R_query,                     //查詢
    R_print,                     //列印
    R_export,                    //導出Excel
    R_rptDesign : Boolean;       //報表設計
end;

//列印
type
  TPrintData = Record
    Data:             OleVariant; //數據包
    RecNo:            Integer;    //當前記錄
    IndexFieldNames,              //索引欄位
    Filter:           String;     //過濾
end;

type
  TArrPrintData = Array of TPrintData;

//匯出
type
  TExportObj = Record
    TableName,                   //表名(取欄位名稱)
    ProcId,                      //程式代碼
    XlsCaption,                  //Excel名稱
    IndexFieldNames: String;     //數據包的排序欄位
    Data:            OleVariant; //數據包
    RecNo:           Integer;    //當前記錄
end;

//unCommon.SetMoreGrdCaption
type
  TGrdEh = Record
    grdEh : array of TDBGridEh;
    tb    : array of string;
end;

//回調函數
type
  TCallBackProc = procedure(ProcId,ProcName,SBText:PChar; DllHandle,FormHandle:HWnd;
    isClose:Boolean);stdcall;

//查詢
type
  TQueryDllFunc = function (AppH:HWnd; UInfo: PUserInfo; ConnData:TArrConnData;
    tb, ProcId, OutSQL:PChar):Boolean; stdcall;

//匯出xls (RecNo=-1匯出全部數據)
type
  TExportDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo;
    ConnData:TArrConnData; Data:OleVariant; RecNo:Integer;
    tb, ProcId, XlsCaption, IndexFieldNames: PChar; PBar:TProgressBar); stdcall;

//列印 (R_rptDesign報表設計權限)
type
  TPrintDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo; ConnData:TArrConnData;
    ArrPrintData: TArrPrintData;
    SysId, ProcId: PChar; R_rptDesign: Boolean); stdcall;

//庫存查詢
type
  TStockDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo; MInfo: PMenuInfo;
    Pno, isMPS:PChar); stdcall;

//CCL料號
type
  TSplitMaterialno = Record
    M3_6:Double;
    M1,
    M2,
    M7,
    M8,
    M7_8,
    M9_11,
    M12_14,
    M15,
    MLast_1,     //倒數第2碼
    MLast,       //尾碼
    Custno,      //coc使用
    Custno2,     //終端客戶
    Err:string;
end;

//外賣PP料號
type
  TSplitMaterialnoPP = Record
    M1,
    M2,
    M3,
    M4_7,
    M8_10,
    M11_13,
    M14_16,
    M17,
    M18,
    Custno,      //coc使用
    Err:string;
end;

//半成品PP料號
type
  TSplitMaterialnoPPCore = Record
    M1,
    M2,
    M3,
    M4_5,                  //2碼
    M6_8,
    M9,
    M10,
    M11,
    M12,
    M13,
    MFiber,                //4碼
    Err:string;
end;

{變量}
var
  g_cbp             : TCallBackProc;      //回調函數
  g_DllHandle       : HWnd;               //dll handle
  g_MainHandle      : HWnd;               //exe handle
  g_UInfo           : PUserInfo;          //用戶信息
  g_MInfo           : PMenuInfo;          //作業權限
  g_StatusBar       : TStatusBar;         //狀態欄
  g_ProgressBar     : TProgressBar;       //進度條
  g_ExportObj       : TExportObj;         //匯出xls記錄
  g_PrintData       : TArrPrintData;      //列印記錄
  g_MachineCCL      : string;             //CCL機台
  g_MachinePP       : string;             //PP機台
  g_MachineCCL_DG   : string;             //DG CCL機台
  g_MachineCCL_GZ   : string;             //GZ CCL機台
  g_MachinePP_DG    : string;             //DG PP機台
  g_MachinePP_GZ    : string;             //GZ PP機台
  g_MPS012_Stype    : string;             //副排程類別
  g_ThinSize        : string;             //薄厚板分隔(大於或等於此值為厚板)
  g_PW              : string;             //密碼
  g_ConnData        : TArrConnData;       //ADO連接數組
  g_DAL             : TArrDAL;            //使用ADO連接時,對數據庫操作數組

{常量}
const g_Asc='△';
const g_Desc='▽';
const g_cLongTime ='YYYYMMDDHHNNSSZZZ';
const g_cLongTimeSP ='YYYY/MM/DD HH:NN:SS';
const g_cShortDate ='YYYY/M/D';
const g_cShortDate1 ='YYYY/MM/DD';
const g_cShortDateYYMMDD ='YYMMDD';
const g_cFilterNothing = 'and 1<>1';
const g_OZ='ZZ@@';
const g_Jitem=999;
const g_WonoNormalFlag=99;   //正常結案工單
const g_WonoErrorFlag=88;    //異常結案工單(88+站別)

const g_DGLastCode='X,N,3,W,K,R,9,Q,H,I,S,1,7,V,Y,Z';  //東莞尾碼
const g_GZLastCode='G,g,n,z,w,k,r,9,h,s,v,R,F';        //廣州尾碼

const g_CocData=999;

implementation

end.
