{*******************************************************}
{                                                       }
{                unDLII640                              }
{                Author: KaiKai                         }
{                Create date:                           }
{                Description: 客戶二維碼檢查設定        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII640;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII640 = class(TFrmSTDI031)
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
  FrmDLII640: TFrmDLII640;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII640.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI640 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII640.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI640';
  p_SBText:=CheckLang('檢查:檢查此段內容,位置:二維碼所在的位置,長度:不比較的字符長度');
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLII640.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('CustNo').AsString))=0 then
     ShowM('CustNo');

  if Length(Trim(CDS.FieldByName('splitter').AsString))=0 then
     ShowM('splitter');

  if CDS.FieldByName('po_chk').AsBoolean then
  if CDS.FieldByName('po').AsInteger<=0 then
     ShowM('po');

  if CDS.FieldByName('cpno_chk').AsBoolean then
  if CDS.FieldByName('cpno').AsInteger<=0 then
     ShowM('cpno');

  if CDS.FieldByName('lot_chk').AsBoolean then
  if CDS.FieldByName('lot').AsInteger<=0 then
     ShowM('lot');

  if CDS.FieldByName('qty_chk').AsBoolean then
  if CDS.FieldByName('qty').AsInteger<=0 then
     ShowM('qty');

  if CDS.FieldByName('pno_chk').AsBoolean then
  if CDS.FieldByName('pno').AsInteger<=0 then
     ShowM('pno');

  if CDS.FieldByName('po_fst').AsInteger<0 then
     ShowM('po_fst');
  if CDS.FieldByName('po_lst').AsInteger<0 then
     ShowM('po_lst');

  if CDS.FieldByName('cpno_fst').AsInteger<0 then
     ShowM('cpno_fst');
  if CDS.FieldByName('cpno_lst').AsInteger<0 then
     ShowM('cpno_lst');

  if CDS.FieldByName('lot_fst').AsInteger<0 then
     ShowM('lot_fst');
  if CDS.FieldByName('lot_lst').AsInteger<0 then
     ShowM('lot_lst');

  if CDS.FieldByName('qty_fst').AsInteger<0 then
     ShowM('qty_fst');
  if CDS.FieldByName('qty_lst').AsInteger<0 then
     ShowM('qty_lst');

  if CDS.FieldByName('pno_fst').AsInteger<0 then
     ShowM('pno_fst');
  if CDS.FieldByName('pno_lst').AsInteger<0 then
     ShowM('pno_lst');

  inherited;
end;

end.
