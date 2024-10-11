{*******************************************************}
{                                                       }
{                unMPSR200                              }
{                Author: kaikai                         }
{                Create date: 2020/5/19                 }
{                Description: CCL生產并包明細表         }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR200;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, StrUtils;

type
  TFrmMPSR200 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    DBGridEh2: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS1,l_CDS2:TClientDataSet;
    procedure GetDS1(D1,D2:TDateTime);
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmMPSR200: TFrmMPSR200;

implementation

uses unGlobal, unCommon, unMPSR200_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="qdate" fieldtype="DateTime"/>'
           +'<FIELD attrname="sdate" fieldtype="DateTime"/>'
           +'<FIELD attrname="machine" fieldtype="string" width="10"/>'
           +'<FIELD attrname="wono" fieldtype="string" width="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" width="30"/>'
           +'<FIELD attrname="sqty" fieldtype="r8"/>'
           +'<FIELD attrname="ordqty1" fieldtype="r8"/>'
           +'<FIELD attrname="custno" fieldtype="string" width="20"/>'
           +'<FIELD attrname="custom" fieldtype="string" width="30"/>'
           +'<FIELD attrname="tc_sid110" fieldtype="string" width="10"/>'
           +'<FIELD attrname="depot" fieldtype="string" width="20"/>'
           +'<FIELD attrname="area" fieldtype="string" width="20"/>'
           +'<FIELD attrname="lot" fieldtype="string" width="20"/>'
           +'<FIELD attrname="ta_img05" fieldtype="string" width="40"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="ordqty2" fieldtype="r8"/>'
           +'<FIELD attrname="remark" fieldtype="string" width="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMPSR200.GetDS1(D1,D2:TDateTime);
var
  isD1,isD2,tmpFlag1,tmpFlag2:Boolean;
  tmpSQL,tmpWono,qryD1,qryD2,tmpORADB:string;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  Data:OleVariant;
  tmpList:TStrings;
  mil:Double;

  procedure AddData;
  begin
    if isD1 then
    begin
      with l_CDS1 do
      begin
        Append;
        if tmpFlag1 then
        begin
          FieldByName('qdate').AsDateTime:=D1;
          FieldByName('sdate').AsDateTime:=tmpCDS1.FieldByName('sdate').AsDateTime;
          FieldByName('machine').AsString:=tmpCDS1.FieldByName('machine').AsString;
          FieldByName('wono').AsString:=tmpCDS1.FieldByName('wono').AsString;
          FieldByName('pno').AsString:=tmpCDS1.FieldByName('pno').AsString;
          FieldByName('sqty').AsFloat:=tmpCDS1.FieldByName('sqty').AsFloat;
          FieldByName('ordqty1').AsFloat:=tmpCDS1.FieldByName('orderqty').AsFloat;
          FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
          FieldByName('custom').AsString:=tmpCDS1.FieldByName('custom').AsString;
          if tmpCDS3.Locate('shb05',FieldByName('wono').AsString,[]) then
             FieldByName('tc_sid110').AsString:=tmpCDS3.FieldByName('tc_sid110').AsString;
        end;
        FieldByName('ordqty2').AsFloat:=tmpCDS2.FieldByName('oeb12').AsFloat;
        FieldByName('depot').AsString:=tmpCDS2.FieldByName('img02').AsString;
        FieldByName('area').AsString:=tmpCDS2.FieldByName('img03').AsString;
        FieldByName('lot').AsString:=tmpCDS2.FieldByName('img04').AsString;
        FieldByName('ta_img05').AsString:=LeftStr(tmpCDS2.FieldByName('ta_img05').AsString,1);
        FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
        Post;
      end;
      tmpFlag1:=False;
    end;

    if isD2 then
    begin
      with l_CDS2 do
      begin
        Append;
        if tmpFlag2 then
        begin
          FieldByName('qdate').AsDateTime:=D2;
          FieldByName('sdate').AsDateTime:=tmpCDS1.FieldByName('sdate').AsDateTime;
          FieldByName('machine').AsString:=tmpCDS1.FieldByName('machine').AsString;
          FieldByName('wono').AsString:=tmpCDS1.FieldByName('wono').AsString;
          FieldByName('pno').AsString:=tmpCDS1.FieldByName('pno').AsString;
          FieldByName('sqty').AsFloat:=tmpCDS1.FieldByName('sqty').AsFloat;
          FieldByName('ordqty1').AsFloat:=tmpCDS1.FieldByName('orderqty').AsFloat;
          FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
          FieldByName('custom').AsString:=tmpCDS1.FieldByName('custom').AsString;
          if tmpCDS3.Locate('shb05',FieldByName('wono').AsString,[]) then
             FieldByName('tc_sid110').AsString:=tmpCDS3.FieldByName('tc_sid110').AsString;          
        end;
        FieldByName('ordqty2').AsFloat:=tmpCDS2.FieldByName('oeb12').AsFloat;
        FieldByName('depot').AsString:=tmpCDS2.FieldByName('img02').AsString;
        FieldByName('area').AsString:=tmpCDS2.FieldByName('img03').AsString;
        FieldByName('lot').AsString:=tmpCDS2.FieldByName('img04').AsString;
        FieldByName('ta_img05').AsString:=LeftStr(tmpCDS2.FieldByName('ta_img05').AsString,1);
        FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
        Post;
      end;
    end;
    tmpFlag2:=False;
  end;

begin
  g_StatusBar.Panels[0].Text:='正在查詢排程資料,請等待...';
  Application.ProcessMessages;
  l_CDS1.EmptyDataSet;
  l_CDS2.EmptyDataSet;
  tmpList:=TStringList.Create;
  try
    if D1>EncodeDate(2015,1,1) then
    begin
      qryD1:=StringReplace(FormatDateTime('YYYY-MM-DD',D1),'/','-',[rfReplaceAll]);
      qryD2:=StringReplace(FormatDateTime('YYYY-MM-DD',D2),'/','-',[rfReplaceAll]);
      tmpSQL:='select machine,sdate,wono,materialno as pno,sqty,'
             +' orderqty,custno,custom,wostation_d2str'
             +' from mps010 where bu=''ITEQDG'' and wostation>=3 and wostation<=6'
             +' and (charindex('+Quotedstr(qryD1)+',wostation_d2str)>0'
             +' or charindex('+Quotedstr(qryD2)+',wostation_d2str)>0)';
      if SameText(g_UInfo^.BU,'ITEQDG') then
      begin
        tmpORADB:='ORACLE';
        tmpSQL:=tmpSQL+' and machine<>''L6''';
      end else
      begin
        tmpORADB:='ORACLE1';
        tmpSQL:=tmpSQL+' and machine=''L6''';
      end;
      tmpSQL:=tmpSQL+' order by machine,jitem,oz,materialno,simuver,citem';
      if not QueryBySQL(tmpSQL,Data) then
         Exit;

      tmpCDS1:=TClientDataSet.Create(nil);
      tmpCDS2:=TClientDataSet.Create(nil);
      tmpCDS3:=TClientDataSet.Create(nil);
      try
        tmpCDS1.Data:=Data;
        if tmpCDS1.IsEmpty then
           Exit;

        tmpSQL:='';
        tmpWono:='';
        while not tmpCDS1.Eof do
        begin
          if (Length(Trim(tmpCDS1.FieldByName('pno').AsString))>0) and
             (Pos(tmpCDS1.FieldByName('pno').AsString,tmpSQL)=0) then
             tmpSQL:=tmpSQL+','+Quotedstr(tmpCDS1.FieldByName('pno').AsString);

          if (Length(Trim(tmpCDS1.FieldByName('wono').AsString))>0) and
             (Pos(tmpCDS1.FieldByName('wono').AsString,tmpWono)=0) then
             tmpWono:=tmpWono+','+Quotedstr(tmpCDS1.FieldByName('wono').AsString);

          tmpCDS1.Next;
        end;

        if (Length(tmpSQL)=0) or (Length(tmpWono)=0) then
           Exit;

        //庫存量<>訂單量(批號->工單->訂單)
        g_StatusBar.Panels[0].Text:='正在查詢庫存資料,請等待...';
        Application.ProcessMessages;
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpSQL:='select distinct img01,img02,img03,img04,ta_img05,img10,oeb12'
               +' from img_file,tc_sih_file,shb_file,sfb_file,oeb_file'
               +' where substr(img04,1,10)=substr(tc_sih02,1,10)'
               +' and tc_sih01=shb01 and shb05=sfb01 and sfb22=oeb01 and sfb221=oeb03'
               +' and img01 in ('+tmpSQL+') and img02 in (''Y0A00'',''N0A00'',''N3A18'')'
               +' and img10>0 and img10<>oeb12'
               +' order by img01,substr(img04,2,4)';
        if not QueryBySQL(tmpSQL,Data,tmpORADB) then
           Exit;

        tmpCDS2.Data:=Data;
        if tmpCDS2.IsEmpty then
           Exit;

        //報工銅箔
        g_StatusBar.Panels[0].Text:='正在查詢報工銅箔,請等待...';
        Application.ProcessMessages;
        Delete(tmpWono,1,1);
        Data:=null;
        tmpSQL:='select shb05,tc_sid110 from shb_file,tc_sid_file'
               +' where shb01=tc_sid01 and shb05 in ('+tmpWono+')'
               +' and shb06=3 and shbacti=''Y''';
        if not QueryBySQL(tmpSQL,Data,tmpORADB) then
           Exit;

        tmpCDS3.Data:=Data;
        if tmpCDS3.IsEmpty then
           Exit;

        g_StatusBar.Panels[0].Text:='正在計算結果,請等待...';
        Application.ProcessMessages;
        g_ProgressBar.Position:=0;
        g_ProgressBar.Max:=tmpCDS1.RecordCount;
        g_ProgressBar.Visible:=True;
        tmpCDS1.First;
        while not tmpCDS1.Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;
          Application.ProcessMessages;

          tmpList.DelimitedText:=tmpCDS1.FieldByName('wostation_d2str').AsString;
          isD1:=(tmpList.Count>=3) and (LeftStr(tmpList.Strings[2],10)=qryD1);
          isD2:=(tmpList.Count>=5) and (LeftStr(tmpList.Strings[4],10)=qryD2);
          if isD1 or isD2 then
          begin
            mil:=StrToIntDef(RightStr(LeftStr(tmpCDS1.FieldByName('pno').AsString,6),4),0)/10; //條數
            if mil>0 then
            begin
              tmpFlag1:=True;
              tmpFlag2:=True;
              tmpCDS2.Filtered:=False;
              tmpCDS2.Filter:='img01='+Quotedstr(tmpCDS1.FieldByName('pno').AsString);
              tmpCDS2.Filtered:=True;
              while not tmpCDS2.Eof do
              begin
                if mil<12 then
                begin
                  if tmpCDS2.FieldByName('img10').AsInteger<30 then //<12mil 30SH一包
                     AddData;
                end else
                if mil<=24 then
                begin
                  if tmpCDS2.FieldByName('img10').AsInteger<20 then //12~24mil 20SH一包
                     AddData;
                end else
                if mil<=36 then
                begin
                  if tmpCDS2.FieldByName('img10').AsInteger<15 then //25~36mil 15SH一包
                     AddData;
                end else
                if mil<=62 then
                begin
                  if tmpCDS2.FieldByName('img10').AsInteger<10 then //37~62mil 10SH一包
                     AddData;
                end else
                begin
                  if tmpCDS2.FieldByName('img10').AsInteger<5 then  //>62mil 5SH一包
                     AddData;
                end;

                tmpCDS2.Next;
              end;
            end;
          end;
          tmpCDS1.Next;
        end;

      finally
        FreeAndNil(tmpCDS1);
        FreeAndNil(tmpCDS2);
        FreeAndNil(tmpCDS3);
      end;
    end;
  finally
    if l_CDS1.ChangeCount>0 then
       l_CDS1.MergeChangeLog;
    if l_CDS2.ChangeCount>0 then
       l_CDS2.MergeChangeLog;
    CDS.Data:=l_CDS1.Data;
    CDS2.Data:=l_CDS2.Data;
    FreeAndNil(tmpList);
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmMPSR200.RefreshDS(strFilter: string);
begin
  GetDS1(EncodeDate(1955,5,5), Date);

  inherited;
end;

procedure TFrmMPSR200.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR200';
  p_GridDesignAns:=False;
  l_CDS1:=TClientDataSet.Create(Self);
  l_CDS2:=TClientDataSet.Create(Self);
  InitCDS(l_CDS1, l_xml);
  l_CDS2.Data:=l_CDS1.Data;

  inherited;

  TabSheet1.Caption:=CheckLang('組合站');
  TabSheet20.Caption:=CheckLang('裁邊站');
  SetGrdCaption(DBGridEh2, 'MPSR200');
end;

procedure TFrmMPSR200.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
end;

procedure TFrmMPSR200.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出['+TabSheet1.Caption+']請按[是]'+#13#10+'匯出['+TabSheet20.Caption+']請按[否]'+#13#10+'[取消]無操作',35) of
    IdYes:GetExportXls(CDS, 'MPSR200');
    IdNo:GetExportXls(CDS2, 'MPSR200');
  end;
end;

procedure TFrmMPSR200.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR200_query) then
     FrmMPSR200_query:=TFrmMPSR200_query.Create(Application);
  if FrmMPSR200_query.ShowModal=mrOK then
     GetDS1(FrmMPSR200_query.dtp1.Date, FrmMPSR200_query.dtp2.Date);
end;

end.

