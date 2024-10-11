unit unFavorite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ImgList, StdCtrls, CheckLst, ExtCtrls, DB, DBClient,
  Buttons, StrUtils;

type
  PMenuObj = ^TMenuObj;
  TMenuObj = record
    NId       : Integer;
    ProcId,
    ProcName  : string;
end;

type
  TFrmFavorite = class(TFrmBaseEmpty)
    CLB: TCheckListBox;
    Panel1: TPanel;
    LB: TListBox;
    cbb: TComboBox;
    CDS: TClientDataSet;
    btn_up: TSpeedButton;
    btn_down: TSpeedButton;
    lblsys: TLabel;
    Edit1: TEdit;
    btn_qfind: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure cbbChange(Sender: TObject);
    procedure CLBClickCheck(Sender: TObject);
    procedure btn_upClick(Sender: TObject);
    procedure btn_downClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LBDblClick(Sender: TObject);
    procedure btn_qfindClick(Sender: TObject);
  private
    { Private declarations }
    l_cbbIndex:Integer;
    procedure SetCLB;
    procedure LoadFavorite;
    procedure RefreshFavorite;
  public
    { Public declarations }
  end;

var
  FrmFavorite: TFrmFavorite;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmFavorite.SetCLB;
var
  tmpSQL:string;
  NId:Integer;
  Data:OleVariant;
begin
  CLB.Clear;
  if cbb.ItemIndex=-1 then
     NId:=-999
  else
     NId:=PMenuObj(cbb.Items.Objects[cbb.ItemIndex])^.NId;

  tmpSQL:='Declare @t Table(PId int,ProcId nvarchar(50),ProcName nvarchar(50),SnoASC int)'
         +' ;with cte as(Select NId from Sys_Menu Where PId='+IntToStr(NId)
         +' Union All'
         +' Select B.NId From cte A join Sys_Menu B on A.NId=B.PId)'
         +' Insert Into @t'
         +' Select Sys_Menu.PId,Sys_Menu.ProcId,Sys_Menu.ProcName,Sys_Menu.SnoASC'
         +' From cte C join Sys_Menu on C.NId=Sys_Menu.NId'
         +' Select A.ProcId,A.ProcName From  @t A,Sys_UserRight B'
         +' Where A.ProcId=B.ProcId'
         +' And B.Bu='+Quotedstr(g_UInfo^.BU)
         +' And B.UserId='+Quotedstr(g_UInfo^.UserId)
         +' And B.R_visible=1'
         +' Order By A.PId,A.SnoASC';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    while not CDS.Eof do
    begin
      tmpSQL:=CDS.Fields[1].AsString+'('+CDS.Fields[0].AsString+')';
      CLB.Items.Add(tmpSQL);
      if LB.Items.IndexOf(tmpSQL)<>-1 then
         CLB.Checked[CLB.Items.Count-1]:=True;
      CDS.Next;
    end;
  end;
end;

procedure TFrmFavorite.LoadFavorite;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select A.ProcId,B.ProcName From Sys_Favorite A,Sys_Menu B'
         +' Where A.ProcId=B.ProcId'
         +' And A.Bu='+Quotedstr(g_UInfo^.BU)
         +' And A.UserId='+Quotedstr(g_UInfo^.UserId)
         +' Order By A.SnoAsc,B.SnoAsc';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  CDS.Data:=Data;
  with CDS do
  while not Eof do
  begin
    LB.Items.Add(CDS.Fields[1].AsString+'('+CDS.Fields[0].AsString+')');
    Next;
  end;
end;

procedure TFrmFavorite.RefreshFavorite;
var
  i,pos1:Integer;
  tmpSQL:string;
  Data:OleVariant;

  //找substr在s中最後出現位置
  function ReversePos(SubStr, S: String):Integer;
  var
    j:Integer;
  begin
    j:=Pos(ReverseString(SubStr), ReverseString(S));
    if j>0 then
       j:=Length(S)-j-Length(SubStr)+2;
    Result:=j;
  end;
begin
  tmpSQL:='Select * From Sys_Favorite'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And UserId='+Quotedstr(g_UInfo^.UserId);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  CDS.Data:=Data;
  while not CDS.IsEmpty do
    CDS.Delete;

  for i:=0 to LB.Items.Count-1 do
  begin
    tmpSQL:=LB.Items[i];
    Delete(tmpSQL,Length(tmpSQL),1);
    pos1:=ReversePos('(',tmpSQL);
    tmpSQL:=Copy(tmpSQL,pos1+1,20);
    CDS.Append;
    CDS.FieldByName('Bu').AsString:=g_UInfo^.BU;
    CDS.FieldByName('Userid').AsString:=g_UInfo^.UserId;
    CDS.FieldByName('ProcId').AsString:=tmpSQL;
    CDS.FieldByName('SnoAsc').AsInteger:=i;
    CDS.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
    CDS.FieldByName('Idate').AsDateTime:=Now;
    CDS.Post;
  end;
  CDSPost(CDS,'Sys_Favorite');
end;

procedure TFrmFavorite.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  P:PMenuObj;
begin
  inherited;
  SetLabelCaption(Self, Self.Name);
  LoadFavorite;

  l_cbbIndex:=-1;
  tmpSQL:=' declare @nid int'
         +' select @nid=nid from sys_menu where pid<0'
         +' select nid,procid,procname from sys_menu where pid=@nid order by pid,snoasc';
  if not QueryBySQL(tmpSQL,Data) then
     Exit;

  CDS.Data:=Data;
  while not CDS.Eof do
  begin
    New(p);
    P^.NId:=CDS.Fields[0].AsInteger;
    P^.ProcId:=CDS.Fields[1].AsString;
    P^.ProcName:=CDS.Fields[2].AsString;
    cbb.Items.AddObject(P^.ProcName+'('+P^.ProcId+')', TObject(P));
    CDS.Next;
  end;
end;

procedure TFrmFavorite.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  RefreshFavorite;
  for i:=cbb.Items.Count-1 downto 0 do
     Dispose(PMenuObj(cbb.Items.Objects[i]));
  cbb.Clear;
end;

procedure TFrmFavorite.cbbChange(Sender: TObject);
begin
  inherited;
  if l_cbbIndex<>cbb.ItemIndex then
     SetCLB;
end;

procedure TFrmFavorite.CLBClickCheck(Sender: TObject);
var
  index:Integer;
  str:string;
begin
  inherited;
  index:=TCheckListBox(Sender).ItemIndex;
  str:=CLB.Items.Strings[index];
  if CLB.Checked[index] then
  begin
    if LB.Items.IndexOf(str)=-1 then
       LB.Items.Add(str)
  end else
  begin
    index:=LB.Items.IndexOf(str);
    if index<>-1 then
       LB.Items.Delete(index);
  end;
end;

procedure TFrmFavorite.btn_upClick(Sender: TObject);
var
  CurIndex, NewIndex: Integer;
begin
  if (LB.Items.Count>0) and (LB.ItemIndex >= 0) then
  begin
    CurIndex := LB.ItemIndex;
    if CurIndex = 0 then
       NewIndex := LB.Items.Count-1
    else
       NewIndex := CurIndex - 1;
    LB.Items.Move(CurIndex, NewIndex);
    LB.ItemIndex:= NewIndex;
    LB.Selected[NewIndex]:=True;
  end;
end;

procedure TFrmFavorite.btn_downClick(Sender: TObject);
var
  CurIndex, NewIndex: Integer;
begin
  if (LB.Items.Count>0) and (LB.ItemIndex >= 0) then
  begin
    CurIndex := LB.ItemIndex;
    if CurIndex = LB.Items.Count-1 then
       NewIndex := 0
    else
       NewIndex := CurIndex + 1;
    LB.Items.Move(CurIndex, NewIndex);
    LB.ItemIndex := NewIndex;
    LB.Selected[NewIndex]:=True;
  end;
end;

procedure TFrmFavorite.LBDblClick(Sender: TObject);
begin
  inherited;
  if LB.ItemIndex<>-1 then
  begin
    LB.Selected[LB.ItemIndex]:=True;
    LB.DeleteSelected;
  end;
end;

procedure TFrmFavorite.btn_qfindClick(Sender: TObject);
var
  twofind:boolean;

  function FindX(index:integer):Boolean;
  var
    i:Integer;
  begin
    Result:=False;
    for i:=index to CLB.Items.Count-1 do
    if Pos(Edit1.Text,CLB.Items.Strings[i])>0 then
    begin
      CLB.Selected[i]:=True;
      Result:=True;
      Break;
    end;
  end;
begin
  inherited;
  twofind:=CLB.ItemIndex>0;
  if not FindX(CLB.ItemIndex+1) then
  if twofind then
     FindX(0);
end;

end.
