unit unDLIT7XX_select;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh,
  ImgList, Buttons, ExtCtrls;

type
  TFrmDLIT7XX_select = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    CDS: TClientDataSet;
    Panel1: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    l_SQLFilter:string;
    { Public declarations }
  end;

var
  FrmDLIT7XX_select: TFrmDLIT7XX_select;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIT7XX_select.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  Label1.Caption:=CheckLang('³t¬d´ÌªO§å¸¹¡G');
  SetGrdCaption(DBGridEh1, 'DLI710');
  tmpSQL:='select * from DLI710'
         +' where bu='+Quotedstr(g_UInfo^.BU)+l_SQLFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmDLIT7XX_select.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLIT7XX_select.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrOK;
end;

procedure TFrmDLIT7XX_select.Edit1Change(Sender: TObject);
begin
  inherited;
  if not CDS.Active then
     Exit;

  CDS.Filtered:=False;
  if Trim(Edit1.Text)='' then
     Exit;

  CDS.Filter:='lot like '+Quotedstr('%'+Trim(Edit1.Text)+'%');
  CDS.Filtered:=True;
end;

end.
