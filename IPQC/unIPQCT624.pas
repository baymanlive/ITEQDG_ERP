unit unIPQCT624;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Buttons;

type
  TFrmIPQCT624 = class(TFrmSTDI041)
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    Panel2: TPanel;
    Panel3: TPanel;
    Edit3: TEdit;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    Splitter1: TSplitter;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_printClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_sql2:string;
    l_list2:TStrings;
    procedure RefreshDS2;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmIPQCT624: TFrmIPQCT624;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

//sg2:5組中取樣時間最新一組平均值
procedure TFrmIPQCT624.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select ad,ver From IPQC610 Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter+' And Conf=1';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  if CDS.Active and CDS.IsEmpty then
     RefreshDS2;

  inherited;
end;

procedure TFrmIPQCT624.RefreshDS2;
var
  tmpSQL:string;
begin
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='Select sno,item,kg,kg as kg_old,diff,istext From IPQC611'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Ad='+Quotedstr(CDS.FieldByName('Ad').AsString)
         +' And Ver='+Quotedstr(CDS.FieldByName('Ver').AsString)
         +' And IsText=0 Order By Sno';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmIPQCT624.FormCreate(Sender: TObject);
begin
  p_SysId:='ipqc';
  p_TableName:='ipqc610';
  p_GridDesignAns:=True;

  inherited;

  Label1.Caption:=CheckLang('調膠量(噸):');
  BitBtn1.Caption:=CheckLang('計算');
  btn_export.Visible:=False;
  SetGrdCaption(DBGridEh2, 'ipqc611');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmIPQCT624.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_list2);
end;

procedure TFrmIPQCT624.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  SetLength(ArrPrintData, 2);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=CDS.Filter;
  ArrPrintData[1].Data:=CDS2.Data;
  ArrPrintData[1].RecNo:=CDS2.RecNo;
  ArrPrintData[1].IndexFieldNames:=CDS2.IndexFieldNames;
  ArrPrintData[1].Filter:=CDS2.Filter;
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmIPQCT624.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  RefreshDS2;
end;

procedure TFrmIPQCT624.BitBtn1Click(Sender: TObject);
var
  tmpCDS:TClientDataSet;
  num:Double;
begin
  inherited;
  if not CDS2.Active or CDS2.IsEmpty then
  begin
    ShowMsg('請查詢資料!',48);
    Exit;
  end;

  num:=0;
  
  try
    num:=StrToFloatDef(Edit3.Text,0);
  except
  end;

  if num<=0 then
  begin
    ShowMsg('投入量必需大於0!',48);
    Edit3.SetFocus;
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS2.Data;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        if not FieldByName('istext').AsBoolean then
        begin
          Edit;
          FieldByName('kg').AsFloat:=FieldByName('kg_old').AsFloat*num;
          Post;
        end;
        Next;
      end;
      MergeChangeLog;
    end;
    CDS2.Data:=tmpCDS.Data;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT624.Timer1Timer(Sender: TObject);
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
