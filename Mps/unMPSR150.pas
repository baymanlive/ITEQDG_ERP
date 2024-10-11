{*******************************************************}
{                                                       }
{                unMPSR150                              }
{                Author: kaikai                         }
{                Create date: 2018/3/20                 }
{                Description: 小PNL每日達交量           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR150;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, DateUtils, StrUtils, unMPS_IcoFlag;

type
  TFrmMPSR150 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    TabSheet30: TTabSheet;
    DBGridEh3: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    DBGridEh2: TDBGridEh;
    TabSheet40: TTabSheet;
    DBGridEh4: TDBGridEh;
    CDS4: TClientDataSet;
    DS4: TDataSource;
    TabSheet50: TTabSheet;
    DBGridEh5: TDBGridEh;
    CDS5: TClientDataSet;
    DS5: TDataSource;
    TabSheet60: TTabSheet;
    DBGridEh6: TDBGridEh;
    CDS6: TClientDataSet;
    DS6: TDataSource;
    CDS7: TClientDataSet;
    DS7: TDataSource;
    DBGridEh7: TDBGridEh;
    ImageList2: TImageList;
    btn_mpsr150A: TToolButton;
    btn_mpsr150B: TToolButton;
    btn_mpsr150C: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDS4AfterPost(DataSet: TDataSet);
    procedure CDS5AfterPost(DataSet: TDataSet);
    procedure CDS4BeforePost(DataSet: TDataSet);
    procedure CDS5BeforePost(DataSet: TDataSet);
    procedure DBGridEh4DblClick(Sender: TObject);
    procedure DBGridEh5DblClick(Sender: TObject);
    procedure CDS4BeforeInsert(DataSet: TDataSet);
    procedure CDS5BeforeInsert(DataSet: TDataSet);
    procedure CDS4BeforeEdit(DataSet: TDataSet);
    procedure CDS5BeforeEdit(DataSet: TDataSet);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh7DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn_mpsr150AClick(Sender: TObject);
    procedure btn_mpsr150BClick(Sender: TObject);
    procedure btn_mpsr150CClick(Sender: TObject);
  private
    { Private declarations }
    l_Img: TBitmap;
    l_img02:string;
    l_CDS1,l_CDS2,l_CDS3,l_CDS4,l_CDS5:TClientDataSet;
    l_MPS_IcoFlag:TMPS_IcoFlag;
    procedure GetDS(bu:string);
    procedure GetDS6(pno:string);
    procedure GetDS7(pno,orderno,orderitem:string);
    procedure SetAdate_new(xCDS:TClientDataSet);
    procedure UpdateMPSRemark(isCCL:Boolean);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR150: TFrmMPSR150;

implementation

uses unGlobal, unCommon, unMPSR150_XlsSelect;

const l_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="adate" fieldtype="datetime"/>'
            +'<FIELD attrname="cclqty" fieldtype="r8"/>'
            +'<FIELD attrname="cclgyqty" fieldtype="r8"/>'   //CCL打鋼印
            +'<FIELD attrname="cclcnt" fieldtype="i4"/>'
            +'<FIELD attrname="ppqty" fieldtype="r8"/>'
            +'<FIELD attrname="ppzkqty" fieldtype="r8"/>'    //PP鉆孔
            +'<FIELD attrname="ppcnt" fieldtype="i4"/>'
            +'<FIELD attrname="tot" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const l_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="30"/>'
            +'<FIELD attrname="cclqty" fieldtype="r8"/>'
            +'<FIELD attrname="ppqty" fieldtype="r8"/>'
            +'<FIELD attrname="tot" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const l_Xml3='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="bu" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderitem" fieldtype="i4"/>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="30"/>'
            +'<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>'
            +'<FIELD attrname="pnlsize1" fieldtype="r8"/>'
            +'<FIELD attrname="pnlsize2" fieldtype="r8"/>'
            +'<FIELD attrname="adate" fieldtype="datetime"/>'
            +'<FIELD attrname="stime" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="outqty" fieldtype="r8"/>'
            +'<FIELD attrname="wono_date" fieldtype="DateTime"/>'
            +'<FIELD attrname="wono" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="sqty" fieldtype="r8"/>'                         //生產數量
            +'<FIELD attrname="cqty" fieldtype="r8"/>'                         //完工數量
            +'<FIELD attrname="state" fieldtype="string" WIDTH="20"/>'         //工單狀態
            +'<FIELD attrname="zk" fieldtype="string" WIDTH="10"/>'            //鉆孔否
            +'<FIELD attrname="gy" fieldtype="string" WIDTH="10"/>'            //鋼印否
            +'<FIELD attrname="adate_new" fieldtype="DateTime"/>'              //新交期
            +'<FIELD attrname="mpsremark" fieldtype="string" WIDTH="200"/>'    //生產狀況
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_gyCustno='AC093,AC082,AC405,AC075,AC311,AC310,AC950,AC178,US005,EZ001,AC707';

{$R *.dfm}

procedure TFrmMPSR150.GetDS(bu:string);
var
  isCCL:Boolean;
  tmpOutQty,tmpRemainQty:Double;
  tmpSQL,tmpOrderno:string;
  i,tmpOrderitem:Integer;
  tmpCDS1,tmpCDS2,tmpCDSSTime:TClientDataSet;
  Data1,Data2:OleVariant;

  procedure AddData(DataSet:TClientDataSet);
  begin
    with DataSet do
    begin
      if Locate('adate',tmpCDS1.FieldByName('adate').AsDateTime,[]) then
         Edit
      else begin
        Append;
        FieldByName('adate').AsDateTime:=tmpCDS1.FieldByName('adate').AsDateTime;
      end;

      if isCCL then
      begin
        FieldByName('cclqty').AsFloat:=FieldByName('cclqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
        FieldByName('cclcnt').AsInteger:=FieldByName('cclcnt').AsInteger+1;
        if Pos(tmpCDS1.FieldByName('custno').AsString,g_gyCustno)>0 then
           FieldByName('cclgyqty').AsFloat:=FieldByName('cclgyqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
      end else
      begin
        FieldByName('ppqty').AsFloat:=FieldByName('ppqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
        FieldByName('ppcnt').AsInteger:=FieldByName('ppcnt').AsInteger+1;
        if tmpCDS1.FieldByName('zk').AsInteger=1 then
           FieldByName('ppzkqty').AsFloat:=FieldByName('ppzkqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
      end;

      FieldByName('tot').AsFloat:=FieldByName('cclqty').AsFloat+FieldByName('ppqty').AsFloat;
      Post;
    end;
  end;

  function GetStime(Custno:string):string;
  begin
    Result:='';
    with tmpCDSSTime do
    begin
      First;
      while not Eof do
      begin
        if Pos(Custno,FieldByName('custno').AsString)>0 then
        begin
          Result:=FormatDateTime('HH:NN',FieldByName('stime').AsDateTime);
          Break;
        end;
        Next;
      end;
    end;
  end;

begin
  g_StatusBar.Panels[0].Text:='正在查詢資料,請等待...';
  Application.ProcessMessages;
  try
    tmpSQL:='exec [dbo].[proc_MPSR150] '+Quotedstr(bu);
    if not QueryBySQL(tmpSQL, Data1) then
       Exit;

    tmpSQL:='select custno,stime from mps290 where Bu='+Quotedstr(bu);
    if not QueryBySQL(tmpSQL, Data2) then
       Exit;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    tmpCDSSTime:=TClientDataSet.Create(nil);
    try
      tmpCDSSTime.Data:=Data2;   //切貨時間

      //正常數據
      tmpCDS1.Data:=Data1;

      //拆多筆,達交量>未交量
      tmpCDS2.Data:=Data1;
      tmpCDS2.Filtered:=False;
      tmpCDS2.Filter:='flag=1';
      tmpCDS2.Filtered:=True;
      tmpCDS2.IndexFieldNames:='orderno;orderitem;adate';
      if not tmpCDS2.IsEmpty then
      begin
        tmpOrderno:=tmpCDS2.FieldByName('orderno').AsString;
        tmpOrderitem:=tmpCDS2.FieldByName('orderitem').AsInteger;
        tmpRemainQty:=tmpCDS2.FieldByName('remainqty').AsFloat;
        while not tmpCDS2.Eof do
        begin
          if (tmpRemainQty>0) and (tmpOrderno=tmpCDS2.FieldByName('orderno').AsString) and
             (tmpOrderitem=tmpCDS2.FieldByName('orderitem').AsInteger) then
          begin
            if tmpRemainQty>=tmpCDS2.FieldByName('outqty').AsFloat then
               tmpOutQty:=tmpCDS2.FieldByName('outqty').AsFloat
            else
               tmpOutQty:=tmpRemainQty;

            if tmpOutQty>0 then
            begin
              tmpCDS1.Append;
              for i:=0 to tmpCDS1.FieldCount-1 do
                tmpCDS1.Fields[i].Value:=tmpCDS2.Fields[i].Value;
              tmpCDS1.FieldByName('outqty').AsFloat:=tmpOutQty;
              tmpCDS1.FieldByName('flag').AsInteger:=0;
              tmpCDS1.Post;
            end;

            tmpRemainQty:=tmpRemainQty-tmpOutQty;
          end;

          tmpCDS2.Next;

          if (tmpOrderno<>tmpCDS2.FieldByName('orderno').AsString) or
             (tmpOrderitem<>tmpCDS2.FieldByName('orderitem').AsInteger) then
          begin
            tmpOrderno:=tmpCDS2.FieldByName('orderno').AsString;
            tmpOrderitem:=tmpCDS2.FieldByName('orderitem').AsInteger;
            tmpRemainQty:=tmpCDS2.FieldByName('remainqty').AsFloat;
          end;
        end;
      end;

      tmpCDS1.Filtered:=False;
      tmpCDS1.Filter:='flag=0';
      tmpCDS1.Filtered:=True;
      tmpCDS1.IndexFieldNames:='adate';
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        isCCL:=Pos(LeftStr(tmpCDS1.FieldByName('pno').AsString,1),'ET')>0;

        if not isCCL then  //pp全部在dg
           AddData(l_CDS1)
        else if SameText(RightStr(tmpCDS1.FieldByName('pno').AsString,1),'G') then  //ccl尾碼G全部在gz
           AddData(l_CDS2)
        else
           AddData(l_CDS1);

        with l_CDS3 do
        begin
          if Locate('custno',tmpCDS1.FieldByName('custno').AsString,[]) then
             Edit
          else begin
            Append;
            FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
            FieldByName('custshort').AsString:=tmpCDS1.FieldByName('custshort').AsString;
          end;
          if isCCL then
             FieldByName('cclqty').AsFloat:=FieldByName('cclqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat
          else
             FieldByName('ppqty').AsFloat:=FieldByName('ppqty').AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
          FieldByName('tot').AsFloat:=FieldByName('cclqty').AsFloat+FieldByName('ppqty').AsFloat;
        end;

        if isCCL then
        begin
          with l_CDS4 do
          begin
            Append;
            for i:=0 to FieldCount-1 do
              if tmpCDS1.FindField(Fields[i].FieldName)<>nil then
                 Fields[i].Value:=tmpCDS1.FieldByName(Fields[i].FieldName).Value;
            FieldByName('bu').AsString:=bu;
            FieldByName('stime').AsString:=GetStime(tmpCDS1.FieldByName('custno').AsString);
            if Pos(tmpCDS1.FieldByName('custno').AsString,g_gyCustno)>0 then
               FieldByName('gy').AsString:='Yes'
            else
               FieldByName('gy').AsString:='No';
            Post;
          end;
        end else
        begin
          with l_CDS5 do
          begin
            Append;
            for i:=0 to FieldCount-1 do
              if tmpCDS1.FindField(Fields[i].FieldName)<>nil then
                 Fields[i].Value:=tmpCDS1.FieldByName(Fields[i].FieldName).Value;
            FieldByName('bu').AsString:=bu;
            FieldByName('stime').AsString:=GetStime(tmpCDS1.FieldByName('custno').AsString);
            if tmpCDS1.FieldByName('zk').AsInteger=1 then
               FieldByName('zk').AsString:='Yes'
            else
               FieldByName('zk').AsString:='No';
            Post;
          end;
        end;

        tmpCDS1.Next;
      end;

      if l_CDS1.ChangeCount>0 then
         l_CDS1.MergeChangeLog;
      if l_CDS2.ChangeCount>0 then
         l_CDS2.MergeChangeLog;
      if l_CDS3.ChangeCount>0 then
         l_CDS3.MergeChangeLog;
      if l_CDS4.ChangeCount>0 then
         l_CDS4.MergeChangeLog;
      if l_CDS5.ChangeCount>0 then
         l_CDS5.MergeChangeLog;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      FreeAndNil(tmpCDSSTime);
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR150.GetDS6(pno:string);
const fstCode='ETBRPQMN';
var
  i:Integer;
  Data:OleVariant;
  tmpStr:WideString;
  tmpSQL,tmpImgFilter:string;
  tmpCDS:TClientDataSet;
begin
  //取庫別
  tmpCDS:=TClientDataSet.Create(nil);
  try
    if Length(l_img02)=0 then
    begin
      tmpSQL:='Select Depot From MPS330 Where sst=1 And Bu='+Quotedstr(g_UInfo^.BU);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS.Data:=Data;
      with tmpCDS do
      while Not Eof do
      begin
        l_img02:=l_img02+','+Quotedstr(Fields[0].AsString);
        Next;
      end;
      if Length(l_img02)=0 then
      begin
        ShowMsg('MPS330無庫別,請確認!',48);
        Exit;
      end;
      Delete(l_img02,1,1);
      l_img02:=' And img02 in ('+l_img02+')';
    end;
    //***

    tmpStr:=pno;
    Delete(tmpStr,1,1);
    for i:=1 to Length(fstCode) do
       tmpImgFilter:=tmpImgFilter+' or img01 Like '+Quotedstr(fstCode[i]+tmpStr+'%');

    Data:=null;
    tmpSQL:='Select img01,img02,img03,img04,img10,ta_img03,ta_img04,ta_img05,''DG'' dbtype'
           +' From ITEQDG.img_file Where (img01=''@''' +tmpImgFilter+')'+l_img02
           +' And img10>0'
           +' Union All'
           +' Select img01,img02,img03,img04,img10,ta_img03,ta_img04,ta_img05,''GZ'' as dbtype'
           +' From ITEQGZ.img_file Where (img01=''@''' +tmpImgFilter+')'+l_img02
           +' And img10>0'
           +' Order By img01,img02,img03,img04';
    if QueryBySQL(tmpSQL, Data, 'ORACLE') then
       CDS6.Data:=Data;

  finally
     FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR150.GetDS7(pno,orderno,orderitem:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if Pos(LeftStr(pno,1),'ET')>0 then
     tmpSQL:='1'
  else
     tmpSQL:='0';
  tmpSQL:='exec dbo.proc_MPST030_3 '+Quotedstr(g_UInfo^.BU)+','+
                                     Quotedstr(orderno)+','+orderitem+',1,'+tmpSQL;
  if QueryBySQL(tmpSQL, Data) then
  begin
    if not Assigned(l_MPS_IcoFlag) then
       l_MPS_IcoFlag:=TMPS_IcoFlag.Create;
    l_MPS_IcoFlag.Data:=Data;
    CDS7.Data:=l_MPS_IcoFlag.Data;
  end;
end;

procedure TFrmMPSR150.SetAdate_new(xCDS:TClientDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  tmpSQL:='select * from mps201 where bu='+Quotedstr(xCDS.FieldByName('bu').AsString)
         +' and orderno='+Quotedstr(xCDS.FieldByName('orderno').AsString)
         +' and orderitem='+IntToStr(xCDS.FieldByName('orderitem').AsInteger);
  if not QueryBySQL(tmpSQL, Data) then
  begin
    if xCDS.ChangeCount>0 then
       xCDS.CancelUpdates;
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if xCDS.FieldByName('adate_new').IsNull then
    begin
      if not tmpCDS.IsEmpty then
      begin
        tmpCDS.Delete;
        if not CDSPost(tmpCDS, 'MPS201') then
        begin
          if xCDS.ChangeCount>0 then
             xCDS.CancelUpdates;
        end;
      end;
    end else
    begin
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString:=xCDS.FieldByName('bu').AsString;
        tmpCDS.FieldByName('orderno').AsString:=xCDS.FieldByName('orderno').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger:=xCDS.FieldByName('orderitem').AsInteger;
        tmpCDS.FieldByName('pno').AsString:=xCDS.FieldByName('pno').AsString;
        tmpCDS.FieldByName('qty').AsInteger:=xCDS.FieldByName('outqty').AsInteger;
      end else
         tmpCDS.Edit;
      tmpCDS.FieldByName('adate').AsDateTime:=xCDS.FieldByName('adate_new').AsDateTime;
      tmpCDS.Post;
      if not CDSPost(tmpCDS, 'MPS201') then
      begin
        if xCDS.ChangeCount>0 then
           xCDS.CancelUpdates;
      end;
    end;

    if xCDS.ChangeCount>0 then
       xCDS.MergeChangeLog;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR150.RefreshDS(strFilter: string);
begin
  inherited;
end;

procedure TFrmMPSR150.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR150_1';
  p_GridDesignAns:=False;
  l_CDS1:=TClientDataSet.Create(Self);
  l_CDS2:=TClientDataSet.Create(Self);
  l_CDS3:=TClientDataSet.Create(Self);
  l_CDS4:=TClientDataSet.Create(Self);
  l_CDS5:=TClientDataSet.Create(Self);
  InitCDS(l_CDS1, l_Xml1);
  InitCDS(l_CDS2, l_Xml1);
  InitCDS(l_CDS3, l_Xml2);
  InitCDS(l_CDS4, l_Xml3);
  InitCDS(l_CDS5, l_Xml3);
  btn_quit.Left:=btn_mpsr150C.Left+btn_mpsr150C.Width;

  inherited;

  TabSheet1.Caption:=CheckLang('DG資料');
  TabSheet20.Caption:=CheckLang('GZ資料');
  TabSheet30.Caption:=CheckLang('客戶分布');
  TabSheet40.Caption:=CheckLang('CCL明細資料');
  TabSheet50.Caption:=CheckLang('PP明細資料');
  TabSheet60.Caption:=CheckLang('庫存與在製狀況');
  SetGrdCaption(DBGridEh2, 'MPSR150_1');
  SetGrdCaption(DBGridEh3, 'MPSR150_2');
  SetGrdCaption(DBGridEh4, 'MPSR150_3');
  SetGrdCaption(DBGridEh5, 'MPSR150_3');
  SetGrdCaption(DBGridEh6, 'MPST040');
  SetGrdCaption(DBGridEh7, 'MPSR020');
  CDS.Data:=l_CDS1.Data;
  CDS2.Data:=l_CDS2.Data;
  CDS3.Data:=l_CDS3.Data;
  CDS4.Data:=l_CDS4.Data;
  CDS5.Data:=l_CDS5.Data;
  CDS4.IndexFieldNames:='adate;stime;custno;orderno;orderitem';
  CDS5.IndexFieldNames:=CDS4.IndexFieldNames;
  l_Img:=TBitmap.Create;
end;

procedure TFrmMPSR150.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CDS4.State in [dsInsert,dsEdit] then
  begin
    CDS4.Cancel;
    if CDS4.ChangeCount>0 then
       CDS4.CancelUpdates;
    Action:=caNone;
    Exit;
  end;

  if CDS5.State in [dsInsert,dsEdit] then
  begin
     CDS5.Cancel;
     if CDS4.ChangeCount>0 then
        CDS4.CancelUpdates;
     Action:=caNone;
     Exit;
  end;

  inherited;

  CDS2.Active:=False;
  CDS3.Active:=False;
  CDS4.Active:=False;
  CDS5.Active:=False;
  CDS6.Active:=False;
  CDS7.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
  DBGridEh5.Free;
  DBGridEh6.Free;
  DBGridEh7.Free;
  if Assigned(l_MPS_IcoFlag) then
     FreeAndNil(l_MPS_IcoFlag);
  FreeAndNil(l_Img);   
end;

procedure TFrmMPSR150.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
  FreeAndNil(l_CDS3);
  FreeAndNil(l_CDS4);
  FreeAndNil(l_CDS5);
end;

procedure TFrmMPSR150.btn_exportClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR150_XlsSelect) then
  begin
    FrmMPSR150_XlsSelect:=TFrmMPSR150_XlsSelect.Create(Application);
    FrmMPSR150_XlsSelect.rb1.Caption:=TabSheet1.Caption;
    FrmMPSR150_XlsSelect.rb2.Caption:=TabSheet20.Caption;
    FrmMPSR150_XlsSelect.rb3.Caption:=TabSheet30.Caption;
    FrmMPSR150_XlsSelect.rb4.Caption:=TabSheet40.Caption;
    FrmMPSR150_XlsSelect.rb5.Caption:=TabSheet50.Caption;
  end;

  if FrmMPSR150_XlsSelect.ShowModal=mrOK then
  begin
    if FrmMPSR150_XlsSelect.rb1.Checked then
       GetExportXls(CDS, 'MPSR150_1')
    else if FrmMPSR150_XlsSelect.rb2.Checked then
       GetExportXls(CDS2, 'MPSR150_1')
    else if FrmMPSR150_XlsSelect.rb3.Checked then
       GetExportXls(CDS3, 'MPSR150_2')
    else if FrmMPSR150_XlsSelect.rb4.Checked then
       GetExportXls(CDS4, 'MPSR150_3')
    else if FrmMPSR150_XlsSelect.rb5.Checked then
       GetExportXls(CDS5, 'MPSR150_3')
  end;
end;

procedure TFrmMPSR150.btn_queryClick(Sender: TObject);
begin
//  inherited;
  l_CDS1.EmptyDataSet;
  l_CDS2.EmptyDataSet;
  l_CDS3.EmptyDataSet;
  l_CDS4.EmptyDataSet;
  l_CDS5.EmptyDataSet;
  GetDS('ITEQDG');
  GetDS('ITEQGZ');
  CDS.Data:=l_CDS1.Data;
  CDS2.Data:=l_CDS2.Data;
  CDS3.Data:=l_CDS3.Data;
  CDS4.Data:=l_CDS4.Data;
  CDS5.Data:=l_CDS5.Data;
  RefreshDS('');
end;

procedure TFrmMPSR150.CDS4BeforePost(DataSet: TDataSet);
begin
  inherited;
  if (not DataSet.FieldByName('adate_new').IsNull) and
     (DataSet.FieldByName('adate_new').AsDateTime<Date) then
  begin
    ShowMsg('請設定新交期>當天',48);
    if DBGridEh4.CanFocus then
       DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=DataSet.FieldByName('adate_new');    
    Abort;
  end;
end;

procedure TFrmMPSR150.CDS5BeforePost(DataSet: TDataSet);
begin
  inherited;
  if (not DataSet.FieldByName('adate_new').IsNull) and
     (DataSet.FieldByName('adate_new').AsDateTime<Date) then
  begin
    ShowMsg('請設定新交期>當天',48);
    if DBGridEh4.CanFocus then
       DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=DataSet.FieldByName('adate_new');
    Abort;
  end;
end;

procedure TFrmMPSR150.CDS4BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPSR150.CDS5BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPSR150.CDS4BeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmMPSR150.CDS5BeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmMPSR150.CDS4AfterPost(DataSet: TDataSet);
begin
  inherited;
  SetAdate_new(CDS4);
end;

procedure TFrmMPSR150.CDS5AfterPost(DataSet: TDataSet);
begin
  inherited;
  SetAdate_new(CDS5);
end;

procedure TFrmMPSR150.DBGridEh4DblClick(Sender: TObject);
begin
  inherited;
  if CDS4.IsEmpty then
     Exit;
  GetDS6(CDS4.FieldByName('pno').AsString);
  GetDS7(CDS4.FieldByName('pno').AsString,CDS4.FieldByName('orderno').AsString,CDS4.FieldByName('orderitem').AsString);
  PCL.ActivePageIndex:=PCL.PageCount-1;
end;

procedure TFrmMPSR150.DBGridEh5DblClick(Sender: TObject);
begin
  inherited;
  if CDS5.IsEmpty then
     Exit;
  GetDS6(CDS5.FieldByName('pno').AsString);
  GetDS7(CDS5.FieldByName('pno').AsString,CDS5.FieldByName('orderno').AsString,CDS5.FieldByName('orderitem').AsString);
  PCL.ActivePageIndex:=PCL.PageCount-1;
end;

procedure TFrmMPSR150.DBGridEh7DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  P:TPoint;
  fName:string;
begin
  inherited;
  if (not CDS7.Active) or CDS7.IsEmpty then
     Exit;

  fName:=LowerCase(Column.FieldName);
  if Pos('/'+fName+'/', '/s1/s2/s3/s4/s5/s6/s7/')>0 then
  begin
    ImageList2.GetBitmap(CDS7.FieldByName(fName+'_ico').AsInteger, l_Img);
    with DBGridEh7.Canvas do
    begin
      FillRect(Rect);
      P.X:=round((Rect.Left+Rect.Right-l_Img.Width)/2)-10;
      P.Y:=round((Rect.Top+Rect.Bottom-l_Img.Height)/2);
      Draw(P.X, P.Y, l_Img);
      TextOut(P.X+l_Img.Width+2, P.Y+2, CDS7.FieldByName(fName).AsString);
    end;
  end;
end;

procedure TFrmMPSR150.btn_mpsr150AClick(Sender: TObject);
var
  str:string;
begin
  inherited;
  case PCL.ActivePageIndex of
    3:if CDS4.Active then str:=Copy(CDS4.FieldByName('pno').AsString,1,Length(CDS4.FieldByName('pno').AsString)-3);
    4:if CDS5.Active then str:='B'+Copy(CDS5.FieldByName('pno').AsString,2,Length(CDS5.FieldByName('pno').AsString)-3);
  end;
  GetQueryStock(str, true);
end;

procedure TFrmMPSR150.btn_mpsr150BClick(Sender: TObject);
begin
  inherited;
  if (not CDS4.Active) or CDS4.IsEmpty then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  if ShowMsg('確定更新嗎?',33)=IdCancel then
     Exit;

  UpdateMPSRemark(True);
end;

procedure TFrmMPSR150.btn_mpsr150CClick(Sender: TObject);
begin
  inherited;
  if (not CDS5.Active) or CDS5.IsEmpty then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  if ShowMsg('確定更新嗎?',33)=IdCancel then
     Exit;
       
  UpdateMPSRemark(False);
end;

procedure TFrmMPSR150.UpdateMPSRemark(isCCL:Boolean);
var
  i:Integer;
  Data:OleVariant;
  tmpSQL:string;
  SrcCDS,tmpCDS:TClientDataSet;
  dsNE1,dsNE2,dsNE3,dsNE4,dsNE5:TDataSetNotifyEvent;
begin
  inherited;
  if isCCL then
     SrcCDS:=CDS4
  else
     SrcCDS:=CDS5;
     
  dsNE1:=SrcCDS.BeforeEdit;
  dsNE2:=SrcCDS.AfterEdit;
  dsNE3:=SrcCDS.BeforePost;
  dsNE4:=SrcCDS.AfterPost;
  dsNE5:=SrcCDS.AfterScroll;
  SrcCDS.BeforeEdit:=nil;
  SrcCDS.AfterEdit:=nil;
  SrcCDS.BeforePost:=nil;
  SrcCDS.AfterPost:=nil;
  SrcCDS.AfterScroll:=nil;
  SrcCDS.DisableControls;
  SrcCDS.First;
  if isCCL then
     DBGridEh4.Enabled:=False
  else
     DBGridEh5.Enabled:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    while not SrcCDS.Eof do
    begin
      g_StatusBar.Panels[0].Text:='正在更新['+IntToStr(SrcCDS.RecNo)+']筆';
      Application.ProcessMessages;

      if isCCL then
         tmpSQL:='1'
      else
         tmpSQL:='0';
      Data:=null;
      tmpSQL:='exec dbo.proc_MPST030_3 '+Quotedstr(SrcCDS.FieldByName('bu').AsString)+','+
                                         Quotedstr(SrcCDS.FieldByName('orderno').AsString)+','+
                                         IntToStr(SrcCDS.FieldByName('orderitem').AsInteger)+',1,'+tmpSQL;
      if not QueryBySQL(tmpSQL, Data) then
      begin
        if SrcCDS.ChangeCount>0 then
           SrcCDS.CancelUpdates;
        Exit;
      end;

      tmpCDS.Data:=Data;
      i:=1;
      tmpSQL:='';
      with tmpCDS do
      while not Eof do
      begin
        tmpSQL:=Trim(FieldByName('wono').AsString+' '+
                IntToStr(MonthOf(FieldByName('sdate').AsDateTime))+'/'+
                IntToStr(DayOf(FieldByName('sdate').AsDateTime))+' '+
                FieldByName('machine').AsString+'-'+
                FieldByName('sqty').AsString);
        if isCCL then
           tmpSQL:=tmpSQL+' '+FieldByName('currentboiler').AsString+CheckLang('鍋');
        Inc(i);
        if i>3 then
           Break;
        Next;
      end;
      SrcCDS.Edit;
      SrcCDS.FieldByName('mpsremark').AsString:=tmpSQL;
      SrcCDS.Post;
      SrcCDS.Next;
    end;

    if SrcCDS.ChangeCount>0 then
       SrcCDS.MergeChangeLog;
    ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS);
    SrcCDS.BeforeEdit:=dsNE1;
    SrcCDS.AfterEdit:=dsNE2;
    SrcCDS.BeforePost:=dsNE3;
    SrcCDS.AfterPost:=dsNE4;
    SrcCDS.AfterScroll:=dsNE5;
    SrcCDS.EnableControls;
    if isCCL then
       DBGridEh4.Enabled:=True
    else
       DBGridEh5.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
