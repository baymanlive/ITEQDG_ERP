unit unDLIR290_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DateUtils;

type
  TFrmDLIR290_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
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
  FrmDLIR290_Query: TFrmDLIR290_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR290_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
  Label1.Caption:=CheckLang('�X�f���(�_)�G');
  Label2.Caption:=CheckLang('�X�f���(��)�G');
  Label3.Caption:=CheckLang('�Ȥ�s���G');
  Label4.Caption:=CheckLang('���y�H���b���G');
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR290_Query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�X�f���(�_)����j��X�f���(��)!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Dtp2.Date>Date+1 then
  begin
    ShowMsg('�X�f���(��)����j���Ѥ��+1!', 48);
    Dtp2.SetFocus;
    Exit;
  end;

  if DaysBetween(Dtp1.Date, Dtp2.Date)>180 then
  begin
    ShowMsg('�d�ߤ���϶�����j��180��!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
