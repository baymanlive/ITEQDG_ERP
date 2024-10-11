unit unMPSR230;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils;

type
  TFrmMPSR230 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    procedure GetDS(D1,D2:TDateTime; wono:string);
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR230: TFrmMPSR230;

implementation

uses unGlobal, unCommon, unMPSR230_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="wono" fieldtype="string" width="20"/>'
           +'<FIELD attrname="sdate" fieldtype="DateTime"/>'
           +'<FIELD attrname="img01" fieldtype="string" width="30"/>'
           +'<FIELD attrname="ima02" fieldtype="string" width="200"/>'
           +'<FIELD attrname="ima021" fieldtype="string" width="200"/>'
           +'<FIELD attrname="img02" fieldtype="string" width="30"/>'
           +'<FIELD attrname="img03" fieldtype="string" width="30"/>'
           +'<FIELD attrname="img04" fieldtype="string" width="30"/>'
           +'<FIELD attrname="img10" fieldtype="r8"/>'
           +'<FIELD attrname="sqty" fieldtype="r8"/>'
           +'<FIELD attrname="inqty" fieldtype="r8"/>'
           +'<FIELD attrname="diffqty" fieldtype="r8"/>'
           +'<FIELD attrname="custno" fieldtype="string" width="20"/>'
           +'<FIELD attrname="custom" fieldtype="string" width="30"/>'
           +'<FIELD attrname="orderno" fieldtype="string" width="20"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="units" fieldtype="string" width="20"/>'
           +'<FIELD attrname="adate" fieldtype="DateTime"/>'
           +'<FIELD attrname="ordqty" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="notqty" fieldtype="r8"/>'
           +'<FIELD attrname="ta_img01" fieldtype="string" width="100"/>'
           +'<FIELD attrname="ta_img03" fieldtype="string" width="100"/>'
           +'<FIELD attrname="ta_img04" fieldtype="string" width="100"/>'
           +'<FIELD attrname="ta_img05" fieldtype="string" width="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMPSR230.GetDS(D1,D2:TDateTime; wono:string);
var
  isDG:Boolean;
  tmpSQL,tmpORADB,tmpFilter:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  g_StatusBar.Panels[0].Text:='正在查詢工單資料,查詢過程較慢,請等待...';
  Application.ProcessMessages;
  l_CDS.EmptyDataSet;
  try
    if D1>EncodeDate(2015,1,1) then
    begin
      isDG:=SameText(g_UInfo^.BU,'ITEQDG');
      tmpSQL:=StringReplace(Quotedstr(FormatDateTime(g_cShortDate1,D1))+' and '+Quotedstr(FormatDateTime(g_cShortDate1,D2)),'-','/',[rfReplaceAll]);
      if Length(wono)>0 then
         tmpSQL:=tmpSQL+' and sfb01='+Quotedstr(wono);

      tmpSQL:='select e.*,ima02,ima021 from('
             +' select d.*,occ02 from('
             +' select c.*,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05 from('
             +' select b.*,oeb05,oeb12,oeb24,oeb12-oeb24 notqty from('
             +' select a.*,oea04 from('
             +' select sfb01,sfb81,sfb05,sfb08,sfb09,sfb08-sfb09 diffqty,sfb22,sfb221'
             +' from sfb_file where to_char(sfb81,''YYYY/MM/DD'') between '+tmpSQL
             +' and substr(sfb05,1,1) in (''B'',''R'',''E'',''T'')) a,oea_file'
             +' where sfb22=oea01) b,oeb_file'
             +' where sfb22=oeb01 and sfb221=oeb03) c,img_file'
             +' where sfb05=img01 and img02 in (''D3A17'',''N3A18'',''Y0A00'',''N0A00'',''Y0AM0'',''N0AM0'',''Y1A00'',''N1A00'',''Y2AF0'',''N2AF0'')'
             +' and sfb01=img12 and img10>0) d,occ_file'
             +' where oea04=occ01) e,ima_file'
             +' where sfb05=ima01';
      if isDG then
         tmpORADB:='ORACLE'
      else
         tmpORADB:='ORACLE1';
      if not QueryBySQL(tmpSQL,Data,tmpORADB) then
         Exit;

      tmpCDS1:=TClientDataSet.Create(nil);
      tmpCDS2:=TClientDataSet.Create(nil);
      try
        tmpCDS1.Data:=Data;
        if tmpCDS1.IsEmpty then
           Exit;

        tmpSQL:='';
        while not tmpCDS1.Eof do
        begin
          if Pos(tmpCDS1.FieldByName('sfb01').AsString,tmpSQL)=0 then
             tmpSQL:=tmpSQL+','+Quotedstr(tmpCDS1.FieldByName('sfb01').AsString);

          tmpCDS1.Next;
        end;

        g_StatusBar.Panels[0].Text:='正在查詢交期資料,請等待...';
        Application.ProcessMessages;
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpFilter:=' where bu=''ITEQDG'' and sdate>getdate()-365 and wono in ('+tmpSQL+')';
        tmpSQL:='select wono,adate_new from mps010 '+tmpFilter;
        if isDG then
           tmpSQL:=tmpSQL+' and machine<>''L6'''
        else
           tmpSQL:=tmpSQL+' and machine=''L6''';

        tmpSQL:=tmpSQL+' union all';
        tmpSQL:=tmpSQL+' select wono,adate_new from MPS010_20160409 '+tmpFilter;
        if isDG then
           tmpSQL:=tmpSQL+' and machine<>''L6'''
        else
           tmpSQL:=tmpSQL+' and machine=''L6''';

        tmpSQL:=tmpSQL+' union all';
        tmpSQL:=tmpSQL+' select wono,adate_new from mps070 '+tmpFilter;
        if isDG then
           tmpSQL:=tmpSQL+' and machine in (''T1'',''T2'',''T3'',''T4'',''T5'')'
        else
           tmpSQL:=tmpSQL+' and machine in (''T6'',''T7'',''T8'')';

        tmpSQL:=tmpSQL+' union all';
        tmpSQL:=tmpSQL+' select wono,adate_new from MPS070_bak '+tmpFilter;
        if isDG then
           tmpSQL:=tmpSQL+' and machine in (''T1'',''T2'',''T3'',''T4'',''T5'')'
        else
           tmpSQL:=tmpSQL+' and machine in (''T6'',''T7'',''T8'')';
        
        if not QueryBySQL(tmpSQL,Data) then
           Exit;

        tmpCDS2.Data:=Data;

        g_StatusBar.Panels[0].Text:='正在處理結果,請等待...';
        Application.ProcessMessages;
        g_ProgressBar.Position:=0;
        g_ProgressBar.Max:=tmpCDS1.RecordCount;
        g_ProgressBar.Visible:=True;
        tmpCDS1.First;
        while not tmpCDS1.Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;
          Application.ProcessMessages;

          with l_CDS do
          begin
            Append;
            FieldByName('wono').AsString:=tmpCDS1.FieldByName('sfb01').AsString;
            FieldByName('sdate').AsDateTime:=tmpCDS1.FieldByName('sfb81').AsDateTime;
            FieldByName('img01').AsString:=tmpCDS1.FieldByName('sfb05').AsString;
            FieldByName('ima02').AsString:=tmpCDS1.FieldByName('ima02').AsString;
            FieldByName('ima021').AsString:=tmpCDS1.FieldByName('ima021').AsString;
            FieldByName('img02').AsString:=tmpCDS1.FieldByName('img02').AsString;
            FieldByName('img03').AsString:=tmpCDS1.FieldByName('img03').AsString;
            FieldByName('img04').AsString:=tmpCDS1.FieldByName('img04').AsString;
            FieldByName('img10').AsFloat:=tmpCDS1.FieldByName('img10').AsFloat;
            FieldByName('ta_img01').AsString:=tmpCDS1.FieldByName('ta_img01').AsString;
            FieldByName('ta_img03').AsString:=tmpCDS1.FieldByName('ta_img03').AsString;
            FieldByName('ta_img04').AsString:=tmpCDS1.FieldByName('ta_img04').AsString;
            FieldByName('ta_img05').AsString:=tmpCDS1.FieldByName('ta_img05').AsString;
            FieldByName('sqty').AsFloat:=tmpCDS1.FieldByName('sfb08').AsFloat;
            FieldByName('inqty').AsFloat:=tmpCDS1.FieldByName('sfb09').AsFloat;
            FieldByName('diffqty').AsFloat:=tmpCDS1.FieldByName('diffqty').AsFloat;
            FieldByName('custno').AsString:=tmpCDS1.FieldByName('oea04').AsString;
            FieldByName('custom').AsString:=tmpCDS1.FieldByName('occ02').AsString;
            FieldByName('orderno').AsString:=tmpCDS1.FieldByName('sfb22').AsString;
            FieldByName('orderitem').AsString:=tmpCDS1.FieldByName('sfb221').AsString;
            FieldByName('units').AsString:=tmpCDS1.FieldByName('oeb05').AsString;
            FieldByName('ordqty').AsFloat:=tmpCDS1.FieldByName('oeb12').AsFloat;
            FieldByName('outqty').AsFloat:=tmpCDS1.FieldByName('oeb24').AsFloat;
            FieldByName('notqty').AsFloat:=tmpCDS1.FieldByName('notqty').AsFloat;
            if tmpCDS2.Locate('wono',FieldByName('wono').AsString,[]) then
               FieldByName('adate').AsDateTime:=tmpCDS2.FieldByName('adate_new').AsDateTime;
            Post;
          end;

          tmpCDS1.Next;
        end;

      finally
        FreeAndNil(tmpCDS1);
        FreeAndNil(tmpCDS2);
      end;
    end;
  finally
    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
    CDS.Data:=l_CDS.Data;
    CDS.IndexFieldNames:='sdate;wono;custno;orderno;orderitem';
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmMPSR230.RefreshDS(strFilter: string);
begin
  GetDS(EncodeDate(1955,5,5), Date, '@');

  inherited;
end;

procedure TFrmMPSR230.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR230';
  p_GridDesignAns:=False;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_xml);

  inherited;
end;

procedure TFrmMPSR230.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR230.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmMPSR230_query) then
     FrmMPSR230_query:=TFrmMPSR230_query.Create(Application);
  if FrmMPSR230_query.ShowModal=mrOK then
     GetDS(FrmMPSR230_query.dtp1.Date, FrmMPSR230_query.dtp2.Date, UpperCase(Trim(FrmMPSR230_query.Edit1.Text)));
end;

end.
