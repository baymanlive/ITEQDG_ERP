{*******************************************************}
{                                                       }
{                unDLII010                              }
{                Author: kaikai                         }
{                Create date: 2015/5/28                 }
{                Description: 出貨表                    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, Menus, ImgList,
  StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin, 
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII010 = class(TFrmSTDI031)
    OpenDialog1: TOpenDialog;
    btn_dlii010A: TToolButton;
    btn_dlii010B: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_dlii010AClick(Sender: TObject);
    procedure btn_dlii010BClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
  private
    l_StrIndex,l_StrIndexDesc:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII010: TFrmDLII010;

implementation

uses unGlobal, unCommon, ComObj;

{$R *.dfm}

procedure TFrmDLII010.SetToolBar;
begin
  btn_DLII010A.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  btn_DLII010B.Enabled:=btn_DLII010A.Enabled;
  inherited;
end;

procedure TFrmDLII010.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From Dli010 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' And IsNull(GarbageFlag,0)=0 And Indate<=(Select Max(Indate)'
         +' From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)+')';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII010.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='Dli010';
  p_GridDesignAns:=True;
  btn_dlii010A.Visible:=g_MInfo^.R_edit;
  btn_dlii010B.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_quit.Left:=btn_dlii010B.Left+btn_dlii010B.Width;

  inherited;
end;

procedure TFrmDLII010.btn_dlii010AClick(Sender: TObject);
const MaxCnt=30;
var
  isCoc:Boolean;
  tmpCnt:Integer;
  IsFind:Boolean;
  i,j,tmpDitem,MsgFlag:Integer;
  tmpStr,tmpDno,tmpDate:string;
  tmpList:TStrings;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  inherited;
  //此dg帳號匯入資料只在coc作業顯示,條件:QtyColor=g_CocData
  //ID130251胡美香,ID140622張勝德
  isCoc:=SameText(g_UInfo^.BU, 'ITEQDG') and (SameText(g_UInfo^.UserId, 'ID130251') or SameText(g_UInfo^.UserId, 'ID140622'));
  if not isCoc then
  begin
    if SameText(g_UInfo^.BU, 'ITEQDG') then
    begin
      ShowMsg('DG出貨表請使用出貨排程作業!', 48);
      Exit;
    end;

    //檢查當天出貨資料是否存在
    tmpStr:='Select Top 1 1 From Dli010 Where Bu='+Quotedstr(g_Uinfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(Date+1))
           +' And IsNull(GarbageFlag,0)=0';
    if not QueryExists(tmpStr, IsFind) then
       Exit;

    MsgFlag:=-1;
    tmpCnt:=MaxInt;
    if IsFind then
    begin
      //檢查是否已做備貨、COC
      tmpStr:='Select Top 1 1 From Dli010 A Inner Join Dli020 B'
             +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
             +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
             +' And IsNull(GarbageFlag,0)=0 And A.Indate='+Quotedstr(DateToStr(Date+1))
             +' Union'
             +' Select Top 1 1 From Dli010 A Inner Join Dli040 B'
             +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
             +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
             +' And IsNull(GarbageFlag,0)=0 And A.Indate='+Quotedstr(DateToStr(Date+1));
      if not QueryExists(tmpStr, IsFind) then
         Exit;

      if IsFind then
      begin
        tmpCnt:=MaxCnt;
        if ShowMsg('['+DateToStr(Date+1)+']出貨表已備貨或者已做COC,'
                  +'將以插單的形式最多允許匯入'+IntToStr(MaxCnt)+'筆!'+#13#10
                  +'按[確定]將繼續執行'+#13#10
                  +'按[取消]將取消匯入', 33)=IDCancel then
           Exit;
      end else
      begin
        MsgFlag:=ShowMsg('['+DateToStr(Date+1)+']出貨表已經存在,請選擇按扭操作?'+#13#10
                  +'按[是]將刪除當天出貨資料'+#13#10
                  +'按[否]將保留當天出貨資料'+#13#10
                  +'按[取消]將取消匯入', 35);
        if MsgFlag=IdCancel then
           Exit;
      end;
    end;

    if not OpenDialog1.Execute then
       Exit;

    if MsgFlag=IdYes then
    begin
      tmpStr:=' Delete From Dli010 Where Bu='+Quotedstr(g_Uinfo^.BU)
             +' And Indate='+Quotedstr(DateToStr(Date+1));
      if not PostBySQL(tmpStr) then
         Exit;
    end;
  end else
  begin
    tmpDate:=DateToStr(Date);
    if not InputQuery(CheckLang('請輸入日期'), 'date', tmpDate) then
       Exit;
    tmpDate:=Trim(tmpDate);
    if tmpDate = '' then
       Exit;
    try
      StrToDate(tmpDate);
    except
      ShowMsg('日期格式錯誤!',48);
      Exit;
    end;
    tmpStr:='Select Top 1 1 From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(tmpDate);
    if not QueryExists(tmpStr, IsFind) then
       Exit;

    if not IsFind then
    begin
      ShowMsg('此日期出貨表未確認,不可匯入!',48);
      Exit;
    end;

    tmpCnt:=MaxInt;
    if not OpenDialog1.Execute then
       Exit;
  end;

  with DBGridEh1 do
  for i:=0 to Columns.Count -1 do
    CDS.FieldByName(Columns[i].FieldName).DisplayLabel:=Columns[i].Title.Caption;

  tmpList:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    tmpDitem:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to tmpDitem do
    begin
      IsFind:=False;
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);

      if tmpStr<>'' then
      for j:=0 to CDS.FieldCount-1 do
      if (CDS.Fields[j].DisplayLabel=tmpStr) and
         (not SameText(CDS.Fields[j].FieldName,'Delcount')) then
      begin
        tmpList.Add(IntToStr(j));
        IsFind:=True;
        Break;
      end;

      if not IsFind then
         tmpList.Add('-1');
    end;
    
    if tmpList.Count=0 then
    begin
      ShowMsg('Excel無欄位,請檢查Excel檔案第一行的欄位名稱是否正確!', 48);
      Exit;
    end;

    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible:=True;
    tmpCDS.Data:=CDS.Data;
    tmpCDS.EmptyDataSet;
    tmpDitem:=1; i:=2;
    tmpDno:=GetSno(g_MInfo^.ProcId);
    while i<>0 do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;

      if tmpCnt<=0 then
      begin
        ShowMsg('Excel資料筆數超出'+IntToStr(MaxCnt)+'筆!', 48);
        Exit;
      end;

      tmpCDS.Append;
      for j:=0 to tmpList.Count-1 do
        if tmpList.Strings[j]<>'-1' then
           tmpCDS.Fields[StrToInt(tmpList.Strings[j])].Value:=ExcelApp.Cells[i,j+1].Value;
      tmpCDS.FieldByName('Bu').AsString:=g_Uinfo^.BU;
      if isCoc then
      begin
        tmpCDS.FieldByName('Indate').AsDateTime:=StrToDate(tmpDate);
        tmpCDS.FieldByName('InsFlag').AsBoolean:=True;
        tmpCDS.FieldByName('QtyColor').AsInteger:=g_CocData;
        tmpCDS.FieldByName('Sno').AsInteger:=0;
      end else
      begin
        tmpCDS.FieldByName('Indate').AsDateTime:=Date+1;
        tmpCDS.FieldByName('InsFlag').AsBoolean:=False;
        tmpCDS.FieldByName('QtyColor').AsInteger:=0;
        tmpCDS.FieldByName('Sno').AsInteger:=tmpDitem;
        tmpCDS.FieldByName('Coccount').AsFloat:=0;
        tmpCDS.FieldByName('Coccount1').AsFloat:=0;
      end;
      tmpCDS.FieldByName('Iuser').AsString:=g_Uinfo^.UserId;
      tmpCDS.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS.FieldByName('Check_ans').AsBoolean:=False;
      tmpCDS.FieldByName('BingBao_ans').AsBoolean:=False;
      tmpCDS.FieldByName('COC_ans').AsBoolean:=False;
      tmpCDS.FieldByName('Coc_err').AsBoolean:=False;
      tmpCDS.FieldByName('Prn_ans').AsBoolean:=False;
      tmpCDS.FieldByName('Coc_err').AsBoolean:=False;
      tmpCDS.FieldByName('Dno').AsString:=tmpDno;
      tmpCDS.FieldByName('Ditem').AsInteger:=tmpDitem;
      tmpCDS.FieldByName('Delcount').AsFloat:=0;
      tmpCDS.FieldByName('Delcount1').AsFloat:=0;
      tmpCDS.FieldByName('Jcount_old').AsFloat:=0;
      tmpCDS.FieldByName('Jcount_new').AsFloat:=0;
      tmpCDS.FieldByName('Bcount').AsFloat:=0;
      tmpCDS.FieldByName('Ordercount').AsFloat:=0;
      tmpCDS.FieldByName('SourceDitem').AsInteger:=0;
      tmpCDS.FieldByName('GarbageFlag').AsBoolean:=False;
      tmpCDS.FieldByName('Chkcount').AsFloat:=0;
      tmpCDS.FieldByName('Notcount1').AsFloat:=tmpCDS.FieldByName('Notcount').AsFloat;
      tmpCDS.Post;
      Inc(tmpDitem); Inc(i); Dec(tmpCnt);

      //下一列全為空值,退出
      for j:=0 to tmpList.Count-1 do
      if VarToStr(ExcelApp.Cells[i,j+1].Value)<>'' then
         Break;
      if j>=tmpList.Count then
         i:=0;
    end;

    if CDSPost(tmpCDS, p_TableName) then
    begin
      if not isCoc then
      begin
        tmpStr:=Quotedstr(DateToStr(Date+1));
        tmpStr:='if not exists(select 1 from mps320'
               +' where bu='+Quotedstr(g_UInfo^.BU)
               +' and indate='+tmpStr+')'
               +' insert into mps320(bu,indate)'
               +' values('+Quotedstr(g_UInfo^.BU)+','+tmpStr+')';
        if not PostBySQL(tmpStr) then
           ShowMsg('確認出貨日期失敗,請聯絡管理員!', 48);
      end;
      CDS.Data:=tmpCDS.Data;
    end;
  finally
    g_ProgressBar.Visible:=False;
    tmpList.Free;
    tmpCDS.Free;
    ExcelApp.Quit;
  end;
end;

procedure TFrmDLII010.btn_dlii010BClick(Sender: TObject);
var
  isCoc:Boolean;
  tmpStr,tmpDate:string;
begin
  inherited;
  //ID130251胡美香,ID140622張勝德
  isCoc:=SameText(g_UInfo^.BU, 'ITEQDG') and (SameText(g_UInfo^.UserId, 'ID130251') or SameText(g_UInfo^.UserId, 'ID140622'));
  if not isCoc then
  begin
    ShowMsg('你沒有權限進行此操作!',48);
    Exit;
  end;

  tmpDate:=DateToStr(Date);
  if not InputQuery(CheckLang('請輸入日期'), 'date', tmpDate) then
     Exit;
  tmpDate:=Trim(tmpDate);
  if tmpDate = '' then
     Exit;
  try
    StrToDate(tmpDate);
  except
    ShowMsg('日期格式錯誤!',48);
    Exit;
  end;

  tmpStr:=' declare @t table(X varchar(6),Y varchar(11),Z int)'
         +' insert into @t'
         +' select B.bu,B.dno,B.ditem from dli010 A inner join dli040 B'
         +' on A.bu=B.bu and A.dno=B.dno and A.ditem=B.ditem'
         +' where A.bu='+Quotedstr(g_UInfo^.BU)
         +' and A.indate='+Quotedstr(tmpDate)
         +' and A.qtycolor='+IntToStr(g_CocData)
         +' if exists(select 1 from @t)'
         +'    delete dli040 from dli040,@t where bu=X and dno=Y and ditem=Z'
         +' delete from dli010 where bu='+Quotedstr(g_UInfo^.BU)
         +' and indate='+Quotedstr(tmpDate)
         +' and qtycolor='+IntToStr(g_CocData);
  if PostBySQL(tmpStr) then
     ShowMsg('刪除完畢!',64);
end;

procedure TFrmDLII010.CDSBeforeInsert(DataSet: TDataSet);
begin
//  inherited;
  Abort;
end;

procedure TFrmDLII010.CDSBeforeDelete(DataSet: TDataSet);
begin
//  inherited;
  Abort;
end;

procedure TFrmDLII010.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    ShowMsg('DG出貨表請使用出貨排程作業!', 48);
    Abort;
  end;
end;

procedure TFrmDLII010.CDSBeforePost(DataSet: TDataSet);
begin
  inherited;

  CDS.FieldByName('Notcount1').AsFloat:=CDS.FieldByName('Notcount').AsFloat;
end;

procedure TFrmDLII010.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=CDS.Data;
  ArrPrintData[0].RecNo:=CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:='Ditem';
  ArrPrintData[0].Filter:='Dno='+Quotedstr(CDS.FieldByName('Dno').AsString);
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmDLII010.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
//  inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    if Pos('Qry_ppccl', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
    if Pos('Qry_isbz', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate>='+Quotedstr(DateToStr(Date));
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLII010.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
     Exit;
  if  SameText(Column.FieldName,'Delcount') and
     (CDS.FieldByName('Delcount').AsFloat<>0) then
     Background:=clMoneyGreen;
  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then  //拆單
     AFont.Color:=clBlue;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
     AFont.Color:=clRed;
  if CDS.FieldByName('QtyColor').AsInteger=g_CocData then        //插單:COC資料
     AFont.Color:=clGray;
end;

procedure TFrmDLII010.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

end.
