unit unDLII380;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, ImgList, ComCtrls, ToolWin, StdCtrls, DBClient,
  Buttons, unSvr;

type
  TFrmDLII380 = class(TFrmSTDI080)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    cbb: TComboBox;
    Bevel1: TBevel;
    Memo2: TMemo;
    Bevel2: TBevel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    ToolButton100: TToolButton;
    Label9: TLabel;
    Edit5: TEdit;
    Label10: TLabel;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure cbbChange(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure ToolButton100Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    procedure InitData1;
    procedure InitData2;
    procedure SetCtlDefault(isDef: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII380: TFrmDLII380;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII380.SetCtlDefault(isDef:Boolean);
begin
  Edit1.ReadOnly:=isDef;
  Edit2.ReadOnly:=isDef;
  Edit3.ReadOnly:=isDef;
  Edit4.ReadOnly:=isDef;
  Edit5.ReadOnly:=isDef;
  //Memo1.ReadOnly:=isDef;
  Memo2.ReadOnly:=isDef;
  Cbb.Enabled:=isDef;

  btn_print.Enabled:=isDef;
  btn_export.Enabled:=not isDef;
  btn_query.Enabled:=isDef;
  ToolButton100.Enabled:=not isDef;
  BitBtn1.Enabled:=isDef;
end;

procedure TFrmDLII380.InitData1;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  tmpSQL:='select * from dli380 where bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL,Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    Edit1.Text:=tmpCDS.FieldByName('UId').AsString;
    Edit2.Text:=tmpCDS.FieldByName('PW').AsString;
    Edit3.Text:=tmpCDS.FieldByName('Email').AsString;
    Edit4.Text:=tmpCDS.FieldByName('COCPath').AsString;
    Edit5.Text:=tmpCDS.FieldByName('ResultEmail').AsString;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII380.InitData2;
var
  tmpSQL,tmpTime:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Memo2.Clear;
  tmpTime:=cbb.Items.Strings[cbb.ItemIndex];
  tmpSQL:='select * from dli381 where bu='+Quotedstr(g_UInfo^.BU)
         +' and stime='+Quotedstr(tmpTime);
  if not QueryBySQL(tmpSQL,Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    while not tmpCDS.Eof do
    begin
      Memo2.Lines.Add(tmpCDS.FieldByName('Custom').AsString+';'+tmpCDS.FieldByName('Email').AsString);
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII380.FormCreate(Sender: TObject);
begin
  p_TableName:='@@@';
  ToolButton100.Left:=btn_query.Left;
  inherited;

  btn_print.Caption:=CheckLang('更改');
  btn_export.Caption:=CheckLang('儲存');
  btn_query.Caption:=CheckLang('重整');
  ToolButton100.Caption:=CheckLang('放棄');
  BitBtn1.Caption:=CheckLang('測試[test]');

  Label1.Caption:=CheckLang('寄件人Email資料');
  //Label2.Caption:=CheckLang('郵件正文');
  Label3.Caption:=CheckLang('收件人資料(格式:客戶簡稱;郵箱一;郵箱二;...)');
  Label4.Caption:=CheckLang('Email帳號：');
  Label5.Caption:=CheckLang('Email密碼：');
  Label6.Caption:=CheckLang('Email全稱：');
  Label7.Caption:=CheckLang('發送時間：');
  Label8.Caption:=CheckLang('COC基本路徑：');
  Label9.Caption:=CheckLang('發送日記至Email：');
  Label10.Caption:=CheckLang('實際COC路徑：[COC基本路徑]\客戶簡稱\月份(如:1月)\日期(如:0101)\*.pdf(或*.xls或*.xlsx)');
  cbb.Items.LoadFromFile(g_UInfo^.SysPath+'cocemail.txt');
  cbb.Tag:=-1;
  cbb.ItemIndex:=0;
  cbb.Tag:=0;
  InitData1;
  InitData2;
  SetCtlDefault(True);
end;

procedure TFrmDLII380.btn_printClick(Sender: TObject);
begin
//  inherited;
  SetCtlDefault(False);
end;

procedure TFrmDLII380.btn_exportClick(Sender: TObject);
var
  i,pos1:Integer;
  bo:Boolean;
  tmpSQL,tmpTime:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data1,Data2:OleVariant;
begin
//  inherited;
  tmpSQL:='select * from dli380 where bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL,Data1) then
     Exit;

  tmpTime:=cbb.Items.Strings[cbb.ItemIndex];
  tmpSQL:='select * from dli381 where bu='+Quotedstr(g_UInfo^.BU)
         +' and stime='+Quotedstr(tmpTime);
  if not QueryBySQL(tmpSQL,Data2) then
     Exit;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data1;
    tmpCDS2.Data:=Data2;
    tmpCDS1.Edit;
    tmpCDS1.FieldByName('UId').AsString:=Edit1.Text;
    tmpCDS1.FieldByName('PW').AsString:=Edit2.Text;
    tmpCDS1.FieldByName('Email').AsString:=Edit3.Text;
    tmpCDS1.FieldByName('COCPath').AsString:=Edit4.Text;
    tmpCDS1.FieldByName('ResultEmail').AsString:=Edit5.Text;
    tmpCDS1.FieldByName('Muser').AsString:=g_UInfo^.UserId;
    tmpCDS1.FieldByName('Mdate').AsDateTime:=Now;
    tmpCDS1.Post;

    while not tmpCDS2.IsEmpty do
      tmpCDS2.Delete;

    for i:=0 to Memo2.Lines.Count-1 do
    begin
      pos1:=Pos(';',Memo2.Lines[i]);
      if pos1>0 then
      begin
        tmpCDS2.Append;
        tmpCDS2.FieldByName('Bu').AsString:=g_UInfo^.BU;
        tmpCDS2.FieldByName('Stime').AsString:=tmpTime;
        tmpCDS2.FieldByName('Custom').AsString:=Copy(Memo2.Lines[i],1,pos1-1);
        tmpCDS2.FieldByName('Email').AsString:=Copy(Memo2.Lines[i],pos1+1,500);
        tmpCDS2.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
        tmpCDS2.FieldByName('Idate').AsDateTime:=Now;
        tmpCDS2.Post;
      end;
    end;

    bo:=CDSPost(tmpCDS1,'dli380');
    if bo then
       bo:=CDSPost(tmpCDS2,'dli381');
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;

  if bo then
     SetCtlDefault(True);
end;

procedure TFrmDLII380.btn_queryClick(Sender: TObject);
begin
//  inherited;
  cbb.Items.LoadFromFile(g_UInfo^.SysPath+'cocemail.txt');
  cbb.Tag:=-1;
  cbb.ItemIndex:=0;
  cbb.Tag:=0;
  InitData1;
  InitData2;
end;

procedure TFrmDLII380.ToolButton100Click(Sender: TObject);
begin
  inherited;
  InitData1;
  InitData2;
  SetCtlDefault(True);
end;

procedure TFrmDLII380.cbbChange(Sender: TObject);
begin
  inherited;
  if cbb.Tag=0 then
     InitData2;
end;

procedure TFrmDLII380.BitBtn1Click(Sender: TObject);
var
  Err:string;
begin
  inherited;
  if TSvr.COCEmail(g_UInfo^.BU,Err) then
     ShowMsg('已執行測試,請稍后查看測試郵箱!',64)
  else
     ShowMsg('測試失敗,請聯絡管理員!',48);
end;

end.
