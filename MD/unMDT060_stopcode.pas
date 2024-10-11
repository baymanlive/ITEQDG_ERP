unit unMDT060_stopcode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmMDT060_stopcode = class(TFrmSTDI051)
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
  FrmMDT060_stopcode: TFrmMDT060_stopcode;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMDT060_stopcode.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'FrmMDT060_stopcode');
end;

procedure TFrmMDT060_stopcode.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select dma01,dma02 from '+g_UInfo^.BU+'.dma_file'
         +' where dmaacti=''Y''';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     CDS1.Data:=Data;
end;

procedure TFrmMDT060_stopcode.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMDT060_stopcode.btn_okClick(Sender: TObject);
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

procedure TFrmMDT060_stopcode.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  btn_ok.Click;
end;

end.
