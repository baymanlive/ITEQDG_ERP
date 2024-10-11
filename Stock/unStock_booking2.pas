unit unStock_booking2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmStock_booking2 = class(TFrmSTDI051)
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
  FrmStock_booking2: TFrmStock_booking2;

implementation

uses unGlobal, unCommon;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="img01" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="img02" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="img03" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="img04" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="img10" fieldtype="r8"/>'
           +'<FIELD attrname="ta_img01" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="ta_img03" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="ta_img04" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="ta_img05" fieldtype="string" WIDTH="100"/>'
           +'<FIELD attrname="bookingqty" fieldtype="r8"/>'
           +'<FIELD attrname="dbtype" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="err" fieldtype="boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmStock_booking2.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'MPST040');
end;

procedure TFrmStock_booking2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmStock_booking2.FormShow(Sender: TObject);
var
  tmpSQL,dgsql,gzsql:string;
  Data:OleVariant;
  tmpCDS0,tmpCDS1,tmpCDS2:TClientDataSet;
begin
  inherited;
  DBGridEh1.ReadOnly:=not l_edit;

  tmpSQL:='select * from dli603'
         +' where ordbu='+Quotedstr(l_SalCDS.FieldByName('dbtype').AsString)
         +' and orderno='+Quotedstr(l_SalCDS.FieldByName('oea01').AsString)
         +' and orderitem='+IntToStr(l_SalCDS.FieldByName('oeb03').AsInteger);
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
      if SameText(FieldByName('bu').AsString,'DG') then
         dgsql:=dgsql+' or (img01='+Quotedstr(FieldByName('pno').AsString)
                     +' and img02='+Quotedstr(FieldByName('place').AsString)
                     +' and img03='+Quotedstr(FieldByName('area').AsString)
                     +' and img04='+Quotedstr(FieldByName('lot').AsString)+')'
      else
         gzsql:=gzsql+' or (img01='+Quotedstr(FieldByName('pno').AsString)
                     +' and img02='+Quotedstr(FieldByName('place').AsString)
                     +' and img03='+Quotedstr(FieldByName('area').AsString)
                     +' and img04='+Quotedstr(FieldByName('lot').AsString)+')';

      Next;
    end;

    if Length(dgsql)>0 then
    begin
      Delete(dgsql,1,4);
      dgsql:='select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''DG'' dbtype'
            +' from iteqdg.img_file where 1=1 and ('+dgsql+')';
    end;

    if Length(gzsql)>0 then
    begin
      Delete(gzsql,1,4);
      gzsql:='select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''GZ'' dbtype'
            +' from iteqdg.img_file where 1=1 and ('+gzsql+')';
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
          FieldByName('dbtype').AsString:=tmpCDS1.FieldByName('bu').AsString;
          FieldByName('img01').AsString:=tmpCDS1.FieldByName('pno').AsString;
          FieldByName('img02').AsString:=tmpCDS1.FieldByName('place').AsString;
          FieldByName('img03').AsString:=tmpCDS1.FieldByName('area').AsString;
          FieldByName('img04').AsString:=tmpCDS1.FieldByName('lot').AsString;
          FieldByName('bookingqty').AsFloat:=tmpCDS1.FieldByName('qty').AsFloat;
          FieldByName('err').AsBoolean:=True;
          if tmpCDS2.Locate('dbtype;img01;img02;img03;img04',VarArrayOf([
              FieldByName('dbtype').AsString,
              FieldByName('img01').AsString,
              FieldByName('img02').AsString,
              FieldByName('img03').AsString,
              FieldByName('img04').AsString]),[]) then
          begin
            FieldByName('ta_img01').AsString:=tmpCDS2.FieldByName('ta_img01').AsString;
            FieldByName('ta_img03').AsString:=tmpCDS2.FieldByName('ta_img03').AsString;
            FieldByName('ta_img04').AsString:=tmpCDS2.FieldByName('ta_img04').AsString;
            FieldByName('ta_img05').AsString:=tmpCDS2.FieldByName('ta_img05').AsString;
            FieldByName('img10').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
            FieldByName('err').AsBoolean:=tmpCDS2.FieldByName('img10').AsFloat<=0;
          end;
          Post;
        end;
        tmpCDS1.Next;
      end;

      if tmpCDS0.ChangeCount>0  then
         tmpCDS0.MergeChangeLog;
      CDS.AfterScroll:=nil;
      CDS.Data:=tmpCDS0.Data;
      CDS.IndexFieldNames:='dbtype;img01;img02;img03;img04';
      CDS.AfterScroll:=CDSAfterScroll;
      CDS.AfterScroll(CDS);
    end;

  finally
    FreeAndNil(tmpCDS0);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmStock_booking2.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  CDS.MergeChangeLog;

  tmpSQL:='select * from dli603'
         +' where bu='+Quotedstr(CDS.FieldByName('dbtype').AsString)
         +' and pno='+Quotedstr(CDS.FieldByName('img01').AsString)
         +' and place='+Quotedstr(CDS.FieldByName('img02').AsString)
         +' and area='+Quotedstr(CDS.FieldByName('img03').AsString)
         +' and lot='+Quotedstr(CDS.FieldByName('img04').AsString)
         +' and ordbu='+Quotedstr(l_SalCDS.FieldByName('dbtype').AsString)
         +' and orderno='+Quotedstr(l_SalCDS.FieldByName('oea01').AsString)
         +' and orderitem='+IntToStr(l_SalCDS.FieldByName('oeb03').AsInteger);
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
        tmpCDS.FieldByName('bu').AsString:=CDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('pno').AsString:=CDS.FieldByName('img01').AsString;
        tmpCDS.FieldByName('place').AsString:=CDS.FieldByName('img02').AsString;
        tmpCDS.FieldByName('area').AsString:=CDS.FieldByName('img03').AsString;
        tmpCDS.FieldByName('lot').AsString:=CDS.FieldByName('img04').AsString;
        tmpCDS.FieldByName('qty').AsFloat:=CDS.FieldByName('bookingqty').AsFloat;
        tmpCDS.FieldByName('ordbu').AsString:=l_SalCDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('orderno').AsString:=l_SalCDS.FieldByName('oea01').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger:=l_SalCDS.FieldByName('oeb03').AsInteger;
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
           +' where bu='+Quotedstr(CDS.FieldByName('dbtype').AsString)
           +' and pno='+Quotedstr(CDS.FieldByName('img01').AsString)
           +' and place='+Quotedstr(CDS.FieldByName('img02').AsString)
           +' and area='+Quotedstr(CDS.FieldByName('img03').AsString)
           +' and lot='+Quotedstr(CDS.FieldByName('img04').AsString)
           +' group by bu,pno,place,area,lot'
           +' union all'
           +' select ''B'' as ftype,sum(qty) qty from dli603'
           +' where ordbu='+Quotedstr(l_SalCDS.FieldByName('dbtype').AsString)
           +' and orderno='+Quotedstr(l_SalCDS.FieldByName('oea01').AsString)
           +' and orderitem='+IntToStr(l_SalCDS.FieldByName('oeb03').AsInteger)
           +' group by ordbu,orderno,orderitem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;

    with l_StkCDS do
    begin
      DisableControls;
      if Locate('dbtype;img01;img02;img03;img04',VarArrayOf([
          CDS.FieldByName('dbtype').AsString,
          CDS.FieldByName('img01').AsString,
          CDS.FieldByName('img02').AsString,
          CDS.FieldByName('img03').AsString,
          CDS.FieldByName('img04').AsString]),[]) then
      begin
        Edit;
        FieldByName('bookingqty').Clear;
        if tmpCDS.Locate('ftype','A',[]) then
        if tmpCDS.FieldByName('qty').AsFloat<>0 then
           FieldByName('bookingqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
        Post;
        MergeChangeLog;
      end;
      EnableControls;
    end;

    with l_SalCDS do
    begin
      Edit;
      FieldByName('bookingqty').Clear;
      if tmpCDS.Locate('ftype','B',[]) then
      if tmpCDS.FieldByName('qty').AsFloat<>0 then
         FieldByName('bookingqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
      Post;
      MergeChangeLog;
    end;

  finally
    FreeAndNil(tmpCDS);
    l_StkCDS.EnableControls;
  end;
end;

procedure TFrmStock_booking2.CDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if CDS.FieldByName('bookingqty').AsFloat<0 then
  begin
    ShowMsg('Booking數量不能小于0',48);
    Abort;
  end;
end;

procedure TFrmStock_booking2.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  l_StkCDS.Locate('dbtype;img01;img02;img03;img04',VarArrayOf([
    CDS.FieldByName('dbtype').AsString,
    CDS.FieldByName('img01').AsString,
    CDS.FieldByName('img02').AsString,
    CDS.FieldByName('img03').AsString,
    CDS.FieldByName('img04').AsString]),[])
end;

procedure TFrmStock_booking2.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmStock_booking2.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not l_edit then
     Abort;
end;

procedure TFrmStock_booking2.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('err').AsBoolean then
     AFont.Color:=clGray;
end;

end.
