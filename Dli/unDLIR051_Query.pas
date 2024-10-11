unit unDLIR051_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmDLIR051_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Dtp2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR051_Query: TFrmDLIR051_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR051_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
  Label1.Caption:=CheckLang('掃描日期(起)：');
  Label2.Caption:=CheckLang('掃描日期(迄)：');
  Label3.Caption:=CheckLang('客戶編號：');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR051_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('掃描日期(迄)不能大於掃描日期(起)!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入客戶編號,多個客戶編號請用逗號(,)分開!', 48);
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
