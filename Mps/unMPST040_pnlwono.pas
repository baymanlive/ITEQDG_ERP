{*******************************************************}
{                                                       }
{                unMPST040_pnlwono                      }
{                Author: kaikai                         }
{                Create date: 2016/03/23                }
{                Description: 小板工單號碼查詢          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_pnlwono;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, StdCtrls, ExtCtrls, ComCtrls, GridsEh, DBAxisGridsEh,
  DBGridEh, ImgList, Buttons, DBClient;

type
  TFrmMPST040_pnlwono = class(TFrmSTDI051)
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    lblindate: TLabel;
    Dtp1: TDateTimePicker;
    btn_query: TBitBtn;
    rgp: TRadioGroup;
    btn1: TBitBtn;
    Panel1: TPanel;
    btn_export: TBitBtn;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure rgpClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    procedure FilterData;
    procedure l_CDSBeforeInsert(DataSet: TDataSet);
    procedure l_CDSBeforeEdit(DataSet: TDataSet);
    procedure l_CDSAfterPost(DataSet: TDataSet);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_pnlwono: TFrmMPST040_pnlwono;

implementation

uses unGlobal, unCommon, unMPST040_units;

{$R *.dfm}

procedure TFrmMPST040_pnlwono.FilterData;
begin
  with l_CDS do
  begin
    if not Active then
       Exit;

    if rgp.ItemIndex=0 then
    begin
      Filtered:=False;
      Filter:='m1=''E'' or m1=''T''';
      Filtered:=True;
    end
    else if rgp.ItemIndex=1 then
    begin
      Filtered:=False;
      Filter:='m1=''M'' or m1=''N''';
      Filtered:=True;
    end else
    begin
      Filtered:=False;
      Filter:='';
    end;

    IndexFieldNames:='custno';
    First;
  end;
end;

procedure TFrmMPST040_pnlwono.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Label1.Caption:=CheckLang('[備註四、備註五]欄位可更改');
  SetGrdCaption(DBGridEh1, 'MPST040_pnlwono');
  l_CDS:=TClientDataSet.Create(Self);
  l_CDS.BeforeInsert:=l_CDSBeforeInsert;
  l_CDS.BeforeEdit:=l_CDSBeforeEdit;
  l_CDS.AfterPost:=l_CDSAfterPost;
  DS1.DataSet:=l_CDS;
end;

procedure TFrmMPST040_pnlwono.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST040_pnlwono.btn_queryClick(Sender: TObject);
var
  Data:OleVariant;
  tmpSQL:string;
begin
  inherited;
  tmpSQL:='exec dbo.proc_MPST040_pnlwono '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(DateToStr(Dtp1.Date));
  if QueryBySQL(tmpSQL, Data) then
  begin
    l_CDS.Data:=Data;
    FilterData;
  end;
end;

procedure TFrmMPST040_pnlwono.btn_exportClick(Sender: TObject);
begin
  inherited;
  GetExportXls(l_CDS, 'MPST040_pnlwono');
end;

procedure TFrmMPST040_pnlwono.rgpClick(Sender: TObject);
begin
  inherited;
  FilterData;
end;

procedure TFrmMPST040_pnlwono.DBGridEh1GetCellParams(Sender: TObject;
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

procedure TFrmMPST040_pnlwono.btn1Click(Sender: TObject);
var
  str:string;
begin
  inherited;
  if l_CDS.Active then
     str:=l_CDS.FieldByName('pno').AsString;
  GetQueryStock(str, false);
end;

procedure TFrmMPST040_pnlwono.l_CDSBeforeInsert(DataSet: TDataSet);
begin
  Abort;
end;

procedure TFrmMPST040_pnlwono.l_CDSBeforeEdit(DataSet: TDataSet);
begin
  if not g_MInfo^.R_edit then
     Abort;
end;

procedure TFrmMPST040_pnlwono.l_CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  tmpSQL:='Update DLI010 Set Remark4='+Quotedstr(l_CDS.FieldByName('Remark4').AsString)
         +',Remark5='+Quotedstr(l_CDS.FieldByName('Remark5').AsString)
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(l_CDS.FieldByName('Dno').AsString)
         +' And Ditem='+l_CDS.FieldByName('Ditem').AsString;
  if PostBySQL(tmpSQL) then
     l_CDS.MergeChangeLog
  else if l_CDS.ChangeCount>0 then
     l_CDS.CancelUpdates;
end;

end.
