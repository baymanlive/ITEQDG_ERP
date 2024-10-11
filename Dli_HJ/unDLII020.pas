{*******************************************************}
{                                                       }
{                unDLII020                              }
{                Author: kaikai                         }
{                Create date: 2015/5/28                 }
{                Description: 出貨單列印                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, unDLII020_sale,
  unDLII020_prn, unDLII020_btnopt, unDLII020_const;

type
  TFrmDLII020 = class(TFrmSTDI041)
    Panel2: TPanel;
    btn_dlii020A: TBitBtn;
    btn_dlii020B: TBitBtn;
    btn_dlii020C: TBitBtn;
    btn_dlii020D: TBitBtn;
    btn_dlii020E: TBitBtn;
    btn_dlii020F: TBitBtn;
    btn_dlii020G: TBitBtn;
    PnlRight: TPanel;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    DBGridEh2: TDBGridEh;
    btn_dlii020H: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn_dlii020AClick(Sender: TObject);
    procedure btn_dlii020BClick(Sender: TObject);
    procedure btn_dlii020CClick(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_dlii020EClick(Sender: TObject);
    procedure btn_dlii020FClick(Sender: TObject);
    procedure btn_dlii020GClick(Sender: TObject);
    procedure btn_dlii020DClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure btn_dlii020HClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    l_StrIndex,l_StrIndexDesc,l_sql2:string;
    l_opt,l_bool2:Boolean;
    l_SelList:TStrings;
    l_list2:TStrings;
    l_prn:TDLII020_prn;
    l_btnopt:TDLII020_btnopt;
    procedure SetBtnEnabled(Bool:Boolean);
    procedure RefreshDS2;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII020: TFrmDLII020;

implementation

uses unGlobal, unCommon, unDLII020_upd, unDLII020_prnconf,
  unDLII020_qrcode;

const l_tb2='DLI020';

{$R *.dfm}

procedure TFrmDLII020.SetBtnEnabled(bool:Boolean);
var
  i:Integer;
begin
  for i:=0 to PnlRight.ControlCount -1 do
    if PnlRight.Controls[i] is TBitBtn then
       (PnlRight.Controls[i] as TBitBtn).Enabled:=bool;
end;

procedure TFrmDLII020.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter
         +' And Left(Pno,1) in (''A'',''E'',''U'')'
         +' And IsNull(GarbageFlag,0)=0 And Indate<=(Select Max(Indate)'
         +' From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)+')';
 if QueryBySQL(tmpSQL, Data) then
    CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII020.RefreshDS2;
var
  tmpSQL:string;
begin
  tmpSQL:='Select *,Case SFlag When 0 Then ''檢貨'' When 1 Then ''並包確認'' End SFlagX,'
         +' Case JFlag When 1 Then ''並包當中'' When 2 Then ''並包完成'' End JFlagX'
         +' From '+l_tb2
         +' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
         +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger)
         +' And Bu='+Quotedstr(g_UInfo^.BU)
         +' Order By Sno';
  if l_bool2 then
     tmpSQL:=tmpSQL+' ';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLII020.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI010';
  p_GridDesignAns:=True;
  DBGridEh1.Parent:=Panel2;
  DBGridEh2.Parent:=Panel2;
  DBGridEh2.Height:=220;
  
  inherited;

  SetGrdCaption(DBGridEh2, l_tb2);
  SetPnlRightBtn(PnlRight,False);
  l_SelList:=TStringList.Create;
  l_list2:=TStringList.Create;
  l_prn:=TDLII020_prn.Create;
  l_btnopt:=TDLII020_btnopt.Create;
  Timer1.Enabled:=True;
  CMDDeleteFile(g_UInfo^.TempPath,'bmp');
end;

procedure TFrmDLII020.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_SelList);
  FreeAndNil(l_list2);
  FreeAndNil(l_prn);
  FreeAndNil(l_btnopt);
end;

procedure TFrmDLII020.btn_printClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if CDS.Active and (Length(Trim(CDS.FieldByName('Saleno').AsString))>0) then
     tmpStr:=Trim(CDS.FieldByName('Saleno').AsString);
  if not Assigned(FrmDLII020_prnconf) then
     FrmDLII020_prnconf:=TFrmDLII020_prnconf.Create(Application);
  FrmDLII020_prnconf.Edit1.Text:=tmpStr;
  if FrmDLII020_prnconf.ShowModal=mrOK then
  begin
    case FrmDLII020_prnconf.rgp.ItemIndex of
      0:l_prn.StartPrintDef(UpperCase(Trim(FrmDLII020_prnconf.Edit1.Text)));
      1:l_prn.StartPrintCustomer(UpperCase(Trim(FrmDLII020_prnconf.Edit1.Text)));
    end;
  end;
end;

procedure TFrmDLII020.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    if Length(tmpStr)=0 then
       tmpStr:=tmpStr+' And Indate>='+Quotedstr(DateToStr(Date));
    l_SelList.Clear;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLII020.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    tmpStr:=CDS.FieldByName('Dno').AsString+'@'+
            CDS.FieldByName('Ditem').AsString;
    if l_SelList.IndexOf(tmpStr) =-1 then
       l_SelList.Add(tmpStr)
    else
       l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;

  if SameText(Column.FieldName,'prn_ans') then
  begin
    CDS.Edit;
    CDS.FieldByName('Prn_ans').AsBoolean:=not CDS.FieldByName('Prn_ans').AsBoolean;
    CDS.Post;
  end;
end;

procedure TFrmDLII020.CDSAfterScroll(DataSet: TDataSet);
begin
  if not l_opt then
  begin
    inherited;
    RefreshDS2;
  end;
end;

procedure TFrmDLII020.CDSBeforePost(DataSet: TDataSet);
begin
  inherited;
  if l_opt then
     Exit;
     
  if (CDS.State in [dsEdit]) and CDS.FieldByName('Prn_ans').AsBoolean and (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    ShowMsg('未產生出貨單,不能更改[列印]狀態!', 48);
    CDS.CancelUpdates;
    Abort;
  end;
end;

procedure TFrmDLII020.CDSAfterPost(DataSet: TDataSet);
var
  tmpBool:Boolean;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if l_opt then
     Exit;

  tmpBool:=CDS.FieldByName('Prn_ans').AsBoolean;

  if (not tmpBool) and (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno,Ditem');
    Exit;
  end;

  tmpSQL:='Select Bu,Dno,Ditem,Prn_ans From Dli010'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Saleno='+Quotedstr(CDS.FieldByName('Saleno').AsString);
  if QueryBySQL(tmpSQL, Data) then
  begin
    l_opt:=True;
    CDS.DisableControls;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        Edit;
        FieldByName('Prn_ans').AsBoolean:=tmpBool;
        Post;
        Next;
      end;

      if PostBySQLFromDelta(tmpCDS, p_TableName, 'Bu,Dno,Ditem') then
      begin
        CDS.MergeChangeLog;
        if (tmpCDS.RecordCount=1) and
           (CDS.FieldByName('Dno').AsString=tmpCDS.FieldByName('Dno').AsString) and
           (CDS.FieldByName('Ditem').AsInteger=tmpCDS.FieldByName('Ditem').AsInteger) then
           Exit;   //只有一筆

        //多筆,更新其它項次打印狀態   
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            if CDS.Locate('Dno;Ditem', VarArrayOf([Fields[1].AsString, Fields[2].AsString]), []) then
            begin
              CDS.Edit;
              CDS.FieldByName('Prn_ans').AsBoolean:=tmpBool;
              CDS.Post;
            end;
            Next;
          end;
        end;
        if CDS.ChangeCount>0 then
           CDS.MergeChangeLog;
      end else
        CDS.CancelUpdates;
        
    finally
      l_opt:=False;
      CDS.EnableControls;
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII020.btn_dlii020AClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    DLII020_sale(CDS, l_SelList);
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020BClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    if l_btnopt.UpdateLot(CDS, CDS2) then
    begin
      l_bool2:=True;
      try
        RefreshDS2;
      finally
        l_bool2:=False;
      end;
    end;
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020CClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    l_btnopt.SplitQty(CDS);
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020DClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    l_btnopt.SplitQtyAll(True);
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020EClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    l_btnopt.DeleteSaleNo(CDS);
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020FClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    l_btnopt.DeleteSaleItem(CDS);
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020GClick(Sender: TObject);
begin
  inherited;
  l_opt:=True;
  SetBtnEnabled(False);
  try
    if l_btnopt.DeleteLot(CDS, CDS2) then
    begin
      l_bool2:=True;
      try
        RefreshDS2;
      finally
        l_bool2:=False;
      end;
    end;
  finally
    l_opt:=False;
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.btn_dlii020HClick(Sender: TObject);
begin
  inherited;
  SetBtnEnabled(False);
  try
    if not AsSigned(FrmDLII020_qrcode) then
       FrmDLII020_qrcode:=TFrmDLII020_qrcode.Create(Application);
    if Length(Self.CDS.FieldByName('Saleno').AsString)>0 then
    begin
      FrmDLII020_qrcode.Edit1.Text:=Self.CDS.FieldByName('Saleno').AsString;
      FrmDLII020_qrcode.Edit2.Text:=IntToStr(Self.CDS.FieldByName('SaleItem').AsInteger);
      FrmDLII020_qrcode.Memo1.Clear;
    end;
    FrmDLII020_qrcode.ShowModal;
  finally
    SetBtnEnabled(True);
  end;
end;

procedure TFrmDLII020.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLII020.DBGridEh1GetCellParams(Sender: TObject;
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
end;

procedure TFrmDLII020.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr:string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr:=CDS.FieldByName('Dno').AsString+'@'+
            CDS.FieldByName('Ditem').AsString;
    if l_SelList.IndexOf(tmpStr)<>-1 then
       DBGridEh1.Canvas.TextOut(Round((Rect.Left+Rect.Right)/2)-6,
       Round((Rect.Top+Rect.Bottom)/2-6), 'V');
  end;
end;

procedure TFrmDLII020.Timer1Timer(Sender: TObject);
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
    if (not l_bool2) and (tmpSQL=l_SQL2) then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
