unit unIPQCT002;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmIPQCT002 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmIPQCT002: TFrmIPQCT002;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmIPQCT002.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select * from IPQ_CUT_CHECK'
        +' Where Bu='+Quotedstr(g_UInfo^.BU)
        +strFilter
        +' order by BATCH_UID,UPDATE_DATE_TIME';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmIPQCT002.FormCreate(Sender: TObject);
begin
  p_SysId:='IPQC';
  p_TableName:='IPQ_CUT_CHECK';
  p_GridDesignAns:=True;
  inherited;
  SetGrdCaption(DBGridEh1, p_TableName);
end;

procedure TFrmIPQCT002.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if not GetQueryString(p_TableName, tmpStr) then
     Exit;

  RefreshDS(tmpStr);
  DBGridEh1.Repaint;

end;

end.
