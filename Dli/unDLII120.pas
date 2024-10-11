{*******************************************************}
{                                                       }
{                unDLII120                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: �l���v                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII120;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII120 = class(TFrmSTDI031)
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
  FrmDLII120: TFrmDLII120;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII120.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI120 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII120.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI120';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('[�O�p]���п�JA��B(A:�O�p>=20mil B:�O�p<20mil)');

  inherited;
end;

procedure TFrmDLII120.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Thickness').AsString))=0 then
     ShowM('Thickness');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if CDS.FieldByName('WaterPer').IsNull then
     ShowM('WaterPer');
  inherited;
end;

end.
