unit unDLII430_planlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls,
  DBClient, StrUtils, Math, CommCtrl;

type
  TFrmDLII430_planlist = class(TFrmSTDI051)
    Lv1: TListView;
    Label1: TLabel;
    Dtp: TDateTimePicker;
    LB: TListBox;
    btn_query: TBitBtn;
    Edit1: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure LBClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Lv1DblClick(Sender: TObject);
  private
    l_CurIndex:Integer;
    procedure SetLvText;
    procedure GetKBCnt(Custno:string; var CCLKBCnt,PPKBCnt:Integer);
    function GetCnt(Custno:string):string;
    { Private declarations }
  public
    l_Id:Integer;
    l_Date:TDateTime;
    { Public declarations }
  end;

var
  FrmDLII430_planlist: TFrmDLII430_planlist;

implementation

uses unGlobal, unCommon, unDLII430_units;

{$R *.dfm}

//設置ListView值
procedure TFrmDLII430_planlist.SetLvText;
var
  str:string;
begin
  inherited;
  str:=Trim(Edit1.Text);
  if str<>'0' then
  if StrToIntDef(str, 0)=0 then
     Exit;

  if l_CurIndex=0 then
     Lv1.Selected.Caption := str
  else
     Lv1.Selected.SubItems[l_CurIndex - 1] := str;

  Lv1.Selected.SubItems[6] := IntToStr(StrToInt(Lv1.Selected.SubItems[4]) + StrToInt(Lv1.Selected.SubItems[5]));
end;

//計算棧板數
procedure TFrmDLII430_planlist.GetKBCnt(Custno:string; var CCLKBCnt,PPKBCnt:Integer);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  CCLKBCnt:=0;
  PPKBCnt:=0;
  
  tmpSQL:='Select Pno,Notcount1 From DLI010'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(l_Date))
         +' And Custno='+Quotedstr(Custno)
         +' And Len(IsNull(Dno_ditem,''''))=0 And IsNull(GarbageFlag,0)=0'
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;

    with tmpCDS do
    while not tmpCDS.Eof do
    begin
      if Pos(UpperCase(LeftStr(Fields[0].AsString,1)),'ET')>0 then
      begin
        if Length(Fields[0].AsString)=17 then
        begin
          tmpSQL:=Copy(Fields[0].AsString,3,4);
          if tmpSQL<='0120' then
             CCLKBCnt:=CCLKBCnt+Ceil((Ceil(Fields[1].AsFloat/30))/20)    //30張一包，20包一個棧板，下同
          else if tmpSQL<='0240' then
             CCLKBCnt:=CCLKBCnt+Ceil((Ceil(Fields[1].AsFloat/20))/25)
          else if tmpSQL<='0360' then
             CCLKBCnt:=CCLKBCnt+Ceil((Ceil(Fields[1].AsFloat/15))/25)
          else if tmpSQL<='0590' then
             CCLKBCnt:=CCLKBCnt+Ceil((Ceil(Fields[1].AsFloat/10))/25)
          else
             CCLKBCnt:=CCLKBCnt+Ceil((Ceil(Fields[1].AsFloat/5))/30);
        end else
          CCLKBCnt:=CCLKBCnt+1;
      end else
      begin
        if Length(Fields[0].AsString)=18 then
           PPKBCnt:=PPKBCnt+Ceil(Fields[1].AsFloat/12)
        else
           PPKBCnt:=PPKBCnt+1;
      end;

      Next;
    end;

  finally
    tmpCDS.Free;
  end;
end;

//取已建立車次次數
function TFrmDLII430_planlist.GetCnt(Custno:string):string;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  Result:='0';
  tmpSQL:='Select Count(Id) Cnt From DLI430'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(l_Date))
         +' And CharIndex('+Quotedstr(Custno)+',Custno)>0';
  if not QueryOneCR(tmpSQL, Data) then
     Exit;
  Result:=VarToStr(Data);
end;

procedure TFrmDLII430_planlist.FormCreate(Sender: TObject);
begin
  inherited;
  Self.Caption:=Self.Caption+CheckLang('[CCL棧板數、PP棧板數、卡位數欄位可雙擊修改]');
  Dtp.Date:=Date;
  with Lv1.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('項次');
      Width:=40;
    end;
    with Add do
    begin
      Caption:=CheckLang('時間');
      Width:=50;
    end;
    with Add do
    begin
      Caption:=CheckLang('客戶編號');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('客戶簡稱');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('車次');
      Width:=50;
    end;
    with Add do
    begin
      Caption:=CheckLang('CCL棧板數');
      Width:=75;
    end;
    with Add do
    begin
      Caption:=CheckLang('PP棧板數');
      Width:=75;
    end;
    with Add do
    begin
      Caption:=CheckLang('總棧板數');
      Width:=75;
    end;
    with Add do
    begin
      Caption:=CheckLang('卡位數');
      Width:=75;
    end;
    EndUpdate;
  end;
end;

procedure TFrmDLII430_planlist.btn_queryClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpSQL:='Select Pathname From DLI410'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(Dtp.Date))
         +' Order By Stime';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  l_Date:=Dtp.Date;
  LB.Items.BeginUpdate;
  LB.Clear;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if LB.Items.IndexOf(FieldByName('Pathname').AsString)=-1 then
         LB.Items.Add(FieldByName('Pathname').AsString);
      Next;
    end;
  finally
    LB.Items.EndUpdate;
    tmpCDS.Free;
  end;
end;

procedure TFrmDLII430_planlist.LBClick(Sender: TObject);
var
  i,j,CCLKBCnt,PPKBCnt:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  List1,List2:TStrings;
begin
  inherited;
  if LB.ItemIndex=-1 then
     Exit;

  tmpSQL:='Select * From DLI410 Where Bu='+Quotedstr(g_UInfo^.BU)
        +' And Indate='+Quotedstr(DateToStr(l_Date))
        +' And Pathname='+Quotedstr(LB.Items.Strings[LB.ItemIndex])
        +' Order By Stime';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  i:=0;
  Lv1.Items.BeginUpdate;
  List1:=TStringList.Create;
  List2:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    Lv1.Items.Clear;
    while not tmpCDS.Eof do
    begin
      List1.DelimitedText:=tmpCDS.FieldByName('Custno').AsString;
      List2.DelimitedText:=tmpCDS.FieldByName('Custshort').AsString;

      for j:=0 to List1.Count-1 do
      begin
        Inc(i);
        CCLKBCnt:=0;
        PPKBCnt:=0;
        tmpSQL:=List1.Strings[j]; //客戶編號
        GetKBCnt(tmpSQL, CCLKBCnt, PPKBCnt);
        with Lv1.Items.Add do
        begin
          Caption:=IntToStr(i);
          SubItems.Add(tmpCDS.FieldByName('Stime').AsString);
          SubItems.Add(tmpSQL);
          SubItems.Add(List2.Strings[j]);
          SubItems.Add(GetCnt(tmpSQL));
          SubItems.Add(IntToStr(CCLKBCnt));
          SubItems.Add(IntToStr(PPKBCnt));
          SubItems.Add(IntToStr(CCLKBCnt+PPKBCnt));
          SubItems.Add('0');
        end;
      end;
      tmpCDS.Next;
    end;
  finally
    List1.Free;
    List2.Free;
    Lv1.Items.EndUpdate;
    tmpCDS.Free;
  end;
end;

procedure TFrmDLII430_planlist.btn_okClick(Sender: TObject);
var
  Rec:TDLI430Rec;
  i,MaxId:Integer;
  tmpSQL,tmpStime,tmpCustno,tmpCustshort:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpStime:='';
  for i:=0 to Lv1.Items.Count-1 do
  begin
    with Lv1.Items[i] do
    if Checked then
    begin
      tmpStime:=SubItems[0];
      tmpCustno:=tmpCustno+','+SubItems[1];
      tmpCustshort:=tmpCustshort+','+SubItems[2];
      //CCLKBCnt:=CCLKBCnt+StrToIntDef(SubItems[4],0);
      //PPKBCnt:=PPKBCnt+StrToIntDef(SubItems[5],0);
      //SlotCnt:=SlotCnt+StrToIntDef(SubItems[7],0);
    end;
  end;

  if tmpStime='' then
  begin
    ShowMsg('請選擇客戶!', 48);
    Exit;
  end;

  if ShowMsg('確定產生車次嗎?', 33)=IdCancel then
     Exit;

  tmpSQL:='Select Top 1 * From DLI430 Where Bu='+Quotedstr(g_UInfo^.BU)
        +' And Indate='+Quotedstr(DateToStr(l_Date))
        +' Order By Id Desc';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       MaxId:=1
    else
       MaxId:=tmpCDS.FieldByName('Id').AsInteger+1;

    while not tmpCDS.IsEmpty do
      tmpCDS.Delete;
    if tmpCDS.ChangeCount>0 then
       tmpCDS.MergeChangeLog;
       
    Delete(tmpCustno,1,1);
    Delete(tmpCustshort,1,1);
    Rec:=GetCustnoDetail(l_Date, tmpCustno);
    with tmpCDS do
    begin
      Append;
      FieldByName('Bu').AsString:=g_UInfo^.BU;
      FieldByName('Indate').AsDateTime:=l_Date;
      FieldByName('Id').AsInteger:=MaxId;
      FieldByName('Cno').AsString:=FormatDateTime('YYYYMMDD',l_Date)+RightStr(IntToStr((10000+MaxId)),2);
      FieldByName('Stime').AsString:=tmpStime;
      FieldByName('Pathname').AsString:=LB.Items.Strings[LB.ItemIndex];
      FieldByName('Custno').AsString:=tmpCustno;
      FieldByName('Custshort').AsString:=tmpCustshort;
      FieldByName('TotCnt').AsInteger:=Rec.TotCnt;
      FieldByName('FinCnt').AsInteger:=Rec.FinCnt;
      FieldByName('CCLSH1').AsFloat:=Rec.CCLSH1;
      FieldByName('CCLSH2').AsFloat:=Rec.CCLSH2;
      FieldByName('CCLPNL1').AsFloat:=Rec.CCLPNL1;
      FieldByName('CCLPNL2').AsFloat:=Rec.CCLPNL2;
      FieldByName('PPRL1').AsFloat:=Rec.PPRL1;
      FieldByName('PPRL2').AsFloat:=Rec.PPRL2;
      FieldByName('PPPNL1').AsFloat:=Rec.PPPNL1;
      FieldByName('PPPNL2').AsFloat:=Rec.PPPNL2;
      FieldByName('CCLKBCnt').Clear;      //=CCLKBCnt
      FieldByName('PPKBCnt').Clear;       //=PPKBCnt
      FieldByName('JiaoKBCnt').Clear;     //=SlotCnt
      FieldByName('SlotCnt').Clear;
      FieldByName('RLCnt').Clear;      
      FieldByName('SHCnt').Clear;
      FieldByName('HighSpeed').AsBoolean:=False;
      FieldByName('State').AsString:=CheckLang('備貨中');
      //FieldByName('Carno').AsString:='車號';
      //FieldByName('StdSlotCnt').AsInteger:=0;
      FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      FieldByName('Idate').AsDateTime:=Now;
      Post;
    end;

    if not CDSPost(tmpCDS, 'DLI430') then
       Exit;

    l_Id:=MaxId;
    
  finally
    tmpCDS.Free;
  end;

  inherited;
end;

procedure TFrmDLII430_planlist.Edit1Change(Sender: TObject);
begin
  inherited;
  SetLvText;
end;

procedure TFrmDLII430_planlist.Edit1Exit(Sender: TObject);
begin
  inherited;
  SetLvText;
  Edit1.Visible := False;
end;

procedure TFrmDLII430_planlist.Lv1DblClick(Sender: TObject);
var
  W, X, nCount: Integer;
  Rect: TRect;
  Pos: TPoint;
  nCol: Integer;
begin
  inherited;
  if not Assigned(Lv1.Selected) then  //未選中
     Exit;

  W:=0;
  Pos := Lv1.ScreenToClient(Mouse.CursorPos);
  nCount := Lv1.Columns.Count;
  X := -GetScrollPos(Lv1.Handle, SB_HORZ);

  for nCol := 0 to nCount - 1 do
  begin
    W := ListView_GetColumnWidth(Lv1.Handle, nCol);
    if Pos.X <= X + W then
       Break;
    X := X + W
  end;

  l_CurIndex := nCol;
  if (not (nCol in [5,6,8])) or (nCol>Lv1.Selected.SubItems.Count) then
     Exit;

  if X < 0 then
  begin
    W := W + X;
    X := 0;
  end;

  Rect := Lv1.Selected.DisplayRect(drBounds);
  Pos.X := X;
  Pos.Y := Rect.Top;

  MapWindowPoints(Lv1.Handle, Handle, Pos, 1);

  Edit1.SetBounds(Pos.X-Lv1.Left, Pos.Y, W, Rect.Bottom- Rect.Top + 3);

  Edit1.Parent := Lv1;
  Edit1.Top := Lv1.Selected.Top;
  if l_CurIndex=0 then
     Edit1.Text := Lv1.Selected.Caption
  else
     Edit1.Text := Lv1.Selected.SubItems[l_CurIndex-1];
  Edit1.Visible := True;
  Edit1.SetFocus;
end;

end.
