{*******************************************************}
{                                                       }
{                unSTDI051                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: ¼ÒºAForm                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unSTDI051;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFrmSTDI051 = class(TFrmBaseEmpty)
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    PnlRight: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSTDI051: TFrmSTDI051;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSTDI051.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, Self.Name);
end;

procedure TFrmSTDI051.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  p_isModalForm:=False;
end;

procedure TFrmSTDI051.btn_okClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrOK;
end;

procedure TFrmSTDI051.btn_quitClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrCancel;
end;

procedure TFrmSTDI051.FormShow(Sender: TObject);
begin
  inherited;
  p_isModalForm:=True;
end;

end.
