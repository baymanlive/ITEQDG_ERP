{*******************************************************}
{                                                       }
{                unMPST070_ShowErrList                  }
{                Author: kaikai                         }
{                Create date: 2016/8/22                 }
{                Description: 排程錯誤提示              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_ShowErrList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST070_ShowErrList = class(TFrmSTDI051)
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_ShowErrList: TFrmMPST070_ShowErrList;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPST070_ShowErrList.FormCreate(Sender: TObject);
begin
  inherited;
  btn_ok.Caption:=CheckLang('存儲為檔案');
end;

procedure TFrmMPST070_ShowErrList.btn_okClick(Sender: TObject);
begin
//  inherited;
  if SaveDialog1.Execute then
     Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

end.
