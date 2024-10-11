unit unDLIR260;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Math;

type
  TFrmDLIR260 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
  private
    l_bu:string;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR260: TFrmDLIR260;

implementation

uses unGlobal, unCommon, unDLIR260_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sno" fieldtype="i4"/>'
           +'<FIELD attrname="ordernox" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitemx" fieldtype="i4"/>'
           +'<FIELD attrname="ordbu" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderdate" fieldtype="datetime" />'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="ordpno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="longitude" fieldtype="r8"/>'
           +'<FIELD attrname="latitude" fieldtype="r8"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ordqty" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="notqty" fieldtype="r8"/>'
           +'<FIELD attrname="c_date" fieldtype="datetime"/>'
           +'<FIELD attrname="c_orderno" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="c_pno" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="c_sizes" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="bu" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="place" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="area" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="stkqty" fieldtype="r8"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="custom" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="state" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="cpk" fieldtype="string" WIDTH="60"/>'
           +'<FIELD attrname="isselect" fieldtype="boolean"/>'
           +'<FIELD attrname="useqty" fieldtype="r8"/>'
           +'<FIELD attrname="err" fieldtype="boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIR260.RefreshDS(strFilter:string);
var
  isFst:Boolean;
  tmpSno:Integer;
  tmpQty:Double;
  tmpSQL,tmpPno:string;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  Data:OleVariant;
begin
  l_CDS.EmptyDataSet;
  try
    if strFilter=g_cFilterNothing then
       Exit;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢訂單資料');
    Application.ProcessMessages;
    tmpSQL:='select oea01,oea02,oea04,oea10,oeb03,oeb04,oeb05,oeb06,oeb11,oeb12,oeb15,'
           +' oeb24,ta_oeb01,ta_oeb02,ta_oeb10,occ02,ima021,oeb12-oeb24 as notqty'
           +' from '+l_bu+'.oea_file,'+l_bu+'.oeb_file,'+l_bu+'.occ_file,'+l_bu+'.ima_file'
           +' where oea01=oeb01 and oea04=occ01 and oeb04=ima01 '+strFilter
           +' and oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>0'
           +' and substr(oea01,1,3) not in (''226'',''22A'')'
           +' and substr(oeb04,length(oeb04),1)<>''0'''
           +' and substr(oeb04,1,1) in (''E'',''T'')'
           +' order by oea02,oea01,oeb03';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    tmpCDS3:=TClientDataSet.Create(nil);
    try
      tmpCDS1.Data:=Data;
      if tmpCDS1.IsEmpty then
         Exit;

      with tmpCDS1 do
      while not Eof do
      begin
        if Pos(FieldByName('oeb04').AsString, tmpPno)=0 then
           tmpPno:=tmpPno+','+Quotedstr(FieldByName('oeb04').AsString);
        Next;
      end;

      Delete(tmpPno,1,1);

      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢庫存資料');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:=' select * from (select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''ITEQDG'' as bu'
             +' from iteqdg.img_file where img01 in ('+tmpPno+') and img02 in (''Y0A00'',''N0A00'') and img10>0'
             +' union all'
             +' select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''ITEQDG'' as bu'
             +' from iteqgz.img_file where img01 in ('+tmpPno+') and img02 in (''Y0A00'',''N0A00'') and img10>0) t'
             +' order by bu,img01,substr(img04,2,4)';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;
      tmpCDS2.Data:=Data;

      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢已booking資料');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:='select * from dli602 where pno in ('+tmpPno+')';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS3.Data:=Data;

      g_StatusBar.Panels[0].Text:=CheckLang('正在計算');
      Application.ProcessMessages;
      tmpSno:=1;
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        //添加訂單
        l_CDS.Append;
        l_CDS.FieldByName('sno').AsInteger:=tmpSno;
        l_CDS.FieldByName('ordernox').AsString:=tmpCDS1.FieldByName('oea01').AsString;
        l_CDS.FieldByName('orderitemx').AsInteger:=tmpCDS1.FieldByName('oeb03').AsInteger;
        l_CDS.FieldByName('ordbu').AsString:=l_bu;
        l_CDS.FieldByName('orderdate').AsDateTime:=tmpCDS1.FieldByName('oea02').AsDateTime;
        l_CDS.FieldByName('orderno').AsString:=tmpCDS1.FieldByName('oea01').AsString;
        l_CDS.FieldByName('orderitem').AsInteger:=tmpCDS1.FieldByName('oeb03').AsInteger;
        l_CDS.FieldByName('custno').AsString:=tmpCDS1.FieldByName('oea04').AsString;
        l_CDS.FieldByName('custshort').AsString:=tmpCDS1.FieldByName('occ02').AsString;
        l_CDS.FieldByName('custshort').AsString:=tmpCDS1.FieldByName('occ02').AsString;
        l_CDS.FieldByName('ordpno').AsString:=tmpCDS1.FieldByName('oeb04').AsString;
        l_CDS.FieldByName('pname').AsString:=tmpCDS1.FieldByName('oeb06').AsString;
        l_CDS.FieldByName('sizes').AsString:=tmpCDS1.FieldByName('ima021').AsString;
        if not tmpCDS1.FieldByName('ta_oeb01').IsNull then
           l_CDS.FieldByName('longitude').AsFloat:=tmpCDS1.FieldByName('ta_oeb01').AsFloat;
        if not tmpCDS1.FieldByName('ta_oeb02').IsNull then
           l_CDS.FieldByName('latitude').AsFloat:=tmpCDS1.FieldByName('ta_oeb02').AsFloat;
        l_CDS.FieldByName('units').AsString:=tmpCDS1.FieldByName('oeb05').AsString;
        l_CDS.FieldByName('ordqty').AsFloat:=tmpCDS1.FieldByName('oeb12').AsFloat;
        l_CDS.FieldByName('outqty').AsFloat:=tmpCDS1.FieldByName('oeb24').AsFloat;
        l_CDS.FieldByName('notqty').AsFloat:=tmpCDS1.FieldByName('notqty').AsFloat;
        try
          l_CDS.FieldByName('c_date').AsDateTime:=tmpCDS1.FieldByName('oeb15').AsDateTime;
        except
          l_CDS.FieldByName('c_date').Clear;
        end;
        l_CDS.FieldByName('c_orderno').AsString:=tmpCDS1.FieldByName('oea10').AsString;
        l_CDS.FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('oeb11').AsString;
        l_CDS.FieldByName('c_sizes').AsString:=tmpCDS1.FieldByName('ta_oeb10').AsString;
        l_CDS.FieldByName('isselect').AsBoolean:=False;
        l_CDS.FieldByName('err').AsBoolean:=False;
        l_CDS.Post;

        //添加庫存
        isFst:=True;
        tmpCDS2.Filtered:=False;
        tmpCDS2.Filter:='img01='+Quotedstr(tmpCDS1.FieldByName('oeb04').AsString);
        tmpCDS2.Filtered:=True;
        while not tmpCDS2.Eof do
        begin
          //計算被其它訂單booking數量
          tmpCDS3.Filtered:=False;
          tmpCDS3.Filter:='bu='+Quotedstr(tmpCDS2.FieldByName('bu').AsString)
                         +' and pno='+Quotedstr(tmpCDS2.FieldByName('img01').AsString)
                         +' and place='+Quotedstr(tmpCDS2.FieldByName('img02').AsString)
                         +' and area='+Quotedstr(tmpCDS2.FieldByName('img03').AsString)
                         +' and lot='+Quotedstr(tmpCDS2.FieldByName('img04').AsString);
          tmpCDS3.Filtered:=True;
          tmpQty:=0;
          while not tmpCDS3.Eof do
          begin
            if not ((tmpCDS3.FieldByName('ordbu').AsString=l_bu) and
                    (tmpCDS3.FieldByName('orderno').AsString=tmpCDS1.FieldByName('oea01').AsString) and
                    (tmpCDS3.FieldByName('orderitem').AsInteger=tmpCDS1.FieldByName('oeb03').AsInteger)) then
               tmpQty:=tmpQty+tmpCDS3.FieldByName('qty').AsFloat;
            tmpCDS3.Next;
          end;

          tmpQty:=RoundTo(tmpCDS2.FieldByName('img10').AsFloat-tmpQty,-6);
          if tmpQty>0 then
          begin
            if not isFst then
            begin
              Inc(tmpSno);
              l_CDS.Append;
              l_CDS.FieldByName('sno').AsInteger:=tmpSno;
              l_CDS.FieldByName('ordernox').AsString:=tmpCDS1.FieldByName('oea01').AsString;
              l_CDS.FieldByName('orderitemx').AsInteger:=tmpCDS1.FieldByName('oeb03').AsInteger;
              l_CDS.Post;
            end;

            l_CDS.Edit;
            l_CDS.FieldByName('bu').AsString:=tmpCDS2.FieldByName('bu').AsString;
            l_CDS.FieldByName('pno').AsString:=tmpCDS2.FieldByName('img01').AsString;
            l_CDS.FieldByName('place').AsString:=tmpCDS2.FieldByName('img02').AsString;
            l_CDS.FieldByName('area').AsString:=tmpCDS2.FieldByName('img03').AsString;
            l_CDS.FieldByName('lot').AsString:=tmpCDS2.FieldByName('img04').AsString;
            l_CDS.FieldByName('stkqty').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
            l_CDS.FieldByName('qty').AsFloat:=tmpQty;
            l_CDS.FieldByName('custom').AsString:=tmpCDS2.FieldByName('ta_img03').AsString;
            l_CDS.FieldByName('state').AsString:=tmpCDS2.FieldByName('ta_img01').AsString;
            l_CDS.FieldByName('cpk').AsString:=tmpCDS2.FieldByName('ta_img04').AsString;
            l_CDS.FieldByName('isselect').AsBoolean:=False;
            l_CDS.FieldByName('err').AsBoolean:=False;

            //已booking,更新isselect、useqty
            tmpCDS3.Filtered:=False;
            tmpCDS3.Filter:='ordbu='+Quotedstr(l_bu)
                           +' and orderno='+Quotedstr(tmpCDS1.FieldByName('oea01').AsString)
                           +' and orderitem='+IntToStr(tmpCDS1.FieldByName('oeb03').AsInteger)
                           +' and bu='+Quotedstr(tmpCDS2.FieldByName('bu').AsString)
                           +' and pno='+Quotedstr(tmpCDS2.FieldByName('img01').AsString)
                           +' and place='+Quotedstr(tmpCDS2.FieldByName('img02').AsString)
                           +' and area='+Quotedstr(tmpCDS2.FieldByName('img03').AsString)
                           +' and lot='+Quotedstr(tmpCDS2.FieldByName('img04').AsString);
            tmpCDS3.Filtered:=True;
            if not tmpCDS3.IsEmpty then
            begin
              l_CDS.FieldByName('useqty').AsFloat:=tmpCDS3.FieldByName('qty').AsFloat;
              l_CDS.FieldByName('isselect').AsBoolean:=True;
              tmpCDS3.Edit;
              tmpCDS3.FieldByName('iuser').AsString:='1';   //更新booking標記為1
              tmpCDS3.Post;
            end;

            l_CDS.Post;
            isFst:=False;
          end;

          tmpCDS2.Next;
        end;

        //已booking,但庫存不存在了
        tmpCDS3.Filtered:=False;
        tmpCDS3.Filter:='ordbu='+Quotedstr(l_bu)
                       +' and orderno='+Quotedstr(tmpCDS1.FieldByName('oea01').AsString)
                       +' and orderitem='+IntToStr(tmpCDS1.FieldByName('oeb03').AsInteger)
                       +' and iuser<>''1''';
        tmpCDS3.Filtered:=True;
        while not tmpCDS3.Eof do
        begin
          if not isFst then
          begin
            Inc(tmpSno);
            l_CDS.Append;
            l_CDS.FieldByName('sno').AsInteger:=tmpSno;
            l_CDS.FieldByName('ordernox').AsString:=tmpCDS1.FieldByName('oea01').AsString;
            l_CDS.FieldByName('orderitemx').AsInteger:=tmpCDS1.FieldByName('oeb03').AsInteger;
            l_CDS.Post;
          end;

          l_CDS.Edit;
          l_CDS.FieldByName('bu').AsString:=tmpCDS3.FieldByName('bu').AsString;
          l_CDS.FieldByName('pno').AsString:=tmpCDS3.FieldByName('pno').AsString;
          l_CDS.FieldByName('place').AsString:=tmpCDS3.FieldByName('place').AsString;
          l_CDS.FieldByName('area').AsString:=tmpCDS3.FieldByName('area').AsString;
          l_CDS.FieldByName('lot').AsString:=tmpCDS3.FieldByName('lot').AsString;
          l_CDS.FieldByName('useqty').AsFloat:=tmpCDS3.FieldByName('qty').AsFloat;
          l_CDS.FieldByName('isselect').AsBoolean:=True;
          l_CDS.FieldByName('err').AsBoolean:=True;
          l_CDS.Post;
          isFst:=False;
          tmpCDS3.Next;
        end;

        tmpCDS1.Next;
      end;

    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      FreeAndNil(tmpCDS3);
    end;

  finally
    g_StatusBar.Panels[0].Text:='';
    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
    CDS.Data:=l_CDS.Data;
    inherited;
  end;
end;

procedure TFrmDLIR260.FormCreate(Sender: TObject);
begin
  p_SysId:='DLI';
  p_TableName:='DLIR260';
  p_GridDesignAns:=True;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_Xml);

  inherited;
end;

procedure TFrmDLIR260.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR260.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('err').AsBoolean then
     AFont.Color:=clSilver
  else
  if SameText(Column.FieldName,'useqty') then
  if CDS.FieldByName('qty').AsFloat<CDS.FieldByName('useqty').AsFloat then
     Background:=clRed;
end;

procedure TFrmDLIR260.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if SameText(Column.FieldName,'isselect') then
  if Length(CDS.FieldByName('bu').AsString)>0 then
  begin
    CDS.Edit;
    CDS.FieldByName('isselect').AsBoolean:=not CDS.FieldByName('isselect').AsBoolean;
    if CDS.FieldByName('isselect').AsBoolean then
       CDS.FieldByName('useqty').AsFloat:=CDS.FieldByName('qty').AsFloat
    else
       CDS.FieldByName('useqty').Clear;
    CDS.Post;
  end;
end;

procedure TFrmDLIR260.CDSBeforeInsert(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmDLIR260.CDSBeforeEdit(DataSet: TDataSet);
begin
  //inherited;
  if Length(CDS.FieldByName('bu').AsString)=0 then
     Abort;
end;

procedure TFrmDLIR260.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select * from dli602 where ordbu='+Quotedstr(l_bu)
         +' and orderno='+Quotedstr(CDS.FieldByName('ordernox').AsString)
         +' and orderitem='+IntToStr(CDS.FieldByName('orderitemx').AsInteger)
         +' and bu='+Quotedstr(CDS.FieldByName('bu').AsString)
         +' and pno='+Quotedstr(CDS.FieldByName('pno').AsString)
         +' and place='+Quotedstr(CDS.FieldByName('place').AsString)
         +' and area='+Quotedstr(CDS.FieldByName('area').AsString)
         +' and lot='+Quotedstr(CDS.FieldByName('lot').AsString);
  if not QueryBySQL(tmpSQL, Data) then
  begin
    CDS.CancelUpdates;
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if CDS.FieldByName('isselect').AsBoolean then
    begin
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('ordbu').AsString:=l_bu;
        tmpCDS.FieldByName('orderno').AsString:=CDS.FieldByName('ordernox').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger:=CDS.FieldByName('orderitemx').AsInteger;
        tmpCDS.FieldByName('bu').AsString:=CDS.FieldByName('bu').AsString;
        tmpCDS.FieldByName('pno').AsString:=CDS.FieldByName('pno').AsString;
        tmpCDS.FieldByName('place').AsString:=CDS.FieldByName('place').AsString;
        tmpCDS.FieldByName('area').AsString:=CDS.FieldByName('area').AsString;
        tmpCDS.FieldByName('lot').AsString:=CDS.FieldByName('lot').AsString;
        tmpCDS.FieldByName('qty').AsString:=CDS.FieldByName('useqty').AsString;
        tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime:=Now;
        tmpCDS.Post;
      end else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('qty').AsString:=CDS.FieldByName('useqty').AsString;
        tmpCDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime:=Now;
        tmpCDS.Post;
      end
    end else
    begin
      if not tmpCDS.IsEmpty then
         tmpCDS.Delete;
    end;

    if CDSPost(tmpCDS, 'dli602') then
       CDS.MergeChangeLog
    else
       CDS.CancelUpdates;     
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLIR260.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR260_query) then
     FrmDLIR260_query:=TFrmDLIR260_query.Create(Application);
  if FrmDLIR260_query.ShowModal=mrOK then
  begin
    l_bu:=FrmDLIR260_query.l_bu;
    RefreshDS(FrmDLIR260_query.l_sql);
  end;
end;

end.
