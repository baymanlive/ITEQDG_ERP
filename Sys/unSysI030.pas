unit unSysI030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI020, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, DB, ImgList, ExtCtrls, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, StdCtrls, ComCtrls, ToolWin, DBCtrls, Mask;

type
  TFrmSysI030 = class(TFrmSTDI020)
    userid: TLabel;
    username: TLabel;
    password: TLabel;
    wk_no: TLabel;
    depart: TLabel;
    room: TLabel;
    title: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    not_use: TDBCheckBox;
    lblsys: TLabel;
    cbb: TComboBox;
    btn_copyright: TToolButton;
    N1: TMenuItem;
    NX: TMenuItem;
    X203: TMenuItem;
    X204: TMenuItem;
    NX1: TMenuItem;
    X201: TMenuItem;
    NX0: TMenuItem;
    X205: TMenuItem;
    X206: TMenuItem;
    X202: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure CDS2AfterPost(DataSet: TDataSet);
    procedure btn_copyrightClick(Sender: TObject);
    procedure cbbChange(Sender: TObject);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDS2BeforeDelete(DataSet: TDataSet);
    procedure CDS2AfterDelete(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure X203Click(Sender: TObject);
    procedure X204Click(Sender: TObject);
    procedure X205Click(Sender: TObject);
    procedure X206Click(Sender: TObject);
    procedure X201Click(Sender: TObject);
    procedure X202Click(Sender: TObject);
  private
    { Private declarations }
    l_userid:string;
    l_CDS:TClientDataSet;
    l_list:TStrings;
    procedure SetCbb;
    function GetProcid:string;
  public
    { Public declarations }
  protected  
    procedure SetToolBar;override;
    procedure RefreshDS1(strFilter:string);override;
    procedure RefreshDS2;override;
  end;

var
  FrmSysI030: TFrmSysI030;

implementation

uses unGlobal, unCommon, unSysI030_CopyRight;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="procid" fieldtype="string.uni" WIDTH="100"/>'
           +'<FIELD attrname="procname" fieldtype="string.uni" WIDTH="200"/>'
           +'<FIELD attrname="r_visible" fieldtype="boolean"/>'
           +'<FIELD attrname="r_new" fieldtype="boolean"/>'
           +'<FIELD attrname="r_edit" fieldtype="boolean"/>'
           +'<FIELD attrname="r_delete" fieldtype="boolean"/>'
           +'<FIELD attrname="r_copy" fieldtype="boolean"/>'
           +'<FIELD attrname="r_garbage" fieldtype="boolean"/>'
           +'<FIELD attrname="r_conf" fieldtype="boolean"/>'
           +'<FIELD attrname="r_check" fieldtype="boolean"/>'
           +'<FIELD attrname="r_query" fieldtype="boolean"/>'
           +'<FIELD attrname="r_print" fieldtype="boolean"/>'
           +'<FIELD attrname="r_export" fieldtype="boolean"/>'
           +'<FIELD attrname="r_rptDesign" fieldtype="boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmSysI030.SetCbb;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpSQL:='select nid,procname from sys_menu'
         +' where pid in (select nid from sys_menu where pid<0) order by pid,snoasc';
  if not QueryBySQL(tmpSQL,Data) then
     Exit;

  Cbb.Tag:=1;
  Cbb.Items.Clear;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    while not tmpCDS.Eof do
    begin
      l_list.Add(tmpCDS.Fields[0].AsString);
      Cbb.Items.Add(tmpCDS.Fields[1].AsString);
      tmpCDS.Next;
    end;
    Cbb.ItemIndex:=-1;
  finally
    FreeAndNil(tmpCDS);
    Cbb.Tag:=0;
  end;
end;

function TFrmSysI030.GetProcid:string;
var
  tmpStr:string;
begin
  Result:='';
  if CDS.IsEmpty then
     Exit;

  CDS2.DisableControls;
  try
    CDS2.First;
    while not CDS2.Eof do
    begin
      tmpStr:=tmpStr+','+Quotedstr(CDS2.FieldByName('procid').AsString);
      CDS2.Next;
    end;
  finally
    CDS2.EnableControls;
  end;

  Delete(tmpStr,1,1);
  Result:=tmpStr;
end;

procedure TFrmSysI030.SetToolBar;
begin
  btn_copyright.Enabled:=g_MInfo^.R_edit and (not (CDS.State in [dsInsert,dsEdit]));
  cbb.Enabled:=not (CDS.State in [dsInsert,dsEdit]);
  inherited;
end;

procedure TFrmSysI030.RefreshDS1(strFilter:string);
var
  Data:OleVariant;
begin
  if QueryBySQL('select * from sys_user where bu='+Quotedstr(g_UInfo^.BU)+strFilter, Data) then
     CDS.Data:=Data;
  if CDS.IsEmpty then
     RefreshDS2;

  inherited;
end;

procedure TFrmSysI030.RefreshDS2;
var
  tmpSQL,tmpProcId:string;
  i,nid:Integer;
  Data:OleVariant;
  tmpCDS1:TClientDataSet;
  tmpList:TStrings;
begin
  l_CDS.EmptyDataSet;
  if (Cbb.ItemIndex<>-1) and (not CDS.IsEmpty) then
  begin
    nid:=StrToInt(l_list.Strings[Cbb.ItemIndex]);
    tmpCDS1:=TClientDataSet.Create(nil);
    tmpList:=TStringList.Create;
    try
      tmpSQL:='select pid,nid,procid,procname from sys_menu'
             +' order by case when pid<0 then ''0'' else procid end';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpProcId:=Quotedstr('@@@');
        tmpList.Add(IntToStr(nid));
        tmpCDS1.Data:=Data;
        while not tmpCDS1.Eof do
        begin
          if (tmpCDS1.FieldByName('pid').AsInteger<0) or
             (tmpCDS1.FieldByName('nid').AsInteger=nid) or
             (tmpList.IndexOf(IntToStr(tmpCDS1.FieldByName('pid').AsInteger))<>-1) then
          begin
            tmpProcId:=tmpProcId+','+Quotedstr(tmpCDS1.FieldByName('procid').AsString);
            if tmpCDS1.FieldByName('pid').AsInteger>0 then
               tmpList.Add(IntToStr(tmpCDS1.FieldByName('nid').AsInteger));
            l_CDS.Append;
            for i:=0 to l_CDS.FieldCount-1 do
              if l_CDS.Fields[i].DataType=ftBoolean then
                 l_CDS.Fields[i].AsBoolean:=False;
            l_CDS.FieldByName('procid').AsString:=tmpCDS1.FieldByName('procid').AsString;
            l_CDS.FieldByName('procname').AsString:=tmpCDS1.FieldByName('procname').AsString;
            l_CDS.Post;
          end;
          tmpCDS1.Next;
        end;

        Data:=null;
        tmpSQL:='select * from sys_userright where bu='+Quotedstr(g_UInfo^.BU)
               +' and userid='+Quotedstr(CDS.FieldByName('UserId').AsString)
               +' and procid in ('+tmpProcId+')';
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS1.Data:=Data;
          while not tmpCDS1.Eof do
          begin
            if l_CDS.Locate('procid',tmpCDS1.FieldByName('procid').AsString,[loCaseInsensitive]) then
            begin
              l_CDS.Edit;
              for i:=0 to l_CDS.FieldCount-1 do
                if l_CDS.Fields[i].DataType=ftBoolean then
                   if tmpCDS1.FindField(l_CDS.Fields[i].FieldName)<>nil then
                      l_CDS.Fields[i].AsBoolean:=tmpCDS1.FieldByName(l_CDS.Fields[i].FieldName).AsBoolean;
              l_CDS.Post;
            end;
            tmpCDS1.Next;
          end;
        end;
      end;

    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpList);
    end;
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;
  CDS2.Data:=l_CDS.Data;
  
  inherited;
end;

procedure TFrmSysI030.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_MainTableName:='Sys_User';
  p_DetailTableName:='Sys_UserRight';
  p_GridDesignAns:=True;
  p_FocusCtrl:=DBEdit1;
  btn_copyright.Left:=btn_quit.Left;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS,g_Xml);

  inherited;

  l_list:=TStringList.Create;
  SetCbb;
end;

procedure TFrmSysI030.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(l_CDS);
  FreeAndNil(l_list);
  inherited;
end;

procedure TFrmSysI030.CDSBeforePost(DataSet: TDataSet);
begin
  if Trim(CDS.FieldByName('userid').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(userid.Caption));
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    Abort;
  end;

  if Trim(CDS.FieldByName('username').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(username.Caption));
    if DBEdit2.CanFocus then
       DBEdit2.SetFocus;
    Abort;
  end;

  if Trim(CDS.FieldByName('password').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(password.Caption));
    if DBEdit3.CanFocus then
       DBEdit3.SetFocus;
    Abort;
  end;

  if Trim(CDS.FieldByName('wk_no').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(wk_no.Caption));
    if DBEdit4.CanFocus then
       DBEdit4.SetFocus;
    Abort;
  end;

  inherited;
end;

procedure TFrmSysI030.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  l_userid:='';
end;

procedure TFrmSysI030.CDSBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  l_userid:=DataSet.FieldByName('userid').AsString;
end;

procedure TFrmSysI030.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  l_userid:=DataSet.FieldByName('userid').AsString;
end;

procedure TFrmSysI030.CDSAfterDelete(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if not SameText(l_userid,DataSet.FieldByName('userid').AsString) then
  begin
    tmpSQL:='delete from '+p_DetailTableName+' where bu='+Quotedstr(g_UInfo^.BU)
           +' and userid='+Quotedstr(l_userid);
    PostBySQL(tmpSQL);
  end;
end;

procedure TFrmSysI030.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  inherited;
  if (Length(l_userid)>0) and (not SameText(l_userid,DataSet.FieldByName('userid').AsString)) then
  begin
    tmpSQL:='update '+p_DetailTableName+' set userid='+Quotedstr(DataSet.FieldByName('userid').AsString)
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and userid='+Quotedstr(l_userid);
    PostBySQL(tmpSQL);
    RefreshDS2;
  end;
end;

procedure TFrmSysI030.CDS2BeforeDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmSysI030.CDS2AfterDelete(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmSysI030.CDS2BeforeInsert(DataSet: TDataSet);
begin
//  inherited;
  Abort;
end;

procedure TFrmSysI030.CDS2BeforePost(DataSet: TDataSet);
begin
//  inherited;
end;

procedure TFrmSysI030.CDS2AfterPost(DataSet: TDataSet);
var
  i:Integer;
  isNone:Boolean;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
//  inherited;
  tmpSQL:='select * from '+p_DetailTableName+' where bu='+Quotedstr(g_UInfo^.BU)
         +' and userid='+Quotedstr(CDS.FieldByName('userid').AsString)
         +' and procid='+Quotedstr(DataSet.FieldByName('procid').AsString);
  if not QueryBySQL(tmpSQL, Data) then
  begin
    if CDS2.ChangeCount>0 then
       CDS2.CancelUpdates;
     Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if isEmpty then
      begin
        Append;
        FieldByName('bu').AsString:=g_UInfo^.BU;
        FieldByName('userid').AsString:=CDS.FieldByName('userid').AsString;
        FieldByName('procid').AsString:=DataSet.FieldByName('procid').AsString;
      end else
        Edit;
      FieldByName('R_visible').AsBoolean:=DataSet.FieldByName('R_visible').AsBoolean;
      FieldByName('R_new').AsBoolean:=DataSet.FieldByName('R_new').AsBoolean;
      FieldByName('R_edit').AsBoolean:=DataSet.FieldByName('R_edit').AsBoolean;
      FieldByName('R_delete').AsBoolean:=DataSet.FieldByName('R_delete').AsBoolean;
      FieldByName('R_copy').AsBoolean:=DataSet.FieldByName('R_copy').AsBoolean;
      FieldByName('R_garbage').AsBoolean:=DataSet.FieldByName('R_garbage').AsBoolean;
      FieldByName('R_conf').AsBoolean:=DataSet.FieldByName('R_conf').AsBoolean;
      FieldByName('R_check').AsBoolean:=DataSet.FieldByName('R_check').AsBoolean;
      FieldByName('R_query').AsBoolean:=DataSet.FieldByName('R_query').AsBoolean;
      FieldByName('R_print').AsBoolean:=DataSet.FieldByName('R_print').AsBoolean;
      FieldByName('R_export').AsBoolean:=DataSet.FieldByName('R_export').AsBoolean;
      FieldByName('R_rptDesign').AsBoolean:=DataSet.FieldByName('R_rptDesign').AsBoolean;
      Post;

      isNone:=True;
      for i:=0 to FieldCount-1 do
      if Fields[i].DataType=ftBoolean then
      if Fields[i].AsBoolean then
      begin
        isNone:=False;
        Break;
      end;

      if isNone then
         Delete;
    end;
    if CDSPost(tmpCDS,p_DetailTableName) then
       CDS2.MergeChangeLog
    else
    if CDS2.ChangeCount>0 then
       CDS2.CancelUpdates;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmSysI030.btn_copyrightClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmSysI030_CopyRight) then
     FrmSysI030_CopyRight:=TFrmSysI030_CopyRight.Create(Application);
  FrmSysI030_CopyRight.l_userid:=CDS.FieldByName('userid').AsString;
  FrmSysI030_CopyRight.ShowModal;
  if FrmSysI030_CopyRight.l_isRefresh then
     RefreshDS2;
end;

procedure TFrmSysI030.cbbChange(Sender: TObject);
begin
  inherited;
  if Cbb.Tag=0 then
     RefreshDS2;
end;

procedure TFrmSysI030.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N201.Visible:=False;
  N202.Visible:=False;
  N206.Visible:=False;
  NX.Visible:=g_MInfo^.R_edit and CDS.Active and (not CDS.IsEmpty) and (not CDS2.IsEmpty);
  if NX.Visible then
     NX.Enabled:=not (CDS2.State in [dsInsert,dsEdit]);
end;

procedure TFrmSysI030.X201Click(Sender: TObject);
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;
  CDS2.Edit;
  CDS2.FieldByName('r_visible').AsBoolean:=True;
  CDS2.FieldByName('r_new').AsBoolean:=False;
  CDS2.FieldByName('r_edit').AsBoolean:=False;
  CDS2.FieldByName('r_delete').AsBoolean:=False;
  CDS2.FieldByName('r_copy').AsBoolean:=False;
  CDS2.FieldByName('r_garbage').AsBoolean:=False;
  CDS2.FieldByName('r_conf').AsBoolean:=False;
  CDS2.FieldByName('r_check').AsBoolean:=False;
  CDS2.FieldByName('r_query').AsBoolean:=True;
  CDS2.FieldByName('r_print').AsBoolean:=True;
  CDS2.FieldByName('r_export').AsBoolean:=True;
  CDS2.FieldByName('r_rptdesign').AsBoolean:=False;
  CDS2.Post;
end;

procedure TFrmSysI030.X202Click(Sender: TObject);
var
  tmpSQL,tmpProcId:string;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;
  tmpProcId:=GetProcid;
  tmpSQL:='delete from '+p_DetailTableName
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and userid='+Quotedstr(CDS.FieldByName('userid').AsString)
         +' and procid in ('+tmpProcId+')';
  if PostBySQL(tmpSQL) then
  begin
    tmpSQL:='insert into '+p_DetailTableName+'(bu,userid,procid,r_visible,r_new,r_edit,'
           +' r_delete,r_copy,r_garbage,r_conf,r_check,r_query,r_print,r_export,r_rptdesign)'
           +' select '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(CDS.FieldByName('userid').AsString)
           +' ,procid,1,0,0,0,0,0,0,0,1,1,1,0'
           +' from sys_menu where procid in ('+tmpProcId+')';
    PostBySQL(tmpSQL);
  end;
  RefreshDS2;
end;

procedure TFrmSysI030.X203Click(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;
  CDS2.Edit;
  for i:=0 to CDS2.FieldCount-1 do
  if CDS2.Fields[i].DataType=ftBoolean then
     CDS2.Fields[i].AsBoolean:=True;
  CDS2.Post;
end;

procedure TFrmSysI030.X204Click(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;
  CDS2.Edit;
  for i:=0 to CDS2.FieldCount-1 do
  if CDS2.Fields[i].DataType=ftBoolean then
     CDS2.Fields[i].AsBoolean:=False;
  CDS2.Post;
end;

procedure TFrmSysI030.X205Click(Sender: TObject);
var
  tmpSQL,tmpProcId:string;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;
  tmpProcId:=GetProcid;
  tmpSQL:='delete from '+p_DetailTableName
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and userid='+Quotedstr(CDS.FieldByName('userid').AsString)
         +' and procid in ('+tmpProcId+')';
  if PostBySQL(tmpSQL) then
  begin
    tmpSQL:='insert into '+p_DetailTableName+'(bu,userid,procid,r_visible,r_new,r_edit,'
           +' r_delete,r_copy,r_garbage,r_conf,r_check,r_query,r_print,r_export,r_rptdesign)'
           +' select '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(CDS.FieldByName('userid').AsString)
           +' ,procid,1,1,1,1,1,1,1,1,1,1,1,1'
           +' from sys_menu where procid in ('+tmpProcId+')';
    PostBySQL(tmpSQL);
  end;
  RefreshDS2;
end;

procedure TFrmSysI030.X206Click(Sender: TObject);
var
  tmpSQL:string;
begin
  inherited;
  if CDS2.IsEmpty then
     Exit;  
  tmpSQL:='delete from '+p_DetailTableName
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and userid='+Quotedstr(CDS.FieldByName('userid').AsString)
         +' and procid in ('+GetProcid+')';
  if PostBySQL(tmpSQL) then
     RefreshDS2;
end;

end.
