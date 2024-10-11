unit unMPST070_UseCoreDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons;

type
  TFrmMPST070_UseCoreDetail = class(TFrmSTDI051)
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
    rgp1: TRadioGroup;
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure rgp1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_UseCoreDetail: TFrmMPST070_UseCoreDetail;

implementation

uses unGlobal, unCommon;

const l_tb='MPS070_usecoredetail';

{$R *.dfm}

procedure TFrmMPST070_UseCoreDetail.FormShow(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,l_tb);
  rgp1.Items.Strings[2]:=CheckLang('BR其它');
  if not SameText(g_UInfo^.BU,'ITEQDG') then
     rgp2.Visible:=False;
  btn_ok.Caption:=CheckLang('查詢');
  BitBtn1.Caption:=CheckLang('匯出Excel');
  label1.Caption:=CheckLang('生產日期：');
  label2.Caption:=CheckLang('至');

  dtp1.Date:=Date;
  dtp2.Date:=Date+7;
end;

procedure TFrmMPST070_UseCoreDetail.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMPST070_UseCoreDetail.btn_okClick(Sender: TObject);
var
  i:Integer;
  tmpList:TStrings;
  tmpSQL:string;
  Data:OleVariant;
begin
  //inherited;
  if rgp1.ItemIndex=0 then
  begin
    if not rgp2.Visible then
       tmpSQL:=' and custno='+Quotedstr(CheckLang('自用'))
    else begin
       case rgp2.ItemIndex of
         0:tmpSQL:=' and custno='+Quotedstr(CheckLang('DG自用'));
         1:tmpSQL:=' and custno='+Quotedstr(CheckLang('GZ自用'));
         2:tmpSQL:=' and custno in ('+Quotedstr(CheckLang('DG自用'))+','+Quotedstr(CheckLang('GZ自用'))+')';
       end;

       tmpSQL:=tmpSQL+' and machine not in (''T9'',''T10'')';
    end;

    tmpSQL:='select materialno,sum(sqty) sqty from ('
           +' select substring(materialno,2,9) materialno,sqty from mps070'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and left(materialno,1) in (''P'',''Q'')'
           +' and isnull(errorflag,0)=0 '+tmpSQL
           +' union all'
           +' select substring(materialno,2,9) materialno,sqty from MPS070_bak'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and left(materialno,1) in (''P'',''Q'')'
           +' and isnull(errorflag,0)=0'+tmpSQL
           +' ) t group by materialno';
  end
  else if rgp1.ItemIndex=1 then
  begin
    if rgp2.Visible then
    begin
      case rgp2.ItemIndex of
        0:tmpSQL:=' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_DG+',')+')>0';
        1:tmpSQL:=' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_GZ+',')+')>0';
        2:tmpSQL:=' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_DG+','+g_MachinePP_GZ+',')+')>0';
      end;
    end;

    tmpSQL:='select sdate as materialno,sum(sqty) sqty from ('
           +' select sdate,sqty from mps070'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and left(materialno,1) in (''B'',''R'')'
           +' and isnull(errorflag,0)=0 '+tmpSQL
           +' union all'
           +' select sdate,sqty from MPS070_bak'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and left(materialno,1) in (''B'',''R'')'
           +' and isnull(errorflag,0)=0 '+tmpSQL
           +' ) t group by sdate';
  end else
  begin
    if Length(Trim(Edit1.Text))=0 then
    begin
      ShowMsg('選擇['+rgp1.Items.Strings[2]+'],請輸入查詢條件'+#13#10+'即:料號前N碼,多個值用逗號(,)隔開',48);
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
        0:tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_DG+',')+')>0';
        1:tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_GZ+',')+')>0';
        2:tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachinePP_DG+','+g_MachinePP_GZ+',')+')>0';
      end;
    end;

    tmpSQL:='select sdate as materialno,sum(sqty) sqty from ('
           +' select sdate,sqty from mps070'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and isnull(errorflag,0)=0 '+tmpSQL
           +' union all'
           +' select sdate,sqty from MPS070_bak'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and isnull(errorflag,0)=0 '+tmpSQL
           +' ) t group by sdate';
  end;

  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  CDS.Data:=Data;
end;

procedure TFrmMPST070_UseCoreDetail.BitBtn1Click(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, l_tb);
end;

procedure TFrmMPST070_UseCoreDetail.rgp1Click(Sender: TObject);
begin
  inherited;
  if rgp1.ItemIndex=2 then
     Edit1.Color:=clWindow
  else
     Edit1.Color:=clSilver;
end;

end.
