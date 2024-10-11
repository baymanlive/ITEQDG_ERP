{*******************************************************}
{                                                       }
{                unDLII020                              }
{                Author: kaikai                         }
{                Create date: 2015/5/28                 }
{                Description: 出貨單列印                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII021;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, ToolWin, unDLII020_sale, unDLII020_prn, unDLII020_btnopt, unDLII020_const, ADODB;

type
  TFrmDLII021 = class(TFrmSTDI041)
    Panel2: TPanel;
    btn_dlii020A: TBitBtn;
    btn_dlii020B: TBitBtn;
    btn_dlii020C: TBitBtn;
    btn_dlii020D: TBitBtn;
    btn_dlii020E: TBitBtn;
    btn_dlii020F: TBitBtn;
    btn_dlii020G: TBitBtn;
    btn_dlii020H: TBitBtn;
    btn_dlii020I: TBitBtn;
    PnlRight: TPanel;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    DBGridEh2: TDBGridEh;
    btn_dlii020J: TBitBtn;
    btn_dlii020K: TBitBtn;
    btn_dlii020L: TBitBtn;
    PCL2: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    btn_dlii020M: TBitBtn;
    btn_dlii020N: TBitBtn;
    btn_dlii020O: TBitBtn;
    btn_dlii020P: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    btn_dlii020R: TBitBtn;
    ConnJx: TADOConnection;
    qyjx: TADOQuery;
    btn_dlii020S: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State:
      TGridDrawState);
    procedure btn_dlii020AClick(Sender: TObject);
    procedure btn_dlii020BClick(Sender: TObject);
    procedure btn_dlii020CClick(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_dlii020EClick(Sender: TObject);
    procedure btn_dlii020FClick(Sender: TObject);
    procedure btn_dlii020GClick(Sender: TObject);
    procedure btn_dlii020DClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure btn_dlii020HClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_dlii020IClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure btn_dlii020JClick(Sender: TObject);
    procedure CDS2AfterOpen(DataSet: TDataSet);
    procedure btn_dlii020KClick(Sender: TObject);
    procedure btn_dlii020LClick(Sender: TObject);
    procedure btn_dlii020MClick(Sender: TObject);
    procedure btn_dlii020NClick(Sender: TObject);
    procedure btn_dlii020OClick(Sender: TObject);
    procedure btn_dlii020PClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure btn_dlii020RClick(Sender: TObject);
    procedure btn_dlii020SClick(Sender: TObject);
  private
    l_StrIndex, l_StrIndexDesc, l_sql2, l_sql3: string;
    l_opt, l_bool2: Boolean;
    l_SelList, l_list2, l_list3: TStrings;
    l_prn, l_prn1: TDLII020_prn;
    l_btnopt: TDLII020_btnopt;
    procedure SetBtnEnabled(Bool: Boolean);
    procedure RefreshDS2;
    procedure RefreshDS3;
    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLII021: TFrmDLII021;

implementation

uses
  unGlobal, unCommon, unDLII020_upd, unDLII020_qrcode, unDLII020_prnconf, unDLII020_selectsaleno, unDLII020_lotgo,
  unDLII020_AC172, unDLI020_AC109, unDLII020_AC145, unDLII020_AC101, unDLII020_ACC58, unDLII020_AC365, strutils,
  unDLII020_AC117;

const
  l_tb2 = 'DLI020';

{$R *.dfm}

procedure TFrmDLII021.SetBtnEnabled(bool: Boolean);
var
  i: Integer;
begin
  for i := 0 to PnlRight.ControlCount - 1 do
    if PnlRight.Controls[i] is TBitBtn then
      (PnlRight.Controls[i] as TBitBtn).Enabled := bool;
end;

procedure TFrmDLII021.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  //g_CocData:coc匯入的資料
  tmpSQL := 'Select * From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.Bu) + ' ' + strFilter +
    ' And Left(Pno,1) not in (''E'',''T'')' + ' And IsNull(QtyColor,0)<>' + IntToStr(g_CocData) +
    ' And IsNull(GarbageFlag,0)=0 And Indate<=(Select Max(Indate)' + ' From MPS320 Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ')';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := tmpSQL + ' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLII021.RefreshDS2;
var
  tmpSQL: string;
begin
  tmpSQL := 'Select *,Case SFlag When 0 Then ''檢貨'' When 1 Then ''並包確認'' End SFlagX,' +
    ' Case JFlag When 1 Then ''並包當中'' When 2 Then ''並包完成'' End JFlagX' + ' From ' + l_tb2 + ' Where Dno=' +
    Quotedstr(CDS.FieldByName('Dno').AsString) + ' And Ditem=' + IntToStr(CDS.FieldByName('Ditem').AsInteger) +
    ' And Bu=' + Quotedstr(g_UInfo^.BU) + ' Order By Sno';
  if l_bool2 then
    tmpSQL := tmpSQL + ' ';
  l_list2.Insert(0, tmpSQL);
end;

procedure TFrmDLII021.RefreshDS3;
var
  tmpSQL: string;
begin
  tmpSQL := 'Select manfac,sum(qty) qty From DLI040' + ' Where Dno=' + Quotedstr(CDS.FieldByName('Dno').AsString) +
    ' And Ditem=' + IntToStr(CDS.FieldByName('Ditem').AsInteger) + ' And Bu=' + Quotedstr(g_UInfo^.BU) +
    ' Group By manfac Order By manfac';
  l_list3.Insert(0, tmpSQL);
end;

procedure TFrmDLII021.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI010';
  p_GridDesignAns := True;
  p_SBText := '二維碼標籤請按右側[二維碼]按扭列印'; //CheckLang('二維碼標籤請按右側[二維碼]按扭列印');
  DBGridEh1.Parent := Panel2;
  PCL2.Parent := Panel2;
  PCL2.Height := 220;

  inherited;

  SetGrdCaption(DBGridEh2, l_tb2);
  SetGrdCaption(DBGridEh3, 'dli040');
  TabSheet1.Caption := CheckLang('資材批號');
  TabSheet2.Caption := CheckLang('COC批號');
  SetPnlRightBtn(PnlRight, False);
  l_SelList := TStringList.Create;
  l_list2 := TStringList.Create;
  l_list3 := TStringList.Create;
  l_prn := TDLII020_prn.Create;
  l_btnopt := TDLII020_btnopt.Create;
  CMDDeleteFile(g_UInfo^.TempPath, 'bmp');
  Timer1.Enabled := True;
  Timer2.Enabled := True
end;

procedure TFrmDLII021.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  Timer2.Enabled := False;

  inherited;

  CDS2.Active := False;
  CDS3.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  FreeAndNil(l_SelList);
  FreeAndNil(l_list2);
  FreeAndNil(l_list3);
  FreeAndNil(l_prn);
    FreeAndNil(l_prn1);
  FreeAndNil(l_btnopt);
  if Assigned(FrmDLII020_qrcode) then
    FreeAndNil(FrmDLII020_qrcode);
end;

procedure TFrmDLII021.btn_printClick(Sender: TObject);
var
  tmpStr: string;
begin
  //inherited;
  if CDS.Active and (Length(Trim(CDS.FieldByName('Saleno').AsString)) > 0) then
    tmpStr := Trim(CDS.FieldByName('Saleno').AsString);
  if not Assigned(FrmDLII020_prnconf) then
    FrmDLII020_prnconf := TFrmDLII020_prnconf.Create(Application);
  FrmDLII020_prnconf.Edit1.Text := tmpStr;
  if FrmDLII020_prnconf.ShowModal = mrOK then
    l_prn.StartPrint(UpperCase(Trim(FrmDLII020_prnconf.Edit1.Text)), CDS.fieldbyname('remark').AsString);
end;

procedure TFrmDLII021.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    if Pos('Qry_ppccl', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
    if Pos('Qry_isbz', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr) = 0 then
      tmpStr := tmpStr + ' And Indate>=' + Quotedstr(DateToStr(Date));
    l_SelList.Clear;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLII021.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Dno').AsString + '@' + CDS.FieldByName('Ditem').AsString;
    if l_SelList.IndexOf(tmpStr) = -1 then
      l_SelList.Add(tmpStr)
    else
      l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;

  if SameText(Column.FieldName, 'prn_ans') then
  begin
    CDS.Edit;
    CDS.FieldByName('Prn_ans').AsBoolean := not CDS.FieldByName('Prn_ans').AsBoolean;
    CDS.Post;
  end;
end;

procedure TFrmDLII021.CDSAfterScroll(DataSet: TDataSet);
begin
  if not l_opt then
  begin
    inherited;
    RefreshDS2;
    RefreshDS3;
  end;
end;

procedure TFrmDLII021.CDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if l_opt then
    Exit;

  if (CDS.State in [dsEdit]) and CDS.FieldByName('Prn_ans').AsBoolean and (Length(CDS.FieldByName('Saleno').AsString) =
    0) then
  begin
    ShowMsg('未產生出貨單,不能更改[列印]狀態!', 48);
    CDS.CancelUpdates;
    Abort;
  end;
end;

procedure TFrmDLII021.CDSAfterPost(DataSet: TDataSet);
var
  tmpBool: Boolean;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if l_opt then
    Exit;

  tmpBool := CDS.FieldByName('Prn_ans').AsBoolean;

  if (not tmpBool) and (Length(CDS.FieldByName('Saleno').AsString) = 0) then
  begin
    PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno,Ditem');
    Exit;
  end;

  tmpSQL := 'Select Bu,Dno,Ditem,Prn_ans From Dli010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Saleno=' +
    Quotedstr(CDS.FieldByName('Saleno').AsString);
  if QueryBySQL(tmpSQL, Data) then
  begin
    l_opt := True;
    CDS.DisableControls;
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          Edit;
          FieldByName('Prn_ans').AsBoolean := tmpBool;
          Post;
          Next;
        end;

      if PostBySQLFromDelta(tmpCDS, p_TableName, 'Bu,Dno,Ditem') then
      begin
        CDS.MergeChangeLog;
        if (tmpCDS.RecordCount = 1) and (CDS.FieldByName('Dno').AsString = tmpCDS.FieldByName('Dno').AsString) and (CDS.FieldByName
          ('Ditem').AsInteger = tmpCDS.FieldByName('Ditem').AsInteger) then
          Exit;   //只有一筆
        //多筆,更新其它項次打印狀態
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            if CDS.Locate('Dno;Ditem', VarArrayOf([Fields[1].AsString, Fields[2].AsString]), []) then
            begin
              CDS.Edit;
              CDS.FieldByName('Prn_ans').AsBoolean := tmpBool;
              CDS.Post;
            end;
            Next;
          end;
        end;
        if CDS.ChangeCount > 0 then
          CDS.MergeChangeLog;
      end
      else
        CDS.CancelUpdates;

    finally
      l_opt := False;
      CDS.EnableControls;
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII021.btn_dlii020AClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    DLII020_sale(CDS, l_SelList);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020BClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    if l_btnopt.UpdateLot(CDS, CDS2) then
    begin
      l_bool2 := True;
      try
        RefreshDS2;
      finally
        l_bool2 := False;
      end;
    end;
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020CClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    l_btnopt.SplitQty(CDS);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020DClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    l_btnopt.SplitQtyAll(False);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020EClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    l_btnopt.DeleteSaleNo(CDS);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020FClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    l_btnopt.DeleteSaleItem(CDS);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020GClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    if l_btnopt.DeleteLot(CDS, CDS2) then
    begin
      l_bool2 := True;
      try
        RefreshDS2;
      finally
        l_bool2 := False;
      end;
    end;
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020HClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);

  try
    if not AsSigned(FrmDLII020_qrcode) then
      FrmDLII020_qrcode := TFrmDLII020_qrcode.Create(Application);
    FrmDLII020_qrcode.Edit3.Text := '';
    FrmDLII020_qrcode.Memo1.Clear;
    if Length(Self.CDS.FieldByName('Saleno').AsString) > 0 then
    begin
      FrmDLII020_qrcode.Edit1.Text := Self.CDS.FieldByName('Saleno').AsString;
      FrmDLII020_qrcode.Edit2.Text := IntToStr(Self.CDS.FieldByName('SaleItem').AsInteger);
    end
    else
    begin
      FrmDLII020_qrcode.Edit1.Text := '';
      FrmDLII020_qrcode.Edit2.Text := '';
    end;
    FrmDLII020_qrcode.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020IClick(Sender: TObject);
var
  ret: Integer;
  str: string;
begin
  inherited;
  SetBtnEnabled(False);
  FrmDLII020_selectsaleno := TFrmDLII020_selectsaleno.Create(nil);
  try
    ret := FrmDLII020_selectsaleno.ShowModal;
    str := FrmDLII020_selectsaleno.l_ret;
  finally
    SetBtnEnabled(True);
    FreeAndNil(FrmDLII020_selectsaleno);
  end;
  if ret = mrOk then
    l_prn.StartPrint(str, '');
end;

procedure TFrmDLII021.btn_dlii020JClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  FrmDLII020_lotgo := TFrmDLII020_lotgo.Create(nil);
  try
    FrmDLII020_lotgo.l_dno := Self.CDS.FieldByName('dno').AsString;
    FrmDLII020_lotgo.l_ditem := Self.CDS.FieldByName('ditem').AsInteger;
    FrmDLII020_lotgo.l_remark := Self.CDS.FieldByName('remark').AsString;
    FrmDLII020_lotgo.ShowModal;
  finally
    FreeAndNil(FrmDLII020_lotgo);
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020KClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  FrmDLII020_AC172 := TFrmDLII020_AC172.Create(nil);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_AC172.Edit1.Text := CDS.FieldByName('Saleno').AsString;
    FrmDLII020_AC172.ShowModal;
  finally
    FreeAndNil(FrmDLII020_AC172);
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020LClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  FrmDLII020_AC109 := TFrmDLII020_AC109.Create(nil);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_AC109.Edit1.Text := CDS.FieldByName('Saleno').AsString;
    FrmDLII020_AC109.ShowModal;
  finally
    FreeAndNil(FrmDLII020_AC109);
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020MClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmDLII020_AC145) then
    FrmDLII020_AC145 := TFrmDLII020_AC145.Create(Application);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_AC145.Edit1.Text := CDS.FieldByName('Saleno').AsString
    else
      FrmDLII020_AC145.Edit1.Text := '';
    FrmDLII020_AC145.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020NClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmDLII020_AC101) then
    FrmDLII020_AC101 := TFrmDLII020_AC101.Create(Application);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_AC101.Edit1.Text := CDS.FieldByName('Saleno').AsString
    else
      FrmDLII020_AC101.Edit1.Text := '';
    FrmDLII020_AC101.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020OClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmDLII020_ACC58) then
    FrmDLII020_ACC58 := TFrmDLII020_ACC58.Create(Application);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_ACC58.Edit1.Text := CDS.FieldByName('Saleno').AsString
    else
      FrmDLII020_ACC58.Edit1.Text := '';
    FrmDLII020_ACC58.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.btn_dlii020PClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmDLII020_AC365) then
    FrmDLII020_AC365 := TFrmDLII020_AC365.Create(Application);
  try
    if Length(CDS.FieldByName('Saleno').AsString) > 0 then
      FrmDLII020_AC365.Memo1.Text := CDS.FieldByName('Saleno').AsString
    else
      FrmDLII020_AC365.Memo1.Text := '';
    FrmDLII020_AC365.Memo2.Text := '';
    FrmDLII020_AC365.PCL.ActivePageIndex := 0;
    FrmDLII020_AC365.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII021.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLII021.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
    Exit;
  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString)) > 0 then  //拆單
    AFont.Color := clBlue;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
    AFont.Color := clRed;
end;

procedure TFrmDLII021.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Dno').AsString + '@' + CDS.FieldByName('Ditem').AsString;
    if l_SelList.IndexOf(tmpStr) <> -1 then
      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
  end;
end;

procedure TFrmDLII021.CDS2AfterOpen(DataSet: TDataSet);
begin
  inherited;
  if SameText(CDS.FieldByName('custno').AsString, 'ACC58') then
  begin
    DBGridEh2.FieldColumns['lotsn'].Visible := True;
    DBGridEh2.FieldColumns['boxsn'].Visible := False;
  end
  else if SameText(CDS.FieldByName('custno').AsString, 'AC172') then
  begin
    DBGridEh2.FieldColumns['lotsn'].Visible := True;
    DBGridEh2.FieldColumns['boxsn'].Visible := True;
  end
  else
  begin
    DBGridEh2.FieldColumns['lotsn'].Visible := False;
    DBGridEh2.FieldColumns['boxsn'].Visible := False;
  end;
end;

procedure TFrmDLII021.Timer1Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Timer1.Enabled := False;
  try
    if l_List2.Count = 0 then
      Exit;

    while l_List2.Count > 1 do
      l_List2.Delete(l_List2.Count - 1);

    tmpSQL := l_List2.Strings[0];
    if (not l_bool2) and (tmpSQL = l_SQL2) then
      Exit;
    l_SQL2 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      CDS2.Data := Data;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TFrmDLII021.Timer2Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Timer2.Enabled := False;
  try
    if l_List3.Count = 0 then
      Exit;

    while l_List3.Count > 1 do
      l_List3.Delete(l_List3.Count - 1);

    tmpSQL := l_List3.Strings[0];
    if tmpSQL = l_SQL3 then
      Exit;
    l_SQL3 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      CDS3.Data := Data;
  finally
    Timer2.Enabled := True;
  end;
end;

procedure TFrmDLII021.btn_dlii020RClick(Sender: TObject);
var
  sql, tmpsql, remark, custno, endogb31, endogb32, saleno: string;
  tmpCDS: TClientdataset;
  data: OleVariant;
begin
  remark := CDS.fieldbyname('remark').asstring;
  custno := rightstr(remark, 5);
  endogb31 := Copy(remark, 4, 10);
  endogb32 := copy(remark, 15, Length(remark) - 20);
  saleno := CDS.fieldbyname('saleno').asstring;

  if Length(saleno) = 0 then
    if IDNO = Application.MessageBox('沒有出貨單號,是否繼續?', '錯誤', MB_YESNO + MB_ICONSTOP) then
      exit;
  tmpsql :=
    'select fname3,fname13,fname4,b.sno from dli041 a join lbl590 b on b.id=a.fname13 where Dno=%s and Ditem=%d and Bu=%s';
  tmpsql := Format(tmpsql, [Quotedstr(CDS.FieldByName('Dno').AsString), CDS.FieldByName('Ditem').AsInteger, Quotedstr(g_UInfo
    ^.BU)]);
  if SameText(g_uinfo^.UserId, 'ID150515') then
  begin
    ShowMsg(tmpsql);
    exit;
  end;
  if QueryBySQL(tmpsql, data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.data := data;
      tmpsql := '';
      connjx.Connected := True;
      try
        while not tmpCDS.Eof do
        begin
          sql :=
            'insert friends_factory_scan_file(guids,companyno,ogb01,endogb31,endogb32,ogblot,ogb12,labelid,customerqr)values(%s,%s,%s,%s,%s,%s,%s,%s,%s)';
          sql := format(sql, [quotedstr(guid), quotedstr(custno), quotedstr(saleno), quotedstr(endogb31), quotedstr(endogb32),
            quotedstr(tmpCDS.fieldbyname('fname3').asstring), quotedstr(tmpCDS.fieldbyname('fname4').asstring),
            quotedstr(tmpCDS.fieldbyname('fname13').asstring), quotedstr(tmpCDS.fieldbyname('sno').asstring)]);
          tmpsql := tmpsql + sql + #13;
          tmpCDS.next;
        end;
        sql := 'select 1 from friends_factory_scan_file where endogb31=' + quotedstr(endogb31) + ' and endogb32=' +
          quotedstr(endogb32);
        if SameText(g_uinfo^.UserId, 'ID150515') then
        begin
          ShowMsg(tmpsql);
        end;
        qyjx.Close;
        qyjx.SQL.Text := sql;
        qyjx.Open;

        if not qyjx.IsEmpty then
        begin
          if IDYES = Application.MessageBox('已存在拋轉數據,是否刪除舊數據?', '提示', MB_YESNO + MB_ICONQUESTION) then
          begin
            tmpsql := 'delete from friends_factory_scan_file where endogb31=' + quotedstr(endogb31) + ' and endogb32=' +
              quotedstr(endogb32) + #13 + tmpsql;
          end;
        end;

        qyjx.close;

        if SameText(g_uinfo^.UserId, 'ID150515') then
        begin
          ShowMsg(tmpsql);
        end;
        ConnJx.Execute(tmpsql);
        ShowMsg('拋轉成功', 48);
      finally
        connjx.Connected := False;
        tmpCDS.free;
      end;
    except
      on ex: Exception do
      begin
        ShowMsg('拋轉失敗,請重試'#13 + ex.Message, 48);
      end;
    end;
  end;
end;

procedure TFrmDLII021.btn_dlii020SClick(Sender: TObject);
//var
//  ArrPrintData: TArrPrintData;
//  tmp, tmp2: TClientDataSet;
//  i: Integer;
//  sql, remark, dno, ditem, sno, custPo, custPno, mfgdate, qrcode,oea04: string;
//  data: olevariant;
begin
  AC117ZBPrint(cds, cds3, Sender);
//  if not CDS.Active then
//    Exit;
//  if CDS.IsEmpty then
//    exit;
//  remark := CDS.fieldbyname('remark').AsString;
//  if (pos('AC117', remark) = 0) and (pos('ACC19', remark) = 0) then
//  begin
//    showmsg('僅限廣合使用');
//    exit;
//  end;
//
//  sql := 'exec proc_GetLBLSno '''',''AC117zb''';
//
//  if not QueryOneCR(sql, data) then
//    exit;
//  sno := vartostr(data);
//  dno := copy(remark, 4, 10);
//  remark := copy(remark, 15, 255);  //JX-222-370042-1-AC117
//  i := pos('-', remark);
//  ditem := copy(remark, 1, i - 1);
//
//  tmp := TClientDataSet.Create(nil);
//  tmp2 := TClientDataSet.Create(nil);
//  try

    //    sql := 'select oea04,oea10,oeb01,oeb11,ta_oeb10,occ02 from iteqjx.oea_file,iteqjx.oeb_file,iteqjx.occ_file where oea01=oeb01 and oea04=occ01 and oea01=' +
//      quotedstr(dno) + ' and oeb03='+ quotedstr(ditem);
//    if not querybysql(sql, data, 'ORACLE') then
//      exit;
//    tmp.data := data;
//    oea04 := tmp.fieldbyname('oea04').asstring;
//    dno := tmp.fieldbyname('oea10').asstring;
//    ditem := tmp.fieldbyname('oeb01').asstring;
//    custPno := tmp.fieldbyname('oeb11').asstring;
//
//    tmp2.FieldDefs.Add('lot', ftString, 50);
//    tmp2.FieldDefs.Add('dno', ftString, 50);
//    tmp2.FieldDefs.Add('qty', ftString, 50);
//    tmp2.FieldDefs.Add('sno', ftString, 50);
//    tmp2.FieldDefs.Add('pno', ftString, 50);
//    tmp2.FieldDefs.Add('oea04', ftString, 50);
//    tmp2.FieldDefs.Add('ta_oeb10', ftString, 200);
//    tmp2.FieldDefs.Add('custpno', ftString, 50);
//    tmp2.FieldDefs.Add('qrcode', ftString, 1000);
//    tmp2.CreateDataSet;
//    cds3.DisableControls;
//    cds3.First;
//    while not cds3.eof do
//    begin
//      tmp2.Append;
//      tmp2.FieldByName('qty').AsString := cds3.fieldbyname('qty').asstring;
//      tmp2.FieldByName('dno').AsString := dno;
//      tmp2.FieldByName('oea04').AsString := oea04;
//      tmp2.FieldByName('pno').AsString := cds.fieldbyname('pno').asstring;
//      tmp2.FieldByName('custpno').AsString := tmp.fieldbyname('oeb11').asstring;
//      tmp2.FieldByName('ta_oeb10').AsString := tmp.fieldbyname('ta_oeb10').asstring;
//      tmp2.FieldByName('lot').AsString := cds3.fieldbyname('manfac').asstring;
//      if not QueryOneCR('exec proc_GetLBLSno '''',''AC117zb''', data) then
//        exit;
//      tmp2.FieldByName('sno').AsString := vartostr(data);
//      tmp2.post;
//      cds3.next;
//    end;
//
//    SetLength(ArrPrintData, 2);
//    ArrPrintData[0].data := tmp2.Data;
//    ArrPrintData[0].RecNo := tmp2.RecNo;
//    ArrPrintData[1].data := cds3.Data;
//    ArrPrintData[1].RecNo := cds3.RecNo;
//    GetPrintObj('Dli', ArrPrintData, 'DLII020_ZB');
//  finally
//    ArrPrintData := nil;
//    tmp.Free;
//    tmp2.free;
//    cds3.EnableControls;
//  end;
end;

end.

