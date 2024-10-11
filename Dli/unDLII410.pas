{*******************************************************}
{                                                       }
{                unDLII410                              }
{                Author: kaikai                         }
{                Create date: 2017/1/20                 }
{                Description: 出車計划表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII410;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII410 = class(TFrmSTDI031)
    btn_dlii410A: TBitBtn;
    btn_dlii410B: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_dlii410AClick(Sender: TObject);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
    procedure btn_dlii410BClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII410: TFrmDLII410;

implementation

uses unGlobal, unCommon, unDLII410_indate, unDLII410_custno, unDLII410_ordlist;
   
{$R *.dfm}

procedure TFrmDLII410.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI410 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By Indate,Stime';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII410.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI410';
  p_GridDesignAns:=True;

  inherited;

  SetStrings(DBGridEh1.FieldColumns['Pathname'].PickList,'Pathname','DLI400');
end;

procedure TFrmDLII410.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
  
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if CDS.FieldByName('Indate').IsNull then
     ShowM('Indate');
  if Length(Trim(CDS.FieldByName('Stime').AsString))=0 then
     ShowM('Stime');
  if Length(Trim(CDS.FieldByName('Pathname').AsString))=0 then
     ShowM('Pathname');
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(CDS.FieldByName('Indate').AsDateTime));
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;
  inherited;
end;

procedure TFrmDLII410.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
//  inherited;
  if GetQueryString(p_TableName, tmpStr) then
  if Length(tmpStr)=0 then
     RefreshDS(' And Indate='+Quotedstr(DateToStr(Date)))
  else
     RefreshDS(tmpStr);
end;

procedure TFrmDLII410.btn_dlii410AClick(Sender: TObject);
begin
  inherited;
  FrmDLII410_indate:=TFrmDLII410_indate.Create(nil);
  try
    if FrmDLII410_indate.ShowModal=MrOK then
       CDS.Data:=FrmDLII410_indate.RetData;
  finally
    FreeAndNil(FrmDLII410_indate);
  end;
end;

procedure TFrmDLII410.btn_dlii410BClick(Sender: TObject);
begin
  inherited;
  FrmDLII410_ordlist:=TFrmDLII410_ordlist.Create(nil);
  try
    FrmDLII410_ordlist.ShowModal;
  finally
    FreeAndNil(FrmDLII410_ordlist);
  end;
end;

procedure TFrmDLII410.DBGridEh1EditButtonClick(Sender: TObject);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Exit;

  FrmDLII410_custno:=TFrmDLII410_custno.Create(nil);
  FrmDLII410_custno.Memo1.Lines.DelimitedText:=CDS.FieldByName('Custno').AsString;
  FrmDLII410_custno.Memo2.Lines.DelimitedText:=CDS.FieldByName('Custshort').AsString;
  try
    if FrmDLII410_custno.ShowModal=MrOK then
    begin
      if not (CDS.State in [dsInsert,dsEdit]) then
         CDS.Edit;
      CDS.FieldByName('Custno').AsString:=FrmDLII410_custno.Memo1.Lines.DelimitedText;
      CDS.FieldByName('Custshort').AsString:=FrmDLII410_custno.Memo2.Lines.DelimitedText;
    end;
  finally
    FreeAndNil(FrmDLII410_custno);
  end;
end;

end.
