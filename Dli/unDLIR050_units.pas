unit unDLIR050_units;

interface

uses
  SysUtils, Classes, Variants, Math, DBCLient, StrUtils, unCommon, unGlobal,DB;

function GetResin(Custno, M2, M18: string; isCCL: Boolean): string;

function GetCPK(Custno: string; isCCL: Boolean): string;

function GetCopperVisible(Custno, M2, MLast, C_Sizes: string): string;

function GetCopper(LotFilter, Dno, Ditem: string): string;

function GetCopperAC109(LotFilter, Dno, Ditem, M7_8: string): string;

function GetCopperAC109_oth(LotFilter, Dno, Ditem, M2, MLast: string): string;

function GetPPVisible_CCL(Custno, M2, MLast, Struct, C_Sizes: string): string;

function GetPP_CCL(SMRec: TSplitMaterialno; LotFilter, Dno, Ditem, Pno, Struct, C_Sizes: string): string;// overload;



//function GetPP_CCL(SMRec: TSplitMaterialno; Dno, Ditem: string): string; overload;

procedure GetCCL_PP_Copper(custno, Dno, Ditem: string; ds: TDataset);

procedure GetCCL_PP_Copper2(custno, Dno, Ditem: string; ds: TDataset);

function GetPP_tiptop(Dno, Ditem, Pno, LotFilter, OraDB, Custno: string): string;

function GetPP_scanlot(Dno, Ditem, LotFilter: string; isLot13: Boolean): string;

implementation

//取樹脂
function GetResin(Custno, M2, M18: string; isCCL: Boolean): string;
var
  bo: Boolean;
  ret: string;
begin
  ret := '';

  if SameText(Custno, 'AC436') then
  begin
    bo := True;
    ret := '01'
  end
  else if (pos(Custno, 'AC051/ACE22')>0) and (Date>= EncodeDate(2023,9,1)) and isCCl then
  begin
    bo := True;
    ret := '01'
  end
  else
  begin
    if isCCL then
    begin
      bo := (Pos(Custno, 'AC093/AM010/AC394/AC844/AC152/AH036/AC769/ACC39') > 0) or (SameText(Custno, 'AC111') and (Pos(M2, '6/F/4/8/A') > 0));
      ret := CheckLang('長春')
    end
    else
    begin
      bo := (Pos(Custno, 'AC394/AC844/AC152/AH036/AC111/AC093/AM010/AC769/ACC39') > 0) or SameText(M2, 'X');
      if bo then
      begin
        if Pos(Custno, 'AC769/ACC39') > 0 then
          ret := CheckLang('長春')
        else if SameText(M2, 'X') then
          ret := CheckLang('CCP')
        else if SameText(Custno, 'AC151') and ((Pos(M2, 'L/1/J') > 0) or (SameText(M2, 'U') and SameText(M18, 'X'))) then
          ret := CheckLang('晉一')
        else
          ret := CheckLang('長春');
      end;
    end;
  end;

  if not bo then
    ret := '';
  Result := ret;
end;

//取CPK
function GetCPK(Custno: string; isCCL: Boolean): string;
var
  ret: string;
begin
  ret := '';
  Randomize;
  if isCCL then
  begin
    if Pos(Custno, 'AC394/AC844/AC152/AH036/AC151') > 0 then
    begin
      if SameText(Custno, 'AC151') then
        ret := '1.3' + IntToStr(RandomRange(3, 9))
      else
        ret := '1.5' + IntToStr(RandomRange(1, 9));
    end;
  end
  else
  begin
    if Pos(Custno, 'AC093/AM010/AC394/AC844/AC152/AH036') > 0 then
    begin
      if SameText(Custno, 'AC151') then
        ret := '1.3' + IntToStr(RandomRange(3, 9))
      else
        ret := '1.5' + IntToStr(RandomRange(1, 9));
    end;
  end;
  Result := ret;
end;

//CCL銅箔顯示否
function GetCopperVisible(Custno, M2, MLast, C_Sizes: string): string;
var
  ret: Boolean;
begin
  ret := (Pos(Custno, 'AC051/ACE22/ACD04') > 0) or
  (Pos(Custno, 'AC117/ACC19/AC405/AC075/AC310/AC311/AC950/AC093/AM010/AC394/AC844/AC152/AH036/N013/N006/AC082/AC434/N023/AC436/AC051/ACE22/AC769/ACC39/AC143/AC097/AC148/AC136/ACA27') > 0) or (SameText(Custno, 'AC111') and (Pos(M2, '6/F/4/8/A/U') > 0)) or ((Pos(Custno, 'AC820/AC526/AC121/ACG02/ACA97') > 0) and (Pos(M2, '6/F/8/Q') > 0)) or (SameText(Custno, 'DDE') and (M2 = '8')) or (SameText(Custno, 'AC174') and (M2 = '6')) or (SameText(Custno, 'AC096') and (Pos(M2, '6/F') > 0)) or (SameText(Custno, 'AC178') and SameText(M2, 'U')) or (SameText(Custno, 'AC109')
    and (Pos(M2, '6/F/J/H/U') > 0)) or (SameText(Custno, 'AC109') and SameText(M2, 'U') and (Pos(MLast, '3HhZzIi') > 0)) or (SameText(Custno, 'AC109') and SameText(M2, '5') and (Pos(MLast, 'CIKMcikm') > 0)) or (SameText(Custno, 'N024')) or (SameText(Custno, 'AC084') and SameText(M2, 'Q') and (Pos('IBM', C_Sizes) > 0));

  if ret then
    Result := '1'
  else
    Result := '0';
end;

//取CCL銅箔
function GetCopper(LotFilter, Dno, Ditem: string): string;
var
  tmpSQL, ret: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  //批號第11位
  ret := '';
  tmpSQL := 'Select Supplier From Dli210 Where Copper in' + ' (Select Substring(manfac,11,1) x From Dli040' + ' Where Dno=' + Quotedstr(Dno) + ' And Ditem=' + Ditem + ' And Bu=' + Quotedstr(g_UInfo^.BU) + LotFilter + ' And Len(manfac)>10)' + ' And Bu=' + Quotedstr(g_UInfo^.BU) + ' Group By Supplier';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        ret := ret + ',' + tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;
      if Length(ret) > 0 then
        Delete(ret, 1, 1);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
  Result := ret;
end;

//取華通CCL銅箔,膠系6/F/J/U
function GetCopperAC109(LotFilter, Dno, Ditem, M7_8: string): string;
var
  ret: string;
begin
  if (Pos('T', M7_8) > 0) or (Pos('H', M7_8) > 0) or (Pos('1', M7_8) > 0) or (Pos('2', M7_8) > 0) then
  begin
    Result := CheckLang('臺灣長春');
    Exit;
  end;

  ret := '';
  if Pos('3', M7_8) > 0 then
    ret := GetCopperAC109_oth(LotFilter, Dno, Ditem, '', '');

  Result := ret;
end;

//取華通CCL銅箔,其它
function GetCopperAC109_oth(LotFilter, Dno, Ditem, M2, MLast: string): string;
var
  tmpSQL, ret: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  ret := '';
  if Pos(M2 + MLast, 'UH,Uh') > 0 then
  begin
    Result := CheckLang('蘇州福田');
    Exit;
  end
  else if Pos(M2 + MLast, '5C,5I,5K,5M,5c,5i,5k,5m') > 0 then
  begin
    Result := CheckLang('臺灣金居');
    Exit;
  end;

  //批號第11位
  tmpSQL := 'Select Distinct Substring(manfac,11,1) x From Dli040' + ' Where Dno=' + Quotedstr(Dno) + ' And Ditem=' + Ditem + ' And Bu=' + Quotedstr(g_UInfo^.BU) + LotFilter + ' And Len(manfac)>10';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        if tmpCDS.Fields[0].AsString = 'C' then
          ret := ret + ',' + CheckLang('臺灣長春')
        else if SameText(tmpCDS.Fields[0].AsString, 'M') then
          ret := ret + ',' + CheckLang('臺灣南亞')
        else if SameText(tmpCDS.Fields[0].AsString, 'B') then
          ret := ret + ',' + CheckLang('江蘇盧森堡')
        else if SameText(tmpCDS.Fields[0].AsString, 'F') then
          ret := ret + ',' + CheckLang('蘇州福田')
        else if SameText(tmpCDS.Fields[0].AsString, '2') then
          ret := ret + ',' + CheckLang('臺灣臺銅')
        else if SameText(tmpCDS.Fields[0].AsString, 'N') then
          ret := ret + ',' + CheckLang('昆山南亞')
        else if SameText(tmpCDS.Fields[0].AsString, 'U') then
          ret := ret + ',' + CheckLang('臺灣金居');
        tmpCDS.Next;
      end;
      if Length(ret) > 0 then
        Delete(ret, 1, 1);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  Result := ret;
end;

//CCL玻布顯示否
function GetPPVisible_CCL(Custno, M2, MLast, Struct, C_Sizes: string): string;
const
  strSpace = '@kk@';
var
  i: Integer;
  isOK: Boolean;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  tmpList: TStrings;
begin
  Result := '0'; //默認不顯示

  Data := null;
  tmpSQL := 'Select Code2,LastCode,Struct,StructX,C_sizes From DLI650' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And CharIndex(' + Quotedstr(Custno) + ',Custno)>0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  tmpList := TStringList.Create;
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
      Exit;

    tmpList.Delimiter := '/';
    while not tmpCDS.Eof do
    begin
      if Length(Trim(tmpCDS.FieldByName('Code2').AsString)) > 0 then
        if Pos(M2, tmpCDS.FieldByName('Code2').AsString) = 0 then
        begin
          tmpCDS.Next;
          Continue;
        end;

      if Length(Trim(tmpCDS.FieldByName('LastCode').AsString)) > 0 then
        if Pos(MLast, tmpCDS.FieldByName('LastCode').AsString) = 0 then
        begin
          tmpCDS.Next;
          Continue;
        end;

      if Length(Trim(tmpCDS.FieldByName('C_sizes').AsString)) > 0 then
      begin
        isOK := False;
        tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('C_sizes').AsString), ' ', strSpace, [rfReplaceAll]);
        for i := 0 to tmpList.Count - 1 do
          if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), C_Sizes) > 0 then
          begin
            isOK := True;
            Break;
          end;

        if not isOK then
        begin
          tmpCDS.Next;
          Continue;
        end;
      end;

      if Length(Trim(tmpCDS.FieldByName('Struct').AsString)) > 0 then       //此結構欄位顯示
      begin
        isOK := False;
        tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('Struct').AsString), ' ', strSpace, [rfReplaceAll]);
        for i := 0 to tmpList.Count - 1 do
          if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), Struct) > 0 then
          begin
            isOK := True;
            Break;
          end;

        if not isOK then
        begin
          tmpCDS.Next;
          Continue;
        end;
      end
      else if Length(Trim(tmpCDS.FieldByName('StructX').AsString)) > 0 then //此結構欄位不顯示
      begin
        isOK := False;
        tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('StructX').AsString), ' ', strSpace, [rfReplaceAll]);
        for i := 0 to tmpList.Count - 1 do
          if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), Struct) > 0 then
          begin
            isOK := True;
            Break;
          end;

        if isOK then
        begin
          tmpCDS.Next;
          Continue;
        end;
      end;

      Result := '1';  //跑到這里,表示這筆資料符合
      Break;
    end;

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpList);
  end;
end;

//取CCL玻布
//function GetPP_CCL(SMRec: TSplitMaterialno; Dno, Ditem: string): string;
//var
//  tmpSQL, tmpLot: string;
//  tmpCDS: TClientDataSet;
//  Data: OleVariant;
//begin
//  result := '/';
//  Data := null;
//  tmpSQL := 'exec dbo.proc_GetHotLotByDli010DnoDitem %s,%s,%s';
//  tmpSQL := Format(tmpSQL, [Quotedstr(g_UInfo^.BU), QuotedStr(Dno), Ditem]);
//  if not QueryBySQL(tmpSQL, Data) then
//    Exit;
//  tmpCDS := TClientDataSet.create(nil);
//  try
//    tmpCDS.Data := Data;
//    if tmpCDS.IsEmpty then
//      Exit;
//    tmpLot := tmpCDS.Fields[0].AsString;
//    Data := null;
//    tmpSQL := 'Select Supplier From Dli200' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And GlassCloth=' + QuotedStr(Copy(tmpLot, 12, 1));
//    if not QueryBySQL(tmpSQL, Data) then
//      Exit;
//    tmpCDS.Data := Data;
//    result := tmpCDS.Fields[0].AsString + '/';
//    Data := null;
//    tmpSQL := 'Select Supplier From Dli210' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Copper=' + QuotedStr(Copy(tmpLot, 11, 1));
//    if not QueryBySQL(tmpSQL, Data) then
//      Exit;
//    tmpCDS.Data := Data;
//    result := result + tmpCDS.Fields[0].AsString;
//  finally
//    tmpCDS.Free;
//  end;
//end;


//取CCL玻布及銅箔
procedure GetCCL_PP_Copper(custno, Dno, Ditem: string; ds: TDataset);
var
  tmpSQL,tmpSQL2: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  data := null;
  tmpSQL := 'Select distinct fname1 From Dli041 Where Bu=%s and dno=%s and ditem=%s';
  tmpSQL := Format(tmpSQL, [QuotedStr(g_uinfo^.BU), QuotedStr(Dno), QuotedStr(Ditem)]);
  if not QueryBySQL(tmpSQL, data) then
    exit;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      exit;

    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + ',' + QuotedStr(tmpCDS.Fields[0].AsString);
      tmpCDS.Next;
    end;
    Delete(tmpSQL, 1, 1);


    tmpSQL := 'SELECT TC_SIE02 FROM ' + g_UInfo^.BU + '.TC_SIE_FILE, ' + g_UInfo^.BU +
      '.SHB_FILE where SHB01=TC_SIE01 AND SHB05 in (' + tmpSQL + ') order by TA_SHBCONF desc';
    data := null;
    if not QueryBySQL(tmpSQL, data, 'ORACLE') then
      exit;
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      EXIT;
    tmpSQL := '';
    tmpSQL2 := '';
    while not tmpCDS.Eof do
    begin
      if Length(tmpCDS.Fields[0].AsString) < 12 then
      begin
        tmpCDS.next;
        Continue;
      end;
      tmpSQL := tmpSQL + ',' + QuotedStr(copy(tmpCDS.Fields[0].AsString, 12, 1));
      tmpSQL2 := tmpSQL2 + ',' + QuotedStr(copy(tmpCDS.Fields[0].AsString, 11, 1));
      tmpCDS.Next;
    end;
    Delete(tmpSQL, 1, 1);
    Delete(tmpSQL2, 1, 1);


    data := null;
    tmpSQL := 'Select Supplier From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And GlassCloth in (' + tmpSQL + ')';
    if not QueryBySQL(tmpSQL, data) then
      Exit;
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      exit;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + ',' + tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;

    if Length(tmpSQL) > 0 then
    begin
      Delete(tmpSQL, 1, 1);          
      ds.FieldByName('pp').AsString := tmpSQL;
    end;

    data := null;
    tmpSQL := 'Select Supplier From Dli210 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Copper in (' + tmpSQL2 + ')';
    if not QueryBySQL(tmpSQL, data) then
      Exit;
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      exit;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + ',' + tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;

    if Length(tmpSQL) > 0 then
    begin
      Delete(tmpSQL, 1, 1);
      ds.FieldByName('Copper').AsString := tmpSQL;
    end;
  finally
    tmpCDS.Free;
  end;
end;

//取CCL玻布及銅箔
procedure GetCCL_PP_Copper2(custno, Dno, Ditem: string; ds: TDataset);
var
  tmpSQL: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  data := null;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpSQL := 'Select Supplier From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU) +
      ' And GlassCloth in (Select Substring(manfac,12,1) x From Dli040 where dno='+quotedstr(dno)+' and ditem='+quotedstr(ditem)+')';
    if not QueryBySQL(tmpSQL, data) then
      Exit;
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      exit;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + ',' + tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;

    if Length(tmpSQL) > 0 then
    begin
      Delete(tmpSQL, 1, 1);
      ds.FieldByName('pp').AsString := tmpSQL;
    end;
    data := null;
    tmpSQL := 'Select Supplier From Dli210 Where Bu=' + Quotedstr(g_UInfo^.BU) +
      ' And Copper in (Select Substring(manfac,11,1) x From Dli040 where dno='+quotedstr(dno)+' and ditem='+quotedstr(ditem)+')';
    if not QueryBySQL(tmpSQL, data) then
      Exit;
    tmpCDS.Data := data;
    if tmpCDS.IsEmpty then
      exit;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + ',' + tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;

    if Length(tmpSQL) > 0 then
    begin
      Delete(tmpSQL, 1, 1);
      if SameText(custno, 'ACD04') and (pos(tmpSQL, '長春南亞') > 0) then
        ds.FieldByName('Copper').AsString := tmpSQL + '集團'
      else
        ds.FieldByName('Copper').AsString := tmpSQL;
    end;
  finally
    tmpCDS.Free;
  end;
end;








//取CCL玻布
function GetPP_CCL(SMRec: TSplitMaterialno; LotFilter, Dno, Ditem, Pno, Struct, C_Sizes: string): string;
const
  strSpace = '@kk@';
var
  pos1, SrcId: Integer;
  tmpSQL, tmpORA: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  tmpList: TStrings;

  function GetSrcId: Integer;
  var
    i: Integer;
    isOK: Boolean;
    tmpStrip_lower, tmpStrip_upper: Double;
  begin
    Result := -1;

    if Length(Trim(tmpCDS.FieldByName('Code2').AsString)) > 0 then        //此膠系欄位符合
    begin
      if Pos(SMRec.M2, tmpCDS.FieldByName('Code2').AsString) = 0 then
        Exit;
    end
    else if Length(Trim(tmpCDS.FieldByName('Code2X').AsString)) > 0 then  //此膠系欄位不符合
    begin
      if Pos(SMRec.M2, tmpCDS.FieldByName('Code2X').AsString) > 0 then
        Exit;
    end;

    if Length(Trim(tmpCDS.FieldByName('Strip_lower').AsString)) > 0 then
    begin
      try
        tmpStrip_lower := StrToFloat(tmpCDS.FieldByName('Strip_lower').AsString);
      except
        ShowMsg('基本參數[玻布供應商來源]->"條數"欄位設定錯誤:' + SMRec.Custno + ',' + tmpCDS.FieldByName('Sno').AsString, 48);
        Result := -2;
        Exit;
      end;
      tmpStrip_lower := tmpStrip_lower / 10;
    end
    else
      tmpStrip_lower := 0;

    if Length(Trim(tmpCDS.FieldByName('Strip_upper').AsString)) > 0 then
    begin
      try
        tmpStrip_upper := StrToFloat(tmpCDS.FieldByName('Strip_upper').AsString);
      except
        ShowMsg('基本參數[玻布供應商來源]->"條數"欄位設定錯誤:' + SMRec.Custno + ',' + tmpCDS.FieldByName('Sno').AsString, 48);
        Result := -2;
        Exit;
      end;
      tmpStrip_upper := tmpStrip_upper / 10;
    end
    else
      tmpStrip_upper := 9999;

    if (SMRec.M3_6 < tmpStrip_lower) or (SMRec.M3_6 > tmpStrip_upper) then
      Exit;

    if Length(Trim(tmpCDS.FieldByName('Code7_8').AsString)) > 0 then
      if Pos(SMRec.M7_8, tmpCDS.FieldByName('Code7_8').AsString) = 0 then
        Exit;

    if Length(Trim(tmpCDS.FieldByName('Code15').AsString)) > 0 then
      if Pos(SMRec.M15, tmpCDS.FieldByName('Code15').AsString) = 0 then
        Exit;

    if Length(Trim(tmpCDS.FieldByName('LastCode').AsString)) > 0 then
      if Pos(SMRec.MLast, tmpCDS.FieldByName('LastCode').AsString) = 0 then
        Exit;

    if Length(Trim(tmpCDS.FieldByName('Struct').AsString)) > 0 then       //此結構欄位符合
    begin
      isOK := False;
      tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('Struct').AsString), ' ', strSpace, [rfReplaceAll]);
      for i := 0 to tmpList.Count - 1 do
        if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), Struct) > 0 then
        begin
          isOK := True;
          Break;
        end;

      if not isOK then
        Exit;
    end
    else if Length(Trim(tmpCDS.FieldByName('StructX').AsString)) > 0 then //此結構欄位不符合
    begin
      isOK := False;
      tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('StructX').AsString), ' ', strSpace, [rfReplaceAll]);
      for i := 0 to tmpList.Count - 1 do
        if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), Struct) > 0 then
        begin
          isOK := True;
          Break;
        end;

      if isOK then
        Exit;
    end;

    if Length(Trim(tmpCDS.FieldByName('C_sizes').AsString)) > 0 then
    begin
      isOK := False;
      tmpList.DelimitedText := StringReplace(Trim(tmpCDS.FieldByName('C_sizes').AsString), ' ', strSpace, [rfReplaceAll]);
      for i := 0 to tmpList.Count - 1 do
        if Pos(StringReplace(tmpList.Strings[i], strSpace, ' ', [rfReplaceAll]), C_Sizes) > 0 then
        begin
          isOK := True;
          Break;
        end;

      if not isOK then
        Exit;
    end;

    Result := tmpCDS.FieldByName('SrcId').AsInteger;
  end;

begin
  Result := '';   //默認空白

  tmpCDS := TClientDataSet.Create(nil);
  tmpList := TStringList.Create;
  try
    //這些客戶,品名備註的玻布優先
    if Pos(SMRec.Custno, 'AC082/AC093/AM010/AC394/AC844/AC152/AH036') > 0 then
    begin
      Data := null;
      tmpSQL := 'Select GlassCloth,Supplier From Dli200' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Len(GlassCloth)>4';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;

      tmpSQL := '';
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        if Pos(tmpCDS.Fields[0].AsString, C_Sizes) > 0 then
          tmpSQL := tmpSQL + ',' + tmpCDS.Fields[1].AsString;
        tmpCDS.Next;
      end;

      if Length(tmpSQL) > 0 then
      begin
        Delete(tmpSQL, 1, 1);
        Result := tmpSQL;
        Exit;
      end;
    end;

    //AC111品名備註的玻布優先
    if SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '6/F') > 0) and (Pos(SMRec.MLast_1, '6/7') > 0) then
    begin
      pos1 := Pos('(', C_Sizes);
      if (pos1 > 0) and (RightStr(C_Sizes, 1) = ')') then
      begin
        tmpSQL := Copy(C_Sizes, pos1 + 1, 255);
        tmpSQL := Copy(tmpSQL, 1, Length(tmpSQL) - 1);
        if Length(tmpSQL) > 0 then
          if not SameText(tmpSQL, 'AE') then  //(AE)表示汽車板標識
            if not SameText(tmpSQL, 'JX') then  //(JX)表示江西廠
            begin
              Result := tmpSQL;
              Exit;
            end;
      end;
    end;

    //N024以熱壓批號判定
//    if SameText(SMRec.Custno,'N024')  then
//    begin
//      Data:=null;
//      tmpSQL:='Select GlassCloth,Supplier From Dli010'
//             +' Where Bu='+Quotedstr(g_UInfo^.BU)
//             +' and dno= ' + QuotedStr(dno)
//             +' and Ditem= ' + QuotedStr(Ditem)
//             +' And Len(GlassCloth)>4';
//      if not QueryBySQL(tmpSQL, Data) then
//         Exit;
//    end;

    Data := null;
    tmpSQL := 'Select Sno,Code2,Code2X,Strip_lower,Strip_upper,Code7_8,Code15,LastCode,' + 'Struct,StructX,C_sizes,SrcId,Value From DLI660' +
    ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And CharIndex(' + Quotedstr(SMRec.Custno) + ',Custno)>0 Order By Sno,Id';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;

    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
      Exit;

    tmpList.Delimiter := '/';
    while not tmpCDS.Eof do
    begin
      SrcId := GetSrcId;
      if SrcId = -1 then
        tmpCDS.Next
      else if SrcId = -2 then
        Exit
      else
      begin
        tmpORA := g_UInfo^.BU;
        if SameText(SMRec.Custno, 'AC436') then
        begin
          if Pos(SMRec.MLast, 'Gw') > 0 then
            tmpORA := 'iteqgz'
          else
            tmpORA := 'iteqdg';
        end;

        if SrcId = 0 then
          Result := tmpCDS.FieldByName('Value').AsString
        else if SrcId = 1 then
          Result := GetPP_tiptop(Dno, Ditem, Pno, LotFilter, tmpORA, '')
        else if SrcId = 2 then
          Result := GetPP_tiptop(Dno, Ditem, Pno, LotFilter, tmpORA, SMRec.Custno)
        else if SrcId = 3 then
          Result := GetPP_scanlot(Dno, Ditem, LotFilter, False)
        else if SrcId = 4 then
          Result := GetPP_scanlot(Dno, Ditem, LotFilter, True);

        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpList);
  end;
end;

//【掃描批號前10碼+料號】查詢tiptop報工批號,再取報工批號第12碼對應供應商
function GetPP_tiptop(Dno, Ditem, Pno, LotFilter, OraDB, Custno: string): string;
var
  tmpSQL, ret: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  //查詢掃描批號
  ret := '';
  Data := null;
  tmpSQL := 'Select Distinct Left(manfac,10)+''%'' lot From Dli040' + ' Where Dno=' + Quotedstr(Dno) + ' And Ditem=' + Ditem + ' And Bu=' + Quotedstr(g_UInfo^.BU) + LotFilter;
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      tmpSQL := '';
      while not tmpCDS.Eof do
      begin
        if tmpSQL <> '' then
          tmpSQL := tmpSQL + ' or ';
        tmpSQL := tmpSQL + ' tc_sih02 Like ' + Quotedstr(tmpCDS.Fields[0].AsString);
        tmpCDS.Next;
      end;

      //查詢報工批號,取第12碼
      if tmpSQL <> '' then
      begin
        Data := null;
        tmpSQL := 'Select tc_sih02 From ' + OraDB + '.tc_sih_file Inner Join ' + OraDB + '.shb_file' + ' on tc_sih01=shb01 Where (' + tmpSQL + ')' + ' and shb10=' + Quotedstr(Pno) + ' and shbacti=''Y''';
        if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          tmpCDS.Data := Data;
          tmpSQL := '';
          while not tmpCDS.Eof do
          begin
            if Length(tmpCDS.Fields[0].AsString) > 11 then
            begin
              if tmpSQL <> '' then
                tmpSQL := tmpSQL + ',';
              tmpSQL := tmpSQL + Quotedstr(Custno + Copy(tmpCDS.Fields[0].AsString, 12, 1));
            end;
            tmpCDS.Next;
          end;

          //報工批號12碼查詢玻布供應商
          if tmpSQL <> '' then
          begin
            Data := null;
            tmpSQL := 'Select Distinct Supplier From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And GlassCloth in (' + tmpSQL + ') Group By Supplier';
            if QueryBySQL(tmpSQL, Data) then
            begin
              tmpCDS.Data := Data;
              tmpSQL := '';
              while not tmpCDS.Eof do
              begin
                if tmpSQL <> '' then
                  tmpSQL := tmpSQL + ',';
                tmpSQL := tmpSQL + tmpCDS.Fields[0].AsString;
                tmpCDS.Next;
              end;

              ret := tmpSQL;
            end;
          end;
        end;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  Result := ret;
end;

//掃描批號玻布碼供應商
function GetPP_scanlot(Dno, Ditem, LotFilter: string; isLot13: Boolean): string;
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := '';

  //批號第12位
  Data := null;
  tmpSQL := 'Select Supplier,1 id From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And GlassCloth in (Select Substring(manfac,12,1) x From Dli040' + ' Where Dno=' + Quotedstr(Dno) + ' And Ditem=' + Ditem + ' And Bu=' + Quotedstr(g_UInfo^.BU) + LotFilter + ' And Len(manfac)>11)' + ' Group By Supplier';
  if isLot13 then  //批號第13位
    tmpSQL := tmpSQL + ' Union ALL Select Supplier,2 id From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And GlassCloth in (Select Substring(manfac,13,1) x From Dli040' + ' Where Dno=' + Quotedstr(Dno) + ' And Ditem=' + Ditem + ' And Bu=' + Quotedstr(g_UInfo^.BU) + LotFilter + ' And Len(manfac)>12)' + ' Group By Supplier';
  tmpSQL := tmpSQL + ' Order By id';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        if Pos(tmpCDS.Fields[0].AsString, Result) = 0 then
          Result := Result + ',' + tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;
      if Length(Result) > 0 then
        Delete(Result, 1, 1);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

end.

