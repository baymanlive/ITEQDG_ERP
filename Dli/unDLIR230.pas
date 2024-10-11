{*******************************************************}
{                                                       }
{                unMPSR230                              }
{                Author: kaikai                         }
{                Create date: 2019/11/22                }
{                Description: 生益出貨資料              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR230;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, Math, StrUtils;

type
  T061Rec = record
    RTF, RTF2, VLP, HVLP: string;
  end;

type
  TFrmDLIR230 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private    { Private declarations }
    l_CDS1, l_CDS2: TClientDataSet;
    procedure GetDiff(c_sizesX: string; var valueX, valueY: double);
    procedure GetDS(D1, D2: TDateTime; cIndex: Integer);
  public    { Public declarations }
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLIR230: TFrmDLIR230;


implementation

uses
  unGlobal, unCommon, unDLIR230_query;

const
  l_xml1 = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' + '<FIELD attrname="indate" fieldtype="datetime"/>' + '<FIELD attrname="c_lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="c_orderno" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="c_pno" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="v0" fieldtype="r8"/>' +
    '<FIELD attrname="v0_1" fieldtype="r8"/>' + '<FIELD attrname="v0_2" fieldtype="r8"/>' + '<FIELD attrname="qty" fieldtype="r8"/>' + '<FIELD attrname="v1" fieldtype="r8"/>' + '<FIELD attrname="v2" fieldtype="r8"/>' + '<FIELD attrname="v3" fieldtype="r8"/>' + '<FIELD attrname="v4" fieldtype="r8"/>' + '<FIELD attrname="v5" fieldtype="r8"/>' + '<FIELD attrname="v6" fieldtype="r8"/>' + '<FIELD attrname="v7" fieldtype="r8"/>' + '<FIELD attrname="v8" fieldtype="r8"/>' + '<FIELD attrname="v9" fieldtype="r8"/>'            //下面欄位不匯出xls
    + '<FIELD attrname="sno" fieldtype="i4"/>' + '<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="src" fieldtype="string" WIDTH="10"/>'            //上面欄位不匯出xls
    + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';


const
  l_xml2 = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' + '<FIELD attrname="c_orderno" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="indate" fieldtype="datetime"/>' + '<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="c_lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="c_pno" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="rc0" fieldtype="r8"/>' +
    '<FIELD attrname="rc0_1" fieldtype="r8"/>' + '<FIELD attrname="rc0_2" fieldtype="r8"/>' + '<FIELD attrname="rc1" fieldtype="r8"/>' + '<FIELD attrname="rc2" fieldtype="r8"/>' + '<FIELD attrname="rc3" fieldtype="r8"/>' + '<FIELD attrname="rc4" fieldtype="r8"/>' + '<FIELD attrname="rc5" fieldtype="r8"/>' + '<FIELD attrname="rc6" fieldtype="r8"/>'            //下面欄位不匯出xls
    + '<FIELD attrname="sno" fieldtype="i4"/>' + '<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="qty" fieldtype="r8"/>' + '<FIELD attrname="src" fieldtype="string" WIDTH="10"/>'            //上面欄位不匯出xls
    + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';


var
  custno: string;

{$R *.dfm}
//客戶品名取公差值
//3種符號類型:+a/-b或+/-或±
procedure TFrmDLIR230.GetDiff(c_sizesX: string; var valueX, valueY: double);
var
  tmpStr, s1, s2, sp: WideString;
  pos1, pos2, len: Integer;

  //取數字

  function getNum(xStr: string): string;
  var
    s: string;
    i, num: Integer;
  begin
    num := 0;
    s := '';
    for i := 1 to Length(xStr) do
    begin
      if Char(xStr[i]) in ['0'..'9', '.'] then
      begin
        if xStr[i] = '.' then
          num := num + 1;
        if num < 2 then
          s := s + xStr[i]
        else
          Break;
      end
      else
        Break;
    end;
    Result := s;
  end;

begin
  valueX := 0;
  valueY := 0;
  tmpStr := c_sizesX;

  //+a/-b
  pos1 := pos('+', tmpStr);
  pos2 := pos('/-', tmpStr);
  if (pos1 > 0) and (pos2 > 0) and (pos2 - pos1 > 1) then
  begin
    s1 := Copy(tmpStr, pos1 + 1, pos2 - pos1 - 1);     //a
    Delete(tmpStr, 1, pos2 + 1);
    s2 := getNum(tmpStr);                      //b
    valueX := StrToFloatDef(s1, 0);
    valueY := StrToFloatDef(s2, 0);
    Exit;
  end;

  //+/-或±
  len := 2;
  sp := '+/-';
  pos1 := pos(sp, tmpStr);
  if pos1 = 0 then
  begin
    len := 0;
    sp := '±';
    pos1 := pos(sp, tmpStr);
  end;

  if pos1 > 0 then
  begin
    Delete(tmpStr, 1, pos1 + len);
    s2 := getNum(tmpStr);
    valueX := StrToFloatDef(s2, 0);
    valueY := valueX;
  end;
end;

procedure TFrmDLIR230.GetDS(D1, D2: TDateTime; cIndex: Integer);
const
  cnt = 50;  //每次查詢tiptop 50筆
var
  v1, v2: double;
  tmpRecno: Integer;
  tmpSQL: string;
  C061: T061Rec;
  Data: OleVariant;
  tmpCDS, tmpCDS_360, tmpCDS_dg, tmpCDS_gz: TClientDataSet;

  function GetV0(pno: string): double;
  var
    lstCode2, code7, code8, ftype: string;
  begin
    Result := StrToInt(Copy(pno, 3, 4)) / 10;
    code7 := Copy(pno, 7, 1);
    code8 := Copy(pno, 8, 1);
    lstCode2 := LeftStr(RightStr(pno, 2), 1);

    if Pos(lstCode2, C061.RTF) > 0 then
      ftype := 'B'
    else if Pos(lstCode2, C061.VLP) > 0 then
      ftype := 'C'
    else if Pos(lstCode2, C061.HVLP) > 0 then
      ftype := 'D'
    else
      ftype := 'A';

    with tmpCDS_360 do
    begin
      Filtered := False;
      Filter := 'custno<>''@'' and type=' + Quotedstr(ftype);
      Filtered := True;
      if IsEmpty then
      begin
        Filtered := False;
        Filter := 'custno=''@'' and type=' + Quotedstr(ftype);
        Filtered := True;
      end;
      if Locate('sizes', code7, [loCaseInsensitive]) then
        Result := Result + FieldByName('fvalue').AsFloat;
      if Locate('sizes', code8, [loCaseInsensitive]) then
        Result := Result + FieldByName('fvalue').AsFloat;
      Filtered := False;
    end;
  end;

begin
  g_StatusBar.Panels[0].Text := '正在查詢出貨資料...';
  Application.ProcessMessages;
  if cIndex = 0 then
    tmpSQL := 'AC084'
  else if cIndex = 1 then
    tmpSQL := 'ACD04'
  else
    tmpSQL := 'AC082';

  tmpSQL := 'exec [dbo].[proc_DLIR230] ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(DateToStr(D1)) + ',' + Quotedstr(DateToStr(D2)) + ',' + Quotedstr(tmpSQL);
  if not QueryBySQL(tmpSQL, Data) then
  begin
    g_StatusBar.Panels[0].Text := '';
    Exit;
  end;

  l_CDS1.EmptyDataSet;
  l_CDS2.EmptyDataSet;
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS_360 := TClientDataSet.Create(nil);
  tmpCDS_dg := TClientDataSet.Create(nil);
  tmpCDS_gz := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
    begin
      if IsEmpty then
        Exit;
      First;
      while not Eof do
      begin
        tmpSQL := RightStr(FieldByName('pno').AsString, 1);
        Edit;
        if Pos(tmpSQL, g_DGLastCode) > 0 then
          FieldByName('src').AsString := 'DG'
        else if Pos(tmpSQL, g_GZLastCode) > 0 then
          FieldByName('src').AsString := 'GZ'
        else
          FieldByName('src').AsString := 'ERR';
        Post;
        Next;
      end;
      if ChangeCount > 0 then
        MergeChangeLog;
    end;

    //RTF、RTF2、VLP、HVLP
    Data := null;
    tmpSQL := 'select rtf,rtf2,vlp,hvlp from dli061 where bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS_360.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('剝離強度RTF、RTF2、VLP、HVLP未設定!', 48);
      Exit;
    end;

    C061.RTF := tmpCDS_360.FieldByName('rtf').AsString;
    C061.RTF2 := tmpCDS_360.FieldByName('rtf2').AsString;
    C061.VLP := tmpCDS_360.FieldByName('vlp').AsString;
    C061.HVLP := tmpCDS_360.FieldByName('hvlp').AsString;

    //ccl
    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'ftype=''CCL''';
    tmpCDS.Filtered := True;
    if not tmpCDS.IsEmpty then
    begin
      //銅厚
      g_StatusBar.Panels[0].Text := '正在查詢銅箔厚度...';
      Application.ProcessMessages;
      Data := null;
      tmpSQL := 'select * from dli360 where bu=' + Quotedstr(g_UInfo^.BU) + ' and (charindex(''AC084'',custno)>0 or custno=''@'')';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS_360.Data := Data;

      //dg 9點值
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''CCL'' and src=''DG''';
      tmpCDS.Filtered := True;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.First;
        tmpRecno := 1;
        while tmpRecno <= tmpCDS.RecNo do
        begin
          tmpSQL := '';
          with tmpCDS do
            while not Eof do
            begin
              tmpRecno := tmpCDS.RecNo;

              if tmpSQL <> '' then
                tmpSQL := tmpSQL + ' or ';
              if custno='AC082' then
              begin
                tmpSQL := tmpSQL + ' (tc_sih02 Like ' + Quotedstr(Copy(FieldByName('lot').AsString, 1, 10) + '%')    //只要前10碼
                  + ')';
              end
              else
              begin
                tmpSQL := tmpSQL + ' (tc_sih02 Like ' + Quotedstr(Copy(FieldByName('lot').AsString, 1, 10) + '%')    //只要前10碼
                  + ' and shb05=' + Quotedstr(FieldByName('wono').AsString) + ')';
              end;
              Next;
              if (not Eof) and (tmpRecno mod cnt = 0) then
                Break;
            end;

          g_StatusBar.Panels[0].Text := '正在查詢DG九點資訊' + IntToStr(tmpRecno);
          Application.ProcessMessages;
          Inc(tmpRecno);

          Data := null;
          tmpSQL := 'select shb05,substr(tc_sih02,1,10) tc_sih02,tc_sih111,tc_sih112,tc_sih113,tc_sih114,tc_sih115,tc_sih116,tc_sih117,tc_sih118,tc_sih119' + ' from tc_sih_file inner join shb_file' + ' on tc_sih01=shb01 where (' + tmpSQL + ') and shbacti=''Y''';
          if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
            Exit;
          if Data <> null then
          begin
            if tmpCDS_dg.Active then
              tmpCDS_dg.AppendData(Data, True)
            else
              tmpCDS_dg.Data := Data;
          end;
        end;
      end;

      //gz 9點值
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''CCL'' and src=''GZ''';
      tmpCDS.Filtered := True;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.First;
        tmpRecno := 1;
        while tmpRecno <= tmpCDS.RecNo do
        begin
          tmpSQL := '';
          with tmpCDS do
            while not Eof do
            begin
              tmpRecno := tmpCDS.RecNo;

              if tmpSQL <> '' then
                tmpSQL := tmpSQL + ' or ';
              tmpSQL := tmpSQL + ' (tc_sih02 Like ' + Quotedstr(Copy(FieldByName('lot').AsString, 1, 10) + '%')    //只要前10碼
                + ' and shb05=' + Quotedstr(FieldByName('wono').AsString) + ')';
              Next;
              if (not Eof) and (tmpRecno mod cnt = 0) then
                Break;
            end;

          g_StatusBar.Panels[0].Text := '正在查詢DG九點資訊' + IntToStr(tmpRecno);
          Application.ProcessMessages;
          Inc(tmpRecno);

          Data := null;
          tmpSQL := 'select shb05,substr(tc_sih02,1,10) tc_sih02,tc_sih111,tc_sih112,tc_sih113,tc_sih114,tc_sih115,tc_sih116,tc_sih117,tc_sih118,tc_sih119' + ' from tc_sih_file inner join shb_file' + ' on tc_sih01=shb01 where (' + tmpSQL + ') and shbacti=''Y''';
          if not QueryBySQL(tmpSQL, Data, 'ORACLE1') then
            Exit;
          if Data <> null then
          begin
            if tmpCDS_gz.Active then
              tmpCDS_gz.AppendData(Data, True)
            else
              tmpCDS_gz.Data := Data;
          end;
        end;
      end;

      g_StatusBar.Panels[0].Text := '正在計算CCL資料...';
      Application.ProcessMessages;
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''CCL''';
      tmpCDS.Filtered := True;
      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
          GetDiff(tmpCDS.FieldByName('c_sizes').AsString, v1, v2);
        with l_CDS1 do
        begin
          Append;
          FieldByName('indate').AsDateTime := tmpCDS.FieldByName('indate').AsDateTime;
          FieldByName('lot').AsString := tmpCDS.FieldByName('lot').AsString;
          FieldByName('c_orderno').AsString := tmpCDS.FieldByName('c_orderno').AsString;
          FieldByName('c_pno').AsString := tmpCDS.FieldByName('c_pno').AsString;
          FieldByName('c_sizes').AsString := tmpCDS.FieldByName('c_sizes').AsString;
          FieldByName('v0').AsFloat := GetV0(tmpCDS.FieldByName('pno').AsString);
          FieldByName('v0_1').AsFloat := RoundTo(FieldByName('v0').AsFloat + v1 * 39.37, -3);
          FieldByName('v0_2').AsFloat := RoundTo(FieldByName('v0').AsFloat - v2 * 39.37, -3);
          FieldByName('qty').AsFloat := tmpCDS.FieldByName('qty').AsFloat;
          FieldByName('sno').AsInteger := tmpCDS.FieldByName('sno').AsInteger;
          FieldByName('pno').AsString := tmpCDS.FieldByName('pno').AsString;
          FieldByName('wono').AsString := tmpCDS.FieldByName('wono').AsString;
          FieldByName('src').AsString := tmpCDS.FieldByName('src').AsString;
          if custno='AC082' then
          begin
            if SameText(FieldByName('src').AsString, 'dg') and tmpCDS_dg.Active and tmpCDS_dg.Locate('tc_sih02', VarArrayOf([Copy(FieldByName('lot').AsString, 1, 10)]), []) then
            begin
              FieldByName('v1').Value := tmpCDS_dg.FieldByName('tc_sih111').Value;
              FieldByName('v2').Value := tmpCDS_dg.FieldByName('tc_sih112').Value;
              FieldByName('v3').Value := tmpCDS_dg.FieldByName('tc_sih113').Value;
              FieldByName('v4').Value := tmpCDS_dg.FieldByName('tc_sih114').Value;
              FieldByName('v5').Value := tmpCDS_dg.FieldByName('tc_sih115').Value;
              FieldByName('v6').Value := tmpCDS_dg.FieldByName('tc_sih116').Value;
              FieldByName('v7').Value := tmpCDS_dg.FieldByName('tc_sih117').Value;
              FieldByName('v8').Value := tmpCDS_dg.FieldByName('tc_sih118').Value;
              FieldByName('v9').Value := tmpCDS_dg.FieldByName('tc_sih119').Value;
            end
          end
          else if SameText(FieldByName('src').AsString, 'dg') and tmpCDS_dg.Active and tmpCDS_dg.Locate('shb05;tc_sih02', VarArrayOf([FieldByName('wono').AsString, Copy(FieldByName('lot').AsString, 1, 10)]), []) then
          begin
            FieldByName('v1').Value := tmpCDS_dg.FieldByName('tc_sih111').Value;
            FieldByName('v2').Value := tmpCDS_dg.FieldByName('tc_sih112').Value;
            FieldByName('v3').Value := tmpCDS_dg.FieldByName('tc_sih113').Value;
            FieldByName('v4').Value := tmpCDS_dg.FieldByName('tc_sih114').Value;
            FieldByName('v5').Value := tmpCDS_dg.FieldByName('tc_sih115').Value;
            FieldByName('v6').Value := tmpCDS_dg.FieldByName('tc_sih116').Value;
            FieldByName('v7').Value := tmpCDS_dg.FieldByName('tc_sih117').Value;
            FieldByName('v8').Value := tmpCDS_dg.FieldByName('tc_sih118').Value;
            FieldByName('v9').Value := tmpCDS_dg.FieldByName('tc_sih119').Value;
          end
          else if SameText(FieldByName('src').AsString, 'gz') and tmpCDS_gz.Active and tmpCDS_gz.Locate('shb05;tc_sih02', VarArrayOf([FieldByName('wono').AsString, Copy(FieldByName('lot').AsString, 1, 10)]), []) then
          begin
            FieldByName('v1').Value := tmpCDS_gz.FieldByName('tc_sih111').Value;
            FieldByName('v2').Value := tmpCDS_gz.FieldByName('tc_sih112').Value;
            FieldByName('v3').Value := tmpCDS_gz.FieldByName('tc_sih113').Value;
            FieldByName('v4').Value := tmpCDS_gz.FieldByName('tc_sih114').Value;
            FieldByName('v5').Value := tmpCDS_gz.FieldByName('tc_sih115').Value;
            FieldByName('v6').Value := tmpCDS_gz.FieldByName('tc_sih116').Value;
            FieldByName('v7').Value := tmpCDS_gz.FieldByName('tc_sih117').Value;
            FieldByName('v8').Value := tmpCDS_gz.FieldByName('tc_sih118').Value;
            FieldByName('v9').Value := tmpCDS_gz.FieldByName('tc_sih119').Value;
          end;

          Post;
        end;

        tmpCDS.Next;
      end;
    end;

    tmpCDS_dg.Active := False;
    tmpCDS_gz.Active := False;

    //pp
    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'ftype=''PP''';
    tmpCDS.Filtered := True;
    if not tmpCDS.IsEmpty then
    begin
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''PP'' and src=''DG''';
      tmpCDS.Filtered := True;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.First;
        tmpRecno := 1;
        while tmpRecno <= tmpCDS.RecNo do
        begin
          tmpSQL := '';
          with tmpCDS do
            while not Eof do
            begin
              tmpRecno := tmpCDS.RecNo;

              if tmpSQL <> '' then
                tmpSQL := tmpSQL + ' or ';
              tmpSQL := tmpSQL + ' (tc_sia02 Like ' + Quotedstr(Copy(FieldByName('lot').AsString, 1, Length(FieldByName('lot').AsString) - 1) + '%')    //最后一碼不要
                + ' and shb05=' + Quotedstr(FieldByName('wono').AsString) + ')';
              Next;
              if (not Eof) and (tmpRecno mod cnt = 0) then
                Break;
            end;

          g_StatusBar.Panels[0].Text := '正在查詢DG物性資料' + IntToStr(tmpRecno);
          Application.ProcessMessages;
          Inc(tmpRecno);

          Data := null;
          tmpSQL := 'select shb05,tc_sia02,tc_sia171,tc_sia173,tc_sia175' + ' from tc_sia_file inner join shb_file' + ' on tc_sia01=shb01 where (' + tmpSQL + ') and shbacti=''Y''';
          if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
            Exit;
          if Data <> null then
          begin
            if tmpCDS_dg.Active then
              tmpCDS_dg.AppendData(Data, True)
            else
              tmpCDS_dg.Data := Data;
          end;
        end;
      end;

      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''PP'' and src=''GZ''';
      tmpCDS.Filtered := True;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.First;
        tmpRecno := 1;
        while tmpRecno <= tmpCDS.RecNo do
        begin
          tmpSQL := '';
          with tmpCDS do
            while not Eof do
            begin
              tmpRecno := tmpCDS.RecNo;

              if tmpSQL <> '' then
                tmpSQL := tmpSQL + ' or ';
              tmpSQL := tmpSQL + ' (tc_sia02 Like ' + Quotedstr(Copy(FieldByName('lot').AsString, 1, Length(FieldByName('lot').AsString) - 1) + '%')    //最后一碼不要
                + ' and shb05=' + Quotedstr(FieldByName('wono').AsString) + ')';
              Next;
              if (not Eof) and (tmpRecno mod cnt = 0) then
                Break;
            end;

          g_StatusBar.Panels[0].Text := '正在查詢GZ物性資料' + IntToStr(tmpRecno);
          Application.ProcessMessages;
          Inc(tmpRecno);

          Data := null;
          tmpSQL := 'select shb05,tc_sia02,tc_sia171,tc_sia173,tc_sia175' + ' from tc_sia_file inner join shb_file' + ' on tc_sia01=shb01 where (' + tmpSQL + ') and shbacti=''Y''';
          if not QueryBySQL(tmpSQL, Data, 'ORACLE1') then
            Exit;
          if Data <> null then
          begin
            if tmpCDS_gz.Active then
              tmpCDS_gz.AppendData(Data, True)
            else
              tmpCDS_gz.Data := Data;
          end;
        end;
      end;

      g_StatusBar.Panels[0].Text := '正在計算PP資料...';
      Application.ProcessMessages;
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'ftype=''PP''';
      tmpCDS.Filtered := True;
      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
        GetDiff(tmpCDS.FieldByName('c_sizes').AsString, v1, v2);

        with l_CDS2 do
        begin
          Append;
          FieldByName('indate').AsDateTime := tmpCDS.FieldByName('indate').AsDateTime;
          FieldByName('lot').AsString := tmpCDS.FieldByName('lot').AsString;
          FieldByName('c_orderno').AsString := tmpCDS.FieldByName('c_orderno').AsString;
          FieldByName('c_pno').AsString := tmpCDS.FieldByName('c_pno').AsString;
          FieldByName('c_sizes').AsString := tmpCDS.FieldByName('c_sizes').AsString;
          FieldByName('rc0').AsFloat := StrToInt(Copy(tmpCDS.FieldByName('pno').AsString, 8, 2));
          FieldByName('rc0_1').AsFloat := RoundTo(FieldByName('rc0').AsFloat + v1, -3);
          FieldByName('rc0_2').AsFloat := RoundTo(FieldByName('rc0').AsFloat - v2, -3);
          FieldByName('qty').AsFloat := tmpCDS.FieldByName('qty').AsFloat;
          FieldByName('sno').AsInteger := tmpCDS.FieldByName('sno').AsInteger;
          FieldByName('pno').AsString := tmpCDS.FieldByName('pno').AsString;
          FieldByName('wono').AsString := tmpCDS.FieldByName('wono').AsString;
          FieldByName('src').AsString := tmpCDS.FieldByName('src').AsString;

          if SameText(FieldByName('src').AsString, 'dg') and tmpCDS_dg.Active and tmpCDS_dg.Locate('shb05;tc_sia02', VarArrayOf([FieldByName('wono').AsString, Copy(FieldByName('lot').AsString, 1, Length(FieldByName('lot').AsString) - 1)]), [loPartialKey]) then
          begin
            FieldByName('rc1').Value := tmpCDS_dg.FieldByName('tc_sia171').Value;
            FieldByName('rc2').Value := tmpCDS_dg.FieldByName('tc_sia173').Value;
            FieldByName('rc3').Value := tmpCDS_dg.FieldByName('tc_sia175').Value;
          end
          else if SameText(FieldByName('src').AsString, 'gz') and tmpCDS_gz.Active and tmpCDS_gz.Locate('shb05;tc_sia02', VarArrayOf([FieldByName('wono').AsString, Copy(FieldByName('lot').AsString, 1, Length(FieldByName('lot').AsString) - 1)]), [loPartialKey]) then
          begin
            FieldByName('rc1').Value := tmpCDS_gz.FieldByName('tc_sia171').Value;
            FieldByName('rc2').Value := tmpCDS_gz.FieldByName('tc_sia173').Value;
            FieldByName('rc3').Value := tmpCDS_gz.FieldByName('tc_sia175').Value;
          end;

          Post;
        end;

        tmpCDS.Next;
      end;
    end;

  finally
    if l_CDS1.ChangeCount > 0 then
      l_CDS1.MergeChangeLog;
    if l_CDS2.ChangeCount > 0 then
      l_CDS2.MergeChangeLog;
    CDS.Data := l_CDS1.Data;
    CDS2.Data := l_CDS2.Data;
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS_360);
    FreeAndNil(tmpCDS_dg);
    FreeAndNil(tmpCDS_gz);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmDLIR230.RefreshDS(strFilter: string);
begin
  if strFilter = g_cFilterNothing then
  begin
    l_CDS1.EmptyDataSet;
    l_CDS2.EmptyDataSet;
    CDS.Data := l_CDS1.Data;
    CDS2.Data := l_CDS2.Data;
  end;

  inherited;
end;

procedure TFrmDLIR230.FormCreate(Sender: TObject);
begin
  p_SysId := 'DLI';
  p_TableName := 'DLIR230_1';
  p_GridDesignAns := False;
  l_CDS1 := TClientDataSet.Create(Self);
  l_CDS2 := TClientDataSet.Create(Self);
  InitCDS(l_CDS1, l_xml1);
  InitCDS(l_CDS2, l_xml2);

  inherited;

  TabSheet1.Caption := CheckLang('CCL');
  TabSheet20.Caption := CheckLang('PP');
  SetGrdCaption(DBGridEh2, 'DLIR230_2');
end;

procedure TFrmDLIR230.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
  CDS2.Active := False;
  DBGridEh2.Free;
end;

procedure TFrmDLIR230.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR230_query) then
    FrmDLIR230_query := TFrmDLIR230_query.Create(Application);
  if FrmDLIR230_query.ShowModal = mrOK then
  begin
    if FrmDLIR230_query.rgp.ItemIndex = 2 then
    custno := 'AC082'
  else
    custno := '';
    GetDS(FrmDLIR230_query.dtp1.Date, FrmDLIR230_query.dtp2.Date, FrmDLIR230_query.rgp.ItemIndex);
    RefreshDS('@');
  end;


end;

procedure TFrmDLIR230.btn_exportClick(Sender: TObject);
begin
  //  inherited;
  case ShowMsg('匯出CCl請按[是]' + #13#10 + '匯出PP請按[否]' + #13#10 + '[取消]無操作', 35) of
    IdYes:
      GetExportXls(CDS, 'DLIR230_1');
    IdNo:
      GetExportXls(CDS2, 'DLIR230_2');
  end;
end;

end.

