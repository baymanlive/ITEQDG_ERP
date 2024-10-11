{*******************************************************}
{                                                       }
{                unMPSR060                              }
{                Author: kaikai                         }
{                Create date: 2015/10/10                }
{                Description: 客戶每條線產能統計表      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmMPSR060 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR060: TFrmMPSR060;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR060.RefreshDS(strFilter: string);
var
  tmpSQL,tmpFilter:string;
  Data:OleVariant;
begin
  if Pos('thick_qry',strFilter)>0 then
     tmpFilter:=StringReplace(strFilter,'thick_qry','substring(materialno,3,4)',[])
  else
     tmpFilter:=strFilter;
  tmpSQL:='Select *,L1+L2+L3+L4+L5+L6 AS Tot From ('
         +'Select Sdate,Custno,Custom,'
         +'Sum(Case When Machine=''L1'' Then Sqty Else 0 End) AS L1,'
         +'Sum(Case When Machine=''L2'' Then Sqty Else 0 End) AS L2,'
         +'Sum(Case When Machine=''L3'' Then Sqty Else 0 End) AS L3,'
         +'Sum(Case When Machine=''L4'' Then Sqty Else 0 End) AS L4,'
         +'Sum(Case When Machine=''L5'' Then Sqty Else 0 End) AS L5,'
         +'Sum(Case When Machine=''L6'' Then Sqty Else 0 End) AS L6 '
         +' From MPS010 Where Len(Custno)>0'
         +' And Sdate>='+Quotedstr(DateToStr(Date-90))+tmpFilter
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Group By Sdate,Custno,Custom) AS X'
         +' Order By Sdate,Custno';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  Data:=null;
  tmpSQL:='Select *,L1+L2+L3+L4+L5+L6 AS Tot From ('
         +'Select Sdate,'
         +'Sum(Case When Machine=''L1'' Then Sqty Else 0 End) AS L1,'
         +'Sum(Case When Machine=''L2'' Then Sqty Else 0 End) AS L2,'
         +'Sum(Case When Machine=''L3'' Then Sqty Else 0 End) AS L3,'
         +'Sum(Case When Machine=''L4'' Then Sqty Else 0 End) AS L4,'
         +'Sum(Case When Machine=''L5'' Then Sqty Else 0 End) AS L5,'
         +'Sum(Case When Machine=''L6'' Then Sqty Else 0 End) AS L6 '
         +' From MPS010 Where Sdate>='+Quotedstr(DateToStr(Date-90))+tmpFilter
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Group By Sdate) AS X'
         +' Order By Sdate';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;

  inherited;
end;

procedure TFrmMPSR060.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR060';
  p_GridDesignAns:=False;

  inherited;

  TabSheet1.Caption:=CheckLang('客戶產能');
  TabSheet2.Caption:=CheckLang('總產能');
  SetGrdCaption(DBGridEh2, p_TableName);
end;

procedure TFrmMPSR060.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh2.Free;
end;

procedure TFrmMPSR060.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出[客戶產能]請按[是]'+#13#10+'匯出[總產能]請按[否]'+#13#10+'[取消]無操作',35) of
    IdYes:GetExportXls(CDS, p_TableName);
    IdNo:GetExportXls(CDS2, p_TableName);
  end;
end;

end.
