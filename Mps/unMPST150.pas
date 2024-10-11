{*******************************************************}
{                                                       }
{                unMPSI010                              }
{                Author: kaikai                         }
{                Create date: 2015/12/20                }
{                Description: 主排程程式                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST150;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, Buttons, ExtCtrls, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, Math;

const
  l_Color1 = 16772300;  //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPST150 = class(TFrmSTDI030)
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    DS3: TDataSource;
    CDS3: TClientDataSet;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    RG1: TRadioGroup;
    RG2: TRadioGroup;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RG1Click(Sender: TObject);
    procedure RG2Click(Sender: TObject);

    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
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
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDS3AfterScroll(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
//    procedure CheckMater();
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    l_Ans, l_LockAns, l_OptLockAns: Boolean;
    l_SelList, l_ErrList, l_ColorList, l_ErrorIdList: TStrings; //選擇,錯誤提示,顏色,異常重排單號
    l_StrIndex: string;
    l_StrIndexDesc: string;
    l_CDS670: TClientDataSet;
    l_CheckMater_RecNo: TStrings; // 記錄混號的行號 lxj
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetEdit3;
    procedure RefreshColor;
    procedure SetNewRecordData(DataSet: TDataSet);
    procedure GetSumQty;
    { Private declarations }
  public
    function GetTotBooks(DataSet: TCLientDataSet): Double;
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST150: TFrmMPST150;


implementation

uses
  unGlobal, unCommon;

const
  l_JumpHint = '光標跳轉到調整的鍋次';

{$R *.dfm}
//過濾數據
procedure TFrmMPST150.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
begin
  l_SelList.Clear;
  with xCDS do
  begin
    Filtered := False;
    if xRG.ItemIndex = -1 then
      Filter := 'machine=''@'''
    else
      Filter := 'errorflag<>1 and machine=' + Quotedstr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

procedure TFrmMPST150.SetEdit3;
begin
  if PCL.ActivePageIndex = 0 then
  begin
    if CDS.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
    Edit4.Text := IntToStr(CDS.FieldByName('CurrentBoiler').AsInteger);
  end
  else if PCL.ActivePageIndex = 1 then
  begin
    if CDS2.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS2.FieldByName('Sdate').AsDateTime);
    Edit4.Text := IntToStr(CDS2.FieldByName('CurrentBoiler').AsInteger);
  end
  else
  begin
    Edit3.Text := '';
    Edit4.Text := '0';
  end
end;

procedure TFrmMPST150.RefreshColor;
var
  tmpStr, tmpValue: string;
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

    tmpValue := '1';
    tmpStr := '@';
    while not tmpCDS.Eof do
    begin
      if tmpStr <> tmpCDS.FieldByName('Stealno').AsString then
      begin
        if tmpValue = '1' then
          tmpValue := '2'
        else
          tmpValue := '1';
      end;
      l_ColorList.Add(tmpValue);
      tmpStr := tmpCDS.FieldByName('Stealno').AsString;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST150.SetNewRecordData(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('BU').AsString := g_UInfo^.BU;
    FieldByName('Iuser').AsString := g_UInfo^.UserId;
    FieldByName('Idate').AsDateTime := Now;
    FieldByName('Muser').Clear;
    FieldByName('Mdate').Clear;
    FieldByName('Lock').AsBoolean := False;
    FieldByName('EmptyFlag').AsInteger := 0;
    FieldByName('ErrorFlag').AsInteger := 0;
    FieldByName('Case_ans1').AsBoolean := False;
    FieldByName('Case_ans2').AsBoolean := False;
    FieldByName('Move_ans').AsBoolean := False;
  end;
end;

procedure TFrmMPST150.GetSumQty;
var
  tmpSQL, tmpMachine, S9_11: string;
  tmpSdate: TDateTime;
  tmpCurrentBoiler: Integer;
  Qty1, Qty2, tmpSqty: Double;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Edit5.Text := '0';
  Edit6.Text := '0';
  if ((PCL.ActivePageIndex = 0) and CDS.IsEmpty) or ((PCL.ActivePageIndex = 1) and CDS2.IsEmpty) or (PCL.ActivePageIndex = 2) then
    Exit;

  if not l_CDS670.Active then
  begin
    tmpSQL := 'select size_l,size_h,d,m from mps670 where bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    l_CDS670.Data := Data;
  end;

  Qty1 := 0;
  Qty2 := 0;
  tmpSdate := Date;
  tmpCurrentBoiler := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    if PCL.ActivePageIndex = 0 then
    begin
      tmpMachine := CDS.FieldByName('Machine').AsString;
      tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
      tmpCurrentBoiler := CDS.FieldByName('CurrentBoiler').AsInteger;
      tmpCDS.Data := CDS.Data;
    end
    else if PCL.ActivePageIndex = 1 then
    begin
      tmpMachine := CDS2.FieldByName('Machine').AsString;
      tmpSdate := CDS2.FieldByName('Sdate').AsDateTime;
      tmpCurrentBoiler := CDS2.FieldByName('CurrentBoiler').AsInteger;
      tmpCDS.Data := CDS2.Data;
    end;

    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'Machine=' + Quotedstr(tmpMachine) + ' And Sdate=' + Quotedstr(DateToStr(tmpSdate)) + ' And (ErrorFlag=0 or ErrorFlag is null)' + ' And (Sqty is not null) And Sqty<>0';
      Filtered := True;
      while not Eof do
      begin
        S9_11 := Copy(FieldByName('Materialno').AsString, 9, 3);
        l_CDS670.Filtered := False;
        l_CDS670.Filter := 'size_l<=' + Quotedstr(S9_11) + ' and size_h>=' + Quotedstr(S9_11);
        l_CDS670.Filtered := True;
        if l_CDS670.IsEmpty then
          tmpSqty := FieldByName('Sqty').AsFloat
        else
          tmpSqty := Ceil(FieldByName('Sqty').AsFloat / l_CDS670.FieldByName('d').AsInteger * l_CDS670.FieldByName('m').AsInteger);
        if FieldByName('CurrentBoiler').AsInteger = tmpCurrentBoiler then
          Qty1 := Qty1 + tmpSqty;
        Qty2 := Qty2 + tmpSqty;
        Next;
      end;
    end;

    Edit5.Text := FloatToStr(Qty1);
    Edit6.Text := FloatToStr(Qty2);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

function TFrmMPST150.GetTotBooks(DataSet: TCLientDataSet): Double;
var
  k: Double; //k 倍數
  tmpC9_11: string;
  tmpTotBooks: Double;
begin
  tmpTotBooks := 0;
  with DataSet do
    while not Eof do
    begin
      if Pos(UpperCase(FieldByName('machine').AsString), g_MachineCCL_GZ) > 0 then
      begin
        k := 2;
        tmpC9_11 := UpperCase(Copy(FieldByName('materialno').AsString, 9, 3));
        if (tmpC9_11 < '300') and (tmpC9_11 <> '230') then
          k := 3
        else if (tmpC9_11 >= '431') and (tmpC9_11 <= '739') then
          k := 1.5
        else if Pos(tmpC9_11, '740/820/860') > 0 then
          k := 1;
      end
      else
        k := 1;

      if FieldByName('book_qty').AsFloat <> 0 then
        tmpTotBooks := tmpTotBooks + FieldByName('sqty').AsFloat / FieldByName('book_qty').AsFloat / k;
      Next;
    end;

  Result := RoundTo(tmpTotBooks, -3);
end;

procedure TFrmMPST150.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From ' + p_TableName + ' a left join mps018 b on a.wono=b.wono and a.machine=b.machine Where isnull(a.wono,'''')<>'''' and Bu=' + Quotedstr(g_UInfo^.BU) + ' And IsNull(Case_ans2,0)=0 ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST150.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS010';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  RG2.Tag := 1;
  l_CDS670 := TClientDataSet.Create(Self);

  inherited;

  GetMPSMachine;
  CDS.IndexFieldNames := 'Machine;Jitem;spy;OZ;Materialno;Simuver;Citem';
  CDS2.IndexFieldNames := 'Machine;Jitem';
  RG1.Items.DelimitedText := g_MachineCCL;
  RG2.Items.DelimitedText := g_MachineCCL;
  DBGridEh2.FieldColumns['machine1'].PickList.DelimitedText := g_MachineCCL;
  DBGridEh3.FieldColumns['machine1'].PickList.DelimitedText := g_MachineCCL;

  btn_insert.Visible := False;
  btn_edit.Visible := False;
  btn_delete.Visible := False;
  btn_copy.Visible := False;
  btn_post.Visible := False;
  btn_cancel.Visible := False;
  btn_print.Visible := False;

  TabSheet1.Caption := CheckLang('已確認排程');
  TabSheet2.Caption := CheckLang('預排結果');
  TabSheet3.Caption := CheckLang('待排訂單');
  Label3.Caption := CheckLang('生產日期/鍋次');
  Label4.Caption := CheckLang('數量');
  SetGrdCaption(DBGridEh2, p_TableName);
  SetGrdCaption(DBGridEh3, 'oea_file');

  DBGridEh2.ReadOnly := not g_MInfo^.R_edit;
  DBGridEh3.ReadOnly := not g_MInfo^.R_edit;

  with DBGridEh2 do
    for i := 0 to FieldCount - 1 do
      Columns[i].Title.Caption := DBGridEh1.FieldColumns[Columns[i].FieldName].Title.Caption;

  CDS2.Data := CDS.Data;
  CDS2.EmptyDataSet;
  l_SelList := TStringList.Create;
  l_ErrList := TStringList.Create;
  l_ColorList := TStringList.Create;
  l_ErrorIdList := TStringList.Create;

  RG1.Tag := 0;
  RG2.Tag := 0;
  RG1.ItemIndex := 0;
  RG2.ItemIndex := 0;
  if SameText(g_UInfo^.BU, 'ITEQJX') then
  begin
    Panel3.Width := Panel3.Width + 10;
    RG1.Width := RG1.Width + 10;
    RG1.Height := RG1.Height + 100;

    Panel2.Width := Panel3.Width;
    RG2.Width := RG1.Width;
    RG2.Height := RG1.Height;
  end;

  l_CheckMater_RecNo := TStringList.Create;
end;

procedure TFrmMPST150.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if l_OptLockAns then
    UnLockProc;

  inherited;

  FreeAndNil(l_CDS670);
  FreeAndNil(l_SelList);
  FreeAndNil(l_ErrList);
  FreeAndNil(l_ColorList);
  FreeAndNil(l_ErrorIdList);

  CDS2.Active := False;
  CDS3.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;

  FreeAndNil(l_CheckMater_RecNo);
end;

procedure TFrmMPST150.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
  IsLock: Boolean;
begin
//  inherited;
  if not GetQueryString(p_TableName, tmpStr) then
    Exit;

  RefreshDS(tmpStr);
  RefreshData(RG1, CDS);
  PCL.ActivePageIndex := 0;
  RefreshColor;
  DBGridEh1.Repaint;

  if not l_OptLockAns then
    if CheckLockProc(IsLock) then
      l_LockAns := IsLock;
end;

procedure TFrmMPST150.btn_firstClick(Sender: TObject);
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

procedure TFrmMPST150.btn_priorClick(Sender: TObject);
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

procedure TFrmMPST150.btn_nextClick(Sender: TObject);
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

procedure TFrmMPST150.btn_lastClick(Sender: TObject);
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

procedure TFrmMPST150.btn_quitClick(Sender: TObject);
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

procedure TFrmMPST150.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST150.RG2Click(Sender: TObject);
begin
  inherited;
  if (not CDS2.Active) or (RG2.Tag = 1) then
    Exit;
  RefreshData(RG2, CDS2);
  RefreshColor;
  DBGridEh2.Repaint;
end;

procedure TFrmMPST150.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  tmpStr: string;
  lp: Integer;
begin
  inherited;
//  if SameText(Column.FieldName, 'select') then
//  begin
//    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
//    if l_SelList.IndexOf(tmpStr) <> -1 then
//      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
//  end;
//
//  if SameText(Column.FieldName, 'materialno') then
//  begin
//    for lp := 0 to l_CheckMater_RecNo.Count - 1 do
//      if CDS.RecNo = strtoint(l_CheckMater_RecNo.Strings[lp]) then
//      begin
//        DBGridEh1.Canvas.Font.Color := clGreen;
//        DBGridEh1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
//      end;
//  end;
end;

procedure TFrmMPST150.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
//  if (not CDS.Active) or CDS.IsEmpty then
//    Exit;
//
//  tmpStr := LowerCase(Copy(CDS.FieldByName('materialno').AsString, 2, 1));
//  if Pos(tmpStr, 'q8fnu') > 0 then
//    AFont.Color := clRed;
//
//  tmpStr := CDS.FieldByName('stealno').AsString;
//  if (LowerCase(Column.FieldName) = 'stealno') and ((Pos('37-', tmpStr) > 0) or (Pos('40-', tmpStr) > 0) or (Pos('55-', tmpStr) > 0)) then
//    Background := clMenuHighlight
//  else if l_ColorList.Count >= CDS.RecNo then
//  begin
//    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
//      Background := l_Color2
//    else
//      Background := l_Color1;
//  end;
//
//  if LowerCase(Column.FieldName) = 'remain_ordqty' then
//    if not CDS.FieldByName('remain_ordqty').IsNull then
//      if CDS.FieldByName('remain_ordqty').AsFloat < CDS.FieldByName('orderqty').AsFloat then
//        Background := clMenuHighlight;
if  CDS.FieldByName('taked').AsBoolean then
   Background := l_Color1;
end;

procedure TFrmMPST150.CDSAfterCancel(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSAfterEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSAfterInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSAfterScroll(DataSet: TDataSet);
begin
//  if L_Ans then
//    Exit;
//
//  inherited;
//  SetEdit3;
//  GetSumQty;
end;

procedure TFrmMPST150.CDSBeforeDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSBeforeEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSBeforeInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDSNewRecord(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST150.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;

  if (Trim(CDS2.FieldByName('Orderno').AsString) <> '') and CDS3.Active then
    CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]), []);
  SetEdit3;
  SetSBars(CDS2);
  GetSumQty;
end;

procedure TFrmMPST150.CDS2BeforePost(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  if CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]), []) then
  begin
    l_Ans := True;
    CDS3.Edit;
    CDS3.FieldByName('Sdate1').Value := CDS2.FieldByName('Sdate1').Value;
    CDS3.FieldByName('Machine1').Value := CDS2.FieldByName('Machine1').Value;
    CDS3.FieldByName('Boiler1').Value := CDS2.FieldByName('Boiler1').Value;
    CDS3.Post;
    l_Ans := False;
  end;
end;

procedure TFrmMPST150.CDS3AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  SetSBars(CDS3);
end;

procedure TFrmMPST150.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  SetNewRecordData(DataSet);
end;

procedure TFrmMPST150.PCLChange(Sender: TObject);
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

procedure TFrmMPST150.btn_editClick(Sender: TObject);
begin
//  inherited;

end;

procedure TFrmMPST150.btn_deleteClick(Sender: TObject);
begin
//  inherited;

end;

procedure TFrmMPST150.DBGridEh1DblClick(Sender: TObject);
var
  sql: string;
begin
  inherited;
  if CDS.FieldByName('taked').AsBoolean then
  begin
    if Application.MessageBox('確定取消取樣?', '提示', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
    begin
      sql := Format('exec proc_Mpst150 %s,%s,%d', [QuotedStr(CDS.fieldbyname('machine').AsString), QuotedStr(CDS.fieldbyname('wono').AsString), 0]);
      PostBySQL(sql);
      CDS.edit;
      CDS.FieldByName('taked').AsBoolean:=false;
    end;
  end
  else
  begin
    if Application.MessageBox('確定取樣?', '提示', MB_OKCANCEL + MB_ICONQUESTION) = IDOK then
    begin
      sql := Format('exec proc_Mpst150 %s,%s,%d', [QuotedStr(CDS.fieldbyname('machine').AsString), QuotedStr(CDS.fieldbyname('wono').AsString), 1]);
      PostBySQL(sql);
      CDS.edit;
      CDS.FieldByName('taked').AsBoolean:=true;
    end;
  end;
end;

end.

