unit unMPST012_units;

interface

uses
  SysUtils, DBClient, Math, DateUtils;

  function GetStypeAdRemainQty(CDSMPSI390, CDSMPS390:TClientDataSet;
    Sdate:TDateTime; Stype, Ad:string):Double;
  procedure UpdateStypeAdRemainQty(CDSMPSI390:TClientDataSet;
    Sdate:TDateTime; Stype, Ad:string; RemainQty:Double);

  function GetCustRemainQty(CDSMPSI180, CDSMPS180:TClientDataSet;
    Sdate:TDateTime; Custno, Ad:string; IsThin:Integer):Double;
  procedure UpdateCustRemainQty(CDSMPSI180:TClientDataSet;
    Sdate:TDateTime; Custno, Ad:string; IsThin:Integer; RemainQty:Double);

const g_xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderdate" fieldtype="datetime"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="materialno1" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="sqty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
           +'<FIELD attrname="regulateQty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
           +'<FIELD attrname="orderQty" fieldtype="fixed" DECIMALS="3" WIDTH="15"/>'
           +'<FIELD attrname="edate" fieldtype="datetime"/>'
           +'<FIELD attrname="adate" fieldtype="datetime"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ta_oeb35" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custnoreal" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custom" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="custom2" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="pnlsize1" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
           +'<FIELD attrname="pnlsize2" fieldtype="fixed" DECIMALS="2" WIDTH="10"/>'
           +'<FIELD attrname="stype" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="sdate" fieldtype="datetime"/>'
           +'<FIELD attrname="srcflag" fieldtype="i4"/>'
           +'<FIELD attrname="oz" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="thickness" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="supplier" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="pnlnum" fieldtype="i4"/>'
           +'<FIELD attrname="orderno2" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem2" fieldtype="i4"/>'
           +'<FIELD attrname="uuid" fieldtype="string" WIDTH="36"/>'
           +'<FIELD attrname="orderBu" fieldtype="string" WIDTH="6"/>'
           +'<FIELD attrname="premark3" fieldtype="string" WIDTH="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

const g_maxqty=9999999;

implementation

//取膠系+尺寸可用產能
function GetStypeAdRemainQty(CDSMPSI390, CDSMPS390:TClientDataSet;
  Sdate:TDateTime; Stype, Ad:string):Double;
var
  bool:Boolean;
begin
  Result:=g_maxqty;
  bool:=False;
  with CDSMPSI390 do
  begin
    Filtered:=False;
    Filter:='sdate='+Quotedstr(DateToStr(Sdate));
    Filtered:=True;
    while not Eof do
    begin
      if SameText(Stype, FieldByName('stype').AsString) and
         (Pos(Ad, FieldByName('ad').AsString)>0) then
      begin
        bool:=True;
        Result:=RoundTo(FieldByName('maxqty').AsFloat-FieldByName('tot').AsFloat, -3);
        Break;
      end;
      Next;
    end;
  end;

  if not bool then
  begin
    with CDSMPS390 do
    begin
      First;
      while not Eof do
      begin
        if SameText(Stype, FieldByName('stype').AsString) and
           (Pos(Ad, FieldByName('ad').AsString)>0) then
        begin
          Result:=FieldByName('maxqty').AsFloat;
          CDSMPSI390.Filtered:=False;
          CDSMPSI390.Append;
          CDSMPSI390.FieldByName('sdate').AsDateTime:=Sdate;
          CDSMPSI390.FieldByName('stype').AsString:=FieldByName('stype').AsString;
          CDSMPSI390.FieldByName('ad').AsString:=FieldByName('ad').AsString;
          CDSMPSI390.FieldByName('maxqty').AsFloat:=FieldByName('maxqty').AsFloat;
          CDSMPSI390.FieldByName('tot').AsFloat:=0;
          CDSMPSI390.Post;
          CDSMPSI390.MergeChangeLog;
          Break;
        end;
        Next;
      end;
    end;
  end;
end;

//更新膠系+尺寸已用產能
procedure UpdateStypeAdRemainQty(CDSMPSI390:TClientDataSet;
  Sdate:TDateTime; Stype, Ad:string; RemainQty:Double);
begin
  with CDSMPSI390 do
  begin
    Filtered:=False;
    Filter:='sdate='+Quotedstr(DateToStr(Sdate));
    Filtered:=True;
    while not Eof do
    begin
      if SameText(Stype, FieldByName('stype').AsString) and
         (Pos(Ad, FieldByName('ad').AsString)>0) then
      begin
        Edit;
        FieldByName('tot').AsFloat:=FieldByName('maxqty').AsFloat-RemainQty;
        Post;
        MergeChangeLog;
        Break;
      end;
      Next;
    end;
  end;
end;

//取客戶可用產能
function GetCustRemainQty(CDSMPSI180, CDSMPS180:TClientDataSet;
  Sdate:TDateTime; Custno, Ad:string; IsThin:Integer):Double;
var
  ym:string;
  bool:Boolean;
begin
  Result:=g_maxqty;
  bool:=False;
  ym:=FormatDateTime('YYYYMM',Sdate);
  with CDSMPSI180 do
  begin
    Filtered:=False;
    Filter:='sdate='+Quotedstr(DateToStr(Sdate))
           +' and isthin='+IntToStr(IsThin);
    Filtered:=True;
    IndexFieldNames:='sdate;groupid';
    First;
    while not Eof do
    begin
      if (Pos(Custno, FieldByName('custno').AsString)>0) and
         ((Length(FieldByName('ad').AsString)=0) or (Pos(Ad, FieldByName('ad').AsString)>0)) then
      begin
        if Pos(ym, FieldByName('lockmonth').AsString)>0 then
        begin
          Result:=0;
          Exit;
        end;

        bool:=True;
        Result:=RoundTo(FieldByName('maxqty').AsFloat-FieldByName('tot').AsFloat, -3);
        Break;
      end;
      Next;
    end;
  end;

  if not bool then
  begin
    with CDSMPS180 do
    begin
      Filtered:=False;
      Filter:='isthin='+IntToStr(IsThin);
      Filtered:=True;
      IndexFieldNames:='groupid';
      First;
      while not Eof do
      begin
        if (Pos(Custno, FieldByName('custno').AsString)>0) and
           ((Length(FieldByName('ad').AsString)=0) or (Pos(Ad, FieldByName('ad').AsString)>0)) then
        begin
          if Pos(ym, FieldByName('lockmonth').AsString)>0 then
          begin
            Result:=0;
            Exit;
          end;

          Result:=FieldByName('maxqty').AsFloat;

          CDSMPSI180.Filtered:=False;
          CDSMPSI180.IndexFieldNames:='';
          CDSMPSI180.Append;
          CDSMPSI180.FieldByName('sdate').AsDateTime:=Sdate;
          CDSMPSI180.FieldByName('groupid').AsString:=FieldByName('groupid').AsString;
          CDSMPSI180.FieldByName('custno').AsString:=FieldByName('custno').AsString;
          CDSMPSI180.FieldByName('ad').AsString:=FieldByName('ad').AsString;
          CDSMPSI180.FieldByName('lockmonth').AsString:=FieldByName('lockmonth').AsString;
          CDSMPSI180.FieldByName('isthin').AsInteger:=isthin;
          CDSMPSI180.FieldByName('maxqty').AsFloat:=FieldByName('maxqty').AsFloat;
          CDSMPSI180.FieldByName('tot').AsFloat:=0;
          CDSMPSI180.Post;
          CDSMPSI180.MergeChangeLog;
          Break;
        end;
        Next;
      end;
    end;
  end;
end;

//更新客戶可用產能
procedure UpdateCustRemainQty(CDSMPSI180:TClientDataSet;
  Sdate:TDateTime; Custno, Ad:string; IsThin:Integer; RemainQty:Double);
begin
  with CDSMPSI180 do
  begin
    Filtered:=False;
    Filter:='sdate='+Quotedstr(DateToStr(Sdate))
           +' and isthin='+IntToStr(IsThin);
    Filtered:=True;
    IndexFieldNames:='sdate;groupid';
    First;
    while not Eof do
    begin
      if (Pos(Custno, FieldByName('custno').AsString)>0) and
         ((Length(FieldByName('ad').AsString)=0) or (Pos(Ad, FieldByName('ad').AsString)>0)) then
      begin
        Edit;
        FieldByName('tot').AsFloat:=FieldByName('maxqty').AsFloat-RemainQty;
        Post;
        MergeChangeLog;
        Break;
      end;
      Next;
    end;
  end;
end;

end.
