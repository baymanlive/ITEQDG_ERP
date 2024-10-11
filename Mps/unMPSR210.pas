unit unMPSR210;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils;

type
  TFrmMPSR210 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    procedure GetDS(D1,D2:TDateTime);
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR210: TFrmMPSR210;

implementation

uses unGlobal, unCommon, unMPSR210_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sdate" fieldtype="DateTime"/>'
           +'<FIELD attrname="machine" fieldtype="string" width="10"/>'
           +'<FIELD attrname="wono" fieldtype="string" width="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" width="30"/>'
           +'<FIELD attrname="sqty" fieldtype="r8"/>'
           +'<FIELD attrname="ordqty" fieldtype="r8"/>'
           +'<FIELD attrname="custno" fieldtype="string" width="20"/>'
           +'<FIELD attrname="custom" fieldtype="string" width="30"/>'
           +'<FIELD attrname="breadth" fieldtype="string" width="30"/>'
           +'<FIELD attrname="fiber" fieldtype="string" width="30"/>'
           +'<FIELD attrname="pno9" fieldtype="string" width="30"/>'
           +'<FIELD attrname="depot" fieldtype="string" width="20"/>'
           +'<FIELD attrname="area" fieldtype="string" width="20"/>'
           +'<FIELD attrname="lot" fieldtype="string" width="20"/>'
           +'<FIELD attrname="ta_img01" fieldtype="string" width="80"/>'
           +'<FIELD attrname="ta_img05" fieldtype="string" width="40"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="remark" fieldtype="string" width="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMPSR210.GetDS(D1,D2:TDateTime);
var
  tmpFlag:Boolean;
  tmpM:Double;
  tmpSQL,tmpORADB:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  g_StatusBar.Panels[0].Text:='正在查詢排程資料,請等待...';
  Application.ProcessMessages;
  l_CDS.EmptyDataSet;
  try
    if D1>EncodeDate(2015,1,1) then
    begin
      tmpSQL:='select machine,sdate,wono,materialno as pno,left(materialno,9) pno9,'
             +' sqty,orderqty,custno,custom,breadth,fiber'
             +' from mps070 where bu=''ITEQDG'''
             +' and sdate between '+Quotedstr(DateToStr(D1))
             +' and '+Quotedstr(DateToStr(D2))
             +' and len(isnull(wono,''''))>0'
             +' and left(materialno,1) in (''B'',''R'')';
      if SameText(g_UInfo^.BU,'ITEQDG') then
      begin
        tmpORADB:='ORACLE';
        tmpSQL:=tmpSQL+' and machine in (''T1'',''T2'',''T3'',''T4'',''T5'')';
      end else
      begin
        tmpORADB:='ORACLE1';
        tmpSQL:=tmpSQL+' and machine in (''T6'',''T7'',''T8'')';
      end;
      tmpSQL:=tmpSQL+' order by machine,sdate,jitem,ad,fisno,rc desc,fiber,simuver,citem';
      if not QueryBySQL(tmpSQL,Data) then
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
          if (Length(Trim(tmpCDS1.FieldByName('pno9').AsString))>0) and
             (Pos(tmpCDS1.FieldByName('pno9').AsString,tmpSQL)=0) then
             tmpSQL:=tmpSQL+','+Quotedstr(tmpCDS1.FieldByName('pno9').AsString);

          tmpCDS1.Next;
        end;

        if Length(tmpSQL)=0 then
           Exit;

        g_StatusBar.Panels[0].Text:='正在查詢庫存資料,請等待...';
        Application.ProcessMessages;
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpSQL:='select img01,img02,img03,img04,ta_img01,ta_img05,img10,substr(img01,1,9) pno9'
               +' from img_file where (img01 like ''B%'' or img01 like ''R%'')'
               +' and substr(img01,1,9) in ('+tmpSQL+')'
               +' and img02 in (''Y2AF0'',''N2AF0'')'
               +' and img10>0 order by pno9,img01,substr(img04,2,4)';
        if not QueryBySQL(tmpSQL,Data,tmpORADB) then
           Exit;

        tmpCDS2.Data:=Data;
        if tmpCDS2.IsEmpty then
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

          tmpFlag:=True;
          tmpCDS2.Filtered:=False;
          tmpCDS2.Filter:='pno9='+Quotedstr(tmpCDS1.FieldByName('pno9').AsString);
          tmpCDS2.Filtered:=True;
          while not tmpCDS2.Eof do
          begin
            tmpM:=StrToFloatDef(Copy(tmpCDS2.FieldByName('img01').AsString,11,3),0);
            if (tmpM>0) and (tmpM<>StrToFloatDef(tmpCDS2.FieldByName('img10').AsString,0)) then
            begin
              with l_CDS do
              begin
                Append;
                if tmpFlag then
                begin
                  FieldByName('sdate').AsDateTime:=tmpCDS1.FieldByName('sdate').AsDateTime;
                  FieldByName('machine').AsString:=tmpCDS1.FieldByName('machine').AsString;
                  FieldByName('wono').AsString:=tmpCDS1.FieldByName('wono').AsString;
                  FieldByName('pno').AsString:=tmpCDS1.FieldByName('pno').AsString;
                  FieldByName('sqty').AsFloat:=tmpCDS1.FieldByName('sqty').AsFloat;
                  FieldByName('ordqty').AsFloat:=tmpCDS1.FieldByName('orderqty').AsFloat;
                  FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
                  FieldByName('custom').AsString:=tmpCDS1.FieldByName('custom').AsString;
                  FieldByName('breadth').AsString:=tmpCDS1.FieldByName('breadth').AsString;
                  FieldByName('fiber').AsString:=tmpCDS1.FieldByName('fiber').AsString;
                end;
                FieldByName('pno9').AsString:=tmpCDS2.FieldByName('img01').AsString;
                FieldByName('depot').AsString:=tmpCDS2.FieldByName('img02').AsString;
                FieldByName('area').AsString:=tmpCDS2.FieldByName('img03').AsString;
                FieldByName('lot').AsString:=tmpCDS2.FieldByName('img04').AsString;
                FieldByName('ta_img01').AsString:=tmpCDS2.FieldByName('ta_img01').AsString;
                FieldByName('ta_img05').AsString:=tmpCDS2.FieldByName('ta_img05').AsString;
                FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
                Post;
                tmpFlag:=False;
              end;
            end;

            tmpCDS2.Next;
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
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmMPSR210.RefreshDS(strFilter: string);
begin
  GetDS(EncodeDate(1955,5,5), Date);

  inherited;
end;

procedure TFrmMPSR210.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR210';
  p_GridDesignAns:=False;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_xml);

  inherited;
end;

procedure TFrmMPSR210.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR210.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmMPSR210_query) then
     FrmMPSR210_query:=TFrmMPSR210_query.Create(Application);
  if FrmMPSR210_query.ShowModal=mrOK then
     GetDS(FrmMPSR210_query.dtp1.Date, FrmMPSR210_query.dtp2.Date);
end;

end.
