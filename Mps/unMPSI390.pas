{*******************************************************}
{                                                       }
{                unMPSI390                              }
{                Author: kaikai                         }
{                Create date: 2019/9/8                  }
{                Description: 膠系+尺寸產能             }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI390;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI390 = class(TFrmSTDI031)
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
  FrmMPSI390: TFrmMPSI390;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI390.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS390 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI390.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS390';
  p_GridDesignAns:=True;
  
  inherited;
end;

procedure TFrmMPSI390.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('stype').AsString))=0 then
     ShowM('stype');
  if Length(Trim(CDS.FieldByName('ad').AsString))=0 then
     ShowM('ad');
  inherited;
end;

end.
