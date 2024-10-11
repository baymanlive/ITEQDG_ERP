unit unMPSR270;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls,
  StdCtrls, ExtCtrls, ToolWin;

type
  TFrmMPSR270 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
  private    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSR270: TFrmMPSR270;


implementation

uses
  unGlobal, unCommon;
{$R *.dfm}


procedure TFrmMPSR270.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpSQL:=' and machine in (''L1'',''L2'',''L3'',''L4'',''L5'')'
  else
     tmpSQL:=' and machine=''L6''';
  tmpSQL:='select bu,simuver,citem,jitem,oz,case_ans1 as ''select'',machine,sdate,wono,'
         +' materialno,sqty,stealno,currentboiler,premark,orderno,orderitem,custno,custom'
         +' from mps010 where 1=1 '+strFilter+tmpSQL
         +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0'
         +' and left(materialno,1) in (''E'',''T'')';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=False;
        Post;
        Next;
      end;
      tmpCDS.MergeChangeLog;
      CDS.Data:=tmpCDS.Data;
      CDS.IndexFieldNames:='machine;jitem;oz;materialno;simuver;citem';
      RG1Click(RG1);
      CDS2.EmptyDataSet;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  inherited;
end;

procedure TFrmMPSR270.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS070';
  p_GridDesignAns := True;
  inherited;

  inherited;

end;

end.

