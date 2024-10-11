unit unMPST012_adqty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmMPST012_adqty = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    CDS: TClientDataSet;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST012_adqty: TFrmMPST012_adqty;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_adqty.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmMPST012_adqty');
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
  tmpSQL:='exec dbo.proc_MPSI390 '+Quotedstr(g_UInfo^.Bu);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmMPST012_adqty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  DBGridEh1.Free;
end;

end.
