{*******************************************************}
{                                                       }
{                unDLRI240                              }
{                Author: kaikai                         }
{                Create date: 2019/12/10                }
{                Description: 客戶棧板統計表            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR240;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin;

type
  TFrmDLIR240 = class(TFrmSTDI040)
    CDS2: TClientDataSet;
    DS2: TDataSource;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    DS4: TDataSource;
    CDS4: TClientDataSet;
    TabSheet20: TTabSheet;
    TabSheet21: TTabSheet;
    TabSheet22: TTabSheet;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    DBGridEh4: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR240: TFrmDLIR240;

implementation

uses unGlobal, unCommon, unDLIR240_Query, unDLIR240_export;

{$R *.dfm}

procedure TFrmDLIR240.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  tmpCDS1,tmpCDS2,tmpCDS3,tmpCDS4,custCDS:TClientDataSet;
  Data:OleVariant;

  procedure SetCustshort(xCDS:TClientDataSet);
  begin
    with xCDS do
    begin
      First;
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;
        
        Edit;
        if custCDS.Active and custCDS.Locate('occ01',FieldByName('custno').AsString,[]) then
           FieldByName('custshort').AsString:=custCDS.FieldByName('occ02').AsString
        else
           FieldByName('custshort').Clear;
        Post;
        Next;
      end;
    end;
  end;

begin
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  tmpCDS4:=TClientDataSet.Create(nil);
  custCDS:=TClientDataSet.Create(nil);
  try
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+TabSheet1.Caption);
    Application.ProcessMessages;
    tmpSQL:='select custno,custno as custshort,count(*) cnt from('
           +' select distinct custno,kb from dli431'
           +' where bu='+Quotedstr(g_UInfo^.Bu)+' and not_use=0 '+strFilter+') t'
           +' group by custno order by custno';   
    if QueryBySQL(tmpSQL, Data) then
       tmpCDS1.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+TabSheet20.Caption);
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select idate,custno,custno as custshort,count(*) cnt from('
           +' select distinct convert(varchar(10),idate,120) idate,custno,kb from dli431'
           +' where bu='+Quotedstr(g_UInfo^.Bu)+' and not_use=0 '+strFilter+') t'
           +' group by idate,custno'
           +' order by idate,custno';
    if QueryBySQL(tmpSQL, Data) then
       tmpCDS2.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+TabSheet21.Caption);
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select distinct convert(varchar(10),idate,120) idate,custno,custno as custshort,kb from dli431'
           +' where bu='+Quotedstr(g_UInfo^.Bu)+' and not_use=0 '+strFilter
           +' order by 1,2,4';
    if QueryBySQL(tmpSQL, Data) then
       tmpCDS3.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+TabSheet22.Caption);
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select convert(varchar(10),idate,120) idate,custno,custno as custshort,kb,pno,qty from dli431'
           +' where bu='+Quotedstr(g_UInfo^.Bu)+' and not_use=0 '+strFilter
           +' order by 1,2,4,5';
    if QueryBySQL(tmpSQL, Data) then
       tmpCDS4.Data:=Data;

    if not tmpCDS1.IsEmpty  then
    begin
      tmpSQL:='';
      with tmpCDS1 do
      while not Eof do
      begin
        tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('custno').AsString);
        Next;
      end;

      Delete(tmpSQL,1,1);
      Data:=null;
      tmpSQL:='select occ01,occ02 from '+g_UInfo^.Bu+'.occ_file where occ01 in ('+tmpSQL+')';
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
         custCDS.Data:=Data;

      g_StatusBar.Panels[0].Text:=CheckLang('正在更新:客戶簡稱');
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=tmpCDS1.RecordCount+tmpCDS2.RecordCount+tmpCDS3.RecordCount+tmpCDS4.RecordCount;
      g_ProgressBar.Visible:=True;
      Application.ProcessMessages;
      SetCustshort(tmpCDS1);
      SetCustshort(tmpCDS2);
      SetCustshort(tmpCDS3);
      SetCustshort(tmpCDS4);
    end;

  finally
    if tmpCDS1.Active then
       CDS.Data:=tmpCDS1.Data
    else if CDS.Active then
       CDS.EmptyDataSet;

    if tmpCDS2.Active then
       CDS2.Data:=tmpCDS2.Data
    else if CDS2.Active then
       CDS2.EmptyDataSet;

    if tmpCDS3.Active then
       CDS3.Data:=tmpCDS3.Data
    else if CDS3.Active then
       CDS3.EmptyDataSet;

    if tmpCDS4.Active then
       CDS4.Data:=tmpCDS4.Data
    else if CDS4.Active then
       CDS4.EmptyDataSet;

    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    FreeAndNil(tmpCDS4);
    FreeAndNil(custCDS);
    g_ProgressBar.Visible:=False;
    g_StatusBar.Panels[0].Text:='';
  end;

  inherited;
end;

procedure TFrmDLIR240.FormCreate(Sender: TObject);
begin
  p_SysId:='DLI';
  p_TableName:='DLIR240_1';

  inherited;
  
  TabSheet1.Caption:=CheckLang('棧板數量合計');
  TabSheet20.Caption:=CheckLang('棧板日期+數量合計');
  TabSheet21.Caption:=CheckLang('棧板編碼明細');
  TabSheet22.Caption:=CheckLang('料號數量明細');
  SetGrdCaption(DBGridEh2, 'DLIR240_2');
  SetGrdCaption(DBGridEh3, 'DLIR240_3');
  SetGrdCaption(DBGridEh4, 'DLIR240_4');
end;

procedure TFrmDLIR240.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  CDS4.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
end;

procedure TFrmDLIR240.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if not AsSigned(FrmDLIR240_query) then
     FrmDLIR240_query:=TFrmDLIR240_query.Create(Application);
  if FrmDLIR240_query.ShowModal=mrOK then
  begin
    tmpStr:=' and idate between '+Quotedstr(DateToStr(FrmDLIR240_query.dtp1.Date))
           +' and '+Quotedstr(DateToStr(FrmDLIR240_query.dtp2.Date)+' 23:59:59');
    if Length(Trim(FrmDLIR240_query.Edit1.Text))>0 then
       tmpStr:=tmpStr+' and charindex(custno,'+Quotedstr(FrmDLIR240_query.Edit1.Text)+')>0';
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLIR240.btn_exportClick(Sender: TObject);
begin
//  inherited;
  if not AsSigned(FrmDLIR240_export) then
  begin
    FrmDLIR240_export:=TFrmDLIR240_export.Create(Application);
    FrmDLIR240_export.rgp.Items[0]:=TabSheet1.Caption;
    FrmDLIR240_export.rgp.Items[1]:=TabSheet20.Caption;
    FrmDLIR240_export.rgp.Items[2]:=TabSheet21.Caption;
    FrmDLIR240_export.rgp.Items[3]:=TabSheet22.Caption;
  end;
  if FrmDLIR240_export.ShowModal<>mrOK then
     Exit;

  case FrmDLIR240_export.rgp.ItemIndex of
    0:GetExportXls(CDS, 'DLIR240_1');
    1:GetExportXls(CDS2, 'DLIR240_2');
    2:GetExportXls(CDS3, 'DLIR240_3');
    3:GetExportXls(CDS4, 'DLIR240_4');
  end;
end;

end.
