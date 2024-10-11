{*******************************************************}
{                                                       }
{                unDLII100                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: 介電常數/消耗因素         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII100;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII100 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII100: TFrmDLII100;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII100.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI100 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By Custno,Adhesive,DKDF';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII100.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI100';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII100.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Sno').AsString:=GetSno(g_MInfo^.ProcId);
end;

end.
