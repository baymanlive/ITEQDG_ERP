{*******************************************************}
{                                                       }
{                unDLII041_rpt                          }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: COC-PP列印                }
{                             DLII041、DLIR050共用此單元}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII041_rpt;

interface

uses
  Windows, Classes, SysUtils, DB, DBClient, Forms, Variants, Math, StrUtils, Controls, ComCtrls, DateUtils, unGlobal,
  unCommon, unDLII041_prn, Graphics, unDLII040_cocerr, unDLIR050_units, unCheckC_sizes, TWODbarcode;

type
  TDLII041_rpt = class
  private
    Fm_image: PTIMAGESTRUCT;
    FCDS: TClientDataSet;
    FCDSLot: TClientDataSet;
    FCDSDetail: TClientDataSet;
    FCDSDli200: TClientDataSet;
    FCheckC_sizes: TCheckC_sizes;
    procedure ShowBarMsg(msg: string);
    function GetRC: string;
    function GetBBXD(SMRec: TSplitMaterialnoPP;custno:string=''): string;
    function GetAddr(SMRec: TSplitMaterialnoPP): string;
    function SetFGHI_FromDli340(DataSet: TDataSet; SMRec: TSplitMaterialnoPP): Boolean;
    procedure AddCDSDetail(Lot, Units, RC: string; Qty: Double; SMRec: TSplitMaterialnoPP);
    procedure SY_QRCode;
    function GetJxTA_oeb10(const oao06: string; ta_oeb10: Tfield): boolean;
    procedure CheckCar(pno, c_sizes, orderno, remark: string; orderitem: integer);
//    procedure SetSourceCDS(const Value: TClientDataSet);
  public
    FSourceCDS: TClientDataSet;
    constructor Create(CDS: TClientDataSet);
    destructor Destroy; override;
    procedure StartPrint(ProcId, qrcode: string; ds3: TDataset = nil);
  end;

implementation

uses
  unFrmWarn;

const
  l_CDSXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="IsPPCOC" fieldtype="boolean"/>' + '<FIELD attrname="Indate" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="Indate1" fieldtype="string" WIDTH="20"/>' //年月日
    + '<FIELD attrname="Fileno" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="TestName" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="E_seal" fieldtype="boolean"/>' +
    '<FIELD attrname="A" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="B" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="C" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="D1" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="D11" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="D2" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="D21" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="E1_unit" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="E1" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="E11" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="E2_unit" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="E2" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="E21" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="F1" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="G1" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="G11" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="PV" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="PP" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="Resin" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="CPK1" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="CPK2" fieldtype="string" WIDTH="10"/>'
    + '<FIELD attrname="CPK3" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Addr" fieldtype="string" WIDTH="100"/>'      //產地
    + '<FIELD attrname="PP_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Resin_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="CPK_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Cl_std" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="Cl" fieldtype="string" WIDTH="10"/>'
    + '<FIELD attrname="Br_std" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Br" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Cl_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="Cl_pass" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="GP_ROHS_pass" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="F" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="G" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="H" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="H_TestMethod" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="I" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="J1" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="J11" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="STS_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="CustPno_visible" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="remark" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="remark2" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="Custabs" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="PrdDate" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="ExpDate" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="Orderno" fieldtype="string" WIDTH="200"/>'   //廠內訂單號
    + '<FIELD attrname="Pno" fieldtype="string" WIDTH="200"/>'       //廠內料號
    + '<FIELD attrname="Pname" fieldtype="string" WIDTH="200"/>'     //廠內品名
    + '<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'     //廠內規格
    + '<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="200"/>' //客戶訂單號
    + '<FIELD attrname="C_Pno" fieldtype="string" WIDTH="200"/>'     //客戶料號
    + '<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'   //客戶規格
    + '<FIELD attrname="PP_Sizes" fieldtype="string" WIDTH="200"/>'  //客戶品名指定的玻布供應商
    + '<FIELD attrname="PPErr" fieldtype="string" WIDTH="200"/>'     //玻布限定錯誤信息
    + '<FIELD attrname="QRcode" fieldtype="string" WIDTH="200"/>'    //二維碼
    + '<FIELD attrname="FstLot" fieldtype="string" WIDTH="20"/>'     //第一個批號
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
    '<FIELD attrname="lot" fieldtype="string" WIDTH="100"/>' + '<FIELD attrname="lot1" fieldtype="string" WIDTH="100"/>' +
    '<FIELD attrname="qty" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="rc" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="rf" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="pg" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="vc" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="sf" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="prddate" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="glasscloth" fieldtype="string" WIDTH="10"/>' + '</FIELDS><PARAMS/></METADATA>' +
    '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

const
  l_CDSDetailXml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="sizes" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="qty" fieldtype="r8"/>' +
    '<FIELD attrname="units" fieldtype="string" WIDTH="4"/>' + '<FIELD attrname="rc" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="resin" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="pp" fieldtype="string" WIDTH="30"/>' +
    '</FIELDS><PARAMS/></METADATA>' + '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

procedure Warn(msg: string; backGroundColor: TColor = clRed);
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

constructor TDLII041_rpt.Create(CDS: TClientDataSet);
begin
  FSourceCDS := CDS;
  FCDS := TClientDataSet.Create(nil);
  FCDSLot := TClientDataSet.Create(nil);
  FCDSDetail := TClientDataSet.Create(nil);
  FCDSDli200 := TClientDataSet.Create(nil);
  InitCDS(FCDS, l_CDSXml);
  InitCDS(FCDSLot, l_CDSLotXml);
  InitCDS(FCDSDetail, l_CDSDetailXml);
  FCheckC_sizes := TCheckC_sizes.Create;
  PtInitImage(@Fm_image);
end;

destructor TDLII041_rpt.Destroy;
begin
  FreeAndNil(FCDS);
  FreeAndNil(FCDSLot);
  FreeAndNil(FCDSDetail);
  FreeAndNil(FCDSDli200);
  FreeAndNil(FCheckC_sizes);
  PtFreeImage(@Fm_image);
  inherited;
end;

procedure TDLII041_rpt.ShowBarMsg(msg: string);
begin
  g_StatusBar.Panels[0].Text := CheckLang(msg);
  Application.ProcessMessages;
end;

//客戶品名欄位取RC公差值
function TDLII041_rpt.GetRC: string;
var
  tmpStr, s, sp: WideString;
  i, pos1, len: Integer;
begin
  tmpStr := FCDS.FieldByName('C_Sizes').AsString;
  len := 2;
  sp := '+/-';
  pos1 := pos(sp, tmpStr);
  if pos1 = 0 then
  begin
    len := 0;
    sp := '±';
    pos1 := pos(sp, tmpStr);
  end;

  s := '';
  if pos1 > 0 then
  begin
    Delete(tmpStr, 1, pos1 + len);
    pos1 := 0; //小數點個數
    for i := 1 to Length(tmpStr) do
    begin
      if Char(tmpStr[i]) in ['0'..'9', '.'] then
      begin
        if tmpStr[i] = '.' then
          pos1 := pos1 + 1;
        if pos1 < 2 then
          s := s + tmpStr[i]
        else
          Break;
      end
      else
        Break;
    end;
  end;

  Result := s;
end;

//玻布限定
function TDLII041_rpt.GetBBXD(SMRec: TSplitMaterialnoPP;custno:string=''): string;
var
  tmpRecno, tmpMaxNum, tmpNum: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  //玻布限定資料
  Result := '';
  Data := null;
  if custno<>'' then
    tmpSQL := 'Select * From Dli530 Where custno=''@'' and Bu=' + Quotedstr(g_UInfo^.BU)
  else
    tmpSQL := 'Select * From Dli530 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno) +
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

        if Pos('/' + SMRec.M3 + '/', '/' + FieldByName('Code3').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Code3').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.M4_7 + '/', '/' + FieldByName('Code4_7').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Code4_7').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.M8_10 + '/', '/' + FieldByName('Code8_10').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('Code8_10').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.M17 + '/', '/' + FieldByName('CodeLast2').AsString + '/') > 0 then
          Inc(tmpNum)
        else if Length(FieldByName('CodeLast2').AsString) > 0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/' + SMRec.M18 + '/', '/' + FieldByName('CodeLast1').AsString + '/') > 0 then
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

//與報表IPQCR010一致
{
拉絲法PG1:AK001 AC347 AC388 AC434 AC093(E) AC091/AC094(N)
布種A=C=L=3=6 E=H F=I G=J B=N O=S Q=U R=V 8=T=P
}
function TDLII041_rpt.SetFGHI_FromDli340(DataSet: TDataSet; SMRec: TSplitMaterialnoPP): Boolean;
var
  tmpStr1, tmpStr2, tmpRC: string;
  tmpBo: Boolean;

  procedure SetFGHI();
  var
    pos1: Integer;
    tmpPG2: WideString;
  begin
    with DataSet do
    begin
      //RC
      if (DataSet.FieldByName('Custno').AsString = '@') and (Pos(SMRec.Custno, 'AC388/AC114/AC365') > 0) then
        FCDS.FieldByName('F').AsString := FieldByName('RC').AsString + '±1.5'
      else if Length(tmpRC) > 0 then
        FCDS.FieldByName('F').AsString := FieldByName('RC').AsString + '±' + tmpRC
      else
        FCDS.FieldByName('F').AsString := FieldByName('RC').AsString + FieldByName('RC_diff').AsString;

      //RF
      FCDS.FieldByName('G').AsString := FieldByName('RF').AsString;

      //PG
      if (UpperCase(FSourceCDS.FieldByName('Custno').AsString) = 'AK001') and (SMRec.M2 = '8') then
        FCDS.FieldByName('H').AsString := '100±20'
          //      else if (UpperCase(FSourceCDS.FieldByName('Custno').AsString) = 'AC204') and (Pos(SMRec.M2, '4/6/F/P') > 0) then
//        FCDS.FieldByName('H').AsString := '125±20'           // 20221102取消 胡美香
      else if (UpperCase(FSourceCDS.FieldByName('Custno').AsString) = 'AC144') and (SMRec.M2 = '4') then
      begin
        tmpPG2 := FieldByName('PG2').AsString;
        pos1 := Pos('±', tmpPG2);
        if pos1 > 0 then
          tmpPG2 := Copy(tmpPG2, 1, pos1);
        FCDS.FieldByName('H').AsString := tmpPG2 + '12';
      end
      else if DataSet.FieldByName('Custno').AsString = '@' then
      begin
        if (Pos(SMRec.Custno, 'AK001/AC347/AC388/AC434') > 0) or ((POS(SMRec.Custno, 'AC093/AM010')>0) and SameText(SMRec.M2,
          'E')) or (SameText(SMRec.Custno, 'AC091/AC094') and SameText(SMRec.M2, 'N')) then
          FCDS.FieldByName('H').AsString := FieldByName('PG1').AsString
        else
          FCDS.FieldByName('H').AsString := FieldByName('PG2').AsString;
      end
      else
        FCDS.FieldByName('H').AsString := FieldByName('PG1').AsString;

      //VC
      FCDS.FieldByName('I').AsString := FieldByName('VC').AsString;
    end;
  end;

begin
  if DataSet.IsEmpty then
  begin
    Result := False;
    Exit;
  end;

  if Pos(SMRec.M3, '36ACL') > 0 then
    tmpStr1 := SMRec.M4_7 + '3/' + SMRec.M4_7 + '6/' + SMRec.M4_7 + 'A/' + SMRec.M4_7 + 'C/' + SMRec.M4_7 + 'L'
  else if Pos(SMRec.M3, 'EH') > 0 then
    tmpStr1 := SMRec.M4_7 + 'E/' + SMRec.M4_7 + 'H'
  else if Pos(SMRec.M3, 'FI') > 0 then
    tmpStr1 := SMRec.M4_7 + 'F/' + SMRec.M4_7 + 'I'
  else if Pos(SMRec.M3, 'GJ') > 0 then
    tmpStr1 := SMRec.M4_7 + 'G/' + SMRec.M4_7 + 'J'
  else if Pos(SMRec.M3, 'BN') > 0 then
    tmpStr1 := SMRec.M4_7 + 'B/' + SMRec.M4_7 + 'N'
  else if Pos(SMRec.M3, 'OS') > 0 then
    tmpStr1 := SMRec.M4_7 + 'O/' + SMRec.M4_7 + 'S'
  else if Pos(SMRec.M3, '8PT') > 0 then
    tmpStr1 := SMRec.M4_7 + '8/' + SMRec.M4_7 + 'P/' + SMRec.M4_7 + 'T'
  else if Pos(SMRec.M3, 'QU') > 0 then
    tmpStr1 := SMRec.M4_7 + 'Q/' + SMRec.M4_7 + 'U'
  else if Pos(SMRec.M3, 'RV') > 0 then
    tmpStr1 := SMRec.M4_7 + 'R/' + SMRec.M4_7 + 'V'
  else
    tmpStr1 := SMRec.M4_7 + SMRec.M3;

  tmpRC := GetRC;

  tmpBo := False;
  with DataSet do
  begin
    First;
    while not Eof do
    begin
      tmpStr2 := RightStr('00000' + FieldByName('Stkname').AsString, 5);
      if Pos(tmpStr2, tmpStr1) > 0 then
      begin
        SetFGHI;
        tmpBo := True;
        Break;
      end;
      Next;
    end;

    if not tmpBo then
    begin
      First;
      while not Eof do
      begin
        tmpStr2 := RightStr('00000' + FieldByName('Stkname').AsString, 4);
        if tmpStr2 = SMRec.M4_7 then
        begin
          SetFGHI;
          tmpBo := True;
          Break;
        end;
        Next;
      end;
    end;
  end;
  Result := tmpBo;
end;

function TDLII041_rpt.GetAddr(SMRec: TSplitMaterialnoPP): string;
var
  tmpRecno, tmpMaxNum, tmpNum: Integer;
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := '';
  Data := null;
  tmpSQL := 'Select Ad,LstCode,Addr From Dli470 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.Custno)
    + ',Custno)>0 and IsCCL=0' + ' Order By Ad,LstCode';
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

        if Pos('/' + SMRec.M18 + '/', '/' + FieldByName('LstCode').AsString + '/') > 0 then
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

procedure TDLII041_rpt.StartPrint(ProcId, Qrcode: string; ds3: TDataset = nil);
type
  TRemarkRec = record
    Custno, Other, Orderno: string;
    Orderitem: integer;
  end;
var
  days, pos1: Integer;
  tmpSQL, tmpPno, tmpUnit, tmpStr, tmpVC, tmpOraDB, tmpDayErr, tmpOneDayErr, tmpOTDayErr, tmpBBXD, tmpFIFOErr, tmpLotErr,
    tmpLot10, tmpN006, tmpFstlot, tmpSF,tmpLots: string;
  tmpDate: TDateTime;
  tmpBo, isPN, isHY, isCY, isAsk, isN006, isN024,flag: Boolean;
  tmpTotQty: Double;
  Data: OleVariant;
  tmpCDS, tmpCDS2, tmpCDS3: TClientDataSet;
  SMRec: TSplitMaterialnoPP;
  ArrPrintData: TArrPrintData;
  tmpRemarkRec: TRemarkRec;
  custInfo:TCustInfo;
begin
  //inherited;

  if (not FSourceCDS.Active) or FSourceCDS.IsEmpty then
  begin
    ShowMsg('無數據可列印!', 48);
    Exit;
  end;

  if FSourceCDS.FieldByName('Coc_err').AsBoolean then
  begin
    ShowMsg('COC異常不可列印,請雙擊查看異常原因!', 48);
    Exit;
  end;

  if Pos('JIANGXI', UpperCase(FSourceCDS.FieldByName('custname').asstring)) > 0 then
  begin
    Warn('請確認江西規範!', clRed);
  end;

  tmpSQL := LeftStr(FSourceCDS.FieldByName('Pno').AsString, 1);
  if Pos(tmpSQL, 'ET') > 0 then
  begin
    ShowMsg('請列印PP!', 48);
    Exit;
  end;

  if Length(FSourceCDS.FieldByName('Pno').AsString) in [12, 20] then
  begin
    tmpUnit := 'PNL';
    isPN := True;
  end
  else
  begin
    tmpUnit := 'ROL';
    isPN := False;
  end;

  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpOraDB := 'ORACLE'
  else
    tmpOraDB := 'ORACLE1';

  if (Pos('AC434', FSourceCDS.FieldByName('remark').AsString) > 0) and (Pos(Copy(FSourceCDS.Fieldbyname('pno').AsString,
    3, 1), '6/8/D/K') > 0) then
  begin
    if (Pos('7628', Qrcode) = 0) then
    begin
      Warn('請確認訂單CAFC', clRed);
    end;
  end;
  CheckCar(FSourceCDS.Fieldbyname('pno').AsString, FSourceCDS.FieldByName('Custname').AsString, FSourceCDS.FieldByName('Orderno').AsString,
    FSourceCDS.Fieldbyname('remark').AsString, FSourceCDS.FieldByName('Orderitem').AsInteger);

  isN006 := SameText(FSourceCDS.FieldByName('Custno').AsString, 'N006');
  isN024 := SameText(FSourceCDS.FieldByName('Custno').AsString, 'N024');

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
  end
  else if FSourceCDS.FieldByName('Custno').AsString = 'N024' then
  begin
    tmpSQL := FSourceCDS.FieldByName('Remark').AsString;
    pos1 := pos('JX-', tmpSQL);
    if pos1 = 1 then
      tmpRemarkRec.Orderno := Copy(tmpSQL, 4, 10);
    tmpSQL := Copy(tmpSQL, 15, 255);
    pos1 := pos('-', tmpSQL);
    if pos1 > 0 then
    begin
      tmpRemarkRec.Orderitem := StrToIntDef(Copy(tmpSQL, 1, pos1 - 1), 0);
      tmpSQL := Copy(tmpSQL, pos1, 255);
      pos1 := pos('-', tmpSQL);
      if pos1 > 0 then
      begin
        tmpRemarkRec.Custno := Copy(tmpSQL, pos1 + 1, 5);
        tmpRemarkRec.Other := Copy(tmpSQL, pos1 + 6, 100);
      end;
    end;
  end;

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
          ':超過兩個批號!', 48);
  end;

  ShowBarMsg('正在核對批號正確性...');
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS3 := TClientDataSet.Create(nil);
  try
    tmpSQL := 'exec dbo.proc_CheckPPLot ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
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
      ShowMsg('下列批號存在錯誤:' + tmpSQL, 48);
      Exit;
    end;

    ShowBarMsg('正在核對二維碼正確性...');
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
        ShowMsg('下列二維碼存在錯誤:' + tmpSQL, 48);
      Exit;
    end;
    tmpCDS.Filtered := False;

    ShowBarMsg('正在核對PP客戶批號是否重複...');
    if not isPN then
    begin
      Data := null;
      tmpSQL := 'exec dbo.proc_DLIR050_PPManfac ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Custno').AsString)
        + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString) + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);
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
        ShowMsg('此客戶批號重複:' + tmpSQL, 48);
        Exit;
      end;
    end;

    ShowBarMsg( '正在查詢玻布供應商...');
    Data := null;
    tmpSQL := 'Select GlassCloth,Supplier From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS3.Data := Data;

    ShowBarMsg('正在查詢出貨日期...');
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
    FCDS.FieldByName('IsPPCOC').AsBoolean := True;
    FCDS.FieldByName('Indate').AsString := tmpCDS.Fields[0].AsString + '/' + RightStr('00' + tmpCDS.Fields[1].AsString,
      2) + '/' + RightStr('00' + tmpCDS.Fields[2].AsString, 2);
    FCDS.FieldByName('Indate1').AsString := CheckLang(tmpCDS.Fields[0].AsString + '年' + tmpCDS.Fields[1].AsString +
      '月' + tmpCDS.Fields[2].AsString + '日');
    FCDS.FieldByName('Fileno').AsString := LBLSno('cocpp');//'Q1-' + FormatDateTime(g_cShortDateYYMMDD, tmpDate) + FSourceCDS.FieldByName('Coc_no').AsString;

    //訂單資料
    {oea10客戶訂單號
     oeb04廠內料號
     oeb11客戶料號
     ta_oeb01經向
     ta_oeb02緯向
     ta_oeb10客戶規格}
    ShowBarMsg('正在查詢訂單資料...');
    Data := null;
    tmpSQL := ' Select X.*,oao06 From (' + ' Select oea04,oea10,oeb01,oeb03,oeb04,oeb11,ta_oeb01,ta_oeb02,ta_oeb10' +
      ' From oea_file Inner Join oeb_file On oea01=oeb01' + ' Where oeb01=' + Quotedstr(FSourceCDS.FieldByName('Orderno').AsString)
      + ' And oeb03=' + IntToStr(FSourceCDS.FieldByName('Orderitem').AsInteger) +
      ' ) X Left Join oao_file Y On oeb01=oao01 and oeb03=oao03';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
      Exit;

    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop訂單資料不存在,請確認!', 48);
      Exit;
    end;

    tmpPno := tmpCDS.FieldByName('oeb04').AsString;
    FCDS.FieldByName('Pno').AsString := tmpPno;
    if FSourceCDS.FieldByName('Pno').AsString <> tmpPno then
      ShowMsg('出貨排程料號[' + FSourceCDS.FieldByName('Pno').AsString + ']'#13#10 + '與TipTop訂單料號[' + tmpPno +
        ']不一致,請確認!', 48);

    if isPN then
    begin
      SMRec.M11_13 := tmpCDS.FieldByName('ta_oeb01').AsString;
      SMRec.M14_16 := tmpCDS.FieldByName('ta_oeb02').AsString;
    end;

    if Length(tmpRemarkRec.Orderno) > 0 then
      FCDS.FieldByName('Orderno').AsString := tmpRemarkRec.Orderno;
    if Length(FCDS.FieldByName('Orderno').AsString) <> 10 then
      FCDS.FieldByName('Orderno').AsString := FSourceCDS.FieldByName('Orderno').AsString;

    tmpSQL := GetOea10(FSourceCDS.FieldByName('Orderno').AsString, FSourceCDS.FieldByName('Remark').AsString, tmpCDS.FieldByName
      ('oea10').AsString);
    SMRec.Custno := FSourceCDS.FieldByName('Custno').AsString;
    if JxRemark(FSourceCDS.FieldByName('Remark').AsString,custInfo) then// SMRec.Custno);
      SMRec.Custno := custInfo.No;  
    FCDS.FieldByName('C_Orderno').AsString := GetC_Orderno(tmpCDS.FieldByName('oea04').AsString, tmpSQL, tmpCDS.FieldByName
      ('oao06').AsString);
    FCDS.FieldByName('C_Pno').AsString := tmpCDS.FieldByName('oeb11').AsString;
    if copy(tmpCDS.FieldByName('oao06').AsString, 1, 3) = 'JX-' then
    begin
      GetJxTA_oeb10(tmpCDS.FieldByName('oao06').AsString, FCDS.FieldByName('C_Sizes'));
      FCDS.FieldByName('C_Pno').AsString := FSourceCDS.FieldByName('Custprono').AsString;
      //20240510
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
        end;    ////20240510-end
        if flag then
          warn('客戶訂單號不匹配,請檢查', clred);
      end;
    end
    else
    begin
      FCDS.FieldByName('C_Sizes').AsString := tmpCDS.FieldByName('ta_oeb10').AsString;
    end;

    ShowBarMsg('正在查詢料號資料...');
    Data := null;
    tmpSQL := 'Select ima01,ima02,ima021 From ima_file' + ' Where ima01=' + Quotedstr(tmpPno) + ' or ima01=' + Quotedstr
      (FCDS.FieldByName('Pno').AsString);
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
      Exit;
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop此筆料號[' + tmpPno + ']品名規格不存在,請確認!', 48);
      Exit;
    end;

    tmpCDS.Locate('ima01', tmpPno, []); //tmpCDS最多2筆,最少1筆,此處不一定找到
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
    end;

    tmpPno := FCDS.FieldByName('Pno').AsString;
    if isPN then
    begin
      if Length(tmpPno) = 20 then
        tmpPno := Copy(tmpPno, 1, 10) + '999999' + Copy(tmpPno, 19, 2)   //20碼新料號
      else
        tmpPno := Copy(tmpPno, 1, 10) + '999999' + Copy(tmpPno, 11, 2);  //后面截取字符中用
    end;
    SMRec.M1 := Copy(tmpPno, 1, 1);
    SMRec.M2 := Copy(tmpPno, 2, 1);
    SMRec.M3 := Copy(tmpPno, 3, 1);
    SMRec.M4_7 := Copy(tmpPno, 4, 4);
    SMRec.M8_10 := Copy(tmpPno, 8, 3);
    if not isPN then
    begin
      SMRec.M11_13 := Copy(tmpPno, 11, 3);
      SMRec.M14_16 := Copy(tmpPno, 14, 3);
    end;
    SMRec.M17 := Copy(tmpPno, 17, 1);
    SMRec.M18 := Copy(tmpPno, 18, 1);
    if (SMRec.M2 = '8') and SameText(SMRec.M18, 'R') then
      SMRec.M2 := 'F';

    SMRec.Custno := FSourceCDS.FieldByName('Custno').AsString;
    if (Length(tmpRemarkRec.Custno) > 0) and (not isN006) then
      SMRec.Custno := tmpRemarkRec.Custno;

    isHY := Pos(SMRec.Custno, 'AC394/AC152/AH036/AC844') > 0;              //惠亞
    isCY := Pos(SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950') > 0;  //超毅
    //聯能150GS 確認PG
    if SameText(SMRec.Custno, 'AC072') and (SMRec.M2 = 'S') then
      ShowMsg('聯能150GS,請確認PG', 48);

    //提示臺灣廠出貨
    if (Pos(SMRec.Custno, 'AC117/ACC19') > 0) and (SMRec.M2 = 'X') then
      ShowMsg('客戶:AC117/ACC19 膠系:X' + #13#10 + '請以臺灣廠出貨!', 48);

    //廠內料號與客戶品名
    tmpSQL := FCheckC_sizes.CheckPP_C_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString, isPN, isAsk);
    if Length(tmpSQL) > 0 then
    begin
      if isAsk then
      begin
        if ShowMsg(tmpSQL, 33) = IdCancel then
          Exit;
      end
      else
      begin
        ShowMsg(tmpSQL, 48);
        Exit;
      end;
    end;

    //客戶料號與廠內料號
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
        if tmpSQL = 'err' then
        begin
          ShowMsg('客戶料號未維護!', 48);
          Exit;
        end
        else if Copy(tmpSQL, 2, Length(tmpSQL) - 2) <> Copy(FCDS.FieldByName('Pno').AsString, 2, Length(FCDS.FieldByName
          ('Pno').AsString) - 2) then
        begin
          ShowMsg('廠內料號不符,要求是：' + #13#10 + FCDS.FieldByName('C_Pno').AsString + '=>' + tmpSQL, 48);
          Exit;
        end;
      end;
    end;

    //簡稱
    if JxRemark(FSourceCDS.fieldbyname('remark').AsString, custInfo) then
    begin
      SMRec.Custno:=custInfo.No;
      FCDS.FieldByName('Custabs').AsString := custInfo.Name;
    end
    else if SameText(SMRec.Custno, 'AC365') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('方正高密')
    else if SameText(SMRec.Custno, 'ACE06') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('九江明陽二廠')
    else if SameText(SMRec.Custno, 'AC114') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('方正多層')
    else if SameText(SMRec.Custno, 'ACD39') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('方正多層-2')
    else if SameText(SMRec.Custno, 'AC388') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('高密HDI')
    else if SameText(SMRec.Custno, 'AC091') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('廣大')
    else if SameText(SMRec.Custno, 'AC094') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('廣元')
    else if SameText(SMRec.Custno, 'AC117') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('廣合')
    else if SameText(SMRec.Custno, 'ACC19') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('廣合-2')
    else if SameText(SMRec.Custno, 'AC434') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('重慶高密')
    else if SameText(SMRec.Custno, 'AC172') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('欣強')
    else if SameText(SMRec.Custno, 'AC145') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('全成信')
    else if SameText(SMRec.Custno, 'ACE67') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('湖北全成信')
    else if SameText(SMRec.Custno, 'AC638') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('珠海元盛')
    else if SameText(SMRec.Custno, 'AC449') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('奈電')
    else if SameText(SMRec.Custno, 'AC625') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('廣州快捷')
    else if SameText(SMRec.Custno, 'AC103') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('快捷電路')
    else if SameText(SMRec.Custno, 'ACB00') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('興森電子')
    else if SameText(SMRec.Custno, 'ACB89') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('江西比亞迪')
    else if SameText(SMRec.Custno, 'AC360') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('勝宏')
    else if SameText(SMRec.Custno, 'AC263') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('富盈')
    else if SameText(SMRec.Custno, 'ACD57') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('崇達電路')
    else if SameText(SMRec.Custno, 'AC588') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('三德冠')
    else if SameText(SMRec.Custno, 'AC737') then
      FCDS.FieldByName('Custabs').AsString := CheckLang('深圳迅捷興')
    else
      FCDS.FieldByName('Custabs').AsString := FSourceCDS.FieldByName('Custshort').AsString;


    //N006備註格式:ACXXX-客戶名稱
    if isN006 then
      if (Length(tmpRemarkRec.Custno) > 0) and (Length(tmpRemarkRec.Other) > 0) then
        FCDS.FieldByName('Custabs').AsString := FCDS.FieldByName('Custabs').AsString + '(' + tmpRemarkRec.Other + ')';
    //簡稱
    //電子簽名
    FCDS.FieldByName('E_seal').AsBoolean := True;

    //N005 超毅po
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

    //纖維結構
    Data := null;
    tmpSQL := 'Select Top 1 * From Dli330 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Fiber=' + Quotedstr(SMRec.M4_7);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
      begin
        FCDS.FieldByName('D1').AsString := tmpCDS.FieldByName('Warp').AsString + '±2';
        FCDS.FieldByName('D11').AsString := tmpCDS.FieldByName('Warp').AsString;
        FCDS.FieldByName('D2').AsString := tmpCDS.FieldByName('Filling').AsString + '±2';
        FCDS.FieldByName('D21').AsString := tmpCDS.FieldByName('Filling').AsString;
      end;
    end;
    //纖維結構
    //品名
    if SameText(SMRec.M2, 'H') and (Pos(SMRec.Custno, 'AC052/AC051') > 0) then
      FCDS.FieldByName('A').AsString := FCDS.FieldByName('C_Sizes').AsString
    else if isHY or isCY or (Pos(SMRec.Custno, 'AC093/AM010/AC151/AC143/AC097/AC707/AC715/AC715') > 0) then
      FCDS.FieldByName('A').AsString := FCDS.FieldByName('C_Sizes').AsString
    else if SameText(SMRec.Custno, 'AC111') and (Pos('90003', FCDS.FieldByName('C_Sizes').AsString) > 0) then
      FCDS.FieldByName('A').AsString := FCDS.FieldByName('Pname').AsString + ' ' + FloatToStr(StrToInt(SMRec.M8_10) / 10)
        + '% 90003'
    else if SameText(SMRec.Custno, 'AC111') and (Pos('90001', FCDS.FieldByName('C_Sizes').AsString) > 0) then
      FCDS.FieldByName('A').AsString := FCDS.FieldByName('Pname').AsString + ' ' + FloatToStr(StrToInt(SMRec.M8_10) / 10)
        + '% 90001'
    else
      FCDS.FieldByName('A').AsString := FCDS.FieldByName('Pname').AsString + ' ' + FloatToStr(StrToInt(SMRec.M8_10) / 10)
        + '%';
    //品名
    //尺寸
    if isPN then
    begin
      if SameText(SMRec.Custno, 'EI001') then
        FCDS.FieldByName('B').AsString := SMRec.M11_13 + '"G*' + SMRec.M14_16 + '"'
      else
        FCDS.FieldByName('B').AsString := SMRec.M11_13 + '"*' + SMRec.M14_16 + '"';
      FCDS.FieldByName('E1_unit').AsString := 'mm';
      FCDS.FieldByName('E2_unit').AsString := 'mm';
      if SMRec.Custno = 'AC687' then
      begin
        FCDS.FieldByName('E1').AsString := '+3/-0';
        FCDS.FieldByName('E2').AsString := '+3/-0';
      end
      else
      begin
        FCDS.FieldByName('E1').AsString := '+1/-0';
        FCDS.FieldByName('E2').AsString := '+1/-0';
      end;
    end
    else
    begin
      FCDS.FieldByName('B').AsString := FloatToStr(StrToInt(SMRec.M14_16) / 10) + '"*' + SMRec.M11_13 + 'M';
      FCDS.FieldByName('E1_unit').AsString := 'm';
      FCDS.FieldByName('E1').AsString := '±1';
      FCDS.FieldByName('E2_unit').AsString := 'mm';
      if (SMRec.M14_16 <> '495') and (SMRec.M14_16 <> '496') then
        FCDS.FieldByName('E2').AsString := '+4/-4'
      else
        FCDS.FieldByName('E2').AsString := '+8/-0';

      FCDS.FieldByName('E11').AsString := SMRec.M11_13;          //*
    end;

    Data := null;
    tmpSQL := 'Select * From Dli170 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (Sizes=' + Quotedstr(SMRec.M11_13) +
      ' OR Sizes=' + Quotedstr(SMRec.M14_16) + ')';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if isPN and tmpCDS.Locate('Sizes', SMRec.M11_13, []) then  //*
        FCDS.FieldByName('E11').AsString := tmpCDS.FieldByName('fValue').AsString;
      if tmpCDS.Locate('Sizes', SMRec.M14_16, []) then
        FCDS.FieldByName('E21').AsString := tmpCDS.FieldByName('fValue').AsString;
    end;

    if isPN then
    begin
      FCDS.FieldByName('E1').AsString := FCDS.FieldByName('E11').AsString + FCDS.FieldByName('E1').AsString;
      FCDS.FieldByName('E2').AsString := FCDS.FieldByName('E21').AsString + FCDS.FieldByName('E2').AsString;
    end
    else
    begin
      FCDS.FieldByName('E1').AsString := FCDS.FieldByName('E11').AsString + FCDS.FieldByName('E1').AsString;
      FCDS.FieldByName('E2').AsString := FCDS.FieldByName('E21').AsString + FCDS.FieldByName('E2').AsString;
    end;

    //檢查客戶品名:小片尺寸
    if isPN then
      if not (SameText(SMRec.Custno, 'AC101') and (Pos(FCDS.FieldByName('Pno').AsString, 'MSA2116570XX,MSA7628480XX') >
        0)) then
      begin
        tmpSQL := FCheckC_sizes.CheckPP_PN_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString, FCDS.FieldByName('E11').AsString,
          FCDS.FieldByName('E21').AsString);
        if Length(tmpSQL) > 0 then
        begin
          ShowMsg(tmpSQL, 48);
          Exit;
        end;
      end;

    //比例流量
    tmpSF := '';
    if isHY or SameText(SMRec.Custno, 'AC109') then
    begin
      if not SameText(SMRec.Custno, 'AC109') then
        FCDS.FieldByName('F1').AsString := 'NA'
      else
      begin
        Data := null;
        tmpSQL := 'Select Top 1 fValue,dValue,tValue From Dli280' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
          ' And Adhesive=' + Quotedstr(SMRec.M2) + ' And Fiber=' + Quotedstr(SMRec.M4_7) + ' And RC=' + Quotedstr(FloatToStr
          (StrToInt(SMRec.M8_10) / 10));
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data := Data;
          if not tmpCDS.IsEmpty then
          begin
            if Pos('.', tmpCDS.Fields[0].AsString) = 0 then
              FCDS.FieldByName('F1').AsString := tmpCDS.Fields[0].AsString + '.0±' + tmpCDS.Fields[1].AsString
            else
              FCDS.FieldByName('F1').AsString := tmpCDS.Fields[0].AsString + '±' + tmpCDS.Fields[1].AsString;
            tmpSF := tmpCDS.Fields[2].AsString;
          end;
        end;
      end;
    end;
    //AC109華通比例流量
    //968、958G、988G、BM(859GTA、180GN)布基重
    if Pos(SMRec.M2, 'XYZBM') > 0 then
    begin
      Data := null;
      tmpSQL := 'Select Top 1 bw From Dli450 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Code2=' + Quotedstr(SMRec.M2) +
        ' And Fiber=' + Quotedstr(SMRec.M4_7);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        if not tmpCDS.IsEmpty then
        begin
          FCDS.FieldByName('G1').AsString := tmpCDS.Fields[0].AsString;
          FCDS.FieldByName('G11').AsString := tmpCDS.Fields[0].AsString;
        end;
      end;
    end
    else
    begin
      //AC084、AC148、AC347布基重
      if Pos(SMRec.Custno, 'AC084/AC148/AC347/N023/AC360/AC950/AC075/AC310/AC311/AC405/AC109/AC172/AC136/ACA27') > 0 then
      begin
        Data := null;
        tmpSQL := 'Select Top 1 fValue,dValue,n023 From Dli370' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Fiber='
          + Quotedstr(SMRec.M4_7);
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data := Data;
          if not tmpCDS.IsEmpty then
          begin
            if Pos(SMRec.Custno, 'N023/AC360/AC109/AC136/ACA27') > 0 then
              //N023只要測試值
            begin
              FCDS.FieldByName('G1').AsString := tmpCDS.Fields[2].AsString;
              FCDS.FieldByName('G11').AsString := tmpCDS.Fields[2].AsString;
            end
            else
            begin
              FCDS.FieldByName('G1').AsString := tmpCDS.Fields[0].AsString + '±' + tmpCDS.Fields[1].AsString;
              FCDS.FieldByName('G11').AsString := tmpCDS.Fields[0].AsString;
            end;
          end;
        end;
      end;
      //AC084、AC148、AC347布基重
      //AC111布基重
      if Pos(SMRec.Custno, 'AC111/AC072') > 0 then
      begin
        Data := null;
        tmpSQL := 'Select Top 1 bw From Dli440 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Fiber=' + Quotedstr(SMRec.M4_7);
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data := Data;
          if not tmpCDS.IsEmpty then
          begin
            FCDS.FieldByName('G1').AsString := tmpCDS.Fields[0].AsString;
            FCDS.FieldByName('G11').AsString := tmpCDS.Fields[0].AsString;
          end;
        end;
      end;
      //AC111布基重
    end;

    //PP ROHS 2.0項目設定
    if pos(SMRec.Custno, 'AC950/AC075/AC310/AC311/AC405') > 0 then
    begin
      Data := null;
      tmpSQL := Copy(tmpPno, 3, 4);
      tmpSQL := 'Select * From Dli492 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2);
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

    //PP規范
    //N006:實際客戶->N006->@
    tmpN006 := '';
    if isN006 and (Length(tmpRemarkRec.Custno) > 0) then
    begin
      tmpN006 := SMRec.Custno;
      SMRec.Custno := tmpRemarkRec.Custno;
      tmpSQL := ' OR Custno=''N006''';
    end
    else if isN024 and (Length(tmpRemarkRec.Custno) > 0) then
    begin
      tmpSQL := '';
      SMRec.Custno := tmpRemarkRec.Custno;
    end
    else
      tmpSQL := '';
    Data := null;            
    {(*}
    tmpSQL := 'Select *,Case When Len(IsNull(LastCode,''''))>0 Then LastCode Else ''@'' End LastCode1 From Dli340' +
              ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (Custno=''@'' OR Custno=' + Quotedstr(SMRec.Custno) + tmpSQL
                + ')' +
              ' And Adhesive=' + Quotedstr(SMRec.M2) + ' And RC=' + Quotedstr(FloatToStr(StrToInt(SMRec.M8_10) / 10));
    if (Pos('JIANGXI',UpperCase(FSourceCDS.FieldByName('custname').asstring))>0) and (Pos(FSourceCDS.FieldByName(
      'custno').asstring,'AC075/AC405/AC311/AC310/AC950')>0) then
      tmpSQL:=tmpSql+' and Remark=''JIANGXI''';
    {*)}
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        Filtered := False;
        Filter := 'Custno=' + Quotedstr(SMRec.Custno) + ' And LastCode1 like ' + Quotedstr('%' + SMRec.M18 + '%');
        Filtered := True;
        if not SetFGHI_FromDli340(tmpCDS, SMRec) then
        begin
          Filtered := False;
          Filter := 'Custno=' + Quotedstr(SMRec.Custno) + ' And LastCode1=''@''';
          Filtered := True;

          if not SetFGHI_FromDli340(tmpCDS, SMRec) then
          begin
            tmpBo := False;
            if isN006 then
            begin
              Filtered := False;
              Filter := 'Custno=''N006'' And LastCode1 like ' + Quotedstr('%' + SMRec.M18 + '%');
              Filtered := True;
              if not SetFGHI_FromDli340(tmpCDS, SMRec) then
              begin
                Filtered := False;
                Filter := 'Custno=''N006'' And LastCode1=''@''';
                Filtered := True;
                if not SetFGHI_FromDli340(tmpCDS, SMRec) then
                  tmpBo := True;
              end;
            end
            else
              tmpBo := True;

            if tmpBo then
            begin
              Filtered := False;
              Filter := 'Custno=''@'' And LastCode1 like ' + Quotedstr('%' + SMRec.M18 + '%');
              Filtered := True;
              if not SetFGHI_FromDli340(tmpCDS, SMRec) then
              begin
                Filtered := False;
                Filter := 'Custno=''@'' And LastCode1=''@''';
                Filtered := True;
                SetFGHI_FromDli340(tmpCDS, SMRec);
              end;
            end;
          end;
        end;
        Filtered := False;
      end;
    end;
    if Length(tmpN006) > 0 then
      SMRec.Custno := tmpN006;
    if isCY and SameText(SMRec.M2, 'X') then
    begin
      FCDS.FieldByName('G').AsString := 'NA';
      FCDS.FieldByName('H').AsString := 'NA';
    end;
    //PP規范
    //VC測試值
//    if (SMRec.M2='5') and

      //       (Pos(SMRec.Custno,'AC434/ACD57/AC072/ACC63/AC820/ACC19/AC111/AC625/AC101/ACA97/AC117/AC051/AC084/AC121/AC089/AC145/ACD39/ACD04/AC100/AC360/N006')=0) then
//      tmpVC :=''
//    else
    begin
      tmpVC := '0.00';
      Data := null;
      tmpSQL := 'Select Top 1 [Value] From DLI300 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Adhesive=' + Quotedstr(SMRec.M2)
        + ' And (Case When Len(Fiber)=3 Then ''0''+Fiber Else Fiber End)=' + Quotedstr(SMRec.M4_7) + ' And RC=' +
        Quotedstr(SMRec.M8_10);
      if QueryOneCR(tmpSQL, Data) then
      begin
        if not VarIsNull(Data) then
        begin
          tmpVC := VarToStr(Data);
          if Pos('.', tmpVC) = 0 then
            tmpVC := tmpVC + '.00';
          if Length(tmpVC) = 3 then
            tmpVC := tmpVC + '0';
        end;
      end;
    end;
    //VC測試值
    //經緯紗變形 1.30~1.40
    Randomize;
    FCDS.FieldByName('J1').AsString := '≦5%';
    FCDS.FieldByName('J11').AsString := '1.' + IntToStr(RandomRange(30, 40));
    //經緯紗變形
    //GT測試條件
    //IPC-TM-650
    //2.3.18
    //171±0.5℃ ***H_TestMethod=171或200
    if SameText(SMRec.M2, 'E') then
      FCDS.FieldByName('H_TestMethod').AsString := '200'
    else
      FCDS.FieldByName('H_TestMethod').AsString := '171';
    //GT測試條件
    //氯溴
    Randomize;
    FCDS.FieldByName('Cl_std').AsString := '<900';
    FCDS.FieldByName('Br_std').AsString := '<900';
    FCDS.FieldByName('Cl').AsString := IntToStr(RandomRange(200, 400));
    FCDS.FieldByName('Br').AsString := IntToStr(RandomRange(50, 100));
    if Pos(SMRec.M2, '1/2/9/B/H/J/L/K/M/O/P/U/V/W/S/Y/Z/5/T') > 0 then
      FCDS.FieldByName('Cl_visible').AsString := '1'
    else
      FCDS.FieldByName('Cl_visible').AsString := '0';
    //氯溴
    //STS
    if ((POS(SMRec.Custno, 'AC093/AM010')>0) and (Pos(SMRec.M2, '4/8') > 0)) or (isHY and SameText(SMRec.M2, '6')) then
      FCDS.FieldByName('STS_visible').AsString := '1'
    else
      FCDS.FieldByName('STS_visible').AsString := '0';
    //STS
    //CustPno_visible
    tmpSQL := 'AC121/ACG02/AC820/ACA97/AC109';
    if (Pos(SMRec.Custno, tmpSQL) > 0) and SameText(SMRec.M2, 'X') then
      FCDS.FieldByName('CustPno_visible').AsString := '1'
    else
    begin
      tmpSQL :=
        'AC093/AM010/ACD67/AC148/AC082/AC135/AC109/AC347/AC734/AC121/ACG02/AC076/AC360/N006/AC133/ACA28/ACE06/AC625/ACB00/ACD57/AC820/ACA97';
      if isCY or (Pos(SMRec.Custno, tmpSQL) > 0) then
        FCDS.FieldByName('CustPno_visible').AsString := '1'
      else
        FCDS.FieldByName('CustPno_visible').AsString := '0';
    end;
    //CustPno_visible
    //樹脂
    FCDS.FieldByName('Resin').AsString := GetResin(SMRec.Custno, SMRec.M2, SMRec.M18, False);
    if Length(FCDS.FieldByName('Resin').AsString) > 0 then
      FCDS.FieldByName('Resin_visible').AsString := '1'
    else
      FCDS.FieldByName('Resin_visible').AsString := '0';

    //玻布
    if isHY or isCY or (Pos(SMRec.M2, 'XYZ') > 0) or (Pos(SMRec.Custno,
      'AC117/ACC19/AC093/AM010/AC388/N013/N006/AC148/AC347/AC096/AC174/AC082/N023/N024/AC365/AC434/AC114/AC388/AC436/AC769/ACC39')
      > 0) or (SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '6/F/4/8/A/U') > 0)) or (SameText(SMRec.Custno,
      'AC109') and (Pos(SMRec.M2, '5/6/F/J/H/U') > 0)) or (SameText(SMRec.Custno, 'AC109') and (Pos(SMRec.M2 + SMRec.M18,
      'U3,UZ,Uz,UI,Ui') > 0)) or (SameText(SMRec.Custno, 'AC178') and (Pos(SMRec.M4_7,
      '1506/7628/1086/1037/0106/1080/3313/2116') > 0)) or (SameText(SMRec.Custno, 'AC084') and SameText(SMRec.M2, 'Q')
      and (Pos('IBM', FCDS.FieldByName('C_Sizes').AsString) > 0)) then
      FCDS.FieldByName('PP_visible').AsString := '1'
    else if Pos(SMRec.Custno,'AC051/ACE22/AC136/ACA27')>0 then
      FCDS.FieldByName('PP_visible').AsString := '1'
    else if (POS(SMRec.Custno, 'ACD04')>0) and (date>=EncodeDate(2023, 12, 18)) then
      FCDS.FieldByName('PP_visible').AsString := '1'
    else
      FCDS.FieldByName('PP_visible').AsString := '0';

    //CPK
    FCDS.FieldByName('CPK1').AsString := GetCPK(SMRec.Custno, False);
    FCDS.FieldByName('CPK2').AsString := GetCPK(SMRec.Custno, False);
    FCDS.FieldByName('CPK3').AsString := GetCPK(SMRec.Custno, False);
    if Length(FCDS.FieldByName('CPK1').AsString) > 0 then
      FCDS.FieldByName('CPK_visible').AsString := '1'
    else
      FCDS.FieldByName('CPK_visible').AsString := '0';
       
    //產地
    FCDS.FieldByName('Addr').AsString := GetAddr(SMRec);
    if Length(FCDS.FieldByName('Addr').AsString) > 0 then
      FCDS.FieldByName('Addr').AsString := '產地:' + FCDS.FieldByName('Addr').AsString;
       
    //備註spec
    Data := null;
    tmpSQL := 'Select Top 1 Remark From Dli240' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (charindex(' + Quotedstr
      (SMRec.Custno) + ',Custno)>0 or Custno=''@'')' + ' And charindex(' + Quotedstr(SMRec.M2) + ',Adhesive)>0' +
      ' And (LstCode=' + Quotedstr(SMRec.M18) + ' or LstCode=''@'')' + ' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('Remark').AsString := VarToStr(Data);
    end;
    //備註spec
    //備註typeS
    FCDS.FieldByName('Remark2').AsString := 'typeH.';
    Data := null;
    tmpSQL := 'Select Top 1 Remark From Dli241' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And charindex(' + Quotedstr(SMRec.M17)
      + ',LstCode2)>0' + ' Order By LstCode2 Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('Remark2').AsString := VarToStr(Data);
    end;
    //備註typeS
    //COC檢驗員
    Data := null;
    tmpSQL := 'Select Top 1 UserName From Sys_PDAUser' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And UserId=' +
      Quotedstr(FSourceCDS.FieldByName('Coc_user').AsString) + ' Order By Not_use,UserId';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        FCDS.FieldByName('TestName').AsString := VarToStr(Data);
    end;
    //COC檢驗員
    //有效期
    days := -1;
    Data := null;
    tmpSQL := 'Select Top 1 IsNull(PPday,0) PPday From DLI510' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) +
      ' And (charindex(' + Quotedstr(SMRec.Custno) + ',Custno)>0 or Custno=''@'')' + ' And charindex(' + Quotedstr(SMRec.M2)
      + ',Adhesive)>0' + ' And (LstCode=' + Quotedstr(SMRec.M18) + ' or LstCode=''@'')' +
      ' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
        days := StrToInt(VarToStr(Data));
    end;
    //有效期
    //coc lot
    tmpLots:='';
    tmpPno := '';                //tmpPno暫存批號中最早生產的日期
    tmpDayErr := '';             //超出有效期批號
    tmpOneDayErr := '';          //剩余1天有效期批號
    tmpFstlot := '';
    tmpBo := False;              //玻布限定不符
    tmpBBXD := GetBBXD(SMRec);
    if tmpBBXD='' then
      tmpBBXD := GetBBXD(SMRec,'@');
    tmpTotQty := 0;
    Data := null;
    tmpSQL := 'Select manfac,rc,rf,pg,sum(qty) qty,min(sno) sno1 From Dli040' + ' Where Dno=' + Quotedstr(FSourceCDS.FieldByName
      ('Dno').AsString) + ' And Ditem=' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ' And Bu=' + Quotedstr(g_UInfo
      ^.BU) + ' And Isnull(qty,0)<>0 and Len(Isnull(manfac,''''))>4' + ' Group By manfac,rc,rf,pg Order By sno1';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpSQL := '';
      tmpCDS.Data := Data;
      //總數量、批號
      while not tmpCDS.Eof do
      begin
        tmpStr := tmpCDS.FieldByName('manfac').AsString;
        tmpSQL := tmpSQL + ' OR tc_sia02 Like ' + Quotedstr(Copy(tmpStr, 1, Length(tmpStr) - 1) + '%');
        tmpTotQty := tmpTotQty + tmpCDS.FieldByName('qty').AsFloat;
        tmpCDS.Next;
      end;

      if Length(tmpSQL) <> 0 then
      begin
        tmpStr := 'ORACLE';
        if Pos(SMRec.M18, 'G3') > 0 then
          tmpStr := 'ORACLE1';
        ShowBarMsg('正在查詢特性值...');
        Data := null;
        tmpSQL := 'Select tc_sia02,tc_sia201,tc_sia40 From tc_sia_file Where 1=2 ' + tmpSQL;
        if QueryBySQL(tmpSQL, Data, tmpStr) then
        begin
          tmpCDS2 := TClientDataSet.Create(nil);
          try
            tmpCDS2.Data := Data;
            tmpCDS.First;
            while not tmpCDS.Eof do
            begin
              if Length(tmpFstlot) = 0 then
                tmpFstlot := tmpCDS.Fields[0].AsString;

              tmpStr := tmpCDS.Fields[0].AsString;
              tmpLots:= tmpLots+','+tmpStr;
              tmpSQL := Copy(tmpStr, 2, 4);
              if (tmpPno = '') or (tmpPno < tmpSQL) then
                tmpPno := tmpSQL;

              FCDSLot.Append;

              //數量
              if isPN then
                FCDSLot.FieldByName('qty').AsString := FloatToStr(tmpCDS.Fields[4].AsFloat)
              else
                FCDSLot.FieldByName('qty').AsString := FloatToStr(RoundTo(tmpCDS.Fields[4].AsFloat / StrToInt(SMRec.M11_13),
                  -3));

              //批號+數量(單位=ROL&數量<1或者單位=PNL,則批號后面顯示數量)
              if isPN and (tmpCDS.RecordCount <> 1) then
                FCDSLot.FieldByName('lot').AsString := tmpStr + '(' + FCDSLot.FieldByName('qty').AsString + tmpUnit +
                  ')'
              else if (not isPN) and (tmpCDS.RecordCount <> 1) and (tmpCDS.Fields[4].AsFloat / StrToInt(SMRec.M11_13) <
                1) then
                FCDSLot.FieldByName('lot').AsString := tmpStr + '(' + FCDSLot.FieldByName('qty').AsString + tmpUnit +
                  ')'
              else
                FCDSLot.FieldByName('lot').AsString := tmpStr;

              //批號
              if SMRec.Custno='AC198' then
              begin
                if LeftStr(tmpLots, 1) = ',' then
                  Delete(tmpLots, 1, 1);
                FCDSLot.FieldByName('lot1').AsString := tmpLots
              end
              else
                FCDSLot.FieldByName('lot1').AsString := tmpStr;

              //數量+單位
              FCDSLot.FieldByName('qty').AsString := FCDSLot.FieldByName('qty').AsString + tmpUnit;

              //生產日期
              FCDSLot.FieldByName('prddate').AsString := DateToStr(GetLotDate(tmpSQL, Self.FSourceCDS.FieldByName('Indate').AsDateTime));

              //有效期管制
              if (days > 0) and (Pos(tmpStr, tmpDayErr) = 0) and (DaysBetween(StrToDate(FCDSLot.FieldByName('prddate').AsString),
                Date) >= days) then
                tmpDayErr := tmpDayErr + tmpStr + #13#10;
              if (days > 0) and (Pos(tmpStr, tmpOneDayErr) = 0) and (DaysBetween(StrToDate(FCDSLot.FieldByName('prddate').AsString),
                Date) = days - 1) then
                tmpOneDayErr := tmpOneDayErr + tmpStr + #13#10;

              //超前批號
              if StrToDate(FCDSLot.FieldByName('prddate').AsString) > Date then
                tmpOTDayErr := tmpOTDayErr + tmpStr + #13#10;

              //玻布
              tmpLot10 := Copy(tmpStr, 10, 1);
              if POS(SMRec.Custno, 'AC109')>0 then
              begin
                if SameText(SMRec.M2, 'H') or SameText(SMRec.M2, '5') or (Pos(SMRec.M2 + SMRec.M18, 'U3,UZ,Uz') > 0)
                  then
                begin
                  if tmpCDS3.Locate('GlassCloth', SMRec.Custno + tmpLot10, [loCaseInsensitive]) then
                    FCDSLot.FieldByName('GlassCloth').AsString := tmpCDS3.FieldByName('Supplier').AsString;
                end
                else if tmpCDS3.Locate('GlassCloth', tmpLot10, [loCaseInsensitive]) then
                  FCDSLot.FieldByName('GlassCloth').AsString := tmpCDS3.FieldByName('Supplier').AsString;
              end
              else if (POS(SMRec.Custno, 'ACD04')>0) and (date>=EncodeDate(2023, 12, 18)) then
              begin
                if tmpCDS3.Locate('GlassCloth', SMRec.Custno + tmpLot10, [loCaseInsensitive]) then
                  FCDSLot.FieldByName('GlassCloth').AsString := tmpCDS3.FieldByName('Supplier').AsString;
              end
              else if tmpCDS3.Locate('GlassCloth', tmpLot10, [loCaseInsensitive]) then
                FCDSLot.FieldByName('GlassCloth').AsString := tmpCDS3.FieldByName('Supplier').AsString;

              //玻布限定
              if (Length(tmpBBXD) > 0) and (Pos(Copy(tmpStr, 10, 1), tmpBBXD) = 0) then
                tmpBo := True;

              //rc
              FCDSLot.FieldByName('rc').AsString := tmpCDS.Fields[1].AsString;
              if Pos('.', FCDSLot.FieldByName('rc').AsString) = 0 then
                FCDSLot.FieldByName('rc').AsString := FCDSLot.FieldByName('rc').AsString + '.0';

              //rf
              FCDSLot.FieldByName('rf').AsString := tmpCDS.Fields[2].AsString;
              if Pos('.', FCDSLot.FieldByName('rf').AsString) = 0 then
                FCDSLot.FieldByName('rf').AsString := FCDSLot.FieldByName('rf').AsString + '.0';

              //pg
              if isCY and SameText(SMRec.M2, 'X') then
              begin
                FCDSLot.FieldByName('rf').AsString := 'NA';
                FCDSLot.FieldByName('pg').AsString := 'NA';
              end
              else
                FCDSLot.FieldByName('pg').AsString := tmpCDS.Fields[3].AsString;

              //sf
              if SameText(SMRec.Custno, 'AC109') then
              begin
                if tmpCDS2.Locate('tc_sia02', Copy(tmpStr, 1, Length(tmpStr) - 1), [loPartialKey]) then
                  FCDSLot.FieldByName('sf').AsString := tmpCDS2.FieldByName('tc_sia40').AsString;
                if Length(FCDSLot.FieldByName('sf').AsString) = 0 then
                  FCDSLot.FieldByName('sf').AsString := tmpSF;

                if Length(FCDSLot.FieldByName('sf').AsString) > 0 then
                  if Pos('.', FCDSLot.FieldByName('sf').AsString) = 0 then
                    FCDSLot.FieldByName('sf').AsString := FCDSLot.FieldByName('sf').AsString + '.0';
              end
              else
                FCDSLot.FieldByName('sf').AsString := 'NA';

              //vc
              FCDSLot.FieldByName('vc').AsString := tmpVC;
              FCDSLot.Post;

              //明細
              if isHY or (POS(SMRec.Custno, 'AC093/AM010')>0) then
                AddCDSDetail(tmpCDS.Fields[0].AsString, tmpUnit, FCDSLot.FieldByName('rc').AsString, tmpCDS.Fields[4].AsFloat,
                  SMRec);

              tmpCDS.Next;
            end;

          finally
            FreeAndNil(tmpCDS2);
          end;
        end;
      end;
    end;
    //coc lot

    if Length(tmpDayErr) > 0 then
    begin
      ShowMsg('下列批號超過設定有效期' + IntToStr(days) + ':' + #13#10 + tmpDayErr, 48);
      if not Sametext(g_uinfo^.UserId,'ID150515') then
        Exit;
    end;

    if Length(tmpOneDayErr) > 0 then
    begin
      if ShowMsg('下列批號剩余1天有效期' + IntToStr(days) + ':' + #13#10 + tmpOneDayErr, 33) = IdCancel then
        Exit;
    end;

    if Length(tmpOTDayErr) > 0 then
    begin
      ShowMsg('下列批號超前:' + #13#10 + tmpOTDayErr, 48);
      Exit;
    end;

    //客戶品名指定的玻布供應商
    with tmpCDS3 do
    begin
      First;
      while not Eof do
      begin
        if (Length(FieldByName('GlassCloth').AsString) > 4) and (Pos(FieldByName('GlassCloth').AsString, FCDS.FieldByName
          ('C_Sizes').AsString) > 0) then
        begin
          FCDS.Edit;
          FCDS.FieldByName('PP_Sizes').AsString := FieldByName('Supplier').AsString;
          FCDS.Post;
          Break;
        end;
        Next;
      end;
    end;

    //AC111備註(FQ),固定:富喬
    if SameText(SMRec.Custno, 'AC111') and (Pos('(FQ)', FCDS.FieldByName('C_Sizes').AsString) > 0) then
    begin
      FCDS.Edit;
      FCDS.FieldByName('PP_Sizes').AsString := CheckLang('富喬');
      FCDS.Post;
    end;

    //合并所有玻布供應商
    tmpStr := '';
    if (FCDS.FieldByName('PP_visible').AsString = '1') and (not SameText(SMRec.M2, 'X')) then //968玻布空白,手動輸入
    begin
      if SameText(SMRec.Custno, 'AC109') and (Pos(SMRec.M2, '6/F/J') > 0) then  //華通
        tmpStr := CheckLang('上海宏和');

      if Length(tmpStr) = 0 then
        if SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '6/F') > 0) and (Pos(SMRec.M3, '6/D') > 0) then
        begin
          pos1 := Pos('(', FCDS.FieldByName('C_Sizes').AsString);
          if (pos1 > 0) and (RightStr(FCDS.FieldByName('C_Sizes').AsString, 1) = ')') then
          begin
            tmpStr := Copy(FCDS.FieldByName('C_Sizes').AsString, pos1 + 1, 255);
            tmpStr := Copy(tmpStr, 1, Length(tmpStr) - 1);
            if SameText(tmpStr, 'AE') or SameText(tmpStr, 'JX') then  //(AE)表示汽車板標識,(JX)表示江西廠
              tmpStr := ''
          end;
        end;

      if Length(tmpStr) = 0 then
      begin
        with FCDSLot do
        begin
          First;
          while not Eof do
          begin
            if Pos(FieldByName('GlassCloth').AsString, tmpStr) = 0 then
            begin
              if Length(tmpStr) > 0 then
                tmpStr := tmpStr + ',';
              tmpStr := tmpStr + FieldByName('GlassCloth').AsString;
            end;
            Next;
          end;
        end;
      end;
    end;

    //玻布、數量、生產日期、到期日、第一個批號
    if Length(tmpPno) > 0 then
      tmpDate := GetLotDate(tmpPno, FSourceCDS.FieldByName('Indate').AsDateTime)
    else
      tmpDate := EncodeDate(1955, 1, 1);
    with FCDS do
    begin
      Edit;
      if tmpBo then
        FieldByName('PPErr').AsString := tmpBBXD;
      FieldByName('PP').AsString := tmpStr;
      if isPN then
        FieldByName('C').AsString := FloatToStr(tmpTotQty) + tmpUnit
      else
        FieldByName('C').AsString := FloatToStr(RoundTo(tmpTotQty / StrToFloat(SMRec.M11_13), -3)) + tmpUnit;

      FieldByName('PrdDate').AsString := StringReplace(FormatDateTime(g_cShortDate1, tmpDate), '-', '/', [rfReplaceAll]);
      FieldByName('ExpDate').AsString := StringReplace(FormatDateTime(g_cShortDate1, IncYear(tmpDate, 2)), '-', '/', [rfReplaceAll]);
      FieldByName('FstLot').AsString := tmpFstlot;
      Post;
    end;

    //批號先進選出
    tmpFIFOErr := '';
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckLotFIFO ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ',' + Quotedstr(FSourceCDS.FieldByName('Custno').AsString)
      + ',0';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data := Data;
      if (not tmpCDS.IsEmpty) and (Length(tmpCDS.Fields[1].AsString) > 0) then
        tmpFIFOErr := '1.最新出貨批號是：' + tmpCDS.Fields[0].AsString + #13#10 + '2.下列批號未按先進先出' + #13#10 +
          StringReplace(tmpCDS.Fields[1].AsString, ',', #13#10, [rfReplaceAll]);
    end;
    //批號先進選出
    //檢查資材批號
    tmpLotErr := '';
    Data := null;
    tmpSQL := 'exec dbo.proc_CheckZClot ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
      + ',' + IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger) + ',' + Quotedstr(FSourceCDS.FieldByName('Custno').AsString)
      + ',0';
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
          tmpLotErr := '資材批號' + #13#10;
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
          tmpLotErr := tmpLotErr + 'COC批號' + #13#10;
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
    //檢查資材批號
    //中山惠亞,廣州添利:隱藏部分信息
    if isHY or (POS(SMRec.Custno, 'AC093/AM010')>0) then
    begin
      FCDS.Edit;
      Data := null;
      tmpSQL := 'Select GlassCloth From Dli200' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Len(GlassCloth)>4';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data := Data;
        while not tmpCDS.Eof do
        begin
          FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, tmpCDS.Fields[0].AsString, '',
            [rfReplaceAll]);
          tmpCDS.Next;
        end;
      end;
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, ' -CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, '-CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, ' -CAF', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, '-CAF', '', [rfReplaceAll]);

      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, ' CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, 'CAFC', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, ' CAF', '', [rfReplaceAll]);
      FCDS.FieldByName('A').AsString := StringReplace(FCDS.FieldByName('A').AsString, 'CAF', '', [rfReplaceAll]);

      pos1 := Pos('RC', FCDS.FieldByName('A').AsString);
      if pos1 > 0 then
      begin
        tmpStr := Copy(FCDS.FieldByName('A').AsString, 1, pos1 - 1);
        tmpSQL := Copy(FCDS.FieldByName('A').AsString, pos1, 200);
        pos1 := pos(' ', tmpSQL);
        if pos1 > 0 then
        begin
          tmpSQL := Copy(tmpSQL, pos1 + 1, 200);
          FCDS.FieldByName('A').AsString := tmpStr + tmpSQL;
        end
        else
          FCDS.FieldByName('A').AsString := tmpStr;
      end;
      FCDS.FieldByName('C_Sizes').AsString := FCDS.FieldByName('A').AsString;
      FCDS.Post;
    end;

    if (Pos(SMRec.Custno, 'AC365/AC388/AC434/ACD39/ACF29') > 0) and
       (Pos('能源板',FCDS.FieldByName('C_Sizes').AsString) >0) and
       ((copy(FCDS.FieldByName('Pno').AsString,2,1) <> 'Q') or
       (copy(FCDS.FieldByName('Pno').AsString,length(FCDS.FieldByName('Pno').AsString),1) <> 'R'))
    then
    begin
      Warn('能源板料號必須Q+尾碼R');
    end else
    if SameText('AC360',SMRec.Custno) and
       (Copy(FSourceCDS.FieldByName('remark').AsString,2,3) = '207') and
       (Pos(Copy(FCDS.FieldByName('Pno').AsString,3,1),'678')=0)    {*)}
    then
    begin
      Warn('汽車板料號3碼必須是6/8/D');
    end;

    //生益二維碼
    if SameText(SMRec.Custno, 'AC084') then
      SY_QRCode;

    ShowBarMsg('正在檢驗測試項目正確性...');

    FrmDLII041_prn := TFrmDLII041_prn.Create(nil);
    try
      FrmDLII041_prn.DS.DataSet := FCDS;
      FrmDLII041_prn.DS2.DataSet := FCDSLot;
      FrmDLII041_prn.l_SMRec := SMRec;
      FrmDLII041_prn.l_FIFOErr := tmpFIFOErr;
      FrmDLII041_prn.l_LotErr := Trim(tmpLotErr);
      if FrmDLII041_prn.ShowModal <> mrOK then
        Exit;
    finally
      FreeAndNil(FrmDLII041_prn);
    end;
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS3);
    ShowBarMsg('');
  end;

  //無批號增加一筆空數據
  if FCDSLot.IsEmpty then
  begin
    FCDSLot.Append;
    FCDSLot.FieldByName('lot').AsString := ' ';
    FCDSLot.Post;
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

  if SameText(SMRec.M2, 'X') then                 //968格式
  begin
    if isCY then                                      //超毅和普通一樣
      tmpSQL := 'Other-COC7'
    else if (POS(SMRec.Custno, 'AC093/AM010')>0) then          //廣州添利,胜宏
      tmpSQL := 'Other-COCf'
    else                                              //默認
      tmpSQL := 'Other-COC9'
  end
  else if SameText(SMRec.M2, 'Y') or SameText(SMRec.M2, 'Z') then          //958G,988G格式
    tmpSQL := 'Other-COCn'
  else if (SMRec.M2 = 'B') or (SMRec.M2 = 'M') then                          //大寫BM:859GTA,180GN格式
    tmpSQL := 'Other-COCo'
  else if SameText(SMRec.Custno, 'AH017') or (SameText(SMRec.Custno, 'AC174') and (SMRec.M2 = '4')) or (SameText(SMRec.Custno,
    'AC096') and (SMRec.M2 = '4')) then           //臺灣格式
    tmpSQL := 'Other-COC4'
  else if (Pos(SMRec.Custno, 'AC347/AC148/AC111/AC072/AC360/AC109/AC136/ACA27') > 0) then                  //加布基重項目格式
    tmpSQL := 'Other-COC5'
  else if (Pos(SMRec.Custno, 'N023') > 0) then                               //臺灣格式:布基重+膠片類型
    tmpSQL := 'Other-COCe'
  else if isHY then                                                      //加經緯紗變形項目格式(惠亞)
    tmpSQL := 'Other-COC6'
  else if isCY then                                                      //超毅
    tmpSQL := 'Other-COC7'
  else if Pos(SMRec.Custno, 'AC093/AM010') > 0 then                           //添利
    tmpSQL := 'Other-COCd'
  else if SameText(SMRec.Custno, 'AC084') then                           //生益
    tmpSQL := 'Other-COCm'
  else if SameText(SMRec.Custno, 'AC172') then
    tmpSQL := 'Other-COCq'
  else
    tmpSQL := ProcId;                                                     //默認

  GetPrintObj('Dli', ArrPrintData, tmpSQL);
  ArrPrintData := nil;
end;

procedure TDLII041_rpt.AddCDSDetail(Lot, Units, RC: string; Qty: Double; SMRec: TSplitMaterialnoPP);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if not FCDSDli200.Active then
  begin
    tmpSQL := 'Select GlassCloth,Supplier From Dli200 Where Bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    FCDSDli200.Data := Data;
  end;

  with FCDSDetail do
  begin
    Append;
    FieldByName('pname').AsString := FCDS.FieldByName('pname').AsString;
    FieldByName('sizes').AsString := FCDS.FieldByName('sizes').AsString;
    FieldByName('c_sizes').AsString := FCDS.FieldByName('c_sizes').AsString;
    FieldByName('lot').AsString := Lot;
    if SameText(Units, 'ROL') then
      FieldByName('qty').AsFloat := Qty / StrToInt(SMRec.M11_13)
    else
      FieldByName('qty').AsFloat := Qty;
    FieldByName('units').AsString := Units;
    FieldByName('rc').AsString := RC;
    FieldByName('resin').AsString := GetResin(SMRec.Custno, SMRec.M2, SMRec.M18, False);
    if FCDSDli200.Locate('GlassCloth', Copy(Lot, 10, 1), [loCaseInsensitive]) then
      FieldByName('pp').AsString := FCDSDli200.Fields[1].AsString;
    Post;
  end;
end;

//生益二維碼
procedure TDLII041_rpt.SY_QRCode;
var
  tmpLot, tmpStr1, tmpStr2, rc, rf, gt, vc: string;
begin
  with FCDSLot do
  begin
    First;
    while not Eof do
    begin
      tmpLot := tmpLot + ',' + FieldByName('lot1').AsString;
      Next;
    end;
  end;
  if Length(tmpLot) > 0 then
    Delete(tmpLot, 1, 1);

  if not FCDSLot.IsEmpty then
  begin
    FCDSLot.First;
    rc := FCDSLot.FieldByName('rc').AsString;
    rf := FCDSLot.FieldByName('rf').AsString;
    gt := FCDSLot.FieldByName('pg').AsString;
    vc := FCDSLot.FieldByName('vc').AsString;
  end;

  tmpStr1 := '{"Mtype":"PP","CMNumber":"' + FCDS.FieldByName('C_pno').AsString + '",' + '"IT":"' + FCDS.FieldByName('C_sizes').AsString
    + '",' + '"SLN":"' + tmpLot + '",' + '"GCS":"' + FCDS.FieldByName('PP').AsString + '",' + '"Surface":"OK",' +
    '"Bbjz":"' + FCDS.FieldByName('G11').AsString + '",' + '"Szhl":"' + rc + '",' + '"Ljtime":"' + gt + '",' + '"Jll":"'
    + rf + '",' + '"Hff":"' + vc + '",' + '"Rrzd":"",' + '"Jzb":"",' + '"Rateflow":""}';
  tmpStr1 := StringReplace(tmpStr1, '±', '+/-', [rfReplaceAll]);
  tmpStr2 := g_UInfo^.TempPath + 'coc_pp.bmp';
  if getcode(tmpStr1, tmpStr2, Fm_image) then
  begin
    FCDS.Edit;
    FCDS.FieldByName('QRcode').AsString := tmpStr2;
    FCDS.Post;
  end;
end;

function TDLII041_rpt.GetJxTA_oeb10(const oao06: string; ta_oeb10: Tfield): boolean;
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
      if pos(ls[4], 'AC114/AC365/AC388/AC434/ACD39') > 0 then
        ta_oeb10.DataSet.FieldByName('C_Orderno').asstring := tmpCDS.Fields[2].asstring
      else
        ta_oeb10.DataSet.FieldByName('C_Orderno').asstring := tmpCDS.Fields[1].asstring;
    end;
  finally
    ls.free;
    tmpCDS.free;
  end;
end;

procedure TDLII041_rpt.CheckCar(pno, c_sizes, orderno, remark: string; orderitem: integer);
var
  ls: TStrings;
  i: integer;
  s3, sql,itm: string;
  isCar: boolean;
begin
  ls := TStringList.create;
  s3 := Copy(pno, 3, 1);
  isCar := false;
  try
    ls.CommaText := 'TTEOQA,NJHEQA,AE,汽車,AT板,ANTICAF,Anti-CAF,能源板,CAR';
    for i := 0 to ls.count - 1 do
    begin
      itm:=ls[i];
      if (Pos(itm, c_sizes) > 0) or (Pos(itm, remark) > 0) then
      begin
        isCar := true;
        break;
      end;
    end;

    if not isCar then
    begin
      sql := 'select premark from mps070 where bu=%s and orderno=%s and orderitem=%d and premark like ';
      sql := Format(sql, [QuotedStr(g_uinfo^.BU), QuotedStr(orderno), orderitem]) + quotedstr('%汽車%');
      QueryExists(sql, isCar);
    end;

    if isCar and (Pos(s3, '6/8/D') = 0) then
    begin
      Warn('汽車板料號3碼必須是6/8/D');
    end;
  finally
    ls.Free;
  end;
end;
//procedure TDLII041_rpt.SetSourceCDS(const Value: TClientDataSet);
//begin
//  FSourceCDS := Value;
//end;

end.

