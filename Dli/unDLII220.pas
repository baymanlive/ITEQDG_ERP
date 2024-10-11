{*******************************************************}
{                                                       }
{                unDLII220                              }
{                Author: kaikai                         }
{                Create date: 2015/7/10                 }
{                Description: 膨脹系統                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII220;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII220 = class(TFrmSTDI031)
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
  FrmDLII220: TFrmDLII220;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII220.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI220 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII220.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI220';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('[類型]欄位請輸入A、B、C(A:Alpha 1   B:Alpha 2  C:50~260℃)');

  inherited;
end;

procedure TFrmDLII220.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('type').AsString))=0 then
     ShowM('type');
  if Length(Trim(CDS.FieldByName('spec').AsString))=0 then
     ShowM('spec');
  inherited;
end;

end.
