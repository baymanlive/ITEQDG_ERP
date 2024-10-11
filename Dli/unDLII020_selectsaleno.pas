unit unDLII020_selectsaleno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh,
  ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLII020_selectsaleno = class(TFrmSTDI050)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    BitBtn1: TBitBtn;
    Panel1: TPanel;
    DBGridEh1: TDBGridEh;
    Panel2: TPanel;
    Memo1: TMemo;
    DataSource1: TDataSource;
    CDS: TClientDataSet;
    Label3: TLabel;
    Edit1: TEdit;
    BitBtn2: TBitBtn;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    l_custno,l_ret:string;
    { Public declarations }
  end;

var
  FrmDLII020_selectsaleno: TFrmDLII020_selectsaleno;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII020_selectsaleno.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('出貨日期：');
  Label2.Caption:=CheckLang('至');
  Label3.Caption:=CheckLang('總單號/出貨單：');
  BitBtn1.Caption:=CheckLang('查詢出貨單');
  BitBtn2.Caption:=CheckLang('查詢列印記錄');
  BitBtn3.Caption:=CheckLang('作廢');
  TabSheet2.Caption:=CheckLang('總單號');
  DBGridEh1.FieldColumns['oga01'].Title.Caption:=CheckLang('出貨單號');
  DBGridEh1.FieldColumns['oga02'].Title.Caption:=CheckLang('單據日期');
  DBGridEh1.FieldColumns['ptype'].Title.Caption:=CheckLang('產品別');
  DBGridEh1.FieldColumns['ogapost'].Title.Caption:=CheckLang('扣帳');
  DBGridEh1.FieldColumns['ogaprsw'].Title.Caption:=CheckLang('列印次數');
  DBGridEh1.FieldColumns['scan'].Title.Caption:=CheckLang('掃描');
  DBGridEh1.FieldColumns['out'].Title.Caption:=CheckLang('出廠確認');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmDLII020_selectsaleno.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLII020_selectsaleno.BitBtn1Click(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  inherited;
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('查詢起始日期不能大於截止日期!',48);
    dtp1.SetFocus;
    Exit;
  end;

  if dtp2.Date-dtp1.Date>6 then
  begin
    ShowMsg('日期范圍<7天!',48);
    dtp1.SetFocus;
    Exit;
  end;

  tmpSQL:='YYYY/MM/DD';
  tmpSQL:='select distinct oga01,oga02,ogapost,ogaprsw,ogapost as scan,ogapost as out,'
         +'case when substr(ogb04,1,1) in (''E'',''T'') then ''CCL'' else ''PP'' end as ptype'
         +' from '+g_UInfo^.BU+'.oga_file,'+g_UInfo^.BU+'.ogb_file'
         +' where oga01=ogb01 and oga04='''+l_custno+''' and ogapost<>''X'''
         +' and to_char(oga02,'''+tmpSQL+''') between '
         +Quotedstr(StringReplace(FormatDateTime(tmpSQL,dtp1.Date),'-','/',[rfReplaceAll]))+' and '
         +Quotedstr(StringReplace(FormatDateTime(tmpSQL,dtp2.Date),'-','/',[rfReplaceAll]))
         +' order by oga02,oga01';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpSQL:='';
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    with tmpCDS1 do
    while not Eof do
    begin
      tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('oga01').AsString);
      Next;
    end;

    if Length(tmpSQL)>0 then
    begin
      Data:=null;
      Delete(tmpSQL,1,1);
      tmpSQL:='select b.saleno,a.conf from dli013 a,dli014 b'
             +' where a.bu=b.bu and a.dno=b.dno and b.saleno in ('+tmpSQL+')';
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS2.Data:=Data;
      with tmpCDS1 do
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('scan').AsString:='N';
          FieldByName('out').AsString:='N';
          if tmpCDS2.Locate('saleno',FieldByName('oga01').AsString,[]) then
          begin
            FieldByName('scan').AsString:='Y';
            if tmpCDS2.FieldByName('conf').AsString='Y' then
               FieldByName('out').AsString:='Y';
          end;
          Post;
          Next;
        end;
      end;
    end;

    CDS.Data:=tmpCDS1.Data;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmDLII020_selectsaleno.BitBtn2Click(Sender: TObject);
var
  str,tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  str:=Trim(Edit1.Text);
  if Length(str)=0 then
  begin
    ShowMsg('請輸入要查詢的總單號碼/出貨單號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpSQL:='select dno,saleno from dli024 where bu='+Quotedstr(g_UInfo^.BU)
         +' and (charindex('+Quotedstr(str)+',saleno)>0'
         +' or dno='+Quotedstr(str)+')'
         +' and isnull(not_use,0)=0 order by dno desc';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
     
  Memo1.Lines.Clear;
  Memo2.Lines.Clear;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
       Memo1.Lines.DelimitedText:=tmpCDS.Fields[1].AsString;

    //打印多次,多個流水號   
    if tmpCDS.RecordCount>1 then
    begin
      Memo2.Lines.Add('此單號多次列印,存在多個流水號：');
      while not tmpCDS.Eof do
      begin
        Memo2.Lines.Add(tmpCDS.Fields[0].AsString);
        tmpCDS.Next;
      end;
      PCL.ActivePageIndex:=1;
    end else
      Memo2.Lines.Text:=tmpCDS.Fields[0].AsString;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII020_selectsaleno.BitBtn3Click(Sender: TObject);
var
  str,tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  str:=Trim(Edit1.Text);
  if Length(str)=0 then
  begin
    ShowMsg('請輸入要作廢的總單號碼!',48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpSQL:='select * from dli024 where bu='+Quotedstr(g_UInfo^.BU)
         +' and dno='+Quotedstr(str);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg(str+'此總單號碼不存在!',48);
      Edit1.SetFocus;
      Exit;
    end;

    if tmpCDS.FieldByName('not_use').AsBoolean then
    begin
      ShowMsg(str+'已作廢!',48);
      Edit1.SetFocus;
      Exit;
    end;

    if ShowMsg('確定作廢'+str+'嗎?',33)=IdCancel then
       Exit;

    tmpCDS.Edit;
    tmpCDS.FieldByName('not_use').AsBoolean:=True;
    tmpCDS.Post;
    if CDSPost(tmpCDS, 'dli024') then
       ShowMsg('作廢完畢!',48);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmDLII020_selectsaleno.DBGridEh1DblClick(Sender: TObject);
var
  s:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  s:=CDS.FieldByName('oga01').AsString;
  if CDS.FieldByName('ogapost').AsString<>'Y' then
  begin
    ShowMsg(s+'未扣帳',48);
    Exit;
  end;

  if Memo1.Lines.IndexOf(s)=-1 then
     Memo1.Lines.Add(s);
end;

procedure TFrmDLII020_selectsaleno.btn_okClick(Sender: TObject);
var
  i:Integer;
  sList:TStringList;
begin
  if Length(Trim(Memo1.Text))=0 then
  begin
    ShowMsg('請選擇出貨單號!',48);
    Memo1.SetFocus;
    Exit;
  end;

  for i:=0 to Memo1.Lines.Count-1 do
  if Length(Memo1.Lines[i])<>10 then
  begin
    ShowMsg('第'+IntToStr(i+1)+'筆錯誤!',48);
    Memo1.SetFocus;
    Exit;
  end;

  sList:=TStringList.Create;
  try
    sList.DelimitedText:=Memo1.Lines.DelimitedText;
    sList.Sort;

    l_ret:='';
    for i:=0 to sList.Count-1 do
      l_ret:=l_ret+','+sList.Strings[i];

    Delete(l_ret,1,1);
  finally
    FreeAndNil(sList);
  end;

  inherited;
end;

end.
