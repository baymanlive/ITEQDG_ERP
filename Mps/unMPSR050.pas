{*******************************************************}
{                                                       }
{                unMPSR050                              }
{                Author: kaikai                         }
{                Create date: 2015/7/6                  }
{                Description: 違反合鍋原則分析表        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR050;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, unGlobal;

const l_Color1=16772300;  //RGB(204,236,255);   //淺藍
const l_Color2=13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPSR050 = class(TFrmSTDI041)
    Label3: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
  private
    l_ColorList:TStrings;
    l_CDS:TClientDataSet;
    function GetCCLData(xType: string): OleVariant;
    function GetAdCode(SMRec:TSplitMaterialno):Integer;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR050: TFrmMPSR050;

implementation

uses unCommon, unMPSR050_Query;

{$R *.dfm}

function TFrmMPSR050.GetCCLData(xType:string):OleVariant;
var
  tmpSQL:string;
  Data1:OleVariant;
begin
  TmpSQL:='exec proc_GetCCL '+xType+','+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data1) then
     Result:=Data1
  else
     Result:=null;
end;

//取膠系合鍋代碼
function TFrmMPSR050.GetAdCode(SMRec:TSplitMaterialno):Integer;
begin
  Result:=0;
  with l_CDS do
  begin
    Filtered:=False;
    Filter:='machine='+Quotedstr(SMRec.MLast_1)
           +' and strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and custno<>''*''';
    Filtered:=True;
    IndexFieldNames:='Code';
    First;
    while not Eof do
    begin
      if Pos('/'+UpperCase(SMRec.MLast)+'/',FieldByName('custno').AsString)>0 then
      begin
        Result:=FieldByName('Code').AsInteger;
        Break;
      end;
      Next;
    end;

    if Result=0 then
    begin
      Filtered:=False;
      Filter:='machine='+Quotedstr(SMRec.MLast_1)
             +' and strip_lower<='+FloatToStr(SMRec.M3_6)
             +' and strip_upper>='+FloatToStr(SMRec.M3_6)
             +' and custno=''*''';
      Filtered:=True;
      IndexFieldNames:='Code';
      First;
      while not Eof do
      begin
        if Pos('/'+SMRec.M2+'/',FieldByName('Adhesive').AsString)>0 then
        begin
          Result:=FieldByName('Code').AsInteger;
          Break;
        end;
        Next;
      end;
    end;
  end;
end;

procedure TFrmMPSR050.RefreshDS(strFilter: string);
begin
  inherited;
end;

procedure TFrmMPSR050.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR050';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('以每鍋第一筆作為參考,只分析合鍋規范');

  inherited;

  Label3.Caption:=CheckLang('生產日期/鍋次');
  l_ColorList:=TStringList.Create;
  l_CDS:=TClientDataSet.Create(nil);
  CDS.IndexFieldNames:='Machine;Jitem;OZ;Simuver;Citem';
end;

procedure TFrmMPSR050.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR050.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (CDS.Active) and (not CDS.IsEmpty) and (l_ColorList.Count>=CDS.RecNo) then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=l_Color2
    else
       Background:=l_Color1;
  end;
end;

procedure TFrmMPSR050.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if CDS.FieldByName('Sdate').IsNull then
     Edit3.Text:=''
  else
     Edit3.Text:=FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  Edit4.Text:=IntToStr(CDS.FieldByName('CurrentBoiler').AsInteger);
end;

procedure TFrmMPSR050.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    if CDS.FieldByName('Iuser').AsString='*' then
    begin
      DBGridEh1.Canvas.Font.Color:=clRed;
      DBGridEh1.Canvas.TextOut(Round((Rect.Left+Rect.Right)/2)-6,
        Round((Rect.Top+Rect.Bottom)/2-6), '*');
    end;
  end;
end;

procedure TFrmMPSR050.btn_queryClick(Sender: TObject);
var
  tmpJitem,tmpAdcode,tmpOldAdcode:Integer;
  tmpSQL,tmpValue:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  SMRec:TSplitMaterialno;
begin
//  inherited;
  if not AsSigned(FrmMPSR050_Query) then
     FrmMPSR050_Query:=TFrmMPSR050_Query.Create(Application);
  tmpJitem:=FrmMPSR050_Query.ShowModal;
  if tmpJitem=MrCancel then
     Exit;

  tmpSQL:='Select * From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And IsNull(ErrorFlag,0)=0'
         +' And Machine='+Quotedstr(FrmMPSR050_Query.Cbb.Text)
         +' And Sdate Between '+Quotedstr(DateToStr(FrmMPSR050_Query.Dtp1.Date))
         +' And '+Quotedstr(DateToStr(FrmMPSR050_Query.Dtp2.Date))
         +' Order By Machine,Jitem,OZ,Simuver,Citem';
  if QueryBySQL(tmpSQl, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not l_CDS.Active then
         l_CDS.Data:=GetCCLData('4');

      l_ColorList.Clear;
      tmpJitem:=-1;
      tmpOldAdcode:=-1;
      tmpValue:='1';
      with tmpCDS do
      while not Eof do
      begin
        if tmpJitem<>FieldByName('Jitem').AsInteger then
        begin
          if tmpValue='1' then
             tmpValue:='2'
          else
             tmpValue:='1';
        end;
        l_ColorList.Add(tmpValue);

        if FieldByName('EmptyFlag').AsInteger=0 then
        begin
          SMRec.MLast:=FieldByName('custno').AsString;
          SMRec.MLast_1:=FieldByName('machine').AsString;
          SMRec.M2:=UpperCase(Copy(FieldByName('materialno').AsString,2,1));
          SMRec.M3_6:=StrToFloat(Copy(FieldByName('materialno').AsString,3,4))/10000;
          tmpAdcode:=GetAdCode(SMRec);
          if tmpJitem<>FieldByName('Jitem').AsInteger then
             tmpOldAdcode:=tmpAdcode;
          if tmpOldAdcode<>tmpAdcode then
          begin
            Edit;
            FieldByName('Iuser').AsString:='*';
            Post;
          end;
        end;
        tmpJitem:=FieldByName('Jitem').AsInteger;
        Next;
      end;
      tmpCDS.MergeChangeLog;
      CDS.Data:=tmpCDS.Data;
    finally
      tmpCDS.Free;
    end;
  end;
end;

end.
