{*******************************************************}
{                                                       }
{                unIPQCT502                             }
{                Author: kaikai                         }
{                Create date: 2020/9/25                 }
{                Description: VC揮發份測試記錄表        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unIPQCT502;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping, DB,
  DBClient, MConnect, SConnect, Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh, Math;

type
  TFrmIPQCT502 = class(TFrmSTDI031)
    btn_import: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_copyClick(Sender: TObject);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
  private
    { Private declarations }
    procedure valueChange(Sender: TField);
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmIPQCT502: TFrmIPQCT502;

implementation

uses
  unGlobal, unCommon;

{$R *.dfm}

procedure TFrmIPQCT502.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From IPQC502 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter +
    ' Order By fdate,ad,sizes,rc,lot';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmIPQCT502.valueChange(Sender: TField);
var
  v1, v2: Double;
begin
  v1 := CDS.FieldByName('lvalue1').AsFloat + CDS.FieldByName('mvalue1').AsFloat + CDS.FieldByName('rvalue1').AsFloat;
  v2 := CDS.FieldByName('lvalue2').AsFloat + CDS.FieldByName('mvalue2').AsFloat + CDS.FieldByName('rvalue2').AsFloat;
  if v1 <> 0 then
    v1 := (v1 - v2) / v1 * 100;
  CDS.FieldByName('vc').AsFloat := RoundTo(v1, -2);
  if v1 <= CDS.FieldByName('std').AsFloat then
    CDS.FieldByName('ret').AsString := 'Y'
  else
    CDS.FieldByName('ret').AsString := 'N';
  if CDS.FieldByName('lvalue1').AsFloat = 0 then
    CDS.FieldByName('lvalue3').value := null
  else
    CDS.FieldByName('lvalue3').AsFloat := roundto((CDS.FieldByName('lvalue1').AsFloat - CDS.FieldByName('lvalue2').AsFloat)
      / CDS.FieldByName('lvalue1').AsFloat * 100, -2);
  if CDS.FieldByName('mvalue1').AsFloat = 0 then
    CDS.FieldByName('mvalue3').value := null
  else
    CDS.FieldByName('mvalue3').AsFloat := roundto((CDS.FieldByName('mvalue1').AsFloat - CDS.FieldByName('mvalue2').AsFloat)
      / CDS.FieldByName('mvalue1').AsFloat * 100, -2);
  if CDS.FieldByName('rvalue1').AsFloat = 0 then
    CDS.FieldByName('rvalue3').value := null
  else
    CDS.FieldByName('rvalue3').AsFloat := roundto((CDS.FieldByName('rvalue1').AsFloat - CDS.FieldByName('rvalue2').AsFloat)
      / CDS.FieldByName('rvalue1').AsFloat * 100, -2);
end;

procedure TFrmIPQCT502.FormCreate(Sender: TObject);
begin
  p_SysId := 'IPQC';
  p_TableName := 'IPQC502';
  p_GridDesignAns := True ;
  p_SBText := CheckLang('查詢條件未輸入時,默認顯示[測試日期]一個月內資料');
  btn_import.Visible := g_MInfo^.R_edit and (g_uinfo^.BU='ITEQGZ');
  inherited;
end;

procedure TFrmIPQCT502.CDSBeforePost(DataSet: TDataSet);
var
  len: Integer;
  tmpSQL: string;
  Data: OleVariant;

  procedure ShowM(fName, fMsg: string);
  begin
    ShowMsg('請輸入[%s]' + fMsg, 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField := CDS.FieldByName(fName);
    Abort;
  end;

begin
  if CDS.FieldByName('fdate').IsNull then
    ShowM('fdate', '');

  len := Length(CDS.FieldByName('ad').AsString);
  if (Length(Trim(CDS.FieldByName('ad').AsString)) = 0) or (len <> 1) then
    ShowM('ad', ',長度1碼');

  len := Length(CDS.FieldByName('sizes').AsString);
  if (Length(Trim(CDS.FieldByName('sizes').AsString)) = 0) or ((len <> 3) and (len <> 4)) then
    ShowM('sizes', ',長度3碼或4碼');

  len := Length(CDS.FieldByName('rc').AsString);
  if (len <> 2) and (len <> 4) then
    ShowM('rc', ',格式:xx或xx.x');
  if StrToFloatDef(CDS.FieldByName('rc').AsString, 0) <= 0 then
    ShowM('rc', ',格式:xx或xx.xx');

  if Length(Trim(CDS.FieldByName('lot').AsString)) = 0 then
    ShowM('lot', '');
  if CDS.FieldByName('vc').IsNull then
    ShowM('vc', '');

//  if DataSet.State in [dsInsert] then
//  begin
//    tmpSQL := 'Select IsNull(Max(Id),0)+1 as Id From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU);
//    if not QueryOneCR(tmpSQL, Data) then
//      Abort;
//    CDS.FieldByName('Id').AsInteger := StrToIntDef(VarToStr(Data), 1);
//  end;

//  inherited;
end;

procedure TFrmIPQCT502.CDSAfterPost(DataSet: TDataSet);
begin
  if PostBySQLFromDelta(CDS, p_TableName, 'bu,id') then
    inherited;
end;

procedure TFrmIPQCT502.CDSAfterEdit(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('mname').AsString := g_UInfo^.UserName;
end;

procedure TFrmIPQCT502.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('iname').AsString := g_UInfo^.UserName;
  DataSet.FieldByName('std').AsFloat := 1.5;
end;

procedure TFrmIPQCT502.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('lvalue1').OnChange := valueChange;
  DataSet.FieldByName('mvalue1').OnChange := valueChange;
  DataSet.FieldByName('rvalue1').OnChange := valueChange;
  DataSet.FieldByName('lvalue2').OnChange := valueChange;
  DataSet.FieldByName('mvalue2').OnChange := valueChange;
  DataSet.FieldByName('rvalue2').OnChange := valueChange;
//  DataSet.FieldByName('lvalue3').OnChange := valueChange;
//  DataSet.FieldByName('mvalue3').OnChange := valueChange;
//  DataSet.FieldByName('rvalue3').OnChange := valueChange;
  DataSet.FieldByName('std').OnChange := valueChange;
end;

procedure TFrmIPQCT502.btn_copyClick(Sender: TObject);
begin
  inherited;
  valueChange(nil);
end;

procedure TFrmIPQCT502.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    if Length(tmpStr) = 0 then
      tmpStr := ' and fdate>getdate()-32';
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmIPQCT502.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'ret') then
    if CDS.FieldByName('ret').AsString = 'N' then
      Background := clRed;
end;

procedure TFrmIPQCT502.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if g_MInfo^.R_conf then
  begin
    if IDYES = Application.MessageBox('確定要審核嗎?', '提示', MB_YESNO + MB_ICONQUESTION) then
    begin
      CDS.edit;
      CDS.post;
    end;
  end;
end;

procedure TFrmIPQCT502.CDSBeforeEdit(DataSet: TDataSet);
begin
  if (not g_MInfo^.R_edit) and (not g_MInfo^.R_conf) then
    Abort;
end;

procedure TFrmIPQCT502.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

end.

