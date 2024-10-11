{*******************************************************}
{                                                       }
{                unDLII433                              }
{                Author: kaikai                         }
{                Create date: 2021/6/23                 }
{                Description: 裝車檢核記錄表            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII433;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils;

type
  TFrmDLII433 = class(TFrmSTDI041)
    kb: TLabel;
    Memo1: TMemo;
    saleno: TLabel;
    Memo2: TMemo;
    Panel2: TPanel;
    DBGridEh2: TDBGridEh;
    Panel3: TPanel;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
    procedure RefreshDS2;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII433: TFrmDLII433;

implementation

uses unGlobal, unCommon, unDLII433_export;

{$R *.dfm}

procedure TFrmDLII433.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Data:=null;
  tmpSQL:='select * from dli433 where bu='+Quotedstr(g_UInfo^.BU)+strFilter
         +' order by idate desc';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    Memo1.Lines.Clear;
    Memo2.Lines.Clear;
    RefreshDS2;
  end;

  inherited;
end;

procedure TFrmDLII433.RefreshDS2;
var
  i:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  for i:=0 to Memo1.Lines.Count-1 do
    tmpSQL:=tmpSQL+','+Quotedstr(Memo1.Lines.Strings[i]);

  if Length(tmpSQL)>0 then
  begin
    Delete(tmpSQL,1,1);
    tmpSQL:=' and kb in ('+tmpSQL+')';
  end else
    tmpSQL:=g_cFilterNothing;

  Data:=null;
  tmpSQL:='select kb,sno,custno,pno,qty,iuser,idate from dli431'
         +' where bu='+Quotedstr(g_UInfo^.BU)+tmpSQL
         +' and not_use=0 order by kb,sno,custno,pno';
  if QueryBySQL(tmpSQL, Data) then
     CDS2.Data:=Data;
end;

procedure TFrmDLII433.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI433';
  p_GridDesignAns:=True;

  inherited;

  SetGrdCaption(DBGridEh2,'dli431');
end;

procedure TFrmDLII433.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh2.Free;
end;

procedure TFrmDLII433.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  Memo1.Lines.DelimitedText:=CDS.FieldByName('kb').AsString;
  Memo2.Lines.DelimitedText:=CDS.FieldByName('saleno').AsString;
  RefreshDS2;
end;

procedure TFrmDLII433.btn_exportClick(Sender: TObject);
begin
  //inherited;
   if not Assigned(FrmDLII433_export) then
      FrmDLII433_export:=TFrmDLII433_export.Create(Application);
   if FrmDLII433_export.ShowModal<>mrOk then
      Exit;

   case FrmDLII433_export.rgp.ItemIndex of
    0:GetExportXls(CDS, p_TableName);
    1:GetExportXls(CDS2, 'dli431');
   end;
end;

end.
