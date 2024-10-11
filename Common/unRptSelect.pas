unit unRptSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ExtCtrls, ImgList, StdCtrls, Buttons, ComCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmRptSelect = class(TFrmSTDI051)
    DS: TDataSource;
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    procedure btn_okClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l_table:string;
  end;

var
  FrmRptSelect: TFrmRptSelect;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmRptSelect.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1,l_table);
  DBGridEh1.Columns[1].Width:=DBGridEh1.ClientWidth-DBGridEh1.Columns[0].Width-50;
  tmpSQL:='select rptid,rptname from '+l_table
         +' where conf=1 and bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL,Data) then
     CDS.Data:=Data;
end;

procedure TFrmRptSelect.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmRptSelect.btn_okClick(Sender: TObject);
begin
  if (not CDS.Active) or CDS.IsEmpty then
     ModalResult:=mrCancel
  else
     inherited;
end;

procedure TFrmRptSelect.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  btn_ok.Click;
end;

end.
