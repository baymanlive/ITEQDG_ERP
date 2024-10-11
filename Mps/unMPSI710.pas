unit unMPSI710;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, Math, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ExtCtrls, ComCtrls, ToolWin, Clipbrd, StrUtils;

type
  TFrmMPSI710 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure FieldChange(Sender: TField);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State:
      TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
  private    { Private declarations }
    function GETBOMCONSTRU(MCODE: string): string;
//    procedure insertTiptop;
    procedure FillSameStealno(wono, v01, good, qty,v06,v02,v26: string;ddate:TDateTime);
    function checkexists(wono: string): boolean;
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI710: TFrmMPSI710;

implementation

uses
  unGlobal, unCommon, unMPSI710_Steal;

const
  strNG = 'NG';

var
  FMPS202: TClientDataSet;
{$R *.dfm}

function TFrmMPSI710.GETBOMCONSTRU(MCODE: string): string;
type
  recordleixing = record
    LeiXing: string;
    geshu: integer;
  end;
var
  I: Integer;
  STR, Mleixing, tmp_clno, db, s_clno, s_lastButOne, s_lastButTwo, s_last, s_custno: string;
  YONGLIANG: REAL;
  m, j, t: integer;
  l_leixing: array[1..20] of recordleixing;
  l_combine: array[1..10] of recordleixing;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  s_clno := CDS.FIELDBYNAME('PNO').asstring;
  if s_clno = '' then
  begin
    result := '';
    Exit;
  end;
  s_last := Copy(s_clno, Length(s_clno), 1);
  s_custno := CDS.fieldbyname('custno').asstring;
  s_lastButOne := Copy(s_clno, Length(s_clno) - 1, 1)[1];
  s_lastButTwo := s_clno[Length(s_clno) - 2];
  if SameText(g_uinfo^.BU, 'ITEQDG') then
    db := 'ORACLE'
  else
    db := 'ORACLE1';
  m := 1;
  STR := 'SELECT IMA02,sum(BMB06*100000) as bmb06,BMB20 FROM  ' + g_UInfo^.BU + '.BMB_FILE,' + g_UInfo^.BU +
    '.IMA_FILE WHERE BMB03=IMA01 AND BMB01=''' + MCODE + ''' AND SUBSTR(BMB03,1,1) IN (''' + 'P' + ''',''' + 'R' +
    ''',''' + 'N' + ''',''' + 'Q' + ''',''' + 'M' + ''') and bmb05 is null  group  BY IMA02,bmb20';
  tmpCDS := TClientDataSet.Create(nil);
  result := '';
  try
    QueryBySQL(STR, Data, db);
    tmpCDS.data := Data;
    if tmpCDS.IsEmpty then
    begin
      tmp_clno := Copy(s_clno, 2, 5) + '%' + s_lastButTwo + '_' + s_last;
      tmp_clno := 'select * from ima_file where (ima01 like ''E' + tmp_clno + ''' or ima01 like ''T' + tmp_clno +
        ''') and length(ima01) =17 and rownum=1';
      QueryBySQL(STR, Data, db);
      tmpCDS.data := Data;
      tmp_clno := tmpCDS.Fields[0].asstring;
    end;

    tmpCDS.FIRST;
    while not tmpCDS.EOF do
    begin
      Mleixing := Trim(Copy(tmpCDS.FieldByName('IMA02').AsString, Pos('-', tmpCDS.FieldByName('IMA02').AsString) + 1,
        Length(tmpCDS.FieldByName('IMA02').AsString)));
      if Pos('-', Mleixing) > 1 then
        Mleixing := Copy(Mleixing, 1, Pos('-', Mleixing) - 1);
      if (Mleixing = '7627') or (Mleixing = '7630') then
        Mleixing := '7628';
      if (Mleixing = '7628') and ((Copy(MCODE, 3, 4) = '0210') or (Copy(MCODE, 3, 4) = '0170') or (Copy(MCODE, 3, 4) =
        '0540')) and (s_custno = 'AC111') then
        Mleixing := '7627';
      YONGLIANG := tmpCDS.FieldByName('BMB06').ASFLOAT / tmpCDS.FieldByName('BMB20').ASFLOAT / 100000; //框架bug

      l_leixing[m].LeiXing := Mleixing;
      l_leixing[m].geshu := StrToInt((floattostr(RoundTo(YONGLIANG, 0))));
      m := m + 1;
      tmpCDS.NEXT;
    end;
    for I := 1 to 10 do//Iterate
    begin
      l_combine[I].geshu := 0;
    end; //for
    for j := 1 to m - 1 do//Iterate
    begin
      l_combine[j].LeiXing := l_leixing[j].LeiXing;
      l_combine[j].geshu := l_leixing[j].geshu;
      for I := j + 1 to m - 1 do//Iterate
      begin

        if l_combine[j].LeiXing = l_leixing[I].LeiXing then
        begin
          l_combine[j].geshu := l_combine[j].geshu + l_leixing[I].geshu;
          l_leixing[I].geshu := 0
        end;
      end; //for
    end; //for


    result := l_combine[1].LeiXing + '*' + inttostr(l_combine[1].geshu);
    for I := 2 to 10 do//Iterate
    begin
      for t := 10 downto 1 do//Iterate
      begin
        if l_combine[t].LeiXing = l_combine[I].LeiXing then
          Continue
        else if l_combine[I].geshu > 0 then
        begin
          result := result + '+' + l_combine[I].LeiXing + '*' + inttostr(l_combine[I].geshu);
          l_combine[I].geshu := 0;
        end;
      end; //for
    end; //for

  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPSI710.FormCreate(Sender: TObject);
var
  col: TColumnEh;
  sql: string;
  data: OleVariant;
  i: integer;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS710';
  p_GridDesignAns := True;
  inherited;
  FMPS202 := TClientDataSet.Create(nil);
  sql := 'select Thickness,diff from mps202 where bu=' + QuotedStr(g_uinfo.BU);
  if QueryBySQL(sql, data) then
    FMPS202.data := data;

  col := DBGridEh1.FindFieldColumn('v01');
  col.PickList.Add('OK');
  col.PickList.Add(strNG);
  col := DBGridEh1.FindFieldColumn('v18');
  col.ReadOnly := true;
  col.Color := clInfoBk;
  for i := 0 to DBGridEh1.Columns.Count - 1 do
  begin
    if Pos(DBGridEh1.Columns[i].FieldName, 'custno,pno,Construction,checker,ddate') > 0 then
    begin
      DBGridEh1.Columns[i].ReadOnly := true;
      DBGridEh1.Columns[i].Color := clInfoBk;
    end;
  end;
//  col.PickList.Add('PASS');
//  col.PickList.Add(strNG);
end;

procedure TFrmMPSI710.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
  i: integer;
begin
  if strFilter='' then
    strFilter:=' and ddate>getdate()-14 ';
  tmpSQL := 'exec proc_Update_Mps710_lot Select * From MPS710 Where Bu=''ITEQDG'' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
  for i := 0 to CDS.FieldCount - 1 do
    CDS.Fields[i].OnChange := FieldChange;
end;

procedure TFrmMPSI710.FieldChange(Sender: TField);
var
  sql: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
  col: TColumnEh;
  mil: double;
  ls:TStrings;
//  sdate: TDateTime;
begin
  if Pos(Sender.FieldName, 'v09,v10,v11,v12,v13,v14,v15,v16') > 0 then
  begin
    with Sender.DataSet do
    begin  {(*}
      if (FieldByName('v09').Value>0) and
         (FieldByName('v10').Value>0) and
         (FieldByName('v11').Value>0) and
         (FieldByName('v12').Value>0) and
         (FieldByName('v13').Value>0) and
         (FieldByName('v14').Value>0) and
         (FieldByName('v15').Value>0) and
         (FieldByName('v16').Value>0) then
      FieldByName('v17').Value:=
                         RoundTo((FieldByName('v09').Value+
                                  FieldByName('v10').Value+
                                  FieldByName('v11').Value+
                                  FieldByName('v12').Value+
                                  FieldByName('v13').Value+
                                  FieldByName('v14').Value+
                                  FieldByName('v15').Value+
                                  FieldByName('v16').Value)/8,-2);
        if (FieldByName('v09').Value >= FieldByName('v19').Value) and
           (FieldByName('v09').Value <= FieldByName('v20').Value) and
           (FieldByName('v10').Value >= FieldByName('v19').Value) and
           (FieldByName('v10').Value <= FieldByName('v20').Value) and
           (FieldByName('v11').Value >= FieldByName('v19').Value) and
           (FieldByName('v11').Value <= FieldByName('v20').Value) and
           (FieldByName('v12').Value >= FieldByName('v19').Value) and
           (FieldByName('v12').Value <= FieldByName('v20').Value) and
           (FieldByName('v13').Value >= FieldByName('v19').Value) and
           (FieldByName('v13').Value <= FieldByName('v20').Value) and
           (FieldByName('v14').Value >= FieldByName('v19').Value) and
           (FieldByName('v14').Value <= FieldByName('v20').Value) and
           (FieldByName('v15').Value >= FieldByName('v19').Value) and
           (FieldByName('v15').Value <= FieldByName('v20').Value) and
           (FieldByName('v16').Value >= FieldByName('v19').Value) and
           (FieldByName('v16').Value <= FieldByName('v20').Value) then
          FieldByName('v18').Value := 'PASS'
        else
          FieldByName('v18').Value := 'NG';
         {*)}
    end;
  end
  else if SameText(Sender.FieldName, 'wono') then
  begin
    {(*}
    sql := 'select shb10,tc_sie02,sfa03,sfb08,oea04,ima02 from ' +
           ' shb_file join sfa_file on sfa01=shb05 join sfb_file on sfa01=sfb01 ' +
           ' join ima_file on sfb05=ima01 ' +
           ' join oea_file on sfb22=oea01 left join tc_sie_file on tc_sie01=shb01 ' +
           ' where shb05=' + QuotedStr(Sender.AsString);
    {*)}
    if QueryBySQL(sql, data, 'ORACLE') then
    begin
      tmpCDS := TClientDataSet.Create(nil);
      ls := TStringList.create;
      try
        tmpCDS.data := data;
        ls.Delimiter := '-';
        ls.DelimitedText := tmpCDS.fieldbyname('ima02').asstring;
        if ls.Count > 0 then
          CDS.FieldByName('cu').AsString := ls[ls.count - 1];
        CDS.FieldByName('pno').AsString := tmpCDS.fieldbyname('shb10').asstring;
        mil := StrToIntDef(copy(CDS.FieldByName('pno').AsString, 3, 4), 0) / 10;
        if FMPS202.Active then
        begin
          if FMPS202.Locate('thickness', mil, []) then
          begin
            CDS.FieldByName('v19').value := mil - fmps202.fieldbyname('diff').Value;
            CDS.FieldByName('v20').value := mil + fmps202.fieldbyname('diff').Value;
          end;
        end;
        CDS.FieldByName('lot').AsString := tmpCDS.fieldbyname('tc_sie02').asstring;
        CDS.FieldByName('custno').AsString := tmpCDS.fieldbyname('oea04').asstring;
        CDS.FieldByName('qty').value := tmpCDS.fieldbyname('sfb08').value;
        CDS.FieldByName('Construction').AsString := GETBOMCONSTRU(CDS.fieldbyname('pno').asstring);
        col := DBGridEh1.FindFieldColumn('lot');
        col.PickList.Clear;
        while not tmpCDS.Eof do
        begin
          if (tmpCDS.fieldbyname('tc_sie02').asstring <> '') and (col.PickList.IndexOf(tmpCDS.fieldbyname('tc_sie02').asstring)
            = -1) then
          begin
            col.PickList.Add(tmpCDS.fieldbyname('tc_sie02').asstring);
            if CDS.FieldByName('lot').AsString = '' then
              CDS.FieldByName('lot').AsString := tmpCDS.fieldbyname('tc_sie02').asstring;
          end;
          tmpCDS.Next;
        end;
        col := DBGridEh1.FindFieldColumn('v25');
        col.PickList.Clear;
        sql :=
          'select distinct tc_sic04 from shb_file join sfa_file on sfa01=shb05 join sfb_file on sfa01=sfb01 join oea_file on sfb22=oea01 left join tc_sic_file on tc_sic01=shb01 where tc_sic04 is not null and shb05='
          + QuotedStr(Sender.AsString);
        if QueryBySQL(sql, data, 'ORACLE') then
        begin
          tmpCDS.data := data;
          CDS.FieldByName('V25').value := tmpCDS.fieldbyname('tc_sic04').asstring;
          tmpCDS.Next;
          while not tmpCDS.Eof do
          begin
            if tmpCDS.fieldbyname('tc_sic04').asstring <> '' then
              CDS.FieldByName('V25').value := CDS.FieldByName('V25').value + ',' + tmpCDS.fieldbyname('tc_sic04').asstring;
            tmpCDS.Next;
          end;
        end;

//        FrmMPSI710_Steal := TFrmMPSI710_Steal.Create(self, Stealno(Sender.AsString));
//        FrmMPSI710_Steal.ShowModal;
      finally
        tmpCDS.Free;
        ls.free;
      end;
    end;
  end
  else if Pos(Sender.FieldName, 'v01,v18') > 0 then
  begin
    with Sender.DataSet do
    begin
      if (FieldByName('v01').asstring = '') and (FieldByName('v18').asstring = '') then
        FieldByName('result').AsString := ''
      else if (FieldByName('v01').asstring = 'OK') and (FieldByName('v18').asstring = 'PASS') then
        FieldByName('result').AsString := 'PASS'
      else
        FieldByName('result').AsString := strNG;
    end;
  end;
  Application.ProcessMessages;
end;

procedure TFrmMPSI710.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('checker').AsString := g_uinfo^.UserId;
  DataSet.FieldByName('ddate').value := now;
end;

procedure TFrmMPSI710.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  if SameText(g_uinfo^.UserId, 'ID150515') then
    ShowMessage(Column.FieldName);
end;

procedure TFrmMPSI710.CDSAfterPost(DataSet: TDataSet);
begin
  inherited;
//  insertTiptop;
  CDS.AfterPost := nil;
  try
    FillSameStealno(cds.fieldbyname('wono').asstring, cds.fieldbyname('v01').asstring, cds.fieldbyname('good').asstring,
      cds.fieldbyname('qty').asstring, cds.fieldbyname('v06').asstring, cds.fieldbyname('v02').asstring, cds.fieldbyname('v26').asstring,cds.fieldbyname('ddate').AsDateTime);
  finally
    CDS.AfterPost := CDSAfterPost;
    g_ProgressBar.Visible := False;
  end;
end;

procedure TFrmMPSI710.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  inherited;
  if cds.FieldByName('result').AsString = 'NG' then
  begin
    if Pos(Column.FieldName, 'v02,v03,v04,v05,v06,v07') > 0 then
    begin
      with DBGridEh1 do
      begin
        Canvas.Brush.Color := clred;
        Canvas.FillRect(Rect);
        Canvas.TextRect(Rect, Rect.Left, Rect.Top, Column.Field.AsString);
      end;
    end;
  end;
end;

procedure TFrmMPSI710.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMPS202.Free;
  inherited;
end;

procedure TFrmMPSI710.CDSBeforePost(DataSet: TDataSet);
var
  sql,v26: string;
  idx:integer;
begin
  if (cds.FieldByName('v01').AsString <>strNG) and (cds.FieldByName('v01').AsString <>'OK') then
  begin
    ShowMsg('未填寫'+DBGridEh1.FieldColumns[cds.FieldByName('v01').FieldName].Title.Caption);
    Abort;
  end;
  
  if not (cds.FieldByName('v26').AsInteger in [0,1,2]) then
  begin
    showmsg('取樣數量只能是0，1，2');
    Abort;
  end;

  if cds.FieldByName('v26').AsInteger = 0 then
  begin
  {(*}
    if       (not cds.FieldByName('v09').IsNull)
          or (not cds.FieldByName('v10').IsNull)
          or (not cds.FieldByName('v11').IsNull)
          or (not cds.FieldByName('v12').IsNull)
          or (not cds.FieldByName('v13').IsNull)
          or (not cds.FieldByName('v14').IsNull)
          or (not cds.FieldByName('v15').IsNull)
          or (not cds.FieldByName('v16').IsNull) then    {*)}
    begin
      showmsg('取樣數量欄位只能填1或2板厚數據方可輸入');
      Abort;
    end;
  end;
  for idx:=9 to 16 do
  begin
    sql:='v'+RightStr('0'+IntToStr(idx),2);
    if not cds.FieldByName(sql).IsNull then
    begin
      if (cds.FieldByName(sql).AsFloat<cds.FieldByName('v19').AsFloat) or
         (cds.FieldByName(sql).AsFloat>cds.FieldByName('v20').AsFloat) then
      begin
        ShowMessage(DBGridEh1.FieldColumns[sql].Title.Caption+'超出允許範圍');
//        Abort;
      end;
    end;
  end;

  if (cds.FieldByName('v01').OldValue <> cds.FieldByName('v01').NewValue) or
     (cds.FieldByName('good').OldValue <> cds.FieldByName('good').NewValue) or
     (cds.FieldByName('v06').OldValue <> cds.FieldByName('v06').NewValue) or
     (cds.FieldByName('v26').OldValue <> cds.FieldByName('v26').NewValue) or
     (cds.FieldByName('v02').OldValue <> cds.FieldByName('v02').NewValue) then
  begin
    if VarToStr(cds.FieldByName('v26').NewValue) = '' then
      v26:='0'
    else
      v26:=VarToStr(cds.FieldByName('v26').NewValue);
    sql := 'update tc_mps_file set tc_result=%s,tc_result2=%s,tc_defective=%d,v26=%s where tc_bu=%s and tc_wono=%s';// and nvl(v02,'' '')=%s ';
    sql := format(sql, [quotedstr(cds.FieldByName('v01').ASSTRING),
                        quotedstr(cds.FieldByName('v06').ASSTRING),
                        cds.FieldByName('good').AsInteger,
                        quotedstr(v26),
                        quotedstr(g_uinfo^.BU),
                        quotedstr(cds.FieldByName('wono').AsString)]);
                        //quotedstr(cds.FieldByName('v02').ASSTRING+' ')]);
    if SameText(g_uinfo^.UserId,'ID150515') then
      ShowMessage(sql);
    if not postbysql(sql, 'ORACLE') then
    begin
      showmsg('更新TIPTOP數據失敗,請重試');
    end;
  end;
end;

procedure TFrmMPSI710.CDSBeforeDelete(DataSet: TDataSet);
var
  sql, bu, db: string;
begin
  inherited;
  if g_UInfo^.bu = 'ITEQDG' then
  begin
    bu := ' and machine<>''L6''';
    db := 'ORACLE';
  end
  else
  begin
    db := 'ORACLE1';
    bu := ' and machine=''L6''';
  end;                       
    {(*}
  sql := 'delete from tc_mps_file where tc_bu='+QuotedStr(g_uinfo^.BU) +
         ' and tc_wono='+QuotedStr(CDS.fieldbyname('wono').AsString);    {*)}
  PostBySQL(sql, db);    {*)}
end;

procedure TFrmMPSI710.FillSameStealno(wono, v01, good, qty, v06, v02, v26: string;ddate:TDateTime);
var
  sql, stealno, boiler, sdate: string;
  tmpCDS, oraCDS: TClientDataSet;
  data: OleVariant;
begin
  sql := 'select stealno,sdate,currentboiler from mps010 where machine<>''L6'' and isnull(errorflag,0)=0 and wono=' + QuotedStr(wono);
  tmpCDS := TClientDataSet.Create(nil);
  oraCDS := TClientDataSet.Create(nil);
  try
    if not QueryBySQL(sql, data) then
      exit;
    tmpCDS.Data := data;
    if not tmpCDS.IsEmpty then
    begin
      stealno := tmpCDS.fieldbyname('stealno').AsString;
      sdate := tmpCDS.fieldbyname('sdate').AsString;
      boiler := tmpCDS.fieldbyname('currentboiler').AsString;
      {(*}
      sql := 'select distinct wono from mps010 where stealno=%s and Sdate=%s and currentboiler=%s ' +
             ' and isnull(wono,'''')<>''''  and isnull(errorflag,0)=0 and machine<>''L6''';
              {*)}
      sql := Format(sql, [QuotedStr(stealno), QuotedStr(sdate), QuotedStr(boiler)]);
      data := null;
      if not QueryBySQL(sql, data) then
        exit;
      tmpCDS.data := data;
      sql := '';
      while not tmpCDS.Eof do
      begin
        sql := sql + ' or shb05=' + QuotedStr(tmpCDS.fieldbyname('wono').AsString);
        tmpCDS.next;
      end;
    end else
      sql :=  ' or shb05=' + QuotedStr(wono);

    Delete(sql, 1, 3);
    
    {(*}
    sql := 'select distinct shb05,sfb05,sfb08 from shb_file join sfa_file on sfa01=shb05 ' +
           'join sfb_file on sfa01=sfb01  '+
           'left join tc_mps_file on shb05=tc_wono  '+
           'where tc_wono is null and  (' + sql + ')';  {*)}       //tc_sie02 is not null and
    data := null;
    if not QueryBySQL(sql, data, 'ORACLE') then
      exit;
    tmpCDS.data := data;
    if tmpCDS.IsEmpty then
      exit;

    sql := 'select * from tc_mps_file where 1=2';
    data := null;
    if not QueryBySQL(sql, data, 'ORACLE') then
      exit;
    oraCDS.Data := data;

    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := tmpCDS.RecordCount;
    g_ProgressBar.Visible := True;
    while not tmpCDS.Eof do
    begin
//      wono := tmpCDS.fieldbyname('shb05').AsString;
      if not checkexists(tmpCDS.fieldbyname('shb05').AsString) then
      begin
        CDS.Append;
        CDS.FieldByName('wono').AsString := tmpCDS.fieldbyname('shb05').AsString;
        CDS.FieldByName('pno').AsString := tmpCDS.fieldbyname('sfb05').AsString;
        CDS.FieldByName('v01').AsString := v01;
//        CDS.FieldByName('good').AsString := good;
      end;
      oraCDS.Append;
      oraCDS.FieldByName('tc_bu').AsString := g_uinfo^.bu;
      oraCDS.FieldByName('tc_wono').AsString := tmpCDS.fieldbyname('shb05').AsString;
      oraCDS.FieldByName('tc_lot').AsString := '1';
      oraCDS.FieldByName('tc_pno').AsString := tmpCDS.fieldbyname('sfb05').AsString;
      oraCDS.FieldByName('tc_quatity').AsString := qty;
      oraCDS.FieldByName('tc_result').AsString := v01;
      oraCDS.FieldByName('tc_defective').AsString := good;   //陳榮耀要求,別思考這是什麼鬼邏輯
      oraCDS.FieldByName('tc_result2').AsString := v06;
      oraCDS.FieldByName('v02').AsString := v02;
      if tmpCDS.fieldbyname('shb05').AsString=wono then
        oraCDS.FieldByName('v26').AsString := v26;
//      else
//        oraCDS.FieldByName('v26').AsString := '0';
      oraCDS.FieldByName('tc_date').AsDateTime := ddate;

      tmpCDS.next;
      g_ProgressBar.Position := g_ProgressBar.Position + 1;
    end;
    inherited CDSAfterPost(CDS);
    if oraCDS.State in [dsInsert, dsEdit] then
      oraCDS.Post;
    if not CDSPost(oraCDS, 'tc_mps_file', 'ORACLE') then
      if oraCDS.ChangeCount > 0 then
        oraCDS.CancelUpdates;
  finally
    FreeAndNil(tmpCDS);
    oraCDS.free;
    g_ProgressBar.Visible := false;
  end;
end;
//
//procedure TFrmMPSI710.insertTiptop;
//var
//  sql, bu, db: string;
//  boiler: integer;
//  data: OleVariant;
//  sdate: TDateTime;
//  tmp, ora: TClientDataSet;
//begin
//  if g_UInfo^.bu = 'ITEQDG' then
//  begin
//    bu := ' and machine<>''L6''';
//    db := 'ORACLE';
//  end
//  else
//  begin
//    db := 'ORACLE1';
//    bu := ' and machine=''L6''';
//  end;
//  if CDS.fieldbyname('v01').AsString = '' then
//    exit;
//  if CDS.fieldbyname('wono').AsString = '' then
//    exit;
////  if CDS.fieldbyname('lot').AsString = '' then
////    exit;
//  if CDS.fieldbyname('qty').AsString = '' then
//    exit;
//  sql := 'select sdate,CurrentBoiler from mps010 where wono=' + QuotedStr(CDS.fieldbyname('wono').AsString) + bu;
//  if not QueryBySQL(sql, data) then
//    Exit;
//
//  tmp := TClientDataSet.Create(nil);
//  ora := TClientDataSet.Create(nil);
//  try
//    tmp.data := data;
//    sdate := tmp.fieldbyname('sdate').AsDateTime;
//    boiler := tmp.fieldbyname('CurrentBoiler').AsInteger;
//    sql := 'select wono from mps010 where CurrentBoiler=''%d'' and sdate=''%s''' + bu;
//    sql := Format(sql, [boiler, FormatDateTime('yyyy-MM-dd', sdate)]);
//    if not QueryBySQL(sql, data) then
//      exit;
//    tmp.data := data;
////    sql := 'delete from tc_shz_file where tc_shz04=''MPS710'' and (1=2 ';
//    {(*}
//    sql := 'delete from tc_mps_file where tc_bu='+QuotedStr(g_uinfo^.BU) +
//           ' and tc_wono='+QuotedStr(CDS.fieldbyname('wono').AsString);    {*)}
//    PostBySQL(sql, db);
//
//    sql :=
//      'insert into tc_mps_file(tc_bu,tc_wono,tc_lot,tc_pno,tc_pplot,tc_pot,tc_result,tc_quatity,tc_Defective)values(%s,%s,%s,%s,%s,%d,%s,%s,%s)';
//      {(*}
//    sql := Format(sql,[QuotedStr(g_uinfo^.BU),
//                       QuotedStr(CDS.fieldbyname('wono').AsString),
//                       QuotedStr(' '),
//                       QuotedStr(CDS.fieldbyname('pno').AsString),
//                       QuotedStr(CDS.fieldbyname('v25').AsString),
//                       boiler,
//                       QuotedStr(CDS.fieldbyname('v01').AsString),
//                       QuotedStr(CDS.fieldbyname('qty').AsString),
//                       QuotedStr(CDS.fieldbyname('good').AsString)
//    ]);
//     {*)}
//    PostBySQL(sql, db);
//  finally
//    tmp.free;
//    ora.Free;
//  end;
//end;

function TFrmMPSI710.checkexists(wono: string): boolean;
var
  sql: string;
  isExist: boolean;
begin
  result := false;
  sql := 'select 1 from mps710 where wono=' + quotedstr(wono);
  if QueryExists(sql, isExist) then
    result := isExist;
end;

end.

