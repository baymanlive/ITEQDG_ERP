{*******************************************************}
{                                                       }
{                unMPSI340                              }
{                Author: kaikai                         }
{                Create date: 2016/10/20                }
{                Description: 客戶群組                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI340;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI340 = class(TFrmSTDI031)
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
  FrmMPSI340: TFrmMPSI340;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI340.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS340 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI340.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS340';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('多個客戶編號請用逗號(,)分隔');

  inherited;
end;

procedure TFrmMPSI340.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('GroupId').AsString))=0 then
     ShowM('GroupId');

  if Pos(','+CDS.FieldByName('GroupId').AsString+',',','+CDS.FieldByName('Custno').AsString+',')>0 then
  begin
    ShowMsg('%s', 48, '['+DBGridEh1.FieldColumns['GroupId'].Title.Caption+']'+CheckLang('不能出現在')
                     +'['+DBGridEh1.FieldColumns['Custno'].Title.Caption+']'+CheckLang('中'));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedIndex:=0;
    Abort;
  end;
  inherited;
end;

end.
