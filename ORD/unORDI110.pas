{*******************************************************}
{                                                       }
{                unORDI110                              }
{                Author: terry                          }
{                Create date: 2016/3/2                }
{                Description: 客戶特殊規格設定          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI110;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030, ADODB;
type
  TFrmORDI110 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI110: TFrmORDI110;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI110.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD110';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

end.
