unit unMPSR170_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmMPSR170_query = class(TFrmSTDI051)
    rgp1: TRadioGroup;
    rgp2: TRadioGroup;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    lblto: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR170_query: TFrmMPSR170_query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR170_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('客戶代號,多個請用逗號(,)分開');
  Label2.Caption:=CheckLang('膠系(第2碼),多個請用逗號(,)分開');
  Label3.Caption:=CheckLang('厚度區間(CCL第3~6碼)');
  Label4.Caption:=CheckLang('達交日期');
  Label5.Caption:=lblto.Caption;
  dtp1.Date:=Date;
  dtp2.Date:=Date+90;
end;

procedure TFrmMPSR170_query.btn_okClick(Sender: TObject);
begin
  if rgp1.ItemIndex in [0,1] then
  begin
    if Length(Edit3.Text)>0 then
    begin
      if Length(Edit3.Text)<>4 then
      begin
        ShowMsg('厚度區間(起)錯誤!',48);
        Exit;
      end;

      if StrToIntDef(Edit3.Text,0)<0 then
      begin
        ShowMsg('厚度區間(起)錯誤!',48);
        Exit;
      end;
    end;

    if Length(Edit4.Text)>0 then
    begin
      if Length(Edit4.Text)<>4 then
      begin
        ShowMsg('厚度區間(迄)錯誤!',48);
        Exit;
      end;

      if StrToIntDef(Edit4.Text,0)<0 then
      begin
        ShowMsg('厚度區間(迄)錯誤!',48);
        Exit;
      end;
    end;
  end;

  if dtp1.Date<Date then
  begin
    ShowMsg('查詢開始日期不可小于當天!',48);
    Exit;
  end;

  if dtp2.Date>dtp1.Date+90 then
  begin
    ShowMsg('查詢日期區間不可大於90天!',48);
    Exit;
  end;

  inherited;
end;

end.
