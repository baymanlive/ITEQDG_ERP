{*******************************************************}
{                                                       }
{                unMPSR130                              }
{                Author: kaikai                         }
{                Create date: 2017/12/15                }
{                Description: 排程良率分析              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, Math,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, unGridDesign, DateUtils, StrUtils;

type
  TFrmMPSR130 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_mpsr130: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpsr130Click(Sender: TObject);
  private
    l_CDS1,l_CDS2:TClientDataSet;
    l_GridDesign2:TGridDesign;
    procedure GetDS(xFliter:string);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR130: TFrmMPSR130;

implementation

uses unGlobal, unCommon, unMPSR130_Query;

{$R *.dfm}

const l_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="machine" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="sdate" fieldtype="date"/>'
            +'<FIELD attrname="currentboiler" fieldtype="i4"/>'
            +'<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderdate" fieldtype="date"/>'
            +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderitem" fieldtype="i4"/>'
            +'<FIELD attrname="orderqty" fieldtype="r8"/>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custom" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="materialno1" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pnlsize1" fieldtype="r8"/>'
            +'<FIELD attrname="pnlsize2" fieldtype="r8"/>'
            +'<FIELD attrname="sqty" fieldtype="r8"/>'
            +'<FIELD attrname="wqty" fieldtype="r8"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="adate_new" fieldtype="date"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const l_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="bu" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custom" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="materialno" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="materialno1" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pnlsize1" fieldtype="r8"/>'
            +'<FIELD attrname="pnlsize2" fieldtype="r8"/>'
            +'<FIELD attrname="sqty" fieldtype="r8"/>'
            +'<FIELD attrname="wqty" fieldtype="r8"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

procedure TFrmMPSR130.GetDS(xFliter:string);
var
  i,cnt1,cnt2:Integer;
  lo:Boolean;
  Data:OleVariant;
  tmpSQL,str1,str2:string;
  tmpCDS:TClientDataSet;
begin
  l_CDS1.DisableControls;
  l_CDS1.EmptyDataSet;
  l_CDS2.DisableControls;
  l_CDS2.EmptyDataSet;
  g_StatusBar.Panels[0].Text:='正在查詢...';
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select machine,sdate,currentboiler,wono,orderdate,orderno,orderitem,'
           +' orderqty,custno,custom,materialno,materialno1,pnlsize1,pnlsize2,sqty,'
           +' sqty as wqty,custno as per,adate_new from mps010'
           +' where bu='+Quotedstr(g_UInfo^.BU)+xFliter
           +' union all'
           +' select machine,sdate,currentboiler,wono,orderdate,orderno,orderitem,'
           +' orderqty,custno,custom,materialno,materialno1,pnlsize1,pnlsize2,sqty,'
           +' sqty as wqty,custno as per,adate_new from MPS010_20160409'
           +' where bu='+Quotedstr(g_UInfo^.BU)+xFliter
           +' order by machine,sdate,currentboiler';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpSQL:='';
    cnt1:=0;
    cnt2:=0;
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if IsEmpty then
         Exit;
      while not Eof do
      begin
        if SameText(FieldByName('machine').AsString,'L6') then
        begin
          str1:=str1+','+Quotedstr(FieldByName('wono').AsString);
          Inc(cnt1);
        end else
        begin
          str2:=str2+','+Quotedstr(FieldByName('wono').AsString);
          Inc(cnt2);
        end;
        l_CDS1.Append;
        for i:=0 to Fields.Count-1 do
           l_CDS1.FieldByName(Fields[i].FieldName).Value:=Fields[i].Value;
        l_CDS1.FieldByName('wqty').AsFloat:=0;
        l_CDS1.FieldByName('per').AsString:='0%';
        l_CDS1.Post;
        Next;

        if ((cnt1=1000) or Eof) and (Length(str1)>0) then   //in條件不超1000
        begin
          System.Delete(str1,1,1);
          if Length(tmpSQL)>0 then
             tmpSQL:=tmpSQL+' union all ';
          tmpSQL:=tmpSQL+'select A.shb05,B.tc_sih04,1 as gz'
                        +' from iteqgz.shb_file A inner join iteqgz.tc_sih_file B'
                        +' on A.shb01=B.tc_sih01'
                        +' where A.shb05 in ('+str1+') and A.shb06=6'
                        +' and A.ta_shbconf=''Y'' And B.tc_sih04>0';
          str1:='';
          cnt1:=0;
        end;

        if ((cnt2=1000) or Eof) and (Length(str2)>0) then  //in條件不超1000
        begin
          System.Delete(str2,1,1);
          if Length(tmpSQL)>0 then
             tmpSQL:=tmpSQL+' union all ';
          tmpSQL:=tmpSQL+'select A.shb05,B.tc_sih04,0 as gz'
                        +' from iteqdg.shb_file A inner join iteqdg.tc_sih_file B'
                        +' on A.shb01=B.tc_sih01'
                        +' where A.shb05 in ('+str2+') and A.shb06=6'
                        +' and A.ta_shbconf=''Y'' And B.tc_sih04>0';
          str2:='';
          cnt2:=0;
        end;

      end;
    end;

    if Length(tmpSQL)>0 then
    begin
      tmpSQL:='select shb05,sum(tc_sih04) qty,gz from ('+tmpSQL+') t group by shb05,gz order by shb05,gz';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;

      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        with l_CDS1 do
        begin
          First;
          while not Eof do
          begin
            if SameText(FieldByName('machine').AsString,'L6') then
               lo:=tmpCDS.Locate('shb05;gz',VarArrayOf([FieldByName('wono').AsString,1]),[])
            else
               lo:=tmpCDS.Locate('shb05;gz',VarArrayOf([FieldByName('wono').AsString,0]),[]);
            if lo then
            begin
              Edit;
              FieldByName('wqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
              FieldByName('per').AsString:=IntToStr(Round(FieldByName('wqty').AsFloat*100/FieldByName('sqty').AsFloat))+'%';
              Post;
            end;
            Next;
          end;
        end;
      end;
    end;

    if l_CDS1.ChangeCount>0 then
       l_CDS1.MergeChangeLog;

    l_CDS1.First;
    while not l_CDS1.Eof do
    begin
      if SameText(l_CDS1.FieldByName('machine').AsString,'L6') then
         tmpSQL:='ITEQGZ'
      else
         tmpSQL:='ITEQDG';
      if Length(l_CDS1.FieldByName('materialno1').AsString)>0 then
         lo:=l_CDS2.Locate('bu;custno;materialno;materialno1;pnlsize1;pnlsize2',
              VarArrayOf([tmpSQL,l_CDS1.FieldByName('custno').AsString,
                                 l_CDS1.FieldByName('materialno').AsString,
                                 l_CDS1.FieldByName('materialno1').AsString,
                                 l_CDS1.FieldByName('pnlsize1').AsFloat,
                                 l_CDS1.FieldByName('pnlsize2').AsFloat]),[])
      else
         lo:=l_CDS2.Locate('bu;custno;materialno',
              VarArrayOf([tmpSQL,l_CDS1.FieldByName('custno').AsString,
                                 l_CDS1.FieldByName('materialno').AsString]),[]);

      if lo then
         l_CDS2.Edit
      else
      begin
        l_CDS2.Append;
        l_CDS2.FieldByName('bu').AsString:=tmpSQL;
        l_CDS2.FieldByName('custno').AsString:=l_CDS1.FieldByName('custno').AsString;
        l_CDS2.FieldByName('custom').AsString:=l_CDS1.FieldByName('custom').AsString;
        l_CDS2.FieldByName('materialno').AsString:=l_CDS1.FieldByName('materialno').AsString;
        if Length(l_CDS1.FieldByName('materialno1').AsString)>0 then
        begin
          l_CDS2.FieldByName('materialno1').AsString:=l_CDS1.FieldByName('materialno1').AsString;
          l_CDS2.FieldByName('pnlsize1').AsFloat:=l_CDS1.FieldByName('pnlsize1').AsFloat;
          l_CDS2.FieldByName('pnlsize2').AsFloat:=l_CDS1.FieldByName('pnlsize2').AsFloat;
        end;
      end;
      l_CDS2.FieldByName('sqty').AsFloat:=l_CDS2.FieldByName('sqty').AsFloat+l_CDS1.FieldByName('sqty').AsFloat;
      l_CDS2.FieldByName('wqty').AsFloat:=l_CDS2.FieldByName('wqty').AsFloat+l_CDS1.FieldByName('wqty').AsFloat;
      l_CDS2.FieldByName('per').AsString:=FloatToStr(RoundTo(l_CDS2.FieldByName('wqty').AsFloat*100/l_CDS2.FieldByName('sqty').AsFloat,-1))+'%';
      l_CDS2.Post;

      l_CDS1.Next;
    end;

    if l_CDS2.ChangeCount>0 then
       l_CDS2.MergeChangeLog;
  finally
    tmpCDS.Free;
    l_CDS1.EnableControls;
    l_CDS2.EnableControls;
    CDS.Data:=l_CDS1.Data;
    CDS2.Data:=l_CDS2.Data;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR130.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
  begin
     CDS.Data:=l_CDS1.Data;
     CDS2.Data:=l_CDS2.Data;
  end else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmMPSR130.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR130_1';
  p_GridDesignAns:=True;
  l_CDS1:=TClientDataSet.Create(Self);
  l_CDS2:=TClientDataSet.Create(Self);
  InitCDS(l_CDS1,l_Xml1);
  InitCDS(l_CDS2,l_Xml2);
  btn_mpsr130.Left:=btn_quit.Left;

  inherited;

  TabSheet1.Caption:=CheckLang('排程良率');
  TabSheet2.Caption:=CheckLang('客戶良率');
  SetGrdCaption(DBGridEh2, 'MPSR130_2');
  l_GridDesign2:=TGridDesign.Create(DBGridEh2, 'MPSR130_2');
  CDS.IndexFieldNames:='machine;sdate;currentboiler;custno;materialno';
  CDS2.IndexFieldNames:='bu;custno;materialno';
end;

procedure TFrmMPSR130.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     FreeAndNil(l_GridDesign2);
  FreeAndNil(DBGridEh2);
end;

procedure TFrmMPSR130.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
end;

procedure TFrmMPSR130.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出排程良率請按[是]'+#13#10
              +'客戶良率請按[否]'+#13#10
              +'無操作請按[取消]',35) of
    IdYes: GetExportXls(CDS,  'MPSR130_1');
    IdNo : GetExportXls(CDS2, 'MPSR130_2');
  end;
end;

procedure TFrmMPSR130.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR130_Query) then
     FrmMPSR130_Query:=TFrmMPSR130_Query.Create(Application);
  if FrmMPSR130_Query.ShowModal=mrOK then
     RefreshDS(FrmMPSR130_Query.l_ret);
end;

procedure TFrmMPSR130.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPSR130.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.ColWidthChange;
end;

procedure TFrmMPSR130.btn_mpsr130Click(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active then
     str:=CDS.FieldByName('materialno').AsString;
  GetQueryStock(str, true);
end;

end.
