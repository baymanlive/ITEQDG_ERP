unit unDLII020_AC101_remark;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, GridsEh,
  DBAxisGridsEh, DBGridEh, DB, DBClient;

type
  TFrmDLII020_AC101_remark = class(TFrmSTDI051)
    DataSource1: TDataSource;
    CDS: TClientDataSet;
    DBGridEh1: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
  private
    l_init:Boolean;
    { Private declarations }
  public
    procedure SetData(xCDS:TClientDataSet);
    procedure GetData(xCDS:TClientDataSet);
    { Public declarations }
  end;

var
  FrmDLII020_AC101_remark: TFrmDLII020_AC101_remark;

implementation

uses unGlobal, unCommon;

const l_xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="recno" fieldtype="i4"/>'
           +'<FIELD attrname="remark" fieldtype="string" WIDTH="400"/>'
           +'<FIELD attrname="cnt" fieldtype="i4"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLII020_AC101_remark.GetData(xCDS:TClientDataSet);
begin
  if CDS.State in [dsInsert,dsEdit] then
     CDS.Post;
  if CDS.ChangeCount>0 then
     CDS.MergeChangeLog;
  CDS.First;
  while not CDS.Eof do
  begin
    xCDS.RecNo:=CDS.FieldByName('recno').AsInteger;
    xCDS.Edit;
    if CDS.FieldByName('cnt').AsInteger<=0 then
       xCDS.FieldByName('remark').AsString:=CDS.FieldByName('remark').AsString
    else
       xCDS.FieldByName('remark').AsString:=CDS.FieldByName('remark').AsString+#13#10+CheckLang('¥t°h³ø¼oªO')+IntToStr(CDS.FieldByName('cnt').AsInteger)+'PNL';
    xCDS.FieldByName('remark').AsString:=Trim(xCDS.FieldByName('remark').AsString);
    xCDS.Post;
    CDS.Next;
  end;

  xCDS.MergeChangeLog;
end;

procedure TFrmDLII020_AC101_remark.SetData(xCDS:TClientDataSet);
begin
  l_init:=True;
  xCDS.First;
  while not xCDS.Eof do
  begin
    CDS.Append;
    CDS.FieldByName('recno').AsInteger:=xCDS.RecNo;
    CDS.FieldByName('remark').AsString:=xCDS.FieldByName('remark').AsString;
    CDS.Post;
    xCDS.Next;
  end;
  CDS.MergeChangeLog;
  l_init:=False;
end;

procedure TFrmDLII020_AC101_remark.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmDLII020_AC101_remark');
  InitCDS(CDS, l_xml);
  btn_quit.Visible:=False;
end;

procedure TFrmDLII020_AC101_remark.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLII020_AC101_remark.CDSBeforeInsert(DataSet: TDataSet);
begin
  if not l_init then
     Abort;
  inherited;
end;

procedure TFrmDLII020_AC101_remark.CDSBeforeDelete(DataSet: TDataSet);
begin
  Abort;
  inherited;
end;

end.
