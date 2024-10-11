unit unMPST650_sum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, ImgList, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmMPST650_sum = class(TFrmSTDI050)
    TabSheet2: TTabSheet;
    CDS1: TClientDataSet;
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    Panel1: TPanel;
    Label2: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    btn_query: TBitBtn;
    Label1: TLabel;
    DBGridEh2: TDBGridEh;
    Panel2: TPanel;
    rgp: TRadioGroup;
    btn_export: TBitBtn;
    BitBtn1: TBitBtn;
    procedure btn_queryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure rgpClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    function GetSrcId: string;
    procedure RefreshData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST650_sum: TFrmMPST650_sum;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmMPST650_sum.GetSrcId:string;
begin
  case rgp.ItemIndex of
    0:Result:='wxpp';
    1:Result:='wxccl';
    2:Result:='twpp';
    3:Result:='twccl';
    4:Result:='jxpp';
    5:Result:='jxccl';
    6:Result:='wx';
    7:Result:='tw';
    8:Result:='jx';
  else
    Result:='wxpp';
  end;
end;

procedure TFrmMPST650_sum.RefreshData;
begin
  if (not CDS1.Active) or (not CDS2.Active) then
     Exit;

  with CDS1 do
  begin
    Filtered:=False;
    Filter:='srcid='+Quotedstr(GetSrcId);
    Filtered:=True;
  end;

  with CDS2 do
  begin
    Filtered:=False;
    Filter:='srcid='+Quotedstr(GetSrcId);
    Filtered:=True;
  end;
end;

procedure TFrmMPST650_sum.FormCreate(Sender: TObject);
var
  tmpGrdEh:TGrdEh;
begin
  inherited;
  PnlRight.Visible:=False;
  BitBtn1.Caption:=btn_quit.Caption;
  TabSheet1.Caption:=CheckLang('預計出廠');
  TabSheet2.Caption:=CheckLang('預計到廠');

  Label1.Caption:=CheckLang('查詢日期：');
  Label2.Caption:=CheckLang('至');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;

  SetLength(tmpGrdEh.grdEh,2);
  SetLength(tmpGrdEh.tb,2);
  tmpGrdEh.grdEh[0]:=DBGridEh1;
  tmpGrdEh.grdEh[1]:=DBGridEh2;
  tmpGrdEh.tb[0]:='MPST650_sum';
  tmpGrdEh.tb[1]:='MPST650_sum';
  SetMoreGrdCaption(tmpGrdEh);
  tmpGrdEh.grdEh:=nil;
  tmpGrdEh.tb:=nil;

  Dtp1.Date:=Date-30;
  Dtp2.Date:=Date;
end;

procedure TFrmMPST650_sum.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmMPST650_sum.rgpClick(Sender: TObject);
begin
  inherited;
  RefreshData;
end;

procedure TFrmMPST650_sum.btn_queryClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //inherited;

  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢起始日期不能大于截止日期',48);
    Exit;
  end;

  //as srcid為了顯示欄位名
  Data:=null;
  tmpSQL:='select srcid,ftype,units,fdate,sum(qty1) qty1,sum(qty2) qty2 from('
         +' select srcid,case when left(pno,1) in (''E'',''T'',''H'') then ''CCL'' else ''PP'' end as ftype,units,'
         +' date2 fdate,isnull(purqty,0) qty1,isnull(qty,0) qty2 from mps650'
         +' where bu=''ITEQDG'' and isnull(isfinish,0)=0'
         +' and date2 between '+Quotedstr(DateToStr(Dtp1.Date))+' and '+Quotedstr(DateToStr(Dtp2.Date))+') x'
         +' group by srcid,ftype,units,fdate'
         +' order by srcid,ftype,units,fdate';   
  if QueryBySQL(tmpSQL,Data) then
     CDS1.Data:=Data;

  Data:=null;
  tmpSQL:='select srcid,ftype,units,fdate,sum(qty1) qty1,sum(qty2) qty2 from('
         +' select srcid,case when left(pno,1) in (''E'',''T'',''H'') then ''CCL'' else ''PP'' end as ftype,units,'
         +' date4 fdate,isnull(purqty,0) qty1,isnull(qty,0) qty2 from mps650'
         +' where bu=''ITEQDG'' and isnull(isfinish,0)=0'
         +' and date2 between '+Quotedstr(DateToStr(Dtp1.Date))+' and '+Quotedstr(DateToStr(Dtp2.Date))+') x'
         +' group by srcid,ftype,units,fdate'
         +' order by srcid,ftype,units,fdate';
  if QueryBySQL(tmpSQL,Data) then
     CDS2.Data:=Data;

  RefreshData;
end;

procedure TFrmMPST650_sum.btn_exportClick(Sender: TObject);
begin
  inherited;
  case PCL.ActivePageIndex of
    0:GetExportXls(CDS1, 'MPST650_sum');
    1:GetExportXls(CDS2, 'MPST650_sum');
  end;
end;

procedure TFrmMPST650_sum.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
