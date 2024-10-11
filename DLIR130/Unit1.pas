{*******************************************************}
{                                                       }
{                DLIR130.exe                            }
{                Author: kaikai                         }
{                Create date: 2019/12/12                }
{                Description: 訂單狀況匯總表(by膠系)    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Menus, ExtCtrls, DateUtils, Math,
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
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure test1Click(Sender: TObject);
  private
    l_mailFrom,l_mailTo:string;
    function GetArrIndex(Ad:string):Integer;
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

function TForm1.GetArrIndex(Ad:string):Integer;
var
  tmpAd:string;
begin
  tmpAd:=UpperCase(Ad);
  if Pos(tmpAd,'IT150DA')>0 then
     Result:=0
  else if Pos(tmpAd,'IT170GRA1')>0 then
     Result:=1
  else if Pos(tmpAd,'IT200LK')>0 then
     Result:=2
  else if Pos(tmpAd,'IT958G')>0 then
     Result:=3
  else if Pos(tmpAd,'IT968')>0 then
     Result:=4
  else if Pos(tmpAd,'IT988G')>0 then
     Result:=5
  else if Pos(tmpAd,'IT150G')>0 then
     Result:=6
  else if Pos(tmpAd,'IT150G-HDI')>0 then
     Result:=7
  else if Pos(tmpAd,'IT150GL')>0 then
     Result:=8
  else if Pos(tmpAd,'IT150GM')>0 then
     Result:=9
  else if Pos(tmpAd,'IT150GS')>0 then
     Result:=10
  else if Pos(tmpAd,'IT168G')>0 then
     Result:=11
  else if Pos(tmpAd,'IT170GLE')>0 then
     Result:=12
  else if Pos(tmpAd,'IT800GLE')>0 then
     Result:=13
  else if Pos(tmpAd,'IT180')>0 then
     Result:=14
  else if Pos(tmpAd,'IT180A')>0 then
     Result:=15
  else if Pos(tmpAd,'IT180I')>0 then
     Result:=16
  else if Pos(tmpAd,'IT189')>0 then
     Result:=17
  else if Pos(tmpAd,'IT158')>0 then
     Result:=18
  else if Pos(tmpAd,'IT158A1')>0 then
     Result:=19
  else if Pos(tmpAd,'IT140')>0 then
     Result:=20
  else
     Result:=-1;
end;

function TForm1.GetRpt(var xfname,xfpath:string):Boolean;
const xls='Temp\訂單狀況匯總表.xlsx';
const cShortMonth ='YYYYMM';
const cShortDate ='YYYYMMDD';
var
  Arr:array [0..20,0..11] of Double;
  i,r,y,m,d,lstd:Integer;
  js_qty,js_amt,amt0:double;
  fEndDate,fPath:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('訂單狀況匯總表');
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
    amt0:=0;
    FillChar(Arr[0][0],SizeOf(Arr),0);
    fEndDate:=FormatDateTime(cShortDate,Date-1);

    //銷售目標
    Memo1.Lines.Add('正在查詢[銷售目標]');
    Application.ProcessMessages;
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:='select sno-1 as sno,cclqty,cclamt,ppqty,ppamt,js_cclqty,js_ppqty,js_cclamt,js_ppamt'
               +' from dli021 where bu=''ITEQDG'''
               +' and yyyymm='+Quotedstr(Copy(fEndDate,1,6))
               +' order by sno';
      try
        Open;
      except
        on e: exception do
        begin
          Memo1.Lines.Add(e.Message);
          Exit;
        end;
      end;

      pb.Position:=0;
      pb.Max:=RecordCount;
      while not Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        i:=FieldByName('sno').AsInteger;
        Arr[i,2]:=FieldByName('cclqty').AsFloat;
        Arr[i,5]:=FieldByName('cclamt').AsFloat;
        Arr[i,8]:=FieldByName('ppqty').AsFloat;
        Arr[i,11]:=FieldByName('ppamt').AsFloat;
        Next;
      end;
    end;

    Memo1.Lines.Add('正在查詢[訂單已交]');
    Application.ProcessMessages;
    with ADOQuery2 do
    begin
      Close;
      SQL.Text:='exec [dbo].[proc_DLIR130_1] '+Quotedstr(fEndDate);  //訂單已交(當月出貨資料)
      try
        Open;
      except
        on e: exception do
        begin
          Memo1.Lines.Add(e.Message);
          Exit;
        end;
      end;

      pb.Position:=0;
      pb.Max:=RecordCount;
      while not Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        if FieldByName('ad').AsString='0' then
           amt0:=amt0+FieldByName('amt').AsFloat
        else begin
          i:=GetArrIndex(FieldByName('ad').AsString);
          if i<>-1 then
          begin
            if FieldByName('type').AsInteger=1 then
            begin
              Arr[i][0]:=Arr[i][0]+FieldByName('qty').AsFloat;
              Arr[i][3]:=Arr[i][3]+FieldByName('amt').AsFloat;
            end
            else if FieldByName('type').AsInteger=2 then
            begin
              Arr[i][6]:=Arr[i][6]+FieldByName('qty').AsFloat;
              Arr[i][9]:=Arr[i][9]+FieldByName('amt').AsFloat;
            end;
          end;
        end;
        Next;
      end;
    end;

    //最後一天不計算未交
    y:=StrToInt(LeftStr(fEndDate,4));
    m:=StrToInt(Copy(fEndDate,5,2));
    d:=StrToInt(RightStr(fEndDate,2));
    lstd:=DayOf(EndOfAMonth(y,m));
    if lstd<>d then
    begin
      with ADOQuery2 do
      begin
        Memo1.Lines.Add('正在查詢[東莞訂單未交]');
        Application.ProcessMessages;
        Close;
        SQL.Text:='exec [dbo].[proc_DLIR130_2] '+Quotedstr('ITEQDG')+','+Quotedstr(fEndDate);
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;

        pb.Position:=0;
        pb.Max:=RecordCount;
        while not Eof do
        begin
          pb.Position:=pb.Position+1;
          Application.ProcessMessages;

          i:=GetArrIndex(FieldByName('ad').AsString);
          if i<>-1 then
          begin
            if FieldByName('type').AsInteger=1 then
            begin
              Arr[i][1]:=Arr[i][1]+FieldByName('qty').AsFloat;
              Arr[i][4]:=Arr[i][4]+FieldByName('amt').AsFloat;
            end
            else if FieldByName('type').AsInteger=2 then
            begin
              Arr[i][7]:=Arr[i][7]+FieldByName('qty').AsFloat;
              Arr[i][10]:=Arr[i][10]+FieldByName('amt').AsFloat;
            end;
          end;
          Next;
        end;

        Memo1.Lines.Add('正在查詢[廣州訂單未交]');
        Application.ProcessMessages;
        Close;
        SQL.Text:='exec [dbo].[proc_DLIR130_2] '+Quotedstr('ITEQGZ')+','+Quotedstr(fEndDate);
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;

        pb.Position:=0;
        pb.Max:=RecordCount;
        while not Eof do
        begin
          pb.Position:=pb.Position+1;
          Application.ProcessMessages;

          i:=GetArrIndex(FieldByName('ad').AsString);
          if i<>-1 then
          begin
            if FieldByName('type').AsInteger=1 then
            begin
              Arr[i][1]:=Arr[i][1]+FieldByName('qty').AsFloat;
              Arr[i][4]:=Arr[i][4]+FieldByName('amt').AsFloat;
            end
            else if FieldByName('type').AsInteger=2 then
            begin
              Arr[i][7]:=Arr[i][7]+FieldByName('qty').AsFloat;
              Arr[i][10]:=Arr[i][10]+FieldByName('amt').AsFloat;
            end;
          end;
          Next;
        end;

        Memo1.Lines.Add('正在查詢[寄售倉]');
        Application.ProcessMessages;
        Close;
        SQL.Text:='exec [dbo].[proc_DLIR130_3]';
        try
          Open;
        except
          on e: exception do
          begin
            Memo1.Lines.Add(e.Message);
            Exit;
          end;
        end;

        pb.Position:=0;
        pb.Max:=RecordCount;
        while not Eof do
        begin
          pb.Position:=pb.Position+1;
          Application.ProcessMessages;

          i:=GetArrIndex(FieldByName('ad').AsString);
          if i<>-1 then
          begin
            //寄售倉待本月扣帳部分＝(當前寄售倉庫存量-平均期末結存量)*94%（入帳率）
            //小於0時設為0
            js_qty:=0;
            js_amt:=0;
            if ADOQuery1.Locate('sno',i,[]) then
            begin
              if FieldByName('type').AsInteger=1 then
              begin
                js_qty:=ADOQuery1.FieldByName('js_cclqty').AsFloat;
                js_amt:=ADOQuery1.FieldByName('js_cclamt').AsFloat;
              end else if FieldByName('type').AsInteger=2 then
              begin
                js_qty:=ADOQuery1.FieldByName('js_ppqty').AsFloat;
                js_amt:=ADOQuery1.FieldByName('js_ppamt').AsFloat;
              end;
            end;

            js_qty:=Round((FieldByName('qty').AsFloat-js_qty)*0.94);
            if js_qty<0 then
               js_qty:=0;
            js_amt:=Round((FieldByName('amt').AsFloat-js_amt)*0.94);
            if js_amt<0 then
               js_amt:=0;

            if FieldByName('type').AsInteger=1 then
            begin
              Arr[i][1]:=Arr[i][1]+js_qty;
              Arr[i][4]:=Arr[i][4]+js_amt;
            end
            else if FieldByName('type').AsInteger=2 then
            begin
              Arr[i][7]:=Arr[i][7]+js_qty;
              Arr[i][10]:=Arr[i][10]+js_amt;
            end;
          end;
          Next;
        end;  //end 寄售倉庫
      end;    //end with adoquery2 do
    end;

    //匯出xls
    Memo1.Lines.Add('正在匯出xls');
    Application.ProcessMessages;
    ExcelApp.DisplayAlerts:=False;
    ExcelApp.WorkBooks.Open(l_path+xls);
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.Cells[1,2].Value:=IntToStr(y)+'年'+IntToStr(m)+'月 華南區硬板訂單狀況匯總表（By膠系） （Updated to:'+IntToStr(m)+'/'+IntToStr(d)+'）';
    for i:=0 to 20 do
    begin
      r:=i+5;
      ExcelApp.Cells[r,4].Value:=Arr[i][0];
      ExcelApp.Cells[r,5].Value:=Arr[i][1];
      ExcelApp.Cells[r,7].Value:=Arr[i][2];
      ExcelApp.Cells[r,9].Value:=Arr[i][3];
      ExcelApp.Cells[r,10].Value:=Arr[i][4];
      ExcelApp.Cells[r,12].Value:=Arr[i][5];
      ExcelApp.Cells[r,14].Value:=Arr[i][6];
      ExcelApp.Cells[r,15].Value:=Arr[i][7];
      ExcelApp.Cells[r,17].Value:=Arr[i][8];
      ExcelApp.Cells[r,19].Value:=Arr[i][9];
      ExcelApp.Cells[r,20].Value:=Arr[i][10];
      ExcelApp.Cells[r,22].Value:=Arr[i][11];
    end;
    if amt0=0 then
       ExcelApp.Cells[29,3].Value:=ExcelApp.Cells[29,3].Value+'0USD'
    else
       ExcelApp.Cells[29,3].Value:=ExcelApp.Cells[29,3].Value+FormatFloat('#,###',Round(amt0))+'USD';

    fPath:=l_path+'Temp\訂單狀況匯總表'+IntToStr(YearOf(Date-1));
    if not DirectoryExists(fPath) then
       CreateDir(fPath);

    xfname:='硬板訂單狀況匯總表（By膠系）'+RightStr(fEndDate,4);
    xfpath:=fPath+'\'+xfname+'.xlsx';
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

      //MailServer服務器
      MailIP:=ini.ReadString('MailServer','IP','');
      MailID:=ini.ReadString('MailServer','UID','');
      MailPW:=ini.ReadString('MailServer','PW','');
      l_mailFrom:=ini.ReadString('MailServer','FROMADDR','');

      l_mailTo:=ini.ReadString('DLIR130','TOADDR','');
      MailPW:=Decrypt(MailPW);
    finally
      ini.Free;
    end;
  end;

  ADOConn.ConnectionString:='Provider=SQLOLEDB.1;Password='+SQLPW+';Persist Security Info=True;User ID='+SQLUID+';Initial Catalog='+SQLDB+';Data Source='+SQLIP;
  IdSMTP1.Host:=MailIP;
  idsmtp1.AuthenticationType:=atLogin; //郵箱登錄驗證{atNone,atLogin}
  IdSMTP1.Username:=MailID;
  IdSMTP1.Password:=MailPW;

  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1);
  if LowerCase(s1)='dlir130' then //由ERPServer.exe啟動,Timer1延時10秒執行
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
