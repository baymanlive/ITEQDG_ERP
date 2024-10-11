{*******************************************************}
{                                                       }
{                unDLIR050                              }
{                Author: kaikai                         }
{                Create date: 2015/10/13                }
{                Description: COC明細表                 }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR050;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, unDLII030_rpt, unDLII040_rpt,
  unDLIR050_units;

type
  TFrmDLIR050 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_printClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_index:Integer;
    l_indate1,l_indate2,l_custno,l_lot:string;
    l_DLII030_rpt:TDLII030_rpt;
    l_DLII040_rpt:TDLII040_rpt;
    l_tmpCDS1,l_tmpCDS2,l_tmpCDS3:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;


var
  FrmDLIR050: TFrmDLIR050;

implementation

uses unGlobal, unCommon, unDLIR050_Query, unDLIR050_prn, unDLII040_cocerr;

{$R *.dfm}


procedure TFrmDLIR050.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //參數:公司別、出貨日期起、出貨日期迄、客戶編號、批號、0:PP 1:CCL
  tmpSQL:='exec proc_DLIR050 '+Quotedstr(g_UInfo^.BU)+','
                              +Quotedstr(l_indate1)+','
                              +Quotedstr(l_indate2)+','
                              +Quotedstr(l_custno)+','
                              +Quotedstr(l_lot)+','
                              +IntToStr(l_index);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
     
  inherited;
end;

procedure TFrmDLIR050.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR050';
  p_GridDesignAns:=True;
  l_index:=0;
  l_indate1:='1955/5/5';
  l_indate2:=l_indate1;
  l_custno:='@@';
  l_lot:='@@';

  inherited;

  l_tmpCDS1:=TClientDataSet.Create(Self);
  l_tmpCDS2:=TClientDataSet.Create(Self);
  l_tmpCDS3:=TClientDataSet.Create(Self);
end;

procedure TFrmDLIR050.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_DLII030_rpt) then
     FreeAndNil(l_DLII030_rpt);
  if Assigned(l_DLII040_rpt) then
     FreeAndNil(l_DLII040_rpt);
  FreeAndNil(l_tmpCDS1);
  FreeAndNil(l_tmpCDS2);
  FreeAndNil(l_tmpCDS3);
end;

procedure TFrmDLIR050.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  if not Assigned(FrmDLIR050_prn) then
     FrmDLIR050_prn:=TFrmDLIR050_prn.Create(Application);
  if FrmDLIR050_prn.ShowModal=mrCancel then
     Exit;

  if FrmDLIR050_prn.RadioGroup1.ItemIndex=1 then
  begin
    SetLength(ArrPrintData, 1);
    ArrPrintData[0].Data:=CDS.Data;
    ArrPrintData[0].RecNo:=CDS.RecNo;
    ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
    ArrPrintData[0].Filter:=CDS.Filter;
    GetPrintObj('DLI', ArrPrintData);
    ArrPrintData:=nil;
  end else
  begin
    if Pos(Copy(CDS.FieldByName('Pno').AsString,1,1),'ET')=0 then
    begin
      if not Assigned(l_DLII030_rpt) then
         l_DLII030_rpt:=TDLII030_rpt.Create(CDS);
      l_DLII030_rpt.StartPrint('DLII030');
    end else
    begin
      if not Assigned(l_DLII040_rpt) then
         l_DLII040_rpt:=TDLII040_rpt.Create(CDS);
      l_DLII040_rpt.StartPrint('DLII040');
    end;
  end;
end;

procedure TFrmDLIR050.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR050_Query) then
     FrmDLIR050_Query:=TFrmDLIR050_Query.Create(Application);
  if FrmDLIR050_Query.ShowModal=mrOK then
  begin
    l_index:=FrmDLIR050_Query.RadioGroup1.ItemIndex;
    l_indate1:=DateToStr(FrmDLIR050_Query.Dtp1.Date);
    l_indate2:=DateToStr(FrmDLIR050_Query.Dtp2.Date);
    l_custno:=Trim(FrmDLIR050_Query.Edit1.Text+'/'+FrmDLIR050_Query.Edit3.Text);
    l_lot:=Trim(FrmDLIR050_Query.Edit2.Text);
    RefreshDS('');
  end;
end;

procedure TFrmDLIR050.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmDLII040_cocerr) then
     FrmDLII040_cocerr:=TFrmDLII040_cocerr.Create(Application);
  FrmDLII040_cocerr.l_Coc_errid:=CDS.FieldByName('coc_errid').AsString;
  FrmDLII040_cocerr.ShowModal;
end;

procedure TFrmDLIR050.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('coc_err').AsBoolean then
     AFont.Color:=clFuchsia;
end;

end.
