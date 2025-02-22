{*******************************************************}
{                                                       }
{                unMPSI010                              }
{                Author: kaikai                         }
{                Create date: 2015/12/20                }
{                Description: 主排程程式                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI030, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, Menus, StdCtrls, Buttons, ExtCtrls, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, Math, unMPST010_SingleBoiler, unMPST010_SingleLine,
  unMPST010_Param, unMPST010_Order, unMPST010_units, unCCLStruct, unMPST010_Wono;

type
  TMachineLine = packed record
    Machine: string;
    SingleLine: TSingleLine;
  end;

const
  l_Color1 = 16772300;  //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPST010 = class(TFrmSTDI030)
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    Edit3: TEdit;
    Label3: TLabel;
    PopupMenu1: TPopupMenu;
    N20: TMenuItem;
    N21: TMenuItem;
    Edit4: TEdit;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    btn_mpst010A: TBitBtn;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    DS3: TDataSource;
    CDS3: TClientDataSet;
    PopupMenu2: TPopupMenu;
    N24: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    N28: TMenuItem;
    N22: TMenuItem;
    N5: TMenuItem;
    N23: TMenuItem;
    N4: TMenuItem;
    N29: TMenuItem;
    RG1: TRadioGroup;
    RG2: TRadioGroup;
    PnlRight: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    btn_mpst010B: TBitBtn;
    btn_mpst010C: TBitBtn;
    btn_mpst010D: TBitBtn;
    btn_mpst010E: TBitBtn;
    btn_mpst010F: TBitBtn;
    btn_mpst010G: TBitBtn;
    btn_mpst010H: TBitBtn;
    btn_mpst010I: TBitBtn;
    btn_mpst010J: TBitBtn;
    btn_mpst010K: TBitBtn;
    btn_mpst010L: TBitBtn;
    btn_mpst010M: TBitBtn;
    btn_mpst010N: TBitBtn;
    btn_mpst010O: TBitBtn;
    btn_mpst010P: TBitBtn;
    btn_mpst010Q: TBitBtn;
    btn_mpst010R: TBitBtn;
    btn_mpst010S: TBitBtn;
    btn_mpst010T: TBitBtn;
    N30: TMenuItem;
    btn_mpst010U: TToolButton;
    btnCheckMaterReview: TButton;
    N1: TMenuItem;
    N6: TMenuItem;
    btn_mpst010V: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RG1Click(Sender: TObject);
    procedure RG2Click(Sender: TObject);
    procedure btn_mpst010AClick(Sender: TObject);
    procedure btn_mpst010CClick(Sender: TObject);
    procedure btn_mpst010DClick(Sender: TObject);
    procedure btn_mpst010EClick(Sender: TObject);
    procedure btn_mpst010FClick(Sender: TObject);
    procedure btn_mpst010GClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure DBGridEh3GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State:
      TGridDrawState);
    procedure DBGridEh1DblClick(Sender: TObject);
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
    procedure N24Click(Sender: TObject);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure DBGridEh3DblClick(Sender: TObject);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_mpst010HClick(Sender: TObject);
    procedure CDS3AfterScroll(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure DBGridEh3TitleClick(Column: TColumnEh);
    procedure N28Click(Sender: TObject);
    procedure btn_mpst010IClick(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure btn_mpst010JClick(Sender: TObject);
    procedure btn_mpst010KClick(Sender: TObject);
    procedure btn_mpst010LClick(Sender: TObject);
    procedure btn_mpst010MClick(Sender: TObject);
    procedure btn_mpst010NClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure btn_mpst010OClick(Sender: TObject);
    procedure btn_mpst010PClick(Sender: TObject);
    procedure btn_mpst010QClick(Sender: TObject);
    procedure btn_mpst010RClick(Sender: TObject);
    procedure btn_mpst010SClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_mpst010BClick(Sender: TObject);
    procedure btn_mpst010TClick(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_mpst010UClick(Sender: TObject);
    procedure btnCheckMaterReviewClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure CheckMater();
    procedure DBGridEh3Columns4UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText, Handled:
      Boolean);
    procedure Button1Click(Sender: TObject);
    procedure btn_mpst010VClick(Sender: TObject);
  private
    l_Ans, l_LockAns, l_OptLockAns: Boolean;
    l_Param: TMPST010_Param;
    l_Order: TMPST010_Order;
    l_ArrMachineLine: array of TMachineLine;
    l_SelList, l_ErrList, l_ColorList, l_ErrorIdList: TStrings; //選擇,錯誤提示,顏色,異常重排單號
    l_StrIndex: string;
    l_StrIndexDesc: string;
    l_CDS670: TClientDataSet;
    l_CheckMater_RecNo: TStrings; // 記錄混號的行號 lxj
    l_MPST010_Wono: TMPST010_Wono;
    function IsCuston(code:string):boolean;
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetMachineLine;
    procedure ClrearMachineLine;
    function GetSingleLine(machine: string; books: Double): TSingleLine;
    procedure SetOldEmptyBoiler;
    procedure SetPData(P: POrderRec);
    procedure GetPData;
    procedure SetEdit3;
    procedure RefreshColor;
    procedure SetNewRecordData(DataSet: TDataSet);
    procedure GetSumQty;
    procedure CheckLock;
    procedure SetBtnEnabled(bool: Boolean);
    { Private declarations }
  public
    function GetTotBooks(DataSet: TCLientDataSet): Double;
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST010: TFrmMPST010;

implementation

uses
  unGlobal, unCommon, unMPST010_SqtyEdit, unMPST010_BoilerEdit, unMPST010_ShowErrList, unMPST010_PlanChange,
  unMPST010_StealnoEdit, unMPST010_EmptyFlagAdd, unFind, unMPST010_EmptyFlagEdit, unMPST010_Orderno2Edit,
  unMPST010_CalcBooks, unMPST070_bom, unMPST010_UpdateCo, unMPST010_UpdateRemainOrdqty, unMPST010_GetCore,
  unMPST010_PnoSum, unMPST010_UpdateWono, unMPST020_WonoList;

const
  l_JumpHint = '光標跳轉到調整的鍋次';
  l_Rework = '重工';

var
  l_QueryString:string;

{$R *.dfm}
//排程鎖定判斷
procedure TFrmMPST010.CheckLock;
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



//過濾數據
procedure TFrmMPST010.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
var str:string;
begin
  l_SelList.Clear;
  with xCDS do
  begin
    Filtered := False;
    if xRG.Items[xRG.ItemIndex]=checklang(l_rework) then
    begin     {(*}
      str := l_QueryString+' and machine<>''L6'' and Premark2 not like ''%51F-%'' and ' +
                    'Premark3 not like ''%51F-%'' and bu=''ITEQDG'' and '+
                    'materialno like ''_____________3___'' and '+
                    'isnull(wono,'''')<> '''' and '+
                    'isnull(Materialno1,'''')= '''' ';
                        {*)}
      RefreshDS(str);
    end
    else if xRG.ItemIndex = -1 then
      Filter := 'machine=''@'''
    else
      Filter := 'errorflag<>1 and machine=' + Quotedstr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

//清除所有流水線
procedure TFrmMPST010.ClrearMachineLine;
var
  i: Integer;
begin
  for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
    FreeAndNil(l_ArrMachineLine[i].SingleLine);
  l_ArrMachineLine := nil;
end;

//讀取所有流水線
procedure TFrmMPST010.SetMachineLine;
var
  i: Integer;
  tmpList: TStrings;
begin
  ClrearMachineLine;
  tmpList := TStringList.Create;
  try
    tmpList.DelimitedText := g_MachineCCL;
    SetLength(l_ArrMachineLine, tmpList.Count);
    for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
      l_ArrMachineLine[i].Machine := tmpList[i];
  finally
    FreeAndNil(tmpList);
  end;
end;

//取出流水線
function TFrmMPST010.GetSingleLine(machine: string; books: Double): TSingleLine;
var
  i: Integer;
  tmpList: TStrings;
begin
  Result := nil;
  for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
  begin
    if SameText(l_ArrMachineLine[i].machine, machine) then
    begin
      if Assigned(l_ArrMachineLine[i].SingleLine) then
        Result := l_ArrMachineLine[i].SingleLine
      else
      begin
        tmpList := TStringList.Create;
        try
          l_Param.GetAllStealno(machine, tmpList);
          l_ArrMachineLine[i].SingleLine := TSingleLine.Create(machine, l_Param.GetCustnoAdCode(machine), books, tmpList);
          Result := l_ArrMachineLine[i].SingleLine;
        finally
          FreeAndNil(tmpList);
        end;
      end;
      Break;
    end;
  end;
end;

//取出舊數據(未滿鍋)
procedure TFrmMPST010.SetOldEmptyBoiler;
var
  tmpMachine: string;
  tmpBooks: Double;
  tmpCDS: TClientDataSet;
  SingleLine: TSingleLine;
  SingleBoiler: TSingleBoiler;
begin
  tmpMachine := '@@@@';
  SingleLine := nil;
  tmpCDS := TClientDataSet.Create(nil);
  try
    with tmpCDS do
    begin
      Data := l_Param.OldEmptyData;
      First;
      while not Eof do
      begin
        if tmpMachine <> FieldByName('machine').AsString then
        begin
          tmpMachine := FieldByName('machine').AsString;
          tmpBooks := l_Param.GetBooks(tmpMachine);
          SingleLine := GetSingleLine(tmpMachine, tmpBooks);
        end;

        if Assigned(SingleLine) then
        begin
          SingleBoiler := TSingleBoiler.Create(FieldByName('sdate').AsDateTime, FieldByName('boiler_qty').AsInteger,
            FieldByName('stealno').AsString);
          SingleBoiler.CurrentBoiler := FieldByName('CurrentBoiler').AsInteger;
          SingleBoiler.OldJitem := FieldByName('Jitem').AsInteger;
          SingleBoiler.Lock := FieldByName('Lock').AsBoolean;
          SingleBoiler.AdCode := FieldByName('AdCode').AsInteger;
          SingleBoiler.RemainBooks := FieldByName('RemainBooks').AsFloat;
          SingleBoiler.OZ := StringReplace(FieldByName('OZ').AsString, g_OZ, '', []);
          SingleBoiler.Premark := FieldByName('Premark').AsString;
          if SingleBoiler.Lock and (Length(SingleBoiler.Premark) > 0) then
            SingleBoiler.Premark_custno := l_Param.ReplaceCustnoGroup(SingleBoiler.Premark);
          SingleLine.List.Add(SingleBoiler);
          SingleLine.EmptyCount := SingleLine.List.Count;
        end;
        Next;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//寫入數據
procedure TFrmMPST010.SetPData(P: POrderRec);
begin
  with CDS3 do
  begin
    P^.orderdate := FieldByName('orderdate').Value;
    P^.orderno := FieldByName('orderno').Value;
    P^.orderitem := FieldByName('orderitem').Value;
    P^.custno := FieldByName('custno').Value;
    P^.custno2 := FieldByName('custno2').Value;
    P^.custom := FieldByName('custom').Value;
    P^.custom2 := FieldByName('custom2').Value;
    P^.edate := FieldByName('edate').Value;
    P^.adate := FieldByName('adate').Value;
    P^.materialno := FieldByName('materialno').Value;
    P^.materialno1 := FieldByName('materialno1').Value;
    P^.pnlsize1 := FieldByName('pnlsize1').Value;
    P^.pnlsize2 := FieldByName('pnlsize2').Value;
    P^.orderqty := FieldByName('orderqty').Value;
    P^.sqty := FieldByName('sqty').AsInteger;
    P^.book_qty := 0;
    P^.errorid := FieldByName('errorid').Value;
    P^.wono := FieldByName('wono').Value;
    P^.orderno2 := FieldByName('orderno2').Value;
    P^.orderitem2 := FieldByName('orderitem2').Value;
    P^.srcflag := FieldByName('srcflag').Value;
    P^.oz := FieldByName('oz').Value;
    P^.supplier := FieldByName('supplier').Value;
    P^.premark := FieldByName('premark').Value;
    P^.premark2 := FieldByName('premark2').Value;
    P^.premark3 := FieldByName('premark3').Value;

    // 2022.01.07 longxinjue 加入加投數量與樣品數量
    P^.regulateQty := FieldByName('regulateQty').Value;
    P^.sampleQty := FieldByName('sampleQty').Value;

    P^.pnlnum := FieldByName('pnlnum').Value;
    if Length(Trim(FieldByName('machine1').AsString)) > 0 then    //3种指定
    begin                                                       //1.機台
      P^.machine1 := UpperCase(FieldByName('machine1').Value);    //2.機台+日期
      try                                                       //3.機台+日期+鍋次
        StrToInt(VarToStr(FieldByName('boiler1').Value));
        P^.boiler1 := FieldByName('boiler1').Value;
      except
        P^.boiler1 := null;
      end;

      try
        StrToDate(VarToStr(FieldByName('sdate1').Value));
        P^.sdate1 := FieldByName('sdate1').Value;
      except
        P^.sdate1 := null;
        P^.boiler1 := null; //日期不對，則鍋次無效
      end;
    end
    else
    begin
      P^.sdate1 := null;
      P^.machine1 := null;
      P^.boiler1 := null;
    end;
  end
end;

//添加排程結果
procedure TFrmMPST010.GetPData;
var
  i, j, k, tmpJitem: Integer;
  SingleLine: TSingleLine;
  SingleBoiler: TSingleBoiler;
  P: POrderRec;
  tmpCustno: string;
label
  mark1;

  procedure AddDefData;
  begin
    CDS2.FieldByName('Jitem').AsInteger := tmpJitem;                //預排結果排序用
    CDS2.FieldByName('Citem').AsInteger := SingleBoiler.OldJitem;   //暫存舊數據Jitem
    CDS2.FieldByName('Machine').AsString := l_ArrMachineLine[i].machine;
    CDS2.FieldByName('Sdate').AsDateTime := SingleBoiler.Wdate;
    CDS2.FieldByName('Stealno').AsString := SingleBoiler.Stealno;
    CDS2.FieldByName('Premark').AsString := SingleBoiler.Premark;
    CDS2.FieldByName('CurrentBoiler').AsInteger := SingleBoiler.CurrentBoiler;
    CDS2.FieldByName('AdCode').Value := SingleBoiler.AdCode;
    CDS2.FieldByName('RemainBooks').Value := SingleBoiler.RemainBooks;
    CDS2.FieldByName('Lock').AsBoolean := SingleBoiler.Lock;
    Inc(tmpJitem);
  end;

begin
  tmpJitem := 1;
  l_ErrorIdList.Clear;
  CDS2.EmptyDataSet;

  for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
  begin
    if not Assigned(l_ArrMachineLine[i].SingleLine) then
      Continue;

    SingleLine := TSingleLine(l_ArrMachineLine[i].SingleLine);
    for j := 0 to SingleLine.List.Count - 1 do
    begin
      SingleBoiler := TSingleBoiler(SingleLine.List[j]);
      //預排結果只顯示有訂單資料,SingleBoiler.List.Count=0時為空鍋
      if SingleBoiler.List.Count > 0 then
        for k := 0 to SingleBoiler.List.Count - 1 do
        begin
          P := POrderRec(SingleBoiler.List[k]);
            //          if (Pos(P^.custno, 'AC084,AC111,AC310,AC707') > 0) and (Pos(Copy(P^.materialno, 9, 6), '370490,410490') > 0) and (Copy(P^.materialno, 3, 4) <= '0030') then
//          begin
//            if i < 4 then
//            begin
//              goto mark1;
//            end;
//          end;
          CDS2.Append;
          AddDefData;
          CDS2.FieldByName('OrderDate').Value := P^.orderdate;
          CDS2.FieldByName('OrderNo').Value := P^.orderno;
          CDS2.FieldByName('OrderItem').Value := P^.orderitem;
          CDS2.FieldByName('Custno').Value := P^.custno;
          CDS2.FieldByName('Custno2').Value := P^.custno2;
          CDS2.FieldByName('Custom').Value := P^.custom;
          CDS2.FieldByName('Custom2').Value := P^.custom2;
          CDS2.FieldByName('Edate').Value := P^.edate;
          if VarIsNull(P^.adate) then
          begin
            if SameText(g_UInfo^.BU, 'ITEQJX') then
            begin
              if Length(VarToStr(P^.materialno1)) > 0 then
                CDS2.FieldByName('Adate').AsDateTime := SingleBoiler.Wdate + 4
              else
                CDS2.FieldByName('Adate').AsDateTime := SingleBoiler.Wdate + 3;
            end
            else
            begin
              if Length(VarToStr(P^.materialno1)) > 0 then
                CDS2.FieldByName('Adate').AsDateTime := SingleBoiler.Wdate + 3
              else if (Pos(UpperCase(CDS2.FieldByName('Machine').AsString), g_MachineCCL_GZ) > 0) and (SingleBoiler.CurrentBoiler
                >= SingleBoiler.TotalBoiler - 3) then
                CDS2.FieldByName('Adate').AsDateTime := SingleBoiler.Wdate + 3
              else
                CDS2.FieldByName('Adate').AsDateTime := SingleBoiler.Wdate + 2;
            end;
          end
          else
            CDS2.FieldByName('Adate').AsDateTime := P^.adate;
          CDS2.FieldByName('Materialno').Value := P^.materialno;
          CDS2.FieldByName('Materialno1').Value := P^.materialno1;
          CDS2.FieldByName('Pnlsize1').Value := P^.pnlsize1;
          CDS2.FieldByName('Pnlsize2').Value := P^.pnlsize2;
          CDS2.FieldByName('Orderqty').Value := P^.orderqty;
          CDS2.FieldByName('Sqty').Value := P^.sqty;
          CDS2.FieldByName('RemainBooks').Value := 0;
          CDS2.FieldByName('Book_qty').Value := P^.book_qty;
          CDS2.FieldByName('sdate1').Value := P^.sdate1;
          CDS2.FieldByName('machine1').Value := P^.machine1;
          CDS2.FieldByName('boiler1').Value := P^.boiler1;
          if LeftStr(VarToStr(P^.errorid), 1) = 'A' then
            CDS2.FieldByName('ErrorId').Value := P^.errorid;
          CDS2.FieldByName('Wono').Value := P^.wono;
          CDS2.FieldByName('OrderNo2').Value := P^.orderno2;
          CDS2.FieldByName('OrderItem2').Value := P^.orderitem2;
          CDS2.FieldByName('SrcFlag').Value := P^.srcflag;
          CDS2.FieldByName('OZ').Value := P^.oz;
          CDS2.FieldByName('Supplier').Value := P^.supplier;

          if SameText(g_UInfo^.BU, 'ITEQJX') then
            tmpCustno := P^.custom  //江西custom是二階客戶編號
          else if P^.custno='N024' then
            tmpCustno := P^.custno2
          else
            tmpCustno := P^.custno;

          

//          if VarIsNull(P^.premark) then
//            CDS2.FieldByName('Premark').AsString := CDS2.FieldByName('Premark').AsString + l_Param.GetCustRemark(tmpCustno,
//              P^.materialno)
//          else
//            CDS2.FieldByName('Premark').AsString := CDS2.FieldByName('Premark').AsString + l_Param.GetCustRemark(tmpCustno,
//              P^.materialno) + ' ' + VarToStr(P^.premark);

          CDS2.FieldByName('Premark').AsString := CDS2.FieldByName('Premark').AsString  + trim(' ' + VarToStr(P^.premark));
          if trim(CDS2.FieldByName('Premark').AsString)='' then
            CDS2.FieldByName('Premark').AsString:=CDS2.FieldByName('Premark').AsString + l_Param.GetCustRemark(tmpCustno,
              P^.materialno);


          CDS2.FieldByName('Premark2').Value := P^.premark2;
          CDS2.FieldByName('Premark3').Value := P^.premark3;

        // 2022.01.07 longxinjue 加入加投數量與樣品數量
          CDS2.FieldByName('regulateQty').Value := P^.regulateQty;
          CDS2.FieldByName('sampleQty').Value := P^.sampleQty;

          CDS2.Post;
          if Length(VarToStr(P^.errorid)) > 0 then
            l_ErrorIdList.Add(P^.errorid);

        //未滿一鍋
          if (k = SingleBoiler.List.Count - 1) and (SingleBoiler.RemainBooks > 0) then
          begin
            CDS2.Append;
            AddDefData;
            CDS2.FieldByName('OZ').Value := g_OZ + SingleBoiler.OZ;
            CDS2.FieldByName('EmptyFlag').AsInteger := 1;
            CDS2.Post;
          end;
        end;
    end;
mark1:


  end;
end;

procedure TFrmMPST010.SetEdit3;
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

procedure TFrmMPST010.RefreshColor;
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

procedure TFrmMPST010.SetNewRecordData(DataSet: TDataSet);
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

procedure TFrmMPST010.GetSumQty;
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
  if ((PCL.ActivePageIndex = 0) and CDS.IsEmpty) or ((PCL.ActivePageIndex = 1) and CDS2.IsEmpty) or (PCL.ActivePageIndex
    = 2) then
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
      Filter := 'Machine=' + Quotedstr(tmpMachine) + ' And Sdate=' + Quotedstr(DateToStr(tmpSdate)) +
        ' And (ErrorFlag=0 or ErrorFlag is null)' + ' And (Sqty is not null) And Sqty<>0';
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

function TFrmMPST010.GetTotBooks(DataSet: TCLientDataSet): Double;
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

procedure TFrmMPST010.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And IsNull(Case_ans2,0)=0 ' +
    strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST010.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS010';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  RG2.Tag := 1;
  l_CDS670 := TClientDataSet.Create(Self);
  btn_mpst010U.Left := ToolButton2.Left;

  inherited;
  GetMPSMachine;
  CDS.IndexFieldNames := 'Machine;Jitem;spy;OZ;Materialno;Simuver;Citem';
  CDS2.IndexFieldNames := 'Machine;Jitem';
  RG1.Items.DelimitedText := g_MachineCCL;
  RG1.Items.Add(checklang(l_rework));
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
  btn_mpst010U.Visible := SameText(g_UInfo^.BU, 'ITEQJX') and g_MInfo^.R_edit;
  if not btn_mpst010U.Visible then
    ToolButton2.Visible := False;

  TabSheet1.Caption := CheckLang('已確認排程');
  TabSheet2.Caption := CheckLang('預排結果');
  TabSheet3.Caption := CheckLang('待排訂單');
  Label3.Caption := CheckLang('生產日期/鍋次');
  Label4.Caption := CheckLang('數量');
  btn_mpst010N.Hint := CheckLang(l_JumpHint);
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

  l_Param := TMPST010_Param.Create;
  l_Param.GetParameData_Init;
  SetMachineLine;

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
//  btn_mpst010V.Visible:=false;
end;

procedure TFrmMPST010.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if l_OptLockAns then
    UnLockProc;

  inherited;

  ClrearMachineLine;
  FreeAndNil(l_CDS670);
  FreeAndNil(l_SelList);
  FreeAndNil(l_ErrList);
  FreeAndNil(l_ColorList);
  FreeAndNil(l_ErrorIdList);
  if Assigned(l_Order) then
    FreeAndNil(l_Order);
  FreeAndNil(l_Param);

  CDS2.Active := False;
  CDS3.Active := False;
  DBGridEh2.Free;
  DBGridEh3.Free;

  FreeAndNil(l_CheckMater_RecNo);
end;

procedure TFrmMPST010.btn_queryClick(Sender: TObject);
var
  QueryString: string;
  IsLock: Boolean;
begin
//  inherited;
  if not GetQueryString(p_TableName, QueryString) then
    Exit;

  RefreshDS(QueryString);
  RefreshData(RG1, CDS);
  PCL.ActivePageIndex := 0;
  RefreshColor;
  DBGridEh1.Repaint;

  if not l_OptLockAns then
    if CheckLockProc(IsLock) then
      l_LockAns := IsLock;
end;

procedure TFrmMPST010.btn_firstClick(Sender: TObject);
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

procedure TFrmMPST010.btn_priorClick(Sender: TObject);
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

procedure TFrmMPST010.btn_nextClick(Sender: TObject);
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

procedure TFrmMPST010.btn_lastClick(Sender: TObject);
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

procedure TFrmMPST010.btn_quitClick(Sender: TObject);
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

procedure TFrmMPST010.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST010.RG2Click(Sender: TObject);
begin
  inherited;
  if (not CDS2.Active) or (RG2.Tag = 1) then
    Exit;
  RefreshData(RG2, CDS2);
  RefreshColor;
  DBGridEh2.Repaint;
end;

procedure TFrmMPST010.btn_mpst010AClick(Sender: TObject);
var
  Data1: OleVariant;
begin
  inherited;
  if not Assigned(l_Order) then
    l_Order := TMPST010_Order.Create;
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

procedure TFrmMPST010.btn_mpst010BClick(Sender: TObject);
var
  Data1: OleVariant;
begin
  inherited;
  if not Assigned(l_Order) then
    l_Order := TMPST010_Order.Create;
  Data1 := l_Order.GetLessData;
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

procedure TFrmMPST010.btn_mpst010CClick(Sender: TObject);
var
  i: Integer;
  tmpBooks, tmpBookQty: Double;
  tmpStr: string;
  tmpAdCode: Integer;
  SMRec: TSplitMaterialno;
  P: POrderRec;
  StealnoList: TStrings;
  SingleLine: TSingleLine;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
  begin
    ShowMsg('待排訂單無資料!', 48);
    Exit;
  end;

  if ShowMsg('確定要進行排程嗎?', 33) = IDCancel then
    Exit;

  if CDS2.State in [dsInsert, dsEdit] then
    CDS2.Post;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  //鎖定作業
  if not l_OptLockAns then
  begin
    CheckLock;

    l_OptLockAns := LockProc;
    if not l_OptLockAns then
      Exit;

    l_LockAns := l_OptLockAns;
  end;

  l_Ans := True;
  l_ErrList.Clear;
  l_Param.GetParameData_Exec;
  SetMachineLine;
  SetOldEmptyBoiler;

  New(P);
  SingleLine := nil;
  StealnoList := TStringLIst.Create;
  g_ProgressBar.Visible := True;
  CDS2.DisableControls;
  CDS3.DisableControls;
  try
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := CDS3.RecordCount * 2;
    for i := 1 to 2 do
    begin
      CDS3.First;
      while not CDS3.Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        tmpStr := Trim(CDS3.FieldByName('machine1').AsString);                       {(*}
//        if (Pos(CDS3.FieldByName('Custno').AsString, 'AC084,AC111,AC310,AC707') > 0) and
//           (Pos(Copy(CDS3.FieldByName('Materialno').AsString, 9, 6), '370490,410490,373493,413493') > 0) and
//           (Pos(CDS3.FieldByName('machine1').AsString, 'L5,L6') = 0) and
//           (Copy(CDS3.FieldByName('Materialno').AsString, 3, 4) <= '0030') then {*)}
//        begin
//          ShowMsg('客戶AC084,AC111,AC310,AC707,370490,410490,3條及以下必須指定排在L5~L6線', 48, MyStringReplace(DBGridEh3.FieldColumns
//            ['sdate1'].Title.Caption));
//          Abort;
//        end;

        if i = 1 then              //排2次,先排指定的(存在多余的while,待修正)
        begin
          if tmpStr = '' then
          begin
            CDS3.Next;
            Continue;
          end;
        end
        else
        begin
          if tmpStr <> '' then
          begin
            CDS3.Next;
            Continue;
          end;
        end;

        SetPData(P);
        tmpStr := l_Param.GetMachineFilter(SMRec, P);
        if Length(tmpStr) = 0 then
        begin
          l_ErrList.Add(SMRec.Err + '找不到對應的鋼板設定');
          CDS3.Next;
          Continue;
        end;

        with l_Param.CDS_ChanNeng do
        begin
          Filtered := False;
          Filter := '(' + tmpStr + ') and boiler_qty>0';
          Filtered := True;
          if IsEmpty then
          begin
            l_ErrList.Add(SMRec.Err + tmpStr + '產能不足');
            CDS3.Next;
            Continue;
          end;

          IndexFieldNames := 'wdate;machine';
          tmpStr := '';
          tmpBookQty := 0;
          tmpAdCode := 0;
          while not Eof do
          begin
            if not SameText(tmpStr, FieldByName('machine').AsString) then
            begin
              tmpStr := FieldByName('machine').AsString;
              tmpBooks := l_Param.GetBooks(tmpStr);
              if tmpBooks <= 0 then
              begin
                l_ErrList.Add(SMRec.Err + tmpStr + '(' + FloatToStr(tmpBooks) + '本)Book數設定錯誤');
                Break;
              end;

              tmpBookQty := l_Param.GetBookQty(SMRec, P, tmpStr);
              if tmpBookQty <= 0 then
              begin
                l_ErrList.Add(SMRec.Err + '机台/膠系/銅厚/條數(' + tmpStr + '/' + SMRec.M2 + '/' + SMRec.M7_8 + '/' +
                  FloatToStr(SMRec.M3_6) + ')未設定每本張數或設定錯誤');
                Break;
              end;

              tmpAdCode := l_Param.GetAdCode(SMRec, P, tmpStr);
              if tmpAdCode = 0 then
              begin
                l_ErrList.Add(SMRec.Err + '机台/膠系/條數(' + tmpStr + '/' + SMRec.M2 + '/' + FloatToStr(SMRec.M3_6) +
                  ')找不到合鍋規范設定');
                Break;
              end;

              SingleLine := GetSingleLine(tmpStr, tmpBooks);
              if SingleLine = nil then
              begin
                l_ErrList.Add(SMRec.Err + tmpStr + '機台線別錯誤,請聯絡管理員');
                Break;
              end;
            end;

            l_Param.GetStealnoList(SMRec, FieldByName('machine').AsString, P, StealnoList);
            if StealnoList.Count = 0 then
            begin
              l_ErrList.Add(SMRec.Err + '机台/經/緯/條數(' + FieldByName('machine').AsString + '/' + SMRec.M9_11 + '/' +
                SMRec.M12_14 + '/' + FloatToStr(SMRec.M3_6) + ')鋼板設定錯誤');
              Break;
            end;

            P^.sdate := FieldByName('wdate').Value;
            P^.book_qty := tmpBookQty;

            SingleLine.TotalBoiler := FieldByName('boiler_qty1').AsInteger;
            SingleLine.RemainBoiler := FieldByName('boiler_qty').AsInteger;
            SingleLine.AddOrderObj(tmpAdCode, StealnoList, P, l_ErrList);

            Edit;
            FieldByName('boiler_qty').AsInteger := SingleLine.RemainBoiler;
            Post;
            if P^.sqty <= 0 then
              Break
            else if (not VarIsNull(P^.sdate1)) and (P^.sdate1 < P^.sdate) then
            begin
              l_ErrList.Add(SMRec.Err + '數量:' + FloatToStr(P^.sqty) + ',不滿足指定生產日期、機台、鍋次');
              Break;
            end
            else if SingleLine.RemainBoiler = 0 then  //boiler_qty>0 Filter已過濾,自動Next
            begin
              if IsEmpty then
                l_ErrList.Add(SMRec.Err + '數量:' + FloatToStr(P^.sqty) + ',產能不足');
              Continue;
            end;

            Next;
          end; //end while
        end;   //end  with

        CDS3.Next;
      end;
    end;

    GetPData;

  finally
    l_Ans := False;
    Dispose(P);
    FreeAndNil(StealnoList);
    g_ProgressBar.Visible := False;
    CDS2.EnableControls;
    CDS3.EnableControls;
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
    FrmShowErrList.Memo1.Hint := CheckLang('訂單單號/項次/料號/未排原因');
    FrmShowErrList.Memo1.Lines.Assign(l_ErrList);
    FrmShowErrList.ShowModal;
  end
  else
    ShowMsg('排程完畢!', 64);
end;

procedure TFrmMPST010.btn_mpst010DClick(Sender: TObject);
const
  gzOrder = '廣州訂單';
const
  gzBigSize = '大尺寸';
const
  gzBigStealno = '大鋼板';
var
  i, j, tmpCitem, tmpJitem,tmpSize1,tmpSize2: Integer;
  tmpCDS1, tmpCDS2: TClientDataSet;
  post_bo, isTW,ordSize: Boolean;
  tmpSimuver, tmpSQL, tmpStr1, tmpStr2, tmpMachine, tmpPno, tmpSizes: string;
  Data: OleVariant;
  SingleLine: TSingleLine;
  SingleBoiler: TSingleBoiler;
begin
  inherited;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := CDS2.Data;
    if (not tmpCDS1.Active) or tmpCDS1.IsEmpty then
    begin
      ShowMsg('預排結果無資料,不可確認!', 48);
      Exit;
    end;

    if ShowMsg('確認排程嗎?', 33) = IDCancel then
      Exit;

    tmpCitem := 0;
    tmpStr1 := '';
    tmpStr2 := '';
    for i := 0 to l_ErrorIdList.Count - 1 do
    begin
      if LeftStr(l_ErrorIdList.Strings[i], 1) = 'A' then         //主排程重排資料
      begin
        tmpSQL := Copy(l_ErrorIdList.Strings[i], 2, 100);
        if Pos(tmpSQL, tmpStr1) = 0 then
          tmpStr1 := tmpStr1 + ' or Simuver+''@''+Cast(Citem as varchar(20))=' + Quotedstr(tmpSQL);
      end
      else if LeftStr(l_ErrorIdList.Strings[i], 1) = 'B' then    //副排程資料
      begin
        tmpSQL := Copy(l_ErrorIdList.Strings[i], 2, 100);
        if Pos(tmpSQL, tmpStr2) = 0 then
        begin
          tmpStr2 := tmpStr2 + ' or ' + g_mps012pk + '=' + Quotedstr(tmpSQL);
          Inc(tmpCitem);
        end;
      end;
    end;

    //判斷副排程資料是否還存在
    if tmpCitem > 0 then
    begin
      Delete(tmpStr2, 1, 4);
      Data := null;
      tmpSQL := 'Select Count(*) cnt From MPS012 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (' + tmpStr2 +
        ') and isnull(notvisible,0)=1 and isnull(srcflag,0)>0';
      if not QueryOneCR(tmpSQL, Data) then
        Exit;
      if StrToInt(VarToStr(Data)) <> tmpCitem then
      begin
        ShowMsg('副排程資料不存在,請重新查詢[副排程訂單]', 48);
        Exit;
      end;
    end;

    //1.刪除已重排的異常單據
    //2.處理空行
    Data := null;
    tmpSQL := 'Select * From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (EmptyFlag=1' + tmpStr1 + ')';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS1.Data := Data;

    //1.
    with tmpCDS1 do
    begin
      Filtered := False;
      Filter := 'EmptyFlag<>1';
      Filtered := True;
      while not IsEmpty do
        Delete;
      Filtered := False;
      Filter := '';
    end;

    //2.更新舊空行
    for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
    begin
      if not Assigned(l_ArrMachineLine[i].SingleLine) then
        Continue;
      SingleLine := TSingleLine(l_ArrMachineLine[i].SingleLine);
      for j := 0 to SingleLine.EmptyCount - 1 do
      begin
        SingleBoiler := TSingleBoiler(SingleLine.List[j]);
        if SingleBoiler.List.Count > 0 then
        begin
          if not tmpCDS1.Locate('Jitem', SingleBoiler.OldJitem, []) then
          begin
            ShowMsg('資料不同步,請重新排程!', 48);
            Exit;
          end;

          if SingleBoiler.RemainBooks <= 0 then
            tmpCDS1.Delete
          else
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('AdCode').Value := SingleBoiler.AdCode;
            tmpCDS1.FieldByName('RemainBooks').Value := SingleBoiler.RemainBooks;
            tmpCDS1.FieldByName('OZ').Value := g_OZ + SingleBoiler.OZ;
            tmpCDS1.FieldByName('Muser').AsString := g_UInfo^.UserId;
            tmpCDS1.FieldByName('Mdate').AsDateTime := Now;
            tmpCDS1.Post;
          end;
        end;
      end;
    end;

    isTW := SameText(g_UInfo^.BU, 'ITEQXP');
    if isTW then
    begin
      //膠系中文名稱
      Data := null;
      tmpSQL := 'Select M2,Cname From MPS310 Where Bu=' + Quotedstr(g_UInfo^.BU);
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS2.Data := Data;
    end;

    //取流水號
    tmpCitem := 1;
    tmpSimuver := GetSno(g_MInfo^.ProcId);
    if tmpSimuver = '' then
      Exit;

    //取最大的項次
    tmpJitem := 0;
    tmpSQL := 'Select Max(Jitem) Jitem From mps010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU);
    if QueryOneCR(tmpSQL, Data) then
    begin
      if VarToStr(Data) <> '' then
        tmpJitem := StrToIntDef(VarToStr(Data), 0);
    end;

    l_Ans := True;
    tmpStr1 := '@';
    g_ProgressBar.Visible := True;
    CDS2.Filtered := False;
    CDS2.DisableControls;
    try
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := CDS2.RecordCount;
      CDS2.First;
      while not CDS2.Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        tmpPno := CDS2.FieldByName('Materialno').AsString;
        tmpMachine := CDS2.FieldByName('Machine').AsString + '@' + DateToStr(CDS2.FieldByName('Sdate').AsDateTime) + '@'
          + IntToStr(CDS2.FieldByName('CurrentBoiler').AsInteger);

        //是舊空鍋資料則跳過這筆(上面已更新)
        if (CDS2.FieldByName('Citem').AsInteger > 0) and (CDS2.FieldByName('EmptyFlag').AsInteger = 1) then
        begin
          tmpStr1 := tmpMachine;
          CDS2.Next;
          Continue;
        end;

        //新增的鍋次,檢查是否有跳過的日期
        if (tmpStr1 <> tmpMachine) and (CDS2.FieldByName('Citem').AsInteger < 0) then
        begin
          for i := Low(l_ArrMachineLine) to High(l_ArrMachineLine) do
          begin
            if SameText(l_ArrMachineLine[i].machine, CDS2.FieldByName('Machine').AsString) then
            begin
              if not Assigned(l_ArrMachineLine[i].SingleLine) then
                Break;
              SingleLine := TSingleLine(l_ArrMachineLine[i].SingleLine);
              for j := SingleLine.EmptyCount to SingleLine.List.Count - 1 do
              begin
                SingleBoiler := TSingleBoiler(SingleLine.List[j]);
                if (SingleBoiler.Wdate = CDS2.FieldByName('Sdate').AsDateTime) and (SingleBoiler.CurrentBoiler = CDS2.FieldByName
                  ('CurrentBoiler').AsInteger) then
                  Break;

                if (SingleBoiler.OldJitem < 0) and (SingleBoiler.List.Count = 0) and (not tmpCDS1.Locate('Sdate;Machine;CurrentBoiler;EmptyFlag',
                  VarArrayOf([SingleBoiler.Wdate, l_ArrMachineLine[i].machine, SingleBoiler.CurrentBoiler, 1]), []))
                  then
                begin
                  Inc(tmpJitem);

                  tmpCDS1.Append;
                  SetNewRecordData(tmpCDS1);
                  tmpCDS1.FieldByName('Simuver').AsString := tmpSimuver;
                  tmpCDS1.FieldByName('Citem').AsInteger := tmpCitem;
                  tmpCDS1.FieldByName('Jitem').AsInteger := tmpJitem;
                  tmpCDS1.FieldByName('Machine').AsString := l_ArrMachineLine[i].machine;
                  tmpCDS1.FieldByName('Sdate').AsDateTime := SingleBoiler.Wdate;
                  tmpCDS1.FieldByName('Stealno').AsString := SingleBoiler.Stealno;
                  tmpCDS1.FieldByName('Premark').AsString := SingleBoiler.Premark;
                  tmpCDS1.FieldByName('CurrentBoiler').AsInteger := SingleBoiler.CurrentBoiler;
                  tmpCDS1.FieldByName('AdCode').Value := SingleBoiler.AdCode;
                  tmpCDS1.FieldByName('RemainBooks').Value := SingleBoiler.RemainBooks;
                  tmpCDS1.FieldByName('Lock').AsBoolean := SingleBoiler.Lock;
                  tmpCDS1.FieldByName('EmptyFlag').AsInteger := 1;
                  tmpCDS1.FieldByName('OZ').Value := g_OZ + SingleBoiler.OZ;
                  tmpCDS1.Post;

                  Inc(tmpCitem);
                end;
              end;

              Break;
            end;
          end;
        end;

        //添加預排結果
        tmpCDS1.Append;
        for i := 0 to tmpCDS1.FieldCount - 1 do
          if not CDS2.FieldByName(tmpCDS1.Fields[i].FieldName).IsNull then
            tmpCDS1.Fields[i].Value := CDS2.FieldByName(tmpCDS1.Fields[i].FieldName).Value;
        tmpCDS1.FieldByName('Bu').AsString := g_UInfo^.BU;
        tmpCDS1.FieldByName('Adate_new').Value := CDS2.FieldByName('Adate').Value;
        tmpCDS1.FieldByName('Simuver').AsString := tmpSimuver;
        if CDS2.FieldByName('Citem').AsInteger > 0 then
          tmpCDS1.FieldByName('Jitem').AsInteger := CDS2.FieldByName('Citem').AsInteger
        else
        begin
          if tmpStr1 <> tmpMachine then
            Inc(tmpJitem);
          tmpCDS1.FieldByName('Jitem').AsInteger := tmpJitem;
        end;
        tmpCDS1.FieldByName('Citem').AsInteger := tmpCitem;

         //台灣版欄位,台灣未上線,暫時停用這幾個欄位
        if isTW and (Length(tmpPno) > 0) then
        begin
          if tmpCDS2.Locate('M2', Copy(tmpPno, 2, 1), []) then
            tmpCDS1.FieldByName('Adhesive').AsString := tmpCDS2.FieldByName('Cname').AsString
          else
            tmpCDS1.FieldByName('Adhesive').AsString := Copy(tmpPno, 2, 1);
          tmpCDS1.FieldByName('Thickness').AsString := '0.' + Copy(tmpPno, 3, 4);
          tmpCDS1.FieldByName('Copper').AsString := Copy(tmpPno, 7, 2);
          tmpCDS1.FieldByName('Sizes').AsString := FloatToStr(StrToFloat(Copy(tmpPno, 9, 2) + '.' + Copy(tmpPno, 11, 1)))
            + '*' + FloatToStr(StrToFloat(Copy(tmpPno, 12, 2) + '.' + Copy(tmpPno, 14, 1)));
        end;

        //備註廣州訂單
        if (tmpCDS1.FieldByName('SrcFlag').AsInteger in [2, 4, 6]) and (Pos(tmpCDS1.FieldByName('Custno').AsString,
          'AC121,AC526,AC820,ACA97,AC625') > 0) then
        begin
          if Length(Trim(tmpCDS1.FieldByName('Premark').AsString)) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := CheckLang(gzOrder)
          else if Pos(CheckLang(gzOrder), tmpCDS1.FieldByName('Premark').AsString) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := Trim(tmpCDS1.FieldByName('Premark').AsString) + ' ' + CheckLang(gzOrder);
        end;
        if (tmpCDS1.FieldByName('SrcFlag').AsInteger in [6]) and (Pos(tmpCDS1.FieldByName('Custno').AsString, 'N006') >
          0) then
        begin
          if Length(Trim(tmpCDS1.FieldByName('Premark').AsString)) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := CheckLang(gzOrder)
          else if Pos(CheckLang(gzOrder), tmpCDS1.FieldByName('Premark').AsString) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := Trim(tmpCDS1.FieldByName('Premark').AsString) + ' ' + CheckLang(gzOrder);
        end;

        //備註大尺寸
        if (Length(tmpPno) > 0) and (Pos(Copy(tmpPno, 9, 6), '740490,820490,860490') > 0) then
        begin
          if Length(Trim(tmpCDS1.FieldByName('Premark').AsString)) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := CheckLang(gzBigSize)
          else if Pos(CheckLang(gzBigSize), tmpCDS1.FieldByName('Premark').AsString) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := Trim(tmpCDS1.FieldByName('Premark').AsString) + ' ' + CheckLang(gzBigSize);
        end;

        //備註大鋼板
        if SameText(tmpCDS1.FieldByName('Machine').AsString, 'L5') and (Pos(tmpCDS1.FieldByName('Stealno').AsString,
          '38-6,42-6') > 0) then
        begin
          if Length(Trim(tmpCDS1.FieldByName('Premark').AsString)) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := CheckLang(gzBigStealno)
          else if Pos(CheckLang(gzBigStealno), tmpCDS1.FieldByName('Premark').AsString) = 0 then
            tmpCDS1.FieldByName('Premark').AsString := Trim(tmpCDS1.FieldByName('Premark').AsString) + ' ' + CheckLang(gzBigStealno);
        end;

        {
        //備注無錫鋼板
        if (Length(tmpPno)>0) and (Copy(tmpPno,3,4)<='0035') and
           (Pos(Copy(tmpPno,9,6),'370490,373493,410490,413493')>0) and
           (not SameText(tmpCDS1.FieldByName('Custno').AsString,'N013')) then
        begin
          if SameText(Copy(tmpPno,2,1),'U') or SameText(tmpCDS1.FieldByName('Custno').AsString,'AC178') then
          begin
            if Length(tmpCDS1.FieldByName('Premark').AsString)=0 then
               tmpCDS1.FieldByName('Premark').AsString:=CheckLang('無錫鋼板')
           else if Pos(CheckLang('無錫鋼板'),tmpCDS1.FieldByName('Premark').AsString)=0 then
               tmpCDS1.FieldByName('Premark').AsString:=Trim(tmpCDS1.FieldByName('Premark').AsString)+' '+CheckLang('無錫鋼板');
          end;
        end;
        }
        //重慶高密AC434 28mil含以上 370425,370490,410430,410490,430490,550420,410425加大尺寸0.3
        if Length(tmpPno) > 0 then
        begin
          tmpSizes := Copy(tmpPno, 9, 6);
          ordSize:= Copy(tmpPno, 9, 1)='0';
        end
        else
        begin
          tmpSizes := '';
          ordSize:= false;
        end;
        {(*}
        if SameText(tmpCDS1.FieldByName('Custno').AsString, 'AC434') and
           (Pos(tmpSizes, '370425,370490,410430,410490,430490,550420,410425,370430') > 0) and
           (Copy(tmpPno, 3, 4) >= '0280') then          {*)}
        begin
          if tmpSizes = '370425' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373428' + RightStr(tmpPno, 3)
          else if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410430' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413433' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3)
          else if tmpSizes = '430490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '433493' + RightStr(tmpPno, 3)
          else if tmpSizes = '550420' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '553423' + RightStr(tmpPno, 3)
          else if tmpSizes = '410425' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413428' + RightStr(tmpPno, 3)
          else if tmpSizes = '370430' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373433' + RightStr(tmpPno, 3);
        end;

        if SameText(tmpCDS1.FieldByName('Custno').AsString, 'ACD04') and (Pos(tmpSizes, '370490,410490') > 0) and (Copy(tmpPno,
          3, 4) <= '0030') then          {*)}
        begin
          if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3);
        end;

        //深南AC111 80mil含以上 370490,410490,430490加大尺寸0.3
        if (SameText(tmpCDS1.FieldByName('Custno').AsString, 'AC111') or SameText(tmpCDS1.FieldByName('Custno2').AsString, 'AC111')) and
          (Copy(tmpPno, 3, 4) >= '0800') then
        begin
          if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3)
          else if tmpSizes = '430490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '433493' + RightStr(tmpPno, 3);
        end;
//
//        //深南AC111 87mil含以上
//        if SameText(tmpCDS1.FieldByName('Custno').AsString, 'AC111') and (Copy(tmpPno, 3, 4) >= '0870') then
//        begin
//          if (tmpSize1 mod 10 = 0) and (tmpSize2 mod 10 =0) then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + inttostr(tmpSize1 * 1000+ tmpsize2) + RightStr(tmpPno, 3)
//        end;

        //深南AC111 IT180A 2mil 370490,410490,430490加大尺寸0.3
        if SameText(tmpCDS1.FieldByName('Custno').AsString, 'AC111') and (Pos(tmpSizes, '370490,410490,430490') > 0) and
          (Copy(tmpPno, 3, 4) = '0020') and (Copy(tmpPno, 2, 1) = 'F') then
        begin
          if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3)
              //          else if tmpSizes = '430490' then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '433493' + RightStr(tmpPno, 3);
        end;

        //HDI(尾碼Nn) 3mil含以下 1oz含以下 370490,410490加大尺寸0.3
//        if SameText(RightStr(tmpPno, 1), 'N') and
//          (Copy(tmpPno, 3, 4) <= '0030') and
//          (Pos(Copy(tmpPno, 7, 2), '11,1H,HH,TT') > 0)
//          and (Pos(tmpSizes, '370490,410490') > 0) then
//        begin
//          if tmpSizes = '370490' then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
//          else if tmpSizes = '410490' then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3);
//        end;
//        if (Copy(tmpPno, 3, 4) <= '0030') and
//          (Pos(Copy(tmpPno, 7, 2), '11,1H,HH,TT') > 0)
//          and (Pos(tmpSizes, '370490,410490') > 0) then
//        begin
//          if tmpSizes = '370490' then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
//          else if tmpSizes = '410490' then
//            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3);
//        end;
        //德麗AC310,深南AC111,全創AC707 3mil含以下 370490,410490,430490加大尺寸0.3                                AC310,AC111,AC707
        if ((Pos(tmpCDS1.FieldByName('Custno').AsString, 'AC707,AC111,AC084,ACD04,AC310') > 0)or
            (Pos(tmpCDS1.FieldByName('Custno2').AsString, 'AC707,AC111,AC084,ACD04,AC310') > 0)) and (Pos(tmpSizes,
          '370490,410490,430490') > 0) and (Copy(tmpPno, 3, 4) <= '0030') then
        begin
          if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3)
          else if (tmpSizes = '430490') and (tmpCDS1.FieldByName('Custno').AsString <> 'AC111') then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '433493' + RightStr(tmpPno, 3);
        end;

        {(*}    //    AC111, 3.2mil 180a 370490,410490
        if (Pos(tmpCDS1.FieldByName('Custno').AsString, 'AC111') > 0) and
           (Pos(tmpSizes, '370490,410490') > 0) and
           (Copy(tmpCDS1.FieldByName('Materialno').AsString, 2, 1) = 'F') and
           (Copy(tmpCDS1.FieldByName('Materialno').AsString, 7, 2) = '22') and
           (Copy(tmpPno, 3, 4) = '0032') then
        begin
          if tmpSizes = '370490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
          else if tmpSizes = '410490' then
            tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3);
        end;    {*)}

        if (Pos(tmpCDS1.FieldByName('Custno2').AsString, 'AC084,AC111,AC310,AC707') > 0) and (Pos(tmpSizes,
          '370490,410490,430490') > 0) then
        begin
          if ((Copy(tmpPno, 3, 4) <= '0030') and (Pos(Copy(tmpPno, 7, 2),'HH/11/1H/21/22')>0)) or
             ((Copy(tmpPno, 3, 4) = '0032') and (Pos(Copy(tmpPno, 7, 2),'22')>0) and (Copy(tmpPno, 2, 1) = 'F'))
          then
          begin
            if tmpSizes = '370490' then
              tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '373493' + RightStr(tmpPno, 3)
            else if tmpSizes = '410490' then
              tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '413493' + RightStr(tmpPno, 3)
            else if tmpSizes = '430490' then
              tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + '433493' + RightStr(tmpPno, 3);
          end;
        end;

        if ((Copy(tmpPno, 2, 5) = '60240') or (Copy(tmpPno, 2, 5) = 'F0240')) and (Pos(tmpSizes,
          '370490,410490,430490,370430,410430,370425') > 0) then
        begin
          i := StrToInt(Copy(tmpPno, 9, 6));
          i := i + 3003;
          tmpCDS1.FieldByName('Materialno').AsString := LeftStr(tmpPno, 8) + IntToStr(i) + RightStr(tmpPno, 3);
        end;

        tmpCDS1.Post;

        Inc(tmpCitem);

        tmpStr1 := tmpMachine;
        CDS2.Next;
      end;

      post_bo := CDSPost(tmpCDS1, p_TableName);

      if post_bo then
      begin
        if Length(tmpStr2) > 0 then
        begin
          tmpSQL := 'Delete From MPS012 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (' + tmpStr2 + ')';
          if not PostBySQL(tmpSQL) then
            ShowMsg('副排程已排資料清理失敗!', 48);
        end;
      end;

    finally
      l_Ans := False;
      g_ProgressBar.Visible := False;
      CDS2.EnableControls;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;

  if post_bo then
  begin
    CDS.EmptyDataSet;
    CDS2.EmptyDataSet;
    CDS3.EmptyDataSet;
    SetEdit3;
    GetSumQty;
    l_OptLockAns := False;
    l_LockAns := False;
    if UnLockProc then
      ShowMsg('確認完畢,請重新查詢顯示資料!', 64);
  end;
end;

procedure TFrmMPST010.btn_mpst010EClick(Sender: TObject);
var
  tmpS1, tmpS2, tmpSimuver, tmpStealno: string;
  i, tmpEmptyRecno, tmpCitem, tmpJitem, tmpNewBoiler, tmpOjitem, tmpAdcode: Integer;
  tmpNewSdate: TDateTime;
  R_ans: Boolean;

  procedure SPStr(SourceStr: string; var S1, S2: string);
  var
    pos1: Integer;
  begin
    pos1 := Pos('@', SourceStr);
    S1 := LeftStr(SourceStr, pos1 - 1);
    S2 := Copy(SourceStr, pos1 + 1, 20);
  end;

  function UpdateMove_ans(xJitem: Integer; var xEmptyRecno: Integer): Boolean;
  var
    P: TBookMark;
  begin
    Result := False;
    xEmptyRecno := -1;
    P := CDS.GetBookmark;
    while not CDS.Bof do
    begin
      CDS.Prior;
      if xJitem = CDS.FieldByName('Jitem').AsInteger then
        P := CDS.GetBookmark
      else
        Break;
    end;

    CDS.GotoBookmark(P);
    while not CDS.Eof do
    begin
      if xJitem = CDS.FieldByName('Jitem').AsInteger then
      begin
        if CDS.FieldByName('EmptyFlag').AsInteger = 1 then
        begin
          if xEmptyRecno = -1 then
            xEmptyRecno := CDS.RecNo;
        end
        else
        begin
          if l_SelList.IndexOf(CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString) = -1 then
          begin   //單鍋至少保留一筆
            Result := True;
            if not CDS.FieldByName('Move_ans').AsBoolean then
            begin
              CDS.Edit;
              CDS.FieldByName('Move_ans').AsBoolean := True;
              CDS.Post;
            end;
          end;
        end;
      end
      else
        Break;

      CDS.Next;
    end;
  end;

begin
  inherited;
  if l_SelList.Count = 0 then
  begin
    ShowMsg('請選擇要調整的單據!', 48);
    Exit;
  end;

  CheckLock;

  if ShowMsg('調整過的鍋次將標記為滿鍋,且不再計算!' + #13#10 + '確定要將選中的單據調整到當前鍋次嗎?', 33) = IdCancel
    then
    Exit;

  l_Ans := True;
  tmpOjitem := -1;
  CDS.DisableControls;
  try
    //***調整到此位置
    tmpSimuver := CDS.FieldByName('Simuver').AsString;
    tmpCitem := CDS.FieldByName('Citem').AsInteger;
    tmpJitem := CDS.FieldByName('Jitem').AsInteger;
    tmpStealno := CDS.FieldByName('Stealno').AsString;
    tmpAdcode := CDS.FieldByName('Adcode').AsInteger;
    tmpNewBoiler := CDS.FieldByName('CurrentBoiler').AsInteger;
    tmpNewSdate := CDS.FieldByName('Sdate').AsDateTime;
    //***

    for i := 0 to l_SelList.Count - 1 do
    begin
      SPStr(l_SelList.Strings[i], tmpS1, tmpS2);
      CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []);
      if (CDS.FieldByName('Sdate').AsDateTime = tmpNewSdate) and (CDS.FieldByName('CurrentBoiler').AsInteger =
        tmpNewBoiler) then
      begin
        ShowMsg('相同鍋次不可調整!', 48);
        Exit;
      end;
    end;

    for i := 0 to l_SelList.Count - 1 do
    begin
      SPStr(l_SelList.Strings[i], tmpS1, tmpS2);
      CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []);
      tmpOjitem := CDS.FieldByName('Jitem').AsInteger;

      R_ans := UpdateMove_ans(tmpOjitem, tmpEmptyRecno);
      if tmpEmptyRecno <> -1 then
      begin
        CDS.RecNo := tmpEmptyRecno;
        CDS.Delete;
      end;

      CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []);
      if not R_ans then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        ShowMsg('不能調整為空鍋!', 48);
        Exit;
      end;

      CDS.Edit;
      CDS.FieldByName('Sdate').AsDateTime := tmpNewSdate;
      CDS.FieldByName('CurrentBoiler').AsInteger := tmpNewBoiler;
      CDS.FieldByName('Jitem').AsInteger := tmpJitem;
      CDS.FieldByName('Stealno').AsString := tmpStealno;
      CDS.FieldByName('Adcode').AsInteger := tmpAdcode;
      CDS.FieldByName('Move_ans').AsBoolean := True;
      CDS.Post;

      //新位置
      CDS.Locate('Simuver;Citem', VarArrayOf([tmpSimuver, tmpCitem]), []);
      UpdateMove_ans(tmpJitem, tmpEmptyRecno);
      if tmpEmptyRecno <> -1 then
      begin
        CDS.RecNo := tmpEmptyRecno;
        CDS.Delete;
      end;
    end;

    if not CDSPost(CDS, p_TableName) then
      if CDS.ChangeCount > 0 then
        CDS.CancelUpdates;

    SPStr(l_SelList.Strings[0], tmpS1, tmpS2);
    CDS.Locate('Simuver;Citem', VarArrayOf([tmpS1, tmpS2]), []);
    btn_mpst010N.Hint := CheckLang(l_JumpHint) + '[' + CDS.FieldByName('Jitem').AsString + '/' + IntToStr(tmpOjitem) +
      ']';
  finally
    l_Ans := False;
    CDS.EnableControls;
    SetEdit3;
    GetSumQty;
    RefreshColor;
    l_SelList.Clear;
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST010.btn_mpst010FClick(Sender: TObject);
var
  Reslut: Boolean;
begin
  inherited;
  CheckLock;

  Reslut := False;
  l_Ans := True;
  CDS.DisableControls;
  FrmBoilerEdit := TFrmBoilerEdit.Create(nil);
  try
    Reslut := FrmBoilerEdit.ShowModal = mrOK;
    if Reslut then
    begin
      SetEdit3;
      GetSumQty;
      RefreshColor;
      l_SelList.Clear;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
    CDS.EnableControls;
    FreeAndNil(FrmBoilerEdit);
    if Reslut then
      ShowMsg('對換完畢!', 64);
  end;
end;

procedure TFrmMPST010.btn_mpst010GClick(Sender: TObject);
begin
  inherited;
  CheckLock;

  FrmPlanChange := TFrmPlanChange.Create(nil);
  if (PCL.ActivePageIndex = 0) and (not CDS.IsEmpty) then
  begin
    FrmPlanChange.l_Machine := CDS.FieldByName('Machine').AsString;
    FrmPlanChange.Dtp.Date := CDS.FieldByName('Sdate').AsDateTime;
  end;
  try
    FrmPlanChange.ShowModal;
  finally
    FreeAndNil(FrmPlanChange);
  end;
end;

procedure TFrmMPST010.btn_mpst010HClick(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  inherited;
  CheckLock;

  tmpSQL := ' declare @id int' + ' if exists(select 1 from mps010 where bu=' + Quotedstr(g_UInfo^.BU) +
    ' and case_ans1=1 and isnull(case_ans2,0)=0)' + ' set @id=1 else set @id=2' + ' if @id=1' + ' begin' +
    '   if exists(select 1 from mps010 where bu=' + Quotedstr(g_UInfo^.BU) +
    '   and case_ans1=1 and isnull(case_ans2,0)=0' + '   and (cx_date is null) and isnull(wostation,0)<=3)' +
    '   set @id=3 else set @id=4' + ' end' + ' select @id as id';
  if not QueryOneCR(tmpSQL, Data) then
    Exit;
  if VarToStr(Data) = '2' then
  begin
    ShowMsg('未選擇結案單據!', 48);
    Exit;
  end;

  if VarToStr(Data) = '3' then
  begin
    if ShowMsg('生產報工異常,確定強制結案嗎?', 33) = IDCancel then
      Exit;
  end
  else if ShowMsg('確定進行強制結案嗎?', 33) = IDCancel then
    Exit;

  tmpSQL := 'update mps010 set case_ans2=1,case_user2=' + Quotedstr(g_UInfo^.UserId) + ',case_date2=' + Quotedstr(FormatDateTime
    (g_cLongTimeSP, Now)) + ' where Bu=' + Quotedstr(g_UInfo^.BU) + ' and case_ans1=1 and isnull(case_ans2,0)=0';
  if PostBySQL(tmpSQL) then
    ShowMsg('強制結案完畢,請重新查詢顯示資料!', 64);
end;

procedure TFrmMPST010.btn_mpst010IClick(Sender: TObject);
var
  Reslut: Boolean;
begin
  inherited;
  CheckLock;

  Reslut := False;
  l_Ans := True;
  CDS.DisableControls;
  FrmEmptyFlagAdd := TFrmEmptyFlagAdd.Create(nil);
  try
    Reslut := FrmEmptyFlagAdd.ShowModal = mrOK;
    if Reslut then
    begin
      RefreshColor;
      l_SelList.Clear;
      DBGridEh1.Repaint;
    end;
  finally
    l_Ans := False;
    CDS.EnableControls;
    FreeAndNil(FrmEmptyFlagAdd);
    if Reslut then
      ShowMsg('添加完畢!', 64);
  end;
end;

procedure TFrmMPST010.btn_mpst010JClick(Sender: TObject);
var
  tmpSdate: TDateTime;
  tmpSQL, tmpMachine, tmpStealno, tmpOZ: string;
  tmpUseBooks, tmpRemainBooks: Double;
  tmpJitem, tmpBoiler, tmpAdcode: Integer;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('排程無資料,不可計算', 64);
    Exit;
  end;

  tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
  tmpMachine := CDS.FieldByName('Machine').AsString;
  tmpStealno := CDS.FieldByName('Stealno').AsString;
  tmpJitem := CDS.FieldByName('Jitem').AsInteger;
  tmpBoiler := CDS.FieldByName('CurrentBoiler').AsInteger;
  tmpAdcode := CDS.FieldByName('Adcode').AsInteger;
  tmpSQL := 'Select Machine,Materialno,Book_qty,Sqty From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ' And Sdate=' + Quotedstr(DateToStr(tmpSdate)) + ' And Machine=' + Quotedstr(tmpMachine) + ' And Jitem=' + IntToStr(tmpJitem)
    + ' And IsNull(ErrorFlag,0)=0 And Len(IsNull(Materialno,''''))>0 And Sqty>0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  l_Ans := True;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    tmpUseBooks := GetTotBooks(tmpCDS);

    Data := null;
    tmpSQL := 'Select Top 1 Books From MPS040 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Machine=' + Quotedstr(tmpMachine);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    tmpRemainBooks := RoundTo(tmpCDS.Fields[0].AsFloat - tmpUseBooks, -1);
    tmpSQL := '總產能：' + FloatToStr(tmpCDS.Fields[0].AsFloat) + #13#10 + '已使用：' + FloatToStr(tmpUseBooks) + #13#10
      + '剩余：' + FloatToStr(tmpRemainBooks);
    if tmpRemainBooks <= 0 then
    begin
      ShowMsg(tmpSQL, 64);
      Exit;
    end;

    tmpSQL := tmpSQL + #13#10 + '按[確定]添加或修改空行產能,按[取消]退出,請選擇操作?';
    if ShowMsg(tmpSQL, 33) = IdCancel then
      Exit;

    Data := null;
    tmpSQL := 'Select Simuver,Citem,RemainBooks From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Sdate=' +
      Quotedstr(DateToStr(tmpSdate)) + ' And Machine=' + Quotedstr(tmpMachine) + ' And Jitem=' + IntToStr(tmpJitem) +
      ' And EmptyFlag=1';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    if not tmpCDS.IsEmpty then
    begin
      if not CDS.Locate('Simuver;Citem', VarArrayOf([tmpCDS.FieldByName('Simuver').AsString, tmpCDS.FieldByName('Citem').AsInteger]),
        []) then
      begin
        ShowMsg('空行已存在,但定位失敗,請重新查詢資料重試!', 48);
        Exit;
      end;

      if CDS.FieldByName('RemainBooks').AsInteger = tmpRemainBooks then
        Exit;

      CDS.Edit;
      CDS.FieldByName('RemainBooks').AsFloat := tmpRemainBooks;
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
        FieldByName('Jitem').AsInteger := tmpJitem;
        FieldByName('Sdate').AsDateTime := tmpSdate;
        FieldByName('Machine').AsString := tmpMachine;
        FieldByName('Stealno').AsString := tmpStealno;
        FieldByName('CurrentBoiler').AsInteger := tmpBoiler;
        FieldByName('Adcode').AsInteger := tmpAdcode;
        FieldByName('RemainBooks').AsFloat := tmpRemainBooks;
        //取銅箔
        if not GetMPSEmptyOZ(IntToStr(tmpJitem), '', tmpOZ) then
        begin
          Cancel;
          Locate('Jitem', tmpJitem, []);
          Exit;
        end;
        FieldByName('OZ').AsString := g_OZ + tmpOZ;

        FieldByName('EmptyFlag').AsInteger := 1;
        FieldByName('Lock').AsBoolean := False;
        FieldByName('BU').AsString := g_UInfo^.BU;
        FieldByName('Iuser').AsString := g_UInfo^.UserId;
        FieldByName('Idate').AsDateTime := Now;
        FieldByName('ErrorFlag').AsInteger := 0;
        FieldByName('Case_ans1').AsBoolean := False;
        FieldByName('Case_ans2').AsBoolean := False;
        FieldByName('Move_ans').AsBoolean := False;
        Post;
      end;
    end;

    if not CDSPost(CDS, 'MPS010') then
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
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST010.btn_mpst010KClick(Sender: TObject);
begin
  inherited;
  FrmClacBooks := TFrmClacBooks.Create(nil);
  try
    FrmClacBooks.ShowModal;
  finally
    FreeAndNil(FrmClacBooks);
  end;
end;

procedure TFrmMPST010.btn_mpst010LClick(Sender: TObject);
var
  tmpIndex: Integer;
  tmpSQL, tmpMachine, tmpStealno, tmpFilter, tmpMinJitem, tmpMaxJitem: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  tmpList: TStrings;
begin
  inherited;
  if not (CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex = 0)) then
  begin
    ShowMsg('請選擇線別!', 48);
    Exit;
  end;

  tmpMinJitem := CDS.FieldByName('Jitem').AsString;
  tmpMachine := CDS.FieldByName('Machine').AsString;
  tmpStealno := CDS.FieldByName('Stealno').AsString;

  tmpSQL := 'Select Top 1 Jitem From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ' And Jitem in (Select Jitem From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Machine=' + Quotedstr(tmpMachine)
    + ' And Stealno=' + Quotedstr(tmpStealno) + ' And Jitem>' + tmpMinJitem + ' Group By Jitem Having Count(*)=1)' +
    ' And IsNull(lock,0)=0 And EmptyFlag=1' + ' Order By Jitem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
      begin
        ShowMsg('沒有空余的鍋次', 48);
        Exit;
      end;

      if ShowMsg('確定增加' + tmpStealno + '鋼板嗎?', 33) = IdCancel then
        Exit;

      CheckLock;

      tmpMaxJitem := tmpCDS.FieldByName('Jitem').AsString;
      Data := null;
      tmpSQL := 'Select Simuver,Citem,Jitem,Sdate,CurrentBoiler From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
        ' And Machine=' + Quotedstr(tmpMachine) + ' And Stealno=' + Quotedstr(tmpStealno) + ' And Jitem>=' + tmpMinJitem
        + ' And Jitem<=' + tmpMaxJitem + ' Order By Jitem';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if tmpCDS.IsEmpty then
        begin
          ShowMsg('資料不存在!', 48);
          Exit;
        end;

        l_Ans := True;
        tmpList := TStringList.Create;
        tmpFilter := CDS.Filter;
        CDS.Filtered := False;
        CDS.DisableControls;
        try
          with tmpCDS do
          begin
            while not Eof do
            begin
              if tmpList.IndexOf(FieldByName('Jitem').AsString) = -1 then
              begin
                tmpList.Add(FieldByName('Jitem').AsString);
                tmpList.Add(FieldByName('Sdate').AsString);
                tmpList.Add('@' + FieldByName('CurrentBoiler').AsString);  //Jitem可能等於CurrentBoiler
              end;
              Next;
            end;

            First;
            tmpList.Add(FieldByName('Jitem').AsString);
            tmpList.Add(FieldByName('Sdate').AsString);
            tmpList.Add('@' + FieldByName('CurrentBoiler').AsString);
            while not Eof do
            begin
              if not CDS.Locate('Simuver;Citem', VarArrayOf([FieldByName('Simuver').AsString, FieldByName('Citem').AsInteger]),
                []) then
              begin
                if CDS.ChangeCount > 0 then
                  CDS.CancelUpdates;
                ShowMsg('資料不同步,請重新開啟作業!', 48);
                Exit;
              end;

              tmpIndex := tmpList.IndexOf(FieldByName('Jitem').AsString);
              tmpSQL := tmpList.Strings[tmpIndex + 5];
              System.Delete(tmpSQL, 1, 1); //Delete '@'
              CDS.Edit;
              CDS.FieldByName('Jitem').AsInteger := StrToInt(tmpList.Strings[tmpIndex + 3]);
              CDS.FieldByName('Sdate').AsDateTime := StrToDate(tmpList.Strings[tmpIndex + 4]);
              CDS.FieldByName('CurrentBoiler').AsInteger := StrToInt(tmpSQL);
              CDS.Post;
              Next;
            end;
          end;

          if not CDSPost(CDS, 'MPS010') then
            if CDS.ChangeCount > 0 then
            begin
              CDS.CancelUpdates;
              Exit;
            end;

          SetEdit3;
          GetSumQty;
          RefreshColor;
          l_SelList.Clear;
          DBGridEh1.Repaint;

        finally
          l_Ans := False;
          FreeAndNil(tmpList);
          CDS.Filter := tmpFilter;
          CDS.Filtered := True;
          CDS.Locate('Jitem', tmpMinJitem, []);
          CDS.EnableControls;
        end;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmMPST010.btn_mpst010MClick(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  SMRec: TSplitMaterialno;
  tmpList: TStrings;
begin
  inherited;
  tmpSQL := 'Select * From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ' And IsNull(ErrorFlag,0)=0 And IsNull(EmptyFlag,0)=0' + ' And Sdate>' + Quotedstr(DateToStr(Date - 1)) +
    ' Order By Machine,Jitem,OZ,Materialno,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpList := TStringList.Create;
    if not Assigned(FrmShowErrList) then
      FrmShowErrList := TFrmShowErrList.Create(Application);
    FrmShowErrList.Memo1.Hint := CheckLang('機台/生產日期/鍋次/料號/鋼板');
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        if not IsEmpty then
        begin
          g_ProgressBar.Visible := True;
          g_ProgressBar.Max := RecordCount;
          g_ProgressBar.Position := 0;
          l_Param.GetParameData_Stealno;
          while not Eof do
          begin
            g_ProgressBar.Position := g_ProgressBar.Position + 1;
            SMRec.MLast := Copy(FieldByName('stealno').AsString, 1, 2);
            SMRec.M3_6 := StrToFloat(Copy(FieldByName('materialno').AsString, 3, 4)) / 10000;
            SMRec.M9_11 := UpperCase(Copy(FieldByName('materialno').AsString, 9, 3));
            SMRec.M12_14 := UpperCase(Copy(FieldByName('materialno').AsString, 12, 3));
            if (SMRec.M12_14 >= '488') and (SMRec.M12_14 <= '493') then //緯向490,經向是特殊尺寸則轉換
              SMRec.M9_11 := l_Param.GetOtherSize(SMRec.M9_11, True);
            if not l_Param.CheckStealno(SMRec) then
            begin
              tmpSQL := FieldByName('machine').AsString + '    ' + FieldByName('sdate').AsString + '    ' + FieldByName('currentboiler').AsString
                + '    ' + FieldByName('materialno').AsString + '    ' + FieldByName('stealno').AsString;
              tmpList.Add(tmpSQL);
            end;
            Next;
          end;
          g_ProgressBar.Visible := False;
        end;
      end;
      if tmpList.Count = 0 then
        tmpList.Add(CheckLang('無錯誤'));
      FrmShowErrList.Memo1.Lines.Assign(tmpList);
      FrmShowErrList.ShowModal;
    finally
      FreeAndNil(tmpList);
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmMPST010.btn_mpst010NClick(Sender: TObject);
var
  tmpStr1, tmpStr2: WideString;
  Pos1: Integer;
begin
  inherited;
  //格式: btn_mpst010N.Hint[A/B]
  tmpStr1 := btn_mpst010N.Hint;
  Pos1 := Pos('[', tmpStr1);
  if Pos1 = 0 then
    Exit;

  tmpStr1 := Copy(tmpStr1, Pos1 + 1, Length(tmpStr1) - Pos1 - 1);  //A/B
  Pos1 := Pos('/', tmpStr1);
  tmpStr2 := Copy(tmpStr1, Pos1 + 1, 10);  //B
  tmpStr1 := Copy(tmpStr1, 1, Pos1 - 1);   //A

  if CDS.FieldByName('Jitem').AsString = tmpStr1 then
    CDS.Locate('Jitem', tmpStr2, [])
  else
    CDS.Locate('Jitem', tmpStr1, []);
end;

procedure TFrmMPST010.btn_mpst010OClick(Sender: TObject);
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

procedure TFrmMPST010.btn_mpst010PClick(Sender: TObject);
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

procedure TFrmMPST010.btn_mpst010QClick(Sender: TObject);
begin
  inherited;
  if not AsSigned(FrmUpdateCo) then
    FrmUpdateCo := TFrmUpdateCo.Create(Application);
  if not CDS.IsEmpty then
  begin
    FrmUpdateCo.dtp1.Date := CDS.FieldByName('sdate').AsDateTime;
    FrmUpdateCo.dtp2.Date := CDS.FieldByName('sdate').AsDateTime;
    if Pos(CDS.FieldByName('machine').AsString, g_MachineCCL_GZ) > 0 then
      FrmUpdateCo.rgp.ItemIndex := 1
    else
      FrmUpdateCo.rgp.ItemIndex := 0;
  end;
  FrmUpdateCo.ShowModal;
end;

procedure TFrmMPST010.btn_mpst010RClick(Sender: TObject);
begin
  inherited;
  if not AsSigned(FrmUpdateRemainOrdqty) then
    FrmUpdateRemainOrdqty := TFrmUpdateRemainOrdqty.Create(Application);
  if not CDS.IsEmpty then
  begin
    FrmUpdateRemainOrdqty.dtp1.Date := CDS.FieldByName('sdate').AsDateTime;
    FrmUpdateRemainOrdqty.dtp2.Date := CDS.FieldByName('sdate').AsDateTime;
  end;
  FrmUpdateRemainOrdqty.ShowModal;
end;

procedure TFrmMPST010.btn_mpst010SClick(Sender: TObject);
begin
  inherited;
  FrmMPST010_GetCore := TFrmMPST010_GetCore.Create(nil);
  try
    FrmMPST010_GetCore.ShowModal;
  finally
    FreeAndNil(FrmMPST010_GetCore);
  end;
end;

procedure TFrmMPST010.btn_mpst010TClick(Sender: TObject);
begin
  inherited;
  FrmMPST010_PnoSum := TFrmMPST010_PnoSum.Create(nil);
  try
    FrmMPST010_PnoSum.ShowModal;
  finally
    FreeAndNil(FrmMPST010_PnoSum);
  end;
end;

procedure TFrmMPST010.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr: string;
  lp: Integer;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) <> -1 then
      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
  end;

  if SameText(Column.FieldName, 'materialno') then
  begin
    for lp := 0 to l_CheckMater_RecNo.Count - 1 do
      if CDS.RecNo = strtoint(l_CheckMater_RecNo.Strings[lp]) then
      begin
        DBGridEh1.Canvas.Font.Color := clGreen;
        DBGridEh1.DefaultDrawColumnCell(Rect, DataCol, Column, State);
      end;
  end;
end;

procedure TFrmMPST010.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  tmpStr := LowerCase(Copy(CDS.FieldByName('materialno').AsString, 2, 1));
  if Pos(tmpStr, 'q8fnu') > 0 then
    AFont.Color := clRed;

  tmpStr := CDS.FieldByName('stealno').AsString;
  if (LowerCase(Column.FieldName) = 'stealno') and ((Pos('37-', tmpStr) > 0) or (Pos('40-', tmpStr) > 0) or (Pos('55-',
    tmpStr) > 0)) then
    Background := clMenuHighlight
  else if l_ColorList.Count >= CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
      Background := l_Color2
    else
      Background := l_Color1;
  end;

  if LowerCase(Column.FieldName) = 'remain_ordqty' then
    if not CDS.FieldByName('remain_ordqty').IsNull then
      if CDS.FieldByName('remain_ordqty').AsFloat < CDS.FieldByName('orderqty').AsFloat then
        Background := clMenuHighlight;
end;

procedure TFrmMPST010.DBGridEh3GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS3.Active and (CDS3.FieldByName('srcflag').AsInteger in [3, 4]) then
    Background := $00C08080;
end;

procedure TFrmMPST010.DBGridEh1DblClick(Sender: TObject);
var
  sSimuver, sMachine, sStealno, tmpStr, tmpC9_11, tmpSimuver, tmpOZ: string;
  sCitem, sAdCode, sCurrentBoiler, tmpJitem, k: Integer;
  sSdate: TDateTime;
  sBook_qty, sRemainbooks, tmpBooks: Double;
  tmpBo: Boolean;
  P: TBookmark;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if (DBGridEh1.SelectedField = CDS.FieldByName('Case_ans1')) or (DBGridEh1.SelectedIndex = 0) then
    Exit;

  CheckLock;

  with CDS do
    if (FieldByName('ErrorFlag').AsInteger = 0) and (Length(FieldByName('Orderno').AsString) > 0) then
    begin
      tmpJitem := FieldByName('Jitem').AsInteger;
      if FieldByName('Move_ans').AsBoolean then
      begin
        DisableControls;
        P := GetBookmark;
        try
          Next;
          if Eof or (tmpJitem <> FieldByName('Jitem').AsInteger) then
          begin
            GotoBookmark(P);
            Prior;
            if Bof or (tmpJitem <> FieldByName('Jitem').AsInteger) then
            begin
              ShowMsg('此鍋次剩余一筆,不允許撤消,請補空行後再操作!', 48);
              Exit;
            end;
          end;
        finally
          GotoBookmark(P);
          EnableControls;
        end;
      end;

      tmpStr := '確定撤消並返回未排狀態嗎?';
      if FieldByName('Move_ans').AsBoolean then
        tmpStr := '此鍋次已調整過,撤消不再計算!' + #13#10 + tmpStr;

      if ShowMsg(tmpStr, 33) = IDCancel then
        Exit;

      sSimuver := FieldByName('Simuver').AsString;
      sCitem := FieldByName('Citem').AsInteger;
      sMachine := FieldByName('Machine').AsString;
      sSdate := FieldByName('Sdate').AsDateTime;
      sStealno := FieldByName('Stealno').AsString;
      sAdCode := FieldByName('AdCode').AsInteger;
      sBook_qty := FieldByName('Book_qty').AsFloat;
      sCurrentBoiler := FieldByName('CurrentBoiler').AsInteger;
      tmpBooks := l_Param.GetBooks(sMachine);

      tmpStr := ' And not (Simuver=' + Quotedstr(sSimuver) + ' And Citem=' + IntToStr(sCitem) + ')';
      if not GetMPSEmptyOZ(IntToStr(tmpJitem), tmpStr, tmpOZ) then
        Exit;

      if Pos(UpperCase(sMachine), g_MachineCCL_GZ) > 0 then
      begin
        k := 2;
        tmpC9_11 := UpperCase(Copy(FieldByName('materialno').AsString, 9, 3));
        if (tmpC9_11 < '300') and (tmpC9_11 <> '230') then
          k := 3
        else if Pos(tmpC9_11, '740/820/860') > 0 then
          k := 1;
      end
      else
        k := 1;

      sRemainbooks := RoundTo(FieldByName('sqty').AsFloat / (sBook_qty * k), -3);

      l_Ans := True;
      tmpBo := True;
      DisableControls;
      try
        if not FieldByName('Move_ans').AsBoolean then
        begin             //找未滿鍋的單據
          Next;
          while not Eof do
          begin
            if tmpJitem <> FieldByName('Jitem').AsFloat then
              Break
            else if FieldByName('EmptyFlag').AsInteger = 1 then
            begin
              Edit;
              FieldByName('RemainBooks').AsFloat := RoundTo(FieldByName('RemainBooks').AsFloat + sRemainbooks, -3);
              if Round(FieldByName('RemainBooks').AsFloat + 0.04) >= tmpBooks then
              begin
                FieldByName('Adcode').AsInteger := 0;
                FieldByName('RemainBooks').AsFloat := 0;
                FieldByName('OZ').AsString := g_OZ;
              end
              else
                FieldByName('OZ').AsString := g_OZ + tmpOZ;
              Post;
              tmpBo := False;
              Break;
            end;
            Next;
          end;

          if tmpBo then   //找不到,新增一筆空數據
          begin
            tmpSimuver := GetSno(g_MInfo^.ProcId);  //取流水號
            if tmpSimuver <> '' then
            begin
              Append;
              SetNewRecordData(CDS);
              FieldByName('EmptyFlag').AsInteger := 1;
              FieldByName('Simuver').AsString := tmpSimuver;
              FieldByName('Citem').AsInteger := 1;
              FieldByName('Jitem').AsInteger := tmpJitem;
              FieldByName('Machine').AsString := sMachine;
              FieldByName('Sdate').AsDateTime := sSdate;
              FieldByName('Stealno').AsString := sStealno;
              FieldByName('CurrentBoiler').AsFloat := sCurrentBoiler;
              if Round(sRemainbooks + 0.04) < tmpBooks then
              begin
                FieldByName('Adcode').AsInteger := sAdCode;
                FieldByName('RemainBooks').AsFloat := sRemainbooks;
                FieldByName('OZ').AsString := g_OZ + tmpOZ;
              end
              else  //空鍋
              begin
                FieldByName('Adcode').AsInteger := 0;
                FieldByName('RemainBooks').AsFloat := 0;
                FieldByName('OZ').AsString := g_OZ;
              end;
              Post;
            end;
          end;
        end;

        Locate('Simuver;Citem', VarArrayOf([sSimuver, sCitem]), []);
        Edit;
        FieldByName('ErrorFlag').AsInteger := 1;
        Post;

        if not CDSPost(Self.CDS, p_TableName) then
          if ChangeCount > 0 then
            CancelUpdates;
      finally
        EnableControls;
        l_Ans := False;
        l_SelList.Clear;
        RefreshColor;
        DBGridEh1.Repaint;
      end;
    end;
end;

procedure TFrmMPST010.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
      g_DelFname := 'select,case_ans1,edate,stealno,orderitem,sqty,' + 'orderqty,materialno1,pnlsize1,pnlsize2';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end
  else if (Shift = [ssCtrl]) and (Key = 81) and CDS.Active and  //Ctrl+Q 兩角訂單更改
    (not CDS.IsEmpty) and (g_MInfo^.R_edit) and (CDS.FieldByName('ErrorFlag').AsInteger = 0) and (CDS.FieldByName('EmptyFlag').AsInteger
    <> 1) then
  begin
    CheckLock;
    if not Assigned(FrmOrderno2Edit) then
      FrmOrderno2Edit := TFrmOrderno2Edit.Create(Application);
    with FrmOrderno2Edit do
    begin
      Label1.Caption := Self.DBGridEh1.FieldColumns['Orderno2'].Title.Caption + '：';
      Label2.Caption := Self.DBGridEh1.FieldColumns['Orderitem2'].Title.Caption + '：';
      Edit1.Text := Self.CDS.FieldByName('Orderno2').AsString;
      Edit2.Text := Self.CDS.FieldByName('Orderitem2').AsString;
    end;
    if FrmOrderno2Edit.ShowModal = mrOk then
    begin
      if (CDS.FieldByName('Orderno2').AsString = FrmOrderno2Edit.Edit1.Text) and (CDS.FieldByName('Orderitem2').AsString
        = FrmOrderno2Edit.Edit2.Text) then
        Exit;

      CDS.Edit;
      CDS.FieldByName('Orderno2').AsString := Trim(FrmOrderno2Edit.Edit1.Text);
      if (Length(CDS.FieldByName('Orderno2').AsString) = 0) or (Trim(FrmOrderno2Edit.Edit2.Text) = '') then
        CDS.FieldByName('Orderitem2').Clear
      else
        CDS.FieldByName('Orderitem2').AsInteger := StrToInt(FrmOrderno2Edit.Edit2.Text);
      CDS.Post;
      if not CDSPost(CDS, p_TableName) then
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
    end;
  end
  else if (Shift = [ssCtrl]) and (Key = 69) and CDS.Active and  //Ctrl+E 交期、排製量等更改
    (not CDS.IsEmpty) and (g_MInfo^.R_edit) and (CDS.FieldByName('ErrorFlag').AsInteger = 0) and (CDS.FieldByName('EmptyFlag').AsInteger
    <> 1) then
  begin
    CheckLock;
    FrmSqtyEdit := TFrmSqtyEdit.Create(nil);
    with FrmSqtyEdit do
    begin
      Dtp.Date := Self.CDS.FieldByName('Adate_new').AsDateTime;
      Edit1.Text := DateToStr(Self.CDS.FieldByName('Adate').AsDateTime);
      Edit2.Text := FloatToStr(Self.CDS.FieldByName('Sqty').AsFloat);
      Edit3.Text := Self.CDS.FieldByName('Premark').AsString;
      Edit4.Text := Self.CDS.FieldByName('Wono').AsString;
      Edit5.Text := Self.CDS.FieldByName('Materialno').AsString;
      Edit6.Text := Self.CDS.FieldByName('Orderno').AsString;
      Edit7.Text := Self.CDS.FieldByName('Orderitem').AsString;
      Edit8.Text := Self.CDS.FieldByName('Supplier').AsString;
      Edit9.Text := Self.CDS.FieldByName('Premark2').AsString;
      Edit10.Text := Self.CDS.FieldByName('Premark3').AsString;

      // longxnjue 2022.01.07 加投數量、訂單數量、樣品數量
      Edit11.Text := Self.CDS.FieldByName('regulateQty').AsString;
      Edit12.Text := Self.CDS.FieldByName('orderQty').AsString;
      Edit13.Text := Self.CDS.FieldByName('sampleQty').AsString;
    end;
    try
      if FrmSqtyEdit.ShowModal = mrOk then
      begin
        if (CDS.FieldByName('Adate_new').AsDateTime = FrmSqtyEdit.Dtp.Date) and (CDS.FieldByName('Sqty').AsFloat =
          StrToFloat(FrmSqtyEdit.Edit2.Text)) and (CDS.FieldByName('Premark').AsString = FrmSqtyEdit.Edit3.Text) and (CDS.FieldByName
          ('Wono').AsString = FrmSqtyEdit.Edit4.Text) and (CDS.FieldByName('Materialno').AsString = FrmSqtyEdit.Edit5.Text)
          and (CDS.FieldByName('Orderno').AsString = FrmSqtyEdit.Edit6.Text) and (CDS.FieldByName('Orderitem').AsString
          = FrmSqtyEdit.Edit7.Text) and (CDS.FieldByName('Supplier').AsString = FrmSqtyEdit.Edit8.Text) and (CDS.FieldByName
          ('Premark2').AsString = FrmSqtyEdit.Edit9.Text) and (CDS.FieldByName('Premark3').AsString = FrmSqtyEdit.Edit10.Text)
          and         // longxnjue 2022.01.07 加投數量、樣品數量
          (CDS.FieldByName('regulateQty').AsString = FrmSqtyEdit.Edit11.Text) and (CDS.FieldByName('sampleQty').AsString
          = FrmSqtyEdit.Edit13.Text) then
          Exit;

        CDS.Edit;
        CDS.FieldByName('Adate_new').AsDateTime := FrmSqtyEdit.Dtp.Date;
        CDS.FieldByName('Sqty').AsFloat := StrToFloat(FrmSqtyEdit.Edit2.Text);
        CDS.FieldByName('Premark').AsString := FrmSqtyEdit.Edit3.Text;
        CDS.FieldByName('Wono').AsString := FrmSqtyEdit.Edit4.Text;
        CDS.FieldByName('Materialno').AsString := FrmSqtyEdit.Edit5.Text;
        CDS.FieldByName('Orderno').AsString := FrmSqtyEdit.Edit6.Text;
        CDS.FieldByName('Orderitem').AsString := FrmSqtyEdit.Edit7.Text;
        CDS.FieldByName('Supplier').AsString := FrmSqtyEdit.Edit8.Text;
        CDS.FieldByName('Premark2').AsString := FrmSqtyEdit.Edit9.Text;
        CDS.FieldByName('Premark3').AsString := FrmSqtyEdit.Edit10.Text;

      // longxnjue 2022.01.07 加投數量、樣品數量
        CDS.FieldByName('regulateQty').AsString := FrmSqtyEdit.Edit11.Text;
        CDS.FieldByName('sampleQty').AsString := FrmSqtyEdit.Edit13.Text;

        CDS.Post;
        if not CDSPost(CDS, p_TableName) then
          if CDS.ChangeCount > 0 then
            CDS.CancelUpdates;
      end;
    finally
      FreeAndNil(FrmSqtyEdit);
    end;
  end;
end;

procedure TFrmMPST010.DBGridEh1CellClick(Column: TColumnEh);
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

  if SameText(Column.FieldName, 'select') and (not SameText(CDS.FieldByName('machine').AsString, 'stk')) and (CDS.FieldByName
    ('EmptyFlag').AsInteger <> 1) then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) = -1 then
      l_SelList.Add(tmpStr)
    else
      l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST010.CDSAfterCancel(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSAfterDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSAfterEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSAfterInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSAfterPost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSAfterScroll(DataSet: TDataSet);
begin
  if L_Ans then
    Exit;

  inherited;
  SetEdit3;
  GetSumQty;
end;

procedure TFrmMPST010.CDSBeforeDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSBeforeEdit(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSBeforeInsert(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDSNewRecord(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmMPST010.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;

  if (Trim(CDS2.FieldByName('Orderno').AsString) <> '') and CDS3.Active then
    CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]),
      []);
  SetEdit3;
  SetSBars(CDS2);
  GetSumQty;
end;

procedure TFrmMPST010.CDS2BeforePost(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  if CDS3.Locate('Orderno;OrderItem', VarArrayOf([CDS2.FieldByName('Orderno').AsString, CDS2.FieldByName('OrderItem').AsInteger]),
    []) then
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

procedure TFrmMPST010.CDS3AfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_Ans then
    Exit;
  SetSBars(CDS3);
end;

procedure TFrmMPST010.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  SetNewRecordData(DataSet);
end;

procedure TFrmMPST010.PCLChange(Sender: TObject);
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

procedure TFrmMPST010.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N20.Visible := g_MInfo^.R_edit;
  N21.Visible := g_MInfo^.R_edit;
  N22.Visible := g_MInfo^.R_edit;
  N23.Visible := g_MInfo^.R_edit;
  if N20.Visible then
  begin
    N20.Enabled := CDS.Active and (not CDS.IsEmpty);
    N21.Enabled := l_SelList.Count > 0;
    N22.Enabled := N20.Enabled;
    N23.Enabled := CDS.FieldByName('EmptyFlag').AsInteger = 1;
  end;

  N3.Visible := CDS.Active and (not CDS.IsEmpty) and (g_MInfo^.R_edit);
  if N3.Visible then
    N27.Enabled := CDS.FieldByName('EmptyFlag').AsInteger = 1;
end;

procedure TFrmMPST010.N20Click(Sender: TObject);
var
  tmpStr: string;
  tmpJitem: Integer;
  P: TBookMark;
begin
  inherited;
  l_SelList.Clear;
  tmpJitem := CDS.FieldByName('Jitem').AsInteger;
  P := CDS.GetBookmark;
  CDS.DisableControls;
  try
    while not CDS.Bof do
    begin
      CDS.Prior;
      if tmpJitem = CDS.FieldByName('Jitem').AsInteger then
        P := CDS.GetBookmark
      else
        Break;
    end;

    CDS.GotoBookmark(P);
    while not CDS.Eof do
    begin
      if tmpJitem = CDS.FieldByName('Jitem').AsInteger then
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

procedure TFrmMPST010.N21Click(Sender: TObject);
begin
  inherited;
  l_SelList.Clear;
  DBGridEh1.Repaint;
end;

procedure TFrmMPST010.N22Click(Sender: TObject);
var
  tmpJitem: Integer;
  P: TBookMark;
begin
  inherited;
  CheckLock;
  tmpJitem := CDS.FieldByName('Jitem').AsInteger;
  P := CDS.GetBookmark;
  CDS.DisableControls;
  try
    while not CDS.Bof do
    begin
      CDS.Prior;
      if tmpJitem = CDS.FieldByName('Jitem').AsInteger then
        P := CDS.GetBookmark
      else
        Break;
    end;

    CDS.GotoBookmark(P);
    while not CDS.Eof do
    begin
      if tmpJitem = CDS.FieldByName('Jitem').AsInteger then
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

procedure TFrmMPST010.N23Click(Sender: TObject);
begin
  inherited;
  CheckLock;
  FrmEmptyFlagEdit := TFrmEmptyFlagEdit.Create(nil);
  try
    FrmEmptyFlagEdit.ShowModal;
  finally
    FreeAndNil(FrmEmptyFlagEdit);
  end;
end;

procedure TFrmMPST010.PopupMenu2Popup(Sender: TObject);
begin
  inherited;
  //DBGridEh3.Tag=0單選 1多選
  N24.Visible := CDS3.Active and (not CDS3.IsEmpty);
  N28.Visible := N24.Visible;
  N29.Visible := N24.Visible;
  N30.Visible := N24.Visible;

  //單選和有權限才允許實際刪除
  N28.Enabled := g_MInfo^.R_edit and (DBGridEh3.Tag = 0);
end;

procedure TFrmMPST010.N24Click(Sender: TObject);
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

procedure TFrmMPST010.N28Click(Sender: TObject);
var
  fstCode, tmpSQL: string;
begin
  inherited;
  if (not CDS3.Active) or CDS3.IsEmpty then
    Exit;

  if CDS3.State in [dsInsert, dsEdit] then
    CDS3.Post;

  if ShowMsg('確定要刪除此筆資料嗎?', 33) = IDOK then
  begin
    fstCode := LeftStr(CDS3.FieldByName('ErrorId').AsString, 1);
    tmpSQL := Copy(CDS3.FieldByName('ErrorId').AsString, 2, 100);
    if fstCode = 'A' then
      tmpSQL := 'Delete From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) +
        ' And ErrorFlag=1 And simuver+''@''+Cast(citem as varchar(10))=' + Quotedstr(tmpSQL)
    else  //B
      tmpSQL := 'Delete From MPS012 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And NotVisible=1 And ' + g_mps012pk + '=' +
        Quotedstr(tmpSQL);
    if PostBySQL(tmpSQL) then
      CDS3.Delete;
  end;
end;

procedure TFrmMPST010.N29Click(Sender: TObject);
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

procedure TFrmMPST010.DBGridEh3TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS3, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST010.N30Click(Sender: TObject);
var
  tmpMachine: string;
  tmpDate: TDateTime;
  tmpBoiler: Integer;
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
  tmpBoiler := CDS3.FieldByName('boiler1').AsInteger;

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
        if tmpBoiler > 0 then
          FieldByName('boiler1').AsInteger := tmpBoiler;
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

procedure TFrmMPST010.N26Click(Sender: TObject);
begin
  inherited;
  CheckLock;
  if not Assigned(FrmStealnoEdit) then
    FrmStealnoEdit := TFrmStealnoEdit.Create(Application);
  with FrmStealnoEdit do
  begin
    Label1.Caption := Self.DBGridEh1.FieldColumns['stealno'].Title.Caption + '：';
    Label2.Caption := Self.DBGridEh1.FieldColumns['premark'].Title.Caption + '：';
    Label3.Caption := Self.DBGridEh1.FieldColumns['premark2'].Title.Caption + '：';
    Label4.Caption := Self.DBGridEh1.FieldColumns['premark3'].Title.Caption + '：';
    Edit1.Text := Self.CDS.FieldByName('stealno').AsString;
    Edit2.Text := Self.CDS.FieldByName('premark').AsString;
    Edit3.Text := Self.CDS.FieldByName('premark2').AsString;
    Edit4.Text := Self.CDS.FieldByName('premark3').AsString;
  end;
  if FrmStealnoEdit.ShowModal = mrOk then
  begin
    if (CDS.FieldByName('stealno').AsString = Trim(FrmStealnoEdit.Edit1.Text)) and (CDS.FieldByName('premark').AsString
      = Trim(FrmStealnoEdit.Edit2.Text)) and (CDS.FieldByName('premark2').AsString = Trim(FrmStealnoEdit.Edit3.Text))
      and (CDS.FieldByName('premark3').AsString = Trim(FrmStealnoEdit.Edit4.Text)) then
      Exit;

    CDS.Edit;
    CDS.FieldByName('stealno').AsString := FrmStealnoEdit.Edit1.Text;
    CDS.FieldByName('premark').AsString := FrmStealnoEdit.Edit2.Text;
    CDS.FieldByName('premark2').AsString := FrmStealnoEdit.Edit3.Text;
    CDS.FieldByName('premark3').AsString := FrmStealnoEdit.Edit4.Text;
    CDS.Post;
    if not CDSPost(CDS, p_TableName) then
      if CDS.ChangeCount > 0 then
        CDS.CancelUpdates;
  end;
end;

procedure TFrmMPST010.N27Click(Sender: TObject);
var
  tmpMsg: string;
begin
  inherited;
  CheckLock;
  if CDS.FieldByName('Adcode').AsInteger = 0 then
    tmpMsg := '當前鍋次為空鍋,刪除可能會造成鋼板丟失!' + #13#10;
  tmpMsg := tmpMsg + '確定要刪除嗎?';
  if ShowMsg(tmpMsg, 33) = IdCancel then
    Exit;

  CDS.Delete;
  if CDSPost(CDS, p_TableName) then
  begin
    RefreshColor;
    l_SelList.Clear;
    DBGridEh1.Repaint;
    ShowMsg('刪除完畢!', 64);
  end
  else if CDS.ChangeCount > 0 then
    CDS.CancelUpdates;
end;

procedure TFrmMPST010.CDS3BeforePost(DataSet: TDataSet);
begin
  inherited;
  if not l_Ans then
    if not DataSet.FieldByName('sdate1').IsNull then
      if DataSet.FieldByName('sdate1').AsDateTime < Date then
      begin
        ShowMsg('[%s]不能小於當前日期', 48, MyStringReplace(DBGridEh3.FieldColumns['sdate1'].Title.Caption));
        Abort;
      end;
end;

procedure TFrmMPST010.DBGridEh3DblClick(Sender: TObject);
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

procedure TFrmMPST010.btn_exportClick(Sender: TObject);
var
  tmpCDS: TClientDataSet;
begin
  //inherited;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    SetCCLStruct(tmpCDS, g_UInfo^.Bu, 'materialno', 'struct', 'machine');
      //最后一個參數是PNL載切方式,排程都是排大板,此欄位不需要
    GetExportXls(tmpCDS, p_TableName);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST010.btn_mpst010UClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST010_UpdateWono) then
    FrmMPST010_UpdateWono := TFrmMPST010_UpdateWono.Create(Application);
  FrmMPST010_UpdateWono.ShowModal;
end;

// 檢查混料 lxj
procedure TFrmMPST010.CheckMater();
var
  preStealNo: string;
  preMaterialNo: string;
  curStealNo: string;
  curMaterialNo: string;
  tips: string;
  tmpCDS: TClientDataSet;
begin

  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS.Data := CDS.Data;

  l_CheckMater_RecNo.Clear;

  preStealNo := '';
  preMaterialNo := '';
  curStealNo := '';
  curMaterialNo := '';

  g_ProgressBar.Visible := True;
  g_ProgressBar.Position := 0;
  g_ProgressBar.Max := tmpCDS.RecordCount;

  try
    with tmpCDS do
    begin
      IndexFieldNames := 'Machine;Jitem;spy;OZ;Materialno;Simuver;Citem';

      Filtered := False;
      if RG1.ItemIndex <> -1 then
        Filter := 'errorflag<>1 and machine=' + Quotedstr(RG1.Items[RG1.ItemIndex]);
      Filtered := True;

      DisableControls;
      Application.ProcessMessages;

      First;
      while not Eof do
      begin

        curStealNo := FieldByName('stealno').AsString;
        curMaterialNo := FieldByName('materialno').AsString;

        // 同鍋
        if (SameText(curStealNo, preStealNo)) then
        begin

          // 忽略第一碼
          //if(SameText(copy(curMaterialNo,1,1),copy(preMaterialNo,1,1)))then
          //begin
          if (SameText(copy(curMaterialNo, 2, 1), copy(preMaterialNo, 2, 1))) then
          begin // 第二碼相同

            if (SameText(copy(curMaterialNo, 2, 13), copy(preMaterialNo, 2, 13))) then
              if (not SameText(copy(curMaterialNo, 15, 1), copy(preMaterialNo, 15, 1))) then
              begin
                tips := tips + '第 ' + inttostr(RecNo - 1) + ' 行與第 ' + inttostr(RecNo) + ' 行' + #13#10;
                l_CheckMater_RecNo.Add(inttostr(RecNo - 1));
                l_CheckMater_RecNo.Add(inttostr(RecNo));
              end;
          end
          else
          begin // 第二碼不相同

            if (SameText(copy(curMaterialNo, 4, 12), copy(preMaterialNo, 4, 12))) then
            begin
              tips := tips + '第 ' + inttostr(RecNo - 1) + ' 行與第 ' + inttostr(RecNo) + ' 行' + #13#10;
              l_CheckMater_RecNo.Add(inttostr(RecNo - 1));
              l_CheckMater_RecNo.Add(inttostr(RecNo));
            end;

          end;
          //end;

        end;

        preStealNo := FieldByName('stealno').AsString;
        preMaterialNo := FieldByName('materialno').AsString;

        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        Next;
      end;

      if (length(tips) > 0) then
        ShowMsg(tips + #13#10 + '物料易混用，請注意！', 48);

    end;
  finally
    g_ProgressBar.Visible := False;
    DBGridEh1.Repaint;
    tmpCDS.EnableControls;
    FreeAndNil(tmpCDS);
  end;
end;

// 整理混料 lxj
procedure TFrmMPST010.btnCheckMaterReviewClick(Sender: TObject);
var
  preStealNo: string;
  preMaterialNo: string;
  curStealNo: string;
  curMaterialNo: string;
  total_999: Integer; // 默認一個記錄數，讓記錄始終排列在最後一行

begin
  inherited;

  if (not CDS.Active) or CDS.IsEmpty then
    Exit;
//  i:=0;
//  while i < RG1.Items.Count do
//  begin
//    RG1.ItemIndex:=i;
  l_CheckMater_RecNo.Clear;

  total_999 := 9999;

  preStealNo := '';
  preMaterialNo := '';
  curStealNo := '';
  curMaterialNo := '';

  g_ProgressBar.Visible := True;
  g_ProgressBar.Position := 0;
  g_ProgressBar.Max := CDS.RecordCount;

  try
    with CDS do
    begin

      DisableControls;
      Application.ProcessMessages;

      First;
      while not Eof do
      begin

        curStealNo := FieldByName('stealno').AsString;
        curMaterialNo := FieldByName('materialno').AsString;

        // 同鍋
        if (SameText(curStealNo, preStealNo)) then
        begin//aaa
          // 忽略第一碼
          //if(SameText(copy(curMaterialNo,1,1),copy(preMaterialNo,1,1)))then
          //begin
          if (SameText(copy(curMaterialNo, 2, 1), copy(preMaterialNo, 2, 1))) then
          begin // 第二碼相同

            if (SameText(copy(curMaterialNo, 2, 13), copy(preMaterialNo, 2, 13))) then
              if (not SameText(copy(curMaterialNo, 15, 1), copy(preMaterialNo, 15, 1))) then
              begin
                Edit;
                FieldByName('spy').AsInteger := RecNo + total_999; // 讓記錄排在最後一行
                Post;
              end;
          end
          else
          begin // 第二碼不相同

            if (SameText(copy(curMaterialNo, 4, 12), copy(preMaterialNo, 4, 12))) then
            begin
              Edit;
              FieldByName('spy').AsInteger := RecNo + total_999;  // 讓記錄排在最後一行
              Post;
            end;
          end;
          //end;

        end; //aaa

        preStealNo := FieldByName('stealno').AsString;
        preMaterialNo := FieldByName('materialno').AsString;

        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        Next;
      end;

      CDSPost(CDS, p_TableName);

    end;
  finally
    g_ProgressBar.Visible := False;
    CDS.EnableControls;
    CheckMater();
    CDS.Filtered := true;
  end;
//    inc(i);
//  end;

end;

procedure TFrmMPST010.N6Click(Sender: TObject);
var
  i, tmpJitem: Integer;
  tmpStr: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  tmpSC1, tmpSimuver1, tmpCitem1: string;
  tmpSC2, tmpSimuver2, tmpCitem2: string;
  reno: array[0..2] of Integer;
begin
  inherited;

  Application.ProcessMessages;

  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if (l_SelList.Count <> 2) then
  begin
    ShowMsg('僅可以選擇同一鍋的兩條記錄！', 48);
    exit;
  end;

  // 判斷是否為同一鍋
  tmpStr := '';
  tmpJitem := -1;

  for i := 0 to l_SelList.Count - 1 do
  begin
    if tmpStr <> '' then
      tmpStr := tmpStr + ',';
    tmpStr := tmpStr + Quotedstr(l_SelList.Strings[i])
  end;

  tmpStr := 'Select distinct Jitem,stealno From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
    ' And Simuver+''@''+Cast(Citem as varchar(10)) in (' + tmpStr + ')';
  if not QueryBySQL(tmpStr, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.RecordCount <> 1 then
    begin
      ShowMsg('請選擇同一鍋的兩條記錄！', 48);
      Exit;
    end
    else
    begin
      while not tmpCDS.Eof do
      begin
        tmpJitem := tmpCDS.FieldByName('Jitem').AsInteger;
        tmpCDS.Next;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  reno[0] := 0;
  reno[1] := 0;
  reno[2] := 0;

  CDS.First;

  // a1. 獲取第一條記錄的行號
  if CDS.Locate('Jitem', VarArrayOf([tmpJitem]), []) then
    reno[0] := CDS.RecNo;

  // a2. 獲取第一條選定記錄的行號
  tmpSC1 := l_SelList.Strings[0];
  tmpSimuver1 := copy(tmpSC1, 1, pos('@', tmpSC1) - 1);
  tmpCitem1 := copy(tmpSC1, pos('@', tmpSC1) + 1, (length(tmpSC1) - pos('@', tmpSC1)));

  if CDS.Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, tmpSimuver1, tmpCitem1]), []) then
    reno[1] := CDS.RecNo;

  // a3. 獲取第二條選定記錄的行號
  tmpSC2 := l_SelList.Strings[1];
  tmpSimuver2 := copy(tmpSC2, 1, pos('@', tmpSC2) - 1);
  tmpCitem2 := copy(tmpSC2, pos('@', tmpSC2) + 1, (length(tmpSC2) - pos('@', tmpSC2)));

  if CDS.Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, tmpSimuver2, tmpCitem2]), []) then
    reno[2] := CDS.RecNo;

  CDS.First;

  // b1. 固定目前的排序
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    with tmpCDS do
    begin
      IndexFieldNames := 'Machine;Jitem;spy;OZ;Materialno;Simuver;Citem';
      Filtered := False;
      if RG1.ItemIndex <> -1 then
        Filter := 'Jitem=' + inttostr(tmpJitem) + ' and errorflag<>1 and machine=' + Quotedstr(RG1.Items[RG1.ItemIndex]);
      Filtered := True;

      g_ProgressBar.Visible := True;
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := tmpCDS.RecordCount;

      while not Eof do
      begin
        CDS.Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, FieldByName('Simuver').AsString, FieldByName('Citem').AsInteger]),
          []);
        CDS.Edit;
        CDS.FieldByName('spy').AsInteger := reno[0];
        CDS.Post;
        reno[0] := reno[0] + 1;
        g_ProgressBar.Position := g_ProgressBar.Position + 1;
        Next;
      end;

      CDSPost(CDS, p_TableName);
    end;
  finally
    FreeAndNil(tmpCDS);
    l_SelList.Clear;
    DBGridEh1.Repaint;
    g_ProgressBar.Visible := False;
  end;
  

  // b2. 調整排序
  try
    with CDS do
    begin
      DisableControls;
      g_ProgressBar.Visible := True;
      g_ProgressBar.Position := 0;
      g_ProgressBar.Max := 100;

      First;
      g_ProgressBar.Position := 20;
      if Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, tmpSimuver1, tmpCitem1]), []) then
      begin
        Edit;
        FieldByName('spy').AsInteger := reno[2];
        Post;
      end;

      g_ProgressBar.Position := 60;
      if Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, tmpSimuver2, tmpCitem2]), []) then
      begin
        Edit;
        FieldByName('spy').AsInteger := reno[1];
        Post;
      end;
      g_ProgressBar.Position := 80;

      CDSPost(CDS, p_TableName);
      g_ProgressBar.Position := 100;
    end;
  finally
    g_ProgressBar.Visible := False;
    CDS.First;
    CDS.EnableControls;
    CDS.Locate('Jitem;Simuver;Citem', VarArrayOf([tmpJitem, tmpSimuver1, tmpCitem1]), [])
  end;

end;

procedure TFrmMPST010.DBGridEh3Columns4UpdateData(Sender: TObject; var Text: string; var Value: Variant; var UseText,
  Handled: Boolean);
begin
  inherited;
  // longxinjue 2022.01.07 排制數量小於訂單數量，則為零
  if (strtofloat(Text) <= CDS3.FieldByName('sQty').AsFloat) then
    CDS3.FieldByName('regulateQty').AsFloat := 0
  else
    CDS3.FieldByName('regulateQty').AsFloat := strtofloat(Text) - CDS3.FieldByName('orderQty').AsFloat;
end;

procedure TFrmMPST010.Button1Click(Sender: TObject);
begin
  inherited;
  N27Click(nil);
end;

procedure TFrmMPST010.btn_mpst010VClick(Sender: TObject);
var
  tmpStr, tmpSql: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  OrdWono: TOrderWono;
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('已確認排程無資料!', 48);
    Exit;
  end;

  if ShowMsg('確定產生重工工單嗎?', 33) = IdCancel then
    Exit;

  SetBtnEnabled(False);
  tmpSql := '';
  tmpCDS := TClientDataSet.Create(nil);
  cds.DisableControls;
  try
    tmpCDS.data := cds.Data;
    tmpCDS.First;                
    {(*}
    tmpSql := 'select oeb01,oeb03,oeb04,oeb12,oea04 from oea_file,oeb_file where oea01=oeb01 and ' +
              'oeb01='''+CDS.FieldByName('orderno').AsString + ''' and ' +
              'oeb03='+CDS.FieldByName('orderitem').AsString + ' and ' +
              'oeb04<>'''+CDS.FieldByName('Materialno').AsString + '''';
    {*)}

    if not querybysql(tmpSql, Data, 'ORACLE') then
      exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('沒有需要重工的工單');
      exit;
    end;

    tmpStr := '';

    OrdWono.Machine := '';
    OrdWono.Pno := tmpCDS.FieldByName('oeb04').AsString;
    OrdWono.Custno := UpperCase(tmpCDS.FieldByName('oea04').AsString);
    OrdWono.Adhesive := Copy(OrdWono.Pno, 2, 1);
    OrdWono.Premark := '';
    OrdWono.Sqty := CDS.fieldbyname('sqty').AsFloat;
    OrdWono.sfa03 := CDS.fieldbyname('materialno').asstring;
    OrdWono.IsDG := true;
    OrdWono.Orderno := tmpCDS.FieldByName('oeb01').AsString;
    OrdWono.Orderitem := tmpCDS.FieldByName('oeb03').AsString;

    if not Assigned(l_MPST010_Wono) then
      l_MPST010_Wono := TMPST010_Wono.Create;

    if not l_MPST010_Wono.Init(OrdWono.IsDG) then
        Exit;

    if l_MPST010_Wono.SetWono(OrdWono, tmpStr, '51F') then
    begin
      cds.edit;
      cds.FieldByName('Premark2').AsString := cds.FieldByName('Premark2').AsString+ ' ' +tmpStr;
      cds.FieldByName('Premark2').AsString := trim(cds.FieldByName('Premark2').AsString);
      cds.post;
    end;

    if CDSPost(CDS, p_TableName) then
    begin
      if l_MPST010_Wono.Post(OrdWono.IsDG) then
      begin
        if Self.CDS.ChangeCount > 0 then
          Self.CDS.MergeChangeLog;

        l_SelList.Clear;

        if not Assigned(FrmMPST020_WonoList) then
          FrmMPST020_WonoList := TFrmMPST020_WonoList.Create(Self);
        FrmMPST020_WonoList.Memo1.Text := '自動產生工單完畢,工單單號：' + tmpStr;
        FrmMPST020_WonoList.ShowModal;
      end
      else
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        if not CDSPost(CDS, p_TableName) then
        begin
          ShowMsg('產生工單失敗,下列工單號碼請手動刪除!' + tmpStr, 48);
          Exit;
        end;
      end;
    end;
  finally
    SetBtnEnabled(True);
    g_StatusBar.Panels[0].Text := '';
    FreeAndNil(tmpCDS);
    cds.EnableControls;
  end;
end;

//procedure TFrmMPST010.btn_mpst010VClick(Sender: TObject);
//var
//  i, j: Integer;
//  tmpStr, tmpSql, tmpAllWono, filterStr,filterCDS: string;
//  Data: OleVariant;
//  tmpCDS,updCDS: TClientDataSet;
//  OrdWono: TOrderWono;
//begin
//  if (not CDS.Active) or CDS.IsEmpty then
//  begin
//    ShowMsg('已確認排程無資料!', 48);
//    Exit;
//  end;
//
//  if ShowMsg('確定產生重工工單嗎?', 33) = IdCancel then
//    Exit;
//
//  SetBtnEnabled(False);
//  tmpSql := '';
//  tmpCDS := TClientDataSet.Create(nil);
//  cds.DisableControls;
//  filterStr := cds.Filter;
//  try
//    tmpCDS.data := cds.Data;
//    tmpCDS.First;                
//    while not tmpCDS.Eof do
//    begin    {(*}
//      if ((pos('51F-', tmpcds.FieldByName('Premark2').AsString) = 0) and
//         ( pos('51F-', tmpcds.FieldByName('Premark3').AsString) = 0)) and
//          (tmpcds.FieldByName('machine').AsString <> 'L6') and
//          (copy(tmpcds.FieldByName('Materialno').AsString,14,1)='3') and
//          (tmpcds.FieldByName('wono').AsString <> '') and
//          (tmpcds.FieldByName('Materialno1').AsString = '') then
//        tmpSql := tmpSql + 'or(oeb01='''+tmpCDS.FieldByName('orderno').AsString + '''' +
//                           ' and oeb03='+tmpCDS.FieldByName('orderitem').AsString +
//                           ' and oeb04<>'''+tmpCDS.FieldByName('Materialno').AsString + ''')';    {*)}
//      tmpCDS.Next;
//    end;
//    if tmpsql='' then
//    begin
//      ShowMsg('沒有需要重工的工單');
//      exit;
//    end;
//
//    delete(tmpSql, 1, 2);
//
//    tmpSql := 'select oeb01,oeb03,oeb04,oeb12,oea04 from oea_file,oeb_file where oea01=oeb01 and (' +
//      tmpSql + ')';
//    Data := null;
//    if not querybysql(tmpSql, Data, 'ORACLE') then
//      exit;
//    tmpCDS.Data := Data;
//    if tmpCDS.IsEmpty then
//    begin
//      ShowMsg('沒有需要重工的工單');
//      exit;
//    end;
//
//    tmpStr := '';
//
//    i := 1;
//    tmpAllWono := '';
//
//    tmpCDS.First;
//    cds.Filtered:=false;
//    while not tmpCDS.Eof do
//    begin
//      cds.First;
//      while not cds.eof do
//      begin    {(*}
//        if (cds.FieldByName('bu').AsString='ITEQDG') and
//           (cds.FieldByName('orderno').AsString=tmpCDS.FieldByName('oeb01').AsString) and
//           (cds.FieldByName('orderitem').AsString=tmpCDS.FieldByName('oeb03').AsString) and
//           (pos('51F',cds.FieldByName('Premark2').AsString)=0) then       {*)}
//        begin
//          OrdWono.Machine := '';
//          OrdWono.Pno := tmpCDS.FieldByName('oeb04').AsString;
//          OrdWono.Custno := UpperCase(tmpCDS.FieldByName('oea04').AsString);
//          OrdWono.Adhesive := Copy(OrdWono.Pno, 2, 1);
//          OrdWono.Premark := ''; //FieldByName('Premark').AsString + FieldByName('Premark2').AsString;
//          OrdWono.Sqty := CDS.fieldbyname('sqty').AsFloat;
//          OrdWono.sfa03 := CDS.fieldbyname('materialno').asstring;
//          OrdWono.IsDG := true;
//          OrdWono.Orderno := tmpCDS.FieldByName('oeb01').AsString;
//          OrdWono.Orderitem := tmpCDS.FieldByName('oeb03').AsString;
//
//          if not Assigned(l_MPST010_Wono) then
//            l_MPST010_Wono := TMPST010_Wono.Create;
//
//          if i = 1 then
//            if not l_MPST010_Wono.Init(OrdWono.IsDG) then
//              Exit;
//
//          tmpStr := '  ' + IntToStr(i) + '/' + IntToStr(tmpCDS.RecordCount);
//          if l_MPST010_Wono.SetWono(OrdWono, tmpStr, '51F') then
//          begin
//            tmpAllWono := tmpAllWono + #13#10 + tmpStr;
//            cds.edit;
//            cds.FieldByName('Premark2').AsString := cds.FieldByName('Premark2').AsString+ ' ' +tmpStr;
//            cds.FieldByName('Premark2').AsString := trim(cds.FieldByName('Premark2').AsString);
//            cds.post;
//          end;
//          Inc(i);
//        end;
//        cds.next;
//      end;
//      tmpCDS.Next;
//    end;
//
//
//    if not Assigned(l_MPST010_Wono) then
//    begin
//      ShowMsg('沒有需要重工的工單');
//      exit;
//    end;
//
////    if CDSPost(CDS, p_TableName) then
////    begin
////      if l_MPST010_Wono.Post(OrdWono.IsDG) then
////      begin
////        if Self.CDS.ChangeCount > 0 then
////          Self.CDS.MergeChangeLog;
////
////        l_SelList.Clear;
////
////        if not Assigned(FrmMPST020_WonoList) then
////          FrmMPST020_WonoList := TFrmMPST020_WonoList.Create(Self);
////        FrmMPST020_WonoList.Memo1.Text := '自動產生工單完畢,工單單號：' + tmpAllWono;
////        FrmMPST020_WonoList.ShowModal;
////      end
////      else
////      begin
////        if CDS.ChangeCount > 0 then
////          CDS.CancelUpdates;
////        if not CDSPost(CDS, p_TableName) then
////        begin
////          ShowMsg('產生工單失敗,下列工單號碼請手動刪除!' + tmpAllWono, 48);
////          Exit;
////        end;
////      end;
////    end;
//
//  finally
//    SetBtnEnabled(True);
//    g_StatusBar.Panels[0].Text := '';
//    FreeAndNil(tmpCDS);
//    cds.Filter := filterStr;
//    cds.Filtered := true;
//    cds.EnableControls;
//  end;
//end;

procedure TFrmMPST010.SetBtnEnabled(bool: Boolean);
begin
  btn_mpst010U.Enabled := bool;
end;



function TFrmMPST010.IsCuston(code: string): boolean;
begin
 //
end;

end.

