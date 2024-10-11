{*******************************************************}
{                                                       }
{                unDLIR201                              }
{                Author: kaikai                         }
{                Create date: 2021/5/11                 }
{                Description: 出車明細表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR201;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  ComCtrls, StdCtrls, ExtCtrls, ToolWin, Math;

type
  TFrmDLIR201 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    TabSheet4: TTabSheet;
    DBGridEh4: TDBGridEh;
    CDS4: TClientDataSet;
    DS4: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure DBGridEh2GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh3GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh4GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_D1,l_D2:TDateTime;
    l_Cno:string;
    l_CDS1,l_CDS2,l_CDS3,l_CDS4:TClientDataSet;
    procedure GetData;
    procedure totkgChange(Sender:TField);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR201: TFrmDLIR201;

implementation

uses unGlobal, unCommon, unDLIR201_Query, unDLIR201_export;

{$R *.dfm}

const l_CDSXml1='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="sno" fieldtype="i4"/>'
               +'<FIELD attrname="indate" fieldtype="datetime"/>'
               +'<FIELD attrname="id" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="cno" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="company" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="carno" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="driver" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="pathname" fieldtype="string" WIDTH="30"/>'
               +'<FIELD attrname="mileage" fieldtype="r8"/>'
               +'<FIELD attrname="customcnt" fieldtype="i4"/>'
               +'<FIELD attrname="outtime" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="ton" fieldtype="r8"/>'
               +'<FIELD attrname="slot" fieldtype="i4"/>'
               +'<FIELD attrname="slotcnt" fieldtype="i4"/>'
               +'<FIELD attrname="slotper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="totkg" fieldtype="r8"/>'
               +'<FIELD attrname="maxkg" fieldtype="r8"/>'
               +'<FIELD attrname="kgper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="kbcnt" fieldtype="i4"/>'
               +'<FIELD attrname="ppkbcnt" fieldtype="i4"/>'
               +'<FIELD attrname="cclkbcnt" fieldtype="i4"/>'
               +'<FIELD attrname="jiaokbcnt" fieldtype="i4"/>'
               +'<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="custno" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="custshort" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="remark_jiaokb" fieldtype="string" WIDTH="200"/>'
               +'<FIELD attrname="saleno" fieldtype="string" WIDTH="800"/>'
               +'<FIELD attrname="sourcedno" fieldtype="string" WIDTH="20"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

const l_CDSXml2='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="sno" fieldtype="i4"/>'
               +'<FIELD attrname="title" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="cnt" fieldtype="i4"/>'
               +'<FIELD attrname="kg1" fieldtype="r8"/>'
               +'<FIELD attrname="kg2" fieldtype="r8"/>'
               +'<FIELD attrname="kgper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="kb" fieldtype="i4"/>'
               +'<FIELD attrname="slot1" fieldtype="i4"/>'
               +'<FIELD attrname="slot2" fieldtype="i4"/>'
               +'<FIELD attrname="slotper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="cntper" fieldtype="string" WIDTH="10"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

const l_CDSXml3='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="sno" fieldtype="i4"/>'
               +'<FIELD attrname="title" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="cnt" fieldtype="i4"/>'
               +'<FIELD attrname="kg1" fieldtype="r8"/>'
               +'<FIELD attrname="kg2" fieldtype="r8"/>'
               +'<FIELD attrname="kgper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="kb" fieldtype="i4"/>'
               +'<FIELD attrname="slot1" fieldtype="i4"/>'
               +'<FIELD attrname="slot2" fieldtype="i4"/>'
               +'<FIELD attrname="slotper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="customcnt" fieldtype="i4"/>'
               +'<FIELD attrname="cntper" fieldtype="string" WIDTH="10"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

const l_CDSXml4='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="sno" fieldtype="i4"/>'
               +'<FIELD attrname="title" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="cnt" fieldtype="i4"/>'
               +'<FIELD attrname="kg1" fieldtype="r8"/>'
               +'<FIELD attrname="kg2" fieldtype="r8"/>'
               +'<FIELD attrname="kgper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="ppkb" fieldtype="i4"/>'
               +'<FIELD attrname="ppkbper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="cclkb" fieldtype="i4"/>'
               +'<FIELD attrname="cclkbper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="kb" fieldtype="i4"/>'
               +'<FIELD attrname="slot1" fieldtype="i4"/>'
               +'<FIELD attrname="slot2" fieldtype="i4"/>'
               +'<FIELD attrname="slotper" fieldtype="string" WIDTH="10"/>'
               +'<FIELD attrname="customcnt" fieldtype="i4"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

procedure TFrmDLIR201.GetData;
var
  tmpSQL,tmpCustno,tmpCustshort,tmpSaleno,tmpTitle:string;
  tmpSno,tmpLen,tmpCustomcnt,tmpSumCnt,tmpSumKB,tmpSumPPKB,tmpSumCCLKB,tmpSumSlot1,tmpSumSlot2,tmpSumCustom:Integer;
  tmpSumKG1,tmpSumKG2:Double;
  tmpIndate:TDateTime;
  Data:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDS3,tmpCDS4:TClientDataSet;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  tmpCDS4:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select indate,id,cno,carno,pathname,slotcnt,cclkbcnt,ppkbcnt,'
           +' jiaokbcnt,sourcedno,outtime,totkg,remark,remark_jiaokb from dli430'
           +' where indate>='+Quotedstr(DateToStr(l_D1))
           +' and indate<='+Quotedstr(DateToStr(l_D2))
           +' and bu='+Quotedstr(g_Uinfo^.BU);
    if Length(l_Cno)>0 then
       tmpSQL:=tmpSQL+' and cno='+Quotedstr(l_Cno);
    tmpSQL:=tmpSQL+' order by indate,outtime,cno';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
       Exit;

    Data:=null;
    tmpSQL:='select carno,driver,company,ton,slot,maxkg,mileage from dli420'
           +' where bu='+Quotedstr(g_Uinfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS2.Data:=Data;

    Data:=null;
    tmpSQL:='select b.dno,b.driver,c.saleno from dli430 a,dli013 b,dli014 c'
           +' where a.bu=b.bu and b.bu=c.bu and a.sourcedno=b.dno and b.dno=c.dno'
           +' and a.indate>='+Quotedstr(DateToStr(l_D1))
           +' and a.indate<='+Quotedstr(DateToStr(l_D2))
           +' and a.bu='+Quotedstr(g_Uinfo^.BU)
           +' and b.conf=''Y''';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS3.Data:=Data;
    if tmpCDS3.IsEmpty then
       Exit;

    //tiptop 500個單號查詢一次
    tmpSno:=1;
    tmpSQL:='';
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS3.RecordCount;
    g_ProgressBar.Visible:=True;
    tmpCDS3.First;
    while not tmpCDS3.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;
          
      tmpSQL:=tmpSQL+','+Quotedstr(tmpCDS3.FieldByName('saleno').AsString);
      tmpCDS3.Next;
      if tmpCDS3.Eof or (tmpSno=500) then
      begin
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpSQL:='select oga01,occ01,occ02'
               +' from(select oga01,oga04 from '+g_UInfo^.BU+'.oga_file'
               +' where oga01 in ('+tmpSQL+') and ogaconf=''Y'') a left join '+g_UInfo^.BU+'.occ_file'
               +' on oga04=occ01';
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
           Exit;
        if not tmpCDS4.Active then
           tmpCDS4.Data:=Data
        else
           tmpCDS4.AppendData(Data, True);
        tmpSno:=1;
        tmpSQL:='';
      end else
        Inc(tmpSno);
    end;

    if (not tmpCDS4.Active) or tmpCDS4.IsEmpty then
       Exit;

    tmpSno:=1;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS1.RecordCount;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      tmpIndate:=tmpCDS1.FieldByName('indate').AsDateTime;

      tmpCDS3.Filtered:=False;
      tmpCDS3.Filter:='dno='+Quotedstr(tmpCDS1.FieldByName('sourcedno').AsString);
      tmpCDS3.Filtered:=True;
      if tmpCDS3.IsEmpty then
      begin
        tmpCDS1.Next;
        Continue;
      end;

      tmpSQL:='';
      tmpCDS3.First;
      while not tmpCDS3.Eof do
      begin
        tmpSQL:=tmpSQL+' or oga01='+Quotedstr(tmpCDS3.FieldByName('saleno').AsString);
        tmpCDS3.Next;
      end;

      Delete(tmpSQL,1,4);
      tmpCDS4.Filtered:=False;
      tmpCDS4.Filter:=tmpSQL;
      tmpCDS4.Filtered:=True;
      tmpCDS4.IndexFieldNames:='occ01;oga01';
      if tmpCDS4.IsEmpty then
      begin
        tmpCDS1.Next;
        Continue;
      end;

      tmpCustomcnt:=0;
      tmpCustno:='';
      tmpCustshort:='';
      tmpSaleno:='';
      tmpCDS4.First;
      while not tmpCDS4.Eof do
      begin
        if pos(tmpCDS4.FieldByName('occ01').AsString,tmpCustno)=0 then
        begin
          tmpLen:=Length(tmpSaleno);
          if tmpLen=0 then
             tmpSaleno:=tmpCDS4.FieldByName('occ01').AsString+tmpCDS4.FieldByName('occ02').AsString+':'
          else
             tmpSaleno:=Copy(tmpSaleno,1,tmpLen-1)+' '+tmpCDS4.FieldByName('occ01').AsString+tmpCDS4.FieldByName('occ02').AsString+':';

          tmpCustno:=tmpCustno+','+tmpCDS4.FieldByName('occ01').AsString;
          tmpCustshort:=tmpCustshort+','+tmpCDS4.FieldByName('occ02').AsString;
          Inc(tmpCustomcnt);
        end;

        tmpSaleno:=tmpSaleno+tmpCDS4.FieldByName('oga01').AsString+',';
        tmpCDS4.Next;
      end;

      Delete(tmpCustno,1,1);
      Delete(tmpCustshort,1,1);
      tmpSaleno:=Copy(tmpSaleno,1,Length(tmpSaleno)-1);

      l_CDS1.Append;
      l_CDS1.FieldByName('sno').AsInteger:=tmpSno;
      l_CDS1.FieldByName('indate').AsDateTime:=tmpCDS1.FieldByName('indate').AsDateTime;
      l_CDS1.FieldByName('id').AsString:=tmpCDS1.FieldByName('id').AsString;
      l_CDS1.FieldByName('cno').AsString:=tmpCDS1.FieldByName('cno').AsString;
      l_CDS1.FieldByName('carno').AsString:=tmpCDS1.FieldByName('carno').AsString;
      if tmpCDS2.Locate('carno',tmpCDS1.FieldByName('carno').AsString,[loCaseInsensitive]) then
      begin
        l_CDS1.FieldByName('company').Value:=tmpCDS2.FieldByName('company').Value;
        l_CDS1.FieldByName('ton').Value:=tmpCDS2.FieldByName('ton').Value;
        l_CDS1.FieldByName('slot').Value:=tmpCDS2.FieldByName('slot').Value;
        l_CDS1.FieldByName('maxkg').Value:=tmpCDS2.FieldByName('maxkg').Value;
        l_CDS1.FieldByName('mileage').Value:=tmpCDS2.FieldByName('mileage').Value;
      end;
      l_CDS1.FieldByName('driver').AsString:=tmpCDS3.FieldByName('driver').AsString;
      l_CDS1.FieldByName('pathname').AsString:=tmpCDS1.FieldByName('pathname').AsString;
      l_CDS1.FieldByName('outtime').Value:=tmpCDS1.FieldByName('outtime').Value;
      l_CDS1.FieldByName('totkg').Value:=tmpCDS1.FieldByName('totkg').Value;
      l_CDS1.FieldByName('slotcnt').AsInteger:=tmpCDS1.FieldByName('slotcnt').AsInteger;

      if l_CDS1.FieldByName('totkg').AsFloat=0 then
         l_CDS1.FieldByName('kgper').AsString:='0%'
      else if l_CDS1.FieldByName('maxkg').AsFloat>0 then
         l_CDS1.FieldByName('kgper').AsString:=IntToStr(Round(l_CDS1.FieldByName('totkg').AsFloat/l_CDS1.FieldByName('maxkg').AsFloat*100))+'%'
      else
         l_CDS1.FieldByName('kgper').AsString:='100%';

      if l_CDS1.FieldByName('slotcnt').AsInteger=0 then
         l_CDS1.FieldByName('slotper').AsString:='0%'
      else if l_CDS1.FieldByName('slot').AsInteger>0 then
         l_CDS1.FieldByName('slotper').AsString:=IntToStr(Round(l_CDS1.FieldByName('slotcnt').AsInteger/l_CDS1.FieldByName('slot').AsInteger*100))+'%'
      else
         l_CDS1.FieldByName('slotper').AsString:='100%';

      l_CDS1.FieldByName('kbcnt').AsInteger:=tmpCDS1.FieldByName('ppkbcnt').AsInteger+tmpCDS1.FieldByName('cclkbcnt').AsInteger;
      l_CDS1.FieldByName('cclkbcnt').AsInteger:=tmpCDS1.FieldByName('cclkbcnt').AsInteger;
      l_CDS1.FieldByName('ppkbcnt').AsInteger:=tmpCDS1.FieldByName('ppkbcnt').AsInteger;
      l_CDS1.FieldByName('jiaokbcnt').AsInteger:=tmpCDS1.FieldByName('jiaokbcnt').AsInteger;
      l_CDS1.FieldByName('sourcedno').AsString:=tmpCDS1.FieldByName('sourcedno').AsString;
      l_CDS1.FieldByName('remark').AsString:=tmpCDS1.FieldByName('remark').AsString;
      l_CDS1.FieldByName('remark_jiaokb').AsString:=tmpCDS1.FieldByName('remark_jiaokb').AsString;
      l_CDS1.FieldByName('customcnt').AsInteger:=tmpCustomcnt;
      l_CDS1.FieldByName('custno').AsString:=tmpCustno;
      l_CDS1.FieldByName('custshort').AsString:=tmpCustshort;
      l_CDS1.FieldByName('saleno').AsString:=tmpSaleno;
      l_CDS1.Post;

      //l_CDS2
      tmpTitle:=l_CDS1.FieldByName('company').AsString;
      if l_CDS2.Locate('title',tmpTitle,[loCaseInsensitive]) then
         l_CDS2.Edit
      else begin
        l_CDS2.Append;
        if Pos('廠車',tmpTitle)=0 then
           l_CDS2.FieldByName('sno').AsInteger:=0
        else
           l_CDS2.FieldByName('sno').AsInteger:=2;
        l_CDS2.FieldByName('title').AsString:=tmpTitle;
      end;
      l_CDS2.FieldByName('cnt').AsInteger:=l_CDS2.FieldByName('cnt').AsInteger+1;
      l_CDS2.FieldByName('kg1').AsFloat:=l_CDS2.FieldByName('kg1').AsFloat+l_CDS1.FieldByName('totkg').AsFloat;
      l_CDS2.FieldByName('kg2').AsFloat:=l_CDS2.FieldByName('kg2').AsFloat+l_CDS1.FieldByName('maxkg').AsFloat;
      l_CDS2.FieldByName('kb').AsInteger:=l_CDS2.FieldByName('kb').AsInteger+l_CDS1.FieldByName('kbcnt').AsInteger;
      l_CDS2.FieldByName('slot1').AsInteger:=l_CDS2.FieldByName('slot1').AsInteger+l_CDS1.FieldByName('slotcnt').AsInteger;
      l_CDS2.FieldByName('slot2').AsInteger:=l_CDS2.FieldByName('slot2').AsInteger+l_CDS1.FieldByName('slot').AsInteger;
      l_CDS2.Post;

      //l_CDS3
      tmpTitle:=l_CDS1.FieldByName('pathname').AsString;
      if l_CDS3.Locate('title',tmpTitle,[loCaseInsensitive]) then
         l_CDS3.Edit
      else begin
        l_CDS3.Append;
        l_CDS3.FieldByName('sno').AsInteger:=0;
        l_CDS3.FieldByName('title').AsString:=tmpTitle;
      end;
      l_CDS3.FieldByName('cnt').AsInteger:=l_CDS3.FieldByName('cnt').AsInteger+1;
      l_CDS3.FieldByName('kg1').AsFloat:=l_CDS3.FieldByName('kg1').AsFloat+l_CDS1.FieldByName('totkg').AsFloat;
      l_CDS3.FieldByName('kg2').AsFloat:=l_CDS3.FieldByName('kg2').AsFloat+l_CDS1.FieldByName('maxkg').AsFloat;
      l_CDS3.FieldByName('kb').AsInteger:=l_CDS3.FieldByName('kb').AsInteger+l_CDS1.FieldByName('kbcnt').AsInteger;
      l_CDS3.FieldByName('slot1').AsInteger:=l_CDS3.FieldByName('slot1').AsInteger+l_CDS1.FieldByName('slotcnt').AsInteger;
      l_CDS3.FieldByName('slot2').AsInteger:=l_CDS3.FieldByName('slot2').AsInteger+l_CDS1.FieldByName('slot').AsInteger;
      l_CDS3.FieldByName('customcnt').AsInteger:=l_CDS3.FieldByName('customcnt').AsInteger+l_CDS1.FieldByName('customcnt').AsInteger;
      l_CDS3.Post;

      //l_CDS4
      tmpTitle:=StringReplace(FormatDateTime(g_cShortDate1,tmpIndate),'/','-',[rfReplaceAll]);
      if l_CDS4.Locate('title',tmpTitle,[loCaseInsensitive]) then
         l_CDS4.Edit
      else begin
        l_CDS4.Append;
        l_CDS4.FieldByName('sno').AsInteger:=0;
        l_CDS4.FieldByName('title').AsString:=tmpTitle;
      end;
      l_CDS4.FieldByName('cnt').AsInteger:=l_CDS4.FieldByName('cnt').AsInteger+1;
      l_CDS4.FieldByName('kg1').AsFloat:=l_CDS4.FieldByName('kg1').AsFloat+l_CDS1.FieldByName('totkg').AsFloat;
      l_CDS4.FieldByName('kg2').AsFloat:=l_CDS4.FieldByName('kg2').AsFloat+l_CDS1.FieldByName('maxkg').AsFloat;
      l_CDS4.FieldByName('ppkb').AsInteger:=l_CDS4.FieldByName('ppkb').AsInteger+l_CDS1.FieldByName('ppkbcnt').AsInteger;
      l_CDS4.FieldByName('cclkb').AsInteger:=l_CDS4.FieldByName('cclkb').AsInteger+l_CDS1.FieldByName('cclkbcnt').AsInteger;
      l_CDS4.FieldByName('kb').AsInteger:=l_CDS4.FieldByName('kb').AsInteger+l_CDS1.FieldByName('kbcnt').AsInteger;
      l_CDS4.FieldByName('slot1').AsInteger:=l_CDS4.FieldByName('slot1').AsInteger+l_CDS1.FieldByName('slotcnt').AsInteger;
      l_CDS4.FieldByName('slot2').AsInteger:=l_CDS4.FieldByName('slot2').AsInteger+l_CDS1.FieldByName('slot').AsInteger;
      l_CDS4.FieldByName('customcnt').AsInteger:=l_CDS4.FieldByName('customcnt').AsInteger+l_CDS1.FieldByName('customcnt').AsInteger;
      l_CDS4.Post;

      tmpCDS1.Next;
      if tmpIndate=tmpCDS1.FieldByName('indate').AsDateTime then
         Inc(tmpSno)
      else
         tmpSno:=1;
    end;

    //統計l_CDS2
    tmpSumCnt:=0;
    tmpSumKG1:=0;
    tmpSumKG2:=0;
    tmpSumKB:=0;
    tmpSumSlot1:=0;
    tmpSumSlot2:=0;
    with tmpCDS1 do
    begin
      Filtered:=False;
      Filter:='';
      Data:=l_CDS2.Data;
      Filter:='sno=0';
      Filtered:=True;
      First;
      while not Eof do
      begin
        tmpSumCnt:=tmpSumCnt+FieldByName('cnt').AsInteger;
        tmpSumKG1:=tmpSumKG1+FieldByName('kg1').AsFloat;
        tmpSumKG2:=tmpSumKG2+FieldByName('kg2').AsFloat;
        tmpSumKB:=tmpSumKB+FieldByName('kb').AsInteger;
        tmpSumSlot1:=tmpSumSlot1+FieldByName('slot1').AsInteger;
        tmpSumSlot2:=tmpSumSlot2+FieldByName('slot2').AsInteger;
        Next;
      end;
    end;

    with l_CDS2 do
    begin
      Filtered:=False;
      Filter:='sno=0';
      Filtered:=True;
      First;
      while not Eof do
      begin
        Edit;
        if FieldByName('cnt').AsInteger=0 then
           FieldByName('cntper').AsString:='0%'
        else if tmpSumCnt>0 then
           FieldByName('cntper').AsString:=FloatToStr(RoundTo(FieldByName('cnt').AsInteger/tmpSumCnt,-4)*100)+'%'
        else
           FieldByName('cntper').AsString:='100%';
        Post;
        Next;
      end;
      Filtered:=False;
      Filter:='';
      Append;
      FieldByName('sno').AsInteger:=1;
      FieldByName('title').AsString:=CheckLang('小計');
      FieldByName('cnt').AsInteger:=tmpSumCnt;
      FieldByName('kg1').AsFloat:=tmpSumKG1;
      FieldByName('kg2').AsFloat:=tmpSumKG2;
      FieldByName('kb').AsInteger:=tmpSumKB;
      FieldByName('slot1').AsInteger:=tmpSumSlot1;
      FieldByName('slot2').AsInteger:=tmpSumSlot2;
      Post;
    end;

    with tmpCDS1 do
    begin
      Filtered:=False;
      Filter:='sno=2';
      Filtered:=True;
      First;
      while not Eof do
      begin
        tmpSumCnt:=tmpSumCnt+FieldByName('cnt').AsInteger;
        tmpSumKG1:=tmpSumKG1+FieldByName('kg1').AsFloat;
        tmpSumKG2:=tmpSumKG2+FieldByName('kg2').AsFloat;
        tmpSumKB:=tmpSumKB+FieldByName('kb').AsInteger;
        tmpSumSlot1:=tmpSumSlot1+FieldByName('slot1').AsInteger;
        tmpSumSlot2:=tmpSumSlot2+FieldByName('slot2').AsInteger;
        Next;
      end;
    end;

    with l_CDS2 do
    begin
      Append;
      FieldByName('sno').AsInteger:=3;
      FieldByName('title').AsString:=CheckLang('合計');
      FieldByName('cnt').AsInteger:=tmpSumCnt;
      FieldByName('kg1').AsFloat:=tmpSumKG1;
      FieldByName('kg2').AsFloat:=tmpSumKG2;
      FieldByName('kb').AsInteger:=tmpSumKB;
      FieldByName('slot1').AsInteger:=tmpSumSlot1;
      FieldByName('slot2').AsInteger:=tmpSumSlot2;
      Post;
      First;
      while not Eof do
      begin
        Edit;
        if FieldByName('kg1').AsInteger=0 then
           FieldByName('kgper').AsString:='0%'
        else if FieldByName('kg2').AsFloat>0 then
           FieldByName('kgper').AsString:=IntToStr(Round(FieldByName('kg1').AsFloat/FieldByName('kg2').AsFloat*100))+'%'
        else
           FieldByName('kgper').AsString:='100%';

        if FieldByName('slot1').AsInteger=0 then
           FieldByName('slotper').AsString:='0%'
        else if FieldByName('slot2').AsInteger>0 then
           FieldByName('slotper').AsString:=IntToStr(Round(FieldByName('slot1').AsInteger/FieldByName('slot2').AsInteger*100))+'%'
        else
           FieldByName('slotper').AsString:='100%';
        Post;
        Next;
      end;
    end;

    //統計l_CDS3
    tmpSumCnt:=0;
    tmpSumKG1:=0;
    tmpSumKG2:=0;
    tmpSumKB:=0;
    tmpSumSlot1:=0;
    tmpSumSlot2:=0;
    tmpSumCustom:=0;
    with tmpCDS1 do
    begin
      Filtered:=False;
      Filter:='';
      Data:=l_CDS3.Data;
      Filtered:=False;
      Filter:='sno=0';
      Filtered:=True;
      First;
      while not Eof do
      begin
        tmpSumCnt:=tmpSumCnt+FieldByName('cnt').AsInteger;
        tmpSumKG1:=tmpSumKG1+FieldByName('kg1').AsFloat;
        tmpSumKG2:=tmpSumKG2+FieldByName('kg2').AsFloat;
        tmpSumKB:=tmpSumKB+FieldByName('kb').AsInteger;
        tmpSumSlot1:=tmpSumSlot1+FieldByName('slot1').AsInteger;
        tmpSumSlot2:=tmpSumSlot2+FieldByName('slot2').AsInteger;
        tmpSumCustom:=tmpSumCustom+FieldByName('customcnt').AsInteger;
        Next;
      end;
    end;

    with l_CDS3 do
    begin
      Append;
      FieldByName('sno').AsInteger:=1;
      FieldByName('title').AsString:=CheckLang('小計');
      FieldByName('cnt').AsInteger:=tmpSumCnt;
      FieldByName('kg1').AsFloat:=tmpSumKG1;
      FieldByName('kg2').AsFloat:=tmpSumKG2;
      FieldByName('kb').AsInteger:=tmpSumKB;
      FieldByName('slot1').AsInteger:=tmpSumSlot1;
      FieldByName('slot2').AsInteger:=tmpSumSlot2;
      FieldByName('customcnt').AsInteger:=tmpSumCustom;
      Post;
      First;
      while not Eof do
      begin
        Edit;
        if FieldByName('kg1').AsInteger=0 then
           FieldByName('kgper').AsString:='0%'
        else if FieldByName('kg2').AsFloat>0 then
           FieldByName('kgper').AsString:=IntToStr(Round(FieldByName('kg1').AsFloat/FieldByName('kg2').AsFloat*100))+'%'
        else
           FieldByName('kgper').AsString:='100%';

        if FieldByName('slot1').AsInteger=0 then
           FieldByName('slotper').AsString:='0%'
        else if FieldByName('slot2').AsInteger>0 then
           FieldByName('slotper').AsString:=IntToStr(Round(FieldByName('slot1').AsInteger/FieldByName('slot2').AsInteger*100))+'%'
        else
           FieldByName('slotper').AsString:='100%';

        if FieldByName('customcnt').AsInteger=0 then
           FieldByName('cntper').AsString:='0'
        else if FieldByName('cnt').AsInteger>0 then
           FieldByName('cntper').AsString:=FloatToStr(RoundTo(FieldByName('customcnt').AsInteger/FieldByName('cnt').AsInteger,-3)*100)
        else
           FieldByName('cntper').AsString:='0';
        if Pos('.',FieldByName('cntper').AsString)=0 then
           FieldByName('cntper').AsString:=FieldByName('cntper').AsString+'.0';
        Post;
        Next;
      end;
    end;

    //統計l_CDS4
    tmpSumCnt:=0;
    tmpSumKG1:=0;
    tmpSumKG2:=0;
    tmpSumPPKB:=0;
    tmpSumCCLKB:=0;
    tmpSumKB:=0;
    tmpSumSlot1:=0;
    tmpSumSlot2:=0;
    tmpSumCustom:=0;
    with tmpCDS1 do
    begin
      Filtered:=False;
      Filter:='';
      Data:=l_CDS4.Data;
      Filtered:=False;
      Filter:='sno=0';
      Filtered:=True;
      First;
      while not Eof do
      begin
        tmpSumCnt:=tmpSumCnt+FieldByName('cnt').AsInteger;
        tmpSumKG1:=tmpSumKG1+FieldByName('kg1').AsFloat;
        tmpSumKG2:=tmpSumKG2+FieldByName('kg2').AsFloat;
        tmpSumPPKB:=tmpSumPPKB+FieldByName('ppkb').AsInteger;
        tmpSumCCLKB:=tmpSumCCLKB+FieldByName('cclkb').AsInteger;
        tmpSumKB:=tmpSumKB+FieldByName('kb').AsInteger;
        tmpSumSlot1:=tmpSumSlot1+FieldByName('slot1').AsInteger;
        tmpSumSlot2:=tmpSumSlot2+FieldByName('slot2').AsInteger;
        tmpSumCustom:=tmpSumCustom+FieldByName('customcnt').AsInteger;
        Next;
      end;
    end;

    with l_CDS4 do
    begin
      if RecordCount>0 then
      begin
        Append;
        FieldByName('sno').AsInteger:=1;
        FieldByName('title').AsString:=CheckLang('月平均');
        FieldByName('cnt').AsInteger:=Round(tmpSumCnt/RecordCount);
        FieldByName('kg1').AsFloat:=Round(tmpSumKG1/RecordCount);
        FieldByName('kg2').AsFloat:=Round(tmpSumKG2/RecordCount);
        FieldByName('ppkb').AsInteger:=Round(tmpSumPPKB/RecordCount);
        FieldByName('cclkb').AsInteger:=Round(tmpSumCCLKB/RecordCount);
        FieldByName('kb').AsInteger:=Round(tmpSumKB/RecordCount);
        FieldByName('slot1').AsInteger:=Round(tmpSumSlot1/RecordCount);
        FieldByName('slot2').AsInteger:=Round(tmpSumSlot2/RecordCount);
        FieldByName('customcnt').AsInteger:=Round(tmpSumCustom/RecordCount);
        Post;
      end;
      Append;
      FieldByName('sno').AsInteger:=2;
      FieldByName('title').AsString:=CheckLang('月合計');
      FieldByName('cnt').AsInteger:=tmpSumCnt;
      FieldByName('kg1').AsFloat:=tmpSumKG1;
      FieldByName('kg2').AsFloat:=tmpSumKG2;
      FieldByName('ppkb').AsInteger:=tmpSumPPKB;
      FieldByName('cclkb').AsInteger:=tmpSumCCLKB;
      FieldByName('kb').AsInteger:=tmpSumKB;
      FieldByName('slot1').AsInteger:=tmpSumSlot1;
      FieldByName('slot2').AsInteger:=tmpSumSlot2;
      FieldByName('customcnt').AsInteger:=tmpSumCustom;
      Post;
      First;
      while not Eof do
      begin
        Edit;
        if FieldByName('kg1').AsInteger=0 then
           FieldByName('kgper').AsString:='0%'
        else if FieldByName('kg2').AsFloat>0 then
           FieldByName('kgper').AsString:=IntToStr(Round(FieldByName('kg1').AsFloat/FieldByName('kg2').AsFloat*100))+'%'
        else
           FieldByName('kgper').AsString:='100%';

        if FieldByName('slot1').AsInteger=0 then
           FieldByName('slotper').AsString:='0%'
        else if FieldByName('slot2').AsInteger>0 then
           FieldByName('slotper').AsString:=IntToStr(Round(FieldByName('slot1').AsInteger/FieldByName('slot2').AsInteger*100))+'%'
        else
           FieldByName('slotper').AsString:='100%';

        if FieldByName('kb').AsInteger>0 then
        begin
          FieldByName('ppkbper').AsString:=IntToStr(Round(FieldByName('ppkb').AsInteger/FieldByName('kb').AsInteger*100))+'%';
          FieldByName('cclkbper').AsString:=IntToStr(Round(FieldByName('cclkb').AsInteger/FieldByName('kb').AsInteger*100))+'%'
        end else
        begin
          if FieldByName('ppkb').AsInteger=0 then
             FieldByName('ppkbper').AsString:='0%'
          else
             FieldByName('ppkbper').AsString:='100%';

          if FieldByName('cclkb').AsInteger=0 then
             FieldByName('cclkbper').AsString:='0%'
          else
             FieldByName('cclkbper').AsString:='100%';
        end;
        Post;
        Next;
      end;
    end;

    if l_CDS1.ChangeCount>0 then
       l_CDS1.MergeChangeLog;
    if l_CDS2.ChangeCount>0 then
       l_CDS2.MergeChangeLog;
    if l_CDS3.ChangeCount>0 then
       l_CDS3.MergeChangeLog;
    if l_CDS4.ChangeCount>0 then
       l_CDS4.MergeChangeLog;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    FreeAndNil(tmpCDS4);
    g_ProgressBar.Visible:=False;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR201.totkgChange(Sender:TField);
begin
  if CDS.FieldByName('totkg').AsInteger=0 then
     CDS.FieldByName('kgper').AsString:='0%'
  else if CDS.FieldByName('maxkg').AsInteger>0 then
     CDS.FieldByName('kgper').AsString:=IntToStr(Round(CDS.FieldByName('totkg').AsInteger/CDS.FieldByName('maxkg').AsInteger*100))+'%'
  else
     CDS.FieldByName('kgper').AsString:='100%';
end;

procedure TFrmDLIR201.RefreshDS(strFilter: string);
begin
  l_CDS1.EmptyDataSet;
  l_CDS2.EmptyDataSet;
  l_CDS3.EmptyDataSet;
  l_CDS4.EmptyDataSet;
  if l_CDS1.ChangeCount>0 then
     l_CDS1.MergeChangeLog;
  if l_CDS2.ChangeCount>0 then
     l_CDS2.MergeChangeLog;
  if l_CDS3.ChangeCount>0 then
     l_CDS3.MergeChangeLog;
  if l_CDS4.ChangeCount>0 then
     l_CDS4.MergeChangeLog;
  if strFilter<>g_cFilterNothing then
     GetData;
  CDS.Data:=l_CDS1.Data;
  CDS2.Data:=l_CDS2.Data;
  CDS3.Data:=l_CDS3.Data;
  CDS4.Data:=l_CDS4.Data;
  inherited;
end;

procedure TFrmDLIR201.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR201';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('黃色欄位可編輯');
  l_CDS1:=TClientDataSet.Create(nil);
  l_CDS2:=TClientDataSet.Create(nil);
  l_CDS3:=TClientDataSet.Create(nil);
  l_CDS4:=TClientDataSet.Create(nil);
  InitCDS(l_CDS1,l_CDSXml1);
  InitCDS(l_CDS2,l_CDSXml2);
  InitCDS(l_CDS3,l_CDSXml3);
  InitCDS(l_CDS4,l_CDSXml4);

  inherited;

  TabSheet1.Caption:=CheckLang('明細表');
  TabSheet2.Caption:=CheckLang('物流商');
  TabSheet3.Caption:=CheckLang('送貨區域');
  TabSheet4.Caption:=CheckLang('每天');
  SetGrdCaption(DBGridEh2, 'DLIR201_2');
  SetGrdCaption(DBGridEh3, 'DLIR201_3');
  SetGrdCaption(DBGridEh4, 'DLIR201_4');
  CDS2.IndexFieldNames:='sno;title';
  CDS3.IndexFieldNames:='sno;title';
  CDS4.IndexFieldNames:='sno;title';
end;

procedure TFrmDLIR201.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CDS.State in [dsEdit] then
     CDS.Post;

  inherited;
  
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
  FreeAndNil(l_CDS3);
  FreeAndNil(l_CDS4);
end;

procedure TFrmDLIR201.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR201_Query) then
     FrmDLIR201_Query:=TFrmDLIR201_Query.Create(Application);
  if FrmDLIR201_Query.ShowModal=mrOK then
  begin
    l_D1:=FrmDLIR201_Query.Dtp1.Date;
    l_D2:=FrmDLIR201_Query.Dtp2.Date;
    l_Cno:=FrmDLIR201_Query.Edit1.Text;
    RefreshDS('');
  end;
end;

procedure TFrmDLIR201.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select bu,indate,id,outtime,totkg,remark,remark_jiaokb from dli430'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and indate='+Quotedstr(DateToStr(CDS.FieldByName('indate').AsDateTime))
         +' and id='+Quotedstr(CDS.FieldByName('id').AsString);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;

    tmpCDS.Edit;
    if CDS.FieldByName('outtime').IsNull then
       tmpCDS.FieldByName('outtime').Clear
    else
       tmpCDS.FieldByName('outtime').AsString:=CDS.FieldByName('outtime').AsString;

    if CDS.FieldByName('totkg').IsNull then
       tmpCDS.FieldByName('totkg').Clear
    else
       tmpCDS.FieldByName('totkg').AsFloat:=CDS.FieldByName('totkg').AsFloat;

    if CDS.FieldByName('remark').IsNull then
       tmpCDS.FieldByName('remark').Clear
    else
       tmpCDS.FieldByName('remark').AsString:=CDS.FieldByName('remark').AsString;

    if CDS.FieldByName('remark_jiaokb').IsNull then
       tmpCDS.FieldByName('remark_jiaokb').Clear
    else
       tmpCDS.FieldByName('remark_jiaokb').AsString:=CDS.FieldByName('remark_jiaokb').AsString;
    tmpCDS.Post;
    CDSPost(tmpCDS, 'dli430');
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLIR201.CDSBeforeDelete(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmDLIR201.CDSBeforeInsert(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmDLIR201.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('totkg').OnChange:=totkgChange;
end;

procedure TFrmDLIR201.DBGridEh2GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (CDS2.FieldByName('sno').AsInteger=1) or
     (CDS2.FieldByName('sno').AsInteger=3) then
     Background:=clMoneyGreen;
end;

procedure TFrmDLIR201.DBGridEh3GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS3.FieldByName('sno').AsInteger=1 then
     Background:=clMoneyGreen;
end;

procedure TFrmDLIR201.DBGridEh4GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (CDS4.FieldByName('sno').AsInteger=1) or
     (CDS4.FieldByName('sno').AsInteger=2)  then
     Background:=clMoneyGreen;
end;

procedure TFrmDLIR201.btn_exportClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR201_export) then
     FrmDLIR201_export:=TFrmDLIR201_export.Create(Application);
  if FrmDLIR201_export.ShowModal<>mrOK then
     Exit;
     
  case FrmDLIR201_export.rgp.ItemIndex of
   0:GetExportXls(CDS, p_TableName);
   1:GetExportXls(CDS2, 'dlir201_2');
   2:GetExportXls(CDS3, 'dlir201_3');
   3:GetExportXls(CDS4, 'dlir201_4');
  end;
end;

end.
