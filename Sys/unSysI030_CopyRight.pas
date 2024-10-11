unit unSysI030_CopyRight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmSysI030_CopyRight = class(TFrmSTDI051)
    SourceId: TLabel;
    DestId: TLabel;
    Cbb1: TComboBox;
    Cbb2: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Cbb1Change(Sender: TObject);
    procedure Cbb2Change(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
    l_userid:string;
    l_isRefresh:Boolean;    
  end;

var
  FrmSysI030_CopyRight: TFrmSysI030_CopyRight;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmSysI030_CopyRight.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  l_isRefresh:=False;
  Cbb1.Tag:=1;
  Cbb2.Tag:=1;
  Cbb1.Items.Clear;
  Cbb2.Items.Clear;
  tmpSQL:='Select UserId,UserName From Sys_User Where isnull(not_use,0)=0'
         +' and Bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
  begin
    l_CDS.Data:=Data;
    with l_CDS do
    while not Eof do
    begin
      Cbb1.Items.Add(Fields[0].AsString);
      Cbb2.Items.Add(Fields[0].AsString);
      Next;
    end;
  end;
  Cbb1.ItemIndex:=Cbb1.Items.IndexOf(l_userid);
  Cbb2.ItemIndex:=Cbb1.ItemIndex;
  Cbb1.Tag:=0;
  Cbb2.Tag:=0;
  Cbb1Change(Cbb1);
  Cbb2Change(Cbb2);
end;

procedure TFrmSysI030_CopyRight.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
begin
//  inherited;

  if (Cbb1.ItemIndex=-1) or (Cbb2.ItemIndex=-1) then
  begin
    ShowMsg('請選擇帳號!', 48);
    Exit;
  end;

  if Cbb1.ItemIndex=Cbb2.ItemIndex then
  begin
    ShowMsg('請選擇不同的帳號!', 48);
    Exit;
  end;

  if ShowMsg('確定複製嗎?', 33)=IdCancel then
     Exit;

  if (not l_isRefresh) and SameText(l_userid, Cbb2.Text) then
     l_isRefresh:=True;

  tmpSQL:='Delete From Sys_UserRight Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And UserId='+Quotedstr(Cbb2.Text)
         +' Insert Into Sys_UserRight (Bu,UserId,ProcId,R_visible,R_new,R_edit,'
         +' R_delete,R_copy,R_garbage,R_conf,R_check,R_query,R_print,R_export,R_rptDesign)'
         +' Select Bu,'+Quotedstr(Cbb2.Text)+',ProcId,R_visible,R_new,R_edit,'
         +' R_delete,R_copy,R_garbage,R_conf,R_check,R_query,R_print,R_export,R_rptDesign'
         +' From Sys_UserRight Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And UserId='+Quotedstr(Cbb1.Text);
  if PostBySQL(tmpSQL) then
     ShowMsg('複製成功!', 64);
end;

procedure TFrmSysI030_CopyRight.FormCreate(Sender: TObject);
begin
  inherited;
  l_CDS:=TClientDataSet.Create(Self);
end;

procedure TFrmSysI030_CopyRight.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmSysI030_CopyRight.Cbb1Change(Sender: TObject);
begin
  inherited;
  if l_CDS.Active and l_CDS.Locate('userid',Cbb1.Items.Strings[Cbb1.ItemIndex],[]) then
     Label1.Caption:=l_CDS.FieldByName('username').AsString
  else
     Label1.Caption:='';
end;

procedure TFrmSysI030_CopyRight.Cbb2Change(Sender: TObject);
begin
  inherited;
  if l_CDS.Active and l_CDS.Locate('userid',Cbb2.Items.Strings[Cbb2.ItemIndex],[]) then
     Label2.Caption:=l_CDS.FieldByName('username').AsString
  else
     Label2.Caption:='';
end;

end.
