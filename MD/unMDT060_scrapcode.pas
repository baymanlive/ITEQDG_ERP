unit unMDT060_scrapcode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmMDT060_scrapcode = class(TFrmSTDI051)
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
    l_ret1,l_ret2:string;
    { Public declarations }
  end;

var
  FrmMDT060_scrapcode: TFrmMDT060_scrapcode;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMDT060_scrapcode.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'FrmMDT060_scrapcode');
end;

procedure TFrmMDT060_scrapcode.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select qce01,qce03 from '+g_UInfo^.BU+'.qce_file'
         +' where qceacti=''Y'' and length(trim(nvl(qce03,'''')))>0 order by qce01';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     CDS1.Data:=Data;
end;

procedure TFrmMDT060_scrapcode.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMDT060_scrapcode.btn_okClick(Sender: TObject);
begin
  l_ret1:='';
  l_ret2:='';
  if CDS1.Active and (not CDS1.IsEmpty) then
  begin
    l_ret1:=CDS1.Fields[0].AsString;
    l_ret2:=CDS1.Fields[1].AsString;
  end else
  begin
    ShowMsg('請選擇一筆資料!',48);
    Exit;
  end;

  inherited;
end;

procedure TFrmMDT060_scrapcode.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  btn_ok.Click;
end;

end.
