{*******************************************************}
{                                                       }
{                unDLIR050                              }
{                Author: kaikai                         }
{                Create date: 2015/10/13                }
{                Description: COC明細表                 }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR050;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ComCtrls, ToolWin, unDLII041_rpt, unDLII040_rpt, unDLIR050_units,
  Math, StrUtils;

type
  TFrmDLIR050 = class(TFrmSTDI041)
    btn_dlir050A: TToolButton;
    btn_dlir050B: TToolButton;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_dlir050AClick(Sender: TObject);
    procedure btn_dlir050BClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure CheckBox1Click(Sender: TObject);
  private
    l_index: Integer;
    l_custno, l_lot, l_carno: string;
    l_indate1, l_indate2: TDateTime;
    l_DLII041_rpt: TDLII041_rpt;
    l_DLII040_rpt: TDLII040_rpt;
    l_tmpCDS1, l_tmpCDS2, l_tmpCDS3: TClientDataSet;
    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLIR050: TFrmDLIR050;


implementation

uses
  unGlobal, unCommon, unDLIR050_Query, unDLIR050_prn, unDLII040_cocerr;

{$R *.dfm}

//5天一次查詢
//proc_DLIR050參數:公司別、出貨日期起、出貨日期迄、客戶編號、批號、0:PP 1:CCL
procedure TFrmDLIR050.RefreshDS(strFilter: string);
var
  d1, d2: TDateTime;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  if strFilter = g_cFilterNothing then
  begin
    tmpSQL := 'exec proc_DLIR050_v2 ''no'',''1955-5-5'',''1955-5-5'',''@@'',''@'',0,''@''';
    if QueryBySQL(tmpSQL, Data) then
      CDS.Data := Data;
  end
  else
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      d1 := l_indate1;
      d2 := l_indate1;
      while d2 <= l_indate2 do
      begin
        d2 := d1 + 7;
        if d2 > l_indate2 then
          d2 := l_indate2;

        g_StatusBar.Panels[0].Text := CheckLang('正在查詢:' + DateToStr(d1) + '~' + DateToStr(d2) + ',請等待...');
        Application.ProcessMessages;

        Data := Null;
        tmpSQL := 'exec proc_DLIR050_v2 ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(DateToStr(d1)) + ',' + QuotedStr(DateToStr(d2)) + ',' + QuotedStr(l_custno) + ',' + QuotedStr(l_lot) + ',' + IntToStr(l_index) + ',' + QuotedStr(l_carno);
        if QueryBySQL(tmpSQL, Data) then
        begin
          if not VarIsNull(Data) then
          begin
            if tmpCDS.Active then
              tmpCDS.AppendData(Data, True)
            else
              tmpCDS.Data := Data;
          end;
        end;

        d1 := d2 + 1;
        d2 := d1;
      end;

      if tmpCDS.Active then
        CDS.Data := tmpCDS.Data;

    finally
      FreeAndNil(tmpCDS);
      g_StatusBar.Panels[0].Text := '';
    end;
  end;

  inherited;
end;

procedure TFrmDLIR050.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLIR050';
  p_GridDesignAns := True;
  btn_quit.Left := btn_dlir050B.Width + btn_dlir050B.Left;

  inherited;

  CheckBox1.Caption := CheckLang('全選');
  l_tmpCDS1 := TClientDataSet.Create(Self);
  l_tmpCDS2 := TClientDataSet.Create(Self);
  l_tmpCDS3 := TClientDataSet.Create(Self);
end;

procedure TFrmDLIR050.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_DLII041_rpt) then
    FreeAndNil(l_DLII041_rpt);
  if Assigned(l_DLII040_rpt) then
    FreeAndNil(l_DLII040_rpt);
  FreeAndNil(l_tmpCDS1);
  FreeAndNil(l_tmpCDS2);
  FreeAndNil(l_tmpCDS3);
end;

procedure TFrmDLIR050.btn_printClick(Sender: TObject);
var
  tmpStr: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  ArrPrintData: TArrPrintData;
begin
  //inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料', 48);
    Exit;
  end;

  if not Assigned(FrmDLIR050_prn) then
    FrmDLIR050_prn := TFrmDLIR050_prn.Create(Application);
  if FrmDLIR050_prn.ShowModal = mrCancel then
    Exit;

  if FrmDLIR050_prn.RadioGroup1.ItemIndex = 1 then
  begin
    if (not CDS.Active) or CDS.IsEmpty then
    begin
      ShowMsg('請選擇列印資料', 48);
      Exit;
    end;

    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := CDS.Data;
      with tmpCDS do
      begin
        Filtered := False;
        Filter := 'select=1';
        Filtered := True;
        if IsEmpty then
        begin
          ShowMsg('請選擇列印資料', 48);
          Exit;
        end;
        First;
      end;

      if SameText(tmpCDS.FieldByName('custno').AsString, 'N005') or SameText(tmpCDS.FieldByName('custno').AsString, 'N012') then
      begin
        tmpStr := LeftStr(tmpCDS.FieldByName('remark').AsString, Pos('-', tmpCDS.FieldByName('remark').AsString) - 1);
        if Length(tmpStr) > 0 then
        begin
          tmpStr := 'select occ02 from ' + g_UInfo^.BU + '.occ_file where occ01=' + QuotedStr(tmpStr);
          if QueryOneCR(tmpStr, Data, 'ORACLE') then
            if not VarIsNull(Data) then
            begin
              tmpStr := VarToStr(Data);
              with tmpCDS do
              begin
                First;
                while not Eof do
                begin
                  Edit;
                  FieldByName('custshort').AsString := tmpStr;
                  Post;
                  Next;
                end;
                MergeChangeLog;
              end;
            end;
        end;
      end;

      SetLength(ArrPrintData, 1);
      ArrPrintData[0].Data := tmpCDS.Data;
      ArrPrintData[0].RecNo := 1;
      ArrPrintData[0].IndexFieldNames := '';
      ArrPrintData[0].Filter := tmpCDS.Filter;
      GetPrintObj('DLI', ArrPrintData);
      ArrPrintData := nil;
    finally
      FreeAndNil(tmpCDS);
    end;
  end
  else
  begin
    if Pos(Copy(CDS.FieldByName('Pno').AsString, 1, 1), 'ET') = 0 then
    begin
      if not Assigned(l_DLII041_rpt) then
        l_DLII041_rpt := TDLII041_rpt.Create(CDS);
      l_DLII041_rpt.StartPrint('DLII041','');
    end
    else
    begin
      if not Assigned(l_DLII040_rpt) then
        l_DLII040_rpt := TDLII040_rpt.Create(CDS);
      l_DLII040_rpt.StartPrint('DLII040');
    end;
  end;
end;

procedure TFrmDLIR050.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR050_Query) then
    FrmDLIR050_Query := TFrmDLIR050_Query.Create(Application);
  if FrmDLIR050_Query.ShowModal = mrOK then
  begin
    l_index := FrmDLIR050_Query.RadioGroup1.ItemIndex;
    l_indate1 := FrmDLIR050_Query.Dtp1.Date;
    l_indate2 := FrmDLIR050_Query.Dtp2.Date;
    l_custno := Trim(FrmDLIR050_Query.Edit1.Text + '/' + FrmDLIR050_Query.Edit3.Text);
    l_lot := Trim(FrmDLIR050_Query.Edit2.Text);
    l_carno := Trim(FrmDLIR050_Query.Edit4.Text);
    RefreshDS('');
  end;
end;

procedure TFrmDLIR050.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmDLII040_cocerr) then
    FrmDLII040_cocerr := TFrmDLII040_cocerr.Create(Application);
  FrmDLII040_cocerr.l_Coc_errid := CDS.FieldByName('coc_errid').AsString;
  FrmDLII040_cocerr.ShowModal;
end;

procedure TFrmDLIR050.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('coc_err').AsBoolean then
    AFont.Color := clFuchsia;
end;

//只更新廣合(AC117)、廣合-2(ACC19)
procedure TFrmDLIR050.btn_dlir050AClick(Sender: TObject);
const
  l_diff = 0.000001;
var
  tmpSQL: string;
  tmpCDS, Ima_CDS: TClientDataSet;
  Data: OleVariant;
  flag: boolean;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  if ShowMsg('只更新廣合、廣合-2重量與面積,確定更新嗎?', 33) = IdCancel then
    Exit;

  g_StatusBar.Panels[0].Text := CheckLang('正在更新,請等待...');
  Application.ProcessMessages;
  tmpCDS := TClientDataSet.Create(nil);
  Ima_CDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.First;
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := tmpCDS.RecNo;
    g_ProgressBar.Visible := True;
    with tmpCDS do
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;
        flag := (FieldByName('custno').AsString = 'AC117') or (FieldByName('custno').AsString = 'ACC19');
        if (Pos('AC117', FieldByName('remark').AsString) + Pos('ACC19', FieldByName('remark').AsString)) > 0 then
          flag := true;
        if flag then
          if Pos(FieldByName('pno').AsString, tmpSQL) = 0 then
            tmpSQL := tmpSQL + ' or Ima01=' + QuotedStr(FieldByName('pno').AsString);
        Next;
      end;

    if Length(tmpSQL) = 0 then
    begin
      ShowMsg('無廣合、廣合-2資料!', 48);
      Exit;
    end;

    tmpSQL := 'Select ima01,ima18,ta_ima01,ta_ima02' + ' From ' + g_UInfo^.BU + '.ima_file' + ' Where 1=2 ' + tmpSQL;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    Ima_CDS.Data := Data;

    g_ProgressBar.Position := 0;
    tmpCDS.First;
    with tmpCDS do
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

//        tmpStr := Copy(FieldByName('remark').AsString, 1, 5);
        if (FieldByName('custno').AsString = 'AC117') or (FieldByName('custno').AsString = 'ACC19') or (Pos('AC117',FieldByName('remark').AsString)>0) or (Pos('ACC19',FieldByName('remark').AsString)>0) then
          if Ima_CDS.Locate('ima01', FieldByName('pno').AsString, []) then
          begin
            Edit;
        //小板舊料號重量從存儲過程計算
            if Length(FieldByName('pno').AsString) in [11, 12] then
              FieldByName('kg').AsFloat := RoundTo(GetKG2(FieldByName('orderno').AsString, FieldByName('orderitem').AsInteger, 0), -3)
            else
            begin
              if SameText(FieldByName('units').AsString, 'RL') and (Length(FieldByName('pno').AsString) = 18) then
                FieldByName('kg').AsFloat := RoundTo(StrToInt(Copy(FieldByName('pno').AsString, 11, 3)) * Ima_CDS.FieldByName('ima18').AsFloat + l_diff, -3)
              else
                FieldByName('kg').AsFloat := Ima_CDS.FieldByName('ima18').AsFloat;
            end;
            FieldByName('tkg').AsFloat := RoundTo(FieldByName('qty').AsFloat * FieldByName('kg').AsFloat + l_diff, -3);

        //面積
            tmpSQL := Copy(FieldByName('pno').AsString, 1, 1); //第1碼
            if (tmpSQL = 'M') or (tmpSQL = 'N') then
              FieldByName('sf').AsFloat := RoundTo((StrToFloatDef(FieldByName('longitude').AsString, 0) * StrToFloatDef(FieldByName('latitude').AsString, 0)) / 144 + l_diff, -3)
            else if (tmpSQL = 'B') and (Length(FieldByName('pno').AsString) = 18) then
              FieldByName('sf').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat * StrToInt(Copy(FieldByName('pno').AsString, 11, 3))) / 144 + l_diff, -3)
            else if tmpSQL = 'R' then
              FieldByName('sf').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat * 39.37) / 144 + l_diff, -3)
            else
              FieldByName('sf').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat) / 144 + l_diff, -3);
            FieldByName('tsf').AsFloat := RoundTo(FieldByName('qty').AsFloat * FieldByName('sf').AsFloat + l_diff, -3);

            if FieldByName('sf').AsFloat <= 0 then
            begin
              FieldByName('sf').Clear;
              FieldByName('tsf').Clear;
            end;

            Post;
          end;

        Next;
      end;

    if tmpCDS.ChangeCount > 0 then
    begin
      tmpCDS.MergeChangeLog;
      CDS.Data := tmpCDS.Data;
    end;

    ShowMsg('更新完畢!', 64);
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(Ima_CDS);
    g_StatusBar.Panels[0].Text := '';
    g_ProgressBar.Visible := False;
  end;
end;

//更新兩角訂單客戶PO
procedure TFrmDLIR050.btn_dlir050BClick(Sender: TObject);
var
  pos1: Integer;
  tmpOraDB, tmpSQL, tmpStr, tmpFilter: string;
  tmpCDS, oea_CDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  if ShowMsg('只更兩角訂單客戶PO,確定更新嗎?', 33) = IdCancel then
    Exit;

  g_StatusBar.Panels[0].Text := CheckLang('正在更新,請等待...');
  Application.ProcessMessages;
  tmpCDS := TClientDataSet.Create(nil);
  oea_CDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.First;
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := tmpCDS.RecNo;
    g_ProgressBar.Visible := True;
    with tmpCDS do
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

        if Pos(LeftStr(FieldByName('orderno').AsString, 3), 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z') > 0 then
        begin
          tmpStr := FieldByName('remark').AsString;
          pos1 := Pos('-', tmpStr);
          if pos1 > 0 then
          begin
            tmpStr := Copy(tmpStr, pos1 + 1, 10); //訂單號碼
            if (Length(tmpStr) = 10) and (Pos('-', tmpStr) = 4) then
              tmpFilter := tmpFilter + ',' + QuotedStr(tmpStr);
          end;
        end;
        Next;
      end;

    if Length(tmpFilter) = 0 then
    begin
      ShowMsg('無兩角訂單資料!', 48);
      Exit;
    end;

    if SameText(g_UInfo^.BU, 'ITEQDG') then
      tmpOraDB := 'ITEQGZ'
    else
      tmpOraDB := 'ITEQDG';
    Delete(tmpFilter, 1, 1);
    tmpSQL := 'select oea01,oea10 from ' + tmpOraDB + '.oea_file where oea01 in (' + tmpFilter + ')';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;
    oea_CDS.Data := Data;

    g_ProgressBar.Position := 0;
    tmpCDS.First;
    with tmpCDS do
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

        if Pos(LeftStr(FieldByName('orderno').AsString, 3), 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z') > 0 then
        begin
          tmpStr := FieldByName('remark').AsString;
          pos1 := Pos('-', tmpStr);
          if pos1 > 0 then
          begin
            tmpStr := Copy(tmpStr, pos1 + 1, 10); //訂單號碼
            if (Length(tmpStr) = 10) and (Pos('-', tmpStr) = 4) then
              if oea_CDS.Locate('oea01', tmpStr, []) then
              begin
                Edit;
                FieldByName('custorderno').AsString := oea_CDS.FieldByName('oea10').AsString;
                Post;
              end;
          end;
        end;
        Next;
      end;

    if tmpCDS.ChangeCount > 0 then
    begin
      tmpCDS.MergeChangeLog;
      CDS.Data := tmpCDS.Data;
    end;

    ShowMsg('更新完畢!', 64);
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(oea_CDS);
    g_StatusBar.Panels[0].Text := '';
    g_ProgressBar.Visible := False;
  end;
end;

procedure TFrmDLIR050.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'select') then
  begin
    CDS.Edit;
    CDS.FieldByName('select').AsBoolean := not CDS.FieldByName('select').AsBoolean;
    CDS.Post;
    CDS.MergeChangeLog;
  end;
end;

procedure TFrmDLIR050.CheckBox1Click(Sender: TObject);
var
  tmpCDS: TClientDataSet;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean := TCheckBox(Sender).Checked;
        Post;
        Next;
      end;
      CDS.MergeChangeLog;
    end;
    CDS.Data := tmpCDS.Data;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.

