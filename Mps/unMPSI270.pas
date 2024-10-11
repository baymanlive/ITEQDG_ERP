{*******************************************************}
{                                                       }
{                unMPSI270                              }
{                Author: kaikai                         }
{                Create date: 2015/12/17                }
{                Description: 膠系+15碼指定機台         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI270;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI270 = class(TFrmSTDI031)
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
  FrmMPSI270: TFrmMPSI270;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI270.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS270 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI270.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS270';
  p_GridDesignAns:=True;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;  
end;

procedure TFrmMPSI270.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('Code15').AsString))=0 then
     ShowM('Code15');
  if Length(Trim(CDS.FieldByName('Strip_lower').AsString))=0 then
     ShowM('Strip_lower');
  if Length(Trim(CDS.FieldByName('Strip_upper').AsString))=0 then
     ShowM('Strip_upper');
  if Pos(CDS.FieldByName('Machine').AsString,g_MachineCCL)=0 then
     ShowM('Machine');
  inherited;
end;

end.
