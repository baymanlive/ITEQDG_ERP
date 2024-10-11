{*******************************************************}
{                                                       }
{                unDLII030                              }
{                Author: kaikai                         }
{                Create date: 2021/5/6                  }
{                Description: 廣州自動倉掃描記錄        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII030;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII030 = class(TFrmSTDI031)
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
  FrmDLII030: TFrmDLII030;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII030.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI030 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' order by pno,area,lot,idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII030.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI030';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII030.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('pno').AsString))=0 then
     ShowM('pno');
  if Length(Trim(CDS.FieldByName('lot').AsString))=0 then
     ShowM('lot');
  if Length(Trim(CDS.FieldByName('area').AsString))=0 then
     ShowM('area');
  if CDS.FieldByName('qty').AsFloat<=0 then
     ShowM('qty');

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
