{*******************************************************}
{                                                       }
{                unMPST130_Wono                         }
{                Author: kaikai                         }
{                Create date: 2020/10/27                }
{                Description: 產生工單                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST130_Wono;

interface

uses
  Classes, SysUtils, DBClient, Forms, Variants, Math, StrUtils,
  unGlobal, unCommon;

type
  TOrderWono = Packed Record
    Orderno,
    Orderitem,
    FstCode,
    Pno,
    L_pno,
    ta_oeb03    : string;
    Qty,
    L_qty,
    ta_oeb01    : Double;
    tc_ocm03    : Integer;
    IsDG        : Boolean;
    Adate       : TDateTime;
end;

type
  TMPST130_Wono = class
  private
    FsfaCDS:TClientDataSet;
    FsfbCDS:TClientDataSet;
    Fta_sfbCDS:TClientDataSet;
    FimaCDS:TClientDataSet;
    procedure ShowSB(msg: string);
    procedure Reset_sfb(OrcDB:string);
    procedure Reset_ta_sfb(OrcDB:string);
  public
    constructor Create;
    destructor Destroy; override;
    function Init(IsDG:Boolean):Boolean;
    function SetWono(OrdWono:TOrderWono; var OutWono:string):Boolean;
    function Post(IsDG:Boolean):Boolean;
  end;

implementation

{ TMPST130_Wono }

constructor TMPST130_Wono.Create;
var
  tmpOraDB,tmpSQL:string;
  Data:OleVariant;
begin
  tmpOraDB:='ORACLE';
  FsfaCDS:=TClientDataSet.Create(nil);
  FsfbCDS:=TClientDataSet.Create(nil);
  Fta_sfbCDS:=TClientDataSet.Create(nil);
  FimaCDS:=TClientDataSet.Create(nil);

  FsfaCDS.DisableStringTrim:=True;
  FsfbCDS.DisableStringTrim:=True;
  Fta_sfbCDS.DisableStringTrim:=True;
  FimaCDS.DisableStringTrim:=True;

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
end;

destructor TMPST130_Wono.Destroy;
begin
  FreeAndNil(FsfaCDS);
  FreeAndNil(FsfbCDS);
  FreeAndNil(Fta_sfbCDS);
  FreeAndNil(FimaCDS);

  inherited;
end;

procedure TMPST130_Wono.ShowSB(msg:string);
begin
  g_StatusBar.Panels[0].Text:=msg;
  Application.ProcessMessages;
end;

//初始化
function TMPST130_Wono.Init(IsDG:Boolean): Boolean;
begin
  FsfbCDS.EmptyDataSet;
  FsfbCDS.MergeChangeLog;

  Fta_sfbCDS.EmptyDataSet;
  Fta_sfbCDS.MergeChangeLog;

  FsfaCDS.EmptyDataSet;
  FsfaCDS.MergeChangeLog;

  Result:=True;
end;

//刪除sfb
procedure TMPST130_Wono.Reset_sfb(OrcDB:string);
begin
  while not FsfbCDS.IsEmpty do
    FsfbCDS.Delete;
  CDSPost(FsfbCDS, 'sfb_file', OrcDB);
end;

//刪除ta_sfb
procedure TMPST130_Wono.Reset_ta_sfb(OrcDB:string);
begin
  while not Fta_sfbCDS.IsEmpty do
    Fta_sfbCDS.Delete;
  CDSPost(Fta_sfbCDS, 'ta_sfb_file', OrcDB);
end;

//提交
function TMPST130_Wono.Post(IsDG:Boolean): Boolean;
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

  if not CDSPost(FsfaCDS, 'sfa_file', tmpOraDB) then
  begin
    Reset_sfb(tmpOraDB);
    Reset_ta_sfb(tmpOraDB);
    Exit;
  end;

  Result:=True;
end;

//產生工單號碼
function TMPST130_Wono.SetWono(OrdWono:TOrderWono; var OutWono:string):Boolean;
var
  tmpOraDB,tmpSQL,tmpsfb01,tmpCntMsg,tmpMaxsfb01:string;
  Data:OleVariant;
begin
  Result:=False;
  tmpCntMsg:=OutWono;
  OutWono:='';

  if OrdWono.tc_ocm03<=0 then
  begin
    ShowMsg('裁剪方式錯誤'+tmpCntMsg,48);
    Exit;
  end;

  if OrdWono.IsDG then
     tmpOraDB:='ORACLE'    //iteqdg
  else
     tmpOraDB:='ORACLE1';  //iteqgz

  ShowSB('正在計算[工單單別]'+tmpCntMsg);
  if Pos(OrdWono.FstCode,'EN')>0 then
     tmpsfb01:='514-'+GetYM
  else if Pos(OrdWono.FstCode,'TM')>0 then
     tmpsfb01:='51B-'+GetYM
  else
     tmpsfb01:='';
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
  tmpSQL:='Select ima01,ima15,ima25,ima70 From ima_file'
         +' Where imaacti=''Y'' and (ima01='+Quotedstr(OrdWono.L_pno)
         +' or ima01='+Quotedstr(OrdWono.Pno)+')';
  if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
     Exit;

  FimaCDS.Data:=Data;
  if not FimaCDS.Locate('ima01',OrdWono.L_pno,[]) then
  begin
    ShowMsg(OrdWono.L_pno+'物料基本資料不存在,請檢查是否已無效'+tmpCntMsg, 48);
    Exit;
  end;

  if not FimaCDS.Locate('ima01',OrdWono.Pno,[]) then
  begin
    ShowMsg(OrdWono.Pno+'物料基本資料不存在,請檢查是否已無效'+tmpCntMsg, 48);
    Exit;
  end;

  ShowSB('正在添加[工單單頭資料]'+tmpCntMsg);
  FimaCDS.Locate('ima01',OrdWono.Pno,[]);
  with FsfbCDS do
  begin
    Append;                                              
    FieldByName('sfb01').AsString    := tmpsfb01;
    FieldByName('sfb02').AsInteger   := 5;             //工單型態5:再加工工單
    FieldByName('sfb04').AsString    := '2';           //工單狀態2:工單已發放
    FieldByName('sfb05').AsString    := OrdWono.Pno;
    if OrdWono.Adate<>0 then
      FieldByName('ta_sfb15').AsDateTime    := OrdWono.Adate;
    FieldByName('sfb071').AsDateTime := Date;          //產品結構指定有效日期
    FieldByName('sfb08').AsFloat     := OrdWono.Qty;   //重工數量
    FieldByName('sfb081').AsFloat    := 0;
    FieldByName('sfb09').AsFloat     := 0;
    FieldByName('sfb10').AsFloat     := 0;
    FieldByName('sfb11').AsFloat     := 0;
    FieldByName('sfb111').AsFloat    := 0;
    FieldByName('sfb12').AsFloat     := 0;
    FieldByName('sfb121').AsFloat    := 0;
    FieldByName('sfb13').AsDateTime  := IncMonth(Date,3);                 //開工日期
    FieldByName('sfb15').AsDateTime  := FieldByName('sfb13').AsDateTime;  //完工日期
    FieldByName('sfb21').AsString    := 'N';
    FieldByName('sfb22').AsString    := OrdWono.Orderno;
    FieldByName('sfb221').AsInteger  := StrToInt(OrdWono.Orderitem);
    FieldByName('sfb23').AsString    := 'Y';
    FieldByName('sfb24').AsString    := 'N';
    FieldByName('sfb29').AsString    := 'Y';
    FieldByName('sfb39').AsString    := '1';      //完工方式
    FieldByName('sfb41').AsString    := 'N';
    FieldByName('sfb81').AsDateTime  := Date;     //開工單日期
    FieldByName('sfb87').AsString    := 'Y';      //確認
    FieldByName('sfb93').AsString    := 'N';
    FieldByName('sfb94').AsString    := 'N';
    FieldByName('sfb95').AsString    := tmpsfb01; //定制單號
    FieldByName('sfb99').AsString    := 'Y';
    FieldByName('sfb100').AsString   := '1';
    FieldByName('sfbacti').AsString  := 'Y';
    FieldByName('sfbuser').AsString  := g_UInfo^.UserId;
    FieldByName('sfbgrup').AsString  := '0D9261';
    FieldByName('sfbdate').AsDateTime:= Date;
    if Copy(tmpsfb01,1,3)='514' then
       FieldByName('ta_sfb02').AsString := 'A'    //生產線別
    else
       FieldByName('ta_sfb02').AsString := '1';
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
    FieldByName('ta_sfb10').AsString := '1';
    Post;
  end;

  //工單單身
  ShowSB('正在添加[工單單身資料]'+tmpCntMsg);
  FimaCDS.Locate('ima01',OrdWono.L_pno,[]);
  with FsfaCDS do
  begin
    Append;
    FieldByName('sfa01').AsString   := tmpsfb01;
    FieldByName('sfa02').AsInteger  := FsfbCDS.FieldByName('sfb02').AsInteger;
    FieldByName('sfa03').AsString   := OrdWono.L_pno;
    FieldByName('sfa04').AsFloat    := 0; //后面重新計算
    FieldByName('sfa05').AsFloat    := OrdWono.L_qty;
    FieldByName('sfa06').AsFloat    := 0;
    FieldByName('sfa061').AsFloat   := 0;
    FieldByName('sfa062').AsFloat   := 0;
    FieldByName('sfa063').AsFloat   := 0;
    FieldByName('sfa064').AsFloat   := 0;
    FieldByName('sfa065').AsFloat   := 0;
    FieldByName('sfa066').AsFloat   := 0;
    FieldByName('sfa07').AsFloat    := 0;
    FieldByName('sfa08').AsString   := ' ';
    FieldByName('sfa09').AsInteger  := 0;
    FieldByName('sfa11').AsString   := 'N'; //sfb39='2'時'E'
    if FimaCDS.FieldByName('ima70').AsString='Y' then
       FieldByName('sfa11').AsString:= 'E';
    FieldByName('sfa12').AsString   := FimaCDS.FieldByName('ima25').AsString;
    FieldByName('sfa13').AsFloat    := 1;
    FieldByName('sfa14').AsString   := FimaCDS.FieldByName('ima25').AsString;
    FieldByName('sfa15').AsFloat    := 1;
    FieldByName('sfa16').AsFloat    := 1;
    FieldByName('sfa161').AsFloat   := RoundTo(OrdWono.L_qty/OrdWono.qty,-5);
    if Pos(OrdWono.FstCode,'ET')>0 then
       FieldByName('sfa04').AsFloat := RoundTo(OrdWono.Qty/OrdWono.tc_ocm03,-3)
    else begin
      if OrdWono.ta_oeb03='2' then
         FieldByName('sfa04').AsFloat := RoundTo(OrdWono.Qty/OrdWono.tc_ocm03*OrdWono.ta_oeb01/1000,-3)
      else
         FieldByName('sfa04').AsFloat := RoundTo(OrdWono.Qty/OrdWono.tc_ocm03*OrdWono.ta_oeb01*0.0254,-3);
    end;
    FieldByName('sfa25').AsFloat    := FieldByName('sfa04').AsFloat;
    FieldByName('sfa26').AsString   := '0';
    FieldByName('sfa27').AsString   := OrdWono.L_pno;
    FieldByName('sfa28').AsFloat    := 1;
    FieldByName('sfa29').AsString   := OrdWono.Pno;
    FieldByName('sfa100').AsFloat   := 0;
    FieldByName('sfaacti').AsString := 'Y';
    Post;
  end;

  OutWono:=tmpsfb01;
  Result:=True;
end;

end.
