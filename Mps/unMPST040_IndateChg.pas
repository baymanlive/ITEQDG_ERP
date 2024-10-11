{*******************************************************}
{                                                       }
{                unMPST040_IndateChg                    }
{                Author: kaikai                         }
{                Create date: 2016/03/23                }
{                Description: 更改出貨日期              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_IndateChg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, ComCtrls, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh,
  ImgList, Buttons, ExtCtrls, DBClient, StrUtils;

type
  TFrmMPST040_IndateChg = class(TFrmSTDI051)
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    btn_query: TBitBtn;
    btn1: TBitBtn;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_IndateChg: TFrmMPST040_IndateChg;

implementation

uses unGlobal, unCommon, unMPST040_units;

{$R *.dfm}

procedure TFrmMPST040_IndateChg.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date+1;
  SetGrdCaption(DBGridEh1, 'DLI010');
  l_CDS:=TClientDataSet.Create(Self);
  DS1.DataSet:=l_CDS;
end;

procedure TFrmMPST040_IndateChg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST040_IndateChg.btn_queryClick(Sender: TObject);
var
  Data:OleVariant;
  tmpSQL:string;
begin
  inherited;
  tmpSQL:='Select * From DLI010 Where Indate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And isnull(ChkCount,0)=0 And isnull(GarbageFlag,0)=0'
         +' And len(isnull(Dno_Ditem,''''))=0'
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
         +' And Bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
     l_CDS.Data:=Data;
end;

procedure TFrmMPST040_IndateChg.btn1Click(Sender: TObject);
var
  i:Integer;
  P:TBookmark;
  procedure XUpdateRecord;
  begin
    with l_CDS do
    if FieldByName('Indate').AsDateTime<>Dtp2.Date then
    begin
      Edit;
      FieldByName('Indate').AsDateTime:=Dtp2.Date;
      Post;
    end;
  end;
begin
  inherited;
  if (not l_CDS.Active) or l_CDS.IsEmpty then
  begin
    ShowMsg('請選擇數據!', 48);
    Exit;
  end;

  if CheckConfirm(Dtp2.Date) then
  begin
    ShowMsg(DateToStr(Dtp2.Date)+'出貨表已確認,請使用單筆新增!', 48);
    Exit;
  end;

  if ShowMsg('確定更新嗎?', 33)=IDcancel then
     Exit;

  btn_query.Enabled:=False;
  btn1.Enabled:=False;
  P:=l_CDS.GetBookmark;
  l_CDS.DisableControls;
  try
    if DBGridEh1.SelectedRows.Count=0 then
       XUpdateRecord
    else
    for i:=0 to DBGridEh1.SelectedRows.Count-1 do
    begin
      l_CDS.GotoBookmark(Pointer(DBGridEh1.SelectedRows[i]));
      XUpdateRecord;
    end;

    if CDSPost(l_CDS, 'DLI010') then
       ShowMsg('更新完畢!', 64)
    else if l_CDS.ChangeCount>0 then
       l_CDS.CancelUpdates;    
  finally
    btn_query.Enabled:=True;
    btn1.Enabled:=True;
    l_CDS.GotoBookmark(P);
    l_CDS.EnableControls;
  end;
end;

procedure TFrmMPST040_IndateChg.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not l_CDS.Active then
     Exit;
  if SameText(Column.FieldName, 'Chkcount') then
  case l_CDS.FieldByName('QtyColor').AsInteger of
    1:Background:=clLime;
    2:Background:=clYellow;
    3:Background:=clFuchsia;
  end;
end;

end.
