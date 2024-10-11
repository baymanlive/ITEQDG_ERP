{*******************************************************}
{                                                       }
{                unDLII630                              }
{                Author: KaiKai                         }
{                Create date:                           }
{                Description: �Ȥ�~�W�ˮ֡G���c+�ؤo   }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII630;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII630 = class(TFrmSTDI031)
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
  FrmDLII630: TFrmDLII630;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}

procedure TFrmDLII630.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI630 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII630.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI630';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLII630.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
//  if Length(Trim(CDS.FieldByName('CustNo').AsString))=0 then
//     ShowM('CustNo');
//  inherited;
end;

procedure TFrmDLII630.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('Adhesive').asstring :='';
end;

end.