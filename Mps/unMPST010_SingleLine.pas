{*******************************************************}
{                                                       }
{                unMPSI010_SingleLine                   }
{                Author: kaikai                         }
{                Create date: 2015/3/13                 }
{                Description: 單線類                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_SingleLine;

interface

uses
  Classes, SysUtils, Variants, StrUtils, unMPST010_SingleBoiler, unMPST010_units;

type
  TSingleLine = class
  private
    FMachine:string;                                //機台
    FBooks:Double;                                  //總本數
    FTotalBoiler:Integer;                           //總鍋數
    FRemainBoiler:Integer;                          //剩余鍋數
    FStealnoList:TStrings;                          //全部鋼板
    FList:TList;                                    //單鍋鏈表TSingleBoiler
    FAdCode:string;                                 //此合鍋代碼忽略OZ
    FEmptyCount:Integer;                            //舊數據(未滿鍋)筆數
    function GetStealno:string;
    procedure SetTotalBoiler(Value: Integer);
    procedure SetRemainBoiler(Value: Integer);
    procedure SetEmptyCount(Value: Integer);
  public
    constructor Create(xMachine, xAdCode:string; xBooks:Double;
      xStealnoList:TStrings);
    destructor Destroy; override;
    procedure AddOrderObj(AdCode: Integer; CanUseStealno: TStrings; P: POrderRec;
      ErrList:TStrings; const FmListIndex:Integer=0);
  published
    property List:TList read FList;
    property TotalBoiler:Integer read FTotalBoiler write SetTotalBoiler;
    property RemainBoiler:Integer read FRemainBoiler write SetRemainBoiler;
    property EmptyCount:Integer read FEmptyCount write SetEmptyCount;
  end;

implementation

{ TSingleLine }

procedure TSingleLine.AddOrderObj(AdCode: Integer; CanUseStealno: TStrings;
  P: POrderRec; ErrList:TStrings; const FmListIndex:Integer=0);
var
  bo:Boolean;
  i:Integer;
  tmpOZ,tmpAdCode:string;
  SingleBoiler:TSingleBoiler;
begin
  bo:=not VarIsNull(P^.sdate1);
  for i:=FmListIndex to FList.Count-1 do
  begin
    SingleBoiler:=TSingleBoiler(FList[i]);
    if SingleBoiler.Lock and (Pos(VarToStr(P^.custno),WideString(SingleBoiler.Premark_custno))=0) then
       Continue;
    tmpOZ:=LeftStr(P^.oz, 1);
    tmpAdCode:='/'+IntToStr(AdCode)+'/';

    //3种指定條件,第3個不考慮鋼板和合鍋規范
    //1.機台
    //2.機台+日期
    //3.機台+日期+鍋次
    if bo then
    begin
      if (P^.sdate1=SingleBoiler.Wdate) and VarIsNull(P^.boiler1) and  //2
         (CanUseStealno.IndexOf(SingleBoiler.Stealno)<>-1) then
      begin
        if SingleBoiler.AdCode=0 then
        begin
          SingleBoiler.RemainBooks:=FBooks;
          if SingleBoiler.AddOrderObj(FMachine, P) then
          begin
            SingleBoiler.AdCode:=AdCode;
            SingleBoiler.OZ:=tmpOZ;
            if P^.sqty<=0 then
               Break;
          end else
            SingleBoiler.RemainBooks:=0;
        end
        else if (SingleBoiler.AdCode=AdCode) and (SingleBoiler.RemainBooks>0) then
        begin
          if (Length(SingleBoiler.OZ)=1) or
             (Pos(tmpOZ, SingleBoiler.OZ)>0) or
             (Pos(tmpAdCode, FAdCode)>0) then
          begin
            if SingleBoiler.AddOrderObj(FMachine, P) then
            begin
              if (Length(SingleBoiler.OZ)=1) and (SingleBoiler.OZ<>tmpOZ) then
                 SingleBoiler.OZ:=SingleBoiler.OZ+tmpOZ;
              if P^.sqty<=0 then
                 Break;
            end;
          end;
        end;
      end else                                                         //3
      if (P^.sdate1=SingleBoiler.Wdate) and (SingleBoiler.CurrentBoiler=P^.boiler1) then
      begin
        if SingleBoiler.AdCode=0 then
           SingleBoiler.RemainBooks:=FBooks;
        if SingleBoiler.RemainBooks>0 then
        begin
          if SingleBoiler.AddOrderObj(FMachine, P) then
          begin
            if SingleBoiler.AdCode=0 then
            begin
              SingleBoiler.AdCode:=AdCode;
              SingleBoiler.OZ:=tmpOZ;
            end
            else if (Length(SingleBoiler.OZ)=1) and (SingleBoiler.OZ<>tmpOZ) then
              SingleBoiler.OZ:=SingleBoiler.OZ+tmpOZ;

            if CanUseStealno.IndexOf(SingleBoiler.Stealno)=-1 then
               ErrList.Add(P^.orderno+' '+VarToStr(P^.orderitem)+' '+P^.materialno+
                           ' 指定生產日期、機台、鍋次的鋼板不同,但略過');

            if SingleBoiler.AdCode<>AdCode then
               ErrList.Add(P^.orderno+' '+VarToStr(P^.orderitem)+' '+P^.materialno+
                           ' 指定生產日期、機台、鍋次的合鍋規范不同,但略過');

            if P^.sqty<=0 then
               Break;
          end
          else if SingleBoiler.AdCode=0 then
            SingleBoiler.RemainBooks:=0;
        end;
      end;
    end else                                                           //1+正常
    if CanUseStealno.IndexOf(SingleBoiler.Stealno)<>-1 then
    begin
      if SingleBoiler.AdCode=0 then
      begin
        SingleBoiler.RemainBooks:=FBooks;
        if SingleBoiler.AddOrderObj(FMachine, P) then
        begin
          SingleBoiler.AdCode:=AdCode;
          SingleBoiler.OZ:=tmpOZ;
          if P^.sqty<=0 then
             Break;
        end else
          SingleBoiler.RemainBooks:=0;
      end
      else if (SingleBoiler.AdCode=AdCode) and (SingleBoiler.RemainBooks>0) then
      begin
        if (Length(SingleBoiler.OZ)=1) or
           (Pos(tmpOZ, SingleBoiler.OZ)>0) or
           (Pos(tmpAdCode, FAdCode)>0) then
        begin
          if SingleBoiler.AddOrderObj(FMachine, P) then
          begin
            if (Length(SingleBoiler.OZ)=1) and (SingleBoiler.OZ<>tmpOZ) then
               SingleBoiler.OZ:=SingleBoiler.OZ+tmpOZ;
            if P^.sqty<=0 then
               Break;
          end;
        end;
      end;
    end;
  end;

  if bo and (P^.sdate1<P^.sdate) then
     Exit;

  if (P^.sqty>0) and (FRemainBoiler>0) then
  begin
    Dec(FRemainBoiler);
    SingleBoiler:=TSingleBoiler.Create(P^.sdate, FTotalBoiler, GetStealno);
    SingleBoiler.CurrentBoiler:=FTotalBoiler-FRemainBoiler;
    FList.Add(SingleBoiler);

    AddOrderObj(AdCode, CanUseStealno, P, ErrList, FList.Count-1);
  end;  
end;

constructor TSingleLine.Create(xMachine, xAdCode: string; xBooks: Double;
  xStealnoList:TStrings);
begin
  FMachine:=xMachine;
  FAdCode:=xAdCode;
  FBooks:=xBooks;
  FRemainBoiler:=0;
  FEmptyCount:=0;

  FList:=TList.Create;
  FStealnoList:=TStringList.Create;
  FStealnoList.AddStrings(xStealnoList);
end;

destructor TSingleLine.Destroy;
var
  i:Integer;
begin
  for i:=FList.Count-1 downto 0 do
    TSingleBoiler(FList[i]).Free;
  FreeAndNil(FList);
  FreeAndNil(FStealnoList);

  inherited Destroy;
end;

//根據上一鍋鋼板編號，取下一鍋的鋼板編號
//FStealnoList一定有資料
function TSingleLine.GetStealno:string;
var
  cnt:Integer;
begin
  cnt:=List.Count;
  if cnt>0 then
  begin
    if TSingleBoiler(List[cnt-1]).OldJitem>0 then
       cnt:=0
    else
    begin
      cnt:=FStealnoList.IndexOf(TSingleBoiler(List[cnt-1]).Stealno)+1;
      if cnt>=FStealnoList.Count then
         cnt:=0;
    end;
  end;
  Result:=FStealnoList.Strings[cnt];
end;

procedure TSingleLine.SetTotalBoiler(Value: Integer);
begin
  if FTotalBoiler<>Value then
     FTotalBoiler:=Value;
end;

procedure TSingleLine.SetRemainBoiler(Value: Integer);
begin
  if FRemainBoiler<>Value then
     FRemainBoiler:=Value;
end;

procedure TSingleLine.SetEmptyCount(Value: Integer);
begin
  if FEmptyCount<>Value then
     FEmptyCount:=Value;
end;

end.
