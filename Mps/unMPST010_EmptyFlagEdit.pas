unit unMPST010_EmptyFlagEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

const l_Premark='已保留';

type
  TFrmEmptyFlagEdit = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Chk: TCheckBox;
    Chk2: TCheckBox;
    Label2: TLabel;
    Edit2: TEdit;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmEmptyFlagEdit: TFrmEmptyFlagEdit;

implementation

uses unGlobal, unCommon, unMPST010, unCustnoGroup;

{$R *.dfm}

procedure TFrmEmptyFlagEdit.btn_okClick(Sender: TObject);
var
  tmpBooks:Double;
begin
  if not Chk.Checked then
  begin
    try
      tmpBooks:=StrToFloatDef(Edit1.Text, -0.2);
    except
      ShowMsg('請輸入本數!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if tmpBooks<0 then
    begin
      ShowMsg('請輸入數字!', 48);
      Edit1.SetFocus;
      Exit;
    end;
  end;

  with FrmMPST010.CDS do
  begin
    Edit;
    if Self.Chk.Checked then
    begin
      FieldByName('Adcode').AsInteger:=0;
      FieldByName('RemainBooks').AsFloat:=0;
      FieldByName('OZ').AsString:=g_OZ;
    end else
      FieldByName('RemainBooks').AsFloat:=StrToFloat(Self.Edit1.Text); //是否要恢復Adcode&OZ ?
    FieldByName('Lock').AsBoolean:=Self.Chk2.Checked;
    if FieldByName('Lock').AsBoolean then
    begin
      if Length(Trim(Self.Edit2.Text))>0 then
         FieldByName('Premark').AsString:=CheckLang(l_Premark+Trim(Self.Edit2.Text))
      else
         FieldByName('Premark').AsString:=CheckLang(l_Premark);
    end else
       FieldByName('Premark').Clear;
    Post;
  end;

  if not CDSPost(FrmMPST010.CDS, 'MPS010') then
  if FrmMPST010.CDS.ChangeCount>0 then
  begin
    FrmMPST010.CDS.CancelUpdates;
    Exit;
  end;

  inherited;
end;

procedure TFrmEmptyFlagEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('更改本數：');
  Label2.Caption:=CheckLang('保留鍋次給客戶：');
  Label3.Caption:=CheckLang('若空鍋情況下,請選中[清除合鍋代碼],本數可不用輸入');
  Chk.Caption:=CheckLang('清除合鍋代碼');
  Chk2.Caption:=CheckLang('保留鍋次');
  BitBtn1.Caption:=CheckLang('選擇');
end;

procedure TFrmEmptyFlagEdit.FormShow(Sender: TObject);
begin
  inherited;
  with FrmMPST010.CDS do
  begin
    Self.Memo1.Lines.Clear;
    Self.Memo1.Lines.Add(CheckLang('機台：')+FieldByName('Machine').AsString);
    Self.Memo1.Lines.Add(CheckLang('日期：')+DateToStr(FieldByName('Sdate').AsDateTime));
    Self.Memo1.Lines.Add(CheckLang('鋼板：')+FieldByName('Stealno').AsString);
    Self.Memo1.Lines.Add(CheckLang('鍋次：')+IntToStr(FieldByName('CurrentBoiler').AsInteger));
    Self.Memo1.Lines.Add(CheckLang('合鍋代碼：')+IntToStr(FieldByName('Adcode').AsInteger));
    Self.Edit1.Text:=FloatToStr(FieldByName('RemainBooks').AsFloat);
    Self.Chk2.Checked:=FieldByName('Lock').AsBoolean;
    if Self.Chk2.Checked then
       Self.Edit2.Text:=StringReplace(FieldByName('Premark').AsString,l_Premark,'',[]);
  end;
end;

procedure TFrmEmptyFlagEdit.BitBtn1Click(Sender: TObject);
begin
  inherited;
  FrmCustnoGroup:=TFrmCustnoGroup.Create(nil);
  try
    FrmCustnoGroup.ShowData;
    if FrmCustnoGroup.ShowModal=mrOK then
       Edit2.Text:=FrmCustnoGroup.l_ret;
  finally
    FreeAndNil(FrmCustnoGroup);
  end;
end;

end.
