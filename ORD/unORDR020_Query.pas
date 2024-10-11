unit unORDR020_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, Menus, ImgList, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, ToolWin;

type
  TFrmORDR020_Query = class(TFrmSTDI050)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    Label3: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    dtp2: TDateTimePicker;
    chk1: TCheckBox;
    Label6: TLabel;
    edit6: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure chk1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORDR020_Query: TFrmORDR020_Query;

implementation
uses unCommon;
{$R *.dfm}

procedure TFrmORDR020_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�u�����_�G');
  Label5.Caption:=CheckLang('�u�������G');
  Label2.Caption:=CheckLang('�u��s���G');
  Label3.Caption:=CheckLang('�Ƹ��G');
  Label4.Caption:=CheckLang('�q�渹�G');
  Label6.Caption:=CheckLang('���t�G');
  Dtp1.date:=date;
  Dtp2.date:=Dtp1.date;
end;

procedure TFrmORDR020_Query.btn_okClick(Sender: TObject);
begin

//  if Dtp1.Date>Dtp2.Date then
//  begin
//    ShowMsg('�X�f���(��)����j��X�f���(�_)!', 48);
//    Exit;
//  end;
//  if Trim(Edit1.Text) = EmptyStr then
//    if Dtp2.Date-Dtp1.Date > 7 then
//    begin
//      ShowMsg('����d�򤣯�W�L�@�P', 48);
//      Exit;
//    end;
//  if chk1.Checked and ((Trim(Edit1.text)='') and (Trim(Edit2.text)=''))  then
//    begin
//      ShowMsg('�п�J�Ȥ�s���έq�渹', 48);
//      Exit;
//    end;
  inherited;
end;

procedure TFrmORDR020_Query.chk1Click(Sender: TObject);
begin
  inherited;
  Dtp1.Enabled:=chk1.Checked;
  dtp2.Enabled:=Dtp1.Enabled;
end;

end.
