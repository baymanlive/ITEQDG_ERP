unit unDLIR250_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmDLIR250_Query = class(TFrmSTDI051)
    dtp1: TDateTimePicker;
    lblorderdate: TLabel;
    rgp: TRadioGroup;
    lblcustno: TLabel;
    Edit2: TEdit;
    lblpno: TLabel;
    Edit3: TEdit;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    Edit1: TEdit;
    lblorderno: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR250_Query: TFrmDLIR250_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR250_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label2.Caption:=CheckLang('客戶輸入多個時用逗號分開');
  Label3.Caption:=CheckLang('料號可以輸入前幾碼');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

end.
