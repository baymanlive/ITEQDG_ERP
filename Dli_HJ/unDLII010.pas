{*******************************************************}
{                                                       }
{                unDLII010                              }
{                Author: kaikai                         }
{                Create date: 2018/9/4                  }
{                Description: HJ出貨表                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII010 = class(TFrmSTDI031)
    OpenDialog1: TOpenDialog;
    btn_dlii010A: TToolButton;
    btn_dlii010B: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_dlii010AClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_dlii010BClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
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
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII010.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='Dli010';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('【更新】庫存量、客戶編號');
  btn_dlii010A.Visible:=g_MInfo^.R_edit;
  btn_dlii010B.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_quit.Left:=btn_dlii010B.Left+btn_dlii010B.Width;

  inherited;
end;

procedure TFrmDLII010.btn_dlii010AClick(Sender: TObject);
const MaxCnt=30;
var
  tmpCnt:Integer;
  IsFind:Boolean;
  i,j,tmpDitem,MsgFlag:Integer;
  tmpStr,tmpDno:string;
  tmpList:TStrings;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  inherited;
  //檢查當天出貨資料是否存在
  tmpStr:='Select Top 1 1 From Dli010 Where Bu='+Quotedstr(g_Uinfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(Date))
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
           +' And IsNull(GarbageFlag,0)=0 And A.Indate='+Quotedstr(DateToStr(Date))
           +' Union'
           +' Select Top 1 1 From Dli010 A Inner Join Dli040 B'
           +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
           +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
           +' And IsNull(GarbageFlag,0)=0 And A.Indate='+Quotedstr(DateToStr(Date));
    if not QueryExists(tmpStr, IsFind) then
       Exit;

    if IsFind then
    begin
      tmpCnt:=MaxCnt;
      if ShowMsg('['+DateToStr(Date)+']出貨表已備貨或者已做COC,'
                +'將以插單的形式最多允許匯入'+IntToStr(MaxCnt)+'筆!'+#13#10
                +'按[確定]將繼續執行'+#13#10
                +'按[取消]將取消匯入', 33)=IDCancel then
         Exit;
    end else
    begin
      MsgFlag:=ShowMsg('['+DateToStr(Date)+']出貨表已經存在,請選擇按扭操作?'+#13#10
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
           +' And Indate='+Quotedstr(DateToStr(Date));
    if not PostBySQL(tmpStr) then
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
      for j:=0 to tmpCDS.FieldCount-1 do
        if tmpCDS.Fields[j].DataType=ftBoolean then
           tmpCDS.Fields[j].AsBoolean:=False
        else if tmpCDS.Fields[j].DataType in [ftInteger,ftSmallint] then
           tmpCDS.Fields[j].AsInteger:=0
        else if tmpCDS.Fields[j].DataType in [ftFloat, ftCurrency, ftBCD] then
           tmpCDS.Fields[j].AsFloat:=0;
      for j:=0 to tmpList.Count-1 do
        if tmpList.Strings[j]<>'-1' then
           tmpCDS.Fields[StrToInt(tmpList.Strings[j])].Value:=ExcelApp.Cells[i,j+1].Value;
      tmpCDS.FieldByName('Bu').AsString:=g_Uinfo^.BU;
      tmpCDS.FieldByName('Dno').AsString:=tmpDno;
      tmpCDS.FieldByName('Ditem').AsInteger:=tmpDitem;
      tmpCDS.FieldByName('Indate').AsDateTime:=Date;
      tmpCDS.FieldByName('Sno').AsInteger:=tmpDitem;
      tmpCDS.FieldByName('Iuser').AsString:=g_Uinfo^.UserId;
      tmpCDS.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS.FieldByName('SaleItem').Clear;
      tmpCDS.FieldByName('SourceDitem').Clear;
      tmpCDS.FieldByName('Notcount1').AsFloat:=tmpCDS.FieldByName('Notcount').AsFloat;
      tmpCDS.Post;
      if Length(Trim(tmpCDS.FieldByName('Orderno').AsString))=0 then
         tmpCDS.Delete
      else begin
        Inc(tmpDitem);
        Dec(tmpCnt);
      end;
      
      Inc(i);

      //下一列全為空值,退出
      for j:=0 to tmpList.Count-1 do
      if VarToStr(ExcelApp.Cells[i,j+1].Value)<>'' then
         Break;
      if j>=tmpList.Count then
         i:=0;
    end;

    if CDSPost(tmpCDS, p_TableName) then
    begin
      tmpStr:=Quotedstr(DateToStr(Date));
      tmpStr:='if not exists(select 1 from mps320'
             +' where bu='+Quotedstr(g_UInfo^.BU)
             +' and indate='+tmpStr+')'
             +' insert into mps320(bu,indate)'
             +' values('+Quotedstr(g_UInfo^.BU)+','+tmpStr+')';
      if not PostBySQL(tmpStr) then
         ShowMsg('確認出貨日期失敗,請聯絡管理員!', 48);
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
const nostr='nothing';
var
  tmpCRecNo,tmpBRecNo,tmpERecNo:Integer;   //當前、開始、結束
  qty1,qty2:Double;
  Data:OleVariant;
  tmpSQL,tmpImg01X,tmpImg01Y,tmpOea01:string;
  tmpStr:WideString;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  dsNE1,dsNE2,dsNE3,dsNE4,dsNE5:TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!',48);
    Exit;
  end;

  tmpStr:=DBGridEh1.FieldColumns['stkremark'].Title.Caption;
  if (Pos(g_Asc, tmpStr)>0) or (Pos(g_Desc, tmpStr)>0) then
  begin
    ShowMsg('請取消[庫存量]欄位排序標記,再執行此操作!',48);
    Exit;
  end;

  tmpCRecNo:=CDS.RecNo;
  case ShowMsg('更新全部請按[是]'+#13#10
              +'更新當前這筆請按[否]'+#13#10
              +'無操作請按[取消]',35) of
    IdNo: tmpCRecNo:=0;
    IdCancel: Exit;
  end;

  dsNE1:=CDS.BeforeEdit;
  dsNE2:=CDS.AfterEdit;
  dsNE3:=CDS.BeforePost;
  dsNE4:=CDS.AfterPost;
  dsNE5:=CDS.AfterScroll;
  CDS.BeforeEdit:=nil;
  CDS.AfterEdit:=nil;
  CDS.BeforePost:=nil;
  CDS.AfterPost:=nil;
  CDS.AfterScroll:=nil;
  CDS.DisableControls;
  if tmpCRecNo<>0 then
     CDS.First;
  DBGridEh1.Enabled:=False;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    while True do
    begin
      tmpImg01X:='';
      tmpImg01Y:='';
      tmpOea01:='';
      tmpCDS1.Active:=False;
      tmpCDS2.Active:=False;
      tmpCDS3.Active:=False;
      tmpBRecNo:=CDS.RecNo;
      tmpERecNo:=tmpBRecNo;

      if tmpCRecNo=0 then
      begin
        tmpSQL:=Copy(CDS.FieldByName('pno').AsString,1,1);
        if SameText(tmpSQL,'C') then     //鋁基板
           tmpImg01X:=Quotedstr(CDS.FieldByName('pno').AsString)
        else if SameText(tmpSQL,'A') or SameText(tmpSQL,'U') then //M/L
           tmpImg01Y:='img01 like '+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-4)+'%')
        else if SameText(tmpSQL,'E') then //出國外M/L
           tmpImg01Y:='img01='+Quotedstr(CDS.FieldByName('pno').AsString)
        else
           tmpImg01Y:='img01 like '+Quotedstr(nostr+'%');

        if Length(Trim(CDS.FieldByName('orderno').AsString))>0 then
           tmpOea01:=Quotedstr(CDS.FieldByName('orderno').AsString)
        else
           tmpOea01:=Quotedstr(nostr);
      end else
      begin
        while not CDS.Eof do
        begin
          tmpSQL:=Copy(CDS.FieldByName('pno').AsString,1,1);
          if SameText(tmpSQL,'C') then
          begin
            if Pos(CDS.FieldByName('pno').AsString, tmpImg01X)=0 then
               tmpImg01X:=tmpImg01X+','+Quotedstr(CDS.FieldByName('pno').AsString);
          end
          else if SameText(tmpSQL,'E') then
          begin
            if Pos(CDS.FieldByName('pno').AsString, tmpImg01Y)=0 then
               tmpImg01Y:=tmpImg01Y+' or img01='+Quotedstr(CDS.FieldByName('pno').AsString);
          end
          else if SameText(tmpSQL,'A') or SameText(tmpSQL,'U') then
          begin
            tmpSQL:=Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-4);
            if Pos(tmpSQL, tmpImg01Y)=0 then
               tmpImg01Y:=tmpImg01Y+' or img01 like '+Quotedstr(tmpSQL+'%');
          end;

          if (Length(Trim(CDS.FieldByName('orderno').AsString))>0) and
             (Pos(CDS.FieldByName('orderno').AsString, tmpOea01)=0) then
             tmpOea01:=tmpOea01+','+Quotedstr(CDS.FieldByName('orderno').AsString);

          tmpERecNo:=CDS.RecNo;
          if (tmpERecNo mod 50)=0 then  //每次取50筆料號查詢庫存
             Break;
          CDS.Next;
        end;

        if Length(tmpOea01)>0 then
           Delete(tmpOea01,1,1);
        if Length(tmpImg01X)>0 then
           Delete(tmpImg01X,1,1);
        if Length(tmpImg01Y)>0 then
           Delete(tmpImg01Y,1,4);
      end;

      g_StatusBar.Panels[0].Text:='正在處理'+inttostr(tmpBRecNo)+'...'+inttostr(tmpERecNo)+'筆';
      Application.ProcessMessages;
      Data:=null;
      if Length(tmpImg01X)>0 then
      begin
        tmpSQL:='select img01,img02,sum(img10) img10'
               +' from img_file where img01 in ('+tmpImg01X+')'
               +' And img02 in (''N5A00'',''Y5A00'',''N5BT0'',''Y5BT0'')'
               +' and img10>0 group by img01,img02';
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          if CDS.ChangeCount>0 then
             CDS.CancelUpdates;
          Exit;
        end;
        tmpCDS1.Data:=Data;
      end;

      if Length(tmpImg01Y)>0 then
      begin
        tmpSQL:='select img01,img02,sum(img10) img10'
               +' from (select substr(img01,1,length(img01)-4) as img01,img02,img10'
               +' from img_file where ('+tmpImg01Y+') and img10>0'
               +' And img02 in (''N4A00'',''N4A07'',''Y4A07'',''N4BT0'',''Y4BT0'')) X'
               +' group by img01,img02';
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          if CDS.ChangeCount>0 then
             CDS.CancelUpdates;
          Exit;
        end;
        tmpCDS2.Data:=Data;
      end;

      if Length(tmpOea01)>0 then
      begin
        tmpSQL:='select oea01,oea04 from oea_file'
               +' where oea01 in ('+tmpOea01+') and oeaconf=''Y''';
        if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          if CDS.ChangeCount>0 then
             CDS.CancelUpdates;
          Exit;
        end;
        tmpCDS3.Data:=Data;
      end;

      CDS.RecNo:=tmpBRecNo;
      while (tmpCRecNo=0) or ((CDS.RecNo<=tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1:=0;
        qty2:=0;
        if SameText(Copy(CDS.FieldByName('pno').AsString,1,1),'C') then //鋁基板
        begin
          with tmpCDS1 do
          begin
            if Active then
            begin
              Filtered:=False;
              Filter:='img01='+Quotedstr(CDS.FieldByName('pno').AsString);
              Filtered:=True;
              while not Eof do
              begin
                if Pos(Fields[1].AsString, 'N5A00,Y5A00')>0 then          //正常品倉
                   qty1:=qty1+Fields[2].AsFloat
                else if Pos(Fields[1].AsString, 'N5BT0,Y5BT0')>0 then
                   qty2:=qty2+Fields[2].AsFloat;                          //零成本倉
                Next;
              end;
            end;
          end;
        end else  //M/L
        begin
          with tmpCDS2 do
          begin
            if Active then
            begin
              Filtered:=False;
              Filter:='img01='+Quotedstr(Copy(CDS.FieldByName('pno').AsString,1,Length(CDS.FieldByName('pno').AsString)-4));
              Filtered:=True;
              while not Eof do
              begin
                if Pos(Fields[1].AsString, 'N4A00,N4A07,Y4A07')>0 then    //正常品倉
                   qty1:=qty1+Fields[2].AsFloat
                else if Pos(Fields[1].AsString, 'N4BT0,Y4BT0')>0 then
                   qty2:=qty2+Fields[2].AsFloat;                          //零成本倉
                Next;
              end;
            end;
          end;
        end;

        CDS.Edit;
        CDS.FieldByName('stkremark').AsString:=FloatToStr(qty1)+'/'+FloatToStr(qty2);
        if tmpCDS3.Active and tmpCDS3.Locate('oea01',CDS.FieldByName('orderno').AsString,[]) then
           CDS.FieldByName('custno').AsString:=tmpCDS3.Fields[1].AsString;
        CDS.Post;

        if tmpCRecNo=0 then
           Break;
        CDS.Next;
      end;

      //退出while true
      if CDS.Eof or (tmpCRecNo=0) then
         Break;
    end;

    if not PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno,Ditem') then
       CDS.CancelUpdates
    else
       ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDS3);
    if tmpCRecNo<>0 then
       CDS.RecNo:=tmpCRecNo;
    CDS.BeforeEdit:=dsNE1;
    CDS.AfterEdit:=dsNE2;
    CDS.BeforePost:=dsNE3;
    CDS.AfterPost:=dsNE4;
    CDS.AfterScroll:=dsNE5;
    CDS.EnableControls;
    DBGridEh1.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
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
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate>='+Quotedstr(DateToStr(Date));
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmDLII010.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmDLII010.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
     Exit;
  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then  //拆單
     AFont.Color:=clBlue;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
     AFont.Color:=clRed;
end;

end.
