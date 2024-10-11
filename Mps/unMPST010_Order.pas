{*******************************************************}
{                                                       }
{                unMPST010_Order                        }
{                Author: kaikai                         }
{                Create date: 2015/5/3                  }
{                Description: 訂單查詢                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_Order;

interface

uses
  Classes, SysUtils, Variants, ComCtrls, Forms, DB, DBClient, StrUtils, unGlobal,
  unCommon, unMPST010_units;

type
  TMPST010_Order = class
  private
    FTmpCDS: TCLientDataSet;
    FCDS1: TCLientDataSet;
    function GetErrorSQL: string;
    function GetMPSSQL: string;
    function GetLessSQL(xFilter: string): string;
    procedure SetBarMsg(xMsg: string);
    function AddData(xData: OleVariant): Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    function GetData: OleVariant;
    function GetLessData: OleVariant;
  end;

implementation

{ TMPST010_Order }

//srcflag:1->DG訂單 2->GZ訂單 3->DG異常訂單 4->GZ異常訂單 5->DG短交訂單 6->GZ短交訂單

constructor TMPST010_Order.Create;
begin
  FTmpCDS := TClientDataSet.Create(nil);
  FCDS1 := TClientDataSet.Create(nil);
  InitCDS(FCDS1, g_CDSxml);
end;

destructor TMPST010_Order.Destroy;
begin
  FreeAndNil(FTmpCDS);
  FreeAndNil(FCDS1);

  inherited Destroy;
end;

procedure TMPST010_Order.SetBarMsg(xMsg: string);
begin
  g_StatusBar.Panels[0].Text := xMsg;
  Application.ProcessMessages;
end;

function TMPST010_Order.AddData(xData: OleVariant): Boolean;
var
  i: Integer;
begin
  with FTmpCDS do
  begin
    Data := xData;
    Result := not IsEmpty;
    if Result then
    begin
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := RecordCount;
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

        if RightStr(FieldByName('materialno').AsString, 1) <> '0' then
        begin
          FCDS1.Append;
          for i := 0 to FieldCount - 1 do
            FCDS1.FieldByName(Fields[i].FieldName).Value := Fields[i].Value;
          FCDS1.Post;
        end;
        Next;
      end;
      g_ProgressBar.Position := 0;
    end;
  end;
end;

function TMPST010_Order.GetErrorSQL: string;
begin           {(*}
  Result:='select wono,orderno,orderdate,orderitem,materialno,sqty,orderqty,'
         +' edate,custno,custom,custom2,materialno1,pnlsize1,pnlsize2,sdate1,'
         +' machine1,boiler1,adate_new adate,oz,supplier,orderno2,orderitem2,'
         +' custno2,custname2,'
         +' case when (srcflag%2)=0 then 4 else 3 end as srcflag,'
         +' ''A''+simuver+''@''+cast(citem as varchar(10)) as errorid'
         +' from mps010 where bu='+QuotedStr(G_Uinfo^.BU)
         +' and isnull(errorflag,0)=1 and isnull(srcflag,0)>0';        {*)}
end;

function TMPST010_Order.GetMPSSQL: string;
begin     {(*}
  Result:='select orderno,orderdate,orderitem,materialno,sqty,custno2,custname2,'
         +' orderqty,edate,custno,custom,custom2,materialno1,pnlsize1,pnlsize2,'
         +' sdate as sdate1,adate,oz,supplier,pnlnum,srcflag,premark,premark2,premark3,regulateQty,'
         +' orderno2,orderitem2,''B''+'+g_mps012pk+' as errorid '
         +' from mps012 where bu='+QuotedStr(G_Uinfo^.BU)
         +' and isnull(notvisible,0)=1 and isnull(srcflag,0)>0';   {*)}
end;

function TMPST010_Order.GetLessSQL(xFilter: string): string;
begin       {(*}
  Result:='Select orderno,orderdate,orderitem,materialno,sqty,custno2,custname2,'
         +' orderQty,edate,custno,custom,custom2,materialno1,pnlsize1,pnlsize2,'
         +' sdate1,machine1,boiler1,adate_new adate,oz,supplier,'
         +' case when (srcflag%2)=0 then 6 else 5 end as srcflag'
         +' From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)+xFilter
         +' And IsNull(ErrorFlag,0)=0 And IsNull(srcflag,0)>0';     {*)}
end;

function TMPST010_Order.GetData: OleVariant;
var
  Data: Olevariant;
begin
  Result := null;
  g_ProgressBar.Visible := True;
  try
    FCDS1.EmptyDataSet;

    SetBarMsg('正在提取[異常訂單]');
    if not QueryBySQL(GetErrorSQL, Data) then
      Exit;
    AddData(Data);

    SetBarMsg('正在提取[副排程訂單]');
    Data := null;
    if not QueryBySQL(GetMPSSQL, Data) then
      Exit;
    AddData(Data);

    if FCDS1.ChangeCount > 0 then
      FCDS1.MergeChangeLog;
    Result := FCDS1.Data;

  finally
    g_ProgressBar.Visible := False;
    SetBarMsg('');
  end;
end;

function TMPST010_Order.GetLessData: OleVariant;
var
  tmpStr: string;
  Data: OleVariant;
begin
  Result := null;
  if not GetQueryString('MPS010_Q1', tmpStr) then
    Exit;

  FCDS1.EmptyDataSet;
  SetBarMsg('正在提取[短交訂單]');
  if QueryBySQL(GetLessSQL(tmpStr), Data) then
  begin
    g_ProgressBar.Visible := True;
    try
      AddData(Data);
      if FCDS1.ChangeCount > 0 then
        FCDS1.MergeChangeLog;
      Result := FCDS1.Data;
    finally
      g_ProgressBar.Visible := False;
      SetBarMsg('');
    end;
  end;
end;

end.

