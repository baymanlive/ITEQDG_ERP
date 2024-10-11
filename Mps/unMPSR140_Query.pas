unit unMPSR140_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ComCtrls, Buttons, ImgList;

type
  TFrmMPSR140_Query = class(TFrmSTDI051)
    lblorderdate: TLabel;
    dtp1: TDateTimePicker;
    lblto: TLabel;
    dtp2: TDateTimePicker;
    rgp1: TRadioGroup;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    btn_sp: TSpeedButton;
    btn_sp1: TSpeedButton;
    rgp2: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
    procedure btn_sp1Click(Sender: TObject);
  private
    { Private declarations }
  public
    l_ret:string;
    { Public declarations }
  end;

var
  FrmMPSR140_Query: TFrmMPSR140_Query;

implementation

uses unGlobal, unCommon, unMPSR140, unMPSR140_PGroup, unMPSR140_AD;

{$R *.dfm}

procedure TFrmMPSR140_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date-2;
  Dtp2.Date:=Date;
  btn_sp1.Caption:=btn_sp.Caption;
end;

procedure TFrmMPSR140_Query.btn_okClick(Sender: TObject);
begin
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('起始日期不能大於截止日期',48);
    dtp1.SetFocus;
    Exit;
  end;

  l_ret:=' and to_char(oea02,''YYYY/MM/DD'') between '+Quotedstr(FormatDateTime(g_cShortDate1, Dtp1.Date))
        +' and '+Quotedstr(FormatDateTime(g_cShortDate1, Dtp2.Date));
  l_ret:=StringReplace(l_ret,'-','/',[rfReplaceAll]);
  if rgp1.ItemIndex<>2 then
     l_ret:=l_ret+' and ptype='+Quotedstr(rgp1.Items[rgp1.ItemIndex]);
  if Length(Trim(Edit2.Text))>0 then
     l_ret:=l_ret+' and instr('+Quotedstr(UpperCase(','+StringReplace(Trim(Edit2.Text),'，',',',[rfReplaceAll])+','))+',concat('','',concat(ad,'','')))>0';

  inherited;
end;

procedure TFrmMPSR140_Query.btn_spClick(Sender: TObject);
begin
  inherited;
  FrmMPSR140_PGroup:=TFrmMPSR140_PGroup.Create(nil);
  try
    FrmMPSR140_PGroup.ShowData;
    if FrmMPSR140_PGroup.ShowModal=mrOK then
       Edit1.Text:=FrmMPSR140_PGroup.l_ret;
  finally
    FreeAndNil(FrmMPSR140_PGroup);
  end;
end;

procedure TFrmMPSR140_Query.btn_sp1Click(Sender: TObject);
begin
  inherited;
  FrmMPSR140_AD:=TFrmMPSR140_AD.Create(nil);
  try
    FrmMPSR140_AD.ShowData;
    if FrmMPSR140_AD.ShowModal=mrOK then
       Edit2.Text:=FrmMPSR140_AD.l_ret;
  finally
    FreeAndNil(FrmMPSR140_AD);
  end;
end;

end.
