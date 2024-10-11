unit unIPQCT510;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, TeEngine, Series,
  TeeProcs, Chart, StdCtrls, Buttons, Mask, DBCtrlsEh, ComCtrls, ExtCtrls,
  ImgList, ToolWin, DBGridEhImpExp, StrUtils, DateUtils, Math;

type
  TFrmIPQCT510 = class(TFrmSTDI080)
    PCL: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Chart1: TChart;
    Series1: TLineSeries;
    Edit3: TEdit;
    Edit4: TEdit;
    dtp1: TDBDateTimeEditEh;
    dtp2: TDBDateTimeEditEh;
    btn_ipqct510A: TBitBtn;
    lb: TListBox;
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    CDS1: TClientDataSet;
    DS1: TDataSource;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    SaveDialog100: TSaveDialog;
    IdTCPClient1: TIdTCPClient;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure lbClick(Sender: TObject);
    procedure btn_ipqct510AClick(Sender: TObject);
    procedure Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_OldX,l_OldY,l_CrossHCount:Integer;
    l_dataList,l_headList:TStrings;
    l_ms:TMemoryStream;
    l_CDS:TClientDataSet;
    procedure InitObj(num:Integer);
    procedure SetCDSField(xList:TStrings);
    procedure SetCDSValue(xList:TStrings; xObjName:string);
    procedure SetChartValue(xIndex:Integer; initDtp:Boolean);
    function GetValue0(value0:string):TDateTime;
  public
    { Public declarations }
  end;

var
  FrmIPQCT510: TFrmIPQCT510;

implementation

uses unGlobal, unCommon, unIPQCT510_units, unIPQCT510_query;

const l_strSpeed='速度';

{$R *.dfm}

//初始化num:0~4
procedure TFrmIPQCT510.InitObj(num:Integer);
var
  fList:TStrings;

  procedure LoadTxtFile(objIndex:Integer;txtName:string);
  var
    txtPath:string;
    i:Integer;
  begin
    g_ArrMachine[num].Machine:='T'+IntToStr(num+1);
    g_ArrMachine[num].ArrObj[objIndex].Name:=txtName;

    txtPath:=g_UInfo^.SysPath+'PLC\'+g_ArrMachine[num].Machine+'\'+txtName+'.txt';
    if not FileExists(txtPath) then
       Exit;

    fList.LoadFromFile(txtPath);
    SetLength(g_ArrMachine[num].ArrObj[objIndex].ArrAddr, fList.Count);
    for i:=0 to fList.Count-1 do
      g_ArrMachine[num].ArrObj[objIndex].ArrAddr[i].Name:=Copy(fList.Strings[i],1,Pos(',',fList.Strings[i])-1);
  end;

begin
  fList:=TStringList.Create;
  //順序不可改變
  LoadTxtFile(0,'爐溫監控');
  LoadTxtFile(1,'風機頻率');
  LoadTxtFile(2,'張力檢測');
  LoadTxtFile(3,'粘度');
  LoadTxtFile(4,'速度');
  //順序不可改變
  FreeAndNil(fList);
end;

procedure TFrmIPQCT510.SetCDSField(xList:TStrings);
var
  i:Integer;
  f,xml:string;
begin
  xml:='<FIELD attrname="value0" fieldtype="string" WIDTH="20"/>';
  for i:=1 to xList.Count-1 do
  begin
    f:='value'+IntToStr(i);
    xml:=xml+'<FIELD attrname="'+f+'" fieldtype="r8"/>';
  end;
  xml:='<?xml version="1.0" standalone="yes"?>'
      +'<DATAPACKET Version="2.0">'
      +'<METADATA><FIELDS>'+xml+'</FIELDS><PARAMS/></METADATA>'
      +'<ROWDATA></ROWDATA>'
      +'</DATAPACKET>';
  InitCDS(l_CDS,xml);
  for i:=0 to xList.Count-1 do
    l_CDS.Fields[i].DisplayLabel:=xList.Strings[i];
end;

procedure TFrmIPQCT510.SetCDSValue(xList:TStrings; xObjName:string);
var
  i:Integer;
  s:string;
begin
  //20171129105631 => 2017-11-29 10:56:31
  s:=xList.Strings[0];
  if DateSeparator='-' then
     s:=Copy(s,1,4)+'-'+Copy(s,5,2)+'-'+Copy(s,7,2)+' '+Copy(s,9,2)+':'+Copy(s,11,2)+':'+Copy(s,13,2)
  else
     s:=Copy(s,1,4)+'/'+Copy(s,5,2)+'/'+Copy(s,7,2)+' '+Copy(s,9,2)+':'+Copy(s,11,2)+':'+Copy(s,13,2);
  l_CDS.Append;
  l_CDS.Fields[0].Value:=s;
  for i:=1 to xList.Count-1 do
  begin
    if SameText(xObjName, l_strSpeed) then
       l_CDS.Fields[i].Value:=StrToInt(xList.Strings[i])/100
    else
       l_CDS.Fields[i].Value:=StrToInt(xList.Strings[i])/10;
  end;
  l_CDS.Post;
end;

procedure TFrmIPQCT510.SetChartValue(xIndex:Integer;initDtp:Boolean);
var
  y,m,d,cnt:Integer;
  v,minv,maxv,totv:Double;
  sTitle:string;
begin
  Series1.Active:=False;
  Series1.Clear;
  Chart1.LeftAxis.Automatic:=True;
  Chart1.Title.Text.Text:=lb.Hint+' - nothing';
  if (not l_CDS.Active) or l_CDS.IsEmpty then
     Exit;

  y:=YearOf(l_CDS.Fields[0].AsDateTime);
  m:=MonthOf(l_CDS.Fields[0].AsDateTime);
  d:=DayOf(l_CDS.Fields[0].AsDateTime);
  l_CDS.First;
  if initDtp or (dtp1.Value<EncodeDate(2010,1,1)) then
  begin
    if DateSeparator='-' then
       dtp1.Value:=IntToStr(y)+'-'+IntToStr(m)+'-'+IntToStr(d)+' 00:00:00'
    else
       dtp1.Value:=IntToStr(y)+'/'+IntToStr(m)+'/'+IntToStr(d)+' 00:00:00';
  end;
  if initDtp or (dtp2.Value<EncodeDate(2010,1,1)) then
  begin
    if DateSeparator='-' then
       dtp2.Value:=IntToStr(y)+'-'+IntToStr(m)+'-'+IntToStr(d)+' 23:59:59'
    else
       dtp2.Value:=IntToStr(y)+'/'+IntToStr(m)+'/'+IntToStr(d)+' 23:59:59';
  end;
  v:=l_CDS.Fields[xIndex+1].Value;
  minv:=v;
  maxv:=v;
  totv:=0;
  cnt:=0;
  while not l_CDS.Eof do
  begin
    if GetValue0(l_CDS.Fields[0].AsString)<dtp1.Value then
    begin
      l_CDS.Next;
      Continue;
    end;

    if GetValue0(l_CDS.Fields[0].AsString)>dtp2.Value then
       Break;
         
    v:=l_CDS.Fields[xIndex+1].Value;
    if v>500 then
    begin
      l_CDS.Next;
      Continue;
    end;

    Inc(cnt);
    if v<minv then minv:=v;
    if v>maxv then maxv:=v;
    totv:=totv+v;

    Series1.Add(v, l_CDS.Fields[0].Value);
    l_CDS.Next;
  end;
  sTitle:=lb.Hint+' - '+lb.Items.Strings[xIndex]+' [min:'+FloatToStr(minv)+' max:'+FloatToStr(maxv);
  if cnt=0 then
     Chart1.Title.Text.Text:=sTitle+' avg:0]'
  else
     Chart1.Title.Text.Text:=sTitle+' avg:'+FloatToStr(Trunc(totv/cnt))+']';
  Series1.Active:=True;
  Edit3.Text:=FloatToStr(minv);
  Edit4.Text:=FloatToStr(maxv);
end;

function TFrmIPQCT510.GetValue0(value0:string):TDateTime;
begin
  if DateSeparator='-' then
     Result:=StrToDateTime(StringReplace(value0,'/',DateSeparator,[rfReplaceAll]))
  else
     Result:=StrToDateTime(StringReplace(value0,'-',DateSeparator,[rfReplaceAll]));
end;

procedure TFrmIPQCT510.FormCreate(Sender: TObject);
begin
  p_TableName:='IPQC510';

  inherited;

  SetGrdCaption(DBGridEh2, p_TableName);
  TabSheet1.Caption:=CheckLang('曲線圖');
  TabSheet2.Caption:=CheckLang('PLC資料');
  TabSheet3.Caption:=CheckLang('工單資料');
  TabSheet4.Caption:=CheckLang('爐溫波動');
  with DBGridEh3 do
  begin
    FieldColumns['machine'].Title.Caption:=CheckLang('機台');
    FieldColumns['errmemo'].Title.Caption:=CheckLang('日誌');
    FieldColumns['idate'].Title.Caption:=CheckLang('時間');
    FieldColumns['machine'].Width:=50;
    FieldColumns['errmemo'].Width:=400;
    FieldColumns['idate'].Width:=160;
  end;
  Label5.Caption:=CheckLang('日期(起)');
  Label6.Caption:=CheckLang('迄');
  Label3.Caption:=CheckLang('最小值');
  Label4.Caption:=CheckLang('最大值');

  InitObj(0);
  InitObj(1);
  InitObj(2);
  InitObj(3);
  InitObj(4);

  l_dataList:=TStringList.Create;
  l_headList:=TStringList.Create;
  l_ms:=TMemoryStream.Create;
  l_CDS:=TClientDataSet.Create(Self);
  l_OldX:=-1;
end;

procedure TFrmIPQCT510.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CDS1.Active:=False;
  CDS2.Active:=False;
  CDS3.Active:=False;
  l_CDS.Active:=False;
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
  FreeAndNil(l_dataList);
  FreeAndNil(l_headList);
  FreeAndNil(l_ms);
  FreeAndNil(l_CDS);
  IdTCPClient1.Disconnect;
  IdTCPClient1.Free;
end;

procedure TFrmIPQCT510.btn_exportClick(Sender: TObject);
var
  ExpClass: TDBGridEhExportclass;
begin
  inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;
  if SaveDialog100.Execute then
  begin
    ExpClass:=TDBGridEhExportAsHTML;
    SaveDBGridEhToExportFile(ExpClass, DBGridEh1, SaveDialog100.FileName, true);
  end;
end;

procedure TFrmIPQCT510.btn_queryClick(Sender: TObject);
var
  i,j,tmpIndex:Integer;
  isInit,isErr:Boolean;
  tmpSQL,tmpObjName,tmpFDTD1,tmpFDTD2,tmpToday:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  TCPData:TTCPData;
  tmpBuff:array[0..5120] of byte;
  tmpLen,tmpSize:integer;
  tmpD1,tmpD2:TDateTime;
begin
  inherited;
  if not Assigned(FrmIPQCT510_query) then
     FrmIPQCT510_query:=TFrmIPQCT510_query.Create(Application);
  if FrmIPQCT510_query.ShowModal<>mrOK then
     Exit;

  if l_CDS.Active then
     l_CDS.EmptyDataSet;
  if CDS2.Active then
     CDS2.EmptyDataSet;
  if CDS3.Active then
     CDS3.EmptyDataSet;
  g_StatusBar.Panels[1].Text:='';
  isInit:=False;
  tmpIndex:=FrmIPQCT510_query.rgp.ItemIndex;
  tmpObjName:=FrmIPQCT510_query.cbb.Items.Strings[FrmIPQCT510_query.cbb.ItemIndex];
  tmpD1:=FrmIPQCT510_query.dtp1.Date;
  tmpD2:=FrmIPQCT510_query.dtp2.Date;
  tmpFDTD1:=Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,tmpD1),'-','/',[rfReplaceAll]));
  tmpFDTD2:=Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,tmpD2),'-','/',[rfReplaceAll]));
  LB.Items.Clear;
  for i:=Low(g_ArrMachine[tmpIndex].ArrObj) to High(g_ArrMachine[tmpIndex].ArrObj) do
  if SameText(g_ArrMachine[tmpIndex].ArrObj[i].Name, tmpObjName) then
  begin
    for j:=Low(g_ArrMachine[tmpIndex].ArrObj[i].ArrAddr) to High(g_ArrMachine[tmpIndex].ArrObj[i].ArrAddr) do
       LB.Items.Add(g_ArrMachine[tmpIndex].ArrObj[i].ArrAddr[j].Name);
    Break;
  end;
  lb.Hint:=FrmIPQCT510_query.rgp.Items.Strings[tmpIndex];

  //工單資料
  if Length(Trim(FrmIPQCT510_query.Edit1.Text))>0 then
     tmpSQL:='select wono,sno,sdate,edate from IPQC510 where bu='+Quotedstr('ITEQDG')
            +' and machine='+Quotedstr(lb.Hint)
            +' and wono='+Quotedstr(Trim(FrmIPQCT510_query.Edit1.Text))
            +' order by sno'
  else begin
    tmpSQL:='select wono,sno,sdate,edate from IPQC510 where bu='+Quotedstr('ITEQDG')
           +' and machine='+Quotedstr(lb.Hint)
           +' and (convert(varchar(10),sdate,111) between '+tmpFDTD1+' and '+tmpFDTD2
           +' or   convert(varchar(10),edate,111) between '+tmpFDTD1+' and '+tmpFDTD2+')'
           +' order by wono,sno';
  end;
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  CDS2.Data:=Data;

  //爐溫波動
  tmpSQL:='select machine,errmemo,idate from IPQC513 where bu='+Quotedstr('ITEQDG')
         +' and machine='+Quotedstr(lb.Hint)
         +' and (convert(varchar(10),idate,111) between '+tmpFDTD1+' and '+tmpFDTD2
         +' or   convert(varchar(10),idate,111) between '+tmpFDTD1+' and '+tmpFDTD2+')';
  if not QueryBySQL(tmpSQL, Data, 'PLC') then
     Exit;
  CDS3.Data:=Data;

  //不是當天日期保存在資料庫中
  if tmpD1<Date then
  begin
    Data:=null;
    tmpSQL:='select txtfile from IPQC512 where bu='+Quotedstr('ITEQDG')
           +' and machine='+Quotedstr(lb.Hint)
           +' and objname='+Quotedstr(tmpObjName)
           +' and indate between '+Quotedstr(DateToStr(tmpD1))
           +' and '+Quotedstr(DateToStr(tmpD2))
           +' order by indate,ampm';
    if not QueryBySQL(tmpSQL, Data, 'PLC') then
       Exit;

    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        l_ms.Clear;
        TBlobField(tmpCDS.Fields[0]).SaveToStream(l_ms);
        l_ms.Seek(0,soFromBeginning);
        l_dataList.LoadFromStream(l_ms);
        if not isInit then
        begin
          l_headList.DelimitedText:=l_dataList.Strings[0];
          SetCDSField(l_headList);
          isInit:=True;
        end;

        for i:=1 to l_dataList.Count-1 do
        begin
          l_headList.DelimitedText:=l_dataList.Strings[i];
          SetCDSValue(l_headList, tmpObjName);
        end;
        tmpCDS.Next;
      end;
      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  //PLC主機
  if tmpD2>=Date then
  begin
    try
      isErr:=False;
      IdTCPClient1.Disconnect;
      IdTCPClient1.Host:='192.168.4.33';
      //IdTCPClient1.Host:='192.168.5.35';
      IdTCPClient1.Port:=201734;
      IdTCPClient1.Connect(3000);
    except
      g_StatusBar.Panels[1].Text:=CheckLang('服務器連接失敗,'+DateToStr(Date)+'數據無法查詢,請聯絡管理員');
      isErr:=True;
    end;

    if not isErr then
    begin
      FillChar(TCPData,SizeOf(TCPData),#0);
      TCPData.Machine:='getData';
      TCPData.Wono:=IntToStr(tmpIndex);
      TCPData.ObjName:=tmpObjName;
      IdTCPClient1.WriteBuffer(TCPData, SizeOf(TCPData), true);
      IdTCPClient1.ReadBuffer(TCPData, SizeOf(TCPData));
      if SameText(TCPData.Machine, 'setData') then
      begin
        l_ms.Clear;
        l_ms.Seek(0,soFromBeginning);
        tmpLen:=IdTCPClient1.ReadInteger;
        tmpSize:=5120;
        if tmpLen<tmpSize then
           tmpSize:=tmpLen;
        while tmpSize>0 do
        begin
           IdTCPClient1.ReadBuffer(tmpBuff, tmpSize);
           l_ms.Write(tmpBuff, tmpSize);
           Inc(tmpLen, -tmpSize);
           if tmpLen<tmpSize then
              tmpSize:=tmpLen;
        end;
        l_ms.Seek(0,soFromBeginning);
        l_dataList.LoadFromStream(l_ms);
        if not isInit then
        begin
          l_headList.DelimitedText:=l_dataList.Strings[0];
          SetCDSField(l_headList);
        end;

        tmpToday:=FormatDateTime('YYYYMMDD',Date);
        for i:=1 to l_dataList.Count-1 do
        begin
          l_headList.DelimitedText:=l_dataList.Strings[i];
          if LeftStr(l_headList.Strings[0],8)=tmpToday then
             SetCDSValue(l_headList, tmpObjName);
        end;
      end else
      if SameText(TCPData.Machine, 'nothing1') or SameText(TCPData.Machine, 'nothing2') then
         g_StatusBar.Panels[1].Text:=TCPData.Machine;
      IdTCPClient1.Disconnect;
    end;
  end;

  if l_CDS.IsEmpty then
     CDS1.Active:=False
  else begin
     CDS1.Data:=l_CDS.Data;
     for i:=0 to l_CDS.FieldCount-1 do
        CDS1.Fields[i].DisplayLabel:=l_CDS.Fields[i].DisplayLabel;
  end;
  LB.ItemIndex:=0;
  SetChartValue(LB.ItemIndex,True);
  Chart1.Repaint;
end;

procedure TFrmIPQCT510.lbClick(Sender: TObject);
begin
  inherited;
  SetChartValue(LB.ItemIndex,False);
end;

procedure TFrmIPQCT510.btn_ipqct510AClick(Sender: TObject);
var
  xIndex,cnt:Integer;
  v,minv,maxv,totv,minimum,maximum:Double;
  sTitle:string;
begin
  inherited;
  if (not l_CDS.Active) or l_CDS.IsEmpty or (Lb.Items.Count=0) then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  if dtp1.Value>dtp2.Value then
  begin
    ShowMsg('起始日期不能大於截止日期!',48);
    dtp1.SetFocus;
    Exit;
  end;

  l_CDS.First;
  if dtp2.Value<getvalue0(l_CDS.Fields[0].AsString) then
     Exit;
  l_CDS.Last;
  if dtp1.Value>getvalue0(l_CDS.Fields[0].AsString) then
     Exit;

  minimum:=StrToFloatDef(Trim(Edit3.Text),-1);
  maximum:=StrToFloatDef(Trim(Edit4.Text),-1);
  if minimum<0 then
  begin
    ShowMsg('最小值不能小於0!',48);
    Edit3.SetFocus;
    Exit;
  end;
  if maximum<=0 then
  begin
    ShowMsg('最大值不能小於等於0!',48);
    Edit4.SetFocus;
    Exit;
  end;
  if minimum>=maximum then
  begin
    ShowMsg('最大值需大於最小值!',48);
    Edit4.SetFocus;
    Exit;
  end;

  xIndex:=LB.ItemIndex;
  Series1.Active:=False;
  Series1.Clear;
  l_CDS.First;
  v:=l_CDS.Fields[xIndex+1].Value;
  minv:=v;
  maxv:=v;
  totv:=0;
  cnt:=0;
  while not l_CDS.Eof do
  begin
    if GetValue0(l_CDS.Fields[0].AsString)<dtp1.Value then
    begin
      l_CDS.Next;
      Continue;
    end;

    if GetValue0(l_CDS.Fields[0].AsString)>dtp2.Value then
       Break;

    v:=l_CDS.Fields[xIndex+1].Value;
    if v>500 then
    begin
      l_CDS.Next;
      Continue;
    end;

    if v<minv then minv:=v;
    if v>maxv then maxv:=v;
    totv:=totv+v;
    Inc(cnt);
    Series1.Add(v, l_CDS.Fields[0].Value);
    l_CDS.Next;
  end;
  Chart1.LeftAxis.AutomaticMinimum:=False;
  Chart1.LeftAxis.AutomaticMaximum:=False;
  Chart1.LeftAxis.Minimum:=minimum;
  Chart1.LeftAxis.Maximum:=maximum;
  sTitle:=lb.Hint+' - '+lb.Items.Strings[xIndex]+' [min:'+FloatToStr(minv)+' max:'+FloatToStr(maxv);
  if cnt=0 then
     Chart1.Title.Text.Text:=sTitle+' avg:0]'
  else
     Chart1.Title.Text.Text:=sTitle+' avg:'+FloatToStr(Trunc(totv/cnt))+']';
  Series1.Active:=True;                      
end;

procedure TFrmIPQCT510.Chart1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  tmpX, tmpY:Double;

  procedure DrawCross(AX, AY: Integer);
  begin
    with Chart1, Canvas do
    begin
      Pen.Color := clred;
      Pen.Style := psSolid;
      Pen.Mode := pmXor;
      Pen.Width := 1;
      MoveTo(AX, ChartRect.Top - Height3D);
      LineTo(AX, ChartRect.Bottom - Height3D);
      MoveTo(ChartRect.Left + Width3D, AY);
      LineTo(ChartRect.Right + Width3D, AY);
    end;
  end;
begin
  inherited;
  if (l_OldX <> -1) then
  begin
    DrawCross(l_OldX, l_OldY);
    l_OldX := -1;
  end;

  if PtInRect(Chart1.ChartRect, Point(X - Chart1.Width3D, Y + Chart1.Height3D)) then
  begin
    if l_CrossHCount < 3 then
       DrawCross(X, Y);
    if (l_OldY = X) and (l_OldY = Y) then
       Inc(l_CrossHCount)
    else
       l_CrossHCount := 0;
    l_OldX := X;
    l_OldY := Y;
  end;
  Series1.GetCursorValues(tmpX, tmpY);
  g_StatusBar.Panels[1].Text := Series1.GetHorizAxis.LabelValue(RoundTo(tmpY,-1));
end;

end.
