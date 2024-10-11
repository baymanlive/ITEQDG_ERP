{�Τ_DLII040,DLII041,DLIT600
�P�x�s�L�{proc_CheckPP_C_sizes,proc_CheckCCL_C_sizes�\��@��
�x�s�L�{�Τ_PDA}

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
      isPN:Boolean):string;       //ccl�~�W
    function CheckCCL_9_C_sizes(SMRec:TSplitMaterialno; C_sizes:string):string;       //ccl�~�W
    function CheckPP_C_sizes(SMRec:TSplitMaterialnoPP; C_sizes:string;
      isPN:Boolean; var isAsk:Boolean):string;      //pp�~�W
    function CheckStruct(SMRec:TSplitMaterialno; C_sizes:string;
      const Struct:string=''):string;  //ccl���c
    function CheckCCL_PN_sizes(SMRec:TSplitMaterialno; C_sizes:string;
      const Sizes1:string=''; const Sizes2:string=''):string;  //ccl pn�ؤo
    function CheckPP_PN_sizes(SMRec:TSplitMaterialnoPP; C_sizes:string;
      const Sizes1:string=''; const Sizes2:string=''):string;  //pp pn�ؤo
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
         +' Order By CodeId,Custno Desc,Code Desc,LstCode Desc'; //0�Ʀb�᭱
  if QueryBySQL(tmpSQL, Data) then
     FCDSDli620_ccl.Data:=Data;

  Data:=null;
  tmpSQL:='Select CodeId,Custno,Code,LstCode,StdValue,StdValueNo,StdValueOne'
         +' From Dli620 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And CodeId in (4,5,6,7)'
         +' Order By CodeId,Custno Desc,Code Desc,LstCode Desc'; //0�Ʀb�᭱
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

  //�d��ŦX����O��
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
    Result:='�Ȥ�~�W�ˮ֥���,�Ƶ�"RG312"����"RTF3"';
    Exit;
  end;

  if (Pos('RG311',upperC_sizes)>0) and (Pos('RTF2',upperC_sizes)=0) then
  begin
    Result:='�Ȥ�~�W�ˮ֥���,�Ƶ�"RG311"����"RTF2"';
    Exit;
  end;

  if (Length(C_sizes)=0) or (not FCDSDli620_ccl.Active) or FCDSDli620_ccl.IsEmpty then
     Exit;

  tmpList:=TStringList.Create;
  try
    //��2�X
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=0';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M2, SMRec.MLast);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[���t]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M2;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[���t]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //��7-8�X
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=1';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M7, SMRec.MLast_1);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[�ɺ�]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M7;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
    begin
      tmpRecno1:=FindRecNo(SMRec.M8, SMRec.MLast_1);
      if tmpRecno1=-1 then
      begin
        Result:='�Ȥ�~�W[�ɺ�]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M8;
        Exit;
      end;

      FCDSDli620_ccl.RecNo:=tmpRecno1;
      tmpStr2:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
      if (Length(tmpStr2)>0) and (tmpStr2<>'/') then   //��"/"�ɤ��ˬd
      begin
        isOK:=False;
        if (Pos(tmpStr1+'-'+tmpStr2,C_sizes)>0) or
           (Pos(tmpStr1+'/'+tmpStr2,C_sizes)>0) or
           (Pos(tmpStr2+'-'+tmpStr1,C_sizes)>0) or
           (Pos(tmpStr2+'/'+tmpStr1,C_sizes)>0) then
           isOK:=True;

        if not isOK then
        begin
          Result:='�Ȥ�~�W[�ɺ�]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1+'-'+tmpStr2+','+tmpStr1+'/'+tmpStr2;
          Exit;
        end;
      end;
    end;

    //��9-14�X
    if not isPN then
    begin
      FCDSDli620_ccl.Filtered:=False;
      FCDSDli620_ccl.Filter:='CodeId=2';
      FCDSDli620_ccl.Filtered:=True;
      tmpRecno1:=FindRecNo(SMRec.M9_11, SMRec.MLast);
      if tmpRecno1=-1 then
      begin
        Result:='�Ȥ�~�W[�ؤo]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M9_11;
        Exit;
      end;

      FCDSDli620_ccl.RecNo:=tmpRecno1;
      tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
      if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
      begin
        tmpRecno1:=FindRecNo(SMRec.M12_14, SMRec.MLast);
        if tmpRecno1=-1 then
        begin
          Result:='�Ȥ�~�W[�ؤo]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M12_14;
          Exit;
        end;

        FCDSDli620_ccl.RecNo:=tmpRecno1;
        tmpStr2:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);
        if (Length(tmpStr2)>0) and (tmpStr2<>'/') then   //��"/"�ɤ��ˬd
        begin
          isOK:=False;
          s1:='';
          s2:='';
          pos1:=Pos(',',tmpStr1);    //�̦h2�ӭȡA4���զX
          if pos1>0 then
          begin
            s1:=LeftStr(tmpStr1,pos1-1);
            tmpStr1:=Copy(tmpStr1,pos1+1,100);
            pos1:=Pos(',',tmpStr1);
            if pos1>0 then
               tmpStr1:=LeftStr(tmpStr1,pos1-1);
          end;

          pos1:=Pos(',',tmpStr2);    //�̦h2�ӭȡA4���զX
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
            Result:='�Ȥ�~�W[�ؤo]�ˮ֥���!';
            Exit;
          end;
        end;
      end;
    end;

    //��16�X
    FCDSDli620_ccl.Filtered:=False;
    FCDSDli620_ccl.Filter:='CodeId=3';
    FCDSDli620_ccl.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.MLast_1, SMRec.MLast);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[���~�O]�ˮ֥���,�����ѼƳ]�w:'+SMRec.MLast_1;
      Exit;
    end;

    FCDSDli620_ccl.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValue').AsString);  //�Ҧ����e���ݥX�{
    if tmpStr1='/' then                                              //�����ؤ��ˬd
       Exit;

    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)=0 then
        begin
          Result:='�Ȥ�~�W[���~�O]�ˮ֥���,���ݦ��U�C��'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValueNo').AsString);  //�Ҧ����e����X�{
    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          Result:='�Ȥ�~�W[���~�O]�ˮ֥���,���঳�U�C��'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_ccl.FieldByName('StdValueOne').AsString);  //�䤤���@���ݥX�{
    if Length(tmpStr1)>0 then
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[���~�O]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
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

  //�d��ŦX����O��
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
    //��2�X
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=4';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M2, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[���t]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M2;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[���t]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //��3�X
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=5';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M3, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[���~�O]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M3;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);  //�Ҧ����e���ݥX�{
    if tmpStr1='/' then                                             //�����ؤ��ˬd
       Exit;

    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)=0 then
        begin
          Result:='�Ȥ�~�W[���~�O]�ˮ֥���,���ݦ��U�C��'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValueNo').AsString);  //�Ҧ����e����X�{
    if Length(tmpStr1)>0 then
    begin
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
      for i:=0 to tmpList.Count-1 do
      begin
        if Pos(tmpList.Strings[i],C_sizes)>0 then
        begin
          Result:='�Ȥ�~�W[���~�O]�ˮ֥���,���঳�U�C��'+#13#10+tmpStr1;
          Exit;
        end;
      end;
    end;

    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValueOne').AsString);  //�䤤���@���ݥX�{
    if Length(tmpStr1)>0 then
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[���~�O]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //��4-7�X
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=6';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M4_7, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[����]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M4_7;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[����]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //��8-10�X
    FCDSDli620_pp.Filtered:=False;
    FCDSDli620_pp.Filter:='CodeId=7';
    FCDSDli620_pp.Filtered:=True;
    tmpRecno1:=FindRecNo(SMRec.M8_10, SMRec.M18);
    if tmpRecno1=-1 then
    begin
      Result:='�Ȥ�~�W[RC]�ˮ֥���,�����ѼƳ]�w:'+SMRec.M8_10;
      Exit;
    end;

    FCDSDli620_pp.RecNo:=tmpRecno1;
    tmpStr1:=Trim(FCDSDli620_pp.FieldByName('StdValue').AsString);
    if (Length(tmpStr1)>0) and (tmpStr1<>'/') then     //��"/"�ɤ��ˬd
    begin
      isOK:=False;
      tmpList.DelimitedText:=StringReplace(tmpStr1,'�A',',',[rfReplaceAll]);
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
        Result:='�Ȥ�~�W[RC]�ˮ֥���,�����U�C�Ȥ��@'+#13#10+tmpStr1;
        Exit;
      end;
    end;

    //�ؤo
    if not isPN then
    begin
      tmpStr1:=LeftStr(SMRec.M14_16,2)+'.'+RightStr(SMRec.M14_16,1);
      tmpStr2:=tmpStr1+'x'+SMRec.M11_13+'G';
      tmpStr1:=SMRec.M11_13+'M*'+tmpStr1;
      if (Pos(tmpStr1,C_sizes)=0) and (Pos(tmpStr2,C_sizes)=0) then
      begin
        isAsk:=True;
        Result:='�Ȥ�~�W[�ؤo]�ˮ֥���,����'+#13#10+tmpStr1+'��'+tmpStr2;
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

  //�O�_�ˬd�Ȥ�~�W�����cisChkStruct
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

  //AC111�BAC082���c���s����
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
            Result:='�Ȥ�~�W[���c]�ˮ֥���!'+#13#10+'�����Ȥ�'+SMRec.Custno+'�����c�]�w';
            Exit;
          end else
          if Pos(tmpSQL,C_sizes)=0 then
          begin
            Result:='�Ȥ�~�W[���c]�ˮ֥���,����'+tmpSQL;
            Exit;
          end;
        end;
      end;
    end;
  end else
  begin
    tmpStruct:=Struct;

    //���c�L�Ѽ�,���s����
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
        Result:='�Ȥ�~�W[���c]�ˮ֥���,����'+tmpStruct;
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

  //�O�_�ˬd�Ȥ�~�W��pnl�ؤoisChkSizes
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
      if Locate('Sizes',SMRec.M9_11,[]) then   //�g�V
         tmpSizes1:=FieldByName('fValue').AsString;
      if Locate('Sizes',SMRec.M12_14,[]) then  //�n�V
         tmpSizes2:=FieldByName('fValue').AsString;
    end;
  end;

  if SameText(SMRec.Custno,'AC111') and (SMRec.M12_14='43') then
  begin
    if Pos(SMRec.M9_11+'X42.5',C_Sizes)=0 then
    begin
      Result:='�Ȥ�~�W[PNL�ؤo]�ˮ֥���!'+SMRec.M9_11+'X42.5';
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
     (Pos('�g'+SMRec.M9_11+'*�n'+SMRec.M12_14,C_Sizes)=0) and
     (Pos(SMRec.M9_11+'*'+SMRec.M12_14+'�n',C_Sizes)=0) and
     (Pos(tmpSizes1+'W*'+tmpSizes2+'F',C_Sizes)=0) and
     (Pos(tmpSizes1+'(W)*'+tmpSizes2+'(T)',C_Sizes)=0) and
     (Pos(tmpSizes1+'MM*'+tmpSizes2+'MM',C_Sizes)=0) and
     (Pos(tmpSizes1+'mm*'+tmpSizes2+'mm',C_Sizes)=0) and
     (Pos('�g'+tmpSizes1+'MM*�n'+tmpSizes2+'MM',C_Sizes)=0) and
     (Pos('�g'+tmpSizes1+'mm*�n'+tmpSizes2+'mm',C_Sizes)=0) and
     (g_UInfo^.UserId<>'ID150515')
      then
  begin
    Result:='�Ȥ�~�W[PNL�ؤo]�ˮ֥���!';
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
      if Locate('Sizes',SMRec.M11_13,[]) then   //�g�V
         tmpSizes1:=FieldByName('fValue').AsString;
      if Locate('Sizes',SMRec.M14_16,[]) then   //�n�V
         tmpSizes2:=FieldByName('fValue').AsString;
    end;
  end;

  if ((Pos(SMRec.M11_13,C_sizes)=0) and (Pos(tmpSizes1,C_sizes)=0)) or
     ((Pos(SMRec.M14_16,C_sizes)=0) and (Pos(tmpSizes2,C_sizes)=0)) then
  begin
    Result:='�Ȥ�~�W[PNL�ؤo]�ˮ֥���!';
    Exit;
  end;
end;

end.
