{*******************************************************}
{                                                       }
{                unMPSI040                              }
{                Author: kaikai                         }
{                Create date: 2015/12/20                }
{                Description: 回流線產能設定程式        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI040;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI040 = class(TFrmSTDI031)
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
  FrmMPSI040: TFrmMPSI040;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI040.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS040 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI040.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS040';
  p_GridDesignAns:=True;

  inherited;
  
  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;
  SetStrings(DBGridEh1.FieldColumns['Adhesive_type'].PickList, 'Adhesive_type', 'MPS140');
end;

procedure TFrmMPSI040.CDSBeforePost(DataSet: TDataSet);
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
     
  if Pos(CDS.FieldByName('machine').AsString,g_MachineCCL)=0 then
     ShowM('machine');

  if Length(Trim(CDS.FieldByName('Adhesive_type').AsString))=0 then
     ShowM('Adhesive_type');

  if CDS.FieldByName('cwcode_lower').IsNull then
     ShowM('cwcode_lower');

  if CDS.FieldByName('cwcode_upper').IsNull then
     ShowM('cwcode_upper');

  if CDS.FieldByName('strip_lower').IsNull then
     ShowM('strip_lower');

  if CDS.FieldByName('strip_upper').IsNull then
     ShowM('strip_upper');

  inherited;
end;

procedure TFrmMPSI040.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('nu_capacity').AsFloat:=0;
  DataSet.FieldByName('mu_capacity').AsFloat:=0;
  DataSet.FieldByName('fu_capacity').AsFloat:=0;
  DataSet.FieldByName('eu_capacity').AsFloat:=0;
end;

end.
