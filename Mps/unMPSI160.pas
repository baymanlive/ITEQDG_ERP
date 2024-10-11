{*******************************************************}
{                                                       }
{                unMPSI160                              }
{                Author: kaikai                         }
{                Create date: 2015/3/12                 }
{                Description: 良率設定                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI160;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI160 = class(TFrmSTDI031)
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
  FrmMPSI160: TFrmMPSI160;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI160.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS160 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  tmpSQL:=tmpSQL+' order by len(custno),custno,isnull(adhesive,''''),cwcode_lower,cwcode_upper,qty_lower';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI160.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS160';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmMPSI160.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(CDS.FieldByName('custno').AsString)=0 then
     ShowM('custno');
{  if Length(CDS.FieldByName('adhesive').AsString)=0 then
     ShowM('adhesive');
  if CDS.FieldByName('strip_lower').IsNull then
     ShowM('strip_lower');
  if CDS.FieldByName('strip_upper').IsNull then
     ShowM('strip_upper'); }
  if CDS.FieldByName('cwcode_lower').IsNull then
     ShowM('cwcode_lower');
  if CDS.FieldByName('cwcode_upper').IsNull then
     ShowM('cwcode_upper');
  if CDS.FieldByName('qty_lower').IsNull then
     ShowM('qty_lower');
  if CDS.FieldByName('qty_upper').IsNull then
     ShowM('qty_upper');
  if CDS.State in [dsInsert] then
     CDS.FieldByName('dno').AsString:=GetSno(g_MInfo^.ProcId);
  inherited;
end;

procedure TFrmMPSI160.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('code9_11').asstring:='';
end;

end.
