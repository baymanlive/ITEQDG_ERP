unit unMPSR190_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmMPSR190_query = class(TFrmSTDI051)
    MonthCalendar1: TMonthCalendar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR190_query: TFrmMPSR190_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR190_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('¥X³f¤é´Á');
  MonthCalendar1.Date:=Date;
end;

end.
