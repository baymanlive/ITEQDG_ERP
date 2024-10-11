{*******************************************************}
{                                                       }
{                unDLII400                              }
{                Author: terry                          }
{                Create date: 2015/11/27                }
{                Description: 客戶路線設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII400;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII400 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
  private
    l_StrIndex,l_StrIndexDesc:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII400: TFrmDLII400;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII400.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI400 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII400.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI400';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLII400.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Trim(CDS.FieldByName('Custno').AsString)=EmptyStr then
     ShowM('Custno');
  if Trim(CDS.FieldByName('Pathname').AsString)=EmptyStr then
     ShowM('Pathname');
  inherited;
end;

procedure TFrmDLII400.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
