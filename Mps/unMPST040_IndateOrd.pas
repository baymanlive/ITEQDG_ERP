{*******************************************************}
{                                                       }
{                unMPST040_Indate                       }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: 指定訂單號產生出貨排程    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_IndateOrd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls,
  DBClient, DateUtils, Math, unMPST040_IndateClass;

type
  TFrmMPST040_IndateOrd = class(TFrmSTDI050)
    lblindate: TLabel;
    Dtp1: TDateTimePicker;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    lblorderno: TLabel;
    Edit1: TEdit;
    Lv1: TListView;
    btn_query: TBitBtn;
    Edit2: TEdit;
    Label1: TLabel;
    btn1: TBitBtn;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure Lv1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Edit2Change(Sender: TObject);
    procedure Lv1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure btn1Click(Sender: TObject);
  private
    l_IndateClass:TMPST040_IndateClass;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_IndateOrd: TFrmMPST040_IndateOrd;

implementation

uses unGlobal, unCommon, unMPST040, unMPST040_units;

{$R *.dfm}

procedure TFrmMPST040_IndateOrd.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date+1;
  with Lv1.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('序號');
      Width:=40;
    end;
    with Add do
    begin
      Caption:=CheckLang('項次');
      Width:=40;
    end;
    with Add do
    begin
      Caption:=CheckLang('料號');
      Width:=140;
    end;
    with Add do
    begin
      Caption:=CheckLang('達交日期');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('Call貨日期');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('拆分數量');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('出貨數量');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('已排');
      Width:=40;
      Alignment:=taCenter;
    end;
    with Add do
    begin
      Caption:=CheckLang('生管備註');
      Width:=150;
    end;
    EndUpdate;
  end;
end;

procedure TFrmMPST040_IndateOrd.FormShow(Sender: TObject);
begin
  inherited;
  PCL.ActivePageIndex:=0;
  Memo1.Lines.Clear;
  Edit1.Text:='';
  Edit2.Text:='';
  Lv1.Items.Clear;
end;

procedure TFrmMPST040_IndateOrd.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(l_CDS) then
     FreeAndNil(l_CDS);
  if Assigned(l_IndateClass) then
     FreeAndNil(l_IndateClass);
end;

procedure TFrmMPST040_IndateOrd.btn_queryClick(Sender: TObject);
var
  i:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入訂單號碼!',48);
    Exit;
  end;

  tmpSQL:='Select * From MPS200 Where Orderno='+Quotedstr(Edit1.Text)
        +' And Bu='+Quotedstr(g_UInfo^.BU)
        +' And IsNull(GarbageFlag,0)=0'
        +' Order By Orderitem';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  if not Assigned(l_CDS) then
     l_CDS:=TClientDataSet.Create(Self);

  i:=0;
  Lv1.Items.BeginUpdate;
  try
    l_CDS.Data:=Data;
    Lv1.Items.Clear;
    while not l_CDS.Eof do
    begin
      Inc(i);
      with Lv1.Items.Add do
      begin
        Caption:=IntToStr(i);
        SubItems.Add(IntToStr(l_CDS.FieldByName('Orderitem').AsInteger));
        SubItems.Add(l_CDS.FieldByName('Materialno').AsString);
        if l_CDS.FieldByName('Adate').IsNull then
           SubItems.Add('')
        else
           SubItems.Add(DateToStr(l_CDS.FieldByName('Adate').AsDateTime));
        if l_CDS.FieldByName('Cdate').IsNull then
           SubItems.Add('')
        else
           SubItems.Add(DateToStr(l_CDS.FieldByName('Cdate').AsDateTime));
        SubItems.Add(FloatToStr(l_CDS.FieldByName('Qty').AsFloat));
        SubItems.Add(FloatToStr(l_CDS.FieldByName('Qty').AsFloat));
        if l_CDS.FieldByName('Flag').AsInteger>0 then
           SubItems.Add('V')
        else
           SubItems.Add('X');
        SubItems.Add(l_CDS.FieldByName('Remark1').AsString);
      end;
      l_CDS.Next;
    end;
  finally
    Lv1.Items.EndUpdate;
  end;
end;

procedure TFrmMPST040_IndateOrd.btn_okClick(Sender: TObject);
var
  i:Integer;
  qty1,qty2:Double;
  IsConfirm:Boolean;
  tmpSQL, OutMsg:string;
  ArrOutQty:TArrOutQty;
begin
//  inherited;
  if Dtp1.Date<Date then
  begin
    ShowMsg('出貨日期不能小於當前日期!',48);
    Exit;
  end;

  if (not Assigned(l_CDS)) or (not l_CDS.Active) then
  begin
    ShowMsg('請查詢訂單!',48);
    Exit;
  end;

  tmpSQL:='';
  SetLength(ArrOutQty, l_CDS.RecordCount);
  try
    for i:=0 to Lv1.Items.Count-1 do
    begin
      ArrOutQty[i].ditem:=0;
      ArrOutQty[i].qty:=0;
      if Lv1.Items[i].Checked then
      begin
        if SameText(Lv1.Items[i].SubItems.Strings[6], 'V') then
        begin
          ShowMsg('第'+IntToStr(i+1)+'筆已排出貨,不可重複排!',48);
          Exit;
        end;

        qty1:=StrToFloatDef(Lv1.Items[i].SubItems.Strings[5], 0);
        if qty1<=0 then
        begin
          ShowMsg('第'+IntToStr(i+1)+'筆數量不能是0或小於0!',48);
          Exit;
        end;

        qty2:=StrToFloatDef(Lv1.Items[i].SubItems.Strings[4], 0);
        if qty1>qty2 then
        begin
          ShowMsg('第'+IntToStr(i+1)+'筆出貨數量不能大於拆分數量!',48);
          Exit;
        end;

        l_CDS.RecNo:=i+1;
        tmpSQL:=tmpSQL+l_CDS.FieldByName('Ditem').AsString+',';

        if l_CDS.FieldByName('Qty').AsFloat<>qty1 then //更改了數量,未出完
        begin
          ArrOutQty[i].ditem:=l_CDS.FieldByName('Ditem').AsInteger;
          ArrOutQty[i].qty:=qty1;
        end;
      end;
    end;

    if Length(tmpSQL)=0 then
    begin
      ShowMsg('未選擇資料,請選擇一筆或多筆!',48);
      Exit;
    end;

    IsConfirm:=CheckConfirm(Dtp1.Date);

    //tmpSQL後面有逗號
    tmpSQL:='Select * From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Ditem in ('+tmpSQL+'-100)'
           +' And Isnull(Flag,0)=0 And Qty>0';
    if not Assigned(l_IndateClass) then
       l_IndateClass:=TMPST040_IndateClass.Create;
    l_IndateClass.ArrOutQty:=ArrOutQty;
     showmsg(tmpsql,48);
    if l_IndateClass.Exec(Dtp1.Date, tmpSQL, IsConfirm, OutMsg) then
    begin
      RefreshGrdCaption(FrmMPST040.CDS, FrmMPST040.DBGridEh1,FrmMPST040.l_StrIndex, FrmMPST040.l_StrIndexDesc);
      FrmMPST040.CDS.Data:=l_IndateClass.Data;
      Edit1.Text:=l_CDS.FieldByName('Orderno').AsString;
      btn_queryClick(btn_query);
    end;
    if Length(OutMsg)>0 then
    begin
      Memo1.Lines.Text:=OutMsg;
      PCL.ActivePageIndex:=1;
    end;
  finally
    ArrOutQty:=nil;
  end;
end;

procedure TFrmMPST040_IndateOrd.btn1Click(Sender: TObject);
var
  str:string;
begin
  inherited;
  if Lv1.Selected<>nil then
     str:=Lv1.Selected.SubItems[1];
  GetQueryStock(str, false);
end;

procedure TFrmMPST040_IndateOrd.Lv1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  inherited;
  Edit2.OnChange:=nil;
  Edit2.Text:=Item.SubItems[5];
  Edit2.OnChange:=Edit2Change;
end;

procedure TFrmMPST040_IndateOrd.Edit2Change(Sender: TObject);
begin
  inherited;
  if Lv1.ItemIndex=-1 then
     Exit;
     
  if StrToFloatDef(Trim(Edit2.Text),0)<=0 then
     Lv1.Items.Item[Lv1.ItemIndex].SubItems[5]:='0'
  else
     Lv1.Items.Item[Lv1.ItemIndex].SubItems[5]:=Trim(Edit2.Text);
end;

procedure TFrmMPST040_IndateOrd.Lv1CustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
var
  qty1,qty2:Double;
begin
  inherited;
  qty1:=StrToFloatDef(Item.SubItems[4],0);
  qty2:=StrToFloatDef(Item.SubItems[5],0);
  if (SubItem=6) and ((qty2<=0) or (qty1<qty2)) then
     Sender.Canvas.Font.Color:=clRed
  else
     Sender.Canvas.Font.Color:=clBlack;   
end;

end.
