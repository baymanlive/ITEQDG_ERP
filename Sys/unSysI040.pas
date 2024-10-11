unit unSysI040;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBase, ImgList, ExtCtrls, DB, DBClient, StdCtrls, ComCtrls,
  ToolWin, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  DBCtrls, Mask, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmSysI040 = class(TFrmBase)
    DBGridEh2: TDBGridEh;
    Panel2: TPanel;
    DBGridEh1: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_refreshfieldname: TToolButton;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure CDS2AfterScroll(DataSet: TDataSet);
    procedure CDS1NewRecord(DataSet: TDataSet);
    procedure btn_refreshfieldnameClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure CDS1BeforeInsert(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_bool2:Boolean;
    l_sql2:string;
    l_list2:TStrings;
    procedure GetCDS1;
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmSysI040: TFrmSysI040;

implementation

uses unGlobal, unCommon;

const l_DetailTableName='Sys_Table';

{$R *.dfm}

procedure TFrmSysI040.GetCDS1;
var
  tmpSQL:string;
begin
  tmpSQL:='select * from sys_tabledetail'
        +' where tablename='+Quotedstr(CDS2.FieldByName('tablename').AsString);
  if l_bool2 then
     tmpSQL:=tmpSQL+' ';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmSysI040.SetToolBar;
begin
  btn_refreshfieldname.Enabled:=g_MInfo^.R_edit and (not (CDS1.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmSysI040.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='declare @t table(tablename nvarchar(50),remark nvarchar(100),flag int)'
         +' insert into @t select * from'
         +' (select a.[name] as tablename,b.remark,0 as flag'
         +' from sysobjects a left join sys_table b'
         +' on a.[name]=b.tablename'
         +' where a.xtype=N''U'' and [name]<>''dtproperties'''
         +' union all'
         +' select tablename,remark,1 as flag from sys_table where tablename not in'
         +' (select name from sysobjects where xtype=''U'')) x where 1=1 '+strFilter
         +' order by flag,tablename'
         +' select * from @t';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;

  if CDS2.IsEmpty then
     GetCDS1;

  inherited;
end;

procedure TFrmSysI040.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_TableName:='Sys_TableDetail';
  p_FocusCtrl:=DBGridEh1;
  btn_refreshfieldname.Left:=btn_quit.Left;
  l_list2:=TStringList.Create;

  inherited;

  SetGrdCaption(DBGridEh1,p_TableName);
  SetGrdCaption(DBGridEh2,l_DetailTableName);
  Timer1.Enabled:=True;
end;

procedure TFrmSysI040.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  FreeAndNil(l_list2);
  CDS2.Active:=False;
  DBGridEh1.Free;
  DBGridEh2.Free;
  inherited;
end;

procedure TFrmSysI040.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  SetLength(ArrPrintData, 2);
  ArrPrintData[0].Data:=CDS2.Data;
  ArrPrintData[0].RecNo:=CDS2.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS2.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS2.Filter;
  ArrPrintData[1].Data:=CDS1.Data;
  ArrPrintData[1].RecNo:=CDS1.RecNo;
  ArrPrintData[1].IndexFieldNames:=CDS1.IndexFieldNames;
  ArrPrintData[1].Filter:=CDS1.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmSysI040.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出[資料表]請按[是]'+#13#10+'匯出[欄位資料]請按[否]'+#13#10+'[取消]無操作',35) of
    IDYes:GetExportXls(CDS2, l_DetailTableName);
    IDNo:GetExportXls(CDS1, p_TableName);
  end;
end;

procedure TFrmSysI040.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(l_DetailTableName, tmpStr) then
     RefreshDS(tmpStr);
end;

procedure TFrmSysI040.btn_refreshfieldnameClick(Sender: TObject);
var
  tmpSQL,tmpTb:string;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;

  tmpTb:=Quotedstr(CDS2.FieldByName('tablename').AsString);
  tmpSQL:='insert into sys_tabledetail(tablename,fieldname,width,'
         +' ispk,isprint,isexport,isquery,iuser,idate)'
         +' select '+tmpTb
         +',[name],80,0,0,0,0,'+quotedstr(g_uinfo^.userid)
         +','+quotedstr(formatdatetime(g_clongtimesp,now))+' from syscolumns'
         +' where id in(select id from sysobjects where [name]='+tmpTb+')'
         +' and not exists(select 1 from sys_tabledetail'
         +' where tablename='+tmpTb+' and fieldname=[name])';
  if PostBySQL(tmpSQL) then
  begin
    l_bool2:=True;
    try
      GetCDS1;
    finally
      l_bool2:=False;
    end;
  end;
end;

procedure TFrmSysI040.CDS2BeforeInsert(DataSet: TDataSet);
begin
  //inherited;
  Abort;
end;

procedure TFrmSysI040.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  DBGridEh1.FieldColumns['typename'].Visible:=CDS2.FieldByName('flag').AsInteger=1;
  GetCDS1;
end;

procedure TFrmSysI040.CDS1NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('tablename').AsString:=CDS2.FieldByName('tablename').AsString;
  DataSet.FieldByName('ispk').AsBoolean:=False;
  DataSet.FieldByName('isquery').AsBoolean:=False;
  DataSet.FieldByName('isexport').AsBoolean:=False;
  DataSet.FieldByName('isprint').AsBoolean:=False;
end;

procedure TFrmSysI040.CDS1BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if CDS2.IsEmpty then
  begin
    ShowMsg('請選擇資料表!',48);
    ABort;
  end;
end;

procedure TFrmSysI040.CDS2AfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select * from '+l_DetailTableName
         +' where tablename='+Quotedstr(DataSet.FieldByName('tablename').AsString);
  if QueryBySQl(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
       if IsEmpty then
       begin
         Append;
         FieldByName('tablename').AsString:=DataSet.FieldByName('tablename').AsString;
         FieldByName('iuser').AsString:=g_UInfo^.UserId;
         FieldByName('idate').AsDateTime:=Now;
       end else
       begin
         Edit;
         FieldByName('muser').AsString:=g_UInfo^.UserId;
         FieldByName('mdate').AsDateTime:=Now;
       end;
       FieldByName('remark').AsString:=DataSet.FieldByName('remark').AsString;
       Post;
      end;
      if CDSPost(tmpCDS, l_DetailTableName) then
         CDS2.MergeChangeLog
      else if CDS2.ChangeCount>0 then
         CDS2.CancelUpdates;
    finally
      FreeAndNil(tmpCDS);
    end;
  end
  else if CDS2.ChangeCount>0 then
     CDS2.CancelUpdates;
end;

procedure TFrmSysI040.Timer1Timer(Sender: TObject);
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
    begin
      CDS1.Data:=Data;
      SetToolBar;
    end;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
