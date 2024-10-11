{*******************************************************}
{                                                       }
{                unMPST010_SqtyEdit                     }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: 達交日期,數量更改         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_CtrlE;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBCtrlsEh, Mask, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPS070_CtrlE = class(TFrmSTDI051)
    Label3: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label1: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label7: TLabel;
    Label4: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Label8: TLabel;
    Dtp: TDBDateTimeEditEh;
    Label9: TLabel;
    Cbb: TDBComboBoxEh;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPS070_CtrlE: TFrmMPS070_CtrlE;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPS070_CtrlE.FormCreate(Sender: TObject);
begin
  inherited;
  SetStrings(Cbb.Items,'Vendor','MPS690');

  Label1.Caption:=CheckLang('生管原達交日期：');
  Label2.Caption:=CheckLang('生管新達交日期：');
  Label3.Caption:=CheckLang('排製數量：');
  Label7.Caption:=CheckLang('物件料號：');
  Label5.Caption:=CheckLang('生管特別備註：');
  Label6.Caption:=CheckLang('製令單號：');
  Label4.Caption:=CheckLang('訂單單號：');
  Label8.Caption:=CheckLang('訂單項次：');
  Label9.Caption:=CheckLang('布種：');
  Dtp.Text:='';
end;

procedure TFrmMPS070_CtrlE.btn_okClick(Sender: TObject);
begin
  if StrToFloatDef(Edit2.Text, -1)<0 then
  begin
    ShowMsg('排製量請輸入數字,且不可小於0!',48);
    Edit2.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
