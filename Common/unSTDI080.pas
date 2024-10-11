{*******************************************************}
{                                                       }
{                unSTDI080                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 無資料表作業              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unSTDI080;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, Menus, ExtCtrls, ToolWin, StdCtrls, DB,
  DBClient, unFrmBaseEmpty, DateUtils, unDAL;

type
  TFrmSTDI080 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_print: TToolButton;
    btn_export: TToolButton;
    btn_query: TToolButton;
    btn_quit: TToolButton;
    ToolButton1: TToolButton;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_quitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    p_TableName,                      //表名
    p_SBText :string;                 //狀態欄顯示信息
    procedure SetToolBar;virtual;     //設置工具欄按扭
  end;

var
  FrmSTDI080: TFrmSTDI080;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmSTDI080.SetToolBar;
begin
  btn_print.Enabled := g_MInfo^.R_print;
  btn_export.Enabled := g_MInfo^.R_export;
  btn_query.Enabled := g_MInfo^.R_query;
end;

procedure TFrmSTDI080.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  Left:=0;
  Top:=0;  
  Self.Caption:=g_MInfo^.ProcName;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, p_TableName);
  SetToolBar;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(p_SBText), g_DllHandle, Self.Handle, False);
end;

procedure TFrmSTDI080.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmSTDI080.btn_quitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
