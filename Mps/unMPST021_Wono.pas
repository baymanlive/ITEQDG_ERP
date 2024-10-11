{*******************************************************}
{                                                       }
{                unMPST020_Wono                         }
{                Author: kaikai                         }
{                Create date: 2015/10/26                }
{                Description: 產生工單                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST021_Wono;

interface

uses
  Classes, SysUtils, DBClient, Forms, Variants, Math, StrUtils,
  unGlobal, unCommon;

type
  TOrderWono = Packed Record
    Machine,
    Orderno,
    Orderitem,
    Pno,
    Custno,
    Breadth,    //幅寬
    Fiber,      //玻布供應商
    Premark     : string;
    Sqty        : Double;
    IsDG        : Boolean;
    Adate       : TDateTime;
end;

type
  TMPST021_Wono = class
  private
    FsfaCDS:TClientDataSet;
    FsfbCDS:TClientDataSet;
    Fta_sfbCDS:TClientDataSet;
    FimaCDS:TClientDataSet;
    FecmCDS:TClientDataSet;
    FsmaCDS:TClientDataSet;
    Fmps620CDS:TClientDataSet;
    Fmps540CDS:TClientDataSet;
    FtmpCDS:TClientDataSet;
    function GetLine(Orderno, Machine, Pno:string):string;
    function GetDeptno(Machine, Pno: string): string;
    function GetWono_Fst(Machine, Custno, Premark: string): string;
    procedure ShowSB(msg: string);
    function GetBomStr(OrdWono:TOrderWono): string;
    procedure DeleteRec(wono:string);
    procedure Reset_ecm(OraDB:string);
    procedure Reset_sfb(OraDB:string);
    procedure Reset_ta_sfb(OraDB:string);
  public
    constructor Create;
    destructor Destroy; override;
    function Init(IsDG:Boolean):Boolean;
    function SetWono(OrdWono:TOrderWono; var OutWono:string):Boolean;
    function Post(IsDG:Boolean):Boolean;
  end;

implementation

{ TMPST020_Wono }

constructor TMPST021_Wono.Create;
var
  tmpOraDB,tmpSQL:string;
  Data:OleVariant;
begin
  tmpOraDB:='ORACLE';
  FsfaCDS:=TClientDataSet.Create(nil);
  FsfbCDS:=TClientDataSet.Create(nil);
  Fta_sfbCDS:=TClientDataSet.Create(nil);
  FimaCDS:=TClientDataSet.Create(nil);
  FecmCDS:=TClientDataSet.Create(nil);
  FsmaCDS:=TClientDataSet.Create(nil);
  Fmps620CDS:=TClientDataSet.Create(nil);
  Fmps540CDS:=TClientDataSet.Create(nil);
  FtmpCDS:=TClientDataSet.Create(nil);

  FsfaCDS.DisableStringTrim:=True;
  FsfbCDS.DisableStringTrim:=True;
  Fta_sfbCDS.DisableStringTrim:=True;
  FimaCDS.DisableStringTrim:=True;
  FecmCDS.DisableStringTrim:=True;
  FsmaCDS.DisableStringTrim:=True;
  Fmps620CDS.DisableStringTrim:=True;
  Fmps540CDS.DisableStringTrim:=True;
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

  ShowSB('正在查詢[工單制程追蹤]');
  Data:=null;
  tmpSQL:='Select * From ecm_file Where 1=2';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Abort;
  FecmCDS.Data:=Data;

  //Bom虛擬料號
  ShowSB('正在查詢[Bom玻布使用資料]');
  Data:=null;
  tmpSQL:='Select Bu,Fiber,''/''+Breadth+''/'' Breadth,Vendor,Code,Code2 From MPS620';
  if not QueryBySQL(tmpSQL, Data) then
     Abort;
  Fmps620CDS.Data:=Data;

  //料號與布種關系
  ShowSB('正在查詢[料號與布種關系]');
  Data:=null;
  tmpSQL:='Select Code4_5,Fiber From MPS540 Where Bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data) then
     Abort;
  Fmps540CDS.Data:=Data;
end;

destructor TMPST021_Wono.Destroy;
begin
  FsfaCDS.Free;
  FsfbCDS.Free;
  Fta_sfbCDS.Free;
  FimaCDS.Free;
  FecmCDS.Free;
  FsmaCDS.Free;
  Fmps620CDS.Free;
  Fmps540CDS.Free;
  FtmpCDS.Free;

  inherited;
end;

procedure TMPST021_Wono.ShowSB(msg:string);
begin
  g_StatusBar.Panels[0].Text:=msg;
  Application.ProcessMessages;
end;

//取單頭
function TMPST021_Wono.GetWono_Fst(Machine, Custno, Premark: string): string;
const dgMachine='T1,T2,T3,T4,T5';
begin
  Result:='';

  if (Machine='T9') or (Machine='T10') then
  begin
    Result:='51W-'+GetYM;
    Exit;
  end;

  //ACA90技服、AC485研發
  if Pos(Machine, dgMachine)>0 then
  begin
    if SameText(Custno, 'ACA90') or (Pos(CheckLang('樣品'), Premark)>0) then
       Result:='R14'
    else if SameText(Custno, 'AC485') or
           (Pos(CheckLang('試制'), Premark)>0) or
           (Pos(CheckLang('試製'),Premark)>0) then
      Result:='R13'
    else
      Result:='513';
  end else
  begin
    if Pos(CheckLang('樣品'), Premark)>0 then
       Result:='R14'
    else if (Pos(CheckLang('試制'), Premark)>0) or
            (Pos(CheckLang('試製'),Premark)>0) then
       Result:='R13'
    else
       Result:='513';
  end;

  if Length(Result)>0 then
     Result:=Result+'-'+GetYM;
end;

//取線別
function TMPST021_Wono.GetLine(Orderno, Machine, Pno: string): string;
const tmpS1='T1,T2,T3,T4,T5,T6,T7,T8';
const tmpS2='A*,B*,C*,D*,E*,A*,B*,C*';   //*多余,截取字符串用
const tmpS3='1*,2*,3*,4*,5*,1*,2*,3*';
var
  pos1:Integer;
begin
  pos1:=Pos(Machine, tmpS1);
  if pos1>0 then
  begin
    if Length(Pno)<18 then  //自用
    begin
      if LeftStr(Pno,1)='Q' then
         Result:=Copy(tmpS3, pos1, 1)
      else
         Result:=Copy(tmpS2, pos1, 1);
    end else
    begin
      if Pos(LeftStr(Orderno,3), '222/223/227/22G/228/P1Z/P2Z')>0 then  //內銷
         Result:=Copy(tmpS3, pos1, 1)
      else
         Result:=Copy(tmpS2, pos1, 1);
    end;
  end else
    Result:='';
end;

//取成本中心
function TMPST021_Wono.GetDeptno(Machine, Pno: string): string;
var
  len:Integer;
begin
  if (Machine='T9') or (Machine='T10') then
  begin
    Result:='1D1128';
    Exit;
  end;

  len:=Length(Pno);
  if Pos(Machine, 'T1/T2/T3/T4/T5')>0 then
  begin
    if len=18 then
       Result:='1D1128'
    else
       Result:='1D1126';
  end else
  begin
    if len=18 then
       Result:='4G1123'
    else
       Result:='4G1122';
  end;
end;

//替換虛擬料號
function TMPST021_Wono.GetBomStr(OrdWono:TOrderWono):string;
var
  tmpStr,Fiber:string;
begin
  Result:='';

  if Length(OrdWono.Pno)=18 then
     Fiber:=Copy(OrdWono.Pno,4,4)
  else begin
     if Fmps540CDS.Locate('Code4_5',Copy(OrdWono.Pno,4,2),[]) then
        Fiber:=Fmps540CDS.FieldByName('Fiber').AsString
     else
        Exit;
  end;

  try
    tmpStr:=FloatToStr(StrToFloat(OrdWono.Breadth));
  except
    Exit;
  end;

  with Fmps620CDS do
  begin
    Filtered:=False;
    if Pos(','+OrdWono.Machine+',', ',T1,T2,T3,T4,T5,T9,T10,')>0 then
       Filter:='Bu=''ITEQDG'' and Fiber='+Quotedstr(Fiber)
              +' and Vendor='+Quotedstr(OrdWono.Fiber)
    else
       Filter:='Bu=''ITEQGZ'' and Fiber='+Quotedstr(Fiber)
              +' and Vendor='+Quotedstr(OrdWono.Fiber);
    Filtered:=True;
    First;
    while not Eof do
    begin
      if Pos('/'+tmpStr+'/', FieldByName('Breadth').AsString)>0 then
      begin
        if Length(OrdWono.Pno)=18 then
        begin
          if Pos(Copy(OrdWono.Pno,3,1),'3,8,D')>0 then
             Result:=FieldByName('Code2').AsString
          else
             Result:=FieldByName('Code').AsString;
        end else
        begin
          if Pos(Copy(OrdWono.Pno,11,2),'6X,6T,3T,3X')>0 then
             Result:=FieldByName('Code2').AsString
          else
             Result:=FieldByName('Code').AsString;
        end;

        Break;
      end;
      Next;
    end;
  end;
end;

//判斷sma_file參數及初始化
function TMPST021_Wono.Init(IsDG:Boolean): Boolean;
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

  try
    FsfbCDS.EmptyDataSet;
    FsfbCDS.MergeChangeLog;

    Fta_sfbCDS.EmptyDataSet;
    Fta_sfbCDS.MergeChangeLog;

    FecmCDS.EmptyDataSet;
    FecmCDS.MergeChangeLog;

    FsfaCDS.EmptyDataSet;
    FsfaCDS.MergeChangeLog;
    
    Result:=True;
  except
    ShowMsg('初始化CDS失敗,請聯系管理員!',48);
  end;
end;

//刪除sfb
procedure TMPST021_Wono.Reset_sfb(OraDB:string);
begin
  while not FsfbCDS.IsEmpty do
    FsfbCDS.Delete;
  CDSPost(FsfbCDS, 'sfb_file', OraDB);
end;

//刪除ta_sfb
procedure TMPST021_Wono.Reset_ta_sfb(OraDB:string);
begin
  while not Fta_sfbCDS.IsEmpty do
    Fta_sfbCDS.Delete;
  CDSPost(Fta_sfbCDS, 'ta_sfb_file', OraDB);
end;

//刪除ecm
procedure TMPST021_Wono.Reset_ecm(OraDB:string);
begin
  while not FecmCDS.IsEmpty do
    FecmCDS.Delete;
  CDSPost(FecmCDS, 'ecm_file', OraDB);
end;

//提交
function TMPST021_Wono.Post(IsDG:Boolean): Boolean;
var
  tmpOraDB:string;
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

  if not CDSPost(FecmCDS, 'ecm_file', tmpOraDB) then
  begin
    Reset_sfb(tmpOraDB);
    Reset_ta_sfb(tmpOraDB);
    Exit;
  end;

  if not CDSPost(FsfaCDS, 'sfa_file', tmpOraDB) then
  begin
    Reset_sfb(tmpOraDB);
    Reset_ta_sfb(tmpOraDB);
    Reset_ecm(tmpOraDB);
    Exit;
  end;

  Result:=True;
end;

//異常刪除
procedure TMPST021_Wono.DeleteRec(wono:string);
begin
  while FsfbCDS.Locate('sfb01', wono, []) do
    FsfbCDS.Delete;

  while Fta_sfbCDS.Locate('ta_sfb01', wono, []) do
    Fta_sfbCDS.Delete;

  while FecmCDS.Locate('ecm01', wono, []) do
    FecmCDS.Delete;

  while FsfaCDS.Locate('sfa01', wono, []) do
    FsfaCDS.Delete;
end;

//產生工單號碼
function TMPST021_Wono.SetWono(OrdWono:TOrderWono; var OutWono:string):Boolean;
var
  tmpOraDB,tmpSQL,tmpsfb01,tmpecm57,tmpima55,tmpima571,tmpCntMsg,tmpBomId,tmpMaxsfb01:string;
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

  tmpBomId:=GetBomStr(OrdWono);
  if Length(tmpBomId)=0 then
  begin
    ShowMsg('找不到虛擬替代料號,請檢查設定MPSI620,'+tmpCntMsg,48);
    Exit;
  end;

  ShowSB('正在計算[工單單別]'+tmpCntMsg);
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
    tmpSQL := 'Select nvl(max(sfb01),'''') as sfb01 From sfb_file'
             +' Where sfb01 like ''' + tmpsfb01 + '%''';
    if not QueryOneCR( tmpSQL, Data, tmpOraDB) then
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

  ShowSB('正在添加[工單單頭資料]'+tmpCntMsg);
  with FsfbCDS do
  begin
    Append;
    FieldByName('sfb01').AsString    := tmpsfb01;
    FieldByName('sfb02').AsInteger   := 1;             //工單型態1:一般工單
    FieldByName('sfb04').AsString    := '2';           //工單狀態2:工單已發放
    FieldByName('sfb05').AsString    := OrdWono.Pno;
    if OrdWono.Adate<>0 then
      FieldByName('ta_sfb15').AsDateTime    := OrdWono.Adate;
    if SameText(FsmaCDS.FieldByName('sma119').AsString,'W') then
       FieldByName('sfb06').AsString :='001'
    else
       FieldByName('sfb06').AsString := FimaCDS.FieldByName('ima94').AsString;
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
    if Length(OrdWono.Pno)=18 then
    begin
      FieldByName('sfb22').AsString      := OrdWono.Orderno;
      FieldByName('sfb221').AsInteger    := StrToInt(OrdWono.Orderitem);
    end;
    FieldByName('sfb23').AsString        := 'Y';
    FieldByName('sfb24').AsString        := 'Y';
    FieldByName('sfb29').AsString        := 'Y';
    FieldByName('sfb39').AsString        := '2';          //完工方式
    FieldByName('sfb41').AsString        := 'N';
    FieldByName('sfb81').AsDateTime      := Date;         //開工單日期
    FieldByName('sfb82').AsString        := GetDeptno(OrdWono.Machine, OrdWono.Pno);   //部門
    FieldByName('sfb87').AsString        := 'Y';          //確認
    FieldByName('sfb93').AsString        := 'Y';
    FieldByName('sfb94').AsString        := 'N';
    FieldByName('sfb95').AsString        := tmpsfb01;     //定制單號
    FieldByName('sfb98').AsString        := FieldByName('sfb82').AsString;             //承接部門,成本中心
    FieldByName('sfb99').AsString        := 'N';
    FieldByName('sfb100').AsString       := '1';
    FieldByName('sfbacti').AsString      := 'Y';
    FieldByName('sfbuser').AsString      := g_UInfo^.UserId;
    FieldByName('sfbgrup').AsString      := '0D9261';
    FieldByName('sfbdate').AsDateTime    := Date;
    FieldByName('ta_sfb01').AsString     := '00:00';
    if OrdWono.Machine='T9' then
       FieldByName('ta_sfb02').AsString  :='9'
    else if OrdWono.Machine='T10' then
       FieldByName('ta_sfb02').AsString  :='0'
    else
       FieldByName('ta_sfb02').AsString  := GetLine(FieldByName('sfb22').AsString, OrdWono.Machine, OrdWono.Pno); //生產線別
    FieldByName('ta_sfb03').AsString     := 'A';
    FieldByName('ta_sfb11').AsString     := FimaCDS.FieldByName('ima15').AsString; //保稅
    FieldByName('ta_sfb13').AsString     := '0';                                   //0一般、1覆捲、2換批號
    Post;
  end;

  tmpSQL:=Copy(tmpsfb01,1,3);
  ShowSB('正在添加[工單擴展資料]'+tmpCntMsg);
  with Fta_sfbCDS do
  begin
    Append;
    FieldByName('ta_sfb01').AsString := tmpsfb01;
    if tmpSQL='R13' then
    begin
      FieldByName('ta_sfb04').AsString := '3';
      FieldByName('ta_sfb05').AsString := 'Q8AT0';
    end else
    if tmpSQL='R14' then
       FieldByName('ta_sfb04').AsString := '1'
    else
       FieldByName('ta_sfb04').AsString := '0';
    FieldByName('ta_sfb07').AsString := 'X';
    FieldByName('ta_sfb08').AsString := 'X';
    //FieldByName('ta_sfb09').AsString := ''; //2up尺寸 tc_ksd46?
    FieldByName('ta_sfb10').AsString := '1';
    Post;
  end;

  ShowSB('正在查詢[工單製程料號]'+tmpCntMsg);
  tmpima571:=FimaCDS.FieldByName('ima571').AsString;
  if Length(tmpima571)=0 then
     tmpima571:=' ';
  Data:=null;
  tmpSQL:=' Select ecu01,''A'' tmpF From ecu_file Where ecu01='+Quotedstr(tmpima571)
         +' And ecu02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
         +' Union'
         +' Select ecu01,''B'' tmpF From ecu_file Where ecu01='+Quotedstr(OrdWono.Pno)
         +' And ecu02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
         +' Order By tmpF';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
  begin
    DeleteRec(tmpsfb01);
    Exit;
  end;

  FtmpCDS.Data:=Data;
  if FtmpCDS.IsEmpty then
  begin
    DeleteRec(tmpsfb01);
    ShowMsg('製程料號不存在'+tmpCntMsg+#13#10+tmpima571+#13#10+OrdWono.Pno, 48);
    Exit;
  end;

  ShowSB('正在查詢[工單製程資料]'+tmpCntMsg);
  Data:=null;
  tmpSQL:=FtmpCDS.Fields[0].AsString;
  tmpSQL:='Select * From ecb_file Where ecb01='+Quotedstr(tmpSQL)
         +' And ecb02='+Quotedstr(FsfbCDS.FieldByName('sfb06').AsString)
         +' And ecbacti=''Y'' Order By ecb03';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
  begin
    DeleteRec(tmpsfb01);
    Exit;
  end;

  FtmpCDS.Data:=Data;
  if FtmpCDS.IsEmpty then
  begin
    DeleteRec(tmpsfb01);
    ShowMsg('製程資料不存在'+tmpCntMsg, 48);
    Exit;
  end;

  ShowSB('正在添加[工單製程資料]'+tmpCntMsg);
  tmpecm03:=-15698;
  with FecmCDS do
  begin
    while not FtmpCDS.Eof do
    begin
      if tmpecm03=-15698 then  //tmpecm03保存第1筆
         tmpecm03:=FtmpCDS.FieldByName('ecb03').AsInteger;
      Append;
      FieldByName('ecm01').AsString     := tmpsfb01;
      FieldByName('ecm02').AsString     := FsfbCDS.FieldByName('sfb02').AsString;
      FieldByName('ecm03_par').AsString := OrdWono.Pno;
      FieldByName('ecm03').AsInteger    := FtmpCDS.FieldByName('ecb03').AsInteger;
      FieldByName('ecm04').AsString     := FtmpCDS.FieldByName('ecb06').AsString;
      FieldByName('ecm05').AsString     := FtmpCDS.FieldByName('ecb07').AsString;
      FieldByName('ecm06').AsString     := FtmpCDS.FieldByName('ecb08').AsString;
      FieldByName('ecm07').AsFloat      := 0;
      FieldByName('ecm08').AsFloat      := 0;
      FieldByName('ecm09').AsFloat      := 0;
      FieldByName('ecm10').AsFloat      := 0;
      FieldByName('ecm11').AsString     := FtmpCDS.FieldByName('ecb02').AsString; 
      FieldByName('ecm13').AsFloat      := FtmpCDS.FieldByName('ecb18').AsFloat;
      FieldByName('ecm14').AsFloat      := FtmpCDS.FieldByName('ecb19').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
      FieldByName('ecm15').AsFloat      := FtmpCDS.FieldByName('ecb20').AsFloat;
      FieldByName('ecm16').AsFloat      := FtmpCDS.FieldByName('ecb21').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
      FieldByName('ecm49').AsFloat      := FtmpCDS.FieldByName('ecb38').AsFloat*FsfbCDS.FieldByName('sfb08').AsFloat;
      FieldByName('ecm45').AsString     := FtmpCDS.FieldByName('ecb17').AsString;
      FieldByName('ecm52').AsString     := FtmpCDS.FieldByName('ecb39').AsString;
      FieldByName('ecm53').AsString     := FtmpCDS.FieldByName('ecb40').AsString;
      FieldByName('ecm54').AsString     := FtmpCDS.FieldByName('ecb41').AsString;
      FieldByName('ecm55').AsString     := FtmpCDS.FieldByName('ecb42').AsString;
      FieldByName('ecm56').AsString     := FtmpCDS.FieldByName('ecb43').AsString;
      FieldByName('ecm291').AsFloat     := 0;
      FieldByName('ecm292').AsFloat     := 0;
      FieldByName('ecm301').AsFloat     := 0;     //第1站投入量大確認時計算
      FieldByName('ecm302').AsFloat     := 0;
      FieldByName('ecm303').AsFloat     := 0;
      FieldByName('ecm311').AsFloat     := 0;
      FieldByName('ecm312').AsFloat     := 0;
      FieldByName('ecm313').AsFloat     := 0;
      FieldByName('ecm314').AsFloat     := 0;
      FieldByName('ecm315').AsFloat     := 0;
      FieldByName('ecm316').AsFloat     := 0;
      FieldByName('ecm321').AsFloat     := 0;
      FieldByName('ecm322').AsFloat     := 0;
      FieldByName('ecm57').AsString     := FtmpCDS.FieldByName('ecb44').AsString;
      FieldByName('ecm58').AsString     := FtmpCDS.FieldByName('ecb45').AsString;
      FieldByName('ecm59').AsString     := FtmpCDS.FieldByName('ecb46').AsString;
      FieldByName('ecmacti').AsString   := 'Y';
      FieldByName('ecmuser').AsString   := g_UInfo^.UserId;
      FieldByName('ecmgrup').AsString   := FsfbCDS.FieldByName('sfbgrup').AsString;
      FieldByName('ecmdate').AsDateTime := Date;
      Post;
      FtmpCDS.Next;
    end;
  end;

  tmpecm57:=' ';
  if FimaCDS.FieldByName('ima55').IsNull then
     tmpima55:=' '
  else
     tmpima55:=Trim(FimaCDS.FieldByName('ima55').AsString);
  if FecmCDS.Locate('ecm01;ecm03', VarArrayOf([tmpsfb01,tmpecm03]), []) then
  begin
    with FecmCDS do
    begin
      Edit;
      FieldByName('ecm301').AsFloat := FsfbCDS.FieldByName('sfb08').AsFloat;
      Post;
      if not FieldByName('ecm57').IsNull then
         tmpecm57:=Trim(FieldByName('ecm57').AsString);
    end;
  end else  //不存在制程資料
  begin
    FsfbCDS.Edit;
    FsfbCDS.FieldByName('sfb24').AsString:= 'N';
    FsfbCDS.Post;
  end;
  
  {
  //各制程單元資料sgc_file->sgd_file暫不處理(sgc_file無數據)
  //處理製程完畢，應計算開工日，完工日(暫不處理)
  //更新tc_ksl_file(暫不處理)
  }

  //物料單位與製程單位不同，第1站投入量ecm301單位換算
  if FecmCDS.Locate('ecm01;ecm03', VarArrayOf([tmpsfb01,tmpecm03]), []) and
     (not SameText(tmpima55, tmpecm57)) then
  begin
    ShowSB('正在處理[製程單位換算]'+tmpCntMsg);
    Data:=null;
    tmpSQL:='Select smd04,smd06,''A'' tmpF FROM smd_file'
           +' Where smd01='+Quotedstr(OrdWono.Pno)
           +' And smd02='+Quotedstr(tmpima55)
           +' And smd03='+QUotedstr(tmpecm57)
           +' Union All'
           +' Select smd06,smd04,''B'' tmpF FROM smd_file'
           +' Where smd01='+Quotedstr(OrdWono.Pno)
           +' And smd02='+QUotedstr(tmpecm57)
           +' And smd03='+Quotedstr(tmpima55)
           +' Union All'
           +' Select smc03,smc04,''C'' tmpF FROM smc_file'
           +' Where smc01='+QUotedstr(tmpima55)
           +' And smc02='+QUotedstr(tmpecm57)
           +' And smcacti=''Y'''
           +' Order By tmpF';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
    begin
      DeleteRec(tmpsfb01);
      Exit;
    end;

    FtmpCDS.Data:=Data;
    if not FtmpCDS.IsEmpty then
    begin
      if FtmpCDS.Fields[0].AsFloat=0 then  //用第1筆
         tmpQty:=0
      else
         tmpQty:=FtmpCDS.Fields[1].AsFloat/FtmpCDS.Fields[0].AsFloat;

      with FecmCDS do
      begin
        Edit;
        FieldByName('ecm301').AsFloat:=FsfbCDS.FieldByName('sfb08').AsFloat*tmpQty;
        Post;
      end;
    end;
  end;

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
    while not FtmpCDS.Eof do
    begin
      if FtmpCDS.FieldByName('bmb06').AsFloat<=0 then
      begin
        DeleteRec(tmpsfb01);
        ShowMsg('Bom表['+FtmpCDS.FieldByName('bmb03').AsString+']組成用量<=0,'+tmpCntMsg,48);
        Exit;
      end;
          
      if LeftStr(FtmpCDS.FieldByName('bmb03').AsString, 1)='1' then
         tmpSQL:=tmpBomId
      else
         tmpSQL:=FtmpCDS.FieldByName('bmb03').AsString;

      if not Locate('sfa01;sfa03', VarArrayOf([tmpsfb01,tmpSQL]),[]) then
      begin
        Append;
        FieldByName('sfa01').AsString   := tmpsfb01;
        FieldByName('sfa02').AsInteger  := FsfbCDS.FieldByName('sfb02').AsInteger;
        FieldByName('sfa03').AsString   := tmpSQL;
        FieldByName('sfa06').AsFloat    := 0;
        FieldByName('sfa061').AsFloat   := 0;
        FieldByName('sfa062').AsFloat   := 0;
        FieldByName('sfa063').AsFloat   := 0;
        FieldByName('sfa064').AsFloat   := 0;
        FieldByName('sfa065').AsFloat   := 0;
        FieldByName('sfa066').AsFloat   := 0;
        FieldByName('sfa07').AsFloat    := 0;
        FieldByName('sfa08').AsString   := FtmpCDS.FieldByName('bmb09').AsString;
        FieldByName('sfa09').AsInteger  := FtmpCDS.FieldByName('bmb18').AsInteger;
        FieldByName('sfa11').AsString   := 'E';  //sfb39='2'
        FieldByName('sfa14').AsString   := FtmpCDS.FieldByName('ima86').AsString;
        FieldByName('sfa15').AsFloat    := FtmpCDS.FieldByName('bmb10_fac2').AsFloat;
        FieldByName('sfa26').AsString   := FtmpCDS.FieldByName('bmb16').AsString; //料號取代標誌暫不處理
        FieldByName('sfa27').AsString   := FtmpCDS.FieldByName('bmb03').AsString;
        FieldByName('sfa28').AsFloat    := 1;
        FieldByName('sfa29').AsString   := OrdWono.Pno;
        //FieldByName('sfa31').AsString := bml04; //bml_file.bml04 指定廠商
        FieldByName('sfa100').AsFloat   := 0;
        FieldByName('sfaacti').AsString := 'Y';
      end else
        Edit;
      {
      //組成量bmb06*排制量sfb08*損耗率bmb08/底數bmb07
      if FsmaCDS.FieldByName('sma71').AsString='N' then   //bmb08=0
         tmpQty:=RoundTo(FtmpCDS.FieldByName('bmb06').AsFloat*
                         FsfbCDS.FieldByName('sfb08').AsFloat/
                         FtmpCDS.FieldByName('bmb07').AsFloat,-3)
      else
         tmpQty:=RoundTo(FtmpCDS.FieldByName('bmb06').AsFloat*
                         FsfbCDS.FieldByName('sfb08').AsFloat*
                      (1+FtmpCDS.FieldByName('bmb08').AsFloat/100)/
                         FtmpCDS.FieldByName('bmb07').AsFloat,-3);
      }
      //膠水不計算損耗率20181210
      if LeftStr(FieldByName('sfa27').AsString,1)='1' then
         tmpQty:=RoundTo(FtmpCDS.FieldByName('bmb06').AsFloat*
                         FsfbCDS.FieldByName('sfb08').AsFloat*
                      (1+FtmpCDS.FieldByName('bmb08').AsFloat/100)/
                         FtmpCDS.FieldByName('bmb07').AsFloat,-3)
      else
         tmpQty:=RoundTo(FtmpCDS.FieldByName('bmb06').AsFloat*
                         FsfbCDS.FieldByName('sfb08').AsFloat/
                         FtmpCDS.FieldByName('bmb07').AsFloat,-3);
      if FsmaCDS.FieldByName('sma78').AsString='1' then //庫存單位
      begin
        tmpQty:=tmpQty*FtmpCDS.FieldByName('bmb10_fac').AsFloat;
        FieldByName('sfa12').AsString := FtmpCDS.FieldByName('ima25').AsString;
        FieldByName('sfa13').AsFloat  := 1;
      end else
      begin
        FieldByName('sfa12').AsString := FtmpCDS.FieldByName('bmb10').AsString;
        FieldByName('sfa13').AsFloat  := FtmpCDS.FieldByName('bmb10_fac').AsFloat;
      end;
      FieldByName('sfa04').AsFloat    := FieldByName('sfa04').AsFloat+tmpQty;

      tmpQty:=FieldByName('sfa04').AsFloat;
      if (FtmpCDS.FieldByName('ima641').AsFloat<>0) and
         (tmpQty<FtmpCDS.FieldByName('ima641').AsFloat) THEN
         tmpQty:=FtmpCDS.FieldByName('ima641').AsFloat;
      if FtmpCDS.FieldByName('ima64').AsFloat<>0 then
         tmpQty:=tmpQty*FtmpCDS.FieldByName('ima64').AsFloat;
                 
      if LeftStr(FieldByName('sfa27').AsString,1)='1' then
         FieldByName('sfa05').AsFloat    := Trunc(tmpQty)
      else
         FieldByName('sfa05').AsFloat    := RoundTo(tmpQty,-3); //膠水保留小數
      
      tmpQty:=RoundTo(FtmpCDS.FieldByName('bmb06').AsFloat/FtmpCDS.FieldByName('bmb07').AsFloat,-5);
      FieldByName('sfa16').AsFloat    := FieldByName('sfa16').AsFloat+tmpQty;

      tmpQty:=RoundTo(FieldByName('sfa05').AsFloat/FsfbCDS.FieldByName('sfb08').AsFloat,-5);
      FieldByName('sfa161').AsFloat   := tmpQty;

      tmpQty:=FieldByName('sfa05').AsFloat;
      if FtmpCDS.FieldByName('ima262').AsFloat>0 then
         tmpQty:=tmpQty-FtmpCDS.FieldByName('ima262').AsFloat;
      if tmpQty<0 then
         tmpQty:=0;
      FieldByName('sfa25').AsFloat    := tmpQty;
      Post;
      FtmpCDS.Next;
    end;
  end;

  OutWono:=tmpsfb01;
  Result:=True;
end;

end.
