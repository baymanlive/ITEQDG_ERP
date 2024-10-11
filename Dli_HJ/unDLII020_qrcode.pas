unit unDLII020_qrcode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient, StrUtils,
  DateUtils, Math, TWODbarcode;

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
    SaveDialog: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure rb1Click(Sender: TObject);
    procedure rb2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_ORADB:string;
    l_CDS,l_CDSLot:TClientDataSet;
    function CheckEdit(var xDno:string; var xDitem:Integer; var xNum:Integer): Boolean;
    procedure SetCtrlVisible;
    function SetCDSLot(xDno:string; xDitem:Integer; var xTotQty:Double):Boolean;
    function GetOAO06(xOrderno:string; xOrderitem:Integer):string;
    function GetPrdDate1(xLot:string):string;
    function GetLstDate1(xIsPP:Boolean;xPrdDate1:string):string;
    function GetPrd_LstDate(xDate:string):string;
    function GetPnoKG(xORACDS:TClientDataSet):Double;
    procedure AddData(xORACDS:TClientDataSet; xLot:string; xQty:Double;
      xRecno,xKgdeci,xTotkgdeci:Integer);
    procedure GetQRCode(var xImgPath,xImgPath1,xKB:string);
    procedure JP_QRCode(var xImgPath,xImgPath1,xKB:string);
    procedure SH_QRCode(var xImgPath,xImgPath1,xKB:string);
    procedure CD_QRCode(var xImgPath,xImgPath1,xKB:string);
    procedure CY_QRCode(var xImgPath,xImgPath1,xKB:string);
    { Private declarations }
  public
    Fm_image : PTIMAGESTRUCT;
    { Public declarations }
  end;

var
  FrmDLII020_qrcode: TFrmDLII020_qrcode;

implementation

uses unGlobal, unCommon, unDLII020_const;

const l_diff=0.000001;

{$R *.dfm}

//檢查輸入欄位
function TFrmDLII020_qrcode.CheckEdit(var xDno:string;
  var xDitem:Integer; var xNum:Integer):Boolean;
var
  tmpDno:string;
  tmpDitem,tmpNum:Integer;
begin
  Result:=False;

  tmpDitem:=0;
  tmpNum:=0;
  tmpDno:=Trim(Edit1.Text);
  if (Length(tmpDno)<>10) or (Copy(tmpDno,4,1)<>'-') then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label1.Caption));
    Edit1.SetFocus;
    Exit;
  end;

  if rb2.Checked then
  begin
    tmpDitem:=StrToIntDef(Trim(Edit2.Text),0);
    if tmpDitem<1 then
    begin
      ShowMsg('請輸入[%s]',48,myStringReplace(Label2.Caption));
      Edit2.SetFocus;
      Exit;
    end;
  end;

  xDno:=tmpDno;
  xDitem:=tmpDitem;
  xNum:=tmpNum;
  Result:=True;
end;

//切換控件狀態
procedure TFrmDLII020_qrcode.SetCtrlVisible;
begin
  Label2.Visible:=rb2.Checked;
  Label3.Visible:=rb2.Checked;
  Label4.Visible:=rb2.Checked;
  Edit2.Visible:=rb2.Checked;
  Memo1.Visible:=rb2.Checked;
  BitBtn1.Visible:=rb2.Checked;
end;

//取批號
function TFrmDLII020_qrcode.SetCDSLot(xDno:string; xDitem:Integer;
  var xTotQty:Double):Boolean;
var
  i,tmpPos:Integer;
  tmpQty:Double;
  tmpSQL,tmpStr,tmpLot:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;
  
  xTotQty:=0;
  l_CDSlot.Filtered:=False;
  l_CDSlot.Filter:='';
  l_CDSlot.IndexFieldNames:='';
  l_CDSLot.EmptyDataSet;

  if rb2.Checked then
  begin
    if Memo1.Lines.Count=0 then
    begin
      ShowMsg('請輸入[%s]',48,myStringReplace(Label3.Caption));
      Memo1.SetFocus;
      Exit;
    end;

    if Memo1.Lines.Count>50 then
    begin
      ShowMsg('[%s]不能大于50筆!',48,myStringReplace(Label3.Caption));
      Memo1.SetFocus;
      Exit;
    end;

    for i:=0 to Memo1.Lines.Count-1 do
    begin
      tmpStr:=Trim(Memo1.Lines[i]);
      tmpPos:=Pos(',',tmpStr);
      if tmpPos>0 then
      begin
        tmpLot:=LeftStr(tmpStr,tmpPos-1);
        tmpQty:=StrToFloatDef(Copy(tmpStr,tmpPos+1,30),0);
      end else
      begin
        tmpLot:='';
        tmpQty:=0;
      end;

      if (Length(tmpLot)=0) or (tmpQty<=0) then
      begin
        ShowMsg('[%s]第'+IntToStr(i+1)+'行格式錯誤,請重新輸入!',48,myStringReplace(Label3.Caption));
        Memo1.SetFocus;
        Exit;
      end;

      with l_CDSLot do
      begin
        Append;
        FieldByName('Saleno').AsString:=xDno;
        FieldByName('Saleitem').AsInteger:=xDitem;
        FieldByName('Lot').AsString:=tmpLot;
        FieldByName('Qty').AsFloat:=tmpQty;
        Post;
      end;

      xTotQty:=xTotQty+tmpQty;
    end;

    l_CDSLot.MergeChangeLog;
    Result:=True;
    Exit;
  end;

  //rb1.Checked
  tmpSQL:='Select A.Saleno,A.Saleitem,B.Manfac1 Lot,Sum(B.Qty) Qty'
         +' From DLI010 A Inner Join DLI020 B'
         +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
         +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
         +' And A.Saleno='+Quotedstr(xDno)+' And IsNull(B.JFlag,0)=0'
         +' Group By A.Saleno,A.Saleitem,B.Manfac1'
         +' Order By A.Saleno,A.Saleitem';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with l_CDSLot do
    begin
      while not tmpCDS.Eof do
      begin
        Append;
        FieldByName('Saleno').AsString:=tmpCDS.FieldByName('Saleno').AsString;
        FieldByName('Saleitem').AsInteger:=tmpCDS.FieldByName('Saleitem').AsInteger;
        FieldByName('Lot').AsString:=tmpCDS.FieldByName('Lot').AsString;
        FieldByName('Qty').AsFloat:=tmpCDS.FieldByName('Qty').AsFloat;
        Post;

        tmpCDS.Next;
      end;

      if ChangeCount>0 then
         MergeChangeLog;
      if IsEmpty then
      begin
        ShowMsg('無批號資料!',48);
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;

  Result:=True;
end;

//取訂單備注
function TFrmDLII020_qrcode.GetOAO06(xOrderno:string; xOrderitem:Integer):string;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Result:='';

  Data:=null;
  tmpSQL:='select listagg(oao06,'','') within group (order by oao04) as oao06'
         +' from oao_file where oao01='+Quotedstr(xOrderno)
         +' and oao03='+IntToStr(xOrderitem)
         +' group by oao01,oao03';
  if not QueryOneCR(tmpSQL, Data, l_ORADB) then
     Exit;
  if not VarIsNull(Data) then
     Result:=VarToStr(Data);
end;

//取批號生產日期：YYYYMMDD
function TFrmDLII020_qrcode.GetPrdDate1(xLot:string):string;
var
  tmpDate:TDateTime;
begin
  Result:='';

  tmpDate:=GetLotDateHJ(Copy(xLot,3,6), Date);
  if tmpDate>EncodeDate(2014,1,1) then
     Result:=FormatDateTime('YYYYMMDD', tmpDate);
end;

//取批號有效日期：YYYYMMDD
function TFrmDLII020_qrcode.GetLstDate1(xIsPP:Boolean;xPrdDate1:string):string;
var
  y,m,d:Word;
  tmpDate:TDateTime;
begin
  Result:='';

  if Length(xPrdDate1)=8 then
  begin
    y:=StrToInt(LeftStr(xPrdDate1,4));
    m:=StrToInt(Copy(xPrdDate1,5,2));
    d:=StrToInt(RightStr(xPrdDate1,2));
    tmpDate:=EncodeDate(y,m,d);
    if xIsPP then
       tmpDate:=IncMonth(tmpDate,3)-1
    else
       tmpDate:=IncYear(tmpDate,2)-1;

    Result:=FormatDateTime('YYYYMMDD', tmpDate);
  end
end;

//取批號生產日期(有效日期)：YYYY-MM-DD
function TFrmDLII020_qrcode.GetPrd_LstDate(xDate:string):string;
begin
  Result:='';

  if Length(xDate)=8 then
     Result:=LeftStr(xDate,4)+'-'+Copy(xDate,5,2)+'-'+RightStr(xDate,2);
end;

//計算小料單重
function TFrmDLII020_qrcode.GetPnoKG(xORACDS:TClientDataSet):Double;
var
  kg:Double;
  tmpStr,tmpPno:string;
begin
  kg:=-1;
  tmpPno:=xORACDS.FieldByName('ogb04').AsString;
  tmpStr:=LeftStr(tmpPno,1);
  if (((tmpStr='E') or (tmpStr='T')) and (Length(tmpPno)=11)) or
     (((tmpStr='N') or (tmpStr='M')) and (Length(tmpPno)=12)) then
    kg:=GetKG(xORACDS.FieldByName('ogb01').AsString ,xORACDS.FieldByName('ogb03').AsInteger, 0);

  if kg=-1 then
     Result:=xORACDS.FieldByName('ima18').AsFloat
  else
     Result:=kg;
end;

procedure TFrmDLII020_qrcode.FormCreate(Sender: TObject);
begin
  inherited;
  GroupBox1.Caption:=CheckLang('列印類型');
  rb1.Caption:=CheckLang('按整張出貨單');
  rb2.Caption:=CheckLang('按出貨單項次、并指定批號和數量');

  l_ORADB:='ORACLE';
  l_CDS:=TClientDataSet.Create(nil);
  l_CDSLot:=TClientDataSet.Create(nil);
  InitCDS(l_CDS, g_QRCodeXml);
  InitCDS(l_CDSLot, g_lotxml);
  PtInitImage(@Fm_image);
end;

procedure TFrmDLII020_qrcode.FormShow(Sender: TObject);
begin
  inherited;
  rb1.Checked:=True;
  SetCtrlVisible;
end;

procedure TFrmDLII020_qrcode.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
  FreeAndNil(l_CDSLot);
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

procedure TFrmDLII020_qrcode.BitBtn1Click(Sender: TObject);

var
  tmpSQL,tmpDno:string;
  tmpDitem,tmpNum:Integer;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if not CheckEdit(tmpDno, tmpDitem, tmpNum) then
     Exit;

  tmpSQL:='Select B.Manfac1 Lot,Sum(B.Qty) Qty'
         +' From DLI010 A Inner Join DLI020 B'
         +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
         +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
         +' And A.Saleno='+Quotedstr(tmpDno)
         +' And A.SaleItem='+IntToStr(tmpDitem)
         +' And IsNull(B.JFlag,0)=0'
         +' Group By B.Manfac1';      
  if QueryBySQL(tmpSQL, Data) then
  begin
    Memo1.Lines.Clear;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        Memo1.Lines.Add(tmpCDS.Fields[0].AsString+','+FloatToStr(tmpCDS.Fields[1].AsFloat));
        tmpCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII020_qrcode.btn_okClick(Sender: TObject);
var
  isJP:Boolean;
  tmpDitem,tmpNum,kgdeci,totkgdeci,tmpRecno:Integer;
  tmpTotQty:Double;
  tmpSQL,tmpDno:string;
  OraCDS,tmpCDS:TClientDataSet;
  Data:OleVariant;
  ArrPrintData:TArrPrintData;
  tmpList:TStrings;
begin
  //inherited;
  if not CheckEdit(tmpDno, tmpDitem, tmpNum) then
     Exit;

  if rb1.Checked then
     tmpSQL:=''
  else
     tmpSQL:=' and ogb03='+IntToStr(tmpDitem);

  Data:=null;
  tmpSQL:='select D.*,occ02,occ18 from'
         +' (select C.*,ima02,ima021,ima18 from'
         +' (select B.*,oea04,oea10 from'
         +' (select A.*,oeb11,ta_oeb01,ta_oeb02,ta_oeb07,ta_oeb10 from'
         +' (select ogapost,ogb01,ogb03,ogb04,ogb05,ogb05_fac,ogb12,ogb31,ogb32'
         +' from oga_file inner join ogb_file on oga01=ogb01'
         +' where ogb01='+Quotedstr(tmpDno)+tmpSQL
         +') A inner join oeb_file on ogb31=oeb01 and ogb32=oeb03'
         +') B inner join oea_file on ogb31=oea01'
         +') C inner join ima_file on ima01=ogb04'
         +') D inner join occ_file on oea04=occ01'
         +' order by ogb01,ogb03';
  if not QueryBySQL(tmpSQL, Data, l_ORADB) then
     Exit;

  OraCDS:=TClientDataSet.Create(nil);
  tmpCDS:=TClientDataSet.Create(nil);
  try
    OraCDS.Data:=Data;

    if OraCDS.IsEmpty then
    begin
      if rb1.Checked then
         ShowMsg(tmpDno+'出貨單不存在!', 48)
      else
         ShowMsg(tmpDno+'/'+IntToStr(tmpDitem)+'出貨單不存在!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if OraCDS.FieldByName('ogapost').AsString<>'Y' then
    begin
      ShowMsg(tmpDno+'出貨單未扣帳,不可列印!', 48);
      Edit1.SetFocus;
      Exit;
    end;

    if not SetCDSLot(tmpDno,tmpDitem,tmpTotQty) then
       Exit;

    //指定批號+數量:檢查總數量與出貨數量
    if rb2.Checked then
    if Abs(tmpTotQty-OraCDS.FieldByName('ogb12').AsFloat)>l_diff then
    begin
      ShowMsg('合計數量'+FloatToStr(tmpTotQty)+'<>出貨數量'+FloatToStr(OraCDS.FieldByName('ogb12').AsFloat),48);
      //Memo1.SetFocus;
      //Exit;
    end;

    //單重,總重小數位
    Data:=null;
    tmpSQL:='exec dbo.proc_GetKGFormat '+Quotedstr(g_UInfo^.BU)+','+
            Quotedstr(OraCDS.FieldByName('oea04').AsString);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    kgdeci:=-tmpCDS.FieldByName('kgdeci').AsInteger;
    totkgdeci:=-tmpCDS.FieldByName('totkgdeci').AsInteger;

    //添加資料至l_CDS
    OraCDS.First;
    l_CDSlot.First;
    l_CDS.EmptyDataSet;
    if rb1.Checked then
    begin
      while not OraCDS.Eof do
      begin
        with l_CDSlot do
        begin
          Filtered:=False;
          Filter:='Saleno='+Quotedstr(OraCDS.FieldByName('ogb01').AsString)
                 +' And Saleitem='+IntToStr(OraCDS.FieldByName('ogb03').AsInteger);
          Filtered:=True;
          IndexFieldNames:='Lot';
          while not Eof do
          begin
            if l_CDSlot.RecNo>1 then
               tmpRecno:=l_CDS.RecNo
            else
               tmpRecno:=0;
            AddData(OraCDS, FieldByName('Lot').AsString, FieldByName('Qty').AsFloat, tmpRecno, kgdeci, totkgdeci);

            Next;
          end;
        end;

        OraCDS.Next;
      end;
    end else
    begin
      while not l_CDSlot.Eof do
      begin
        if l_CDS.RecordCount>0 then
           tmpRecno:=1
        else
           tmpRecno:=0;
        AddData(OraCDS, l_CDSlot.FieldByName('Lot').AsString, l_CDSlot.FieldByName('Qty').AsFloat, tmpRecno, kgdeci, totkgdeci);

        l_CDSlot.Next;
      end;
    end;

    //敬鵬匯出資料
    isJP:=Pos(l_CDS.FieldByName('custno').AsString,g_strJP)>0;
    if isJP then
    begin
      tmpList:=TStringList.Create;
      try
        with l_CDS do
        begin
          //tmpList:$D出貨資料
          First;
          while not Eof do
          begin
            tmpList.Add('$DA33B;'+FieldByName('Saleno').AsString+';'+
                        FieldByName('C_Orderno').AsString+';'+
                        FieldByName('C_Pno').AsString+';'+
                        FloatToStr(FieldByName('Qty').AsFloat)+';'+
                        StringReplace(FieldByName('PrdDate2').AsString,'-','/',[rfReplaceAll])+';'+
                        FieldByName('Lot').AsString);
            Next;
          end;

          //tmpList:$P棧板資料
          First;
          while not Eof do
          begin
            tmpList.Add('$PA33B;'+FieldByName('Saleno').AsString+';'+
                        FieldByName('KB').AsString+';'+
                        FieldByName('C_Pno').AsString+';'+
                        FloatToStr(FieldByName('Qty').AsFloat)+';'+
                        StringReplace(FieldByName('PrdDate2').AsString,'-','/',[rfReplaceAll])+';'+
                        FieldByName('Lot').AsString);
            Next;
          end;
        end;

        //另存匯出
        if tmpList.Count>0 then
        begin
          SaveDialog:=TSaveDialog.Create(nil);
          try
            SaveDialog.Title:=CheckLang('出貨資料另存');
            SaveDialog.Filter:=CheckLang('文字文件(*.txt)|*.txt');
            SaveDialog.DefaultExt:='.txt';
            SaveDialog.FileName:=l_CDS.FieldByName('Saleno').AsString+'_'+FormatDateTime(g_cLongTime,Now);
            if SaveDialog.Execute then
               tmpList.SaveToFile(SaveDialog.FileName);
          finally
            FreeAndNil(SaveDialog);
          end;
        end;

      finally
        FreeAndNil(tmpList);
      end;
    end;

  finally
    FreeAndNil(OraCDS);
    FreeAndNil(tmpCDS);
  end;

  l_CDS.MergeChangeLog;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  if isJP then                                                      //敬鵬
     GetPrintObj('Dli', ArrPrintData, 'QRCode_JP')
  else if Pos(l_CDS.FieldByName('custno').AsString,g_strSH)>0 then  //勝華
     GetPrintObj('Dli', ArrPrintData, 'QRCode_SH')
  else if Pos(l_CDS.FieldByName('custno').AsString,g_strCD)>0 then  //崇達
     GetPrintObj('Dli', ArrPrintData, 'QRCode_CD')
  else if Pos(l_CDS.FieldByName('custno').AsString,g_strCY)>0 then  //超毅
     GetPrintObj('Dli', ArrPrintData, 'QRCode_CY')
  else
     GetPrintObj('Dli', ArrPrintData, 'QRCode_def');
  ArrPrintData:=nil;
end;

procedure TFrmDLII020_qrcode.AddData(xORACDS:TClientDataSet; xLot:string;
  xQty:Double; xRecno,xKgdeci,xTotkgdeci:Integer);
var
  tmpOAO06,tmpC_Orderno,tmpImgPath,tmpImgPath1,tmpKB:string;
  tmpKG:Double;
begin
  if xRecno>0 then
  begin
    l_CDS.RecNo:=xRecno;
    tmpOAO06:=l_CDS.FieldByName('OAO06').AsString;
    tmpC_Orderno:=l_CDS.FieldByName('C_Orderno').AsString;
    tmpKG:=l_CDS.FieldByName('KG_old').AsFloat;
  end else
  begin
    tmpOAO06:=GetOAO06(xORACDS.FieldByName('ogb31').AsString,xORACDS.FieldByName('ogb32').AsInteger);
    tmpC_Orderno:=GetC_Orderno(xORACDS.FieldByName('oea04').AsString,xORACDS.FieldByName('oea10').AsString,tmpOAO06);
    tmpKG:=RoundTo(GetPnoKG(xORACDS)+l_diff,xKgdeci);
  end;

  with l_CDS do
  begin
    Append;
    FieldByName('Saleno').AsString:=xORACDS.FieldByName('ogb01').AsString;
    FieldByName('Saleitem').AsInteger:=xORACDS.FieldByName('ogb03').AsInteger;
    FieldByName('Orderno').AsString:=xORACDS.FieldByName('ogb31').AsString;
    FieldByName('Orderitem').AsInteger:=xORACDS.FieldByName('ogb32').AsInteger;
    FieldByName('OldOrderitem').AsInteger:=xORACDS.FieldByName('ogb32').AsInteger;
    FieldByName('Custno').AsString:=xORACDS.FieldByName('oea04').AsString;
    FieldByName('Custabs').AsString:=xORACDS.FieldByName('occ02').AsString;
    FieldByName('Custom').AsString:=xORACDS.FieldByName('occ18').AsString;
    FieldByName('Pno').AsString:=xORACDS.FieldByName('ogb04').AsString;
    FieldByName('Pname').AsString:=xORACDS.FieldByName('ima02').AsString;
    FieldByName('Sizes').AsString:=xORACDS.FieldByName('ima021').AsString;
    FieldByName('C_Orderno').AsString:=tmpC_Orderno;
    FieldByName('C_Pno').AsString:=xORACDS.FieldByName('oeb11').AsString;
    FieldByName('C_Sizes').AsString:=xORACDS.FieldByName('ta_oeb10').AsString;
    FieldByName('Units').AsString:=xORACDS.FieldByName('ogb05').AsString;
    FieldByName('Qty').AsFloat:=xQty;
    FieldByName('Lot').AsString:=xLot;
    FieldByName('PrdDate1').AsString:=GetPrdDate1(FieldByName('Lot').AsString);         //YYYYMMDD
    FieldByName('PrdDate2').AsString:=GetPrd_LstDate(FieldByName('PrdDate1').AsString); //YYYY-MM-DD
    FieldByName('LstDate1').AsString:=GetLstDate1(Pos(LeftStr(FieldByName('Pno').AsString,1),'ET')=0,FieldByName('PrdDate1').AsString); //YYYYMMDD
    FieldByName('LstDate2').AsString:=GetPrd_LstDate(FieldByName('LstDate1').AsString); //YYYY-MM-DD
    FieldByName('KG_old').AsFloat:=tmpKG;
    if SameText(FieldByName('Units').AsString,'RL') and
       (Length(FieldByName('Pno').AsString)=18) then
       FieldByName('KG').AsFloat:=RoundTo(StrToInt(Copy(FieldByName('Pno').AsString,11,3))*FieldByName('KG_old').AsFloat+l_diff,xKgdeci)
    else
       FieldByName('KG').AsFloat:=RoundTo(xORACDS.FieldByName('ogb05_fac').AsFloat*FieldByName('KG_old').AsFloat+l_diff,xKgdeci);
    FieldByName('T_KG').AsFloat:=RoundTo(FieldByName('Qty').AsFloat*FieldByName('KG').AsFloat+l_diff,xTotkgdeci);
    FieldByName('SPEC').AsString:=xORACDS.FieldByName('ta_oeb10').AsString;
    FieldByName('OAO06').AsString:=tmpOAO06;
    GetQRCode(tmpImgPath,tmpImgPath1,tmpKB);
    FieldByName('QRcode').AsString:=tmpImgPath;
    FieldByName('QRcode1').AsString:=tmpImgPath1;
    FieldByName('KB').AsString:=tmpKB;
    Post;
  end;
end;

//產生二維碼,返回圖片路徑、卡板編號
procedure TFrmDLII020_qrcode.GetQRCode(var xImgPath,xImgPath1,xKB:string);
begin
  xImgPath:='';
  xImgPath1:='';
  xKB:='';

  if Pos(l_CDS.FieldByName('Custno').AsString,g_strJP)>0 then       //敬鵬
     JP_QRCode(xImgPath, xImgPath1, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString,g_strSH)>0 then  //勝華
     SH_QRCode(xImgPath, xImgPath1, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString,g_strCD)>0 then  //崇達
     CD_QRCode(xImgPath, xImgPath1, xKB)
  else if Pos(l_CDS.FieldByName('Custno').AsString,g_strCY)>0 then  //超毅
     CY_QRCode(xImgPath, xImgPath1, xKB);
end;

//敬鵬:$PA33B;出貨單號;棧板號
procedure TFrmDLII020_qrcode.JP_QRCode(var xImgPath,xImgPath1,xKB:string);
var
  tmpQRCodeSno:Integer;
  tmpStr,tmpImgPath:string;
begin
  xImgPath:='';
  xImgPath1:='';
  xKB:='';

  tmpQRCodeSno:=GetQRCodeSno(l_CDS.FieldByName('Custno').AsString,Date)+1;
  xKB:='A33B'+FormatDateTime('YYMMDD',Date)+'P'+RightStr('00'+IntToStr(tmpQRCodeSno),3);
  tmpStr:='$PA33B;'+l_CDS.FieldByName('Saleno').AsString+';'+xKB;
  tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'.bmp';
  if getcode(tmpStr, tmpImgPath, Fm_image) then
     xImgPath:=tmpImgPath;
     
  SetQRCodeSno(l_CDS.FieldByName('Custno').AsString,Date,tmpQRCodeSno);
end;

//勝華:供應商編號,采購單號,采購項次,客戶料號,生產日期,數量,批號
procedure TFrmDLII020_qrcode.SH_QRCode(var xImgPath,xImgPath1,xKB:string);
var
  tmpStr,tmpImgPath:string;
begin
  xImgPath:='';
  xImgPath1:='';
  xKB:='';

  with l_CDS do
    tmpStr:='M0014,'+FieldByName('C_Orderno').AsString+','+
                     FieldByName('Orderitem').AsString+','+
                     FieldByName('C_Pno').AsString+','+
                     FieldByName('PrdDate1').AsString+','+
                     FieldByName('Qty').AsString+','+
                     FieldByName('Lot').AsString;
  tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'.bmp';
  if getcode(tmpStr, tmpImgPath, Fm_image) then
     xImgPath:=tmpImgPath;
end;

{崇達入庫
<z>
<a>客戶料號</a>
<b>送貨單號</b>
<c>項次</c>
<d>數量</d>
<e>單位</e>
<f>客戶訂單</f>
<g>重量</g>
<h>生產日期</h>
<i>過期日期</i>
<j>批號</j>
</z>
崇達出庫碼:
客戶料號|批號
}
procedure TFrmDLII020_qrcode.CD_QRCode(var xImgPath,xImgPath1,xKB:string);
var
  tmpStr,tmpImgPath:string;
begin
  xImgPath:='';
  xImgPath1:='';
  xKB:='';

  with l_CDS do
    tmpStr:='<z><a>'+FieldByName('C_Pno').AsString+'</a>'+
            '<b>'+FieldByName('Saleno').AsString+'</b>'+
            '<c>'+FieldByName('Saleitem').AsString+'</c>'+
            '<d>'+FloatToStr(FieldByName('Qty').AsFloat)+'</d>'+
            '<e>PCS</e>'+
            '<f>'+FieldByName('C_Orderno').AsString+'</f>'+
            '<g>'+FloatToStr(FieldByName('T_KG').AsFloat)+'</g>'+
            '<h>'+FieldByName('PrdDate2').AsString+'</h>'+
            '<i>'+FieldByName('LstDate2').AsString+'</i>'+
            '<j>'+FieldByName('Lot').AsString+'</j></z>';
  tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'.bmp';
  if getcode(tmpStr, tmpImgPath, Fm_image) then
     xImgPath:=tmpImgPath;

  tmpStr:=l_CDS.FieldByName('C_Pno').AsString+'|'+l_CDS.FieldByName('Lot').AsString;
  tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'_1.bmp';
  if getcode(tmpStr, tmpImgPath, Fm_image) then
     xImgPath1:=tmpImgPath;
end;

//超毅:流水號*客戶料號*有效日期MMDDYY*數量*批號*客戶PO*生產日期MMDDYY
procedure TFrmDLII020_qrcode.CY_QRCode(var xImgPath,xImgPath1,xKB:string);
var
  tmpQRCodeSno:Integer;
  tmpId,tmpStr,tmpImgPath:string;
begin
  xImgPath:='';
  xImgPath1:='';
  xKB:='';

  if SameText(l_CDS.FieldByName('Custno').AsString,'AC405') then
     tmpId:='B1-'
  else if SameText(l_CDS.FieldByName('Custno').AsString,'AC311') then
     tmpId:='B4-'
  else if SameText(l_CDS.FieldByName('Custno').AsString,'AC310') then
     tmpId:='B5-'
  else
     Exit;

  tmpQRCodeSno:=GetQRCodeSno(l_CDS.FieldByName('Custno').AsString,Date)+1;
  tmpId:=tmpId+FormatDateTime('YYYYMMDD',Date)+'RI0012'+RightStr('000'+IntToStr(tmpQRCodeSno),4);

  with l_CDS do
    tmpStr:=tmpId+'*'+FieldByName('C_Pno').AsString+'*'+
             l_CDS.FieldByName('LstDate1').AsString+'*'+
             FloatToStr(FieldByName('Qty').AsFloat)+'*'+
             FieldByName('Lot').AsString+'*'+
             FieldByName('C_Orderno').AsString+'*'+
             l_CDS.FieldByName('PrdDate1').AsString;

  tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(l_CDS.RecordCount)+'.bmp';
  if FileExists(tmpImgPath) then
     DeleteFile(tmpImgPath);  
  if getcode(tmpStr, tmpImgPath, Fm_image) then
     xImgPath:=tmpImgPath;
     
  xKB:=tmpId+','+l_CDS.FieldByName('PrdDate1').AsString+','+l_CDS.FieldByName('LstDate1').AsString;
  SetQRCodeSno(l_CDS.FieldByName('Custno').AsString,Date,tmpQRCodeSno);
end;

end.
