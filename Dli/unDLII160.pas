{*******************************************************}
{                                                       }
{                unDLII160                              }
{                Author: kaikai                         }
{                Create date: 2015/8/17                 }
{                Description: 厚度/介質厚度             }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII160;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII160 = class(TFrmSTDI031)
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
  FrmDLII160: TFrmDLII160;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII160.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI160 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII160.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI160';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII160.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('strip_lower').AsString))=0 then
     ShowM('strip_lower');
  if Length(Trim(CDS.FieldByName('strip_upper').AsString))=0 then
     ShowM('strip_upper');
  inherited;
end;

end.
