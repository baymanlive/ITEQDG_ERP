{用于DLII040,DLII041,DLIT600
與儲存過程proc_CheckPP_C_sizes,proc_CheckCCL_C_sizes功能一樣
儲存過程用于PDA}

unit unCheckC_sizes;

interface

uses
  Windows, Classes, SysUtils, Variants, StrUtils, DBClient, unGlobal, unCommon;

type
  TCheckC_sizes= class
  private
    FCDSDli150:TClientDataSet;
    FCDSDli151:TClientDataSet;
    FCDSDli170:TClientDataSet;
    FCDSDli190:TClientDataSet;
    FCDSDli620_ccl:TClientDataSet;
    FCDSDli620_pp:TClientDataSet;
    FCDSDli630:TClientDataSet;
  public
    constructor Create;
    destructor Destroy; override;
    function CheckCCL_C_sizes(SMRec:TSplitMaterialno; C_sizes:string;
      isPN:Boolean):string;       //ccl品名
    function CheckCCL_9_C_sizes(SMRec:TSplitMaterialno; C_sizes:string):string;       //ccl品名
    function CheckPP_C_sizes(SMRec:TSplitMaterialnoPP; C_sizes:string;
      isPN:Boolean; var isAsk:Boolean):string;      //pp品名
    function CheckStruct(SMRec:TSplitMaterialno; C_sizes:string;
      const Struct:string=''):string;  //ccl結構
    function CheckCCL_PN_sizes(SMRec:TSplitMaterialno; C_sizes:string;
      const Sizes1:string=''; const Sizes2:string=''):string;  //ccl pn尺寸
    function CheckPP_PN_sizes(SMRec:TSplitMaterialnoPP; C_sizes:string;
      const Sizes1:string=''; const Sizes2:string=''):string;  //pp pn尺寸
  end;

implementation

{ TCheckC_sizes }

constructor TCheckC_sizes.Create;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  FCDSDli150:=TClientDataSet.Create(nil);
  FCDSDli151:=TClientDataSet.Create(nil);
  FCDSDli170:=TClientDataSet.Create(nil);
  FCDSDli190:=TClientDataSet.Create(nil);
  FCDSDli620_ccl:=TClientDataSet.Create(nil);
  FCDSDli620_pp:=TClientDataSet.Create(nil);
  FCDSDli630:=TClientDataSet.Create(nil);

  Data:=null;
  tmpSQL:='Select CodeId,Custno,Code,LstCode,StdValue,StdValueNo,StdValueOne'
         +' From Dli620 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And CodeId in (0,1,2,3)'
         +' Order By CodeId,Custno Desc,Code Desc,LstCode Desc'; //0排在後面
  if QueryBySQL(tmpSQL, Data) then
     FCDSDli620_ccl.Data:=Data;

  Data:=null;
  tmpSQL:='Select CodeId,Custno,Code,LstCode,StdValue,StdValueNo,StdValueOne'
         +' From Dli620 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And CodeId in (4,5,6,7)'
         +' Order By CodeId,Custno Desc,Code Desc,LstCode Desc'; //0排在後面
  if QueryBySQL(tmpSQL, Data) then
     FCDSDli620_pp.Data:=Data;
end;

destructor TCheckC_sizes.Destroy;
begin
  FreeAndNil(FCDSDli150);
  FreeAndNil(FCDSDli151);
  FreeAndNil(FCDSDli170);
  FreeAndNil(FCDSDli190);
  FreeAndNil(FCDSDli620_ccl);
  FreeAndNil(FCDSDli620_pp);
  FreeAndNil(FCDSDli630);

  inherited;
end;

function TCheckC_sizes.CheckCCL_C_sizes(SMRec: TSplitMaterialno;
  C_sizes: string; isPN: Boolean): string;
var
  i,tmpRecno1,pos1:Integer;
  isOK:Boolean;
  tmpStr1,tmpStr2,s1,s2,upperC_sizes:string;
  tmpList:TStrings;

  //查找符合條件記錄
  function FindRecNo(Code,LstCode:string):Integer;
  var
    tmpRecno2,tmpMaxNum,tmpNum:Integer;
  begin
    tmpMaxNum:=-1;
    tmpRecno2:=-1;
    with FCDSDli620_ccl do
    begin
      First;
      while not Eof do
      begin
        tmpNum:=0;
        if (FieldByName('Custno').AsString='0') or
           (Pos(','+SMRec.Custno+',',','+FieldByName('Custno').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (FieldByName('Code').AsString='0') or
           (Pos(','+Code+',',','+FieldByName('Code').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (FieldByName('LstCode').AsString='0') or
           (Pos(','+LstCode+',',','+FieldByName('LstCode').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (tmpNum>0) and (tmpMaxNum<tmpNum) then
        begin
          tmpMaxNum:=tmpNum;
          tmpRecno2:=Recno;
        end;
        if tmpMaxNum=3 then
           Break;
        Next;
      end;
    end;
    Result:=tmpRecno2;
  end;

  function Check9_14(xs,ys:string):Boolean;
  begin
    Result:=False;
    if (Pos(xs+'*'+ys,C_sizes)>0) or
       (Pos(xs+'X'+ys,C_sizes)>0) or
       (Pos(xs+'x'+ys,C_sizes)>0) or
       (Pos(xs+'"X'+ys+'"',C_sizes)>0) or
       (Pos(xs+'"x'+ys+'"',C_sizes)>0) or
       (Pos(xs+'"*'+ys+'"',C_sizes)>0) or
       (Pos(xs+'(W)*'+ys+'(T)',C_sizes)>0) or
       (Pos(xs+'GX'+ys,C_sizes)>0) or
       (Pos(xs+'Gx'+ys,C_sizes)>0) or
       (Pos(xs+'G*'+ys,C_sizes)>0) then
       Result:=True;
  end;
begin
  Result:='';
  upperC_sizes:=UpperCase(C_sizes);

  if (Pos('RG312',upperC_sizes)>0) and (Pos('RTF3',upperC_sizes)=0) then
  begin
    Result:='客戶品名檢核失敗,備註"RG312"應為"RTF3"';
    Exit;
  end;

  if (Pos('RG311',upperC_sizes)>0) and (Pos('RTF2',upperC_sizes)=0) then
  begin
    Result:='客戶品名檢核失敗,備註"RG311"應為"RTF2"';
    Exit;
  end;

  if (Length(C_sizes)=0) or (not FCDSDli620_ccl.Active) or FCDSDli620_ccl.IsEmpty then
     Exit;

  tmpList:=TStringList.Create;
  try
    //第2碼
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=0';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M2, SMRec.MLast);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[膠系]檢核失敗,未找到參數設定:'+SMRec.M2;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[膠系]檢核失敗,應為下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //第7-8碼
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=1';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M7, SMRec.MLast_1);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[銅箔]檢核失敗,未找到參數設定:'+SMRec.M7;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
    begin
      tmpRecno1:=FindRecNo(SMRec.M8, SMRec.MLast_1);
      if tmpRecno1=-1 then
      begin
        Result:='客戶品名[銅箔]檢核失敗,未找到參數設定:'+SMRec.M8;
        Exit;
      end;

      FCDSDli620_ccl.RecNo:=tmpRecno1;
      tmpStr2:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
      if (Length(tmpStr2)>0) and (tmpStr2<>'/') then   //為"/"時不檢查
      begin
        isOK:=False;
        if (Pos(tmpStr1+'-'+tmpStr2,C_sizes)>0) or
           (Pos(tmpStr1+'/'+tmpStr2,C_sizes)>0) or
           (Pos(tmpStr2+'-'+tmpStr1,C_sizes)>0) or
           (Pos(tmpStr2+'/'+tmpStr1,C_sizes)>0) then
           isOK:=True;

        if not isOK then
        begin
          Result:='客戶品名[銅箔]檢核失敗,應為下列值之一'+#13#10+tmpStr1+'-'+tmpStr2+','+tmpStr1+'/'+tmpStr2;
          Exit;
        end;
      end;
    end;

    //第9-14碼
    if not isPN then
    begin
      FCDSDli620_ccl.Filtered:=False;
      FCDSDli620_ccl.Filter:='CodeId=2';
      FCDSDli620_ccl.Filtered:=True;
      tmpRecno1:=FindRecNo(SMRec.M9_11, SMRec.MLast);
      if tmpRecno1=-1 then
      begin
        Result:='客戶品名[尺寸]檢核失敗,未找到參數設定:'+SMRec.M9_11;
        Exit;
      end;

      FCDSDli620_ccl.RecNo:=tmpRecno1;
      tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
      if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
      begin
        tmpRecno1:=FindRecNo(SMRec.M12_14, SMRec.MLast);
        if tmpRecno1=-1 then
        begin
          Result:='客戶品名[尺寸]檢核失敗,未找到參數設定:'+SMRec.M12_14;
          Exit;
        end;

        FCDSDli620_ccl.RecNo:=tmpRecno1;
        tmpStr2:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
        if (Length(tmpStr2)>0) and (tmpStr2<>'/') then   //為"/"時不檢查
        begin
          isOK:=False;
          s1:='';
          s2:='';
          pos1:=Pos(',',tmpStr1);    //最多2個值，4种組合
          if pos1>0 then
          begin
            s1:=LeftStr(tmpStr1,pos1-1);
            tmpStr1:=Copy(tmpStr1,pos1+1,100);
            pos1:=Pos(',',tmpStr1);
            if pos1>0 then
               tmpStr1:=LeftStr(tmpStr1,pos1-1);
          end;

          pos1:=Pos(',',tmpStr2);    //最多2個值，4种組合
          if pos1>0 then
          begin
            s2:=LeftStr(tmpStr2,pos1-1);
            tmpStr2:=Copy(tmpStr2,pos1+1,100);
            pos1:=Pos(',',tmpStr2);
            if pos1>0 then
               tmpStr2:=LeftStr(tmpStr2,pos1-1);
          end;

          if Length(s1)>0 then
          begin
            if Length(s2)>0 then
            begin
              isOK:=Check9_14(s1,s2);
              if not isOK then
                 isOK:=Check9_14(tmpStr1,s2);
            end;
            if not isOK then
               isOK:=Check9_14(s1,tmpStr2);
            if not isOK then
               isOK:=Check9_14(tmpStr1,tmpStr2);
          end else
          begin
            if Length(s2)>0 then
               isOK:=Check9_14(tmpStr1,s2);
            if not isOK then
               isOK:=Check9_14(tmpStr1,tmpStr2);
          end;

          if not isOK then
          begin
            Result:='客戶品名[尺寸]檢核失敗!';
            Exit;
          end;
        end;
      end;
    end;

    //第16碼
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=3';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.MLast_1, SMRec.MLast);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[產品別]檢核失敗,未找到參數設定:'+SMRec.MLast_1;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);  //所有內容必需出現
    if tmpStr1='/' then                                              //此項目不檢查
       Exit;

    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)=0 then
        begin
          Result:='客戶品名[產品別]檢核失敗,必需有下列值'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValueNo').AsString);  //所有內容不能出現
    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          Result:='客戶品名[產品別]檢核失敗,不能有下列值'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValueOne').AsString);  //其中之一必需出現
    if Length(tmpStr1)>0 then
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[產品別]檢核失敗,應有下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpList);
  end;
end;

function tcheckc_sizes.CheckCCL_9_C_sizes(SMRec:TSplitMaterialno; C_sizes:string):string;
begin

end;

function TCheckC_sizes.CheckPP_C_sizes(SMRec: TSplitMaterialnoPP;
  C_sizes: string; isPN: Boolean; var isAsk:Boolean): string;
var
  i,tmpRecno1:Integer;
  isOK:Boolean;
  tmpStr1,tmpStr2:string;
  tmpList:TStrings;

  //查找符合條件記錄
  function FindRecNo(Code,LstCode:string):Integer;
  var
    tmpRecno2,tmpMaxNum,tmpNum:Integer;
  begin
    tmpMaxNum:=-1;
    tmpRecno2:=-1;
    with FCDSDli620_pp do
    begin
      First;
      while not Eof do
      begin
        tmpNum:=0;
        if (FieldByName('Custno').AsString='0') or
           (Pos(','+SMRec.Custno+',',','+FieldByName('Custno').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (FieldByName('Code').AsString='0') or
           (Pos(','+Code+',',','+FieldByName('Code').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (FieldByName('LstCode').AsString='0') or
           (Pos(','+LstCode+',',','+FieldByName('LstCode').AsString+',')>0) then
           Inc(tmpNum)
        else
        begin
          Next;
          Continue;
        end;

        if (tmpNum>0) and (tmpMaxNum<tmpNum) then
        begin
          tmpMaxNum:=tmpNum;
          tmpRecno2:=Recno;
        end;
        if tmpMaxNum=3 then
           Break;
        Next;
      end;
    end;
    Result:=tmpRecno2;
  end;

begin
  isAsk:=False;
  Result:='';
  if (Length(C_sizes)=0) or (not FCDSDli620_pp.Active) or FCDSDli620_pp.IsEmpty then
     Exit;

  tmpList:=TStringList.Create;
  try
    //第2碼
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=4';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M2, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[膠系]檢核失敗,未找到參數設定:'+SMRec.M2;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[膠系]檢核失敗,應為下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //第3碼
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=5';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M3, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[產品別]檢核失敗,未找到參數設定:'+SMRec.M3;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);  //所有內容必需出現
    if tmpStr1='/' then                                             //此項目不檢查
       Exit;

    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)=0 then
        begin
          Result:='客戶品名[產品別]檢核失敗,必需有下列值'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValueNo').AsString);  //所有內容不能出現
    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          Result:='客戶品名[產品別]檢核失敗,不能有下列值'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValueOne').AsString);  //其中之一必需出現
    if Length(tmpStr1)>0 then
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[產品別]檢核失敗,應有下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //第4-7碼
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=6';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M4_7, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[布種]檢核失敗,未找到參數設定:'+SMRec.M4_7;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[布種]檢核失敗,應為下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //第8-10碼
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=7';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M8_10, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='客戶品名[RC]檢核失敗,未找到參數設定:'+SMRec.M8_10;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //為"/"時不檢查
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'，',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          isOK:=True;
          Break;
        end;
      end;

      if not isOK then
      begin
        Result:='客戶品名[RC]檢核失敗,應為下列值之一'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //尺寸
    if not isPN then
    begin
      tmpStr1:=LeftStr(SMRec.M14_16,2)+'.'+RightStr(SMRec.M14_16,1);
      tmpStr2:=tmpStr1+'x'+SMRec.M11_13+'G';
      tmpStr1:=SMRec.M11_13+'M*'+tmpStr1;
      if (Pos(tmpStr1,C_sizes)=0) and (Pos(tmpStr2,C_sizes)=0) then
      begin
        isAsk:=True;
        Result:='客戶品名[尺寸]檢核失敗,應為'+#13#10+tmpStr1+'或'+tmpStr2;
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpList);
  end;
end;

function TCheckC_sizes.CheckStruct(SMRec:TSplitMaterialno; C_sizes:string;
  const Struct:string=''):string;
var
  pos1:Integer;
  tmpBo,isChkStruct:Boolean;
  tmpSQL,tmpStruct:string;
  Data:OleVariant;
begin
  Result:='';
  if Length(C_sizes)=0 then
     Exit;

  //是否檢查客戶品名中結構isChkStruct
  if not FCDSDli630.Active then
  begin
    Data:=null;
    tmpSQL:='Select Custno,Struct,Sizes From Dli630 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    FCDSDli630.Data:=Data;
  end;

  with FCDSDli630 do
  begin
    Filtered:=False;
    Filter:='Custno='+Quotedstr(SMRec.Custno)+' OR  Custno=''0''';
    Filtered:=True;
    if Locate('Custno',SMRec.Custno,[]) or Locate('Custno','0',[]) then
       isChkStruct:=Fields[1].AsBoolean
    else
       isChkStruct:=False;
  end;

  if not isChkStruct then
     Exit;

  //AC111、AC082結構重新取值
  if Pos(SMRec.Custno, 'AC111/AC082')>0 then
  begin
    if not FCDSDli151.Active then
    begin
      Data:=null;
      tmpSQL:='Select * From Dli151 Where Bu='+Quotedstr(g_UInfo^.BU);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      FCDSDli151.Data:=Data;
    end;

    with FCDSDli151 do
    begin
      Filtered:=False;
      Filter:='Custno='+Quotedstr(SMRec.Custno)
             +' And Adhesive='+Quotedstr(SMRec.M2)
             +' And Strip='+FloatToStr(SMRec.M3_6/1000);
      Filtered:=True;
      if not IsEmpty then
      begin
        tmpSQL:='Struct'+SMRec.M15;
        if FindField(tmpSQL)<>nil then
        begin
          tmpSQL:=FieldByName(tmpSQL).AsString;
          if Length(tmpSQL)=0 then
          begin
            Result:='客戶品名[結構]檢核失敗!'+#13#10+'未找到客戶'+SMRec.Custno+'的結構設定';
            Exit;
          end else
          if Pos(tmpSQL,C_sizes)=0 then
          begin
            Result:='客戶品名[結構]檢核失敗,應為'+tmpSQL;
            Exit;
          end;
        end;
      end;
    end;
  end else
  begin
    tmpStruct:=Struct;

    //結構無參數,重新取值
    if Length(tmpStruct)=0 then
    begin
      if not FCDSDli150.Active then
      begin
        Data:=null;
        tmpSQL:='Select * From Dli150 Where Bu='+Quotedstr(g_UInfo^.BU);
        if not QueryBySQL(tmpSQL, Data) then
           Exit;
        FCDSDli150.Data:=Data;
      end;

      with FCDSDli150 do
      begin
        Filtered:=False;
        Filter:='Strip='+FloatToStr(SMRec.M3_6/1000)
               +' And (Adhesive='+Quotedstr(SMRec.M2)+' Or Adhesive=''@'')';
        Filtered:=True;
        if not IsEmpty then
        begin
          tmpBo:=Locate('Custno;Adhesive', VarArrayOf([SMRec.Custno, SMRec.M2]), []);
          if not tmpBo then
             tmpBo:=Locate('Custno;Adhesive', VarArrayOf(['@', SMRec.M2]), []);
          if not tmpBo then
             tmpBo:=Locate('Custno;Adhesive', VarArrayOf(['@','@']), []);

          if tmpBo then
          begin
            tmpSQL:='Struct'+SMRec.M15;
            if FindField(tmpSQL)<>nil then
               tmpStruct:=FieldByName(tmpSQL).AsString;
          end;
        end;
      end;
    end;

    if Length(tmpStruct)>0 then
    begin
      tmpSQL:=tmpStruct;
      pos1:=Pos('+',tmpSQL);
      if pos1=0 then
         tmpSQL:='@@@@@@@@'
      else
         tmpSQL:=Copy(tmpSQL,pos1+1,50)+'+'+Copy(tmpSQL,1,pos1-1);
      if (Pos(tmpSQL,C_Sizes)=0) and (Pos(tmpStruct,C_Sizes)=0) then
      begin
        Result:='客戶品名[結構]檢核失敗,應為'+tmpStruct;
        Exit;
      end;
    end;
  end;
end;

function TCheckC_sizes.CheckCCL_PN_sizes(SMRec:TSplitMaterialno; C_sizes:string;
  const Sizes1:string=''; const Sizes2:string=''):string;
var
  isChkSizes:Boolean;
  tmpSQL,tmpSizes1,tmpSizes2:string;
  Data:OleVariant;
begin
  Result:='';
  if Length(C_sizes)=0 then
     Exit;

  //是否檢查客戶品名中pnl尺寸isChkSizes
  if not FCDSDli630.Active then
  begin
    Data:=null;
    tmpSQL:='Select Custno,Struct,Sizes From Dli630 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    FCDSDli630.Data:=Data;
  end;

  with FCDSDli630 do
  begin
    Filtered:=False;
    Filter:='Custno='+Quotedstr(SMRec.Custno)+' OR  Custno=''0''';
    Filtered:=True;
    if Locate('Custno',SMRec.Custno,[]) or Locate('Custno','0',[]) then
       isChkSizes:=Fields[2].AsBoolean
    else
       isChkSizes:=False;
  end;

  if not isChkSizes then
     Exit;

  tmpSizes1:=Sizes1;
  tmpSizes2:=Sizes2;
  if (Length(tmpSizes1)=0) or (Length(tmpSizes2)=0) then
  begin
    if not FCDSDli190.Active then
    begin
      Data:=null;
      tmpSQL:='Select Sizes,fValue From Dli190 Where Bu='+Quotedstr(g_UInfo^.BU);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      FCDSDli190.Data:=Data;
    end;

    with FCDSDli190 do
    begin
      if Locate('Sizes',SMRec.M9_11,[]) then   //經向
         tmpSizes1:=FieldByName('fValue').AsString;
      if Locate('Sizes',SMRec.M12_14,[]) then  //緯向
         tmpSizes2:=FieldByName('fValue').AsString;
    end;
  end;

  if SameText(SMRec.Custno,'AC111') and (SMRec.M12_14='43') then
  begin
    if Pos(SMRec.M9_11+'X42.5',C_Sizes)=0 then
    begin
      Result:='客戶品名[PNL尺寸]檢核失敗!'+SMRec.M9_11+'X42.5';
      Exit;
    end;
  end else
  if (Pos(SMRec.M9_11+'*'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'"*'+SMRec.M12_14+'"',C_Sizes)=0) and
     (Pos(SMRec.M9_11+'X'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'x'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'G*'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'GX'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'Gx'+SMRec.M12_14,C_Sizes)=0) and
     (Pos('經'+SMRec.M9_11+'*緯'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'*'+SMRec.M12_14+'緯',C_Sizes)=0) and
     (Pos(tmpSizes1+'W*'+tmpSizes2+'F',C_Sizes)=0) and
     (Pos(tmpSizes1+'(W)*'+tmpSizes2+'(T)',C_Sizes)=0) and
     (Pos(tmpSizes1+'MM*'+tmpSizes2+'MM',C_Sizes)=0) and
     (Pos(tmpSizes1+'mm*'+tmpSizes2+'mm',C_Sizes)=0) and
     (Pos('經'+tmpSizes1+'MM*緯'+tmpSizes2+'MM',C_Sizes)=0) and
     (Pos('經'+tmpSizes1+'mm*緯'+tmpSizes2+'mm',C_Sizes)=0) and
     (g_UInfo^.UserId<>'ID150515')
      then
  begin
    Result:='客戶品名[PNL尺寸]檢核失敗!';
    Exit;
  end;
end;

function TCheckC_sizes.CheckPP_PN_sizes(SMRec:TSplitMaterialnoPP; C_sizes:string;
  const Sizes1:string=''; const Sizes2:string=''):string;
var
  tmpSQL,tmpSizes1,tmpSizes2:string;
  Data:OleVariant;
begin
  Result:='';
  if Length(C_sizes)=0 then
     Exit;

  tmpSizes1:=Sizes1;
  tmpSizes2:=Sizes2;
  if (Length(tmpSizes1)=0) or (Length(tmpSizes2)=0) then
  begin
    if not FCDSDli170.Active then
    begin
      Data:=null;
      tmpSQL:='Select Sizes,fValue From Dli170 Where Bu='+Quotedstr(g_UInfo^.BU);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      FCDSDli170.Data:=Data;
    end;

    with FCDSDli170 do
    begin
      if Locate('Sizes',SMRec.M11_13,[]) then   //經向
         tmpSizes1:=FieldByName('fValue').AsString;
      if Locate('Sizes',SMRec.M14_16,[]) then   //緯向
         tmpSizes2:=FieldByName('fValue').AsString;
    end;
  end;

  if ((Pos(SMRec.M11_13,C_sizes)=0) and (Pos(tmpSizes1,C_sizes)=0)) or
     ((Pos(SMRec.M14_16,C_sizes)=0) and (Pos(tmpSizes2,C_sizes)=0)) then
  begin
    Result:='客戶品名[PNL尺寸]檢核失敗!';
    Exit;
  end;
end;

end.
