unit unMPST070_CalPP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ComCtrls,
  DB, GridsEh, DBAxisGridsEh, DBGridEh,DBClient;

type
  TFrmMPST070_CalPP = class(TFrmSTDI051)
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    btn_export: TBitBtn;
    procedure btn_quitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
     l_CalPPCDS: TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmMPST070_CalPP: TFrmMPST070_CalPP;

implementation

uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmMPST070_CalPP.btn_quitClick(Sender: TObject);
begin
  //inherited;
   close;
end;

procedure TFrmMPST070_CalPP.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CalPPCDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST070_CalPP.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption := CheckLang('開始日期：');
  Label2.Caption := CheckLang('結束日期：');
  with DBGridEh1 do
  begin
    FieldColumns['kind'].Title.Caption := CheckLang('膠系');
    FieldColumns['kind'].Width:=100;
    FieldColumns['Sqty'].Title.Caption := CheckLang('匯總數量');
    FieldColumns['Sqty'].Width:=200;
  end;
  l_CalPPCDS := TClientDataSet.Create(Self);
  DS.DataSet := l_CalPPCDS;
end;

procedure TFrmMPST070_CalPP.btn_okClick(Sender: TObject);
var
  tmpStr1: string;
  tmpQty: Double;
  Data: OleVariant;
begin
  //inherited;
 tmpStr1:=' select substring(Materialno,2,1) as kind,sum(isnull(Sqty,0)) as Sqty from MPS070 where Bu='''+g_UInfo^.BU+''' And IsNull(Case_ans2,0)=0 '
         +' and substring(Materialno,1,1) in ('''+'R'+''','''+'B'+''' )'
         +' and CONVERT(varchar(10),Sdate,120)>=CONVERT(varchar(10),'''+FormatDatetime('YYYY-MM-DD',DateTimePicker1.date)+''',120)'
         +' and CONVERT(varchar(10),Sdate,120)<=CONVERT(varchar(10),'''+FormatDatetime('YYYY-MM-DD',DateTimePicker2.date)+''',120)'
         +' group by substring(Materialno,2,1) ';
         
  if not QueryBySQL(tmpStr1, Data) then   Exit;
  l_CalPPCDS.Data := Data;
end;
procedure TFrmMPST070_CalPP.btn_exportClick(Sender: TObject);
begin
  inherited;
   GetExportXls(l_CalPPCDS, 'FrmMPST070_CalPP');
end;

end.
