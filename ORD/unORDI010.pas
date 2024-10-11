{*******************************************************}
{                                                       }
{                unORDI010                              }
{                Author: terry                          }
{                Create date: 2016/1/29                 }
{                Description: CCL品名客戶設定檔         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI010;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;
type
  TFrmORDI010 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmORDI010: TFrmORDI010;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmORDI010.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;  
begin
  tmpSQL:='Select * From '+p_TableName+' Where kind=''CCL'' ';
  if p_IsBu then
     tmpSQL:=tmpSQL+' And Bu='+Quotedstr(g_UInfo^.BU);
  tmpSQL:=tmpSQL+strFilter+p_OrderBy;
  if QueryBySQL(Conn, tmpSQL, p_DBType, Data) then
     CDS.Data:=Data;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    SetControls;
    SetSBars;
  end;
end;

procedure TFrmORDI010.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD010';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;
  inherited;
end;



procedure TFrmORDI010.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('ord13').value:='不顯示';
  CDS.FieldByName('ord14').value:=false;
  CDS.FieldByName('ord15').value:=false;
  CDS.FieldByName('BU').Value:='ITEQDG';
  CDS.FieldByName('kind').Value:='CCL';
end;

procedure TFrmORDI010.FormShow(Sender: TObject);
var
  i:integer;//處長要求不要用ord要用kind
begin

  for i:=0 to DBGridEh1.Columns.Count-1 do
  begin
    if Pos('ord',DBGridEh1.Columns[i].Title.Caption)>0 then
        DBGridEh1.Columns[i].Title.Caption:=StringReplace(DBGridEh1.Columns[i].Title.Caption,'ord','kind',[]);
  end;
end;

end.
