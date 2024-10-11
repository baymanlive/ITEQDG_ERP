{*******************************************************}
{                                                       }
{                DLIR220.exe                            }
{                Author: kaikai                         }
{                Create date: 2019/12/12                }
{                Description: �q��_�ͺޱƥ�ѼƤ��R��   }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, ADODB, Menus, ExtCtrls, DBClient, DateUtils, Math,
  ExcelXP, Provider, ComCtrls, IdMessage, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdMessageClient, IdSMTP, IniFiles;

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
    DataSetProvider1: TDataSetProvider;
    CDS: TClientDataSet;
    pb: TProgressBar;
    IdSMTP1: TIdSMTP;
    IdMessage1: TIdMessage;
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

const lstxml='</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

{$R *.dfm}

//�ѱK
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

//�K�[���~�H����O�����
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
const maxcol=90;
var
  i,maxday,cnt,num,row,col,tmpNum,aIndex,sIndex,cIndex:Integer;
  tot:Double;
  endDate,fmdate,todate,d1,d2:TDateTime;
  xml2,xml3,xml4,xml5,fname,lblDate:string;
  tmpSQL,strd1,strd2,fPath:string;
  srcCDS,destCDS2,destCDS3,destCDS4,destCDS5:TClientDataSet;
  arrList1,arrList2,arrList3,arrList4,arrList5:Array of TObj;
  Arr:array[1..260] of string;
  tmpAd,tmpSalename,tmpCustno:string;
  ExcelApp:Variant;
begin
  xfname:='';
  xfpath:='';
  Result:=False;
  Memo1.Clear;
  Memo1.Lines.Add('�q��_�ͺޱƥ�ѼƤ��R��');
  Memo1.Lines.Add('begin rpt');
  try
    ExcelApp:=CreateOleObject('Excel.Application');
  except
    Memo1.Lines.Add('�Ы�Excel����');
    LogInfo(Memo1.Text);
    Exit;
  end;

  xml2:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="avg" fieldtype="r8"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml3:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml4:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  xml5:='<?xml version="1.0" standalone="yes"?>'
       +'<DATAPACKET Version="2.0">'
       +'<METADATA><FIELDS>'
       +'<FIELD attrname="salename" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
       +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="ftype" fieldtype="string" WIDTH="20"/>'
       +'<FIELD attrname="avg" fieldtype="r8"/>'
       +'<FIELD attrname="not" fieldtype="i4"/>';

  srcCDS:=TClientDataSet.Create(nil);
  destCDS2:=TClientDataSet.Create(nil);
  destCDS3:=TClientDataSet.Create(nil);
  destCDS4:=TClientDataSet.Create(nil);
  destCDS5:=TClientDataSet.Create(nil);
  try
    CDS.Tag:=1;
    endDate:=Date-1;     //�s�I�L�Z����,���W�@��
    fmdate:=endDate-30;  //�e��1�Ӥ�  EncodeDate(YearOf(endDate),MonthOf(endDate),1); 1��
    todate:=endDate;
    d1:=fmdate;
    d2:=fmdate;
    lblDate:='�q����:'+DateToStr(fmdate)+'~'+DateToStr(todate);
    while d2<=todate do
    begin
      d2:=d1+4;
      if d2>todate then
         d2:=todate;

      strd1:=StringReplace(FormatDateTime('YYYY/MM/DD',d1),'-','/',[rfReplaceAll]);
      strd2:=StringReplace(FormatDateTime('YYYY/MM/DD',d2),'-','/',[rfReplaceAll]);
      Memo1.Lines.Add('���b�d��:'+strd1+'~'+strd2);
      Application.ProcessMessages;
      CDS.Active:=False;
      ADOQuery1.Close;
      ADOQuery1.SQL.Text:='exec [dbo].[proc_DLIR220] '+Quotedstr('ITEQDG')+','+Quotedstr(strd1)+','+Quotedstr(strd2);
      try
        ADOQuery1.Open;
      except
        on e:Exception do
        begin
          Memo1.Lines.Add(e.Message);
          Exit;
        end;
      end;
      CDS.Active:=True;

      if CDS.Tag=1 then
      begin
        srcCDS.Data:=CDS.Data;
        CDS.Tag:=0;
      end
      else if not CDS.IsEmpty then
        srcCDS.AppendData(CDS.Data,True);

      d1:=d2+1;
      d2:=d1;
    end;

    if srcCDS.IsEmpty then
    begin
      Memo1.Lines.Add('�L���');
      Exit;
    end;

    Memo1.Lines.Add('���b�έp����');
    Application.ProcessMessages;

    SetLength(arrList1,19); //srcCDS.FieldCount
    arrList1[0].FieldName:='ftype';       arrList1[0].Caption:='���~�O';
    arrList1[1].FieldName:='ad';          arrList1[1].Caption:='���t';
    arrList1[2].FieldName:='orderdate';   arrList1[2].Caption:='�q����';
    arrList1[3].FieldName:='custno';      arrList1[3].Caption:='�b�ګȤ�';
    arrList1[4].FieldName:='custshort';   arrList1[4].Caption:='�Ȥ�²��';
    arrList1[5].FieldName:='salename';    arrList1[5].Caption:='�~��';
    arrList1[6].FieldName:='orderno';     arrList1[6].Caption:='�q�渹�X';
    arrList1[7].FieldName:='orderitem';   arrList1[7].Caption:='����';
    arrList1[8].FieldName:='pno';         arrList1[8].Caption:='�Ƹ�';
    arrList1[9].FieldName:='pname';       arrList1[9].Caption:='�~�W';
    arrList1[10].FieldName:='sizes';      arrList1[10].Caption:='�W��';
    arrList1[11].FieldName:='qty';        arrList1[11].Caption:='�ƶq';
    arrList1[12].FieldName:='units';      arrList1[12].Caption:='���';
    arrList1[13].FieldName:='confdate';   arrList1[13].Caption:='�T�{���';
    arrList1[14].FieldName:='adate';      arrList1[14].Caption:='����T�{���';
    arrList1[15].FieldName:='mpsdate';    arrList1[15].Caption:='�ͺޱƩw�F����';
    arrList1[16].FieldName:='diffday1';   arrList1[16].Caption:='�ƥ�Ѽ�';
    arrList1[17].FieldName:='custdate';   arrList1[17].Caption:='���q��f��';
    arrList1[18].FieldName:='diffday2';   arrList1[18].Caption:='�ƥ�O���Ѽ�';

    //�K�[�䥦���D
    srcCDS.Filtered:=False;
    srcCDS.Filter:='diffday1>0';
    srcCDS.Filtered:=True;
    srcCDS.IndexFieldNames:='diffday1';
    srcCDS.Last;
    if srcCDS.FieldByName('diffday1').IsNull then
       maxday:=-1
    else if srcCDS.FieldByName('diffday1').AsFloat=0.16 then
       maxday:=0
    else
       maxday:=srcCDS.FieldByName('diffday1').AsInteger;
    if maxday>maxcol then
       maxday:=maxcol;

    if maxday=-1 then
    begin
      SetLength(arrList2,4);
      SetLength(arrList3,5);
      SetLength(arrList4,2);
    end else
    begin
      SetLength(arrList2,5+maxday); //0.16
      SetLength(arrList3,6+maxday);
      SetLength(arrList4,3+maxday);
    end;

    arrList2[0].FieldName:='ad';        arrList2[0].Caption:='���t';
    arrList2[1].FieldName:='ftype';     arrList2[1].Caption:='���~�O';
    arrList2[2].FieldName:='avg';       arrList2[2].Caption:='�����ƥ�Ѽ�';
    arrList2[3].FieldName:='not';       arrList2[3].Caption:='���ƥ�';

    arrList3[0].FieldName:='salename';  arrList3[0].Caption:='�~��';
    arrList3[1].FieldName:='custshort'; arrList3[1].Caption:='�Ȥ�²��';
    arrList3[2].FieldName:='ad';        arrList3[2].Caption:='���t';
    arrList3[3].FieldName:='ftype';     arrList3[3].Caption:='���~�O';
    arrList3[4].FieldName:='not';       arrList3[4].Caption:='���ƥ�';

    arrList4[0].FieldName:='salename';  arrList4[0].Caption:='�~��';
    arrList4[1].FieldName:='not';       arrList4[1].Caption:='���ƥ�';

    for i:=0 to maxday do
    begin
      fname:='cnt'+IntToStr(i);
      xml2:=xml2+'<FIELD attrname="'+fname+'" fieldtype="i4"/>';
      xml3:=xml3+'<FIELD attrname="'+fname+'" fieldtype="i4"/>';
      xml4:=xml4+'<FIELD attrname="'+fname+'" fieldtype="i4"/>';

      arrList2[i+4].FieldName:=fname;
      arrList3[i+5].FieldName:=fname;
      arrList4[i+2].FieldName:=fname;
      if i=0 then
      begin
        arrList2[i+4].Caption:='0.16';
        arrList3[i+5].Caption:='0.16';
        arrList4[i+2].Caption:='0.16';
      end else
      begin
        arrList2[i+4].Caption:=IntToStr(i);
        arrList3[i+5].Caption:=IntToStr(i);
        arrList4[i+2].Caption:=IntToStr(i);
      end
    end;

    if maxday=maxcol then
    begin
      arrList2[High(arrList2)].Caption:='��'+IntToStr(maxcol);
      arrList3[High(arrList3)].Caption:='��'+IntToStr(maxcol);
      arrList4[High(arrList4)].Caption:='��'+IntToStr(maxcol);
    end;

    srcCDS.Filtered:=False;
    srcCDS.Filter:='diffday2>0';
    srcCDS.Filtered:=True;
    srcCDS.IndexFieldNames:='diffday2';
    srcCDS.Last;
    maxday:=srcCDS.FieldByName('diffday2').AsInteger;
    if maxday>maxcol then
       maxday:=maxcol;

    SetLength(arrList5,6+maxday);
    arrList5[0].FieldName:='salename';  arrList5[0].Caption:='�~��';
    arrList5[1].FieldName:='custshort'; arrList5[1].Caption:='�Ȥ�²��';
    arrList5[2].FieldName:='ad';        arrList5[2].Caption:='���t';
    arrList5[3].FieldName:='ftype';     arrList5[3].Caption:='���~�O';
    arrList5[4].FieldName:='avg';       arrList5[4].Caption:='�����F��O�ɤѼ�';
    arrList5[5].FieldName:='not';       arrList5[5].Caption:='���ƥ�';

    for i:=1 to maxday do
    begin
      fname:='cnt'+IntToStr(i);
      col:=5+i;
      xml5:=xml5+'<FIELD attrname="'+fname+'" fieldtype="i4"/>';
      arrList5[col].FieldName:=fname;
      arrList5[col].Caption:=IntToStr(i);
    end;

    if maxday=maxcol then
       arrList5[High(arrList5)].Caption:='��'+IntToStr(maxcol);

    InitCDS(destCDS2,xml2+lstxml);
    InitCDS(destCDS3,xml3+lstxml);
    InitCDS(destCDS4,xml4+lstxml);
    InitCDS(destCDS5,xml5+lstxml);

    srcCDS.Filtered:=False;
    srcCDS.First;
    pb.Position:=0;
    pb.Max:=srcCDS.RecordCount;
    pb.Visible:=True;
    while not srcCDS.Eof do
    begin
      pb.Position:=pb.Position+1;
      Application.ProcessMessages;

      //destCDS2
      if destCDS2.Locate('ad;ftype',
          VarArrayOf([srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS2.Edit
      else begin
        destCDS2.Append;
        destCDS2.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS2.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //�ƥ�Ѽ�,���ƥ�
         destCDS2.FieldByName('not').AsInteger:=destCDS2.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //�ƥ�Ѽ�,�w�ƥ�,0.16��bcnt0,�䥦�������
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS2.FieldByName(fname).AsInteger:=destCDS2.FieldByName(fname).AsInteger+1;
      end;
      destCDS2.Post;

      //destCDS3
      if destCDS3.Locate('salename;custno;ad;ftype',
          VarArrayOf([srcCDS.FieldByName('salename').AsString,
                      srcCDS.FieldByName('custno').AsString,
                      srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS3.Edit
      else begin
        destCDS3.Append;
        destCDS3.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
        destCDS3.FieldByName('custno').AsString:=srcCDS.FieldByName('custno').AsString;
        destCDS3.FieldByName('custshort').AsString:=srcCDS.FieldByName('custshort').AsString;
        destCDS3.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS3.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //�ƥ�Ѽ�,���ƥ�
         destCDS3.FieldByName('not').AsInteger:=destCDS3.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //�ƥ�Ѽ�,�w�ƥ�,0.16��bcnt0,�䥦�������
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS3.FieldByName(fname).AsInteger:=destCDS3.FieldByName(fname).AsInteger+1;
      end;
      destCDS3.Post;

      //destCDS4
      if destCDS4.Locate('salename',srcCDS.FieldByName('salename').AsString,[]) then
         destCDS4.Edit
      else begin
        destCDS4.Append;
        destCDS4.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then         //�ƥ�Ѽ�,���ƥ�
         destCDS4.FieldByName('not').AsInteger:=destCDS4.FieldByName('not').AsInteger+1
      else begin
        if srcCDS.FieldByName('diffday1').AsFloat=0.16 then //�ƥ�Ѽ�,�w�ƥ�,0.16��bcnt0,�䥦�������
           fname:='cnt0'
        else if srcCDS.FieldByName('diffday1').AsInteger>maxcol then
           fname:='cnt'+IntToStr(maxcol)
        else
           fname:='cnt'+IntToStr(srcCDS.FieldByName('diffday1').AsInteger);
        destCDS4.FieldByName(fname).AsInteger:=destCDS4.FieldByName(fname).AsInteger+1;
      end;
      destCDS4.Post;

      //destCDS5
      if destCDS5.Locate('salename;custno;ad;ftype',
          VarArrayOf([srcCDS.FieldByName('salename').AsString,
                      srcCDS.FieldByName('custno').AsString,
                      srcCDS.FieldByName('ad').AsString,
                      srcCDS.FieldByName('ftype').AsString]),[]) then
        destCDS5.Edit
      else begin
        destCDS5.Append;
        destCDS5.FieldByName('salename').AsString:=srcCDS.FieldByName('salename').AsString;
        destCDS5.FieldByName('custno').AsString:=srcCDS.FieldByName('custno').AsString;
        destCDS5.FieldByName('custshort').AsString:=srcCDS.FieldByName('custshort').AsString;
        destCDS5.FieldByName('ad').AsString:=srcCDS.FieldByName('ad').AsString;
        destCDS5.FieldByName('ftype').AsString:=srcCDS.FieldByName('ftype').AsString;
      end;

      if srcCDS.FieldByName('diffday1').IsNull then      //�ƥ�Ѽ�,���ƥ�
      begin
        num:=1;
        destCDS5.FieldByName('not').AsInteger:=destCDS5.FieldByName('not').AsInteger+1;
      end else
      begin
        num:=srcCDS.FieldByName('diffday2').AsInteger;   //�O���Ѽ�
        if num>0 then
        begin
          if num>maxcol then
             fname:='cnt'+IntToStr(maxcol)
          else
             fname:='cnt'+IntToStr(num);
          destCDS5.FieldByName(fname).AsInteger:=destCDS5.FieldByName(fname).AsInteger+1;
        end;
      end;
      if num>0 then
         destCDS5.Post
      else
         destCDS5.Cancel;

      srcCDS.Next;
    end;

    //destCDS2�p��avg
    with destCDS2 do
    begin
      First;
      pb.Position:=0;
      pb.Max:=destCDS2.RecordCount+destCDS5.RecordCount;
      while not Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        tot:=0; //sum(����*�Ѽ�)
        cnt:=FieldByName('not').AsInteger; //sum(����)
        for i:=4 to High(arrList2) do
        begin
          num:=i-4;
          fname:='cnt'+FloatToStr(num);
          if FieldByName(fname).AsInteger>0 then
          begin
            if num=0 then
               tot:=tot+FieldByName(fname).AsInteger*0.16
            else
               tot:=tot+FieldByName(fname).AsInteger*num;
            cnt:=cnt+FieldByName(fname).AsInteger;
          end;
        end;

        Edit;
        FieldByName('avg').AsFloat:=RoundTo(tot/cnt,-2);
        Post;
        Next;
      end;
    end;

    //destCDS5�p��avg
    with destCDS5 do
    begin
      First;
      //g_ProgressBar.Position:=0;
      //g_ProgressBar.Max:=destCDS5.RecordCount; //destCDS2�w�֭p
      while not Eof do
      begin
        pb.Position:=pb.Position+1;
        Application.ProcessMessages;

        tot:=0; //sum(����*�Ѽ�)
        cnt:=FieldByName('not').AsInteger; //sum(����)
        for i:=6 to High(arrList5) do
        begin
          num:=i-5;
          fname:='cnt'+IntToStr(num);
          if FieldByName(fname).AsInteger>0 then
          begin
            tot:=tot+FieldByName(fname).AsInteger*num;
            cnt:=cnt+FieldByName(fname).AsInteger;
          end;
        end;

        Edit;
        if cnt>0 then
           FieldByName('avg').AsFloat:=RoundTo(tot/cnt,-2)
        else
           FieldByName('avg').AsFloat:=0;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='avg=0';
      Filtered:=True;
      while not IsEmpty do
        Delete;
      Filtered:=False;
    end;

    if destCDS2.ChangeCount>0 then
       destCDS2.MergeChangeLog;
    destCDS2.IndexFieldNames:='ad;ftype';

    if destCDS3.ChangeCount>0 then
       destCDS3.MergeChangeLog;
    destCDS3.IndexFieldNames:='salename;custno;ad;ftype';

    if destCDS4.ChangeCount>0 then
       destCDS4.MergeChangeLog;
    destCDS4.IndexFieldNames:='salename';

    if destCDS5.ChangeCount>0 then
       destCDS5.MergeChangeLog;
    destCDS5.IndexFieldNames:='salename;custno;ad;ftype';

    Memo1.Lines.Add('�ץXxls');
    Application.ProcessMessages;
    
    //��l��excel�C�r��
    for i:=1 to length(Arr) do
    begin
      if i<=26 then
         Arr[i]:=chr(64+i)
      else begin
        aIndex:=i;
        tmpNum:=0;
        while aIndex>26 do
        begin
          aIndex:=aIndex-26;
          Inc(tmpNum);
        end;
        Arr[i]:=chr(64+tmpNum)+chr(64+aIndex);
      end;
    end;

    ExcelApp.DisplayAlerts:=False;

    //�ץX5�Ӫ�
    ExcelApp.WorkBooks.Add;
    while ExcelApp.WorkSheets.Count >1 do
    begin
      ExcelApp.WorkSheets[1].Select;
      ExcelApp.WorkSheets[1].Delete;
    end;

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[1]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[2]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[3]);

    ExcelApp.WorkSheets[1].Select;
    ExcelApp.WorkSheets[1].Copy(After:=ExcelApp.WorkSheets[4]);

    Memo1.Lines.Add('���b�ץX[�ѼƲέp��]');
    Application.ProcessMessages;
    
    //CDS2�ѼƲέp��
    ExcelApp.WorkSheets[1].Activate;
    ExcelApp.ActiveSheet.Name:='�ѼƲέp��';
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[3].NumberFormat:='@';
    //��1��
    col:=High(arrList2)+1;
    ExcelApp.ActiveSheet.Cells[1,1].Value:='�q��_�ͺޱƥ�ѼƤ��R��';
    ExcelApp.ActiveSheet.Range['A1'].Select;
    ExcelApp.Selection.Font.Color:=RGB(70,130,193);
    ExcelApp.Selection.Font.Size:=20;
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Merge;
    //��2��
    ExcelApp.ActiveSheet.Cells[2,1].Value:=lblDate;
    ExcelApp.ActiveSheet.Range['A2:B2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[2,3].Value:='(�Ѽ�*����)/�`����';
    ExcelApp.ActiveSheet.Range['C2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[2,4].Value:='����';
    ExcelApp.ActiveSheet.Range['D2:'+Arr[col]+'2'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[2].RowHeight:=30;
    //��3����D
    for i:=Low(arrList2) to High(arrList2) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[3,col].Value:=arrList2[i].Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      ExcelApp.ActiveSheet.Range[Arr[col]+'3:'+Arr[col]+'3'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A3:'+Arr[col]+'3'].interior.ColorIndex:=34;
    //�ץX
    PB.Position:=0;
    PB.Max:=destCDS2.RecordCount;
    row:=3;
    aIndex:=4;
    destCDS2.First;
    while not destCDS2.Eof do
    begin
      Inc(row);
      PB.Position:=PB.Position+1;
      Application.ProcessMessages;

      for i:=Low(arrList2) to High(arrList2) do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=destCDS2.FieldByName(arrList2[i].FieldName).Value;

      tmpAd:=destCDS2.FieldByName('ad').AsString;
      destCDS2.Next;
      if destCDS2.Eof or (tmpAd<>destCDS2.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(aIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;
    end;
    //�ᵲ�e3�C
    ExcelApp.ActiveSheet.Range['A4'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    Memo1.Lines.Add('���b�ץX[�ѼƲέp��by�~��]');
    Application.ProcessMessages;

    //CDS3�ѼƲέp��by�~��
    ExcelApp.WorkSheets[2].Activate;
    ExcelApp.ActiveSheet.Name:='�ѼƲέp��by�~��';
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //��1��
    col:=High(arrList3)+1;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=lblDate;
    ExcelApp.ActiveSheet.Range['A1:D1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Cells[1,5].Value:='����';
    ExcelApp.ActiveSheet.Range['E1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //��2����D
    for i:=Low(arrList3) to High(arrList3) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=arrList3[i].Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //�ץX
    PB.Position:=0;
    PB.Max:=destCDS3.RecordCount;
    row:=2;
    aIndex:=3;
    sIndex:=3;
    cIndex:=3;
    destCDS3.First;
    while not destCDS3.Eof do
    begin
      Inc(row);
      PB.Position:=PB.Position+1;
      Application.ProcessMessages;

      for i:=Low(arrList3) to High(arrList3) do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=destCDS3.FieldByName(arrList3[i].FieldName).Value;

      tmpSalename:=destCDS3.FieldByName('salename').AsString;
      tmpCustno:=destCDS3.FieldByName('custno').AsString;
      tmpAd:=destCDS3.FieldByName('ad').AsString;
      destCDS3.Next;
      if destCDS3.Eof or (tmpSalename+'@'+tmpCustno+'@'+tmpAd<>destCDS3.FieldByName('salename').AsString+'@'+
                                                               destCDS3.FieldByName('custno').AsString+'@'+
                                                               destCDS3.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['C'+IntToStr(aIndex)+':C'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;

      if destCDS3.Eof or (tmpSalename+'@'+tmpCustno<>destCDS3.FieldByName('salename').AsString+'@'+destCDS3.FieldByName('custno').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['B'+IntToStr(cIndex)+':B'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        cIndex:=row+1;
        aIndex:=cIndex;
      end;

      if destCDS3.Eof or (tmpSalename<>destCDS3.FieldByName('salename').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(sIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        sIndex:=row+1;
        aIndex:=sIndex;
        cIndex:=sIndex;
      end;
    end;
    //�ᵲ�e3�C
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    Memo1.Lines.Add('���b�ץX[sales���R��]');
    Application.ProcessMessages;

    //CDS4 sales���R��
    ExcelApp.WorkSheets[3].Activate;
    ExcelApp.ActiveSheet.Name:='sales���R��';
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //��1��
    col:=High(arrList4)+1;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=lblDate;
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //��2����D
    for i:=Low(arrList4) to High(arrList4) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=arrList4[i].Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //�ץX
    PB.Position:=0;
    PB.Max:=destCDS4.RecordCount;
    row:=2;
    destCDS4.First;
    while not destCDS4.Eof do
    begin
      Inc(row);
      PB.Position:=PB.Position+1;
      Application.ProcessMessages;

      for i:=Low(arrList4) to High(arrList4) do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=destCDS4.FieldByName(arrList4[i].FieldName).Value;

      destCDS4.Next;
    end;
    //�[�`
    aIndex:=row+1;
    for i:=Low(arrList4) to High(arrList4) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[aIndex,col].Value:='=sum('+Arr[col]+'3:'+Arr[col]+IntToStr(row)+')';
    end;
    ExcelApp.ActiveSheet.Cells[aIndex,1].Value:='�`�p';
    //�ᵲ�e3�C
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    Memo1.Lines.Add('���b�ץX[�Ȥ�ƥ�O����]');
    Application.ProcessMessages;

    //CDS5�Ȥ�ƥ�O����
    ExcelApp.WorkSheets[4].Activate;
    ExcelApp.ActiveSheet.Name:='�Ȥ�ƥ�O����';
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //��1��
    col:=High(arrList5)+1;
    ExcelApp.ActiveSheet.Cells[1,1].Value:=lblDate;
    ExcelApp.ActiveSheet.Range['A1:D1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[1,5].Value:='(�Ѽ�*����)/�`����';
    ExcelApp.ActiveSheet.Range['E1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.WrapText:=True;
    ExcelApp.ActiveSheet.Cells[1,6].Value:='����';
    ExcelApp.ActiveSheet.Range['F1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.Selection.HorizontalAlignment:=xlCenter;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //��2����D
    for i:=Low(arrList5) to High(arrList5) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=arrList5[i].Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //�ץX
    PB.Position:=0;
    PB.Max:=destCDS5.RecordCount;
    row:=2;
    aIndex:=3;
    sIndex:=3;
    cIndex:=3;
    destCDS5.First;
    while not destCDS5.Eof do
    begin
      Inc(row);
      PB.Position:=PB.Position+1;
      Application.ProcessMessages;

      for i:=Low(arrList5) to High(arrList5) do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=destCDS5.FieldByName(arrList5[i].FieldName).Value;

      tmpSalename:=destCDS5.FieldByName('salename').AsString;
      tmpCustno:=destCDS5.FieldByName('custno').AsString;
      tmpAd:=destCDS5.FieldByName('ad').AsString;
      destCDS5.Next;
      if destCDS5.Eof or (tmpSalename+'@'+tmpCustno+'@'+tmpAd<>destCDS5.FieldByName('salename').AsString+'@'+
                                                               destCDS5.FieldByName('custno').AsString+'@'+
                                                               destCDS5.FieldByName('ad').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['C'+IntToStr(aIndex)+':C'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        aIndex:=row+1;
      end;

      if destCDS5.Eof or (tmpSalename+'@'+tmpCustno<>destCDS5.FieldByName('salename').AsString+'@'+destCDS5.FieldByName('custno').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['B'+IntToStr(cIndex)+':B'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        cIndex:=row+1;
        aIndex:=cIndex;
      end;

      if destCDS5.Eof or (tmpSalename<>destCDS5.FieldByName('salename').AsString) then
      begin
        ExcelApp.ActiveSheet.Range['A'+IntToStr(sIndex)+':A'+IntToStr(row)].Select;
        ExcelApp.Selection.Merge;
        sIndex:=row+1;
        aIndex:=sIndex;
        cIndex:=sIndex;
      end;
    end;
    //�ᵲ�e3�C
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    Memo1.Lines.Add('���b�ץX[�F����Ӫ�]');
    Application.ProcessMessages;

    //CDS �F����Ӫ�
    ExcelApp.WorkSheets[5].Activate;
    ExcelApp.ActiveSheet.Name:='�F����Ӫ�';
    ExcelApp.ActiveSheet.Rows[1].NumberFormat:='@';
    ExcelApp.ActiveSheet.Rows[2].NumberFormat:='@';
    //��1��
    col:=High(arrList1)+1;
    ExcelApp.ActiveSheet.Cells[1,1].Value:='�F����Ӫ�';
    ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+'1'].Select;
    ExcelApp.Selection.Font.Size:=10;
    ExcelApp.Selection.Merge;
    ExcelApp.ActiveSheet.Rows[1].RowHeight:=30;
    //��2����D
    for i:=Low(arrList1) to High(arrList1) do
    begin
      col:=i+1;
      ExcelApp.ActiveSheet.Cells[2,col].Value:=arrList1[i].Caption;
      ExcelApp.ActiveSheet.Columns[col].Font.Size:=10;
      if Pos('��',arrList1[i].Caption)>0 then
         ExcelApp.ActiveSheet.Columns[col].NumberFormat:='yyyy'+DateSeparator+'m'+DateSeparator+'d';
      ExcelApp.ActiveSheet.Range[Arr[col]+'2:'+Arr[col]+'2'].HorizontalAlignment:=xlCenter;
    end;
    ExcelApp.ActiveSheet.Range['A2:'+Arr[col]+'2'].interior.ColorIndex:=34;
    //�ץX
    PB.Position:=0;
    PB.Max:=srcCDS.RecordCount;
    row:=2;
    srcCDS.IndexFieldNames:='orderdate;orderno;orderitem';
    srcCDS.First;
    while not srcCDS.Eof do
    begin
      Inc(row);
      PB.Position:=PB.Position+1;
      Application.ProcessMessages;

      for i:=Low(arrList1) to High(arrList1) do
        ExcelApp.ActiveSheet.Cells[row,i+1].Value:=srcCDS.FieldByName(arrList1[i].FieldName).Value;

      srcCDS.Next;
    end;
    //�ᵲ�e3�C
    ExcelApp.ActiveSheet.Range['A3'].Select;
    ExcelApp.ActiveWindow.FreezePanes:=True;

    //�վ�excel�榡
    for i:=ExcelApp.WorkSheets.Count downto 1 do
    begin
      ExcelApp.WorkSheets[i].Activate;
      ExcelApp.ActiveSheet.Columns.EntireColumn.AutoFit;
      col:=ExcelApp.ActiveSheet.Usedrange.columns.count;
      row:=ExcelApp.ActiveSheet.Usedrange.Rows.count;
      //��ؽu
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders.LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.ActiveSheet.Range['A1:'+Arr[col]+IntToStr(row)].Borders[xlInsideHorizontal].Weight:=xlThin;
    end;

    fPath:=l_path+'Temp';
    if not DirectoryExists(fPath) then
       if not CreateDir(fPath) then
       begin
         Memo1.Lines.Add('�Ыإؿ�����');
         Exit;
       end;

    fPath:=l_path+'Temp\�q��_�ͺޱƥ�ѼƤ��R��'+IntToStr(YearOf(endDate));
    if not DirectoryExists(fPath) then
       if not CreateDir(fPath) then
       begin
         Memo1.Lines.Add('�Ыإؿ�����');
         Exit;
       end;

    xfname:='�q��_�ͺޱƥ�ѼƤ��R��'+FormatDateTime('MMDD',endDate);
    xfpath:=fPath+'\'+xfname+'.xlsx';
    ExcelApp.WorkSheets[1].SaveAs(xfpath);
    Memo1.Lines.Add('end rpt');
    Result:=True;
    
  finally
    SetLength(arrList1,0);
    SetLength(arrList2,0);
    SetLength(arrList3,0);
    SetLength(arrList4,0);
    SetLength(arrList5,0);
    FreeAndNil(srcCDS);
    FreeAndNil(destCDS2);
    FreeAndNil(destCDS3);
    FreeAndNil(destCDS4);
    FreeAndNil(destCDS5);
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
    msg:='�o�e�H�α����H���]�w';
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
      msg:='�l�c�n�J����:'+#13#10+e.Message;
      Memo1.Lines.Add(msg);
      LogInfo(msg);
      Exit;
    end;
  end;

  IdMessage1.MessageParts.Clear;
  TIdattachment.Create(IdMessage1.MessageParts,xfpath);
  IdMessage1.From.Address:=l_mailFrom;                      //�o��H
  IdMessage1.Recipients.EMailAddresses:=l_mailTo;           //����H
  IdMessage1.Subject:=xfname;                               //�l��D��
                                                            //�l�󥿤�
  IdMessage1.Body.Text:='Dear ALL�G'+#13#10
                       +'    ���󬰡i'+xfname+'�j�A�Ьd�\�I'+#13#10
                       +'���q���ѥ~��ERP�t�Φ۰ʵo�X�A�ФŦ^�СA�Y���ðݽ��p�������H���A���¡I'+#13#10#13#10
                       +StringReplace(FormatDateTime('YYYY/MM/DD HH:NN:SS',Now),'-','/',[rfReplaceAll]);
  try
    IdSMTP1.Send(IdMessage1);
    Result:=True;

    msg:='�l��o�e���\';
    Memo1.Lines.Add(msg);
    LogInfo(msg);
  except
    on e:exception do
    begin
      msg:='�l��o�e����:'+#13#10+e.Message;
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
      //SQLServer�A�Ⱦ�
      SQLIP:=ini.ReadString('SQLServer','IP','');
      SQLUID:=ini.ReadString('SQLServer','UID','');
      SQLPW:=ini.ReadString('SQLServer','PW','');
      SQLDB:=ini.ReadString('SQLServer','DB','');
      SQLPW:=Decrypt(SQLPW);

      //MailServer�A�Ⱦ�
      MailIP:=ini.ReadString('MailServer','IP','');
      MailID:=ini.ReadString('MailServer','UID','');
      MailPW:=ini.ReadString('MailServer','PW','');
      l_mailFrom:=ini.ReadString('MailServer','FROMADDR','');

      l_mailTo:=ini.ReadString('DLIR220','TOADDR','');
      MailPW:=Decrypt(MailPW);
    finally
      ini.Free;
    end;
  end;

  ADOConn.ConnectionString:='Provider=SQLOLEDB.1;Password='+SQLPW+';Persist Security Info=True;User ID='+SQLUID+';Initial Catalog='+SQLDB+';Data Source='+SQLIP;
  IdSMTP1.Host:=MailIP;
  idsmtp1.AuthenticationType:=atLogin; //�l�c�n������{atNone,atLogin}
  IdSMTP1.Username:=MailID;
  IdSMTP1.Password:=MailPW;

  Timer1.Enabled:=False;
  Timer1.Interval:=10000;

  s1:=Paramstr(1);
  if LowerCase(s1)='dlir220' then //��ERPServer.exe�Ұ�,Timer1����10�����
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
