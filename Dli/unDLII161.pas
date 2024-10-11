{*******************************************************}
{                                                       }
{                unDLII161                              }
{                Author: kaikai                         }
{                Create date: 2018/8/15                 }
{                Description: �p��                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII161;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII161 = class(TFrmSTDI031)
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
  FrmDLII161: TFrmDLII161;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII161.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI161 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII161.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI161';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII161.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('custno').AsString))=0 then
     ShowM('custno');
  if Length(Trim(CDS.FieldByName('strip_lower').AsString))=0 then
     ShowM('strip_lower');
  if Length(Trim(CDS.FieldByName('strip_upper').AsString))=0 then
     ShowM('strip_upper');
  inherited;
end;

end.