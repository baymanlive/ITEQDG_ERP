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
  Label2.Caption:=CheckLang('�Ȥ��J�h�Ӯɥγr�����}');
  Label3.Caption:=CheckLang('�Ƹ��i�H��J�e�X�X');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

end.
