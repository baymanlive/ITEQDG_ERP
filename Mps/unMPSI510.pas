{*******************************************************}
{                                                       }
{                unMPSI510                              }
{                Author: kaikai                         }
{                Create date: 2016/9/10                 }
{                Description: 機台速度(米/分鐘)設定     }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI510;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI510 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI510: TFrmMPSI510;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI510.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS510 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI510.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS510';
  p_GridDesignAns:=True;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['Machine'].PickList.DelimitedText:=g_MachinePP;
end;

procedure TFrmMPSI510.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');

  if Pos(CDS.FieldByName('machine').AsString,g_MachinePP)=0 then
     ShowM('machine');

  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');

  if Length(Trim(CDS.FieldByName('fiber').AsString))=0 then
     ShowM('fiber');

  if CDS.FieldByName('rc_lower').IsNull then
     ShowM('rc_lower');

  if CDS.FieldByName('rc_upper').IsNull then
     ShowM('rc_upper');

  inherited;
end;

procedure TFrmMPSI510.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('speed').AsInteger:=0;
end;

end.
