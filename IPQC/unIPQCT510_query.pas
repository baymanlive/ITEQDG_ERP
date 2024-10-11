unit unIPQCT510_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons;

type
  TFrmIPQCT510_query = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    cbb: TComboBox;
    Label3: TLabel;
    rgp: TRadioGroup;
    Label4: TLabel;
    Edit1: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT510_query: TFrmIPQCT510_query;

implementation

uses unGlobal, unCommon, unIPQCT510_units;

{$R *.dfm}

procedure TFrmIPQCT510_query.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  label1.Caption:=CheckLang('起始日期：');
  label2.Caption:=CheckLang('截止日期：');
  label3.Caption:=CheckLang('項目：');
  label4.Caption:=CheckLang('工單號碼：');
  rgp.Items.Clear;
  cbb.Items.Clear;
  for i:=Low(g_ArrMachine) to High(g_ArrMachine) do
    rgp.Items.Add(g_ArrMachine[i].Machine);
  for i:=Low(g_ArrMachine[0].ArrObj) to High(g_ArrMachine[0].ArrObj) do
    cbb.Items.Add(g_ArrMachine[0].ArrObj[i].Name);
  rgp.Columns:=rgp.Items.Count;
  rgp.ItemIndex:=0;
  cbb.ItemIndex:=0;
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmIPQCT510_query.btn_okClick(Sender: TObject);
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('起始日期不能大於截止日期',48);
    dtp2.SetFocus;
    Exit;
  end;

  if Dtp2.Date-Dtp1.Date>=3 then
  begin
    ShowMsg('日期區間不能大於3天',48);
    dtp2.SetFocus;
    Exit;
  end;

  inherited;
end;

end.
