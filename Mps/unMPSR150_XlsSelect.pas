unit unMPSR150_XlsSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmMPSR150_XlsSelect = class(TFrmSTDI051)
    RadioGroup1: TRadioGroup;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    rb4: TRadioButton;
    rb5: TRadioButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR150_XlsSelect: TFrmMPSR150_XlsSelect;

implementation

{$R *.dfm}

end.
