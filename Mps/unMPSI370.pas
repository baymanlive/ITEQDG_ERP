{*******************************************************}
{                                                       }
{                unMPSI370                              }
{                Author: kaikai                         }
{                Create date: 2018/7/27                 }
{                Description: 副排程鋼板                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI370;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI370 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI370: TFrmMPSI370;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI370.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS370 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI370.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS370';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmMPSI370.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('stealno').AsString))=0 then
     ShowM('stealno');

  if Length(Trim(CDS.FieldByName('longitude_lower').AsString))=0 then
     ShowM('longitude_lower');

  if Length(Trim(CDS.FieldByName('longitude_upper').AsString))=0 then
     ShowM('longitude_upper');

  if Length(Trim(CDS.FieldByName('latitude_lower').AsString))=0 then
     ShowM('latitude_lower');

  if Length(Trim(CDS.FieldByName('latitude_upper').AsString))=0 then
     ShowM('latitude_upper');

  inherited;
end;

end.
