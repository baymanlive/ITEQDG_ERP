unit unDLIR201_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR201_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    Edit1: TEdit;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR201_Query: TFrmDLIR201_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR201_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('派車日期(起)：');
  Label2.Caption:=CheckLang('派車日期(迄)：');
  Label3.Caption:=CheckLang('派車單號：');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR201_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於截止日期!', 48);
    Exit;
  end;

  inherited;
end;

end.
