{*******************************************************}
{                                                       }
{                unDLII310                              }
{                Author: kaikai                         }
{                Create date: 2015/7/17                 }
{                Description: µô¤Á§Q¥Î²v                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI280;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, ExtCtrls, DB, DBClient, Menus,
  ImgList, StdCtrls, Buttons, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TFrmMPSI280 = class(TFrmSTDI010)
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Lock: TDBCheckBox;
    Urate_lower: TLabel;
    Urate_upper: TLabel;
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
  FrmMPSI280: TFrmMPSI280;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI280.SetToolBar;
begin
  inherited;
  btn_insert.Visible:=False;
  btn_delete.Visible:=False;
  btn_copy.Visible:=False;
end;

procedure TFrmMPSI280.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS280 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI280.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS280';
  p_FocusCtrl:=DBEdit1;

  inherited;
end;

procedure TFrmMPSI280.btn_queryClick(Sender: TObject);
begin
  //inherited;
  RefreshDS('');
end;

end.
