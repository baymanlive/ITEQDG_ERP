unit unMPSR190;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI032, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmMPSR190 = class(TFrmSTDI032)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR190: TFrmMPSR190;

implementation

uses unGlobal, unCommon, unMPSR190_query;

{$R *.dfm}

procedure TFrmMPSR190.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From dli010 Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData) //g_CocData:coc匯入的資料
         +' And IsNull(GarbageFlag,0)=0'
         +' And Len(IsNull(Dno_Ditem,''''))=0';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Sno'
  else
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Custno,Units,right(Pno,1),Pno,Orderno,Orderitem,Sno';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSR190.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='DLI010';
  p_GridDesignAns:=True;
  btn_insert.Visible:=False;
  btn_delete.Visible:=False;
  btn_copy.Visible:=False;

  inherited;
end;

procedure TFrmMPSR190.CDSBeforeInsert(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmMPSR190.CDSBeforeDelete(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmMPSR190.CDSAfterPost(DataSet: TDataSet);
begin
  PostBySQLFromDelta(CDS, 'dli010', 'Bu,Dno,Ditem');
  inherited;
end;

procedure TFrmMPSR190.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  {
  if not Assigned(FrmMPSR190_query) then
     FrmMPSR190_query:=TFrmMPSR190_query.Create(Application);
  if FrmMPSR190_query.ShowModal=mrOK then
     RefreshDS(' and indate='+Quotedstr(DateToStr(FrmMPSR190_query.MonthCalendar1.Date)));
  }

  if GetQueryString(p_TableName, tmpStr) then
  begin
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount1,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    if Pos('Qry_ppccl', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
    if Pos('Qry_isbz', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate='+Quotedstr(DateToStr(Date));
    RefreshDS(tmpStr);
  end;
end;

end.
