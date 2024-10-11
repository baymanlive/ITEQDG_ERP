{*******************************************************}
{                                                       }
{                unMPSI220                              }
{                Author: kaikai                         }
{                Create date: 2015/10/4                 }
{                Description: 特殊尺寸設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI220;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI220 = class(TFrmSTDI031)
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
  FrmMPSI220: TFrmMPSI220;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI220.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS220 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI220.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS220';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmMPSI220.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('OthSize').AsString))=0 then
     ShowM('OthSize');
  if Length(Trim(CDS.FieldByName('StdSize').AsString))=0 then
     ShowM('StdSize');
  if Length(Trim(CDS.FieldByName('ChkSize').AsString))=0 then
     ShowM('ChkSize');
  inherited;
end;

end.
