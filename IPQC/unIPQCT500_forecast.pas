unit unIPQCT500_forecast;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, ExtCtrls, ComCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons;

type
  TFrmIPQCT500_forecast = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    Label1: TLabel;
    CDS: TClientDataSet;
    DS: TDataSource;
    Dtp1: TDateTimePicker;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    RG: TRadioGroup;
    Panel1: TPanel;
    btn_export: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT500_forecast: TFrmIPQCT500_forecast;

implementation

uses unGlobal, unCommon, unIPQCT500;

{$R *.dfm}

procedure TFrmIPQCT500_forecast.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'IPQC500');
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=CheckLang('至');
  Dtp1.Date:=Date;
  Dtp2.Date:=Dtp1.Date+6;
end;

procedure TFrmIPQCT500_forecast.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmIPQCT500_forecast.btn_okClick(Sender: TObject);
var
  tmpBu,tmpStr:string;
  Data:OleVariant;
begin
  //inherited;
  if RG.ItemIndex=0 then
     tmpBu:='ITEQDG'
  else
     tmpBu:='ITEQGZ';
  tmpStr:='Select B.Fiber,A.Breadth,A.Fiber Vendor,B.Code Pno,Sum(A.Sqty) Qty'
         +' From MPS070 A Left Join (Select * From MPS620 Where Bu='+Quotedstr(tmpBu)+') B'
         +' ON (Case When A.Fi=''2313a'' Then ''3313'' Else A.FI End)=B.Fiber'
         +'   And CHARINDEX(A.Breadth, B.Breadth)>0 And A.Fiber=B.Vendor'
         +' Where A.Bu=''ITEQDG'' And A.Sdate Between '+Quotedstr(DateToStr(Dtp1.Date))
         +' And '+Quotedstr(DateToStr(Dtp2.Date))
         +' And IsNull(A.EmptyFlag,0)=0 And IsNull(A.ErrorFlag,0)=0 And IsNull(A.Case_ans2,0)=0';
  if RG.ItemIndex=0 then
     tmpStr:=tmpStr+' And A.Machine in (''T1'',''T2'',''T3'',''T4'',''T5'')'
  else
     tmpStr:=tmpStr+' And A.Machine in (''T6'',''T7'',''T8'')';
  tmpStr:=tmpStr+' Group By B.Fiber,A.Breadth,A.Fiber,B.Code';     
  if not QueryBySQL(tmpStr, Data) then
     Exit;
  CDS.Data:=Data;
end;

procedure TFrmIPQCT500_forecast.btn_exportClick(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, 'IPQC500');
end;

end.
