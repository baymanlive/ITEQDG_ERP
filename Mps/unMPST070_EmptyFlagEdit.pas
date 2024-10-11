unit unMPST070_EmptyFlagEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST070_EmptyFlagEdit = class(TFrmSTDI051)
    Label3: TLabel;
    Edit3: TEdit;
    Chk: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_Sdate:Variant;
    l_Machine:string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_EmptyFlagEdit: TFrmMPST070_EmptyFlagEdit;

implementation

uses unGlobal, unCommon, unMPST070;

{$R *.dfm}

procedure TFrmMPST070_EmptyFlagEdit.btn_okClick(Sender: TObject);
var
  tmpTimes:Integer;
begin
  if VarIsNull(l_Sdate) then
  begin
    ShowMsg('機台不存在!', 48);
    Exit;
  end;

  try
    tmpTimes:=StrToIntDef(Edit3.Text, -1);
  except
    ShowMsg('請輸入'+Label3.Caption, 48);
    Edit3.SetFocus;
    Exit;
  end;

  if tmpTimes<0 then
  begin
    ShowMsg('請輸入數字!', 48);
    Edit3.SetFocus;
    Exit;
  end;

  with FrmMPST070.CDS do
  begin
    Edit;
    FieldByName('RemainCapacity').AsInteger:=tmpTimes;
    FieldByName('Lock').AsBoolean:=Self.Chk.Checked;
    if FieldByName('Lock').AsBoolean then
       FieldByName('Premark').AsString:=CheckLang('已保留')
    else
       FieldByName('Premark').Clear;
    if Length(Trim(Edit4.Text))>0 then
       FieldByName('Premark').AsString:=FieldByName('Premark').AsString+Trim(Edit4.Text);
    Post;
  end;

  if not CDSPost(FrmMPST070.CDS, 'MPS070') then
  if FrmMPST070.CDS.ChangeCount>0 then
  begin
    FrmMPST070.CDS.CancelUpdates;
    Exit;
  end;

  inherited;
end;

procedure TFrmMPST070_EmptyFlagEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('機台：');
  Label2.Caption:=CheckLang('生產日期：');
  Label3.Caption:=CheckLang('時間產能(分鐘)：');
  Label4.Caption:=CheckLang('生管特別備註：');
  Label5.Caption:=CheckLang('時間產能(分鐘)：輸入0,則以參數設定的產能為準');
  Chk.Caption:=CheckLang('保留');
end;

procedure TFrmMPST070_EmptyFlagEdit.FormShow(Sender: TObject);
begin
  inherited;
  with FrmMPST070 do
  if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  begin
    Self.l_Sdate:=CDS.FieldByName('Sdate').AsDateTime;
    Self.l_Machine:=CDS.FieldByName('Machine').AsString;
  end else
    Self.l_Sdate:=null;

  if not VarIsNull(l_Sdate) then
  begin
    Edit1.Text:=l_Machine;
    Edit2.Text:=DateToStr(l_Sdate);
    Edit3.Text:=IntToStr(FrmMPST070.CDS.FieldByName('RemainCapacity').AsInteger);
    Chk.Checked :=FrmMPST070.CDS.FieldByName('Lock').AsBoolean;
  end;
end;

end.
