unit unMPST010_GetCore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, ExtCtrls, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, ImgList, Buttons, StrUtils;

type
  TFrmMPST010_GetCore = class(TFrmSTDI050)
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    DS: TDataSource;
    CDS: TClientDataSet;
    DBGridEh1: TDBGridEh;
    Label8: TLabel;
    Edit2: TEdit;
    Label9: TLabel;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    BitBtn2: TBitBtn;
    rgp: TRadioGroup;
    Panel1: TPanel;
    Panel2: TPanel;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    BitBtn3: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure BitBtn3Click(Sender: TObject);
  private
    l_StrIndex,l_StrIndexDesc:string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST010_GetCore: TFrmMPST010_GetCore;

implementation

uses unGlobal, unCommon, unMPST010;

{$R *.dfm}

procedure TFrmMPST010_GetCore.FormCreate(Sender: TObject);
begin
  inherited;
  BitBtn1.Caption:=CheckLang('計算');
  BitBtn2.Caption:=CheckLang('CCL排程資料');
  BitBtn3.Caption:=CheckLang('副排程資料');
  TabSheet1.Caption:=CheckLang('內用core資料');
  TabSheet2.Caption:=CheckLang('CCL排程資料');
  TabSheet3.Caption:=CheckLang('副排程資料');
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=CheckLang('至');
  Label8.Caption:=CheckLang('料號：');
  Label9.Caption:=CheckLang('總使用量：0');
  DBGridEh1.FieldColumns['materialno'].Title.Caption:=CheckLang('料號');
  DBGridEh1.FieldColumns['sqty'].Title.Caption:=CheckLang('使用量');
  DBGridEh1.FieldColumns['stk_qty'].Title.Caption:=CheckLang('庫存量');
  DBGridEh1.FieldColumns['zt_qty'].Title.Caption:=CheckLang('在製量');
  DBGridEh1.FieldColumns['diff_qty'].Title.Caption:=CheckLang('差異');
  
  DBGridEh2.FieldColumns['sdate'].Title.Caption:=CheckLang('生產日期');
  DBGridEh2.FieldColumns['machine'].Title.Caption:=CheckLang('機台');
  DBGridEh2.FieldColumns['currentboiler'].Title.Caption:=CheckLang('鍋次');
  DBGridEh2.FieldColumns['materialno'].Title.Caption:=CheckLang('料號');
  DBGridEh2.FieldColumns['wono'].Title.Caption:=CheckLang('製令單號');
  DBGridEh2.FieldColumns['custno'].Title.Caption:=CheckLang('客戶');
  DBGridEh2.FieldColumns['sqty'].Title.Caption:=CheckLang('排製量');
  DBGridEh2.FieldColumns['adate_new'].Title.Caption:=CheckLang('生管達交日期');

  DBGridEh3.FieldColumns['stype'].Title.Caption:=CheckLang('類別');
  DBGridEh3.FieldColumns['sdate'].Title.Caption:=CheckLang('生產日期');
  DBGridEh3.FieldColumns['materialno'].Title.Caption:=CheckLang('料號');
  DBGridEh3.FieldColumns['custno'].Title.Caption:=CheckLang('客戶');
  DBGridEh3.FieldColumns['sqty'].Title.Caption:=CheckLang('排製量');
  DBGridEh3.FieldColumns['adate'].Title.Caption:=CheckLang('生管達交日期');
  dtp1.Date:=Date;
  dtp2.Date:=Date+6;

  rgp.Items.Clear;
  rgp.Columns:=0;
  if SameText(g_UInfo^.BU,'ITEQDG') or SameText(g_UInfo^.BU,'ITEQGZ') then
  begin
    rgp.Items.Add('DG');
    rgp.Items.Add('GZ');
    rgp.Items.Add(CheckLang('副排程'));
    rgp.Columns:=3;
  end else
  begin
    rgp.Items.Add('主排程');
    rgp.Items.Add(CheckLang('副排程'));
    rgp.Columns:=2;
  end;
  rgp.ItemIndex:=0;
end;

procedure TFrmMPST010_GetCore.FormDestroy(Sender: TObject);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmMPST010_GetCore.BitBtn1Click(Sender: TObject);
var
  totqty:Double;
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  totqty:=0;
  tmpSQL:='and sdate between '+Quotedstr(DateToStr(Dtp1.Date))+' and '+Quotedstr(DateToStr(Dtp2.Date));
   if rgp.Items.Count=3 then
  begin
    if rgp.ItemIndex=0 then
       tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_DG+',')+')>0'
    else if rgp.ItemIndex=1 then
       tmpSQL:=tmpSQL+' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_GZ+',')+')>0';
  end;

  if ((rgp.Items.Count=2) and (rgp.ItemIndex=1)) or
     ((rgp.Items.Count=3) and (rgp.ItemIndex=2)) then
     tmpSQL:='exec dbo.proc_GetCCLCoreX '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(tmpSQL)+','+Quotedstr(Trim(Edit2.Text))
  else
     tmpSQL:='exec dbo.proc_GetCCLCore '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(tmpSQL)+','+Quotedstr(Trim(Edit2.Text));
  if QueryBySQL(tmpSQL, Data) then
  begin
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    Self.CDS.Data:=Data;
    with Self.CDS do
    begin
      DisableControls;
      while not Eof do
      begin
        totqty:=totqty+FieldByName('sqty').AsFloat;
        Next;
      end;
      First;
      EnableControls
    end;
  end;
  Label9.Caption:=CheckLang('總使用量：')+FloatToStr(totqty);
end;

//第1碼：P=Q、第11碼:C=N
procedure TFrmMPST010_GetCore.BitBtn2Click(Sender: TObject);
var
  tmpSQL,tmpStr,s1,s2,s3,s4,FOraDB:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TCLientDataSet;
begin
  inherited;
  if (not CDS.Active) or (CDS.IsEmpty) then
     s1:=UpperCase(Trim(Edit2.Text))
  else
     s1:=UpperCase(CDS.FieldByName('materialno').AsString);
  if (Length(s1)<>13) or (Pos(LeftStr(s1, 1),'PQ')=0) then
  begin
    ShowMsg('請選擇或輸入一個料號,第一碼為P、Q,長度13碼!',48);
    Exit;
  end;

  if ((rgp.Items.Count=2) and (rgp.ItemIndex=1)) or
     ((rgp.Items.Count=3) and (rgp.ItemIndex=2)) then
  begin
    ShowMsg('請選擇CCL排程!',48);
    Exit;
  end;

  if LeftStr(s1, 1)='P' then
     s2:='Q'+Copy(s1,2,20)
  else
     s2:='P'+Copy(s1,2,20);
  if Copy(s1,11,1)='C' then
  begin
    s3:=Copy(s1,1,10)+'N'+Copy(s1,12,10);
    s4:=Copy(s2,1,10)+'N'+Copy(s2,12,10);
  end
  else if Copy(s1,11,1)='N' then
  begin
    s3:=Copy(s1,1,10)+'C'+Copy(s1,12,10);
    s4:=Copy(s2,1,10)+'C'+Copy(s2,12,10);
  end else
  begin
    s3:=s1;
    s4:=s1;
  end;

  FOraDB:=g_UInfo^.BU;
  if rgp.Items.Count=3 then
  begin
    if rgp.ItemIndex=0 then
       tmpStr:=' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_DG+',')+')>0'
    else if rgp.ItemIndex=2 then
       tmpStr:=' and charindex('',''+machine+'','','+Quotedstr(','+g_MachineCCL_GZ+',')+')>0';
  end;

  tmpSQL:='	declare @bu varchar(6)='+Quotedstr(g_UInfo^.BU)
         +' declare @bmb03_1 varchar(20)='+Quotedstr(s1)
         +' declare @bmb03_2 varchar(20)='+Quotedstr(s2)
         +' declare @bmb03_3 varchar(20)='+Quotedstr(s3)
         +' declare @bmb03_4 varchar(20)='+Quotedstr(s4)
         +' declare @t table(bmb03 varchar(20))'
         +' declare @sql varchar(8000)'

         +' set @sql=''select distinct bmb01 from '+FOraDB+'.bmb_file'
         +' where bmb03 in (''''''''''+@bmb03_1+'''''''''','
         +' ''''''''''+@bmb03_2+'''''''''','
         +' ''''''''''+@bmb03_3+'''''''''','
         +' ''''''''''+@bmb03_4+'''''''''')'''
         +' set @sql=''select * from openquery(iteqdg,''''''+@sql+'''''')'''
         +' insert into @t(bmb03) exec (@sql)'
         
         +' select sdate,machine,currentboiler,materialno,wono,'
         +' isnull(custno,'''')+isnull(custom,'''') as custno,sqty,adate_new'
         +' from mps010 inner join @t on materialno=bmb03'
         +' where bu=@bu and isnull(errorflag,0)=0 and sqty>0'
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date))+tmpStr
         +' order by sdate,machine,currentboiler';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpStr:='';
    tmpCDS1:=TCLientDataSet.Create(nil);
    tmpCDS2:=TCLientDataSet.Create(nil);
    try
      tmpCDS1.Data:=Data;
      while not tmpCDS1.Eof do
      begin
        if (Length(tmpCDS1.FieldByName('wono').AsString)>0) and
           (Pos(tmpCDS1.FieldByName('wono').AsString,tmpStr)=0) then
           tmpStr:=tmpStr+','+Quotedstr(tmpCDS1.FieldByName('wono').AsString);
        tmpCDS1.Next;
      end;

      if Length(tmpStr)>0 then
      begin
        Delete(tmpStr,1,1);
        Data:=null;
        tmpSQL:='select shb05 from '+FOraDB+'.shb_file'
               +' where shb05 in ('+tmpStr+') and shb06=1 and shbacti=''Y''';
        if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          tmpCDS2.Data:=Data;
          while not tmpCDS2.Eof do
          begin
            if tmpCDS1.Locate('wono',tmpCDS2.FieldByName('shb05').AsString,[]) then
               tmpCDS1.Delete;
            tmpCDS2.Next;
          end;
        end;
      end;
      if tmpCDS1.ChangeCount>0 then
         tmpCDS1.MergeChangeLog;
      CDS2.Data:=tmpCDS1.Data;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
    end;
  end;
  PCL.ActivePageIndex:=1;
end;

//第1碼：P=Q、第11碼:C=N
procedure TFrmMPST010_GetCore.BitBtn3Click(Sender: TObject);
var
  tmpSQL,s1,s2,s3,s4,FOraDB:string;
  Data:OleVariant;
begin
  inherited;
  if (not CDS.Active) or (CDS.IsEmpty) then
     s1:=UpperCase(Trim(Edit2.Text))
  else
     s1:=UpperCase(CDS.FieldByName('materialno').AsString);
  if (Length(s1)<>13) or (Pos(LeftStr(s1, 1),'PQ')=0) then
  begin
    ShowMsg('請選擇或輸入一個料號,第一碼為P、Q,長度13碼!',48);
    Exit;
  end;

  if LeftStr(s1, 1)='P' then
     s2:='Q'+Copy(s1,2,20)
  else
     s2:='P'+Copy(s1,2,20);
  if Copy(s1,11,1)='C' then
  begin
    s3:=Copy(s1,1,10)+'N'+Copy(s1,12,10);
    s4:=Copy(s2,1,10)+'N'+Copy(s2,12,10);
  end
  else if Copy(s1,11,1)='N' then
  begin
    s3:=Copy(s1,1,10)+'C'+Copy(s1,12,10);
    s4:=Copy(s2,1,10)+'C'+Copy(s2,12,10);
  end else
  begin
    s3:=s1;
    s4:=s1;
  end;

  FOraDB:=g_UInfo^.BU;
  tmpSQL:='	declare @bu varchar(6)='+Quotedstr(g_UInfo^.BU)
         +' declare @bmb03_1 varchar(20)='+Quotedstr(s1)
         +' declare @bmb03_2 varchar(20)='+Quotedstr(s2)
         +' declare @bmb03_3 varchar(20)='+Quotedstr(s3)
         +' declare @bmb03_4 varchar(20)='+Quotedstr(s4)
         +' declare @t table(bmb03 varchar(20))'
         +' declare @sql varchar(8000)'

         +' set @sql=''select distinct bmb01 from '+FOraDB+'.bmb_file'
         +' where bmb03 in (''''''''''+@bmb03_1+'''''''''','
         +' ''''''''''+@bmb03_2+'''''''''','
         +' ''''''''''+@bmb03_3+'''''''''','
         +' ''''''''''+@bmb03_4+'''''''''')'''
         +' set @sql=''select * from openquery(iteqdg,''''''+@sql+'''''')'''
         +' insert into @t(bmb03) exec (@sql)'
         
         +' select stype,sdate,materialno,'
         +' isnull(custno,'''')+isnull(custom,'''') as custno,sqty,adate'
         +' from mps012 inner join @t on materialno=bmb03'
         +' where bu=@bu and isnull(isempty,0)=0 and sqty>0'
         +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
         +' and '+Quotedstr(DateToStr(dtp2.Date))
         +' order by stype,sdate';
  if QueryBySQL(tmpSQL, Data) then
     CDS3.Data:=Data;
  PCL.ActivePageIndex:=2;
end;

procedure TFrmMPST010_GetCore.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
