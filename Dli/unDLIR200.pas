{*******************************************************}
{                                                       }
{                unDLIR200                              }
{                Author: kaikai                         }
{                Create date: 2021/5/12                 }
{                Description: 派車明細表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR200;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils;

type
  TFrmDLIR200 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_D1,l_D2:TDateTime;
    l_CDS:TClientDataSet;
    procedure GetData;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR200: TFrmDLIR200;

implementation

uses unGlobal, unCommon, unDLIR200_Query;

{$R *.dfm}

const l_CDSXml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="indate" fieldtype="datetime"/>'
                  +'<FIELD attrname="id" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="stime" fieldtype="string" WIDTH="10"/>'
                  +'<FIELD attrname="pathname" fieldtype="string" WIDTH="30"/>'
                  +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="saleno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="cclkbcnt" fieldtype="i4"/>'
                  +'<FIELD attrname="ppkbcnt" fieldtype="i4"/>'
                  +'<FIELD attrname="jiaokbcnt" fieldtype="i4"/>'
                  +'<FIELD attrname="slotcnt" fieldtype="i4"/>'
                  +'<FIELD attrname="highspeed" fieldtype="string" WIDTH="1"/>'
                  +'<FIELD attrname="state" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="company" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="carno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="driver" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="stdslotcnt" fieldtype="i4"/>'
                  +'<FIELD attrname="ton" fieldtype="i4"/>'
                  +'<FIELD attrname="dealerno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="dealer" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="sourcedno" fieldtype="string" WIDTH="20"/>'
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

procedure TFrmDLIR200.GetData;
var
  tmpSno:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS3,tmpCDS4:TClientDataSet;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  tmpCDS4:=TClientDataSet.Create(nil);
  try
    Data:=null;
    tmpSQL:='exec [dbo].[proc_DLIR200] '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(DateToStr(l_D1))+','+Quotedstr(DateToStr(l_D2));
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
       Exit;

    Data:=null;
    tmpSQL:='select b.dno,b.driver,c.saleno from dli430 a,dli013 b,dli014 c'
           +' where a.bu=b.bu and b.bu=c.bu and a.sourcedno=b.dno and b.dno=c.dno'
           +' and a.indate>='+Quotedstr(DateToStr(l_D1))
           +' and a.indate<='+Quotedstr(DateToStr(l_D2))
           +' and a.bu='+Quotedstr(g_Uinfo^.BU);
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

    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS1.RecordCount;
    g_ProgressBar.Visible:=True;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

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

      tmpCDS4.First;
      while not tmpCDS4.Eof do
      begin
        l_CDS.Append;
        l_CDS.FieldByName('indate').AsDateTime:=tmpCDS1.FieldByName('indate').AsDateTime;
        l_CDS.FieldByName('id').AsString:=tmpCDS1.FieldByName('cno').AsString;
        l_CDS.FieldByName('stime').AsString:=tmpCDS1.FieldByName('stime').AsString;
        l_CDS.FieldByName('pathname').AsString:=tmpCDS1.FieldByName('pathname').AsString;
        l_CDS.FieldByName('custno').AsString:=tmpCDS4.FieldByName('occ01').AsString;
        l_CDS.FieldByName('custshort').AsString:=tmpCDS4.FieldByName('occ02').AsString;
        l_CDS.FieldByName('saleno').AsString:=tmpCDS4.FieldByName('oga01').AsString;
        l_CDS.FieldByName('cclkbcnt').AsInteger:=tmpCDS1.FieldByName('cclkbcnt').AsInteger;
        l_CDS.FieldByName('ppkbcnt').AsInteger:=tmpCDS1.FieldByName('ppkbcnt').AsInteger;
        l_CDS.FieldByName('jiaokbcnt').AsInteger:=tmpCDS1.FieldByName('jiaokbcnt').AsInteger;
        l_CDS.FieldByName('slotcnt').AsInteger:=tmpCDS1.FieldByName('slotcnt').AsInteger;
        if tmpCDS1.FieldByName('highspeed').AsBoolean then
           l_CDS.FieldByName('highspeed').AsString:='Y'
        else
           l_CDS.FieldByName('highspeed').AsString:='N';
        l_CDS.FieldByName('state').AsString:=tmpCDS1.FieldByName('state').AsString;
        l_CDS.FieldByName('company').AsString:=tmpCDS1.FieldByName('company').AsString;
        l_CDS.FieldByName('carno').AsString:=tmpCDS1.FieldByName('carno').AsString;
        l_CDS.FieldByName('driver').AsString:=tmpCDS1.FieldByName('driver').AsString;
        l_CDS.FieldByName('stdslotcnt').AsInteger:=tmpCDS1.FieldByName('stdslotcnt').AsInteger;
        l_CDS.FieldByName('ton').AsInteger:=tmpCDS1.FieldByName('ton').AsInteger;
        l_CDS.FieldByName('dealerno').AsString:=tmpCDS1.FieldByName('dealerno').AsString;
        l_CDS.FieldByName('dealer').AsString:=tmpCDS1.FieldByName('dealer').AsString;
        l_CDS.FieldByName('sourcedno').AsString:=tmpCDS1.FieldByName('sourcedno').AsString;
        l_CDS.Post;
        tmpCDS4.Next;
      end;
      tmpCDS1.Next;
    end;
    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS3);
    FreeAndNil(tmpCDS4);
    g_ProgressBar.Visible:=False;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR200.RefreshDS(strFilter: string);
begin
  l_CDS.EmptyDataSet;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;
  if strFilter<>g_cFilterNothing then
     GetData;
  CDS.Data:=l_CDS.Data;
  inherited;
end;

procedure TFrmDLIR200.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR200';
  p_GridDesignAns:=True;
  
  l_CDS:=TClientDataSet.Create(nil);
  InitCDS(l_CDS,l_CDSXml);

  inherited;
end;

procedure TFrmDLIR200.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR200.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR200_Query) then
     FrmDLIR200_Query:=TFrmDLIR200_Query.Create(Application);
  if FrmDLIR200_Query.ShowModal=mrOK then
  begin
    l_D1:=FrmDLIR200_Query.Dtp1.Date;
    l_D2:=FrmDLIR200_Query.Dtp2.Date;
    RefreshDS('');
  end;
end;

end.
