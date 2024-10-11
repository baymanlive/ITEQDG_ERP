{*******************************************************}
{                                                       }
{                unMPSR160                              }
{                Author: kaikai                         }
{                Create date: 2018/5/24                 }
{                Description: 工單合鍋統計表            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR160;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, unGridDesign;

type
  TFrmMPSR160 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_CDS1,l_CDS2:TClientDataSet;
    l_GridDesign:TGridDesign;
    procedure GetDS(xFliter:string);
    { Private declarations }
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmMPSR160: TFrmMPSR160;

implementation

uses unGlobal, unCommon, unMPSR160_Query;

{$R *.dfm}

const l_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="sdate" fieldtype="date"/>'
            +'<FIELD attrname="machine" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="sno" fieldtype="i4"/>'
            +'<FIELD attrname="cnt" fieldtype="i4"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const l_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="sdate" fieldtype="date"/>'
            +'<FIELD attrname="machine" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="sno" fieldtype="i4"/>'
            +'<FIELD attrname="cnt" fieldtype="i4"/>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="sqty" fieldtype="r8"/>'
            +'<FIELD attrname="premark" fieldtype="string" WIDTH="200"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

procedure TFrmMPSR160.GetDS(xFliter:string);
var
  Data:OleVariant;
  tmpSQL,str1,str2:string;
  tmpCDS:TClientDataSet;
begin
  l_CDS1.DisableControls;
  l_CDS1.EmptyDataSet;
  l_CDS2.DisableControls;
  l_CDS2.EmptyDataSet;
  g_StatusBar.Panels[0].Text:='正在查詢...';
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select simuver,citem,jitem,oz,sdate,machine,currentboiler,substring(materialno,2,1) as ad,sqty,premark'
           +' from mps010 where bu='+Quotedstr(g_UInfo^.BU)+xFliter
           +' union all'
           +' select simuver,citem,jitem,oz,sdate,machine,currentboiler,substring(materialno,2,1) as ad,sqty,premark'
           +' from MPS010_20160409 where bu='+Quotedstr(g_UInfo^.BU)+xFliter
           +' order by machine,sdate,currentboiler,jitem,oz,simuver,citem';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if IsEmpty then
         Exit;
      while not Eof do
      begin
        if l_CDS1.Locate('sdate;machine;sno',
              VarArrayOf([FieldByName('sdate').AsDateTime,
                          FieldByName('machine').AsString,
                          FieldByName('currentboiler').AsInteger]),[]) then
           l_CDS1.Edit
        else begin
          l_CDS1.Append;
          l_CDS1.FieldByName('sdate').AsDateTime:=FieldByName('sdate').AsDateTime;
          l_CDS1.FieldByName('machine').AsString:=FieldByName('machine').AsString;
          l_CDS1.FieldByName('sno').AsInteger:=FieldByName('currentboiler').AsInteger;
        end;
        l_CDS1.FieldByName('cnt').AsInteger:=l_CDS1.FieldByName('cnt').AsInteger+1;
        l_CDS1.Post;

        l_CDS2.Append;
        l_CDS2.FieldByName('sdate').AsDateTime:=FieldByName('sdate').AsDateTime;
        l_CDS2.FieldByName('machine').AsString:=FieldByName('machine').AsString;
        l_CDS2.FieldByName('sno').AsInteger:=FieldByName('currentboiler').AsInteger;
        //l_CDS2.FieldByName('cnt').AsInteger:=
        l_CDS2.FieldByName('ad').AsString:=FieldByName('ad').AsString;
        l_CDS2.FieldByName('sqty').AsFloat:=FieldByName('sqty').AsFloat;
        l_CDS2.FieldByName('premark').AsString:=FieldByName('premark').AsString;
        l_CDS2.Post;
        Next;
      end;
    end;

    str1:='@';
    with l_CDS2 do
    begin
      First;
      while not Eof do
      begin
        str2:=DateToStr(FieldByName('sdate').AsDateTime)+'/'+FieldByName('machine').AsString+'/'+IntToStr(FieldByName('sno').AsInteger);
        Edit;
        if str1<>str2 then
        begin
          str1:=str2;
          if l_CDS1.Locate('sdate;machine;sno',
                VarArrayOf([FieldByName('sdate').AsDateTime,
                            FieldByName('machine').AsString,
                            FieldByName('sno').AsInteger]),[]) then
            FieldByName('cnt').AsInteger:=l_CDS1.FieldByName('cnt').AsInteger
          else
            FieldByName('cnt').AsInteger:=0;
        end else
        begin
          FieldByName('sdate').Clear;
          FieldByName('machine').Clear;
          FieldByName('sno').Clear;
          FieldByName('cnt').Clear;
        end;
        Post;
        Next;
      end;
    end;

    if l_CDS1.ChangeCount>0 then
       l_CDS1.MergeChangeLog;
    if l_CDS2.ChangeCount>0 then
       l_CDS2.MergeChangeLog;
  finally
    tmpCDS.Free;
    l_CDS1.EnableControls;
    l_CDS2.EnableControls;
    CDS.Data:=l_CDS1.Data;
    CDS2.Data:=l_CDS2.Data;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR160.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR160_1';
  p_GridDesignAns:=True;
  l_CDS1:=TClientDataSet.Create(Self);
  l_CDS2:=TClientDataSet.Create(Self);
  InitCDS(l_CDS1,l_Xml1);
  InitCDS(l_CDS2,l_Xml2);

  inherited;
  TabSheet1.Caption:=CheckLang('總表');
  TabSheet2.Caption:=CheckLang('明細表');
  SetGrdCaption(DBGridEh2, 'MPSR160_2');
  l_GridDesign:=TGridDesign.Create(DBGridEh2, 'MPSR160_2');
end;

procedure TFrmMPSR160.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  if Assigned(l_GridDesign) then
     FreeAndNil(l_GridDesign);
  DBGridEh2.Free;
end;

procedure TFrmMPSR160.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS2);
end;

procedure TFrmMPSR160.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
  begin
    CDS.Data:=l_CDS1.Data;
    CDS2.Data:=l_CDS2.Data;
  end else
    GetDS(strFilter);
  inherited; 
end;

procedure TFrmMPSR160.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出總表請按[是]'+#13#10
              +'明細請按[否]'+#13#10
              +'無操作請按[取消]',35) of
    IdYes: GetExportXls(CDS,  'MPSR160_1');
    IdNo : GetExportXls(CDS2, 'MPSR160_2');
  end;
end;

procedure TFrmMPSR160.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR160_Query) then
     FrmMPSR160_Query:=TFrmMPSR160_Query.Create(Application);
  if FrmMPSR160_Query.ShowModal=mrOK then
     RefreshDS(FrmMPSR160_Query.l_ret);
end;

procedure TFrmMPSR160.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign) then
     l_GridDesign.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPSR160.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign) then
     l_GridDesign.ColWidthChange;
end;

end.
