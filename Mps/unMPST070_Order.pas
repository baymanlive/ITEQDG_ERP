{*******************************************************}
{                                                       }
{                unMPST070_Order                        }
{                Author: kaikai                         }
{                Create date: 2016/8/15                 }
{                Description: PP訂單查詢                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_Order;

interface

uses
  Classes, SysUtils, Variants, ComCtrls, Forms, DB, DBClient, StrUtils, unGlobal, unCommon, unMPST070_cdsxml;

type
  TMPST070_Order = class
  private
    FOraDB: string;
    FOrderType: string;
    FTmpList: TStrings;
    FTmpCDS: TCLientDataSet;
    FCDS1: TCLientDataSet;
    FCDS2: TCLientDataSet;
    FCDS3: TCLientDataSet;
    FCDS4: TCLientDataSet;
    function GetErrorSQL: string;
    function GetOracleSQL(xBu, xSrcFlag, xFilter: string): string;
    function GetLessSQL(xFilter: string): string;
    function GetOrderType: string;
    procedure SetBarMsg(xMsg: string);
    procedure GetDefaultData;
    function AddData(xData1, xData2: OleVariant): Boolean;
    procedure DelData;
    procedure UpdateCustom_DG;
    procedure UpdateCustom_GZ;
    procedure UpdateCustom_JX;
    procedure UpdateJXOrders(cds: TClientDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    function GetData: OleVariant;
    function GetLessData: OleVariant;
  end;

implementation

{ TMPST010_Order }

//srcflag:1->DG訂單 2->GZ訂單 3->DG異常訂單 4->GZ異常訂單 5->DG短交訂單 6->GZ短交訂單

constructor TMPST070_Order.Create;
begin
  FOraDB := 'ORACLE';
  FTmpList := TStringList.Create;
  FTmpCDS := TClientDataSet.Create(nil);
  FCDS1 := TClientDataSet.Create(nil);
  FCDS2 := TClientDataSet.Create(nil);
  FCDS3 := TClientDataSet.Create(nil);
  FCDS4 := TClientDataSet.Create(nil);
  InitCDS(FCDS1, g_OrdXML);
end;

destructor TMPST070_Order.Destroy;
begin
  FreeAndNil(FTmpList);
  FreeAndNil(FTmpCDS);
  FreeAndNil(FCDS1);
  FreeAndNil(FCDS2);
  FreeAndNil(FCDS3);
  FreeAndNil(FCDS4);

  inherited Destroy;
end;

procedure TMPST070_Order.SetBarMsg(xMsg: string);
begin
  g_StatusBar.Panels[0].Text := xMsg;
  Application.ProcessMessages;
end;

function TMPST070_Order.GetOrderType: string;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  //訂單類別
  Result := ' And 1<>1';
  tmpSQL := 'Select OrderType From MPS520 Where Bu=' + Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data1) then
  begin
    with FTmpCDS do
    begin
      Data := Data1;
      if not IsEmpty then
      begin
        Result := '';
        while not Eof do
        begin
          Result := Result + '@' + Fields[0].AsString;
          Next;
        end;

        Result := ' And InStr(''' + Result + '@'',Substr(A.oea01,1,3))>0';
      end;
    end;
  end;
end;

procedure TMPST070_Order.GetDefaultData;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  SetBarMsg('正在提取[客戶]資料');

  //客戶
  Data1 := null;
  tmpSQL := 'Select 1 sno,occ01,occ02 From ' + g_UInfo^.BU + '.occ_file';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := tmpSQL + ' union all Select 2 sno,occ01,occ02 From iteqwx.occ_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS2.Data := Data1;

  SetBarMsg('正在提取[PNL板]資料');

  //PNL板
  Data1 := null;
  tmpSQL := 'Select tc_ocl01,tc_ocl07 From ' + g_UInfo^.BU + '.tc_ocl_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS3.Data := Data1;

  SetBarMsg('正在提取[PNL大小板]資料');

  //PNL板1開几
  Data1 := null;
  tmpSQL := 'Select tc_ocm01,tc_ocm03 From ' + g_UInfo^.BU + '.tc_ocm_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS4.Data := Data1;
end;

function TMPST070_Order.AddData(xData1, xData2: OleVariant): Boolean;
var
  i: Integer;
begin
  with FTmpCDS do
  begin
    Data := xData1;
    if xData2 <> null then
      AppendData(xData2, True);
    Result := not IsEmpty;
    if Result then
    begin
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := RecordCount;
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        FCDS1.Append;
        for i := 0 to FieldCount - 1 do
          FCDS1.FieldByName(Fields[i].FieldName).Value := Fields[i].Value;
        FCDS1.Post;
        Next;
      end;
      g_ProgressBar.Position := 0;
    end;
  end;
end;

procedure TMPST070_Order.DelData;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  SetBarMsg('正在計算[未排的訂單]');
  tmpSQL := 'Select Distinct Orderno,Orderitem,' + ' Case When Srcflag%2=0 Then 2 Else 1 End Srcflag From MPS070' +
    ' Where Len(IsNull(Orderno,''''))>0 And IsNull(ErrorFlag,0)=0' + ' And Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data1) then
    Exit;

  FTmpCDS.Data := Data1;

  with FCDS1 do
  begin
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := RecordCount;
    First;
    while not Eof do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;

      if FTmpCDS.Locate('Orderno;Orderitem;Srcflag', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('Orderitem').AsInteger,
        FieldByName('Srcflag').AsInteger]), []) then
        Delete
      else
        Next;
    end;
    g_ProgressBar.Position := 0;
  end;
end;

//東莞排程:無錫原客戶
//無錫客戶下單東莞
procedure TMPST070_Order.UpdateCustom_DG;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  if not SameText(g_UInfo^.BU, 'ITEQDG') then
    Exit;

  if FCDS1.IsEmpty then
    Exit;

  SetBarMsg('正在更新[客戶簡稱]');
  tmpSQL := '';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if SameText(FieldByName('custno').AsString, 'N006') and (FieldByName('srcflag').AsInteger mod 2 <> 0) then
        tmpSQL := tmpSQL + ' or (oao01=' + Quotedstr(FieldByName('orderno').AsString) + ' and oao03=' + IntToStr(FieldByName
          ('orderitem').AsInteger) + ')';
      Next;
    end;
  end;

  if Length(tmpSQL) = 0 then
    Exit;

  Delete(tmpSQL, 1, 3);
  tmpSQL := 'select oao01,oao03,oao06 from iteqdg.oao_file where ' + tmpSQL;
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;

  FTmpCDS.Data := Data1;
  if FTmpCDS.IsEmpty then
    Exit;

  //oao06格式:客戶編號-其它文字
  FTmpList.Delimiter := '-';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if FieldByName('srcflag').AsInteger mod 2 <> 0 then
        if FTmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsInteger]),
          []) then
        begin
          FTmpList.DelimitedText := FTmpCDS.FieldByName('oao06').AsString;
          if FTmpList.Count > 0 then
            if FCDS2.Locate('sno;occ01', VarArrayOf([2, FTmpList.Strings[0]]), []) then
            begin
              Edit;
              FieldByName('custom').AsString := FCDS2.FieldByName('occ01').AsString;
              FieldByName('custom2').AsString := FCDS2.FieldByName('occ02').AsString;
              Post;
            end;
        end;
      Next;
    end;
  end;
end;

//東莞排程:無錫原客戶
//無錫客戶下單廣州
procedure TMPST070_Order.UpdateCustom_GZ;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  if not SameText(g_UInfo^.BU, 'ITEQDG') then
    Exit;

  if FCDS1.IsEmpty then
    Exit;

  SetBarMsg('正在更新[客戶簡稱]');
  tmpSQL := '';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if SameText(FieldByName('custno').AsString, 'N006') and (FieldByName('srcflag').AsInteger mod 2 = 0) then
        tmpSQL := tmpSQL + ' or (oao01=' + Quotedstr(FieldByName('orderno').AsString) + ' and oao03=' + IntToStr(FieldByName
          ('orderitem').AsInteger) + ')';
      Next;
    end;
  end;

  if Length(tmpSQL) = 0 then
    Exit;

  Delete(tmpSQL, 1, 3);
  tmpSQL := 'select oao01,oao03,oao06 from iteqgz.oao_file where ' + tmpSQL;
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;

  FTmpCDS.Data := Data1;
  if FTmpCDS.IsEmpty then
    Exit;

  //oao06格式:客戶編號-其它文字
  FTmpList.Delimiter := '-';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if FieldByName('srcflag').AsInteger mod 2 = 0 then
        if FTmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsInteger]),
          []) then
        begin
          FTmpList.DelimitedText := FTmpCDS.FieldByName('oao06').AsString;
          if FTmpList.Count > 0 then
            if FCDS2.Locate('sno;occ01', VarArrayOf([2, FTmpList.Strings[0]]), []) then
            begin
              Edit;
              FieldByName('custom').AsString := FCDS2.FieldByName('occ01').AsString;
              FieldByName('custom2').AsString := FCDS2.FieldByName('occ02').AsString;
              Post;
            end;
        end;
      Next;
    end;
  end;
end;

procedure TMPST070_Order.UpdateJXOrders(cds: TClientDataSet);
var
  s1, s2: string;
  Data1: OleVariant;
begin
    cds.First;
    s1 := '';
    while not cds.Eof do
    begin
      if cds.FieldByName('custno').AsString = 'N024' then
      begin
        s2 := ' or (oao01=' + QuotedStr(cds.FieldByName('orderno').AsString) + ')';
        if Pos(s2, s1) = 0 then
          s1 := s1 + s2;
      end;
      cds.next;
    end;
    s1 := 'select oao06 from oao_file where 1=2 '+s1;
    cds.first;
end;

//江西排程:原客戶,原訂單
procedure TMPST070_Order.UpdateCustom_JX;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  if not SameText(g_UInfo^.BU, 'ITEQJX') then
    Exit;

  if FCDS1.IsEmpty then
    Exit;

  SetBarMsg('正在更新[客戶簡稱]');
  tmpSQL := '';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if Length(FieldByName('custom2').AsString) = 0 then
      begin
        Edit;
        FieldByName('custom2').AsString := FieldByName('custom').AsString;
        FieldByName('custom').AsString := FieldByName('custno').AsString;
        Post;

        if Pos(FieldByName('custno').AsString, 'N004,N005,N006,N012,N013,N023,N024') > 0 then
          tmpSQL := tmpSQL + ' or (oao01=' + Quotedstr(FieldByName('orderno').AsString) + ' and oao03=' + IntToStr(FieldByName
            ('orderitem').AsInteger) + ')';
      end;
      Next;
    end;
  end;

  if Length(tmpSQL) = 0 then
    Exit;

  Delete(tmpSQL, 1, 3);
  tmpSQL := 'select oao01,oao03,oao06 from ' + g_UInfo^.BU + '.oao_file where ' + tmpSQL;
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;

  FTmpCDS.Data := Data1;
  if FTmpCDS.IsEmpty then
    Exit;

  //oao06格式:廠別-單別-單號-項次-客戶編號-其它文字(xx-xxx-xxxxxx-xx-xxxxx-x)
  FTmpList.Delimiter := '-';
  with FCDS1 do
  begin
    First;
    while not Eof do
    begin
      if FTmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsInteger]),
        []) then
      begin
        FTmpList.DelimitedText := FTmpCDS.FieldByName('oao06').AsString;
        if FTmpList.Count >= 5 then
          if FCDS2.Locate('occ01', FTmpList.Strings[4], []) then
          begin
            Edit;
            FieldByName('orderno2').AsString := FTmpList.Strings[1] + '-' + FTmpList.Strings[2];
            FieldByName('orderitem2').AsInteger := StrToInt(FTmpList.Strings[3]);
            FieldByName('custom').AsString := FTmpList.Strings[4];
            FieldByName('custom2').AsString := FCDS2.FieldByName('occ02').AsString;
            Post;
          end;
      end;
      Next;
    end;
  end;
end;

function TMPST070_Order.GetErrorSQL: string;
begin
  Result := 'Select wono,orderno,orderdate,orderitem,materialno,sqty,' +
    ' orderQty,edate,custno,custom,custom2,materialno1,pnlsize1,pnlsize2,' + ' sdate1,machine1,Adate_new adate,'
    //cast(null as varchar(100))oao06,'
    + ' case when (srcflag%2)=0 then 4 else 3 end as srcflag,' +
    ' simuver+''@''+Cast(citem as varchar(10)) as errorid,orderno2,orderitem2' + ' From MPS070 Where Bu=' + Quotedstr(g_UInfo
    ^.BU) + ' And ErrorFlag=1 And IsNull(srcflag,0)>0 And Len(IsNull(Orderno,''''))>0';
end;

function TMPST070_Order.GetOracleSQL(xBu, xSrcFlag, xFilter: string): string;
var
  s: string;
begin
  if Length(FOrderType) = 0 then
    FOrderType := GetOrdertype;

  if Pos('orderno', LowerCase(xFilter)) = 0 then
    s := ' And A.oea02>sysdate-30'
  else
    s := '';
//  s   :='Select * From'
//         +' (Select A.oea01 orderno,to_char(A.oea02,'''+g_cShortDate1+''') orderdate,'
//         +' B.oeb03 orderitem,B.oeb04 materialno,B.oeb12 sqty,B.oeb12 orderQty,'
//         +' to_char(B.oeb15,'''+g_cShortDate1+''') edate,A.oea04 custno,'
//         +' B.ta_oeb04 materialno1,B.ta_oeb07 custom,B.ta_oeb01 pnlsize1,'
//         +' B.ta_oeb02 pnlsize2,'+xSrcFlag+' srcflag,B.oeb05 unit,oao06 '
//         +' From '+xBu+'.oea_file A Inner Join '+xBu+'.oeb_file B On A.oea01=B.oeb01'
//         +' left join '+xBu+'.oao_file on oeb01=oao01 and oeb03=oao03 and oao06 like ''JX-%'' AND OAO04=1 AND oao05=2'
//         +' Where A.oeaconf<>''X'' and B.oeb12>0 '+FOrderType+s
//         +' And Substr(B.oeb04,1,1) in (''M'',''N'',''B'',''R'',''P'',''Q'')) C Where 1=1 '+xFilter;
  s := 'Select * From' + ' (Select A.oea01 orderno,to_char(A.oea02,''' + g_cShortDate1 + ''') orderdate,' +
    ' B.oeb03 orderitem,B.oeb04 materialno,B.oeb12 sqty,B.oeb12 orderQty,' + ' to_char(B.oeb15,''' + g_cShortDate1 +
    ''') edate,A.oea04 custno,' + ' B.ta_oeb04 materialno1,B.ta_oeb07 custom,B.ta_oeb01 pnlsize1,' +
    ' B.ta_oeb02 pnlsize2,' + xSrcFlag + ' srcflag,B.oeb05 unit ' + ' From ' + xBu + '.oea_file A Inner Join ' + xBu +
    '.oeb_file B On A.oea01=B.oeb01' + ' Where A.oeaconf<>''X'' and B.oeb12>0 ' + FOrderType + s +
    ' And Substr(B.oeb04,1,1) in (''M'',''N'',''B'',''R'',''P'',''Q'')) C Where 1=1 ' + xFilter;
  result := s;
end;

function TMPST070_Order.GetLessSQL(xFilter: string): string;
begin
  Result := 'Select orderno,orderdate,orderitem,materialno,sqty,' +
    ' orderQty,edate,custno,custom,custom2,materialno1,pnlsize1,pnlsize2,' + ' sdate1,machine1,Adate_new adate,' +
    ' case when (srcflag%2)=0 then 6 else 5 end as srcflag' + ' From MPS070 Where Bu=' + Quotedstr(g_UInfo^.BU) +
    xFilter + ' And IsNull(ErrorFlag,0)=0 And IsNull(srcflag,0)>0 And Len(IsNull(Orderno,''''))>0';
end;

function TMPST070_Order.GetData: OleVariant;
var
  bool: Boolean;
  len: Integer;
  tmpStr, s1: string;
  Data1, Data2: Olevariant;
begin
  Result := null;
  if not GetQueryString('oea_file', tmpStr) then
    Exit;

  g_ProgressBar.Visible := True;
  try
    FCDS1.EmptyDataSet;

    SetBarMsg('正在提取[異常訂單]');
    if not QueryBySQL(GetErrorSQL, Data1) then
      Exit;
    AddData(Data1, null);

    if SameText(g_UInfo^.BU, 'ITEQDG') then
    begin
      SetBarMsg('正在提取[DG訂單]');
      Data1 := null;
      bool := QueryBySQL(GetOracleSQL('ITEQDG', '1', tmpStr), Data1, 'ORACLE');
      if bool then
      begin
        SetBarMsg('正在提取[GZ訂單]');
        Data2 := null;
        bool := QueryBySQL(getOracleSQL('ITEQGZ', '2', tmpStr), Data2, 'ORACLE');
      end;
    end
    else
    begin
      SetBarMsg('正在提取訂單');
      Data1 := null;
      Data2 := null;
      bool := QueryBySQL(GetOracleSQL(g_UInfo^.BU, '1', tmpStr), Data1, FOraDB);
    end;

    //tiptop異常允許排返回未排的異常訂單
    if (not bool) or AddData(Data1, Data2) then
    begin
      if bool then
        DelData;

      //if FDepot='' then
      //   FDepot:=GetDepot;
      if not FCDS2.Active then
        GetDefaultData;

      with FCDS1 do
      begin
        SetBarMsg('正在計算Pnl板、十大客戶');
        g_ProgressBar.Position := 0;
        g_ProgressBar.Max := RecordCount;

        First;
        while not Eof do
        begin
          g_ProgressBar.Position := g_ProgressBar.Position + 1;

          Edit;
          if FieldByName('srcflag').AsInteger in [1, 2] then
          begin
            tmpStr := FieldByName('materialno').AsString;
            len := Length(tmpStr);
            //Pnl板  materialno1暫存是ta_oeb04
            if (len = 12) or (len = 20) then
            begin
              s1 := LeftStr(tmpStr, 1);
              if s1 = 'M' then
                s1 := 'B'
              else
                s1 := 'R';
              if FCDS3.Locate('tc_ocl01', FieldByName('materialno1').AsString, []) then
              begin
                if len = 12 then
                  FieldByName('materialno').AsString := s1 + Copy(tmpStr, 2, 9) + FCDS3.FieldByName('tc_ocl07').AsString
                    + Copy(tmpStr, 11, 2)
                else
                  FieldByName('materialno').AsString := s1 + Copy(tmpStr, 2, 9) + FCDS3.FieldByName('tc_ocl07').AsString
                    + Copy(tmpStr, 19, 2);
              end
              else
              begin
                if len = 12 then
                  FieldByName('materialno').AsString := s1 + Copy(tmpStr, 2, 9) + '999999' + Copy(tmpStr, 11, 2)
                else
                  FieldByName('materialno').AsString := s1 + Copy(tmpStr, 2, 9) + '999999' + Copy(tmpStr, 19, 2);
              end;

              //1開几 custom暫存是ta_oeb07
              if FCDS4.Locate('tc_ocm01', FieldByName('custom').AsString, []) and (FCDS4.FieldByName('tc_ocm03').AsInteger
                > 0) then
              begin
                FieldByName('pnlnum').AsInteger := FCDS4.FieldByName('tc_ocm03').AsInteger; //1開几數字
                FieldByName('sqty').AsFloat := ((FieldByName('sqty').AsFloat / FieldByName('pnlnum').AsInteger) *
                  FieldByName('pnlsize1').AsFloat * 25.4) / 1000;
                if Trunc(FieldByName('sqty').AsFloat) < FieldByName('sqty').AsFloat then
                  FieldByName('sqty').AsFloat := Round(FieldByName('sqty').AsFloat + 0.5);

                if FieldByName('sqty').AsInteger mod 10 <> 0 then                          //10的倍數
                  FieldByName('sqty').AsFloat := (trunc(FieldByName('sqty').AsInteger / 10) + 1) * 10;
              end;

              FieldByName('materialno1').AsString := tmpStr;
            end
            else
            begin
              FieldByName('materialno1').Clear;
              if FieldByName('unit').AsString <> 'M' then
                FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat * StrToInt(Copy(tmpStr, 11, 3));
            end;

            //客戶 custom暫存是ta_oeb07
            if FCDS2.Locate('sno;occ01', VarArrayOf([1, FieldByName('custno').AsString]), []) then
              FieldByName('custom').AsString := FCDS2.FieldByName('occ02').AsString
            else
              FieldByName('custom').Clear;
          end;

          Post;
          Next;
        end;
      end;
    end;

    UpdateCustom_DG;
    UpdateCustom_GZ;
    UpdateCustom_JX;

    if FCDS1.ChangeCount > 0 then
      FCDS1.MergeChangeLog;
    Result := FCDS1.Data;

  finally
    g_ProgressBar.Visible := False;
    SetBarMsg('');
  end;
end;

function TMPST070_Order.GetLessData: OleVariant;
var
  tmpStr: string;
  Data1: OleVariant;
begin
  Result := null;
  if not GetQueryString('MPS010_Q1', tmpStr) then
    Exit;

  FCDS1.EmptyDataSet;
  SetBarMsg('正在提取[短交訂單]');
  if QueryBySQL(GetLessSQL(tmpStr), Data1) then
  begin
    g_ProgressBar.Visible := True;
    try
      AddData(Data1, null);
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

