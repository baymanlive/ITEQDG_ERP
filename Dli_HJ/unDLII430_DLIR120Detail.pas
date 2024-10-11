unit unDLII430_DLIR120Detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmDLII430_DLIR120Detail = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    Panel1: TPanel;
    DS2: TDataSource;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    btn_query: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
  private
    procedure GetCDS1_data(xFilter: string);
    procedure GetCDS2_data;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII430_DLIR120Detail: TFrmDLII430_DLIR120Detail;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII430_DLIR120Detail.GetCDS1_data(xFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select *,isnull(cclpnlqty,0)+isnull(pppnlqty,0) as pnlqty From DLI018'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)+xFilter
         +' Order By Cdate Desc,Custno,Cname';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS1.Data:=Data;
    if CDS1.IsEmpty then
       GetCDS2_data;
  end;
end;

procedure TFrmDLII430_DLIR120Detail.GetCDS2_data;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI019 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' Order By kw,kb';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;
end;

procedure TFrmDLII430_DLIR120Detail.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'DLI018');
  SetGrdCaption(DBGridEh2, 'DLI019');
end;

procedure TFrmDLII430_DLIR120Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmDLII430_DLIR120Detail.FormShow(Sender: TObject);
begin
  inherited;
  GetCDS1_data(' And Cdate='+Quotedstr(DateToStr(Date)));
end;

procedure TFrmDLII430_DLIR120Detail.CDS1AfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetCDS2_data;
end;

procedure TFrmDLII430_DLIR120Detail.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  inherited;
  if GetQueryString('DLI018', tmpStr) then
  if Length(tmpStr)=0 then
     GetCDS1_data(' and cdate>=getdate()-180')
  else
     GetCDS1_data(tmpStr);
end;

procedure TFrmDLII430_DLIR120Detail.btn_okClick(Sender: TObject);
begin
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('請選擇資料!',48);
    Exit;
  end;
  
  inherited;
end;

end.
