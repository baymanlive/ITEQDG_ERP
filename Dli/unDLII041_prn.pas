unit unDLII041_prn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DB, StdCtrls, ComCtrls, DBCtrls, Mask, ExtCtrls, ImgList,
  Buttons, unGlobal;

type
  TFrmDLII041_prn = class(TFrmSTDI050)
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
    DBEdit20: TDBEdit;
    Label27: TLabel;
    Label28: TLabel;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    DBEdit66: TDBEdit;
    Label43: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    l_is968, l_is958G, l_isBM: Boolean;
    l_MsgList: TStrings;
    function FindNumber(SourceStr: WideString; const StartIndex: Integer = 1): Double;
    procedure Item_A;
    procedure Item_D1;
    procedure Item_D2;
    procedure Item_E1;
    procedure Item_E2;
    procedure Item_G;
    procedure Item_G_AC111;
    procedure Item_PP;
    procedure ItemLot;
    procedure Item_Oth;
    procedure Item_GT(custno:string);
    procedure Item_PV;
    function GetLotStdValue(Value, ItemCaption: string; var RetL, RetH: Double): Boolean;
    { Private declarations }
  public
    l_SMRec: TSplitMaterialnoPP;
    l_FIFOErr, l_LotErr: string;
    { Public declarations }
  end;

var
  FrmDLII041_prn: TFrmDLII041_prn;


implementation

uses
  unCommon, unFrmWarn;

const
  l_SpecificationSet = '�W��n�D���]�w'#13#10;


const
  l_TestValueSet = '���խȥ��]�w'#13#10;


const
  l_SpecificationNull = '�W��n�D����J'#13#10;


const
  l_TestValueNull = '���խȥ���J'#13#10;


const
  l_Enter = #13#10;

{$R *.dfm}

procedure Warn(msg: string; backGroundColor: TColor=clRed);
begin
  WarnFrm := TWarnFrm.Create(nil);
  try
    WarnFrm.Label1.Caption := msg;
    WarnFrm.Color := backGroundColor;
    WarnFrm.ShowModal;
  finally
    WarnFrm.free;
  end;
end;

function TFrmDLII041_prn.FindNumber(SourceStr: WideString; const StartIndex: Integer = 1): Double;
var
  fstnum: Boolean;
  i, pos1, tmpIndex: Integer;
  tmpResult: WideString;
begin
  fstnum := False;
  pos1 := 0;
  tmpIndex := StartIndex;
  if tmpIndex < 1 then
    tmpIndex := 1;

  for i := tmpIndex to Length(SourceStr) do
  begin
    if Char(SourceStr[i]) in ['0'..'9', '.'] then
    begin
      fstnum := True;
      if SourceStr[i] = '.' then
        pos1 := pos1 + 1;
      if pos1 < 2 then
        tmpResult := tmpResult + SourceStr[i]
      else
        Break;
    end
    else if fstnum then
      Break;
  end;

  if Length(tmpResult) > 0 then
  begin
    pos1 := Pos(tmpResult, SourceStr);
    if (pos1 > 1) and (SourceStr[pos1 - 1] = '-') then
      tmpResult := '-' + tmpResult;
    Result := StrToFloat(tmpResult);
  end
  else
    Result := 0;
end;

procedure TFrmDLII041_prn.Item_A;
begin
  if SameText(l_SMRec.Custno, 'AM002') and SameText(l_SMRec.M2, '4') and SameText(l_SMRec.M4_7, '7628') and SameText(l_SMRec.M8_10, '505') then
    if Pos('7630', DS.DataSet.FieldByName('A').AsString) = 0 then
      l_MsgList.Add('�~�W' + l_enter + 'ELNA(AM002)�q��PP :IT140 CAF 7628 RC50.5%,���ҩMCOC�n�D���7630 RC50.5%' + l_enter);
end;

procedure TFrmDLII041_prn.Item_D1;
var
  pos1: Integer;
  tmpMsg, str1, str2: string;
  num1, num2, num3: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('D1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('D11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('D11').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
    pos1 := Pos('��', DS.DataSet.FieldByName('D1').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '�W��n�D�榡���~(123��x)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('D1').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('D1').AsString, pos1 + 2, 20);
    end;

    if (num1 > 0) and (pos1 > 0) then
    begin
      num2 := StrToFloatDef(str1, 0);
      num3 := StrToFloatDef(str2, 0);
      if (num2 <= 0) or (num3 <= 0) or (num2 <= num3) then
        tmpMsg := tmpMsg + '�W��n�D�榡���~(123��x)' + l_enter
      else if (num1 < num2 - num3) or (num1 > num2 + num3) then
        tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ֺ����c(�g����)' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_D2;
var
  pos1: Integer;
  tmpMsg, str1, str2: string;
  num1, num2, num3: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('D2').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('D21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('D21').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
    pos1 := Pos('��', DS.DataSet.FieldByName('D2').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '�W��n�D�榡���~(123��x)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('D2').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('D2').AsString, pos1 + 2, 20);
    end;

    if (num1 > 0) and (pos1 > 0) then
    begin
      num2 := StrToFloatDef(str1, 0);
      num3 := StrToFloatDef(str2, 0);
      if (num2 <= 0) or (num3 <= 0) or (num2 <= num3) then
        tmpMsg := tmpMsg + '�W��n�D�榡���~(123��x)' + l_enter
      else if (num1 < num2 - num3) or (num1 > num2 + num3) then
        tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ֺ����c(�n����)' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_E1;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('E1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('E11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and (StrToFloatDef(Trim(DS.DataSet.FieldByName('E11').AsString), 0) <= 0) then
    tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo(�g�V)' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_E2;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('E2').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('E21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and (StrToFloatDef(Trim(DS.DataSet.FieldByName('E21').AsString), 0) <= 0) then
    tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo(�n�V)' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_G;
var
  pos1: Integer;
  tmpMsg, str1, str2: string;
begin
  if (not SameText(l_SMRec.Custno, 'N023'))  then
    if Length(Trim(DS.DataSet.FieldByName('G1').AsString)) = 0 then
      tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('G11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (not SameText(l_SMRec.Custno, 'N023')) and (Length(tmpMsg) = 0) then
  begin
    if StrToFloatDef(Trim(DS.DataSet.FieldByName('G11').AsString), 0) <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter
    else
    begin
      pos1 := Pos('��', DS.DataSet.FieldByName('G1').AsString);
      if pos1 = 0 then
        tmpMsg := tmpMsg + '�W��n�D�榡���~(123��x)' + l_enter
      else
      begin
        str1 := Copy(DS.DataSet.FieldByName('G1').AsString, 1, pos1 - 1);
        str2 := Copy(DS.DataSet.FieldByName('G1').AsString, pos1 + 2, 20);
        if StrToFloatDef(str1, 0) <= 0 then
          tmpMsg := tmpMsg + '�W��n�D[����]���O���Ī��ƭ�' + l_enter;
        if StrToFloatDef(str2, 0) <= 0 then
          tmpMsg := tmpMsg + '�W��n�D[�~�t��]���O���Ī��ƭ�' + l_enter;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('����' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_G_AC111;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('G1').AsString)) = 0 then //G1=G11
    tmpMsg := tmpMsg + l_SpecificationSet;

  if Length(tmpMsg) = 0 then
    if StrToFloatDef(Trim(DS.DataSet.FieldByName('G1').AsString), 0) <= 0 then
      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('����' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_PP;
var
  str1, str2: string;
begin
  str1 := DS.DataSet.FieldByName('PP_Sizes').AsString;
  str2 := DS.DataSet.FieldByName('PP').AsString;
  if Length(str1) > 0 then
  begin
    if str1 <> str2 then
      l_MsgList.Add('����' + l_enter + '�Ȥ�~�W���w�����O:' + str1 + ', �帹�����O:' + str2 + l_enter);
  end
  else if Length(DS.DataSet.FieldByName('PPErr').AsString) > 0 then
    l_MsgList.Add('�������w' + l_enter + '�n�D�O:' + DS.DataSet.FieldByName('PPErr').AsString + l_enter);
end;

function TFrmDLII041_prn.GetLotStdValue(Value, ItemCaption: string; var RetL, RetH: Double): Boolean;
var
  pos1: Integer;
  tmpMsg: string;
  num1, num2: Double;
begin
  RetL := 0;
  RetH := 0;
  pos1 := Pos('��', Value);
  if pos1 = 0 then
    tmpMsg := tmpMsg + ItemCaption + '�W��n�D�榡���~(123��x)' + l_enter
  else
  begin
    num1 := StrToFloatDef(Copy(Value, 1, pos1 - 1), 0);
    num2 := StrToFloatDef(Copy(Value, pos1 + 2, 20), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + ItemCaption + '�W��n�D[����]���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + ItemCaption + '�W��n�D[�~�t��]���O���Ī��ƭ�' + l_enter;
    if (num1 > 0) and (num2 > 0) and (num1 <= num2) then
      tmpMsg := tmpMsg + ItemCaption + '�W��n�D�榡���~(123��x)' + l_enter;

    if Length(tmpMsg) = 0 then
    begin
      RetL := num1 - num2;
      RetH := num1 + num2;
    end;
  end;

  Result := Length(tmpMsg) = 0;
  if not Result then
    l_MsgList.Add(ItemCaption + l_enter + tmpMsg);
end;

{*�ݭn�ˬd
|-------------|-----|-----|-----|-----|------|
|             |  F  |  G  |  H  |  I  |  F1  |
|------------ |-----|-- --|---- |-----|------|
|             |  RC |  RF | PG  |  VC |  SF  |
|-------------|-----|-----|-----|-----|------|
|�W��968/958G |  *  |*(NA)|*(NA)|  *  |      |
|-------------|-----|-----|-----|-----|------|
|�䥦968/958G |  *  |  *  |     |     |      |
|-------------|-----|-----|-----|-----|------|
|859GTA/180GN |  *  |  *  |     |     |      |
|-------------|-----|-----|-----|-----|------|
|AC109        |  *  |  *  |  *  |  *  |  *   |
|-------------|-----|-----|-----|-----|------|
|other        |  *  |  *  |  *  |  *  |      |
|-------------|-----|-----|-----|-----|------|
}
procedure TFrmDLII041_prn.ItemLot;
var
  tmpMsg, strLot, strRF: string;
  numRC_L, numRC_H, numRF_L, numRF_H, numPG_L, numPG_H, numSF_L, numSF_H, numVC, tmpNum: Double;
  isCY, isRC, isRF, isPG, isVC, isSF: Boolean;
begin
  isCY := Pos(l_SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950') > 0; //�W��
  //rc
  isRC := GetLotStdValue(DS.DataSet.FieldByName('F').AsString, 'RC', numRC_L, numRC_H);

  //rf
  strRF := StringReplace(DS.DataSet.FieldByName('G').AsString, '(�ȩw)', '', [rfReplaceAll]);
  strRF := StringReplace(strRF, '�ȩw', '', [rfReplaceAll]);
  isRF := False;
  if Pos('�Ѧ�', strRF) = 0 then
    if not SameText(strRF, 'NA') then
      isRF := GetLotStdValue(strRF, 'RF', numRF_L, numRF_H);

  //pg
  if l_is968 or l_is958G or l_isBM or SameText(l_SMRec.M2, '9') then  //968�B958G�BBM(859GTA�B180GN)���ˬd�A���W�ݤ��ONA�ݭn�ˬd
  begin
    isPG := False;
    if isCY then
      if not SameText(DS.DataSet.FieldByName('H').AsString, 'NA') then
        isPG := True;
  end
  else
    isPG := GetLotStdValue(DS.DataSet.FieldByName('H').AsString, 'PG', numPG_L, numPG_H);

  //vc
  numVC := 0;
  isVC := True;
  if {l_is968 or l_is958G or} l_isBM then
    if not isCY then
      isVC := False;
  if isVC then
  begin
    numVC := FindNumber(DS.DataSet.FieldByName('I').AsString);
    if numVC <= 0 then
    begin
      isVC := False;
      tmpMsg := tmpMsg + 'VC�W��n�D���O���Ī��ƭ�' + l_enter;
    end;
  end;

  //sf
  isSF := SameText(l_SMRec.Custno, 'AC109') and (Length(DS.DataSet.FieldByName('F1').AsString) > 0);
  if isSF then
    isSF := GetLotStdValue(DS.DataSet.FieldByName('F1').AsString, 'AC109 SF', numSF_L, numSF_H);

  with DS2.DataSet do
  begin
    First;
    while not Eof do
    begin
      strLot := FieldByName('lot1').AsString;

      if isRC then
      begin
        tmpNum := StrToFloatDef(FieldByName('rc').AsString, 0);
        if tmpNum <= 0 then
          tmpMsg := tmpMsg + strLot + ' RC���O���Ī��ƭ�' + l_enter
        else if (tmpNum < numRC_L) or (tmpNum > numRC_H) then
          tmpMsg := tmpMsg + strLot + ' RC���b�W��n�D�d��' + l_enter;
      end;

      if isRF then
      begin
        tmpNum := StrToFloatDef(FieldByName('rf').AsString, 0);
        if tmpNum <= 0 then
          tmpMsg := tmpMsg + strLot + ' RF���O���Ī��ƭ�' + l_enter
        else if (tmpNum < numRF_L) or (tmpNum > numRF_H) then
          tmpMsg := tmpMsg + strLot + ' RF���b�W��n�D�d��' + l_enter;
      end;

      if isPG then
      begin
        tmpNum := StrToFloatDef(FieldByName('pg').AsString, 0);
        if tmpNum <= 0 then
          tmpMsg := tmpMsg + strLot + ' PG���O���Ī��ƭ�' + l_enter
        else if (tmpNum < numPG_L) or (tmpNum > numPG_H) then
          tmpMsg := tmpMsg + strLot + ' PG���b�W��n�D�d��' + l_enter;
      end;

      if isVC then
      begin
        tmpNum := StrToFloatDef(FieldByName('vc').AsString, 0);
        if tmpNum <= 0 then
          tmpMsg := tmpMsg + strLot + ' VC���O���Ī��ƭ�' + l_enter
        else if tmpNum > numVC then
          tmpMsg := tmpMsg + strLot + ' VC���b�W��n�D�d��' + l_enter;
      end;

      if isSF then
      begin
        tmpNum := StrToFloatDef(FieldByName('sf').AsString, 0);
        if tmpNum <= 0 then
          tmpMsg := tmpMsg + strLot + ' SF���O���Ī��ƭ�' + l_enter
        else if (tmpNum < numSF_L) or (tmpNum > numSF_H) then
          tmpMsg := tmpMsg + strLot + ' SF���b�W��n�D�d��' + l_enter;
      end;

      Next;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�S�ʭ�' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_GT(custno:string);
var
  tmpMsg: string;
  i:integer;
begin
  tmpMsg:=DS.DataSet.FieldByName('C_Sizes').AsString;
  tmpMsg:=StringReplace(tmpMsg,'�G',':',[rfReplaceAll]);
  tmpMsg:=UpperCase(tmpMsg);
  if (custno='AC084') and (Pos('GT:',tmpMsg)=0) then
    exit;
    
  tmpMsg:='';
  if Length(DS.DataSet.FieldByName('H').AsString) = 0 then
    tmpMsg := 'GT�W��n�D����J' + l_enter;


  if Pos(DS.DataSet.FieldByName('H').AsString, DS.DataSet.FieldByName('C_Sizes').AsString) = 0 then
    tmpMsg := tmpMsg + 'AC394,AC152,AH036,AC084 GT�W��n�D' + DS.DataSet.FieldByName('H').AsString + '�P�Ȥ�~�W�Ƶ�����' + l_enter;


  if Length(tmpMsg) > 0 then
    l_MsgList.Add('GT����' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_PV;
var
  tmpNum: Double;
  tmpMsg: string;
begin
  if Length(DS.DataSet.FieldByName('PV').AsString) = 0 then
    tmpMsg := tmpMsg + '���խȥ���J' + l_enter
  else
  begin
    tmpNum := StrToFloatDef(DS.DataSet.FieldByName('PV').AsString, 0);
    if (tmpNum < 100) or (tmpNum > 700) then
      tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��400��300' + l_enter;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�R�H��' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.Item_Oth;
var
  tmpMsg: string;
begin
  if (DS.DataSet.FieldByName('Resin_visible').AsString = '1') and (Length(Trim(DS.DataSet.FieldByName('Resin').AsString)) = 0) then
    tmpMsg := tmpMsg + '��ץ���J' + l_enter;

  if (DS.DataSet.FieldByName('PP_visible').AsString = '1') and (Length(Trim(DS.DataSet.FieldByName('PP').AsString)) = 0) then
    tmpMsg := tmpMsg + '��������J' + l_enter;

  if Length(Trim(DS.DataSet.FieldByName('fileno').AsString)) = 0 then
    tmpMsg := tmpMsg + '���s������J' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�䥦����' + l_enter + tmpMsg);
end;

procedure TFrmDLII041_prn.FormCreate(Sender: TObject);
begin
  inherited;
  l_MsgList := TStringList.Create;

  TabSheet2.Caption := CheckLang('���~�H��');
  CheckBox1.Caption := CheckLang('�ˬd���~');
  CheckBox2.Caption := CheckLang('�ˬd���i���X');
  CheckBox3.Caption := CheckLang('�ˬd����帹');
  DBCheckBox1.Caption := CheckLang('�q�l�L��');

  Label21.Caption := CheckLang('���ն���');
  Label22.Caption := CheckLang('�W��n�D');
  Label23.Caption := CheckLang('���խ�');
  Label24.Caption := Label21.Caption;
  Label25.Caption := Label22.Caption;
  Label26.Caption := Label23.Caption;
  Label33.Caption := CheckLang('���s���G');

  Label1.Caption := CheckLang('�~�W�G');
  Label3.Caption := CheckLang('�ؤo�G');
  Label4.Caption := CheckLang('��t�q�G');
  Label6.Caption := CheckLang('�ͧt�q�G');
  Label5.Caption := CheckLang('�ƶq�G');
  Label7.Caption := CheckLang('�g���ơG');
  Label9.Caption := CheckLang('�n���ơG');
  Label11.Caption := CheckLang('�ؤo(�g)�G');
  Label13.Caption := CheckLang('�ؤo(�n)�G');
  Label15.Caption := CheckLang('��קt�qR/C�G');
  Label17.Caption := CheckLang('��׬y�qR/F�G');
  Label19.Caption := CheckLang('���׮ɶ�P/G�G');
  Label2.Caption := CheckLang('���o��V/C�G');
  Label10.Caption := CheckLang('�����G');
  Label12.Caption := CheckLang('��סG');
  Label14.Caption := CheckLang('RC-CPK�G');
  Label8.Caption := CheckLang('RF-CPK�G');
  Label16.Caption := CheckLang('GT-CPK�G');
  Label18.Caption := CheckLang('�q�渹�X�G');
  Label20.Caption := CheckLang('�Ȥ�q�渹�X�G');
  Label27.Caption := CheckLang('�R�H�סG');
  Label28.Caption := CheckLang('���򭫡G');
  Label43.Caption := CheckLang('�Ȥ�²�١G');

  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    DBCheckBox1.Visible := SameText(g_UInfo^.UserId, 'ID130251') or  //�J����
      SameText(g_UInfo^.UserId, 'ID140139') or  //������
      SameText(g_UInfo^.UserId, 'ID150515');    //�i�Ӽw
    CheckBox1.Visible := DBCheckBox1.Visible;
    CheckBox2.Visible := DBCheckBox1.Visible;
    CheckBox3.Visible := DBCheckBox1.Visible;
  end;
end;

procedure TFrmDLII041_prn.FormShow(Sender: TObject);
begin
  inherited;
  //�ק�W�ݶ��ΫȤ�W�d,����958�P�w,969�쥻�u�]�t���tX �J���� 20220310
  l_is968 := SameText(l_SMRec.M2, 'X');
  l_is958G := Pos(l_SMRec.M2, 'YZ') > 0; //958G�B988G
  l_isBM := Pos(l_SMRec.M2, 'BM') > 0;   //859GTA�B180GN
  if l_is968 then
  begin
    DBEdit29.Enabled := True;
    DBEdit33.Enabled := True;
    DBEdit29.Color := clInfoBk;
    DBEdit33.Color := clInfoBk;
  end;
  DBEdit20.Visible := l_is968 and (Pos(l_SMRec.Custno, 'AC093/AM010') > 0);
  Label27.Visible := DBEdit20.Visible;
  if sametext(g_uinfo^.UserId,'ID150515') then
     CheckBox1.Checked:=false;
end;

procedure TFrmDLII041_prn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_MsgList);
end;

procedure TFrmDLII041_prn.btn_okClick(Sender: TObject);
var
  i, tmpLine: Integer;
begin
  if CheckBox1.Checked then
  begin
    RichEdit1.Clear;
    l_MsgList.Clear;
    Item_A;             //�~�W
    Item_D1;            //�ֺ����c(�g����)
    Item_D2;            //�ֺ����c(�n����)
    Item_E1;            //�ؤo(�g�V)
    Item_E2;            //�ؤo(�n�V)
    if l_is968 or l_is958G or l_isBM or SameText(l_SMRec.Custno, 'AC111') then
      Item_G_AC111     //�`�n����
    else if Pos(l_SMRec.Custno, 'AC084/AC148/AC347/N023') > 0 then
      Item_G;          //�䥦����
    Item_PP;            //����
    ItemLot;            //�帹rc�Brf�Bpg�Bvc�S�ʭ�
    Item_Oth;           //�䥦����
    if Pos(l_SMRec.Custno, 'AC394/AC152/AH036/AC084') > 0 then
      Item_GT(l_SMRec.Custno);         //�Ȥ�~�WGT�n�D
    if l_is968 and (Pos(l_SMRec.Custno, 'AC093/AM010') > 0) then
      Item_PV;         //�R�߫�
    if CheckBox2.Checked and (Length(l_FIFOErr) > 0) then
      l_MsgList.Add('���i���X' + l_enter + l_FIFOErr + l_enter);
    if CheckBox3.Checked and (Length(l_LotErr) > 0) then
      l_MsgList.Add('����PCOC�帹���۲�' + l_enter + l_LotErr + l_enter);

    RichEdit1.Lines.AddStrings(l_MsgList);
    if RichEdit1.Lines.Count > 0 then
    begin
      RichEdit1.SelStart := 0;
      RichEdit1.SelLength := Length(RichEdit1.Lines.Strings[0]);
      RichEdit1.SelAttributes.Color := clRed;
    end;

    for i := 1 to RichEdit1.Lines.Count - 2 do
    begin
      if Length(Trim(RichEdit1.Lines.Strings[i])) = 0 then
      begin
        tmpLine := SendMessage(RichEdit1.Handle, EM_LINEINDEX, i + 1, 0);
        RichEdit1.SelStart := tmpLine;
        RichEdit1.SelLength := Length(RichEdit1.Lines.Strings[i + 1]);
        RichEdit1.SelAttributes.Color := clRed;
      end;
    end;

    if Length(Trim(RichEdit1.Text)) > 0 then
    begin
      RichEdit1.Text := CheckLang(RichEdit1.Text);
      PCL.ActivePageIndex := 1;
      Exit;
    end;
  end;

  inherited;
end;

end.

