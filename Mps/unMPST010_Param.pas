{*******************************************************}
{                                                       }
{                unMPST010_Param                        }
{                Author: kaikai                         }
{                Create date: 2015/5/3                  }
{                Description: �Ƶ{�Ѽ�                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_Param;

interface

uses
   Classes, SysUtils, Variants, DBClient, StrUtils, DB, Math, unGlobal,
   unCommon, unMPST010_units;

 const l_Premark='�w�O�d';

type
  TMPST010_Param = class
  private
    FCDS1:TCLientDataSet;
    FCDS2:TCLientDataSet;
    FCDS3:TCLientDataSet;
    FCDS4:TCLientDataSet;
    FCDS5:TCLientDataSet;
    FCDS6:TCLientDataSet;
    FCDS7:TCLientDataSet;
    FCDS8:TCLientDataSet;
    FCDS10:TCLientDataSet;
    FCDS11:TCLientDataSet;
    FCDS12:TCLientDataSet;
    FCDS14:TCLientDataSet;
    FCDS17:TCLientDataSet;
    FCDS18:TCLientDataSet;
    function GetCCLData(xType:string):OleVariant;
    function GetOldEmptyData:OleVariant;
  public
    constructor Create;
    destructor Destroy; override;
    procedure GetParameData_Init;
    procedure GetParameData_Exec;
    procedure GetParameData_Stealno;
    procedure GetAllStealno(Machine:string; var Result:TStrings);
    function GetBooks(Machine: string): Double;
    procedure GetStealnoList(SMRec:TSplitMaterialno; Machine:string;
      P:POrderRec; var Result:TStrings);
    function IsGZLine(SMRec:TSplitMaterialno; Custno:string):Integer;
    function IsGZLineInside(SMRec:TSplitMaterialno; Custno:string):Integer;
    function GetAdCode(SMRec:TSplitMaterialno; P:POrderRec;
      Machine:string):Integer;
    function GetBookQty(SMRec:TSplitMaterialno; P:POrderRec;
      Machine:string):Double;
    function GetOtherSize(S9_S11:string; isChkSize:Boolean):string;
    function GetMachineFilter(var SMRec:TSplitMaterialno; P:POrderRec):string;
    function GetCustnoAdCode(Machine:string):string;
    function DeMachine(SMRec:TSplitMaterialno; var xFilter:string):Boolean;
    function CheckStealno(SMRec:TSplitMaterialno):Boolean;
    function GetCustRemark(Custno,Pno:string):string;
    function ReplaceCustnoGroup(Premark:string):string;
  published
    property OldEmptyData:OleVariant read GetOldEmptyData;
    property CDS_ChanNeng:TClientDataSet read FCDS2;
  end;

implementation

{ TMPST010_Param }

constructor TMPST010_Param.Create;
begin
  FCDS1:=TClientDataSet.Create(nil);   //���O
  FCDS2:=TClientDataSet.Create(nil);   //����
  FCDS3:=TClientDataSet.Create(nil);   //���粣��
  FCDS4:=TClientDataSet.Create(nil);   //�X��W�d
  FCDS5:=TClientDataSet.Create(nil);   //���t����
  FCDS6:=TClientDataSet.Create(nil);   //OZ�P�s�X
  FCDS7:=TClientDataSet.Create(nil);   //��xbook���Ɣ�
  FCDS8:=TClientDataSet.Create(nil);   //GZ�u
  //FCDS9:=TClientDataSet.Create(nil);   //�w�Ʋ��Ȥ�s����
  FCDS10:=TClientDataSet.Create(nil);  //�����窺���v���
  FCDS11:=TClientDataSet.Create(nil);  //�̫���O
  FCDS12:=TClientDataSet.Create(nil);  //�S��ؤo
  FCDS14:=TClientDataSet.Create(nil);  //���t�զX���c���w��x
  //FCDS16:=TClientDataSet.Create(nil);  //�Ȥ�s����
  FCDS17:=TClientDataSet.Create(nil);  //�Ȥ�Ƶ�
  FCDS18:=TClientDataSet.Create(nil);  //�Ȥ�s��
end;

destructor TMPST010_Param.Destroy;
begin
  FreeAndNil(FCDS1);
  FreeAndNil(FCDS2);
  FreeAndNil(FCDS3);
  FreeAndNil(FCDS4);
  FreeAndNil(FCDS5);
  FreeAndNil(FCDS6);
  FreeAndNil(FCDS7);
  FreeAndNil(FCDS8);
  FreeAndNil(FCDS10);
  FreeAndNil(FCDS11);
  FreeAndNil(FCDS12);
  FreeAndNil(FCDS14);
  FreeAndNil(FCDS17);
  FreeAndNil(FCDS18);
  
  inherited Destroy;
end;

function TMPST010_Param.GetCCLData(xType:string):OleVariant;
var
  tmpSQL:string;
  Data1:OleVariant;
begin
  TmpSQL:='exec proc_GetCCL '+xType+','+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data1) then
     Result:=Data1
  else
     Result:=null;
end;

//�@�~��l�ƨϥ�
procedure TMPST010_Param.GetParameData_Init;
begin
  FCDS11.Data:=GetCCLData('11');
  FCDS1.Data:=GetCCLData('1');

  //�����`�ާ@�ϥ�
  FCDS7.Data:=GetCCLData('7');
end;

//����Ƶ{
procedure TMPST010_Param.GetParameData_Exec;
begin
  FCDS1.Data:=GetCCLData('1');
  FCDS2.Data:=GetCCLData('2');
  FCDS3.Data:=GetCCLData('3');
  FCDS4.Data:=GetCCLData('4');
  FCDS5.Data:=GetCCLData('5');
  FCDS6.Data:=GetCCLData('6');
  FCDS7.Data:=GetCCLData('7');
  FCDS8.Data:=GetCCLData('8');
  //FCDS9.Data:=GetCCLData('9');
  FCDS10.Data:=GetCCLData('10');
  FCDS11.Data:=GetCCLData('11');
  FCDS12.Data:=GetCCLData('12');
  FCDS14.Data:=GetCCLData('14');
  //FCDS16.Data:=GetCCLData('16');
  FCDS17.Data:=GetCCLData('17');
  FCDS18.Data:=GetCCLData('18');
end;

//�ˬd���O
procedure TMPST010_Param.GetParameData_Stealno;
begin
  FCDS1.Data:=GetCCLData('1');
  FCDS12.Data:=GetCCLData('12');
end;

//�Y���x�Y�ɶ��q���Ҧ����O,�ýվ���O����
procedure TMPST010_Param.GetAllStealno(Machine:string; var Result:TStrings);
var
  i:Integer;
  tmpStealno:string;
  tmpMinNum:Integer;
  tmpList:TStrings;
begin
  tmpList:=TStringList.Create;
  Result.BeginUpdate;
  try
    Result.Clear;
    with FCDS1 do
    begin
      Filtered:=False;
      Filter:='machine='+Quotedstr(Machine);
      Filtered:=True;
      IndexFieldNames:='id';
      First;
      while not Eof do
      begin
        tmpStealno:=FieldByName('stealno').AsString;
        tmpMinNum:=FieldByName('minNum').AsInteger;
        while tmpMinNum<=FieldByName('maxNum').AsInteger do
        begin
          Result.Add(tmpStealno+'-'+IntToStr(tmpMinNum));
          Inc(tmpMinNum);
        end;
        Next;
      end;
    end;

    if FCDS11.Locate('machine', Machine, [loCaseInsensitive]) then
    begin
      tmpList.Clear;
      tmpList.AddStrings(Result);
      tmpMinNum:=tmpList.IndexOf(FCDS11.FieldByName('Stealno').AsString)+1;
      for i:=tmpList.Count -1 downto tmpMinNum do
      begin
        Result.Delete(Result.Count-1);
        Result.Insert(0, tmpList.Strings[i]);
      end;
    end;
  finally
    Result.EndUpdate;
    FreeAndNil(tmpList);
  end;
end;

//���X���W������i�ο��O
procedure TMPST010_Param.GetStealnoList(SMRec:TSplitMaterialno; Machine:string;
  P:POrderRec; var Result:TStrings);
var
  tmpMinNum:Integer;
  tmpStealno:string;
begin
  Result.Clear;
  with FCDS1 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and longitude_lower<='+Quotedstr(SMRec.M9_11)
           +' and longitude_upper>='+Quotedstr(SMRec.M9_11)
           +' and latitude_lower<='+Quotedstr(SMRec.M12_14)
           +' and latitude_upper>='+Quotedstr(SMRec.M12_14)
           +' and minNum<=maxNum and (stealno is not null) and (stealno<>'''')';
    Filtered:=True;
    IndexFieldNames:='id';
    if not IsEmpty then
    begin
      First;
      Result.Clear;
      tmpStealno:=FieldByName('stealno').AsString;
      tmpMinNum:=FieldByName('minNum').AsInteger;
      while tmpMinNum<=FieldByName('maxNum').AsInteger do
      begin
        Result.Add(tmpStealno+'-'+IntToStr(tmpMinNum));
        Inc(tmpMinNum);
      end;
    end;
  end;

  if (Result.Count=0) and
     (not VarIsNull(P^.machine1)) and
     (not VarIsNull(P^.sdate1)) and
     (not VarIsNull(P^.boiler1)) then
    Result.Add('niu-b');
end;

//����xBook����
function TMPST010_Param.GetBooks(Machine:string):Double;
begin
  if FCDS7.Locate('machine', Machine, [loCaseInsensitive]) then
     Result:=FCDS7.FieldByName('books').AsFloat
  else
     Result:=0;
end;

//���CBook���i��
function TMPST010_Param.GetBookQty(SMRec:TSplitMaterialno; P:POrderRec;
  Machine:string):Double;
var
  tmpCwcode:Double;
  tmpAd_type:string;
begin
  //���t����
  tmpAd_type:='@@@@';
  with FCDS5 do
  begin
    First;
    while not Eof do
    begin
      if Pos('/'+SMRec.M2+'/',FieldByName('adhesive').AsString)>0 then
      begin
        tmpAd_type:=FieldByName('adhesive_type').AsString;
        Break;
      end;
      Next;
    end;
  end;

  //�ɫp������OZ
  if FCDS6.Locate('materialno', SMRec.M7_8, [loCaseInsensitive]) then
     tmpCwcode:=FCDS6.FieldByName('OZ').AsFloat
  else
     tmpCwcode:=-1234;

  //���粣��
  with FCDS3 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and adhesive_type='+Quotedstr(tmpAd_type)
           +' and cwcode_lower<='+FloatToStr(tmpCwcode)
           +' and cwcode_upper>='+FloatToStr(tmpCwcode)
           +' and strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6);
    Filtered:=True;
    if IsEmpty then
       Result:=0
    else if Pos(SMRec.MLast, 'NK')>0 then
       Result:=FieldByName('nbook_qty').AsFloat
    else
       Result:=FieldByName('book_qty').AsFloat;
  end;
end;

//�P�_�O�_�]GZ�u
//0:!GZ
//1:GZ
//2:All
function TMPST010_Param.IsGZLine(SMRec:TSplitMaterialno; Custno:string):Integer;
begin
  Result:=0;
  if (SMRec.M12_14<'488') or (SMRec.M12_14>'493') or (SMRec.MLast='V') then
     Exit;

  if SameText(SMRec.MLast, 'G') then
     Result:=1
  else
  begin
    FCDS8.Filtered:=False;
    if FCDS8.IsEmpty then
       Exit;

    with FCDS8 do
    begin
      Filtered:=False;
      Filter:='custno=''/*/'''
             +' and strip_lower<='+FloatToStr(SMRec.M3_6)
             +' and strip_upper>='+FloatToStr(SMRec.M3_6);
      Filtered:=True;
      if not IsEmpty then
         if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
            if Pos('/'+SMRec.M7_8+'/',FieldByName('Cwcode').AsString)>0 then
               if Pos('/'+SMRec.MLast_1+'/',FieldByName('Cup').AsString)>0 then
                  Result:=1;

      if Result=0 then
      begin
        Filtered:=False;
        Filter:='custno<>''/*/'' and custno<>''/@/'''
               +' and strip_lower<='+FloatToStr(SMRec.M3_6)
               +' and strip_upper>='+FloatToStr(SMRec.M3_6);
        Filtered:=True;
        if not IsEmpty then
           if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
              if Pos('/'+SMRec.M7_8+'/',FieldByName('Cwcode').AsString)>0 then
                 if Pos('/'+SMRec.MLast_1+'/',FieldByName('Cup').AsString)>0 then
                    if Pos('/'+Custno+'/',FieldByName('Custno').AsString)>0 then
                       Result:=1;

        if Result=0 then
        begin
          Filtered:=False;
          Filter:='custno=''/@/'''
                 +' and strip_lower<='+FloatToStr(SMRec.M3_6)
                 +' and strip_upper>='+FloatToStr(SMRec.M3_6);
          Filtered:=True;
          if not IsEmpty then
             if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
                if Pos('/'+SMRec.M7_8+'/',FieldByName('Cwcode').AsString)>0 then
                   if Pos('/'+SMRec.MLast_1+'/',FieldByName('Cup').AsString)>0 then
                         Result:=2;
        end;
      end;
    end;
  end;
end;

//�P�_�O�_�ŦXGZ�u���W��
//Result:=1
function TMPST010_Param.IsGZLineInside(SMRec:TSplitMaterialno; Custno:string):Integer;
begin
  Result:=0;
  if (SMRec.M12_14<'488') or (SMRec.M12_14>'493') or (SMRec.MLast='V') then
     Exit;

  with FCDS8 do
  begin
    Filtered:=False;
    Filter:='custno<>''/*/'' and custno<>''/@/'''
               +' and strip_lower<='+FloatToStr(SMRec.M3_6)
               +' and strip_upper>='+FloatToStr(SMRec.M3_6);
    Filtered:=True;

    if not IsEmpty then
       if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
          if Pos('/'+SMRec.M7_8+'/',FieldByName('Cwcode').AsString)>0 then
             if Pos('/'+SMRec.MLast_1+'/',FieldByName('Cup').AsString)>0 then
                if Pos('/'+Custno+'/',FieldByName('Custno').AsString)>0 then
                   Result:=1;
  end;
end;

//�����t�X��N�X
function TMPST010_Param.GetAdCode(SMRec:TSplitMaterialno; P:POrderRec;
  Machine:string):Integer;
begin
  Result:=0;

  with FCDS4 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and custno<>''*''';
    Filtered:=True;
    IndexFieldNames:='Code';
    First;
    while not Eof do
    begin
      if Pos('/'+UpperCase(P^.custno)+'/',FieldByName('custno').AsString)>0 then
      begin
        Result:=FieldByName('Code').AsInteger;
        Break;
      end;
      Next;
    end;

    if Result=0 then
    begin
      Filtered:=False;
      Filter:='machine='+Quotedstr(Machine)
             +' and strip_lower<='+FloatToStr(SMRec.M3_6)
             +' and strip_upper>='+FloatToStr(SMRec.M3_6)
             +' and custno=''*''';
      Filtered:=True;
      IndexFieldNames:='Code';
      First;
      while not Eof do
      begin
        if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
        begin
          Result:=FieldByName('Code').AsInteger;
          Break;
        end;
        Next;
      end;
    end;
  end;
end;


//�S��ؤo�ഫ�зǤؤo
function TMPST010_Param.GetOtherSize(S9_S11:string; isChkSize:Boolean):string;
begin
  Result:=S9_S11;
  with FCDS12 do
  begin
    First;
    while not Eof do
    begin
      if Pos('/'+S9_S11+'/', FieldByName('OthSize').AsString)>0 then
      begin
        if isChkSize then
           Result:=FieldByName('ChkSize').AsString
        else
           Result:=FieldByName('StdSize').AsString;
        Break;
      end;
      Next;
    end;
  end;
end;

//���t�զX���c���w�Ͳ��u�O
function TMPST010_Param.DeMachine(SMRec:TSplitMaterialno;
  var xFilter:string):Boolean;
begin
  xFilter:='';
  with FCDS14 do
  begin
    Filtered:=False;
    Filter:='strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and adhesive='+Quotedstr(SMRec.M2)
           +' and code15='+Quotedstr(SMRec.M15);
    Filtered:=True;
    IndexFieldNames:='machine';
    while not Eof do
    begin
      if xFilter<>'' then
         xFilter:=xFilter+' or ';
      xFilter:=xFilter+' Machine='+Quotedstr(FieldByName('Machine').AsString);
      Next;
    end;
  end;

  Result:=Length(xFilter)>0;
  if Result then
     xFilter:=' and ('+xFilter+')';
end;

//�L�o�i�H���x
function TMPST010_Param.GetMachineFilter(var SMRec:TSplitMaterialno;
  P:POrderRec):string;
var
  tmpStr:string;
  gzFlag:Integer;
begin
  Result:='';

  SMRec.M1:=UpperCase(Copy(P^.materialno,1,1));
  SMRec.M2:=UpperCase(Copy(P^.materialno,2,1));
  SMRec.M3_6:=StrToFloat(Copy(P^.materialno,3,4))/10000;
  SMRec.M7_8:=UpperCase(Copy(P^.materialno,7,2));
  SMRec.M9_11:=UpperCase(Copy(P^.materialno,9,3));
  SMRec.M12_14:=UpperCase(Copy(P^.materialno,12,3));
  if (SMRec.M12_14>='488') and (SMRec.M12_14<='493') then //�n�V490,�g�V�O�S��ؤo�h�ഫ
      SMRec.M9_11:=GetOtherSize(SMRec.M9_11, False);
  SMRec.M15:=UpperCase(Copy(P^.materialno,15,1));
  SMRec.MLast_1:=UpperCase(Copy(P^.materialno,16,1));
  SMRec.MLast:=RightStr(P^.materialno,1);
  SMRec.Err:=P^.orderno+' '+VarToStr(P^.orderitem)+' '+P^.materialno+' ';

  if (not VarIsNull(P^.machine1)) and
     (not VarIsNull(P^.sdate1)) and
     (not VarIsNull(P^.boiler1)) then
  begin
    Result:='Machine='+Quotedstr(P^.machine1);
    Exit;
  end;

  with FCDS1 do
  begin
    Filtered:=False;
    Filter:='strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and longitude_lower<='+Quotedstr(SMRec.M9_11)
           +' and longitude_upper>='+Quotedstr(SMRec.M9_11)
           +' and latitude_lower<='+Quotedstr(SMRec.M12_14)
           +' and latitude_upper>='+Quotedstr(SMRec.M12_14);

    if not VarIsNull(P^.machine1) then
       Filter:=Filter+' and machine='+Quotedstr(P^.machine1)
    else if DeMachine(SMRec, tmpStr) then
       Filter:=Filter+tmpStr
    else if SMRec.MLast='N' then
       Filter:=Filter+' and machine=''L5'''
    else   
    begin
      gzFlag:=IsGZLine(SMRec, P^.custno);
      if gzFlag=0 then           //����]gz
         Filter:=Filter+' and machine<>''L5'' and machine<>''L6'''
      else if gzFlag=1 then      //�u��]gz
         Filter:=Filter+' and machine=''L6'''
      else if gzFlag=2 then      //��L5�]����
         Filter:=Filter+' and machine<>''L5''';
    end;

    Filtered:=True;
    IndexFieldNames:='machine';
    First;
    while not Eof do
    begin
      if Result<>'' then
         Result:=Result+' or ';
      Result:=Result+'Machine='+Quotedstr(FieldByName('machine').AsString);
      Next;
    end;
  end;
end;

//�i�X�窺�Ȥ᪺�X��N�X(�X��N�X�ۦP,�h�o�ǫȤ�i�X��,�����ɺ�OZ)
function TMPST010_Param.GetCustnoAdCode(Machine:string):string;
begin
  Result:='';

  with FCDS4 do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(Machine)
           +' and custno<>''*''';
    Filtered:=True;
    IndexFieldNames:='Code';
    First;
    while not Eof do
    begin
      Result:=Result+IntToStr(FieldByName('Code').AsInteger)+'/';
      Next;
    end;
  end;

  Result:='/'+Result;
end;

//���X���W������i�ο��O,�P��ڱƪ����O���
//SMRec.MLast=��ڱƪ����O
function TMPST010_Param.CheckStealno(SMRec:TSplitMaterialno):Boolean;
begin
  Result:=False;

  if SMRec.MLast='' then
     Exit;

  with FCDS1 do
  begin
    Filtered:=False;
    Filter:='strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and longitude_lower<='+Quotedstr(SMRec.M9_11)
           +' and longitude_upper>='+Quotedstr(SMRec.M9_11)
           +' and latitude_lower<='+Quotedstr(SMRec.M12_14)
           +' and latitude_upper>='+Quotedstr(SMRec.M12_14)
           +' and (stealno is not null) and (stealno<>'''')';
    Filtered:=True;
    IndexFieldNames:='id';
    while not Eof do
    begin
      Result:=SameText(FieldByName('stealno').AsString, SMRec.MLast);
      if Result then
         Break;
      Next;
    end;
  end;
end;

function TMPST010_Param.GetCustRemark(Custno,Pno:string):string;
var
  code2,code78,code16,code17:string;
  tmpRecno,tmpMaxNum,tmpNum:Integer;
begin
  Result:='';

  if FCDS17.IsEmpty then
     Exit;

  tmpMaxNum:=-1;
  tmpRecno:=-1;
  code2:=Copy(Pno,2,1);
  code78:=Copy(Pno,7,2);
  code16:=LeftStr(RightStr(Pno,2),1);
  code17:=RightStr(Pno,1);
  with FCDS17 do
  begin
    First;
    while not Eof do
    begin
      tmpNum:=0;
      if Pos('/'+Custno+'/','/'+FieldByName('custno').AsString+'/')>0 then
         Inc(tmpNum)
      else if Length(FieldByName('custno').AsString)>0 then
      begin
        Next;
        Continue;
      end;

      if Pos('/'+code2+'/','/'+FieldByName('code2').AsString+'/')>0 then
         Inc(tmpNum)
      else if Length(FieldByName('code2').AsString)>0 then
      begin
        Next;
        Continue;
      end;

      if Pos('/'+code78+'/','/'+FieldByName('code7_8').AsString+'/')>0 then
         Inc(tmpNum)
      else if Length(FieldByName('code7_8').AsString)>0 then
      begin
        Next;
        Continue;
      end;

      if Pos('/'+code16+'/','/'+FieldByName('code16').AsString+'/')>0 then
         Inc(tmpNum)
      else if Length(FieldByName('code16').AsString)>0 then
      begin
        Next;
        Continue;
      end;

      if Pos('/'+code17+'/','/'+FieldByName('code17').AsString+'/')>0 then
         Inc(tmpNum)
      else if Length(FieldByName('code17').AsString)>0 then
      begin
        Next;
        Continue;
      end;

      if (tmpNum>0) and (tmpMaxNum<tmpNum) then
      begin
        tmpMaxNum:=tmpNum;
        tmpRecno:=Recno;
      end;
      if tmpMaxNum=5 then
         Break;
      Next;
    end;
  end;

  if tmpRecno<>-1 then
  begin
    FCDS17.RecNo:=tmpRecno;
    Result:=FCDS17.FieldByName('remark').AsString;
  end;
end;

function TMPST010_Param.ReplaceCustnoGroup(Premark:string):string;
var
  ret:string;
begin
  if (Length(Premark)>0) and (not FCDS18.IsEmpty) then
  begin
    ret:=StringReplace(Premark,l_Premark,'',[rfReplaceAll]);
    if Length(ret)>0 then
    begin
      ret:=','+ret+',';
      with FCDS18 do
      begin
        First;
        while not Eof do
        begin
          if Pos(FieldByName('groupId').AsString, ret)>0 then
             ret:=StringReplace(ret,FieldByName('groupId').AsString,FieldByName('custno').AsString,[rfReplaceAll]);
          Next;
        end;
      end;
    end;
    Result:=ret;
  end else
    Result:=Premark;
end;

function TMPST010_Param.GetOldEmptyData:OleVariant;
begin
  Result:=FCDS10.Data;
end;

end.
