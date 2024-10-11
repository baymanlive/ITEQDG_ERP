{*******************************************************}
{                                                       }
{                DLIR141.exe                            }
{                Author: kaikai                         }
{                Create date: 2020/4/7                  }
{                Description: �e10�j�Ȥ�Lead Time�ޱ��� }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Menus, ExtCtrls, DateUtils, Math,
  ExcelXP, Provider, ComCtrls, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IniFiles, StrUtils;

type
  TRec = Record
    OrdCnt,
    SumLT   : Integer;
  end;

  TAdObj = Record
    Ad      : string;
    LT      : Integer;
    Data    : array [0..2] of TRec;  //0:ok 1:PO���w��� 2:������F��
    Show    : Boolean;               //l_ArrAd�Ψ�,�����P�_�����O�_���
  end;

  TCustomerObj = Record
    Name,
    Custno  : string;
    Obj     : array of TAdObj;
    Show    : Boolean;               //l_ArrCustomer�Ψ�,�����P�_�����O�_���
  end;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    m1: TMenuItem;
    ADOConn: TADOConnection;
    ADOQuery1: TADOQuery;
    N1: TMenuItem;
    pb: TProgressBar;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    ADOQuery2: TADOQuery;
    ORAConn: TADOConnection;
    ADOQuery3: TADOQuery;
    ADOQuery4: TADOQuery;
    ADOQuery5: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    l_ArrAd1:array [0..99] of TAdObj;              //�W��,���tLT���`,�̦h100�ӽ��t
    l_ArrAd2:array [0..99] of TAdObj;              //���,���tLT���`,�̦h100�ӽ��t
    l_ArrCustomer1:array [0..10] of TCustomerObj;  //�W��,�e10�j�Ȥ�LT���`
    l_ArrCustomer2:array [0..10] of TCustomerObj;  //���,�e10�j�Ȥ�LT���`
    l_mailFrom,l_mailTo:string;
    procedure InitArrAd;
    procedure InitArrCustomer;
    procedure ClearArrAd1;
    procedure ClearArrAd2;
    procedure ClearArrCustomer1;
    procedure ClearArrCustomer2;
    procedure UpdateArrAd1(ad:string;lt,dataIndex:Integer);
    procedure UpdateArrAd2(ad:string;lt,dataIndex:Integer);
    procedure UpdateArrCustomer1(custno,ad:string;lt,dataIndex:Integer);
    procedure UpdateArrCustomer2(custno,ad:string;lt,dataIndex:Integer);
    function CheckAdLT1(ad:string; LT:Integer; var retLT:Integer):Boolean;
    function CheckAdLT2(ad:string; LT:Integer; var retLT:Integer):Boolean;
    function CheckCustomerLT(custno,ad:string; LT:Integer; var retLT:Integer):Boolean;
    function GetRpt(var xfname,xfpath:string):Boolean;
    function SendEmail(xfname,xfpath:string):Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  l_path:string;

implementation

uses ComObj;

const l_defLT=7;

{$R *.dfm}

//�ѱK
function Decrypt(Value:string):string;
type
  TEncrypt = procedure (SourceStr, DestStr:PChar);stdcall;
var
  DllHandle:HWnd;
  DllFunc:TEncrypt;
  P:PChar;
begin
  Result:='';
  DllHandle:=LoadLibrary('Encrypt.dll');
  if DllHandle<>0 then
  begin
    @DllFunc:=GetProcAddress(DllHandle, 'Decrypt');
    if @DllFunc<>nil then
    begin
      P:=StrAlloc(1024);
      try
        DllFunc(PChar(Value), P);
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

//�K�[���~�H����O�����
procedure LogInfo(Err: string);
var
  tmpStr: string;
  txt: TextFile;
begin
  tmpStr:=l_path + 'Error';
  if not DirectoryExists(tmpStr) then
     CreateDir(tmpStr);
  tmpStr:=tmpStr + '\' +FormatDateTime('YYYYMM', Date);
  if not DirectoryExists(tmpStr) then
     CreateDir(tmpStr);
  tmpStr:= tmpStr + '\' +FormatDateTime('YYYYMMDD', Date) + '.txt';
  AssignFile(txt, tmpStr);
  if not FileExists(tmpStr) then
     Rewrite(txt);
  Append(txt);
  Write(txt, DateTimeToStr(Now)+#13#10+Err+#13#10);
  CloseFile(txt);
end;

//��l�ƽ��tLT:l_ArrAd1�Bl_ArrAd2
//�X�}�����t:IT168G&IT168G1�BIT170GRA&IT170GRA1�B140G&150G
//SQL�y�y�w�g���F����:IT168G=>IT168G1�BIT170GRA=>IT170GRA1�B140G=>150G
procedure TForm1.InitArrAd;
//�w�����t��LT
const strAd='IT140,IT150DA,IT150G,IT150GS,IT150GTA1,IT158,IT168G1,IT170GRA1,IT170GRA2,IT170GT,IT180,IT180A,IT180I,IT200LK,IT88GMW,IT958G,IT958GQ,IT968,IT968SE,IT988G,IT988GSE';
const strLT='15,7,5,7,15,7,5,5,7,7,7,7,7,7,12,12,12,12,12,12,12';
var
  i:Integer;
  tmpAdList:TStrings;
  tmpLTList:TStrings;
begin
  tmpAdList:=TStringList.Create;
  tmpLTList:=TStringList.Create;
  try
    tmpAdList.DelimitedText:=strAd;
    tmpLTList.DelimitedText:=strLT;
    for i:=0 to tmpAdList.Count-1 do
    begin
      l_ArrAd1[i].Show:=False;
      l_ArrAd1[i].Ad:=tmpAdList.Strings[i];
      l_ArrAd1[i].LT:=StrToInt(tmpLTList.Strings[i]);
      l_ArrAd1[i].Data[0].OrdCnt:=0;
      l_ArrAd1[i].Data[0].SumLT:=0;
      l_ArrAd1[i].Data[1].OrdCnt:=0;
      l_ArrAd1[i].Data[1].SumLT:=0;
      l_ArrAd1[i].Data[2].OrdCnt:=0;
      l_ArrAd1[i].Data[2].SumLT:=0;
    end;

    for i:=tmpAdList.Count to High(l_ArrAd1) do
    begin
      l_ArrAd1[i].Show:=False;
      l_ArrAd1[i].Ad:='';
      l_ArrAd1[i].LT:=0;
      l_ArrAd1[i].Data[0].OrdCnt:=0;
      l_ArrAd1[i].Data[0].SumLT:=0;
      l_ArrAd1[i].Data[1].OrdCnt:=0;
      l_ArrAd1[i].Data[1].SumLT:=0;
      l_ArrAd1[i].Data[2].OrdCnt:=0;
      l_ArrAd1[i].Data[2].SumLT:=0;
    end;

    for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
    begin
      l_ArrAd2[i].Show:=False;
      l_ArrAd2[i].Ad:=l_ArrAd1[i].Ad;
      l_ArrAd2[i].LT:=l_ArrAd1[i].LT;
      l_ArrAd2[i].Data[0].OrdCnt:=0;
      l_ArrAd2[i].Data[0].SumLT:=0;
      l_ArrAd2[i].Data[1].OrdCnt:=0;
      l_ArrAd2[i].Data[1].SumLT:=0;
      l_ArrAd2[i].Data[2].OrdCnt:=0;
      l_ArrAd2[i].Data[2].SumLT:=0;
    end;

  finally
    FreeAndNil(tmpAdList);
    FreeAndNil(tmpLTList);
  end;
end;

//��l��10�j�Ȥ�LT:InitArrCustomer1�BInitArrCustomer2
procedure TForm1.InitArrCustomer;
var
  i,j:Integer;
begin
  l_ArrCustomer1[0].Name:='TTM����';
  l_ArrCustomer1[0].Custno:=',AC082,AC093,AC152,AC178,AC282,AC394,AC844,AH035,';
  SetLength(l_ArrCustomer1[0].Obj,4);
  l_ArrCustomer1[0].Obj[0].Ad:='IT9';
  l_ArrCustomer1[0].Obj[0].LT:=15;
  l_ArrCustomer1[0].Obj[1].Ad:='IT140/IT180';
  l_ArrCustomer1[0].Obj[1].LT:=15;
  l_ArrCustomer1[0].Obj[2].Ad:='IT158/IT180A';
  l_ArrCustomer1[0].Obj[2].LT:=7;
  l_ArrCustomer1[0].Obj[3].Ad:='�䥦';
  l_ArrCustomer1[0].Obj[3].LT:=7;

  l_ArrCustomer1[1].Name:='���I����';
  l_ArrCustomer1[1].Custno:=',AC136,ACA27,';
  SetLength(l_ArrCustomer1[1].Obj,3);
  l_ArrCustomer1[1].Obj[0].Ad:='IT9';
  l_ArrCustomer1[1].Obj[0].LT:=10;
  l_ArrCustomer1[1].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[1].Obj[1].LT:=7;
  l_ArrCustomer1[1].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[1].Obj[2].LT:=7;

  l_ArrCustomer1[2].Name:='�西����';
  l_ArrCustomer1[2].Custno:=',AC114,AC365,AC388,AC687,AC434,';
  SetLength(l_ArrCustomer1[2].Obj,3);
  l_ArrCustomer1[2].Obj[0].Ad:='IT9';
  l_ArrCustomer1[2].Obj[0].LT:=12;
  l_ArrCustomer1[2].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[2].Obj[1].LT:=7;
  l_ArrCustomer1[2].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[2].Obj[2].LT:=7;

  l_ArrCustomer1[3].Name:='�ͯq';
  l_ArrCustomer1[3].Custno:=',AC084,';
  SetLength(l_ArrCustomer1[3].Obj,3);
  l_ArrCustomer1[3].Obj[0].Ad:='IT9';
  l_ArrCustomer1[3].Obj[0].LT:=10;
  l_ArrCustomer1[3].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[3].Obj[1].LT:=7;
  l_ArrCustomer1[3].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[3].Obj[2].LT:=8;

  l_ArrCustomer1[4].Name:='�̹y';
  l_ArrCustomer1[4].Custno:=',AC151,';
  SetLength(l_ArrCustomer1[4].Obj,2);
  l_ArrCustomer1[4].Obj[0].Ad:='IT158/IT180A';
  l_ArrCustomer1[4].Obj[0].LT:=7;
  l_ArrCustomer1[4].Obj[1].Ad:='�䥦';
  l_ArrCustomer1[4].Obj[1].LT:=7;

  l_ArrCustomer1[5].Name:='�R�F����';
  l_ArrCustomer1[5].Custno:=',AC305,AC526,AC121,AC820,ACA97,';
  SetLength(l_ArrCustomer1[5].Obj,4);
  l_ArrCustomer1[5].Obj[0].Ad:='IT9';
  l_ArrCustomer1[5].Obj[0].LT:=7;
  l_ArrCustomer1[5].Obj[1].Ad:='IT140/IT180';
  l_ArrCustomer1[5].Obj[1].LT:=15;
  l_ArrCustomer1[5].Obj[2].Ad:='IT158/IT180A';
  l_ArrCustomer1[5].Obj[2].LT:=5;
  l_ArrCustomer1[5].Obj[3].Ad:='�䥦';
  l_ArrCustomer1[5].Obj[3].LT:=5;

  l_ArrCustomer1[6].Name:='�`�n';
  l_ArrCustomer1[6].Custno:=',AC111,';
  SetLength(l_ArrCustomer1[6].Obj,4);
  l_ArrCustomer1[6].Obj[0].Ad:='IT9';
  l_ArrCustomer1[6].Obj[0].LT:=20;
  l_ArrCustomer1[6].Obj[1].Ad:='IT140/IT180';
  l_ArrCustomer1[6].Obj[1].LT:=15;
  l_ArrCustomer1[6].Obj[2].Ad:='IT158/IT180A';
  l_ArrCustomer1[6].Obj[2].LT:=10;
  l_ArrCustomer1[6].Obj[3].Ad:='�䥦';
  l_ArrCustomer1[6].Obj[3].LT:=7;

  l_ArrCustomer1[7].Name:='�ӧ�';
  l_ArrCustomer1[7].Custno:=',AC360,AC085,';
  SetLength(l_ArrCustomer1[7].Obj,3);
  l_ArrCustomer1[7].Obj[0].Ad:='IT9';
  l_ArrCustomer1[7].Obj[0].LT:=12;
  l_ArrCustomer1[7].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[7].Obj[1].LT:=10;
  l_ArrCustomer1[7].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[7].Obj[2].LT:=10;

  l_ArrCustomer1[8].Name:='�سq����';
  l_ArrCustomer1[8].Custno:=',AC109,AC994,ACB16,';
  SetLength(l_ArrCustomer1[8].Obj,3);
  l_ArrCustomer1[8].Obj[0].Ad:='IT9';
  l_ArrCustomer1[8].Obj[0].LT:=10;
  l_ArrCustomer1[8].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[8].Obj[1].LT:=7;
  l_ArrCustomer1[8].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[8].Obj[2].LT:=7;

  l_ArrCustomer1[9].Name:='�W�ݶ���';
  l_ArrCustomer1[9].Custno:=',AC075,AC310,AC311,AC405,AC950,';
  SetLength(l_ArrCustomer1[9].Obj,3);
  l_ArrCustomer1[9].Obj[0].Ad:='IT9';
  l_ArrCustomer1[9].Obj[0].LT:=15;
  l_ArrCustomer1[9].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[9].Obj[1].LT:=7;
  l_ArrCustomer1[9].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[9].Obj[2].LT:=10;

  l_ArrCustomer1[10].Name:='�s�X����';
  l_ArrCustomer1[10].Custno:=',AC117,ACC19,';
  SetLength(l_ArrCustomer1[10].Obj,3);
  l_ArrCustomer1[10].Obj[0].Ad:='IT9';
  l_ArrCustomer1[10].Obj[0].LT:=10;
  l_ArrCustomer1[10].Obj[1].Ad:='IT158/IT180A';
  l_ArrCustomer1[10].Obj[1].LT:=7;
  l_ArrCustomer1[10].Obj[2].Ad:='�䥦';
  l_ArrCustomer1[10].Obj[2].LT:=7;

  ClearArrCustomer1;

  for i:=Low(l_ArrCustomer1) to High(l_ArrCustomer1) do
  begin
    l_ArrCustomer2[i].Show:=False;
    l_ArrCustomer2[i].Name:=l_ArrCustomer1[i].Name;
    l_ArrCustomer2[i].Custno:=l_ArrCustomer1[i].Custno;
    SetLength(l_ArrCustomer2[i].Obj,Length(l_ArrCustomer1[i].Obj));
    for j:=Low(l_ArrCustomer2[i].Obj) to High(l_ArrCustomer2[i].Obj) do
    begin
      l_ArrCustomer2[i].Obj[j].Ad:=l_ArrCustomer1[i].Obj[j].Ad;
      l_ArrCustomer2[i].Obj[j].LT:=l_ArrCustomer1[i].Obj[j].LT;
    end;
  end;
end;

//�M���ƾ�ClearArrAd1
procedure TForm1.ClearArrAd1;
var
  i:Integer;
begin
  for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
  begin
    if l_ArrAd1[i].LT=0 then
       Break;

    l_ArrAd1[i].Show:=False;
    l_ArrAd1[i].Data[0].OrdCnt:=0;
    l_ArrAd1[i].Data[0].SumLT:=0;
    l_ArrAd1[i].Data[1].OrdCnt:=0;
    l_ArrAd1[i].Data[1].SumLT:=0;
    l_ArrAd1[i].Data[2].OrdCnt:=0;
    l_ArrAd1[i].Data[2].SumLT:=0;
  end;
end;

//�M���ƾ�ClearArrAd2
procedure TForm1.ClearArrAd2;
var
  i:Integer;
begin
  for i:=Low(l_ArrAd2) to High(l_ArrAd2) do
  begin
    if l_ArrAd2[i].LT=0 then
       Break;

    l_ArrAd2[i].Show:=False;
    l_ArrAd2[i].Data[0].OrdCnt:=0;
    l_ArrAd2[i].Data[0].SumLT:=0;
    l_ArrAd2[i].Data[1].OrdCnt:=0;
    l_ArrAd2[i].Data[1].SumLT:=0;
    l_ArrAd2[i].Data[2].OrdCnt:=0;
    l_ArrAd2[i].Data[2].SumLT:=0;
  end;
end;

//�M���ƾ�l_ArrCustomer1
procedure TForm1.ClearArrCustomer1;
var
  i,j:Integer;
begin
  for i:=Low(l_ArrCustomer1) to High(l_ArrCustomer1) do
  begin
    l_ArrCustomer1[i].Show:=False;
    for j:=Low(l_ArrCustomer1[i].Obj) to High(l_ArrCustomer1[i].Obj) do
    begin
      l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt:=0;
      l_ArrCustomer1[i].Obj[j].Data[0].SumLT:=0;
      l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt:=0;
      l_ArrCustomer1[i].Obj[j].Data[1].SumLT:=0;
      l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt:=0;
      l_ArrCustomer1[i].Obj[j].Data[2].SumLT:=0;
      l_ArrCustomer1[i].Obj[j].Show:=False;          //�o����show�ݩ�l_ArrCustomer1���ϥ�
    end;
  end;
end;

//�M���ƾ�l_ArrCustomer2
procedure TForm1.ClearArrCustomer2;
var
  i,j:Integer;
begin
  for i:=Low(l_ArrCustomer2) to High(l_ArrCustomer2) do
  begin
    l_ArrCustomer2[i].Show:=False;
    for j:=Low(l_ArrCustomer2[i].Obj) to High(l_ArrCustomer2[i].Obj) do
    begin
      l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt:=0;
      l_ArrCustomer2[i].Obj[j].Data[0].SumLT:=0;
      l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt:=0;
      l_ArrCustomer2[i].Obj[j].Data[1].SumLT:=0;
      l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt:=0;
      l_ArrCustomer2[i].Obj[j].Data[2].SumLT:=0;
      l_ArrCustomer2[i].Obj[j].Show:=False;          //�o����show�ݩ�l_ArrCustomer2���ϥ�
    end;
  end;
end;

//��sl_ArrAd1,���s�b���K�[
procedure TForm1.UpdateArrAd1(ad:string;lt,dataIndex:Integer);
var
  isFind:Boolean;
  i:Integer;
begin
  isFind:=False;
  for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
  if SameText(l_ArrAd1[i].Ad,ad) then
  begin
    isFind:=True;
    l_ArrAd1[i].Show:=True;
    l_ArrAd1[i].Data[dataIndex].OrdCnt:=l_ArrAd1[i].Data[dataIndex].OrdCnt+1;
    l_ArrAd1[i].Data[dataIndex].SumLT:=l_ArrAd1[i].Data[dataIndex].SumLT+lt;
    Break;
  end;

  if not isFind then
  for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
  if l_ArrAd1[i].LT=0 then
  begin
    l_ArrAd1[i].Show:=True;
    l_ArrAd1[i].Ad:=UpperCase(ad);
    l_ArrAd1[i].LT:=l_defLT;
    l_ArrAd1[i].Data[0].OrdCnt:=0;
    l_ArrAd1[i].Data[0].SumLT:=0;
    l_ArrAd1[i].Data[1].OrdCnt:=0;
    l_ArrAd1[i].Data[1].SumLT:=0;
    l_ArrAd1[i].Data[2].OrdCnt:=0;
    l_ArrAd1[i].Data[2].SumLT:=0;

    l_ArrAd1[i].Data[dataIndex].OrdCnt:=l_ArrAd1[i].Data[dataIndex].OrdCnt+1;
    l_ArrAd1[i].Data[dataIndex].SumLT:=l_ArrAd1[i].Data[dataIndex].SumLT+lt;
    Break;
  end;
end;

//��sl_ArrAd2,���s�b���K�[
procedure TForm1.UpdateArrAd2(ad:string;lt,dataIndex:Integer);
var
  isFind:Boolean;
  i:Integer;
begin
  isFind:=False;
  for i:=Low(l_ArrAd2) to High(l_ArrAd2) do
  if SameText(l_ArrAd2[i].Ad,ad) then
  begin
    isFind:=True;
    l_ArrAd2[i].Show:=True;
    l_ArrAd2[i].Data[dataIndex].OrdCnt:=l_ArrAd2[i].Data[dataIndex].OrdCnt+1;
    l_ArrAd2[i].Data[dataIndex].SumLT:=l_ArrAd2[i].Data[dataIndex].SumLT+lt;
    Break;
  end;

  if not isFind then
  for i:=Low(l_ArrAd2) to High(l_ArrAd2) do
  if l_ArrAd2[i].LT=0 then
  begin
    l_ArrAd2[i].Show:=True;
    l_ArrAd2[i].Ad:=UpperCase(ad);
    l_ArrAd2[i].LT:=l_defLT;
    l_ArrAd2[i].Data[0].OrdCnt:=0;
    l_ArrAd2[i].Data[0].SumLT:=0;
    l_ArrAd2[i].Data[1].OrdCnt:=0;
    l_ArrAd2[i].Data[1].SumLT:=0;
    l_ArrAd2[i].Data[2].OrdCnt:=0;
    l_ArrAd2[i].Data[2].SumLT:=0;

    l_ArrAd2[i].Data[dataIndex].OrdCnt:=l_ArrAd2[i].Data[dataIndex].OrdCnt+1;
    l_ArrAd2[i].Data[dataIndex].SumLT:=l_ArrAd2[i].Data[dataIndex].SumLT+lt;
    Break;
  end;
end;

//��sl_ArrCustomer1
procedure TForm1.UpdateArrCustomer1(custno,ad:string;lt,dataIndex:Integer);
var
  isFind:Boolean;
  i,j:Integer;
  tmpCustno,tmpAd_3:string;
begin
  tmpCustno:=','+custno+',';
  tmpAd_3:=Copy(ad,1,3); //���t�e3�X�O�_�OIT9

  for i:=Low(l_ArrCustomer1) to High(l_ArrCustomer1) do
  if Pos(tmpCustno,l_ArrCustomer1[i].Custno)>0 then  //�������Ȥ�
  begin
    l_ArrCustomer1[i].Show:=True;

    //���t�e3�X�p�G�OIT9,�@�w�O�bl_ArrCustomer1[i].Obj[0]��
    if SameText(tmpAd_3,'IT9') and SameText(l_ArrCustomer1[i].Obj[0].Ad,tmpAd_3) then
    begin
      l_ArrCustomer1[i].Obj[0].Data[dataIndex].OrdCnt:=l_ArrCustomer1[i].Obj[0].Data[dataIndex].OrdCnt+1;
      l_ArrCustomer1[i].Obj[0].Data[dataIndex].SumLT:=l_ArrCustomer1[i].Obj[0].Data[dataIndex].SumLT+lt;
    end else
    begin
      isFind:=False;
      for j:=Low(l_ArrCustomer1[i].Obj) to High(l_ArrCustomer1[i].Obj)-1 do //-1:�̦Z�@���O"�䥦",���γB�z
      begin
        if Pos('/'+ad+'/','/'+l_ArrCustomer1[i].Obj[j].Ad+'/')>0 then
        begin
          isFind:=True;
          l_ArrCustomer1[i].Obj[j].Data[dataIndex].OrdCnt:=l_ArrCustomer1[i].Obj[j].Data[dataIndex].OrdCnt+1;
          l_ArrCustomer1[i].Obj[j].Data[dataIndex].SumLT:=l_ArrCustomer1[i].Obj[j].Data[dataIndex].SumLT+lt;
          Break;
        end;
      end;

      //�����,��b"�䥦"��,�C�Ӷ��س̦Z�@���O"�䥦"
      if not isFind then
      begin
        j:=High(l_ArrCustomer1[i].Obj);
        l_ArrCustomer1[i].Obj[j].Data[dataIndex].OrdCnt:=l_ArrCustomer1[i].Obj[j].Data[dataIndex].OrdCnt+1;
        l_ArrCustomer1[i].Obj[j].Data[dataIndex].SumLT:=l_ArrCustomer1[i].Obj[j].Data[dataIndex].SumLT+lt;
      end;
    end;

    Break;
  end;
end;

//��sl_ArrCustomer2
procedure TForm1.UpdateArrCustomer2(custno,ad:string;lt,dataIndex:Integer);
var
  isFind:Boolean;
  i,j:Integer;
  tmpCustno,tmpAd_3:string;
begin
  tmpCustno:=','+custno+',';
  tmpAd_3:=Copy(ad,1,3); //���t�e3�X�O�_�OIT9

  for i:=Low(l_ArrCustomer2) to High(l_ArrCustomer2) do
  if Pos(tmpCustno,l_ArrCustomer2[i].Custno)>0 then  //�������Ȥ�
  begin
    l_ArrCustomer2[i].Show:=True;

    //���t�e3�X�p�G�OIT9,�@�w�O�bl_ArrCustomer2[i].Obj[0]��
    if SameText(tmpAd_3,'IT9') and SameText(l_ArrCustomer2[i].Obj[0].Ad,tmpAd_3) then
    begin
      l_ArrCustomer2[i].Obj[0].Data[dataIndex].OrdCnt:=l_ArrCustomer2[i].Obj[0].Data[dataIndex].OrdCnt+1;
      l_ArrCustomer2[i].Obj[0].Data[dataIndex].SumLT:=l_ArrCustomer2[i].Obj[0].Data[dataIndex].SumLT+lt;
    end else
    begin
      isFind:=False;
      for j:=Low(l_ArrCustomer2[i].Obj) to High(l_ArrCustomer2[i].Obj)-1 do //-1:�̦Z�@���O"�䥦",���γB�z
      begin
        if Pos('/'+ad+'/','/'+l_ArrCustomer2[i].Obj[j].Ad+'/')>0 then
        begin
          isFind:=True;
          l_ArrCustomer2[i].Obj[j].Data[dataIndex].OrdCnt:=l_ArrCustomer2[i].Obj[j].Data[dataIndex].OrdCnt+1;
          l_ArrCustomer2[i].Obj[j].Data[dataIndex].SumLT:=l_ArrCustomer2[i].Obj[j].Data[dataIndex].SumLT+lt;
          Break;
        end;
      end;

      //�����,��b"�䥦"��,�C�Ӷ��س̦Z�@���O"�䥦"
      if not isFind then
      begin
        j:=High(l_ArrCustomer2[i].Obj);
        l_ArrCustomer2[i].Obj[j].Data[dataIndex].OrdCnt:=l_ArrCustomer2[i].Obj[j].Data[dataIndex].OrdCnt+1;
        l_ArrCustomer2[i].Obj[j].Data[dataIndex].SumLT:=l_ArrCustomer2[i].Obj[j].Data[dataIndex].SumLT+lt;
      end;
    end;

    Break;
  end;
end;

//l_ArrAd1
//�ˬd���t�O�_�ŦXLT
//True:���ŦX,False:�ŦX
function TForm1.CheckAdLT1(ad:string; LT:Integer; var retLT:Integer):Boolean;
var
  i:Integer;
  isFind:Boolean;
begin
  Result:=False;
  retLT:=0;

  isFind:=False;
  for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
  if SameText(l_ArrAd1[i].Ad,ad) then
  begin
    retLT:=l_ArrAd1[i].LT;
    if LT>retLT then
       Result:=True;
    isFind:=True;
    Break;
  end;

  //���s�b��,��ܥ�����LUpdateArrAd1,�q�{LT=7
  if not isFind then
  begin
    retLT:=l_defLT;
     if LT>retLT then
        Result:=True;
  end;
end;

//l_ArrAd2
//�ˬd���t�O�_�ŦXLT
//True:���ŦX,False:�ŦX
function TForm1.CheckAdLT2(ad:string; LT:Integer; var retLT:Integer):Boolean;
var
  i:Integer;
  isFind:Boolean;
begin
  Result:=False;
  retLT:=0;
  
  isFind:=False;
  for i:=Low(l_ArrAd2) to High(l_ArrAd2) do
  if SameText(l_ArrAd2[i].Ad,ad) then
  begin
    retLT:=l_ArrAd2[i].LT;
    if LT>retLT then
       Result:=True;
    isFind:=True;
    Break;
  end;

  //���s�b��,��ܥ�����LUpdateArrAd2,�q�{LT=7
  if not isFind then
  begin
    retLT:=l_defLT;
    if LT>retLT then
       Result:=True;
  end;
end;

//�ˬd�e10�j�Ȥ�+���t�O�_�ŦXLT
//False:�ŦX; True:���ŦX
function TForm1.CheckCustomerLT(custno,ad:string; LT:Integer; var retLT:Integer):Boolean;
var
  isFind:Boolean;
  i,j:Integer;
  tmpCustno,tmpAd_3:string;
begin
  Result:=False;
  retLT:=0;

  tmpCustno:=','+custno+',';
  tmpAd_3:=Copy(ad,1,3); //���t�e3�X�O�_�OIT9

  for i:=Low(l_ArrCustomer1) to High(l_ArrCustomer1) do
  if Pos(tmpCustno,l_ArrCustomer1[i].Custno)>0 then  //�������Ȥ�
  begin
    //���t�e3�X�p�G�OIT9,�@�w�O�bl_ArrCustomer1[i].Obj[0]��
    if SameText(tmpAd_3,'IT9') and SameText(l_ArrCustomer1[i].Obj[0].Ad,tmpAd_3) then
    begin
      retLT:=l_ArrCustomer1[i].Obj[0].LT;
      if LT>retLT then
         Result:=True;
    end else
    begin
      isFind:=False;
      for j:=Low(l_ArrCustomer1[i].Obj) to High(l_ArrCustomer1[i].Obj)-1 do //-1:�̦Z�@���O"�䥦",���γB�z
      begin
        if Pos('/'+ad+'/','/'+l_ArrCustomer1[i].Obj[j].Ad+'/')>0 then
        begin
          isFind:=True;
          retLT:=l_ArrCustomer1[i].Obj[j].LT;
          if LT>retLT then
             Result:=True;
          Break;
        end;
      end;

      //�����,�h�ݩ�̦Z�@��"�䥦"
      if not isFind then
      begin
        j:=High(l_ArrCustomer1[i].Obj);
        retLT:=l_ArrCustomer1[i].Obj[j].LT;
        if LT>retLT then
           Result:=True;
      end;
    end;

    Break;
  end;
end;

function TForm1.GetRpt(var xfname,xfpath:string):Boolean;
const xls='Temp\�e10�j�Ȥ�Lead Time�ޱ���.xlsx';
var
  isFindDate,isIndate,isOeb15Err,isPriorMonth,isOverAdLT,isOverCustomerLT:Boolean;
  i,j,r,row1,row2,lt,ltType1,ltType2,retAdLT,retCustomerLT,sum0,sum1,sum2:Integer;
  tmpDefDate,tmpAdate,tmpIndate,D1:TDateTime;
  tmpFilter,tmpBu,tmpSrcFlag,fPath,qryD,tmpCell:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('�e10�j�Ȥ�Lead Time�ޱ���');
  Memo1.Lines.Add('begin rpt');
  if not FileExists(l_path+xls) then
  begin
    Memo1.Lines.Add(l_path+xls+'���s�b');
    LogInfo(Memo1.Text);
    Exit;
  end;

  try
    ExcelApp:=CreateOleObject('Excel.Application');
  except
    Memo1.Lines.Add('�Ы�Excel����');
    LogInfo(Memo1.Text);
    Exit;
  end;

  ClearArrAd1;
  ClearArrAd2;
  ClearArrCustomer1;
  ClearArrCustomer2;
  pb.Position:=0;
  pb.Visible:=True;
  try
    r:=2;
    row1:=2;
    row2:=2;
    tmpBu:='ITEQDG';
    tmpDefDate:=EncodeDate(1955,5,5);
    D1:=EncodeDate(YearOf(Date),MonthOf(Date),1); //���1��
    if MonthOf(Date)=1 then                       //�W��1��
       qryD:=FormatDateTime('YYYY/MM/DD',EncodeDate(YearOf(Date)-1,12,1))
    else
       qryD:=FormatDateTime('YYYY/MM/DD',EncodeDate(YearOf(Date),MonthOf(Date)-1,1));
    qryD:=StringReplace(qryD,'-','/',[rfReplaceAll]);
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(l_path+xls);
    ExcelApp.WorkSheets[1].Activate;
    for i:=1 to 2 do
    begin
      tmpFilter:='';

      Memo1.Lines.Add('���b�d��['+tmpBu+'�q����]');
      Application.ProcessMessages;
      with ADOQuery1 do
      begin
        Close;
        SQL.Text:='select x.*,case ad when ''IT168G'' then ''IT168G1'' when ''IT170GRA'' then ''IT170GRA1'' when ''IT140G'' then ''IT150G'' else ad end adx from ('
                 +' select oea01,oea02,oea04,oea044,oea10,oeb03,oeb04,oeb05,oeb06,'
                 +' oeb11,oeb12,oeb15,oeb24,ta_oeb01,ta_oeb02,ta_oeb10,occ02,ima021,'
                 +' case when instr(ima02,''TC'',1,1)>0 then substr(ima02,1,instr(ima02,''TC'',1,1)-1)'
                 +' when instr(ima02,''BS'',1,1)>0 then substr(ima02,1,instr(ima02,''BS'',1,1)-1) else ''ERROR'' end as ad'
                 +' from '+tmpBu+'.oea_file,'+tmpBu+'.oeb_file,'+tmpBu+'.occ_file,'+tmpBu+'.ima_file'
                 +' where oea01=oeb01 and oea04=occ01 and oeb04=ima01'
                 +' and to_char(oea02,''YYYY/MM/DD'')>='+Quotedstr(qryD)
                 //+' and to_char(oea02,''YYYY/MM/DD'') in (''2020/03/30'',''2020/04/01'')'  //����
                 +' and oeaconf=''Y'' and oeb70<>''Y'' and oeb12>0'
                 +' and substr(oea01,1,3) not in (''226'',''22A'')'
                 +' and substr(oea04,1,1)<>''N'''
                 +' and substr(oeb04,length(oeb04),1)<>''0'''
                 +' and substr(oeb04,1,1) in (''E'',''T'',''R'',''B'',''N'',''M'')) x'
                 +' order by adx,oea04,oea02,oea01,oeb03';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;

        if IsEmpty then
        begin
          tmpBu:='ITEQGZ';
          Continue;
        end;

        while not Eof do
        begin
          if Pos(FieldByName('oea01').AsString, tmpFilter)=0 then
             tmpFilter:=tmpFilter+','+Quotedstr(FieldByName('oea01').AsString);
          Next;
        end;
      end;

      Memo1.Lines.Add('���b�d��['+tmpBu+'������]');
      Application.ProcessMessages;
      Delete(tmpFilter,1,1);
      with ADOQuery2 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Adate) Adate,Min(Cdate) Cdate'
                 +' From MPS200 Where Bu='+Quotedstr(tmpBu)
                 +' And Orderno in ('+tmpFilter+')'
                 +' And IsNull(GarbageFlag,0)=0'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('���b�d��['+tmpBu+' CCL�Ͳ��Ƶ{���]');
      Application.ProcessMessages;
      if SameText(tmpBu,'ITEQDG') then
         tmpSrcFlag:=' And SrcFlag in (1,3,5)'
      else
         tmpSrcFlag:=' And SrcFlag in (2,4,6)';
      with ADOQuery3 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Sdate) Sdate From ('
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS010 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union'
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS010_20160409 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('���b�d��['+tmpBu+' PP�Ͳ��Ƶ{���]');
      Application.ProcessMessages;
      with ADOQuery4 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Sdate) Sdate From ('
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS070 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union'
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS070_bak Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('���b�d��['+tmpBu+'�X�f����]');
      Application.ProcessMessages;
      with ADOQuery5 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Indate) Indate From ('
                 +' Select Orderno,Orderitem,Indate'
                 +' From DLI010 Where Bu='+Quotedstr(tmpBu)
                 +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
                 +' And Indate<getdate()'
                 +' And IsNull(QtyColor,0)<>999'
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union All'
                 +' Select Orderno,Orderitem,Indate'
                 +' From DLI010_20160409 Where Bu='+Quotedstr(tmpBu)
                 +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
                 +' And IsNull(QtyColor,0)<>999'
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      //�ץX���ӡB�}�έp�J�`
      Memo1.Lines.Add('���b�ץX['+tmpBu+'����xls]');
      Application.ProcessMessages;
      pb.Position:=0;
      pb.Max:=ADOQuery1.RecordCount;
      ADOQuery1.First;
      while not ADOQuery1.Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        tmpFilter:='orderno='+Quotedstr(ADOQuery1.FieldByName('oea01').AsString)
                  +' and orderitem='+IntToStr(ADOQuery1.FieldByName('oeb03').AsInteger);

        //lt=�X�f���-�q����
        //lt=Call�f���-�q����
        //lt=������-�q����
        isFindDate:=False;    //�O�_�����
        isIndate:=False;      //�O�_�O�X�f���
        isOeb15Err:=False;    //Oeb15�O���~�����
        if not ADOQuery1.FieldByName('oeb15').IsNull then
        begin
          try
            tmpIndate:=ADOQuery1.FieldByName('oeb15').AsDateTime;  //tmpIndate�{�ɥΧ@�P�_
          except
            tmpIndate:=tmpDefDate;
          end;

          ltType1:=YearOf(tmpIndate); //ltType1�{�ɥΧ@�P�_
          if (ltType1<2000) or (ltType1>3000) then
             isOeb15Err:=True;
        end else
          isOeb15Err:=True;

        tmpIndate:=Date;    //�q�{�X�f���������

        //��X�f���
        ADOQuery5.Filtered:=False;
        ADOQuery5.Filter:=tmpFilter;
        ADOQuery5.Filtered:=True;
        if (not ADOQuery5.IsEmpty) and (not ADOQuery5.FieldByName('indate').IsNull) then
        begin
          tmpIndate:=ADOQuery5.FieldByName('indate').AsDateTime;
          isFindDate:=True;
          isIndate:=True;
        end;

        //��call�f����B������
        if not isFindDate then
        begin
          ADOQuery2.Filtered:=False;
          ADOQuery2.Filter:=tmpFilter;
          ADOQuery2.Filtered:=True;
          if not ADOQuery2.IsEmpty then
          begin
            if not ADOQuery2.FieldByName('cdate').IsNull then
            begin
              tmpIndate:=ADOQuery2.FieldByName('cdate').AsDateTime;
              isFindDate:=True;
            end else
            if not ADOQuery2.FieldByName('adate').IsNull then
            begin
              tmpIndate:=ADOQuery2.FieldByName('adate').AsDateTime;
              isFindDate:=True;
            end;
          end;
        end;

        if isFindDate and (ADOQuery1.FieldByName('oea02').AsDateTime<tmpIndate) then
           lt:=DaysBetween(ADOQuery1.FieldByName('oea02').AsDateTime,tmpIndate)
        else
           lt:=0;

        retAdLT:=0;
        retCustomerLT:=0;
        isPriorMonth:=ADOQuery1.FieldByName('oea02').AsDateTime<D1; //�p�_D1���W��
        if isPriorMonth then
        begin
          r:=row1;
          ExcelApp.WorkSheets[1].Activate;
          isOverAdLT:=CheckAdLT1(ADOQuery1.FieldByName('adx').AsString,lt,retAdLT);
          isOverCustomerLT:=CheckCustomerLT(ADOQuery1.FieldByName('oea04').AsString,ADOQuery1.FieldByName('adx').AsString,lt,retCustomerLT);
        end else
        begin
          r:=row2;
          ExcelApp.WorkSheets[2].Activate;
          isOverAdLT:=CheckAdLT2(ADOQuery1.FieldByName('adx').AsString,lt,retAdLT);
          isOverCustomerLT:=CheckCustomerLT(ADOQuery1.FieldByName('oea04').AsString,ADOQuery1.FieldByName('adx').AsString,lt,retCustomerLT);
        end;

        //�Z���i�H�ϥ�retCustomerLT>0�P�_�O�_�O�e10�j�Ȥ�

        if isFindDate then
        begin
          //ltType=>0:ok 1:PO���w��� 2:������F��
          if not isOverAdLT then
            ltType1:=0
          else if (not isOeb15Err) and (tmpIndate<=ADOQuery1.FieldByName('oeb15').AsDateTime) then
            ltType1:=1
          else
            ltType1:=2;

          if not isOverCustomerLT then
            ltType2:=0
          else if (not isOeb15Err) and (tmpIndate<=ADOQuery1.FieldByName('oeb15').AsDateTime) then
            ltType2:=1
          else
            ltType2:=2;

          //���`��u�p��w�X�f�q��
          if isIndate then
          begin
            if isPriorMonth then
            begin
              UpdateArrAd1(ADOQuery1.FieldByName('adx').AsString,lt,ltType1);
              if retCustomerLT>0 then
                 UpdateArrCustomer1(ADOQuery1.FieldByName('oea04').AsString,ADOQuery1.FieldByName('adx').AsString,lt,ltType2);
            end else
            begin
              UpdateArrAd2(ADOQuery1.FieldByName('adx').AsString,lt,ltType2);
              if retCustomerLT>0 then
                 UpdateArrCustomer2(ADOQuery1.FieldByName('oea04').AsString,ADOQuery1.FieldByName('adx').AsString,lt,ltType2);
            end;
          end;
        end else
        begin
          ltType1:=-1;        //������
          ltType2:=-1;
        end;

        ExcelApp.Cells[r,17].Value:='T+'+IntToStr(retAdLT);
        case ltType1 of
          0:ExcelApp.Cells[r,18].Value:='OK';
          1:ExcelApp.Cells[r,18].Value:='PO���w���';
          2:ExcelApp.Cells[r,18].Value:='������F��';
          else
            ExcelApp.Cells[r,18].Value:='������';
        end;

        if retCustomerLT>0 then
        begin
          ExcelApp.Cells[r,19].Value:='T+'+IntToStr(retCustomerLT);
          case ltType2 of
            0:ExcelApp.Cells[r,20].Value:='OK';
            1:ExcelApp.Cells[r,20].Value:='PO���w���';
            2:ExcelApp.Cells[r,20].Value:='������F��';
            else
              ExcelApp.Cells[r,20].Value:='������';
          end;
        end;

        ExcelApp.Cells[r,1].Value:=tmpBu;
        ExcelApp.Cells[r,2].Value:=ADOQuery1.FieldByName('oea02').AsDateTime;
        ExcelApp.Cells[r,3].Value:=ADOQuery1.FieldByName('oea01').AsString;
        ExcelApp.Cells[r,4].Value:=ADOQuery1.FieldByName('oeb03').AsInteger;
        ExcelApp.Cells[r,5].Value:=ADOQuery1.FieldByName('oea04').AsString;
        ExcelApp.Cells[r,6].Value:=ADOQuery1.FieldByName('occ02').AsString;
        ExcelApp.Cells[r,7].Value:=ADOQuery1.FieldByName('oeb04').AsString;
        ExcelApp.Cells[r,8].Value:=ADOQuery1.FieldByName('ad').AsString;
        ExcelApp.Cells[r,9].Value:=ADOQuery1.FieldByName('oeb12').AsFloat;
        ExcelApp.Cells[r,10].Value:=ADOQuery1.FieldByName('oeb05').AsString;
        if not isOeb15Err then
           ExcelApp.Cells[r,11].Value:=ADOQuery1.FieldByName('oeb15').AsDateTime;

        if isFindDate then
        begin
          //�F����,call�f���
          ADOQuery2.Filtered:=False;
          ADOQuery2.Filter:=tmpFilter;
          ADOQuery2.Filtered:=True;
          if not ADOQuery2.IsEmpty then
          begin
            if not ADOQuery2.FieldByName('adate').IsNull then
               ExcelApp.Cells[r,12].Value:=ADOQuery2.FieldByName('adate').AsDateTime;
            if not ADOQuery2.FieldByName('cdate').IsNull then
               ExcelApp.Cells[r,13].Value:=ADOQuery2.FieldByName('cdate').AsDateTime;
          end;

          //ccl�Ͳ�����Bpp�Ͳ����
          if ADOQuery1.FieldByName('oeb04').AsString[1] in ['E','T'] then
          begin
            ADOQuery3.Filtered:=False;
            ADOQuery3.Filter:=tmpFilter;
            ADOQuery3.Filtered:=True;
            if (not ADOQuery3.IsEmpty) and (not ADOQuery3.FieldByName('sdate').IsNull) then
               ExcelApp.Cells[r,14].Value:=ADOQuery3.FieldByName('sdate').AsDateTime;
          end else
          begin
            ADOQuery4.Filtered:=False;
            ADOQuery4.Filter:=tmpFilter;
            ADOQuery4.Filtered:=True;
            if (not ADOQuery4.IsEmpty) and (not ADOQuery4.FieldByName('sdate').IsNull) then
               ExcelApp.Cells[r,14].Value:=ADOQuery4.FieldByName('sdate').AsDateTime;
          end;

          if (not ADOQuery5.IsEmpty) and (not ADOQuery5.FieldByName('indate').IsNull) then
             ExcelApp.Cells[r,15].Value:=ADOQuery5.FieldByName('indate').AsDateTime;

          ExcelApp.Cells[r,16].Value:=lt;

          //���ŦX�n�D,�аO����
          if isOverAdLT or isOverCustomerLT then
          begin
            tmpCell:='P'+IntToStr(r);
            ExcelApp.Range[tmpCell].Select;
            ExcelApp.Range[tmpCell].Interior.ColorIndex:=3;
            ExcelApp.Range[tmpCell].Interior.Pattern:=xlSolid;
          end;
        end;

        ADOQuery1.Next;
        Inc(r);
        if isPriorMonth then
           row1:=r
        else
           row2:=r;
      end;

      tmpBu:='ITEQGZ';
    end;

    //��ؽu
    for i:=1 to 2 do
    begin
      ExcelApp.WorkSheets[i].Activate;
      if i=1 then
         r:=row1-1
      else
         r:=row2-1;
      tmpCell:='A1:T'+IntToStr(r);
      ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
      ExcelApp.Columns.EntireColumn.AutoFit;

      Inc(r,3);
      ExcelApp.Cells[r,1].Value:='Lead Time�p�⤽���G';
      ExcelApp.Cells[r+1,1].Value:='1. �X�f���-�q����';
      ExcelApp.Cells[r+2,1].Value:='2. Call�f���-�q����';
      ExcelApp.Cells[r+3,1].Value:='3. ������-�q����';
      ExcelApp.Range['A2'].Select;
    end;

    //���`,�ץXxls
    Memo1.Lines.Add('���b�ץX[�W�뽦�tLT���`���]');
    Application.ProcessMessages;
    ExcelApp.WorkSheets[3].Activate;
    sum0:=0;sum1:=0;sum2:=0;
    r:=3;
    row1:=r;
    for i:=Low(l_ArrAd1) to High(l_ArrAd1) do
    begin
      if l_ArrAd1[i].LT=0 then
         Break;
      if l_ArrAd1[i].Show then
      begin
        if SameText(l_ArrAd1[i].Ad,'IT168G1') then
           ExcelApp.Cells[r,1].Value:='IT168G�BIT168G1'
        else if SameText(l_ArrAd1[i].Ad,'IT170GRA1') then
           ExcelApp.Cells[r,1].Value:='IT170GRA�BIT170GRA1'
        else if SameText(l_ArrAd1[i].Ad,'IT150G') then
           ExcelApp.Cells[r,1].Value:='IT140G�BIT150G'
        else
           ExcelApp.Cells[r,1].Value:=l_ArrAd1[i].Ad;
        ExcelApp.Cells[r,2].Value:='T+'+IntToStr(l_ArrAd1[i].LT);

        //Data[0]:ok Data[1]:PO���w��� Data[2]:������F��
        if l_ArrAd1[i].Data[0].OrdCnt>0 then
        begin
          sum0:=sum0+l_ArrAd1[i].Data[0].SumLT;
          lt:=Round(l_ArrAd1[i].Data[0].SumLT/l_ArrAd1[i].Data[0].OrdCnt);
          ExcelApp.Cells[r,3].Value:=l_ArrAd1[i].Data[0].OrdCnt;
          ExcelApp.Cells[r,4].Value:=lt;
        end;

        if l_ArrAd1[i].Data[1].OrdCnt>0 then
        begin
          sum1:=sum1+l_ArrAd1[i].Data[1].SumLT;
          lt:=Round(l_ArrAd1[i].Data[1].SumLT/l_ArrAd1[i].Data[1].OrdCnt);
          ExcelApp.Cells[r,5].Value:=l_ArrAd1[i].Data[1].OrdCnt;
          ExcelApp.Cells[r,6].Value:=lt;
        end;

        if l_ArrAd1[i].Data[2].OrdCnt>0 then
        begin
          sum2:=sum2+l_ArrAd1[i].Data[2].SumLT;
          lt:=Round(l_ArrAd1[i].Data[2].SumLT/l_ArrAd1[i].Data[2].OrdCnt);
          ExcelApp.Cells[r,7].Value:=l_ArrAd1[i].Data[2].OrdCnt;
          ExcelApp.Cells[r,8].Value:=lt;
        end;

        lt:=l_ArrAd1[i].Data[0].OrdCnt+l_ArrAd1[i].Data[1].OrdCnt+l_ArrAd1[i].Data[2].OrdCnt; //�@�w>0
        ExcelApp.Cells[r,9].Value:=lt;
        lt:=Round((l_ArrAd1[i].Data[0].SumLT+l_ArrAd1[i].Data[1].SumLT+l_ArrAd1[i].Data[2].SumLT)/lt);
        ExcelApp.Cells[r,10].Value:=lt;

        ExcelApp.Cells[r,11].Value:='=(C'+IntToStr(r)+'+E'+IntToStr(r)+')/I'+IntToStr(r);
        ExcelApp.Range['K'+IntToStr(r)].Select;
        ExcelApp.Selection.NumberFormatLocal:='0%';

        Inc(r);
      end;
    end;

    //�X�p�B��ؽu
    if r>3 then
    begin
      row2:=r-1;
      ExcelApp.Cells[r,1].Value:='�X�p';
      ExcelApp.Cells[r,3].Value:='=SUM(C3:C'+IntToStr(row2)+')';
      ExcelApp.Cells[r,4].Value:='=ROUND('+IntToStr(sum0)+'/C'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,5].Value:='=SUM(E3:E'+IntToStr(row2)+')';
      ExcelApp.Cells[r,6].Value:='=ROUND('+IntToStr(sum1)+'/E'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,7].Value:='=SUM(G3:G'+IntToStr(row2)+')';
      ExcelApp.Cells[r,8].Value:='=ROUND('+IntToStr(sum2)+'/G'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,9].Value:='=SUM(I3:I'+IntToStr(row2)+')';
      sum0:=sum0+sum1+sum2;
      ExcelApp.Cells[r,10].Value:='=ROUND('+IntToStr(sum0)+'/I'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,11].Value:='=(C'+IntToStr(r)+'+E'+IntToStr(r)+')/I'+IntToStr(r);
      ExcelApp.Range['K'+IntToStr(r)].Select;
      ExcelApp.Selection.NumberFormatLocal:='0%';

      tmpCell:='A'+IntToStr(row1)+':K'+IntToStr(r);
      ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;
    ExcelApp.Columns.EntireColumn.AutoFit;
    ExcelApp.Range['M2'].Select;

    Memo1.Lines.Add('���b�ץX[��뽦�tLT���`���]');
    Application.ProcessMessages;
    ExcelApp.WorkSheets[4].Activate;
    sum0:=0;sum1:=0;sum2:=0;
    r:=3;
    row1:=r;
    for i:=Low(l_ArrAd2) to High(l_ArrAd2) do
    begin
      if l_ArrAd2[i].LT=0 then
         Break;
      if l_ArrAd2[i].Show then
      begin
        if SameText(l_ArrAd2[i].Ad,'IT168G1') then
           ExcelApp.Cells[r,1].Value:='IT168G�BIT168G1'
        else if SameText(l_ArrAd2[i].Ad,'IT170GRA1') then
           ExcelApp.Cells[r,1].Value:='IT170GRA�BIT170GRA1'
        else if SameText(l_ArrAd2[i].Ad,'IT150G') then
           ExcelApp.Cells[r,1].Value:='IT140G�BIT150G'
        else
           ExcelApp.Cells[r,1].Value:=l_ArrAd2[i].Ad;
        ExcelApp.Cells[r,2].Value:='T+'+IntToStr(l_ArrAd2[i].LT);

        //Data[0]:ok Data[1]:PO���w��� Data[2]:������F��
        if l_ArrAd2[i].Data[0].OrdCnt>0 then
        begin
          sum0:=sum0+l_ArrAd2[i].Data[0].SumLT;
          lt:=Round(l_ArrAd2[i].Data[0].SumLT/l_ArrAd2[i].Data[0].OrdCnt);
          ExcelApp.Cells[r,3].Value:=l_ArrAd2[i].Data[0].OrdCnt;
          ExcelApp.Cells[r,4].Value:=lt;
        end;

        if l_ArrAd2[i].Data[1].OrdCnt>0 then
        begin
          sum1:=sum1+l_ArrAd2[i].Data[1].SumLT;
          lt:=Round(l_ArrAd2[i].Data[1].SumLT/l_ArrAd2[i].Data[1].OrdCnt);
          ExcelApp.Cells[r,5].Value:=l_ArrAd2[i].Data[1].OrdCnt;
          ExcelApp.Cells[r,6].Value:=lt;
        end;

        if l_ArrAd2[i].Data[2].OrdCnt>0 then
        begin
          sum2:=sum2+l_ArrAd2[i].Data[2].SumLT;
          lt:=Round(l_ArrAd2[i].Data[2].SumLT/l_ArrAd2[i].Data[2].OrdCnt);
          ExcelApp.Cells[r,7].Value:=l_ArrAd2[i].Data[2].OrdCnt;
          ExcelApp.Cells[r,8].Value:=lt;
        end;

        lt:=l_ArrAd2[i].Data[0].OrdCnt+l_ArrAd2[i].Data[1].OrdCnt+l_ArrAd2[i].Data[2].OrdCnt; //�@�w>0
        ExcelApp.Cells[r,9].Value:=lt;
        lt:=Round((l_ArrAd2[i].Data[0].SumLT+l_ArrAd2[i].Data[1].SumLT+l_ArrAd2[i].Data[2].SumLT)/lt);
        ExcelApp.Cells[r,10].Value:=lt;

        ExcelApp.Cells[r,11].Value:='=(C'+IntToStr(r)+'+E'+IntToStr(r)+')/I'+IntToStr(r);
        ExcelApp.Range['K'+IntToStr(r)].Select;
        ExcelApp.Selection.NumberFormatLocal:='0%';

        Inc(r);
      end;
    end;

    //�X�p�B��ؽu
    if r>3 then
    begin
      row2:=r-1;
      ExcelApp.Cells[r,1].Value:='�X�p';
      ExcelApp.Cells[r,3].Value:='=SUM(C3:C'+IntToStr(row2)+')';
      ExcelApp.Cells[r,4].Value:='=ROUND('+IntToStr(sum0)+'/C'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,5].Value:='=SUM(E3:E'+IntToStr(row2)+')';
      ExcelApp.Cells[r,6].Value:='=ROUND('+IntToStr(sum1)+'/E'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,7].Value:='=SUM(G3:G'+IntToStr(row2)+')';
      ExcelApp.Cells[r,8].Value:='=ROUND('+IntToStr(sum2)+'/G'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,9].Value:='=SUM(I3:I'+IntToStr(row2)+')';
      sum0:=sum0+sum1+sum2;
      ExcelApp.Cells[r,10].Value:='=ROUND('+IntToStr(sum0)+'/I'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,11].Value:='=(C'+IntToStr(r)+'+E'+IntToStr(r)+')/I'+IntToStr(r);
      ExcelApp.Range['K'+IntToStr(r)].Select;
      ExcelApp.Selection.NumberFormatLocal:='0%';

      tmpCell:='A'+IntToStr(row1)+':K'+IntToStr(r);
      ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;
    ExcelApp.Columns.EntireColumn.AutoFit;
    ExcelApp.Range['M2'].Select;

    Memo1.Lines.Add('���b�ץX[�W��e10�j�Ȥ�LT���`���]');
    Application.ProcessMessages;
    ExcelApp.WorkSheets[5].Activate;
    sum0:=0;sum1:=0;sum2:=0;
    r:=3;
    row1:=r;
    for i:=Low(l_ArrCustomer1) to High(l_ArrCustomer1) do
    begin
      if l_ArrCustomer1[i].Show then
      begin
        row2:=r;
        ExcelApp.Cells[r,1].Value:=l_ArrCustomer1[i].Name;
        for j:=Low(l_ArrCustomer1[i].Obj) to High(l_ArrCustomer1[i].Obj) do
        begin
          if SameText(l_ArrCustomer1[i].Obj[j].Ad,'IT9') then
             ExcelApp.Cells[r,2].Value:='9�t�C'
          else
             ExcelApp.Cells[r,2].Value:=l_ArrCustomer1[i].Obj[j].Ad;
          ExcelApp.Cells[r,3].Value:='T+'+IntToStr(l_ArrCustomer1[i].Obj[j].LT);

          //Data[0]:ok Data[1]:PO���w��� Data[2]:������F��
          if l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt>0 then
          begin
            sum0:=sum0+l_ArrCustomer1[i].Obj[j].Data[0].SumLT;
            lt:=Round(l_ArrCustomer1[i].Obj[j].Data[0].SumLT/l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt);
            ExcelApp.Cells[r,4].Value:=l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt;
            ExcelApp.Cells[r,5].Value:=lt;
          end;

          if l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt>0 then
          begin
            sum1:=sum1+l_ArrCustomer1[i].Obj[j].Data[1].SumLT;
            lt:=Round(l_ArrCustomer1[i].Obj[j].Data[1].SumLT/l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt);
            ExcelApp.Cells[r,6].Value:=l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt;
            ExcelApp.Cells[r,7].Value:=lt;
          end;

          if l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt>0 then
          begin
            sum2:=sum2+l_ArrCustomer1[i].Obj[j].Data[2].SumLT;
            lt:=Round(l_ArrCustomer1[i].Obj[j].Data[2].SumLT/l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt);
            ExcelApp.Cells[r,8].Value:=l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt;
            ExcelApp.Cells[r,9].Value:=lt;
          end;

          if (l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt>0) or
             (l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt>0) or
             (l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt>0) then
          begin
            lt:=l_ArrCustomer1[i].Obj[j].Data[0].OrdCnt+l_ArrCustomer1[i].Obj[j].Data[1].OrdCnt+l_ArrCustomer1[i].Obj[j].Data[2].OrdCnt;
            ExcelApp.Cells[r,10].Value:=lt;
            lt:=Round((l_ArrCustomer1[i].Obj[j].Data[0].SumLT+l_ArrCustomer1[i].Obj[j].Data[1].SumLT+l_ArrCustomer1[i].Obj[j].Data[2].SumLT)/lt);
            ExcelApp.Cells[r,11].Value:=lt;

            ExcelApp.Cells[r,12].Value:='=(D'+IntToStr(r)+'+F'+IntToStr(r)+')/J'+IntToStr(r);
            ExcelApp.Range['L'+IntToStr(r)].Select;
            ExcelApp.Selection.NumberFormatLocal:='0%';
          end;

          Inc(r);
        end;

        ExcelApp.Range['A'+IntToStr(row2)+':A'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
      end;
    end;

    //�X�p�B��ؽu
    if r>3 then
    begin
      row2:=r-1;
      ExcelApp.Cells[r,1].Value:='�X�p';
      ExcelApp.Cells[r,4].Value:='=SUM(D3:D'+IntToStr(row2)+')';
      ExcelApp.Cells[r,5].Value:='=ROUND('+IntToStr(sum0)+'/D'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,6].Value:='=SUM(F3:F'+IntToStr(row2)+')';
      ExcelApp.Cells[r,7].Value:='=ROUND('+IntToStr(sum1)+'/F'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,8].Value:='=SUM(H3:H'+IntToStr(row2)+')';
      ExcelApp.Cells[r,9].Value:='=ROUND('+IntToStr(sum2)+'/H'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,10].Value:='=SUM(J3:J'+IntToStr(row2)+')';
      sum0:=sum0+sum1+sum2;
      ExcelApp.Cells[r,11].Value:='=ROUND('+IntToStr(sum0)+'/J'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,12].Value:='=(D'+IntToStr(r)+'+F'+IntToStr(r)+')/J'+IntToStr(r);
      ExcelApp.Range['L'+IntToStr(r)].Select;
      ExcelApp.Selection.NumberFormatLocal:='0%';

      tmpCell:='A'+IntToStr(row1)+':L'+IntToStr(r);
      ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;
    ExcelApp.Columns.EntireColumn.AutoFit;
    ExcelApp.Range['N2'].Select;

    Memo1.Lines.Add('���b�ץX[���e10�j�Ȥ�LT���`���]');
    Application.ProcessMessages;
    ExcelApp.WorkSheets[6].Activate;
    sum0:=0;sum1:=0;sum2:=0;
    r:=3;
    row1:=r;
    for i:=Low(l_ArrCustomer2) to High(l_ArrCustomer2) do
    begin
      if l_ArrCustomer2[i].Show then
      begin
        row2:=r;
        ExcelApp.Cells[r,1].Value:=l_ArrCustomer2[i].Name;
        for j:=Low(l_ArrCustomer2[i].Obj) to High(l_ArrCustomer2[i].Obj) do
        begin
          if SameText(l_ArrCustomer2[i].Obj[j].Ad,'IT9') then
             ExcelApp.Cells[r,2].Value:='9�t�C'
          else
             ExcelApp.Cells[r,2].Value:=l_ArrCustomer2[i].Obj[j].Ad;
          ExcelApp.Cells[r,3].Value:='T+'+IntToStr(l_ArrCustomer2[i].Obj[j].LT);

          //Data[0]:ok Data[1]:PO���w��� Data[2]:������F��
          if l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt>0 then
          begin
            sum0:=sum0+l_ArrCustomer2[i].Obj[j].Data[0].SumLT;
            lt:=Round(l_ArrCustomer2[i].Obj[j].Data[0].SumLT/l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt);
            ExcelApp.Cells[r,4].Value:=l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt;
            ExcelApp.Cells[r,5].Value:=lt;
          end;

          if l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt>0 then
          begin
            sum1:=sum1+l_ArrCustomer2[i].Obj[j].Data[1].SumLT;
            lt:=Round(l_ArrCustomer2[i].Obj[j].Data[1].SumLT/l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt);
            ExcelApp.Cells[r,6].Value:=l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt;
            ExcelApp.Cells[r,7].Value:=lt;
          end;

          if l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt>0 then
          begin
            sum2:=sum2+l_ArrCustomer2[i].Obj[j].Data[2].SumLT;
            lt:=Round(l_ArrCustomer2[i].Obj[j].Data[2].SumLT/l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt);
            ExcelApp.Cells[r,8].Value:=l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt;
            ExcelApp.Cells[r,9].Value:=lt;
          end;

          if (l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt>0) or
             (l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt>0) or
             (l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt>0) then
          begin
            lt:=l_ArrCustomer2[i].Obj[j].Data[0].OrdCnt+l_ArrCustomer2[i].Obj[j].Data[1].OrdCnt+l_ArrCustomer2[i].Obj[j].Data[2].OrdCnt;
            ExcelApp.Cells[r,10].Value:=lt;
            lt:=Round((l_ArrCustomer2[i].Obj[j].Data[0].SumLT+l_ArrCustomer2[i].Obj[j].Data[1].SumLT+l_ArrCustomer2[i].Obj[j].Data[2].SumLT)/lt);
            ExcelApp.Cells[r,11].Value:=lt;

            ExcelApp.Cells[r,12].Value:='=(D'+IntToStr(r)+'+F'+IntToStr(r)+')/J'+IntToStr(r);
            ExcelApp.Range['L'+IntToStr(r)].Select;
            ExcelApp.Selection.NumberFormatLocal:='0%';
          end;

          Inc(r);
        end;

        ExcelApp.Range['A'+IntToStr(row2)+':A'+IntToStr(r-1)].Select;
        ExcelApp.Selection.Merge;
      end;
    end;

    //�X�p�B��ؽu
    if r>3 then
    begin
      row2:=r-1;
      ExcelApp.Cells[r,1].Value:='�X�p';
      ExcelApp.Cells[r,4].Value:='=SUM(D3:D'+IntToStr(row2)+')';
      ExcelApp.Cells[r,5].Value:='=ROUND('+IntToStr(sum0)+'/D'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,6].Value:='=SUM(F3:F'+IntToStr(row2)+')';
      ExcelApp.Cells[r,7].Value:='=ROUND('+IntToStr(sum1)+'/F'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,8].Value:='=SUM(H3:H'+IntToStr(row2)+')';
      ExcelApp.Cells[r,9].Value:='=ROUND('+IntToStr(sum2)+'/H'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,10].Value:='=SUM(J3:J'+IntToStr(row2)+')';
      sum0:=sum0+sum1+sum2;
      ExcelApp.Cells[r,11].Value:='=ROUND('+IntToStr(sum0)+'/J'+IntToStr(r)+',0)';
      ExcelApp.Cells[r,12].Value:='=(D'+IntToStr(r)+'+F'+IntToStr(r)+')/J'+IntToStr(r);
      ExcelApp.Range['L'+IntToStr(r)].Select;
      ExcelApp.Selection.NumberFormatLocal:='0%';

      tmpCell:='A'+IntToStr(row1)+':L'+IntToStr(r);
      ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;
    ExcelApp.Columns.EntireColumn.AutoFit;
    ExcelApp.Range['N2'].Select;

    fPath:=l_path+'Temp\�e10�j�Ȥ�Lead Time�ޱ���'+IntToStr(YearOf(Date));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='�e10�j�Ȥ�Lead Time�ޱ���'+FormatDateTime('MMDD',Date);
    xfpath:=fPath+'\'+xfname+'.xlsx';
    ExcelApp.ActiveSheet.SaveAs(xfpath);
    Memo1.Lines.Add('end rpt');
    Result:=True;

  finally
    PB.Visible:=False;
    ExcelApp.Quit;
    LogInfo(Memo1.Text);
  end;
end;

function TForm1.SendEmail(xfname,xfpath:string):Boolean;
var
  msg:string;
begin
  Result:=False;

  if (Length(l_mailFrom)=0) or (Length(l_mailTo)=0) then
  begin
    msg:='�o�e�H�α����H���]�w';
    Memo1.Lines.Add(msg);
    LogInfo(msg);
    Exit;
  end;

  try
    IdSMTP1.Disconnect;
    IdSMTP1.Connect;
    IdSMTP1.Authenticate;
  except
    on e:exception do
    begin
      msg:='�l�c�n�J����:'+#13#10+e.Message;
      Memo1.Lines.Add(msg);
      LogInfo(msg);
      Exit;
    end;
  end;

  IdMessage1.MessageParts.Clear;
  TIdattachment.Create(IdMessage1.MessageParts,xfpath);
  IdMessage1.From.Address:=l_mailFrom;                      //�o��H
  IdMessage1.Recipients.EMailAddresses:=l_mailTo;           //����H
  IdMessage1.Subject:=xfname;                               //�l��D��
                                                            //�l�󥿤�
  IdMessage1.Body.Text:='Dear ALL�G'+#13#10
                       +'    ���󬰡i'+xfname+'�j�A�Ьd�\�I'+#13#10
                       +'���q���ѥ~��ERP�t�Φ۰ʵo�X�A�ФŦ^�СA�Y���ðݽ��p�������H���A���¡I'+#13#10#13#10
                       +StringReplace(FormatDateTime('YYYY/MM/DD HH:NN:SS',Now),'-','/',[rfReplaceAll]);
  try
    IdSMTP1.Send(IdMessage1);
    Result:=True;

    msg:='�l��o�e���\';
    Memo1.Lines.Add(msg);
    LogInfo(msg);
  except
    on e:exception do
    begin
      msg:='�l��o�e����:'+#13#10+e.Message;
      Memo1.Lines.Add(msg);
      LogInfo(msg);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s1:string;
  SQLIP,SQLUID,SQLPW,SQLDB:string;
  ORAIP,ORAUID,ORAPW:string;
  MailIP,MailID,MailPW:string;
  ini:TIniFile;
begin
  l_path:=ExtractFilePath(Application.ExeName);
  if FileExists(l_path+'MailConfig.ini') then
  begin
    ini:=TIniFile.Create(l_path+'MailConfig.ini');
    try
      //SQLServer�A�Ⱦ�
      SQLIP:=ini.ReadString('SQLServer','IP','');
      SQLUID:=ini.ReadString('SQLServer','UID','');
      SQLPW:=ini.ReadString('SQLServer','PW','');
      SQLDB:=ini.ReadString('SQLServer','DB','');
      SQLPW:=Decrypt(SQLPW);

      //ORAServer�A�Ⱦ�
      ORAIP:=ini.ReadString('ORAServer','IP','');
      ORAUID:=ini.ReadString('ORAServer','UID','');
      ORAPW:=ini.ReadString('ORAServer','PW','');
      ORAPW:=Decrypt(ORAPW);

      //MailServer�A�Ⱦ�
      MailIP:=ini.ReadString('MailServer','IP','');
      MailID:=ini.ReadString('MailServer','UID','');
      MailPW:=ini.ReadString('MailServer','PW','');
      l_mailFrom:=ini.ReadString('MailServer','FROMADDR','');

      l_mailTo:=ini.ReadString('DLIR141','TOADDR','');
      MailPW:=Decrypt(MailPW);
    finally
      ini.Free;
    end;
  end;

  ADOConn.ConnectionString:='Provider=SQLOLEDB.1;Password='+SQLPW+';Persist Security Info=True;User ID='+SQLUID+';Initial Catalog='+SQLDB+';Data Source='+SQLIP;
  ORAConn.ConnectionString:='Provider=MSDAORA.1;Password='+ORAPW+';User ID='+ORAUID+';Data Source='+ORAIP+';Persist Security Info=True';
  IdSMTP1.Host:=MailIP;
  idsmtp1.AuthenticationType:=atLogin; //�l�c�n������{atNone,atLogin}
  IdSMTP1.Username:=MailID;
  IdSMTP1.Password:=MailPW;

  InitArrAd;
  InitArrCustomer;

  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1);
  if LowerCase(s1)='dlir141' then //��ERPServer.exe�Ұ�,Timer1����10�����
     Timer1.Enabled:=True;
end;

procedure TForm1.N1Click(Sender: TObject);
var
  xfname,xfpath:string;
begin
  if Application.MessageBox('test?','message',33)=IdOk then
  if GetRpt(xfname,xfpath) then
     SendEmail(xfname,xfpath);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  xfname,xfpath:string;
begin
  Timer1.Enabled:=False;
  if GetRpt(xfname,xfpath) then
     SendEmail(xfname,xfpath);
  Close;
end;

end.


