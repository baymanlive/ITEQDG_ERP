unit unLBLR270;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin, ADODB;

type
  TFrmLBLR270 = class(TFrmSTDI031)
    CDSid: TAutoIncField;
    CDSwono1: TStringField;
    CDSpno1: TStringField;
    CDSlot1: TStringField;
    CDSqty1: TStringField;
    CDSspec1: TStringField;
    CDSwono2: TStringField;
    CDSpno2: TStringField;
    CDSlot2: TStringField;
    CDSqty2: TStringField;
    CDSspec2: TStringField;
    CDSuserid: TStringField;
    CDSddate: TDateTimeField;
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
  FrmLBLR270: TFrmLBLR270;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmLBLR270.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
//  tmpSQL:='select * from CHONG_GONG_CHECK_HISTORY'
//        +' Where Bu='+Quotedstr(g_UInfo^.BU)
//        +strFilter
//        +' order by BATCH_UID,CATEGORY,UPDATE_DATE_TIME';
  tmpSQL:='select * from lbl620 order by id desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmLBLR270.FormCreate(Sender: TObject);
begin
  p_SysId:='IPQC';
  p_TableName:='lbl600';
  p_GridDesignAns:=True;
  inherited;
  SetGrdCaption(DBGridEh1, p_TableName);
  DBGridEh1.ReadOnly := true;
end;

procedure TFrmLBLR270.btn_queryClick(Sender: TObject);
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
