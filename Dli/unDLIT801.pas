{*******************************************************}
{                                                       }
{                unDLIT801                              }
{                Author: kaikai                         }
{                Create date: 2019/6/24                 }
{                Description: 庫存盤點檢核              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIT801;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, StrUtils;

type
  TFrmDLIT801 = class(TFrmSTDI040)
    PCL2: TPageControl;
    TabSheet100: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_dlit801: TToolButton;
    TabSheet200: TTabSheet;
    DBGridEh3: TDBGridEh;
    DS3: TDataSource;
    CDS3: TClientDataSet;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_dlit801Click(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    l_fdate:TDateTime;
    l_area,l_img02,l_sql2:string;
    l_list2:TStrings;
    l_CDS,l_CDS3:TClientDataSet;
    procedure RefreshDS2;
    { Private declarations }
  public
    { Public declarations }
  protected  
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIT801: TFrmDLIT801;

implementation

uses unGlobal, unCommon, unDLIT801_query, unDLIT801_export;

const l_CDSXml='<?xml version="1.0" standalone="yes"?>'
              +'<DATAPACKET Version="2.0">'
              +'<METADATA><FIELDS>'
              +'<FIELD attrname="sno" fieldtype="i4"/>'
              +'<FIELD attrname="area" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="qty" fieldtype="r8"/>'
              +'<FIELD attrname="img02" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="img03" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="img04" fieldtype="string" WIDTH="20"/>'
              +'<FIELD attrname="img10" fieldtype="r8"/>'
              +'<FIELD attrname="result" fieldtype="string" WIDTH="20"/>'
              +'</FIELDS><PARAMS/></METADATA>'
              +'<ROWDATA></ROWDATA>'
              +'</DATAPACKET>';

const l_CDS3Xml='<?xml version="1.0" standalone="yes"?>'
               +'<DATAPACKET Version="2.0">'
               +'<METADATA><FIELDS>'
               +'<FIELD attrname="img01" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="img02" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="img03" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="img04" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="img10" fieldtype="r8"/>'
               +'<FIELD attrname="area" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
               +'<FIELD attrname="qty" fieldtype="r8"/>'
               +'<FIELD attrname="diffqty" fieldtype="r8"/>'
               +'</FIELDS><PARAMS/></METADATA>'
               +'<ROWDATA></ROWDATA>'
               +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIT801.RefreshDS(strFilter: string);
var
  isExists:Boolean;
  i,tmpSno,tmpRecno,pos1:Integer;
  tmpSQL,tmpArea,tmpImg02:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
  tmpList:TStrings;
begin
  l_CDS.EmptyDataSet;
  l_CDS3.EmptyDataSet;

  if strFilter<>g_cFilterNothing then
  begin
    tmpSQL:='select area,pno,lot,sum(qty) qty from dli801'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and fdate='+Quotedstr(DateToStr(l_fdate))
           +' and area='+Quotedstr(l_area)
           +' group by area,pno,lot'
           +' order by area,pno,lot';
    if QueryBySQL(tmpSQL,Data) then
    begin
      tmpSno:=0;
      tmpCDS1:=TClientDataSet.Create(nil);
      tmpCDS2:=TClientDataSet.Create(nil);
      tmpList:=TStringList.Create;
      try
        tmpCDS1.Data:=Data;

        if Pos(',',l_img02)>0 then
        begin
          tmpList.DelimitedText:=l_img02;
          for i:=0 to tmpList.Count-1 do
            tmpImg02:=tmpImg02+','+Quotedstr(tmpList.Strings[i]);
          Delete(tmpImg02,1,1);
          tmpImg02:=' and img02 in ('+tmpImg02+')';
        end
        else if Length(l_img02)>0 then
          tmpImg02:=' and img02='+Quotedstr(l_img02);

        g_ProgressBar.Position:=0;
        g_ProgressBar.Max:=tmpCDS1.RecordCount;
        g_ProgressBar.Visible:=True;
        g_StatusBar.Panels[0].Text:=CheckLang('正在處理,請稍等...');
        while not tmpCDS1.Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;
          Application.ProcessMessages;

          inc(tmpSno);
          l_CDS.Append;
          l_CDS.FieldByName('sno').AsInteger:=tmpSno;
          l_CDS.FieldByName('area').AsString:=tmpCDS1.FieldByName('area').AsString;
          l_CDS.FieldByName('pno').AsString:=tmpCDS1.FieldByName('pno').AsString;
          l_CDS.FieldByName('lot').AsString:=tmpCDS1.FieldByName('lot').AsString;
          l_CDS.FieldByName('qty').AsFloat:=tmpCDS1.FieldByName('qty').AsFloat;
          l_CDS.FieldByName('result').AsString:='N';
          l_CDS.Post;

          Data:=null;
          tmpSQL:='select img01,img02,img03,img04,img10 from '+g_UInfo^.BU+'.img_file'
                 +' where img01='+Quotedstr(tmpCDS1.FieldByName('pno').AsString)+tmpImg02
                 +' and substr(img04,2,8)='+Quotedstr(Copy(tmpCDS1.FieldByName('lot').AsString,2,8))
                 +' and img10>0 and length(img04)>=9';
          if not QueryBySQL(tmpSQL,Data,'ORACLE') then
             Exit;
          tmpCDS2.Data:=Data;
          while not tmpCDS2.Eof do
          begin
            if tmpCDS2.RecNo=1 then
               l_CDS.Edit
            else begin
              Inc(tmpSno);
              l_CDS.Append;
              l_CDS.FieldByName('sno').AsInteger:=tmpSno;
              l_CDS.FieldByName('result').AsString:='N';
            end;

            l_CDS.FieldByName('img02').AsString:=tmpCDS2.FieldByName('img02').AsString;
            l_CDS.FieldByName('img03').AsString:=tmpCDS2.FieldByName('img03').AsString;
            l_CDS.FieldByName('img04').AsString:=tmpCDS2.FieldByName('img04').AsString;
            l_CDS.FieldByName('img10').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;

            tmpArea:=tmpCDS2.FieldByName('img03').AsString;
            pos1:=Pos('-0',tmpArea);
            if pos1>0 then
               tmpArea:=Copy(tmpArea,1,pos1-1);
            if SameText(tmpCDS1.FieldByName('area').AsString,tmpArea) and
               (tmpCDS1.FieldByName('qty').AsFloat=tmpCDS2.FieldByName('img10').AsFloat) then
               l_CDS.FieldByName('result').AsString:='Y';
            l_CDS.Post;

            tmpCDS2.Next;
          end;

          tmpCDS1.Next;
        end;

        //計算有帳無物資料,必需輸入倉庫
        if Length(tmpImg02)>0 then
        begin
          g_ProgressBar.Position:=0;
          Application.ProcessMessages;
          Data:=null;
          tmpSQL:='select img01,img02,img03,img04,img10 from '+g_UInfo^.BU+'.img_file'
                 +' where (img01 like ''E%'' or img01 like ''T%'''
                 +' or img01 like ''B%'' or img01 like ''R%'''
                 +' or img01 like ''M%'' or img01 like ''N%'') '+tmpImg02
                 +' and (img03='+Quotedstr(l_area)+' or img03 like '+Quotedstr(l_area+'-0%')+') and img10>0';
          if QueryBySQL(tmpSQL,Data,'ORACLE') then
          begin
            tmpCDS2.Data:=Data;
            g_ProgressBar.Max:=tmpCDS2.RecordCount;
            while not tmpCDS2.Eof do
            begin
              g_ProgressBar.Position:=g_ProgressBar.Position+1;
              Application.ProcessMessages;

              isExists:=False;
              tmpRecno:=-1;
              tmpCDS1.First;
              while not tmpCDS1.Eof do
              begin
                //料號相等、批號2-9碼相等、儲位相等、數量相等：視為存在
                if (tmpCDS2.FieldByName('img01').AsString=tmpCDS1.FieldByName('pno').AsString) and
                   ((tmpCDS2.FieldByName('img03').AsString=tmpCDS1.FieldByName('area').AsString) or
                    (Pos(tmpCDS1.FieldByName('area').AsString+'-0',tmpCDS2.FieldByName('img03').AsString)>0)) and
                   (Copy(tmpCDS2.FieldByName('img04').AsString,2,8)=Copy(tmpCDS1.FieldByName('lot').AsString,2,8)) then
                begin
                  tmpRecno:=tmpCDS1.RecNo;
                  if tmpCDS2.FieldByName('img10').AsFloat=tmpCDS1.FieldByName('qty').AsFloat then
                     isExists:=True;
                  Break;
                end;

                tmpCDS1.Next;
              end;

              if not isExists then
              begin
                l_CDS3.Append;
                l_CDS3.FieldByName('img01').AsString:=tmpCDS2.FieldByName('img01').AsString;
                l_CDS3.FieldByName('img02').AsString:=tmpCDS2.FieldByName('img02').AsString;
                l_CDS3.FieldByName('img03').AsString:=tmpCDS2.FieldByName('img03').AsString;
                l_CDS3.FieldByName('img04').AsString:=tmpCDS2.FieldByName('img04').AsString;
                l_CDS3.FieldByName('img10').AsFloat:=tmpCDS2.FieldByName('img10').AsFloat;
                if tmpRecno<>-1 then
                begin
                  tmpCDS1.RecNo:=tmpRecno;
                  l_CDS3.FieldByName('area').AsString:=tmpCDS1.FieldByName('area').AsString;
                  l_CDS3.FieldByName('lot').AsString:=tmpCDS1.FieldByName('lot').AsString;
                  l_CDS3.FieldByName('qty').AsFloat:=tmpCDS1.FieldByName('qty').AsFloat;
                end;
                l_CDS3.FieldByName('diffqty').AsFloat:=l_CDS3.FieldByName('img10').AsFloat-l_CDS3.FieldByName('qty').AsFloat;
                l_CDS3.Post;
              end;
              tmpCDS2.Next;
            end;
          end;
        end;

      finally
        g_ProgressBar.Visible:=False;
        g_StatusBar.Panels[0].Text:='';
        FreeAndNil(tmpCDS1);
        FreeAndNil(tmpCDS2);
        FreeAndNil(tmpList);
      end;
    end;
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;
  if l_CDS3.ChangeCount>0 then
     l_CDS3.MergeChangeLog;
  CDS.Data:=l_CDS.Data;
  CDS.IndexFieldNames:='sno';
  CDS3.Data:=l_CDS3.Data;
  if CDS.IsEmpty then
  begin
    if CDS2.Active then
       CDS2.EmptyDataSet
    else
       RefreshDS2;
  end;

  inherited;
end;

procedure TFrmDLIT801.RefreshDS2;
var
  tmpSQL:string;
begin
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='Select * From DLI801 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Area='+Quotedstr(CDS.FieldByName('Area').AsString)
         +' And Pno='+Quotedstr(CDS.FieldByName('Pno').AsString)
         +' And Lot='+Quotedstr(CDS.FieldByName('Lot').AsString)
         +' Order By Sno';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLIT801.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIT801_1';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('檢核條件:料號+批號(2-10碼),檢核結果:儲位相同為Y,不同為N');
  btn_dlit801.Left:=btn_quit.Left;
  l_CDS:=TClientDataSet.Create(nil);
  l_CDS3:=TClientDataSet.Create(nil);
  InitCDS(l_CDS,l_CDSXml);
  InitCDS(l_CDS3,l_CDS3Xml);

  inherited;

  SetGrdCaption(DBGridEh2, 'DLIT801_2');
  SetGrdCaption(DBGridEh3, 'DLIT801_3');
  TabSheet100.Caption:=CheckLang('盤點資料');
  TabSheet200.Caption:=CheckLang('有帳無實物資料');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmDLIT801.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  CDS2.Active:=False;
  CDS3.Active:=False;
  DBGridEh2.Free;
  DBGridEh3.Free;
  FreeAndNil(l_CDS);
  FreeAndNil(l_CDS3);
  FreeAndNil(l_list2);
end;

procedure TFrmDLIT801.CDSAfterScroll(DataSet: TDataSet);
begin
  RefreshDS2;

  inherited;
end;

procedure TFrmDLIT801.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIT801_query) then
     FrmDLIT801_query:=TFrmDLIT801_query.Create(Application);
  if FrmDLIT801_query.ShowModal=mrOK then
  begin
    l_fdate:=FrmDLIT801_query.dtp.Date;
    l_area:=UpperCase(Trim(FrmDLIT801_query.Edit1.Text));
    l_img02:=UpperCase(Trim(FrmDLIT801_query.Edit2.Text));
    RefreshDS('');
  end;
end;

procedure TFrmDLIT801.btn_dlit801Click(Sender: TObject);
begin
  inherited;
  GetQueryStock(CDS.FieldByName('pno').AsString, False);
end;

procedure TFrmDLIT801.btn_exportClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIT801_export) then
  begin
    FrmDLIT801_export:=TFrmDLIT801_export.Create(Application);
    FrmDLIT801_export.rgp.Items.Strings[0]:=TabSheet1.Caption;
    FrmDLIT801_export.rgp.Items.Strings[1]:=TabSheet200.Caption;
    FrmDLIT801_export.rgp.Items.Strings[2]:=TabSheet100.Caption;
  end;

  if FrmDLIT801_export.ShowModal<>mrOK then
     Exit;

  case FrmDLIT801_export.rgp.ItemIndex of
    0:GetExportXls(CDS, p_TableName);
    1:GetExportXls(CDS3, 'DLIT801_3');
    2:GetExportXls(CDS2, 'DLIT801_2');
  end;
end;

procedure TFrmDLIT801.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer1.Enabled:=False;
  try
    if l_List2.Count=0 then
       Exit;

    while l_List2.Count>1 do
      l_List2.Delete(l_List2.Count-1);

    tmpSQL:=l_List2.Strings[0];
    if tmpSQL=l_SQL2 then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
