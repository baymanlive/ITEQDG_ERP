unit unDLIR091_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmDLIR091_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Dtp2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR091_Query: TFrmDLIR091_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR091_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
  Label1.Caption:=CheckLang('�X�f���(�_)�G');
  Label2.Caption:=CheckLang('�X�f���(��)�G');
  Label3.Caption:=CheckLang('�Ȥ�s���G');
  Label4.Caption:=CheckLang('�帹�G');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR091_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�X�f���(��)����j��X�f���(�_)!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
