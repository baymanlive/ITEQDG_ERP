unit unMPST012_copy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST012_copy = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_qty:Integer;
    { Public declarations }
  end;

var
  FrmMPST012_copy: TFrmMPST012_copy;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST012_copy.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('����ƶq�G');
  Label3.Caption:='';
end;

procedure TFrmMPST012_copy.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Text:=IntToStr(l_qty);
  Label2.Caption:=CheckLang('�`�ƶq�G')+Edit1.Text;
end;

procedure TFrmMPST012_copy.Edit1Change(Sender: TObject);
var
  qty,remainQty:Integer;
begin
  inherited;
  qty:=StrToIntDef(Edit1.Text,0);
  if (qty<=0) or (qty>l_qty) then
     Label3.Caption:=CheckLang('����ƶq�G'+IntToStr(qty)+', �@0��')
  else begin
    remainQty:=l_qty mod qty;
    if remainQty=0 then
       Label3.Caption:=CheckLang('����ƶq�G'+IntToStr(qty)+', �@'+IntToStr(Trunc(l_qty/qty))+'��')
    else
       Label3.Caption:=CheckLang('����ƶq�G'+IntToStr(qty)+', �@'+IntToStr(Trunc(l_qty/qty)+1)+'��,�䤤�@���G'+IntToStr(remainQty));
  end;
end;

procedure TFrmMPST012_copy.btn_okClick(Sender: TObject);
var
  qty:Integer;
begin
  qty:=StrToIntDef(Edit1.Text,0);
  if (qty<=0) or (qty>l_qty) then
  begin
    ShowMsg('����ƶq����>0,�B<'+IntToStr(l_qty),48);
    Exit;
  end;

  inherited;
end;

end.
