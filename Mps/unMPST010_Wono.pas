unit unMPST010_Wono;


interface

uses
  Classes, SysUtils, DBClient, Forms, Variants, Math, StrUtils,
  unGlobal, unCommon,db;

const l_StrCCL01='CCL-01';
const l_StrCCL03='CCL-03'; //dg全部使用CCL-03製程，若不是CCL-03，儲存時將更新
                           //11.25 CCL-03停用，重新使用CCL-01，若是CCL-03，則更新為CCL-01

type
  TOrderWono = Packed Record
    Machine,
    Orderno,
    Orderitem,
    Pno,
    Sfa03,
    Custno,
    Adhesive,
    Premark     : string;
    Sqty        : Double;
    IsDG        : Boolean;
    Adate       : TDateTime; //生管達交日期
end;

type
  TMPST010_Wono = class
  private
    Fima571:string;         //製程料號
    FList_ima94:TStrings;   //制程編碼CCL-03
    FsfaCDS:TClientDataSet;
    FsfbCDS:TClientDataSet;
    Fta_sfbCDS:TClientDataSet;
    FimaCDS:TClientDataSet;
    FecmCDS:TClientDataSet;
    FsmaCDS:TClientDataSet;
    Fmps240CDS:TClientDataSet;
    FtmpCDS:TClientDataSet;
    function GetLine(Orderno,Machine:string):string;
    function GetDeptno(Machine: string): string;
    function GetWono_Fst(Machine, Custno, Premark: string;Fst:string=''): string;
    procedure ShowSB(msg: string);
    function GetBomStr(IsDG:Boolean; BomStr,Pno,Custno,Adhesive: string): string;
    procedure DeleteRec(wono:string);
    procedure Reset_ecm(OrcDB:string);
    procedure Reset_sfb(OrcDB:string);
    procedure Reset_ta_sfb(OrcDB:string);
  public
    constructor Create;
    destructor Destroy; override;
    function Init(IsDG:Boolean):Boolean;
    function SetWono(OrdWono:TOrderWono; var OutWono:string;Fst:string=''):Boolean;
    function Post(IsDG:Boolean):Boolean;
  end;

implementation

{ TMPST010_Wono }

constructor TMPST010_Wono.Create;
var
  tmpOraDB,tmpSQL:string;
  Data:OleVariant;
begin
  tmpOraDB:='ORACLE';
  FList_ima94:=TStringList.Create;
  FsfaCDS:=TClientDataSet.Create(nil);
  FsfbCDS:=TClientDataSet.Create(nil);
  Fta_sfbCDS:=TClientDataSet.Create(nil);
  FimaCDS:=TClientDataSet.Create(nil);
  FecmCDS:=TClientDataSet.Create(nil);
  FsmaCDS:=TClientDataSet.Create(nil);
  Fmps240CDS:=TClientDataSet.Create(nil);
  FtmpCDS:=TClientDataSet.Create(nil);

  FsfaCDS.DisableStringTrim:=True;
  FsfbCDS.DisableStringTrim:=True;
  Fta_sfbCDS.DisableStringTrim:=True;
  FimaCDS.DisableStringTrim:=True;
  FecmCDS.DisableStringTrim:=True;
  FsmaCDS.DisableStringTrim:=True;
  Fmps240CDS.DisableStringTrim:=True;
  FtmpCDS.DisableStringTrim:=True;

  //環境設定參數
  ShowSB('正在查詢[環境設定參數]');
  tmpSQL:=' Select sma_file.*, ''dg'' db From iteqdg.sma_file Where sma00=''0'''
         +' Union All'
         +' Select sma_file.*, ''gz'' db From iteqgz.sma_file Where sma00=''0''';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Abort;
  FsmaCDS.Data:=Data;

  //工單單頭
  ShowSB('正在查詢[工單單頭資料]');
  Data:=null;
  tmpSQL:='Select * From sfb_file Where 1=2';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Abort;
  FsfbCDS.Data:=Data;

  //工單單身
  ShowSB('正在查詢[工單單身資料]');
  Data:=null;
  tmpSQL:='Select * From sfa_file Where 1=2';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Abort;
  FsfaCDS.Data:=Data;

  //工單擴展
  ShowSB('正在查詢[工單擴展資料]');
  Data:=null;
  tmpSQL:='Select * From ta_sfb_file Where 1=2';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Abort;
  Fta_sfbCDS.Data:=Data;

//  ShowSB('正在查詢[工單制程追蹤]');
//  Data:=null;
//  tmpSQL:='Select * From ecm_file Where 1=2';
//  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
//     Abort;
//  FecmCDS.Data:=Data;

  //Bom虛擬料號
  ShowSB('正在查詢[Bom銅箔使用資料]');
  Data:=null;
  tmpSQL:='Select * From MPS240 Where bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data) then
     Abort;
  Fmps240CDS.Data:=Data;
end;

destructor TMPST010_Wono.Destroy;
begin
  FreeAndNil(FList_ima94);
  FreeAndNil(FsfaCDS);
  FreeAndNil(FsfbCDS);
  FreeAndNil(Fta_sfbCDS);
  FreeAndNil(FimaCDS);
  FreeAndNil(FecmCDS);
  FreeAndNil(FsmaCDS);
  FreeAndNil(Fmps240CDS);
  FreeAndNil(FtmpCDS);

  inherited;
end;

procedure TMPST010_Wono.ShowSB(msg:string);
begin
  g_StatusBar.Panels[0].Text:=msg;
  Application.ProcessMessages;
end;

//取單頭
function TMPST010_Wono.GetWono_Fst(Machine, Custno, Premark: string; Fst: string = ''): string;
begin
  if length(Fst) = 3 then
  begin
    Result := Fst + '-' + GetYM;
  end
  else
  begin
    Result := '';
  
  //ACA90技服、AC485研發
    if SameText(Machine, 'L6') then
    begin
      if Pos(CheckLang('樣品'), Premark) > 0 then
        Result := 'R15'
      else if (Pos(CheckLang('試制'), Premark) > 0) or (Pos(CheckLang('試製'), Premark) > 0) then
        Result := 'R1P';
    end
    else
    begin
      if SameText(Custno, 'ACA90') or (Pos(CheckLang('樣品'), Premark) > 0) then
        Result := 'R15'
      else if SameText(Custno, 'AC458') or (Pos(CheckLang('試制'), Premark) > 0) or (Pos(CheckLang('試製'), Premark) > 0)
        then
        Result := 'R1P';
    end;

    if Length(Result) = 0 then
    begin
      if Pos(Machine, 'L1/L2/L3/L6') > 0 then
        Result := '516'
      else if Pos(Machine, 'L4/L5') > 0 then
        Result := '51T';
    end;

    if Length(Result) > 0 then
      Result := Result + '-' + GetYM;
  end;
end;


//取線別
function TMPST010_Wono.GetLine(Orderno, Machine: string): string;
const tmpS1='L1,L2,L3,L4,L5,L6';
const tmpS2='A*,B*,C*,D*,E*,A*';   //*多余,截取字符串用
const tmpS3='1*,2*,3*,4*,5*,1*';
var
  pos1:Integer;
begin
  pos1:=Pos(Machine, tmpS1);
  if pos1>0 then
  begin
    if Pos(LeftStr(Orderno,3), '222/223/227/22G/228/P1Z/P2Z')>0 then  //內銷
       Result:=Copy(tmpS3, pos1, 1)
    else
       Result:=Copy(tmpS2, pos1, 1);
  end else
    Result:='';
end;

//取成本中心
function TMPST010_Wono.GetDeptno(Machine: string): string;
begin
  if Pos(Machine, 'L1/L2/L3')>0 then
     Result:='1D0033'
  else if Pos(Machine, 'L4/L5')>0 then
     Result:='1D0035'
  else if SameText(Machine, 'L6') then
     Result:='4G1124'
  else
     Result:='';
end;

//替換虛擬料號
function TMPST010_Wono.GetBomStr(IsDG:Boolean; BomStr,Pno,Custno,Adhesive:string):string;
var
  tmpDB,Pno78,Bom3,Bom4,Bom6,Codelst:string;

  function GetCode6(xBom4:string):string;
  begin
    Result:='';

    //Bom3、Bom4、Bom6全部滿足條件
    //另外Custno、Adhesive、CodeLst三個條件,可設置全部*或指定,共8種組合

    with Fmps240CDS do
    begin
      //111全指定
      Filtered:=False;
      Filter:='DB='+Quotedstr(tmpDB)
             +' And Bom3='+Quotedstr(Bom3)
             +' And Bom4='+Quotedstr(xBom4)
             +' And Bom6='+Quotedstr(Bom6)
             +' And Custno<>''*'''
             +' And Adhesive<>''*'''
             +' And CodeLst<>''*''';
      Filtered:=True;
      First;
      while not Eof do
      begin
        if (Pos('/'+UpperCase(Custno)+'/', '/'+UpperCase(FieldByName('Custno').AsString)+'/')>0) and
           (Pos('/'+UpperCase(Adhesive)+'/', '/'+UpperCase(FieldByName('Adhesive').AsString)+'/')>0) and
           (Pos('/'+UpperCase(Codelst)+'/', '/'+UpperCase(FieldByName('CodeLst').AsString)+'/')>0) then
        begin
          Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
          Exit;
        end;
        Next;
      end;

      //110尾碼CodeLst未指定
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno<>''*'''
               +' And Adhesive<>''*'''
               +' And CodeLst=''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if (Pos('/'+UpperCase(Custno)+'/', '/'+UpperCase(FieldByName('Custno').AsString)+'/')>0) and
             (Pos('/'+UpperCase(Adhesive)+'/', '/'+UpperCase(FieldByName('Adhesive').AsString)+'/')>0) then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //101膠系Adhesive未指定
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno<>''*'''
               +' And Adhesive=''*'''
               +' And CodeLst<>''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if (Pos('/'+UpperCase(Custno)+'/', '/'+UpperCase(FieldByName('Custno').AsString)+'/')>0) and
             (Pos('/'+UpperCase(Codelst)+'/', '/'+UpperCase(FieldByName('CodeLst').AsString)+'/')>0) then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //011客戶Custno未指定
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno=''*'''
               +' And Adhesive<>''*'''
               +' And CodeLst<>''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if (Pos('/'+UpperCase(Adhesive)+'/', '/'+UpperCase(FieldByName('Adhesive').AsString)+'/')>0) and
             (Pos('/'+UpperCase(Codelst)+'/', '/'+UpperCase(FieldByName('CodeLst').AsString)+'/')>0) then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //100只指定客戶Custno
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno<>''*'''
               +' And Adhesive=''*'''
               +' And CodeLst=''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if Pos('/'+UpperCase(Custno)+'/', '/'+UpperCase(FieldByName('Custno').AsString)+'/')>0 then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //010只指定膠系Adhesive
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno=''*'''
               +' And Adhesive<>''*'''
               +' And CodeLst=''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if Pos('/'+UpperCase(Adhesive)+'/', '/'+UpperCase(FieldByName('Adhesive').AsString)+'/')>0 then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //001只指定尾碼CodeLst
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno=''*'''
               +' And Adhesive=''*'''
               +' And CodeLst<>''*''';
        Filtered:=True;
        First;
        while not Eof do
        begin
          if Pos('/'+UpperCase(Codelst)+'/', '/'+UpperCase(FieldByName('CodeLst').AsString)+'/')>0 then
          begin
            Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
            Exit;
          end;
          Next;
        end;
      end;

      //000全部未指定
      if Length(Result)=0 then
      begin
        Filtered:=False;
        Filter:='DB='+Quotedstr(tmpDB)
               +' And Bom3='+Quotedstr(Bom3)
               +' And Bom4='+Quotedstr(xBom4)
               +' And Bom6='+Quotedstr(Bom6)
               +' And Custno=''*'''
               +' And Adhesive=''*'''
               +' And CodeLst=''*''';
        Filtered:=True;
        if not IsEmpty then
           Result:= LeftStr(BomStr, 4)+FieldByName('Code6').AsString;
      end;
    end;  
  end;

begin
  Result:='';
  if LeftStr(BomStr, 1)='1' then
  begin
    if IsDG then
       tmpDB:='DG'
    else
       tmpDB:='GZ';
    Pno78:=Copy(Pno,7,2);
    Bom3:=Copy(BomStr,3,1);
    Bom4:=Copy(BomStr,4,1);
    Bom6:=Copy(BomStr,6,1);
    Codelst:=RightStr(Pno,1);

    //料號第78碼查找,
    Result:=GetCode6(Pno78);
    if Length(Result)=0 then
       Result:=GetCode6(Bom4);  //Bom料號第4碼再查找
  end;

  if Length(Result)=0 then
     Result:=BomStr;
end;

//判斷sma_file參數及初始化
function TMPST010_Wono.Init(IsDG:Boolean): Boolean;
begin
  Result:=False;
  ShowSB('正在初始化...');
  if IsDG and (not FsmaCDS.Locate('db', 'dg', [])) then
  begin
    ShowMsg('iteqdg系統參數sma_file不存在,請查核..!',48);
    Exit;
  end else
  if (not IsDG) and (not FsmaCDS.Locate('db', 'gz', [])) then
  begin
    ShowMsg('iteqgz系統參數sma_file不存在,請查核..!',48);
    Exit;
  end;

  with FsmaCDS do
  begin
    if (FieldByName('sma28').AsString<>'1') and
       (FieldByName('sma28').AsString<>'2') then
    begin
      ShowMsg('系統參數sma28須為:1或2,請查核..!',48);
      Exit;
    end;

    if (FieldByName('sma26').AsString<>'1') and
       (FieldByName('sma26').AsString<>'2') and
       (FieldByName('sma26').AsString<>'3') then
    begin
      ShowMsg('系統參數sma26(工單生產製程追蹤設定):須為1或2或3,請查核..!',48);
      Exit;
    end;
  end;

  Fima571:='';
  FList_ima94.Clear;

  try
    FsfbCDS.EmptyDataSet;
    FsfbCDS.MergeChangeLog;

    Fta_sfbCDS.EmptyDataSet;
    Fta_sfbCDS.MergeChangeLog;

//    FecmCDS.EmptyDataSet;
//    FecmCDS.MergeChangeLog;

    FsfaCDS.EmptyDataSet;
    FsfaCDS.MergeChangeLog;
    
    Result:=True;
  except
    ShowMsg('初始化CDS失敗,請聯系管理員!',48);
  end;
end;

//刪除sfb
procedure TMPST010_Wono.Reset_sfb(OrcDB:string);
begin
  while not FsfbCDS.IsEmpty do
    FsfbCDS.Delete;
  CDSPost(FsfbCDS, 'sfb_file', OrcDB);
end;

//刪除ta_sfb
procedure TMPST010_Wono.Reset_ta_sfb(OrcDB:string);
begin
  while not Fta_sfbCDS.IsEmpty do
    Fta_sfbCDS.Delete;
  CDSPost(Fta_sfbCDS, 'ta_sfb_file', OrcDB);
end;

//刪除ecm
procedure TMPST010_Wono.Reset_ecm(OrcDB:string);
begin
//  while not FecmCDS.IsEmpty do
//    FecmCDS.Delete;
//  CDSPost(FecmCDS, 'ecm_file', OrcDB);
end;

//提交
function TMPST010_Wono.Post(IsDG:Boolean): Boolean;
var
  i:Integer;
  tmpSQL,tmpOraDB:string;
begin
  Result:=False;
  ShowSB('正在儲存資料...');
  if IsDG then
     tmpOraDB:='ORACLE'
  else
     tmpOraDB:='ORACLE1';

  if not CDSPost(FsfbCDS, 'sfb_file', tmpOraDB) then
     Exit;

  if not CDSPost(Fta_sfbCDS, 'ta_sfb_file', tmpOraDB) then
  begin
    Reset_sfb(tmpOraDB);
    Exit;
  end;

//  if not CDSPost(FecmCDS, 'ecm_file', tmpOraDB) then
//  begin
//    Reset_sfb(tmpOraDB);
//    Reset_ta_sfb(tmpOraDB);
//    Exit;
//  end;

  if not CDSPost(FsfaCDS, 'sfa_file', tmpOraDB) then
  begin
    Reset_sfb(tmpOraDB);
    Reset_ta_sfb(tmpOraDB);
    Reset_ecm(tmpOraDB);
    Exit;
  end;

  if IsDG and (FList_ima94.Count>0) then
  begin
    for i:=0 to FList_ima94.Count-1 do
      tmpSQL:=tmpSQL+','+Quotedstr(FList_ima94.Strings[i]);
    Delete(tmpSQL,1,1);
    tmpSQL:='update ima_file set ima571='+Quotedstr(Fima571)+',ima94='+Quotedstr(l_StrCCL01)
           +' where ima01 in ('+tmpSQL+')';
    try
      PostBySQL(tmpSQL, tmpOraDB);
    except
    end;
  end;

  Result:=True;
end;

//異常刪除
procedure TMPST010_Wono.DeleteRec(wono:string);
begin
  while FsfbCDS.Locate('sfb01', wono, []) do
    FsfbCDS.Delete;

  while Fta_sfbCDS.Locate('ta_sfb01', wono, []) do
    Fta_sfbCDS.Delete;

//  while FecmCDS.Locate('ecm01', wono, []) do
//    FecmCDS.Delete;

  while FsfaCDS.Locate('sfa01', wono, []) do
    FsfaCDS.Delete;
end;

//產生工單號碼
function TMPST010_Wono.SetWono(OrdWono:TOrderWono; var OutWono:string;Fst:string=''):Boolean;
var
  tmpOraDB,tmpSQL,tmpsfb01,tmpecm57,tmpima55,tmpima571,tmpCntMsg,tmpMaxsfb01:string;
  tmpecm03:Integer;
  tmpQty:Double;
  Data:OleVariant;
begin
  Result:=False;
  tmpCntMsg:=OutWono;
  OutWono:='';
  
  if OrdWono.IsDG then
     tmpOraDB:='ORACLE'    //iteqdg
  else
     tmpOraDB:='ORACLE1';  //iteqgz

  ShowSB('正在計算[工單單別]'+tmpCntMsg);
  if Fst<>'' then
    tmpsfb01:=Fst +'-'+ getym
  else
    tmpsfb01:= GetWono_Fst(OrdWono.Machine, OrdWono.Custno, OrdWono.Premark);
  if Length(tmpsfb01)=0 then
  begin
    ShowMsg('計算工單單別失敗'+tmpCntMsg,48);
    Exit;
  end;

  //tmpsfb01:='ABC-XX'; //測試單別
  ShowSB('正在計算[工單號碼]'+tmpCntMsg);
  tmpMaxsfb01:='';
  with FsfbCDS do
  begin
    First;
    while not Eof do
    begin
      if tmpsfb01=LeftStr(FieldByName('sfb01').AsString,6) then
      begin
        if tmpMaxsfb01<FieldByName('sfb01').AsString then
           tmpMaxsfb01:=FieldByName('sfb01').AsString;
      end;
      Next;
    end;
  end;
  if Length(tmpMaxsfb01)=0 then
  begin
    Data:=null;
    tmpSQL:='Select nvl(max(sfb01),'''') as sfb01 From sfb_file'
           +' Where sfb01 like ''' + tmpsfb01 + '%''';
    if not QueryOneCR(tmpSQL, Data, tmpOraDB) then
       Exit;
    tmpsfb01:=GetNewNo(tmpsfb01, VarToStr(Data));
  end else
    tmpsfb01:=GetNewNo(tmpsfb01, tmpMaxsfb01);

  ShowSB('正在查詢[物料基本資料]'+tmpCntMsg);
  Data:=null;
  tmpSQL:='Select ima15,ima55,ima571,ima94 From ima_file'
         +' Where imaacti=''Y'' and ima01='+Quotedstr(OrdWono.Pno);
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Exit;
     
  FimaCDS.Data:=Data;
  if FimaCDS.IsEmpty then
  begin
    ShowMsg(OrdWono.Pno+'物料基本資料不存在,請檢查是否已無效'+tmpCntMsg, 48);
    Exit;
  end;

  if OrdWono.IsDG and (FimaCDS.FieldByName('ima94').AsString=l_StrCCL03) then
  begin
    FList_ima94.Add(OrdWono.Pno);
    if Fima571='' then
    begin
      tmpSQL:='Select ecb01 From ecb_file Where ecb02='+Quotedstr(l_StrCCL01)
             +' And ecbacti=''Y'' And rownum=1';
      if QueryOneCR(tmpSQL, Data, tmpOraDB) then
         Fima571:=VarToStr(Data);
    end;
  end;

  ShowSB('正在添加[工單單頭資料]'+tmpCntMsg);
  with FsfbCDS do
  begin
    Append;
    FieldByName('sfb01').AsString    := tmpsfb01;
    FieldByName('sfb02').AsInteger   := 5;             //工單型態5:重工工單
    FieldByName('sfb04').AsString    := '2';           //工單狀態2:工單已發放
    FieldByName('sfb05').AsString    := OrdWono.Pno;
    if OrdWono.Adate<>0 then
      FieldByName('ta_sfb15').AsDateTime    := OrdWono.Adate;
//    if SameText(FsmaCDS.FieldByName('sma119').AsString,'W') then
//       FieldByName('sfb06').AsString :='001'
//    else if OrdWono.IsDG and (FimaCDS.FieldByName('ima94').AsString=l_StrCCL03) then
//       FieldByName('sfb06').AsString := l_StrCCL01
//    else
//       FieldByName('sfb06').AsString := FimaCDS.FieldByName('ima94').AsString;
    FieldByName('sfb071').AsDateTime := Date;          //產品結構指定有效日期
    FieldByName('sfb08').AsFloat     := OrdWono.Sqty;  //排製量
    FieldByName('sfb081').AsFloat    := 0;
    FieldByName('sfb09').AsFloat     := 0;
    FieldByName('sfb10').AsFloat     := 0;
    FieldByName('sfb11').AsFloat     := 0;
    FieldByName('sfb111').AsFloat    := 0;
    FieldByName('sfb12').AsFloat     := 0;
    FieldByName('sfb121').AsFloat    := 0;
    FieldByName('sfb13').AsDateTime  := Date;          //開工日期
    FieldByName('sfb14').AsString    := '00:00';
    FieldByName('sfb15').AsDateTime  := Date+7;        //完工日期
    FieldByName('sfb16').AsString    := '00:00';
    FieldByName('sfb21').AsString    := 'N';
    FieldByName('sfb22').AsString    := OrdWono.Orderno;
    FieldByName('sfb221').AsInteger  := StrToInt(OrdWono.Orderitem);
    FieldByName('sfb23').AsString    := 'Y';
    FieldByName('sfb24').AsString    := 'N';
    FieldByName('sfb29').AsString    := 'Y';
    FieldByName('sfb39').AsString    := '1';      //完工方式
    FieldByName('sfb41').AsString    := 'N';
    FieldByName('sfb81').AsDateTime  := Date;     //開工單日期
    FieldByName('sfb82').AsString    := GetDeptno(OrdWono.Machine); //部門
    FieldByName('sfb87').AsString    := 'Y';      //確認
    FieldByName('sfb93').AsString    := 'N';
    FieldByName('sfb94').AsString    := 'N';
    FieldByName('sfb95').AsString    := tmpsfb01; //定制單號
    FieldByName('sfb98').AsString    := FieldByName('sfb82').AsString;         //承接部門,成本中心
    FieldByName('sfb99').AsString    := 'Y';
    FieldByName('sfb100').AsString   := '1';
    FieldByName('sfbacti').AsString  := 'Y';
    FieldByName('sfbuser').AsString  := g_UInfo^.UserId;
    FieldByName('sfbgrup').AsString  := '0D9261';
    FieldByName('sfbdate').AsDateTime:= Date;
    FieldByName('ta_sfb01').AsString := '00:00';
    if pos(copy(FieldByName('sfb22').AsString,1,3),'222,223,228')>0 then
      FieldByName('ta_sfb02').AsString := '1'
    else
      FieldByName('ta_sfb02').AsString := 'A'; //生產線別
    FieldByName('ta_sfb03').AsString := 'A';
    FieldByName('ta_sfb04').AsString := tmpsfb01;
    FieldByName('ta_sfb11').AsString := FimaCDS.FieldByName('ima15').AsString; //保稅
    FieldByName('ta_sfb13').AsString := '0';                                   //0一般、1覆捲、2換批號

    Post;
  end;

  ShowSB('正在添加[工單擴展資料]'+tmpCntMsg);
  with Fta_sfbCDS do
  begin
    Append;
    FieldByName('ta_sfb01').AsString := tmpsfb01;
    FieldByName('ta_sfb04').AsString := '0';
    FieldByName('ta_sfb07').AsString := 'X';
    FieldByName('ta_sfb08').AsString := 'X';
 //FieldByName('ta_sfb09').AsString  := ''; //2up尺寸 tc_ksd46?
    FieldByName('ta_sfb10').AsString := '1';
    Post;
  end;

//  ShowSB('正在查詢[工單製程料號]'+tmpCntMsg);
//  if OrdWono.IsDG and (FimaCDS.FieldByName('ima94').AsString=l_StrCCL03) then
//     tmpima571:=Fima571
//  else
//     tmpima571:=FimaCDS.FieldByName('ima571').AsString;
//  if Length(tmpima571)=0 then
//     tmpima571:=' ';
//  Data:=null;
//  tmpSQL:=' Select ecu01,''A'' tmpF From ecu_file Where ecu01='+Quotedstr(tmpima571)
//         +' And ecu02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
//         +' Union'
//         +' Select ecu01,''B'' tmpF From ecu_file Where ecu01='+Quotedstr(OrdWono.Pno)
//         +' And ecu02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
//         +' Order By tmpF';
//  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
//  begin
//    DeleteRec(tmpsfb01);
//    Exit;
//  end;
//
//  FtmpCDS.Data:=Data;
//  if FtmpCDS.IsEmpty then
//  begin
//    DeleteRec(tmpsfb01);
//    ShowMsg('製程料號不存在'+tmpCntMsg+#13#10+tmpima571+#13#10+OrdWono.Pno, 48);
//    Exit;
//  end;
//
//  ShowSB('正在查詢[工單製程資料]'+tmpCntMsg);
//  Data:=null;
//  tmpSQL:=FtmpCDS.Fields[0].AsString;
//  tmpSQL:='Select * From ecb_file Where ecb01='+Quotedstr(tmpSQL)
//         +' And ecb02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
//         +' And ecbacti=''Y'' Order By ecb03';
//  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
//  begin
//    DeleteRec(tmpsfb01);
//    Exit;
//  end;
//
//  FtmpCDS.Data:=Data;
//  if FtmpCDS.IsEmpty then
//  begin
//    DeleteRec(tmpsfb01);
//    ShowMsg('製程資料不存在'+tmpCntMsg, 48);
//    Exit;
//  end;
//
//  ShowSB('正在添加[工單製程資料]'+tmpCntMsg);
//  tmpecm03:=-15698;
//  with FecmCDS do
//  begin
//    while not FtmpCDS.Eof do
//    begin
//      if tmpecm03=-15698 then  //tmpecm03保存第1筆
//         tmpecm03:=FtmpCDS.FieldByName('ecb03').AsInteger;
//      Append;
//      FieldByName('ecm01').AsString     := tmpsfb01;
//      FieldByName('ecm02').AsString     := FsfbCDS.FieldByName('sfb02').AsString;
//      FieldByName('ecm03_par').AsString := OrdWono.Pno;
//      FieldByName('ecm03').AsInteger    := FtmpCDS.FieldByName('ecb03').AsInteger;
//      FieldByName('ecm04').AsString     := FtmpCDS.FieldByName('ecb06').AsString;
//      FieldByName('ecm05').AsString     := FtmpCDS.FieldByName('ecb07').AsString;
//      FieldByName('ecm06').AsString     := FtmpCDS.FieldByName('ecb08').AsString;
//      FieldByName('ecm07').AsFloat      := 0;
//      FieldByName('ecm08').AsFloat      := 0;
//      FieldByName('ecm09').AsFloat      := 0;
//      FieldByName('ecm10').AsFloat      := 0;
//      FieldByName('ecm11').AsString     := FtmpCDS.FieldByName('ecb02').AsString; //CCL-01
//      FieldByName('ecm13').AsFloat      := FtmpCDS.FieldByName('ecb18').AsFloat;
//      FieldByName('ecm14').AsFloat      := FtmpCDS.FieldByName('ecb19').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
//      FieldByName('ecm15').AsFloat      := FtmpCDS.FieldByName('ecb20').AsFloat;
//      FieldByName('ecm16').AsFloat      := FtmpCDS.FieldByName('ecb21').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
//      FieldByName('ecm49').AsFloat      := FtmpCDS.FieldByName('ecb38').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
//      FieldByName('ecm45').AsString     := FtmpCDS.FieldByName('ecb17').AsString;
//      FieldByName('ecm52').AsString     := FtmpCDS.FieldByName('ecb39').AsString;
//      FieldByName('ecm53').AsString     := FtmpCDS.FieldByName('ecb40').AsString;
//      FieldByName('ecm54').AsString     := FtmpCDS.FieldByName('ecb41').AsString;
//      FieldByName('ecm55').AsString     := FtmpCDS.FieldByName('ecb42').AsString;
//      FieldByName('ecm56').AsString     := FtmpCDS.FieldByName('ecb43').AsString;
//      FieldByName('ecm291').AsFloat     := 0;
//      FieldByName('ecm292').AsFloat     := 0;
//      FieldByName('ecm301').AsFloat     := 0;     //第1站投入量大確認時計算
//      FieldByName('ecm302').AsFloat     := 0;
//      FieldByName('ecm303').AsFloat     := 0;
//      FieldByName('ecm311').AsFloat     := 0;
//      FieldByName('ecm312').AsFloat     := 0;
//      FieldByName('ecm313').AsFloat     := 0;
//      FieldByName('ecm314').AsFloat     := 0;
//      FieldByName('ecm315').AsFloat     := 0;
//      FieldByName('ecm316').AsFloat     := 0;
//      FieldByName('ecm321').AsFloat     := 0;
//      FieldByName('ecm322').AsFloat     := 0;
//      FieldByName('ecm57').AsString     := FtmpCDS.FieldByName('ecb44').AsString;
//      FieldByName('ecm58').AsString     := FtmpCDS.FieldByName('ecb45').AsString;
//      FieldByName('ecm59').AsString     := FtmpCDS.FieldByName('ecb46').AsString;
//      FieldByName('ecmacti').AsString   := 'Y';
//      FieldByName('ecmuser').AsString   := g_UInfo^.UserId;
//      FieldByName('ecmgrup').AsString   := FsfbCDS.FieldByName('sfbgrup').AsString;
//      FieldByName('ecmdate').AsDateTime := Date;
//      Post;
//      FtmpCDS.Next;
//    end;
//  end;
//
//  tmpecm57:=' ';
//  if FimaCDS.FieldByName('ima55').IsNull then
//     tmpima55:=' '
//  else
//     tmpima55:=Trim(FimaCDS.FieldByName('ima55').AsString);
//  if FecmCDS.Locate('ecm01;ecm03', VarArrayOf([tmpsfb01,tmpecm03]), []) then
//  begin
//    with FecmCDS do
//    begin
//      Edit;
//      FieldByName('ecm301').AsFloat := FsfbCDS.FieldByName('sfb08').AsFloat;
//      Post;
//      if not FieldByName('ecm57').IsNull then
//         tmpecm57:=Trim(FieldByName('ecm57').AsString);
//    end;
//  end else  //不存在制程資料
//  begin
//    FsfbCDS.Edit;
//    FsfbCDS.FieldByName('sfb24').AsString:= 'N';
//    FsfbCDS.Post;
//  end;

  {
  //各制程單元資料sgc_file->sgd_file暫不處理(sgc_file無數據)
  //處理製程完畢，應計算開工日，完工日(暫不處理)
  //更新tc_ksl_file(暫不處理)
  }

  //物料單位與製程單位不同，第1站投入量ecm301單位換算
//  if FecmCDS.Locate('ecm01;ecm03', VarArrayOf([tmpsfb01,tmpecm03]), []) and
//     (not SameText(tmpima55, tmpecm57)) then
//  begin
//    ShowSB('正在處理[製程單位換算]'+tmpCntMsg);
//    Data:=null;
//    tmpSQL:='Select smd04,smd06,''A'' tmpF FROM smd_file'
//           +' Where smd01='+Quotedstr(OrdWono.Pno)
//           +' And smd02='+Quotedstr(tmpima55)
//           +' And smd03='+QUotedstr(tmpecm57)
//           +' Union All'
//           +' Select smd06,smd04,''B'' tmpF FROM smd_file'
//           +' Where smd01='+Quotedstr(OrdWono.Pno)
//           +' And smd02='+QUotedstr(tmpecm57)
//           +' And smd03='+Quotedstr(tmpima55)
//           +' Union All'
//           +' Select smc03,smc04,''C'' tmpF FROM smc_file'
//           +' Where smc01='+QUotedstr(tmpima55)
//           +' And smc02='+QUotedstr(tmpecm57)
//           +' And smcacti=''Y'''
//           +' Order By tmpF';
//    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
//    begin
//      DeleteRec(tmpsfb01);
//      Exit;
//    end;
//
//    FtmpCDS.Data:=Data;
//    if not FtmpCDS.IsEmpty then
//    begin
//      if FtmpCDS.Fields[0].AsFloat=0 then  //用第1筆
//         tmpQty:=0
//      else
//         tmpQty:=FtmpCDS.Fields[1].AsFloat/FtmpCDS.Fields[0].AsFloat;
//
//      with FecmCDS do
//      begin
//        Edit;
//        FieldByName('ecm301').AsFloat:=FsfbCDS.FieldByName('sfb08').AsFloat*tmpQty;
//        Post;
//      end;
//    end;
//  end;

  //工單單身
  //Bom結構
  ShowSB('正在查詢[Bom結構]'+tmpCntMsg);
  Data:=null;
  tmpSQL:='Select A.*,ima08,ima37,ima25,ima55,ima86,ima86_fac,ima262,ima27,ima108,ima64,ima641'
         +' From (Select bmb02,bmb03,bmb04,bmb05,bmb10,bmb10_fac2,'
         +' case when nvl(bmb10_fac,0)=0 then 1 else bmb10_fac end bmb10_fac,'
         +' bmb15,nvl(bmb16,''0'') bmb16,bmb06,bmb08,nvl(bmb09,'' '') bmb09,'
         +' nvl(bmb18,0) bmb18,bmb19,bmb28,bmb07'
         +' From bmb_file Inner Join bma_file On bmb01=bma01'
         +' Where bma01='+Quotedstr(OrdWono.Pno)
         +' and bmaacti=''Y'') A Inner Join ima_file On bmb03=ima01'
         +' Where (bmb04 is null or bmb04<=to_date('+Quotedstr(DateToStr(Date))+',''YYYY/MM/DD''))'
         +' And (bmb05 is null or bmb05>to_date('+Quotedstr(DateToStr(Date))+',''YYYY/MM/DD''))'
         +' And ima08<>''D'' and imaacti=''Y'' Order By bmb02';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
  begin
    DeleteRec(tmpsfb01);
    Exit;
  end;

  FtmpCDS.Data:=Data;
  if FtmpCDS.IsEmpty then
  begin
    DeleteRec(tmpsfb01);
    ShowMsg(OrdWono.Pno+'Bom表不存在:請檢查是否已無效,或有效日期小於發放日期'+tmpCntMsg,48);
    Exit;
  end;

  ShowSB('正在添加[工單單身資料]'+tmpCntMsg);
  with FsfaCDS do
  begin


        Append;
        FieldByName('sfa01').AsString   := tmpsfb01;
        FieldByName('sfa02').AsInteger  := FsfbCDS.FieldByName('sfb02').AsInteger;
        FieldByName('sfa03').AsString   := OrdWono.Sfa03;
        FieldByName('sfa04').AsFloat   := OrdWono.sqty;    
        FieldByName('sfa05').AsFloat   := OrdWono.sqty;
        FieldByName('sfa06').AsFloat    := 0;
        FieldByName('sfa061').AsFloat   := 0;
        FieldByName('sfa062').AsFloat   := 0;
        FieldByName('sfa063').AsFloat   := 0;
        FieldByName('sfa064').AsFloat   := 0;
        FieldByName('sfa065').AsFloat   := 0;
        FieldByName('sfa066').AsFloat   := 0;
        FieldByName('sfa07').AsFloat    := 0;
        FieldByName('sfa08').AsString   := ' ';//FtmpCDS.FieldByName('bmb09').AsString;
        FieldByName('sfa09').AsInteger  := FtmpCDS.FieldByName('bmb18').AsInteger;
        FieldByName('sfa11').AsString   := 'N';  //sfb39='2'
        FieldByName('sfa12').AsString   := 'SH';
        FieldByName('sfa14').AsString   := 'SH';
        FieldByName('sfa15').AsFloat    := FtmpCDS.FieldByName('bmb10_fac2').AsFloat;
        FieldByName('sfa16').AsFloat    := 1;
        FieldByName('sfa161').AsFloat   := 1;
        FieldByName('sfa25').AsFloat    := OrdWono.Sqty;
        FieldByName('sfa26').AsString   := '1';//FtmpCDS.FieldByName('bmb16').AsString; //料號取代標誌暫不處理
        FieldByName('sfa27').AsString   := OrdWono.Sfa03;
        FieldByName('sfa28').AsFloat    := 1;
        FieldByName('sfa29').AsString   := OrdWono.Pno;
        //FieldByName('sfa31').AsString := bml04; //bml_file.bml04 指定廠商
        FieldByName('sfa100').AsFloat   := 0;
        FieldByName('sfaacti').AsString := 'Y';
      Post;

  end;

  OutWono:=tmpsfb01;
  Result:=True;
end;

end.