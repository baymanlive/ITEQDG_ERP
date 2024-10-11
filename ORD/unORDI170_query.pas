unit unORDI170_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmORDI170_query = class(TFrmSTDI051)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    Label1: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit1: TEdit;
    DBGridEh1: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_ordi170select: TBitBtn;
    Chb_IsOk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_ordi170selectClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l_ret:string;
  end;

var
  FrmORDI170_query: TFrmORDI170_query;

implementation
uses unGlobal, unCommon,unORDI170;
{$R *.dfm}

procedure TFrmORDI170_query.FormCreate(Sender: TObject);
begin
  SetGrdCaption(DBGridEh1, 'ORD160');
  inherited;
  Label1.Caption:=CheckLang('營運中心：');
  Label2.Caption:=CheckLang('客戶代號：');
  Label4.Caption:=CheckLang('客戶產品描述：');
end;

procedure TFrmORDI170_query.btn_ordi170selectClick(Sender: TObject);
var
  s1,s2,s3,tmpSQL:string;
  Data:OleVariant;
begin
//  inherited;
  l_ret:=' ';
 // tmpSQL:='select Bu,CustNo,CustItemCode,CustDesc,IsOk,ItemCodeA from ORD160 where IsOk=0 ';
  tmpSQL:='select * from ORD160 where 0=0 and MuserA<>'+Quotedstr(g_UInfo^.UserId) ;
  s1:=UpperCase(Trim(Edit1.Text));
  s2:=UpperCase(Trim(Edit2.Text));
  s3:=UpperCase(Trim(Edit3.Text));

  if (Length(s1)=0) and (Length(s2)=0) and (Length(s3)=0) then
  begin
    ShowMsg('請輸入查詢條件！',48);
    Exit;
  end;

  if Chb_IsOk.Checked then
    l_ret:=l_ret+' and Isok=0 '
  else
    l_ret:=l_ret+' and Isok=1 ' ;

  if Length(s1)>0 then
     l_ret:=l_ret+' and Bu like '+Quotedstr(s1+'%');
  if Length(s2)>0 then
     l_ret:=l_ret+' and CustNo = '+Quotedstr(s2);
  if Length(s3)>0 then
     l_ret:=l_ret+' and CustDesc like '+Quotedstr(s3+'%');


  tmpSQL:=tmpSQL+ l_ret;

  if QueryBySQL(tmpSQL, Data) then
    CDS2.Data:=Data;
end;
procedure TFrmORDI170_query.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmORDI170_query.DBGridEh1DblClick(Sender: TObject);
var
  tmpCustNo,tmpItemCodeA:string;
begin
  tmpCustNo:=CDS2.FieldByname('CustNo').asstring;
  tmpItemCodeA:=CDS2.FieldByname('ItemCodeA').asstring;
  FrmORDI170.CDS.Data:=CDS2.Data;
  FrmORDI170.CDS.Locate('CustNo;ItemCodeA',VarArrayOf([tmpCustNo,tmpItemCodeA]), [loCaseInsensitive]);
  inherited;

end;

end.
