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
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="notqty" fieldtype="r8"/>'
           +'<FIELD attrname="stkqty" fieldtype="r8"/>'
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
const xls='Temp\DG訂單與HJ庫存對照表.xlsx';
var
  r:Integer;
  qryD,fPath:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('DG訂單與HJ庫存對照表');
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
    qryD:=StringReplace(FormatDateTime('YYYY-MM-DD',Date-1),'/','-',[rfReplaceAll]);
    Memo1.Lines.Add('正在查詢訂單資料');
    Application.ProcessMessages;
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:='select b.*,occ02 from'
               +' (select a.*,ima02,ima021 from'
               +' (select oea01,oea04,oeb03,oeb04,oeb12,oeb24,oeb12-oeb24 notqty,substr(oeb04,2,13) pno'
               +' from iteqdg.oea_file inner join iteqdg.oeb_file on oea01=oeb01'
               +' where oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>oeb24'
               +' and to_char(oea02,''YYYY-MM-DD'')='+Quotedstr(qryD)
               +' and (oeb04 like ''E%'' or oeb04 like ''T%'')'
               +' and length(oeb04)=17) a'
               +' inner join iteqdg.ima_file on oeb04=ima01) b'
               +' inner join iteqdg.occ_file on oea04=occ01'
               +' order by oea04,oea01,oeb03';
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

    Memo1.Lines.Add('正在查詢查詢庫存');
    Application.ProcessMessages;
    with ADOQuery2 do
    begin
      Close;
      SQL.Text:='select substr(img01,2,13) pno,sum(img10) qty from iteqhj.img_file'
               +' where img10>0 and length(img01)>14'
               +' and substr(img01,1,1) in (''E'',''T'')'
               +' group by substr(img01,2,13)';
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

    //添加資料
    with ADOQuery1 do
    begin
      if IsEmpty then
      begin
        Memo1.Lines.Add('無資料');
        Exit;
      end;

      First;
      while not Eof do
      begin
        if ADOQuery2.Locate('pno',FieldByName('pno').AsString,[]) then
        begin
          CDS1.Append;
          CDS1.FieldByName('orderno').AsString:=FieldByName('oea01').AsString;
          CDS1.FieldByName('orderitem').AsInteger:=FieldByName('oeb03').AsInteger;
          CDS1.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
          CDS1.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
          CDS1.FieldByName('pno').AsString:=FieldByName('oeb04').AsString;
          CDS1.FieldByName('pname').AsString:=FieldByName('ima02').AsString;
          CDS1.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
          CDS1.FieldByName('qty').AsFloat:=FieldByName('oeb12').AsFloat;
          CDS1.FieldByName('outqty').AsFloat:=FieldByName('oeb24').AsFloat;
          CDS1.FieldByName('notqty').AsFloat:=FieldByName('notqty').AsFloat;
          CDS1.FieldByName('stkqty').AsFloat:=ADOQuery2.FieldByName('qty').AsFloat;
          CDS1.Post;
        end;
        Next;
      end;
    end;

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

      ExcelApp.ActiveSheet.Cells[r,1].Value:=CDS1.FieldByName('orderno').AsString;
      ExcelApp.ActiveSheet.Cells[r,2].Value:=CDS1.FieldByName('orderitem').AsInteger;
      ExcelApp.ActiveSheet.Cells[r,3].Value:=CDS1.FieldByName('custno').AsString;
      ExcelApp.ActiveSheet.Cells[r,4].Value:=CDS1.FieldByName('custshort').AsString;
      ExcelApp.ActiveSheet.Cells[r,5].Value:=CDS1.FieldByName('pno').AsString;
      ExcelApp.ActiveSheet.Cells[r,6].Value:=CDS1.FieldByName('pname').AsString;
      ExcelApp.ActiveSheet.Cells[r,7].Value:=CDS1.FieldByName('sizes').AsString;
      ExcelApp.ActiveSheet.Cells[r,8].Value:=CDS1.FieldByName('qty').AsString;
      ExcelApp.ActiveSheet.Cells[r,9].Value:=CDS1.FieldByName('outqty').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,10].Value:=CDS1.FieldByName('notqty').AsFloat;
      ExcelApp.ActiveSheet.Cells[r,11].Value:=CDS1.FieldByName('stkqty').AsFloat;
      CDS1.Next;
      Inc(r);
    end;

    //框線
    Dec(r);
    ExcelApp.ActiveSheet.Range['A1:K'+IntToStr(r)].Borders.LineStyle := xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:K'+IntToStr(r)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:K'+IntToStr(r)].Borders[xlInsideVertical].Weight:=xlThin;
    ExcelApp.ActiveSheet.Range['A1:K'+IntToStr(r)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
    ExcelApp.ActiveSheet.Range['A1:K'+IntToStr(r)].Borders[xlInsideHorizontal].Weight:=xlThin;
    ExcelApp.ActiveSheet.Columns.EntireColumn.AutoFit;
    ExcelApp.ActiveSheet.Range['A2'].Select;

    fPath:=l_path+'Temp\DG訂單與HJ庫存對照表'+IntToStr(YearOf(Date));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='DG訂單與HJ庫存對照表'+FormatDateTime('MMDD',Date-1);
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
  ORAIP,ORAUID,ORAPW:string;
  MailIP,MailID,MailPW:string;
  ini:TIniFile;
begin
  l_path:=ExtractFilePath(Application.ExeName);
  if FileExists(l_path+'MailConfig.ini') then
  begin
    ini:=TIniFile.Create(l_path+'MailConfig.ini');
    try
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

      l_mailTo:=ini.ReadString('HJR001','TOADDR','');
      MailPW:=Decrypt(MailPW);
    finally
      ini.Free;
    end;
  end;

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
  if LowerCase(s1)='hjr001' then //由ERPServer.exe啟動,Timer1延時10秒執行
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
