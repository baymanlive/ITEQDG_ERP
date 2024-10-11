{*******************************************************}
{                                                       }
{                unDLII030                              }
{                Author: kaikai                         }
{                Create date: 2015/8/20                 }
{                Description: COC-PP列印                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ComCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, StdCtrls, ToolWin, unDLII030_rpt;

type
  TFrmDLII030 = class(TFrmSTDI041)
    PCL2: TPageControl;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_delete: TToolButton;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_deleteClick(Sender: TObject);
    procedure CDS3AfterPost(DataSet: TDataSet);
    procedure CDS3BeforeEdit(DataSet: TDataSet);
    procedure CDS3BeforeInsert(DataSet: TDataSet);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    l_qty:Double;
    l_sql2,l_sql3:string;
    l_list2,l_list3:TStrings;
    l_DLII030_rpt:TDLII030_rpt;
    procedure CDS2_Edit_Delete(isDelete:Boolean);
    procedure RefreshDS2;
    procedure RefreshDS3;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII030: TFrmDLII030;

implementation

uses unGlobal, unCommon, unDLII040_cocerr;

const l_tb3='Dli041';

{$R *.dfm}

procedure TFrmDLII030.CDS2_Edit_Delete(isDelete:Boolean);
var
  dsNE1,dsNE2,dsNE3,dsNE4:TDataSetNotifyEvent;
  tmpStr,tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  tmpStr:=' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS2.FieldByName('Dno').AsString)
         +' And Ditem='+CDS2.FieldByName('Ditem').AsString;
  if isDelete then
     tmpSQL:=' Delete From DLI040 '+tmpStr+' And Sno='+CDS2.FieldByName('Sno').AsString
            +' IF not Exists(Select 1 From DLI040 '+tmpStr+')'
            +' Update DLI010 Set Coc_no=null '+tmpStr;
  tmpSQL:=tmpSQL+' Exec dbo.proc_UpdateCoccount '+Quotedstr(g_UInfo^.BU)+','+
                          Quotedstr(CDS2.FieldByName('Dno').AsString)+','+
                          CDS2.FieldByName('Ditem').AsString
                +' Select Top 1 IsNull(Coccount,0) qty,Coc_no From DLI010 '+tmpStr;
  if QueryBySQL(tmpSQL, Data) then
  begin
    if isDelete then
    begin
      CDS2.Delete;
      CDS2.MergeChangeLog;
    end;
    
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      dsNE1:=CDS.BeforeEdit;
      dsNE2:=CDS.AfterEdit;
      dsNE3:=CDS.BeforePost;
      dsNE4:=CDS.AfterPost;
      CDS.BeforeEdit:=nil;
      CDS.AfterEdit:=nil;
      CDS.BeforePost:=nil;
      CDS.AfterPost:=nil;
      try
        CDS.Edit;
        CDS.FieldByName('Coccount').AsFloat:=tmpCDS.Fields[0].AsFloat;
        CDS.FieldByName('Coc_no').AsString:=tmpCDS.Fields[1].AsString;
        CDS.Post;
        CDS.MergeChangeLog;
      finally
        CDS.BeforeEdit:=dsNE1;
        CDS.AfterEdit:=dsNE2;
        CDS.BeforePost:=dsNE3;
        CDS.BeforePost:=dsNE4;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII030.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter
         +' And Substring(Pno,1,1) in (''A'',''E'',''U'')'
         +' And Custno is not null And Custno<>'''''
         +' And IsNull(GarbageFlag,0)=0 And Indate<=(Select Max(Indate)'
         +' From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)+')';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII030.RefreshDS2;
var
  tmpSQL:string;
begin
  tmpSQL:='Select * From DLI040'
         +' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
         +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger)
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Order By Sno';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLII030.RefreshDS3;
var
  tmpSQL:string;
begin
  tmpSQL:='Select * From '+l_tb3
         +' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
         +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger)
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Order By Sno';
  l_list3.Insert(0,tmpSQL);
end;

procedure TFrmDLII030.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='Dli010';
  p_GridDesignAns:=True;
  btn_delete.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_delete.Left:=btn_print.Left;

  inherited;

  TabSheet2.Caption:=CheckLang('批號資料');
  TabSheet3.Caption:=CheckLang('二維碼資料');
  SetGrdCaption(DBGridEh2, 'DLI040');
  SetGrdCaption(DBGridEh3, l_tb3);
  l_list2:=TStringList.Create;
  l_list3:=TStringList.Create;
  l_DLII030_rpt:=TDLII030_rpt.Create(CDS);
  Timer1.Enabled:=True;
  Timer2.Enabled:=True;
end;

procedure TFrmDLII030.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  Timer2.Enabled:=False;
  if CDS.State in [dsEdit] then
     CDS.Post;

  inherited;
  
  FreeAndNil(l_list2);
  FreeAndNil(l_list3);
  FreeAndNil(l_DLII030_rpt);
  CDS2.Active:=False;
  CDS3.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmDLII030.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS2;
  RefreshDS3;
end;

procedure TFrmDLII030.btn_deleteClick(Sender: TObject);
begin
  inherited;
  if PCL2.ActivePageIndex=0 then
  begin
    if (not CDS2.Active) or CDS2.IsEmpty then
    begin
      ShowMsg('請選擇刪除的資料!', 48);
      Exit;
    end;

    if ShowMsg('刪除後將不可恢復,確定刪除批號['+CDS2.FieldByName('manfac').AsString+']嗎?', 33)=IdCancel then
       Exit;
    CDS2_Edit_Delete(True);
  end else
  begin
    if (not CDS3.Active) or CDS3.IsEmpty then
    begin
      ShowMsg('請選擇刪除的資料!', 48);
      Exit;
    end;

    if ShowMsg('刪除後將不可恢復,確定刪除此筆二維碼資料嗎?', 33)=IdCancel then
       Exit;
    CDS3.Delete;
    if not CDSPost(CDS3, l_tb3) then
    if CDS3.ChangeCount>0 then
       CDS3.CancelUpdates;
  end;
end;

procedure TFrmDLII030.btn_printClick(Sender: TObject);
begin
//  inherited;
exit;
  l_DLII030_rpt.StartPrint(g_MInfo^.ProcId);
end;

procedure TFrmDLII030.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
//  inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    if Pos('Qry_ppccl', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
    if Pos('Qry_isbz', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate>='+Quotedstr(DateToStr(Date));
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLII030.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
     Exit;
       
  if SameText(Column.FieldName,'coc_ans') then
  begin
    CDS.Edit;
    CDS.FieldByName('coc_ans').AsBoolean:=not CDS.FieldByName('coc_ans').AsBoolean;
    CDS.Post;
  end;
end;

procedure TFrmDLII030.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if CDS.FieldByName('coc_ans').AsBoolean then
     tmpSQL:='Update Dli010 Set coc_ans=1'
  else
     tmpSQL:='Update Dli010 Set coc_ans=0';
  tmpSQL:=tmpSQL+' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
                +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger)
                +' And Bu='+Quotedstr(g_UInfo^.BU);
  if PostBySQL(tmpSQL) then
     CDS.MergeChangeLog
  else
     CDS.CancelUpdates;
end;

procedure TFrmDLII030.CDS2AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS2, 'Dli040') then
     CDS2.CancelUpdates
  else if l_qty<>DataSet.FieldByName('qty').AsFloat then
     CDS2_Edit_Delete(False);
end;

procedure TFrmDLII030.CDS3AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS3, l_tb3) then
     CDS3.CancelUpdates;
end;

procedure TFrmDLII030.CDSBeforeInsert(DataSet: TDataSet);
begin
  Abort;
//  inherited;
end;

procedure TFrmDLII030.CDS2BeforeInsert(DataSet: TDataSet);
begin
  Abort;
//  inherited;
end;

procedure TFrmDLII030.CDS3BeforeInsert(DataSet: TDataSet);
begin
  Abort;
//  inherited;
end;

procedure TFrmDLII030.CDS2BeforeEdit(DataSet: TDataSet);
begin
  if not g_MInfo^.R_edit then
     Abort;
  l_qty:=DataSet.FieldByName('qty').AsFloat;
  inherited;
end;

procedure TFrmDLII030.CDS3BeforeEdit(DataSet: TDataSet);
begin
  if not g_MInfo^.R_edit then
     Abort;
  inherited;
end;

procedure TFrmDLII030.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmDLII040_cocerr) then
     FrmDLII040_cocerr:=TFrmDLII040_cocerr.Create(Application);
  FrmDLII040_cocerr.l_Coc_errid:=CDS.FieldByName('Coc_errid').AsString;
  FrmDLII040_cocerr.ShowModal;
end;

procedure TFrmDLII030.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
     Exit;
  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then  //拆單
     AFont.Color:=clBlue;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
     AFont.Color:=clRed;
  if CDS.FieldByName('QtyColor').AsInteger=g_CocData then        //插單:COC資料
     AFont.Color:=clGray;
  if CDS.FieldByName('Coc_err').AsBoolean then                   //COC異常
     AFont.Color:=clFuchsia;
end;

procedure TFrmDLII030.Timer1Timer(Sender: TObject);
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

procedure TFrmDLII030.Timer2Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer2.Enabled:=False;
  try
    if l_List3.Count=0 then
       Exit;

    while l_List3.Count>1 do
      l_List3.Delete(l_List3.Count-1);

    tmpSQL:=l_List3.Strings[0];
    if tmpSQL=l_SQL3 then Exit;
    l_SQL3:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS3.Data:=Data;
  finally
    Timer2.Enabled:=True;
  end;
end;

end.
