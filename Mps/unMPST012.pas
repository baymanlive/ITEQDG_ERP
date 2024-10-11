{*******************************************************}
{                                                       }
{                unMPSI010                              }
{                Author: kaikai                         }
{                Create date: 2015/12/20                }
{                Description: 主排程程式                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST012;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, Buttons, ExtCtrls, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, Math, unMPST012_Order,
  ADODB;

const
  l_Color1 = 16772300;  //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPST012 = class(TFrmSTDI030)
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    Edit3: TEdit;
    Label3: TLabel;
    PopupMenu1: TPopupMenu;
    N20: TMenuItem;
    N21: TMenuItem;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    btn_mpst012A: TBitBtn;
    btn_mpst012C: TBitBtn;
    btn_mpst012D: TBitBtn;
    btn_mpst012E: TBitBtn;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    DS3: TDataSource;
    CDS3: TClientDataSet;
    PopupMenu2: TPopupMenu;
    N31: TMenuItem;
    Edit4: TEdit;
    btn_mpst012F: TBitBtn;
    N32: TMenuItem;
    RG1: TRadioGroup;
    RG2: TRadioGroup;
    PnlRight: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    N1: TMenuItem;
    N23: TMenuItem;
    N22: TMenuItem;
    N24: TMenuItem;
    btn_mpst012L: TBitBtn;
    btn_mpst012H: TBitBtn;
    btn_mpst012I: TBitBtn;
    btn_mpst012J: TBitBtn;
    btn_mpst012G: TBitBtn;
    btn_mpst012K: TBitBtn;
    btn_mpst012N: TBitBtn;
    btn_mpst012O: TBitBtn;
    btn_mpst012P: TBitBtn;
    N2: TMenuItem;
    N34: TMenuItem;
    N33: TMenuItem;
    btn_mpst012Q: TBitBtn;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    btn_mpst070R: TButton;
    btn_mpst012S: TButton;
    btn_mpst012T: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RG1Click(Sender: TObject);
    procedure RG2Click(Sender: TObject);
    procedure btn_mpst012AClick(Sender: TObject);
    procedure btn_mpst012CClick(Sender: TObject);
    procedure btn_mpst012DClick(Sender: TObject);
    procedure btn_mpst012EClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure CDSAfterCancel(DataSet: TDataSet);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSAfterInsert(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDS2AfterScroll(DataSet: TDataSet);
    procedure PCLChange(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure DBGridEh3DblClick(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDS3AfterScroll(DataSet: TDataSet);
    procedure DBGridEh3TitleClick(Column: TColumnEh);
    procedure btn_mpst012FClick(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure btn_mpst012GClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure btn_mpst012IClick(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure btn_mpst012JClick(Sender: TObject);
    procedure btn_mpst012HClick(Sender: TObject);
    procedure btn_mpst012KClick(Sender: TObject);
    procedure btn_mpst012LClick(Sender: TObject);
    procedure btn_mpst012NClick(Sender: TObject);
    procedure btn_mpst012OClick(Sender: TObject);
    procedure btn_mpst012PClick(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure btn_mpst012QClick(Sender: TObject);
    procedure DBGridEh2Columns6UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure DBGridEh3Columns4UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText, Handled: Boolean);
    procedure btn_mpst012SClick(Sender: TObject);
    procedure DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer; Column: TColumnEh);
    procedure btn_mpst070RClick(Sender: TObject);
    procedure btn_mpst012TClick(Sender: TObject);
  private
    l_Ans: Boolean;
    l_Order: TMPST012_Order;
    l_SelList, l_ErrList, l_ColorList: TStrings; //選擇,錯誤提示,顏色
    l_StrIndex: string;
    l_StrIndexDesc: string;
    l_CDS670: TClientDataSet;
    l_CDS_Stock: TClientDataSet; // 訂單關聯庫存
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetEdit3;
    procedure RefreshColor;
    procedure GetSumQty;
    function GetMaxSno(sDate: TDateTime; var maxSno: Integer): Boolean;
    function SetCDS670(reopen: Boolean): Boolean;
    function InitCDSStock(): Boolean;
    function SaveOrderStockInfo(MDS: TClientDataSet; ODS: TClientDataSet): TClientDataSet;
    { Private declarations }
  public    { Public declarations }
    function GetGUID: string;
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST012: TFrmMPST012;


implementation

uses
  unGlobal, unCommon, unMPST010_ShowErrList, unMPST012_units, unFind,
  unMPST012_rqty, unMPST012_clear0, unMPST012_CtrlE, unMPST012_cqty,
  unMPST070_bom, unMPST012_adqty, unMPST012_adate_qty, unMPST012_PnoSum,
  unMPST012_copy, unMPST012_Stck, unMPST070_CalCCL;

const
  l_pk = 'bu,sdate,stype,sno';
  IndexFieldNames = 'Sdate;Stype;OZ;Thickness;Materialno;Sno';

{$R *.dfm}

function TFrmMPST012.GetGUID: string;
var
  LTep: TGUID;
  sGUID: string;
begin
  CreateGUID(LTep);
  sGUID := GUIDToString(LTep);
  sGUID := StringReplace(sGUID, '-', '', [rfReplaceAll]);
  sGUID := Copy(sGUID, 2, Length(sGUID) - 2);
  Result := sGUID;
end;

//過濾數據
procedure TFrmMPST012.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
begin
  l_SelList.Clear;
  btn_mpst012Q.Hint := '';
  with xCDS do
  begin
    Filtered := False;
    if xRG.ItemIndex = -1 then
      Filter := 'Stype=''@'''
    else
      Filter := '(not (not NotVisible=0)) and Stype=' + Quotedstr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

procedure TFrmMPST012.SetEdit3;
begin
  if PCL.ActivePageIndex = 0 then
  begin
    if CDS.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  end
  else if PCL.ActivePageIndex = 1 then
  begin
    if CDS2.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS2.FieldByName('Sdate').AsDateTime);
  end
  else
    Edit3.Text := '';
end;

procedure TFrmMPST012.RefreshColor;
var
  tmpSdate: TDateTime;
  tmpValue: string;
  tmpCDS: TClientdataset;
begin
  l_ColorList.Clear;
  if PCL.ActivePageIndex = 2 then
    Exit;
  tmpCDS := TClientdataset.Create(nil);
  try
    if PCL.ActivePageIndex = 0 then
    begin
      tmpCDS.Data := CDS.Data;
      tmpCDS.Filter := CDS.Filter;
      tmpCDS.Filtered := True;
      tmpCDS.IndexFieldNames := CDS.IndexFieldNames;
    end
    else if PCL.ActivePageIndex = 1 then
    begin
      tmpCDS.Data := CDS2.Data;
      tmpCDS.Filter := CDS2.Filter;
      tmpCDS.Filtered := True;
      tmpCDS.IndexFieldNames := CDS2.IndexFieldNames;
    end;
    tmpCDS.First;

    tmpValue := '1';
    tmpSdate := EncodeDate(2000, 1, 1);
    while not tmpCDS.Eof do
    begin
      if tmpSdate <> tmpCDS.FieldByName('Sdate').AsDateTime then
      begin
        if tmpValue = '1' then
          tmpValue := '2'
        else
          tmpValue := '1';
      end;
      l_ColorList.Add(tmpValue);
      tmpSdate := tmpCDS.FieldByName('Sdate').AsDateTime;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST012.GetSumQty;
var
  tmpSqty: Double;
  tmpStype, S9_11: string;
  tmpSdate: TDateTime;
  Qty1: Double;
  tmpCDS: TClientDataSet;
begin
  Edit4.Text := '0';
  if ((PCL.ActivePageIndex = 0) and CDS.IsEmpty) or ((PCL.ActivePageIndex = 1) and CDS2.IsEmpty) or (PCL.ActivePageIndex = 2) then
    Exit;

  if not SetCDS670(False) then
    Exit;

  Qty1 := 0;
  tmpStype := '@';
  tmpSdate := EncodeDate(2000, 1, 1);
  ;
  tmpCDS := TClientDataSet.Create(nil);
  try
    if PCL.ActivePageIndex = 0 then
    begin
      tmpStype := CDS.FieldByName('Stype').AsString;
      tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
      tmpCDS.Data := CDS.Data;
    end
    else if PCL.ActivePageIndex = 1 then
    begin
      tmpStype := CDS2.FieldByName('Stype').AsString;
      tmpSdate := CDS2.FieldByName('Sdate').AsDateTime;
      tmpCDS.Data := CDS2.Data;
    end;

    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'Stype=' + Quotedstr(tmpStype) + ' And Sdate=' + Quotedstr(DateToStr(tmpSdate));
      Filtered := True;
      while not Eof do
      begin
        if not FieldByName('NotVisible').AsBoolean then
        begin
          S9_11 := Copy(FieldByName('Materialno').AsString, 9, 3);
          l_CDS670.Filtered := False;
          l_CDS670.Filter := 'size_l<=' + Quotedstr(S9_11) + ' and size_h>=' + Quotedstr(S9_11);
          l_CDS670.Filtered := True;
          if l_CDS670.IsEmpty then
            tmpSqty := FieldByName('Sqty').AsFloat
          else
            tmpSqty := Ceil(FieldByName('Sqty').AsFloat / l_CDS670.FieldByName('d').AsInteger * l_CDS670.FieldByName('m').AsInteger);
          Qty1 := Qty1 + tmpSqty;
        end;
        Next;
      end;
    end;

    Edit4.Text := FloatToStr(Qty1);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

function TFrmMPST012.GetMaxSno(sDate: TDateTime; var maxSno: Integer): Boolean;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := False;
  maxSno := 0;

  tmpSQL := 'Select IsNull(Max(Sno),0)+1 as Sno From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Sdate=' + Quotedstr(DateToStr(sDate));
  if QueryOneCR(tmpSQL, Data) then
  begin
    maxSno := StrToIntDef(VarToStr(Data), 1);
    Result := True;
  end;
end;

function TFrmMPST012.SetCDS670(reopen: Boolean): Boolean;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := False;
  if reopen or (not l_CDS670.Active) then
  begin
    tmpSQL := 'select size_l,size_h,d,m from mps670 where bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    l_CDS670.Data := Data;
  end;

  Result := True;
end;

procedure TFrmMPST012.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin                                                        //pno2 for index
  tmpSQL := 'Select *,substring(materialno,2,len(materialno)-2)pno2 From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And IsNull(NotVisible,0)=0 ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST012.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS012';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  RG2.Tag := 1;
  l_CDS670 := TClientDataSet.Create(Self);
  l_CDS_Stock := TClientDataSet.Create(Self);

  inherited;

  GetMPSMachine;
  //CDS.IndexFieldNames := IndexFieldNames;
  CDS2.IndexFieldNames := CDS.IndexFieldNames;
  RG1.Items.DelimitedText := CheckLang(g_MPS012_Stype);
  RG2.Items.DelimitedText := CheckLang(g_MPS012_Stype);
  DBGridEh3.FieldColumns['stype'].PickList.DelimitedText := CheckLang(g_MPS012_Stype);

  btn_insert.Visible := False;
  btn_edit.Visible := False;
  btn_delete.Visible := False;
  btn_copy.Visible := False;
  btn_post.Visible := False;
  btn_cancel.Visible := False;
  ToolButton2.Visible := False;
  btn_print.Visible := False;

  TabSheet1.Caption := CheckLang('已確認排程');
  TabSheet2.Caption := CheckLang('預排結果');
  TabSheet3.Caption := CheckLang('待排訂單');
  Label3.Caption := CheckLang('生產日期/數量');

  btn_mpst012S.Caption := CheckLang('訂單關聯庫存');

  SetGrdCaption(DBGridEh2, p_TableName);
  SetGrdCaption(DBGridEh3, p_TableName);

  DBGridEh3.ReadOnly := not g_MInfo^.R_edit;

  CDS2.Data := CDS.Data;
  CDS2.EmptyDataSet;
  InitCDS(CDS3, g_xml);
  l_SelList := TStringList.Create;
  l_ErrList := TStringList.Create;
  l_ColorList := TStringList.Create;

  RG1.Tag := 0;
  RG2.Tag := 0;
  RG1.ItemIndex := 0;
  RG2.ItemIndex := 0;

  InitCDSStock();
  btn_mpst012S.Visible := false;
end;

procedure TFrmMPST012.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(FrmMPST070_CalCCL);
  FreeAndNil(l_CDS670);
  FreeAndNil(l_SelList);
  FreeAndNil(l_ErrList);
  FreeAndNil(l_ColorList);
  if Assigned(l_Order) then
    FreeAndNil(l_Order);

  FreeAndNil(l_CDS_Stock);

  CDS2.Active := False;
  CDS3.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmMPST012.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
//  inherited;
  if not GetQueryString(p_TableName, tmpStr) then
    Exit;

  RefreshDS(tmpStr);
  RefreshData(RG1, CDS);
  PCL.ActivePageIndex := 0;
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST012.btn_firstClick(Sender: TObject);
begin
  case PCL.ActivePageIndex of
    0:
      inherited;
    1:
      if CDS2.Active then
        CDS2.First;
    2:
      if CDS3.Active then
        CDS3.First;
  end;
end;

procedure TFrmMPST012.btn_priorClick(Sender: TObject);
begin
  case PCL.ActivePageIndex of
    0:
      inherited;
    1:
      if CDS2.Active then
        CDS2.Prior;
    2:
      if CDS3.Active then
        CDS3.Prior;
  end;
end;

procedure TFrmMPST012.btn_nextClick(Sender: TObject);
begin
  case PCL.ActivePageIndex of
    0:
      inherited;
    1:
      if CDS2.Active then
        CDS2.Next;
    2:
      if CDS3.Active then
        CDS3.Next;
  end;
end;

procedure TFrmMPST012.btn_lastClick(Sender: TObject);
begin
  case PCL.ActivePageIndex of
    0:
      inherited;
    1:
      if CDS2.Active then
        CDS2.Last;
    2:
      if CDS3.Active then
        CDS3.Last;
  end;
end;

procedure TFrmMPST012.btn_quitClick(Sender: TObject);
begin
  //inherited;
  case PCL.ActivePageIndex of
    0:
      if CDS.State in [dsInsert, dsEdit] then
        CDS.Cancel
      else
        Close;
    1:
      if CDS2.State in [dsInsert, dsEdit] then
        CDS2.Cancel
      else
        Close;
    2:
      if CDS3.State in [dsInsert, dsEdit] then
        CDS3.Cancel
      else
        Close;
  end;
end;

procedure TFrmMPST012.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  CDS.IndexFieldNames := IndexFieldNames;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST012.RG2Click(Sender: TObject);
begin
  inherited;
  if (not CDS2.Active) or (RG2.Tag = 1) then
    Exit;
  RefreshData(RG2, CDS2);
  RefreshColor;
  DBGridEh2.Repaint;
end;

procedure TFrmMPST012.btn_mpst012AClick(Sender: TObject);
var
  Data1: OleVariant;
  tmpCDS0: TClientDataSet;
begin
  inherited;
  tmpCDS0 := TClientDataSet.Create(nil);
  try
    tmpCDS0.Data := CDS2.Data;
    if tmpCDS0.Active and (not tmpCDS0.IsEmpty) then
      if ShowMsg('預排結果未確認,確定重新選擇訂單嗎?', 33) = IdCancel then
        Exit;
  finally
    FreeAndNil(tmpCDS0);
  end;

  if not Assigned(l_Order) then
    l_Order := TMPST012_Order.Create;
  Data1 := l_Order.GetData;
  if not VarIsNull(Data1) then
  begin
    RefreshGrdCaption(CDS3, DBGridEh3, l_StrIndex, l_StrIndexDesc);
    l_Ans := True;
    CDS3.Data := Data1;
    CDS2.EmptyDataSet;
    PCL.ActivePageIndex := 2;
    PCL.OnChange(PCL);
    l_Ans := False;
  end;
end;

procedure TFrmMPST012.btn_mpst012CClick(Sender: TObject);
var
  isNext, isOZLock, isNew: Boolean;
  i, tmpIsThin, tmpCDS670_D, tmpCDS670_M: Integer;
  tmpSdate, tmpMinSdate, tmpMaxSdate: TDateTime;
  sqty, tmpSqty, tmpSqty2, tmpMqty, tmpRemainQty, tmpRemainQtyX: Double;
  tmpSQL, S9_11, S12_14, tmpStype, tmpCustno, tmpAd: string;
  tmpCDS0, tmpCDS1, tmpCDS2, tmpCDS3, tmpCDS4, tmpCDS5, tmpCDS6, tmpCDS7, tmpCDS8, tmpCDS9, tmpCDS10, tmpCDS11: TClientDataSet;
  Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11: OleVariant;

  //特殊尺寸轉換標準尺寸

  function GetOtherSizeX(S9_S11: string): string;
  begin
    Result := S9_S11;
    with tmpCDS2 do
    begin
      First;
      while not Eof do
      begin
        if Pos('/' + S9_S11 + '/', Fields[0].AsString) > 0 then
        begin
          Result := Fields[1].AsString;
          Break;
        end;
        Next;
      end;
    end;
  end;

  //取鋼板編號
  function GetStealnoX(S9_S11, S12_S14: string): string;
  begin
    Result := '';
    with tmpCDS3 do
    begin
      First;
      while not Eof do
      begin
        if (S9_S11 >= Fields[1].AsString) and (S9_S11 <= Fields[2].AsString) and (S12_S14 >= Fields[3].AsString) and (S12_S14 <= Fields[4].AsString) then
        begin
          Result := Fields[0].AsString;
          Break;
        end;
        Next;
      end;
    end;
  end;

  //銅箔特殊格鎖定
  //Lock:為True時不考慮Sdate日期,
  //     為False時,則必需指定生產日期,並且≧Sdate
  function CheckOZLock(Materialno: string; var IsLock: Boolean; var Sdate: TDateTime): Boolean;
  var
    str2, str7_8, str9_11, str12_14, str16, str17: string;
  begin
    Result := False;
    IsLock := False;
    Sdate := EncodeDate(1955, 5, 5);

    str2 := Copy(Materialno, 2, 1);
    str7_8 := Copy(Materialno, 7, 2);
    str9_11 := Copy(Materialno, 9, 3);
    str12_14 := Copy(Materialno, 12, 3);
    str16 := Copy(Materialno, 16, 1);
    str17 := Copy(Materialno, 17, 1);
    with tmpCDS7 do
    begin
      Filtered := False;
      Filter := 'oz=' + QuotedStr(str7_8) + ' and code16=' + QuotedStr(str16);  //oz,code16必需輸入
      Filter := Filter + ' and (code2 like ' + QuotedStr('%' + str2 + '%') + ' or code2='''')';
      Filter := Filter + ' and (code17 like ' + QuotedStr('%' + str17 + '%') + ' or code17='''')';
      Filtered := True;
      IndexFieldNames := 'oz;code16;code9_11;code12_14';
      if not IsEmpty then
      begin
        First;
        while not Eof do       //查找code9_11、code12_14條件都滿足
        begin
          if (Pos(str9_11, FieldByName('code9_11').AsString) > 0) and (Pos(str12_14, FieldByName('code12_14').AsString) > 0) then
          begin
            Result := True;
            IsLock := FieldByName('lock').AsBoolean;
            if not IsLock then
              Sdate := FieldByName('sdate').AsDateTime;
            Exit;
          end;
          Next;
        end;

        First;
        while not Eof do       //查找code9_11條件滿足、code12_14為空
        begin
          if (Pos(str9_11, FieldByName('code9_11').AsString) > 0) and (Length(FieldByName('code12_14').AsString) = 0) then
          begin
            Result := True;
            IsLock := FieldByName('lock').AsBoolean;
            if not IsLock then
              Sdate := FieldByName('sdate').AsDateTime;
            Exit;
          end;
          Next;
        end;

        First;
        while not Eof do       //查找code9_11為空、code12_14條件滿足
        begin
          if (Pos(str12_14, FieldByName('code12_14').AsString) > 0) and (Length(FieldByName('code9_11').AsString) = 0) then
          begin
            Result := True;
            IsLock := FieldByName('lock').AsBoolean;
            if not IsLock then
              Sdate := FieldByName('sdate').AsDateTime;
            Exit;
          end;
          Next;
        end;

        First;
        while not Eof do       //查找code9_11、code12_14都為空值
        begin
          if (Length(FieldByName('code9_11').AsString) = 0) and (Length(FieldByName('code12_14').AsString) = 0) then
          begin
            Result := True;
            IsLock := FieldByName('lock').AsBoolean;
            if not IsLock then
              Sdate := FieldByName('sdate').AsDateTime;
            Exit;
          end;
          Next;
        end;
      end;
    end;
  end;

  //PN板裁切利用率,若小於設定的利用率則鎖定
  function CheckPNLLock(xCDS: TClientDataSet): Boolean;
  var
    pnlnum: Integer;
    num1, num2, num3, num4: Double;
  begin
    Result := False;
    if tmpCDS6.IsEmpty then
      Exit;

    pnlnum := xCDS.FieldByName('pnlnum').AsInteger;
    if pnlnum <= 0 then
      Exit;

    num1 := xCDS.FieldByName('pnlsize1').AsFloat;
    num2 := xCDS.FieldByName('pnlsize2').AsFloat;
    if (num1 <= 0) or (num2 <= 0) then
      Exit;

    num3 := StrToInt(Copy(xCDS.FieldByName('materialno').AsString, 9, 3)) / 10;
    num4 := StrToInt(Copy(xCDS.FieldByName('materialno').AsString, 12, 3)) / 10;

    num1 := RoundTo(((num1 * num2 * pnlnum) / (num3 * num4)) * 100, -1);

    Result := (num1 < tmpCDS6.FieldByName('Urate_lower').AsFloat) or (num1 > tmpCDS6.FieldByName('Urate_upper').AsFloat);
  end;

  //添加結果
  procedure AddCDS2(sdateX: TDateTime; stypeX: string; qtyX: Double);
  begin
    with CDS2 do
    begin
      Append;
      FieldByName('sdate').Value := sdateX;
      FieldByName('stype').Value := stypeX;
      FieldByName('orderdate').Value := CDS3.FieldByName('orderdate').Value;
      FieldByName('orderno').Value := CDS3.FieldByName('orderno').Value;
      FieldByName('orderitem').Value := CDS3.FieldByName('orderitem').Value;
      FieldByName('materialno').Value := CDS3.FieldByName('materialno').Value;
      FieldByName('materialno1').Value := CDS3.FieldByName('materialno1').Value;
      FieldByName('pnlsize1').Value := CDS3.FieldByName('pnlsize1').Value;
      FieldByName('pnlsize2').Value := CDS3.FieldByName('pnlsize2').Value;
      FieldByName('orderqty').Value := CDS3.FieldByName('orderqty').Value;
      FieldByName('sqty').Value := qtyX;

      // aaa
      if CDS3.FieldByName('adate').IsNull then
      begin
        if SameText(g_UInfo^.BU, 'ITEQJX') then
        begin
          if Length(FieldByName('materialno1').AsString) > 0 then
            FieldByName('adate').Value := sdateX + 4
          else
            FieldByName('adate').Value := sdateX + 3;
        end
        else
        begin
          if Length(FieldByName('materialno1').AsString) > 0 then
            FieldByName('adate').Value := sdateX + 3
          else
            FieldByName('adate').Value := sdateX + 2;
        end;
      end
      else
        FieldByName('adate').Value := CDS3.FieldByName('adate').Value;
      // aaa
        // 記錄原始的生管交期 longxinjue 2022.01.05
      FieldByName('adate_old1').Value := FieldByName('adate').Value;
      FieldByName('adate_old').Value := FieldByName('adate').Value;

      FieldByName('edate').Value := CDS3.FieldByName('edate').Value;
      FieldByName('custno').Value := CDS3.FieldByName('custno').Value;
      FieldByName('custom').Value := CDS3.FieldByName('custom').Value;
      FieldByName('custom2').Value := CDS3.FieldByName('custom2').Value;
      FieldByName('isempty').AsBoolean := False;
      FieldByName('remainqty').AsFloat := 0;
      FieldByName('srcflag').Value := CDS3.FieldByName('srcflag').Value;
      FieldByName('oz').Value := CDS3.FieldByName('oz').Value;
      FieldByName('thickness').Value := CDS3.FieldByName('thickness').Value;
      FieldByName('supplier').Value := CDS3.FieldByName('supplier').Value;
      FieldByName('pnlnum').Value := CDS3.FieldByName('pnlnum').Value;
      FieldByName('orderno2').Value := CDS3.FieldByName('orderno2').Value;
      FieldByName('orderitem2').Value := CDS3.FieldByName('orderitem2').Value;

      FieldByName('premark3').Value := CDS3.FieldByName('premark3').Value;

        // longxinjue 2022.01.07
      FieldByName('regulateQty').Value := CDS3.FieldByName('regulateQty').Value;

        // longxinjue 2022.01.10
      FieldByName('uuid').Value := CDS3.FieldByName('uuid').Value;

      FieldByName('notvisible').AsBoolean := False;

      Post;
    end;
  end;

begin
  inherited;
  isNew := True;
  tmpCDS0 := TClientDataSet.Create(nil);
  try
    tmpCDS0.Data := CDS2.Data;
    if tmpCDS0.Active and (not tmpCDS0.IsEmpty) then
    begin
      if ShowMsg('預排結果未確認,確定執行排程嗎?', 33) = IdCancel then
        Exit;
      isNew := False;  //預排頁面是否有東東
    end;
  finally
    FreeAndNil(tmpCDS0);
  end;

  if (not CDS3.Active) or CDS3.IsEmpty then
  begin
    ShowMsg('待排訂單無資料!', 48);
    Exit;
  end;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if isNew and (ShowMsg('確定進行排程嗎?', 33) = IDCancel) then
    Exit;

  //檢查特殊銅箔鎖定,訂單單別與料號對應
  tmpSQL := 'exec proc_GetCCL 13,' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data7) then
    Exit;

  //檢查膠+系規格鎖定
  tmpSQL := 'exec proc_GetCCL 19,' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data11) then
    Exit;

  l_Ans := True;
  CDS3.DisableControls;
  tmpCDS7 := TClientDataSet.Create(nil);
  tmpCDS11 := TClientDataSet.Create(nil);
  try
    tmpCDS7.Data := Data7;
    tmpCDS11.Data := Data11;

    CDS3.First;
    while not CDS3.Eof do
    begin
      tmpSQL := '';
      if SameText(g_UInfo^.BU, 'ITEQDG') or SameText(g_UInfo^.BU, 'ITEQGZ') then
      begin
        if Pos(LeftStr(CDS3.FieldByName('Orderno').AsString, 3), '223,227,228,22G,222,22A,237') > 0 then
        begin
          if Pos(LeftStr(CDS3.FieldByName('Materialno').AsString, 1), 'T,B,M') = 0 then
            tmpSQL := 'err';
        end
        else
        begin
          if Pos(LeftStr(CDS3.FieldByName('Materialno').AsString, 1), 'E,R,N') = 0 then
            tmpSQL := 'err';
        end;

        if Length(tmpSQL) > 0 then
        begin
          if PCL.ActivePageIndex = 2 then
            SetSBars(CDS3);
          ShowMsg('第' + IntToStr(CDS3.RecNo) + '筆：訂單單別與料號不符!', 48);
          Exit;
        end;
      end;

      if CheckOZLock(CDS3.FieldByName('Materialno').AsString, isOZLock, tmpSdate) then
      begin
        if isOZLock then
          tmpSQL := '特殊銅箔已鎖定,不可排程!'
        else if CDS3.FieldByName('Sdate').IsNull then
          tmpSQL := '特殊銅箔生產日期未指定(≧' + DateToStr(tmpSdate) + ')'
        else if CDS3.FieldByName('Sdate').AsDateTime < tmpSdate then
          tmpSQL := '特殊銅箔指定生產日期小於設定日期(≧' + DateToStr(tmpSdate) + ')'
        else
          tmpSQL := '';

        if Length(tmpSQL) > 0 then
        begin
          if PCL.ActivePageIndex = 2 then
            SetSBars(CDS3);
          ShowMsg('第' + IntToStr(CDS3.RecNo) + '筆：' + tmpSQL, 48);
          Exit;
        end;
      end;

      tmpSQL := Copy(CDS3.FieldByName('Materialno').AsString, 3, 4);
      tmpCDS11.First;
      while not tmpCDS11.Eof do
      begin
        if (tmpCDS11.FieldByName('lcode3_6').AsString <= tmpSQL) and (tmpCDS11.FieldByName('hcode3_6').AsString >= tmpSQL) and (Pos(UpperCase(Copy(CDS3.FieldByName('materialno').AsString, 2, 1)), UpperCase(tmpCDS11.FieldByName('code2').AsString)) > 0) and ((tmpCDS11.FieldByName('code9_14').AsString = '*') or (Pos(UpperCase(Copy(CDS3.FieldByName('materialno').AsString, 9, 6)), UpperCase(tmpCDS11.FieldByName('code9_14').AsString)) > 0)) and ((tmpCDS11.FieldByName('custno').AsString = '*') or (Pos(UpperCase(CDS3.FieldByName
          ('custno').AsString), UpperCase(tmpCDS11.FieldByName('custno').AsString)) > 0)) and ((tmpCDS11.FieldByName('OZ').AsString = '*') or (Pos(UpperCase(Copy(CDS3.FieldByName('materialno').AsString, 7, 2)), UpperCase(tmpCDS11.FieldByName('OZ').AsString)) > 0)) and ((tmpCDS11.FieldByName('codeReci_2').AsString = '*') or (Pos(UpperCase(Copy(CDS3.FieldByName('materialno').AsString, Length(CDS3.FieldByName('materialno').AsString) - 1, 1)), UpperCase(tmpCDS11.FieldByName('codeReci_2').AsString)) > 0)) and (UpperCase(tmpCDS11.FieldByName('LockFlg').AsString) = 'Y') then
        begin
          ShowMsg('第' + IntToStr(CDS3.RecNo) + '筆：此膠系+規格+尺寸+客戶+銅厚+銅箔規格 不可排程!', 48);
          Exit;
        end;
        tmpCDS11.Next;
      end;

      CDS3.Next;
    end;
  finally
    l_Ans := False;
    CDS3.EnableControls;
    FreeAndNil(tmpCDS7);
    FreeAndNil(tmpCDS11);
  end;

  //特殊尺寸換算公式
  if not SetCDS670(True) then
    Exit;

  //產能
  tmpSQL := 'exec [dbo].[proc_MPSI380] ' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data1) then
    Exit;

  //特殊尺寸
  tmpSQL := 'select ''/''+isnull(OthSize,'''')+''/'' OthSize,StdSize from mps220' + ' where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data2) then
    Exit;

  //鋼板編號
  tmpSQL := 'select stealno,longitude_lower,longitude_upper,latitude_lower,latitude_upper' + ' from mps370 where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data3) then
    Exit;

  //客戶群組產能
  tmpSQL := 'select groupid,custno,ad,case when isthin=1 then 1 else 0 end isthin,maxqty,lockmonth' + ' from mps180 where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data4) then
    Exit;

  //客戶群組已使用產能(每日)
  tmpSQL := 'exec dbo.proc_MPSI180 ' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data5) then
    Exit;

  //PNL利用率
  tmpSQL := 'exec proc_GetCCL 15,' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data6) then
    Exit;

  //膠系+尺寸產能
  tmpSQL := 'select stype,ad,maxqty from mps390 where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data8) then
    Exit;

  //膠系+尺寸已使用產能
  tmpSQL := 'exec dbo.proc_MPSI390 ' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data9) then
    Exit;

  //排程最大日期
  tmpSQL := 'select stype,max(sdate) sdate from mps012' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' group by stype';
  if not QueryBySQL(tmpSQL, Data10) then
    Exit;

  l_Ans := True;
  l_ErrList.Clear;
  g_ProgressBar.Visible := True;
  CDS2.DisableControls;
  CDS3.DisableControls;
  CDS2.EmptyDataSet;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  tmpCDS3 := TClientDataSet.Create(nil);
  tmpCDS4 := TClientDataSet.Create(nil);
  tmpCDS5 := TClientDataSet.Create(nil);
  tmpCDS6 := TClientDataSet.Create(nil);
  tmpCDS8 := TClientDataSet.Create(nil);
  tmpCDS9 := TClientDataSet.Create(nil);
  tmpCDS10 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data1;
    tmpCDS2.Data := Data2;
    tmpCDS3.Data := Data3;
    tmpCDS4.Data := Data4;
    tmpCDS5.Data := Data5;
    tmpCDS6.Data := Data6;
    tmpCDS8.Data := Data8;
    tmpCDS9.Data := Data9;
    tmpCDS10.Data := Data10;
    tmpCDS1.IndexFieldNames := 'sdate;stype';

    for i := 1 to 2 do
    begin
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := CDS3.RecordCount;
      CDS3.First;
      while not CDS3.Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

        if CDS3.FieldByName('sqty').AsFloat <= 0 then
        begin
          CDS3.Next;
          Continue;
        end;

        //排2次,先排指定日期或類別的
        if i = 1 then
        begin
          if CDS3.FieldByName('sdate').IsNull and (Length(CDS3.FieldByName('stype').AsString) = 0) then
          begin
            CDS3.Next;
            Continue;
          end;
        end
        else
        begin
          if (not CDS3.FieldByName('sdate').IsNull) or (Length(CDS3.FieldByName('stype').AsString) > 0) then
          begin
            CDS3.Next;
            Continue;
          end;
        end;

        if CheckPNLLock(CDS3) then
        begin
          l_ErrList.Add('第' + IntToStr(CDS3.RecNo) + '筆,PN板裁切利用率鎖定');
          CDS3.Next;
          Continue;
        end;

        S9_11 := Copy(CDS3.FieldByName('materialno').AsString, 9, 3);     //經向
        l_CDS670.Filtered := False;
        l_CDS670.Filter := 'size_l<=' + Quotedstr(S9_11) + ' and size_h>=' + Quotedstr(S9_11);
        l_CDS670.Filtered := True;
        if l_CDS670.IsEmpty then
        begin
          tmpCDS670_D := 1;
          tmpCDS670_M := 1;
        end
        else
        begin
          tmpCDS670_D := l_CDS670.FieldByName('d').AsInteger;
          tmpCDS670_M := l_CDS670.FieldByName('m').AsInteger;
        end;

        tmpSqty := CDS3.FieldByName('sqty').AsFloat;        //訂單量(待排制量)
        tmpSqty2 := Ceil(tmpSqty / tmpCDS670_D * tmpCDS670_M);  //占用產能
        if Copy(CDS3.FieldByName('materialno').AsString, 3, 4) >= g_ThinSize then  //厚板tmpIsThin=0
          tmpIsThin := 0
        else
          tmpIsThin := 1;

        if Length(CDS3.FieldByName('stype').AsString) > 0 then
          tmpStype := CDS3.FieldByName('stype').AsString
        else
        begin
          S12_14 := Copy(CDS3.FieldByName('materialno').AsString, 12, 3); //續向
          if (S12_14 >= '488') and (S12_14 <= '493') then //緯向488~493,經向是特殊尺寸則轉換
            S9_11 := GetOtherSizeX(S9_11);
          tmpStype := GetStealnoX(S9_11, S12_14);
          if tmpStype = '' then
          begin
            l_ErrList.Add('第' + IntToStr(CDS3.RecNo) + '筆,未找到鋼板設定:' + S9_11 + S12_14);
            CDS3.Next;
            Continue;
          end;

          //40,41,55,33不分薄厚
          if (tmpStype <> '40') and (tmpStype <> '41') and (tmpStype <> '55') and (tmpStype <> '33') then
          begin
            if tmpIsThin = 0 then
              tmpStype := tmpStype + '厚'
            else
              tmpStype := tmpStype + '薄';
          end;
        end;

        tmpCDS1.Filtered := False;
        tmpCDS1.Filter := 'qty>0 and stype=' + Quotedstr(tmpStype);
        if not CDS3.FieldByName('sdate').IsNull then
          tmpCDS1.Filter := tmpCDS1.Filter + ' and sdate=' + Quotedstr(DateToStr(CDS3.FieldByName('sdate').AsDateTime));
        tmpCDS1.Filtered := True;

        if tmpCDS1.IsEmpty then
        begin
          l_ErrList.Add('第' + IntToStr(CDS3.RecNo) + '筆,產能不足:' + FloatToStr(tmpSqty) + '(' + FloatToStr(tmpSqty2) + '),鋼板:' + tmpStype);
          CDS3.Next;
          Continue;
        end;

        //循環產能表MPS380
        tmpCDS1.First;
        while not tmpCDS1.Eof do
        begin
          tmpSdate := tmpCDS1.FieldByName('sdate').AsDateTime;                            //生產日期
          tmpMqty := tmpCDS1.FieldByName('qty').AsFloat;                                  //總產能
          tmpCustno := CDS3.FieldByName('custno').AsString;                               //客戶編號
          tmpAd := Copy(CDS3.FieldByName('materialno').AsString, 2, 1);                     //膠系

          tmpRemainQtyX := GetStypeAdRemainQty(tmpCDS9, tmpCDS8, tmpSdate, tmpStype, tmpAd); //產能限定:膠系+尺寸
          if tmpRemainQtyX <= 0 then
          begin
            tmpCDS1.Next;
            Continue;
          end;

          tmpRemainQty := GetCustRemainQty(tmpCDS5, tmpCDS4, tmpSdate, tmpCustno, tmpAd, tmpIsThin);    //產能限定:客戶+膠系+薄厚
          if tmpRemainQty <= 0 then
          begin
            tmpCDS1.Next;
            Continue;
          end;

          if tmpRemainQtyX < tmpRemainQty then          //產能限定順序:1.膠系+尺寸 2.客戶+膠系
            tmpRemainQty := tmpRemainQtyX;

          isNext := False;  //true=>tmpCDS1.next, qty=0時Filtered即tmpCDS1.next
          if tmpRemainQty < tmpSqty2 then               //產能限定不滿足排制量,存在拆單
          begin
            if (tmpSqty <= 120) or (tmpMqty < 100) then   //120sh以下小單或當天剩余產能<100不拆
            begin
              tmpCDS1.Next;
              Continue;
            end;

            if tmpRemainQty >= tmpMqty then             //產能限定>=可用產能(tmpSqty2>tmpMqty,最多只能排tmpMqty)
            begin
              sqty := Trunc(tmpMqty / tmpCDS670_M * tmpCDS670_D);  //已排量
              AddCDS2(tmpSdate, tmpStype, sqty);

              tmpCDS1.Edit;
              tmpCDS1.FieldByName('editflag').AsInteger := 1;
              tmpCDS1.FieldByName('qty').AsFloat := 0; //剩余產能0, Filter即tmpCDS1.Next
              tmpCDS1.Post;

              tmpSqty := tmpSqty - sqty;                 //剩余排製量
              tmpRemainQty := tmpRemainQty - tmpMqty;    //產能限定,剩余產能
            end
            else
            begin                                    //產能限定<可用產能,最多只能排tmpRemainQty
              sqty := Trunc(tmpRemainQty / tmpCDS670_M * tmpCDS670_D);  //已排量
              AddCDS2(tmpSdate, tmpStype, sqty);

              tmpCDS1.Edit;
              tmpCDS1.FieldByName('editflag').AsInteger := 1;
              tmpCDS1.FieldByName('qty').AsFloat := tmpCDS1.FieldByName('qty').AsFloat - tmpRemainQty; //剩余產能
              tmpCDS1.Post;

              tmpSqty := tmpSqty - sqty;                //剩余排製量
              tmpRemainQty := 0;                      //產能限定,剩余產能
              isNext := True;                         //執行tmpCDS1.Next
            end;

            //更新已使用產能
            UpdateStypeAdRemainQty(tmpCDS9, tmpSdate, tmpStype, tmpAd, tmpRemainQty);
            UpdateCustRemainQty(tmpCDS5, tmpSdate, tmpCustno, tmpAd, tmpIsThin, tmpRemainQty);
          end
          else                                   //產能限定滿足排制量
          begin
            if tmpMqty >= tmpSqty2 then                //可用產能>=排製量占用產能
            begin
              AddCDS2(tmpSdate, tmpStype, tmpSqty);

              tmpCDS1.Edit;
              tmpCDS1.FieldByName('editflag').AsInteger := 1;
              tmpCDS1.FieldByName('qty').AsFloat := tmpCDS1.FieldByName('qty').AsFloat - tmpSqty2;     //剩余產能
              tmpCDS1.Post;

              tmpRemainQty := tmpRemainQty - tmpSqty2;   //產能限定,剩余產能
              tmpSqty := 0;                            //剩余排製量Break;
            end
            else if (tmpSqty > 120) and (tmpMqty >= 100) then   //產能不足,120以上的單,最小拆成100
            begin
              sqty := Trunc(tmpMqty / tmpCDS670_M * tmpCDS670_D); //已排量
              AddCDS2(tmpSdate, tmpStype, sqty);

              tmpCDS1.Edit;
              tmpCDS1.FieldByName('editflag').AsInteger := 1;
              tmpCDS1.FieldByName('qty').AsFloat := 0; //剩余產能0, Filter即tmpCDS1.Next
              tmpCDS1.Post;

              tmpSqty := tmpSqty - sqty;                 //剩余排製量
              tmpRemainQty := tmpRemainQty - tmpMqty;    //產能限定,剩余產能
            end
            else
              isNext := True;                          //此筆產能不可用,取下一筆
            //更新已使用產能
            if not isNext then
            begin
              UpdateStypeAdRemainQty(tmpCDS9, tmpSdate, tmpStype, tmpAd, tmpRemainQty);
              UpdateCustRemainQty(tmpCDS5, tmpSdate, tmpCustno, tmpAd, tmpIsThin, tmpRemainQty);
            end;
          end;

          if tmpSqty = 0 then
            Break;

          //剩餘訂單量需占用產能tmpSqty2
          tmpSqty2 := Ceil(tmpSqty / tmpCDS670_D * tmpCDS670_M);

          if isNext then
            tmpCDS1.Next;
        end;

        if tmpSqty > 0 then
          l_ErrList.Add('第' + IntToStr(CDS3.RecNo) + '筆,產能不足:' + FloatToStr(tmpSqty) + '(' + FloatToStr(tmpSqty2) + '),鋼板:' + tmpStype);

        CDS3.Next;
      end;
    end;

    tmpCDS1.Filtered := False;
    if tmpCDS1.ChangeCount > 0 then
      tmpCDS1.MergeChangeLog;
    for i := 0 to RG2.Items.Count - 1 do
    begin
      tmpStype := RG2.Items.Strings[i];

      //添加剩餘產能(編輯過的資料editflag=1)
      tmpCDS1.Filtered := False;
      tmpCDS1.Filter := 'stype=' + Quotedstr(tmpStype) + ' and qty>0 and editflag=1';
      tmpCDS1.Filtered := True;
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        CDS2.Append;
        CDS2.FieldByName('sdate').Value := tmpCDS1.FieldByName('sdate').AsDateTime;
        CDS2.FieldByName('stype').Value := tmpStype;
        CDS2.FieldByName('isempty').AsBoolean := True;
        CDS2.FieldByName('remainqty').AsFloat := tmpCDS1.FieldByName('qty').AsFloat;
        CDS2.FieldByName('oz').Value := g_OZ;
        CDS2.Post;

        tmpCDS1.Next;
      end;

      //添加跳過的日期(未編輯過的資料editflag=0)
      //找出已確認排程中最后一個日期tmpMinSdate
      //找出預排排程中最后一個日期tmpMaxSdate
      tmpCDS1.Filtered := False;
      tmpCDS1.Filter := 'stype=' + Quotedstr(tmpStype) + ' and editflag=1';
      tmpCDS1.Filtered := True;
      if not tmpCDS1.IsEmpty then
      begin
        if tmpCDS10.Locate('stype', tmpStype, []) then
          tmpMinSdate := tmpCDS10.FieldByName('sdate').AsDateTime + 1
        else
          tmpMinSdate := Date;

        tmpCDS1.Last;
        tmpMaxSdate := tmpCDS1.FieldByName('sdate').AsDateTime;

        tmpCDS1.Filtered := False;
        tmpCDS1.Filter := 'stype=' + Quotedstr(tmpStype) + ' and sdate>=' + Quotedstr(DateToStr(tmpMinSdate)) + ' and sdate<' + Quotedstr(DateToStr(tmpMaxSdate)) + ' and editflag=0';
        tmpCDS1.Filtered := True;
        while not tmpCDS1.Eof do
        begin
          CDS2.Append;
          CDS2.FieldByName('sdate').Value := tmpCDS1.FieldByName('sdate').AsDateTime;
          CDS2.FieldByName('stype').Value := tmpStype;
          CDS2.FieldByName('isempty').AsBoolean := True;
          CDS2.FieldByName('remainqty').AsFloat := tmpCDS1.FieldByName('qty').AsFloat;
          CDS2.FieldByName('oz').Value := g_OZ;
          CDS2.Post;

          tmpCDS1.Next;
        end;
      end;
    end;

    if CDS2.ChangeCount > 0 then
      CDS2.MergeChangeLog;

  finally
    l_Ans := False;
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    FreeAndNil(tmpCDS4);
    FreeAndNil(tmpCDS5);
    FreeAndNil(tmpCDS6);
    FreeAndNil(tmpCDS8);
    FreeAndNil(tmpCDS9);
    FreeAndNil(tmpCDS10);
    CDS2.EnableControls;
    CDS3.EnableControls;
    g_ProgressBar.Visible := False;
  end;

  RefreshData(RG2, CDS2);
  PCL.ActivePageIndex := 1;
  SetEdit3;
  GetSumQty;
  RefreshColor;
  DBGridEh2.Repaint;

  if l_ErrList.Count > 0 then
  begin
    l_ErrList.Text := CheckLang(l_ErrList.Text);
    if not Assigned(FrmShowErrList) then
      FrmShowErrList := TFrmShowErrList.Create(Application);
    FrmShowErrList.Memo1.Lines.Assign(l_ErrList);
    FrmShowErrList.ShowModal;
  end
  else
    ShowMsg('排程完畢!', 64);
end;

procedure TFrmMPST012.btn_mpst012DClick(Sender: TObject);
var
  tmpSQL: string;
  i, tmpSno: Integer;
  tmpSdate: TDateTime;
  tmpCDS1, tmpCDS2, tmpCDS3, tmpCDS4: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  tmpCDS3 := TClientDataSet.Create(nil);
  tmpCDS4 := TClientDataSet.Create(nil);

  try
    tmpCDS1.Data := CDS2.Data;
    if (not tmpCDS1.Active) or tmpCDS1.IsEmpty then
    begin
      ShowMsg('預排結果無資料,不可確認!', 48);
      Exit;
    end;

    if ShowMsg('確認排程嗎?', 33) = IDCancel then
      Exit;

    //空行產能處理
    //預排結果:1.空行修改過有剩餘 2.無空行(用完) 3.新加入的(排至未來日期,中間跳過的日期)
    //保存資料:1.更新             2.刪除         3.新增
    tmpSQL := 'select * from mps012 where bu=' + Quotedstr(g_UInfo^.BU) + ' and sdate>getdate()-1 and isnull(isempty,0)=1';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS2.Data := Data;

    with tmpCDS2 do
    begin
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := RecordCount;
      g_ProgressBar.Visible := True;
      while not Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Application.ProcessMessages;

        //此日期+類別,預排結果有資料
        if tmpCDS1.Locate('sdate;stype', VarArrayOf([FieldByName('sdate').AsDateTime, FieldByName('stype').AsString]), []) then
        begin
          //1.空行修改過有剩餘
          if tmpCDS1.Locate('sdate;stype;isempty', VarArrayOf([FieldByName('sdate').AsDateTime, FieldByName('stype').AsString, 1]), []) then
          begin
            Edit;
            FieldByName('remainqty').AsFloat := tmpCDS1.FieldByName('remainqty').AsFloat;
            FieldByName('muser').AsString := g_UInfo^.UserId;
            FieldByName('mdate').AsDateTime := Now;
            Post;
          end
          else  //2.無空行(用完)
          begin
            Delete;
            Continue;
          end;
        end;

        Next;
      end;
    end;

    tmpCDS3.Data := tmpCDS2.Data;
    tmpCDS3.MergeChangeLog;

    tmpSno := 1;
    tmpSdate := EnCodeDate(2000, 1, 1);
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := tmpCDS1.RecordCount;
    tmpCDS1.IndexFieldNames := CDS.IndexFieldNames;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      g_ProgressBar.Position := g_ProgressBar.Position + 1;
      Application.ProcessMessages;

      //如果是空行,且數據庫已存在這筆資料則不保存(前面步驟已做更新)
      //從數據庫查詢的tmpCDS2無法Locate isempty欄位,故使用tmpCDS3
      if tmpCDS1.FieldByName('isempty').AsBoolean then
      begin
        tmpCDS3.Filtered := False;
        tmpCDS3.Filter := 'sdate=' + Quotedstr(DateToStr(tmpCDS1.FieldByName('sdate').AsDateTime)) + ' and stype=' + Quotedstr(tmpCDS1.FieldByName('stype').AsString) + ' and isempty';
        tmpCDS3.Filtered := True;
        if not tmpCDS3.IsEmpty then
        begin
          tmpCDS1.Next;
          Continue;
        end;
      end;

      if tmpSdate <> tmpCDS1.FieldByName('Sdate').AsDateTime then
      begin
        tmpSdate := tmpCDS1.FieldByName('Sdate').AsDateTime;
        if not GetMaxSno(tmpSdate, tmpSno) then
          Exit;
      end;

      tmpCDS2.Append;
      for i := 0 to tmpCDS1.FieldCount - 1 do
      begin
        if tmpCDS1.Fields[i].FieldName <> 'pno2' then
          tmpCDS2.Fields[i].Value := tmpCDS1.Fields[i].Value;
      end;
      tmpCDS2.FieldByName('Bu').AsString := g_UInfo^.BU;
      tmpCDS2.FieldByName('Sno').AsInteger := tmpSno;
      tmpCDS2.FieldByName('Iuser').AsString := g_UInfo^.UserId;
      tmpCDS2.FieldByName('Idate').AsDateTime := Now;
      tmpCDS2.Post;
      Inc(tmpSno);

      tmpCDS1.Next;
    end;

    // 保存訂單與庫存的關聯 longxinjue 2022.01.10
    tmpCDS4 := SaveOrderStockInfo(tmpCDS2, l_CDS_Stock);
    if CDSPost(tmpCDS4, 'MPS012_Stock') then
    begin
      l_CDS_Stock.EmptyDataSet;
    end;

    if CDSPost(tmpCDS2, 'MPS012') then
    begin
      CDS.EmptyDataSet;
      CDS2.EmptyDataSet;
      CDS3.EmptyDataSet;
      SetEdit3;
      GetSumQty;
      ShowMsg('確認完畢,請重新查詢顯示資料!', 64);
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    FreeAndNil(tmpCDS4);
    g_ProgressBar.Visible := False;
  end;
end;

procedure TFrmMPST012.btn_mpst012EClick(Sender: TObject);
var
  i, tmpSno: Integer;
  tmpSdate, tmpOldSdate: TDateTime;
  tmpList: TStrings;
begin
  inherited;
  if l_SelList.Count = 0 then
  begin
    ShowMsg('請選擇要調整的單據!', 48);
    Exit;
  end;

  if ShowMsg('確認調整嗎?', 33) = IDCancel then
    Exit;

  l_Ans := True;
  tmpSno := 1;
  tmpOldSdate := EncodeDate(2000, 1, 1);
  CDS.DisableControls;
  tmpList := TStringList.Create;
  try
    tmpSdate := CDS.FieldByName('sdate').AsDateTime;
    if not GetMaxSno(tmpSdate, tmpSno) then
      Exit;

    for i := 0 to l_SelList.Count - 1 do
    begin
      tmpList.DelimitedText := StringReplace(l_SelList.Strings[i], '@', ',', [rfReplaceAll]);
      if not CDS.Locate('sdate;stype;sno', VarArrayOf([tmpList.Strings[0], tmpList.Strings[1], tmpList.Strings[2]]), []) then
      begin
        ShowMsg('未定位到單據!', 48);
        Exit;
      end;

      if CDS.FieldByName('isempty').AsBoolean then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        ShowMsg('空行不可調整!', 48);
        Exit;
      end;

      tmpOldSdate := CDS.FieldByName('sdate').AsDateTime;
      if tmpOldSdate <> tmpSdate then
      begin
        CDS.Edit;
        CDS.FieldByName('sdate').AsDateTime := tmpSdate;
        CDS.FieldByName('sno').AsInteger := tmpSno;
        if SameText(g_UInfo^.BU, 'ITEQJX') then
        begin
          if Length(CDS.FieldByName('materialno1').AsString) > 0 then
            CDS.FieldByName('adate').AsDateTime := tmpSdate + 4
          else
            CDS.FieldByName('adate').AsDateTime := tmpSdate + 3;
        end
        else
        begin
          if Length(CDS.FieldByName('materialno1').AsString) > 0 then
            CDS.FieldByName('adate').AsDateTime := tmpSdate + 3
          else
            CDS.FieldByName('adate').AsDateTime := tmpSdate + 2;
        end;
        CDS.Post;
        Inc(tmpSno);
      end;
    end;

    if PostBySQLFromDelta(CDS, p_TableName, l_pk) then
    begin
      btn_mpst012Q.Hint := DateToStr(tmpOldSdate) + '&' + DateToStr(tmpSdate);
      l_SelList.Clear;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
    FreeAndNil(tmpList);
    CDS.AfterScroll(CDS);
    CDS.EnableControls;
    RefreshColor;
  end;
end;

procedure TFrmMPST012.btn_mpst012FClick(Sender: TObject);
var
  tmpSno: Integer;
  Num: Double;
  tmpSdate: TDateTime;
  tmpSQL, str, tmpStype: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  tmpSno := -1;
  tmpSdate := CDS.FieldByName('sdate').AsDateTime;
  tmpStype := CDS.FieldByName('stype').AsString;

  if CDS.FieldByName('isempty').AsBoolean then
    str := FloatToStr(CDS.FieldByName('remainqty').AsFloat);

  if not InputQuery(CheckLang('請輸入產能(sh)'), 'Number', str) then
    Exit;
  if str = '' then
    Exit;

  Num := StrToFloatDef(str, -1);
  if Num <= 0 then
  begin
    ShowMsg('請輸入大於0的數字', 48);
    Exit;
  end;

  tmpSQL := 'select remainqty from mps012 where bu=' + Quotedstr(g_UInfo^.BU) + ' and sdate=' + Quotedstr(DateToStr(tmpSdate)) + ' and stype=' + Quotedstr(tmpStype) + ' and isnull(isempty,0)=1';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  L_Ans := True;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    tmpCDS2.Data := CDS.Data;
    with tmpCDS2 do
    begin
      Filtered := False;
      Filter := 'Sdate=' + Quotedstr(DateToStr(tmpSdate)) + ' and Stype=' + Quotedstr(tmpStype);
      Filtered := True;
      while not Eof do
      begin
        if FieldByName('IsEmpty').AsBoolean then
        begin
          tmpSno := FieldByName('Sno').AsInteger;
          Break;
        end;
        Next;
      end;
    end;

    if (not tmpCDS1.IsEmpty) and (tmpSno < 0) then
    begin
      ShowMsg('資料不同步1,請重新查詢!', 48);
      Exit;
    end;

    if tmpCDS1.IsEmpty and (tmpSno > 0) then
    begin
      ShowMsg('資料不同步2,請重新查詢!', 48);
      Exit;
    end;

    if tmpCDS1.IsEmpty then
    begin
      if not GetMaxSno(tmpSdate, tmpSno) then
        Exit;

      CDS.Append;
      CDS.FieldByName('bu').AsString := g_UInfo^.BU;
      CDS.FieldByName('sdate').AsDateTime := tmpSdate;
      CDS.FieldByName('stype').AsString := tmpStype;
      CDS.FieldByName('sno').AsInteger := tmpSno;
      CDS.FieldByName('isempty').AsBoolean := True;
      CDS.FieldByName('remainqty').AsFloat := Num;
      CDS.FieldByName('oz').Value := g_OZ;
      CDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
      CDS.FieldByName('Idate').AsDateTime := Now;
      CDS.Post;
      PostBySQLFromDelta(CDS, p_TableName, l_pk);
    end
    else
    begin
      if Num = tmpCDS1.FieldByName('remainqty').AsFloat then
        Exit;

      if not CDS.Locate('sdate;stype;sno', VarArrayOf([tmpSdate, tmpStype, tmpSno]), []) then
      begin
        ShowMsg('定位數據失敗,請重試!', 48);
        Exit;
      end;

      CDS.Edit;
      CDS.FieldByName('remainqty').AsFloat := Num;
      CDS.Post;
      PostBySQLFromDelta(CDS, p_TableName, l_pk);
    end;
  finally
    L_Ans := False;
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    CDS.AfterScroll(CDS);
    RefreshColor;
  end;
end;

procedure TFrmMPST012.btn_mpst012GClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  case PCL.ActivePageIndex of
    0:
      if CDS.Active then
        str := CDS.FieldByName('materialno').AsString;
    1:
      if CDS2.Active then
        str := CDS2.FieldByName('materialno').AsString;
    2:
      if CDS3.Active then
        str := CDS3.FieldByName('materialno').AsString;
  end;
  GetQueryStock(str, g_MInfo^.ProcId);
end;

procedure TFrmMPST012.btn_mpst012HClick(Sender: TObject);
begin
  inherited;
  FrmMPST012_cqty := TFrmMPST012_cqty.Create(nil);
  try
    FrmMPST012_cqty.ShowModal;
  finally
    FreeAndNil(FrmMPST012_cqty);
  end;
end;

procedure TFrmMPST012.btn_mpst012IClick(Sender: TObject);
begin
  inherited;
  FrmMPST012_rqty := TFrmMPST012_rqty.Create(nil);
  try
    if CDS.Active and (not CDS.IsEmpty) then
    begin
      FrmMPST012_rqty.l_stype := CDS.FieldByName('Stype').AsString;
      FrmMPST012_rqty.l_sdate := CDS.FieldByName('Sdate').AsDateTime;
    end
    else
    begin
      FrmMPST012_rqty.l_stype := '@';
      FrmMPST012_rqty.l_sdate := EncodeDate(2000, 1, 1);
    end;
    FrmMPST012_rqty.ShowModal;
  finally
    FreeAndNil(FrmMPST012_rqty);
  end;
end;

procedure TFrmMPST012.btn_mpst012JClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST012_clear0) then
    FrmMPST012_clear0 := TFrmMPST012_clear0.Create(Application);
  FrmMPST012_clear0.ShowModal;
end;

procedure TFrmMPST012.btn_mpst012KClick(Sender: TObject);
var
  tmpStr1, tmpStr2: string;
begin
  inherited;
  tmpStr1 := '';
  FrmMPST070_bom := TFrmMPST070_bom.Create(nil);
  case PCL.ActivePageIndex of
    0:
      if CDS.Active then
      begin
        tmpStr1 := CDS.FieldByName('materialno').AsString;
        tmpStr2 := FloatToStr(CDS.FieldByName('sqty').AsFloat);
      end;
    1:
      if CDS2.Active then
      begin
        tmpStr1 := CDS2.FieldByName('materialno').AsString;
        tmpStr2 := FloatToStr(CDS2.FieldByName('sqty').AsFloat);
      end;
    2:
      if CDS3.Active then
      begin
        tmpStr1 := CDS3.FieldByName('materialno').AsString;
        tmpStr2 := FloatToStr(CDS3.FieldByName('sqty').AsFloat);
      end;
  end;
  FrmMPST070_bom.Edit1.Text := tmpStr1;
  FrmMPST070_bom.Edit2.Text := tmpStr2;
  try
    FrmMPST070_bom.ShowModal;
  finally
    FreeAndNil(FrmMPST070_bom);
  end;
end;

procedure TFrmMPST012.btn_mpst012LClick(Sender: TObject);
var
  tmpSQL: string;
begin
  inherited;
  if ShowMsg('確定更新嗎?', 33) = IdCancel then
    Exit;

  tmpSQL := 'exec [dbo].[proc_UpdateMPS012_RemainQty] ' + Quotedstr(g_UInfo^.BU);
  if PostBySQL(tmpSQL) then
  begin
    CDS.EmptyDataSet;
    CDS2.EmptyDataSet;
    CDS3.EmptyDataSet;
    SetEdit3;
    GetSumQty;
    RefreshColor;
    ShowMsg('更新完畢!', 64);
  end;
end;

procedure TFrmMPST012.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('sdate').AsString + '@' + CDS.FieldByName('stype').AsString + '@' + CDS.FieldByName('sno').AsString;
    if l_SelList.IndexOf(tmpStr) <> -1 then
      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
  end;
end;

procedure TFrmMPST012.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if l_ColorList.Count >= CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
      Background := l_Color2
    else
      Background := l_Color1;
  end;
end;

procedure TFrmMPST012.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      g_DelFname := 'select,edate,orderitem,sqty,orderqty,materialno1,pnlsize1,pnlsize2';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end
  else if (Shift = [ssCtrl]) and (Key = 69) and CDS.Active and  //Ctrl+E排程資料更改
    (not CDS.IsEmpty) and (g_MInfo^.R_edit) and (not CDS.FieldByName('IsEmpty').AsBoolean) then
  begin
    FrmMPST012_CtrlE := TFrmMPST012_CtrlE.Create(nil);
    try
      with FrmMPST012_CtrlE do
      begin
        Edit7.Text := DateToStr(Self.CDS.FieldByName('Adate_old').AsDateTime);
        Dtp.Date := Self.CDS.FieldByName('Adate').AsDateTime;
        Edit1.Text := FloatToStr(Self.CDS.FieldByName('Sqty').AsFloat);
        Edit2.Text := Self.CDS.FieldByName('Materialno').AsString;
        Edit3.Text := Self.CDS.FieldByName('Premark').AsString;
        Edit4.Text := Self.CDS.FieldByName('Orderno').AsString;
        Edit5.Text := Self.CDS.FieldByName('Orderitem').AsString;
        Edit6.Text := Self.CDS.FieldByName('Premark2').AsString;
        Edit8.Text := Self.CDS.FieldByName('Orderno2').AsString;
        Edit9.Text := Self.CDS.FieldByName('Orderitem2').AsString;

        Edit10.Text := Self.CDS.FieldByName('Premark3').AsString;

        // longxinjue 2022.01.07 加投數量
        Edit11.Text := Self.CDS.FieldByName('regulateQty').AsString;
        Edit12.Text := Self.CDS.FieldByName('orderQty').AsString;

        if ShowModal = mrOk then
        begin
          if (Self.CDS.FieldByName('Adate').AsDateTime = Dtp.Date) and (Self.CDS.FieldByName('Sqty').AsFloat = StrToFloat(Edit1.Text)) and (Self.CDS.FieldByName('Materialno').AsString = Edit2.Text) and (Self.CDS.FieldByName('Premark').AsString = Edit3.Text) and (Self.CDS.FieldByName('Orderno').AsString = Edit4.Text) and (Self.CDS.FieldByName('Orderitem').AsInteger = StrToIntDef(Edit5.Text, 0)) and (Self.CDS.FieldByName('Premark2').AsString = Edit6.Text) and (Self.CDS.FieldByName('Premark3').AsString = Edit10.Text) and             // longxnjue 2022.01.07 加投數量
            (Self.CDS.FieldByName('regulateQty').AsString = Edit11.Text) and (Self.CDS.FieldByName('orderQty').AsString = Edit12.Text) and (Self.CDS.FieldByName('Orderno2').AsString = Edit8.Text) and (Self.CDS.FieldByName('Orderitem2').AsInteger = StrToIntDef(Edit9.Text, 0)) then
            Exit;

          Self.CDS.Edit;
          Self.CDS.FieldByName('Adate').AsDateTime := Dtp.Date;
          Self.CDS.FieldByName('Sqty').AsFloat := StrToFloat(Edit1.Text);
          Self.CDS.FieldByName('Materialno').AsString := Edit2.Text;
          Self.CDS.FieldByName('Premark').AsString := Edit3.Text;
          Self.CDS.FieldByName('Orderno').AsString := Edit4.Text;
          Self.CDS.FieldByName('Orderitem').AsInteger := StrToIntDef(Edit5.Text, 0);
          Self.CDS.FieldByName('Premark2').AsString := Edit6.Text;

          Self.CDS.FieldByName('Premark3').AsString := Edit10.Text;

          // longxnjue 2022.01.07
          Self.CDS.FieldByName('regulateQty').AsString := Edit11.Text;

          if Length(Trim(Edit8.Text)) = 0 then
          begin
            Self.CDS.FieldByName('Orderno2').Clear;
            Self.CDS.FieldByName('Orderitem2').Clear;
          end
          else
          begin
            Self.CDS.FieldByName('Orderno2').AsString := Edit8.Text;
            Self.CDS.FieldByName('Orderitem2').AsInteger := StrToIntDef(Edit9.Text, 0);
          end;
          Self.CDS.Post;
          PostBySQLFromDelta(Self.CDS, Self.p_TableName, l_pk);
          GetSumQty;
        end;
      end;
    finally
      FreeAndNil(FrmMPST012_CtrlE);
    end;
  end;
end;

procedure TFrmMPST012.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if SameText(Column.FieldName, 'select') and (not CDS.FieldByName('isempty').AsBoolean) then
  begin
    tmpStr := CDS.FieldByName('sdate').AsString + '@' + CDS.FieldByName('stype').AsString + '@' + CDS.FieldByName('sno').AsString;
    if l_SelList.IndexOf(tmpStr) = -1 then
      l_SelList.Add(tmpStr)
    else
      l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST012.CDSAfterCancel(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSAfterEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSAfterInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSAfterScroll(DataSet: TDataSet);
begin
  if L_Ans then
    Exit;

  inherited;
  SetEdit3;
  GetSumQty;
end;

procedure TFrmMPST012.CDSBeforeDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSBeforeEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSBeforeInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDSNewRecord(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST012.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;

  SetEdit3;
  SetSBars(CDS2);
  GetSumQty;
end;

procedure TFrmMPST012.CDS3AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;

  SetSBars(CDS3);
end;

procedure TFrmMPST012.PCLChange(Sender: TObject);
begin
  inherited;
  SetEdit3;
  GetSumQty;
  case PCL.ActivePageIndex of
    0:
      SetSBars(CDS);
    1:
      SetSBars(CDS2);
    2:
      SetSBars(CDS3);
  end;
  RefreshColor;
end;

procedure TFrmMPST012.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N20.Visible := g_MInfo^.R_edit;
  N21.Visible := g_MInfo^.R_edit;
  N22.Visible := g_MInfo^.R_edit;
  N23.Visible := g_MInfo^.R_edit;
  N24.Visible := g_MInfo^.R_edit;
  if N20.Visible then
  begin
    N20.Enabled := CDS.Active and (not CDS.IsEmpty);
    N21.Enabled := l_SelList.Count > 0;
    N22.Enabled := N21.Enabled;
    N23.Enabled := N20.Enabled;
    N24.Enabled := N20.Enabled and (not CDS.FieldByName('IsEmpty').AsBoolean);
  end;
end;

procedure TFrmMPST012.N20Click(Sender: TObject);
var
  tmpStr: string;
  tmpSdate: TDateTime;
  P: TBookMark;
begin
  inherited;
  l_Ans := True;
  l_SelList.Clear;
  tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
  P := CDS.GetBookmark;
  CDS.DisableControls;
  try
    while not CDS.Bof do
    begin
      CDS.Prior;
      if tmpSdate = CDS.FieldByName('Sdate').AsDateTime then
        P := CDS.GetBookmark
      else
        Break;
    end;

    CDS.GotoBookmark(P);
    while not CDS.Eof do
    begin
      if tmpSdate = CDS.FieldByName('Sdate').AsDateTime then
      begin
        tmpStr := CDS.FieldByName('Sdate').AsString + '@' + CDS.FieldByName('Stype').AsString + '@' + CDS.FieldByName('Sno').AsString;
        if l_SelList.IndexOf(tmpStr) = -1 then
          l_SelList.Add(tmpStr);
      end
      else
        Break;

      CDS.Next;
    end;
  finally
    l_Ans := False;
    CDS.EnableControls;
    CDS.AfterScroll(CDS);
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST012.N21Click(Sender: TObject);
begin
  inherited;
  l_SelList.Clear;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST012.N22Click(Sender: TObject);
var
  i: Integer;
  tmpList: TStrings;
begin
  inherited;
  if l_SelList.Count = 0 then
  begin
    ShowMsg('請選擇要返回的單據!', 48);
    Exit;
  end;

  l_Ans := True;
  CDS.DisableControls;
  tmpList := TStringList.Create;
  try
    for i := 0 to l_SelList.Count - 1 do
    begin
      tmpList.DelimitedText := StringReplace(l_SelList.Strings[i], '@', ',', [rfReplaceAll]);
      if not CDS.Locate('sdate;stype;sno', VarArrayOf([tmpList.Strings[0], tmpList.Strings[1], tmpList.Strings[2]]), []) then
      begin
        ShowMsg('未定位到單據!', 48);
        Exit;
      end;

      if CDS.FieldByName('isempty').AsBoolean then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        ShowMsg('空行不可返回!', 48);
        Exit;
      end;

      CDS.Edit;
      CDS.FieldByName('notvisible').AsBoolean := True;
      CDS.Post;
    end;

    if PostBySQLFromDelta(CDS, p_TableName, l_pk) then
    begin
      l_SelList.Clear;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
    FreeAndNil(tmpList);
    CDS.AfterScroll(CDS);
    CDS.EnableControls;
    RefreshColor;
  end;
end;

procedure TFrmMPST012.N23Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if ShowMsg('刪除不可恢複,確定要刪除嗎?', 33) = IDCancel then
    Exit;

  CDS.Delete;
  PostBySQLFromDelta(CDS, p_TableName, l_pk);
  RefreshColor;
end;

procedure TFrmMPST012.N24Click(Sender: TObject);
var
  i: Integer;
  tmpList: TStrings;
  tmpSno: Integer;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or CDS.FieldByName('IsEmpty').AsBoolean then
    Exit;

  if ShowMsg('確定複製此筆資料嗎?', 33) = IdCancel then
    Exit;

  tmpSno := -1;
  if not GetMaxSno(CDS.FieldByName('Sdate').AsDateTime, tmpSno) then
    Exit;

  l_Ans := True;
  tmpList := TStringList.Create;
  try
    for i := 0 to CDS.FieldCount - 1 do
      tmpList.Add(Trim(CDS.Fields[i].AsString));

    CDS.Append;
    for i := 0 to CDS.FieldCount - 1 do
    begin
      if CDS.Fields[i].FieldName <> 'pno2' then
        CDS.Fields[i].AsString := tmpList.Strings[i];
    end;
    CDS.FieldByName('Sno').AsInteger := tmpSno;
    CDS.Post;
    PostBySQLFromDelta(CDS, p_TableName, l_pk);
  finally
    l_Ans := False;
    FreeAndNil(tmpList);
    CDS.AfterScroll(CDS);
    RefreshColor;
  end;
end;

procedure TFrmMPST012.PopupMenu2Popup(Sender: TObject);
begin
  inherited;
  N31.Visible := CDS3.Active and (not CDS3.IsEmpty);
  N32.Visible := N31.Visible;
  N33.Visible := N31.Visible;
  N34.Visible := N31.Visible;
end;

procedure TFrmMPST012.N31Click(Sender: TObject);
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if ShowMsg('確定要刪除此筆資料嗎?', 33) = IDOK then
  begin
    if DBGridEh3.SelectedRows.Count > 1 then
      DBGridEh3.SelectedRows.Delete
    else
      CDS3.Delete;
  end;
end;

procedure TFrmMPST012.N32Click(Sender: TObject);
var
  i: Integer;
  tmpList: TStrings;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  l_Ans := True;
  tmpList := TStringList.Create;
  try
    for i := 0 to CDS3.FieldCount - 1 do
      tmpList.Add(Trim(CDS3.Fields[i].AsString));

    CDS3.Append;
    for i := 0 to CDS3.FieldCount - 1 do
      if Length(tmpList.Strings[i]) > 0 then
        CDS3.Fields[i].AsString := tmpList.Strings[i];

    // longxinjue 2022.01.10
    CDS3.FieldByName('uuid').AsString := GetGUID;

    CDS3.Post;
    CDS3.MergeChangeLog;
  finally
    l_Ans := False;
    FreeAndNil(tmpList);
  end;
end;

procedure TFrmMPST012.N33Click(Sender: TObject);
var
  i, j, totQty, qty, remainQty, cnt: Integer;
  tmpCDS: TClientDataSet;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if Pos('.', FloatToStr(CDS3.FieldByName('sqty').AsFloat)) > 0 then
  begin
    ShowMsg('原數量必需>0,而且為整數!', 48);
    Exit;
  end;

  totQty := CDS3.FieldByName('sqty').AsInteger;
  if totQty <= 0 then
  begin
    ShowMsg('原數量必需>0,而且為整數!', 48);
    Exit;
  end;

  if not Assigned(FrmMPST012_copy) then
    FrmMPST012_copy := TFrmMPST012_copy.Create(Application);
  FrmMPST012_copy.l_qty := totQty;
  if FrmMPST012_copy.ShowModal <> mrOK then
    Exit;

  qty := StrToIntDef(FrmMPST012_copy.Edit1.Text, 0);
  if (qty <= 0) or (qty > totQty) then
    Exit;

  remainQty := totQty mod qty;
  cnt := Trunc(totQty / qty);
  if remainQty = 0 then
    Dec(cnt);

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS3.Data;
    tmpCDS.EmptyDataSet;
    i := 1;
    while i <= cnt do
    begin
      tmpCDS.Append;
      for j := 0 to tmpCDS.FieldCount - 1 do
        tmpCDS.Fields[j].Value := CDS3.Fields[j].Value;
      tmpCDS.FieldByName('sqty').AsFloat := qty;
      if not CDS3.FieldByName('sdate').IsNull then
        tmpCDS.FieldByName('sdate').AsDateTime := CDS3.FieldByName('sdate').AsDateTime + i;

      // longxinjue 2022.01.10
      tmpCDS.FieldByName('uuid').AsString := GetGUID;

      tmpCDS.Post;
      Inc(i);
    end;
    tmpCDS.MergeChangeLog;

    with CDS3 do
    begin
      Edit;
      if remainQty = 0 then
        FieldByName('sqty').AsFloat := qty
      else
        FieldByName('sqty').AsFloat := remainQty;
      Post;
      MergeChangeLog;
      AppendData(tmpCDS.Data, True);
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST012.N34Click(Sender: TObject);
var
  tmpDate: TDateTime;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if CDS3.FieldByName('sdate').IsNull then
  begin
    ShowMsg('請輸入生產日期!', 48);
    Exit;
  end;

  tmpDate := CDS3.FieldByName('sdate').AsDateTime;

  RefreshGrdCaption(CDS3, DBGridEh3, l_StrIndex, l_StrIndexDesc);
  l_Ans := True;
  with CDS3 do
  begin
    DisableControls;
    try
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('sdate').AsDateTime := tmpDate;
        Post;
        Next;
      end;
      MergeChangeLog;
    finally
      EnableControls;
    end;
  end;
  l_Ans := False;
end;

procedure TFrmMPST012.CDS3BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not l_Ans then
    if not DataSet.FieldByName('sdate').IsNull then
      if DataSet.FieldByName('sdate').AsDateTime < Date then
      begin
        ShowMsg('[%s]不能小於當前日期', 48, MyStringReplace(DBGridEh3.FieldColumns['sdate'].Title.Caption));
        Abort;
      end;
end;

procedure TFrmMPST012.DBGridEh3DblClick(Sender: TObject);
begin
  inherited;
  with DBGridEh3 do
  begin
    if Tag = 0 then
    begin
      Tag := 1;
      Options := Options + [dgRowSelect, dgMultiSelect];
      ReadOnly := True;
    end
    else
    begin
      Tag := 0;
      Options := Options - [dgRowSelect, dgMultiSelect] + [dgEditing];
      ReadOnly := not g_MInfo^.R_edit;
    end;
  end;
end;

procedure TFrmMPST012.DBGridEh3TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS3, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST012.btn_mpst012NClick(Sender: TObject);
begin
  inherited;
  FrmMPST012_adqty := TFrmMPST012_adqty.Create(nil);
  try
    FrmMPST012_adqty.ShowModal;
  finally
    FreeAndNil(FrmMPST012_adqty);
  end;
end;

procedure TFrmMPST012.btn_mpst012OClick(Sender: TObject);
begin
  inherited;
  FrmMPST012_adate_qty := TFrmMPST012_adate_qty.Create(nil);
  try
    FrmMPST012_adate_qty.l_sdate := CDS.FieldByName('sdate').AsDateTime;
    FrmMPST012_adate_qty.l_stype := CDS.FieldByName('stype').AsString;
    FrmMPST012_adate_qty.ShowModal;
  finally
    FreeAndNil(FrmMPST012_adate_qty);
  end;
end;

procedure TFrmMPST012.btn_mpst012PClick(Sender: TObject);
begin
  inherited;
  FrmMPST012_PnoSum := TFrmMPST012_PnoSum.Create(nil);
  try
    FrmMPST012_PnoSum.ShowModal;
  finally
    FreeAndNil(FrmMPST012_PnoSum);
  end;
end;

procedure TFrmMPST012.btn_mpst012QClick(Sender: TObject);
var
  tmpStr1, tmpStr2: string;
  d1, d2: TDateTime;
  Pos1: Integer;
begin
  inherited;
  //格式: btn_mpst012Q.Hint=A&B
  tmpStr1 := btn_mpst012Q.Hint;
  Pos1 := Pos('&', tmpStr1);
  if Pos1 = 0 then
    Exit;

  tmpStr2 := Copy(tmpStr1, Pos1 + 1, 20);  //B
  tmpStr1 := Copy(tmpStr1, 1, Pos1 - 1);   //A

  try
    d1 := StrToDate(tmpStr1);
  except
    Exit;
  end;

  try
    d2 := StrToDate(tmpStr2);
  except
    Exit;
  end;

  if CDS.FieldByName('sdate').AsDateTime = d1 then
    CDS.Locate('sdate', d2, [])
  else
    CDS.Locate('sdate', d1, []);
end;

procedure TFrmMPST012.DBGridEh2Columns6UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText, Handled: Boolean);
var
  sdate: TDateTime;
  adate: TDateTime;
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
    exit;

  sdate := CDS2.FieldByName('sdate').AsDateTime;
  adate := CDS2.FieldByName('adate').AsDateTime;
  if (strtodate(Text) < sdate) then
  begin
    ShowMsg('[%s]不能小於生產日期', 48, MyStringReplace(DBGridEh2.FieldColumns['adate'].Title.Caption));
    Value := adate;
    UseText := false;
    ;
  end
  else
  begin
    // 讓生管交付日期與歷史生管交付日期一致 longxinjue 2022.01.05
    CDS2.FieldByName('adate_old').Value := strtodate(Text);
  end;
end;

procedure TFrmMPST012.DBGridEh2CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
    exit;

  if SameText(Column.FieldName, 'adate') then
  begin
    //CDS2.Edit;
    DS2.AutoEdit := true;
    with DBGridEh2 do
    begin
      if (g_MInfo^.R_edit) then
      begin
        Options := Options - [dgRowSelect, dgMultiSelect] + [dgEditing];
        ReadOnly := false;
      end;
    end;
    //CDS2.Post;
  end
  else
  begin
    DS2.AutoEdit := false;
    with DBGridEh2 do
    begin
      Options := Options + [dgRowSelect, dgMultiSelect];
      ReadOnly := True;
    end;
  end;
end;

procedure TFrmMPST012.CDS2BeforePost(DataSet: TDataSet);
begin
  inherited;
  if (not DataSet.FieldByName('sdate').IsNull) and (not DataSet.FieldByName('adate').IsNull) then
    if (DataSet.FieldByName('sdate').AsDateTime) > (DataSet.FieldByName('adate').AsDateTime) then
    begin
      ShowMsg('[%s]不能小於生產日期', 48, MyStringReplace(DBGridEh2.FieldColumns['adate'].Title.Caption));
      Abort;
    end;
end;

procedure TFrmMPST012.DBGridEh3Columns4UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText, Handled: Boolean);
begin
  inherited;

  if (not CDS3.Active) or CDS3.IsEmpty then
    exit;

  // longxinjue 2022.01.07 排制數量小於訂單數量的話，加投數量為 0

  if (strtofloat(Text) <= CDS3.FieldByName('sQty').AsFloat) then
    CDS3.FieldByName('regulateQty').AsFloat := 0
  else
    CDS3.FieldByName('regulateQty').AsFloat := strtofloat(Text) - CDS3.FieldByName('orderQty').AsFloat;
end;

procedure TFrmMPST012.btn_mpst012SClick(Sender: TObject);
begin
  inherited;

  exit;

  if (not CDS3.Active) or CDS3.IsEmpty then
  begin
    ShowMsg('請先選定一條“待排訂單”記錄', 48);
    Exit;
  end;

  FrmMPST012_Stck := TFrmMPST012_Stck.Create(self);
  try

    with FrmMPST012_Stck do
    begin
      with CDS3 do
      begin
        //clsStock.gid := GetGUID;
        clsStock.uuid := FieldByName('uuid').AsString;
        clsStock.orderBu := FieldByName('orderBu').AsString;
        clsStock.orderno := FieldByName('orderno').AsString;
        clsStock.orderitem := FieldByName('orderitem').AsInteger;
        clsStock.materialno := FieldByName('materialno').AsString;
        clsStock.orderQty := FieldByName('orderQty').AsFloat;
        clsStock.sQty := FieldByName('orderQty').AsFloat;
        clsStock.custno := FieldByName('custno').AsString;
        clsStock.custom := FieldByName('custom').AsString;
        clsStock.dbtype := '';
        clsStock.wareHouseNo := '';
        clsStock.storageNo := '';
        clsStock.batchNo := '';
        clsStock.stockQty := 0;
        clsStock.isActive := 'N';
      end;
      Edit1.Text := clsStock.materialno;

      CDS1.Data := l_CDS_Stock.Data;
      CDS1.Filtered := false;
      CDS1.Filter := 'uuid=' + Quotedstr(clsStock.uuid);
      CDS1.Filtered := true;
    end;

    if FrmMPST012_Stck.ShowModal = mrOK then
    begin
      l_CDS_Stock.Data := FrmMPST012_Stck.CDS1.Data;
    end;

  finally
    FreeAndNil(FrmMPST012_Stck);
  end;
end;

function TFrmMPST012.InitCDSStock(): Boolean;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := False;

  tmpSQL := 'select * from MPS012_Stock where 1=2';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  l_CDS_Stock.Data := Data;

  Result := True;
end;

function TFrmMPST012.SaveOrderStockInfo(MDS: TClientDataSet; ODS: TClientDataSet): TClientDataSet;
var
  i: Integer;
  uuid1, uuid2: string;
  isActive: string;
  tmpCDS: TClientdataset;
  dt: TDateTime;
begin

  dt := now;

  tmpCDS := TClientdataset.Create(nil);
  tmpCDS.Data := ODS.Data;
  tmpCDS.EmptyDataSet;

  if (ODS.IsEmpty) or (MDS.IsEmpty) then
  begin
    Result := tmpCDS;
    exit;
  end;

  try

    MDS.First;
    while not MDS.Eof do // a1
    begin
      uuid1 := MDS.FieldByName('uuid').AsString;

      ODS.First;
      while not ODS.Eof do // b1
      begin
        uuid2 := ODS.FieldByName('uuid').AsString;
        isActive := uppercase(ODS.FieldByName('isActive').AsString);

        if (SameText(uuid1, uuid2) and SameText(isActive, 'N')) then  // c1
        begin
          try
            tmpCDS.Append;
            for i := 0 to tmpCDS.FieldCount - 1 do
              tmpCDS.Fields[i].Value := ODS.Fields[i].Value;

            tmpCDS.FieldByName('Bu').AsString := g_UInfo^.BU;
            tmpCDS.FieldByName('isActive').AsString := 'Y';
            tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
            tmpCDS.FieldByName('Idate').AsDateTime := Now;
            tmpCDS.FieldByName('ChangeDate').AsDateTime := dt; // 調換操作日期
            tmpCDS.Post;
          finally
          end;
        end; // c1

        ODS.Next;
      end; // b1

      MDS.Next;
    end; // a1
  finally
  end;

  Result := tmpCDS;
end;

procedure TFrmMPST012.DBGridEh1TitleBtnClick(Sender: TObject; ACol: Integer; Column: TColumnEh);
begin
  inherited;
  CDS.IndexFieldNames := 'pno2';
end;

procedure TFrmMPST012.btn_mpst070RClick(Sender: TObject);
var
  tmpStr1: string;
begin
  inherited;

  tmpStr1 := '';
  if not Assigned(FrmMPST070_CalCCL) then
    FrmMPST070_CalCCL := TFrmMPST070_CalCCL.Create(Self);
  FrmMPST070_CalCCL.FormStyle := fsStayOnTop;
  FrmMPST070_CalCCL.Show;
end;

procedure TFrmMPST012.btn_mpst012TClick(Sender: TObject);
const
  updateSql = 'update mps012 set oqcqty=%d,sqty=sqty+%d where bu=''%s'' and sdate=''%s'' and stype=''%s'' and sno=%d';
var
  inputQty, sql: string;
  qty: Integer;
begin
  inherited;
  if not InputQuery('提示', '請輸入取樣數量', inputQty) then
    Exit;
  qty := StrToIntDef(inputQty, -1);
  if qty = -1 then
  begin
    ShowMsg('請輸入有效數量');
    exit;
  end;
  sql := Format(updateSql, [qty, qty, g_UInfo^.BU, CDS.FieldByName('sdate').AsString, CDS.FieldByName('stype').AsString, CDS.FieldByName('sno').AsInteger]);
  if PostBySQL(sql) then
  begin
    CDS.FieldByName('oqcqty').Value := qty;
    CDS.FieldByName('sqty').Value := CDS.FieldByName('sqty').Value + qty;
  end;
end;

end.

