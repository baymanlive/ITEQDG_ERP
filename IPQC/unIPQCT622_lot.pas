unit unIPQCT622_lot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmIPQCT622_lot = class(TFrmSTDI051)
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
    l_ad,l_ver,l_lot:string;
    { Public declarations }
  end;

var
  FrmIPQCT622_lot: TFrmIPQCT622_lot;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT622_lot.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'IPQC620');
end;

procedure TFrmIPQCT622_lot.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select top 50 lot from ipqc620 where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(l_ad)
         +' and ver='+Quotedstr(l_ver)
         +' and isnull(garbageflag,0)=0'
         +' order by idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmIPQCT622_lot.btn_okClick(Sender: TObject);
begin
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料',48);
    Exit;
  end;

  l_lot:=CDS.FieldByName('lot').AsString;

  inherited;
end;

procedure TFrmIPQCT622_lot.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmIPQCT622_lot.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) then
     btn_ok.Click;
end;

end.
