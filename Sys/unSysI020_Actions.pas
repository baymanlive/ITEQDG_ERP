unit unSysI020_Actions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmSysI020_Actions = class(TFrmSTDI051)
    Ainsert: TCheckBox;
    Aedit: TCheckBox;
    Adelete: TCheckBox;
    Acopy: TCheckBox;
    Agarbage: TCheckBox;
    Afirst: TCheckBox;
    Aprior: TCheckBox;
    Ajump: TCheckBox;
    Anext: TCheckBox;
    Alast: TCheckBox;
    Aprop: TCheckBox;
    Aquery: TCheckBox;
    Aprint: TCheckBox;
    Aexport: TCheckBox;
    checkAll: TCheckBox;
    Bevel1: TBevel;
    procedure checkAllClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_Actions:string;
    { Public declarations }
  end;

var
  FrmSysI020_Actions: TFrmSysI020_Actions;

implementation

{$R *.dfm}

procedure TFrmSysI020_Actions.checkAllClick(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  for i:=0 to Self.ControlCount -1 do
  begin
    if (Self.Controls[i] is TCheckBox) and
       ((Self.Controls[i] as TCheckBox).Tag<>1) then
       (Self.Controls[i] as TCheckBox).Checked:=checkall.Checked;
  end;
end;

procedure TFrmSysI020_Actions.FormShow(Sender: TObject);
var
  tmpstr:string;
  i:Integer;
begin
  inherited;
  l_Actions:=LowerCase(l_Actions);
  for i:=0 to Self.ControlCount -1 do
  begin
    if Self.Controls[i] is TCheckBox then
    begin
      tmpstr:=LowerCase(Self.Controls[i].Name);
      Delete(tmpstr,1,1);
      if Pos(tmpstr, l_Actions)>0 then
         (Self.Controls[i] as TCheckBox).Checked:=True;
    end;
  end;
end;

procedure TFrmSysI020_Actions.btn_okClick(Sender: TObject);
var
  tmpstr:string;
  i:Integer;
begin
  l_Actions:='';
  for i:=0 to Self.ControlCount -1 do
  begin
    if Self.Controls[i] is TCheckBox then
    begin
      if (Self.Controls[i] as TCheckBox).Checked and
         ((Self.Controls[i] as TCheckBox).Tag<>1) then
      begin
        tmpstr:=LowerCase(Self.Controls[i].Name);
        Delete(tmpstr,1,1);
        l_Actions:=l_Actions+','+tmpstr;
      end;
    end;
  end;
  
  if l_Actions<>'' then
     l_Actions:=l_Actions+',';
     
  inherited;
end;

end.
