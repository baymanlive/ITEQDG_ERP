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
  Label1.Caption:=CheckLang('�������(�_)�G');
  Label2.Caption:=CheckLang('�������(��)�G');
  Label3.Caption:=CheckLang('�����渹�G');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR201_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�d�߶}�l�������j��I����!', 48);
    Exit;
  end;

  inherited;
end;

end.
