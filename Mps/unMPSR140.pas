{*******************************************************}
{                                                       }
{                unMPSR140                              }
{                Author: kaikai                         }
{                Create date: 2018/3/1                  }
{                Description: 訂單達交L/T統計分析表     }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR140;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, StdCtrls, ToolWin, Math, DateUtils,
  unGridDesign;

type
  TFrmMPSR140 = class(TFrmSTDI040)
    CDS3: TClientDataSet;
    DS3: TDataSource;
    PopupMenu1: TPopupMenu;
    N201: TMenuItem;
    N202: TMenuItem;
    N203: TMenuItem;
    N206: TMenuItem;
    N204: TMenuItem;
    N205: TMenuItem;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure CDS3AfterPost(DataSet: TDataSet);
    procedure CDS3NewRecord(DataSet: TDataSet);
    procedure CDS3BeforeInsert(DataSet: TDataSet);
    procedure CDS3BeforeEdit(DataSet: TDataSet);
    procedure CDS3AfterEdit(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N201Click(Sender: TObject);
    procedure N202Click(Sender: TObject);
    procedure N203Click(Sender: TObject);
    procedure N204Click(Sender: TObject);
    procedure N205Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_bu,l_pgroup:string;
    l_GridDesign2:TGridDesign;
    procedure GetDS(xFliter:string);
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmMPSR140: TFrmMPSR140;

implementation

uses unGlobal, unCommon, unMPSR140_Query;

const l_table1='MPSR140_1';
const l_table2='MPSR140_2';
const l_tableLT='MPS341';

{$R *.dfm}

procedure TFrmMPSR140.GetDS(xFliter:string);
var
  days:Integer;
  D1,D2:TDateTime;
  Data:OleVariant;
  tmpSQL,tmpOrderno:string;
  tmpCDSA,tmpCDSB,tmpCDS1,tmpCDS2:TClientDataSet;
begin
  tmpCDSA:=TClientDataSet.Create(nil);
  tmpCDSB:=TClientDataSet.Create(nil);
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select B.*,oao06'
           +' from(select oea02,oea01,oeb03,pgroup,oea04,occ02,ptype,ad,oeb04,ta_oeb01,'
           +' ta_oeb02,oeb05,oeb12,oeb24,oeb24 qty,oeb15,oea02 adate,oeb03 overday'
           +' from (select oea02,oea01,oeb03,oeb06 as pgroup,oea04,oeb04,ta_oeb01,'
           +' ta_oeb02,oeb05,oeb12,oeb24,oeb15,'
           +' case when substr(oeb04,1,1) in (''R'',''N'',''B'',''M'') then ''PP'''
					 +'	when substr(oeb04,1,1) in (''E'',''T'') and substr(oeb04,1,2) not in (''EI'',''ES'') then ''CCL'' else ''err'' end as ptype,'
           +' case when instr(oeb06,''TC'',1,1)>0 then substr(oeb06,1,instr(oeb06,''TC'',1,1)-1)'
			     +' when instr(oeb06,''BS'',1,1)>0 then substr(oeb06,1,instr(oeb06,''BS'',1,1)-1) else ''err'' end as ad'
           +' from '+l_bu+'.oea_file inner join '+l_bu+'.oeb_file on oea01=oeb01'
           +' where oeaconf=''Y'' and oeb12>0 and oeb12>oeb24 and oeb70=''N'''
           +' and to_char(oea02,''YYYY/MM/DD'')>=''2016/01/01'''
           +' and oea01 not like ''226%'''
           +' and oea01 not like ''228%'''
           +' and oea01 not like ''22A%'''
           +' and oea01 not like ''22B%'''
           +' and oea04 not in(''N012'',''N005'')'
           +' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%'''
           +' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%'''
           +' or oeb04 like ''R%'' or oeb04 like ''T%'')'
		       +' and oeb06 not like ''玻%'''
		       +' and oeb06 not like ''ML%'') A'
           +' inner join '+l_bu+'.occ_file on oea04=occ01 where 1=1 '+xFliter
           +' ) B left join '+l_bu+'.oao_file on oea01=oao01 and oeb03=oao03'
           +' order by oea02,oea01,oeb03';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDSA.Data:=Data;
    with tmpCDSA do
    begin
      if IsEmpty then
      begin
        CDS.Data:=tmpCDSA.Data;
        CDS2.Data:=tmpCDSA.Data;
        Exit;
      end;

      tmpCDS2.Data:=CDS3.Data;
      First;
      while not Eof do
      begin
        tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('oea01').AsString);
        Edit;

        days:=0;
        tmpSQL:='';
        tmpCDS2.First;
        while not tmpCDS2.Eof do
        begin
          if Pos(FieldByName('oea04').AsString, tmpCDS2.FieldByName('custno').AsString)>0 then
             tmpSQL:=tmpCDS2.FieldByName('pgroup').AsString;

          if Pos(FieldByName('oea04').AsString, tmpCDS2.FieldByName('custno').AsString)>0 then
          if (Pos(FieldByName('ad').AsString, tmpCDS2.FieldByName('ad').AsString)>0) or
             (FieldByName('ptype').AsString=tmpCDS2.FieldByName('ad').AsString) then
          begin
            if Pos('QTA',FieldByName('oao06').AsString)>0 then
               days:=tmpCDS2.FieldByName('qta').AsInteger
            else
               days:=tmpCDS2.FieldByName('normal').AsInteger;
            Break;
          end;
          
          tmpCDS2.Next;
        end;

        FieldByName('overday').AsInteger:=days;
        FieldByName('pgroup').AsString:=tmpSQL;
        if Length(l_pgroup)>0 then
          if Pos(FieldByName('pgroup').AsString, l_pgroup)=0 then
             FieldByName('pgroup').AsString:='1';
        FieldByName('qty').AsFloat:=RoundTo(FieldByName('oeb12').AsFloat-FieldByName('oeb24').AsFloat, -3);
        FieldByName('adate').Clear;
        Post;
        Next;
      end;

      //過濾集團名稱
      if Length(l_pgroup)>0 then
      begin
        tmpOrderno:='';
        Filtered:=False;
        Filter:='pgroup=''1''';
        Filtered:=True;
        while not isEmpty do
          delete;

        Filtered:=False;
        First;
        while not Eof do
        begin
          tmpOrderno:=tmpOrderno+','+Quotedstr(FieldByName('oea01').AsString);
          Next;
        end;
      end;
    end;

    //更新達交日期
    if Length(tmpOrderno)>0 then
    begin
      Delete(tmpOrderno,1,1);
      Data:=null;
      tmpSQL:='Select Orderno,Orderitem,Adate'
             +' From MPS200 Where Bu='+Quotedstr(l_bu)
             +' And Orderno in ('+tmpOrderno+')'
             +' And IsNull(GarbageFlag,0)=0';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;
      tmpCDS1.Data:=Data;
      with tmpCDS1 do
      while not Eof do
      begin
        if tmpCDSA.Locate('oea01;oeb03',
            VarArrayOf([FieldByName('Orderno').AsString,
                        FieldByName('Orderitem').AsInteger]),[]) then
        begin
          tmpCDSA.Edit;
          if not FieldByName('adate').IsNull then
          if tmpCDSA.FieldByName('adate').IsNull or
             (FieldByName('adate').AsDateTime<tmpCDSA.FieldByName('adate').AsDateTime) then
             tmpCDSA.FieldByName('adate').AsDateTime:=FieldByName('adate').AsDateTime;

          tmpCDSA.Post;
        end;
        Next;
      end;
    end;

    tmpCDSB.Data:=tmpCDSA.Data;

    //tmpCDSA只保留逾期資料:adate-oea02
    with tmpCDSA do
    begin
      First;
      while not Eof do
      begin
        if not FieldByName('adate').IsNull then
           D1:=FieldByName('adate').AsDateTime
        else
           D1:=Date;
        days:=DaysBetween(FieldByName('oea02').AsDateTime,D1)-FieldByName('overday').AsInteger;
        Edit;
        FieldByName('overday').AsInteger:=days;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='overday<=0';
      Filtered:=True;
      while not isEmpty do
        delete;
      Filtered:=False;
    end;

    //tmpCDSB只保留逾期資料:adate-oeb15
    with tmpCDSB do
    begin
      First;
      while not Eof do
      begin
        D1:=FieldByName('oea02').AsDateTime;
        if not FieldByName('oeb15').IsNull then
        begin
          try
            D1:=FieldByName('oeb15').AsDateTime;
          except
          end;
        end;

        if not FieldByName('adate').IsNull then
           D2:=FieldByName('adate').AsDateTime
        else
           D2:=Date;

        if D2>D1 then
           days:=DaysBetween(D1,D2)
        else
           days:=0;
        Edit;
        FieldByName('overday').AsInteger:=days;
        Post;
        Next;
      end;

      Filtered:=False;
      Filter:='overday<=0';
      Filtered:=True;
      while not isEmpty do
        delete;
      Filtered:=False;
    end;

    if tmpCDSA.ChangeCount>0 then
       tmpCDSA.MergeChangeLog;
    if tmpCDSB.ChangeCount>0 then
       tmpCDSB.MergeChangeLog;
    CDS.Data:=tmpCDSA.Data;
    CDS2.Data:=tmpCDSB.Data;
    PCL.ActivePageIndex:=0;
  finally
    FreeAndNil(tmpCDSA);
    FreeAndNil(tmpCDSB);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmMPSR140.RefreshDS(strFilter: string);
var
  Data:OleVariant;
begin
  GetDS(strFilter);

  if QueryBySQL('Select * From '+l_tableLT, Data) then
     CDS3.Data:=Data;

  inherited;
end;

procedure TFrmMPSR140.FormCreate(Sender: TObject);
begin
  l_bu:=g_UInfo^.BU;
  p_SysId:='Mps';
  p_TableName:=l_table1;
  p_GridDesignAns:=True;

  inherited;

  TabSheet1.Caption:=CheckLang('協議逾期明細');
  TabSheet2.Caption:=CheckLang('客戶要求逾期明細');
  TabSheet3.Caption:=CheckLang('L/T設定');
  SetGrdCaption(DBGridEh2, l_table2);
  SetGrdCaption(DBGridEh3, l_tableLT);
  l_GridDesign2:=TGridDesign.Create(DBGridEh2, l_table2);
end;

procedure TFrmMPSR140.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  if Assigned(l_GridDesign2) then
     FreeAndNil(l_GridDesign2);
end;

procedure TFrmMPSR140.btn_exportClick(Sender: TObject);
begin
//  inherited;
  if CDS.IsEmpty and CDS2.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  case ShowMsg('匯出[協議逾期明細]請按[是]'+#13#10+'匯出[客戶要求逾期明細]請按[否]'+#13#10+'[取消]無操作',35) of
    IDYes:GetExportXls(CDS, l_table1);
    IDNo:GetExportXls(CDS2, l_table2);
    IDCancel:Exit;
  end;
end;

procedure TFrmMPSR140.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR140_Query) then
     FrmMPSR140_Query:=TFrmMPSR140_Query.Create(Application);
  if FrmMPSR140_Query.ShowModal=mrOK then
  begin
    l_bu:=FrmMPSR140_Query.rgp2.Items[FrmMPSR140_Query.rgp2.ItemIndex];
    l_pgroup:=FrmMPSR140_Query.Edit1.Text;
    g_StatusBar.Panels[0].Text:='正在查詢...';
    Application.ProcessMessages;
    try
      GetDS(FrmMPSR140_Query.l_ret);
    finally
      g_StatusBar.Panels[0].Text:='';
    end;
  end;
end;

procedure TFrmMPSR140.CDS3BeforePost(DataSet: TDataSet);
begin
  inherited;
  if Length(Trim(DataSet.FieldByName('pgroup').AsString))=0 then
  begin
    ShowMsg('請輸入集團名稱!',48);
    if DBGridEh3.CanFocus then
       DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=DataSet.FieldByName('pgroup');
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('custno').AsString))=0 then
  begin
    ShowMsg('請輸入客戶編號!',48);
    if DBGridEh3.CanFocus then
       DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=DataSet.FieldByName('custno');
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('ad').AsString))=0 then
  begin
    ShowMsg('請輸入膠系或產品別!',48);
    if DBGridEh3.CanFocus then
       DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=DataSet.FieldByName('ad');
    Abort;
  end;
end;

procedure TFrmMPSR140.CDS3AfterPost(DataSet: TDataSet);
begin
  inherited;
  if not CDSPost(CDS3, l_tableLT) then
     CDS3.CancelUpdates;
end;

procedure TFrmMPSR140.CDS3NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Iuser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Idate').AsDateTime:=Now;
end;

procedure TFrmMPSR140.CDS3BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmMPSR140.CDS3BeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmMPSR140.CDS3AfterEdit(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('Muser').AsString:=g_UInfo^.Wk_no;
  DataSet.FieldByName('Mdate').AsDateTime:=Now;
end;

procedure TFrmMPSR140.PopupMenu1Popup(Sender: TObject);
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

procedure TFrmMPSR140.N201Click(Sender: TObject);
begin
  inherited;
  CDS3.Append;
end;

procedure TFrmMPSR140.N202Click(Sender: TObject);
begin
  inherited;
  if ShowMsg('刪除後不可恢複,確定刪除嗎?',33)=IDCancel then
     Exit;

  CDS3.Delete;
  if not CDSPost(CDS3, l_tableLT) then
     CDS3.CancelUpdates;
end;

procedure TFrmMPSR140.N203Click(Sender: TObject);
begin
  inherited;
  CDS3.Edit;
end;

procedure TFrmMPSR140.N204Click(Sender: TObject);
begin
  inherited;
  if CDS3.State in [dsInsert,dsEdit] then
     CDS3.Post;
end;

procedure TFrmMPSR140.N205Click(Sender: TObject);
begin
  inherited;
  if CDS3.State in [dsInsert,dsEdit] then
     CDS3.Cancel;
end;

procedure TFrmMPSR140.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPSR140.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.ColWidthChange;
end;

end.
