{*******************************************************}
{                                                       }
{                unORDI040                              }
{                Author: terry                          }
{                Create date: 2016/1/29                 }
{                Description: 客戶品名公差設定檔        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI040;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030;
type
  TFrmORDI040 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI040: TFrmORDI040;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI040.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD040';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;
  p_OrderBy:='order by custno,curi,cucode';

  inherited;
end;

procedure TFrmORDI040.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('custno').value:='';
  CDS.FieldByName('curi').value:=false;
end;

end.
