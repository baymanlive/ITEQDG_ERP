{*******************************************************}
{                                                       }
{                unMPSI070                              }
{                Author: kaikai                         }
{                Create date: 2016/8/15                 }
{                Description: PP主排程程式              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, Buttons, ComCtrls, ExtCtrls, ImgList, DB, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ToolWin, StrUtils, DateUtils, Math,
  unMPST070_Order, unMPST070_Mps, unMPST070_cdsxml, TWODbarcode;

const
  l_Color1 = 16772300;      //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;      //RGB(255,255,204);   //淺黃

type
  TADColor = record
    AD: string;
    R, G, B: Integer;
  end;

type
  TFrmMPST070 = class(TFrmSTDI030)
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    ProgressBar1: TProgressBar;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    btn_mpst070A: TBitBtn;
    btn_mpst070B: TBitBtn;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    DS3: TDataSource;
    CDS3: TClientDataSet;
    PopupMenu2: TPopupMenu;
    N24: TMenuItem;
    N28: TMenuItem;
    N4: TMenuItem;
    N29: TMenuItem;
    RG1: TRadioGroup;
    RG2: TRadioGroup;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    btn_mpst070C: TBitBtn;
    btn_mpst070D: TBitBtn;
    btn_mpst070E: TBitBtn;
    PopupMenu1: TPopupMenu;
    N20: TMenuItem;
    N21: TMenuItem;
    N5: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N25: TMenuItem;
    N2: TMenuItem;
    btn_mpst070F: TBitBtn;
    btn_mpst070G: TBitBtn;
    btn_mpst070H: TBitBtn;
    btn_mpst070I: TBitBtn;
    btn_mpst070J: TBitBtn;
    btn_mpst070K: TBitBtn;
    btn_mpst070L: TBitBtn;
    btn_mpst070M: TBitBtn;
    btn_mpst070N: TBitBtn;
    btn_mpst070O: TBitBtn;
    PnlRight: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    N30: TMenuItem;
    btn_mpst070P: TBitBtn;
    btn_mpst070Q: TToolButton;
    btn_mpst070CalPP: TBitBtn;
    btn_mpst070CalcPP: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RG1Click(Sender: TObject);
    procedure RG2Click(Sender: TObject);
    procedure btn_mpst070AClick(Sender: TObject);
    procedure btn_mpst070BClick(Sender: TObject);
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
    procedure PopupMenu2Popup(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure DBGridEh3DblClick(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDS3AfterScroll(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure DBGridEh3TitleClick(Column: TColumnEh);
    procedure N28Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure btn_mpst070DClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh3GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_mpst070EClick(Sender: TObject);
    procedure btn_mpst070CClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure btn_mpst070FClick(Sender: TObject);
    procedure btn_mpst070GClick(Sender: TObject);
    procedure btn_mpst070HClick(Sender: TObject);
    procedure btn_mpst070JClick(Sender: TObject);
    procedure btn_mpst070IClick(Sender: TObject);
    procedure btn_mpst070KClick(Sender: TObject);
    procedure btn_mpst070LClick(Sender: TObject);
    procedure btn_mpst070MClick(Sender: TObject);
    procedure btn_mpst070NClick(Sender: TObject);
    procedure btn_mpst070OClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure btn_mpst070PClick(Sender: TObject);
    procedure btn_mpst070QClick(Sender: TObject);
    procedure btn_mpst070CalPPClick(Sender: TObject);
    procedure btn_mpst070CalcPPClick(Sender: TObject);
  private
    l_ArrADColor: array of TADColor; //膠系字體顏色
    l_Ans, l_LockAns, l_OptLockAns: Boolean;
    l_Order: TMPST070_Order;
    l_MPST070_Mps: TMPST070_Mps;
    l_SelList, l_ColorList: TStrings;   //選擇,顏色
    l_StrIndex, l_StrIndexDesc: string;
    procedure SetNewRecordData(DataSet: TDataSet);
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure CheckLock;
    function GetSumQty(SourceCDS: TClientDataSet): Double;
    procedure SetEdit3;
    procedure RefreshColor;
    procedure GetPPQty;
    { Private declarations }
  public
    Fm_image: PTIMAGESTRUCT;
    procedure UdpJitem(xSimuver: string);
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST070: TFrmMPST070;


implementation

uses
  unGlobal, unCommon, unFind, unMPST070_ShowErrList, unMPST070_GetCore,
  unMPST070_CtrlE, unMPST070_Orderno2Edit, unMPST070_EmptyFlagAdd,
  unMPST070_EmptyFlagEdit, unMPST070_Orderby, unMPST070_SwapSdate, unMPST070_bom,
  unMPST070_UseCoreDetail, unMPST070_Print, unMPST070_UpdateWono,
  unMPST070_CalPP;

var
  imgCds: TClientDataSet;
{$R *.dfm}

procedure TFrmMPST070.CheckLock;
var
  IsLock: Boolean;
begin
  if not l_LockAns then
    if CheckLockProc(IsLock) then
      l_LockAns := IsLock
    else
      Abort;

  if l_LockAns then
  begin
    if l_OptLockAns then
      ShowMsg('排程已鎖定,請確認排程!', 16)
    else
      ShowMsg('排程已鎖定,請重新查詢或重新開啟作業!', 16);
    Abort;
  end;
end;

procedure TFrmMPST070.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
begin
  l_SelList.Clear;
  btn_mpst070P.Hint := '';
  with xCDS do
  begin
    Filtered := False;
    if xRG.ItemIndex = -1 then
      Filter := 'machine=''@'''
    else
      Filter := 'errorflag<>1 and machine=' + QuotedStr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

procedure TFrmMPST070.SetEdit3;
begin
  if PCL.ActivePageIndex = 0 then
  begin
    if CDS.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
    Edit4.Text := FloatToStr(GetSumQty(CDS));
  end
  else if PCL.ActivePageIndex = 1 then
  begin
    if CDS2.FieldByName('Sdate').IsNull then
      Edit3.Text := ''
    else
      Edit3.Text := FormatDateTime(g_cShortDate, CDS2.FieldByName('Sdate').AsDateTime);
    Edit4.Text := FloatToStr(GetSumQty(CDS2));
  end
  else
  begin
    Edit3.Text := '';
    Edit4.Text := '0';
  end;
end;

procedure TFrmMPST070.RefreshColor;
var
  tmpValue: string;
  tmpSdate: TDateTime;
  tmpCDS: TClientDataSet;
begin
  l_ColorList.Clear;
  if PCL.ActivePageIndex = 2 then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    if PCL.ActivePageIndex = 0 then
    begin
      tmpCDS.Data := CDS.Data;
      tmpCDS.Filter := CDS.Filter;
      tmpCDS.Filtered := True;
    end
    else if PCL.ActivePageIndex = 1 then
    begin
      tmpCDS.Data := CDS2.Data;
      tmpCDS.Filter := CDS2.Filter;
      tmpCDS.Filtered := True;
    end;

    tmpCDS.AddIndex('xIndex', CDS.IndexDefs[0].Fields, [ixCaseInsensitive], CDS.IndexDefs[0].DescFields);
    tmpCDS.IndexName := 'xIndex';
    tmpValue := '1';
    tmpSdate := EncodeDate(1955, 5, 5);
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

procedure TFrmMPST070.SetNewRecordData(DataSet: TDataSet);
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
  end;
end;

function TFrmMPST070.GetSumQty(SourceCDS: TClientDataSet): Double;
var
  tmpCDS: TClientDataSet;
begin
  Result := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := SourceCDS.Data;
    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'machine=' + QuotedStr(SourceCDS.FieldByName('machine').AsString) + ' and sdate=' + QuotedStr(DateToStr(SourceCDS.FieldByName('sdate').AsDateTime)) + ' and (ErrorFlag=0 or ErrorFlag is null)' + ' and (sqty is not null) and sqty<>0';
      Filtered := True;
      while not Eof do
      begin
        Result := Result + FieldByName('sqty').AsFloat;
        Next;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST070.UdpJitem(xSimuver: string);
var
  i: Integer;
  rcASC: Boolean;                   //RC升序或降序
  tmpJitem: Integer;                //更新id
  tmpStr, tmpAd, tmpFi, tmpRc, tmpFiber, tmpMachine, tmpSdate: string;
  tmpCDS1, tmpCDS2: TClientDataSet;  //tmpCDS1全部數據,tmpCDS2待處理數據
  Data: OleVariant;
  tmpList: TStrings;

  procedure UdpDest1(xMachine, xSdate: string; xJitem: Integer);
  begin
    tmpCDS1.Filtered := False;
    tmpCDS1.Filter := 'Machine=' + QuotedStr(xMachine) + ' And Sdate=' + QuotedStr(xSdate) + ' And Jitem<>' + IntToStr(g_Jitem);
    tmpCDS1.Filtered := True;
    while not tmpCDS1.Eof do
    begin
      if tmpCDS1.FieldByName('Jitem').AsInteger >= xJitem then
      begin
        tmpCDS1.Edit;
        tmpCDS1.FieldByName('Jitem').AsInteger := tmpCDS1.FieldByName('Jitem').AsInteger + 1;
        tmpCDS1.Post;
      end;
      tmpCDS1.Next;
    end;
  end;

  procedure UdpDest2;
  begin
    tmpCDS1.Filtered := False;
    if tmpCDS1.Locate('Simuver;Citem', VarArrayOf([tmpCDS2.FieldByName('Simuver').AsString, tmpCDS2.FieldByName('Citem').AsInteger]), []) then
    begin
      tmpCDS1.Edit;
      tmpCDS1.FieldByName('Jitem').AsInteger := tmpJitem;
      tmpCDS1.Post;
    end;
  end;

begin
  tmpStr := 'exec dbo.proc_MPST070 ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(xSimuver);
  if not QueryBySQL(tmpStr, Data) then
    Exit;
  tmpList := TStringList.Create;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    tmpCDS2.Data := Data;
    if tmpCDS1.IsEmpty then
      Exit;
    while not tmpCDS1.Eof do
    begin
      tmpStr := tmpCDS1.FieldByName('Machine').AsString + '@' + DateToStr(tmpCDS1.FieldByName('Sdate').AsDateTime);
      if tmpList.IndexOf(tmpStr) = -1 then
        tmpList.Add(tmpStr);
      tmpCDS1.Next;
    end;

    tmpCDS1.IndexFieldNames := 'Jitem';
    for i := 0 to tmpList.Count - 1 do
    begin
      tmpStr := tmpList.Strings[i];
      tmpMachine := Copy(tmpStr, 1, Pos('@', tmpStr) - 1);
      tmpSdate := Copy(tmpStr, Pos('@', tmpStr) + 1, 20);

      tmpCDS2.Filtered := False;
      tmpCDS2.Filter := 'Machine=' + QuotedStr(tmpMachine) + ' And Sdate=' + QuotedStr(tmpSdate) + ' And Jitem=' + IntToStr(g_Jitem);
      tmpCDS2.Filtered := True;
      while not tmpCDS2.Eof do
      begin
        tmpJitem := -1;
        tmpAd := tmpCDS2.FieldByName('AD').AsString;
        tmpFi := tmpCDS2.FieldByName('FI').AsString;
        tmpRc := tmpCDS2.FieldByName('RC').AsString;
        tmpFiber := tmpCDS2.FieldByName('Fiber').AsString;

        tmpCDS1.Filtered := False;
        tmpCDS1.Filter := 'Machine=' + QuotedStr(tmpMachine) + ' And Sdate=' + QuotedStr(tmpSdate) + ' And Jitem<>' + IntToStr(g_Jitem);
        tmpCDS1.Filtered := True;
        if tmpCDS1.Locate('AD', tmpAd, []) then      //存在此膠系
        begin
          tmpCDS1.Filtered := False;
          tmpCDS1.Filter := 'Machine=' + QuotedStr(tmpMachine) + ' And Sdate=' + QuotedStr(tmpSdate) + ' And AD=' + QuotedStr(tmpAd) + ' And Jitem<>' + IntToStr(g_Jitem);
          tmpCDS1.Filtered := True;
          if tmpCDS1.Locate('FI', tmpFi, []) then    //存在此布種
          begin
            rcASC := True;                             //RC默認升序
            tmpCDS1.Filtered := False;
            tmpCDS1.Filter := 'Machine=' + QuotedStr(tmpMachine) + ' And Sdate=' + QuotedStr(tmpSdate) + ' And AD=' + QuotedStr(tmpAd) + ' And FI=' + QuotedStr(tmpFi) + ' And Jitem<>' + IntToStr(g_Jitem);
            tmpCDS1.Filtered := True;
            if tmpCDS1.Locate('RC;Fiber', VarArrayOf([tmpRc, tmpFiber]), []) then    //存在RC,布種供應商相同
              tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger
            else
            begin
              if tmpCDS1.RecordCount > 1 then          //多筆,判斷RC順序
              begin
                tmpStr := tmpCDS1.FieldByName('RC').AsString;
                tmpCDS1.Next;
                while not tmpCDS1.Eof do
                begin
                  if tmpStr > tmpCDS1.FieldByName('RC').AsString then
                  begin
                    rcASC := False;
                    Break;
                  end
                  else if tmpStr < tmpCDS1.FieldByName('RC').AsString then
                    Break;
                  tmpCDS1.Next;
                end;
              end;

              tmpCDS1.First;
              while not tmpCDS1.Eof do
              begin
                if rcASC and (tmpCDS1.FieldByName('RC').AsString > tmpRc) then
                begin
                  tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger;
                  Break;
                end
                else if (not rcASC) and (tmpCDS1.FieldByName('RC').AsString < tmpRc) then
                begin
                  tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger;
                  Break;
                end;
                tmpCDS1.Next;
              end;

              if tmpJitem = -1 then
              begin
                tmpCDS1.Last;
                tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger + 1;
              end;
            end;
            UdpDest1(tmpMachine, tmpSdate, tmpJitem);
            UdpDest2;
          end
          else                                   //不存在此布種,大->小
          begin
            tmpCDS1.First;
            while not tmpCDS1.Eof do
            begin
              if tmpCDS1.FieldByName('FI').AsString < tmpFi then
              begin
                tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger;
                Break;
              end;
              tmpCDS1.Next;
            end;

            if tmpJitem = -1 then
            begin
              tmpCDS1.Last;
              tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger + 1;
            end;

            UdpDest1(tmpMachine, tmpSdate, tmpJitem);
            UdpDest2;
          end;
        end
        else                                     //不存在此膠系,小->大
        begin
          tmpCDS1.First;
          while not tmpCDS1.Eof do
          begin
            if tmpCDS1.FieldByName('AD').AsString > tmpAd then
            begin
              if tmpJitem = -1 then
                tmpJitem := tmpCDS1.FieldByName('Jitem').AsInteger;
              tmpCDS1.Edit;
              tmpCDS1.FieldByName('Jitem').AsInteger := tmpCDS1.FieldByName('Jitem').AsInteger + 1;
              tmpCDS1.Post;
            end;
            tmpCDS1.Next;
          end;

          if tmpJitem = -1 then
            tmpJitem := tmpCDS1.RecordCount + 1;

          UdpDest2;
        end;
        tmpCDS2.Next;
      end;
    end;

    CDSPost(tmpCDS1, p_TableName);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmMPST070.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin                                            // Bu=' + QuotedStr(g_UInfo^.BU) + ' And
  tmpSQL := 'Select * From ' + p_TableName + ' Where  IsNull(Case_ans2,0)=0 ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST070.FormCreate(Sender: TObject);
var
  i: Integer;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS070';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  RG2.Tag := 1;
  btn_mpst070Q.Left := ToolButton2.Left;

  inherited;
  GetMPSMachine;
  RG1.Items.DelimitedText := g_MachinePP;
  RG2.Items.DelimitedText := g_MachinePP;
  DBGridEh2.FieldColumns['machine1'].PickList.DelimitedText := g_MachinePP;
  DBGridEh3.FieldColumns['machine1'].PickList.DelimitedText := g_MachinePP;

  btn_insert.Visible := False;
  btn_edit.Visible := False;
  btn_delete.Visible := False;
  btn_copy.Visible := False;
  btn_post.Visible := False;
  btn_cancel.Visible := False;
  btn_mpst070Q.Visible := SameText(g_UInfo^.BU, 'ITEQJX') and g_MInfo^.R_edit;
  if not btn_mpst070Q.Visible then
    ToolButton2.Visible := False;

  TabSheet1.Caption := CheckLang('已確認排程');
  TabSheet2.Caption := CheckLang('預排結果');
  TabSheet3.Caption := CheckLang('待排訂單');
  Label3.Caption := CheckLang('生產日期/米');
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
  l_ColorList := TStringList.Create;

  if QueryBySQL('Select AD,R,G,B From MPS610 Where Bu=' + QuotedStr(g_UInfo^.BU), Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      SetLength(l_ArrADColor, tmpCDS.RecordCount);
      i := 0;
      while not tmpCDS.Eof do
      begin
        l_ArrADColor[i].AD := UpperCase(tmpCDS.FieldByName('AD').AsString);
        l_ArrADColor[i].R := tmpCDS.FieldByName('R').AsInteger;
        l_ArrADColor[i].G := tmpCDS.FieldByName('G').AsInteger;
        l_ArrADColor[i].B := tmpCDS.FieldByName('B').AsInteger;
        Inc(i);
        tmpCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  l_MPST070_Mps := TMPST070_Mps.Create;
  CMDDeleteFile(g_UInfo^.TempPath, 'bmp');
  PtInitImage(@Fm_image);

  RG1.Tag := 0;
  RG2.Tag := 0;
  RG1.ItemIndex := 0;
  RG2.ItemIndex := 0;
  if SameText(g_UInfo^.BU, 'ITEQJX') then
  begin
    RG1.Columns := 2;
    RG2.Columns := 2;
    Panel2.Width := Panel2.Width * 2 + 10;
    RG1.Width := RG1.Width * 2 + 10;
    RG1.Height := RG1.Height + 180;

    Panel3.Width := Panel2.Width;
    RG2.Width := RG1.Width;
    RG2.Height := RG1.Height;
  end;
end;

procedure TFrmMPST070.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if l_OptLockAns then
    UnLockProc;
  FreeAndNil(FrmMPST070_CalPP);
  FreeAndNil(FrmMPST070_bom);
  FreeAndNil(FrmMPST070_GetCore);
  inherited;

  FreeAndNil(l_SelList);
  FreeAndNil(l_ColorList);
  FreeAndNil(l_Order);
  FreeAndNil(l_MPST070_Mps);
  CDS2.Active := False;
  CDS3.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  PtFreeImage(@Fm_image);
  imgCds.free;
end;

procedure TFrmMPST070.btn_printClick(Sender: TObject);
var
  tmpSQL, tmpImgPath: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  ArrPrintData: TArrPrintData;
begin
//  inherited;
  if not Assigned(FrmMPST070_Print) then
    FrmMPST070_Print := TFrmMPST070_Print.Create(Application);
  if FrmMPST070_Print.ShowModal <> mrOK then
    Exit;

  tmpSQL := 'Select * From ' + p_TableName + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And IsNull(Case_ans2,0)=0 And IsNull(ErrorFlag,0)<>1' + ' And Machine=' + QuotedStr(FrmMPST070_Print.RG1.Items[FrmMPST070_Print.RG1.ItemIndex]) + ' And Sdate Between ' + QuotedStr(DateToStr(FrmMPST070_Print.dtp1.Date)) + ' And ' + QuotedStr(DateToStr(FrmMPST070_Print.dtp2.Date)) + ' Order By Machine,Sdate,Jitem,AD,FISno,RC Desc,Fiber,Simuver,Citem';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
      while not Eof do
      begin
        if Length(FieldByName('wono').AsString) > 0 then
        begin
          tmpImgPath := g_UInfo^.TempPath + FieldByName('wono').AsString + '.bmp';
          if getcode(FieldByName('wono').AsString, tmpImgPath, Fm_image) then
          begin
            Edit;
            FieldByName('WoStation_d1str').AsString := tmpImgPath;  //WoStation_d1str此欄位長度200
            Post;
          end;
        end;
        Next;
      end;

    if tmpCDS.ChangeCount > 0 then
      tmpCDS.MergeChangeLog;

    SetLength(ArrPrintData, 1);
    ArrPrintData[0].Data := tmpCDS.Data;
    ArrPrintData[0].RecNo := tmpCDS.RecNo;
    ArrPrintData[0].IndexFieldNames := tmpCDS.IndexFieldNames;
    ArrPrintData[0].Filter := tmpCDS.Filter;
    GetPrintObj(p_SysId, ArrPrintData);
    ArrPrintData := nil;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST070.btn_queryClick(Sender: TObject);
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

procedure TFrmMPST070.btn_firstClick(Sender: TObject);
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

procedure TFrmMPST070.btn_priorClick(Sender: TObject);
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

procedure TFrmMPST070.btn_nextClick(Sender: TObject);
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

procedure TFrmMPST070.btn_lastClick(Sender: TObject);
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

procedure TFrmMPST070.btn_quitClick(Sender: TObject);
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

procedure TFrmMPST070.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST070.RG2Click(Sender: TObject);
begin
  inherited;
  if (not CDS2.Active) or (RG2.Tag = 1) then
    Exit;
  RefreshData(RG2, CDS2);
  RefreshColor;
  DBGridEh2.Repaint;
end;

procedure TFrmMPST070.btn_mpst070AClick(Sender: TObject);
var
  Data1: OleVariant;
begin
  inherited;
  if not Assigned(l_Order) then
    l_Order := TMPST070_Order.Create;
  Data1 := l_Order.GetData;
  if not VarIsNull(Data1) then
  begin
    RefreshGrdCaption(CDS3, DBGridEh3, l_StrIndex, l_StrIndexDesc);
    l_Ans := True;
    CDS3.Data := Data1;
    CDS2.EmptyDataSet;
    PCL.ActivePageIndex := 2;
    PCLChange(PCL);
    l_Ans := False;
  end;
end;

procedure TFrmMPST070.btn_mpst070BClick(Sender: TObject);
var
  Data1: OleVariant;
begin
  inherited;
  if not Assigned(l_Order) then
    l_Order := TMPST070_Order.Create;
  Data1 := l_Order.GetLessData;
  if not VarIsNull(Data1) then
  begin
    RefreshGrdCaption(CDS3, DBGridEh3, l_StrIndex, l_StrIndexDesc);
    l_Ans := True;
    CDS3.Data := Data1;
    CDS2.EmptyDataSet;
    PCL.ActivePageIndex := 2;
    PCLChange(PCL);
    l_Ans := False;
  end;
end;

procedure TFrmMPST070.btn_mpst070CClick(Sender: TObject);
begin
  inherited;

  l_Ans := True;
  try
    l_MPST070_Mps.LockAns := l_LockAns;
    if not l_MPST070_Mps.ExecMPS(CDS3, CDS2, l_OptLockAns) then
      Exit;
  finally
    l_Ans := False;
  end;

  RefreshData(RG2, CDS2);
  PCL.ActivePageIndex := 1;
  SetEdit3;
  RefreshColor;
  DBGridEh2.Repaint;

  if l_MPST070_Mps.ErrList.Count > 0 then
  begin
    FrmMPST070_ShowErrList := TFrmMPST070_ShowErrList.Create(nil);
    FrmMPST070_ShowErrList.Memo1.Hint := CheckLang('訂單單號/項次/料號/未排原因');
    FrmMPST070_ShowErrList.Memo1.Lines.Assign(l_MPST070_Mps.ErrList);
    try
      FrmMPST070_ShowErrList.ShowModal;
    finally
      FreeAndNil(FrmMPST070_ShowErrList);
    end;
  end
  else
    ShowMsg('排程完畢!', 64);
end;

procedure TFrmMPST070.btn_mpst070DClick(Sender: TObject);
const
  gzOrder = '廣州訂單';
var
  i, tmpCitem: Integer;
  tmpWdate: TDateTime;
  tmpCDS: TClientDataSet;
  post_bo: Boolean;
  tmpSimuver, tmpStr, tmpSQL: string;
  Data: OleVariant;
begin
  inherited;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS2.Data;
    if (not tmpCDS.Active) or tmpCDS.IsEmpty then
    begin
      ShowMsg('預排結果無資料,不可確認!', 48);
      Exit;
    end;

    if ShowMsg('確認排程嗎?', 33) = IDCancel then
      Exit;

    //取流水號
    tmpCitem := 1;
    tmpSimuver := GetSno(g_MInfo^.ProcId);
    if tmpSimuver = '' then
      Exit;

    //1.刪除已重排的異常單據
    //2.處理空行
    Data := Null;
    tmpSQL := 'Select * From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU);
    for i := 0 to l_MPST070_Mps.ErrorIdList.Count - 1 do
      tmpStr := tmpStr + ' or Simuver+''@''+Cast(Citem as varchar(20))=' + QuotedStr(l_MPST070_Mps.ErrorIdList.Strings[i]);
    tmpSQL := tmpSQL + ' And (EmptyFlag=1' + tmpStr + ')';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;

    //1.
    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'EmptyFlag<>1';
      Filtered := True;
      while not IsEmpty do
        Delete;
      Filtered := False;
      Filter := '';
    end;

    //2.
    for i := 0 to RG1.Items.Count - 1 do
    begin
      with l_MPST070_Mps.CDS_ChanNeng do
      begin
        Filtered := False;
        Filter := 'flag=2 and machine=' + QuotedStr(RG1.Items.Strings[i]); //產能修改過:flag=2
        Filtered := True;
        if IsEmpty then
          Continue;
        IndexFieldNames := 'wdate';
        while not Eof do
        begin
          if tmpCDS.Locate('sdate;machine', VarArrayOf([FieldByName('wdate').AsDateTime, FieldByName('machine').AsString]), []) then
          begin
            if FieldByName('capacity').AsInteger <= 0 then //用完
              tmpCDS.Delete
            else
            begin  //未用完,更新剩餘量
              tmpCDS.Edit;
              tmpCDS.FieldByName('Jitem').AsInteger := g_Jitem;
              tmpCDS.FieldByName('RemainCapacity').AsInteger := FieldByName('capacity').AsInteger;
              tmpCDS.FieldByName('Muser').AsString := g_UInfo^.UserId;
              tmpCDS.FieldByName('Mdate').AsDateTime := Now;
              tmpCDS.Post;
            end;
          end
          else if FieldByName('capacity').AsInteger > 0 then //新的空行
          begin
            tmpCDS.Append;
            tmpCDS.FieldByName('Bu').AsString := g_UInfo^.BU;
            tmpCDS.FieldByName('Simuver').AsString := tmpSimuver;
            tmpCDS.FieldByName('Citem').AsInteger := tmpCitem;
            tmpCDS.FieldByName('Jitem').AsInteger := g_Jitem;
            tmpCDS.FieldByName('AD').AsString := g_OZ;
            tmpCDS.FieldByName('Machine').AsString := FieldByName('machine').AsString;
            tmpCDS.FieldByName('Sdate').AsDateTime := FieldByName('wdate').AsDateTime;
            tmpCDS.FieldByName('RemainCapacity').AsInteger := FieldByName('capacity').AsInteger;
            tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
            tmpCDS.FieldByName('Idate').AsDateTime := Now;
            tmpCDS.FieldByName('Lock').AsBoolean := False;
            tmpCDS.FieldByName('EmptyFlag').AsInteger := 1;
            tmpCDS.FieldByName('ErrorFlag').AsInteger := 0;
            tmpCDS.FieldByName('Case_ans1').AsBoolean := False;
            tmpCDS.FieldByName('Case_ans2').AsBoolean := False;
            tmpCDS.Post;
            Inc(tmpCitem);
          end;

          Next;
        end;

        //排至未來日期,添加跳過的日期
        Last;
        tmpWdate := FieldByName('wdate').AsDateTime;
        Filtered := False;
        Filter := 'machine=' + QuotedStr(RG1.Items.Strings[i]) + ' and wdate<' + QuotedStr(DateToStr(tmpWdate)) + ' and flag=0';
        Filtered := True;
        IndexFieldNames := 'wdate';
        while not Eof do
        begin
          tmpCDS.Append;
          tmpCDS.FieldByName('Bu').AsString := g_UInfo^.BU;
          tmpCDS.FieldByName('Simuver').AsString := tmpSimuver;
          tmpCDS.FieldByName('Citem').AsInteger := tmpCitem;
          tmpCDS.FieldByName('Jitem').AsInteger := g_Jitem;
          tmpCDS.FieldByName('AD').AsString := g_OZ;
          tmpCDS.FieldByName('Machine').AsString := FieldByName('machine').AsString;
          tmpCDS.FieldByName('Sdate').AsDateTime := FieldByName('wdate').AsDateTime;
          tmpCDS.FieldByName('RemainCapacity').AsInteger := 0;
          tmpCDS.FieldByName('Iuser').AsString := g_UInfo^.UserId;
          tmpCDS.FieldByName('Idate').AsDateTime := Now;
          tmpCDS.FieldByName('Lock').AsBoolean := False;
          tmpCDS.FieldByName('EmptyFlag').AsInteger := 1;
          tmpCDS.FieldByName('ErrorFlag').AsInteger := 0;
          tmpCDS.FieldByName('Case_ans1').AsBoolean := False;
          tmpCDS.FieldByName('Case_ans2').AsBoolean := False;
          tmpCDS.Post;
          Inc(tmpCitem);
          Next;
        end;
      end;
    end;

    l_Ans := True;
    tmpStr := '@';
    ProgressBar1.Visible := True;
    CDS2.Filtered := False;
    CDS2.DisableControls;
    try
      ProgressBar1.Position := 0;
      ProgressBar1.Max := CDS2.RecordCount;
      CDS2.First;
      while not CDS2.Eof do
      begin
        ProgressBar1.Position := ProgressBar1.Position + 1;
        tmpCDS.Append;
        for i := 0 to tmpCDS.FieldCount - 1 do
          if not CDS2.FieldByName(tmpCDS.Fields[i].FieldName).IsNull then
            tmpCDS.Fields[i].Value := CDS2.FieldByName(tmpCDS.Fields[i].FieldName).Value;
        tmpCDS.FieldByName('Bu').AsString := g_UInfo^.BU;
        tmpCDS.FieldByName('Simuver').AsString := tmpSimuver;
        tmpCDS.FieldByName('Citem').AsInteger := tmpCitem;
        tmpCDS.FieldByName('Jitem').AsInteger := g_Jitem;
        if (Pos(UpperCase(tmpCDS.FieldByName('Machine').AsString), g_MachinePP_GZ) > 0) and (Pos(tmpCDS.FieldByName('Orderno').AsString, '225,221,S11,S14,S1D,239,220') > 0) and (Length(tmpCDS.FieldByName('Materialno1').AsString) = 0) then
          tmpCDS.FieldByName('Adate_new').Value := CDS2.FieldByName('Adate').Value + 1
        else
          tmpCDS.FieldByName('Adate_new').Value := CDS2.FieldByName('Adate').Value;
        if Length(tmpCDS.FieldByName('Materialno1').AsString) > 0 then
        begin
          if Length(tmpCDS.FieldByName('Premark').AsString) > 0 then
            tmpCDS.FieldByName('Premark').AsString := 'PNL ' + tmpCDS.FieldByName('Premark').AsString
          else
            tmpCDS.FieldByName('Premark').AsString := 'PNL';
        end;
        if Pos(Copy(tmpCDS.FieldByName('Materialno').AsString, 1, 1), 'PQ') > 0 then
        begin
          if Pos(Copy(tmpCDS.FieldByName('Materialno').AsString, 11, 1), '368') > 0 then
            tmpCDS.FieldByName('Premark').AsString := trim(tmpCDS.FieldByName('Premark').AsString + ' CAF-C');

          if Pos(RightStr(tmpCDS.FieldByName('Materialno').AsString, 1), 'nNkK') > 0 then
            if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
              tmpCDS.FieldByName('Premark').AsString := CheckLang('HDI訂單')
            else
              tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang('HDI訂單');
        end
        else if Pos(Copy(tmpCDS.FieldByName('Materialno').AsString, 3, 1), '368') > 0 then
        begin
          tmpCDS.FieldByName('Premark').AsString := Trim(tmpCDS.FieldByName('Premark').AsString + ' CAF-C');
        end;
        if (Pos(UpperCase(tmpCDS.FieldByName('Machine').AsString), g_MachinePP_GZ) = 0) and (Pos(tmpCDS.FieldByName('Custno').AsString, 'AC434,AC114,AC365,AC388,AC091,AC117,AC094,AC449,AC172,AC330') > 0) then
        begin
          if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
            tmpCDS.FieldByName('Premark').AsString := CheckLang(gzOrder)
          else
            tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang(gzOrder);
        end;
        if (tmpCDS.FieldByName('SrcFlag').AsInteger in [2, 4, 6]) and (Pos(tmpCDS.FieldByName('Custno').AsString, 'AC121,AC526,AC820,ACA97,AC625') > 0) and (Pos(CheckLang(gzOrder), tmpCDS.FieldByName('Premark').AsString) = 0) then
        begin
          if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
            tmpCDS.FieldByName('Premark').AsString := CheckLang(gzOrder)
          else
            tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang(gzOrder);
        end;
        if tmpCDS.FieldByName('Breadth').AsString < '44' then
        begin
          if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
            tmpCDS.FieldByName('Premark').AsString := CheckLang('窄碼')
          else
            tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang('窄碼');
        end;
        tmpCDS.Post;
        Inc(tmpCitem);
        CDS2.Next;
      end;

      post_bo := CDSPost(tmpCDS, p_TableName);
      UdpJitem(tmpSimuver);
    finally
      l_Ans := False;
      ProgressBar1.Visible := False;
      CDS2.EnableControls;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  if post_bo then
  begin
    CDS.EmptyDataSet;
    CDS2.EmptyDataSet;
    CDS3.EmptyDataSet;
    SetEdit3;
    l_OptLockAns := False;
    l_LockAns := False;
    if UnLockProc then
      ShowMsg('確認完畢,請重新查詢顯示資料!', 64);
  end;
end;

procedure TFrmMPST070.btn_mpst070EClick(Sender: TObject);
var
  Data1: OleVariant;
begin
  inherited;
  if not Assigned(FrmMPST070_GetCore) then
    FrmMPST070_GetCore := TFrmMPST070_GetCore.Create(Self);
  if PCL.ActivePageIndex = 0 then
  begin
    if CDS.Active and (not CDS.IsEmpty) then
      FrmMPST070_GetCore.dtp3.Date := CDS.FieldByName('Sdate').AsDateTime;
    FrmMPST070_GetCore.cbb1.ItemIndex := RG1.ItemIndex;
  end
  else if PCL.ActivePageIndex = 1 then
  begin
    if CDS2.Active and (not CDS2.IsEmpty) then
      FrmMPST070_GetCore.dtp3.Date := CDS2.FieldByName('Sdate').AsDateTime;
    FrmMPST070_GetCore.cbb1.ItemIndex := RG2.ItemIndex;
  end;

//  if FrmMPST070_GetCore.ShowModal = mrOK then
  FrmMPST070_GetCore.Show;
  if FrmMPST070_GetCore.l_IsBtnOkClick then
  begin
    Data1 := FrmMPST070_GetCore.GetData;
    if not VarIsNull(Data1) then
    begin
      RefreshGrdCaption(CDS3, DBGridEh3, l_StrIndex, l_StrIndexDesc);
      l_Ans := True;
      CDS3.Data := Data1;
      CDS2.EmptyDataSet;
      PCL.ActivePageIndex := 2;
      PCLChange(PCL);
      l_Ans := False;
    end;
  end;
end;

procedure TFrmMPST070.btn_mpst070FClick(Sender: TObject);
var
  tmpSQL: string;
begin
  inherited;
  CheckLock;

  if ShowMsg('確定進行強制結案嗎?', 33) = IDOK then
  begin
    tmpSQL := 'Update MPS070 Set Case_ans2=1,Case_user2=' + QuotedStr(g_UInfo^.UserId) + ',Case_date2=' + QuotedStr(FormatDateTime(g_cLongTimeSP, Now)) + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Case_ans1=1 And IsNull(Case_ans2,0)=0';
    if PostBySQL(tmpSQL) then
      ShowMsg('強制結案完畢,請重新查詢顯示資料!', 64);
  end;
end;

procedure TFrmMPST070.btn_mpst070GClick(Sender: TObject);
var
  Reslut: Boolean;
begin
  inherited;
  CheckLock;

  Reslut := False;
  l_Ans := True;
  CDS.DisableControls;
  FrmMPST070_EmptyFlagAdd := TFrmMPST070_EmptyFlagAdd.Create(nil);
  try
    Reslut := FrmMPST070_EmptyFlagAdd.ShowModal = mrOK;
    if Reslut then
    begin
      RefreshColor;
      l_SelList.Clear;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
    CDS.EnableControls;
    FreeAndNil(FrmMPST070_EmptyFlagAdd);
    if Reslut then
      ShowMsg('添加完畢!', 64);
  end;
end;

procedure TFrmMPST070.btn_mpst070HClick(Sender: TObject);
var
  i: Integer;
  tmpSdate, tmpOldSdate: TDateTime;
  tmpFilter, tmpSQL, tmpStr, tmpCurid, tmpS1, tmpS2: string;
  tmpCDS1, tmpCDS2, tmpCDS3: TClientDataSet;
  Data: OleVariant;
  tmpList: TStrings;

  procedure SPStr(SourceStr: string; var S1, S2: string);
  var
    pos1: Integer;
  begin
    pos1 := Pos('@', SourceStr);
    S1 := LeftStr(SourceStr, pos1 - 1);
    S2 := Copy(SourceStr, pos1 + 1, 20);
  end;

begin

  inherited;
  if l_SelList.Count = 0 then
  begin
    ShowMsg('請選擇要調整的單據!', 48);
    Exit;
  end;

  CheckLock;

  if ShowMsg('調整後將不再計算剩余產能,確定要調整嗎?', 33) = IdCancel then
    Exit;

  tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
  tmpOldSdate := tmpSdate;
  tmpCurid := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
  for i := 0 to l_SelList.Count - 1 do
    tmpFilter := tmpFilter + ',' + QuotedStr(l_SelList.Strings[i]);
  Delete(tmpFilter, 1, 1);
  tmpSQL := 'Select Distinct Sdate From MPS070' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Simuver+''@''+Cast(Citem as varchar(20)) in (' + tmpFilter + ')';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  l_Ans := True;
  CDS.DisableControls;
  tmpList := TStringList.Create;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  tmpCDS3 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data;
    with tmpCDS1 do
      if not Locate('Sdate', tmpSdate, []) then
      begin
        Append;
        Fields[0].AsDateTime := tmpSdate;
        Post;
        MergeChangeLog;
      end;
    tmpStr := '';
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      tmpStr := tmpStr + ',' + QuotedStr(DateToStr(tmpCDS1.Fields[0].AsDateTime));
      tmpCDS1.Next;
    end;
    Delete(tmpStr, 1, 1);
    Data := Null;
    tmpSQL := 'Select Simuver,Citem,Sdate,EmptyFlag From MPS070' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate in (' + tmpStr + ')' + ' And Machine=' + QuotedStr(RG1.Items[RG1.ItemIndex]) + ' And IsNull(ErrorFlag,0)=0 And IsNull(Case_ans2,0)=0' + ' Order By Sdate,Jitem,AD,FISno,RC Desc,Fiber,Simuver,Citem';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS2.Data := Data;

    with tmpCDS2 do
      while not Eof do
      begin
        if not CDS.Locate('Simuver;Citem', VarArrayOf([FieldByName('Simuver').AsString, FieldByName('Citem').AsInteger]), []) then
        begin
          ShowMsg('資料不同步,請重新查詢資料再試!', 48);
          Exit;
        end;
        Next;
      end;

    if not tmpCDS2.Locate('Sdate', tmpSdate, []) then
    begin
      ShowMsg('定位數據失敗!', 48);
      Exit;
    end;

    //所有需調整的資料,按排序添加至tmpList
    //tmpList包括2部份:1.原日期資料(按默認位置添加),2.其它調整過來的資料(排序后添加到選中位置)
    while tmpCDS2.FieldByName('Sdate').AsDateTime = tmpSdate do
    begin
      tmpStr := tmpCDS2.FieldByName('Simuver').AsString + '@' + IntToStr(tmpCDS2.FieldByName('Citem').AsInteger);
      if tmpStr = tmpCurid then //選中的位置
      begin
        if l_SelList.Count > 1 then //調整單據>1筆,重新排序
        begin
          Data := Null;
          tmpSQL := 'Select Simuver,Citem From MPS070' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Simuver+''@''+Cast(Citem as varchar(20)) in (' + tmpFilter + ')' + ' Order By AD,FISno,RC Desc,Fiber';
          if not QueryBySQL(tmpSQL, Data) then
            Exit;
          tmpCDS3.Data := Data;
          while not tmpCDS3.Eof do
          begin
            tmpList.Add(tmpCDS3.Fields[0].AsString + '@' + tmpCDS3.Fields[1].AsString);
            tmpCDS3.Next;
          end;
        end
        else
        begin
          for i := 0 to l_SelList.Count - 1 do
            tmpList.Add(l_SelList.Strings[i]);
        end;
      end;
      if l_SelList.IndexOf(tmpStr) = -1 then
        tmpList.Add(tmpStr);
      tmpCDS2.Next;
      if tmpCDS2.Eof then
        Break;
    end;

    for i := 0 to tmpList.Count - 1 do
    begin
      SPStr(tmpList.Strings[i], tmpS1, tmpS2);
      if not CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []) then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        ShowMsg('資料不同步!', 48);
        Exit;
      end;

      if tmpSdate <> CDS.FieldByName('sdate').AsDateTime then
        tmpOldSdate := CDS.FieldByName('sdate').AsDateTime;

      CDS.Edit;
      CDS.FieldByName('Sdate').AsDateTime := tmpSdate;
      CDS.FieldByName('Jitem').AsInteger := i + 1;
      CDS.Post;
    end;

    //若不同日期間調整,刪除空行
    if tmpCDS1.RecordCount > 1 then
    begin
      with tmpCDS2 do
      begin
        First;
        while not Eof do
        begin
          if FieldByName('EmptyFlag').AsInteger = 1 then
          begin
            if not CDS.Locate('Simuver;Citem', VarArrayOf([FieldByName('Simuver').AsString, FieldByName('Citem').AsInteger]), []) then
            begin
              if CDS.ChangeCount > 0 then
                CDS.CancelUpdates;
              ShowMsg('資料不同步!', 48);
              Exit;
            end;
            CDS.Delete;
          end;
          Next;
        end;
      end;
    end;

    //全部調走,添加空行
    with tmpCDS1 do
    begin
      First;
      while not Eof do
      begin
        if not CDS.Locate('Sdate', Fields[0].AsDateTime, []) then
        begin
          tmpStr := GetSno(g_MInfo^.ProcId);  //取流水號
          if tmpStr = '' then
          begin
            if CDS.ChangeCount > 0 then
              CDS.CancelUpdates;
            ShowMsg('取流水號失敗,請重試!', 48);
            Exit;
          end;
          CDS.Append;
          SetNewRecordData(CDS);
          CDS.FieldByName('EmptyFlag').AsInteger := 1;
          CDS.FieldByName('Simuver').AsString := tmpStr;
          CDS.FieldByName('Citem').AsInteger := 1;
          CDS.FieldByName('Jitem').AsInteger := g_Jitem;
          CDS.FieldByName('AD').AsString := g_OZ;
          CDS.FieldByName('Machine').AsString := RG1.Items[RG1.ItemIndex];
          CDS.FieldByName('Sdate').AsDateTime := Fields[0].AsDateTime;
          CDS.FieldByName('RemainCapacity').AsInteger := 0;
          CDS.Post;
        end;
        Next;
      end;
    end;

    if CDSPost(CDS, p_TableName) then
    begin
      if tmpOldSdate = tmpSdate then
        btn_mpst070P.Hint := ''
      else
        btn_mpst070P.Hint := DateToStr(tmpOldSdate) + '&' + DateToStr(tmpSdate);
    end
    else if CDS.ChangeCount > 0 then
      CDS.CancelUpdates;
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    SPStr(tmpCurid, tmpS1, tmpS2);
    CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []);
    l_Ans := False;
    CDS.EnableControls;
    SetEdit3;
    RefreshColor;
    l_SelList.Clear;
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST070.btn_mpst070IClick(Sender: TObject);
begin
  inherited;
  if CDS.IsEmpty then
  begin
    ShowMsg('請選擇數據!', 48);
    Exit;
  end;

  l_Ans := True;
  if not Assigned(FrmMPST070_Orderby) then
    FrmMPST070_Orderby := TFrmMPST070_Orderby.Create(Application);
  FrmMPST070_Orderby.l_machine := RG1.Items.Strings[RG1.ItemIndex];
  FrmMPST070_Orderby.l_sdate := CDS.FieldByName('Sdate').AsDateTime;
  try
    if FrmMPST070_Orderby.ShowModal = mrOK then
    begin
      RefreshColor;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
  end;
end;

procedure TFrmMPST070.btn_mpst070JClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST070_SwapSdate) then
    FrmMPST070_SwapSdate := TFrmMPST070_SwapSdate.Create(Application);
  FrmMPST070_SwapSdate.l_machine := RG1.Items.Strings[RG1.ItemIndex];
  if CDS.Active and (not CDS.IsEmpty) then
  begin
    FrmMPST070_SwapSdate.Dtp1.Date := CDS.FieldByName('Sdate').AsDateTime;
    FrmMPST070_SwapSdate.Dtp2.Date := CDS.FieldByName('Sdate').AsDateTime;
  end
  else
  begin
    FrmMPST070_SwapSdate.Dtp1.Date := Date;
    FrmMPST070_SwapSdate.Dtp2.Date := Date;
  end;

  FrmMPST070_SwapSdate.ShowModal;
  if FrmMPST070_SwapSdate.l_ret then
    CDS.EmptyDataSet;
end;

procedure TFrmMPST070.btn_mpst070KClick(Sender: TObject);
var
  tmpSdate: TDateTime;
  tmpSQL, tmpMachine, tmpAD, tmpFi, tmpRC: string;
  tmpSpeed, tmpUseCapacity: Double;
  tmpRemainCapacity: Integer;
  tmpCDS1, tmpCDS2, tmpCDS3: TClientDataSet;
  Data1, Data2, Data3: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('排程無資料,不可計算', 48);
    Exit;
  end;

  tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
  tmpMachine := CDS.FieldByName('Machine').AsString;
  tmpSQL := 'Select Materialno,Sqty From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate=' + QuotedStr(DateToStr(tmpSdate)) + ' And Machine=' + QuotedStr(tmpMachine) + ' And IsNull(ErrorFlag,0)=0 And Len(IsNull(Materialno,''''))>0 And Sqty>0';
  if not QueryBySQL(tmpSQL, Data1) then
    Exit;

  tmpSQL := 'Select Adhesive,Fiber,RC_lower,RC_upper,Speed From MPS510' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Machine=' + QuotedStr(tmpMachine);
  if not QueryBySQL(tmpSQL, Data2) then
    Exit;

  tmpSQL := 'Select Code4_5,Fiber From MPS540 Where Bu=' + QuotedStr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data3) then
    Exit;

  l_Ans := True;
  tmpUseCapacity := 0;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  tmpCDS3 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := Data1;
    tmpCDS2.Data := Data2;
    tmpCDS3.Data := Data3;
    while not tmpCDS1.Eof do
    begin
      tmpAD := Copy(tmpCDS1.FieldByName('Materialno').AsString, 2, 1);
      if Length(tmpCDS1.FieldByName('Materialno').AsString) = 18 then
      begin
        tmpFi := Copy(tmpCDS1.FieldByName('Materialno').AsString, 4, 4);
        tmpRC := Copy(tmpCDS1.FieldByName('Materialno').AsString, 8, 3);
      end
      else if Length(tmpCDS1.FieldByName('Materialno').AsString) = 13 then
      begin
        tmpFi := Copy(tmpCDS1.FieldByName('Materialno').AsString, 4, 2);
        if tmpCDS3.Locate('Code4_5', tmpFi, []) then
          tmpFi := tmpCDS3.FieldByName('Fiber').AsString;
        tmpRC := Copy(tmpCDS1.FieldByName('Materialno').AsString, 6, 3);
      end;

      if Length(tmpFi) = 4 then
      begin
        with tmpCDS2 do
        begin
          Filtered := False;
          Filter := 'adhesive=' + QuotedStr(tmpAD) + ' and fiber=' + QuotedStr(tmpFi) + ' and rc_lower<=' + FloatToStr(StrToInt(tmpRC) / 10) + ' and rc_upper>=' + FloatToStr(StrToInt(tmpRC) / 10);
          Filtered := True;
          tmpSpeed := FieldByName('speed').AsFloat;
        end;

        if tmpSpeed > 0 then
          tmpUseCapacity := tmpUseCapacity + tmpCDS1.FieldByName('Sqty').AsFloat / tmpSpeed;
      end;
      tmpCDS1.Next;
    end;

    tmpUseCapacity := Trunc(tmpUseCapacity);

    Data1 := Null;
    tmpSQL := 'Select Top 1 Capacity From MPS500 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Wdate=' + QuotedStr(DateToStr(tmpSdate)) + ' And Machine=' + QuotedStr(tmpMachine);
    if not QueryBySQL(tmpSQL, Data1) then
      Exit;
    tmpCDS1.Data := Data1;
    tmpRemainCapacity := Trunc(tmpCDS1.Fields[0].AsFloat - tmpUseCapacity);
    tmpSQL := '總產能：' + FloatToStr(tmpCDS1.Fields[0].AsFloat) + #13#10 + '已使用：' + FloatToStr(tmpUseCapacity) + #13#10 + '剩余：' + FloatToStr(tmpRemainCapacity);
    if tmpRemainCapacity <= 0 then
    begin
      ShowMsg(tmpSQL, 64);
      Exit;
    end;

    tmpSQL := tmpSQL + #13#10 + '按[確定]添加或修改空行產能,按[取消]退出,請選擇操作?';
    if ShowMsg(tmpSQL, 33) = IdCancel then
      Exit;

    Data1 := Null;
    tmpSQL := 'Select Simuver,Citem,RemainCapacity From MPS070' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate=' + QuotedStr(DateToStr(tmpSdate)) + ' And Machine=' + QuotedStr(tmpMachine) + ' And EmptyFlag=1';
    if not QueryBySQL(tmpSQL, Data1) then
      Exit;
    tmpCDS1.Data := Data1;
    if not tmpCDS1.IsEmpty then
    begin
      if not CDS.Locate('Simuver;Citem', VarArrayOf([tmpCDS1.FieldByName('Simuver').AsString, tmpCDS1.FieldByName('Citem').AsInteger]), []) then
      begin
        ShowMsg('空行已存在,但定位失敗,請重新查詢資料重試!', 48);
        Exit;
      end;

      if CDS.FieldByName('RemainCapacity').AsInteger = tmpRemainCapacity then
        Exit;

      CDS.Edit;
      CDS.FieldByName('RemainCapacity').AsFloat := tmpRemainCapacity;
      CDS.Post;
    end
    else
    begin
      //取流水號
      tmpSQL := GetSno(g_MInfo^.ProcId);
      if tmpSQL = '' then
        Exit;

      with CDS do
      begin
        Append;
        FieldByName('Simuver').AsString := tmpSQL;
        FieldByName('Citem').AsInteger := 1;
        FieldByName('Jitem').AsInteger := g_Jitem;
        FieldByName('Sdate').AsDateTime := tmpSdate;
        FieldByName('Machine').AsString := tmpMachine;
        FieldByName('RemainCapacity').AsInteger := tmpRemainCapacity;
        FieldByName('AD').AsString := g_OZ;
        FieldByName('EmptyFlag').AsInteger := 1;
        FieldByName('Lock').AsBoolean := False;
        FieldByName('BU').AsString := g_UInfo^.BU;
        FieldByName('Iuser').AsString := g_UInfo^.UserId;
        FieldByName('Idate').AsDateTime := Now;
        FieldByName('ErrorFlag').AsInteger := 0;
        FieldByName('Case_ans1').AsBoolean := False;
        FieldByName('Case_ans2').AsBoolean := False;
        Post;
      end;
    end;

    if not CDSPost(CDS, 'MPS070') then
      if CDS.ChangeCount > 0 then
      begin
        CDS.CancelUpdates;
        Exit;
      end;
    RefreshColor;
    l_SelList.Clear;
    DBGridEh1.Repaint;

  finally
    l_Ans := False;
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
  end;
end;

procedure TFrmMPST070.btn_mpst070LClick(Sender: TObject);
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
  GetQueryStock(str, true);
end;

procedure TFrmMPST070.btn_mpst070MClick(Sender: TObject);
var
  tmpStr1, tmpStr2: string;
begin
  inherited;
  tmpStr1 := '';
  if not Assigned(FrmMPST070_bom) then
    FrmMPST070_bom := TFrmMPST070_bom.Create(Self);
  FrmMPST070_bom.FormStyle := fsStayOnTop;
//  FrmMPST070_bom:=TFrmMPST070_bom.Create(nil);
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
  FrmMPST070_bom.Show;
//  try
//    FrmMPST070_bom.ShowModal;
//  finally
//    FreeAndNil(FrmMPST070_bom);
//  end;
end;

procedure TFrmMPST070.btn_mpst070NClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定更新完工數量嗎?', 33) = IDCancel then
    Exit;

  if PostBySQL('exec dbo.proc_UpdateWostationPP ' + QuotedStr(g_UInfo^.BU)) then
    ShowMsg('更新完畢,請重新查詢顯示資料!', 64);
end;

procedure TFrmMPST070.btn_mpst070OClick(Sender: TObject);
begin
  inherited;
  FrmMPST070_UseCoreDetail := TFrmMPST070_UseCoreDetail.Create(nil);
  try
    FrmMPST070_UseCoreDetail.ShowModal;
  finally
    FreeAndNil(FrmMPST070_UseCoreDetail);
  end;
end;

procedure TFrmMPST070.btn_mpst070PClick(Sender: TObject);
var
  tmpStr1, tmpStr2: string;
  d1, d2: TDateTime;
  Pos1: Integer;
begin
  inherited;
  //格式: btn_mpst070P.Hint=A&B
  tmpStr1 := btn_mpst070P.Hint;
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

procedure TFrmMPST070.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  i: Integer;
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  tmpStr := Copy(CDS.FieldByName('materialno').AsString, 2, 1);
  for i := Low(l_ArrADColor) to High(l_ArrADColor) do
    if Pos(tmpStr, l_ArrADColor[i].AD) > 0 then
    begin
      AFont.Color := RGB(l_ArrADColor[i].R, l_ArrADColor[i].G, l_ArrADColor[i].B);
      Break;
    end;

  if l_ColorList.Count >= CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
      Background := l_Color2
    else
      Background := l_Color1;
  end;
end;

procedure TFrmMPST070.DBGridEh3GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if CDS3.Active and (CDS3.FieldByName('srcflag').AsInteger in [3, 4]) then
    Background := $00C08080;
end;

procedure TFrmMPST070.DBGridEh1DblClick(Sender: TObject);
var
  tmpStr, tmpSimuver, tmpMachine: string;
  tmpCitem, tmpMaxCapacity: Integer;
  tmpSpeed, tmpTotCapacity: Double;
  tmpSdate: TDateTime;
  tmpIsBS: Boolean;
  tmpCDS: TClientDataSet;
  tmpData: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if (DBGridEh1.SelectedField = CDS.FieldByName('Case_ans1')) or (DBGridEh1.SelectedIndex = 0) then
    Exit;

  CheckLock;

  if (CDS.FieldByName('ErrorFlag').AsInteger = 0) and (Length(CDS.FieldByName('Materialno').AsString) > 0) then
  begin
    tmpIsBS := Pos(UpperCase(Copy(CDS.FieldByName('Materialno').AsString, 1, 1)), 'PQ') = 0;
    if tmpIsBS then
      tmpStr := '確定撤消並返回未排狀態嗎?'
    else
      tmpStr := '確定撤消嗎?';

    if ShowMsg(tmpStr, 33) = IDCancel then
      Exit;

    tmpSimuver := CDS.FieldByName('Simuver').AsString;
    tmpCitem := CDS.FieldByName('Citem').AsInteger;
    tmpMachine := CDS.FieldByName('Machine').AsString;
    tmpSdate := CDS.FieldByName('Sdate').AsDateTime;

    tmpStr := 'Select Top 1 Capacity From MPS500 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Machine=' + QuotedStr(tmpMachine) + ' And Wdate=' + QuotedStr(DateToStr(tmpSdate));
    if not QueryOneCR(tmpStr, tmpData) then
      Exit;

    tmpMaxCapacity := StrToIntDef(VarToStr(tmpData), 0);
    if tmpMaxCapacity <= 0 then
    begin
      ShowMsg(DateToStr(tmpSdate) + '/' + tmpMachine + '產能設定不能小於0', 48);
      Exit;
    end;

    tmpData := Null;
    tmpStr := 'Select Simuver,Citem,Materialno,EmptyFlag,Sqty From MPS070' + ' Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate=' + QuotedStr(DateToStr(tmpSdate)) + ' And Machine=' + QuotedStr(tmpMachine) + ' And Simuver+''@''+Cast(Citem as varchar(20))<>' + QuotedStr(tmpSimuver + '@' + IntToStr(tmpCitem)) + ' And IsNull(ErrorFlag,0)=0';
    if not QueryBySQL(tmpStr, tmpData) then
      Exit;

    l_Ans := True;
    tmpTotCapacity := 0;
    CDS.DisableControls;
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := tmpData;
      while not tmpCDS.Eof do
      begin
        if tmpCDS.FieldByName('EmptyFlag').AsInteger <> 1 then
        begin
          tmpSpeed := l_MPST070_Mps.GetSpeed(tmpMachine, tmpCDS.FieldByName('Materialno').AsString);
          if tmpSpeed > 0 then
            tmpTotCapacity := tmpTotCapacity + RoundTo(tmpCDS.FieldByName('Sqty').AsFloat / tmpSpeed, -1);
        end;
        tmpCDS.Next;
      end;

      if tmpCDS.Locate('EmptyFlag', 1, []) then
      begin
        if not CDS.Locate('Simuver;Citem', VarArrayOf([tmpCDS.FieldByName('Simuver').AsString, tmpCDS.FieldByName('Citem').AsInteger]), []) then
        begin
          ShowMsg('定位失敗,請重新查詢資料再試!', 48);
          Exit;
        end;
        if tmpMaxCapacity <= tmpTotCapacity then
          CDS.Delete
        else
        begin
          CDS.Edit;
          if tmpTotCapacity = 0 then
            CDS.FieldByName('RemainCapacity').AsInteger := 0
          else
            CDS.FieldByName('RemainCapacity').AsInteger := Trunc(tmpMaxCapacity - tmpTotCapacity);
          CDS.Post;
        end;
      end
      else
      begin
        if tmpTotCapacity <= tmpMaxCapacity then
        begin
          tmpStr := GetSno(g_MInfo^.ProcId);  //取流水號
          if tmpStr = '' then
          begin
            ShowMsg('取流水號失敗,請重試!', 48);
            Exit;
          end;
          CDS.Append;
          SetNewRecordData(CDS);
          CDS.FieldByName('EmptyFlag').AsInteger := 1;
          CDS.FieldByName('Simuver').AsString := tmpStr;
          CDS.FieldByName('Citem').AsInteger := 1;
          CDS.FieldByName('Jitem').AsInteger := g_Jitem;
          CDS.FieldByName('AD').AsString := g_OZ;
          CDS.FieldByName('Machine').AsString := tmpMachine;
          CDS.FieldByName('Sdate').AsDateTime := tmpSdate;
          if tmpTotCapacity = 0 then
            CDS.FieldByName('RemainCapacity').AsInteger := 0
          else
            CDS.FieldByName('RemainCapacity').AsInteger := Trunc(tmpMaxCapacity - tmpTotCapacity);
          CDS.Post;
        end;
      end;

      CDS.Locate('Simuver;Citem', VarArrayOf([tmpSimuver, tmpCitem]), []);
      if tmpIsBS then
      begin
        CDS.Edit;
        CDS.FieldByName('ErrorFlag').AsInteger := 1;
        CDS.Post;
      end
      else
        CDS.Delete;

      if not CDSPost(Self.CDS, p_TableName) then
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
    finally
      FreeAndNil(tmpCDS);
      CDS.EnableControls;
      l_Ans := False;
      l_SelList.Clear;
      RefreshColor;
      DBGridEh1.Repaint;
    end;
  end;
end;

procedure TFrmMPST070.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  tmpPno, pg: string;
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
      g_DelFname := 'select,case_ans1,sdate,edate,orderitem,sqty,breadth,fiber,' + 'adate_new,orderqty,orderitem2,pnlsize1,pnlsize2,edate';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end
  else if (Shift = [ssCtrl]) and (Key = 81) and CDS.Active and  //Ctrl+Q 兩角訂單更改
    (not CDS.IsEmpty) and (g_MInfo^.R_edit) then
  begin
    if (CDS.FieldByName('ErrorFlag').AsInteger = 0) and (CDS.FieldByName('EmptyFlag').AsInteger <> 1) then
    begin
      CheckLock;

      FrmMPST070_Orderno2Edit := TFrmMPST070_Orderno2Edit.Create(nil);
      with FrmMPST070_Orderno2Edit do
      begin
        Edit1.Text := Self.CDS.FieldByName('Orderno2').AsString;
        Edit2.Text := Self.CDS.FieldByName('Orderitem2').AsString;
      end;
      try
        if FrmMPST070_Orderno2Edit.ShowModal = mrOk then
        begin
          if (CDS.FieldByName('Orderno2').AsString = FrmMPST070_Orderno2Edit.Edit1.Text) and (CDS.FieldByName('Orderitem2').AsString = FrmMPST070_Orderno2Edit.Edit2.Text) then
            Exit;

          CDS.Edit;
          CDS.FieldByName('Orderno2').AsString := FrmMPST070_Orderno2Edit.Edit1.Text;
          if Trim(FrmMPST070_Orderno2Edit.Edit2.Text) = '' then
            CDS.FieldByName('Orderitem2').Clear
          else
            CDS.FieldByName('Orderitem2').AsInteger := StrToInt(FrmMPST070_Orderno2Edit.Edit2.Text);
          CDS.Post;
          if not CDSPost(CDS, p_TableName) then
            if CDS.ChangeCount > 0 then
              CDS.CancelUpdates;
        end;
      finally
        FreeAndNil(FrmMPST070_Orderno2Edit);
      end;
    end;
  end
  else if (Shift = [ssCtrl]) and (Key = 69) and CDS.Active and  //Ctrl+E 更改
    (not CDS.IsEmpty) and (g_MInfo^.R_edit) then
  begin
    if (CDS.FieldByName('ErrorFlag').AsInteger = 0) and (CDS.FieldByName('EmptyFlag').AsInteger <> 1) then
    begin
      CheckLock;

      FrmMPS070_CtrlE := TFrmMPS070_CtrlE.Create(nil);
      if not CDS.FieldByName('Adate').IsNull then
        FrmMPS070_CtrlE.Edit1.Text := DateToStr(CDS.FieldByName('Adate').AsDateTime);
      FrmMPS070_CtrlE.Edit2.Text := FloatToStr(CDS.FieldByName('Sqty').AsFloat);
      if not CDS.FieldByName('Adate_new').IsNull then
        FrmMPS070_CtrlE.Dtp.Value := CDS.FieldByName('Adate_new').AsDateTime;
      FrmMPS070_CtrlE.Edit3.Text := CDS.FieldByName('Premark').AsString;
      FrmMPS070_CtrlE.Edit4.Text := CDS.FieldByName('Wono').AsString;
      FrmMPS070_CtrlE.Edit5.Text := CDS.FieldByName('Materialno').AsString;
      FrmMPS070_CtrlE.Edit6.Text := CDS.FieldByName('Orderno').AsString;
      FrmMPS070_CtrlE.Edit7.Text := CDS.FieldByName('Orderitem').AsString;
      FrmMPS070_CtrlE.Cbb.Text := CDS.FieldByName('Fiber').AsString;
      try
        if FrmMPS070_CtrlE.ShowModal = mrOk then
        begin
          CDS.Edit;
          if VarIsNull(FrmMPS070_CtrlE.Dtp.Value) then
            CDS.FieldByName('Adate_new').Clear
          else
            CDS.FieldByName('Adate_new').AsDateTime := FrmMPS070_CtrlE.Dtp.Value;
          CDS.FieldByName('Sqty').AsFloat := StrToFloat(FrmMPS070_CtrlE.Edit2.Text);
          CDS.FieldByName('Premark').AsString := FrmMPS070_CtrlE.Edit3.Text;
          CDS.FieldByName('Wono').AsString := FrmMPS070_CtrlE.Edit4.Text;
          CDS.FieldByName('Orderno').AsString := FrmMPS070_CtrlE.Edit6.Text;
          CDS.FieldByName('Orderitem').AsString := FrmMPS070_CtrlE.Edit7.Text;
          CDS.FieldByName('Fiber').AsString := FrmMPS070_CtrlE.Cbb.Text;
          if CDS.FieldByName('Materialno').AsString <> FrmMPS070_CtrlE.Edit5.Text then
          begin
            tmpPno := FrmMPS070_CtrlE.Edit5.Text;
            CDS.FieldByName('Materialno').AsString := tmpPno;
            if Length(tmpPno) > 0 then
            begin
              CDS.FieldByName('AD').Value := Copy(tmpPno, 2, 1);
              if SameText(CDS.FieldByName('AD').Value, 'J') then
                CDS.FieldByName('AD').Value := '1';
              if Length(tmpPno) = 18 then
              begin
                CDS.FieldByName('FI').Value := Copy(tmpPno, 4, 4);
                CDS.FieldByName('RC').Value := Copy(tmpPno, 8, 3);
              end
              else
              begin
                CDS.FieldByName('FI').Value := l_MPST070_Mps.GetFiber(Copy(tmpPno, 4, 2));
                CDS.FieldByName('RC').Value := Copy(tmpPno, 6, 3);
              end;
              CDS.FieldByName('FISno').AsInteger := l_MPST070_Mps.GetFiSno(CDS.FieldByName('FI').AsString);
              if CDS.FieldByName('FI').AsString = '3313' then //3313<=>2313
                CDS.FieldByName('FI').AsString := '2313a';
              pg := Copy(tmpPno, 3, 1);
              if Pos(pg, '36') > 0 then
                pg := '36'
              else if Pos(pg, '8T') > 0 then
                pg := '8T'
              else
                pg := pg + '@';
              CDS.FieldByName('PG').Value := pg;
            end;
          end;
          CDS.Post;
          if not CDSPost(CDS, p_TableName) then
            if CDS.ChangeCount > 0 then
              CDS.CancelUpdates;
        end;
      finally
        FreeAndNil(FrmMPS070_CtrlE);
      end;
    end;
  end;
end;

procedure TFrmMPST070.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if SameText(Column.FieldName, 'case_ans1') then
  begin
    CDS.Edit;
    CDS.FieldByName('Case_ans1').AsBoolean := not CDS.FieldByName('Case_ans1').AsBoolean;
    if CDS.FieldByName('Case_ans1').AsBoolean then
    begin
      CDS.FieldByName('Case_user1').AsString := g_UInfo^.UserId;
      CDS.FieldByName('Case_date1').AsDateTime := Now;
    end
    else
    begin
      CDS.FieldByName('Case_user1').Clear;
      CDS.FieldByName('Case_date1').Clear;
    end;
    CDS.Post;
    if not CDSPost(Self.CDS, p_TableName) then
      if CDS.ChangeCount > 0 then
        CDS.CancelUpdates;
  end;

  if SameText(Column.FieldName, 'select') and (CDS.FieldByName('EmptyFlag').AsInteger <> 1) then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) = -1 then
      l_SelList.Add(tmpStr)
    else
      l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST070.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) <> -1 then
      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
  end;
end;

procedure TFrmMPST070.CDSAfterCancel(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSAfterEdit(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSAfterInsert(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSAfterScroll(DataSet: TDataSet);
begin
  if l_Ans then
    Exit;

  inherited;
  SetEdit3;

//  if DBGridEh1.FindFieldColumn('ppqty').Visible then
//    GetPPQty;
end;

procedure TFrmMPST070.CDSBeforeDelete(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSBeforeEdit(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSBeforeInsert(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDSNewRecord(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmMPST070.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;

  if (Trim(CDS2.FieldByName('Orderno').AsString) <> '') and CDS3.Active then
    CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]), [])
  else if (Trim(CDS2.FieldByName('Orderno').AsString) = '') and CDS3.Active then
    CDS3.Locate('Materialno', CDS2.FieldByName('Materialno').AsString, []);

  SetEdit3;
  SetSBars(CDS2);
end;

procedure TFrmMPST070.CDS2BeforePost(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  if Length(CDS2.FieldByName('Orderno').AsString) > 0 then
  begin
    if CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]), []) then
    begin
      l_Ans := True;
      CDS3.Edit;
      CDS3.FieldByName('Sdate1').Value := CDS2.FieldByName('Sdate1').Value;
      CDS3.FieldByName('Machine1').Value := CDS2.FieldByName('Machine1').Value;
      CDS3.Post;
      l_Ans := False;
    end;
  end
  else
  begin
    if CDS3.Locate('Materialno', CDS2.FieldByName('Materialno').AsString, []) then
    begin
      l_Ans := True;
      CDS3.Edit;
      CDS3.FieldByName('Sdate1').Value := CDS2.FieldByName('Sdate1').Value;
      CDS3.FieldByName('Machine1').Value := CDS2.FieldByName('Machine1').Value;
      CDS3.Post;
      l_Ans := False;
    end;
  end;
end;

procedure TFrmMPST070.CDS3AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  SetSBars(CDS3);
end;

procedure TFrmMPST070.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  SetNewRecordData(DataSet);
end;

procedure TFrmMPST070.PCLChange(Sender: TObject);
begin
  inherited;
  SetEdit3;
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

procedure TFrmMPST070.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N20.Visible := g_MInfo^.R_edit;
  N21.Visible := g_MInfo^.R_edit;
  N22.Visible := g_MInfo^.R_edit;
  N23.Visible := g_MInfo^.R_edit;
  N25.Visible := g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
  begin
    N20.Enabled := CDS.Active and (not CDS.IsEmpty);
    N21.Enabled := l_SelList.Count > 0;
    N22.Enabled := N20.Enabled;
    N23.Enabled := CDS.Active and (CDS.FieldByName('EmptyFlag').AsInteger = 1);
    N25.Enabled := N23.Enabled;
  end;
end;

procedure TFrmMPST070.PopupMenu2Popup(Sender: TObject);
begin
  inherited;
  //DBGridEh3.Tag=0單選 1多選
  N24.Visible := CDS3.Active and (not CDS3.IsEmpty);
  N28.Visible := N24.Visible;
  N29.Visible := N24.Visible;
  N30.Visible := N24.Visible;

  N28.Enabled := g_MInfo^.R_edit and (DBGridEh3.Tag = 0) and (CDS3.FieldByName('srcflag').AsInteger in [3, 4]);
end;

procedure TFrmMPST070.N20Click(Sender: TObject);
var
  tmpStr: string;
  tmpSdate: TDateTime;
  P: TBookMark;
begin
  inherited;
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
        tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
        if l_SelList.IndexOf(tmpStr) = -1 then
          l_SelList.Add(tmpStr);
      end
      else
        Break;

      CDS.Next;
    end;
  finally
    CDS.EnableControls;
  end;
end;

procedure TFrmMPST070.N21Click(Sender: TObject);
begin
  inherited;
  l_SelList.Clear;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST070.N22Click(Sender: TObject);
var
  tmpSdate: TDateTime;
  P: TBookMark;
begin
  inherited;
  CheckLock;
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
        if not CDS.FieldByName('Case_ans1').AsBoolean then
        begin
          CDS.Edit;
          CDS.FieldByName('Case_ans1').AsBoolean := True;
          CDS.Post;
        end;
      end
      else
        Break;

      CDS.Next;
    end;
    if not CDSPost(CDS, p_TableName) then
      if CDS.ChangeCount > 0 then
        CDS.CancelUpdates;
  finally
    CDS.EnableControls;
  end;
end;

procedure TFrmMPST070.N23Click(Sender: TObject);
begin
  inherited;
  CheckLock;
  FrmMPST070_EmptyFlagEdit := TFrmMPST070_EmptyFlagEdit.Create(nil);
  if Length(Trim(CDS.FieldByName('Premark').AsString)) > 0 then
    FrmMPST070_EmptyFlagEdit.Edit4.Text := StringReplace(CDS.FieldByName('Premark').AsString, CheckLang('已保留'), '', [rfReplaceAll, rfIgnoreCase]);
  try
    FrmMPST070_EmptyFlagEdit.ShowModal;
  finally
    FreeAndNil(FrmMPST070_EmptyFlagEdit);
  end;
end;

procedure TFrmMPST070.N25Click(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  inherited;
  CheckLock;
  tmpSQL := 'Select Count(*) as Cnt From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate=' + QuotedStr(DateToStr(CDS.FieldByName('Sdate').AsDateTime)) + ' And Machine=' + QuotedStr(CDS.FieldByName('Machine').AsString) + ' And IsNull(ErrorFlag,0)=0';
  if not QueryOneCR(tmpSQL, Data) then
    Exit;
  if StrToIntDef(VarToStr(Data), 0) = 1 then
  begin
    ShowMsg('當前日期無排程資料,不可刪除!', 48);
    Exit;
  end;
  if ShowMsg('確定要刪除嗎?', 33) = IdCancel then
    Exit;

  CDS.Delete;
  if CDSPost(CDS, p_TableName) then
  begin
    RefreshColor;
    l_SelList.Clear;
    DBGridEh1.Repaint;
  end
  else if CDS.ChangeCount > 0 then
    CDS.CancelUpdates;
end;

procedure TFrmMPST070.N24Click(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定要刪除此筆資料嗎?', 33) = IDOK then
  begin
    if DBGridEh3.SelectedRows.Count > 1 then
      DBGridEh3.SelectedRows.Delete
    else
      CDS3.Delete;
  end;
end;

procedure TFrmMPST070.N28Click(Sender: TObject);
var
  tmpSQL: string;
begin
  inherited;
  if ShowMsg('確定要刪除此筆資料嗎?', 33) = IDOK then
  begin
    tmpSQL := CDS3.FieldByName('ErrorId').AsString;
    tmpSQL := 'Delete From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And ErrorFlag=1 And simuver+''@''+Cast(citem as varchar(10))=' + QuotedStr(tmpSQL);
    if PostBySQL(tmpSQL) then
      CDS3.Delete;
  end;
end;

procedure TFrmMPST070.N29Click(Sender: TObject);
var
  i: Integer;
  tmpList: TStrings;
begin
  inherited;
  l_Ans := True;
  tmpList := TStringList.Create;
  try
    for i := 0 to CDS3.FieldCount - 1 do
      tmpList.Add(Trim(CDS3.Fields[i].AsString));

    CDS3.Append;
    for i := 0 to CDS3.FieldCount - 1 do
      if Length(tmpList.Strings[i]) > 0 then
        CDS3.Fields[i].AsString := tmpList.Strings[i];

    CDS3.FieldByName('wono').Clear;
    CDS3.FieldByName('errorid').Clear;
    if CDS3.FieldByName('srcflag').AsInteger in [1, 3, 5] then
      CDS3.FieldByName('srcflag').AsString := '1'
    else
      CDS3.FieldByName('srcflag').AsString := '2';
    CDS3.Post;
    CDS3.MergeChangeLog;
  finally
    l_Ans := False;
    FreeAndNil(tmpList);
  end;
end;

procedure TFrmMPST070.N30Click(Sender: TObject);
var
  tmpMachine: string;
  tmpDate: TDateTime;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if CDS3.FieldByName('sdate1').IsNull then
  begin
    ShowMsg('請輸入生產日期!', 48);
    Exit;
  end;

  tmpMachine := CDS3.FieldByName('machine1').AsString;
  tmpDate := CDS3.FieldByName('sdate1').AsDateTime;

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
        FieldByName('machine1').AsString := tmpMachine;
        FieldByName('sdate1').AsDateTime := tmpDate;
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

procedure TFrmMPST070.CDS3BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not l_Ans then
    if not DataSet.FieldByName('sdate1').IsNull then
      if DataSet.FieldByName('sdate1').AsDateTime < Date then
      begin
        ShowMsg('[' + DBGridEh3.FieldColumns['sdate1'].Title.Caption + ']不能小於當前日期', 48);
        Abort;
      end;
end;

procedure TFrmMPST070.DBGridEh3DblClick(Sender: TObject);
begin
  inherited;
  with DBGridEh3 do
  begin
    if Tag = 0 then
    begin
      Tag := 1;
      Options := Options + [dgRowSelect, dgMultiSelect];
    end
    else
    begin
      Tag := 0;
      Options := Options - [dgRowSelect, dgMultiSelect] + [dgEditing];
      ReadOnly := False;
    end;
  end;
end;

procedure TFrmMPST070.DBGridEh3TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS3, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST070.btn_mpst070QClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPST070_UpdateWono) then
    FrmMPST070_UpdateWono := TFrmMPST070_UpdateWono.Create(Application);
  FrmMPST070_UpdateWono.ShowModal;
end;

procedure TFrmMPST070.btn_mpst070CalPPClick(Sender: TObject);
var
  tmpStr1: string;
begin
  inherited;
  tmpStr1 := '';
  if not Assigned(FrmMPST070_CalPP) then
    FrmMPST070_CalPP := TFrmMPST070_CalPP.Create(Self);
  FrmMPST070_CalPP.FormStyle := fsStayOnTop;
  FrmMPST070_CalPP.DateTimePicker1.date := now();
  FrmMPST070_CalPP.DateTimePicker2.date := now() + 7;
  FrmMPST070_CalPP.Show;
end;

procedure TFrmMPST070.GetPPQty;
var
  data: OleVariant;
  tmpSql, tmpBu, s12, s47: string;
  s3: char;
begin
  if CDS.IsEmpty or (not CDS.Active) then
    exit;

  if Pos(cds.fieldbyname('machine').AsString, 'T1,T2,T3,T4,T5') > 0 then
    tmpBu := 'ORACLE'
  else
    tmpBu := 'ORACLE1';

  if not Assigned(imgCds) then
    imgCds := TClientDataSet.Create(nil);
  if not imgCds.Active then
  begin
    tmpSql := 'select img01,img10 from img_file where ta_img01=''P1'' AND IMG02=''N2AF2'' and img10>0';
    if not QueryBySQL(tmpSql, data, tmpBu) then
      exit;
    imgCds.data := data;
  end;
  CDS.DisableControls;
  CDS.First;
  try
    imgCds.Filtered := true;
    while not Cds.Eof do
    begin
      if Length(cds.fieldbyname('materialno').AsString) < 10 then
        exit;
      s3 := cds.fieldbyname('materialno').AsString[3];
      s12 := copy(cds.fieldbyname('materialno').AsString, 1, 2);
      s47 := copy(cds.fieldbyname('materialno').AsString, 4, 7);
      if s3 in ['A', 'C', '6'] then
        imgCds.Filter := '     img01 like ''' + s12 + 'A' + s47 + '%'' or img01 like ''' + s12 + 'C' + s47 + '%'' or img01 like ''' + s12 + '6' + s47 + '%'''
      else if s3 in ['E', 'H'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'E' + s47 + '%'' or img01 like ''' + s12 + 'H' + s47 + '%'''
      else if s3 in ['F', 'I'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'F' + s47 + '%'' or img01 like ''' + s12 + 'I' + s47 + '%'''
      else if s3 in ['G', 'J'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'G' + s47 + '%'' or img01 like ''' + s12 + 'J' + s47 + '%'''
      else if s3 in ['O', 'S'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'O' + s47 + '%'' or img01 like ''' + s12 + 'S' + s47 + '%'''
      else if s3 in ['P', 'T'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'P' + s47 + '%'' or img01 like ''' + s12 + 'T' + s47 + '%'''
      else if s3 in ['Q', 'U'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'Q' + s47 + '%'' or img01 like ''' + s12 + 'U' + s47 + '%'''
      else if s3 in ['R', 'V'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'R' + s47 + '%'' or img01 like ''' + s12 + 'V' + s47 + '%'''
      else if s3 in ['B', 'N'] then
        imgCds.Filter := '      img01 like ''' + s12 + 'B' + s47 + '%'' or img01 like ''' + s12 + 'N' + s47 + '%'''
      else
        imgCds.Filter := ' img01 like  ''' + copy(cds.fieldbyname('materialno').AsString, 1, 10) + '%''';
      if not imgCds.IsEmpty then
      begin
        imgCds.First;
        while not imgCds.Eof do
        begin
          CDS.edit;
          CDS.FieldByName('ppqty').AsCurrency := imgCds.fieldbyname('img10').AsCurrency;
          imgCds.Next;
        end;
      end;
      Cds.next;
    end;
  finally
    CDS.First;
    CDS.EnableControls;
  end
end;

procedure TFrmMPST070.btn_mpst070CalcPPClick(Sender: TObject);
begin
  GetPPQty
end;

end.

