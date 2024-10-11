{*******************************************************}
{                                                       }
{                unDLII020_sale                         }
{                Author: kaikai                         }
{                Create date: 2018/9/26                 }
{                Description: iteqhj���ͥX�f��          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020_sale;

interface

uses
  Windows, Classes, SysUtils, DB, DBClient, Forms, Variants,
  DateUtils, StrUtils, Math, unGlobal, unCommon, unDLII020_const;

  procedure DLII020_sale(CDS:TClientDataSet; SelList:TStrings);

implementation

//�ײv
function GetRate(xCashType, xExt:string; xDate:TDateTime):Double;
var
  r1,r2,r3,r4,r5,r6:Double;
  tmpSQL,fYYYYMM,tmpOraDB:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=1;

  tmpOraDB:='ORACLE';
  tmpSQL:='SELECT aza17,aza19 FROM aza_file WHERE aza01 = ''0'' AND ROWNUM=1';
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;

    if SameText(Trim(tmpCDS.Fields[0].AsString), xCashType) then
       Exit;

    r1:=1;
    r2:=1;
    r3:=1;
    r4:=1;
    r5:=1;
    r6:=1;

    if (tmpCDS.Fields[1].AsString='1') or (tmpCDS.Fields[1].AsString='2') then
    begin
      fYYYYMM:=FormatDateTime(g_cShortDateYYMMDD, xDate);
      Data:=null;
      tmpSQL:='SELECT azj04,azj03,azj04,azj03,azj04,azj04,''A'' AS A FROM azj_file'
             +' WHERE azj01='+Quotedstr(xCashType)
             +' AND azj02='+Quotedstr(fYYYYMM)+' AND ROWNUM=1'
             +' UNION ALL'
             +' SELECT azk03,azk04,azk051,azk052,azk041,azk05,''B'' AS A FROM azk_file'
             +' WHERE azk01='+Quotedstr(xCashType)
             +' AND azk02=(SELECT MAX(azk02) FROM azk_file WHERE azk01='+Quotedstr(xCashType)
             +' AND azk02<= to_date('+Quotedstr(FormatDateTime(g_cShortDate1,xDate))+','+Quotedstr(g_cShortDate1)+'))'
             +' AND ROWNUM=1'
             +' UNION ALL'
             +' SELECT Nvl(azj07,1) azj07,0,0,0,0,0,''C'' AS A FROM azj_file'
             +' WHERE azj01='+Quotedstr(xCashType)
             +' AND azj02='+Quotedstr(fYYYYMM)+' AND ROWNUM=1';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
         Exit;

      tmpSQL:=tmpCDS.Fields[1].AsString;
      tmpCDS.Data:=Data;                 //���C��ײv
      if (tmpSQL='1') and tmpCDS.Locate('A', 'A', []) then
      begin
        r1:=tmpCDS.Fields[0].AsFloat;
        r2:=tmpCDS.Fields[1].AsFloat;
        r3:=tmpCDS.Fields[2].AsFloat;
        r4:=tmpCDS.Fields[3].AsFloat;
        r5:=tmpCDS.Fields[4].AsFloat;
        r6:=tmpCDS.Fields[5].AsFloat;
      end                                //����Ѷײv,��Ѥ��s�b���̪�ײv
      else if (tmpSQL='2') and tmpCDS.Locate('A', 'B', []) then
      begin
        r1:=tmpCDS.Fields[0].AsFloat;
        r2:=tmpCDS.Fields[1].AsFloat;
        r3:=tmpCDS.Fields[2].AsFloat;
        r4:=tmpCDS.Fields[3].AsFloat;
        r5:=tmpCDS.Fields[4].AsFloat;
        r6:=tmpCDS.Fields[5].AsFloat;
      end
    end;

    if xExt='B' then
       Result:=r1
    else if xExt='S' then
       Result:=r2
    else if xExt='C' then
       Result:=r3
    else if xExt='D' then
       Result:=r4
    else if xExt='M' then
       Result:=r5
    else if xExt='T' then
       Result:=r6
    else if xExt='R' then
    begin
      if tmpCDS.Locate('A', 'C', []) then
         Result:=tmpCDS.Fields[0].AsFloat
      else
         Result:=1;
    end else
       Result:=1;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

//�p�������ڤ�Data1�B���ڨ����Date2
//�Ѽ�:�Ȥ�s��,�I�ڱ���,�P�f���
function GetOga11_12(CustNo, Payno:string; SaleDate:TDateTime;
  var Date1, Date2:TDateTime): Boolean;
var
  resDate:TDateTime;
  occ38,occ39:integer;
  tmpSQL,tmpOraDB:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;

  //sDate�������p�⦬�ڤ�β��ڨ����
  function cl_Date(sDate:TDateTime; FieldName_Month, FieldName_Day:string):TDateTime;
  var
    tmpDate:TDateTime;
    aMonth,aDay:Integer;
  begin
    tmpDate:=sDate;
    aMonth:=StrToIntDef(tmpCDS.FieldByName(FieldName_Month).AsString, 0);
    aDay:=StrToIntDef(tmpCDS.FieldByName(FieldName_Day).AsString, 0);
    if (occ38>0) and (occ38<DayOf(tmpDate)) then
       tmpDate:=IncMonth(tmpDate);
    tmpDate:=StartOfTheMonth(IncMonth(tmpDate));
    tmpDate:=IncMonth(tmpDate,aMonth)+aDay;
    if occ39>0 then
    begin
      if occ39<DayOf(tmpDate) then
         tmpDate:=StartOfTheMonth(IncMonth(tmpDate))
      else
         tmpDate:=StartOfTheMonth(tmpDate);

      if DayOf(EndOfTheMonth(tmpDate))>occ39 then
         tmpDate:=tmpDate+occ39-1
      else
         tmpDate:=EndOfTheMonth(tmpDate);
    end;
    Result:=tmpDate;
  end;

begin
  Result:=False;

  tmpOraDB:='ORACLE';
  tmpCDS:=TClientDataSet.Create(nil);
  try
    Data:=null;
    tmpSQL:='SELECT occ38,occ39 FROM occ_file WHERE occ01 = '+Quotedstr(CustNo);
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;
    occ38:=StrToIntDef(tmpCDS.Fields[0].AsString, 0);
    occ39:=StrToIntDef(tmpCDS.Fields[1].AsString, 0);

    Data:=null;
    tmpSQL:='SELECT oag03,oag041,oag04,oag06,oag071,oag07 FROM oag_file'
           +' WHERE oag01 = '+Quotedstr(Payno);
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;

    resDate:=cl_Date(Date, 'oag041', 'oag04');
    if Pos(tmpCDS.FieldByName('oag03').AsString, '12')>0 then
       Date1:=SaleDate          //�X�f���
    else
       Date1:=resDate;          //oag03=4��5 �X�f�馸���+��+��

    if Pos(tmpCDS.FieldByName('oag06').AsString, '12')>0 then  //�X�f���
       Date2:=SaleDate
    else if tmpCDS.FieldByName('oag06').AsString='3' then      //�����ڤ�
       Date2:=Date1
    else if Pos(tmpCDS.FieldByName('oag06').AsString, '45')>0 then   //�X�f�馸���+��+��
       Date2:=resDate
    else if tmpCDS.FieldByName('oag06').AsString='6' then            //�����ڤ馸���+��+��
       Date2:=cl_Date(Date1, 'oag071', 'oag07')
    else
       Exit;

    Result:=True;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//�h���x��X�f
function SetData_Ogc(Dno, Ditem, Sno, AUnit, Custno: string;
  OgbCDS,OgcCDS:TClientDataSet):Boolean;
var
  tmpQty:Double;
  tmpSQL,tmpOraDB:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=False;

  tmpOraDB:='ORACLE';
  tmpSQL:='Select stkplace,stkarea,manfac,sum(qty) qty'
         +' From DLI020 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(Dno)
         +' And Ditem='+Ditem+' And SFlag=0'
         +' Group By stkplace,stkarea,manfac';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('��'+Sno+'��,�q��['+OgbCDS.FieldByName('ogb31').AsString+'/'+
                                  OgbCDS.FieldByName('ogb32').AsString+
              ']�S���˳f!', 48);
      Exit;
    end;

    //�ˬd�w�s
    while not tmpCDS.Eof do
    begin
      Data:=null;
      tmpSQL:='Select img01 From img_file Where img01='+Quotedstr(OgbCDS.FieldByName('ogb04').AsString)
             +' And img02='+Quotedstr(tmpCDS.FieldByName('stkplace').AsString)
             +' And img03='+Quotedstr(tmpCDS.FieldByName('stkarea').AsString)
             +' And img04='+Quotedstr(tmpCDS.FieldByName('manfac').AsString)
             +' And img10>='+FloatToStr(tmpCDS.FieldByName('qty').AsFloat)
             +' And rownum=1';
      if QueryOneCR(tmpSQL, Data, tmpOraDB) then
      begin
        if VarIsNull(Data) or (Length(VarToStr(Data))=0) then
        begin
          ShowMsg('��'+Sno+'��,�q��['+OgbCDS.FieldByName('ogb31').AsString
                 +'/'+OgbCDS.FieldByName('ogb32').AsString+']'+#13#10
                 +'�ܮw['+tmpCDS.FieldByName('stkplace').AsString+']'+#13#10
                 +'�x��['+tmpCDS.FieldByName('stkarea').AsString+']'+#13#10
                 +'�帹['+tmpCDS.FieldByName('manfac').AsString+']'+#13#10
                 +'�ƶq['+tmpCDS.FieldByName('qty').AsString+']'+#13#10
                 +'���s�b�ήw�s����!', 48);
          Exit;
        end;
      end else
        Exit;
      tmpCDS.Next;
    end;
    //

    //ogb17�h���x��X�f
    tmpCDS.First;
    if Pos(Custno, 'AC096/AC093/AC394/AC152')=0 then    //�o�ǫȤ�س�n�D�h���x:�W��,�s�{�K�Q,�f��,���s�ҧQ
    begin
      if tmpCDS.RecordCount=1 then
      begin
        OgbCDS.FieldByName('ogb17').AsString:='N';
        OgbCDS.FieldByName('ogb09').AsString:=tmpCDS.FieldByName('stkplace').AsString;
        OgbCDS.FieldByName('ogb091').AsString:=tmpCDS.FieldByName('stkarea').AsString;
        OgbCDS.FieldByName('ogb092').AsString:=tmpCDS.FieldByName('manfac').AsString;
        Result:=True;
        Exit;
      end;
    end;

    tmpQty:=0;
    OgbCDS.FieldByName('ogb17').AsString:='Y';
    while not tmpCDS.Eof do
    begin
      with OgcCDS do
      begin
        Append;
        //FieldByName('ogc01').AsString:=OgbCDS.FieldByName('ogb01').AsString; //(�̫���)
        FieldByName('ogc03').AsInteger:=OgbCDS.FieldByName('ogb03').AsInteger;
        FieldByName('ogc09').AsString:=tmpCDS.FieldByName('stkplace').AsString;
        FieldByName('ogc091').AsString:=tmpCDS.FieldByName('stkarea').AsString;
        FieldByName('ogc092').AsString:=tmpCDS.FieldByName('manfac').AsString;
        if SameText(Trim(OgbCDS.FieldByName('ogb05').AsString),'RL') then //pp�̴�����
           FieldByName('ogc12').AsFloat:=RoundTo(tmpCDS.FieldByName('qty').AsFloat/OgbCDS.FieldByName('ogb15_fac').AsFloat,-3)
        else
           FieldByName('ogc12').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
        FieldByName('ogc15').AsString:=Trim(AUnit);
        FieldByName('ogc15_fac').AsFloat:=OgbCDS.FieldByName('ogb15_fac').AsFloat;
        FieldByName('ogc16').AsFloat:=RoundTo(FieldByName('ogc12').AsFloat*FieldByName('ogc15_fac').AsFloat,-3);
        //FieldByName('ta_ogc01').AsString:=
        //FieldByName('ta_ogc02').AsString:=
        Post;

        tmpQty:=tmpQty+FieldByName('ogc12').AsFloat;
      end;
      tmpCDS.Next;
    end;

    if OgbCDS.FieldByName('ogb12').AsFloat-tmpQty>0.00001 then
    begin
      ShowMsg('��'+Sno+'��,�q��['+OgbCDS.FieldByName('ogb31').AsString+'/'+
                                  OgbCDS.FieldByName('ogb32').AsString+
              ']�˳f�ƶq�P�[�`�ƶq���@�P,�Юֹ�!', 48);
      Exit;
    end;

    Result:=True;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure DLII020_sale(CDS:TClientDataSet; SelList:TStrings);

//�t���q�椣�P,���i���b�@�_
const str_custno1='N005/ACA62/ACA12/AC142/AC129/AC108/AC082/AC151/AC769/AC625/AC103/AC136/ACA27/AC109/AC102/AC116/AC181/AC687/AC163/AC093/AC394/AC844/AC152/AC096/AC174';
//�Ȥ�q�椣�P,���i���b�@�_+g_strCD
const str_custno2='AC052/ACA27/AC136/AC654/AC687/AC469';

var
  tmpOraDB:string;
  tmpogb17:Boolean;
  i,j,cnt,tmpoea211:Integer;
  tmpSQL,tmpStr,V1,V2,tmpoea00,tmpoea01_1,tmpoea01_2,tmpoea04,tmpoea08,tmpoea14,
  tmpoea21,tmpoea213,tmpoea23,tmpoea18,tmpcustorderno:string;
  tmpOldAddr,tmpNewAddr:WideString;
  tmpoga11,tmpoga12:TDateTime;
  tmpUnTaxAmt,tmpRate:Double;
  Data:OleVariant;
  tmpCDS,tmpOazCDS,tmpOgaCDS,tmpOgbCDS,tmpOgcCDS,tmpOrderCDS:TClientDataSet;
  copylist:TStrings;
  P:TBookmark;

  procedure Sp(Source:string);
  var
    pos1:Integer;
  begin
    pos1:=Pos('@', Source);
    V1:=Copy(Source, 1, Pos1 - 1);
    V2:=Copy(Source, Pos1+1, 5);
  end;
begin
  if SelList.Count=0 then
  begin
    ShowMsg('�п�ܳ��!', 48);
    Exit;
  end;

  if ShowMsg('�T�w�ͦ��X�f���?',33)=IdCancel then
     Exit;

  tmpOraDB:='ORACLE';
  for i:=0 to SelList.Count-1 do
  begin
    if tmpSQL<>'' then
       tmpSQL:=tmpSQL+',';
    tmpSQL:=tmpSQL+Quotedstr(SelList.Strings[i]);
  end;

  tmpSQL:='Select * From Dli010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno+''@''+Cast(Ditem as varchar(10)) in ('+tmpSQL+')';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  g_StatusBar.Panels[0].Text:=CheckLang('���b�ˬd�O�_�i�H��X�f��...');
  Application.ProcessMessages;
  tmpSQL:='';
  tmpOldAddr:='@@';
  P:=CDS.GetBookmark;
  CDS.DisableControls;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpOrderCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      for i:=0 to SelList.Count-1 do
      begin
        Sp(SelList.Strings[i]);
        if not Locate('Dno;Ditem',VarArrayOf([V1, StrToInt(V2)]),[]) then
        begin
          ShowMsg('���['+V1+'/'+V2+']���s�b!', 48);
          Exit;
        end;

        tmpNewAddr:=Trim(FieldByName('Remark').AsString);
        if (Length(tmpNewAddr)>2) and (LeftStr(tmpNewAddr, 2)=CheckLang('�f�e')) then
        begin
          j:=Pos('(', tmpNewAddr);
          if j>0 then
          begin
            System.Delete(tmpNewAddr, 1, j);
            j:=Pos(')', tmpNewAddr);
            if j>0 then
               tmpNewAddr:=Copy(tmpNewAddr, 1, j-1)
            else
               tmpNewAddr:=Trim(FieldByName('SendAddr').AsString);
          end else
            tmpNewAddr:=Trim(FieldByName('SendAddr').AsString);
        end else
          tmpNewAddr:=Trim(FieldByName('SendAddr').AsString);

        if tmpOldAddr='@@' then
           tmpOldAddr:=tmpNewAddr;

        tmpStr:='��'+FieldByName('Sno').AsString+'��,�q��['
                    +FieldByName('Orderno').AsString+'/'
                    +FieldByName('Orderitem').AsString+']';
       { if Length(FieldByName('Custorderno').AsString)=0 then
        begin
          ShowMsg(tmpStr+'�Ȥ�q�渹�X���s�b!', 48);
          Exit;
        end else }
        if FieldByName('BingBao_ans').AsBoolean then
        begin
          ShowMsg(tmpStr+'�å]������!', 48);
          Exit;
        end else
        if Length(FieldByName('Saleno').AsString)>0 then
        begin
          ShowMsg(tmpStr+'�w���ͥX�f��!', 48);
          Exit;
        end else
        if (tmpoea01_1<>'') and (tmpoea01_1<>LeftStr(FieldByName('Orderno').AsString,3)) then
        begin
          ShowMsg(tmpStr+'�q��O���ۦP!', 48);
          Exit;
        end else
        if (tmpoea04<>'') and (tmpoea04<>FieldByName('custno').AsString) then
        begin
          ShowMsg(tmpStr+'�Ȥᤣ�ۦP!', 48);
          Exit;
        end else
        if tmpOldAddr<>tmpNewAddr then
        begin
          ShowMsg(tmpStr+'�e�f�a�}���ۦP!', 48);
          Exit;
        end else             //���P[�t���q��]���i�P�@�X�f��
        if (tmpoea01_2<>'') and (tmpoea01_2<>FieldByName('Orderno').AsString) and
           (Pos(FieldByName('custno').AsString, str_custno1)>0) then
        begin
          ShowMsg(tmpStr+'�t���q�椣�ۦP,��]:'+#13#10+FieldByName('custno').AsString+FieldByName('custshort').AsString+'�����PO�I', 48);
          Exit;
        end else            //���P[�Ȥ�q��]���i�P�@�X�f��
        if (tmpcustorderno<>'') and (tmpcustorderno<>FieldByName('CustOrderno').AsString) and
           (Pos(FieldByName('custno').AsString, str_custno2+'/'+g_strCD)>0) then
        begin
          ShowMsg(tmpStr+'�Ȥ�q�椣�ۦP,��]:'+#13#10+FieldByName('custno').AsString+FieldByName('custshort').AsString+'�����PO�I', 48);
          Exit;
        end;

        tmpoea01_1:=LeftStr(FieldByName('Orderno').AsString,3); //�q���O
        tmpoea01_2:=FieldByName('Orderno').AsString;            //�q�渹
        tmpcustorderno:=FieldByName('custorderno').AsString;    //�Ȥ�q�渹
        tmpoea04:=FieldByName('Custno').AsString;
        tmpSQL:=tmpSQL+' or (B.oeb01='+Quotedstr(FieldByName('Orderno').AsString)
                      +' and B.oeb03='+FieldByName('Orderitem').AsString+')';
      end;
    end;

    Data:=null;
    tmpSQL:='Select C.*,ima25 From'
           +' (Select A.*,B.* From oea_file A Inner Join oeb_file B'
           +' on A.oea01=B.oeb01 Where 1=2 '+tmpSQL
           +') C Inner Join ima_file on C.oeb04=ima01';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;
    tmpOrderCDS.Data:=Data;

    tmpoea211:=-1;
    with tmpOrderCDS do
    begin
      if IsEmpty then
      begin
        ShowMsg('TipTop�q���Ƥ��s�b!', 48);
        Exit;
      end;
      while not Eof do
      begin
        if not tmpCDS.Locate('Orderno;Orderitem',VarArrayOf([FieldByName('oea01').AsString,
                FieldByName('oeb03').AsInteger]),[]) then
        begin
          ShowMsg('Dli010�q��ƾڿ��~!', 48);
          Exit;
        end;

        tmpStr:='��'+tmpCDS.FieldByName('Sno').AsString+'��,�q��['+
                FieldByName('oea01').AsString+'/'+FieldByName('oeb03').AsString+']';

        if FieldByName('oeaconf').AsString<>'Y' then
        begin
          ShowMsg(tmpStr+'�q�楼�T�{!', 48);
          Exit;
        end else
        if (tmpoea00<>'') and (tmpoea00<>FieldByName('oea00').AsString) then
        begin
          ShowMsg(tmpStr+'�q��O���ۦP!', 48);
          Exit;
        end else
        if (tmpoea04<>'') and (tmpoea04<>FieldByName('oea04').AsString) then
        begin
          ShowMsg(tmpStr+'�Ȥᤣ�ۦP!', 48);
          Exit;
        end else
        if (tmpoea08<>'') and (tmpoea08<>FieldByName('oea08').AsString) then
        begin
          ShowMsg(tmpStr+'���P/�~�P���ۦP!', 48);
          Exit;
        end else
        if (tmpoea14<>'') and (tmpoea14<>FieldByName('oea14').AsString) then
        begin
          ShowMsg(tmpStr+'�~�ȭ����ۦP!', 48);
          Exit;
        end else
        if (tmpoea21<>'') and (tmpoea21<>FieldByName('oea21').AsString) then
        begin
          ShowMsg(tmpStr+'�|�O���ۦP!', 48);
          Exit;
        end else
        if (tmpoea211<>-1) and (tmpoea211<>FieldByName('oea211').AsInteger) then
        begin
          ShowMsg(tmpStr+'�|�v���ۦP!', 48);
          Exit;
        end else
        if (tmpoea213<>'') and (tmpoea213<>FieldByName('oea213').AsString) then
        begin
          ShowMsg(tmpStr+'�t�|�_���ۦP!', 48);
          Exit;
        end else
        if (tmpoea23<>'') and (tmpoea23<>FieldByName('oea23').AsString) then
        begin
          ShowMsg(tmpStr+'���O���ۦP!', 48);
          Exit;
        end else
        if tmpCDS.FieldByName('Pno').AsString<>FieldByName('oeb04').AsString then
        begin
          ShowMsg(tmpStr+'���~�Ƹ����ۦP!', 48);
          Exit;
        end;

        tmpoea00:=FieldByName('oea00').AsString;
        tmpoea04:=FieldByName('oea04').AsString;
        tmpoea08:=FieldByName('oea08').AsString;
        tmpoea14:=FieldByName('oea14').AsString;
        tmpoea21:=FieldByName('oea21').AsString;
        tmpoea211:=FieldByName('oea211').AsInteger;
        tmpoea213:=FieldByName('oea213').AsString;
        tmpoea23:=FieldByName('oea23').AsString;
        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('���b�p�������ڤ��...');
    Application.ProcessMessages;
    tmpOrderCDS.First;
    if not GetOga11_12(tmpOrderCDS.FieldByName('oea03').AsString,
                       tmpOrderCDS.FieldByName('oea32').AsString,
                       Date,tmpoga11,tmpoga12) then
    begin
      ShowMsg('�����ڤ���p����~!', 48);
      Exit;
    end;

    tmpOazCDS:=TClientDataSet.Create(nil);
    tmpOgaCDS:=TClientDataSet.Create(nil);
    tmpOgbCDS:=TClientDataSet.Create(nil);
    tmpOgcCDS:=TClientDataSet.Create(nil);
    try
      g_StatusBar.Panels[0].Text:=CheckLang('���b�����X�f����Y���...');
      Application.ProcessMessages;

      tmpOgaCDS.DisableStringTrim:=True;
      tmpOgbCDS.DisableStringTrim:=True;
      tmpOgcCDS.DisableStringTrim:=True;

      Data:=null;
      tmpSQL := 'Select oaz41,oaz52,oaz70,oaz32 From oaz_file'
               +' Where oaz00=''0'' and rownum=1';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
         Exit;
      tmpOazCDS.Data:=Data;

      Data:=null;
      tmpSQL:='Select * From oga_file Where 1=2';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
         Exit;
      tmpOgaCDS.Data:=Data;

      g_StatusBar.Panels[0].Text:=CheckLang('���b�g�J�X�f����Y���...');
      Application.ProcessMessages;
      with tmpOgaCDS do
      begin
        Append;
        FieldByName('oga00').AsString:=tmpoea00;                                    //�X�f�O
        //FieldByName('oga01').AsString:='';                                        //�X�f�渹 (�̫���)
        //FieldByName('oga011').AsString:='';                                       //oga09='1' �X�f�q����
        FieldByName('oga02').AsDateTime:=Date;                                      //�X�f���
        FieldByName('oga021').AsDateTime:=Date;                                     //�������
        //FieldByName('oga022').AsDateTime:=Date;                                   //�˲���
        FieldByName('oga03').AsString:=tmpOrderCDS.FieldByName('oea03').AsString;   //�Ȥ�s��
        FieldByName('oga032').AsString:=tmpOrderCDS.FieldByName('oea032').AsString; //�Ȥ�²��
        FieldByName('oga033').AsString:=tmpOrderCDS.FieldByName('oea033').AsString; //�Τ@�s��
        FieldByName('oga04').AsString:=tmpOrderCDS.FieldByName('oea04').AsString;   //�e�f�Ȥ�s��
        FieldByName('oga044').AsString:=tmpOrderCDS.FieldByName('oea044').AsString; //�e�f�a�}�X
        FieldByName('oga05').AsString:=tmpOrderCDS.FieldByName('oea05').AsString;   //�o���O
        FieldByName('oga06').AsString:=tmpOazCDS.FieldByName('oaz41').AsString;     //�ק睊��
        FieldByName('oga07').AsString:=tmpOrderCDS.FieldByName('oea07').AsString;
        FieldByName('oga08').AsString:=tmpOrderCDS.FieldByName('oea08').AsString;   //��/�~�P
        {
        FieldByName('oga09').AsString:='';       //��ڧO=2 �@��X�f��
        FieldByName('oga09').AsString:='';       //��ڧO
        FieldByName('oga10').AsString:='';       //�b��s��   oma01
        FieldByName('oga13').AsString:='';       //��ؤ��s�X
        }
        FieldByName('oga11').AsDateTime:=StrToDate(DateToStr(tmpoga11));              //�����ڤ�
        FieldByName('oga12').AsDateTime:=StrToDate(DateToStr(tmpoga12));              //���ڨ����
        FieldByName('oga14').AsString:=tmpOrderCDS.FieldByName('oea14').AsString;;    //�H���s��
        FieldByName('oga15').AsString:=tmpOrderCDS.FieldByName('oea15').AsString;     //�����s��
        FieldByName('oga16').AsString:=tmpOrderCDS.FieldByName('oea01').AsString;     //�q��s��
        if tmpOrderCDS.FieldByName('oea161').IsNull then                              //�q��������v
           FieldByName('oga161').AsFloat:=0
        else
           FieldByName('oga161').AsFloat:=tmpOrderCDS.FieldByName('oea161').AsFloat;
        if tmpOrderCDS.FieldByName('oea162').IsNull then                              //�X�f������v
           FieldByName('oga162').AsFloat:=100
        else
           FieldByName('oga162').AsFloat:=tmpOrderCDS.FieldByName('oea162').AsFloat;
        if tmpOrderCDS.FieldByName('oea163').IsNull then                              //����������v
           FieldByName('oga163').AsFloat:=0
        else
           FieldByName('oga163').AsFloat:=tmpOrderCDS.FieldByName('oea163').AsFloat;

        //FieldByName('oga17').AsInteger:='';       //�Ƴf��������
        FieldByName('oga18').AsString:=tmpOrderCDS.FieldByName('oea17').AsString;     //���ګȤ�s��
        //FieldByName('oga19').AsString:='';        //�w���ڸ��X
        FieldByName('oga20').AsString:='Y';         //�������Z�O�_�i���s����(N:�H���ק�L)
        FieldByName('oga21').AsString:=tmpOrderCDS.FieldByName('oea21').AsString;     //�|�O
        FieldByName('oga211').AsFloat:=tmpOrderCDS.FieldByName('oea211').AsFloat;     //�|�v
        FieldByName('oga212').AsString:=tmpOrderCDS.FieldByName('oea212').AsString;   //�p��
        FieldByName('oga213').AsString:=tmpOrderCDS.FieldByName('oea213').AsString;   //�O�_�t�|
        FieldByName('oga23').AsString:=tmpOrderCDS.FieldByName('oea23').AsString;     //���O
        FieldByName('oga24').AsFloat:=tmpOrderCDS.FieldByName('oea24').AsFloat;       //�ײv
        FieldByName('oga25').AsString:=tmpOrderCDS.FieldByName('oea25').AsString;     //�P������@
        FieldByName('oga26').AsString:=tmpOrderCDS.FieldByName('oea26').AsString;     //�P������G
        {
        FieldByName('oga27').AsString:='';
        FieldByName('oga28').AsString:='';
        FieldByName('oga29').AsFloat:='';
        }
        FieldByName('oga30').AsString:='N';  //�]�˳�T�{�X
        FieldByName('oga31').AsString:=tmpOrderCDS.FieldByName('oea31').AsString;  //�������s��
        FieldByName('oga32').AsString:=tmpOrderCDS.FieldByName('oea32').AsString;  //���ڱ���s��
        FieldByName('oga33').AsString:=tmpOrderCDS.FieldByName('oea33').AsString;  //�䥦����
        if not tmpOrderCDS.FieldByName('oea34').IsNull then
           FieldByName('oga34').AsFloat:=tmpOrderCDS.FieldByName('oea34').AsFloat;    //�����v
        {
        FieldByName('oga35').AsString:='';
        FieldByName('oga36').AsString:='';
        FieldByName('oga37').AsString:='';
        FieldByName('oga38').AsString:='';
        FieldByName('oga39').AsString:='';
        FieldByName('oga40').AsString:='';
        }
        FieldByName('oga41').AsString:=tmpOrderCDS.FieldByName('oea41').AsString;     //�_�B�a
        FieldByName('oga42').AsString:=tmpOrderCDS.FieldByName('oea42').AsString;     //��B�a
        FieldByName('oga43').AsString:=tmpOrderCDS.FieldByName('oea43').AsString;     //��B�覡
        FieldByName('oga44').AsString:=tmpOrderCDS.FieldByName('oea44').AsString;     //�M�Y�s��
        FieldByName('oga45').AsString:=tmpOrderCDS.FieldByName('oea45').AsString;     //�p���H
        FieldByName('oga46').AsString:=tmpOrderCDS.FieldByName('oea46').AsString;     //�M�׽s��
        {
        FieldByName('oga47').AsString:='';              //��W/����
        FieldByName('oga48').AsString:='';              //�覸
        FieldByName('oga49').AsString:='';              //���f��
        }
        //FieldByName('oga501').AsFloat:=0;             //�����X�f���Bnot use
        //FieldByName('oga511').AsFloat:=0;             //�����X�f���Bnot use
        FieldByName('oga50').AsFloat:=0;                //����X�f���B(���|)
        //FieldByName('oga51').AsFloat:=0;              //����X�f���B(�t�|)
        FieldByName('oga52').AsFloat:=0;                //����w���q����P�f�����B
        FieldByName('oga53').AsFloat:=0;                //������}�o�����|���B
        FieldByName('oga54').AsFloat:=0;                //����w�}�o�����|���B

        FieldByName('oga903').AsString:='N';             //�H�άd�֩��
        {
        FieldByName('oga99').AsString:='';              //�h���T���y�{�Ǹ�
        FieldByName('oga901').AsString:='';
        FieldByName('oga902').AsString:='';             //�H�ζW���d�m�N�X
        FieldByName('oga904').AsString:='';
        FieldByName('oga905').AsString:='';             //�w��T���T���X�f��_
        FieldByName('oga906').AsString:='';             //�_�l�X�f��_
        FieldByName('oga907').AsString:='';             //�ǲ����X
        FieldByName('oga908').AsString:='';             //L/C NO
        FieldByName('oga909').AsString:='';             //�T���T���_
        FieldByName('oga910').AsString:='';             //�ҥ~�ܮw
        FieldByName('oga911').AsString:='';             //�ҥ~�x��
        }
        FieldByName('ogaconf').AsString:='N';           //�T�{Y/N || �@�oX
        FieldByName('ogapost').AsString:='N';           //�X�f���b(Y�w�X�f���b N�����b)
        FieldByName('ogaprsw').AsInteger:=0;            //�C�L����
        FieldByName('ogauser').AsString:=g_UInfo^.Wk_no;//��ƩҦ���
        FieldByName('ogagrup').AsString:='0H8121';      //��ƩҦ�����
        FieldByName('ogamodu').AsString:=g_UInfo^.Wk_no;//��ƭק��
        FieldByName('ogadate').AsDateTime:=Date;        //�̪�ק���
        FieldByName('oga55').AsString:='0';             //���p�X
        FieldByName('ogamksg').AsString:='N';           //ñ��

        FieldByName('ta_oga02').AsString:='N';          //QC�T�{
        FieldByName('ta_oga04').AsString:='NNNNNNNNNN'; //�d�����A
        {
        FieldByName('ta_oga01').AsDateTime:='';         //�X�t���
        FieldByName('ta_oga03').AsString:='';           //�ֳ�ɶ�
        FieldByName('ta_oga05').AsString:='';           //�������X
        FieldByName('ta_oga06').AsString:='';
        FieldByName('ta_oga07').AsFloat:='';            //��
        FieldByName('ta_oga08').AsFloat:='';            //�b��
        FieldByName('ta_oga09').AsDateTime:='';         //���w�F����
        FieldByName('ta_oga10').AsFloat:='';
        FieldByName('ta_oga11').AsString:='';           //���w�F��ɶ�
        FieldByName('ta_oga12').AsString:='';           //�w�p�X���ɶ�
        FieldByName('ta_oga13').AsString:='';           //��ڥX���ɶ�
        FieldByName('ta_oga14').AsString:='';           //�z�LMclient�L�b�_
        FieldByName('ta_oga15').AsDateTime:='';         //�}����
        }

        tmpoea18:=tmpOrderCDS.FieldByName('oea18').AsString; //Y�q��ײv�߽�
        Post;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('���b�����X�f��樭���...');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:='Select * From ogb_file Where 1=2';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
         Exit;
      tmpOgbCDS.Data:=Data;

      Data:=null;
      tmpSQL:='Select * From ogc_file Where 1=2';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
         Exit;
      tmpOgcCDS.Data:=Data;

      g_StatusBar.Panels[0].Text:=CheckLang('���b�B�z�X�f��樭���...');
      Application.ProcessMessages;
      i:=1;
      tmpogb17:=False;
      tmpRate:=1+RoundTo(tmpOgaCDS.FieldByName('oga211').AsFloat/100,-2); //�|�v+1
      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('Saleitem').AsInteger:=i;
        tmpCDS.Post;

        if not tmpOrderCDS.Locate('oeb01;oeb03',
                VarArrayOf([tmpCDS.FieldByName('Orderno').AsString,
                            tmpCDS.FieldByName('Orderitem').AsInteger]),[]) then
        begin
          ShowMsg('TipTop�q��['+tmpCDS.FieldByName('Orderno').AsString+'/'+
                                tmpCDS.FieldByName('Orderitem').AsString+']���s�b!', 48);
          Exit;
        end;

        with tmpOgbCDS do
        begin
          Append;
          //FieldByName('ogb01').AsString:=V1;                                            //�X�f�渹 (�̫���)
          FieldByName('ogb03').AsInteger:=i;                                              //����
          FieldByName('ogb04').AsString:=tmpCDS.FieldByName('Pno').AsString;              //���~�s��    oeb04G�PX ?
          FieldByName('ogb05').AsString:=Trim(tmpOrderCDS.FieldByName('oeb05').AsString); //�P����
          if SameText(FieldByName('ogb05').AsString,'RL') and (Length(FieldByName('ogb04').AsString)=18) then
             FieldByName('ogb05_fac').AsFloat:=StrToInt(Copy(FieldByName('ogb04').AsString,11,3))
          else                                                                            //��촫��v
             FieldByName('ogb05_fac').AsFloat:=tmpOrderCDS.FieldByName('oeb05_fac').AsFloat;
          if FieldByName('ogb05_fac').AsFloat=0 then
             FieldByName('ogb05_fac').AsFloat:=1;
          FieldByName('ogb06').AsString:=tmpOrderCDS.FieldByName('oeb06').AsString;       //�~�W�W��
          FieldByName('ogb07').AsString:=tmpOrderCDS.FieldByName('oeb07').AsString;       //�B�~�~�W�s��
          FieldByName('ogb08').AsString:=tmpOrderCDS.FieldByName('oeb08').AsString;       //�X�f��B���߽s��
          FieldByName('ogb11').AsString:=tmpOrderCDS.FieldByName('oeb11').AsString;       //�ȤᲣ�~�s��
          FieldByName('ogb12').AsFloat:=RoundTo(tmpCDS.FieldByName('Delcount').AsFloat-tmpCDS.FieldByName('Bcount').AsFloat,-3); //�X�f�ƶq
          FieldByName('ogb13').AsFloat:=tmpOrderCDS.FieldByName('oeb13').AsFloat;         //���
          if SameText(Trim(tmpOgaCDS.FieldByName('oga213').AsString),'Y') then            //�t�|
          begin
            FieldByName('ogb14t').AsFloat:=RoundTo(FieldByName('ogb12').AsFloat*FieldByName('ogb13').AsFloat,-6);  //����t�|���B
            FieldByName('ogb14').AsFloat:=RoundTo(FieldByName('ogb14t').AsFloat/tmpRate,-6);                       //������|���B
          end else
          begin
            FieldByName('ogb14').AsFloat:=RoundTo(FieldByName('ogb12').AsFloat*FieldByName('ogb13').AsFloat,-6);   //������|���B
            FieldByName('ogb14t').AsFloat:=RoundTo(FieldByName('ogb14').AsFloat*tmpRate,-6);                       //����t�|���B
          end;
          FieldByName('ogb15').AsString:=FieldByName('ogb05').AsString;                   //�w�s���ӳ��
          FieldByName('ogb15_fac').AsFloat:=FieldByName('ogb05_fac').AsFloat;             //�w�s���ӳ�촫��v
          FieldByName('ogb16').AsFloat:=FieldByName('ogb12').AsFloat*FieldByName('ogb15_fac').AsFloat;   //�ƶq(�w�s���ӳ��)
          FieldByName('ogb18').AsFloat:=tmpOrderCDS.FieldByName('oeb12').AsFloat;         //�w�p�X�f�ƶq
          FieldByName('ogb31').AsString:=tmpOrderCDS.FieldByName('oeb01').AsString;       //�q��渹
          FieldByName('ogb32').AsInteger:=tmpOrderCDS.FieldByName('oeb03').AsInteger;     //�q�涵��
          FieldByName('ogb60').AsFloat:=0;         //�w�}�o���ƶq
          FieldByName('ogb63').AsFloat:=0;         //�P�h�ƶq(�ݴ��f�A�X�f)
          FieldByName('ogb64').AsFloat:=0;         //�P�h�ƶq(���ݴ��f�A�X�f)

          //�ܡB�x�B��
          if not SetData_Ogc(tmpCDS.FieldByName('Dno').AsString,
                             tmpCDS.FieldByName('Ditem').AsString,
                             tmpCDS.FieldByName('Sno').AsString,
                             tmpOrderCDS.FieldByName('ima25').AsString,
                             tmpCDS.FieldByName('Custno').AsString, tmpOgbCDS, tmpOgcCDS) then
             Exit;

          if (not tmpogb17) and (FieldByName('ogb17').AsString='Y') then
             tmpogb17:=True;

          Post;
        end;
        Inc(i);
        tmpCDS.Next;
      end;

      //tmpStr := 'ABC-' + GetYM();     //���ճ�O
      tmpSQL:=LeftStr(tmpOgbCDS.FieldByName('ogb04').AsString,1);
      if (tmpSQL='A') or (tmpSQL='E') or (tmpSQL='U') then
         i:=1
      else if (tmpSQL='C') or (tmpSQL='H') then
         i:=2
      else
         i:=250;
      tmpStr := GetSaleNo_Id(tmpCDS.FieldByName('Orderno').AsString,i);
      if tmpStr='' then
      begin
        ShowMsg(LeftStr(tmpCDS.FieldByName('Orderno').AsString,3)+'�X�f��O���s�b!', 48);
        Exit;
      end;

      //axmt821,�s�{�p�ZN012���i�h���x��(�C��ogc_file��ƲK�[��ogb_file,�R��ogc_file)
      if not tmpOgcCDS.IsEmpty then
      if (LeftStr(tmpStr,1)='P') or
         SameText(Trim(tmpOgaCDS.FieldByName('oga03').AsString), 'N012') then
      begin
        copylist:=TStringList.Create;
        try
          tmpOgcCDS.MergeChangeLog;
          cnt:=tmpOgbCDS.RecordCount;
          for i:=1 to cnt do
          begin
            if not tmpOgbCDS.Locate('ogb03', i, []) then
            begin
              ShowMsg('tmpOgbCDS Locate '+IntToStr(i)+' Error.', 48);
              Exit;
            end;

            if tmpOgbCDS.FieldByName('ogb17').AsString='Y' then
            begin
              copylist.Clear;
              for j := 0 to tmpOgbCDS.FieldCount - 1 do
                  copylist.Add(Trim(tmpOgbCDS.Fields[j].AsString));

              with tmpOgbCDS do
              begin
                tmpOgcCDS.Filtered:=False;
                tmpOgcCDS.Filter:='ogc03='+IntToStr(i);
                tmpOgcCDS.Filtered:=True;
                while not tmpOgcCDS.Eof do
                begin
                  Append;
                  for j := 0 to FieldCount - 1 do
                    if copylist.Strings[j]<>'' then
                       Fields[j].Value := copylist.Strings[j];
                  FieldByName('ogb17').AsString:='N';
                  FieldByName('ogb09').AsString:=tmpOgcCDS.FieldByName('ogc09').AsString;   //��
                  FieldByName('ogb091').AsString:=tmpOgcCDS.FieldByName('ogc091').AsString; //�x
                  FieldByName('ogb092').AsString:=tmpOgcCDS.FieldByName('ogc092').AsString; //��
                  FieldByName('ogb12').AsFloat:=tmpOgcCDS.FieldByName('ogc12').AsFloat;     //��
                  FieldByName('ogb18').AsFloat:=tmpOgcCDS.FieldByName('ogc12').AsFloat;     //�w�p�X�f��
                  FieldByName('ogb16').AsFloat:=FieldByName('ogb12').AsFloat*FieldByName('ogb15_fac').AsFloat;
                  if SameText(Trim(tmpOgaCDS.FieldByName('oga213').AsString),'Y') then      //�t�|
                  begin
                    FieldByName('ogb14t').AsFloat:=RoundTo(FieldByName('ogb12').AsFloat*FieldByName('ogb13').AsFloat,-6);     //����t�|���B
                    FieldByName('ogb14').AsFloat:=RoundTo(FieldByName('ogb14t').AsFloat/tmpRate,-6);                          //������|���B
                  end else
                  begin
                    FieldByName('ogb14').AsFloat:=RoundTo(FieldByName('ogb12').AsFloat*FieldByName('ogb13').AsFloat,-6);      //������|���B
                    FieldByName('ogb14t').AsFloat:=RoundTo(FieldByName('ogb14').AsFloat*tmpRate,-6);                          //����t�|���B
                  end;
                  Post;
                  tmpOgcCDS.Next;
                end;
                Locate('ogb03', i, []);
                Delete;
              end;
            end;
          end;

          //�R��ogc_file
          with tmpOgcCDS do
          begin
            Filtered:=False;
            while not IsEmpty do
              Delete;
            MergeChangeLog;
          end;

          tmpogb17:=False;

        finally
          FreeAndNil(copylist);
        end;
      end;

      //�X��f�渹
      g_StatusBar.Panels[0].Text:=CheckLang('���b�B�z�X�f�渹...');
      Application.ProcessMessages;
      Data:=null;
      tmpStr :=tmpStr + '-' + GetYM();
      tmpSQL := 'Select nvl(Max(Oga01),'''') as Oga01 From Oga_file'
               +' Where Oga01 like ''' + tmpStr + '%''';
      if not QueryOneCR(tmpSQL, Data, tmpOraDB) then
         Exit;
      tmpStr:=GetNewNo(tmpStr, VarToStr(Data));
      tmpSQL:=LeftStr(tmpStr,1);

      with tmpOgcCDS do
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('ogc01').AsString:=tmpStr;
          Post;
          Next;
        end;
      end;

      i:=1;
      tmpunTaxAmt:=0;
      with tmpOgbCDS do
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('ogb01').AsString:=tmpStr;
          FieldByName('ogb03').AsInteger:=i;     //�Ǹ����s�]�w
          if FieldByName('ogb17').AsString='Y' then
          begin
            FieldByName('ogb09').AsString:=' ';
            FieldByName('ogb091').AsString:=' ';
            FieldByName('ogb092').AsString:=' ';
          end;
          Post;
          tmpunTaxAmt:=tmpunTaxAmt+FieldByName('ogb14').AsFloat;
          Next;
          Inc(i);
        end;
      end;

      with tmpOgaCDS do
      begin
        Edit;
        FieldByName('oga01').AsString:=tmpStr;
        if tmpSQL='P' then
           FieldByName('oga09').AsString:='6'
        else if tmpSQL='S' then
           FieldByName('oga09').AsString:='4'
        else
           FieldByName('oga09').AsString:='2';
        if Pos(tmpSQL, 'PS')>0 then
        begin
          FieldByName('oga905').AsString:='N';
          FieldByName('oga906').AsString:='Y';
          FieldByName('oga909').AsString:='Y';
        end;
        FieldByName('oga50').AsFloat:=RoundTo(tmpunTaxAmt,-6);
        FieldByName('oga53').AsFloat:=FieldByName('oga50').AsFloat;

        //�ײv
        if tmpoea18<>'Y' then
        begin
          g_StatusBar.Panels[0].Text:=CheckLang('���b�p��ײv...');
          Application.ProcessMessages;
          if FieldByName('oga909').AsString='Y' then
             tmpSQL:=tmpOazCDS.FieldByName('oaz32').AsString
          else if FieldByName('oga08').AsString='1' then
             tmpSQL:=tmpOazCDS.FieldByName('oaz52').AsString
          else
             tmpSQL:=tmpOazCDS.FieldByName('oaz70').AsString;

          FieldByName('oga24').AsFloat:=GetRate(FieldByName('oga23').AsString,
            tmpSQL, FieldByName('oga021').AsDateTime);
        end;

        Post;
      end;
      //��f�渹

      g_StatusBar.Panels[0].Text:=CheckLang('���b�x�s���...');
      Application.ProcessMessages;
      //��sORACLE
      if not CDSPost(tmpOgaCDS, 'oga_file', tmpOraDB) then
         Exit;

      if not CDSPost(tmpOgbCDS, 'ogb_file', tmpOraDB) then
      begin
        tmpSQL:='Delete From oga_file Where oga01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        Exit;
      end;

      //�h���x�X�f,��s�帹������(����AsString��Ȥ覡�|�L��?)
      if tmpogb17 then
      begin
        tmpSQL:='Update ogb_file Set ogb09='' '',ogb091='' '',ogb092='' '''
               +' Where ogb01='+Quotedstr(tmpStr)+' And ogb17=''Y''';
        PostBySQL(tmpSQL, tmpOraDB);
      end;

      if not CDSPost(tmpOgcCDS, 'ogc_file', tmpOraDB) then
      begin
        tmpSQL:='Delete From oga_file Where oga01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        tmpSQL:='Delete From ogb_file Where ogb01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        Exit;
      end;

      //��sMSSQL
      with tmpCDS do
      begin
        First;
        while not Eof do
        begin
          if CDS.Locate('Dno;Ditem', VarArrayOf([FieldByName('Dno').AsString,
                                                 FieldByName('Ditem').AsInteger]),[]) then
          begin
            CDS.Edit;
            CDS.FieldByName('Saleno').AsString:=tmpStr;
            CDS.FieldByName('Saleitem').AsInteger:=FieldByName('Saleitem').AsInteger;
            CDS.Post;
          end;
          Next;
        end;
      end;
      if not PostBySQLFromDelta(CDS, 'DLI010', 'Bu,Dno,Ditem') then
      begin
        tmpSQL:='Delete From oga_file Where oga01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        tmpSQL:='Delete From ogb_file Where ogb01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        tmpSQL:='Delete From ogc_file Where ogc01='+Quotedstr(tmpStr);
        PostBySQL(tmpSQL, tmpOraDB);
        Exit;
      end;

      ShowMsg('�ͦ��X�f�槹��!', 64);
    finally
      FreeAndNil(tmpOazCDS);
      FreeAndNil(tmpOgaCDS);
      FreeAndNil(tmpOgbCDS);
      FreeAndNil(tmpOgcCDS);
    end;
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpOrderCDS);
    CDS.GotoBookmark(P);
    CDS.EnableControls;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
