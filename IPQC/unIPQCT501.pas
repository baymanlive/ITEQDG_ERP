unit unIPQCT501;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI070, Buttons, StdCtrls, DBCtrls, Mask, ComCtrls, ImgList,
  ExtCtrls, DB, DBClient, ToolWin, Math, DBCtrlsEh, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmIPQCT501 = class(TFrmSTDI070)
    PCL: TPageControl;
    PCL2: TPageControl;
    TabSheet2: TTabSheet;
    Pnl1: TPanel;
    PnlDetail: TPanel;
    tc_sia22: TLabel;
    tc_sia161: TLabel;
    tc_sia171: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    tc_sia181: TLabel;
    tc_sia191: TLabel;
    tc_sia196: TLabel;
    tc_sia201: TLabel;
    tc_sia43: TLabel;
    tc_sia38: TLabel;
    tc_sia215: TLabel;
    tc_sia41: TLabel;
    tc_sia211: TLabel;
    tc_sia33: TLabel;
    tc_sia24: TLabel;
    tc_sia44: TLabel;
    tc_sia39: TLabel;
    tc_sia217: TLabel;
    tc_sia42: TLabel;
    tc_sia212: TLabel;
    tc_sia23: TLabel;
    tc_sia32: TLabel;
    tc_sia45: TLabel;
    tc_sia40: TLabel;
    tc_sia30: TLabel;
    tc_sia36: TLabel;
    btn_sp: TSpeedButton;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit20: TDBEdit;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit31: TDBEdit;
    DBEdit32: TDBEdit;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    DBEdit35: TDBEdit;
    DBEdit36: TDBEdit;
    DBEdit37: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit40: TDBEdit;
    DBEdit41: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit45: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    DBEdit49: TDBEdit;
    DBEdit50: TDBEdit;
    DBEdit51: TDBEdit;
    DBEdit52: TDBEdit;
    DBEdit53: TDBEdit;
    tc_sia31: TDBCheckBox;
    btn_ipqct501A: TBitBtn;
    btn_ipqct501B: TBitBtn;
    btn_ipqct501C: TBitBtn;
    shb01: TLabel;
    tc_sia02: TLabel;
    tc_sik03: TLabel;
    shb09: TLabel;
    shb10: TLabel;
    ima02: TLabel;
    shb02: TLabel;
    shb05: TLabel;
    DBEdit7: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    shbacti: TDBCheckBox;
    DBEdit43: TDBEdit;
    DBEdit83: TDBEdit;
    ima021: TLabel;
    Panel2: TPanel;
    btn_sp2: TSpeedButton;
    tc_sia49: TLabel;
    DBEdit8: TDBEdit;
    tc_sia50: TLabel;
    DBEdit9: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_ipqct501AClick(Sender: TObject);
    procedure btn_ipqct501BClick(Sender: TObject);
    procedure btn_ipqct501CClick(Sender: TObject);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_postClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_sp2Click(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
  private    { Private declarations }
    function GetBW(pno: string): Double;
    procedure GetWX;
    function UpdateORA(isAll: Boolean): Boolean;
    procedure BWChange(Sender: TField);
    procedure RFChange(Sender: TField);
    function CheckData: Boolean;
  public    { Public declarations }
  protected
    procedure RefreshDS; override;
  end;

var
  FrmIPQCT501: TFrmIPQCT501;


implementation

uses
  unGlobal, unCommon, unIPQCT501_query, unIPQCT501_tc_sia30;

const
  l_CDSXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' + '<FIELD attrname="shb01" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="shb02" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="shb05" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="shb09" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="shb10" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="shbacti" fieldtype="boolean"/>' +
    '<FIELD attrname="tc_sia02" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="tc_sik03" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="ima02" fieldtype="string" WIDTH="50"/>' + '<FIELD attrname="ima021" fieldtype="string" WIDTH="50"/>' + '<FIELD attrname="oea04" fieldtype="string" WIDTH="20"/>'                                                                         //fieldcount=11,l_FNameIndex
    + '<FIELD attrname="tc_sia22" fieldtype="r8"/>' + '<FIELD attrname="tc_sia161" fieldtype="r8"/>' + '<FIELD attrname="tc_sia163" fieldtype="r8"/>' + '<FIELD attrname="tc_sia165" fieldtype="r8"/>' + '<FIELD attrname="tc_sia171" fieldtype="r8"/>' + '<FIELD attrname="tc_sia173" fieldtype="r8"/>' + '<FIELD attrname="tc_sia175" fieldtype="r8"/>' + '<FIELD attrname="tc_sia181" fieldtype="r8"/>' + '<FIELD attrname="tc_sia183" fieldtype="r8"/>' + '<FIELD attrname="tc_sia185" fieldtype="r8"/>' +
    '<FIELD attrname="tc_sia191" fieldtype="r8"/>' + '<FIELD attrname="tc_sia192" fieldtype="r8"/>' + '<FIELD attrname="tc_sia193" fieldtype="r8"/>' + '<FIELD attrname="tc_sia194" fieldtype="r8"/>' + '<FIELD attrname="tc_sia195" fieldtype="r8"/>' + '<FIELD attrname="tc_sia196" fieldtype="r8"/>' + '<FIELD attrname="tc_sia197" fieldtype="r8"/>' + '<FIELD attrname="tc_sia198" fieldtype="r8"/>' + '<FIELD attrname="tc_sia199" fieldtype="r8"/>' + '<FIELD attrname="tc_sia19A" fieldtype="r8"/>' +
    '<FIELD attrname="tc_sia201" fieldtype="r8"/>' + '<FIELD attrname="tc_sia203" fieldtype="r8"/>' + '<FIELD attrname="tc_sia205" fieldtype="r8"/>' + '<FIELD attrname="tc_sia43" fieldtype="r8"/>' + '<FIELD attrname="tc_sia44" fieldtype="r8"/>' + '<FIELD attrname="tc_sia45" fieldtype="r8"/>' + '<FIELD attrname="tc_sia38" fieldtype="r8"/>' + '<FIELD attrname="tc_sia39" fieldtype="r8"/>' + '<FIELD attrname="tc_sia40" fieldtype="r8"/>' + '<FIELD attrname="tc_sia215" fieldtype="r8"/>' +
    '<FIELD attrname="tc_sia217" fieldtype="r8"/>' + '<FIELD attrname="tc_sia41" fieldtype="r8"/>' + '<FIELD attrname="tc_sia42" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="tc_sia211" fieldtype="r8"/>' + '<FIELD attrname="tc_sia212" fieldtype="r8"/>' + '<FIELD attrname="tc_sia30" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="tc_sia33" fieldtype="string" WIDTH="1"/>' + '<FIELD attrname="tc_sia23" fieldtype="string" WIDTH="8"/>' + '<FIELD attrname="tc_sia31" fieldtype="boolean"/>' +
    '<FIELD attrname="tc_sia24" fieldtype="string" WIDTH="1"/>' + '<FIELD attrname="tc_sia32" fieldtype="string" WIDTH="1"/>' + '<FIELD attrname="tc_sia36" fieldtype="string.uni" WIDTH="40"/>' + '<FIELD attrname="tc_sia49" fieldtype="r8"/>' + '<FIELD attrname="tc_sia50" fieldtype="r8"/>' + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';


const
  l_FNameIndex = 11;

{$R *.dfm}

function TFrmIPQCT501.GetBW(pno: string): Double;
var
  s: string;
begin
  result := 0;
  if Pos(Copy(pno, 1, 1), 'PQ') > 0 then
  begin
    s := Copy(pno, 4, 2);
    if s = '12' then
      result := 6813
    else if s = '15' then
      result := 2230
    else if s = '16' then
      result := 1941
    else if s = '17' then
      result := 1982
    else if s = '18' then
      result := 1239
    else if s = '19' then
      result := 1012
    else if s = '1A' then
      result := 826
    else if s = '1B' then
      result := 1032
    else if s = '21' then
      result := 3345
    else if s = '25' then
      result := 4294
    else if s = '26' then
      result := 3221
    else if s = '31' then
      result := 3345
    else if s = '75' then
      result := 9084
    else if s = '76' then
      result := 8671
    else if s = '77' then
      result := 8382;
  end
  else
  begin
    s := Copy(pno, 4, 4);
    if s = '1506' then
      result := 6813
    else if s = '1086' then
      result := 2230
    else if s = '1080' then
      result := 1941
    else if s = '1078' then
      result := 1982
    else if s = '1067' then
      result := 1239
    else if s = '1037' then
      result := 1012
    else if s = '1027' then
      result := 826
    else if s = '106' then
      result := 1032
    else if s = '2313' then
      result := 3345
    else if s = '2116' then
      result := 4294
    else if s = '2113' then
      result := 3221
    else if s = '3313' then
      result := 3345
    else if s = '7630' then
      result := 9084
    else if s = '7628' then
      result := 8671
    else if s = '7627' then
      result := 8382;
  end;
end;

//function TFrmIPQCT501.GetBW(pno: string): Double;
//var
//  s: string;
//begin
//  s := Copy(pno, 4, 2);
//  if (s = '75') or (s = '7630') then
//    Result := 9084
//  else if (s = '76') or (s = '7628') then
//    Result := 8671
//  else if (s = '77') or (s = '7627') then
//    Result := 8382
//  else if (s = '12') or (s = '1506') then
//    Result := 6813
//  else if (s = '26') or (s = '2116') then
//    Result := 4294
//  else if (s = '31') or (s = '3313') then
//    Result := 3345
//  else if (s = '21') or (s = '2313') then
//    Result := 3345
//  else if (s = '23') or (s = '2113') then
//    Result := 3221
//  else if (s = '15') or (s = '1086') then
//    Result := 2230
//  else if (s = '16') or (s = '1080') then
//    Result := 1941
//  else if (s = '17') or (s = '1078') then
//    Result := 1982
//  else if (s = '1B') or (s = '1060') then
//    Result := 1032
//  else if (s = '18') or (s = '1067') then
//    Result := 1239
//  else if (s = '19') or (s = '1037') then
//    Result := 1012
//  else if (s = '1A') or (s = '1027') then
//    Result := 826
//  else if (s = '1J') or (s = '1017') then
//    Result := 516
//  else
//    Result := 0;
//end;

procedure TFrmIPQCT501.BWChange(Sender: TField);
begin
  if SameText(TField(Sender).FieldName, 'tc_sia161') or SameText(TField(Sender).FieldName, 'tc_sia22') then
    if CDS.FieldByName('tc_sia161').IsNull then
      CDS.FieldByName('tc_sia171').Clear
    else
      CDS.FieldByName('tc_sia171').AsFloat := RoundTo((CDS.FieldByName('tc_sia161').AsFloat - CDS.FieldByName('tc_sia22').AsFloat) / CDS.FieldByName('tc_sia161').AsFloat * 100, -1);

  if SameText(TField(Sender).FieldName, 'tc_sia163') or SameText(TField(Sender).FieldName, 'tc_sia22') then
    if CDS.FieldByName('tc_sia163').IsNull then
      CDS.FieldByName('tc_sia173').Clear
    else
      CDS.FieldByName('tc_sia173').AsFloat := RoundTo((CDS.FieldByName('tc_sia163').AsFloat - CDS.FieldByName('tc_sia22').AsFloat) / CDS.FieldByName('tc_sia163').AsFloat * 100, -1);

  if SameText(TField(Sender).FieldName, 'tc_sia165') or SameText(TField(Sender).FieldName, 'tc_sia22') then
    if CDS.FieldByName('tc_sia165').IsNull then
      CDS.FieldByName('tc_sia175').Clear
    else
      CDS.FieldByName('tc_sia175').AsFloat := RoundTo((CDS.FieldByName('tc_sia165').AsFloat - CDS.FieldByName('tc_sia22').AsFloat) / CDS.FieldByName('tc_sia165').AsFloat * 100, -1);
end;

procedure TFrmIPQCT501.RFChange(Sender: TField);
begin
  if CDS.FieldByName('tc_sia49').AsFloat = 0 then
    CDS.FieldByName('tc_sia183').AsFloat := 0
  else
    CDS.FieldByName('tc_sia183').AsFloat := RoundTo(((CDS.FieldByName('tc_sia49').AsFloat - CDS.FieldByName('tc_sia50').AsFloat * 2) * 100) / CDS.FieldByName('tc_sia49').AsFloat, -1);
end;

function TFrmIPQCT501.CheckData: Boolean;
var
  rf, rc: Double;
  s2, s44, tmpSQL: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := False;
  s2 := Copy(CDS.FieldByName('shb10').AsString, 2, 1);
  if CDS.FieldByName('tc_sia201').IsNull then
  begin
    ShowMsg('請輸入VC!', 48);
    if DBEdit32.CanFocus then
      DBEdit32.SetFocus;
    Exit;
  end;

  if CDS.FieldByName('tc_sia49').IsNull then
  begin
    ShowMsg('請輸入片重!', 48);
    if DBEdit8.CanFocus then
      DBEdit8.SetFocus;
    Exit;
  end;

  if CDS.FieldByName('tc_sia50').IsNull then
  begin
    ShowMsg('請輸入圓重!', 48);
    if DBEdit9.CanFocus then
      DBEdit9.SetFocus;
    Exit;
  end;

  if SameText(g_uinfo^.BU, 'ITEQDG') and SameText(CDS.FieldByName('oea04').AsString, 'AC109') then
  begin
    if Pos(s2, '68FQ') > 0 then
      if CDS.FieldByName('tc_sia40').IsNull then
      begin
        ShowMsg('華通膠系68FQ,請輸入比例流動度!', 48);
        if DBEdit40.CanFocus then
          DBEdit40.SetFocus;
        Exit;
      end;
    s44 := Copy(CDS.FieldByName('shb10').AsString, 4, 4);
    rc := StrToInt(Copy(CDS.FieldByName('shb10').AsString, 8, 3)) / 10;
    tmpSQL := 'select fValue-dValue v1, fvalue+dvalue v2 from DLI280 where Adhesive=%s AND Fiber=%s and RC=%f and bu=%s';
    tmpSQL := format(tmpSQL, [QuotedStr(s2), QuotedStr(s44), rc, QuotedStr(g_UInfo^.BU)]);
    if not QueryBySQL(tmpSQL, data) then
      Exit;
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.data := data;
      if (CDS.FieldByName('tc_sia40').Value > tmpCDS.FieldByName('v2').Value) or (CDS.FieldByName('tc_sia40').Value < tmpCDS.FieldByName('v1').Value) then
      begin
        ShowMsg('比例流動度超出設定範圍', 48);
        if DBEdit40.CanFocus then
          DBEdit40.SetFocus;
        Exit;
      end;
    finally
      tmpCDS.free;
    end;
  end;

  if Length(WideString(CDS.FieldByName('tc_sia36').AsString)) > 10 then
  begin
    ShowMsg('CPK備註字符超出長度限制(最多10位)!', 48);
    if DBEdit53.CanFocus then
      DBEdit53.SetFocus;
    Exit;
  end;

  if CDS.FieldByName('tc_sia49').AsFloat = 0 then
    rf := 0
  else
    rf := RoundTo(((CDS.FieldByName('tc_sia49').AsFloat - CDS.FieldByName('tc_sia50').AsFloat * 2) * 100) / CDS.FieldByName('tc_sia49').AsFloat, -1);
  if ABS(CDS.FieldByName('tc_sia183').AsFloat - rf) > 0.00001 then
  begin
    if ShowMsg('RF(' + FloatToStr(CDS.FieldByName('tc_sia183').AsFloat) + ')與片重、圓重計算結果(' + FloatToStr(rf) + ')不符!', 33) = IDCancel then
    begin
      if DBEdit8.CanFocus then
        DBEdit8.SetFocus;
      Exit;
    end;
  end;

  Result := True;
end;

procedure TFrmIPQCT501.GetWX;
var
  i: Integer;
  tmpSQL, tmpfName: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  dsne1, dsne2, dsne3, dsne4: TDataSetNotifyEvent;
begin
  dsne1 := CDS.BeforeEdit;
  dsne2 := CDS.AfterEdit;
  dsne3 := CDS.BeforePost;
  dsne4 := CDS.AfterPost;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.FieldByName('tc_sia22').OnChange := nil;
  CDS.FieldByName('tc_sia161').OnChange := nil;
  CDS.FieldByName('tc_sia163').OnChange := nil;
  CDS.FieldByName('tc_sia165').OnChange := nil;
  CDS.FieldByName('tc_sia49').OnChange := nil;
  CDS.FieldByName('tc_sia50').OnChange := nil;
  tmpCDS := TClientDataSet.Create(nil);
  try
    CDS.Edit;
    for i := l_FNameIndex to CDS.FieldCount - 1 do
      CDS.Fields[i].Clear;
    CDS.Post;

    tmpSQL := 'select * from ' + g_UInfo^.BU + '.tc_sia_file' + ' where tc_sia01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;

    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
      Exit;

    CDS.Edit;
    for i := l_FNameIndex to CDS.FieldCount - 1 do
    begin
      tmpfName := CDS.Fields[i].FieldName;
      if not SameText(tmpfName, 'tc_sia31') then
        if tmpCDS.FindField(tmpfName) <> nil then
          if not tmpCDS.FieldByName(tmpfName).IsNull then
            CDS.Fields[i].Value := tmpCDS.FieldByName(tmpfName).Value;
    end;
    CDS.FieldByName('tc_sia31').AsBoolean := SameText(tmpCDS.FieldByName('tc_sia31').AsString, 'Y');
    if SameText(g_uinfo^.BU, 'ITEQDG') and CDS.FieldByName('tc_sia22').IsNull then
      CDS.FieldByName('tc_sia22').AsFloat := GetBW(CDS.FieldByName('shb10').AsString);

    //查詢VC測試值
    if CDS.FieldByName('tc_sia201').IsNull then
    begin
      Data := null;
      tmpSQL := 'exec [dbo].[proc_IPQCT502] ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(CDS.FieldByName('shb10').AsString) + ',' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
          CDS.FieldByName('tc_sia201').AsFloat := tmpCDS.Fields[0].AsFloat;
      end;
    end;

    CDS.Post;
    CDS.MergeChangeLog;

  finally
    CDS.BeforeEdit := dsne1;
    CDS.AfterEdit := dsne2;
    CDS.BeforePost := dsne3;
    CDS.AfterPost := dsne4;
    CDS.FieldByName('tc_sia22').OnChange := BWChange;
    CDS.FieldByName('tc_sia161').OnChange := BWChange;
    CDS.FieldByName('tc_sia163').OnChange := BWChange;
    CDS.FieldByName('tc_sia165').OnChange := BWChange;
    CDS.FieldByName('tc_sia49').OnChange := RFChange;
    CDS.FieldByName('tc_sia50').OnChange := RFChange;
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT501.RefreshDS;
begin
  InitCDS(CDS, l_CDSXml);
  inherited;
end;

function TFrmIPQCT501.UpdateORA(isAll: Boolean): Boolean;
var
  i: Integer;
  tmpSQL, tmpfName, tmpStr: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Result := False;

  if CDS.IsEmpty then
  begin
    if isAll then
      ShowMsg('無資料!', 48);
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpSQL := 'select B.* from ' + g_UInfo^.BU + '.shb_file A,' + g_UInfo^.BU + '.tc_sia_file B' + ' where A.shb01=B.tc_sia01 and A.shbacti<>''X'' and A.ta_shbconf=''N''' + ' and nvl(tc_sia02,''@'')<>''@''';
    if isAll then
      tmpSQL := tmpSQL + ' and substr(B.tc_sia02,1,8)=' + Quotedstr(Copy(CDS.FieldByName('tc_sia02').AsString, 1, 8)) + ' and B.tc_sia02<>' + Quotedstr(CDS.FieldByName('tc_sia02').AsString) + ' order by tc_sia02'
    else
      tmpSQL := tmpSQL + ' and B.tc_sia01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and B.tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      if isAll then
        ShowMsg('報工單已確認或作廢!', 48);
      Exit;
    end;

    while not tmpCDS.Eof do
    begin
      if isAll then
      begin
        if ShowMsg(tmpCDS.FieldByName('tc_sia01').AsString + '---' + tmpCDS.FieldByName('tc_sia02').AsString + '是否需要更新?', 33) = IdCancel then
        begin
          tmpCDS.Next;
          Continue;
        end;

        if tmpCDS.FieldByName('tc_sia31').AsString = 'Y' then
          if ShowMsg('制程已判定,是否要覆蓋?', 33) = IdCancel then
          begin
            tmpCDS.Next;
            Continue;
          end;
      end;

      tmpSQL := '';
      for i := l_FNameIndex to CDS.FieldCount - 1 do
      begin
        tmpfName := CDS.Fields[i].FieldName;
        if not SameText(tmpfName, 'tc_sia31') then
        begin
          if CDS.FieldByName(tmpfName).DataType in [ftString, ftWideString] then
          begin
            if CDS.FieldByName(tmpfName).AsString <> tmpCDS.FieldByName(tmpfName).AsString then
              if Length(Trim(CDS.FieldByName(tmpfName).AsString)) = 0 then
                tmpSQL := tmpSQL + ',' + tmpfName + '=null'
              else
                tmpSQL := tmpSQL + ',' + tmpfName + '=' + Quotedstr(CDS.FieldByName(tmpfName).AsString);
          end
          else if tmpCDS.FieldByName(tmpfName).DataType in [ftInteger, ftFloat, ftCurrency, ftBCD] then
          begin
            if CDS.FieldByName(tmpfName).AsFloat <> tmpCDS.FieldByName(tmpfName).AsFloat then
              if CDS.FieldByName(tmpfName).IsNull then
                tmpSQL := tmpSQL + ',' + tmpfName + '=null'
              else
                tmpSQL := tmpSQL + ',' + tmpfName + '=' + FloatToStr(CDS.FieldByName(tmpfName).AsFloat);
          end;
        end;
      end;

      if CDS.FieldByName('tc_sia31').AsBoolean then
        tmpStr := 'Y'
      else
        tmpStr := 'N';
      if tmpStr <> tmpCDS.FieldByName('tc_sia31').AsString then
        tmpSQL := tmpSQL + ',tc_sia31=' + Quotedstr(tmpStr);

      if Length(tmpSQL) > 0 then
      begin
        Delete(tmpSQL, 1, 1);
        tmpSQL := 'update ' + g_UInfo^.BU + '.tc_sia_file set ' + tmpSQL + ',tc_sia46=' + Quotedstr(UpperCase(g_UInfo^.UserId)) + ' where tc_sia01=' + Quotedstr(tmpCDS.FieldByName('tc_sia01').AsString) + ' and tc_sia02=' + Quotedstr(tmpCDS.FieldByName('tc_sia02').AsString);
        if not PostBySQL(tmpSQL, 'ORACLE') then
          Exit;
      end;

      if isAll then
        tmpCDS.Next
      else
        Exit;
    end;

    Result := True;
    if isAll then
      ShowMsg('更新完畢!', 64);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT501.FormCreate(Sender: TObject);
begin
  p_SysId := 'IPQC';
  p_TableName := 'IPQCT501';

  inherited;

  btn_sp2.Caption := CheckLang('查詢');
  TabSheet2.Caption := CheckLang('半成品狀況');
  btn_insert.Visible := False;
  btn_delete.Visible := False;
  btn_copy.Visible := False;
  btn_print.Visible := False;
  btn_export.Visible := False;
  PnlDetail.Enabled := False;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    DBEdit32.Color := clInfoBk;
    DBEdit32.Enabled := False;
  end;
end;

procedure TFrmIPQCT501.btn_postClick(Sender: TObject);
begin
  if not CheckData then
    Exit;

  inherited;

  PnlDetail.Enabled := False;
  UpdateORA(False);
end;

procedure TFrmIPQCT501.btn_cancelClick(Sender: TObject);
begin
  inherited;
  if not (CDS.State in [dsInsert, dsEdit]) then
    PnlDetail.Enabled := False;
end;

procedure TFrmIPQCT501.CDSAfterEdit(DataSet: TDataSet);
begin
  inherited;
  PnlDetail.Enabled := True;
end;

procedure TFrmIPQCT501.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetWX;
end;

procedure TFrmIPQCT501.btn_queryClick(Sender: TObject);
var
  tmpSQL, tmpStr: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
//  inherited;
  if not Assigned(FrmIPQCT501_query) then
    FrmIPQCT501_query := TFrmIPQCT501_query.Create(Application);
  if FrmIPQCT501_query.ShowModal <> mrOK then
    Exit;

  g_StatusBar.Panels[0].Text := '正在查詢...';
  Application.ProcessMessages;    
  {(*}
  tmpSQL := 'select A.shb01,A.shb02,A.shb05,A.shb09,A.shb10,A.shbacti,tc_sia02,'+
            'C.ima02,C.ima021 from @bu.shb_file A,@bu.tc_sia_file B,@bu.ima_file C ' +
            'where A.shb01=B.tc_sia01 and A.shb10=C.ima01 ' +
            FrmIPQCT501_query.l_ret +
            ' and A.shbacti<>''X'' and tc_sia01 like ''571%''' +
            ' and length(nvl(tc_sia02,''''))>0';      {*)}
  tmpSQL := StringReplace(tmpSQL, '@bu', g_uinfo^.BU, [rfReplaceAll]);
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
    Exit;

  tmpStr := '';
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := CDS.Data;
    while not tmpCDS1.IsEmpty do
      tmpCDS1.Delete;

    tmpCDS2.Data := Data;
    while not tmpCDS2.Eof do
    begin
      if Pos(tmpCDS2.FieldByName('shb01').AsString, tmpStr) = 0 then
        tmpStr := tmpStr + ',' + Quotedstr(tmpCDS2.FieldByName('shb01').AsString);

      //只賦值基本資料,其它欄位從CDSAfterScroll GetWX取得
      tmpCDS1.Append;
      tmpCDS1.FieldByName('shb01').AsString := tmpCDS2.FieldByName('shb01').AsString;
      tmpCDS1.FieldByName('shb02').AsString := tmpCDS2.FieldByName('shb02').AsString;
      tmpCDS1.FieldByName('shb05').AsString := tmpCDS2.FieldByName('shb05').AsString;
      tmpCDS1.FieldByName('shb09').AsString := tmpCDS2.FieldByName('shb09').AsString;
      tmpCDS1.FieldByName('shb10').AsString := tmpCDS2.FieldByName('shb10').AsString;
      tmpCDS1.FieldByName('shbacti').AsBoolean := tmpCDS2.FieldByName('shbacti').AsString = 'Y';
      tmpCDS1.FieldByName('tc_sia02').AsString := tmpCDS2.FieldByName('tc_sia02').AsString;
      tmpCDS1.FieldByName('ima02').AsString := tmpCDS2.FieldByName('ima02').AsString;
      tmpCDS1.FieldByName('ima021').AsString := tmpCDS2.FieldByName('ima021').AsString;
      tmpCDS1.Post;

      tmpCDS2.Next;
    end;

    if Length(tmpStr) > 0 then
    begin
      Delete(tmpStr, 1, 1);
      Data := null;
      tmpSQL := 'select 1 as f,tc_sik01,tc_sik03 from ' + g_UInfo^.BU + '.tc_sik_file' + ' where tc_sik01 in (' + tmpStr + ')' + ' union all' + ' select 2 as f,shb01,oea04 from ' + g_UInfo^.BU + '.shb_file,' + g_UInfo^.BU + '.sfb_file,' + g_UInfo^.BU + '.oea_file' + ' where shb05=sfb01 and sfb22=oea01 and shb01 in (' + tmpStr + ')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;
      tmpCDS2.Data := Data;
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        if tmpCDS2.Locate('f;tc_sik01', VarArrayOf([1, tmpCDS1.FieldByName('shb01').AsString]), []) then
        begin
          tmpCDS1.Edit;
          tmpCDS1.FieldByName('tc_sik03').AsString := tmpCDS2.FieldByName('tc_sik03').AsString;
          tmpCDS1.Post;
        end;

        if tmpCDS2.Locate('f;tc_sik01', VarArrayOf([2, tmpCDS1.FieldByName('shb01').AsString]), []) then
        begin
          tmpCDS1.Edit;
          tmpCDS1.FieldByName('oea04').AsString := tmpCDS2.FieldByName('tc_sik03').AsString;
          tmpCDS1.Post;
        end;
        tmpCDS1.Next;
      end;
    end;

    if tmpCDS1.ChangeCount > 0 then
      tmpCDS1.MergeChangeLog;
    CDS.Data := tmpCDS1.Data;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

//tc_sia33
procedure TFrmIPQCT501.btn_ipqct501AClick(Sender: TObject);
var
  s_rc_max, s_rc_min, s_pg_max, s_pg_min: Double;
  s_rcdd, s_rcdd_1, s_rcdd_2, s_rcdd_3, s_rcjc, s_rf, s_pgdd, s_pgdd_1, s_pgdd_2, s_pgdd_3, s_pgdd_4, s_pgdd_5, s_pgjc, tmpSQL, tmpStr: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
  dsne1, dsne2: TDataSetNotifyEvent;
begin
  inherited;
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpSQL := 'select A.shb10,B.* from ' + g_UInfo^.BU + '.shb_file A,' + g_UInfo^.BU + '.tc_sia_file B' + ' where A.shb01=B.tc_sia01 and A.shbacti<>''X'' and A.ta_shbconf=''N''' + ' and A.shb01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and B.tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    tmpCDS1.Data := Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('報工單已確認或作廢!', 48);
      Exit;
    end;

    if Pos(Copy(tmpCDS1.FieldByName('shb10').AsString, 1, 1), 'BR') = 0 then
    begin
      ShowMsg('只有外賣PP才可以進行物性自動判級!', 48);
      Exit;
    end;

    Data := null;
    tmpSQL := 'select * from ' + g_UInfo^.BU + '.tc_sfj_file' + ' where tc_sfjyz=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and tc_sfjph=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    tmpCDS2.Data := Data;
    if tmpCDS2.IsEmpty then
    begin
      ShowMsg('無SPC資料,無法進行自動判級!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('tc_sia171').IsNull or tmpCDS1.FieldByName('tc_sia173').IsNull or tmpCDS1.FieldByName('tc_sia175').IsNull then
    begin
      ShowMsg('R/C值不能為空!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('tc_sia183').IsNull or (tmpCDS1.FieldByName('tc_sia183').AsFloat <= 0) then
    begin
      ShowMsg('外賣R/F值不能為空!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('tc_sia192').IsNull or tmpCDS1.FieldByName('tc_sia193').IsNull or tmpCDS1.FieldByName('tc_sia195').IsNull or tmpCDS1.FieldByName('tc_sia196').IsNull or tmpCDS1.FieldByName('tc_sia199').IsNull then
    begin
      ShowMsg('P/G值不能為空!', 48);
      Exit;
    end;

   //判斷R/C左單點等級
    if (tmpCDS1.FieldByName('tc_sia171').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj11').AsFloat) and (tmpCDS1.FieldByName('tc_sia171').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj11').AsFloat) then
      s_rcdd_1 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia171').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj12').AsFloat) and (tmpCDS1.FieldByName('tc_sia171').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj12').AsFloat) then
      s_rcdd_1 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia171').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj36').AsFloat) and (tmpCDS1.FieldByName('tc_sia171').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj36').AsFloat) then
      s_rcdd_1 := 'C'
    else
      s_rcdd_1 := 'D';

   //判斷R/C中單點等級
    if (tmpCDS1.FieldByName('tc_sia173').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj11').AsFloat) and (tmpCDS1.FieldByName('tc_sia173').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj11').AsFloat) then
      s_rcdd_2 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia173').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj12').AsFloat) and (tmpCDS1.FieldByName('tc_sia173').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj12').AsFloat) then
      s_rcdd_2 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia173').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj36').AsFloat) and (tmpCDS1.FieldByName('tc_sia173').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj36').AsFloat) then
      s_rcdd_2 := 'C'
    else
      s_rcdd_2 := 'D';

   //判斷R/C右單點等級
    if (tmpCDS1.FieldByName('tc_sia175').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj11').AsFloat) and (tmpCDS1.FieldByName('tc_sia175').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj11').AsFloat) then
      s_rcdd_3 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia175').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj12').AsFloat) and (tmpCDS1.FieldByName('tc_sia175').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj12').AsFloat) then
      s_rcdd_3 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia175').AsFloat >= tmpCDS2.FieldByName('tc_sfj06').AsFloat - tmpCDS2.FieldByName('tc_sfj36').AsFloat) and (tmpCDS1.FieldByName('tc_sia175').AsFloat <= tmpCDS2.FieldByName('tc_sfj06').AsFloat + tmpCDS2.FieldByName('tc_sfj36').AsFloat) then
      s_rcdd_3 := 'C'
    else
      s_rcdd_3 := 'D';

   //判斷R/C單點等級,取三點最差等級
    s_rcdd := s_rcdd_1;
    if s_rcdd_2 > s_rcdd then
      s_rcdd := s_rcdd_2;
    if s_rcdd_3 > s_rcdd then
      s_rcdd := s_rcdd_3;

   //取R/C的最大值
    s_rc_max := tmpCDS1.FieldByName('tc_sia171').AsFloat;
    if tmpCDS1.FieldByName('tc_sia173').AsFloat > s_rc_max then
      s_rc_max := tmpCDS1.FieldByName('tc_sia173').AsFloat;
    if tmpCDS1.FieldByName('tc_sia175').AsFloat > s_rc_max then
      s_rc_max := tmpCDS1.FieldByName('tc_sia175').AsFloat;

   //取R/C的最小值
    s_rc_min := tmpCDS1.FieldByName('tc_sia171').AsFloat;
    if tmpCDS1.FieldByName('tc_sia173').AsFloat < s_rc_min then
      s_rc_min := tmpCDS1.FieldByName('tc_sia173').AsFloat;
    if tmpCDS1.FieldByName('tc_sia175').AsFloat < s_rc_min then
      s_rc_min := tmpCDS1.FieldByName('tc_sia175').AsFloat;

   //判斷R/C極差等級
    if s_rc_max - s_rc_min <= tmpCDS2.FieldByName('tc_sfj44').AsFloat then
      s_rcjc := 'A'
    else if s_rc_max - s_rc_min <= tmpCDS2.FieldByName('tc_sfj45').AsFloat then
      s_rcjc := 'B'
    else if s_rc_max - s_rc_min > tmpCDS2.FieldByName('tc_sfj47').AsFloat then
      s_rcjc := 'D'
    else
      s_rcjc := 'C';

   //判斷R/F等級
    if (tmpCDS1.FieldByName('tc_sia183').AsFloat >= tmpCDS2.FieldByName('tc_sfj07').AsFloat - tmpCDS2.FieldByName('tc_sfj13').AsFloat) and (tmpCDS1.FieldByName('tc_sia183').AsFloat <= tmpCDS2.FieldByName('tc_sfj07').AsFloat + tmpCDS2.FieldByName('tc_sfj13').AsFloat) then
      s_rf := 'A'
    else if (tmpCDS1.FieldByName('tc_sia183').AsFloat >= tmpCDS2.FieldByName('tc_sfj07').AsFloat - tmpCDS2.FieldByName('tc_sfj14').AsFloat) and (tmpCDS1.FieldByName('tc_sia183').AsFloat <= tmpCDS2.FieldByName('tc_sfj07').AsFloat + tmpCDS2.FieldByName('tc_sfj14').AsFloat) then
      s_rf := 'B'
    else if (tmpCDS1.FieldByName('tc_sia183').AsFloat >= tmpCDS2.FieldByName('tc_sfj07').AsFloat - tmpCDS2.FieldByName('tc_sfj38').AsFloat) and (tmpCDS1.FieldByName('tc_sia183').AsFloat <= tmpCDS2.FieldByName('tc_sfj07').AsFloat + tmpCDS2.FieldByName('tc_sfj38').AsFloat) then
      s_rf := 'C'
    else
      s_rf := 'D';

   //判斷P/G左左2單點等級
    if (tmpCDS1.FieldByName('tc_sia192').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj15').AsFloat) and (tmpCDS1.FieldByName('tc_sia192').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj15').AsFloat) then
      s_pgdd_1 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia192').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj16').AsFloat) and (tmpCDS1.FieldByName('tc_sia192').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj16').AsFloat) then
      s_pgdd_1 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia192').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj40').AsFloat) and (tmpCDS1.FieldByName('tc_sia192').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj40').AsFloat) then
      s_pgdd_1 := 'C'
    else
      s_pgdd_1 := 'D';

   //判斷P/G左1單點等級
    if (tmpCDS1.FieldByName('tc_sia193').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj15').AsFloat) and (tmpCDS1.FieldByName('tc_sia193').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj15').AsFloat) then
      s_pgdd_2 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia193').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj16').AsFloat) and (tmpCDS1.FieldByName('tc_sia193').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj16').AsFloat) then
      s_pgdd_2 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia193').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj40').AsFloat) and (tmpCDS1.FieldByName('tc_sia193').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj40').AsFloat) then
      s_pgdd_2 := 'C'
    else
      s_pgdd_2 := 'D';

   //判斷P/G中1單點等級
    if (tmpCDS1.FieldByName('tc_sia195').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj15').AsFloat) and (tmpCDS1.FieldByName('tc_sia195').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj15').AsFloat) then
      s_pgdd_3 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia195').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj16').AsFloat) and (tmpCDS1.FieldByName('tc_sia195').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj16').AsFloat) then
      s_pgdd_3 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia195').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj40').AsFloat) and (tmpCDS1.FieldByName('tc_sia195').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj40').AsFloat) then
      s_pgdd_3 := 'C'
    else
      s_pgdd_3 := 'D';

   //判斷P/G右2單點等級
    if (tmpCDS1.FieldByName('tc_sia196').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj15').AsFloat) and (tmpCDS1.FieldByName('tc_sia196').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj15').AsFloat) then
      s_pgdd_4 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia196').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj16').AsFloat) and (tmpCDS1.FieldByName('tc_sia196').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj16').AsFloat) then
      s_pgdd_4 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia196').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj40').AsFloat) and (tmpCDS1.FieldByName('tc_sia196').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj40').AsFloat) then
      s_pgdd_4 := 'C'
    else
      s_pgdd_4 := 'D';

   //判斷P/G右右1單點等級
    if (tmpCDS1.FieldByName('tc_sia199').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj15').AsFloat) and (tmpCDS1.FieldByName('tc_sia199').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj15').AsFloat) then
      s_pgdd_5 := 'A'
    else if (tmpCDS1.FieldByName('tc_sia199').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj16').AsFloat) and (tmpCDS1.FieldByName('tc_sia199').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj16').AsFloat) then
      s_pgdd_5 := 'B'
    else if (tmpCDS1.FieldByName('tc_sia199').AsFloat >= tmpCDS2.FieldByName('tc_sfj08').AsFloat - tmpCDS2.FieldByName('tc_sfj40').AsFloat) and (tmpCDS1.FieldByName('tc_sia199').AsFloat <= tmpCDS2.FieldByName('tc_sfj08').AsFloat + tmpCDS2.FieldByName('tc_sfj40').AsFloat) then
      s_pgdd_5 := 'C'
    else
      s_pgdd_5 := 'D';

   //判斷P/G單點等級，取5點中最差等級
    s_pgdd := s_pgdd_1;
    if s_pgdd_2 > s_pgdd then
      s_pgdd := s_pgdd_2;
    if s_pgdd_3 > s_pgdd then
      s_pgdd := s_pgdd_3;
    if s_pgdd_4 > s_pgdd then
      s_pgdd := s_pgdd_4;
    if s_pgdd_5 > s_pgdd then
      s_pgdd := s_pgdd_5;

   //取P/G最大值
    s_pg_max := tmpCDS1.FieldByName('tc_sia192').AsFloat;
    if tmpCDS1.FieldByName('tc_sia193').AsFloat > s_pg_max then
      s_pg_max := tmpCDS1.FieldByName('tc_sia193').AsFloat;
    if tmpCDS1.FieldByName('tc_sia195').AsFloat > s_pg_max then
      s_pg_max := tmpCDS1.FieldByName('tc_sia195').AsFloat;
    if tmpCDS1.FieldByName('tc_sia196').AsFloat > s_pg_max then
      s_pg_max := tmpCDS1.FieldByName('tc_sia196').AsFloat;
    if tmpCDS1.FieldByName('tc_sia199').AsFloat > s_pg_max then
      s_pg_max := tmpCDS1.FieldByName('tc_sia199').AsFloat;

   //取P/G最小值
    s_pg_min := tmpCDS1.FieldByName('tc_sia192').AsFloat;
    if tmpCDS1.FieldByName('tc_sia193').AsFloat < s_pg_min then
      s_pg_min := tmpCDS1.FieldByName('tc_sia193').AsFloat;
    if tmpCDS1.FieldByName('tc_sia195').AsFloat < s_pg_min then
      s_pg_min := tmpCDS1.FieldByName('tc_sia195').AsFloat;
    if tmpCDS1.FieldByName('tc_sia196').AsFloat < s_pg_min then
      s_pg_min := tmpCDS1.FieldByName('tc_sia196').AsFloat;
    if tmpCDS1.FieldByName('tc_sia199').AsFloat < s_pg_min then
      s_pg_min := tmpCDS1.FieldByName('tc_sia199').AsFloat;

   //判斷P/G極差等級
    if s_pg_max - s_pg_min <= tmpCDS2.FieldByName('tc_sfj17').AsFloat then
      s_pgjc := 'A'
    else if s_pg_max - s_pg_min <= tmpCDS2.FieldByName('tc_sfj18').AsFloat then
      s_pgjc := 'B'
    else if s_pg_max - s_pg_min > tmpCDS2.FieldByName('tc_sfj43').AsFloat then
      s_pgjc := 'D'
    else
      s_pgjc := 'C';

   //判斷物性等級，取R/C單點等級、R/C極差等級、R/F等級、P/G單點等級、P/G極差等級中的最差等級
    tmpStr := s_rcdd;
    if s_rcjc > tmpStr then
      tmpStr := s_rcjc;
    if s_rf > tmpStr then
      tmpStr := s_rf;
    if s_pgdd > tmpStr then
      tmpStr := s_pgdd;
    if s_pgjc > tmpStr then
      tmpStr := s_pgjc;

    if (tmpStr = 'C') or (tmpStr = 'D') then
      ShowMsg('物性等級為C級或D級', 48);

    if CDS.State in [dsEdit] then
      CDS.FieldByName('tc_sia33').AsString := tmpStr
    else
    begin
      tmpSQL := 'update ' + g_UInfo^.BU + '.tc_sia_file set tc_sia33=' + Quotedstr(tmpStr) + ' where tc_sia01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
      if PostBySQL(tmpSQL, 'ORACLE') then
      begin
        dsne1 := CDS.BeforeEdit;
        dsne2 := CDS.AfterEdit;
        CDS.BeforeEdit := nil;
        CDS.AfterEdit := nil;
        CDS.Edit;
        CDS.FieldByName('tc_sia33').AsString := tmpStr;
        CDS.Post;
        CDS.MergeChangeLog;
        CDS.BeforeEdit := dsne1;
        CDS.AfterEdit := dsne2;
        ShowMsg('判定完畢!', 64);
      end;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

//tc_sia24
procedure TFrmIPQCT501.btn_ipqct501BClick(Sender: TObject);
var
  tmpSQL, tmpStr: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  dsne1, dsne2: TDataSetNotifyEvent;
begin
  inherited;
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpSQL := 'select tc_sia32,tc_sia33 from ' + g_UInfo^.BU + '.shb_file A,' + g_UInfo^.BU + '.tc_sia_file B' + ' where A.shb01=B.tc_sia01 and A.shbacti<>''X'' and A.ta_shbconf=''N''' + ' and A.shb01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and B.tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('報工單已確認或作廢!', 48);
      Exit;
    end;

    if (Length(tmpCDS.FieldByName('tc_sia32').AsString) = 0) or (Length(tmpCDS.FieldByName('tc_sia33').AsString) = 0) then
    begin
      ShowMsg('判定等級或外觀等級不能為空!', 48);
      Exit;
    end;

    if Pos(tmpCDS.FieldByName('tc_sia32').AsString, 'A,B,C,D') = 0 then
    begin
      ShowMsg('外觀等級輸入錯誤!', 48);
      Exit;
    end;

    if Pos(tmpCDS.FieldByName('tc_sia33').AsString, 'A,B,C,D') = 0 then
    begin
      ShowMsg('判定等級輸入錯誤!', 48);
      Exit;
    end;

    if tmpCDS.FieldByName('tc_sia32').AsString <= tmpCDS.FieldByName('tc_sia33').AsString then
      tmpStr := tmpCDS.FieldByName('tc_sia33').AsString
    else
      tmpStr := tmpCDS.FieldByName('tc_sia32').AsString;

    if (tmpCDS.FieldByName('tc_sia33').AsString = 'C') and (Pos(tmpStr, 'AB') > 0) then
    begin
      ShowMsg('C級不可改判A或B級!', 48);
      Exit;
    end;

    if CDS.State in [dsEdit] then
      CDS.FieldByName('tc_sia24').AsString := tmpStr
    else
    begin
      tmpSQL := 'update ' + g_UInfo^.BU + '.tc_sia_file set tc_sia24=' + Quotedstr(tmpStr) + ' where tc_sia01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
      if PostBySQL(tmpSQL, 'ORACLE') then
      begin
        dsne1 := CDS.BeforeEdit;
        dsne2 := CDS.AfterEdit;
        CDS.BeforeEdit := nil;
        CDS.AfterEdit := nil;
        CDS.Edit;
        CDS.FieldByName('tc_sia24').AsString := tmpStr;
        CDS.Post;
        CDS.MergeChangeLog;
        CDS.BeforeEdit := dsne1;
        CDS.AfterEdit := dsne2;
        ShowMsg('判定完畢!', 64);
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT501.btn_ipqct501CClick(Sender: TObject);
begin
  inherited;
  UpdateORA(True);
end;

procedure TFrmIPQCT501.btn_spClick(Sender: TObject);
begin
  inherited;
  FrmIPQCT501_tc_sia30 := TFrmIPQCT501_tc_sia30.Create(Application);
  try
    FrmIPQCT501_tc_sia30.l_pno := CDS.FieldByName('shb10').AsString;
    if FrmIPQCT501_tc_sia30.ShowModal = mrOK then
      if Length(FrmIPQCT501_tc_sia30.l_ret) > 0 then
        CDS.FieldByName('tc_sia30').AsString := FrmIPQCT501_tc_sia30.l_ret;
  finally
    FreeAndNil(FrmIPQCT501_tc_sia30);
  end;
end;

procedure TFrmIPQCT501.btn_sp2Click(Sender: TObject);
var
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  tmpSQL := 'exec [dbo].[proc_IPQCT502] ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(CDS.FieldByName('shb10').AsString);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
        CDS.FieldByName('tc_sia201').AsFloat := tmpCDS.Fields[0].AsFloat
      else
        ShowMsg('[VC揮發份測試記錄表(IPQCT502)]無此規格資料!', 48);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmIPQCT501.CDSBeforePost(DataSet: TDataSet);
begin
  if not CheckData then
    Abort;

  inherited;
end;

procedure TFrmIPQCT501.btn_editClick(Sender: TObject);
var
  tmpCDS: TClientDataSet;
  tmpSQL: string;
  data: OleVariant;
begin
  if SameText(g_uinfo^.BU, 'ITEQGZ') then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpSQL := 'select 1 from ' + g_UInfo^.BU + '.shb_file A,' + g_UInfo^.BU + '.tc_sia_file B' + ' where A.shb01=B.tc_sia01 and A.ta_shbconf=''Y''';
      tmpSQL := tmpSQL + ' and B.tc_sia01=' + Quotedstr(CDS.FieldByName('shb01').AsString) + ' and B.tc_sia02=' + Quotedstr(CDS.FieldByName('tc_sia02').AsString);
      if not QueryBySQL(tmpSQL, data, 'ORACLE') then
        Exit;
      tmpCDS.Data := data;
      if not tmpCDS.IsEmpty then
      begin
        ShowMsg('報工單已確認!', 48);
        Exit;
      end;
    finally
      tmpCDS.Free;
    end;
  end;
  inherited;

end;

end.

