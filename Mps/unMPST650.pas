unit unMPST650;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ComCtrls, ToolWin, Buttons, Math, ComObj, Menus;

type
  TFrmMPST650 = class(TFrmSTDI031)
    PnlRight: TPanel;
    btn_mpst650A: TBitBtn;
    btn_mpst650D: TBitBtn;
    btn_mpst650E: TBitBtn;
    btn_mpst650F: TBitBtn;
    btn_mpst650G: TBitBtn;
    btn_mpst650I: TBitBtn;
    btn_mpst650H: TBitBtn;
    btn_mpst650J: TBitBtn;
    btn_mpst650K: TBitBtn;
    btn_mpst650L: TBitBtn;
    btn_mpst650M: TBitBtn;
    btn_mpst650N: TBitBtn;
    Panel2: TPanel;
    rgp: TRadioGroup;
    LblTot: TLabel;
    btn_mpst650O: TBitBtn;
    btn_mpst650P: TBitBtn;
    btn_mpst650Q: TBitBtn;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure rgpClick(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_mpst650AClick(Sender: TObject);
    procedure btn_mpst650DClick(Sender: TObject);
    procedure btn_mpst650EClick(Sender: TObject);
    procedure btn_mpst650FClick(Sender: TObject);
    procedure btn_mpst650GClick(Sender: TObject);
    procedure btn_mpst650IClick(Sender: TObject);
    procedure btn_mpst650HClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpst650JClick(Sender: TObject);
    procedure btn_mpst650KClick(Sender: TObject);
    procedure btn_mpst650LClick(Sender: TObject);
    procedure btn_mpst650MClick(Sender: TObject);
    procedure btn_mpst650NClick(Sender: TObject);
    procedure btn_mpst650OClick(Sender: TObject);
    procedure btn_mpst650PClick(Sender: TObject);
    procedure btn_mpst650QClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
  private
    l_StrIndex, l_StrIndexDesc: string;
    procedure PurQtyChange(Sender: TField);
    procedure Date1Change(Sender: TField);
    procedure Date2Change(Sender: TField);
    //procedure Date3Change(Sender: TField);
    procedure Date4Change(Sender: TField);
    procedure Date5Change(Sender: TField);
    procedure Date6Change(Sender: TField);
    function GetSrcId: string;
    procedure UpdateSupply(bu: string; tmpCDS1: TClientDataSet);
    procedure RefreshData;
    procedure SetQtyColor(ColorIndex: Integer);
    { Private declarations }
  public
    procedure RefreshGrdCaptionX;
    procedure RefreshDS(strFilter: string); override;
    { Public declarations }
  end;

var
  FrmMPST650: TFrmMPST650;

implementation

uses
  unGlobal, unCommon, unMPST650_pur, unFind, unMPST650_query, unMPST650_sum;

const
  l_msg = '更新完畢,請重新查詢顯示資料!';

{$R *.dfm}

function TFrmMPST650.GetSrcId: string;
begin
  case rgp.ItemIndex of
    0:
      Result := 'wxpp';
    1:
      Result := 'wxccl';
    2:
      Result := 'twpp';
    3:
      Result := 'twccl';
    4:
      Result := 'jxpp';
    5:
      Result := 'jxccl';
    6:
      Result := 'wx';
    7:
      Result := 'tw';
    8:
      Result := 'jx';
    9:
      Result := 'pp';
  else
    Result := 'wxpp';
  end;
end;

procedure TFrmMPST650.RefreshData;
var
  Qty1, Qty2: Double;
  tmpCDS: TClientDataSet;
begin
  with CDS do
  begin
    Filtered := False;
    Filter := 'SrcId=' + Quotedstr(GetSrcId);
    Filtered := True;
    if CDS.IsEmpty then
    begin
      LblTot.Caption := '';
      Exit;
    end;
  end;

  Qty1 := 0;
  Qty2 := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.Filter := CDS.Filter;
    tmpCDS.Filtered := True;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        Qty1 := Qty1 + FieldByName('purqty').AsFloat;
        Qty2 := Qty2 + FieldByName('qty').AsFloat;
        Next;
      end;
    end;

    LblTot.Caption := CheckLang('總數量:' + FloatToStr(Qty1) + '/' + FloatToStr(Qty2));
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST650.RefreshGrdCaptionX;
begin
  RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
end;

//計算:轉換后數量
procedure TFrmMPST650.PurQtyChange(Sender: TField);
begin
  if SameText(CDS.FieldByName('units').AsString, 'RL') and (Length(CDS.FieldByName('pno').AsString) = 18) then
    CDS.FieldByName('qty').AsFloat := TField(Sender).AsFloat * StrToInt(Copy(CDS.FieldByName('pno').AsString, 11, 3))
  else
    CDS.FieldByName('qty').AsFloat := TField(Sender).AsFloat;
end;

//答交出貨日期=預計到廠日期
procedure TFrmMPST650.Date1Change(Sender: TField);
begin
  if not TField(Sender).IsNull then
    CDS.FieldByName('date2').AsDateTime := TField(Sender).AsDateTime;
end;

//預計出廠日期->計算->預計到廠日期
procedure TFrmMPST650.Date2Change(Sender: TField);
begin
  if CDS.FieldByName('date3').IsNull then
  begin
    if TField(Sender).IsNull then
      CDS.FieldByName('date4').Clear
    else
    begin
      if rgp.ItemIndex in [0, 1, 6] then
        CDS.FieldByName('date4').AsDateTime := TField(Sender).AsDateTime + 4
      else if rgp.ItemIndex in [2, 3] then
        CDS.FieldByName('date4').AsDateTime := TField(Sender).AsDateTime + 10
      else if rgp.ItemIndex in [4, 5, 8, 9] then
        CDS.FieldByName('date4').AsDateTime := TField(Sender).AsDateTime + 1
      else //7
        CDS.FieldByName('date4').AsDateTime := TField(Sender).AsDateTime + 2;
    end;
  end;
end;
{
//實際出廠日期->計算->預計到廠日期
procedure TFrmMPST650.Date3Change(Sender:TField);
begin
  if TField(Sender).IsNull then
  begin
    if CDS.FieldByName('date2').IsNull then
       CDS.FieldByName('date4').Clear
    else begin
      if rgp.ItemIndex in [0,1,6] then
         CDS.FieldByName('date4').AsDateTime:=CDS.FieldByName('date2').AsDateTime+4
      else if rgp.ItemIndex in [2,3] then
         CDS.FieldByName('date4').AsDateTime:=CDS.FieldByName('date2').AsDateTime+10
      else if rgp.ItemIndex in [4,5,8] then
         CDS.FieldByName('date4').AsDateTime:=CDS.FieldByName('date2').AsDateTime+3
      else //7
         CDS.FieldByName('date4').AsDateTime:=CDS.FieldByName('date2').AsDateTime+2;
    end;
  end else
  begin
    if rgp.ItemIndex in [0,1,6] then
       CDS.FieldByName('date4').AsDateTime:=TField(Sender).AsDateTime+4
    else if rgp.ItemIndex in [2,3] then
       CDS.FieldByName('date4').AsDateTime:=TField(Sender).AsDateTime+10
    else if rgp.ItemIndex in [4,5,8] then
       CDS.FieldByName('date4').AsDateTime:=TField(Sender).AsDateTime+3
    else //7
       CDS.FieldByName('date4').AsDateTime:=TField(Sender).AsDateTime+2;
  end;
end;
}
//預計到廠日期->計算->DG達交日期

procedure TFrmMPST650.Date4Change(Sender: TField);
begin
  if TField(Sender).IsNull then
    CDS.FieldByName('adate').Clear
  else
    CDS.FieldByName('adate').AsDateTime := TField(Sender).AsDateTime + 1;
end;

//新出廠日期->計算->新到廠日期
procedure TFrmMPST650.Date5Change(Sender: TField);
begin
  if TField(Sender).IsNull then
    CDS.FieldByName('date6').Clear
  else
  begin
    if rgp.ItemIndex in [0, 1, 6] then
      CDS.FieldByName('date6').AsDateTime := TField(Sender).AsDateTime + 4
    else if rgp.ItemIndex in [2, 3] then
      CDS.FieldByName('date6').AsDateTime := TField(Sender).AsDateTime + 10
    else if rgp.ItemIndex in [4, 5, 8] then
      CDS.FieldByName('date6').AsDateTime := TField(Sender).AsDateTime + 1
    else //7
      CDS.FieldByName('date6').AsDateTime := TField(Sender).AsDateTime + 2;
  end;
end;

//新到廠日期->計算->新DG達交日期
procedure TFrmMPST650.Date6Change(Sender: TField);
begin
  if TField(Sender).IsNull then
    CDS.FieldByName('adate_new').Clear
  else
    CDS.FieldByName('adate_new').AsDateTime := TField(Sender).AsDateTime + 1;
end;

procedure TFrmMPST650.SetQtyColor(ColorIndex: Integer);
var
  dsNE1, dsNE2, dsNE3, dsNE4: TDataSetNotifyEvent;
begin
  with CDS do
  begin
    if (not Active) or IsEmpty then
    begin
      ShowMsg('無數據,不可操作!', 48);
      Exit;
    end;

    dsNE1 := BeforeEdit;
    dsNE2 := AfterEdit;
    dsNE3 := BeforePost;
    dsNE4 := AfterPost;
    BeforeEdit := nil;
    AfterEdit := nil;
    BeforePost := nil;
    AfterPost := nil;
    try
      Edit;
      if FieldByName('QtyColor').AsInteger = ColorIndex then
        FieldByName('QtyColor').AsInteger := 0
      else
        FieldByName('QtyColor').AsInteger := ColorIndex;
      Post;
      if not PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno') then
        CDS.CancelUpdates;
    finally
      BeforeEdit := dsNE1;
      AfterEdit := dsNE2;
      BeforePost := dsNE3;
      AfterPost := dsNE4;
    end;
  end;
end;

procedure TFrmMPST650.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS650 Where Bu=' + Quotedstr(g_UInfo^.Bu) + strFilter + ' Order By SrcId,Cdate,Cno,Sno';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST650.FormCreate(Sender: TObject);
begin
  p_SysId := 'MPS';
  p_TableName := 'MPS650';
  p_GridDesignAns := True;

  inherited;

  btn_insert.Visible := False;
  LblTot.Caption := '';
end;

procedure TFrmMPST650.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not AsSigned(FrmMPST650_query) then
    FrmMPST650_query := TFrmMPST650_query.Create(Application);
  if FrmMPST650_query.ShowModal = mrOK then
  begin
    RefreshGrdCaptionX;
    RefreshDS(FrmMPST650_query.l_sql);
    RefreshData;
  end;
end;

procedure TFrmMPST650.rgpClick(Sender: TObject);
begin
  inherited;
  if CDS.Active then
    RefreshData;
end;

procedure TFrmMPST650.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('purqty').OnChange := PurQtyChange;
  CDS.FieldByName('date1').OnChange := Date1Change;
  CDS.FieldByName('date2').OnChange := Date2Change;
  //CDS.FieldByName('date3').OnChange:=Date3Change;
  CDS.FieldByName('date4').OnChange := Date4Change;
  CDS.FieldByName('date5').OnChange := Date5Change;
  CDS.FieldByName('date6').OnChange := Date6Change;
end;

procedure TFrmMPST650.CDSAfterPost(DataSet: TDataSet);
begin
  if PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno') then
    inherited;
end;

procedure TFrmMPST650.CDSBeforePost(DataSet: TDataSet);
begin
  if (Length(Trim(DataSet.FieldByName('oradb').AsString)) = 0) or (DBGridEh1.FieldColumns['oradb'].PickList.IndexOf(UpperCase
    (DataSet.FieldByName('oradb').AsString)) = -1) then
  begin
    ShowMsg('原始[訂單來源]錯誤,請重新選擇!', 48);
    Abort;
  end;

  if DataSet.State in [dsInsert] then
    DataSet.FieldByName('dno').AsString := GetSno(p_TableName);
  inherited;
end;

procedure TFrmMPST650.CDSAfterDelete(DataSet: TDataSet);
begin
  //inherited;
  if not PostBySQLFromDelta(CDS, p_TableName, 'bu,dno') then
    if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
end;

procedure TFrmMPST650.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('srcid').AsString := GetSrcId;
  DataSet.FieldByName('stkqty').Clear;
  DataSet.FieldByName('mpsqty').Clear;
end;

procedure TFrmMPST650.btn_mpst650AClick(Sender: TObject);
begin
  inherited;
  FrmMPST650_pur := TFrmMPST650_pur.Create(nil);
  try
    FrmMPST650_pur.l_srcid := GetSrcId;
    FrmMPST650_pur.ShowModal;
  finally
    FreeAndNil(FrmMPST650_pur);
  end;
end;

procedure TFrmMPST650.btn_mpst650DClick(Sender: TObject);
var
  i, loopCnt: Integer;
  tmpNum1, tmpNum2: Integer;
  tmpSQL: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if Sender is TMenuItem then
  begin
    if CDS.Active and (CDS.FieldByName('purcno').AsString<>'') then
      tmpSQL := 'select bu,dno,cno,sno,purcno,pursno,suppno,supplier from mps650' + ' where bu=' + Quotedstr(g_UInfo^.BU) +
        ' and len(isnull(cno,''''))>0' + ' and sno is not null' + ' and isnull(isfinish,0)=0' +
        ' and purcno='+QuotedStr(CDS.FieldByName('purcno').AsString)
    else
      Exit;
  end
  else
  tmpSQL := 'select bu,dno,cno,sno,purcno,pursno,suppno,supplier from mps650' + ' where bu=' + Quotedstr(g_UInfo^.BU) +
    ' and len(isnull(cno,''''))>0' + ' and sno is not null' + ' and isnull(isfinish,0)=0' +
    ' and len(isnull(purcno,''''))=0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

    if ShowMsg('確定[' + btn_mpst650D.Caption + ']嗎?', 33) = IDCancel then
      Exit;

    //每次更新50筆
    i := 1;
    loopCnt := Ceil(tmpCDS1.RecordCount / 50);
    while i <= loopCnt do
    begin
      tmpNum1 := tmpCDS1.RecNo;
      tmpNum2 := i * 50;
      if tmpNum2 > tmpCDS1.RecordCount then
        tmpNum2 := tmpCDS1.RecordCount;

      g_StatusBar.Panels[0].Text := CheckLang('正在更新[' + IntToStr(tmpNum1) + '..' + IntToStr(tmpNum2) + ']');
      Application.ProcessMessages;

      Data := null;
      tmpSQL := '';
      while not tmpCDS1.Eof do
      begin
        tmpSQL := tmpSQL + ' or (pmn24=' + Quotedstr(tmpCDS1.FieldByName('cno').AsString) + ' and pmn25=' + IntToStr(tmpCDS1.FieldByName
          ('sno').AsInteger) + ')';
        tmpCDS1.Next;
        if tmpCDS1.Eof or (tmpCDS1.RecNo > tmpNum2) then
          Break;
      end;

      Delete(tmpSQL, 1, 3);
      tmpSQL := 'select pmn01,pmn02,pmn24,pmn25,pmm09 from ' + g_UInfo^.BU + '.pmm_file,' + g_UInfo^.BU + '.pmn_file' +
        ' where pmm01=pmn01 and pmmacti=''Y'' and (' + tmpSQL + ')';
      tmpSQL := 'select t.*,occ02 from (' + tmpSQL + ') t left join ' + g_UInfo^.BU + '.occ_file on pmm09=occ01';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;

      tmpCDS2.Data := Data;
      if not tmpCDS2.IsEmpty then
      begin
        tmpCDS1.RecNo := tmpNum1;
        while tmpCDS1.RecNo <= tmpNum2 do
        begin
          if tmpCDS2.Locate('pmn24;pmn25', VarArrayOf([tmpCDS1.FieldByName('cno').AsString, tmpCDS1.FieldByName('sno').AsInteger]),
            []) then
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('purcno').AsString := tmpCDS2.FieldByName('pmn01').AsString;
            tmpCDS1.FieldByName('pursno').AsInteger := tmpCDS2.FieldByName('pmn02').AsInteger;
            if Length(tmpCDS1.FieldByName('suppno').AsString) = 0 then
            begin
              tmpCDS1.FieldByName('suppno').AsString := tmpCDS2.FieldByName('pmm09').AsString;
              tmpCDS1.FieldByName('supplier').AsString := tmpCDS2.FieldByName('occ02').AsString;
            end;
            tmpCDS1.Post;
          end;

          tmpCDS1.Next;
          if tmpCDS1.Eof then
            Break;
        end;
      end;
      Inc(i);
    end;

    if CDSPost(tmpCDS1, p_TableName) then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.btn_mpst650EClick(Sender: TObject);
var
  i, j, loopCnt: Integer;
  tmpNum1, tmpNum2: Integer;
  tmpSQL, code1_2, code1_3, code3, code3_7, code4_7, lstcode4, lstcode8: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
  tmpList: TStrings;
begin
  inherited;
  tmpSQL := 'select bu,dno,pno,notqty from mps650' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and isnull(isfinish,0)=0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpList := TStringList.Create;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

    if ShowMsg('確定[' + btn_mpst650E.Caption + ']嗎?', 33) = IDCancel then
      Exit;

    //每次更新50筆
    i := 1;
    loopCnt := Ceil(tmpCDS1.RecordCount / 50);
    while i <= loopCnt do
    begin
      tmpNum1 := tmpCDS1.RecNo;
      tmpNum2 := i * 50;
      if tmpNum2 > tmpCDS1.RecordCount then
        tmpNum2 := tmpCDS1.RecordCount;

      g_StatusBar.Panels[0].Text := CheckLang('正在更新[' + IntToStr(tmpNum1) + '..' + IntToStr(tmpNum2) + ']');
      Application.ProcessMessages;

      tmpList.Clear;
      Data := null;
      while not tmpCDS1.Eof do
      begin
        tmpSQL := tmpCDS1.FieldByName('pno').AsString;
        if Length(tmpSQL) = 18 then
        begin
          tmpSQL := Copy(tmpSQL, 1, 15);  //去掉后3碼,第3碼A=C、J=G, 第4-7碼2313=3313
          code1_2 := Copy(tmpSQL, 1, 2);
          code1_3 := Copy(tmpSQL, 1, 3);
          code3 := Copy(tmpSQL, 3, 1);
          code3_7 := Copy(tmpSQL, 3, 5);
          code4_7 := Copy(tmpSQL, 4, 4);
          lstcode4 := Copy(tmpSQL, 4, 20);
          lstcode8 := Copy(tmpSQL, 8, 20);

          if Pos(code3_7, 'A2313,A3313,C2313,C3313') > 0 then
          begin
            tmpSQL := code1_2 + 'A2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'A3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3_7, 'J2313,J3313,G2313,G3313') > 0 then
          begin
            tmpSQL := code1_2 + 'J2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'J3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3, 'AC') > 0 then
          begin
            tmpSQL := code1_2 + 'A' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3, 'JG') > 0 then
          begin
            tmpSQL := code1_2 + 'J' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code4_7, '2313,3313') > 0 then
          begin
            tmpSQL := code1_3 + '2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_3 + '3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if tmpList.IndexOf(tmpSQL) = -1 then
            tmpList.Add(tmpSQL);
        end
        else if tmpList.IndexOf(tmpSQL) = -1 then
          tmpList.Add(tmpSQL);

        tmpCDS1.Next;
      end;

      tmpSQL := '';
      for j := 0 to tmpList.Count - 1 do
        tmpSQL := tmpSQL + ' or oeb04=' + Quotedstr(tmpList.Strings[j]);

      Delete(tmpSQL, 1, 3);
      tmpSQL := 'select oeb04,sum(qty) as qty from (' + ' select case when length(oeb04)=18 then case' +
        ' when substr(oeb04,3,5) in (''A2313'',''C3313'') then concat(concat(substr(oeb04,1,2),''A2313''),substr(oeb04,8,8))'
        +
        ' when substr(oeb04,3,5) in (''J2313'',''G3313'') then concat(concat(substr(oeb04,1,2),''J2313''),substr(oeb04,8,8))'
        + ' when substr(oeb04,3,1) in (''A'',''C'') then concat(concat(substr(oeb04,1,2),''A''),substr(oeb04,4,12))' +
        ' when substr(oeb04,3,1) in (''J'',''G'') then concat(concat(substr(oeb04,1,2),''J''),substr(oeb04,4,12))' +
        ' when substr(oeb04,4,4) in (''2313'',''3313'') then concat(concat(substr(oeb04,1,3),''2313''),substr(oeb04,8,8))'
        + ' else substr(oeb04,1,15) end else oeb04 end as oeb04,' + ' (oeb12-oeb24)*oeb05_fac as qty' + ' from ' +
        g_UInfo^.BU + '.oea_file,' + g_UInfo^.BU + '.oeb_file' +
        ' where oea01=oeb01 and oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y''' + ' and oeb12>0 and oeb12>oeb24' +
        ' and oea04 not in (''N005'',''N012'')' + ' and substr(oea01,1,3) not in (''228'',''22B'')' + ' and (' + tmpSQL
        + ')) t group by oeb04';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;

      tmpCDS2.Data := Data;
      if not tmpCDS2.IsEmpty then
      begin
        tmpCDS1.RecNo := tmpNum1;
        while tmpCDS1.RecNo <= tmpNum2 do
        begin
          tmpSQL := tmpCDS1.FieldByName('pno').AsString;
          if Length(tmpSQL) = 18 then
          begin
            tmpSQL := Copy(tmpSQL, 1, 15);
            if Pos(Copy(tmpSQL, 3, 5), 'A2313,A3313,C2313,C3313') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'A2313' + Copy(tmpSQL, 8, 20)
            else if Pos(Copy(tmpSQL, 3, 5), 'J2313,J3313,G2313,G3313') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'J2313' + Copy(tmpSQL, 8, 20)
            else if Pos(Copy(tmpSQL, 3, 1), 'AC') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'A' + Copy(tmpSQL, 4, 20)
            else if Pos(Copy(tmpSQL, 3, 1), 'JG') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'J' + Copy(tmpSQL, 4, 20)
            else
              tmpSQL := StringReplace(tmpSQL, '3313', '2313', []);
          end;

          tmpCDS1.Edit;
          if tmpCDS2.Locate('oeb04', tmpSQL, []) then
            tmpCDS1.FieldByName('notqty').AsFloat := tmpCDS2.FieldByName('qty').AsFloat
          else
            tmpCDS1.FieldByName('notqty').Clear;
          tmpCDS1.Post;

          tmpCDS1.Next;
          if tmpCDS1.Eof then
            Break;
        end;
      end;
      Inc(i);
    end;

    if CDSPost(tmpCDS1, p_TableName) then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.btn_mpst650FClick(Sender: TObject);
var
  i, j, loopCnt: Integer;
  tmpNum1, tmpNum2: Integer;
  tmpSQL, code1_2, code1_3, code3, code3_7, code4_7, lstcode4, lstcode8: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
  tmpList: TStrings;
begin
  inherited;
  tmpSQL := 'select bu,dno,pno,stkqty from mps650' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and isnull(isfinish,0)=0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpList := TStringList.Create;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

    if ShowMsg('確定[' + btn_mpst650F.Caption + ']嗎?', 33) = IDCancel then
      Exit;

    //每次更新50筆
    i := 1;
    loopCnt := Ceil(tmpCDS1.RecordCount / 50);
    while i <= loopCnt do
    begin
      tmpNum1 := tmpCDS1.RecNo;
      tmpNum2 := i * 50;
      if tmpNum2 > tmpCDS1.RecordCount then
        tmpNum2 := tmpCDS1.RecordCount;

      g_StatusBar.Panels[0].Text := CheckLang('正在更新[' + IntToStr(tmpNum1) + '..' + IntToStr(tmpNum2) + ']');
      Application.ProcessMessages;

      tmpList.Clear;
      Data := null;
      while not tmpCDS1.Eof do
      begin
        tmpSQL := tmpCDS1.FieldByName('pno').AsString;
        if Length(tmpSQL) = 18 then
        begin
          tmpSQL := Copy(tmpSQL, 1, 15);  //去掉后3碼,第3碼A=C、J=G, 第4-7碼2313=3313
          code1_2 := Copy(tmpSQL, 1, 2);
          code1_3 := Copy(tmpSQL, 1, 3);
          code3 := Copy(tmpSQL, 3, 1);
          code3_7 := Copy(tmpSQL, 3, 5);
          code4_7 := Copy(tmpSQL, 4, 4);
          lstcode4 := Copy(tmpSQL, 4, 20);
          lstcode8 := Copy(tmpSQL, 8, 20);

          if Pos(code3_7, 'A2313,A3313,C2313,C3313') > 0 then
          begin
            tmpSQL := code1_2 + 'A2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'A3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3_7, 'J2313,J3313,G2313,G3313') > 0 then
          begin
            tmpSQL := code1_2 + 'J2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'J3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3, 'AC') > 0 then
          begin
            tmpSQL := code1_2 + 'A' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'C' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code3, 'JG') > 0 then
          begin
            tmpSQL := code1_2 + 'J' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_2 + 'G' + lstcode4;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if Pos(code4_7, '2313,3313') > 0 then
          begin
            tmpSQL := code1_3 + '2313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
            tmpSQL := code1_3 + '3313' + lstcode8;
            if tmpList.IndexOf(tmpSQL) = -1 then
              tmpList.Add(tmpSQL);
          end
          else if tmpList.IndexOf(tmpSQL) = -1 then
            tmpList.Add(tmpSQL);
        end
        else if tmpList.IndexOf(tmpSQL) = -1 then
          tmpList.Add(tmpSQL);

        tmpCDS1.Next;
      end;

      tmpSQL := '';
      for j := 0 to tmpList.Count - 1 do
        tmpSQL := tmpSQL + ' or img01=' + Quotedstr(tmpList.Strings[j]);

      Delete(tmpSQL, 1, 3);
      tmpSQL := 'select img01,sum(img10) as qty from (' + ' select case when length(img01)=18 then case' +
        ' when substr(img01,3,5) in (''A2313'',''C3313'') then concat(concat(substr(img01,1,2),''A2313''),substr(img01,8,8))'
        +
        ' when substr(img01,3,5) in (''J2313'',''G3313'') then concat(concat(substr(img01,1,2),''J2313''),substr(img01,8,8))'
        + ' when substr(img01,3,1) in (''A'',''C'') then concat(concat(substr(img01,1,2),''A''),substr(img01,4,12))' +
        ' when substr(img01,3,1) in (''J'',''G'') then concat(concat(substr(img01,1,2),''J''),substr(img01,4,12))' +
        ' when substr(img01,4,4) in (''2313'',''3313'') then concat(concat(substr(img01,1,3),''2313''),substr(img01,8,8))'
        + ' else substr(img01,1,15) end else img01 end as img01,img10' + ' from ' + g_UInfo^.BU + '.img_file' +
        ' where img10>0 and (' + tmpSQL + ')) t group by img01';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;

      tmpCDS2.Data := Data;
      if not tmpCDS2.IsEmpty then
      begin
        tmpCDS1.RecNo := tmpNum1;
        while tmpCDS1.RecNo <= tmpNum2 do
        begin
          tmpSQL := tmpCDS1.FieldByName('pno').AsString;
          if Length(tmpSQL) = 18 then
          begin
            tmpSQL := Copy(tmpSQL, 1, 15);
            if Pos(Copy(tmpSQL, 3, 5), 'A2313,A3313,C2313,C3313') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'A2313' + Copy(tmpSQL, 8, 20)
            else if Pos(Copy(tmpSQL, 3, 5), 'J2313,J3313,G2313,G3313') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'J2313' + Copy(tmpSQL, 8, 20)
            else if Pos(Copy(tmpSQL, 3, 1), 'AC') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'A' + Copy(tmpSQL, 4, 20)
            else if Pos(Copy(tmpSQL, 3, 1), 'JG') > 0 then
              tmpSQL := Copy(tmpSQL, 1, 2) + 'J' + Copy(tmpSQL, 4, 20)
            else
              tmpSQL := StringReplace(tmpSQL, '3313', '2313', []);
          end;

          tmpCDS1.Edit;
          if tmpCDS2.Locate('img01', tmpSQL, []) then
            tmpCDS1.FieldByName('stkqty').AsFloat := tmpCDS2.FieldByName('qty').AsFloat
          else
            tmpCDS1.FieldByName('stkqty').Clear;
          tmpCDS1.Post;

          tmpCDS1.Next;
          if tmpCDS1.Eof then
            Break;
        end;
      end;
      Inc(i);
    end;

    if CDSPost(tmpCDS1, p_TableName) then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.btn_mpst650GClick(Sender: TObject);
var
  tmpSQL: string;
begin
  inherited;
  if ShowMsg('確定[' + btn_mpst650G.Caption + ']嗎?', 33) = IDCancel then
    Exit;

  //云掉后3碼
  tmpSQL := 'update mps650 set mpsqty=x.sqty from (' + ' select pno,sum(sqty) sqty from(' +
    ' select left(materialno,len(materialno)-3) pno,sqty from mps070' + ' where bu=''ITEQDG'' and sdate>=' + Quotedstr(DateToStr
    (Date)) + ' and len(isnull(materialno,''''))>4 and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0' + ' union all' +
    ' select left(materialno,len(materialno)-3) pno,sqty sqty from mps010' + ' where bu=''ITEQDG'' and sdate>=' +
    Quotedstr(DateToStr(Date)) +
    ' and len(isnull(materialno,''''))>4 and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0' + ' union all' +
    ' select left(materialno,len(materialno)-3) pno,sqty sqty from mps012' + ' where bu=''ITEQDG'' and sdate>=' +
    Quotedstr(DateToStr(Date)) + ' and len(isnull(materialno,''''))>4 and isnull(isempty,0)=0) t group by pno) x' +
    ' where left(mps650.pno,len(mps650.pno)-3)=x.pno' + ' and isnull(isfinish,0)=0 and bu=' + Quotedstr(g_UInfo^.BU);
  if PostBySQL(tmpSQL) then
    ShowMsg(l_msg, 64);
end;

procedure TFrmMPST650.btn_mpst650IClick(Sender: TObject);
var
  i, loopCnt: Integer;
  tmpNum1, tmpNum2: Integer;
  tmpSQL: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  tmpSQL := 'select bu,dno,purcno,pursno,inqty from mps650' + ' where bu=' + Quotedstr(g_UInfo^.BU) +
    ' and isnull(isfinish,0)=0' + ' and len(isnull(purcno,''''))>0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

    if ShowMsg('確定[' + btn_mpst650I.Caption + ']嗎?', 33) = IDCancel then
      Exit;

    //每次更新50筆
    i := 1;
    loopCnt := Ceil(tmpCDS1.RecordCount / 50);
    while i <= loopCnt do
    begin
      tmpNum1 := tmpCDS1.RecNo;
      tmpNum2 := i * 50;
      if tmpNum2 > tmpCDS1.RecordCount then
        tmpNum2 := tmpCDS1.RecordCount;

      g_StatusBar.Panels[0].Text := CheckLang('正在更新[' + IntToStr(tmpNum1) + '..' + IntToStr(tmpNum2) + ']');
      Application.ProcessMessages;

      Data := null;
      tmpSQL := '';
      while not tmpCDS1.Eof do
      begin
        tmpSQL := tmpSQL + ' or (pmn01=' + Quotedstr(tmpCDS1.FieldByName('purcno').AsString) + ' and pmn02=' + IntToStr(tmpCDS1.FieldByName
          ('pursno').AsInteger) + ')';
        tmpCDS1.Next;
        if tmpCDS1.Eof or (tmpCDS1.RecNo > tmpNum2) then
          Break;
      end;

      Delete(tmpSQL, 1, 3);
      tmpSQL := 'select pmn01,pmn02,pmn53 from ' + g_UInfo^.BU + '.pmn_file' + ' where 1=1 and (' + tmpSQL + ')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;

      tmpCDS2.Data := Data;
      if not tmpCDS2.IsEmpty then
      begin
        tmpCDS1.RecNo := tmpNum1;
        while tmpCDS1.RecNo <= tmpNum2 do
        begin
          if tmpCDS2.Locate('pmn01;pmn02', VarArrayOf([tmpCDS1.FieldByName('purcno').AsString, tmpCDS1.FieldByName('pursno').AsInteger]),
            []) then
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('inqty').AsFloat := tmpCDS2.FieldByName('pmn53').AsFloat;
            tmpCDS1.Post;
          end;

          tmpCDS1.Next;
          if tmpCDS1.Eof then
            Break;
        end;
      end;
      Inc(i);
    end;

    if CDSPost(tmpCDS1, p_TableName) then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.btn_mpst650HClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if CDS.Active then
    str := CDS.FieldByName('pno').AsString;
  GetQueryStock(str, False);
end;

procedure TFrmMPST650.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
    Exit;

  if SameText(Column.FieldName, 'purqty') then
    case CDS.FieldByName('QtyColor').AsInteger of
      1:
        Background := clLime;
      2:
        Background := clYellow;
      3:
        Background := clFuchsia;
      4:
        Background := clAqua;
      5:
        Background := RGB(255, 165, 0);
    end;

  if SameText(Column.FieldName, 'date3') then
    if not CDS.FieldByName('date2').IsNull then
      if not CDS.FieldByName('date3').IsNull then
        if CDS.FieldByName('date3').AsDateTime > CDS.FieldByName('date2').AsDateTime then
          Background := clRed;
end;

procedure TFrmMPST650.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Shift = [ssCtrl]) and (Key = 70) then               //Ctrl+F 查找
  begin
    if not Assigned(FrmFind) then
      FrmFind := TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS := Self.CDS;
      g_Columns := Self.DBGridEh1.Columns;
      if Self.DBGridEh1.SelectedIndex <> 0 then
        g_DefFname := Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname := 'cdate,sno,pursno,units,purqty,qty,date1,date2,date3,date4,' +
        'outqty,notqty,stkqty,mpsqty,orderdate,orderitem,isfinish';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end;
end;

procedure TFrmMPST650.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST650.btn_mpst650JClick(Sender: TObject);
begin
  inherited;
  SetQtyColor(1);
end;

procedure TFrmMPST650.btn_mpst650KClick(Sender: TObject);
begin
  inherited;
  SetQtyColor(2);
end;

procedure TFrmMPST650.btn_mpst650LClick(Sender: TObject);
begin
  inherited;
  SetQtyColor(3);
end;

procedure TFrmMPST650.btn_mpst650MClick(Sender: TObject);
begin
  inherited;
  SetQtyColor(4);
end;

procedure TFrmMPST650.btn_mpst650NClick(Sender: TObject);
begin
  inherited;
  SetQtyColor(5);
end;

procedure TFrmMPST650.btn_mpst650OClick(Sender: TObject);
begin
  inherited;
  FrmMPST650_sum := TFrmMPST650_sum.Create(nil);
  try
    FrmMPST650_sum.ShowModal;
  finally
    FreeAndNil(FrmMPST650_sum);
  end;
end;

procedure TFrmMPST650.btn_mpst650PClick(Sender: TObject);
var
  i, j, row, maxRow: Integer;
  tmpSQL, tmpStr, tmpCno, tmpSno: string;
  isFind: Boolean;
  tmpDefDate: TDateTime;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  ExcelApp: Variant;
  OpenDialog: TOpenDialog;
  tmpList: TStrings;
begin
  inherited;
  OpenDialog := TOpenDialog.Create(nil);
  OpenDialog.Filter := CheckLang('Excel檔案(*.xlsx)|*.xlsx|Excel檔案(*.xls)|*.xls');
  if not OpenDialog.Execute then
  begin
    FreeAndNil(OpenDialog);
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  tmpList := TStringList.Create;
  ExcelApp := CreateOleObject('Excel.Application');
  try
    RefreshGrdCaptionX;
    for i := 0 to 10 do
      tmpList.Add('0');

    ExcelApp.WorkBooks.Open(OpenDialog.FileName);
    ExcelApp.WorkSheets[1].Activate;
    j := ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i := 1 to j do
    begin
      tmpStr := Trim(ExcelApp.Cells[1, i].Value);

      if DBGridEh1.FieldColumns['Cno'].Title.Caption = tmpStr then
        tmpList.Strings[0] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Sno'].Title.Caption = tmpStr then
        tmpList.Strings[1] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date1'].Title.Caption = tmpStr then
        tmpList.Strings[2] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date2'].Title.Caption = tmpStr then
        tmpList.Strings[3] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date3'].Title.Caption = tmpStr then
        tmpList.Strings[4] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date4'].Title.Caption = tmpStr then
        tmpList.Strings[5] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date5'].Title.Caption = tmpStr then
        tmpList.Strings[6] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date6'].Title.Caption = tmpStr then
        tmpList.Strings[7] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Date7'].Title.Caption = tmpStr then
        tmpList.Strings[8] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Adate'].Title.Caption = tmpStr then
        tmpList.Strings[9] := IntToStr(i)
      else if DBGridEh1.FieldColumns['Adate_new'].Title.Caption = tmpStr then
        tmpList.Strings[10] := IntToStr(i);
    end;

    if (tmpList.Strings[0] = '0') or (tmpList.Strings[1] = '0') then
    begin
      ShowMsg('Excel表找不到請購單號或項次欄位!', 48);
      Exit;
    end;

    isFind := False;
    for i := 2 to 10 do
      if tmpList.Strings[i] <> '0' then
      begin
        isFind := True;
        Break;
      end;

    if not isFind then
    begin
      ShowMsg('Excel表找不到可更新的日期欄位!', 48);
      Exit;
    end;

    //tmpList欄位與tmpCDS欄位順序對應
    tmpSQL := 'Select Cno,Sno,Date1,Date2,Date3,Date4,Date5,Date6,Date7,Adate,Adate_new,Bu,Dno' +
      ' From MPS650 Where Isfinish=0 and Bu=' + Quotedstr(g_UInfo^.Bu);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;

    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('作業無資料!', 48);
      Exit;
    end;

    row := 2;
    maxRow := ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    tmpDefDate := EncodeDate(2010, 1, 1);
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := maxRow;
    g_ProgressBar.Visible := True;
    while row <= maxRow do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;
      Application.ProcessMessages;

      j := StrToInt(tmpList.Strings[0]);
      tmpCno := ExcelApp.Cells[row, j].Value;

      j := StrToInt(tmpList.Strings[1]);
      tmpSno := ExcelApp.Cells[row, j].Value;

      if (Length(tmpCno) <> 10) or (StrToIntDef(tmpSno, 0) <= 0) then
      begin
        ShowMsg('第' + IntToStr(row) + '筆請購單號或項次錯誤!', 48);
        Exit;
      end;

      if tmpCDS.Locate('cno;sno', VarArrayOf([tmpCno, tmpSno]), []) then
        for i := 2 to tmpList.Count - 1 do
        begin
          j := StrToInt(tmpList.Strings[i]);
          if j > 0 then
          begin
            tmpCDS.Edit;
            tmpStr := ExcelApp.Cells[row, j].Value;
            if Length(tmpStr) > 0 then
            begin
              if StrToDateDef(tmpStr, tmpDefDate) <= tmpDefDate then
              begin
                ShowMsg('第' + IntToStr(row) + '筆,第' + IntToStr(j) + '列日期錯誤:' + tmpStr, 48);
                Exit;
              end;

              tmpCDS.Fields[i].Value := tmpStr;
            end
            else
              tmpCDS.Fields[i].Clear;
            tmpCDS.Post;
          end;
        end;

      Inc(row);
    end;

    if tmpCDS.ChangeCount = 0 then
    begin
      ShowMsg('無資料可更新!', 48);
      Exit;
    end;

    if PostBySQLFromDelta(tmpCDS, p_TableName, 'Bu,Dno') then
    begin
      ShowMsg('更新完畢!', 48);
      Exit;
    end;

  finally
    g_ProgressBar.Visible := False;
    FreeAndNil(OpenDialog);
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;

procedure TFrmMPST650.btn_mpst650QClick(Sender: TObject);
var
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  tmpSQL := 'select bu,dno,Suppno,PurCno,PurSno,SupplyOrderNo,SupplyOrderItem,SupplyPno from mps650' + ' where bu=' +
    Quotedstr(g_UInfo^.BU) + ' and len(isnull(PurCno,''''))>0' + ' and PurSno is not null' + ' and isnull(isfinish,0)=0'
    + ' and len(isnull(SupplyOrderNo,''''))=0 and Cdate>=''2022-4-22''';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

    tmpCDS.Filtered := true;
    if ShowMsg('確定[' + Tbitbtn(Sender).Caption + ']嗎?', 33) = IDCancel then
      Exit;
    tmpCDS.Filter := ' Suppno=''N024''';
    if not tmpCDS.IsEmpty then
      UpdateSupply('ITEQJX', tmpCDS);
//    tmpCDS.Filter := ' Suppno=''N006''';
//    if not tmpCDS.IsEmpty then
//      UpdateSupply('ITEQWX', tmpCDS);
//    tmpCDS.Filter := ' Suppno=''N023''';
//    if not tmpCDS.IsEmpty then
//      UpdateSupply('ITEQXP', tmpCDS);
//
//    tmpCDS.Filtered:=false;
    if CDSPost(tmpCDS, p_TableName) then
    begin
      ShowMsg(l_msg, 64);
      Exit;
    end;

  finally
    FreeAndNil(tmpCDS);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.UpdateSupply(bu: string; tmpCDS1: TClientDataSet);
var
  i, loopCnt: Integer;
  tmpNum1, tmpNum2: Integer;
  tmpSQL: string;
  tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    //每次更新50筆
    i := 1;
    loopCnt := Ceil(tmpCDS1.RecordCount / 50);
    while i <= loopCnt do
    begin
      tmpNum1 := tmpCDS1.RecNo;
      tmpNum2 := i * 50;
      if tmpNum2 > tmpCDS1.RecordCount then
        tmpNum2 := tmpCDS1.RecordCount;

      g_StatusBar.Panels[0].Text := CheckLang('正在更新[' + IntToStr(tmpNum1) + '..' + IntToStr(tmpNum2) + ']');
      Application.ProcessMessages;
      Data := null;
      tmpSQL := '';
      while not tmpCDS1.Eof do
      begin
        tmpSQL := tmpSQL + ' or (oea10=' + Quotedstr(tmpCDS1.FieldByName('PurCno').AsString) + ' and oeb03=' + IntToStr(tmpCDS1.FieldByName
          ('PurSno').AsInteger) + ')';
        tmpCDS1.Next;
        if tmpCDS1.Eof or (tmpCDS1.RecNo > tmpNum2) then
          Break;
      end;

      Delete(tmpSQL, 1, 3);
      tmpSQL := 'select oea10,oeb01,oeb03,oeb04 from ' + bu + '.oea_file,' + bu + '.oeb_file' +
        ' where oea01=oeb01 and oea04=''N005'' and (' + tmpSQL + ')';
//      ShowMsg(tmpSQL,48);
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;
      tmpCDS2.Data := Data;
      if not tmpCDS2.IsEmpty then
      begin
        tmpCDS1.RecNo := tmpNum1;
        while tmpCDS1.RecNo <= tmpNum2 do
        begin
          if tmpCDS2.Locate('oea10;oeb03', VarArrayOf([tmpCDS1.FieldByName('PurCno').AsString, tmpCDS1.FieldByName('PurSno').AsInteger]),
            []) then
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('SupplyOrderNo').AsString := tmpCDS2.FieldByName('oeb01').AsString;
            tmpCDS1.FieldByName('SupplyOrderItem').AsInteger := tmpCDS2.FieldByName('oeb03').AsInteger;
            tmpCDS1.FieldByName('SupplyPno').AsString := tmpCDS2.FieldByName('oeb04').AsString;
            tmpCDS1.Post;
          end;

          tmpCDS1.Next;
          if tmpCDS1.Eof then
            Break;
        end;
      end;
      Inc(i);
    end;

  finally
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST650.btn_copyClick(Sender: TObject);
var
  i: Integer;
  list: TStrings;
  arrFNE: array of TFieldNotifyEvent;
begin
  SetLength(arrFNE, CDS.FieldCount);
  for i := 0 to CDS.FieldCount - 1 do
  begin
    arrFNE[i] := CDS.Fields[i].OnChange;
    CDS.Fields[i].OnChange := nil;
  end;
  list := TStringList.Create;
  try
    for i := 0 to CDS.FieldCount - 1 do
      list.Add(Trim(CDS.Fields[i].AsString));
    CDS.Append;
    for i := 0 to CDS.FieldCount - 1 do
      CDS.Fields[i].AsString := list.Strings[i];
//    CDS.OnNewRecord(CDS);
  finally
    FreeAndNil(list);
    for i := 0 to CDS.FieldCount - 1 do
      CDS.Fields[i].OnChange := arrFNE[i];
    arrFNE := nil;
  end;
end;

procedure TFrmMPST650.DBGridEh1DblClick(Sender: TObject);
var
  tmpSql: string;
  tmpCDS: TClientDataSet;
  data: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    exit;
  if not SameText(DBGridEh1.SelectedField.FieldName, 'purcno') then
    exit;
  tmpSql :=
    'select pmn01,pmn02,pmn24,pmn25,pmm09,occ02 from %0:s.pmm_file,%0:s.pmn_file,%0:s.occ_file where pmm01=pmn01 and pmm09=occ01 and pmmacti=''Y''and pmn24=''%1:s'' and pmn25=%2:d';
  tmpSql := Format(tmpSql, [g_UInfo.BU, CDS.FieldByName('cno').AsString, CDS.FieldByName('sno').asinteger]);
  if QueryBySQL(tmpSql, data, 'ORACLE') then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := data;
      CDS.Edit;
      CDS.FieldByName('purcno').AsString := tmpCDS.FieldByName('pmn01').AsString;
      CDS.FieldByName('pursno').AsInteger := tmpCDS.FieldByName('pmn02').AsInteger;
      if Length(CDS.FieldByName('suppno').AsString) = 0 then
      begin
        CDS.FieldByName('suppno').AsString := tmpCDS.FieldByName('pmm09').AsString;
        CDS.FieldByName('supplier').AsString := tmpCDS.FieldByName('occ02').AsString;
      end;
      CDS.Post;
      CDSPost(CDS, p_TableName);
    finally
      tmpCDS.free;
    end;
  end;
end;

procedure TFrmMPST650.N1Click(Sender: TObject);
begin
  inherited;
  btn_mpst650DClick(Sender);
end;

end.

