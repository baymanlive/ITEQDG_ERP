{*******************************************************}
{                                                       }
{                unDLII032                              }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: PP³W­S                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII032;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII032 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_importClick(Sender: TObject);
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
  FrmDLII032: TFrmDLII032;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmDLII032.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI032';
  p_GridDesignAns:=True;
  btn_import.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_import.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmDLII032.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

procedure TFrmDLII032.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName+' Where Bu='+Quotedstr(g_UInfo^.BU)+ ' order by  custno,Adhesive,thick,Copper';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII032.CDSBeforePost(DataSet: TDataSet);
begin
//  inherited;

end;

procedure TFrmDLII032.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('GUID').AsString := guid;
end;

end.
