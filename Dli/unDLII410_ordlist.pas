{*******************************************************}
{                                                       }
{                unDLII410_ordlist                      }
{                Author: kaikai                         }
{                Create date: 2017/02/13                }
{                Description: 出貨排程明細              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII410_ordlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh, Menus, ImgList,
  Buttons, ExtCtrls, ComCtrls, ToolWin, DBClient, DB, StrUtils, Math;

type
  TFrmDLII410_ordlist = class(TFrmSTDI051)
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    Label1: TLabel;
    Dtp: TDateTimePicker;
    btn_query: TBitBtn;
    Label2: TLabel;
    pnl101: TPanel;
    pnl100: TPanel;
    btn_export: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    l_IsDG:Boolean;
    { Public declarations }
  end;

var
  FrmDLII410_ordlist: TFrmDLII410_ordlist;

implementation

uses unGlobal, unCommon, unDLII410;

{$R *.dfm}

procedure TFrmDLII410_ordlist.FormCreate(Sender: TObject);
begin
  inherited;
  btn_export.Top:=btn_ok.Top;
  btn_ok.Visible:=True;

  Label2.Caption:='';
  SetGrdCaption(DBGridEh1, 'DLII410_ordlist');
  Dtp.Date:=Date;
  l_CDS:=TClientDataSet.Create(Self);
end;

procedure TFrmDLII410_ordlist.FormDestroy(Sender: TObject);
begin
  inherited;
  l_CDS.Free;
  DBGridEh1.Free;
end;

procedure TFrmDLII410_ordlist.btn_queryClick(Sender: TObject);
var
  i,Cnt1,Cnt2:Integer;
  tmpSQL:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
  tmpList:TStrings;
begin
  inherited;
  Cnt1:=0;
  Cnt2:=0;
  g_StatusBar.Panels[0].Text:='正在查詢...';
  Application.ProcessMessages;
  tmpList:=TStringList.Create;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  DS1.DataSet:=nil;
  try
    tmpSQL:='Select Id,Pathname,Custno From DLI410'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(Dtp.Date))
           +' And Len(IsNull(Custno,''''))>0';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;

    Data:=null;
    tmpSQL:='Select Remark1 as Id,Remark2 as Pathname,Sno,Custno,Custshort,Orderno,Orderitem,Pno,Notcount1,Units,Remark'
           +' From DLI010 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(Dtp.Date))
           +' And Len(IsNull(Dno_Ditem,''''))=0 And IsNull(GarbageFlag,0)=0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
           +' Order By Sno';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS2.Data:=Data;
    l_CDS.Data:=Data;
    l_CDS.EmptyDataSet;
    tmpSQL:='';
    with tmpCDS2 do
    begin
      Cnt1:=RecordCount;
      while not Eof do
      begin
        Edit;
        FieldByName('Id').AsString:='';
        FieldByName('Pathname').AsString:='';
        tmpCDS1.First;
        while not tmpCDS1.Eof do
        begin
          if Pos(FieldByName('Custno').AsString,tmpCDS1.FieldByName('Custno').AsString)>0 then
          begin
            if Length(FieldByName('Id').AsString)>0 then
            begin
              FieldByName('Id').AsString:=FieldByName('Id').AsString+','+tmpCDS1.FieldByName('Id').AsString;
              if Pos(tmpCDS1.FieldByName('Pathname').AsString,FieldByName('Pathname').AsString)=0 then
                 FieldByName('Pathname').AsString:=FieldByName('Pathname').AsString+','+tmpCDS1.FieldByName('Pathname').AsString;
            end else
            begin
              FieldByName('Id').AsString:=tmpCDS1.FieldByName('Id').AsString;
              FieldByName('Pathname').AsString:=tmpCDS1.FieldByName('Pathname').AsString;
            end
          end;
          tmpCDS1.Next;
        end;
        Post;
        Next;
      end;

      if ChangeCount>0 then
         MergeChangeLog;

      Filter:='Id<>''''';
      IndexFieldNames:='Id';
      Filtered:=True;
      Cnt2:=RecordCount;
      First;
      while not Eof do
      begin
        l_CDS.Append;
        for i:=0 to FieldCount -1 do
           l_CDS.Fields[i].Value:=Fields[i].Value;

        l_CDS.Post;
        Next;
      end;
      l_CDS.First;
    end;
  finally
    tmpList.Free;
    tmpCDS1.Free;
    tmpCDS2.Free;
    Label2.Caption:=CheckLang('排程筆數:'+IntToStr(Cnt1)+', 派車筆數:'+IntToStr(Cnt2));
    DS1.DataSet:=l_CDS;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLII410_ordlist.btn_exportClick(Sender: TObject);
begin
  inherited;
  if not l_CDS.Active then
     Exit;
  GetExportXls(l_CDS, 'DLII410_ordlist');
end;

end.
