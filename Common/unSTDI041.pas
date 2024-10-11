{*******************************************************}
{                                                       }
{                unSTDI041                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 報表:DBGridEh             }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unSTDI041;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, DB, StdCtrls, ExtCtrls, unFrmBaseEmpty,
  DBGridEh, DBCtrls, unGlobal, unCommon, DBClient, DBGridEhGrouping, ToolCtrlsEh,
  DBGridEhToolCtrls, DynVarsEh, GridsEh, DBAxisGridsEh, unGridDesign, DateUtils,
  unDAL;

type
  TFrmSTDI041 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_print: TToolButton;
    btn_export: TToolButton;
    btn_query: TToolButton;
    ToolButton4: TToolButton;
    btn_first: TToolButton;
    btn_prior: TToolButton;
    btn_next: TToolButton;
    btn_last: TToolButton;
    ToolButton5: TToolButton;
    btn_quit: TToolButton;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    DS: TDataSource;
    Panel1: TPanel;
    CDS: TClientDataSet;
    DBGridEh1: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_firstClick(Sender: TObject);
    procedure btn_priorClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
    procedure btn_lastClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1ColWidthsChanged(Sender: TObject);
  private
    { Private declarations }
    l_GridDesign: TGridDesign;                    //grid設定
  public
    { Public declarations }
  protected
    p_SysId,                       //系統ID
    p_TableName,                   //CDS資料表
    p_SBText: string;               //狀態欄顯示信息
    p_GridDesignAns: Boolean;       //grid設定
    procedure SetToolBar; virtual;  //設置工具欄按扭
    procedure SetSBars; virtual;    //設置狀態欄筆數
    procedure RefreshDS(strFilter: string); virtual; //DataSet查詢
  end;

var
  FrmSTDI041: TFrmSTDI041;

implementation

{$R *.dfm}

procedure TFrmSTDI041.SetToolBar;
begin
  btn_print.Enabled := g_MInfo^.R_print;
  btn_export.Enabled := g_MInfo^.R_export;
  btn_query.Enabled := g_MInfo^.R_query;
end;

procedure TFrmSTDI041.SetSBars;
var
  dis_bo: Boolean;
  minNum, maxNum: Integer;
begin
  if CDS.Active then
  begin
    if CDS.IsEmpty or (CDS.RecNo = -1) then
      Edit1.Text := '0'
    else
      Edit1.Text := IntToStr(CDS.RecNo);
    Edit2.Text := IntToStr(CDS.RecordCount);
  end
  else
  begin
    Edit1.Text := '0';
    Edit2.Text := '0';
  end;

  dis_bo := (not CDS.Active) or (CDS.RecordCount < 2) or (CDS.State in [dsInsert, dsEdit]);
  minNum := StrToIntDef(Edit1.Text, 0);
  maxNum := StrToIntDef(Edit2.Text, 0);

  btn_first.Enabled := (not dis_bo) and (minNum > 1);
  btn_prior.Enabled := (not dis_bo) and (minNum > 1);
  btn_next.Enabled := (not dis_bo) and (maxNum > minNum);
  btn_last.Enabled := (not dis_bo) and (maxNum > minNum);
end;

procedure TFrmSTDI041.RefreshDS(strFilter: string);
begin
  if (not CDS.Active) or CDS.IsEmpty then
    SetSBars;
end;

procedure TFrmSTDI041.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  inherited;
  Left := 0;
  Top := 0;
  Self.Caption := g_MInfo^.ProcName;
  SetLength(g_DAL, Length(g_ConnData));
  for i := Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i] := TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetToolBar;
  SetLabelCaption(Self, p_TableName);
  SetGrdCaption(DBGridEh1, p_TableName);
  if p_GridDesignAns then
    l_GridDesign := TGridDesign.Create(DBGridEh1);
  RefreshDS(g_cFilterNothing);
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(p_SBText), g_DllHandle, Self.Handle, False);
end;

procedure TFrmSTDI041.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    FreeAndNil(l_GridDesign);
  for i := Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  CDS.Active := False;
  DBGridEh1.Free;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmSTDI041.btn_printClick(Sender: TObject);
var
  ArrPrintData: TArrPrintData;
begin
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data := CDS.Data;
  ArrPrintData[0].RecNo := CDS.RecNo;
  ArrPrintData[0].IndexFieldNames := CDS.IndexFieldNames;
  ArrPrintData[0].Filter := CDS.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData := nil;
end;

procedure TFrmSTDI041.btn_exportClick(Sender: TObject);
begin
  GetExportXls(CDS, p_TableName);
end;

procedure TFrmSTDI041.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  if GetQueryString(p_TableName, tmpStr) then
    RefreshDS(tmpStr);
end;

procedure TFrmSTDI041.btn_firstClick(Sender: TObject);
begin
  CDS.First;
end;

procedure TFrmSTDI041.btn_priorClick(Sender: TObject);
begin
  CDS.Prior;
end;

procedure TFrmSTDI041.btn_nextClick(Sender: TObject);
begin
  CDS.Next;
end;

procedure TFrmSTDI041.btn_lastClick(Sender: TObject);
begin
  CDS.Last;
end;

procedure TFrmSTDI041.btn_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSTDI041.CDSAfterScroll(DataSet: TDataSet);
begin
  SetSBars;
end;

procedure TFrmSTDI041.DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    l_GridDesign.MouseDown(Button = mbRight, X, Y);
end;

procedure TFrmSTDI041.DBGridEh1ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if p_GridDesignAns and Assigned(l_GridDesign) then
    l_GridDesign.ColWidthChange;
end;

end.

