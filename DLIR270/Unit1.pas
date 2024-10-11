{*******************************************************}
{                                                       }
{                HJR001.exe                             }
{                Author: kaikai                         }
{                Create date: 2020/06/09                }
{                Description: DG訂單與HJ庫存對照表      }
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
    ADOQuery1: TADOQuery;
    test1: TMenuItem;
    pb: TProgressBar;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    ADOQuery2: TADOQuery;
    ORAConn: TADOConnection;
    CDS1: TClientDataSet;
    ADOConn: TADOConnection;
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
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="DG" fieldtype="r8"/>'
           +'<FIELD attrname="GZ" fieldtype="r8"/>'
           +'<FIELD attrname="JX" fieldtype="r8"/>'
           +'<FIELD attrname="B" fieldtype="r8"/>'
           +'<FIELD attrname="C" fieldtype="r8"/>'
           +'<FIELD attrname="D" fieldtype="r8"/>'
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

//批號轉換成日期
//lot為4碼如5A18表示2015-10-18, basedate取年份
function GetLotDate(Lot:string; BaseDate:TDateTime):TDateTime;
var
  aYear, aMonth, aDay: Word;
begin
  try
    DecodeDate(BaseDate, aYear, aMonth, aDay);
    aYear:=StrToInt(LeftStr(IntToStr(aYear),3)+Lot[1]);
    if aYear>=YearOf(BaseDate)+5 then
       aYear:=aYear-10;
    if Lot[2]='A' then
       aMonth:=10
    else if Lot[2]='B' then
       aMonth:=11
    else if Lot[2]='C' then
       aMonth:=12
    else
       aMonth:=StrToInt(Lot[2]);
    aDay:=StrToInt(RightStr(Lot,2));
    Result:=EncodeDate(aYear, aMonth, aDay);
  except
    Result:=EncodeDate(1955, 1, 1);
  end;
end;

function TForm1.GetRpt(var xfname,xfpath:string):Boolean;
const xls='Temp\HDI料號庫存管理表.xlsx';
var
  r,m:Integer;
  fPath,tmpFilter1,tmpFilter2,tmpFname,tmpLot,tmpImg02:string;
  tmpDate:TDateTime;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('HDI料號庫存管理表');
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

  try
    CDS1.EmptyDataSet;
    Memo1.Lines.Add('正在查詢HDI庫別資料');
    Application.ProcessMessages;
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:='select [id]=stuff((select '',''+[id] from dli029 where bu=''ITEQDG'' for xml path('''')),1,1,'''')';
      try
        Open;
      except
        on e: exception do
        begin
          Memo1.Lines.Add(e.Message);
          Exit;
        end;
      end;

      if not IsEmpty then
         tmpImg02:=Fields[0].AsString;
      if Length(tmpImg02)=0 then
      begin
        Memo1.Lines.Add('無HDI庫別資料');
        Exit;
      end;
    end;

    Memo1.Lines.Add('正在查詢HDI料號資料');
    Application.ProcessMessages;
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:='select pno,qty from dli080 where bu=''ITEQDG''';
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
        Memo1.Lines.Add('無HDI料號資料');
        Exit;
      end;

      First;
      while not Eof do
      begin
        CDS1.Append;
        CDS1.FieldByName('pno').AsString:=FieldByName('pno').AsString;
        CDS1.FieldByName('dg').AsFloat:=0;
        CDS1.FieldByName('gz').AsFloat:=0;
        CDS1.FieldByName('jx').AsFloat:=0;
        CDS1.FieldByName('b').AsFloat:=FieldByName('qty').AsFloat;
        CDS1.FieldByName('c').AsFloat:=0;
        CDS1.FieldByName('d').AsFloat:=-FieldByName('qty').AsFloat;
        CDS1.Post;

        Next;
      end;

      Memo1.Lines.Add('正在查詢HDI料號庫存資料');
      Application.ProcessMessages;
      tmpFilter1:='';
      tmpFilter2:='';
      First;
      while not Eof do
      begin
        tmpFilter1:=tmpFilter1+' or img01 like '+Quotedstr(FieldByName('pno').AsString+'%');
        tmpFilter2:=tmpFilter2+' or oeb04 like '+Quotedstr(FieldByName('pno').AsString+'%');

        Next;
        if Eof or (RecNo mod 30 =0) then   //每30個料號查詢一次
        begin
          System.Delete(tmpFilter1,1,4);
          ADOQuery2.Close;
          ADOQuery2.SQL.Text:='select bu,img01 pno,img04 lot,sum(img10) qty from('
                             +' select ''dg'' as bu,img01,img04,img10 from iteqdg.img_file where img10>0 and ('+tmpFilter1+')'
                             +' and instr('+Quotedstr(tmpImg02)+',img02)>0'
                             +' union all'
                             +' select ''gz'' as bu,img01,img04,img10 from iteqgz.img_file where img10>0 and ('+tmpFilter1+')'
                             +' and instr('+Quotedstr(tmpImg02)+',img02)>0'
                             +' union all'
                             +' select ''jx'' as bu,img01,img04,img10 from iteqjx.img_file where img10>0 and ('+tmpFilter1+')'
                             +' and instr('+Quotedstr(tmpImg02)+',img02)>0) t group by bu,img01,img04';
          try
            ADOQuery2.Open;
          except
            on e: exception do
            begin
              Memo1.Lines.Add(e.Message);
              Exit;
            end;
          end;

          CDS1.First;
          while not CDS1.Eof do
          begin
            ADOQuery2.Filtered:=False;
            ADOQuery2.Filter:='pno like '+Quotedstr(CDS1.FieldByName('pno').AsString+'%');
            ADOQuery2.Filtered:=True;
            while not ADOQuery2.Eof do
            begin
              tmpFname:=ADOQuery2.FieldByName('bu').AsString;

              tmpLot:=Copy(ADOQuery2.FieldByName('lot').AsString,2,4);
              if Length(tmpLot)=4 then
              begin
                tmpDate:=GetLotDate(tmpLot,Date);
                if Pos(Copy(ADOQuery2.FieldByName('lot').AsString,1,1),'ET')=0 then //PP有效期3個月內(90天)
                begin
                  if DaysBetween(tmpDate,Date)>90 then
                  begin
                    ADOQuery2.Next;
                    Continue;
                  end;
                end else //CCL有效期6個月內(180天)
                begin
                  if DaysBetween(tmpDate,Date)>180 then
                  begin
                    ADOQuery2.Next;
                    Continue;
                  end;
                end;

                CDS1.Edit;
                CDS1.FieldByName(tmpFname).AsFloat:=CDS1.FieldByName(tmpFname).AsFloat+ADOQuery2.FieldByName('qty').AsFloat;
                CDS1.FieldByName('d').AsFloat:=RoundTo(CDS1.FieldByName('dg').AsFloat+CDS1.FieldByName('gz').AsFloat+CDS1.FieldByName('jx').AsFloat-CDS1.FieldByName('b').AsFloat-CDS1.FieldByName('c').AsFloat,-3);
                CDS1.Post;
              end;

              ADOQuery2.Next;
            end;

            CDS1.Next;
          end;
          ADOQuery2.Filtered:=False;
          ADOQuery2.Filter:='';

          System.Delete(tmpFilter2,1,4);
          ADOQuery2.Close;
          ADOQuery2.SQL.Text:='select oeb04 pno,sum(qty) qty from('
                             +' select oeb04,oeb12-oeb24 qty from iteqdg.oea_file,iteqdg.oeb_file'
                             +' where oea01=oeb01 and oea02>sysdate-366'
                             +' and oea04 not in (''N004'',''N005'',''N006'',''N012'',''N019'',''N023'',''N024'',''AC458'')'
                             +' and oea01 not like ''228%'' and oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>oeb24 and ('+tmpFilter2+')'
                             +' union all'
                             +' select oeb04,oeb12-oeb24 qty from iteqgz.oea_file,iteqgz.oeb_file'
                             +' where oea01=oeb01 and oea02>sysdate-366'
                             +' and oea04 not in (''N004'',''N005'',''N006'',''N012'',''N019'',''N023'',''N024'',''AC458'')'
                             +' and oea01 not like ''228%'' and oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>oeb24 and ('+tmpFilter2+')'
                             +' union all'
                             +' select oeb04,oeb12-oeb24 qty from iteqjx.oea_file,iteqjx.oeb_file'
                             +' where oea01=oeb01 and oea02>sysdate-366'
                             +' and oea04 not in (''N004'',''N005'',''N006'',''N012'',''N019'',''N023'',''N024'',''AC458'')'
                             +' and oea01 not like ''228%'' and oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>oeb24 and ('+tmpFilter2+')) t group by oeb04';
          try
            ADOQuery2.Open;
          except
            on e: exception do
            begin
              Memo1.Lines.Add(e.Message);
              Exit;
            end;
          end;

          CDS1.First;
          while not CDS1.Eof do
          begin
            ADOQuery2.Filtered:=False;
            ADOQuery2.Filter:='pno like '+Quotedstr(CDS1.FieldByName('pno').AsString+'%');
            ADOQuery2.Filtered:=True;
            while not ADOQuery2.Eof do
            begin
              m:=1;
              if Pos(Copy(ADOQuery2.FieldByName('pno').AsString,1,1),'BR')>0 then
                 m:=StrToInt(Copy(ADOQuery2.FieldByName('pno').AsString,11,3));
              CDS1.Edit;
              CDS1.FieldByName('c').AsFloat:=CDS1.FieldByName('c').AsFloat+ADOQuery2.FieldByName('qty').AsFloat*m;
              CDS1.FieldByName('d').AsFloat:=RoundTo(CDS1.FieldByName('dg').AsFloat+CDS1.FieldByName('gz').AsFloat+CDS1.FieldByName('jx').AsFloat-CDS1.FieldByName('b').AsFloat-CDS1.FieldByName('c').AsFloat,-3);
              CDS1.Post;
              ADOQuery2.Next;
            end;

            CDS1.Next;
          end;
          ADOQuery2.Filtered:=False;
          ADOQuery2.Filter:='';
          tmpFilter1:='';
          tmpFilter2:='';
        end;
      end;
    end;

    if CDS1.ChangeCount>0 then
       CDS1.MergeChangeLog;

    if CDS1.IsEmpty then
    begin
      Memo1.Lines.Add('無資料');
      Exit;
    end;

    //匯出xls
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(l_path+xls);
    Memo1.Lines.Add('正在匯出xls');
    Application.ProcessMessages;
    ExcelApp.WorkSheets[1].Activate;
    r:=2;
    pb.Position:=0;
    pb.Max:=CDS1.RecordCount;
    pb.Visible:=True;
    CDS1.First;
    while not CDS1.Eof do
    begin
      pb.Position:=pb.Position+1;
      Application.ProcessMessages;

      ExcelApp.ActiveSheet.Cells[r,1].Value:=CDS1.FieldByName('pno').AsString;
      ExcelApp.ActiveSheet.Cells[r,2].Value:=CDS1.FieldByName('dg').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,3].Value:=CDS1.FieldByName('gz').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,4].Value:=CDS1.FieldByName('jx').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,5].Value:=CDS1.FieldByName('b').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,6].Value:=CDS1.FieldByName('c').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,7].Value:=CDS1.FieldByName('d').AsFloat;
      CDS1.Next;
      Inc(r);
    end;

    if r=2 then
    begin
      Memo1.Lines.Add('無資料');
      Exit;
    end;

    //框線
    Dec(r);
    ExcelApp.ActiveSheet.Range['A1:G'+IntToStr(r)].Borders.LineStyle := xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:G'+IntToStr(r)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:G'+IntToStr(r)].Borders[xlInsideVertical].Weight:=xlThin;
    ExcelApp.ActiveSheet.Range['A1:G'+IntToStr(r)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:G'+IntToStr(r)].Borders[xlInsideHorizontal].Weight:=xlThin;
    ExcelApp.ActiveSheet.Columns.EntireColumn.AutoFit;
    ExcelApp.ActiveSheet.Range['A2'].Select;

    fPath:=l_path+'Temp\HDI料號庫存管理表'+IntToStr(YearOf(Date));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='HDI料號庫存管理表'+FormatDateTime('MMDD',Date-1);
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
  SQLIP,SQLUID,SQLPW,SQLDB,ORAIP,ORAUID,ORAPW:string;
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

      l_mailTo:=ini.ReadString('DLIR270','TOADDR','');
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
  if LowerCase(s1)='dlir270' then //由ERPServer.exe啟動,Timer1延時10秒執行
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
