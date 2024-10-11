{*******************************************************}
{                                                       }
{                unMPST010_SqtyEdit                     }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: 達交日期,數量更改         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST012_CtrlE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST012_CtrlE = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Dtp: TDateTimePicker;
    Label4: TLabel;
    Edit3: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label6: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Edit6: TEdit;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Label11: TLabel;
    Edit10: TEdit;
    Label12: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST012_CtrlE: TFrmMPST012_CtrlE;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_CtrlE.FormCreate(Sender: TObject);
begin
  inherited;
  Label8.Caption:=CheckLang('原生管達交日期：');
  Label1.Caption:=CheckLang('生管達交日期：');
  Label2.Caption:=CheckLang('排製數量：');
  Label3.Caption:=CheckLang('物件料號：');
  Label4.Caption:=CheckLang('生管備註一：');
  Label5.Caption:=CheckLang('訂單號碼：');
  Label6.Caption:=CheckLang('訂單項次：');
  Label7.Caption:=CheckLang('生管備註二：');
  Label9.Caption:=CheckLang('兩角訂單號碼：');
  Label10.Caption:=CheckLang('兩角訂單項次：');
  Label11.Caption:=CheckLang('生管備註三：');
  Label12.Caption:=CheckLang('加投數：');

  if not SameText(g_UInfo^.BU,'ITEQJX') then
  begin
    Label9.Visible:=False;
    Label10.Visible:=False;
    Edit8.Visible:=False;
    Edit9.Visible:=False;
    Self.ClientHeight:=Edit9.Top;
  end;
end;

procedure TFrmMPST012_CtrlE.btn_okClick(Sender: TObject);
begin
  if StrToIntDef(Edit1.Text, -1)<0 then
  begin
    Edit1.Color:=clInfoBk;
    Edit1.SetFocus;
    Exit;
  end;

  if StrToIntDef(Edit5.Text, 0)<1 then
  begin
    Edit5.Color:=clInfoBk;
    Edit5.SetFocus;
    Exit;
  end;

  if Edit9.Visible and (Length(Edit8.Text)>0) then
  if StrToIntDef(Edit9.Text, 0)<1 then
  begin
    Edit9.Color:=clInfoBk;
    Edit9.SetFocus;
    Exit;
  end;

  inherited;
end;

procedure TFrmMPST012_CtrlE.Edit1Exit(Sender: TObject);
begin
  inherited;
  // longxinjue 2022.01.07 排制數量小於訂單數量的話，加投數量為 0
  if(strtofloat(Edit1.Text)<=strtofloat(Edit12.Text)) then
    Edit11.Text:='0'
  else
    Edit11.Text:= floattostr( strtofloat(Edit1.Text) - strtofloat(Edit12.Text) );
end;

end.
