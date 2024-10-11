unit unDLIR130_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR130_Query = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR130_Query: TFrmDLIR130_Query;

implementation

{$R *.dfm}

procedure TFrmDLIR130_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date-1;
end;

end.
