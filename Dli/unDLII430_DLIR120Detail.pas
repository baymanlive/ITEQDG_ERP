unit unDLII430_DLIR120Detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls;

type
  TFrmDLII430_DLIR120Detail = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    Panel1: TPanel;
    DS2: TDataSource;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    CDS2: TClientDataSet;
    btn_query: TBitBtn;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    l_sql2:string;
     l_list2:TStrings;
    procedure GetCDS1_data(xFilter: string);
    procedure GetCDS2_data;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII430_DLIR120Detail: TFrmDLII430_DLIR120Detail;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII430_DLIR120Detail.GetCDS1_data(xFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select *,isnull(cclpnlqty,0)+isnull(pppnlqty,0) as pnlqty From DLI018'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)+xFilter
         +' Order By Cdate Desc,Custno,Cname';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS1.Data:=Data;
    if CDS1.IsEmpty then
       GetCDS2_data;
  end;
end;

procedure TFrmDLII430_DLIR120Detail.GetCDS2_data;
var
  tmpSQL:string;
begin
  tmpSQL:='Select * From DLI019 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' Order By kw,kb';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLII430_DLIR120Detail.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'DLI018');
  SetGrdCaption(DBGridEh2, 'DLI019');
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmDLII430_DLIR120Detail.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmDLII430_DLIR120Detail.FormShow(Sender: TObject);
begin
  inherited;
  GetCDS1_data(' And Cdate='+Quotedstr(DateToStr(Date)));
end;

procedure TFrmDLII430_DLIR120Detail.CDS1AfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetCDS2_data;
end;

procedure TFrmDLII430_DLIR120Detail.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  inherited;
  if GetQueryString('DLI018', tmpStr) then
  if Length(tmpStr)=0 then
     GetCDS1_data(' and cdate>=getdate()-180')
  else
     GetCDS1_data(tmpStr);
end;

procedure TFrmDLII430_DLIR120Detail.btn_okClick(Sender: TObject);
begin
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('請選擇資料!',48);
    Exit;
  end;
  
  inherited;
end;

procedure TFrmDLII430_DLIR120Detail.Timer1Timer(Sender: TObject);
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
