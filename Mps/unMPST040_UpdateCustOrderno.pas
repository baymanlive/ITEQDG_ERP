unit unMPST040_UpdateCustOrderno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmMPST040_UpdateCustOrderno = class(TFrmSTDI051)
    MonthCalendar1: TMonthCalendar;
    Label1: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_UpdateCustOrderno: TFrmMPST040_UpdateCustOrderno;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST040_UpdateCustOrderno.FormCreate(Sender: TObject);
begin
  inherited;
  MonthCalendar1.Date:=Date;
end;

procedure TFrmMPST040_UpdateCustOrderno.btn_okClick(Sender: TObject);
begin
  //inherited;
  if ShowMsg('�T�w��s'+DateToStr(MonthCalendar1.Date)+'�⨤�q��Ȥ�q�渹�X��?',33)=IdCancel then
     Exit;

  if PostBySQL('exec [dbo].[proc_UpdateCustorderno] '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(DateToStr(MonthCalendar1.Date))) then
     ShowMsg('��s����!',64);
end;


end.
