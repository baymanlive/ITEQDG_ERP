unit unMPST012_cqty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmMPST012_cqty = class(TFrmSTDI051)
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
  FrmMPST012_cqty: TFrmMPST012_cqty;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_cqty.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmMPST012_cqty');
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
  tmpSQL:='exec dbo.proc_MPSI180 '+Quotedstr(g_UInfo^.Bu);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmMPST012_cqty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  DBGridEh1.Free;
end;

end.
