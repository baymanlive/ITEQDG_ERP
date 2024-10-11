unit unDLIR300;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
   DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrlsEh, DBCtrls;

type
  TFrmDLIR300 = class(TFrmSTDI041)
    oga01: TLabel;
    oga02: TLabel;
    oga032: TLabel;
    oga011: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    DBEdit5: TDBEdit;
    cdssno: TClientDataSet;
    cdssnosno: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_printClick(Sender: TObject);
  private
//    Fm_image: PTIMAGESTRUCT;
  public
    { Public declarations }
  end;

var
  FrmDLIR300: TFrmDLIR300;

implementation

uses
  unGlobal, unCommon, unDLIR300_Query;

{$R *.dfm}

procedure TFrmDLIR300.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLIR300';
  inherited;
  cdssno.CreateDataSet;
end;

procedure TFrmDLIR300.btn_queryClick(Sender: TObject);
var
  s: string;
  data: OleVariant;
  l_indate1, l_indate2: TDateTime;
  l_custno, l_pno, l_dno: string;
begin

  FrmDLIR300_Query := TFrmDLIR300_Query.Create(self);
  try
    if FrmDLIR300_Query.ShowModal = mrOK then
    begin
      l_indate1 := FrmDLIR300_Query.Dtp1.Date;
      l_indate2 := FrmDLIR300_Query.Dtp2.Date;
      l_custno := Trim(FrmDLIR300_Query.Edit1.Text);
      l_pno := Trim(FrmDLIR300_Query.Edit2.Text);
      l_dno := Trim(FrmDLIR300_Query.Edit4.Text);
      s := 'exec porc_dlir300_m %s,%s,%s,%s,%s,%s';   {(*}
      s := Format(s, [QuotedStr(g_uinfo^.BU),
                      QuotedStr(FormatDateTime('YYYY-MM-DD', l_indate1)),
                      QuotedStr(FormatDateTime('YYYY-MM-DD', l_indate2)),
                      QuotedStr(l_custno),
                      QuotedStr(l_pno),
                      QuotedStr(l_dno)]);              {*)}

      QueryBySQL(s, data);
      CDS.data := data;
    end;
  finally
    FrmDLIR300_Query.free;
  end;
end;

procedure TFrmDLIR300.CDSAfterScroll(DataSet: TDataSet);
var
  data: OleVariant;
  s: string;
begin
  inherited;
  if sametext(CDS.FieldByName('oga04').AsString,'AC588') then
    s := 'exec porc_dlir300_d2 %s,%s'
  else
    s := 'exec porc_dlir300_d %s,%s';
  s := format(s, [QuotedStr(g_uinfo^.BU), QuotedStr(CDS.fieldbyname('oga01').AsString)]);
  if QueryBySQL(s, data) then
    CDS2.data := data;
end;

procedure TFrmDLIR300.btn_printClick(Sender: TObject);
var
  ArrPrintData: TArrPrintData;
  data: OleVariant;
  s, sno: string;
begin
  s := 'exec proc_GetLBLSno %s,%s';
  s := Format(s, [QuotedStr(g_uinfo^.BU), QuotedStr(CDS.fieldbyname('oga04').AsString)]);

  if QueryOneCR(s, data) then
    sno := VarToStr(data);


  cdssno.EDIT;
  cdssnosno.asstring := sno;

  SetLength(ArrPrintData, 3);
  ArrPrintData[0].data := CDS.Data;
  ArrPrintData[0].RecNo := CDS.RecNo;
  ArrPrintData[0].IndexFieldNames := CDS.IndexFieldNames;
  ArrPrintData[0].Filter := CDS.Filter;
  ArrPrintData[1].data := CDS2.Data;
  ArrPrintData[1].RecNo := CDS2.RecNo;
  ArrPrintData[1].IndexFieldNames := CDS2.IndexFieldNames;
  ArrPrintData[1].Filter := CDS2.Filter;
  ArrPrintData[2].data := cdssno.Data;
  ArrPrintData[2].RecNo := cdssno.RecNo;
  ArrPrintData[2].IndexFieldNames := cdssno.IndexFieldNames;
  ArrPrintData[2].Filter := cdssno.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData := nil;
end;

end.

