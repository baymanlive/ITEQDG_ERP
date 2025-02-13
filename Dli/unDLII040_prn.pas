{*******************************************************}
{                                                       }
{                unDLII040_prn                          }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: COC-CCL�C�L�e�ƾڳ]�w     }
{                             DLII040�BDLIR050�@�Φ��椸}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII040_prn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DB, StdCtrls, ComCtrls, DBCtrls, Mask, ExtCtrls, ImgList,
  Buttons, unGlobal;

type
  TFrmDLII040_prn = class(TFrmSTDI050)
    Label1: TLabel;
    DBEdit1: TDBEdit;
    DS: TDataSource;
    DBEdit2: TDBEdit;
    Label2: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label3: TLabel;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label4: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    Label5: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label6: TLabel;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    Label7: TLabel;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    Label8: TLabel;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    Label9: TLabel;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    Label10: TLabel;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    Label11: TLabel;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    Label12: TLabel;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    Label13: TLabel;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    Label14: TLabel;
    DBEdit27: TDBEdit;
    DBEdit28: TDBEdit;
    Label15: TLabel;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    Label16: TLabel;
    DBEdit31: TDBEdit;
    DBEdit32: TDBEdit;
    Label17: TLabel;
    DBEdit33: TDBEdit;
    DBEdit34: TDBEdit;
    Label18: TLabel;
    DBEdit35: TDBEdit;
    DBEdit36: TDBEdit;
    Label19: TLabel;
    DBEdit37: TDBEdit;
    DBEdit38: TDBEdit;
    Label20: TLabel;
    DBEdit39: TDBEdit;
    DBEdit40: TDBEdit;
    Bevel1: TBevel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Bevel2: TBevel;
    Label27: TLabel;
    DBEdit41: TDBEdit;
    DBEdit42: TDBEdit;
    Label28: TLabel;
    DBEdit43: TDBEdit;
    DBEdit44: TDBEdit;
    Label29: TLabel;
    DBEdit45: TDBEdit;
    DBEdit46: TDBEdit;
    Label30: TLabel;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    Label31: TLabel;
    DBEdit49: TDBEdit;
    DBEdit50: TDBEdit;
    Label32: TLabel;
    DBEdit51: TDBEdit;
    DBEdit52: TDBEdit;
    Label33: TLabel;
    DBEdit53: TDBEdit;
    Label34: TLabel;
    DBEdit54: TDBEdit;
    Label35: TLabel;
    DBEdit55: TDBEdit;
    DBEdit56: TDBEdit;
    DBEdit57: TDBEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    DBEdit58: TDBEdit;
    DBEdit59: TDBEdit;
    DBEdit60: TDBEdit;
    DBEdit61: TDBEdit;
    DBEdit62: TDBEdit;
    Label40: TLabel;
    Label41: TLabel;
    DBEdit63: TDBEdit;
    TabSheet2: TTabSheet;
    RichEdit1: TRichEdit;
    CheckBox1: TCheckBox;
    DBCheckBox1: TDBCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label42: TLabel;
    DBEdit64: TDBEdit;
    DBEdit65: TDBEdit;
    Label43: TLabel;
    DBEdit66: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_is968: Boolean;
    l_MsgList: TStrings;
    function CheckRange(exp: string; value: currency): Boolean;
    procedure C11Change(Sender: TField);
    function FindNumber(SourceStr: WideString; const StartIndex: Integer = 1): Double;
    procedure Item_A;
    procedure Item_B;
    procedure Item_C;
    procedure Item_D;
    procedure Item_E;
    procedure Item_F;
    procedure Item_G;
    procedure Item_H1;
    procedure Item_H2;
    procedure Item_H_1;
    procedure Item_I;
    procedure Item_I_1;
    procedure Item_J;
    procedure Item_K1;
    procedure Item_K2;
    procedure Item_L;
    procedure Item_O;
    procedure Item_P;
    procedure Item_Q;
    procedure Item_M;
    procedure Item_R;
    procedure Item_TD;
    procedure Item_Oth;
    { Private declarations }
  public
    l_SMRec: TSplitMaterialno;
    l_thickness, l_diff,                    //�p�סB���t
    l_CopperValue1, l_CopperValue2: Double;  //�W�B�U2���ɫp
    l_FIFOErr, l_LotErr: string;
    { Public declarations }
  end;

var
  FrmDLII040_prn: TFrmDLII040_prn;

implementation

uses
  unCommon;

const
  l_SpecificationSet = '�W��n�D���]�w'#13#10;
  l_TestValueSet = '���խȥ��]�w'#13#10;
  l_SpecificationNull = '�W��n�D����J'#13#10;
  l_TestValueNull = '���խȥ���J'#13#10;
  l_Enter = #13#10;

{$R *.dfm}

function TFrmDLII040_prn.CheckRange(exp: string; value: currency): Boolean;
var
  i, j: integer;
  n1, n2, n3: Currency;
begin              //example 691+2/-0;
  i := Pos('+', exp);
  j := Pos('/', exp);
  try
    n1 := StrToFloat(Copy(exp, 1, i - 1));
    n2 := StrToFloat(Copy(exp, i + 1, j - i - 1));
    n3 := StrToFloat(Copy(exp, j + 2, 255));
    result := ((n1 + n2) >= value) and ((n1 - n3) <= value)
  except
    result := false;
  end;
end;

function TFrmDLII040_prn.FindNumber(SourceStr: WideString; const StartIndex: Integer = 1): Double;
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

procedure TFrmDLII040_prn.Item_A;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('A1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('A11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�~�[' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_B;
var
  tmpMsg: string;
begin
  if (Length(Trim(DS.DataSet.FieldByName('B1').AsString)) = 0) or (Copy(DS.DataSet.FieldByName('B1').AsString, 1, 1) = '+') then
    tmpMsg := tmpMsg + l_SpecificationSet;

  if Length(Trim(DS.DataSet.FieldByName('B11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and (StrToFloatDef(Trim(DS.DataSet.FieldByName('B11').AsString), 0) <= 0) then
    tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo(�g�V)' + l_enter + tmpMsg);

  tmpMsg := '';
  if (Length(Trim(DS.DataSet.FieldByName('B2').AsString)) = 0) or (Copy(DS.DataSet.FieldByName('B2').AsString, 1, 1) = '+') then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if (not CheckRange(DS.DataSet.FieldByName('B1').AsString, DS.DataSet.FieldByName('B11').AsCurrency)) or (not CheckRange(DS.DataSet.FieldByName('B2').AsString, DS.DataSet.FieldByName('B21').AsCurrency)) then
    tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��';

  if Length(Trim(DS.DataSet.FieldByName('B21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and (StrToFloatDef(Trim(DS.DataSet.FieldByName('B21').AsString), 0) <= 0) then
    tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo(�n�V)' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_C;
const
  err = 99998;
var
  pos1, pos2: Integer;
  tmpMsg: string;
  str1, str2: WideString;
  num1, num2, num3, num4: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('C1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('C11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueNull;

  if Length(tmpMsg) = 0 then
  begin
    pos1 := Pos('-', DS.DataSet.FieldByName('C11').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '���խȮ榡���~(123-456)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('C11').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('C11').AsString, pos1 + 1, 20);
      num1 := StrToFloatDef(str1, 0);
      num2 := StrToFloatDef(str2, 0);
      if (num1 <= 0) or (num2 <= 0) or (num1 >= num2) then
        tmpMsg := tmpMsg + '���խȮ榡���~(123-456)' + l_enter
      else
      begin
        if Pos('class', LowerCase(DS.DataSet.FieldByName('C1').AsString)) > 0 then
        begin
          if l_diff <= 0 then
            tmpMsg := tmpMsg + DS.DataSet.FieldByName('C1').AsString + '���t�ȿ��~:' + FloatToStr(l_diff) + l_enter
          else
          begin
            str1 := FloatToStr(l_thickness) + '��' + FloatToStr(l_diff);
            DS.DataSet.Edit;
            DS.DataSet.FieldByName('D1_3').AsString:=str1;
            if (num1 <= l_thickness - l_diff) or (num2 >= l_thickness + l_diff) then
              tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:' + str1 + l_enter;
          end;
        end
        else
        begin
          if DS.DataSet.FieldByName('C1X').AsString = '+0/-6.3' then
          begin
            if (num1 <= 56.7) or (num2 >= 63) then
              tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:56.7~63' + l_enter;
          end
          else
          begin
            pos1 := Pos('+', DS.DataSet.FieldByName('C1X').AsString);
            pos2 := Pos('/-', DS.DataSet.FieldByName('C1X').AsString);
            if (pos1 > 0) and (pos2 > 0) and (pos2 - pos1 > 1) then //+a/-b
            begin
              str1 := StringReplace(StringReplace(DS.DataSet.FieldByName('C1X').AsString, '+', '', [rfReplaceAll]), '/-', ',', [rfReplaceAll]);
              pos1 := Pos(',', str1);
              str2 := Copy(str1, pos1 + 1, 10);
              str1 := Copy(str1, 1, pos1 - 1);
              num3 := StrToFloatDef(str1, err);
              num4 := StrToFloatDef(str2, err);
              if (num3 = err) or (num4 = err) then
                tmpMsg := tmpMsg + '�W��n�D[���t]���O���ļƭ�' + l_enter
              else
              begin
                str1 := FloatToStr(l_thickness) + '+' + str1 + '/-' + str2;
                if (num1 <= l_thickness - num4) or (num2 >= l_thickness + num3) then
                  tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:' + str1 + l_enter;
              end;
            end
            else
            begin
              num3 := Abs(FindNumber(DS.DataSet.FieldByName('C1X').AsString));
              if num3 = 0 then
                tmpMsg := tmpMsg + '�W��n�D[���t]���O���Ī��ƭ�' + l_enter
              else
              begin
                str1 := FloatToStr(l_thickness) + '��' + FloatToStr(num3);
                if (num1 <= l_thickness - num3) or (num2 >= l_thickness + num3) then
                  tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:' + str1 + l_enter;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�p��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_D;
var
  pos1, pos2: Integer;
  tmpMsg: string;
  str1, str2: WideString;
  num1, num2, num3: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('D1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('D11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueNull;

  if Length(tmpMsg) = 0 then
  begin
    pos1 := Pos('-', DS.DataSet.FieldByName('D11').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '���խȮ榡���~(123-456)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('D11').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('D11').AsString, pos1 + 1, 20);
      num1 := StrToFloatDef(str1, 0);
      num2 := StrToFloatDef(str2, 0);
      if (num1 <= 0) or (num2 <= 0) or (num1 >= num2) then
        tmpMsg := tmpMsg + '���խȮ榡���~(123-456)' + l_enter
      else
      begin
        if Pos('class', LowerCase(DS.DataSet.FieldByName('D1').AsString)) > 0 then
        begin
          if l_diff <= 0 then
            tmpMsg := tmpMsg + DS.DataSet.FieldByName('D1').AsString + '���t�ȿ��~:' + FloatToStr(l_diff) + l_enter
          else
          begin
            str1 := FloatToStr(l_SMRec.M3_6) + '��' + FloatToStr(l_diff);
            if (num1 <= l_SMRec.M3_6 - l_diff) or (num2 >= l_SMRec.M3_6 + l_diff) then
              tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:' + str1 + l_enter;
          end;
        end
        else
        begin
          pos1 := Pos('+', DS.DataSet.FieldByName('D1X').AsString);
          pos2 := Pos('/-', DS.DataSet.FieldByName('D1X').AsString);
          if not ((pos1 > 0) and (pos2 > 0) and (pos2 - pos1 > 1)) then //not +a/-b
          begin
            num3 := Abs(FindNumber(DS.DataSet.FieldByName('D1X').AsString));
            if num3 = 0 then
              tmpMsg := tmpMsg + '�W��n�D[���t]���O���Ī��ƭ�' + l_enter
            else
            begin
              str1 := FloatToStr(l_SMRec.M3_6) + '��' + FloatToStr(num3);
              if (num1 <= l_SMRec.M3_6 - num3) or (num2 >= l_SMRec.M3_6 + num3) then
                tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��:' + str1 + l_enter;
            end;
          end;
        end;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('����h�p��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_E;
var
  tmpMsg, str1, str2: string;
  pos1: Integer;
  num1, num2, num3: Double;
begin
  if (Length(Trim(DS.DataSet.FieldByName('E1').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('E2').AsString)) = 0) then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if (Length(Trim(DS.DataSet.FieldByName('E11').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('E21').AsString)) = 0) then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('E11').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '1.���խȤ��O���Ī��ƭ�' + l_enter;
    pos1 := Pos('��', DS.DataSet.FieldByName('E1').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '1.�W��n�D�榡���~(123��12.3)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('E1').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('E1').AsString, pos1 + 2, 20);
    end;

    if (num1 > 0) and (pos1 > 0) then
    begin
      num2 := StrToFloatDef(str1, 0);
      num3 := StrToFloatDef(str2, 0);
      if (num2 <= 0) or (num3 <= 0) or (num2 <= num3) then
        tmpMsg := tmpMsg + '1.�W��n�D�榡���~(123��12.3)' + l_enter
      else if (num1 < num2 - num3) or (num1 > num2 + num3) then
        tmpMsg := tmpMsg + '1.���խȤ��b�W��n�D�d��' + l_enter;
    end;

    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('E21').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '2.���խȤ��O���Ī��ƭ�' + l_enter;
    pos1 := Pos('��', DS.DataSet.FieldByName('E2').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + '2.�W��n�D�榡���~(123��12.3)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('E2').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('E2').AsString, pos1 + 2, 20);
    end;

    if (num1 > 0) and (pos1 > 0) then
    begin
      num2 := StrToFloatDef(str1, 0);
      num3 := StrToFloatDef(str2, 0);
      if (num2 <= 0) or (num3 <= 0) or (num2 <= num3) then
        tmpMsg := tmpMsg + '2.�W��n�D�榡���~(123��12.3)' + l_enter
      else if (num1 < num2 - num3) or (num1 > num2 + num3) then
        tmpMsg := tmpMsg + '2.���խȤ��b�W��n�D�d��' + l_enter;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ɺ�p��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_F;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('F1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('F11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�s��/�ᦱ' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_G;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  if (Length(Trim(DS.DataSet.FieldByName('G1').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('G2').AsString)) = 0) then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if (Length(Trim(DS.DataSet.FieldByName('G11').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('G21').AsString)) = 0) then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('G11').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '1.���խȤ��O���Ī��ƭ�' + l_enter
    else
    begin
      num2 := FindNumber(DS.DataSet.FieldByName('G1').AsString, 4);
      if num2 <= 0 then
        tmpMsg := tmpMsg + '1.�W��n�D���O���Ī��ƭ�' + l_enter
      else if num2 > num1 then
        tmpMsg := tmpMsg + '1.���խȤ��b�W��n�D�d��' + l_enter;
    end;

    num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('G21').AsString), 0);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '2.���խȤ��O���Ī��ƭ�' + l_enter
    else
    begin
      num2 := FindNumber(DS.DataSet.FieldByName('G2').AsString, 4);
      if num2 <= 0 then
        tmpMsg := tmpMsg + '2.�W��n�D���O���Ī��ƭ�' + l_enter
      else if num2 > num1 then
        tmpMsg := tmpMsg + '2.���խȤ��b�W��n�D�d��' + l_enter;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�����j��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_H1;
var
  pos1: Integer;
  tmpMsg, h1: string;
  str1, str2: Widestring;
  num1, num2, num3: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('H1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('H11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and SameText(DS.DataSet.FieldByName('H12').AsString, 'pass') then
  begin
    num1 := StrToFloatDef(DS.DataSet.FieldByName('H11').AsString, 0);
    if num1 = 0 then
      tmpMsg := tmpMsg + '���խȤ��i��0' + l_enter
    else
    begin
      h1 := StringReplace(DS.DataSet.FieldByName('H1').AsString, '(�ȩw)', '', [rfReplaceAll]);
      h1 := Trim(StringReplace(h1, '�ȩw', '', [rfReplaceAll]));
      pos1 := Pos('��', h1);
      if pos1 = 0 then
        tmpMsg := tmpMsg + '�W��n�D�榡���~(#��123)' + l_enter
      else
      begin
        str1 := Copy(h1, 1, pos1 - 1);
        str2 := Copy(h1, pos1 + 2, 20);
      end;

      if pos1 > 0 then
      begin
        num2 := FindNumber(str1);
        num3 := FindNumber(str2);
        if (num1 < num2 - num3) or (num1 > num2 + num3) then
          tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo�w�w��(�g�V)' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_H2;
var
  pos1: Integer;
  tmpMsg, h2: string;
  str1, str2: Widestring;
  num1, num2, num3: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('H2').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('H21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and SameText(DS.DataSet.FieldByName('H22').AsString, 'pass') then
  begin
    num1 := StrToFloatDef(DS.DataSet.FieldByName('H21').AsString, 0);
    if num1 = 0 then
      tmpMsg := tmpMsg + '���խȤ��i��0' + l_enter
    else
    begin
      h2 := StringReplace(DS.DataSet.FieldByName('H2').AsString, '(�ȩw)', '', [rfReplaceAll]);
      h2 := Trim(StringReplace(h2, '�ȩw', '', [rfReplaceAll]));
      pos1 := Pos('��', h2);
      if pos1 = 0 then
        tmpMsg := tmpMsg + '�W��n�D�榡���~(#��123)' + l_enter
      else
      begin
        str1 := Copy(h2, 1, pos1 - 1);
        str2 := Copy(h2, pos1 + 2, 20);
      end;

      if pos1 > 0 then
      begin
        num2 := FindNumber(str1);
        num3 := FindNumber(str2);
        if (num1 < num2 - num3) or (num1 > num2 + num3) then
          tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo�w�w��(�n�V)' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_H_1;
var
  pos1: Integer;
  tmpMsg: string;
  str1, str2: Widestring;
  num1, num2, num3: Double;
begin
  if not SameText(DS.DataSet.FieldByName('H12').AsString, 'NA') then
  begin
    if Length(Trim(DS.DataSet.FieldByName('H1').AsString)) = 0 then
      tmpMsg := tmpMsg + l_SpecificationSet;
    if Length(Trim(DS.DataSet.FieldByName('H11').AsString)) = 0 then
      tmpMsg := tmpMsg + l_TestValueSet;
    if Length(Trim(DS.DataSet.FieldByName('H21').AsString)) = 0 then
      tmpMsg := tmpMsg + l_TestValueSet;

    if Length(tmpMsg) = 0 then
    begin
      num1 := StrToFloatDef(DS.DataSet.FieldByName('H11').AsString, 0);
      if num1 >= 0 then
        tmpMsg := tmpMsg + '���խȤ��O���Ī��t�ƭ�' + l_enter
      else
      begin
        pos1 := Pos('��', DS.DataSet.FieldByName('H1').AsString);
        if pos1 = 0 then
          Exit;

        str1 := Copy(DS.DataSet.FieldByName('H1').AsString, 1, pos1 - 1);
        str2 := Copy(DS.DataSet.FieldByName('H1').AsString, pos1 + 2, 20);

        num2 := FindNumber(str1);
        num3 := FindNumber(str2);
        if (num1 < num2 - num3) or (num1 > num2 + num3) then
          tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�ؤo�w�w��(�W��)' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_I;
var
  pos1: Integer;
  tmpMsg, str1: string;
  num1, num2, num3, num4, num5: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('I1').AsString)) = 0 then
    tmpMsg := tmpMsg + 'Tg' + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('I2').AsString)) = 0 then
    tmpMsg := tmpMsg + '��Tg' + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('I11').AsString)) = 0 then
    tmpMsg := tmpMsg + 'Tg1' + l_TestValueSet;
  if Length(Trim(DS.DataSet.FieldByName('I31').AsString)) = 0 then
    tmpMsg := tmpMsg + 'Tg2' + l_TestValueSet;
  if Length(Trim(DS.DataSet.FieldByName('I21').AsString)) = 0 then
    tmpMsg := tmpMsg + '��Tg' + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := FindNumber(DS.DataSet.FieldByName('I1').AsString);  //Tg�з�
    num2 := FindNumber(DS.DataSet.FieldByName('I2').AsString);  //��Tg�з�
    num3 := 0;                                                  //tg1
    num4 := 0;                                                  //tg2
                                                              //num5 ��tg1
    if num1 <= 0 then
      tmpMsg := tmpMsg + 'Tg�W��n�D���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + '��Tg�W��n�D���O���Ī��ƭ�' + l_enter;

    pos1 := Pos('=', DS.DataSet.FieldByName('I11').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + 'Tg1���խȮ榡���~(Tg1=123)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('I11').AsString, pos1 + 1, 20);
      num3 := StrToFloatDef(str1, 0);
      if num3 <= 0 then
        tmpMsg := tmpMsg + 'Tg1���խȤ��O���Ī��ƭ�' + l_enter
      else if num3 < num1 then
        tmpMsg := tmpMsg + 'Tg1���խȤ��b�W��n�D�d��' + l_enter;
    end;

    pos1 := Pos('=', DS.DataSet.FieldByName('I31').AsString);
    if pos1 = 0 then
      tmpMsg := tmpMsg + 'Tg2���խȮ榡���~(Tg2=123)' + l_enter
    else
    begin
      str1 := Copy(DS.DataSet.FieldByName('I31').AsString, pos1 + 1, 20);
      num4 := StrToFloatDef(str1, 0);
      if num4 <= 0 then
        tmpMsg := tmpMsg + 'Tg2���խȤ��O���Ī��ƭ�' + l_enter
      else if num4 < num1 then
        tmpMsg := tmpMsg + 'Tg2���խȤ��b�W��n�D�d��' + l_enter;
    end;

    num5 := FindNumber(DS.DataSet.FieldByName('I21').AsString);
    if num5 <= 0 then
      tmpMsg := tmpMsg + '��Tg���խȤ��O���Ī��ƭ�' + l_enter
    else if (POS(l_SMRec.Custno, 'AC093/AM010')>0) then
    begin
      if (num2 > 0) and (num5 >= num2) then
        tmpMsg := tmpMsg + 'AC093 ��Tg���խȤ��b�W��n�D�d��' + l_enter;
    end
    else if (num2 > 0) and (num5 > num2) then
      tmpMsg := tmpMsg + '��Tg���խȤ��b�W��n�D�d��' + l_enter;

    if (num3 > 0) and (num4 > 0) and (num5 > 0) and (Abs(Abs(num4 - num3) - num5) > 0.000001) then
      tmpMsg := tmpMsg + '���խ�Tg1-Tg2<>��Tg' + l_enter;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('������Ʒū�' + l_enter + tmpMsg);
end;

//�W�ݡA�u��tg�Btg1
procedure TFrmDLII040_prn.Item_I_1;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  num1 := StrToFloatDef(Trim(DS.DataSet.FieldByName('I4').AsString), 0);
  num2 := StrToFloatDef(Trim(DS.DataSet.FieldByName('I42').AsString), 0);

  if num1 <= 0 then
    tmpMsg := tmpMsg + 'Tg���]�w�Τ��O���Ī��ƭ�';
  if num2 <= 0 then
    tmpMsg := tmpMsg + 'Tg1���]�w�Τ��O���Ī��ƭ�';

  if (Length(tmpMsg) = 0) and (num1 > num2) then
    tmpMsg := tmpMsg + 'Tg1���խȤ��b�W��n�D�d��';

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('������Ʒū�(�W��)' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_J;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('J1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('J11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('��n�q��' + l_enter + tmpMsg);

  tmpMsg := '';
  if Length(Trim(DS.DataSet.FieldByName('J2').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('J21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���q��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_K1;
var
  pos1: Integer;
  tmpMsg: string;
  str1, str2: WideString;
  num1, num2: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('K1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('K11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    pos1 := Pos('/', DS.DataSet.FieldByName('K11').AsString);
    if pos1 > 0 then
    begin
      str1 := Copy(DS.DataSet.FieldByName('K11').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('K11').AsString, pos1 + 1, 20);
    end
    else
      str1 := DS.DataSet.FieldByName('K11').AsString;

    num1 := FindNumber(DS.DataSet.FieldByName('K1').AsString);
    num2 := FindNumber(str1);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

    if Length(tmpMsg) = 0 then
    begin
      if num2 > num1 then
        tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;

      if Pos(l_SMRec.Custno, 'AC148/AC347') > 0 then
      begin
        if pos1 = 0 then
          tmpMsg := tmpMsg + 'AC148/AC347���խȮ榡���~(1m/1g)' + l_enter
        else
        begin
          num2 := FindNumber(str2);
          if num2 <= 0 then
            tmpMsg := tmpMsg + 'AC148/AC347 1g���խȤ��O���Ī��ƭ�' + l_enter
          else if num2 > num1 then
            tmpMsg := tmpMsg + 'AC148/AC347 1g���խȤ��b�W��n�D�d��' + l_enter;
        end;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���q�`��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_K2;
var
  pos1: Integer;
  tmpMsg: string;
  str1, str2: WideString;
  num1, num2: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('K2').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('K21').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    pos1 := Pos('/', DS.DataSet.FieldByName('K21').AsString);
    if pos1 > 0 then
    begin
      str1 := Copy(DS.DataSet.FieldByName('K21').AsString, 1, pos1 - 1);
      str2 := Copy(DS.DataSet.FieldByName('K21').AsString, pos1 + 1, 20);
    end
    else
      str1 := DS.DataSet.FieldByName('K21').AsString;

    num1 := FindNumber(DS.DataSet.FieldByName('K2').AsString);
    num2 := FindNumber(str1);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

    if Length(tmpMsg) = 0 then
    begin
      if num2 > num1 then
        tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;

      if Pos(l_SMRec.Custno, 'AC148/AC347') > 0 then
      begin
        if pos1 = 0 then
          tmpMsg := tmpMsg + 'AC148/AC347���խȮ榡���~(1m/1g)' + l_enter
        else
        begin
          num2 := FindNumber(str2);
          if num2 <= 0 then
            tmpMsg := tmpMsg + 'AC148/AC347 1g���խȤ��O���Ī��ƭ�' + l_enter
          else if num2 > num1 then
            tmpMsg := tmpMsg + 'AC148/AC347 1g���խȤ��b�W��n�D�d��' + l_enter;
        end;
      end;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���Ӧ]��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_L;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('L1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('L11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := FindNumber(DS.DataSet.FieldByName('L1').AsString);
    num2 := FindNumber(DS.DataSet.FieldByName('L11').AsString);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
    if (num1 > 0) and (num2 > 0) and (num2 >= num1) then
      tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�l����' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_M;
var
  tmpMsg: string;
begin
  if Length(Trim(DS.DataSet.FieldByName('M1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('M11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if (Length(tmpMsg) = 0) and (StrToFloatDef(Trim(DS.DataSet.FieldByName('M11').AsString), 0) <= 0) then
    tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���U��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_O;
var
  tmpMsg, str1: string;
  num1, num2: Double;
begin
  if (Length(Trim(DS.DataSet.FieldByName('O1').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('O2').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('O3').AsString)) = 0) then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if (Length(Trim(DS.DataSet.FieldByName('O11').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('O21').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('O31').AsString)) = 0) then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    if SameText(Trim(DS.DataSet.FieldByName('O12').AsString), 'NA') then
    begin
      str1 := DS.DataSet.FieldByName('O11').AsString;
      str1 := StringReplace(str1, '-', '', [rfReplaceAll]);
      if length(Trim(str1)) > 0 then
        tmpMsg := tmpMsg + '1.NA�W��n�D�O---' + l_enter;

      str1 := DS.DataSet.FieldByName('O21').AsString;
      str1 := StringReplace(str1, '-', '', [rfReplaceAll]);
      if length(Trim(str1)) > 0 then
        tmpMsg := tmpMsg + '2.NA�W��n�D�O---' + l_enter;

      str1 := DS.DataSet.FieldByName('O31').AsString;
      str1 := StringReplace(str1, '-', '', [rfReplaceAll]);
      if length(Trim(str1)) > 0 then
        tmpMsg := tmpMsg + '3.NA�W��n�D�O---' + l_enter;
    end
    else
    begin
      num1 := FindNumber(DS.DataSet.FieldByName('O1').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('O11').AsString);
      if num1 <= 0 then
        tmpMsg := tmpMsg + '1.�W��n�D���O���Ī��ƭ�' + l_enter;
      if num2 <= 0 then
        tmpMsg := tmpMsg + '1.���խȤ��O���Ī��ƭ�' + l_enter;
      if (num1 > 0) and (num2 > 0) and (num2 > num1) then
        tmpMsg := tmpMsg + '1.���խȤ��b�W��n�D�d��' + l_enter;

      num1 := FindNumber(DS.DataSet.FieldByName('O2').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('O21').AsString);
      if num1 <= 0 then
        tmpMsg := tmpMsg + '2.�W��n�D���O���Ī��ƭ�' + l_enter;
      if num2 <= 0 then
        tmpMsg := tmpMsg + '2.���խȤ��O���Ī��ƭ�' + l_enter;
      if (num1 > 0) and (num2 > 0) and (num2 > num1) then
        tmpMsg := tmpMsg + '2.���խȤ��b�W��n�D�d��' + l_enter;

      num1 := FindNumber(DS.DataSet.FieldByName('O3').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('O31').AsString);
      if num1 <= 0 then
        tmpMsg := tmpMsg + '3.�W��n�D���O���Ī��ƭ�' + l_enter;
      if num2 <= 0 then
        tmpMsg := tmpMsg + '3.���խȤ��O���Ī��ƭ�' + l_enter;
      if (num1 > 0) and (num2 > 0) and (num2 > num1) then
        tmpMsg := tmpMsg + '3.���խȤ��b�W��n�D�d��' + l_enter;
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���Ȩt��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_P;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('P1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('P11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
    if SameText(Trim(DS.DataSet.FieldByName('P12').AsString), 'pass') then
    begin
      num1 := FindNumber(DS.DataSet.FieldByName('P1').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('P11').AsString);
      if num1 <= 0 then
        tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
      if num2 <= 0 then
        tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
      if (num1 > 0) and (num2 > 0) and (num2 < num1) then
        tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
    end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�@�q������' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_Q;
var
  tmpMsg: string;
  num1, num2: Double;
begin
//  if Length(Trim(DS.DataSet.FieldByName('Q1').AsString)) = 0 then
//    tmpMsg := tmpMsg + l_SpecificationSet;
//  if Length(Trim(DS.DataSet.FieldByName('Q11').AsString)) = 0 then
//    tmpMsg := tmpMsg + l_TestValueSet;
//
//  if Length(tmpMsg) = 0 then
//  begin
//    num1 := FindNumber(DS.DataSet.FieldByName('Q1').AsString);
//    num2 := FindNumber(DS.DataSet.FieldByName('Q11').AsString);
//    if num1 <= 0 then
//      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
//    if num2 <= 0 then
//      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
//    if (num1 > 0) and (num2 > 0) and (num2 >= num1) then
//      tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
//  end;
//
//  if Length(tmpMsg) > 0 then
//    l_MsgList.Add('�ܤƾǩ�' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_R;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  if (Length(Trim(DS.DataSet.FieldByName('R1').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('R2').AsString)) = 0) then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if (Length(Trim(DS.DataSet.FieldByName('R11').AsString)) = 0) or (Length(Trim(DS.DataSet.FieldByName('R21').AsString)) = 0) then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    if SameText(Trim(DS.DataSet.FieldByName('R12').AsString), 'pass') then
    begin
      num1 := FindNumber(DS.DataSet.FieldByName('R1').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('R11').AsString);
      if num2 < num1 then
        tmpMsg := tmpMsg + '1.���խȤ��b�W��n�D�d��' + l_enter
    end;

    if SameText(Trim(DS.DataSet.FieldByName('R22').AsString), 'pass') then
    begin
      num1 := FindNumber(DS.DataSet.FieldByName('R2').AsString);
      num2 := FindNumber(DS.DataSet.FieldByName('R21').AsString);
      if num2 < num1 then
        tmpMsg := tmpMsg + '2.���խȤ��b�W��n�D�d��' + l_enter
    end;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���s���j��' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_TD;
var
  tmpMsg: string;
  num1, num2: Double;
begin
  if Length(Trim(DS.DataSet.FieldByName('TD1').AsString)) = 0 then
    tmpMsg := tmpMsg + l_SpecificationSet;
  if Length(Trim(DS.DataSet.FieldByName('TD11').AsString)) = 0 then
    tmpMsg := tmpMsg + l_TestValueSet;

  if Length(tmpMsg) = 0 then
  begin
    num1 := FindNumber(DS.DataSet.FieldByName('TD1').AsString);
    num2 := FindNumber(DS.DataSet.FieldByName('TD11').AsString);
    if num1 <= 0 then
      tmpMsg := tmpMsg + '�W��n�D���O���Ī��ƭ�' + l_enter;
    if num2 <= 0 then
      tmpMsg := tmpMsg + '���խȤ��O���Ī��ƭ�' + l_enter;
    if (num1 > 0) and (num2 > 0) and (num2 < num1) then
      tmpMsg := tmpMsg + '���խȤ��b�W��n�D�d��' + l_enter;
  end;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('���ѷū�TD' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.Item_Oth;
var
  tmpMsg: string;
begin
  if (DS.DataSet.FieldByName('Resin_visible').AsString = '1') and (Length(Trim(DS.DataSet.FieldByName('Resin').AsString)) = 0) then
    tmpMsg := tmpMsg + '��ץ���J' + l_enter;

  if (DS.DataSet.FieldByName('PP_visible').AsString = '1') and (Length(Trim(DS.DataSet.FieldByName('PP').AsString)) = 0) then
    tmpMsg := tmpMsg + '��������J' + l_enter;

  if (DS.DataSet.FieldByName('Copper_visible').AsString = '1') and (Length(Trim(DS.DataSet.FieldByName('Copper').AsString)) = 0) then
    tmpMsg := tmpMsg + '�ɺ䥼��J' + l_enter;

  if Length(Trim(DS.DataSet.FieldByName('N1').AsString)) = 0 then
    tmpMsg := tmpMsg + '���c����J' + l_enter;

  if Length(Trim(DS.DataSet.FieldByName('fileno').AsString)) = 0 then
    tmpMsg := tmpMsg + '���s������J' + l_enter;

  if Length(tmpMsg) > 0 then
    l_MsgList.Add('�䥦����' + l_enter + tmpMsg);
end;

procedure TFrmDLII040_prn.FormCreate(Sender: TObject);
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
  Label32.Caption := CheckLang('���c�G');
  Label33.Caption := CheckLang('���s���G');

  Label1.Caption := CheckLang('�~�[�G');
  Label3.Caption := CheckLang('�ؤo(�g)�G');
  Label5.Caption := CheckLang('�ؤo(�n)�G');
  Label7.Caption := CheckLang('�p�סG');
  Label9.Caption := CheckLang('����h�p�סG');
  Label11.Caption := CheckLang('�ɺ�p��(�W)�G');
  Label13.Caption := CheckLang('�ɺ�p��(�U)�G');
  Label15.Caption := CheckLang('�s��/�ᦱ�G');
  Label17.Caption := CheckLang('�����j��(�W)�G');
  Label19.Caption := CheckLang('�����j��(�U)�G');
  Label2.Caption := CheckLang('�ؤo�w�w��(�g�V)�G');
  Label4.Caption := CheckLang('�ؤo�w�w��(�n�V)�G');
  Label6.Caption := CheckLang('������Ʒū�tg�G');
  Label8.Caption := CheckLang('������Ʒūס�tg�G');

  Label10.Caption := CheckLang('��n�q���G');
  Label12.Caption := CheckLang('���q���G');
  Label14.Caption := CheckLang('���q�`�ơG');
  Label16.Caption := CheckLang('���Ӧ]���G');
  Label18.Caption := CheckLang('�l���ʡG');
  Label20.Caption := CheckLang('���U�ʡG');
  Label27.Caption := CheckLang('����t��(a1)�G');
  Label28.Caption := CheckLang('����t��(a2)�G');
  Label29.Caption := CheckLang('����t��(50~260)�G');
  Label30.Caption := CheckLang('�@�q�����աG');
  Label31.Caption := CheckLang('�ܤƩʡG');
  Label34.Caption := CheckLang('��t�q�G');
  Label35.Caption := CheckLang('�ͧt�q�G');
  Label36.Caption := CheckLang('��סG');
  Label37.Caption := CheckLang('�����G');
  Label38.Caption := CheckLang('�ɺ�G');
  Label39.Caption := CheckLang('CPK�G');
  Label40.Caption := CheckLang('�q�渹�X�G');
  Label41.Caption := CheckLang('�Ȥ�q�渹�X�G');
  Label42.Caption := CheckLang('���ѷūסG');
  Label43.Caption := CheckLang('�Ȥ�²�١G');

  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    DBCheckBox1.Visible := SameText(g_UInfo^.UserId, 'ID130251') or  //�J����
      SameText(g_UInfo^.UserId, 'ID140139') or  //������
      SameText(g_UInfo^.UserId, 'ID150515');   
    CheckBox1.Visible := DBCheckBox1.Visible;
    CheckBox2.Visible := DBCheckBox1.Visible;
    CheckBox3.Visible := DBCheckBox1.Visible;
  end;
end;

procedure TFrmDLII040_prn.FormShow(Sender: TObject);
begin
  inherited;
  DS.DataSet.FieldByName('C11').OnChange := C11Change;
  l_is968 := SameText(l_SMRec.M2, 'X');
  if l_is968 then
  begin
    DBEdit4.Enabled := True;
    DBEdit8.Enabled := True;
    DBEdit14.Enabled := False;
    DBEdit4.Color := clInfoBk;
    DBEdit8.Color := clInfoBk;
    DBEdit14.Color := clWindow;
  end;
  if sametext('ID150515',g_uinfo^.userid) then
    CheckBox1.checked:=false;
end;

procedure TFrmDLII040_prn.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DS.DataSet.FieldByName('C11').OnChange := nil;
  FreeAndNil(l_MsgList);
end;

procedure TFrmDLII040_prn.btn_okClick(Sender: TObject);
var
  i, tmpLine: Integer;
begin
  //�f��AC394/AC152/AC844
  //�W��AC405/AC075/AC310/AC311/AC950

  if CheckBox1.Checked then
  begin
    RichEdit1.Clear;
    l_MsgList.Clear;
    if not SameText(l_SMRec.Custno, 'AC109') then
      Item_A; //�~�[
    Item_B; //�ؤo
    if (not SameText(l_SMRec.Custno, 'AC109')) and (not l_is968) then
      Item_C; //�p��
    if not l_is968 then
    begin
      Item_D; //����h�p��
      Item_E; //�ɺ�p��
    end;
    Item_F; //�s��/�ᦱ
    Item_G; //�����j��
    if Pos(l_SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950') > 0 then
    begin
      Item_H_1;  //�ؤo�w�w��(�W��)
      Item_I_1   //������Ʒū�(�W��)
    end
    else
    begin
      Item_H1;   //�ؤo�w�w��(�g�V)
      Item_H2;   //�ؤo�w�w��(�n�V)
      Item_I;    //������Ʒū�
    end;
    Item_J;      //�q��
    Item_K1;     //���q�`��
    Item_K2;     //���Ӧ]��
    Item_L;      //�l����
    Item_O;      //���Ȩt��
    Item_P;      //�@�q������
    if not SameText(l_SMRec.Custno, 'AC109') then
      Item_Q;   //�ܤƾǩ�
    Item_M;      //���U��

    if Pos(l_SMRec.Custno, 'AC394/AC152/AH036/AC844/AC405/AC075/AC310/AC311/AC950') > 0 then
      Item_R;  //���s���j��

    if pos(l_SMRec.Custno, 'AC109/N023')>0 then
      Item_TD;  //���ѷū�

    Item_Oth;   //�䥦����

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

//��J�p�צ۰ʭp�⤶��h�p��
procedure TFrmDLII040_prn.C11Change(Sender: TField);
var
  pos1: Integer;
  num1, num2: Double;
  str1, str2: string;
begin
  pos1 := Pos('-', DS.DataSet.FieldByName('C11').AsString);
  if pos1 = 0 then
    Exit;

  str1 := Copy(DS.DataSet.FieldByName('C11').AsString, 1, pos1 - 1);
  str2 := Copy(DS.DataSet.FieldByName('C11').AsString, pos1 + 1, 20);
  num1 := StrToFloatDef(str1, 0);
  num2 := StrToFloatDef(str2, 0);
  if (num1 <= 0) or (num2 <= 0) then
    Exit;
  num1 := num1 - l_CopperValue1 - l_CopperValue2;
  num2 := num2 - l_CopperValue1 - l_CopperValue2;
  DS.DataSet.FieldByName('D11').AsString := Format('%.2n-%.2n', [num1, num2]);
end;

end.

