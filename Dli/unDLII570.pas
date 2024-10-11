{*******************************************************}
{                                                       }
{                unDLII570                              }
{                Author: kaikai                         }
{                Create date: 2015/7/17                 }
{                Description: COCÃC¦â¤è¦V               }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII570;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, ExtCtrls, DB, DBClient, Menus,
  ImgList, StdCtrls, Buttons, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TFrmDLII570 = class(TFrmSTDI010)
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    PPColor: TLabel;
    DBMemo1: TDBMemo;
    CCLColor: TLabel;
    DBMemo2: TDBMemo;
    PPDirection: TLabel;
    DBMemo3: TDBMemo;
    CCLDirection: TLabel;
    DBMemo4: TDBMemo;
    PPDirectionPnl: TLabel;
    DBMemo5: TDBMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII570: TFrmDLII570;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII570.SetToolBar;
begin
  inherited;
  btn_insert.Visible:=False;
  btn_delete.Visible:=False;
  btn_copy.Visible:=False;
end;

procedure TFrmDLII570.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI570 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII570.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI570';
  p_FocusCtrl:=DBMemo1;

  inherited;
end;

procedure TFrmDLII570.btn_queryClick(Sender: TObject);
begin
  //inherited;
  RefreshDS('');
end;

end.
