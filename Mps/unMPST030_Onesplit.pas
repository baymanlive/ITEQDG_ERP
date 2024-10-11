unit unMPST030_Onesplit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ExtCtrls, StdCtrls, ImgList, Buttons, DBClient, StrUtils,
  DateUtils, Math;

type
  TFrmMPST030_Onesplit = class(TFrmSTDI051)
    Monday: TLabel;
    Tuesday: TLabel;
    Wednesday: TLabel;
    Thurday: TLabel;
    Friday: TLabel;
    Saturday: TLabel;
    Sunday: TLabel;
    Month: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    cbb: TComboBox;
    Label2: TLabel;
    Edit43: TEdit;
    Label3: TLabel;
    Edit44: TEdit;
    Label4: TLabel;
    Edit45: TEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;
    Label5: TLabel;
    Edit46: TEdit;
    btn_query: TBitBtn;
    Label7: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbbChange(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
  private
    l_dateList:TStringList;
    procedure SetDayText;
    procedure InitList;
    function MyFormatDate(D:TDateTime):string;
    { Private declarations }
  public
    l_ret:Boolean;
    { Public declarations }
  end;

var
  FrmMPST030_Onesplit: TFrmMPST030_Onesplit;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

//返回YYYYMMDD
function TFrmMPST030_Onesplit.MyFormatDate(D:TDateTime):string;
begin
  Result:=StringReplace(StringReplace(FormatDateTime(g_cShortDate1,D),'/','',[rfReplaceAll]),'-','',[rfReplaceAll]);
end;

procedure TFrmMPST030_Onesplit.SetDayText;
var
  i,week,lstday,v1:Integer;
  y,m,y1,m1:word;
  tmpStr:string;
begin
  tmpStr:=Cbb.Items.Strings[cbb.ItemIndex];
  y:=StrToInt(LeftStr(tmpStr,4));
  m:=StrToInt(RightStr(tmpStr,2));

  //初始化
  for i:=1 to 42 do
  begin
    with TEdit(Self.FindComponent('Edit'+IntToStr(i))) do
    begin
      Tag:=0;
      Color:=clWindow;
    end;
  end;

  //當月
  v1:=0;
  y1:=y;
  m1:=m;
  week:=DayOfTheWeek(Encodedate(y,m,1));                //1號星期几:edit1~edit7
  lstday:=DayOf(EndOfTheMonth(Encodedate(y,m,1)));      //當月天數
  for i:=1 to lstday do
  begin
    v1:=week+i-1;
    with TEdit(Self.FindComponent('Edit'+IntToStr(v1))) do
    begin
      Text:=IntToStr(i);
      Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));   //tag:年月
      if l_dateList.IndexOf(MyFormatDate(EncodeDate(y1,m1,i)))<>-1 then
         Color:=clYellow;
    end;
  end;

  //1號不是星期1:補上個月
  if week>1 then
  begin
    //tag:年月
    if m=1 then
    begin
      y1:=y-1;
      m1:=12;
      lstday:=31;
    end else
    begin
      y1:=y;
      m1:=m-1;
      lstday:=DayOf(EndOfTheMonth(Encodedate(y,m-1,1)));
    end;

    while week>1 do
    begin
      Dec(week);
      with TEdit(Self.FindComponent('Edit'+IntToStr(week))) do
      begin
        Text:=IntToStr(lstday);
        Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));
        if l_dateList.IndexOf(MyFormatDate(EncodeDate(y1,m1,lstday)))<>-1 then
           Color:=clYellow
        else
           Color:=clSilver;
      end;
      Dec(lstday);
    end;
  end;

  //補下個月
  //tag:年月
  if m=12 then
  begin
    y1:=y+1;
    m1:=1;
  end else
  begin
    y1:=y;
    m1:=m+1;
  end;

  week:=1;
  v1:=v1+1;
  for i:=v1 to 42 do          //42個edit
  begin
    with TEdit(Self.FindComponent('Edit'+IntToStr(i))) do
    begin
      Text:=IntToStr(week);
      Tag:=StrToInt(IntToStr(y1)+'0'+IntToStr(m1));
      if l_dateList.IndexOf(MyFormatDate(EncodeDate(y1,m1,week)))<>-1 then
         Color:=clYellow
      else
         Color:=clSilver;
    end;
    Inc(week);
  end;
end;

procedure TFrmMPST030_Onesplit.InitList;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Data:=null;
  tmpSQL:='select adate from mps200 where orderno='+Quotedstr(Edit43.Text)
         +' and orderitem='+IntToStr(StrToIntDef(Edit44.Text,0))
         +' and flag=0 and isnull(garbageflag,0)=0';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    l_dateList.Clear;
    tmpCDS.Data:=Data;
    while not tmpCDS.Eof do
    begin
      if not tmpCDS.Fields[0].IsNull then
         l_dateList.Add(MyFormatDate(tmpCDS.Fields[0].AsDateTime));
      tmpCDS.Next;
    end;
    
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST030_Onesplit.FormCreate(Sender: TObject);
var
  i,y,m:Integer;
begin
  inherited;
  Label1.Caption:=CheckLang('生管達交日期');
  Label2.Caption:=CheckLang('訂單號碼');
  Label3.Caption:=CheckLang('訂單項次');
  Label4.Caption:=CheckLang('未交數量');
  Label5.Caption:=CheckLang('拆分數量');
  Label6.Caption:='';
  Label7.Caption:=CheckLang('點擊日期變為黃色表示選中');
  l_dateList:=TStringList.Create;
  l_dateList.Sorted:=True;
  
  i:=1;
  y:=YearOf(Date);
  m:=MonthOf(Date);
  cbb.Items.Clear;
  cbb.Items.Add(IntToStr(y)+RightStr('0'+IntToStr(m),2));
  while i<6 do
  begin
    m:=m+1;
    if m=13 then
    begin
      y:=y+1;
      m:=1;
    end;
    cbb.Items.Add(IntToStr(y)+RightStr('0'+IntToStr(m),2));
    Inc(i);
  end;
  cbb.ItemIndex:=0;
end;

procedure TFrmMPST030_Onesplit.FormShow(Sender: TObject);
begin
  inherited;
  l_ret:=False;
  if (Length(Trim(Edit43.Text))>0) and (Length(Trim(Edit44.Text))>0) then
     InitList;
  SetDayText;
end;

procedure TFrmMPST030_Onesplit.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_dateList);
end;

procedure TFrmMPST030_Onesplit.cbbChange(Sender: TObject);
begin
  inherited;
  SetDayText;
end;

procedure TFrmMPST030_Onesplit.Edit1Click(Sender: TObject);
var
  y,m,d:word;
  tmpIndex:Integer;
  tmpStr:String;
begin
  inherited;
  with TEdit(Sender) do
  begin
    y:=StrToInt(LeftStr(IntToStr(Tag),4));
    m:=StrToInt(RightStr(IntToStr(Tag),2));
    d:=StrToInt(Text);
  end;

  tmpStr:=MyFormatDate(Encodedate(y,m,d));
  tmpIndex:=l_dateList.IndexOf(tmpStr);
  if tmpIndex=-1 then
  begin
    l_dateList.Add(tmpStr);
    TEdit(Sender).Color:=clYellow;
  end else
  begin
    l_dateList.Delete(tmpIndex);
    if m=StrToInt(RightStr(cbb.Items[cbb.ItemIndex],2)) then
       TEdit(Sender).Color:=clWindow
    else
       TEdit(Sender).Color:=clSilver;
  end;
end;

procedure TFrmMPST030_Onesplit.btn_queryClick(Sender: TObject);
var
  tmpSQL,tmpOrderno,tmpOrderitem:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  tmpOrderno:=Trim(Edit43.Text);
  tmpOrderitem:=Trim(Edit44.Text);

  if Length(tmpOrderno)=0 then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label2.Caption));
    Edit43.SetFocus;
    Exit;
  end;

  if (Length(tmpOrderitem)=0) or (StrToIntDef(tmpOrderitem,0)<=0) then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label3.Caption));
    Edit44.SetFocus;
    Exit;
  end;

  tmpSQL:='select oeb04,oeb12,oeb24,oeb12-oeb24 as qty'
         +' from '+g_UInfo^.BU+'.oea_file,'+g_UInfo^.BU+'.oeb_file'
         +' where oea01=oeb01 and oea01='+Quotedstr(tmpOrderno)
         +' and oeb03='+tmpOrderitem
         +' and oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y'' and oeb12-oeb24>0';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('訂單資料不存在、或未確認、或已結案、或未交數量為0!',48);
      Exit;
    end;

    Edit45.Text:=tmpCDS.Fields[3].AsString;
    Label6.Caption:='料號:'+tmpCDS.Fields[0].AsString+',訂單數量:'+tmpCDS.Fields[1].AsString+',已交數量:'+tmpCDS.Fields[2].AsString+',未交數量:'+tmpCDS.Fields[3].AsString;

    InitList;
    SetDayText;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST030_Onesplit.btn_okClick(Sender: TObject);
var
  y,m,d:Word;
  i,ditem:Integer;
  tmpMaxQty,tmpQty:Double;
  tmpSQL,tmpPno,tmpOrderno,tmpOrderitem:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  //inherited;
  if l_dateList.Count=0 then
  begin
    ShowMsg('未選擇任何日期!',48);
    Exit;
  end;

  for i:=0 to l_dateList.Count-1 do
  begin
    y:=StrToInt(LeftStr(l_dateList.Strings[i],4));
    m:=StrToInt(RightStr(LeftStr(l_dateList.Strings[i],6),2));
    d:=StrToInt(RightStr(l_dateList.Strings[i],2));
    if EncodeDate(y,m,d)<Date then
    begin
      ShowMsg('['+l_dateList.Strings[i]+']不能選擇小于當天日期',48);
      Exit;
    end;
  end;

  tmpOrderno:=Trim(Edit43.Text);
  tmpOrderitem:=Trim(Edit44.Text);
  tmpMaxQty:=StrToIntDef(Trim(Edit45.Text),0);
  tmpQty:=StrToIntDef(Trim(Edit46.Text),0);

  if Length(tmpOrderno)=0 then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label2.Caption));
    Edit43.SetFocus;
    Exit;
  end;

  if (Length(tmpOrderitem)=0) or (StrToIntDef(tmpOrderitem,0)<=0) then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label3.Caption));
    Edit44.SetFocus;
    Exit;
  end;

  if tmpMaxQty<=0 then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label4.Caption));
    Edit45.SetFocus;
    Exit;
  end;

  if tmpQty<=0 then
  begin
    ShowMsg('請輸入[%s]!',48, MyStringReplace(Label5.Caption));
    Edit46.SetFocus;
    Exit;
  end;

  if tmpMaxQty<tmpQty then
  begin
    ShowMsg('[拆分數量]不能大于[未交數量]!',48);
    Edit46.SetFocus;
    Exit;
  end;

  if ShowMsg('確定執行嗎?',33)=IdCancel then
     Exit;

  tmpSQL:='select oeb04,oeb12,oeb24,oeb12-oeb24 as qty'
         +' from '+g_UInfo^.BU+'.oea_file,'+g_UInfo^.BU+'.oeb_file'
         +' where oea01=oeb01 and oea01='+Quotedstr(tmpOrderno)
         +' and oeb03='+tmpOrderitem
         +' and oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y'' and oeb12-oeb24>0';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('訂單資料不存在、或未確認、或已結案、或未交數量為0!',48);
      Exit;
    end;

    tmpPno:=tmpCDS.Fields[0].AsString;
    Label6.Caption:='料號:'+tmpPno+',訂單數量:'+tmpCDS.Fields[1].AsString+',已交數量:'+tmpCDS.Fields[2].AsString+',未交數量:'+tmpCDS.Fields[3].AsString;

    Data:=null;
    tmpSQL:='select * from mps200 where orderno='+Quotedstr(tmpOrderno)
           +' and orderitem='+tmpOrderitem;
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      while not Eof do
      begin
        if (FieldByName('flag').AsInteger=1) and (not FieldByName('adate').IsNull) then
        if l_dateList.IndexOf(MyFormatDate(FieldByName('adate').AsDateTime))<>-1 then
        begin
          ShowMsg('['+DateToStr(FieldByName('adate').AsDateTime)+']已排出貨表!',48);
          Exit;
        end;

        Next;
      end;

      Filtered:=False;
      Filter:='flag<>1';
      Filtered:=True;
      while not IsEmpty do
        Delete;
      Filtered:=False;
    end;

    Data:=null;
    tmpSQL:='select isnull(max(ditem),0)+1 from mps200 where bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR(tmpSQL, Data) then
       ditem:=-1
    else
       ditem:=StrToIntDef(VarToStr(Data),1);

    if ditem=-1 then
    begin
      ShowMsg('取流水號失敗,請重試!',48);
      Exit;
    end;

    for i:=0 to l_dateList.Count-1 do
    begin
      y:=StrToInt(LeftStr(l_dateList.Strings[i],4));
      m:=StrToInt(RightStr(LeftStr(l_dateList.Strings[i],6),2));
      d:=StrToInt(RightStr(l_dateList.Strings[i],2));
      with tmpCDS do
      begin
        Append;
        FieldByName('bu').AsString:=g_UInfo^.BU;
        FieldByName('ditem').AsInteger:=ditem;
        FieldByName('orderno').AsString:=tmpOrderno;
        FieldByName('orderitem').AsString:=tmpOrderitem;
        FieldByName('materialno').AsString:=tmpPno;
        FieldByName('adate').AsDateTime:=EncodeDate(y,m,d);
        if tmpMaxQty>tmpQty then
           FieldByName('qty').AsFloat:=tmpQty
        else
           FieldByName('qty').AsFloat:=tmpMaxQty;
        FieldByName('flag').AsInteger:=0;
        FieldByName('garbageflag').AsBoolean:=False;
        FieldByName('iuser').AsString:=g_UInfo^.UserId;
        FieldByName('idate').AsDateTime:=Now;
        Post;
      end;

      tmpMaxQty:=RoundTo(tmpMaxQty-tmpQty,-4);
      if tmpMaxQty<=0 then
         Break;

      Inc(ditem);
    end;

    if CDSPost(tmpCDS, 'mps200') then
    begin
      l_ret:=True;
      ShowMsg('執行完畢,請返回作業查看結果!',64);
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.
