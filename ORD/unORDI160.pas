unit unORDI160;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, ImgList, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls,
  ToolWin, Mask, DBCtrls, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmORDI160 = class(TFrmSTDI010)
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    Bu: TLabel;
    CustNo: TLabel;
    CustDesc: TLabel;
    ItemCodeA: TLabel;
    ItemDescA: TLabel;
    Lb_CustName: TLabel;
    MuserA: TLabel;
    MDateA: TLabel;
    lbl_CustDemo: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    PP: TLabel;
    CCL: TLabel;
    Label1: TLabel;
    CustItemCode: TLabel;
    DBEdit8: TDBEdit;
    GroupBox1: TGroupBox;
    tc_ocn16: TLabel;
    DBEdit9: TDBEdit;
    tc_ocn19: TLabel;
    DBEdit10: TDBEdit;
    tc_ocn09: TLabel;
    DBEdit11: TDBEdit;
    tc_ocn10: TLabel;
    DBEdit12: TDBEdit;
    tc_ocn08: TLabel;
    DBEdit13: TDBEdit;
    tc_ocn04: TLabel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    tc_ocn05: TLabel;
    DBEdit16: TDBEdit;
    tc_ocn11: TLabel;
    DBEdit17: TDBEdit;
    tc_ocn20: TLabel;
    DBEdit18: TDBEdit;
    tc_ocn21: TLabel;
    ta_ocn01: TLabel;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    ta_ocn02: TLabel;
    DBEdit21: TDBEdit;
    tc_ocn14: TLabel;
    DBEdit22: TDBEdit;
    tc_ocn06: TLabel;
    DBEdit23: TDBEdit;
    tc_ocn07: TLabel;
    tc_ocn18: TLabel;
    DBEdit24: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure DBEdit2Exit(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_deleteClick(Sender: TObject);
    procedure DBEdit4Exit(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
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
  FrmORDI160: TFrmORDI160;

implementation
uses  unGlobal,unCommon;
{$R *.dfm}

procedure TFrmORDI160.FormCreate(Sender: TObject);
begin
  p_SysId:='ORD';
  p_TableName:='ORD160';
  inherited;

end;

procedure TFrmORDI160.RefreshDS(strFilter:string);
var
  Data:OleVariant;
begin
//  if QueryBySQL('Select * From Sys_Bu Where 1=1 '+strFilter, Data) then
  if QueryBySQL('Select * From ORD160 Where IsOk=0 ', Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmORDI160.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('MuserA').AsString:=g_UInfo^.UserId;
  DataSet.FieldByName('MDateA').AsDateTime:=Date;
end;

procedure TFrmORDI160.CDSAfterScroll(DataSet: TDataSet);

begin
  inherited;
  Lb_CustName.caption:=Getocc02(DataSet.fieldbyname('Custno').AsString);
  Edit3.Text:=GetCustDemoPP(DBEdit2.Text);
  Edit4.Text:=GetCustDemoCCL(DBEdit2.Text);
  
end;

//取tt中客戶代號
function TFrmORDI160.Getocc02(const custno: string): string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  Result := '';
  if SameText(DBEdit1.Text, 'ITEQDG') then
    tmpSQL := 'ITEQDG'
  else if SameText(DBEdit1.Text, 'ITEQGZ') then
    tmpSQL := 'ITEQGZ'
  else if SameText(DBEdit1.Text, 'ITEQJX') then
    tmpSQL := 'ITEQJX'
  else if SameText(DBEdit1.Text, 'ITEQ2') then
    tmpSQL := 'ITEQ2'
  else
    tmpSQL := g_UInfo^.Bu;
  tmpSQL := 'select occ02 from ' + tmpSQL + '.occ_file' + ' where occ01=' + Quotedstr(custno) + ' and rownum=1';
  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;

//取ORD161中客戶Demo
function TFrmORDI160.GetCustDemoPP(const custno: string):string;
var
  tmpSQL: string;
  Data: OleVariant;
begin

  tmpSQL := 'select top 1 CustDemoPP  from ORD180 ' + ' where CustNo=' + Quotedstr(custno) + ' and Bu= '+Quotedstr(g_UInfo^.Bu);
  if not QueryOneCR(tmpSQL, Data) then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;
function TFrmORDI160.GetCustDemoCCL(const custno: string):string;
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'select top 1 CustDemoCCL  from ORD180 ' + ' where CustNo=' + Quotedstr(custno) + ' and Bu= '+Quotedstr(g_UInfo^.Bu);
  if not QueryOneCR(tmpSQL, Data) then    Exit;
  if not VarIsNull(Data) then    Result := VarToStr(Data);
end;

procedure TFrmORDI160.DBEdit2Exit(Sender: TObject);
begin
  inherited;
  Lb_Custname.Caption:=Getocc02(DBEdit2.Text);
  Edit3.Text:=GetCustDemoPP(DBEdit2.Text);
  Edit4.Text:=GetCustDemoCCL(DBEdit2.Text);
end;

procedure TFrmORDI160.CDSBeforePost(DataSet: TDataSet);
var
  IsFind:Boolean;
  tmpStr:string;
begin
  if Trim(CDS.FieldByName('CustNo').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(CustNo.Caption));
    if DBEdit2.CanFocus then
       DBEdit2.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('CustDesc').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(CustDesc.Caption));
    if DBEdit3.CanFocus then
       DBEdit3.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('ItemCodeA').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ItemCodeA.Caption));
    if DBEdit4.CanFocus then
       DBEdit4.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('ItemDescA').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ItemDescA.Caption));
    if DBEdit5.CanFocus then
       DBEdit5.SetFocus;
    Abort;
  end;
  IF CDS.State=dsinsert then
  begin
    tmpStr:='Select Top 1 1 From ORD160 Where Bu='+Quotedstr(g_Uinfo^.BU)
           +' And CustNo=' +Quotedstr(Trim(CDS.FieldByName('CustNo').AsString))
           +' And ItemCodeA='+Quotedstr(Trim(CDS.FieldByName('ItemCodeA').AsString));
    if QueryExists(tmpStr, IsFind) then
    begin
       showmessage('料號已存在,請檢查！');
       Exit;
    end;
  end;
  inherited;

end;

procedure TFrmORDI160.btn_deleteClick(Sender: TObject);
var
  IsFind:Boolean;
  tmpStr:string;
begin
    //檢查當天備料是否存在
  tmpStr:='Select Top 1 1 From ORD160 Where Bu='+Quotedstr(g_Uinfo^.BU)
         +' And CustNo=' +Quotedstr(Trim(CDS.FieldByName('CustNo').AsString))
         +' And ItemCodeA='+Quotedstr(Trim(CDS.FieldByName('ItemCodeA').AsString))
         +' And IsOk=1';
  if QueryExists(tmpStr, IsFind) then
  begin
     showmessage('已經複核過了,不能刪除');
     Exit;
  end;
  inherited;

end;

procedure TFrmORDI160.DBEdit4Exit(Sender: TObject);
var
  tmpSQL,tmpDB,tmp_ima31: string;
  Data: OleVariant;
begin
  if CDS.state IN [dsinsert,dsedit] then
  begin
  if SameText(DBEdit1.Text, 'ITEQDG') then
    tmpDB := 'ITEQDG'
  else if SameText(DBEdit1.Text, 'ITEQGZ') then
    tmpDB := 'ITEQGZ'
  else if SameText(DBEdit1.Text, 'ITEQJX') then
    tmpDB := 'ITEQJX'
  else if SameText(DBEdit1.Text, 'ITEQ2') then
    tmpDB := 'ITEQ2'
  else
    tmpDB := g_UInfo^.Bu;


  IF tmpDB='' then   exit;

  tmpDB:=DBEdit1.Text;
  tmpSQL := 'select ima31 from ' + tmpDB + '.ima_file' + ' where ima01=' + Quotedstr(DBEdit4.Text) + ' and imaacti='+Quotedstr('Y');
 // if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
 QueryOneCR(tmpSQL, Data, 'ORACLE');
 if VarIsNull(Data) then
  begin
      ShowMsg('料號[%s]在aimi100中不存在或無效中,請檢查！',48,myStringReplace(DBEdit4.Text));
      Dbedit4.SetFocus;
      Exit;
  end;
  if not VarIsNull(Data) then
  BEGIN
    tmp_ima31 := VarToStr(Data);
  END;
    CDS.FieldByName('tc_ocn19').AsString:=tmp_ima31;
    if (tmp_ima31='RL') or (tmp_ima31='SH') then
      CDS.FieldByName('tc_ocn08').AsString:='1';
    if (uppercase(tmp_ima31)='PN') or (uppercase(tmp_ima31)='PNL') then
      CDS.FieldByName('tc_ocn08').AsString:='2';
      
    if length(DBEdit4.Text)=20 then
    begin
       CDS.FieldByName('ta_ocn01').AsFloat:=strtoint(copy(DBEdit4.Text,11,4))/100;
       CDS.FieldByName('ta_ocn02').AsFloat:=strtoint(copy(DBEdit4.Text,15,4))/100;
    end;
    if length(DBEdit4.Text)=19 then
    begin
       CDS.FieldByName('ta_ocn01').AsFloat:=strtoint(copy(DBEdit4.Text,9,4))/100;
       CDS.FieldByName('ta_ocn02').AsFloat:=strtoint(copy(DBEdit4.Text,13,4))/100;
    end;
    if CDS.FieldByName('tc_ocn16').AsString='' then
       CDS.FieldByName('tc_ocn16').AsString:='1';

  end;
  inherited;

end;

procedure TFrmORDI160.btn_insertClick(Sender: TObject);
var
  tmpDB:string;
begin
  if SameText(g_UInfo^.Bu, 'ITEQDG') then
    tmpDB := 'ITEQDG'
  else if SameText(g_UInfo^.Bu, 'ITEQGZ') then
    tmpDB := 'ITEQGZ'
  else if SameText(g_UInfo^.Bu, 'ITEQJX') then
    tmpDB := 'ITEQJX'
  else if SameText(g_UInfo^.Bu, 'ITEQ2') then
    tmpDB := 'ITEQ2'
  else
    tmpDB := g_UInfo^.Bu;

  DBEdit1.Text:=tmpDB;
  inherited;

end;

end.
