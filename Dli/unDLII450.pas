{*******************************************************}
{                                                       }
{                unDLII450                              }
{                Author: kaikai                         }
{                Create date: 2019/9/9                  }
{                Description: ITEQXP布基重              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII450;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII450 = class(TFrmSTDI031)
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
  FrmDLII450: TFrmDLII450;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII450.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI450 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII450.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI450';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII450.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('code2').AsString))=0 then
     ShowM('code2');
  if Length(Trim(CDS.FieldByName('fiber').AsString))=0 then
     ShowM('fiber');
  if Length(Trim(CDS.FieldByName('bw').AsString))=0 then
     ShowM('bw');
  inherited;
end;

end.
