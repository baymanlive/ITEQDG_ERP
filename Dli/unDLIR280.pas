{*******************************************************}
{                                                       }
{                unDLIR280                              }
{                Author: kaikai                         }
{                Create date: 2020/8/20                 }
{                Description: 入庫清單apmt720           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR280;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR280 = class(TFrmSTDI041)
    DBGridEh2: TDBGridEh;
    Splitter1: TSplitter;
    DS2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure btn_printClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
  private
    { Private declarations }
    l_prnIndex:Integer;
    l_dataCDS,l_CDS:TClientDataSet;    //源數據,主檔數據
    l_StrIndex,l_StrIndexDesc:string;
    function GetRVU08(rvu08:string):string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR280: TFrmDLIR280;

implementation

uses unGlobal, unCommon, unDLIR280_Query;

{$R *.dfm}

const l_xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sno" fieldtype="i4"/>'
           +'<FIELD attrname="select" fieldtype="boolean"/>'
           +'<FIELD attrname="isprn" fieldtype="boolean"/>'
           +'<FIELD attrname="rvu03" fieldtype="datetime"/>'
           +'<FIELD attrname="rvu01" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvu02" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvu08" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvu04" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvu05" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="rvu06" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="gem02" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvu07" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="gen02" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv02" fieldtype="i4"/>'
           +'<FIELD attrname="rvv31" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv031" fieldtype="string" WIDTH="80"/>'
           +'<FIELD attrname="ima021" fieldtype="string" WIDTH="80"/>'
           +'<FIELD attrname="rvv32" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv33" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv17" fieldtype="r8"/>'
           +'<FIELD attrname="rvv35" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv36" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="rvv37" fieldtype="i4"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

procedure TFrmDLIR280.RefreshDS(strFilter: string);
var
  i:Integer;
  tmpSQL,tmpId:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  l_CDS.EmptyDataSet;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  if strFilter=g_cFilterNothing then
  begin
    if l_dataCDS.Active then
    begin
      l_dataCDS.EmptyDataSet;
      if l_dataCDS.ChangeCount>0 then
         l_dataCDS.MergeChangeLog;
    end;
    CDS.Data:=l_CDS.Data
  end else
  begin
    g_StatusBar.Panels[0].Text:='正在查詢資料...';
    Application.ProcessMessages;
    try
      tmpSQL:='select z.*,ima021 from ('
             +' select y.*,gen02 from ('
             +' select x.*,gem02 from ('
             +' select * from '+g_UInfo^.BU+'.rvu_file,'+g_UInfo^.BU+'.rvv_file where rvu01=rvv01'
             +' and (rvu02 like ''333%'' or rvu02 like ''336%'' or rvu02 like ''337%'' or rvu02 like ''33E%'')'
             +' and rvuconf=''Y'' and rvuacti=''Y'' '+strFilter+') x'
             +' left join '+g_UInfo^.BU+'.gem_file on rvu06=gem01) y'
             +' left join '+g_UInfo^.BU+'.gen_file on rvu07=gen01) z'
             +' left join '+g_UInfo^.BU+'.ima_file on rvv31=ima01'
             +' order by rvu03,rvv01,rvv02';           
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        tmpCDS1:=TClientDataSet.Create(nil);
        tmpCDS2:=TClientDataSet.Create(nil);
        try
          tmpCDS1.Data:=Data;
          i:=1;
          tmpSQL:='';
          tmpId:='@';
          with tmpCDS1 do
          while not Eof do
          begin
            if tmpId<>FieldByName('rvu01').AsString then
            begin
              tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('rvu01').AsString);
              l_CDS.Append;
              l_CDS.FieldByName('sno').AsInteger:=i;
              l_CDS.FieldByName('select').AsBoolean:=False;
              l_CDS.FieldByName('isprn').AsBoolean:=False;
              l_CDS.FieldByName('rvu03').AsDateTime:=FieldByName('rvu03').AsDateTime;
              l_CDS.FieldByName('rvu01').AsString:=FieldByName('rvu01').AsString;
              l_CDS.FieldByName('rvu02').AsString:=FieldByName('rvu02').AsString;
              l_CDS.FieldByName('rvu08').AsString:=GetRVU08(FieldByName('rvu08').AsString);
              l_CDS.FieldByName('rvu04').AsString:=FieldByName('rvu04').AsString;
              l_CDS.FieldByName('rvu05').AsString:=FieldByName('rvu05').AsString;
              l_CDS.FieldByName('rvu06').AsString:=FieldByName('rvu06').AsString;
              l_CDS.FieldByName('gem02').AsString:=FieldByName('gem02').AsString;
              l_CDS.FieldByName('rvu07').AsString:=FieldByName('rvu07').AsString;
              l_CDS.FieldByName('gen02').AsString:=FieldByName('gen02').AsString;
              l_CDS.Post;
              Inc(i);
            end;
            tmpId:=FieldByName('rvu01').AsString;
            Next;
          end;

          //列印記錄
          if Length(tmpSQL)>0 then
          begin
            Delete(tmpSQL,1,1);
            Data:=null;
            tmpSQL:='select rvu01 from dli049 where bu='+Quotedstr(g_UInfo^.BU)
                   +' and rvu01 in ('+tmpSQL+')';
            if QueryBySQL(tmpSQL, Data) then
            begin
              tmpCDS2.Data:=Data;
              while not tmpCDS2.Eof do
              begin
                if l_CDS.Locate('rvu01',tmpCDS2.FieldByName('rvu01').AsString,[]) then
                begin
                  l_CDS.Edit;
                  l_CDS.FieldByName('isprn').AsBoolean:=True;
                  l_CDS.Post;
                end;
                tmpCDS2.Next;
              end;
            end;
          end;

          if l_prnIndex<>2 then
          begin
            with l_CDS do
            begin
              if l_prnIndex=0 then
              begin
                Filtered:=False;
                Filter:='isprn=1';
                Filtered:=True;
              end else
              begin
                Filtered:=False;
                Filter:='isprn=0';
                Filtered:=True;
              end;

              while not IsEmpty do
                Delete;
              Filtered:=False;
              Filter:='';
            end;
          end;

          if tmpCDS1.ChangeCount>0 then
             tmpCDS1.MergeChangeLog;
          l_dataCDS.Data:=tmpCDS1.Data;

          if l_CDS.ChangeCount>0 then
             l_CDS.MergeChangeLog;
          CDS.Data:=l_CDS.Data;
        finally
          FreeAndNil(tmpCDS1);
          FreeAndNil(tmpCDS2);
        end;
      end;
    finally
      g_StatusBar.Panels[0].Text:='';
    end;
  end;

  inherited;
end;

function TFrmDLIR280.GetRVU08(rvu08:string):string;
var
  str:string;
begin
  if SameText(rvu08,'REG') then
     str:=CheckLang(' 原物料')
  else if SameText(rvu08,'EXP') then
     str:=CheckLang(' 費用')
  else if SameText(rvu08,'CAP') then
     str:=CheckLang(' 資產')
  else if SameText(rvu08,'RTN') then
     str:=CheckLang(' 退補貨');

  Result:=rvu08+str;
end;

procedure TFrmDLIR280.FormCreate(Sender: TObject);
begin
  p_SysId:='DLI';
  p_TableName:='DLIR280';
  p_GridDesignAns:=True;

  l_dataCDS:=TClientDataSet.Create(nil);
  l_CDS:=TClientDataSet.Create(nil);
  InitCDS(l_CDS,l_xml);
  
  inherited;
  
  SetGrdCaption(DBGridEh2, p_TableName);
  DS2.DataSet:=l_dataCDS;
end;

procedure TFrmDLIR280.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DS2.DataSet:=nil;
  FreeAndNil(l_dataCDS);
  FreeAndNil(l_CDS);
  DBGridEh2.Free;
end;

procedure TFrmDLIR280.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR280_Query) then
     FrmDLIR280_Query:=TFrmDLIR280_Query.Create(Application);
  if FrmDLIR280_Query.ShowModal=mrOK then
  begin
    l_prnIndex:=FrmDLIR280_Query.rgp2.ItemIndex;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(FrmDLIR280_Query.l_QueryStr);
  end;
end;

procedure TFrmDLIR280.btn_printClick(Sender: TObject);
var
  i,j:Integer;
  tmp04,tmp06,tmp08:string; //廠商、部門、採購性質
  ArrPrintData:TArrPrintData;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  //inherited;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=CDS.Data;
    tmpCDS1.Filter:='select=1';
    tmpCDS1.Filtered:=True;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('請選擇列印單據!',48);
      Exit;
    end;

    tmp04:=tmpCDS1.FieldByName('rvu04').AsString;
    tmp06:=tmpCDS1.FieldByName('rvu06').AsString;
    tmp08:=tmpCDS1.FieldByName('rvu08').AsString;
    tmpCDS2.Data:=l_dataCDS.Data;

    j:=1;
    l_CDS.EmptyDataSet;
    while not tmpCDS1.Eof do
    begin
      if tmp04<>tmpCDS1.FieldByName('rvu04').AsString then
      begin
        ShowMsg('所選單據[廠商]不同,不可列印',48);
        Exit;
      end;

//      if tmp06<>tmpCDS1.FieldByName('rvu06').AsString then
//      begin
//        ShowMsg('所選單據[部門]不同,不可列印',48);
//        Exit;
//      end;

      if tmp08<>tmpCDS1.FieldByName('rvu08').AsString then
      begin
        ShowMsg('所選單據[採購性質]不同,不可列印',48);
        Exit;
      end;

      tmpCDS2.Filtered:=False;
      tmpCDS2.Filter:='rvv01='+Quotedstr(tmpCDS1.FieldByName('rvu01').AsString);
      tmpCDS2.Filtered:=True;
      tmpCDS2.IndexFieldNames:='rvv01;rvv02';
      while not tmpCDS2.Eof do
      begin
        if l_CDS.Locate('rvu01;rvu02;rvv31;rvv32;rvv36;rvv37',
          VarArrayOf([tmpCDS2.FieldByName('rvu01').AsString,
                      tmpCDS2.FieldByName('rvu02').AsString,
                      tmpCDS2.FieldByName('rvv31').AsString,
                      tmpCDS2.FieldByName('rvv32').AsString,
                      tmpCDS2.FieldByName('rvv36').AsString,
                      tmpCDS2.FieldByName('rvv37').AsInteger]),[]) then  //單號、料號、倉庫、採購單號相同，數量合併
        begin
          l_CDS.Edit;
          l_CDS.FieldByName('rvv17').AsFloat:=l_CDS.FieldByName('rvv17').AsFloat+tmpCDS2.FieldByName('rvv17').AsFloat;
          l_CDS.Post;
        end else
        begin
          l_CDS.Append;
          for i:=3 to l_CDS.FieldCount-1 do  //0:sno 1:select 2:isprn
            l_CDS.Fields[i].Value:=tmpCDS2.FieldByName(l_CDS.Fields[i].FieldName).Value;
          l_CDS.FieldByName('sno').AsInteger:=j;
          l_CDS.FieldByName('rvu07').AsString:=g_UInfo^.UserId;
          l_CDS.FieldByName('gen02').AsString:=g_UInfo^.UserName;
          l_CDS.FieldByName('rvu08').AsString:=tmp08;
          l_CDS.Post;
          Inc(j);
        end;

        tmpCDS2.Next;
      end;

      tmpCDS1.Next;
    end;
    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:='sno';
  ArrPrintData[0].Filter:='';
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmDLIR280.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  if CDS.IsEmpty then
     CDSAfterScroll(CDS);
end;

procedure TFrmDLIR280.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if l_dataCDS.Active then
  begin
    l_dataCDS.Filtered:=False;
    l_dataCDS.Filter:='rvv01='+Quotedstr(CDS.FieldByName('rvu01').AsString);
    l_dataCDS.Filtered:=True;
    l_dataCDS.IndexFieldNames:='rvv01;rvv02';
  end;
end;

procedure TFrmDLIR280.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpSQL:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    CDS.Edit;
    CDS.FieldByName('select').AsBoolean:=not CDS.FieldByName('select').AsBoolean;
    CDS.Post;
    CDS.MergeChangeLog;
  end else
  if SameText(Column.FieldName,'isprn') then
  begin
    tmpSQL:='delete from dli049 where bu='+Quotedstr(g_UInfo^.BU)
           +' and rvu01='+Quotedstr(CDS.FieldByName('rvu01').AsString);
    if not CDS.FieldByName('isprn').AsBoolean then
       tmpSQL:=tmpSQL+' insert into dli049(bu,rvu01,iuser,idate)'
                     +' values('+Quotedstr(g_UInfo^.BU)+','+Quotedstr(CDS.FieldByName('rvu01').AsString)+','+Quotedstr(g_UInfo^.UserId)+',getdate())';
    if PostBySQL(tmpSQL) then
    begin
      CDS.Edit;
      CDS.FieldByName('isprn').AsBoolean:=not CDS.FieldByName('isprn').AsBoolean;
      CDS.Post;
      CDS.MergeChangeLog;
    end;
  end;
end;

procedure TFrmDLIR280.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
