unit unDLIT803;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, DB, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh;

type
  TFrmDLIT803 = class(TFrmSTDI080)
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    OpenDialog1: TOpenDialog;
    DS: TDataSource;
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    procedure SetSBarsX;
    function CheckValue(xName, xValue:string):string;
    function CheckPlace(xPno,xPlace:string):string;
  public
    { Public declarations }
  end;

var
  FrmDLIT803: TFrmDLIT803;

implementation

uses unGlobal, unCommon, ComObj, unDLIT803_showret;

{$R *.dfm}

procedure TFrmDLIT803.SetSBarsX;
begin
  if CDS.Active then
  begin
    if CDS.IsEmpty or (CDS.RecNo=-1) then
       Edit1.Text:='0'
    else
       Edit1.Text:=IntToStr(CDS.RecNo);
    Edit2.Text:=IntToStr(CDS.RecordCount);
  end else
  begin
    Edit1.Text:='0';
    Edit2.Text:='0';
  end;
end;

function TFrmDLIT803.CheckValue(xName, xValue:string):string;
begin
  Result:='';

  if SameText(xName,'purno') then
  begin
    if (Length(xValue)<>10) or (Copy(xValue,4,1)<>'-') then
    begin
      Result:='採購單號錯誤';
      Exit;
    end;

    if Pos(Copy(xValue,1,3),'P1Z,323,327,32E')=0 then
    begin
      Result:='單別錯誤,只允許:P1Z,323,327,32E';
      Exit;
    end;
  end else
  if SameText(xName,'pursno') then
  begin
    if StrToIntDef(xValue,0)<=0 then
    begin
      Result:='採購單項次錯誤';
      Exit;
    end;
  end else
  if SameText(xName,'pno') then
  begin
    if Length(xValue)<10 then
    begin
      Result:='料號錯誤';
      Exit;
    end;
  end else
  if SameText(xName,'lot') then
  begin
    if Length(xValue)<9 then
    begin
      Result:='批號錯誤,最小9碼';
      Exit;
    end;
  end else
  if SameText(xName,'qty') then
  begin
    if StrToFloatDef(xValue,0)<=0 then
    begin
      Result:='數量錯誤';
      Exit;
    end;
  end else
  if SameText(xName,'units') then
  begin
    if (xValue<>'RL') and (xValue<>'SH') and (xValue<>'M') and (xValue<>'PN') then
    begin
      Result:='單位錯誤,應為:SH、RL、M、PN';
      Exit;
    end;
  end else
  if SameText(xName,'place') then
  begin
    if Length(xValue)<>5 then
    begin
      Result:='倉庫別錯誤,應為5碼';
      Exit;
    end;
  end else
  if SameText(xName,'area') then
  begin
    if Length(xValue)<>4 then
    begin
      Result:='儲位錯誤,應為4碼';
      Exit;
    end;
  end;
end;

function TFrmDLIT803.CheckPlace(xPno,xPlace:string):string;
var
  fstCode:string;
begin
  Result:='';

  fstCode:=Copy(xPno,1,1);
  if fstCode='E' then
  begin
   if Pos(xPlace,'Y0A0F,D3A17,Y0AM0,Y0AA0')=0 then
    begin
      Result:='倉別錯誤,應為:Y0A0F,D3A17,Y0AM0,Y0AA0';
      Exit;
    end;
  end else
  if fstCode='T' then
  begin
   if Pos(xPlace,'N0A0F,N3A18,N0AM0,N0AA0')=0 then
    begin
      Result:='倉別錯誤,應為:N0A0F,N3A18,N0AM0,N0AA0';
      Exit;
    end;
  end else
  if (fstCode='B') or (fstCode='M') then
  begin
   if Pos(xPlace,'N3A18,N0AM0')=0 then
    begin
      Result:='倉別錯誤,應為:N3A18,N0AM0';
      Exit;
    end;
  end else
  if (fstCode='R') or (fstCode='N') then
  begin
   if Pos(xPlace,'D3A17,Y0AM0')=0 then
    begin
      Result:='倉別錯誤,應為:D3A17,Y0AM0';
      Exit;
    end;
  end else
  if fstCode='P' then
  begin
   if Pos(xPlace,'Y2A10')=0 then
    begin
      Result:='倉別錯誤,應為:Y2A10';
      Exit;
    end;
  end else
  if fstCode='Q' then
  begin
   if Pos(xPlace,'N2A10')=0 then
    begin
      Result:='倉別錯誤,應為:N2A10';
      Exit;
    end;
  end else
  begin
    Result:='料號錯誤,第1碼應為:E,T,B,R,M,N,P,Q';
    Exit;
  end;
end;

procedure TFrmDLIT803.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  SetSBarsX;
end;

procedure TFrmDLIT803.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetSBarsX;
end;

procedure TFrmDLIT803.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  p_TableName:='dli803';

  inherited;
  
  btn_export.Caption:=CheckLang('匯入資料');
  btn_query.Caption:=CheckLang('收貨');
  SetGrdCaption(DBGridEh1, p_TableName);
  btn_print.Visible:=False;
  btn_export.Visible:=True;
  btn_query.Visible:=True;

  tmpSQL:='select * from '+p_TableName+' where 1=2';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmDLIT803.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmDLIT803.btn_exportClick(Sender: TObject);
var
  i,j,row,sno:Integer;
  tmpStr,ret:string;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
begin
  //inherited;
  if not OpenDialog1.Execute then
     Exit;

  for i:=0 to DBGridEh1.Columns.Count-1 do
    DBGridEh1.Columns[i].Tag:=0;

  tmpCDS:=TClientDataSet.Create(nil);
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to sno do
    begin
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);

      if tmpStr<>'' then
      for j:=0 to DBGridEh1.Columns.Count-1 do
      if DBGridEh1.Columns[j].Title.Caption=tmpStr then
      begin
        DBGridEh1.Columns[j].Tag:=i;
        Break;
      end;
    end;

    for j:=0 to DBGridEh1.Columns.Count-1 do
    if DBGridEh1.Columns[j].Tag=0 then
    begin
      ShowMsg('Excel檔案缺少欄位[%s]', 48, DBGridEh1.Columns[j].Title.Caption);
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在匯入Excel資料...');
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible:=True;
    tmpCDS.Data:=CDS.Data;
    tmpCDS.EmptyDataSet;
    row:=2;
    while True do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      //全為空值,退出
      tmpStr:='';
      for i:=1 to sno do
         tmpStr:=tmpStr+Trim(VarToStr(ExcelApp.Cells[row,i].Value));
      if Length(tmpStr)=0 then
         Break;

      tmpCDS.Append;
      for i:=0 to DBGridEh1.Columns.Count-1 do
      begin
        j:=DBGridEh1.Columns[i].Tag;
        tmpStr:=StringReplace(Trim(ExcelApp.Cells[row,j].Value),'''','',[rfReplaceAll]);
        ret:=CheckValue(DBGridEh1.Columns[i].FieldName, tmpStr);
        if Length(ret)>0 then
        begin
          ShowMsg('第'+IntToStr(row)+'筆,'+ret+#13#10+'當前:'+tmpStr,48);
          Exit;
        end;

        tmpCDS.FieldByName(DBGridEh1.Columns[i].FieldName).Value:=tmpStr;
      end;
      tmpCDS.Post;

      ret:=CheckPlace(tmpCDS.FieldByName('pno').AsString,tmpCDS.FieldByName('place').AsString);
      if Length(ret)>0 then
      begin
        ShowMsg('第'+IntToStr(row)+'筆,'+ret+#13#10+'當前:'+tmpCDS.FieldByName('place').AsString,48);
        Exit;
      end;

      Inc(row);
    end;

    if tmpCDS.ChangeCount>0 then
       tmpCDS.MergeChangeLog;
    CDS.Data:=tmpCDS.Data;

  finally
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;

procedure TFrmDLIT803.btn_queryClick(Sender: TObject);
var
  i,sno:Integer;
  per,qty,maxqty,minqty:Double;
  tmpPurno,tmpSQL,tmpSid,tmpRva01,tmpImgFilter,tmpPmhFilter,tmpLotFilter:string;
  tmpPurnoList,tmpRetList:TStrings;
  Data:OleVariant;
  tmpCDS,tmpSrcCDS,tmpSumCDS,pmmCDS,rvaCDS,rvbCDS,imgCDS,pmhCDS:TClientDataSet;
begin
//  inherited;
  if not SameText(g_UInfo^.BU,'ITEQDG') then
  begin
    ShowMsg('此程式只適用東莞廠!',48);
    Exit;
  end;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無資料,請選擇Excel檔匯入資料!',48);
    Exit;
  end;

  if ShowMsg('確定進行收貨嗎?',33)=IdCancel then
     Exit;

  tmpPurnoList:=TStringList.Create;
  tmpRetList:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  tmpSrcCDS:=TClientDataSet.Create(nil);
  tmpSumCDS:=TClientDataSet.Create(nil);
  pmmCDS:=TClientDataSet.Create(nil);
  rvaCDS:=TClientDataSet.Create(nil);
  rvbCDS:=TClientDataSet.Create(nil);
  imgCDS:=TClientDataSet.Create(nil);
  pmhCDS:=TClientDataSet.Create(nil);
  try
    tmpSumCDS.Data:=CDS.Data;
    tmpSumCDS.EmptyDataSet; //加總數量,用于檢查超短交

    tmpSrcCDS.Data:=CDS.Data;
    tmpPurno:='';
    tmpImgFilter:='';
    tmpPmhFilter:='';
    tmpLotFilter:='';
    with tmpSrcCDS do
    begin
      First;
      while not Eof do
      begin
        if Pos(FieldByName('purno').AsString,tmpPurno)=0 then
           tmpPurno:=tmpPurno+','+Quotedstr(FieldByName('purno').AsString);

        tmpSQL:='(img01='+Quotedstr(FieldByName('pno').AsString)
               +' and img02='+Quotedstr(FieldByName('place').AsString)
               +' and img03='+Quotedstr(FieldByName('area').AsString)
               +' and img04='+Quotedstr(FieldByName('lot').AsString)+')';
        if Pos(tmpSQL,tmpImgFilter)=0 then
           tmpImgFilter:=tmpImgFilter+' or '+tmpSQL;

        if Pos(FieldByName('pno').AsString,tmpPmhFilter)=0 then
           tmpPmhFilter:=tmpPmhFilter+' or pmh01='+Quotedstr(FieldByName('pno').AsString);

        if Pos(FieldByName('lot').AsString,tmpLotFilter)=0 then
           tmpLotFilter:=tmpLotFilter+','+Quotedstr(FieldByName('lot').AsString);

        if tmpSumCDS.Locate('purno;pursno',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          tmpSumCDS.Edit;
          tmpSumCDS.FieldByName('qty').AsFloat:=tmpSumCDS.FieldByName('qty').AsFloat+FieldByName('qty').AsFloat;
          tmpSumCDS.Post;
        end else
        begin
          tmpSumCDS.Append;
          tmpSumCDS.FieldByName('purno').AsString:=FieldByName('purno').AsString;
          tmpSumCDS.FieldByName('pursno').AsInteger:=FieldByName('pursno').AsInteger;
          tmpSumCDS.FieldByName('qty').AsFloat:=FieldByName('qty').AsFloat;
          tmpSumCDS.Post;
        end;

        Next;
      end;
    end;

    Delete(tmpPurno,1,1);
    Delete(tmpImgFilter,1,4);
    Delete(tmpPmhFilter,1,4);
    Delete(tmpLotFilter,1,1);

    if tmpSumCDS.ChangeCount>0 then
       tmpSumCDS.MergeChangeLog;

    g_StatusBar.Panels[0].Text:=CheckLang('正在檢查當天收貨批號是否重複...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select rvb38 from '+g_UInfo^.BU+'.rva_file,'+g_UInfo^.BU+'.rvb_file'
           +' where rva01=rvb01 and to_char(rva06,''YYYY-MM-DD'')=to_char(sysdate,''YYYY-MM-DD'')'
           +' and rvb38 in ('+tmpLotFilter+') and rvaconf<>''X''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    begin
      if ShowMsg('當天收貨批號重複,請確認(共'+IntToStr(tmpCDS.RecordCount)+'個重複,其中一個是:'+tmpCDS.Fields[0].AsString+')'+#13#10+'請按[確定]繼續收貨,按[取消]中止操作',33)=IdCancel then
         Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在檢查是否有未確認的收貨單...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select distinct rva01 from '+g_UInfo^.BU+'.rva_file,'+g_UInfo^.BU+'.rvb_file'
           +' where rva01=rvb01 and rvb04 in ('+tmpPurno+') and rvaconf=''N''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then    //一張採購單建立一張收貨單,可以不用連接rvb_file
       Exit;
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    begin
      if not Assigned(FrmDLIT803_showret) then
         FrmDLIT803_showret:=TFrmDLIT803_showret.Create(Application);
      FrmDLIT803_showret.Memo1.Lines.Clear;
      FrmDLIT803_showret.Memo1.Lines.Add(CheckLang('存在未確認的收貨單,請先確認:'));
      while not tmpCDS.Eof do
      begin
        FrmDLIT803_showret.Memo1.Lines.Add(tmpCDS.Fields[0].AsString);
        tmpCDS.Next;
      end;
      FrmDLIT803_showret.ShowModal;
      Exit;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在檢查採購單資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.pmm_file,'+g_UInfo^.BU+'.pmn_file'
           +' where pmm01=pmn01 and pmm01 in ('+tmpPurno+') and pmmacti=''Y''';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmmCDS.Data:=Data;
    if pmmCDS.IsEmpty then
    begin
      ShowMsg('採購單不存在!',48);
      Exit;
    end;

    with tmpSrcCDS do
    begin
      First;
      while not Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('第'+IntToStr(RecNo)+'筆,採購單不存在:'+#13#10+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString,48);
          Exit;
        end;

        if FieldByName('pno').AsString<>pmmCDS.FieldByName('pmn04').AsString then
        begin
          ShowMsg('第'+IntToStr(RecNo)+'筆,與採購單料號不同:'+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
              '採購單:'+pmmCDS.FieldByName('pmn04').AsString+#13#10+
              '當前:'+FieldByName('pno').AsString,48);
          Exit;
        end;

        if FieldByName('units').AsString<>pmmCDS.FieldByName('pmn07').AsString then
        begin
          ShowMsg('第'+IntToStr(RecNo)+'筆,與採購單單位不同:'+
              FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
              '採購單:'+pmmCDS.FieldByName('pmn07').AsString+#13#10+
              '當前:'+FieldByName('units').AsString,48);
          Exit;
        end;

        Next;
      end;
    end;

    //檢查超交、短交
    with tmpSumCDS do
    begin
      First;
      while not Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([FieldByName('purno').AsString,FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('無法定位到採購單:'+FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString,48);
          Exit;
        end;

        per:=pmmCDS.FieldByName('pmn13').AsFloat;  //超短交率
        if per>0 then
        begin
          qty:=FieldByName('qty').AsFloat+pmmCDS.FieldByName('pmn50').AsFloat+pmmCDS.FieldByName('pmn51').AsFloat;  //待交量+已交量+在驗量
          maxqty:=(pmmCDS.FieldByName('pmn20').AsFloat*(100+per))/100;     //最大可交量(pmn20:採購量)
          minqty:=(pmmCDS.FieldByName('pmn20').AsFloat*(100-per))/100;     //最小可交量
          if pmmCDS.FieldByName('pmn14').AsString='Y' then //Y:可部份交貨,只控制超交; N:不可部份交貨,超交與短交都控制
          begin
            if qty>maxqty then
            begin
              ShowMsg('所交貨之數量總計大於允許的交貨數量:'+#13#10+
                  FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
                  '當前交貨:'+FloatToStr(qty)+'>最大可交貨:'+FloatToStr(maxqty),48);
              Exit;
            end;
          end else
          begin
            if (qty>maxqty) or (qty<minqty) then
            begin
              ShowMsg('所交貨之數量總計大於/小于允許的交貨數量:'+#13#10+
                  FieldByName('purno').AsString+'/'+FieldByName('pursno').AsString+#13#10+
                  '當前交貨:'+FloatToStr(qty)+'>最大可交貨:'+FloatToStr(maxqty)+',<最小可交貨:'+FloatToStr(minqty),48);
              Exit;
            end;
          end;
        end;

        Next;
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢庫存資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.img_file where '+tmpImgFilter;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    imgCDS.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢廠商料件資料...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select pmh01,pmh02,pmh08,pmh13 from '+g_UInfo^.BU+'.pmh_file where '+tmpPmhFilter;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmhCDS.Data:=Data;

    g_StatusBar.Panels[0].Text:=CheckLang('正在獲取收貨單資料表結構...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from rva_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    rvaCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from rvb_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    rvbCDS.Data:=Data;

    //開始建單,一張採購單建立一張收貨單
    tmpPurnoList.DelimitedText:=StringReplace(tmpPurno,'''','',[rfReplaceAll]);
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpPurnoList.Count;
    g_ProgressBar.Visible:=True;
    for i:=0 to tmpPurnoList.Count-1 do
    begin
      tmpPurno:=tmpPurnoList.Strings[i];
      if not pmmCDS.Locate('pmn01',tmpPurno,[]) then
      begin
        ShowMsg('無法定位到採購單:'+tmpPurno,48);
        Exit;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('正在處理採購單:'+tmpPurno);
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      rvaCDS.Append;
      rvaCDS.FieldByName('rva01').AsString:=IntToStr(i);                            //收貨單號(后面統一更新)
      rvaCDS.FieldByName('rva02').AsString:=tmpPurno;                               //採購單號
      rvaCDS.FieldByName('rva04').AsString:='N';                                    //是否為L/C收料
      rvaCDS.FieldByName('rva05').AsString:=pmmCDS.FieldByName('pmm09').AsString;   //供應廠商
      rvaCDS.FieldByName('rva06').AsDateTime:=Date;                                 //收貨日期
      if Copy(rvaCDS.FieldByName('rva02').AsString,1,3)='P1Z' then
        rvaCDS.FieldByName('rva10').AsString:='REG'
      else
        rvaCDS.FieldByName('rva10').AsString:=pmmCDS.FieldByName('pmm02').AsString;   //採購類別REG
      rvaCDS.FieldByName('rvaprsw').AsString:='Y';                                  //是否需列印收貨單
      rvaCDS.FieldByName('rvaconf').AsString:='N';                                  //資料確認碼
      rvaCDS.FieldByName('rvaprno').AsInteger:=0;                                   //列印次數
      rvaCDS.FieldByName('rvaacti').AsString:='Y';                                  //資料有效碼
      rvaCDS.FieldByName('rvauser').AsString:=g_UInfo^.UserId;                      //經辦人
      rvaCDS.FieldByName('rvagrup').AsString:='0D8120';                             //部門
      rvaCDS.FieldByName('rvamodu').AsString:=g_UInfo^.UserId;                      //修改人
      rvaCDS.FieldByName('rvadate').AsDateTime:=Date;                               //修改日期
      rvaCDS.Post;

      sno:=1;
      tmpSrcCDS.Filtered:=False;
      tmpSrcCDS.Filter:='purno='+Quotedstr(tmpPurno);
      tmpSrcCDS.Filtered:=True;
      tmpSrcCDS.IndexFieldNames:='pursno;lot;qty';
      while not tmpSrcCDS.Eof do
      begin
        if not pmmCDS.Locate('pmn01;pmn02',VarArrayOf([tmpPurno,tmpSrcCDS.FieldByName('pursno').AsInteger]),[]) then
        begin
          ShowMsg('無法定位到採購單:'+tmpPurno+'/'+tmpSrcCDS.FieldByName('pursno').AsString,48);
          Exit;
        end;

        rvbCDS.Append;
        rvbCDS.FieldByName('rvb01').AsString:=rvaCDS.FieldByName('rva01').AsString;     //收貨單號(后面統一更新)
        rvbCDS.FieldByName('rvb02').AsInteger:=sno;                                     //收貨項次
        rvbCDS.FieldByName('rvb03').AsInteger:=pmmCDS.FieldByName('pmn02').AsInteger;   //採購項次
        rvbCDS.FieldByName('rvb04').AsString:=pmmCDS.FieldByName('pmn01').AsString;     //採購單號
        rvbCDS.FieldByName('rvb05').AsString:=pmmCDS.FieldByName('pmn04').AsString;     //料號
        rvbCDS.FieldByName('rvb06').AsInteger:=0;                                       //已請款量
        rvbCDS.FieldByName('rvb07').AsFloat:=tmpSrcCDS.FieldByName('qty').AsFloat;      //實收數量
        rvbCDS.FieldByName('rvb08').AsFloat:=rvbCDS.FieldByName('rvb07').AsFloat;       //收數數量
        rvbCDS.FieldByName('rvb09').AsInteger:=0;                                       //允請款量
        rvbCDS.FieldByName('rvb10').AsFloat:=pmmCDS.FieldByName('pmn31').AsFloat;       //未稅單價
        rvbCDS.FieldByName('rvb10t').AsFloat:=pmmCDS.FieldByName('pmn31t').AsFloat;     //含稅單價
        rvbCDS.FieldByName('rvb11').AsInteger:=0;                                       //代買項次
        rvbCDS.FieldByName('rvb12').AsDateTime:=Date;                                   //收貨應完成日期
        rvbCDS.FieldByName('rvb15').AsInteger:=0;                                       //容器裝數
        rvbCDS.FieldByName('rvb16').AsInteger:=0;                                       //容器數目
        rvbCDS.FieldByName('rvb18').AsString:='10';                                     //收貨狀況 10:在收貨檢驗區 30:入[庫存]
        rvbCDS.FieldByName('rvb19').AsString:='1';                                      //收貨性質 1:採購收貨單
        rvbCDS.FieldByName('rvb27').AsFloat:=0;                                         //未知
        rvbCDS.FieldByName('rvb28').AsFloat:=0;                                         //未知
        rvbCDS.FieldByName('rvb29').AsFloat:=0;                                         //退貨量
        rvbCDS.FieldByName('rvb30').AsFloat:=0;                                         //已檢驗入庫量
        rvbCDS.FieldByName('rvb31').AsFloat:=rvbCDS.FieldByName('rvb07').AsFloat;       //rvb07實收量-rvb29退回量-rvb檢驗量
        rvbCDS.FieldByName('rvb32').AsFloat:=0;                                         //未知
        rvbCDS.FieldByName('rvb33').AsFloat:=0;                                         //允收數量 QC輸入
        rvbCDS.FieldByName('rvb35').AsString:='N';                                      //樣品否
        rvbCDS.FieldByName('rvb36').AsString:=tmpSrcCDS.FieldByName('place').AsString;  //倉庫
        rvbCDS.FieldByName('rvb37').AsString:=tmpSrcCDS.FieldByName('area').AsString;   //儲位
        rvbCDS.FieldByName('rvb38').AsString:=tmpSrcCDS.FieldByName('lot').AsString;    //批號
        rvbCDS.FieldByName('rvb39').AsString:='Y';                                      //檢驗否(rvb40檢驗日期,rvb41檢驗結果)
        rvbCDS.FieldByName('ta_rvb01').AsString:='N';                                   //VMI入庫否
        rvbCDS.FieldByName('ta_rvb02').AsInteger:=0;                                    //VMI可入庫量
        rvbCDS.FieldByName('ta_rvb03').AsInteger:=0;                                    //VMI入庫量
        rvbCDS.FieldByName('ta_rvb04').AsInteger:=0;                                    //VMI可轉出量
        rvbCDS.FieldByName('ta_rvb05').AsInteger:=0;                                    //VMI轉出量
        
        //免檢
        if pmhCDS.Locate('pmh01;pmh02;pmh13',
            VarArrayOf([rvbCDS.FieldByName('rvb05').AsString,
                        rvaCDS.FieldByName('rva05').AsString,
                        pmmCDS.FieldByName('pmm22').AsString]),[]) then
        if pmhCDS.FieldByName('pmh08').AsString='N' then                                //省略條件:or (sma886[6,6]='N' and sma886[8,8]='N') or rvb19='2'
           rvbCDS.FieldByName('rvb39').AsString:='N';                                   //QC檢驗否

        rvbCDS.Post;

        //添加一筆庫存為0的資料
        if not imgCDS.Locate('img01;img02;img03;img04',
            VarArrayOf([rvbCDS.FieldByName('rvb05').AsString,
                        rvbCDS.FieldByName('rvb36').AsString,
                        rvbCDS.FieldByName('rvb37').AsString,
                        rvbCDS.FieldByName('rvb38').AsString]),[]) then
        begin
          imgCDS.Append;
          imgCDS.FieldByName('img01').AsString:=rvbCDS.FieldByName('rvb05').AsString;
          imgCDS.FieldByName('img02').AsString:=rvbCDS.FieldByName('rvb36').AsString;
          imgCDS.FieldByName('img03').AsString:=rvbCDS.FieldByName('rvb37').AsString;
          imgCDS.FieldByName('img04').AsString:=rvbCDS.FieldByName('rvb38').AsString;
          imgCDS.FieldByName('img05').AsString:=rvbCDS.FieldByName('rvb01').AsString;
          imgCDS.FieldByName('img06').AsString:=rvbCDS.FieldByName('rvb02').AsString;
          if pmmCDS.FieldByName('pmn07').AsString='RL' then
             imgCDS.FieldByName('img09').AsString:='M'
          else
             imgCDS.FieldByName('img09').AsString:=pmmCDS.FieldByName('pmn07').AsString;
          imgCDS.FieldByName('img10').AsFloat:=0;
          imgCDS.FieldByName('img17').AsDateTime:=Date;
          imgCDS.FieldByName('img18').AsDateTime:=EncodeDate(9999,12,31);
          imgCDS.FieldByName('img19').AsString:='A';
          imgCDS.FieldByName('img20').AsFloat:=1;
          imgCDS.FieldByName('img21').AsFloat:=1;
          imgCDS.FieldByName('img22').AsString:='S';
          imgCDS.FieldByName('img23').AsString:='Y';
          imgCDS.FieldByName('img24').AsString:='Y';
          imgCDS.FieldByName('img25').AsString:='N';
          imgCDS.FieldByName('img27').AsInteger:=0;
          imgCDS.FieldByName('img28').AsInteger:=0;
          imgCDS.FieldByName('img30').AsFloat:=0;
          imgCDS.FieldByName('img31').AsFloat:=0;
          imgCDS.FieldByName('img32').AsFloat:=0;
          imgCDS.FieldByName('img33').AsFloat:=0;
          imgCDS.FieldByName('img34').AsFloat:=1;
          imgCDS.FieldByName('img37').AsDateTime:=Date;
          imgCDS.Post;
        end;

        tmpSrcCDS.Next;
        Inc(sno);
      end;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在處理收貨單號...');
    Application.ProcessMessages;
    tmpRetList.Clear;
    rvaCDS.First;
    while not rvaCDS.Eof do
    begin
      tmpSid:=Copy(rvaCDS.FieldByName('rva02').AsString,1,3); //前3碼單別
      if tmpSid='327' then
         tmpSid:='337'
      else if tmpSid='323' then
         tmpSid:='333'
      else if tmpSid='32E' then
         tmpSid:='33E'
      else if tmpSid='P1Z' then
         tmpSid:='337'
      else begin
        ShowMsg('未知採購單別:'+tmpSid,48);
        Exit;
      end;

      tmpRva01:='';
      tmpSid:=tmpSid+'-'+GetYM;
      for i:=0 to tmpRetList.Count-1 do
      if tmpSid=LeftStr(tmpRetList.Strings[i],6) then //前6碼相同,直接使用此單號,否則重新查詢rva_file最大單號
      begin
        if tmpRva01<tmpRetList.Strings[i] then
           tmpRva01:=tmpRetList.Strings[i];
      end;

      if Length(tmpRva01)=0 then
      begin
        Data:=null;
        tmpSQL:='select nvl(max(rva01),'''') as rva01 from '+g_UInfo^.BU+'.rva_file'
               +' where rva01 like ''' + tmpSid + '%''';
        if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
           Exit;
        tmpRva01:=GetNewNo(tmpSid, VarToStr(Data));
      end else
        tmpRva01:=GetNewNo(tmpSid, tmpRva01);

      tmpRetList.Add(tmpRva01);
      with rvbCDS do
      begin
        Filtered:=False;
        Filter:='rvb01='+Quotedstr(rvaCDS.FieldByName('rva01').AsString);
        Filtered:=True;
        while not IsEmpty do  //更改rvb01后,Filtered生效
        begin
          Edit;
          FieldByName('rvb01').AsString:=tmpRva01;
          Post;
        end;
      end;

      rvaCDS.Edit;
      rvaCDS.FieldByName('rva01').AsString:=tmpRva01;
      rvaCDS.Post;

      rvaCDS.Next;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在儲存資料...');
    Application.ProcessMessages;
    if not CDSPost(imgCDS,'img_file','ORACLE') then
       Exit;

    if not CDSPost(rvaCDS,'rva_file','ORACLE') then
       Exit;

    rvbCDS.Filtered:=False;
    if not CDSPost(rvbCDS,'rvb_file','ORACLE') then
    begin
      while not rvaCDS.IsEmpty do
        rvaCDS.Delete;
      CDSPost(rvaCDS,'rva_file','ORACLE');
    end;
    
    //省略:添加excel資料至dli803

    if not Assigned(FrmDLIT803_showret) then
       FrmDLIT803_showret:=TFrmDLIT803_showret.Create(Application);
    FrmDLIT803_showret.Memo1.Lines.Clear;
    FrmDLIT803_showret.Memo1.Lines.AddStrings(tmpRetList);
    FrmDLIT803_showret.Memo1.Lines.Insert(0,CheckLang('收貨完畢,收貨單碼:'));
    FrmDLIT803_showret.ShowModal;
    
  finally
    g_StatusBar.Panels[0].Text:='';
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpSrcCDS);
    FreeAndNil(pmmCDS);
    FreeAndNil(rvaCDS);
    FreeAndNil(rvbCDS);
    FreeAndNil(imgCDS);
    FreeAndNil(pmhCDS);
    FreeAndNil(tmpPurnoList);
    FreeAndNil(tmpRetList);
  end;
end;

end.
