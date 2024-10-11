unit unMPST070_GetCore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, Mask, DBCtrlsEh, ComCtrls, ExtCtrls,
  GridsEh, DBAxisGridsEh, DBGridEh, ImgList, Buttons, StrUtils, unMPST070_Param;

type
  TAddDefRec = record
    Simuver, Machine: string;
    Sdate: TDateTime;
    EmptyFlag: Integer;
  end;

type
  TFrmMPST070_GetCore = class(TFrmSTDI050)
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    Edit1: TEdit;
    cbb1: TComboBox;
    dtp3: TDateTimePicker;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DS: TDataSource;
    CDS: TClientDataSet;
    Label6: TLabel;
    Edit2: TEdit;
    DBGridEh1: TDBGridEh;
    Label8: TLabel;
    Edit3: TEdit;
    Label9: TLabel;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    BitBtn3: TBitBtn;
    rgp: TRadioGroup;
    Cbb2: TDBComboBoxEh;
    Label7: TLabel;
    Label10: TLabel;
    Cbb3: TDBComboBoxEh;
    Panel1: TPanel;
    Panel2: TPanel;
    TabSheet3: TTabSheet;
    DBGridEh3: TDBGridEh;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
  private
    l_StrIndex, l_StrIndexDesc: string;
    l_List: TList;
    l_Param: TMPST070_Param;
    procedure AddDefValue(xCDS: TClientDataSet; xRec: TAddDefRec);
    { Private declarations }
  public
    l_IsBtnOkClick: boolean;
    function GetData: OleVariant;
    { Public declarations }
  end;

var
  FrmMPST070_GetCore: TFrmMPST070_GetCore;


implementation

uses
  unGlobal, unCommon, unMPST070, unMPST070_cdsxml;

{$R *.dfm}

function TFrmMPST070_GetCore.GetData: OleVariant;
var
  tmpList: TStrings;
  tmpMS: TMemoryStream;
  tmpCDS: TClientDataSet;
begin
  Result := Null;
  if (CDS.Active) or (not CDS.IsEmpty) then
  begin
    tmpMS := TMemoryStream.Create;
    tmpList := TStringList.Create;
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpList.Add(g_OrdXML);
      tmpList.SaveToStream(tmpMS);
      tmpMS.Position := 0;
      tmpCDS.LoadFromStream(tmpMS);
      with CDS do
      begin
        DisableControls;
        First;
        while not Eof do
        begin
          tmpCDS.Append;
          tmpCDS.FieldByName('materialno').AsString := FieldByName('materialno').AsString;
          tmpCDS.FieldByName('sqty').AsString := FieldByName('sqty').AsString;
          tmpCDS.Post;
          Next;
        end;
        EnableControls;
      end;
      if tmpCDS.ChangeCount > 0 then
        tmpCDS.MergeChangeLog;
      Result := tmpCDS.Data;
    finally
      FreeAndNil(tmpCDS);
      FreeAndNil(tmpList);
      FreeAndNil(tmpMS);
    end;
  end;
end;

procedure TFrmMPST070_GetCore.AddDefValue(xCDS: TClientDataSet; xRec: TAddDefRec);
begin
  with xCDS do
  begin
    FieldByName('Bu').AsString := g_UInfo^.BU;
    FieldByName('Simuver').AsString := xRec.Simuver;
    FieldByName('Citem').AsInteger := RecordCount + 1;
    FieldByName('Jitem').AsInteger := g_Jitem;
    FieldByName('Machine').AsString := xRec.Machine;
    FieldByName('Sdate').AsDateTime := xRec.Sdate;
    FieldByName('Iuser').AsString := g_UInfo^.UserId;
    FieldByName('Idate').AsDateTime := Now;
    FieldByName('Lock').AsBoolean := False;
    FieldByName('EmptyFlag').AsInteger := xRec.EmptyFlag;
    FieldByName('ErrorFlag').AsInteger := 0;
    FieldByName('Case_ans1').AsBoolean := False;
    FieldByName('Case_ans2').AsBoolean := False;
  end;
end;

procedure TFrmMPST070_GetCore.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'MPST070_GetCore1');
  SetGrdCaption(DBGridEh2, 'MPST070_GetCore2');
  SetGrdCaption(DBGridEh3, 'MPST070_GetCore3');
  SetStrings(Cbb2.Items, 'Vendor', 'MPS690');

  TabSheet1.Caption := CheckLang('內用Core資料');
  TabSheet2.Caption := CheckLang('CCL排程資料');
  TabSheet3.Caption := CheckLang('副排程資料');
  BitBtn1.Caption := CheckLang('計算');
  BitBtn2.Caption := CheckLang('排產');
  BitBtn3.Caption := CheckLang('CCL排程資料');
  BitBtn4.Caption := CheckLang('副排程資料');
  BitBtn5.Caption := CheckLang('庫存與未交狀況');
  BitBtn6.Caption := CheckLang('匯出Excel');
  Label1.Caption := CheckLang('生產日期：');
  Label2.Caption := CheckLang('至');
  Label3.Caption := CheckLang('料號');
  Label4.Caption := CheckLang('數量');
  Label5.Caption := CheckLang('生產日期');
  Label6.Caption := CheckLang('機台');
  Label7.Caption := CheckLang('布種');
  Label8.Caption := CheckLang('料號：');
  Label9.Caption := CheckLang('總使用量：0');
  Label10.Caption := CheckLang('說明');

  Cbb3.Items.BeginUpdate;
  Cbb3.Items.Clear;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    Cbb3.Items.Add(CheckLang('DG自用'));
    Cbb3.Items.Add(CheckLang('GZ自用'));
  end
  else
    Cbb3.Items.Add(CheckLang('自用'));
  Cbb3.Items.EndUpdate;
  cbb1.Items.DelimitedText := g_MachinePP;
  dtp1.Date := Date;
  dtp2.Date := Date + 6;
  dtp3.Date := Date + 1;

  if cbb1.Items.Count > 0 then
    cbb1.ItemIndex := 0;
  if Cbb2.Items.Count > 0 then
    Cbb2.ItemIndex := 0;
  if Cbb3.Items.Count > 0 then
    Cbb3.ItemIndex := 0;

  rgp.Items.Clear;
  rgp.Columns := 0;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    rgp.Items.Add('L1~L5');
    rgp.Items.Add('L6');
    rgp.Items.Add(CheckLang('副排程'));
    rgp.Items.Add(CheckLang('全部'));
    rgp.Columns := 4;
  end
  else
  begin
    rgp.Items.Add('主排程');
    rgp.Items.Add(CheckLang('副排程'));
    rgp.Items.Add(CheckLang('全部'));
    rgp.Columns := 3;
  end;
  rgp.ItemIndex := 0;

  l_Param := TMPST070_Param.Create;
  l_List := TList.Create;
end;

procedure TFrmMPST070_GetCore.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
  FreeAndNil(l_Param);
  for i := 0 to l_List.Count - 1 do
    Dispose(POrderRec(l_List.Items[i]));
  FreeAndNil(l_List);
end;

procedure TFrmMPST070_GetCore.BitBtn1Click(Sender: TObject);
var
  totqty: Double;
  tmpSQL: string;
  Data: OleVariant;
begin
  inherited;
  totqty := 0;
  tmpSQL := ' and sdate between ' + QuotedStr(DateToStr(dtp1.Date)) + ' and ' + QuotedStr(DateToStr(dtp2.Date));

  if rgp.ItemIndex = 3 then       //全部:主排程+副排程
    tmpSQL := 'exec dbo.proc_GetCCLCoreY ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(tmpSQL) + ',' + QuotedStr(Trim(Edit3.Text))
  else if rgp.ItemIndex = 2 then  //副排程
    tmpSQL := 'exec dbo.proc_GetCCLCoreX ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(tmpSQL) + ',' + QuotedStr(Trim(Edit3.Text))
  else
  begin                                    //主排程
    if SameText(g_UInfo^.BU, 'ITEQDG') then
    begin
      if rgp.ItemIndex = 0 then
        tmpSQL := tmpSQL + ' and machine<>''L6'''
      else //rgp.ItemIndex=1
        tmpSQL := tmpSQL + ' and machine=''L6''';
    end;

    tmpSQL := 'exec dbo.proc_GetCCLCore ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(tmpSQL) + ',' + QuotedStr(Trim(Edit3.Text));
  end;
  if QueryBySQL(tmpSQL, Data) then
  begin
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    Self.CDS.Data := Data;
    with Self.CDS do
    begin
      DisableControls;
      while not Eof do
      begin
        totqty := totqty + FieldByName('sqty').AsFloat;
        Next;
      end;
      First;
      EnableControls
    end;
  end;
  Label9.Caption := CheckLang('總使用量：') + FloatToStr(totqty);
end;

procedure TFrmMPST070_GetCore.BitBtn2Click(Sender: TObject);
var
  tmpSQL, tmpPno, tmpMachine, tmpSimuver, pg: string;
  isFiLock: Boolean;
  tmpQty: Double;
  tmpWdate, tmpSdate: TDateTime;
  tmpNum, tmpCapacity: Integer; //產能:分鐘
  tmpSpeed: Double;            //机速:米/分鐘
  SMRec: TSplitMaterialnoPPCore;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
  tmpRec: TAddDefRec;
begin
  inherited;
  tmpPno := Trim(Edit1.Text);
  if (Length(tmpPno) <> 13) or (Pos(Copy(tmpPno, 1, 1), 'PQ') = 0) then
  begin
    ShowMsg('請輸入料號,或料號格式、長度不正確!', 48);
    Edit1.SetFocus;
    Exit;
  end;

  try
    tmpQty := StrToInt(Trim(Edit2.Text));
  except
    ShowMsg('數量請輸入整數!', 48);
    Edit2.SetFocus;
    Exit;
  end;

  if tmpQty <= 0 then
  begin
    ShowMsg('數量＞0!', 48);
    Edit2.SetFocus;
    Exit;
  end;

  if dtp3.Date < Date then
  begin
    ShowMsg('生產日期不能小於當前日期!', 48);
    dtp3.SetFocus;
    Exit;
  end;

  if cbb1.ItemIndex = -1 then
  begin
    ShowMsg('請選擇機台', 48);
    cbb1.SetFocus;
    Exit;
  end;

  tmpMachine := UpperCase(cbb1.Text);

  if ShowMsg('確定要進行排程嗎?', 33) = IDCancel then
    Exit;

  l_Param.GetParameData_Exec;
  l_Param.SetCoreRec(SMRec, tmpPno);

  //檢查布種鎖定
  if (Length(Cbb2.Text) > 0) and l_Param.CheckFiberLock(tmpMachine, SMRec.MFiber, Cbb2.Text, SMRec.M10, isFiLock, tmpSdate) then
  begin
    if isFiLock then
    begin
      ShowMsg('布種鎖定,不可排程!', 48);
      Exit;
    end
    else if dtp3.Date < tmpSdate then
    begin
      ShowMsg('布種指定生產日期小於設定日期(≧' + DateToStr(tmpSdate) + ')', 48);
      Exit;
    end;
  end;
  //檢查布種鎖定

  with l_Param.CDS_ChanNeng do
  begin
    Filtered := False;
    Filter := 'machine=' + QuotedStr(tmpMachine) + ' and wdate=' + QuotedStr(DateToStr(dtp3.Date)) + ' and capacity>0 and lock=0';
    Filtered := True;
    if IsEmpty then
    begin
      ShowMsg('產能不足', 48);
      Exit;
    end;
    IndexFieldNames := 'wdate';
    tmpNum := l_Param.AdIsPlan(tmpMachine, SMRec.M2, FieldByName('wdate').AsDateTime);
    if tmpNum = 1 then
    begin
      if ShowMsg('與計劃性生產設定不符,忽略嗎?', 33) = IdCancel then
        Exit;
    end
    else if tmpNum = 0 then
      if l_Param.SdateIsPlan(tmpMachine, FieldByName('wdate').AsDateTime) then
        if ShowMsg('與計劃性生產設定不符,忽略嗎?', 33) = IdCancel then
          Exit;

    tmpSpeed := l_Param.GetSpeedCore(tmpMachine, SMRec);
    if tmpSpeed <= 0 then
    begin
      ShowMsg(tmpPno + '機台/膠系/布種/RC(' + tmpMachine + '/' + SMRec.M2 + '/' + SMRec.MFiber + '/' + SMRec.M6_8 + ')找不到機速設定或設定錯誤', 48);
      Exit;
    end;

    //換規格計算
    tmpCapacity := Round(tmpQty / tmpSpeed + 0.5);                 //需要生產時間
    if tmpCapacity <= FieldByName('capacity').AsInteger then   //產能足
    begin
      tmpQty := 0;
      tmpCapacity := Trunc(FieldByName('capacity').AsInteger - tmpCapacity);
    end
    else                                                 //不足
    begin
      tmpQty := Trunc(tmpQty - Trunc(FieldByName('capacity').AsInteger * tmpSpeed));
      tmpCapacity := 0;
    end;
  end;

  if tmpQty > 0 then
  begin
    ShowMsg(tmpPno + '數量:' + FloatToStr(tmpQty) + ',產能不足', 48);
    Exit;
  end;

  tmpSimuver := GetSno(g_MInfo^.ProcId);
  if tmpSimuver = '' then
    Exit;

  //tmpWdate~Dtp.Date這段日期區間添加空行
  tmpSQL := 'Select Max(Sdate)+1 Sdate From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And IsNull(ErrorFlag,0)=0 And Machine=' + QuotedStr(tmpMachine);
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpCDS.IsEmpty then
      tmpWdate := EncodeDate(1955, 5, 5)
    else
      tmpWdate := tmpCDS.Fields[0].AsDateTime;

    tmpSQL := 'Select Bu,Simuver,Citem,Jitem,Machine,Sdate,Materialno,Sqty,' + ' Adate_new,Iuser,Idate,RemainCapacity,Breadth,Fiber,Custno,Lock,' + ' EmptyFlag,ErrorFlag,Case_ans1,Case_ans2,AD,FI,FISno,RC,PG,Premark' + ' From MPS070 Where Bu=' + QuotedStr(g_UInfo^.BU) + ' And Sdate=' + QuotedStr(DateToStr(dtp3.Date)) + ' And Machine=' + QuotedStr(tmpMachine) + ' And EmptyFlag=1';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;
    while not tmpCDS.Eof do
      tmpCDS.Delete;

    tmpRec.Simuver := tmpSimuver;
    tmpRec.Machine := tmpMachine;
    tmpRec.Sdate := dtp3.Date;
    tmpRec.EmptyFlag := 0;
    tmpCDS.Append;
    AddDefValue(tmpCDS, tmpRec);
    tmpCDS.FieldByName('Materialno').AsString := tmpPno;
    tmpCDS.FieldByName('Sqty').AsFloat := StrToFloat(Edit2.Text);
    tmpCDS.FieldByName('Breadth').AsString := SMRec.M10;
    tmpCDS.FieldByName('Fiber').AsString := Cbb2.Text;
    tmpCDS.FieldByName('AD').Value := Copy(tmpPno, 2, 1);
    if SameText(tmpCDS.FieldByName('AD').Value, 'J') then
      tmpCDS.FieldByName('AD').Value := '1';
    tmpCDS.FieldByName('FI').Value := SMRec.MFiber;
    tmpCDS.FieldByName('FISno').Value := l_Param.GetFiSno(SMRec.MFiber);
    if tmpCDS.FieldByName('FI').AsString = '3313' then //3313<=>2313
      tmpCDS.FieldByName('FI').AsString := '2313a';
    tmpCDS.FieldByName('RC').Value := Copy(tmpPno, 6, 3);
    pg := Copy(tmpPno, 3, 1);
    if Pos(pg, '36') > 0 then
      pg := '36'
    else if Pos(pg, '8T') > 0 then
      pg := '8T'
    else
      pg := pg + '@';
    tmpCDS.FieldByName('PG').Value := pg;
    if Length(Cbb3.Text) = 0 then
      tmpCDS.FieldByName('Custno').AsString := CheckLang('自用')
    else
      tmpCDS.FieldByName('Custno').AsString := Cbb3.Text;
    if SMRec.M11 = '6' then
    begin
      if (SMRec.M1='P') or (SMRec.M1='Q') then
        tmpCDS.FieldByName('Premark').AsString := 'CAF-C 汽車板'
      else
        tmpCDS.FieldByName('Premark').AsString := 'CAF-C';
    end;
    if Pos(SMRec.M13, 'nNkK') > 0 then
    begin
      if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
        tmpCDS.FieldByName('Premark').AsString := CheckLang('HDI訂單')
      else
        tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang('HDI訂單');
    end;
    if SMRec.M10 < '44' then
    begin
      if Length(tmpCDS.FieldByName('Premark').AsString) = 0 then
        tmpCDS.FieldByName('Premark').AsString := CheckLang('窄碼')
      else
        tmpCDS.FieldByName('Premark').AsString := tmpCDS.FieldByName('Premark').AsString + ' ' + CheckLang('窄碼');
    end;
    tmpCDS.Post;
    if tmpCapacity > 0 then
    begin
      tmpRec.EmptyFlag := 1;
      tmpCDS.Append;
      AddDefValue(tmpCDS, tmpRec);
      tmpCDS.FieldByName('RemainCapacity').AsInteger := tmpCapacity;
      tmpCDS.FieldByName('AD').Value := g_OZ;
      tmpCDS.Post;
    end;

    //補空行
    if tmpWdate > EncodeDate(2016, 10, 1) then
    begin
      while tmpWdate < dtp3.Date do
      begin
        tmpRec.Sdate := tmpWdate;
        tmpRec.EmptyFlag := 1;
        tmpCDS.Append;
        AddDefValue(tmpCDS, tmpRec);
        tmpCDS.FieldByName('RemainCapacity').AsInteger := 0;
        tmpCDS.FieldByName('AD').Value := g_OZ;
        tmpCDS.Post;
        tmpWdate := tmpWdate + 1;
      end;
    end;

    if CDSPost(tmpCDS, 'MPS070') then
    begin
      FrmMPST070.UdpJitem(tmpSimuver);
      ShowMsg('排程完畢!', 64);
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST070_GetCore.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if Self.CDS.Active and (not Self.CDS.IsEmpty) then
  begin
    Edit1.Text := Self.CDS.FieldByName('materialno').AsString;
    Edit2.Text := FloatToStr(Self.CDS.FieldByName('sqty').AsFloat);
  end;
end;

//第1碼：P=Q、第11碼:C=N
procedure TFrmMPST070_GetCore.BitBtn3Click(Sender: TObject);
var
  tmpSQL, tmpStr, s1, s2, s3, s4, FOraDB: string;
  tmpSQL_GZ, tmpSQL_DG: string;
  Data: OleVariant;
  tmpCDS1, tmpCDS2: TClientDataSet;
begin
  inherited;    //proc_GetCCL_By_Pno
  if (not CDS.Active) or (CDS.IsEmpty) then
    s1 := Trim(Edit3.Text)
  else
    s1 := CDS.FieldByName('materialno').AsString;
  if (Length(s1) <> 13) or (Pos(LeftStr(s1, 1), 'PQ') = 0) then
  begin
    ShowMsg('請選擇或輸入一個料號,第一碼為P、Q,長度13碼!', 48);
    Exit;
  end;

  if ((rgp.Items.Count = 2) and (rgp.ItemIndex = 1)) or ((rgp.Items.Count = 3) and (rgp.ItemIndex = 2)) then
  begin
    ShowMsg('請選擇CCL排程!', 48);
    Exit;
  end;

  if LeftStr(s1, 1) = 'P' then
    s2 := 'Q' + Copy(s1, 2, 20)
  else
    s2 := 'P' + Copy(s1, 2, 20);
  if Copy(s1, 11, 1) = 'C' then
  begin
    s3 := Copy(s1, 1, 10) + 'N' + Copy(s1, 12, 10);
    s4 := Copy(s2, 1, 10) + 'N' + Copy(s2, 12, 10);
  end
  else if Copy(s1, 11, 1) = 'N' then
  begin
    s3 := Copy(s1, 1, 10) + 'C' + Copy(s1, 12, 10);
    s4 := Copy(s2, 1, 10) + 'C' + Copy(s2, 12, 10);
  end
  else
  begin
    s3 := s1;
    s4 := s1;
  end;
  FOraDB := g_UInfo^.BU;
  if rgp.Items.Count = 4 then   //?
  begin
    if rgp.ItemIndex = 0 then
    begin
      tmpStr := ' and machine<>''L6''';
      FOraDB := 'ITEQDG';
    end
    else if rgp.ItemIndex = 1 then
    begin
      tmpStr := ' and machine=''L6''';
      FOraDB := 'ITEQGZ';
    end;
  end;

  //oracle區分大小寫,mssql不區分大小寫,結果distinct
//  tmpSQL := '	declare @bu varchar(6)=' + QuotedStr(g_UInfo^.BU) + ' declare @bmb03_1 varchar(20)=' + QuotedStr(s1) + ' declare @bmb03_2 varchar(20)=' + QuotedStr(s2) + ' declare @bmb03_3 varchar(20)=' + QuotedStr(s3) + ' declare @bmb03_4 varchar(20)=' + QuotedStr(s4) + ' declare @t table(bmb03 varchar(20))' + ' declare @sql varchar(8000)'
// + ' set @sql=''select distinct bmb01 from ' + FOraDB + '.bma_file,' + FOraDB + '.bmb_file' + ' where bma01=bmb01 and bmb05 is null and nvl(bmaacti,''''''''N'''''''')=''''''''Y''''''''' + ' and bmb03 in (''''''''''+@bmb03_1+'''''''''',' + ' ''''''''''+@bmb03_2+'''''''''',' + ' ''''''''''+@bmb03_3+'''''''''',' + ' ''''''''''+@bmb03_4+'''''''''')''' + ' set @sql=''select * from openquery(iteqdg,''''''+@sql+'''''')''' + ' insert into @t(bmb03) exec (@sql)'
// + ' select distinct sdate,machine,currentboiler,materialno,wono,' + ' isnull(custno,'''')+isnull(custom,'''') as custno,sqty,adate_new' + ' from mps010 inner join @t on materialno=bmb03' + ' where bu=@bu and isnull(errorflag,0)=0 and sqty>0' + ' and sdate between ' + QuotedStr(DateToStr(dtp1.Date)) + ' and ' + QuotedStr(DateToStr(dtp2.Date)) + tmpStr + ' order by sdate,machine,currentboiler';
  {(*}
  tmpSQL := '	declare @bu varchar(6)=' + QuotedStr(g_UInfo^.BU) + ' declare @bmb03_1 varchar(20)=' + QuotedStr(s1) +
            ' declare @bmb03_2 varchar(20)=' + QuotedStr(s2) + ' declare @bmb03_3 varchar(20)=' + QuotedStr(s3) +
            ' declare @bmb03_4 varchar(20)=' + QuotedStr(s4) + ' declare @t table(bmb03 varchar(20))' +
            ' declare @sql varchar(8000)' +
            ' set @sql=''select distinct bmb01 from ' + FOraDB + '.bma_file,' + FOraDB + '.bmb_file' + ' where bma01=bmb01 and bmb05 is null and nvl(bmaacti,''''''''N'''''''')=''''''''Y''''''''' + ' and bmb03 in (''''''''''+@bmb03_1+'''''''''',' + ' ''''''''''+@bmb03_2+'''''''''',' + ' ''''''''''+@bmb03_3+'''''''''',' + ' ''''''''''+@bmb03_4+'''''''''')''';
  tmpSQL := tmpSQL +' set @sql=''select * from openquery(iteqdg,''''''+@sql+'''''')''' + ' insert into @t(bmb03) exec (@sql)'+
            ' select distinct sdate,machine,currentboiler,materialno,wono,' + ' isnull(custno,'''')+isnull(custom,'''') as custno,sqty,adate_new' + ' from mps010 inner join @t on materialno=bmb03' + ' where bu=@bu and isnull(errorflag,0)=0 and sqty>0' + ' and sdate between ' + QuotedStr(DateToStr(dtp1.Date)) + ' and ' + QuotedStr(DateToStr(dtp2.Date)) + tmpStr + ' order by sdate,machine,currentboiler';
  {*)}
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpStr := '';
    tmpCDS1 := TClientDataSet.Create(nil);
    tmpCDS2 := TClientDataSet.Create(nil);
    try
      tmpCDS1.Data := Data;
      while not tmpCDS1.Eof do
      begin
        if (Length(tmpCDS1.FieldByName('wono').AsString) > 0) and (Pos(tmpCDS1.FieldByName('wono').AsString, tmpStr) = 0) then
          tmpStr := tmpStr + ',' + QuotedStr(tmpCDS1.FieldByName('wono').AsString);
        tmpCDS1.Next;
      end;

      if Length(tmpStr) > 0 then
      begin
        Delete(tmpStr, 1, 1);
        Data := Null;

        // longxinjue 20211203
        // a. 以下為刪除已報工的單據： 同一工單號出沒於 GZ DG 兩個庫
        // a1. 刪除廣州已報工
        tmpSQL_GZ := 'select shb05 from ITEQGZ.shb_file' + ' where shb05 in (' + tmpStr + ') and shb06=1 and ta_shbconf=''Y''';
        if QueryBySQL(tmpSQL_GZ, Data, 'ORACLE') then
        begin
          tmpCDS2.Data := Data;
          while not tmpCDS2.Eof do
          begin
            while tmpCDS1.Locate('machine;wono', VarArrayOf(['L6', tmpCDS2.FieldByName('shb05').AsString]), []) do
              tmpCDS1.Delete;
            tmpCDS2.Next;
          end;
        end;

        // a2. 刪除DG已報工
        tmpSQL_DG := 'select shb05 from ITEQDG.shb_file' + ' where shb05 in (' + tmpStr + ') and shb06=1 and ta_shbconf=''Y''';
        if QueryBySQL(tmpSQL_DG, Data, 'ORACLE') then
        begin
          tmpCDS2.Data := Data;
          while not tmpCDS2.Eof do
          begin
            if not SameText(tmpCDS1.FieldByName('machine').AsString, 'L6') then
              while tmpCDS1.Locate('wono', tmpCDS2.FieldByName('shb05').AsString, []) do
                tmpCDS1.Delete;
            tmpCDS2.Next;
          end;
        end;

      end;
      if tmpCDS1.ChangeCount > 0 then
        tmpCDS1.MergeChangeLog;
      CDS2.Data := tmpCDS1.Data;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
    end;
  end;
  PCL.ActivePageIndex := 1;
end;

procedure TFrmMPST070_GetCore.BitBtn4Click(Sender: TObject);
var
  tmpSQL, s1, s2, s3, s4, FOraDB: string;
  Data: OleVariant;
begin
  inherited;
  if (not CDS.Active) or (CDS.IsEmpty) then
    s1 := Trim(Edit3.Text)
  else
    s1 := CDS.FieldByName('materialno').AsString;
  if (Length(s1) <> 13) or (Pos(LeftStr(s1, 1), 'PQ') = 0) then
  begin
    ShowMsg('請選擇或輸入一個料號,第一碼為P、Q,長度13碼!', 48);
    Exit;
  end;

  if LeftStr(s1, 1) = 'P' then
    s2 := 'Q' + Copy(s1, 2, 20)
  else
    s2 := 'P' + Copy(s1, 2, 20);
  if Copy(s1, 11, 1) = 'C' then
  begin
    s3 := Copy(s1, 1, 10) + 'N' + Copy(s1, 12, 10);
    s4 := Copy(s2, 1, 10) + 'N' + Copy(s2, 12, 10);
  end
  else if Copy(s1, 11, 1) = 'N' then
  begin
    s3 := Copy(s1, 1, 10) + 'C' + Copy(s1, 12, 10);
    s4 := Copy(s2, 1, 10) + 'C' + Copy(s2, 12, 10);
  end
  else
  begin
    s3 := s1;
    s4 := s1;
  end;

  FOraDB := g_UInfo^.BU;                                                                                                                                                                                                                                                                                  //   collate Chinese_Taiwan_Stroke_CS_AS
  tmpSQL := '	declare @bu varchar(6)=' + QuotedStr(g_UInfo^.BU) + ' declare @bmb03_1 varchar(20)=' + QuotedStr(s1) + ' declare @bmb03_2 varchar(20)=' + QuotedStr(s2) + ' declare @bmb03_3 varchar(20)=' + QuotedStr(s3) + ' declare @bmb03_4 varchar(20)=' + QuotedStr(s4) + ' declare @t table(bmb03 varchar(20))' + ' declare @sql varchar(8000)' + ' set @sql=''select distinct bmb01 from ' + FOraDB + '.bma_file,' + FOraDB + '.bmb_file' +
    ' where bma01=bmb01 and bmb05 is null and nvl(bmaacti,''''''''N'''''''')=''''''''Y''''''''' + ' and bmb03 in (''''''''''+@bmb03_1+'''''''''',' + ' ''''''''''+@bmb03_2+'''''''''',' + ' ''''''''''+@bmb03_3+'''''''''',' + ' ''''''''''+@bmb03_4+'''''''''')''' + ' set @sql=''select * from openquery(iteqdg,''''''+@sql+'''''')''' + ' insert into @t(bmb03) exec (@sql)' + ' select stype,sdate,materialno,' + ' isnull(custno,'''')+isnull(custom,'''') as custno,sqty,adate' + ' from mps012 inner join @t on materialno collate Chinese_Taiwan_Stroke_CS_AS=bmb03' + ' where bu=@bu and isnull(isempty,0)=0 and sqty>0' + ' and sdate between ' + QuotedStr(DateToStr(dtp1.Date)) + ' and ' + QuotedStr(DateToStr(dtp2.Date)) + ' order by stype,sdate';

  if QueryBySQL(tmpSQL, Data) then
    CDS3.Data := Data;
  PCL.ActivePageIndex := 2;
end;

procedure TFrmMPST070_GetCore.BitBtn5Click(Sender: TObject);
var
  str: string;
begin
  inherited;
  if CDS.Active then
    str := CDS.FieldByName('materialno').AsString;
  GetQueryStock(str, true);
end;

procedure TFrmMPST070_GetCore.BitBtn6Click(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, 'MPST070_GetCore1');
end;

procedure TFrmMPST070_GetCore.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST070_GetCore.FormShow(Sender: TObject);
begin
  inherited;
  l_IsBtnOkClick := false;
end;

procedure TFrmMPST070_GetCore.btn_okClick(Sender: TObject);
begin
  inherited;
  l_IsBtnOkClick := true;
end;

procedure TFrmMPST070_GetCore.btn_quitClick(Sender: TObject);
begin
  inherited;
  close;
end;

end.

