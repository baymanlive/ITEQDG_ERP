{*******************************************************}
{                                                       }
{                unDLII050                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: 尺安中值                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII300;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLII300 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII300: TFrmDLII300;

implementation

uses unGlobal,unCommon,ComObj;

{$R *.dfm}

procedure TFrmDLII300.SetToolBar;
begin
  btn_import.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmDLII300.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By adhesive,fiber,rc,id';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII300.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI300';
  p_GridDesignAns:=True;
  btn_import.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_import.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmDLII300.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;

  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入['+DBGridEh1.FieldColumns[fName].Title.Caption+']',48);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');
  if Length(Trim(CDS.FieldByName('fiber').AsString))=0 then
     ShowM('fiber');
  if Length(Trim(CDS.FieldByName('rc').AsString))=0 then
     ShowM('rc');
  if CDS.FieldByName('value').IsNull then
     ShowM('value');
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

procedure TFrmDLII300.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.
