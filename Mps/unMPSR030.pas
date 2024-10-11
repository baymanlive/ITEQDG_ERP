{*******************************************************}
{                                                       }
{                unMPSR030                              }
{                Author: kaikai                         }
{                Create date: 2017/04/21                }
{                Description: CCL排程結案明細           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, ExtCtrls, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, ToolWin, Math;

const
  l_Color1 = 16772300;  //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPSR030 = class(TFrmSTDI041)
    RG1: TRadioGroup;
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label4: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Panel2: TPanel;
    procedure RG1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_CDS670: TClientDataSet;
    l_ColorList: TStrings;
    procedure GetSumQty;
    procedure RefreshColor;
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetEdit3;
    { Private declarations }
  public    { Public declarations }
    procedure SetBarMsg(xMsg: string);
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSR030: TFrmMPSR030;


implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

//過濾數據
procedure TFrmMPSR030.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
begin
  with xCDS do
  begin
    Filtered := False;
    if xRG.ItemIndex = -1 then
      Filter := 'Machine=''@'''
    else
      Filter := 'Machine=' + Quotedstr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

procedure TFrmMPSR030.SetEdit3;
begin
  if CDS.FieldByName('Sdate').IsNull then
    Edit3.Text := ''
  else
    Edit3.Text := FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  Edit4.Text := IntToStr(CDS.FieldByName('CurrentBoiler').AsInteger);
end;

procedure TFrmMPSR030.RefreshColor;
var
  tmpStr, tmpValue: string;
  tmpCDS: TClientdataset;
begin
  l_ColorList.Clear;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;
  tmpCDS := TClientdataset.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.Filter := CDS.Filter;
    tmpCDS.Filtered := True;
    tmpCDS.IndexFieldNames := CDS.IndexFieldNames;

    tmpValue := '1';
    tmpStr := '@';
    while not tmpCDS.Eof do
    begin
      if tmpStr <> tmpCDS.FieldByName('Stealno').AsString then
      begin
        if tmpValue = '1' then
          tmpValue := '2'
        else
          tmpValue := '1';
      end;
      l_ColorList.Add(tmpValue);
      tmpStr := tmpCDS.FieldByName('Stealno').AsString;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPSR030.GetSumQty;
var
  tmpSQL, tmpMachine, S9_11: string;
  tmpSdate: TDateTime;
  tmpCurrentBoiler: Integer;
  Qty1, Qty2, tmpSqty: Double;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Edit5.Text := '0';
  Edit6.Text := '0';
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if not l_CDS670.Active then
  begin
    tmpSQL := 'select size_l,size_h,d,m from mps670 where bu=' + Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    l_CDS670.Data := Data;
  end;

  Qty1 := 0;
  Qty2 := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpMachine := CDS.FieldByName('Machine').AsString;
    tmpSdate := CDS.FieldByName('Sdate').AsDateTime;
    tmpCurrentBoiler := CDS.FieldByName('CurrentBoiler').AsInteger;
    tmpCDS.Data := CDS.Data;

    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'Machine=' + Quotedstr(tmpMachine) + ' And Sdate=' + Quotedstr(DateToStr(tmpSdate)) + ' And (ErrorFlag=0 or ErrorFlag is null)' + ' And (sqty is not null) and Sqty<>0';
      Filtered := True;
      while not Eof do
      begin
        S9_11 := Copy(FieldByName('Materialno').AsString, 9, 3);
        l_CDS670.Filtered := False;
        l_CDS670.Filter := 'size_l<=' + Quotedstr(S9_11) + ' and size_h>=' + Quotedstr(S9_11);
        l_CDS670.Filtered := True;
        if l_CDS670.IsEmpty then
          tmpSqty := FieldByName('Sqty').AsFloat
        else
          tmpSqty := Ceil(FieldByName('Sqty').AsFloat / l_CDS670.FieldByName('d').AsInteger * l_CDS670.FieldByName('m').AsInteger);
        if FieldByName('CurrentBoiler').AsInteger = tmpCurrentBoiler then
          Qty1 := Qty1 + tmpSqty;
        Qty2 := Qty2 + tmpSqty;
        Next;
      end;
    end;

    Edit5.Text := FloatToStr(Qty1);
    Edit6.Text := FloatToStr(Qty2);
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPSR030.SetBarMsg(xMsg: string);
begin
  g_StatusBar.Panels[0].Text := xMsg;
  Application.ProcessMessages;
end;

procedure TFrmMPSR030.RefreshDS(strFilter: string);
var
  tmpSQL, tmpSQL2, tmpSQL3: string;
  Data: OleVariant;
begin

  g_ProgressBar.Visible := True;
  g_ProgressBar.Position := 20;
  g_ProgressBar.Max := 100;

  Application.ProcessMessages;

  tmpSQL3 := 'select sfb01,sfb09 from openquery(' + g_UInfo^.BU + ',' + Quotedstr('select sfb01,sfb09 from sfb_file where (sfb25>=add_months(sysdate,-6)) and sfb04 in (''6'',''7'',''8'')') + ')';

  tmpSQL2 := 'select custno2,custname2,machine,sdate,currentboiler,wono,orderdate,orderno,orderitem,' + ' materialno,sqty,adate_new,custno,custom,custom2,stealno,premark,premark2,premark3,' + ' orderqty,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,edate,adhesive,thickness,' + ' copper,supplier,sizes,oz,simuver,citem,jitem,errorflag,remain_ordqty,struct' + ' from mps010 where bu=' + Quotedstr(g_UInfo^.BU) + ' and case_ans2=1 and isnull(errorflag,0)=0 ' + strFilter + ' union all' +
    ' select ''''custno2,''''custname2,machine,sdate,currentboiler,wono,orderdate,orderno,orderitem,' + ' materialno,sqty,adate_new,custno,custom,custom2,stealno,premark,premark2,' + Quotedstr('') + ' as premark3,' + ' orderqty,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,edate,adhesive,thickness,' + ' copper,supplier,sizes,oz,simuver,citem,jitem,errorflag,remain_ordqty,struct' + ' from MPS010_20160409 where bu=' + Quotedstr(g_UInfo^.BU) + ' and sdate>=getdate()-60' + ' and case_ans2=1 and isnull(errorflag,0)=0 ' + strFilter;

  tmpSQL := 'select aaa.*,bbb.sfb09 from (' + tmpSQL2 + ')aaa left join (' + tmpSQL3 + ')bbb on aaa.wono=bbb.sfb01';

  SetBarMsg('正在查詢[排程單據]與[入庫明細]...');

  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data := Data;
    if RG1.Tag = 0 then
    begin
      RefreshData(RG1, CDS);
      RefreshColor;
      DBGridEh1.Repaint;
      if CDS.IsEmpty then
      begin
        SetEdit3;
        GetSumQty;
      end;
    end;
  end;
  SetBarMsg('已查詢完畢！');

  g_ProgressBar.Position := 100;
  g_ProgressBar.Visible := false;

  inherited;
end;

procedure TFrmMPSR030.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS010';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  l_CDS670 := TClientDataSet.Create(Self);

  inherited;

  DBGridEh1.FieldColumns['sfb09'].Title.Caption := CheckLang('入庫數量');

  Label3.Caption := CheckLang('生產日期/鍋次');
  Label4.Caption := CheckLang('數量');
  l_ColorList := TStringList.Create;
  GetMPSMachine;
  CDS.IndexFieldNames := 'Machine;Jitem;OZ;Materialno;Simuver;Citem';
  RG1.Items.DelimitedText := g_MachineCCL;
  RG1.Tag := 0;
  RG1.ItemIndex := 0;
  if SameText(g_UInfo^.BU, 'ITEQJX') then
  begin
    Panel2.Width := Panel2.Width + 10;
    RG1.Width := RG1.Width + 10;
    RG1.Height := RG1.Height + 100;
  end;
end;

procedure TFrmMPSR030.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
  FreeAndNil(l_CDS670);
end;

procedure TFrmMPSR030.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetEdit3;
  GetSumQty;
end;

procedure TFrmMPSR030.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPSR030.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  tmpStr := LowerCase(Copy(CDS.FieldByName('Materialno').AsString, 2, 1));
  if Pos(tmpStr, 'q8fnu') > 0 then
    AFont.Color := clRed;

  tmpStr := CDS.FieldByName('Stealno').AsString;
  if (LowerCase(Column.FieldName) = 'Stealno') and ((Pos('37-', tmpStr) > 0) or (Pos('40-', tmpStr) > 0) or (Pos('55-', tmpStr) > 0)) then
    Background := clMenuHighlight
  else if l_ColorList.Count >= CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
      Background := l_Color2
    else
      Background := l_Color1;
  end;
end;

end.

