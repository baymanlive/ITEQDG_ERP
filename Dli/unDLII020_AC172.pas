unit unDLII020_AC172;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB,
  DBClient, GridsEh, DBAxisGridsEh, DBGridEh, DateUtils, StrUtils, TWODbarcode;

type
  TFrmDLII020_AC172 = class(TFrmSTDI051)
    Panel1: TPanel;
    DBGridEh2: TDBGridEh;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    DBGridEh1: TDBGridEh;
    btn_query: TBitBtn;
    CDS1: TClientDataSet;
    DS1: TDataSource;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    CheckBox1: TCheckBox;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    Label2: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    l_sql2:string;
    l_list2:TStrings;
    Fm_image:PTIMAGESTRUCT;
    l_CDS:TClientDataSet;
    procedure RefreshDS1(strFilter: string);
    procedure RefreshDS2;
    function GetLotSN(xBoxsn:string; xData:OleVariant):string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_AC172: TFrmDLII020_AC172;

implementation

uses unGlobal, unCommon, unDLII020_const, unAC172Service;

const l_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="checkbox" fieldtype="boolean"/>'
            +'<FIELD attrname="dno" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="ditem" fieldtype="i4"/>'
            +'<FIELD attrname="sno" fieldtype="i4"/>'
            +'<FIELD attrname="manfac1" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="qty" fieldtype="r8"/>'
            +'<FIELD attrname="sflagx" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="jflagx" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="jremark" fieldtype="string" WIDTH="80"/>'
            +'<FIELD attrname="lotsn" fieldtype="string" WIDTH="15"/>'
            +'<FIELD attrname="boxsn" fieldtype="string" WIDTH="15"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const l_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="lotsn1" fieldtype="string" WIDTH="15"/>'
            +'<FIELD attrname="lotsn2" fieldtype="string" WIDTH="15"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLII020_AC172.RefreshDS1(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select * from dli010 where bu='+Quotedstr(g_UInfo^.Bu)
         +' and custno=''AC172'' '+strFilter
         +' order by saleitem';
  if QueryBySQL(tmpSQL, Data) then
     CDS1.Data:=Data;

  if CDS1.Active and CDS1.IsEmpty then
     RefreshDS2;
end;

procedure TFrmDLII020_AC172.RefreshDS2;
var
  tmpSQL:string;
begin
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    CDS2.EmptyDataSet;
    Exit;
  end;
  
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='select *,case sflag when 0 then ''檢貨'' when 1 then ''並包確認'' end sflagx,'
         +' case jflag when 1 then ''並包當中'' when 2 then ''並包完成'' end jflagx'
         +' from dli020'
         +' where dno='+Quotedstr(CDS1.FieldByName('dno').AsString)
         +' and ditem='+IntToStr(CDS1.FieldByName('ditem').AsInteger)
         +' and bu='+Quotedstr(g_UInfo^.BU)
         +' order by sno';
  l_list2.Insert(0,tmpSQL);
end;

//取出同一外箱SN中所有小包SN
function TFrmDLII020_AC172.GetLotSN(xBoxsn:string; xData:OleVariant):string;
var
  s1,s2,s3,s4:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  Result:='';

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    InitCDS(tmpCDS1, l_Xml2);
    with tmpCDS2 do
    begin
      Data:=xData;
      Filtered:=False;
      Filter:='boxsn='+Quotedstr(xBoxsn);
      Filtered:=True;
      IndexFieldNames:='lotsn';
      while not Eof do
      begin
        if tmpCDS1.IsEmpty then
        begin
          tmpCDS1.Append;
          tmpCDS1.FieldByName('lotsn1').AsString:=FieldByName('lotsn').AsString;
          tmpCDS1.Post;
        end else
        begin
          if Length(tmpCDS1.FieldByName('lotsn2').AsString)=0 then
          begin
            s1:=LeftStr(tmpCDS1.FieldByName('lotsn1').AsString,8);
            s2:=RightStr(tmpCDS1.FieldByName('lotsn1').AsString,7);
          end else
          begin
            s1:=LeftStr(tmpCDS1.FieldByName('lotsn2').AsString,8);
            s2:=RightStr(tmpCDS1.FieldByName('lotsn2').AsString,7);
          end;

          s3:=LeftStr(FieldByName('lotsn').AsString,8);
          s4:=RightStr(FieldByName('lotsn').AsString,7);
          if (s1=s3) and (StrToInt(s2)+1=StrToInt(s4)) then  //連續
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('lotsn2').AsString:=FieldByName('lotsn').AsString;
            tmpCDS1.Post;
          end else                                           //不連續
          begin
            tmpCDS1.Append;
            tmpCDS1.FieldByName('lotsn1').AsString:=FieldByName('lotsn').AsString;
            tmpCDS1.Post;
          end;
        end;

        Next;
      end;
    end;

    with tmpCDS1 do
    begin
      MergeChangeLog;
      First;
      while not Eof do
      begin
        Result:=Result+';'+FieldByName('lotsn1').AsString;
        if Length(FieldByName('lotsn2').AsString)>0 then
           Result:=Result+'-'+FieldByName('lotsn2').AsString;
        Next;
      end;
    end;

    if Length(Result)>0 then
       Delete(Result,1,1);
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmDLII020_AC172.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('出貨單號:');
  Label2.Caption:=CheckLang('PP：若生產日期相同,請一起選擇產生一個外箱SN    CCL：按實際包裝選擇產生外箱SN');
  CheckBox1.Caption:=CheckLang('全選');
  SetGrdCaption(DBGridEh1, 'dli010');
  SetGrdCaption(DBGridEh2, 'dli020');
  DBGridEh2.FieldColumns['checkbox'].Title.Caption:=CheckLang('選中');
  DBGridEh2.FieldColumns['checkbox'].Width:=40;
  l_CDS:=TClientDataSet.Create(nil);
  InitCDS(l_CDS, g_QRCodeXml);
  InitCDS(CDS2, l_Xml1);
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
  PtInitImage(@Fm_image);
end;

procedure TFrmDLII020_AC172.FormShow(Sender: TObject);
begin
  inherited;
  if Length(Trim(Edit1.Text))>0 then
     RefreshDS1('and saleno='+Quotedstr(Edit1.Text))
  else
     RefreshDS1(g_cFilterNothing)
end;

procedure TFrmDLII020_AC172.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  FreeAndNil(l_CDS);
  PtFreeImage(@Fm_image);
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmDLII020_AC172.CDS1AfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS2;
end;

procedure TFrmDLII020_AC172.btn_queryClick(Sender: TObject);
begin
  inherited;
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(Label1.Caption));
    Exit;
  end;

  RefreshDS1('and saleno='+Quotedstr(Edit1.Text));
end;

procedure TFrmDLII020_AC172.BitBtn1Click(Sender: TObject);
var
  sn:Integer;
  isCheck:Boolean;
  tmpSQL,code,boxsn:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if CDS2.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  isCheck:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS2.Data;
    while not tmpCDS.Eof do
    begin
      if tmpCDS.FieldByName('checkbox').AsBoolean then
      begin
        if not isCheck then
           isCheck:=True;

        if Length(tmpCDS.FieldByName('lotsn').AsString)<>15 then
        begin
          ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆小包SN不存在,請重新選擇!',48);
          Exit;
        end;

        if Length(tmpCDS.FieldByName('boxsn').AsString)=15 then
        begin
          ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆已產生外箱SN,請重新選擇!',48);
          Exit;
        end;
      end;

      tmpCDS.Next;
    end;

    if not isCheck then
    begin
      ShowMsg('請選擇批號資料!',48);
      Exit;
    end;

    code:=Copy(tmpCDS.FieldByName('lotsn').AsString,2,4);

    if ShowMsg('確定對選中的資料產生外箱標簽SN嗎?',33)=IdCancel then
       Exit;

    tmpSQL:='select * from mps080 where Bu=''ITEQDG'' and kind=''AC172KB'''
           +' and wdate='+Quotedstr(DateToStr(EncodeDate(YearOf(Date),1,1)));
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       sn:=1
    else
       sn:=tmpCDS.FieldByName('sno').AsInteger+1;

    boxsn:='B'+code+RightStr(IntToStr(YearOf(Date)),2)+'S'+RightStr('000000'+IntToStr(sn),7);
    CDS2.First;
    while not CDS2.Eof do
    begin
      if CDS2.FieldByName('checkbox').AsBoolean then
      begin
        CDS2.Edit;
        CDS2.FieldByName('boxsn').AsString:=boxsn;
        CDS2.FieldByName('checkbox').AsBoolean:=False;
        CDS2.Post;

        tmpSQL:='update dli020 set boxsn='+Quotedstr(boxsn)
               +' where bu='+Quotedstr(g_UInfo^.BU)
               +' and dno='+Quotedstr(CDS2.FieldByName('dno').AsString)
               +' and ditem='+IntToStr(CDS2.FieldByName('ditem').AsInteger)
               +' and sno='+IntToStr(CDS2.FieldByName('sno').AsInteger);
        if not PostBySQL(tmpSQL) then
        begin
          RefreshDS2;
          Exit;
        end;
      end;

      CDS2.Next;
    end;
    CDS2.MergeChangeLog;

    if tmpCDS.IsEmpty then
    begin
      tmpCDS.Append;
      tmpCDS.FieldByName('Bu').AsString:='ITEQDG';
      tmpCDS.FieldByName('Kind').AsString:='AC172KB';
      tmpCDS.FieldByName('Wdate').AsDateTime:=EncodeDate(YearOf(Date),1,1);
      tmpCDS.FieldByName('Sno').AsInteger:=sn;
      tmpCDS.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      tmpCDS.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS.Post;
    end else
    begin
      tmpCDS.Edit;
      tmpCDS.FieldByName('Sno').AsInteger:=sn;
      tmpCDS.FieldByName('Muser').AsString:=g_UInfo^.UserId;
      tmpCDS.FieldByName('Mdate').AsDateTime:=Now;
      tmpCDS.Post;
    end;

    if not CDSPost(tmpCDS, 'MPS080') then
    begin
      ShowMsg('產生完畢,但儲存最后SN失敗,下次可能會重複,請刪除重新產生!',48);
      Exit;
    end;
    ShowMsg('產生完畢!',64);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII020_AC172.BitBtn2Click(Sender: TObject);
var
  tmpSQL,tmpImgPath,tmpBoxsn,tmpOraDB:string;
  tmpDate:TDateTime;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  Data:OleVariant;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  if CDS1.IsEmpty or CDS2.IsEmpty then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  g_StatusBar.Panels[0].Text:='正在查詢資料...';
  Application.ProcessMessages;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select a.pno,b.manfac1,dbo.Get_PPMRL(a.pno,b.qty) qty,lotsn,boxsn'
           +' from dli010 a inner join dli020 b'
           +' on a.bu=b.bu and a.dno=b.dno and a.ditem=b.ditem'
           +' where a.bu='+quotedstr(g_uinfo^.bu)
           +' and a.saleno='+Quotedstr(CDS1.FieldByName('saleno').AsString)
           +' and a.saleitem='+IntToStr(CDS1.FieldByName('saleitem').AsInteger)
           +' and isnull(b.jflag,0)=0'
           +' order by b.boxsn,b.lotsn,b.sno';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('無批號資料!',48);
      Exit;
    end;

    while not tmpCDS1.Eof do
    begin
      if Length(tmpCDS1.FieldByName('lotsn').AsString)<>15 then
      begin
        ShowMsg(tmpCDS1.FieldByName('manfac1').AsString+'小包SN不存在!',48);
        Exit;
      end;

      if Length(tmpCDS1.FieldByName('boxsn').AsString)<>15 then
      begin
        ShowMsg(tmpCDS1.FieldByName('manfac1').AsString+'外箱SN不存在!',48);
        Exit;
      end;

      tmpCDS1.Next;
    end;

    if Pos('dg', LowerCase(g_UInfo^.BU))>0 then
       tmpOraDB:='ORACLE'
    else
       tmpOraDB:='ORACLE1';

    Data:=null;
    tmpSQL:=' select ogb01,oea10,oeb11,ta_oeb10 from'
           +' (select ogb01,ogb31,ogb32,oeb11,ta_oeb10'
           +' from ogb_file inner join oeb_file on ogb31=oeb01 and ogb32=oeb03'
           +' where ogb01='+Quotedstr(CDS1.FieldByName('saleno').AsString)
           +' and ogb03='+IntToStr(CDS1.FieldByName('saleitem').AsInteger)
           +' ) A inner join oea_file on ogb31=oea01 where oea04=''AC172''';
    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
       Exit;

    tmpCDS2.Data:=Data;
    if tmpCDS2.IsEmpty then
    begin
      ShowMsg(CDS1.FieldByName('saleno').AsString+'不存在,或者不是欣強單據!',48);
      Exit;
    end;

    tmpBoxsn:='@@@';
    l_CDS.EmptyDataSet;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      if tmpCDS1.FieldByName('boxsn').AsString<>tmpBoxsn then
      begin
        l_CDS.Append;
        l_CDS.FieldByName('Saleno').AsString:=tmpCDS2.FieldByName('ogb01').AsString;
        l_CDS.FieldByName('C_Orderno').AsString:=tmpCDS2.FieldByName('oea10').AsString;
        l_CDS.FieldByName('C_Pno').AsString:=tmpCDS2.FieldByName('oeb11').AsString;
        l_CDS.FieldByName('C_Sizes').AsString:=tmpCDS2.FieldByName('ta_oeb10').AsString;
        l_CDS.FieldByName('KB').AsString:=tmpCDS1.FieldByName('boxsn').AsString;                       //外箱sn
        l_CDS.FieldByName('SPEC').AsString:=GetLotSN(l_CDS.FieldByName('KB').AsString, tmpCDS1.Data);  //小包sn
        if Length(l_CDS.FieldByName('SPEC').AsString)=0 then
        begin
          l_CDS.Cancel;
          ShowMsg(l_CDS.FieldByName('KB').AsString+',小包SN獲取失敗,請重試!',48);
          Exit;
        end;
      end else
         l_CDS.Edit;
      l_CDS.FieldByName('Qty').AsFloat:=l_CDS.FieldByName('Qty').AsFloat+tmpCDS1.FieldByName('Qty').AsFloat;

      //只要最大批號
      if l_CDS.FieldByName('Lot').AsString<tmpCDS1.FieldByName('manfac1').AsString then
      begin
        tmpDate:=GetLotDate(Copy(tmpCDS1.FieldByName('manfac1').AsString,2,4), Date);
        if tmpDate<EncodeDate(2014,1,1) then
           Exit;

        l_CDS.FieldByName('Lot').AsString:=tmpCDS1.FieldByName('manfac1').AsString;
        l_CDS.FieldByName('PrdDate1').AsString:=FormatDateTime('YYYYMMDD', tmpDate);
        l_CDS.FieldByName('PrdDate2').AsString:=StringReplace(FormatDateTime('YYYY-MM-DD', tmpDate),'/','-',[rfReplaceAll]);
        if Pos(LeftStr(tmpCDS1.FieldByName('Pno').AsString,1),'ET')=0 then
           l_CDS.FieldByName('LstDate2').AsString:=FormatDateTime('YYYY-MM-DD', tmpDate+90)
        else
           l_CDS.FieldByName('LstDate2').AsString:=FormatDateTime('YYYY-MM-DD', IncYear(tmpDate,2)-1);
        l_CDS.FieldByName('LstDate2').AsString:=StringReplace(l_CDS.FieldByName('LstDate2').AsString,'/','-',[rfReplaceAll]);
        l_CDS.FieldByName('LstDate1').AsString:=StringReplace(l_CDS.FieldByName('LstDate2').AsString,'-','',[rfReplaceAll]);
      end;

      l_CDS.Post;
      tmpBoxsn:=tmpCDS1.FieldByName('boxsn').AsString;
      tmpCDS1.Next;
    end;

    with l_CDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        tmpImgPath:=g_UInfo^.TempPath+l_CDS.FieldByName('Saleno').AsString+'@'+IntToStr(RecNo)+'.bmp';
        if getcode(FieldByName('KB').AsString, tmpImgPath, Fm_image) then
           FieldByName('QRcode').AsString:=tmpImgPath;
        Post;
        Next;
      end;
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
    Application.ProcessMessages;
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
  end;

  l_CDS.MergeChangeLog;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData, 'DLII020_AC172');
  ArrPrintData:=nil;
end;

procedure TFrmDLII020_AC172.BitBtn3Click(Sender: TObject);
var
  Soap:AC172ServiceSoap;
  ret:String;
begin
  inherited;
  if CDS1.IsEmpty then
  begin
    ShowMsg('請選擇一筆資料進行上傳!',48);
    Exit;
  end;

  Soap:=unAC172Service.GetAC172ServiceSoap;
  ret:=Soap.AC172(g_UInfo^.BU, CDS1.FieldByName('saleno').AsString, CDS1.FieldByName('saleitem').AsInteger);
  if Pos('成功', ret)>0 then
     ShowMsg(ret, 64)
  else
     ShowMsg(ret, 48);

  //我的電腦->屬性->高級->性能->設置->數據執行保護->選擇打開DEP那一項,把程式添加進去   
end;

procedure TFrmDLII020_AC172.BitBtn4Click(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS2.Data;
    with tmpCDS do
    while not Eof do
    begin
      if FieldByName('checkbox').AsBoolean then
         tmpSQL:=tmpSQL+','+FieldByName('sno').AsString;
      Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  if Length(tmpSQL)=0 then
  begin
    ShowMsg('請選中要刪除的外箱SN',48);
    Exit;
  end;

  if ShowMsg('確定刪除選中的外箱SN嗎?',33)=IdCancel then
     Exit;

  Delete(tmpSQL,1,1);
  tmpSQL:='update dli020 set boxsn=null'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and dno='+Quotedstr(CDS1.FieldByName('dno').AsString)
         +' and ditem='+IntToStr(CDS1.FieldByName('ditem').AsInteger)
         +' and sno in ('+tmpSQL+')';
  if PostBySQL(tmpSQL) then
     RefreshDS2;
end;

procedure TFrmDLII020_AC172.CheckBox1Click(Sender: TObject);
begin
  inherited;
  with CDS2 do
  begin
    if IsEmpty then
       Exit;
       
    DisableControls;
    First;
    while not Eof do
    begin
      Edit;
      FieldByName('checkbox').AsBoolean:=CheckBox1.Checked;
      Post;
      Next;
    end;
    EnableControls;
    MergeChangeLog;
  end;
end;

procedure TFrmDLII020_AC172.DBGridEh2CellClick(Column: TColumnEh);
begin
  inherited;
  if SameText(Column.FieldName,'checkbox') then
  begin
    CDS2.Edit;
    CDS2.FieldByName('checkbox').AsBoolean:=not CDS2.FieldByName('checkbox').AsBoolean;
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;
end;

procedure TFrmDLII020_AC172.Timer1Timer(Sender: TObject);
var
  i:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
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
    begin
      tmpCDS1:=TClientDataSet.Create(nil);
      tmpCDS2:=TClientDataSet.Create(nil);
      try
        tmpCDS1.Data:=Data;
        if tmpCDS1.IsEmpty then
        begin
          CDS2.EmptyDataSet;
          Exit;
        end;

        tmpCDS2.Data:=CDS2.Data;
        tmpCDS2.EmptyDataSet;

        while not tmpCDS1.Eof do
        begin
          tmpCDS2.Append;
          for i:=1 to tmpCDS2.FieldCount-1 do
            tmpCDS2.Fields[i].Value:=tmpCDS1.FieldByName(tmpCDS2.Fields[i].FieldName).Value;
          tmpCDS2.FieldByName('checkbox').AsBoolean:=False;
          tmpCDS2.Post;

          tmpCDS1.Next;
        end;

        tmpCDS2.MergeChangeLog;
        CDS2.Data:=tmpCDS2.Data;
      finally
        FreeAndNil(tmpCDS1);
        FreeAndNil(tmpCDS2);
      end;
    end;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
