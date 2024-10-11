{*******************************************************}
{                                                       }
{                unGlobal                               }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: �`�q                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unGlobal;

interface

uses
  Windows, ComCtrls, Forms, DBClient, DBGridEh, ADODB, unDAL;

type
  TConnData = Record               //ADO�s���O��
    DBtype  :  String;             //��Ʈw���O
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
  TArrConnData = Array of TConnData;   //ADO�s���Ʋ�
  TArrDAL = Array of TDAL;             //ADO�ƾڮw�ާ@�Ʋ�

type
  PUserInfo = ^ TUserInfo;
  TUserInfo = Packed Record      //�Τ�O��
    BU,                          //�t�O
    ShortName,                   //²��
    Cname,                       //����W��
    UserId,                      //�b��
    UserName,                    //�m�W
    Depart,                      //����
    Room,                        //�ҫ�
    Title,                       //¾��
    Wk_no,                       //�u��
    SysPath,                     //�t�θ��|
    TempPath,                    //OS�{�ɤ����|
    LocalComputerName,           //Local ComputerName
    LocalIP,                     //Local IP
    Host,                        //Rdm IP
    ServerName,                  //Rdm �W��
    ClientID,                    //Rdm��^���Ȥ��ID
    DBType          :String;     //�q�{��Ʈw
    Port            :Integer;    //Rdm�ݤf��
    isCN,                        //�t�λy��
    isWideString    :Boolean;    //SQL�ϥ����r�`
end;

type
  PMenuInfo = ^ TMenuInfo;
  TMenuInfo =  Packed Record     //�@�~�O��
    PId,                         //�W��Id
    NId         : Integer;       //Id
    ProcId,                      //���s��
    ProcName,                    //���W��
    DllPath,                     //Dll���|
    Actions     : String;        //��ܫ���
    SnoAsc      : Integer;       //����m
    IsExe,                       //���{���O�i������exe
    IsPop,                       //��@�~�Ҧ�:�u�X�@�~
    R_visible,                   //���
    R_new,                       //�s��
    R_edit,                      //���
    R_delete,                    //�R��
    R_copy,                      //�ƻs
    R_garbage,                   //�@�u
    R_conf,                      //�T�{
    R_check,                     //�f��
    R_query,                     //�d��
    R_print,                     //�C�L
    R_export,                    //�ɥXExcel
    R_rptDesign : Boolean;       //����]�p
end;

//�C�L
type
  TPrintData = Record
    Data:             OleVariant; //�ƾڥ]
    RecNo:            Integer;    //��e�O��
    IndexFieldNames,              //�������
    Filter:           String;     //�L�o
end;

type
  TArrPrintData = Array of TPrintData;

//�ץX
type
  TExportObj = Record
    TableName,                   //��W(�����W��)
    ProcId,                      //�{���N�X
    XlsCaption,                  //Excel�W��
    IndexFieldNames: String;     //�ƾڥ]���Ƨ����
    Data:            OleVariant; //�ƾڥ]
    RecNo:           Integer;    //��e�O��
end;

//unCommon.SetMoreGrdCaption
type
  TGrdEh = Record
    grdEh : array of TDBGridEh;
    tb    : array of string;
end;

//�^�ը��
type
  TCallBackProc = procedure(ProcId,ProcName,SBText:PChar; DllHandle,FormHandle:HWnd;
    isClose:Boolean);stdcall;

//�d��
type
  TQueryDllFunc = function (AppH:HWnd; UInfo: PUserInfo; ConnData:TArrConnData;
    tb, ProcId, OutSQL:PChar):Boolean; stdcall;

//�ץXxls (RecNo=-1�ץX�����ƾ�)
type
  TExportDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo;
    ConnData:TArrConnData; Data:OleVariant; RecNo:Integer;
    tb, ProcId, XlsCaption, IndexFieldNames: PChar; PBar:TProgressBar); stdcall;

//�C�L (R_rptDesign����]�p�v��)
type
  TPrintDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo; ConnData:TArrConnData;
    ArrPrintData: TArrPrintData;
    SysId, ProcId: PChar; R_rptDesign: Boolean); stdcall;

//�w�s�d��
type
  TStockDllFunc = procedure (AppH:HWnd; UInfo: PUserInfo; MInfo: PMenuInfo;
    Pno, isMPS:PChar); stdcall;

//CCL�Ƹ�
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
    MLast_1,     //�˼Ʋ�2�X
    MLast,       //���X
    Custno,      //coc�ϥ�
    Custno2,     //�׺ݫȤ�
    Err:string;
end;

//�~��PP�Ƹ�
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
    Custno,      //coc�ϥ�
    Err:string;
end;

//�b���~PP�Ƹ�
type
  TSplitMaterialnoPPCore = Record
    M1,
    M2,
    M3,
    M4_5,                  //2�X
    M6_8,
    M9,
    M10,
    M11,
    M12,
    M13,
    MFiber,                //4�X
    Err:string;
end;

{�ܶq}
var
  g_cbp             : TCallBackProc;      //�^�ը��
  g_DllHandle       : HWnd;               //dll handle
  g_MainHandle      : HWnd;               //exe handle
  g_UInfo           : PUserInfo;          //�Τ�H��
  g_MInfo           : PMenuInfo;          //�@�~�v��
  g_StatusBar       : TStatusBar;         //���A��
  g_ProgressBar     : TProgressBar;       //�i�ױ�
  g_ExportObj       : TExportObj;         //�ץXxls�O��
  g_PrintData       : TArrPrintData;      //�C�L�O��
  g_MachineCCL      : string;             //CCL���x
  g_MachinePP       : string;             //PP���x
  g_MachineCCL_DG   : string;             //DG CCL���x
  g_MachineCCL_GZ   : string;             //GZ CCL���x
  g_MachinePP_DG    : string;             //DG PP���x
  g_MachinePP_GZ    : string;             //GZ PP���x
  g_MPS012_Stype    : string;             //�ƱƵ{���O
  g_ThinSize        : string;             //���p�O���j(�j��ε��󦹭Ȭ��p�O)
  g_PW              : string;             //�K�X
  g_ConnData        : TArrConnData;       //ADO�s���Ʋ�
  g_DAL             : TArrDAL;            //�ϥ�ADO�s����,��ƾڮw�ާ@�Ʋ�

{�`�q}
const g_Asc='��';
const g_Desc='��';
const g_cLongTime ='YYYYMMDDHHNNSSZZZ';
const g_cLongTimeSP ='YYYY/MM/DD HH:NN:SS';
const g_cShortDate ='YYYY/M/D';
const g_cShortDate1 ='YYYY/MM/DD';
const g_cShortDateYYMMDD ='YYMMDD';
const g_cFilterNothing = 'and 1<>1';
const g_OZ='ZZ@@';
const g_Jitem=999;
const g_WonoNormalFlag=99;   //���`���פu��
const g_WonoErrorFlag=88;    //���`���פu��(88+���O)

const g_DGLastCode='X,N,3,W,K,R,9,Q,H,I,S,1,7,V,Y,Z';  //�F����X
const g_GZLastCode='G,g,n,z,w,k,r,9,h,s,v,R,F';        //�s�{���X

const g_CocData=999;

implementation

end.
