{*******************************************************}
{                                                       }
{                unMPSR220                              }
{                Author: kaikai                         }
{                Create date: 2019/9/9                  }
{                Description: 訂單＿生管排交天數分析表  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR220;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, Math, ExcelXP;

type
  TFrmDLIR220 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    Label1: TLabel;
    TabSheet21: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    TabSheet22: TTabSheet;
    DBGridEh4: TDBGridEh;
    CDS4: TClientDataSet;
    DS4: TDataSource;
    TabSheet23: TTabSheet;
    DBGridEh5: TDBGridEh;
    CDS5: TClientDataSet;
    DS5: TDataSource;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    procedure rpt(xData:OleVariant);
    { Private declarations }
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmDLIR220: TFrmDLIR220;

implementation

uses unGlobal, unCommon, unDLIR220_query, ComObj;

const lstxml='</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIR220.rpt(xData:OleVariant);
const maxcol=90;
var
  i,maxday,cnt,num:Integer;
  tot:Double;
  xml2,xml3,xml4,xml5,fname:string;
  srcCDS,destCDS2,destCDS3,destCDS4,destCDS5:TClientDataSet;
begin
  xml2:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="avg" fieldtype="r8"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml3:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml4:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml5:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="avg" fieldtype="r8"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  srcCDS:=TClientDataSet.Create(nil);
  destCDS2:=TClientDataSet.Create(nil);
  destCDS3:=TClientDataSet.Create(nil);
  destCDS4:=TClientDataSet.Create(nil);
  destCDS5:=TClientDataSet.Create(nil);
  DBGridEh2.Columns.BeginUpdate;
  DBGridEh2.DataSource:=nil;
  DBGridEh3.Columns.BeginUpdate;
  DBGridEh3.DataSource:=nil;
  DBGridEh4.Columns.BeginUpdate;
  DBGridEh4.DataSource:=nil;
  DBGridEh5.Columns.BeginUpdate;
  DBGridEh5.DataSource:=nil;
  try
    for i:=DBGridEh2.Columns.Count-1 downto 4 do
      DBGridEh2.Columns.Delete(i);

    for i:=DBGridEh3.Columns.Count-1 downto 5 do
      DBGridEh3.Columns.Delete(i);

    for i:=DBGridEh4.Columns.Count-1 downto 2 do
      DBGridEh4.Columns.Delete(i);

    for i:=DBGridEh5.Columns.Count-1 downto 6 do
      DBGridEh5.Columns.Delete(i);

    srcCDS.Data:=xData;
    if srcCDS.IsEmpty then
    begin
      InitCDS(destCDS2,xml2+lstxml);
      CDS2.Data:=destCDS2.Data;

      InitCDS(destCDS3,xml3+lstxml);
      CDS3.Data:=destCDS3.Data;

      InitCDS(destCDS4,xml4+lstxml);
      CDS4.Data:=destCDS4.Data;

      InitCDS(destCDS5,xml5+lstxml);
      CDS5.Data:=destCDS5.Data;

      Exit;
    end;

    //添加DBGridEh列
    srcCDS.Filtered:=False;
    srcCDS.Filter:='diffday1>0';
    srcCDS.Filtered:=True;
    srcCDS.IndexFieldNames:='diffday1';
    srcCDS.Last;
    if srcCDS.FieldByName('diffday1').IsNull then
       maxday:=-1
    else if srcCDS.FieldByName('diffday1').AsFloat=0.16 then
       maxday:=0
    else
       maxday:=srcCDS.FieldByName('diffday1').AsInteger;
    if maxday>maxcol then
       maxday:=maxcol;

    for i:=0 to maxday do
    begin
      xml2:=xml2+'<FIELD attrname="cnt'+IntToStr(i)+'" fieldtype="i4"/>';
      xml3:=xml3+'<FIELD attrname="cnt'+IntToStr(i)+'" fieldtype="i4"/>';
      xml4:=xml4+'<FIELD attrname="cnt'+IntToStr(i)+'" fieldtype="i4"/>';
      with DBGridEh2.Columns.Add do
      begin
        if i=0 then
           Title.Caption:='0.16'
        else
           Title.Caption:=IntToStr(i);
        FieldName:='cnt'+IntToStr(i);
        Width:=40;
      end;

      with DBGridEh3.Columns.Add do
      begin
        if i=0 then
           Title.Caption:='0.16'
        else
           Title.Caption:=IntToStr(i);
        FieldName:='cnt'+IntToStr(i);
        Width:=40;
      end;

      with DBGridEh4.Columns.Add do
      begin
        if i=0 then
           Title.Caption:='0.16'
        else
           Title.Caption:=IntToStr(i);
        FieldName:='cnt'+IntToStr(i);
        Width:=40;
        Footer.ValueType:=fvtSum;
      end;
    end;

    if maxday=maxcol then
    begin
      DBGridEh2.Columns[DBGridEh2.Columns.Count-1].Title.Caption:='≧'+IntToStr(maxcol);
      DBGridEh3.Columns[DBGridEh3.Columns.Count-1].Title.Caption:='≧'+IntToStr(maxcol);
      DBGridEh4.Columns[DBGridEh4.Columns.Count-1].Title.Caption:='≧'+IntToStr(maxcol);
    end;

    srcCDS.Filtered:=False;
    srcCDS.Filter:='diffday2>0';
    srcCDS.Filtered:=True;
    srcCDS.IndexFieldNames:='diffday2';
    srcCDS.Last;
    maxday:=srcCDS.FieldByName('diffday2').AsInteger;
    if maxday>maxcol then
       maxday:=maxcol;

    for i:=1 to maxday do
    begin
      xml5:=xml5+'<FIELD attrname="cnt'+IntToStr(i)+'" fieldtype="i4"/>';
      with DBGridEh5.Columns.Add do
      begin
        Title.Caption:=IntToStr(i);
        FieldName:='cnt'+IntToStr(i);
        Width:=40;
      end;
    end;

    if maxday=maxcol then
       DBGridEh5.Columns[DBGridEh5.Columns.Count-1].Title.Caption:='≧'+IntToStr(maxcol);

    InitCDS(destCDS2,xml2+lstxml);
    InitCDS(destCDS3,xml3+lstxml);
    InitCDS(destCDS4,xml4+lstxml);
    InitCDS(destCDS5,xml5+lstxml);

    srcCDS.Filtered:=False;
    srcCDS.First;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=srcCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    while not srcCDS.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      //destCDS2
      if destCDS2.Locate('ad;ftype',
          VarArrayOf([srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS2.Edit
      else begin
        destCDS2.Append;
        destCDS2.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS2.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //排交天數,未排交
         destCDS2.FieldByName('not').AsInteger:=destCDS2.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //排交天數,已排交,0.16放在cnt0,其它對應欄位
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS2.FieldByName(fname).AsInteger:=destCDS2.FieldByName(fname).AsInteger+1;
      end;
      destCDS2.Post;

      //destCDS3
      if destCDS3.Locate('salename;custno;ad;ftype',
          VarArrayOf([srcCDS.FieldByName('salename').AsString,
                      srcCDS.FieldByName('custno').AsString,
                      srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS3.Edit
      else begin
        destCDS3.Append;
        destCDS3.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
        destCDS3.FieldByName('custno').AsString:=srcCDS.FieldByName('custno').AsString;
        destCDS3.FieldByName('custshort').AsString:=srcCDS.FieldByName('custshort').AsString;
        destCDS3.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS3.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //排交天數,未排交
         destCDS3.FieldByName('not').AsInteger:=destCDS3.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //排交天數,已排交,0.16放在cnt0,其它對應欄位
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS3.FieldByName(fname).AsInteger:=destCDS3.FieldByName(fname).AsInteger+1;
      end;
      destCDS3.Post;

      //destCDS4
      if destCDS4.Locate('salename',srcCDS.FieldByName('salename').AsString,[]) then
         destCDS4.Edit
      else begin
        destCDS4.Append;
        destCDS4.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //排交天數,未排交
         destCDS4.FieldByName('not').AsInteger:=destCDS4.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //排交天數,已排交,0.16放在cnt0,其它對應欄位
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS4.FieldByName(fname).AsInteger:=destCDS4.FieldByName(fname).AsInteger+1;
      end;
      destCDS4.Post;

      //destCDS5
      if destCDS5.Locate('salename;custno;ad;ftype',
          VarArrayOf([srcCDS.FieldByName('salename').AsString,
                      srcCDS.FieldByName('custno').AsString,
                      srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS5.Edit
      else begin
        destCDS5.Append;
        destCDS5.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
        destCDS5.FieldByName('custno').AsString:=srcCDS.FieldByName('custno').AsString;
        destCDS5.FieldByName('custshort').AsString:=srcCDS.FieldByName('custshort').AsString;
        destCDS5.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS5.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;


      if srcCDS.FieldByName('diffday1').IsNull then      //排交天數,未排交
      begin
        num:=1;
        destCDS5.FieldByName('not').AsInteger:=destCDS5.FieldByName('not').AsInteger+1;
      end else
      begin
        num:=srcCDS.FieldByName('diffday2').AsInteger;   //逾期天數
        if num>0 then
        begin
          if num>maxcol then
             fname:='cnt'+IntToStr(maxcol)
          else
             fname:='cnt'+IntToStr(num);
          destCDS5.FieldByName(fname).AsInteger:=destCDS5.FieldByName(fname).AsInteger+1;
        end;
      end;
      if num>0 then
         destCDS5.Post
      else
         destCDS5.Cancel;

      srcCDS.Next;
    end;

    //destCDS2計算avg
    with destCDS2 do
    begin
      First;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=destCDS2.RecordCount+destCDS5.RecordCount;
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        tot:=0; //sum(筆數*天數)
        cnt:=FieldByName('not').AsInteger; //sum(筆數)
        for i:=4 to DBGridEh2.Columns.Count-1 do
        begin
          num:=i-4;
          fname:='cnt'+FloatToStr(num);
          if FieldByName(fname).AsInteger>0 then
          begin
            if num=0 then
               tot:=tot+FieldByName(fname).AsInteger*0.16
            else
               tot:=tot+FieldByName(fname).AsInteger*num;
            cnt:=cnt+FieldByName(fname).AsInteger;
          end;
        end;

        Edit;
        FieldByName('avg').AsFloat:=RoundTo(tot/cnt,-2);
        Post;
        Next;
      end;
    end;

    //destCDS5計算avg
    with destCDS5 do
    begin
      First;
      //g_ProgressBar.Position:=0;
      //g_ProgressBar.Max:=destCDS5.RecordCount; //destCDS2已累計
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        tot:=0; //sum(筆數*天數)
        cnt:=FieldByName('not').AsInteger; //sum(筆數)
        for i:=6 to DBGridEh5.Columns.Count-1 do
        begin
          num:=i-5;
          fname:='cnt'+IntToStr(num);
          if FieldByName(fname).AsInteger>0 then
          begin
            tot:=tot+FieldByName(fname).AsInteger*num;
            cnt:=cnt+FieldByName(fname).AsInteger;
          end;
        end;

        Edit;
        if cnt>0 then
           FieldByName('avg').AsFloat:=RoundTo(tot/cnt,-2)
        else
           FieldByName('avg').AsFloat:=0;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='avg=0';
      Filtered:=True;
      while not IsEmpty do
        Delete;
      Filtered:=False;
    end;

    if destCDS2.ChangeCount>0 then
       destCDS2.MergeChangeLog;
    CDS2.Data:=destCDS2.Data;
    CDS2.IndexFieldNames:='ad;ftype';

    if destCDS3.ChangeCount>0 then
       destCDS3.MergeChangeLog;
    CDS3.Data:=destCDS3.Data;
    CDS3.IndexFieldNames:='salename;custno;ad;ftype';

    if destCDS4.ChangeCount>0 then
       destCDS4.MergeChangeLog;
    CDS4.Data:=destCDS4.Data;
    CDS4.IndexFieldNames:='salename';

    if destCDS5.ChangeCount>0 then
       destCDS5.MergeChangeLog;
    CDS5.Data:=destCDS5.Data;
    CDS5.IndexFieldNames:='salename;custno;ad;ftype';

  finally
    FreeAndNil(srcCDS);
    FreeAndNil(destCDS2);
    FreeAndNil(destCDS3);
    FreeAndNil(destCDS4);
    FreeAndNil(destCDS5);
    DBGridEh2.Columns.EndUpdate;
    DBGridEh2.DataSource:=DS2;
    DBGridEh3.Columns.EndUpdate;
    DBGridEh3.DataSource:=DS3;
    DBGridEh4.Columns.EndUpdate;
    DBGridEh4.DataSource:=DS4;
    DBGridEh5.Columns.EndUpdate;
    DBGridEh5.DataSource:=DS5;
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmDLIR220.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if strFilter=g_cFilterNothing then
  begin
    tmpSQL:='exec [dbo].[proc_DLIR220] ''@'',''1955/05/05'',''1955/05/05''';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end;

  inherited;
end;

procedure TFrmDLIR220.FormCreate(Sender: TObject);
begin
  p_SysId:='DLI';
  p_TableName:='DLIR220_1';
  p_GridDesignAns:=False;

  inherited;

  Label1.Caption:='';
  Label1.Font.Color:=clBlue;
  Label2.Caption:=CheckLang('排交天數=交期確認日期-確認日期, 排交逾期天數=生管排定達交日期-約訂交貨日');
  TabSheet1.Caption:=CheckLang('達交明細表');
  TabSheet20.Caption:=CheckLang('天數統計表');
  TabSheet21.Caption:=CheckLang('天數統計表By業務');
  TabSheet22.Caption:=CheckLang('sales分析表');
  TabSheet23.Caption:=CheckLang('客戶排交逾期表');
  SetGrdCaption(DBGridEh2, 'DLIR220_2');
  SetGrdCaption(DBGridEh3, 'DLIR220_3');
  SetGrdCaption(DBGridEh4, 'DLIR220_4');
  SetGrdCaption(DBGridEh5, 'DLIR220_5');
end;

procedure TFrmDLIR220.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  CDS4.Active:=False;
  CDS5.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
  DBGridEh5.Free;
end;

procedure TFrmDLIR220.btn_queryClick(Sender: TObject);
var
  fmdate,todate,d1,d2:TDateTime;
  tmpSQL,tmpbu,strd1,strd2:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
//  inherited;
  if not Assigned(FrmDLIR220_query) then
     FrmDLIR220_query:=TFrmDLIR220_query.Create(Application);
  if FrmDLIR220_query.ShowModal<>mrOK then
     Exit;

  //數據量大,防止查詢逾時,5天查詢一次
  fmdate:=FrmDLIR220_query.dtp1.Date;
  todate:=FrmDLIR220_query.dtp2.Date;
  tmpbu:=FrmDLIR220_query.rgp.Items.Strings[FrmDLIR220_query.rgp.ItemIndex];
  Label1.Caption:=CheckLang('訂單日期:')+DateToStr(fmdate)+'~'+DateToStr(todate);

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.EmptyDataSet;

    d1:=fmdate;
    d2:=fmdate;
    while d2<=todate do
    begin
      d2:=d1+4;
      if d2>todate then
         d2:=todate;

      strd1:=StringReplace(FormatDateTime(g_cShortDate1,d1),'-','/',[rfReplaceAll]);
      strd2:=StringReplace(FormatDateTime(g_cShortDate1,d2),'-','/',[rfReplaceAll]);

      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+strd1+'~'+strd2);
      Application.ProcessMessages;

      Data:=null;
      tmpSQL:='exec [dbo].[proc_DLIR220] '+Quotedstr(tmpbu)+','+Quotedstr(strd1)+','+Quotedstr(strd2);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
         
      if Data<>null then
         tmpCDS.AppendData(Data,True);

      d1:=d2+1;
      d2:=d1;
    end;

    CDS.Data:=tmpCDS.Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在統計報表...');
    Application.ProcessMessages;
    rpt(tmpCDS.Data);

  finally
    FreeAndNil(tmpCDS);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR220.btn_exportClick(Sender: TObject);
var
  isXlsOK:Boolean;
  i,row,col,tmpNum,aIndex,sIndex,cIndex:Integer;
  Arr:array[1..260] of string;
  tmpAd,tmpSalename,tmpCustno:string;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  //  inherited;

  if CDS.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  if ShowMsg('確定匯出嗎?',33)=IdCancel then
     Exit;

  try
    ExcelApp:=CreateOleObject('Excel.Application');
  except
    ShowMsg('創建Excel失敗,請重試',48);
    Exit;
  end;

  //初始化excel列字母
  for i:=1 to length(Arr) do
  begin
    if i<=26 then
       Arr[i]:=chr(64+i)
    else begin
      aIndex:=i;
      tmpNum:=0;
      while aIndex>26 do
      begin
        aIndex:=aIndex-26;
        Inc(tmpNum);
      end;
      Arr[i]:=chr(64+tmpNum)+chr(64+aIndex);
    end;
  end;

  isXlsOK:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    ExcelApp.DisplayAlerts:=False;

    //匯出5個表
    ExcelApp.WorkBooks.Add;
    while ExcelApp.WorkSheets.Count >1 do
    begin
      ExcelApp.WorkSheets[1].Select;
      ExcelApp.WorkSheets[1].Delete;
    end;

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[1]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[2]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[3]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[4]);

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯出['+TabSheet20.Caption+']');
    Application.ProcessMessages;

    //CDS2天數統計表
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.ActiveSheet.Name:=TabSheet20.Caption;
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[3].NumberFormat:='@';
    //第1行
    col:=DBGridEh2.Columns.Count;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=CheckLang('訂單_生管排交天數分析表');
    ExcelApp.ActiveSheet.Range['A1'].Select;
    ExcelApp.Selection.Font.Color:=RGB(70,130,193);
    ExcelApp.Selection.Font.Size:=20;
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Merge;
    //第2行
    ExcelApp.ActiveSheet.Cells[2,1].Value:=Label1.Caption;
    ExcelApp.ActiveSheet.Range['A2:B2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[2,3].Value:=CheckLang('(天數*筆數)/總筆數');
    ExcelApp.ActiveSheet.Range['C2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[2,4].Value:=CheckLang('筆數');
    ExcelApp.ActiveSheet.Range['D2:'+Arr[col]+'2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[2].RowHeight:=30;
    //第3行標題
    for i:=0 to DBGridEh2.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[3,col].Value:=DBGridEh2.Columns[i].Title.Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if DBGridEh2.Columns[i].Field.DataType in [ftDate, ftDateTime] then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'3:'+Arr[col]+'3'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A3:'+Arr[col]+'3'].interior.ColorIndex:=34;
    //匯出
    tmpCDS.IndexFieldNames:='';
    tmpCDS.Data:=CDS2.Data;
    tmpCDS.IndexFieldNames:=CDS2.IndexFieldNames;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    row:=3;
    aIndex:=4;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      Inc(row);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      for i:=0 to DBGridEh2.Columns.Count-1 do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=tmpCDS.FieldByName(DBGridEh2.Columns[i].FieldName).Value;

      tmpAd:=tmpCDS.FieldByName('ad').AsString;
      tmpCDS.Next;
      if tmpCDS.Eof or (tmpAd<>tmpCDS.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(aIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;
    end;
    //凍結前3列
    ExcelApp.ActiveSheet.Range['A4'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯出['+TabSheet21.Caption+']');
    Application.ProcessMessages;

    //CDS3天數統計表by業務
    ExcelApp.WorkSheets[2].Activate;
    ExcelApp.ActiveSheet.Name:=TabSheet21.Caption;
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //第1行
    col:=DBGridEh3.Columns.Count;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=Label1.Caption;
    ExcelApp.ActiveSheet.Range['A1:D1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Cells[1,5].Value:=CheckLang('筆數');
    ExcelApp.ActiveSheet.Range['E1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //第2行標題
    for i:=0 to DBGridEh3.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=DBGridEh3.Columns[i].Title.Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if DBGridEh3.Columns[i].Field.DataType in [ftDate, ftDateTime] then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //匯出
    tmpCDS.IndexFieldNames:='';
    tmpCDS.Data:=CDS3.Data;
    tmpCDS.IndexFieldNames:=CDS3.IndexFieldNames;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    row:=2;
    aIndex:=3;
    sIndex:=3;
    cIndex:=3;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      Inc(row);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      for i:=0 to DBGridEh3.Columns.Count-1 do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=tmpCDS.FieldByName(DBGridEh3.Columns[i].FieldName).Value;

      tmpSalename:=tmpCDS.FieldByName('salename').AsString;
      tmpCustno:=tmpCDS.FieldByName('custno').AsString;
      tmpAd:=tmpCDS.FieldByName('ad').AsString;
      tmpCDS.Next;
      if tmpCDS.Eof or (tmpSalename+'@'+tmpCustno+'@'+tmpAd<>tmpCDS.FieldByName('salename').AsString+'@'+
                                                             tmpCDS.FieldByName('custno').AsString+'@'+
                                                             tmpCDS.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['C'+IntToStr(aIndex)+':C'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;

      if tmpCDS.Eof or (tmpSalename+'@'+tmpCustno<>tmpCDS.FieldByName('salename').AsString+'@'+tmpCDS.FieldByName('custno').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['B'+IntToStr(cIndex)+':B'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        cIndex:=row+1;
        aIndex:=cIndex;
      end;

      if tmpCDS.Eof or (tmpSalename<>tmpCDS.FieldByName('salename').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(sIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        sIndex:=row+1;
        aIndex:=sIndex;
        cIndex:=sIndex;
      end;
    end;
    //凍結前3列
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯出['+TabSheet22.Caption+']');
    Application.ProcessMessages;

    //CDS4 sales分析表
    ExcelApp.WorkSheets[3].Activate;
    ExcelApp.ActiveSheet.Name:=TabSheet22.Caption;
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //第1行
    col:=DBGridEh4.Columns.Count;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=Label1.Caption;
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //第2行標題
    for i:=0 to DBGridEh4.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=DBGridEh4.Columns[i].Title.Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if DBGridEh4.Columns[i].Field.DataType in [ftDate, ftDateTime] then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //匯出
    tmpCDS.IndexFieldNames:='';
    tmpCDS.Data:=CDS4.Data;
    tmpCDS.IndexFieldNames:=CDS4.IndexFieldNames;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    row:=2;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      Inc(row);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      for i:=0 to DBGridEh4.Columns.Count-1 do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=tmpCDS.FieldByName(DBGridEh4.Columns[i].FieldName).Value;

      tmpCDS.Next;
    end;
    //加總
    aIndex:=row+1;
    for i:=0 to DBGridEh4.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[aIndex,col].Value:='=sum('+Arr[col]+'3:'+Arr[col]+IntToStr(row)+')';
    end;
    ExcelApp.ActiveSheet.Cells[aIndex,1].Value:=CheckLang('總計');
    //凍結前3列
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯出['+TabSheet23.Caption+']');
    Application.ProcessMessages;

    //CDS5客戶排交逾期表
    ExcelApp.WorkSheets[4].Activate;
    ExcelApp.ActiveSheet.Name:=TabSheet23.Caption;
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //第1行
    col:=DBGridEh5.Columns.Count;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=Label1.Caption;
    ExcelApp.ActiveSheet.Range['A1:D1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[1,5].Value:=CheckLang('(天數*筆數)/總筆數');
    ExcelApp.ActiveSheet.Range['E1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[1,6].Value:=CheckLang('筆數');
    ExcelApp.ActiveSheet.Range['F1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //第2行標題
    for i:=0 to DBGridEh5.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=DBGridEh5.Columns[i].Title.Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if DBGridEh5.Columns[i].Field.DataType in [ftDate, ftDateTime] then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //匯出
    tmpCDS.IndexFieldNames:='';
    tmpCDS.Data:=CDS5.Data;
    tmpCDS.IndexFieldNames:=CDS5.IndexFieldNames;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    row:=2;
    aIndex:=3;
    sIndex:=3;
    cIndex:=3;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      Inc(row);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      for i:=0 to DBGridEh5.Columns.Count-1 do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=tmpCDS.FieldByName(DBGridEh5.Columns[i].FieldName).Value;

      tmpSalename:=tmpCDS.FieldByName('salename').AsString;
      tmpCustno:=tmpCDS.FieldByName('custno').AsString;
      tmpAd:=tmpCDS.FieldByName('ad').AsString;
      tmpCDS.Next;
      if tmpCDS.Eof or (tmpSalename+'@'+tmpCustno+'@'+tmpAd<>tmpCDS.FieldByName('salename').AsString+'@'+
                                                             tmpCDS.FieldByName('custno').AsString+'@'+
                                                             tmpCDS.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['C'+IntToStr(aIndex)+':C'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;

      if tmpCDS.Eof or (tmpSalename+'@'+tmpCustno<>tmpCDS.FieldByName('salename').AsString+'@'+tmpCDS.FieldByName('custno').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['B'+IntToStr(cIndex)+':B'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        cIndex:=row+1;
        aIndex:=cIndex;
      end;

      if tmpCDS.Eof or (tmpSalename<>tmpCDS.FieldByName('salename').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(sIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        sIndex:=row+1;
        aIndex:=sIndex;
        cIndex:=sIndex;
      end;
    end;
    //凍結前3列
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯出['+TabSheet1.Caption+']');
    Application.ProcessMessages;

    //CDS 達交明細表
    ExcelApp.WorkSheets[5].Activate;
    ExcelApp.ActiveSheet.Name:=TabSheet1.Caption;
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //第1行
    col:=DBGridEh1.Columns.Count;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=Label1.Caption;
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //第2行標題
    for i:=0 to DBGridEh1.Columns.Count-1 do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=DBGridEh1.Columns[i].Title.Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if DBGridEh1.Columns[i].Field.DataType in [ftDate, ftDateTime] then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //匯出
    tmpCDS.IndexFieldNames:='';
    tmpCDS.Data:=CDS.Data;
    tmpCDS.IndexFieldNames:=CDS.IndexFieldNames;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    row:=2;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      Inc(row);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      for i:=0 to DBGridEh1.Columns.Count-1 do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=tmpCDS.FieldByName(DBGridEh1.Columns[i].FieldName).Value;

      tmpCDS.Next;
    end;
    //凍結前3列
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    //調整excel格式
    for i:=ExcelApp.WorkSheets.Count downto 1 do
    begin
      ExcelApp.WorkSheets[i].Activate;
      ExcelApp.ActiveSheet.Columns.EntireColumn.AutoFit;
      col:=ExcelApp.ActiveSheet.Usedrange.columns.count;
      row:=ExcelApp.ActiveSheet.Usedrange.Rows.count;
      //邊框線
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders.LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;

    ExcelApp.Visible:=True;
    isXlsOK:=True;

  finally
    g_StatusBar.Panels[0].Text:='';
    FreeAndNil(tmpCDS);
    g_ProgressBar.Visible:=False;
    if not isXlsOK then
       ExcelApp.Quit;
  end;
end;

end.

