{*******************************************************}
{                                                       }
{                unSTDI050                              }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: ¼ÒºAForm+PageControl      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unSTDI050;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmSTDI050 = class(TFrmBaseEmpty)
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    PCL: TPageControl;
    TabSheet1: TTabSheet;
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
  FrmSTDI050: TFrmSTDI050;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSTDI050.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, Self.Name);
end;

procedure TFrmSTDI050.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  p_isModalForm:=False;
end;

procedure TFrmSTDI050.btn_okClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrOK;
end;

procedure TFrmSTDI050.btn_quitClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrCancel;
end;

procedure TFrmSTDI050.FormShow(Sender: TObject);
begin
  inherited;
  p_isModalForm:=True;
end;

end.
