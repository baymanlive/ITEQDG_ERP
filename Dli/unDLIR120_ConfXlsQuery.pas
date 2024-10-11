unit unDLIR120_ConfXlsQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR120_ConfXlsQuery = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    lblcustno: TLabel;
    Edit1: TEdit;
    Dtp2: TDateTimePicker;
    lblto2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR120_ConfXlsQuery: TFrmDLIR120_ConfXlsQuery;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR120_ConfXlsQuery.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR120_ConfXlsQuery.btn_okClick(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入客戶編號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
