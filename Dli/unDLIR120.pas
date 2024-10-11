{*******************************************************}
{                                                       }
{                unDLIR120                              }
{                Author: kaikai                         }
{                Create date: 2017/7/28                 }
{                Description: 成本出貨清單              }
{                             報表設計權限顯示單價,金額 }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR120;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, Math;

type
  TFrmDLIR120 = class(TFrmSTDI031)
    btn_dlir120A: TBitBtn;
    btn_dlir120B: TBitBtn;
    btn_dlir120C: TBitBtn;
    PopupMenu1: TPopupMenu;
    N_del1: TMenuItem;
    N_del2: TMenuItem;
    N_edit1: TMenuItem;
    N_xxxx: TMenuItem;
    N_del3: TMenuItem;
    N_clr: TMenuItem;
    N2: TMenuItem;
    PnlRight: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_dlir120AClick(Sender: TObject);
    procedure btn_dlir120BClick(Sender: TObject);
    procedure btn_dlir120CClick(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N_del1Click(Sender: TObject);
    procedure N_del2Click(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure m_queryClick(Sender: TObject);
    procedure N_edit1Click(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure N_del3Click(Sender: TObject);
    procedure N_clrClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
  private
    { Private declarations }
    l_rgpIndex:Integer;
    l_filter:string;
    l_SelList:TStrings;
    l_StrIndex,l_StrIndexDesc:string;
    function GetMaxDitem:Integer;
    function GetDS(xFliter:string):Boolean;
    procedure qtyChange(Sender: TField);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR120: TFrmDLIR120;

implementation

uses unGlobal, unCommon, unDLIR120_Query, unDLIR120_Conf,
  unDLIR120_ConfDetail, unDLIR120_unit;

{$R *.dfm}

function TFrmDLIR120.GetMaxDitem:Integer;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select IsNull(Max(Ditem),0)+1 as Id From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.BU);
  if QueryOneCR(tmpSQL, Data) then
     Result:=StrToIntDef(VarToStr(Data),1)
  else
     Result:=0;
end;

function TFrmDLIR120.GetDS(xFliter:string):Boolean;
const l_diff=0.000001;
const l_sfdeci=-2;
var
  len,tmpDitem:Integer;
  tmpData:OleVariant;
  tmpSQL,tmpSlip,tmpSaleno,tmpOrderno,tmpORADB:string;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
begin
  Result:=False;

  tmpORADB:='ORACLE';
  tmpSlip:='''235'',''S31'',''P31'',''P3Q'',''P38'',''P3L''';
  if SameText(g_UInfo^.BU, 'ITEQGZ') then
  begin
    tmpORADB:='ORACLE1';
    tmpSlip:='''235'',''P3T'',''S3C''';
  end;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    tmpSQL:='Select * From '+p_TableName+' Where Bu='+Quotedstr(g_UInfo^.BU)+l_filter;
    if not QueryBySQL(tmpSQL, tmpData) then
       Exit;
    tmpCDS1.Data:=tmpData;

    tmpData:=null;
    tmpSQL:='select E.*,oao06 from'
           +' (select D.*,oeb11,ta_oeb01,ta_oeb02,ta_oeb10 from'
           +' (select C.*,oea10 from'
           +' (select B.*,ima18,ima021,ta_ima01,ta_ima02 from'
           +' (select A.*,occ02 from'
           +' (select oga01,oga02,oga04,oga23,ogb03,ogb04,ogb05,ogb05_fac,ogb06,'
           +' ogb12,ogb13,ogb14,ogb31,ogb32,to_char(oga02,''YYYY/MM/DD'') q_oga02'
           +' from oga_file inner join ogb_file on oga01=ogb01'
           +' where ogaconf=''Y'' and substr(oga01,1,3) in ('+tmpSlip+') and ogb05<>''KG'') A'
           +' inner join occ_file on oga04=occ01 where 1=1 '+xFliter
           +' ) B inner join ima_file on ogb04=ima01'
           +' ) C inner join oea_file on ogb31=oea01'
           +' ) D inner join oeb_file on ogb31=oeb01 and ogb32=oeb03'
           +' ) E left join oao_file on ogb31=oao01 and ogb32=oao03 and oao05=2'
           +' order by oga02,oga01,ogb03';
    if not QueryBySQL(tmpSQL, tmpData, tmpORADB) then
       Exit;

    tmpCDS2.Data:=tmpData;
    with tmpCDS2 do
    begin
      if IsEmpty then
         Exit;

      if l_rgpIndex<>2 then
      begin
        First;
        while not Eof do
        begin
          tmpSaleno:=tmpSaleno+','+Quotedstr(FieldByName('oga01').AsString);
          Next;
        end;

        if Length(tmpSaleno)>0 then
        begin
          System.Delete(tmpSaleno,1,1);
          tmpSQL:='Select B.Saleno From DLI013 A Inner Join DLI014 B'
                 +' ON A.Bu=B.Bu And A.Dno=B.Dno'
                 +' Where A.Bu='+Quotedstr(g_UInfo^.BU)+' And A.Conf=''Y'''
                 +' And B.Saleno in ('+tmpSaleno+')';
          if not QueryBySQL(tmpSQL, tmpData) then
             Exit;
          tmpCDS3.Data:=tmpData;  //已出廠鎖貨單號
        end;
      end;

      tmpDitem:=-1;
      First;
      while not Eof do
      begin
        if tmpCDS1.Locate('saleno;saleitem',VarArrayOf([FieldByName('oga01').AsString,
            FieldByName('ogb03').AsInteger]),[]) then
        begin
          Next;
          Continue;
        end;

        if (l_rgpIndex<>2) and tmpCDS3.Active then
        begin
          if l_rgpIndex=0 then  //未出廠
          begin
            if tmpCDS3.Locate('saleno',FieldByName('oga01').AsString,[]) then
            begin
              Next;
              Continue;
            end;
          end else              //已出廠
          begin
            if not tmpCDS3.Locate('saleno',FieldByName('oga01').AsString,[]) then
            begin
              Next;
              Continue;
            end;
          end
        end;

        if tmpDitem=-1 then
           tmpDitem:=GetMaxDitem;
        tmpSQL:=LeftStr(FieldByName('ogb04').AsString,1); //第1碼
        len:=Length(FieldByName('ogb04').AsString);
        tmpCDS1.Append;
        tmpCDS1.FieldByName('bu').AsString:=g_UInfo^.BU;
        tmpCDS1.FieldByName('dno').AsString:='A';
        tmpCDS1.FieldByName('ditem').AsInteger:=tmpDitem;
        tmpCDS1.FieldByName('saleno').AsString:=FieldByName('oga01').AsString;
        tmpCDS1.FieldByName('saleitem').AsInteger:=FieldByName('ogb03').AsInteger;
        tmpCDS1.FieldByName('saledate').AsDateTime:=FieldByName('oga02').AsDateTime;
        tmpCDS1.FieldByName('custno').AsString:=FieldByName('oga04').AsString;
        tmpCDS1.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
        tmpCDS1.FieldByName('pno').AsString:=FieldByName('ogb04').AsString;
        tmpCDS1.FieldByName('pname').AsString:=FieldByName('ogb06').AsString;
        tmpCDS1.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
        if len=17 then
        begin
          tmpCDS1.FieldByName('longitude').AsFloat:=StrToInt(Copy(FieldByName('ogb04').AsString,9,3))/10;
          tmpCDS1.FieldByName('latitude').AsFloat:=StrToInt(Copy(FieldByName('ogb04').AsString,12,3))/10;
        end else
        if len=18 then
        begin
          tmpCDS1.FieldByName('longitude').AsFloat:=StrToFloat(Copy(FieldByName('ogb04').AsString,11,3));
          tmpCDS1.FieldByName('latitude').AsFloat:=StrToInt(Copy(FieldByName('ogb04').AsString,14,3))/10;
        end else
        begin
          tmpCDS1.FieldByName('longitude').AsFloat:=FieldByName('ta_oeb01').AsFloat;
          tmpCDS1.FieldByName('latitude').AsFloat:=FieldByName('ta_oeb02').AsFloat;
        end;
        if (tmpSQL='E') or (tmpSQL='T') then
           tmpCDS1.FieldByName('thickness').AsFloat:=StrToInt(Copy(FieldByName('ogb04').AsString,3,4))/10000;
        tmpCDS1.FieldByName('qty').AsFloat:=FieldByName('ogb12').AsFloat;
        tmpCDS1.FieldByName('units').AsString:=FieldByName('ogb05').AsString;
        tmpCDS1.FieldByName('price').AsFloat:=FieldByName('ogb13').AsFloat;
        tmpCDS1.FieldByName('amt').AsFloat:=FieldByName('ogb14').AsFloat;
        tmpCDS1.FieldByName('cashtype').AsString:=FieldByName('oga23').AsString;
        if (Pos(tmpSQL,'MNET')>0) and (len<=12) then
           tmpCDS1.FieldByName('kg').AsFloat:=GetKG(FieldByName('oga01').AsString,FieldByName('ogb03').AsInteger,0)
        else if len=18 then
           tmpCDS1.FieldByName('kg').AsFloat:=FieldByName('ima18').AsFloat*StrToInt(Copy(FieldByName('ogb04').AsString,11,3))
        else
           tmpCDS1.FieldByName('kg').AsFloat:=FieldByName('ima18').AsFloat;
        tmpCDS1.FieldByName('kg').AsFloat:=RoundTo(tmpCDS1.FieldByName('kg').AsFloat, -3);
        tmpCDS1.FieldByName('nw').AsFloat:=RoundTo(tmpCDS1.FieldByName('kg').AsFloat*FieldByName('ogb12').AsFloat,-2);
        tmpCDS1.FieldByName('orderno').AsString:=FieldByName('ogb31').AsString;
        tmpCDS1.FieldByName('orderitem').AsInteger:=FieldByName('ogb32').AsInteger;
        tmpCDS1.FieldByName('custorderno').AsString:=FieldByName('oea10').AsString;
        tmpCDS1.FieldByName('custprono').AsString:=FieldByName('oeb11').AsString;
        tmpCDS1.FieldByName('custname').AsString:=FieldByName('ta_oeb10').AsString;
        tmpCDS1.FieldByName('remark').AsString:=FieldByName('oao06').AsString;

        //面積
        if tmpSQL='R' then
           tmpCDS1.FieldByName('sf').AsFloat:=RoundTo((FieldByName('ta_ima01').AsFloat*FieldByName('ta_ima02').AsFloat*39.37)/144+l_diff,l_sfdeci)
        else
           tmpCDS1.FieldByName('sf').AsFloat:=RoundTo((FieldByName('ta_ima01').AsFloat*FieldByName('ta_ima02').AsFloat)/144*FieldByName('ogb05_fac').AsFloat+l_diff,l_sfdeci);

        if ((tmpSQL='R') or (tmpSQL='B')) and
           (FieldByName('oga04').AsString='AC091') and
           (Copy(FieldByName('ogb04').AsString,14,3)='428') then
           tmpCDS1.FieldByName('sf').AsFloat:=RoundTo((FieldByName('ogb05_fac').AsFloat*42.85*39.37)/144+l_diff,l_sfdeci);

        tmpCDS1.FieldByName('totsf').AsFloat:=RoundTo(FieldByName('ogb12').AsFloat*tmpCDS1.FieldByName('sf').AsFloat+l_diff,l_sfdeci);
        if Pos(FieldByName('ogb05').AsString,'RL/ROL')>0 then
           tmpCDS1.FieldByName('totsf1').AsFloat:=RoundTo(tmpCDS1.FieldByName('longitude').AsFloat*tmpCDS1.FieldByName('latitude').AsFloat*FieldByName('ogb12').AsFloat*0.0254,-2)
        else
           tmpCDS1.FieldByName('totsf1').AsFloat:=RoundTo(tmpCDS1.FieldByName('longitude').AsFloat*tmpCDS1.FieldByName('latitude').AsFloat*FieldByName('ogb12').AsFloat*0.0254*0.0254,-2);

        if tmpCDS1.FieldByName('totsf1').AsFloat=0 then
           tmpCDS1.FieldByName('gsf').AsFloat:=0
        else
           tmpCDS1.FieldByName('gsf').AsFloat:=RoundTo(tmpCDS1.FieldByName('nw').AsFloat/tmpCDS1.FieldByName('totsf1').AsFloat*1000,-2);

        if (FieldByName('oga04').AsString='AC148') and
           ((tmpSQL='R') or (tmpSQL='P')) then
        begin
          if FieldByName('ogb05_fac').AsFloat=150 then
          begin
            tmpCDS1.FieldByName('sf').AsFloat:=1968.5;
            tmpCDS1.FieldByName('totsf').AsFloat:=1968.5*FieldByName('ogb12').AsFloat;
          end else
          if FieldByName('ogb05_fac').AsFloat=200 then
          begin
            tmpCDS1.FieldByName('sf').AsFloat:=2624.7;
            tmpCDS1.FieldByName('totsf').AsFloat:=2624.7*FieldByName('ogb12').AsFloat;
          end else
          if FieldByName('ogb05_fac').AsFloat=300 then
          begin
            tmpCDS1.FieldByName('sf').AsFloat:=3937;
            tmpCDS1.FieldByName('totsf').AsFloat:=3937*(FieldByName('ogb12').AsFloat);
          end;
        end;
        if tmpCDS1.FieldByName('sf').AsFloat=0 then
           tmpCDS1.FieldByName('sf').Clear;
        if tmpCDS1.FieldByName('totsf').AsFloat=0 then
           tmpCDS1.FieldByName('totsf').Clear;
        //面積

        tmpCDS1.FieldByName('flag').AsBoolean:=false;
        tmpCDS1.FieldByName('iuser').AsString:=g_UInfo^.Wk_no;
        tmpCDS1.FieldByName('idate').AsDateTime:=Now;
        tmpCDS1.Post;
        if Pos(LeftStr(FieldByName('ogb31').AsString,3),'S11,S1C')>0 then
           tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('ogb31').AsString);
        tmpDitem:=tmpDitem+1;
        Next;
      end;
    end;

    if Length(tmpOrderno)>0 then
    begin
      Delete(tmpOrderno,1,1);
      tmpData:=null;
//      tmpSQL:='Select oeb01,oeb03,oeb12,oeb13,oeb14 From iteq2.oeb_file where oeb01 in ('+tmpOrderno+')';
      tmpSQL:='Select a.oeb01,a.oeb03,a.oeb12,a.oeb13,a.oeb14,b.oeb12 dg_oeb12,b.oeb13 dg_oeb13,b.oeb14 dg_oeb14 From iteq2.oeb_file a inner join iteq2.oeb_file b on a.oeb01=b.oeb01 and a.oeb3=b.oeb3 where a.oeb01 in ('+tmpOrderno+')';
      if not QueryBySQL(tmpSQL, tmpData, 'ORACLE') then
         Exit;
      tmpCDS2.Data:=tmpData;
      with tmpCDS1 do
      begin
        First;
        while not Eof do
        begin
          if tmpCDS2.Locate('oeb01;oeb03',VarArrayOf([FieldByName('orderno').AsString,
            FieldByName('orderitem').AsInteger]),[]) then
          begin
            Edit;
            FieldByName('price').AsFloat:=tmpCDS2.FieldByName('oeb13').AsFloat;
            FieldByName('price2').AsFloat:=tmpCDS2.FieldByName('dg_oeb13').AsFloat;
            if FieldByName('qty').AsFloat=tmpCDS2.FieldByName('oeb12').AsFloat then
               FieldByName('amt').AsFloat:=tmpCDS2.FieldByName('oeb14').AsFloat
            else
               FieldByName('amt').AsFloat:=RoundTo(FieldByName('qty').AsFloat*FieldByName('price').AsFloat,-6);
            if FieldByName('qty').AsFloat=tmpCDS2.FieldByName('dg_oeb12').AsFloat then
               FieldByName('amt2').AsFloat:=tmpCDS2.FieldByName('dg_oeb14').AsFloat
            else
               FieldByName('amt2').AsFloat:=RoundTo(FieldByName('qty').AsFloat*FieldByName('price2').AsFloat,-6);
            Post;
          end;
          Next;
        end;
      end;
    end;

    if not CDSPost(tmpCDS1, p_TableName) then
       Exit;

    Result:=True;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
  end;
end;

procedure TFrmDLIR120.qtyChange(Sender: TField);
begin
  CDS.FieldByName('nw').AsFloat:=RoundTo(TField(Sender).AsFloat*CDS.FieldByName('kg').AsFloat,-2);
  CDS.FieldByName('totsf').AsFloat:=RoundTo(TField(Sender).AsFloat*CDS.FieldByName('sf').AsFloat,-3);
  CDS.FieldByName('amt').AsFloat:=RoundTo(TField(Sender).AsFloat*CDS.FieldByName('price').AsFloat,-4);
  if Pos(CDS.FieldByName('units').AsString,'RL/ROL')>0 then
     CDS.FieldByName('totsf1').AsFloat:=RoundTo(CDS.FieldByName('longitude').AsFloat*CDS.FieldByName('latitude').AsFloat*TField(Sender).AsFloat*0.0254,-2)
  else
     CDS.FieldByName('totsf1').AsFloat:=RoundTo(CDS.FieldByName('longitude').AsFloat*CDS.FieldByName('latitude').AsFloat*TField(Sender).AsFloat*0.0254*0.0254,-2);
  if CDS.FieldByName('totsf1').AsFloat=0 then
     CDS.FieldByName('gsf').AsFloat:=0
  else
     CDS.FieldByName('gsf').AsFloat:=RoundTo(CDS.FieldByName('nw').AsFloat/CDS.FieldByName('totsf1').AsFloat*1000,-2);
end;

procedure TFrmDLIR120.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI019 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' And IsNull(Flag,0)=0 Order By Cname,Custno,Dno,kb,kw';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLIR120.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI019';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('雙擊可改變單筆或多筆選中狀態,右鍵刪除');
  if not g_MInfo^.R_rptDesign then
  begin
    DBGridEh1.FieldColumns['price'].Visible:=False;
    DBGridEh1.FieldColumns['amt'].Visible:=False;
  end;

  inherited;
  N_del3.Caption:=CheckLang('未選刪除');
  N_clr.Caption:=CheckLang('取消選中');
  N_edit1.Caption:=CheckLang('複製毛重');
  N_del1.Caption:=CheckLang('臨時刪除');
  N_del2.Caption:=CheckLang('徹底刪除');

  l_SelList:=TStringList.Create;
  g_CDS:=TClientDataSet.Create(nil);
  InitCDS(g_CDS, g_Xml);
end;

procedure TFrmDLIR120.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_SelList);
  FreeAndNil(g_CDS);
end;

procedure TFrmDLIR120.CDSBeforeEdit(DataSet: TDataSet);
begin
  if CDS.FieldByName('Flag').AsBoolean then
     Abort;

  inherited;
end;

procedure TFrmDLIR120.CDSBeforePost(DataSet: TDataSet);
var
  tmpDitem:Integer;
begin
  if DataSet.State in [dsInsert] then
  begin
    tmpDitem:=GetMaxDitem;
    if tmpDitem=0 then
       Abort;
    CDS.FieldByName('Ditem').AsInteger:=tmpDitem;
  end;

  inherited;
end;

procedure TFrmDLIR120.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  CDS.FieldByName('qty').OnChange:=qtyChange;
end;

procedure TFrmDLIR120.btn_dlir120AClick(Sender: TObject);
var
  str:string;
begin
  //inherited;
  if not Assigned(FrmDLIR120_Query) then
     FrmDLIR120_Query:=TFrmDLIR120_Query.Create(Application);
  if FrmDLIR120_Query.ShowModal=mrOK then
  begin
    l_rgpIndex:=FrmDLIR120_Query.Rgp1.ItemIndex;
    l_filter:=' and saledate>='+Quotedstr(DateToStr(FrmDLIR120_Query.Dtp1.Date))
             +' and saledate<='+Quotedstr(DateToStr(FrmDLIR120_Query.Dtp2.Date))
             +' and custno='+Quotedstr(FrmDLIR120_Query.Edit1.Text);
    if Length(Trim(FrmDLIR120_Query.Edit2.Text))>0 then
       l_filter:=l_filter+' and saleno='+Quotedstr(UpperCase(Trim(FrmDLIR120_Query.Edit2.Text)));
    str:=StringReplace(' and q_oga02>='+Quotedstr(FormatDateTime(g_cShortDate1,FrmDLIR120_Query.Dtp1.Date))
        +' and q_oga02<='+Quotedstr(FormatDateTime(g_cShortDate1,FrmDLIR120_Query.Dtp2.Date)),'-','/',[rfReplaceAll])
        +' and oga04='+Quotedstr(UpperCase(Trim(FrmDLIR120_Query.Edit1.Text)));
    if Length(Trim(FrmDLIR120_Query.Edit2.Text))>0 then
       str:=str+' and oga01='+Quotedstr(UpperCase(Trim(FrmDLIR120_Query.Edit2.Text)));
    if GetDS(str) then
    begin
      l_SelList.Clear;
      RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
      RefreshDS(l_filter);
    end;
  end;
end;

procedure TFrmDLIR120.btn_dlir120BClick(Sender: TObject);
var
  kw,kb:Integer;
  qty1,qty2,qty3,qty4,gw:Double;
  tmpDno,tmpSQL,tmpFilter:string;
  tmpDitem:Integer;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料,不可碓認!', 48);
    Exit;
  end;

  gw:=0;
  qty1:=0;
  qty2:=0;
  qty3:=0;
  qty4:=0;
  tmpDno:='';
  tmpDitem:=-1;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    with tmpCDS1 do
    begin
      Data:=CDS.Data;
      IndexFieldNames:='kw';
      First;
      while not Eof do
      begin
        if (FieldByName('kw').AsInteger<=0) or
           (FieldByName('kb').AsInteger<=0) or
           (FieldByName('gw').AsFloat<=0) or
           FieldByName('flag').AsBoolean then
        begin
          tmpDno:=FieldByName('dno').AsString;
          tmpDitem:=FieldByName('ditem').AsInteger;
          Break;
        end;

        if SameText(FieldByName('units').AsString, 'SH') then
           qty1:=qty1+FieldByName('qty').AsFloat
        else if SameText(FieldByName('units').AsString, 'RL') or
                SameText(FieldByName('units').AsString, 'ROL') then
           qty2:=qty2+FieldByName('qty').AsFloat
        else if SameText(FieldByName('units').AsString, 'PN') and
                (Pos(LeftStr(FieldByName('pno').AsString,1), 'ET')>0) then
           qty3:=qty3+FieldByName('qty').AsFloat
        else if SameText(FieldByName('units').AsString, 'PN') and
                (Pos(LeftStr(FieldByName('pno').AsString,1), 'MN')>0) then
           qty4:=qty4+FieldByName('qty').AsFloat;

        gw:=FieldByName('gw').AsFloat;
        kw:=FieldByName('kw').AsInteger;
        tmpFilter:=tmpFilter+','+Quotedstr(FieldByName('dno').AsString+'@'+FieldByName('ditem').AsString);

        Next;

        if (not Eof) and (kw=FieldByName('kw').AsInteger) and
           (gw<>FieldByName('gw').AsFloat) then
        begin
          tmpDno:=FieldByName('dno').AsString;
          tmpDitem:=FieldByName('ditem').AsInteger;
          gw:=-999999;
          Break;
        end;
      end;
    end;

    if Length(tmpDno)>0 then
    begin
      CDS.Locate('dno;ditem',VarArrayOf([tmpDno,tmpDitem]),[]);
      if gw=-999999 then
         ShowMsg('第'+IntToStr(CDS.RecNo)+'筆卡位相同,但毛重不同,請確認!',48)
      else
         ShowMsg('第'+IntToStr(CDS.RecNo)+'筆卡位、卡板、毛重未輸入或已確認!',48);
      Exit;
    end;

    //判斷卡位,卡板是否連續
    kw:=0;
    kb:=0;
    with tmpCDS1 do
    begin
      IndexFieldNames:='kw;kb';
      First;
      while not Eof do
      begin
        if (kw<>FieldByName('kw').AsInteger) and (kw+1<>FieldByName('kw').AsInteger) then
        begin
          CDS.Locate('dno;ditem',VarArrayOf([FieldByName('dno').AsString,FieldByName('ditem').AsInteger]),[]);
          ShowMsg('第'+IntToStr(CDS.RecNo)+'筆卡位不連續!',48);
          Exit;
        end;

        if (kb<>FieldByName('kb').AsInteger) and (kb+1<>FieldByName('kb').AsInteger) then
        begin
          CDS.Locate('dno;ditem',VarArrayOf([FieldByName('dno').AsString,FieldByName('ditem').AsInteger]),[]);
          ShowMsg('第'+IntToStr(CDS.RecNo)+'筆卡板不連續!',48);
          Exit;
        end;

        kw:=FieldByName('kw').AsInteger;
        kb:=FieldByName('kb').AsInteger;
        Next;
      end;
    end;

    //***判斷出貨單數量***
    tmpCDS1.IndexFieldNames:='';
    Delete(tmpFilter,1,1);
    Data:=null;
    tmpSQL:='Select Saleno,Saleitem,Sum(Qty) Qty From DLI019'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Dno+''@''+Cast(Ditem as varchar(10)) in ('+tmpFilter+')'
           +' Group By Saleno,Saleitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;

    tmpSQL:='';
    with tmpCDS1 do
    begin
      if IsEmpty then
      begin
        ShowMsg('無資料',48);
        Exit;
      end;
      while not Eof do
      begin
        tmpSQL:=tmpSQL+' or (ogb01='+Quotedstr(Fields[0].AsString)
                      +' And ogb03='+Fields[1].AsString+')';
        Next;
      end;
    end;

    Delete(tmpSQL,1,3);
    Data:=null;
    tmpSQL:='Select ogb01,ogb03,ogb12 From '+g_UInfo^.BU+'.ogb_file Where '+tmpSQL;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDS2.Data:=Data;
    with tmpCDS1 do
    begin
      First;
      while not Eof do
      begin
        if not tmpCDS2.Locate('ogb01;ogb03',VarArrayOf([Fields[0].AsString,Fields[1].AsInteger]),[]) then
        begin
          ShowMsg('%s不存在', 48, Fields[0].AsString+'/'+Fields[1].AsString);
          Exit;
        end;
        if Fields[2].AsFloat<>tmpCDS2.Fields[2].AsFloat then
        begin
          ShowMsg('%s',48,Fields[0].AsString+'/'+Fields[1].AsString+CheckLang('合計數量:')+FloatToStr(Fields[2].AsFloat)+CheckLang('<>出貨數量:')+FloatToStr(tmpCDS2.Fields[2].AsFloat));
          Self.CDS.Locate('Saleno;Saleitem',VarArrayOf([Fields[0].AsString,Fields[1].AsInteger]),[]);
          Exit;
        end;
        Next;
      end;
    end;
    //***判斷出貨單數量***

    if not Assigned(FrmDLIR120_Conf) then
       FrmDLIR120_Conf:=TFrmDLIR120_Conf.Create(Application);
    FrmDLIR120_Conf.Label1.Caption:='CCL:'+FloatToStr(qty1)+' SH   '+FloatToStr(qty3)+' PN';
    FrmDLIR120_Conf.Label2.Caption:='PP :'+FloatToStr(qty2)+' RL   '+FloatToStr(qty4)+' PN';
    FrmDLIR120_Conf.Edit4.Text:=CDS.FieldByName('Cname').AsString;
    if FrmDLIR120_Conf.ShowModal<>mrOK then
       Exit;

    tmpDno:=GetSno(g_MInfo^.ProcId);
    if Length(tmpDno)=0 then
       Exit;
    Data:=null;
    tmpSQL:='Select * From DLI018 Where 1<>1';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;
    with tmpCDS1 do
    begin
      Append;
      FieldByName('Bu').AsString:=g_UInfo^.BU;
      FieldByName('Cdate').AsDateTime:=Date;
      FieldByName('Dno').AsString:=tmpDno;
      FieldByName('Cname').AsString:=Trim(FrmDLIR120_Conf.Edit4.Text);
      FieldByName('Custno').AsString:=CDS.FieldByName('Custno').AsString;
      FieldByName('Custshort').AsString:=CDS.FieldByName('Custshort').AsString;
      FieldByName('Carno').AsString:=FrmDLIR120_Conf.Edit1.Text;
      FieldByName('Driver').AsString:=FrmDLIR120_Conf.Edit3.Text;
      FieldByName('Tel').AsString:=FrmDLIR120_Conf.Edit2.Text;
      FieldByName('CCLQty').AsFloat:=qty1;
      FieldByName('PPQty').AsFloat:=qty2;
      FieldByName('CCLPnlQty').AsFloat:=qty3;
      FieldByName('PPPnlQty').AsFloat:=qty4;
      FieldByName('Conf').AsString:='N';
      FieldByName('Iuser').AsString:=g_UInfo^.Wk_no;
      FieldByName('Idate').AsDateTime:=Now;
      Post;
    end;

    if not CDSPost(tmpCDS1, 'DLI018') then
       Exit;

    Data:=null;
    tmpSQL:=' declare @t table(fkw int,fnw float,fgw float)'
           +' update dli019 set cname='+Quotedstr(Trim(FrmDLIR120_Conf.Edit4.Text))
           +' ,flag=1,dno='+Quotedstr(tmpDno)
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and dno+''@''+cast(ditem as varchar(10)) in ('+tmpFilter+')'

           +' insert into @t select kw,isnull(sum(nw),0) nw,isnull(min(gw),0) gw'
           +' from dli019 where bu='+Quotedstr(g_UInfo^.BU)
           +' and dno='+Quotedstr(tmpDno)+' group by kw'

           +' update dli019 set totnw=fnw,tare=round(fgw-fnw,2)'
           +' from @t where bu='+Quotedstr(g_UInfo^.BU)
           +' and dno='+Quotedstr(tmpDno)+' and kw=fkw';
    if not PostBySQL(tmpSQL) then
    begin
      tmpSQL:='delete from dli018 where bu='+Quotedstr(g_UInfo^.BU)
             +' and cdate='+Quotedstr(DateToStr(Date))
             +' and dno='+Quotedstr(tmpDno);
      PostBySQL(tmpSQL);
      Exit;
    end;

    l_SelList.Clear;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    CDS.EmptyDataSet;
    ShowMsg('確認完畢,請在[已確認資料]中查看!',64);
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmDLIR120.btn_dlir120CClick(Sender: TObject);
begin
  inherited;
  FrmDLIR120_ConfDetail:=TFrmDLIR120_ConfDetail.Create(nil);
  try
    FrmDLIR120_ConfDetail.ShowModal;
  finally
    FreeAndNil(FrmDLIR120_ConfDetail);
  end;
end;

procedure TFrmDLIR120.btn_deleteClick(Sender: TObject);
var
  dsNE:TDataSetNotifyEvent;
begin
//  inherited;
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定刪除此筆資料嗎?', 33)=IDOK then
  begin
    dsNE:=CDS.AfterDelete;
    CDS.AfterDelete:=nil;
    try
      CDS.Delete;
      CDS.MergeChangeLog;
    finally
      CDS.AfterDelete:=dsNE;
    end;
    if CDS.IsEmpty then
    begin
      SetToolBar;
      SetSBars;
    end;
  end;
end;

procedure TFrmDLIR120.btn_printClick(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  tmpSQL:='Select *,isnull(cclpnlqty,0)+isnull(pppnlqty,0) as pnlqty From DLI018 Where 1=2';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;

    while not g_CDS.IsEmpty do
       g_CDS.Delete;
    if g_CDS.ChangeCount>0 then
       g_CDS.MergeChangeLog;

    tmpCDS2.Data:=CDS.Data;
    if not g_MInfo^.R_rptDesign then
    begin
      tmpCDS2.First;
      while not tmpCDS2.Eof do
      begin
        tmpCDS2.Edit;
        tmpCDS2.FieldByName('Price').Clear;
        tmpCDS2.FieldByName('Amt').Clear;
        tmpCDS2.Post;
        tmpCDS2.Next;
      end;
      if tmpCDS2.ChangeCount>0 then
         tmpCDS2.MergeChangeLog;
    end;
    tmpCDS2.RecNo:=CDS.RecNo;
    tmpCDS2.IndexFieldNames:=CDS.IndexFieldNames;

    SetLength(ArrPrintData, 3);
    ArrPrintData[0].Data:=tmpCDS1.Data;
    ArrPrintData[0].RecNo:=tmpCDS1.RecNo;
    ArrPrintData[0].IndexFieldNames:=tmpCDS1.IndexFieldNames;
    ArrPrintData[0].Filter:=tmpCDS1.Filter;

    ArrPrintData[1].Data:=tmpCDS2.Data;
    ArrPrintData[1].RecNo:=tmpCDS2.RecNo;
    ArrPrintData[1].IndexFieldNames:=tmpCDS2.IndexFieldNames;
    ArrPrintData[1].Filter:=tmpCDS2.Filter;

    ArrPrintData[2].Data:=g_CDS.Data;
    ArrPrintData[2].RecNo:=g_CDS.RecNo;
    ArrPrintData[2].IndexFieldNames:=g_CDS.IndexFieldNames;
    ArrPrintData[2].Filter:=g_CDS.Filter;
    GetPrintObj(p_SysId, ArrPrintData);
    ArrPrintData:=nil;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmDLIR120.btn_exportClick(Sender: TObject);
var
  tmpCDS:TClientDataSet;
begin
  //inherited;
  if g_MInfo^.R_rptDesign then
  begin
    GetExportXls(CDS, p_TableName);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpCDS.Edit;
      tmpCDS.FieldByName('Price').Clear;
      tmpCDS.FieldByName('Amt').Clear;
      tmpCDS.Post;
      tmpCDS.Next;
    end;
    if tmpCDS.ChangeCount>0 then
       tmpCDS.MergeChangeLog;
    tmpCDS.RecNo:=CDS.RecNo;
    GetExportXls(tmpCDS, p_TableName);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLIR120.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  with DBGridEh1 do
  begin
    if Tag=0 then
    begin
      Tag:=1;
      Options:=Options+[dgRowSelect,dgMultiSelect];
    end else
    begin
      Tag:=0;
      Options:=Options-[dgRowSelect,dgMultiSelect]+[dgEditing];
      ReadOnly:=False;
    end;
  end;
end;

procedure TFrmDLIR120.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N_del1.Visible:=CDS.Active and (not CDS.IsEmpty) and g_MInfo^.R_delete;
  N_del2.Visible:=N_del1.Visible;
  N_del3.Visible:=N_del1.Visible and (l_SelList.Count>0);
  N_edit1.Visible:=CDS.Active and (not CDS.IsEmpty) and g_MInfo^.R_edit;
  N_clr.Visible:=l_SelList.Count>0;
end;

procedure TFrmDLIR120.N_del1Click(Sender: TObject);
var
  dsNE:TDataSetNotifyEvent;
begin
  inherited;
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定要刪除所選中的資料嗎?', 33)=IDOK then
  begin
    dsNE:=CDS.AfterDelete;
    CDS.AfterDelete:=nil;
    try
      if DBGridEh1.SelectedRows.Count>1 then
         DBGridEh1.SelectedRows.Delete
      else
         CDS.Delete;
      CDS.MergeChangeLog;
    finally
      CDS.AfterDelete:=dsNE;
    end;
    if CDS.IsEmpty then
    begin
      SetToolBar;
      SetSBars;
    end;
  end;
end;

procedure TFrmDLIR120.N_del2Click(Sender: TObject);
begin
  inherited;
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else if ShowMsg('確定要刪除所選中的資料嗎?', 33)=IDOK then
  begin
    if DBGridEh1.SelectedRows.Count>1 then
       DBGridEh1.SelectedRows.Delete
    else
       CDS.Delete;
  end;
end;

procedure TFrmDLIR120.N_edit1Click(Sender: TObject);
var
  kw:Integer;
  gw:Double;
  tmpStr:string;
  dsNE1,dsNE2,dsNE3,dsNE4,dsNE5:TDataSetNotifyEvent;
begin
  inherited;
  tmpStr:=DBGridEh1.FieldColumns['gw'].Title.Caption;
  if (Pos(g_Asc, tmpStr)>0) or (Pos(g_Desc, tmpStr)>0) then
  begin
    ShowMsg('請取消[毛重]欄位排序標記,再執行此操作!',48);
    Exit;
  end;

  kw:=CDS.FieldByName('kw').AsInteger;
  gw:=CDS.FieldByName('gw').AsFloat;

  if kw<=0 then
  begin
    ShowMsg('請輸入卡位!',48);
    Exit;
  end;
  if gw<=0 then
  begin
    ShowMsg('請輸入毛重!',48);
    Exit;
  end;

  if ShowMsg('確定把所有卡位['+IntToStr(kw)+']的毛重更改為['+FloatToStr(gw)+']嗎?',33)=IdCancel then
     Exit;
  dsNE1:=CDS.BeforeEdit;
  dsNE2:=CDS.AfterEdit;
  dsNE3:=CDS.BeforePost;
  dsNE4:=CDS.AfterPost;
  dsNE5:=CDS.AfterScroll;
  CDS.BeforeEdit:=nil;
  CDS.AfterEdit:=nil;
  CDS.BeforePost:=nil;
  CDS.AfterPost:=nil;
  CDS.AfterScroll:=nil;
  CDS.DisableControls;
  try
     CDS.First;
     while not CDS.Eof do
     begin
       if CDS.FieldByName('kw').AsInteger>0 then
       if (kw=CDS.FieldByName('kw').AsInteger) and (gw<>CDS.FieldByName('gw').AsFloat) then
       begin
         CDS.Edit;
         CDS.FieldByName('gw').AsFloat:=gw;
         CDS.Post;
       end;
       CDS.Next;
     end;

     if CDS.ChangeCount>0 then
     if not CDSPost(CDS, p_TableName) then
        CDS.CancelUpdates;
  finally
    CDS.BeforeEdit:=dsNE1;
    CDS.AfterEdit:=dsNE2;
    CDS.BeforePost:=dsNE3;
    CDS.AfterPost:=dsNE4;
    CDS.AfterScroll:=dsNE5;
    CDS.EnableControls;
  end;
end;

procedure TFrmDLIR120.N_del3Click(Sender: TObject);
var
  dsNE1,dsNE2,dsNE3:TDataSetNotifyEvent;
begin
  inherited;
  if l_SelList.Count=0 then
  begin
    ShowMsg('未選中任何資料!',48);
    Exit;
  end;

  if ShowMsg('確定刪除未選中的資料嗎?',33)=IdCancel then
     Exit;

  dsNE1:=CDS.BeforeDelete;
  dsNE2:=CDS.AfterDelete;
  dsNE3:=CDS.AfterScroll;
  CDS.BeforeDelete:=nil;
  CDS.AfterDelete:=nil;
  CDS.AfterScroll:=nil;
  CDS.DisableControls;
  try
    CDS.First;
    while not CDS.Eof do
    begin
      if l_SelList.IndexOf(CDS.FieldByName('dno').AsString+'@'+CDS.FieldByName('ditem').AsString)=-1 then
         CDS.Delete
      else
         CDS.Next;
    end;
    if CDS.ChangeCount>0 then
       CDS.MergeChangeLog;
  finally
    l_SelList.Clear;
    CDS.BeforeDelete:=dsNE1;
    CDS.AfterDelete:=dsNE2;
    CDS.AfterScroll:=dsNE3;
    CDS.EnableControls;
  end;
end;

procedure TFrmDLIR120.N_clrClick(Sender: TObject);
begin
  inherited;
  l_SelList.Clear;
  DBGridEh1.Repaint;
end;

procedure TFrmDLIR120.m_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    l_SelList.Clear;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLIR120.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLIR120.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_delete) then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    tmpStr:=CDS.FieldByName('dno').AsString+'@'+
            CDS.FieldByName('ditem').AsString;
    if l_SelList.IndexOf(tmpStr) =-1 then
       l_SelList.Add(tmpStr)
    else
       l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmDLIR120.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr:string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr:=CDS.FieldByName('dno').AsString+'@'+
            CDS.FieldByName('ditem').AsString;
    if l_SelList.IndexOf(tmpStr)<>-1 then
       DBGridEh1.Canvas.TextOut(Round((Rect.Left+Rect.Right)/2)-6,
       Round((Rect.Top+Rect.Bottom)/2-6), 'V');
  end;
end;

procedure TFrmDLIR120.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Dno').AsString:='A';
end;

procedure TFrmDLIR120.btn_copyClick(Sender: TObject);
begin
  CDS.FieldByName('qty').OnChange:=nil;
  try
    inherited;
  finally
    CDS.FieldByName('qty').OnChange:=qtyChange;
  end;
end;

end.
