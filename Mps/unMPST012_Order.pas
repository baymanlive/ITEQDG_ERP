{*******************************************************}
{                                                       }
{                unMPST010_Order                        }
{                Author: kaikai                         }
{                Create date: 2015/5/3                  }
{                Description: 訂單查詢                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST012_Order;

interface

uses
  Classes, SysUtils, Variants, ComCtrls, Forms, DB, DBClient, StrUtils, unGlobal,
  unCommon, unMPST012_units, ADODB;

type
  TMPST012_Order = class
  private
    FOrderType: string;
    FOraDB: string;
    FTmpList: TStrings;
    FTmpCDS: TCLientDataSet;
    FCDS1: TCLientDataSet;
    FCDS2: TCLientDataSet;
    FCDS3: TCLientDataSet;
    FCDS4: TCLientDataSet;
    FCDS5: TCLientDataSet;
    FCDS6: TCLientDataSet;
    FCDS7: TCLientDataSet;
    function GetOracleSQL(xBu, xSrcFlag, xFilter: string): string;
    function GetOrderType: string;
    procedure SetBarMsg(xMsg: string);
    procedure GetDefaultData;
    function AddData(xData1, xData2: OleVariant): Boolean;
    procedure DelData;
    procedure UpdateCustom;
  public
    constructor Create;
    destructor Destroy; override;
    function GetData: OleVariant;
  end;

implementation

uses
  unMPST012;

{ TMPST010_Order }

//srcflag:1->DG訂單 2->GZ訂單 3->DG異常訂單 4->GZ異常訂單 5->DG短交訂單 6->GZ短交訂單

constructor TMPST012_Order.Create;
begin
  FOraDB := 'ORACLE';
  FTmpList := TStringList.Create;
  FTmpCDS := TClientDataSet.Create(nil);
  FCDS1 := TClientDataSet.Create(nil);
  FCDS2 := TClientDataSet.Create(nil);
  FCDS3 := TClientDataSet.Create(nil);
  FCDS4 := TClientDataSet.Create(nil);
  FCDS5 := TClientDataSet.Create(nil);
  FCDS6 := TClientDataSet.Create(nil);
  FCDS7 := TClientDataSet.Create(nil);
  InitCDS(FCDS1, g_xml);
end;

destructor TMPST012_Order.Destroy;
begin
  FreeAndNil(FTmpList);
  FreeAndNil(FTmpCDS);
  FreeAndNil(FCDS1);
  FreeAndNil(FCDS2);
  FreeAndNil(FCDS3);
  FreeAndNil(FCDS4);
  FreeAndNil(FCDS5);
  FreeAndNil(FCDS6);
  FreeAndNil(FCDS7);

  inherited Destroy;
end;

procedure TMPST012_Order.SetBarMsg(xMsg: string);
begin
  g_StatusBar.Panels[0].Text := xMsg;
  Application.ProcessMessages;
end;

function TMPST012_Order.GetOrderType: string;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  //訂單類別
  Result := ' And 1<>1';
  tmpSQL := 'Select OrderType From MPS120 Where Bu=' + Quotedstr(g_UInfo^.BU);
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

procedure TMPST012_Order.GetDefaultData;
var
  tmpSQL: string;
  Data1: OleVariant;
begin
  SetBarMsg('正在查詢[客戶]資料');

  //客戶
  Data1 := null;
  tmpSQL := 'Select occ01,occ02 From ' + g_UInfo^.BU + '.occ_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS2.Data := Data1;

  SetBarMsg('正在查詢[PNL板]資料');

  //PNL板
  Data1 := null;
  tmpSQL := 'Select tc_ocl01,tc_ocl07 From ' + g_UInfo^.BU + '.tc_ocl_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS3.Data := Data1;

  SetBarMsg('正在查詢[PNL大小板]資料');

  //PNL板1開几
  Data1 := null;
  tmpSQL := 'Select tc_ocm01,tc_ocm03 From ' + g_UInfo^.BU + '.tc_ocm_file';
  if not QueryBySQL(tmpSQL, Data1, FOraDB) then
    Exit;
  FCDS4.Data := Data1;

  SetBarMsg('正在查詢[良率]資料');

  //良率(排除短交客戶custno1)
  Data1 := null;    {(*}
  tmpSQL := 'Select upper(A.custno) custno1,upper(B.custno) as custno2,B.adhesive,' +
            ' B.strip_lower,B.strip_upper,B.cwcode_lower,B.cwcode_upper,B.qty_lower,code9_11,code15,code16,' +
            ' B.qty_upper,B.Addqty From MPS190 as A full join MPS160 as B' + ' on A.Bu=B.Bu Where A.Bu=' + Quotedstr(g_UInfo^.BU);  {*)}
  if not QueryBySQL(tmpSQL, Data1) then
    Exit;
  FCDS5.Data := Data1;

  SetBarMsg('正在查詢[銅厚]資料');

  //料號與OZ關系
  Data1 := null;
  tmpSQL := 'Select Materialno,OZ From MPS150' + ' Where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data1) then
    Exit;
  FCDS6.Data := Data1;
end;

function TMPST012_Order.AddData(xData1, xData2: OleVariant): Boolean;
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

procedure TMPST012_Order.DelData;
var
  tmpSQL: string;
begin

  SetBarMsg('正在計算[未排的訂單]');

  tmpSQL := 'Select Distinct Orderno,Orderitem,' + ' Case When Srcflag%2=0 Then 2 Else 1 End Srcflag From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And IsNull(ErrorFlag,0)=0' + ' Union' + ' Select Distinct Orderno,Orderitem,' + ' Case When Srcflag%2=0 Then 2 Else 1 End Srcflag From MPS012' + ' Where Bu=' + Quotedstr(g_UInfo^.BU);
  with FrmMPST012.ADOQuery1 do
  begin
    close;
    sql.text := tmpSQL;
    open;
  end;
//  if not QueryBySQL(tmpSQL, Data1) then
//     Exit;
//
//  FTmpCDS.Data:=Data1;

  with FCDS1 do
  begin
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := RecordCount;
    First;
    while not Eof do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;

      if {FTmpCDS} FrmMPST012.ADOQuery1.Locate('Orderno;Orderitem;Srcflag', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('Orderitem').AsInteger, FieldByName('Srcflag').AsInteger]), []) then
        Delete
      else
        Next;
    end;
    g_ProgressBar.Position := 0;
  end;
end;

//只保留客戶編號
procedure TMPST012_Order.UpdateCustom;
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
          tmpSQL := tmpSQL + ' or (oao01=' + Quotedstr(FieldByName('orderno').AsString) + ' and oao03=' + IntToStr(FieldByName('orderitem').AsInteger) + ')';
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
      if FTmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsInteger]), []) then
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

function TMPST012_Order.GetOracleSQL(xBu, xSrcFlag, xFilter: string): string;
var
  s: string;
begin
  if Length(FOrderType) = 0 then
    FOrderType := GetOrdertype;

  if Pos('orderno', LowerCase(xFilter)) = 0 then
    s := ' And A.oea02>sysdate-30'
  else
    s := '';
{
  Result:='Select * From'
         +' (Select A.oea01 orderno,to_char(A.oea02,'''+g_cShortDate1+''') orderdate,'
         +' B.oeb03 orderitem,B.oeb04 materialno,B.oeb12 sqty,B.oeb12 orderQty,'
         +' to_char(B.oeb15,'''+g_cShortDate1+''') edate,A.oea04 custno,'
         +' B.ta_oeb04 materialno1,B.ta_oeb07 custom,B.ta_oeb01 pnlsize1,'
         +' B.ta_oeb02 pnlsize2,substr(B.oeb04,3,4) thickness,'
         +' substr(B.oeb04,7,2) oz,'+xSrcFlag+' srcflag,'
         +' concat(ta_oeb05,ta_oeb06) supplier'
         +' From '+xBu+'.oea_file A Inner Join '+xBu+'.oeb_file B On A.oea01=B.oeb01'
         +' Where A.oeaconf<>''X'' and B.oeb12>0 '+FOrderType+s
         +' And Substr(B.oeb04,1,1) in (''E'',''T'')) C Where 1=1 '+xFilter;
}
  Result := 'Select * From' + ' (Select A.oea01 orderno,to_char(A.oea02,''' + g_cShortDate1 + ''') orderdate,'       //  +' B.oeb03 orderitem,B.oeb04 materialno,B.oeb12 sqty,B.oeb12 orderQty,'
    + ' B.oeb03 orderitem,B.oeb04 materialno,nvl(B.oeb12,0)-nvl(B.oeb905,0) sqty,nvl(B.oeb12,0)-nvl(B.oeb905,0)  orderQty,' + ' to_char(B.oeb15,''' + g_cShortDate1 + ''') edate,A.oea04 custno,' + ' B.ta_oeb04 materialno1,B.ta_oeb07 custom,B.ta_oeb01 pnlsize1,ta_oeb35,'    //ta_oeb35終端客戶編號
    + ' B.ta_oeb02 pnlsize2,substr(B.oeb04,3,4) thickness,' + ' substr(B.oeb04,7,2) oz,' + xSrcFlag + ' srcflag,' + ' concat(ta_oeb05,ta_oeb06) supplier,' + ' ''' + xBu + ''' as orderBu,' + ' cast('''' as varchar2(100)) as premark3,' + ' cast(lower(RAWTOHEX(sys_guid())) as VARCHAR (50)) as uuid ' + ' From ' + xBu + '.oea_file A Inner Join ' + xBu + '.oeb_file B On A.oea01=B.oeb01' + ' Where A.oeaconf<>''X'' and B.oeb12>0 ' + FOrderType + s + ' And Substr(B.oeb04,1,1) in (''E'',''T'')) C Where 1=1 ' + xFilter;
end;

function TMPST012_Order.GetData: OleVariant;
var
  len: Integer;
  isErr: Boolean;
  strip: Double;
  tmpStr, ta_oeb35: string;    //終端客戶
  Data1, Data2: Olevariant;
begin
  Result := null;
  if not GetQueryString('MPST012_Order', tmpStr) then
    Exit;

  g_ProgressBar.Visible := True;
  try
    FCDS1.EmptyDataSet;
    if SameText(g_UInfo^.BU, 'ITEQDG') then
    begin
      SetBarMsg('正在查詢[DG訂單]');
      Data1 := null;
      isErr := QueryBySQL(GetOracleSQL('ITEQDG', '1', tmpStr), Data1, FOraDB);
      if isErr then
      begin
        SetBarMsg('正在查詢[GZ訂單]');
        Data2 := null;
        isErr := QueryBySQL(getOracleSQL('ITEQGZ', '2', tmpStr), Data2, FOraDB);
      end;
    end
    else
    begin
      SetBarMsg('正在查詢訂單');
      Data1 := null;
      Data2 := null;
      isErr := QueryBySQL(GetOracleSQL(g_UInfo^.BU, '1', tmpStr), Data1, FOraDB);
    end;

    //tiptop異常允許排返回未排的異常訂單
    if (not isErr) or AddData(Data1, Data2) then
    begin
      if isErr then
        DelData;

      if not FCDS2.Active then
        GetDefaultData;
      with FCDS1 do
      begin
        SetBarMsg('正在計算Pnl板、庫存量、良率');
        g_ProgressBar.Position := 0;
        g_ProgressBar.Max := RecordCount;

        First;
        while not Eof do
        begin
          g_ProgressBar.Position := g_ProgressBar.Position + 1;

          if FieldByName('srcflag').AsInteger in [3, 4, 5, 6] then
          begin
            Next;
            Continue;
          end;

          tmpStr := FieldByName('materialno').AsString;
          len := Length(tmpStr);
          Edit;
          //Pnl板  materialno1暫存是ta_oeb04
          if (len = 11) or (len = 19) then
          begin
            if FCDS3.Locate('tc_ocl01', FieldByName('materialno1').AsString, []) then
            begin
              if len = 11 then
                FieldByName('materialno').AsString := Copy(tmpStr, 1, 8) + FCDS3.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 9, 3)
              else
                FieldByName('materialno').AsString := Copy(tmpStr, 1, 8) + FCDS3.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 17, 3);
            end
            else
            begin
              if len = 11 then
                FieldByName('materialno').AsString := Copy(tmpStr, 1, 8) + '999999' + Copy(tmpStr, 9, 3)
              else
                FieldByName('materialno').AsString := Copy(tmpStr, 1, 8) + '999999' + Copy(tmpStr, 17, 3);
            end;

            //1開几 custom暫存是ta_oeb07
            if FCDS4.Locate('tc_ocm01', FieldByName('custom').AsString, []) and (FCDS4.FieldByName('tc_ocm03').AsInteger > 0) then
            begin
              FieldByName('pnlnum').AsInteger := FCDS4.FieldByName('tc_ocm03').AsInteger; //1開几數字
              FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat / FieldByName('pnlnum').AsInteger;
              if Trunc(FieldByName('sqty').AsFloat) < FieldByName('sqty').AsFloat then
                FieldByName('sqty').AsFloat := Round(FieldByName('sqty').AsFloat + 0.5);
            end;

            FieldByName('materialno1').AsString := tmpStr;
          end
          else
            FieldByName('materialno1').Clear;

          //客戶 custom暫存是ta_oeb07
          if FCDS2.Locate('occ01', FieldByName('custno').AsString, []) then
            FieldByName('custom').AsString := FCDS2.FieldByName('occ02').AsString
          else
            FieldByName('custom').Clear;



          //良率
          ta_oeb35 := FieldByName('ta_oeb35').AsString;
          if Pos(ta_oeb35, 'AC117/ACC19') = 0 then
            ta_oeb35 := FieldByName('custno').AsString;
          if FCDS6.Locate('Materialno', Copy(tmpStr, 7, 2), [loCaseInsensitive]) then
          begin
            FCDS5.Filtered := False;
            if not FCDS5.Locate('custno1', FieldByName('custno').AsString, []) then
            begin
              isErr := False;
              strip := StrToFloat(Copy(tmpStr, 3, 4)) / 10000;
              FCDS5.Filter := 'strip_lower<=' + FloatToStr(strip) +
                              ' and strip_upper>=' + FloatToStr(strip) +
                              ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) +
                              ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) +
                              ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) +
                              ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) +
                              ' and code9_11 like ' + quotedstr('%' + Copy(Fieldbyname('materialno').AsString, 9, 3) + '%');
              FCDS5.Filtered := True;
              while not FCDS5.Eof do
              begin

                if (Pos(ta_oeb35{FieldByName('custno').AsString}, FCDS5.FieldByName('custno2').AsString) > 0)
                and (Pos(Copy(tmpStr, 2, 1), FCDS5.FieldByName('adhesive').AsString) > 0) then
                begin
                  isErr := True;
                  FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
                  Break;
                end;
                FCDS5.Next;
              end;

              if not isErr then
              begin
                FCDS5.Filtered := False;
                FCDS5.Filter := 'strip_lower<=' + FloatToStr(strip) +
                ' and strip_upper>=' + FloatToStr(strip) +
                ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) +
                ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) +
                ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) +
                ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and code16 like ' + QuotedStr('%' + Copy(tmpStr, 16, 1) + '%');

                FCDS5.Filtered := True;
                while not FCDS5.Eof do
                begin

                  if (Pos(ta_oeb35{FieldByName('custno').AsString}, FCDS5.FieldByName('custno2').AsString) > 0) and (Pos(Copy(tmpStr, 2, 1), FCDS5.FieldByName('adhesive').AsString) > 0) then
                  begin
                    isErr := True;

                    FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
                    Break;
                  end;
                  FCDS5.Next;
                end;
              end;

              if not isErr then
              begin
                FCDS5.Filtered := False;
                FCDS5.Filter := 'strip_lower<=' + FloatToStr(strip) + ' and strip_upper>=' + FloatToStr(strip) + ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and code9_11=''''' + ' and code15 like ' + QuotedStr('%' + Copy(tmpStr, 15, 1) + '%');
                FCDS5.Filtered := True;
                while not FCDS5.Eof do
                begin
                  if (Pos(Copy(tmpStr, 2, 1), FCDS5.FieldByName('adhesive').AsString) > 0) then
                  begin
                    isErr := True;
                    FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
                    Break;
                  end;
                  FCDS5.Next;
                end;
              end;

              if not isErr then
              begin
                FCDS5.Filtered := False;
                FCDS5.Filter := 'strip_lower<=' + FloatToStr(strip) +
                ' and strip_upper>=' + FloatToStr(strip) +
                ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) +
                ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) +
                ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and code9_11=''''';
                FCDS5.Filtered := True;

                while not FCDS5.Eof do
                begin

                  if (Pos(ta_oeb35{FieldByName('custno').AsString}, FCDS5.FieldByName('custno2').AsString) > 0) and (Pos(Copy(tmpStr, 2, 1), FCDS5.FieldByName('adhesive').AsString) > 0) then
                  begin
                    isErr := True;
                    FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
                    Break;
                  end;
                  FCDS5.Next;
                end;
              end;

              if not isErr then
              begin
                FCDS5.Filtered := False;
                FCDS5.Filter := 'strip_lower<=' + FloatToStr(strip) + ' and strip_upper>=' + FloatToStr(strip) + ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and code9_11=''''';
                FCDS5.Filtered := True;

                while not FCDS5.Eof do
                begin

                  if (Pos(ta_oeb35{FieldByName('custno').AsString}, FCDS5.FieldByName('custno2').AsString) > 0) then
                  begin
                    isErr := True;
                    FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
                    Break;
                  end;
                  FCDS5.Next;
                end;
              end;

              if not isErr then
              begin
                FCDS5.Filtered := False;
                FCDS5.Filter := 'custno2=''*''' + ' and cwcode_lower<=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and cwcode_upper>=' + FloatToStr(FCDS6.FieldByName('oz').AsFloat) + ' and qty_lower<=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and qty_upper>=' + FloatToStr(FieldByName('sqty').AsFloat) + ' and code9_11=''''';
                FCDS5.Filtered := True;
                if not FCDS5.IsEmpty then
                  FieldByName('sqty').AsFloat := FieldByName('sqty').AsFloat + FCDS5.FieldByName('addqty').AsFloat;
              end;


//              if not isErr then
//              begin
//                FCDS5.Filtered:=False;
//                FCDS5.Filter:='custno2=''*'''
//                             +' and cwcode_lower<='+FloatToStr(FCDS6.FieldByName('oz').AsFloat)
//                             +' and cwcode_upper>='+FloatToStr(FCDS6.FieldByName('oz').AsFloat)
//                             +' and qty_lower<='+FloatToStr(FieldByName('sqty').AsFloat)
//                             +' and qty_upper>='+FloatToStr(FieldByName('sqty').AsFloat)
//                             +' and code9_11=''''';
//                FCDS5.Filtered:=True;
//                if not FCDS5.IsEmpty then
//                   FieldByName('sqty').AsFloat:=FieldByName('sqty').AsFloat+
//                                                FCDS5.FieldByName('addqty').AsFloat;
//              end;
            end;
          end;


//           longxinjue 2022.01.07 排制數量小於訂單數量的話，加投數量為 0
          if (FieldByName('sqty').AsFloat > FieldByName('orderQty').AsFloat) then
            FieldByName('regulateQty').AsFloat := FieldByName('sqty').AsFloat - FieldByName('orderQty').AsFloat
          else
            FieldByName('regulateQty').AsFloat := 0;

          Post;
          Next;
        end;
      end;
    end;

    UpdateCustom;

    if FCDS1.ChangeCount > 0 then
      FCDS1.MergeChangeLog;
    Result := FCDS1.Data;
    SetBarMsg('');
  finally
    g_ProgressBar.Visible := False;
  end;
end;

end.

