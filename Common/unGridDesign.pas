{*******************************************************}
{                                                       }
{                unGridDesign                           }
{                Author: kaikai                         }
{                Create date:                           }
{                Description: DBGridEh設定              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unGridDesign;

interface

uses
  Classes, SysUtils, Controls, DBClient, Menus, Variants, DBGridEh,
  GridsEh, unGlobal, unCommon;

type
  TGridDesign = class
  private
    FProcId:string;
    FCDS:TClientDataSet;
    FDBGridEh:TDBGridEh;
    FPopupMenu:TPopupMenu;
    FNameList:TStrings;
    FWidthList:TStrings;
    procedure PopupMenuClick(Sender: TObject);
    procedure InitCDS;
    procedure InitPopupMenu;
    procedure SetPopupMenu;
  public
    constructor Create(DBGridEh:TDBGridEh; const ProcId:string='');
    destructor Destroy; override;
    procedure MouseDown(IsRButton:Boolean; X, Y: Integer);
    procedure ColWidthChange;
  end;

implementation

{ TGridDesign }

constructor TGridDesign.Create(DBGridEh:TDBGridEh; const ProcId:string='');
begin
  if Length(ProcId)>0 then
     FProcId:=ProcId
  else
     FProcId:=g_MInfo^.ProcId;
  FDBGridEh:=DBGridEh;
  FCDS:=TClientDataSet.Create(nil);
  FPopupMenu:=TPopupMenu.Create(nil);
  FPopupMenu.AutoHotkeys:=maManual;
  FPopupMenu.Name:='POPGridDesign';
  FNameList:=TStringList.Create;
  FWidthList:=TStringList.Create;

  InitCDS;
  InitPopupMenu;
  SetPopupMenu;
end;

destructor TGridDesign.Destroy;
var
  i:Integer;
begin
  FreeAndNil(FCDS);
  for i:=FPopupMenu.Items.Count-1 downto 0 do
     FPopupMenu.Items[i].Free;
  FPopupMenu.Free;
  FreeAndNil(FNameList);
  FreeAndNil(FWidthList);

  inherited;
end;

procedure TGridDesign.PopupMenuClick(Sender: TObject);
var
  i:Integer;
  s:string;
begin
  if Sender<>nil then  //ColWidthChange調用傳入nil
     FDBGridEh.FieldColumns[TMenuItem(Sender).Name].Visible:=TMenuItem(Sender).Checked;

  FNameList.Clear;
  FWidthList.Clear;
  for i:=0 to FDBGridEh.Columns.Count-1 do
  if FDBGridEh.Columns[i].Visible then
  begin
    FNameList.Add(LowerCase(FDBGridEh.Columns[i].FieldName));
    FWidthList.Add(IntToStr(FDBGridEh.Columns[i].Width));
  end;

  with FCDS do
  begin
    if IsEmpty then
    begin
      Append;
      FieldByName('Bu').AsString:=g_UInfo^.BU;
      FieldByName('UserId').AsString:=g_UInfo^.UserId;
      FieldByName('ProcId').AsString:=FProcId;
    end else
      Edit;

    s:=FNameList.DelimitedText;
    if FieldByName('fName').AsString<>s then
       FieldByName('fName').AsString:=s;

    s:=FWidthList.DelimitedText;
    if FieldByName('fWidth').AsString<>s then
       FieldByName('fWidth').AsString:=s;
    Post;
  end;

  if not CDSPost(FCDS, 'Sys_GridDesign') then
  if FCDS.ChangeCount>0 then
     FCDS.CancelUpdates;
end;

procedure TGridDesign.InitCDS;
var
  Data:OleVariant;
  tmpSQL:string;
begin
  tmpSQL:='Select Top 1 * From Sys_GridDesign'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And UserId='+Quotedstr(g_UInfo^.UserId)
         +' And ProcId='+Quotedstr(FProcId);
  if QueryBySQL(tmpSQL, Data) then
     FCDS.Data:=Data;
end;

procedure TGridDesign.InitPopupMenu;
var
  i:Integer;
  Bo:Boolean;
  tmpItem:TMenuItem;
begin
  //CDS無數據全部選中(顯示)
  Bo:=FCDS.IsEmpty or (Trim(FCDS.FieldByName('fName').AsString)='');

  for i:=0 to FDBGridEh.Columns.Count-1 do
  begin
    if not FDBGridEh.Columns[i].Visible then
       Continue;
    //設置右鍵菜單屬性
    tmpItem:=TMenuItem.Create(nil);
    tmpItem.Caption:=FDBGridEh.Columns[i].Title.Caption;
    tmpItem.Name:=LowerCase(FDBGridEh.Columns[i].FieldName);
    tmpItem.AutoCheck:=True;
    tmpItem.Checked:=Bo;
    tmpItem.OnClick:=PopupMenuClick;

    FPopupMenu.Items.Add(tmpItem);
  end;
end;

procedure TGridDesign.SetPopupMenu;
var
  i,j:Integer;
  Bo:Boolean;
begin
  if FCDS.IsEmpty or (Trim(FCDS.FieldByName('fName').AsString)='') then
     Exit;

  FNameList.DelimitedText:=FCDS.FieldByName('fName').AsString;
  FWidthList.DelimitedText:=FCDS.FieldByName('fWidth').AsString;

  //刪除不存在欄位
  for i:=FNameList.Count-1 downto 0 do
  begin
    Bo:=False;
    for j:=0 to FPopupMenu.Items.Count-1 do
    begin
      Bo:=SameText(FNameList.Strings[i], FPopupMenu.Items[j].Name);
      if Bo then
         Break;
    end;

    if not Bo then
    begin
      FNameList.Delete(i);
      FWidthList.Delete(i);
    end;
  end;

  //設置定義的寬度、位置、右鍵菜單選中
  for i:=0 to FNameList.Count-1 do
  begin
    with FDBGridEh.FieldColumns[FNameList.Strings[i]] do
    begin
      Width:=StrToInt(FWidthList.Strings[i]);
      Index:=i;
      FPopupMenu.Items.Find(Title.Caption).Checked:=True;
    end;
  end;

  //隱藏或顯示
  for i:=FDBGridEh.Columns.Count-1 downto 0 do
    if FNameList.IndexOf(LowerCase(FDBGridEh.Columns[i].FieldName))=-1 then
       FDBGridEh.Columns[i].Visible:=False
    else
       Break; //Index調整後不顯示的在最后面
end;

procedure TGridDesign.MouseDown(IsRButton: Boolean; X, Y: Integer);
var
  Cell: TGridCoord;
begin
  if IsRButton then
  begin
    Cell:=FDBGridEh.MouseCoord(X, Y);
    if Cell.Y=0 then
       FPopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;
end;

procedure TGridDesign.ColWidthChange;
begin
  PopupMenuClick(nil);
end;

end.
 