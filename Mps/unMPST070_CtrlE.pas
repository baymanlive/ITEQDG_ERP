{*******************************************************}
{                                                       }
{                unMPST010_SqtyEdit                     }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: �F����,�ƶq���         }
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

  Label1.Caption:=CheckLang('�ͺޭ�F�����G');
  Label2.Caption:=CheckLang('�ͺ޷s�F�����G');
  Label3.Caption:=CheckLang('�ƻs�ƶq�G');
  Label7.Caption:=CheckLang('����Ƹ��G');
  Label5.Caption:=CheckLang('�ͺޯS�O�Ƶ��G');
  Label6.Caption:=CheckLang('�s�O�渹�G');
  Label4.Caption:=CheckLang('�q��渹�G');
  Label8.Caption:=CheckLang('�q�涵���G');
  Label9.Caption:=CheckLang('���ءG');
  Dtp.Text:='';
end;

procedure TFrmMPS070_CtrlE.btn_okClick(Sender: TObject);
begin
  if StrToFloatDef(Edit2.Text, -1)<0 then
  begin
    ShowMsg('�ƻs�q�п�J�Ʀr,�B���i�p��0!',48);
    Edit2.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
