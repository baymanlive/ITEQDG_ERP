{*******************************************************}
{                                                       }
{                unDLII240                              }
{                Author: kaikai                         }
{                Create date: 2015/8/18                 }
{                Description: COC³Æµùspec               }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII240;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII240 = class(TFrmSTDI031)
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
  FrmDLII240: TFrmDLII240;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII240.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI240 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII240.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI240';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII240.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Trim(CDS.FieldByName('LstCode').AsString)='' then
     CDS.FieldByName('LstCode').AsString:='@';
  inherited;
end;

procedure TFrmDLII240.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('LstCode').AsString:='@';
end;

end.
