unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection, StrUtils,
  IdTCPClient, IdMessageClient, IdSMTP, IdMessage, Buttons, ExtCtrls, Menus,
  DB, ADODB, DateUtils, IdGlobal;

type
  TForm1 = class(TForm)
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
    Memo1: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    m1: TMenuItem;
    ADOConn: TADOConnection;
    ADOQuery1: TADOQuery;
    ADOQuery2: TADOQuery;
    test1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure test1Click(Sender: TObject);
  private
    l_path,l_date,l_stime:string;
    l_cocList:TStrings;
    function SendMail(xDate:TDateTime; xTime:string):Boolean;
    function GetSubject(xDate:TDateTime;Custom:string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.dfm}

//本機電腦名
function GetLocalComputerName:string;
var
  cpName:PChar;
  cpSize:DWord;
  cpBool:Boolean;
begin
  cpSize:=255;
  getmem(cpName,cpSize);
  cpBool:=GetComputerName(cpName,cpSize);
  if cpBool then
    Result:=StrPas(cpName)
  else
    Result:='';
  FreeMem(cpName,cpSize);
end;

procedure Searchfile(xPath: string; var SL:TStrings);
var
  ext: string;
  sr: TSearchRec;
  bo: integer;
begin
  SL.Clear;
  bo := FindFirst(xPath + '\' + '*.*', faAnyFile, sr);
  while bo = 0 do
  begin
    //if (sr.Name <> '.') and (sr.Name <> '..') and (sr.Attr <> faDirectory) then
    ext:=LowerCase(ExtractFileExt(sr.Name));
    if (ext='.pdf') or (ext='.xls') or (ext='.xlsx') then
       SL.Add(sr.Name);
    bo := FindNext(sr);
  end;
  FindClose(sr);
end;

function TForm1.GetSubject(xDate:TDateTime;Custom:string): string;
var
  str:string;
begin
  if Pos('深南',Custom)>0 then
  begin
    if pos('CCL',UpperCase(Custom))>0 then
       Result:='聯茂-CCL-'+FormatDateTime('YYYYMMDD',xDate)
    else
       Result:='聯茂-PP-'+FormatDateTime('YYYYMMDD',xDate);
  end else
  begin
    str:=StringReplace(FormatDateTime('YYYY-MM-DD',xDate),'/','-',[rfReplaceAll]);
    if Pos('華通',Custom)>0 then
       Result:=str+' ITEQ  COC'
    else if Pos('美銳',Custom)>0 then
       Result:=str+' ITEQ  CCL COC'
    else if Pos('廣合',Custom)>0 then
       Result:='ITEQ '+str+Custom+'出貨清單'
    else
       Result:='ITEQ '+str+Custom+'出貨COC';
  end;
end;

function TForm1.SendMail(xDate:TDateTime; xTime:string):Boolean;
var
  isBool:Boolean;
  i,j,iSize,totSize:Integer;
  tmpDir,tmpFilePath,tmpFileNameX,tmpFileNameY,
  fromAddress,toAddress,tmpBody,tmpLogMail,tmpCustom:string;
  fileList,logList:TStrings;
begin
  Result:=False;

  fileList:=TStringList.Create;
  logList:=TStringList.Create;
  try
    with ADOQuery1 do
    begin
      Close;
      SQL.Text:='select host,uid,pw,email,cocpath,resultemail from dli380 where bu=''ITEQDG''';
      try
        Open;
      except
        on e:exception do
        begin
          logList.Add('dli380 open error:');
          logList.Add(e.Message);
          Exit;
        end;
      end;
    end;

    with ADOQuery2 do
    begin
      Close;
      SQL.Text:='select custom,email from dli381 where bu=''ITEQDG'' and stime='+Quotedstr(xTime);
      try
        Open;
      except
        on e:exception do
        begin
          logList.Add('dli381 open error:');
          logList.Add(e.Message);
          Exit;
        end;
      end;
    end;

    if ADOQuery1.IsEmpty or ADOQuery2.IsEmpty then
    begin
      logList.Add(xTime+' empty');
      Exit;
    end;

    IdSMTP1.Host:=ADOQuery1.FieldByName('host').AsString;      //郵件服務器
    idsmtp1.AuthenticationType:=atLogin;                       //登錄驗證{atNone,atLogin}
    IdSMTP1.Username:=ADOQuery1.FieldByName('uid').AsString;   //帳號
    IdSMTP1.Password:=ADOQuery1.FieldByName('pw').AsString;    //密碼
    fromAddress:=ADOQuery1.FieldByName('email').AsString;      //發件人
    {(*}
    tmpBody:= 'Dear ALL：'+#13#10+'  本通知由外掛ERP系統自動發出，請勿回覆，若有疑問請聯絡相關人員，謝謝！'+
              '-------------------------------------------------------------------------------------'+
              'Confidentiality Statement: This email and its attachments are intended solely for the'+
              'intended recipient hereof and may contain legally privileged or other confidential   '+
              'information. Any unauthorized use or disclosure is prohibited. If you have received  '+
              'this email or its attachments in error, please destroy the original and any copies   '+
              'thereof and immediately notify the sender. Thanks.                                   '+
              '-------------------------------------------------------------------------------------';
    {*)}
    tmpDir:=ADOQuery1.FieldByName('cocpath').AsString;         //檔案存放目錄
    tmpLogMail:=ADOQuery1.FieldByName('resultemail').AsString; //發送日記文件郵箱
    try
      IdSMTP1.Disconnect;
      IdSMTP1.Connect;
      IdSMTP1.Authenticate;
    except
      on e:exception do
      begin
        logList.Add('connect error:');
        logList.Add(e.Message);
        Exit;
      end;
    end;

    if RightStr(tmpDir,1)<>'\' then
       tmpDir:=tmpDir+'\';
    while not ADOQuery2.Eof do
    begin
      tmpCustom:=Trim(ADOQuery2.Fields[0].AsString);
      toAddress:=Trim(ADOQuery2.Fields[1].AsString);
      if Length(toAddress)=0 then
      begin
        logList.Add(tmpCustom+' not address');
        ADOQuery2.Next;
        Continue;
      end;

      tmpFilePath:=tmpDir+tmpCustom+'\'+IntToStr(MonthOf(xDate))+'月\'+FormatDateTime('MMDD',xDate);
      Searchfile(tmpFilePath,fileList);
      logList.Add('begin send:'+tmpCustom+','+IntToStr(fileList.Count)+' files,'+DateTimeToStr(Now));

      //添加附件
      j:=0;
      while True do
      begin
        isBool:=False;
        iSize:=0;
        totSize:=0;
        IdMessage1.MessageParts.Clear;
        for i:=j to fileList.Count-1 do
        begin
          tmpFileNameX:=fileList.Strings[i];
          tmpFileNameY:=tmpFilePath+'\'+tmpFileNameX;
          if FileExists(tmpFileNameY) then
          begin
            try
              iSize:=Round(FileSizeByName(tmpFileNameY)/1024);
            except
              on e:Exception do
              begin
                logList.Add('file open error:');
                logList.Add(e.Message);
                Continue;
              end;
            end;

            if iSize>10240 then //單個文件>10M,不發送此文件
               Continue
            else begin
              if totSize+iSize>10240 then //累計大小>10M,分開發送
              begin
                isBool:=True;
                j:=i;
                Break;
              end else
              begin
                totSize:=totSize+iSize;
                TIdattachment.Create(IdMessage1.MessageParts,tmpFileNameY);
                logList.Add('send ready:'+tmpFileNameX);
              end;
            end;
          end else
          begin
            logList.Add('not exists');
            logList.Add(tmpFileNameY);
          end;
        end;

        if IdMessage1.MessageParts.Count>0 then
        begin
          IdMessage1.From.Address:=fromAddress;                                  //發件人
          IdMessage1.Recipients.EMailAddresses:=toAddress;                       //收件人
          IdMessage1.Subject:=GetSubject(xDate,tmpCustom);                       //郵件主旨
          IdMessage1.Body.Text:=tmpBody;                                         //郵件正文
          IdMessage1.Body.Add('');                                               //郵件正文
          IdMessage1.Body.Add(StringReplace(FormatDateTime('YYYY-MM-DD HH:NN:SS',Now),'/','-',[rfReplaceAll])); //郵件正文,時間
          try
            IdSMTP1.Send(IdMessage1);
            logList.Add('send complete.');
          except
            on e:exception do
            begin
              logList.Add('send error:');
              logList.Add(e.Message);
              Break;
            end;
          end;
        end;

        if not isBool then
           Break;
      end;

      logList.Add('end send:'+tmpCustom+','+DateTimeToStr(Now));
      logList.Add('');
      ADOQuery2.Next;
    end;

    Result:=True;
  finally
    tmpFilePath:=l_path+'Error';
    if not DirectoryExists(tmpFilePath) then
       CreateDir(tmpFilePath);

    tmpFilePath:=tmpFilePath+'\COC';
    if not DirectoryExists(tmpFilePath) then
       CreateDir(tmpFilePath);

    tmpFilePath:=tmpFilePath+'\'+FormatDateTime('YYYYMM',Date);
    if not DirectoryExists(tmpFilePath) then
       CreateDir(tmpFilePath);

    tmpFilePath:=tmpFilePath+'\'+FormatDateTime('YYYYMMDDHHNNSSZZZ',Now)+'.txt';
    logList.SaveToFile(tmpFilePath);
    if (Length(tmpLogMail)>0) and IdSMTP1.Connected then
    begin
      IdMessage1.MessageParts.Clear;
      if FileExists(tmpFilePath) then
         TIdattachment.Create(IdMessage1.MessageParts,tmpFilePath);
      IdMessage1.From.Address:=fromAddress;
      IdMessage1.Recipients.EMailAddresses:=tmpLogMail;
      IdMessage1.Subject:='ITEQ COC Email Log '+FormatDateTime('MMDD',xDate)+' '+xTime;
      IdMessage1.Body.Text:='fyi.';
      IdMessage1.Body.Add('');
      IdMessage1.Body.Add(DateTimeToStr(Now));
      try
        IdSMTP1.Send(IdMessage1);
      except
      end;
    end;
    Memo1.Lines.Assign(logList);
    ADOQuery1.Close;
    ADOQuery2.Close;
    ADOConn.Connected:=False;
    IdSMTP1.Disconnect;
    FreeAndNil(fileList);
    FreeAndNil(logList);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  s1,s2,s3,s4:string;
begin
  l_path:=ExtractFilePath(Application.ExeName);
  l_cocList:=TStringList.Create;
  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1); //coc
  s2:=Paramstr(2); //iteqdg
  s3:=Paramstr(3); //date
  s4:=Paramstr(4); //time

  if (LowerCase(s1)='coc') and ((Length(s4)=8) or SameText(s4,'test')) then //由ERPServer.exe啟動,Timer1延時10秒執行
  begin
    l_date:=s3;
    l_stime:=s4;
    Timer1.Enabled:=True;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if Assigned(l_cocList) then
     FreeAndNil(l_cocList);
end;

procedure TForm1.test1Click(Sender: TObject);
begin
  if Form2.ShowModal=mrOK then
     SendMail(Form2.dtp.Date, Trim(Form2.Edit1.Text));
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled:=False;
  if SendMail(StrToDate(l_date),l_stime) then
     Close
  else begin
    if SameText(l_stime,'test') then
       Close
    else begin
      Timer1.Interval:=300000; //5分鐘再次執行
      Timer1.Enabled:=True;
    end;
  end;
end;

end.
