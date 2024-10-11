unit unMDT060_img;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmMDT060_img = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
  private
    { Private declarations }
  public
    l_StrIndex,l_StrIndexDesc:string;
    { Public declarations }
  end;

var
  FrmMDT060_img: TFrmMDT060_img;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMDT060_img.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'FrmMDT060_img');
end;

procedure TFrmMDT060_img.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select img01,img04,ima02,ima021,img10'
         +' from '+g_UInfo^.BU+'.img_file,'+g_UInfo^.BU+'.ima_file'
         +' where ima01=img01 and img01 like ''1G%'''
         +' and img02 in (''N3A12'',''Y3A12'') and img10>0'
         +' order by substr(ima01,8,1)';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     CDS1.Data:=Data;
end;

procedure TFrmMDT060_img.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMDT060_img.btn_okClick(Sender: TObject);
begin
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料!',48);
    Exit;
  end;

  inherited;
end;

procedure TFrmMDT060_img.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  btn_ok.Click;
end;

procedure TFrmMDT060_img.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS1, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
