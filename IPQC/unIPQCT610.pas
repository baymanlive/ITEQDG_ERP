unit unIPQCT610;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI020, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, DB, ImgList, ExtCtrls, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, StdCtrls, ComCtrls, ToolWin, DBCtrls, Mask;

type
  TFrmIPQCT610 = class(TFrmSTDI020)
    ad: TLabel;
    ver: TLabel;
    DBEdit1: TDBEdit;
    DBEdit5: TDBEdit;
    N1: TMenuItem;
    ConfUser: TLabel;
    Confdate: TLabel;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    iuser: TLabel;
    idate: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    muser: TLabel;
    mdate: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    btn_conf: TToolButton;
    imgConf: TImage;
    N2011: TMenuItem;
    sg1: TLabel;
    DBEdit4: TDBEdit;
    DBEdit6: TDBEdit;
    sg2: TLabel;
    DBEdit11: TDBEdit;
    sg3: TLabel;
    cz1: TLabel;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    cz2: TLabel;
    DBEdit14: TDBEdit;
    cz3: TLabel;
    Niandu: TLabel;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    Xidu: TLabel;
    DBEdit17: TDBEdit;
    CL: TLabel;
    br: TLabel;
    DBEdit18: TDBEdit;
    remark: TLabel;
    DBEdit19: TDBEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDS2BeforeDelete(DataSet: TDataSet);
    procedure CDS2AfterDelete(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N2011Click(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_confClick(Sender: TObject);
    procedure CDS2NewRecord(DataSet: TDataSet);
    procedure N206Click(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure CDS2BeforeEdit(DataSet: TDataSet);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_ad,l_ver,l_sql2:string;
    l_list2:TStrings;
    function CheckConf:Boolean;
  public
    { Public declarations }
  protected  
    procedure SetToolBar;override;
    procedure RefreshDS1(strFilter:string);override;
    procedure RefreshDS2;override;
  end;

var
  FrmIPQCT610: TFrmIPQCT610;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT610.SetToolBar;
begin
  btn_conf.Enabled:=CDS.Active and (not CDS.IsEmpty) and (not (CDS.State in [dsInsert,dsEdit])) and g_MInfo^.R_conf;
  inherited;
end;

procedure TFrmIPQCT610.RefreshDS1(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select * from ipqc610 where bu='+Quotedstr(g_UInfo^.BU)+strFilter
         +' order by isnull(conf,0) desc,ad,ver';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
  if CDS.IsEmpty then
  begin
    imgConf.Visible:=False;
    RefreshDS2;
  end;

  inherited;
end;

procedure TFrmIPQCT610.RefreshDS2;
var
  tmpSQL:string;
begin
  if Assigned(l_list2) then
  begin
    tmpSQL:='select * from ipqc611 where bu='+Quotedstr(g_UInfo^.BU)
           +' and ad='+Quotedstr(CDS.FieldByName('ad').AsString)
           +' and ver='+Quotedstr(CDS.FieldByName('ver').AsString)
           +' order by sno';
    l_list2.Insert(0,tmpSQL);
  end;

  inherited;
end;

function TFrmIPQCT610.CheckConf:Boolean;
var
  tmpSQL:string;
  isExists:Boolean;
begin
  Result:=True;

  tmpSQL:='select bu from ipqc610 where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(CDS.FieldByName('ad').AsString)
         +' and ver='+Quotedstr(CDS.FieldByName('ver').AsString)
         +' and conf=1';
  if not QueryExists(tmpSQL, isExists) then
     Exit;

  if isExists then
  begin
    ShowMsg('單據已確認,不可異動!',48);
    Exit;
  end;

  Result:=False;
end;

procedure TFrmIPQCT610.FormCreate(Sender: TObject);
begin
  p_SysId:='ipqc';
  p_MainTableName:='ipqc610';
  p_DetailTableName:='ipqc611';
  p_GridDesignAns:=False;
  p_FocusCtrl:=DBEdit1;
  btn_quit.Left:=btn_conf.Left+btn_conf.Width;

  inherited;

  N2011.Caption:=CheckLang('插入');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmIPQCT610.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
end;

procedure TFrmIPQCT610.btn_editClick(Sender: TObject);
begin
  if CheckConf then
     Exit;
  inherited;
end;

procedure TFrmIPQCT610.btn_deleteClick(Sender: TObject);
begin
  if CheckConf then
     Exit;
  inherited;
end;

procedure TFrmIPQCT610.btn_copyClick(Sender: TObject);
var
  tmpAd,tmpVer_1,tmpVer_2,tmpSQL:string;
begin
  if CDS.IsEmpty then
     Exit;

  tmpAd:=CDS.FieldByName('ad').AsString;
  tmpVer_1:=CDS.FieldByName('ver').AsString;
  if ShowMsg('複製一份[%s]嗎?',33,tmpAd+'-'+tmpVer_1)=IDCancel then
     Exit;

  inherited;

  tmpVer_2:=FormatDateTime('HHNNSSZZZ',now);
  CDS.FieldByName('ver').AsString:=tmpVer_2;
  CDS.Post;

  tmpSQL:=StringReplace(FormatDateTime(g_cShortDate,now),'/','-',[rfReplaceAll]);
  tmpSQL:='insert into '+p_DetailTableName+'(bu,ad,ver,sno,item,listpno,kg,keep,diff,istext,iuser,idate)'
         +' select bu,'+Quotedstr(tmpAd)+','+Quotedstr(tmpVer_2)+',sno,item,listpno,kg,keep,diff,istext,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(tmpSQL)
         +' from '+p_DetailTableName+' where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(tmpAd)
         +' and ver='+Quotedstr(tmpVer_1);
  if not PostBySQL(tmpsQL) then
     Exit;

  RefreshDS2;
end;

procedure TFrmIPQCT610.CDSBeforePost(DataSet: TDataSet);
begin
  if Trim(CDS.FieldByName('ad').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ad.Caption));
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    Abort;
  end;

  if Trim(CDS.FieldByName('ver').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ver.Caption));
    if DBEdit5.CanFocus then
       DBEdit5.SetFocus;
    Abort;
  end;

  inherited;
end;

procedure TFrmIPQCT610.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  l_ad:='';
  l_ver:='';
end;

procedure TFrmIPQCT610.CDSBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  l_ad:=DataSet.FieldByName('ad').AsString;
  l_ver:=DataSet.FieldByName('ver').AsString;
end;

procedure TFrmIPQCT610.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  l_ad:=DataSet.FieldByName('ad').AsString;
  l_ver:=DataSet.FieldByName('ver').AsString;
end;

procedure TFrmIPQCT610.CDSAfterDelete(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if (not SameText(l_ad,DataSet.FieldByName('ad').AsString)) or
     (not SameText(l_ver,DataSet.FieldByName('ver').AsString)) then
  begin
    tmpSQL:='delete from '+p_DetailTableName
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and ad='+Quotedstr(l_ad)
           +' and ver='+Quotedstr(l_ver);
    PostBySQL(tmpSQL);
  end;

  if DataSet.IsEmpty then
     imgConf.Visible:=False;
end;

procedure TFrmIPQCT610.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if ((Length(l_ad)>0) and (not SameText(l_ad,DataSet.FieldByName('ad').AsString))) or
     ((Length(l_ver)>0) and (not SameText(l_ver,DataSet.FieldByName('ver').AsString))) then
  begin
    tmpSQL:='update '+p_DetailTableName
           +' set ad='+Quotedstr(DataSet.FieldByName('ad').AsString)
           +',ver='+Quotedstr(DataSet.FieldByName('ver').AsString)
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and ad='+Quotedstr(l_ad)
           +' and ver='+Quotedstr(l_ver);
    PostBySQL(tmpSQL);
    RefreshDS2;
  end;

  imgConf.Visible:=DataSet.FieldByName('Conf').AsBoolean;
end;

procedure TFrmIPQCT610.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  imgConf.Visible:=DataSet.FieldByName('Conf').AsBoolean;
end;

procedure TFrmIPQCT610.CDS2BeforeDelete(DataSet: TDataSet);
begin
  if CheckConf then
     Abort;
  inherited;
end;

procedure TFrmIPQCT610.CDS2AfterDelete(DataSet: TDataSet);
begin
  inherited;
  RefreshSno(CDS2,p_DetailTableName,'ad+''@''+ver',CDS.FieldByName('ad').AsString+'@'+CDS.FieldByName('ver').AsString);
end;

procedure TFrmIPQCT610.CDS2BeforeEdit(DataSet: TDataSet);
begin
  if CheckConf then
     Abort;
  inherited;
end;

procedure TFrmIPQCT610.CDS2BeforeInsert(DataSet: TDataSet);
begin
  if CheckConf then
     Abort;
  inherited;
end;

procedure TFrmIPQCT610.CDS2BeforePost(DataSet: TDataSet);
begin
  if Length(Trim(DataSet.FieldByName('item').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]!',48,DBGridEh2.FieldColumns['item'].Title.Caption);
    Abort;
  end;

  if DataSet.FieldByName('istext').AsBoolean then
  begin
    if (not DataSet.FieldByName('kg').IsNull) or (not DataSet.FieldByName('diff').IsNull) then
    begin
      ShowMsg('選中['+DBGridEh2.FieldColumns['istext'].Title.Caption
             +'],不用輸入['+DBGridEh2.FieldColumns['kg'].Title.Caption
             +','+DBGridEh2.FieldColumns['diff'].Title.Caption+']',48);
      Abort;
    end;
  end else
  begin
    if DataSet.FieldByName('kg').IsNull or DataSet.FieldByName('diff').IsNull then
    begin
      ShowMsg('未選中['+DBGridEh2.FieldColumns['istext'].Title.Caption
             +'],請輸入['+DBGridEh2.FieldColumns['kg'].Title.Caption
             +','+DBGridEh2.FieldColumns['diff'].Title.Caption+']',48);
      Abort;
    end;
  end;

  //inherited;
end;

procedure TFrmIPQCT610.CDS2NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('ad').AsString:=CDS.FieldByName('ad').AsString;
  DataSet.FieldByName('ver').AsString:=CDS.FieldByName('ver').AsString;
  DataSet.FieldByName('sno').AsInteger:=DataSet.RecordCount+1;
end;

procedure TFrmIPQCT610.PopupMenu1Popup(Sender: TObject);
begin
  if (not CDS.Active) or CDS.IsEmpty or CDS.FieldByName('conf').AsBoolean then
  begin
    N201.Visible:=False;
    N2011.Visible:=False;
    N202.Visible:=False;
    N203.Visible:=False;
    N204.Visible:=False;
    N205.Visible:=False;
    N206.Visible:=False;
    Exit;
  end;

  inherited;

  N2011.Visible:=N201.Visible;
  N2011.Enabled:=N201.Enabled;
end;

procedure TFrmIPQCT610.N206Click(Sender: TObject);
begin
  inherited;
  if CDS2.State=dsInsert then
     CDS2.FieldByName('Sno').AsInteger:=CDS2.RecordCount+1;
end;

procedure TFrmIPQCT610.N2011Click(Sender: TObject);
begin
  inherited;
  if CheckConf then
     Exit;
  InsertRec(CDS2);
end;

procedure TFrmIPQCT610.btn_confClick(Sender: TObject);
{var
  tmpSQL,tmpAd,tmpVer:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  DSNE1,DSNE2,DSNE3,DSNE4,DSNE5,DSNE6:TDataSetNotifyEvent; }
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇單據!',48);
    Exit;
  end;

  if CDS2.State in [dsInsert,dsEdit] then
     CDS2.Post;

  tmpSQL:='select iuser,muser from '+p_MainTableName
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(CDS.FieldByName('ad').AsString)
         +' and ver='+Quotedstr(CDS.FieldByName('ver').AsString);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('此筆資料不存在!',48);
      Exit;
    end;

    if SameText(tmpCDS.FieldByName('iuser').AsString,g_UInfo^.UserId) or
       SameText(tmpCDS.FieldByName('muser').AsString,g_UInfo^.UserId) then
    begin
      ShowMsg('確認人員不可同時是新增人員或修改人員!',48);
      Exit;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  if not CheckAsyncConf(CDS.FieldByName('conf').AsBoolean,p_MainTableName,'ad+''@''+ver',CDS.FieldByName('ad').AsString+'@'+CDS.FieldByName('ver').AsString,False) then
     Exit;

  SetConf(CDS, p_MainTableName);
  imgConf.Visible:=CDS.FieldByName('conf').AsBoolean;

  { 以下取消同膠系其它版本的確認
  if not CDS.FieldByName('conf').AsBoolean then
     Exit;

  tmpAd:=CDS.FieldByName('ad').AsString;
  tmpVer:=CDS.FieldByName('ver').AsString;
  tmpSQL:='select * from '+p_MainTableName
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and ad='+Quotedstr(tmpAd)
         +' and ver<>'+Quotedstr(tmpVer);
  if not QueryBySQL(tmpSQL,Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;

    while not tmpCDS.Eof do
    begin
      tmpCDS.Edit;
      tmpCDS.FieldByName('conf').AsBoolean:=False;
      tmpCDS.FieldByName('confuser').Clear;
      tmpCDS.FieldByName('confdate').Clear;
      tmpCDS.Post;
      tmpCDS.Next;
    end;

    if not CDSPost(tmpCDS,p_MainTableName) then
       Exit;

    with CDS do
    begin
      DSNE1:=BeforeEdit;
      DSNE2:=AfterEdit;
      DSNE3:=BeforePost;
      DSNE4:=AfterPost;
      DSNE5:=BeforeScroll;
      DSNE6:=AfterScroll;
      BeforeEdit:=nil;
      AfterEdit:=nil;
      BeforePost:=nil;
      AfterPost:=nil;
      BeforeScroll:=nil;
      AfterScroll:=nil;
      DisableControls;
      try
        tmpCDS.First;
        while not tmpCDS.Eof do
        begin
          if Locate('ad;ver',VarArrayOf([tmpCDS.FieldByName('ad').AsString,tmpCDS.FieldByName('ver').AsString]),[loCaseInsensitive]) then
          begin
            Edit;
            FieldByName('conf').AsBoolean:=False;
            FieldByName('confuser').Clear;
            FieldByName('confdate').Clear;
            Post;
            MergeChangeLog;
          end;
          tmpCDS.Next;
        end;
      finally
        Locate('ad;ver',VarArrayOf([tmpAd,tmpVer]),[loCaseInsensitive]);
        BeforeEdit:=DSNE1;
        AfterEdit:=DSNE2;
        BeforePost:=DSNE3;
        AfterPost:=DSNE4;
        BeforeScroll:=DSNE5;
        AfterScroll:=DSNE6;
        EnableControls;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
  end; }
end;

procedure TFrmIPQCT610.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if SameText(Column.FieldName,'conf') and btn_conf.Visible and btn_conf.Enabled then
  begin
    if CDS2.State in [dsInsert,dsEdit] then
       CDS2.Post;

    if not CheckAsyncConf(CDS.FieldByName('conf').AsBoolean,p_MainTableName,'ad+''@''+ver',CDS.FieldByName('ad').AsString+'@'+CDS.FieldByName('ver').AsString,False) then
       Exit;

    SetConf(CDS, p_MainTableName);
    imgConf.Visible:=CDS.FieldByName('conf').AsBoolean;
  end;
end;

procedure TFrmIPQCT610.Timer1Timer(Sender: TObject);
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
