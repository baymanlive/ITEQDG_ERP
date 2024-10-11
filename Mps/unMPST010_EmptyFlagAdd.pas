unit unMPST010_EmptyFlagAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

const l_Premark='�w�O�d';

type
  TFrmEmptyFlagAdd = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    Chk: TCheckBox;
    Chk2: TCheckBox;
    Edit2: TEdit;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Label3: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    l_Sdate:Variant;
    l_Machine,l_Stealno:string;
    l_Boiler,l_Adcode,l_Jitem:Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmEmptyFlagAdd: TFrmEmptyFlagAdd;

implementation

uses unGlobal, unCommon, unMPST010, unCustnoGroup;

{$R *.dfm}

procedure TFrmEmptyFlagAdd.btn_okClick(Sender: TObject);
var
  IsExist:Boolean;
  tmpSQL,tmpSimuver,tmpOZ:string;
  tmpBooks:Double;
begin
  if VarIsNull(l_Sdate) then
  begin
    ShowMsg('���x���s�b!', 48);
    Exit;
  end;

  if Chk.Checked then
     tmpBooks:=0
  else
  begin
    try
      tmpBooks:=StrToFloatDef(Edit1.Text, -0.2);
    except
      ShowMsg('�п�J����!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if tmpBooks<0 then
    begin
      ShowMsg('�п�J�Ʀr!', 48);
      Edit1.SetFocus;
      Exit;
    end;
  end;

  tmpSQL:='Select 1 From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Sdate='+Quotedstr(DateToStr(l_Sdate))
         +' And Machine='+Quotedstr(l_Machine)
         +' And CurrentBoiler='+IntToStr(l_Boiler)
         +' And EmptyFlag=1';
  if QueryExists(tmpSQL, IsExist) then
  begin
    if IsExist then
    begin
      ShowMsg('�Ŧ�w�s�b!', 48);
      Exit;
    end;

    //���y����
    tmpSimuver:=GetSno(g_MInfo^.ProcId);
    if tmpSimuver='' then
       Exit;

    with FrmMPST010.CDS do
    begin
      Append;
      FieldByName('Simuver').AsString:=tmpSimuver;
      FieldByName('Citem').AsInteger:=1;
      FieldByName('Jitem').AsInteger:=l_Jitem;
      FieldByName('Sdate').AsDateTime:=l_Sdate;
      FieldByName('Machine').AsString:=l_Machine;
      FieldByName('Stealno').AsString:=l_Stealno;
      FieldByName('CurrentBoiler').AsInteger:=l_Boiler;
      if Chk.Checked then
      begin
        FieldByName('Adcode').AsInteger:=0;
        FieldByName('RemainBooks').AsFloat:=0;
        FieldByName('OZ').AsString:=g_OZ;
      end else
      begin
        FieldByName('Adcode').AsInteger:=l_Adcode;
        FieldByName('RemainBooks').AsFloat:=tmpBooks;
        //���ɺ�
        if not GetMPSEmptyOZ(IntToStr(l_Jitem), '', tmpOZ) then
        begin
          Cancel;
          Locate('Jitem', l_Jitem, []);
          Exit;
        end;
        FieldByName('OZ').AsString:=g_OZ+tmpOZ;
      end;
      FieldByName('EmptyFlag').AsInteger:=1;
      FieldByName('Lock').AsBoolean:=Self.Chk2.Checked;
      if FieldByName('Lock').AsBoolean then
      begin
        if Length(Trim(Self.Edit2.Text))>0 then
           FieldByName('Premark').AsString:=CheckLang(l_Premark+Trim(Self.Edit2.Text))
        else
           FieldByName('Premark').AsString:=CheckLang(l_Premark);
      end;

      FieldByName('BU').AsString:=g_UInfo^.BU;
      FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      FieldByName('Idate').AsDateTime:=Now;
      FieldByName('ErrorFlag').AsInteger:=0;
      FieldByName('Case_ans1').AsBoolean:=False;
      FieldByName('Case_ans2').AsBoolean:=False;
      FieldByName('Move_ans').AsBoolean:=False;
      Post;
    end;

    if not CDSPost(FrmMPST010.CDS, 'MPS010') then
    if FrmMPST010.CDS.ChangeCount>0 then
    begin
      FrmMPST010.CDS.CancelUpdates;
      Exit;
    end;
  end;

  inherited;
end;

procedure TFrmEmptyFlagAdd.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�W�[���ơG');
  Label2.Caption:=CheckLang('�O�d�禸���Ȥ�G');
  Label3.Caption:=CheckLang('�Y���籡�p�U,�п襤[�M���X��N�X],���ƥi���ο�J');
  Chk.Caption:=CheckLang('�M���X��N�X');
  Chk2.Caption:=CheckLang('�O�d�禸');
  BitBtn1.Caption:=CheckLang('���');
end;

procedure TFrmEmptyFlagAdd.FormShow(Sender: TObject);
begin
  inherited;
  with FrmMPST010 do
  if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  begin
    Self.l_Sdate:=CDS.FieldByName('Sdate').AsDateTime;
    Self.l_Machine:=CDS.FieldByName('Machine').AsString;
    Self.l_Stealno:=CDS.FieldByName('Stealno').AsString;
    Self.l_Boiler:=CDS.FieldByName('CurrentBoiler').AsInteger;
    Self.l_Adcode:=CDS.FieldByName('Adcode').AsInteger;
    Self.l_Jitem:=CDS.FieldByName('Jitem').AsInteger;
  end else
    Self.l_Sdate:=null;

  if not VarIsNull(l_Sdate) then
  begin
    Memo1.Lines.Clear;
    Memo1.Lines.Add(CheckLang('���x�G')+l_Machine);
    Memo1.Lines.Add(CheckLang('����G')+DateToStr(l_Sdate));
    Memo1.Lines.Add(CheckLang('���O�G')+l_Stealno);
    Memo1.Lines.Add(CheckLang('�禸�G')+IntToStr(l_Boiler));
    Memo1.Lines.Add(CheckLang('�X��N�X�G')+IntToStr(l_Adcode));
  end;
end;

procedure TFrmEmptyFlagAdd.BitBtn1Click(Sender: TObject);
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
