{*******************************************************}
{                                                       }
{                unMPSI010_SingleBoiler                 }
{                Author: kaikai                         }
{                Create date: 2015/3/13                 }
{                Description: 單鍋類                    }
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
    FOldJitem:Integer;               //舊數據項次
    FLock:Boolean;                   //鎖定標記
    FWdate:TDateTime;                //生產日期
    FTotalBoiler:Integer;            //總鍋數
    FCurrentBoiler:Integer;          //當前鍋次
    FAdCode:Integer;                 //合鍋代碼
    FOZ:string;                      //銅箔第7碼,最多2种規格一鍋
    FStealno:string;                 //鋼板編號
    FPremark:string;                 //生管備註
    FPremark_custno:string;          //生管備註(客戶群組替換成具體客戶)
    FRemainBooks:Double;             //剩余本數
    FList:TList;                     //訂單鏈表
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

//訂單120張以內不拆、120以上拆單至少拆100+n
function TSingleBoiler.AddOrderObj(Machine:string; P:POrderRec):Boolean;
var
  tmpC9_11:string;
  k:Double; //倍數
  P1:POrderRec;
  TotBookQty:Double;//此鍋可再排張數
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

  if TotBookQty>=P1^.sqty then                 //單鍋產能滿足,不拆單
  begin
    FRemainBooks:=RoundTo(FRemainBooks-RoundTo(P1^.sqty/(P^.book_qty*k), -3), -3);
    if FRemainBooks<0 then
       FRemainBooks:=0;
    P^.sqty:=0;
  end                                          //單鍋剩余產能不足,120以上大單,最小拆成100
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
