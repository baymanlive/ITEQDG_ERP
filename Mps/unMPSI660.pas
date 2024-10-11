{*******************************************************}
{                                                       }
{                unMPSI660                              }
{                Author: kaikai                         }
{                Create date: 2021/3/29                 }
{                Description: 膠系、規格不可排程設定    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI660;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI660 = class(TFrmSTDI031)
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
  FrmMPSI660: TFrmMPSI660;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI660.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS660 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI660.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS660';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('尺寸、客戶、OZ、銅箔規格 輸入"*"號表示所有尺寸、客戶、銅箔、銅箔規格');

  inherited;
end;

procedure TFrmMPSI660.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('lcode3_6').AsString))=0 then
     ShowM('lcode3_6');
  if Length(Trim(CDS.FieldByName('hcode3_6').AsString))=0 then
     ShowM('hcode3_6');
  if Length(Trim(CDS.FieldByName('code2').AsString))=0 then
     ShowM('code2');
  if Length(Trim(CDS.FieldByName('code9_14').AsString))=0 then
     ShowM('code9_14');
  if Length(Trim(CDS.FieldByName('custno').AsString))=0 then
     ShowM('custno');
  if Length(Trim(CDS.FieldByName('OZ').AsString))=0 then
     ShowM('OZ');
  if Length(Trim(CDS.FieldByName('codeReci_2').AsString))=0 then
     ShowM('codeReci_2');
  if Length(Trim(CDS.FieldByName('LockFlg').AsString))=0 then
     ShowM('LockFlg');
  inherited;
end;

end.
