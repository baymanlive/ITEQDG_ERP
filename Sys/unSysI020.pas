unit unSysI020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ExtCtrls, StdCtrls, ComCtrls, ToolWin, ImgList,
  DB, DBClient, StrUtils, Buttons, unDAL;

type
  TFrmSysI020 = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    ToolButton2: TToolButton;
    btn_quit: TToolButton;
    TV: TTreeView;
    Edit2: TEdit;
    pprocid: TLabel;
    Edit3: TEdit;
    pprocname: TLabel;
    Edit4: TEdit;
    procid: TLabel;
    Edit5: TEdit;
    procname: TLabel;
    Panel1: TPanel;
    Edit6: TEdit;
    dllpath: TLabel;
    Edit7: TEdit;
    snoasc: TLabel;
    Bevel1: TBevel;
    Edit1: TEdit;
    nid: TLabel;
    CDS: TClientDataSet;
    Panel2: TPanel;
    Panel3: TPanel;
    btn_openright: TToolButton;
    isexe: TCheckBox;
    ispop: TCheckBox;
    actions: TLabel;
    Edit8: TEdit;
    btn_sp: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TVClick(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_openrightClick(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
  private
    { Private declarations }
    function GetParentTreeNode(PId:Integer):TTreeNode;
    procedure LoadMenu;
    function CheckTxt:Boolean;
  public
    { Public declarations }
  end;

var
  FrmSysI020: TFrmSysI020;

implementation

uses unGlobal, unCommon, unSysI020_Actions;

{$R *.dfm}

//Get Parent Tree Node
function TFrmSysI020.GetParentTreeNode(PId:Integer):TTreeNode;
var
  i:Integer;
begin
  Result:=nil;
  for i:=TV.Items.Count -1 downto 0  do
  begin
    if PMenuInfo(TV.Items[i].Data)^.NId = PId then
    begin
      Result:=TV.Items[i];
      Break;
    end;
  end;
end;

//加載菜單
procedure TFrmSysI020.LoadMenu;
var
  tmpSQL:string;
  P: PMenuInfo;
  tn: TTreeNode;
  Data:OleVariant;
begin
  tmpSQL:='select * from sys_menu order by pid,snoaSC';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
  with CDS do
  while not Eof do
  begin
    tn:=nil;
    if FieldByName('pid').AsInteger>=0 then
    begin
      tn:=GetParentTreeNode(FieldByName('pid').AsInteger);
      if tn=nil then
      begin
        Next;
        Continue;
      end;
    end;

    New(P);
    P^.PId:=FieldByName('pid').AsInteger;
    P^.NId:=FieldByName('nid').AsInteger;
    P^.ProcId:=FieldByName('procId').AsString;
    P^.ProcName:=FieldByName('procname').AsString;
    P^.DllPath:=FieldByName('dllpath').AsString;
    P^.Actions:=FieldByName('actions').AsString;
    P^.SnoAsc:=FieldByName('snoasc').AsInteger;
    P^.IsExe:=FieldByName('isexe').AsBoolean;
    P^.IsPop:=FieldByName('ispop').AsBoolean;
    if tn=nil then
       TV.Items.AddObject(nil, P^.ProcName+'('+P^.ProcId+')'+','+IntToStr(P^.SnoAsc), P)
    else
       TV.Items.AddChildObject(tn, P^.ProcName+'('+P^.ProcId+')'+','+IntToStr(P^.SnoAsc), P);
    Next;
  end;

  CDS.Active:=False;
  if TV.Items.Count>0 then
     TV.Items[0].Expanded:=True;
end;

function TFrmSysI020.CheckTxt:Boolean;
begin
  Result:=False;

  if Length(Edit1.Text)=0 then
  begin
    ShowMsg('請選擇一個作業',48);
    Exit;
  end;

  if Length(Edit4.Text)=0 then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(procid.Caption));
    Edit4.SetFocus;
    Exit;
  end;

  if Length(Edit5.Text)=0 then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(procname.Caption));
    Edit5.SetFocus;
    Exit;
  end;

  Result:=True;
end;

procedure TFrmSysI020.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  Self.Caption:=g_MInfo^.ProcName;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  SetLabelCaption(Self, 'sys_menu');
  pprocid.Caption:=procid.Caption;
  pprocname.Caption:=procname.Caption;
  LoadMenu;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar(''), g_DllHandle, Self.Handle, False);
end;

procedure TFrmSysI020.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:integer;
begin
  inherited;
  for i:=0 to TV.Items.Count-1 do
    Dispose(PMenuInfo(TV.Items[i].Data));
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  CDS.Active:=False;
  g_cbp(PChar(g_MInfo^.ProcId), PChar(g_MInfo^.ProcName), PChar('1'), g_DllHandle, Self.Handle, True);
end;

procedure TFrmSysI020.TVClick(Sender: TObject);
var
  Node:TTreeNode;
  X,Y:Integer;
  ht:THitTests;
  P:PMenuInfo;
begin
  with TV do
  begin
    X:=ScreenToClient(Mouse.CursorPos).X;
    Y:=ScreenToClient(Mouse.CursorPos).Y;
    ht:=GetHitTestInfoAt(X,Y);
    if htOnItem in ht then
    begin
      Node:=GetNodeAt(X,Y);
      if Node<>nil then
      begin
        P:=PMenuInfo(Node.Data);
        Edit1.Text:=IntToStr(P^.NId);
        Edit2.Text:=P^.Procid;
        Edit3.Text:=P^.ProcName;
        Edit4.Text:=P^.Procid;
        Edit5.Text:=P^.ProcName;
        Edit6.Text:=P^.DllPath;
        Edit7.Text:=IntToStr(P^.SnoAsc);
        Edit8.Text:=P^.Actions;
        isexe.Checked:=P^.IsExe;
        ispop.Checked:=P^.IsPop;
      end;
    end;
  end;
end;

procedure TFrmSysI020.btn_insertClick(Sender: TObject);
var
  tmpSQL,fExe,fPop:string;
  pid,sno: Integer;
  tn: TTreeNode;
  P: PMenuInfo;
  Data: OleVariant;
begin
  inherited;
  if not CheckTxt then
     Exit;

  if ShowMsg('確定新增[%s]嗎?',33,Edit5.Text+'('+Edit4.Text+')')=IdCancel then
     Exit;

  sno:=StrToIntDef(Edit7.Text,0);
  if isexe.Checked then
     fExe:='1'
  else
     fExe:='0';
  if ispop.Checked then
     fPop:='1'
  else
     fPop:='0';
  tmpSQL:='if exists(select 1 from sys_menu where procid='+Quotedstr(Edit4.Text)+')'
         +' begin'
         +'    select -1 as ret'
         +'    return'
         +' end'
         +' declare @nid int'
         +' select @nid=isnull(max(nid),0)+1 from sys_menu'
         +' insert into sys_menu(pid,nid,procid,procname,dllpath,actions,snoasc,isexe,ispop)'
         +' values('+Edit1.Text+',@nid,'+Quotedstr(Edit4.Text)+','+Quotedstr(Edit5.Text)+','+Quotedstr(Edit6.Text)+','+Quotedstr(Edit8.Text)+','+IntToStr(sno)+','+fExe+','+fPop+')'
         +' delete from sys_userright where userid in (''ID140622'',''ID150515'') and procid='+Quotedstr(Edit4.Text)
         +' insert into sys_userright(bu,userid,procid,r_visible,r_new,r_edit,'
         +' r_delete,r_copy,r_garbage,r_conf,r_check,r_query,r_print,r_export,r_rptdesign)'
         +' select bu,''ID140622'','+Quotedstr(Edit4.Text)+',1,1,1,1,1,1,1,1,1,1,1,1 from sys_bu'
         +' union all'
         +' select bu,''ID150515'','+Quotedstr(Edit4.Text)+',1,1,1,1,1,1,1,1,1,1,1,1 from sys_bu'
         +' select @nid as ret';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    if CDS.FieldByName('ret').AsInteger=-1 then
    begin
      ShowMsg('[%s]作業代碼已存在!',48,Edit4.Text);
      Exit;
    end;

    pid:=StrToInt(Edit1.Text);
    tn:=GetParentTreeNode(pid);
    New(P);
    P^.PId:=pid;
    P^.NId:=CDS.FieldByName('ret').AsInteger;
    P^.ProcId:=Edit4.Text;
    P^.ProcName:=Edit5.Text;
    P^.DllPath:=Edit6.Text;
    P^.Actions:=Edit8.Text;
    P^.SnoAsc:=sno;
    P^.IsExe:=isexe.Checked;
    P^.IsPop:=ispop.Checked;
    if tn=nil then
       TV.Items.AddObject(nil, P^.ProcName+'('+P^.ProcId+')'+','+IntToStr(P^.SnoAsc), P)
    else
       TV.Items.AddChildObject(tn, P^.ProcName+'('+P^.ProcId+')'+','+IntToStr(P^.SnoAsc), P);
    ShowMsg('新增完畢!',64);
  end;
end;

procedure TFrmSysI020.btn_editClick(Sender: TObject);
var
  tmpSQL,fExe,fPop:string;
  pid,sno: Integer;
  tn: TTreeNode;
  P: PMenuInfo;
  Data: OleVariant;
begin
  inherited;
  if not CheckTxt then
     Exit;

  if ShowMsg('確定更改[%s]嗎?',33,Edit5.Text+'('+Edit4.Text+')')=IdCancel then
     Exit;

  pid:=StrToInt(Edit1.Text);
  sno:=StrToIntDef(Edit7.Text,0);
  if isexe.Checked then
     fExe:='1'
  else
     fExe:='0';
  if ispop.Checked then
     fPop:='1'
  else
     fPop:='0';
  tmpSQL:='declare @ret int set @ret=0';
  if Edit2.Text<>Edit4.Text then
     tmpSQL:=tmpSQL+' if exists(select 1 from sys_menu where procid='+Quotedstr(Edit4.Text)+')'
                   +' set @ret=-1 else';
  tmpSQL:=tmpSQL+' update sys_menu set procid='+Quotedstr(Edit4.Text)
                +',procname='+Quotedstr(Edit5.Text)
                +',dllpath='+Quotedstr(Edit6.Text)
                +',actions='+Quotedstr(Edit8.Text)
                +',snoasc='+IntToStr(sno)
                +',isexe='+fExe
                +',ispop='+fPop
                +' where nid='+IntToStr(pid)
                +' and procid='+Quotedstr(Edit2.Text)
                +' if @ret=0'
                +' update sys_userright set procid='+Quotedstr(Edit4.Text)+' where procid='+Quotedstr(Edit2.Text)
                +' select @ret as ret';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    if CDS.FieldByName('ret').AsInteger=-1 then
    begin
      ShowMsg('[%s]作業代碼已存在!',48,Edit4.Text);
      Exit;
    end;

    tn:=GetParentTreeNode(pid);
    if tn<>nil then
    begin
      P:=PMenuInfo(tn.Data);
      P^.ProcId:=Edit4.Text;
      P^.ProcName:=Edit5.Text;
      P^.DllPath:=Edit6.Text;
      P^.Actions:=Edit8.Text;
      P^.SnoAsc:=sno;
      P^.IsExe:=isexe.Checked;
      P^.IsPop:=ispop.Checked;
      tn.Text:=P^.ProcName+'('+P^.ProcId+')'+','+IntToStr(P^.SnoAsc);
    end;
    ShowMsg('更改完畢!',64);
  end;
end;

procedure TFrmSysI020.btn_deleteClick(Sender: TObject);
var
  tmpSQL:string;
  tn: TTreeNode;
begin
  inherited;
  if Length(Edit1.Text)=0 then
  begin
    ShowMsg('請選擇一個作業',48);
    Exit;
  end;

  tn:=GetParentTreeNode(StrToInt(Edit1.Text));
  if tn<>nil then
  begin
    if PMenuInfo(tn.Data)^.PId<0 then
    begin
      ShowMsg('根目錄,不可刪除!',48);
      Exit;
    end;

    if tn.HasChildren then
    begin
      ShowMsg('存在下級作業,不可刪除!',48);
      Exit;
    end;
  end;

  if ShowMsg('確定刪除[%s]嗎?',33,Edit3.Text+'('+Edit2.Text+')')=IdCancel then
     Exit;

  tmpSQL:='delete from sys_menu where nid='+Edit1.Text+' and procid='+Quotedstr(Edit2.Text)
         +' delete from sys_userright where procid='+Quotedstr(Edit2.Text);
  if PostBySQL(tmpSQL) then
  begin
    if tn<>nil then
    begin
      Dispose(PMenuInfo(tn.Data));
      tn.Delete;
    end;
    Edit1.Text:='';
    Edit2.Text:='';
    Edit3.Text:='';
    Edit4.Text:='';
    Edit5.Text:='';
    Edit6.Text:='';
    Edit7.Text:='';
    Edit8.Text:='';
    isexe.Checked:=False;
    ispop.Checked:=False;
    ShowMsg('刪除完畢!',64);
  end;
end;

procedure TFrmSysI020.btn_quitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmSysI020.btn_openrightClick(Sender: TObject);
begin
  inherited;
  CopyDataSendMsg(g_MainHandle,'Open,SysI030');
end;

procedure TFrmSysI020.btn_spClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmSysI020_Actions) then
     FrmSysI020_Actions:=TFrmSysI020_Actions.Create(Application);
  FrmSysI020_Actions.l_Actions:=Edit8.Text;
  if FrmSysI020_Actions.ShowModal=mrOK then
     Edit8.Text:=FrmSysI020_Actions.l_Actions;
end;

end.
