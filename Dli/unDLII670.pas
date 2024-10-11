{*******************************************************}
{                                                       }
{                unDLII670                              }
{                Author: kaikai                         }
{                Create date: 2021/2/25                 }
{                Description: 江西結構設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII670;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII670 = class(TFrmSTDI031)
    btn_dlii670: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_dlii670Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII670: TFrmDLII670;

implementation

uses unGlobal,unCommon, unDLII670_set;

{$R *.dfm}

procedure TFrmDLII670.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI670 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII670.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI670';
  p_GridDesignAns:=True;
  btn_dlii670.Left:=btn_quit.Left;
  
  inherited;
end;

procedure TFrmDLII670.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('code2').AsString))=0 then
     ShowM('code2');
  if Length(Trim(CDS.FieldByName('code3_6').AsString))=0 then
     ShowM('code3_6');
  if Length(Trim(CDS.FieldByName('code15').AsString))=0 then
     ShowM('code15');
  if Length(Trim(CDS.FieldByName('code15_jx').AsString))=0 then
     ShowM('code15_jx');
  inherited;
end;

procedure TFrmDLII670.btn_dlii670Click(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmDLII670_set) then
     FrmDLII670_set:=TFrmDLII670_set.Create(Application);
  FrmDLII670_set.ShowModal;
end;

end.
