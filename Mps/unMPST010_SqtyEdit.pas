{*******************************************************}
{                                                       }
{                unMPST010_SqtyEdit                     }
{                Author: kaikai                         }
{                Create date: 2015/4/21                 }
{                Description: 達交日期,數量更改         }
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
  Label1.Caption:=CheckLang('原生管預定達交日期：');
  Label2.Caption:=CheckLang('生管預定達交日期：');
  Label3.Caption:=CheckLang('排製數量：');
  Label7.Caption:=CheckLang('物件料號：');
  Label5.Caption:=CheckLang('生管特別備註：');
  Label10.Caption:=CheckLang('生管特別備註二：');
  Label11.Caption:=CheckLang('生管特別備註三：');
  Label6.Caption:=CheckLang('製令單號：');
  Label4.Caption:=CheckLang('訂單單號：');
  Label8.Caption:=CheckLang('訂單項次：');
  Label9.Caption:=CheckLang('廠商：');
  Label12.Caption:=CheckLang('加投數量：');
  Label13.Caption:=CheckLang('樣品數量：');
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
  // longxinjue 2022.01.07 排制數量小於訂單數量的話，加投數量為 0
  if(strtofloat(Edit2.Text)<=strtofloat(Edit12.Text)) then
    Edit11.Text:='0'
  else
    Edit11.Text:= floattostr( strtofloat(Edit2.Text) - strtofloat(Edit12.Text) );
end;

end.
