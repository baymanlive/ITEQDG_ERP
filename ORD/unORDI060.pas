{*******************************************************}
{                                                       }
{                unORDI060                              }
{                Author: terry                          }
{                Create date: 2016/2/1                 }
{                Description: §ΩÆt≥]©w¿…              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI060;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030, ADODB;
type
  TFrmORDI060 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI060: TFrmORDI060;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI060.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD060';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;
  p_OrderBy:=' order by Thickness1';

  inherited;
end;

end.
