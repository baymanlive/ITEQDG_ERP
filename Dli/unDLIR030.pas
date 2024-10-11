{*******************************************************}
{                                                       }
{                unDLIR030                              }
{                Author: kaikai                         }
{                Create date: 2015/10/7                 }
{                Description: 先進先出表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin;

type
  TFrmDLIR030 = class(TFrmSTDI040)
    PCL2: TPageControl;
    TabSheet_lot: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh2GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
  private
    l_sql2:string;
    l_list2:TStrings;
    { Private declarations }
  public
    { Public declarations }
  protected  
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR030: TFrmDLIR030;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR030.RefreshDS(strFilter: string);
var
  tmpStr:string;
  Data:OleVariant;
begin
  tmpStr:=strFilter;

  //應出數量與對貨數量相減
  if Pos('Qry_qty', tmpStr)>0 then
     tmpStr:=StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
  if Pos('Qry_ppccl', tmpStr)>0 then
     tmpStr:=StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
  if Pos('Qry_isbz', tmpStr)>0 then
     tmpStr:=StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(A.bu,orderno,orderitem)', [rfIgnoreCase]);

  tmpStr:='Select C.* From DLI010 C Inner Join'
         +' (Select Distinct A.Bu,A.Dno,A.Ditem From DLI260 A Inner Join DLI010 B'
         +' ON A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
         +' Where B.Bu='+Quotedstr(g_UInfo^.BU)+tmpStr
         +' And B.Indate>getdate()-16) D'
         +' ON C.Bu=D.Bu And C.Dno=D.Dno And C.Ditem=D.Ditem';
  if QueryBySQL(tmpStr, Data) then
  begin
    CDS.Data:=Data;
    if CDS.IsEmpty and CDS2.Active then
       CDS2.EmptyDataSet;
  end;

  inherited;
end;

procedure TFrmDLIR030.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI010';
  p_GridDesignAns:=True;

  inherited;

  SetGrdCaption(DBGridEh2, 'DLI260');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmDLIR030.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  CDS2.Active:=False;
  DBGridEh2.Free;
end;

procedure TFrmDLIR030.CDSAfterScroll(DataSet: TDataSet);
var
  tmpSQL:string;
begin
  tmpSQL:='Select * From DLI260 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(DataSet.FieldByName('Dno').AsString)
         +' And Ditem='+Quotedstr(DataSet.FieldByName('Ditem').AsString)
         +' Order By Sno';
  l_list2.Insert(0,tmpSQL);

  inherited;
end;

procedure TFrmDLIR030.DBGridEh2GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS2.FieldByName('stkqty').AsFloat<>CDS2.FieldByName('qty').AsFloat then
     Background:=RGB(255,255,204);
end;

procedure TFrmDLIR030.Timer1Timer(Sender: TObject);
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
