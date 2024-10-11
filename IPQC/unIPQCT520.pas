unit unIPQCT520;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, IdUDPBase, IdUDPServer, Menus, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, StdCtrls, ExtCtrls, TeeProcs,
  TeEngine, Chart, ImgList, ComCtrls, ToolWin, IniFiles, unIPQCT520_units,
  IdSocketHandle, Series;

type
  Tthr=class(TThread)
  private
    TCPData: TTCPData;
  protected
     procedure Execute;override;
  end;

type
  TFrmIPQCT520 = class(TFrmSTDI080)
    Chart1: TChart;
    Chart2: TChart;
    Chart3: TChart;
    Chart4: TChart;
    IdTCPClient1: TIdTCPClient;
    Memo1: TMemo;
    PopupMenu1: TPopupMenu;
    N100: TMenuItem;
    SaveDialog100: TSaveDialog;
    Timer100: TTimer;
    IdUDPServer1: TIdUDPServer;
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure Chart1DblClick(Sender: TObject);
    procedure Chart2DblClick(Sender: TObject);
    procedure Chart3DblClick(Sender: TObject);
    procedure Chart4DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure N100Click(Sender: TObject);
    procedure IdTCPClient1Disconnected(Sender: TObject);
    procedure Timer100Timer(Sender: TObject);
    procedure IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure rgpClick(Sender: TObject);
  private
    l_err:Boolean;
    l_thr:Tthr;
    procedure InitObj(num:Integer);
    function SelectObj(num:Integer; var objstr1,objstr2,objstr3,objstr4,objstr5:string;
      var MinV,MaxV:Double):Boolean;
    procedure RefreshChart(chart:TChart; objstr1,objstr2,objstr3,objstr4,objstr5:string);
    procedure AddChartValue(mIndex,oIndex:Integer; value:string);
    procedure AddMemoLog(mIndex,oIndex:Integer; value:string);
    procedure LoadMonitorObj(num:Integer);
    procedure LoadDefChar;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT520: TFrmIPQCT520;

implementation

uses unGlobal, unCommon, unIPQCT520_selectobj;

const l_strTCPConn='服務器連接失敗,2分鐘後嘗試連接';
const l_strTemp='爐溫監控';
const l_strTempCaption='穩定值:';
const l_strSpeed='速度';

{$R *.dfm}

//線程執行接收數據
procedure Tthr.Execute;
var
  i,j:integer;
  str:string;
begin
  while not Terminated do
  begin
    if FrmIPQCT520.IdTCPClient1.Connected then
    begin
      try
        FrmIPQCT520.IdTCPClient1.ReadBuffer(TCPData, SizeOf(TCPData));
        if Pos(TCPData.Machine,'T1,T2,T3,T4,T5')>0 then
        begin
          for i:=Low(g_ArrMachine) to High(g_ArrMachine) do
          if SameText(g_ArrMachine[i].Machine, TCPData.Machine) then
          begin
            for j:=Low(g_ArrMachine[i].ArrObj) to High(g_ArrMachine[i].ArrObj) do
            if SameText(g_ArrMachine[i].ArrObj[j].Name, TCPData.ObjName) then
            begin
              str:=FormatDateTime('HH:NN:SS', now)+','+TCPData.Data1+TCPData.Data2;
              g_ArrMachine[i].ArrObj[j].DataList.Add(str);
              if g_ArrMachine[i].ArrObj[j].DataList.Count>720 then  //10s一個值,約2小時
                 g_ArrMachine[i].ArrObj[j].DataList.Delete(0);
              FrmIPQCT520.AddChartValue(i, j, str);
              FrmIPQCT520.AddMemoLog(i, j, str);
              Break;
            end;
            Break;
          end;
        end;
      except
      end;
    end;
  end;
end;

//初始化
procedure TFrmIPQCT520.InitObj(num:Integer);
var
  fList:TStrings;

  procedure LoadTxtFile(objIndex:Integer;txtName:string);
  var
    str,txtPath:string;
    i:Integer;
  begin
    g_ArrMachine[num].Machine:='T'+IntToStr(num+1);
    g_ArrMachine[num].ArrObj[objIndex].Name:=txtName;
    g_ArrMachine[num].MonitorObjList:=TStringList.Create;
    g_ArrMachine[num].MonitorDataList:=TStringList.Create;
    g_ArrMachine[num].ArrObj[objIndex].DataList:=TStringList.Create;

    txtPath:=g_UInfo^.SysPath+'PLC\'+g_ArrMachine[num].Machine+'\'+txtName+'.txt';
    if not FileExists(txtPath) then
       Exit;

    fList.LoadFromFile(txtPath);
    SetLength(g_ArrMachine[num].ArrObj[objIndex].ArrAddr, fList.Count);
    for i:=0 to fList.Count-1 do
    begin
      g_ArrMachine[num].ArrObj[objIndex].ArrAddr[i].Name:=Copy(fList.Strings[i],1,Pos(',',fList.Strings[i])-1);
      str:=str+','+StringReplace(g_ArrMachine[num].ArrObj[objIndex].ArrAddr[i].Name,',','',[]);
    end;
    if Length(str)>0 then
       Delete(str,1,1);
    g_ArrMachine[num].ArrObj[objIndex].AllObjName:=str;
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

//選擇顯示項目
function TFrmIPQCT520.SelectObj(num:Integer; var objstr1,objstr2,objstr3,objstr4,objstr5:string; var MinV,MaxV:Double):Boolean;
var
  str:string;

function GetSeriesTitle(chart:TChart):string;
var
  i:Integer;
begin
  Result:='';
  for i:=0 to chart.SeriesCount-1 do
    Result:=Result+','+chart.Series[i].Title;
end;

procedure SetM(chart:TChart);
begin
  if chart.LeftAxis.Automatic then
  begin
    FrmIPQCT520_objselect.l_MinV:=-1;
    FrmIPQCT520_objselect.l_MaxV:=-1;
  end else
  begin
    FrmIPQCT520_objselect.l_MinV:=chart.LeftAxis.Minimum;
    FrmIPQCT520_objselect.l_MaxV:=chart.LeftAxis.Maximum;;
  end;
end;

begin
  Result:=False;
  if not Assigned(FrmIPQCT520_objselect) then
     FrmIPQCT520_objselect:=TFrmIPQCT520_objselect.Create(Application);
  FrmIPQCT520_objselect.l_num:=rgp.ItemIndex;
  case num of
    0:begin
        str:=GetSeriesTitle(Chart1);
        SetM(Chart1);
      end;
    1:begin
        str:=GetSeriesTitle(Chart2);
        SetM(Chart2);
      end;
    2:begin
        str:=GetSeriesTitle(Chart3);
        SetM(Chart3);
      end;
    3:begin
        str:=GetSeriesTitle(Chart4);
        SetM(Chart4);
      end;
  end;
  FrmIPQCT520_objselect.l_def:=str;
  if FrmIPQCT520_objselect.ShowModal=mrOK then
  begin
    MinV:=FrmIPQCT520_objselect.l_MinV;
    MaxV:=FrmIPQCT520_objselect.l_MaxV;
    objstr1:=FrmIPQCT520_objselect.getclb(FrmIPQCT520_objselect.clb1);
    objstr2:=FrmIPQCT520_objselect.getclb(FrmIPQCT520_objselect.clb2);
    objstr3:=FrmIPQCT520_objselect.getclb(FrmIPQCT520_objselect.clb3);
    objstr4:=FrmIPQCT520_objselect.getclb(FrmIPQCT520_objselect.clb4);
    objstr5:=FrmIPQCT520_objselect.getclb(FrmIPQCT520_objselect.clb5);
    Result:=True;
  end;
end;

//重置chart
//objstr1~objstr5:顯示的項目
procedure TFrmIPQCT520.RefreshChart(chart:TChart; objstr1,objstr2,objstr3,objstr4,objstr5:string);
var
  List1,List2,List3:TStrings;

  procedure RefreshX(oIndex:Integer);
  var
    v:Double;
    i,j,mIndex,vIndex,vDiv:Integer;
    ls:TLineSeries;
  begin
    //所有子項目
    mIndex:=rgp.ItemIndex;
    List1.DelimitedText:=g_ArrMachine[mIndex].ArrObj[oIndex].AllObjName;
    //需要顯示的項目
    case oIndex of
      0:List2.DelimitedText:=objstr1;
      1:List2.DelimitedText:=objstr2;
      2:List2.DelimitedText:=objstr3;
      3:List2.DelimitedText:=objstr4;
      4:List2.DelimitedText:=objstr5;
    end;
    for i:=0 to List2.Count-1 do
    begin
      //顯示項目所在位置(數據所在位置)
      vIndex:=List1.IndexOf(List2.Strings[i]);
      if vIndex<>-1 then
      begin
        ls:=TLineSeries.Create(chart);
        ls.Title:=List2.Strings[i];
        ls.LinePen.Width:=2;
        chart.AddSeries(ls);

        vIndex:=vIndex+1;   //第1行是時間
        for j:=0 to g_ArrMachine[mIndex].ArrObj[oIndex].DataList.Count-1 do
        begin
          List3.DelimitedText:=g_ArrMachine[mIndex].ArrObj[oIndex].DataList.Strings[j];   //數據
          if List3.Count>vIndex then
          begin
            if SameText(g_ArrMachine[mIndex].ArrObj[oIndex].Name, l_strSpeed) then
               vDiv:=100
            else
               vDiv:=10;
            v:=StrToInt(List3.Strings[vIndex])/vDiv;
            if v<500 then
               ls.Add(v, List3.Strings[0]);
          end;
        end;
      end;
    end;
  end;

begin
  List1:=TStringList.Create;
  List2:=TStringList.Create;
  List3:=TStringList.Create;
  try
    chart.SeriesList.Clear;
    if Length(objstr1)>0 then
       RefreshX(0);
    if Length(objstr2)>0 then
       RefreshX(1);
    if Length(objstr3)>0 then
       RefreshX(2);
    if Length(objstr4)>0 then
       RefreshX(3);
    if Length(objstr5)>0 then
       RefreshX(4);
  finally
    FreeAndNil(List1);
    FreeAndNil(List2);
    FreeAndNil(List3);
  end;
end;

//添加chart數據
procedure TFrmIPQCT520.AddChartValue(mIndex,oIndex:Integer; value:string);
var
  List1,List2:TStrings;

  procedure AddValue(chart:TChart);
  var
    tmpX,v:Double;
    i,vIndex,vDiv:Integer;
  begin
    //所有子項目
    List1.DelimitedText:=g_ArrMachine[mIndex].ArrObj[oIndex].AllObjName;
    //數據
    List2.DelimitedText:=value;
    for i:=0 to chart.SeriesCount-1 do
    begin
      //是否顯示此項目(數據所在位置)
      vIndex:=List1.IndexOf(chart.Series[i].Title)+1;  //第1行是時間
      if (vIndex>0) and (List2.Count>vIndex) then
      begin
        if SameText(g_ArrMachine[mIndex].ArrObj[oIndex].Name, l_strSpeed) then
           vDiv:=100
        else
           vDiv:=10;
        v:=StrToInt(List2.Strings[vIndex])/vDiv;
        if v<500 then
        begin
          if chart.Series[i].XValues.Count>720 then      //左移
          begin
            tmpX:=chart.Series[i].XValues[1]-chart.Series[i].XValues[0];
            chart.Series[i].Delete(0);
            chart.Series[i].AddXY(chart.Series[i].XValues.Last+tmpX, v, List2.Strings[0])
          end else
            chart.Series[i].Add(v, List2.Strings[0]);
        end;
      end;
    end;
  end;

begin
  if mIndex<>rgp.ItemIndex then
     Exit;

  List1:=TStringList.Create;
  List2:=TStringList.Create;
  try
    if Chart1.SeriesCount>0 then
       AddValue(Chart1);
    if Chart2.SeriesCount>0 then
       AddValue(Chart2);
    if Chart3.SeriesCount>0 then
       AddValue(Chart3);
    if Chart4.SeriesCount>0 then
       AddValue(Chart4);
  finally
    FreeAndNil(List1);
    FreeAndNil(List2);
  end;
end;

//監視項目,添加memo日誌
procedure TFrmIPQCT520.AddMemoLog(mIndex,oIndex:Integer; value:string);
var
  i,vIndex,vDiv:Integer;
  objName,oldValue,newValue:string;
  List1,List2:TStrings;
begin
  if g_ArrMachine[mIndex].MonitorObjList.Count>0 then  //存在監視項目
  begin
    List1:=TStringList.Create;
    List2:=TStringList.Create;
    try
      List1.DelimitedText:=g_ArrMachine[mIndex].ArrObj[oIndex].AllObjName;
      List2.DelimitedText:=value;
      for i:=0 to g_ArrMachine[mIndex].MonitorObjList.Count-1 do
      begin
        objName:=g_ArrMachine[mIndex].MonitorObjList.Strings[i];
        vIndex:=List1.IndexOf(objName)+1;   //第1行是時間
        if vIndex>0 then
        begin
          oldValue:=g_ArrMachine[mIndex].MonitorDataList.Strings[i];//舊值
          newValue:=List2.Strings[vIndex];                          //新值

          if oldValue='-1' then
             g_ArrMachine[mIndex].MonitorDataList.Strings[i]:=newValue
          else if oldValue<>newValue then
          begin
            if SameText(g_ArrMachine[mIndex].ArrObj[oIndex].Name, l_strSpeed) then
               vDiv:=100
            else
               vDiv:=10;
            Memo1.Lines.Add(g_ArrMachine[mIndex].Machine+','+objName
                +',數據發生變化,原值:'+FloatToStr(StrToInt(oldValue)/vDiv)
                +',新值:'+FloatToStr(StrToInt(newValue)/vDiv)
                +','+DateTimeToStr(Now)); //時間:List2.Strings[0]
            g_ArrMachine[mIndex].MonitorDataList.Strings[i]:=newValue;
          end;
        end;
      end;
    finally
      FreeAndNil(List1);
      FreeAndNil(List2);
    end;
  end;
end;

procedure TFrmIPQCT520.LoadMonitorObj(num:Integer);
var
  i:Integer;
  str,iniPath:string;
  ini:TIniFile;
begin
  iniPath:=g_UInfo^.SysPath+'PLC\T'+IntToStr(num+1)+'.ini';
  if not FileExists(iniPath) then
     Exit;

  ini:=TIniFile.Create(iniPath);
  try
    str:=ini.ReadString('MonitorObj','value','');
    if Length(str)>0 then
    begin
      g_ArrMachine[num].MonitorObjList.DelimitedText:=str;
      for i:=0 to g_ArrMachine[num].MonitorObjList.Count-1 do
        g_ArrMachine[num].MonitorDataList.Add('-1'); //默認值
    end;
  finally
    ini.Free;
  end;
end;

procedure TFrmIPQCT520.LoadDefChar;
var
  iniPath,objstr1,objstr2,objstr3,objstr4,objstr5:string;
  ini:TIniFile;
begin
  iniPath:=g_UInfo^.SysPath+'PLC\'+rgp.Items.Strings[rgp.ItemIndex]+'.ini';
  if not FileExists(iniPath) then
     Exit;

  ini:=TIniFile.Create(iniPath);
  try
    objstr1:=ini.ReadString('Chart1','objstr1','');
    objstr2:=ini.ReadString('Chart1','objstr2','');
    objstr3:=ini.ReadString('Chart1','objstr3','');
    objstr4:=ini.ReadString('Chart1','objstr4','');
    objstr5:=ini.ReadString('Chart1','objstr5','');
    RefreshChart(Chart1,objstr1,objstr2,objstr3,objstr4,objstr5);

    objstr1:=ini.ReadString('Chart2','objstr1','');
    objstr2:=ini.ReadString('Chart2','objstr2','');
    objstr3:=ini.ReadString('Chart2','objstr3','');
    objstr4:=ini.ReadString('Chart2','objstr4','');
    objstr5:=ini.ReadString('Chart2','objstr5','');
    RefreshChart(Chart2,objstr1,objstr2,objstr3,objstr4,objstr5);

    objstr1:=ini.ReadString('Chart3','objstr1','');
    objstr2:=ini.ReadString('Chart3','objstr2','');
    objstr3:=ini.ReadString('Chart3','objstr3','');
    objstr4:=ini.ReadString('Chart3','objstr4','');
    objstr5:=ini.ReadString('Chart3','objstr5','');
    RefreshChart(Chart3,objstr1,objstr2,objstr3,objstr4,objstr5);

    objstr1:=ini.ReadString('Chart4','objstr1','');
    objstr2:=ini.ReadString('Chart4','objstr2','');
    objstr3:=ini.ReadString('Chart4','objstr3','');
    objstr4:=ini.ReadString('Chart4','objstr4','');
    objstr5:=ini.ReadString('Chart4','objstr5','');
    RefreshChart(Chart4,objstr1,objstr2,objstr3,objstr4,objstr5);
  finally
    ini.Free;
  end;
end;

procedure TFrmIPQCT520.FormCreate(Sender: TObject);
begin
  inherited;
  ToolBar.Visible:=False;
end;

procedure TFrmIPQCT520.FormShow(Sender: TObject);
begin
  inherited;
  InitObj(0);
  InitObj(1);
  InitObj(2);
  InitObj(3);
  InitObj(4);

  LoadMonitorObj(0);
  LoadMonitorObj(1);
  LoadMonitorObj(2);
  LoadMonitorObj(3);
  LoadMonitorObj(4);
  LoadDefChar;

  Chart1.BufferedDisplay:=True;
  Chart2.BufferedDisplay:=True;
  Chart3.BufferedDisplay:=True;
  Chart4.BufferedDisplay:=True;

  IdTCPClient1.Host:='192.168.4.33';
  //IdTCPClient1.Host:='192.168.5.35';
  IdTCPClient1.Port:=201733;
  try
    IdTCPClient1.Connect(3000);
  except
    Memo1.Lines.Add(CheckLang(l_strTCPConn));
    Timer100.Enabled:=True;
  end;

  IdUDPServer1.ThreadedEvent:=True;
  IdUDPServer1.DefaultPort:=201833;
  try
    IdUDPServer1.Active:=True;
  except
    on E:exception do
    begin
      Memo1.Lines.Add(e.Message);
      l_err:=True;
      Timer100.Enabled:=False;
      IdTCPClient1.Disconnect;
      Exit;
    end;
  end;

  l_thr:=Tthr.Create(True);
  l_thr.FreeOnTerminate:=True;
  l_thr.Resume;
end;

procedure TFrmIPQCT520.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i,j:Integer;
begin
  inherited;

  if not l_err then
  begin
    l_thr.Suspend;
    l_thr.Terminate;
    if Assigned(l_thr) then
       l_thr:=nil;
    IdTCPClient1.Disconnect;
    IdUDPServer1.Active:=False;
  end;
  IdTCPClient1.Free;
  IdUDPServer1.Free;
  for i:=Low(g_ArrMachine) to High(g_ArrMachine) do
  for j:=Low(g_ArrMachine[i].ArrObj) to High(g_ArrMachine[i].ArrObj) do
  begin
    FreeAndNil(g_ArrMachine[i].MonitorObjList);
    FreeAndNil(g_ArrMachine[i].MonitorDataList);
    FreeAndNil(g_ArrMachine[i].ArrObj[j].DataList);
  end;
end;

procedure TFrmIPQCT520.rgpClick(Sender: TObject);
begin
  inherited;
  Chart1.SeriesList.Clear;
  Chart1.Repaint;
  Chart2.SeriesList.Clear;
  Chart2.Repaint;
  Chart3.SeriesList.Clear;
  Chart3.Repaint;
  Chart4.SeriesList.Clear;
  Chart4.Repaint;
  Chart1.LeftAxis.Automatic:=True;
  Chart2.LeftAxis.Automatic:=True;
  Chart3.LeftAxis.Automatic:=True;
  Chart4.LeftAxis.Automatic:=True;
  LoadDefChar;
end;

procedure TFrmIPQCT520.Chart1DblClick(Sender: TObject);
var
  MinV,MaxV:Double;
  objstr1,objstr2,objstr3,objstr4,objstr5:string;
begin
  inherited;
  if SelectObj(0,objstr1,objstr2,objstr3,objstr4,objstr5,MinV,MaxV) then
  begin
    RefreshChart(Chart1, objstr1,objstr2,objstr3,objstr4,objstr5);
    if MinV<>-1 then
    begin
      Chart1.LeftAxis.Automatic:=False;
      Chart1.LeftAxis.Minimum:=MinV;
      Chart1.LeftAxis.Maximum:=MaxV;
    end else
      Chart1.LeftAxis.Automatic:=True;
  end;
end;

procedure TFrmIPQCT520.Chart2DblClick(Sender: TObject);
var
  MinV,MaxV:Double;
  objstr1,objstr2,objstr3,objstr4,objstr5:string;
begin
  inherited;
  if SelectObj(1,objstr1,objstr2,objstr3,objstr4,objstr5,MinV,MaxV) then
  begin
    RefreshChart(Chart2, objstr1,objstr2,objstr3,objstr4,objstr5);
    if MinV<>-1 then
    begin
      Chart2.LeftAxis.Automatic:=False;
      Chart2.LeftAxis.Minimum:=MinV;
      Chart2.LeftAxis.Maximum:=MaxV;
    end else
      Chart2.LeftAxis.Automatic:=True;
  end;
end;

procedure TFrmIPQCT520.Chart3DblClick(Sender: TObject);
var
  MinV,MaxV:Double;
  objstr1,objstr2,objstr3,objstr4,objstr5:string;
begin
  inherited;
  if SelectObj(2,objstr1,objstr2,objstr3,objstr4,objstr5,MinV,MaxV) then
  begin
    RefreshChart(Chart3, objstr1,objstr2,objstr3,objstr4,objstr5);
    if MinV<>-1 then
    begin
      Chart3.LeftAxis.Automatic:=False;
      Chart3.LeftAxis.Minimum:=MinV;
      Chart3.LeftAxis.Maximum:=MaxV;
    end else
      Chart3.LeftAxis.Automatic:=True;
  end;
end;

procedure TFrmIPQCT520.Chart4DblClick(Sender: TObject);
var
  MinV,MaxV:Double;
  objstr1,objstr2,objstr3,objstr4,objstr5:string;
begin
  inherited;
  if SelectObj(3,objstr1,objstr2,objstr3,objstr4,objstr5,MinV,MaxV) then
  begin
    RefreshChart(Chart4, objstr1,objstr2,objstr3,objstr4,objstr5);
    if MinV<>-1 then
    begin
      Chart4.LeftAxis.Automatic:=False;
      Chart4.LeftAxis.Minimum:=MinV;
      Chart4.LeftAxis.Maximum:=MaxV;
    end else
      Chart4.LeftAxis.Automatic:=True;
  end;
end;

procedure TFrmIPQCT520.N100Click(Sender: TObject);
begin
  inherited;
  if SaveDialog100.Execute then
     Memo1.Lines.SaveToFile(SaveDialog100.FileName);
end;

procedure TFrmIPQCT520.IdTCPClient1Disconnected(Sender: TObject);
begin
  inherited;
  if (Timer100.Tag=0) and (not l_err) then
  begin
    Timer100.Enabled:=True;
    Memo1.Lines.Add(CheckLang(l_strTCPConn));
  end;
end;

procedure TFrmIPQCT520.Timer100Timer(Sender: TObject);
begin
  inherited;
  Timer100.Enabled:=False;
  Timer100.Tag:=Timer100.Tag+1;
  try
    IdTCPClient1.Disconnect;
    IdTCPClient1.Connect(3000);
    Memo1.Lines.Add(CheckLang('服務器連接成功,開始接收數據'));
    Timer100.Tag:=0;
  except
    Memo1.Lines.Add(CheckLang(l_strTCPConn+':'+IntToStr(Timer100.Tag)));
    Timer100.Enabled:=True;
  end;
end;

procedure TFrmIPQCT520.IdUDPServer1UDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  len:Integer;
  info:string;
  buf:array [0..255] of byte;
begin
  inherited;
  FillChar(buf[0],Length(buf),#0);
  len:=AData.Size;
  if len>Length(buf) then
     len:=Length(buf);
  AData.ReadBuffer(buf, len);
  SetLength(info, len);
  Move(buf[0], info[1], len);
  Memo1.Lines.Add(PChar(info));
end;

end.
