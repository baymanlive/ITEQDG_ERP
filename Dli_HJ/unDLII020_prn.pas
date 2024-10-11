{*******************************************************}
{                                                       }
{                unDLII020_prn                          }
{                Author: kaikai                         }
{                Create date: 2018/9/26                 }
{                Description: hj出貨單列印              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020_prn;

interface

uses
  Windows, Classes, SysUtils, DBClient, Forms, Variants, Math, Dialogs,
  StrUtils, DateUtils, ComCtrls, Controls, unGlobal, unCommon, TWODbarcode,
  unDLII020_const, unDLII020_AC101_remark;

const l_diff=0.000001;

//敬鵬、勝宏、崇達、競華、全成信
type
  TCRec = Packed Record
    JP,SH,CD,JH,QCX:Boolean;
end;

type
  TDLII020_prn = class
  private
    Fm_image : PTIMAGESTRUCT;
    FOraDB:string;
    FPrnCDS1:TClientDataSet;
    FPrnCDS2:TClientDataSet;
    procedure ShowBarHint(msg:string);
    function GetAddr(p_no,p_cus_no,p_add_no:string):string;
    function GetPnoKG(Saleno,Pno:string;Saleitem:Integer):Double;
    procedure CheckCust(Custno:string;var xRec:TCRec);
    function SetC_Sizes(DataSet:TClientDataSet;xFilter:string):Boolean;
    function GetLot(Saleno:string; isLocalLot:Boolean; var Data:OleVariant):Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure StartPrintDef(Saleno:string);
    procedure StartPrintCustomer(Saleno:string);
  end;

implementation

constructor TDLII020_prn.Create;
begin
  FOraDB:='ORACLE';
  FPrnCDS1:=TClientDataSet.Create(nil);
  FPrnCDS2:=TClientDataSet.Create(nil);
  InitCDS(FPrnCDS1, g_PrnCDS1Xml);
  InitCDS(FPrnCDS2, g_PrnCDS2Xml);
  PtInitImage(@Fm_image);
end;

destructor TDLII020_prn.Destroy;
begin
  FreeAndNil(FPrnCDS1);
  FreeAndNil(FPrnCDS2);
  PtFreeImage(@Fm_image);

  inherited;
end;

//狀態欄顯示信息
procedure TDLII020_prn.ShowBarHint(msg:string);
begin
  g_StatusBar.Panels[0].Text:=CheckLang(msg);
  Application.ProcessMessages;
end;

//送貨地址
function TDLII020_prn.GetAddr(p_no,p_cus_no,p_add_no:string):string;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if Length(p_add_no)=0 then
      tmpSQL:='SELECT occ241 FROM occ_file WHERE occ01='+Quotedstr(p_cus_no)
    else if SameText(p_add_no,'MISC') then
      tmpSQL:='SELECT oap041 FROM oap_file WHERE oap01='+Quotedstr(p_no)
    else
      tmpSQL:='SELECT ocd221 FROM ocd_file WHERE ocd01='+Quotedstr(p_cus_no)
             +' AND ocd02='+Quotedstr(p_add_no);
    if QueryBySQL(tmpSQL, Data, FOraDB) then
    begin
      tmpCDS.Data:=Data;
      Result:=tmpCDS.Fields[0].AsString;
    end else
      Result:='';
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//計算小料單重
function TDLII020_prn.GetPnoKG(Saleno,Pno:string;Saleitem:Integer):Double;
var
  tmpStr:string;
begin
  Result:=-1;
  tmpStr:=LeftStr(Pno,1);
  if (((tmpStr='E') or (tmpStr='T')) and (Length(Pno)=11)) or
     (((tmpStr='N') or (tmpStr='M')) and (Length(Pno)=12)) then
    Result:=GetKG(Saleno ,Saleitem, 0);
end;

//敬鵬、勝宏、崇達
procedure TDLII020_prn.CheckCust(Custno:string;var xRec:TCRec);
begin
  xRec.JP:=Pos(Custno,g_strJP)>0;
  xRec.SH:=Pos(Custno,g_strSH)>0;
  xRec.CD:=Pos(Custno,g_strCD)>0;
  xRec.JH:=Pos(Custno,g_strJH)>0;
  xRec.QCX:=Pos(Custno,g_strQCX)>0;
  //xRec.CD:=True;  測試
end;

//查詢訂單的客戶產品編號C_Orderno、客戶品名C_Pno、客戶規格C_Sizes
function TDLII020_prn.SetC_Sizes(DataSet:TClientDataSet; xFilter:string):Boolean;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=False;
  ShowBarHint('正在查詢[產品編號、客戶品名、客戶規格]...');
  tmpSQL:=' Select X.*,Y.oao04,Y.oao06 from ('
         +' Select oea04,oea10,oeb01,oeb03,oeb11,ta_oeb10,ta_oeb01,ta_oeb02,ta_oeb07'
         +' From oea_file Inner Join oeb_file'
         +' On oea01=oeb01 Where 1=2 '+xFilter+') X Left Join oao_file Y'
         +' On X.oeb01=Y.oao01 and X.oeb03=Y.oao03 and oao05=1'
         +' Order By oeb01,oeb03,oao04';
  if not QueryBySQL(tmpSQL, Data, FOraDB) then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with DataSet do
    begin
      First;
      while not Eof do
      begin
        if tmpCDS.Locate('oeb01;oeb03', VarArrayOf([FieldByName('Orderno').AsString,
           FieldByName('Orderitem').AsString]), []) then
        begin
          Edit;
          FieldByName('C_Orderno').AsString:=GetC_Orderno(tmpCDS.FieldByName('oea04').AsString,tmpCDS.FieldByName('oea10').AsString,tmpCDS.FieldByName('oao06').AsString);
          FieldByName('C_Pno').AsString:=tmpCDS.FieldByName('oeb11').AsString;
          FieldByName('C_Sizes').AsString:=tmpCDS.FieldByName('ta_oeb10').AsString;
          if SameText(FPrnCDS1.FieldByName('Custno').AsString,'ACB32') then
          begin
            if Pos('ITA-9300',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT968','ITA-9300',[])
            else if Pos('ITA-9310',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT150DA','ITA-9310',[])
            else if Pos('ITA-9320',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT150DA','ITA-9320',[])
            else if Pos('ITA-9350',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT150DA','ITA-9350',[])
            else if Pos('ITA-9380',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT150DA','ITA-9380',[])
            else if Pos('ITA-9430',FieldByName('C_Sizes').AsString)>0 then
               FieldByName('Pname').AsString:=StringReplace(FieldByName('Pname').AsString,'IT170GRA1','ITA-9430',[]);
          end;
          Post;
        end;
        Next;
      end;
    end;

    Result:=True;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

//取批號
function TDLII020_prn.GetLot(Saleno:string; isLocalLot:Boolean;
  var Data:OleVariant):Boolean;
var
  i:Integer;
  tmpSQL,tmpSFilter:string;
  tmpList:TStrings;
begin
  Result:=False;
  ShowBarHint('正在查詢[批號]...');
  Data:=null;
  if Pos(',',Saleno)>0 then
  begin
    tmpList:=TStringList.Create;
    try
      tmpList.DelimitedText:=Saleno;
      for i:=0 to tmpList.Count-1 do
        tmpSFilter:=tmpSFilter+','+Quotedstr(tmpList.Strings[i]);
      Delete(tmpSFilter,1,1);
      tmpSFilter:=' in ('+tmpSFilter+')';
    finally
      FreeAndNil(tmpList);
    end;
  end else
    tmpSFilter:='='+Quotedstr(Saleno);

  if isLocalLot then //PDA掃描批號MSSQL
  begin
    tmpSQL:='Select A.Saleno ogb01,A.Saleitem ogb03,B.Manfac1 ogb092,Sum(B.Qty) ogb12'
           +' From DLI010 A Inner Join DLI020 B'
           +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
           +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
           +' And A.Saleno'+tmpSFilter+' And IsNull(B.JFlag,0)=0'
           +' Group By A.Saleno,A.Saleitem,B.Manfac1'
           +' Order By A.Saleno,A.Saleitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
  end
  else begin         //tiptop扣帳批號
    tmpSQL:='Select ogb01,ogb03,ogb092,Sum(ogb12) ogb12'
           +' From (Select ogb01,ogb03,ogb092,ogb12 From ogb_file'
           +' Where ogb01'+tmpSFilter+' and ogb17=''N'''
           +' Union All'
           +' Select ogc01,ogc03,ogc092,ogc12 From ogc_file'
           +' Where ogc01'+tmpSFilter+') A'
           +' Group By ogb01,ogb03,ogb092'
           +' Order By ogb01,ogb03';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
  end;
  Result:=True;
end;

//注意：報表設定中(報表文件fr3)包含關鍵詞"出貨單"才更新打印次數
//送貨明細,多個saleno用逗號連接
procedure TDLII020_prn.StartPrintDef(Saleno:string);
var
  i,kgdeci,totkgdeci,sfdeci,totsfdeci:Integer;
  isMore,isPrnLot,isLocalLot:Boolean;
  cRec:TCRec;
  tmpKG:Double;
  tmpSQL,tmpstr1,tmpstr2,tmpstr3,tmpSFilter:string;
  tmpList:TStrings;
  Data:OleVariant;
  tmpCDS,Ima_CDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  if Length(Saleno)=0 then
  begin
    ShowMsg('請輸入銷貨單號!', 48);
    Exit;
  end;

  tmpList:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  Ima_CDS:=TClientDataSet.Create(nil);
  try
    tmpList.DelimitedText:=Saleno;
    isMore:=tmpList.Count>1;
    if isMore then    //多個單號檢查是否同一客戶,是否扣帳,是否相同產品別
    begin
      tmpSQL:=LeftStr(tmpList.Strings[0],3);
      for i:=0 to tmpList.Count-1 do
      begin
        if tmpSQL<>LeftStr(tmpList.Strings[i],3) then
        begin
          ShowMsg('單別不相同不可打印在一起!', 48);
          Exit;
        end;

        tmpSFilter:=tmpSFilter+','+Quotedstr(tmpList.Strings[i]);
      end;

      Delete(tmpSFilter,1,1);
      tmpSQL:='Select distinct oga01,oga04,ogapost,case when substr(ogb04,1,1) in (''A'',''E'',''U'') then 1 else 0 end ptype'
             +' From oga_file,ogb_file where oga01=ogb01 and oga01 in ('+tmpSFilter+')';
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
         Exit;
      tmpCDS.Data:=Data;
      for i:=0 to tmpList.Count-1 do
      if not tmpCDS.Locate('oga01',tmpList.Strings[i],[]) then
      begin
        ShowMsg(tmpList.Strings[i]+'出貨單據不存在!', 48);
        Exit;
      end;

      if tmpCDS.Locate('ptype',1,[]) then
        if tmpCDS.Locate('ptype',0,[]) then
      begin
        ShowMsg('產品別不同,不可打印在一起!', 48);
        Exit;
      end;

      tmpCDS.First;
      tmpSQL:=tmpCDS.FieldByName('oga04').AsString;
      while not tmpCDS.Eof do
      begin
        if tmpCDS.FieldByName('oga04').AsString<>'AC096' then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString+'不是名幸客戶,不可列印!', 48);
          Exit;
        end;

        if tmpSQL<>tmpCDS.FieldByName('oga04').AsString then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString+'客戶不相同,不可列印!', 48);
          Exit;
        end;

        if tmpCDS.FieldByName('ogapost').AsString<>'Y' then
        begin
          ShowMsg(tmpCDS.FieldByName('oga01').AsString+'單據未扣帳,不可列印!', 48);
          Exit;
        end;

        tmpCDS.Next;
      end;
    end;

    //TipTop單頭(oga00單別、gen02業務員、gem02部門)
    ShowBarHint('正在查詢[出貨單單頭]資料...');
    Data:=null;
    tmpSQL:='Select X.*,Y.gem02'
           +' From (Select C.*,D.gen02'
           +' From (Select A.*, Concat(B.smyslip,B.smydesc) oga00'
           +' From (Select oga01,oga02,oga04,oga044,oga14,oga15,oga23,oga24,'
           +'         ogauser,ogapost,ogaprsw,occ01,occ02,occ18'
           +' From oga_file Inner Join occ_file'
           +' ON oga04=occ01 Where oga01='+Quotedstr(tmpList.Strings[0])+') A Left Join smy_file B'
           +' ON Substr(A.oga01,1,3)=B.smyslip) C Left Join gen_file D'
           +' ON C.oga14=D.gen01) X Left Join gem_file Y'
           +' ON X.oga15=Y.gem01';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
    tmpCDS.Data:=Data;

    if tmpCDS.IsEmpty then
    begin
      ShowMsg(tmpList.Strings[0]+'出貨單據不存在!', 48);
      Exit;
    end;

    if tmpCDS.FieldByName('ogapost').AsString<>'Y' then
    begin
      ShowMsg(tmpList.Strings[0]+'單據未扣帳,不可列印!', 48);
      Exit;
    end;

    CheckCust(tmpCDS.FieldByName('occ01').AsString, cRec);

    while not FPrnCDS1.IsEmpty do
      FPrnCDS1.Delete;
    while not FPrnCDS2.IsEmpty do
      FPrnCDS2.Delete;

    with FPrnCDS1 do
    begin
      Append;
      FieldByName('Saleno').AsString:=tmpCDS.FieldByName('oga01').AsString;
      FieldByName('Saleno1').AsString:=RightStr(tmpCDS.FieldByName('oga01').AsString,6);
      FieldByName('Saledate').AsString:=tmpCDS.FieldByName('oga02').AsString;
      FieldByName('Saletype').AsString:=tmpCDS.FieldByName('oga00').AsString;
      FieldByName('Salesno').AsString:=tmpCDS.FieldByName('oga14').AsString;
      FieldByName('Salesname').AsString:=tmpCDS.FieldByName('gen02').AsString;
      FieldByName('Deptno').AsString:=tmpCDS.FieldByName('oga15').AsString;
      FieldByName('Dept').AsString:=tmpCDS.FieldByName('gem02').AsString;
      FieldByName('Cashtype').AsString:=tmpCDS.FieldByName('oga23').AsString;
      FieldByName('Rate').AsString:=tmpCDS.FieldByName('oga24').AsString;
      FieldByName('Custno').AsString:=tmpCDS.FieldByName('occ01').AsString;
      FieldByName('Custabs').AsString:=tmpCDS.FieldByName('occ02').AsString;
      FieldByName('Custom').AsString:=tmpCDS.FieldByName('occ18').AsString;
      FieldByName('Custno_addr').AsString:=tmpCDS.FieldByName('oga04').AsString;
      FieldByName('SendAddr').AsString:=tmpCDS.FieldByName('oga044').AsString;
      FieldByName('Dealer').AsString:=tmpCDS.FieldByName('ogauser').AsString;
      FieldByName('Printcnt').AsString:=IntToStr(tmpCDS.FieldByName('ogaprsw').AsInteger);
      if isMore then
         FieldByName('MoreSaleno').AsString:=Saleno;
      Post;
    end;

    //送貨地址
    ShowBarHint('正在查詢[送貨地址]...');
    tmpSQL:=GetAddr(FPrnCDS1.FieldByName('Saleno').AsString,
                    Trim(FPrnCDS1.FieldByName('Custno_addr').AsString),
                    Trim(FPrnCDS1.FieldByName('SendAddr').AsString));
    with FPrnCDS1 do
    begin
      Edit;
      FieldByName('SendAddr').AsString:=tmpSQL;
      Post;
    end;

    //製表人Dealer、品保人COC_user、核准人Check_user
    ShowBarHint('正在查詢[製表人、品保人、核准人]...');
    Data:=null;
    tmpSQL:='exec dbo.proc_GetCOCName '+Quotedstr(g_UInfo^.BU)+','+
            Quotedstr(tmpList.Strings[0])+','+
            Quotedstr(FPrnCDS1.FieldByName('Dealer').AsString);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    with FPrnCDS1 do
    begin
      Edit;
      FieldByName('Dealer').AsString:=tmpCDS.Fields[0].AsString;
      FieldByName('COC_user').AsString:=tmpCDS.Fields[1].AsString;
      FieldByName('Check_user').AsString:=tmpCDS.Fields[2].AsString;
      Post;
    end;
    if Trim(FPrnCDS1.FieldByName('Dealer').AsString)='' then
    begin
      FPrnCDS1.Edit;
      FPrnCDS1.FieldByName('Dealer').AsString:=g_UInfo^.UserName;
      FPrnCDS1.Post;
    end;

    //單重,總重小數位
    ShowBarHint('正在查詢[格式化字符串]...');
    Data:=null;
    tmpSQL:='exec dbo.proc_GetKGFormat '+Quotedstr(g_UInfo^.BU)+','+
            Quotedstr(FPrnCDS1.FieldByName('Custno').AsString);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with FPrnCDS1 do
    begin
      Edit;
      FieldByName('QtyFormat').AsString:=tmpCDS.FieldByName('qtyformat').AsString;
      FieldByName('KgFormat').AsString:=tmpCDS.FieldByName('kgformat').AsString;
      FieldByName('TotKgFormat').AsString:=tmpCDS.FieldByName('totkgformat').AsString;
      FieldByName('SfFormat').AsString:=tmpCDS.FieldByName('sfformat').AsString;
      FieldByName('TotSfFormat').AsString:=tmpCDS.FieldByName('totsfformat').AsString;
      Post;
    end;
    kgdeci:=-tmpCDS.FieldByName('kgdeci').AsInteger;
    totkgdeci:=-tmpCDS.FieldByName('totkgdeci').AsInteger;
    sfdeci:=-tmpCDS.FieldByName('sfdeci').AsInteger;
    totsfdeci:=-tmpCDS.FieldByName('totsfdeci').AsInteger;

    //二維碼圖片存放目錄
    //銷貨單2維碼
    tmpSQL:=g_UInfo^.TempPath+FPrnCDS1.FieldByName('Saleno').AsString+'.bmp';
    if getcode(FPrnCDS1.FieldByName('Saleno').AsString, tmpSQL, Fm_image) then
    begin
      FPrnCDS1.Edit;
      FPrnCDS1.FieldByName('QRCodeSaleno').AsString:=tmpSQL;
      FPrnCDS1.Post;
    end;
    //end l_PrnCDS1

    //出貨單是否列印批號,是否帶pda掃描批號
    Data:=null;
    tmpSQL:='select isprnlot,islocallot from dli026'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and custno='+Quotedstr(FPrnCDS1.FieldByName('Custno').AsString);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    isPrnLot:=tmpCDS.Fields[0].AsBoolean;
    isLocalLot:=tmpCDS.Fields[1].AsBoolean;

    //begin l_PrnCDS2
    //單身tmpCDS
    ShowBarHint('正在查詢[出貨單單身]資料...');
    Data:=null;
    tmpSQL:='Select A.*,B.ta_oeb01,B.ta_oeb02 From ogb_file A,oeb_file B'
           +' Where ogb31=oeb01 and ogb32=oeb03';
    if isMore then
       tmpSQL:=tmpSQL+' and ogb01 in ('+tmpSFilter+')'
    else
       tmpSQL:=tmpSQL+' and ogb01='+Quotedstr(tmpList.Strings[0]);
    tmpSQL:=tmpSQL+' Order By ogb01,ogb03';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
    tmpCDS.Data:=Data;
    if isMore then
    begin
      for i:=0 to tmpList.Count-1 do
      if not tmpCDS.Locate('ogb01',tmpList.Strings[0],[]) then
      begin
        ShowMsg(tmpList.Strings[0]+'單身檔無資料!',48);
        Exit;
      end;
    end
    else if tmpCDS.IsEmpty then
    begin
      ShowMsg('單身檔無資料!',48);
      Exit;
    end;

    //查詢產品檔條件tmpstr1,訂單檔備註檔條件tmpstr2,訂單檔條件tmpstr3
    with tmpCDS do
    while not Eof do
    begin
      tmpstr1:=tmpstr1+' or Ima01='+Quotedstr(FieldByName('ogb04').AsString);
      tmpstr2:=tmpstr2+' or (oao01='+Quotedstr(FieldByName('ogb31').AsString)
                      +' and oao03='+FieldByName('ogb32').AsString
                      +' and oao05=2)';
      tmpstr3:=tmpstr3+' or (oeb01='+Quotedstr(FieldByName('ogb31').AsString)
                      +' and oeb03='+FieldByName('ogb32').AsString+')';
      Next;
    end;

    //產品資料
    ShowBarHint('正在查詢[產品資料]...');
    tmpSQL:='Select ima01,ima02,ima021,ima18,ta_ima01,ta_ima02 From ima_file'
           +' Where 1=2 '+tmpstr1;
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
    Ima_CDS.Data:=Data;

    tmpCDS.First;
    with FPrnCDS2 do
    begin
      while not tmpCDS.Eof do
      begin
        Append;
        FieldByName('Dno').AsString:=tmpCDS.FieldByName('ogb01').AsString;
        FieldByName('Ditem').AsString:=tmpCDS.FieldByName('ogb03').AsString;
        FieldByName('Orderno').AsString:=tmpCDS.FieldByName('ogb31').AsString;
        FieldByName('Orderitem').AsString:=tmpCDS.FieldByName('ogb32').AsString;
        FieldByName('Pno').AsString:=tmpCDS.FieldByName('ogb04').AsString;
        FieldByName('Units').AsString:=tmpCDS.FieldByName('ogb05').AsString;
        FieldByName('Qty').AsFloat:=tmpCDS.FieldByName('ogb12').AsFloat;
        if SameText(FieldByName('Units').AsString,'RL') and (Length(FieldByName('Pno').AsString)=18) then
           FieldByName('Qty_m').AsFloat:=FieldByName('Qty').AsFloat*StrToInt(Copy(FieldByName('Pno').AsString,11,3))
        else
           FieldByName('Qty_m').AsFloat:=FieldByName('Qty').AsFloat*tmpCDS.FieldByName('ogb05_fac').AsFloat;
        //重量、面積
        tmpSQL:=FieldByName('Pno').AsString;
        if Ima_CDS.Locate('ima01', tmpSQL, []) or
           Ima_CDS.Locate('ima01', FieldByName('Pno').AsString, []) then
        begin
          //品名、規格以物料檔為準
          FieldByName('Pname').AsString:=Ima_CDS.FieldByName('ima02').AsString;
          FieldByName('Sizes').AsString:=Ima_CDS.FieldByName('ima021').AsString;

          tmpKG:=GetPnoKG(tmpCDS.FieldByName('ogb01').AsString,
                          tmpCDS.FieldByName('ogb04').AsString,
                          tmpCDS.FieldByName('ogb03').AsInteger);
          if tmpKG=-1 then
             FieldByName('KG').AsFloat:=Ima_CDS.FieldByName('ima18').AsFloat
          else
             FieldByName('KG').AsFloat:=tmpKG;

          if SameText(FieldByName('Units').AsString,'RL') and (Length(FieldByName('Pno').AsString)=18) then
             FieldByName('KG').AsFloat:=RoundTo(StrToInt(Copy(FieldByName('Pno').AsString,11,3))*FieldByName('KG').AsFloat+l_diff,kgdeci)
          else
             FieldByName('KG').AsFloat:=RoundTo(tmpCDS.FieldByName('ogb05_fac').AsFloat*FieldByName('KG').AsFloat+l_diff,kgdeci);
          FieldByName('T_KG').AsFloat:=RoundTo(FieldByName('Qty').AsFloat*FieldByName('KG').AsFloat+l_diff,totkgdeci);

          tmpSQL:=LeftStr(FieldByName('Pno').AsString,1); //第1碼
          if (tmpSQL='M') or (tmpSQL='N') then
             FieldByName('SF').AsFloat:=RoundTo((tmpCDS.FieldByName('ta_oeb01').AsFloat*
              tmpCDS.FieldByName('ta_oeb02').AsFloat)/144+l_diff,sfdeci)
          else if tmpSQL='R' then
             FieldByName('SF').AsFloat:=RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat*
              Ima_CDS.FieldByName('ta_ima02').AsFloat*39.37)/144+l_diff,sfdeci)
          else
             FieldByName('SF').AsFloat:=RoundTo((Ima_CDS.FieldByName('ta_ima01').AsFloat*
              Ima_CDS.FieldByName('ta_ima02').AsFloat)/144*tmpCDS.FieldByName('ogb05_fac').AsFloat+l_diff,sfdeci);

          if ((tmpSQL='R') or (tmpSQL='B')) and
             (FPrnCDS1.FieldByName('Custno_addr').AsString='AC091') and
             (Copy(FieldByName('Pno').AsString,14,3)='428') then
             FieldByName('SF').AsFloat:=RoundTo((tmpCDS.FieldByName('ogb05_fac').AsFloat*42.85*39.37)/144+l_diff,sfdeci);

          FieldByName('T_SF').AsFloat:=RoundTo(FieldByName('Qty').AsFloat*FieldByName('SF').AsFloat+l_diff,totsfdeci);

          if (FPrnCDS1.FieldByName('Custno').AsString='AC148') or
             (FPrnCDS1.FieldByName('Custno_addr').AsString='AC148') then
          begin
            if (tmpSQL='B') or (tmpSQL='R') or (tmpSQL='P') then
            begin
              if tmpCDS.FieldByName('ogb05_fac').AsFloat=150 then
              begin
                //FieldByName('SF').AsFloat:=1968.5;
                FieldByName('T_SF').AsFloat:=1968.5*FieldByName('Qty').AsFloat;
              end else
              if tmpCDS.FieldByName('ogb05_fac').AsFloat=200 then
              begin
                //FieldByName('SF').AsFloat:=2624.7;
                FieldByName('T_SF').AsFloat:=2624.7*FieldByName('Qty').AsFloat;
              end else
              if tmpCDS.FieldByName('ogb05_fac').AsFloat=300 then
              begin
                //FieldByName('SF').AsFloat:=3937;
                FieldByName('T_SF').AsFloat:=3937*(FieldByName('Qty').AsFloat);
              end;
            end
            else if (tmpSQL='M') or (tmpSQL='N') then
            begin
              FieldByName('T_SF').AsFloat:=RoundTo(FieldByName('Qty').AsFloat*
                ((tmpCDS.FieldByName('ta_oeb01').AsFloat*tmpCDS.FieldByName('ta_oeb02').AsFloat)/144)+l_diff,-2);
              //FieldByName('SF').AsFloat:=RoundTo(FieldByName('T_SF').AsFloat/FieldByName('Qty').AsFloat,-3);
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
    Data:=null;
    tmpSQL:='select oao01,oao03,listagg(oao06,'','') within group (order by oao04) as oao06'
           +' from oao_file where 1=2 '+tmpstr2
           +' group by oao01,oao03';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
    tmpCDS.Data:=Data;
    with FPrnCDS2 do
    begin
      First;
      while not Eof do
      begin
        if tmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('Orderno').AsString,
           FieldByName('Orderitem').AsString]), []) then
        begin
          Edit;
          FieldByName('Remark').AsString:=tmpCDS.FieldByName('oao06').AsString;
          Post;
        end;
        Next;
      end;
    end;

    //客戶產品編號、客戶品名、客戶規格
    if not SetC_Sizes(FPrnCDS2, tmpstr3) then
       Exit;

    //批號
    Data:=null;
    if not GetLot(Saleno, isLocalLot, Data) then
       Exit;
    tmpCDS.Data:=Data;
    if isMore then
    begin
      for i:=0 to tmpList.Count-1 do
      if not tmpCDS.Locate('ogb01',tmpList.Strings[0],[]) then
      begin
        ShowMsg(tmpList.Strings[0]+'批號檔無資料!',48);
        Exit;
      end;
    end
    else if tmpCDS.IsEmpty then
    begin
      ShowMsg('批號檔無資料!',48);
      Exit;
    end;

    FPrnCDS2.First;
    while not FPrnCDS2.Eof do
    begin
      tmpStr1:='';
      with tmpCDS do
      begin
        Filtered:=False;
        Filter:='ogb01='+Quotedstr(FPrnCDS2.FieldByName('Dno').AsString)
               +' And ogb03='+IntToStr(FPrnCDS2.FieldByName('Ditem').AsInteger);
        Filtered:=True;
        IndexFieldNames:='ogb092';
        while not Eof do
        begin
          //if then //批號后面顯示數量
          //   tmpStr1:=tmpStr1+FieldByName('ogb092').AsString+' '+FieldByName('ogb12').AsString+#13#10
          //else begin
          tmpStr1:=tmpStr1+FieldByName('ogb092').AsString+#13#10;

          Next;
        end;
      end;

      with FPrnCDS2 do
      begin
        Edit;
        FieldByName('Lot').AsString:=Trim(tmpStr1);
        if isMore then
        begin
          tmpSQL:=g_UInfo^.TempPath+FieldByName('Dno').AsString+'@'+IntToStr(FieldByName('Ditem').AsInteger)+'.bmp';
          if getcode(FieldByName('Dno').AsString, tmpSQL, Fm_image) then
             FieldByName('QRcode').AsString:=tmpSQL;
        end;
        Post;
      end;
      FPrnCDS2.Next;
    end;

    //tmpCDS.Filtered:=False;
    //tmpCDS.IndexFieldNames:='';

    FPrnCDS1.MergeChangeLog;
    FPrnCDS2.MergeChangeLog;

    SetLength(ArrPrintData, 2);
    ArrPrintData[0].Data:=FPrnCDS1.Data;
    ArrPrintData[0].RecNo:=FPrnCDS1.RecNo;
    ArrPrintData[1].Data:=FPrnCDS2.Data;
    ArrPrintData[1].RecNo:=FPrnCDS2.RecNo;
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(Ima_CDS);
    FreeAndNil(tmpList);
  end;

  g_StatusBar.Panels[0].Text:='';
  Application.ProcessMessages;
  if isPrnLot then
     GetPrintObj('Dli', ArrPrintData, 'DLII020_A')
  else
     GetPrintObj('Dli', ArrPrintData, 'DLII020');
  ArrPrintData:=nil;
end;

//客戶送貨單
procedure TDLII020_prn.StartPrintCustomer(Saleno:string);
var
  tmpQty,tmpKG:Double;
  cRec:TCRec;
  isAC101:Boolean;
  tmpSQL,tmpStr1,tmpStr2:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2,Ima_CDS,Oao_CDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  if Length(Saleno)=0 then
  begin
    ShowMsg('請輸入銷貨單號!', 48);
    Exit;
  end;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  Ima_CDS:=TClientDataSet.Create(nil);
  Oao_CDS:=TClientDataSet.Create(nil);
  try
    ShowBarHint('正在查詢[出貨單]資料...');
    tmpSQL:='select y.*,oeb05,oeb11,ta_oeb10'
           +' from(select x.*,oea10'
           +' from(select oga02,oga04,ogapost,ogb01,ogb03,ogb04,ogb12,ogb31,ogb32'
           +' from oga_file,ogb_file'
           +' where oga01=ogb01 and oga01='+Quotedstr(Saleno)+') x,oea_file'
           +' where ogb31=oea01) y,oeb_file'
           +' where ogb31=oeb01 and ogb32=oeb03'
           +' order by ogb01,ogb03';
    if not QueryBySQL(tmpSQL, Data, FOraDB) then
       Exit;
    tmpCDS1.Data:=Data;

    if tmpCDS1.IsEmpty then
    begin
      ShowMsg(Saleno+'出貨單據不存在!', 48);
      Exit;
    end;

    if tmpCDS1.FieldByName('ogapost').AsString<>'Y' then
    begin
      ShowMsg(Saleno+'單據未扣帳,不可列印!', 48);
      Exit;
    end;

    CheckCust(tmpCDS1.FieldByName('oga04').AsString, cRec);
    if (not cRec.JP) and (not cRec.JH) and (not cRec.QCX) then
    begin
      ShowMsg('['+tmpCDS1.FieldByName('oga04').AsString+']無客戶送貨單格式!', 48);
      Exit;
    end;

    //批號
    Data:=null;
    if not GetLot(Saleno, True, Data) then
       Exit;
    tmpCDS2.Data:=Data;
    if tmpCDS2.IsEmpty then
    begin
      ShowMsg('批號檔無資料!',48);
      Exit;
    end;

    tmpCDS1.First;
    tmpCDS2.First;
    while not tmpCDS1.Eof do
    begin
      tmpCDS2.Filtered:=False;

      if not tmpCDS2.Locate('ogb01;ogb03',VarArrayOf([tmpCDS1.FieldByName('ogb01').AsString,tmpCDS1.FieldByName('ogb03').AsString]),[]) then
      begin
        ShowMsg('出貨排程資料無此出貨單項次['+tmpCDS2.FieldByName('ogb03').AsString+']!', 48);
        Exit;
      end;

      tmpQty:=0;
      tmpCDS2.Filter:='ogb01='+Quotedstr(tmpCDS1.FieldByName('ogb01').AsString)
                     +' and ogb03='+IntToStr(tmpCDS1.FieldByName('ogb03').AsInteger);
      tmpCDS2.Filtered:=True;
      while not tmpCDS2.Eof do
      begin
        tmpQty:=tmpQty+tmpCDS2.FieldByName('ogb12').AsFloat;
        tmpCDS2.Next;
      end;

      if tmpQty<>tmpCDS1.FieldByName('ogb12').AsFloat then
      begin
        ShowMsg('第'+tmpCDS1.FieldByName('ogb03').AsString+'項,出貨單數量與檢貨數量不一致!', 48);
        Exit;
      end;

      tmpCDS1.Next;
    end;

    while not FPrnCDS2.IsEmpty do
      FPrnCDS2.Delete;

    if cRec.JH then
    begin
      with tmpCDS1 do
      begin
        First;
        while not Eof do
        begin
          tmpStr1:=tmpStr1+' or ima01='+Quotedstr(FieldByName('ogb04').AsString);
          tmpstr2:=tmpstr2+' or (oao01='+Quotedstr(FieldByName('ogb31').AsString)
                          +' and oao03='+FieldByName('ogb32').AsString+')';
          Next;
        end;
      end;

      //產品資料
      ShowBarHint('正在查詢[產品資料]...');
      Data:=null;
      tmpSQL:='select ima01,ima02,ima021,ima18,ta_ima01,ta_ima02 from ima_file'
             +' where 1=2 '+tmpStr1;
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
         Exit;
      Ima_CDS.Data:=Data;

      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        with FPrnCDS2 do
        begin
          Append;
          FieldByName('dno').AsString:=tmpCDS1.FieldByName('ogb01').AsString;
          FieldByName('ditem').AsString:=tmpCDS1.FieldByName('ogb03').AsString;
          FieldByName('orderno').AsString:=tmpCDS1.FieldByName('ogb31').AsString;
          FieldByName('orderitem').AsString:=tmpCDS1.FieldByName('ogb32').AsString;
          FieldByName('c_orderno').AsString:=tmpCDS1.FieldByName('oea10').AsString;
          FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('oeb11').AsString;
          FieldByName('c_sizes').AsString:=tmpCDS1.FieldByName('ta_oeb10').AsString;
          if SameText(tmpCDS1.FieldByName('oeb05').AsString,'RL') then
             FieldByName('units').AsString:='M'
          else
             FieldByName('units').AsString:=tmpCDS1.FieldByName('oeb05').AsString;
          FieldByName('qty').AsFloat:=tmpCDS1.FieldByName('ogb12').AsFloat;

          if Ima_CDS.Locate('ima01', tmpCDS1.FieldByName('ogb04').AsString, []) then
          begin
            tmpKG:=GetPnoKG(tmpCDS1.FieldByName('ogb01').AsString,
                            tmpCDS1.FieldByName('ogb04').AsString,
                            tmpCDS1.FieldByName('ogb03').AsInteger);
            if tmpKG=-1 then
               FieldByName('kg').AsFloat:=Ima_CDS.FieldByName('ima18').AsFloat
            else
               FieldByName('kg').AsFloat:=tmpKG;
            FieldByName('t_kg').AsFloat:=RoundTo(FieldByName('qty').AsFloat*FieldByName('kg').AsFloat+l_diff,-3);
          end;

          Post;
        end;

        tmpCDS1.Next;
      end;

      //訂單備註
      ShowBarHint('正在查詢[訂單備註]...');
      Data:=null;
      tmpSQL:='select oao01,oao03,listagg(oao06,'','') within group (order by oao04) as oao06'
             +' from oao_file where 1=2 '+tmpstr2
             +' group by oao01,oao03';
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
         Exit;
      Oao_CDS.Data:=Data;
      with FPrnCDS2 do
      begin
        First;
        while not Eof do
        begin
          if Oao_CDS.Locate('oao01;oao03', VarArrayOf([FieldByName('Orderno').AsString,
             FieldByName('Orderitem').AsString]), []) then
          begin
            Edit;
            FieldByName('remark').AsString:=Oao_CDS.FieldByName('oao06').AsString;
            Post;
          end;
          Next;
        end;
      end;
    end
    else if cRec.JP then
    begin
      tmpCDS2.Filtered:=False;
      tmpCDS2.First;
      while not tmpCDS2.Eof do
      begin
        tmpCDS1.Locate('ogb01;ogb03',VarArrayOf([tmpCDS2.FieldByName('ogb01').AsString,tmpCDS2.FieldByName('ogb03').AsString]),[]);

        with FPrnCDS2 do
        begin
          Append;
          FieldByName('dno').AsString:=tmpCDS2.FieldByName('ogb01').AsString;
          FieldByName('ditem').AsString:=tmpCDS2.FieldByName('ogb03').AsString;
          FieldByName('c_orderno').AsString:=tmpCDS1.FieldByName('oea10').AsString;
          FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('oeb11').AsString;
          FieldByName('c_sizes').AsString:=tmpCDS1.FieldByName('ta_oeb10').AsString;
          FieldByName('orderno').AsString:=tmpCDS1.FieldByName('oga02').AsString;   //單據日期
          FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('ogb12').AsFloat;
          FieldByName('prddate1').AsString:=LeftStr(IntToStr(YearOf(Date)),2)+Copy(tmpCDS2.FieldByName('ogb092').AsString,3,6);
          FieldByName('lot').AsString:=tmpCDS2.FieldByName('ogb092').AsString;
          if cRec.JP then
          begin
            tmpSQL:=g_UInfo^.TempPath+FieldByName('dno').AsString+'@'+IntToStr(FieldByName('ditem').AsInteger)+'@'+IntToStr(RecNo)+'.bmp';
            if getcode('$D'+'A33B;'+FieldByName('dno').AsString, tmpSQL, Fm_image) then
               FieldByName('qrcode').AsString:=tmpSQL;
          end;
          Post;
        end;
        tmpCDS2.Next;
      end;
    end else //cRec.CQX
    begin
      with tmpCDS1 do
      begin
        First;
        while not Eof do
        begin
          tmpStr1:=tmpStr1+' or ima01='+Quotedstr(FieldByName('ogb04').AsString);
          Next;
        end;
      end;

      //產品資料
      ShowBarHint('正在查詢[產品資料]...');
      Data:=null;
      tmpSQL:='select ima01,ima02,ima021,ima18,ta_ima01,ta_ima02 from ima_file'
             +' where 1=2 '+tmpStr1;
      if not QueryBySQL(tmpSQL, Data, FOraDB) then
         Exit;
      Ima_CDS.Data:=Data;

      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        with FPrnCDS2 do
        begin
          Append;
          FieldByName('dno').AsString:=tmpCDS1.FieldByName('ogb01').AsString;
          FieldByName('ditem').AsInteger:=tmpCDS1.FieldByName('ogb03').AsInteger;
          FieldByName('c_orderno').AsString:=tmpCDS1.FieldByName('oea10').AsString;
          FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('oeb11').AsString;
          FieldByName('c_sizes').AsString:=tmpCDS1.FieldByName('ta_oeb10').AsString;
          if SameText(tmpCDS1.FieldByName('oeb05').AsString,'SH') then
             FieldByName('units').AsString:=CheckLang('張')
          else if SameText(tmpCDS1.FieldByName('oeb05').AsString,'RL') then
             FieldByName('units').AsString:=CheckLang('卷')
          else if SameText(tmpCDS1.FieldByName('oeb05').AsString,'PN') then
             FieldByName('units').AsString:=CheckLang('片')
          else
             FieldByName('units').AsString:=tmpCDS1.FieldByName('oeb05').AsString;
          FieldByName('qty').AsFloat:=tmpCDS1.FieldByName('ogb12').AsFloat;
          FieldByName('remark').AsString:=g_UInfo^.UserName;   //經辦人

          if Ima_CDS.Locate('ima01', tmpCDS1.FieldByName('ogb04').AsString, []) then
          begin
            tmpKG:=GetPnoKG(tmpCDS1.FieldByName('ogb01').AsString,
                            tmpCDS1.FieldByName('ogb04').AsString,
                            tmpCDS1.FieldByName('ogb03').AsInteger);
            if tmpKG=-1 then
               FieldByName('kg').AsFloat:=Ima_CDS.FieldByName('ima18').AsFloat
            else
               FieldByName('kg').AsFloat:=tmpKG;
            FieldByName('t_kg').AsFloat:=RoundTo(FieldByName('qty').AsFloat*FieldByName('kg').AsFloat+l_diff,-3);
          end;

          Post;
        end;

        tmpCDS1.Next;
      end;
    end;

    FPrnCDS2.MergeChangeLog;
    isAC101:=cRec.JH and (LeftStr(FPrnCDS2.FieldByName('orderno').AsString,3)='22X');
    if isAC101 and (not FPrnCDS2.IsEmpty) then
    begin
      FrmDLII020_AC101_remark:=TFrmDLII020_AC101_remark.Create(nil);
      try
        FrmDLII020_AC101_remark.SetData(FPrnCDS2);
        if FrmDLII020_AC101_remark.ShowModal=mrOK then
           FrmDLII020_AC101_remark.GetData(FPrnCDS2);
      finally
        FreeAndNil(FrmDLII020_AC101_remark);
      end;
    end;
    SetLength(ArrPrintData, 1);
    ArrPrintData[0].Data:=FPrnCDS2.Data;
    ArrPrintData[0].RecNo:=FPrnCDS2.RecNo;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(Ima_CDS);
    FreeAndNil(Oao_CDS);
  end;

  g_StatusBar.Panels[0].Text:='';
  Application.ProcessMessages;
  if cRec.JH then
  begin
    if isAC101 then
       GetPrintObj('Dli', ArrPrintData, 'DLII020_AC101_2')
    else
       GetPrintObj('Dli', ArrPrintData, 'DLII020_AC101_1');
  end
  else if cRec.JP then
     GetPrintObj('Dli', ArrPrintData, 'DLII020_JP')
  else
     GetPrintObj('Dli', ArrPrintData, 'DLII020_AC145');
  ArrPrintData:=nil;
end;

end.
