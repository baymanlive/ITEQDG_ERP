unit unMPST010_PnoSum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons;

type
  TFrmMPST010_PnoSum = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    rgp2: TRadioGroup;
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
  FrmMPST010_PnoSum: TFrmMPST010_PnoSum;

implementation

uses unGlobal, unCommon;

const l_tb='MPS010_PnoSum';

{$R *.dfm}

procedure TFrmMPST010_PnoSum.FormShow(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,l_tb);
  btn_ok.Caption:=CheckLang('查詢');
  BitBtn1.Caption:=CheckLang('匯出Excel');
  label1.Caption:=CheckLang('生產日期：');
  label2.Caption:=CheckLang('至');
  label3.Caption:=CheckLang('料號：');
  rgp2.Visible:=SameText(g_UInfo^.BU,'ITEQDG');
  dtp1.Date:=Date;
  dtp2.Date:=Date+7;
end;

procedure TFrmMPST010_PnoSum.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMPST010_PnoSum.btn_okClick(Sender: TObject);
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

  if rgp2.Visible then
  begin
    case rgp2.ItemIndex of
      0:tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_DG+',')+')>0';
      1:tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_GZ+',')+')>0';
    end;
  end;

  tmpSQL:='select sdate,sum(sqty) as sqty'
         +' from(select sdate,[dbo].get_sqty(bu,materialno,sqty) sqty'
         +' from mps010 where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date))+tmpSQL
         +' and sqty>0 and errorflag=0 and emptyFlag=0'
         +' union all'
         +' select sdate,[dbo].get_sqty(bu,materialno,sqty) sqty'
         +' from mps010_20160409 where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date))+tmpSQL
         +' and sqty>0 and errorflag=0 and emptyFlag=0) x'
         +' group by sdate'
         +' order by sdate';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  CDS.Data:=Data;
end;

procedure TFrmMPST010_PnoSum.BitBtn1Click(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, l_tb);
end;

end.
