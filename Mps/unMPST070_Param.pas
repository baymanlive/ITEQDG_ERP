{*******************************************************}
{                                                       }
{                unMPST070_Param                        }
{                Author: kaikai                         }
{                Create date: 2016/8/22                 }
{                Description: PP排程參數                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_Param;

interface

uses
   Classes, SysUtils, Variants, DBClient, StrUtils, DB, Math, unGlobal, unCommon;

type
  POrderRec = ^ TOrderRec;
  TOrderRec = Record
    sdate,
    orderdate,
    orderno,
    orderitem,
    custno,
    custno2,
    custom,
    custom2,
    edate,
    adate,
    materialno,
    materialno1,
    pnlsize1,
    pnlsize2,
    breadth,
    fiber,
    orderqty,
    sqty,
    sdate1,
    machine1,
    errorid,
    wono,
    orderno2,
    orderitem2,
    srcflag,
    pnlnum:         variant;    //pnlnum 表中無此欄位,保存PN板一開几
end;

type
  TMPST070_Param = class
  private
    FCDS1:TCLientDataSet;
    FCDS2:TCLientDataSet;
    FCDS3:TCLientDataSet;
    FCDS4:TCLientDataSet;
    FCDS5:TCLientDataSet;
    FCDS6:TCLientDataSet;
    FCDS7:TCLientDataSet;
    FCDS8:TCLientDataSet;
    FCDS9:TCLientDataSet;
    FCDS10:TCLientDataSet;
    FCDS11:TCLientDataSet;
    function GetPPData(xType:string):OleVariant;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetParameData_Exec;
    procedure SetBSRec(var SMRec:TSplitMaterialnoPP; Pno:string);
    procedure SetCoreRec(var SMRec:TSplitMaterialnoPPCore; Pno:string);
    function GetMachineFilter(SMRec:TSplitMaterialnoPP; P:POrderRec):string;
    function GetMachineFilterCore(SMRec:TSplitMaterialnoPPCore; P:POrderRec):string;
    function GetSpeed(Machine:string; SMRec:TSplitMaterialnoPP):Double;
    function GetSpeedCore(Machine:string; SMRec:TSplitMaterialnoPPCore):Double;
    function GetFiber(Fiber:string):string;
    function AdIsPlan(Machine, Adhesive:string; wDate:TDateTime):Integer;
    function SdateIsPlan(Machine:string; Sdate:TDateTime):Boolean;
    function GetFiberVendor(Machine, Custno, Pno:string):string;
    function GetFiSno(Fiber:string):Integer;
    function CheckFiberLock(Machine, Fiber, Vendor, Breadth:string; var IsLock:Boolean;
      var Sdate:TDateTime):Boolean;
    function CheckFiberOverCnt(Machine, AD, Fiber: string;
      Sdate: TDateTime): Boolean;
    function CheckPNLLock(P:POrderRec):Boolean;
  published
    property CDS_ChanNeng:TClientDataSet read FCDS1;
  end;

implementation

{ TMPST070_Param }

constructor TMPST070_Param.Create;
begin
  FCDS1:=TClientDataSet.Create(nil);   //每天產能
  FCDS2:=TClientDataSet.Create(nil);   //每線機速
  FCDS3:=TClientDataSet.Create(nil);   //內用core料號布種
  FCDS4:=TClientDataSet.Create(nil);   //內用core料號幅寬
  FCDS5:=TClientDataSet.Create(nil);   //指定机机台
  FCDS6:=TClientDataSet.Create(nil);   //按膠系計劃性生產
  FCDS7:=TClientDataSet.Create(nil);   //布種供應商
  FCDS8:=TClientDataSet.Create(nil);   //布種大小
  FCDS9:=TClientDataSet.Create(nil);   //布種鎖定
  FCDS10:=TClientDataSet.Create(nil);  //F/6一天最多排2個布種
  FCDS11:=TClientDataSet.Create(nil);  //PN板裁切利用率
end;

destructor TMPST070_Param.Destroy;
begin
  FreeAndNil(FCDS1);
  FreeAndNil(FCDS2);
  FreeAndNil(FCDS3);
  FreeAndNil(FCDS4);
  FreeAndNil(FCDS5);
  FreeAndNil(FCDS6);
  FreeAndNil(FCDS7);
  FreeAndNil(FCDS8);
  FreeAndNil(FCDS9);
  FreeAndNil(FCDS10);
  FreeAndNil(FCDS11);

  inherited Destroy;
end;

function TMPST070_Param.GetPPData(xType:string):OleVariant;
var
  tmpSQL:string;
  Data1:OleVariant;
begin
  tmpSQL:='exec proc_GetPP '+xType+','+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data1) then
     Result:=Data1
  else
     Result:=null;
end;

//執行排程
procedure TMPST070_Param.GetParameData_Exec;
begin
  FCDS1.Data:=GetPPData('1');
  FCDS2.Data:=GetPPData('2');
  FCDS3.Data:=GetPPData('3');
  FCDS4.Data:=GetPPData('4');
  FCDS5.Data:=GetPPData('5');
  FCDS6.Data:=GetPPData('6');
  FCDS7.Data:=GetPPData('7');
  FCDS8.Data:=GetPPData('8');
  FCDS9.Data:=GetPPData('9');
  FCDS10.Data:=GetPPData('10');
  FCDS11.Data:=GetPPData('11');
end;

//過濾可以機台-外賣pp
function TMPST070_Param.GetMachineFilter(SMRec:TSplitMaterialnoPP;
  P:POrderRec):string;
begin
  Result:='';

  if (not VarIsNull(P^.machine1)) and
     (not VarIsNull(P^.sdate1)) then
  begin
    Result:='machine='+Quotedstr(P^.machine1);
    Exit;
  end;

  with FCDS5 do
  begin
    Filtered:=False;
    Filter:='id=1 and adhesive='+Quotedstr(SMRec.M2)
           +' and fiber='+Quotedstr(SMRec.M4_7)
           +' and rc_lower<='+FloatToStr(StrToInt(SMRec.M8_10)/10)
           +' and rc_upper>='+FloatToStr(StrToInt(SMRec.M8_10)/10);
    if not VarIsNull(P^.machine1) then
       Filter:=Filter+' and machine='+Quotedstr(P^.machine1);
    Filtered:=True;
    IndexFieldNames:='machine';
    while not Eof do
    begin
      if Result<>'' then
         Result:=Result+' or ';
      Result:=Result+'machine='+Quotedstr(FieldByName('machine').AsString);
      Next;
    end;
  end;
end;

//過濾可以機台-自用pp
function TMPST070_Param.GetMachineFilterCore(SMRec:TSplitMaterialnoPPCore;
  P:POrderRec):string;
begin
  Result:='';

  if (not VarIsNull(P^.machine1)) and
     (not VarIsNull(P^.sdate1)) then
  begin
    Result:='machine='+Quotedstr(P^.machine1);
    Exit;
  end;

  with FCDS5 do
  begin
    Filtered:=False;
    Filter:='id=2 and adhesive='+Quotedstr(SMRec.M2)
           +' and fiber='+Quotedstr(SMRec.M4_5)
           +' and rc_lower<='+FloatToStr(StrToInt(SMRec.M6_8)/10)
           +' and rc_upper>='+FloatToStr(StrToInt(SMRec.M6_8)/10);
    if not VarIsNull(P^.machine1) then
       Filter:=Filter+' and machine='+Quotedstr(P^.machine1);
    Filtered:=True;
    IndexFieldNames:='machine';
    while not Eof do
    begin
      if Result<>'' then
         Result:=Result+' or ';
      Result:=Result+'machine='+Quotedstr(FieldByName('machine').AsString);
      Next;
    end;
  end;
end;

//設置BS料號記錄
procedure TMPST070_Param.SetBSRec(var SMRec:TSplitMaterialnoPP; Pno:string);
var
  tmpPno:string;
begin
  tmpPno:=UpperCase(Pno);
  SMRec.M1:=Copy(tmpPno,1,1);
  SMRec.M2:=Copy(tmpPno,2,1);
  SMRec.M3:=Copy(tmpPno,3,1);
  SMRec.M4_7:=Copy(tmpPno,4,4);
  SMRec.M8_10:=Copy(tmpPno,8,3);
  SMRec.M11_13:=Copy(tmpPno,11,3);
  SMRec.M14_16:=Copy(tmpPno,14,3);
  SMRec.M17:=Copy(tmpPno,17,1);
  SMRec.M18:=Copy(tmpPno,18,1);
end;

//設置core料號記錄
procedure TMPST070_Param.SetCoreRec(var SMRec:TSplitMaterialnoPPCore; Pno:string);
var
  tmpPno:string;
begin
  tmpPno:=UpperCase(Pno);
  SMRec.M1:=Copy(tmpPno,1,1);
  SMRec.M2:=Copy(tmpPno,2,1);
  SMRec.M3:=Copy(tmpPno,3,1);
  SMRec.M4_5:=Copy(tmpPno,4,2);
  SMRec.M6_8:=Copy(tmpPno,6,3);
  SMRec.M9:=Copy(tmpPno,9,1);
  SMRec.M10:=Copy(tmpPno,10,1);
  SMRec.M11:=Copy(tmpPno,11,1);
  SMRec.M12:=Copy(tmpPno,12,1);
  SMRec.M13:=Copy(tmpPno,13,1);

  if FCDS3.Active and FCDS3.Locate('Code4_5',SMRec.M4_5,[]) then
     SMRec.MFiber:=FCDS3.FieldByName('Fiber').AsString
  else
     SMRec.MFiber:='err';

  if FCDS4.Active and FCDS4.Locate('Code10',SMRec.M10,[]) then
     SMRec.M10:=FCDS4.FieldByName('Breadth').AsString
  else
     SMRec.M10:='err';
end;

//取機速-外賣pp
function TMPST070_Param.GetSpeed(Machine:string; SMRec:TSplitMaterialnoPP):Double;
begin
  Result:=0;

  if not FCDS2.Active then
     FCDS2.Data:=GetPPData('2');
     
  with FCDS2 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and adhesive='+Quotedstr(SMRec.M2)
           +' and fiber='+Quotedstr(SMRec.M4_7)
           +' and rc_lower<='+FloatToStr(StrToInt(SMRec.M8_10)/10)
           +' and rc_upper>='+FloatToStr(StrToInt(SMRec.M8_10)/10);
    Filtered:=True;          
    if not isEmpty then
       Result:=FieldByName('speed').AsFloat;
  end;
end;

//取機速-內用core
function TMPST070_Param.GetSpeedCore(Machine:string; SMRec:TSplitMaterialnoPPCore):Double;
begin
  Result:=0;

  if not FCDS2.Active then
     FCDS2.Data:=GetPPData('2');

  with FCDS2 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and adhesive='+Quotedstr(SMRec.M2)
           +' and fiber='+Quotedstr(SMRec.MFiber)
           +' and rc_lower<='+FloatToStr(StrToInt(SMRec.M6_8)/10)
           +' and rc_upper>='+FloatToStr(StrToInt(SMRec.M6_8)/10);
    Filtered:=True;
    if not isEmpty then
       Result:=FieldByName('speed').AsFloat;
  end;
end;

//內用core布種2碼轉換成4碼
function TMPST070_Param.GetFiber(Fiber:string):string;
begin
  if not FCDS3.Active then
     FCDS3.Data:=GetPPData('3');
  if FCDS3.Locate('Code4_5',Fiber,[]) then
     Result:=FCDS3.FieldByName('Fiber').AsString
  else
     Result:=Fiber;
end;

//判斷膠系是否計劃生產
//Result=0不是計劃生產
//Result=1是計劃生產,但機台或日期不符
//Result=2是計劃生產,機台或日期符合
function TMPST070_Param.AdIsPlan(Machine,Adhesive:string; wDate:TDateTime):Integer;
var
  str:string;
begin
  Result:=0;
  str:='';
  
  with FCDS6 do
  begin
    First;
    while not Eof do
    begin
      if Pos(Adhesive, FieldByName('adhesive').AsString)>0 then
         str:=str+','+FieldByName('machine').AsString;
      Next;
    end;
  end;

  if Length(str)=0 then
     Exit;

  if Pos(Machine, str)=0 then
  begin
    Result:=1;
    Exit;
  end;

  with FCDS6 do
  begin
    First;
    while not Eof do
    begin
      if SameText(Machine, FieldByName('machine').AsString) and
        (Pos(Adhesive, FieldByName('adhesive').AsString)>0) then
      begin
        if (FieldByName('fmdate').AsDateTime<=wDate) and
           (FieldByName('todate').AsDateTime>=wDate) then
           Result:=2
        else
           Result:=1;
        Break;
      end;
      Next;
    end;
  end;
end;

//判斷日期是否計劃生產
function TMPST070_Param.SdateIsPlan(Machine:string;Sdate:TDateTime):Boolean;
begin
  Result:=False;
  with FCDS6 do
  begin
    First;
    while not Eof do
    begin
      if SameText(Machine, FieldByName('machine').AsString) and
         (FieldByName('fmdate').AsDateTime<=Sdate) and
         (FieldByName('todate').AsDateTime>=Sdate) then
      begin
        Result:=True;
        Break;
      end;
      Next;
    end;
  end;
end;

//取布種供應商
function TMPST070_Param.GetFiberVendor(Machine,Custno,Pno:string):string;
var
  IsBS:Boolean;
  tmpRecno,tmpMaxNum,tmpNum:Integer;
  Adhesive,Fiber,Code3,LastCode3,LastCode:string;
begin
  Result:='';
  IsBS:=Length(Pno)=18;
  if not IsBS then   //內用core暫時不用布種
     Exit;
  tmpMaxNum:=-1;
  tmpRecno:=-1;
  Adhesive:=Copy(Pno,2,1);
  if IsBS then
  begin
    Code3:=Copy(Pno,3,1);
    Fiber:=Copy(Pno,4,4);
    if FCDS3.Locate('Fiber',Fiber,[]) then
       Fiber:=FCDS3.FieldByName('Code4_5').AsString;
    LastCode3:=Copy(Pno,16,1);;
    LastCode:=Copy(Pno,18,1);
  end else
  begin
    Code3:=Copy(Pno,3,1);
    Fiber:=Copy(Pno,4,2);
    LastCode3:=Copy(Pno,11,1);
    LastCode:=Copy(Pno,13,1);
  end;
  with FCDS7 do
  begin
    Filtered:=False;
    if SameText(g_UInfo^.BU,'ITEQJX') then
       Filter:='IsDG=1'
    else begin
      if Pos(RightStr(Machine,1),'12345')>0 then
         Filter:='IsDG=1'
      else
         Filter:='IsDG=0';
    end;
    Filtered:=True;
    First;
    while not Eof do
    begin
      tmpNum:=0;
      if (FieldByName('custno').AsString='*') or
         (Pos('/'+Custno+'/','/'+FieldByName('custno').AsString+'/')>0) then
         Inc(tmpNum)
      else begin
        Next;
        Continue;
      end;

      if (FieldByName('adhesive').AsString='*') or
         (Pos('/'+Adhesive+'/','/'+FieldByName('adhesive').AsString+'/')>0) then
         Inc(tmpNum)
      else begin
        Next;
        Continue;
      end;

      if (FieldByName('fiber').AsString='*') or
         (Pos('/'+Fiber+'/','/'+FieldByName('fiber').AsString+'/')>0) then
         Inc(tmpNum)
      else begin
        Next;
        Continue;
      end;

      if IsBS then
      begin
        if (FieldByName('code3').AsString='*') or
           (Pos('/'+Code3+'/','/'+FieldByName('code3').AsString+'/')>0) then
           Inc(tmpNum)
        else begin
          Next;
          Continue;
        end;
      end;

      if not IsBS then
      begin
        if (FieldByName('lastcode3').AsString='*') or
           (Pos('/'+lastcode3+'/','/'+FieldByName('lastcode3').AsString+'/')>0) then
           Inc(tmpNum)
        else begin
          Next;
          Continue;
        end;
      end;

      if (FieldByName('lastcode').AsString='*') or
         (Pos('/'+LastCode+'/','/'+FieldByName('lastcode').AsString+'/')>0) then
         Inc(tmpNum)
      else begin
        Next;
        Continue;
      end;

      if (tmpNum>0) and (tmpMaxNum<tmpNum) then
      begin
        tmpMaxNum:=tmpNum;
        tmpRecno:=Recno;
      end;
      if tmpMaxNum=5 then
         Break;

      Next;
    end;
    if tmpRecno<>-1 then
    begin
      RecNo:=tmpRecno;
      Result:=FieldByName('vendor').AsString;
    end;
  end;
end;

//布種大小
function TMPST070_Param.GetFiSno(Fiber:string):Integer;
begin
  if not FCDS8.Active then
     FCDS8.Data:=GetPPData('8');
  if FCDS8.Locate('Fi',Fiber,[]) then
     Result:=FCDS8.FieldByName('Sno').AsInteger
  else
     Result:=0;
end;

//布種鎖定
//Machine,Fiber,Vendor, Breadth:線別,布种,廠商,幅寬
//Lock:為True時不考慮Sdate日期,
//     為False時,則必需指定生產日期,並且≧Sdate
function TMPST070_Param.CheckFiberLock(Machine, Fiber, Vendor, Breadth:string;
  var IsLock:Boolean; var Sdate:TDateTime):Boolean;
var
  b:Double;
  s:string;
begin
  Result:=False;
  IsLock:=False;
  Sdate:=EncodeDate(1955, 5, 5);
  if SameText(g_UInfo^.BU,'ITEQDG') then
  begin
    if Pos(UpperCase(Machine), g_MachinePP_DG)>0 then
       s:='bu=''ITEQDG'''
    else
       s:='bu=''ITEQGZ''';
  end else
    s:='bu='+Quotedstr(g_UInfo^.BU);

  try
    b:=StrToFloat(Breadth);
  except
    Exit;
  end;

  if b<44 then
     s:=s+' and narrow=''Y'''
  else
     s:=s+' and narrow=''N''';

  s:=s+' and fiber='+Quotedstr(Fiber)
      +' and vendor='+Quotedstr(Vendor);

  with FCDS9 do
  begin
    Filtered:=False;
    Filter:=s;
    Filtered:=True;
    if not isEmpty then //if Locate('fiber;vendor', VarArrayOf([Fiber,Vendor]),[]) then
    begin
      Result:=True;
      IsLock:=FieldByName('lock').AsBoolean;
      if not IsLock then
         Sdate:=FieldByName('sdate').AsDateTime;
    end;
  end;
end;

//檢查一天中F/6膠系布種排產次數
function TMPST070_Param.CheckFiberOverCnt(Machine, AD, Fiber:string;
  Sdate:TDateTime):Boolean;
var
  tmpFi:string;
begin
  Result:=False;

  if (Pos(AD, '6F')=0) or (Length(Fiber)<>4) then
     Exit;
     
  if Fiber='3313' then
     tmpFi:='2313'
  else
     tmpFi:=Fiber;

  with FCDS10 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and sdate='+Quotedstr(DateToStr(Sdate))
           +' and ad='+Quotedstr(AD);
    Filtered:=True;
    if Locate('fi', tmpFi, []) then
       Exit;

    if RecordCount<=1 then
    begin
      Append;
      FieldByName('machine').AsString:=Machine;
      FieldByName('sdate').AsDateTime:=Sdate;
      FieldByName('ad').AsString:=AD;
      FieldByName('fi').AsString:=tmpFi;
      Post;
      MergeChangeLog;
    end else
      Result:=True;
  end;
end;

//PN板裁切利用率,若小於設定的利用率鎖定
function TMPST070_Param.CheckPNLLock(P:POrderRec):Boolean;
var
  pnlnum:Integer;
  num1,num2:Double;
begin
  Result:=False;
  if FCDS11.IsEmpty then
     Exit;

  pnlnum:=StrToIntDef(VarToStr(P^.pnlnum),0);
  if pnlnum<=0 then
     Exit;

  num1:=StrToFloatDef(VarToStr(P^.pnlsize2),0);
  num2:=StrToFloatDef(P^.breadth,0);
  if (num1<=0) or (num2<=0) then
     Exit;

  num1:=RoundTo((num1*pnlnum)/num2*100, -1);

  Result:=(num1<FCDS11.FieldByName('Urate_lower').AsFloat) or
          (num1>FCDS11.FieldByName('Urate_upper').AsFloat);
end;

end.
