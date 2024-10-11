unit unDLII020_AC101;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, DBClient, StrUtils,
  Math;

type
  TFrmDLII020_AC101 = class(TFrmSTDI051)
    Label1: TLabel;
    Edit1: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII020_AC101: TFrmDLII020_AC101;

implementation

uses unGlobal, unCommon;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="oga01" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ogb03" fieldtype="i4"/>'
           +'<FIELD attrname="c_orderno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="c_sizes"  fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="dealer" fieldtype="string" WIDTH="10"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLII020_AC101.btn_okClick(Sender: TObject);
var
  saleno,oraDB,tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  saleno:=Trim(Edit1.Text);
  if Length(saleno)=0 then
  begin
    ShowMsg('請輸入出貨單號',48);
    Exit;
  end;

  if Pos('dg', LowerCase(g_UInfo^.BU))>0 then
     oraDB:='ORACLE'
  else
     oraDB:='ORACLE1';

  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢出貨單資料...');
  Application.ProcessMessages;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select y.*,oeb05,oeb11,ta_oeb10 from ('
           +' select x.*,oea10 from ('
           +' select oga01,ogb03,oga04,ogapost,ogb04,ogb05_fac,ogb12,ogb31,ogb32'
           +' from oga_file,ogb_file where oga01=ogb01'
           +' and oga01='+Quotedstr(saleno)+') x,oea_file'
           +' where ogb31=oea01) y,oeb_file'
           +' where ogb31=oeb01 and ogb32=oeb03'
           +' order by oga01,ogb03';
    if not QueryBySQL(tmpSQL, Data, oraDB) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg(saleno+'不存在,不可列印!',48);
      Exit;
    end;

    if not SameText(tmpCDS.FieldByName('oga04').AsString,'AC101') then
    begin
      ShowMsg(saleno+'不是競華客戶,不可列印!',48);
      Exit;
    end;

    if tmpCDS.FieldByName('ogapost').AsString<>'Y' then
    begin
      ShowMsg(saleno+'未扣帳,不可列印!',48);
      Exit;
    end;

    l_CDS.EmptyDataSet;
    while not tmpCDS.Eof do
    begin
      g_StatusBar.Panels[0].Text:=CheckLang('正在處理'+IntToStr(tmpCDS.RecNo)+'/'+IntToStr(tmpCDS.RecordCount));
      Application.ProcessMessages;

      l_CDS.Append;
      l_CDS.FieldByName('oga01').AsString:=tmpCDS.FieldByName('oga01').AsString;
      l_CDS.FieldByName('ogb03').AsInteger:=tmpCDS.FieldByName('ogb03').AsInteger;
      l_CDS.FieldByName('c_orderno').AsString:=tmpCDS.FieldByName('oea10').AsString;
      l_CDS.FieldByName('c_sizes').AsString:=tmpCDS.FieldByName('ta_oeb10').AsString;
      if SameText(tmpCDS.FieldByName('oeb05').AsString,'RL') then
         l_CDS.FieldByName('units').AsString:='M'
      else
         l_CDS.FieldByName('units').AsString:=tmpCDS.FieldByName('oeb05').AsString;
      l_CDS.FieldByName('qty').AsFloat:=tmpCDS.FieldByName('ogb12').AsFloat*tmpCDS.FieldByName('ogb05_fac').AsFloat;
      l_CDS.FieldByName('dealer').AsString:=g_UInfo^.UserName;

      l_CDS.Post;
      tmpCDS.Next;
    end;

  finally
    g_StatusBar.Panels[0].Text:='';
    FreeAndNil(tmpCDS);
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData, 'DLII020_AC101');
  ArrPrintData:=nil;
end;

procedure TFrmDLII020_AC101.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('出貨單號：');
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS,l_Xml);
end;

procedure TFrmDLII020_AC101.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

end.
