{*******************************************************}
{                                                       }
{                unMPST010_SqtyEdit                     }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: �F����,�ƶq���         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_SqtyEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmSqtyEdit = class(TFrmSTDI051)
    Label2: TLabel;
    Edit2: TEdit;
    Dtp: TDateTimePicker;
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
    Label9: TLabel;
    Edit8: TEdit;
    Label3: TLabel;
    Label10: TLabel;
    Edit9: TEdit;
    Label11: TLabel;
    Edit10: TEdit;
    Label12: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Label13: TLabel;
    Edit13: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSqtyEdit: TFrmSqtyEdit;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSqtyEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('��ͺ޹w�w�F�����G');
  Label2.Caption:=CheckLang('�ͺ޹w�w�F�����G');
  Label3.Caption:=CheckLang('�ƻs�ƶq�G');
  Label7.Caption:=CheckLang('����Ƹ��G');
  Label5.Caption:=CheckLang('�ͺޯS�O�Ƶ��G');
  Label10.Caption:=CheckLang('�ͺޯS�O�Ƶ��G�G');
  Label11.Caption:=CheckLang('�ͺޯS�O�Ƶ��T�G');
  Label6.Caption:=CheckLang('�s�O�渹�G');
  Label4.Caption:=CheckLang('�q��渹�G');
  Label8.Caption:=CheckLang('�q�涵���G');
  Label9.Caption:=CheckLang('�t�ӡG');
  Label12.Caption:=CheckLang('�[��ƶq�G');
  Label13.Caption:=CheckLang('�˫~�ƶq�G');
end;

procedure TFrmSqtyEdit.FormShow(Sender: TObject);
begin
  inherited;
  Edit2.Color:=clWindow;
end;

procedure TFrmSqtyEdit.btn_okClick(Sender: TObject);
begin
  if StrToIntDef(Edit2.Text, -1)<0 then
  begin
    Edit2.Color:=clInfoBk;
    Edit2.SetFocus;
    Exit;
  end;

  inherited;
end;

procedure TFrmSqtyEdit.Edit2Exit(Sender: TObject);
begin
  inherited;
  // longxinjue 2022.01.07 �ƨ�ƶq�p��q��ƶq���ܡA�[��ƶq�� 0
  if(strtofloat(Edit2.Text)<=strtofloat(Edit12.Text)) then
    Edit11.Text:='0'
  else
    Edit11.Text:= floattostr( strtofloat(Edit2.Text) - strtofloat(Edit12.Text) );
end;

end.
