unit unDLIR240_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls, DateUtils;

type
  TFrmDLIR240_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR240_query: TFrmDLIR240_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR240_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('掃描日期:');
  Label2.Caption:=CheckLang('客戶編號:');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmDLIR240_query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大于截止日期!',48);
    Exit;
  end;

  if Dtp2.Date-Dtp1.Date>179 then
  begin
    ShowMsg('查詢范圍不能大于180天!',48);
    Exit;
  end;
 
  inherited;
end;

end.
