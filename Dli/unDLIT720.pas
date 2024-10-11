unit unDLIT720;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI020, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DBCtrlsEh, Mask, DBCtrls, ExtCtrls, Menus, DB, ImgList,
  DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIT720 = class(TFrmSTDI020)
    cno: TLabel;
    DBEdit1: TDBEdit;
    Iuser: TLabel;
    DBEdit4: TDBEdit;
    Idate: TLabel;
    DBEdit5: TDBEdit;
    Muser: TLabel;
    DBEdit6: TDBEdit;
    Mdate: TLabel;
    DBEdit7: TDBEdit;
    cdate: TLabel;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    imgConf: TImage;
    Remark: TLabel;
    DBEdit2: TDBEdit;
    btn_conf: TToolButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDS2BeforeDelete(DataSet: TDataSet);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure btn_cancelClick(Sender: TObject);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure btn_confClick(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_cno,l_sql2:string;
    l_list2:TStrings;
    procedure Conf(flag:string);
    procedure CheckConf;
    procedure CdateChange(Sender: TField);
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS1(strFilter:string);override;
    procedure RefreshDS2;override;
  end;

var
  FrmDLIT720: TFrmDLIT720;

implementation

uses unGlobal, unCommon, unDLIT7XX_units;

const l_FormatStr='D72-YYMMDD999';

{$R *.dfm}

procedure TFrmDLIT720.CheckConf;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if not CDS.IsEmpty then
  begin
    tmpSQL:='select 1 from '+p_MainTableName
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and cno='+Quotedstr(CDS.FieldByName('cno').AsString)
           +' and conf=1';
    if not QueryOneCR(tmpSQL, Data) then
       Abort;

    if VarToStr(Data)='1' then
    begin
      ShowMsg('已確認,不可異動',48);
      Abort;
    end;
  end;
end;

//flag=0/1
procedure TFrmDLIT720.Conf(flag:string);
var
  v:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  DSNE1,DSNE2,DSNE3,DSNE4:TDataSetNotifyEvent;
begin
  if CDS2.IsEmpty then
  begin
    ShowMsg('無明細資料!',48);
    Exit;
  end;

  if (flag='1') and (ShowMsg('確認嗎?',33)=IDCancel) then
     Exit
  else if (flag='0') and (ShowMsg('取消確認嗎?',33)=IDCancel) then
     Exit;

  tmpSQL:='exec [dbo].[proc_DLIT720] '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(CDS.FieldByName('cno').AsString)+','+flag;
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      v:=tmpCDS.Fields[0].AsInteger;
      if v=0 then
      begin
        with CDS do
        begin
          DSNE1:=BeforeEdit;
          DSNE2:=AfterEdit;
          DSNE3:=BeforePost;
          DSNE4:=AfterPost;
          BeforeEdit:=nil;
          AfterEdit:=nil;
          BeforePost:=nil;
          AfterPost:=nil;
          try
            Edit;
            FieldByName('Conf').AsBoolean:=flag='1';
            Post;
            MergeChangeLog;
            imgConf.Visible:=FieldByName('Conf').AsBoolean;
          finally
            BeforeEdit:=DSNE1;
            AfterEdit:=DSNE2;
            BeforePost:=DSNE3;
            AfterPost:=DSNE4;
          end;
        end;
      end
      else if v=-1 then
        ShowMsg('單據不存在!',48)
      else if v=-2 then
        ShowMsg('未確認,不可取消確認!',48)
      else if v=-3 then
        ShowMsg('已確認,不可重復確認!',48)
      else if v=-4 then
        ShowMsg(tmpCDS.Fields[1].AsString+'棧板已做後續作業,不可取消確認!',48)
      else if v=-5 then
        ShowMsg(tmpCDS.Fields[1].AsString+'棧板不可重複入庫!',48)
      else
        ShowMsg('未知參數錯誤,請聯絡系統管理員!',48);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLIT720.CdateChange(Sender: TField);
begin
  if not TField(Sender).IsNull then
     CDS.FieldByName('cno').AsString:=GetNewCno(p_MainTableName,l_FormatStr,TField(Sender).AsDateTime);
end;

procedure TFrmDLIT720.SetToolBar;
begin
  btn_conf.Enabled:=g_MInfo^.R_conf and CDS.Active and (not CDS.IsEmpty) and (not (CDS.State in [dsInsert, dsEdit]));
  inherited;
end;

procedure TFrmDLIT720.RefreshDS1(strFilter:string);
var
  Data:OleVariant;
begin
  if QueryBySQL('select * from '+p_MainTableName+' where bu='+Quotedstr(g_UInfo^.BU)+strFilter, Data) then
     CDS.Data:=Data;
  if CDS.IsEmpty then
     RefreshDS2;

  inherited;
end;

procedure TFrmDLIT720.RefreshDS2;
var
  tmpSQL:string;
begin
  if Assigned(l_list2) then
  begin
    tmpSQL:='Select * From '+p_DetailTableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Cno='+Quotedstr(CDS.FieldByName('Cno').AsString);
    l_list2.Insert(0,tmpSQL);
  end;

  inherited;
end;

procedure TFrmDLIT720.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_MainTableName:='DLI720';
  p_DetailTableName:='DLI721';
  p_GridDesignAns:=True;
  p_FocusCtrl:=DBEdit2;
  btn_conf.Visible:=g_MInfo^.R_conf;
  if g_MInfo^.R_conf then
     btn_conf.Left:=btn_quit.Left;

  inherited;

  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmDLIT720.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
end;

procedure TFrmDLIT720.btn_editClick(Sender: TObject);
begin
  CheckConf;
  inherited;
end;

procedure TFrmDLIT720.btn_deleteClick(Sender: TObject);
begin
  CheckConf;
  inherited;
end;

procedure TFrmDLIT720.btn_cancelClick(Sender: TObject);
begin
  inherited;
  imgConf.Visible:=CDS.FieldByName('Conf').AsBoolean;
end;

procedure TFrmDLIT720.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_MainTableName, tmpStr) then
  begin
    if Length(tmpStr)=0 then
       tmpStr:=' and cdate>getdate()-180';
    RefreshDS1(tmpStr);
  end;
end;

procedure TFrmDLIT720.btn_confClick(Sender: TObject);
begin
  inherited;
  if CDS.FieldByName('Conf').AsBoolean then
     Conf('0')
  else
     Conf('1');
end;

procedure TFrmDLIT720.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('cdate').AsDateTime:=Date;
  DataSet.FieldByName('conf').AsBoolean:=False;
end;

procedure TFrmDLIT720.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('cdate').OnChange:=CdateChange;
end;

procedure TFrmDLIT720.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  isExist:Boolean;
begin
  if DataSet.FieldByName('cdate').IsNull then
  begin
    ShowMsg('請輸入入庫日期!',48);
    if DBDateTimeEditEh1.CanFocus then
       DBDateTimeEditEh1.SetFocus;
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('cno').AsString))=0 then
  begin
    ShowMsg('請輸入入庫單號!',48);
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    Abort;
  end;
  
  if CDS.State in [dsInsert] then
  begin
    tmpSQL:='select 1 from '+p_MainTableName
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and cno='+Quotedstr(CDS.FieldByName('cno').AsString);
    if not QueryExists(tmpSQL, isExist) then
       Abort;

    if isExist then
       CDS.FieldByName('cno').AsString:=GetNewCno(p_MainTableName,l_FormatStr,CDS.FieldByName('cdate').AsDateTime);
  end;

  inherited;
end;

procedure TFrmDLIT720.CDS2BeforePost(DataSet: TDataSet);
begin
  if Length(Trim(DataSet.FieldByName('lot').AsString))=0 then
  begin
    ShowMsg('請輸入棧板編號!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('lot');
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('place').AsString))=0 then
  begin
    ShowMsg('請輸入倉庫!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('place');
    Abort;
  end;

  if Length(Trim(DataSet.FieldByName('area').AsString))=0 then
  begin
    ShowMsg('請輸入儲位!',48);
    if DBGridEh2.CanFocus then
       DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=DataSet.FieldByName('area');
    Abort;
  end;
  
  inherited;
end;

procedure TFrmDLIT720.CDSBeforeInsert(DataSet: TDataSet);
begin
  l_cno:='';
  inherited;
end;

procedure TFrmDLIT720.CDSBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  l_cno:=DataSet.FieldByName('cno').AsString;
end;

procedure TFrmDLIT720.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  l_cno:=DataSet.FieldByName('cno').AsString;
end;

procedure TFrmDLIT720.CDSAfterDelete(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if not SameText(l_cno, DataSet.FieldByName('cno').AsString) then
  begin
    tmpSQL:='delete from '+p_DetailTableName
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and cno='+Quotedstr(l_cno);
    PostBySQL(tmpSQL);
  end;

  if DataSet.IsEmpty then
     imgConf.Visible:=False;
end;

procedure TFrmDLIT720.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if (Length(l_cno)>0) and (not SameText(l_cno, DataSet.FieldByName('cno').AsString)) then
  begin
    tmpSQL:='update '+p_DetailTableName
           +' set cno='+Quotedstr(DataSet.FieldByName('cno').AsString)
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and cno='+Quotedstr(l_cno);
    PostBySQL(tmpSQL);
    RefreshDS2;
  end;
  imgConf.Visible:=DataSet.FieldByName('Conf').AsBoolean;
end;

procedure TFrmDLIT720.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  imgConf.Visible:=DataSet.FieldByName('Conf').AsBoolean;
end;

procedure TFrmDLIT720.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('cno').AsString:=CDS.FieldByName('cno').AsString;
end;

procedure TFrmDLIT720.CDS2BeforeInsert(DataSet: TDataSet);
begin
  CheckConf;
  inherited;
end;

procedure TFrmDLIT720.CDS2BeforeEdit(DataSet: TDataSet);
begin
  CheckConf;
  inherited;
end;

procedure TFrmDLIT720.CDS2BeforeDelete(DataSet: TDataSet);
begin
  CheckConf;
  inherited;
end;

procedure TFrmDLIT720.Timer1Timer(Sender: TObject);
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
