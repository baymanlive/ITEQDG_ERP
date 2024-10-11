{*******************************************************}
{                                                       }
{                unDLII180                              }
{                Author: kaikai                         }
{                Create date: 2015/7/10                 }
{                Description: 出貨派車資料              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII180;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII180 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
    l_StrIndex,l_StrIndexDesc:string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII180: TFrmDLII180;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII180.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI180 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter+' Order By wdate';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII180.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI180';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII180.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('Sno').AsString:=GetSno(g_MInfo^.ProcId);
end;

procedure TFrmDLII180.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;


end.
