unit unMPST080;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI060, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ExtCtrls, DB, DBClient, Menus, ImgList,
  StdCtrls, Buttons, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

const l_strState='正常,報廢';

type
  TFrmMPST080 = class(TFrmSTDI060)
    btn_mpst080A: TToolButton;
    btn_mpst080B: TToolButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_mpst080AClick(Sender: TObject);
    procedure btn_mpst080bClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_lot:string;
    l_sql2:string;
    l_list2:TStrings;
  public
    { Public declarations }
    procedure SetToolBar; override;
    procedure RefreshDS1(strFilter:string); override;
    procedure RefreshDS2; override;
  end;

var
  FrmMPST080: TFrmMPST080;

implementation

uses unGlobal, unCommon, unMPST080_mps;

{$R *.dfm}

procedure TFrmMPST080.SetToolBar;
begin
  btn_mpst080A.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPST080.RefreshDS1(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS350 Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPST080.RefreshDS2;
var
  tmpSQL:string;
begin
  if Assigned(l_list2) then
  begin
    tmpSQL:='Select * From MPS360 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Lot='+Quotedstr(CDS.FieldByName('Lot').AsString);
    l_list2.Insert(0,tmpSQL);
  end;

  inherited;
end;

procedure TFrmMPST080.FormCreate(Sender: TObject);
begin
  p_SysId:='MPS';
  p_MainTableName:='MPS350';
  p_DetailTableName:='MPS360';
  p_GridDesignAns1:=True;
  p_GridDesignAns2:=True;
  p_EditFlag:=allEdit;
  p_Grd2PosFlag:=isBottom;
  p_GridAnchors:=detailAnchors;
  btn_quit.Left:=btn_mpst080B.Left+btn_mpst080B.Width;
  btn_mpst080A.Visible:=g_MInfo^.R_edit;

  inherited;
  
  GetMPSMachine;
  DBGridEh1.FieldColumns['Machine'].PickList.DelimitedText:=g_MachineCCL;
  DBGridEh2.FieldColumns['State'].PickList.DelimitedText:=l_strState;
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmMPST080.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
end;

procedure TFrmMPST080.CDSBeforePost(DataSet: TDataSet);
begin
  if DBGridEh1.FieldColumns['Machine'].PickList.IndexOf(DataSet.FieldByName('Machine').AsString)=-1 then
  begin
    ShowMsg('請輸入['+DBGridEh1.FieldColumns['Machine'].Title.Caption+']', 48);
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('Stealno').AsString))=0 then
  begin
    ShowMsg('請輸入['+DBGridEh1.FieldColumns['Stealno'].Title.Caption+']', 48);
    Abort;
  end;

  if DataSet.FieldByName('MaxNum').IsNull then
  begin
    ShowMsg('請輸入['+DBGridEh1.FieldColumns['MaxNum'].Title.Caption+']', 48);
    Abort;
  end;

  if DataSet.FieldByName('FmSdate').IsNull then
  begin
    ShowMsg('請輸入['+DBGridEh1.FieldColumns['FmSdate'].Title.Caption+']', 48);
    Abort;
  end;

  if DataSet.FieldByName('FmBoiler').AsInteger<1 then
  begin
    ShowMsg('['+DBGridEh1.FieldColumns['FmBoiler'].Title.Caption+']輸入錯誤!', 48);
    Abort;
  end;

  if (not DataSet.FieldByName('ToSdate').IsNull) and
     (DataSet.FieldByName('ToSdate').AsDateTime<DataSet.FieldByName('FmSdate').AsDateTime) then
  begin
    ShowMsg('['+DBGridEh1.FieldColumns['ToSdate'].Title.Caption+']不能小於['+
                DBGridEh1.FieldColumns['FmSdate'].Title.Caption+']', 48);
    Abort;
  end;

  if not DataSet.FieldByName('ToBoiler').IsNull then
  if (DataSet.FieldByName('ToBoiler').AsInteger<1) or
     ((DataSet.FieldByName('ToSdate').AsDateTime=DataSet.FieldByName('FmSdate').AsDateTime) and
      (DataSet.FieldByName('ToBoiler').AsInteger<DataSet.FieldByName('FmBoiler').AsInteger)) then
  begin
    ShowMsg('['+DBGridEh1.FieldColumns['ToBoiler'].Title.Caption+']輸入錯誤!', 48);
    Abort;
  end;

  inherited;
end;

procedure TFrmMPST080.CDS2BeforePost(DataSet: TDataSet);
begin
  if Length(Trim(DataSet.FieldByName('Lot2').AsString))=0 then
  begin
    ShowMsg('請輸入['+DBGridEh2.FieldColumns['Lot2'].Title.Caption+']', 48);
    Abort;
  end;

  if Pos(DataSet.FieldByName('State').AsString,l_strState)=0 then
  begin
    ShowMsg('['+DBGridEh2.FieldColumns['State'].Title.Caption+']請選擇:'+l_strState,48);
    Abort;
  end;

  inherited;
end;

procedure TFrmMPST080.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('ToSdate').Clear;
    FieldByName('ToBoiler').Clear;
    FieldByName('MaxNum').AsInteger:=500;
    FieldByName('Num').AsInteger:=0;
  end;
end;

procedure TFrmMPST080.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('Lot').AsString:=CDS.FieldByName('Lot').AsString;
    FieldByName('Num').AsInteger:=0;
    FieldByName('State').AsString:=DBGridEh2.FieldColumns['State'].PickList.Strings[0];
  end;
end;

procedure TFrmMPST080.CDSBeforeDelete(DataSet: TDataSet);
begin
  l_lot:=CDS.FieldByName('lot').AsString;
  inherited;
end;

procedure TFrmMPST080.CDSBeforeEdit(DataSet: TDataSet);
begin
  l_lot:=CDS.FieldByName('lot').AsString;
  inherited;
end;

procedure TFrmMPST080.CDSBeforeInsert(DataSet: TDataSet);
begin
  l_lot:='';
  inherited;
end;

procedure TFrmMPST080.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if (Length(l_lot)>0) and (l_lot<>CDS.FieldByName('lot').AsString) then
  begin
    tmpSQL:='Update MPS360 Set Lot='+Quotedstr(CDS.FieldByName('Lot').AsString)
           +' Where Lot='+Quotedstr(l_lot);
    if PostBySQL(tmpSQL) then
       RefreshDS2
    else
       ShowMsg('更新明細資料主鍵失敗,請聯絡管理員!', 48);
  end;
end;

procedure TFrmMPST080.CDSAfterDelete(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if l_lot<>CDS.FieldByName('lot').AsString then
  begin
    tmpSQL:='Delete From MPS360 Where Bu='+Quotedstr(g_UInfo^.Bu)
           +' And Lot='+Quotedstr(l_lot);
    if not PostBySQL(tmpSQL) then
       ShowMsg('刪除明細資料失敗,請聯絡管理員!', 48);
  end;
end;

procedure TFrmMPST080.btn_mpst080AClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定更新嗎?',33)=IdOK then
  if PostBySQL('exec dbo.proc_HuanChongDian '+Quotedstr(g_UInfo^.BU)) then
     ShowMsg('更新完畢!', 64);
end;

procedure TFrmMPST080.btn_mpst080bClick(Sender: TObject);
begin
  inherited;
  FrmMPST080_mps:=TFrmMPST080_mps.Create(nil);
  try
    FrmMPST080_mps.ShowModal;
  finally
    FreeAndNil(FrmMPST080_mps);
  end;
end;


procedure TFrmMPST080.Timer1Timer(Sender: TObject);
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

