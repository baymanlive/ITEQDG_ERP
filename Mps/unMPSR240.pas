{*******************************************************}
{                                                       }
{                unMPSR040                              }
{                Author: kaikai                         }
{                Create date: 2017/04/21                }
{                Description: PP排程結案明細            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR240;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  TWODbarcode, DynVarsEh, StdCtrls, ExtCtrls, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

const
  l_Color1 = 16772300;  //RGB(204,236,255);   //淺藍

const
  l_Color2 = 13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPSR240 = class(TFrmSTDI041)
    RG1: TRadioGroup;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    Panel2: TPanel;
    procedure RG1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
  private
    Fm_image: PTIMAGESTRUCT;
    l_date1, l_date2: TDateTime;
    l_ColorList: TStrings;
    function GetSumQty(SourceCDS: TClientDataSet): Double;
    procedure RefreshColor;
    procedure RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
    procedure SetEdit3;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSR240: TFrmMPSR240;

implementation

uses
  unGlobal, unCommon, unMPSR240_query;

{$R *.dfm}

//過濾數據
procedure TFrmMPSR240.RefreshData(xRG: TRadioGroup; xCDS: TClientDataSet);
begin
  with xCDS do
  begin
    Filtered := False;
    if xRG.ItemIndex = -1 then
      Filter := 'Machine=''@'''
    else
      Filter := 'Machine=' + QuotedStr(xRG.Items[xRG.ItemIndex]);
    Filtered := True;
  end;
end;

procedure TFrmMPSR240.SetEdit3;
begin
  if CDS.FieldByName('Sdate').IsNull then
    Edit3.Text := ''
  else
    Edit3.Text := FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  Edit4.Text := FloatToStr(GetSumQty(CDS));
end;

procedure TFrmMPSR240.RefreshColor;
var
  tmpValue: string;
  tmpSdate: TDateTime;
  tmpCDS: TClientDataSet;
begin
  l_ColorList.Clear;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.Filter := CDS.Filter;
    tmpCDS.Filtered := True;
    tmpCDS.AddIndex('xIndex', CDS.IndexDefs[0].Fields, [ixCaseInsensitive], CDS.IndexDefs[0].DescFields);
    tmpCDS.IndexName := 'xIndex';
    tmpValue := '1';
    tmpSdate := EncodeDate(1955, 5, 5);
    while not tmpCDS.Eof do
    begin
      if tmpSdate <> tmpCDS.FieldByName('Sdate').AsDateTime then
      begin
        if tmpValue = '1' then
          tmpValue := '2'
        else
          tmpValue := '1';
      end;
      l_ColorList.Add(tmpValue);
      tmpSdate := tmpCDS.FieldByName('Sdate').AsDateTime;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
end;

function TFrmMPSR240.GetSumQty(SourceCDS: TClientDataSet): Double;
var
  tmpCDS: TClientDataSet;
begin
  Result := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := SourceCDS.Data;
    with tmpCDS do
    begin
      Filtered := False;
      Filter := 'Machine=' + QuotedStr(SourceCDS.FieldByName('Machine').AsString) + ' And Sdate=' + QuotedStr(DateToStr(SourceCDS.FieldByName('Sdate').AsDateTime)) + ' And (Sqty is not null) And Sqty<>0';
      Filtered := True;
      while not Eof do
      begin
        Result := Result + FieldByName('Sqty').AsFloat;
        Next;
      end;
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPSR240.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'exec [dbo].[proc_MPSR240] ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(DateToStr(l_date1)) + ',' + QuotedStr(DateToStr(l_date2));
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data := Data;
    if RG1.Tag = 0 then
    begin
      RefreshData(RG1, CDS);
      RefreshColor;
      DBGridEh1.Repaint;
      if CDS.IsEmpty then
        SetEdit3;
    end;
  end;

  inherited;
end;

procedure TFrmMPSR240.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPSR240';
  p_GridDesignAns := True;
  RG1.Tag := 1;
  l_date1 := EncodeDate(1955, 5, 5);
  l_date2 := l_date1;

  inherited;

  Label3.Caption := CheckLang('生產日期/米');
  l_ColorList := TStringList.Create;
  GetMPSMachine;
  RG1.Items.DelimitedText := g_MachinePP;
  RG1.Tag := 0;
  RG1.ItemIndex := 0;
  if SameText(g_UInfo^.BU, 'ITEQJX') then
  begin
    RG1.Columns := 2;
    Panel2.Width := Panel2.Width * 2 + 10;
    RG1.Width := RG1.Width * 2 + 10;
    RG1.Height := RG1.Height + 180;
  end;
end;

procedure TFrmMPSR240.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
end;

procedure TFrmMPSR240.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetEdit3;
end;

procedure TFrmMPSR240.RG1Click(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag = 1) then
    Exit;
  RefreshData(RG1, CDS);
  RefreshColor;
  DBGridEh1.Repaint;
end;

procedure TFrmMPSR240.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if l_ColorList.Count >= CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo - 1] = '1' then
      Background := l_Color2
    else
      Background := l_Color1;
  end;
end;

procedure TFrmMPSR240.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmMPSR240_query) then
    FrmMPSR240_query := TFrmMPSR240_query.Create(Application);
  if FrmMPSR240_query.ShowModal = mrOK then
  begin
    l_date1 := FrmMPSR240_query.dtp1.Date;
    l_date2 := FrmMPSR240_query.dtp2.Date;
    RefreshDS('');
  end
end;

procedure TFrmMPSR240.btn_printClick(Sender: TObject);
var
  tmpSQL: string;
begin
  CDS.DisableControls;
  try
    CDS.first;
    while not CDS.Eof do
    begin
      tmpSQL := g_UInfo^.TempPath + CDS.FieldByName('wono').AsString + '.bmp';
      if CDS.FieldByName('wono').AsString <> '' then
      begin
        getcode(CDS.FieldByName('wono').AsString, tmpSQL, Fm_image);
        CDS.edit;
        CDS.FieldByName('qrcode').asstring:=tmpSQL;
      end;

      CDS.Next;
    end;
  finally
    CDS.EnableControls;
  end;
  inherited;

end;

end.

