{*******************************************************}
{                                                       }
{                unDLII520                              }
{                Author: kaikai                         }
{                Create date: 2016/7/28                 }
{                Description: 銅箔厚度測試值            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII520;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII520 = class(TFrmSTDI031)
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
  FrmDLII520: TFrmDLII520;

implementation

uses unGlobal,unCommon;

{$R *.dfm}
 
procedure TFrmDLII520.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI520 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII520.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI520';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII520.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('FmDate').AsString))=0 then
     ShowM('FmDate');
  if Length(Trim(CDS.FieldByName('ToDate').AsString))=0 then
     ShowM('ToDate');
  if Length(Trim(CDS.FieldByName('Copper').AsString))=0 then
     ShowM('Copper');
  inherited;
end;

end.
