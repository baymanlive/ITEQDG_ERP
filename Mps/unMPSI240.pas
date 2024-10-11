{*******************************************************}
{                                                       }
{                unMPSI240                              }
{                Author: kaikai                         }
{                Create date: 2015/11/2                 }
{                Description: Bom虛擬料號轉換           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI240;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI240 = class(TFrmSTDI031)
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
  FrmMPSI240: TFrmMPSI240;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI240.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS240 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI240.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS240';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmMPSI240.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if (CDS.FieldByName('DB').AsString<>'DG') and
     (CDS.FieldByName('DB').AsString<>'GZ') and
     (CDS.FieldByName('DB').AsString<>'JX')  then
     ShowM('DB');
  if Length(Trim(CDS.FieldByName('Bom3').AsString))=0 then
     ShowM('Bom3');
  if Length(Trim(CDS.FieldByName('Bom4').AsString))=0 then
     ShowM('Bom4');
  if Length(Trim(CDS.FieldByName('Bom6').AsString))=0 then
     ShowM('Bom6');
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('CodeLst').AsString))=0 then
     ShowM('CodeLst');
  inherited;
end;

end.
