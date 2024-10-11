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
//檢查輸入欄位

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
    ShowMsg('請輸入[%s]', 48, myStringReplace(Label1.Caption));
    Edit1.SetFocus;
    Exit;
  end;

  if rb2.Checked or rb3.Checked then
  begin
    tmpDitem := StrToIntDef(Trim(Edit2.Text), 0);
    if tmpDitem < 1 then
    begin
      ShowMsg('請輸入[%s]', 48, myStringReplace(Label2.Caption));
      Edit2.SetFocus;
      Exit;
    end;

    if rb3.Checked then
    begin
      tmpNum := StrToIntDef(Trim(Edit3.Text), 0);
      if tmpNum < 1 then
      begin
        ShowMsg('請輸入[%s]', 48, myStringReplace(Label3.Caption));
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

//切換控件狀態
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
    Label3.Caption := CheckLang('批號,數量:');
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
    Label3.Caption := CheckLang('卡板數量:');
  end
end;

//取批號
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
      ShowMsg('請輸入[%s]', 48, myStringReplace(Label3.Caption));
      Memo1.SetFocus;
      Exit;
    end;

    if Memo1.Lines.Count > 50 then
    begin
      ShowMsg('[%s]不能大于50筆!', 48, myStringReplace(Label3.Caption));
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
        ShowMsg('[%s]第' + IntToStr(i + 1) + '行格式錯誤,請重新輸入!', 48, myStringReplace(Label3.Caption));
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

  //以下rb1.Checked
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
        ShowMsg('無批號資料!', 48);
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;

  Result := True;
end;

//取訂單備注
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



//計算小料單重
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

//華通ccl計算spec
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
  GroupBox1.Caption := CheckLang('列印類型');
  rb1.Caption := CheckLang('按整張出貨單');
  rb2.Caption := CheckLang('按出貨單項次、并指定批號和數量');
  rb3.Caption := CheckLang('名幸PP標簽');
  Edit3.Left := Memo1.Left;
  Edit3.Top := Memo1.Top;

  //下列客戶取coc批號
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
        ShowMsg(tmpDno + '出貨單不存在!', 48)
      else
        ShowMsg(tmpDno + '/' + IntToStr(tmpDitem) + '出貨單不存在!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if OraCDS.FieldByName('ogapost').AsString <> 'Y' then
    begin
      ShowMsg(tmpDno + '出貨單未扣帳,不可列印!', 48);
      Edit1.SetFocus;
      Exit;
    end;
    UpdateJxDs(OraCDS);

    isCoc := Pos(OraCDS.FieldByName('oea04').AsString, l_custno) > 0;        //取COC批號
    isCDPP := (Pos(OraCDS.FieldByName('oea04').AsString, g_strCD) > 0) and   //崇達PP
      (Pos(LeftStr(OraCDS.FieldByName('ogb04').AsString, 1), 'ET') = 0);
    if not SetCDSLot(tmpDno, tmpDitem, isCoc, isCDPP, tmpTotQty) then
      Exit;

    //指定批號+數量:檢查總數量與出貨數量
    //廣州聯茂因為不可多倉儲批,出貨單項次無對應關系,跳過檢查
    //聯能是合併的批號也跳過檢查
    if rb2.Checked then
      if Pos(OraCDS.FieldByName('oea04').AsString, 'N012/' + g_strLN) = 0 then
        if Abs(tmpTotQty - OraCDS.FieldByName('ogb12').AsFloat) > l_diff then
        begin
          ShowMsg('合計數量' + FloatToStr(tmpTotQty) + '<>出貨數量' + FloatToStr(OraCDS.FieldByName('ogb12').AsFloat),
            48);
          Memo1.SetFocus;
          Exit;
        end;

    //單重,總重小數位
    Data := null;
    tmpSQL := 'exec dbo.proc_GetKGFormat ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(OraCDS.FieldByName('oea04').AsString);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    kgdeci := -tmpCDS.FieldByName('kgdeci').AsInteger;
    totkgdeci := -tmpCDS.FieldByName('totkgdeci').AsInteger;
    //添加資料至l_CDS
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


      //三廣、生益、崇達、深南、華通、依頓、美維、美銳、聯能、廣州依利安達,微通科技、中京、中富、超毅一個批號一筆
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
                '無批號資料!', 48);
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
      else //其它取最大批號、總數量
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
                '無批號資料!', 48);
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
    //聯能標籤重新處理：批號、數量、生產日期、有效日期按項次合并
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
            ShowMsg('產生二維碼失敗,請重試!', 48);
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
  if Pos(l_CDS.FieldByName('custno').AsString, g_strMX) > 0 then       //名幸
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC096')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strJS) > 0 then    //杰賽
    GetPrintObj('Dli', ArrPrintData, 'QRCode_ACB19')
  else if Pos(l_CDS.FieldByName('custno').AsString, 'AC101') > 0 then  //競華
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC101')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strSN) > 0 then  //深南
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC111')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strLN) > 0 then  //聯能
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC072')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strCY) > 0 then  //超毅
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC075')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strTL) > 0 then  //添利
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC093')
  else if Pos(l_CDS.FieldByName('custno').AsString, g_strJY) > 0 then  //駿亞
    GetPrintObj('Dli', ArrPrintData, 'QRCode_AC715')
  else if Pos(l_CDS.FieldByName('custno').AsString, 'ACA00') > 0 then  //駿亞
    GetPrintObj('Dli', ArrPrintData, 'QRCode_ACA00')
      //  else if Pos(l_CDS.FieldByName('custno').AsString, 'AC436') > 0 then  //梅州博敏
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
      ShowMsg('單據不存在!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if Pos(tmpCDS.FieldByName('oga04').AsString, g_strMX) = 0 then
    begin
      ShowMsg('不是[名幸]單據,不可列印!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if Pos(LeftStr(tmpCDS.FieldByName('ogb04').AsString, 1), 'ET') > 0 then
    begin
      ShowMsg('不是PP料號,不可列印!', 48);
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

        tmpSQL := '-KB' + RightStr('000' + IntToStr(tmpQRCodeSno), 4); //PP卡板編號
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
      if l_isSG and SameText(xORACDS.FieldByName('ogb05').AsString, 'RL') and  //三廣 PP單位RL換成M
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
        ShowMsg('產生二維碼失敗,請重試!', 48);
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

//產生二維碼,返回圖片路徑、卡板編號
function TFrmDLII020_qrcode.GetQRCode(var xImgPath, xKB: string): Boolean;
begin
  Result := True;
  xImgPath := '';
  xKB := '';
  if Pos(l_CDS.FieldByName('Custno').AsString, g_strSH) > 0 then       //勝宏(勝華)
    Result := SH_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSN) > 0 then  //深南
    Result := SN_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMY) > 0 then  //明陽
    Result := MY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC148') > 0 then  //AC148
    Result := AC148_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC436,ACA79') > 0 then  //梅州博敏  //奔創
    Result := AC436_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strHT) > 0 then  //華通
    Result := HT_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMR) > 0 then  //美銳
    Result := MR_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strMX) > 0 then  //名幸
    Result := MX_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSY) > 0 then  //生益
    Result := SY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC552') > 0 then  
    Result := AC552_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strJS) > 0 then  //杰賽
    Result := JS_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC051,ACE22') > 0 then  //AC051
    Result := AC051_QRCode(xImgPath, xKB)
      //  else if (Pos('AC117', FRemark) > 0) or (Pos('ACC19', FRemark) > 0) then                                               //三廣
//    Result := SG_JX_QRCode(xImgPath, xKB)
  else if l_isSG then                                               //三廣
    Result := SG_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strCY) > 0 then  //超毅
    Result := CY_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strSL) > 0 then  //深聯
    Result := SL_QRCode(xImgPath, xKB)
  else if (Pos(l_CDS.FieldByName('Custno').AsString, g_strJW) > 0) or SameText(l_CDS.FieldByName('Custno').AsString,
    'N024') then  //深圳景旺
    Result := JW_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strCD) > 0 then  //崇達
    Result := CD_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strYD) > 0 then  //依頓
    Result := YD_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC100,AC087') > 0 then  //AC100,AC087
    Result := AC100_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'ACD60') > 0 then
    Result := ACD60_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strKX) > 0 then  //科翔
    Result := KX_QRCode(xImgPath, xKB, l_CDS.FieldByName('Custno').AsString)
  else if (Pos(l_CDS.FieldByName('Custno').AsString, g_strMW) > 0) or (Pos(l_CDS.FieldByName('Custno').AsString, g_strTL)
    > 0) then  //美維   添利
    Result := MW_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strLN) > 0 then  //聯能
    Result := LN_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strAC052_AC071) > 0 then  //聯能
    Result := AC052_AC071_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC145') > 0 then  //全成信
    Result := AC145_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strZJ) > 0 then  //中京
    Result := ZJ_QRCode(xImgPath, xKB)//  else if Pos(l_CDS.FieldByName('Custno').AsString,g_strZHZJ)>0 then  //珠海中京
//     Result:=ZHZJ_QRCode(xImgPath,xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strZF) > 0 then  //中富
    Result := ZF_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strJLS) > 0 then //皆利士
    Result := JLS_QRCode(xImgPath, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString, g_strjy) > 0 then //俊亞
    Result := JY_QRCode(xImgPath)
  else if Pos(l_CDS.FieldByName('Custno').AsString, 'AC101') > 0 then //競華
    Result := AC101_QRCode(xImgPath);
end;

//勝宏(勝華):L0001,客戶PO,PO項次,客戶料號,生產日期,數量,批號,備註,有無鹵,重量,ITEQ
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
//      raise Exception.Create('勝宏PP數量不能大於1');
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

//駿亞
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


//競華   客戶訂單單號；客戶產品編號；數量；生產批號；生產日期
function TFrmDLII020_qrcode.AC101_QRCode(var xImgPath: string): Boolean;
var
  tmpSQL, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';

  try
    {(*}
    with l_CDS do
      tmpSQL := FieldByName('C_Orderno').AsString + ';;' +  //營管要求兩個分號
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


//明陽 廠別(01:深圳名陽;02九江明陽..),送貨單號,明陽內部採購批次號,批號,數量,凈重,生產日期,有效日期,小包數量
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

//明陽 廠別(01:深圳名陽;02九江明陽..),送貨單號,明陽內部採購批次號,批號,數量,凈重,生產日期,有效日期,小包數量
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


//深南:客戶料號+100660+批號+生產日期+有效日期+客戶PO+數量
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

//華通:VND:ITEQ,PO:客戶PO,PN:客戶料號,SPEC:SPEC(客戶品名),LOT:批號,MF:生產日期,QTY:數量單位
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

//美銳:客戶PO;LIMDZ;客戶料號pn;數量;單位;批號;有效日期;箱號;D/N編號
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
        ';;';    //20240530客戶要求不留空格
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

//名幸:DN:送貨單號,SM:聯茂代號AD001|AD002,KB:卡板編號,M:客戶料號,BS:批號,DM:生產日期,DE:有效日期,Q:數量,
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

    if Pos(Copy(l_CDS.FieldByName('Saleno').AsString, 1, 3), '232/23G/235/602') > 0 then //內銷
      tmpStr := 'AD002'
    else
      tmpStr := 'AD001';
    tmpStrX := '-KB' + RightStr('000' + IntToStr(tmpQRCodeSno), 4); //卡板編號
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

//生益:GYS_QRCODE_CGSL01+客戶PO+客戶PO項次后面加0+客戶料號+數量+單位+生產日期后面加4流水號+批號+有效日期
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

//三廣:客戶PO#客戶PO項次#客戶料號#生產日期#有效日期#批號#單位#數量#廣合流水號#箱號(流水號)
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



//超毅:流水號*客戶料號*有效日期MMDDYY*數量*批號*客戶PO*生產日期MMDDYY
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

//深聯:客戶PO#客戶料號#生產日期#批號#數量#廠內料號
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

//深圳景旺:客戶訂單號
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

{崇達:
<a>客戶料號</a>
<b>送貨單號</b>
<c>項次</c>
<d>數量</d>
<e>單位</e>
<f>客戶訂單</f>
<g>重量</g>
<h>生產日期</h>
<i>過期日期</i>
<j>批號</j>}
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

//依頓:送貨單號;客戶PO;客戶料號;數量;重量;批號;生產日期;有效日期
function TFrmDLII020_qrcode.YD_QRCode(var xImgPath, xKB: string): Boolean;
var
  tmpStr, tmpImgPath: string;
begin
  Result := True;
  xImgPath := '';
  xKB := '';

  try
    if Pos(Copy(l_CDS.FieldByName('Saleno').AsString, 1, 3), '232/23G/235/602') > 0 then //內銷
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
//廠商ID(AD002),客戶料號，批號，生?日期，數量

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

//美維:客戶po;聯茂代碼;客戶料號;數量;採購單位(sheet);批號;有效日期;箱號(空白);送貨單號(空白)
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
  //聯能:PO:客戶訂單號;PN:客戶產品料號;MN:廠內料號;LT:批號數量(多個);PD:生產日期(多個);ED:有效日期(多個);NO:流水碼(YYMMDD????);

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

//廣州依利安達,微通科技:客戶po$客戶料號$數量$客戶品名$生產日期$有效日期&批號
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
        + '$' + StringReplace(StringReplace(FieldByName('C_Sizes').AsString, '含銅', '', [rfReplaceAll]), '不', '', [rfReplaceAll])
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

//全成信:客戶po,客戶料號,客戶品名,批號,數量,生產日期,有效日期
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

//中京:M:物料編號,BS:批號,DM:製造日期,DE:有效日期,Q:數量,PO:採購單號,DN:送貨單號
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
////珠海中京 訂單號,送貨單號
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

//中富:客戶訂單號,客戶料號,批號,數量,生產日期,唯一流水號LM+8位年月日+4位流水號

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

//皆利士:客戶po;聯茂代碼;客戶料號;數量;採購單位(sheet);批號;有效日期;箱號(空白);送貨單號(空白)
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
    if Pos(LeftStr(l_CDS.FieldByName('pno').AsString, 1), 'RME') > 0 then //外銷RME、內銷BNT
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




