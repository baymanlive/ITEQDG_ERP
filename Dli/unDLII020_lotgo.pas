unit unDLII020_lotgo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls, ComCtrls;

type
  TFrmDLII020_lotgo = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    DS1: TDataSource;
    CDS1: TClientDataSet;
    DBGridEh2: TDBGridEh;
    Panel1: TPanel;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure CDS1AfterScroll(DataSet: TDataSet);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    l_bu,l_sql2:string;
    l_list2:TStrings;
    procedure GetCDS2;
  public
    { Public declarations }
    l_dno,l_remark:string;
    l_ditem:Integer;
  end;

var
  FrmDLII020_lotgo: TFrmDLII020_lotgo;

implementation

uses unGlobal, unCommon, unDLII020_const;

{$R *.dfm}

procedure TFrmDLII020_lotgo.GetCDS2;
var
  tmpSQL:string;
begin
  if not Assigned(l_list2) then
     Exit;

  tmpSQL:='Select *,Case SFlag When 0 Then ''檢貨'' When 1 Then ''並包確認'' End SFlagX,'
         +' Case JFlag When 1 Then ''並包當中'' When 2 Then ''並包完成'' End JFlagX'
         +' From DLI020 Where Dno='+Quotedstr(CDS1.FieldByName('Dno').AsString)
         +' And Ditem='+IntToStr(CDS1.FieldByName('Ditem').AsInteger)
         +' And Bu='+Quotedstr(l_bu)
         +' Order By Sno';
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmDLII020_lotgo.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'FrmDLII020_lotgo');
  SetGrdCaption(DBGridEh2, 'DLI020');

  if SameText(g_UInfo^.BU,'iteqdg') then
     l_bu:='ITEQGZ'
  else if SameText(g_UInfo^.BU,'iteqgz') then
     l_bu:='ITEQDG'
  else
     l_bu:='@@@@';
  Self.Caption:=Self.Caption+' '+l_bu;
  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;  
end;

procedure TFrmDLII020_lotgo.FormShow(Sender: TObject);
var
  pos1:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  pos1:=Pos(' ',l_remark);
  if pos1>0 then
     l_remark:=Copy(l_remark,1,pos1-1);
  tmpSQL:='select dno,ditem,indate,saleno,saleitem,odate,orderno,orderitem,custno,custshort,'
         +' pno,pname,ordercount,notcount1'
         +' from dli010 where bu='+Quotedstr(l_bu)
         +' and custno+''-''+orderno+''-''+cast(orderitem as varchar(10))='
         +Quotedstr(StringReplace(l_remark,'-JXB','',[rfIgnoreCase]))
         +' and isnull(garbageflag,0)=0'
         +' order by indate';
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS1.Data:=Data;
    if CDS1.IsEmpty then
       GetCDS2;
  end;
end;

procedure TFrmDLII020_lotgo.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  FreeAndNil(l_list2);
  DBGridEh1.Free;
  DBGridEh2.Free;
end;

procedure TFrmDLII020_lotgo.btn_okClick(Sender: TObject);
var
  qRet2:Boolean;
  tmpSQL,tmpFilter,tmpArea,tmpM1:string;
  Data:OleVariant;
  isExist:Boolean;
begin
  //inherited;
  if (not CDS1.Active) or CDS1.IsEmpty then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  //這些客戶無COC掃描資料,不給拋轉
  if Pos(CDS1.FieldByName('custno').AsString,g_strSG+'/'+g_strSH+'/'+g_FZ)>0 then
  begin
    tmpSQL:='select top 1 bu from dli040'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and dno='+Quotedstr(l_dno)
           +' and ditem='+IntToStr(l_ditem)
           +' and qty>0';
    if not QueryExists(tmpSQL, isExist) then
       Exit;

    if not isExist then
    begin
      ShowMsg('三廣、勝宏、方正客戶無COC批號不允許拋轉,請確認后重試!',16);
      Exit;
    end;

    //方正必須有二維碼
    if Pos(CDS1.FieldByName('custno').AsString,g_FZ)>0 then
    begin
      tmpSQL:='select top 1 bu from dli041'
             +' where bu='+Quotedstr(g_UInfo^.BU)
             +' and dno='+Quotedstr(l_dno)
             +' and ditem='+IntToStr(l_ditem);
      if not QueryExists(tmpSQL, isExist) then
         Exit;

      if not isExist then
      begin
        ShowMsg('方正客戶無COC二維碼不允許拋轉,請確認后重試!',16);
        Exit;
      end;
    end;
  end;

  if ShowMsg('拋轉成功后將刪除舊資料,確定拋轉嗎?',33)=IDCancel then
     Exit;

  tmpFilter:=' where bu='+Quotedstr(l_bu)
            +' and dno='+Quotedstr(CDS1.FieldByName('dno').AsString)
            +' and ditem='+IntToStr(CDS1.FieldByName('ditem').AsInteger);
  tmpSQL:='select top 1 bu from dli010 '+tmpFilter
         +' and isnull(garbageflag,0)=0';

  if not QueryOneCR(tmpSQL, Data) then
     Exit;

  if Length(VarToStr(Data))=0 then
  begin
    ShowMsg('單據不存在,請確認是否已作廢!',48);
    Exit;
  end;

  tmpArea:='stkplace,stkarea';
  tmpM1:=UpperCase(Copy(CDS1.FieldByName('pno').AsString,1,1));
  if SameText(l_bu, 'ITEQGZ') then
  begin
    if Pos(tmpM1,'ETH')>0 then
    begin
      //內銷
      if tmpM1='T' then
         tmpArea:='''D3A18'',''JD01-00001'''
      else
         tmpArea:='''D3A17'',''JD01-00001''';
    end else
    begin
      //內銷
      if (tmpM1='B') or (tmpM1='M') then
         tmpArea:='''D3A18'',''JD02-00001'''
      else
         tmpArea:='''D3A17'',''JD02-00001''';
    end;
  end else
  begin
    if Pos(tmpM1,'ETH')>0 then
    begin
      //內銷
      if tmpM1='T' then
         tmpArea:='''N3A18'',''DG01-00001'''
      else
         tmpArea:='''D3A17'',''DG01-00001''';
    end else
    begin
      //內銷
      if (tmpM1='B') or (tmpM1='M') then
         tmpArea:='''N3A18'',''DG02-00001'''
      else
         tmpArea:='''D3A17'',''DG02-00001''';
    end;
  end;
  {(*}
  tmpSQL:='declare @sno int set @sno=0'
         +' delete from dli020 '+tmpFilter
         +' insert into dli020(bu,dno,ditem,sno,stkplace,stkarea,manfac,manfac1,qty,sflag,jflag,jremark)'
         +' select '+Quotedstr(l_bu)+','+Quotedstr(CDS1.FieldByName('dno').AsString)
         +','+IntToStr(CDS1.FieldByName('ditem').AsInteger)
         +',sno+@sno,'+tmpArea+',manfac,manfac1,qty,sflag,jflag,jremark from dli020'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and dno='+Quotedstr(l_dno)
         +' and ditem='+IntToStr(l_ditem)
         +' exec [dbo].[proc_UpdateDelcount] '+Quotedstr(l_bu)+','
         +Quotedstr(CDS1.FieldByName('dno').AsString)+','+IntToStr(CDS1.FieldByName('ditem').AsInteger);
  {*)}
  qRet2:=PostBySQL(tmpSQL);
  GetCDS2;
  if qRet2 then
  begin
    //這些客戶同時拋轉COC批號
    if Pos(CDS1.FieldByName('custno').AsString,g_strSG+'/'+g_strCD+'/'+g_strSH+'/'+g_FZ)>0 then
    begin
      Data:=null;
      tmpSQL:='declare @sno int set @sno=0'
             +' if not exists(select 1 from dli040'
             +' where bu='+Quotedstr(g_UInfo^.BU)
             +' and dno='+Quotedstr(l_dno)
             +' and ditem='+IntToStr(l_ditem)+')'
             +' begin select 0 as flag return end'
             +' delete from dli040 '+tmpFilter
             +' insert into dli040(bu,dno,ditem,sno,Manfac,qty,rc,rf,pg,remark)'
             +' select '+Quotedstr(l_bu)+','+Quotedstr(CDS1.FieldByName('dno').AsString)+','+IntToStr(CDS1.FieldByName('ditem').AsInteger)
             +',sno+@sno,manfac,qty,rc,rf,pg,''go'' as remark from dli040'
             +' where bu='+Quotedstr(g_UInfo^.BU)
             +' and dno='+Quotedstr(l_dno)
             +' and ditem='+IntToStr(l_ditem)
             +' and qty>0'
             +' exec [dbo].[proc_UpdateCoccount] '+Quotedstr(l_bu)+','+Quotedstr(CDS1.FieldByName('dno').AsString)+','+IntToStr(CDS1.FieldByName('ditem').AsInteger)
             +' select 1 as flag';
      if not QueryOneCR(tmpSQL, Data) then
      begin
        ShowMsg('資料批號拋轉成功,但COC批號拋轉失敗,請重試!',16);
        Exit;
      end;

      if VarToStr(Data)='0' then
      begin
        ShowMsg('資料批號拋轉成功,但無COC批號,請確認后重試!',16);
        Exit;
      end;

      //方正同時拋轉二維碼
      if Pos(CDS1.FieldByName('custno').AsString,g_FZ)>0 then
      begin
        Data:=null;
        tmpSQL:='declare @sno int set @sno=0'
               +' if not exists(select 1 from dli041'
               +' where bu='+Quotedstr(g_UInfo^.BU)
               +' and dno='+Quotedstr(l_dno)
               +' and ditem='+IntToStr(l_ditem)+')'
               +' begin select 0 as flag return end'
               +' delete from dli041 '+tmpFilter
               +' insert into dli041(bu,dno,ditem,sno,qrcode,fname1,fname2,fname3,fname4,'
               +' fname5,fname6,fname7,fname8,fname9,fname10,fname11,fname12,fname13,fname14,'
               +' fname15,fname16,fname17,fname18,fname19,fname20)'
               +' select '+Quotedstr(l_bu)+','+Quotedstr(CDS1.FieldByName('dno').AsString)+','+IntToStr(CDS1.FieldByName('ditem').AsInteger)
               +',sno+@sno,qrcode,fname1,fname2,fname3,fname4,fname5,fname6,fname7,'
               +' fname8,fname9,fname10,fname11,fname12,fname13,fname14,fname15,fname16,'
               +' fname17,fname18,fname19,fname20 from dli041'
               +' where bu='+Quotedstr(g_UInfo^.BU)
               +' and dno='+Quotedstr(l_dno)
               +' and ditem='+IntToStr(l_ditem)
               +' select 1 as flag';
        if not QueryOneCR(tmpSQL, Data) then
        begin
          ShowMsg('資料批號拋轉成功,但COC二維碼拋轉失敗,請重試!',16);
          Exit;
        end;

        if VarToStr(Data)='0' then
        begin
          ShowMsg('資料批號拋轉成功,但無COC二維碼,請確認后重試!',16);
          Exit;
        end;
      end;
    end;

    ShowMsg('拋轉完畢!',64);
  end;
end;

procedure TFrmDLII020_lotgo.CDS1AfterScroll(DataSet: TDataSet);
begin
  inherited;
  GetCDS2;
end;

procedure TFrmDLII020_lotgo.Timer1Timer(Sender: TObject);
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
