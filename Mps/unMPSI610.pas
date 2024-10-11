{*******************************************************}
{                                                       }
{                unMPSI610                              }
{                Author: kaikai                         }
{                Create date: 2017/5/9                  }
{                Description: 膠系顏色設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI610;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI610 = class(TFrmSTDI031)
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI610: TFrmMPSI610;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI610.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS610 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI610.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS610';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmMPSI610.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('AD').AsString))=0 then
     ShowM('AD');
  inherited;
end;

procedure TFrmMPSI610.DBGridEh1DblClick(Sender: TObject);
var
  Color: TColor;
  R, G, B: integer;
begin
  inherited;
  R:=CDS.FieldByName('R').AsInteger;
  G:=CDS.FieldByName('G').AsInteger;
  B:=CDS.FieldByName('B').AsInteger;
  ColorDialog1.Color:=RGB(R,G,B);
  if g_MInfo^.R_edit and ColorDialog1.Execute then
  begin
    Color := ColorDialog1.Color;
    R := Color and $FF;
    G := (Color and $FF00) shr 8;
    B := (Color and $FF0000) shr 16;
    if not (CDS.State in [dsInsert,dsEdit]) then
       CDS.Edit;
    CDS.FieldByName('R').AsInteger:=R;
    CDS.FieldByName('G').AsInteger:=G;
    CDS.FieldByName('B').AsInteger:=B;
  end;
end;

end.
