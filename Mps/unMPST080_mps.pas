unit unMPST080_mps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  Buttons, ExtCtrls, ComCtrls, ToolWin, DBClient, DB;

type
  TFrmMPST080_mps = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    lblsdate: TLabel;
    CDS: TClientDataSet;
    DS: TDataSource;
    Dtp1: TDateTimePicker;
    lblto: TLabel;
    Dtp2: TDateTimePicker;
    RG: TRadioGroup;
    pnl101: TPanel;
    pnl102: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure RGClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    l_ColorList:TStrings;
    procedure RefreshColor;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST080_mps: TFrmMPST080_mps;

implementation

uses unGlobal, unCommon, unMPST080;

{$R *.dfm}

procedure TFrmMPST080_mps.RefreshColor;
var
  tmpStr,tmpValue:string;
  tmpCDS:TClientdataset;
begin
  l_ColorList.Clear;
  if not CDS.Active then
     Exit;
  tmpCDS:=TClientdataset.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.Filter:=CDS.Filter;
    tmpCDS.Filtered:=True;
    tmpCDS.IndexFieldNames:=CDS.IndexFieldNames;
    
    tmpValue:='1';
    tmpStr:='@';
    while not tmpCDS.Eof do
    begin
      if tmpStr<>tmpCDS.FieldByName('Stealno').AsString then
      begin
        if tmpValue='1' then
           tmpValue:='2'
        else
           tmpValue:='1';
      end;
      l_ColorList.Add(tmpValue);
      tmpStr:=tmpCDS.FieldByName('Stealno').AsString;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPST080_mps.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'MPST080_mps');
  RG.Items.DelimitedText:=g_MachineCCL;
  RG.ItemIndex:=0;
  RG.Columns:=RG.Items.Count;
  Dtp1.Date:=Date-30;
  Dtp2.Date:=Date;
  l_ColorList:=TStringList.Create;
end;

procedure TFrmMPST080_mps.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
  l_ColorList.Free;
end;

procedure TFrmMPST080_mps.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;
  if l_ColorList.Count>=CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=RGB(255,255,204)
    else
       Background:=RGB(204,236,255);
  end;
end;

procedure TFrmMPST080_mps.RGClick(Sender: TObject);
begin
  inherited;
  if not CDS.Active then
     Exit;

  CDS.Filtered:=False;
  CDS.Filter:='Machine='+Quotedstr(RG.Items.Strings[RG.ItemIndex]);
  CDS.Filtered:=True;
  RefreshColor;
end;

procedure TFrmMPST080_mps.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //inherited;
  tmpSQL:='Select Simuver,Citem,Jitem,OZ,Machine,Sdate,CurrentBoiler,Wono,'
         +' Orderno,Orderitem,Materialno,Sqty,Adate_new,Custno,Stealno,'
         +' Premark,Orderqty,Orderno2,Orderitem2,Materialno1,Pnlsize1,Pnlsize2'
         +' From MPS010 Where Bu=''ITEQDG'''
         +' And Sdate>='+Quotedstr(DateToStr(Dtp1.Date))
         +' And Sdate<='+Quotedstr(DateToStr(Dtp2.Date))
         +' And IsNull(ErrorFlag,0)=0'
         +' Union ALL'
         +' Select Simuver,Citem,Jitem,OZ,Machine,Sdate,CurrentBoiler,Wono,'
         +' Orderno,Orderitem,Materialno,Sqty,Adate_new,Custno,Stealno,'
         +' Premark,Orderqty,Orderno2,Orderitem2,Materialno1,Pnlsize1,Pnlsize2'
         +' From MPS010_20160409 Where Bu=''ITEQDG'''
         +' And Sdate>='+Quotedstr(DateToStr(Dtp1.Date))
         +' And Sdate<='+Quotedstr(DateToStr(Dtp2.Date))
         +' And IsNull(ErrorFlag,0)=0'
         +' Order By Machine,Jitem,OZ,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    RGClick(RG);
  end;
end;

end.
