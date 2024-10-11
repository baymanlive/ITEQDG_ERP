unit unMPST012_PnoSum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons;

type
  TFrmMPST012_PnoSum = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    CDS: TClientDataSet;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST012_PnoSum: TFrmMPST012_PnoSum;

implementation

uses unGlobal, unCommon;

const l_tb='MPS012_PnoSum';

{$R *.dfm}

procedure TFrmMPST012_PnoSum.FormShow(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,l_tb);
  btn_ok.Caption:=CheckLang('查詢');
  BitBtn1.Caption:=CheckLang('匯出Excel');
  label1.Caption:=CheckLang('生產日期：');
  label2.Caption:=CheckLang('至');
  label3.Caption:=CheckLang('料號：');

  dtp1.Date:=Date;
  dtp2.Date:=Date+7;
end;

procedure TFrmMPST012_PnoSum.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMPST012_PnoSum.btn_okClick(Sender: TObject);
var
  i:Integer;
  tmpList:TStrings;
  tmpSQL:string;
  Data:OleVariant;
begin
  //inherited;
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入查詢條件'+#13#10+'即:料號前N碼,多個值用逗號(,)隔開',48);
    Exit;
  end;

  tmpList:=TStringList.Create;
  try
    tmpList.DelimitedText:=Edit1.Text;
    for i:=0 to tmpList.Count-1 do
      tmpSQL:=tmpSQL+' or materialno like '+Quotedstr(tmpLIst.Strings[i]+'%');
  finally
    FreeAndNil(tmpList);
  end;

  Delete(tmpSQL,1,4);
  tmpSQL:=' and ('+tmpSQL+')';

  tmpSQL:='select sdate,sum([dbo].get_sqty(bu,materialno,sqty)) sqty'
         +' from mps012 where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date))+tmpSQL
         +' and sqty>0 and isnull(isempty,0)=0'
         +' group by sdate'
         +' order by sdate';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  CDS.Data:=Data;
end;

procedure TFrmMPST012_PnoSum.BitBtn1Click(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, l_tb);
end;

end.
