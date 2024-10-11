unit unFind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, DB, DBClient,
  DBGridEh;

type
  TItemObj = Class(TObject)
    private
      FFiledName:string;
      FFieldCaption:string;
  public
    constructor Create(fName, fCaption: string);
    destructor Destroy; override;
  end;

type
  TFrmFind = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Cbb: TComboBox;
    Chk1: TCheckBox;
    Chk2: TCheckBox;
    Chk3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_DestCDS:TClientDataSet;
    { Private declarations }
  public
    g_SrcCDS:TClientDataSet;
    g_Columns:TDBGridColumnsEh;
    g_DefFname,g_DelFname:string;
    { Public declarations }
  end;

var
  FrmFind: TFrmFind;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

{ TItemObj }

constructor TItemObj.Create(fName, fCaption: string);
begin
  FFiledName:=fName;
  FFieldCaption:=fCaption;
end;

destructor TItemObj.Destroy;
begin

  inherited;
end;

procedure TFrmFind.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('查找內容：');
  Label2.Caption:=CheckLang('查找欄位：');
  Chk1.Caption:=CheckLang('忽略大小寫');
  Chk2.Caption:=CheckLang('全字匹配');
  Chk3.Caption:=CheckLang('向下');
end;

procedure TFrmFind.FormShow(Sender: TObject);
var
  i:Integer;
begin
  inherited;      
  g_DelFname:=LowerCase(g_DelFname);
  for i:=0 to g_Columns.Count-1 do
  begin
    if pos(','+LowerCase(g_Columns[i].FieldName)+',',','+g_DelFname+',')>0 then
       Continue;

    Cbb.Items.AddObject(g_Columns[i].Title.Caption, TItemObj.Create(g_Columns[i].FieldName,
      g_Columns[i].Title.Caption));
  end;

  if g_DefFname<>'' then
  for i:=0 to Cbb.Items.Count -1 do
  begin
    if SameText(g_DefFname, TItemObj(Cbb.Items.Objects[i]).FFiledName) then
    begin
      Cbb.ItemIndex:=i;
      Break;
    end;
  end;

  l_DestCDS:=TClientDataSet.Create(nil);
  if g_SrcCDS.Active then
  with l_DestCDS do
  begin
    Data:=g_SrcCDS.Data;
    if g_SrcCDS.IndexName<>'' then
    begin
      AddIndex('xIndex', g_SrcCDS.IndexDefs[0].Fields, [ixCaseInsensitive], g_SrcCDS.IndexDefs[0].DescFields);
      IndexName:='xIndex';
    end else
      IndexFieldNames:=g_SrcCDS.IndexFieldNames;
    Filtered:=False;
    Filter:=g_SrcCDS.Filter;
    Filtered:=True;
  end;
end;

procedure TFrmFind.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  inherited;
  for i:=Cbb.Items.Count-1 downto 0 do
  begin
    TItemObj(Cbb.Items.Objects[i]).Free;
    Cbb.Items.Delete(i);
  end;
  FreeAndNil(l_DestCDS);
end;

procedure TFrmFind.btn_okClick(Sender: TObject);
var
  str1,str2,fName:string;
  isFind:Boolean;
begin
  if Cbb.ItemIndex=-1 then
  begin
    ShowMsg('請選擇要查找的欄位!', 48);
    Exit;
  end;
  if (not l_DestCDS.Active) or l_DestCDS.IsEmpty then
  begin
    ShowMsg('找不到"'+str1+'"', 48);
    Exit;
  end;
  str1:=Trim(Edit1.Text);
  if str1='' then
  begin
    ShowMsg('請輸入要查找的內容!', 48);
    Exit;
  end;

  TBitBtn(Sender).Enabled:=False;
  Application.ProcessMessages;
  if not Chk1.Checked then
     str1:=LowerCase(str1);
  fName:=TItemObj(Cbb.Items.Objects[Cbb.ItemIndex]).FFiledName;
  isFind:=False;
  with l_DestCDS do
  begin
    DisableControls;
    RecNo:=g_SrcCDS.RecNo;
    if Chk3.Checked then
       Next
    else
       Prior;
    try
    while (Chk3.Checked and (not Eof)) or ((not Chk3.Checked) and (not Bof)) do
    begin
      str2:=FieldByName(fName).AsString;
      if not Chk1.Checked then
         str2:=LowerCase(str2);
      if (chk2.Checked and (str1=str2)) or
         ((not chk2.Checked) and (Pos(str1, str2)>0)) then
      begin
        isFind:=True;
        Break;
      end;
      if Chk3.Checked then
         Next
      else
         Prior;
    end;
    finally
      TBitBtn(Sender).Enabled:=True;
      EnableControls;
      if not isFind then
         ShowMsg('找不到"'+str1+'"', 48)
      else
         g_SrcCDS.RecNo:=RecNo;
    end;
  end;
//  inherited;
end;

end.
