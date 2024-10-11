unit unMPST090_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmMPST090_query = class(TFrmSTDI051)
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST090_query: TFrmMPST090_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPST090_query.FormCreate(Sender: TObject);
begin
  inherited;
  RadioGroup1.Items.Strings[0]:=CheckLang('東莞排程');
  RadioGroup1.Items.Strings[1]:=CheckLang('廣州排程');
end;

end.
