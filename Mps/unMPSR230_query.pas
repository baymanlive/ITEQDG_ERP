unit unMPSR230_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls;

type
  TFrmMPSR230_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
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
  FrmMPSR230_query: TFrmMPSR230_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmMPSR230_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�}�u����(�_)�G');
  Label2.Caption:=CheckLang('���G');
  Label3.Caption:=CheckLang('�u�渹�X�G');
  dtp1.Date:=Date-6;
  dtp2.Date:=Date;
end;

procedure TFrmMPSR230_query.btn_okClick(Sender: TObject);
var
  len:Integer;
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�d�߰_�l�������j�_�I����!',48);
    Exit;
  end;

  if dtp1.Date+30<dtp2.Date then
  begin
    ShowMsg('�d�߽d�򤣯�j��31��!',48);
    Exit;
  end;

  len:=Length(Trim(Edit1.Text));
  if (len>0) and (len<>10) then
  begin
    ShowMsg('�u�渹�X���~(10�X)!',48);
    Exit;
  end;

  inherited;
end;

end.
