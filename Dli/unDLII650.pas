{*******************************************************}
{                                                       }
{                unDLII650                              }
{                Author: kaikai                         }
{                Create date: 2020/5/21                 }
{                Description: 玻布供應商顯示設定        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII650;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII650 = class(TFrmSTDI031)
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
  FrmDLII650: TFrmDLII650;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII650.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI650 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By custno,id';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII650.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI650';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('未輸入表示所有(客戶必需輸入),多個條件值請用"/"間隔');

  inherited;
end;

procedure TFrmDLII650.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns['Custno'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Custno');
    Abort;
  end;

  if (Length(Trim(CDS.FieldByName('Struct').AsString))>0) and
     (Length(Trim(CDS.FieldByName('StructX').AsString))>0) then
  begin
    ShowMsg('[結構]、[排除結構]欄位不可同時輸入!', 48);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Struct');
    Abort;
  end;

  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;

  inherited;
end;

end.
