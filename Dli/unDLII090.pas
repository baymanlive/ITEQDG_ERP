{*******************************************************}
{                                                       }
{                unDLII090                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: 板厚公差                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII090;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII090 = class(TFrmSTDI031)
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
  FrmDLII090: TFrmDLII090;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII090.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI090 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII090.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI090';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('[客戶編號,膠系]輸入(*)符號表示通用,輸入多個值時請用左斜線(/)間隔');

  inherited;
end;

procedure TFrmDLII090.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');
  if Length(Trim(CDS.FieldByName('strip_lower').AsString))=0 then
     ShowM('strip_lower');
  if Length(Trim(CDS.FieldByName('strip_upper').AsString))=0 then
     ShowM('strip_upper');
  inherited;
end;

procedure TFrmDLII090.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('custno').AsString:='*';
  CDS.FieldByName('adhesive').AsString:='*';
end;

end.
