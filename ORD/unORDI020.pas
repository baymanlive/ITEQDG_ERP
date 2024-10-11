{*******************************************************}
{                                                       }
{                unORDI020                              }
{                Author: terry                          }
{                Create date: 2016/1/29                 }
{                Description: CCL品名客戶設定檔         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI020;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh;

type
  TFrmORDI020 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetNewRecordDefData(DataSet: TDataSet);override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmORDI020: TFrmORDI020;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}
procedure TFrmORDI020.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName+' Where kind=''PP'' ';
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

procedure TFrmORDI020.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD010';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

procedure TFrmORDI020.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    ShowMsg('請輸入['+DBGridEh1.FieldColumns[fName].Title.Caption+']', 48);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('Stkname').AsString))=0 then
     ShowM('Stkname');
  if Length(Trim(CDS.FieldByName('RC').AsString))=0 then
     ShowM('RC');
  inherited;
end;

procedure TFrmORDI020.SetNewRecordDefData(DataSet: TDataSet);
begin
  inherited;
end;

procedure TFrmORDI020.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('ord013').value:=false;
  CDS.FieldByName('ord014').value:=false;
  CDS.FieldByName('ord015').value:=false;
end;



end.
