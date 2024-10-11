unit unDLII040_cocerr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLII040_cocerr = class(TFrmSTDI051)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    l_Coc_errid:string;
    { Public declarations }
  end;

var
  FrmDLII040_cocerr: TFrmDLII040_cocerr;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLII040_cocerr.FormCreate(Sender: TObject);
begin
  inherited;
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
end;

procedure TFrmDLII040_cocerr.FormShow(Sender: TObject);
var
  str,errid:string;
begin
  inherited;
  str:='';
  errid:=','+l_Coc_errid+',';
  if pos(',0,', errid)>0 then
     str:=str+'�̪O���`'+#13#10;
  if pos(',1,', errid)>0 then
     str:=str+'�]�˯}�l'+#13#10;
  if pos(',2,', errid)>0 then
     str:=str+'���\�˫~��'+#13#10;
  if pos(',3,', errid)>0 then
     str:=str+'�ɺ䤣��'+#13#10;
  if pos(',4,', errid)>0 then
     str:=str+'��������'+#13#10;
  if pos(',5,', errid)>0 then
     str:=str+'�������i���X'+#13#10;
  if pos(',6,', errid)>0 then
     str:=str+'�p���Ҳ��`'+#13#10;
  if pos(',7,', errid)>0 then
     str:=str+'�~�W/�W�榳�~'+#13#10;
  if pos(',8,', errid)>0 then
     str:=str+'���Ҳ��`'+#13#10;
  if pos(',9,', errid)>0 then
     str:=str+'�Ƶ����~'+#13#10;
  if pos(',10,', errid)>0 then
     str:=str+'�Ȥ�G���X���~'+#13#10;
  if Length(str)=0 then
     str:=Trim(l_Coc_errid);
  Memo1.Lines.Text:=CheckLang(str);
end;

end.
