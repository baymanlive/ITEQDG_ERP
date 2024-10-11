{*******************************************************}
{                                                       }
{                unMPST010_ShowErrList                  }
{                Author: kaikai                         }
{                Create date: 2015/4/24                 }
{                Description: 排程錯誤提示              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_ShowErrList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmShowErrList = class(TFrmSTDI051)
    Memo1: TMemo;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmShowErrList: TFrmShowErrList;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmShowErrList.FormCreate(Sender: TObject);
begin
  inherited;
  btn_ok.Caption:=CheckLang('存儲為檔案');
end;

procedure TFrmShowErrList.btn_okClick(Sender: TObject);
begin
//  inherited;
  if SaveDialog1.Execute then
     Memo1.Lines.SaveToFile(SaveDialog1.FileName);
end;

end.
