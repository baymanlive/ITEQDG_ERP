unit unMPST090;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, StrUtils, Math, unGridDesign;

type
  TFrmMPST090 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_mpst090: TToolButton;
    btn_mpst090_export: TToolButton;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1ColWidthsChanged(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure btn_mpst090Click(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_mpst090_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_gen03:string;
    l_GridDesign1,l_GridDesign2:TGridDesign;
    function CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS:TClientDataSet; isCCL:Boolean):string;
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST090: TFrmMPST090;

implementation

uses unGlobal, unCommon, unMPST090_query, unMPST090_Export;

{$R *.dfm}

procedure TFrmMPST090.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if (strFilter='0') or (strFilter='1') then
  begin
    tmpSQL:='exec dbo.proc_MPST090 0,'+strFilter;
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;

    Data:=null;
    tmpSQL:='exec dbo.proc_MPST090 1,'+strFilter;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  end else
  begin
    tmpSQL:='select case_ans1 as checkbox,* from mps010 where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;

    Data:=null;
    tmpSQL:='select case_ans1 as checkbox,* from mps070 where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  end;

  inherited;
end;

procedure TFrmMPST090.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS010';
  p_GridDesignAns:=False;
  btn_mpst090.Visible:=g_MInfo^.R_edit;
  btn_mpst090_export.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
  begin
    btn_mpst090.Left := btn_quit.Left;
    btn_mpst090_export.Left := btn_quit.Left;
  end;

  inherited;

  TabSheet1.Caption:=CheckLang('CCL排程資料');
  TabSheet2.Caption:=CheckLang('PP排程資料');
  SetGrdCaption(DBGridEh2, 'MPS070');
  
  DBGridEh1.FieldColumns['CheckBox'].Title.Caption:=CheckLang('選中');
  DBGridEh2.FieldColumns['CheckBox'].Title.Caption:=CheckLang('選中');
  DBGridEh1.FieldColumns['CheckBox'].Width:=40;
  DBGridEh2.FieldColumns['CheckBox'].Width:=40;

  DBGridEh1.FieldColumns['iscreate'].Title.Caption:=CheckLang('已產生');
  DBGridEh2.FieldColumns['iscreate'].Title.Caption:=CheckLang('已產生');
  DBGridEh1.FieldColumns['iscreate'].Width:=50;
  DBGridEh2.FieldColumns['iscreate'].Width:=50;

  DBGridEh1.FieldColumns['isdomestic'].Title.Caption:=CheckLang('內銷');
  DBGridEh2.FieldColumns['isdomestic'].Title.Caption:=CheckLang('內銷');
  DBGridEh1.FieldColumns['isdomestic'].Width:=50;
  DBGridEh2.FieldColumns['isdomestic'].Width:=50;

  DBGridEh1.FieldColumns['isdg'].Title.Caption:=CheckLang('DG訂單');
  DBGridEh2.FieldColumns['isdg'].Title.Caption:=CheckLang('DG訂單');
  DBGridEh1.FieldColumns['isdg'].Width:=60;
  DBGridEh2.FieldColumns['isdg'].Width:=60;

  l_GridDesign1:=TGridDesign.Create(DBGridEh1, 'MPST090_1');
  l_GridDesign2:=TGridDesign.Create(DBGridEh2, 'MPST090_2');
end;

procedure TFrmMPST090.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_GridDesign1);
  FreeAndNil(l_GridDesign2);
end;

procedure TFrmMPST090.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPST090_query) then
     FrmMPST090_query:=TFrmMPST090_query.Create(Application);
  if FrmMPST090_query.ShowModal=mrOK then
     RefreshDS(IntToStr(FrmMPST090_query.RadioGroup1.ItemIndex));
end;

procedure TFrmMPST090.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'checkbox') then
  begin
    CDS.Edit;
    CDS.FieldByName('checkbox').AsBoolean:=not CDS.FieldByName('checkbox').AsBoolean;
    CDS.Post;
    CDS.MergeChangeLog;
  end;
end;

procedure TFrmMPST090.DBGridEh2CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'checkbox') then
  begin
    CDS2.Edit;
    CDS2.FieldByName('checkbox').AsBoolean:=not CDS2.FieldByName('checkbox').AsBoolean;
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;
end;

procedure TFrmMPST090.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign1) then
     l_GridDesign1.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPST090.DBGridEh1ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign1) then
     l_GridDesign1.ColWidthChange;
end;

procedure TFrmMPST090.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPST090.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.ColWidthChange;
end;

procedure TFrmMPST090.btn_mpst090Click(Sender: TObject);
const gzMachine='L6,T6,T7,T8';
const gzLstCode='G,n,z,w,k,9,r,h,s,v,F';
const dgLstCode='X,N,W,K,H,3,9,R,S,1,V';
var
  isCCL:Boolean;
  tmpSQL,tmpPMK01,tmpPMK02:string;
  tmpCDS,oebCDS,pmkCDS,pmlCDS,tc_pmlCDS,genCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (PCL.ActivePageIndex=0) and ((not CDS.Active) or CDS.IsEmpty) then
  begin
    ShowMsg('['+PCL.Pages[0].Caption+']未選擇任何單據!',48);
    Exit;
  end;

  if (PCL.ActivePageIndex=1) and ((not CDS2.Active) or CDS2.IsEmpty) then
  begin
    ShowMsg('['+PCL.Pages[1].Caption+']未選擇任何單據!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  oebCDS:=TClientDataSet.Create(nil);
  pmkCDS:=TClientDataSet.Create(nil);
  pmlCDS:=TClientDataSet.Create(nil);
  tc_pmlCDS:=TClientDataSet.Create(nil);
  genCDS:=TClientDataSet.Create(nil);
  try
    //賦值
    if PCL.ActivePageIndex=0 then
    begin
      isCCL:=True;
      tmpCDS.Data:=CDS.Data;
    end else
    begin
      isCCL:=False;
      tmpCDS.Data:=CDS2.Data;
    end;
    //*

    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1';
    tmpCDS.Filtered:=True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('['+PCL.Pages[PCL.ActivePageIndex].Caption+']未選擇任何單據!',48);
      Exit;
    end;

    if tmpCDS.RecordCount>100 then
    begin
      ShowMsg('最多可選100筆,請重新選擇!',48);
      Exit;
    end;

    tmpSQL:='';
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL:=tmpSQL+' or (oeb01='+Quotedstr(tmpCDS.FieldByName('orderno').AsString)
                    +' and oeb03='+IntToStr(tmpCDS.FieldByName('orderitem').AsInteger)+')';

      if (tmpCDS.FieldByName('isdg').AsString='Y') and
         (Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)=0) then
      begin
        ShowMsg('東莞訂單東莞生產不可轉單!',48);
        Exit;
      end;

      if (tmpCDS.FieldByName('isdg').AsString='N') and
         (Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)>0) then
      begin
        ShowMsg('廣州訂單廣州生產不可轉單!',48);
        Exit;
      end;

      tmpCDS.Next;
    end;

    if tmpCDS.Locate('iscreate','Y',[]) then
    begin
      if ShowMsg('存在已產生請購單的單據'+#13#10+'確定繼續產生請購單嗎?',33)=IdCancel then
         Exit;
    end else
    if ShowMsg('確定產生請購單嗎?',33)=IdCancel then
       Exit;

    //訂單資料
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢訂單資料...');
    Application.ProcessMessages;
    Delete(tmpSQL,1,3);
    Data:=null;
    if tmpCDS.FieldByName('isdg').AsString='Y' then
       tmpSQL:='select * from iteqdg.oeb_file where '+tmpSQL
    else
       tmpSQL:='select * from iteqgz.oeb_file where '+tmpSQL;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    oebCDS.Data:=Data;

    //檢查料號及尾碼
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL:='['+tmpCDS.FieldByName('orderno').AsString+'/'+tmpCDS.FieldByName('orderitem').AsString+']';

      if not oebCDS.Locate('oeb01;oeb03',
           VarArrayOf([tmpCDS.FieldByName('orderno').AsString,
                       tmpCDS.FieldByName('orderitem').AsInteger]),[]) then
      begin
        ShowMsg(tmpSQL+'訂單不存在!',48);
        Exit;
      end;

      //pn不檢查
      if not (Length(oebCDS.FieldByName('oeb04').AsString) in [11,12,19,20]) then
      begin
        //if RightStr(oebCDS.FieldByName('oeb04').AsString,1)<>RightStr(tmpCDS.FieldByName('materialno').AsString,1) then
        //begin
        //  ShowMsg(tmpSQL+'與原始訂單尾碼不相同,不可轉單!',48);
        //  Exit;
        //end;

        if Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)>0 then
        begin
          if Pos(RightStr(tmpCDS.FieldByName('materialno').AsString,1), gzLstCode)=0 then
          begin
            ShowMsg(tmpSQL+'尾碼非'+gzLstCode+'不可轉單!',48);
            Exit;
          end;
        end;

        if Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)=0 then
        begin
          if Pos(RightStr(tmpCDS.FieldByName('materialno').AsString,1), dgLstCode)=0 then
          begin
            ShowMsg(tmpSQL+'尾碼非'+dgLstCode+'不可轉單!',48);
            Exit;
          end;
        end;
      end;

      tmpCDS.Next;
    end;

    if Length(l_gen03)=0 then
    begin
      //部門編號
      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢部門編號...');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:='select gen03 from gen_file where gen01='+Quotedstr(UpperCase(g_UInfo^.UserId));
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;
      genCDS.Data:=Data;
      //*

      if not genCDS.IsEmpty then
         l_gen03:=genCDS.Fields[0].AsString;

      if Length(l_gen03)=0 then
      begin
        ShowMsg('無部門編號,請確認!',48);
        Exit;
      end;
    end;

    //請購單
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢請購單資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from pmk_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmkCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmlCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from tc_pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tc_pmlCDS.Data:=Data;
    //*

    //內銷
    g_StatusBar.Panels[1].Text:=CheckLang('正在產生內銷請購單...');
    Application.ProcessMessages;
    tmpPMK01:='';
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1 and isdomestic=''Y''';
    tmpCDS.Filtered:=True;
    if not tmpCDS.IsEmpty then
    begin
      tmpPMK01:=CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, isCCL);
      if Length(tmpPMK01)=0 then
         Exit;
    end;

    //外銷
    g_StatusBar.Panels[1].Text:=CheckLang('正在產生外銷請購單...');
    Application.ProcessMessages;
    tmpPMK02:='';
    pmkCDS.EmptyDataSet;
    pmlCDS.EmptyDataSet;
    tc_pmlCDS.EmptyDataSet;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1 and isdomestic=''N''';
    tmpCDS.Filtered:=True;
    if not tmpCDS.IsEmpty then
       tmpPMK02:=CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, isCCL);
    g_StatusBar.Panels[1].Text:='';
    Application.ProcessMessages;

    if isCCL then
       CDS.CancelUpdates
    else
       CDS2.CancelUpdates;

    if Length(tmpPMK02)>0 then
       if Length(tmpPMK01)>0 then
          tmpPMK01:=tmpPMK01+','+tmpPMK02
       else
          tmpPMK01:=tmpPMK02;
    if Length(tmpPMK01)>0 then
       ShowMsg('執行完畢,請購單號:'+tmpPMK01,64);

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(oebCDS);
    FreeAndNil(pmkCDS);
    FreeAndNil(pmlCDS);
    FreeAndNil(tc_pmlCDS);
    FreeAndNil(genCDS);
    g_StatusBar.Panels[0].Text:='';
    g_StatusBar.Panels[1].Text:='';
  end;
end;

//返回請購單號
function TFrmMPST090.CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS:TClientDataSet;
  isCCL:Boolean):string;
var
  tmpSQL,tmpDBType,tmpPMK01:String;
  tmpCDS,imaCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:='';

  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    if not oebCDS.Locate('oeb01;oeb03',
         VarArrayOf([sourceCDS.FieldByName('orderno').AsString,
                     sourceCDS.FieldByName('orderitem').AsInteger]),[]) then
    begin
      ShowMsg('['+sourceCDS.FieldByName('orderno').AsString+'/'+sourceCDS.FieldByName('orderitem').AsString+']訂單不存在!',48);
      Exit;
    end;

    //pmlCDS請購單單身
    pmlCDS.Append;
    pmlCDS.FieldByName('pml01').AsString:='?';        //單號
    pmlCDS.FieldByName('pml011').AsString:='TAP';     //單據性質:TAP多角代採購
    pmlCDS.FieldByName('pml02').AsInteger:=pmlCDS.RecordCount+1;  //項次
    pmlCDS.FieldByName('pml04').AsString:='?';        //料號
    pmlCDS.FieldByName('pml041').AsString:='?';       //品名ima02
    pmlCDS.FieldByName('pml06').AsString:=oebCDS.FieldByName('oeb01').AsString+'-'+oebCDS.FieldByName('oeb03').AsString; //備註
    pmlCDS.FieldByName('pml08').AsString:='?';        //庫存單位ima25
    pmlCDS.FieldByName('pml09').AsFloat:=oebCDS.FieldByName('oeb05_fac').AsFloat;  //單位轉換率
    pmlCDS.FieldByName('pml11').AsString:='N';        //凍結碼
    pmlCDS.FieldByName('pml121').AsInteger:=0;        //專案代號-順序
    pmlCDS.FieldByName('pml122').AsInteger:=0;        //專案代號-項次
    pmlCDS.FieldByName('pml13').AsFloat:=0;           //允許可超交/短交數量比率
    pmlCDS.FieldByName('pml14').AsString:='Y';        //部份交貨否
    pmlCDS.FieldByName('pml15').AsString:='Y';        //提前交貨否
    pmlCDS.FieldByName('pml16').AsString:='1';        //狀況碼:0開立,1核准
    pmlCDS.FieldByName('pml18').AsDateTime:=EncodeDate(1899,12,31);  //MRP需求日期

    //處理請購料號,單位,數量
    //dg訂單,廣州請購
    if SourceCDS.FieldByName('isdg').AsString='Y' then
    begin
      if isCCL then
      begin
        if Length(oebCDS.FieldByName('oeb04').AsString) in [11,19] then //ccl pnl
        begin
          pmlCDS.FieldByName('pml07').AsString:='PN';
          pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;         //請購原訂單料號
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end else
        begin
          pmlCDS.FieldByName('pml07').AsString:='SH';
          pmlCDS.FieldByName('pml04').AsString:=SourceCDS.FieldByName('materialno').AsString; //請購排程料號
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end;
      end else
      begin
        if Length(oebCDS.FieldByName('oeb04').AsString) in [12,20] then //pp pnl
        begin
          pmlCDS.FieldByName('pml07').AsString:='RL';
          pmlCDS.FieldByName('pml04').AsString:=SourceCDS.FieldByName('materialno').AsString; //請購排程料號
          pmlCDS.FieldByName('pml20').AsFloat:=RoundTo(SourceCDS.FieldByName('sqty').AsFloat/StrToInt(Copy(SourceCDS.FieldByName('materialno').AsString,11,3)),-3);
        end else
        begin
          pmlCDS.FieldByName('pml07').AsString:='RL';
          pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;         //請購原訂單料號
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end;
      end;
    end else  //gz訂單,dg請購(無PNL)
    begin
      if Length(oebCDS.FieldByName('oeb04').AsString) in [11,12,19,20] then
         pmlCDS.FieldByName('pml07').AsString:='PN'
      else if Length(oebCDS.FieldByName('oeb04').AsString)=18 then
         pmlCDS.FieldByName('pml07').AsString:='RL'
      else
         pmlCDS.FieldByName('pml07').AsString:='SH';
      pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;
      pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
    end;

    pmlCDS.FieldByName('pml21').AsFloat:=0;
    pmlCDS.FieldByName('pml23').AsString:='Y';        //課稅否
    pmlCDS.FieldByName('pml30').AsFloat:=0;           //本幣標準價格
    pmlCDS.FieldByName('pml31').AsFloat:=0;           //未稅單價
    pmlCDS.FieldByName('pml31t').AsFloat:=0;          //含稅單價
    pmlCDS.FieldByName('pml32').AsFloat:=0;           //採購價差
    pmlCDS.FieldByName('pml33').AsDateTime:=Date+7;   //交貨日期
    pmlCDS.FieldByName('pml34').AsDateTime:=pmlCDS.FieldByName('pml33').AsDateTime;  //到廠日期
    pmlCDS.FieldByName('pml35').AsDateTime:=pmlCDS.FieldByName('pml33').AsDateTime;  //到庫日期
    pmlCDS.FieldByName('pml38').AsString:='Y';        //可用/不可用
    pmlCDS.FieldByName('pml42').AsString:='0';        //替代碼0:原始料件,不可被替代
    pmlCDS.FieldByName('pml43').AsInteger:=0;         //作業序號
    pmlCDS.FieldByName('pml431').AsInteger:=0;        //下一站作業序號
    pmlCDS.FieldByName('pml67').AsString:=l_gen03;    //部門編號
    pmlCDS.Post;
    //*

    //保存請購料號、數量
    sourceCDS.Edit;
    sourceCDS.FieldByName('p_pno').AsString:=pmlCDS.FieldByName('pml04').AsString;
    sourceCDS.FieldByName('p_qty').AsFloat:=pmlCDS.FieldByName('pml20').AsFloat;
    sourceCDS.Post;

    //擴展資料
    tc_pmlCDS.Append;
    //tc_pmlCDS.FieldByName('tc_pml03').AsString:='1' //單位 1.MM 2.INCH  不會處理,不管了
    if Length(pmlCDS.FieldByName('pml04').AsString) in [11,12,19,20] then
    begin
      tc_pmlCDS.FieldByName('tc_pml03').AsString:='2';
      tc_pmlCDS.FieldByName('tc_pml01').AsFloat:=oebCDS.FieldByName('ta_oeb01').AsFloat;      //經度
      tc_pmlCDS.FieldByName('tc_pml02').AsFloat:=oebCDS.FieldByName('ta_oeb02').AsFloat;      //緯度
      tc_pmlCDS.FieldByName('tc_pml04').AsString:=oebCDS.FieldByName('ta_oeb04').AsString;    //CCL尺寸代碼
      tc_pmlCDS.FieldByName('tc_pml05').AsString:=oebCDS.FieldByName('ta_oeb05').AsString ;   //玻布碼
      tc_pmlCDS.FieldByName('tc_pml06').AsString:=oebCDS.FieldByName('ta_oeb06').AsString ;   //銅箔碼
      tc_pmlCDS.FieldByName('tc_pml07').AsString:=oebCDS.FieldByName('ta_oeb07').AsString;    //裁剪方式
      tc_pmlCDS.FieldByName('tc_pml08').AsInteger:=oebCDS.FieldByName('ta_oeb08').AsInteger;  //併裁
      tc_pmlCDS.FieldByName('tc_pml09').AsString:=oebCDS.FieldByName('ta_oeb09').AsString ;   //導角
    end;

    tc_pmlCDS.FieldByName('tc_pml10').AsString:='?';   //請購單號
    tc_pmlCDS.FieldByName('tc_pml11').AsInteger:=tc_pmlCDS.RecordCount+1;  //請購單項次
    tc_pmlCDS.Post;
    //*

    sourceCDS.Next;
  end;

  //pmlCDS請購單單頭
  pmkCDS.Append;
  pmkCDS.FieldByName('pmk01').AsString:='?';                                     //單號
  pmkCDS.FieldByName('pmk02').AsString:='TAP';                                   //單據性質:TAP多角代採購
  pmkCDS.FieldByName('pmk03').AsInteger:=0;                                      //版本更動序號
  pmkCDS.FieldByName('pmk04').AsDateTime:=Date;                                  //請購日期
                                                                                 //供應商pmk09
  if SourceCDS.FieldByName('isdg').AsString='N' then                             //gz訂單,dg請購
     pmkCDS.FieldByName('pmk09').AsString:='N005'
  else if SourceCDS.FieldByName('isdomestic').AsString='Y' then                  //dg訂單,gz請購,內銷
     pmkCDS.FieldByName('pmk09').AsString:='N012'
  else                                                                           //dg訂單,gz請購,外銷
     pmkCDS.FieldByName('pmk09').AsString:='N018';
  pmkCDS.FieldByName('pmk12').AsString:=UpperCase(g_UInfo^.UserId); //請購員
  pmkCDS.FieldByName('pmk13').AsString:=l_gen03;                                 //請購部門
  pmkCDS.FieldByName('pmk14').AsString:=l_gen03;                                 //收貨部門
  pmkCDS.FieldByName('pmk15').AsString:=pmkCDS.FieldByName('pmk12').AsString;    //收貨確認人
  pmkCDS.FieldByName('pmk18').AsString:='Y';                                     //確認否
  pmkCDS.FieldByName('pmk25').AsString:='1';                                     //0:開立,1:核准
  pmkCDS.FieldByName('pmk27').AsDateTime:=Date;                                  //狀況異動日期
  pmkCDS.FieldByName('pmk30').AsString:='Y';                                     //收貨單列印否
  pmkCDS.FieldByName('pmk40').AsFloat:=0;                                        //未知
  pmkCDS.FieldByName('pmk401').AsFloat:=0;                                       //未知
  pmkCDS.FieldByName('pmk42').AsFloat:=1;                                        //匯率
  pmkCDS.FieldByName('pmk43').AsFloat:=0;                                        //稅率
  pmkCDS.FieldByName('pmk45').AsString:='Y';                                     //可用/不可用
  pmkCDS.FieldByName('pmkprno').AsInteger:=0;                                    //列印次數
  pmkCDS.FieldByName('pmkmksg').AsString:='N';                                   //是否簽核
  pmkCDS.FieldByName('pmkdays').AsInteger:=0;                                    //簽核完成天數
  pmkCDS.FieldByName('pmksseq').AsInteger:=0;                                    //已簽核順序
  pmkCDS.FieldByName('pmksmax').AsInteger:=0;                                    //應簽核順序
  pmkCDS.FieldByName('pmkacti').AsString:='Y';                                   //資料有效碼
  pmkCDS.FieldByName('pmkuser').AsString:=pmkCDS.FieldByName('pmk12').AsString;  //資料所有者
  pmkCDS.FieldByName('pmkgrup').AsString:=l_gen03;                               //資料所有部門
  pmkCDS.Post;
  //*

  if SourceCDS.FieldByName('isdg').AsString='Y' then
     tmpDBType:='ORACLE'
  else
     tmpDBType:='ORACLE1';

  //處理品名,庫存單位
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢物品資料...');
  Application.ProcessMessages;
  tmpSQL:='';
  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    tmpSQL:=tmpSQL+','+Quotedstr(pmlCDS.FieldByName('pml04').AsString);
    pmlCDS.Next;
  end;
  Delete(tmpSQL,1,1);

  imaCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select ima01,ima02,ima25 from ima_file where ima01 in ('+tmpSQL+')';
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
       Exit;

    imaCDS.Data:=Data;
    pmlCDS.First;
    while not pmlCDS.Eof do
    begin
      if not imaCDS.Locate('ima01',pmlCDS.FieldByName('pml04').AsString,[]) then
      begin
        ShowMsg('料件基本資料找不到['+pmlCDS.FieldByName('pml04').AsString+']',48);
        Exit;
      end;

      pmlCDS.Edit;
      pmlCDS.FieldByName('pml041').AsString:=imaCDS.FieldByName('ima02').AsString;
      pmlCDS.FieldByName('pml08').AsString:=imaCDS.FieldByName('ima25').AsString;
      pmlCDS.Post;
      pmlCDS.Next;
    end;
  finally
    FreeAndNil(imaCDS);
  end;

  //處理單號
  g_StatusBar.Panels[0].Text:=CheckLang('正在計算請購單流水號...');
  Application.ProcessMessages;
  if SourceCDS.FieldByName('isdomestic').AsString='Y' then
     tmpPMK01:='317-'+GetYM     //317
  else
     tmpPMK01:='313-'+GetYM;    //313
  //tmpPMK01:='XXX-'+GetYM;       //測試單別
  Data:=null;
  tmpSQL:='select nvl(max(pmk01),'''') as pmk01 from pmk_file'
         +' where pmk01 like ''' + tmpPMK01 + '%''';
  if not QueryOneCR(tmpSQL, Data, tmpDBType) then
     Exit;
  tmpPMK01:=GetNewNo(tmpPMK01, VarToStr(Data));

  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    pmlCDS.Edit;
    pmlCDS.FieldByName('pml01').AsString:=tmpPMK01;
    pmlCDS.Post;
    pmlCDS.Next;
  end;

  tc_pmlCDS.First;
  while not tc_pmlCDS.Eof do
  begin
    tc_pmlCDS.Edit;
    tc_pmlCDS.FieldByName('tc_pml10').AsString:=tmpPMK01;
    tc_pmlCDS.Post;
    tc_pmlCDS.Next;
  end;

  pmkCDS.Edit;
  pmkCDS.FieldByName('pmk01').AsString:=tmpPMK01;
  pmkCDS.Post;
  //*

  //儲存
  g_StatusBar.Panels[0].Text:=CheckLang('正在儲存資料...');
  Application.ProcessMessages;
  if not CDSPost(pmkCDS, 'pmk_file', tmpDBType) then
     Exit;

  if not CDSPost(pmlCDS, 'pml_file', tmpDBType) then
  begin
    ShowMsg('單身資料儲存失敗'+#13#10+'請進入tiptop進行作廢處理,單號:'+tmpPMK01,48);
    Exit;
  end;

  if not CDSPost(tc_pmlCDS, 'tc_pml_file', tmpDBType) then
  begin
    ShowMsg('擴展資料儲存失敗'+#13#10+'請進入tiptop進行作廢處理,單號:'+tmpPMK01,48);
    Exit;
  end;

  //更新oeb_file,ta_oeb39請購單號
  g_StatusBar.Panels[0].Text:=CheckLang('正在更新訂單檔請購單號...');
  Application.ProcessMessages;
  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    tmpSQL:='update oeb_file set ta_oeb39='+Quotedstr(tmpPMK01+'-'+IntToStr(pmlCDS.FieldByName('pml02').AsInteger))
           +' where oeb01='+Quotedstr(LeftStr(pmlCDS.FieldByName('pml06').AsString,10))
           +' and oeb03='+Copy(pmlCDS.FieldByName('pml06').AsString,12,10);
    if not PostBySQL(tmpSQL, tmpDBType) then
    begin
      ShowMsg('更新訂單檔請購單號失敗'+#13#10+'請進入tiptop進行作廢處理,單號:'+tmpPMK01,48);
      Exit;
    end;

    pmlCDS.Next;
  end;

  //添加已產生請購單記錄
  g_StatusBar.Panels[0].Text:=CheckLang('正在添加日誌資料...');
  Application.ProcessMessages;
  tmpSQL:='';
  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    tmpSQL:=tmpSQL+' or (orderno='+Quotedstr(sourceCDS.FieldByName('orderno').AsString)
                  +' and orderitem='+IntToStr(sourceCDS.FieldByName('orderitem').AsInteger)+')';

    sourceCDS.Next;
  end;
  Delete(tmpSQL,1,3);
  Data:=null;
  if SourceCDS.FieldByName('isdg').AsString='Y' then
     tmpDBType:='ITEQDG'
  else
     tmpDBType:='ITEQGZ';
  tmpSQL:='select * from mps011 where ('+tmpSQL+') and bu='+Quotedstr(tmpDBType);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;

      sourceCDS.First;
      while not sourceCDS.Eof do
      begin
        if tmpCDS.Locate('orderno;orderitem',
            VarArrayOf([sourceCDS.FieldByName('orderno').AsString,
                        sourceCDS.FieldByName('orderitem').AsInteger]),[]) then
        begin
          tmpCDS.Edit;
          tmpCDS.FieldByName('num').AsInteger:=tmpCDS.FieldByName('num').AsInteger+1;
          tmpCDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
          tmpCDS.FieldByName('mdate').AsDateTime:=Now;
        end else
        begin
          tmpCDS.Append;
          tmpCDS.FieldByName('bu').AsString:=tmpDBType;
          tmpCDS.FieldByName('orderno').AsString:=sourceCDS.FieldByName('orderno').AsString;
          tmpCDS.FieldByName('orderitem').AsInteger:=sourceCDS.FieldByName('orderitem').AsInteger;
          tmpCDS.FieldByName('pno').AsString:=sourceCDS.FieldByName('p_pno').AsString;
          tmpCDS.FieldByName('qty').AsFloat:=sourceCDS.FieldByName('p_qty').AsFloat;
          tmpCDS.FieldByName('num').AsInteger:=1;
          tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
          tmpCDS.FieldByName('idate').AsDateTime:=Now;
        end;
        tmpCDS.Post;
        sourceCDS.Next;
      end;

      CDSPost(tmpCDS, 'mps011');
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  g_StatusBar.Panels[0].Text:='';
  Application.ProcessMessages;
  
  Result:=tmpPMK01;
end;

procedure TFrmMPST090.btn_exportClick(Sender: TObject);
begin
  //inherited;
  // if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  if CDS.Active and (PCL.ActivePageIndex=0) then
    GetExportXls(CDS, 'MPS010');

  if CDS2.Active and (PCL.ActivePageIndex=1) then
    GetExportXls(CDS2, 'MPS070');
end;

procedure TFrmMPST090.btn_mpst090_exportClick(Sender: TObject);
begin
  if not Assigned(FrmMPST090_Export) then
     FrmMPST090_Export:=TFrmMPST090_Export.Create(Application);
  FrmMPST090_Export.ShowModal;
end;

end.
