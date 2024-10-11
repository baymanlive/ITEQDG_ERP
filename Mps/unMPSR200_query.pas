unit unMPSR200_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmMPSR200_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR200_query: TFrmMPSR200_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR200_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('組合站報工日期：');
  Label2.Caption:=CheckLang('裁邊站報工日期：');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

end.
