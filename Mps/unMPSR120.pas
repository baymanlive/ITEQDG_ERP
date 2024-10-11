{*******************************************************}
{                                                       }
{                unMPSR120                              }
{                Author: kaikai                         }
{                Create date: 2017/7/6                  }
{                Description: 訂單與庫存對照表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR120;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, StrUtils;

type
  TFrmMPSR120 = class(TFrmSTDI041)
    PnlRight: TPanel;
    btn_mpsr120A: TBitBtn;
    btn_mpsr120B: TBitBtn;
    btn_mpsr120C: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_mpsr120AClick(Sender: TObject);
    procedure btn_mpsr120BClick(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_mpsr120CClick(Sender: TObject);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    l_img02All,l_img02Out,l_OraDB:string;
    l_isDG:Boolean;
    l_SalCDS:TClientDataSet;
    l_StrIndex,l_StrIndexDesc:string;
    procedure GetDS(xFliter:string);
    procedure SetBtnEnabled(bool:Boolean);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR120: TFrmMPSR120;

implementation

uses unGlobal, unCommon, unMPSR120_Query, unFind, unCCLStruct;

{$R *.dfm}

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ta_oeb30" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="orderdate" fieldtype="date"/>'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="c_orderno" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="oeb11" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="ta_oea08" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="longitude" fieldtype="r8"/>'
           +'<FIELD attrname="latitude" fieldtype="r8"/>'
           +'<FIELD attrname="struct" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
           +'<FIELD attrname="orderqty" fieldtype="r8"/>'
           +'<FIELD attrname="qty1" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qty2" fieldtype="r8"/>'
           +'<FIELD attrname="qty3" fieldtype="r8"/>'
           +'<FIELD attrname="ddate" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="remark" fieldtype="string" WIDTH="400"/>'
           +'<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ok" fieldtype="boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

procedure TFrmMPSR120.GetDS(xFliter:string);
var
  Data:OleVariant;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
begin
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  g_StatusBar.Panels[0].Text:='正在查詢...';
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if l_isDG then
       tmpSQL:=' and oea04 not in (''N012'',''N005'')'
    else
       tmpSQL:='';
    tmpSQL:='select C.*,oao06 from'
           +' (select B.*,ima021 from'
           +' (select A.*,occ02 from'
           +' (select oea01,oea02,oea04,oea10,oeb03,oeb04,oeb05,oeb06,'
           +' oeb11,oeb12,oeb15,ta_oeb01,ta_oeb02,ta_oeb04,ta_oeb10,ta_oeb30,'
           +' to_char(oea02,''YYYY/MM/DD'') q_oea02,'
           +' case when ta_oea08=1 then ''依樣品流程作業'' when ta_oea08=2 then ''無需依樣品流程作業'' end ta_oea08 '
           +' from '+l_OraDB+'.oea_file inner join '+l_OraDB+'.oeb_file on oea01=oeb01'
           +' where oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>0 '+tmpSQL
           +' and substr(oeb04,1,1)<>''F'') A'
           +' inner join '+l_OraDB+'.occ_file on oea04=occ01 where 1=1 '+xFliter
           +' ) B left join '+l_OraDB+'.ima_file on oeb04=ima01'
           +' ) C left join '+l_OraDB+'.oao_file on oea01=oao01 and oeb03=oao03'
           +' order by oea02,oea01,oeb03';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;

    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if IsEmpty then
         Exit;
      while not Eof do
      begin
        //oao_file資料有可能多筆
        if l_SalCDS.Locate('orderno;orderitem',VarArrayOf([FieldByName('oea01').AsString,FieldByName('oeb03').AsInteger]),[]) then
        begin
          l_SalCDS.Edit;
          l_SalCDS.FieldByName('remark').AsString:=l_SalCDS.FieldByName('remark').AsString+FieldByName('oao06').AsString;
          l_SalCDS.Post;
        end else
        begin
          l_SalCDS.Append;
          l_SalCDS.FieldByName('ok').AsBoolean:=false;
          l_SalCDS.FieldByName('custno').AsString:=FieldByName('oea04').AsString;
          l_SalCDS.FieldByName('custshort').AsString:=FieldByName('occ02').AsString;
          l_SalCDS.FieldByName('orderdate').AsDateTime:=FieldByName('oea02').AsDateTime;
          l_SalCDS.FieldByName('orderno').AsString:=FieldByName('oea01').AsString;
          l_SalCDS.FieldByName('orderitem').AsInteger:=FieldByName('oeb03').AsInteger;
          l_SalCDS.FieldByName('pno').AsString:=FieldByName('oeb04').AsString;
          l_SalCDS.FieldByName('pname').AsString:=FieldByName('oeb06').AsString;
          l_SalCDS.FieldByName('sizes').AsString:=FieldByName('ima021').AsString;
          l_SalCDS.FieldByName('c_orderno').AsString:=FieldByName('oea10').AsString;
          l_SalCDS.FieldByName('oeb11').AsString:=FieldByName('oeb11').AsString;
          l_SalCDS.FieldByName('c_sizes').AsString:=FieldByName('ta_oeb10').AsString;
          l_SalCDS.FieldByName('longitude').AsString:=FieldByName('ta_oeb01').AsString;
          l_SalCDS.FieldByName('latitude').AsString:=FieldByName('ta_oeb02').AsString;
          l_SalCDS.FieldByName('units').AsString:=FieldByName('oeb05').AsString;
          l_SalCDS.FieldByName('ta_oea08').AsString:=FieldByName('ta_oea08').AsString;
          l_SalCDS.FieldByName('orderqty').AsFloat:=FieldByName('oeb12').AsFloat;
          l_SalCDS.FieldByName('ddate').AsString:=FieldByName('oeb15').AsString;
          l_SalCDS.FieldByName('remark').AsString:=FieldByName('oao06').AsString;
          l_SalCDS.FieldByName('ta_oeb30').AsString:=FieldByName('ta_oeb30').AsString;
          l_SalCDS.FieldByName('ta_oeb04').AsString:=FieldByName('ta_oeb04').AsString;
          l_SalCDS.Post;
        end;
        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:='正在更新狀態...';
    tmpSql:= 'exec proc_MPSR120_1 '+quotedstr(g_uinfo.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.data:=data;
    l_SalCDS.first;
    while not l_SalCDS.Eof do
    begin
      if tmpCDS.Locate('orderno;orderitem',VarArrayOf([l_SalCDS.FieldByName('orderno').AsString,l_SalCDS.FieldByName('orderitem').AsInteger]),[]) then
      begin
        l_SalCDS.Edit;
        l_SalCDS.FieldByName('ok').AsBoolean:=true;
        l_SalCDS.Post;
      end;
      l_SalCDS.next;
    end;


    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;

    SetCCLStruct(l_SalCDS,l_OraDB,'pno','struct','ta_oeb04');

  finally
    tmpCDS.Free;
    l_SalCDS.EnableControls;
    CDS.Data:=l_SalCDS.Data;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR120.SetBtnEnabled(bool:Boolean);
begin
  btn_mpsr120A.Enabled:=bool;
  btn_mpsr120B.Enabled:=bool;
  btn_mpsr120C.Enabled:=bool;
end;

procedure TFrmMPSR120.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS(strFilter);

  inherited;
end;

procedure TFrmMPSR120.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR120';
  p_GridDesignAns:=True;
  l_SalCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS,l_Xml);

  inherited;

  l_isDG:=SameText(g_UInfo^.BU,'ITEQDG') or SameText(g_UInfo^.BU,'ITEQGZ');
end;

procedure TFrmMPSR120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SalCDS);
end;

//更新客戶庫存量及去掉尾碼的總庫存量
procedure TFrmMPSR120.btn_mpsr120AClick(Sender: TObject);
var
  tmpCRecNo,tmpBRecNo,tmpERecNo:Integer;   //當前、開始、結束
  qty1,qty2:Double;
  Data:OleVariant;
  tmpStr,tmpSQL:string;
  tmpCDS:TClientDataSet;
  dsNE1,dsNE2,dsNE3,dsNE4,dsNE5:TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!',48);
    Exit;
  end;

  tmpStr:=DBGridEh1.FieldColumns['qty1'].Title.Caption;
  if (Pos(g_Asc, tmpStr)>0) or (Pos(g_Desc, tmpStr)>0) then
  begin
    ShowMsg('請取消[庫存量]欄位排序標記,再執行此操作!',48);
    Exit;
  end;

  tmpCRecNo:=CDS.RecNo;
  case ShowMsg('更新全部請按[是]'+#13#10
              +'更新當前這筆請按[否]'+#13#10
              +'無操作請按[取消]',35) of
    IdNo: tmpCRecNo:=0;
    IdCancel: Exit;
  end;

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
  if tmpCRecNo<>0 then
     CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    //取庫別
    if (Length(l_img02All)=0) and (Length(l_img02Out)=0) then
    begin
      tmpSQL:='Select Depot,lst,fst From MPS330 Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And (lst=1 or fst=1)';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;
      with tmpCDS do
      while Not Eof do
      begin
        if Fields[1].AsBoolean then        //總庫存
           l_img02All:=l_img02All+','+Quotedstr(Fields[0].AsString);
        if Fields[2].AsBoolean then        //有效庫存
           l_img02Out:=l_img02Out+Fields[0].AsString+'/';
        Next;
      end;
      if (Length(l_img02All)=0) and (Length(l_img02Out)=0) then
      begin
        ShowMsg('MPS330無庫別,請確認!',48);
        Exit;
      end;
      Delete(l_img02All,1,1);
      l_img02All:=' And img02 in ('+l_img02All+')';
    end;
    //***

    while True do
    begin
      tmpSQL:='';
      tmpBRecNo:=CDS.RecNo;
      tmpERecNo:=tmpBRecNo;

      if tmpCRecNo=0 then
         tmpSQL:=' or img01 like '+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1)+'%')
      else
      begin
        while not CDS.Eof do
        begin
          tmpStr:=Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1);
          if Pos(tmpStr, tmpSQL)=0 then
             tmpSQL:=tmpSQL+' or img01 like '+Quotedstr(tmpStr+'%');
          tmpERecNo:=CDS.RecNo;
          if (tmpERecNo mod 50)=0 then  //每次取50筆料號查詢庫存
             Break;
          CDS.Next;
        end;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('正在處理'+inttostr(tmpBRecNo)+'...'+inttostr(tmpERecNo)+'筆');
      Application.ProcessMessages;
      Data:=null;            //img01_1去掉尾碼
      if l_isDG then
         tmpSQL:='Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1'
                +' From ITEQDG.img_file Where (img01=''@''' +tmpSQL+')'+l_img02All+' And img10>0'
                +' Union All'
                +' Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1'
                +' From ITEQGZ.img_file Where (img01=''@''' +tmpSQL+')'+l_img02All+' And img10>0'
      else
         tmpSQL:='Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1'
                +' From '+g_UInfo^.BU+'.img_file Where (img01=''@''' +tmpSQL+')'+l_img02All+' And img10>0';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount>0 then
           CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data:=Data;

      CDS.RecNo:=tmpBRecNo;
      while (tmpCRecNo=0) or ((CDS.RecNo<=tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1:=0;
        qty2:=0;
        with tmpCDS do
        begin
          Filtered:=False;
          Filter:='img01_1='+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1));
          Filtered:=True;
          while not Eof do
          begin
            if CDS.FieldByName('pno').AsString=Fields[0].AsString then
            if (SameText(Fields[3].AsString, CDS.FieldByName('custno').AsString) or
                SameText(Fields[3].AsString, CDS.FieldByName('custshort').AsString)) and
               (Pos(Fields[1].AsString, l_img02Out)>0) then
               qty1:=qty1+Fields[2].AsFloat;
            qty2:=qty2+Fields[2].AsFloat;
            Next;
          end;
        end;
        CDS.Edit;
        CDS.FieldByName('qty1').AsString:=FloatToStr(qty1)+'/'+FloatToStr(qty2);
        CDS.Post;
        if tmpCRecNo=0 then
           Break;
        CDS.Next;
      end;

      //退出while true
      if CDS.Eof or (tmpCRecNo=0) then
         Break;
    end;
    if CDS.ChangeCount>0 then
       CDS.MergeChangeLog;
    ShowMsg('更新完筆!', 64);

  finally
    tmpCDS.Free;
    if tmpCRecNo<>0 then
       CDS.RecNo:=tmpCRecNo;
    CDS.BeforeEdit:=dsNE1;
    CDS.AfterEdit:=dsNE2;
    CDS.BeforePost:=dsNE3;
    CDS.AfterPost:=dsNE4;
    CDS.AfterScroll:=dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

//更新客戶未交、料號未交(去尾碼)訂單數量
procedure TFrmMPSR120.btn_mpsr120BClick(Sender: TObject);
var
  tmpCRecNo,tmpBRecNo,tmpERecNo:Integer;   //當前、開始、結束
  qty1,qty2:Double;
  Data:OleVariant;
  tmpSQL:string;
  tmpStr:WideString;
  tmpCDS:TClientDataSet;
  dsNE1,dsNE2,dsNE3,dsNE4,dsNE5:TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!',48);
    Exit;
  end;

  tmpStr:=DBGridEh1.FieldColumns['qty2'].Title.Caption;
  if (Pos(g_Asc, tmpStr)>0) or (Pos(g_Desc, tmpStr)>0) then
  begin
    ShowMsg('請取消[未交數量]欄位排序標記,再執行此操作!',48);
    Exit;
  end;

  tmpStr:=DBGridEh1.FieldColumns['qty3'].Title.Caption;
  if (Pos(g_Asc, tmpStr)>0) or (Pos(g_Desc, tmpStr)>0) then
  begin
    ShowMsg('請取消[未交數量]欄位排序標記,再執行此操作!',48);
    Exit;
  end;

  tmpCRecNo:=CDS.RecNo;
  case ShowMsg('更新全部請按[是]'+#13#10
              +'更新當前這筆請按[否]'+#13#10
              +'無操作請按[取消]',35) of
    IdNo: tmpCRecNo:=0;
    IdCancel: Exit;
  end;

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
  if tmpCRecNo<>0 then
     CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    while True do
    begin
      tmpSQL:='';
      tmpBRecNo:=CDS.RecNo;
      tmpERecNo:=tmpBRecNo;

      if tmpCRecNo=0 then
         tmpSQL:=' or oeb04 like '+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1)+'%')
      else
      begin
        while not CDS.Eof do
        begin
          tmpStr:=Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1);
          if Pos(tmpStr, tmpSQL)=0 then
             tmpSQL:=tmpSQL+' or oeb04 like '+Quotedstr(tmpStr+'%');
          tmpERecNo:=CDS.RecNo;
          if (tmpERecNo mod 50)=0 then  //每次取50筆料號查詢庫存
             Break;
          CDS.Next;
        end;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('正在處理'+inttostr(tmpBRecNo)+'...'+inttostr(tmpERecNo)+'筆');
      Application.ProcessMessages;
      Data:=null;            //oeb04_1去掉尾碼
      if l_isDG then
         tmpSQL:=' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1'
                +' From ITEQDG.oea_file Inner Join ITEQDG.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y'''
                +' and oea04 not in (''N012'',''N005'') and substr(oea01,1,3) not in (''228'',''22B'')'
                +' and (oeb04=''@''' +tmpSQL+')'
                +' Union All'
                +' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1'
                +' From ITEQGZ.oea_file Inner Join ITEQGZ.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y'''
                +' and oea04 not in (''N012'',''N005'') and substr(oea01,1,3) not in (''228'',''22B'')'
                +' and (oeb04=''@''' +tmpSQL+')'
      else
         tmpSQL:=' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1'
                +' From '+g_UInfo^.BU+'.oea_file Inner Join '+g_UInfo^.BU+'.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y'''
                +' and substr(oea01,1,3) not in (''228'',''22B'')'
                +' and (oeb04=''@''' +tmpSQL+')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount>0 then
           CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data:=Data;

      CDS.RecNo:=tmpBRecNo;
      while (tmpCRecNo=0) or ((CDS.RecNo<=tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1:=0;
        qty2:=0;
        with tmpCDS do
        begin
          Filtered:=False;
          Filter:='oea04='+Quotedstr(CDS.FieldByName('custno').AsString)
                 +' and oeb04='+Quotedstr(CDS.FieldByName('pno').AsString);
          Filtered:=True;
          while not Eof do
          begin
            qty1:=qty1+Fields[2].AsFloat;
            Next;
          end;

          Filtered:=False;
          Filter:='oeb04_1='+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-1));
          Filtered:=True;
          while not Eof do
          begin
            qty2:=qty2+Fields[2].AsFloat;
            Next;
          end;
        end;
        CDS.Edit;
        CDS.FieldByName('qty2').AsFloat:=qty1;
        CDS.FieldByName('qty3').AsFloat:=qty2;
        CDS.Post;
        if tmpCRecNo=0 then
           Break;
        CDS.Next;
      end;

      //退出while true
      if CDS.Eof or (tmpCRecNo=0) then
         Break;
    end;
    if CDS.ChangeCount>0 then
       CDS.MergeChangeLog;
    ShowMsg('更新完筆!', 64);

  finally
    tmpCDS.Free;
    if tmpCRecNo<>0 then
       CDS.RecNo:=tmpCRecNo;
    CDS.BeforeEdit:=dsNE1;
    CDS.AfterEdit:=dsNE2;
    CDS.BeforePost:=dsNE3;
    CDS.AfterPost:=dsNE4;
    CDS.AfterScroll:=dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR120.btn_mpsr120CClick(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active then
     str:=CDS.FieldByName('pno').AsString;
  GetQueryStock(str, true);
end;

procedure TFrmMPSR120.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPSR120.DBGridEh1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[ssCtrl]) and (Key=70) then               //Ctrl+F 查找
  begin
    if not Assigned(FrmFind) then
       FrmFind:=TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS:=Self.CDS;
      g_Columns:=Self.DBGridEh1.Columns;
      g_DefFname:=Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname:='orderitem,longitude,latitude,orderqty,qty1,qty2,qty3';
    end;
    FrmFind.ShowModal;
    Key:=0; //DBGridEh自帶的查找
  end;
end;

procedure TFrmMPSR120.btn_queryClick(Sender: TObject);
var
  str:string;
begin
//  inherited;
  if not Assigned(FrmMPSR120_Query) then
     FrmMPSR120_Query:=TFrmMPSR120_Query.Create(Application);
  if FrmMPSR120_Query.ShowModal=mrOK then
  begin
    l_OraDB:=FrmMPSR120_Query.Rgp.Items.Strings[FrmMPSR120_Query.Rgp.ItemIndex];
    str:=' and q_oea02>='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmMPSR120_Query.Dtp1.Date),'-','/',[rfReplaceAll]))
        +' and q_oea02<='+Quotedstr(StringReplace(FormatDateTime(g_cShortDate1,FrmMPSR120_Query.Dtp2.Date),'-','/',[rfReplaceAll]));
    if Length(Trim(FrmMPSR120_Query.Edit2.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmMPSR120_Query.Edit2.Text)))+',oea01)>0';
    if Length(Trim(FrmMPSR120_Query.Edit1.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmMPSR120_Query.Edit1.Text)))+',oea04)>0';
    if Length(Trim(FrmMPSR120_Query.Edit3.Text))>0 then
       str:=str+' and instr('+Quotedstr(UpperCase(Trim(FrmMPSR120_Query.Edit3.Text)))+',substr(oeb04,2,1))>0';
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(str);
  end;
end;

procedure TFrmMPSR120.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.Active and (not CDS.FieldByName('ok').AsBoolean) then
    Background := $7280FA;
end;

end.
