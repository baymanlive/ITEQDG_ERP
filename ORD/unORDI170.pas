unit unORDI170;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, ImgList, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls,
  ToolWin, Mask, DBCtrls;

type
  TFrmORDI170 = class(TFrmSTDI010)
    Bu: TLabel;
    CustNo: TLabel;
    CustDesc: TLabel;
    ItemCodeB: TLabel;
    ItemDescB: TLabel;
    Lb_CustName: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    MuserB: TLabel;
    MDateB: TLabel;
    DBEdit7: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit5: TDBEdit;
    lbl_CustDemo: TLabel;
    PP: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    CCL: TLabel;
    CustItemCode: TLabel;
    DBEdit8: TDBEdit;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
    function Getocc02(const custno: string): string;
    function GetCustDemoPP(const custno: string):string;
    function GetCustDemoCCL(const custno: string):string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmORDI170: TFrmORDI170;

implementation
uses  unGlobal,unCommon, unORDI170_query;

{$R *.dfm}

//取tt中客戶代號
function TFrmORDI170.Getocc02(const custno: string): string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := '';
  if SameText(g_UInfo^.Bu, 'ITEQDG') then
    tmpSQL := 'ITEQDG'
  else if SameText(g_UInfo^.Bu, 'ITEQGZ') then
    tmpSQL := 'ITEQGZ'
  else if SameText(g_UInfo^.Bu, 'ITEQJX') then
    tmpSQL := 'ITEQJX'
  else
    tmpSQL := g_UInfo^.Bu;
  tmpSQL := 'select occ02 from ' + tmpSQL + '.occ_file' + ' where occ01=' + Quotedstr(custno) + ' and rownum=1';
  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;

//取ORD161中客戶Demo
function TFrmORDI170.GetCustDemoPP(const custno: string):string;
var
  tmpSQL: string;
  Data: OleVariant;
begin

  tmpSQL := 'select top 1 CustDemoPP  from ORD180 ' + ' where CustNo=' + Quotedstr(custno) + ' and Bu= '+Quotedstr(g_UInfo^.Bu);
  if not QueryOneCR(tmpSQL, Data) then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;
function TFrmORDI170.GetCustDemoCCL(const custno: string):string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'select top 1 CustDemoCCL  from ORD180 ' + ' where CustNo=' + Quotedstr(custno) + ' and Bu= '+Quotedstr(g_UInfo^.Bu);
  if not QueryOneCR(tmpSQL, Data) then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;

procedure TFrmORDI170.FormCreate(Sender: TObject);
begin
  p_SysId:='ORD';
  p_TableName:='ORD160';
  inherited;
end;
procedure TFrmORDI170.RefreshDS(strFilter:string);
var
  Data:OleVariant;

begin
  if QueryBySQL('Select * From ORD160 Where IsOk=0 and MuserA<>'+Quotedstr(g_UInfo^.UserId) +'', Data) then
     CDS.Data:=Data;
  inherited;
end;
procedure TFrmORDI170.btn_queryClick(Sender: TObject);
begin
 // inherited;
   if not Assigned(FrmORDI170_query) then
     FrmORDI170_query:=TFrmORDI170_query.Create(Application);
  try
    FrmORDI170_query.ShowModal;
  finally
    FreeAndNil(FrmORDI170_query);
  end;
end;

procedure TFrmORDI170.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL,tmpDB:string;
  tmpCDS2:TClientDataSet;
   Data:OleVariant;
begin
  DataSet.FieldByName('MuserB').AsString:=g_UInfo^.UserId;
  DataSet.FieldByName('MDateB').AsDateTime:=Date;

  if Trim(CDS.FieldByName('ItemCodeB').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ItemCodeB.Caption));
    if DBEdit4.CanFocus then
       DBEdit4.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('ItemDescB').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ItemDescB.Caption));
    if DBEdit5.CanFocus then
       DBEdit5.SetFocus;
    Abort;
  end;
    if CDS.FieldByName('ItemCodeB').AsString<>CDS.FieldByName('ItemCodeA').AsString then
  begin
    ShowMsg('[%s]與初檢內容不同,請檢查！',48,myStringReplace(ItemCodeB.Caption));
    if DBEdit4.CanFocus then
       DBEdit4.SetFocus;
    Abort;
  end;
    if CDS.FieldByName('ItemDescB').AsString<>CDS.FieldByName('ItemDescA').AsString then
  begin
    ShowMsg('[%s]與初檢內容不同,請檢查！',48,myStringReplace(ItemDescB.Caption));
    if DBEdit5.CanFocus then
       DBEdit5.SetFocus;
    Abort;
  end;
  DataSet.FieldByName('IsOk').AsBoolean:=TRUE;


  inherited;

  tmpCDS2:=TClientDataSet.Create(nil);
  if SameText(DBEdit1.Text, 'ITEQDG') then
    tmpDB := 'ITEQDG'
  else if SameText(DBEdit1.Text, 'ITEQGZ') then
    tmpDB := 'ITEQGZ'
  else if SameText(DBEdit1.Text, 'ITEQJX') then
    tmpDB := 'ITEQJX'
  else if SameText(DBEdit1.Text, 'ITEQ2') then
    tmpDB := 'ITEQ2'
  else
    tmpDB :='';
  IF (tmpDB='') then
  BEGIN
    showmessage('營運中心只能是:ITEQDG/ITEQGZ/ITEQ2/ITEQJX');
    EXIT;
  end;
  //檢查cxmi154dg是否有記錄,若無則新增
  tmpSQL:='Select  tc_ocn01  From  ' +tmpDB+ '.tc_ocn_file   where tc_ocn01=' + Quotedstr(CDS.FieldByName('CustNo').AsString)
         +' And tc_ocn02='+Quotedstr(CDS.FieldByName('CustItemCode').AsString)
         + ' And tc_ocn12='+Quotedstr(CDS.FieldByName('ItemCodeB').AsString)
         + ' And tc_ocn16='+Quotedstr(CDS.FieldByName('tc_ocn16').AsString)
         +' and rownum=1';

  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
  begin
    showmessage('客戶：'+CDS.FieldByName('CustNo').AsString+'--廠內料號：'+CDS.FieldByName('CustItemCode').AsString+' 在cxmi154dg中存在;');
    Exit;
  end;

  tmpSQL:='Select * From '+tmpDB+'.tc_ocn_file  Where 1=2';
  try
    QueryBySQL(tmpSQL, Data,'ORACLE');
    tmpCDS2.Data:=Data;
    tmpCDS2.Append;
    tmpCDS2.FieldByName('tc_ocn01').AsString:=CDS.FieldByName('CustNo').AsString;
    tmpCDS2.FieldByName('tc_ocn02').AsString:=CDS.FieldByName('CustItemCode').AsString;
    tmpCDS2.FieldByName('tc_ocn03').AsString:=CDS.FieldByName('ItemDescB').AsString;
    tmpCDS2.FieldByName('tc_ocn12').AsString:=CDS.FieldByName('ItemCodeB').AsString;
    tmpCDS2.FieldByName('tc_ocnuser').AsString:=g_UInfo^.UserId;
    tmpCDS2.FieldByName('tc_ocndate').AsDateTime:=date;
    tmpCDS2.FieldByName('tc_ocn16').AsString:=CDS.FieldByName('tc_ocn16').AsString;
    tmpCDS2.FieldByName('tc_ocn19').AsString:=CDS.FieldByName('tc_ocn19').AsString;
    tmpCDS2.FieldByName('tc_ocn10').AsString:=CDS.FieldByName('tc_ocn10').AsString;
    tmpCDS2.FieldByName('tc_ocn08').AsString:=CDS.FieldByName('tc_ocn08').AsString;
    tmpCDS2.FieldByName('tc_ocn04').AsString:=CDS.FieldByName('tc_ocn04').AsString;
    tmpCDS2.FieldByName('tc_ocn05').AsString:=CDS.FieldByName('tc_ocn05').AsString;
    tmpCDS2.FieldByName('tc_ocn11').AsString:=CDS.FieldByName('tc_ocn11').AsString;
    tmpCDS2.FieldByName('tc_ocn20').AsString:=CDS.FieldByName('tc_ocn20').AsString;
    tmpCDS2.FieldByName('ta_ocn01').AsString:=CDS.FieldByName('ta_ocn01').AsString;
    tmpCDS2.FieldByName('ta_ocn02').AsString:=CDS.FieldByName('ta_ocn02').AsString;
    tmpCDS2.FieldByName('tc_ocn21').AsString:=CDS.FieldByName('tc_ocn21').AsString;
    tmpCDS2.FieldByName('tc_ocn14').AsString:=CDS.FieldByName('tc_ocn14').AsString;
    tmpCDS2.FieldByName('tc_ocn06').AsString:=CDS.FieldByName('tc_ocn06').AsString;
    tmpCDS2.FieldByName('tc_ocn07').AsString:=CDS.FieldByName('tc_ocn07').AsString;
    tmpCDS2.FieldByName('tc_ocn18').AsString:=CDS.FieldByName('tc_ocn18').AsString;
    tmpCDS2.Post;
    CDSPost(tmpCDS2, tmpDB+ '.tc_ocn_file','ORACLE');
  finally
      FreeAndNil(tmpCDS2);
  end;

end;

procedure TFrmORDI170.CDSAfterScroll(DataSet: TDataSet);
begin
  Lb_Custname.Caption:=Getocc02(DBEdit2.Text);
  Edit3.Text:=GetCustDemoPP(DBEdit2.Text);
  Edit4.Text:=GetCustDemoCCL(DBEdit2.Text);
  inherited;

end;

procedure TFrmORDI170.ToolButton1Click(Sender: TObject);
var
  tmpSQL,tmpDB:string;
  tmpCDS3:TClientDataSet;
   Data:OleVariant;
begin
//  inherited;
 tmpCDS3:=TClientDataSet.Create(nil);
  if SameText(DBEdit1.Text, 'ITEQDG') then
    tmpDB := 'ITEQDG'
  else if SameText(DBEdit1.Text, 'ITEQGZ') then
    tmpDB := 'ITEQGZ'
  else if SameText(DBEdit1.Text, 'ITEQJX') then
    tmpDB := 'ITEQJX'
  else if SameText(DBEdit1.Text, 'ITEQ2') then
    tmpDB := 'ITEQ2'
  else
    tmpDB :='';
  IF (tmpDB='') then
  BEGIN
    showmessage('營運中心只能是:ITEQDG/ITEQGZ/ITEQ2/ITEQJX');
    EXIT;
  end;
  //檢查cxmi154dg是否有記錄,若無則新增
  tmpSQL:='Select  tc_ocn01  From  ' +tmpDB+ '.tc_ocn_file   where tc_ocn01=' + Quotedstr(CDS.FieldByName('CustNo').AsString)
         +' And tc_ocn02='+Quotedstr(CDS.FieldByName('CustItemCode').AsString)
         + ' And tc_ocn12='+Quotedstr(CDS.FieldByName('ItemCodeB').AsString)
         + ' And tc_ocn16='+Quotedstr(CDS.FieldByName('tc_ocn16').AsString)
         +' and rownum=1';

  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
  begin
    showmessage('客戶：'+CDS.FieldByName('CustNo').AsString+'--廠內料號：'+CDS.FieldByName('CustItemCode').AsString+' 在cxmi154dg中存在;');
    Exit;
  end;

  tmpSQL:='Select * From '+tmpDB+'.tc_ocn_file  Where 1=2';
  try
    QueryBySQL(tmpSQL, Data,'ORACLE');
    tmpCDS3.Data:=Data;
    tmpCDS3.Append;
    tmpCDS3.FieldByName('tc_ocn01').AsString:=CDS.FieldByName('CustNo').AsString;
    tmpCDS3.FieldByName('tc_ocn02').AsString:=CDS.FieldByName('CustItemCode').AsString;
    tmpCDS3.FieldByName('tc_ocn03').AsString:=CDS.FieldByName('ItemDescB').AsString;
    tmpCDS3.FieldByName('tc_ocn12').AsString:=CDS.FieldByName('ItemCodeB').AsString;
    tmpCDS3.FieldByName('tc_ocnuser').AsString:=g_UInfo^.UserId;
    tmpCDS3.FieldByName('tc_ocndate').AsDateTime:=date;
    tmpCDS3.FieldByName('tc_ocn16').AsString:=CDS.FieldByName('tc_ocn16').AsString;
    tmpCDS3.FieldByName('tc_ocn19').AsString:=CDS.FieldByName('tc_ocn19').AsString;
    tmpCDS3.FieldByName('tc_ocn10').AsString:=CDS.FieldByName('tc_ocn10').AsString;
    tmpCDS3.FieldByName('tc_ocn08').AsString:=CDS.FieldByName('tc_ocn08').AsString;
    tmpCDS3.FieldByName('tc_ocn04').AsString:=CDS.FieldByName('tc_ocn04').AsString;
    tmpCDS3.FieldByName('tc_ocn05').AsString:=CDS.FieldByName('tc_ocn05').AsString;
    tmpCDS3.FieldByName('tc_ocn11').AsString:=CDS.FieldByName('tc_ocn11').AsString;
    tmpCDS3.FieldByName('tc_ocn20').AsString:=CDS.FieldByName('tc_ocn20').AsString;
    tmpCDS3.FieldByName('ta_ocn01').AsString:=CDS.FieldByName('ta_ocn01').AsString;
    tmpCDS3.FieldByName('ta_ocn02').AsString:=CDS.FieldByName('ta_ocn02').AsString;
    tmpCDS3.FieldByName('tc_ocn21').AsString:=CDS.FieldByName('tc_ocn21').AsString;
    tmpCDS3.FieldByName('tc_ocn14').AsString:=CDS.FieldByName('tc_ocn14').AsString;
    tmpCDS3.FieldByName('tc_ocn06').AsString:=CDS.FieldByName('tc_ocn06').AsString;
    tmpCDS3.FieldByName('tc_ocn07').AsString:=CDS.FieldByName('tc_ocn07').AsString;
    tmpCDS3.FieldByName('tc_ocn18').AsString:=CDS.FieldByName('tc_ocn18').AsString;
    tmpCDS3.Post;
    CDSPost(tmpCDS3, tmpDB+ '.tc_ocn_file','ORACLE');
  finally
      FreeAndNil(tmpCDS3);
  end;
end;

end.
