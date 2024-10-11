{*******************************************************}
{                                                       }
{                unORDI120                              }
{                Author: terry                          }
{                Create date: 2016/3/4                  }
{                Description:料號含銅特殊判定           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI120;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030, ADODB;
type
  TFrmORDI120 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI120: TFrmORDI120;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI120.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD120';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

procedure TFrmORDI120.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.fieldbyname('cuflag').Value:=False;
end;

end.
