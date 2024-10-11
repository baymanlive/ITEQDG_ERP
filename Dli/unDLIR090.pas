{*******************************************************}
{                                                       }
{                unDLIR090                              }
{                Author: kaikai                         }
{                Create date: 2016/7/18                 }
{                Description: 出貨單簽收明細表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR090;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ComCtrls, ToolWin, DateUtils, unGridDesign;

type
  TFrmDLIR090 = class(TFrmSTDI041)
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    { Private declarations }
    l_QueryIndex: Integer;
    l_FmDate, l_ToDate: TDateTime;
    l_RgpIndex1, l_RgpIndex2, l_RgpIndex3: Integer;
    l_Cno: string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLIR090: TFrmDLIR090;

implementation

uses
  unGlobal, unCommon, unDLIR090_Query, E6gps, superobject;

{$R *.dfm}

procedure TFrmDLIR090.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  g_StatusBar.Panels[0].Text := CheckLang('正在查詢...');
  Application.ProcessMessages;
  if l_QueryIndex = 1 then //以派車日期查詢
    tmpSQL := 'exec dbo.proc_DLIR090_2 ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(DateToStr(l_FmDate)) + ',' +
      Quotedstr(DateToStr(l_ToDate)) + ',' + Quotedstr(strFilter) + ',' + IntToStr(l_RgpIndex1) + ',' + IntToStr(l_RgpIndex2)
      + ',' + IntToStr(l_RgpIndex3) + ',' + Quotedstr(l_Cno)
  else                  //以送貨單日期查詢
    tmpSQL := 'exec dbo.proc_DLIR090_1 ' + Quotedstr(g_UInfo^.BU) + ',' + Quotedstr(strFilter) + ',' + IntToStr(l_RgpIndex1)
      + ',' + IntToStr(l_RgpIndex2) + ',' + IntToStr(l_RgpIndex3) + ',' + Quotedstr(l_Cno);
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data := Data;
    if CDS.IsEmpty then
      Label3.Caption := ''
    else
      Label3.Caption := CheckLang('出廠 ' + IntToStr(CDS.FieldByName('outcnt').AsInteger) + '    回聯 ' + IntToStr(CDS.FieldByName
        ('backcnt').AsInteger) + '    簽收 ' + IntToStr(CDS.FieldByName('confcnt').AsInteger));
  end;
  g_StatusBar.Panels[0].Text := '';

  inherited;
end;

procedure TFrmDLIR090.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLIR090';
  p_GridDesignAns := True;
  p_SBText := CheckLang('此作業查詢過程較慢,請耐心等待');

  inherited;

  l_QueryIndex := 0;
  l_RgpIndex1 := 2;
  l_RgpIndex2 := 2;
  l_RgpIndex3 := 2;
  Label3.Caption := '';
  l_Cno := '@';
end;

procedure TFrmDLIR090.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR090_Query) then
    FrmDLIR090_Query := TFrmDLIR090_Query.Create(Application);
  if FrmDLIR090_Query.ShowModal = mrOK then
  begin
    if FrmDLIR090_Query.RB1.Checked then
      l_QueryIndex := 1
    else
      l_QueryIndex := 2;
    l_FmDate := FrmDLIR090_Query.Dtp1.Date;
    l_ToDate := FrmDLIR090_Query.Dtp2.Date;
    l_Cno := Trim(FrmDLIR090_Query.Edit3.Text);
    l_RgpIndex1 := FrmDLIR090_Query.Rgp1.ItemIndex;
    l_RgpIndex2 := FrmDLIR090_Query.Rgp2.ItemIndex;
    l_RgpIndex3 := FrmDLIR090_Query.Rgp3.ItemIndex;
    RefreshDS(FrmDLIR090_Query.l_QueryStr);
  end;
end;

procedure TFrmDLIR090.DBGridEh1DblClick(Sender: TObject);
var
  Soap: E6gpsSoap;
  i: integer;
  memo1: Tmemo;
  tmpSaleno, ret: string;
  aryData: TSuperArray;
  jRet, jResult, jData: ISuperObject;
  strData, strResult: string;
  aryUsers: TSuperArray;
  strcode: string;
begin
  if DBGridEh1.SelectedField.FieldName = 'carno' then
  begin
    Soap := E6gps.GetE6gpsSoap;
    tmpSaleno := trim(copy(DBGridEh1.SelectedField.AsString, 3, 20));
    ret := Soap.GetAddress(tmpSaleno);
    ShowMsg(ret);
//    jRet := SO(memo1.Text);
//    strResult := jRet.O['result'].AsString;
//    jResult := SO(strResult);
//    strcode := jResult.O['code'].asstring;
//    if strcode <> '1' then
//    begin
//      showmessage('未找到車牌號');
//      txt_Vehicle.Clear;
//      txt_GPSTime.Clear;
//      txt_Status.Clear;
//      txt_PlaceName.Clear;
//      txt_Provice.Clear;
//      txt_City.Clear;
//      txt_District.Clear;
//      txt_RoadName.Clear;
//      exit;
//    end;
//
//    strData := jResult.O['data'].AsString;
//    jData := SO(strData);
//    aryData := jData.AsArray;
//
//    txt_Vehicle.text := aryData[0].O['Vehicle'].AsString;
//    txt_GPSTime.text := aryData[0].O['GPSTime'].AsString;
//    txt_Status.text := aryData[0].O['Status'].AsString;
//    txt_PlaceName.Text := aryData[0].O['PlaceName'].AsString;
//    txt_Provice.Text := aryData[0].O['Provice'].AsString;
//    txt_City.Text := aryData[0].O['City'].AsString;
//    txt_District.Text := aryData[0].O['District'].AsString;
//    txt_RoadName.Text := aryData[0].O['RoadName'].AsString;

  end;
end;

end.

