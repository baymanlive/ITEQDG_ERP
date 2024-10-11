unit unDLII020_upd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLII020_upd = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_upd: TFrmDLII020_upd;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLII020_upd.btn_okClick(Sender: TObject);
begin
  if Trim(Edit1.Text)='' then
  begin
    ShowMsg('請輸入[%s]!', 48, MyStringReplace(Label1.Caption));
    Edit1.SetFocus;
    Exit;
  end;
  if Trim(Edit2.Text)='' then
  begin
    ShowMsg('請輸入[%s]!', 48, MyStringReplace(Label2.Caption));
    Edit2.SetFocus;
    Exit;
  end;
  if Trim(Edit3.Text)='' then
  begin
    ShowMsg('請輸入[%s]!', 48, MyStringReplace(Label3.Caption));
    Edit3.SetFocus;
    Exit;
  end;
  if StrToFloatDef(Trim(Edit4.Text),-1)<0 then
  begin
    ShowMsg('請輸入[%s]!', 48, MyStringReplace(Label4.Caption));
    Edit4.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
