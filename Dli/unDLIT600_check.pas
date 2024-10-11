unit unDLIT600_check;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmDLIT600_check = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    dtp: TDateTimePicker;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT600_check: TFrmDLIT600_check;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIT600_check.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('訂單日期：');
  Label2.Caption:=CheckLang('客戶編號：');
  dtp.Date:=Date;
end;

end.
