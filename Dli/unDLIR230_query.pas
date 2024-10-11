unit unDLIR230_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, ComCtrls, DateUtils;

type
  TFrmDLIR230_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    rgp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR230_query: TFrmDLIR230_query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR230_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�X�f���:');
  rgp.Items.Strings[0]:=CheckLang('�ͯq');
  rgp.Items.Strings[1]:=CheckLang('�N�w�ͯq');
  rgp.Items.Strings[2]:=CheckLang('���U');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmDLIR230_query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('�d�߶}�l�������j�_�I����!',48);
    Exit;
  end;

//  if Dtp2.Date-Dtp1.Date>30 then
//  begin
//    ShowMsg('�d�߭S�򤣯�j�_31��!',48);
//    Exit;
//  end;

  inherited;
end;

end.
