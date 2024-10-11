unit unDLIR220_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls, DateUtils;

type
  TFrmDLIR220_query = class(TFrmSTDI051)
    rgp: TRadioGroup;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR220_query: TFrmDLIR220_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR220_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�q����:');
  dtp1.Date:=EncodeDate(YearOf(Date),MonthOf(Date),1);
  dtp2.Date:=Date;
end;

procedure TFrmDLIR220_query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�d�߶}�l�������j�_�I����!',48);
    Exit;
  end;

  if Dtp2.Date-Dtp1.Date>30 then
  begin
    ShowMsg('�d�߭S�򤣯�j�_31��!',48);
    Exit;
  end;
 
  inherited;
end;

end.
