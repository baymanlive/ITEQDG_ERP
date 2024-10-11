unit unDLIT710;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ImgList, ComCtrls, ToolWin;

type
  TFrmDLIT710 = class(TFrmSTDI080)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetCDS(strFilter:string);
  public
    { Public declarations }
  end;

var
  FrmDLIT710: TFrmDLIT710;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIT710.SetCDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Edit1.Text:='0';
  Edit2.Text:='0';
  tmpSQL:='select * from '+p_TableName
        +' where bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    Edit2.Text:=IntToStr(CDS.RecordCount);
  end;
end;

procedure TFrmDLIT710.FormCreate(Sender: TObject);
begin
  p_TableName:='DLI710';

  inherited;

  btn_print.Visible:=False;
  SetGrdCaption(DBGridEh1, p_TableName);
  SetCDS(g_cFilterNothing);
end;

procedure TFrmDLIT710.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLIT710.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  inherited;
  if GetQueryString(p_TableName, tmpStr) then
     SetCDS(tmpStr);
end;

procedure TFrmDLIT710.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  Edit1.Text:=IntToStr(CDS.RecNo);
end;

procedure TFrmDLIT710.btn_exportClick(Sender: TObject);
begin
  //inherited;
  GetExportXls(CDS, p_TableName);
end;

end.
