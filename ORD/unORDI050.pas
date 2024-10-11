{*******************************************************}
{                                                       }
{                unORDI050                              }
{                Author: terry                          }
{                Create date: 2016/2/1                 }
{                Description: 客戶品名膠系設定檔        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI050;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030;
type
  TFrmORDI050 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI050: TFrmORDI050;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI050.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD050';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

procedure TFrmORDI050.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('custno').value:='';
end;

end.
