{*******************************************************}
{                                                       }
{                unDLII600                              }
{                Author: KaiKai                         }
{                Create date: 2018/1/3                  }
{                Description: 客戶料號-廠內料號         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII600;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, Menus, ImgList, StdCtrls,
  Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII600 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLII600: TFrmDLII600;


implementation

uses
  unGlobal, unCommon;
   
{$R *.dfm}

procedure TFrmDLII600.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From DLI600 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLII600.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLI600';
  p_GridDesignAns := True;

  inherited;
end;

procedure TFrmDLII600.CDSBeforePost(DataSet: TDataSet);

  procedure ShowM(fName: string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(fName);
    Abort;
  end;

begin
  if Length(Trim(CDS.FieldByName('CustNo').AsString)) = 0 then
    ShowM('CustNo');
  if Length(Trim(CDS.FieldByName('C_pno').AsString)) = 0 then
    ShowM('C_pno');
  inherited;
end;

procedure TFrmDLII600.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.

