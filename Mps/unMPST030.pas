{*******************************************************}
{                                                       }
{                unMPST030                              }
{                Author: kaikai                         }
{                Create date: 2016/02/18                }
{                Description: 交期拆分作業              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI060, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, Menus, DB, ImgList, ExtCtrls, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, unGridDesign,
  DateUtils, StrUtils, Math;

type
  TspFlag = (spNotFinish, spFinish, spAll, spNull); //未拆交期、未拆交期、全部、無資料
  ToverFlag = (oNotFinish, oFinish, oAll);          //未結案、已結案、全部

type
  TFrmMPST030 = class(TFrmSTDI060)
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    btn_mpst030A: TBitBtn;
    N280: TMenuItem;
    PnlRight: TPanel;
    btn_mpst030E: TBitBtn;
    btn_mpst030F: TBitBtn;
    btn_mpst030B: TBitBtn;
    btn_mpst030G: TBitBtn;
    btn_mpst030C: TBitBtn;
    btn_mpst030D: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    btn_mpst030H: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh3ColWidthsChanged(Sender: TObject);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CDS2BeforeDelete(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure btn_mpst030AClick(Sender: TObject);
    procedure btn_mpst030CClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_mpst030BClick(Sender: TObject);
    procedure btn_mpst030DClick(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N280Click(Sender: TObject);
    procedure btn_mpst030EClick(Sender: TObject);
    procedure btn_mpst030FClick(Sender: TObject);
    procedure btn_mpst030GClick(Sender: TObject);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

  private
    l_chgQty:Double;
    l_spFlag:TspFlag;
    l_overFlag:ToverFlag;
    l_GridDesign3: TGridDesign;
    l_StrIndex,l_StrIndexDesc:string;
    l_sql2,l_sql3:string;
    l_bool2:Boolean;
    l_list2,l_list3:TStrings;
    procedure SetBtnEnabled(bool:Boolean);
    procedure RefreshDS3;
    function GetNextDitem:Integer;
    function GetTotQty:Double;
    procedure CDS2cdateChange(Sender: TField);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS1(strFilter:string); override;
    procedure RefreshDS2; override;
  end;

var
  FrmMPST030: TFrmMPST030;

implementation

uses unGlobal, unCommon, unFind, unMPST030_Query, unMPST030_Nosplit,
  unMPST040_units, unMPST030_Onesplit;
var
  cdate:TField;

{$R *.dfm}

procedure TFrmMPST030.SetBtnEnabled(bool:Boolean);
var
  i:Integer;
begin
  for i:=0 to PnlRight.ControlCount -1 do
    if PnlRight.Controls[i] is TBitBtn then
       (PnlRight.Controls[i] as TBitBtn).Enabled:=bool;
end;

procedure TFrmMPST030.RefreshDS1(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if SameText(strFilter, g_cFilterNothing) then
     tmpSQL:='exec dbo.proc_MPST030_1 0,0,'+IntToStr(Ord(spNull))+','+
                                            IntToStr(Ord(oNotFinish))
  else
     tmpSQL:='exec dbo.proc_MPST030_1 '+Quotedstr(g_UInfo^.BU)+','+
                                        Quotedstr(strFilter)+','+
                                        IntToStr(Ord(l_spFlag))+','+
                                        IntToStr(Ord(l_overFlag));
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;

  if CDS.Active and CDS.IsEmpty then
     RefreshDS3;
end;

procedure TFrmMPST030.RefreshDS2;
var
  tmpSQL:string;
begin
  inherited;
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='Select * From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Orderno='+Quotedstr(CDS.FieldByName('oea01').AsString)
         +' And Orderitem='+IntToStr(CDS.FieldByName('oeb03').AsInteger);
  if l_bool2 then
     tmpSQL:=tmpSQL+' ';         
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmMPST030.RefreshDS3;
var
  tmpSQL:string;
begin
  inherited;
  if not Assigned(l_list3) then
     Exit;

  if Pos(LeftStr(CDS.FieldByName('oeb04').AsString,1),'ET')>0 then
     tmpSQL:='1'
  else
     tmpSQL:='0';
  tmpSQL:='exec dbo.proc_MPST030_3 '+Quotedstr(g_UInfo^.BU)+','+
                                     Quotedstr(CDS.FieldByName('oea01').AsString)+','+
                                     IntToStr(CDS.FieldByName('oeb03').AsInteger)+',0,'+tmpSQL;
  l_list3.Insert(0,tmpSQL);
end;

procedure TFrmMPST030.FormCreate(Sender: TObject);
begin
  p_SysId:='MPS';
  p_MainTableName:='MPST030';
  p_DetailTableName:='MPS200';
  p_GridDesignAns1:=True;
  p_GridDesignAns2:=True;
  p_EditFlag:=detailEdit;
  l_spFlag:=spNull;
  l_overFlag:=oNotFinish;

  inherited;

  N280.Caption:=CheckLang('全部刪除');
  TabSheet3.Caption:=CheckLang('訂單資料');
  TabSheet2.Caption:=CheckLang('拆分達交日期');
  TabSheet3.Caption:=CheckLang('排程資料');
  SetGrdCaption(DBGridEh3, 'MPS010');
  l_list2:=TStringList.Create;
  l_list3:=TStringList.Create;
  l_GridDesign3:=TGridDesign.Create(DBGridEh3, g_MInfo^.ProcId+'_3');
  Timer1.Enabled:=True;
  Timer2.Enabled:=True;
  PCL2.ActivePageIndex:=0;
end;

procedure TFrmMPST030.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  Timer2.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  FreeAndNil(l_list3);
  FreeAndNil(l_GridDesign3);
  CDS3.Active:=False;
  DBGridEh3.Free;
end;

function TFrmMPST030.GetNextDitem:Integer;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select ISNULL(Max(Ditem),0)+1 From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU);
  if not QueryOneCR(tmpSQL, Data) then
     Result:=-1
  else
     Result:=StrToIntDef(VarToStr(Data),1);
end;

function TFrmMPST030.GetTotQty:Double;
var
  Data:OleVariant;
  tmpSQL:string;
begin
  Result:=0;
  tmpSQL:='Select IsNull(Sum(qty),0) qty From MPS200'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Orderno='+Quotedstr(CDS.FieldByName('oea01').AsString)
         +' And Orderitem='+IntToStr(CDS.FieldByName('oeb03').AsInteger)
         +' And IsNull(GarbageFlag,0)=0';
  if QueryOneCR(tmpSQL, Data) then
     Result:=StrToFloatDef(VarToStr(Data),0);
end;

procedure TFrmMPST030.CDS2BeforeInsert(DataSet: TDataSet);
var
  tmpSQL:string;
  isExist:Boolean;
begin
  inherited;
 { tmpSQL:=LeftStr(CDS.FieldByName('oea01').AsString,2);
  if SameText(tmpSQL,'P1') or SameText(tmpSQL,'P2') then
  begin
    ShowMsg('兩角訂單不可拆分,請更改原始訂單將自動更新!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end; }

  if not SameText(CDS.FieldByName('oeaconf').AsString,'Y') then
  begin
    ShowMsg('此訂單未確認,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;

  if SameText(CDS.FieldByName('oeb70').AsString,'Y') then
  begin
    ShowMsg('此訂單已結案,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;

  if CDS.FieldByName('oeb12').AsFloat=CDS.FieldByName('oeb24').AsFloat then
  begin
    ShowMsg('此訂單已出貨完畢,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;

  tmpSQL:='Select 1 From MPS250 Where Bu=''ITEQDG'''
         +' And Custno='+Quotedstr(CDS.FieldByName('oea04').AsString)
         +' And Isnull(IsDG,0)=0';
  if not QueryExists(tmpSQL, isExist) then
     Abort;
  if SameText(g_UInfo^.BU,'ITEQDG') and isExist then
  begin
    ShowMsg('廣州下單客戶,不可拆分!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end
  else if SameText(g_UInfo^.BU,'ITEQGZ') and (not isExist) then
  begin
    ShowMsg('東莞下單客戶,不可拆分!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;

  l_chgQty:=0;
end;

procedure TFrmMPST030.CDS2BeforeDelete(DataSet: TDataSet);
var
  str:String;
begin
  Abort; //不給刪除20191231

  inherited;

  str:=LeftStr(CDS.FieldByName('oea01').AsString,2);
  if SameText(str,'P1') or SameText(str,'P2') then
  begin
    ShowMsg('兩角訂單不可刪除,請更改原始訂單將自動更新!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end else
  if SameText(CDS.FieldByName('oeb70').AsString,'Y') then
  begin
    ShowMsg('此訂單已結案,不可刪除!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end else
  if DataSet.FieldByName('Flag').AsInteger<>0 then
  begin
    ShowMsg('這筆拆分資料已產生出貨表,不可刪除!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;
end;

procedure TFrmMPST030.CDS2BeforeEdit(DataSet: TDataSet);
//var
//  str:String;
begin
  inherited;
{  str:=LeftStr(CDS.FieldByName('oea01').AsString,2);
  if SameText(str,'P1') or SameText(str,'P2') then
  begin
    ShowMsg('兩角訂單不可拆分,請更改原始訂單將自動更新!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end else }
  if SameText(CDS.FieldByName('oeb70').AsString,'Y') then
  begin
    ShowMsg('此訂單已結案,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end else
  if CDS.FieldByName('oeb12').AsFloat=CDS.FieldByName('oeb24').AsFloat then
  begin
    ShowMsg('此訂單已出貨完畢,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end else
  if DataSet.FieldByName('Flag').AsInteger<>0 then
  begin
    ShowMsg('這筆拆分資料已產生出貨表,不可更改!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Abort;
  end;

  l_chgQty:=CDS2.FieldByName('Qty').AsFloat;
end;

procedure TFrmMPST030.CDS2BeforePost(DataSet: TDataSet);
var
  tmpStr1,tmpStr2:string;
  tmpBool:Boolean;
begin
  tmpStr1:=DataSet.FieldByName('Materialno').AsString;
  if Length(Trim(tmpStr1))=0 then
  begin
    ShowMsg('請輸入料號!', 48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Materialno');
    Abort;
  end;
  
  tmpStr1:=Copy(tmpStr1,1,Length(tmpStr1)-1);
  tmpStr2:=CDS.FieldByName('oeb04').AsString;
  tmpStr2:=Copy(tmpStr2,1,Length(tmpStr2)-1);
  if tmpStr1<>tmpStr2 then
  begin
    ShowMsg('料號錯誤,請確認!', 48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Materialno');
    Abort;
  end;

  if DataSet.FieldByName('Adate').IsNull then
  begin
    tmpStr1:=DBGridEh2.FieldColumns['Adate'].Title.Caption;
    ShowMsg('請輸入[%s]!', 48, tmpStr1);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Adate');
    Abort;
  end;

  if DataSet.FieldByName('CDate').IsNull then
  begin
    if DataSet.FieldByName('ADate').AsDateTime<Date then
    begin
      tmpStr1:=DBGridEh2.FieldColumns['ADate'].Title.Caption;
      ShowMsg('[%s]不能小於當天日期!', 48, tmpStr1);
      if DBGridEh2.CanFocus then
         DBGridEh2.SetFocus;
      DBGridEh2.SelectedField:=DataSet.FieldByName('Adate');
      Abort;
    end;
  end else
  begin
    if DataSet.FieldByName('CDate').AsDateTime<Date then
    begin
      tmpStr1:=DBGridEh2.FieldColumns['CDate'].Title.Caption;
      ShowMsg('[%s]不能小於當天日期!', 48, tmpStr1);
      if DBGridEh2.CanFocus then
         DBGridEh2.SetFocus;
      DBGridEh2.SelectedField:=DataSet.FieldByName('Cdate');
      Abort;
    end;
  end;



  if DataSet.State in [dsEdit] then
  if {(DataSet.FieldByName('ADate').OldValue<>null) and}
  (DataSet.FieldByName('ADate').OldValue<>DataSet.FieldByName('ADate').NewValue) then  //不可修改,只有一次機會
  begin
    tmpStr1:=DBGridEh2.FieldColumns['ADate'].Title.Caption;
    ShowMsg('[%s]不可異動!', 48, tmpStr1);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Adate');
    Abort;
  end;
  {
  if (not DataSet.FieldByName('Cdate').IsNull) and
     (DataSet.FieldByName('Adate').AsDateTime>
      DataSet.FieldByName('Cdate').AsDateTime) then
  begin
    tmpStr1:=DBGridEh2.FieldColumns['Adate'].Title.Caption;
    tmpStr2:=DBGridEh2.FieldColumns['Cdate'].Title.Caption;
    ShowMsg('%s', 48, tmpStr2+CheckLang('不能小於')+tmpStr1);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Adate');
    Abort;
  end;
  }
  if DataSet.FieldByName('Qty').AsFloat<=0 then
  begin
    tmpStr1:=DBGridEh2.FieldColumns['Qty'].Title.Caption;
    ShowMsg('[%s]不能為0或小於0', 48, tmpStr1);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Qty');
    Abort;
  end;

  if (DataSet.FieldByName('Materialno').AsString<>CDS.FieldByName('oeb04').AsString) and
     (DataSet.FieldByName('Orderitem').AsInteger=CDS.FieldByName('oeb03').AsInteger) then
  if ShowMsg('料號不同,項次相同,確定嗎?', 33)=IdCancel then
     Abort;

  if DataSet.FieldByName('Cdate').IsNull then
     tmpBool:=CheckConfirm(DataSet.FieldByName('Adate').AsDateTime)
  else
     tmpBool:=CheckConfirm(DataSet.FieldByName('Cdate').AsDateTime);
  if tmpBool then
  begin
    ShowMsg('此日期出貨表已確認,不可拆分為此日期!', 48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('Adate');
    Abort;
  end;

  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('Ditem').AsInteger:=GetNextDitem;
    if DataSet.FieldByName('Ditem').AsInteger<1 then
    begin
      ShowMsg('取流水號失敗,請聯絡系統管理員!', 48);
      Abort;
    end;
  end;

  inherited;
end;

procedure TFrmMPST030.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS3;
end;

procedure TFrmMPST030.DBGridEh3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign3) then
     l_GridDesign3.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPST030.DBGridEh3ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if p_GridDesignAns1 and Assigned(l_GridDesign3) then
     l_GridDesign3.ColWidthChange;
end;

procedure TFrmMPST030.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPST030_Query) then
     FrmMPST030_Query:=TFrmMPST030_Query.Create(Application);
  if FrmMPST030_Query.ShowModal=mrok then
  begin
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
    Application.ProcessMessages;
    l_spFlag:=TspFlag(FrmMPST030_Query.RadioGroup4.ItemIndex);     //注意順序
    l_overFlag:=ToverFlag(FrmMPST030_Query.RadioGroup2.ItemIndex); //注意順序
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS1(FrmMPST030_Query.l_QueryStr);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPST030.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift=[ssCtrl]) and (Key=70) then               //Ctrl+F 查找
  begin
    if not Assigned(FrmFind) then
       FrmFind:=TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS:=Self.CDS;
      g_Columns:=Self.DBGridEh1.Columns;
      g_DefFname:=Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname:='oea02,oeb03,oeb12,oeb15,oeb24';
    end;
    FrmFind.ShowModal;
    Key:=0; //DBGridEh自帶的查找
  end
  else if (Shift=[ssCtrl]) and (Key=83) and (CDS2.State in [dsInsert,dsEdit]) then
    CDS2.Post  //Ctrl+S 保存
  else
    inherited;
end;

procedure TFrmMPST030.btn_insertClick(Sender: TObject);
begin
  inherited;
  PCL2.ActivePageIndex:=0;
end;

//自動拆分15天內所有兩角訂單,拆分後生管達交日期為客戶預定交貨日期
procedure TFrmMPST030.btn_mpst030AClick(Sender: TObject);
var
  IsLock:Boolean;
  tmpSQL:string;
begin
  inherited;
  if ShowMsg('自動拆分15天內所有兩角訂單,'+#13#10
            +'確定執行嗎?', 33)=IDCancel then
     Exit;

  if not CheckLockProc(IsLock) then
     Exit;

  if IsLock then
  begin
    ShowMsg('拆分作業被別的使用者暫時鎖定,請重試!', 48);
    Exit;
  end;

  if not LockProc then
     Exit;

  g_StatusBar.Panels[0].Text:=CheckLang('正在拆分...');
  Application.ProcessMessages;
  try
    tmpSQL:='exec dbo.proc_MPST030_4 '+Quotedstr(g_UInfo^.BU);
    if PostBySQL(tmpSQL) then
       ShowMsg('拆分完畢!', 64);
  finally
    g_StatusBar.Panels[0].Text:='';
    UnLockProc;
  end;
end;

//自動拆分只有一筆排程的所有訂單,拆分後生管達交日期為排程上的生管達交日期
procedure TFrmMPST030.btn_mpst030BClick(Sender: TObject);
var
  IsLock:Boolean;
  tmpSQL,procName:string;
  Data:OleVariant;
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmMPST030_Nosplit) then
     FrmMPST030_Nosplit:=TFrmMPST030_Nosplit.Create(Application);
  if FrmMPST030_Nosplit.ShowModal=mrok then
  begin
    if not CheckLockProc(IsLock) then
       Exit;

    if IsLock then
    begin
      ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
      Exit;
    end;

    if not LockProc then
       Exit;

    g_StatusBar.Panels[0].Text:=CheckLang('正在拆分...');
    Application.ProcessMessages;
    if Sender= btn_mpst030H then
      procName:='dbo.proc_MPST030_5 '
    else
      procName:='dbo.proc_MPST030_2 ';
    try
      tmpSQL:='exec '+procName+Quotedstr(g_UInfo^.BU)+','+
                                         Quotedstr(g_UInfo^.UserId)+','+
                                         Quotedstr(FrmMPST030_Nosplit.l_QueryStr);

      if QueryOneCR(tmpSQL, Data) then
      begin
        tmpSQL:=VarToStr(Data);
        ShowMsg('%s', StrToInt(LeftStr(tmpSQL,2)), Copy(tmpSQL,3,100));
      end;
    finally
      g_StatusBar.Panels[0].Text:='';
      UnLockProc;
    end;
  end;
  SetBtnEnabled(True);
end;

//查詢指定訂單日期范圍所有未拆分交期的資料
procedure TFrmMPST030.btn_mpst030CClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  if not Assigned(FrmMPST030_Nosplit) then
     FrmMPST030_Nosplit:=TFrmMPST030_Nosplit.Create(Application);
  if FrmMPST030_Nosplit.ShowModal=mrok then
  begin
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
    Application.ProcessMessages;
    l_spFlag:=spNotFinish;
    l_overFlag:=oAll;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS1(FrmMPST030_Nosplit.l_QueryStr);
    g_StatusBar.Panels[0].Text:='';
  end;
  SetBtnEnabled(True);
end;

procedure TFrmMPST030.btn_mpst030DClick(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active then
     str:=CDS.FieldByName('oeb04').AsString;
  GetQueryStock(str, false);
end;

procedure TFrmMPST030.btn_mpst030EClick(Sender: TObject);
var
  tmpDitem,tmpOrderitem:Integer;
  tmpSQL,tmpBu,tmpOrderno:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料!',48);
    Exit;
  end;

  tmpSQL:=CDS.FieldByName('oea04').AsString+'-'+
          CDS.FieldByName('oea01').AsString+'-'+
          CDS.FieldByName('oeb03').AsString;

  if ShowMsg('確定更新['+tmpSQL+']兩角訂單的拆分資料嗎?',33)=IdCancel then
     Exit;

  if SameText(g_UInfo^.BU,'ITEQDG') then
     tmpBu:='ITEQGZ'
  else if SameText(g_UInfo^.BU,'ITEQGZ') then
     tmpBu:='ITEQDG'
  else
     Exit;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢兩角訂單號碼...');
    Application.ProcessMessages;
    tmpSQL:='select oao01,oao03 from '+tmpBu+'.oao_file where oao06='+Quotedstr(tmpSQL);
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;

    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('未找到兩角訂單!',48);
      Exit;
    end;

    tmpOrderno:=tmpCDS1.Fields[0].AsString;
    tmpOrderitem:=tmpCDS1.Fields[1].AsInteger;
    
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢拆分資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from mps200 where bu='+Quotedstr(tmpBu)
           +' and orderno='+Quotedstr(tmpOrderno)
           +' and orderitem='+IntToStr(tmpOrderitem)
           +' And IsNull(GarbageFlag,0)=0';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('兩角訂單無拆分資料,請執行[兩角訂單拆分]自動回寫更新!',48);
      Exit;
    end;

    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      if tmpCDS1.FieldByName('Flag').AsInteger=1 then
      begin
        if ShowMsg('兩角訂單已排出貨,確定繼續更新嗎?',33)=IdCancel then
           Exit;
        Break;
      end;
      tmpCDS1.Next;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在更新資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select isnull(max(ditem),0)+1 as ditem from mps200 where bu='+Quotedstr(tmpBu);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;
    tmpDitem:=StrToIntDef(VarToStr(Data),1);

    while not tmpCDS1.IsEmpty do
      tmpCDS1.Delete;

    tmpCDS2.Data:=CDS2.Data;
    tmpCDS2.First;
    while not tmpCDS2.Eof do
    begin
      tmpCDS1.Append;
      tmpCDS1.FieldByName('Bu').AsString:=tmpBu;
      tmpCDS1.FieldByName('Ditem').AsInteger:=tmpDitem;
      tmpCDS1.FieldByName('Orderno').AsString:=tmpOrderno;
      tmpCDS1.FieldByName('Orderitem').AsInteger:=tmpOrderitem;
      tmpCDS1.FieldByName('Materialno').AsString:=tmpCDS2.FieldByName('Materialno').AsString;
      if not tmpCDS2.FieldByName('Adate').IsNull then
      begin
        if Pos(CDS.FieldByName('oea04').AsString, 'AC114,AC365,AC388,AC434,AC625,ACB00,AC117,ACC19')>0 then
           tmpCDS1.FieldByName('Adate').AsDateTime:=tmpCDS2.FieldByName('Adate').AsDateTime
        else
           tmpCDS1.FieldByName('Adate').AsDateTime:=tmpCDS2.FieldByName('Adate').AsDateTime-1;
      end;
      if not tmpCDS2.FieldByName('Cdate').IsNull then
         tmpCDS1.FieldByName('Cdate').AsDateTime:=tmpCDS2.FieldByName('Cdate').AsDateTime;
      tmpCDS1.FieldByName('Qty').AsFloat:=tmpCDS2.FieldByName('Qty').AsFloat;
      tmpCDS1.FieldByName('Remark1').AsString:=tmpCDS2.FieldByName('Remark1').AsString;
      tmpCDS1.FieldByName('Remark2').AsString:=tmpCDS2.FieldByName('Remark2').AsString;
      tmpCDS1.FieldByName('Flag').AsInteger:=0;
      tmpCDS1.FieldByName('GarbageFlag').AsBoolean:=False;
      tmpCDS1.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      tmpCDS1.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS1.Post;

      Inc(tmpDitem);
      tmpCDS2.Next;
    end;
    if CDSPost(tmpCDS1, 'MPS200') then
       ShowMsg('更新完畢!',64);
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPST030.btn_mpst030FClick(Sender: TObject);
var
  tmpSQL,tmpBu,tmpSrcno:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) then
     tmpSrcno:=CDS.FieldByName('oea01').AsString
  else
     tmpSrcno:='';

  if not InputQuery(CheckLang('請輸入訂單號碼'), 'orderno', tmpSrcno) then
     Exit;
  if tmpSrcno='' then
     Exit;

  if (Length(tmpSrcno)<>10) or (Pos('-',tmpSrcno)<>4) then
  begin
    ShowMsg('訂單號碼錯誤!',48);
    Exit;
  end;

  if SameText(g_UInfo^.BU,'ITEQDG') then
     tmpBu:='ITEQGZ'
  else if SameText(g_UInfo^.BU,'ITEQGZ') then
     tmpBu:='ITEQDG'
  else
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢兩角訂單號碼...');
    Application.ProcessMessages;
    tmpSQL:='select oao01,oao03 from '+tmpBu+'.oao_file where oao06'
           +' in(select concat(concat(concat(concat(oea04,''-''),oeb01),''-''),oeb03) as no'
           +' from '+g_UInfo^.BU+'.oea_file,'+g_UInfo^.BU+'.oeb_file'
           +' where oea01=oeb01 and oea01='+Quotedstr(tmpSrcno)+')';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('未找到兩角訂單!',48);
      Exit;
    end;

    tmpSQL:='';
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL:=tmpSQL+' or (orderno='+Quotedstr(tmpCDS.Fields[0].AsString)
                    +' and orderitem='+IntToStr(tmpCDS.Fields[1].AsInteger)+')';
      tmpCDS.Next;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢拆分資料...');
    Application.ProcessMessages;
    Delete(tmpSQL,1, 4);
    Data:=null;
    tmpSQL:='select * from mps200 where bu='+Quotedstr(tmpBu)
           +' and ('+tmpSQL+') and isnull(garbageflag,0)=0';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('兩角訂單無拆分資料,請執行[兩角訂單拆分]自動回寫更新!',48);
      Exit;
    end;

    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      if tmpCDS.FieldByName('Flag').AsInteger=1 then
      begin
        if ShowMsg('存在已排出貨的兩角訂單,確定繼續更新嗎?',33)=IdCancel then
           Exit;
        Break;
      end;
      tmpCDS.Next;
    end;

    while not tmpCDS.IsEmpty do
      tmpCDS.Delete;

    g_StatusBar.Panels[0].Text:=CheckLang('正在更新資料...');
    Application.ProcessMessages;
    if CDSPost(tmpCDS, 'MPS200') then
    begin
      tmpSQL:='exec dbo.proc_MPST030_4 '+Quotedstr(tmpBu);
      if PostBySQL(tmpSQL) then
         ShowMsg('更新完畢!', 64);
    end;   
  finally
    FreeAndNil(tmpCDS);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPST030.btn_mpst030GClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  FrmMPST030_Onesplit:=TFrmMPST030_Onesplit.Create(Application);
  if not CDS.IsEmpty then
  begin
    FrmMPST030_Onesplit.Edit43.Text:=CDS.FieldByName('oea01').AsString;
    FrmMPST030_Onesplit.Edit44.Text:=CDS.FieldByName('oeb03').AsString;
    FrmMPST030_Onesplit.Edit45.Text:=CDS.FieldByName('qty').AsString;
    FrmMPST030_Onesplit.Label6.Caption:=CheckLang('料號:'+CDS.FieldByName('oeb04').AsString+',訂單數量:'+CDS.FieldByName('oeb12').AsString+',已交數量:'+CDS.FieldByName('oeb24').AsString+',未交數量:'+CDS.FieldByName('qty').AsString);
  end;
  try
    FrmMPST030_Onesplit.ShowModal;
    if FrmMPST030_Onesplit.l_ret then
    begin
      l_bool2:=True;
      try
        RefreshDS2;
      finally
        l_bool2:=False;
      end;
    end;
  finally
    FreeAndNil(FrmMPST030_Onesplit);
    SetBtnEnabled(True);
  end;
end;

procedure TFrmMPST030.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName,'spflag') and
     SameText(CDS.FieldByName('spflag').AsString,'N') then
     Background:=clRed;
end;

procedure TFrmMPST030.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST030.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('Orderno').AsString:=CDS.FieldByName('oea01').AsString;
    FieldByName('Orderitem').AsInteger:=CDS.FieldByName('oeb03').AsInteger;
    FieldByName('Materialno').AsString:=CDS.FieldByName('oeb04').AsString;
    if not CDS3.IsEmpty then
       FieldByName('Adate').AsDateTime:=DateOf(CDS3.FieldByName('Adate_new').AsDateTime);
    FieldByName('Qty').AsFloat:=RoundTo(CDS.FieldByName('oeb12').AsFloat-Self.GetTotQty, -3);
    FieldByName('Flag').AsInteger:=0;
  end;
end;

procedure TFrmMPST030.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N202.Visible:=False;
  N280.Visible:=False;
  {不給刪除20191231
  N280.Visible:=N201.Visible;

  if N280.Visible then
  begin
    if CDS2.State in [dsInsert,dsEdit] then
       N280.Enabled:=False
    else
       N280.Enabled:=not CDS2.IsEmpty;
  end; }
end;

procedure TFrmMPST030.N280Click(Sender: TObject);
var
  tmpCDS:TClientDataSet;
begin
  inherited;
  if SameText(CDS.FieldByName('oeb70').AsString,'Y') then
  begin
    ShowMsg('此訂單已結案,不可刪除!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS2.Data;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='Flag=0';
    tmpCDS.Filtered:=True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('全部已排出貨,不可刪除!',48);
      if DBGridEh2.CanFocus then
         DBGridEh2.SetFocus;
      Exit;
    end;

    if ShowMsg('只刪除未排出貨的單據'+#13#10+'刪除後不可恢複,確定全部刪除嗎?',33)=IDCancel then
    begin
      if DBGridEh2.CanFocus then
         DBGridEh2.SetFocus;
      Exit;
    end;

    while not tmpCDS.IsEmpty do
      tmpCDS.Delete;
    if CDSPost(tmpCDS, 'MPS200') then
    begin
      l_bool2:=True;
      try
        RefreshDS2;
      finally
        l_bool2:=False;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST030.DBGridEh2CellClick(Column: TColumnEh);
var
  DSNE1,DSNE2,DSNE3,DSNE4:TDataSetNotifyEvent;
begin
  inherited;
  if (not SameText(Column.FieldName,'GarbageFlag')) or (not g_MInfo^.R_edit) or
     (not CDS2.Active) or CDS2.IsEmpty or (CDS2.State in [dsInsert,dsEdit]) then
     Exit;

  if CDS2.FieldByName('flag').AsInteger<>1 then
  begin
    ShowMsg('已排出貨表方可無效',48);
    Exit;
  end;

  with CDS2 do
  begin
    DSNE1:=BeforeEdit;
    DSNE2:=AfterEdit;
    DSNE3:=BeforePost;
    DSNE4:=AfterPost;
    BeforeEdit:=nil;
    AfterEdit:=nil;
    BeforePost:=nil;
    AfterPost:=nil;
    try
      Edit;
      FieldByName('GarbageFlag').AsBoolean:=not FieldByName('GarbageFlag').AsBoolean;
      Post;
      if not CDSPost(CDS2, p_DetailTableName) then
         CancelUpdates;
    finally
      BeforeEdit:=DSNE1;
      AfterEdit:=DSNE2;
      BeforePost:=DSNE3;
      AfterPost:=DSNE4;
    end;
  end;
end;

procedure TFrmMPST030.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer1.Enabled:=False;
  try
    if l_List2.Count=0 then
       Exit;

    while l_List2.Count>1 do
      l_List2.Delete(l_List2.Count-1);

    tmpSQL:=l_List2.Strings[0];
    if tmpSQL=l_SQL2 then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
    cdate:=CDS2.FindField('cdate');
    cdate.OnChange:=CDS2cdateChange;
  finally
    Timer1.Enabled:=True;
  end;
end;

procedure TFrmMPST030.Timer2Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer2.Enabled:=False;
  try
    if l_List3.Count=0 then
       Exit;

    while l_List3.Count>1 do
      l_List3.Delete(l_List3.Count-1);

    tmpSQL:=l_List3.Strings[0];
    if (not l_bool2) and (tmpSQL=l_SQL3) then Exit;
    l_SQL3:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS3.Data:=Data;
  finally
    Timer2.Enabled:=True;
  end;
end;

procedure TFrmMPST030.CDS2cdateChange(Sender: TField);
var s:string;
  ddate:TDateTime;
begin
  if Assigned(cdate) then
  begin
    if CDS2.fieldbyname('cdate').Value<>0 then
      ddate:=CDS2.fieldbyname('cdate').Value
    else
      ddate:=CDS2.fieldbyname('adate').Value;
    s:='update %s.sfb_file set ta_sfb15=to_date(%s,''YYYYMMDD'')  where sfb22=%s and sfb221=%s';
{(*}s:=Format(s,[CDS2.fieldbyname('bu').AsString,
                 QuotedStr(FormatDateTime('YYYYMMDD', ddate)),
                 QuotedStr(CDS2.fieldbyname('Orderno').AsString),
                 CDS2.fieldbyname('Orderitem').AsString]);     {*)}
//    ShowMsg(s,48);
    if not PostBySQL(s,'ORACLE') then
    begin
      ShowMsg(CheckLang('更新Call貨時間失敗'),48);
    end;
  end;
end;

end.
