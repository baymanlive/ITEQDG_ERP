{*******************************************************}
{                                                       }
{                unMPSI620                              }
{                Author: kaikai                         }
{                Create date: 2017/6/13                 }
{                Description: 玻布料號編碼設定          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI620;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI620 = class(TFrmSTDI031)
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
  FrmMPSI620: TFrmMPSI620;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI620.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS620 Where 1=1 '+strFilter
         +' Order By Bu,Fiber,Vendor';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI620.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS620';
  p_GridDesignAns:=True;

  inherited;

  with DBGridEh1.FieldColumns['Bu'].PickList do
  begin
    Clear;
    Add(g_UInfo^.BU);
    if SameText(g_UInfo^.BU,'ITEQDG') then
       Add('ITEQGZ');
  end;

  SetStrings(DBGridEh1.FieldColumns['Vendor'].PickList,'Vendor','MPS690');
end;

procedure TFrmMPSI620.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
  
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if DBGridEh1.FieldColumns['Bu'].PickList.IndexOf(CDS.FieldByName('Bu').AsString)=-1 then
     ShowM('Bu');
  if Length(Trim(CDS.FieldByName('Fiber').AsString))=0 then
     ShowM('Fiber');
  if Length(Trim(CDS.FieldByName('Vendor').AsString))=0 then
     ShowM('Vendor');
  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(CDS.FieldByName('Bu').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;
  inherited;
end;

end.
