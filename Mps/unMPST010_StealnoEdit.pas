{*******************************************************}
{                                                       }
{                unMPST010_StealnoEdit                  }
{                Author: kaikai                         }
{                Create date: 2015/5/7                  }
{                Description: 鋼板更改                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_StealnoEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmStealnoEdit = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmStealnoEdit: TFrmStealnoEdit;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmStealnoEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('鋼板：');
  Label2.Caption:=CheckLang('生管特別備註：');
  Label3.Caption:=CheckLang('生管備註二：');
  Label4.Caption:=CheckLang('生管備註三：');
end;

procedure TFrmStealnoEdit.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Color:=clWindow;
end;

procedure TFrmStealnoEdit.btn_okClick(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then
  begin
    Edit1.Color:=clInfoBk;
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
