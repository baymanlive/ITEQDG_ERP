{*******************************************************}
{                                                       }
{                unDLII410_custno                       }
{                Author: kaikai                         }
{                Create date: 2017/2/8                  }
{                Description: dlii410、dlii430客戶選擇  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII410_custno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, Menus, ImgList, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, ToolWin, DBClient;

type
  TFrmDLII410_custno = class(TFrmSTDI051)
    Memo1: TMemo;
    Memo2: TMemo;
    lblcustno: TLabel;
    lblcustshort: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    l_List:TStrings;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII410_custno: TFrmDLII410_custno;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII410_custno.FormCreate(Sender: TObject);
begin
  inherited;
  l_CDS:=TClientDataSet.Create(Self);
  l_List:=TStringList.Create;
  Memo1.Tag:=1;
end;

procedure TFrmDLII410_custno.FormDestroy(Sender: TObject);
begin
  inherited;
  l_CDS.Free;
  l_List.Free;
end;

procedure TFrmDLII410_custno.FormShow(Sender: TObject);
var
  tmpSQL,tmpORADB:string;
  Data:OleVariant;
begin
  inherited;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpORADB:='ORACLE'
  else
     tmpORADB:='ORACLE1';
  tmpSQL:='Select occ01,occ02 From occ_file Order By occ01';
  if QueryBySQL(tmpSQL, Data, tmpORADB) then
     l_CDS.Data:=Data;
  Memo1.Tag:=0;
end;

procedure TFrmDLII410_custno.Memo1Change(Sender: TObject);
var
  i:Integer;
  str:string;
begin
  inherited;
  if (Memo1.Tag=1) or (not l_CDS.Active) then
     Exit;
  l_List.DelimitedText:=Memo1.Lines.DelimitedText;
  for i:=0 to l_List.Count-1 do
  if l_CDS.Locate('occ01', l_List.Strings[i], []) then
     str:=str+','+l_CDS.Fields[1].AsString
  else
     str:=str+',';

  if Length(str)>0 then
  begin
    Delete(str,1,1);
    Memo2.Lines.DelimitedText:=str
  end else
    Memo2.Clear;
end;

procedure TFrmDLII410_custno.btn_okClick(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to Memo2.Lines.Count-1 do
  if Length(Trim(Memo2.Lines.Strings[i]))=0 then
  begin
    ShowMsg('第'+IntToStr(i+1)+'筆客戶簡稱不正確!',48);
    Exit;
  end;

  inherited;
end;

end.
