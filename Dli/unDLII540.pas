{*******************************************************}
{                                                       }
{                unDLII540                              }
{                Author: kaikai                         }
{                Create date: 2016/10/13                }
{                Description: CCL�ɺ䭭�w               }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII540;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII540 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII540: TFrmDLII540;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII540.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI540 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By Custno,Code2,Code3_6_lower,Code3_6_upper,Code7_8_lower,'
         +' Code7_8_upper,CodeLast1,CodeLast2,CodeLast3';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII540.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI540';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII540.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;

  procedure ShowM(fName:string);
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Value').AsString))=0 then
     ShowM('Value');
  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR( tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;

  inherited;
end;

procedure TFrmDLII540.CDSNewRecord(DataSet: TDataSet);
var
  i:Integer;
begin
  for i:=0 to DataSet.FieldCount -1 do
  if DataSet.Fields[i].DataType in [ftString,ftWideString] then
  if DataSet.Fields[i].IsNull then
     DataSet.Fields[i].AsString:='';
   inherited;
end;

end.
