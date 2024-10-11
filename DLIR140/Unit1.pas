{*******************************************************}
{                                                       }
{                DLIR140.exe                            }
{                Author: kaikai                         }
{                Create date: 2019/12/12                }
{                Description: Lead Time管控表           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Menus, ExtCtrls, DBClient, DateUtils, Math,
  ExcelXP, Provider, ComCtrls, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IniFiles, StrUtils;

type
  TObj = Record
    FieldName,
    Caption     : string;
  end;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    m1: TMenuItem;
    ADOConn: TADOConnection;
    ADOQuery1: TADOQuery;
    test1: TMenuItem;
    pb: TProgressBar;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    ADOQuery2: TADOQuery;
    ORAConn: TADOConnection;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    CDS3: TClientDataSet;
    ADOQuery3: TADOQuery;
    ADOQuery4: TADOQuery;
    ADOQuery5: TADOQuery;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure test1Click(Sender: TObject);
  private
    l_mailFrom,l_mailTo:string;
    function CheckLT(ad,lst_code:string; LT:Integer):Boolean;
    function GetLT(ad,lst_code:string):string;
    function GetVipAdIndex(ad,pno:string):Integer;
    function GetRpt(var xfname,xfpath:string):Boolean;
    function SendEmail(xfname,xfpath:string):Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  l_path:string;

implementation

uses ComObj;

const l_xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sno" fieldtype="i4"/>'
           +'<FIELD attrname="reqlt" fieldtype="i4"/>'
           +'<FIELD attrname="avglt" fieldtype="i4"/>'
           +'<FIELD attrname="diffday" fieldtype="i4"/>'
           +'<FIELD attrname="ordcnt" fieldtype="i4"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

//解密
function Decrypt(Value:string):string;
type
  TEncrypt = procedure (SourceStr, DestStr:PChar);stdcall;
var
  DllHandle:HWnd;
  DllFunc:TEncrypt;
  P:PChar;
begin
  Result:='';
  DllHandle:=LoadLibrary('Encrypt.dll');
  if DllHandle<>0 then
  begin
    @DllFunc:=GetProcAddress(DllHandle, 'Decrypt');
    if @DllFunc<>nil then
    begin
      P:=StrAlloc(1024);
      try
        DllFunc(PChar(Value), P);
        Result:=P;
      finally
        StrDispose(P);
      end;
    end else
      raise Exception.Create('Invalid dll function ''Decrypt''');

    FreeLibrary(DllHandle);
  end else
    raise Exception.Create('Invalid dll name ''Encrypt''');
end;

procedure InitCDS(DataSet:TClientDataSet; Xml:string);
var
  tmpList:TStrings;
  tmpMS:TMemoryStream;
begin
  tmpMS:=TMemoryStream.Create;
  tmpList:=TStringList.Create;
  try
    tmpList.Add(Xml);
    tmpList.SaveToStream(tmpMS);
    tmpMS.Position:=0;
    DataSet.LoadFromStream(tmpMS);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpMS);
  end;
end;

//添加錯誤信息到記錄文件
procedure LogInfo(Err: string);
var
  tmpStr: string;
  txt: TextFile;
begin
  tmpStr:=l_path + 'Error';
  if not DirectoryExists(tmpStr) then
     CreateDir(tmpStr);
  tmpStr:=tmpStr + '\' +FormatDateTime('YYYYMM', Date);
  if not DirectoryExists(tmpStr) then
     CreateDir(tmpStr);
  tmpStr:= tmpStr + '\' +FormatDateTime('YYYYMMDD', Date) + '.txt';
  AssignFile(txt, tmpStr);
  if not FileExists(tmpStr) then
     Rewrite(txt);
  Append(txt);
  Write(txt, DateTimeToStr(Now)+#13#10+Err+#13#10);
  CloseFile(txt);
end;

function TForm1.CheckLT(ad,lst_code:string; LT:Integer):Boolean;
var
  s:string;
begin
  Result:=False;
  s:='/'+ad+'/';
  if Pos(s,'/IT140G/IT150G/')>0 then
  begin
    if Pos(lst_code,'nkNK')>0 then
    begin
      if lt>3 then
         Result:=True;
    end else
    begin
      if lt>5 then
         Result:=True;
    end
  end else
  if Pos(s,'/IT168G/IT168G1/')>0 then
  begin
    if lt>3 then
       Result:=True;
  end else
  if Pos(s,'/IT170GRA/IT170GRA1/')>0 then
  begin
    if lt>5 then
       Result:=True;
  end else
  if Pos(s,'/IT150GS/IT170GT/')>0 then
  begin
    if lt>7 then
       Result:=True;
  end else
  if lt>7 then
     Result:=True;
end;

function TForm1.GetLT(ad,lst_code:string):string;
var
  s:string;
begin
  s:='/'+ad+'/';
  if Pos(s,'/IT140G/IT150G/')>0 then
  begin
    if Pos(lst_code,'nkNK')>0 then
       Result:='T+3'
    else
       Result:='T+5';
  end
  else if Pos(s,'/IT168G/IT168G1/')>0 then
     Result:='T+3'
  else if Pos(s,'/IT170GRA/IT170GRA1/')>0 then
     Result:='T+5'
  else if Pos(s,'/IT150GS/IT170GT/')>0 then
     Result:='T+7'
  else
     Result:='T+x';
end;

function TForm1.GetVipAdIndex(ad,pno:string):Integer;
begin
  if SameText(ad,'IT140G') or SameText(ad,'IT150G') then
  begin
    if Pos(UpperCase(RightStr(pno,1)),'NK')>0 then
       Result:=1
    else
       Result:=2;
  end
  else if SameText(ad,'IT168G') or SameText(ad,'IT168G1') then
     Result:=3
  else if SameText(ad,'IT170GRA') or SameText(ad,'IT170GRA1') then
     Result:=4
  else if SameText(ad,'IT150GS') then
     Result:=5
  else if SameText(ad,'IT170GT') then
     Result:=6
  else
     Result:=0;
end;

function TForm1.GetRpt(var xfname,xfpath:string):Boolean;
const xls='Temp\Lead Time管控表.xlsx';
var
  Bo,isIndate,isOeb15Date,isOverLT:Boolean;
  i,r,lt,adIndex,ltType:Integer;
  tmpDefDate,tmpAdate,tmpIndate,D1,D2:TDateTime;
  tmpFilter,tmpBu,tmpSrcFlag,fPath,qryD,tmpCell:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('Lead Time管控表');
  Memo1.Lines.Add('begin rpt');
  if not FileExists(l_path+xls) then
  begin
    Memo1.Lines.Add(l_path+xls+'不存在');
    LogInfo(Memo1.Text);
    Exit;
  end;

  try
    ExcelApp:=CreateOleObject('Excel.Application');
  except
    Memo1.Lines.Add('創建Excel失敗');
    LogInfo(Memo1.Text);
    Exit;
  end;

  pb.Position:=0;
  pb.Visible:=True;
  try
    r:=2;
    tmpBu:='ITEQDG';
    tmpDefDate:=EncodeDate(1955,5,5);
    D1:=Date-2;                                   //前天
    D2:=EncodeDate(YearOf(Date),MonthOf(Date),1); //當月1號
    if MonthOf(Date)=1 then                       //上月1號
       qryD:=FormatDateTime('YYYY/MM/DD',EncodeDate(YearOf(Date)-1,12,1))
    else
       qryD:=FormatDateTime('YYYY/MM/DD',EncodeDate(YearOf(Date),MonthOf(Date)-1,1));
    qryD:=StringReplace(qryD,'-','/',[rfReplaceAll]);
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(l_path+xls);
    ExcelApp.WorkSheets[1].Activate;
    for i:=1 to 2 do
    begin
      tmpFilter:='';

      Memo1.Lines.Add('正在查詢['+tmpBu+'訂單資料]');
      Application.ProcessMessages;
      with ADOQuery1 do
      begin
        Close;
        SQL.Text:='select * from ('
                 +' select oea01,oea02,oea04,oea044,oea10,oeb03,oeb04,oeb05,oeb06,'
                 +' oeb11,oeb12,oeb24,ta_oeb01,ta_oeb02,ta_oeb10,occ02,ima021,'
                 +' case when instr(ima02,''TC'',1,1)>0 then substr(ima02,1,instr(ima02,''TC'',1,1)-1)'
                 +' when instr(ima02,''BS'',1,1)>0 then substr(ima02,1,instr(ima02,''BS'',1,1)-1) else ''err'' end as ad,'
                 +' case when to_char(oeb15,''YYYY'') between ''2000'' and ''9998'' then oeb15 else null end oeb15'
                 +' from '+tmpBu+'.oea_file,'+tmpBu+'.oeb_file,'+tmpBu+'.occ_file,'+tmpBu+'.ima_file'
                 +' where oea01=oeb01 and oea04=occ01 and oeb04=ima01'
                 +' and to_char(oea02,''YYYY/MM/DD'')>='+Quotedstr(qryD)
                 +' and oeaconf=''Y'' and oeb70<>''Y'' and oeb12>0'
                 +' and substr(oea01,1,3) not in (''226'',''22A'')'
                 +' and substr(oea04,1,1)<>''N'''
                 +' and substr(oeb04,length(oeb04),1)<>''0'''
                 +' and substr(oeb04,1,1) in (''E'',''T'',''R'',''B'',''N'',''M'')) X'
                 +' where ad in (''IT150G'',''IT140G'',''IT168G'',''IT168G1'',''IT170GRA'',''IT170GRA1'',''IT150GS'',''IT170GT'')'
                 +' order by ad,oea04,oea02,oea01,oeb03';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
        if IsEmpty then
        begin
          tmpBu:='ITEQGZ';
          Continue;
        end;

        while not Eof do
        begin
          if Pos(FieldByName('oea01').AsString, tmpFilter)=0 then
             tmpFilter:=tmpFilter+','+Quotedstr(FieldByName('oea01').AsString);
          Next;
        end;
      end;

      Memo1.Lines.Add('正在查詢['+tmpBu+'拆分資料]');
      Application.ProcessMessages;
      Delete(tmpFilter,1,1);
      with ADOQuery2 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Adate) Adate,Min(Cdate) Cdate'
                 +' From MPS200 Where Bu='+Quotedstr(tmpBu)
                 +' And Orderno in ('+tmpFilter+')'
                 +' And IsNull(GarbageFlag,0)=0'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('正在查詢['+tmpBu+' CCL生產排程資料]');
      Application.ProcessMessages;
      if SameText(tmpBu,'ITEQDG') then
         tmpSrcFlag:=' And SrcFlag in (1,3,5)'
      else
         tmpSrcFlag:=' And SrcFlag in (2,4,6)';
      with ADOQuery3 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Sdate) Sdate From ('
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS010 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union'
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS010_20160409 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('正在查詢['+tmpBu+' PP生產排程資料]');
      Application.ProcessMessages;
      with ADOQuery4 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Sdate) Sdate From ('
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS070 Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union'
                 +' Select Orderno,Orderitem,Sdate'
                 +' From MPS070_bak Where Bu=''ITEQDG'''
                 +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      Memo1.Lines.Add('正在查詢['+tmpBu+'出貨表資料]');
      Application.ProcessMessages;
      with ADOQuery5 do
      begin
        Close;
        SQL.Text:='Select Orderno,Orderitem,Min(Indate) Indate From ('
                 +' Select Orderno,Orderitem,Indate'
                 +' From DLI010 Where Bu='+Quotedstr(tmpBu)
                 +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
                 +' And Indate<getdate()'
                 +' And IsNull(QtyColor,0)<>999'
                 +' And Orderno in ('+tmpFilter+')'
                 +' Union All'
                 +' Select Orderno,Orderitem,Indate'
                 +' From DLI010_20160409 Where Bu='+Quotedstr(tmpBu)
                 +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
                 +' And IsNull(QtyColor,0)<>999'
                 +' And Orderno in ('+tmpFilter+')) X'
                 +' Group By Orderno,Orderitem'
                 +' Order By Orderno,Orderitem';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;
      end;

      //明細:匯出xls
      Memo1.Lines.Add('正在匯出['+tmpBu+'明細xls]');
      Application.ProcessMessages;
      pb.Position:=0;
      pb.Max:=ADOQuery1.RecordCount;
      ADOQuery1.First;
      while not ADOQuery1.Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        tmpFilter:='orderno='+Quotedstr(ADOQuery1.FieldByName('oea01').AsString)
                  +' and orderitem='+IntToStr(ADOQuery1.FieldByName('oeb03').AsInteger);

        //lt=出貨日期-訂單日期
        //lt=Call貨日期-訂單日期
        //lt=拆分日期-訂單日期
        //lt=客戶需求日期-訂單日期
        Bo:=False;              //是否找到日期
        isIndate:=False;        //是否是出貨日期
        isOeb15Date:=False;     //是否是客戶需求日期
        tmpIndate:=Date;
        ltType:=0;
        ADOQuery5.Filtered:=False;
        ADOQuery5.Filter:=tmpFilter;
        ADOQuery5.Filtered:=True;
        if (not ADOQuery5.IsEmpty) and (not ADOQuery5.FieldByName('indate').IsNull) then
        begin
          tmpIndate:=ADOQuery5.FieldByName('indate').AsDateTime;
          Bo:=True;
          isIndate:=True;
        end;

        if not Bo then
        begin
          ADOQuery2.Filtered:=False;
          ADOQuery2.Filter:=tmpFilter;
          ADOQuery2.Filtered:=True;
          if not ADOQuery2.IsEmpty then
          begin
            if not ADOQuery2.FieldByName('cdate').IsNull then
            begin
              tmpIndate:=ADOQuery2.FieldByName('cdate').AsDateTime;
              Bo:=True;
            end else
            if not ADOQuery2.FieldByName('adate').IsNull then
            begin
              tmpIndate:=ADOQuery2.FieldByName('adate').AsDateTime;
              Bo:=True;
            end;
          end;
        end;

        if (not Bo) and (not ADOQuery1.FieldByName('oeb15').IsNull) then
        begin
          tmpIndate:=ADOQuery1.FieldByName('oeb15').AsDateTime;
          Bo:=True;
          isOeb15Date:=True;
        end;

        if not Bo then
        begin
          ADOQuery1.Next;
          Continue;
        end;

        if ADOQuery1.FieldByName('oea02').AsDateTime<tmpIndate then
           lt:=DaysBetween(ADOQuery1.FieldByName('oea02').AsDateTime,tmpIndate)
        else
           lt:=0;

        //是否超出需求LT
        isOverLT:=CheckLT(UpperCase(ADOQuery1.FieldByName('ad').AsString),RightStr(ADOQuery1.FieldByName('oeb04').AsString,1),lt);

        //3天內資料:已拆分&訂單日期>=D1(前一天數據)
        if (not isOeb15Date) and (ADOQuery1.FieldByName('oea02').AsDateTime>=D1) then
        begin
          adIndex:=GetVipAdIndex(ADOQuery1.FieldByName('ad').AsString,ADOQuery1.FieldByName('oeb04').AsString);
          if adIndex<>0 then
          begin
            if not isOverLT then
            begin
              adIndex:=adIndex*10+1;    //符合LT:sno=adIndex對應11,21,31,41,51,61
              ltType:=1;
            end
            else if (not ADOQuery1.FieldByName('oeb15').IsNull) and
                    (tmpIndate<=ADOQuery1.FieldByName('oeb15').AsDateTime) then
            begin
              adIndex:=adIndex*10+2;    //不符合LT,但符合客戶需求日:sno=adIndex對應12,22,32,42,52,62
              ltType:=2;
            end
            else begin
              adIndex:=adIndex*10+3;    //其它:sno=adIndex對應13,23,33,43,53,63
              ltType:=3;
            end;
            if CDS1.Locate('sno',adIndex,[]) then
            begin
              CDS1.Edit;
              CDS1.FieldByName('avglt').AsInteger:=CDS1.FieldByName('avglt').AsInteger+lt;
              CDS1.FieldByName('ordcnt').AsInteger:=CDS1.FieldByName('ordcnt').AsInteger+1;
              CDS1.Post;
            end;
          end;
        end;

        //當月已出貨資料:訂單日期>=當月1號,即D2
        if isIndate and (ADOQuery1.FieldByName('oea02').AsDateTime>=D2) then
        begin
          adIndex:=GetVipAdIndex(ADOQuery1.FieldByName('ad').AsString,ADOQuery1.FieldByName('oeb04').AsString);
          if adIndex<>0 then
          begin
            if not isOverLT then
               adIndex:=adIndex*10+1    //符合LT:sno=adIndex對應11,21,31,41,51,61
            else if (not ADOQuery1.FieldByName('oeb15').IsNull) and
                    (tmpIndate<=ADOQuery1.FieldByName('oeb15').AsDateTime) then
               adIndex:=adIndex*10+2    //不符合LT,但符合客戶需求日:sno=adIndex對應12,22,32,42,52,62
            else
               adIndex:=adIndex*10+3;   //其它:sno=adIndex對應13,23,33,43,53,63
            if CDS2.Locate('sno',adIndex,[]) then
            begin
              CDS2.Edit;
              CDS2.FieldByName('avglt').AsInteger:=CDS2.FieldByName('avglt').AsInteger+lt;
              CDS2.FieldByName('ordcnt').AsInteger:=CDS2.FieldByName('ordcnt').AsInteger+1;
              CDS2.Post;
            end;
          end;
        end;

        //上月已出貨資料:訂單日期<當月1號,即D2
        if isIndate and (ADOQuery1.FieldByName('oea02').AsDateTime<D2) then
        begin
          adIndex:=GetVipAdIndex(ADOQuery1.FieldByName('ad').AsString,ADOQuery1.FieldByName('oeb04').AsString);
          if adIndex<>0 then
          begin
            if not isOverLT then
               adIndex:=adIndex*10+1    //符合LT:sno=adIndex對應11,21,31,41,51,61
            else if (not ADOQuery1.FieldByName('oeb15').IsNull) and
                    (tmpIndate<=ADOQuery1.FieldByName('oeb15').AsDateTime) then
               adIndex:=adIndex*10+2    //不符合LT,但符合客戶需求日:sno=adIndex對應12,22,32,42,52,62
            else
               adIndex:=adIndex*10+3;   //其它:sno=adIndex對應13,23,33,43,53,63
            if CDS3.Locate('sno',adIndex,[]) then
            begin
              CDS3.Edit;
              CDS3.FieldByName('avglt').AsInteger:=CDS3.FieldByName('avglt').AsInteger+lt;
              CDS3.FieldByName('ordcnt').AsInteger:=CDS3.FieldByName('ordcnt').AsInteger+1;
              CDS3.Post;
            end;
          end;
        end;

        //訂單日期<D1,不匯出excel
        if ADOQuery1.FieldByName('oea02').AsDateTime<D1 then
        begin
          ADOQuery1.Next;
          Continue;
        end;

        if (not ADOQuery5.IsEmpty) and (not ADOQuery5.FieldByName('indate').IsNull) then
           ExcelApp.Cells[r,14].Value:=ADOQuery5.FieldByName('indate').AsDateTime;
        ExcelApp.Cells[r,15].Value:=lt;
        ExcelApp.Cells[r,16].Value:=GetLT(UpperCase(ADOQuery1.FieldByName('ad').AsString),RightStr(ADOQuery1.FieldByName('oeb04').AsString,1));
        case ltType of
          1:ExcelApp.Cells[r,17].Value:='OK';
          2:ExcelApp.Cells[r,17].Value:='PO指定交期';
          3:ExcelApp.Cells[r,17].Value:='交期未達成';
          else
            ExcelApp.Cells[r,17].Value:='未答交';
        end;

        ExcelApp.Cells[r,1].Value:=tmpBu;
        ExcelApp.Cells[r,2].Value:=ADOQuery1.FieldByName('oea02').AsDateTime;
        ExcelApp.Cells[r,3].Value:=ADOQuery1.FieldByName('oea01').AsString;
        ExcelApp.Cells[r,4].Value:=ADOQuery1.FieldByName('oeb03').AsInteger;
        ExcelApp.Cells[r,5].Value:=ADOQuery1.FieldByName('occ02').AsString;
        ExcelApp.Cells[r,6].Value:=ADOQuery1.FieldByName('oeb04').AsString;
        ExcelApp.Cells[r,7].Value:=ADOQuery1.FieldByName('ad').AsString;
        ExcelApp.Cells[r,8].Value:=ADOQuery1.FieldByName('oeb12').AsFloat;
        ExcelApp.Cells[r,9].Value:=ADOQuery1.FieldByName('oeb05').AsString;
        if not ADOQuery1.FieldByName('oeb15').IsNull then
           ExcelApp.Cells[r,10].Value:=ADOQuery1.FieldByName('oeb15').AsDateTime;

        //達交日期,call貨日期
        tmpAdate:=tmpDefdate;
        ADOQuery2.Filtered:=False;
        ADOQuery2.Filter:=tmpFilter;
        ADOQuery2.Filtered:=True;
        if not ADOQuery2.IsEmpty then
        begin
          if not ADOQuery2.FieldByName('adate').IsNull then
          begin
            tmpAdate:=ADOQuery2.FieldByName('adate').AsDateTime;
            ExcelApp.Cells[r,11].Value:=tmpAdate;
          end;
          if not ADOQuery2.FieldByName('cdate').IsNull then
          begin
            tmpAdate:=ADOQuery2.FieldByName('cdate').AsDateTime;
            ExcelApp.Cells[r,12].Value:=tmpAdate;
          end;
        end;

        //ccl生產日期
        if ADOQuery1.FieldByName('oeb04').AsString[1] in ['E','T'] then
        begin
          ADOQuery3.Filtered:=False;
          ADOQuery3.Filter:=tmpFilter;
          ADOQuery3.Filtered:=True;
          if (not ADOQuery3.IsEmpty) and (not ADOQuery3.FieldByName('sdate').IsNull) then
             ExcelApp.Cells[r,13].Value:=ADOQuery3.FieldByName('sdate').AsDateTime;
        end else  //pp生產日期
        begin
          ADOQuery4.Filtered:=False;
          ADOQuery4.Filter:=tmpFilter;
          ADOQuery4.Filtered:=True;
          if (not ADOQuery4.IsEmpty) and (not ADOQuery4.FieldByName('sdate').IsNull) then
             ExcelApp.Cells[r,13].Value:=ADOQuery4.FieldByName('sdate').AsDateTime;
        end;

        //不符合要求,標記紅色
        if isOverLT then
        begin
          tmpCell:='O'+IntToStr(r)+':O'+IntToStr(r);
          ExcelApp.Range[tmpCell].Select;
          ExcelApp.Range[tmpCell].Interior.ColorIndex:=3;
          ExcelApp.Range[tmpCell].Interior.Pattern:=xlSolid;
        end;

        ADOQuery1.Next;
        Inc(r);
      end;

      tmpBu:='ITEQGZ';
    end;

    //框線
    Dec(r);
    tmpCell:='A1:Q'+IntToStr(r);
    ExcelApp.Range[tmpCell].Borders.LineStyle:=xlContinuous;
    ExcelApp.Range[tmpCell].Borders[xlInsideVertical].LineStyle:=xlContinuous;
    ExcelApp.Range[tmpCell].Borders[xlInsideVertical].Weight:=xlThin;
    ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
    ExcelApp.Range[tmpCell].Borders[xlInsideHorizontal].Weight:=xlThin;
    ExcelApp.Columns.EntireColumn.AutoFit;

    Inc(r,3);
    ExcelApp.Cells[r,1].Value:='Lead Time計算公式：';
    ExcelApp.Cells[r+1,1].Value:='1. 出貨日期-訂單日期';
    ExcelApp.Cells[r+2,1].Value:='2. Call貨日期-訂單日期';
    ExcelApp.Cells[r+3,1].Value:='3. 拆分日期-訂單日期';
    ExcelApp.Cells[r+4,1].Value:='4. 客戶需求日-訂單日期';
    ExcelApp.Range['A2'].Select;

    //匯總,匯出xls
    Memo1.Lines.Add('正在匯出[匯總資料]');
    Application.ProcessMessages;
    r:=3;
    ExcelApp.WorkSheets[2].Activate;
    ExcelApp.Cells[1,1].Value:=FormatDateTime('M/D',D1)+'~'+FormatDateTime('M/D',Date)+' 達交Lead Time 狀況';
    with CDS1 do
    begin
      First;
      While not Eof do
      begin
        if FieldByName('ordcnt').AsInteger>0 then
        begin
          lt:=Round(FieldByName('avglt').AsInteger/FieldByName('ordcnt').AsInteger); //平均lt
          ExcelApp.Cells[r,3].Value:=lt;
          ExcelApp.Cells[r,5].Value:=lt-FieldByName('reqlt').AsInteger;
          ExcelApp.Cells[r,6].Value:=FieldByName('ordcnt').AsInteger;
        end;
        Next;
        Inc(r);
      end;
    end;

    r:=24;
    with CDS2 do
    begin
      First;
      While not Eof do
      begin
        if FieldByName('ordcnt').AsInteger>0 then
        begin
          lt:=Round(FieldByName('avglt').AsInteger/FieldByName('ordcnt').AsInteger); //平均lt
          ExcelApp.Cells[r,3].Value:=lt;
          ExcelApp.Cells[r,5].Value:=lt-FieldByName('reqlt').AsInteger;
          ExcelApp.Cells[r,6].Value:=FieldByName('ordcnt').AsInteger;
        end;
        Next;
        Inc(r);
      end;
    end;

    r:=45;
    with CDS3 do
    begin
      First;
      While not Eof do
      begin
        if FieldByName('ordcnt').AsInteger>0 then
        begin
          lt:=Round(FieldByName('avglt').AsInteger/FieldByName('ordcnt').AsInteger); //平均lt
          ExcelApp.Cells[r,3].Value:=lt;
          ExcelApp.Cells[r,5].Value:=lt-FieldByName('reqlt').AsInteger;
          ExcelApp.Cells[r,6].Value:=FieldByName('ordcnt').AsInteger;
        end;
        Next;
        Inc(r);
      end;
    end;

    ExcelApp.Range['I2'].Select;
    fPath:=l_path+'Temp\Lead Time管控表'+IntToStr(YearOf(Date));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='Lead Time管控表'+FormatDateTime('MMDD',Date);
    xfpath:=fPath+'\'+xfname+'.xlsx';
    ExcelApp.WorkSheets[2].SaveAs(xfpath);
    Memo1.Lines.Add('end rpt');
    Result:=True;

  finally
    PB.Visible:=False;
    ExcelApp.Quit;
    LogInfo(Memo1.Text);
  end;
end;

function TForm1.SendEmail(xfname,xfpath:string):Boolean;
var
  msg:string;
begin
  Result:=False;

  if (Length(l_mailFrom)=0) or (Length(l_mailTo)=0) then
  begin
    msg:='發送人或接收人未設定';
    Memo1.Lines.Add(msg);
    LogInfo(msg);
    Exit;
  end;

  try
    IdSMTP1.Disconnect;
    IdSMTP1.Connect;
    IdSMTP1.Authenticate;
  except
    on e:exception do
    begin
      msg:='郵箱登入失敗:'+#13#10+e.Message;
      Memo1.Lines.Add(msg);
      LogInfo(msg);
      Exit;
    end;
  end;

  IdMessage1.MessageParts.Clear;
  TIdattachment.Create(IdMessage1.MessageParts,xfpath);
  IdMessage1.From.Address:=l_mailFrom;                      //發件人
  IdMessage1.Recipients.EMailAddresses:=l_mailTo;           //收件人
  IdMessage1.Subject:=xfname;                               //郵件主旨
                                                            //郵件正文
  IdMessage1.Body.Text:='Dear ALL：'+#13#10
                       +'    附件為【'+xfname+'】，請查閱！'+#13#10
                       +'本通知由外掛ERP系統自動發出，請勿回覆，若有疑問請聯絡相關人員，謝謝！'+#13#10#13#10
                       +StringReplace(FormatDateTime('YYYY/MM/DD HH:NN:SS',Now),'-','/',[rfReplaceAll]);
  try
    IdSMTP1.Send(IdMessage1);
    Result:=True;

    msg:='郵件發送成功';
    Memo1.Lines.Add(msg);
    LogInfo(msg);
  except
    on e:exception do
    begin
      msg:='郵件發送失敗:'+#13#10+e.Message;
      Memo1.Lines.Add(msg);
      LogInfo(msg);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s1:string;
  SQLIP,SQLUID,SQLPW,SQLDB:string;
  ORAIP,ORAUID,ORAPW:string;
  MailIP,MailID,MailPW:string;
  ini:TIniFile;
begin
  l_path:=ExtractFilePath(Application.ExeName);
  if FileExists(l_path+'MailConfig.ini') then
  begin
    ini:=TIniFile.Create(l_path+'MailConfig.ini');
    try
      //SQLServer服務器
      SQLIP:=ini.ReadString('SQLServer','IP','');
      SQLUID:=ini.ReadString('SQLServer','UID','');
      SQLPW:=ini.ReadString('SQLServer','PW','');
      SQLDB:=ini.ReadString('SQLServer','DB','');
      SQLPW:=Decrypt(SQLPW);

      //ORAServer服務器
      ORAIP:=ini.ReadString('ORAServer','IP','');
      ORAUID:=ini.ReadString('ORAServer','UID','');
      ORAPW:=ini.ReadString('ORAServer','PW','');
      ORAPW:=Decrypt(ORAPW);

      //MailServer服務器
      MailIP:=ini.ReadString('MailServer','IP','');
      MailID:=ini.ReadString('MailServer','UID','');
      MailPW:=ini.ReadString('MailServer','PW','');
      l_mailFrom:=ini.ReadString('MailServer','FROMADDR','');

      l_mailTo:=ini.ReadString('DLIR140','TOADDR','');
      MailPW:=Decrypt(MailPW);
    finally
      ini.Free;
    end;
  end;

  ADOConn.ConnectionString:='Provider=SQLOLEDB.1;Password='+SQLPW+';Persist Security Info=True;User ID='+SQLUID+';Initial Catalog='+SQLDB+';Data Source='+SQLIP;
  ORAConn.ConnectionString:='Provider=MSDAORA.1;Password='+ORAPW+';User ID='+ORAUID+';Data Source='+ORAIP+';Persist Security Info=True';
  IdSMTP1.Host:=MailIP;
  idsmtp1.AuthenticationType:=atLogin; //郵箱登錄驗證{atNone,atLogin}
  IdSMTP1.Username:=MailID;
  IdSMTP1.Password:=MailPW;

  InitCDS(CDS1, l_xml);
  with CDS1 do
  begin
    Append;
    FieldByName('sno').AsInteger:=11;         //OK
    FieldByName('reqlt').AsInteger:=3;
    Post;
    Append;
    FieldByName('sno').AsInteger:=12;         //PO指定交期
    FieldByName('reqlt').AsInteger:=3;
    Post;
    Append;
    FieldByName('sno').AsInteger:=13;         //交期未達成
    FieldByName('reqlt').AsInteger:=3;
    Post;

    Append;
    FieldByName('sno').AsInteger:=21;
    FieldByName('reqlt').AsInteger:=5;
    Post;
    Append;
    FieldByName('sno').AsInteger:=22;
    FieldByName('reqlt').AsInteger:=5;
    Post;
    Append;
    FieldByName('sno').AsInteger:=23;
    FieldByName('reqlt').AsInteger:=5;
    Post;

    Append;
    FieldByName('sno').AsInteger:=31;
    FieldByName('reqlt').AsInteger:=3;
    Post;
    Append;
    FieldByName('sno').AsInteger:=32;
    FieldByName('reqlt').AsInteger:=3;
    Post;
    Append;
    FieldByName('sno').AsInteger:=33;
    FieldByName('reqlt').AsInteger:=3;
    Post;

    Append;
    FieldByName('sno').AsInteger:=41;
    FieldByName('reqlt').AsInteger:=5;
    Post;
    Append;
    FieldByName('sno').AsInteger:=42;
    FieldByName('reqlt').AsInteger:=5;
    Post;
    Append;
    FieldByName('sno').AsInteger:=43;
    FieldByName('reqlt').AsInteger:=5;
    Post;

    Append;
    FieldByName('sno').AsInteger:=51;
    FieldByName('reqlt').AsInteger:=7;
    Post;
    Append;
    FieldByName('sno').AsInteger:=52;
    FieldByName('reqlt').AsInteger:=7;
    Post;
    Append;
    FieldByName('sno').AsInteger:=53;
    FieldByName('reqlt').AsInteger:=7;
    Post;

    Append;
    FieldByName('sno').AsInteger:=61;
    FieldByName('reqlt').AsInteger:=7;
    Post;
    Append;
    FieldByName('sno').AsInteger:=62;
    FieldByName('reqlt').AsInteger:=7;
    Post;
    Append;
    FieldByName('sno').AsInteger:=63;
    FieldByName('reqlt').AsInteger:=7;
    Post;
  end;
  CDS1.MergeChangeLog;   //匯總
  CDS2.Data:=CDS1.Data;  //當月
  CDS3.Data:=CDS1.Data;  //上月

  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1);
  if LowerCase(s1)='dlir140' then //由ERPServer.exe啟動,Timer1延時10秒執行
     Timer1.Enabled:=True;
end;

procedure TForm1.test1Click(Sender: TObject);
var
  xfname,xfpath:string;
begin
  if Application.MessageBox('test?','message',33)=IdOk then
  if GetRpt(xfname,xfpath) then
     SendEmail(xfname,xfpath);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  xfname,xfpath:string;
begin
  Timer1.Enabled:=False;
  if GetRpt(xfname,xfpath) then
     SendEmail(xfname,xfpath);
  Close;
end;

end.
