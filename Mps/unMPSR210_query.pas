unit unMPSR210_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmMPSR210_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR210_query: TFrmMPSR210_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR210_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('生產日期(起)：');
  Label2.Caption:=CheckLang('生產日期(迄)：');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmMPSR210_query.btn_okClick(Sender: TObject);
begin
//  if dtp1.Date<Date then
//  begin
//    ShowMsg('查詢日期不能小于當天日期',48);
//    Exit;
//  end;
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('查詢起始日期不能大于截止日期',48);
    Exit;
  end;
  inherited;
end;

end.
