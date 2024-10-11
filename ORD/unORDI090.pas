{*******************************************************}
{                                                       }
{                unORDI090                              }
{                Author: terry                          }
{                Create date: 2016/2/26                 }
{                Description: 客戶特殊厚度設定          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI090;     

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh,
  unSTDI030, ADODB;
type
  TFrmORDI090 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI090: TFrmORDI090;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI090.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD090';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

procedure TFrmORDI090.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('tflag').value:=False;
//  CDS.FieldByName('tolerance').value:='';
//  CDS.FieldByName('structure').value:='';
//  CDS.FieldByName('txt').value:='';
end;

end.                                     
