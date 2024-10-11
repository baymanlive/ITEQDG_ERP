unit unMPST070_EmptyFlagAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmMPST070_EmptyFlagAdd = class(TFrmSTDI051)
    Label3: TLabel;
    Edit3: TEdit;
    Chk: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
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
  FrmMPST070_EmptyFlagAdd: TFrmMPST070_EmptyFlagAdd;

implementation

uses unGlobal, unCommon, unMPST070;

{$R *.dfm}

procedure TFrmMPST070_EmptyFlagAdd.btn_okClick(Sender: TObject);
var
  IsExist:Boolean;
  tmpSQL,tmpSimuver:string;
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

  tmpSQL:='Select 1 From MPS070 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Sdate='+Quotedstr(DateToStr(l_Sdate))
         +' And Machine='+Quotedstr(l_Machine)
         +' And EmptyFlag=1';
  if QueryExists(tmpSQL, IsExist) then
  begin
    if IsExist then
    begin
      ShowMsg('空行已存在!', 48);
      Exit;
    end;

    //取流水號
    tmpSimuver:=GetSno(g_MInfo^.ProcId);
    if tmpSimuver='' then
       Exit;

    with FrmMPST070.CDS do
    begin
      Append;
      FieldByName('Simuver').AsString:=tmpSimuver;
      FieldByName('Citem').AsInteger:=1;
      FieldByName('Jitem').AsInteger:=g_Jitem;
      FieldByName('Sdate').AsDateTime:=l_Sdate;
      FieldByName('Machine').AsString:=l_Machine;
      FieldByName('RemainCapacity').AsInteger:=tmpTimes;
      FieldByName('AD').AsString:=g_OZ;
      FieldByName('EmptyFlag').AsInteger:=1;
      FieldByName('Lock').AsBoolean:=Self.Chk.Checked;
      if FieldByName('Lock').AsBoolean then
         FieldByName('Premark').AsString:=CheckLang('已保留');
      FieldByName('BU').AsString:=g_UInfo^.BU;
      FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      FieldByName('Idate').AsDateTime:=Now;
      FieldByName('ErrorFlag').AsInteger:=0;
      FieldByName('Case_ans1').AsBoolean:=False;
      FieldByName('Case_ans2').AsBoolean:=False;
      Post;
    end;

    if not CDSPost(FrmMPST070.CDS, 'MPS070') then
    if FrmMPST070.CDS.ChangeCount>0 then
    begin
      FrmMPST070.CDS.CancelUpdates;
      Exit;
    end;
  end;

  inherited;
end;

procedure TFrmMPST070_EmptyFlagAdd.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('機台：');
  Label2.Caption:=CheckLang('生產日期：');
  Label3.Caption:=CheckLang('時間產能(分鐘)：');
  Label4.Caption:=CheckLang('時間產能(分鐘)：輸入0,則以參數設定的產能為準');
  Chk.Caption:=CheckLang('保留');
end;

procedure TFrmMPST070_EmptyFlagAdd.FormShow(Sender: TObject);
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
  end;
  Edit3.SetFocus;
end;

end.
