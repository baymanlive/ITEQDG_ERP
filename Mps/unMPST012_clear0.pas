unit unMPST012_clear0;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls, Mask,
  DBCtrlsEh;

type
  TFrmMPST012_clear0 = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Cbb: TDBComboBoxEh;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST012_clear0: TFrmMPST012_clear0;

implementation

uses unGlobal, unCommon, unMPST012_units;

{$R *.dfm}

procedure TFrmMPST012_clear0.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�Ͳ����(�_)�G');
  Label2.Caption:=CheckLang('���G');
  Label3.Caption:=CheckLang('���O�G');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
  Cbb.Items.DelimitedText:=CheckLang(g_MPS012_Stype);
  Cbb.Items.Add(CheckLang('����'));
  Cbb.ItemIndex:=0;
end;

procedure TFrmMPST012_clear0.btn_okClick(Sender: TObject);
var
  tmpIndex:Integer;
  tmpSQL,tmpStr:string;
begin
  //inherited;

  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�Ͳ����(�_)����j��Ͳ����(��)!', 48);
    dtp1.SetFocus;
    Exit;
  end;

  tmpIndex:=Cbb.ItemIndex;
  if tmpIndex=-1 then
  begin
    ShowMsg('�п�����O!', 48);
    Cbb.SetFocus;
    Exit;
  end;

  if ShowMsg('�T�w�M�s��?', 33)=IdCancel then
     Exit;

  tmpSQL:='update mps380 set not_use=1 where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date));
  if tmpIndex<>Cbb.Items.Count-1 then
  begin
    tmpStr:=Cbb.Items.Strings[tmpIndex];
    tmpSQL:=tmpSQL+' and stealno like '+Quotedstr(Copy(tmpStr,1,2)+'%');

    if Pos(CheckLang('��'),tmpStr)>0 then
       tmpSQL:=tmpSQL+' and isnull(thickness,0)=1'
    else if Pos(CheckLang('�p'),tmpStr)>0 then
       tmpSQL:=tmpSQL+' and isnull(thickness,0)=0';
  end;

  if PostBySQL(tmpSQL) then
     ShowMsg('�M�s����!',64);
end;

end.
