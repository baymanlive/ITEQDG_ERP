unit unIPQCT622_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmIPQCT622_query = class(TFrmSTDI051)
    ad: TLabel;
    Edit1: TEdit;
    ver: TLabel;
    Edit2: TEdit;
    lot: TLabel;
    Edit3: TEdit;
    btn_sp: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    l_Data:OleVariant;
    { Public declarations }
  end;

var
  FrmIPQCT622_query: TFrmIPQCT622_query;

implementation

uses unGlobal, unCommon, unIPQCT622_ad, unIPQCT622_lot;

{$R *.dfm}

procedure TFrmIPQCT622_query.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, 'IPQC620');
  SpeedButton1.Caption:=btn_sp.Caption;
end;

procedure TFrmIPQCT622_query.btn_okClick(Sender: TObject);
var
  tmpad,tmpver,tmplot,tmpSQL:string;
  tmpCDS,tmpCDS_610:TClientDataSet;
  Data:OleVariant;
begin
  tmpad:=Trim(Edit1.Text);
  tmpver:=Trim(Edit2.Text);
  tmplot:=Trim(Edit3.Text);
  {
  if Length(tmpad)=0 then
  begin
    ShowMsg('請輸入膠系!',48);
    Edit1.SetFocus;
    Exit;
  end;

  if Length(tmpver)=0 then
  begin
    ShowMsg('請輸入版本號!',48);
    Edit2.SetFocus;
    Exit;
  end;
  }
  if Length(tmplot)=0 then
  begin
    ShowMsg('請輸入批號!',48);
    Edit3.SetFocus;
    Exit;
  end;

  tmpSQL:='select * from ipqc620 where bu='+Quotedstr(g_UInfo^.BU)
         //+' and ad='+Quotedstr(tmpad)
         //+' and ver='+Quotedstr(tmpver)
         +' and lot='+Quotedstr(tmplot)
         +' and isnull(garbageflag,0)=0';
  if Length(tmpad)>0 then
     tmpSQL:=tmpSQL+' and ad='+Quotedstr(tmpad);
  if Length(tmpver)>0 then
     tmpSQL:=tmpSQL+' and ver='+Quotedstr(tmpver);
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

    if tmpCDS.RecordCount>1 then
    begin
      ShowMsg('此查詢條件存在多筆資料,請輸入[膠系+版本號+批號]以確定一筆資料!',48);
      Exit;
    end;

    tmpad:=tmpCDS.FieldByName('ad').AsString;
    tmpver:=tmpCDS.FieldByName('ver').AsString;

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

procedure TFrmIPQCT622_query.btn_spClick(Sender: TObject);
begin
  inherited;
  FrmIPQCT622_ad:=TFrmIPQCT622_ad.Create(nil);
  try
    if FrmIPQCT622_ad.ShowModal=mrOK then
    begin
      Edit1.Text:=FrmIPQCT622_ad.l_ad;
      Edit2.Text:=FrmIPQCT622_ad.l_ver;
    end;
  finally
    FreeAndNil(FrmIPQCT622_ad);
  end;
end;

procedure TFrmIPQCT622_query.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  FrmIPQCT622_lot:=TFrmIPQCT622_lot.Create(nil);
  try
    FrmIPQCT622_lot.l_ad:=Edit1.Text;
    FrmIPQCT622_lot.l_ver:=Edit2.Text;
    if FrmIPQCT622_lot.ShowModal=mrOK then
       Edit3.Text:=FrmIPQCT622_lot.l_lot;
  finally
    FreeAndNil(FrmIPQCT622_lot);
  end;
end;

end.
