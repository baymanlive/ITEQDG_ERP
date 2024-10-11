{*******************************************************}
{                                                       }
{                unDLIR150                              }
{                Author: kaikai                         }
{                Create date: 2017/12/26                }
{                Description: 排程出貨達交率分析表      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR150;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ComCtrls, ImgList, ExtCtrls, DB, DBClient, Math, GridsEh,
  DBAxisGridsEh, DBGridEh, StdCtrls, ToolWin, DateUtils;

type
  TFrmDLIR150 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    Lv1: TListView;
    Label3: TLabel;
    Label4: TLabel;
    Lv2: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
  private
    l_indate:TDateTime;
	  l_bu,l_custno,l_orderno,l_ad:string;
    l_SalCDS:TClientDataSet;
    l_AdCDS:TClientDataSet;
    l_CustnoCDS:TClientDataSet;
    l_StrIndex,l_StrIndexDesc:string;
    procedure GetDS;
    { Private declarations }
  public
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmDLIR150: TFrmDLIR150;

implementation

uses unGlobal, unCommon, unDLIR150_Query, unDLIR150_ExportXlsSelect;

{$R *.dfm}

const g_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="indate" fieldtype="date"/>'
            +'<FIELD attrname="odate" fieldtype="date"/>'
            +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="orderitem" fieldtype="i4"/>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="pname" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
            +'<FIELD attrname="longitude" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="latitude" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
            +'<FIELD attrname="orderqty" fieldtype="r8"/>'
            +'<FIELD attrname="qty1" fieldtype="r8"/>'
            +'<FIELD attrname="qty2" fieldtype="r8"/>'
            +'<FIELD attrname="outqty1" fieldtype="r8"/>'
            +'<FIELD attrname="outqty2" fieldtype="r8"/>'
            +'<FIELD attrname="remainqty1" fieldtype="r8"/>'
            +'<FIELD attrname="remainqty2" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
            +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="totcnt" fieldtype="i4"/>'
            +'<FIELD attrname="overdaycnt" fieldtype="i4"/>'
            +'<FIELD attrname="remainqtycnt" fieldtype="i4"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml3='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="ad" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="totcnt" fieldtype="i4"/>'
            +'<FIELD attrname="overdaycnt" fieldtype="i4"/>'
            +'<FIELD attrname="remainqtycnt" fieldtype="i4"/>'
            +'<FIELD attrname="per" fieldtype="string" WIDTH="10"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

procedure TFrmDLIR150.GetDS();
var
  i,pos1:Integer;
  Data:OleVariant;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
begin
  l_SalCDS.DisableControls;
  l_SalCDS.EmptyDataSet;
  l_CustnoCDS.EmptyDataSet;
  l_AdCDS.EmptyDataSet;
  Lv1.Items.BeginUpdate;
  Lv2.Items.BeginUpdate;
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢排程出貨資料...');
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='exec [dbo].[proc_DLIR150] '+Quotedstr(l_bu)+','
                                        +Quotedstr(DateToStr(l_indate))+','
                                        +Quotedstr(l_custno)+','
                                        +Quotedstr(l_orderno)+','
                                        +Quotedstr(l_ad);
    if  not QueryBySQL(tmpSQL, Data) then
        Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    begin
      if IsEmpty then
         Exit;
      while not Eof do
      begin
        l_SalCDS.Append;
        for i:=0 to Fields.Count-1 do
        if l_SalCDS.FindField(Fields[i].FieldName)<>nil then
           l_SalCDS.FieldByName(Fields[i].FieldName).Value:=Fields[i].Value;

        pos1:=Pos('BS',FieldByName('pname').AsString);
        if pos1=0 then
           pos1:=Pos('TC',FieldByName('pname').AsString);
        if pos1>0 then
           l_SalCDS.FieldByName('ad').AsString:=Copy(FieldByName('pname').AsString,1,pos1-1);
        if SameText(FieldByName('units').AsString, 'RL') then
        begin
          l_SalCDS.FieldByName('qty2').AsFloat:=StrToInt(Copy(FieldByName('pno').AsString,11,3))*FieldByName('qty1').AsFloat;
          l_SalCDS.FieldByName('outqty2').AsFloat:=StrToInt(Copy(FieldByName('pno').AsString,11,3))*FieldByName('outqty1').AsFloat;
        end
        else if SameText(FieldByName('units').AsString, 'PN') then
        begin
          if FieldByName('pno').AsString[1] in ['E','T'] then
          begin
            l_SalCDS.FieldByName('qty2').AsFloat:=RoundTo(FieldByName('qty1').AsFloat/5, -2);
            l_SalCDS.FieldByName('outqty2').AsFloat:=RoundTo(FieldByName('outqty1').AsFloat/5, -2);
          end else
          begin
            l_SalCDS.FieldByName('qty2').AsFloat:=RoundTo(FieldByName('qty1').AsFloat/3.75, -2);
            l_SalCDS.FieldByName('outqty2').AsFloat:=RoundTo(FieldByName('outqty1').AsFloat/3.75, -2);
          end;
        end else
        begin
          l_SalCDS.FieldByName('qty2').AsFloat:=FieldByName('qty1').AsFloat;
          l_SalCDS.FieldByName('outqty2').AsFloat:=FieldByName('outqty1').AsFloat;
        end;
        l_SalCDS.FieldByName('remainqty1').AsFloat:=RoundTo(l_SalCDS.FieldByName('qty1').AsFloat-l_SalCDS.FieldByName('outqty1').AsFloat,-2);
        l_SalCDS.FieldByName('remainqty2').AsFloat:=RoundTo(l_SalCDS.FieldByName('qty2').AsFloat-l_SalCDS.FieldByName('outqty2').AsFloat,-2);
        l_SalCDS.Post;

        //客戶達成率
        if not l_CustnoCDS.Locate('custno',FieldByName('custno').AsString,[]) then
        begin
          l_CustnoCDS.Append;
          l_CustnoCDS.FieldByName('custno').AsString:=FieldByName('custno').AsString;
          l_CustnoCDS.FieldByName('custshort').AsString:=FieldByName('custshort').AsString;
        end else
          l_CustnoCDS.Edit;
        l_CustnoCDS.FieldByName('totcnt').AsInteger:=l_CustnoCDS.FieldByName('totcnt').AsInteger+1;
        if l_SalCDS.FieldByName('outqty1').AsFloat=0 then      //出0:甩期
           l_CustnoCDS.FieldByName('overdaycnt').AsInteger:=l_CustnoCDS.FieldByName('overdaycnt').AsInteger+1;
        if l_SalCDS.FieldByName('remainqty1').AsFloat>0 then   //出部分:尾數
           l_CustnoCDS.FieldByName('remainqtycnt').AsInteger:=l_CustnoCDS.FieldByName('remainqtycnt').AsInteger+1;
        l_CustnoCDS.Post;

        //膠系達成率
        if Length(l_SalCDS.FieldByName('ad').AsString)>0 then
        begin
          if not l_AdCDS.Locate('ad',l_SalCDS.FieldByName('ad').AsString,[]) then
          begin
            l_AdCDS.Append;
            l_AdCDS.FieldByName('ad').AsString:=l_SalCDS.FieldByName('ad').AsString;
          end else
            l_AdCDS.Edit;
          l_AdCDS.FieldByName('totcnt').AsInteger:=l_AdCDS.FieldByName('totcnt').AsInteger+1;
          if l_SalCDS.FieldByName('outqty1').AsFloat=0 then    //出0:甩期
             l_AdCDS.FieldByName('overdaycnt').AsInteger:=l_AdCDS.FieldByName('overdaycnt').AsInteger+1;
          if l_SalCDS.FieldByName('remainqty1').AsFloat>0 then //出部分:尾數
             l_AdCDS.FieldByName('remainqtycnt').AsInteger:=l_AdCDS.FieldByName('remainqtycnt').AsInteger+1;
          l_AdCDS.Post;
        end;

        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在添加計算結果...');
    Application.ProcessMessages;
    Lv1.Items.Clear;
    Lv2.Items.Clear;
    with l_CustnoCDS do
    begin
      IndexFieldNames:='custno';
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('per').AsString:=FloatToStr(Round((FieldByName('totcnt').AsInteger-FieldByName('overdaycnt').AsInteger)/FieldByName('totcnt').AsInteger*100))+'%';
        Post;

        with Lv1.Items.Add do
        begin
          Caption:=FieldByName('custno').AsString;
          SubItems.Add(FieldByName('custshort').AsString);
          SubItems.Add(IntToStr(FieldByName('totcnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('overdaycnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('remainqtycnt').AsInteger));
          SubItems.Add(FieldByName('per').AsString);
        end;
        Next;
      end;
      IndexFieldNames:='';
    end;

    with l_AdCDS do
    begin
      IndexFieldNames:='ad';
      First;
      While not Eof do
      begin
        Edit;
        FieldByName('per').AsString:=FloatToStr(Round((FieldByName('totcnt').AsInteger-FieldByName('overdaycnt').AsInteger)/FieldByName('totcnt').AsInteger*100))+'%';
        Post;
        with Lv2.Items.Add do
        begin
          Caption:=FieldByName('ad').AsString;
          SubItems.Add(IntToStr(FieldByName('totcnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('overdaycnt').AsInteger));
          SubItems.Add(IntToStr(FieldByName('remainqtycnt').AsInteger));
          SubItems.Add(FieldByName('per').AsString);
        end;
        Next;
      end;
      IndexFieldNames:='';
    end;

    if l_SalCDS.ChangeCount>0 then
       l_SalCDS.MergeChangeLog;
    if l_CustnoCDS.ChangeCount>0 then
       l_CustnoCDS.MergeChangeLog;
    if l_AdCDS.ChangeCount>0 then
       l_AdCDS.MergeChangeLog;
  finally
    Lv1.Items.EndUpdate;
    Lv2.Items.EndUpdate;
    FreeAndNil(tmpCDS);
    l_SalCDS.EnableControls;
    CDS.Data:=l_SalCDS.Data;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmDLIR150.RefreshDS(strFilter: string);
begin
  if strFilter=g_cFilterNothing then
     CDS.Data:=l_SalCDS.Data
  else
     GetDS;

  inherited;
end;

procedure TFrmDLIR150.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR150';
  p_GridDesignAns:=True;
  l_SalCDS:=TClientDataSet.Create(Self);
  l_CustnoCDS:=TClientDataSet.Create(Self);
  l_AdCDS:=TClientDataSet.Create(Self);
  InitCDS(l_SalCDS, g_Xml1);
  InitCDS(l_CustnoCDS, g_Xml2);
  InitCDS(l_AdCDS, g_Xml3);

  inherited;
  
  TabSheet2.Caption:=CheckLang('達成率');
  Label3.Caption:=CheckLang('客戶');
  Label4.Caption:=CheckLang('膠系');
  with Lv1.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('客戶編號');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('客戶簡稱');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('總筆數');
      Width:=80;
    end;    
    with Add do
    begin
      Caption:=CheckLang('甩期筆數');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('欠尾數筆數');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('達成率');
      Width:=70;
    end;
    EndUpdate;
  end;

  with Lv2.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('膠系');
      Width:=100;
    end;
    with Add do
    begin
      Caption:=CheckLang('總筆數');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('甩期筆數');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('欠尾數筆數');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('達成率');
      Width:=70;
    end;
    EndUpdate;
  end;
end;

procedure TFrmDLIR150.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SalCDS);
  FreeAndNil(l_CustnoCDS);
  FreeAndNil(l_AdCDS);
end;

procedure TFrmDLIR150.btn_exportClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR150_ExportXlsSelect) then
     FrmDLIR150_ExportXlsSelect:=TFrmDLIR150_ExportXlsSelect.Create(Application);
  if FrmDLIR150_ExportXlsSelect.ShowModal=mrOK then
  begin
    case FrmDLIR150_ExportXlsSelect.rgp.ItemIndex of
      0:GetExportXls(CDS, p_TableName);
      1:GetExportXls(l_CustnoCDS, 'DLIR150_1');
      2:GetExportXls(l_AdCDS, 'DLIR150_2');
    end;
  end;
end;

procedure TFrmDLIR150.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR150_Query) then
     FrmDLIR150_Query:=TFrmDLIR150_Query.Create(Application);
  if FrmDLIR150_Query.ShowModal=mrOK then
  begin
    if FrmDLIR150_Query.rgp.ItemIndex=0 then
       l_bu:='ITEQDG'
    else
       l_bu:='ITEQGZ';
    l_indate:=FrmDLIR150_Query.Dtp1.Date;
    l_custno:=Trim(FrmDLIR150_Query.Edit1.Text);
    l_orderno:=Trim(FrmDLIR150_Query.Edit2.Text);
    l_ad:=Trim(FrmDLIR150_Query.Edit3.Text);
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS('');
  end;
end;

procedure TFrmDLIR150.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
