unit unIPQCT622_ad;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmIPQCT622_ad = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    CDS: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_ad,l_ver:string;
    { Public declarations }
  end;

var
  FrmIPQCT622_ad: TFrmIPQCT622_ad;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT622_ad.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'IPQC610');
end;

procedure TFrmIPQCT622_ad.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select ad,ver from ipqc610'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and conf=1';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmIPQCT622_ad.btn_okClick(Sender: TObject);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料',48);
    Exit;
  end;

  l_ad:=CDS.FieldByName('ad').AsString;
  l_ver:=CDS.FieldByName('ver').AsString;

  inherited;
end;

procedure TFrmIPQCT622_ad.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmIPQCT622_ad.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) then
     btn_ok.Click;
end;

end.
