{*******************************************************}
{                                                       }
{                unMPSI640                              }
{                Author: kaikai                         }
{                Create date: 2017/6/27                 }
{                Description: ½u§O²£¯à³]©w              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI640;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI640 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI640: TFrmMPSI640;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI640.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS640 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI640.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS640';
  p_GridDesignAns:=True;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;
  DBGridEh1.FieldColumns['type'].PickList.DelimitedText:='38«p,38Á¡,42«p,42Á¡,44«p,44Á¡,40Á¡/«p,55Á¡/«p,33Á¡/«p,74Á¡/«p,82Á¡/«p,86Á¡/«p';
end;

procedure TFrmMPSI640.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if DBGridEh1.FieldColumns['machine'].PickList.IndexOf(CDS.FieldByName('machine').AsString)=-1 then
     ShowM('machine');
  if DBGridEh1.FieldColumns['type'].PickList.IndexOf(CDS.FieldByName('type').AsString)=-1 then
     ShowM('type');
  if Length(Trim(CDS.FieldByName('capacity').AsString))=0 then
     ShowM('capacity');
  inherited;
end;

end.
