{*******************************************************}
{                                                       }
{                unDLIR110                              }
{                Author: kaikai                         }
{                Create date: 2017/6/2                  }
{                Description: 營管受訂管控表            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR110;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ComCtrls, ToolWin, DateUtils, StrUtils, Math;

type
  TFrmDLIR110 = class(TFrmSTDI041)
    ImageList2: TImageList;
    LblTot: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_queryClick(Sender: TObject);
  private    { Private declarations }
    l_D1, l_D2, l_D3, l_D4: Variant;
    l_IsDG: Boolean;
    l_DLI680, l_SalCDS: TClientDataSet;
    l_Img: TBitmap;
    l_StrIndex, l_StrIndexDesc: string;

    function ChkIndate(indate: string): Boolean;
    procedure GetDS(xFliter: string);
    procedure CalcTotQty;
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLIR110: TFrmDLIR110;


implementation

uses
  unGlobal, unCommon, unDLIR110_Query, unCCLStruct;

{$R *.dfm}

const
  g_Xml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' + '<FIELD attrname="stime" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="odate" fieldtype="date"/>' + '<FIELD attrname="ddate" fieldtype="date"/>' + '<FIELD attrname="edate" fieldtype="date"/>' + '<FIELD attrname="adate" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="cdate" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="indate" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="orderitem" fieldtype="i4"/>' + '<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="longitude" fieldtype="r8"/>' +
    '<FIELD attrname="latitude" fieldtype="r8"/>' + '<FIELD attrname="struct" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="ta_oeb07" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="orderqty" fieldtype="r8"/>' + '<FIELD attrname="outqty" fieldtype="r8"/>' + '<FIELD attrname="remainqty" fieldtype="r8"/>' + '<FIELD attrname="units" fieldtype="string" WIDTH="4"/>' + '<FIELD attrname="custorderno" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="custprono" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="custname" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="sendaddr" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="remark" fieldtype="string" WIDTH="400"/>' + '<FIELD attrname="remark1" fieldtype="string" WIDTH="400"/>' + '<FIELD attrname="remark2" fieldtype="string" WIDTH="400"/>' + '<FIELD attrname="remark3" fieldtype="string" WIDTH="400"/>' + '<FIELD attrname="machine" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="flag" fieldtype="i4"/>'    //切貨時間超2h,賦值2
    + '<FIELD attrname="cashtype" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="price" fieldtype="r8"/>' + '<FIELD attrname="untax_amt" fieldtype="r8"/>' + '<FIELD attrname="tax_amt" fieldtype="r8"/>' + '<FIELD attrname="artwork" fieldtype="string" WIDTH="50"/>' + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

const
  NotFound = '未找到圖紙';

//l_D3,L_D4在indate內,返回true
function TFrmDLIR110.ChkIndate(indate: string): Boolean;
var
  pos1: Integer;
  str1, str2: string;
begin
  Result := False;

  if Length(indate) > 0 then
  begin
    pos1 := Pos(',', indate);
    if pos1 = 0 then
    begin
      if (StrToDate(indate) >= l_D3) and (StrToDate(indate) <= l_D4) then
        Result := True;
    end
    else
    begin
      str1 := indate;
      while pos1 > 0 do
      begin
        str2 := Copy(str1, 1, pos1 - 1);
        if (StrToDate(str2) >= l_D3) and (StrToDate(str2) <= l_D4) then
        begin
          Result := True;
          Exit;
        end;
        str1 := Copy(str1, pos1 + 1, 200);
        pos1 := Pos(',', str1);
      end;
    end;
  end;
end;

procedure TFrmDLIR110.GetDS(xFliter: string);
var
  tmpDate: TDateTime;
  Data: OleVariant;
  tmpSQL, tmpOrderno, tmpBu, tmpOAO06, n2: string;
  tmpCDS, tmpCDSAddr: TClientDataSet;
  tmpList: TStrings;

begin
  g_StatusBar.Panels[0].Text := CheckLang('正在查詢[訂單]資料...');
  Application.ProcessMessages;
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDSAddr := TClientDataSet.Create(nil);
  tmpList := TStringList.Create;
  tmpList.Delimiter := '-';
  try
    tmpSQL := 'select C.*,oao06 from' + ' (select B.*,ima021 from' + ' (select A.*,occ02,occ241 from' + ' (select oea01,oea02,oea04,oea044,oea10,oea23,oeb03,oeb04,oeb05,oeb06,' + ' oeb11,oeb12,oeb13,oeb14,oeb14t,oeb15,oeb24,ta_oeb01,ta_oeb02,ta_oeb04,ta_oeb07,' + ' ta_oeb10,to_char(oea02,''YYYY/MM/DD'') q_oea02' + ' from oea_file inner join oeb_file on oea01=oeb01' + ' where oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y'' and oeb12>0' + ' and oea02>=sysdate-365' + ' and oea01 not like ''226%''' + ' and oea01 not like ''228%''' + ' and oea01 not like ''22A%''' + ' and oea01 not like ''22B%'''           //+' and oea04 not in(''N012'',''N005'')'
      + ' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%''' + ' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%''' + ' or oeb04 like ''R%'' or oeb04 like ''T%'')' + ' and oeb06 not like ''玻%''' + ' and oeb06 not like ''ML%'') A' + ' inner join occ_file on oea04=occ01 where 1=1 ' + xFliter + ' ) B left join ima_file on oeb04=ima01' + ' ) C left join oao_file on oea01=oao01 and oeb03=oao03' + ' order by oea02,oea01,oeb03';
    if l_IsDG then
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        tmpCDS.Data := Data
      else
        Exit;
    end
    else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
        tmpCDS.Data := Data
      else
        Exit;
    end;

    Data := null;
    tmpSQL := 'select ocd01,ocd02,ocd221 from ocd_file';
    if l_IsDG then
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        tmpCDSAddr.Data := Data
      else
        Exit;
    end
    else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
        tmpCDSAddr.Data := Data
      else
        Exit;
    end;

    with tmpCDS do
    begin
      if IsEmpty then
        Exit;
      while not Eof do
      begin
        l_SalCDS.Append;
        l_SalCDS.FieldByName('odate').AsDateTime := FieldByName('oea02').AsDateTime;
        try
          l_SalCDS.FieldByName('ddate').AsDateTime := DateOf(FieldByName('oeb15').AsDateTime);
        except
          l_SalCDS.FieldByName('ddate').Clear;
        end;
        l_SalCDS.FieldByName('custno').AsString := FieldByName('oea04').AsString;
        l_SalCDS.FieldByName('custshort').AsString := FieldByName('occ02').AsString;
        l_SalCDS.FieldByName('orderno').AsString := FieldByName('oea01').AsString;
        l_SalCDS.FieldByName('orderitem').AsInteger := FieldByName('oeb03').AsInteger;
        l_SalCDS.FieldByName('pno').AsString := FieldByName('oeb04').AsString;
        l_SalCDS.FieldByName('pname').AsString := FieldByName('oeb06').AsString;
        l_SalCDS.FieldByName('sizes').AsString := FieldByName('ima021').AsString;
        l_SalCDS.FieldByName('longitude').AsString := FieldByName('ta_oeb01').AsString;
        l_SalCDS.FieldByName('latitude').AsString := FieldByName('ta_oeb02').AsString;
        l_SalCDS.FieldByName('ta_oeb04').AsString := FieldByName('ta_oeb04').AsString;
        l_SalCDS.FieldByName('ta_oeb07').AsString := FieldByName('ta_oeb07').AsString;
        l_SalCDS.FieldByName('orderqty').AsFloat := FieldByName('oeb12').AsFloat;
        l_SalCDS.FieldByName('outqty').AsFloat := FieldByName('oeb24').AsFloat;
        l_SalCDS.FieldByName('remainqty').AsFloat := RoundTo(FieldByName('oeb12').AsFloat - FieldByName('oeb24').AsFloat, -3);
        l_SalCDS.FieldByName('units').AsString := FieldByName('oeb05').AsString;
        l_SalCDS.FieldByName('custorderno').AsString := FieldByName('oea10').AsString;
        l_SalCDS.FieldByName('custprono').AsString := FieldByName('oeb11').AsString;
        l_SalCDS.FieldByName('custname').AsString := FieldByName('ta_oeb10').AsString;
        if Length(FieldByName('oea044').AsString) > 0 then
        begin
          if tmpCDSAddr.Locate('ocd01;ocd02', VarArrayOf([FieldByName('oea04').AsString, FieldByName('oea044').AsString]), []) then
            l_SalCDS.FieldByName('sendaddr').AsString := tmpCDSAddr.FieldByName('ocd221').AsString;
        end
        else
          l_SalCDS.FieldByName('sendaddr').AsString := FieldByName('occ241').AsString;
        l_SalCDS.FieldByName('remark').AsString := FieldByName('oao06').AsString;
        l_SalCDS.FieldByName('cashtype').AsString := FieldByName('oea23').AsString;
        l_SalCDS.FieldByName('price').AsFloat := FieldByName('oeb13').AsFloat;
        l_SalCDS.FieldByName('untax_amt').AsFloat := FieldByName('oeb14').AsFloat;
        l_SalCDS.FieldByName('tax_amt').AsFloat := FieldByName('oeb14t').AsFloat;
        l_SalCDS.Post;
        if Pos(FieldByName('oea01').AsString, tmpOrderno) = 0 then
          tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('oea01').AsString);
        Next;
      end;
    end;

    //***交期與備註***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[交期與備註]資料...');
    Application.ProcessMessages;
    if l_IsDG then
      tmpBu := 'ITEQDG'
    else
      tmpBu := 'ITEQGZ';
    Delete(tmpOrderno, 1, 1);
    Data := null;
    tmpSQL := 'Select Orderno,Orderitem,Ddate,Edate,Remark1,Remark2' + ' From DLI017 Where Bu=' + Quotedstr(tmpBu) + ' And Orderno in (' + tmpOrderno + ')';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with tmpCDS do
      while not Eof do
      begin
        if l_SalCDS.Locate('orderno;orderitem', VarArrayof([FieldByName('orderno').AsString, IntToStr(FieldByName('orderitem').AsInteger)]), []) then
        begin
          l_SalCDS.Edit;
          if not FieldByName('ddate').IsNull then
            l_SalCDS.FieldByName('ddate').AsDateTime := FieldByName('ddate').AsDateTime;
          if not tmpCDS.FieldByName('edate').IsNull then
            l_SalCDS.FieldByName('edate').AsDateTime := FieldByName('edate').AsDateTime;
          l_SalCDS.FieldByName('remark1').AsString := FieldByName('remark1').AsString;
          l_SalCDS.FieldByName('remark2').AsString := FieldByName('remark2').AsString;
          l_SalCDS.Post;
        end;
        Next;
      end;
    //***交期與備註***
    //過濾達客戶交期edate
    if not VarIsNull(l_D1) then
    begin
      with l_SalCDS do
      begin
        First;
        while not Eof do
        begin
          if not FieldByName('edate').IsNull then
          begin
            if (FieldByName('edate').AsDateTime < l_D1) or (FieldByName('edate').AsDateTime > l_D2) then
              Delete
          end
          else
            Next;
        end;

        if IsEmpty then
          Exit;
        tmpOrderno := '';
        First;
        while not Eof do
        begin
          if Pos(FieldByName('orderno').AsString, tmpOrderno) = 0 then
            tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('orderno').AsString);
          Next;
        end;
        System.Delete(tmpOrderno, 1, 1);
      end;
    end;
    //過濾達客戶交期edate
    //***生管達交日期、Call貨日期***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[拆分交期]資料...');
    Application.ProcessMessages;
    Data := null;
    tmpSQL := 'Select Orderno,Orderitem,Adate,Cdate' + ' From MPS200 Where Bu=' + Quotedstr(tmpBu) + ' And Orderno in (' + tmpOrderno + ')' + ' And IsNull(GarbageFlag,0)=0' + ' Order By Orderno,Orderitem,Adate,Cdate';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with tmpCDS do
      while not Eof do
      begin
        if l_SalCDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, IntToStr(FieldByName('orderitem').AsInteger)]), []) then
        begin
          if (not FieldByName('adate').IsNull) and (Pos(DateToStr(FieldByName('adate').AsDateTime), l_SalCDS.FieldByName('adate').AsString) = 0) then
          begin
            l_SalCDS.Edit;
            if l_SalCDS.FieldByName('edate').IsNull then //達客戶交期=生管交期
              l_SalCDS.FieldByName('edate').AsDateTime := FieldByName('adate').AsDateTime;
            if Length(l_SalCDS.FieldByName('adate').AsString) > 0 then
              l_SalCDS.FieldByName('adate').AsString := l_SalCDS.FieldByName('adate').AsString + ',' + DateToStr(FieldByName('adate').AsDateTime)
            else
              l_SalCDS.FieldByName('adate').AsString := DateToStr(FieldByName('adate').AsDateTime);
            l_SalCDS.Post;
          end;

          if (not FieldByName('cdate').IsNull) and (Pos(DateToStr(FieldByName('cdate').AsDateTime), l_SalCDS.FieldByName('cdate').AsString) = 0) then
          begin
            l_SalCDS.Edit;
            if Length(l_SalCDS.FieldByName('cdate').AsString) > 0 then
              l_SalCDS.FieldByName('cdate').AsString := l_SalCDS.FieldByName('cdate').AsString + ',' + DateToStr(FieldByName('cdate').AsDateTime)
            else
              l_SalCDS.FieldByName('cdate').AsString := DateToStr(FieldByName('cdate').AsDateTime);
            l_SalCDS.Post;
          end;
        end;
        Next;
      end;
    //***生管達交日期、Call貨日期***
    //過濾達客戶交期edate
    if not VarIsNull(l_D1) then
    begin
      with l_SalCDS do
      begin
        First;
        while not Eof do
        begin
          if (FieldByName('edate').AsDateTime < l_D1) or (FieldByName('edate').AsDateTime > l_D2) then
            Delete
          else
            Next;
        end;
      end;
    end;
    //過濾達客戶交期edate
    //***出貨日期***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[出貨日期]資料...');
    Application.ProcessMessages;
    Data := null;
    tmpSQL := 'Select Orderno,Orderitem,Indate' + ' From DLI010 Where Bu=' + Quotedstr(tmpBu) + ' And IsNull(GarbageFlag,0)=0' + ' And IsNull(QtyColor,0)<>' + IntToStr(g_CocData) + ' And Orderno in (' + tmpOrderno + ')' + ' Order By Orderno,Orderitem,Indate';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with tmpCDS do
      while not Eof do
      begin
        if l_SalCDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, IntToStr(FieldByName('orderitem').AsInteger)]), []) then
        begin
          if (not FieldByName('indate').IsNull) and (Pos(DateToStr(FieldByName('indate').AsDateTime), l_SalCDS.FieldByName('indate').AsString) = 0) then
          begin
            l_SalCDS.Edit;
            if Length(l_SalCDS.FieldByName('indate').AsString) > 0 then
              l_SalCDS.FieldByName('indate').AsString := l_SalCDS.FieldByName('indate').AsString + ',' + DateToStr(FieldByName('indate').AsDateTime)
            else
              l_SalCDS.FieldByName('indate').AsString := DateToStr(FieldByName('indate').AsDateTime);
            l_SalCDS.Post;
          end;
        end;
        Next;
      end;
    //***出貨日期***
    //過濾出貨日期indate
    if not VarIsNull(l_D3) then
    begin
      with l_SalCDS do
      begin
        First;
        while not Eof do
        begin
          if not ChkIndate(FieldByName('indate').AsString) then
            Delete
          else
            Next;
        end;
      end;
    end;
    //過濾出貨日期indate
    //***切貨時間***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[切貨時間]資料...');
    Application.ProcessMessages;
    Data := null;
    tmpSQL := 'Select Custno,Stime From MPS290 Where Bu=''ITEQDG''';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with l_SalCDS do
    begin
      First;
      while not Eof do
      begin
        tmpCDS.First;
        while not tmpCDS.Eof do
        begin
          if (Pos(FieldByName('custno').AsString, tmpCDS.FieldByName('custno').AsString) > 0) and (not tmpCDS.FieldByName('stime').IsNull) then
          begin
            Edit;
            FieldByName('stime').AsString := FormatDateTime('HH:NN', tmpCDS.FieldByName('stime').AsDateTime);
            if (Length(FieldByName('indate').AsString) > 0) and (Pos(',', FieldByName('indate').AsString) = 0) and (FieldByName('remainqty').AsFloat > 0) then
            begin
              tmpDate := StrToDateTime(FieldByName('indate').AsString + ' ' + FieldByName('stime').AsString);
              if (tmpDate < Now) and (SecondsBetween(tmpDate, Now) > 7200) then //2h
                FieldByName('flag').AsInteger := 2;
            end;
            Post;
            Break;
          end;
          tmpCDS.Next;
        end;
        Next;
      end;
    end;
    //***切貨時間***
    //***生產線別CCL&PP***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[生產線別]資料...');
    Application.ProcessMessages;
    Data := null;
    tmpSQL := 'Select Distinct Orderno,Orderitem,Machine From MPS010 Where Bu=''ITEQDG''' + ' And IsNull(ErrorFlag,0)=0 And Orderno in (' + tmpOrderno + ')';
    if l_IsDG then
      tmpSQL := tmpSQL + ' And SrcFlag in (1,3,5)'
    else
      tmpSQL := tmpSQL + ' And SrcFlag in (2,4,6)';
    tmpSQL := tmpSQL + ' Union All' + ' Select Distinct Orderno,Orderitem,Machine From MPS070 Where Bu=''ITEQDG''' + ' And IsNull(ErrorFlag,0)=0 And Orderno in (' + tmpOrderno + ')';
    if l_IsDG then
      tmpSQL := tmpSQL + ' And SrcFlag in (1,3,5)'
    else
      tmpSQL := tmpSQL + ' And SrcFlag in (2,4,6)';
    tmpSQL := tmpSQL + ' Order By Orderno,Orderitem,Machine';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with l_SalCDS do
    begin
      First;
      while not Eof do
      begin
        tmpCDS.Filtered := False;
        tmpCDS.Filter := 'orderno=' + Quotedstr(FieldByName('orderno').AsString) + ' and orderitem=' + IntToStr(FieldByName('orderitem').AsInteger);
        tmpCDS.Filtered := True;
        tmpCDS.First;
        while not tmpCDS.Eof do
        begin
          if Pos(tmpCDS.FieldByName('machine').AsString, FieldByName('machine').AsString) = 0 then
          begin
            Edit;
            if Length(FieldByName('machine').AsString) > 0 then
              FieldByName('machine').AsString := FieldByName('machine').AsString + ',';
            FieldByName('machine').AsString := FieldByName('machine').AsString + tmpCDS.FieldByName('machine').AsString;
            Post;
          end;
          tmpCDS.Next;
        end;
        Next;
      end;
    end;
    tmpCDS.Filtered := False;
    //***生產線別CCL&PP***
    //***兩角訂單***
    g_StatusBar.Panels[0].Text := CheckLang('正在查詢[兩角訂單]資料...');
    Application.ProcessMessages;
    with l_SalCDS do
    begin
      First;
      while not Eof do
      begin
        tmpSQL := FieldByName('custno').AsString + '-' + FieldByName('orderno').AsString + '-' + FieldByName('orderitem').AsString;
        tmpOAO06 := tmpOAO06 + ' or oao06 like ' + Quotedstr(tmpSQL + '%');
        Next;
      end;
    end;
    if Length(tmpOAO06) > 0 then
    begin
      Delete(tmpOAO06, 1, 4);
      Data := null;
      tmpSQL := 'select oao01,oao03,oao06 from oao_file where (' + tmpOAO06 + ')';
      if l_IsDG then
      begin
        tmpSQL := tmpSQL + ' and (oao01 like ''P1T%'' or oao01 like ''P1Y%'' or oao01 like ''P1Z%'' or oao01 like ''P1N%'')';
        if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
          tmpCDS.Data := Data
        else
          Exit;
      end
      else
      begin
        tmpSQL := tmpSQL + ' and (oao01 like ''P2Y%'' or oao01 like ''P2Z%'' or oao01 like ''P2N%'')';
        if QueryBySQL(tmpSQL, Data, 'ORACLE') then
          tmpCDS.Data := Data
        else
          Exit;
      end;

      with tmpCDS do
        while not Eof do
        begin
          tmpList.DelimitedText := FieldByName('oao06').AsString;
          if tmpList.Count >= 4 then
            if l_SalCDS.Locate('custno;orderno;orderitem', VarArrayOf([tmpList.Strings[0], tmpList.Strings[1] + '-' + tmpList.Strings[2], tmpList.Strings[3]]), []) then
            begin
              l_SalCDS.Edit;
              l_SalCDS.FieldByName('remark3').AsString := FieldByName('oao01').AsString + '-' + FieldByName('oao03').AsString;
              l_SalCDS.Post;
            end;
          Next;
        end;
    end;
    //***兩角訂單***
    //***更新圖紙資料***
    g_StatusBar.Panels[0].Text := CheckLang('正在更新圖紙資料...');
    Application.ProcessMessages;
    with l_SalCDS do
    begin
      First;
      while not Eof do
      begin
        n2 := RightStr(FieldByName('Remark').AsString, 2);  {(*}
        if (FieldByName('custno').AsString='N006') and
           (LeftStr(FieldByName('Pno').AsString,1)='M') and
           ((n2='N5')or(n2='N7')) then                  {*)}
        begin
          Edit;
          if l_DLI680.Locate('plant;long;lat', VarArrayOf([n2, copy(FieldByName('Pno').AsString, 11, 4), copy(FieldByName('Pno').AsString, 15, 4)]), []) then
            FieldByName('Artwork').AsString := l_DLI680.fieldbyname('artwork').AsString
          else
            FieldByName('Artwork').AsString := NotFound;
        end;
        Next;
      end;
    end;
    //***更新圖紙資料***

    if l_SalCDS.ChangeCount > 0 then
      l_SalCDS.MergeChangeLog;

    SetCCLStruct(l_SalCDS, g_UInfo^.BU, 'pno', 'struct', 'ta_oeb04');

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDSAddr);
    FreeAndNil(tmpList);
    l_SalCDS.EnableControls;
    CDS.Data := l_SalCDS.Data;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmDLIR110.CalcTotQty;
var
  i: Integer;
  Arr: array[0..11] of Double;
  tmpCDS: TClientDataSet;
begin
  for i := Low(Arr) to High(Arr) do
    Arr[i] := 0;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    LblTot.Caption := '訂單/已出/未出=> CCL:0/0/0    PN:0/0/0    PP:0/0/0    PN:0/0/0';
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    with tmpCDS do
      while not Eof do
      begin
        if SameText(FieldByName('units').AsString, 'SH') then
        begin
          Arr[0] := Arr[0] + FieldByName('orderqty').AsFloat;
          Arr[1] := Arr[1] + FieldByName('outqty').AsFloat;
          Arr[2] := Arr[2] + FieldByName('remainqty').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'RL') or SameText(FieldByName('units').AsString, 'ROL') then
        begin
          Arr[3] := Arr[3] + FieldByName('orderqty').AsFloat;
          Arr[4] := Arr[4] + FieldByName('outqty').AsFloat;
          Arr[5] := Arr[5] + FieldByName('remainqty').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'PN') and (Pos(LeftStr(FieldByName('pno').AsString, 1), 'ET') > 0) then
        begin
          Arr[6] := Arr[6] + FieldByName('orderqty').AsFloat;
          Arr[7] := Arr[7] + FieldByName('outqty').AsFloat;
          Arr[8] := Arr[8] + FieldByName('remainqty').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'PN') and (Pos(LeftStr(FieldByName('pno').AsString, 1), 'MN') > 0) then
        begin
          Arr[9] := Arr[9] + FieldByName('orderqty').AsFloat;
          Arr[10] := Arr[10] + FieldByName('outqty').AsFloat;
          Arr[11] := Arr[11] + FieldByName('remainqty').AsFloat;
        end;

        Next;
      end;

    LblTot.Caption := '訂單/已出/未出=> CCL:' + FloatToStr(Arr[0]) + '/' + FloatToStr(Arr[1]) + '/' + FloatToStr(Arr[2]) + '   PN:' + FloatToStr(Arr[3]) + '/' + FloatToStr(Arr[4]) + '/' + FloatToStr(Arr[5]) + '   PP:' + FloatToStr(Arr[6]) + '/' + FloatToStr(Arr[7]) + '/' + FloatToStr(Arr[8]) + '   PN:' + FloatToStr(Arr[9]) + '/' + FloatToStr(Arr[10]) + '/' + FloatToStr(Arr[11]);
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmDLIR110.RefreshDS(strFilter: string);
begin
  if strFilter = g_cFilterNothing then
    CDS.Data := l_SalCDS.Data
  else
    GetDS(strFilter);
  CalcTotQty();

  inherited;
end;

procedure TFrmDLIR110.FormCreate(Sender: TObject);
var
  data: OleVariant;
  sql: string;
begin
  p_SysId := 'Dli';
  p_TableName := 'DLIR110';
  p_GridDesignAns := True;
  l_IsDG := SameText(g_UInfo^.BU, 'ITEQDG');
  l_SalCDS := TClientDataSet.Create(Self);
  l_DLI680 := TClientDataSet.Create(Self);
  sql := 'select * from dli680 where bu=' + QuotedStr(g_uinfo^.BU);
  if QueryBySQL(sql, data) then
    l_DLI680.data := data;
  InitCDS(l_SalCDS, g_Xml);

  inherited;

  l_Img := TBitmap.Create;
end;

procedure TFrmDLIR110.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_SalCDS);
  FreeAndNil(l_DLI680);
  FreeAndNil(l_Img);
end;

procedure TFrmDLIR110.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmDLIR110.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
    Abort;
end;

procedure TFrmDLIR110.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  inherited;
  tmpSQL := 'Select * From DLI017 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(CDS.FieldByName('Orderno').AsString) + ' And Orderitem=' + IntToStr(CDS.FieldByName('Orderitem').AsInteger);
  if not QueryBySQL(tmpSQL, Data) then
  begin
    CDS.CancelUpdates;
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      tmpCDS.Append;
      tmpCDS.FieldByName('Bu').AsString := g_UInfo^.BU;
      tmpCDS.FieldByName('Orderno').AsString := CDS.FieldByName('Orderno').AsString;
      tmpCDS.FieldByName('Orderitem').AsInteger := CDS.FieldByName('Orderitem').AsInteger;
      tmpCDS.FieldByName('Idate').AsDateTime := Now;
      tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.Wk_no;
    end
    else
    begin
      tmpCDS.Edit;
      tmpCDS.FieldByName('Mdate').AsDateTime := Now;
      tmpCDS.FieldByName('Muser').AsString := g_UInfo^.Wk_no;
    end;
    if CDS.FieldByName('Ddate').IsNull then
      tmpCDS.FieldByName('Ddate').Clear
    else
      tmpCDS.FieldByName('Ddate').AsDateTime := CDS.FieldByName('Ddate').AsDateTime;
    if CDS.FieldByName('Edate').IsNull then
      tmpCDS.FieldByName('Edate').Clear
    else
      tmpCDS.FieldByName('Edate').AsDateTime := CDS.FieldByName('Edate').AsDateTime;
    tmpCDS.FieldByName('Remark1').AsString := CDS.FieldByName('Remark1').AsString;
    tmpCDS.FieldByName('Remark2').AsString := CDS.FieldByName('Remark2').AsString;
    tmpCDS.Post;
    if CDSPost(tmpCDS, 'DLI017') then
      CDS.MergeChangeLog
    else
      CDS.CancelUpdates;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmDLIR110.btn_queryClick(Sender: TObject);
var
  str: string;
begin
  //inherited;
  if not Assigned(FrmDLIR110_Query) then
    FrmDLIR110_Query := TFrmDLIR110_Query.Create(Application);
  g_StatusBar.Panels[0].Text := CheckLang('正在查詢...');
  Application.ProcessMessages;
  try
    if FrmDLIR110_Query.ShowModal = mrOK then
    begin
      l_D1 := FrmDLIR110_Query.Dtp3.Value;
      l_D2 := FrmDLIR110_Query.Dtp4.Value;
      l_D3 := FrmDLIR110_Query.Dtp5.Value;
      l_D4 := FrmDLIR110_Query.Dtp6.Value;
      if VarIsNull(l_D1) then
        l_D1 := l_D2;
      if VarIsNull(l_D2) then
        l_D2 := l_D1;
      if VarIsNull(l_D3) then
        l_D3 := l_D4;
      if VarIsNull(l_D4) then
        l_D4 := l_D3;
      str := ' and q_oea02>=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmDLIR110_Query.Dtp1.Date), '-', '/', [rfReplaceAll])) + ' and q_oea02<=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmDLIR110_Query.Dtp2.Date), '-', '/', [rfReplaceAll]));
      if Length(Trim(FrmDLIR110_Query.Edit2.Text)) > 0 then
        str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmDLIR110_Query.Edit2.Text))) + ',oea01)>0';
      if Length(Trim(FrmDLIR110_Query.Edit1.Text)) > 0 then
        str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmDLIR110_Query.Edit1.Text))) + ',oea04)>0';
      if Length(Trim(FrmDLIR110_Query.Edit3.Text)) > 0 then
        str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmDLIR110_Query.Edit3.Text))) + ',oea10)>0';
      case FrmDLIR110_Query.Rgp.ItemIndex of
        0:
          str := str + ' and oeb12>oeb24';
        1:
          str := str + ' and oeb12=oeb24';
      end;
      RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
      RefreshDS(str);
    end;
  finally
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmDLIR110.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  P: TPoint;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if (CDS.FieldByName('flag').AsInteger = 2) and SameText(Column.FieldName, 'flag') then
  begin
    ImageList2.GetBitmap(6, l_Img);
    with DBGridEh1.Canvas do
    begin
      FillRect(Rect);
      P.X := round((Rect.Left + Rect.Right - l_Img.Width) / 2);
      P.Y := round((Rect.Top + Rect.Bottom - l_Img.Height) / 2);
      Draw(P.X, P.Y, l_Img);
    end;
  end
  else if (Column.FieldName = 'artwork') then
  begin
//    Canvas.Font.Color := clBlack;
    if Column.Field.AsString = NotFound then
    begin
      Canvas.Brush.Color := clred;
      Canvas.FillRect(Rect);
      Canvas.TextRect(Rect, Rect.Left, Rect.Top, NotFound);
    end;
  end;

end;

procedure TFrmDLIR110.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.

