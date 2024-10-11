{*******************************************************}
{                                                       }
{                unMPSR040                              }
{                Author: kaikai                         }
{                Create date: 2017/04/21                }
{                Description: PP排程結案明細            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR040;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, ExtCtrls, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;
  
const l_Color1=16772300;  //RGB(204,236,255);   //淺藍
const l_Color2=13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPSR040 = class(TFrmSTDI041)
    RG1: TRadioGroup;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Panel2: TPanel;
    procedure RG1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_ColorList:TStrings;
    function GetSumQty(SourceCDS:TClientDataSet):Double;
    procedure RefreshColor;
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetEdit3;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR040: TFrmMPSR040;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

//過濾數據
procedure TFrmMPSR040.RefreshData(xRG:TRadioGroup; xCDS:TClientDataSet);
begin
  with xCDS do
  begin
    Filtered:=False;
    if xRG.ItemIndex=-1 then
       Filter:='Machine=''@'''
    else
       Filter:='Machine='+Quotedstr(xRG.Items[xRG.ItemIndex]);
    Filtered:=True;
  end;
end;

procedure TFrmMPSR040.SetEdit3;
begin
  if CDS.FieldByName('Sdate').IsNull then
     Edit3.Text:=''
  else
     Edit3.Text:=FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  Edit4.Text:=FloatToStr(GetSumQty(CDS));
end;

procedure TFrmMPSR040.RefreshColor;
var
  tmpValue:string;
  tmpSdate:TDateTime;
  tmpCDS:TClientdataset;
begin
  l_ColorList.Clear;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;
  tmpCDS:=TClientdataset.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.Filter:=CDS.Filter;
    tmpCDS.Filtered:=True;
    tmpCDS.AddIndex('xIndex', CDS.IndexDefs[0].Fields, [ixCaseInsensitive], CDS.IndexDefs[0].DescFields);
    tmpCDS.IndexName:='xIndex';
    tmpValue:='1';
    tmpSdate:=EncodeDate(1955,5,5);
    while not tmpCDS.Eof do
    begin
      if tmpSdate<>tmpCDS.FieldByName('Sdate').AsDateTime then
      begin
        if tmpValue='1' then
           tmpValue:='2'
        else
           tmpValue:='1';
      end;
      l_ColorList.Add(tmpValue);
      tmpSdate:=tmpCDS.FieldByName('Sdate').AsDateTime;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
end;

function TFrmMPSR040.GetSumQty(SourceCDS:TClientDataSet):Double;
var
  tmpCDS:TClientDataSet;
begin
  Result:=0;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=SourceCDS.Data;
    with tmpCDS do
    begin
      Filtered:=False;
      Filter:='Machine='+Quotedstr(SourceCDS.FieldByName('Machine').AsString)
             +' And Sdate='+Quotedstr(DateToStr(SourceCDS.FieldByName('Sdate').AsDateTime))
             +' And (Sqty is not null) And Sqty<>0';
      Filtered:=True;
      while not Eof do
      begin
        Result:=Result+FieldByName('Sqty').AsFloat;
        Next;
      end;
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPSR040.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;                 
begin
  tmpSQL:='select custno2,custname2,machine,sdate,wono,orderdate,orderno,orderitem,materialno,sqty,'
         +' adate_new,custno,custom,custom2,breadth,fiber,premark,wostation_qtystr,'
         +' orderqty,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,edate,'
         +' simuver,citem,jitem,ad,fi,rc,errorflag,fisno'
         +' from mps070 where bu='+Quotedstr(g_UInfo^.BU)
         +' and case_ans2=1 and isnull(errorflag,0)=0 '+strFilter
         +' union all'
         +' select custno2,custname2,machine,sdate,wono,orderdate,orderno,orderitem,materialno,sqty,'
         +' adate_new,custno,custom,custom2,breadth,fiber,premark,wostation_qtystr,'
         +' orderqty,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,edate,'
         +' simuver,citem,jitem,ad,fi,rc,errorflag,fisno'
         +' from MPS070_bak where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate>=getdate()-60'
         +' and case_ans2=1 and isnull(errorflag,0)=0 '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    if RG1.Tag=0 then
    begin
      RefreshData(RG1, CDS);
      RefreshColor;
      DBGridEh1.Repaint;
      if CDS.IsEmpty then
         SetEdit3;
    end;
  end;

  inherited;
end;

procedure TFrmMPSR040.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS070';
  p_GridDesignAns:=True;
  RG1.Tag:=1;

  inherited;

  Label3.Caption:=CheckLang('生產日期/米');
  l_ColorList:=TStringList.Create;
  GetMPSMachine;
  RG1.Items.DelimitedText:=g_MachinePP;
  RG1.Tag:=0;
  RG1.ItemIndex:=0;
  if SameText(g_UInfo^.BU,'ITEQJX') then
  begin
    RG1.Columns:=2;
    Panel2.Width:=Panel2.Width*2+10;
    RG1.Width:=RG1.Width*2+10;
    RG1.Height:=RG1.Height+180;
  end;
end;

procedure TFrmMPSR040.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
end;

procedure TFrmMPSR040.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetEdit3;
end;

procedure TFrmMPSR040.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag=1) then
     Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPSR040.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if l_ColorList.Count>=CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=l_Color2
    else
       Background:=l_Color1;
  end;
end;

end.
