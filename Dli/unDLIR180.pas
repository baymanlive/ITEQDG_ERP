{*******************************************************}
{                                                       }
{                unDLIR180                              }
{                Author: kaikai                         }
{                Create date: 2018/5/22                 }
{                Description: 每日達交出貨統計表        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR180;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, ExcelXP, StrUtils, Math;

type
  TFrmDLIR180 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    procedure GetDS1(bu:string; d1,d2:TDateTime);
    procedure ToXLS;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR180: TFrmDLIR180;

implementation

uses unGlobal, unCommon, unDLIR180_query, ComObj, unDLIR180_export;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="adate" fieldtype="datetime"/>'
           //wx:無錫,tw:台灣,zz:自制+其它
           //1:寄售訂單,2:正式訂單

           //數量
           //pp
           +'<FIELD attrname="rl_wxqty1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_zzqty1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_twqty1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_wxqty2" fieldtype="r8"/>'
           +'<FIELD attrname="rl_zzqty2" fieldtype="r8"/>'
           +'<FIELD attrname="rl_twqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_wxqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_zzqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_twqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_wxqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_zzqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_twqty2" fieldtype="r8"/>'
           //ccl
           +'<FIELD attrname="sh_wxqty1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_zzqty1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_twqty1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_wxqty2" fieldtype="r8"/>'
           +'<FIELD attrname="sh_zzqty2" fieldtype="r8"/>'
           +'<FIELD attrname="sh_twqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_wxqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_zzqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_twqty1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_wxqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_twqty2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_zzqty2" fieldtype="r8"/>'
           //金額
           //pp
           +'<FIELD attrname="rl_wxamt1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_zzamt1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_twamt1" fieldtype="r8"/>'
           +'<FIELD attrname="rl_wxamt2" fieldtype="r8"/>'
           +'<FIELD attrname="rl_zzamt2" fieldtype="r8"/>'
           +'<FIELD attrname="rl_twamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_wxamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_zzamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_twamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pn_wxamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_zzamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pn_twamt2" fieldtype="r8"/>'
           //ccl
           +'<FIELD attrname="sh_wxamt1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_zzamt1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_twamt1" fieldtype="r8"/>'
           +'<FIELD attrname="sh_wxamt2" fieldtype="r8"/>'
           +'<FIELD attrname="sh_zzamt2" fieldtype="r8"/>'
           +'<FIELD attrname="sh_twamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_wxamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_zzamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_twamt1" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_wxamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_zzamt2" fieldtype="r8"/>'
           +'<FIELD attrname="pnl_twamt2" fieldtype="r8"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

const l_strOrdno='223,225';   //寄售訂單
const l_strwx='外購無錫';
const l_strtw='外購台灣';

{$R *.dfm}

procedure TFrmDLIR180.GetDS1(bu:string; d1,d2:TDateTime);
var
  tmpOutQty,tmpRemainQty:Double;
  tmpSQL,tmpOrderno:string;
  i,tmpOrderitem:Integer;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;

  procedure SetCDSValue(qtyname,amtname:string; qty:Double);
  begin
    l_CDS.FieldByName(qtyname).AsFloat:=l_CDS.FieldByName(qtyname).AsFloat+qty;
    l_CDS.FieldByName(amtname).AsFloat:=l_CDS.FieldByName(amtname).AsFloat+tmpCDS1.FieldByName('amt').AsFloat;
  end;

  procedure AddDate;
  begin
    with tmpCDS1 do
    begin
      if Pos(LeftStr(FieldByName('pno').AsString,1),'ET')>0 then  //ccl
      begin
        if Pos(LeftStr(FieldByName('orderno').AsString,3),l_strOrdno)>0 then  //寄售訂單
        begin
          if Length(FieldByName('pno').AsString)=11 then          //pnl
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('pnl_wxqty1','pnl_wxamt1',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('pnl_twqty1','pnl_twamt1',FieldByName('outqty').AsFloat)
            else
               SetCDSValue('pnl_zzqty1','pnl_zzamt1',FieldByName('outqty').AsFloat);
          end else                                                //sh
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('sh_wxqty1','sh_wxamt1',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('sh_twqty1','sh_twamt1',FieldByName('outqty').AsFloat)
            else //自製
               SetCDSValue('sh_zzqty1','sh_zzamt1',FieldByName('outqty').AsFloat);
          end;
        end else                                                              //正式訂單
        begin
          if Length(FieldByName('pno').AsString)=11 then          //pnl
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('pnl_wxqty2','pnl_wxamt2',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('pnl_twqty2','pnl_twamt2',FieldByName('outqty').AsFloat)
            else
               SetCDSValue('pnl_zzqty2','pnl_zzamt2',FieldByName('outqty').AsFloat);
          end else                                                //sh
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('sh_wxqty2','sh_wxamt2',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('sh_twqty2','sh_twamt2',FieldByName('outqty').AsFloat)
            else //自製
               SetCDSValue('sh_zzqty2','sh_zzamt2',FieldByName('outqty').AsFloat);
          end;
        end;
      end else                                                    //pp
      begin
        if Pos(LeftStr(FieldByName('orderno').AsString,3),l_strOrdno)>0 then  //寄售訂單
        begin
          if Length(FieldByName('pno').AsString)=12 then          //pn
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('pn_wxqty1','pn_wxamt1',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('pn_twqty1','pn_twamt1',FieldByName('outqty').AsFloat)
            else
               SetCDSValue('pn_zzqty1','pn_zzamt1',FieldByName('outqty').AsFloat);
          end else                                                //rl
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('rl_wxqty1','rl_wxamt1',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)))
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('rl_twqty1','rl_twamt1',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)))
            else //自製
               SetCDSValue('rl_zzqty1','rl_zzamt1',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)));
          end;
        end else                                                              //正式訂單
        begin
          if Length(FieldByName('pno').AsString)=12 then          //pn
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('pn_wxqty2','pn_wxamt2',FieldByName('outqty').AsFloat)
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('pn_twqty2','pn_twamt2',FieldByName('outqty').AsFloat)
            else
               SetCDSValue('pn_zzqty2','pn_zzamt2',FieldByName('outqty').AsFloat);
          end else                                                //rl
          begin
            if FieldByName('remark1').AsString=l_strwx then
               SetCDSValue('rl_wxqty2','rl_wxamt2',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)))
            else if FieldByName('remark1').AsString=l_strtw then
               SetCDSValue('rl_twqty2','rl_twamt2',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)))
            else //自製
               SetCDSValue('rl_zzqty2','rl_zzamt2',FieldByName('outqty').AsFloat*StrToInt(Copy(FieldByName('pno').AsString,11,3)));
          end;
        end;
      end;
    end;
  end;

begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢資料,請等待...');
  Application.ProcessMessages;
  try
    tmpSQL:='exec [dbo].[proc_DLIR180] '+Quotedstr(bu)+','+Quotedstr(DateToStr(d1))+','+Quotedstr(DateToStr(d2));
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    l_CDS.EmptyDataSet;
    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    try
      //正常數據
      tmpCDS1.Data:=Data;
      tmpCDS1.Filtered:=False;
      tmpCDS1.Filter:='flag=0';
      tmpCDS1.Filtered:=True;
      while not tmpCDS1.Eof do
      begin
        if l_CDS.Locate('adate',tmpCDS1.FieldByName('adate').AsDateTime,[]) then
           l_CDS.Edit
        else begin
          l_CDS.Append;
          l_CDS.FieldByName('adate').AsDateTime:=tmpCDS1.FieldByName('adate').AsDateTime;
        end;
        AddDate;
        l_CDS.Post;

        tmpCDS1.Next;
      end;
      tmpCDS1.Filtered:=False;

      //拆多筆,達交量>未交量
      tmpCDS2.Data:=Data;
      tmpCDS2.Filtered:=False;
      tmpCDS2.Filter:='flag=1';
      tmpCDS2.Filtered:=True;
      tmpCDS2.AddIndex('xIndex', 'orderno;orderitem;adate', [ixCaseInsensitive], 'adate');
      tmpCDS2.IndexName:='xIndex';
      if not tmpCDS2.IsEmpty then
      begin
        tmpOrderno:=tmpCDS2.FieldByName('orderno').AsString;
        tmpOrderitem:=tmpCDS2.FieldByName('orderitem').AsInteger;
        tmpRemainQty:=tmpCDS2.FieldByName('remainqty').AsFloat;
        while not tmpCDS2.Eof do
        begin
          if (tmpRemainQty>0) and (tmpOrderno=tmpCDS2.FieldByName('orderno').AsString) and
             (tmpOrderitem=tmpCDS2.FieldByName('orderitem').AsInteger) then
          begin
            if tmpRemainQty>=tmpCDS2.FieldByName('outqty').AsFloat then
               tmpOutQty:=tmpCDS2.FieldByName('outqty').AsFloat
            else
               tmpOutQty:=tmpRemainQty;

            if tmpOutQty>0 then
            begin
              tmpCDS1.Append;
              for i:=0 to tmpCDS1.FieldCount-1 do
                tmpCDS1.Fields[i].Value:=tmpCDS2.Fields[i].Value;
              tmpCDS1.FieldByName('outqty').AsFloat:=tmpOutQty;
              tmpCDS1.FieldByName('flag').AsInteger:=2;
              tmpCDS1.FieldByName('amt').AsFloat:=RoundTo(tmpOutQty*tmpCDS1.FieldByName('price').AsFloat*tmpCDS1.FieldByName('rates').AsFloat,-6);
              tmpCDS1.Post;

              if l_CDS.Locate('adate',tmpCDS1.FieldByName('adate').AsDateTime,[]) then
                 l_CDS.Edit
              else begin
                l_CDS.Append;
                l_CDS.FieldByName('adate').AsDateTime:=tmpCDS1.FieldByName('adate').AsDateTime;
              end;
              AddDate;
              l_CDS.Post;
            end;

            tmpRemainQty:=tmpRemainQty-tmpOutQty;
          end;

          tmpCDS2.Next;

          if (tmpOrderno<>tmpCDS2.FieldByName('orderno').AsString) or
             (tmpOrderitem<>tmpCDS2.FieldByName('orderitem').AsInteger) then
          begin
            tmpOrderno:=tmpCDS2.FieldByName('orderno').AsString;
            tmpOrderitem:=tmpCDS2.FieldByName('orderitem').AsInteger;
            tmpRemainQty:=tmpCDS2.FieldByName('remainqty').AsFloat;
          end;
        end;
      end;

      //小數位
      with l_CDS do
      begin
        First;
        while not Eof do
        begin
          Edit;
          for i:=1 to Fields.Count-1 do
            if Pos('qty',Fields[i].FieldName)>0 then
               Fields[i].AsFloat:=RoundTo(Fields[i].AsFloat,-3)
            else
               Fields[i].AsFloat:=RoundTo(Fields[i].AsFloat,-6);
          Post;
          Next;
        end;
      end;

      //明細,刪除flag=1的數據
      with tmpCDS1 do
      begin
        Filtered:=False;
        Filter:='flag=1';
        Filtered:=True;
        while not IsEmpty do
          Delete;
        Filtered:=False;
      end;

      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
      CDS.Data:=l_CDS.Data;
      CDS.IndexFieldNames:='adate';

      if tmpCDS1.ChangeCount>0 then
         tmpCDS1.MergeChangeLog;
      CDS2.Data:=tmpCDS1.Data;
      CDS2.IndexFieldNames:='adate;orderno;orderitem';
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;
 
procedure TFrmDLIR180.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     GetDS1('-1',Date,Date)
  else
     GetDS1(g_UInfo^.Bu,Date,Date);

  inherited;
end;

procedure TFrmDLIR180.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR180_1';
  p_GridDesignAns:=False;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);

  inherited;

  TabSheet20.Caption:=CheckLang('明細資料');
  SetGrdCaption(DBGridEh2, 'DLIR180_2');
end;

procedure TFrmDLIR180.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR180.btn_exportClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR180_export) then
     FrmDLIR180_export:=TFrmDLIR180_export.Create(Application);
  if FrmDLIR180_export.ShowModal=mrOK then
  begin
    case FrmDLIR180_export.rgp.ItemIndex of
      0:ToXLS;
      1:GetExportXls(CDS2, 'DLIR180_2');
    end;
  end;
end;

procedure TFrmDLIR180.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR180_query) then
     FrmDLIR180_query:=TFrmDLIR180_query.Create(Application);
  if FrmDLIR180_query.ShowModal=mrOK then
     GetDS1(FrmDLIR180_query.rgp2.Items.Strings[FrmDLIR180_query.rgp2.ItemIndex],FrmDLIR180_query.dtp1.Date,FrmDLIR180_query.dtp2.Date);
end;

procedure TFrmDLIR180.ToXLS;
const xlsFile='每日達交出貨統計表.xlsx';
var
  xlsPath,r1:string;
  r:Integer;
  ExcelApp:Variant;
  tmpCDS:TClientDataSet;
begin
  xlsPath:=ExtractFilePath(Application.Exename)+'Temp\'+xlsFile;
  if not FileExists(xlsPath) then
  begin
    ShowMsg('[Temp\'+xlsFile+']文件不存在',48);
    Exit;
  end;

  r:=5;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    ExcelApp:=CreateOleObject('Excel.Application');
    try
      ExcelApp.DisplayAlerts:=False;
      ExcelApp.WorkBooks.Open(xlsPath);
      ExcelApp.WorkSheets[1].Activate;
      tmpCDS.Data:=CDS.Data;
      tmpCDS.IndexFieldNames:='adate';
      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
        ExcelApp.Cells[r,1].Value:=tmpCDS.FieldByName('adate').AsDateTime;
        ExcelApp.Cells[r,2].Value:=tmpCDS.FieldByName('rl_wxqty1').AsFloat;
        ExcelApp.Cells[r,3].Value:=tmpCDS.FieldByName('rl_zzqty1').AsFloat;
        ExcelApp.Cells[r,4].Value:=tmpCDS.FieldByName('rl_twqty1').AsFloat;
        ExcelApp.Cells[r,5].Value:=tmpCDS.FieldByName('rl_wxqty2').AsFloat;
        ExcelApp.Cells[r,6].Value:=tmpCDS.FieldByName('rl_zzqty2').AsFloat;
        ExcelApp.Cells[r,7].Value:=tmpCDS.FieldByName('rl_twqty2').AsFloat;

        ExcelApp.Cells[r,8].Value:=tmpCDS.FieldByName('pn_wxqty1').AsFloat;
        ExcelApp.Cells[r,9].Value:=tmpCDS.FieldByName('pn_zzqty1').AsFloat;
        ExcelApp.Cells[r,10].Value:=tmpCDS.FieldByName('pn_twqty1').AsFloat;
        ExcelApp.Cells[r,11].Value:=tmpCDS.FieldByName('pn_wxqty2').AsFloat;
        ExcelApp.Cells[r,12].Value:=tmpCDS.FieldByName('pn_zzqty2').AsFloat;
        ExcelApp.Cells[r,13].Value:=tmpCDS.FieldByName('pn_twqty2').AsFloat;

        ExcelApp.Cells[r,14].Value:=tmpCDS.FieldByName('sh_wxqty1').AsFloat;
        ExcelApp.Cells[r,15].Value:=tmpCDS.FieldByName('sh_zzqty1').AsFloat;
        ExcelApp.Cells[r,16].Value:=tmpCDS.FieldByName('sh_twqty1').AsFloat;
        ExcelApp.Cells[r,17].Value:=tmpCDS.FieldByName('sh_wxqty2').AsFloat;
        ExcelApp.Cells[r,18].Value:=tmpCDS.FieldByName('sh_zzqty2').AsFloat;
        ExcelApp.Cells[r,19].Value:=tmpCDS.FieldByName('sh_twqty2').AsFloat;

        ExcelApp.Cells[r,20].Value:=tmpCDS.FieldByName('pnl_wxqty1').AsFloat;
        ExcelApp.Cells[r,21].Value:=tmpCDS.FieldByName('pnl_zzqty1').AsFloat;
        ExcelApp.Cells[r,22].Value:=tmpCDS.FieldByName('pnl_twqty1').AsFloat;
        ExcelApp.Cells[r,23].Value:=tmpCDS.FieldByName('pnl_wxqty2').AsFloat;
        ExcelApp.Cells[r,24].Value:=tmpCDS.FieldByName('pnl_zzqty2').AsFloat;
        ExcelApp.Cells[r,25].Value:=tmpCDS.FieldByName('pnl_twqty2').AsFloat;

        ExcelApp.Cells[r,26].Value:=tmpCDS.FieldByName('rl_wxamt1').AsFloat;
        ExcelApp.Cells[r,27].Value:=tmpCDS.FieldByName('rl_zzamt1').AsFloat;
        ExcelApp.Cells[r,28].Value:=tmpCDS.FieldByName('rl_twamt1').AsFloat;
        ExcelApp.Cells[r,29].Value:=tmpCDS.FieldByName('rl_wxamt2').AsFloat;
        ExcelApp.Cells[r,30].Value:=tmpCDS.FieldByName('rl_zzamt2').AsFloat;
        ExcelApp.Cells[r,31].Value:=tmpCDS.FieldByName('rl_twamt2').AsFloat;

        ExcelApp.Cells[r,32].Value:=tmpCDS.FieldByName('pn_wxamt1').AsFloat;
        ExcelApp.Cells[r,33].Value:=tmpCDS.FieldByName('pn_zzamt1').AsFloat;
        ExcelApp.Cells[r,34].Value:=tmpCDS.FieldByName('pn_twamt1').AsFloat;
        ExcelApp.Cells[r,35].Value:=tmpCDS.FieldByName('pn_wxamt2').AsFloat;
        ExcelApp.Cells[r,36].Value:=tmpCDS.FieldByName('pn_zzamt2').AsFloat;
        ExcelApp.Cells[r,37].Value:=tmpCDS.FieldByName('pn_twamt2').AsFloat;

        ExcelApp.Cells[r,38].Value:=tmpCDS.FieldByName('sh_wxamt1').AsFloat;
        ExcelApp.Cells[r,39].Value:=tmpCDS.FieldByName('sh_zzamt1').AsFloat;
        ExcelApp.Cells[r,40].Value:=tmpCDS.FieldByName('sh_twamt1').AsFloat;
        ExcelApp.Cells[r,41].Value:=tmpCDS.FieldByName('sh_wxamt2').AsFloat;
        ExcelApp.Cells[r,42].Value:=tmpCDS.FieldByName('sh_zzamt2').AsFloat;
        ExcelApp.Cells[r,43].Value:=tmpCDS.FieldByName('sh_twamt2').AsFloat;

        ExcelApp.Cells[r,44].Value:=tmpCDS.FieldByName('pnl_wxamt1').AsFloat;
        ExcelApp.Cells[r,45].Value:=tmpCDS.FieldByName('pnl_zzamt1').AsFloat;
        ExcelApp.Cells[r,46].Value:=tmpCDS.FieldByName('pnl_twamt1').AsFloat;
        ExcelApp.Cells[r,47].Value:=tmpCDS.FieldByName('pnl_wxamt2').AsFloat;
        ExcelApp.Cells[r,48].Value:=tmpCDS.FieldByName('pnl_zzamt2').AsFloat;
        ExcelApp.Cells[r,49].Value:=tmpCDS.FieldByName('pnl_twamt2').AsFloat;

        ExcelApp.Cells[r,50].Value:='=SUM(Z'+IntToStr(r)+':AW'+IntToStr(r)+')';
        Inc(r);
        tmpCDS.Next;
      end;

      r1:=IntToStr(r-1);
      ExcelApp.Cells[r,1].Value:='TOTAL';
      ExcelApp.Cells[r,2].Value:='=SUM(B5:B'+r1+')';
      ExcelApp.Cells[r,3].Value:='=SUM(C5:C'+r1+')';
      ExcelApp.Cells[r,4].Value:='=SUM(D5:D'+r1+')';
      ExcelApp.Cells[r,5].Value:='=SUM(E5:E'+r1+')';
      ExcelApp.Cells[r,6].Value:='=SUM(F5:F'+r1+')';
      ExcelApp.Cells[r,7].Value:='=SUM(G5:G'+r1+')';
      ExcelApp.Cells[r,8].Value:='=SUM(H5:H'+r1+')';
      ExcelApp.Cells[r,9].Value:='=SUM(I5:I'+r1+')';
      ExcelApp.Cells[r,10].Value:='=SUM(J5:J'+r1+')';
      ExcelApp.Cells[r,11].Value:='=SUM(K5:K'+r1+')';
      ExcelApp.Cells[r,12].Value:='=SUM(L5:L'+r1+')';
      ExcelApp.Cells[r,13].Value:='=SUM(M5:M'+r1+')';
      ExcelApp.Cells[r,14].Value:='=SUM(N5:N'+r1+')';
      ExcelApp.Cells[r,15].Value:='=SUM(O5:O'+r1+')';
      ExcelApp.Cells[r,16].Value:='=SUM(P5:P'+r1+')';
      ExcelApp.Cells[r,17].Value:='=SUM(Q5:Q'+r1+')';
      ExcelApp.Cells[r,18].Value:='=SUM(R5:R'+r1+')';
      ExcelApp.Cells[r,19].Value:='=SUM(S5:S'+r1+')';
      ExcelApp.Cells[r,20].Value:='=SUM(T5:T'+r1+')';
      ExcelApp.Cells[r,21].Value:='=SUM(U5:U'+r1+')';
      ExcelApp.Cells[r,22].Value:='=SUM(V5:V'+r1+')';
      ExcelApp.Cells[r,23].Value:='=SUM(W5:W'+r1+')';
      ExcelApp.Cells[r,24].Value:='=SUM(X5:X'+r1+')';
      ExcelApp.Cells[r,25].Value:='=SUM(Y5:Y'+r1+')';
      ExcelApp.Cells[r,26].Value:='=SUM(Z5:Z'+r1+')';
      ExcelApp.Cells[r,27].Value:='=SUM(AA5:AA'+r1+')';
      ExcelApp.Cells[r,28].Value:='=SUM(AB5:AB'+r1+')';
      ExcelApp.Cells[r,29].Value:='=SUM(AC5:AC'+r1+')';
      ExcelApp.Cells[r,30].Value:='=SUM(AD5:AD'+r1+')';
      ExcelApp.Cells[r,31].Value:='=SUM(AE5:AE'+r1+')';
      ExcelApp.Cells[r,32].Value:='=SUM(AF5:AF'+r1+')';
      ExcelApp.Cells[r,33].Value:='=SUM(AG5:AG'+r1+')';
      ExcelApp.Cells[r,34].Value:='=SUM(AH5:AH'+r1+')';
      ExcelApp.Cells[r,35].Value:='=SUM(AI5:AI'+r1+')';
      ExcelApp.Cells[r,36].Value:='=SUM(AJ5:AJ'+r1+')';
      ExcelApp.Cells[r,37].Value:='=SUM(AK5:AK'+r1+')';
      ExcelApp.Cells[r,38].Value:='=SUM(AL5:AL'+r1+')';
      ExcelApp.Cells[r,39].Value:='=SUM(AM5:AM'+r1+')';
      ExcelApp.Cells[r,40].Value:='=SUM(AN5:AN'+r1+')';
      ExcelApp.Cells[r,41].Value:='=SUM(AO5:AO'+r1+')';
      ExcelApp.Cells[r,42].Value:='=SUM(AP5:AP'+r1+')';
      ExcelApp.Cells[r,43].Value:='=SUM(AQ5:AQ'+r1+')';
      ExcelApp.Cells[r,44].Value:='=SUM(AR5:AR'+r1+')';
      ExcelApp.Cells[r,45].Value:='=SUM(AS5:AS'+r1+')';
      ExcelApp.Cells[r,46].Value:='=SUM(AT5:AT'+r1+')';
      ExcelApp.Cells[r,47].Value:='=SUM(AU5:AU'+r1+')';
      ExcelApp.Cells[r,48].Value:='=SUM(AV5:AV'+r1+')';
      ExcelApp.Cells[r,49].Value:='=SUM(AW5:AW'+r1+')';
      ExcelApp.Cells[r,50].Value:='=SUM(AX5:AX'+r1+')';

      //TOTAL居中
      ExcelApp.Range['A'+IntToStr(r)].Select;
      ExcelApp.Selection.HorizontalAlignment:=xlCenter;
      //框線
      ExcelApp.Range['A5:AX'+IntToStr(r)].Borders.LineStyle := xlContinuous;
      ExcelApp.Range['A5:AX'+IntToStr(r)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range['A5:AX'+IntToStr(r)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range['A5:AX'+IntToStr(r)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range['A5:AX'+IntToStr(r)].Borders[xlInsideHorizontal].Weight:=xlThin;
      ExcelApp.Columns.EntireColumn.AutoFit;
      ExcelApp.Range['A5'].Select;
      ExcelApp.Visible:=True;
    except
      ExcelApp.Quit;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.

