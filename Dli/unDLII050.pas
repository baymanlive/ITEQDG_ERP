{*******************************************************}
{                                                       }
{                unDLII050                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: �ئw����                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII050;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII050 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII050: TFrmDLII050;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII050.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI050 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By custno,adhesive,lastcode,thick,sstru,id';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII050.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI050';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('�Ȥ�+@���1H�з�,�Ȥ�+&���21�з�,�Ȥ�+#���2H�з�');
  btn_import.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_import.Left:=btn_quit.Left;
     
  inherited;
end;

procedure TFrmDLII050.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;

  procedure ShowM(fName:string);
  begin
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    ShowMsg('�п�J['+DBGridEh1.FieldColumns[fName].Title.Caption+']',48);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('custno').AsString))=0 then
     ShowM('custno');
  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');
  if Length(Trim(CDS.FieldByName('thick').AsString))=0 then
     ShowM('thick');
  if Length(Trim(CDS.FieldByName('sstru').AsString))=0 then
     ShowM('sstru');

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

procedure TFrmDLII050.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport( p_TableName, CDS, DBGridEh1);
end;

end.
