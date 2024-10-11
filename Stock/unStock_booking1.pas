unit unStock_booking1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmStock_booking1 = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DataSource1: TDataSource;
    CDS: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
  public
    l_edit:Boolean;
    l_StkCDS,l_SalCDS:TClientDataSet;
    { Public declarations }
  end;

var
  FrmStock_booking1: TFrmStock_booking1;

implementation

uses unGlobal, unCommon;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="oea01" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="oea04" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="oeb03" fieldtype="i4"/>'
           +'<FIELD attrname="oeb04" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="oeb05" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ta_oeb01" fieldtype="r8"/>'
           +'<FIELD attrname="ta_oeb02" fieldtype="r8"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="bookingqty" fieldtype="r8"/>'
           +'<FIELD attrname="dbtype" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="occ02" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="err" fieldtype="boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmStock_booking1.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'MPST040');
end;

procedure TFrmStock_booking1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmStock_booking1.FormShow(Sender: TObject);
var
  tmpSQL,dgsql,gzsql:string;
  Data:OleVariant;
  tmpCDS0,tmpCDS1,tmpCDS2:TClientDataSet;
begin
  inherited;
  DBGridEh1.ReadOnly:=not l_edit;

  tmpSQL:='select * from dli603'
         +' where bu='+Quotedstr(l_StkCDS.FieldByName('dbtype').AsString)
         +' and pno='+Quotedstr(l_StkCDS.FieldByName('img01').AsString)
         +' and place='+Quotedstr(l_StkCDS.FieldByName('img02').AsString)
         +' and area='+Quotedstr(l_StkCDS.FieldByName('img03').AsString)
         +' and lot='+Quotedstr(l_StkCDS.FieldByName('img04').AsString);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS0:=TClientDataSet.Create(nil);
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
       Exit;

    with tmpCDS1 do
    while not Eof do
    begin
      if SameText(FieldByName('ordbu').AsString,'DG') then
         dgsql:=dgsql+' or (oea01='+Quotedstr(FieldByName('orderno').AsString)
                     +' and oeb03='+Quotedstr(FieldByName('orderitem').AsString)+')'
      else
         gzsql:=gzsql+' or (oea01='+Quotedstr(FieldByName('orderno').AsString)
                     +' and oeb03='+Quotedstr(FieldByName('orderitem').AsString)+')';

      Next;
    end;

    if Length(dgsql)>0 then
    begin
      Delete(dgsql,1,4);
      dgsql:='select x.*,occ02,''DG'' dbtype from (select oea01,oea04,oeb03,'
            +' oeb04,oeb05,ta_oeb01,ta_oeb02,oeb12-oeb24 qty,nvl(oeb70,''N'') oeb70'
            +' from iteqdg.oea_file,iteqdg.oeb_file'
            +' where oea01=oeb01 and ('+dgsql+')) x,iteqdg.occ_file where oea04=occ01';
    end;

    if Length(gzsql)>0 then
    begin
      Delete(gzsql,1,4);
      gzsql:='select y.*,occ02,''GZ'' dbtype from (select oea01,oea04,oeb03,'
            +' oeb04,oeb05,ta_oeb01,ta_oeb02,oeb12-oeb24 qty,nvl(oeb70,''N'') oeb70'
            +' from iteqgz.oea_file,iteqgz.oeb_file'
            +' where oea01=oeb01 and ('+gzsql+')) y,iteqgz.occ_file where oea04=occ01';
    end;

    tmpSQL:='';
    if (Length(dgsql)>0) and (Length(gzsql)>0) then
       tmpSQL:=dgsql+' union all '+gzsql
    else if Length(dgsql)>0 then
       tmpSQL:=dgsql
    else if Length(gzsql)>0 then
       tmpSQL:=gzsql;

    if Length(tmpSQL)>0 then
    begin    
      Data:=null;
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;

      tmpCDS2.Data:=Data;
      if tmpCDS2.IsEmpty then
         Exit;

      InitCDS(tmpCDS0,l_XML);
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        with tmpCDS0 do
        begin
          Append;
          FieldByName('dbtype').AsString:=tmpCDS1.FieldByName('ordbu').AsString;
          FieldByName('oea01').AsString:=tmpCDS1.FieldByName('orderno').AsString;
          FieldByName('oeb03').AsInteger:=tmpCDS1.FieldByName('orderitem').AsInteger;
          FieldByName('bookingqty').AsFloat:=tmpCDS1.FieldByName('qty').AsFloat;
          FieldByName('err').AsBoolean:=True;
          if tmpCDS2.Locate('dbtype;oea01;oeb03',VarArrayOf([
              FieldByName('dbtype').AsString,
              FieldByName('oea01').AsString,
              FieldByName('oeb03').AsInteger]),[]) then
          begin
            FieldByName('oea04').AsString:=tmpCDS2.FieldByName('oea04').AsString;
            FieldByName('occ02').AsString:=tmpCDS2.FieldByName('occ02').AsString;
            FieldByName('oeb04').AsString:=tmpCDS2.FieldByName('oeb04').AsString;
            FieldByName('oeb05').AsString:=tmpCDS2.FieldByName('oeb05').AsString;
            FieldByName('ta_oeb01').Value:=tmpCDS2.FieldByName('ta_oeb01').Value;
            FieldByName('ta_oeb02').Value:=tmpCDS2.FieldByName('ta_oeb02').Value;
            FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('qty').AsFloat;
            FieldByName('err').AsBoolean:=(tmpCDS2.FieldByName('qty').AsFloat<=0) or SameText(tmpCDS2.FieldByName('oeb70').AsString,'Y');
          end;
          Post;
        end;
        tmpCDS1.Next;
      end;

      if tmpCDS0.ChangeCount>0  then
         tmpCDS0.MergeChangeLog;
      CDS.AfterScroll:=nil;
      CDS.Data:=tmpCDS0.Data;
      CDS.IndexFieldNames:='dbtype;oeb04;oea04;oea01;oeb03';
      CDS.AfterScroll:=CDSAfterScroll;
      CDS.AfterScroll(CDS);
    end;

  finally
    FreeAndNil(tmpCDS0);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmStock_booking1.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  CDS.MergeChangeLog;

  tmpSQL:='select * from dli603'
         +' where bu='+Quotedstr(l_StkCDS.FieldByName('dbtype').AsString)
         +' and pno='+Quotedstr(l_StkCDS.FieldByName('img01').AsString)
         +' and place='+Quotedstr(l_StkCDS.FieldByName('img02').AsString)
         +' and area='+Quotedstr(l_StkCDS.FieldByName('img03').AsString)
         +' and lot='+Quotedstr(l_StkCDS.FieldByName('img04').AsString)
         +' and ordbu='+Quotedstr(CDS.FieldByName('dbtype').AsString)
         +' and orderno='+Quotedstr(CDS.FieldByName('oea01').AsString)
         +' and orderitem='+IntToStr(CDS.FieldByName('oeb03').AsInteger);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if CDS.FieldByName('bookingqty').AsFloat>0 then
    begin
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString:=l_StkCDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('pno').AsString:=l_StkCDS.FieldByName('img01').AsString;
        tmpCDS.FieldByName('place').AsString:=l_StkCDS.FieldByName('img02').AsString;
        tmpCDS.FieldByName('area').AsString:=l_StkCDS.FieldByName('img03').AsString;
        tmpCDS.FieldByName('lot').AsString:=l_StkCDS.FieldByName('img04').AsString;
        tmpCDS.FieldByName('qty').AsFloat:=CDS.FieldByName('bookingqty').AsFloat;
        tmpCDS.FieldByName('ordbu').AsString:=CDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('orderno').AsString:=CDS.FieldByName('oea01').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger:=CDS.FieldByName('oeb03').AsInteger;
        tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime:=Now;
        tmpCDS.Post;
      end else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('qty').AsFloat:=CDS.FieldByName('bookingqty').AsFloat;
        tmpCDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime:=Now;
        tmpCDS.Post;
      end
    end else
    begin
      if not tmpCDS.IsEmpty then
         tmpCDS.Delete;
    end;

    if not CDSPost(tmpCDS, 'dli603') then
       Exit;

    //刷新欄位
    Data:=null;
    tmpSQL:='select ''A'' as ftype,sum(qty) qty from dli603'
           +' where bu='+Quotedstr(l_StkCDS.FieldByName('dbtype').AsString)
           +' and pno='+Quotedstr(l_StkCDS.FieldByName('img01').AsString)
           +' and place='+Quotedstr(l_StkCDS.FieldByName('img02').AsString)
           +' and area='+Quotedstr(l_StkCDS.FieldByName('img03').AsString)
           +' and lot='+Quotedstr(l_StkCDS.FieldByName('img04').AsString)
           +' group by bu,pno,place,area,lot'
           +' union all'
           +' select ''B'' as ftype,sum(qty) qty from dli603'
           +' where ordbu='+Quotedstr(CDS.FieldByName('dbtype').AsString)
           +' and orderno='+Quotedstr(CDS.FieldByName('oea01').AsString)
           +' and orderitem='+IntToStr(CDS.FieldByName('oeb03').AsInteger)
           +' group by ordbu,orderno,orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;

    with l_StkCDS do
    begin
      Edit;
      FieldByName('bookingqty').Clear;
      if tmpCDS.Locate('ftype','A',[]) then
      if tmpCDS.FieldByName('qty').AsFloat<>0 then
         FieldByName('bookingqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
      Post;
      MergeChangeLog;
    end;

    with l_SalCDS do
    begin
      DisableControls;
      if Locate('dbtype;oea01;oeb03',VarArrayOf([
          CDS.FieldByName('dbtype').AsString,
          CDS.FieldByName('oea01').AsString,
          CDS.FieldByName('oeb03').AsInteger]),[]) then
      begin
        Edit;
        FieldByName('bookingqty').Clear;
        if tmpCDS.Locate('ftype','B',[]) then
        if tmpCDS.FieldByName('qty').AsFloat<>0 then
           FieldByName('bookingqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
        Post;
        MergeChangeLog;
      end;
      EnableControls;
    end;

  finally
    FreeAndNil(tmpCDS);
    l_SalCDS.EnableControls;
  end;
end;

procedure TFrmStock_booking1.CDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if CDS.FieldByName('bookingqty').AsFloat<0 then
  begin
    ShowMsg('Booking數量不能小于0',48);
    Abort;
  end;
end;

procedure TFrmStock_booking1.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  l_SalCDS.Locate('dbtype;oea01;oeb03',VarArrayOf([
    CDS.FieldByName('dbtype').AsString,
    CDS.FieldByName('oea01').AsString,
    CDS.FieldByName('oeb03').AsInteger]),[])
end;

procedure TFrmStock_booking1.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmStock_booking1.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not l_edit then
     Abort;
end;

procedure TFrmStock_booking1.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('err').AsBoolean then
     AFont.Color:=clGray;
end;

end.
