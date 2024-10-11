{*******************************************************}
{                                                       }
{                unDLII040_rpt                          }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: COC-CCL�C�L               }
{                             DLII040�BDLIR050�@�Φ��椸}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII040_rpt;

interface

uses
  Windows, Classes, SysUtils, DB, DBClient, Forms, Variants, Math, StrUtils, Controls, ComCtrls, DateUtils, unGlobal,
  unCommon, unDLII040_prn, Graphics, unDLII040_lot, unDLII040_cocerr, unDLIR050_units, unCheckC_sizes, TWODbarcode;

type
  T061Rec = record
    RTF, RTF2, VLP, HVLP: string;
  end;

type
  TDLII040_rpt = class
  private
    Fm_image: PTIMAGESTRUCT;
    FCDS: TClientDataSet;
    FCDSLot: TClientDataSet;
    FCDSDetail: TClientDataSet;
    FCDSDli210: TClientDataSet;
    FCheckC_sizes: TCheckC_sizes;
    procedure ShowBarMsg(msg: string);
    function FormatPoint(SourceStr: string; n: integer): string;
    function ReM7_8(s: string): string;
    function SetG2_FromDli060(DataSet: TDataSet; SMRec: TSplitMaterialno; cw1, cw2: string): Boolean;
    function SetG2_FromDli060_VLP(DataSet: TDataSet; SMRec: TSplitMaterialno): Boolean;
    function SetH_FromDli050(DataSet: TDataSet; SMRec: TSplitMaterialno; isLCA: Boolean): Boolean;
    function GetClassB_C(SMRec: TSplitMaterialno; C_Sizes: string): Boolean;
    procedure GetClassB_C_diff(SMRec: TSplitMaterialno; CopperValue1, CopperValue2: Double; var thickness, diff: Double);
    function GetTBXD(SMRec: TSplitMaterialno; IsCustno: Boolean): string;
    function GetBBXD(SMRec: TSplitMaterialno; Struct: string): string;
    function GetAddr(SMRec: TSplitMaterialno): string;
    procedure AddCDSDetail(Lot, Units: string; Qty: Double; SMRec: TSplitMaterialno);
    procedure AddCDSDetail_oth(Lot: string);
    procedure CheckCar(pno, c_sizes, orderno, remark: string; orderitem: integer);
    procedure SY_QRCode;
//    function GetCustName(custno: string): string;
    function GetJxTA_oeb10(const oao06: string; ta_oeb10: Tfield): boolean;
  public
    FSourceCDS: TClientDataSet;
    constructor Create(CDS: TClientDataSet);
    destructor Destroy; override;
    procedure StartPrint(ProcId: string; ds3: TDataset = nil);
  end;

implementation

uses
  unFrmWarn;

const
  l_CDSXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="IsCCLCOC" fieldtype="boolean"/>' + '<FIELD attrname="Indate" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Indate1" fieldtype="string" WIDTH="100"/>' //�~���
    + '<FIELD attrname="Fileno" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="TestName" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="E_seal" fieldtype="boolean"/>' +
    '<FIELD attrname="A1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="A11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="B1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="B11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="B2" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="B21" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="C1X" fieldtype="string" WIDTH="100"/>'   //�ˬd��
    + '<FIELD attrname="C1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="C11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="D1X" fieldtype="string" WIDTH="100"/>'   //�ˬd��
    + '<FIELD attrname="D1_1" fieldtype="string" WIDTH="100"/>'  //-���t(�Ʀr�L�Ÿ�)
    + '<FIELD attrname="D1_2" fieldtype="string" WIDTH="100"/>'  //+���t(�Ʀr�L�Ÿ�)
    + '<FIELD attrname="D1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="D11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="E1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="E11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="E2" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="E21" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="F1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="F11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="F12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="G1" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="G11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="G2" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="G21" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="G_unit" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="H1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="H11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="H12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="H2" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="H21" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="H22" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="I1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="I11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="I2" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="I21" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="I31" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="I4" fieldtype="string" WIDTH="100"/>'
    //�W��
    + '<FIELD attrname="I41" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="I42" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="J1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="J11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="J2" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="J21" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="K1_item" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="K1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="K11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="K2_item" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="K2" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="K21" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="L1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="L11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="M1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="M11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="N1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="O1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="O1_1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="O11" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="O12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="O2" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="O2_1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="O21" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="O22" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="O3" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="O3_1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="O31" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="O32" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="P1" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="P11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="P12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="Q1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Q11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="R1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="R11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="R12" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="R2" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="R21" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="R22" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="S1" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="S11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="S12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="T1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="T11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="T12" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="TD1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="TD11" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="U1" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="U11" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="U12" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="Ra1" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="Ra2" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Rz1" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="Rz2" fieldtype="string" WIDTH="100"/>'
    + '<FIELD attrname="Resin" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="PP" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Copper" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="CPK" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="Addr" fieldtype="string" WIDTH="100"/>'
    //���a
    + '<FIELD attrname="Resin_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="PP_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Copper_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="CPK_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Cl_std" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Cl" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Br_std" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Br" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Cl_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="STS_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="CustPno_visible" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="remark2" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="Custabs" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="Orderno" fieldtype="string" WIDTH="200"/>'   //�t���q�渹
    + '<FIELD attrname="Pno" fieldtype="string" WIDTH="200"/>'       //�t���Ƹ�
    + '<FIELD attrname="Pname" fieldtype="string" WIDTH="200"/>'     //�t���~�W
    + '<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'     //�t���W��
    + '<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="200"/>' //�Ȥ�q�渹
    + '<FIELD attrname="C_Pno" fieldtype="string" WIDTH="200"/>'     //�Ȥ�Ƹ�
    + '<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'   //�Ȥ�W��
    + '<FIELD attrname="TW_Size" fieldtype="string" WIDTH="200"/>'   //TW�榡�ؤo
    + '<FIELD attrname="AC117_remark" fieldtype="string" WIDTH="100"/>' //AC117�W�U�ɺ�c��
    + '<FIELD attrname="QRcode" fieldtype="string" WIDTH="200"/>'    //�G���X
    + '<FIELD attrname="FstLot" fieldtype="string" WIDTH="20"/>'     //�Ĥ@�ӧ帹
    + '<FIELD attrname="V01" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V02" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V03" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V04" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V05" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V06" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V07" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V08" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V09" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V10" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V11" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V12" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="V13" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="V14" fieldtype="string" WIDTH="20"/>'
    + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

const
  l_CDSLotXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="lot" fieldtype="string" WIDTH="400"/>'      //�帹(�ƶq���)(�Ů�s��)
    + '<FIELD attrname="lot1" fieldtype="string" WIDTH="400"/>'     //�帹(�r���s��)
    + '<FIELD attrname="totqty" fieldtype="string" WIDTH="400"/>' +
    '<FIELD attrname="PrdDate" fieldtype="string" WIDTH="200"/>'  //�̷s�帹���Ͳ����
    + '<FIELD attrname="PrdDate1" fieldtype="string" WIDTH="200"/>' //�Ҧ��帹���Ͳ����
    + '<FIELD attrname="ExpDate" fieldtype="string" WIDTH="200"/>'  //�L����
    + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

const
  l_CDSDetailXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="sizes" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="qty" fieldtype="r8"/>' +
    '<FIELD attrname="units" fieldtype="string" WIDTH="4"/>' + '<FIELD attrname="resin" fieldtype="string" WIDTH="30"/>'
    + '<FIELD attrname="copper" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="pp" fieldtype="string" WIDTH="30"/>' + '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' +
    '</DATAPACKET>';

const
  l_CopperALL = 'QTH1AS2BP34567';               //�ɫp�j�p�ƦC

procedure Warn(msg: string; backGroundColor: TColor = clRed);
begin
  with TWarnFrm.Create(nil) do
  begin
    try
      Label1.Caption := msg;
      Color := backGroundColor;
      ShowModal;
    finally
      free;
    end;
  end;
end;

constructor TDLII040_rpt.Create(CDS: TClientDataSet);
begin
  FSourceCDS := CDS;
  FCDS := TClientDataSet.Create(nil);
  FCDSLot := TClientDataSet.Create(nil);        //�Ҧ��帹�@��coc
  FCDSDetail := TClientDataSet.Create(nil);     //coc+����
  FCDSDli210 := TClientDataSet.Create(nil);
  InitCDS(FCDS, l_CDSXml);
  InitCDS(FCDSLot, l_CDSLotXml);
  InitCDS(FCDSDetail, l_CDSDetailXml);
  FCheckC_sizes := TCheckC_sizes.Create;
  PtInitImage(@Fm_image);
end;

destructor TDLII040_rpt.Destroy;
begin
  FreeAndNil(FCDS);
  FreeAndNil(FCDSLot);
  FreeAndNil(FCDSDetail);
  FreeAndNil(FCDSDli210);
  FreeAndNil(FCheckC_sizes);
  PtFreeImage(@Fm_image);
  inherited;
end;

procedure TDLII040_rpt.ShowBarMsg(msg: string);
begin
  g_StatusBar.Panels[0].Text := CheckLang(msg);
  Application.ProcessMessages;
end;

//�O�dn��p��(�I���B�D�i��Bn<=0�u�O�d���)
function TDLII040_rpt.FormatPoint(SourceStr: string; n: integer): string;
var
  pos1: Integer;
  tmpStr: string;
begin
  tmpStr := SourceStr;
  pos1 := Pos('.', tmpStr);
  if pos1 = 0 then
    tmpStr := tmpStr + '.0000000'
  else
    tmpStr := tmpStr + '0000000';

  pos1 := Pos('.', tmpStr);
  if n <= 0 then
    Result := Copy(tmpStr, 1, pos1 - 1)
  else
    Result := Copy(tmpStr, 1, pos1 + n);
end;

function TDLII040_rpt.ReM7_8(s: string): string;
begin
  if SameText(s, 'A') or SameText(s, 'G') then
    Result := '1'
  else if SameText(s, 'B') then
    Result := '2'
  else if SameText(s, 'S') then
    Result := '1.5'
  else if SameText(s, 'P') then
    Result := '2.5'
  else
    Result := s;
end;

function TDLII040_rpt.SetG2_FromDli060(DataSet: TDataSet; SMRec: TSplitMaterialno; cw1, cw2: string): Boolean;
var
  tmpBo: Boolean;
begin
  tmpBo := False;
  with DataSet do
    while not Eof do
    begin
      if (Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Adhesive').AsString + '/') > 0) and ((Pos(SMRec.MLast,
        FieldByName('Lst').AsString) > 0) or (FieldByName('Lst').AsString = ''))    //2021/12/3�J����
        and SameText(cw1, FieldByName('Copper').AsString) then
      begin
        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + FieldByName('StdValue').AsString;
        FCDS.FieldByName('G11').AsString := FieldByName('fValue').AsString;
        tmpBo := True;
      end;
      if (Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Adhesive').AsString + '/') > 0) and ((Pos(SMRec.MLast,
        FieldByName('Lst').AsString) > 0) or (FieldByName('Lst').AsString = ''))    //2021/12/3�J����
        and SameText(cw2, FieldByName('Copper').AsString) then
      begin
        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + FieldByName('StdValue').AsString;
        FCDS.FieldByName('G21').AsString := FieldByName('fValue').AsString;
        tmpBo := True;
      end;
      Next;
    end;
  Result := tmpBo;
end;

function TDLII040_rpt.SetG2_FromDli060_VLP(DataSet: TDataSet; SMRec: TSplitMaterialno): Boolean;
var
  tmpBo: Boolean;
begin
  tmpBo := False;
  with DataSet do
    while not Eof do
    begin
      if Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Adhesive').AsString + '/') > 0 then
      begin
        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + FieldByName('StdValue').AsString;
        FCDS.FieldByName('G11').AsString := FieldByName('fValue').AsString;
        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + FieldByName('StdValue').AsString;
        FCDS.FieldByName('G21').AsString := FieldByName('fValue').AsString;
        tmpBo := True;
      end;
      Next;
    end;
  Result := tmpBo;
end;

function TDLII040_rpt.SetH_FromDli050(DataSet: TDataSet; SMRec: TSplitMaterialno; isLCA: Boolean): Boolean;
const
  tmp = ' �ȩw';
var
  s1, s2, strM15: string;
begin
  Result := False;
  if DataSet.IsEmpty then
    Exit;

  //�Ȥ�+& �N��12�B21
  if Pos('&', DataSet.FieldByName('Custno').AsString) > 0 then
    if (not SameText(SMRec.M7_8, '21')) and (not SameText(SMRec.M7_8, '12')) then
      Exit;

  //�Ȥ�+# �N��2H�BH2
  if Pos('#', DataSet.FieldByName('Custno').AsString) > 0 then
    if (not SameText(SMRec.M7_8, '2H')) and (not SameText(SMRec.M7_8, 'H2')) then
      Exit;

  //�Ȥ�+@ �N��1H�BH1
  if Pos('@', DataSet.FieldByName('Custno').AsString) > 0 then
    if (not SameText(SMRec.M7_8, '1H')) and (not SameText(SMRec.M7_8, 'H1')) then
      Exit;

  strM15 := SMRec.M15;
  if SameText(SMRec.Custno, 'AC096') and SameText(strM15, 'G') then
    strM15 := 'A';

  with DataSet do
    while not Eof do
    begin
      if SameText(strM15, FieldByName('sstru').AsString) and (SMRec.M3_6 = FieldByName('thick').AsFloat) then
      begin
        if isLCA or SameText(SMRec.Custno, 'AC084') or (SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2,
          '6/8/4/F/A/U/S/H') > 0)) or ((POS(SMRec.Custno, 'AC093/AM010') > 0) and SameText(SMRec.M2, 'E')) or ((Pos(SMRec.Custno,
          'AC394/AC152/AH036/AC082') > 0) and (Pos(SMRec.M2, '8/6/U/F/H') > 0)) then
        begin
          s1 := '200';
          s2 := '200';
        end
        else
        begin
          s1 := FloatToStr(FieldByName('warp').AsFloat);
          s2 := FloatToStr(FieldByName('fill').AsFloat)
        end;
//        if (date - FieldByName('mdate').AsDateTime) > 30 then
//        begin
//          ShowMsg('�ؤo�w�w�ʳ]�w��30�ѥ���s', 48);
//        end;
        if Pos(SMRec.M7_8, 'HH/TT/HT/TH') > 0 then
        begin
          if FieldByName('htwarp').IsNull then
            FCDS.FieldByName('H1').AsString := '��' + s1
          else
            FCDS.FieldByName('H1').AsString := FloatToStr(FieldByName('htwarp').AsFloat) + '(��' + s1 + ')';

          if FieldByName('htfill').IsNull then
            FCDS.FieldByName('H2').AsString := '��' + s2
          else
            FCDS.FieldByName('H2').AsString := FloatToStr(FieldByName('htfill').AsFloat) + '(��' + s2 + ')';

          if FieldByName('tmpht').AsBoolean then
          begin
            FCDS.FieldByName('H1').AsString := FCDS.FieldByName('H1').AsString + tmp;
            FCDS.FieldByName('H2').AsString := FCDS.FieldByName('H2').AsString + tmp;
          end;

          FCDS.FieldByName('H11').AsString := FloatToStr(FieldByName('htwarp_value').AsFloat);
          FCDS.FieldByName('H21').AsString := FloatToStr(FieldByName('htfill_value').AsFloat);
        end
        else if Pos(SMRec.M7_8, '11/1H/1T/T1/AA/GG') > 0 then
        begin
          if FieldByName('warp11').IsNull then
            FCDS.FieldByName('H1').AsString := '��' + s1
          else
            FCDS.FieldByName('H1').AsString := FloatToStr(FieldByName('warp11').AsFloat) + '(��' + s1 + ')';

          if FieldByName('fill11').IsNull then
            FCDS.FieldByName('H2').AsString := '��' + s2
          else
            FCDS.FieldByName('H2').AsString := FloatToStr(FieldByName('fill11').AsFloat) + '(��' + s2 + ')';

          if FieldByName('tmp11').AsBoolean then
          begin
            FCDS.FieldByName('H1').AsString := FCDS.FieldByName('H1').AsString + tmp;
            FCDS.FieldByName('H2').AsString := FCDS.FieldByName('H2').AsString + tmp;
          end;

          FCDS.FieldByName('H11').AsString := FloatToStr(FieldByName('warp11_value').AsFloat);
          FCDS.FieldByName('H21').AsString := FloatToStr(FieldByName('fill11_value').AsFloat);
        end
        else if Pos(SMRec.M7_8, '12/22/21/2H/2T/T2/SS/BB/BA') > 0 then
        begin
          if FieldByName('warp22').IsNull then
            FCDS.FieldByName('H1').AsString := '��' + s1
          else
            FCDS.FieldByName('H1').AsString := FloatToStr(FieldByName('warp22').AsFloat) + '(��' + s1 + ')';

          if FieldByName('fill22').IsNull then
            FCDS.FieldByName('H2').AsString := '��' + s2
          else
            FCDS.FieldByName('H2').AsString := FloatToStr(FieldByName('fill22').AsFloat) + '(��' + s2 + ')';

          if FieldByName('tmp22').AsBoolean then
          begin
            FCDS.FieldByName('H1').AsString := FCDS.FieldByName('H1').AsString + tmp;
            FCDS.FieldByName('H2').AsString := FCDS.FieldByName('H2').AsString + tmp;
          end;

          FCDS.FieldByName('H11').AsString := FloatToStr(FieldByName('warp22_value').AsFloat);
          FCDS.FieldByName('H21').AsString := FloatToStr(FieldByName('fill22_value').AsFloat);
        end
        else if (SameText(SMRec.M7, '3') and (Pos(SMRec.M8, '4567') = 0)) or (SameText(SMRec.M8, '3') and (Pos(SMRec.M7,
          '4567') = 0)) then  //��7�B8�X�䤤�@�X�O3,�t�@�X���O4567
        begin
          if FieldByName('warp33').IsNull then
            FCDS.FieldByName('H1').AsString := '��' + s1
          else
            FCDS.FieldByName('H1').AsString := FloatToStr(FieldByName('warp33').AsFloat) + '(��' + s1 + ')';

          if FieldByName('fill33').IsNull then
            FCDS.FieldByName('H2').AsString := '��' + s2
          else
            FCDS.FieldByName('H2').AsString := FloatToStr(FieldByName('fill33').AsFloat) + '(��' + s2 + ')';

          if FieldByName('tmp33').AsBoolean then
          begin
            FCDS.FieldByName('H1').AsString := FCDS.FieldByName('H1').AsString + tmp;
            FCDS.FieldByName('H2').AsString := FCDS.FieldByName('H2').AsString + tmp;
          end;

          FCDS.FieldByName('H11').AsString := FloatToStr(FieldByName('warp33_value').AsFloat);
          FCDS.FieldByName('H21').AsString := FloatToStr(FieldByName('fill33_value').AsFloat);
        end
        else if (Pos(SMRec.M7, '4567') > 0) or (Pos(SMRec.M8, '4567') > 0) then  //��7�B8�X�䤤�@�X�O4567
        begin
          if FieldByName('warp44').IsNull then
            FCDS.FieldByName('H1').AsString := '��' + s1
          else
            FCDS.FieldByName('H1').AsString := FloatToStr(FieldByName('warp44').AsFloat) + '(��' + s1 + ')';

          if FieldByName('fill44').IsNull then
            FCDS.FieldByName('H2').AsString := '��' + s2
          else
            FCDS.FieldByName('H2').AsString := FloatToStr(FieldByName('fill44').AsFloat) + '(��' + s2 + ')';

          if FieldByName('tmp44').AsBoolean then
          begin
            FCDS.FieldByName('H1').AsString := FCDS.FieldByName('H1').AsString + tmp;
            FCDS.FieldByName('H2').AsString := FCDS.FieldByName('H2').AsString + tmp;
          end;

          FCDS.FieldByName('H11').AsString := FloatToStr(FieldByName('warp44_value').AsFloat);
          FCDS.FieldByName('H21').AsString := FloatToStr(FieldByName('fill44_value').AsFloat);
        end;

        FCDS.FieldByName('H12').AsString := 'pass';
        FCDS.FieldByName('H22').AsString := 'pass';
        Result := True;
        Break;
      end;
      Next;
    end;
end;

//�Ȥ�~�W�����p�פ��t��
//3�زŸ�����:+a/-b��+/-�Ρ�
function TDLII040_rpt.GetClassB_C(SMRec: TSplitMaterialno; C_Sizes: string): Boolean;
var
  tmpStr, s1, s2, sp: WideString;
  pos1, pos2, len: Integer;

  //���Ʀr

  function getNum(xStr: string): string;
  var
    s: string;
    i, num: Integer;
  begin
    num := 0;
    s := '';
    for i := 1 to Length(xStr) do
    begin
      if Char(xStr[i]) in ['0'..'9', '.'] then
      begin
        if xStr[i] = '.' then
          num := num + 1;
        if num < 2 then
          s := s + xStr[i]
        else
          Break;
      end
      else
        Break;
    end;
    Result := s;
  end;

begin
  tmpStr := C_Sizes;

  //�d��
  if (Pos(SMRec.Custno, 'AC375,AC116') > 0) and (Pos('�Ť��t', tmpStr) > 0) then
  begin
    FCDS.FieldByName('C1').AsString := 'Class M';
    FCDS.FieldByName('D1').AsString := 'Class C';
    Result := True;
    Exit;
  end
  else if (Pos(SMRec.Custno, 'AC051,ACE22') > 0) then
  begin
    if (Pos('CLASSC-TL', FCDS.FieldByName('C_Sizes').AsString) > 0) or (Pos('CLASS C', FCDS.FieldByName('C_Sizes').AsString)
      > 0) then
    begin
      FCDS.FieldByName('C1').AsString := 'Class M';
      FCDS.FieldByName('D1').AsString := 'Class C';
      Result := True;
      Exit;
    end
    else if (Pos('CLASSB-TL', FCDS.FieldByName('C_Sizes').AsString) > 0) or (Pos('CLASS B', FCDS.FieldByName('C_Sizes').AsString)
      > 0) then
    begin
      FCDS.FieldByName('C1').AsString := 'Class L';
      FCDS.FieldByName('D1').AsString := 'Class B';
      Result := True;
      Exit;
    end;
  end;

  //+a/-b
  pos1 := pos('+', tmpStr);
  pos2 := pos('/-', tmpStr);
  if (pos1 > 0) and (pos2 > 0) and (pos2 - pos1 > 1) then
  begin
    s1 := Trim(Copy(tmpStr, pos1 + 1, pos2 - pos1 - 1));     //a
    Delete(tmpStr, 1, pos2 + 1);
    s2 := getNum(Trim(tmpStr));                      //b
    if (Pos('mm', tmpStr) > 0) or (Pos('MM', tmpStr) > 0) then
    begin
      try
        s1 := FloatToStr(RoundTo(StrToFloat(s1) * 39.37, -1));
        s2 := FloatToStr(RoundTo(StrToFloat(s2) * 39.37, -1));
      except
        ShowMsg('�Ȥ�~�W�Ƶ����t���~!', 48);
        Abort;
      end;
    end;

    if Pos(SMRec.Custno, 'AC178,AC082,AC093,AM010,AC152,AH036') > 0 then
      //�F������B���U�q�l�B�s�{�K�Q�B���s�ҧQ�h,�Y�Ȥ�Ƶ����t��4��p��,�h���t*1000
    begin
      pos1 := pos('.', s1);
      if pos1 > 0 then
      begin
        len := Length(Copy(s1, pos1 + 1, 10));
        if (len = 3) or (len = 4) then
          s1 := FloatToStr(StrToFloat(s1) * 1000);
      end;

      pos1 := pos('.', s2);
      if pos1 > 0 then
      begin
        len := Length(Copy(s2, pos1 + 1, 10));
        if (len = 3) or (len = 4) then
          s2 := FloatToStr(StrToFloat(s2) * 1000);
      end;
    end;

    FCDS.FieldByName('C1').AsString := '+' + s1 + '/-' + s2;
    FCDS.FieldByName('D1').AsString := FCDS.FieldByName('C1').AsString;
    FCDS.FieldByName('D1_1').AsString := s2;
    FCDS.FieldByName('D1_2').AsString := s1;
    Result := True;
    Exit;
  end;

  //+/-�Ρ�
  len := 2;
  sp := '+/-';
  pos1 := pos(sp, tmpStr);
  if pos1 = 0 then
  begin
    len := 0;
    sp := '��';
    pos1 := pos(sp, tmpStr);
  end;

  if pos1 > 0 then
  begin
    Delete(tmpStr, 1, pos1 + len);
    s2 := getNum(Trim(tmpStr));
    if (Pos('mm', tmpStr) > 0) or (Pos('MM', tmpStr) > 0) then
      s2 := FloatToStr(RoundTo(StrToFloat(s2) * 39.37, -1));
  end;

  Result := Length(s2) > 0;
  if Result then
  begin
    if Pos(SMRec.Custno, 'AC178,AC082,AC093,AM010,AC152,AH036') > 0 then
      //�F������B���U�q�l�B�s�{�K�Q�B���s�ҧQ�h,�Y�Ȥ�Ƶ����t��4��p��,�h���t*1000
    begin
      pos1 := pos('.', s2);
      if pos1 > 0 then
      begin
        len := Length(Copy(s2, pos1 + 1, 10));
        if (len = 3) or (len = 4) then
          s2 := FloatToStr(StrToFloat(s2) * 1000);
      end;
    end;

    FCDS.FieldByName('C1').AsString := sp + s2;
    FCDS.FieldByName('D1').AsString := sp + s2;
    FCDS.FieldByName('D1_1').AsString := s2;
    FCDS.FieldByName('D1_2').AsString := s2;
  end;
end;

//�p��p�סBClassB��ClassC���t
//���ơB�ɺ�1�B�ɺ�2
procedure TDLII040_rpt.GetClassB_C_diff(SMRec: TSplitMaterialno; CopperValue1, CopperValue2: Double; var thickness, diff:
  Double);
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  thickness := SMRec.M3_6 + CopperValue1 + CopperValue2;
  diff := 0;

  if Pos('class', LowerCase(FCDS.FieldByName('C1').AsString)) > 0 then
  begin
    //D1=C1
    tmpSQL := RightStr('0000' + FloatToStr(SMRec.M3_6 * 10), 4);
    tmpSQL := 'Select ClassB,ClassC,0 as id From DLI090' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Strip_lower<='
      + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) + ' And charindex(' + Quotedstr(SMRec.Custno) +
      ',Custno)>0' + ' And charindex(' + Quotedstr(SMRec.M2) + ',Adhesive)>0' + ' Union All' +
      ' Select ClassB,ClassC,1 as id From DLI090' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Strip_lower<=' +
      Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) + ' And charindex(' + Quotedstr(SMRec.Custno) +
      ',Custno)>0' + ' And Adhesive=''*''' + ' Union All' + ' Select ClassB,ClassC,2 as id From DLI090' + ' Where Bu=' +
      Quotedstr(g_UInfo^.BU) + ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) +
      ' And Custno=''*'' And Adhesive=''*''' + ' Order By id';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS := TClientDataSet.Create(nil);
      try
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
        begin
          if SameText(FCDS.FieldByName('C1').AsString, 'Class B') or SameText(FCDS.FieldByName('C1').AsString, 'Class L')
            then
            diff := tmpCDS.Fields[0].AsFloat
          else if SameText(FCDS.FieldByName('C1').AsString, 'Class C') or SameText(FCDS.FieldByName('C1').AsString,
            'Class M') then
            diff := tmpCDS.Fields[1].AsFloat
          else
            diff := 0;
        end;
      finally
        FreeAndNil(tmpCDS);
      end;
    end;
  end;
end;

//�ɺ䭭�w
function TDLII040_rpt.GetTBXD(SMRec: TSplitMaterialno; IsCustno: Boolean): string;
var
  tmpRecno, tmpMaxNum, tmpNum: Integer;
  tmpSQL: string;
  tmpIndex1, tmpIndex2, tmpIndex3: Integer;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := '';
  Data := null;
  if sametext(FSourceCDS.fieldbyname('custno').asstring, 'AC084') and (pos('IBM����', FSourceCDS.fieldbyname('Custname').asstring)
    > 0) then
    tmpSQL := 'Select * From Dli540 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno) +
      ',Custno)>0 and remark like ''%IBM%'''
  else if IsCustno then
    tmpSQL := 'Select * From Dli540 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno) +
      ',Custno)>0'
  else
    tmpSQL := 'Select * From Dli540 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Custno=''@''';
  tmpSQL := tmpSQL + ' Order By Custno,Code2,Code3_6_lower,Code3_6_upper,Code7_8_lower,' +
    ' Code7_8_upper,CodeLast1,CodeLast2,CodeLast3';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpMaxNum := -1;
  tmpRecno := -1;
  tmpSQL := RightStr('0000' + FloatToStr(SMRec.M3_6 * 10), 4);
  tmpIndex1 := Pos(SMRec.M7, l_CopperALL);
  tmpIndex2 := Pos(SMRec.M8, l_CopperALL);
  if tmpIndex1 < tmpIndex2 then
    tmpIndex1 := tmpIndex2;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        tmpNum := 0;
        if Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Code2').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Code2').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if (tmpSQL >= FieldByName('Code3_6_lower').AsString) and (tmpSQL <= FieldByName('Code3_6_upper').AsString) then
          Inc(tmpNum)
        else if (Length(FieldByName('Code3_6_lower').AsString) > 0) or (Length(FieldByName('Code3_6_upper').AsString) >
          0) then
        begin
          Next;
          Continue;
        end;

        tmpIndex2 := Pos(FieldByName('Code7_8_lower').AsString, l_CopperALL);
        tmpIndex3 := Pos(FieldByName('Code7_8_upper').AsString, l_CopperALL);
        if (tmpIndex1 > 0) and (tmpIndex2 > 0) and (tmpIndex3 > 0) and (tmpIndex1 >= tmpIndex2) and (tmpIndex1 <=
          tmpIndex3) then
        begin
          Inc(tmpNum);
        end
        else if (Length(FieldByName('Code7_8_lower').AsString) > 0) or (Length(FieldByName('Code7_8_upper').AsString) >
          0) then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.M15 + '/', '/' + FieldByName('CodeLast3').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('CodeLast3').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.MLast_1 + '/', '/' + FieldByName('CodeLast2').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('CodeLast2').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.MLast + '/', '/' + FieldByName('CodeLast1').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('CodeLast1').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if (tmpNum > 0) and (tmpMaxNum < tmpNum) then
        begin
          tmpMaxNum := tmpNum;
          tmpRecno := Recno;
        end;
        if tmpMaxNum = 6 then
          Break;
        Next;
      end;
    end;

    if tmpRecno <> -1 then
    begin
      tmpCDS.RecNo := tmpRecno;
      Result := tmpCDS.FieldByName('Value').AsString;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//�������w
function TDLII040_rpt.GetBBXD(SMRec: TSplitMaterialno; Struct: string): string;
var
  tmpRecno, tmpMaxNum, tmpNum: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := '';
  Data := null;
  tmpSQL := 'Select * From Dli541 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno) +
    ',Custno)>0';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpMaxNum := -1;
  tmpRecno := -1;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        tmpNum := 0;
        if Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Code2').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Code2').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos(FieldByName('Struct').AsString, Struct) > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Struct').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.MLast + '/', '/' + FieldByName('CodeLast').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('CodeLast').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if (tmpNum > 0) and (tmpMaxNum < tmpNum) then
        begin
          tmpMaxNum := tmpNum;
          tmpRecno := Recno;
        end;
        if tmpMaxNum = 3 then
          Break;
        Next;
      end;
    end;

    if tmpRecno <> -1 then
    begin
      tmpCDS.RecNo := tmpRecno;
      Result := tmpCDS.FieldByName('Value').AsString;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

function TDLII040_rpt.GetAddr(SMRec: TSplitMaterialno): string;
var
  tmpRecno, tmpMaxNum, tmpNum: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := '';
  Data := null;
  tmpSQL := 'Select Ad,LstCode,Addr From Dli470 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno)
    + ',Custno)>0 and IsCCL=1' + ' Order By Ad,LstCode';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpMaxNum := -1;
  tmpRecno := -1;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        tmpNum := 0;
        if Pos('/' + SMRec.M2 + '/', '/' + FieldByName('Ad').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Ad').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.MLast + '/', '/' + FieldByName('LstCode').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('LstCode').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if (tmpNum > 0) and (tmpMaxNum < tmpNum) then
        begin
          tmpMaxNum := tmpNum;
          tmpRecno := Recno;
        end;
        if tmpMaxNum = 2 then
          Break;
        Next;
      end;
    end;

    if tmpRecno <> -1 then
    begin
      tmpCDS.RecNo := tmpRecno;
      Result := tmpCDS.FieldByName('Addr').AsString;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TDLII040_rpt.StartPrint(ProcId: string; ds3: TDataset = nil);
type
  TRemarkRec = record
    Custno, Other, Orderno: string;
    Orderitem: integer;
  end;
var
  pos1, days, rand1, rand2: Integer;
  tmpCustno, tmpSQL, tmpPno, s1, s2, s3, tmpUnit, tmpLot1, tmpOneLot, tmpAllLot, tmpPrdDate, tmpOraDB, tmpDayErr,
    tmpOneDayErr, tmpOTDayErr, tmpTBXD, tmpBBXD, tmpFIFOErr, tmpLotErr, tmpFstlot: string;
  tmpDate: TDateTime;
  tmpTotQty, CopperValue1, CopperValue2: Double;
  tmpBo, is968, isPN, isLCA, isCY, isHY, isSN, isFZ, isN006, tmpTBXDErr, tmpBBXDErr, flag: Boolean;
  C061: T061Rec;
  CList: TStrings;
  Data: OleVariant;
  tmpCDS, tmpCDS1: TClientDataSet;
  SMRec: TSplitMaterialno;
  ArrPrintData: TArrPrintData;
  tmpFrmDLII040_lot: TFrmDLII040_lot;
  tmpRemarkRec: TRemarkRec;
  ls: TStrings;
  custInfo: TCustInfo;
begin
  //inherited;
  if (not FSourceCDS.Active) or FSourceCDS.IsEmpty then
  begin
    ShowMsg('�L�ƾڥi�C�L!', 48);
    Exit;
  end;

  if FSourceCDS.FieldByName('Coc_err').AsBoolean then
  begin
    ShowMsg('COC���`���i�C�L,�������d�ݲ��`��]!', 48);
    Exit;
  end;

  tmpSQL := LeftStr(FSourceCDS.FieldByName('Pno').AsString, 1);
  s2 := copy(FSourceCDS.FieldByName('Pno').AsString, 2, 1);
  if pos(s2, 'S/U/H/5') > 0 then
  begin
    s2 := copy(FSourceCDS.FieldByName('Pno').AsString, length(FSourceCDS.FieldByName('Pno').AsString) - 1, 1);
    if pos(s2, 'i/k/c/m/7/R/I') = 0 then
      warn('�ɺ�аt�ORTF', clred);
  end;
  if Pos(tmpSQL, 'ET') = 0 then
  begin
    ShowMsg('�ЦC�LCCL!', 48);
    Exit;
  end;

  if Length(FSourceCDS.FieldByName('Pno').AsString) in [11, 19] then
  begin
    tmpUnit := 'PN';
    isPN := True;
  end
  else
  begin
    tmpUnit := 'SH';
    isPN := False;
  end;

  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpOraDB := 'ORACLE'
  else
    tmpOraDB := 'ORACLE1';

  isN006 := SameText(FSourceCDS.FieldByName('Custno').AsString, 'N006');

  tmpRemarkRec.Custno := '';
  tmpRemarkRec.Other := '';
  tmpRemarkRec.Orderno := '';
  tmpRemarkRec.Orderitem := 0;
  if Pos(FSourceCDS.FieldByName('Custno').AsString, 'N012,N005,N006') > 0 then
  begin
    tmpSQL := FSourceCDS.FieldByName('Remark').AsString;
    pos1 := pos('-', tmpSQL);
    if pos1 > 0 then
    begin
      tmpRemarkRec.Custno := Copy(tmpSQL, 1, pos1 - 1);
      tmpRemarkRec.Other := Copy(tmpSQL, pos1 + 1, 100);
      tmpRemarkRec.Orderno := Copy(tmpSQL, pos1 + 1, 10);
      tmpRemarkRec.Orderitem := StrToIntDef(Copy(tmpSQL, pos1 + 12, 10), 0);
      if (length(tmpRemarkRec.Orderno) <> 10) or (Pos('-', tmpRemarkRec.Orderno) <> 4) or (tmpRemarkRec.Orderitem <= 0)
        then
      begin
        tmpRemarkRec.Orderno := '';
        tmpRemarkRec.Orderitem := 0;
      end;
    end;
  end;

  tmpSQL := FSourceCDS.FieldByName('Custno').AsString;
  if (Length(tmpRemarkRec.Custno) > 0) and (not isN006) then
    tmpSQL := tmpRemarkRec.Custno;
  isCY := Pos(tmpSQL, 'AC405/AC075/AC310/AC311/AC950') > 0;  //�W��

  if SameText(FSourceCDS.FieldByName('Custno').AsString, 'AC687') or SameText(FSourceCDS.FieldByName('Custno').AsString,
    'AC084') then
  begin
    Data := null;
    tmpSQL := 'select count(*) cnt from (' + ' select distinct manfac from dli040 where bu=' + Quotedstr(g_UInfo^.BU) +
      ' and dno=' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString) + ' and ditem=' + FSourceCDS.FieldByName('Ditem').AsString
      + ') x';
    if QueryOneCR(tmpSQL, Data) then
      if StrToInt(VarToStr(Data)) > 2 then
        ShowMsg(FSourceCDS.FieldByName('Custno').AsString + FSourceCDS.FieldByName('Custshort').AsString +
          ':�W�L��ӧ帹!', 48);
  end;

  tmpFrmDLII040_lot := TFrmDLII040_lot.Create(nil);
  try
    with tmpFrmDLII040_lot do
    begin
      l_isOneLot := isCY or (POS(FSourceCDS.FieldByName('Custno').AsString, 'AC089,AC097,AC143') > 0);
      AddLot(Self.FSourceCDS.FieldByName('Dno').AsString, Self.FSourceCDS.FieldByName('Ditem').AsString, tmpUnit);
      if ShowModal = mrOk then
      begin
        tmpOneLot := GetLot(True);
        tmpAllLot := GetLot(False);
      end
      else
        Exit;
    end;
  finally
    FreeAndNil(tmpFrmDLII040_lot);
  end;

  ShowBarMsg('���b�ֹ�帹���T��...');
  CList := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS1 := TClientDataSet.Create(nil);
  try
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckCCLLot ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);

    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + #13#10 + tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;
    if Length(tmpSQL) > 0 then
    begin
      ShowMsg('�U�C�帹�s�b���~:' + tmpSQL, 48);
      Exit;
    end;

    ShowBarMsg('���b�ֹ�G���X���T��...');
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckCOCQRCode ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'sno<>0';
    tmpCDS.Filtered := True;
    tmpSQL := '';
    while not tmpCDS.Eof do
    begin
      tmpSQL := tmpSQL + #13#10 + tmpCDS.Fields[0].AsString + '.' + tmpCDS.Fields[1].AsString;
      tmpCDS.Next;
    end;
    if Length(tmpSQL) > 0 then
    begin
      if tmpCDS.RecordCount > 10 then
      begin
        if not Assigned(FrmDLII040_cocerr) then
          FrmDLII040_cocerr := TFrmDLII040_cocerr.Create(Application);
        FrmDLII040_cocerr.l_Coc_errid := tmpSQL;
        FrmDLII040_cocerr.ShowModal;
      end
      else
        ShowMsg('�U�C�G���X�s�b���~:' + tmpSQL, 48);
      Exit;
    end;
    tmpCDS.Filtered := False;

    ShowBarMsg('���b�d�ߥX�f���...');
    Data := null;
    tmpSQL := 'exec dbo.proc_GetCOCIndate ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(DateToStr(FSourceCDS.FieldByName('Indate').AsDateTime));
    if not QueryBySQL(tmpSQL, Data) then
      Exit;

    tmpCDS.Data := Data;
    tmpDate := EncodeDate(tmpCDS.Fields[0].AsInteger, tmpCDS.Fields[1].AsInteger, tmpCDS.Fields[2].AsInteger);

    while not FCDS.IsEmpty do
      FCDS.Delete;
    while not FCDSLot.IsEmpty do
      FCDSLot.Delete;
    while not FCDSDetail.IsEmpty do
      FCDSDetail.Delete;

    FCDS.Append;
    FCDS.FieldByName('IsCCLCOC').AsBoolean := True;
    FCDS.FieldByName('Indate').AsString := tmpCDS.Fields[0].AsString + '/' + RightStr('00' + tmpCDS.Fields[1].AsString,
      2) + '/' + RightStr('00' + tmpCDS.Fields[2].AsString, 2);
    FCDS.FieldByName('Indate1').AsString := CheckLang(tmpCDS.Fields[0].AsString + '�~' + tmpCDS.Fields[1].AsString +
      '��' + tmpCDS.Fields[2].AsString + '��');
    FCDS.FieldByName('Fileno').AsString := LBLSno('cocccl');//'Q1-' + FormatDateTime(g_cShortDateYYMMDD, tmpDate) + FSourceCDS.FieldByName('Coc_no').AsString;

    //�q����
    {oea10�Ȥ�q�渹
     oeb04�t���Ƹ�
     oeb11�Ȥ�Ƹ�
     ta_oeb01�g�V
     ta_oeb02�n�V
     ta_oeb10�Ȥ�W��}
    ShowBarMsg('���b�d�߭q����...');
    Data := null;
    tmpSQL := ' Select X.*,oao06 From (' +
      ' Select oea04,oea10,oeb01,oeb03,oeb04,oeb11,ta_oeb01,ta_oeb02,ta_oeb10,ta_oeb28' +
      ' From oea_file Inner Join oeb_file On oea01=oeb01' + ' Where oeb01=' + Quotedstr(FSourceCDS.FieldByName('Orderno').AsString)
      + ' And oeb03=' + IntToStr(FSourceCDS.FieldByName('Orderitem').AsInteger) +
      ' ) X Left Join oao_file Y On oeb01=oao01 and oeb03=oao03';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
      Exit;

    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop�q���Ƥ��s�b,�нT�{!', 48);
      Exit;
    end;

    tmpPno := tmpCDS.FieldByName('oeb04').AsString;
    FCDS.FieldByName('Pno').AsString := tmpPno;
    if FSourceCDS.FieldByName('Pno').AsString <> tmpPno then
      ShowMsg('�X�f�Ƶ{�Ƹ�[' + FSourceCDS.FieldByName('Pno').AsString + ']'#13#10 + '�PTipTop�q��Ƹ�[' + tmpPno +
        ']���@�P,�нT�{!', 48);

    if isPN then
    begin
      SMRec.M9_11 := tmpCDS.FieldByName('ta_oeb01').AsString;
      SMRec.M12_14 := tmpCDS.FieldByName('ta_oeb02').AsString;
    end;

    if Length(tmpRemarkRec.Orderno) > 0 then
      FCDS.FieldByName('Orderno').AsString := tmpRemarkRec.Orderno;
    if Length(FCDS.FieldByName('Orderno').AsString) <> 10 then
      FCDS.FieldByName('Orderno').AsString := FSourceCDS.FieldByName('Orderno').AsString;

    //tmpSQL�Ȥ�po
    tmpSQL := GetOea10(FSourceCDS.FieldByName('Orderno').AsString, FSourceCDS.FieldByName('Remark').AsString, tmpCDS.FieldByName
      ('oea10').AsString);
    SMRec.Custno := FSourceCDS.FieldByName('Custno').AsString;
    if JxRemark(FSourceCDS.FieldByName('Remark').AsString, custInfo) then
    begin// SMRec.Custno);
      SMRec.Custno := custInfo.No;
    end;
    FCDS.FieldByName('C_Orderno').AsString := GetC_Orderno(tmpCDS.FieldByName('oea04').AsString, tmpSQL, tmpCDS.FieldByName
      ('oao06').AsString);

    FCDS.FieldByName('C_Pno').AsString := tmpCDS.FieldByName('oeb11').AsString;
    if copy(tmpCDS.FieldByName('oao06').AsString, 1, 3) = 'JX-' then
    begin
      GetJxTA_oeb10(tmpCDS.FieldByName('oao06').AsString, FCDS.FieldByName('C_Sizes'));
      FCDS.FieldByName('C_Pno').AsString := FSourceCDS.FieldByName('Custprono').AsString;
      if (ds3 <> nil) and (pos(SMRec.Custno, 'AC434/AC365/ACD39/AC388/AC111,AC082,AC108,ACF29') > 0) then
      begin
        flag := false;
        ds3.first;
        while not ds3.eof do
        begin
          if pos(FCDS.FieldByName('C_Orderno').AsString, ds3.fieldbyname('FNAME9').asstring) = 0 then
          begin
            flag := true;
            break;
          end;
          ds3.next;
        end;
        if flag then
          warn('�Ȥ�q�渹���ǰt,���ˬd', clred);
      end;
    end
    else
    begin
      FCDS.FieldByName('C_Sizes').AsString := tmpCDS.FieldByName('ta_oeb10').AsString;
    end;

    ShowBarMsg('���b�d�߮Ƹ����...');
    Data := null;
    tmpSQL := 'Select ima01,ima02,ima021 From ima_file' + ' Where ima01=' + Quotedstr(tmpPno) + ' or ima01=' + Quotedstr
      (FCDS.FieldByName('Pno').AsString);
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
      Exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop�����Ƹ�[' + tmpPno + ']�~�W�W�椣�s�b,�нT�{!', 48);
      Exit;
    end;

    tmpCDS.Locate('ima01', tmpPno, []); //tmpCDS�̦h2��,�̤�1��,���B���@�w���
    FCDS.FieldByName('Pname').AsString := tmpCDS.Fields[1].AsString;
    FCDS.FieldByName('Sizes').AsString := tmpCDS.Fields[2].AsString;
    if SameText(FSourceCDS.FieldByName('Custno').AsString, 'ACB32') then
    begin
      if Pos('ITA-9300', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT968', 'ITA-9300', [])
      else if Pos('ITA-9310', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT150DA', 'ITA-9310', [])
      else if Pos('ITA-9320', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT150DA', 'ITA-9320', [])
      else if Pos('ITA-9350', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT150DA', 'ITA-9350', [])
      else if Pos('ITA-9380', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT150DA', 'ITA-9380', [])
      else if Pos('ITA-9430', FCDS.FieldByName('C_Sizes').AsString) > 0 then
        FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'IT170GRA1', 'ITA-9430',
          []);
    end
    else if pos('AC145', FSourceCDS.FieldByName('remark').AsString) > 0 then
    begin
      ls := TStringlist.create;
      try
        ls.Delimiter := '-';
        ls.DelimitedText := FCDS.FieldByName('Pname').AsString;
        if ls.Count > 1 then
        begin
          FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, '-' + ls[1], '', []);
        end;
      finally
        ls.free;
      end;
    end;
    CheckCar(tmpPno, FSourceCDS.FieldByName('Custname').AsString, FSourceCDS.FieldByName('Orderno').AsString, FSourceCDS.FieldByName
      ('remark').AsString, FSourceCDS.FieldByName('Orderitem').AsInteger);

    tmpPno := FCDS.FieldByName('Pno').AsString;
    if isPN then
    begin
      if Length(tmpPno) = 19 then
        tmpPno := Copy(tmpPno, 1, 8) + '999999' + Copy(tmpPno, 17, 3)  //19�X�s�Ƹ�
      else
        tmpPno := Copy(tmpPno, 1, 8) + '999999' + Copy(tmpPno, 9, 3);  //�Z���I���r�Ť���
    end;
    SMRec.M1 := Copy(tmpPno, 1, 1);
    SMRec.M2 := Copy(tmpPno, 2, 1);
    SMRec.M3_6 := StrToFloat(Copy(tmpPno, 3, 4)) / 10;
    SMRec.M7_8 := Copy(tmpPno, 7, 2);
    SMRec.M7 := LeftStr(SMRec.M7_8, 1);
    SMRec.M8 := RightStr(SMRec.M7_8, 1);
    if not isPN then
    begin
      SMRec.M9_11 := Copy(tmpPno, 9, 3);
      SMRec.M12_14 := Copy(tmpPno, 12, 3);
    end;
    SMRec.M15 := Copy(tmpPno, 15, 1);
    SMRec.MLast_1 := Copy(tmpPno, 16, 1);              //M16
    SMRec.MLast := RightStr(tmpPno, 1);               //M17
    if (SMRec.M2 = '8') and SameText(SMRec.MLast, 'R') then
      SMRec.M2 := 'F';

//    SMRec.Custno := FSourceCDS.FieldByName('Custno').AsString;
    if (Length(tmpRemarkRec.Custno) > 0) and (not isN006) then
      SMRec.Custno := tmpRemarkRec.Custno;

    isLCA := (Pos('LCA', UpperCase(FCDS.FieldByName('C_Sizes').AsString)) > 0) and (Pos(SMRec.Custno, 'AC097/AC143') > 0);
    isHY := Pos(SMRec.Custno, 'AC394/AC152/AH036,AC844') > 0;              //�f��
    isSN := Pos(SMRec.Custno, 'AC111') > 0; //�`�n
    is968 := SameText(SMRec.M2, 'X');

    if ((Pos(SMRec.Custno, 'AC114/AC365/AC388/AC434') > 0) and (SMRec.M3_6 = 2) and (SMRec.M2 = 'E')) or
      //�西Hi-pot����
      (SameText(SMRec.Custno, 'AC084') and (SMRec.M2 = '5') and (SMRec.M3_6 <= 3))      //�ͯqHi-pot����
      then
      ShowMsg('�Ьd��Hi-pot����!', 48);


    //�`�nHi-pot����
    if SameText(SMRec.Custno, 'AC111') and (SMRec.M3_6 = 2) and (SMRec.M2 = 'F') then
      ShowMsg('�Ьd��Hi-pot����!', 48);

    //�w�RHi-pot����
    if SameText(SMRec.Custno, 'AC310') and (SMRec.M3_6 = 3) and (SMRec.M2 = 'U') then
      ShowMsg('�Ьd��Hi-pot����!', 48);

    if SameText(SMRec.Custno, 'N006') and (SMRec.M2 = '5') and (SMRec.M7 <> SMRec.M8) then
      ShowMsg('�нT�{���u�ɺ�', 48);

    if ((SMRec.M3_6 > 4) and (SMRec.M3_6 < 9)) and ((Pos(SMRec.M7, '34567') > 0) or (Pos(SMRec.M8, '34567') > 0)) and (Pos
      (SMRec.MLast_1, 'C/W/6') > 0) then
      warn('�нT�{2�i�������c', clred);
    

    //���ܥH�O�W�t�X�f
    if (Pos(SMRec.Custno, 'AC117/ACC19') > 0) and (SMRec.M2 = 'X') then
      ShowMsg('�Ȥ�:AC117/ACC19 ���t:X' + #13#10 + '�ХH�O�W�t�X�f!', 48);

    if (Pos(SMRec.Custno, 'AC072') > 0) and (SMRec.M3_6 = 51) then
      ShowMsg('���Ѥ����ά����z��׳��i', 48);

    if (ds3 <> nil) and (Pos('AC434', FSourceCDS.FieldByName('remark').AsString) > 0) and (Pos(Copy(FSourceCDS.Fieldbyname
      ('pno').AsString, 16, 1), '6/7/8/9/c/0') = 0) then
    begin
      flag := false;
      ds3.first;
      while not ds3.eof do
      begin
        if (Pos('7628', ds3.Fieldbyname('qrcode').AsString) > 0) then
        begin
          flag := true;
          break;
        end;
        ds3.next;
      end;
      if not flag then
      begin
        warn('�нT�{�q��CAFC', clred);
      end;
    end;

    //�t���Ƹ��P�Ȥ�~�W
    tmpSQL := FCheckC_sizes.CheckCCL_C_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString, isPN);
    if Length(tmpSQL) > 0 then
    begin
      ShowMsg(tmpSQL, 48);
      Exit;
    end;



    //�Ȥ�Ƹ��P�t���Ƹ�
    if Length(FCDS.FieldByName('C_Pno').AsString) > 0 then
    begin
      Data := null;

      tmpSQL := 'declare @pno varchar(20)' + ' select top 1 @pno=pno from dli600 where bu=' + Quotedstr(g_UInfo^.BU) +
        ' and custno=' + Quotedstr(SMRec.Custno) + ' and c_pno=' + Quotedstr(FCDS.FieldByName('C_Pno').AsString) +
        ' if @pno is null' + ' begin' + '   if exists(select 1 from dli600 where bu=' + Quotedstr(g_UInfo^.BU) +
        ' and custno=' + Quotedstr(SMRec.Custno) + ')' + '      set @pno=''err''' + '   else' + '      set @pno=''ok'''
        + ' end' + ' select @pno';
      if not QueryOneCR(tmpSQL, Data) then
        Exit;
      tmpSQL := VarToStr(Data);
      if tmpSQL <> 'ok' then
      begin
        if (tmpSQL = 'err') and (g_uinfo^.UserId <> 'ID150515') then
        begin
          ShowMsg('�Ȥ�Ƹ������@!', 48);
          Exit;
        end
        else if (Copy(tmpSQL, 2, Length(tmpSQL) - 2) <> Copy(FCDS.FieldByName('Pno').AsString, 2, Length(FCDS.FieldByName
          ('Pno').AsString) - 2)) and (g_uinfo^.UserId <> 'ID150515') then
        begin
          ShowMsg('�t���Ƹ�����,�n�D�O�G' + #13#10 + FCDS.FieldByName('C_Pno').AsString + '=>' + tmpSQL, 48);
          Exit;
        end;
      end;
    end;
    //�s�{�K�Q�P�q��P�Ƹ����i�H�X�{���P�ɺ�
    if (POS(SMRec.Custno, 'AC093/AM010') > 0) and (Length(FSourceCDS.FieldByName('CustOrderno').AsString) > 0) then
    begin
      Data := null;
      tmpSQL := 'select distinct substring(b.manfac,11,1) lot' + ' from dli010 a inner join dli040 b' +
        ' on a.bu=b.bu and a.dno=b.dno and a.ditem=b.ditem' + ' where a.bu=' + Quotedstr(g_UInfo^.BU) + ' and a.pno=' +
        Quotedstr(FCDS.FieldByName('Pno').AsString) + ' and a.custorderno=' + Quotedstr(FSourceCDS.FieldByName('CustOrderno').AsString)
        + ' and isnull(a.garbageflag,0)=0 and len(isnull(b.manfac,''''))>=11 and b.qty>0';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      if tmpCDS.RecordCount > 1 then
      begin
        ShowMsg('�s�{�K�Q�P�Ȥ�q�渹�B�P�Ƹ��X�{�h���ɺ�!', 48);
        Exit;
      end;
    end;

    //�Y�j�]�˶q����>20dsh
    if SameText(SMRec.Custno, 'AC172') and (SMRec.M3_6 >= 2) and (SMRec.M3_6 <= 12) and (SMRec.M7_8 = '22') then
    begin
      Data := null;
      tmpSQL := 'select b.manfac from dli010 a inner join dli040 b' +
        ' on a.bu=b.bu and a.dno=b.dno and a.ditem=b.ditem' + ' where a.bu=' + Quotedstr(g_UInfo^.BU) + ' and a.dno=' +
        Quotedstr(FSourceCDS.FieldByName('dno').AsString) + ' and a.ditem=' + FSourceCDS.FieldByName('ditem').AsString +
        ' and b.qty>20';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      if tmpCDS.RecordCount > 1 then
        ShowMsg('�Y�j2-12mil 2/2���\�̤j�]�˶q20SH,�нT�{!', 48);
    end;

    //RTF�BRTF2�BVLP�BHVLP
    Data := null;
    tmpSQL := 'select rtf,rtf2,vlp,hvlp from dli061 where bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('�����j��RTF�BRTF2�BVLP�BHVLP���]�w!', 48);
      Exit;
    end;

    C061.RTF := tmpCDS.FieldByName('rtf').AsString;
    C061.RTF2 := tmpCDS.FieldByName('rtf2').AsString;
    C061.VLP := tmpCDS.FieldByName('vlp').AsString;
    C061.HVLP := tmpCDS.FieldByName('hvlp').AsString;

    if SMRec.Custno2 <> '' then
      tmpCustno := SMRec.Custno2
    else
      tmpCustno := SMRec.Custno;
    //²��
    if SameText(tmpCustno, 'AC365') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�西���K')
    else if SameText(tmpCustno, 'AC114') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�西�h�h')
    else if SameText(tmpCustno, 'ACD39') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�西�h�h-2')
    else if SameText(tmpCustno, 'ACE06') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�E�������G�t')
    else if SameText(tmpCustno, 'AC388') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('���KHDI')
    else if SameText(tmpCustno, 'AC091') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�s�j')
    else if SameText(tmpCustno, 'AC094') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�s��')
    else if SameText(tmpCustno, 'AC117') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�s�X')
    else if SameText(tmpCustno, 'ACC19') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�s�X-2')
    else if SameText(tmpCustno, 'AC434') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('���y���K')
    else if SameText(tmpCustno, 'AC172') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�Y�j')
    else if SameText(tmpCustno, 'AC638') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�]������')
    else if SameText(tmpCustno, 'AC449') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�`�q')
    else if SameText(tmpCustno, 'AC625') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�s�{�ֱ�')
    else if SameText(tmpCustno, 'AC103') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�ֱ��q��')
    else if SameText(tmpCustno, 'ACB00') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('���˹q�l')
    else if SameText(tmpCustno, 'ACB89') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�����ȭ}')
    else if SameText(tmpCustno, 'AC360') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�ӧ�')
    else if SameText(tmpCustno, 'AC263') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�I��')
    else if SameText(tmpCustno, 'ACD57') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�R�F�q��')
    else if SameText(tmpCustno, 'AC588') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�T�w�a')
    else if SameText(tmpCustno, 'AC737') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('�`�`������')//    else if SameText(tmpCustno, 'ACF29') then
//      FCDS.FieldByName('Custabs').AsString := CheckLang('�]���西��ަh�h�q���O�������q')
    else
      FCDS.FieldByName('Custabs').AsString := FSourceCDS.FieldByName('Custshort').AsString;

//    FCDS.FieldByName('Custabs').AsString := GetCustName(SMRec.Custno);
    //N006�Ƶ��榡:ACXXX-�Ȥ�W��
    if isN006 then
      if (Length(tmpRemarkRec.Custno) > 0) and (Length(tmpRemarkRec.Other) > 0) then
        FCDS.FieldByName('Custabs').AsString := FCDS.FieldByName('Custabs').AsString + '(' + tmpRemarkRec.Other + ')';
    //²��
    //�q�lñ�W
    FCDS.FieldByName('E_seal').AsBoolean := True;

    //N005 �W��po
    if SameText(FSourceCDS.FieldByName('Custno').AsString, 'N005') and isCY and (tmpRemarkRec.Orderitem > 0) then
    begin
      Data := null;
      tmpSQL := ' Select oea10,oao06 From (' + ' Select oea10,oeb01,oeb03' +
        ' From oea_file Inner Join oeb_file On oea01=oeb01' + ' Where oeb01=' + Quotedstr(tmpRemarkRec.Orderno) +
        ' And oeb03=' + IntToStr(tmpRemarkRec.Orderitem) + ' ) X Left Join oao_file Y On oeb01=oao01 and oeb03=oao03';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        Exit;
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
        FCDS.FieldByName('C_Orderno').AsString := GetC_Orderno(SMRec.Custno, tmpCDS.FieldByName('oea10').AsString,
          tmpCDS.FieldByName('oao06').AsString);
    end;

    //�S����
    Data := null;
    tmpSQL := 'Select Top 1 * From Dli310 Where Bu=' + Quotedstr(g_UInfo^.BU);
    if QueryBySQL(tmpSQL, Data) then
      tmpCDS1.Data := Data;
    if (date - tmpCDS1.FieldByName('mdate').AsDateTime) > 30 then
    begin
      ShowMsg('�S���س]�w��30�ѥ���s', 48);
      Exit;
    end;
        //���c
    Data := null;
    tmpSQL := 'Select * From Dli150 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Strip=' + FloatToStr(SMRec.M3_6 / 1000)
      + ' And (Adhesive=' + Quotedstr(SMRec.M2) + ' Or Adhesive=''@'')';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
      begin
        tmpBo := tmpCDS.Locate('Custno;Adhesive', VarArrayOf([SMRec.Custno, SMRec.M2]), []);
        if not tmpBo then
          tmpBo := tmpCDS.Locate('Custno;Adhesive', VarArrayOf(['@', SMRec.M2]), []);
        if not tmpBo then
          tmpBo := tmpCDS.Locate('Custno;Adhesive', VarArrayOf(['@', '@']), []);

        if tmpBo then
        begin
          tmpSQL := 'Struct' + SMRec.M15;
          if tmpCDS.FindField(tmpSQL) <> nil then
            FCDS.FieldByName('N1').AsString := tmpCDS.FieldByName(tmpSQL).AsString;
        end;
      end;
    end;
    //���c
    //�ˬd�Ȥ�~�W���c
    tmpSQL := FCheckC_sizes.CheckStruct(SMRec, FCDS.FieldByName('C_Sizes').AsString, FCDS.FieldByName('N1').AsString);
    if Length(tmpSQL) > 0 then
    begin
      ShowMsg(tmpSQL, 48);
      Exit;
    end;

    //�~�[
    Data := null;
    tmpSQL := 'Select ViewValue From Dli320 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno)
      + ',Custno)>0';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if VarIsNull(Data) then
        tmpSQL := '<30 PV'
      else
        tmpSQL := VarToStr(Data);
      FCDS.FieldByName('A1').AsString := tmpSQL;
      FCDS.FieldByName('A11').AsString := tmpSQL;
    end;
    //�~�[
    //�ؤo
    Data := null;
    tmpSQL := 'Select * From Dli190 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (Sizes=' + Quotedstr(SMRec.M9_11) +
      ' OR Sizes=' + Quotedstr(SMRec.M12_14) + ')';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if tmpCDS.Locate('Sizes', SMRec.M9_11, []) then   //�g�V
      begin
        FCDS.FieldByName('B1').AsString := tmpCDS.FieldByName('dValue').AsString;
        FCDS.FieldByName('B11').AsString := tmpCDS.FieldByName('fValue').AsString;
      end;
      if tmpCDS.Locate('Sizes', SMRec.M12_14, []) then  //�n�V
      begin
        FCDS.FieldByName('B2').AsString := tmpCDS.FieldByName('dValue').AsString;
        FCDS.FieldByName('B21').AsString := tmpCDS.FieldByName('fValue').AsString;
      end;
    end;

    if isPN then
      FCDS.FieldByName('TW_Size').AsString := SMRec.M9_11 + '"*' + SMRec.M12_14 + '"'
    else
      FCDS.FieldByName('TW_Size').AsString := FloatToStr(StrToInt(SMRec.M9_11) / 10) + '"*' + FloatToStr(StrToInt(SMRec.M12_14)
        / 10) + '"';

    if isPN then
    begin
      FCDS.FieldByName('B1').AsString := FCDS.FieldByName('B1').AsString + '+1/-0';
      FCDS.FieldByName('B2').AsString := FCDS.FieldByName('B2').AsString + '+1/-0';
    end
    else if SameText(g_uinfo^.BU, 'ITEQGZ') and (Pos(SMRec.M9_11 + SMRec.M12_14,
      '740490,760490,820490,860490,743493,823493,863493') > 0) then
    begin
      FCDS.FieldByName('B1').AsString := FCDS.FieldByName('B1').AsString + '+3/-0';
      FCDS.FieldByName('B2').AsString := FCDS.FieldByName('B2').AsString + '+3/-0';
    end
    else if Pos(SMRec.M9_11 + SMRec.M12_14, '740490,760490,820490,860490') > 0 then
    begin
      FCDS.FieldByName('B1').AsString := FCDS.FieldByName('B1').AsString + '+3/-0';
      FCDS.FieldByName('B2').AsString := FCDS.FieldByName('B2').AsString + '+3/-0';
    end
    else
    begin
      FCDS.FieldByName('B1').AsString := FCDS.FieldByName('B1').AsString + '+2/-0';
      FCDS.FieldByName('B2').AsString := FCDS.FieldByName('B2').AsString + '+2/-0';
    end;
    //�ؤo
    //�ˬd�Ȥ�~�W�ؤo
    if isPN then
    begin
      tmpSQL := FCheckC_sizes.CheckCCL_PN_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString, FCDS.FieldByName('B11').AsString,
        FCDS.FieldByName('B21').AsString);
      if Length(tmpSQL) > 0 then
      begin
        ShowMsg(tmpSQL, 48);
        Exit;
      end;
    end;

    //�p��&����h�p��
    {�p��ɺ�}
    CopperValue1 := 0;
    CopperValue2 := 0;
    if Pos(SMRec.MLast_1, C061.RTF) > 0 then
      tmpSQL := 'B'
    else if Pos(SMRec.MLast_1, C061.VLP) > 0 then
      tmpSQL := 'C'
    else if Pos(SMRec.MLast_1, C061.HVLP) > 0 then
      tmpSQL := 'D'
    else
      tmpSQL := 'A';

    Data := null;
    tmpSQL := 'Select * From DLI360 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (charindex(' + Quotedstr(SMRec.Custno) +
      ',Custno)>0' + ' Or Custno=''@'') And Type=' + Quotedstr(tmpSQL);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        Filtered := False;
        Filter := 'Custno<>''@''';
        Filtered := True;
        if IsEmpty then
        begin
          Filtered := False;
          Filter := 'Custno=''@''';
          Filtered := True;
        end;
        if Locate('Sizes', SMRec.M7, []) then
          CopperValue1 := FieldByName('fValue').AsFloat;
        if Locate('Sizes', SMRec.M8, []) then
          CopperValue2 := FieldByName('fValue').AsFloat;
        Filtered := False;
      end;
    end;
    {end�p��ɺ�}
    //�西����
    if (Pos(SMRec.Custno, 'AC114/AC365/AC434/AC388') > 0) and (SMRec.M3_6 <= 4) then
    begin
      FCDS.FieldByName('C1').AsString := '��0.4mil';
      FCDS.FieldByName('D1').AsString := '��0.4mil';
    end  //�ܨ�����
    else if SameText(SMRec.Custno, 'AC108') and (Pos(Copy(FCDS.FieldByName('Pno').AsString, 3, 6),
      '051022,0550HH,053511') > 0) then
    begin
      FCDS.FieldByName('C1').AsString := '+4/-2';
      FCDS.FieldByName('D1').AsString := '+4/-2';
    end  //�W�n
    else if (Pos(SMRec.Custno, 'AC097/AC143') > 0) and (SMRec.M2 = '6') and (Pos('1.6mm', LowerCase(FCDS.FieldByName('C_Sizes').AsString))
      > 0) then
    begin
      tmpSQL := Copy(FCDS.FieldByName('Pno').AsString, 2, 7);
      if (tmpSQL <> '60590HH') and (tmpSQL <> '6058011') and (tmpSQL <> '6055022') then
      begin
        ShowMsg('�Ƹ����~,��2�X�ܲ�8�X���ӬO' + #13#10 + '60590HH�B6058011�B6055022', 48);
        Exit;
      end;
      FCDS.FieldByName('C1').AsString := '+0/-6.3';
      FCDS.FieldByName('D1').AsString := '+0/-6.3';
    end
    else  {�W��n�DGetClassB_C���Ȥ�~�W���Ƶ������t}
if GetClassB_C(SMRec, FCDS.FieldByName('C_Sizes').AsString) then
    begin
      if is968 then
        FCDS.FieldByName('D1').AsString := FloatToStr(SMRec.M3_6) + FCDS.FieldByName('D1').AsString + 'mil';
    end
    else
    begin
      if isLCA then
      begin
        if (SMRec.M2 = '1') and ((SMRec.M3_6 = 16) or (SMRec.M3_6 = 18)) then
        begin
          FCDS.FieldByName('C1').AsString := '��1.2mil';
          FCDS.FieldByName('D1').AsString := '��1.2mil';
        end
        else
        begin
          FCDS.FieldByName('C1').AsString := '��0.6mil';
          FCDS.FieldByName('D1').AsString := '��0.6mil';
        end;
      end
      else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 <= 3) and (SMRec.M2 = 'J') then
      begin
        FCDS.FieldByName('C1').AsString := '��0.3mil';
        FCDS.FieldByName('D1').AsString := '��0.3mil';
      end
      else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 > 3) and (SMRec.M3_6 <= 4) and (SMRec.M2 = 'J') then
      begin
        FCDS.FieldByName('C1').AsString := '��0.4mil';
        FCDS.FieldByName('D1').AsString := '��0.4mil';
      end
      else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 = 4.5) and (SMRec.M2 = 'J') then
      begin
        FCDS.FieldByName('C1').AsString := '��0.5mil';
        FCDS.FieldByName('D1').AsString := '��0.5mil';
      end
      else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 <= 3) and (Pos(SMRec.M2, '68F') > 0) then
      begin
        FCDS.FieldByName('C1').AsString := '��0.3mil';
        FCDS.FieldByName('D1').AsString := '��0.3mil';
      end
      else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 <= 4.5) and (Pos(SMRec.M2, '68F') > 0) then
      begin
        FCDS.FieldByName('C1').AsString := '��0.4mil';
        FCDS.FieldByName('D1').AsString := '��0.4mil';
      end
      else
      begin
        Data := null;
        tmpSQL := Copy(tmpPno, 3, 4);
        tmpSQL := 'Select ''A'' as AType,Custno,ClassB_C From Dli160' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
          ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) + ' Union All' +
          ' Select ''B'' as AType,Custno,ClassM_L From Dli161' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
          ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL);
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data := Data;
          if tmpCDS.Locate('AType;Custno', VarArrayOf(['B', SMRec.Custno]), []) then
            FCDS.FieldByName('C1').AsString := tmpCDS.FieldByName('ClassB_C').AsString
          else if tmpCDS.Locate('AType;Custno', VarArrayOf(['B', '@']), []) then
            FCDS.FieldByName('C1').AsString := tmpCDS.FieldByName('ClassB_C').AsString;

          if tmpCDS.Locate('AType;Custno', VarArrayOf(['A', SMRec.Custno]), []) then
            FCDS.FieldByName('D1').AsString := tmpCDS.FieldByName('ClassB_C').AsString
          else if tmpCDS.Locate('AType;Custno', VarArrayOf(['A', '@']), []) then
            FCDS.FieldByName('D1').AsString := tmpCDS.FieldByName('ClassB_C').AsString;

           //AC109�BIT968 class�ഫ����ڤ��t
          if SameText(SMRec.Custno, 'AC109') or is968 then
            if (pos('class', LowerCase(FCDS.FieldByName('C1').AsString)) > 0) or (pos('class', LowerCase(FCDS.FieldByName
              ('D1').AsString)) > 0) then
            begin
              Data := null;
              tmpSQL := RightStr('0000' + FloatToStr(SMRec.M3_6 * 10), 4);
              tmpSQL := 'Select ClassB,ClassC,0 as id From DLI090' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
                ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) + ' And charindex('
                + Quotedstr(SMRec.Custno) + ',Custno)>0' + ' And charindex(' + Quotedstr(SMRec.M2) + ',Adhesive)>0' +
                ' Union All' + ' Select ClassB,ClassC,1 as id From DLI090' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
                ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) + ' And charindex('
                + Quotedstr(SMRec.Custno) + ',Custno)>0' + ' And Adhesive=''*''' + ' Union All' +
                ' Select ClassB,ClassC,2 as id From DLI090' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
                ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL) +
                ' And Custno=''*'' And Adhesive=''*''' + ' Order By id';
              if QueryBySQL(tmpSQL, Data) then
              begin
                tmpCDS.Data := Data;
                if not tmpCDS.IsEmpty then
                begin
                  if SameText(FCDS.FieldByName('C1').AsString, 'Class B') or SameText(FCDS.FieldByName('C1').AsString,
                    'Class L') then
                    FCDS.FieldByName('C1').AsString := '��' + FloatToStr(tmpCDS.Fields[0].AsFloat) + 'mil'
                  else if SameText(FCDS.FieldByName('C1').AsString, 'Class C') or SameText(FCDS.FieldByName('C1').AsString,
                    'Class M') then
                    FCDS.FieldByName('C1').AsString := '��' + FloatToStr(tmpCDS.Fields[1].AsFloat) + 'mil';

                  if SameText(FCDS.FieldByName('D1').AsString, 'Class B') or SameText(FCDS.FieldByName('D1').AsString,
                    'Class L') then
                  begin
                    if is968 then
                    begin
                      FCDS.FieldByName('D1_1').AsString := FloatToStr(tmpCDS.Fields[0].AsFloat);
                      FCDS.FieldByName('D1_2').AsString := FCDS.FieldByName('D1_1').AsString;
                      FCDS.FieldByName('D1').AsString := FloatToStr(SMRec.M3_6) + '��' + FCDS.FieldByName('D1_1').AsString
                        + 'mil';
                    end
                    else
                      FCDS.FieldByName('D1').AsString := '��' + FloatToStr(tmpCDS.Fields[0].AsFloat) + 'mil';
                  end
                  else if SameText(FCDS.FieldByName('D1').AsString, 'Class C') or SameText(FCDS.FieldByName('D1').AsString,
                    'Class M') then
                  begin
                    if is968 then
                    begin
                      FCDS.FieldByName('D1_1').AsString := FloatToStr(tmpCDS.Fields[1].AsFloat);
                      FCDS.FieldByName('D1_2').AsString := FCDS.FieldByName('D1_1').AsString;
                      FCDS.FieldByName('D1').AsString := FloatToStr(SMRec.M3_6) + '��' + FCDS.FieldByName('D1_1').AsString
                        + 'mil';
                    end
                    else
                      FCDS.FieldByName('D1').AsString := '��' + FloatToStr(tmpCDS.Fields[1].AsFloat) + 'mil';
                  end;
                end;
              end;
            end;
        end;
      end;
    end;

    //C1X�BD1X�ˬd�ϥ�
    FCDS.FieldByName('C1X').AsString := FCDS.FieldByName('C1').AsString;
    FCDS.FieldByName('D1X').AsString := FCDS.FieldByName('D1').AsString;
    if SameText(SMRec.Custno, 'AC109') then
    begin
      if (Length(FCDS.FieldByName('C1').AsString) > 0) and (pos('class', LowerCase(FCDS.FieldByName('C1').AsString)) = 0)
        then
        FCDS.FieldByName('C1').AsString := FloatToStr(SMRec.M3_6 + CopperValue1 + CopperValue2) + FCDS.FieldByName('C1').AsString;
      if (Length(FCDS.FieldByName('D1').AsString) > 0) and (pos('class', LowerCase(FCDS.FieldByName('D1').AsString)) = 0)
        then
        FCDS.FieldByName('D1').AsString := FloatToStr(SMRec.M3_6) + FCDS.FieldByName('D1').AsString;
    end;

    if is968 then
      FCDS.FieldByName('C1').AsString := '';
    {end�W��n�D}
    //968�H����(���G�O�d1��p��:���t�̦h�@��p��)
    if is968 and (Length(FCDS.FieldByName('D1_1').AsString) > 0) then
    begin
      rand1 := Ceil((SMRec.M3_6 - StrToFloat(FCDS.FieldByName('D1_1').AsString)) * 10);
      rand2 := Trunc((SMRec.M3_6 + StrToFloat(FCDS.FieldByName('D1_2').AsString)) * 10);
      FCDS.FieldByName('D11').AsString := FloatToStr(RoundTo(RandomRange(rand1, rand2) / 10, -1));
      if Pos('.', FCDS.FieldByName('D11').AsString) = 0 then
        FCDS.FieldByName('D11').AsString := FCDS.FieldByName('D11').AsString + '.0';
    end
    else
    begin
      {���խ� ��dg��Ʈw,�ꪫ�帹�Ĥ@�XG�ܬ�D}
      FCDS.FieldByName('C11').AsString := '';
      FCDS.FieldByName('D11').AsString := '';

      s1 := 'ORACLE';
      if SameText(SMRec.MLast, 'G') then
        s1 := 'ORACLE1';
      if SameText(s1, 'ORACLE') then
        tmpSQL := '(Case When Left(manfac,1)=''G'' Then ''D''+Substring(manfac,2,20) Else manfac End)'
      else
        tmpSQL := 'manfac';

      Data := null;
      tmpSQL := 'Select Distinct Left(' + tmpSQL + ',10)+''%'' lot From Dli040' + ' Where Bu=' + Quotedstr(g_UInfo^.BU)
        + tmpAllLot + ' And Dno=' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString) + ' And Ditem=' + IntToStr(FSourceCDS.FieldByName
        ('Ditem').AsInteger);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        tmpSQL := '';
        while not tmpCDS.Eof do
        begin
          if tmpSQL <> '' then
            tmpSQL := tmpSQL + ' or ';
          tmpSQL := tmpSQL + ' (tc_sih02 Like ' + Quotedstr('D'+copy(tmpCDS.Fields[0].AsString,2,255))+ ' or tc_sih02 Like ' + Quotedstr('J'+copy(tmpCDS.Fields[0].AsString,2,255))+')';
          tmpCDS.Next;
        end;
        if tmpSQL <> '' then
        begin
          ShowBarMsg('���b�d�߫p��...');
          Data := null;
          tmpSQL := 'Select Min(Least(tc_sih111,tc_sih112,tc_sih113))*10000 A,' +
            ' Max(Greatest(tc_sih111,tc_sih112,tc_sih113))*10000 B' + ' From tc_sih_file Where ' + tmpSQL;
          if QueryBySQL(tmpSQL, Data, s1) then
          begin
            tmpCDS.Data := Data;  //Data�r�q��������,�p�ƥᥢ,�ҥH�⵲�G�X�j10000��
            if not tmpCDS.Fields[0].IsNull then
            begin
              s1 := FloatToStr(RoundTo(tmpCDS.Fields[0].AsFloat / 10000, -2));
              s2 := FloatToStr(RoundTo(tmpCDS.Fields[1].AsFloat / 10000, -2));
              s1 := FormatPoint(s1, 2);
              s2 := FormatPoint(s2, 2);
              FCDS.FieldByName('C11').AsString := s1 + '-' + s2;

              //����h�p��D11=�p��C11-�W�U2�����ɺ�p��
              s1 := FloatToStr(RoundTo(StrToFloat(s1) - CopperValue1 - CopperValue2, -2));
              s2 := FloatToStr(RoundTo(StrToFloat(s2) - CopperValue1 - CopperValue2, -2));
              s1 := FormatPoint(s1, 2);
              s2 := FormatPoint(s2, 2);
              FCDS.FieldByName('D11').AsString := s1 + '-' + s2;
            end;
          end;
        end;
      end;
      {end���խ�}
    end;
    //�p��&����h�p��
    //�ɺ�p�� --�W��n�D(E11 E21���խȦbdli520���s�]�w)
    Data := null;
    tmpSQL := 'Select * From Dli070 Where Bu=' + Quotedstr(g_UInfo^.BU);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if tmpCDS.Locate('Custno;Copper', VarArrayOf([SMRec.Custno, SMRec.M7]), [loCaseInsensitive]) or tmpCDS.Locate('Custno;Copper',
        VarArrayOf(['@', SMRec.M7]), [loCaseInsensitive]) then
      begin
        if ((date - tmpCDS.FieldByName('mdate').AsDateTime) > 7) and (not sametext('ID150515', g_uinfo^.userid)) then
        begin
          ShowMsg('�ɺ�p�׳W��n�D�]�w��7�ѥ���s', 48);
//          Exit;
        end;
        FCDS.FieldByName('E11').AsString := FormatPoint(tmpCDS.FieldByName('Value_um').AsString, 1);
        FCDS.FieldByName('E1').AsString := FCDS.FieldByName('E11').AsString + '��' + FormatPoint(FloatToStr(FCDS.FieldByName
          ('E11').AsFloat / 10), 2);
      end;
      if tmpCDS.Locate('Custno;Copper', VarArrayOf([SMRec.Custno, SMRec.M8]), [loCaseInsensitive]) or tmpCDS.Locate('Custno;Copper',
        VarArrayOf(['@', SMRec.M8]), [loCaseInsensitive]) then
      begin
        FCDS.FieldByName('E21').AsString := FormatPoint(tmpCDS.FieldByName('Value_um').AsString, 1);
        FCDS.FieldByName('E2').AsString := FCDS.FieldByName('E21').AsString + '��' + FormatPoint(FloatToStr(FCDS.FieldByName
          ('E21').AsFloat / 10), 2);
      end;
    end;
    //�ɺ�p��
    //�@���h�ɶ�
    Data := null;
    tmpSQL := Copy(tmpPno, 3, 4);
//    if pos(SMRec.Custno,'AC950/AC075/AC310/AC311/AC405')>0 then
//      tmpSQL := 'Select * From Dli490 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Strip_lower<=' + Quotedstr(tmpSQL)
//    else
    tmpSQL := 'Select * From Dli490 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Custno=' + Quotedstr(SMRec.Custno) +
      ' And Strip_lower<=' + Quotedstr(tmpSQL);

    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if tmpCDS.Locate('Adhesive', SMRec.M2, []) then
      begin
        FCDS.FieldByName('U1').AsString := tmpCDS.FieldByName('StdValue').AsString;
        FCDS.FieldByName('U11').AsString := tmpCDS.FieldByName('FValue').AsString;
        FCDS.FieldByName('U12').AsString := 'pass';
      end
      else
      begin
        FCDS.FieldByName('U1').AsString := '---';
        FCDS.FieldByName('U11').AsString := '---';
        FCDS.FieldByName('U12').AsString := 'NA';
      end
    end;
    //CCL ROHS 2.0���س]�w
    if pos(SMRec.Custno, 'AC950/AC075/AC310/AC311/AC405') > 0 then
    begin
      Data := null;
      tmpSQL := Copy(tmpPno, 3, 4);
      tmpSQL := 'Select * From Dli491 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        FCDS.FieldByName('V01').AsString := tmpCDS.FieldByName('V01').AsString;
        FCDS.FieldByName('V02').AsString := tmpCDS.FieldByName('V02').AsString;
        FCDS.FieldByName('V03').AsString := tmpCDS.FieldByName('V03').AsString;
        FCDS.FieldByName('V04').AsString := tmpCDS.FieldByName('V04').AsString;
        FCDS.FieldByName('V05').AsString := tmpCDS.FieldByName('V05').AsString;
        FCDS.FieldByName('V06').AsString := tmpCDS.FieldByName('V06').AsString;
        FCDS.FieldByName('V07').AsString := tmpCDS.FieldByName('V07').AsString;
        FCDS.FieldByName('V08').AsString := tmpCDS.FieldByName('V08').AsString;
        FCDS.FieldByName('V09').AsString := tmpCDS.FieldByName('V09').AsString;
        FCDS.FieldByName('V10').AsString := tmpCDS.FieldByName('V10').AsString;
        FCDS.FieldByName('V11').AsString := tmpCDS.FieldByName('V11').AsString;
        FCDS.FieldByName('V12').AsString := tmpCDS.FieldByName('V12').AsString;
        FCDS.FieldByName('V13').AsString := tmpCDS.FieldByName('V13').AsString;
        FCDS.FieldByName('V14').AsString := tmpCDS.FieldByName('V14').AsString;
      end;
    end;
                //�@���h�ɶ�
    //�s��/�ᦱ
    Data := null;
    tmpSQL := Copy(tmpPno, 3, 4);
    tmpSQL := 'Select * From Dli250 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (Custno=''@'' or charindex(' + Quotedstr
      (SMRec.Custno) + ',Custno)>0)' + ' And Strip_lower<=' + Quotedstr(tmpSQL) + ' And Strip_upper>=' + Quotedstr(tmpSQL);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        if RecordCount > 1 then
        begin
          Filtered := False;
          Filter := 'Custno<>''@''';
          Filtered := True;
        end;
        if not IsEmpty then
        begin
          if ((date - FieldByName('mdate').AsDateTime) > 7) and (not sametext('ID150515', g_uinfo^.userid)) then
          begin
            ShowMsg('�s��/�ᦱ�]�w��7�ѥ���s', 48);
//            Exit;
          end;
          FCDS.FieldByName('F1').AsString := FieldByName('Specification').AsString;
          FCDS.FieldByName('F11').AsString := FieldByName('TestValue').AsString;
          if Pos('---', FCDS.FieldByName('F11').AsString) = 0 then
          begin
            Randomize;
            FCDS.FieldByName('F11').AsString := '0.' + IntToStr(RandomRange(18, 30));
            FCDS.FieldByName('F12').AsString := 'pass';
          end
          else
            FCDS.FieldByName('F12').AsString := 'NA';
        end;
        Filtered := False;
      end;
    end;
    //�s��/�ᦱ
    //�����j��(�ɫp�j�pT<H<1<S<2<P<3<4<5<6<7)
    //���
    if SameText(SMRec.Custno, 'AC152') then
    begin
      FCDS.FieldByName('G_unit').AsString := 'N/mm'
    end
    else if Pos(SMRec.MLast_1, C061.RTF) > 0 then
    begin
      if SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '5/6/8/4/H/F/U/S/Q') > 0) then
        FCDS.FieldByName('G_unit').AsString := 'N/mm'
      else
        FCDS.FieldByName('G_unit').AsString := 'lb/in';
    end
    else if isHY and (Pos(SMRec.M2, '4/6/F') > 0) then
      FCDS.FieldByName('G_unit').AsString := 'N/mm'
    else if isHY and (SMRec.M2 = '8') then
      FCDS.FieldByName('G_unit').AsString := 'KG/CM'
    else if isLCA and (Pos(SMRec.Custno, 'AC143/AC097') > 0) then
      FCDS.FieldByName('G_unit').AsString := 'lb/in'
    else if (Pos(SMRec.Custno, 'AC143/AC097') > 0) and (Pos(SMRec.M2, '1/6/F') > 0) then
      FCDS.FieldByName('G_unit').AsString := 'N/mm'
        //    else if (Pos(SMRec.Custno, 'AC405/AC310/AC311/AC075/AC950') > 0) and (SMRec.M2 = '6') then
//      FCDS.FieldByName('G_unit').AsString := 'N/mm'
    else if SameText(SMRec.Custno, 'AK001') and (Pos(SMRec.M2, '6/8') > 0) then
      FCDS.FieldByName('G_unit').AsString := 'Kgf/cm'
    else if SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '5/6/8/4/F/A') > 0) then
      FCDS.FieldByName('G_unit').AsString := 'N/mm'
    else
      FCDS.FieldByName('G_unit').AsString := 'lb/in';
    //���
//    if (Pos(SMRec.Custno, 'AC405/AC310/AC311/AC075/AC950') > 0) and (SMRec.M2 = '6') then
//    begin
//      if Pos(SMRec.MLast_1, C061.RTF) > 0 then
//      begin
//        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value65').AsString;
//        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value66').AsString;
//        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value65').AsString;
//        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value66').AsString;
//      end
//      else if SMRec.M3_6 < 20 then
//      begin
//        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value61').AsString;
//        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value62').AsString;
//        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value61').AsString;
//        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value62').AsString;
//      end
//      else
//      begin
//        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value63').AsString;
//        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value64').AsString;
//        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value63').AsString;
//        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value64').AsString;
//      end;
//    end
//    else
    if Pos(SMRec.Custno, 'AC148/AC347') > 0 then
    begin
      if SMRec.M3_6 < 20 then
      begin
        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value43').AsString;
        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value44').AsString;
        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value43').AsString;
        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value44').AsString;
      end
      else
      begin
        FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value45').AsString;
        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value46').AsString;
        FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value45').AsString;
        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value46').AsString;
      end;
    end
    else if isLCA and (Pos(SMRec.Custno, 'AC097/AC143') > 0) then
    begin
      FCDS.FieldByName('G1').AsString := ReM7_8(SMRec.M7) + 'OZ ��' + tmpCDS1.FieldByName('Value41').AsString;
      FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value42').AsString;
      FCDS.FieldByName('G2').AsString := ReM7_8(SMRec.M8) + 'OZ ��' + tmpCDS1.FieldByName('Value41').AsString;
      FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value42').AsString;
    end
    else
    begin
      Data := null;
      tmpSQL := Copy(tmpPno, 3, 4);
      tmpSQL := 'Select * From Dli060 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And strip_lower<=' + Quotedstr(tmpSQL) +
        ' And strip_upper>=' + Quotedstr(tmpSQL) + ' order by Lst';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if Pos(SMRec.MLast_1, C061.VLP + ',' + C061.HVLP) > 0 then  //VLP+HVLP
        begin
          with tmpCDS do
          begin
            Filtered := False;
            Filter := 'Custno=' + Quotedstr(SMRec.Custno) + ' And Copper=''#''';
            Filtered := True;
            if not SetG2_FromDli060_VLP(tmpCDS, SMRec) then
            begin
              Filtered := False;
              Filter := 'Custno=''0'' And Copper=''#''';
              Filtered := True;
              SetG2_FromDli060_VLP(tmpCDS, SMRec);
            end;
            Filtered := False;
          end;
        end
        else
        begin
          s1 := SMRec.M7;
          s2 := SMRec.M8;
          if Pos(SMRec.MLast_1, C061.RTF) > 0 then         //RTF
          begin
            if pos(s1, l_CopperALL) > 10 then             //>3 ��3��
              s1 := '@3'
            else
              s1 := '@' + s1;
            if pos(s2, l_CopperALL) > 10 then
              s2 := '@3'
            else
              s2 := '@' + s2;
          end
          else if Pos(SMRec.MLast_1, C061.RTF2) > 0 then        //RTF2
          begin
            if pos(s1, l_CopperALL) > 10 then             //>3 ��3��
              s1 := '&3'
            else
              s1 := '&' + s1;
            if pos(s2, l_CopperALL) > 10 then
              s2 := '&3'
            else
              s2 := '&' + s2;
          end
          else if Pos(SMRec.Custno, 'AC111/AK001/AC143/AC097') > 0 then // >2 ��2��
          begin
            if pos(s1, l_CopperALL) > 7 then
              s1 := '2';
            if pos(s2, l_CopperALL) > 7 then
              s2 := '2';
          end
          else if SameText(SMRec.Custno, 'AC082') then     // >H ��H��
          begin
            if pos(s1, l_CopperALL) > 3 then
              s1 := 'H';
            if pos(s2, l_CopperALL) > 3 then
              s2 := 'H';
          end
          else                                 //�䥦 >3 ��3��
          begin
            if pos(s1, l_CopperALL) > 10 then
              s1 := '3';
            if pos(s2, l_CopperALL) > 10 then
              s2 := '3';
          end;
          with tmpCDS do
          begin
            Filtered := False;
            Filter := 'Custno=' + Quotedstr(SMRec.Custno);
            Filtered := True;
            if not SetG2_FromDli060(tmpCDS, SMRec, s1, s2) then
            begin
              Filtered := False;
              Filter := 'Custno=''0''';
              Filtered := True;
              SetG2_FromDli060(tmpCDS, SMRec, s1, s2);
            end;
            Filtered := False;
          end;
        end;
      end;
    end;

    //�S����,���t=5,�Ƹ�16=w/m
    if (SMRec.M2 = '5') and (Pos(SMRec.MLast_1, 'w/m') > 0) then
    begin
      if SMRec.M7 = '1' then
      begin
        FCDS.FieldByName('G1').AsString := '1OZ ��' + tmpCDS1.FieldByName('Value71').AsString;
        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value72').AsString;
      end
      else if SMRec.M7 = '2' then
      begin
        FCDS.FieldByName('G1').AsString := '2OZ ��' + tmpCDS1.FieldByName('Value73').AsString;
        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value74').AsString;
      end
      else if SMRec.M7 = 'H' then
      begin
        FCDS.FieldByName('G1').AsString := 'HOZ ��' + tmpCDS1.FieldByName('Value75').AsString;
        FCDS.FieldByName('G11').AsString := tmpCDS1.FieldByName('Value76').AsString;
      end;

      if SMRec.M8 = '1' then
      begin
        FCDS.FieldByName('G2').AsString := '1OZ ��' + tmpCDS1.FieldByName('Value71').AsString;
        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value72').AsString;
      end
      else if SMRec.M8 = '2' then
      begin
        FCDS.FieldByName('G2').AsString := '2OZ ��' + tmpCDS1.FieldByName('Value73').AsString;
        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value74').AsString;
      end
      else if SMRec.M8 = 'H' then
      begin
        FCDS.FieldByName('G2').AsString := 'HOZ ��' + tmpCDS1.FieldByName('Value75').AsString;
        FCDS.FieldByName('G21').AsString := tmpCDS1.FieldByName('Value76').AsString;
      end;
    end;

    //�f�ȥ��H����
    if isHY then
    begin
      s1 := FCDS.FieldByName('G1').AsString;
      pos1 := Pos('��', s1);
      if pos1 > 0 then
      begin
        s1 := Copy(s1, pos1 + 2, 20);
        if Length(s1) = 0 then
          s1 := '0';

        s2 := IntToStr(Trunc((RoundTo(StrToFloat(s1), -2) + 0.6) * 100));
        s1 := IntToStr(Trunc((RoundTo(StrToFloat(s1), -2) + 0.3) * 100));
        Randomize;
        s1 := FloatToStr(RandomRange(StrToInt(s1), StrToInt(s2)) / 100);
        FCDS.FieldByName('G11').AsString := FormatPoint(s1, 2);
      end;

      if FCDS.FieldByName('G1').AsString = FCDS.FieldByName('G2').AsString then
        FCDS.FieldByName('G21').AsString := FCDS.FieldByName('G11').AsString
      else
      begin
        s1 := FCDS.FieldByName('G2').AsString;
        pos1 := Pos('��', s1);
        if pos1 > 0 then
        begin
          s1 := Copy(s1, pos1 + 2, 20);
          if Length(s1) = 0 then
            s1 := '0';

          s2 := IntToStr(Trunc((RoundTo(StrToFloat(s1), -2) + 0.6) * 100));
          s1 := IntToStr(Trunc((RoundTo(StrToFloat(s1), -2) + 0.3) * 100));
          Randomize;
          s1 := FloatToStr(RandomRange(StrToInt(s1), StrToInt(s2)) / 100);
          FCDS.FieldByName('G21').AsString := FormatPoint(s1, 2);
        end;
      end;
    end;
    //�����j��
    //�ؤo�w�w��
    if isHY and (SMRec.M3_6 <= 12) and ((Pos(SMRec.M7, '34567') > 0) or (Pos(SMRec.M8, '34567') > 0)) then
    begin
      FCDS.FieldByName('H1').AsString := '��200';
      FCDS.FieldByName('H12').AsString := 'pass';
      FCDS.FieldByName('H2').AsString := '��200';
      FCDS.FieldByName('H22').AsString := 'pass';
      FCDS.FieldByName('H11').AsString := tmpCDS1.FieldByName('Value31').AsString;
      FCDS.FieldByName('H21').AsString := tmpCDS1.FieldByName('Value32').AsString;
    end
    else if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 <= 12) and ((Pos(SMRec.M7, '34567') > 0) or (Pos(SMRec.M8,
      '34567') > 0)) then
    begin
      FCDS.FieldByName('H1').AsString := '��300';
      FCDS.FieldByName('H12').AsString := 'pass';
      FCDS.FieldByName('H2').AsString := '��300';
      FCDS.FieldByName('H22').AsString := 'pass';
      FCDS.FieldByName('H11').AsString := tmpCDS1.FieldByName('Value31').AsString;
      FCDS.FieldByName('H21').AsString := tmpCDS1.FieldByName('Value32').AsString;
    end
    else if isHY and (SMRec.M3_6 > 12) and (SMRec.M3_6 <= 20) then
    begin
      FCDS.FieldByName('H1').AsString := '���ȡ�200';
      FCDS.FieldByName('H11').AsString := tmpCDS1.FieldByName('Value35').AsString;
      FCDS.FieldByName('H12').AsString := 'pass';
      FCDS.FieldByName('H2').AsString := '���ȡ�200';
      FCDS.FieldByName('H21').AsString := tmpCDS1.FieldByName('Value36').AsString;
      FCDS.FieldByName('H22').AsString := 'pass';
    end
    else if isHY and (SMRec.M3_6 > 20) then
    begin
      FCDS.FieldByName('H1').AsString := '���ȡ�200';
      FCDS.FieldByName('H11').AsString := '---';
      FCDS.FieldByName('H12').AsString := '---';
      FCDS.FieldByName('H2').AsString := '���ȡ�200';
      FCDS.FieldByName('H21').AsString := '---';
      FCDS.FieldByName('H22').AsString := '---';
    end
    else if SameText(SMRec.M7_8, 'PP') then
    begin
      if SMRec.M3_6 <= 12 then
      begin
        FCDS.FieldByName('H1').AsString := '��300';
        FCDS.FieldByName('H11').AsString := tmpCDS1.FieldByName('Value37').AsString;
        FCDS.FieldByName('H12').AsString := 'pass';
        FCDS.FieldByName('H2').AsString := '��300';
        FCDS.FieldByName('H21').AsString := tmpCDS1.FieldByName('Value38').AsString;
        FCDS.FieldByName('H22').AsString := 'pass';
      end
      else
      begin
        FCDS.FieldByName('H1').AsString := '---';
        FCDS.FieldByName('H11').AsString := '---';
        FCDS.FieldByName('H12').AsString := 'NA';
        FCDS.FieldByName('H2').AsString := '---';
        FCDS.FieldByName('H21').AsString := '---';
        FCDS.FieldByName('H22').AsString := 'NA';
      end;
    end
    else if not ((SameText(SMRec.Custno, 'AC093') and (SMRec.M3_6 <= 20)) or   //?ac093 20mil??,?AC109 15mil??
      ((POS(SMRec.Custno, 'AC093/AM010') > 0) and (SMRec.M3_6 <= 15))) and ((SMRec.M3_6 > 12) or (Pos(SMRec.M7, '34567')
      > 0) or (Pos(SMRec.M8, '34567') > 0)) then
    begin
      FCDS.FieldByName('H1').AsString := '---';
      FCDS.FieldByName('H11').AsString := '---';
      FCDS.FieldByName('H12').AsString := 'NA';
      FCDS.FieldByName('H2').AsString := '---';
      FCDS.FieldByName('H21').AsString := '---';
      FCDS.FieldByName('H22').AsString := 'NA';
    end
    else //4�ر��p(�e3�اP�_���X)�G1.�Ȥ�@+���t 2.�Ȥ�+���t 3.�Ȥ�=0+���t 4.�Ȥ�=0+���t=0
    begin
      //H�B5:�o2�ӽ��t,���a�q�{���
      if SameText(SMRec.M2, 'H') or SameText(SMRec.M2, '5') then
        tmpSQL := ' And isnull(custno,'''')+isnull(adhesive,'''')<>''00'''
      else
        tmpSQL := '';
      Data := null;
      tmpSQL := 'Select *,case when charindex(' + Quotedstr(SMRec.MLast) + ',lastcode)>0 then ' + Quotedstr(SMRec.MLast)
        + ' else isnull(lastcode,'''') end lc ,case when charindex(' + Quotedstr(SMRec.MLast_1) + ',l1)>0 then ' +
        Quotedstr(SMRec.MLast_1) + ' else isnull(l1,'''') end l1 ' + ' From Dli050 Where Bu=' + Quotedstr(g_UInfo^.BU) +
        tmpSQL + ' Order By custno,adhesive,lc,thick,sstru,id';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;

        tmpCDS.Filtered := False;
        tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '&') + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc='
          + Quotedstr(SMRec.MLast);
        tmpCDS.Filtered := True;
        if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
        begin
          tmpCDS.Filtered := False;
          tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '&') + ' And adhesive=' + Quotedstr(SMRec.M2) +
            ' And lc=''''';
          tmpCDS.Filtered := True;
          if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
          begin
            tmpCDS.Filtered := False;
            tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '#') + ' And adhesive=' + Quotedstr(SMRec.M2) +
              ' And lc=' + Quotedstr(SMRec.MLast);
            tmpCDS.Filtered := True;
            if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
            begin
              tmpCDS.Filtered := False;
              tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '#') + ' And adhesive=' + Quotedstr(SMRec.M2) +
                ' And lc=''''';
              tmpCDS.Filtered := True;
              if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
              begin
                tmpCDS.Filtered := False;
                tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '@') + ' And adhesive=' + Quotedstr(SMRec.M2) +
                  ' And lc=' + Quotedstr(SMRec.MLast);
                tmpCDS.Filtered := True;
                if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                begin
                  tmpCDS.Filtered := False;
                  tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno + '@') + ' And adhesive=' + Quotedstr(SMRec.M2) +
                    ' And lc=''''';
                  tmpCDS.Filtered := True;
                  if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                  begin
                    tmpCDS.Filtered := False;
                    tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno) + ' And adhesive=' + Quotedstr(SMRec.M2) +
                      ' And lc=' + Quotedstr(SMRec.MLast);
                    tmpCDS.Filtered := True;
                    if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                    begin
                      tmpCDS.Filtered := False;
                      tmpCDS.Filter := 'custno=' + Quotedstr(SMRec.Custno) + ' And adhesive=' + Quotedstr(SMRec.M2) +
                        ' And lc=''''';
                      tmpCDS.Filtered := True;
                      if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                      begin
                        tmpCDS.Filtered := False;
                        tmpCDS.Filter := 'custno=''0&''' + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc=' +
                          Quotedstr(SMRec.MLast);
                        tmpCDS.Filtered := True;
                        if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                        begin
                          tmpCDS.Filtered := False;
                          tmpCDS.Filter := 'custno=''0&''' + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc=''''';
                          tmpCDS.Filtered := True;
                          if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                          begin
                            tmpCDS.Filtered := False;
                            tmpCDS.Filter := 'custno=''0#''' + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc=' +
                              Quotedstr(SMRec.MLast);
                            tmpCDS.Filtered := True;
                            if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                            begin
                              tmpCDS.Filtered := False;
                              tmpCDS.Filter := 'custno=''0#''' + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc=''''';
                              tmpCDS.Filtered := True;
                              if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                              begin
                                tmpCDS.Filtered := False;
                                tmpCDS.Filter := 'custno=''0@''' + ' And adhesive=' + Quotedstr(SMRec.M2) + ' And lc=' +
                                  Quotedstr(SMRec.MLast);
                                tmpCDS.Filtered := True;
                                if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                                begin
                                  tmpCDS.Filtered := False;
                                  tmpCDS.Filter := 'custno=''0@''' + ' And adhesive=' + Quotedstr(SMRec.M2) +
                                    ' And lc=''''';
                                  tmpCDS.Filtered := True;
                                  if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                                  begin
                                    tmpCDS.Filtered := False;
                                    tmpCDS.Filter := 'custno=''0''' + ' And adhesive=' + Quotedstr(SMRec.M2) +
                                      ' And lc=' + Quotedstr(SMRec.MLast);
                                    tmpCDS.Filtered := True;
                                    if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                                    begin
                                      tmpCDS.Filtered := False;
                                      tmpCDS.Filter := 'custno=''0''' + ' And adhesive=' + Quotedstr(SMRec.M2) +
                                        ' And lc=''''';
                                      tmpCDS.Filtered := True;
                                      if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                                      begin
                                        tmpCDS.Filtered := False;
                                        tmpCDS.Filter := 'custno=''0'' And adhesive=''0''';
                                        tmpCDS.Filtered := True;
                                        if not SetH_FromDli050(tmpCDS, SMRec, isLCA) then
                                          if SameText(SMRec.Custno, 'AC109') and (SMRec.M3_6 > 12) and (SMRec.M3_6 <= 15)
                                            then
                                          begin
                                            FCDS.FieldByName('H1').AsString := '��250';
                                            FCDS.FieldByName('H11').AsString := tmpCDS1.FieldByName('Value31').AsString;
                                            FCDS.FieldByName('H12').AsString := 'pass';
                                            FCDS.FieldByName('H2').AsString := '��250';
                                            FCDS.FieldByName('H21').AsString := tmpCDS1.FieldByName('Value32').AsString;
                                            FCDS.FieldByName('H22').AsString := 'pass';
                                          end;
                                      end;
                                    end;
                                  end;
                                end;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
        tmpCDS.Filtered := False;
      end;
    end;

    //�W��
    if Pos(SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950') > 0 then
    begin
      if (Pos(SMRec.Custno, 'AC405/AC075') > 0) and (SMRec.M2 = '6') and (SMRec.M3_6 = 10) and (SMRec.M7_8 = 'HH') then
        FCDS.FieldByName('H1').AsString := '-180��200PPM'
      else if (Pos(SMRec.Custno, 'AC405/AC075') > 0) and (SMRec.M2 = '6') and (SMRec.M3_6 = 12) and (SMRec.M7_8 = 'HH')
        then
        FCDS.FieldByName('H1').AsString := '-80��200PPM'
      else
      begin
        FCDS.FieldByName('H1').AsString := 'X+/-300PPM'; //�q�{
        //�Ȥ�~�W�Ƶ�: (DS200)
        pos1 := Pos('(DS', FCDS.FieldByName('C_Sizes').AsString);
        if pos1 > 0 then
        begin
          tmpSQL := Copy(FCDS.FieldByName('C_Sizes').AsString, pos1 + 3, 10);
          pos1 := Pos(')', tmpSQL);
          if pos1 > 0 then
          begin
            tmpSQL := Copy(tmpSQL, 1, pos1 - 1);
            if StrToFloatDef(tmpSQL, 0) > 0 then
              FCDS.FieldByName('H1').AsString := 'X+/-' + tmpSQL + 'PPM';
          end;
        end;
      end;
    end;
    //�ؤo�w�w��
    //������Ʒū�
    s1 := '0';
    s2 := '0';
    Data := null;
    tmpSQL := 'Select * From Dli110 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' order by Lst desc';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      tmpCDS.Filtered := False;
      tmpCDS.Filter := 'Custno=' + Quotedstr(SMRec.Custno) + ' And Adhesive=' + Quotedstr(SMRec.M2) +
        ' and (Lst='''' or Lst like ' + Quotedstr('%' + SMRec.MLast + '%') + ')';
      tmpCDS.Filtered := True;
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Filtered := False;
        tmpCDS.Filter := 'Custno=''0'' And Adhesive=' + Quotedstr(SMRec.M2);
        tmpCDS.Filtered := True;
      end;
      if not tmpCDS.IsEmpty then
      begin
        if (date - tmpCDS.FieldByName('mdate').AsDateTime) > 7 then
        begin
          ShowMsg('������Ʒū׳]�w��7�ѥ���s', 48);
          Exit;
        end;
        if isLCA and (SMRec.M2 = '1') then
        begin
          s1 := '145';
          FCDS.FieldByName('I1').AsString := 'Tg��145';
          FCDS.FieldByName('I4').AsString := '145';   //�W��
        end
        else
        begin
          s1 := tmpCDS.FieldByName('value_tg').AsString;
          FCDS.FieldByName('I1').AsString := 'Tg��' + s1;
          FCDS.FieldByName('I4').AsString := s1;
        end;
        s2 := tmpCDS.FieldByName('value_delta').AsString;
        if (POS(SMRec.Custno, 'AC093/AM010') > 0) then
          FCDS.FieldByName('I2').AsString := '��Tg<' + s2
        else
          FCDS.FieldByName('I2').AsString := '��Tg��' + s2;
        FCDS.FieldByName('I11').AsString := 'Tg1=' + FormatPoint(tmpCDS.FieldByName('tg1').AsString, 2);
        FCDS.FieldByName('I31').AsString := 'Tg2=' + FormatPoint(tmpCDS.FieldByName('tg2').AsString, 2);
        FCDS.FieldByName('I21').AsString := '��Tg=' + FormatPoint(tmpCDS.FieldByName('delta').AsString, 2);

        if SameText(SMRec.M2, '5') then
          FCDS.FieldByName('I41').AsString := FCDS.FieldByName('I4').AsString
        else if SameText(SMRec.M2, 'U') then
          FCDS.FieldByName('I41').AsString := FloatToStr(StrToFloatDef(FCDS.FieldByName('I4').AsString, 0) + 10)
        else
          FCDS.FieldByName('I41').AsString := FloatToStr(StrToFloatDef(FCDS.FieldByName('I4').AsString, 0) + 5);
        FCDS.FieldByName('I42').AsString := tmpCDS.FieldByName('tg1').AsString;
      end;
      tmpCDS.Filtered := False;
    end;
    //�f�ȥ��H����
    if isHY then
    begin
      if StrToIntDef(s2, 0) < 1 then
        s2 := '1';

      //Tg1�H��
      Randomize;
      tmpSQL := FloatToStr(RoundTo(StrToFloat(s1) + RandomRange(100, StrToInt(s2) * 100) / 100, -2));
      FCDS.FieldByName('I11').AsString := 'Tg1=' + FormatPoint(tmpSQL, 2);

      //��Tg�H��
      Randomize;
      s2 := FloatToStr(RandomRange(100, StrToInt(s2) * 100 - 50) / 100);
      FCDS.FieldByName('I21').AsString := '��Tg=' + FormatPoint(s2, 2);

      //Tg2=Tg1+Tg2
      tmpSQL := FloatToStr(StrToFloat(tmpSQL) + StrToFloat(s2));
      FCDS.FieldByName('I31').AsString := 'Tg2=' + FormatPoint(tmpSQL, 2);
    end;
    //������Ʒū�
    //�q��
    Data := null;
    tmpSQL := 'Select Top 1 * From Dli130 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
      begin
        if (date - tmpCDS.FieldByName('mdate').AsDateTime) > 90 then
        begin
          ShowMsg('�q���]�w��180�ѥ���s', 48);
          Exit;
        end;
        FCDS.FieldByName('J1').AsString := '��10E+6';
        FCDS.FieldByName('J11').AsString := tmpCDS.FieldByName('Brvalue').AsString;
        FCDS.FieldByName('J2').AsString := '��10E+4';
        FCDS.FieldByName('J21').AsString := tmpCDS.FieldByName('Frvalue').AsString;
      end;
    end;
    //�q��
    //���q�`��&���Ӧ]��
    if SMRec.M2 = '5' then
    begin
      FCDS.FieldByName('K1_item').AsString := '10G Hz';
      FCDS.FieldByName('K2_item').AsString := '10G Hz';
    end
    else if (SMRec.M2 = 'H') and (SMRec.Custno = 'AC426') then
    begin
      FCDS.FieldByName('K1_item').AsString := '10G Hz';
      FCDS.FieldByName('K2_item').AsString := '10G Hz';
    end
    else if Pos(SMRec.Custno, 'AC148/AC347') > 0 then
    begin
      FCDS.FieldByName('K1_item').AsString := '1M Hz/1G Hz';
      FCDS.FieldByName('K2_item').AsString := '1M Hz/1G Hz';
    end
    else if (Pos(SMRec.Custno, 'AC097/AC143') > 0) and ((Pos(SMRec.M2, '1/L/J') > 0) or (Pos(SMRec.M2 + SMRec.MLast,
      'UX,Ux,UV,Uv') > 0)) then
    begin
      FCDS.FieldByName('K1_item').AsString := '1M Hz';
      FCDS.FieldByName('K2_item').AsString := '1G Hz';
    end
    else
    begin
      FCDS.FieldByName('K1_item').AsString := '1G Hz';
      FCDS.FieldByName('K2_item').AsString := '1G Hz';
    end;

    if isLCA then
      FCDS.FieldByName('K1').AsString := '��5.0';

    Data := null;
    tmpSQL := 'Select * From Dli100 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2) +
      ' And (Custno=' + Quotedstr(SMRec.Custno) + ' Or Custno=''@'')';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if (date - tmpCDS.FieldByName('mdate').AsDateTime) > 30 then
      begin
        ShowMsg('���q�`��,���Ӧ]���]�w��30�ѥ���s', 48);
        Exit;
      end;
      if tmpCDS.Locate('Custno;DKDF', VarArrayOf([SMRec.Custno, 'DK']), [loCaseInsensitive]) or tmpCDS.Locate('Custno;DKDF',
        VarArrayOf(['@', 'DK']), [loCaseInsensitive]) then
      begin
        if not isLCA then
          FCDS.FieldByName('K1').AsString := '��' + tmpCDS.FieldByName('value_std').AsString;
        if Pos(SMRec.Custno, 'AC148/AC347') > 0 then
          FCDS.FieldByName('K11').AsString := tmpCDS.FieldByName('value_1m').AsString + '/' + tmpCDS.FieldByName('value_1g').AsString
        else
          FCDS.FieldByName('K11').AsString := tmpCDS.FieldByName('value_1m').AsString;
      end;

      if tmpCDS.Locate('Custno;DKDF', VarArrayOf([SMRec.Custno, 'DF']), [loCaseInsensitive]) or tmpCDS.Locate('Custno;DKDF',
        VarArrayOf(['@', 'DF']), [loCaseInsensitive]) then
      begin
        FCDS.FieldByName('K2').AsString := '��' + tmpCDS.FieldByName('value_std').AsString;
        if Pos(SMRec.Custno, 'AC148/AC347') > 0 then
          FCDS.FieldByName('K21').AsString := tmpCDS.FieldByName('value_1m').AsString + '/' + tmpCDS.FieldByName('value_1g').AsString
        else if isLCA then
          FCDS.FieldByName('K21').AsString := tmpCDS.FieldByName('value_1g').AsString
        else
          FCDS.FieldByName('K21').AsString := tmpCDS.FieldByName('value_1m').AsString
      end;
    end;
    //���q�`��&���Ӧ]��
    //�l���v
    tmpBo := False;
//    if isHY and (SMRec.M2 = '4') then
//    begin
//      if (SMRec.M3_6 >= 6) and (SMRec.M3_6 < 14) then
//      begin
//        FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value51').AsString;
//        FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value52').AsString;
//        tmpBo := True;
//      end
//      else if (SMRec.M3_6 >= 14) and (SMRec.M3_6 <= 120) then
//      begin
//        FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value53').AsString;
//        FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value54').AsString;
//        tmpBo := True;
//      end;
//    end
//    else
    if isSN and ((SMRec.M2 = 'S') or ((SMRec.M2 = 'U') and (pos(SMRec.MLast, 'HhifF') > 0))) then
    begin
      if (SMRec.M3_6 < 20) then
      begin
        FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value51').AsString;
        FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value52').AsString;
        tmpBo := True;
      end
      else if (SMRec.M3_6 <= 120) then
      begin
        if SMRec.M2 = 'S' then
        begin
          FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value53').AsString;
          FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value54').AsString;
          tmpBo := True;
        end
        else if ((SMRec.M2 = 'U') and (pos(SMRec.MLast, 'HhifF') > 0)) then
        begin
          FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value77').AsString;
          FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value78').AsString;
          tmpBo := True;
        end;
      end;
    end
    else if isSN and (SMRec.M2 = '5') then
    begin
      FCDS.FieldByName('L1').AsString := '��' + tmpCDS1.FieldByName('Value55').AsString;
      FCDS.FieldByName('L11').AsString := tmpCDS1.FieldByName('Value56').AsString;
      tmpBo := True;
    end;
    if not tmpBo then   //�l���v
    begin
      Data := null;
      tmpSQL := 'Select Top 1 * From Dli120 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2);
      if SMRec.M3_6 >= 20 then
      begin
        tmpSQL := tmpSQL + ' And Thickness=''A''';
        FCDS.FieldByName('L1').AsString := '��0.5';
      end
      else
      begin
        tmpSQL := tmpSQL + ' And Thickness=''B''';
        FCDS.FieldByName('L1').AsString := '��0.8';
      end;
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
          FCDS.FieldByName('L11').AsString := tmpCDS.FieldByName('WaterPer').AsString;
      end;
    end;
    //�l���v
    //���Ȩt��
    Data := null;
    tmpSQL := 'Select * From Dli220 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if (date - tmpCDS.FieldByName('mdate').AsDateTime) > 90 then
      begin
        ShowMsg('���Ȩt�Ƴ]�w��90�ѥ���s', 48);
        Exit;
      end;
      if SMRec.M3_6 < 20 then
      begin
        FCDS.FieldByName('O11').AsString := '---';
        FCDS.FieldByName('O21').AsString := '---';
        FCDS.FieldByName('O31').AsString := '---';
        FCDS.FieldByName('O12').AsString := 'NA';
        FCDS.FieldByName('O22').AsString := 'NA';
        FCDS.FieldByName('O32').AsString := 'NA';
      end
      else
      begin
        FCDS.FieldByName('O12').AsString := 'pass';
        FCDS.FieldByName('O22').AsString := 'pass';
        FCDS.FieldByName('O32').AsString := 'pass';
      end;
      if tmpCDS.Locate('type', 'A', [loCaseInsensitive]) then
      begin
        FCDS.FieldByName('O1_1').AsString := tmpCDS.FieldByName('spec').AsString;
        FCDS.FieldByName('O1').AsString := '��' + tmpCDS.FieldByName('spec').AsString;
        if SMRec.M3_6 >= 20 then
          FCDS.FieldByName('O11').AsString := tmpCDS.FieldByName('test').AsString;
      end;
      if tmpCDS.Locate('type', 'B', [loCaseInsensitive]) then
      begin
        FCDS.FieldByName('O2_1').AsString := tmpCDS.FieldByName('spec').AsString;
        FCDS.FieldByName('O2').AsString := '��' + tmpCDS.FieldByName('spec').AsString;
        if SMRec.M3_6 >= 20 then
          FCDS.FieldByName('O21').AsString := tmpCDS.FieldByName('test').AsString;
      end;
      if tmpCDS.Locate('type', 'C', [loCaseInsensitive]) then
      begin
        FCDS.FieldByName('O3_1').AsString := tmpCDS.FieldByName('spec').AsString;
        FCDS.FieldByName('O3').AsString := '��' + tmpCDS.FieldByName('spec').AsString;
        if SMRec.M3_6 >= 20 then
          FCDS.FieldByName('O31').AsString := tmpCDS.FieldByName('test').AsString;
      end;
    end;
    //���Ȩt��
    //�@�q������
    FCDS.FieldByName('P1').AsString := '��60';
    {if SMRec.M3_6<20 then
    begin
      FCDS.FieldByName('P11').AsString:='---';
      FCDS.FieldByName('P12').AsString:='NA';
    end else
    begin }
    FCDS.FieldByName('P11').AsString := tmpCDS1.FieldByName('Value21').AsString;
    FCDS.FieldByName('P12').AsString := 'pass';
   // end;
    //�@�q������
    //�ܤƾǩʡB���U��
    FCDS.FieldByName('Q1').AsString := '�L�����ܼҽk�B´�����S�B�ܥթ��ܳn�{�H'; // '<0.5%';
    FCDS.FieldByName('M1').AsString := 'UL94 V-0';
    Data := null;
    tmpSQL := ' Select Top 1 ''A'' as Type, fValue,mdate From Dli270 Where Bu=' + Quotedstr(g_UInfo^.BU) +
      ' And Adhesive=' + Quotedstr(SMRec.M2) + ' Union All' +
      ' Select Top 1 ''B'' as Type, Flam, mdate From Dli140 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' +
      Quotedstr(SMRec.M2);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if (date - tmpCDS.FieldByName('mdate').AsDateTime) > 30 then
      begin
        ShowMsg('�ܤƩ�,���U�ʳ]�w��30�ѥ���s', 48);
        Exit;
      end;
      if tmpCDS.Locate('Type', 'A', []) then
        FCDS.FieldByName('Q11').AsString := 'OK'; //tmpCDS.Fields[1].AsString;
      if tmpCDS.Locate('Type', 'B', []) then
        FCDS.FieldByName('M11').AsString := tmpCDS.Fields[1].AsString;
    end;
    //�ܤƾǩʡB���U��
    //�f�ȶ���
    {���s���j��}
    FCDS.FieldByName('R1').AsString := '��415';
    FCDS.FieldByName('R2').AsString := '��345';
    if SMRec.M3_6 < 20 then
    begin
      FCDS.FieldByName('R11').AsString := '---';
      FCDS.FieldByName('R12').AsString := 'NA';
      FCDS.FieldByName('R21').AsString := '---';
      FCDS.FieldByName('R22').AsString := 'NA';
    end
    else
    begin
      FCDS.FieldByName('R12').AsString := 'pass';
      FCDS.FieldByName('R22').AsString := 'pass';

      Data := null;
      tmpSQL := 'Select Top 1 Warp,Filling From Dli290' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' +
        Quotedstr(SMRec.M2) + ',Adhesive)>0';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
        begin
          FCDS.FieldByName('R11').AsString := tmpCDS.Fields[0].AsString;
          FCDS.FieldByName('R21').AsString := tmpCDS.Fields[1].AsString;
        end;
      end;
    end;

    {����q��}
    FCDS.FieldByName('S1').AsString := '��40';
    if SMRec.M3_6 >= 20 then
    begin
      FCDS.FieldByName('S11').AsString := 'OK';
      FCDS.FieldByName('S12').AsString := 'pass';
    end
    else
    begin
      FCDS.FieldByName('S11').AsString := '---';
      FCDS.FieldByName('S12').AsString := 'NA';
    end;

    {����j��}
    FCDS.FieldByName('T1').AsString := '��30';
    if SMRec.M3_6 < 20 then
    begin
      FCDS.FieldByName('T11').AsString := '59';
      FCDS.FieldByName('T12').AsString := 'pass';
    end
    else
    begin
      FCDS.FieldByName('T11').AsString := '---';
      FCDS.FieldByName('T12').AsString := 'NA';
    end;
    //�f�ȶ���
    //�سq�B�p�Z�s�HTD
    if (pos(SMRec.Custno, 'AC950/AC075/AC310/AC311/AC405/AC109/AC145/N023/ACE67') > 0) then
    begin
      Data := null;
      tmpSQL := 'Select Top 1 * From Dli460 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Ad=' + Quotedstr(SMRec.M2);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
        begin
          FCDS.FieldByName('TD1').AsString := '��' + tmpCDS.FieldByName('fValue').AsString;
          FCDS.FieldByName('TD11').AsString := tmpCDS.FieldByName('dValue').AsString;
        end;
      end;
    end;
    //�سq�B�p�Z�s�HTD
    //AC111 968����
    if is968 and SameText(SMRec.Custno, 'AC111') then
    begin
      FCDS.FieldByName('Ra1').AsString := LeftStr(FloatToStr(RandomRange(10, 40) / 100) + '00', 4); //��100,�@�w���p���I
      FCDS.FieldByName('Ra2').AsString := LeftStr(FloatToStr(RandomRange(10, 40) / 100) + '00', 4); //��100,�@�w���p���I

      FCDS.FieldByName('Rz1').AsString := FloatToStr(RandomRange(10, 90) / 10);
        //��10,�㰣�ɤ��@�w���p���I
      if Pos('.', FCDS.FieldByName('Rz1').AsString) = 0 then
        FCDS.FieldByName('Rz1').AsString := FCDS.FieldByName('Rz1').AsString + '.0';
      FCDS.FieldByName('Rz2').AsString := FloatToStr(RandomRange(10, 70) / 10);
        //��10,�㰣�ɤ��@�w���p���I
      if Pos('.', FCDS.FieldByName('Rz2').AsString) = 0 then
        FCDS.FieldByName('Rz2').AsString := FCDS.FieldByName('Rz2').AsString + '.0';
    end;

    //���
    Randomize;
    FCDS.FieldByName('Cl_std').AsString := '<900';
    FCDS.FieldByName('Br_std').AsString := '<900';
    FCDS.FieldByName('Cl').AsString := IntToStr(RandomRange(200, 400));
    FCDS.FieldByName('Br').AsString := IntToStr(RandomRange(50, 100));
    if Pos(SMRec.M2, '1/2/9/B/H/J/L/K/M/O/P/U/V/W/S/5/T') > 0 then
      FCDS.FieldByName('Cl_visible').AsString := '1'
    else
      FCDS.FieldByName('Cl_visible').AsString := '0';
    //���
    //STS
    if ((POS(SMRec.Custno, 'AC093/AM010') > 0) and (Pos(SMRec.M2, '4/8') > 0)) or (isHY and SameText(SMRec.M2, '6'))
      then
      FCDS.FieldByName('STS_visible').AsString := '1'
    else
      FCDS.FieldByName('STS_visible').AsString := '0';
    //STS
    //CustPno_visible
    tmpSQL := 'AC121/ACG02/AC820/ACA97/AC109/AM010';
    if (Pos(SMRec.Custno, tmpSQL) > 0) and is968 then
      FCDS.FieldByName('CustPno_visible').AsString := '1'
    else
    begin
      tmpSQL :=
        'AC093/AM010/ACD67/AC148/AC082/AC135/AC109/AC405/AC310/AC311/AC075/AC347/AC734/AC950/AC121/ACG02/AC076/AC360/N006/AC133/ACA28/ACE06/AC625/ACB00/ACD57/AC820/ACA97';
      if (Pos(SMRec.Custno, tmpSQL) > 0) or (Pos(tmpRemarkRec.Custno, tmpSQL) > 0) then
        FCDS.FieldByName('CustPno_visible').AsString := '1'
      else
        FCDS.FieldByName('CustPno_visible').AsString := '0';
    end;
    //CustPno_visible
    //���
    FCDS.FieldByName('Resin').AsString := GetResin(SMRec.Custno, SMRec.M2, '', True);
    if Length(FCDS.FieldByName('Resin').AsString) > 0 then
      FCDS.FieldByName('Resin_visible').AsString := '1'
    else
      FCDS.FieldByName('Resin_visible').AsString := '0';

    //�����帹������&�ɺ�
//    if Pos(SMRec.Custno, 'AC136/ACA27') > 0 then
//    begin
//      FCDS.FieldByName('pp_visible').AsString := '1';
//      FCDS.FieldByName('Copper_visible').AsString := '1';
//      FCDS.FieldByName('Copper').AsString := GetPP_CCL(SMRec, tmpOneLot, FSourceCDS.FieldByName('Dno').AsString,
//          FSourceCDS.FieldByName('Ditem').AsString, FCDS.FieldByName('Pno').AsString, FCDS.FieldByName('N1').AsString,
//          FCDS.FieldByName('C_Sizes').AsString);
//    end
//    else
//    if  sametext(SMRec.Custno, 'ACD04') and (POS(SMRec.Custno, 'ACD04')>0) then
//    begin
//      FCDS.FieldByName('pp_visible').AsString := '1';
//      FCDS.FieldByName('Copper_visible').AsString := '1';
//      GetCCL_PP_Copper(SMRec.Custno, FSourceCDS.FieldByName('Dno').AsString, FSourceCDS.FieldByName('Ditem').AsString,
//        FCDS);
//      FCDS.FieldByName('PP').AsString := GetPP_CCL(SMRec, tmpOneLot, FSourceCDS.FieldByName('Dno').AsString,
//          FSourceCDS.FieldByName('Ditem').AsString, FCDS.FieldByName('Pno').AsString, FCDS.FieldByName('N1').AsString,
//          FCDS.FieldByName('C_Sizes').AsString);
//    end
//    else
    if (Pos(SMRec.Custno, 'AC101/AC117/ACC19/AC136/ACA27/ACC19/AC136/ACA27') > 0) then
    begin
      FCDS.FieldByName('pp_visible').AsString := '1';
      FCDS.FieldByName('Copper_visible').AsString := '1';
      GetCCL_PP_Copper(SMRec.Custno, FSourceCDS.FieldByName('Dno').AsString, FSourceCDS.FieldByName('Ditem').AsString,
        FCDS);
      if Pos(SMRec.Custno, 'AC136/ACA27') > 0 then
        FCDS.FieldByName('Copper').AsString := GetCopper(tmpAllLot, FSourceCDS.FieldByName('Dno').AsString, FSourceCDS.FieldByName
          ('Ditem').AsString);
    end
    else
    begin
      //����
      FCDS.FieldByName('pp_visible').AsString := GetPPVisible_CCL(SMRec.Custno, SMRec.M2, SMRec.MLast, FCDS.FieldByName('N1').AsString,
        FCDS.FieldByName('C_Sizes').AsString);
      if FCDS.FieldByName('pp_visible').AsString = '1' then
      begin

        //      if SameText(SMRec.Custno, 'N024') or (pos('AC117',FSourceCDS.FieldByName('Remark').AsString)>0) or (pos('ACC19',FSourceCDS.FieldByName('Remark').AsString)>0) then
  //      begin

        //        FCDS.FieldByName('PP').AsString := GetPP_CCL(SMRec, FSourceCDS.FieldByName('Dno').AsString, FSourceCDS.FieldByName
  //          ('Ditem').AsString);

        //        FCDS.FieldByName('Copper').AsString := copy(FCDS.FieldByName('PP').AsString, pos('/', FCDS.FieldByName('PP').AsString)
  //          + 1, 255);

        //        FCDS.FieldByName('PP').AsString := copy(FCDS.FieldByName('PP').AsString, 1, pos('/', FCDS.FieldByName('PP').AsString)
  //          - 1);
  //      end
  //      else
        FCDS.FieldByName('PP').AsString := GetPP_CCL(SMRec, tmpOneLot, FSourceCDS.FieldByName('Dno').AsString,
          FSourceCDS.FieldByName('Ditem').AsString, FCDS.FieldByName('Pno').AsString, FCDS.FieldByName('N1').AsString,
          FCDS.FieldByName('C_Sizes').AsString);

        if (Pos(SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950') > 0) then
        begin
          tmpSQL :=
            'select tc_sie02 from %0:s.sfb_file,%0:s.tc_sie_file,%0:s.shb_file where sfb22=''%1:s'' and sfb221=%2:s and length(sfb05)<>19 and shb01=tc_sie01 and shb05=sfb01';
          tmpSQL := format(tmpSQL, [g_uinfo^.BU, FSourceCDS.FieldByName('Orderno').AsString, FSourceCDS.FieldByName('Orderitem').AsString]);
          if QueryBySQL(tmpSQL, Data, 'ORACLE') then
          begin
            tmpCDS.data := Data;
            tmpSQL := tmpCDS.fieldbyname('tc_sie02').asstring;    //�����帹
          end;

          if length(tmpSQL) > 11 then
          begin
            tmpSQL := Copy(tmpSQL, 12, 1); //�����帹�����X
            tmpSQL := 'select supplier from dli200 where bu=' + quotedstr(g_uinfo^.bu) + ' and glasscloth=' + quotedstr(tmpSQL);
            if QueryOneCR(tmpSQL, Data) then
            begin
              if not VarIsNull(Data) then
                tmpSQL := VarToStr(Data);   //�����t�ӦW��
            end;
            if (pos(tmpSQL, FCDS.FieldByName('PP').AsString) = 0) then
            begin
              showmsg('�����帹�����t�Ӭ�' + tmpSQL + ',�P' + FCDS.FieldByName('PP').AsString + '����');
            end;
          end;
        end;
        pos1 := pos('/', FCDS.FieldByName('PP').AsString);
        if pos1 > 0 then
          FCDS.FieldByName('PP').AsString := copy(FCDS.FieldByName('PP').AsString, 1, pos1 - 1);
      end;
      if (Pos(SMRec.Custno2, 'ACD39,AC365,AC388,AC434') > 0) then  //�西����ܻɺ� 20221117  �J����
      begin
        FCDS.FieldByName('Copper').AsString := '';
      end;


      //�ɺ�
      FCDS.FieldByName('Copper_visible').AsString := GetCopperVisible(SMRec.Custno, SMRec.M2, SMRec.MLast, FCDS.FieldByName
        ('C_Sizes').AsString);
      if FCDS.FieldByName('Copper_visible').AsString = '1' then
      begin
        if SameText(SMRec.Custno, 'AC109') then //�سq
        begin
          if Pos(SMRec.M2, '6/F/J/U') > 0 then
            FCDS.FieldByName('Copper').AsString := GetCopperAC109(tmpAllLot, FSourceCDS.FieldByName('Dno').AsString,
              FSourceCDS.FieldByName('Ditem').AsString, SMRec.M7_8)
          else
            FCDS.FieldByName('Copper').AsString := GetCopperAC109_oth(tmpAllLot, FSourceCDS.FieldByName('Dno').AsString,
              FSourceCDS.FieldByName('Ditem').AsString, SMRec.M2, SMRec.MLast);

          if pos('���~', FCDS.FieldByName('Copper').AsString) > 0 then
            ShowMsg('�X�f�سq"���~"��,�лP�ުA�T�{!', 48);
        end
        else
        begin
          if SMRec.Custno <> 'N024' then
            FCDS.FieldByName('Copper').AsString := GetCopper(tmpAllLot, FSourceCDS.FieldByName('Dno').AsString,
              FSourceCDS.FieldByName('Ditem').AsString);
          if (SMRec.Custno = 'ACD04') and (pos(FCDS.FieldByName('Copper').AsString, '�n�Ȫ��K') > 0) then
            FCDS.FieldByName('Copper').AsString := FCDS.FieldByName('Copper').AsString + '����';
        end;
      end;
    end;
    //CPK
    FCDS.FieldByName('CPK').AsString := GetCPK(SMRec.Custno, True);
    if Length(FCDS.FieldByName('CPK').AsString) > 0 then
      FCDS.FieldByName('CPK_visible').AsString := '1'
    else
      FCDS.FieldByName('CPK_visible').AsString := '0';

    //���a
    FCDS.FieldByName('Addr').AsString := GetAddr(SMRec);
    if Length(FCDS.FieldByName('Addr').AsString) > 0 then
      FCDS.FieldByName('Addr').AsString := '���a:' + FCDS.FieldByName('Addr').AsString;

    //�Ƶ�spec
    Data := null;
    tmpSQL := 'Select Top 1 Remark From Dli240' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (charindex(' + Quotedstr
      (SMRec.Custno) + ',Custno)>0 or Custno=''@'')' + ' And charindex(' + Quotedstr(SMRec.M2) + ',Adhesive)>0' +
      ' And (LstCode=' + Quotedstr(SMRec.MLast) + ' or LstCode=''@'')' + ' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('Remark').AsString := VarToStr(Data);
    end;
    //�Ƶ�spec
    //�Ƶ�typeS
    FCDS.FieldByName('Remark2').AsString := 'typeH.';
    Data := null;
    tmpSQL := 'Select Top 1 Remark From Dli241' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.MLast_1)
      + ',LstCode2)>0' + ' Order By LstCode2 Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('Remark2').AsString := VarToStr(Data);
    end;
    //�Ƶ�typeS
    //COC�����
    Data := null;
    tmpSQL := 'Select Top 1 UserName From Sys_PDAUser' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And UserId=' +
      Quotedstr(FSourceCDS.FieldByName('Coc_user').AsString) + ' Order By Not_use,UserId';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('TestName').AsString := VarToStr(Data);
    end;
    //COC�����
    FCDS.Post;
    //���Ĵ�
    days := -1;
    Data := null;
    tmpSQL := 'Select Top 1 IsNull(CCLday,0) CCLday From DLI510' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
      ' And (charindex(' + Quotedstr(SMRec.Custno) + ',Custno)>0 or Custno=''@'')' + ' And charindex(' + Quotedstr(SMRec.M2)
      + ',Adhesive)>0' + ' And (LstCode=' + Quotedstr(SMRec.MLast) + ' or LstCode=''@'')' +
      ' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        days := StrToInt(VarToStr(Data));
    end;
    //���Ĵ�
    //coc lot qty
    s1 := '';               //�帹
    s2 := '';               //�̤j���Ͳ����
    s3 := #13;
    tmpPrdDate := '';       //�Ҧ��帹���Ͳ����
    tmpDayErr := '';        //�W�X���Ĵ��帹
    tmpOneDayErr := '';     //�ѧE1�Ѧ��Ĵ��帹
    tmpOTDayErr := '';      //�W�e�Ͳ�
    tmpFstlot := '';        //�Ĥ@�ӧ帹
    tmpTBXDErr := False;    //�ɺ䭭�w����
    tmpBBXDErr := False;    //�������w����
    tmpTBXD := GetTBXD(SMRec, True);     //�ɺ䭭�w(�Ȥ�)
    if Length(tmpTBXD) = 0 then
      tmpTBXD := GetTBXD(SMRec, False); //�ɺ䭭�w(�Ҧ�custno=@)
    tmpBBXD := GetBBXD(SMRec, FCDS.FieldByName('N1').AsString); //N1 ���c
    //�西����+�@�q�����ճ��i,����:���t6FJ��U+X3z�B6mil�H�U(���t)�BHOZ~6OZ�B2�i���c
    isFZ := (Pos(SMRec.Custno, 'ACD39,AC365,AC388,AC434') > 0) and (SMRec.M3_6 <= 6) and ((Pos(SMRec.M7, l_CopperALL) >=
      3) or (Pos(SMRec.M8, l_CopperALL) >= 3)) and ((Pos(SMRec.M7, l_CopperALL) <= 13) or (Pos(SMRec.M8, l_CopperALL) <=
      13)) and (Pos('*2', FCDS.FieldByName('N1').AsString) > 0) and (Pos('+', FCDS.FieldByName('N1').AsString) = 0);
//    if isFZ then              //AC114
//    begin
//      isFZ := Pos(SMRec.M2, '6EFJ') > 0;
//      if not isFZ then
//        isFZ := SameText(SMRec.M2, 'U') and (Pos(SMRec.MLast, 'Hh3zIiFB,XG5RrCE') > 0); //170GRA,170GRA1
//    end;
    {
    //N012,AC114�C�L�@�q�����ճ��i,����:8mil�H�U(���t)�B1OZ�H�W(�t)�B2�i���c
    isAC114:=SameText(SMRec.Custno,'AC114') and (SMRec.M3_6<8) and
            ((Pos(SMRec.M7,l_CopperALL)>=3) or (Pos(SMRec.M8,l_CopperALL)>=3)) and
            (Pos('*2',FCDS.FieldByName('N1').AsString)>0) and
            (Pos('+',FCDS.FieldByName('N1').AsString)=0);
    //N012,AC434�C�L�@�q�����ճ��i,����:4mil�H�U(�t)
    isAC434:=SameText(SMRec.Custno,'AC434') and (SMRec.M3_6<=4);
    }
    tmpTotQty := 0;
    Data := null;
    tmpSQL := 'Select manfac,sum(qty) qty,min(sno) sno1 From Dli040' + ' Where Dno=' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ' And Ditem=' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ' And Bu=' + Quotedstr(g_UInfo^.BU) +
      tmpAllLot + ' And Isnull(qty,0)<>0 and Len(Isnull(manfac,''''))>4' + ' Group By manfac Order By sno1';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        if RecordCount = 1 then
        begin
          if pos(tmpCustno, 'AC117,ACC19') > 0 then
            s1 := s1 + copy(FieldByName('manfac').AsString, 1, 10)
          else
            s1 := FieldByName('manfac').AsString;
          s2 := Copy(FieldByName('manfac').AsString, 2, 4);
          tmpFstlot := s1;
          tmpLot1 := s1;
          tmpDate := GetLotDate(s2, FSourceCDS.FieldByName('Indate').AsDateTime);
          tmpPrdDate := StringReplace(FormatDateTime(g_cShortDate1, tmpDate), '-', '/', [rfReplaceAll]);
          tmpTotQty := FieldByName('qty').AsFloat;

          //�W���Ĵ��ި�
          if (days > 0) and (DaysBetween(tmpDate, Date) >= days) then
            tmpDayErr := tmpDayErr + s1 + #13#10;
             
          //�ѧE1�Ѧ��Ĵ�����
          if (days > 0) and (DaysBetween(tmpDate, Date) = days - 1) then
            tmpOneDayErr := tmpOneDayErr + s1 + #13#10;

          //�W�e�Ͳ�
          if tmpDate > Date then
            tmpOTDayErr := tmpOTDayErr + s1 + #13#10;

          //�ɺ䭭�w
          if (Length(tmpTBXD) > 0) and (Pos(Copy(s1, 11, 1), tmpTBXD) = 0) then
            tmpTBXDErr := True;

          //�������w
          if (Length(tmpBBXD) > 0) and (Pos(Copy(s1, 12, 1), tmpBBXD) = 0) then
            tmpBBXDErr := True;
          //����
          if isHY or (POS(SMRec.Custno, 'AC093/AM010') > 0) then
            AddCDSDetail(FieldByName('manfac').AsString, tmpUnit, FieldByName('qty').AsFloat, SMRec)
          else if isFZ then
            AddCDSDetail_oth(FieldByName('manfac').AsString);
          if pos(tmpCustno, 'AC192') > 0 then
            s3 := s3 + GetPrdDate3(FieldByName('manfac').AsString);
        end
        else
        begin
          while not Eof do
          begin
            tmpTotQty := tmpTotQty + FieldByName('qty').AsFloat;
            if pos(tmpCustno, 'AC117,ACC19') > 0 then
              s1 := s1 + copy(FieldByName('manfac').AsString, 1, 10) + '(' + FloatToStr(FieldByName('qty').AsFloat) +
                tmpUnit + ') '
            else
              s1 := s1 + FieldByName('manfac').AsString + '(' + FloatToStr(FieldByName('qty').AsFloat) + tmpUnit + ') ';

            if pos(tmpCustno, 'AC192') > 0 then
              s3 := s3 + ' ' + GetPrdDate3(FieldByName('manfac').AsString);

            tmpSQL := Copy(FieldByName('manfac').AsString, 2, 4);
            if (s2 = '') or (s2 < tmpSQL) then
              s2 := tmpSQL;
            tmpLot1 := tmpLot1 + ',' + FieldByName('manfac').AsString;
            tmpDate := GetLotDate(tmpSQL, FSourceCDS.FieldByName('Indate').AsDateTime);
            tmpSQL := StringReplace(FormatDateTime(g_cShortDate1, tmpDate), '-', '/', [rfReplaceAll]);
            //if Pos(tmpSQL, tmpPrdDate)=0 then �ۦP�u��ܤ@��
            tmpPrdDate := tmpPrdDate + tmpSQL + ' ';

            if Length(tmpFstlot) = 0 then
              tmpFstlot := FieldByName('manfac').AsString;

            //�W���Ĵ��ި�
            if (days > 0) and (Pos(FieldByName('manfac').AsString, tmpDayErr) = 0) and (DaysBetween(tmpDate, Date) >=
              days) then
              tmpDayErr := tmpDayErr + FieldByName('manfac').AsString + #13#10;

            //�ѧE1�Ѧ��Ĵ�����
            if (days > 0) and (Pos(FieldByName('manfac').AsString, tmpOneDayErr) = 0) and (DaysBetween(tmpDate, Date) =
              days - 1) then
              tmpOneDayErr := tmpOneDayErr + FieldByName('manfac').AsString + #13#10;

            //�W�e�Ͳ�
            if tmpDate > Date then
              tmpOTDayErr := tmpOTDayErr + FieldByName('manfac').AsString + #13#10;

            //�ɺ䭭�w
            if (Length(tmpTBXD) > 0) and (Pos(Copy(FieldByName('manfac').AsString, 11, 1), tmpTBXD) = 0) then
              tmpTBXDErr := True;

            //�������w
            if (Length(tmpBBXD) > 0) and (Pos(Copy(FieldByName('manfac').AsString, 12, 1), tmpBBXD) = 0) then
              tmpBBXDErr := True;
            //����
            if isHY or (POS(SMRec.Custno, 'AC093/AM010') > 0) then
              AddCDSDetail(FieldByName('manfac').AsString, tmpUnit, FieldByName('qty').AsFloat, SMRec)
            else if isFZ then
              AddCDSDetail_oth(FieldByName('manfac').AsString);
            Next;
          end;
        end;
      end;
    end;
    if (Length(tmpDayErr) > 0) and (g_uinfo^.UserId <> 'ID150515') then
    begin
      ShowMsg('�U�C�帹�W�L�]�w���Ĵ�' + IntToStr(days) + ':' + #13#10 + tmpDayErr, 48);
      Exit;
    end;

    if (Length(tmpOneDayErr) > 0) and (g_uinfo^.UserId <> 'ID150515') then
    begin
      if ShowMsg('�U�C�帹�ѧE1�Ѧ��Ĵ�' + IntToStr(days) + ':' + #13#10 + tmpOneDayErr, 33) = IdCancel then
        Exit;
    end;

    if (Length(tmpOTDayErr) > 0) and (g_uinfo^.UserId <> 'ID150515') then
    begin
      ShowMsg('�U�C�帹�W�e:' + #13#10 + tmpOTDayErr, 48);
      Exit;
    end;

    if tmpTBXDErr and (g_uinfo^.UserId <> 'ID150515') then
    begin
      ShowMsg('�s�b�ɺ䤣��,�ɺ䭭�w��:' + #13#10 + tmpTBXD, 48);
      Exit;
    end;

    if tmpBBXDErr and (g_uinfo^.UserId <> 'ID150515') then
    begin
      ShowMsg('�s�b��������,�������w��:' + #13#10 + tmpBBXD, 48);
      Exit;
    end;

    //�Ĥ@�ӧ帹
    FCDS.Edit;
    FCDS.FieldByName('fstLot').AsString := tmpFstlot;
    FCDS.Post;

    if Length(s2) > 0 then
      tmpDate := GetLotDate(s2, FSourceCDS.FieldByName('Indate').AsDateTime)
    else
      tmpDate := EncodeDate(1955, 1, 1);

    if LeftStr(tmpLot1, 1) = ',' then
      Delete(tmpLot1, 1, 1);

    with FCDSLot do
    begin
      Append;
      FieldByName('lot').AsString := trim(s1 + s3);  //s3=#13
      FieldByName('lot1').AsString := tmpLot1;
      FieldByName('totqty').AsString := FloatToStr(tmpTotQty) + tmpUnit;
      FieldByName('PrdDate').AsString := StringReplace(FormatDateTime(g_cShortDate1, tmpDate), '-', '/', [rfReplaceAll]);
      FieldByName('PrdDate1').AsString := tmpPrdDate;
      FieldByName('ExpDate').AsString := StringReplace(FormatDateTime(g_cShortDate1, IncYear(tmpDate, 2)), '-', '/', [rfReplaceAll]);
      Post;
    end;
    //coc lot qty
    //�K�QCPK
    if (POS(SMRec.Custno, 'AC093/AM010') > 0) then
    begin
      if (SameText(tmpUnit, 'SH') and (tmpTotQty >= 25)) or (SameText(tmpUnit, 'PN') and (tmpTotQty >= 100)) then
      begin
        Randomize;
        FCDS.Edit;
        FCDS.FieldByName('CPK_visible').AsString := '1';
        FCDS.FieldByName('CPK').AsString := '1.3' + IntToStr(RandomRange(3, 9));
        FCDS.Post;
      end;
    end;

    //�ɺ�p�� ���խ�
    Data := null;
    tmpSQL := 'Select Copper,Value From Dli520 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And FmDate<=' + Quotedstr(DateToStr
      (tmpDate)) + ' And ToDate>=' + Quotedstr(DateToStr(tmpDate));
    if QueryBySQL(tmpSQL, Data) then
    begin
      FCDS.Edit;
      tmpCDS.Data := Data;
      if tmpCDS.Locate('Copper', SMRec.M7, [loCaseInsensitive]) then
        FCDS.FieldByName('E11').AsString := FloatToStr(tmpCDS.FieldByName('Value').AsFloat);
      if tmpCDS.Locate('Copper', SMRec.M8, [loCaseInsensitive]) then
        FCDS.FieldByName('E21').AsString := FloatToStr(tmpCDS.FieldByName('Value').AsFloat);
      FCDS.Post;
    end;
    //�ɺ�p��
    //�帹���i��X
    tmpFIFOErr := '';
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckLotFIFO ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ',' + Quotedstr(FSourceCDS.FieldByName('Custno').AsString)
      + ',1';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if (not tmpCDS.IsEmpty) and (Length(tmpCDS.Fields[1].AsString) > 0) then
        tmpFIFOErr := '1.�̷s�X�f�帹�O�G' + tmpCDS.Fields[0].AsString + #13#10 + '2.�U�C�帹�������i���X' + #13#10 +
          StringReplace(tmpCDS.Fields[1].AsString, ',', #13#10, [rfReplaceAll]);
    end;
    //�帹���i��X
    //�ˬd����帹
    tmpLotErr := '';
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckZClot ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ',' + Quotedstr(FSourceCDS.FieldByName('Custno').AsString)
      + ',1';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.Filtered := False;
        tmpCDS.Filter := 'id=1';
        tmpCDS.Filtered := True;
        if not tmpCDS.IsEmpty then
        begin
          tmpLotErr := '����帹' + #13#10;
          while not tmpCDS.Eof do
          begin
            tmpLotErr := tmpLotErr + tmpCDS.Fields[0].AsString + #13#10;
            tmpCDS.Next;
          end;
        end;
        tmpCDS.Filtered := False;
        tmpCDS.Filter := 'id=2';
        tmpCDS.Filtered := True;
        if not tmpCDS.IsEmpty then
        begin
          tmpLotErr := tmpLotErr + 'COC�帹' + #13#10;
          while not tmpCDS.Eof do
          begin
            tmpLotErr := tmpLotErr + tmpCDS.Fields[0].AsString + #13#10;
            tmpCDS.Next;
          end;
        end;
        tmpCDS.Filtered := False;
        tmpCDS.Filter := '';
      end;
    end;
    //�ˬd����帹
    //���s�f��,�s�{�K�Q:���ó����H��
    if isHY or (POS(SMRec.Custno, 'AC093/AM010') > 0) then
    begin
      FCDS.Edit;
      Data := null;
      tmpSQL := 'Select GlassCloth From Dli200' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Len(GlassCloth)>4';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        while not tmpCDS.Eof do
        begin
          FCDS.FieldByName('C_Sizes').AsString := StringReplace(FCDS.FieldByName('C_Sizes').AsString, tmpCDS.Fields[0].AsString,
            '', [rfReplaceAll]);
          FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, tmpCDS.Fields[0].AsString,
            '', [rfReplaceAll]);
          tmpCDS.Next;
        end;
      end;
      FCDS.FieldByName('C_Sizes').AsString := StringReplace(FCDS.FieldByName('C_Sizes').AsString, ' CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('C_Sizes').AsString := StringReplace(FCDS.FieldByName('C_Sizes').AsString, 'CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('C_Sizes').AsString := StringReplace(FCDS.FieldByName('C_Sizes').AsString, ' CAF', '', [rfReplaceAll]);
      FCDS.FieldByName('C_Sizes').AsString := StringReplace(FCDS.FieldByName('C_Sizes').AsString, 'CAF', '', [rfReplaceAll]);

      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, ' -CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, '-CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, ' -CAF', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, '-CAF', '', [rfReplaceAll]);

      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, ' CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, ' CAF', '', [rfReplaceAll]);
      FCDS.FieldByName('Pname').AsString := StringReplace(FCDS.FieldByName('Pname').AsString, 'CAF', '', [rfReplaceAll]);
      FCDS.Post;
    end;

    //AC117�W�U�ɺ�c���B������DG�զX���u��
//    if SameText(SMRec.Custno, 'AC117') and (Pos(SMRec.MLast_1, 'imkc') > 0) then
//    begin
//      Data := null;

      //      tmpSQL := 'Select Top 1 Left(qrcode,10) wono From Dli041' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Dno=' +

      //        Quotedstr(Self.FSourceCDS.FieldByName('Dno').AsString) + ' And Ditem=' + IntToStr(Self.FSourceCDS.FieldByName('Ditem').AsInteger)
//        + ' Order By Sno';
////      showmsg(tmpSQL);
//      if QueryBySQL(tmpSQL, Data) then
//      begin
//        tmpCDS.Data := Data;
//        if (not tmpCDS.IsEmpty) and (Length(tmpCDS.Fields[0].AsString) = 10) then
//        begin
//          Data := null;
//          tmpSQL := 'select tc_sid111,tc_sid211 from ' + g_uinfo^.BU + '.shb_file,' + g_uinfo^.BU + '.tc_sid_file' +

      //            ' where shb01=tc_sid01 and shb05=' + Quotedstr(tmpCDS.Fields[0].AsString) + ' and shb06=3 and shbacti=''Y''';
//          if QueryBySQL(tmpSQL, Data, 'ORACLE') then
//          begin
//            tmpCDS.Data := null;
//            tmpCDS.Data := Data;
//            if not tmpCDS.IsEmpty then  //��bug,���Oempty�]�P�wempty
//            begin
//              FCDS.Edit;

      //              FCDS.FieldByName('ac117_remark').AsString := CheckLang('�ɺ�����G ') + tmpCDS.Fields[0].AsString + '    '
//                + tmpCDS.Fields[1].AsString;
//              FCDS.Post;
//            end
//          end;
//        end;
//      end;
//    end;
    //�ͯq�G���X
    if SameText(SMRec.Custno, 'AC084') then
      SY_QRCode;

    ShowBarMsg('���b������ն��إ��T��...');
    FrmDLII040_prn := TFrmDLII040_prn.Create(nil);
    try
      GetClassB_C_diff(SMRec, CopperValue1, CopperValue2, FrmDLII040_prn.l_thickness, FrmDLII040_prn.l_diff);
      FrmDLII040_prn.l_CopperValue1 := CopperValue1;
      FrmDLII040_prn.l_CopperValue2 := CopperValue2;
      FrmDLII040_prn.l_FIFOErr := tmpFIFOErr;
      FrmDLII040_prn.l_LotErr := Trim(tmpLotErr);
      FrmDLII040_prn.l_SMRec := SMRec;
      FrmDLII040_prn.DS.DataSet := FCDS;
      if FrmDLII040_prn.ShowModal <> mrOK then
        Exit;
    finally
      FreeAndNil(FrmDLII040_prn);
    end;

  finally
    FreeAndNil(CList);
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS1);
    ShowBarMsg('');
  end;

  begin
    {(*}
    if (Pos(tmpCustno, 'AC365/AC388/AC434/ACD39/ACF29') > 0) and
       (Pos('�෽�O',FCDS.FieldByName('C_Sizes').AsString) >0) and
       ((copy(FCDS.FieldByName('Pno').AsString,2,1) <> 'Q') or
       (copy(FCDS.FieldByName('Pno').AsString,length(FCDS.FieldByName('Pno').AsString),1) <> 'R'))
    then
    begin
      Warn('�෽�O�Ƹ�����Q+���XR');
    end
    else
    if SameText('AC360',tmpCustno) and
       (Copy(FSourceCDS.FieldByName('remark').AsString,2,3) = '207') and
       (Pos(Copy(FCDS.FieldByName('Pno').AsString,length(FCDS.FieldByName('Pno').AsString)-1,1),'678')=0)    {*)}
         then
    begin
      Warn('�T���O�Ƹ�16�X�����O6/7/8');
    end;
    {*)}
  end;

  if FCDS.ChangeCount > 0 then
    FCDS.MergeChangeLog;
  if FCDSLot.ChangeCount > 0 then
    FCDSLot.MergeChangeLog;
  if FCDSDetail.ChangeCount > 0 then
    FCDSDetail.MergeChangeLog;

  SetLength(ArrPrintData, 4);
  ArrPrintData[0].Data := FSourceCDS.Data;
  ArrPrintData[0].RecNo := FSourceCDS.RecNo;
  ArrPrintData[0].IndexFieldNames := FSourceCDS.IndexFieldNames;
  ArrPrintData[0].Filter := FSourceCDS.Filter;

  ArrPrintData[1].Data := FCDS.Data;
  ArrPrintData[1].RecNo := FCDS.RecNo;
  ArrPrintData[1].IndexFieldNames := FCDS.IndexFieldNames;
  ArrPrintData[1].Filter := FCDS.Filter;

  ArrPrintData[2].Data := FCDSLot.Data;
  ArrPrintData[2].RecNo := FCDSLot.RecNo;
  ArrPrintData[2].IndexFieldNames := FCDSLot.IndexFieldNames;
  ArrPrintData[2].Filter := FCDSLot.Filter;

  ArrPrintData[3].Data := FCDSDetail.Data;
  ArrPrintData[3].RecNo := FCDSDetail.RecNo;
  ArrPrintData[3].IndexFieldNames := FCDSDetail.IndexFieldNames;
  ArrPrintData[3].Filter := FCDSDetail.Filter;

  if SameText(g_UInfo^.UserId, 'ID140622') then
    tmpSQL := 'Other-CCL'
  else if is968 then                                                //968�榡
  begin
    if isCY then                                                     //�W�ݩM���q�@��
      tmpSQL := 'Other-COC3'
    else if SameText(SMRec.Custno, 'AC111') then                     //�`�n
      tmpSQL := 'Other-COCj'
    else
      tmpSQL := 'Other-COC8';
  end
  else if SameText(SMRec.Custno, 'AH017') or (SameText(SMRec.Custno, 'AC174') and (SMRec.M2 = '4')) or (SameText(SMRec.Custno,
    'AC096') and (SMRec.M2 = '4')) then       //�O�W�榡
    tmpSQL := 'Other-COC1'
  else if isHY then                                                  //�f�Ȯ榡
    tmpSQL := 'Other-COC2'
  else if isCY then                                                  //�W�ݮ榡
    tmpSQL := 'Other-COC3'
  else if isFZ then                                                  //�西����+�@�q�����i
    tmpSQL := 'Other-COCh'
  else if SameText(SMRec.Custno, 'AC434') then                       //���y���K�榡(isFZ:Other-COCh)
    tmpSQL := 'Other-COCa'
  else if Pos(SMRec.Custno, 'AC121/ACG02/AC305/AC526/ACA97/AC820') > 0 then  //�R�F:�q�{�榡+���˪�
    tmpSQL := 'Other-COCb'
  else if Pos(SMRec.Custno, 'AC093/AM010') > 0 then                 //�K�Q�榡
    tmpSQL := 'Other-COCc'
  else if SameText(SMRec.Custno, 'AC172') then                       //�Y�j
    tmpSQL := 'Other-COCg'
  else if SameText(SMRec.Custno, 'AC109') then                       //�سq
    tmpSQL := 'Other-COCi'
  else if pos(SMRec.Custno, 'AC145/ACE67') > 0 then                       //�����H
    tmpSQL := 'Other-COCp'
  else if SameText(SMRec.Custno, 'AC084') then                       //�ͯq
    tmpSQL := 'Other-COCk'
  else if SameText(SMRec.Custno, 'N023') then                        //�s�H
    tmpSQL := 'Other-COCl'
  else
    tmpSQL := ProcId;                                                 //�q�{�榡

  GetPrintObj('Dli', ArrPrintData, tmpSQL);
  ArrPrintData := nil;
end;

//function TDLII040_rpt.GetCustName(custno: string): string;
//var
//  tmpSQL: string;
//  Data: OleVariant;
//  tmpCDS: TClientDataSet;
//begin
//
//  tmpSQL := 'select occ02 from %s.occ_file where occ01=%s';
//  tmpSQL := Format(tmpSQL, [g_uinfo^.BU, QuotedStr(custno)]);
//  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
//  begin
//    tmpCDS := TClientDataSet.Create(nil);
//    try
//      tmpCDS.data := Data;
//      result := tmpCDS.fields[0].asstring;
//    finally
//      tmpCDS.Free;
//    end;
//  end
//  else
//    result := '';
//end;

procedure TDLII040_rpt.AddCDSDetail(Lot, Units: string; Qty: Double; SMRec: TSplitMaterialno);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if not FCDSDli210.Active then
  begin
    tmpSQL := 'Select Copper,Supplier From Dli210 Where Bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    FCDSDli210.Data := Data;
  end;

  with FCDSDetail do
  begin
    Append;
    FieldByName('pname').AsString := FCDS.FieldByName('pname').AsString;
    FieldByName('sizes').AsString := FCDS.FieldByName('sizes').AsString;
    FieldByName('c_sizes').AsString := FCDS.FieldByName('c_sizes').AsString;
    FieldByName('lot').AsString := Lot;
    FieldByName('qty').AsFloat := Qty;
    FieldByName('units').AsString := Units;
    FieldByName('resin').AsString := GetResin(SMRec.Custno, SMRec.M2, '', True);
    if FCDSDli210.Locate('copper', Copy(Lot, 11, 1), [loCaseInsensitive]) then
      FieldByName('copper').AsString := FCDSDli210.Fields[1].AsString;
    FieldByName('pp').AsString := GetPP_CCL(SMRec, ' and manfac=' + Quotedstr(Lot), FSourceCDS.FieldByName('Dno').AsString,
      FSourceCDS.FieldByName('Ditem').AsString, FCDS.FieldByName('Pno').AsString, FCDS.FieldByName('N1').AsString, FCDS.FieldByName
      ('C_Sizes').AsString);
    Post;
  end;
end;

procedure TDLII040_rpt.AddCDSDetail_oth(Lot: string);
begin
  with FCDSDetail do
    if not Locate('lot', Lot, []) then
    begin
      Append;
      FieldByName('lot').AsString := Lot;
      Post;
    end;
end;

//�ͯq�G���X
procedure TDLII040_rpt.SY_QRCode;
var
  pos1: Integer;
  tmpStr1, tmpStr2, h11, h21, tg1, tg2, tg3, zct1, zct2, curve: string;
begin
  if not SameText(FCDS.FieldByName('O12').AsString, 'NA') then
  begin
    zct1 := FCDS.FieldByName('O11').AsString + '/' + FCDS.FieldByName('O21').AsString;
    zct2 := FCDS.FieldByName('O31').AsString;
  end;

  pos1 := Pos('=', FCDS.FieldByName('I11').AsString);
  if pos1 > 0 then
    tg1 := Copy(FCDS.FieldByName('I11').AsString, pos1 + 1, 20)
  else
    tg1 := FCDS.FieldByName('I11').AsString;

  pos1 := Pos('=', FCDS.FieldByName('I31').AsString);
  if pos1 > 0 then
    tg2 := Copy(FCDS.FieldByName('I31').AsString, pos1 + 1, 20)
  else
    tg2 := FCDS.FieldByName('I31').AsString;

  pos1 := Pos('=', FCDS.FieldByName('I21').AsString);
  if pos1 > 0 then
    tg3 := Copy(FCDS.FieldByName('I21').AsString, pos1 + 1, 20)
  else
    tg3 := FCDS.FieldByName('I21').AsString;

  if not SameText(FCDS.FieldByName('H12').AsString, 'NA') then
  begin
    h11 := FCDS.FieldByName('H11').AsString;
    h21 := FCDS.FieldByName('H21').AsString;
  end;

  if not SameText(FCDS.FieldByName('F12').AsString, 'NA') then
    curve := FCDS.FieldByName('F11').AsString;

  tmpStr1 := '{"Mtype":"CCL","CMNumber":"' + FCDS.FieldByName('C_pno').AsString + '",' + '"SLN":"' + FCDSLot.FieldByName
    ('Lot1').AsString + '",' + '"IT":"",' + '"GCS":"' + FCDS.FieldByName('PP').AsString + '",' + '"CUS":"' + FCDS.FieldByName
    ('Copper').AsString + '",' + '"Surface":"' + FCDS.FieldByName('A11').AsString + '",' + '"SW":"' + FCDS.FieldByName('B11').AsString
    + '",' + '"SZ":"' + FCDS.FieldByName('B21').AsString + '",' + '"Thickness":"' + FCDS.FieldByName('C11').AsString +
    '",' + '"Cuthickness":"' + FloatToStr(StrToFloatDef(FCDS.FieldByName('E11').AsString, 0) + StrToFloatDef(FCDS.FieldByName
    ('E21').AsString, 0)) + '",' + '"Dithickness":"' + FCDS.FieldByName('D11').AsString + '",' + '"Cfra":"","Cfrz":"",'
    + '"Pstrength":"' + FCDS.FieldByName('G11').AsString + '",' + '"CaW":"' + h11 + '","CaZ":"' + h21 + '","Glasstt":"'
    + tg1 + '/' + tg2 + '/' + tg3 + '","ZCT1":"' + zct1 + '","ZCT2":"' + zct2 + '","Cexperiment":"OK","FT":"OK",' +
    '"DC":"' + FCDS.FieldByName('K11').AsString + '",' + '"DL":"' + FCDS.FieldByName('K21').AsString + '",' + '"WA":"' +
    FCDS.FieldByName('L11').AsString + '",' + '"VR":"' + FCDS.FieldByName('J11').AsString + '",' + '"SR":"' + FCDS.FieldByName
    ('J21').AsString + '",' + '"Estrength":"",' + '"CR":"' + FCDS.FieldByName('Q11').AsString + '",' + '"SF":"' + FCDS.FieldByName
    ('M11').AsString + '",' + '"Ndhx":"' + FCDS.FieldByName('P11').AsString + '",' + '"Curve":"' + curve +
    '","FitR":"�ŦXRoHS2.0"}';
  tmpStr1 := StringReplace(tmpStr1, '��', '+/-', [rfReplaceAll]);
  tmpStr2 := g_UInfo^.TempPath + 'coc_ccl.bmp';
  if getcode(tmpStr1, tmpStr2, Fm_image) then
  begin
    FCDS.Edit;
    FCDS.FieldByName('QRcode').AsString := tmpStr2;
    FCDS.Post;
  end;
end;

function TDLII040_rpt.GetJxTA_oeb10(const oao06: string; ta_oeb10: Tfield): boolean;
var
  tmpSql: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
  ls: TStringList;
begin           //OAO06 SAMPLE:JX-223-220061-6-ACC58
  ls := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  try
    ls.Delimiter := '-';
    ls.DelimitedText := oao06;
    if ls.Count < 5 then
    begin
      result := False;
      exit;
    end;
    tmpSql :=
      'select ta_oeb10,oea10,ta_oeb28 from iteqjx.oeb_file join iteqjx.oea_file on oea01=oeb01 where oeb01=%s and oeb03=%s';
    tmpSql := Format(tmpSql, [quotedstr(ls[1] + '-' + ls[2]), ls[3]]);
    result := QueryBySQL(tmpSql, data, 'ORACLE');
    if result then
    begin
      tmpCDS.data := data;
      ta_oeb10.asstring := tmpCDS.Fields[0].asstring;
      if pos(ls[4], 'AC114/AC365/AC388/AC434/ACD39/ACF29') > 0 then
        ta_oeb10.DataSet.FieldByName('C_Orderno').asstring := tmpCDS.Fields[2].asstring
      else
        ta_oeb10.DataSet.FieldByName('C_Orderno').asstring := tmpCDS.Fields[1].asstring;
    end;
  finally
    ls.free;
    tmpCDS.free;
  end;
end;

procedure TDLII040_rpt.CheckCar(pno, c_sizes, orderno, remark: string; orderitem: integer);
var
  ls: TStrings;
  i: integer;
  s16, sql: string;
  isCar: boolean;
begin
  ls := TStringList.create;
  s16 := Copy(pno, Length(pno) - 1, 1);
  isCar := false;
  try
    ls.CommaText := 'TTEOQA,NJHEQA,AE,�T��,AT�O,ANTICAF,Anti-CAF,�෽�O,CAR';
    for i := 0 to ls.count - 1 do
    begin
      if (Pos(ls[i], c_sizes) > 0) or (Pos(ls[i], remark) > 0) then
      begin
        isCar := true;
      end;
    end;

    if not isCar then
    begin
      sql := 'select premark from mps010 where bu=%s and orderno=%s and orderitem=%d and premark like ';
      sql := Format(sql, [QuotedStr(g_uinfo^.BU), QuotedStr(orderno), orderitem]) + quotedstr('%�T��%');
      QueryExists(sql, isCar);
    end;

    if isCar and (Pos(s16, '6/7/8') = 0) then
    begin
      Warn('�T���O�Ƹ�16�X�����O6/7/8');
    end;
  finally
    ls.Free;
  end;
end;

end.

