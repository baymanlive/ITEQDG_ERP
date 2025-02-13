{*******************************************************}
{                                                       }
{                unDLII020_prn                          }
{                Author: kaikai                         }
{                Create date: 2015/5/28                 }
{                Description: 出貨單列印                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020_prn;

interface

uses
  Windows, Classes, SysUtils, DBClient, Forms, Variants, Math, StrUtils, DateUtils, ComCtrls, Controls, unGlobal,
  unCommon, TWODbarcode, unDLII020_const, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,db;

const
  l_diff = 0.000001;


type
  TDLII020_prn = class
  private
    Fm_image: PTIMAGESTRUCT;
    FOraDB: string;
    FPrnCDS1: TClientDataSet;
    FPrnCDS2: TClientDataSet;
    FPrnCDS3: TClientDataSet;
    procedure ShowBarHint(msg: string);
    function GetAddr(p_no, p_cus_no, p_add_no: string): string;
    function GetPnoKG(Saleno, Pno: string; Saleitem: Integer): Double;
    function SetC_Sizes(DataSet: TClientDataSet; xFilter: string): Boolean;
    function GetLot(Saleno: string; isLocalLot: Boolean; var Data: OleVariant): Boolean;
    function GetCOCLot(Saleno: string; var Data: OleVariant): Boolean;
    function GetQRCodeCustno: string;
    function MY_QRCodeStr(lot, qty, kg: string): string;
    function SendJson(json,sno: string): string;
    function CD_QRCode:boolean;
    function GetACF13Dno(dno: string): string;
    procedure Sp222_4C2008(oga01:string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartPrint(Saleno, Remark: string);
  end;

implementation

uses
  superobject, unUtf8;

var
  l_selfPP: boolean; //自用pp
  test:boolean=false;
  l_tmpFlag:boolean = FALSE;  //無COC批號列印

constructor TDLII020_prn.Create;
begin
  if Pos('dg', LowerCase(g_UInfo^.BU)) > 0 then
    FOraDB := 'ORACLE'
  else
    FOraDB := 'ORACLE1';
  FPrnCDS1 := TClientDataSet.Create(nil);
  FPrnCDS2 := TClientDataSet.Create(nil);
  FPrnCDS3 := TClientDataSet.Create(nil);
  InitCDS(FPrnCDS1, g_PrnCDS1Xml);
  InitCDS(FPrnCDS2, g_PrnCDS2Xml);
  InitCDS(FPrnCDS3, g_PrnCDS2Xml);
  PtInitImage(@Fm_image);
end;

destructor TDLII020_prn.Destroy;
begin
  FreeAndNil(FPrnCDS1);
  FreeAndNil(FPrnCDS2);
  FreeAndNil(FPrnCDS3);
  PtFreeImage(@Fm_image);

  inherited;
end;

//狀態欄顯示信息
procedure TDLII020_prn.ShowBarHint(msg: string);
begin
  g_StatusBar.Panels[0].Text := CheckLang(msg);
  Application.ProcessMessages;
end;

//送貨地址
function TDLII020_prn.GetAddr(p_no, p_cus_no, p_add_no: string): string;
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  tmpCDS := TClientDataSet.Create(nil);
  try
    if Length(p_add_no) = 0 then
      tmpSQL := 'SELECT occ241 FROM occ_file WHERE occ01=' + Quotedstr(p_cus_no)
    else if SameText(p_add_no, 'MISC') then
      tmpSQL := 'SELECT oap041 FROM oap_file WHERE oap01=' + Quotedstr(p_no)
    else
      tmpSQL := 'SELECT ocd221||ocd222||ocd223 FROM ocd_file WHERE ocd01=' + Quotedstr(p_cus_no) + ' AND ocd02=' +
        Quotedstr(p_add_no);
    if QueryBySQL(tmpSQL, Data, FOraDB) then
    begin
      tmpCDS.Data := Data;
      Result := tmpCDS.Fields[0].AsString;
    end
    else
      Result := '';
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//計算小料單重
function TDLII020_prn.GetPnoKG(Saleno, Pno: string; Saleitem: Integer): Double;
var
  tmpStr: string;
begin
  Result := -1;
  tmpStr := LeftStr(Pno, 1);
  if (((tmpStr = 'E') or (tmpStr = 'T')) and (Length(Pno) = 11)) or (((tmpStr = 'N') or (tmpStr = 'M')) and (Length(Pno)
    = 12)) then
    Result := GetKG(Saleno, Saleitem, 0);
end;

//查詢訂單的客戶產品編號C_Orderno、客戶品名C_Pno、客戶規格C_Sizes
function TDLII020_prn.SetC_Sizes(DataSet: TClientDataSet; xFilter: string): Boolean;
var
  tmpSQL: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  Result := False;
  ShowBarHint('正在查詢[產品編號、客戶品名、客戶規格]...');
  tmpSQL := ' Select X.*,Y.oao04,Y.oao06 from (' + ' Select oea04,oea10,oeb01,oeb03,oeb11,ta_oeb10' +
    ' From oea_file Inner Join oeb_file' + ' On oea01=oeb01 Where 1=2 ' + xFilter + ') X Left Join oao_file Y' +
    ' On X.oeb01=Y.oao01 and X.oeb03=Y.oao03' + ' Order By oeb01,oeb03,oao04';
  if not QueryBySQL(tmpSQL, Data, FOraDB) then
    Exit;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with DataSet do
    begin
      First;
      while not Eof do
      begin
        if tmpCDS.Locate('oeb01;oeb03', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('Orderitem').AsString]),
          []) then
        begin
          Edit;
          FieldByName('C_Orderno').AsString := GetC_Orderno(tmpCDS.FieldByName('oea04').AsString, tmpCDS.FieldByName('oea10').AsString,
            tmpCDS.FieldByName('oao06').AsString);
          FieldByName('C_Pno').AsString := tmpCDS.FieldByName('oeb11').AsString;
          FieldByName('C_Sizes').AsString := tmpCDS.FieldByName('ta_oeb10').AsString;
          if SameText(FPrnCDS1.FieldByName('Custno').AsString, 'ACB32') then
          begin
            if Pos('ITA-9300', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT968', 'ITA-9300', [])
            else if Pos('ITA-9310', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT150DA', 'ITA-9310', [])
            else if Pos('ITA-9320', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT150DA', 'ITA-9320', [])
            else if Pos('ITA-9350', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT150DA', 'ITA-9350', [])
            else if Pos('ITA-9380', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT150DA', 'ITA-9380', [])
            else if Pos('ITA-9430', FieldByName('C_Sizes').AsString) > 0 then
              FieldByName('Pname').AsString := StringReplace(FieldByName('Pname').AsString, 'IT170GRA1', 'ITA-9430', []);
          end;
          Post;
        end;
        Next;
      end;
    end;

    Result := True;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

//取批號
function TDLII020_prn.GetLot(Saleno: string; isLocalLot: Boolean; var Data: OleVariant): Boolean;
var
  i: Integer;
  tmpSQL, tmpSFilter: string;
  tmpList: TStrings;
begin
  Result := False;
  ShowBarHint('正在查詢[批號]...');
  Data := null;
  if Pos(',', Saleno) > 0 then
  begin
    tmpList := TStringList.Create;
    try
      tmpList.DelimitedText := Saleno;
      for i := 0 to tmpList.Count - 1 do
        tmpSFilter := tmpSFilter + ',' + Quotedstr(tmpList.Strings[i]);
      Delete(tmpSFilter, 1, 1);
      tmpSFilter := ' in (' + tmpSFilter + ')';
    finally
      FreeAndNil(tmpList);
    end;
  end
  else
    tmpSFilter := '=' + Quotedstr(Saleno);

  if isLocalLot then //PDA掃描批號MSSQL
  begin
    {(*}
    tmpSQL := 'Select A.Saleno ogb01,A.Saleitem ogb03,''''ogb09,B.Manfac1 ogb092,Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) ogb12' +
              ' From DLI010 A Inner Join DLI020 B' +
              ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' +
              ' Where A.Bu=' + Quotedstr(g_UInfo^.BU) + ' And A.Saleno' +
              tmpSFilter + ' And IsNull(B.JFlag,0)=0' +
              ' Group By A.Saleno,A.Saleitem,B.Manfac1' +
              ' Order By A.Saleno,A.Saleitem';
    {*)}
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
  end
  else
  begin         //tiptop扣帳批號
    {(*}

    tmpSQL := 'Select ogb01,ogb03,ogb09,ogb092,Sum(ogb12) ogb12' +
              ' From (Select ogb01,ogb03,ogb09,ogb092,ogb12 From ogb_file' +
              ' Where ogb01' + tmpSFilter + ' and ogb17=''N''' +
              ' Union All Select ogc01,ogc03,ogc09,ogc092,ogc12 From ogc_file' +
              ' Where ogc01' + tmpSFilter + ') A' + ' Group By ogb01,ogb03,ogb09,ogb092 ' + ' Order By ogb01,ogb03';
    {*)}
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
      Exit;
  end;
  Result := True;
end;

//取COC批號
function TDLII020_prn.GetCOCLot(Saleno: string; var Data: OleVariant): Boolean;
var
  i: Integer;
  tmpSQL, tmpSFilter: string;
  tmpList: TStrings;
begin
  Result := False;
  ShowBarHint('正在查詢[批號]...');
  Data := null;
  if Pos(',', Saleno) > 0 then
  begin
    tmpList := TStringList.Create;
    try
      tmpList.DelimitedText := Saleno;
      for i := 0 to tmpList.Count - 1 do
        tmpSFilter := tmpSFilter + ',' + Quotedstr(tmpList.Strings[i]);
      Delete(tmpSFilter, 1, 1);
      tmpSFilter := ' in (' + tmpSFilter + ')';
    finally
      FreeAndNil(tmpList);
    end;
  end
  else
    tmpSFilter := '=' + Quotedstr(Saleno);

  tmpSQL := 'Select A.Saleno ogb01,A.Saleitem ogb03,''''ogb09,B.Manfac ogb092,Sum(DBO.Get_PPMRL(A.Pno,B.Qty)) ogb12,custprono' +
    ' From DLI010 A Inner Join DLI040 B' + ' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem' + ' Where A.Bu=' +
    Quotedstr(g_UInfo^.BU) + ' And A.Saleno' + tmpSFilter + ' Group By A.Saleno,A.Saleitem,B.Manfac,Custprono' +
    ' Order By A.Saleno,A.Saleitem';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  Result := True;
end;

//客戶用二維碼
function TDLII020_prn.GetQRCodeCustno: string;
const
  strCustno = 'ACC58,AC365,AC114,AC434';
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := '';
  if Pos(FPrnCDS1.FieldByName('Custno').AsString, strCustno) > 0 then
  begin
    tmpSQL := 'Select RetNo From DLI045 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Saleno=' + Quotedstr(FPrnCDS1.FieldByName
      ('Saleno').AsString);
    if not QueryOneCR(tmpSQL, Data) then
      Exit;
    if not VarIsNull(Data) then
      Result := VarToStr(Data);

    if Length(Result) = 0 then
      if SameText(FPrnCDS1.FieldByName('Custno').AsString, 'ACC58') then
        ShowMsg('江西志浩無客戶送貨單號,請確認已上傳資料!', 48);
  end
  else if Pos(FPrnCDS1.FieldByName('Custno').AsString, 'AC613') > 0 then   //強達電路
  begin
    result := FPrnCDS1.FieldByName('saleno').AsString;
    FPrnCDS1.first;
    while not FPrnCDS2.Eof do
    begin
      result := result + '|' + FPrnCDS2.FieldByName('c_pno').AsString + ';' + FPrnCDS2.FieldByName('qty').AsString + ';'
        + GetPrdDate2(FPrnCDS2.FieldByName('Lot').AsString) + ';' + FPrnCDS2.FieldByName('Lot').AsString + ';' +
        FPrnCDS2.FieldByName('C_orderno').AsString;
      FPrnCDS2.next;
    end;
    FPrnCDS1.first;
  end;
end;

//注意：報表設定中(報表文件fr3)包含關鍵詞"出貨單"才更新打印次數
//名幸送貨明細,多個saleno用逗號連接
procedure TDLII020_prn.StartPrint(Saleno, Remark: string);
var
  i, j, kgdeci, totkgdeci, sfdeci, totsfdeci: Integer;
  isPP, isMore, isPrnLot, isLocalLot, isMX, isWS, isCD: Boolean;
  tmpKG, tmpT_KG, tmpSF, tmpT_SF: Double;
  tmpSQL, tmpSql2, tmpstr1, tmpstr2, tmpstr3, tmpSFilter,tmpCustsno,CSOURCE_ID1: string;
  tmpList, tmpList2: TStrings;
  tmpCustQty:Double;
  Data: OleVariant;
  tmpCDS, tmpCDS2, Ima_CDS: TClientDataSet;
  ArrPrintData: TArrPrintData;
//  custno, custname, custfullname, custpno, custpname, custpo: string;
  custInfo:TCustInfo;
  obj, sub: ISuperObject;
begin
  if Length(Saleno) = 0 then
  begin
    ShowMsg('請輸入銷貨單號!', 48);
    Exit;
  end;
  Sp222_4C2008(copy(Saleno,1,10));
  JxRemark(Remark,custInfo);
  isCD := False; //(Pos(custno,'AC121/AC820/ACA97/AC109')>0);

  tmpList := TStringList.Create;
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  Ima_CDS := TClientDataSet.Create(nil);



  try
    tmpList.DelimitedText := Saleno;
    isMore := tmpList.Count > 1;
    if isMore then    //多個單號檢查是否同一客戶,是否扣帳,是否相同產品別
    begin
      tmpSQL := LeftStr(tmpList.Strings[0], 3);
      for i := 0 to tmpList.Count - 1 do
      begin
        if tmpSQL <> LeftStr(tmpList.Strings[i], 3) then
        begin
          ShowMsg('單別不相同不可打印在一起!', 48);
          Exit;
        end;

        tmpSFilter := tmpSFilter + ',' + Quotedstr(tmpList.Strings[i]);
      end;

      Delete(tmpSFilter, 1, 1);
      tmpSQL :=
        'Select distinct oga01,oga04,ogapost,case when substr(ogb04,1,1) in (''E'',''T'') then 1 else 0 end ptype' +
        ' From oga_file,ogb_file where oga01=ogb01 and oga01 in (' + tmpSFilter + ')';
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
        Exit;
      tmpCDS.Data := Data;

      for i := 0 to tmpList.Count - 1 do
        if not tmpCDS.Locate('oga01', tmpList.Strings[i], []) then
        begin
          ShowMsg(tmpList.Strings[i] + '出貨單據不存在!', 48);
          Exit;
        end;

      if tmpCDS.Locate('ptype', 1, []) then
        if tmpCDS.Locate('ptype', 0, []) then
        begin
          ShowMsg('CCL與PP不可打印在一起!', 48);
          Exit;
        end;

      tmpCDS.First;
      tmpSQL := tmpCDS.FieldByName('oga04').AsString;
      while not tmpCDS.Eof do
      begin
        if tmpCDS.FieldByName('oga04').AsString <> 'AC096' then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString + '不是名幸客戶,不可列印!', 48);
          Exit;
        end;

        if tmpSQL <> tmpCDS.FieldByName('oga04').AsString then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString + '客戶不相同,不可列印!', 48);
          Exit;
        end;

        if tmpCDS.FieldByName('ogapost').AsString <> 'Y' then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString + '單據未扣帳,不可列印!', 48);
          Exit;
        end;

        tmpCDS.Next;
      end;
    end;

    //TipTop單頭(oga00單別、gen02業務員、gem02部門)
    ShowBarHint('正在查詢[出貨單單頭]資料...');
    Data := null;         {(*}
    tmpSQL := 'Select X.*,Y.gem02 From '+
              '(Select C.*,D.gen02 From (Select A.*, Concat(B.smyslip,B.smydesc) oga00 From '+
              '(Select oga01,oga02,oga04,oga044,oga14,oga15,oga23,oga24,ogauser,ogapost,ogaprsw,occ01,occ02,occ18' +
              ' From oga_file Inner Join occ_file ON oga04=occ01 Where oga01=' + Quotedstr(tmpList.Strings[0]) +
              ') A Left Join smy_file B ON Substr(A.oga01,1,3)=B.smyslip) C Left Join gen_file D' +
              ' ON C.oga14=D.gen01) X Left Join gem_file Y ON X.oga15=Y.gem01';   {*)}
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
      Exit;
    tmpCDS.Data := Data;
    if isCD then
    begin
      tmpCDS.edit;
      tmpCDS.FieldByName('occ01').AsString := custInfo.No;// custno;
      tmpCDS.FieldByName('occ02').AsString := custInfo.Name;// custname;
    end;

    if tmpCDS.IsEmpty then
    begin
      ShowMsg(tmpList.Strings[0] + '出貨單不存在!', 48);
      Exit;
    end;

    if tmpCDS.FieldByName('ogapost').AsString <> 'Y' then
    begin
      ShowMsg(tmpList.Strings[0] + '出貨單未扣帳,不可列印!', 48);
      Exit;
    end;

    isMX := Pos(tmpCDS.FieldByName('occ01').AsString, g_strMX) > 0; //名幸
    isWS := Pos(tmpCDS.FieldByName('occ01').AsString, g_strWS) > 0; //維勝

    FPrnCDS1.First;
    FPrnCDS2.First;
    while not FPrnCDS1.IsEmpty do
      FPrnCDS1.Delete;
    while not FPrnCDS2.IsEmpty do
      FPrnCDS2.Delete;

    with FPrnCDS1 do
    begin
      Append;
      FieldByName('IsSale').AsString := 'Y';
      FieldByName('Saleno').AsString := tmpCDS.FieldByName('oga01').AsString;
      FieldByName('Saleno1').AsString := RightStr(tmpCDS.FieldByName('oga01').AsString, 6);
      FieldByName('Saledate').AsString := tmpCDS.FieldByName('oga02').AsString;
      FieldByName('Saletype').AsString := tmpCDS.FieldByName('oga00').AsString;
      FieldByName('Salesno').AsString := tmpCDS.FieldByName('oga14').AsString;
      FieldByName('Salesname').AsString := tmpCDS.FieldByName('gen02').AsString;
      FieldByName('Deptno').AsString := tmpCDS.FieldByName('oga15').AsString;
      FieldByName('Dept').AsString := tmpCDS.FieldByName('gem02').AsString;
      FieldByName('Cashtype').AsString := tmpCDS.FieldByName('oga23').AsString;
      FieldByName('Rate').AsString := tmpCDS.FieldByName('oga24').AsString;

      FieldByName('Custno').AsString := tmpCDS.FieldByName('occ01').AsString;
      FieldByName('Custabs').AsString := tmpCDS.FieldByName('occ02').AsString;
      if isCD then
        FieldByName('Custom').AsString := custInfo.Name// custname
      else
        FieldByName('Custom').AsString := tmpCDS.FieldByName('occ18').AsString;
      FieldByName('Custno_addr').AsString := tmpCDS.FieldByName('oga04').AsString;
      FieldByName('SendAddr').AsString := tmpCDS.FieldByName('oga044').AsString;
      FieldByName('Dealer').AsString := tmpCDS.FieldByName('ogauser').AsString;
      FieldByName('Printcnt').AsString := IntToStr(tmpCDS.FieldByName('ogaprsw').AsInteger);
      if isMore or isMX then
        FieldByName('MoreSaleno').AsString := Saleno;
      if (FieldByName('Custno').AsString = 'AC597') then
      begin
        CSOURCE_ID1:=copy(g_uinfo^.BU, 5, 2) + Saleno;
        obj := SO('{"SUPTABLE1":[],"SUPTABLE2":[],"SUPTABLE3":[]}');
        sub := SO('{"CSOURCE_ID":"' + CSOURCE_ID1 + '","CSUPPLIER":"0005"}');
        obj['SUPTABLE1'].AsArray.Add(sub);
      end;
      Post;
    end;

    //送貨地址
    ShowBarHint('正在查詢[送貨地址]...');
    tmpSQL := GetAddr(FPrnCDS1.FieldByName('Saleno').AsString, Trim(FPrnCDS1.FieldByName('Custno_addr').AsString), Trim(FPrnCDS1.FieldByName
      ('SendAddr').AsString));
    with FPrnCDS1 do
    begin
      Edit;
      FieldByName('SendAddr').AsString := tmpSQL;
      Post;
    end;

    //製表人Dealer、品保人COC_user、核准人Check_user
    ShowBarHint('正在查詢[製表人、品保人、核准人]...');
    Data := null;
    tmpSQL := 'exec dbo.proc_GetCOCName ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(tmpList.Strings[0]) + ',' +
      Quotedstr(FPrnCDS1.FieldByName('Dealer').AsString);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    if not tmpCDS.IsEmpty then
      with FPrnCDS1 do
      begin
        Edit;
        FieldByName('Dealer').AsString := tmpCDS.Fields[0].AsString;
        FieldByName('COC_user').AsString := tmpCDS.Fields[1].AsString;
        FieldByName('Check_user').AsString := tmpCDS.Fields[2].AsString;
        Post;
      end;
    if Trim(FPrnCDS1.FieldByName('Dealer').AsString) = '' then
    begin
      FPrnCDS1.Edit;
      FPrnCDS1.FieldByName('Dealer').AsString := g_UInfo^.UserName;
      FPrnCDS1.Post;
    end;

    //單重,總重小數位
    ShowBarHint('正在查詢[格式化字符串]...');
    Data := null;
    tmpSQL := 'exec dbo.proc_GetKGFormat ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(FPrnCDS1.FieldByName('Custno').AsString);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    with FPrnCDS1 do
    begin
      Edit;
      FieldByName('QtyFormat').AsString := tmpCDS.FieldByName('qtyformat').AsString;
      FieldByName('KgFormat').AsString := tmpCDS.FieldByName('kgformat').AsString;
      FieldByName('TotKgFormat').AsString := tmpCDS.FieldByName('totkgformat').AsString;
      FieldByName('SfFormat').AsString := tmpCDS.FieldByName('sfformat').AsString;
      FieldByName('TotSfFormat').AsString := tmpCDS.FieldByName('totsfformat').AsString;
      Post;
    end;
    kgdeci := -tmpCDS.FieldByName('kgdeci').AsInteger;
    totkgdeci := -tmpCDS.FieldByName('totkgdeci').AsInteger;
    sfdeci := -tmpCDS.FieldByName('sfdeci').AsInteger;
    totsfdeci := -tmpCDS.FieldByName('totsfdeci').AsInteger;
    //end l_PrnCDS1
    //出貨單是否列印批號,是否帶pda掃描批號
    Data := null;
    tmpSQL := 'select isprnlot,islocallot from dli026' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and custno=' +
      Quotedstr(FPrnCDS1.FieldByName('Custno').AsString);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    isPrnLot := tmpCDS.Fields[0].AsBoolean;
    isLocalLot := tmpCDS.Fields[1].AsBoolean;

    //begin l_PrnCDS2
    //單身tmpCDS
    ShowBarHint('正在查詢[出貨單單身]資料...');
    Data := null;
//    if (Pos(custno,'AC121/AC820/ACA97/AC109')>0) then
//    begin
//      tmpSQL := Format('exec proc_dli020 %s,%s', [quotedstr(g_uinfo^.BU), quotedstr(tmpList.Strings[0])]);
//      if not QueryBySQL(tmpSQL, Data) then
//        Exit;
//      tmpSql:='Select ogb01,ogb03,ogb31,ogb32,ogb04,ogb05,ogb05_fac,ta_oeb01,ta_oeb02,ta_oeb35,ta_oeb36,ta_oeb44,'+
//              'ogb09,ogc092 ogb092,ogc12 ogb12 From ogb_file,oeb_file,ogc_file where '+
//              'ogb01=ogc01 and ogb03=ogc03 and ogb31=oeb01 and ogb32=oeb03 and ogb01='+ Quotedstr(tmpList.Strings[0]);
//      tmpSQL := tmpSQL + ' Order By ogb01,ogb03';
//      if not QueryBySQL(tmpSQL, Data, FOraDB) then
//        Exit;
//      tmpCDS.Data := Data;
//      if not Get_PPMRL('ogb04','ogb12',tmpCDS) then
//        exit;
//    end
//    else
    begin
      tmpSQL := 'Select ogb_file.*,ta_oeb01,ta_oeb02,ta_oeb35,ta_oeb36,ta_oeb44 From ' +
      'ogb_file,oeb_file where ogb31=oeb01 and ogb32=oeb03';
      if isMore then
        tmpSQL := tmpSQL + ' and ogb01 in (' + tmpSFilter + ')'
      else
        tmpSQL := tmpSQL + ' and ogb01=' + Quotedstr(tmpList.Strings[0]);
      tmpSQL := tmpSQL + ' Order By ogb01,ogb03';
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
        Exit;
      tmpCDS.Data := Data;
    end;

    if isMore then
    begin
      for i := 0 to tmpList.Count - 1 do
        if not tmpCDS.Locate('ogb01', tmpList.Strings[0], []) then
        begin
          ShowMsg(tmpList.Strings[0] + '單身檔無資料!', 48);
          Exit;
        end;
    end
    else if tmpCDS.IsEmpty then
    begin
      ShowMsg('單身檔無資料!', 48);
      Exit;
    end;

    isPP := Pos(LeftStr(tmpCDS.FieldByName('ogb04').AsString, 1), 'ET') = 0;

    //查詢產品檔條件tmpstr1
    //訂單檔備註檔條件tmpstr2
    //訂單檔條件tmpstr3
    with tmpCDS do
      while not Eof do
      begin
        tmpstr1 := tmpstr1 + ' or Ima01=' + Quotedstr(FieldByName('ogb04').AsString);
        tmpstr2 := tmpstr2 + ' or (oao01=' + Quotedstr(FieldByName('ogb31').AsString) + ' and oao03=' + FieldByName('ogb32').AsString
          + ' and oao05=2)';
        tmpstr3 := tmpstr3 + ' or (oeb01=' + Quotedstr(FieldByName('ogb31').AsString) + ' and oeb03=' + FieldByName('ogb32').AsString
          + ')';
        Next;
      end;

    //產品資料
    ShowBarHint('正在查詢[產品資料]...');
    tmpSQL := 'Select ima01,ima02,ima021,ima18,ta_ima01,ta_ima02 From ima_file' + ' Where 1=2 ' + tmpstr1;
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
      Exit;
    Ima_CDS.Data := Data;

    tmpCDS.First;
    with FPrnCDS2 do
    begin
      while not tmpCDS.Eof do
      begin
        Append;
        if (Pos(custInfo.No,'AC121/ACG02/AC820/ACA97/AC109')>0) then
          FieldByName('lot').AsString := tmpCDS.FieldByName('ogb092').AsString;
        FieldByName('Dno').AsString := tmpCDS.FieldByName('ogb01').AsString;
        FieldByName('Ditem').AsString := tmpCDS.FieldByName('ogb03').AsString;
        FieldByName('Orderno').AsString := tmpCDS.FieldByName('ogb31').AsString;
        FieldByName('Orderitem').AsString := tmpCDS.FieldByName('ogb32').AsString;
        FieldByName('Pno').AsString := tmpCDS.FieldByName('ogb04').AsString;
        FieldByName('Units').AsString := tmpCDS.FieldByName('ogb05').AsString;
        FieldByName('Qty').AsFloat := tmpCDS.FieldByName('ogb12').AsFloat;

        if isCD then
        begin
          FieldByName('C_pno').AsString := tmpCDS.FieldByName('ta_oeb36').AsString;
          FieldByName('C_sizes').AsString := tmpCDS.FieldByName('ta_oeb44').AsString;
        end;
        if SameText(FieldByName('Units').AsString, 'RL') and (Length(FieldByName('Pno').AsString) = 18) then
          FieldByName('Qty_m').AsFloat := FieldByName('Qty').AsFloat * StrToInt(Copy(FieldByName('Pno').AsString, 11, 3))
        else
          FieldByName('Qty_m').AsFloat := FieldByName('Qty').AsFloat * tmpCDS.FieldByName('ogb05_fac').AsFloat;
        //重量、面積
        tmpSQL := FieldByName('Pno').AsString;
        if Ima_CDS.Locate('ima01', tmpSQL, []) or Ima_CDS.Locate('ima01', FieldByName('Pno').AsString, []) then
        begin
          //品名、規格以物料檔為準
          FieldByName('Pname').AsString := Ima_CDS.FieldByName('ima02').AsString;
          FieldByName('Sizes').AsString := Ima_CDS.FieldByName('ima021').AsString;

          tmpKG := GetPnoKG(tmpCDS.FieldByName('ogb01').AsString, tmpCDS.FieldByName('ogb04').AsString, tmpCDS.FieldByName
            ('ogb03').AsInteger);
          if tmpKG = -1 then
            FieldByName('KG').AsFloat := Ima_CDS.FieldByName('ima18').AsFloat
          else
            FieldByName('KG').AsFloat := tmpKG;
          FieldByName('KG_old').AsFloat := RoundTo(FieldByName('KG').AsFloat + l_diff, kgdeci);
          if SameText(FieldByName('Units').AsString, 'RL') and (Length(FieldByName('Pno').AsString) = 18) then
          begin
            FieldByName('KG').AsFloat := RoundTo(StrToInt(Copy(FieldByName('Pno').AsString, 11, 3)) * FieldByName('KG').AsFloat
              + l_diff, kgdeci);
          end
          else
            FieldByName('KG').AsFloat := RoundTo(tmpCDS.FieldByName('ogb05_fac').AsFloat * FieldByName('KG').AsFloat +
              l_diff, kgdeci);
          FieldByName('T_KG').AsFloat := RoundTo(FieldByName('Qty').AsFloat * FieldByName('KG').AsFloat + l_diff,
            totkgdeci);

          tmpSQL := LeftStr(FieldByName('Pno').AsString, 1); //第1碼
          if SameText(FieldByName('Units').AsString, 'RL') and (Length(FieldByName('Pno').AsString) = 18) then
          begin
            FieldByName('SF').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat
              * 39.37) / 144 + l_diff, sfdeci);
          end
          else if (tmpSQL = 'M') or (tmpSQL = 'N') then
            FieldByName('SF').AsFloat := RoundTo((tmpCDS.FieldByName('ta_oeb01').AsFloat * tmpCDS.FieldByName('ta_oeb02').AsFloat)
              / 144 + l_diff, sfdeci)
          else if tmpSQL = 'R' then
            FieldByName('SF').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat
              * 39.37) / 144 + l_diff, sfdeci)
          else
            FieldByName('SF').AsFloat := RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat * Ima_CDS.FieldByName('ta_ima02').AsFloat)
              / 144 * tmpCDS.FieldByName('ogb05_fac').AsFloat + l_diff, sfdeci);

          if ((tmpSQL = 'R') or (tmpSQL = 'B')) and (FPrnCDS1.FieldByName('Custno_addr').AsString = 'AC091') and (Copy(FieldByName
            ('Pno').AsString, 14, 3) = '428') then
            FieldByName('SF').AsFloat := RoundTo((tmpCDS.FieldByName('ogb05_fac').AsFloat * 42.85 * 39.37) / 144 +
              l_diff, sfdeci);

          FieldByName('T_SF').AsFloat := RoundTo(FieldByName('Qty').AsFloat * FieldByName('SF').AsFloat + l_diff,
            totsfdeci);


          //鵬鼎
          if (FPrnCDS1.FieldByName('Custno').AsString = 'AC148') or (FPrnCDS1.FieldByName('Custno_addr').AsString =
            'AC148') then
          begin
            if (tmpSQL = 'B') or (tmpSQL = 'R') or (tmpSQL = 'P') then
            begin
              if tmpCDS.FieldByName('ogb05_fac').AsFloat = 150 then
              begin
                //FieldByName('SF').AsFloat:=1968;
                FieldByName('T_SF').AsFloat := 1968 * FieldByName('Qty').AsFloat;
              end
              else if tmpCDS.FieldByName('ogb05_fac').AsFloat = 200 then
              begin
                //FieldByName('SF').AsFloat:=2624;
                FieldByName('T_SF').AsFloat := 2624 * FieldByName('Qty').AsFloat;
              end
              else if tmpCDS.FieldByName('ogb05_fac').AsFloat = 300 then
              begin
                //FieldByName('SF').AsFloat:=3936;
                FieldByName('T_SF').AsFloat := 3936 * (FieldByName('Qty').AsFloat);
              end;
            end
            else if (tmpSQL = 'M') or (tmpSQL = 'N') then
            begin
              FieldByName('T_SF').AsFloat := RoundTo(FieldByName('Qty').AsFloat * ((tmpCDS.FieldByName('ta_oeb01').AsFloat
                * tmpCDS.FieldByName('ta_oeb02').AsFloat) / 144) + l_diff, -2);
            end;

            FieldByName('SF').Clear;
          end;

        end;

        Post;
        tmpCDS.Next;
      end;
    end;

    //訂單備註
    ShowBarHint('正在查詢[訂單備註]...');
    Data := null;
    tmpSQL := 'select oao01,oao03,listagg(oao06,'','') within group (order by oao04) as oao06' +
      ' from oao_file where 1=2 ' + tmpstr2 + ' group by oao01,oao03';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
      Exit;
    tmpCDS.Data := Data;
    with FPrnCDS2 do
    begin
      First;
      while not Eof do
      begin
        if tmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('Orderitem').AsString]),
          []) then
        begin
          Edit;
          FieldByName('Remark').AsString := tmpCDS.FieldByName('oao06').AsString;
//          UpdateJx(FPrnCDS2);
          Post;
        end;
        Next;
      end;
    end;



    //名幸關封號
    //20200212取消
    {if isMX and (LeftStr(FPrnCDS1.FieldByName('Saleno').AsString,3)<>'232') then
    begin
      tmpSQL:='select tc_gfh01,tc_gfh03 from tc_gfh_file where tc_gfh02=''AC096'''
             +' and tc_gfhacti=''Y'' and tc_gfh05<=to_date(to_char(sysdate,''yyyy-mm-dd''),''yyyy-mm-dd'')'
             +' and tc_gfh06>=to_date(to_char(sysdate,''yyyy-mm-dd''),''yyyy-mm-dd'')';
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
         Exit;
      tmpCDS.Data:=Data;

      tmpSQL:='';
      if Pos(LeftStr(FPrnCDS2.FieldByName('Pno').AsString,1),'ET')>0 then
      begin
        if tmpCDS.Locate('tc_gfh01','CCL',[]) then
           tmpSQL:=tmpCDS.FieldByName('tc_gfh03').AsString;
      end else
      begin
        if tmpCDS.Locate('tc_gfh01','PP',[]) then
           tmpSQL:=tmpCDS.FieldByName('tc_gfh03').AsString;
      end;

      if Length(tmpSQL)>0 then
      begin
        FPrnCDS1.Edit;
        FPrnCDS1.FieldByName('MXgfh').AsString:=tmpSQL;
        FPrnCDS1.Post;
      end;
    end;
    }
    //客戶產品編號、客戶品名、客戶規格
    if not isCD then
      if not SetC_Sizes(FPrnCDS2, tmpstr3) then
        Exit;

    Data := null;   {(*}
    l_selfPP:=(Copy(FPrnCDS2.FieldByName('pno').AsString,1,1)<>'P') and
       (Copy(FPrnCDS2.FieldByName('pno').AsString,1,1)<>'Q');
    if (pos(FPrnCDS1.FieldByName('Custno').AsString, 'ACA00/AC178/AC152/AH036/N024/N006') > 0) and
       l_selfPP and (not l_tmpFlag) then   {*)}
    begin
      if not GetCOCLot(Saleno, Data) then
        exit;
    end
    else
    begin
      if not GetLot(Saleno, isLocalLot, Data) then
        Exit;
    end;
    tmpCDS.Data := Data;
    if isMore then
    begin
      for i := 0 to tmpList.Count - 1 do
        if not tmpCDS.Locate('ogb01', tmpList.Strings[0], []) then
        begin
          if not l_tmpFlag then
          begin
          ShowMsg(tmpList.Strings[0] + '批號檔無資料!', 48);
          Exit;
          end;
        end;
    end
    else if tmpCDS.IsEmpty then
    begin
      if not l_tmpFlag then
          begin
      ShowMsg('批號檔無資料!', 48);
      Exit;
      end;
    end;

    FPrnCDS2.First;
    while not FPrnCDS2.Eof do
    begin
      tmpstr1 := '';
      with tmpCDS do
      begin
        Filtered := False;
        Filter := 'ogb01=' + Quotedstr(FPrnCDS2.FieldByName('Dno').AsString) + ' And ogb03=' + IntToStr(FPrnCDS2.FieldByName
          ('Ditem').AsInteger);
        Filtered := True;
        IndexFieldNames := 'ogb092';
        while not Eof do
        begin

          if isWS or (Pos(FPrnCDS1.FieldByName('Custno').AsString, g_strMW) > 0) or (Pos(FPrnCDS1.FieldByName('Custno').AsString,
            'AC152,AH036') > 0) or SameText('ACA00', FPrnCDS1.FieldByName('Custno').AsString) or SameText('N024', FPrnCDS1.FieldByName
            ('Custno').AsString) or (Pos(FPrnCDS1.FieldByName('Custno').AsString, 'N012,N005,N006') > 0) then
          begin
            //            if (Pos('AC117',FPrnCDS2.FieldByName('Remark').AsString) > 0) or (Pos('ACC19',FPrnCDS2.FieldByName('Remark').AsString) > 0) then

            //              tmpstr1 := tmpstr1 + copy(FieldByName('ogb092').AsString,1,10) + ' ' + FieldByName('ogb12').AsString + #13#10
//            else
            tmpstr1 := tmpstr1 + FieldByName('ogb092').AsString + ' ' + FieldByName('ogb12').AsString + #13#10;
          end
          else
            tmpstr1 := tmpstr1 + FieldByName('ogb092').AsString + #13#10;
          Next;
        end;
      end;

      with FPrnCDS2 do
      begin
        Edit;
        FieldByName('Lot').AsString := Trim(tmpstr1);
        FieldByName('PrdDate1').AsString := GetPrdDate1(FieldByName('Lot').AsString);
        FieldByName('PrdDate2').AsString := GetPrdDate2(FieldByName('Lot').AsString);
        if Pos(FPrnCDS1.FieldByName('Custno').AsString, 'N005,N012') > 0 then
        begin
          tmpSQL := g_UInfo^.TempPath + FieldByName('Dno').AsString + '@' + IntToStr(FieldByName('Ditem').AsInteger) +
            '.bmp';
          if getcode(FieldByName('Dno').AsString + ';' + FieldByName('Ditem').AsString + ';' + FieldByName('Pno').AsString,
            tmpSQL, Fm_image) then
            FieldByName('QRcode').AsString := tmpSQL;
        end
        else if isMore or isMX then
        begin
          tmpSQL := g_UInfo^.TempPath + FieldByName('Dno').AsString + '@' + IntToStr(FieldByName('Ditem').AsInteger) +
            '.bmp';
          if getcode(FieldByName('Dno').AsString, tmpSQL, Fm_image) then
            FieldByName('QRcode').AsString := tmpSQL;
        end
        else if Pos(FPrnCDS1.FieldByName('Custno').AsString, 'ACD53,AC222,ACC91') > 0 then
        begin
          tmpSQL := g_UInfo^.TempPath + FieldByName('Dno').AsString + '@' + IntToStr(FieldByName('Ditem').AsInteger) +
            '.bmp';
          if getcode(FieldByName('C_orderno').AsString + ',' + FPrnCDS1.FieldByName('Saleno').AsString, tmpSQL, Fm_image)
            then
            FieldByName('QRcode').AsString := tmpSQL;
        end
        else if Pos(FPrnCDS1.FieldByName('Custno').AsString, 'ACE71') > 0 then
        begin
          tmpSQL := g_UInfo^.TempPath + FieldByName('Dno').AsString + '@' + IntToStr(FieldByName('Ditem').AsInteger) +
            '.bmp';
          if getcode(FieldByName('C_orderno').AsString + ',' + FPrnCDS1.FieldByName('Saleno').AsString, tmpSQL, Fm_image)
            then
            FieldByName('QRcode').AsString := tmpSQL;
        end;
        Post;
      end;
                  //五株
      if (FPrnCDS1.FieldByName('Custno').AsString = 'AC597') then
      begin          {(*}
            sub := SO('{"CPO":"'+FPrnCDS2.FieldByName('C_orderno').AsString+'","CPO_SEQ":"'+FPrnCDS2.FieldByName(
              'orderitem').AsString+'","CPO_QTY":"'+
                    FPrnCDS2.FieldByName('Qty').asstring+'","CDELIVER_QTY":"'+FPrnCDS2.FieldByName('Qty').asstring+
                      '","CSOURCE_ID":"'+  CSOURCE_ID1+'-'+
                    FPrnCDS2.FieldByName('Ditem').AsString+'","CITEM_ID":"'+FPrnCDS2.FieldByName('C_pno').AsString+
                      '","CSUPTABLE1_ID":"'+CSOURCE_ID1+'"}');
            obj['SUPTABLE2'].AsArray.Add(sub);


            Data := null;
            {(*}
        ShowBarHint('正在更新江西二維碼資料...');
        tmpSql2:='update b set b.fname10=substring(c.serial_no,5,255) from dli010 a,dli041 b,'+
                 ' twlbl.GP_LABEL_DB.dbo.label_file c where a.bu=b.bu and a.dno=b.dno and b.fname13=c.id '+
                 ' and a.ditem=b.ditem and a.saleno='+quotedstr(FPrnCDS1.fieldbyname('saleno').asstring)+
                 ' and a.bu='+quotedstr(g_uinfo^.BU)+
                 ' and fname13 like ''JX%'''+
                 ' and (fname2 like ''T%'' or fname2 like ''E%'')';
        if not PostBySQL(tmpSql2) then
          exit;

        tmpSql2:='update b set b.fname11=substring(c.serial_no,5,255) from dli010 a,dli041 b,'+
                 ' twlbl.GP_LABEL_DB.dbo.label_file c where a.bu=b.bu and a.dno=b.dno and b.fname13=c.id '+
                 ' and a.ditem=b.ditem and a.saleno='+quotedstr(FPrnCDS1.fieldbyname('saleno').asstring)+
                 ' and a.bu='+quotedstr(g_uinfo^.BU)+
                 ' and fname13 like ''JX%'''+
                 ' and fname2 not like ''T%'' and fname2 not like ''E%''';
        if not PostBySQL(tmpSql2) then
          exit;

        tmpsql2:=' select fname2,fname4,fname3,substring(fname10,len(fname10)-13,14)fname10,substring(fname11,len(fname11)-13,14)fname11 from dli010 a,dli041 b where a.bu=b.bu and a.dno=b.dno ' +
                    ' and a.ditem=b.ditem and a.saleno=%s and a.saleitem=%d and a.bu=%s';     {*)}
        tmpSql2 := format(tmpSql2, [quotedstr(FPrnCDS1.fieldbyname('saleno').asstring), FPrnCDS2.FieldByName('Ditem').AsInteger,
          quotedstr(g_uinfo^.BU)]);
        if not querybysql(tmpSql2, Data) then
          exit;
        tmpCDS2.Data := Data;
        while not tmpCDS2.eof do
        begin
          if (Copy(tmpCDS2.FieldByName('fname2').AsString,1,1)='E') or (Copy(tmpCDS2.FieldByName('fname2').AsString,1,1)='T') then
            tmpCustsno:='0005'+tmpCDS2.FieldByName('fname10').AsString
          else
            tmpCustsno:='0005'+tmpCDS2.FieldByName('fname11').AsString;

         
          if SameText(FPrnCDS2.FieldByName('Units').AsString, 'RL') and (Length(tmpCDS2.FieldByName('fname2').AsString) = 18) then
            tmpCustQty := tmpCDS2.FieldByName('fname4').AsFloat / StrTofloat(Copy(tmpCDS2.FieldByName('fname2').AsString, 11, 3))
          else
            tmpCustQty := tmpCDS2.FieldByName('fname4').AsFloat;

          sub := SO('{"CBARCODE":"' + tmpCustsno + '","CSUPTABLE2_ID":"' + CSOURCE_ID1+'-'+FPrnCDS2.FieldByName
            ('Ditem').AsString + '","QTY":"' + FloatToStr(tmpCustQty) + '","CPRODUCTION_DATE":"' +
            GetPrdDate2(tmpCDS2.FieldByName('fname3').AsString) + '","CSUPPLIER_LOT":"' + tmpCDS2.FieldByName('fname3').AsString
            + '"}');
          obj['SUPTABLE3'].AsArray.Add(sub);
          tmpCDS2.next;
        end;

      end;
      FPrnCDS2.Next;
    end;

    if (FPrnCDS1.FieldByName('Custno').AsString = 'AC597') then
    begin
      FPrnCDS1.edit;
      FPrnCDS1.FieldByName('QRCodeCustno').AsString := sendjson(obj.Asjson,CSOURCE_ID1);
    end else
    if (FPrnCDS1.FieldByName('Custno').AsString = 'ACF13') then
    begin
      FPrnCDS1.edit;
      FPrnCDS1.FieldByName('QRCodeCustno').AsString := GetACF13Dno(Saleno);
    end;

    //明陽、九江明陽:顯示生產日期
    {(*}
    if (Pos(FPrnCDS1.FieldByName('Custno').AsString, 'AC133,ACA28,ACE06,ACA00,N024,N006') > 0) and
       l_selfPP then   {*)}
    begin
      //COC批號
      Data := null;
      if not GetCOCLot(Saleno, Data) then
        Exit;
      tmpCDS.Data := Data;
      if isMore then
      begin
        for i := 0 to tmpList.Count - 1 do
          if not tmpCDS.Locate('ogb01', tmpList.Strings[0], []) then
          begin
            ShowMsg(tmpList.Strings[0] + 'COC批號檔無資料!', 48);
            Exit;
          end;
      end
      else if tmpCDS.IsEmpty then
      begin
        if not l_tmpFlag then
        begin
          ShowMsg('COC批號檔無資料!', 48);
          Exit;
        end;
      end;

      FPrnCDS2.First;
      while not FPrnCDS2.Eof do
      begin
        tmpstr1 := '';
        tmpstr2 := '';
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'ogb01=' + Quotedstr(FPrnCDS2.FieldByName('Dno').AsString) + ' And ogb03=' + IntToStr(FPrnCDS2.FieldByName
            ('Ditem').AsInteger);
          Filtered := True;
          IndexFieldNames := 'ogb092';
          while not Eof do
          begin
//            tmpStr2:=GetPrdDate1(FieldByName('ogb092').AsString);
//            tmpStr1:=tmpStr1+tmpStr2+' '+FieldByName('ogb12').AsString+#13#10+GetLstDate1(isPP, tmpStr2)+#13#10;
            tmpstr1 := tmpstr1 + FieldByName('ogb092').AsString + #13#10 + GetPrdDate1(FieldByName('ogb092').AsString) +
              ' ' + FieldByName('ogb12').AsString + #13#10;
            tmpstr2 := FieldByName('Custprono').AsString;
            Next;
          end;
        end;

        with FPrnCDS2 do
        begin
          Edit;
          FieldByName('LotDate').AsString := Trim(tmpstr1);
          FieldByName('Custprono').AsString := Trim(tmpstr2);
          Post;
        end;
        FPrnCDS2.Next;
      end;
    end;

    //銷貨單2維碼
    FPrnCDS2.First;
    if Pos(FPrnCDS1.FieldByName('Custno').AsString, 'AC625,ACB00') > 0 then //廣州快揵、興森電子
      tmpstr1 := FPrnCDS2.FieldByName('C_Orderno').AsString + '_' + FPrnCDS1.FieldByName('Saleno').AsString
    else
      tmpstr1 := FPrnCDS1.FieldByName('Saleno').AsString;
    tmpstr2 := g_UInfo^.TempPath + FPrnCDS1.FieldByName('Saleno').AsString + '.bmp';
    if getcode(tmpstr1, tmpstr2, Fm_image) then
    begin
      FPrnCDS1.Edit;
      FPrnCDS1.FieldByName('QRCodeSaleno').AsString := tmpstr2;
      FPrnCDS1.Post;
    end;

    //客戶用二維碼：江西志浩、方正
    tmpstr1 := GetQRCodeCustno;
    if Length(tmpstr1) > 0 then
    begin
      tmpstr2 := g_UInfo^.TempPath + FPrnCDS1.FieldByName('Custno').AsString + '.bmp';
      if getcode(tmpstr1, tmpstr2, Fm_image) then
      begin
        FPrnCDS1.Edit;
        FPrnCDS1.FieldByName('QRCodeCustnoText').AsString := tmpstr1;
        FPrnCDS1.FieldByName('QRCodeCustno').AsString := tmpstr2;
        FPrnCDS1.Post;
      end;
    end;

//    if FPrnCDS1.fieldbyname('Custno').AsString='AC121' then
//    begin
//      FPrnCDS2.FIRST;
//      while not fprncds2.eof do
//      begin
//
//        fprncds2.next;
//      end;
//    end;

    //一個批號一行     ???
//    if (Pos(FPrnCDS1.fieldbyname('Custno').AsString, g_strMY) > 0) then
//    begin
//      FPrnCDS3.EmptyDataSet;
//      with FPrnCDS2 do
//      begin
//        First;
//        while not Eof do
//        begin
//          if Pos(' ', FieldByName('Lot').AsString) = 0 then
//            next;
//        end;
//      end;
//    end;

    //一個批號一行
    if (Pos(FPrnCDS1.fieldbyname('Custno').AsString, g_strMY) > 0) then
    begin
      tmpList2 := TStringList.create;
      try
        tmpList.Clear;
        with FPrnCDS2 do
        begin
          First;
          while not Eof do
          begin
            tmpList.DelimitedText := trim(FieldByName('LotDate').AsString);
            j := tmpList.Count div 3;
            if j > 1 then
            begin
              for i := 0 to FPrnCDS2.FieldCount - 1 do
              begin
                tmpList2.Add(FPrnCDS2.Fields[i].asstring);
              end;
              while j > 1 do
              begin
                Insert;
                for i := 0 to FPrnCDS2.FieldCount - 1 do
                begin
                  Fields[i].asstring := tmpList2[i];

                end;
                FieldByName('LotDate').AsString := tmpList[0] + #13#10 + tmpList[1] + ' ' + tmpList[2];
                FieldByName('Lot').AsString := tmpList[0];
                FieldByName('qty').AsString := tmpList[2];
                FieldByName('t_kg').Value := FieldByName('qty').value * FieldByName('kg').value;
                FieldByName('t_sf').Value := FieldByName('qty').value * FieldByName('sf').value;
                FieldByName('QRcode').AsString := MY_QRCodeStr(FieldByName('Lot').AsString, FieldByName('qty').AsString,
                  FieldByName('t_kg').asstring);
                tmpList.Delete(0);
                tmpList.Delete(0);
                tmpList.Delete(0);
                j := tmpList.Count div 3;

                Next;
                Edit;
                if tmpList.Count = 3 then
                begin
                  FieldByName('LotDate').AsString := tmpList[0] + #13#10 + tmpList[1] + ' ' + tmpList[2];
                  FieldByName('Lot').AsString := tmpList[0];
                  FieldByName('qty').AsString := tmpList[2];
                  FieldByName('t_kg').Value := FieldByName('qty').value * FieldByName('kg').value;
                  FieldByName('t_sf').Value := FieldByName('qty').value * FieldByName('sf').value;
                  FieldByName('QRcode').AsString := MY_QRCodeStr(FieldByName('Lot').AsString, FieldByName('qty').AsString,
                    FieldByName('t_kg').asstring);
                end
                else
                begin
                  FieldByName('LotDate').AsString := tmpList.Text;
                  FieldByName('QRcode').AsString := MY_QRCodeStr(FieldByName('Lot').AsString, FieldByName('qty').AsString,
                    FieldByName('t_kg').asstring);
                end;
              end;
            end
            else if j = 1 then
            begin
              Edit;
              FieldByName('QRcode').AsString := MY_QRCodeStr(tmpList[0], FieldByName('qty').AsString, FieldByName('t_kg').asstring);
            end;
            next;
          end;
        end;
      finally
        tmpList2.free;
      end;
    end;
    
      if (Pos(custInfo.Name,'AC121/ACG02/AC820/ACA97/AC109')>0) then
      begin
        with FPrnCDS2 do
        begin
          first;
          while not eof do
          begin
            Edit;
            if not CD_QRCode then
              exit;
            next;
          end;
        end;
      end;

//    if (FPrnCDS1.FieldByName('Custno').AsString = 'AC597') then
//    begin
//      Data := null;
//      {(*}
//      tmpsql:=' select fname4,fname3,c.sno from dli010 a,dli041 b,lbl590 c where a.bu=b.bu and a.dno=b.dno ' +
//              ' and a.ditem=b.ditem and fname13=c.id and a.saleno=%s and a.saleitem=%d and bu=%s';     {*)}

      //      tmpsql:=format(tmpsql,[quotedstr(FPrnCDS1.fieldbyname('saleno').asstring),FPrnCDS2.fieldbyname('saleitem').AsString,quotedstr(g_uinfo^.BU)]);
//      if not querybysql( tmpsql,data) then
//        exit;
//      tmpCDS.Data := Data;
//      while not tmpcds.eof do
//      begin
//             {(*}

      //        sub := SO('{"CBARCODE":"","CSUPTABLE2_ID":"'+FieldByName('ogb03').AsString+'","QTY":"'+FieldByName('ogb12').AsString+'","CPRODUCTION_DATE":"'+GetPrdDate2(FieldByName('ogb092').AsString)+'","CSUPPLIER_LOT":"'+FieldByName('ogb092').AsString+'"}');
//        obj['SUPTABLE3'].AsArray.Add(sub);
//        tmpcds.next;
//      end;
//      showmsg(obj.Asjson);
//    end;          {(*}

    FPrnCDS1.MergeChangeLog;
    FPrnCDS2.MergeChangeLog;

    SetLength(ArrPrintData, 2);
    ArrPrintData[0].Data := FPrnCDS1.Data;
    ArrPrintData[0].RecNo := FPrnCDS1.RecNo;
    ArrPrintData[1].Data := FPrnCDS2.Data;
    ArrPrintData[1].RecNo := FPrnCDS2.RecNo;
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(Ima_CDS);
    FreeAndNil(tmpList);
  end;
  //聯茂非自用,不顯示批號
  if isPrnLot and (Pos(FPrnCDS1.FieldByName('Custno').AsString, 'N012,N005') > 0) and (Pos(LeftStr(FPrnCDS2.FieldByName('Pno').AsString,
    1), 'PQ') = 0) then
    isPrnLot := False;
  if (LeftStr(g_UInfo^.UserId,2)='IG') and (Pos(FPrnCDS1.FieldByName('Custno').AsString, 'N024,N006') > 0) and (Pos(LeftStr(FPrnCDS2.FieldByName('Pno').AsString,
    1), 'PQ') > 0) then
    isPrnLot := False;

  g_StatusBar.Panels[0].Text := '';
  Application.ProcessMessages;
  if isMore or isMX then
    GetPrintObj('Dli', ArrPrintData, 'DLII020_mx')
  else if isPrnLot then
    GetPrintObj('Dli', ArrPrintData, 'DLII020_A')
  else
    GetPrintObj('Dli', ArrPrintData, 'DLII020');
  ArrPrintData := nil;
end;

function TDLII020_prn.GetACF13Dno(dno: string): string;
var
  http: TidHttp;
  data: TStringStream;
  obj: ISuperObject;
  tmpstr,res: string;
begin
  result := '';
  exit;
  tmpstr :='{"bu":"'+g_uinfo^.BU+'","saleno":"'+dno+'"}';
  http := TIdHTTP.Create(nil);
  data := TStringStream.Create(tmpstr);

  try
    http.Request.ContentType := 'application/json';
    res := (http.Post('http://192.168.4.14:5000/api/acf13/CreateReceiving',data));
    obj := SO(res);
    if (obj['data']['success']<>nil) and  obj['data']['success'].asboolean then
    begin
      result := obj['data']['data'].asstring;
    end
    else if obj['data']['content'] <> nil then
    begin
      ShowMsg(GBToBIG5((obj['data']['content'].AsString)));
    end;
  finally
    http.free;
    data.free;
  end;
end;

function TDLII020_prn.SendJson(json, sno: string): string;
var
  http: TidHttp;
  data, deldata: TStringStream;
  obj: ISuperObject;
  delobj: ISuperObject;
  tmpstr: string;
begin
  tmpstr :=
    '{"FUNC_ID":"TBL_SRM_RECEIVING_003","HEAD_TABLE":"TBL_SRM_RECEIVING","TYPE":"ONLYUPDATE","SUPTABLE1":[{"CSOURCE_ID":"'
    + sno + '","CSUPPLIER":"0005"}]}';
  delobj := SO(tmpstr);
  http := TIdHTTP.Create(nil);
  data := TStringStream.Create(json);
  deldata := TStringStream.Create(delobj.AsJSon);
  try
    http.Request.ContentType := 'application/json';
    if SameText(g_uinfo^.UserId, 'ID150515') then
    begin
      ShowMsg(delobj.AsJSon);
      ShowMsg(json);
      exit;
    end;
    http.Post('http://113.108.243.170:6698/api/IFS/SynTable/SetMES', deldata);
    result := UTF8ToAnsi(http.Post('http://113.108.243.170:6698/api/IFS/SynTable/SetReceiving', data));
    obj := SO(result);
    if obj['data']['Success'].asboolean then
      result := obj['data']['Datas'].asstring
    else
    begin
      ShowMsg(GBToBIG5((obj['data']['Content'].AsString)));
      result := '';
    end;
  finally
    http.free;
    data.free;
    deldata.Free;
  end;
end;

function TDLII020_prn.MY_QRCodeStr(lot, qty, kg: string): string;
var
PrdDate2, LstDate2, plant,remark: string;
begin
  if trim(FPrnCDS2.FieldByName('Remark').AsString) = '' then
  begin
    raise exception.Create('備註不能是空');
  end;
  try

    PrdDate2 := GetPrdDate1(lot);
    LstDate2 := GetLstDate1(Pos(LeftStr(FPrnCDS2.FieldByName('Pno').AsString, 1), 'ET') = 0, PrdDate2);
    PrdDate2 := GetPrd_LstDate(PrdDate2);
    LstDate2 := GetPrd_LstDate(LstDate2);
    with FPrnCDS1 do
    begin
      if FieldByName('Custno').AsString = 'AC133' then
        plant := '01,'
      else if FieldByName('Custno').AsString = 'ACA28' then
        plant := '02,'
      else if FieldByName('Custno').AsString = 'ACE06' then
        plant := '03,';   
     {(*}
      if FieldByName('Custno').AsString = 'AC133' then
        remark:=COPY(FPrnCDS2.FieldByName('Remark').AsString,1,15)
      else
        remark:=FPrnCDS2.FieldByName('Remark').AsString;
      result := plant + FieldByName('Saleno').AsString+','+
                remark+','+
                lot+','+
                qty+','+
                kg+','+
                PrdDate2+','+
                LstDate2+',';
    end;
  except
    on ex: Exception do
    begin
      ShowMsg(ex.Message, 48);
    end;
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
function TDLII020_prn.CD_QRCode:boolean;
var
PrdDate2, LstDate2, tmpStr,lot: string;
begin
  result:=true;
  try
    with FPrnCDS2 do
    begin
      lot:= FieldByName('lot').AsString;
      PrdDate2 := GetPrdDate1(lot);
      LstDate2 := GetLstDate1(Pos(LeftStr(FieldByName('Pno').AsString, 1), 'ET') = 0, PrdDate2);
      PrdDate2 := GetPrd_LstDate(PrdDate2);
      LstDate2 := GetPrd_LstDate(LstDate2);
      if Pos(LeftStr(FieldByName('Pno').AsString, 1), 'ET') > 0 then
        tmpStr := 'PCS'
      else if Pos(LeftStr(FieldByName('Pno').AsString, 1), 'MN') > 0 then
        tmpStr := 'PN'
      else
        tmpStr := 'RL';
      {(*}
      tmpStr := '<z><a>' + FieldByName('C_Pno').AsString + '</a>' +
                '<b>' + FPrnCDS1.FieldByName('Saleno').AsString + '</b>' +
                '<c>' + FieldByName('orderitem').AsString + '</c>' +
                '<d>' + FloatToStr(FieldByName('Qty').AsFloat) + '</d>' +
                '<e>' + tmpStr + '</e>' +
                '<f>' + FieldByName('C_Orderno').AsString + '</f>' +
                '<g>' + FloatToStr(FieldByName('T_KG').AsFloat) + '</g>' +
                '<h>' + PrdDate2 + '</h>' +
                '<i>' + LstDate2 + '</i>' +
                '<j>' + lot + '</j></z>';    {*)}
      FieldByName('QRcode').AsString := tmpStr;
    end;
  except
    on ex: Exception do
    begin
      ShowMsg(ex.message);
      result:=false;
    end;
  end;
end;

procedure TDLII020_prn.Sp222_4C2008(oga01:string);
//222-4C2008   222-4C2009   222-4C2025   生益銷退，退江西，簽呈見附件
var
  tmpSQL,oga16: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  l_tmpFlag:=false;
  tmpSql:= 'select oga16 from oga_file where oga01='+QuotedStr(oga01);
  tmpCDS := TClientDataSet.Create(nil);
  try
    if QueryBySQL(tmpSQL, Data, FOraDB) then
    begin
      tmpCDS.Data := Data;
      oga16 := tmpCDS.Fields[0].AsString;
      l_tmpFlag:= Pos(oga16,'222-4C2008   222-4C2009   222-4C2025')>0;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.

