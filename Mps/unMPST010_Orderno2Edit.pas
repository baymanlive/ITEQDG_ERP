{*******************************************************}
{                                                       }
{                unMPST010_Orderno2Edit                 }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: �⨤�q����              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_Orderno2Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmOrderno2Edit = class(TFrmSTDI051)
    Label2: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit1: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmOrderno2Edit: TFrmOrderno2Edit;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmOrderno2Edit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�q�渹�X�G');
  Label2.Caption:=CheckLang('�����G');
end;

procedure TFrmOrderno2Edit.FormShow(Sender: TObject);
begin
  inherited;
  Edit2.Color:=clWindow;
end;

procedure TFrmOrderno2Edit.btn_okClick(Sender: TObject);
var
  num:Integer;
begin
  if Trim(Edit2.Text)<>'' then
  begin
    num:=StrToIntDef(Edit2.Text, -1);
    if num<0 then
    begin
      Edit2.Color:=clInfoBk;
      Edit2.SetFocus;
      Exit;
    end;
  end;

  inherited;
end;

end.
