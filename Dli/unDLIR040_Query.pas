unit unDLIR040_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmDLIR040_Query = class(TFrmSTDI051)
    Dtp: TDateTimePicker;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    RadioGroup2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR040_Query: TFrmDLIR040_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR040_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp.Date:=Date;
end;

end.
