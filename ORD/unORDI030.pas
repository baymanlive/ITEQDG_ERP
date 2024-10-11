{*******************************************************}
{                                                       }
{                unORDI030                              }
{                Author: terry                          }
{                Create date: 2016/1/29                 }
{                Description: �Ȥ�~�W���t�]�w��        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI030;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;
type
  TFrmORDI030 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDI030: TFrmORDI030;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORDI030.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD030';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

procedure TFrmORDI030.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    ShowMsg('�п�J['+DBGridEh1.FieldColumns[fName].Title.Caption+']', 48);
    Abort;
  end;
begin
//  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
//     ShowM('Custno');
//  if Length(Trim(CDS.FieldByName('Range').AsString))=0 then     
//     ShowM('Range');
//  if Length(Trim(CDS.FieldByName('Tolerances').AsString))=0 then
//     ShowM('Tolerances');
  inherited;
end;



end.
