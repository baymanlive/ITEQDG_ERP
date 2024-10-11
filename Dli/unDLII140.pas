{*******************************************************}
{                                                       }
{                unDLII140                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: ³±¿U©Ê                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII140;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII140 = class(TFrmSTDI031)
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
  FrmDLII140: TFrmDLII140;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII140.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI140 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII140.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI140';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmDLII140.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('½Ð¿é¤J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  inherited;
end;

procedure TFrmDLII140.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('Flam').AsFloat:=0;
end;

end.
