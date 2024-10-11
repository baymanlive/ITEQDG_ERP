{*******************************************************}
{                                                       }
{                unDLIR270                              }
{                Author: kaikai                         }
{                Create date: 2020/9/2                  }
{                Description: HDI料號庫存管理表         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR270;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Math, DateUtils;

type
  TFrmDLIR270 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR270: TFrmDLIR270;

implementation

uses unGlobal, unCommon;

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

procedure TFrmDLIR270.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR270';
  p_GridDesignAns:=True;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS,l_xml);

  inherited;
end;

procedure TFrmDLIR270.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR270.RefreshDS(strFilter: string);
var
  m:Integer;
  tmpSQL,tmpFilter1,tmpFilter2,tmpFname,tmpLot,tmpImg02:string;
  tmpDate:TDateTime;
  Data1:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  l_CDS.EmptyDataSet;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  if strFilter=g_cFilterNothing then
     CDS.Data:=l_CDS.Data
  else begin
    //庫別
    tmpSQL:='select [id]=stuff((select '',''+[id] from dli029 where bu=''ITEQDG'' for xml path('''')),1,1,'''')';
    if not QueryOneCR(tmpSQL, Data1) then
       Exit;
    if not VarIsNull(Data1) then
       tmpImg02:=VarToStr(Data1);
    if Length(tmpImg02)=0 then
       tmpImg02:='@';

    Data1:=null;
    tmpSQL:='select pno,qty from dli080 where bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data1) then
       Exit;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢資料,請待待...');
    Application.ProcessMessages;
    try
      tmpCDS1.Data:=Data1;
      if tmpCDS1.IsEmpty then
      begin
        CDS.Data:=l_CDS.Data;
        inherited;
        Exit;
      end;

      with tmpCDS1 do
      begin
        while not Eof do
        begin
          l_CDS.Append;
          l_CDS.FieldByName('pno').AsString:=FieldByName('pno').AsString;
          l_CDS.FieldByName('dg').AsFloat:=0;
          l_CDS.FieldByName('gz').AsFloat:=0;
          l_CDS.FieldByName('jx').AsFloat:=0;
          l_CDS.FieldByName('b').AsFloat:=FieldByName('qty').AsFloat;
          l_CDS.FieldByName('c').AsFloat:=0;
          l_CDS.FieldByName('d').AsFloat:=-FieldByName('qty').AsFloat;
          l_CDS.Post;

          Next;
        end;

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
            Data1:=null;
            tmpSQL:='select bu,img01 pno,img04 lot,sum(img10) qty from('
                   +' select ''dg'' as bu,img01,img04,img10 from iteqdg.img_file where img10>0 and ('+tmpFilter1+')'
                   +' and instr('+Quotedstr(tmpImg02)+',img02)>0'
                   +' union all'
                   +' select ''gz'' as bu,img01,img04,img10 from iteqgz.img_file where img10>0 and ('+tmpFilter1+')'
                   +' and instr('+Quotedstr(tmpImg02)+',img02)>0'
                   +' union all'
                   +' select ''jx'' as bu,img01,img04,img10 from iteqjx.img_file where img10>0 and ('+tmpFilter1+')'
                   +' and instr('+Quotedstr(tmpImg02)+',img02)>0) t group by bu,img01,img04';
            if not QueryBySQL(tmpSQL, Data1, 'ORACLE') then
               Exit;

            tmpCDS2.Data:=Data1;
            l_CDS.First;
            while not l_CDS.Eof do
            begin
              tmpCDS2.Filtered:=False;
              tmpCDS2.Filter:='pno like '+Quotedstr(l_CDS.FieldByName('pno').AsString+'%');
              tmpCDS2.Filtered:=True;
              while not tmpCDS2.Eof do
              begin
                tmpFname:=tmpCDS2.FieldByName('bu').AsString;

                tmpLot:=Copy(tmpCDS2.FieldByName('lot').AsString,2,4);
                if Length(tmpLot)=4 then
                begin
                  tmpDate:=GetLotDate(tmpLot,Date);
                  if Pos(Copy(tmpCDS2.FieldByName('lot').AsString,1,1),'ET')=0 then //PP有效期3個月內(90天)
                  begin
                    if DaysBetween(tmpDate,Date)>90 then
                    begin
                      tmpCDS2.Next;
                      Continue;
                    end;
                  end else //CCL有效期6個月內(180天)
                  begin
                    if DaysBetween(tmpDate,Date)>180 then
                    begin
                      tmpCDS2.Next;
                      Continue;
                    end;
                  end;

                  l_CDS.Edit;
                  l_CDS.FieldByName(tmpFname).AsFloat:=l_CDS.FieldByName(tmpFname).AsFloat+tmpCDS2.FieldByName('qty').AsFloat;
                  l_CDS.FieldByName('d').AsFloat:=RoundTo(l_CDS.FieldByName('dg').AsFloat+l_CDS.FieldByName('gz').AsFloat+l_CDS.FieldByName('jx').AsFloat-l_CDS.FieldByName('b').AsFloat-l_CDS.FieldByName('c').AsFloat,-3);
                  l_CDS.Post;
                end;

                tmpCDS2.Next;
              end;

              l_CDS.Next;
            end;
            tmpCDS2.Filtered:=False;
            tmpCDS2.Filter:='';

            System.Delete(tmpFilter2,1,4);
            Data1:=null;
            tmpSQL:='select oeb04 pno,sum(qty) qty from('
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
            if not QueryBySQL(tmpSQL, Data1, 'ORACLE') then
               Exit;

            tmpCDS2.Data:=Data1;
            l_CDS.First;
            while not l_CDS.Eof do
            begin
              tmpCDS2.Filtered:=False;
              tmpCDS2.Filter:='pno like '+Quotedstr(l_CDS.FieldByName('pno').AsString+'%');
              tmpCDS2.Filtered:=True;
              while not tmpCDS2.Eof do
              begin
                m:=1;
                if Pos(Copy(tmpCDS2.FieldByName('pno').AsString,1,1),'BR')>0 then
                   m:=StrToInt(Copy(tmpCDS2.FieldByName('pno').AsString,11,3));
                l_CDS.Edit;
                l_CDS.FieldByName('c').AsFloat:=l_CDS.FieldByName('c').AsFloat+tmpCDS2.FieldByName('qty').AsFloat*m;
                l_CDS.FieldByName('d').AsFloat:=RoundTo(l_CDS.FieldByName('dg').AsFloat+l_CDS.FieldByName('gz').AsFloat+l_CDS.FieldByName('jx').AsFloat-l_CDS.FieldByName('b').AsFloat-l_CDS.FieldByName('c').AsFloat,-3);
                l_CDS.Post;
                tmpCDS2.Next;
              end;

              l_CDS.Next;
            end;
            tmpCDS2.Filtered:=False;
            tmpCDS2.Filter:='';
            tmpFilter1:='';
            tmpFilter2:='';
          end;
        end;
      end;

      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
      CDS.Data:=l_CDS.Data;   

    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      g_StatusBar.Panels[0].Text:='';
    end;
  end;
  
  inherited;
end;

procedure TFrmDLIR270.btn_queryClick(Sender: TObject);
begin
  //inherited;
  RefreshDS('1');
end;

end.
