unit unDLIR300_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DateUtils;

type
  TFrmDLIR300_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Dtp2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR300_Query: TFrmDLIR300_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR300_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit4.Text:='';
  Label1.Caption:=CheckLang('出貨日期(起)：');
  Label2.Caption:=CheckLang('出貨日期(迄)：');
  Label3.Caption:=CheckLang('客戶編號：');
  Label4.Caption:=CheckLang('訂單號：');
  Label5.Caption:=CheckLang('送貨單號：');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR300_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('出貨日期(起)不能大於出貨日期(迄)!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Dtp2.Date>Date+1 then
  begin
    ShowMsg('出貨日期(迄)不能大於當天日期+1!', 48);
    Dtp2.SetFocus;
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>30 then
  begin
    ShowMsg('查詢日期區間不能大於30天!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
