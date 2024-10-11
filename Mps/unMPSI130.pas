{*******************************************************}
{                                                       }
{                unMPSI130                              }
{                Author: kaikai                         }
{                Create date: 2015/2/4                  }
{                Description: 合鍋規范設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI130 = class(TFrmSTDI031)
    btn_mpsi130: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_mpsi130Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI130: TFrmMPSI130;

implementation

uses unGlobal, unCommon, unMPSI130_Update;

{$R *.dfm}

procedure TFrmMPSI130.SetToolBar;
begin
  btn_mpsi130.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPSI130.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS130 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI130.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS130';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('更改代碼欄位後,請執行[更新合鍋代碼]進行更新');
  btn_mpsi130.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_mpsi130.Left:=btn_quit.Left;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;
end;

procedure TFrmMPSI130.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('code').AsString))=0 then
     ShowM('code');
  if Pos(CDS.FieldByName('machine').AsString,g_MachineCCL)=0 then
     ShowM('machine');

  inherited;
end;

procedure TFrmMPSI130.btn_mpsi130Click(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPSI130_Update) then
     FrmMPSI130_Update:=TFrmMPSI130_Update.Create(Application);
  FrmMPSI130_Update.Edit2.Text:=CDS.FieldByName('Code').AsString;
  FrmMPSI130_Update.ShowModal;
end;

end.
