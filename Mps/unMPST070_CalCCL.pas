unit unMPST070_CalCCL;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, StdCtrls,
  ImgList, Buttons, ExtCtrls,DBClient;

type
  TFrmMPST070_CalCCL = class(TFrmSTDI051)
    Panel1: TPanel;
    Label2: TLabel;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    btn_export: TBitBtn;
    Memo_sql: TMemo;
    procedure btn_quitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_CalCCLCDS: TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmMPST070_CalCCL: TFrmMPST070_CalCCL;

implementation
uses
  unGlobal, unCommon;
{$R *.dfm}

procedure TFrmMPST070_CalCCL.btn_quitClick(Sender: TObject);
begin
 // inherited;
  close;

end;

procedure TFrmMPST070_CalCCL.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CalCCLCDS);
  DBGridEh1.Free;
  memo_sql.Free;
 end;

procedure TFrmMPST070_CalCCL.btn_okClick(Sender: TObject);
var
  tmpStr1: string;
  Data: OleVariant;
begin
  //inherited;
  tmpStr1:=memo_sql.Text;
  tmpStr1:=StringReplace(tmpStr1,'@variable01',''''+FormatDatetime('YYYY-MM-DD',DateTimePicker1.date)+'''',[rfReplaceAll]);
  tmpStr1:=StringReplace(tmpStr1,'@variable02',''''+FormatDatetime('YYYY-MM-DD',DateTimePicker2.date)+'''',[rfReplaceAll]);


  if not QueryBySQL(tmpStr1, Data) then   Exit;
  l_CalCCLCDS.Data := Data;
end;
procedure TFrmMPST070_CalCCL.FormShow(Sender: TObject);
begin
  inherited;
  Label1.Caption := CheckLang('開始日期：');
  Label2.Caption := CheckLang('結束日期：');
  DateTimePicker1.date:=now();
  DateTimePicker2.date:=now()+7;
  with DBGridEh1 do
  begin
    FieldColumns['kind'].Title.Caption := CheckLang('膠系');
    FieldColumns['kind'].Width:=100;
    FieldColumns['Sqty'].Title.Caption := CheckLang('匯總數量');
    FieldColumns['Sqty'].Width:=200;
  end;
  l_CalCCLCDS := TClientDataSet.Create(Self);
  DS.DataSet := l_CalCCLCDS;
end;

procedure TFrmMPST070_CalCCL.btn_exportClick(Sender: TObject);
begin
  inherited;
   GetExportXls(l_CalCCLCDS, 'FrmMPST012_CalCCL');
end;

end.
