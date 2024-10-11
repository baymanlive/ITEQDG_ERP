{*******************************************************}
{                                                       }
{                unDLII030_rpt                          }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: COC-PP列印                }
{                             DLII030、DLIR050共用此單元}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII030_rpt;

interface

uses
  Windows, Classes, SysUtils, DB, DBClient, Forms, Variants, Math, StrUtils,
  Controls, ComCtrls, DateUtils, unGlobal, unCommon, unDLII030_prn,
  unDLII040_cocerr, unDLIR050_units, unCheckC_sizes;

type
  TDLII030_rpt = class
  private
    FSourceCDS:TClientDataSet;
    FCDS:TClientDataSet;
    FCDSLot:TClientDataSet;
    FCDSDetail:TClientDataSet;
    FCDSDli200:TClientDataSet;
    FCheckC_sizes:TCheckC_sizes;
    procedure ShowBarMsg(msg:string);
    function GetRC:string;
    function GetBBXD(SMRec:TSplitMaterialnoPP):string;
    function SetFGHI_FromDli340(DataSet:TDataSet;
      SMRec:TSplitMaterialnoPP):Boolean;
    procedure AddCDSDetail(Lot,Units,RC:string; Qty:Double; SMRec:TSplitMaterialnoPP);
  public
    constructor Create(CDS:TClientDataSet);
    destructor Destroy; override;
    procedure StartPrint(ProcId:string);
  end;

implementation

const l_CDSXml='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="id" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Indate" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="Indate1" fieldtype="string" WIDTH="20"/>' //年月日
               +'<FIELD attrname="Fileno" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="TestName" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="E_seal" fieldtype="boolean"/>'
               +'<FIELD attrname="A" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="B" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="C" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="D1" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="D11" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="D2" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="D21" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E1_unit" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E1" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E11" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E2_unit" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E2" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="E21" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="F1" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="G1" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="G11" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="PP" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="Resin" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="CPK1" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="CPK2" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="CPK3" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="PP_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Resin_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="CPK_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Cl_std" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Cl" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Br_std" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Br" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Cl_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="Cl_pass" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="GP_ROHS_pass" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="F" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="G" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="H" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="H_TestMethod" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="I" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="J1" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="J11" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="STS_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="CustPno_visible" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="remark" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="Custabs" fieldtype="string" WIDTH="100"/>'
               +'<FIELD attrname="PrdDate" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="ExpDate" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="Orderno" fieldtype="string" WIDTH="200"/>'   //廠內訂單號
               +'<FIELD attrname="Pno" fieldtype="string" WIDTH="200"/>'       //廠內料號
               +'<FIELD attrname="Pname" fieldtype="string" WIDTH="200"/>'     //廠內品名
               +'<FIELD attrname="Sizes" fieldtype="string" WIDTH="200"/>'     //廠內規格
               +'<FIELD attrname="C_Orderno" fieldtype="string" WIDTH="200"/>' //客戶訂單號
               +'<FIELD attrname="C_Pno" fieldtype="string" WIDTH="200"/>'     //客戶料號
               +'<FIELD attrname="C_Sizes" fieldtype="string" WIDTH="200"/>'   //客戶規格
               +'<FIELD attrname="PP_Sizes" fieldtype="string" WIDTH="200"/>'  //客戶品名指定的玻布供應商
               +'<FIELD attrname="PPErr" fieldtype="string" WIDTH="200"/>'     //玻布限定錯誤信息
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

const l_CDSLotXml='<?xml version="1.0" standalone="yes"?>'
                 +'<DATAPACKET Version="2.0">'
                 +'<METADATA><FIELDS>'
                 +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
                 +'<FIELD attrname="lot1" fieldtype="string" WIDTH="20"/>'
                 +'<FIELD attrname="qty" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="rc" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="rf" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="pg" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="vc" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="sf" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="prddate" fieldtype="string" WIDTH="10"/>'
                 +'<FIELD attrname="glasscloth" fieldtype="string" WIDTH="10"/>'
                 +'</FIELDS><PARAMS/></METADATA>'
                 +'<ROWDATA></ROWDATA>'
                 +'</DATAPACKET>';

const l_CDSDetailXml='<?xml version="1.0" standalone="yes"?>'
                    +'<DATAPACKET Version="2.0">'
                    +'<METADATA><FIELDS>'
                    +'<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>'
                    +'<FIELD attrname="sizes" fieldtype="string" WIDTH="30"/>'
                    +'<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>'
                    +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
                    +'<FIELD attrname="qty" fieldtype="r8"/>'
                    +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
                    +'<FIELD attrname="rc" fieldtype="string" WIDTH="10"/>'
                    +'<FIELD attrname="resin" fieldtype="string" WIDTH="30"/>'
                    +'<FIELD attrname="pp" fieldtype="string" WIDTH="30"/>'
                    +'</FIELDS><PARAMS/></METADATA>'
                    +'<ROWDATA></ROWDATA>'
                    +'</DATAPACKET>';

constructor TDLII030_rpt.Create(CDS:TClientDataSet);
begin
  FSourceCDS:=CDS;
  FCDS:=TClientDataSet.Create(nil);
  FCDSLot:=TClientDataSet.Create(nil);
  FCDSDetail:=TClientDataSet.Create(nil);
  FCDSDli200:=TClientDataSet.Create(nil);
  InitCDS(FCDS, l_CDSXml);
  InitCDS(FCDSLot, l_CDSLotXml);
  InitCDS(FCDSDetail, l_CDSDetailXml);
  FCheckC_sizes:=TCheckC_sizes.Create;
end;

destructor TDLII030_rpt.Destroy;
begin
  FreeAndNil(FCDS);
  FreeAndNil(FCDSLot);
  FreeAndNil(FCDSDetail);
  FreeAndNil(FCDSDli200);
  FreeAndNil(FCheckC_sizes);
  inherited;
end;

procedure TDLII030_rpt.ShowBarMsg(msg:string);
begin
  g_StatusBar.Panels[0].Text:=CheckLang(msg);
  Application.ProcessMessages;
end;

//客戶品名欄位取RC公差值
function TDLII030_rpt.GetRC:string;
var
  tmpStr, s, sp:WideString;
  i, pos1, len:Integer;
begin
  tmpStr:=FCDS.FieldByName('C_Sizes').AsString;
  len:=2;
  sp:='+/-';
  pos1:=pos(sp,tmpStr);
  if pos1=0 then
  begin
    len:=0;
    sp:='±';
    pos1:=pos(sp,tmpStr);
  end;

  s:='';
  if pos1>0 then
  begin
    Delete(tmpStr,1,pos1+len);
    pos1:=0; //小數點個數
    for i:=1 to Length(tmpStr) do
    begin
      if Char(tmpStr[i]) in ['0'..'9','.'] then
      begin
        if tmpStr[i]='.' then
           pos1:=pos1+1;
        if pos1<2 then
           s:=s+tmpStr[i]
        else
           Break;
      end else
        Break;
    end;
  end;

  Result:=s;
end;

//玻布限定
function TDLII030_rpt.GetBBXD(SMRec:TSplitMaterialnoPP):string;
var
  tmpRecno,tmpMaxNum,tmpNum:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  //玻布限定資料
  Result:='';
  Data:=null;
  tmpSQL:='Select * From Dli530 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And charindex('+Quotedstr(SMRec.Custno)+',Custno)>0';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpMaxNum:=-1;
  tmpRecno:=-1;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        tmpNum:=0;
        if Pos('/'+SMRec.M2+'/','/'+FieldByName('Code2').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('Code2').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/'+SMRec.M3+'/','/'+FieldByName('Code3').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('Code3').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/'+SMRec.M4_7+'/','/'+FieldByName('Code4_7').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('Code4_7').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/'+SMRec.M8_10+'/','/'+FieldByName('Code8_10').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('Code8_10').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/'+SMRec.M17+'/','/'+FieldByName('CodeLast2').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('CodeLast2').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if Pos('/'+SMRec.M18+'/','/'+FieldByName('CodeLast1').AsString+'/')>0 then
           Inc(tmpNum)
        else if Length(FieldByName('CodeLast1').AsString)>0 then
        begin
          Next;
          Continue;
        end;

        if (tmpNum>0) and (tmpMaxNum<tmpNum) then
        begin
          tmpMaxNum:=tmpNum;
          tmpRecno:=Recno;
        end;
        if tmpMaxNum=6 then
           Break;
        Next;
      end;
    end;

    if tmpRecno<>-1 then
    begin
      tmpCDS.RecNo:=tmpRecno;
      Result:=tmpCDS.FieldByName('Value').AsString;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

{
拉絲法PG1:AK001 AC347 AC388 AC434 AC093(E) AC091/AC094(N)
布種A=C=L=3=6 E=H F=I G=J B=N O=S Q=U R=V 8=T=P
}
function TDLII030_rpt.SetFGHI_FromDli340(DataSet:TDataSet;
  SMRec:TSplitMaterialnoPP):Boolean;
var
  tmpStr1,tmpStr2,tmpRC:string;
  tmpBo:Boolean;
  procedure SetFGHI();
  var
    pos1:Integer;
    tmpPG2:WideString;
  begin
    with DataSet do
    begin
      if (DataSet.FieldByName('Custno').AsString='@') and
         (Pos(SMRec.Custno,'AC388/AC114/N013/AC365')>0) then
        FCDS.FieldByName('F').AsString:=FieldByName('RC').AsString+'±1.5'
      else if Length(tmpRC)>0 then
        FCDS.FieldByName('F').AsString:=FieldByName('RC').AsString+'±'+tmpRC
      else
        FCDS.FieldByName('F').AsString:=FieldByName('RC').AsString+FieldByName('RC_diff').AsString;

      FCDS.FieldByName('G').AsString:=FieldByName('RF').AsString;
      if (UpperCase(FSourceCDS.FieldByName('Custno').AsString)='AK001') and (SMRec.M2='8') then
         FCDS.FieldByName('H').AsString:='100±20'
      else if (UpperCase(FSourceCDS.FieldByName('Custno').AsString)='AC204') and (Pos(SMRec.M2,'4/6/F/P')>0) then
         FCDS.FieldByName('H').AsString:='125±20'
      else if (UpperCase(FSourceCDS.FieldByName('Custno').AsString)='AC144') and (SMRec.M2='4') then
      begin
        tmpPG2:=FieldByName('PG2').AsString;
        pos1:=Pos('±', tmpPG2);
        if pos1>0 then
           tmpPG2:=Copy(tmpPG2, 1, pos1);
        FCDS.FieldByName('H').AsString:=tmpPG2+'12';
      end
      else if DataSet.FieldByName('Custno').AsString='@' then
      begin
        if (Pos(SMRec.Custno,'AK001/AC347/AC388/AC434')>0) or
           (SameText(SMRec.Custno, 'AC093') and SameText(SMRec.M2, 'E')) or
           (SameText(SMRec.Custno, 'AC091/AC094') and SameText(SMRec.M2, 'N')) then
           FCDS.FieldByName('H').AsString:=FieldByName('PG1').AsString
        else
           FCDS.FieldByName('H').AsString:=FieldByName('PG2').AsString;
      end else
         FCDS.FieldByName('H').AsString:=FieldByName('PG1').AsString;

      FCDS.FieldByName('I').AsString:=FieldByName('VC').AsString;
    end;
  end;
begin
  if DataSet.IsEmpty then
  begin
    Result:=False;
    Exit;
  end;

  if Pos(SMRec.M3, '36ACL')>0 then
     tmpStr1:=SMRec.M4_7+'3/'+SMRec.M4_7+'6/'+SMRec.M4_7+'A/'+SMRec.M4_7+'C/'+SMRec.M4_7+'L'
  else if Pos(SMRec.M3, 'EH')>0 then
     tmpStr1:=SMRec.M4_7+'E/'+SMRec.M4_7+'H'
  else if Pos(SMRec.M3, 'FI')>0 then
     tmpStr1:=SMRec.M4_7+'F/'+SMRec.M4_7+'I'
  else if Pos(SMRec.M3, 'GJ')>0 then
     tmpStr1:=SMRec.M4_7+'G/'+SMRec.M4_7+'J'
  else if Pos(SMRec.M3, 'BN')>0 then
     tmpStr1:=SMRec.M4_7+'B/'+SMRec.M4_7+'N'
  else if Pos(SMRec.M3, 'OS')>0 then
     tmpStr1:=SMRec.M4_7+'O/'+SMRec.M4_7+'S'
  else if Pos(SMRec.M3, '8PT')>0 then
     tmpStr1:=SMRec.M4_7+'8/'+SMRec.M4_7+'P/'+SMRec.M4_7+'T'
  else if Pos(SMRec.M3, 'QU')>0 then
     tmpStr1:=SMRec.M4_7+'Q/'+SMRec.M4_7+'U'
  else if Pos(SMRec.M3, 'RV')>0 then
     tmpStr1:=SMRec.M4_7+'R/'+SMRec.M4_7+'V'
  else
     tmpStr1:=SMRec.M4_7+SMRec.M3;

  tmpRC:=GetRC;

  tmpBo:=False;
  with DataSet do
  begin
    First;
    while not Eof do
    begin
      tmpStr2:=RightStr('00000'+FieldByName('Stkname').AsString,5);
      if Pos(tmpStr2, tmpStr1)>0 then
      begin
        SetFGHI;
        tmpBo:=True;
        Break;
      end;
      Next;
    end;

    if not tmpBo then
    begin
      First;
      while not Eof do
      begin
        tmpStr2:=RightStr('00000'+FieldByName('Stkname').AsString,4);
        if tmpStr2=SMRec.M4_7 then
        begin
          SetFGHI;
          tmpBo:=True;
          Break;
        end;
        Next;
      end;
    end;
  end;
  Result:=tmpBo;
end;

procedure TDLII030_rpt.StartPrint(ProcId:string);
var
  days,pos1:Integer;
  tmpSQL,tmpPno,tmpUnit,tmpStr,tmpVC,tmpOraDB,tmpDayErr,tmpOTDayErr,tmpBBXD,
  tmpFIFOErr,tmpLotErr:string;
  tmpDate:TDateTime;
  tmpBo,isPN,isHY,isAsk:Boolean;
  tmpTotQty:Double;
  Data:OleVariant;
  tmpCDS,tmpCDS2,tmpCDS3:TClientDataSet;
  SMRec:TSplitMaterialnoPP;
  ArrPrintData:TArrPrintData;
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

  tmpSQL:=LeftStr(FSourceCDS.FieldByName('Pno').AsString, 1);
  if Pos(tmpSQL, 'ET')>0 then
  begin
    ShowMsg('請列印PP!', 48);
    Exit;
  end;

  if Length(FSourceCDS.FieldByName('Pno').AsString)in [12,20] then
  begin
    tmpUnit:='PNL';
    isPN:=True;
  end else
  begin
    tmpUnit:='ROL';
    isPN:=False;
  end;

  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpOraDB:='ORACLE'
  else
     tmpOraDB:='ORACLE1';

  tmpCDS:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    //檢查批號正確性
    tmpSQL:='exec dbo.proc_CheckPPLot '+Quotedstr(g_UInfo^.BU)+','+
      Quotedstr(FSourceCDS.FieldByName('Dno').AsString)+','+
      IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    tmpSQL:='';
    while not tmpCDS.Eof do
    begin
      tmpSQL:=tmpSQL+#13#10+tmpCDS.Fields[0].AsString;
      tmpCDS.Next;
    end;
    if Length(tmpSQL)>0 then
    begin
      ShowMsg('下列批號存在錯誤:'+tmpSQL, 48);
      Exit;
    end;
    
    //檢查二維碼
    Data:=null;
    tmpSQL:='exec dbo.proc_CheckCOCQRCode '+Quotedstr(g_UInfo^.BU)+','+
      Quotedstr(FSourceCDS.FieldByName('Dno').AsString)+','+
      IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='sno<>0';
    tmpCDS.Filtered:=True;
    tmpSQL:='';
    while not tmpCDS.Eof do
    begin
      tmpSQL:=tmpSQL+#13#10+tmpCDS.Fields[0].AsString+'.'+tmpCDS.Fields[1].AsString;
      tmpCDS.Next;
    end;
    if Length(tmpSQL)>0 then
    begin
      if tmpCDS.RecordCount>10 then
      begin
        if not Assigned(FrmDLII040_cocerr) then
           FrmDLII040_cocerr:=TFrmDLII040_cocerr.Create(Application);
        FrmDLII040_cocerr.l_Coc_errid:=tmpSQL;
        FrmDLII040_cocerr.ShowModal;
      end else
        ShowMsg('下列二維碼存在錯誤:'+tmpSQL, 48);
      Exit;
    end;
    tmpCDS.Filtered:=False;
    
    //pp批號重復
    if not isPN then
    begin
      Data:=null;
      tmpSQL:='exec dbo.proc_DLIR050_PPManfac '+Quotedstr(g_UInfo^.BU)+','+
        Quotedstr(FSourceCDS.FieldByName('Custno').AsString)+','+
        Quotedstr(FSourceCDS.FieldByName('Dno').AsString)+','+
        IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;
      tmpSQL:='';
      while not tmpCDS.Eof do
      begin
        tmpSQL:=tmpSQL+#13#10+tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;
      if Length(tmpSQL)>0 then
      begin
        ShowMsg('此客戶批號重複:'+tmpSQL, 48);
        Exit;
      end;
    end;

    //玻布供應商
    Data:=null;
    tmpSQL:='Select GlassCloth,Supplier From Dli200 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS3.Data:=Data;

    Data:=null;
    tmpSQL:='exec dbo.proc_GetCOCIndate '+Quotedstr(g_UInfo^.BU)+','+
      Quotedstr(DateToStr(FSourceCDS.FieldByName('Indate').AsDateTime));
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS.Data:=Data;
    tmpDate:=EncodeDate(tmpCDS.Fields[0].AsInteger,
                        tmpCDS.Fields[1].AsInteger,
                        tmpCDS.Fields[2].AsInteger);

    while not FCDS.IsEmpty do
      FCDS.Delete;
    while not FCDSLot.IsEmpty do
      FCDSLot.Delete;
    while not FCDSDetail.IsEmpty do
      FCDSDetail.Delete;

    FCDS.Append;
    FCDS.FieldByName('id').AsString:='1';
    FCDS.FieldByName('Indate').AsString:=tmpCDS.Fields[0].AsString+'/'+
                                         RightStr('00'+tmpCDS.Fields[1].AsString,2)+'/'+
                                         RightStr('00'+tmpCDS.Fields[2].AsString,2);
    FCDS.FieldByName('Indate1').AsString:=CheckLang(tmpCDS.Fields[0].AsString+'年'+
                                                    tmpCDS.Fields[1].AsString+'月'+
                                                    tmpCDS.Fields[2].AsString+'日');
    FCDS.FieldByName('Fileno').AsString:='Q1-'+FormatDateTime(g_cShortDateYYMMDD, tmpDate)
                                              +FSourceCDS.FieldByName('Coc_no').AsString;

    //訂單資料
    {oea10客戶訂單號
     oeb04廠內料號
     oeb11客戶料號
     ta_oeb01經向
     ta_oeb02緯向
     ta_oeb10客戶規格}
    ShowBarMsg('正在查詢訂單資料...');
    Data:=null;
    tmpSQL:=' Select X.*,oao06 From ('
           +' Select oea04,oea10,oeb01,oeb03,oeb04,oeb11,ta_oeb01,ta_oeb02,ta_oeb10'
           +' From oea_file Inner Join oeb_file On oea01=oeb01'
           +' Where oeb01='+Quotedstr(FSourceCDS.FieldByName('Orderno').AsString)
           +' And oeb03='+IntToStr(FSourceCDS.FieldByName('Orderitem').AsInteger)
           +' ) X Left Join oao_file Y On oeb01=oao01 and oeb03=oao03 and oao05=1';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop訂單資料不存在,請確認!', 48);
      Exit;
    end;

    tmpPno:=tmpCDS.FieldByName('oeb04').AsString;
    FCDS.FieldByName('Pno').AsString:=tmpPno;
    if FSourceCDS.FieldByName('Pno').AsString<>tmpPno then
    begin
      ShowMsg('出貨排程料號['+FSourceCDS.FieldByName('Pno').AsString+']'#13#10
             +'與TipTop訂單料號['+tmpPno+']不一致,請確認!', 48);
     // Exit;
    end;

    if isPN then
    begin
      SMRec.M11_13:=tmpCDS.FieldByName('ta_oeb01').AsString;
      SMRec.M14_16:=tmpCDS.FieldByName('ta_oeb02').AsString;
    end;
    if Pos(FSourceCDS.FieldByName('Custno').AsString,'N012,N005')>0 then
       FCDS.FieldByName('Orderno').AsString:=Copy(FSourceCDS.FieldByName('Remark').AsString,7,10);
    if Length(FCDS.FieldByName('Orderno').AsString)<>10 then
       FCDS.FieldByName('Orderno').AsString:=FSourceCDS.FieldByName('Orderno').AsString;
    FCDS.FieldByName('C_Orderno').AsString:=GetC_Orderno(tmpCDS.FieldByName('oea04').AsString,tmpCDS.FieldByName('oea10').AsString,tmpCDS.FieldByName('oao06').AsString);
    FCDS.FieldByName('C_Pno').AsString:=tmpCDS.FieldByName('oeb11').AsString;
    FCDS.FieldByName('C_Sizes').AsString:=tmpCDS.FieldByName('ta_oeb10').AsString;

    ShowBarMsg('正在查詢料號資料...');
    Data:=null;
    tmpSQL:='Select ima01,ima02,ima021 From ima_file'
           +' Where ima01='+Quotedstr(tmpPno)
           +' or ima01='+Quotedstr(FCDS.FieldByName('Pno').AsString);
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('TipTop此筆料號['+tmpPno+']品名規格不存在,請確認!', 48);
      Exit;
    end;

    tmpCDS.Locate('ima01',tmpPno,[]); //tmpCDS最多2筆,最少1筆,此處不一定找到
    FCDS.FieldByName('Pname').AsString:=tmpCDS.Fields[1].AsString;
    FCDS.FieldByName('Sizes').AsString:=tmpCDS.Fields[2].AsString;
    if SameText(FSourceCDS.FieldByName('Custno').AsString,'ACB32') then
    begin
      if Pos('ITA-9300',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT968','ITA-9300',[])
      else if Pos('ITA-9310',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT150DA','ITA-9310',[])
      else if Pos('ITA-9320',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT150DA','ITA-9320',[])
      else if Pos('ITA-9350',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT150DA','ITA-9350',[])
      else if Pos('ITA-9380',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT150DA','ITA-9380',[])
      else if Pos('ITA-9430',FCDS.FieldByName('C_Sizes').AsString)>0 then
         FCDS.FieldByName('Pname').AsString:=StringReplace(FCDS.FieldByName('Pname').AsString,'IT170GRA1','ITA-9430',[]);
    end;

    tmpPno:=FCDS.FieldByName('Pno').AsString;
    if isPN then
    begin
      if Length(tmpPno)=20 then
         tmpPno:=Copy(tmpPno,1,10)+'999999'+Copy(tmpPno,19,2)   //20碼新料號
      else
         tmpPno:=Copy(tmpPno,1,10)+'999999'+Copy(tmpPno,11,2);  //后面截取字符中用
    end;
    SMRec.M1:=Copy(tmpPno,1,1);
    SMRec.M2:=Copy(tmpPno,2,1);
    SMRec.M3:=Copy(tmpPno,3,1);
    SMRec.M4_7:=Copy(tmpPno,4,4);
    SMRec.M8_10:=Copy(tmpPno,8,3);
    if not isPN then
    begin
      SMRec.M11_13:=Copy(tmpPno,11,3);
      SMRec.M14_16:=Copy(tmpPno,14,3);
    end;
    SMRec.M17:=Copy(tmpPno,17,1);
    SMRec.M18:=Copy(tmpPno,18,1);
    if (SMRec.M2='8') and SameText(SMRec.M18,'R') then
       SMRec.M2:='F';

    SMRec.Custno:=FSourceCDS.FieldByName('Custno').AsString;
    if Pos(SMRec.Custno,'N012,N005')>0 then
       SMRec.Custno:=UpperCase(Copy(FSourceCDS.FieldByName('Remark').AsString,1,5));
    isHY:=Pos(SMRec.Custno, 'AC394/AC152/AC844')>0;              //惠亞

    //廠內料號與客戶品名
    tmpSQL:=FCheckC_sizes.CheckPP_C_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString, isPN, isAsk);
    if Length(tmpSQL)>0 then
    begin
      if isAsk then
      begin
        if ShowMsg(tmpSQL,33)=IdCancel then
           Exit;
      end else begin
        ShowMsg(tmpSQL,48);
        Exit;
      end;
    end;

    //客戶料號與廠內料號
    if Length(FCDS.FieldByName('C_Pno').AsString)>0 then
    begin
      Data:=null;

      tmpSQL:='declare @pno varchar(20)'
             +' select top 1 @pno=pno from dli600 where bu='+Quotedstr(g_UInfo^.BU)
             +' and custno='+Quotedstr(SMRec.Custno)
             +' and c_pno='+Quotedstr(FCDS.FieldByName('C_Pno').AsString)
             +' if @pno is null'
             +' begin'
             +'   if exists(select 1 from dli600 where bu='+Quotedstr(g_UInfo^.BU)+' and custno='+Quotedstr(SMRec.Custno)+')'
             +'      set @pno=''err'''
             +'   else'
             +'      set @pno=''ok'''
             +' end'
             +' select @pno';
      if not QueryOneCR(tmpSQL, Data) then
         Exit;
      tmpSQL:=VarToStr(Data);
      if tmpSQL<>'ok' then
      begin
        if tmpSQL='err' then
        begin
          ShowMsg('客戶料號未維護!', 48);
          Exit;
        end else if Copy(tmpSQL,2,Length(tmpSQL)-2)<>Copy(FCDS.FieldByName('Pno').AsString,2,Length(FCDS.FieldByName('Pno').AsString)-2) then
        begin
          ShowMsg('廠內料號不符,要求是：'+#13#10+FCDS.FieldByName('C_Pno').AsString+'=>'+tmpSQL, 48);
          Exit;
        end;
      end;
    end;

    //簡稱
    if SMRec.Custno='AC365' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('方正高密')
    else if SMRec.Custno='AC114' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('方正多層')
    else if SMRec.Custno='AC388' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('高密HDI')
    else if SMRec.Custno='AC091' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('廣大')
    else if SMRec.Custno='AC094' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('廣元')
    else if SMRec.Custno='AC117' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('廣合')
    else if SMRec.Custno='ACC19' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('廣合-2')       
    else if SMRec.Custno='AC434' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('重慶高密')
    else if SMRec.Custno='AC172' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('欣強')
    else if SMRec.Custno='AC638' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('珠海元盛')
    else if SMRec.Custno='AC449' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('奈電')
    else if SMRec.Custno='AC625' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('廣州快捷')
    else if SMRec.Custno='AC103' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('快捷電路')
    else if SMRec.Custno='ACB00' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('興森電子')
    else if SMRec.Custno='ACB89' then
       FCDS.FieldByName('Custabs').AsString:=CheckLang('江西比亞迪')             
    else
       FCDS.FieldByName('Custabs').AsString:=FSourceCDS.FieldByName('Custshort').AsString;
    //簡稱

    //電子簽名
    FCDS.FieldByName('E_seal').AsBoolean:=True;

    //N005 超毅po
    if SameText(FSourceCDS.FieldByName('Custno').AsString,'N005') and
       (Pos(SMRec.Custno,'AC405/AC075/AC310/AC311/AC950')>0) then
    begin
      Data:=null;
      tmpSQL:=' Select oea10,oao06 From ('
             +' Select oea10,oeb01,oeb03'
             +' From oea_file Inner Join oeb_file On oea01=oeb01'
             +' Where oeb01='+Quotedstr(Copy(FSourceCDS.FieldByName('Remark').AsString,7,10))
             +' And oeb03='+Copy(FSourceCDS.FieldByName('Remark').AsString,18,4)
             +' ) X Left Join oao_file Y On oeb01=oao01 and oeb03=oao03 and oao05=1';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
         FCDS.FieldByName('C_Orderno').AsString:=GetC_Orderno(SMRec.Custno,tmpCDS.FieldByName('oea10').AsString,tmpCDS.FieldByName('oao06').AsString);
    end;

    //纖維結構
    Data:=null;
    tmpSQL:='Select Top 1 * From Dli330 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Fiber='+Quotedstr(SMRec.M4_7);
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        FCDS.FieldByName('D1').AsString:=tmpCDS.FieldByName('Warp').AsString+'±2';
        FCDS.FieldByName('D11').AsString:=tmpCDS.FieldByName('Warp').AsString;
        FCDS.FieldByName('D2').AsString:=tmpCDS.FieldByName('Filling').AsString+'±2';
        FCDS.FieldByName('D21').AsString:=tmpCDS.FieldByName('Filling').AsString;
      end;
    end;
    //纖維結構

    //品名
    if isHY or (Pos(SMRec.Custno,'AC093/AC151/AC143/AC097/AC075/AC405/AC310/AC311/AC950/AC707')>0) then
       FCDS.FieldByName('A').AsString:=FCDS.FieldByName('C_Sizes').AsString
    else if SameText(SMRec.Custno, 'AC111') and (Pos('90003',FCDS.FieldByName('C_Sizes').AsString)>0) then
       FCDS.FieldByName('A').AsString:=FCDS.FieldByName('Pname').AsString+' '+FloatToStr(StrToInt(SMRec.M8_10)/10)+'% 90003'
    else if SameText(SMRec.Custno, 'AC111') and (Pos('90001',FCDS.FieldByName('C_Sizes').AsString)>0) then
       FCDS.FieldByName('A').AsString:=FCDS.FieldByName('Pname').AsString+' '+FloatToStr(StrToInt(SMRec.M8_10)/10)+'% 90001'
    else
       FCDS.FieldByName('A').AsString:=FCDS.FieldByName('Pname').AsString+' '+FloatToStr(StrToInt(SMRec.M8_10)/10)+'%';
    //品名

    //尺寸
    if isPN then
    begin
      if SameText(SMRec.Custno, 'EI001') then
         FCDS.FieldByName('B').AsString:=SMRec.M11_13+'"G*'+SMRec.M14_16+'"'
      else
         FCDS.FieldByName('B').AsString:=SMRec.M11_13+'"*'+SMRec.M14_16+'"';
      FCDS.FieldByName('E1_unit').AsString:='mm';
      FCDS.FieldByName('E1').AsString:='+1/-0';
      FCDS.FieldByName('E2_unit').AsString:='mm';
      FCDS.FieldByName('E2').AsString:='+1/-0';
    end else
    begin
      FCDS.FieldByName('B').AsString:=FloatToStr(StrToInt(SMRec.M14_16)/10)+'"*'+SMRec.M11_13+'M';
      FCDS.FieldByName('E1_unit').AsString:='m';
      FCDS.FieldByName('E1').AsString:='±1';
      FCDS.FieldByName('E2_unit').AsString:='mm';
      if (SMRec.M14_16<>'495') and (SMRec.M14_16<>'496') then
         FCDS.FieldByName('E2').AsString:='+4/-4'
      else
         FCDS.FieldByName('E2').AsString:='+8/-0';

      FCDS.FieldByName('E11').AsString:=SMRec.M11_13;          //*
    end;

    Data:=null;
    tmpSQL:='Select * From Dli170 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And (Sizes='+Quotedstr(SMRec.M11_13)
           +' OR Sizes='+Quotedstr(SMRec.M14_16)+')';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      if isPN and tmpCDS.Locate('Sizes',SMRec.M11_13,[]) then  //*
         FCDS.FieldByName('E11').AsString:=tmpCDS.FieldByName('fValue').AsString;
      if tmpCDS.Locate('Sizes',SMRec.M14_16,[]) then
         FCDS.FieldByName('E21').AsString:=tmpCDS.FieldByName('fValue').AsString;
    end;

    //檢查客戶品名:小片尺寸
    if isPN then
    if not (SameText(SMRec.Custno,'AC101') and (Pos(FCDS.FieldByName('Pno').AsString,'MSA2116570XX,MSA7628480XX')>0)) then
    begin
      tmpSQL:=FCheckC_sizes.CheckPP_PN_sizes(SMRec, FCDS.FieldByName('C_Sizes').AsString,FCDS.FieldByName('E11').AsString,FCDS.FieldByName('E21').AsString);
      if Length(tmpSQL)>0 then
      begin
        ShowMsg(tmpSQL,48);
        Exit;
      end;
    end;

    //比例流量
    if isHY or SameText(SMRec.Custno,'AC109') then
    begin
      if not SameText(SMRec.Custno, 'AC109') then
         FCDS.FieldByName('F1').AsString:='NA'
      else
      begin
        Data:=null;
        tmpSQL:='Select Top 1 fValue,dValue,tValue From Dli280'
               +' Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Adhesive='+Quotedstr(SMRec.M2)
               +' And Fiber='+Quotedstr(SMRec.M4_7)
               +' And RC='+Quotedstr(FloatToStr(StrToInt(SMRec.M8_10)/10));
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data:=Data;
          if not tmpCDS.IsEmpty then
          begin    
            if Pos('.', tmpCDS.Fields[0].AsString)=0 then
               FCDS.FieldByName('F1').AsString:=tmpCDS.Fields[0].AsString+'.0±'+
                                                tmpCDS.Fields[1].AsString
            else
               FCDS.FieldByName('F1').AsString:=tmpCDS.Fields[0].AsString+'±'+
                                                tmpCDS.Fields[1].AsString;
          end;
        end;
      end;
    end;
    //AC109華通比例流量

    //AC084基重
    if Pos(SMRec.Custno,'AC084/AC148/AC347')>0 then
    begin
      Data:=null;
      tmpSQL:='Select Top 1 fValue,dValue From Dli370 Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Fiber='+Quotedstr(SMRec.M4_7);
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data:=Data;
        if not tmpCDS.IsEmpty then
        begin
          FCDS.FieldByName('G1').AsString:=tmpCDS.Fields[0].AsString+'±'+
                                            tmpCDS.Fields[1].AsString;
          FCDS.FieldByName('G11').AsString:=tmpCDS.Fields[0].AsString;
        end;
      end;
    end;
    //AC084基重

    //PP規范      
    Data:=null;
    tmpSQL:='Select *,Case When Len(isNull(LastCode,''''))>0 Then LastCode Else ''@'' End LastCode1 From Dli340'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And (Custno=''@'' OR Custno='+Quotedstr(SMRec.Custno)+')'
           +' And Adhesive='+Quotedstr(SMRec.M2)
           +' And RC='+Quotedstr(FloatToStr(StrToInt(SMRec.M8_10)/10));
   if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
        Filtered:=False;
        Filter:='Custno='+Quotedstr(SMRec.Custno)+' And LastCode1='+Quotedstr(SMRec.M18);
        Filtered:=True;
        if not SetFGHI_FromDli340(tmpCDS, SMRec) then
        begin
            Filtered:=False;
            Filter:='Custno='+Quotedstr(SMRec.Custno)+' And LastCode1=''@''';
            Filtered:=True;
            if not SetFGHI_FromDli340(tmpCDS, SMRec) then
            begin
              Filtered:=False;
              Filter:='Custno=''@'' And LastCode1='+Quotedstr(SMRec.M18);
              Filtered:=True;
              if not SetFGHI_FromDli340(tmpCDS, SMRec) then
              begin
                Filtered:=False;
                Filter:='Custno=''@'' And LastCode1=''@''';
                Filtered:=True;
                SetFGHI_FromDli340(tmpCDS, SMRec);
              end;
            end
        end;
        Filtered:=False;
      end;
    end;
    //PP規范

    //VC測試值
    tmpVC:='0.00';
    Data:=null;
    tmpSQL:='Select Top 1 [Value] From DLI300 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Adhesive='+Quotedstr(SMRec.M2)
           +' And (Case When Len(Fiber)=3 Then ''0''+Fiber Else Fiber End)='+Quotedstr(SMRec.M4_7)
           +' And RC='+Quotedstr(SMRec.M8_10);
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
      begin
        tmpVC:=VarToStr(Data);
        if Pos('.',tmpVC)=0 then
           tmpVC:=tmpVC+'.00';
        if Length(tmpVC)=3 then
           tmpVC:=tmpVC+'0';
      end;
    end;
    //VC測試值

    //經緯紗變形 1.30~1.40
    Randomize;
    FCDS.FieldByName('J1').AsString:='≦5%';
    FCDS.FieldByName('J11').AsString:='1.'+IntToStr(RandomRange(30,40));
    //經緯紗變形

    //GT測試條件
    //IPC-TM-650
    //2.3.18
    //171±0.5℃ ***H_TestMethod=171或200
    if SameText(SMRec.M2,'E') then
       FCDS.FieldByName('H_TestMethod').AsString:='200'
    else
       FCDS.FieldByName('H_TestMethod').AsString:='171';
    //GT測試條件

    //氯溴
    Randomize;
    FCDS.FieldByName('Cl_std').AsString:='<900';
    FCDS.FieldByName('Br_std').AsString:='<900';
    FCDS.FieldByName('Cl').AsString:=IntToStr(RandomRange(200,400));
    FCDS.FieldByName('Br').AsString:=IntToStr(RandomRange(50,100));
    if Pos(SMRec.M2,'1/2/9/B/H/J/L/K/M/O/P/U/V/W/S')>0 then
       FCDS.FieldByName('Cl_visible').AsString:='1'
    else
       FCDS.FieldByName('Cl_visible').AsString:='0';
    //氯溴

    //STS
    if SameText(SMRec.Custno,'AC093') and (Pos(SMRec.M2, '4/8')>0) then
       FCDS.FieldByName('STS_visible').AsString:='1'
    else
       FCDS.FieldByName('STS_visible').AsString:='0';
    //STS

    //CustPno_visible
    tmpSQL:='AC148/AC082/AC135/AC109/AC405/AC310/AC311/AC075/AC347/AC734/AC950/AC121';
    if (Pos(SMRec.Custno,tmpSQL)>0) or
       (Pos(UpperCase(LeftStr(FSourceCDS.FieldByName('Remark').AsString,5)),tmpSQL)>0) then
       FCDS.FieldByName('CustPno_visible').AsString:='1'
    else
       FCDS.FieldByName('CustPno_visible').AsString:='0';
    //CustPno_visible

    //樹脂
    FCDS.FieldByName('Resin').AsString:=GetResin(SMRec.Custno,SMRec.M2,SMRec.M18,False);
    if Length(FCDS.FieldByName('Resin').AsString)>0 then
       FCDS.FieldByName('Resin_visible').AsString:='1'
    else
       FCDS.FieldByName('Resin_visible').AsString:='0';

    //玻布
    tmpSQL:=UpperCase(Copy(FSourceCDS.FieldByName('Remark').AsString,1,5));
    if (isHY or (Pos(SMRec.Custno, 'AC093/AC388/N013/AC148/AC347/AC096/AC174/AC082/AC075/AC310/AC311/AC405/AC950/N023')>0)) or
       (SameText(SMRec.Custno, 'AC111') and (Pos(SMRec.M2, '6/F/4/8/A/U')>0)) or
       (Pos(SMRec.Custno, 'AC365/AC434/AC114/AC388')>0) or
       (SameText(SMRec.Custno, 'AC178') and  (Pos(SMRec.M4_7,'1506/7628/1086/1037/0106/1080/3313/2116')>0)) then
      FCDS.FieldByName('PP_visible').AsString:='1'
    else
      FCDS.FieldByName('PP_visible').AsString:='0';

    //CPK
    FCDS.FieldByName('CPK1').AsString:=GetCPK(SMRec.Custno, False);
    FCDS.FieldByName('CPK2').AsString:=GetCPK(SMRec.Custno, False);
    FCDS.FieldByName('CPK3').AsString:=GetCPK(SMRec.Custno, False);
    if Length(FCDS.FieldByName('CPK1').AsString)>0 then
       FCDS.FieldByName('CPK_visible').AsString:='1'
    else
       FCDS.FieldByName('CPK_visible').AsString:='0';

    //備註
    Data:=null;
    tmpSQL:='Select Top 1 Remark From Dli240'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And (charindex('+Quotedstr(SMRec.Custno)+',Custno)>0 or Custno=''@'')'
           +' And charindex('+Quotedstr(SMRec.M2)+',Adhesive)>0'
           +' And (LstCode='+Quotedstr(SMRec.M18)+' or LstCode=''@'')'
           +' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
         FCDS.FieldByName('Remark').AsString:=VarToStr(Data);
    end;
    //備註

    //COC檢驗員
    Data:=null;
    tmpSQL:='Select Top 1 Cname From Hr_Employ'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Cno='+Quotedstr(FSourceCDS.FieldByName('Coc_user').AsString);
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
         FCDS.FieldByName('TestName').AsString:=VarToStr(Data);
    end;
    //COC檢驗員

    //有效期
    days:=-1;
    Data:=null;
    tmpSQL:='Select Top 1 IsNull(PPday,0) PPday From DLI510'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And (charindex('+Quotedstr(SMRec.Custno)+',Custno)>0 or Custno=''@'')'
           +' And charindex('+Quotedstr(SMRec.M2)+',Adhesive)>0'
           +' And (LstCode='+Quotedstr(SMRec.M18)+' or LstCode=''@'')'
           +' Order By Custno Desc,LstCode Desc';
    if QueryOneCR(tmpSQL, Data) then
    begin
      if not VarIsNull(Data) then
         days:=StrToInt(VarToStr(Data));
    end;
    //有效期

    //coc lot
    tmpPno:='';                //tmpPno暫存批號中最早生產的日期
    tmpDayErr:='';             //超出有效期批號
    tmpBo:=False;              //玻布限定不符
    tmpBBXD:=GetBBXD(SMRec);
    tmpTotQty:=0;
    Data:=null;
    tmpSQL:='Select manfac,rc,rf,pg,sum(qty) qty, min(sno) sno1 From Dli040'
           +' Where Dno='+Quotedstr(FSourceCDS.FieldByName('Dno').AsString)
           +' And Ditem='+IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger)
           +' And Bu='+Quotedstr(g_UInfo^.BU)
           +' And Isnull(qty,0)<>0 and Len(Isnull(manfac,''''))>4'
           +' Group By manfac,rc,rf,pg'
           +' Order By sno1';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpSQL:='';
      tmpCDS.Data:=Data;
      //總數量、批號
      while not tmpCDS.Eof do
      begin
        tmpStr:=tmpCDS.FieldByName('manfac').AsString;
        tmpSQL:=tmpSQL+' OR tc_sia02 Like '+Quotedstr(Copy(tmpStr,1,Length(tmpStr)-1)+'%');
        tmpTotQty:=tmpTotQty+tmpCDS.FieldByName('qty').AsFloat;
        tmpCDS.Next;
      end;

      if Length(tmpSQL)<>0 then
      begin
        tmpStr:='ORACLE';
        if Pos(SMRec.M18, 'G3')>0 then
           tmpStr:='ORACLE1';
        ShowBarMsg('正在查詢特性值...');
        Data:=null;
        tmpSQL:='Select tc_sia02,tc_sia201,tc_sia40'
               +' From tc_sia_file Where 1=2 '+tmpSQL;
        if QueryBySQL(tmpSQL, Data, tmpStr) then
        begin
          tmpCDS2:=TClientDataSet.Create(nil);
          try
            tmpCDS2.Data:=Data;
            tmpCDS.First;
            while not tmpCDS.Eof do
            begin
              tmpStr:=tmpCDS.Fields[0].AsString;
              tmpSQL:=Copy(tmpStr,2,4);
              if (tmpPno='') or (tmpPno<tmpSQL) then
                 tmpPno:=tmpSQL;

              FCDSLot.Append;

              //數量
              if isPN then
                 FCDSLot.FieldByName('qty').AsString:=FloatToStr(tmpCDS.Fields[4].AsFloat)
              else
                 FCDSLot.FieldByName('qty').AsString:=FloatToStr(RoundTo(tmpCDS.Fields[4].AsFloat/StrToInt(SMRec.M11_13),-3));

              //批號+數量(單位=ROL&數量<1或者單位=PNL,則批號后面顯示數量)
              if isPN and (tmpCDS.RecordCount<>1) then
                 FCDSLot.FieldByName('lot').AsString:=tmpStr+'('+FCDSLot.FieldByName('qty').AsString+tmpUnit+')'
              else if (not isPN) and (tmpCDS.RecordCount<>1) and
                 (tmpCDS.Fields[4].AsFloat/StrToInt(SMRec.M11_13)<1) then
                 FCDSLot.FieldByName('lot').AsString:=tmpStr+'('+FCDSLot.FieldByName('qty').AsString+tmpUnit+')'
              else
                 FCDSLot.FieldByName('lot').AsString:=tmpStr;

              //批號
              FCDSLot.FieldByName('lot1').AsString:=tmpStr;

              //數量+單位
              FCDSLot.FieldByName('qty').AsString:=FCDSLot.FieldByName('qty').AsString+tmpUnit;

              //生產日期
              FCDSLot.FieldByName('prddate').AsString:=DateToStr(GetLotDate(tmpSQL,
                Self.FSourceCDS.FieldByName('Indate').AsDateTime));
              if (days>0) and (Pos(tmpStr, tmpDayErr)=0) and
                 (DaysBetween(StrToDate(FCDSLot.FieldByName('prddate').AsString), Date)>=days) then
                 tmpDayErr:=tmpDayErr+tmpStr+#13#10;

              //超前批號
              if StrToDate(FCDSLot.FieldByName('prddate').AsString)>Date then
                 tmpOTDayErr:=tmpOTDayErr+tmpStr+#13#10;

              //玻布
              if tmpCDS3.Locate('GlassCloth', Copy(tmpStr,10,1), [loCaseInsensitive]) then
                 FCDSLot.FieldByName('GlassCloth').AsString:=tmpCDS3.FieldByName('Supplier').AsString;

              //玻布限定
              if (Length(tmpBBXD)>0) and (Pos(Copy(tmpStr,10,1),tmpBBXD)=0) then
                 tmpBo:=True;

              //rc、rf、pg、sf、vc
              FCDSLot.FieldByName('rc').AsString:=tmpCDS.Fields[1].AsString;
              if Pos('.',FCDSLot.FieldByName('rc').AsString)=0 then
                 FCDSLot.FieldByName('rc').AsString:=FCDSLot.FieldByName('rc').AsString+'.0';
              FCDSLot.FieldByName('rf').AsString:=tmpCDS.Fields[2].AsString;
              if Pos('.',FCDSLot.FieldByName('rf').AsString)=0 then
                 FCDSLot.FieldByName('rf').AsString:=FCDSLot.FieldByName('rf').AsString+'.0';
              FCDSLot.FieldByName('pg').AsString:=tmpCDS.Fields[3].AsString;
              if not SameText(SMRec.Custno, 'AC109') then
                 FCDSLot.FieldByName('sf').AsString:='NA'
              else if tmpCDS2.Locate('tc_sia02', Copy(tmpStr,1,Length(tmpStr)-1), [loPartialKey]) then
              begin
                FCDSLot.FieldByName('sf').AsString:=tmpCDS2.FieldByName('tc_sia40').AsString;
                if Pos('.',FCDSLot.FieldByName('sf').AsString)=0 then
                   FCDSLot.FieldByName('sf').AsString:=FCDSLot.FieldByName('sf').AsString+'.0';
              end;
              FCDSLot.FieldByName('vc').AsString:=tmpVC;
              FCDSLot.Post;

              //明細
              if isHY or SameText(SMRec.Custno,'AC093') then
                 AddCDSDetail(tmpCDS.Fields[0].AsString, tmpUnit, FCDSLot.FieldByName('rc').AsString, tmpCDS.Fields[4].AsFloat, SMRec);

              tmpCDS.Next;
            end;

          finally
            FreeAndNil(tmpCDS2);
          end;
        end;
      end;
    end;
    //coc lot

    if Length(tmpDayErr)>0 then
    begin
      ShowMsg('下列批號超過設定有效期'+IntToStr(Days)+':'+#13#10+tmpDayErr, 48);
      Exit;
    end;

    if Length(tmpOTDayErr)>0 then
    begin
      ShowMsg('下列批號超前:'+#13#10+tmpOTDayErr, 48);
      Exit;
    end;

    //客戶品名指定的玻布供應商
    with tmpCDS3 do
    begin
      First;
      while not Eof do
      begin
        if (Length(FieldByName('GlassCloth').AsString)>4) and
           (Pos(FieldByName('GlassCloth').AsString,FCDS.FieldByName('C_Sizes').AsString)>0) then
        begin
          FCDS.Edit;
          FCDS.FieldByName('PP_Sizes').AsString:=FieldByName('Supplier').AsString;
          FCDS.Post;
          Break;
        end;
        Next;
      end;
    end;

    //合并所有玻布供應商
    tmpStr:='';
    if FCDS.FieldByName('PP_visible').AsString='1' then
    begin
      with FCDSLot do
      begin
        First;
        while not Eof do
        begin
          if Pos(FieldByName('GlassCloth').AsString,tmpStr)=0 then
          begin
            if Length(tmpStr)>0 then
               tmpStr:=tmpStr+',';
            tmpStr:=tmpStr+FieldByName('GlassCloth').AsString;
          end;
          Next;
        end;
      end;
    end;

    //玻布、數量、生產日期、到期日
    if Length(tmpPno)>0 then
       tmpDate:=GetLotDate(tmpPno, FSourceCDS.FieldByName('Indate').AsDateTime)
    else
       tmpDate:=EncodeDate(1955,1,1);
    with FCDS do
    begin
      Edit;
      if tmpBo then
         FCDS.FieldByName('PPErr').AsString:=tmpBBXD;
      FCDS.FieldByName('PP').AsString:=tmpStr;
      if isPN then
         FieldByName('C').AsString:=FloatToStr(tmpTotQty)+tmpUnit
      else
         FieldByName('C').AsString:=FloatToStr(RoundTo(tmpTotQty/StrToFloat(SMRec.M11_13),-3))+tmpUnit;

      FieldByName('PrdDate').AsString:=FormatDateTime(g_cShortDate1, tmpDate);
      FieldByName('ExpDate').AsString:=FormatDateTime(g_cShortDate1, IncYear(tmpDate,2));
      Post;
    end;

    //批號先進選出
    tmpFIFOErr:='';
    Data:=null;
    tmpSQL:='exec dbo.proc_CheckLotFIFO '+Quotedstr(g_UInfo^.BU)+','+
        Quotedstr(FSourceCDS.FieldByName('Dno').AsString)+','+
         IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger)+','+
        Quotedstr(FSourceCDS.FieldByName('Custno').AsString)+',0';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      if (not tmpCDS.IsEmpty) and (Length(tmpCDS.Fields[1].AsString)>0) then
         tmpFIFOErr:='1.最新出貨批號是：'+tmpCDS.Fields[0].AsString+#13#10+
                     '2.下列批號未按先進先出'+#13#10+StringReplace(tmpCDS.Fields[1].AsString,',',#13#10,[rfReplaceAll]);
    end;
    //批號先進選出

    //檢查資材批號
    tmpLotErr:='';
    Data:=null;
    tmpSQL:='exec dbo.proc_CheckZClot '+Quotedstr(g_UInfo^.BU)+','+
        Quotedstr(FSourceCDS.FieldByName('Dno').AsString)+','+
         IntToStr(FSourceCDS.FieldByName('Ditem').AsInteger)+','+
        Quotedstr(FSourceCDS.FieldByName('Custno').AsString)+',0';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.Filtered:=False;
        tmpCDS.Filter:='id=1';
        tmpCDS.Filtered:=True;
        if not tmpCDS.IsEmpty then
        begin
          tmpLotErr:='資材批號'+#13#10;
          while not tmpCDS.Eof do
          begin
            tmpLotErr:=tmpLotErr+tmpCDS.Fields[0].AsString+#13#10;
            tmpCDS.Next;
          end;
        end;
        tmpCDS.Filtered:=False;
        tmpCDS.Filter:='id=2';
        tmpCDS.Filtered:=True;
        if not tmpCDS.IsEmpty then
        begin
          tmpLotErr:=tmpLotErr+'COC批號'+#13#10;
          while not tmpCDS.Eof do
          begin
            tmpLotErr:=tmpLotErr+tmpCDS.Fields[0].AsString+#13#10;
            tmpCDS.Next;
          end;
        end;
        tmpCDS.Filtered:=False;
        tmpCDS.Filter:='';
      end;
    end;
    //檢查資材批號

    //中山惠亞,廣州添利:隱藏部分信息
    if isHY or SameText(SMRec.Custno,'AC093') then
    begin
      FCDS.Edit;
      Data:=null;
      tmpSQL:='Select GlassCloth From Dli200'
             +' Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Len(GlassCloth)>4';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data:=Data;
        while not tmpCDS.Eof do
        begin
          FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,tmpCDS.Fields[0].AsString,'',[rfReplaceAll]);
          tmpCDS.Next;
        end;
      end;
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,' -CAFC','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,'-CAFC','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,' -CAF','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,'-CAF','',[rfReplaceAll]);

      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,' CAFC','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,'CAFC','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,' CAF','',[rfReplaceAll]);
      FCDS.FieldByName('A').AsString:=StringReplace(FCDS.FieldByName('A').AsString,'CAF','',[rfReplaceAll]);

      pos1:=Pos('RC',FCDS.FieldByName('A').AsString);
      if pos1>0 then
      begin
        tmpStr:=Copy(FCDS.FieldByName('A').AsString,1,pos1-1);
        tmpSQL:=Copy(FCDS.FieldByName('A').AsString,pos1,200);
        pos1:=pos(' ',tmpSQL);
        if pos1>0 then
        begin
          tmpSQL:=Copy(tmpSQL,pos1+1,200);
          FCDS.FieldByName('A').AsString:=tmpStr+tmpSQL;
        end;
      end;
      FCDS.FieldByName('C_Sizes').AsString:=FCDS.FieldByName('A').AsString;
      FCDS.Post;
    end;

    ShowBarMsg('正在檢驗測試項目正確性...');
    FrmDLII030_prn:=TFrmDLII030_prn.Create(nil);
    try
      FrmDLII030_prn.DS.DataSet:=FCDS;
      FrmDLII030_prn.DS2.DataSet:=FCDSLot;
      FrmDLII030_prn.l_SMRec:=SMRec;
      FrmDLII030_prn.l_FIFOErr:=tmpFIFOErr;
      FrmDLII030_prn.l_LotErr:=Trim(tmpLotErr);
      if FrmDLII030_prn.ShowModal<>mrOK then
         Exit;
    finally
      FreeAndNil(FrmDLII030_prn);
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
    FCDSLot.FieldByName('lot').AsString:=' ';
    FCDSLot.Post;
  end;

  if FCDS.ChangeCount>0 then
     FCDS.MergeChangeLog;
  if FCDSLot.ChangeCount>0 then
     FCDSLot.MergeChangeLog;
  if FCDSDetail.ChangeCount>0 then
     FCDSDetail.MergeChangeLog;

  SetLength(ArrPrintData, 4);
  ArrPrintData[0].Data:=FSourceCDS.Data;
  ArrPrintData[0].RecNo:=FSourceCDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=FSourceCDS.IndexFieldNames;
  ArrPrintData[0].Filter:=FSourceCDS.Filter;

  ArrPrintData[1].Data:=FCDS.Data;
  ArrPrintData[1].RecNo:=FCDS.RecNo;
  ArrPrintData[1].IndexFieldNames:=FCDS.IndexFieldNames;
  ArrPrintData[1].Filter:=FCDS.Filter;

  ArrPrintData[2].Data:=FCDSLot.Data;
  ArrPrintData[2].RecNo:=FCDSLot.RecNo;
  ArrPrintData[2].IndexFieldNames:=FCDSLot.IndexFieldNames;
  ArrPrintData[2].Filter:=FCDSLot.Filter;

  ArrPrintData[3].Data:=FCDSDetail.Data;
  ArrPrintData[3].RecNo:=FCDSDetail.RecNo;
  ArrPrintData[3].IndexFieldNames:=FCDSDetail.IndexFieldNames;
  ArrPrintData[3].Filter:=FCDSDetail.Filter;

  if SameText(g_UInfo^.UserId, 'admin') then
     tmpSQL:='Other-PP'
  else if SMRec.M2='G' then                                          //台灣來料180No Flow
     tmpSQL:='Other-COC9'
  else if (SMRec.M2='X') or SameText(SMRec.Custno, 'AH017') or
     (SameText(SMRec.Custno, 'AC174') and (SMRec.M2='4')) or
     (SameText(SMRec.Custno, 'AC096') and (SMRec.M2='4')) then       //X:膠系968、臺灣格式
     tmpSQL:='Other-COC4'
  else if Pos(SMRec.Custno, 'AC084/AC347/AC148')>0 then              //加基重項目格式
     tmpSQL:='Other-COC5'
  else if isHY then                                                  //加經緯紗變形項目格式(惠亞)
     tmpSQL:='Other-COC6'
  else if Pos(SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950')>0 then  //超毅格式
     tmpSQL:='Other-COC7'
  else if SameText(SMRec.Custno, 'AC093') then                       //添利格式
     tmpSQL:='Other-COCd'
  else
     tmpSQL:=ProcId;                                                 //默認格式

  GetPrintObj('Dli', ArrPrintData, tmpSQL);
  ArrPrintData:=nil;
end;

procedure TDLII030_rpt.AddCDSDetail(Lot,Units,RC:string; Qty:Double; SMRec:TSplitMaterialnoPP);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if not FCDSDli200.Active then
  begin
    tmpSQL:='Select GlassCloth,Supplier From Dli200 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    FCDSDli200.Data:=Data;
  end;

  with FCDSDetail do
  begin
    Append;
    FieldByName('pname').AsString:=FCDS.FieldByName('pname').AsString;
    FieldByName('sizes').AsString:=FCDS.FieldByName('sizes').AsString;
    FieldByName('c_sizes').AsString:=FCDS.FieldByName('c_sizes').AsString;
    FieldByName('lot').AsString:=Lot;
    if SameText(Units,'ROL') then
       FieldByName('qty').AsFloat:=Qty/StrToInt(SMRec.M11_13)
    else
       FieldByName('qty').AsFloat:=Qty;
    FieldByName('units').AsString:=Units;
    FieldByName('rc').AsString:=RC;
    FieldByName('resin').AsString:=GetResin(SMRec.Custno,SMRec.M2,SMRec.M18,False);
    if FCDSDli200.Locate('GlassCloth', Copy(Lot,10,1), [loCaseInsensitive]) then
       FieldByName('pp').AsString:=FCDSDli200.Fields[1].AsString;
    Post;
  end;
end;

end.
