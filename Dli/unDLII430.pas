unit unDLII430;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI060, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, Menus, DB, ImgList, ExtCtrls, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, DateUtils;

type
  TFrmDLII430 = class(TFrmSTDI060)
    btn_dlii430A: TBitBtn;
    btn_dlii430B: TBitBtn;
    btn_dlii430C: TBitBtn;
    btn_dlii430D: TBitBtn;
    btn_dlii430E: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btn_dlii430AClick(Sender: TObject);
    procedure btn_dlii430BClick(Sender: TObject);
    procedure btn_dlii430CClick(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure btn_dlii430DClick(Sender: TObject);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_dlii430EClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    l_sql2:string;
    l_list2:TStrings;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS1(strFilter:string); override;
    procedure RefreshDS2; override;
  end;

var
  FrmDLII430: TFrmDLII430;

implementation

uses unGlobal,unCommon, unDLII430_planlist, unDLII430_ordlist,
  unDLII430_udpqty, unDLII410_custno, unDLII430_units,
  unDLII430_DLIR120Detail;

{$R *.dfm}

const l_CDSXml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="id" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="dealer" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="now_yy" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="now_mm" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="now_dd" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="stime_hh" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="stime_ss" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="outtime_hh" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="outtime_ss" fieldtype="string" WIDTH="2"/>'
              +'<FIELD attrname="ccl_kbcnt" fieldtype="i4"/>'
              +'<FIELD attrname="pp_kbcnt" fieldtype="i4"/>'
              +'<FIELD attrname="jiao_kbcnt" fieldtype="i4"/>'
              +'<FIELD attrname="slotcnt" fieldtype="i4"/>'
              +'<FIELD attrname="rlcnt" fieldtype="i4"/>'
              +'<FIELD attrname="shcnt" fieldtype="i4"/>'
              +'<FIELD attrname="carno" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="driver" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="company" fieldtype="string" WIDTH="10"/>'
              +'<FIELD attrname="ton" fieldtype="r8"/>'
              +'<FIELD attrname="slot" fieldtype="i4"/>'
              +'<FIELD attrname="custno" fieldtype="string" WIDTH="400"/>'
              +'<FIELD attrname="custshort" fieldtype="string" WIDTH="400"/>'
              +'<FIELD attrname="custshort_asc" fieldtype="string" WIDTH="400"/>'
              +'<FIELD attrname="saleno" fieldtype="string" WIDTH="2000"/>'
              +'<FIELD attrname="salenocnt" fieldtype="i4"/>'
              +'<FIELD attrname="highspeed" fieldtype="i4"/>'
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

procedure TFrmDLII430.RefreshDS1(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI430 Where Bu='+Quotedstr(g_UInfo^.Bu)+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII430.RefreshDS2;
var
  tmpSQL:string;
begin
  if Assigned(l_list2) then
  begin
    if (not CDS.Active) or CDS.IsEmpty then
        tmpSQL:='Select Sno,Custno,Custshort,Orderno,Orderitem,Pno,Notcount1,Units,Remark,Delcount1,Coccount1,custpo2,custpno2'
               +' From DLI010 Where 1=2'
    else
    begin
        tmpSQL:='Select Sno,Custno,Custshort,Orderno,Orderitem,Pno,Notcount1,Units,Remark,Delcount1,Coccount1,custpo2,custpno2'
               +' From DLI010 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Indate='+Quotedstr(DateToStr(CDS.FieldByName('Indate').AsDateTime))
               +' And CharIndex(Custno,'+Quotedstr(CDS.FieldByName('Custno').AsString)+')>0'
               +' And Len(IsNull(Dno_ditem,''''))=0 And IsNull(GarbageFlag,0)=0'
               +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
               +' And Len(IsNull(Saleno,''''))=0 ';
        tmpSql:=tmpSql+' union all select null,c.custno,c.custname,''JX-''+orderno,orderitem,pno,qty,unit,'+
                       ' null,null,null,c.custpo,c.custpno from dli430 a,dli014 b,dli901 c where a.SourceDno=b.dno '+
                       ' and b.saleno=''JX-''+c.orderno and a.cno='+ Quotedstr(CDS.FieldByName('cno').AsString);
        tmpSql:=tmpSql+' Order By Sno';
    end;
    l_list2.Insert(0,tmpSQL);
  end;

  inherited;
end;

procedure TFrmDLII430.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_MainTableName:='DLI430';
  p_DetailTableName:='DLII410_ordlist';
  p_GridDesignAns1:=True;
  p_GridDesignAns2:=True;
  p_EditFlag:=mainEdit;
  p_Grd2PosFlag:=isBottom;
  p_GridAnchors:=mainAnchors;
  
  inherited;

  btn_insert.Visible:=False;
  btn_copy.Visible:=False;
  TabSheet1.Caption:=CheckLang('派車資料');
  TabSheet2.Caption:=CheckLang('未完成單據');
   l_list2:=TStringList.Create;
  l_CDS:=TClientDataSet.Create(nil);
  InitCDS(l_CDS, l_CDSXml);
  Timer1.Enabled:=True;
end;

procedure TFrmDLII430.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  FreeAndNil(l_CDS);
end;

procedure TFrmDLII430.CDSBeforeInsert(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmDLII430.CDSBeforeDelete(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select Top 1 SourceDno From DLI430 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(CDS.FieldByName('Indate').AsDateTime))
         +' And Id='+IntToStr(CDS.FieldByName('Id').AsInteger);
  if not QueryOneCR(tmpSQL, Data) then
     Abort;
  if Length(VarToStr(Data))>0 then
  begin
    ShowMsg('已出車,不可刪除!',48);
    Abort;
  end;

  inherited;
end;

procedure TFrmDLII430.btn_printClick(Sender: TObject);
type
  TCustnoAsc= record
    Custno,
    Custshort : string;
    Id        : Integer;
  end;
var
  i,j,pos1,cNum:Integer;
  tmpSQL,tmpCustno:string;
  tmpSrcdate,tmpSrcno:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
  tmpRec:TCustnoAsc;
  cRec:Array [0..99] of TCustnoAsc;
begin
//  inherited;

  if CDS.Active and (not CDS.IsEmpty) then
  if CDS.FieldByName('CCLKBCnt').IsNull or
     CDS.FieldByName('PPKBCnt').IsNull or
     CDS.FieldByName('JiaoKBCnt').IsNull or
     (CDS.FieldByName('SlotCnt').AsInteger<=0) then
  begin
    ShowMsg('請輸入棧板數或卡位數,卡位數不能為0!',48);
    Exit;
  end;

  if CDS.Active and (not CDS.IsEmpty) then
  if CDS.FieldByName('SlotCnt').AsInteger>0 then
  if (CDS.FieldByName('CCLKBCnt').AsInteger=0) and
     (CDS.FieldByName('PPKBCnt').AsInteger=0) and
     (CDS.FieldByName('JiaoKBCnt').AsInteger=0) then
  begin
    ShowMsg('棧板數不能全為0!',48);
    Exit;
  end;

  if (CDS.FieldByName('state').AsString<>CheckLang('已出車')) and (not sametext(g_uinfo^.userid,'ID150515')) then
  begin
    ShowMsg('狀態不是[已出車],不可列印!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    l_CDS.EmptyDataSet;
    l_CDS.Append;
    l_CDS.FieldByName('id').AsString:=CDS.FieldByName('cno').AsString;
    l_CDS.FieldByName('now_yy').AsString:=RightStr(IntToStr(YearOf(Date)),2);
    l_CDS.FieldByName('now_mm').AsString:=RightStr('0'+IntToStr(MonthOf(Date)),2);
    l_CDS.FieldByName('now_dd').AsString:=RightStr('0'+IntToStr(DayOf(Date)),2);
    pos1:=Pos(':',CDS.FieldByName('Stime').AsString);
    if pos1>0 then
    begin
      l_CDS.FieldByName('stime_hh').AsString:=LeftStr(CDS.FieldByName('Stime').AsString,pos1-1);
      l_CDS.FieldByName('stime_ss').AsString:=Copy(CDS.FieldByName('Stime').AsString,pos1+1,2);
    end else
    begin
      l_CDS.FieldByName('stime_hh').AsString:='00';
      l_CDS.FieldByName('stime_ss').AsString:='00';
    end;
    l_CDS.FieldByName('outtime_hh').AsString:=RightStr('0'+IntToStr(HourOf(Now)),2);
    l_CDS.FieldByName('outtime_ss').AsString:=RightStr('0'+IntToStr(MinuteOf(Now)),2);
    l_CDS.FieldByName('ccl_kbcnt').AsInteger:=CDS.FieldByName('CCLKBCnt').AsInteger;
    l_CDS.FieldByName('pp_kbcnt').AsInteger:=CDS.FieldByName('PPKBCnt').AsInteger;
    l_CDS.FieldByName('jiao_kbcnt').AsInteger:=CDS.FieldByName('JiaoKBCnt').AsInteger;
    l_CDS.FieldByName('slotcnt').AsInteger:=CDS.FieldByName('SlotCnt').AsInteger;
    l_CDS.FieldByName('rlcnt').AsInteger:=CDS.FieldByName('RLCnt').AsInteger;
    l_CDS.FieldByName('shcnt').AsInteger:=CDS.FieldByName('SHCnt').AsInteger;
    l_CDS.FieldByName('carno').AsString:=Trim(CDS.FieldByName('Carno').AsString);
    if CDS.FieldByName('HighSpeed').AsBoolean then
       l_CDS.FieldByName('highspeed').AsInteger:=1
    else
       l_CDS.FieldByName('highspeed').AsInteger:=0;

    if Length(l_CDS.FieldByName('Carno').AsString)>0 then
    begin
      tmpSQL:='Select Top 1 Company,Ton From DLI420'
             +' Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Carno='+Quotedstr(l_CDS.FieldByName('Carno').AsString);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        l_CDS.FieldByName('company').AsString:=tmpCDS.Fields[0].AsString;
        l_CDS.FieldByName('ton').AsFloat:=tmpCDS.Fields[1].AsFloat;
      end;

      Data:=null;
      tmpSQL:='Select C.*,D.UserName From ('
             +' Select A.Driver,A.Confuser,B.Saleno From DLI013 A Inner Join DLI014 B'
             +' ON A.Bu=B.Bu And A.Dno=B.Dno'
             +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
             +' And A.Dno='+Quotedstr(CDS.FieldByName('SourceDno').AsString)+') C Left Join Sys_User D'
             +' ON C.Confuser=D.UserId And D.Bu='+Quotedstr(g_UInfo^.BU)
             +' Order By Saleno';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;

      tmpSQL:='';
      with tmpCDS do
      begin
        if not IsEmpty then
        begin
          l_CDS.FieldByName('driver').AsString:=FieldByName('Driver').AsString;
          l_CDS.FieldByName('dealer').AsString:=FieldByName('UserName').AsString;
          l_CDS.FieldByName('salenocnt').AsString:=IntToStr(RecordCount);
        end;
        while not Eof do
        begin
          tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('Saleno').AsString);
          Next;
        end;
      end;

      if Length(tmpSQL)>0 then
      begin
        cNum:=0;
        tmpCustno:='@@@@';
        Delete(tmpSQL,1,1);
        Data:=null;
        tmpSQL:='Select A.*,occ02 From (Select oga01,oga04 From %bu.oga_file'
               +' Where oga01 in ('+tmpSQL+')) A Left Join %bu.occ_file'
               +' on A.oga04=occ01 Order By oga04';

        if not QueryBySQL(stringreplace(tmpSQL,'%bu',g_uinfo^.bu,[rfReplaceAll]), Data, 'ORACLE') then
           Exit;
        tmpCDS.Data:=Data;
        with tmpCDS do
        while not Eof do
        begin
          if pos(Fields[1].AsString,l_CDS.FieldByName('custno').AsString)=0 then
          begin
            if cNum<=99 then  //設定的最大數組值
            begin
              cRec[cNum].Custno:=Fields[1].AsString;
              cRec[cNum].Custshort:=Fields[2].AsString;
              cRec[cNum].Id:=999999;
            end;
            Inc(cNum);
            l_CDS.FieldByName('custno').AsString:=l_CDS.FieldByName('custno').AsString+','+Fields[1].AsString;
            l_CDS.FieldByName('custshort').AsString:=l_CDS.FieldByName('custshort').AsString+','+Fields[2].AsString;
          end;

          if tmpCustno<>Fields[1].AsString then
          begin
            if Length(l_CDS.FieldByName('saleno').AsString)>0 then
               l_CDS.FieldByName('saleno').AsString:=l_CDS.FieldByName('saleno').AsString+#13#10;
            l_CDS.FieldByName('saleno').AsString:=l_CDS.FieldByName('saleno').AsString+Fields[2].AsString+'：'+Fields[0].AsString
          end else
            l_CDS.FieldByName('saleno').AsString:=l_CDS.FieldByName('saleno').AsString+' / '+Fields[0].AsString;

          tmpCustno:=Fields[1].AsString;
          Next;
        end;

        //JX-
        begin
          tmpSQL :=
            'select distinct ''JX-''+orderno,c.custno,c.custname from dli430 a,dli014 b,dli901 c where a.SourceDno=b.dno ' +
            ' and b.saleno=''JX-''+c.orderno and a.cno=' + Quotedstr(CDS.FieldByName('cno').AsString);
          if not QueryBySQL(tmpSQL, Data, 'MSSQL') then
            Exit;
          tmpCDS.Data := Data;
          with tmpCDS do
            while not Eof do
            begin
              if pos(Fields[1].AsString, l_CDS.FieldByName('custno').AsString) = 0 then
              begin
                if cNum <= 99 then  //設定的最大數組值
                begin
                  cRec[cNum].Custno := Fields[1].AsString;
                  cRec[cNum].Custshort := Fields[2].AsString;
                  cRec[cNum].Id := 999999;
                end;
                Inc(cNum);
                l_CDS.FieldByName('custno').AsString := l_CDS.FieldByName('custno').AsString + ',' + Fields[1].AsString;
                l_CDS.FieldByName('custshort').AsString := l_CDS.FieldByName('custshort').AsString + ',' + Fields[2].AsString;
              end;

              if tmpCustno <> Fields[1].AsString then
              begin
                if Length(l_CDS.FieldByName('saleno').AsString) > 0 then
                  l_CDS.FieldByName('saleno').AsString := l_CDS.FieldByName('saleno').AsString + #13#10;
                l_CDS.FieldByName('saleno').AsString := l_CDS.FieldByName('saleno').AsString + Fields[2].AsString + '：'
                  + Fields[0].AsString
              end
              else
                l_CDS.FieldByName('saleno').AsString := l_CDS.FieldByName('saleno').AsString + ' / ' + Fields[0].AsString;

              tmpCustno := Fields[1].AsString;
              Next;
            end;
        end;

        //送貨順序
        if cNum>1 then
        begin
          Data:=null;
          tmpSQL:='Select Custno,Id From DLI400 Where Bu='+Quotedstr(g_UInfo^.BU)
                 +' And CharIndex(Custno,'+Quotedstr(l_CDS.FieldByName('custno').AsString)+')>0';
          if not QueryBySQL(tmpSQL, Data) then
             Exit;
          tmpCDS.Data:=Data;
          if not tmpCDS.IsEmpty then
          begin
            for i:=0 to cNum-1 do
              if tmpCDS.Locate('Custno',cRec[i].Custno,[]) then
                 cRec[i].Id:=tmpCDS.Fields[1].AsInteger;

            //冒泡排序
            for i:=0 to cNum-1 do
            begin
              for j:=0 to cNum-2 do
              begin
                if cRec[j].Id>cRec[j+1].Id then
                begin
                  tmpRec:=cRec[j];
                  cRec[j]:=cRec[j+1];
                  cRec[j+1]:=tmpRec;
                end;
              end;
            end;

            for i:=0 to cNum-1 do
              l_CDS.FieldByName('custshort_asc').AsString:=l_CDS.FieldByName('custshort_asc').AsString+','+cRec[i].Custshort;
          end;
        end else
          l_CDS.FieldByName('custshort_asc').AsString:=l_CDS.FieldByName('custshort').AsString;
      end;
    end;
    if Length(l_CDS.FieldByName('custno').AsString)>0 then
       l_CDS.FieldByName('custno').AsString:=Copy(l_CDS.FieldByName('custno').AsString,2,400);
    if Length(l_CDS.FieldByName('custshort').AsString)>0 then
       l_CDS.FieldByName('custshort').AsString:=Copy(l_CDS.FieldByName('custshort').AsString,2,400);
    if Length(l_CDS.FieldByName('custshort_asc').AsString)>0 then
       l_CDS.FieldByName('custshort_asc').AsString:=Copy(l_CDS.FieldByName('custshort_asc').AsString,2,400);
    l_CDS.Post;

    if (l_CDS.FieldByName('saleno').AsString = '') or (l_CDS.FieldByName('custshort').AsString = '') then
    begin
      ShowMsg('不允許列印空派車單', 48);
      Exit;
    end;

    //檢查出貨單號是否與成品出貨清單一致
    if Length(CDS.FieldByName('Srcno').AsString)>9 then
    begin
      tmpSrcdate:=LeftStr(CDS.FieldByName('Srcno').AsString,8);
      tmpSrcdate:=Copy(tmpSrcdate,1,4)+'-'+Copy(tmpSrcdate,5,2)+'-'+Copy(tmpSrcdate,7,2);
      tmpSrcno:=Copy(CDS.FieldByName('Srcno').AsString,9,20);
      Data:=null;
      tmpSQL:='Select Saleno,Count(*) cnt From ('
             +' Select Distinct B.Saleno From DLI018 A Inner Join DLI019 B'
             +' ON A.Bu=B.Bu And A.Dno=B.Dno'
             +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
             +' And A.Dno='+Quotedstr(tmpSrcno)
             +' And A.Cdate='+Quotedstr(tmpSrcdate)
             +' Union All'
             +' Select Distinct B.Saleno From DLI013 A Inner Join DLI014 B'
             +' ON A.Bu=B.Bu And A.Dno=B.Dno'
             +' Where A.Bu='+Quotedstr(g_UInfo^.BU)
             +' And A.Dno='+Quotedstr(CDS.FieldByName('SourceDno').AsString)+') X'
             +' Group By Saleno Having Count(*)=1 Order By Saleno';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS.Data:=Data;
      with tmpCDS do
      if not IsEmpty then
      begin
        tmpSQL:='';
        while not Eof do
        begin
          tmpSQL:=tmpSQL+'  '+Fields[0].AsString;
          if (Recno mod 3)=0 then
             tmpSQL:=tmpSQL+#13#10;
          Next;
        end;

        ShowMsg('檢查派車資料與成品出貨清單,下列出貨單號不符：'+#13#10+tmpSQL,48);
        Exit;
      end;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=l_CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=l_CDS.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmDLII430.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
//  inherited;
  if GetQueryString(p_MainTableName, tmpStr) then
  begin
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate>='+Quotedstr(DateToStr(Date));
    RefreshDS1(tmpStr);
  end;
end;

procedure TFrmDLII430.btn_dlii430AClick(Sender: TObject);
begin
  inherited;
  FrmDLII430_planlist:=TFrmDLII430_planlist.Create(nil);
  try
    if FrmDLII430_planlist.ShowModal=mrOk then
       RefreshDS1(' And Indate='+Quotedstr(DateToStr(FrmDLII430_planlist.l_Date))
                 +' And Id='+IntToStr(FrmDLII430_planlist.l_Id));
  finally
    FreeAndNil(FrmDLII430_planlist);
  end;
end;

procedure TFrmDLII430.btn_dlii430BClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmDLII430_udpqty) then
     FrmDLII430_udpqty:=TFrmDLII430_udpqty.Create(Application);
  FrmDLII430_udpqty.ShowModal;
end;

procedure TFrmDLII430.btn_dlii430CClick(Sender: TObject);
begin
  inherited;
  FrmDLII430_ordlist:=TFrmDLII430_ordlist.Create(nil);
  try
    FrmDLII430_ordlist.ShowModal;
  finally
    FreeAndNil(FrmDLII430_ordlist);
  end;
end;

procedure TFrmDLII430.btn_dlii430DClick(Sender: TObject);
const str1='備貨中';
const str2='已出車';
var
  tmpSQL:string;
  dsNE1,dsNE2,dsNE3,dsNE4:TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇單據!',48);
    Exit;
  end;

  tmpSQL:='Update DLI013 Set Conf=null,Confuser=null,Confdate=null'
         +' Where Bu='+QuotedStr(g_UInfo^.Bu)
         +' And Dno='+QuotedStr(CDS.FieldByName('SourceDno').AsString);
  if CDS.FieldByName('State').AsString=CheckLang(str1) then
  begin
    tmpSQL:='Update DLI013 Set Conf=''Y'',Confuser='+QuotedStr(g_UInfo^.UserId)
           +',Confdate='+QuotedStr(FormatDateTime(g_cLongTimeSP, Now))
           +' Where Bu='+QuotedStr(g_UInfo^.Bu)
           +' And Dno='+QuotedStr(CDS.FieldByName('SourceDno').AsString);
    if ShowMsg('確定更改為['+str2+']嗎?',33)=IdCancel then
       Exit;
  end else
  if ShowMsg('確定更改為['+str1+']嗎?',33)=IdCancel then
     Exit;

  dsNE1:=CDS.BeforeEdit;
  dsNE2:=CDS.AfterEdit;
  dsNE3:=CDS.BeforePost;
  dsNE4:=CDS.AfterPost;
  try
    CDS.Edit;
    if CDS.FieldByName('State').AsString=CheckLang(str1) then
       CDS.FieldByName('State').AsString:=CheckLang(str2)
    else
       CDS.FieldByName('State').AsString:=CheckLang(str1);
    CDS.Post;
    if CDSPost(CDS, 'DLI430') then
    begin
      if Length(CDS.FieldByName('SourceDno').AsString)>0 then
      if not PostBySQL(tmpSQL) then
         ShowMsg('更新派車員失敗,請重試!',48);
    end else
    if CDS.ChangeCount>0 then
       CDS.CancelUpdates;
  finally
    CDS.BeforeEdit:=dsNE1;
    CDS.AfterEdit:=dsNE2;
    CDS.BeforePost:=dsNE3;
    CDS.AfterPost:=dsNE4;
  end;
end;

procedure TFrmDLII430.btn_dlii430EClick(Sender: TObject);
var
  srcno:string;
  dsNE1,dsNE2,dsNE3,dsNE4:TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無派車資料!',48);
    Exit;
  end;

  FrmDLII430_DLIR120Detail:=TFrmDLII430_DLIR120Detail.Create(nil);
  try
    if FrmDLII430_DLIR120Detail.ShowModal<>mrOK then
       Exit;

    with FrmDLII430_DLIR120Detail.CDS1 do
    begin
      if not Active or IsEmpty then
         srcno:=''
      else
         srcno:=FormatDateTime('YYYYMMDD',FieldByName('CDate').AsDateTime)+'-'+FieldByName('Dno').AsString;
    end;

    dsNE1:=CDS.BeforeEdit;
    dsNE2:=CDS.AfterEdit;
    dsNE3:=CDS.BeforePost;
    dsNE4:=CDS.AfterPost;
    CDS.BeforeEdit:=nil;
    CDS.AfterEdit:=nil;
    CDS.BeforePost:=nil;
    CDS.AfterPost:=nil;
    try
      CDS.Edit;
      CDS.FieldByName('Srcno').AsString:=srcno;
      CDS.Post;
      if not CDSPost(CDS,p_MainTableName) then
         CDS.CancelUpdates;
    finally
      CDS.BeforeEdit:=dsNE1;
      CDS.AfterEdit:=dsNE2;
      CDS.BeforePost:=dsNE3;
      CDS.AfterPost:=dsNE4;
    end;
  finally
    FreeAndNil(FrmDLII430_DLIR120Detail);
  end;
end;

procedure TFrmDLII430.DBGridEh1EditButtonClick(Sender: TObject);
var
  Rec:TDLI430Rec;
  tmpCustno:string;
begin
  inherited;
  FrmDLII410_custno:=TFrmDLII410_custno.Create(nil);
  FrmDLII410_custno.Memo1.Lines.DelimitedText:=CDS.FieldByName('Custno').AsString;
  FrmDLII410_custno.Memo2.Lines.DelimitedText:=CDS.FieldByName('Custshort').AsString;
  try
    if FrmDLII410_custno.ShowModal=MrOK then
    begin
      tmpCustno:=FrmDLII410_custno.Memo1.Lines.DelimitedText;
      Rec:=GetCustnoDetail(CDS.FieldByName('Indate').AsDateTime, tmpCustno);
      if not (CDS.State in [dsInsert,dsEdit]) then
         CDS.Edit;
      CDS.FieldByName('Custno').AsString:=tmpCustno;
      CDS.FieldByName('Custshort').AsString:=FrmDLII410_custno.Memo2.Lines.DelimitedText;
      CDS.FieldByName('TotCnt').AsInteger:=Rec.TotCnt;
      CDS.FieldByName('FinCnt').AsInteger:=Rec.FinCnt;
      CDS.FieldByName('CCLSH1').AsFloat:=Rec.CCLSH1;
      CDS.FieldByName('CCLSH2').AsFloat:=Rec.CCLSH2;
      CDS.FieldByName('CCLPNL1').AsFloat:=Rec.CCLPNL1;
      CDS.FieldByName('CCLPNL2').AsFloat:=Rec.CCLPNL2;
      CDS.FieldByName('PPRL1').AsFloat:=Rec.PPRL1;
      CDS.FieldByName('PPRL2').AsFloat:=Rec.PPRL2;
      CDS.FieldByName('PPPNL1').AsFloat:=Rec.PPPNL1;
      CDS.FieldByName('PPPNL2').AsFloat:=Rec.PPPNL2;
    end;
  finally
    FreeAndNil(FrmDLII410_custno);
  end;
end;

procedure TFrmDLII430.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer1.Enabled:=False;
  try
    if l_List2.Count=0 then
       Exit;

    while l_List2.Count>1 do
      l_List2.Delete(l_List2.Count-1);

    tmpSQL:=l_List2.Strings[0];
    if tmpSQL=l_SQL2 then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
 