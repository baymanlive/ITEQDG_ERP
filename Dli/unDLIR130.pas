{*******************************************************}
{                                                       }
{                unDLIR110                              }
{                Author: kaikai                         }
{                Create date: 2017/8/23                 }
{                Description: 訂單狀況匯總表(by膠系)    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, StrUtils;

type
  TFrmDLIR130 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    BitBtn1: TBitBtn;
    Edit3: TEdit;
    Label3: TLabel;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_copy: TBitBtn;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    Label4: TLabel;
    Edit4: TEdit;
    BitBtn2: TBitBtn;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure btn_copyClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure CDS3AfterPost(DataSet: TDataSet);
    procedure CDS3BeforeInsert(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    l_Amt0:Double;
    l_Arr:array [0..20,0..11] of Double;
    l_QDate:string;
    l_SalCDS:TClientDataSet;
    function ChkYYYYMM(str:string):Boolean;
    function GetAd(xIndex:Integer):string;
    function GetArrIndex(Ad:string):Integer;
    procedure GetDS(ToDate:string);
    { Private declarations }
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmDLIR130: TFrmDLIR130;

implementation

uses unGlobal, unCommon, Comobj, unDLIR130_Query;

{$R *.dfm}

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="AD" fieldtype="string" WIDTH="20"/>'         //膠系
           //ccl 數量sh
           +'<FIELD attrname="CCLQty1" fieldtype="r8"/>'                   //實際已交付          l_Arr:0
           +'<FIELD attrname="CCLQty2" fieldtype="r8"/>'                   //受訂月末前交付            1
           +'<FIELD attrname="CCLQty3" fieldtype="r8"/>'                   //本月目標                  2
           //ccl 金額
           +'<FIELD attrname="CCLAmt1" fieldtype="r8"/>'                   //實際已交付                3
           +'<FIELD attrname="CCLAmt2" fieldtype="r8"/>'                   //受訂月末前交付            4
           +'<FIELD attrname="CCLAmt3" fieldtype="r8"/>'                   //本月目標                  5
           //pp 數量m
           +'<FIELD attrname="PPQty1" fieldtype="r8"/>'                    //實際已交付                6
           +'<FIELD attrname="PPQty2" fieldtype="r8"/>'                    //受訂月末前交付            7
           +'<FIELD attrname="PPQty3" fieldtype="r8"/>'                    //本月目標                  8
           //pp 金額
           +'<FIELD attrname="PPAmt1" fieldtype="r8"/>'                    //實際已交付                9
           +'<FIELD attrname="PPAmt2" fieldtype="r8"/>'                    //受訂月末前交付            10
           +'<FIELD attrname="PPAmt3" fieldtype="r8"/>'                    //本月目標                  11
           +'<FIELD attrname="y" fieldtype="i4"/>'                         //查詢之年份
           +'<FIELD attrname="m" fieldtype="i4"/>'                         //查詢之月份
           +'<FIELD attrname="d" fieldtype="i4"/>'                         //查詢之天數
           +'<FIELD attrname="lstd" fieldtype="i4"/>'                      //查詢之月份最後一天
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

function TFrmDLIR130.ChkYYYYMM(str:string):Boolean;
const err='年月格式不正確YYYYMM(年:1900~9999,月:01~12)';
var
  y,m:Integer;
  tmpStr:string;
begin
  inherited;

  Result:=False;

  tmpStr:=Trim(str);
  if Length(tmpStr)<>6 then
  begin
    ShowMsg(err, 48);
    Exit;
  end;

  try
    y:=StrToInt(LeftStr(tmpStr,4));
  except
    ShowMsg(err, 48);
    Exit;
  end;

  try
    m:=StrToInt(RightStr(tmpStr,2));
  except
    ShowMsg(err, 48);
    Exit;
  end;

  if (y<1900) or (m<1) or (m>12) then
  begin
    ShowMsg(err, 48);
    Exit;
  end;

  Result:=True;
end;

function TFrmDLIR130.GetAd(xIndex:Integer):string;
begin
  case xIndex of
    0:Result:='IT-150DA';
    1:Result:='IT-170GRA1';
    2:Result:='IT-200LK';
    3:Result:='IT-958G';
    4:Result:='IT-968';
    5:Result:='IT-988G';
    6:Result:='IT-150G';
    7:Result:='IT-150G-HDI';
    8:Result:='IT-150GL';
    9:Result:='IT-150GM';
    10:Result:='IT-150GS';
    11:Result:='IT-168G';
    12:Result:='IT-170GLE';
    13:Result:='IT-800GLE';
    14:Result:='IT-180';
    15:Result:='IT-180A';
    16:Result:='IT-180I';
    17:Result:='IT-189';
    18:Result:='IT-158';
    19:Result:='IT-158A1';
    20:Result:='IT-140';
  end;
end;

function TFrmDLIR130.GetArrIndex(Ad:string):Integer;
var
  tmpAd:string;
begin
  tmpAd:=UpperCase(Ad);
  if Pos(tmpAd,'IT150DA')>0 then
     Result:=0
  else if Pos(tmpAd,'IT170GRA1')>0 then
     Result:=1
  else if Pos(tmpAd,'IT200LK')>0 then
     Result:=2
  else if Pos(tmpAd,'IT958G')>0 then
     Result:=3
  else if Pos(tmpAd,'IT968')>0 then
     Result:=4
  else if Pos(tmpAd,'IT988G')>0 then
     Result:=5
  else if Pos(tmpAd,'IT150G')>0 then
     Result:=6
  else if Pos(tmpAd,'IT150G-HDI')>0 then
     Result:=7
  else if Pos(tmpAd,'IT150GL')>0 then
     Result:=8
  else if Pos(tmpAd,'IT150GM')>0 then
     Result:=9
  else if Pos(tmpAd,'IT150GS')>0 then
     Result:=10
  else if Pos(tmpAd,'IT168G')>0 then
     Result:=11
  else if Pos(tmpAd,'IT170GLE')>0 then
     Result:=12
  else if Pos(tmpAd,'IT800GLE')>0 then
     Result:=13
  else if Pos(tmpAd,'IT180')>0 then
     Result:=14
  else if Pos(tmpAd,'IT180A')>0 then
     Result:=15
  else if Pos(tmpAd,'IT180I')>0 then
     Result:=16
  else if Pos(tmpAd,'IT189')>0 then
     Result:=17
  else if Pos(tmpAd,'IT158')>0 then
     Result:=18
  else if Pos(tmpAd,'IT158A1')>0 then
     Result:=19
  else if Pos(tmpAd,'IT140')>0 then
     Result:=20
  else
     Result:=-1;
end;

procedure TFrmDLIR130.GetDS(ToDate:string);
var
  i,j,y,m,d,lstd:Integer;
  js_qty,js_amt:double;
  Data:OleVariant;
  tmpSQL:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  l_Amt0:=0;
  FillChar(l_Arr[0][0],SizeOf(l_Arr),0);
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    //銷售目標
    tmpSQL:='select sno-1 as sno,cclqty,cclamt,ppqty,ppamt,js_cclqty,js_ppqty,js_cclamt,js_ppamt'
           +' from dli021 where bu='+Quotedstr(g_UInfo^.BU)
           +' and yyyymm='+Quotedstr(Copy(ToDate,1,6))
           +' order by sno';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;
    while not tmpCDS1.Eof do
    begin
      i:=tmpCDS1.FieldByName('sno').AsInteger;
      l_Arr[i,2]:=tmpCDS1.FieldByName('cclqty').AsFloat;
      l_Arr[i,5]:=tmpCDS1.FieldByName('cclamt').AsFloat;
      l_Arr[i,8]:=tmpCDS1.FieldByName('ppqty').AsFloat;
      l_Arr[i,11]:=tmpCDS1.FieldByName('ppamt').AsFloat;
      tmpCDS1.Next;
    end;

    //訂單已交(當月出貨資料)
    Data:=null;
    tmpSQL:='exec [dbo].[proc_DLIR130_1] '+Quotedstr(ToDate);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS2.Data:=Data;
    with tmpCDS2 do
    while not Eof do
    begin
      if FieldByName('ad').AsString='0' then
         l_Amt0:=l_Amt0+FieldByName('amt').AsFloat
      else begin
        i:=GetArrIndex(FieldByName('ad').AsString);
        if i<>-1 then
        begin
          if FieldByName('type').AsInteger=1 then
          begin
            l_Arr[i][0]:=l_Arr[i][0]+FieldByName('qty').AsFloat;
            l_Arr[i][3]:=l_Arr[i][3]+FieldByName('amt').AsFloat;
          end
          else if FieldByName('type').AsInteger=2 then
          begin
            l_Arr[i][6]:=l_Arr[i][6]+FieldByName('qty').AsFloat;
            l_Arr[i][9]:=l_Arr[i][9]+FieldByName('amt').AsFloat;
          end;
        end;
      end;

      Next;
    end;

    //最後一天不計算未交
    y:=StrToInt(LeftStr(ToDate,4));
    m:=StrToInt(Copy(ToDate,5,2));
    d:=StrToInt(RightStr(ToDate,2));
    lstd:=DayOf(EndOfAMonth(y,m));
    if lstd<>d then
    begin
      //dg訂單未交
      Data:=null;
      tmpSQL:='exec [dbo].[proc_DLIR130_2] '+Quotedstr('ITEQDG')+','+Quotedstr(ToDate);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS2.Data:=Data;
      with tmpCDS2 do
      while not Eof do
      begin
        i:=GetArrIndex(FieldByName('ad').AsString);
        if i<>-1 then
        begin
          if FieldByName('type').AsInteger=1 then
          begin
            l_Arr[i][1]:=l_Arr[i][1]+FieldByName('qty').AsFloat;
            l_Arr[i][4]:=l_Arr[i][4]+FieldByName('amt').AsFloat;
          end
          else if FieldByName('type').AsInteger=2 then
          begin
            l_Arr[i][7]:=l_Arr[i][7]+FieldByName('qty').AsFloat;
            l_Arr[i][10]:=l_Arr[i][10]+FieldByName('amt').AsFloat;
          end;
        end;
        Next;
      end;

      //gz訂單未交
      Data:=null;
      tmpSQL:='exec [dbo].[proc_DLIR130_2] '+Quotedstr('ITEQGZ')+','+Quotedstr(ToDate);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS2.Data:=Data;
      with tmpCDS2 do
      while not Eof do
      begin
        i:=GetArrIndex(FieldByName('ad').AsString);
        if i<>-1 then
        begin
          if FieldByName('type').AsInteger=1 then
          begin
            l_Arr[i][1]:=l_Arr[i][1]+FieldByName('qty').AsFloat;
            l_Arr[i][4]:=l_Arr[i][4]+FieldByName('amt').AsFloat;
          end
          else if FieldByName('type').AsInteger=2 then
          begin
            l_Arr[i][7]:=l_Arr[i][7]+FieldByName('qty').AsFloat;
            l_Arr[i][10]:=l_Arr[i][10]+FieldByName('amt').AsFloat;
          end;
        end;
        Next;
      end;

      //寄售倉庫
      Data:=null;
      tmpSQL:='exec [dbo].[proc_DLIR130_3]';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS2.Data:=Data;
      with tmpCDS2 do
      while not Eof do
      begin
        i:=GetArrIndex(FieldByName('ad').AsString);
        if i<>-1 then
        begin
          //寄售倉待本月扣帳部分＝(當前寄售倉庫存量-平均期末結存量)*94%（入帳率）
          //小於0時設為0
          js_qty:=0;
          js_amt:=0;
          if tmpCDS1.Locate('sno',i,[]) then
          begin
            if FieldByName('type').AsInteger=1 then
            begin
              js_qty:=tmpCDS1.FieldByName('js_cclqty').AsFloat;
              js_amt:=tmpCDS1.FieldByName('js_cclamt').AsFloat;
            end else if FieldByName('type').AsInteger=2 then
            begin
              js_qty:=tmpCDS1.FieldByName('js_ppqty').AsFloat;
              js_amt:=tmpCDS1.FieldByName('js_ppamt').AsFloat;
            end;
          end;

          js_qty:=Round((FieldByName('qty').AsFloat-js_qty)*0.94);
          if js_qty<0 then
             js_qty:=0;
          js_amt:=Round((FieldByName('amt').AsFloat-js_amt)*0.94);
          if js_amt<0 then
             js_amt:=0;

          if FieldByName('type').AsInteger=1 then
          begin
            l_Arr[i][1]:=l_Arr[i][1]+js_qty;
            l_Arr[i][4]:=l_Arr[i][4]+js_amt;
          end
          else if FieldByName('type').AsInteger=2 then
          begin
            l_Arr[i][7]:=l_Arr[i][7]+js_qty;
            l_Arr[i][10]:=l_Arr[i][10]+js_amt;
          end;
        end;
        Next;
      end;
    end;

    for i:=0 to 20 do
    begin
      l_SalCDS.Append;
      l_SalCDS.Fields[0].AsString:=GetAd(i);
      for j:=0 to 11 do
        l_SalCDS.Fields[j+1].Value:=l_Arr[i,j];
      l_SalCDS.FieldByName('y').AsInteger:=y;
      l_SalCDS.FieldByName('m').AsInteger:=m;
      l_SalCDS.FieldByName('d').AsInteger:=d;
      l_SalCDS.FieldByName('lstd').AsInteger:=lstd;
      l_SalCDS.Post;
    end;

    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;

  finally
    tmpCDS2.Free;
    l_SalCDS.EnableControls;
    CDS.Data:=l_SalCDS.Data;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR130.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmDLIR130.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR130';
  p_GridDesignAns:=False;
  l_SalCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS,g_Xml);

  inherited;

  Label3.Caption:=CheckLang('年月(YYYYMM)：');
  Label4.Caption:=Label3.Caption;
  Edit3.Text:=FormatDateTime('YYYYMM', Date);
  Edit4.Text:=Edit3.Text;
  BitBtn1.Caption:=btn_query.Caption;
  BitBtn2.Caption:=btn_query.Caption;
  TabSheet2.Caption:=CheckLang('預估目標、寄售倉設定');
  TabSheet3.Caption:=CheckLang('匯率設定');
  SetGrdCaption(DBGridEh2, 'DLI021');
  SetGrdCaption(DBGridEh3, 'DLI022');
end;

procedure TFrmDLIR130.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_SalCDS);
end;

procedure TFrmDLIR130.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmDLIR130.CDS2BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmDLIR130.CDS3BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmDLIR130.CDS2AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS2, 'DLI021') then
  if CDS2.ChangeCount>0 then
     CDS2.CancelUpdates;
end;

procedure TFrmDLIR130.CDS3AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS3, 'DLI022') then
  if CDS3.ChangeCount>0 then
     CDS3.CancelUpdates;
end;

procedure TFrmDLIR130.BitBtn1Click(Sender: TObject);
var
  tmpStr:string;
  Data:OleVariant;
begin
  inherited;

  tmpStr:=Trim(Edit3.Text);
  if not ChkYYYYMM(tmpStr) then
  begin
    Edit3.SetFocus;
    Exit;
  end;

  tmpStr:=' declare @bu varchar(6)'
         +' declare @yyyymm varchar(6)'
         +' set @bu='+Quotedstr(g_UInfo^.BU)
         +' set @yyyymm='+Quotedstr(tmpStr)
         +' if not exists(select 1 from dli021 where bu=@bu and yyyymm=@yyyymm)'
         +' insert into dli021(bu,yyyymm,sno,ad,cclqty,cclamt,ppqty,ppamt,js_cclqty,js_ppqty,iuser,idate)'
         +' select @bu,@yyyymm,sno,ad,0,0,0,0,0,0,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(DateToStr(Date))
         +' from dli021 where bu=@bu and yyyymm=''0'''
         +' select * from dli021 where bu=@bu and yyyymm=@yyyymm';
  if not QueryBySQL(tmpStr, Data) then
     Exit;
  CDS2.Data:=Data;
end;

procedure TFrmDLIR130.btn_copyClick(Sender: TObject);
var
  tmpStr:string;
  Data:OleVariant;
begin
  inherited;
  tmpStr:=Trim(Edit3.Text);
  if not ChkYYYYMM(tmpStr) then
  begin
    Edit3.SetFocus;
    Exit;
  end;

  if RightStr(tmpStr,2)='12' then
  begin
    ShowMsg('請輸入非12月份',48);
    Exit;
  end;

  if ShowMsg('確定複製'+tmpStr+'資料至12月嗎?',33)=IdCancel then
     Exit;

  tmpStr:=' declare @bu varchar(6)'
         +' declare @yyyymm varchar(6)'
         +' declare @mm varchar(2)'
         +' set @bu='+Quotedstr(g_UInfo^.BU)
         +' set @yyyymm='+Quotedstr(tmpStr)
         +' if not exists(select 1 from dli021 where bu=@bu and yyyymm=@yyyymm)'
         +' begin'
         +'   select 1 as id'
         +'   return'
         +' end'

         +' delete from dli021 where bu=@bu and yyyymm>@yyyymm and yyyymm<=left(@yyyymm,4)+''12'''
         +' set @mm=right(@yyyymm,2)'
         +' while @mm<''12'''
         +' begin'
         +'   set @mm=right(''0''+cast(cast(@mm as int)+1 as varchar(2)),2)'
         +'   insert into dli021(bu,yyyymm,sno,ad,cclqty,cclamt,ppqty,ppamt,js_cclqty,js_ppqty,js_cclamt,js_ppamt,iuser,idate)'
         +'   select @bu,left(@yyyymm,4)+@mm,sno,ad,cclqty,cclamt,ppqty,ppamt,js_cclqty,js_ppqty,js_cclamt,js_ppamt,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(DateToStr(Date))
         +'   from dli021 where bu=@bu and yyyymm=@yyyymm'
         +' end'
         +' select 2 as id';
  if QueryOneCR(tmpStr, Data) then
  begin
    if VarToStr(Data)='1' then
       ShowMsg('此月份無資料,請按[查詢]將自動產生!',64)
    else
       ShowMsg('複製完畢!',64);
  end;
end;

procedure TFrmDLIR130.BitBtn2Click(Sender: TObject);
var
  tmpStr:string;
  Data:OleVariant;
begin
  inherited;
  tmpStr:=Trim(Edit4.Text);
  if not ChkYYYYMM(tmpStr) then
  begin
    Edit4.SetFocus;
    Exit;
  end;

  tmpStr:='select top 6 * from dli022 where yyyymm>='+Quotedstr(tmpStr)
         +' order by yyyymm';
  if QueryBySQL(tmpStr, Data) then
     CDS3.Data:=Data;
end;

procedure TFrmDLIR130.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
//  inherited;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS.Filter;
  GetPrintObj('DLI', ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmDLIR130.btn_exportClick(Sender: TObject);
const ext='.xlsx';
var
  xlsPath,m,d:string;
  i,r:Integer;
  ExcelApp:Variant;
begin
  //  inherited;
  if not CDS.Active or CDS.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  xlsPath:=ExtractFilePath(Application.Exename)+'Temp\訂單狀況匯總表';
  if not FileExists(xlsPath+ext) then
  begin
    ShowMsg('[Temp\訂單狀況匯總表.xlsx]文件不存在',48);
    Exit;
  end;
  g_ProgressBar.Position:=0;
  g_ProgressBar.Max:=20*12;
  g_ProgressBar.Visible:=True;
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(xlsPath+ext);
    ExcelApp.WorkSheets[1].Activate;
    m:=IntToStr(StrToInt(Copy(l_QDate,5,2)));
    d:=IntToStr(StrToInt(Copy(l_QDate,7,2)));
    ExcelApp.Cells[1,2].Value:=LeftStr(l_QDate,4)+'年'+m+'月 華南區硬板訂單狀況匯總表(By膠系） （Updated to:'+m+'/'+d+')';
    for i:=0 to 20 do
    begin
      r:=i+5;
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,4].Value:=l_Arr[i][0];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,5].Value:=l_Arr[i][1];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,7].Value:=l_Arr[i][2];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,9].Value:=l_Arr[i][3];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,10].Value:=l_Arr[i][4];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,12].Value:=l_Arr[i][5];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,14].Value:=l_Arr[i][6];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,15].Value:=l_Arr[i][7];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,17].Value:=l_Arr[i][8];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,19].Value:=l_Arr[i][9];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,20].Value:=l_Arr[i][10];
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      ExcelApp.Cells[r,22].Value:=l_Arr[i][11];
    end;
    if l_Amt0=0 then
       ExcelApp.Cells[29,3].Value:=ExcelApp.Cells[29,3].Value+'0USD'
    else
       ExcelApp.Cells[29,3].Value:=ExcelApp.Cells[29,3].Value+FormatFloat('#,###',Round(l_Amt0))+'USD';
    //ExcelApp.WorkSheets[1].SaveAs(xlsPath+FormatDateTime(g_cLongTime, now)+ext);
    ExcelApp.Visible:=True;
  finally
    g_ProgressBar.Visible:=False;
    //ExcelApp.Quit;
  end;
end;

procedure TFrmDLIR130.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR130_Query) then
     FrmDLIR130_Query:=TFrmDLIR130_Query.Create(Application);
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  try
    if FrmDLIR130_Query.ShowModal=mrOK then
    begin
      l_QDate:=FormatDateTime('YYYYMMDD',FrmDLIR130_Query.Dtp1.Date);
      RefreshDS(l_QDate);
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
