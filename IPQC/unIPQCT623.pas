unit unIPQCT623;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmIPQCT623 = class(TFrmSTDI041)
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    Splitter1: TSplitter;
    btn_garbage: TToolButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_garbageClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_sql2:string;
    l_list2:TStrings;
    procedure RefreshDS2;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmIPQCT623: TFrmIPQCT623;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

//sg2:5組中取樣時間最新一組平均值
procedure TFrmIPQCT623.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select ad,ver,lot,qty,'
         +' round((isnull(sg1_value1,0)+isnull(sg1_value2,0)+isnull(sg1_value3,0))/3,2) as sg1,sg1_std,'
         +' case (select top 1 b from(select sg2_atime as a,1 as b union all select sg2_btime,2'
         +'       union all select sg2_ctime,3 union all select sg2_dtime,4 union all select sg2_etime,5) o order by a desc)'
         +'	when 1 then round((isnull(sg2_avalue1,0)+isnull(sg2_avalue2,0)+isnull(sg2_avalue3,0))/3,2)'
         +' when 2 then round((isnull(sg2_bvalue1,0)+isnull(sg2_bvalue2,0)+isnull(sg2_bvalue3,0))/3,2)'
         +' when 3 then round((isnull(sg2_cvalue1,0)+isnull(sg2_cvalue2,0)+isnull(sg2_cvalue3,0))/3,2)'
         +' when 4 then round((isnull(sg2_dvalue1,0)+isnull(sg2_dvalue2,0)+isnull(sg2_dvalue3,0))/3,2)'
         +' when 5 then round((isnull(sg2_evalue1,0)+isnull(sg2_evalue2,0)+isnull(sg2_evalue3,0))/3,2) else 0 end as sg2,'
         +' sg2_astd as sg2_std,'
         +' round((isnull(sg3_value1,0)+isnull(sg3_value2,0)+isnull(sg3_value3,0))/3,2) as sg3,sg3_std,'
         +' niandu,ludaiqty,c13_1,c13_2,c13_3,spos,spos_time,temperature,remainlot,addqty,addsg,'
         +' t1,t1_time,t2,t2_time,t3,t3_time,t4,t4_time,garbageflag'
         +' From IPQC620 Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter+' order by idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  if CDS.Active and CDS.IsEmpty then
     RefreshDS2;

  if g_MInfo^.R_garbage then
     btn_garbage.Enabled:=CDS.Active and (not CDS.IsEmpty) and (not (CDS.State in [dsInsert, dsEdit]));

  inherited;
end;

procedure TFrmIPQCT623.RefreshDS2;
var
  tmpSQL:string;
begin
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='Select * From IPQC621'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Ad='+Quotedstr(CDS.FieldByName('Ad').AsString)
         +' And Ver='+Quotedstr(CDS.FieldByName('Ver').AsString)
         +' And Lot='+Quotedstr(CDS.FieldByName('Lot').AsString)
         +' Order By Sno';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmIPQCT623.FormCreate(Sender: TObject);
begin
  p_SysId:='ipqc';
  p_TableName:='FrmIPQCT623';
  p_GridDesignAns:=True;
  btn_garbage.Visible:=g_MInfo^.R_garbage;
  if g_MInfo^.R_garbage then
     btn_garbage.Left:=btn_print.Left;

  inherited;

  SetGrdCaption(DBGridEh2, 'ipqc621');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmIPQCT623.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_list2);
end;

procedure TFrmIPQCT623.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  SetLength(ArrPrintData, 2);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS.Filter;
  ArrPrintData[1].Data:=CDS2.Data;
  ArrPrintData[1].RecNo:=CDS2.RecNo;
  ArrPrintData[1].IndexFieldNames:=CDS2.IndexFieldNames;
  ArrPrintData[1].Filter:=CDS2.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmIPQCT623.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS2;
end;

procedure TFrmIPQCT623.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    if Length(tmpStr)=0 then
       tmpStr:=' and idate>getdate()-180 and isnull(garbageflag,0)=0';
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmIPQCT623.btn_garbageClick(Sender: TObject);
var
  tmpSQL:string;
begin
  inherited;
  with CDS do
  begin
    if (not Active) or IsEmpty then
    begin
      ShowMsg('無數據,不可操作!',48);
      Exit;
    end;

    if FieldByName('garbageflag').AsBoolean then
       tmpSQL:='0'
    else
       tmpSQL:='1';
    tmpSQL:='update ipqc620 set garbageflag='+tmpSQL
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and ad='+Quotedstr(CDS.FieldByName('ad').AsString)
           +' and ver='+Quotedstr(CDS.FieldByName('ver').AsString)
           +' and lot='+Quotedstr(CDS.FieldByName('lot').AsString);
    if PostBySQL(tmpSQL) then
    begin
      Edit;
      FieldByName('garbageflag').AsBoolean:=not FieldByName('garbageflag').AsBoolean;
      Post;
      MergeChangeLog;
    end;
  end;
end;

procedure TFrmIPQCT623.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if CDS.FieldByName('garbageflag').AsBoolean then
     AFont.Color:=clRed
end;

procedure TFrmIPQCT623.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
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
       CDS2.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
