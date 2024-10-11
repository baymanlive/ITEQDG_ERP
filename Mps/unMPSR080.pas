{*******************************************************}
{                                                       }
{                unMPSR080                              }
{                Author: kaikai                         }
{                Create date: 2015/12/15                }
{                Description: 違反鋼板原則分析表        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR080;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, unGlobal;

const l_Color1=16772300;  //RGB(204,236,255);   //淺藍
const l_Color2=13434879;  //RGB(255,255,204);   //淺黃

type
  TFrmMPSR080 = class(TFrmSTDI041)
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
    l_CDS1,l_CDS12:TClientDataSet;
    function GetCCLData(xType: string): OleVariant;
    function CheckStealno(SMRec:TSplitMaterialno):Boolean;
    function GetOtherSize(S9_S11:string):string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR080: TFrmMPSR080;

implementation

uses unCommon, unMPSR080_Query;

{$R *.dfm}

function TFrmMPSR080.GetCCLData(xType:string):OleVariant;
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

//取出此規格對應可用鋼板比較
//  'machine='+Quotedstr(machine)
// +' and fmdate<='+Quotedstr(DateToStr(P^.sdate))
// +' and todate>='+Quotedstr(DateToStr(P^.sdate))
function TFrmMPSR080.CheckStealno(SMRec:TSplitMaterialno):Boolean;
begin
  Result:=False;

  if SMRec.MLast='' then
     Exit;

  with l_CDS1 do
  begin
    Filtered:=False;
    Filter:='strip_lower<='+FloatToStr(SMRec.M3_6)
           +' and strip_upper>='+FloatToStr(SMRec.M3_6)
           +' and longitude_lower<='+Quotedstr(SMRec.M9_11)
           +' and longitude_upper>='+Quotedstr(SMRec.M9_11)
           +' and latitude_lower<='+Quotedstr(SMRec.M12_14)
           +' and latitude_upper>='+Quotedstr(SMRec.M12_14)
           +' and (stealno is not null) and (stealno<>'''')';
    Filtered:=True;
    IndexFieldNames:='id';
    while not Eof do
    begin
      Result:=SameText(FieldByName('stealno').AsString, SMRec.MLast);
      if Result then
         Break;
      Next;
    end;
  end;
end;

//特殊尺寸
function TFrmMPSR080.GetOtherSize(S9_S11:string):string;
begin
  Result:=S9_S11;
  with l_CDS12 do
  begin
    First;
    while not Eof do
    begin
      if Pos('/'+S9_S11+'/', FieldByName('OthSize').AsString)>0 then
      begin
        Result:=FieldByName('StdSize').AsString;
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TFrmMPSR080.RefreshDS(strFilter: string);
begin
  inherited;
end;

procedure TFrmMPSR080.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR080';
  p_GridDesignAns:=True;

  inherited;

  Label3.Caption:=CheckLang('生產日期/鍋次');
  l_ColorList:=TStringList.Create;
  l_CDS1:=TClientDataSet.Create(nil);
  l_CDS12:=TClientDataSet.Create(nil);
  CDS.IndexFieldNames:='Machine;Jitem;OZ;Simuver;Citem';
end;

procedure TFrmMPSR080.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
  FreeAndNil(l_CDS1);
  FreeAndNil(l_CDS12);
end;

procedure TFrmMPSR080.DBGridEh1GetCellParams(Sender: TObject;
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

procedure TFrmMPSR080.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  if CDS.FieldByName('Sdate').IsNull then
     Edit3.Text:=''
  else
     Edit3.Text:=FormatDateTime(g_cShortDate, CDS.FieldByName('Sdate').AsDateTime);
  Edit4.Text:=IntToStr(CDS.FieldByName('CurrentBoiler').AsInteger);
end;

procedure TFrmMPSR080.DBGridEh1DrawColumnCell(Sender: TObject;
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

procedure TFrmMPSR080.btn_queryClick(Sender: TObject);
var
  tmpJitem:Integer;
  tmpSQL,tmpValue:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  SMRec:TSplitMaterialno;
begin
//  inherited;
  if not AsSigned(FrmMPSR080_Query) then
     FrmMPSR080_Query:=TFrmMPSR080_Query.Create(Application);
  tmpJitem:=FrmMPSR080_Query.ShowModal;
  if tmpJitem=MrCancel then
     Exit;

  tmpSQL:='Select * From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And IsNull(ErrorFlag,0)=0'
         +' And Machine='+Quotedstr(FrmMPSR080_Query.Cbb.Text)
         +' And Sdate Between '+Quotedstr(DateToStr(FrmMPSR080_Query.Dtp1.Date))
         +' And '+Quotedstr(DateToStr(FrmMPSR080_Query.Dtp2.Date))
         +' Order By Machine,Jitem,OZ,Simuver,Citem';
  if QueryBySQL(tmpSQl, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not l_CDS1.Active then
         l_CDS1.Data:=GetCCLData('1');
      if not l_CDS12.Active then
         l_CDS12.Data:=GetCCLData('12');

      l_ColorList.Clear;
      tmpJitem:=-1;
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
          SMRec.MLast:=Copy(FieldByName('stealno').AsString,1,2);
          SMRec.M3_6:=StrToFloat(Copy(FieldByName('materialno').AsString,3,4))/10000;
          SMRec.M9_11:=UpperCase(Copy(FieldByName('materialno').AsString,9,3));
          SMRec.M12_14:=UpperCase(Copy(FieldByName('materialno').AsString,12,3));
          if (SMRec.M12_14>='488') and (SMRec.M12_14<='493') then //緯向490,經向是特殊尺寸則轉換
              SMRec.M9_11:=GetOtherSize(SMRec.M9_11);
          if not CheckStealno(SMRec) then
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
