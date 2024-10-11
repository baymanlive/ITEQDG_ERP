{*******************************************************}
{                                                       }
{                unDLII390                              }
{                Author: kaikai                         }
{                Create date: 2019/6/11                 }
{                Description: 特性異常設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII390;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII390 = class(TFrmSTDI031)
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
  FrmDLII390: TFrmDLII390;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII390.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI390 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII390.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI390';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII390.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('custno').AsString))=0 then
     ShowM('custno');
  if Length(Trim(CDS.FieldByName('pno').AsString))=0 then
     ShowM('pno');
  if Length(Trim(CDS.FieldByName('lot').AsString))=0 then
     ShowM('lot');
  inherited;
end;

end.
