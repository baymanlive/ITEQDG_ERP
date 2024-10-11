unit unSysI060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBase, ImgList, ExtCtrls, DB, DBClient, StdCtrls, ComCtrls,
  ToolWin, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh,
  DBCtrls, Mask, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmSysI060 = class(TFrmBase)
    DBGridEh2: TDBGridEh;
    Panel2: TPanel;
    DBGridEh1: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_otherrpt: TToolButton;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure CDS2AfterScroll(DataSet: TDataSet);
    procedure CDS1NewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure CDS1BeforeInsert(DataSet: TDataSet);
    procedure btn_otherrptClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
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
  FrmSysI060: TFrmSysI060;

implementation

uses unGlobal, unCommon, unSysI060_other;

const l_DetailTableName='Sys_Menu';

{$R *.dfm}

procedure TFrmSysI060.GetCDS1;
var
  tmpSQL:string;
begin
  tmpSQL:='select * from sys_report where bu='+Quotedstr(g_UInfo^.BU)
        +' and procid='+Quotedstr(CDS2.FieldByName('procid').AsString);
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmSysI060.SetToolBar;
begin
  btn_otherrpt.Enabled:=g_MInfo^.R_edit and (not (CDS1.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmSysI060.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select procid,procname,pid,snoasc from sys_menu'
         +' where len(procid)>=6 '+strFilter
         +' order by pid,snoasc';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;

  if CDS2.IsEmpty then
     GetCDS1;

  inherited;
end;

procedure TFrmSysI060.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_TableName:='Sys_Report';
  p_FocusCtrl:=DBGridEh1;
  btn_otherrpt.Left:=btn_quit.Left;
  l_list2:=TStringList.Create;

  inherited;

  SetGrdCaption(DBGridEh1,p_TableName);
  SetGrdCaption(DBGridEh2,l_DetailTableName);
  Timer1.Enabled:=True;
end;

procedure TFrmSysI060.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  FreeAndNil(l_list2);
  CDS2.Active:=False;
  DBGridEh1.Free;
  DBGridEh2.Free;
  inherited;
end;

procedure TFrmSysI060.btn_printClick(Sender: TObject);
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

procedure TFrmSysI060.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出[作業資料]請按[是]'+#13#10+'匯出[報表資料]請按[否]'+#13#10+'[取消]無操作',35) of
    IDYes:GetExportXls(CDS2, l_DetailTableName);
    IDNo:GetExportXls(CDS1, p_TableName);
  end;
end;

procedure TFrmSysI060.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(l_DetailTableName, tmpStr) then
     RefreshDS(tmpStr);
end;

procedure TFrmSysI060.CDS2AfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetCDS1;
end;

procedure TFrmSysI060.CDS1BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if CDS2.IsEmpty then
  begin
    ShowMsg('請選擇作業!',48);
    ABort;
  end;
end;

procedure TFrmSysI060.CDS1NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('procid').AsString:=CDS2.FieldByName('procid').AsString;
  DataSet.FieldByName('def').AsBoolean:=False;
end;

procedure TFrmSysI060.btn_otherrptClick(Sender: TObject);
begin
  inherited;
  FrmSysI060_other:=TFrmSysI060_other.Create(nil);
  try
    FrmSysI060_other.ShowModal;
  finally
    FreeAndNil(FrmSysI060_other);
  end;
end;

procedure TFrmSysI060.Timer1Timer(Sender: TObject);
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
    begin
      CDS1.Data:=Data;
      SetToolBar;
    end;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
