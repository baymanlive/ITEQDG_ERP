{*******************************************************}
{                                                       }
{                unDLII060                              }
{                Author: qwl                            }
{                Create date: 2016/4/29                 }
{                Description: 耐分層時間                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII490;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII490 = class(TFrmSTDI031)
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
  FrmDLII490: TFrmDLII490;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII490.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI490 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII490.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI490';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII490.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Strip_lower').AsString))=0 then
     ShowM('Strip_lower');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  inherited;
end;

end.
