{*******************************************************}
{                                                       }
{                unMPSR170                              }
{                Author: kaikai                         }
{                Create date: 2018/7/18                 }
{                Description: 每日答交量統計表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR170;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, StdCtrls, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, DateUtils, Math;

type
  TFrmMPSR170 = class(TFrmSTDI040)
    TabSheet20: TTabSheet;
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    procedure GetDS1(mtype:Integer; bu, custno, code2, code3_4L,code3_4H, d1, d2:string);
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmMPSR170: TFrmMPSR170;

implementation

uses unGlobal, unCommon, unMPSR170_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="adate" fieldtype="DateTime"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMPSR170.GetDS1(mtype:Integer; bu, custno, code2,code3_4L, code3_4H, d1, d2:string);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  g_StatusBar.Panels[0].Text:='正在查詢資料,查詢過程較慢,請等待...';
  Application.ProcessMessages;
  try
    tmpSQL:='exec [dbo].[proc_MPSR170] '+Quotedstr(bu)+','
                                        +IntToStr(mtype)+','
                                        +Quotedstr(custno)+','
                                        +Quotedstr(code2)+','
                                        +Quotedstr(code3_4L)+','
                                        +Quotedstr(code3_4H)+','
                                        +Quotedstr(d1)+','
                                        +Quotedstr(d2);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    l_CDS.EmptyDataSet;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        tmpCDS.Edit;
        if mtype=2 then
           tmpCDS.FieldByName('retqty').AsFloat:=RoundTo(tmpCDS.FieldByName('qty').AsFloat*StrToIntDef(Copy(tmpCDS.FieldByName('pno').AsString,11,3),1),-3)
        else
           tmpCDS.FieldByName('retqty').AsFloat:=tmpCDS.FieldByName('qty').AsFloat;
        tmpCDS.Post;

        if l_CDS.Locate('adate', tmpCDS.FieldByName('adate').AsDateTime, []) then
           l_CDS.Edit
        else begin
          l_CDS.Append;
          l_CDS.FieldByName('adate').AsDateTime:=tmpCDS.FieldByName('adate').AsDateTime;
        end;
        l_CDS.FieldByName('qty').AsFloat:=l_CDS.FieldByName('qty').AsFloat+tmpCDS.FieldByName('retqty').AsFloat;
        l_CDS.Post;

        tmpCDS.Next;
      end;

      if tmpCDS.ChangeCount>0 then
         tmpCDS.MergeChangeLog;
      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
      CDS.Data:=l_CDS.Data;
      CDS2.Data:=tmpCDS.Data;
    finally
      FreeAndNil(tmpCDS);
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR170.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     GetDS1(-1, g_UInfo^.Bu, '', '', '', '', '', '')
  else
     GetDS1(0, g_UInfo^.Bu, '', '', '', '', '', '');

  inherited;
end;

procedure TFrmMPSR170.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR170_1';
  p_GridDesignAns:=False;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_Xml);

  inherited;

  TabSheet20.Caption:=CheckLang('明細資料');
  SetGrdCaption(DBGridEh2, 'MPSR170_2');
end;

procedure TFrmMPSR170.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR170.btn_exportClick(Sender: TObject);
begin
//  inherited;
  case ShowMsg('匯出[基本資料]請按[是]'+#13#10+'匯出[明細資料]請按[否]'+#13#10+'[取消]無操作',35) of
    IdYes:GetExportXls(CDS, p_TableName);
    IdNo:GetExportXls(CDS2, 'MPSR170_2');
  end;
end;

procedure TFrmMPSR170.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR170_query) then
     FrmMPSR170_query:=TFrmMPSR170_query.Create(Application);
  if FrmMPSR170_query.ShowModal=mrOK then
     GetDS1(FrmMPSR170_query.rgp1.ItemIndex,
            FrmMPSR170_query.rgp2.Items.Strings[FrmMPSR170_query.rgp2.ItemIndex],
            Trim(FrmMPSR170_query.Edit1.Text),
            Trim(FrmMPSR170_query.Edit2.Text),
            Trim(FrmMPSR170_query.Edit3.Text),
            Trim(FrmMPSR170_query.Edit4.Text),
            DateToStr(FrmMPSR170_query.dtp1.Date),
            DateToStr(FrmMPSR170_query.dtp2.Date));
end;

end.

