{*******************************************************}
{                                                       }
{                unMPS_IcoFlag                          }
{                Author: kaikai                         }
{                Create date: 2015/3/27                 }
{                Description: 生產進度圖標狀態          }
{                             MPSR020、MPST040          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPS_IcoFlag;

interface

uses
   Classes, SysUtils, Variants, DB, DBClient, DateUtils, unGlobal, unCommon;

type
  TMPS_IcoFlag = class
  private
    FListD1:TStrings;
    FListD2:TStrings;
    FData:OleVariant;
    FCDS:TClientDataSet;
    FtmpCDS:TClientDataSet;
    FStimeCDS:TClientDataSet;
    function GetStime(Custno: string): TDateTime;
    procedure SetData(value:OleVariant);
    function GetData:OleVariant;
    function GetIco020(value:Integer; pnlpno:string; qty:Double):Integer;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property Data:OleVariant read GetData write SetData;
  end;

implementation

const l_DefStr='@';
const l_SpaceStr=' ';
const l_CDSXml= '<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="bu" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="simuver" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="citem" fieldtype="i4"/>'
               +'<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="machine" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="sdate" fieldtype="dateTime"/>'
               +'<FIELD attrname="currentboiler" fieldtype="i4"/>'
               +'<FIELD attrname="orderdate" fieldtype="dateTime"/>'
               +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="orderitem" fieldtype="i4"/>'
               +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="orderqty" fieldtype="r8"/>'
               +'<FIELD attrname="sqty" fieldtype="r8"/>'
               +'<FIELD attrname="stealno" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="custom" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="adate_new" fieldtype="dateTime"/>'
               +'<FIELD attrname="stime" fieldtype="dateTime"/>'
               +'<FIELD attrname="orderno2" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="orderitem2" fieldtype="i4"/>'
               +'<FIELD attrname="materialno1" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="pnlsize1" fieldtype="r8"/>'
               +'<FIELD attrname="pnlsize2" fieldtype="r8"/>'
               +'<FIELD attrname="premark" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="wostation" fieldtype="i4"/>'
               +'<FIELD attrname="wostation_qtystr" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="wostation_d1str" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="wostation_d2str" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="s1" fieldtype="r8"/>'
               +'<FIELD attrname="s1_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s1_ico" fieldtype="i4"/>'
               +'<FIELD attrname="s2" fieldtype="r8"/>'
               +'<FIELD attrname="s2_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s2_ico" fieldtype="i4"/>'
               +'<FIELD attrname="s3" fieldtype="r8"/>'
               +'<FIELD attrname="s3_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s3_ico" fieldtype="i4"/>'
               +'<FIELD attrname="s4" fieldtype="r8"/>'
               +'<FIELD attrname="s4_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s4_ico" fieldtype="i4"/>'
               +'<FIELD attrname="sy_date" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="xy_date" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="cx_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s5" fieldtype="r8"/>'
               +'<FIELD attrname="s5_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s5_ico" fieldtype="i4"/>'
               +'<FIELD attrname="cb_style" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="s6" fieldtype="r8"/>'
               +'<FIELD attrname="s6_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s6_ico" fieldtype="i4"/>'
               +'<FIELD attrname="s7" fieldtype="r8"/>'
               +'<FIELD attrname="s7_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="bz_date" fieldtype="dateTime"/>'
               +'<FIELD attrname="s7_ico" fieldtype="i4"/>'
               +'<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>'  //工單備註一:在生產進度表輸入
               +'<FIELD attrname="remark2" fieldtype="string" WIDTH="200"/>' //工單備註二:在生產進度表輸入
               +'<FIELD attrname="co_str" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="zc" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="sj" fieldtype="string" WIDTH="200"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

{ TMPS_IcoFlag }

constructor TMPS_IcoFlag.Create;
var
  tmpMS:TMemoryStream;
begin
  FListD1:=TStringList.Create;
  FListD2:=TStringList.Create;
  FListD1.Delimiter:=',';

  FtmpCDS:=TClientDataSet.Create(nil);
  FCDS:=TClientDataSet.Create(nil);
  FStimeCDS:=TClientDataSet.Create(nil);
  tmpMS:=TMemoryStream.Create;
  try
    FListD1.Add(l_CDSXml);
    FListD1.SaveToStream(tmpMS);
    tmpMS.Position:=0;
    FCDS.LoadFromStream(tmpMS);
  finally
    FListD1.Clear;
    FreeAndNil(tmpMS);
  end;
end;

destructor TMPS_IcoFlag.Destroy;
begin
  FreeAndNil(FListD1);
  FreeAndNil(FListD2);
  FreeAndNil(FtmpCDS);
  FreeAndNil(FCDS);
  FreeAndNil(FStimeCDS);

  inherited Destroy;
end;

function TMPS_IcoFlag.GetStime(Custno: string): TDateTime;
var
  Data:OleVariant;
  tmpSQL:string;
begin
  Result:=EncodeDateTime(1955,5,5,0,0,0,0);
  if not FStimeCDS.Active then
  begin
    tmpSQL:='Select Custno,Stime From MPS290 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    FStimeCDS.Data:=Data;
  end;

  with FStimeCDS do
  begin
    First;
    while not Eof do
    begin
      if Pos(Custno, Fields[0].AsString)>0 then
      begin
        if not Fields[1].IsNull then
           Result:=EncodeDateTime(1955,5,5,HourOf(Fields[1].AsDateTime),
                                           MinuteOf(Fields[1].AsDateTime),0,0);
        Break;
      end;
      Next;
    end;
  end;
end;

//MPSR020設置取s1..s7圖標
//外觀檢查完工->包裝5h
function TMPS_IcoFlag.GetIco020(value:Integer; pnlpno:string; qty:Double):Integer;
var
  ispnl,isoth:Boolean;
  h,tmpWoStation:Integer;
  D1,D2, defD:TDateTime;
  function GetDef:Integer;
  begin
    if tmpWoStation=value then
       Result:=1  //綠色
    else if tmpWoStation>value then
       Result:=3  //深灰色
    else
       Result:=0; //淺灰色
  end;
begin
  Result:=0;
  h:=-1;
  defD:=EncodeDate(2015,1,1);
  tmpWoStation:=FCDS.FieldByName('WoStation').AsInteger;
  ispnl:=Length(pnlpno)>0;
  isoth:=SameText(pnlpno,'EU003311CIX') or SameText(pnlpno,'EU003321CIX');

  case value of
    1,2,3,4:Result:=GetDef;
    5:begin                                               //裁邊站
        if not FCDS.FieldByName('cx_date').IsNull then    //拆卸已掃描
        begin
          D1:=FCDS.FieldByName('cx_date').AsDateTime;

          if FCDS.FieldByName('s5_date').IsNull then      //CCL裁邊時間
             D2:=defD
          else
             D2:=FCDS.FieldByName('s5_date').AsDateTime;

          if D2>defD then
             h:=MinutesBetween(D1,D2)
          else
             h:=MinutesBetween(D1,Now);
        end;

        if isoth then
        begin
          if h>2040 then
             Result:=2
          else if (h>=1920) and (tmpWoStation<6) then
             Result:=4
          else
             Result:=GetDef;
        end
        else if ispnl then
        begin
          if h>1440 then
             Result:=2
          else if (h>=1320) and (tmpWoStation<6) then
             Result:=4
          else
             Result:=GetDef;
        end
        else if qty<50 then
        begin
          if h>900 then
             Result:=2
          else if (h>=840) and (tmpWoStation<6) then
             Result:=4
          else
             Result:=GetDef;
        end else
        begin
          if h>480 then
             Result:=2
          else if (h>=360) and (tmpWoStation<6) then
             Result:=4
          else
             Result:=GetDef;
        end;
      end;
    6:begin                                               //CCLCCL外觀檢查站
        if tmpWoStation>=5 then                           //CCL裁邊已報工
        begin
          if FCDS.FieldByName('s5_date').IsNull then      //CCL裁邊站時間
             D1:=defD
          else
             D1:=FCDS.FieldByName('s5_date').AsDateTime;
          if FCDS.FieldByName('s6_date').IsNull then
             D2:=defD
          else
             D2:=FCDS.FieldByName('s6_date').AsDateTime;  //CCL外觀檢查站時間

          if D1>defD then
          begin
            if D2>defD then
               h:=MinutesBetween(D1,D2)
            else
               h:=MinutesBetween(D1,Now);
          end;
        end;

        if ispnl or isoth then
        begin
          if h>120 then
             Result:=2
          else if (h>=60) and (tmpWoStation<7) then
             Result:=4
          else
             Result:=GetDef;
        end
        else if qty<50 then
        begin
          if h>60 then
             Result:=2
          else if (h>=1) and (tmpWoStation<7) then
             Result:=4
          else
             Result:=GetDef;
        end else
        begin
          if h>240 then
             Result:=2
          else if (h>=120) and (tmpWoStation<7) then
             Result:=4
          else
             Result:=GetDef;
        end;
      end;
    7:begin
        if tmpWoStation>=6 then                           //CCL外觀檢查已報工
        begin
          if FCDS.FieldByName('s6_date').IsNull then      //CCL外觀檢查站時間
             D1:=defD
          else
             D1:=FCDS.FieldByName('s6_date').AsDateTime;
          if FCDS.FieldByName('bz_date').IsNull then
             D2:=defD
          else
             D2:=FCDS.FieldByName('bz_date').AsDateTime;  //CCL包裝站時間

          if D1>defD then
          begin
            if D2>defD then
               h:=MinutesBetween(D1,D2)
            else
               h:=MinutesBetween(D1,Now);
          end;
        end;

        if (not ispnl) and (qty<50) then
        begin
          if h>120 then
             Result:=2
          else if h>=60 then
             Result:=4
          else
             Result:=GetDef;
        end else
        begin
          if h>240 then
             Result:=2
          else if h>=120 then
             Result:=4
          else
             Result:=GetDef;
        end;
      end;
  end;
end;

function TMPS_IcoFlag.GetData:OleVariant;
var
  i:Integer;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=FData;   //源數據
    if not tmpCDS.IsEmpty then
    begin
      tmpSQL:='';
      if tmpCDS.RecordCount<=50 then
      begin
        while not tmpCDS.Eof do
        begin
          if Length(tmpCDS.FieldByName('wono').AsString)>0 then
             tmpSQL:=tmpSQL+','+Quotedstr(tmpCDS.FieldByName('wono').AsString);
          tmpCDS.Next;
        end;

        if Length(tmpSQL)>0 then
        begin
          Delete(tmpSQL,1,1);
          tmpSQL:=' where wono in ('+tmpSQL+')';
        end;
      end;
      tmpSQL:='select bu,wono,remark,remark2 from mps020 '+tmpSQL;
      if not QueryBySQL(tmpSQL, Data) then
         tmpCDS.Active:=False
      else
         tmpCDS.Data:=Data;
    end;

    FCDS.EmptyDataSet;    //目標數據
    FtmpCDS.Data:=FData;  //源數據
    while not FtmpCDS.Eof do
    begin
      FCDS.Append;
      for i:=0 to FCDS.FieldCount -1 do
        if FtmpCDS.FindField(FCDS.Fields[i].FieldName)<>nil then
           FCDS.Fields[i].Value:=FtmpCDS.FieldByName(FCDS.Fields[i].FieldName).Value;

      if tmpCDS.Active then
      begin
        if SameText(FCDS.FieldByName('machine').AsString,'L6') then
        begin
          if tmpCDS.Locate('bu;wono',VarArrayOf(['ITEQGZ',FCDS.FieldByName('wono').AsString]),[loCaseInsensitive]) then
          begin
            FCDS.FieldByName('remark').AsString:=tmpCDS.FieldByName('remark').AsString;
            FCDS.FieldByName('remark2').AsString:=tmpCDS.FieldByName('remark2').AsString;
          end;
        end else
        if Pos(FCDS.FieldByName('machine').AsString,'L1,L2,L3,L4,L5')>0 then
        begin
          if tmpCDS.Locate('bu;wono',VarArrayOf(['ITEQDG',FCDS.FieldByName('wono').AsString]),[loCaseInsensitive]) then
          begin
            FCDS.FieldByName('remark').AsString:=tmpCDS.FieldByName('remark').AsString;
            FCDS.FieldByName('remark2').AsString:=tmpCDS.FieldByName('remark2').AsString;
          end;
        end;
      end;

      FListD1.DelimitedText:=Trim(FtmpCDS.FieldByName('Wostation_qtystr').AsString);
      for i:=0 to FListD1.Count -1 do
         FCDS.FieldByName('s'+IntToStr(i+1)).Value:=FListD1.Strings[i];
      FListD1.DelimitedText:=StringReplace(Trim(FtmpCDS.FieldByName('Wostation_d1str').AsString),l_SpaceStr,l_DefStr,[rfReplaceAll]);
      FListD2.DelimitedText:=StringReplace(Trim(FtmpCDS.FieldByName('Wostation_d2str').AsString),l_SpaceStr,l_DefStr,[rfReplaceAll]);
      for i:=0 to FListD1.Count -1 do
      begin
        try
          if i in [0,2] then //裁切、組合取開工時間,其它取完工時間
             FCDS.FieldByName('s'+IntToStr(i+1)+'_date').Value:=StringReplace(FListD1.Strings[i],l_DefStr,l_SpaceStr,[rfReplaceAll])
          else
             FCDS.FieldByName('s'+IntToStr(i+1)+'_date').Value:=StringReplace(FListD2.Strings[i],l_DefStr,l_SpaceStr,[rfReplaceAll]);
        except
          FCDS.FieldByName('s'+IntToStr(i+1)+'_date').Value:=EncodeDate(1955,5,5);
        end;
      end;

      FCDS.FieldByName('s1_ico').AsInteger:=GetIco020(1,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s2_ico').AsInteger:=GetIco020(2,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s3_ico').AsInteger:=GetIco020(3,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s4_ico').AsInteger:=GetIco020(4,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s5_ico').AsInteger:=GetIco020(5,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s6_ico').AsInteger:=GetIco020(6,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('s7_ico').AsInteger:=GetIco020(7,FCDS.FieldByName('materialno1').AsString,FCDS.FieldByName('sqty').AsFloat);
      FCDS.FieldByName('stime').AsDateTime:=GetStime(FCDS.FieldByName('custno').AsString);
      FCDS.Post;
      
      FtmpCDS.Next;
    end;
    FCDS.MergeChangeLog;
    Result:=FCDS.Data;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TMPS_IcoFlag.SetData(value: OleVariant);
begin
  FData:=value;
end;

end.
