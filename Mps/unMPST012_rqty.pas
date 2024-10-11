unit unMPST012_rqty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmMPST012_rqty = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS: TDataSource;
    CDS: TClientDataSet;
    btn_query: TBitBtn;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Edit1: TEdit;
    btn_export: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_sdate:TDateTime;
    l_stype:string;
    { Public declarations }
  end;

var
  FrmMPST012_rqty: TFrmMPST012_rqty;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_rqty.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmMPST012_rqty');
  Label1.Caption:=CheckLang('膠系：');
  BitBtn1.Caption:=btn_quit.Caption;
  btn_ok.Visible:=False;
  btn_quit.Visible:=False;
  tmpSQL:='exec dbo.proc_MPSI380X '+Quotedstr(g_UInfo^.Bu);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmMPST012_rqty.FormShow(Sender: TObject);
begin
  inherited;
  if CDS.Active and (l_stype<>'@') then
     CDS.Locate('sdate;stype',VarArrayOf([l_sdate,l_stype]),[]);
end;

procedure TFrmMPST012_rqty.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  DBGridEh1.Free;
end;

procedure TFrmMPST012_rqty.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('stype').AsString='合計' then
     AFont.Color:=clBlue
  else if CDS.FieldByName('qty').AsFloat=0 then
     AFont.Color:=clRed;
end;

procedure TFrmMPST012_rqty.btn_queryClick(Sender: TObject);
var
  ad,tmpSQL:string;
  Data:OleVariant;
begin
  inherited;

  ad:=Trim(Edit1.Text);
  if Length(ad)=0 then
  begin
    ShowMsg('請輸入膠系(料號第2碼),多個膠系請用逗號(,)間隔!',48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpSQL:='exec dbo.proc_MPSI380X '+Quotedstr(g_UInfo^.Bu)+','+Quotedstr(ad);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmMPST012_rqty.btn_exportClick(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, 'FrmMPST012_rqty');
end;

procedure TFrmMPST012_rqty.BitBtn1Click(Sender: TObject);
begin
  inherited;
  ModalResult:=mrCancel;
end;

end.
