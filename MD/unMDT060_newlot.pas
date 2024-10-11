unit unMDT060_newlot;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls, DB,
  DBClient, StrUtils, DateUtils;

type
  TFrmMDT060_newlot = class(TFrmSTDI051)
    Label1: TLabel;
    dtp: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo1: TMemo;
    btn_query: TBitBtn;
    btn_insert: TBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    CDS: TClientDataSet;
    Label5: TLabel;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    function GetNumLot(clot: string; num: Integer;
      var nlot: string): string;
    { Private declarations }
  public
    l_wono,l_machine:string;
    { Public declarations }
  end;

var
  FrmMDT060_newlot: TFrmMDT060_newlot;

implementation

uses unGlobal, unCommon;

const l_ora='ORACLE';

{$R *.dfm}

function TFrmMDT060_newlot.GetNumLot(clot:string; num:Integer;
  var nlot:string):string;
var
  ret,s1_6,s789,s10:string;
  i:Integer;
begin
  nlot:=clot;
  ret:='';
  if num>1 then
  begin
    i:=1;
    s1_6:=LeftStr(clot,6);
    s789:=Copy(clot,7,3);
    s10:=Copy(clot,10,1);
    while i<num do
    begin
      s789:=RightStr('00'+IntToStr(StrToInt(s789)+1),3);
      nlot:=s1_6 + s789 + s10;
      if Length(ret)>0 then
         ret:=ret+','+nlot
      else
         ret:=nlot;
      Inc(i);
    end;
  end;

  Result:=ret;
end;

procedure TFrmMDT060_newlot.FormCreate(Sender: TObject);
begin
  inherited;
  btn_ok.Caption:=CheckLang('儲存');
  dtp.Date:=Date;
end;

procedure TFrmMDT060_newlot.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Text:='1';
  Edit2.Text:='1';
  Edit3.Text:=l_wono;
  Edit4.Text:=l_machine;
end;

procedure TFrmMDT060_newlot.btn_queryClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
//  inherited;
  tmpSQL:='select tc_six03,tc_six04,nvl(tc_six05,0) as tc_six05,tc_six06,tc_six08'
         +' from '+g_UInfo^.BU+'.tc_six_file where tc_six01='+Quotedstr(l_wono);
  if not QueryBySQL(tmpSQL, Data, l_ora) then
     Exit;
  Memo1.Lines.Clear;
  CDS.Data:=Data;
  with CDS do
  while not Eof do
  begin
    Memo1.Lines.Add(FieldByName('tc_six03').AsString+','+
                    FieldByName('tc_six08').AsString+','+
                    FieldByName('tc_six04').AsString+','+
                    FieldByName('tc_six05').AsString+','+
                    FieldByName('tc_six06').AsString);
    Next;
  end;
end;

procedure TFrmMDT060_newlot.btn_insertClick(Sender: TObject);
var
  tmpSQL,fmtDate,s1,s2,s3,s45,s6,s_789,s10,slot,clot:string;
  cnt,demoNum,lotNum:Integer;
  Data:OleVariant;
begin
//  inherited;
  g_StatusBar.Panels[0].Text:=CheckLang('正在計算批號...');
  Application.ProcessMessages;
  try
    if dtp.Date<EncodeDate(2000,1,1) then
    begin
      ShowMsg('[%s]輸入錯誤',48,myStringReplace(Label1.Caption));
      dtp.SetFocus;
      Exit;
    end;

    demoNum:=StrToIntDef(Edit1.Text,0);
    if demoNum<1 then
    begin
      ShowMsg('[%s]輸入錯誤',48,myStringReplace(Label2.Caption));
      Edit1.SetFocus;
      Exit;
    end;

    lotNum:=StrToIntDef(Edit2.Text,0);
    if lotNum<1 then
    begin
      ShowMsg('[%s]輸入錯誤',48,myStringReplace(Label3.Caption));
      Edit2.SetFocus;
      Exit;
    end;

    fmtDate:=StringReplace(FormatDateTime(g_cShortDate1,dtp.Date),'-','/',[rfReplaceAll]);

    tmpSQL:='select distinct substr(sfa03,8,1) as f from '+g_UInfo^.BU+'.sfa_file'
           +' where sfa01='+Quotedstr(Edit3.Text)
           +' and sfa03 like ''1G%'' order by 1';
    if not QueryBySQL(tmpSQL, Data, l_ora) then
       Exit;

    CDS.Data:=Data;
    if CDS.IsEmpty then
    begin
      ShowMsg('工單號碼不存在'+Edit3.Text,48);
      Exit;
    end;
    s10:=CDS.Fields[0].AsString;

    if SameText(g_UInfo^.BU,'ITEQDG') then
       s1:='D'
    else
       s1:='G';

    s2:=RightStr(IntToStr(YearOf(dtp.Date)),1);
    s3:=IntToStr(MonthOf(dtp.Date));
    if s3='10' then
       s3:='A'
    else if s3='11' then
       s3:='B'
    else if s3='12' then
       s3:='C';
    s45:=RightStr('0'+IntToStr(DayOf(dtp.Date)),2);

    s6:=Edit4.Text;
    if s6='TR01' then
       s6:='A'
    else if s6='TR02' then
       s6:='B'
    else if s6='TR03' then
       s6:='C'
    else if s6='TR04' then
       s6:='D'
    else if s6='TR05' then
       s6:='E'
    else if s6='TR06' then
       s6:='F'
    else begin
      ShowMsg('機臺錯誤'+s6,48);
      Exit;
    end;

    Data:=null;
    tmpSQL:='select count(*) cnt from '+g_UInfo^.BU+'.tc_six_file'
           +' where tc_six01='+Quotedstr(Edit3.Text)
           +' and to_char(tc_six02,''YYYY/MM/DD'')='+Quotedstr(fmtDate);
    if not QueryOneCR(tmpSQL, Data, l_ora) then
       Exit;

    cnt:=StrToInt(VarToStr(Data));
    Data:=null;
    if cnt>0 then
       tmpSQL:='select max(tc_six04) as lot from '+g_UInfo^.BU+'.tc_six_file'
              +' where substr(tc_six04,1,6)='+Quotedstr(s1 + s2 + s3 + s45 + s6)
              +' and tc_six01 ='+Quotedstr(Edit3.Text)
              +' and to_char(tc_six02,''YYYY/MM/DD'')='+Quotedstr(fmtDate)
    else
       tmpSQL:='select max(tc_six04) as lot from '+g_UInfo^.BU+'.tc_six_file'
              +' where substr(tc_six04,1,6) ='+Quotedstr(s1 + s2 + s3 + s45 + s6);
    if not QueryBySQL(tmpSQL, Data, l_ora) then
       Exit;

    CDS.Data:=Data;
    if CDS.IsEmpty or (Length(CDS.Fields[0].AsString)=0) then
       s_789:= '011'
    else begin    
      s_789:=CDS.Fields[0].AsString;
      if cnt>0 then
      begin
        cnt:= StrToInt(Copy(s_789,7,3))+1;
        if cnt<100 then
           s_789:='0'+IntToStr(cnt)
        else
           s_789:=IntToStr(cnt);
      end else
      begin
        cnt:= StrToInt(Copy(s_789,7,2))+1;
        if cnt<10 then
           s_789:='0'+IntToStr(cnt)+'1'
        else
           s_789:=IntToStr(cnt)+'1';
      end;
    end;

    tmpSQL:=s1 + s2 + s3 + s45 + s6 + s_789 + s10; //第1個批號
    cnt:=1;
    slot:='';
    clot:=tmpSQL;
    while cnt<=demoNum do
    begin
      slot:=GetNumLot(cLot, lotNum, cLot);   //批號個數
      if Length(slot)>0 then
         tmpSQL:=tmpSQL+','+slot;
      //新樣流水號進10位   
      s_789:=RightStr('00'+IntToStr(StrToInt(copy(clot,7,2)+'1')+10),3);
      clot:=s1 + s2 + s3 + s45 + s6 + s_789 + s10;
      Inc(cnt);
      if cnt<=demoNum then
         tmpSQL:=tmpSQL+','+clot;
    end;
    Memo1.Lines.DelimitedText:=tmpSQL;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMDT060_newlot.btn_okClick(Sender: TObject);
var
  err:Boolean;
  i,num:Integer;
  s1,s2,s3,s45,s6,str,tmpSQL,fmtDate:string;
  Data:OleVariant;
begin
//  inherited;
  if Length(Trim(Memo1.Lines.Text))=0 then
  begin
    ShowMsg('請輸入批號!',48);
    Memo1.SetFocus;
    Exit;
  end;

  if SameText(g_UInfo^.BU,'ITEQDG') then
     s1:='D'
  else
     s1:='G';

  s2:=RightStr(IntToStr(YearOf(dtp.Date)),1);
  s3:=IntToStr(MonthOf(dtp.Date));
  if s3='10' then
     s3:='A'
  else if s3='11' then
     s3:='B'
  else if s3='12' then
     s3:='C';
  s45:=RightStr('0'+IntToStr(DayOf(dtp.Date)),2);

  s6:=Edit4.Text;
  if s6='TR01' then
     s6:='A'
  else if s6='TR02' then
     s6:='B'
  else if s6='TR03' then
     s6:='C'
  else if s6='TR04' then
     s6:='D'
  else if s6='TR05' then
     s6:='E'
  else if s6='TR06' then
     s6:='F'
  else begin
    ShowMsg('機臺錯誤'+s6,48);
    Exit;
  end;

  //檢查錯誤
  for i:=0 to Memo1.Lines.Count-1 do
  begin
    err:=False;
    str:=UpperCase(Memo1.Lines.Strings[i]);
    if Memo1.Lines.IndexOf(str)<>i then
    begin
      ShowMsg('第'+IntToStr(i+1)+'筆批號重複!',48);
      Memo1.SetFocus;
      Exit;
    end;

    if Length(str)<>10 then
       err:=True
    else if LeftStr(str,1)<>s1 then
       err:=True
    else if Copy(str,2,4)<>s2 + s3 + s45 then
       err:=True
    else if Copy(str,6,1)<>s6 then
       err:=True
    else begin
      try
        num:=StrToInt(Copy(str,7,3));
        if num<11 then
           err:=True;
      except
        err:=True;
      end;
    end;

    if err then
    begin
      ShowMsg('第'+IntToStr(i+1)+'個批號錯誤!',48);
      Memo1.SetFocus;
      Exit;
    end;

    tmpSQL:=tmpSQL+','+Quotedstr(str);
  end;

  g_StatusBar.Panels[0].Text:=CheckLang('正在檢查批號是否重複...');
  Application.ProcessMessages;
  try
    //檢查重復
    Delete(tmpSQL,1,1);
    tmpSQL:='select tc_six04 from '+g_UInfo^.BU+'.tc_six_file'
           +' where tc_six04 in (' + tmpSQL + ') and rownum=1';
    if not QueryBySQL(tmpSQL, Data, l_ora) then
       Exit;

    CDS.Data:=Data;
    if not CDS.IsEmpty then
    begin
      ShowMsg(CDS.Fields[0].AsString+'批號已存在!',48);
      Memo1.SetFocus;
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在儲存資料...');
    Application.ProcessMessages;

    //儲存
    fmtDate:=StringReplace(FormatDateTime(g_cShortDate1,dtp.Date),'-','/',[rfReplaceAll]);
    Data:=null;
    tmpSQL:='select nvl(max(tc_six03),0) as sno from '+g_UInfo^.BU+'.tc_six_file'
           +' where tc_six01 ='+Quotedstr(Edit3.Text)
           +' and to_char(tc_six02,''YYYY/MM/DD'')='+Quotedstr(fmtDate);
    if not QueryBySQL(tmpSQL, Data, l_ora) then
       Exit;

    CDS.Data:=Data;
    num:=CDS.Fields[0].AsInteger+1;

    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_six_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, l_ora) then
       Exit;

    CDS.Data:=Data;
    for i:=0 to Memo1.Lines.Count-1 do
    begin
      CDS.Append;
      CDS.FieldByName('tc_six01').AsString:=Edit3.Text;
      CDS.FieldByName('tc_six02').AsDateTime:=dtp.Date;
      CDS.FieldByName('tc_six03').AsInteger:=num;
      CDS.FieldByName('tc_six04').AsString:=UpperCase(Memo1.Lines.Strings[i]);
      CDS.FieldByName('tc_six05').AsFloat:=0;
      CDS.FieldByName('tc_six06').AsString:='N';
      CDS.FieldByName('tc_six08').AsString:=Edit4.Text;
      CDS.Post;
      Inc(num);
    end;
    if CDSPost(CDS, 'tc_six_file', l_ora) then
       ShowMsg('儲存完畢!',48);
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
