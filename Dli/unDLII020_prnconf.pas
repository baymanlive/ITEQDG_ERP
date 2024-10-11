unit unDLII020_prnconf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmDLII020_prnconf = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_prnconf: TFrmDLII020_prnconf;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII020_prnconf.btn_okClick(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入出貨單號',48);
    Exit;
  end;

  inherited;
end;

end.
