{*******************************************************}
{                                                       }
{                unMPSI110                              }
{                Author: kaikai                         }
{                Create date: 2015/12/29                }
{                Description: 鋼板編碼設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI110;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI110 = class(TFrmSTDI031)
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
  FrmMPSI110: TFrmMPSI110;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI110.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS110 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI110.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS110';
  p_GridDesignAns:=True;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;
end;

procedure TFrmMPSI110.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string; const msg:string='');
  begin
    if msg='' then
       ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption)
    else
       ShowMsg('%s', 48, msg);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if CDS.FieldByName('code').IsNull then
     ShowM('code');

  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');
     
  if Pos(CDS.FieldByName('machine').AsString,g_MachineCCL)=0 then
     ShowM('machine');

  if CDS.FieldByName('strip_lower').IsNull then
     ShowM('strip_lower');

  if CDS.FieldByName('strip_upper').IsNull then
     ShowM('strip_upper');

  if Length(Trim(CDS.FieldByName('longitude_lower').AsString))=0 then
     ShowM('longitude_lower');

  if Length(Trim(CDS.FieldByName('longitude_lower').AsString))=0 then
     ShowM('longitude_upper');

  if Length(Trim(CDS.FieldByName('latitude_lower').AsString))=0 then
     ShowM('latitude_lower');

  if Length(Trim(CDS.FieldByName('latitude_lower').AsString))=0 then
     ShowM('latitude_upper');

  if CDS.FieldByName('minNum').AsFloat>CDS.FieldByName('maxNum').AsFloat then
     ShowM('minNum',DBGridEh1.FieldColumns['minNum'].Title.Caption+CheckLang('不能大於')+DBGridEh1.FieldColumns['maxNum'].Title.Caption);

  inherited;
end;

end.
