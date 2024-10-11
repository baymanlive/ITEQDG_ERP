unit unIPQCT500;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI060, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, Menus, DB, ImgList, ExtCtrls, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

type
  TFrmIPQCT500 = class(TFrmSTDI060)
    btn_ipqc500A: TBitBtn;
    btn_ipqc500B: TBitBtn;
    btn_ipqc500C: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btn_ipqc500AClick(Sender: TObject);
    procedure btn_ipqc500CClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure btn_ipqc500BClick(Sender: TObject);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    l_dno,l_sql2:string;
    l_ditem:Integer;
    l_list2:TStrings;
    function Check501:Boolean;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS1(strFilter:string); override;
    procedure RefreshDS2; override;
  end;

var
  FrmIPQCT500: TFrmIPQCT500;

implementation

uses unGlobal, unCommon, unIPQCT500_mps, unIPQCT500_sdate,
  unIPQCT500_forecast, unIPQCT500_selectpno;

{$R *.dfm}

function TFrmIPQCT500.Check501:Boolean;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Result:=False;
  tmpSQL:='Select Top 1 Bu From IPQC501 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
         +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger);
  if not QueryOneCR(tmpSQL, Data) then
     Abort;
  if Length(VarToStr(Data))>0 then
  begin
    ShowMsg('已開始備料,不可異動!', 48);
    Result:=True;
  end;
end;

procedure TFrmIPQCT500.RefreshDS1(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if Length(strFilter)=0 then
     tmpSQL:=' And Sdate='+Quotedstr(DateToStr(Date))
  else
     tmpSQL:=strFilter;
  tmpSQL:='Select * From IPQC500 Where Bu='+Quotedstr(g_UInfo^.Bu)+tmpSQL
         +' Order By Sdate,Fiber,Breadth,Vendor,Pno';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmIPQCT500.RefreshDS2;
var
  tmpSQL:string;
begin
  if Assigned(l_list2) then
  begin
    tmpSQL:='Select * From IPQC501 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
           +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger);
    l_list2.Insert(0,tmpSQL);
  end;

  inherited;
end;

procedure TFrmIPQCT500.FormCreate(Sender: TObject);
begin
  p_SysId:='IPQC';
  p_MainTableName:='IPQC500';
  p_DetailTableName:='IPQC501';
  p_GridDesignAns1:=True;
  p_GridDesignAns2:=True;
  p_EditFlag:=mainEdit;
  p_Grd2PosFlag:=isBottom;
  p_GridAnchors:=mainAnchors;

  inherited;

  if (not g_MInfo^.R_new) or (not g_MInfo^.R_edit) or (p_EditFlag in [noEdit, detailEdit]) then
     DBGridEh1.FieldColumns['Pno'].ButtonStyle:=cbsAuto;
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmIPQCT500.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
end;

procedure TFrmIPQCT500.btn_deleteClick(Sender: TObject);
begin
  if CDS.Active and (Length(CDS.FieldByName('Cno').AsString)>0) then
  begin
    ShowMsg('已產生調撥單,不可刪除!', 48);
    Exit;
  end;

  if Check501 then
     Abort;
  inherited;
end;

procedure TFrmIPQCT500.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('Cno').Clear;
    FieldByName('Iuser').AsString:=g_UInfo^.UserId;
    FieldByName('Idate').AsDateTime:=Now;
    FieldByName('Conf').AsBoolean:=False;
  end;
end;

procedure TFrmIPQCT500.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('Dno').AsString:=CDS.FieldByName('Dno').AsString;
    FieldByName('Ditem').AsInteger:=CDS.FieldByName('Ditem').AsInteger;
    FieldByName('Iuser').AsString:=g_UInfo^.UserId;
    FieldByName('Idate').AsDateTime:=Now;
  end;
end;

procedure TFrmIPQCT500.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fname:string);
  begin
    ShowMsg('請輸入[%s]', 48, MyStringReplace(DBGridEh1.FieldColumns[fname].Title.Caption));
    if DBGridEh1.CanFocus then
       DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=DataSet.FieldByName(fname);
    Abort;
  end;
begin
  if Length(Trim(DataSet.FieldByName('pno').AsString))<>10 then
     ShowM('pno');
  if DataSet.FieldByName('qty').AsFloat<=0 then
     ShowM('qty');
  if DataSet.State in [dsInsert] then
  begin
    DataSet.FieldByName('Dno').AsString:=GetSno(g_MInfo^.ProcId);
    DataSet.FieldByName('Ditem').AsInteger:=1;
  end;
  inherited;
end;

procedure TFrmIPQCT500.CDS2BeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;

  procedure ShowM(fname:string);
  begin
    ShowMsg('請輸入[%s]', 48, MyStringReplace(DBGridEh2.FieldColumns[fname].Title.Caption));
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName(fname);
    Abort;
  end;

begin
  if Length(Trim(DataSet.FieldByName('pno').AsString))<>10 then
     ShowM('pno');
  if Length(Trim(DataSet.FieldByName('stkplace').AsString))=0 then
     ShowM('stkplace');
  if Length(Trim(DataSet.FieldByName('stkarea').AsString))=0 then
     ShowM('stkarea');
  if Length(Trim(DataSet.FieldByName('manfac').AsString))=0 then
     ShowM('manfac');
  if DataSet.FieldByName('qty').AsFloat<=0 then
     ShowM('qty');
  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Sno),0)+1 Sno From IPQC501'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
           +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    DataSet.FieldByName('Sno').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;
  inherited;
end;

procedure TFrmIPQCT500.CDSBeforeEdit(DataSet: TDataSet);
begin
  if Length(CDS.FieldByName('Cno').AsString)>0 then
  begin
    ShowMsg('已產生調撥單,不可更改!',48);
    Abort;
  end;

  if Check501 then
     Abort;

  inherited;
end;

procedure TFrmIPQCT500.CDS2BeforeEdit(DataSet: TDataSet);
begin
  if Length(CDS.FieldByName('Cno').AsString)>0 then
  begin
    ShowMsg('已產生調撥單,不可更改!',48);
    Abort;
  end;
  inherited;
end;

procedure TFrmIPQCT500.CDS2BeforeInsert(DataSet: TDataSet);
begin
  if Length(CDS.FieldByName('Cno').AsString)>0 then
  begin
    ShowMsg('已產生調撥單,不可更改!',48);
    Abort;
  end;
  inherited;
end;

procedure TFrmIPQCT500.CDSBeforeDelete(DataSet: TDataSet);
begin
  l_dno:=CDS.FieldByName('dno').AsString;
  l_ditem:=CDS.FieldByName('ditem').AsInteger;
  inherited;
end;

procedure TFrmIPQCT500.CDSAfterDelete(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if (l_dno<>CDS.FieldByName('dno').AsString) or
     (l_ditem<>CDS.FieldByName('ditem').AsInteger) then
  begin
    tmpSQL:='Delete From IPQC501 Where Bu='+Quotedstr(g_UInfo^.Bu)
           +' And Dno='+Quotedstr(l_dno)
           +' And Ditem='+IntToStr(l_ditem);
    if not PostBySQL(tmpSQL) then
       ShowMsg('刪除明細資料失敗,請聯絡管理員!', 48);
  end;
end;

procedure TFrmIPQCT500.btn_ipqc500AClick(Sender: TObject);
begin
  inherited;
  FrmIPQCT500_sdate:=TFrmIPQCT500_sdate.Create(nil);
  try
    FrmIPQCT500_sdate.ShowModal;
  finally
    FreeAndNil(FrmIPQCT500_sdate);
  end;
end;

procedure TFrmIPQCT500.btn_ipqc500BClick(Sender: TObject);
begin
  inherited;
  FrmIPQCT500_forecast:=TFrmIPQCT500_forecast.Create(nil);
  try
    FrmIPQCT500_forecast.ShowModal;
  finally
    FreeAndNil(FrmIPQCT500_forecast);
  end;
end;

procedure TFrmIPQCT500.btn_ipqc500CClick(Sender: TObject);
begin
  inherited;
  FrmIPQCT500_mps:=TFrmIPQCT500_mps.Create(nil);
  try
    FrmIPQCT500_mps.ShowModal;
  finally
    FreeAndNil(FrmIPQCT500_mps);
  end;
end;

procedure TFrmIPQCT500.DBGridEh1EditButtonClick(Sender: TObject);
begin
  inherited;
  if Length(CDS.FieldByName('Cno').AsString)>0 then
  begin
    ShowMsg('已產生調撥單,不可更改!',48);
    Abort;
  end;

  FrmIPQCT500_selectpno:=TFrmIPQCT500_selectpno.Create(nil);
  try
    FrmIPQCT500_selectpno.l_fiber:=CDS.FieldByName('Fiber').AsString;
    FrmIPQCT500_selectpno.l_breadth:=CDS.FieldByName('Breadth').AsString;
    FrmIPQCT500_selectpno.l_vendor:=CDS.FieldByName('Vendor').AsString;
    if FrmIPQCT500_selectpno.ShowModal=mrOK then
    begin
      if not (CDS.State in [dsInsert,dsEdit]) then
         CDS.Edit;
      CDS.FieldByName('Pno').AsString:=FrmIPQCT500_selectpno.l_RetCode;
      CDS.FieldByName('Vendor').AsString:=FrmIPQCT500_selectpno.l_RetVendor;
    end;
  finally
    FreeAndNil(FrmIPQCT500_selectpno);
  end;
end;

procedure TFrmIPQCT500.Timer1Timer(Sender: TObject);
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
