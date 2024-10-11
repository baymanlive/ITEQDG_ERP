unit unDLIR701_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DateUtils;

type
  TFrmDLIR701_Query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label2: TLabel;
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
  FrmDLIR701_Query: TFrmDLIR701_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR701_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=EncodeDate(YearOf(Date),MonthOf(Date),1);
  Dtp2.Date:=Date;
  Label1.Caption:=CheckLang('�X�f����G');
  Label2.Caption:=CheckLang('��');
  Label3.Caption:=CheckLang('�Ȥ�s���G');
end;

procedure TFrmDLIR701_Query.btn_okClick(Sender: TObject);
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�d�߶}�l������i�j��I����',48);
    dtp1.SetFocus;
    Exit;
  end;

  if dtp1.Date>Date then
  begin
    ShowMsg('�d�߶}�l������i�j��t�Τ��',48);
    dtp1.SetFocus;
    Exit;
  end;

  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('�п�J�Ȥ�s��',48);
    Edit1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
