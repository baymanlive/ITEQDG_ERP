{*******************************************************}
{                                                       }
{                unMPSR090_CallDate                     }
{                Author: kaikai                         }
{                Create date: 2016/05/23                }
{                Description: Call貨日期、數量拆分      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR090_CallDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, Mask, DBCtrlsEh, ExtCtrls, ImgList, Buttons,
  DBClient;

type
  TFrmMPSR090_CallDate = class(TFrmSTDI051)
    Edit1: TEdit;
    Edit3: TEdit;
    Edit5: TEdit;
    lblqty: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Dtp1: TDBDateTimeEditEh;
    Dtp2: TDBDateTimeEditEh;
    Dtp3: TDBDateTimeEditEh;
    Label7: TLabel;
    Edit2: TEdit;
    Edit4: TEdit;
    Edit6: TEdit;
    Chk1: TCheckBox;
    Chk2: TCheckBox;
    Chk3: TCheckBox;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function CheckData:Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR090_CallDate: TFrmMPSR090_CallDate;

implementation

uses  unGlobal, unCommon, unMPSR090;

{$R *.dfm}

function TFrmMPSR090_CallDate.CheckData:Boolean;
var
  Cnt:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  TotQty:Double;
begin
  Result:=False;
  Cnt:=0;
  TotQty:=0;

  //1
  if Chk1.Checked then
  begin
    if (Trim(Edit1.Text)='') or VarIsNull(Dtp1.Value) then
    begin
      ShowMsg('第1筆數量、Call貨日期不能為空!', 48);
      Exit;
    end else
    begin
      if StrToFloatDef(Edit1.Text,-1)<0 then
      begin
        Edit1.SetFocus;
        ShowMsg('第1筆[數量]請輸入數字!', 48);
        Exit;
      end;

      if Dtp1.Value<Date then
      begin
        Dtp1.SetFocus;
        ShowMsg('第1筆[Call貨日期]不能小當前日期!', 48);
        Exit;
      end;
    end;

    Inc(Cnt);
    TotQty:=StrToFloat(Edit1.Text);
  end;

  //2
  if Chk2.Checked then
  begin
    if (Trim(Edit3.Text)='') or VarIsNull(Dtp2.Value) then
    begin
      ShowMsg('第2筆數量、Call貨日期不能為空!', 48);
      Exit;
    end else
    begin
      if StrToFloatDef(Edit3.Text,-1)<0 then
      begin
        Edit3.SetFocus;
        ShowMsg('第2筆[數量]請輸入數字!', 48);
        Exit;
      end;

      if Dtp2.Value<Date then
      begin
        Dtp2.SetFocus;
        ShowMsg('第2筆[Call貨日期]不能小當前日期!', 48);
        Exit;
      end;
    end;

    Inc(Cnt);
    TotQty:=TotQty+StrToFloat(Edit3.Text);
  end;

  //3
  if Chk3.Checked then
  begin
    if (Trim(Edit5.Text)='') or VarIsNull(Dtp3.Value) then
    begin
      ShowMsg('第3筆數量、Call貨日期不能為空!', 48);
      Exit;
    end else
    begin
      if StrToFloatDef(Edit5.Text,-1)<0 then
      begin
        Edit5.SetFocus;
        ShowMsg('第3筆[數量]請輸入數字!', 48);
        Exit;
      end;

      if Dtp3.Value<Date then
      begin
        Dtp3.SetFocus;
        ShowMsg('第3筆[Call貨日期]不能小當前日期!', 48);
        Exit;
      end;
    end;

    Inc(Cnt);
    TotQty:=TotQty+StrToFloat(Edit5.Text);
  end;

  if Cnt<2 then
  begin
    ShowMsg('請選擇拆分筆數≧2筆!', 48);
    Exit;
  end;

  if TotQty<>FrmMPSR090.CDS.FieldByName('Qty').AsFloat then
  begin
    ShowMsg('拆分後數量合計'+FloatToStr(TotQty)+'≠總數量'
      +FloatToStr(FrmMPSR090.CDS.FieldByName('Qty').AsFloat)+'!', 48);
    Exit;
  end;

  tmpSQL:='Select Indate From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate>='+Quotedstr(DateToStr(Date));
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;

    if Chk1.Checked then
    if tmpCDS.Locate('Indate', Dtp1.Value, []) then
    begin
      Dtp1.SetFocus;
      ShowMsg('第1筆此[Call貨日期]出貨表已確認,不可拆分為此日期!', 48);
      Exit;
    end;

    if Chk2.Checked then
    if tmpCDS.Locate('Indate', Dtp2.Value, []) then
    begin
      Dtp2.SetFocus;
      ShowMsg('第2筆此[Call貨日期]出貨表已確認,不可拆分為此日期!', 48);
      Exit;
    end;

    if Chk3.Checked then
    if tmpCDS.Locate('Indate', Dtp3.Value, []) then
    begin
      Dtp3.SetFocus;
      ShowMsg('第3筆此[Call貨日期]出貨表已確認,不可拆分為此日期!', 48);
      Exit;
    end;
  finally
    tmpCDS.Free;
  end;

  Result:=True;
end;

procedure TFrmMPSR090_CallDate.FormCreate(Sender: TObject);
begin
  inherited;
  Chk1.Caption:='1.';
  Chk2.Caption:='2.';
  Chk3.Caption:='2.';
end;

procedure TFrmMPSR090_CallDate.FormShow(Sender: TObject);
begin
  inherited;
  Label7.Caption:=CheckLang('總數量：'+FloatToStr(FrmMPSR090.CDS.FieldByName('Qty').AsFloat)
                   +'  生管達交日期：'+DateToStr(FrmMPSR090.CDS.FieldByName('Adate').AsDateTime));
  Chk1.Checked:=False;
  Chk2.Checked:=False;
  Chk3.Checked:=False;
  Edit1.Clear;
  Edit2.Clear;
  Edit3.Clear;
  Edit4.Clear;
  Edit5.Clear;
  Edit6.Clear;
  Dtp1.Clear;
  Dtp2.Clear;
  Dtp3.Clear;
end;

procedure TFrmMPSR090_CallDate.btn_okClick(Sender: TObject);
var
  i:Integer;
  isLock: Boolean;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  if not CheckData then
     Exit;

  if not CheckLockProc(IsLock, 'MPST040') then
     Exit;

  if IsLock then
  begin
    ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
    Exit;
  end;

  if ShowMsg('確認拆分嗎?', 33)=IdCancel then
     Exit;

  tmpSQL:='Select * From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Ditem='+IntToStr(FrmMPSR090.CDS.FieldByName('Ditem').AsInteger);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('此單據不存在,請確認!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('Flag').AsInteger=1 then
    begin
      ShowMsg('此單據已排出貨,不可更改!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('Qty').AsFloat<>FrmMPSR090.CDS.FieldByName('Qty').AsFloat then
    begin
      ShowMsg('此單據數量已被更改,請確認!', 48);
      Exit;
    end;

    //更新、插入資料
    //3筆之中至少有2筆是選中,按順序最前面1筆更新,第3筆一定是新增
    tmpCDS2.Data:=Data;
    if Chk1.Checked then
    begin
      tmpCDS1.Edit;
      tmpCDS1.FieldByName('Qty').AsFloat:=StrToFloat(Edit1.Text);
      tmpCDS1.FieldByName('CDate').AsDateTime:=Dtp1.Value;
      tmpCDS1.FieldByName('Remark2').AsString:=Trim(Edit2.Text);
      tmpCDS1.FieldByName('Muser').AsString:=g_UInfo^.UserId;
      tmpCDS1.FieldByName('Mdate').AsDateTime:=Now;
      tmpCDS1.Post;
    end;

    if Chk2.Checked then
    begin
      if Chk1.Checked then
      begin
        tmpCDS1.Append;
        for i:=0 to tmpCDS2.FieldCount -1 do
           tmpCDS1.Fields[i].Value:=tmpCDS2.Fields[i].Value;
        tmpCDS1.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
        tmpCDS1.FieldByName('Idate').AsDateTime:=Now;
      end else
      begin
        tmpCDS1.Edit;
        tmpCDS1.FieldByName('Muser').AsString:=g_UInfo^.UserId;
        tmpCDS1.FieldByName('Mdate').AsDateTime:=Now;
      end;

      tmpCDS1.FieldByName('Qty').AsFloat:=StrToFloat(Edit3.Text);
      tmpCDS1.FieldByName('CDate').AsDateTime:=Dtp2.Value;
      tmpCDS1.FieldByName('Remark2').AsString:=Trim(Edit4.Text);
      tmpCDS1.Post;
    end;

    if Chk3.Checked then
    begin
      tmpCDS1.Append;
      for i:=0 to tmpCDS2.FieldCount -1 do
         tmpCDS1.Fields[i].Value:=tmpCDS2.Fields[i].Value;
      tmpCDS1.FieldByName('Qty').AsFloat:=StrToFloat(Edit5.Text);
      tmpCDS1.FieldByName('CDate').AsDateTime:=Dtp3.Value;
      tmpCDS1.FieldByName('Remark2').AsString:=Trim(Edit6.Text);
      tmpCDS1.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      tmpCDS1.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS1.Post;
    end;

    //流水號
    Data:=null;
    tmpSQL:='Select ISNULL(Max(Ditem),0) Ditem From MPS200'
           +' Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;
    i:=StrToIntDef(VarToStr(Data),0);
    with tmpCDS1 do
    begin
      First;
      Next;  //第1筆不變
      while not Eof do
      begin
        Inc(i);
        Edit;
        FieldByName('Ditem').AsInteger:=i;
        Post;
        Next;
      end;
    end;

    //提交
    if not CDSPost(tmpCDS1, 'MPS200') then
       Exit;

    //刷新作業畫面資料
    tmpCDS2.Data:=FrmMPSR090.CDS.Data;
    tmpCDS2.EmptyDataSet;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      tmpCDS2.Append;
      for i:=0 to FrmMPSR090.CDS.FieldCount-1 do
          tmpCDS2.Fields[i].Value:=FrmMPSR090.CDS.Fields[i].Value;
      tmpCDS2.FieldByName('Ditem').Value:=tmpCDS1.FieldByName('Ditem').Value;
      tmpCDS2.FieldByName('Qty').Value:=tmpCDS1.FieldByName('Qty').Value;
      tmpCDS2.FieldByName('CDate').Value:=tmpCDS1.FieldByName('CDate').Value;
      tmpCDS2.FieldByName('Remark2').Value:=tmpCDS1.FieldByName('Remark2').Value;
      tmpCDS2.Post;
      tmpCDS1.Next;
    end;
    tmpCDS2.MergeChangeLog;
    FrmMPSR090.CDS.Data:=tmpCDS2.Data;
    ShowMsg('拆分完畢!',64);
    
  finally
    tmpCDS1.Free;
    tmpCDS2.Free;
  end;

  inherited;
end;

end.
