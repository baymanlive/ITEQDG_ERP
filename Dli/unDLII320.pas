{*******************************************************}
{                                                       }
{                unDLII320                              }
{                Author: kaikai                         }
{                Create date: 2015/7/2                  }
{                Description: �~�[                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII320;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII320 = class(TFrmSTDI031)
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
  FrmDLII320: TFrmDLII320;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII320.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI320 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII320.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI320';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII320.CDSBeforePost(DataSet: TDataSet);
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
  inherited;
end;

end.
