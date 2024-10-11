unit unMPST040_gz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient, ComCtrls, DateUtils;

type
  TFrmMPST040_gz = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    PCL: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    DBGridEh2: TDBGridEh;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Btn1: TBitBtn;
    Btn2: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure btn_okClick(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
    procedure CDS1BeforeInsert(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh2GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
    l_StimeCDS:TClientDataSet;
    function GetStime(Custno: string): TDateTime;
    procedure GetDS;
  public
    { Public declarations }
  end;

var
  FrmMPST040_gz: TFrmMPST040_gz;

implementation

uses unGlobal, unCommon, unMPST040_units, unMPST040;

{$R *.dfm}

function TFrmMPST040_gz.GetStime(Custno: string): TDateTime;
var
  Data:OleVariant;
  tmpSQL:string;
begin
  Result:=EncodeDateTime(1955,5,5,0,0,0,0);
  if not l_StimeCDS.Active then
  begin
    tmpSQL:='Select Custno,Stime From MPS290 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    l_StimeCDS.Data:=Data;
  end;

  with l_StimeCDS do
  begin
    First;
    while not Eof do
    begin
      if Pos(Custno, Fields[0].AsString)>0 then
      begin
        if not Fields[1].IsNull then
           Result:=EncodeDateTime(1955,5,5,HourOf(Fields[1].AsDateTime),
                                           MinuteOf(Fields[1].AsDateTime),0,0);
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TFrmMPST040_gz.GetDS;
var
  tmpSQL:string;
  Data1,Data2,Data3:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
begin
  //CCL排程
  tmpSQL:='select case_ans1 as ''select'',machine,sdate,currentboiler,wono,orderno,orderitem,'
         +' materialno,materialno1,pnlsize1,pnlsize2,orderqty,sqty,sqty as qty,'
         +' adate_new,edate,custno,custom,stealno,premark,orderno2,orderitem2'
         +' from mps010 where bu=''ITEQDG'' and machine=''L6'' and sdate>getdate()-4'
         +' and sqty>0 and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0'
         +' and len(isnull(orderno2,''''))>0 and isnull(orderitem2,0)<>0'
         +' order by machine,jitem,oz,materialno,simuver,citem';
  if not QueryBySQL(tmpSQL, Data1) then
     Exit;

  //PP排程
  tmpSQL:='select case_ans1 as ''select'',machine,sdate,wono,orderno,orderitem,'
         +' materialno,materialno1,pnlsize1,pnlsize2,breadth,fiber,orderqty,sqty,sqty as qty,'
         +' adate_new,edate,custno,custom,premark,orderno2,orderitem2'
         +' from mps070 where bu=''ITEQDG'' and machine in (''T6'',''T7'',''T8'')'
         +' and sdate>getdate()-4 and sqty>0'
         +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0'
         +' and len(isnull(orderno2,''''))>0 and isnull(orderitem2,0)<>0'
         +' order by machine,sdate,jitem,ad,fisno,rc desc,fiber,simuver,citem';
  if not QueryBySQL(tmpSQL, Data2) then
     Exit;

  //7天中2角訂單出貨表
  tmpSQL:='select orderno,orderitem from dli010'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and indate>='+Quotedstr(DateToStr(Date-7))
         +' and left(orderno,2) in (''P1'',''P2'')'
         +' and isnull(garbageflag,0)=0'
         +' And isnull(qtycolor,0)<>'+IntToStr(g_CocData);
  if not QueryBySQL(tmpSQL, Data3) then
     Exit;

  tmpSQL:='';
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data1;
    tmpCDS2.Data:=Data2;
    tmpCDS3.Data:=Data3;
    with tmpCDS1 do
    begin
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=False;
        FieldByName('qty').Clear;
        if tmpCDS3.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno2').AsString,FieldByName('orderitem2').AsInteger]),[]) then
           FieldByName('select').AsBoolean:=True;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='select=1';
      Filtered:=True;
      First;
      while not IsEmpty do
        Delete;
      Filtered:=False;
    end;

    with tmpCDS2 do
    begin
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=False;
        FieldByName('qty').Clear;
        if tmpCDS3.Locate('orderno;orderitem',VarArrayOf([FieldByName('orderno2').AsString,FieldByName('orderitem2').AsInteger]),[]) then
           FieldByName('select').AsBoolean:=True;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='select=1';
      Filtered:=True;
      First;
      while not IsEmpty do
        Delete;
      Filtered:=False;
    end;

    if tmpCDS1.ChangeCount>0 then
       tmpCDS1.MergeChangeLog;
    if tmpCDS2.ChangeCount>0 then
       tmpCDS2.MergeChangeLog;
    CDS1.Data:=tmpCDS1.Data;
    CDS2.Data:=tmpCDS2.Data;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
  end;
end;

procedure TFrmMPST040_gz.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'MPS010');
  SetGrdCaption(DBGridEh2, 'MPS070');
  DBGridEh1.FieldColumns['qty'].Width:=DBGridEh1.FieldColumns['sqty'].Width;
  DBGridEh1.FieldColumns['qty'].Title.Caption:=CheckLang('出貨數量');
  DBGridEh2.FieldColumns['qty'].Width:=DBGridEh2.FieldColumns['sqty'].Width;
  DBGridEh2.FieldColumns['qty'].Title.Caption:=DBGridEh1.FieldColumns['qty'].Title.Caption;
  TabSheet1.Caption:=CheckLang('CCL排程');
  TabSheet2.Caption:=CheckLang('PP排程');
  TabSheet3.Caption:=CheckLang('提示信息');
  l_StimeCDS:=TClientDataSet.Create(Self);
  GetDS;
end;

procedure TFrmMPST040_gz.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
  FreeAndNil(l_StimeCDS);
end;

procedure TFrmMPST040_gz.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if CDS1.Active and (not CDS1.IsEmpty) and SameText(Column.FieldName,'select') then
  begin
    CDS1.Edit;
    CDS1.FieldByName('select').AsBoolean:=not CDS1.FieldByName('select').AsBoolean;
    CDS1.Post;
    CDS1.MergeChangeLog;
  end;
end;

procedure TFrmMPST040_gz.DBGridEh2CellClick(Column: TColumnEh);
begin
  inherited;
  if CDS2.Active and (not CDS2.IsEmpty) and SameText(Column.FieldName,'select') then
  begin
    CDS2.Edit;
    CDS2.FieldByName('select').AsBoolean:=not CDS2.FieldByName('select').AsBoolean;
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;
end;

procedure TFrmMPST040_gz.btn_okClick(Sender: TObject);
var
  D:TDateTime;
  IsLock:Boolean;
  i,j,tmpDitem,tmpSno:Integer;
  tmpQty:Double;
  tmpSQL,tmpOrderno,tmpStr,tmpDno,tmpMsg:string;
  Data:OleVariant;
  tmpCDS,tmpCDS010,tmpCDSOra:TClientDataSet;
  tmpList:TStrings;
begin
//  inherited;
  if CDS1.State in [dsInsert,dsEdit] then
  begin
    CDS1.Post;
    CDS1.MergeChangeLog;
  end;
  if CDS2.State in [dsInsert,dsEdit] then
  begin
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;
  DBGridEh1.Enabled:=False;
  DBGridEh2.Enabled:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpCDS010:=TClientDataSet.Create(nil);
  tmpCDSOra:=TClientDataSet.Create(nil);
  tmpList:=TStringList.Create;
  try
    tmpCDS.Filtered:=False;
    tmpCDS.Data:=CDS1.Data;
    with tmpCDS do
    begin
      Filter:='select=1';
      Filtered:=True;
      First;
      while not Eof do
      begin
        if FieldByName('qty').AsFloat<=0 then
        begin
          CDS1.Locate('Orderno2;Orderitem2',VarArrayOf([FieldByName('Orderno2').AsString,FieldByName('Orderitem2').AsInteger]),[]);
          ShowMsg('['+FieldByName('Orderno2').AsString+'/'+FieldByName('Orderitem2').AsString+']請輸入出貨數量!',48);
          Exit;
        end;
        tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('Orderno2').AsString);
        Next;
      end;
    end;

    tmpCDS.Filtered:=False;
    tmpCDS.Data:=CDS2.Data;
    with tmpCDS do
    begin
      Filter:='select=1';
      Filtered:=True;
      First;
      while not Eof do
      begin
        if FieldByName('qty').AsFloat<=0 then
        begin
          CDS2.Locate('Orderno2;Orderitem2',VarArrayOf([FieldByName('Orderno2').AsString,FieldByName('Orderitem2').AsInteger]),[]);
          ShowMsg('['+FieldByName('Orderno2').AsString+'/'+FieldByName('Orderitem2').AsString+']請輸入出貨數量!',48);
          Exit;
        end;
        tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('Orderno2').AsString);
        Next;
      end;
    end;

    if Length(tmpOrderno)=0 then
    begin
      ShowMsg('請選擇資料!',48);
      Exit;
    end;

    Delete(tmpOrderno,1,1);

    tmpSQL:=DateToStr(Date);
    if not InputQuery(CheckLang('請輸入出貨日期'), 'date', tmpSQL) then
       Exit;
    tmpSQL:=Trim(tmpSQL);
    if tmpSQL = '' then
       Exit;
    try
      D:=StrToDate(tmpSQL);
    except
      ShowMsg('日期格式錯誤!',48);
      Exit;
    end;

    if D<Date then
    begin
      ShowMsg('出貨日期不能小於當前日期!',48);
      Exit;
    end;

    if CheckConfirm(D) then
    begin
      ShowMsg(DateToStr(D)+'出貨表已確認,請使用單筆新增!', 48);
      Exit;
    end;

   // if ShowMsg('確定新增'+DateToStr(D)+'日期的出貨表嗎?', 33)=IdCancel then
   //    Exit;

    if not CheckLockProc(IsLock) then
       Exit;

    if IsLock then
    begin
      ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
      Exit;
    end;

    if not LockProc then
       Exit;

    IsLock:=True;

    //Indate出貨表
    tmpSQL:='Select * From DLI010 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(D))
           +' And Len(IsNull(Dno_Ditem,''''))=0'
           +' And IsNull(GarbageFlag,0)=0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS010.Data:=Data;

    //tiptop資料
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢訂單資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:=GetOraSQL('ITEQGZ',' and oea01 in ('+tmpOrderno+')');
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDSOra.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在處理資料...');
    Application.ProcessMessages;
    tmpStr:='';
    tmpDno:=GetSno('DLII010');
    tmpSno:=GetMPSSno(D);
    tmpDitem:=1;
    for i:=0 to 1 do
    begin
      with tmpCDS do
      begin
        if i=0 then
           Data:=CDS1.Data
        else
           Data:=CDS2.Data;
        Filtered:=False;
        Filter:='select=1';
        Filtered:=True;
        First;
      end;

      g_ProgressBar.Max:=tmpCDS.RecordCount;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Visible:=True;
      while not tmpCDS.Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;
        
        tmpMsg:=tmpCDS.FieldByName('Orderno2').AsString+'/'+
                tmpCDS.FieldByName('Orderitem2').AsString+' ';
        tmpQty:=tmpCDS.FieldByName('qty').AsFloat;

        if not tmpCDSOra.Locate('oea01;oeb03',VarArrayOf(
              [tmpCDS.FieldByName('Orderno2').AsString,
               tmpCDS.FieldByName('Orderitem2').AsString]),[]) then
           tmpStr:=tmpStr+tmpMsg+' TipTop不存在'+#13#10
        else if tmpCDSOra.FieldByName('oeb70').AsString='Y' then
           tmpStr:=tmpStr+tmpMsg+tmpCDSOra.FieldByName('oea04').AsString+' 已結案'+#13#10
        else if tmpCDSOra.FieldByName('oeb12').AsFloat<=0 then
           tmpStr:=tmpStr+tmpMsg+tmpCDSOra.FieldByName('oea04').AsString+' 訂單量為0'+#13#10
        else if tmpQty>tmpCDSOra.FieldByName('notqty').AsFloat then
           tmpStr:=tmpStr+tmpMsg+tmpCDSOra.FieldByName('oea04').AsString+' 出貨數量['+FloatToStr(tmpQty)+']大於未出數量['+FloatToStr(tmpCDSOra.FieldByName('notqty').AsFloat)+']'+#13#10
        else begin
          tmpList.Add(tmpCDSOra.FieldByName('oea01').AsString+'/'+
             IntToStr(tmpCDSOra.FieldByName('oeb03').AsInteger));

          //添加資料到DLI010
          with tmpCDS010 do
          begin
            if Locate('Orderno;Orderitem;Pno',
                  VarArrayOf([tmpCDSOra.FieldByName('oea01').AsString,
                              tmpCDSOra.FieldByName('oeb03').AsInteger,
                              tmpCDSOra.FieldByName('oeb04').AsString]), []) then
            begin
              Edit;
              FieldByName('Notcount1').AsFloat:=FieldByName('Notcount1').AsFloat+tmpQty;
            end else
            begin
              Append;

              for j:=0 to FieldCount-1 do
              if Fields[j].DataType in [ftBoolean] then
                 Fields[j].AsBoolean:=False
              else if Fields[j].DataType in [ftFloat, ftCurrency, ftBCD, ftSmallint, ftInteger, ftWord] then
                 Fields[j].Value:=0;

              FieldByName('Bu').AsString:=g_UInfo^.BU;
              FieldByName('Dno').AsString:=tmpDno;
              FieldByName('Ditem').AsInteger:=tmpDitem;
              FieldByName('Sno').AsInteger:=tmpSno;
              FieldByName('Indate').AsDateTime:=DateOf(D);
              FieldByName('Iuser').AsString:=g_Uinfo^.UserId;
              FieldByName('Idate').AsDateTime:=Now;

              //tiptop
              FieldByName('Odate').AsDateTime:=DateOf(tmpCDSOra.FieldByName('oea02').AsDateTime);
              FieldByName('Ddate').AsDateTime:=DateOf(tmpCDSOra.FieldByName('oeb15').AsDateTime);
              FieldByName('Custno').AsString:=tmpCDSOra.FieldByName('oea04').AsString;
              FieldByName('Custshort').AsString:=tmpCDS.FieldByName('custom').AsString;   //tmpCDSOra.FieldByName('occ02').AsString;
              FieldByName('Orderno').AsString:=tmpCDSOra.FieldByName('oea01').AsString;
              FieldByName('Orderitem').AsInteger:=tmpCDSOra.FieldByName('oeb03').AsInteger;
              FieldByName('Pno').AsString:=tmpCDSOra.FieldByName('oeb04').AsString;
              FieldByName('Pname').AsString:=tmpCDSOra.FieldByName('oeb06').AsString;
              FieldByName('Sizes').AsString:=tmpCDSOra.FieldByName('ima021').AsString;
              FieldByName('Longitude').AsString:=tmpCDSOra.FieldByName('ta_oeb01').AsString;
              FieldByName('Latitude').AsString:=tmpCDSOra.FieldByName('ta_oeb02').AsString;
              FieldByName('Ordercount').AsFloat:=tmpCDSOra.FieldByName('oeb12').AsFloat;
              FieldByName('Notcount').AsFloat:=tmpQty;
              FieldByName('Notcount1').AsFloat:=tmpQty;
              FieldByName('Units').AsString:=tmpCDSOra.FieldByName('oeb05').AsString;
              FieldByName('Custorderno').AsString:=tmpCDSOra.FieldByName('oea10').AsString;
              FieldByName('Custprono').AsString:=tmpCDSOra.FieldByName('oeb11').AsString;
              FieldByName('Custname').AsString:=tmpCDSOra.FieldByName('ta_oeb10').AsString;
              FieldByName('Remark').AsString:=tmpCDSOra.FieldByName('oao06').AsString;
              FieldByName('SendAddr').AsString:=tmpCDSOra.FieldByName('ocd221').AsString;
              case StrToIntDef(tmpCDSOra.FieldByName('ta_oeb22').AsString, -1) of
                0:FieldByName('CtrlRemark').AsString:=CheckLang('不管控');
                1:FieldByName('CtrlRemark').AsString:=CheckLang('可短交');
                2:FieldByName('CtrlRemark').AsString:=CheckLang('可超交');
                3:FieldByName('CtrlRemark').AsString:=CheckLang('不可短交不可超交');
              end;
              FieldByName('kg').AsString:=tmpCDSOra.FieldByName('ima18').AsString;
              //tiptop

              FieldByName('SourceDitem').Clear;
              FieldByName('Stime').AsDateTime:=GetStime(FieldByName('Custno').AsString);
              FieldByName('Adate').Value:=tmpCDS.FieldByName('Adate_new').Value;
              FieldByName('Remark4').AsString:=tmpCDS.FieldByName('Premark').AsString;
              Inc(tmpDitem); Inc(tmpSno);
            end;

            FieldByName('Remark1').AsString:=Trim(tmpCDS.FieldByName('wono').AsString+' '+
                           IntToStr(MonthOf(tmpCDS.FieldByName('sdate').AsDateTime))+'/'+
                           IntToStr(DayOf(tmpCDS.FieldByName('sdate').AsDateTime))+' '+
                           tmpCDS.FieldByName('machine').AsString+'-'+
                           tmpCDS.FieldByName('sqty').AsString);
            if Pos(Copy(FieldByName('Pno').AsString,1,1),'ET')>0 then
               FieldByName('Remark1').AsString:=FieldByName('Remark1').AsString
                           +' '+tmpCDS.FieldByName('currentboiler').AsString+CheckLang('鍋');
            FieldByName('Remark2').AsString:=tmpCDS.FieldByName('wono').AsString;
            Post;
          end;
        end;

        tmpCDS.Next;
      end;
    end;

    tmpSQL:='新增完畢,共產生'+IntToStr(tmpList.Count)+'筆';
    if tmpList.Count=0 then
    begin
      Memo1.Lines.Text:=tmpSQL+#13#10+tmpStr;
      PCL.ActivePageIndex:=2;
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在儲存資料...');
    Application.ProcessMessages;
    if CDSPost(tmpCDS010, 'DLI010') then
    begin
      //只保留異動的
      with tmpCDS010 do
      begin
        First;
        while not Eof do
        begin
          if tmpList.IndexOf(FieldByName('Orderno').AsString+'/'+
                    IntToStr(FieldByName('Orderitem').AsInteger))=-1 then
          begin
            Delete;
            Continue;
          end;
          Next;
        end;
        MergeChangeLog;
      end;
      //刷新
      GetDS;
      RefreshGrdCaption(FrmMPST040.CDS,FrmMPST040.DBGridEh1,FrmMPST040.l_StrIndex,FrmMPST040.l_StrIndexDesc);
      FrmMPST040.CDS.Data:=tmpCDS010.Data;
      //提示
      Memo1.Lines.Text:=tmpSQL+#13#10+tmpStr;
      PCL.ActivePageIndex:=2;      
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
    DBGridEh1.Enabled:=True;
    DBGridEh2.Enabled:=True;
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS010);
    FreeAndNil(tmpCDSOra);
    FreeAndNil(tmpList);
    if IsLock then
       UnLockProc;
  end;
end;

procedure TFrmMPST040_gz.Btn1Click(Sender: TObject);
var
  isTrue:Boolean;
  tmpCDS:TClientDataSet;
begin
  inherited;
  isTrue:=TBitBtn(Sender).Tag=0;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if PCL.ActivePageIndex=0 then
    begin
      tmpCDS.Data:=CDS1.Data;
      while not tmpCDS.Eof do
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('select').AsBoolean:=isTrue;
        tmpCDS.Next;
      end;
      if tmpCDS.ChangeCount>0 then
      begin
        tmpCDS.MergeChangeLog;
        CDS1.Data:=tmpCDS.Data;
      end;
    end;

    if PCL.ActivePageIndex=1 then
    begin
      tmpCDS.Data:=CDS2.Data;
      while not tmpCDS.Eof do
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('select').AsBoolean:=isTrue;
        tmpCDS.Next;
      end;
      if tmpCDS.ChangeCount>0 then
      begin
        tmpCDS.MergeChangeLog;
        CDS2.Data:=tmpCDS.Data;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST040_gz.CDS1BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST040_gz.CDS2BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST040_gz.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName,'qty') then
     Background:=clMoneyGreen;
end;

procedure TFrmMPST040_gz.DBGridEh2GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName,'qty') then
     Background:=clMoneyGreen;
end;

end.
