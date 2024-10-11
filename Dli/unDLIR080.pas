{*******************************************************}
{                                                       }
{                unDLIR080                              }
{                Author: kaikai                         }
{                Create date: 2016/7/15                 }
{                Description: 出貨單出廠回聯統計表      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR080;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, DateUtils;

type
  TFrmDLIR080 = class(TFrmSTDI041)
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh1KeyPress(Sender: TObject; var Key: Char);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_RgpIndex1,l_RgpIndex2,l_RgpIndex3:Integer;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR080: TFrmDLIR080;

implementation

uses unGlobal, unCommon, unDLIR080_Query, unDLIR080_detail;

{$R *.dfm}

procedure TFrmDLIR080.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  tmpSQL:='exec dbo.proc_DLIR080 '+Quotedstr(g_UInfo^.BU)+','
                                  +Quotedstr(strFilter)+','
                                  +IntToStr(l_RgpIndex1)+','
                                  +IntToStr(l_RgpIndex2)+','
                                  +IntToStr(l_RgpIndex3);
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    if CDS.IsEmpty then
       Label3.Caption:=''
    else
       Label3.Caption:=CheckLang('出廠 '+IntToStr(CDS.FieldByName('outcnt').AsInteger)+'    回聯 '+
                                         IntToStr(CDS.FieldByName('backcnt').AsInteger)+'    簽收 '+
                                         IntToStr(CDS.FieldByName('confcnt').AsInteger));
  end;
  g_StatusBar.Panels[0].Text:='';
  
  inherited;
end;

procedure TFrmDLIR080.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR080';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('雙擊查看訂單資料');
  
  inherited;

  l_RgpIndex1:=2;
  l_RgpIndex2:=2;
  l_RgpIndex3:=2;
  Label3.Caption:='';
end;

procedure TFrmDLIR080.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR080_Query) then
     FrmDLIR080_Query:=TFrmDLIR080_Query.Create(Application);
  if FrmDLIR080_Query.ShowModal=mrOK then
  begin
    l_RgpIndex1:=FrmDLIR080_Query.Rgp1.ItemIndex;
    l_RgpIndex2:=FrmDLIR080_Query.Rgp2.ItemIndex;
    l_RgpIndex3:=FrmDLIR080_Query.Rgp3.ItemIndex;
    RefreshDS(FrmDLIR080_Query.l_QueryStr);
  end;
end;

procedure TFrmDLIR080.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if not CDS.IsEmpty then
  begin
    FrmDLIR080_detail:=TFrmDLIR080_detail.Create(nil);
    FrmDLIR080_detail.l_oga01:=CDS.FieldByName('saleno').AsString;
    try
      FrmDLIR080_detail.ShowModal;
    finally
      FreeAndNil(FrmDLIR080_detail);
    end;
  end;
end;

procedure TFrmDLIR080.DBGridEh1KeyPress(Sender: TObject; var Key: Char);
var
  str,tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if g_MInfo^.R_edit and (not CDS.IsEmpty) and (key=chr(VK_SPACE)) then
  begin
    tmpSQL:='select top 1 back from dli014 where bu='+Quotedstr(g_UInfo^.BU)
           +' and saleno='+Quotedstr(CDS.FieldByName('saleno').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;

    if VarToStr(Data)<>'Y' then
    begin
      ShowMsg('未回聯,不可簽收!', 48);
      Exit;
    end;

    if CDS.FieldByName('conf').AsString='Y' then
       str:='N'
    else
       str:='Y';
    if str='N' then
       tmpSQL:='update dli014 set conf=''N'',confuser=null,conftime=null'
    else
       tmpSQL:='update dli014 set conf=''Y'',confuser='+Quotedstr(g_UInfo^.UserId)
              +',conftime='+Quotedstr(StringReplace(FormatDateTime(g_cLongTimeSP,Now),'/','-',[rfReplaceAll]));
    tmpSQL:=tmpSQL+' where bu='+Quotedstr(g_UInfo^.BU)
                  +' and saleno='+Quotedstr(CDS.FieldByName('saleno').AsString);
    if PostBySQL(tmpSQL) then
    begin
      CDS.Edit;
      CDS.FieldByName('conf').AsString:=str;
      CDS.Post;
      CDS.MergeChangeLog;
    end;
  end;
end;

procedure TFrmDLIR080.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
var
  D:TDateTime;
begin
  inherited;
  if CDS.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'out') then
  begin
    if CDS.FieldByName('outtime').IsNull then
       D:=Date
    else
       D:=CDS.FieldByName('outtime').AsDateTime;
    if DaysBetween(DateOf(CDS.FieldByName('saledate').AsDateTime), DateOf(D))>1 then
       Background:=clRed;
  end;

  if SameText(Column.FieldName,'back') and
     (CDS.FieldByName('days').AsInteger>0) and
     (CDS.FieldByName('out').AsString='Y') then
  begin
    if CDS.FieldByName('backtime').IsNull then
       D:=Date
    else
       D:=CDS.FieldByName('backtime').AsDateTime;
    if DaysBetween(DateOf(CDS.FieldByName('outtime').AsDateTime), DateOf(D))>CDS.FieldByName('days').AsInteger then
       Background:=clRed;
  end;
end;

end.
