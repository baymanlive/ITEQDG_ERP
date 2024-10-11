unit unMPST070_SetSdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST070_SetSdate = class(TFrmSTDI051)
    Label3: TLabel;
    Dtp: TDateTimePicker;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    l_date1,l_date2:TDateTime;
    { Public declarations }
  end;

var
  FrmMPST070_SetSdate: TFrmMPST070_SetSdate;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST070_SetSdate.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('筆數：');
  Label2.Caption:=CheckLang('至');
  Label3.Caption:=CheckLang('生產日期：');
end;

procedure TFrmMPST070_SetSdate.FormShow(Sender: TObject);
begin
  inherited;
  Dtp.Date:=l_date1;
end;

procedure TFrmMPST070_SetSdate.btn_okClick(Sender: TObject);
begin
  if StrToIntDef(Edit1.Text,0)<=0 then
  begin
    ShowMsg('筆數輸入錯誤>0',48);
    Edit1.SetFocus;
    Exit;
  end;

  if StrToIntDef(Edit2.Text,0)<=0 then
  begin
    ShowMsg('筆數輸入錯誤>0',48);
    Edit2.SetFocus;
    Exit;
  end;

  if (Dtp.Date<l_date1) or (Dtp.Date>l_date2) then
  begin
    ShowMsg('日期不在范圍內',48);
    Dtp.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
