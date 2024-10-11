unit unDLII030_prn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DB, StdCtrls, ComCtrls, DBCtrls, Mask, ExtCtrls,
  ImgList, Buttons, unGlobal;

type
  TFrmDLII030_prn = class(TFrmSTDI050)
    Label1: TLabel;
    DBEdit1: TDBEdit;
    DS: TDataSource;
    Label2: TLabel;
    DBEdit3: TDBEdit;
    Label3: TLabel;
    DBEdit5: TDBEdit;
    Label5: TLabel;
    DBEdit9: TDBEdit;
    Label7: TLabel;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    Label9: TLabel;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    Label11: TLabel;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    Label13: TLabel;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    Label15: TLabel;
    DBEdit29: TDBEdit;
    Label17: TLabel;
    DBEdit33: TDBEdit;
    Label19: TLabel;
    DBEdit37: TDBEdit;
    Bevel1: TBevel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label33: TLabel;
    DBEdit53: TDBEdit;
    Label4: TLabel;
    Label6: TLabel;
    DBEdit2: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    Label10: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    Bevel2: TBevel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    Label16: TLabel;
    DBEdit15: TDBEdit;
    Label18: TLabel;
    DBEdit16: TDBEdit;
    Label20: TLabel;
    DBEdit19: TDBEdit;
    TabSheet2: TTabSheet;
    RichEdit1: TRichEdit;
    DS2: TDataSource;
    CheckBox1: TCheckBox;
    DBCheckBox1: TDBCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_MsgList:TStrings;
    function FindNumber(SourceStr:WideString; const StartIndex:Integer=1):Double;
    procedure Item_A;
    procedure Item_D1;
    procedure Item_D2;
    procedure Item_E1;
    procedure Item_E2;
    procedure Item_G;
    procedure Item_PP;
    procedure ItemLot;
    function GetLotStdValue(Value, ItemCaption: string;
      var RetL, RetH: Double): Boolean;
    { Private declarations }
  public
    l_SMRec:TSplitMaterialnoPP;
    l_FIFOErr,l_LotErr: string;
    { Public declarations }
  end;

var
  FrmDLII030_prn: TFrmDLII030_prn;

implementation

uses unCommon;

const l_SpecificationSet='�W��n�D���]�w'#13#10;
const l_TestValueSet='���խȥ��]�w'#13#10;
const l_SpecificationNull='�W��n�D����J'#13#10;
const l_TestValueNull='���խȥ���J'#13#10;
const l_Enter=#13#10;

{$R *.dfm}

function TFrmDLII030_prn.FindNumber(SourceStr:WideString;
  const StartIndex:Integer=1):Double;
var
  fstnum:Boolean;
  i,pos1,tmpIndex:Integer;
  tmpResult:WideString;
begin
  fstnum:=False;
  pos1:=0;
  tmpIndex:=StartIndex;
  if tmpIndex<1 then
     tmpIndex:=1;

  for i:=tmpIndex to Length(SourceStr) do
  begin
    if Char(SourceStr[i]) in ['0'..'9','.'] then
    begin
      fstnum:=True;
      if SourceStr[i]='.' then
         pos1:=pos1+1;
      if pos1<2 then
        tmpResult:=tmpResult+SourceStr[i]
      else
        Break;
    end
    else if fstnum then
      Break;
  end;

  if Length(tmpResult)>0 then
  begin
    pos1:=Pos(tmpResult, SourceStr);
    if (pos1>1) and (SourceStr[pos1-1]='-') then
       tmpResult:='-'+tmpResult;
    Result:=StrToFloat(tmpResult);
  end else
    Result:=0;
end;

procedure TFrmDLII030_prn.Item_A;
begin
  if SameText(l_SMRec.Custno,'AM002') and SameText(l_SMRec.M2,'4') and
     SameText(l_SMRec.M4_7,'7628') and SameText(l_SMRec.M8_10,'505') then
  if Pos('7630', DS.DataSet.FieldByName('A').AsString)=0 then
     l_MsgList.Add('�~�W'+l_enter+'ELNA(AM002)�q��PP :IT140 CAF 7628 RC50.5%,���ҩMCOC�n�D���7630 RC50.5%'+l_enter);
end;

procedure TFrmDLII030_prn.Item_D1;
var
  pos1:Integer;
  tmpMsg,str1,str2:string;
  num1,num2,num3:Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('D1').AsString))=0 then
     tmpMsg:=tmpMsg+l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('D11').AsString))=0 then
     tmpMsg:=tmpMsg+l_TestValueSet;

  if Length(tmpMsg)=0 then
  begin
    num1:=StrToFloatDef(Trim(DS.DataSet.FieldByName('D11').AsString), 0);
    if num1<=0 then
       tmpMsg:=tmpMsg+'���խȤ��O���Ī����ƭ�'+l_enter;
    pos1:=Pos('��', DS.DataSet.FieldByName('D1').AsString);
    if pos1=0 then
       tmpMsg:=tmpMsg+'�W��n�D�榡���~(123��x)'+l_enter
    else begin
      str1:=Copy(DS.DataSet.FieldByName('D1').AsString, 1, pos1-1);
      str2:=Copy(DS.DataSet.FieldByName('D1').AsString, pos1+2, 20);
    end;

    if (num1>0) and (pos1>0) then
    begin
      num2:=StrToFloatDef(str1, 0);
      num3:=StrToFloatDef(str2, 0);
      if (num2<=0) or (num3<=0) or (num2<=num3) then
         tmpMsg:=tmpMsg+'�W��n�D�榡���~(123��x)'+l_enter
      else if (num1<num2-num3) or (num1>num2+num3) then
         tmpMsg:=tmpMsg+'���խȤ��b�W��n�D�d��'+l_enter;
    end;
  end;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('�ֺ����c(�g����)'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.Item_D2;
var
  pos1:Integer;
  tmpMsg,str1,str2:string;
  num1,num2,num3:Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('D2').AsString))=0 then
     tmpMsg:=tmpMsg+l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('D21').AsString))=0 then
     tmpMsg:=tmpMsg+l_TestValueSet;

  if Length(tmpMsg)=0 then
  begin
    num1:=StrToFloatDef(Trim(DS.DataSet.FieldByName('D21').AsString), 0);
    if num1<=0 then
       tmpMsg:=tmpMsg+'���խȤ��O���Ī����ƭ�'+l_enter;
    pos1:=Pos('��', DS.DataSet.FieldByName('D2').AsString);
    if pos1=0 then
       tmpMsg:=tmpMsg+'�W��n�D�榡���~(123��x)'+l_enter
    else begin
      str1:=Copy(DS.DataSet.FieldByName('D2').AsString, 1, pos1-1);
      str2:=Copy(DS.DataSet.FieldByName('D2').AsString, pos1+2, 20);
    end;

    if (num1>0) and (pos1>0) then
    begin
      num2:=StrToFloatDef(str1, 0);
      num3:=StrToFloatDef(str2, 0);
      if (num2<=0) or (num3<=0) or (num2<=num3) then
         tmpMsg:=tmpMsg+'�W��n�D�榡���~(123��x)'+l_enter
      else if (num1<num2-num3) or (num1>num2+num3) then
         tmpMsg:=tmpMsg+'���խȤ��b�W��n�D�d��'+l_enter;
    end;
  end;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('�ֺ����c(�n����)'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.Item_E1;
var
  tmpMsg:string;
begin
  if Length(Trim(DS.DataSet.FieldByName('E1').AsString))=0 then
     tmpMsg:=tmpMsg+l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('E11').AsString))=0 then
     tmpMsg:=tmpMsg+l_TestValueSet;

  if (Length(tmpMsg)=0) and
     (StrToFloatDef(Trim(DS.DataSet.FieldByName('E11').AsString), 0)<=0) then
     tmpMsg:=tmpMsg+'���խȤ��O���Ī����ƭ�'+l_enter;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('�ؤo(�g�V)'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.Item_E2;
var
  tmpMsg:string;
begin
  if Length(Trim(DS.DataSet.FieldByName('E2').AsString))=0 then
     tmpMsg:=tmpMsg+l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('E21').AsString))=0 then
     tmpMsg:=tmpMsg+l_TestValueSet;

  if (Length(tmpMsg)=0) and
     (StrToFloatDef(Trim(DS.DataSet.FieldByName('E21').AsString), 0)<=0) then
     tmpMsg:=tmpMsg+'���խȤ��O���Ī����ƭ�'+l_enter;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('�ؤo(�n�V)'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.Item_G;
var
  pos1:Integer;
  tmpMsg,str1,str2:string;
begin
  if Length(Trim(DS.DataSet.FieldByName('G1').AsString))=0 then
     tmpMsg:=tmpMsg+l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('G11').AsString))=0 then
     tmpMsg:=tmpMsg+l_TestValueSet;

  if Length(tmpMsg)>0 then
  begin
    if StrToFloatDef(Trim(DS.DataSet.FieldByName('G11').AsString), 0)<=0 then
       tmpMsg:=tmpMsg+'���խȤ��O���Ī����ƭ�'+l_enter;

    pos1:=Pos('��', DS.DataSet.FieldByName('G1').AsString);
    if pos1=0 then
       tmpMsg:=tmpMsg+'�W��n�D�榡���~(123��x)'+l_enter
    else begin
      str1:=Copy(DS.DataSet.FieldByName('G1').AsString, 1, pos1-1);
      str2:=Copy(DS.DataSet.FieldByName('G1').AsString, pos1+2, 20);
      if StrToFloatDef(str1, 0)<=0 then
         tmpMsg:=tmpMsg+'�W��n�D[����]���O���Ī����ƭ�'+l_enter;
      if StrToFloatDef(str2, 0)<=0 then
         tmpMsg:=tmpMsg+'�W��n�D[�~�t��]���O���Ī����ƭ�'+l_enter;
    end;
  end;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('��'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.Item_PP;
var
  str1,str2:string;
begin
  str1:=DS.DataSet.FieldByName('PP_Sizes').AsString;
  str2:=DS.DataSet.FieldByName('PP').AsString;
  if Length(str1)>0 then
  begin
    if str1<>str2 then
       l_MsgList.Add('����'+l_enter+'�Ȥ�~�W���w�����O'+str1+', �帹�����O'+str2+l_enter);
  end else
  if Length(DS.DataSet.FieldByName('PPErr').AsString)>0 then
     l_MsgList.Add('�������w'+l_enter+'�n�D�O:'+DS.DataSet.FieldByName('PPErr').AsString+l_enter);
end;

function TFrmDLII030_prn.GetLotStdValue(Value, ItemCaption:string;
  var RetL, RetH:Double):Boolean;
var
  pos1:Integer;
  tmpMsg:string;
  num1,num2:Double;
begin
  RetL:=0;
  RetH:=0;
  pos1:=Pos('��', Value);
  if pos1=0 then
     tmpMsg:=tmpMsg+ItemCaption+'�W��n�D�榡���~(123��x)'+l_enter
  else begin
    num1:=StrToFloatDef(Copy(Value, 1, pos1-1), 0);
    num2:=StrToFloatDef(Copy(Value, pos1+2, 20), 0);
    if num1<=0 then
       tmpMsg:=tmpMsg+ItemCaption+'�W��n�D[����]���O���Ī����ƭ�'+l_enter;
    if num2<=0 then
       tmpMsg:=tmpMsg+ItemCaption+'�W��n�D[�~�t��]���O���Ī����ƭ�'+l_enter;
    if (num1>0) and (num2>0) and (num1<=num2) then
       tmpMsg:=tmpMsg+ItemCaption+'�W��n�D�榡���~(123��x)'+l_enter;

    if Length(tmpMsg)=0 then
    begin
      RetL:=num1-num2;
      RetH:=num1+num2;
    end;
  end;

  Result:=Length(tmpMsg)=0;
  if not Result then
     l_MsgList.Add(ItemCaption+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.ItemLot;
var
  tmpMsg,strLot:string;
  numRC_L,numRC_H,
  numRF_L,numRF_H,
  numPG_L,numPG_H,
  numSF_L,numSF_H,
  numVC,tmpNum:Double;
  Ret1,Ret2,Ret3,Ret4,RetSF,RetRF:Boolean;
begin
  RetSF:=SameText(l_SMRec.Custno,'AC109') and (Length(DS.DataSet.FieldByName('F1').AsString)>0);
  RetRF:=Pos('�Ѧ�', DS.DataSet.FieldByName('G').AsString)=0;

  Ret1:=GetLotStdValue(DS.DataSet.FieldByName('F').AsString, 'RC', numRC_L, numRC_H);
  if RetRF then
     Ret2:=GetLotStdValue(DS.DataSet.FieldByName('G').AsString, 'RF', numRF_L, numRF_H)
  else
     Ret2:=True;
  Ret3:=GetLotStdValue(DS.DataSet.FieldByName('H').AsString, 'PG', numPG_L, numPG_H);
  if RetSF then
     Ret4:=GetLotStdValue(DS.DataSet.FieldByName('F1').AsString, 'AC109 SF', numSF_L, numSF_H)
  else
     Ret4:=True;
  numVC:=FindNumber(DS.DataSet.FieldByName('I').AsString);

  if (not Ret1) or (not Ret2) or (not Ret3) or (numVC<=0) then
  begin
    if numVC<=0 then
       l_MsgList.Add('VC'+l_enter+'�W��n�D���O���Ī����ƭ�'+l_enter);
    Exit;
  end;

  if RetSF and (not Ret4) then
     Exit;

  with DS2.DataSet do
  begin
    First;
    while not Eof do
    begin
      strLot:=FieldByName('lot1').AsString;

      tmpNum:=StrToFloatDef(FieldByName('rc').AsString, 0);
      if tmpNum<=0 then
         tmpMsg:=tmpMsg+strLot+' RC���O���Ī����ƭ�'+l_enter
      else if (tmpNum<numRC_L) or (tmpNum>numRC_H) then
         tmpMsg:=tmpMsg+strLot+' RC���b�W��n�D�d��'+l_enter;

      if RetRF then
      begin
        tmpNum:=StrToFloatDef(FieldByName('rf').AsString, 0);
        if tmpNum<=0 then
           tmpMsg:=tmpMsg+strLot+' RF���O���Ī����ƭ�'+l_enter
        else if (tmpNum<numRF_L) or (tmpNum>numRF_H) then
           tmpMsg:=tmpMsg+strLot+' RF���b�W��n�D�d��'+l_enter;
      end;

      tmpNum:=StrToFloatDef(FieldByName('pg').AsString, 0);
      if tmpNum<=0 then
         tmpMsg:=tmpMsg+strLot+' PG���O���Ī����ƭ�'+l_enter
      else if (tmpNum<numPG_L) or (tmpNum>numPG_H) then
         tmpMsg:=tmpMsg+strLot+' PG���b�W��n�D�d��'+l_enter;

      tmpNum:=StrToFloatDef(FieldByName('vc').AsString, 0);
      if tmpNum<=0 then
         tmpMsg:=tmpMsg+strLot+' VC���O���Ī����ƭ�'+l_enter
      else if tmpNum>numVC then
         tmpMsg:=tmpMsg+strLot+' VC���b�W��n�D�d��'+l_enter;

      if RetSF then
      begin
        tmpNum:=StrToFloatDef(FieldByName('sf').AsString, 0);
        if tmpNum<=0 then
           tmpMsg:=tmpMsg+strLot+' SF���O���Ī����ƭ�'+l_enter
        else if (tmpNum<numSF_L) or (tmpNum>numSF_H) then
           tmpMsg:=tmpMsg+strLot+' SF���b�W��n�D�d��'+l_enter;
      end;

      Next;
    end;
  end;

  if Length(tmpMsg)>0 then
     l_MsgList.Add('�S�ʭ�'+l_enter+tmpMsg);
end;

procedure TFrmDLII030_prn.FormCreate(Sender: TObject);
begin
  inherited;
  l_MsgList:=TStringList.Create;

  TabSheet2.Caption:=CheckLang('���~�H��');
  CheckBox1.Caption:=CheckLang('�ˬd���~');
  CheckBox2.Caption:=CheckLang('�ˬd���i���X');
  CheckBox3.Caption:=CheckLang('�ˬd����帹');
  DBCheckBox1.Caption:=CheckLang('�q�l�L��');

  Label21.Caption:=CheckLang('���ն���');
  Label22.Caption:=CheckLang('�W��n�D');
  Label23.Caption:=CheckLang('���խ�');
  Label24.Caption:=Label21.Caption;
  Label25.Caption:=Label22.Caption;
  Label26.Caption:=Label23.Caption;
  Label33.Caption:=CheckLang('���s���G');

  Label1.Caption:=CheckLang('�~�W�G');
  Label3.Caption:=CheckLang('�ؤo�G');
  Label4.Caption:=CheckLang('��t�q�G');
  Label6.Caption:=CheckLang('�ͧt�q�G');
  Label5.Caption:=CheckLang('�ƶq�G');
  Label7.Caption:=CheckLang('�g���ơG');
  Label9.Caption:=CheckLang('�n���ơG');
  Label11.Caption:=CheckLang('�ؤo(�g)�G');
  Label13.Caption:=CheckLang('�ؤo(�n)�G');
  Label15.Caption:=CheckLang('��קt�qR/C�G');
  Label17.Caption:=CheckLang('��׬y�qR/F�G');
  Label19.Caption:=CheckLang('���׮ɶ�P/G�G');
  Label2.Caption:=CheckLang('���o��V/C�G');
  Label10.Caption:=CheckLang('�����G');
  Label12.Caption:=CheckLang('��סG');
  Label14.Caption:=CheckLang('RC-CPK�G');
  Label8.Caption:=CheckLang('RF-CPK�G');
  Label16.Caption:=CheckLang('GT-CPK�G');
  Label18.Caption:=CheckLang('�q�渹�X�G');
  Label20.Caption:=CheckLang('�Ȥ�q�渹�X�G');

  if SameText(g_UInfo^.BU,'ITEQDG') then
  begin
    DBCheckBox1.Visible:=SameText(g_UInfo^.UserId,'ID110256') or  //�B��
                         SameText(g_UInfo^.UserId,'ID130251') or  //�J����
                         SameText(g_UInfo^.UserId,'ID140139') or  //������
                         SameText(g_UInfo^.UserId,'admin');
    CheckBox1.Visible:=DBCheckBox1.Visible;
    CheckBox2.Visible:=DBCheckBox1.Visible;
    CheckBox3.Visible:=DBCheckBox1.Visible;
  end;
end;

procedure TFrmDLII030_prn.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_MsgList);
end;

procedure TFrmDLII030_prn.btn_okClick(Sender: TObject);
var
  i,tmpLine:Integer;
begin
  if CheckBox1.Checked then
  begin
    RichEdit1.Clear;
    l_MsgList.Clear;
    Item_A;     //�~�W
    Item_D1;    //�ֺ����c(�g����)
    Item_D2;    //�ֺ����c(�n����)
    Item_E1;    //�ؤo(�g�V)
    Item_E2;    //�ؤo(�n�V)
    if Pos(l_SMRec.Custno,'AC084/AC148/AC347')>0 then
       Item_G;  //��
    Item_PP;    //����   
    ItemLot;    //�帹rc�Brf�Bpg�Bvc�S�ʭ�

    if CheckBox2.Checked and (Length(l_FIFOErr)>0) then
       l_MsgList.Add('���i���X'+l_enter+l_FIFOErr+l_enter);
    if CheckBox3.Checked and (Length(l_LotErr)>0) then
       l_MsgList.Add('����PCOC�帹���۲�'+l_enter+l_LotErr+l_enter);

    RichEdit1.Lines.AddStrings(l_MsgList);
    if RichEdit1.Lines.Count>0 then
    begin
      RichEdit1.SelStart:=0;
      RichEdit1.SelLength:=Length(RichEdit1.Lines.Strings[0]);
      RichEdit1.SelAttributes.Color:=clRed;
    end;

    for i:=1 to RichEdit1.Lines.Count -2 do
    begin
      if Length(Trim(RichEdit1.Lines.Strings[i]))=0 then
      begin
        tmpLine:=SendMessage(RichEdit1.Handle, EM_LINEINDEX, i+1, 0);
        RichEdit1.SelStart:=tmpLine;
        RichEdit1.SelLength:=Length(RichEdit1.Lines.Strings[i+1]);
        RichEdit1.SelAttributes.Color:=clRed;
      end;
    end;

    if Length(Trim(RichEdit1.Text))>0 then
    begin
      RichEdit1.Text:=CheckLang(RichEdit1.Text);
      PCL.ActivePageIndex:=1;
      Exit;
    end;
  end;

  inherited;
end;

end.
