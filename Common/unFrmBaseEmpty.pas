{*******************************************************}
{                                                       }
{                unFrmBaseEmpty                         }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: 基類                      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unFrmBaseEmpty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, ComCtrls, DBGridEh, unGlobal, unCommon, ExtCtrls,
  ImgList, ShellApi;

type
  TFrmBaseEmpty = class(TForm)
    ImageList1: TImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure WMActivate(var msg: TMessage);message WM_ACTIVATE;
    procedure WMMouseActivate(var msg: TMessage);message WM_MOUSEACTIVATE;
  public
    { Public declarations }
  protected
    p_isModalForm:Boolean;
    procedure MyMessage(var msg:TWmCopyData);message WM_CopyData;
  end;

var
  FrmBaseEmpty: TFrmBaseEmpty;

implementation

{$R *.dfm}

//dll獲得焦點,exe標題變灰色問題
procedure TFrmBaseEmpty.WMActivate(var msg: TMessage);
begin
  if g_MainHandle>0 then
  begin
    if msg.wParam=WA_INACTIVE then                                       
       SendMessage(g_MainHandle, WM_NCACTIVATE, Integer(False), 0)
    else if ((msg.wParam=WA_ACTIVE) or (msg.wParam=WA_CLICKACTIVE)) then
    begin
      SendMessage(g_MainHandle, WM_NCACTIVATE, Integer(True), 0);
      SendMessage(g_MainHandle, WM_ACTIVATE, WA_ACTIVE, 0);
      Exit;
    end;
  end;
  inherited;
end;

//dll獲得焦點,被其它程序蓋住時,鼠標操作置前
procedure TFrmBaseEmpty.WMMouseActivate(var msg: TMessage);
var
  H:HWND;
begin
  if (g_MainHandle>0) and (not p_isModalForm) then
  begin
    H:=GetForegroundWindow;
    if (H<>Self.Handle) and (H<>g_MainHandle) then
       SendMessage(g_MainHandle, WM_ACTIVATE, WA_ACTIVE, 0);
  end;
  inherited;
end;

procedure TFrmBaseEmpty.MyMessage(var msg: TWmCopyData);
const btn='btn_quit';
var
  str:string;
begin
  str:=StrPas(msg.CopyDataStruct^.lpData);
  if LowerCase(str)='close' then
  begin
    //
  end
  else if LowerCase(str)='quit' then
  begin
    if Self.FindComponent(btn)<>nil then
    if Self.FindComponent(btn) is TToolButton then
       TToolButton(Self.FindComponent(btn)).Click;
  end;
end;

procedure TFrmBaseEmpty.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  Self.ScaleBy(96, Self.PixelsPerInch);

  for i:=0 to Self.ComponentCount-1 do
  if Self.Components[i] is TDBGridEh then
    (Self.Components[i] as TDBGridEh).Columns.ScaleWidths(96,Screen.PixelsPerInch);
  InitCustGroup;
end;

procedure TFrmBaseEmpty.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if ActiveControl is TDBGridEh then
       DBGridEhSelNext(TDBGridEh(ActiveControl), Key)
    else if (not (ActiveControl is TMemo)) and
            (not (ActiveControl is TDBMemo)) and
            (not (ActiveControl is TRichEdit)) then
       SelectNext(ActiveControl, True, True);
  end
  else if Key = VK_ESCAPE then
  begin
    if Self.Caption<>g_MInfo^.ProcName then
       Close;
  end
  else if Key = VK_F1 then
  begin
    if g_MainHandle>0 then
       CopyDataSendMsg(g_MainHandle,'help')
    else
    if pos(LowerCase(Self.Name), 'frmlogin,frmmain,frmfavorite,frmpw')>0 then
       ShellExecute(Handle, nil, PAnsiChar('Help\'+Copy(Self.Name,4,20)+'.html'), nil, nil, SW_SHOWNORMAL);
  end;
end;

end.
