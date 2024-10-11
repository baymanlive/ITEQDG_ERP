{*******************************************************}
{                                                       }
{                unMPST070_Orderno2Edit                 }
{                Author: kaikai                         }
{                Create date: 2016/10/10                }
{                Description: PP兩角訂單更改            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_Orderno2Edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST070_Orderno2Edit = class(TFrmSTDI051)
    Label3: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_Orderno2Edit: TFrmMPST070_Orderno2Edit;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPST070_Orderno2Edit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('兩角訂單號碼：');
  Label3.Caption:=CheckLang('項次：');
end;

procedure TFrmMPST070_Orderno2Edit.btn_okClick(Sender: TObject);
var
  num:Integer;
begin
  if Trim(Edit2.Text)<>'' then
  begin
    num:=StrToIntDef(Edit2.Text, -1);
    if num<0 then
    begin
      ShowMsg('請輸入數字!',48);
      Edit2.SetFocus;
      Exit;
    end;
  end;

  inherited;
end;

end.
