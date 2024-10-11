{*******************************************************}
{                                                       }
{                unMPSI570                              }
{                Author: kaikai                         }
{                Create date: 2016/10/31                }
{                Description: Core指定機台              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI570;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI570 = class(TFrmSTDI031)
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
  FrmMPSI570: TFrmMPSI570;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI570.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS570 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By Machine,Adhesive';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI570.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS570';
  p_GridDesignAns:=True;

  inherited;
  
  GetMPSMachine;
  DBGridEh1.FieldColumns['Machine'].PickList.DelimitedText:=g_MachinePP;
end;

procedure TFrmMPSI570.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');

  if Pos(CDS.FieldByName('machine').AsString,g_MachinePP)=0 then
     ShowM('machine');

  if Length(Trim(CDS.FieldByName('adhesive').AsString))=0 then
     ShowM('adhesive');

  if Length(Trim(CDS.FieldByName('fiber').AsString))=0 then
     ShowM('fiber');

  if CDS.FieldByName('rc_lower').IsNull then
     ShowM('rc_lower');

  if CDS.FieldByName('rc_upper').IsNull then
     ShowM('rc_upper');

  if Length(Trim(CDS.FieldByName('lstcode').AsString))=0 then
     ShowM('lstcode');

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

procedure TFrmMPSI570.CDSNewRecord(DataSet: TDataSet);
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
