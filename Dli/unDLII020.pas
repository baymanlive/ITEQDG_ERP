{*******************************************************}
{                                                       }
{                unDLII020                              }
{                Author: kaikai                         }
{                Create date: 2015/5/28                 }
{                Description: 出貨單列印                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, ToolWin, unDLII020_sale, unDLII020_prn, unDLII020_btnopt, unDLII020_const, ADODB;

type
  TFrmDLII020 = class(TFrmSTDI041)
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
    DS3: TDataSource;
    CDS3: TClientDataSet;
    DBGridEh3: TDBGridEh;
    btn_dlii020M: TBitBtn;
    btn_dlii020N: TBitBtn;
    btn_dlii020O: TBitBtn;
    btn_dlii020P: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    btn_dlii020Q: TBitBtn;
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
    procedure btn_dlii020QClick(Sender: TObject);
    procedure btn_dlii020RClick(Sender: TObject);
    procedure btn_dlii020SClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    l_StrIndex, l_StrIndexDesc, l_sql2, l_sql3: string;
    l_opt, l_bool2: Boolean;
    l_SelList, l_list2, l_list3: TStrings;
    l_prn: TDLII020_prn;
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
  FrmDLII020: TFrmDLII020;

implementation

uses
  unGlobal, unCommon, unDLII020_upd, unDLII020_qrcode, unDLII020_prnconf, unDLII020_selectsaleno, unDLII020_lotgo,
  unDLII020_AC172, unDLI020_AC109, unDLII020_AC145, unDLII020_AC101, unDLII020_ACC58, unDLII020_AC365, StrUtils, unDLII020_AC117, unUtf8;

const
  l_tb2 = 'DLI020';
  const l_Xml3='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="manfac" fieldtype="string" WIDTH="50"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLII020.SetBtnEnabled(bool: Boolean);
var
  i: Integer;
begin
  for i := 0 to PnlRight.ControlCount - 1 do
    if PnlRight.Controls[i] is TBitBtn then
      (PnlRight.Controls[i] as TBitBtn).Enabled := bool;
end;

procedure TFrmDLII020.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  //g_CocData:coc匯入的資料
  tmpSQL := 'Select * From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.Bu) + ' ' + strFilter +
    ' And Left(Pno,1) in (''E'',''T'')' + ' And IsNull(QtyColor,0)<>' + IntToStr(g_CocData) +
    ' And IsNull(GarbageFlag,0)=0 And Indate<=(Select Max(Indate)' + ' From MPS320 Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ')';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := tmpSQL + ' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
//  if SameText(g_uinfo^.UserId,'ID150515') then
//    tmpsql:='Select * From DLI010 Where Bu=''ITEQDG''  And (custno=''ac597'') '+ strFilter +
//            ' and (Convert(varchar(10),Indate,111)=''2023/08/15'') And Left(Pno,1) in (''E'',''T'') And ' +
//            ' IsNull(QtyColor,0)<>999 And IsNull(GarbageFlag,0)=0 '+
//            ' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLII020.RefreshDS2;
var
  tmpSQL: string;
begin
  tmpSQL := 'Select * ' + //  ' Case SFlag When 0 Then ''檢貨'' When 1 Then ''並包確認'' End SFlagX,' +
//  ' Case JFlag When 1 Then ''並包當中'' When 2 Then ''並包完成'' End JFlagX' +
    ' From ' + l_tb2 + ' Where Dno=' + Quotedstr(CDS.FieldByName('Dno').AsString) + ' And Ditem=' + IntToStr(CDS.FieldByName
    ('Ditem').AsInteger) + ' And Bu=' + Quotedstr(g_UInfo^.BU) + ' Order By Sno';
  if l_bool2 then
    tmpSQL := tmpSQL + ' ';
  l_list2.Insert(0, tmpSQL);
end;

procedure TFrmDLII020.RefreshDS3;
var
  tmpSQL: string;
begin
  tmpSQL := 'Select manfac,sum(qty) qty From DLI040 Where Dno=' + Quotedstr(CDS.FieldByName('Dno').AsString) +
    ' And Ditem=' + IntToStr(CDS.FieldByName('Ditem').AsInteger) + ' And Bu=' + Quotedstr(g_UInfo^.BU) +
    ' Group By manfac Order By manfac';
  l_list3.Insert(0, tmpSQL);
end;

procedure TFrmDLII020.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI010';
  p_GridDesignAns := True;
  p_SBText := CheckLang('二維碼標籤請按右側[二維碼]按扭列印');
  DBGridEh1.Parent := Panel2;
  PCL2.Parent := Panel2;
  PCL2.Height := 220;

  inherited;
  InitCDS(CDS3,l_Xml3);
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
  Timer1.Enabled := True;
  Timer2.Enabled := True;
  CMDDeleteFile(g_UInfo^.TempPath, 'bmp');
end;

procedure TFrmDLII020.FormClose(Sender: TObject; var Action: TCloseAction);
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
  FreeAndNil(l_btnopt);
  if Assigned(FrmDLII020_qrcode) then
    FreeAndNil(FrmDLII020_qrcode);
end;

procedure TFrmDLII020.btn_printClick(Sender: TObject);
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
  begin
    l_prn.StartPrint(UpperCase(Trim(FrmDLII020_prnconf.Edit1.Text)), CDS.fieldbyname('remark').AsString);
  end;
end;

procedure TFrmDLII020.btn_queryClick(Sender: TObject);
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

procedure TFrmDLII020.DBGridEh1CellClick(Column: TColumnEh);
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

procedure TFrmDLII020.CDSAfterScroll(DataSet: TDataSet);
begin
  if not l_opt then
  begin
    inherited;
    RefreshDS2;
    RefreshDS3;
  end;
end;

procedure TFrmDLII020.CDSBeforePost(DataSet: TDataSet);
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

procedure TFrmDLII020.CDSAfterPost(DataSet: TDataSet);
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

procedure TFrmDLII020.btn_dlii020AClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020BClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020CClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020DClick(Sender: TObject);
begin
  inherited;
  l_opt := True;
  SetBtnEnabled(False);
  try
    l_btnopt.SplitQtyAll(True);
  finally
    l_opt := False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020EClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020FClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020GClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020HClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  try
    if not AsSigned(FrmDLII020_qrcode) then
      FrmDLII020_qrcode := TFrmDLII020_qrcode.Create(Application);
    FrmDLII020_qrcode.Edit3.Text := '';
    FrmDLII020_qrcode.Memo1.Clear;
    {
    FrmDLII020_qrcode.cbJx.Checked :=
      (Pos('JX-',CDS.FieldByName('remark').AsString)>0) and
      (Pos('-AC101',CDS.FieldByName('remark').AsString)>0);   }

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

procedure TFrmDLII020.btn_dlii020IClick(Sender: TObject);
var
  ret: Integer;
  str: string;
begin
  inherited;
  SetBtnEnabled(False);
  FrmDLII020_selectsaleno := TFrmDLII020_selectsaleno.Create(nil);
  try
    if Sender = btn_dlii020I then
      FrmDLII020_selectsaleno.l_custno := 'AC096';
//    else if Sender=btn_dlii020Q then
//      FrmDLII020_selectsaleno.l_custno:='ACD53';
    ret := FrmDLII020_selectsaleno.ShowModal;
    str := FrmDLII020_selectsaleno.l_ret;
  finally
    SetBtnEnabled(True);
    FreeAndNil(FrmDLII020_selectsaleno);
  end;
  if ret = mrOk then
    l_prn.StartPrint(str, '');
end;

procedure TFrmDLII020.btn_dlii020JClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020KClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020LClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020MClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020NClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020OClick(Sender: TObject);
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

procedure TFrmDLII020.btn_dlii020PClick(Sender: TObject);
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

procedure TFrmDLII020.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLII020.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
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

procedure TFrmDLII020.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
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

procedure TFrmDLII020.CDS2AfterOpen(DataSet: TDataSet);
begin
  inherited;
  if SameText(CDS.FieldByName('custno').AsString, 'AC172') then
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

procedure TFrmDLII020.Timer1Timer(Sender: TObject);
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

procedure TFrmDLII020.Timer2Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
  tmp:TClientDataSet;
  i:integer;
begin
  Timer2.Enabled := False;
  tmp := TClientDataSet.Create(nil);
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
      tmp.Data := Data;
    CDS3.EmptyDataSet;
    while not tmp.Eof do
    begin
      CDS3.Append;
      for i:=0 to tmp.FieldCount - 1 do
        CDS3.Fields[i].Value := tmp.fieldbyname(CDS3.Fields[i].FieldName).Value;
      tmp.Next;
    end;
//    CDS3.Post;
//      CDS3.Data := Data;
  finally
    Timer2.Enabled := True;
    tmp.Free;
  end;
end;

procedure TFrmDLII020.btn_dlii020QClick(Sender: TObject);
var
  ArrPrintData: TArrPrintData;
  tmpcds1, tmpcds2: TClientDataSet;
  i: Integer;
begin
  if not CDS.Active then
    Exit;
  if CDS.IsEmpty then
    exit;
  tmpcds1 := TClientDataSet.Create(nil);
  tmpcds2 := TClientDataSet.Create(nil);
  try
    tmpcds1.FieldDefs.Assign(cds.FieldDefs);
    tmpcds1.CreateDataSet;
    tmpcds1.Append;
    for i := 0 to CDS.Fields.Count - 1 do
      tmpcds1.Fields[i].value := cds.Fields[i].Value;
                    //   manfac,sum(qty) qty

    tmpcds2.FieldDefs.Add('manfac', ftString, 50);
    tmpcds2.FieldDefs.Add('qty', ftString, 50);
    tmpcds2.FieldDefs.Add('ddate', ftString, 50);
    tmpcds2.FieldDefs.Add('qrcode', ftString, 500);
    tmpcds2.CreateDataSet;
    CDS3.First;
    while not CDS3.Eof do
    begin
      tmpcds2.Append;
      for i := 0 to CDS3.Fields.Count - 1 do
      begin
        tmpcds2.Fields[i].asstring := cds3.Fields[i].asstring;
        tmpcds2.FieldByName('ddate').asstring := GetPrdDate1(tmpcds2.FieldByName('manfac').asstring);                 
        {(*}
        tmpcds2.FieldByName('qrcode').asstring:=tmpcds1.FieldByName('Pno').asstring+','+
                                                tmpcds1.FieldByName('Custorderno').asstring+','+
                                                tmpcds1.FieldByName('Custprono').asstring+','+
                                                tmpcds2.FieldByName('manfac').asstring+','+
                                                tmpcds2.FieldByName('qty').asstring+','+
                                                tmpcds2.FieldByName('ddate').asstring;
        {*)}
      end;
      CDS3.Next;
    end;

    SetLength(ArrPrintData, 2);
    ArrPrintData[0].Data := tmpcds1.Data;
    ArrPrintData[0].RecNo := tmpcds1.RecNo;
    ArrPrintData[1].Data := tmpcds2.Data;
    ArrPrintData[1].RecNo := tmpcds2.RecNo;
    GetPrintObj('Dli', ArrPrintData, 'DLII020_BOX');
    ArrPrintData := nil;
  finally
    tmpcds1.Free;
    tmpcds2.free;
  end;
end;

procedure TFrmDLII020.btn_dlii020RClick(Sender: TObject);
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
    ShowMessage(tmpsql);
//    exit;
  end;
  if QueryBySQL(tmpsql, data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.data := data;
      if tmpCDS.IsEmpty then
      begin
        ShowMsg('沒有對應記錄');
        exit;
      end;
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
        if SameText(g_uinfo^.UserId, 'ID150515') then
        begin
          ShowMessage(tmpsql);
//          exit;
        end;
        qyjx.close;
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

procedure TFrmDLII020.btn_dlii020SClick(Sender: TObject);
begin
  AC117ZBPrint(cds,cds3,sender);
end;

procedure TFrmDLII020.DBGridEh1DblClick(Sender: TObject);
//var custno,custname, custpno, custpname,custpo,Remark:string;
begin
  inherited;
//  if CDS.Active and (not CDS.IsEmpty) then
//  begin
//    if SameText(DBGridEh1.SelectedField.FieldName,'Custorderno') then
//    begin
//      Remark:= cds.Fieldbyname('remark').AsString;
//      if JxRemark(Remark,custno,custname, custpno, custpname,custpo) then
//        InputQuery('提示','客戶訂單號',custpo);
//    end;
//  end;
end;

end.

