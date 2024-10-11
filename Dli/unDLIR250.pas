{*******************************************************}
{                                                       }
{                unDLIR250                              }
{                Author: kaikai                         }
{                Create date: 2020/4/11                 }
{                Description: 未交訂單與庫存分析表      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR250;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Math, StrUtils;

type
  TFrmDLIR250 = class(TFrmSTDI041)
    btn_dlir250: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_dlir250Click(Sender: TObject);
  private
    l_IsDG:Boolean;
    l_img02Out:string;
    l_SalCDS:TClientDataSet;
    procedure GetDS(xFliter: string);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR250: TFrmDLIR250;

implementation

uses unGlobal, unCommon, unDLIR250_Query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="oea02" fieldtype="datetime"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

//與出貨表查詢未交明細一樣
procedure TFrmDLIR250.GetDS(xFliter:string);
const strIndexName='pno_asc;adate_asc;oea02;oea01;oeb03';
var
  retErr:Boolean;
  i,tmpRecNo,tmpColor:Integer;
  tmpStkQty,tmpRemainQty:Double;
  Data:OleVariant;
  tmpSQL,tmpOrderno,tmpBu,tmpPno:string;
  tmpMinDate,tmpMaxDate:TDateTime;
  tmpCDS,tmpStkCDS:TClientDataSet;
  tmpList:TStrings;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢未交訂單...');
  Application.ProcessMessages;

  retErr:=False;
  tmpMinDate:=EncodeDate(2000,1,1);
  tmpMaxDate:=EncodeDate(2099,12,31);
  l_SalCDS.EmptyDataSet;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpStkCDS:=TClientDataSet.Create(nil);
  tmpList:=TStringList.Create;
  try
    tmpSQL:='select oea02,oea01,oeb03,oea04,occ02,'
           +' case when substr(oeb04,1,1) in (''R'',''N'',''B'',''M'') then ''PP'''
					 +'	when substr(oeb04,1,1) in (''E'',''T'') and substr(oeb04,1,2) not in (''EI'',''ES'') then ''CCL'' else ''err'' end as ptype,'
           +' case when instr(oeb06,''TC'',1,1)>0 then substr(oeb06,1,instr(oeb06,''TC'',1,1)-1)'
			     +' when instr(oeb06,''BS'',1,1)>0 then substr(oeb06,1,instr(oeb06,''BS'',1,1)-1) else ''err'' end as ad,'
           +' oeb04,oeb06,ima021,ta_oeb01,ta_oeb02,oeb05,oeb12,oeb24,qty,stkqty,oeb15,adate,'
           +' cdate,aremark,bremark,oea10,oeb11,ta_oeb10,oao06,ocd221,pno_asc,adate_asc,fcolor from'
           +' (select C.*,oao06 from'
           +' (select B.*,ima021 from'
           +' (select A.*,occ02 from'
           +' (select oea02,oea01,oeb03,oea04,oea044,oeb04,oeb06,ta_oeb01,'
           +' ta_oeb02,oeb05,oeb12,oeb24,oeb12 qty,oeb12 stkqty,oeb15,ta_oeb10 adate,'
           +' ta_oeb10 cdate,ta_oeb10 aremark,ta_oeb10 bremark,'
           +' to_char(oea02,''YYYY/MM/DD'') q_oea02,oea10,oeb11,ta_oeb10,oeb04 as pno_asc,oea02 as adate_asc,oeb03 as fcolor'
           +' from oea_file inner join oeb_file on oea01=oeb01'
           +' where oeaconf=''Y'' and oeb12>oeb24 and oeb70=''N'''
           +' and to_char(oea02,''YYYY/MM/DD'')>=''2016/01/01'''
           +' and oea01 not like ''226%'''
           +' and oea01 not like ''228%'''
           +' and oea01 not like ''22A%'''
           +' and oea01 not like ''22B%'''
//           +' and oea04 not in(''N012'',''N005'')'
           +' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%'''
           +' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%'''
           +' or oeb04 like ''R%'' or oeb04 like ''T%'')'
		       +' and oeb06 not like ''玻%'''
		       +' and oeb06 not like ''ML%'') A'
           +' inner join occ_file on oea04=occ01 where 1=1 '+xFliter
           +' ) B left join ima_file on oeb04=ima01'
           +' ) C left join oao_file on oea01=oao01 and oeb03=oao03'
           +' ) D left join ocd_file on oea04=ocd01 and oea044=ocd02'
           +' order by oea02,oea01,oeb03';
    if l_IsDG then
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
         l_SalCDS.Data:=Data;
    end else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
         l_SalCDS.Data:=Data;
    end;

    with l_SalCDS do
    begin
      if IsEmpty then
         Exit;

      First;
      while not Eof do
      begin
        if Pos(','+FieldByName('oea01').AsString+',',tmpOrderno+',')=0 then
           tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('oea01').AsString);
        tmpPno:=Copy(FieldByName('oeb04').AsString,1,Length(FieldByName('oeb04').AsString)-1);
        if tmpList.IndexOf(tmpPno)=-1 then
           tmpList.Add(tmpPno);
        Edit;
        FieldByName('pno_asc').AsString:=tmpPno;          //料號去尾碼排序用
        FieldByName('adate_asc').AsDateTime:=tmpMaxDate;  //達次日期、call貨日期排序用,默認未答交最大日期
        FieldByName('qty').AsFloat:=RoundTo(FieldByName('oeb12').AsFloat-FieldByName('oeb24').AsFloat, -3);
        FieldByName('adate').Clear;
        FieldByName('cdate').Clear;
        FieldByName('aremark').Clear;
        FieldByName('bremark').Clear;
        FieldByName('stkqty').AsFloat:=0;
        FieldByName('fcolor').AsInteger:=0;
        Post;
        Next;
      end;
    end;

    //刪除已結案
    if l_IsDG then
       tmpBu:='ITEQDG'
    else
       tmpBu:='ITEQGZ';
    Delete(tmpOrderno,1,1);
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem'
           +' From MPS300 Where Bu='+Quotedstr(tmpBu)
           +' And Orderno in ('+tmpOrderno+') And Flag=1';
    if not QueryBySQL(tmpSQL, Data) then
    begin
      retErr:=True;
      Exit;
    end;
    
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      while l_SalCDS.Locate('oea01;oeb03',
              VarArrayOf([Fields[0].AsString, Fields[1].AsInteger]),[]) do
        l_SalCDS.Delete;

      if l_SalCDS.IsEmpty then
      begin
        retErr:=True;
        Exit;
      end;
      
      Next;
    end;

    //更新達交日期、CALL貨日期
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem,Adate,CDate,Remark1,Remark2'
           +' From MPS200 Where Bu='+Quotedstr(tmpBu)
           +' And Orderno in ('+tmpOrderno+')'
           +' And IsNull(GarbageFlag,0)=0';
    if not QueryBySQL(tmpSQL, Data) then
    begin
      retErr:=True;
      Exit;
    end;
    
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        if l_SalCDS.Locate('oea01;oeb03',
            VarArrayOf([FieldByName('Orderno').AsString,
                        FieldByName('Orderitem').AsInteger]),[]) then
        begin
          l_SalCDS.Edit;
          if not FieldByName('Adate').IsNull then
          begin
            if l_SalCDS.FieldByName('adate').AsString='' then
               l_SalCDS.FieldByName('adate').AsString:=FieldByName('Adate').AsString
            else if Pos(FieldByName('Adate').AsString,l_SalCDS.FieldByName('adate').AsString)=0 then
               l_SalCDS.FieldByName('adate').AsString:=l_SalCDS.FieldByName('adate').AsString+','+FieldByName('Adate').AsString;
            if l_SalCDS.FieldByName('adate_asc').AsDateTime>FieldByName('Adate').AsDateTime then
               l_SalCDS.FieldByName('adate_asc').AsDateTime:=FieldByName('Adate').AsDateTime;
          end;

          if not FieldByName('Cdate').IsNull then
          begin
            if l_SalCDS.FieldByName('cdate').AsString='' then
               l_SalCDS.FieldByName('cdate').AsString:=FieldByName('Cdate').AsString
            else if Pos(FieldByName('Cdate').AsString,l_SalCDS.FieldByName('cdate').AsString)=0 then
               l_SalCDS.FieldByName('cdate').AsString:=l_SalCDS.FieldByName('cdate').AsString+','+FieldByName('Cdate').AsString;
            if l_SalCDS.FieldByName('adate_asc').AsDateTime>FieldByName('Cdate').AsDateTime then
               l_SalCDS.FieldByName('adate_asc').AsDateTime:=FieldByName('Cdate').AsDateTime;
          end;

          if Length(Trim(FieldByName('Remark1').AsString))>0 then
          begin
            if l_SalCDS.FieldByName('aremark').AsString<>'' then
               l_SalCDS.FieldByName('aremark').AsString:=l_SalCDS.FieldByName('aremark').AsString+','+
                                                         FieldByName('Remark1').AsString
            else
               l_SalCDS.FieldByName('aremark').AsString:=FieldByName('Remark1').AsString;
          end;

          if Length(Trim(FieldByName('Remark2').AsString))>0 then
          begin
            if l_SalCDS.FieldByName('bremark').AsString<>'' then
               l_SalCDS.FieldByName('bremark').AsString:=l_SalCDS.FieldByName('bremark').AsString+','+
                                                         FieldByName('Remark2').AsString
            else
               l_SalCDS.FieldByName('bremark').AsString:=FieldByName('Remark2').AsString;
          end;

          l_SalCDS.Post;
        end;
        Next;
      end;
    end;

    //計算庫存
    //取庫別,總庫存lst=1
    if Length(l_img02Out)=0 then
    begin
      tmpSQL:='Select Depot From MPS330 Where Bu='+Quotedstr(tmpBu)+' And lst=1';
      if not QueryBySQL(tmpSQL, Data) then
      begin
        retErr:=True;
        Exit;
      end;
      
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
        if IsEmpty then
        begin
          retErr:=True;
          ShowMsg('MPS330無庫別,無法計算庫存,請確認!',48);
          Exit;
        end;

        while Not Eof do
        begin
          l_img02Out:=l_img02Out+','+Quotedstr(Fields[0].AsString);
          Next;
        end;
      end;
      Delete(l_img02Out,1,1);
      l_img02Out:=' and img02 in ('+l_img02Out+')';
    end;
    //***

    //每50個料號查詢一次，料號不會重複查詢
    tmpSQL:='';
    for i:=0 to tmpList.Count-1 do
    begin
      tmpRecNo:=i+1;
      tmpSQL:=tmpSQL+','+Quotedstr(tmpList.Strings[i]);
      if (tmpRecNo mod 50 = 0) or (tmpRecNo=tmpList.Count) then
      begin
        g_StatusBar.Panels[0].Text:=CheckLang('正在查詢庫存:')+IntToStr(tmpList.Count)+'/'+inttostr(tmpRecNo);
        Application.ProcessMessages;
        Data:=null;
        Delete(tmpSQL,1,1);
        tmpSQL:='select img01,sum(img10) img10 from ('
               +' select substr(img01,1,length(img01)-1) as img01,img10'
               +' from iteqdg.img_file where substr(img01,1,length(img01)-1) in ('+tmpSQL+')'+l_img02Out+' and img10>0'
               +' union all'
               +' select substr(img01,1,length(img01)-1) as img01,img10'
               +' from iteqgz.img_file where substr(img01,1,length(img01)-1) in ('+tmpSQL+')'+l_img02Out+' and img10>0) t group by img01';
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          retErr:=True;
          Exit;
        end;

        if tmpStkCDS.Active then
           tmpStkCDS.AppendData(Data, True)
        else
           tmpStkCDS.Data:=Data;

        tmpSQL:='';
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查計算庫存...');
    Application.ProcessMessages;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpStkCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    tmpColor:=1;
    tmpStkCDS.IndexFieldNames:='img01';
    tmpStkCDS.First;
    while not tmpStkCDS.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      tmpStkQty:=tmpStkCDS.FieldByName('img10').AsFloat;
      if (Pos(LeftStr(tmpStkCDS.FieldByName('img01').AsString,1),'BR')>0) and
         (Length(tmpStkCDS.FieldByName('img01').AsString)>13) then
         tmpStkQty:=RoundTo(tmpStkQty/StrToInt(Copy(tmpStkCDS.FieldByName('img01').AsString,11,3)),-3);
      tmpRemainQty:=tmpStkQty;

      with l_SalCDS do
      begin
        Filtered:=False;
        Filter:='pno_asc='+Quotedstr(tmpStkCDS.FieldByName('img01').AsString);
        Filtered:=True;
        IndexFieldNames:=strIndexName;
        First;
        while not Eof do
        begin
          if tmpRemainQty>0 then
          begin
            Edit;
            if FieldByName('qty').AsFloat<tmpRemainQty then
            begin
              FieldByName('stkqty').AsFloat:=FieldByName('qty').AsFloat;
              tmpRemainQty:=RoundTo(tmpRemainQty-FieldByName('qty').AsFloat,-3);
            end else
            begin
              FieldByName('stkqty').AsFloat:=tmpRemainQty;
              tmpRemainQty:=0;
            end;
            FieldByName('fcolor').AsInteger:=tmpColor;
            Post;
          end;
          Next;

          //添加總庫存量,剩余庫存
          if Eof or (tmpRemainQty<=0) then
          begin
            Append;
            FieldByName('oeb04').AsString:=CheckLang('總庫存');
            FieldByName('pno_asc').AsString:=tmpStkCDS.FieldByName('img01').AsString;
            FieldByName('adate_asc').AsDateTime:=tmpMinDate;
            FieldByName('stkqty').AsFloat:=tmpStkQty;
            FieldByName('fcolor').AsInteger:=tmpColor;
            Post;

            Append;
            FieldByName('oeb04').AsString:=CheckLang('剩餘庫存');
            FieldByName('pno_asc').AsString:=tmpStkCDS.FieldByName('img01').AsString;
            FieldByName('adate_asc').AsDateTime:=tmpMaxDate+1;
            FieldByName('stkqty').AsFloat:=tmpRemainQty;
            FieldByName('fcolor').AsInteger:=tmpColor;
            Post;
            if tmpColor=1 then
               tmpColor:=2
            else
               tmpColor:=1;
            Break;
          end;
        end;
      end;

      tmpStkCDS.Next;
    end;

    with l_SalCDS do
    begin
      Filtered:=False;
      Filter:='fcolor=0';
      Filtered:=True;
      IndexFieldNames:='';
      while not IsEmpty do
        Delete;
    end;

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpStkCDS);
    FreeAndNil(tmpList);
    l_SalCDS.Filtered:=False;
    l_SalCDS.IndexFieldNames:='';
    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;
    if not retErr then
    begin
      CDS.Data:=l_SalCDS.Data;
      CDS.IndexFieldNames:=strIndexName;
      CDS.First;
    end;
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmDLIR250.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmDLIR250.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR250';
  p_SBText:=CheckLang('庫別:[出貨表庫別設定]->出貨表總庫存');
  p_GridDesignAns:=True;
  l_SalCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS,l_Xml);
  btn_dlir250.Left:=btn_quit.Left;
  
  inherited;
end;

procedure TFrmDLIR250.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SalCDS);
end;

procedure TFrmDLIR250.btn_queryClick(Sender: TObject);
var
  str:string;
begin
  //inherited;
  if not Assigned(FrmDLIR250_Query) then
     FrmDLIR250_Query:=TFrmDLIR250_Query.Create(Application);
  if FrmDLIR250_Query.ShowModal=mrOK then
  begin
    l_IsDG:=FrmDLIR250_Query.rgp.ItemIndex=0;
    str:=' and q_oea02>='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR250_Query.Dtp1.Date),'-','/',[rfReplaceAll]))
        +' and q_oea02<='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR250_Query.Dtp2.Date),'-','/',[rfReplaceAll]));
    if Length(Trim(FrmDLIR250_Query.Edit1.Text))>0 then
       str:=str+' and oea01='+Quotedstr(UpperCase(Trim(FrmDLIR250_Query.Edit1.Text)));
    if Length(Trim(FrmDLIR250_Query.Edit2.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmDLIR250_Query.Edit2.Text)))+',oea04)>0';
    if Length(Trim(FrmDLIR250_Query.Edit3.Text))>0 then
       str:=str+' and oeb04 like '+Quotedstr(Trim(FrmDLIR250_Query.Edit3.Text)+'%');
     RefreshDS(str);
  end;
end;

procedure TFrmDLIR250.btn_exportClick(Sender: TObject);
begin
  //l_Xml初始化時只有一個欄位
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料可匯出!',48);
    Exit;
  end;
  
  inherited;
end;

procedure TFrmDLIR250.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if CDS.FieldByName('fcolor').AsInteger=1 then
     Background:=clSkyBlue
  else
     Background:=clInfobk;
end;

procedure TFrmDLIR250.btn_dlir250Click(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) and (CDS.FieldByName('oeb03').AsInteger>0) then
     str:=CDS.FieldByName('oeb04').AsString;
  GetQueryStock(str, false);
end;

end.
