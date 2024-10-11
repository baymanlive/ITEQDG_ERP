unit unDLIT801_query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmDLIT801_query = class(TFrmSTDI051)
    Label1: TLabel;
    Label2: TLabel;
    dtp: TDateTimePicker;
    Edit1: TEdit;
    btn_sp: TSpeedButton;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT801_query: TFrmDLIT801_query;

implementation

uses unCommon, unDLIT801_fdate, unDLIT801_area;

{$R *.dfm}

procedure TFrmDLIT801_query.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�L�I����G');
  Label2.Caption:=CheckLang('�x��G');
  Label3.Caption:=CheckLang('�ܮw�G');
  Label4.Caption:=CheckLang('�Y�p�⦳�b�L�ꪫ���,���ݿ�J�ܮw');
  Label5.Caption:=CheckLang('�h�ӭܮw�Шϥγr��(,)�j�}');
  SpeedButton1.Caption:=btn_sp.Caption;
  dtp.Date:=Date;
end;

procedure TFrmDLIT801_query.btn_spClick(Sender: TObject);
begin
  inherited;
  FrmDLIT801_fdate:=TFrmDLIT801_fdate.Create(nil);
  try
    if FrmDLIT801_fdate.ShowModal=mrOK then
    if not FrmDLIT801_fdate.CDS.IsEmpty then
       dtp.Date:=FrmDLIT801_fdate.CDS.FieldByName('fdate').AsDateTime;
  finally
    FreeAndNil(FrmDLIT801_fdate);
  end;
end;

procedure TFrmDLIT801_query.SpeedButton1Click(Sender: TObject);
begin
  inherited;
  FrmDLIT801_area:=TFrmDLIT801_area.Create(nil);
  try
    FrmDLIT801_area.l_fdate:=dtp.Date;
    if FrmDLIT801_area.ShowModal=mrOK then
    if not FrmDLIT801_area.CDS.IsEmpty then
       Edit1.Text:=FrmDLIT801_area.CDS.FieldByName('area').AsString;
  finally
    FreeAndNil(FrmDLIT801_area);
  end;
end;

procedure TFrmDLIT801_query.btn_okClick(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('�п�J�x��!',48);
    Exit;
  end;
  
  inherited;
end;

end.
