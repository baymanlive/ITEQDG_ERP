unit unIPQCT501_tc_sia30;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmIPQCT501_tc_sia30 = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    l_pno:string;
    l_ret:string;
    { Public declarations }
  end;

var
  FrmIPQCT501_tc_sia30: TFrmIPQCT501_tc_sia30;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT501_tc_sia30.FormCreate(Sender: TObject);
begin
  inherited;
  DBGridEh1.FieldColumns['ta_shb02'].Title.Caption:=CheckLang('½¦¤ô§å¸¹');
  DBGridEh1.FieldColumns['ta_shb02'].Width:=120;
end;

procedure TFrmIPQCT501_tc_sia30.FormShow(Sender: TObject);
var
  tmpOra,tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if SameText(g_Uinfo^.BU,'ITEQDG') then
     tmpOra:='ORACLE'
  else
     tmpOra:='ORACLE1';
  tmpSQL:='select ta_shb02 from shb_file where ta_shbconf=''Y'''
         +' and to_char(shb02,''YYYYMMDD'')>=to_char(sysdate-4,''YYYYMMDD'')'
         +' and shb10 in (select bmb03 from bma_file inner join bmb_file'
         +' on bma01=bmb01 and bmb03 like ''V%'' and bma01='+Quotedstr(l_pno)+')'
         +' order by ta_shb02';  
  if not QueryBySQL(tmpSQL, Data, tmpOra) then
     Exit;

  CDS.Data:=Data;   
end;

procedure TFrmIPQCT501_tc_sia30.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmIPQCT501_tc_sia30.btn_okClick(Sender: TObject);
begin
  if CDS.Active and (not CDS.IsEmpty) then
     l_ret:=CDS.FieldByName('ta_shb02').AsString
  else
     l_ret:='';
     
  inherited;
end;

end.
