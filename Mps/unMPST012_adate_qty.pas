unit unMPST012_adate_qty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TFrmMPST012_adate_qty = class(TFrmSTDI050)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    l_stype:string;
    l_sdate:TDateTime;
    { Public declarations }
  end;

var
  FrmMPST012_adate_qty: TFrmMPST012_adate_qty;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_adate_qty.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmMPST012_adate_qty');
  SetGrdCaption(DBGridEh2, 'FrmMPST012_adate_qty');
  SetGrdCaption(DBGridEh3, 'FrmMPST012_adate_qty');
  TabSheet1.Caption:=CheckLang('日期+數量');
  TabSheet2.Caption:=CheckLang('周+客戶+數量');
  TabSheet3.Caption:=CheckLang('周+群組+數量');
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
end;

procedure TFrmMPST012_adate_qty.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  CDS2.Active:=False;
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmMPST012_adate_qty.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select adate,sum([dbo].get_sqty(bu,materialno,sqty)) sqty from mps012'
         +' where isnull(isempty,0)=0 and bu='+Quotedstr(g_UInfo^.Bu)
         +' and sdate='+Quotedstr(DateToStr(l_sdate))
         +' and stype='+Quotedstr(l_stype)
         +' group by adate order by adate';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  Data:=null;
  tmpSQL:='declare @t table(custno varchar(100),custom varchar(100),m int,d int,sqty float,maxqty float)'
         +' insert into @t(custno,custom,m,d,sqty)'
         +' select custno,custom,m,'
         +' case when d between 1 and 7 then ''1'''
         +' when d between 8 and 14 then ''2'''
         +' when d between 15 and 21 then ''3'''
         +' when d between 22 and 28 then ''4'''
         +' else ''5'' end as d,sqty'
         +' from (select custno,custom,year(adate)*100+month(adate) m,day(adate) d,'
         +' [dbo].get_sqty(bu,materialno,sqty) sqty from mps012'
         +' where isnull(isempty,0)=0 and bu='+Quotedstr(g_UInfo^.Bu)
         +' and sdate='+Quotedstr(DateToStr(l_sdate))
         +' and stype='+Quotedstr(l_stype)+') x'
         +' update @t set maxqty=x.maxqty from mps180 x'
         +' where charindex([@t].custno,x.custno)>0 and x.bu='+Quotedstr(g_UInfo^.Bu)
         +' select custno,custom,m,d,sum(sqty) as sqty,maxqty from @t'
         +' group by custno,custom,m,d,maxqty'
         +' order by m,d,custno';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;

  Data:=null;
  tmpSQL:='declare @t table(custno varchar(100),custom varchar(100),m int,d int,sqty float,maxqty float)'
         +' insert into @t(custno,custom,m,d,sqty)'
         +' select custno,custom,m,'
         +' case when d between 1 and 7 then ''1'''
         +' when d between 8 and 14 then ''2'''
         +' when d between 15 and 21 then ''3'''
         +' when d between 22 and 28 then ''4'''
         +' else ''5'' end as d,sqty'
         +' from (select custno,custom,year(adate)*100+month(adate) m,day(adate) d,'
         +' [dbo].get_sqty(bu,materialno,sqty) sqty from mps012'
         +' where isnull(isempty,0)=0 and bu='+Quotedstr(g_UInfo^.Bu)
         +' and sdate='+Quotedstr(DateToStr(l_sdate))
         +' and stype='+Quotedstr(l_stype)+') x'
         +' update @t set custno=x.groupid,custom=null,maxqty=x.maxqty from mps180 x'
         +' where charindex([@t].custno,x.custno)>0 and x.bu='+Quotedstr(g_UInfo^.Bu)
         +' update @t set custno=custno+custom where custom is not null'
         +' select custno as groupid,m,d,sum(sqty) as sqty,maxqty from @t'
         +' group by custno,m,d,maxqty'
         +' order by m,d,custno';
  if QueryBySQL(tmpSQL, Data) then
     CDS3.Data:=Data;
end;

end.
