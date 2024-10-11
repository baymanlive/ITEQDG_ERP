{*******************************************************}
{                                                       }
{                unMPSI010_SingleBoiler                 }
{                Author: kaikai                         }
{                Create date: 2015/3/13                 }
{                Description: ������                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_SingleBoiler;

interface

uses
  Classes, SysUtils, Variants, Math, unGlobal, uncommon, unMPST010_units;

type
  TSingleBoiler = class
  private
    FOldJitem:Integer;               //�¼ƾڶ���
    FLock:Boolean;                   //��w�аO
    FWdate:TDateTime;                //�Ͳ����
    FTotalBoiler:Integer;            //�`���
    FCurrentBoiler:Integer;          //��e�禸
    FAdCode:Integer;                 //�X��N�X
    FOZ:string;                      //�ɺ��7�X,�̦h2���W��@��
    FStealno:string;                 //���O�s��
    FPremark:string;                 //�ͺ޳Ƶ�
    FPremark_custno:string;          //�ͺ޳Ƶ�(�Ȥ�s�մ���������Ȥ�)
    FRemainBooks:Double;             //�ѧE����
    FList:TList;                     //�q�����
    procedure SetLock(Value: Boolean);
    procedure SetOZ(Value: string);
    procedure SetPremark(Value: string);
    procedure SetPremark_custno(Value: string);
    procedure SetAdCode(Value: Integer);
    procedure SetRemainBooks(Value: Double);
    procedure SetCurrentBoiler(Value: Integer);
    procedure SetJitem(Value: Integer);
  public
    constructor Create(xWdate:TDateTime; xTotalBoiler:Integer; xStealno:string);
    destructor Destroy; override;
    function AddOrderObj(Machine:string; P:POrderRec):Boolean;
  published
    property OldJitem:Integer read FOldJitem write SetJitem;
    property Lock:Boolean read FLock write SetLock;
    property Wdate:TDateTime read FWdate;
    property TotalBoiler:Integer read FTotalBoiler;
    property CurrentBoiler:Integer read FCurrentBoiler write SetCurrentBoiler;
    property AdCode:Integer read FAdCode write SetAdCode;
    property RemainBooks:Double read FRemainBooks write SetRemainBooks;
    property OZ:string read FOZ write SetOZ;
    property Premark:string read FPremark write SetPremark;
    property Premark_custno:string read FPremark_custno write SetPremark_custno;
    property Stealno:string read FStealno;
    property List:TList read FList;
  end;

implementation

{ TSingleBoiler }

constructor TSingleBoiler.Create(xWdate:TDateTime; xTotalBoiler:Integer; xStealno:string);
begin
  FOldJitem:=-1;
  FLock:=False;
  FAdCode:=0;
  FRemainBooks:=0;
  FPremark:='';
  
  FStealno:=xStealno;
  FWdate:=xWdate;
  FTotalBoiler:=xTotalBoiler;

  FList:=TList.Create;
end;

destructor TSingleBoiler.Destroy;
var
  i:Integer;
begin
  for i:=FList.Count-1 downto 0 do
    Dispose(POrderRec(FList[i]));
  FreeAndNil(FList);
  
  inherited Destroy;
end;

//�q��120�i�H������B120�H�W���ܤ֩�100+n
function TSingleBoiler.AddOrderObj(Machine:string; P:POrderRec):Boolean;
var
  tmpC9_11:string;
  k:Double; //����
  P1:POrderRec;
  TotBookQty:Double;//����i�A�Ʊi��
begin
  Result:=True;

  if Pos(UpperCase(Machine), g_MachineCCL_GZ)>0 then
  begin
    k:=2;
    tmpC9_11:=UpperCase(Copy(P^.materialno,9,3));
    if (tmpC9_11<'300') and (tmpC9_11<>'230') then
       k:=3
    else if (tmpC9_11>='431') and (tmpC9_11<='739') then
       k:=1.5
    else if Pos(tmpC9_11,'740/820/860')>0 then
       k:=1;
  end else
    k:=1;

  TotBookQty:=Round(FRemainBooks*P^.book_qty*k);

  New(P1);
  P1^:=P^;
  P1.stealno:=FStealno;

  if TotBookQty>=P1^.sqty then                 //���粣�ມ��,�����
  begin
    FRemainBooks:=RoundTo(FRemainBooks-RoundTo(P1^.sqty/(P^.book_qty*k), -3), -3);
    if FRemainBooks<0 then
       FRemainBooks:=0;
    P^.sqty:=0;
  end                                          //����ѧE���ण��,120�H�W�j��,�̤p�100
  else if (P1^.sqty>120) and (TotBookQty>=100) then
  begin
    P1^.sqty:=TotBookQty;
    P^.sqty:=P^.sqty-P1^.sqty;
    FRemainBooks:=0;
  end else
  begin
    Dispose(P1);
    Result:=False;
    Exit;
  end;
  
  FList.Add(P1);
end;

procedure TSingleBoiler.SetJitem(Value: Integer);
begin
  if FOldJitem<>Value then
     FOldJitem:=Value;
end;

procedure TSingleBoiler.SetLock(Value: Boolean);
begin
  if FLock<>Value then
     FLock:=Value;
end;

procedure TSingleBoiler.SetAdCode(Value: Integer);
begin
  if FAdCode<>Value then
     FAdCode:=Value;
end;

procedure TSingleBoiler.SetRemainBooks(Value: Double);
begin
  if FRemainBooks<>Value then
     FRemainBooks:=Value;
end;

procedure TSingleBoiler.SetCurrentBoiler(Value: Integer);
begin
  if FCurrentBoiler<>Value then
     FCurrentBoiler:=Value;
end;

procedure TSingleBoiler.SetOZ(Value: string);
begin
  if FOZ<>Value then
     FOZ:=Value;
end;

procedure TSingleBoiler.SetPremark(Value: string);
begin
  if FPremark<>Value then
     FPremark:=Value;
end;

procedure TSingleBoiler.SetPremark_custno(Value: string);
begin
  if FPremark_custno<>Value then
     FPremark_custno:=Value;
end;

end.
