{*******************************************************}
{                                                       }
{                unDLIR210                              }
{                Author: kaikai                         }
{                Create date: 2019/4/16                 }
{                Description: 兩角訂單轉單明細          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR210;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, DateUtils, StrUtils, Math;

type
  TFrmDLIR210 = class(TFrmSTDI041)
    ImageList2: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_IsDG:Boolean;
    l_SalCDS:TClientDataSet;
    l_StrIndex,l_StrIndexDesc:string;
    procedure GetDS(xFliter:string);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR210: TFrmDLIR210;

implementation

uses unGlobal, unCommon, unDLIR210_Query;

{$R *.dfm}

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="odate" fieldtype="date"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="longitude" fieldtype="r8"/>'
           +'<FIELD attrname="latitude" fieldtype="r8"/>'
           +'<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ta_oeb07" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderqty" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="remainqty" fieldtype="r8"/>'
           +'<FIELD attrname="sqty" fieldtype="r8"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
           +'<FIELD attrname="custorderno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="custprono" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="custname" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="ddate" fieldtype="date"/>'
           +'<FIELD attrname="adate" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="cdate" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="remark" fieldtype="string" WIDTH="400"/>'
           +'<FIELD attrname="remark1" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="machine" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="isdelete" fieldtype="string" WIDTH="1"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

procedure TFrmDLIR210.GetDS(xFliter:string);
var
  tmpSqty:Double;
  Data:OleVariant;
  tmpSQL,tmpOAO06,tmpOrderno:string;
  tmpCDS,tmpCDS_ocm:TClientDataSet;
  tmpList:TStrings;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢[訂單]資料...');
  Application.ProcessMessages;
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpCDS_ocm:=TClientDataSet.Create(nil);
  tmpList:=TStringList.Create;
  tmpList.Delimiter:='-';
  try
    tmpSQL:='Select tc_ocm01,tc_ocm03 From tc_ocm_file';
    if l_IsDG then
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
         tmpCDS_ocm.Data:=Data
      else
         Exit;
    end else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
         tmpCDS_ocm.Data:=Data
      else
         Exit;
    end;

    Data:=null;
    tmpSQL:='select C.*,oao06 from'
           +' (select B.*,ima021 from'
           +' (select A.*,occ02 from'
           +' (select oea01,oea02,oea04,oea044,oea10,oeb03,oeb04,oeb05,oeb06,'
           +' oeb11,oeb12,oeb15,oeb24,ta_oeb01,ta_oeb02,ta_oeb04,ta_oeb07,'
           +' ta_oeb10,to_char(oea02,''YYYY/MM/DD'') q_oea02'
           +' from oea_file inner join oeb_file on oea01=oeb01'
           +' where oeaconf=''Y'' and nvl(oeb70,''N'')<>''Y'' and oeb12>0'
           +' and oea02>=sysdate-365'
           +' and oea01 not like ''226%'''
           +' and oea01 not like ''228%'''
           +' and oea01 not like ''22A%'''
           +' and oea01 not like ''22B%'''
           +' and oea04 not in(''N012'',''N005'')'
           +' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%'''
           +' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%'''
           +' or oeb04 like ''R%'' or oeb04 like ''T%'')'
           +' and oeb06 not like ''玻%'''
           +' and oeb06 not like ''ML%'') A'
           +' inner join occ_file on oea04=occ01 where 1=1 '+xFliter
           +' ) B left join ima_file on oeb04=ima01'
           +' ) C left join oao_file on oea01=oao01 and oeb03=oao03'
           +' order by oea02,oea01,oeb03';
    if l_IsDG then
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
         tmpCDS.Data:=Data
      else
         Exit;
    end else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
         tmpCDS.Data:=Data
      else
         Exit;
    end;

    with tmpCDS do
    begin
      if IsEmpty then
         Exit;

      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=RecordCount;
      g_ProgressBar.Visible:=True;
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        l_SalCDS.Append;
        l_SalCDS.FieldByName('odate').AsDateTime:=FieldByName('oea02').AsDateTime;
        try
          l_SalCDS.FieldByName('ddate').AsDateTime:=DateOf(FieldByName('oeb15').AsDateTime);
        except
          l_SalCDS.FieldByName('ddate').Clear;
        end;
        l_SalCDS.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
        l_SalCDS.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
        l_SalCDS.FieldByName('orderno').AsString:=FieldByName('oea01').AsString;
        l_SalCDS.FieldByName('orderitem').AsInteger:=FieldByName('oeb03').AsInteger;
        l_SalCDS.FieldByName('pno').AsString:=FieldByName('oeb04').AsString;
        l_SalCDS.FieldByName('pname').AsString:=FieldByName('oeb06').AsString;
        l_SalCDS.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
        l_SalCDS.FieldByName('longitude').AsString:=FieldByName('ta_oeb01').AsString;
        l_SalCDS.FieldByName('latitude').AsString:=FieldByName('ta_oeb02').AsString;
        l_SalCDS.FieldByName('ta_oeb04').AsString:=FieldByName('ta_oeb04').AsString;
        l_SalCDS.FieldByName('ta_oeb07').AsString:=FieldByName('ta_oeb07').AsString;
        l_SalCDS.FieldByName('orderqty').AsFloat:=FieldByName('oeb12').AsFloat;
        l_SalCDS.FieldByName('outqty').AsFloat:=FieldByName('oeb24').AsFloat;
        l_SalCDS.FieldByName('remainqty').AsFloat:=RoundTo(FieldByName('oeb12').AsFloat-FieldByName('oeb24').AsFloat, -3);
        l_SalCDS.FieldByName('units').AsString:=FieldByName('oeb05').AsString;
        l_SalCDS.FieldByName('custorderno').AsString:=FieldByName('oea10').AsString;
        l_SalCDS.FieldByName('custprono').AsString:=FieldByName('oeb11').AsString;
        l_SalCDS.FieldByName('custname').AsString:=FieldByName('ta_oeb10').AsString;
        l_SalCDS.FieldByName('remark').AsString:=FieldByName('oao06').AsString;
        l_SalCDS.FieldByName('machine').AsString:='err';
        l_SalCDS.FieldByName('isdelete').AsString:='N';

        //pnl排制量、公式要與排程一致
        if Length(FieldByName('oeb04').AsString) in [11,12,19,20] then
        begin
          if tmpCDS_ocm.Locate('tc_ocm01',FieldByName('ta_oeb07').AsString,[]) and
             (tmpCDS_ocm.FieldByName('tc_ocm03').AsInteger>0) then
          begin
            if Length(FieldByName('oeb04').AsString) in [11,19] then
            begin
              l_SalCDS.FieldByName('sqty').AsFloat:=FieldByName('oeb12').AsFloat/tmpCDS_ocm.FieldByName('tc_ocm03').AsInteger;
              if Trunc(l_SalCDS.FieldByName('sqty').AsFloat)<l_SalCDS.FieldByName('sqty').AsFloat then
                 l_SalCDS.FieldByName('sqty').AsFloat:=Round(l_SalCDS.FieldByName('sqty').AsFloat+0.5);
            end else
            begin
              l_SalCDS.FieldByName('sqty').AsFloat:=((FieldByName('oeb12').AsFloat/tmpCDS_ocm.FieldByName('tc_ocm03').AsInteger)*FieldByName('ta_oeb01').AsFloat*25.4)/1000;
              if Trunc(l_SalCDS.FieldByName('sqty').AsFloat)<l_SalCDS.FieldByName('sqty').AsFloat then
                 l_SalCDS.FieldByName('sqty').AsFloat:=Round(l_SalCDS.FieldByName('sqty').AsFloat+0.5);

              if l_SalCDS.FieldByName('sqty').AsInteger mod 10 <>0 then  //10的倍數
                 l_SalCDS.FieldByName('sqty').AsFloat:=(Trunc(l_SalCDS.FieldByName('sqty').AsFloat/10)+1)*10;
            end;
          end else
            l_SalCDS.FieldByName('sqty').AsFloat:=FieldByName('oeb12').AsFloat;
        end else
          l_SalCDS.FieldByName('sqty').AsFloat:=FieldByName('oeb12').AsFloat;

        l_SalCDS.Post;
        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢[排程]資料...');
    Application.ProcessMessages;
    Data:=null;
    if l_IsDG then
       tmpSQL:=' and srcflag in(1,3,5)'
    else
       tmpSQL:=' and srcflag in(2,4,6)';
    tmpSQL:='select orderno,orderitem,machine,'
           +'case when machine in (''L6'',''T6'',''T7'',''T8'') then ''GZ'' else ''DG'' end mps,sqty'
           +' from (select orderno,orderitem,machine,sum(sqty) sqty from mps010'
           +' where bu=''ITEQDG'' and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0 '+tmpSQL
           +' group by orderno,orderitem,machine'
           +' union all'
           +' select orderno,orderitem,machine,sum(sqty) sqty from mps070'
           +' where bu=''ITEQDG'' and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0'
           +' and OrderItem is not null '+tmpSQL
           +' group by orderno,orderitem,machine) X'
           +' order by orderno,orderitem,mps,machine';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    //排除資料,標記isdelete=Y
    g_ProgressBar.Position:=0;
    g_StatusBar.Panels[0].Text:=CheckLang('正在分析[排程]資料...');
    Application.ProcessMessages;
    tmpCDS.Data:=Data;
    with l_SalCDS do
    begin
      g_ProgressBar.Max:=RecordCount;

      First;
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        //異地生產,排制量>=訂單量
        tmpCDS.Filtered:=False;
        if l_IsDG then
           tmpCDS.Filter:='mps=''GZ'' and orderno='+Quotedstr(FieldByName('orderno').AsString)
                         +' and orderitem='+IntToStr(FieldByName('orderitem').AsInteger)
        else
           tmpCDS.Filter:='mps=''DG'' and orderno='+Quotedstr(FieldByName('orderno').AsString)
                         +' and orderitem='+IntToStr(FieldByName('orderitem').AsInteger);
        tmpCDS.Filtered:=True;
        if not tmpCDS.IsEmpty then
        begin
          tmpSqty:=0;
          tmpCDS.First;
          while not tmpCDS.Eof do
          begin
            tmpSqty:=tmpSqty+tmpCDS.FieldByName('sqty').AsFloat;
            tmpCDS.Next;
          end;

          if tmpSqty>=FieldByName('sqty').AsFloat then
          begin
            Edit;
            FieldByName('isdelete').AsString:='Y';
            Post;
          end;
        end;

        //本地生產,排制量>=訂單量
        tmpCDS.Filtered:=False;
        if l_IsDG then
           tmpCDS.Filter:='mps=''DG'' and orderno='+Quotedstr(FieldByName('orderno').AsString)
                         +' and orderitem='+IntToStr(FieldByName('orderitem').AsInteger)
        else
           tmpCDS.Filter:='mps=''GZ'' and orderno='+Quotedstr(FieldByName('orderno').AsString)
                         +' and orderitem='+IntToStr(FieldByName('orderitem').AsInteger);
        tmpCDS.Filtered:=True;
        if not tmpCDS.IsEmpty then
        begin
          tmpSqty:=0;
          tmpCDS.First;
          while not tmpCDS.Eof do
          begin
            tmpSqty:=tmpSqty+tmpCDS.FieldByName('sqty').AsFloat;
            tmpCDS.Next;
          end;

          if tmpSqty>=FieldByName('sqty').AsFloat then
          begin
            Edit;
            FieldByName('isdelete').AsString:='Y';
            Post;
          end;
        end;

        //兩邊都生產,不處理

        //更新機臺與數量
        if FieldByName('isdelete').AsString='N' then
        begin
          tmpCDS.Filtered:=False;
          tmpCDS.Filter:='orderno='+Quotedstr(FieldByName('orderno').AsString)
                        +' and orderitem='+IntToStr(FieldByName('orderitem').AsInteger);
          tmpCDS.Filtered:=True;
          if not tmpCDS.IsEmpty then
          begin
            tmpSQL:='';
            tmpCDS.First;
            while not tmpCDS.Eof do
            begin
              tmpSQL:=tmpSQL+','+tmpCDS.FieldByName('machine').AsString+'/'+tmpCDS.FieldByName('sqty').AsString;
              tmpCDS.Next;
            end;

            System.Delete(tmpSQL,1,1);
            Edit;
            FieldByName('machine').AsString:=tmpSQL;
            Post;
          end;
        end;

        Next;
      end;
    end;

    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='';
    
    g_StatusBar.Panels[0].Text:=CheckLang('正在刪除無效訂單資料...');
    Application.ProcessMessages;
    with l_SalCDS do
    begin
      Filtered:=False;
      Filter:='isdelete=''Y''';
      Filtered:=True;
      while not IsEmpty do
        Delete;

      //處理在排程上,但答交是DG庫或GZ庫
      Filtered:=False;
      Filter:='machine<>''err''';
      Filtered:=True;
      while not Eof do
      begin
        if Pos(FieldByName('orderno').AsString,tmpOrderno)=0 then
           tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('orderno').AsString);
        Next;
      end;

      //這里Filtered不能關閉
    end;

    if Length(tmpOrderno)>0 then
    begin
      g_ProgressBar.Position:=0;
      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢[DG庫、GZ庫]資料...');
      Application.ProcessMessages;
      Delete(tmpOrderno,1,1);
      Data:=null;
      tmpSQL:='Select Orderno,Orderitem From MPS200'
             +' Where Orderno in ('+tmpOrderno+') And IsNull(GarbageFlag,0)=0';
      if l_IsDG then
         tmpSQL:=tmpSQL+' And Bu=''ITEQDG'' And Remark1=''DG庫'''
      else
         tmpSQL:=tmpSQL+' And Bu=''ITEQGZ'' And Remark1=''GZ庫''';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS.Data:=Data;
      g_ProgressBar.Max:=tmpCDS.RecordCount;
      while not tmpCDS.Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([tmpCDS.FieldByName('orderno').AsString,
                  IntToStr(tmpCDS.FieldByName('orderitem').AsInteger)]),[]) then
        begin
          l_SalCDS.Edit;
          l_SalCDS.FieldByName('isdelete').AsString:='Y';
          l_SalCDS.Post;
        end;
        tmpCDS.Next;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('正在刪除無效訂單資料...');
      Application.ProcessMessages;
      with l_SalCDS do
      begin
        Filtered:=False;
        Filter:='isdelete=''Y''';
        Filtered:=True;
        while not IsEmpty do
          Delete;
      end;
    end;

    //清除machine=err
    with l_SalCDS do
    begin
      Filtered:=False;
      Filter:='';
      First;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=RecordCount;

      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        if FieldByName('machine').AsString='err' then
        begin
          Edit;
          FieldByName('machine').Clear;
          Post;
        end;
        Next;
      end;
    end;

    //***兩角訂單***
    g_ProgressBar.Position:=0;
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢[兩角訂單]資料...');
    Application.ProcessMessages;
    with l_SalCDS do
    begin
      First;
      while not Eof do
      begin
        tmpSQL:=FieldByName('custno').AsString+'-'+
                FieldByName('orderno').AsString+'-'+
                FieldByName('orderitem').AsString;
        tmpOAO06:=tmpOAO06+' or oao06 like '+Quotedstr(tmpSQL+'%');
        Next;
      end;
    end;
    if Length(tmpOAO06)>0 then
    begin
      Delete(tmpOAO06,1,4);
      Data:=null;
      tmpSQL:='select oao01,oao03,oao06 from oao_file where ('+tmpOAO06+')';
      if l_IsDG then
      begin
        tmpSQL:=tmpSQL+' and (oao01 like ''P1T%'' or oao01 like ''P1Y%'' or oao01 like ''P1Z%'' or oao01 like ''P1N%'')';
        if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
           tmpCDS.Data:=Data
        else
           Exit;
      end else
      begin
        tmpSQL:=tmpSQL+' and (oao01 like ''P2Y%'' or oao01 like ''P2Z%'' or oao01 like ''P2N%'')';
        if QueryBySQL(tmpSQL, Data, 'ORACLE') then
           tmpCDS.Data:=Data
        else
           Exit;
      end;

      g_ProgressBar.Max:=tmpCDS.RecordCount;
      with tmpCDS do
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        tmpList.DelimitedText:=FieldByName('oao06').AsString;
        if tmpList.Count>=4 then
        if l_SalCDS.Locate('custno;orderno;orderitem',
            VarArrayOf([tmpList.Strings[0],tmpList.Strings[1]+'-'+tmpList.Strings[2],tmpList.Strings[3]]),[]) then
        begin
          l_SalCDS.Edit;
          l_SalCDS.FieldByName('remark1').AsString:=FieldByName('oao01').AsString+'-'+FieldByName('oao03').AsString;
          l_SalCDS.Post;
        end;
        Next;
      end;
    end;
    //***兩角訂單***

    //***生管達交日期、Call貨日期***
    if not l_SalCDS.IsEmpty then
    begin
      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢[拆分交期]資料...');
      Application.ProcessMessages;

      tmpOrderno:='';
      with l_SalCDS do
      begin
        Filtered:=False;
        First;
        while not Eof do
        begin
          if Pos(FieldByName('orderno').AsString,tmpOrderno)=0 then
             tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('orderno').AsString);
          Next;
        end;
      end;
      Delete(tmpOrderno,1,1);
      
      if l_IsDG then
         tmpSQL:='ITEQDG'
      else
         tmpSQL:='ITEQGZ';
      Data:=null;
      tmpSQL:='Select Orderno,Orderitem,Adate,Cdate'
             +' From MPS200 Where Bu='+Quotedstr(tmpSQL)
             +' And Orderno in ('+tmpOrderno+')'
             +' And IsNull(GarbageFlag,0)=0'
             +' Order By Orderno,Orderitem,Adate,Cdate';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno').AsString,
                  IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
        begin
          if (not FieldByName('adate').IsNull) and
             (Pos(DateToStr(FieldByName('adate').AsDateTime),l_SalCDS.FieldByName('adate').AsString)=0) then
          begin
            l_SalCDS.Edit;
            if Length(l_SalCDS.FieldByName('adate').AsString)>0 then
               l_SalCDS.FieldByName('adate').AsString:=l_SalCDS.FieldByName('adate').AsString+','+
                                                       DateToStr(FieldByName('adate').AsDateTime)
            else
               l_SalCDS.FieldByName('adate').AsString:=DateToStr(FieldByName('adate').AsDateTime);
            l_SalCDS.Post;
          end;

          if (not FieldByName('cdate').IsNull) and
             (Pos(DateToStr(FieldByName('cdate').AsDateTime),l_SalCDS.FieldByName('cdate').AsString)=0) then
          begin
            l_SalCDS.Edit;
            if Length(l_SalCDS.FieldByName('cdate').AsString)>0 then
               l_SalCDS.FieldByName('cdate').AsString:=l_SalCDS.FieldByName('cdate').AsString+','+
                                                       DateToStr(FieldByName('cdate').AsDateTime)
            else
               l_SalCDS.FieldByName('cdate').AsString:=DateToStr(FieldByName('cdate').AsDateTime);
            l_SalCDS.Post;
          end;
        end;
        Next;
      end;
    end;
    //***生管達交日期、Call貨日期***

    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS_ocm);
    FreeAndNil(tmpList);
    l_SalCDS.EnableControls;
    CDS.Data:=l_SalCDS.Data;
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmDLIR210.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmDLIR210.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR210';
  p_GridDesignAns:=True;
  l_SalCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS, g_Xml);

  inherited;
end;

procedure TFrmDLIR210.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_SalCDS);
end;

procedure TFrmDLIR210.btn_queryClick(Sender: TObject);
var
  str:string;
begin
  //inherited;
  if not Assigned(FrmDLIR210_Query) then
     FrmDLIR210_Query:=TFrmDLIR210_Query.Create(Application);
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  try
    if FrmDLIR210_Query.ShowModal<>mrOK then
       Exit;

    str:=' and q_oea02>='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR210_Query.Dtp1.Date),'-','/',[rfReplaceAll]))
        +' and q_oea02<='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR210_Query.Dtp2.Date),'-','/',[rfReplaceAll]));
    if Length(Trim(FrmDLIR210_Query.Edit2.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmDLIR210_Query.Edit2.Text)))+',oea01)>0';
    if Length(Trim(FrmDLIR210_Query.Edit1.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmDLIR210_Query.Edit1.Text)))+',oea04)>0';
    case FrmDLIR210_Query.Rgp1.ItemIndex of
    0:str:=str+' and oeb12>oeb24';
    1:str:=str+' and oeb12=oeb24';
    end;
    l_IsDG:=FrmDLIR210_Query.Rgp2.ItemIndex=0;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(str);
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR210.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
