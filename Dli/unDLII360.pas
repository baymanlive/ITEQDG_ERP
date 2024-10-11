{*******************************************************}
{                                                       }
{                unDLII360                              }
{                Author: kaikai                         }
{                Create date: 2015/10/6                 }
{                Description: 銅箔厚度                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII360;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII360 = class(TFrmSTDI031)
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
  FrmDLII360: TFrmDLII360;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII360.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI360 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII360.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI360';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('銅箔類型A:HTE B:RTF C:VLP D:HVLP');

  inherited;
end;

procedure TFrmDLII360.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Type').AsString))=0 then
     ShowM('Type');
  if Length(Trim(CDS.FieldByName('Sizes').AsString))=0 then
     ShowM('Sizes');
  inherited;
end;

end.
