unit unMDT060_lot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmMDT060_lot = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    l_wono,l_ret:string;
    { Public declarations }
  end;

var
  FrmMDT060_lot: TFrmMDT060_lot;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMDT060_lot.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'FrmMDT060_lot');
end;

procedure TFrmMDT060_lot.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select tc_six03,tc_six04,nvl(tc_six05,0) as tc_six05,tc_six06,tc_six08'
         +' from '+g_UInfo^.BU+'.tc_six_file where tc_six01='+Quotedstr(l_wono)
         +' and tc_six06=''N''';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     CDS1.Data:=Data;
end;

procedure TFrmMDT060_lot.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMDT060_lot.btn_okClick(Sender: TObject);
begin
  l_ret:='';
  if CDS1.Active and (not CDS1.IsEmpty) then
     l_ret:=CDS1.FieldByName('tc_six04').AsString
  else
  begin
    ShowMsg('請選擇一筆資料!',48);
    Exit;
  end;

  inherited;
end;

procedure TFrmMDT060_lot.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  btn_ok.Click;
end;

end.
