unit unDLIR050_units;

interface

uses
  SysUtils, Variants, Math, DBCLient, unCommon, unGlobal;

  function GetResin(Custno,M2,M18:string; isCCL:Boolean):string;
  function GetCPK(Custno:string; isCCL:Boolean):string;
  
  function GetCopperVisible(Custno,M2:string):string;
  function GetCopper(LotFilter,Dno,Ditem:string):string;

  function GetPPVisible_CCL(Custno,M2,Struct:string):string;
  function GetPP_CCL(SMRec:TSplitMaterialno;
    LotFilter,Dno,Ditem,Struct,C_Sizes:string):string;
                   
implementation

//取樹脂
function GetResin(Custno,M2,M18:string; isCCL:Boolean):string;
var
  bo:Boolean;
  ret:string;
begin
  ret:='';
  if isCCL then
  begin
    bo:=(Pos(Custno,'AC093/AC394/AC844/AC152')>0) or (SameText(Custno, 'AC111') and (Pos(M2,'6/F/4/8/A')>0));
    ret:=CheckLang('長春');
  end else
  begin
    bo:=Pos(Custno,'AC394/AC844/AC152/AC111/AC093')>0;
    if bo then
    begin
      if SameText(Custno, 'AC151') and ((Pos(M2,'L/1/J')>0) or (SameText(M2, 'U') and SameText(M18,'X'))) then
         ret:=CheckLang('晉一')
      else
         ret:=CheckLang('長春');
    end;
  end;

  if not bo then
     ret:='';
  Result:=ret;
end;

//取CPK
function GetCPK(Custno:string; isCCL:Boolean):string;
var
  ret:string;
begin
  ret:='';
  Randomize;
  if isCCL then
  begin
    if Pos(Custno,'AC394/AC844/AC152/AC151')>0 then
    begin
      if SameText(Custno, 'AC151') then
         ret:='1.3'+IntToStr(RandomRange(3,9))
      else
         ret:='1.5'+IntToStr(RandomRange(1,9));
    end;
  end else
  begin
    if Pos(Custno,'AC093/AC394/AC844/AC152')>0 then
    begin
      if SameText(Custno, 'AC151') then
         ret:='1.3'+IntToStr(RandomRange(3,9))
      else
         ret:='1.5'+IntToStr(RandomRange(1,9));
    end;
  end;
  Result:=ret;
end;

//CCL銅箔顯示否
function GetCopperVisible(Custno,M2:string):string;
var
  ret:Boolean;
begin
  ret:=(Pos(Custno, 'AC405/AC075/AC310/AC311/AC950/AC093/AC394/AC844/AC152/N013/AC082/AC434/N023')>0) or
       (SameText(Custno, 'AC111') and (Pos(M2,'6/F/4/8/A/U')>0)) or
       ((Pos(Custno, 'AC820/AC526/AC121/ACA97')>0) and (Pos(M2,'6/F/8/Q')>0)) or
       (SameText(Custno, 'DDE') and (M2='8')) or
       ((Pos(Custno, 'AC096/AC174')>0) and (M2='6')) or
       (SameText(Custno, 'AC178') and SameText(M2,'U'));
  if ret then
     Result:='1'
  else
     Result:='0';
end;

//取CCL銅箔
function GetCopper(LotFilter,Dno,Ditem:string):string;
var
  tmpSQL,ret:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  //批號第11位
  ret:='';
  tmpSQL:='Select Supplier From Dli210 Where Copper in'
         +' (Select Substring(manfac,11,1) x From Dli040'
         +' Where Dno='+Quotedstr(Dno)
         +' And Ditem='+Ditem
         +' And Bu='+Quotedstr(g_UInfo^.BU)+LotFilter
         +' And Len(manfac)>10)'
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Group By Supplier';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        ret:=ret+','+tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;
      if Length(ret)>0 then
         Delete(ret,1,1);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
  Result:=ret;
end;

//CCL玻布顯示否
function GetPPVisible_CCL(Custno,M2,Struct:string):string;
var
  bo:Boolean;
  ret:Boolean;
begin
  ret:=(Pos(Custno,'AC405/AC075/AC310/AC311/AC950/AC093/AC394/AC844/AC152/N013/AC082/N023')>0) or
       (SameText(Custno, 'AC111') and (Pos(M2,'6/F/4/8/A/U')>0)) or
       ((Pos(Custno, 'AC820/AC526/AC121/ACA97')>0) and (Pos(M2,'6/F/8/Q')>0)) or
       (SameText(Custno, 'DDE') and (M2='8')) or
       ((Pos(Custno, 'AC096/AC174')>0) and (M2='6')) or
       (SameText(Custno, 'AC178') and SameText(M2,'U')) or
        SameText(Custno, 'AC082') or
       (SameText(Custno, 'AC178') and SameText(M2,'U')) or
       (Pos(Custno, 'AC365/AC434/AC114/AC388')>0);
  if ret then
     Result:='1'
  else
     Result:='0';

  if SameText(Custno, 'AC178') then
  begin
    bo:=(Pos('7628',Struct)>0) or (Pos('1506',Struct)>0) or
        (Pos('1086',Struct)>0) or (Pos('1037',Struct)>0) or
        (Pos('106',Struct)>0) or (Pos('1080',Struct)>0) or
        (Pos('3313',Struct)>0) or (Pos('2116',Struct)>0);
    if not bo then
       Result:='0';
  end;
end;

//取CCL玻布
function GetPP_CCL(SMRec:TSplitMaterialno;
  LotFilter,Dno,Ditem,Struct,C_Sizes:string):string;
var
  isCY:Boolean;
  tmpSQL,ret:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  ret:='';
  isCY:=Pos(SMRec.Custno, 'AC405/AC075/AC310/AC311/AC950')>0; //超毅
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if SameText(SMRec.Custno, 'AC082') or
       (SameText(SMRec.Custno, 'AC178') and SameText(SMRec.M2,'U')) or
       (Pos(SMRec.Custno, 'AC365/AC434/AC114/AC388')>0) then
    begin
      if SameText(SMRec.Custno, 'AC082') then
      begin
        //客戶品名
        Data:=null;
        tmpSQL:='Select GlassCloth,Supplier From Dli200'
               +' Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Len(GlassCloth)>4';
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data:=Data;
          while not tmpCDS.Eof do
          begin
            if Pos(tmpCDS.Fields[0].AsString,C_Sizes)>0 then
               ret:=ret+','+tmpCDS.Fields[1].AsString;
            tmpCDS.Next;
          end;
          if Length(ret)>0 then
             Delete(ret,1,1);
        end;
      end else
      if SameText(SMRec.Custno, 'AC178') then
      begin
        if (Pos('7628',Struct)>0) or
           (Pos('1506',Struct)>0) then
           ret:=CheckLang('台玻')
        else
           ret:=CheckLang('宏和');
      end;

      if Length(ret)=0 then
      begin
        if SameText(SMRec.Custno, 'AC082') and (Pos(SMRec.M2, '468F')>0) and
           ((Pos('7628',Struct)>0) or (Pos('2116',Struct)>0)) then
           ret:=CheckLang('台嘉')
        else
           ret:=CheckLang('宏和');
      end;
    end
    else if SameText(SMRec.Custno, 'N013') or
           ((Pos(SMRec.Custno, 'AC820/AC526/AC121/ACA97')>0) and (Pos(SMRec.M2,'6/F/8/Q')>0)) then
    begin
      //批號第12位
      Data:=null;
      tmpSQL:='Select Supplier,1 id From Dli200 Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And GlassCloth in (Select Substring(manfac,12,1) x From Dli040'
             +' Where Dno='+Quotedstr(Dno)
             +' And Ditem='+Ditem
             +' And Bu='+Quotedstr(g_UInfo^.BU)+LotFilter
             +' And Len(manfac)>11)'
             +' Group By Supplier';
      if SameText(SMRec.Custno, 'N013') then
         tmpSQL:=tmpSQL+' Union ALL Select Supplier,2 id From Dli200 Where Bu='+Quotedstr(g_UInfo^.BU)
                       +' And GlassCloth in (Select Substring(manfac,13,1) x From Dli040'
                       +' Where Dno='+Quotedstr(Dno)
                       +' And Ditem='+Ditem
                       +' And Bu='+Quotedstr(g_UInfo^.BU)+LotFilter
                       +' And Len(manfac)>12)'
                       +' Group By Supplier';
      tmpSQL:=tmpSQL+' Order By id';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data:=Data;
        while not tmpCDS.Eof do
        begin
          if Pos(tmpCDS.Fields[0].AsString,ret)=0 then
             ret:=ret+','+tmpCDS.Fields[0].AsString;
          tmpCDS.Next;
        end;
        if Length(ret)>0 then
           Delete(ret,1,1);
      end;
    end
    else if SameText(SMRec.Custno, 'N023') then //聯茂新蒲
    begin
      if SameText(SMRec.M2,'O') then
         ret:=CheckLang('臺玻')
      else begin
        //查詢掃描批號
        Data:=null;
        tmpSQL:='Select Distinct Left(manfac,10)+''%'' lot From Dli040'
               +' Where Dno='+Quotedstr(Dno)
               +' And Ditem='+Ditem
               +' And Bu='+Quotedstr(g_UInfo^.BU)+LotFilter;
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS.Data:=Data;
          tmpSQL:='';
          while not tmpCDS.Eof do
          begin
            if tmpSQL<>'' then
               tmpSQL:=tmpSQL+' or ';
            tmpSQL:=tmpSQL+' tc_sih02 Like '+Quotedstr(tmpCDS.Fields[0].AsString);
            tmpCDS.Next;
          end;

          //查詢報工批號,取12碼
          if tmpSQL<>'' then
          begin
            Data:=null;
            tmpSQL:='Select tc_sih02 From '+g_UInfo^.BU+'.tc_sih_file Inner Join '+g_UInfo^.BU+'.shb_file'
                   +' on tc_sih01=shb01 Where ('+tmpSQL+') and shbacti=''Y''';
            if QueryBySQL(tmpSQL, Data, 'ORACLE') then
            begin
              tmpCDS.Data:=Data;
              tmpSQL:='';
              while not tmpCDS.Eof do
              begin
                if Length(tmpCDS.Fields[0].AsString)>11 then
                begin
                  if tmpSQL<>'' then
                     tmpSQL:=tmpSQL+',';
                  tmpSQL:=tmpSQL+Quotedstr(Copy(tmpCDS.Fields[0].AsString,12,1));
                end;
                tmpCDS.Next;
              end;

              //報工批號12碼查詢玻布供應商
              if tmpSQL<>'' then
              begin
                Data:=null;
                tmpSQL:='Select Distinct Supplier From Dli200 Where Bu='+Quotedstr(g_UInfo^.BU)
                       +' And GlassCloth in ('+tmpSQL+') Group By Supplier';
                if QueryBySQL(tmpSQL, Data) then
                begin
                  tmpCDS.Data:=Data;
                  tmpSQL:='';
                  while not tmpCDS.Eof do
                  begin
                    if tmpSQL<>'' then
                       tmpSQL:=tmpSQL+',';
                    tmpSQL:=tmpSQL+tmpCDS.Fields[0].AsString;
                    tmpCDS.Next;
                  end;

                  ret:=tmpSQL;
                end;
              end;
            end;
          end;
        end;
      end
    end
    else if SameText(SMRec.Custno,'AC075') and SameText(SMRec.M2,'Q') and
      (SMRec.M3_6=43) and (SMRec.M7_8='11') and SameText(SMRec.M15,'B') then
      ret:='AST'
    else if isCY and (Pos(SMRec.M2, '16FJ')>0) then
    begin
      if (Pos('7627',Struct)>0) or (Pos('7628',Struct)>0) or
         (Pos('2116',Struct)>0) or (Pos('7630',Struct)>0) then
         ret:=CheckLang('臺嘉')
      else
         ret:=CheckLang('宏和');
    end
    else if isCY and (SMRec.M2='Q') then
      ret:=CheckLang('宏和')
    else if isCY and (Pos(SMRec.M2, 'EU')>0) then
      ret:='AST'
    else if Pos(SMRec.Custno,'AC093/AC394/AC844/AC152')>0 then
    begin
      //客戶品名
      Data:=null;
      tmpSQL:='Select GlassCloth,Supplier From Dli200'
             +' Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Len(GlassCloth)>4';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS.Data:=Data;
        while not tmpCDS.Eof do
        begin
          if Pos(tmpCDS.Fields[0].AsString,C_Sizes)>0 then
             ret:=ret+','+tmpCDS.Fields[1].AsString;
          tmpCDS.Next;
        end;
        if Length(ret)>0 then
           Delete(ret,1,1);
      end;

      if Length(ret)=0 then
      if SameText(SMRec.Custno, 'AC093') then
      begin
        if Pos(SMRec.M2, '468F')>0 then
        begin
          if ((Pos('7628',Struct)>0) or (Pos('2116',Struct)>0)) then
             ret:=CheckLang('台嘉')
          else
             ret:=CheckLang('宏和');
        end
        else if Pos(SMRec.M2, 'HQN')>0 then
          ret:=CheckLang('宏和')
        else if Pos(SMRec.M2, 'EU')>0 then
          ret:=CheckLang('AST');
      end else
        ret:=CheckLang('臺玻');
    end else
      ret:=CheckLang('宏和');

  Result:=ret;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.
