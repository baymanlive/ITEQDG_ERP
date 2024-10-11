{*******************************************************}
{                                                       }
{                unORDI080                              }
{                Author: terry                          }
{                Create date: 2016/2/18                  }
{                Description: 客戶字樣設定             }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI080;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030, ADODB;
type
  TFrmORDI080 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI080: TFrmORDI080;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI080.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD080';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

end.
