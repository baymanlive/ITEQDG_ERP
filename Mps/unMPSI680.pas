{*******************************************************}
{                                                       }
{                unMPSI680                              }
{                Author: kaikai                         }
{                Create date: 2021/6/4                  }
{                Description: PP生產排程規範要求        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI680;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComObj, Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, Menus, ImgList,
  StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI680 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI680: TFrmMPSI680;


implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI680.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS680 Where Bu=''ITEQDG'' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPSI680.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS680';
  p_GridDesignAns := True;
  btn_import.Visible := g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
    btn_import.Left := btn_quit.Left;
  inherited;
end;

procedure TFrmMPSI680.CDSBeforePost(DataSet: TDataSet);

  procedure ShowM(fName: string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(fName);
    Abort;
  end;

begin
//  if DBGridEh1.FieldColumns['stype'].PickList.IndexOf(CDS.FieldByName('stype').AsString) = -1 then
//    ShowM('stype');
//  if Length(Trim(CDS.FieldByName('mtype').AsString)) = 0 then
//    ShowM('mtype');
//  if Length(Trim(CDS.FieldByName('pno').AsString)) = 0 then
//    ShowM('pno');
//  inherited;
end;

procedure TFrmMPSI680.btn_importClick(Sender: TObject);
begin
  XlsImport(p_TableName,CDS,DBGridEh1,'ITEQDG');
end;

procedure TFrmMPSI680.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('BU').AsString:='ITEQDG';
end;

end.

