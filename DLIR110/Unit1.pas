{*******************************************************}
{                                                       }
{                DLIR110.exe                            }
{                Author: kaikai                         }
{                Create date: 2020/03/06                }
{                Description: 特殊膠系管控表            }
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
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure test1Click(Sender: TObject);
  private
    l_mailFrom,l_mailTo:string;
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

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="bu" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="odate" fieldtype="date"/>'
           +'<FIELD attrname="ddate" fieldtype="date"/>'
           +'<FIELD attrname="edate" fieldtype="date"/>'
           +'<FIELD attrname="adate" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="cdate" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="longitude" fieldtype="r8"/>'
           +'<FIELD attrname="latitude" fieldtype="r8"/>'
           +'<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ta_oeb07" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderqty" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="remainqty" fieldtype="r8"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
           +'<FIELD attrname="custorderno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="custprono" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="custname" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="remark" fieldtype="string" WIDTH="400"/>'
           +'<FIELD attrname="remark1" fieldtype="string" WIDTH="400"/>'
           +'<FIELD attrname="remark2" fieldtype="string" WIDTH="400"/>'
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

function TForm1.GetRpt(var xfname,xfpath:string):Boolean;
const xls='Temp\特殊膠系管控表.xlsx';
var
  i,r,cWidth:Integer;
  tmpBu,tmpOrderno,fPath:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('特殊膠系管控表');
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

  CDS1.Filtered:=False;
  CDS1.IndexFieldNames:='';
  pb.Position:=0;
  pb.Visible:=True;
  try
    for i:=1 to 2 do
    begin
      if i=1 then
         tmpBu:='ITEQDG'
      else
         tmpBu:='ITEQGZ';
      tmpOrderno:='';
      Memo1.Lines.Add('正在查詢訂單資料:'+tmpBu);
      Application.ProcessMessages;
      with ADOQuery1 do
      begin
        Close;
        SQL.Text:='select C.*,oao06 from'
                 +' (select B.*,ima021 from'
                 +' (select A.*,occ02,occ241 from'
                 +' (select oea01,oea02,oea04,oea044,oea10,oea23,oeb03,oeb04,oeb05,oeb06,'
                 +' oeb11,oeb12,oeb13,oeb14,oeb14t,oeb15,oeb24,ta_oeb01,ta_oeb02,ta_oeb04,ta_oeb07,ta_oeb10'
                 +' from '+tmpBu+'.oea_file inner join '+tmpBu+'.oeb_file on oea01=oeb01'
                 +' where oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y'' and oeb12>oeb24'
                 +' and oea02>sysdate-31'
                 +' and oea01 not like ''226%'''
                 +' and oea01 not like ''228%'''
                 +' and oea01 not like ''22A%'''
                 +' and oea01 not like ''22B%'''
                 +' and oea04 not in(''N012'',''N005'')'
                 +' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%'''
                 +' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%'''
                 +' or oeb04 like ''R%'' or oeb04 like ''T%'')'
                 +' and substr(oeb04,2,1) not in (''4'',''6'',''8'',''F'',''Q'')'
                 +' and oeb06 not like ''玻%'''
                 +' and oeb06 not like ''ML%'') A'
                 +' inner join '+tmpBu+'.occ_file on oea04=occ01'
                 +' ) B left join '+tmpBu+'.ima_file on oeb04=ima01'
                 +' ) C left join '+tmpBu+'.oao_file on oea01=oao01 and oeb03=oao03'
                 +' order by oea02,oea01,oeb03';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(tmpBu+#13#10+e.Message);
            Exit;
          end;
        end;
      end;

      //添加資料
      with ADOQuery1 do
      begin
        if IsEmpty then
        begin
          Memo1.Lines.Add('無資料:'+tmpBu);
          Continue;
        end;

        First;
        while not Eof do
        begin
          CDS1.Append;
          CDS1.FieldByName('bu').AsString:=tmpBu;
          CDS1.FieldByName('odate').AsDateTime:=FieldByName('oea02').AsDateTime;
          try
            CDS1.FieldByName('ddate').AsDateTime:=DateOf(FieldByName('oeb15').AsDateTime);
          except
            CDS1.FieldByName('ddate').Clear;
          end;
          CDS1.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
          CDS1.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
          CDS1.FieldByName('orderno').AsString:=FieldByName('oea01').AsString;
          CDS1.FieldByName('orderitem').AsInteger:=FieldByName('oeb03').AsInteger;
          CDS1.FieldByName('pno').AsString:=FieldByName('oeb04').AsString;
          CDS1.FieldByName('pname').AsString:=FieldByName('oeb06').AsString;
          CDS1.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
          CDS1.FieldByName('longitude').AsString:=FieldByName('ta_oeb01').AsString;
          CDS1.FieldByName('latitude').AsString:=FieldByName('ta_oeb02').AsString;
          CDS1.FieldByName('ta_oeb04').AsString:=FieldByName('ta_oeb04').AsString;
          CDS1.FieldByName('ta_oeb07').AsString:=FieldByName('ta_oeb07').AsString;
          CDS1.FieldByName('orderqty').AsFloat:=FieldByName('oeb12').AsFloat;
          CDS1.FieldByName('outqty').AsFloat:=FieldByName('oeb24').AsFloat;
          CDS1.FieldByName('remainqty').AsFloat:=RoundTo(FieldByName('oeb12').AsFloat-FieldByName('oeb24').AsFloat, -3);
          CDS1.FieldByName('units').AsString:=FieldByName('oeb05').AsString;
          CDS1.FieldByName('custorderno').AsString:=FieldByName('oea10').AsString;
          CDS1.FieldByName('custprono').AsString:=FieldByName('oeb11').AsString;
          CDS1.FieldByName('custname').AsString:=FieldByName('ta_oeb10').AsString;
          CDS1.FieldByName('remark').AsString:=FieldByName('oao06').AsString;
          CDS1.Post;
          if Pos(FieldByName('oea01').AsString,tmpOrderno)=0 then
             tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('oea01').AsString);
          Next;
        end;
        System.Delete(tmpOrderno,1,1);
      end;

      Memo1.Lines.Add('正在查詢交期與備註資料:'+tmpBu);
      Application.ProcessMessages;
      with ADOQuery2 do
      begin
        Close;
        SQL.Text:='select orderno,orderitem,ddate,edate,remark1,remark2'
                 +' from dli017 where bu='+Quotedstr(tmpBu)
                 +' and orderno in ('+tmpOrderno+')';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(tmpBu+#13#10+e.Message);
            Exit;
          end;
        end;

        while not Eof do
        begin
          if CDS1.Locate('bu;orderno;orderitem',VarArrayof([tmpBu,FieldByName('orderno').AsString,
              IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
          begin
            CDS1.Edit;
            if not FieldByName('ddate').IsNull then
               CDS1.FieldByName('ddate').AsDateTime:=FieldByName('ddate').AsDateTime;
            if not FieldByName('edate').IsNull then
               CDS1.FieldByName('edate').AsDateTime:=FieldByName('edate').AsDateTime;
            CDS1.FieldByName('remark1').AsString:=FieldByName('remark1').AsString;
            CDS1.FieldByName('remark2').AsString:=FieldByName('remark2').AsString;
            CDS1.Post;
          end;
          Next;
        end;
      end;

      Memo1.Lines.Add('正在查詢拆分交期資料:'+tmpBu);
      Application.ProcessMessages;
      with ADOQuery2 do
      begin
        Close;
        SQL.Text:='select orderno,orderitem,adate,cdate'
                 +' from mps200 where bu='+Quotedstr(tmpBu)
                 +' and orderno in ('+tmpOrderno+')'
                 +' and isnull(garbageflag,0)=0'
                 +' order by orderno,orderitem,adate,cdate';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(tmpBu+#13#10+e.Message);
            Exit;
          end;
        end;

        while not Eof do
        begin
          if CDS1.Locate('bu;orderno;orderitem',VarArrayOf([tmpBu,FieldByName('orderno').AsString,
                    IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
          begin
            if (not FieldByName('adate').IsNull) and
               (Pos(DateToStr(FieldByName('adate').AsDateTime),CDS1.FieldByName('adate').AsString)=0) then
            begin
              CDS1.Edit;
              if CDS1.FieldByName('edate').IsNull then //達客戶交期=生管交期
                 CDS1.FieldByName('edate').AsDateTime:=FieldByName('adate').AsDateTime;
              if Length(CDS1.FieldByName('adate').AsString)>0 then
                 CDS1.FieldByName('adate').AsString:=CDS1.FieldByName('adate').AsString+','+
                                                     DateToStr(FieldByName('adate').AsDateTime)
              else
                 CDS1.FieldByName('adate').AsString:=DateToStr(FieldByName('adate').AsDateTime);
              CDS1.Post;
            end;

            if (not FieldByName('cdate').IsNull) and
               (Pos(DateToStr(FieldByName('cdate').AsDateTime),CDS1.FieldByName('cdate').AsString)=0) then
            begin
              CDS1.Edit;
              if Length(CDS1.FieldByName('cdate').AsString)>0 then
                 CDS1.FieldByName('cdate').AsString:=CDS1.FieldByName('cdate').AsString+','+
                                                     DateToStr(FieldByName('cdate').AsDateTime)
              else
                 CDS1.FieldByName('cdate').AsString:=DateToStr(FieldByName('cdate').AsDateTime);
              CDS1.Post;
            end;
          end;
          Next;
        end;
      end;
    end;

    //明細:匯出xls
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(l_path+xls);
    for i:=1 to 2 do
    begin
      if i=1 then
      begin
        Memo1.Lines.Add('正在匯出xls:ITEQDG');
        Application.ProcessMessages;
        CDS1.Filtered:=False;
        CDS1.Filter:='bu=''ITEQDG''';
        CDS1.Filtered:=True;
      end else
      begin
        Memo1.Lines.Add('正在匯出xls:ITEQGZ');
        Application.ProcessMessages;
        CDS1.Filtered:=False;
        CDS1.Filter:='bu=''ITEQGZ''';
        CDS1.Filtered:=True;
      end;
      CDS1.IndexFieldNames:='bu;odate;orderno;orderitem';
      ExcelApp.WorkSheets[i].Activate;
      cWidth:=ExcelApp.ActiveSheet.Columns[4].ColumnWidth;

      r:=2;
      pb.Position:=0;
      pb.Max:=CDS1.RecordCount;
      CDS1.First;
      while not CDS1.Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        ExcelApp.ActiveSheet.Cells[r,1].Value:=CDS1.FieldByName('odate').AsDateTime;
        if not CDS1.FieldByName('ddate').IsNull then
           ExcelApp.ActiveSheet.Cells[r,2].Value:=CDS1.FieldByName('ddate').AsDateTime;
        if not CDS1.FieldByName('edate').IsNull then
           ExcelApp.ActiveSheet.Cells[r,3].Value:=CDS1.FieldByName('edate').AsDateTime;
        ExcelApp.ActiveSheet.Cells[r,4].Value:=CDS1.FieldByName('adate').AsString;
        ExcelApp.ActiveSheet.Cells[r,5].Value:=CDS1.FieldByName('cdate').AsString;
        ExcelApp.ActiveSheet.Cells[r,6].Value:=CDS1.FieldByName('custno').AsString;
        ExcelApp.ActiveSheet.Cells[r,7].Value:=CDS1.FieldByName('custshort').AsString;
        ExcelApp.ActiveSheet.Cells[r,8].Value:=CDS1.FieldByName('orderno').AsString;
        ExcelApp.ActiveSheet.Cells[r,9].Value:=CDS1.FieldByName('orderitem').AsInteger;
        ExcelApp.ActiveSheet.Cells[r,10].Value:=CDS1.FieldByName('pno').AsString;
        ExcelApp.ActiveSheet.Cells[r,11].Value:=CDS1.FieldByName('pname').AsString;
        ExcelApp.ActiveSheet.Cells[r,12].Value:=CDS1.FieldByName('sizes').AsString;
        ExcelApp.ActiveSheet.Cells[r,13].Value:=CDS1.FieldByName('longitude').AsString;
        ExcelApp.ActiveSheet.Cells[r,14].Value:=CDS1.FieldByName('latitude').AsString;
        ExcelApp.ActiveSheet.Cells[r,15].Value:=CDS1.FieldByName('ta_oeb04').AsString;
        ExcelApp.ActiveSheet.Cells[r,16].Value:=CDS1.FieldByName('ta_oeb07').AsString;
        ExcelApp.ActiveSheet.Cells[r,17].Value:=CDS1.FieldByName('orderqty').AsString;
        ExcelApp.ActiveSheet.Cells[r,18].Value:=CDS1.FieldByName('outqty').AsString;
        ExcelApp.ActiveSheet.Cells[r,19].Value:=CDS1.FieldByName('remainqty').AsString;
        ExcelApp.ActiveSheet.Cells[r,20].Value:=CDS1.FieldByName('units').AsString;
        ExcelApp.ActiveSheet.Cells[r,21].Value:=CDS1.FieldByName('custorderno').AsString;
        ExcelApp.ActiveSheet.Cells[r,22].Value:=CDS1.FieldByName('custprono').AsString;
        ExcelApp.ActiveSheet.Cells[r,23].Value:=CDS1.FieldByName('custname').AsString;
        ExcelApp.ActiveSheet.Cells[r,24].Value:=CDS1.FieldByName('remark').AsString;
        ExcelApp.ActiveSheet.Cells[r,26].Value:=CDS1.FieldByName('remark1').AsString;
        ExcelApp.ActiveSheet.Cells[r,27].Value:=CDS1.FieldByName('remark2').AsString;
        CDS1.Next;
        Inc(r);
      end;

      //框線
      Dec(r);
      ExcelApp.ActiveSheet.Range['A1:Z'+IntToStr(r)].Borders.LineStyle := xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:Z'+IntToStr(r)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:Z'+IntToStr(r)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.ActiveSheet.Range['A1:Z'+IntToStr(r)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:Z'+IntToStr(r)].Borders[xlInsideHorizontal].Weight:=xlThin;
      ExcelApp.ActiveSheet.Columns.EntireColumn.AutoFit;
      ExcelApp.ActiveSheet.Columns[4].ColumnWidth:=cWidth;
      ExcelApp.ActiveSheet.Columns[5].ColumnWidth:=cWidth;
      ExcelApp.ActiveSheet.Range['A2'].Select;
    end;

    fPath:=l_path+'Temp\特殊膠系管控表'+IntToStr(YearOf(Date));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='特殊膠系管控表'+FormatDateTime('MMDD',Date);
    xfpath:=fPath+'\'+xfname+'.xlsx';
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.WorkSheets[1].SaveAs(xfpath);
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

      l_mailTo:=ini.ReadString('DLIR110','TOADDR','');
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
  CDS1.MergeChangeLog;

  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1);
  if LowerCase(s1)='dlir110' then //由ERPServer.exe啟動,Timer1延時10秒執行
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
