{*******************************************************}
{                                                       }
{                unMPST040                              }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: 出貨排程                  }
{      AfterScroll快速瀏覽時,同步查詢CDS2,CDS3,CDS4慢,  }
{      使用timer延時加載最后的數據                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI060, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, StdCtrls, Buttons, jpeg, ExtCtrls, Menus, DB, ImgList, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, DateUtils, Math, unMPS_IcoFlag, Grids, Clipbrd;

type
  TFrmMPST040 = class(TFrmSTDI060)
    CDS3: TClientDataSet;
    DS3: TDataSource;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    LblTot: TLabel;
    btn_mpst040A: TBitBtn;
    btn_mpst040B: TBitBtn;
    Image1: TImage;
    ImageList2: TImageList;
    btn_garbage: TToolButton;
    btn_color: TToolButton;
    btnmenu: TPopupMenu;
    bm1: TMenuItem;
    bm2: TMenuItem;
    bm3: TMenuItem;
    bm4: TMenuItem;
    ToolButton200: TToolButton;
    PnlRight: TPanel;
    btn_mpst040N: TBitBtn;
    btn_mpst040C: TBitBtn;
    btn_mpst040D: TBitBtn;
    btn_mpst040E: TBitBtn;
    btn_mpst040F: TBitBtn;
    btn_mpst040G: TBitBtn;
    btn_mpst040H: TBitBtn;
    btn_mpst040I: TBitBtn;
    btn_mpst040J: TBitBtn;
    btn_mpst040K: TBitBtn;
    btn_mpst040M: TBitBtn;
    btn_mpst040O: TBitBtn;
    btn_mpst040L: TBitBtn;
    bm5: TMenuItem;
    TabSheet4: TTabSheet;
    DBGridEh4: TDBGridEh;
    DS4: TDataSource;
    CDS4: TClientDataSet;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    btn_mpst040_total: TButton;
    TabSheet5: TTabSheet;
    DBGridEh6: TDBGridEh;
    CDS5: TClientDataSet;
    DS5: TDataSource;
    DBGridEh5: TDBGridEh;
    CDS6: TClientDataSet;
    DS6: TDataSource;
    Panel2: TPanel;
    btn_mpst040Q: TBitBtn;
    StringGrid1: TStringGrid;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btn_mpst040AClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_mpst040DClick(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State:
      TGridDrawState);
    procedure btn_mpst040EClick(Sender: TObject);
    procedure btn_mpst040IClick(Sender: TObject);
    procedure btn_mpst040BClick(Sender: TObject);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure btn_mpst040JClick(Sender: TObject);
    procedure btn_mpst040CClick(Sender: TObject);
    procedure btn_mpst040KClick(Sender: TObject);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure btn_mpst040GClick(Sender: TObject);
    procedure btn_mpst040HClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_garbageClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure bm1Click(Sender: TObject);
    procedure bm2Click(Sender: TObject);
    procedure bm3Click(Sender: TObject);
    procedure bm4Click(Sender: TObject);
    procedure btn_mpst040LClick(Sender: TObject);
    procedure btn_mpst040MClick(Sender: TObject);
    procedure btn_mpst040NClick(Sender: TObject);
    procedure btn_mpst040OClick(Sender: TObject);
    procedure bm5Click(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure DBGridEh4GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure btn_mpst040_totalClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure CDS5AfterScroll(DataSet: TDataSet);
    procedure DBGridEh6DblClick(Sender: TObject);
    procedure btn_mpst040QClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
  private    { Private declarations }
    l_MPS_IcoFlag: TMPS_IcoFlag;
    l_img02All, l_img02Out: string;
    l_Indate: TDateTime;
    l_Img: TBitmap;
    l_sql2, l_sql3, l_sql4, l_lastCode: string;
    l_bool2: Boolean;
    l_list2, l_list3, l_list4: TStrings;
    procedure RefreshDS3;
    procedure RefreshDS4;
    procedure RefreshDS5;
    procedure RefreshDS6;
    procedure SetBtnEnabled(bool: Boolean);
    procedure CalcTotQty;
    procedure SetW_pno;
    procedure GetLastCode;
    procedure SetQtyColor(ColorIndex: Integer);
    procedure Notcount1Change(Sender: TField);
  public    { Public declarations }
    l_StrIndex, l_StrIndexDesc: string;
  protected
    procedure SetToolBar; override;
    procedure RefreshDS1(strFilter: string); override;
    procedure RefreshDS2; override;
  end;

var
  FrmMPST040: TFrmMPST040;

implementation

uses
  unGlobal, unCommon, unMPST040_Indate, unMPST040_ordlist, unMPST040_units, unMPST040_IndateOrd, unFind,
  unMPST040_IndateChg, unMPST040_confirm, unMPST040_mps, unMPST040_pnlwono, unMPST040_UpdateCustOrderno, unMPST040_gz,
  unMPST040_Dtp, unExportXLS;

{$R *.dfm}

procedure TFrmMPST040.SetBtnEnabled(bool: Boolean);
var
  i: Integer;
begin
  for i := 0 to PnlRight.ControlCount - 1 do
    if PnlRight.Controls[i] is TBitBtn then
      if Pos((PnlRight.Controls[i] as TBitBtn).Name, 'btn_cancel,btn_ok') = 0 then
        (PnlRight.Controls[i] as TBitBtn).Enabled := bool;
end;

procedure TFrmMPST040.SetToolBar;
begin
  inherited;
  btn_garbage.Enabled := CDS.Active and (not CDS.IsEmpty) and g_MInfo^.R_garbage and (not (CDS.State in [dsInsert,
    dsEdit]));
  btn_color.Enabled := CDS.Active and (not CDS.IsEmpty) and g_MInfo^.R_edit and (not (CDS.State in [dsInsert, dsEdit]));
end;

procedure TFrmMPST040.RefreshDS1(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'exec proc_MPST040_query %s,%s';
  tmpSQL := Format(tmpSQL, [Quotedstr(g_UInfo^.Bu), Quotedstr(strFilter)]);

  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  Panel2.Visible := false;
  inherited;
end;

procedure TFrmMPST040.RefreshDS2;
var
  tmpSQL: string;
begin
  inherited;
  if not Assigned(l_list2) then  //窗體create時l_list2未創建,基類調用
    Exit;
  if Pos(LeftStr(CDS.FieldByName('pno').AsString, 1), 'ET') > 0 then
    tmpSQL := '1'
  else
    tmpSQL := '0';

  tmpSQL := 'exec dbo.proc_MPST030_3 ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(CDS.FieldByName('orderno').AsString) +
    ',' + IntToStr(CDS.FieldByName('orderitem').AsInteger) + ',1,' + tmpSQL + ',1';

  if l_bool2 then
    tmpSQL := tmpSQL + ' ';
  l_list2.Insert(0, tmpSQL);
end;

procedure TFrmMPST040.RefreshDS3;
var
  tmpSQL: string;
begin

  tmpSQL := 'Select * From MPS200 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(CDS.FieldByName('Orderno').AsString)
    + ' And Orderitem=' + IntToStr(CDS.FieldByName('Orderitem').AsInteger);
  l_list3.Insert(0, tmpSQL);
end;

procedure TFrmMPST040.RefreshDS5;
var
  tmpSQL: string;
  data: olevariant;
begin
  if cds.Active and (not cds.IsEmpty) then
  begin
    tmpSQL := 'Select sfb01,sfb08,sfb09 From sfb_file Where sfb22=' + Quotedstr(CDS.FieldByName('Orderno').AsString) +
      ' And sfb221=' + IntToStr(CDS.FieldByName('Orderitem').AsInteger);
    if QueryBySQL(tmpSQL, data, ifthen(g_uinfo^.BU = 'ITEQDG', 'ORACLE', 'ORACLE1')) then
      CDS5.Data := data;
  end;
end;

procedure TFrmMPST040.RefreshDS6;
var
  tmpSQL: string;
  data: olevariant;
begin
  tmpSQL := 'select * From sfa_file Where sfa01=' + Quotedstr(CDS5.FieldByName('sfb01').AsString);
  if QueryBySQL(tmpSQL, data, ifthen(g_uinfo^.BU = 'ITEQDG', 'ORACLE', 'ORACLE1')) then
    CDS6.Data := data;
end;

procedure TFrmMPST040.RefreshDS4;
var
  tmpSQL, tmpPno: string;
begin
  tmpPno := Copy(CDS.FieldByName('Pno').AsString, 2, Length(CDS.FieldByName('Pno').AsString) - 2);
  tmpSQL :=
    'Select Case Left(srcid,2) When ''wx'' Then ''外購無錫'' When ''tw'' Then ''外購臺灣'' When ''jx'' Then ''外購江西'' else ''未知'' end srcid,'
    + ' pno,purqty,qty,date4,date6,adate,adate_new,oradb,orderno,orderitem,orderno2,orderitem2' +
    ' From MPS650 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And IsNull(isfinish,0)=0 And substring(pno,2,len(pno)-2)=' +
    Quotedstr(tmpPno) + ' Order By Cdate,Cno,Sno';

  { 顯示所有相似料號,後面用用顏色標記是相同訂單
  if Pos(LeftStr(CDS.FieldByName('Orderno').AsString,3),'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z')>0 then  //單別已經決定了廠別,兩廠不會有相同單號,不用oradb條件
     tmpSQL:=tmpSQL+' And Orderno2='+Quotedstr(CDS.FieldByName('Orderno').AsString)
                   +' And Orderitem2='+IntToStr(CDS.FieldByName('Orderitem').AsInteger)
  else
     tmpSQL:=tmpSQL+' And OraDB='+Quotedstr(g_UInfo^.BU)
                   +' And Orderno='+Quotedstr(CDS.FieldByName('Orderno').AsString)
                   +' And Orderitem='+IntToStr(CDS.FieldByName('Orderitem').AsInteger);
  tmpSQL:=tmpSQL+' Order By Cdate,Cno,Sno';
  }

  l_list4.Insert(0, tmpSQL);
end;

procedure TFrmMPST040.CalcTotQty;
var
  i: Integer;
  Arr: array[0..7] of Double;
  tmpCDS: TClientDataSet;
begin
  for i := Low(Arr) to High(Arr) do
    Arr[i] := 0;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    LblTot.Caption := 'CCL應出:0 已出:0    PN應出:0 已出:0    PP應出:0 已出:0    PP應出:0 已出:0';
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    with tmpCDS do
      while not Eof do
      begin
        if SameText(FieldByName('units').AsString, 'SH') then
        begin
          Arr[0] := Arr[0] + FieldByName('Notcount1').AsFloat;
          Arr[1] := Arr[1] + FieldByName('Chkcount').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'RL') or SameText(FieldByName('units').AsString, 'ROL') then
        begin
          Arr[2] := Arr[2] + FieldByName('Notcount1').AsFloat;
          Arr[3] := Arr[3] + FieldByName('Chkcount').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'PN') and (Pos(LeftStr(FieldByName('pno').AsString, 1), 'ET') >
          0) then
        begin
          Arr[4] := Arr[4] + FieldByName('Notcount1').AsFloat;
          Arr[5] := Arr[5] + FieldByName('Chkcount').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'PN') and (Pos(LeftStr(FieldByName('pno').AsString, 1), 'MN') >
          0) then
        begin
          Arr[6] := Arr[6] + FieldByName('Notcount1').AsFloat;
          Arr[7] := Arr[7] + FieldByName('Chkcount').AsFloat;
        end;

        Next;
      end;

    LblTot.Caption := 'CCL應出:' + FloatToStr(Arr[0]) + ' 已出:' + FloatToStr(Arr[1]) + '    PN應出:' + FloatToStr(Arr[4])
      + ' 已出:' + FloatToStr(Arr[5]) + '    PP應出:' + FloatToStr(RoundTo(Arr[2], -3)) + ' 已出:' + FloatToStr(Arr[3])
      + '    PN應出:' + FloatToStr(Arr[6]) + ' 已出:' + FloatToStr(Arr[7]);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST040.SetQtyColor(ColorIndex: Integer);
var
  dsNE1, dsNE2, dsNE3, dsNE4: TDataSetNotifyEvent;
begin
  if not g_MInfo^.R_edit then
    Exit;

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
      PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem');
    finally
      BeforeEdit := dsNE1;
      AfterEdit := dsNE2;
      BeforePost := dsNE3;
      AfterPost := dsNE4;
    end;
  end;
end;

procedure TFrmMPST040.SetW_pno;
var
  dsNE1, dsNE2, dsNE3, dsNE4: TDataSetNotifyEvent;
begin
  if not g_MInfo^.R_edit then
    Exit;

  with CDS do
  begin
    if (not Active) or IsEmpty then
    begin
      ShowMsg('無數據,不可操作!', 48);
      Exit;
    end;

    if (Length(FieldByName('w_pno').AsString) > 0) or (FieldByName('w_pno').AsString = FieldByName('pno').AsString) then
      Exit;

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
      FieldByName('w_pno').AsString := FieldByName('pno').AsString;
      Post;
      PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem');
    finally
      BeforeEdit := dsNE1;
      AfterEdit := dsNE2;
      BeforePost := dsNE3;
      AfterPost := dsNE4;
    end;
  end;
end;

procedure TFrmMPST040.Notcount1Change(Sender: TField);
begin
{  if Length(Trim(CDS.FieldByName('Saleno').AsString))>0 then
  begin
    ShowMsg('此筆已打出貨單,不可更改數量,請使用插單!', 48);
    Abort;
  end;
}
  CDS.FieldByName('Notcount').AsFloat := TField(Sender).AsFloat;
end;

procedure TFrmMPST040.FormCreate(Sender: TObject);
var
  tmpGrdEh: TGrdEh;
begin
  p_SysId := 'Mps';
  p_MainTableName := 'DLI010';
  p_DetailTableName := 'MPSR020';
  p_GridDesignAns1 := True;
  p_GridDesignAns2 := False;
  p_EditFlag := mainEdit;
  l_lastCode := '';
  //btn_color.Left:=btn_quit.Left;
  btn_quit.Left := ToolButton200.Left + ToolButton200.Width;
  btn_garbage.Left := ToolButton1.Left;
  if (not SameText(g_UInfo^.BU, 'ITEQDG')) and (not SameText(g_UInfo^.BU, 'ITEQGZ')) then
    btn_mpst040F.Tag := -1;

  inherited;
  pcl2.ActivePageIndex := 0;
  TabSheet1.Caption := CheckLang('訂單資料');
  TabSheet2.Caption := CheckLang('在製狀況');
  TabSheet3.Caption := CheckLang('交期拆分狀況');
  TabSheet4.Caption := CheckLang('貿易狀況');
  TabSheet5.Caption := CheckLang('備料資料');
  LblTot.Caption := '';
  //SetGrdCaption(DBGridEh3, 'MPS200');
  //SetGrdCaption(DBGridEh4, 'MPS650');

  SetLength(tmpGrdEh.grdEh, 4);
  SetLength(tmpGrdEh.tb, 4);
  tmpGrdEh.grdEh[0] := DBGridEh3;
  tmpGrdEh.grdEh[1] := DBGridEh4;
  tmpGrdEh.grdEh[2] := DBGridEh5;
  tmpGrdEh.grdEh[3] := DBGridEh6;
  tmpGrdEh.tb[0] := 'MPS200';
  tmpGrdEh.tb[1] := 'MPS650';
  tmpGrdEh.tb[2] := 'MPST040_5';
  tmpGrdEh.tb[3] := 'MPST040_6';
  SetMoreGrdCaption(tmpGrdEh);
  tmpGrdEh.grdEh := nil;
  tmpGrdEh.tb := nil;

  l_Img := TBitmap.Create;
  l_list2 := TStringList.Create;
  l_list3 := TStringList.Create;
  l_list4 := TStringList.Create;
  Timer1.Enabled := True;
  Timer2.Enabled := True;
  Timer3.Enabled := True;

  // longxinjue 2022.01.12
  btn_mpst040_total.Caption := CheckLang('線路彙總導出');

  with StringGrid1 do
  begin
    Cells[0, 1] := '出貨總數';
    Cells[0, 2] := '貿易出貨數量';
    Cells[1, 0] := 'CCL(SH)';
    Cells[2, 0] := 'CCL-PNL';
    Cells[3, 0] := 'PP(RL)';
    Cells[4, 0] := 'PP-PNL';
    Cells[5, 0] := '出貨總筆數';
    Cells[6, 0] := '外購料筆數';
  end;
//  dsExport.CreateDataSet;
end;

procedure TFrmMPST040.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
  Timer2.Enabled := False;
  Timer3.Enabled := False;
//  dsExport.free;
  inherited;

  if Assigned(l_MPS_IcoFlag) then
    FreeAndNil(l_MPS_IcoFlag);
  CDS2.Active := False;
  CDS3.Active := False;
  CDS4.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
  DBGridEh5.Free;
  DBGridEh6.Free;
  FreeAndNil(l_Img);
  FreeAndNil(l_list2);
  FreeAndNil(l_list3);
  FreeAndNil(l_list4);
end;

procedure TFrmMPST040.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  l_Indate := DataSet.FieldByName('Indate').AsDateTime;
end;

procedure TFrmMPST040.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  l_Indate := Encodedate(1955, 5, 5);
end;

procedure TFrmMPST040.CDSBeforePost(DataSet: TDataSet);
begin
  if CDS.FieldByName('Chkcount').AsFloat > CDS.FieldByName('Notcount1').AsFloat then
  begin
    ShowMsg('對貨數量不能大於應出數量!', 48);
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName('Chkcount');
    Abort;
  end;

  if DataSet.FieldByName('Indate').IsNull then
  begin
    ShowMsg('請輸入出貨日期!', 48);
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName('Indate');
    Abort;
  end;

  if (DataSet.State in [dsEdit]) and (l_Indate <> DataSet.FieldByName('Indate').AsDateTime) and ((DataSet.FieldByName('CocCount1').AsFloat
    <> 0) or (DataSet.FieldByName('Coc_no').AsString <> '') or (DataSet.FieldByName('ChkCount').AsFloat <> 0)) then
  begin
    ShowMsg('這筆資料已做COC或已對貨' + #13#10 + '不可直接更改出貨日期,請使用複製!', 48);
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;
    ABort;
  end;

  if (l_Indate <> DataSet.FieldByName('Indate').AsDateTime) and CheckConfirm(DataSet.FieldByName('Indate').AsDateTime)
    then
  begin
    ShowMsg('此出貨日期已確認!', 48);
    if DBGridEh1.CanFocus then
      DBGridEh1.SetFocus;
    Abort;
  end;

  if (not DataSet.FieldByName('Stime').IsNull) and (DateOf(DataSet.FieldByName('Stime').AsDateTime) <> EncodeDate(1955,
    5, 5)) then
    DataSet.FieldByName('Stime').AsDateTime := EncodeDate(1955, 5, 5) + TimeOf(DataSet.FieldByName('Stime').AsDateTime);

  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('Dno').AsString := GetSno('DLII010');
    DataSet.FieldByName('Sno').AsInteger := GetMPSSno(CDS.FieldByName('Indate').AsDateTime);
  end;

  inherited;
end;

procedure TFrmMPST040.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Notcount1').OnChange := Notcount1Change;
  CalcTotQty;
end;

procedure TFrmMPST040.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS3;
  RefreshDS4;
  if cds5.Active then
    cds5.EmptyDataSet;
  if cds6.Active then
    cds6.EmptyDataSet;
  if CDS.State in [dsInsert] then
  begin
    Image1.Visible := False;
    Image1.Hint := '';
  end
  else if Image1.Hint <> DateToStr(CDS.FieldByName('Indate').AsDateTime) then
  begin
    Image1.Visible := CheckConfirm(CDS.FieldByName('Indate').AsDateTime);
    Image1.Hint := DateToStr(CDS.FieldByName('Indate').AsDateTime);
  end;

end;

procedure TFrmMPST040.btn_deleteClick(Sender: TObject);
var
  tmpDno, tmpDitem, tmpSQL: string;
  tmpSditem: Integer;
begin
  if CheckConfirm(CDS.FieldByName('Indate').AsDateTime) then
  begin
    ShowMsg(DateToStr(CDS.FieldByName('Indate').AsDateTime) + '出貨表已確認,不可刪除!', 48);
    Exit;
  end;

  tmpDno := CDS.FieldByName('Dno').AsString;
  tmpDitem := CDS.FieldByName('Ditem').AsString;
  tmpSditem := CDS.FieldByName('SourceDitem').AsInteger;
  inherited;

//  if CDS.IsEmpty then
//    ShowMsg('無資料可刪除!', 48)
//  else if ShowMsg('確定要刪除此筆資料嗎?', 33) = IDOK then
//  begin
//    CDS.AfterDelete := nil;
//    try
//      CDS.Delete;
//      tmpSQL := 'delete from dli010 where Bu=%s and dno=%s and ditem=%s';
//      tmpSQL := format(tmpSQL, [Quotedstr(g_UInfo^.BU), Quotedstr(tmpDno), Quotedstr(tmpDitem)]);
//      PostBySQL(tmpSQL);
//    finally
//      CDS.AfterDelete := CDSAfterDelete;
//    end;
//  end;

  if (tmpSditem > 0) and ((CDS.FieldByName('Dno').AsString <> tmpDno) or (CDS.FieldByName('Ditem').AsString <> tmpDitem))
    then
  begin
    tmpSQL := 'Update MPS200 Set Flag=0 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Ditem=' + IntToStr(tmpSditem);
    PostBySQL(tmpSQL);
  end;

  if CDS.Active and CDS.IsEmpty then
  begin
    CDS2.EmptyDataSet;
    CDS3.EmptyDataSet;
  end;
end;

procedure TFrmMPST040.btn_garbageClick(Sender: TObject);
var
  dsNE1, dsNE2, dsNE3, dsNE4: TDataSetNotifyEvent;
begin
  inherited;
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
      FieldByName('GarbageFlag').AsBoolean := not FieldByName('GarbageFlag').AsBoolean;
      Post;
      PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem');
    finally
      BeforeEdit := dsNE1;
      AfterEdit := dsNE2;
      BeforePost := dsNE3;
      AfterPost := dsNE4;
    end;
  end;
end;

procedure TFrmMPST040.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  //inherited;
  if GetQueryString(p_MainTableName, tmpStr) then
  begin
    Image1.Visible := False;
    Image1.Hint := '';

    //應出數量與COC數量相減
    if Pos('Qry_qtycoc', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_qtycoc', 'isnull(Notcount1,0)-isnull(Coccount1,0)', [rfIgnoreCase]);
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount1,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    //CCL或PP
    if Pos('Qry_ppccl', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
        //生產排程包裝站
    if Pos('Qry_isbz', tmpStr) > 0 then
      tmpStr := StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr) = 0 then
      tmpStr := ' And Indate=' + Quotedstr(DateToStr(Date));
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS1(tmpStr);
  end;
end;

procedure TFrmMPST040.btn_mpst040AClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST040_Indate) then
    FrmMPST040_Indate := TFrmMPST040_Indate.Create(Application);
  FrmMPST040_Indate.ShowModal;
end;

procedure TFrmMPST040.btn_mpst040BClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST040_IndateOrd) then
    FrmMPST040_IndateOrd := TFrmMPST040_IndateOrd.Create(Application);
  FrmMPST040_IndateOrd.ShowModal;
end;

procedure TFrmMPST040.btn_mpst040CClick(Sender: TObject);
begin
  inherited;
  FrmMPST040_IndateChg := TFrmMPST040_IndateChg.Create(nil);
  try
    FrmMPST040_IndateChg.ShowModal;
  finally
    FreeAndNil(FrmMPST040_IndateChg);
  end;
end;

procedure TFrmMPST040.btn_mpst040DClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if CDS.Active then
    str := CDS.FieldByName('pno').AsString;
  GetQueryStock(str, false);
end;

procedure TFrmMPST040.btn_mpst040EClick(Sender: TObject);
begin
  inherited;
  FrmMPST040_ordlist := TFrmMPST040_ordlist.Create(nil);
  FrmMPST040_ordlist.Caption := TBitBtn(Sender).Caption;
  if SameText(TBitBtn(Sender).Name, 'btn_mpst040F') then
    FrmMPST040_ordlist.l_bu := 'ITEQGZ'
  else
    FrmMPST040_ordlist.l_bu := g_UInfo^.BU;
  try
    FrmMPST040_ordlist.ShowModal;
  finally
    FreeAndNil(FrmMPST040_ordlist);
  end;
end;

procedure TFrmMPST040.btn_mpst040GClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmunMPST040_mps) then
    FrmunMPST040_mps := TFrmunMPST040_mps.Create(Application);
  if CDS.Active and (not CDS.IsEmpty) then
    FrmunMPST040_mps.Edit1.Text := CDS.FieldByName('Pno').AsString;
  FrmunMPST040_mps.ShowModal;
end;

procedure TFrmMPST040.btn_mpst040HClick(Sender: TObject);
begin
  inherited;
  FrmMPST040_pnlwono := TFrmMPST040_pnlwono.Create(nil);
  try
    FrmMPST040_pnlwono.ShowModal;
  finally
    FreeAndNil(FrmMPST040_pnlwono);
  end;
end;

procedure TFrmMPST040.btn_mpst040IClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定更新生產進度嗎?', 33) = IDCancel then
    Exit;
  SetBtnEnabled(False);
  if PostBySQL('exec dbo.proc_UpdateWostation ' + Quotedstr(g_UInfo^.BU)) then
  begin
    if CDS2.Active and (not CDS2.IsEmpty) then
    begin
      l_bool2 := True;
      try
        RefreshDS2;
      finally
        l_bool2 := False;
      end;
    end;
    ShowMsg('更新完畢!', 64);
  end;
  SetBtnEnabled(True);
end;

procedure TFrmMPST040.btn_mpst040JClick(Sender: TObject);
var
  i, tmpCRecNo: Integer;
  Data: OleVariant;
  tmpSQL: string;
  tmpStr: WideString;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!', 48);
    Exit;
  end;

  for i := 1 to 3 do
  begin
    tmpStr := DBGridEh1.FieldColumns['Remark' + IntToStr(i)].Title.Caption;
    if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
    begin
      ShowMsg('請取消[生管備註1..3]欄位排序標記,再執行此操作!', 48);
      Exit;
    end;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('更新全部請按[是]' + #13#10 + '更新當前這筆請按[否]' + #13#10 + '無操作請按[取消]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    while not CDS.Eof do
    begin
      g_StatusBar.Panels[0].Text := '正在更新[' + IntToStr(CDS.RecNo) + ']筆';
      Application.ProcessMessages;

      if Pos(LeftStr(CDS.FieldByName('pno').AsString, 1), 'ET') > 0 then
        tmpSQL := '1'
      else
        tmpSQL := '0';
      Data := null;
      tmpSQL := 'exec dbo.proc_MPST030_3 ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(CDS.FieldByName('orderno').AsString)
        + ',' + IntToStr(CDS.FieldByName('orderitem').AsInteger) + ',1,' + tmpSQL;
      if not QueryBySQL(tmpSQL, Data) then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;

      tmpCDS.Data := Data;
      CDS.Edit;
      CDS.FieldByName('sdate_err').AsBoolean := False;
      for i := 1 to 3 do
        CDS.FieldByName('Remark' + IntToStr(i)).Clear;
      i := 1;
      with tmpCDS do
        while not Eof do
        begin
          CDS.FieldByName('Remark' + IntToStr(i)).AsString := Trim(FieldByName('wono').AsString + ' ' + IntToStr(MonthOf
            (FieldByName('sdate').AsDateTime)) + '/' + IntToStr(DayOf(FieldByName('sdate').AsDateTime)) + ' ' +
            FieldByName('machine').AsString + '-' + FieldByName('sqty').AsString);
          if Pos(Copy(CDS.FieldByName('Pno').AsString, 1, 1), 'ET') > 0 then
            CDS.FieldByName('Remark' + IntToStr(i)).AsString := CDS.FieldByName('Remark' + IntToStr(i)).AsString + ' ' +
              FieldByName('currentboiler').AsString + CheckLang('鍋');
          if (not CDS.FieldByName('sdate_err').AsBoolean) and (FieldByName('sdate').AsDateTime >= FieldByName('adate_new').AsDateTime)
            then
            CDS.FieldByName('sdate_err').AsBoolean := True;
          Inc(i);
          if i > 3 then
            Break;
          Next;
        end;
      CDS.Post;
      if tmpCRecNo = 0 then
        Break;
      CDS.Next;
    end;

    if not PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem') then
      CDS.CancelUpdates
    else
      ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS);
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST040.btn_mpst040KClick(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //當前、開始、結束
  qty1, qty2: Double;
  Data: OleVariant;
  tmpSQL: string;
  tmpStr: WideString;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['stkremark'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('請取消[庫存量]欄位排序標記,再執行此操作!', 48);
    Exit;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('更新全部請按[是]' + #13#10 + '更新當前這筆請按[否]' + #13#10 + '無操作請按[取消]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    //取庫別
    if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
    begin
      tmpSQL := 'Select Depot,lst,fst From MPS330 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (lst=1 or fst=1)';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          if Fields[1].AsBoolean then        //總庫存
            l_img02All := l_img02All + ',' + Quotedstr(Fields[0].AsString);
          if Fields[2].AsBoolean then        //有效庫存
            l_img02Out := l_img02Out + Fields[0].AsString + '/';
          Next;
        end;
      if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
      begin
        ShowMsg('MPS330無庫別,請確認!', 48);
        Exit;
      end;
      Delete(l_img02All, 1, 1);
      l_img02All := ' And img02 in (' + l_img02All + ')';
    end;
    //***

    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := CDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := Quotedstr(CDS.FieldByName('pno').AsString)
      else
      begin
        while not CDS.Eof do
        begin
          if Pos(CDS.FieldByName('pno').AsString, tmpSQL) = 0 then
            tmpSQL := tmpSQL + ',' + Quotedstr(CDS.FieldByName('pno').AsString);
          tmpERecNo := CDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //每次取50筆料號查詢庫存
            Break;
          CDS.Next;
        end;
        Delete(tmpSQL, 1, 1);
      end;

      g_StatusBar.Panels[0].Text := '正在處理' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '筆';
      Application.ProcessMessages;
      Data := null;
      if SameText(g_UInfo^.BU, 'ITEQDG') or SameText(g_UInfo^.BU, 'ITEQGZ') then
        tmpSQL := 'Select img01,img02,img10,ta_img03' + ' From ITEQDG.img_file Where img01 in (' + tmpSQL + ')' +
          l_img02All + ' And img10>0' + ' Union All' + ' Select img01,img02,img10,ta_img03' +
          ' From ITEQGZ.img_file Where img01 in (' + tmpSQL + ')' + l_img02All + ' And img10>0'
      else
        tmpSQL := 'Select img01,img02,img10,ta_img03' + ' From ' + g_UInfo^.BU + '.img_file Where img01 in (' + tmpSQL +
          ')' + l_img02All + ' And img10>0';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      CDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((CDS.RecNo <= tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1 := 0;
        qty2 := 0;
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'img01=' + Quotedstr(CDS.FieldByName('pno').AsString);
          Filtered := True;
          while not Eof do
          begin
            if (SameText(Fields[3].AsString, CDS.FieldByName('custno').AsString) or SameText(Fields[3].AsString, CDS.FieldByName
              ('custshort').AsString)) and (Pos(Fields[1].AsString, l_img02Out) > 0) then
              qty1 := qty1 + Fields[2].AsFloat;
            qty2 := qty2 + Fields[2].AsFloat;
            Next;
          end;
        end;
        CDS.Edit;
        CDS.FieldByName('stkremark').AsString := FloatToStr(qty1) + '/' + FloatToStr(qty2);
        CDS.Post;
        if tmpCRecNo = 0 then
          Break;
        CDS.Next;
      end;

      //退出while true
      if CDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;

    if not PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem') then
      CDS.CancelUpdates
    else
      ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS);
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST040.btn_mpst040LClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST040_confirm) then
    FrmMPST040_confirm := TFrmMPST040_confirm.Create(Application);
  if CDS.Active and (not CDS.IsEmpty) then
    FrmMPST040_confirm.Dtp1.Date := CDS.FieldByName('Indate').AsDateTime
  else
    FrmMPST040_confirm.Dtp1.Date := Date;
  FrmMPST040_confirm.ShowModal;
end;

procedure TFrmMPST040.btn_mpst040MClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST040_UpdateCustOrderno) then
    FrmMPST040_UpdateCustOrderno := TFrmMPST040_UpdateCustOrderno.Create(Application);
  FrmMPST040_UpdateCustOrderno.ShowModal;
end;

procedure TFrmMPST040.btn_mpst040NClick(Sender: TObject);
begin
  inherited;
  if not SameText(g_Uinfo^.BU, 'iteqgz') then
  begin
    ShowMsg('只限廣州廠使用!', 48);
    Exit;
  end;

  FrmMPST040_gz := TFrmMPST040_gz.Create(nil);
  try
    FrmMPST040_gz.ShowModal;
  finally
    FreeAndNil(FrmMPST040_gz);
  end;
end;

procedure TFrmMPST040.btn_mpst040OClick(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //當前、開始、結束
  qty: Double;
  Data: OleVariant;
  tmpSQL: string;
  tmpStr: WideString;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['remain_ordqty'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('請取消[未交數量]欄位排序標記,再執行此操作!', 48);
    Exit;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('更新全部請按[是]' + #13#10 + '更新當前這筆請按[否]' + #13#10 + '無操作請按[取消]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := CDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := 'oeb01=' + Quotedstr(CDS.FieldByName('orderno').AsString) + ' and oeb03=' + IntToStr(CDS.FieldByName('orderitem').AsInteger)
      else
      begin
        while not CDS.Eof do
        begin
          tmpSQL := tmpSQL + ' or (oeb01=' + Quotedstr(CDS.FieldByName('orderno').AsString) + ' and oeb03=' + IntToStr(CDS.FieldByName
            ('orderitem').AsInteger) + ')';
          tmpERecNo := CDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //每次取50筆
            Break;
          CDS.Next;
        end;
        Delete(tmpSQL, 1, 4);
      end;

      g_StatusBar.Panels[0].Text := '正在處理' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '筆';
      Application.ProcessMessages;
      Data := null;
      tmpSQL := 'select oeb01,oeb03,oeb12-oeb24 as qty from ' + g_UInfo^.BU + '.oeb_file where ' + tmpSQL;
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      CDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((CDS.RecNo <= tmpERecNo) and (not CDS.Eof)) do
      begin
        if tmpCDS.Locate('oeb01;oeb03', VarArrayOf([CDS.FieldByName('orderno').AsString, CDS.FieldByName('orderitem').AsInteger]),
          []) then
          qty := tmpCDS.FieldByName('qty').AsFloat
        else
          qty := 0;
        CDS.Edit;
        CDS.FieldByName('remain_ordqty').AsFloat := qty;
        CDS.Post;
        if tmpCRecNo = 0 then
          Break;
        CDS.Next;
      end;

      //退出while true
      if CDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;

    if not PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem') then
      CDS.CancelUpdates
    else
      ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS);
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST040.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST040.DBGridEh2DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  P: TPoint;
  fName: string;
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
    Exit;

  fName := LowerCase(Column.FieldName);
  if Pos('/' + fName + '/', '/s1/s2/s3/s4/s5/s6/s7/') > 0 then
  begin
    ImageList2.GetBitmap(CDS2.FieldByName(fName + '_ico').AsInteger, l_Img);
    with DBGridEh2.Canvas do
    begin
      FillRect(Rect);
      P.X := round((Rect.Left + Rect.Right - l_Img.Width) / 2) - 10;
      P.Y := round((Rect.Top + Rect.Bottom - l_Img.Height) / 2);
      Draw(P.X, P.Y, l_Img);
      TextOut(P.X + l_Img.Width + 2, P.Y + 2, CDS2.FieldByName(fName).AsString);
    end;
  end;
end;

procedure TFrmMPST040.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      g_DefFname := Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname := 'indate,sno,adate,odate,stime,orderitem,longitude,' +
        'latitude,notcount1,delcount1,coccount1,chkcount,' + 'remain_ordqty,storagetime,garbageflag,kg';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end;
end;

procedure TFrmMPST040.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) and CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'Chkcount') then
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
  if CDS.FieldByName('Sdate_err').AsBoolean and (Pos(LowerCase(Column.FieldName), 'remark1/remark2/remark3') > 0) then
    Background := clOlive;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
    AFont.Color := clRed;
end;

procedure TFrmMPST040.DBGridEh4GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS4.Active) and CDS4.IsEmpty then
    Exit;

  if Pos(LeftStr(CDS.FieldByName('Orderno').AsString, 3), 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z') > 0 then
    //單別已經決定了廠別,兩廠不會有相同單號,不用oradb條件
  begin
    if SameText(CDS4.FieldByName('Orderno2').AsString, CDS.FieldByName('Orderno').AsString) and (CDS4.FieldByName('Orderitem2').AsInteger
      = CDS.FieldByName('Orderitem').AsInteger) then
      AFont.Color := clRed
  end
  else if SameText(CDS4.FieldByName('OraDB').AsString, g_UInfo^.BU) and (CDS4.FieldByName('Orderno').AsString = CDS.FieldByName
    ('Orderno').AsString) and (CDS4.FieldByName('Orderitem').AsInteger = CDS.FieldByName('Orderitem').AsInteger) then
    AFont.Color := clRed;
end;

procedure TFrmMPST040.CDSAfterPost(DataSet: TDataSet);
begin
  if PostBySQLFromDelta(CDS, p_MainTableName, 'Bu,Dno,Ditem') then
    inherited;
end;

procedure TFrmMPST040.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('saleno').Clear;
    FieldByName('saleitem').Clear;
    FieldByName('check_user').Clear;
    FieldByName('check_date').Clear;
    FieldByName('coc_no').Clear;
    FieldByName('coc_user').Clear;
    FieldByName('coc_err').AsBoolean := False;
    FieldByName('coc_errid').Clear;
    FieldByName('coc_erruser').Clear;
    FieldByName('coc_errdate').Clear;
    FieldByName('scantime').Clear;
    FieldByName('dno_ditem').Clear;
    FieldByName('w_pno').Clear;
    FieldByName('w_qty').Clear;

    FieldByName('Ditem').AsInteger := 1;
    //FieldByName('Indate').AsDateTime:=Date;
    FieldByName('Check_ans').AsBoolean := False;
    FieldByName('BingBao_ans').AsBoolean := False;
    FieldByName('COC_ans').AsBoolean := False;
    FieldByName('Prn_ans').AsBoolean := False;
    FieldByName('Delcount').AsFloat := 0;
    FieldByName('Delcount1').AsFloat := 0;
    FieldByName('Jcount_old').AsFloat := 0;
    FieldByName('Jcount_new').AsFloat := 0;
    FieldByName('Bcount').AsFloat := 0;
    FieldByName('Chkcount').AsFloat := 0;
    FieldByName('Coccount').AsFloat := 0;
    FieldByName('Coccount1').AsFloat := 0;
    FieldByName('SourceDitem').AsInteger := 0;
    FieldByName('QtyColor').AsInteger := 0;
    FieldByName('InsFlag').AsBoolean := False;
    FieldByName('GarbageFlag').AsBoolean := False;
    FieldByName('Remain_ordqty').AsFloat := 0;
  end;
end;

procedure TFrmMPST040.bm1Click(Sender: TObject);
begin
  inherited;
  SetQtyColor(1);
end;

procedure TFrmMPST040.bm2Click(Sender: TObject);
begin
  inherited;
  SetQtyColor(2);
end;

procedure TFrmMPST040.bm3Click(Sender: TObject);
begin
  inherited;
  SetQtyColor(3);
end;

procedure TFrmMPST040.bm4Click(Sender: TObject);
begin
  inherited;
  SetQtyColor(4);
end;

procedure TFrmMPST040.bm5Click(Sender: TObject);
begin
  inherited;
  SetQtyColor(5);
end;

procedure TFrmMPST040.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if pcl2.ActivePage = TabSheet5 then
    RefreshDS5
  else if CDS.FieldByName('w_pno') = DBGridEh1.SelectedField then
    SetW_pno
  else
    SetQtyColor(5);
end;

procedure TFrmMPST040.Timer1Timer(Sender: TObject);
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
    if tmpSQL = l_SQL2 then
      Exit;
    l_SQL2 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
    begin
      if not Assigned(l_MPS_IcoFlag) then
        l_MPS_IcoFlag := TMPS_IcoFlag.Create;
      l_MPS_IcoFlag.Data := Data;
      CDS2.Data := l_MPS_IcoFlag.Data;
    end;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TFrmMPST040.Timer2Timer(Sender: TObject);
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
    if (not l_bool2) and (tmpSQL = l_SQL3) then
      Exit;
    l_SQL3 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      CDS3.Data := Data;
  finally
    Timer2.Enabled := True;
  end;
end;

procedure TFrmMPST040.Timer3Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Timer3.Enabled := False;
  try
    if l_List4.Count = 0 then
      Exit;

    while l_List4.Count > 1 do
      l_List4.Delete(l_List4.Count - 1);

    tmpSQL := l_List4.Strings[0];
    if tmpSQL = l_SQL4 then
      Exit;
    l_SQL4 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      CDS4.Data := Data;
  finally
    Timer3.Enabled := True;
  end;
end;

procedure TFrmMPST040.btn_mpst040_totalClick(Sender: TObject);
begin
  inherited;
  FrmMPST040_Dtp := TFrmMPST040_Dtp.Create(nil);
  FrmMPST040_Dtp.Caption := CheckLang('線路彙總導出');
  FrmMPST040_Dtp.dtp1.Date := date;
  try
    FrmMPST040_Dtp.ShowModal;
  finally
    FreeAndNil(FrmMPST040_Dtp);
  end;
end;

procedure TFrmMPST040.btn_copyClick(Sender: TObject);
var
  i: Integer;
  list: TStrings;
  arrFNE: array of TFieldNotifyEvent;
begin
  SetLength(arrFNE, CDS.FieldCount);
  for i := 0 to CDS.FieldCount - 1 do
  begin
//    if not SameText(cds.Fields[i].FieldName,'kind') then
//    begin
    arrFNE[i] := CDS.Fields[i].OnChange;
    CDS.Fields[i].OnChange := nil;
//    end;
  end;
  list := TStringList.Create;
  try
    for i := 0 to CDS.FieldCount - 1 do
    begin
//      if not SameText(cds.Fields[i].FieldName,'kind') then
      list.Add(Trim(CDS.Fields[i].AsString));
    end;
    CDS.Append;
    for i := 0 to CDS.FieldCount - 1 do
    begin
//      if not SameText(cds.Fields[i].FieldName,'kind') then
      CDS.Fields[i].AsString := list.Strings[i];
    end;
    CDS.OnNewRecord(CDS);
  finally
    FreeAndNil(list);
    for i := 0 to CDS.FieldCount - 1 do
    begin
//      if not SameText(cds.Fields[i].FieldName,'kind') then
      CDS.Fields[i].OnChange := arrFNE[i];
    end;
    arrFNE := nil;
  end;
end;

procedure TFrmMPST040.CDS5AfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS6;
end;

procedure TFrmMPST040.DBGridEh6DblClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if CDS6.Active then
    str := CDS6.FieldByName('sfa03').AsString;
  GetQueryStock(str, false);
end;

procedure TFrmMPST040.btn_mpst040QClick(Sender: TObject);
var
  tmp: TClientDataSet;
  s1, sl: char;
  units: string;
  cclsh, cclsh2, cclpn, cclpn2, br, mn, br2, mn2, qty: Double;
  cnt, cnt2: Integer;
  flag: Boolean;
begin
  inherited;
  if (not Panel2.Visible) and CDS.Active and (not CDS.IsEmpty) then
  begin
    GetLastCode;
    cclsh := 0;
    cclsh2 := 0;
    cclpn := 0;
    cclpn2 := 0;
    br := 0;
    mn := 0;
    br2 := 0;
    mn2 := 0;
    cnt := 0;
    cnt2 := 0;
    tmp := TClientDataSet.Create(nil);
    try
      tmp.Data := cds.Data;
      with tmp do
      begin
        First;
        while not Eof do
        begin
          s1 := tmp.FieldByName('pno').AsString[1];
          sl := tmp.FieldByName('pno').AsString[Length(tmp.FieldByName('pno').AsString)];
          units := tmp.FieldByName('units').AsString;
          qty := tmp.FieldByName('Notcount1').AsFloat;
          flag := Pos(sl, l_lastCode) = 0;
          Inc(cnt2);
          if flag then
            inc(cnt);
          if s1 in ['E', 'T'] then
          begin
            if units = 'SH' then
            begin
              cclsh := cclsh + qty;
              if flag then
                cclsh2 := cclsh2 + qty;
            end
            else if units = 'PN' then
            begin
              cclpn := cclpn + qty;
              if flag then
                cclpn2 := cclpn2 + qty;
            end;
          end
          else if s1 in ['R', 'B'] then
          begin
            br := br + qty;
            if flag then
              br2 := br2 + qty;
          end
          else if s1 in ['M', 'N'] then
          begin
            mn := mn + qty;
            if flag then
              mn2 := mn2 + qty;
          end;
          next;
        end;
      end;
      with StringGrid1 do
      begin
        Cells[1, 1] := FloatToStr(cclsh);
        Cells[1, 2] := FloatToStr(cclsh2);
        Cells[2, 1] := FloatToStr(cclpn);
        Cells[2, 2] := FloatToStr(cclpn2);
        Cells[3, 1] := FloatToStr(br);
        Cells[3, 2] := FloatToStr(br2);
        Cells[4, 1] := FloatToStr(mn);
        Cells[4, 2] := FloatToStr(mn2);
        Cells[5, 1] := IntToStr(cnt2);
        Cells[6, 1] := IntToStr(cnt);
        Refresh;
      end;
    finally
      tmp.Free;
    end;
  end;
  panel2.Visible := not Panel2.Visible;
end;

procedure TFrmMPST040.GetLastCode;
var
  data: OleVariant;
  sql: string;
begin
  if l_lastCode <> '' then
    exit;
  sql := 'select mpst040l1 from sys_setting where id=1';
  if QueryOneCR(sql, data) then
    l_lastCode := VarToStr(data);
end;

procedure TFrmMPST040.StringGrid1DblClick(Sender: TObject);
//
//  function RefToCell(RowID, ColID: Integer): string;
//  var
//    ACount, APos: Integer;
//  begin
//    ACount := ColID div 26;
//    APos := ColID mod 26;
//    if APos = 0 then
//    begin
//      ACount := ACount - 1;
//      APos := 26;
//    end;
//
//    if ACount = 0 then
//      Result := Chr(Ord('A') + ColID - 1) + IntToStr(RowID);
//
//    if ACount = 1 then
//      Result := 'A' + Chr(Ord('A') + APos - 1) + IntToStr(RowID);
//
//    if ACount > 1 then
//      Result := Chr(Ord('A') + ACount - 1) + Chr(Ord('A') + APos - 1) + IntToStr(RowID);
//  end;
//
//
//  function StringGridToExcelSheet(Grid: TStringGrid; SheetName, FileName: string; ShowExcel: Boolean): Boolean;
//  const
//    xlWBATWorksheet = -4167;
//  var
//    SheetCount, SheetColCount, SheetRowCount, BookCount: Integer;
//    XLApp, Sheet, Data: OLEVariant;
//    I, J, N, M: Integer;
//    SaveFileName: string;
//  begin
//
//    SheetCount := (Grid.ColCount div 256) + 1;
//    if Grid.ColCount mod 256 = 0 then
//      SheetCount := SheetCount - 1;
//
//    BookCount := (Grid.RowCount div 65536) + 1;
//    if Grid.RowCount mod 65536 = 0 then
//      BookCount := BookCount - 1;
//
//    Result := False;
//    XLApp := CreateOleObject('Excel.Application');
//    try
//      if ShowExcel = False then
//        XLApp.Visible := False
//      else
//        XLApp.Visible := True;
//      for M := 1 to BookCount do
//      begin
//        XLApp.Workbooks.Add(xlWBATWorksheet);
//        for N := 1 to SheetCount - 1 do
//        begin
//          XLApp.Worksheets.Add;
//        end;
//      end;
//      if Grid.ColCount <= 256 then
//        SheetColCount := Grid.ColCount
//      else
//        SheetColCount := 256;
//      if Grid.RowCount <= 65536 then
//        SheetRowCount := Grid.RowCount
//      else
//        SheetRowCount := 65536;
//
//      for M := 1 to BookCount do
//      begin
//        for N := 1 to SheetCount do
//        begin
//        //Daten aus Grid holen
//          Data := VarArrayCreate([1, Grid.RowCount, 1, SheetColCount], varVariant);
//          for I := 0 to SheetColCount - 1 do
//            for J := 0 to SheetRowCount - 1 do
//              if ((I + 256 * (N - 1)) <= Grid.ColCount) and ((J + 65536 * (M - 1)) <= Grid.RowCount) then
//                Data[J + 1, I + 1] := Grid.Cells[I + 256 * (N - 1), J + 65536 * (M - 1)];
//        //-------------------------
//          XLApp.Worksheets[N].Select;
//          XLApp.Workbooks[M].Worksheets[N].Name := SheetName + IntToStr(N);
//        //Zellen als String Formatieren
//          XLApp.Workbooks[M].Worksheets[N].Range[RefToCell(1, 1), RefToCell(SheetRowCount, SheetColCount)].Select;
//          XLApp.Selection.NumberFormat := '@';
//          XLApp.Workbooks[M].Worksheets[N].Range['A1'].Select;
//        //Daten dem Excelsheet �bergeben
//          Sheet := XLApp.Workbooks[M].WorkSheets[N];
//          Sheet.Range[RefToCell(1, 1), RefToCell(SheetRowCount, SheetColCount)].Value := Data;
//        end;
//      end;
//    //Save Excel Worksheet
//      try
//        for M := 1 to BookCount do
//        begin
//          SaveFileName := Copy(FileName, 1, Pos('.', FileName) - 1) + IntToStr(M) + Copy(FileName, Pos('.', FileName),
//            Length(FileName) - Pos('.', FileName) + 1);
//          XLApp.Workbooks[M].SaveAs(SaveFileName);
//        end;
//        Result := True;
//      except
//      // Error ?
//      end;
//    finally
//    //Excel Beenden
//      if (not VarIsEmpty(XLApp)) and (ShowExcel = False) then
//      begin
//        XLApp.DisplayAlerts := False;
//        XLApp.Quit;
//        XLApp := Unassigned;
//        Sheet := Unassigned;
//      end;
//    end;
//  end;

begin
  inherited;
//  StringGridToExcelSheet(StringGrid1, 'Stringgrid Print', 'c:\dExcelFile.xls', True);
end;

end.

