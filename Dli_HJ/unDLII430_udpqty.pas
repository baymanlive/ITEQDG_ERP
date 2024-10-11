unit unDLII430_udpqty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLII430_udpqty = class(TFrmSTDI051)
    MC: TMonthCalendar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII430_udpqty: TFrmDLII430_udpqty;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII430_udpqty.FormCreate(Sender: TObject);
begin
  inherited;
  MC.Date:=Date;
end;

procedure TFrmDLII430_udpqty.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //inherited;
  g_StatusBar.Panels[0].Text:=CheckLang('正在更新,請等待...');
  btn_ok.Enabled:=False;
  btn_quit.Enabled:=False;
  Application.ProcessMessages;
  try
    tmpSQL:='exec dbo.proc_UpdateDLI430 '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(DateToStr(MC.Date));
    if QueryOneCR(tmpSQL, Data) then
       ShowMsg('更新完畢!',64);
  finally
    btn_ok.Enabled:=True;
    btn_quit.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
