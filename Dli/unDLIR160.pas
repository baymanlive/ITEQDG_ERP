{*******************************************************}
{                                                       }
{                unDLIR160                              }
{                Author: kaikai                         }
{                Create date: 2018/1/19                 }
{                Description: 每日答交量統計表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR160;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils;

type
  TFrmDLIR160 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    LB: TListBox;
    TabSheet30: TTabSheet;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    PopupMenu1: TPopupMenu;
    N202: TMenuItem;
    N201: TMenuItem;
    N203: TMenuItem;
    N204: TMenuItem;
    N205: TMenuItem;
    N206: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure LBClick(Sender: TObject);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure CDS3AfterPost(DataSet: TDataSet);
    procedure CDS3NewRecord(DataSet: TDataSet);
    procedure CDS3BeforeEdit(DataSet: TDataSet);
    procedure CDS3BeforeInsert(DataSet: TDataSet);
    procedure CDS3AfterEdit(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure N202Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N203Click(Sender: TObject);
    procedure N204Click(Sender: TObject);
    procedure N205Click(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    procedure GetDS1(mtype:Integer; bu:string);
    procedure GetDS3;
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmDLIR160: TFrmDLIR160;

implementation

uses unGlobal, unCommon, unDLIR160_query;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="pgroup" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qty0" fieldtype="r8"/>'
           +'<FIELD attrname="qty1" fieldtype="r8"/>'
           +'<FIELD attrname="qty2" fieldtype="r8"/>'
           +'<FIELD attrname="qty3" fieldtype="r8"/>'
           +'<FIELD attrname="qty4" fieldtype="r8"/>'
           +'<FIELD attrname="qty5" fieldtype="r8"/>'
           +'<FIELD attrname="qty6" fieldtype="r8"/>'
           +'<FIELD attrname="qty7" fieldtype="r8"/>'
           +'<FIELD attrname="qty8" fieldtype="r8"/>'
           +'<FIELD attrname="qty9" fieldtype="r8"/>'
           +'<FIELD attrname="qty10" fieldtype="r8"/>'
           +'<FIELD attrname="qty11" fieldtype="r8"/>'
           +'<FIELD attrname="qty12" fieldtype="r8"/>'
           +'<FIELD attrname="qty13" fieldtype="r8"/>'
           +'<FIELD attrname="qty14" fieldtype="r8"/>'
           +'<FIELD attrname="qty15" fieldtype="r8"/>'
           +'<FIELD attrname="qty16" fieldtype="r8"/>'
           +'<FIELD attrname="qty17" fieldtype="r8"/>'
           +'<FIELD attrname="qty18" fieldtype="r8"/>'
           +'<FIELD attrname="qty19" fieldtype="r8"/>'
           +'<FIELD attrname="qty20" fieldtype="r8"/>'
           +'<FIELD attrname="qty21" fieldtype="r8"/>'
           +'<FIELD attrname="qty22" fieldtype="r8"/>'
           +'<FIELD attrname="qty23" fieldtype="r8"/>'
           +'<FIELD attrname="qty24" fieldtype="r8"/>'
           +'<FIELD attrname="qty25" fieldtype="r8"/>'
           +'<FIELD attrname="qty26" fieldtype="r8"/>'
           +'<FIELD attrname="qty27" fieldtype="r8"/>'
           +'<FIELD attrname="qty28" fieldtype="r8"/>'
           +'<FIELD attrname="qty29" fieldtype="r8"/>'
           +'<FIELD attrname="tot" fieldtype="r8"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIR160.GetDS1(mtype:Integer; bu:string);
var
  tmpOutQty,tmpRemainQty:Double;
  tmpSQL,fName,tmpOrderno:string;
  i,tmpOrderitem:Integer;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  g_StatusBar.Panels[1].Text:='正在查詢資料,查詢過程較慢,請等待...';
  Application.ProcessMessages;
  try
    tmpSQL:='exec [dbo].[proc_DLIR160] '+Quotedstr(bu)+','+IntToStr(mtype);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    LB.Items.Clear;
    l_CDS.EmptyDataSet;
    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    try
      //正常數據
      tmpCDS1.Data:=Data;
      tmpCDS1.Filtered:=False;
      tmpCDS1.Filter:='flag=0';
      tmpCDS1.Filtered:=True;
      tmpCDS2.Filtered:=False;

      while not tmpCDS1.Eof do
      begin
        if l_CDS.Locate('pgroup;ad',VarArrayOf([tmpCDS1.FieldByName('pgroup').AsString,tmpCDS1.FieldByName('ad').AsString]),[]) then
           l_CDS.Edit
        else begin
          l_CDS.Append;
          l_CDS.FieldByName('pgroup').AsString:=tmpCDS1.FieldByName('pgroup').AsString;
          l_CDS.FieldByName('ad').AsString:=tmpCDS1.FieldByName('ad').AsString;
          if LB.Items.IndexOf(l_CDS.FieldByName('ad').AsString)=-1 then
             LB.Items.Add(l_CDS.FieldByName('ad').AsString);
        end;

        fName:='qty'+IntToStr(tmpCDS1.FieldByName('qtyindex').AsInteger);
        l_CDS.FieldByName(fName).AsFloat:=l_CDS.FieldByName(fName).AsFloat+tmpCDS1.FieldByName('outqty').AsFloat;
        l_CDS.Post;

        tmpCDS1.Next;
      end;
      tmpCDS1.Filtered:=False;

      //拆多筆,達交量>未交量
      tmpCDS2.Data:=Data;
      tmpCDS2.Filter:='flag=1';
      tmpCDS2.Filtered:=True;
      tmpCDS2.AddIndex('xIndex', 'orderno;orderitem;qtyindex', [ixCaseInsensitive], 'qtyindex');
      tmpCDS2.IndexName:='xIndex';
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
              if l_CDS.Locate('pgroup;ad',VarArrayOf([tmpCDS2.FieldByName('pgroup').AsString,tmpCDS2.FieldByName('ad').AsString]),[]) then
                 l_CDS.Edit
              else begin
                l_CDS.Append;
                l_CDS.FieldByName('pgroup').AsString:=tmpCDS2.FieldByName('pgroup').AsString;
                l_CDS.FieldByName('ad').AsString:=tmpCDS2.FieldByName('ad').AsString;
                if LB.Items.IndexOf(l_CDS.FieldByName('ad').AsString)=-1 then
                   LB.Items.Add(l_CDS.FieldByName('ad').AsString);
              end;

              fName:='qty'+IntToStr(tmpCDS2.FieldByName('qtyindex').AsInteger);
              l_CDS.FieldByName(fName).AsFloat:=l_CDS.FieldByName(fName).AsFloat+tmpOutQty;
              l_CDS.Post;

              tmpCDS1.Append;
              for i:=0 to tmpCDS1.FieldCount-1 do
                tmpCDS1.Fields[i].Value:=tmpCDS2.Fields[i].Value;
              tmpCDS1.FieldByName('outqty').AsFloat:=tmpOutQty;
              tmpCDS1.FieldByName('flag').AsInteger:=2;
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

      //合計
      l_CDS.First;
      while not l_CDS.Eof do
      begin
        tmpOutQty:=0;
        for i:=2 to l_CDS.FieldCount-2 do
          tmpOutQty:=tmpOutQty+l_CDS.Fields[i].AsFloat;
        l_CDS.Edit;
        l_CDS.FieldByName('tot').AsFloat:=tmpOutQty;
        l_CDS.Post;
        l_CDS.Next;
      end;
      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
      CDS.Data:=l_CDS.Data;

      //明細
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        if tmpCDS1.FieldByName('flag').AsInteger=1 then
           tmpCDS1.Delete
        else
           tmpCDS1.Next;
      end;
      if tmpCDS1.ChangeCount>0 then
         tmpCDS1.MergeChangeLog;
      CDS2.Data:=tmpCDS1.Data;
      CDS2.IndexFieldNames:='mtype;ad;pgroup;qtyindex;orderno;orderitem';

      if LB.Items.Count>0 then
      begin
        LB.ItemIndex:=0;
        LBClick(LB);
      end;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
    end;
  finally
    g_StatusBar.Panels[1].Text:='';
  end;
end;

procedure TFrmDLIR160.GetDS3;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI610';
  if QueryBySQL(tmpSQL, Data) then
     CDS3.Data:=Data;
end;

procedure TFrmDLIR160.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     GetDS1(-1, g_UInfo^.Bu)
  else
     GetDS1(0, g_UInfo^.Bu);

  inherited;
end;

procedure TFrmDLIR160.FormCreate(Sender: TObject);
var
  y,m,d1,d2,i:Integer;
begin
  p_SysId:='Dli';
  p_TableName:='DLIR160_1';
  p_GridDesignAns:=True;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);

  inherited;

  TabSheet20.Caption:=CheckLang('明細資料');
  TabSheet30.Caption:=CheckLang('客戶群組');
  SetGrdCaption(DBGridEh2, 'DLIR160_2');
  SetGrdCaption(DBGridEh3, 'DLI610');

  y:=YearOf(Date);
  m:=MonthOf(Date);
  d1:=DayOf(Date);
  d2:=DayOf(EndOfTheMonth(Date));
  with DBGridEh1 do
  begin
    for i:=1 to Columns.Count-2 do
    begin
      Columns[i].Title.Caption:=IntToStr(m)+'月'+IntToStr(d1);
      if d1=d2 then
      begin
        Inc(m);
        if m=13 then
        begin
          Inc(y);
          m:=1;
        end;
        d1:=1;
        d2:=DayOf(EndOfTheMonth(EncodeDate(y,m,d1)));
      end else
        Inc(d1);
    end;
  end;

  GetDS3;
end;

procedure TFrmDLIR160.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR160.btn_exportClick(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
//  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('無資料',48);
    Exit;
  end;

  case ShowMsg('匯出[基本資料]請按[是]'+#13#10+'匯出[明細資料]請按[否]'+#13#10+'[取消]無操作',35) of
    IdYES:if (not CDS.Active) or CDS.IsEmpty then
             ShowMsg('無資料',48)
         else begin
           tmpSQL:='select tablename,fieldname,caption from sys_tabledetail'
                  +' where tablename=''DLIR160_1'' and fieldname like ''qty%''';
           if not QueryBySQL(tmpSQL, Data) then
              Exit;
           tmpCDS:=TClientDataSet.Create(nil);
           try
             tmpCDS.Data:=Data;
             while not tmpCDS.Eof do
             begin
               tmpSQL:=DBGridEh1.FieldColumns[tmpCDS.Fields[1].AsString].Title.Caption;
               if tmpCDS.Fields[2].AsString<>tmpSQL then
               begin
                 tmpCDS.Edit;
                 tmpCDS.Fields[2].AsString:=tmpSQL;
                 tmpCDS.Post;
               end;
               tmpCDS.Next;
             end;
             if not CDSPost(tmpCDS, 'sys_tabledetail') then
                Exit;
           finally
             FreeAndNil(tmpCDS);
           end;
           GetExportXls(CDS, 'DLIR160_1');
         end;
    IdNO:if (not CDS2.Active) or CDS2.IsEmpty then
            ShowMsg('無資料',48)
         else
            GetExportXls(CDS2, 'DLIR160_2');
  end;
end;

procedure TFrmDLIR160.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR160_query) then
     FrmDLIR160_query:=TFrmDLIR160_query.Create(Application);
  if FrmDLIR160_query.ShowModal=mrOK then
     GetDS1(FrmDLIR160_query.rgp1.ItemIndex, FrmDLIR160_query.rgp2.Items.Strings[FrmDLIR160_query.rgp2.ItemIndex]);
end;

procedure TFrmDLIR160.LBClick(Sender: TObject);
begin
  inherited;
  if LB.ItemIndex=-1 then
     Exit;
  CDS.Filtered:=False;
  CDS.Filter:='ad='+Quotedstr(LB.Items.Strings[LB.ItemIndex]);
  CDS.Filtered:=True;
  CDS.IndexFieldNames:='pgroup';
end;

procedure TFrmDLIR160.CDS3BeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if Length(Trim(DataSet.FieldByName('custno').AsString))=0 then
  begin
    ShowMsg('請輸入客戶編號!',48);
    if DBGridEh3.CanFocus then
       DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=DataSet.FieldByName('custno');
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('pgroup').AsString))=0 then
  begin
    ShowMsg('請輸入客戶名稱!',48);
    if DBGridEh3.CanFocus then
       DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=DataSet.FieldByName('pgroup');
    Abort;
  end;

  if (DataSet.State in [dsInsert]) or ((DataSet.State in [dsEdit]) and
     (DataSet.FieldByName('custno').Value<>DataSet.FieldByName('custno').OldValue)) then
  begin
    tmpSQL:='Select 1 From DLI610 Where Custno='+Quotedstr(DataSet.FieldByName('custno').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;

    if Length(VarToStr(Data))>0 then
    begin
      ShowMsg('客戶編號重複!',48);
      if DBGridEh3.CanFocus then
         DBGridEh3.SetFocus;
      DBGridEh3.SelectedField:=DataSet.FieldByName('custno');
      Abort;
    end;
  end;
end;

procedure TFrmDLIR160.CDS3AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS3, 'DLI610') then
     CDS3.CancelUpdates;
end;

procedure TFrmDLIR160.CDS3NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Iuser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Idate').AsDateTime:=Now;
end;

procedure TFrmDLIR160.CDS3BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmDLIR160.CDS3BeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmDLIR160.CDS3AfterEdit(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Muser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Mdate').AsDateTime:=Now;
end;

procedure TFrmDLIR160.PopupMenu1Popup(Sender: TObject);
begin
  inherited;

  N201.Visible:=CDS3.Active and g_MInfo^.R_edit;
  N202.Visible:=N201.Visible;
  N203.Visible:=N201.Visible;
  N204.Visible:=N201.Visible;
  N205.Visible:=N201.Visible;

  if N201.Visible then
  begin
    if CDS3.State in [dsInsert,dsEdit] then
    begin
      N201.Enabled:=False;
      N202.Enabled:=False;
      N203.Enabled:=False;
      N204.Enabled:=True;
      N205.Enabled:=True;
    end else
    begin
      N201.Enabled:=True;
      N202.Enabled:=not CDS3.IsEmpty;
      N203.Enabled:=N202.Enabled;
      N204.Enabled:=False;
      N205.Enabled:=False;
    end;
  end;
end;

procedure TFrmDLIR160.N201Click(Sender: TObject);
begin
  inherited;
  CDS3.Append;
end;

procedure TFrmDLIR160.N202Click(Sender: TObject);
begin
  inherited;
  if ShowMsg('刪除後不可恢複,確定刪除嗎?',33)=IDCancel then
     Exit;
     
  CDS3.Delete;
  if not CDSPost(CDS3, 'DLI610') then
     CDS3.CancelUpdates;
end;

procedure TFrmDLIR160.N203Click(Sender: TObject);
begin
  inherited;
  CDS3.Edit;
end;

procedure TFrmDLIR160.N204Click(Sender: TObject);
begin
  inherited;
  if CDS3.State in [dsInsert,dsEdit] then
     CDS3.Post;
end;

procedure TFrmDLIR160.N205Click(Sender: TObject);
begin
  inherited;
  if CDS3.State in [dsInsert,dsEdit] then
     CDS3.Cancel;
end;

end.

