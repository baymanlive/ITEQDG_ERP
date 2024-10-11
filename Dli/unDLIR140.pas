{*******************************************************}
{                                                       }
{                unDLIR140                              }
{                Author: kaikai                         }
{                Create date: 2017/9/8                  }
{                Description: 出貨達交率分析表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR140;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ComCtrls, ImgList, ExtCtrls, DB, DBClient, Math, GridsEh,
  DBAxisGridsEh, DBGridEh, StdCtrls, ToolWin, DateUtils, StrUtils;

type
  TFrmDLIR140 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    Lv1: TListView;
    Label3: TLabel;
    Label4: TLabel;
    Lv2: TListView;
    lt: TLabel;
    Lv3: TListView;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    l_IsDG:Boolean;
    l_SalCDS:TClientDataSet;
    l_AdCDS:TClientDataSet;
    l_LTAdCDS:TClientDataSet;
    l_CustnoCDS:TClientDataSet;
    l_StrIndex,l_StrIndexDesc:string;
    function GetNormalDay(ad:string):Integer;
    function GetLT(ad,pno,custno:string):string;
    function CheckLT(ad,pno,custno:string; LT:Integer):Boolean;
    procedure GetLTAdIndex(ad,pno,custno:string; var lt:Integer; var adstr:string);
    procedure GetDS(xFliter:string);
    { Private declarations }
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmDLIR140: TFrmDLIR140;

implementation

uses unGlobal, unCommon, unDLIR140_Query, unDLIR140_ExportXlsSelect;

{$R *.dfm}

const g_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="odate" fieldtype="date"/>'
            +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderitem" fieldtype="i4"/>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pname" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
            +'<FIELD attrname="longitude" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="latitude" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="c_orderno" fieldtype="string" WIDTH="50"/>'
            +'<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>'
            +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
            +'<FIELD attrname="orderqty" fieldtype="r8"/>'
            +'<FIELD attrname="custdate" fieldtype="date"/>'
            +'<FIELD attrname="edate" fieldtype="date"/>'
            +'<FIELD attrname="adate" fieldtype="date"/>'
            +'<FIELD attrname="cdate" fieldtype="date"/>'
            +'<FIELD attrname="sdate" fieldtype="date"/>'
            +'<FIELD attrname="indate" fieldtype="date"/>'
            +'<FIELD attrname="outqty" fieldtype="r8"/>'
            +'<FIELD attrname="outqty2" fieldtype="r8"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="overday" fieldtype="i4"/>'
            +'<FIELD attrname="leadtime" fieldtype="i4"/>'
            +'<FIELD attrname="reqlt" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="lttype" fieldtype="string" WIDTH="20"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="totcnt" fieldtype="i4"/>'
            +'<FIELD attrname="overdaycnt" fieldtype="i4"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml3='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="totcnt" fieldtype="i4"/>'
            +'<FIELD attrname="overdaycnt" fieldtype="i4"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml4='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="60"/>'
            +'<FIELD attrname="avglt" fieldtype="i4"/>'
            +'<FIELD attrname="reqlt" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="reqltX" fieldtype="i4"/>'
            +'<FIELD attrname="diffday" fieldtype="i4"/>'
            +'<FIELD attrname="ordcnt" fieldtype="i4"/>'
            +'<FIELD attrname="okcnt" fieldtype="i4"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

function TFrmDLIR140.GetNormalDay(ad:string):Integer;
var
  s:string;
begin
  s:='/'+ad+'/';
  if Pos(s,'/IT150G/IT168G1/')>0 then
     Result:=3
  else if Pos(s,'/IT988G/IT988SE/')>0 then
     Result:=15
  else if Pos(s,'/IT170GRA/IT170GRA1/')>0 then
     Result:=5
  else
     Result:=7;
end;

function TFrmDLIR140.GetLT(ad,pno,custno:string):string;
var
  s:string;
begin
  s:='/'+ad+'/';
  if SameText(custno,'AC111') then
  begin                                                     
    if (Length(pno)=17) and (Pos(LeftStr(pno,1),'ET')>0) and (Pos(Copy(pno,9,6),'370490,410490,430490')=0) then
       Result:='T+10'
    else if (Length(pno)=18) and (Pos(LeftStr(pno,1),'BR')>0) and (Copy(pno,4,4)='0106') then
       Result:='T+10'
    else if (Length(pno)=20) and (Pos(LeftStr(pno,1),'MN')>0) and (Copy(pno,4,4)='0106') then
       Result:='T+10'
    else if Pos(s,'/IT158/IT180A/IT170GRA/IT170GRA1/')>0 then
       Result:='T+4'
    else if Pos(s,'/IT150GS/')>0 then
       Result:='T+7'
    else if Pos(s,'/IT170GT/IT968/IT968SE/IT988G/IG988GSE')>0 then
       Result:='T+10'
    else if Pos(s,'/IT180I/IT150GX/IT958G/IT968G/')>0 then
       Result:='T+15'
    else if Pos(s,'/IT180/')>0 then
       Result:='T+30'
    else
       Result:='T+10';
  end else
  begin
    if (Pos(s,'/IT140G/IT150G/')>0) and (Pos(RightStr(pno,1),'nkNK')>0) then
       Result:='T+3'
    else if Pos(s,'/IT168G/IT168G1/')>0 then
       Result:='T+3'
    else if Pos(s,'/IT140G/IT150G/IT170GRA/IT170GRA1/')>0 then
       Result:='T+5'
    else if Pos(s,'/IT150GS/IT170GT/')>0 then
       Result:='T+7'
    else
       Result:='T+7';
  end;
end;

function TFrmDLIR140.CheckLT(ad,pno,custno:string; LT:Integer):Boolean;
var
  s:string;
begin
  Result:=False;
  s:='/'+ad+'/';
  if SameText(custno,'AC111') then
  begin
    if (Length(pno)=17) and (Pos(LeftStr(pno,1),'ET')>0) and (Pos(Copy(pno,9,6),'370490,410490,430490')=0) then
    begin
      if lt>10 then
         Result:=True;
    end
    else if (Length(pno)=18) and (Pos(LeftStr(pno,1),'BR')>0) and (Copy(pno,4,4)='0106') then
    begin
      if lt>10 then
         Result:=True;
    end
    else if (Length(pno)=20) and (Pos(LeftStr(pno,1),'MN')>0) and (Copy(pno,4,4)='0106') then
    begin
      if lt>10 then
         Result:=True;
    end
    else if Pos(s,'/IT158/IT180A/IT170GRA/IT170GRA1/')>0 then
    begin
      if lt>4 then
         Result:=True;
    end
    else if Pos(s,'/IT150GS/')>0 then
    begin
      if lt>7 then
         Result:=True;
    end
    else if Pos(s,'/IT170GT/IT968/IT968SE/IT988G/IG988GSE')>0 then
    begin
      if lt>10 then
         Result:=True;
    end
    else if Pos(s,'/IT180I/IT150GX/IT958G/IT968G/')>0 then
    begin
      if lt>15 then
         Result:=True;
    end
    else if Pos(s,'/IT180/')>0 then
    begin
      if lt>30 then
         Result:=True;
    end
    else if lt>10 then
       Result:=True;
  end else
  begin
    if Pos(s,'/IT140G/IT150G/')>0 then
    begin
      if Pos(RightStr(pno,1),'nkNK')>0 then
      begin
        if lt>3 then
           Result:=True;
      end else
      begin
        if lt>5 then
           Result:=True;
      end
    end
    else if Pos(s,'/IT168G/IT168G1/')>0 then
    begin
      if lt>3 then
         Result:=True;
    end
    else if Pos(s,'/IT170GRA/IT170GRA1/')>0 then
    begin
      if lt>5 then
         Result:=True;
    end
    else if Pos(s,'/IT150GS/IT170GT/')>0 then
    begin
      if lt>7 then
         Result:=True;
    end else
    if lt>7 then
       Result:=True;
  end;
end;

procedure TFrmDLIR140.GetLTAdIndex(ad,pno,custno:string; var lt:Integer; var adstr:string);
var
  s:string;
begin
  adstr:='';
  s:='/'+ad+'/';
  if SameText(custno,'AC111') then
  begin
    if (Length(pno)=17) and (Pos(LeftStr(pno,1),'ET')>0) and (Pos(Copy(pno,9,6),'370490,410490,430490')=0) then
    begin
      lt:=10;
      adstr:='方板(深南)';
    end
    else if (Length(pno)=18) and (Pos(LeftStr(pno,1),'BR')>0) and (Copy(pno,4,4)='0106') then
    begin
      lt:=10;
      adstr:='106玻布(深南)';
    end
    else if (Length(pno)=20) and (Pos(LeftStr(pno,1),'MN')>0) and (Copy(pno,4,4)='0106') then
    begin
      lt:=10;
      adstr:='106玻布(深南)';
    end
    else if Pos(s,'/IT158/IT180A/IT170GRA/IT170GRA1/')>0 then
    begin
      lt:=4;
      adstr:=ad+'(深南)';
    end
    else if Pos(s,'/IT150GS/')>0 then
    begin
      lt:=7;
      adstr:=ad+'(深南)';
    end
    else if Pos(s,'/IT170GT/IT968/IT968SE/IT988G/IG988GSE')>0 then
    begin
      lt:=10;
      adstr:=ad+'(深南)';
    end
    else if Pos(s,'/IT180I/IT150GX/IT958G/IT968G/')>0 then
    begin
      lt:=15;
      adstr:=ad+'(深南)';
    end
    else if Pos(s,'/IT180/')>0 then
    begin
      lt:=30;
      adstr:=ad+'(深南)';
    end
    else
    begin
      lt:=10;
      adstr:=ad+'(深南)';
    end
  end else
  begin
    if Pos(s,'/IT140G/IT150G/')>0 then
    begin
      if Pos(RightStr(pno,1),'nkNK')>0 then
      begin
        lt:=3;
        adstr:='IT150G,IT140G(N,K)';
      end else
      begin
        lt:=5;
        adstr:='IT150G,IT140G(非N,K)';
      end;
    end else
    if Pos(s,'/IT168G/IT168G1/')>0 then
    begin
      lt:=3;
      adstr:='IT168G,IT168G1';
    end else
    if Pos(s,'/IT170GRA/IT170GRA1/')>0 then
    begin
      lt:=5;
      adstr:='IT170GRA,IT170GRA1';
    end else
    if Pos(s,'/IT150GS/IT170GT/')>0 then
    begin
      lt:=7;
      adstr:=ad;
    end else
    begin
      lt:=7;
      adstr:=ad;
    end;
  end;
end;

procedure TFrmDLIR140.GetDS(xFliter:string);
var
  isOverLT:Boolean;
  ppQty1,ppQty2,cclQty1,cclQty2:double;
  pos1,reqlt:Integer;
  tmpDate1,tmpDate2:TDateTime;
  Data:OleVariant;
  tmpSQL,tmpOrderno,tmpBu,tmpSrcFlag,adstr:string;
  tmpCDS:TClientDataSet;
begin
  ppQty1:=0;
  ppQty2:=0;
  cclQty1:=0;
  cclQty2:=0;
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  l_CustnoCDS.EmptyDataSet;
  l_AdCDS.EmptyDataSet;
  l_LTAdCDS.EmptyDataSet;
  Lv1.Items.BeginUpdate;
  Lv2.Items.BeginUpdate;
  Lv3.Items.BeginUpdate;
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢訂單資料...');
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select C.*,oao06 from'
           +' (select B.*,ima021 from'
           +' (select A.*,occ02 from'
           +' (select oea01,oea02,oea04,oea044,oea10,oeb03,oeb04,oeb05,oeb06,'
           +' oeb11,oeb12,oeb15,oeb24,ta_oeb01,ta_oeb02,ta_oeb10,'
           +' to_char(oea02,''YYYY/MM/DD'') q_oea02'
           +' from oea_file inner join oeb_file on oea01=oeb01'
           +' where oeaconf=''Y'' and oeb70=''N'' and oeb12>0'
           +' and substr(oea01,1,3) not in (''226'',''22A'')'
           +' and substr(oea04,1,1)<>''N'''
           +' and substr(oeb04,length(oeb04),1)<>''0'''
           +' and substr(oeb04,1,1) in (''E'',''T'',''R'',''B'',''N'',''M'')) A'
           +' inner join occ_file on oea04=occ01 where 1=1 '+xFliter
           +' ) B left join ima_file on oeb04=ima01'
           +' ) C left join oao_file on oea01=oao01 and oeb03=oao03'
           +' order by oea04,oea02,oea01,oeb03';
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
      while not Eof do
      begin
        l_SalCDS.Append;
        l_SalCDS.FieldByName('odate').AsDateTime:=FieldByName('oea02').AsDateTime;
        l_SalCDS.FieldByName('orderno').AsString:=FieldByName('oea01').AsString;
        l_SalCDS.FieldByName('orderitem').AsInteger:=FieldByName('oeb03').AsInteger;
        l_SalCDS.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
        l_SalCDS.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
        pos1:=Pos('BS',FieldByName('oeb06').AsString);
        if pos1=0 then
           pos1:=Pos('TC',FieldByName('oeb06').AsString);
        if pos1=0 then
           pos1:=Pos('-',FieldByName('oeb06').AsString);
        if pos1>0 then
           l_SalCDS.FieldByName('ad').AsString:=Copy(FieldByName('oeb06').AsString,1,pos1-1);
        l_SalCDS.FieldByName('pno').AsString:=FieldByName('oeb04').AsString;
        l_SalCDS.FieldByName('pname').AsString:=FieldByName('oeb06').AsString;
        l_SalCDS.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
        l_SalCDS.FieldByName('longitude').AsString:=FieldByName('ta_oeb01').AsString;
        l_SalCDS.FieldByName('latitude').AsString:=FieldByName('ta_oeb02').AsString;
        l_SalCDS.FieldByName('c_orderno').AsString:=FieldByName('oea10').AsString;
        l_SalCDS.FieldByName('remark').AsString:=FieldByName('oao06').AsString;
        l_SalCDS.FieldByName('units').AsString:=FieldByName('oeb05').AsString;
        l_SalCDS.FieldByName('orderqty').AsFloat:=FieldByName('oeb12').AsFloat;
        l_SalCDS.FieldByName('outqty').AsFloat:=FieldByName('oeb24').AsFloat;
        if SameText(FieldByName('oeb05').AsString, 'RL') then
           l_SalCDS.FieldByName('outqty2').AsFloat:=StrToInt(Copy(FieldByName('oeb04').AsString,11,3))*FieldByName('oeb24').AsFloat
        else if SameText(FieldByName('oeb05').AsString, 'PN') then
        begin
          if FieldByName('oeb04').AsString[1] in ['E','T'] then
             l_SalCDS.FieldByName('outqty2').AsFloat:=RoundTo(FieldByName('oeb24').AsFloat/5, -2)
          else
             l_SalCDS.FieldByName('outqty2').AsFloat:=RoundTo(FieldByName('oeb24').AsFloat/3.75, -2);
        end else
           l_SalCDS.FieldByName('outqty2').AsFloat:=FieldByName('oeb24').AsFloat;

        try
          l_SalCDS.FieldByName('custdate').AsDateTime:=FieldByName('oeb15').AsDateTime;
        except
          l_SalCDS.FieldByName('custdate').AsDateTime:=Encodedate(1955,1,1);
        end;

        l_SalCDS.FieldByName('edate').AsDateTime:=FieldByName('oea02').AsDateTime+GetNormalDay(l_SalCDS.FieldByName('ad').AsString);
        l_SalCDS.FieldByName('reqlt').AsString:=GetLT(UpperCase(l_SalCDS.FieldByName('ad').AsString),FieldByName('oeb04').AsString,FieldByName('oea04').AsString);
        l_SalCDS.Post;

        //客戶達成率
        if not l_CustnoCDS.Locate('custno',FieldByName('oea04').AsString,[]) then
        begin
          l_CustnoCDS.Append;
          l_CustnoCDS.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
          l_CustnoCDS.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
        end else
          l_CustnoCDS.Edit;
        l_CustnoCDS.FieldByName('totcnt').AsInteger:=l_CustnoCDS.FieldByName('totcnt').AsInteger+1;
        l_CustnoCDS.Post;

        //膠系達成率
        if Length(l_SalCDS.FieldByName('ad').AsString)>0 then
        begin
          if not l_AdCDS.Locate('ad',l_SalCDS.FieldByName('ad').AsString,[]) then
          begin
            l_AdCDS.Append;
            l_AdCDS.FieldByName('ad').AsString:=l_SalCDS.FieldByName('ad').AsString;
          end else
            l_AdCDS.Edit;
          l_AdCDS.FieldByName('totcnt').AsInteger:=l_AdCDS.FieldByName('totcnt').AsInteger+1;
          l_AdCDS.Post;
        end;

        if Pos(FieldByName('oea01').AsString,tmpOrderno)=0 then
           tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('oea01').AsString);
        Next;
      end;
    end;

    //***生管達交日期、Call貨日期***
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢達交日期、Call貨日期...');
    Application.ProcessMessages;
    if l_IsDG then
       tmpBu:='ITEQDG'
    else
       tmpBu:='ITEQGZ';
    Delete(tmpOrderno,1,1);
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem,Min(Adate) Adate,Min(Cdate) Cdate'
           +' From MPS200 Where Bu='+Quotedstr(tmpBu)
           +' And Orderno in ('+tmpOrderno+')'
           +' And IsNull(GarbageFlag,0)=0'
           +' Group By Orderno,Orderitem'
           +' Order By Orderno,Orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if (not FieldByName('Adate').IsNull) or (not FieldByName('Cdate').IsNull) then
      if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno').AsString,
                IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
      begin
        l_SalCDS.Edit;
        if not FieldByName('Adate').IsNull then
           l_SalCDS.FieldByName('adate').AsDateTime:=FieldByName('Adate').AsDateTime;
        if not FieldByName('Cdate').IsNull then
           l_SalCDS.FieldByName('cdate').AsDateTime:=FieldByName('Cdate').AsDateTime;
        l_SalCDS.Post;
      end;
      Next;
    end;
    //***生管達交日期、Call貨日期***

    //***出貨日期***
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢出貨日期...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem,Indate'
           +' From DLI010 Where Bu='+Quotedstr(tmpBu)
           +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
           +' And Indate<getdate()'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
           +' And Orderno in ('+tmpOrderno+')'
           +' Union All'
           +' Select Orderno,Orderitem,Indate'
           +' From DLI010_20160409 Where Bu='+Quotedstr(tmpBu)
           +' And IsNull(GarbageFlag,0)=0 And IsNull(Chkcount,0)>0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
           +' And Orderno in ('+tmpOrderno+')';
    tmpSQL:='Select Orderno,Orderitem,Min(Indate) Indate'
           +' From ('+tmpSQL+') x'
           +' Group By Orderno,Orderitem'
           +' Order By Orderno,Orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if not FieldByName('Indate').IsNull then
      if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno').AsString,
                IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
      begin
        l_SalCDS.Edit;
        l_SalCDS.FieldByName('indate').AsDateTime:=FieldByName('Indate').AsDateTime;
        l_SalCDS.Post;
      end;
      Next;
    end;
    //***出貨日期***
  
    //***生產日期***
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢生產日期...');
    Application.ProcessMessages;
    if l_IsDG then
       tmpSrcFlag:=' And SrcFlag in (1,3,5)'
    else
       tmpSrcFlag:=' And SrcFlag in (2,4,6)';
    //ccl
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem,Sdate'
           +' From MPS010 Where Bu=''ITEQDG'''
           +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
           +' And Orderno in ('+tmpOrderno+')'
           +' Union'
           +' Select Orderno,Orderitem,Sdate'
           +' From MPS010_20160409 Where Bu=''ITEQDG'''
           +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
           +' And Orderno in ('+tmpOrderno+')';
    tmpSQL:='Select Orderno,Orderitem,Min(Sdate) Sdate'
           +' From ('+tmpSQL+') x'
           +' Group By Orderno,Orderitem'
           +' Order By Orderno,Orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if not FieldByName('Sdate').IsNull then
      if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno').AsString,
                IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
      begin
        l_SalCDS.Edit;
        l_SalCDS.FieldByName('sdate').AsDateTime:=FieldByName('Sdate').AsDateTime;
        l_SalCDS.Post;
      end;
      Next;
    end;
    //pp
    Data:=null;
    tmpSQL:='Select Orderno,Orderitem,Min(Sdate) Sdate'
           +' From MPS070 Where Bu=''ITEQDG'''
           +' And IsNull(ErrorFlag,0)=0 '+tmpSrcFlag
           +' And Orderno in ('+tmpOrderno+')'
           +' Group By Orderno,Orderitem'
           +' Order By Orderno,Orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if not FieldByName('Sdate').IsNull then
      if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno').AsString,
                IntToStr(FieldByName('orderitem').AsInteger)]),[]) then
      begin
        l_SalCDS.Edit;
        l_SalCDS.FieldByName('sdate').AsDateTime:=FieldByName('Sdate').AsDateTime;
        l_SalCDS.Post;
      end;
      Next;
    end;
    //***生產日期***

    g_StatusBar.Panels[0].Text:=CheckLang('正在計算達成率...');
    Application.ProcessMessages;
    with l_SalCDS do
    begin
      First;
      While not Eof do
      begin
        Edit;
        if not FieldByName('cdate').IsNull then
           tmpDate1:=FieldByName('cdate').AsDateTime
        else if not FieldByName('adate').IsNull then
           tmpDate1:=FieldByName('adate').AsDateTime
        else
           tmpDate1:=EncodeDate(2078,1,1);

        if FieldByName('indate').IsNull then
           tmpDate2:=Date
        else
           tmpDate2:=FieldByName('indate').AsDateTime;

        //甩期天數:出貨日期-call貨日期或拆分日期
        if tmpDate2>tmpDate1 then
           FieldByName('overday').AsInteger:=DaysBetween(tmpDate1,tmpDate2)
        else
           FieldByName('overday').AsInteger:=0;

        //Leadtime:日期-訂單日期
        tmpDate1:=FieldByName('odate').AsDateTime;
        if not FieldByName('indate').IsNull then
           tmpDate2:=FieldByName('indate').AsDateTime
        else if not FieldByName('cdate').IsNull then
           tmpDate2:=FieldByName('cdate').AsDateTime
        else if not FieldByName('adate').IsNull then
           tmpDate2:=FieldByName('adate').AsDateTime
        else
           tmpDate2:=EncodeDate(1955,1,1);

        if tmpDate1<tmpDate2 then
           FieldByName('leadtime').AsInteger:=DaysBetween(tmpDate1,tmpDate2)
        else
           FieldByName('leadtime').AsInteger:=0;

        isOverLT:=CheckLT(UpperCase(FieldByName('ad').AsString),FieldByName('pno').AsString,FieldByName('custno').AsString,FieldByName('leadtime').AsInteger);
        if not isOverLT then
           FieldByName('lttype').AsString:='OK'
        else if tmpDate2=EncodeDate(1955,1,1) then
           FieldByName('lttype').AsString:=CheckLang('未答交')
        else if (not FieldByName('custdate').IsNull) and (tmpDate2<=FieldByName('custdate').AsDateTime) then
           FieldByName('lttype').AsString:=CheckLang('PO指定交期')
        else
           FieldByName('lttype').AsString:=CheckLang('交期未達成');
        Post;

        //達成率:以客戶或膠系小計
        if FieldByName('overday').AsInteger<>0 then
        begin
          if l_CustnoCDS.Locate('custno',FieldByName('custno').AsString,[]) then
          begin
            l_CustnoCDS.Edit;
            l_CustnoCDS.FieldByName('overdaycnt').AsInteger:=l_CustnoCDS.FieldByName('overdaycnt').AsInteger+1;
            l_CustnoCDS.Post;
          end;
          if l_AdCDS.Locate('ad',FieldByName('ad').AsString,[]) then
          begin
            l_AdCDS.Edit;
            l_AdCDS.FieldByName('overdaycnt').AsInteger:=l_AdCDS.FieldByName('overdaycnt').AsInteger+1;
            l_AdCDS.Post;
          end;
        end;

        //已出貨所有膠系LT
        if not FieldByName('indate').IsNull then
        begin
          GetLTAdIndex(FieldByName('ad').AsString,FieldByName('pno').AsString,FieldByName('custno').AsString,reqlt,adstr);
          if not l_LTAdCDS.Locate('ad',adstr,[]) then
          begin
            l_LTAdCDS.Append;
            l_LTAdCDS.FieldByName('ad').AsString:=adstr;
            l_LTAdCDS.FieldByName('reqlt').AsString:='T+'+IntToStr(reqlt);
            l_LTAdCDS.FieldByName('reqltX').AsInteger:=reqlt;
          end else
            l_LTAdCDS.Edit;
          l_LTAdCDS.FieldByName('avglt').AsInteger:=l_LTAdCDS.FieldByName('avglt').AsInteger+FieldByName('leadtime').AsInteger;
          l_LTAdCDS.FieldByName('ordcnt').AsInteger:=l_LTAdCDS.FieldByName('ordcnt').AsInteger+1;
          if (FieldByName('indate').AsDateTime=FieldByName('custdate').AsDateTime) or
             (FieldByName('leadtime').AsInteger<=reqlt) then
             l_LTAdCDS.FieldByName('okcnt').AsInteger:=l_LTAdCDS.FieldByName('okcnt').AsInteger+1;
          l_LTAdCDS.Post;
        end;

        if FieldByName('Pno').AsString[1] in ['E','T'] then
        begin
          cclQty1:=cclQty1+FieldByName('outqty2').AsFloat*FieldByName('leadtime').AsInteger;
          cclQty2:=cclQty2+FieldByName('outqty2').AsFloat;
        end else
        begin
          ppQty1:=ppQty1+FieldByName('outqty2').AsFloat*FieldByName('leadtime').AsInteger;
          ppQty2:=ppQty2+FieldByName('outqty2').AsFloat;
        end;

        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在添加計算結果...');
    Application.ProcessMessages;
    Lv1.Items.Clear;
    Lv2.Items.Clear;
    Lv3.Items.Clear;
    with l_CustnoCDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('per').AsString:=FloatToStr(Round((FieldByName('totcnt').AsInteger-FieldByName('overdaycnt').AsInteger)/FieldByName('totcnt').AsInteger*100))+'%';
        Post;

        with Lv1.Items.Add do
        begin
          Caption:=FieldByName('custno').AsString;
          SubItems.Add(FieldByName('custshort').AsString);
          SubItems.Add(IntToStr(FieldByName('totcnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('overdaycnt').AsInteger));
          SubItems.Add(FieldByName('per').AsString);
        end;
        Next;
      end;
    end;

    with l_AdCDS do
    begin
      First;
      While not Eof do
      begin
        Edit;
        FieldByName('per').AsString:=FloatToStr(Round((FieldByName('totcnt').AsInteger-FieldByName('overdaycnt').AsInteger)/FieldByName('totcnt').AsInteger*100))+'%';
        Post;
        with Lv2.Items.Add do
        begin
          Caption:=FieldByName('ad').AsString;
          SubItems.Add(IntToStr(FieldByName('totcnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('overdaycnt').AsInteger));
          SubItems.Add(FieldByName('per').AsString);
        end;
        Next;
      end;
    end;

    with l_LTAdCDS do
    begin
      First;
      While not Eof do
      begin
        Edit;
        FieldByName('avglt').AsInteger:=Round(FieldByName('avglt').AsInteger/FieldByName('ordcnt').AsInteger);
        FieldByName('diffday').AsInteger:=FieldByName('avglt').AsInteger-FieldByName('reqltX').AsInteger;
        FieldByName('per').AsString:=FloatToStr(Round(FieldByName('okcnt').AsInteger/FieldByName('ordcnt').AsInteger*100))+'%';
        Post;
        with Lv3.Items.Add do
        begin
          Caption:=FieldByName('ad').AsString;
          SubItems.Add(IntToStr(FieldByName('avglt').AsInteger));
          SubItems.Add(FieldByName('reqlt').AsString);
          SubItems.Add(IntToStr(FieldByName('diffday').AsInteger));
          SubItems.Add(IntToStr(FieldByName('ordcnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('okcnt').AsInteger));
          SubItems.Add(FieldByName('per').AsString);
        end;
        Next;
      end;
    end;

    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;
    if l_CustnoCDS.ChangeCount>0 then
       l_CustnoCDS.MergeChangeLog;
    if l_AdCDS.ChangeCount>0 then
       l_AdCDS.MergeChangeLog;
    if l_LTAdCDS.ChangeCount>0 then
       l_LTAdCDS.MergeChangeLog;
  finally
    Lv1.Items.EndUpdate;
    Lv2.Items.EndUpdate;
    Lv3.Items.EndUpdate;
    FreeAndNil(tmpCDS);
    l_SalCDS.EnableControls;
    CDS.Data:=l_SalCDS.Data;
    if ppQty2<>0 then
       ppQty1:=RoundTo(ppQty1/ppQty2,-2)
    else
       ppQty1:=0;
    if cclQty2<>0 then
       cclQty1:=RoundTo(cclQty1/cclQty2,-2)
    else
       cclQty1:=0;
    lt.Caption:='Lead Time PP:'+FloatToStr(ppQty1)+'    CCL:'+FloatToStr(cclQty1);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR140.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmDLIR140.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR140';
  p_GridDesignAns:=True;
  l_IsDG:=SameText(g_UInfo^.BU, 'ITEQDG');
  l_SalCDS:=TClientDataSet.Create(Self);
  l_CustnoCDS:=TClientDataSet.Create(Self);
  l_AdCDS:=TClientDataSet.Create(Self);
  l_LTAdCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS, g_Xml1);
  InitCDS(l_CustnoCDS, g_Xml2);
  InitCDS(l_AdCDS, g_Xml3);
  InitCDS(l_LTAdCDS, g_Xml4);
  l_CustnoCDS.IndexFieldNames:='custno';
  l_AdCDS.IndexFieldNames:='ad';
  l_LTAdCDS.IndexFieldNames:='ad';

  inherited;

  TabSheet2.Caption:=CheckLang('達成率');
  lt.Caption:='Lead Time PP:    CCL:0';
  Label3.Caption:=CheckLang('客戶達成率');
  Label4.Caption:=CheckLang('膠系達成率');
  Label5.Caption:=CheckLang('已出貨膠系LT狀況');
  with Lv1.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('客戶編號');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('客戶簡稱');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('總筆數');
      Width:=60;
    end;
    with Add do
    begin
      Caption:=CheckLang('甩期筆數');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('達成率');
      Width:=60;
    end;
    EndUpdate;
  end;

  with Lv2.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('膠系');
      Width:=100;
    end;
    with Add do
    begin
      Caption:=CheckLang('總筆數');
      Width:=60;
    end;
    with Add do
    begin
      Caption:=CheckLang('甩期筆數');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('達成率');
      Width:=60;
    end;
    EndUpdate;
  end;

  with Lv3.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('膠系');
      Width:=140;
    end;
    with Add do
    begin
      Caption:=CheckLang('平均LT');
      Width:=60;
    end;
    with Add do
    begin
      Caption:=CheckLang('要求LT');
      Width:=60;
    end;
    with Add do
    begin
      Caption:=CheckLang('差異天數');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('訂單筆數');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('符合筆數');
      Width:=70;
    end;
    with Add do
    begin
      Caption:=CheckLang('符合率');
      Width:=60;
    end;
    EndUpdate;
  end;
end;

procedure TFrmDLIR140.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SalCDS);
  FreeAndNil(l_CustnoCDS);
  FreeAndNil(l_AdCDS);
  FreeAndNil(l_LTAdCDS);
end;

procedure TFrmDLIR140.btn_exportClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR140_ExportXlsSelect) then
     FrmDLIR140_ExportXlsSelect:=TFrmDLIR140_ExportXlsSelect.Create(Application);
  if FrmDLIR140_ExportXlsSelect.ShowModal=mrOK then
  begin
    case FrmDLIR140_ExportXlsSelect.rgp.ItemIndex of
      0:GetExportXls(CDS, p_TableName);
      1:GetExportXls(l_CustnoCDS, 'DLIR140_1');
      2:GetExportXls(l_AdCDS, 'DLIR140_2');
      3:GetExportXls(l_LTAdCDS, 'DLIR140_3');
    end;
  end;
end;

procedure TFrmDLIR140.btn_queryClick(Sender: TObject);
var
  str:string;
begin
  //inherited;
  if not Assigned(FrmDLIR140_Query) then
     FrmDLIR140_Query:=TFrmDLIR140_Query.Create(Application);
  if FrmDLIR140_Query.ShowModal=mrOK then
  begin
    l_IsDG:=FrmDLIR140_Query.rgp.ItemIndex=0;
    str:=' and q_oea02>='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR140_Query.Dtp1.Date),'-','/',[rfReplaceAll]))
        +' and q_oea02<='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmDLIR140_Query.Dtp2.Date),'-','/',[rfReplaceAll]));
    if Length(Trim(FrmDLIR140_Query.Edit2.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmDLIR140_Query.Edit2.Text)))+',oea01)>0';
    if Length(Trim(FrmDLIR140_Query.Edit1.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmDLIR140_Query.Edit1.Text)))+',oea04)>0';
    if Length(Trim(FrmDLIR140_Query.Edit3.Text))>0 then
       str:=str+' and instr('+Quotedstr(Trim(FrmDLIR140_Query.Edit3.Text))+',substr(oeb04,2,1))>0';
    if Length(Trim(FrmDLIR140_Query.Edit4.Text))>0 then
       str:=str+' and instr('+Quotedstr(Trim(FrmDLIR140_Query.Edit4.Text))+',substr(oeb04,length(oeb04),1))>0';
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(str);
  end;
end;

procedure TFrmDLIR140.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLIR140.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName,'leadtime') then
  if CheckLT(UpperCase(CDS.FieldByName('ad').AsString),CDS.FieldByName('pno').AsString,CDS.FieldByName('custno').AsString,CDS.FieldByName('leadtime').AsInteger) then
     Background:=clRed;
end;

end.
