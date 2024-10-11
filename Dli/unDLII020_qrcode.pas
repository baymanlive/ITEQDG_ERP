unit unDLII020_qrcode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, dialogs, unSTDI051, StdCtrls, ImgList,
  Buttons, ExtCtrls, DB, DBClient, StrUtils, DateUtils, Math, TWODbarcode;

type
  TArrLotQty = record
    Lot: string;
    Qty: Double;
  end;

type
  TFrmDLII020_qrcode = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    rb1: TRadioButton;
    rb2: TRadioButton;
    rb3: TRadioButton;
    Edit3: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure rb3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_ORADB, l_Custno: string;
    l_isSG, l_isCD: Boolean;
    l_CDS, l_CDSLot, l_CDSRemark: TClientDataSet;
    function CheckEdit(var xDno: string; var xDitem: Integer; var xNum: Integer): Boolean;
    procedure SetCtrlVisible;
    function SetCDSLot(xDno: string; xDitem: Integer; xIsCOC, xIsCDPP: Boolean; var xTotQty: Double): Boolean;
    function GetOAO06(xOrderno: string; xOrderitem: Integer): string;
    function GetPnoKG(xORACDS: TClientDataSet): Double;
    function GetSPEC(xORACDS: TClientDataSet): string;
    procedure AC096_KB;
    function AddData(xORACDS: TClientDataSet; xLot: string; xQty: Double; xRecno, xKgdeci, xTotkgdeci: Integer): Boolean;
    function GetQRCode(var xImgPath, xKB: string): Boolean;
    function SH_QRCode(var xImgPath, xKB: string): Boolean;
    function JY_QRCode(var xImgPath: string): Boolean;
    function AC101_QRCode(var xImgPath: string): Boolean;
    function SN_QRCode(var xImgPath, xKB: string): Boolean;
    function AC436_QRCode(var xImgPath, xKB: string): Boolean;
    function MY_QRCode(var xImgPath, xKB: string): Boolean;
//    function MY_QRCodeStr: string;
    function AC148_QRCode(var xImgPath, xKB: string): Boolean;
    function HT_QRCode(var xImgPath, xKB: string): Boolean;
    function MR_QRCode(var xImgPath, xKB: string): Boolean;
    function MX_QRCode(var xImgPath, xKB: string): Boolean;
    function SY_QRCode(var xImgPath, xKB: string): Boolean;
    function AC552_QRCode(var xImgPath, xKB: string): Boolean;   
    function JS_QRCode(var xImgPath, xKB: string): Boolean;
    function AC051_QRCode(var xImgPath, xKB: string): Boolean;
    function SG_QRCode(var xImgPath, xKB: string): Boolean;
    function CY_QRCode(var xImgPath, xKB: string): Boolean;
    function SL_QRCode(var xImgPath, xKB: string): Boolean;
    function JW_QRCode(var xImgPath, xKB: string): Boolean;
    function CD_QRCode(var xImgPath, xKB: string): Boolean;
    function YD_QRCode(var xImgPath, xKB: string): Boolean;
    function AC100_QRCode(var xImgPath, xKB: string): Boolean;
    function ACD60_QRCode(var xImgPath, xKB: string): Boolean;
    function MW_QRCode(var xImgPath, xKB: string): Boolean;
    function LN_QRCode(var xImgPath, xKB: string): Boolean;
    function ZJ_QRCode(var xImgPath, xKB: string): Boolean;
    function ZF_QRCode(var xImgPath, xKB: string): Boolean;
    function JLS_QRCode(var xImgPath, xKB: string): Boolean;
    function AC052_AC071_QRCode(var xImgPath, xKB: string): Boolean;
    function AC145_QRCode(var xImgPath, xKB: string): Boolean;
    function KX_QRCode(var xImgPath, xKB: string; xCustno: string): Boolean;
    procedure UpdateJxDs(ds: TDataSet);
    procedure GetRemarks(tmpDno, tmpDitem: string);
    { Private declarations }
  public
    Fm_image: PTIMAGESTRUCT;
    { Public declarations }
  end;

var
  FrmDLII020_qrcode: TFrmDLII020_qrcode;

implementation

uses
  unGlobal, unCommon, unDLII020_const;

const
  l_diff = 0.000001;

{$R *.dfm}
function GBToBIG5(GBStr: string): AnsiString;
var
  Len: integer;
  pGBCHTChar: PChar;
  pGBCHSChar: PChar;
begin
  pGBCHSChar := PChar(GBStr);
  Len := MultiByteToWideChar(936, 0, pGBCHSChar, -1, Nil, 0);
  GetMem(pGBCHTChar, Len * 2 + 1);
  ZeroMemory(pGBCHTChar, Len * 2 + 1);
  LCMapString($804, LCMAP_TRADITIONAL_CHINESE, pGBCHSChar, -1, pGBCHTChar, Len * 2);
  result := string(pGBCHTChar);
  FreeMem(pGBCHTChar);
end;
//�ˬd��J���

function TFrmDLII020_qrcode.CheckEdit(var xDno: string; var xDitem: Integer; var xNum: Integer): Boolean;
var
  tmpDno: string;
  tmpDitem, tmpNum: Integer;
begin
  Result := False;

  tmpDitem := 0;
  tmpNum := 0;
  tmpDno := Trim(Edit1.Text);
  if (Length(tmpDno) = 0) then// <> 10) or (Copy(tmpDno, 4, 1) <> '-') then
  begin
    ShowMsg('�п�J[%s]', 48, myStringReplace(Label1.Caption));
    Edit1.SetFocus;
    Exit;
  end;

  if rb2.Checked or rb3.Checked then
  begin
    tmpDitem := StrToIntDef(Trim(Edit2.Text), 0);
    if tmpDitem < 1 then
    begin
      ShowMsg('�п�J[%s]', 48, myStringReplace(Label2.Caption));
      Edit2.SetFocus;
      Exit;
    end;

    if rb3.Checked then
    begin
      tmpNum := StrToIntDef(Trim(Edit3.Text), 0);
      if tmpNum < 1 then
      begin
        ShowMsg('�п�J[%s]', 48, myStringReplace(Label3.Caption));
        Edit3.SetFocus;
        Exit;
      end;
    end;
  end;

  xDno := tmpDno;
  xDitem := tmpDitem;
  xNum := tmpNum;
  Result := True;
end;

//�������󪬺A
procedure TFrmDLII020_qrcode.SetCtrlVisible;
begin
  if rb1.Checked then
  begin
    Label2.Visible := False;
    Label3.Visible := False;
    Label4.Visible := False;
    Edit2.Visible := False;
    Edit3.Visible := False;
    Memo1.Visible := False;
    BitBtn1.Visible := False;
  end
  else if rb2.Checked then
  begin
    Label2.Visible := True;
    Label3.Visible := True;
    Label4.Visible := True;
    Edit2.Visible := True;
    Edit3.Visible := False;
    Memo1.Visible := True;
    BitBtn1.Visible := True;
    Label3.Caption := CheckLang('�帹,�ƶq:');
  end
  else  //rb3.Checked
  begin
    Label2.Visible := True;
    Label3.Visible := True;
    Label4.Visible := False;
    Edit2.Visible := True;
    Edit3.Visible := True;
    Memo1.Visible := False;
    BitBtn1.Visible := False;
    Label3.Caption := CheckLang('�d�O�ƶq:');
  end
end;

//���帹
function TFrmDLII020_qrcode.SetCDSLot(xDno: string; xDitem: Integer; xIsCOC, xIsCDPP: Boolean; var xTotQty: Double):
  Boolean;
var
  i, tmpPos: Integer;
  tmpQty: Double;
  tmpSQL, tmpStr, tmpLot: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Result := False;

  xTotQty := 0;
  with l_CDSLot do
  begin
    Filtered := False;
    Filter := '';
    IndexFieldNames := '';
    EmptyDataSet;
  end;

  if rb2.Checked then
  begin
    if Memo1.Lines.Count = 0 then
    begin
      ShowMsg('�п�J[%s]', 48, myStringReplace(Label3.Caption));
      Memo1.SetFocus;
      Exit;
    end;

    if Memo1.Lines.Count > 50 then
    begin
      ShowMsg('[%s]����j�_50��!', 48, myStringReplace(Label3.Caption));
      Memo1.SetFocus;
      Exit;
    end;

    for i := 0 to Memo1.Lines.Count - 1 do
    begin
      tmpStr := Trim(Memo1.Lines[i]);
      tmpPos := Pos(',', tmpStr);
      if tmpPos > 0 then
      begin
        tmpLot := LeftStr(tmpStr, tmpPos - 1);
        tmpQty := StrToFloatDef(Copy(tmpStr, tmpPos + 1, 30), 0);
      end
      else
      begin
        tmpLot := '';
        tmpQty := 0;
      end;

      if (Length(tmpLot) = 0) or (tmpQty <= 0) then
      begin
        ShowMsg('[%s]��' + IntToStr(i + 1) + '��榡���~,�Э��s��J!', 48, myStringReplace(Label3.Caption));
        Memo1.SetFocus;
        Exit;
      end;

      with l_CDSLot do
      begin
        Append;
        FieldByName('Saleno').AsString := xDno;
        FieldByName('Saleitem').AsInteger := xDitem;
        FieldByName('Lot').AsString := tmpLot;
        FieldByName('Qty').AsFloat := tmpQty;
        Post;
      end;

      xTotQty := xTotQty + tmpQty;
    end;

    if l_CDSLot.ChangeCount > 0 then
      l_CDSLot.MergeChangeLog;
    Result := True;
    Exit;
  end;

  //�H�Urb1.Checked
  if xIsCOC then
  begin
    //if xIsCDPP then

    //  tmpSQL := 'Select A.Saleno,A.Saleitem,substring(B.Manfac,1,5) Lot,' + ' Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) Qty' + ' From DLI010 A Inner Join DLI040 B' + ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' + ' Where A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' + Quotedstr(xDno) + ' Group By A.Saleno,A.Saleitem,substring(B.Manfac,1,5)' + ' Order By A.Saleno,A.Saleitem'
    //else
    tmpSQL := 'Select A.Saleno,A.Saleitem,B.Manfac Lot,' + ' Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) Qty' +
      ' From DLI010 A Inner Join DLI040 B' + ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' + ' Where A.Bu=' +
      Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' + Quotedstr(xDno) + ' Group By A.Saleno,A.Saleitem,B.Manfac' +
      ' Order By A.Saleno,A.Saleitem';
  end
  else
  begin
    //if xIsCDPP then

    //  tmpSQL := 'Select A.Saleno,A.Saleitem,substring(B.Manfac1,1,5) Lot,' + ' Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) Qty' + ' From DLI010 A Inner Join DLI020 B' + ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' + ' Where A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' + Quotedstr(xDno) + ' And IsNull(B.JFlag,0)=0' + ' Group By A.Saleno,A.Saleitem,substring(B.Manfac1,1,5)' + ' Order By A.Saleno,A.Saleitem'
    //else
    tmpSQL := 'Select A.Saleno,A.Saleitem,B.Manfac1 Lot,' + ' Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) Qty' +
      ' From DLI010 A Inner Join DLI020 B' + ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' + ' Where A.Bu=' +
      Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' + Quotedstr(xDno) + ' And IsNull(B.JFlag,0)=0' +
      ' Group By A.Saleno,A.Saleitem,B.Manfac1' + ' Order By A.Saleno,A.Saleitem';
  end;
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with l_CDSLot do
    begin
      while not tmpCDS.Eof do
      begin
        Append;
        FieldByName('Saleno').AsString := tmpCDS.FieldByName('Saleno').AsString;
        FieldByName('Saleitem').AsInteger := tmpCDS.FieldByName('Saleitem').AsInteger;
        FieldByName('Lot').AsString := tmpCDS.FieldByName('Lot').AsString;
        FieldByName('Qty').AsFloat := tmpCDS.FieldByName('Qty').AsFloat;
        Post;

        tmpCDS.Next;
      end;

      if ChangeCount > 0 then
        MergeChangeLog;
      if IsEmpty then
      begin
        ShowMsg('�L�帹���!', 48);
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;

  Result := True;
end;

//���q��ƪ`
function TFrmDLII020_qrcode.GetOAO06(xOrderno: string; xOrderitem: Integer): string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := '';

  Data := null;
  tmpSQL := 'select listagg(oao06,'','') within group (order by oao04) as oao06' + ' from oao_file where oao01=' +
    Quotedstr(xOrderno) + ' and oao03=' + IntToStr(xOrderitem) + ' group by oao01,oao03';
  if not QueryOneCR(tmpSQL, Data, l_ORADB) then
    Exit;
  if not VarIsNull(Data) then
    Result := VarToStr(Data);
end;



//�p��p�Ƴ歫
function TFrmDLII020_qrcode.GetPnoKG(xORACDS: TClientDataSet): Double;
var
  kg: Double;
  tmpStr, tmpPno: string;
begin
  kg := -1;
  tmpPno := xORACDS.FieldByName('ogb04').AsString;
  tmpStr := LeftStr(tmpPno, 1);
  if (((tmpStr = 'E') or (tmpStr = 'T')) and (Length(tmpPno) = 11)) or (((tmpStr = 'N') or (tmpStr = 'M')) and (Length(tmpPno)
    = 12)) then
    kg := GetKG(xORACDS.FieldByName('ogb01').AsString, xORACDS.FieldByName('ogb03').AsInteger, 0);

  if kg = -1 then
    Result := xORACDS.FieldByName('ima18').AsFloat
  else
    Result := kg;
end;

//�سqccl�p��spec
function TFrmDLII020_qrcode.GetSPEC(xORACDS: TClientDataSet): string;
var
  isHT: Boolean;
  tmpSQL, tmpPno: string;
  Data: OleVariant;
begin
  Result := '';

  tmpPno := xORACDS.FieldByName('ogb04').AsString;
  isHT := (Pos(xORACDS.FieldByName('oea04').AsString, g_strHT) > 0) and (Pos(LeftStr(tmpPno, 1), 'ET') > 0);
  if not isHT then
    Exit;

  tmpSQL := 'select tc_ocm03 from tc_ocm_file' + ' where tc_ocm01=' + Quotedstr(xORACDS.FieldByName('ta_oeb07').AsString);
  if not QueryOneCR(tmpSQL, Data, l_ORADB) then
    Exit;

  tmpSQL := VarToStr(Data);

  with xORACDS do
  begin
    if Length(tmpPno) in [11, 19] then
    begin
      if FieldByName('ta_oeb01').AsFloat > FieldByName('ta_oeb02').AsFloat then
        Result := FieldByName('ta_oeb01').AsString + '*' + FieldByName('ta_oeb02').AsString + '*L*' + tmpSQL
      else
        Result := FieldByName('ta_oeb01').AsString + '*' + FieldByName('ta_oeb02').AsString + '*S*' + tmpSQL;
    end
    else
      Result := FloatToStr(StrToFloat(Copy(tmpPno, 9, 3)) / 10) + '*' + FloatToStr(StrToFloat(Copy(tmpPno, 12, 3)) / 10)
        + '*S*1';
  end;
end;

procedure TFrmDLII020_qrcode.FormCreate(Sender: TObject);
begin
  inherited;
  GroupBox1.Caption := CheckLang('�C�L����');
  rb1.Caption := CheckLang('����i�X�f��');
  rb2.Caption := CheckLang('���X�f�涵���B�}���w�帹�M�ƶq');
  rb3.Caption := CheckLang('�W��PP��ñ');
  Edit3.Left := Memo1.Left;
  Edit3.Top := Memo1.Top;

  //�U�C�Ȥ��coc�帹
  l_Custno := g_strJS + 'AC148/ACE71/AC192/ACD05/AC552/AH027/AC436/AC204/AC051/ACE22/AC100/AC101/ACD36/AC096/AC178/AC152/AH036/ACA00/N024/' + g_strSN + '/'
    + g_strSH + '/' + g_strSY + '/' + g_strSG + '/' + g_strHT + '/' + g_strMR + '/' + g_strLN + '/' + g_strAC052_AC071 +
    '/' + g_strZJ + '/' + g_strZF + '/' + g_strCD + '/' + g_strCY + '/' + g_strJLS + '/' + g_strMW + '/' + g_strTL;

  if Pos('dg', LowerCase(g_UInfo^.BU)) > 0 then
    l_ORADB := 'ORACLE'
  else
    l_ORADB := 'ORACLE1';

  l_CDS := TClientDataSet.Create(nil);
  l_CDSLot := TClientDataSet.Create(nil);
  l_CDSRemark := TClientDataSet.Create(nil);
  InitCDS(l_CDS, g_QRCodeXml);
  InitCDS(l_CDSLot, g_lotxml);
  PtInitImage(@Fm_image);
end;

procedure TFrmDLII020_qrcode.FormShow(Sender: TObject);
begin
  inherited;
  rb1.Checked := True;
  SetCtrlVisible;
end;

procedure TFrmDLII020_qrcode.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
  FreeAndNil(l_CDSLot);
  FreeAndNil(l_CDSRemark);
  PtFreeImage(@Fm_image);
end;

procedure TFrmDLII020_qrcode.rb1Click(Sender: TObject);
begin
  inherited;
  SetCtrlVisible;
end;

procedure TFrmDLII020_qrcode.rb2Click(Sender: TObject);
begin
  inherited;
  SetCtrlVisible;
end;

procedure TFrmDLII020_qrcode.rb3Click(Sender: TObject);
begin
  inherited;
  SetCtrlVisible;
end;

procedure TFrmDLII020_qrcode.BitBtn1Click(Sender: TObject);
var
  tmpSQL, tmpDno: string;
  tmpDitem, tmpNum: Integer;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if not CheckEdit(tmpDno, tmpDitem, tmpNum) then
    Exit;                            
  {(*}
  tmpSQL := 'IF Exists(Select 1 From DLI010 Where Bu=' + Quotedstr(g_UInfo^.BU) +
            ' And Saleno=' + Quotedstr(tmpDno) + ' And SaleItem=' + IntToStr(tmpDitem) +
            ' And Charindex(Custno,' + Quotedstr(l_Custno) + ')+Charindex(Left(Remark,5),' +
            Quotedstr(l_Custno) + ')>0)' +
            ' Select B.Manfac ogb092,Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) ogb12' +
            ' From DLI010 A Inner Join DLI040 B On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' +
            ' Where A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' + Quotedstr(tmpDno) +
            ' And A.SaleItem=' + IntToStr(tmpDitem) + ' Group By B.Manfac Else '+
            ' Select B.Manfac1 ogb092,Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) ogb12' +
            ' From DLI010 A Inner Join DLI020 B' +
            ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' +
            ' Where A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.Saleno=' +
            Quotedstr(tmpDno) + ' And A.SaleItem=' + IntToStr(tmpDitem) +
            ' And IsNull(B.JFlag,0)=0' + ' Group By B.Manfac1';
  {*)}
  if QueryBySQL(tmpSQL, Data) then
  begin
    Memo1.Lines.Clear;
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      while not tmpCDS.Eof do
      begin
        Memo1.Lines.Add(tmpCDS.Fields[0].AsString + ',' + FloatToStr(tmpCDS.Fields[1].AsFloat));
        tmpCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII020_qrcode.btn_okClick(Sender: TObject);
var
  isCoc, isCDPP: Boolean;
  tmpDitem, tmpNum, kgdeci, totkgdeci, tmpRecno: Integer;
  tmpTotQty: Double;
  tmpSQL, tmpDno, tmpMaxLot, tmpLot_LN, tmpPrd_LN1, tmpPrd_LN2, tmpLst_LN1, tmpLst_LN2, tmpImgPath, tmpKB, tmpACC88:
    string;
  OraCDS, tmpCDS: TClientDataSet;
  Data: OleVariant;
  ArrPrintData: TArrPrintData;
begin
  //inherited;
  if rb3.Checked then
  begin
    AC096_KB;
    Exit;
  end;

  if not CheckEdit(tmpDno, tmpDitem, tmpNum) then
    Exit;

  GetRemarks(tmpDno, IntToStr(tmpDitem));

  if rb1.Checked then
    tmpSQL := ''
  else
    tmpSQL := ' and ogb03=' + IntToStr(tmpDitem);

  Data := null;
  {(*}
//  tmpSQL := 'select D.*,occ02,occ18 from (select C.*,ima02,ima021,ima18 from' +
//            ' (select B.*,oea04,oea10 from (select A.*,oeb11,ta_oeb01,ta_oeb02,ta_oeb07,ta_oeb10 from' +
//            ' (select ogapost,ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb12,ogb31,ogb32' +
//            ' from oga_file inner join ogb_file on oga01=ogb01' +
//            ' where ogb01=' + Quotedstr(tmpDno) + tmpSQL +
//            ') A inner join oeb_file on ogb31=oeb01 and ogb32=oeb03' +
//            ') B inner join oea_file on ogb31=oea01) C inner join ima_file on ima01=ogb04' +
//            ') D inner join occ_file on oea04=occ01 order by ogb01,ogb03';
  tmpSQL := 'select D.*,occ02,occ18 from (select C.*,ima02,ima021,ima18 from' +
            ' (select B.*,' +
            '(case when ta_oeb35 in (''AC121'',''ACG02'',''AC526'',''ACA97'',''AC820'',''AC305'',''ACD57'') then ta_oeb35 else oea04 end) oea04,'+
            ' oea10 from (select A.*, ' +
             '(case when ta_oeb35 in (''AC121'',''ACG02'',''AC526'',''ACA97'',''AC820'',''AC305'',''ACD57'') then ta_oeb36 else oeb11 end) oeb11,'+
            ' ta_oeb01,ta_oeb02,ta_oeb07,ta_oeb10,ta_oeb35,ta_oeb36 from' +
            ' (select ogapost,ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb12,ogb31,ogb32' +
            ' from oga_file inner join ogb_file on oga01=ogb01' +
            ' where ogb01=' + Quotedstr(tmpDno) + tmpSQL +
            ') A inner join oeb_file on ogb31=oeb01 and ogb32=oeb03' +
            ') B inner join oea_file on ogb31=oea01) C inner join ima_file on ima01=ogb04' +
            ') D inner join occ_file on oea04=occ01 order by ogb01,ogb03';
  {*)}
  if not QueryBySQL(tmpSQL, Data, l_ORADB) then
    Exit;
  OraCDS := TClientDataSet.Create(nil);
  tmpCDS := TClientDataSet.Create(nil);
  try
    OraCDS.Data := Data;

    if OraCDS.IsEmpty then
    begin
      if rb1.Checked then
        ShowMsg(tmpDno + '�X�f�椣�s�b!', 48)
      else
        ShowMsg(tmpDno + '/' + IntToStr(tmpDitem) + '�X�f�椣�s�b!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if OraCDS.FieldByName('ogapost').AsString <> 'Y' then
    begin
      ShowMsg(tmpDno + '�X�f�楼���b,���i�C�L!', 48);
      Edit1.SetFocus;
      Exit;
    end;
    UpdateJxDs(OraCDS);

    isCoc := Pos(OraCDS.FieldByName('oea04').AsString, l_custno) > 0;        //��COC�帹
    isCDPP := (Pos(OraCDS.FieldByName('oea04').AsString, g_strCD) > 0) and   //�R�FPP
      (Pos(LeftStr(OraCDS.FieldByName('ogb04').AsString, 1), 'ET') = 0);
    if not SetCDSLot(tmpDno, tmpDitem, isCoc, isCDPP, tmpTotQty) then
      Exit;

    //���w�帹+�ƶq:�ˬd�`�ƶq�P�X�f�ƶq
    //�s�{�p�Z�]�����i�h���x��,�X�f�涵���L�������t,���L�ˬd
    //�p��O�X�֪��帹�]���L�ˬd
    if rb2.Checked then
      if Pos(OraCDS.FieldByName('oea04').AsString, 'N012/' + g_strLN) = 0 then
        if Abs(tmpTotQty - OraCDS.FieldByName('ogb12').AsFloat) > l_diff then
        begin
          ShowMsg('�X�p�ƶq' + FloatToStr(tmpTotQty) + '<>�X�f�ƶq' + FloatToStr(OraCDS.FieldByName('ogb12').AsFloat),
            48);
          Memo1.SetFocus;
          Exit;
        end;

    //�歫,�`���p�Ʀ�
    Data := null;
    tmpSQL := 'exec dbo.proc_GetKGFormat ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(OraCDS.FieldByName('oea04').AsString);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    kgdeci := -tmpCDS.FieldByName('kgdeci').AsInteger;
    totkgdeci := -tmpCDS.FieldByName('totkgdeci').AsInteger;
    //�K�[��Ʀ�l_CDS
    OraCDS.First;
    l_CDSlot.First;
    l_CDS.EmptyDataSet;
    l_isSG := (Pos(OraCDS.FieldByName('oea04').AsString, g_strSG) > 0) or (Pos(LeftStr(tmpSQL, 5), g_strSG) > 0);
    l_isCD := (Pos(OraCDS.FieldByName('oea04').AsString, g_strCD) > 0) or (Pos(LeftStr(tmpSQL, 5), g_strCD) > 0);
    if rb1.Checked then
    begin
      if Length(OraCDS.FieldByName('oea04').AsString) = 4 then
        tmpSQL := GetOAO06(OraCDS.FieldByName('ogb31').AsString, OraCDS.FieldByName('ogb32').AsInteger)
      else
        tmpSQL := '';


      //�T�s�B�ͯq�B�R�F�B�`�n�B�سq�B�̹y�B�����B���U�B�p��B�s�{�̧Q�w�F,�L�q��ޡB���ʡB���I�B�W�ݤ@�ӧ帹�@��
      if l_isSG or (Pos(OraCDS.FieldByName('oea04').AsString, '/ACA00/N024/' + g_strSY + '/' + g_strMY + '/' + g_strCD +
        '/' + g_strSN + '/' + g_strHT + '/' + g_strYD + '/' + g_strMW + '/' + g_strMR + '/' + g_strLN + '/' +
        g_strAC052_AC071 + '/' + g_strZJ + '/' + g_strZF + '/' + g_strCY + '/' + g_strJLS) > 0) then
      begin
        while not OraCDS.Eof do
        begin
          with l_CDSlot do
          begin
            Filtered := False;
            Filter := 'Saleno=' + Quotedstr(OraCDS.FieldByName('ogb01').AsString) + ' And Saleitem=' + IntToStr(OraCDS.FieldByName
              ('ogb03').AsInteger);
            Filtered := True;
            IndexFieldNames := 'Lot';
            if IsEmpty then
            begin
              ShowMsg(OraCDS.FieldByName('ogb01').AsString + '/' + IntToStr(OraCDS.FieldByName('ogb03').AsInteger) +
                '�L�帹���!', 48);
              Exit;
            end;

            while not Eof do
            begin
              if l_CDSlot.RecNo > 1 then
                tmpRecno := l_CDS.RecNo
              else
                tmpRecno := 0;
              if not AddData(OraCDS, FieldByName('Lot').AsString, FieldByName('Qty').AsFloat, tmpRecno, kgdeci,
                totkgdeci) then
                Exit;

              Next;
            end;
          end;

          OraCDS.Next;
        end;
      end
      else //�䥦���̤j�帹�B�`�ƶq
      begin
        while not OraCDS.Eof do
        begin
          tmpMaxLot := '';
          with l_CDSlot do
          begin
            Filtered := False;
            Filter := 'Saleno=' + Quotedstr(OraCDS.FieldByName('ogb01').AsString) + ' And Saleitem=' + IntToStr(OraCDS.FieldByName
              ('ogb03').AsInteger);
            Filtered := True;
            IndexFieldNames := 'Lot';
            if IsEmpty then
            begin
              ShowMsg(OraCDS.FieldByName('ogb01').AsString + '/' + IntToStr(OraCDS.FieldByName('ogb03').AsInteger) +
                '�L�帹���!', 48);
              Exit;
            end;

            while not Eof do
            begin
              if (tmpMaxLot = '') or (Copy(tmpMaxLot, 2, 4) < Copy(FieldByName('Lot').AsString, 2, 4)) then
                tmpMaxLot := FieldByName('Lot').AsString;
              Next;
            end;
          end;

          if not AddData(OraCDS, tmpMaxLot, OraCDS.FieldByName('ogb12').AsFloat, 0, kgdeci, totkgdeci) then
            Exit;

          OraCDS.Next;
        end;
      end;
    end
    else
    begin
      while not l_CDSlot.Eof do
      begin
        if l_CDS.RecordCount > 0 then
          tmpRecno := 1
        else
          tmpRecno := 0;
        if not AddData(OraCDS, l_CDSlot.FieldByName('Lot').AsString, l_CDSlot.FieldByName('Qty').AsFloat, tmpRecno,
          kgdeci, totkgdeci) then
          Exit;

        l_CDSlot.Next;
      end;
    end;
    //�p����ҭ��s�B�z�G�帹�B�ƶq�B�Ͳ�����B���Ĥ���������X�}
    if Pos(l_CDS.FieldByName('Custno').AsString, g_strLN) > 0 then
    begin
      tmpCDS.Filtered := False;
      tmpCDS.Filter := '';
      tmpCDS.Data := l_CDS.Data;
      tmpCDS.IndexFieldNames := 'Saleitem;PrdDate1';
      tmpCDS.First;

      OraCDS.Filtered := False;
      OraCDS.Filter := '';
      OraCDS.Data := l_CDS.Data;
      OraCDS.IndexFieldNames := 'Saleitem;PrdDate1';
      OraCDS.First;

      l_CDS.EmptyDataSet;

      tmpLot_LN := '';
      tmpPrd_LN1 := '';
      tmpPrd_LN2 := '';
      tmpLst_LN1 := '';
      tmpLst_LN2 := '';
      while not tmpCDS.Eof do
      begin
        OraCDS.RecNo := tmpCDS.RecNo;
        tmpNum := tmpCDS.FieldByName('Saleitem').AsInteger;

        tmpLot_LN := tmpLot_LN + tmpCDS.FieldByName('Lot').AsString + '(' + tmpCDS.FieldByName('Qty').AsString + ')' +
          #13#10;
        tmpPrd_LN1 := tmpPrd_LN1 + tmpCDS.FieldByName('PrdDate1').AsString + ',';
        tmpPrd_LN2 := tmpPrd_LN2 + tmpCDS.FieldByName('PrdDate2').AsString + #13#10;
        tmpLst_LN1 := tmpLst_LN1 + tmpCDS.FieldByName('LstDate1').AsString + ',';
        tmpLst_LN2 := tmpLst_LN2 + tmpCDS.FieldByName('LstDate2').AsString + #13#10;
        tmpCDS.Next;

        if tmpCDS.Eof or (tmpNum <> tmpCDS.FieldByName('Saleitem').AsInteger) then
        begin
          l_CDS.Append;
          for tmpNum := 0 to OraCDS.FieldCount - 1 do
            l_CDS.Fields[tmpNum].Value := OraCDS.Fields[tmpNum].Value;
          l_CDS.FieldByName('Lot').AsString := Trim(tmpLot_LN);
          l_CDS.FieldByName('PrdDate1').AsString := Copy(tmpPrd_LN1, 1, Length(tmpPrd_LN1) - 1);
          l_CDS.FieldByName('PrdDate2').AsString := StringReplace(Trim(tmpPrd_LN2), '-', '/', [rfReplaceAll]);
          l_CDS.FieldByName('LstDate1').AsString := Copy(tmpLst_LN1, 1, Length(tmpLst_LN1) - 1);
          l_CDS.FieldByName('LstDate2').AsString := StringReplace(Trim(tmpLst_LN2), '-', '/', [rfReplaceAll]);
          l_CDS.FieldByName('KG_old').Clear;
          l_CDS.FieldByName('KG').Clear;
          l_CDS.FieldByName('T_KG').Clear;
          l_CDS.FieldByName('KB').AsString := '@';
          l_CDS.FieldByName('Memo').AsString := tmpACC88;
          if not GetQRCode(tmpImgPath, tmpKB) then
          begin
            if l_CDS.State in [dsInsert, dsEdit] then
              l_CDS.Cancel;
            if l_CDS.ChangeCount > 0 then
              l_CDS.CancelUpdates;
            ShowMsg('���ͤG���X����,�Э���!', 48);
            Exit;
          end;
          l_CDS.FieldByName('QRcode').AsString := tmpImgPath;
          l_CDS.FieldByName('KB').AsString := tmpKB;
          l_CDS.Post;
          tmpLot_LN := '';
          tmpPrd_LN1 := '';
          tmpPrd_LN2 := '';
          tmpLst_LN1 := '';
          tmpLst_LN2 := '';
        end;
      end;
    end;
  finally
    FreeAndNil(OraCDS);
    FreeAndNil(tmpCDS);
  end;

  Memo1.Lines.Clear;
  l_CDS.MergeChangeLog;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data := l_CDS.Data;
  ArrPrintData[0].RecNo := l_CDS.RecNo;
  if Pos(l_CDS.FieldByName('custno').AsString, g_strMX) > 0 then       //�W��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC096')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strJS) > 0 then    //�N��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_ACB19')
  else if Pos(l_CDS.FieldByName('custno').AsString, 'AC101') > 0 then  //�v��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC101')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strSN) > 0 then  //�`�n
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC111')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strLN) > 0 then  //�p��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC072')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strCY) > 0 then  //�W��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC075')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strTL) > 0 then  //�K�Q
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC093')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strJY) > 0 then  //�@��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC715')
  else if Pos(l_CDS.FieldByName('custno').AsString, 'ACA00') > 0 then  //�@��
    GetPrintObj('Dli', ArrPrintData, 'QRCode_ACA00')
      //  else if Pos(l_CDS.FieldByName('custno').AsString, 'AC436') > 0 then  //���{�ձ�
//    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC436')
  else
    GetPrintObj('Dli', ArrPrintData, 'QRCode_def');
  ArrPrintData := nil;
end;

procedure TFrmDLII020_qrcode.AC096_KB;
var
  i, tmpNum, tmpDitem, tmpQRCodeSno: Integer;
  tmpSQL, tmpStr, tmpDno, tmpImgPath: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
  ArrPrintData: TArrPrintData;
begin
  if not CheckEdit(tmpDno, tmpDitem, tmpNum) then
    Exit;
  {(*}
  tmpSQL := 'select oga04,ogb04,occ02,occ18 from' +
    ' (select oga04,ogb04 from oga_file inner join ogb_file on oga01=ogb01' +
    ' inner join oeb_file on oeb01=ogb31 and oeb03=ogb32 ' +
    ' where ogb01=' + Quotedstr(tmpDno) +
    ' and ogb03=' + IntToStr(tmpDitem) + ') A inner join occ_file on oga04=occ01';
  {*)}
  if not QueryBySQL(tmpSQL, Data, l_ORADB) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('��ڤ��s�b!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if Pos(tmpCDS.FieldByName('oga04').AsString, g_strMX) = 0 then
    begin
      ShowMsg('���O[�W��]���,���i�C�L!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if Pos(LeftStr(tmpCDS.FieldByName('ogb04').AsString, 1), 'ET') > 0 then
    begin
      ShowMsg('���OPP�Ƹ�,���i�C�L!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    l_CDS.EmptyDataSet;
    i := 1;
    tmpQRCodeSno := GetQRCodeSno('AC096_', Date);
    if tmpQRCodeSno < 0 then
      Exit;
    while i <= tmpNum do
    begin
      tmpQRCodeSno := tmpQRCodeSno + 1;
      with l_CDS do
      begin
        Append;
        FieldByName('Saleno').AsString := tmpDno;
        FieldByName('Saleitem').AsInteger := tmpDitem;
        FieldByName('Custno').AsString := tmpCDS.FieldByName('oga04').AsString;
        FieldByName('Custabs').AsString := tmpCDS.FieldByName('occ02').AsString;
        FieldByName('Custom').AsString := tmpCDS.FieldByName('occ18').AsString;
        FieldByName('Pno').AsString := tmpCDS.FieldByName('ogb04').AsString;

        tmpSQL := '-KB' + RightStr('000' + IntToStr(tmpQRCodeSno), 4); //PP�d�O�s��
        if Pos(Copy(tmpDno, 1, 3), '232/23G/235/602') > 0 then
          tmpStr := 'AD002'
        else
          tmpStr := 'AD001';
        FieldByName('KB').AsString := tmpStr + tmpDno + tmpSQL;
        tmpSQL := 'DN:' + tmpDno + ',SM:' + tmpStr + ',KB:' + FieldByName('KB').AsString;
        tmpImgPath := g_UInfo^.TempPath + tmpDno + '@' + IntToStr(i) + '.bmp';
        if FileExists(tmpImgPath) then
          DeleteFile(tmpImgPath);
        if getcode(tmpSQL, tmpImgPath, Fm_image) then
          FieldByName('QRcode').AsString := tmpImgPath;
        Post;
      end;
      Inc(i);
    end;
    if not SetQRCodeSno('AC096_', Date, tmpQRCodeSno) then
      Exit;
  finally
    FreeAndNil(tmpCDS);
  end;

  l_CDS.MergeChangeLog;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data := l_CDS.Data;
  ArrPrintData[0].RecNo := l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData, 'QRCode_AC096_KB');
  ArrPrintData := nil;
end;

function TFrmDLII020_qrcode.AddData(xORACDS: TClientDataSet; xLot: string; xQty: Double; xRecno, xKgdeci, xTotkgdeci:
  Integer): Boolean;
var
  tmpOrderitem: Integer;
  tmpOAO06, tmpC_Orderno, tmpSPEC, tmpImgPath, tmpKB: string;
  tmpKG: Double;
begin
  Result := True;
  try
    if (l_isSG or (Pos(xORACDS.FieldByName('oea04').AsString, g_strSH + '/' + g_strSY) > 0)) and (xORACDS.FieldByName('ogb32').AsInteger
      > 100) then
      tmpOrderitem := StrToInt(RightStr(xORACDS.FieldByName('ogb32').AsString, 2))
    else
      tmpOrderitem := xORACDS.FieldByName('ogb32').AsInteger;

    if xRecno > 0 then
    begin
      l_CDS.RecNo := xRecno;
      tmpOAO06 := l_CDS.FieldByName('OAO06').AsString;
      tmpC_Orderno := l_CDS.FieldByName('C_Orderno').AsString;
      tmpKG := l_CDS.FieldByName('KG_old').AsFloat;
      tmpSPEC := l_CDS.FieldByName('SPEC').AsString;
    end
    else
    begin
      tmpOAO06 := GetOAO06(xORACDS.FieldByName('ogb31').AsString, tmpOrderitem);
      tmpC_Orderno := GetC_Orderno(xORACDS.FieldByName('oea04').AsString, xORACDS.FieldByName('oea10').AsString,
        tmpOAO06);
      tmpKG := RoundTo(GetPnoKG(xORACDS) + l_diff, xKgdeci);
      tmpSPEC := GetSPEC(xORACDS);
      if Length(tmpSPEC) = 0 then
        tmpSPEC := xORACDS.FieldByName('ta_oeb10').AsString;
    end;

    with l_CDS do
    begin
      Append;
      FieldByName('Saleno').AsString := xORACDS.FieldByName('ogb01').AsString;
      FieldByName('Saleitem').AsInteger := xORACDS.FieldByName('ogb03').AsInteger;
      FieldByName('Orderno').AsString := xORACDS.FieldByName('ogb31').AsString;
      FieldByName('Orderitem').AsInteger := tmpOrderitem;
      FieldByName('OldOrderitem').AsInteger := xORACDS.FieldByName('ogb32').AsInteger;
      FieldByName('Custno').AsString := xORACDS.FieldByName('oea04').AsString;
      FieldByName('Custabs').AsString := xORACDS.FieldByName('occ02').AsString;
      FieldByName('Custom').AsString := xORACDS.FieldByName('occ18').AsString;
      FieldByName('Pno').AsString := xORACDS.FieldByName('ogb04').AsString;
      FieldByName('Pname').AsString := xORACDS.FieldByName('ima02').AsString;
      FieldByName('Sizes').AsString := xORACDS.FieldByName('ima021').AsString;
      FieldByName('C_Orderno').AsString := tmpC_Orderno;
      FieldByName('C_Pno').AsString := xORACDS.FieldByName('oeb11').AsString;
      FieldByName('C_Sizes').AsString := xORACDS.FieldByName('ta_oeb10').AsString;
      if l_isSG and SameText(xORACDS.FieldByName('ogb05').AsString, 'RL') and  //�T�s PP���RL����M
        (Length(FieldByName('Pno').AsString) = 18) then
      begin
        FieldByName('Units').AsString := 'M';
        FieldByName('Qty').AsFloat := xQty * StrToInt(Copy(FieldByName('Pno').AsString, 11, 3));
      end
      else
      begin
        FieldByName('Units').AsString := xORACDS.FieldByName('ogb05').AsString;
        FieldByName('Qty').AsFloat := xQty;
      end;
//      if l_isSG then
//        FieldByName('Lot').AsString := Copy(xLot,1,10)
//      else
      FieldByName('Lot').AsString := xLot;
      FieldByName('PrdDate1').AsString := GetPrdDate1(FieldByName('Lot').AsString);         //YYYYMMDD
      FieldByName('PrdDate2').AsString := GetPrd_LstDate(FieldByName('PrdDate1').AsString); //YYYY-MM-DD
      FieldByName('LstDate1').AsString := GetLstDate1(Pos(LeftStr(FieldByName('Pno').AsString, 1), 'ET') = 0,
        FieldByName('PrdDate1').AsString); //YYYYMMDD
      FieldByName('LstDate2').AsString := GetPrd_LstDate(FieldByName('LstDate1').AsString); //YYYY-MM-DD
      FieldByName('KG_old').AsFloat := tmpKG;
      if SameText(FieldByName('Units').AsString, 'RL') and (Length(FieldByName('Pno').AsString) = 18) then
        FieldByName('KG').AsFloat := RoundTo(StrToInt(Copy(FieldByName('Pno').AsString, 11, 3)) * FieldByName('KG_old').AsFloat
          + l_diff, xKgdeci)
      else
        FieldByName('KG').AsFloat := RoundTo(xORACDS.FieldByName('ogb05_fac').AsFloat * FieldByName('KG_old').AsFloat +
          l_diff, xKgdeci);
      FieldByName('T_KG').AsFloat := RoundTo(FieldByName('Qty').AsFloat * FieldByName('KG').AsFloat + l_diff, xTotkgdeci);
      FieldByName('SPEC').AsString := tmpSPEC;
      FieldByName('OAO06').AsString := tmpOAO06;
      if not GetQRCode(tmpImgPath, tmpKB) then
      begin
        if l_CDS.State in [dsInsert, dsEdit] then
          l_CDS.Cancel;
        if l_CDS.ChangeCount > 0 then
          l_CDS.CancelUpdates;
        Result := False;
        ShowMsg('���ͤG���X����,�Э���!', 48);
        Exit;
      end;
      FieldByName('QRcode').AsString := tmpImgPath;
      FieldByName('KB').AsString := tmpKB;
      Post;
    end;
  except
    on ex: Exception do
    begin
      ShowMsg(ex.Message);
      if l_CDS.State in [dsInsert, dsEdit] then
        l_CDS.Cancel;
      if l_CDS.ChangeCount > 0 then
        l_CDS.CancelUpdates;
      Result := False;
    end;
  end;
end;

//���ͤG���X,��^�Ϥ����|�B�d�O�s��
function TFrmDLII020_qrcode.GetQRCode(var xImgPath, xKB: string): Boolean;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if Pos(l_CDS.FieldByName('Custno').AsString, g_strSH) > 0 then       //�ӧ�(�ӵ�)
    Result := SH_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSN) > 0 then  //�`�n
    Result := SN_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMY) > 0 then  //����
    Result := MY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC148') > 0 then  //AC148
    Result := AC148_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC436,ACA79') > 0 then  //���{�ձ�  //�b��
    Result := AC436_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strHT) > 0 then  //�سq
    Result := HT_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMR) > 0 then  //���U
    Result := MR_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMX) > 0 then  //�W��
    Result := MX_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSY) > 0 then  //�ͯq
    Result := SY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC552') > 0 then  
    Result := AC552_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strJS) > 0 then  //�N��
    Result := JS_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC051,ACE22') > 0 then  //AC051
    Result := AC051_QRCode(xImgPath, xKB)
      //  else if (Pos('AC117', FRemark) > 0) or (Pos('ACC19', FRemark) > 0) then                                               //�T�s
//    Result := SG_JX_QRCode(xImgPath, xKB)
  else if l_isSG then                                               //�T�s
    Result := SG_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strCY) > 0 then  //�W��
    Result := CY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSL) > 0 then  //�`�p
    Result := SL_QRCode(xImgPath, xKB)
  else if (Pos(l_CDS.FieldByName('Custno').AsString, g_strJW) > 0) or SameText(l_CDS.FieldByName('Custno').AsString,
    'N024') then  //�`�`����
    Result := JW_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strCD) > 0 then  //�R�F
    Result := CD_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strYD) > 0 then  //�̹y
    Result := YD_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC100,AC087') > 0 then  //AC100,AC087
    Result := AC100_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'ACD60') > 0 then
    Result := ACD60_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strKX) > 0 then  //�쵾
    Result := KX_QRCode(xImgPath, xKB, l_CDS.FieldByName('Custno').AsString)
  else if (Pos(l_CDS.FieldByName('Custno').AsString, g_strMW) > 0) or (Pos(l_CDS.FieldByName('Custno').AsString, g_strTL)
    > 0) then  //����   �K�Q
    Result := MW_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strLN) > 0 then  //�p��
    Result := LN_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strAC052_AC071) > 0 then  //�p��
    Result := AC052_AC071_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC145') > 0 then  //�����H
    Result := AC145_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strZJ) > 0 then  //����
    Result := ZJ_QRCode(xImgPath, xKB)//  else if Pos(l_CDS.FieldByName('Custno').AsString,g_strZHZJ)>0 then  //�]������
//     Result:=ZHZJ_QRCode(xImgPath,xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strZF) > 0 then  //���I
    Result := ZF_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strJLS) > 0 then //�ҧQ�h
    Result := JLS_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strjy) > 0 then //�T��
    Result := JY_QRCode(xImgPath)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC101') > 0 then //�v��
    Result := AC101_QRCode(xImgPath);
end;

//�ӧ�(�ӵ�):L0001,�Ȥ�PO,PO����,�Ȥ�Ƹ�,�Ͳ����,�ƶq,�帹,�Ƶ�,���L��,���q,ITEQ
function TFrmDLII020_qrcode.SH_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, cl, sno: string;
  qty: double;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
//  if Pos(Copy(l_CDS.FieldByName('pno').AsString, 1, 1), 'RB') > 0 then
//    qty := l_CDS.FieldByName('Qty').AsFloat / StrToInt(Copy(l_CDS.FieldByName('Pno').AsString, 11, 3))
//  else

  qty := l_CDS.FieldByName('Qty').AsFloat;
  try
//    if (Pos(Copy(l_CDS.FieldByName('pno').AsString, 1, 1), 'RBMN') > 0) and (l_CDS.FieldByName('Qty').AsFloat > 1) then
//    begin
//      raise Exception.Create('�ӧ�PP�ƶq����j��1');
//    end;
    if Pos(Copy(l_CDS.FieldByName('pno').AsString, 2, 1), '6FQXENG') > 0 then
      cl := 'Y'
    else
      cl := 'N';
    sno := GetSno('DLII020');
    cl := cl + copy(sno, Length(sno) - 2, 3);
    with l_CDS do
      tmpStr := 'L0001,' + FieldByName('C_Orderno').AsString + ',' + FieldByName('Orderitem').AsString + ',' +
        FieldByName('C_Pno').AsString + ',' + FieldByName('PrdDate1').AsString + ',' + FloatToStr(qty) + ',' +
        FieldByName('Lot').AsString;     {*)}
//    if Pos(Copy(l_CDS.FieldByName('Pno').AsString, 1, 1), 'ET') > 0 then
    tmpStr := tmpStr + '_' + copy(sno, Length(sno) - 2, 3);
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�@��
function TFrmDLII020_qrcode.JY_QRCode(var xImgPath: string): Boolean;
var
  tmpSQL, tmpImgPath, sn: string;
  data: OleVariant;
begin
  Result := True;
  xImgPath := '';

  try
    tmpSQL := 'exec proc_GetLBLSno ' + Quotedstr(g_uinfo^.BU) + ',' + Quotedstr('ACC88');
    if QueryBySQL(tmpSQL, data) then
      sn := VarToStr(data);

    tmpSQL := g_uinfo.BU + ',' + l_cds.FieldByName('C_Pno').AsString + ',' + sn;

    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpSQL, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;


//�v��   �Ȥ�q��渹�F�ȤᲣ�~�s���F�ƶq�F�Ͳ��帹�F�Ͳ����
function TFrmDLII020_qrcode.AC101_QRCode(var xImgPath: string): Boolean;
var
  tmpSQL, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';

  try
    {(*}
    with l_CDS do
      tmpSQL := FieldByName('C_Orderno').AsString + ';;' +  //��ޭn�D��Ӥ���
                FieldByName('C_Pno').AsString  + ';' +
                FieldByName('Qty').asstring   + ';' +
                FieldByName('Lot').AsString   + ';' +
                StringReplace(FieldByName('PrdDate2').AsString, '-', '/', [rfReplaceAll]);
    {*)}
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpSQL, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;


//���� �t�O(01:�`�`�W��;02�E������..),�e�f�渹,�����������ʧ妸��,�帹,�ƶq,�䭫,�Ͳ����,���Ĥ��,�p�]�ƶq
function TFrmDLII020_qrcode.MY_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpImgPath, oao06, plant: string;
  ls: TStrings;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  oao06 := GetOAO06(l_CDS.fieldbyname('orderno').AsString, l_CDS.fieldbyname('orderitem').AsInteger);
  if l_CDS.fieldbyname('custno').AsString = 'AC133' then
    plant := '01'
  else if l_CDS.fieldbyname('custno').AsString = 'ACA28' then
    plant := '02'
  else if l_CDS.fieldbyname('custno').AsString = 'ACE06' then
    plant := '03';
  ls := TStringList.create;
  ls.Delimiter := ',';
  try
    with l_CDS do
    begin
      ls.Add(plant);
      ls.Add(FieldByName('Saleno').AsString);
      ls.Add(oao06);
      ls.Add(FieldByName('Lot').AsString);
      ls.Add(FieldByName('Qty').asstring);
      ls.Add(FieldByName('kg').asstring);
      ls.Add(FieldByName('PrdDate2').asstring);
      ls.Add(FieldByName('LstDate2').asstring);
      ls.Add('');
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(ls.Text, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
  ls.free;
end;

//���� �t�O(01:�`�`�W��;02�E������..),�e�f�渹,�����������ʧ妸��,�帹,�ƶq,�䭫,�Ͳ����,���Ĥ��,�p�]�ƶq
//function TFrmDLII020_qrcode.MY_QRCodeStr: string;
//var
//   oao06, plant: string;
//  ls: TStrings;
//begin
//  Result := '';
//  oao06 := GetOAO06(l_CDS.fieldbyname('orderno').AsString, l_CDS.fieldbyname('orderitem').AsInteger);
//  if l_CDS.fieldbyname('custno').AsString = 'AC133' then
//    plant := '01'
//  else if l_CDS.fieldbyname('custno').AsString = 'ACA28' then
//    plant := '02'
//  else if l_CDS.fieldbyname('custno').AsString = 'ACE06' then
//    plant := '03';
//  ls := TStringList.create;
//  ls.Delimiter := ',';
//  try
//    with l_CDS do
//    begin
//      ls.Add(plant);
//      ls.Add(FieldByName('Saleno').AsString);
//      ls.Add(oao06);
//      ls.Add(FieldByName('Lot').AsString);
//      ls.Add(FieldByName('Qty').asstring);
//      ls.Add(FieldByName('kg').asstring);
//      ls.Add(FieldByName('PrdDate2').asstring);
//      ls.Add(FieldByName('LstDate2').asstring);
//      ls.Add('');
//    end;
//    result := ls.text;
//    ls.free;
//  except
//    ls.free;
//  end;
//end;


//�`�n:�Ȥ�Ƹ�+100660+�帹+�Ͳ����+���Ĥ��+�Ȥ�PO+�ƶq
function TFrmDLII020_qrcode.SN_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath,plant: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if (pos('AC111',l_CDS.FieldByName('OAO06').AsString)>0) AND
     (pos('JX-',l_CDS.FieldByName('OAO06').AsString)>0) then
  begin
     plant:='+202808+';
  end
  else
     plant:='+100660+';
  //JX-223-440130-1-AC111
  try
    with l_CDS do   {(*}
      tmpStr := FieldByName('C_Pno').AsString +
                plant+
                FieldByName('Lot').AsString + '+' +
                RightStr(FieldByName('PrdDate1').AsString, 6) + '+' +
                RightStr(FieldByName('LstDate1').AsString, 6) + '+' +
                FieldByName('C_Orderno').AsString + '+' +
                FloatToStr(FieldByName('Qty').AsFloat);      {*)}
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

function TFrmDLII020_qrcode.AC436_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
  sn: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  try
    sn := 'W' + LBLSno(l_CDS.FieldByName('Custno').AsString);
    with l_CDS do   {(*}
      tmpStr := FieldByName('C_Orderno').AsString + ',' +
                RightStr(FieldByName('PrdDate1').AsString,6) + ',' +
                sn + ',' +
                FieldByName('C_Pno').AsString + ',' +
                FieldByName('Lot').AsString + ',' +
                FieldByName('Qty').AsString;  {*)}
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

function TFrmDLII020_qrcode.AC148_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
  tmpDate: TDate;
  tmpQRCodeSno: Integer;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    tmpDate := Date;
    tmpQRCodeSno := GetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate);
    if tmpQRCodeSno < 0 then
    begin
      Result := False;
      Exit;
    end;

    tmpQRCodeSno := tmpQRCodeSno + 1;
    if not SetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate, tmpQRCodeSno) then
    begin
      Result := False;
      Exit;
    end;

    tmpStr := FormatDateTime(g_cShortDateYYMMDD, Date) + RightStr('000' + IntToStr(tmpQRCodeSno), 4);

    with l_CDS do
      tmpStr := FieldByName('C_Pno').AsString + '/' + FieldByName('Qty').AsString + '/' + FieldByName('PrdDate1').AsString
        + '/' + FieldByName('C_Orderno').AsString + '/' + tmpStr + '/' + FieldByName('Pno').AsString + '/' + FieldByName
        ('Lot').AsString + '/' + 'ITEQ' + '/DG/' + Trim(FieldByName('SPEC').AsString);
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�سq:VND:ITEQ,PO:�Ȥ�PO,PN:�Ȥ�Ƹ�,SPEC:SPEC(�Ȥ�~�W),LOT:�帹,MF:�Ͳ����,QTY:�ƶq���
function TFrmDLII020_qrcode.HT_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      tmpStr := Trim(FieldByName('Units').AsString);
      if SameText(tmpStr, 'PN') then
        tmpStr := 'PCS'
      else if SameText(tmpStr, 'SH') then
        tmpStr := 'SHT';
      tmpStr := 'VND:ITEQ,PO:' + FieldByName('C_Orderno').AsString + ',PN:' + FieldByName('C_Pno').AsString + ',SPEC:' +
        FieldByName('SPEC').AsString + ',LOT:' + FieldByName('Lot').AsString + ',MF:' + FieldByName('PrdDate1').AsString
        + ',QTY:' + FloatToStr(FieldByName('Qty').AsFloat) + tmpStr;
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//���U:�Ȥ�PO;LIMDZ;�Ȥ�Ƹ�pn;�ƶq;���;�帹;���Ĥ��;�c��;D/N�s��
function TFrmDLII020_qrcode.MR_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      if SameText(FieldByName('Units').AsString, 'PN') then
        tmpStr := 'PNL'
      else
        tmpStr := FieldByName('Units').AsString;
      tmpStr := FieldByName('C_Orderno').AsString + ';LIMDZ;' + FieldByName('C_Pno').AsString + ';' + FloatToStr(FieldByName
        ('Qty').AsFloat) + ';' + tmpStr + ';' + FieldByName('Lot').AsString + ';' + FieldByName('LstDate1').AsString +
        ';;';    //20240530�Ȥ�n�D���d�Ů�
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�W��:DN:�e�f�渹,SM:�p�Z�N��AD001|AD002,KB:�d�O�s��,M:�Ȥ�Ƹ�,BS:�帹,DM:�Ͳ����,DE:���Ĥ��,Q:�ƶq,
function TFrmDLII020_qrcode.MX_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpQRCodeSno: Integer;
  tmpStr, tmpStrX, tmpImgPath: string;
  tmpDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    tmpDate := Date;
    tmpQRCodeSno := GetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate);
    if tmpQRCodeSno < 0 then
    begin
      Result := False;
      Exit;
    end;

    tmpQRCodeSno := tmpQRCodeSno + 1;
    if not SetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate, tmpQRCodeSno) then
    begin
      Result := False;
      Exit;
    end;

    if Pos(Copy(l_CDS.FieldByName('Saleno').AsString, 1, 3), '232/23G/235/602') > 0 then //���P
      tmpStr := 'AD002'
    else
      tmpStr := 'AD001';
    tmpStrX := '-KB' + RightStr('000' + IntToStr(tmpQRCodeSno), 4); //�d�O�s��
    xKB := tmpStr + '-' + l_CDS.FieldByName('Saleno').AsString + tmpStrX;

    with l_CDS do
      tmpStr := 'DN:' + l_CDS.FieldByName('Saleno').AsString + ',SM:' + tmpStr + ',KB:' + xKB + ',M:' + FieldByName('C_Pno').AsString
        + ',BS:' + FieldByName('Lot').AsString + ',DM:' + FieldByName('PrdDate2').AsString + ',DE:' + FieldByName('LstDate2').AsString
        + ',Q:' + FloatToStr(FieldByName('Qty').AsFloat) + ',';
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�ͯq:GYS_QRCODE_CGSL01+�Ȥ�PO+�Ȥ�PO�����Z���[0+�Ȥ�Ƹ�+�ƶq+���+�Ͳ�����Z���[4�y����+�帹+���Ĥ��
function TFrmDLII020_qrcode.SY_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpQRCodeSno: Integer;
  tmpStr, tmpImgPath: string;
  tmpDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      tmpDate := EncodeDate(StrToInt(LeftStr(FieldByName('PrdDate1').AsString, 4)), StrToInt(Copy(FieldByName('PrdDate1').AsString,
        5, 2)), StrToInt(RightStr(FieldByName('PrdDate1').AsString, 2)));

      tmpQRCodeSno := GetQRCodeSno(FieldByName('Custno').AsString, tmpDate);
      if tmpQRCodeSno < 0 then
      begin
        Result := False;
        Exit;
      end;

      tmpQRCodeSno := tmpQRCodeSno + 1;
      if not SetQRCodeSno(FieldByName('Custno').AsString, tmpDate, tmpQRCodeSno) then
      begin
        Result := False;
        Exit;
      end;

      tmpStr := 'GYS_QRCODE_CGSL01+' + FieldByName('C_Orderno').AsString + '+' + FieldByName('Orderitem').AsString +
        '0+' + FieldByName('C_Pno').AsString + '+' + FloatToStr(FieldByName('Qty').AsFloat) + '+' + FieldByName('Units').AsString
        + '+' + RightStr(FieldByName('PrdDate1').AsString + RightStr('0000' + IntToStr(tmpQRCodeSno), 4), 10) + '+' +
        FieldByName('Lot').AsString + '+' + FieldByName('LstDate1').AsString;
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

function TFrmDLII020_qrcode.JS_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      tmpStr := FieldByName('C_Orderno').AsString + ',' + FieldByName('C_Pno').AsString + ',' + FieldByName('Lot').AsString
        + ',' + FieldByName('Qty').AsString + ',' + FieldByName('PrdDate1').AsString + ',' + FieldByName('SPEC').AsString
        + ',' + FieldByName('sizes').AsString;
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

function TFrmDLII020_qrcode.AC051_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
  mfgDate,expDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      mfgDate := GetLotDate(Copy(FieldByName('Lot').AsString, 2, 4), Date);
      if pos(copy(FieldByName('pno').AsString,1,1),'RBMN')>0 then
        expDate := IncMonth(mfgDate, 3) - 1
      else
        expDate := IncMonth(mfgDate, 24) - 1;
      tmpStr := FieldByName('C_Orderno').AsString + '$' + FieldByName('C_Pno').AsString + '$' + FieldByName('Qty').AsString
        + '$' + FieldByName('Lot').AsString + '$' + FieldByName('SPEC').AsString + '$' + FormatDateTime('MM/dd/yyyy',
        mfgDate) + '$' + FormatDateTime('MM/dd/yyyy', expdate) + '$' +
        FieldByName('Saleno').AsString + '$' + FieldByName('T_KG').AsString;
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�T�s:�Ȥ�PO#�Ȥ�PO����#�Ȥ�Ƹ�#�Ͳ����#���Ĥ��#�帹#���#�ƶq#�s�X�y����#�c��(�y����)
function TFrmDLII020_qrcode.SG_QRCode(var xImgPath, xKB: string): Boolean;
var
  s1, s2, tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    s1 := GetSno('SG_QRCodeX', 'ITEQDG');
    if SameText(l_CDS.FieldByName('Custno').AsString, 'ACC19') then
      s1 := 'B' + RightStr(s1, 9)
    else
      s1 := 'A' + RightStr(s1, 9);

    s2 := 'P' + RightStr(GetSno('SG_QRCode', 'ITEQDG'), 9);

    tmpStr := GetSno('SG_QRCode', 'ITEQDG');
    with l_CDS do
      tmpStr := FieldByName('C_Orderno').AsString + '#' + RightStr('000' + IntToStr(FieldByName('Orderitem').AsInteger *
        10), 4) + '#' + FieldByName('C_Pno').AsString + '#' + FieldByName('PrdDate2').AsString + '#' + FieldByName('LstDate2').AsString
        + '#' + FieldByName('Lot').AsString + '#' + FieldByName('Units').AsString + '#' + FloatToStr(FieldByName('Qty').AsFloat)
        + '#' + s1 + '#' + s2;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;



//�W��:�y����*�Ȥ�Ƹ�*���Ĥ��MMDDYY*�ƶq*�帹*�Ȥ�PO*�Ͳ����MMDDYY
function TFrmDLII020_qrcode.CY_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpQRCodeSno: Integer;
  tmpId, tmpStr, tmpImgPath, tmpD1, tmpD2: string;
  tmpDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    if SameText(l_CDS.FieldByName('Custno').AsString, 'AC075') then
      tmpId := 'Y'
    else if SameText(l_CDS.FieldByName('Custno').AsString, 'AC950') then
      tmpId := 'F'
    else if SameText(l_CDS.FieldByName('Custno').AsString, 'AC405') then
      tmpId := 'P'
    else if SameText(l_CDS.FieldByName('Custno').AsString, 'AC311') then
      tmpId := 'V'
    else if SameText(l_CDS.FieldByName('Custno').AsString, 'AC310') then
      tmpId := 'M'
    else
      Exit;

    tmpDate := Date;
    tmpQRCodeSno := GetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate);
    if tmpQRCodeSno < 0 then
    begin
      Result := False;
      Exit;
    end;

    tmpQRCodeSno := tmpQRCodeSno + 1;
    if not SetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate, tmpQRCodeSno) then
    begin
      Result := False;
      Exit;
    end;

    tmpId := tmpId + FormatDateTime('YYMMDD', Date) + 'RD0086' + RightStr('000' + IntToStr(tmpQRCodeSno), 4);
    tmpD1 := RightStr(l_CDS.FieldByName('PrdDate1').AsString, 4) + Copy(l_CDS.FieldByName('PrdDate1').AsString, 3, 2);
      //PrdDate1:YYYYMMDD
    tmpD2 := RightStr(l_CDS.FieldByName('LstDate1').AsString, 4) + Copy(l_CDS.FieldByName('LstDate1').AsString, 3, 2);
      //LstDate1:YYYYMMDD

    with l_CDS do
      tmpStr := tmpId + '*' + FieldByName('C_Pno').AsString + '*' + tmpD2 + '*' + FloatToStr(FieldByName('Qty').AsFloat)
        + '*' + FieldByName('Lot').AsString + '*' + FieldByName('C_Orderno').AsString + '*' + tmpD1;

    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;

    xKB := tmpId + ',' + tmpD1 + ',' + tmpD2;
  except
    Result := False;
  end;
end;

//�`�p:�Ȥ�PO#�Ȥ�Ƹ�#�Ͳ����#�帹#�ƶq#�t���Ƹ�
function TFrmDLII020_qrcode.SL_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpSQL, tmpImgPath, sn: string;
  Data: OleVariant;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
      tmpStr := FieldByName('C_Orderno').AsString + '#' + FieldByName('C_Pno').AsString + '#' + FieldByName('PrdDate2').AsString
        + '#' + FieldByName('Lot').AsString + '#' + FloatToStr(FieldByName('Qty').AsFloat);// + '#' + FieldByName('Pno').AsString;
    if l_CDS.FieldByName('Custno').AsString = 'AC204' then
    begin
      tmpSQL := 'exec proc_GetLBLSno ' + Quotedstr(g_uinfo^.BU) + ',' + Quotedstr('AC204');
      if QueryOneCR(tmpSQL, Data) then
        sn := VarToStr(Data);
      tmpStr := tmpStr + '#' + sn;
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�`�`����:�Ȥ�q�渹
function TFrmDLII020_qrcode.JW_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, qty: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if Pos(Copy(l_CDS.FieldByName('C_pno').AsString, 1, 1), 'ET') > 0 then
    qty := l_CDS.FieldByName('qty').AsString
  else
    qty := inttostr(Ceil(l_CDS.FieldByName('qty').AsFloat));
  try
    //tmpStr := l_CDS.FieldByName('C_Orderno').AsString;
    {(*}
    tmpStr := l_CDS.FieldByName('C_Orderno').AsString + ',' +
              l_CDS.FieldByName('C_pno').AsString + ',' +
              l_CDS.FieldByName('lot').AsString + ',' +
              qty + ',' +
              l_CDS.FieldByName('kg').AsString + ',' +
              l_CDS.FieldByName('PrdDate1').AsString;          {*)}
    if (Pos(l_CDS.FieldByName('Custno').AsString, 'ACA00') > 0) then
      xImgPath := tmpStr
    else
    begin
      tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
      if FileExists(tmpImgPath) then
        DeleteFile(tmpImgPath);
      if getcode(tmpStr, tmpImgPath, Fm_image) then
        xImgPath := tmpImgPath;
    end;
  except
    Result := False;
  end;
end;

{�R�F:
<a>�Ȥ�Ƹ�</a>
<b>�e�f�渹</b>
<c>����</c>
<d>�ƶq</d>
<e>���</e>
<f>�Ȥ�q��</f>
<g>���q</g>
<h>�Ͳ����</h>
<i>�L�����</i>
<j>�帹</j>}
function TFrmDLII020_qrcode.CD_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      if Pos(LeftStr(FieldByName('Pno').AsString, 1), 'ET') > 0 then
        tmpStr := 'PCS'
      else if Pos(LeftStr(FieldByName('Pno').AsString, 1), 'MN') > 0 then
        tmpStr := 'PN'
      else
        tmpStr := 'RL';                              
      {(*}
      tmpStr := '<z><a>' + FieldByName('C_Pno').AsString + '</a>' +
                '<b>' + FieldByName('Saleno').AsString + '</b>' +
                '<c>' + FieldByName('Saleitem').AsString + '</c>' +
                '<d>' + FloatToStr(FieldByName('Qty').AsFloat) + '</d>' +
                '<e>' + tmpStr + '</e>' +
                '<f>' + FieldByName('C_Orderno').AsString + '</f>' +
                '<g>' + FloatToStr(FieldByName('T_KG').AsFloat) + '</g>' +
                '<h>' + FieldByName('PrdDate2').AsString + '</h>' +
                '<i>' + FieldByName('LstDate2').AsString + '</i>' +
                '<j>' + FieldByName('Lot').AsString + '</j></z>';    {*)}
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�̹y:�e�f�渹;�Ȥ�PO;�Ȥ�Ƹ�;�ƶq;���q;�帹;�Ͳ����;���Ĥ��
function TFrmDLII020_qrcode.YD_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    if Pos(Copy(l_CDS.FieldByName('Saleno').AsString, 1, 3), '232/23G/235/602') > 0 then //���P
      tmpStr := 'Domestic sales'
    else
      tmpStr := 'Export';

    with l_CDS do
      tmpStr := FieldByName('Saleno').AsString + ';' + FieldByName('C_Orderno').AsString + ';' + FieldByName('C_Pno').AsString
        + ';' + FloatToStr(FieldByName('Qty').AsFloat) + ';' + FloatToStr(FieldByName('T_KG').AsFloat) + 'KG;' +
        FieldByName('Lot').AsString + ';' + FieldByName('PrdDate1').AsString + ';' + FieldByName('LstDate1').AsString +
        ';' + tmpStr;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;
//�t��ID(AD002),�Ȥ�Ƹ��A�帹�A��?����A�ƶq

function TFrmDLII020_qrcode.AC100_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
      tmpStr := 'AD002,' + FieldByName('C_Pno').AsString + ',' + FieldByName('Lot').AsString + ',' +
        //                FieldByName('C_Orderno').AsString + ','+
        StringReplace(FieldByName('PrdDate1').AsString, '/', '', [rfReplaceAll]) + ',' + FloatToStr(FieldByName('Qty').AsFloat);
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

function TFrmDLII020_qrcode.ACD60_QRCode(var xImgPath, xKB: string): Boolean;
var
  s: string;
  qty: double;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if Pos(Copy(l_CDS.FieldByName('pno').AsString, 1, 1), 'RB') > 0 then
    qty := l_CDS.FieldByName('Qty').AsFloat / StrToInt(Copy(l_CDS.FieldByName('Pno').AsString, 11, 3))
  else
    qty := l_CDS.FieldByName('Qty').AsFloat;
  s := l_CDS.FieldByName('C_Orderno').AsString + '#' +
       l_CDS.FieldByName('C_Pno').AsString + '#' +
       GetPrd_LstDate(l_CDS.FieldByName('PrdDate1').AsString) + '#' +
       GetPrd_LstDate(l_CDS.FieldByName('LstDate1').AsString) + '#' +
       l_CDS.FieldByName('lot').AsString + '#' +
       'ITEQ#' + FloatToStr(qty);
  l_CDS.FieldByName('QRCode2').asString := s;
end;

function TFrmDLII020_qrcode.KX_QRCode(var xImgPath, xKB: string; xCustno: string): Boolean;
var
  tmpStr, tmpImgPath, AC192str, sn: string;
  data: OleVariant;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if Pos(xCustno,g_strKx)>0 then   //???
  begin
    AC192str := l_CDS.FieldByName('C_Orderno').AsString + '&';
    tmpStr := 'exec proc_GetLBLSno ' + Quotedstr(g_uinfo^.BU) + ',' + Quotedstr(xCustno);
    if QueryOneCR(tmpStr, data) then
      sn := VarToStr(data);
  end
  else
    AC192str := '';
  try
      {(*}
    with l_CDS do tmpStr :=
        'G000603&' +
        AC192str +
        FieldByName('C_Pno').AsString +'&' +
        FieldByName('Lot').AsString +'&' +
        FieldByName('PrdDate1').AsString +'&' +
        FieldByName('LstDate1').AsString +'&' +
        FieldByName('Qty').AsString;     {*)}
    //if (xCustno = 'AC192') or (xCustno='ACD05') then
    tmpStr := tmpStr + '&' + sn;

    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//����:�Ȥ�po;�p�Z�N�X;�Ȥ�Ƹ�;�ƶq;���ʳ��(sheet);�帹;���Ĥ��;�c��(�ť�);�e�f�渹(�ť�)
function TFrmDLII020_qrcode.MW_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, s11: string;
  rq: Currency;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  if (l_CDS.FieldByName('Units').AsString = 'RL') then
  begin
    s11 := copy(l_CDS.FieldByName('Pno').AsString, 11, 3);
    if s11 = '200' then
      rq := l_CDS.FieldByName('Qty').AsFloat * 218
    else if s11 = '150' then
      rq := l_CDS.FieldByName('Qty').AsFloat * 164
    else if s11 = '300' then
      rq := l_CDS.FieldByName('Qty').AsFloat * 328
    else
      rq := 0;
    l_CDS.FieldByName('Qty').AsFloat := rq;
  end;
//  else
//    rq := l_CDS.FieldByName('Qty').AsFloat;
  try
    with l_CDS do
      tmpStr := FieldByName('C_Orderno').AsString + ';CIT01;' + FieldByName('C_Pno').AsString + ';' + l_CDS.FieldByName('Qty').asstring
        {FloatToStr(rq)}                                + ';Sheet;' + FieldByName('Lot').AsString + ';' + FieldByName('LstDate1').AsString
        + ';;';
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;
  //�p��:PO:�Ȥ�q�渹;PN:�ȤᲣ�~�Ƹ�;MN:�t���Ƹ�;LT:�帹�ƶq(�h��);PD:�Ͳ����(�h��);ED:���Ĥ��(�h��);NO:�y���X(YYMMDD????);

function TFrmDLII020_qrcode.LN_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpQRCodeSno: Integer;
  tmpStr, tmpImgPath: string;
  tmpDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    if not SameText(l_CDS.FieldByName('KB').AsString, '@') then
      Exit;

    tmpDate := Date;
    tmpQRCodeSno := GetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate);
    if tmpQRCodeSno < 0 then
    begin
      Result := False;
      Exit;
    end;

    tmpQRCodeSno := tmpQRCodeSno + 1;
    if not SetQRCodeSno(l_CDS.FieldByName('Custno').AsString, tmpDate, tmpQRCodeSno) then
    begin
      Result := False;
      Exit;
    end;

    tmpStr := FormatDateTime(g_cShortDateYYMMDD, Date) + RightStr('000' + IntToStr(tmpQRCodeSno), 4);

    with l_CDS do
      tmpStr := 'PO:' + FieldByName('C_Orderno').AsString + ';' + 'PN:' + FieldByName('C_Pno').AsString + ';' + 'MN:' +
        FieldByName('Pno').AsString + ';' + 'LT:' + StringReplace(FieldByName('Lot').AsString, #13#10, ',', [rfReplaceAll])
        + ';' + 'PD:' + FieldByName('PrdDate1').AsString + ';' + 'ED:' + FieldByName('LstDate1').AsString + ';' + 'NO:'
        + tmpStr + ';';
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�s�{�̧Q�w�F,�L�q���:�Ȥ�po$�Ȥ�Ƹ�$�ƶq$�Ȥ�~�W$�Ͳ����$���Ĥ��&�帹
function TFrmDLII020_qrcode.AC052_AC071_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, d1, d2: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      d1 := StringReplace(FieldByName('PrdDate2').AsString, '-', '/', [rfReplaceAll]);
      d1 := RightStr(d1, 5) + '/' + LeftStr(d1, 4);

      d2 := StringReplace(FieldByName('LstDate2').AsString, '-', '/', [rfReplaceAll]);
      d2 := RightStr(d2, 5) + '/' + LeftStr(d2, 4);

      tmpStr := FieldByName('C_Orderno').AsString + '$' + FieldByName('C_Pno').AsString + '$' + FloatToStr(FieldByName('Qty').AsFloat)
        + '$' + StringReplace(StringReplace(FieldByName('C_Sizes').AsString, '�t��', '', [rfReplaceAll]), '��', '', [rfReplaceAll])
        + '$' + d1 + '$' + d2 + '$' + FieldByName('Lot').AsString;
    end;

    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�����H:�Ȥ�po,�Ȥ�Ƹ�,�Ȥ�~�W,�帹,�ƶq,�Ͳ����,���Ĥ��
function TFrmDLII020_qrcode.AC145_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, d1, d2: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
    begin
      d1 := StringReplace(FieldByName('PrdDate2').AsString, '-', '/', [rfReplaceAll]);
      d1 := RightStr(d1, 5) + '/' + LeftStr(d1, 4);

      d2 := StringReplace(FieldByName('LstDate2').AsString, '-', '/', [rfReplaceAll]);
      d2 := RightStr(d2, 5) + '/' + LeftStr(d2, 4);                              
      {(*}
      tmpStr := FieldByName('C_Orderno').AsString + ',' +
                FieldByName('C_Pno').AsString + ',' +
                FieldByName('C_Sizes').AsString + ',' +
                FieldByName('Lot').AsString + ',' +
                FieldByName('Qty').AsString + ',' +
                d1 + ',' +
                d2;
      {*)}
    end;

    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//����:M:���ƽs��,BS:�帹,DM:�s�y���,DE:���Ĥ��,Q:�ƶq,PO:���ʳ渹,DN:�e�f�渹
function TFrmDLII020_qrcode.ZJ_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    with l_CDS do
      tmpStr := 'M:' + FieldByName('C_Pno').AsString + ',' + 'BS:' + FieldByName('Lot').AsString + ',' + 'DM:' +
        FieldByName('PrdDate2').AsString + ',' + 'DE:' + FieldByName('LstDate2').AsString + ',' + 'Q:' + FloatToStr(FieldByName
        ('Qty').AsFloat) + ',' + 'PO:' + FieldByName('C_Orderno').AsString + ',' + 'DN:' + FieldByName('Saleno').AsString;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;
//
////�]������ �q�渹,�e�f�渹
//function TFrmDLII020_qrcode.ZHZJ_QRCode(var xImgPath,xKB:string):Boolean;
//var
//  tmpStr,tmpImgPath:string;
//begin
//  Result:=True;
//  xImgPath:='';
//  xKB:='';
//
//  try
//    with l_CDS do
//      tmpStr:=FieldByName('C_Pno').AsString+','+FieldByName('Saleno').AsString;
//    tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'.bmp';
//    if FileExists(tmpImgPath) then
//       DeleteFile(tmpImgPath);
//    if getcode(tmpStr, tmpImgPath, Fm_image) then
//       xImgPath:=tmpImgPath;
//  except
//    Result:=False;
//  end;
//end;

//���I:�Ȥ�q�渹,�Ȥ�Ƹ�,�帹,�ƶq,�Ͳ����,�ߤ@�y����LM+8��~���+4��y����

function TFrmDLII020_qrcode.ZF_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpQRCodeSno: Integer;
  tmpStr, tmpImgPath: string;
  tmpDate: TDateTime;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    tmpDate := Date;
//    tmpQRCodeSno:=GetQRCodeSno(l_CDS.FieldByName('Custno').AsString,tmpDate);
    tmpQRCodeSno := GetQRCodeSno('AC136', tmpDate);
    if tmpQRCodeSno < 0 then
    begin
      Result := False;
      Exit;
    end;

    tmpQRCodeSno := tmpQRCodeSno + 1;
//    if not SetQRCodeSno(l_CDS.FieldByName('Custno').AsString,tmpDate,tmpQRCodeSno) then
    if not SetQRCodeSno('AC136', tmpDate, tmpQRCodeSno) then
    begin
      Result := False;
      Exit;
    end;

    tmpStr := 'LM' + FormatDateTime('YYYYMMDD', Date) + RightStr('000' + IntToStr(tmpQRCodeSno), 4);

    with l_CDS do
      tmpStr := FieldByName('C_Orderno').AsString + ',' + FieldByName('C_Pno').AsString + ',' + FieldByName('Lot').AsString
        + ',' + FieldByName('Qty').AsString + ',' + FieldByName('PrdDate2').AsString + ',' + tmpStr;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

//�ҧQ�h:�Ȥ�po;�p�Z�N�X;�Ȥ�Ƹ�;�ƶq;���ʳ��(sheet);�帹;���Ĥ��;�c��(�ť�);�e�f�渹(�ť�)
function TFrmDLII020_qrcode.JLS_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath, tmpId,s11,pno,qtystr: string;
  qty:double;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    if l_CDS.FieldByName('Units').AsString = 'RL' then
    begin
      pno:=l_CDS.FieldByName('pno').AsString;
      qty:=l_CDS.FieldByName('Qty').AsFloat;
      s11:=copy(pno,11,3);
      if s11='200' then
        qty:=qty*218
      else if s11='150' then
        qty:=qty*164
      else if s11='300' then
        qty:=qty*328
      else
        qty:=0;
      qtystr:=formatfloat('0',qty);
    end
    else
      qtystr:=FloatToStr(l_CDS.FieldByName('Qty').AsFloat);
    if Pos(LeftStr(l_CDS.FieldByName('pno').AsString, 1), 'RME') > 0 then //�~�PRME�B���PBNT
      tmpId := 'I029'
    else
      tmpId := 'LM03';

    with l_CDS do
      tmpStr := FieldByName('C_Orderno').AsString + ';' + tmpId + ';' + FieldByName('C_Pno').AsString + ';' +
        qtystr + ';Sheet;' + FieldByName('Lot').AsString + ';' + FieldByName('LstDate1').AsString
        + ';;';
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;

procedure TFrmDLII020_qrcode.UpdateJxDs(ds: TDataSet);
var
  tmpCds: TClientDataSet;
  data: OleVariant;
  dno, itm, sql, remark: string;
  custInfo:TCustInfo;
  idx: integer;
begin

  tmpCds := TClientDataSet.Create(nil);
  try

    ds.First;
    while not ds.Eof do
    begin
      if l_CDSRemark.Locate('Saleno;Saleitem', VarArrayOf([ds.FieldByName('ogb01').AsString, ds.FieldByName('ogb03').AsString]),
        []) then
      begin
        remark := l_CDSRemark.fieldbyname('Remark').AsString;
        if JxRemark(remark,custInfo) then
        begin
          ds.edit;
          ds.FieldByName('oea04').AsString := custInfo.No;// tmpCds.fieldbyname('oea04').asstring;
          ds.FieldByName('occ02').AsString :=custInfo.Name;// tmpCds.fieldbyname('occ02').asstring;
          ds.FieldByName('oea10').AsString :=custInfo.Po;// tmpCds.fieldbyname('oea10').asstring;
//          ds.FieldByName('C_Orderno').AsString:=custInfo.Po;
          ds.FieldByName('oeb11').AsString :=custInfo.PartNo;// tmpCds.fieldbyname('oeb11').asstring;
          if pos(custinfo.no,'AC111')=0 then
            ds.FieldByName('ogb32').AsInteger := custInfo.PoItm;
          if {'AC101'=custInfo.No} pos(custinfo.no,'AC101,AC111')>0 then
             ds.FieldByName('ta_oeb10').AsString := custInfo.PartName;// tmpCds.fieldbyname('ta_oeb10').asstring;
        end;

//        if (LeftStr(remark, 3) = 'JX-') and (pos(remark,'AC117/ACC19/AC101/ACD80' ) > 0) then
//        begin
//          dno := Copy(remark, 4, 10);
//          remark := copy(remark, 15, 10);
//          idx := pos('-', remark);
//          itm := Copy(remark, 1, idx - 1);
//          sql :=
//            'select oea04,occ02,oea10,oeb11,ta_oeb10 from iteqjx.oea_file,iteqjx.oeb_file,iteqjx.occ_file where oea01=oeb01 and oea04=occ01 and oea01=%s and oeb03=%s';
//          sql := Format(sql, [QuotedStr(dno), QuotedStr(itm)]);
//          if not QueryBySQL(sql, data, 'ORACLE') then
//            exit;
//          tmpCds.Data := data;
//          ds.edit;
//          ds.FieldByName('oea04').AsString := tmpCds.fieldbyname('oea04').asstring;
//          ds.FieldByName('occ02').AsString := tmpCds.fieldbyname('occ02').asstring;
//          ds.FieldByName('oea10').AsString := tmpCds.fieldbyname('oea10').asstring;
//          ds.FieldByName('oeb11').AsString := tmpCds.fieldbyname('oeb11').asstring;
//          ds.FieldByName('ogb32').AsString := itm;
//          if (pos('AC101', remark) > 0) then
//             ds.FieldByName('ta_oeb10').AsString := tmpCds.fieldbyname('ta_oeb10').asstring;
//        end;
      end;
      ds.next;
    end;
  finally
    tmpCds.Free;
  end;

end;

procedure TFrmDLII020_qrcode.GetRemarks(tmpDno, tmpDitem: string);
var
  data: OleVariant;
  tmpSQL: string;
begin
  if rb1.Checked then
    tmpSQL := ''
  else
    tmpSQL := ' and Saleitem=' + tmpDitem;
  tmpSQL := 'select Saleno,Saleitem,Remark from dli010 where bu=' + QuotedStr(g_uinfo^.BU) + ' and Saleno=' + QuotedStr(tmpDno)
    + tmpSQL;
  if QueryBySQL(tmpSQL, data) then
    l_CDSRemark.data := data;
end;

function TFrmDLII020_qrcode.AC552_QRCode(var xImgPath,
  xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';

  try
    with l_CDS do
    begin
      {(*}
      tmpStr := 'F00003;' +
                FieldByName('C_Pno').AsString+';'+
                FieldByName('C_Orderno').AsString+';'+
                FieldByName('Qty').AsString +';'+
                FieldByName('PrdDate2').AsString +';'+
                FieldByName('LstDate2').AsString +';'+
                FieldByName('Lot').AsString;
      {*)}
    end;
    tmpImgPath := g_UInfo^.TempPath + l_CDS.FieldByName('Saleno').AsString + '@' + IntToStr(l_CDS.RecordCount) + '.bmp';
    if FileExists(tmpImgPath) then
      DeleteFile(tmpImgPath);
    if getcode(tmpStr, tmpImgPath, Fm_image) then
      xImgPath := tmpImgPath;
  except
    Result := False;
  end;
end;


end.




