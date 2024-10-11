unit unORDR010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, StrUtils, ExtCtrls, DB,
  DBClient, MConnect, SConnect, Menus, ImgList, StdCtrls, GridsEh, DBGridEh,
  ComCtrls, ToolWin, Math, ADODB, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdMessageClient, IdSMTP, IdMessage, DBGridEhToolCtrls, DynVarsEh,
  DBAxisGridsEh;

type
  TFrmORDR010 = class(TFrmSTDI040)
    CDS2: TClientDataSet;
    ToolButton3: TToolButton;
    CDS3: TClientDataSet;
    CDSddate: TDateTimeField;
    CDSmaterialno: TWideStringField;
    CDSmaterialname: TWideStringField;
    CDSmyname: TStringField;
    CDSBu: TStringField;
    CDSIuser: TStringField;
    CDSIdate: TDateTimeField;
    CDSMuser: TStringField;
    CDSMdate: TDateTimeField;
    CDSKind: TStringField;
    CDSORD01: TStringField;
    CDSORD02: TStringField;
    CDSORD03: TStringField;
    CDSORD04: TStringField;
    CDSORD05: TStringField;
    CDSORD06: TStringField;
    CDSORD07: TStringField;
    CDSORD08: TStringField;
    CDSORD09: TStringField;
    CDSORD10: TStringField;
    CDSORD11: TStringField;
    CDSORD12: TStringField;
    CDSORD13: TStringField;
    CDSORD14: TBooleanField;
    CDSORD15: TBooleanField;
    CDSORD16: TStringField;
    CDSORD17: TStringField;
    CDSORD18: TStringField;
    CDSORD19: TStringField;
    CDSORD20: TStringField;
    CDSCombo: TStringField;
    CDSmaker: TWideStringField;
    CDSdno: TWideStringField;
    CDSditem: TIntegerField;
    CDScustname: TWideStringField;
    CDS080: TClientDataSet;
    CDSGlassCloth: TWideStringField;
    CDS040: TClientDataSet;
    CDS060: TClientDataSet;
    CDS041: TClientDataSet;
    CDScpno: TWideStringField;
    CDS090: TClientDataSet;
    CDS100: TClientDataSet;
    ToolButton4: TToolButton;
    CDScompare: TBooleanField;
    CDS110: TClientDataSet;
    CDS010: TClientDataSet;
    CDS120: TClientDataSet;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    CDS130: TClientDataSet;
    CDScompare2: TBooleanField;
    CDScustno: TWideStringField;
    IdSMTP1: TIdSMTP;
    ToolButton12: TToolButton;
    IdMessage1: TIdMessage;
    Timer2: TTimer;
    CDScompare_pp: TBooleanField;
    CDS150: TClientDataSet;
    procedure ToolButton3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure m_queryClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont:
      TFont; var Background: TColor; State: TGridDrawState);
    procedure ToolButton4Click(Sender: TObject);
    procedure DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer; Column: TColumnEh);
    procedure ToolButton10Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure ToolButton12Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    FBmb: TClientDataSet;
    l_index, l_index2, l_index3, l_indate1, l_indate2: string;
    l_halfyear, l_doNotFormat: Boolean;
    function GetMMStr(s: string): string;
    function GetCuThickness: Currency;
    procedure GetBmb;
    procedure SetToolBarVisible;
    procedure SetDefaultValues; //ITEQ通用設置
    procedure WhenHint(Sender: TObject);
  public
    procedure RefreshDS(strFilter: string); override;
    { Public declarations }
  end;

var
  FrmORDR010: TFrmORDR010;
  CDS090Located: Boolean;

implementation

uses
  unGlobal, unCommon, unORDR010_Query;

const
  DO_NOT_CHECK_FIRST_CODE =
    'AC082,AC093,AC101,AC109,AC111,AC526,AC820,ACA97,AI002,AK001,AM007,BS004,EI001,EI004,EI015,EI033,EI036,EI044,US005';
{$R *.dfm}

function TFrmORDR010.GetMMStr(s: string): string;
var
  sl: TStringList;
  i: integer;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := ' ';
    sl.DelimitedText := s;
    for i := 0 to sl.Count - 1 do
      if Pos('MM', UpperCase(sl[i])) > 0 then
        result := sl[i];
  finally
    sl.free;
  end;
end;

procedure TFrmORDR010.WhenHint(Sender: TObject);
begin
  g_StatusBar.Panels[0].Text := Application.Hint;
end;

procedure TFrmORDR010.GetBmb;
var
  tmpStr: string;
  data: OleVariant;
begin
  if Assigned(FBmb) then
    FBmb.Free;
  fbmb := TClientDataSet.Create(nil);
  try
    CDS.DisableControls;
    CDS.First;
    tmpStr := '(';
    while not CDS.Eof do
    begin
      if Pos('13', CDS.fieldbyname('combo').AsString) > 0 then
      begin
        tmpStr := tmpStr + '(bmb01=' + quotedstr(CDS.fieldbyname('materialno').AsString)
          + ') or ';
      end;
      CDS.next;
    end;
    tmpStr := 'select bmb01,bmb03,round(bmb06/bmb20)pcs from ' + g_uinfo^.BU +
      '.bmb_file where (bmb05>=sysdate or bmb05 is null) and trim(bmb10)=''M'' and ' +
      tmpStr + '(1=2))  order by bmb02';
    if QueryBySQL(Conn, tmpStr, 'ORACLE', data) then
      FBmb.data := data;
    FBmb.Filtered := true;
  finally
    CDS.First;
    CDS.EnableControls;
  end;
end;

function DRound(const Value: string; Digit: Byte = 0; const AddValue: Extended =
  0): string;    //英制轉公制
var
  tmp, tmpResult, tmpValue, tmpValue2: Extended;
  Digit2: Byte;
begin
  if Digit > 10 then
    Digit2 := Digit mod 10
  else
    Digit2 := 0;
  if Digit > 10 then
    Digit := Digit div 10;
  tmp := Power(10, Digit);
  tmpValue := StrToFloatDef(Value, 0);
  if FrmORDR010.CDS.FieldByName('ord05').asstring = '"' then
    tmpValue2 := 0.001
  else
    tmpValue2 := 1;
  if tmpValue > 0 then
    tmpResult := tmpValue / 10 * tmp + AddValue * tmpValue2 * tmp + 0.5
  else
    tmpResult := tmpValue / 10 * tmp + AddValue * tmpValue2 * tmp - 0.5;
  tmpResult := Trunc(tmpResult) / tmp;
  if FrmORDR010.l_DoNotFormat then
    Result := FloatToStr(tmpResult)    //2016/3/9加入
  else
    Result := format('%.*f', [Digit, tmpResult]);
  if (Digit2 > 0) and (Result >= '1') then
  begin
    Result := DRound(Value, Digit2, AddValue);
  end;
end;

function DRound2(const Value: string; Digit: Byte = 0; const AddValue: Extended
  = 0): string;    //英制轉公制
var
  tmp, tmpResult, tmpValue: Extended;
  Digit2: Byte;
begin
//  ShowMessage(Value+'*'+inttostr(Digit)+'*'+FloatToStr(AddValue));
  if Digit > 10 then
    Digit2 := Digit mod 10
  else
    Digit2 := 0;
  if Digit > 10 then
    Digit := Digit div 10;
  if (FrmORDR010.CDS.FieldByName('custno').AsString = 'AC111') and (AddValue <>
    0) and AnsiMatchStr(FrmORDR010.CDS.FieldByName('ord09').AsString, ['H/H',
    '2/1', '2/H', 'SH/SH', 'S2/S1', 'S2/SH']) then
  begin
    Digit := 3;
  end;
  tmp := Power(10, Digit);
  tmpValue := StrToFloatDef(Value, 0);
  if tmpValue > 0 then
    tmpResult := tmpValue / 100000 * 254 * tmp + AddValue * tmp + 0.5
  else
    tmpResult := tmpValue / 100000 * 254 * tmp + AddValue * tmp - 0.5;
  tmpResult := Trunc(tmpResult) / tmp;
  Result := format('%.*f', [Digit, tmpResult]);
  if (Digit2 > 0) and (Result >= '1') then
  begin
    Result := DRound2(Value, Digit2, AddValue);
  end;
end;

function Replace(const s: string): string;
begin
  result := StringReplace(s, '公制', '', []);
  result := StringReplace(result, '英制', '', []);
  result := StringReplace(result, '+', '', []);
  result := StringReplace(result, '位小數', '', []);
  result := StringReplace(result, '(大於等於1.0為', '', []); //標記
  result := StringReplace(result, '位)', '', []); //標記
end;

function Get060: string;
var
  tn: Currency;
begin

  result := '';

  with FrmORDR010 do
  begin
    tn := strtofloatdef(Copy(CDS.fieldbyname('materialno').AsString, 3, 4), 0) / 10;
    CDS060.Filtered := True;
    if CDS060.Locate('custno', CDS.fieldbyname('custno').AsString, []) then
      CDS060.Filter := 'custno=' + quotedstr(CDS.fieldbyname('custno').AsString)
    else
      CDS060.Filter := '';
    CDS060.First;
    while not CDS060.Eof do
    begin
      if (CDS060.fieldbyname('thickness1').asCurrency <= tn) and (CDS060.fieldbyname
        ('thickness2').asCurrency >= tn) then
      begin
        if CDS090Located and (FrmORDR010.CDS090.FieldByName('Tolerances').AsString
          = 'Y') then
          result := '±' + CDS060.fieldbyname('class' + rightstr(CDS.FieldByName
            ('ord08').AsString, 1)).asstring
        else if CDS090Located and (FrmORDR010.CDS090.FieldByName('Tolerances').AsString
          = 'N') then
          result := ''
        else
          result := '±' + CDS060.fieldbyname('class' + rightstr(CDS.FieldByName
            ('ord08').AsString, 1)).asstring;
        Break;
      end;
      CDS060.next;
    end;
  end;
end;

function BuildStruct(s: string): string;
var
  num: Integer;
  code, tmpNum, firstNum: string;
begin
  result := '';
  code := '';
  tmpNum := '';
  num := 0;
  with FrmORDR010 do
  begin
    while Length(s) > 0 do
    begin
      if s[1] in ['0'..'9'] then
        tmpNum := tmpNum + s[1]
      else
      begin
        if code <> s[1] then
        begin
          if code <> '' then
          begin
            result := result + BuildStruct(firstNum + s);
            EXIT;
          end
          else
          begin
            code := s[1];
            num := StrToIntDef(tmpNum, 0);
            result := IntToStr(num) + s[1];
          end;
        end
        else
        begin
          num := num + StrToIntDef(tmpNum, 0);
          result := IntToStr(num) + s[1];
        end;
        tmpNum := '';
      end;
      firstNum := s[1];
      Delete(s, 1, 1);
    end;
  end;
end;

function BuildStruct2(s: string): string;
var
  i: Integer;
  code, tmpNum, tmpStr: string;
  list, list2: TStringlist;

  procedure addtolist2(s: string);
  var
    i: Integer;
    founded: boolean;
  begin
    if list2.count = 0 then
      list2.text := s
    else
    begin
      founded := false;
      for i := 0 to list2.Count - 1 do
      begin
        if Copy(list2[i], 1, Pos('*', list2[i]) - 1) = Copy(s, 1, Pos('*', s) - 1) then
        begin
          list2[i] := Copy(list2[i], 1, Pos('*', list2[i]) - 1) + '*' + inttostr
            (strtointdef(Copy(list2[i], Pos('*', list2[i]) + 1, 255), 0) +
            strtointdef(Copy(s, Pos('*', s) + 1, 255), 0));
          founded := True;
          break;
        end;
      end;
      if not founded then
        list2.Append(s);
    end;

  end;

begin
  result := '';
  code := '';
  tmpNum := '';
  list := TStringList.Create;
  list2 := TStringList.Create;
  try
    list.Delimiter := '+';
    list.DelimitedText := s;
    if list.Count = 0 then
      exit;
    for i := 0 to list.count - 1 do
      addtolist2(list[i]);
    tmpStr := StringReplace(list2.text, #10, '+', []);
    result := copy(tmpStr, 1, length(tmpStr) - 2);
  finally
    list.Free;
    list2.free;
  end;
end;

procedure TFrmORDR010.RefreshDS(strFilter: string);
var
  tmpSQL, tmpCustno, tmpMaker, tmpDno: string;
  Data: OleVariant;
begin

  if Pos(',', l_index) > 0 then
    tmpCustno := ' and oea04 in (''''' + StringReplace(l_index, ',', ''''',''''',
      [rfReplaceAll]) + ''''')'
  else if l_index <> '' then
    tmpCustno := ' and oea04=''''' + l_index + ''''''
  else
    tmpCustno := '';

  if l_index2 <> '' then
    tmpDno := ' and oea01=''''' + l_index2 + ''''''
  else
    tmpDno := '';
  if l_index3 <> '' then
    tmpMaker := ' and gen02=''''' + l_index3 + ''''''
  else
    tmpMaker := '';
//  if l_halfyear then
//    tmpsql2:=' and oea02>=sysdate-180 '
//  else
//    tmpsql2:=' and oea02 between to_date('''''+l_indate2+''''',''''YYYY/MM/DD'''') and to_date('''''+l_indate1+''''',''''YYYY/MM/DD'''')  ';


  try
    CDS.DisableControls;                                                                          //ta_oeb05玻布代碼
                                                                                                                                                                                                         //客戶料號
    tmpSQL := 'select * into ##ORDR010' + g_uinfo^.UserId +
      ' from openquery(iteqdg,''select distinct ta_oeb05 GlassCloth,oea02 ddate,oea04 custno,occ02 custname,oeb01 dno,oeb03 ditem,oeb04 materialno,oeb11 cpno,ta_oeb10 materialname,gen02 maker ' +
      //,oao06 memo '+
      ' from oea_file inner join oeb_file on oea01=oeb01 left join gen_file on oeauser=gen01 left join occ_file on oea04=occ01 '
      + //left join oao_file on oao01=oeb01 '+
      '  where oea03 not in (''''N012'''',''''N005'''') and oea04 not like ''''N%'''' and length(ta_oeb10)>0 '
      + tmpCustno + tmpDno + tmpMaker + ' and oea02 between to_date(''''' +
      l_indate1 + ''''',''''YYYY/MM/DD'''') and to_date(''''' + l_indate2 +
      ''''',''''YYYY/MM/DD'''')  ' + ''')';
    tmpSQL := tmpSQL + 'insert into ##ORDR010' + g_uinfo^.UserId +
      ' select * from openquery(iteqdg,''select distinct ta_oeb05 GlassCloth,oea02 ddate,oea04 custno,occ02 custname,oeb01 dno,oeb03 ditem,oeb04 materialno,oeb11 cpno,ta_oeb10 materialname,gen02 maker ' +
      //,oao06 memo '+
      ' from iteqgz.oea_file inner join iteqgz.oeb_file on oea01=oeb01 left join iteqgz.gen_file on oeauser=gen01 left join iteqgz.occ_file on oea04=occ01 '
      + //left join oao_file on oao01=oeb01 '+
      '  where oea03 not in (''''N012'''',''''N005'''') and oeb04 not like ''''F%'''' and length(ta_oeb10)>0 '
      + tmpCustno + tmpDno + tmpMaker + ' and oea02 between to_date(''''' +
      l_indate1 + ''''',''''YYYY/MM/DD'''') and to_date(''''' + l_indate2 +
      ''''',''''YYYY/MM/DD'''')  ' + ''')';
//    ShowMessage(tmpSQL);//tmpSQL
    PostBySQL(Conn, tmpSQL, g_mssql);
    tmpSQL := 'Select * from ##ORDR010' + g_uinfo^.UserId +
      ' a left join ord010 b on a.custno=b.custno order by a.custno,a.dno,a.ditem ';

    if QueryBySQL(Conn, tmpSQL, g_mssql, Data) then
    begin
      CDS.Data := Data;
      tmpSQL := 'drop table ##ORDR010' + g_uinfo^.UserId + '; Select 1';
      QueryBySQL(Conn, tmpSQL, g_mssql, Data);
      SetDefaultValues;
//      if CDS.Active and (not CDS.IsEmpty) then
      ToolButton3Click(nil);
    end;

  finally
    if CDS.Active then
      CDS.first;
    CDS.EnableControls;
  end;
//  inherited;
end;

procedure TFrmORDR010.SetDefaultValues;
var
  i: integer;
  ls: TStringList;
  Data: OleVariant;
  tmpStr: string;
  tmpCDS: TClientDataSet;
begin
  ls := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  CDS.DisableControls;
  try
    tmpStr := 'select * from ord010 where custno =' + quotedstr('ITEQ');
    if QueryBySQL(Conn, tmpStr, g_mssql, Data) then
      tmpCDS.Data := Data;

    for i := 0 to tmpCDS.FieldCount - 1 do
      ls.Add(tmpCDS.Fields[i].FieldName + '=' + tmpCDS.Fields[i].AsString);

    CDS.First;
    while not CDS.Eof do
    begin
      if CDS.FieldByName('combo').asString = '' then
      begin
        CDS.edit;
        for i := 0 to ls.count - 1 do
          if (not SameText(ls.Names[i], 'custno')) and (not SameText(ls.Names[i],
            'custname')) then
            CDS.FieldByName(ls.Names[i]).AsString := ls.ValueFromIndex[i];
      end;
      {if AnsiMatchStr(CDS.FieldByName('custno').asString,['N012','N005']) then
      begin
        if CDS010.Locate('custno',CDS.fieldbyname('custno').AsString,[]) then
        begin
          for i:=0 to CDS010.FieldCount-1 do
          begin
            if (CDS010.Fields[i].FieldName='combo') or (Pos('ORD',CDS010.Fields[i].FieldName)=1) then
            begin
              CDS.edit;
              CDS.FieldByName(CDS010.Fields[i].FieldName).asString:=CDS010.Fields[i].AsString;
            end;
          end;
        end;
      end; }
      CDS.next;
    end;
  finally
    CDS.enableControls;
    tmpCDS.Free;
    ls.Free;
  end;
end;

function TFrmORDR010.GetCuThickness: Currency;
var
  kind: string;
begin
  Result := 0;

  if (Copy(CDS.fieldbyname('materialno').AsString, 16, 1) = 'R') or (Copy(CDS.fieldbyname
    ('materialno').AsString, 16, 1) = 'I') then
    CDS040.Filter := 'curi<>0'
  else
    CDS040.Filter := 'curi=0';
  CDS040.Filtered := True;

  if Pos('公制', CDS.FieldByName('ord04').AsString) > 0 then
    kind := 'mm'
  else
    kind := 'mil';

  //BOOLEAN LOCATE 32位下不正常
  if CDS040.Locate('bu;custno;cucode', VarArrayOf([g_UInfo^.BU, CDS.fieldbyname('custno').AsString,
    Copy(CDS.fieldbyname('materialno').AsString, 7, 1)]), []) then
  begin
    Result := CDS040.fieldbyname(kind).AsCurrency;
  end
  else if CDS040.Locate('bu;custno;cucode', VarArrayOf([g_UInfo^.BU, '', Copy(CDS.fieldbyname
    ('materialno').AsString, 7, 1)]), []) then
  begin
    Result := CDS040.fieldbyname(kind).AsCurrency;
  end;

  if CDS040.Locate('bu;custno;cucode', VarArrayOf([g_UInfo^.BU, CDS.fieldbyname('custno').AsString,
    Copy(CDS.fieldbyname('materialno').AsString, 8, 1)]), []) then
  begin
    Result := Result + CDS040.fieldbyname(kind).AsCurrency;
  end
  else if CDS040.Locate('bu;custno;cucode', VarArrayOf([g_UInfo^.BU, '', Copy(CDS.fieldbyname
    ('materialno').AsString, 8, 1)]), []) then
  begin
    Result := Result + CDS040.fieldbyname(kind).AsCurrency;
  end;
//  ShowMessage(FloatToStr(result));
  CDS040.Filtered := false;
end;

procedure TFrmORDR010.ToolButton3Click(Sender: TObject);
var
  tmpStr, tmpStr2{結構碼}, tmpRI, tmpCuCodeL, tmpCuCodeR, no7, no8, compare1,
    compare2, ord12: string;
  mname, ord12tmp, ml, nm: string;  //紅底白字排序
  s1, s2, s3, s7, s8, s10, s16, sLast: Char;
  IncCu, IsWY, IsPP, IsCCl, toCheck: Boolean;
  tmpList: TStringList;
  i, tmpDigit{小數位數}: integer;
  wan: Double;

  procedure FilterOrd130;
  begin
    CDS130.Filtered := true;
    CDS130.Filter := ' bu=''ITEQDG'' and custno like ' + quotedstr('%' + CDS.FieldByName
      ('custno').AsString + '%') +
//                   ' and sno like '+ quotedstr('%'+Copy(CDS.FieldByName('materialno').AsString, 2, 7)+'%')+
      ' and sno = ' + quotedstr(copy(CDS.FieldByName('materialno').AsString, 1,
      16)) + ' and cust_pno like ' + quotedstr('%' + CDS.FieldByName('cpno').AsString
      + '%');
//    if CDS130.RecordCount=0 then
//      CDS130.Filter:=' bu=''ITEQDG'' and custno like '+quotedstr('%'+CDS.FieldByName('custno').AsString+'%')+
//                   ' and cust_pno like ' +quotedstr('%'+CDS.FieldByName('cpno').AsString+'%');
    if CDS130.RecordCount > 0 then
    begin
      CDS.FieldByName('myname').Value := CDS130.FieldByName('cust_pname').asstring;
      if StringReplace(CDS.FieldByName('materialname').asstring, ' ', '', [rfReplaceAll])
        <> StringReplace(CDS.FieldByName('myname').asstring, ' ', '', [rfReplaceAll]) then
      begin
        if (trim(CDS.FieldByName('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString))
          then
          CDS.FieldByName('compare2').Value := true;
//        CDS.next;
//        Continue;
      end;
    end;
  end;

begin
  inherited;

  GetBmb; //需要計算結構碼的料號列表
  CDS.First;
  while not CDS.Eof do
  begin
    CDS.edit;
//    CDS.FieldByName('materialname').asstring:=              'IT180IBS 2116 RC:60% 473MM*387MM緯';
//    if CDS130.Locate('bu;custno;sno;cust_pno', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
//      ('custno').AsString, Copy(CDS.FieldByName('materialno').AsString, 2, 7),
//      CDS.FieldByName('cpno').AsString]), [loPartialKey]) then
//    begin
//      CDS.FieldByName('myname').value := CDS130.FieldByName('cust_pname').asstring;
//      CDS.next;
//      Continue;
//    end
//    else if CDS130.Locate('bu;custno;cust_pno', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
//      ('custno').AsString, CDS.FieldByName('cpno').AsString]), [loPartialKey]) then
//    begin
//      CDS.FieldByName('myname').value := CDS130.FieldByName('cust_pname').asstring;
//      CDS.next;
//      Continue;
//    end;


    FilterOrd130;    //進行兩次

    ml := CDS.fieldbyname('materialno').asstring;
    nm := CDS.fieldbyname('materialname').asstring;
    s1 := Char(ml[1]);
    s2 := Char(ml[2]);
    s3 := Char(ml[3]);
    s7 := Char(ml[7]);
    s8 := Char(ml[8]);
    s10 := Char(ml[10]);
    sLast := Char(Copy(ml, Length(ml), 1)[1]);
    IsCCl := s1 in ['E', 'T'];

    if ((Pos('含銅', CDS.FieldByName('materialname').asstring) > 0) and (Pos('含銅',
      CDS.FieldByName('myname').asstring) > 0)) and (((Pos('不含銅', CDS.FieldByName
      ('materialname').asstring) > 0) and (Pos('不含銅', CDS.FieldByName('myname').asstring)
      = 0)) or ((Pos('不含銅', CDS.FieldByName('materialname').asstring) = 0)
      and (Pos('不含銅', CDS.FieldByName('myname').asstring) > 0))) then
    begin
      if (GetMMStr(CDS.FieldByName('materialname').asstring) = GetMMStr(CDS.FieldByName
        ('myname').asstring)) and (trim(CDS.FieldByName('myname').AsString) <>
        trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true;
    end;
    if ((Pos('mm', CDS.FieldByName('materialname').asstring) > 0) or (Pos('MM',
      CDS.FieldByName('materialname').asstring) > 0)) and (Pos('"', CDS.FieldByName
      ('materialname').asstring) > 0) then
    begin
      if (GetMMStr(CDS.FieldByName('materialname').asstring) = GetMMStr(CDS.FieldByName
        ('myname').asstring)) and (trim(CDS.FieldByName('myname').AsString) <>
        trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true;
    end;
//    ShowMessage(s7+'/'+s8+'   '+CDS.FieldByName('materialname').asstring);
    if IsCCl and (Pos(s7 + '/' + s8, CDS.FieldByName('materialname').asstring) =
      0) and (Pos(s8 + '/' + s7, CDS.FieldByName('materialname').asstring) = 0)
      and (trim(CDS.FieldByName('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString))
      then
    begin
      CDS.FieldByName('compare2').Value := true;
    end;
    if s3 = '3' then
    begin
      if (Pos('CAFC', CDS.FieldByName('materialname').asstring) = 0) and (trim(CDS.FieldByName
        ('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true;
    end
    else if s3 = '6' then
    begin
      if (Pos('CAFB', CDS.FieldByName('materialname').asstring) = 0) and (trim(CDS.FieldByName
        ('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true
    end
    else if s3 in ['K', 'L'] then
    begin
      if (Pos('LDPP', CDS.FieldByName('materialname').asstring) = 0) and (trim(CDS.FieldByName
        ('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true;
    end
    else if s3 in ['C', 'H', 'I', 'J', 'N', 'S', 'T', 'U', 'V'] then
    begin
      if (Pos('CAF', CDS.FieldByName('materialname').asstring) = 0) and (trim(CDS.FieldByName
        ('myname').AsString) <> trim(CDS.FieldByName('materialname').AsString)) then
        CDS.FieldByName('compare2').Value := true;
    end;

    if Length(ml) = 17 then
      s16 := Char(ml[16])
    else
      s16 := ' ';
    toCheck := Pos(CDS.fieldbyname('custno').AsString, DO_NOT_CHECK_FIRST_CODE) = 0;
    IsPP := (Char(ml[1]) in ['R', 'B', 'N', 'M', 'Q']);
    if IsPP then
    begin
      if CDS150.Locate('FirstCode;LastCode', VarArrayOf([s2, sLast]), [loPartialKey]) then
      begin             //注意應是第二碼  膠系檢查
        if Pos(CDS150.fieldbyname('PName').AsString, nm) = 0 then
        begin
          CDS.FieldByName('compare2').Value := true;
          CDS.next;
          Continue;
        end;
      end;
      if Pos(copy(CDS.FieldByName('materialno').asstring, 1, 1), 'RB') > 0 then   //大料
      begin
        if Pos(copy(CDS.FieldByName('materialno').asstring, 1, 1), 'RBNMQ') = 0
          then  //非PP
        begin
          {       改為針對全部料號 161021范鳳香郵件
          if copy(CDS.FieldByName('materialno').asstring, 3, 1) = '3' then
          begin
            if Pos('CAFC', CDS.FieldByName('materialname').asstring) = 0 then
              CDS.FieldByName('compare2').value := true;
          end
          else if copy(CDS.FieldByName('materialno').asstring, 3, 1) = '6' then
          begin
            if Pos('CAFB', CDS.FieldByName('materialname').asstring) = 0 then
              CDS.FieldByName('compare2').value := true
          end
          else if Pos(copy(CDS.FieldByName('materialno').asstring, 3, 1), 'KL') > 0 then
          begin
            if Pos('LDPP', CDS.FieldByName('materialname').asstring) = 0 then
              CDS.FieldByName('compare2').value := true;
          end
          else if Pos(copy(CDS.FieldByName('materialno').asstring, 3, 1),
            'CHIJNSTUV') > 0 then
          begin
            if Pos('CAF', CDS.FieldByName('materialname').asstring) = 0 then
              CDS.FieldByName('compare2').value := true;
          end;
          }
        end;

        if Pos(Copy(CDS.FieldByName('materialno').asstring, 11, 3), CDS.FieldByName
          ('materialname').asstring) = 0 then
          CDS.FieldByName('compare2').Value := true;
      end;
      if (s1 in ['R', 'N', 'B', 'M']) and toCheck then      //第一碼
      begin
        if (Pos('BS', nm) = 0) and (trim(CDS.FieldByName('myname').AsString) <>
          trim(CDS.FieldByName('materialname').AsString)) then
        begin
          CDS.FieldByName('compare2').Value := true;
          CDS.next;
          Continue;
        end;
      end;
    end
    else
    begin
      if (s1 in ['E', 'T']) and toCheck then                  //第一碼
      begin
        if Pos('TC', nm) = 0 then
        begin
          CDS.FieldByName('compare2').Value := true;
          CDS.next;
          Continue;
        end;
      end;
    end;
    if Length(ml) = 11 then
    begin
      if s10 = 'C' then
      begin
        if Pos('RTF', nm) > 0 then
          CDS.FieldByName('compare2').Value := true;
        if Pos('CAF', nm) = 0 then
          CDS.FieldByName('compare2').Value := true;
      end
      else if s10 = 'I' then
      begin
        if (Pos('CAF', nm) = 0) and (Pos('RTF', nm) = 0) then
          CDS.FieldByName('compare2').Value := true;
      end;
      CDS.next;
      Continue;
    end
    else
    begin
      if s16 = 'C' then
      begin
        if (Pos('RTF', nm) > 0) or (Pos('CAF', nm) = 0) then
        begin
          CDS.FieldByName('compare2').Value := true;
          CDS.next;
          Continue;
        end;
      end
      else if s16 = 'I' then
      begin
        if (Pos('CAF', nm) = 0) and (Pos('RTF', nm) = 0) then
        begin
          CDS.FieldByName('compare2').Value := true;
          CDS.next;
          Continue;
        end;
      end;
    end;
    if Length(ml) <> 17 then
    begin
      CDS.next;
      Continue;
    end;

    if IsPP{Length(ml) <> 17} then    //2016/7/14
    begin
//      showmessage('hi');
      IsWY := AnsiMatchText(CDS.fieldbyname('custno').asstring, ['AC093',
        'AC394', 'AC844', 'AC152']);
      if {IsPP and}  (not IsWY) then  {排除慧亞}
      begin
        cds.edit;
        cds.FieldByName('compare_pp').AsBoolean := ((copy(ml, 2, 1) = 'F') and (Pos
          ('IT180A', nm) = 0) and (Pos('IT-180A', nm) = 0)) or ((copy(ml, 7, 2)
          = 'HH') and (Pos('H/H', nm) = 0)) or ((copy(ml, 16, 1) = 'C') and (Pos
          ('CAF', nm) = 0)) or ((copy(ml, 16, 1) = 'I') and (Pos('CAF', nm) = 0)
          and (Pos('RTF', nm) = 0)) or ((copy(ml, 16, 1) = 'R') and (Pos('RTF',
          nm) = 0)) or ((copy(ml, 16, 1) = '3') and (Pos('CAFC', nm) = 0));
      end;
//      else
      if IsPP then
      begin
//        ShowMessage(CDS.fieldbyname('materialno').asstring);
        if Pos('M*', UpperCase(nm)) = 0 then
        begin
          CDS.edit;
          cds.FieldByName('compare_pp').AsBoolean := True;
        end;
      end;
      CDS.next;
      Continue;
    end;
    if IsPP or (Length(ml) < 17) then
    begin
      CDS.Next;
      Continue;
    end;

    CDS.edit;

    IncCu := false;
    tmpStr := Copy(CDS.fieldbyname('materialno').AsString, 3, 4);
    no7 := Copy(CDS.fieldbyname('materialno').asstring, 7, 1);
    no8 := Copy(CDS.fieldbyname('materialno').asstring, 8, 1);
    tmpDigit := StrToIntDef(REPLACE(CDS.FieldByName('ord04').AsString), 0); //小數位數
    //ord03
    if CDS2.Locate('bu;custno;glueid', VarArrayOf([g_UInfo^.BU, CDS.fieldbyname('custno').AsString,
      Copy(CDS.fieldbyname('materialno').AsString, 2, 1)]), []) then
    begin
      if CDS.FieldByName('ord03').AsString = 'IT&對應膠系別' then
        CDS.FieldByName('ord03').AsString := 'IT' + CDS2.fieldbyname('gluename').AsString
      else if CDS.FieldByName('ord03').AsString = '(IT&對應膠系別)' then
        CDS.FieldByName('ord03').AsString := '(IT' + CDS2.fieldbyname('gluename').AsString
          + ')';
    end
    else if CDS2.Locate('bu;glueid', VarArrayOf([g_uinfo^.bu, Copy(CDS.fieldbyname
      ('materialno').AsString, 2, 1)]), []) then
    begin
      if CDS.FieldByName('ord03').AsString = 'IT&對應膠系別' then
        CDS.FieldByName('ord03').AsString := 'IT' + CDS2.fieldbyname('gluename').AsString
      else if CDS.FieldByName('ord03').AsString = '(IT&對應膠系別)' then
        CDS.FieldByName('ord03').AsString := '(IT' + CDS2.fieldbyname('gluename').AsString
          + ')';
    end;
    //2016/3/21
    if (Copy(CDS.FieldByName('materialno').AsString, 2, 1) = 'J') and (Char(RightStr
      (CDS.FieldByName('materialno').AsString, 1)[1]) in ['E', 'e', 'L', '3']) then
      CDS.FieldByName('ord03').AsString := 'IT150GS'
    else if (Copy(CDS.FieldByName('materialno').AsString, 2, 1) = 'L') and (RightStr
      (CDS.FieldByName('materialno').AsString, 1) = 'G') then
      CDS.FieldByName('ord03').AsString := 'IT150GL1'
    else if (Copy(CDS.FieldByName('materialno').AsString, 2, 1) = 'U') and (RightStr
      (CDS.FieldByName('materialno').AsString, 1) = '3') then
      CDS.FieldByName('ord03').AsString := 'IT170GRA'
    else if (Copy(CDS.FieldByName('materialno').AsString, 2, 1) = 'U') and (RightStr
      (CDS.FieldByName('materialno').AsString, 1) = 'X') then
      CDS.FieldByName('ord03').AsString := 'IT170GRA1';
    //2016/3/21
    if (CDS.FieldByName('custno').AsString = 'AC111') and (CDS.FieldByName('ord02').AsString
      = 'FR4.0') and (AnsiMatchStr(CDS.FieldByName('ord03').AsString, ['IT150GL1',
      'IT150GS', 'IT170GRA1'])) then
      CDS.FieldByName('ord02').AsString := 'FR4.1';

    //ord05   先於ORD04處理  //
    if (CDS.FieldByName('ord05').AsString = '"') or (Pos('IN', CDS.FieldByName('ord05').AsString)
      > 0) then
      wan := 0.001
    else
      wan := 1;
    if CDS.FieldByName('ord05').AsString = 'INCH(不顯示)' then
      CDS.FieldByName('ord05').AsString := '';


    //ord10需前置ORD09處理     後面有 //ord10 //ord11
                           //R銅I銅判定
    if (CDS.FieldByName('ord10').AsString = 'S') and ((Copy(CDS.FieldByName('materialno').AsString,
      16, 1) = 'R') or (Copy(CDS.FieldByName('materialno').AsString, 16, 1) = 'I')) then
      tmpRI := 'S'
    else
      tmpRI := '';
    if CDS.FieldByName('ord10').AsString = 'S' then
      CDS.FieldByName('ord10').AsString := '';
    if (CDS.FieldByName('ord10').AsString = 'RTF') and (CDS.FieldByName('custno').AsString
      <> 'AC111') and ((Copy(CDS.FieldByName('materialno').AsString, 16, 1) <>
      'R') and (Copy(CDS.FieldByName('materialno').AsString, 16, 1) <> 'I')) then
      CDS.FieldByName('ord10').AsString := '';

    //ord09
    tmpCuCodeL := '';
    tmpCuCodeR := '';
    if tmpRI = 'S' then  //start filtering
    begin
      CDS040.Filter := 'curi<>0';
      CDS041.Filter := 'curi<>0';
      CDS040.Filtered := True;
      CDS041.Filtered := True;
    end;
    //if CDS.FieldByName('custno').AsString='AC820'
    if AnsiMatchStr(CDS.fieldbyname('custno').AsString, ['EI015', 'EI033',
      'EI044', 'EI004', 'EI022']) and CDS040.Locate('custno;cucode', VarArrayOf([CDS.fieldbyname
      ('custno').asstring, no7]), []) then
      tmpCuCodeL := FloatToStr(strtofloatdef(CDS040.fieldbyname('mm').AsString,
        0) * 1000)   //注意下面是041
    else if CDS041.Locate('custno;cucode', VarArrayOf([CDS.fieldbyname('custno').asstring,
      no7]), []) then
      tmpCuCodeL := CDS041.fieldbyname('memo').AsString
    else
      tmpCuCodeL := no7;

    if AnsiMatchStr(CDS.fieldbyname('custno').AsString, ['EI015', 'EI033',
      'EI044', 'EI004', 'EI022']) and CDS040.Locate('custno;cucode', VarArrayOf([CDS.fieldbyname
      ('custno').asstring, no8]), []) then
      tmpCuCodeR := FloatToStr(strtofloatdef(CDS040.fieldbyname('mm').AsString,
        0) * 1000)    //注意下面是041
    else if CDS041.Locate('custno;cucode', VarArrayOf([CDS.fieldbyname('custno').asstring,
      no8]), []) then
      tmpCuCodeR := CDS041.fieldbyname('memo').AsString
    else
      tmpCuCodeR := no8;

    CDS040.Filtered := false;
    CDS041.Filtered := false;
    //end filtering


    if CDS.FieldByName('ord09').AsString = '薄銅/厚銅' then
      CDS.FieldByName('ord09').AsString := tmpRI + tmpCuCodeR + '/' + tmpRI + tmpCuCodeL
    else if CDS.FieldByName('ord09').AsString = '厚銅/薄銅' then
      CDS.FieldByName('ord09').AsString := tmpRI + tmpCuCodeL + '/' + tmpRI + tmpCuCodeR;

    if CDS.FieldByName('ord09').AsString = '/' then
      CDS.FieldByName('ord09').AsString := '';

    //ord04     //ord07里有再次處理
    if Pos('英制', CDS.FieldByName('ord04').AsString) > 0 then
    begin
      l_DoNotFormat := (CDS.FieldByName('ord04').AsString = '英制+1位小數') and
        (CDS.FieldByName('ord05').AsString = 'MIL');
      if (CDS.FieldByName('ord04').AsString = '英制+0位小數') and (CDS.FieldByName
        ('ord05').AsString = 'MIL') and ((StrToInt(tmpStr) mod 10) > 0) then// ;//2016/3/18
      begin
//         ShowMessage(FloatToStr(StrToInt(tmpStr)/10.0)+';'+FloatToStr(StrToInt(tmpStr)/10.0+ GetCuThickness) );
        CDS.FieldByName('ord04').AsString := FloatToStr(StrToInt(tmpStr) / 10.0)
          + ';' + FloatToStr(StrToInt(tmpStr) / 10.0 + GetCuThickness)             // ;//2016/3/18
      end
      else
      begin
//         ShowMessage(DRound(floattostr(StrToInt(tmpStr)*wan),tmpDigit)+';'+DRound(floattostr(StrToInt(tmpStr)*wan),tmpDigit,GetCuThickness));                                                                                                                                 // ;//2016/3/18
        CDS.FieldByName('ord04').AsString := DRound(floattostr(StrToInt(tmpStr)
          * wan), tmpDigit) + ';' + DRound(floattostr(StrToInt(tmpStr) * wan),
          tmpDigit, GetCuThickness);
      end;
    end
    else if Pos('公制', CDS.FieldByName('ord04').AsString) > 0 then
    begin
//      ShowMessage(DRound2(tmpStr,tmpDigit)+';'+DRound2(tmpStr,tmpDigit,GetCuThickness)+';'+floattostr(GetCuThickness));
      CDS.FieldByName('ord04').AsString := DRound2(tmpStr, tmpDigit) + ';' +
        DRound2(tmpStr, tmpDigit, GetCuThickness);
    end;  //

//    if CDS.FieldByName('custno').AsString='AC004' then
//    begin
//      CDS.FieldByName('ord04').AsString:=Copy(CDS.FieldByName('ord04').AsString,Pos(';',CDS.FieldByName('ord04').AsString)+1,255)+';'+Copy(CDS.FieldByName('ord04').AsString,1,Pos(';',CDS.FieldByName('ord04').AsString)-1);
//    end;
    //測試順序改變
//    if CDS090.Locate('bu;custno;sno;cust_pno',VarArrayOf([g_UInfo^.BU,CDS.FieldByName('custno').AsString,Copy(CDS.FieldByName('materialno').AsString,2,7),CDS.FieldByName('cpno').AsString]),[]) then
//    begin
//      if StrToFloatdef(CDS090.FieldByName('exccu').Asstring,0)<>0 then
//         CDS.FieldByName('ord04').AsString:=CDS090.FieldByName('exccu').AsString+';'+copy(CDS.FieldByName('ord04').AsString,Pos(';',CDS.FieldByName('ord04').AsString)+1,255);
//      if StrToFloatdef(CDS090.FieldByName('inccu').Asstring,0)<>0 then
//         CDS.FieldByName('ord04').AsString:=copy(CDS.FieldByName('ord04').AsString,1,Pos(';',CDS.FieldByName('ord04').AsString))+CDS090.FieldByName('inccu').AsString;
//    end;

    //ord06         ORD07再處理
    if Pos('0.8MM', CDS.FieldByName('ord06').AsString) > 0 then
    begin

      CDS.FieldByName('ord06').AsString := '';
//      if (CDS.fieldbyname('custno').AsString='AC108') and (StrToInt(Copy(CDS.fieldbyname('materialno').AsString,3,4))>310) then
//        IncCu:=true
//      else if (CDS.fieldbyname('custno').AsString='AC082') and (StrToInt(Copy(CDS.fieldbyname('materialno').AsString,3,4))>290) then
//        IncCu:=true
//      else if StrToInt(Copy(CDS.fieldbyname('materialno').AsString,3,4))>280 then
//        IncCu:=true;
      if CDS.FieldByName('ord05').AsString = 'MIL' then
      begin
        if StrToFloatdef(Copy(CDS.FieldByName('ord04').AsString, Pos(';', CDS.FieldByName
          ('ord04').AsString) + 1, 255), 0) >= 31 then
          IncCu := true;
      end
      else if CDS.FieldByName('ord05').AsString = '"' then
      begin
        if StrToFloatdef(Copy(CDS.FieldByName('ord04').AsString, Pos(';', CDS.FieldByName
          ('ord04').AsString) + 1, 255), 0) >= 0.031 then
          IncCu := true;
      end
      else if StrToFloatdef(Copy(CDS.FieldByName('ord04').AsString, Pos(';', CDS.FieldByName
        ('ord04').AsString) + 1, 255), 0) >= 0.8 then
        IncCu := true;
    end;
    CDS090Located := CDS090.Locate('bu;custno;sno;cust_pno', VarArrayOf([g_UInfo
      ^.BU, CDS.FieldByName('custno').AsString, Copy(CDS.FieldByName('materialno').AsString,
      2, 7), CDS.FieldByName('cpno').AsString]), []);
    if CDS090Located then
    begin
      if StrToFloatdef(CDS090.FieldByName('exccu').Asstring, 0) <> 0 then
        CDS.FieldByName('ord04').AsString := CDS090.FieldByName('exccu').AsString
          + ';' + copy(CDS.FieldByName('ord04').AsString, Pos(';', CDS.FieldByName
          ('ord04').AsString) + 1, 255);
      if StrToFloatdef(CDS090.FieldByName('inccu').Asstring, 0) <> 0 then
        CDS.FieldByName('ord04').AsString := copy(CDS.FieldByName('ord04').AsString,
          1, Pos(';', CDS.FieldByName('ord04').AsString)) + CDS090.FieldByName('inccu').AsString;
      if CDS090.FieldByName('cuflag').AsString = '含銅' then
        IncCu := true
      else if CDS090.FieldByName('cuflag').AsString = '不含銅' then
        IncCu := false;
      if (CDS.FieldByName('custno').AsString = 'AC111') and CDS090.FieldByName('tflag').AsBoolean
        then
        CDS.FieldByName('ord01').asstring := '覆銅板(T)';
    end;
    if AnsiMatchText(CDS.FieldByName('custno').AsString, ['AC004', 'AC097', 'AC143']) then
      CDS.FieldByName('ord04').AsString := Copy(CDS.FieldByName('ord04').AsString,
        Pos(';', CDS.FieldByName('ord04').AsString) + 1, 255) + ';' + Copy(CDS.FieldByName
        ('ord04').AsString, 1, Pos(';', CDS.FieldByName('ord04').AsString) - 1);
    //ord07    同時處理ORD04    再處理0RD06
//    if CDS120.Locate('bu;materialno',VarArrayOf([g_UInfo^.BU,CDS.FieldByName('materialno').Asstring]),[]) then
//        IncCu:=CDS120.fieldbyname('cuflag').asboolean;  //特殊判定
    if CDS.FieldByName('ord07').AsString = '不含銅無字樣' then       //2016/3/18
    begin                                                          //2016/3/18
      if IncCu then                                                //2016/3/18
        CDS.FieldByName('ord07').AsString := '(含銅)'                //2016/3/18
      else                                                        //2016/3/18
        CDS.FieldByName('ord07').AsString := '';                    //2016/3/18
    end                                                           //2016/3/18
    else                                                          //2016/3/18
if Pos('銅)', CDS.FieldByName('ord07').AsString) > 0 then
    begin
      if IncCu then
        CDS.FieldByName('ord07').AsString := '(含銅)'
      else
        CDS.FieldByName('ord07').AsString := '(不含銅)'
    end
    else if Pos('銅', CDS.FieldByName('ord07').AsString) > 0 then
    begin
      if IncCu then
        CDS.FieldByName('ord07').AsString := '含銅'
      else
        CDS.FieldByName('ord07').AsString := '不含銅'
    end
    else if (CDS.FieldByName('ord07').AsString = 'Exc.Cu') or (CDS.FieldByName('ord07').AsString
      = 'Inc.Cu') then
    begin
      if IncCu then
        CDS.FieldByName('ord07').AsString := 'Inc.Cu'
      else
        CDS.FieldByName('ord07').AsString := 'Exc.Cu';
    end;

    if CDS.FieldByName('ord06').AsString = '全含銅' then
    begin
      CDS.FieldByName('ord06').AsString := '';
      if Pos('Cu', CDS.FieldByName('ord07').AsString) > 0 then
        CDS.FieldByName('ord07').AsString := 'Inc.Cu'
      else
        CDS.FieldByName('ord07').AsString := '含銅';
    end
    else if CDS.FieldByName('ord06').AsString = '全不含銅' then
    begin
      CDS.FieldByName('ord06').AsString := '';
      if Pos('Cu', CDS.FieldByName('ord07').AsString) > 0 then
        CDS.FieldByName('ord07').AsString := 'Exc.Cu'
      else
        CDS.FieldByName('ord07').AsString := '不含銅';
    end;

    if AnsiMatchStr(CDS.FieldByName('ord07').AsString, ['含銅', '(含銅)', 'Inc.Cu']) then
      CDS.FieldByName('ord04').AsString := Copy(CDS.FieldByName('ord04').AsString,
        Pos(';', CDS.FieldByName('ord04').AsString) + 1, 255);

    //ord08
    if (CDS090Located and (Trim(CDS090.FieldByName('Tolerances').asstring) <> '')) then
      CDS.FieldByName('ord08').AsString := CDS090.FieldByName('Tolerances').asstring;
    if (CDS.FieldByName('ord08').AsString = '+/- &CLASS C') or (CDS.FieldByName('ord08').AsString
      = '+/- &CLASS B') then
      CDS.FieldByName('ord08').AsString := Get060;
    if CDS.FieldByName('ord05').asstring = 'MM' then
    begin
      CDS.FieldByName('ord08').AsString := '±' + format('%.3f', [StrToFloatDef(copy
        (CDS.FieldByName('ord08').AsString, 3, 255), 0) * 2.54 / 100]);
      ;
    end;

    if CDS100.Locate('bu;custno;cust_pno', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
      ('custno').AsString, CDS.FieldByName('cpno').AsString]), []) then
      CDS.FieldByName('ord08').AsString := '±' + CDS100.fieldbyname('tolerance').AsString;

    //ord10 //ord11
    if (CDS.FieldByName('ord10').AsString <> '') or (CDS.FieldByName('ord11').AsString
      <> '') then
    begin
      if (not (AnsiMatchStr(Copy(CDS.FieldByName('materialno').AsString, 16, 1),
        ['R', 'I']))) and (CDS.FieldByName('ord10').AsString <> 'HTE') then
        CDS.FieldByName('ord10').AsString := '';
      if not (AnsiMatchStr(Copy(CDS.FieldByName('materialno').AsString, 16, 1),
        ['C', 'I'])) then
        CDS.FieldByName('ord11').AsString := ''
    end
    else
    begin
      CDS.FieldByName('ord10').AsString := '';
      CDS.FieldByName('ord11').AsString := '';
    end;

    if AnsiMatchStr(Copy(CDS.FieldByName('materialno').AsString, 16, 1), ['R',
      'I']) and (CDS.FieldByName('custno').asstring <> 'AC111') then
      CDS.FieldByName('ord10').AsString := 'RTF';
    if (CDS.FieldByName('custno').asstring <> 'AC111') and SameText(RightStr(CDS.fieldbyname
      ('materialno').AsString, 1), 'v') and sametext(CDS.FieldByName('ord11').asstring,
      'CAF') and (not AnsiMatchStr(CDS.fieldbyname('custno').asstring, ['AC093',
      'AC152', 'AC394', 'AC844'])) then
      CDS.FieldByName('ord11').asstring := 'ENCAF';
    if (CDS.FieldByName('custno').asstring = 'AC151') and AnsiMatchStr(CDS.FieldByName
      ('ord11').asstring, ['CAF', 'ENCAF']) then
      CDS.FieldByName('ord11').asstring := 'ANTI-' + CDS.FieldByName('ord11').asstring;

    //ord12
//    if CDS.FieldByName('ord12').AsString='英制徑向*英制緯向' then
//      CDS.FieldByName('ord12').AsString:=FloatToStr(strtofloat(Copy(CDS.fieldbyname('materialno').asstring,9,3))/10)+'*'+FloatToStr(strtofloat(Copy(CDS.fieldbyname('materialno').asstring,12,3))/10)
//    else
//    if CDS.FieldByName('ord12').AsString='英制徑向G*英制緯向' then
//      CDS.FieldByName('ord12').AsString:=FloatToStr(strtofloat(Copy(CDS.fieldbyname('materialno').asstring,9,3))/10)+'G*'+FloatToStr(strtofloat(Copy(CDS.fieldbyname('materialno').asstring,12,3))/10)
//    else
//    if CDS.FieldByName('ord12').AsString='公制徑向(mm)*公制緯向(mm)' then
//      CDS.FieldByName('ord12').AsString:=IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,9,3))*2.54))+'*'+IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,12,3))*2.54))
//    else
//    if CDS.FieldByName('ord12').AsString='公制徑向(W)*公制緯向(F)' then
//      CDS.FieldByName('ord12').AsString:=IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,9,3))*2.54))+'W*'+IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,12,3))*2.54))+'F'
//    else
//    if CDS.FieldByName('ord12').AsString='公制徑向(W)*公制緯向(T)' then
//      CDS.FieldByName('ord12').AsString:=IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,9,3))*2.54))+'W*'+IntToStr(Round(StrToInt(Copy(CDS.fieldbyname('materialno').asstring,12,3))*2.54))+'T';

//    if CDS.FieldByName('CustNo').AsString='AC111' then
//    begin
//      if      CDS.FieldByName('ord12').AsString='37*49' then CDS.FieldByName('ord12').AsString:='36*48'
//      else if CDS.FieldByName('ord12').AsString='41*49' then CDS.FieldByName('ord12').AsString:='40*48'
//      else if CDS.FieldByName('ord12').AsString='24*49' then CDS.FieldByName('ord12').AsString:='24*48'
//      else if CDS.FieldByName('ord12').AsString='43*49' then CDS.FieldByName('ord12').AsString:='42*48';
//    end;
    ord12 := CDS.FieldByName('ord12').AsString;
    if Pos('英制', ord12) > 0 then
      CDS.FieldByName('ord12').AsString := FloatToStr(strtofloat(Copy(CDS.fieldbyname
        ('materialno').asstring, 9, 3)) / 10) + '*' + FloatToStr(strtofloat(Copy
        (CDS.fieldbyname('materialno').asstring, 12, 3)) / 10)
    else if Pos('公制', ord12) > 0 then
      CDS.FieldByName('ord12').AsString := IntToStr(Round(StrToInt(Copy(CDS.fieldbyname
        ('materialno').asstring, 9, 3)) * 2.54)) + '*' + IntToStr(Round(StrToInt
        (Copy(CDS.fieldbyname('materialno').asstring, 12, 3)) * 2.54));

    if CDS110.Locate('bu;custno;size1', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
      ('CustNo').AsString, CDS.FieldByName('ord12').AsString]), []) then
      CDS.FieldByName('ord12').AsString := CDS110.fieldbyname('size2').AsString;

    if ord12 = '英制徑向G*英制緯向' then
      CDS.FieldByName('ord12').AsString := Copy(CDS.FieldByName('ord12').AsString,
        1, Pos('*', CDS.FieldByName('ord12').AsString) - 1) + 'G' + Copy(CDS.FieldByName
        ('ord12').AsString, Pos('*', CDS.FieldByName('ord12').AsString), 255)
    else if ord12 = '公制徑向(W)*公制緯向(F)' then
      CDS.FieldByName('ord12').AsString := Copy(CDS.FieldByName('ord12').AsString,
        1, Pos('*', CDS.FieldByName('ord12').AsString) - 1) + 'W' + Copy(CDS.FieldByName
        ('ord12').AsString, Pos('*', CDS.FieldByName('ord12').AsString), 255) + 'F'
    else if ord12 = '公制徑向(W)*公制緯向(T)' then
      CDS.FieldByName('ord12').AsString := Copy(CDS.FieldByName('ord12').AsString,
        1, Pos('*', CDS.FieldByName('ord12').AsString) - 1) + 'W' + Copy(CDS.FieldByName
        ('ord12').AsString, Pos('*', CDS.FieldByName('ord12').AsString), 255) + 'T'
    else if ord12 = '英制徑向"G*英制緯向"' then
      CDS.FieldByName('ord12').AsString := Copy(CDS.FieldByName('ord12').AsString,
        1, Pos('*', CDS.FieldByName('ord12').AsString) - 1) + '"G' + Copy(CDS.FieldByName
        ('ord12').AsString, Pos('*', CDS.FieldByName('ord12').AsString), 255) + '"';

    //ord13
    if (CDS090Located and (CDS090.FieldByName('structure').asstring = 'N')) then
      CDS.FieldByName('ord13').AsString := '不顯示'
    else if (CDS090Located and (CDS090.FieldByName('structure').asstring = 'Y')) then
      CDS.FieldByName('ord13').AsString := '顯示';
    if (CDS.FieldByName('ord13').AsString = '不顯示') then
    begin
      CDS.FieldByName('ord13').Value := '';
    end
    else if (CDS.FieldByName('ord13').AsString = '顯示') then
    begin
      CDS.FieldByName('ord13').Value := '';

      FBmb.Filter := 'bmb01=' + quotedstr(CDS.fieldbyname('materialno').AsString);
      FBmb.First;
      while not FBmb.Eof do
      begin
        tmpStr2 := Copy(FBmb.fieldbyname('bmb03').asstring, 4, 2);
        if CDS.FieldByName('custno').AsString = 'AC111' then
        begin
          if CDS3.Locate('BU;CodeID;Custno', VarArrayOf([g_UInfo^.BU, tmpStr2,
            'AC111']), []) then
          begin
            if (StrToIntDef(Copy(CDS.FieldByName('materialno').AsString, 3, 4),
              0) <= 180) and (CDS3.FieldByName('codeid').ASSTRING = '77') then
              CDS.FieldByName('ord13').Value := CDS.FieldByName('ord13').AsString
                + FBmb.fieldbyname('pcs').asstring + 'S'
            else
              CDS.FieldByName('ord13').Value := CDS.FieldByName('ord13').AsString
                + FBmb.fieldbyname('pcs').asstring + CDS3.fieldbyname('codename').asstring;
          end;
        end
        else
        begin
          if CDS3.Locate('BU;CodeID;Custno', VarArrayOf([g_UInfo^.BU, tmpStr2,
            CDS.FieldByName('custno').AsString]), []) then
          begin
            if CDS.FieldByName('ord13').Value = '' then
              CDS.FieldByName('ord13').Value := CDS3.fieldbyname('codename2').asstring
                + '*' + FBmb.fieldbyname('pcs').asstring
            else
              CDS.FieldByName('ord13').Value := CDS.FieldByName('ord13').asstring
                + '+' + CDS3.fieldbyname('codename2').asstring + '*' + FBmb.fieldbyname
                ('pcs').asstring
          end
          else if CDS3.Locate('BU;CodeID;Custno', VarArrayOf([g_UInfo^.BU,
            tmpStr2, 'AC111']), []) then
          begin
            if CDS.FieldByName('ord13').Value = '' then
              CDS.FieldByName('ord13').Value := CDS3.fieldbyname('codename2').asstring
                + '*' + FBmb.fieldbyname('pcs').asstring
            else
              CDS.FieldByName('ord13').Value := CDS.FieldByName('ord13').asstring
                + '+' + CDS3.fieldbyname('codename2').asstring + '*' + FBmb.fieldbyname
                ('pcs').asstring
          end;
        end;
        FBmb.Next;
      end;
      if CDS.FieldByName('custno').AsString = 'AC111' then
        CDS.FieldByName('ord13').Value := BuildStruct(CDS.FieldByName('ord13').asstring)
      else
        CDS.FieldByName('ord13').Value := BuildStruct2(CDS.FieldByName('ord13').asstring);
    end;

    if AnsiMatchStr(CDS.fieldbyname('custno').AsString, ['AC093', 'AC152',
      'AC394']) and ((Pos('1086', CDS.FieldByName('ord13').AsString) > 0) or (Pos
      ('1067', CDS.FieldByName('ord13').AsString) > 0)) then
    begin
      CDS.FieldByName('ord13').AsString := ' Laser ' + CDS.FieldByName('ord13').AsString;
    end;

    //ord16
    if CDS.FieldByName('custno').AsString = 'AC096' then
      if Copy(CDS.FieldByName('materialno').AsString, 7, 2) <> 'AA' then
        CDS.FieldByName('ord16').AsString := '';



//--------------整合---------------------
    tmpList := TStringList.Create;
    try
      tmpList.CommaText := CDS.fieldbyname('Combo').AsString;
      for i := 0 to tmpList.count - 1 do
      begin
        tmpStr := tmpList.Strings[i];
        if Length(tmpStr) = 1 then
          tmpStr := '0' + tmpStr;
        //分號分隔的使用兩次時清除頭一分號及其前面內容
        if Pos(';', CDS.fieldbyname('ord' + tmpStr).asstring) > 0 then
        begin
          CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring
            + ' ' + Copy(CDS.fieldbyname('ord' + tmpStr).asstring, 1, Pos(';',
            CDS.fieldbyname('ord' + tmpStr).asstring) - 1);
          CDS.fieldbyname('ord' + tmpStr).asstring := Copy(CDS.fieldbyname('ord'
            + tmpStr).asstring, Pos(';', CDS.fieldbyname('ord' + tmpStr).asstring)
            + 1, 255);
        end
        else
          CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring
            + ' ' + CDS.fieldbyname('ord' + tmpStr).asstring;
      end;
    finally
      tmpList.Free;
    end;

    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' ±', '±', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' MIL', 'MIL', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' 覆銅板', '覆銅板', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' TC', 'TC', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' MIL', 'MIL', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' MM', 'MM', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' "', '"', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' IN', 'IN', []);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      ' T', 'T', []);
    CDS.FieldByName('myname').Value := Trim(CDS.FieldByName('myname').asstring);

    //ordi080 客戶玻布字符
    if CDS080.Locate('custno', CDS.fieldbyname('custno').AsString, []) then
    begin
      if {(CDS.fieldbyname('custno').AsString='AC394') and} (RightStr(CDS.fieldbyname
        ('materialno').AsString, 1) = 'V') then
      begin
        if CDS080.Locate('custno;codeid', VarArrayOf([CDS.fieldbyname('custno').AsString,
          CDS.fieldbyname('GlassCloth').AsString]), []) then
        begin
          CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring
            + ' ' + CDS080.fieldbyname('codename').asstring;
        end;
      end;
    end;

//    if (CDS.FieldByName('custno').AsString='AC198') and (Copy(CDS.fieldbyname('materialno').AsString,2,1)='Q') then
//          CDS.FieldByName('myname').value:=CDS.FieldByName('myname').asstring+' '+CDS.fieldbyname('ord19').asstring;
    //後續修改注意CDS2有沒有跳轉
    if Pos(CDS.FieldByName('custno').AsString, CDS2.fieldbyname('custno').AsString)
      > 0 then
      CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring +
        ' ' + CDS2.fieldbyname('txt').asstring;
    if CDS090Located then
      CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring +
        CDS090.fieldbyname('txt').asstring;

    if (CDS.FieldByName('custno').AsString = 'AC108') and (copy(CDS.FieldByName('materialno').asstring,
      15, 1) <> 'A') and (StrtoInt(copy(CDS.FieldByName('materialno').asstring,
      3, 4)) >= 50) and (StrtoInt(copy(CDS.FieldByName('materialno').asstring, 3,
      4)) <= 80) then
      CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring + '(2-PLY)';

    if AnsiMatchText(CDS.FieldByName('custno').AsString, ['AC097', 'AC143']) and
      SameText(Copy(CDS.FieldByName('materialno').AsString, Length(CDS.FieldByName
      ('materialno').AsString), 1), 'v') then
    begin
      CDS.FieldByName('myname').Value := CDS.FieldByName('myname').asstring + ' CAR';
    end;


//    if CDS130.Locate('bu;custno;sno;cust_pno', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
//      ('custno').AsString, Copy(CDS.FieldByName('materialno').AsString, 2, 7),
//      CDS.FieldByName('cpno').AsString]), [loPartialKey]) then
//      CDS.FieldByName('myname').value := CDS130.FieldByName('cust_pname').asstring
//    else if CDS130.Locate('bu;custno;cust_pno', VarArrayOf([g_UInfo^.BU, CDS.FieldByName
//      ('custno').AsString, CDS.FieldByName('cpno').AsString]), [loPartialKey]) then
//      CDS.FieldByName('myname').value := CDS130.FieldByName('cust_pname').asstring;


    FilterORD130;

    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      'exc.cu', '(Exc.cu)', [rfReplaceAll, rfIgnoreCase]);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      'inc.cu', '(Inc.cu)', [rfReplaceAll, rfIgnoreCase]);
    CDS.FieldByName('myname').Value := StringReplace(CDS.FieldByName('myname').asstring,
      #13, '', [rfReplaceAll, rfIgnoreCase]);

    compare1 := StringReplace(CDS.FieldByName('materialname').asstring, 'X', '*',
      [rfReplaceAll, rfIgnoreCase]);
    compare1 := StringReplace(compare1, '+/-', '±', [rfReplaceAll]);
    compare1 := StringReplace(compare1, '-', '', [rfReplaceAll]);
    compare1 := StringReplace(compare1, '(', '', [rfReplaceAll]);
    compare1 := StringReplace(compare1, ')', '', [rfReplaceAll]);
    compare1 := StringReplace(compare1, ' ', '', [rfReplaceAll]);
    //2016/5/9
    //特殊銅厚對應關系“SS”=”1.5/1.5OZ”  “PP” = 2.5/2.5OZ  “H/H” = 0.5/0.5OZ  “WW” = 3.5/3.5 OZ.
    compare1 := StringReplace(compare1, '1.5/1.5OZ', 'S/S', [rfReplaceAll]);
    compare1 := StringReplace(compare1, '2.5/2.5OZ', 'P/P', [rfReplaceAll]);
    compare1 := StringReplace(compare1, '0.5/0.5OZ', 'H/H', [rfReplaceAll]);
    compare1 := StringReplace(compare1, '3.5/3.5OZ', 'W/W', [rfReplaceAll]);

    compare2 := StringReplace(CDS.FieldByName('myname').AsString, ' ', '', [rfReplaceAll]);
    compare2 := StringReplace(compare2, 'X', '*', [rfReplaceAll]);
    compare2 := StringReplace(compare2, '+/-', '±', [rfReplaceAll]);
    compare2 := StringReplace(compare2, '-', '', [rfReplaceAll]);
    compare2 := StringReplace(compare2, '(', '', [rfReplaceAll]);
    compare2 := StringReplace(compare2, ')', '', [rfReplaceAll]);
    compare2 := StringReplace(compare2, ' ', '', [rfReplaceAll]);
    CDS.FieldByName('compare').Value := not SameText(compare1, compare2);


    //紅底白字排序
    mname := StringReplace(CDS.FieldByName('materialname').AsString, 'X', '*', [rfReplaceAll]);
    mname := StringReplace(mname, 'G*', '*', [rfReplaceAll]);
    mname := StringReplace(mname, 'x', '*', [rfReplaceAll]);
    mname := StringReplace(mname, '"', '', [rfReplaceAll]);
    mname := UpperCase(mname);
    ord12tmp := StringReplace(Trim(CDS.FieldByName('ord12').asstring), '"', '',
      [rfReplaceAll]);
    ord12tmp := StringReplace(ord12tmp, 'G', '', [rfReplaceAll]);

    if ((trim(CDS.FieldByName('ord09').asstring) <> '') and (pos(UpperCase(CDS.FieldByName
      ('ord09').asstring), mname) = 0) and (pos(',9,', ',' + CDS.FieldByName('combo').AsString
      + ',') > 0) or ((trim(CDS.FieldByName('ord11').asstring) <> '') and (pos(UpperCase
      (CDS.FieldByName('ord11').asstring), mname) = 0) and (pos(',11,', ',' +
      CDS.FieldByName('combo').AsString + ',') > 0)) or ((ord12tmp <> '') and (pos
      (ord12tmp, mname) = 0) and (pos(',12,', ',' + CDS.FieldByName('combo').AsString
      + ',') > 0)) or ((CDS.FieldByName('ord13').asstring <> '') and (pos(UpperCase
      (CDS.FieldByName('ord13').asstring), mname) = 0) and (pos(',13,', ',' +
      CDS.FieldByName('combo').AsString + ',') > 0)) or ((CDS.FieldByName('ord03').asstring
      <> '') and (pos(UpperCase(CDS.FieldByName('ord03').asstring), mname) = 0)
      and (pos(',3,', ',' + CDS.FieldByName('combo').AsString + ',') > 0))) and
      CDS.FieldByName('compare').AsBoolean then
      CDS.FieldByName('compare2').Value := true;



    //紅底白字排序--END

    CDS.next;
  end;

end;

procedure TFrmORDR010.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DBGridEh1.Options := DBGridEh1.Options - [dgAlwaysShowEditor];
  FBmb.Free;
  FreeAndNil(FrmORDR010_Query);
  inherited;

end;

procedure TFrmORDR010.SetToolBarVisible;
begin
  btn_print.Visible := pos(',print,', g_MInfo^.Actions) > 0;
  btn_export.Visible := pos(',export,', g_MInfo^.Actions) > 0;
  btn_query.Visible := pos(',query,', g_MInfo^.Actions) > 0;

  btn_first.Visible := pos(',first,', g_MInfo^.Actions) > 0;
  btn_prior.Visible := pos(',prior,', g_MInfo^.Actions) > 0;
  btn_jump.Visible := pos(',jump,', g_MInfo^.Actions) > 0;
  btn_next.Visible := pos(',next,', g_MInfo^.Actions) > 0;
  btn_last.Visible := pos(',last,', g_MInfo^.Actions) > 0;

  ToolButton5.Visible := (btn_print.Visible or btn_export.Visible);
  ToolButton6.Visible := btn_query.Visible;
  ToolButton7.Visible := btn_first.Visible or btn_prior.Visible or btn_jump.Visible
    or btn_next.Visible or btn_last.Visible;

  m_print.Visible := btn_print.Visible;
  m_export.Visible := btn_export.Visible;
  m_query.Visible := btn_query.Visible;

  m_first.Visible := btn_first.Visible;
  m_prior.Visible := btn_prior.Visible;
  m_jump.Visible := btn_jump.Visible;
  m_next.Visible := btn_next.Visible;
  m_last.Visible := btn_last.Visible;
  N13.Visible := ToolButton7.Visible;
end;

procedure TFrmORDR010.FormCreate(Sender: TObject);
begin
//  inherited;
//
//  Exit;
  //大小字體調整位置
  Self.ScaleBy(96, Self.PixelsPerInch);
  Self.ClientWidth := 1030;
  Self.ClientHeight := 580;
  p_TableName := 'ORDR010';

  PCL.Top := 45;
  PCL.Left := 8;
  PCL.Width := Self.ClientWidth - 5;
  PCL.Height := PnlBottom.Top - PCL.Top - 5;
  //*******//
  Self.Caption := g_MInfo^.ProcName;
  Conn.Connected := False;
  Conn.Host := g_UInfo^.Host;
  Conn.ServerName := g_UInfo^.ServerName;
  Conn.Port := g_UInfo^.Port;
  SetGrdCaption(Conn, DBGridEh1, 'ORDR010');
  PCl.ActivePageIndex := 0;
  SetToolBarVisible;

  g_cbp(PChar(g_MInfo^.ProcId), g_DllHandle, Self.Handle);

  g_StatusBar := Self.StatusBar;
  Application.OnHint := WhenHint;
end;

procedure TFrmORDR010.m_queryClick(Sender: TObject);
begin
  if not Assigned(FrmORDR010_Query) then
    FrmORDR010_Query := TFrmORDR010_Query.Create(Application);
  if FrmORDR010_Query.ShowModal = mrOK then
  begin
    l_index := trim(FrmORDR010_Query.Edit1.Text);
    l_index2 := trim(FrmORDR010_Query.Edit2.Text);
    l_index3 := trim(FrmORDR010_Query.Edit3.Text);
    l_indate1 := DateToStr(FrmORDR010_Query.Dtp1.Date);
    l_indate2 := DateToStr(FrmORDR010_Query.Dtp2.Date);
    l_halfyear := FrmORDR010_Query.chk1.Checked;
//    l_indate2:=DateToStr(FrmORDR010_Query.Dtp2.Date);
    RefreshDS('');
  end;
end;

procedure TFrmORDR010.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
//var s,S2:string;
begin
  inherited;
//  if (not CDS.Active) or CDS.IsEmpty then exit;
//  s:=StringReplace(CDS.FieldByName('materialname').Value,'X','*',[rfReplaceAll,rfIgnoreCase]);
//  s:=StringReplace(s,'+/-','±',[rfReplaceAll]);
//  s:=StringReplace(s,'-','',[rfReplaceAll]);
//  s:=StringReplace(s,'(','',[rfReplaceAll]);
//  s:=StringReplace(s,')','',[rfReplaceAll]);
//  s:=StringReplace(s,' ','',[rfReplaceAll]);
//  s2:=StringReplace(CDS.FieldByName('myname').AsString,' ','',[rfReplaceAll]);
//  if s<>s2 then
  if CDS.FieldByName('compare').AsBoolean then
    AFont.Color := clRed
  else if CDS.FieldByName('compare_pp').AsBoolean then
    AFont.Color := clblue;

end;

procedure TFrmORDR010.ToolButton4Click(Sender: TObject);
var
  compare1, compare2: string;
begin
  inherited;
  compare1 := StringReplace(CDS.FieldByName('materialname').Value, 'X', '*', [rfReplaceAll,
    rfIgnoreCase]);
  compare1 := StringReplace(compare1, '+/-', '±', [rfReplaceAll]);
  compare1 := StringReplace(compare1, '-', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, '(', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, ')', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, ' ', '', [rfReplaceAll]);
  compare2 := StringReplace(CDS.FieldByName('myname').AsString, ' ', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, '(', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, ')', '', [rfReplaceAll]);
  ShowMessage(compare1 + #10#13 + compare2);
end;

procedure TFrmORDR010.DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer;
  Column: TColumnEh);
begin
  inherited;
  if (CDS.IndexFieldNames = 'custno;dno;ditem') or (CDS.IndexFieldNames = '') then
    CDS.IndexFieldNames := 'compare2;compare;compare_pp;custno;dno;ditem'
  else
    CDS.IndexFieldNames := 'custno;dno;ditem'
end;

procedure TFrmORDR010.ToolButton10Click(Sender: TObject);
var
  data: OleVariant;
  tmpSQL: string;
begin

  tmpSQL :=
    'Select cast(null as varchar(100))dno,cast(null as varchar(100))maker,cast(null as varchar(100))materialname,cast(null as varchar(100))custname,cast(null as datetime)ddate,* ' +
    ',cast(null as varchar(100))GlassCloth,cast(null as int)ditem from sheet12 a left join ord010 b on a.custno=b.custno where len(a.materialno)=17  order by materialno desc ';

  if QueryBySQL(Conn, tmpSQL, g_mssql, data) then
    CDS.Data := data;

end;

procedure TFrmORDR010.FormShow(Sender: TObject);
var
  tmpSql: string;
  Data: OleVariant;
begin
  inherited;
  if not CDS010.Active then
  begin
    tmpSql := 'select * from ord010';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS010.data := Data;
  end;
  if not CDS2.Active then
  begin
    tmpSql := 'select * from ord050';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS2.data := Data;
  end;
  if not CDS3.Active then
  begin
    tmpSql := 'select * from ord070';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS3.data := Data;
  end;
  if not CDS040.Active then
  begin
    tmpSql := 'select * from ord040';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS040.data := Data;
  end;
  if not CDS041.Active then
  begin
    tmpSql := 'select * from ord041';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS041.data := Data;
  end;
  if not CDS060.Active then
  begin
    tmpSql := 'select * from ord060';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS060.data := Data;
  end;
  if not CDS080.Active then
  begin
    tmpSql := 'select * from ord080';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS080.data := Data;
  end;
  if not CDS090.Active then
  begin
    tmpSql := 'select * from ord090';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS090.data := Data;
  end;
  if not CDS100.Active then
  begin
    tmpSql := 'select * from ord100';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS100.data := Data;
  end;
  if not CDS110.Active then
  begin
    tmpSql := 'select * from ord110';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS110.data := Data;
  end;
  if not CDS120.Active then
  begin
    tmpSql := 'select * from ord120';
    if QueryBySQL(Conn, tmpSql, g_MSSQL, Data) then
      CDS120.data := Data;
  end;
  if not CDS130.Active then
  begin
    if QueryBySQL(Conn, 'select * from ord130', g_MSSQL, Data) then
      CDS130.data := Data;
  end;
  if not CDS150.Active then
  begin
    if QueryBySQL(Conn, 'select * from ord150', g_MSSQL, Data) then
      CDS150.data := Data;
  end;
  ToolButton12.Visible := SameText(g_UInfo^.UserId, 'admin');
end;

procedure TFrmORDR010.ToolButton11Click(Sender: TObject);
var
  compare1, compare2: string;
begin
  compare1 := StringReplace(CDS.FieldByName('materialname').Value, 'X', '*', [rfReplaceAll,
    rfIgnoreCase]);
  compare1 := StringReplace(compare1, '+/-', '±', [rfReplaceAll]);
  compare1 := StringReplace(compare1, '-', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, '(', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, ')', '', [rfReplaceAll]);
  compare1 := StringReplace(compare1, ' ', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, 'X', '*', [rfReplaceAll]);
  compare2 := StringReplace(CDS.FieldByName('myname').AsString, ' ', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, '+/-', '±', [rfReplaceAll]);
  compare2 := StringReplace(compare2, '-', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, '(', '', [rfReplaceAll]);
  compare2 := StringReplace(compare2, ')', '', [rfReplaceAll]);
  ShowMessage(compare1 + #10#13 + compare2);
end;

procedure TFrmORDR010.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
//  var
//    mname,ord12:string;
begin
  inherited;
//  mname:=StringReplace(CDS.FieldByName('materialname').AsString,'X','*',[rfReplaceAll]);
//  mname:=StringReplace(mname,'x','',[rfReplaceAll]);
//  mname:=StringReplace(mname,'"','',[rfReplaceAll]);
//  mname:=StringReplace(mname,'G','',[rfReplaceAll]);
//  ord12:=StringReplace(Trim(CDS.FieldByName('ord12').asstring),'"','',[rfReplaceAll]);
//  ord12:=StringReplace(ord12,'G','',[rfReplaceAll]);
//  if (((trim(CDS.FieldByName('ord09').asstring)<>'') and (pos(CDS.FieldByName('ord09').asstring,mname)=0) and
//     (pos(',9,',','+CDS.FieldByName('combo').AsString+',')>0)) or
//     ((trim(CDS.FieldByName('ord11').asstring)<>'') and (pos(CDS.FieldByName('ord11').asstring,mname)=0) and
//     (pos(',11,',','+CDS.FieldByName('combo').AsString+',')>0)) or
//     ((ord12<>'') and (pos(ord12,mname)=0) and
//     (pos(',12,',','+CDS.FieldByName('combo').AsString+',')>0))  or
//     ((CDS.FieldByName('ord13').asstring<>'') and (pos(CDS.FieldByName('ord13').asstring,mname)=0) and
//     (pos(',13,',','+CDS.FieldByName('combo').AsString+',')>0))  or
//     ((CDS.FieldByName('ord03').asstring<>'') and (pos(CDS.FieldByName('ord03').asstring,mname)=0) and
//     (pos(',3,',','+CDS.FieldByName('combo').AsString+',')>0))
//     )
//     and (Column.FieldName = 'materialname') then
  if CDS.FieldByName('compare2').AsBoolean and (Column.FieldName = 'materialname') then
  begin
    DBGridEh1.Canvas.Brush.Color := clRed;
    DBGridEh1.Canvas.Font.Color := clWindow;
    DBGridEh1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
end;

procedure TFrmORDR010.ToolButton12Click(Sender: TObject);
var
  i: integer;
  s: string;
  sl: TStringList;
//  function addblank(s:string): string;
//  begin
//    while length(s)<80 do
//      s:=s+' ';
//    result:=s;
//  end;
begin
//  if (not cds.Active) or CDS.IsEmpty then exit;
  if not SameText(g_UInfo^.UserId, 'admin') then
    exit;
  sl := TStringList.Create;
  if not IdSMTP1.Connected then
    IdSMTP1.Connect();
  try
    IdMessage1.ContentType := 'text/html';
    IdMessage1.From.Text := 'terry.tang@iteq.com.cn';
    IdMessage1.Recipients.EMailAddresses :=
      'terry.tang@iteq.com.cn;mk2@iteq.com.cn;dgqayi@iteq.com.cn;habby.xue@iteq.com.cn;id120468@iteq.com.cn';
    IdMessage1.Subject := {datetostr(date - 1)}l_indate1 + '客戶品名錯誤明細';
    IdMessage1.Body.LoadFromFile('ord\head.txt');
    try
      CDS.Filter := 'compare2=1';
      CDS.Filtered := True;
      if CDS.RecordCount > 0 then
      begin
//        IdMessage1.Body.Add('致命錯誤部分:'+#13);
        cds.First;
        while not CDS.Eof do
        begin
//          s:='';
          for i := 0 to CDS.FieldCount - 1 do
          begin
//              if Pos(LowerCase(CDS.Fields[i].FieldName),'custno,dno,ditem,materialno,materialname,myname')>0 then
//                s:=s+#9+CDS.Fields[i].AsString;
            s := '<tr class="kind1"><td>' + CDS.fieldbyname('custno').asstring +
              '</td><td>' + CDS.fieldbyname('dno').asstring + '</td><td>' + CDS.fieldbyname
              ('ditem').asstring + '</td><td>' + CDS.fieldbyname('materialno').asstring
              + '</td><td>' + (CDS.fieldbyname('materialname').AsString) +
              '</td><td>' + CDS.fieldbyname('myname').asstring + '</td></tr>';
          end;
          IdMessage1.Body.Add(s);
          CDS.Next;
        end;
      end;

      CDS.Filter := 'compare=1';
      CDS.Filtered := True;
      if CDS.RecordCount > 0 then
      begin
//        IdMessage1.Body.Add('一般錯誤部分:'+#13);
        cds.First;
        while not CDS.Eof do
        begin
//          s:='';
          for i := 0 to CDS.FieldCount - 1 do
          begin
//              if Pos(LowerCase(CDS.Fields[i].FieldName),'custno,dno,ditem,materialno,materialname,myname')>0 then
            s := '<tr class="kind2"><td>' + CDS.fieldbyname('custno').asstring +
              '</td><td>' + CDS.fieldbyname('dno').asstring + '</td><td>' + CDS.fieldbyname
              ('ditem').asstring + '</td><td>' + CDS.fieldbyname('materialno').asstring
              + '</td><td>' + (CDS.fieldbyname('materialname').AsString) +
              '</td><td>' + CDS.fieldbyname('myname').asstring + '</td></tr>';
          end;
          IdMessage1.Body.Add(s);
          CDS.Next;
        end;
      end;

      CDS.Filter := 'compare_pp=1';
      CDS.Filtered := True;
      if CDS.RecordCount > 0 then
      begin
//        IdMessage1.Body.Add('一般錯誤部分:'+#13);
        cds.First;
        while not CDS.Eof do
        begin
//          s:='';
          for i := 0 to CDS.FieldCount - 1 do
          begin
//              if Pos(LowerCase(CDS.Fields[i].FieldName),'custno,dno,ditem,materialno,materialname,myname')>0 then
            s := '<tr class="kind3"><td>' + CDS.fieldbyname('custno').asstring +
              '</td><td>' + CDS.fieldbyname('dno').asstring + '</td><td>' + CDS.fieldbyname
              ('ditem').asstring + '</td><td>' + CDS.fieldbyname('materialno').asstring
              + '</td><td>' + (CDS.fieldbyname('materialname').AsString) +
              '</td><td>' + CDS.fieldbyname('myname').asstring + '</td></tr>';
          end;
          IdMessage1.Body.Add(s);
          CDS.Next;
        end;
      end;
    finally
      CDS.Filtered := False;
    end;

//    for i:=0 to ListBox1.Items.Count - 1 do
//    begin
//    Tidattachment.Create(IdMessage1.MessageParts,ListBox1.Items.Strings[i]); //附件
//    IdMessage1.MessageParts.Add;
//    end;
    sl.LoadFromFile('ord\footer.txt');
    IdMessage1.Body.Add(sl.Text);
    IdSMTP1.Send(IdMessage1);
  finally
    IdSMTP1.Disconnect;
    sl.Free;
  end;
end;

procedure TFrmORDR010.Timer2Timer(Sender: TObject);
var
  tmpStr: string;
  data:OleVariant;
begin
  tmpStr := FormatDateTime('HH:NN:SS', Now);
  if SameText(tmpStr, '05:06:00') then
  begin
    Timer2.Enabled := False;
    if not CDS130.Active then
    begin
      if QueryBySQL(Conn, 'select * from ord130', g_MSSQL, data) then
        CDS130.data := data;
    end;
    l_index := '';
    l_index2 := '';
    l_index3 := '';
    l_indate1 := DateToStr(date - 1);
    l_indate2 := DateToStr(date - 1);
    l_halfyear := false;
    RefreshDS('');
    ToolButton12Click(nil);
    Timer2.Enabled := True;
  end;
end;

end.

