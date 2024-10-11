{*******************************************************}
{                                                       }
{                unDLII241                              }
{                Author: kaikai                         }
{                Create date: 2021/1/13                 }
{                Description: COC³ÆµùtypeS              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII241;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII241 = class(TFrmSTDI031)
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
  FrmDLII241: TFrmDLII241;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII241.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI241 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII241.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI241';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII241.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('LstCode2').AsString))=0 then
     ShowM('LstCode2');
  if Length(Trim(CDS.FieldByName('Remark').AsString))=0 then
     ShowM('Remark');
  inherited;
end;

end.
