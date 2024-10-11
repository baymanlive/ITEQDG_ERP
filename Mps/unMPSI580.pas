{*******************************************************}
{                                                       }
{                unMPSI580                              }
{                Author: kaikai                         }
{                Create date: 2016/10/31                }
{                Description: 計划性生產                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI580;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI580 = class(TFrmSTDI031)
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
  FrmMPSI580: TFrmMPSI580;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI580.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS580 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI580.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS580';
  p_GridDesignAns:=True;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachinePP;
end;

procedure TFrmMPSI580.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');

  if Pos(CDS.FieldByName('machine').AsString,g_MachinePP)=0 then
     ShowM('machine');

  if CDS.FieldByName('fmdate').IsNull then
     ShowM('fmdate');

  if CDS.FieldByName('todate').IsNull then
     ShowM('todate');

  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');

  inherited;
end;

end.
