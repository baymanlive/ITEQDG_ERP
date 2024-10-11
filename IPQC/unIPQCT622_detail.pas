unit unIPQCT622_detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmIPQCT622_detail = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    CDS: TClientDataSet;
    Panel1: TPanel;
    Panel2: TPanel;
    lbllot: TLabel;
    Edit1: TEdit;
    lblerr: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_okClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    l_Data:OleVariant;
    { Public declarations }
  end;

var
  FrmIPQCT622_detail: TFrmIPQCT622_detail;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT622_detail.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmIPQCT623');

  tmpSQL:='Select ad,ver,lot,qty,'
         +' round((isnull(sg1_value1,0)+isnull(sg1_value2,0)+isnull(sg1_value3,0))/3,2) as sg1,sg1_std,'
         +' case (select top 1 b from(select sg2_atime as a,1 as b union all select sg2_btime,2'
         +'       union all select sg2_ctime,3 union all select sg2_dtime,4 union all select sg2_etime,5) o order by a desc)'
         +'	when 1 then round((isnull(sg2_avalue1,0)+isnull(sg2_avalue2,0)+isnull(sg2_avalue3,0))/3,2)'
         +' when 2 then round((isnull(sg2_bvalue1,0)+isnull(sg2_bvalue2,0)+isnull(sg2_bvalue3,0))/3,2)'
         +' when 3 then round((isnull(sg2_cvalue1,0)+isnull(sg2_cvalue2,0)+isnull(sg2_cvalue3,0))/3,2)'
         +' when 4 then round((isnull(sg2_dvalue1,0)+isnull(sg2_dvalue2,0)+isnull(sg2_dvalue3,0))/3,2)'
         +' when 5 then round((isnull(sg2_evalue1,0)+isnull(sg2_evalue2,0)+isnull(sg2_evalue3,0))/3,2) else 0 end as sg2,'
         +' sg2_astd as sg2_std,'
         +' round((isnull(sg3_value1,0)+isnull(sg3_value2,0)+isnull(sg3_value3,0))/3,2) as sg3,sg3_std,'
         +' niandu,ludaiqty,t1,t1_time,t2,t2_time,t3,t3_time,t4,t4_time,garbageflag,waste_pno'
         +' From IPQC620 Where Bu='+Quotedstr(g_UInfo^.Bu)
         +' and idate>getdate()-180 and isnull(garbageflag,0)=0 order by idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmIPQCT622_detail.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

//與查詢FrmIPQCT622_query一樣
procedure TFrmIPQCT622_detail.btn_okClick(Sender: TObject);
var
  tmpad,tmpver,tmplot,tmpSQL:string;
  tmpCDS,tmpCDS_610:TClientDataSet;
  Data:OleVariant;
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料!',48);
    Exit;
  end;

  tmpad:=CDS.FieldByName('ad').AsString;
  tmpver:=CDS.FieldByName('ver').AsString;
  tmplot:=CDS.FieldByName('lot').AsString;
  tmpSQL:='select * from ipqc620 where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(tmpad)
         +' and ver='+Quotedstr(tmpver)
         +' and lot='+Quotedstr(tmplot)
         +' and isnull(garbageflag,0)=0';
  if not QueryBySQL(tmpSQL, l_Data) then
     Exit;

  tmpCDS_610:=TClientDataSet.Create(nil);
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=l_Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('資料不存在!',48);
      Exit;
    end;

    //未編輯過,賦默認值
    if tmpCDS.FieldByName('mdate_wx').IsNull then
    begin
      tmpSQL:='select * from ipqc610 where bu='+Quotedstr(g_UInfo^.BU)
             +' and ad='+Quotedstr(tmpad)
             +' and ver='+Quotedstr(tmpver);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS_610.Data:=Data;
      if tmpCDS_610.IsEmpty then
      begin
        ShowMsg('BOM標準設定資料不存在!',48);
        Exit;
      end;

      with tmpCDS do
      begin
        Edit;
        FieldByName('sg1_std').AsString:=tmpCDS_610.FieldByName('sg1').AsString;
        FieldByName('sg1_stdcz').AsString:=tmpCDS_610.FieldByName('cz1').AsString;
        FieldByName('sg2_astd').AsString:=tmpCDS_610.FieldByName('sg2').AsString;
        FieldByName('sg2_astdcz').AsString:=tmpCDS_610.FieldByName('cz2').AsString;
        FieldByName('sg2_bstd').AsString:=tmpCDS_610.FieldByName('sg2').AsString;
        FieldByName('sg2_bstdcz').AsString:=tmpCDS_610.FieldByName('cz2').AsString;
        FieldByName('sg2_cstd').AsString:=tmpCDS_610.FieldByName('sg2').AsString;
        FieldByName('sg2_cstdcz').AsString:=tmpCDS_610.FieldByName('cz2').AsString;
        FieldByName('sg2_dstd').AsString:=tmpCDS_610.FieldByName('sg2').AsString;
        FieldByName('sg2_dstdcz').AsString:=tmpCDS_610.FieldByName('cz2').AsString;
        FieldByName('sg2_estd').AsString:=tmpCDS_610.FieldByName('sg2').AsString;
        FieldByName('sg2_estdcz').AsString:=tmpCDS_610.FieldByName('cz2').AsString;
        FieldByName('sg3_std').AsString:=tmpCDS_610.FieldByName('sg3').AsString;
        FieldByName('sg3_stdcz').AsString:=tmpCDS_610.FieldByName('cz3').AsString;

        FieldByName('cl_std').AsString:=tmpCDS_610.FieldByName('cl').AsString;
        FieldByName('br_std').AsString:=tmpCDS_610.FieldByName('br').AsString;
        FieldByName('xidu_std').AsString:=tmpCDS_610.FieldByName('xidu').AsString;
        FieldByName('niandu_std').AsString:=tmpCDS_610.FieldByName('niandu').AsString;
        Post;
        //MergeChangeLog;
      end;

      l_Data:=tmpCDS.Data;
    end;

  finally
    FreeAndNil(tmpCDS_610);
    FreeAndNil(tmpCDS);
  end;

  inherited;
end;

procedure TFrmIPQCT622_detail.Edit1Change(Sender: TObject);
var
  lot:string;
begin
  inherited;
  lblerr.Visible:=False;
  lot:=Trim(Edit1.Text);
  if (not CDS.Active) or CDS.IsEmpty or (Length(lot)=0) then
     Exit;

  lblerr.Visible:=not CDS.Locate('lot',lot,[loCaseInsensitive, loPartialKey]);
end;

end.
