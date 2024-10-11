unit unIPQCT500_mps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, ComCtrls, StdCtrls, ExtCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons;

type
  TFrmIPQCT500_mps = class(TFrmSTDI050)
    DBGridEh1: TDBGridEh;
    Label1: TLabel;
    CDS: TClientDataSet;
    DS: TDataSource;
    Dtp1: TDateTimePicker;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    RG: TRadioGroup;
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Panel1: TPanel;
    Label3: TLabel;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure RGClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CDS2BeforeInsert(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure BitBtn4Click(Sender: TObject);
  private
    l_Dno:string;
    l_ColorList:TStrings;
    l_CDS:TClientDataSet;
    procedure RefreshColor;
    procedure GetSumQty;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT500_mps: TFrmIPQCT500_mps;

implementation

uses unGlobal, unCommon, unIPQCT500;

const l_XML='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="checkbox" fieldtype="boolean"/>'
           +'<FIELD attrname="fiber" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="breadth" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="vendor" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmIPQCT500_mps.RefreshColor;
var
  tmpValue:string;
  tmpSdate:TDateTime;
  tmpCDS:TClientdataset;
begin
  l_ColorList.Clear;
  if not CDS.Active then
     Exit;
  tmpCDS:=TClientdataset.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.Filter:=CDS.Filter;
    tmpCDS.Filtered:=True;
    tmpCDS.AddIndex('xIndex', CDS.IndexDefs[0].Fields, [ixCaseInsensitive], CDS.IndexDefs[0].DescFields);
    tmpCDS.IndexName:='xIndex';
    tmpValue:='1';
    tmpSdate:=EncodeDate(1955,5,5);
    while not tmpCDS.Eof do
    begin
      if tmpSdate<>tmpCDS.FieldByName('Sdate').AsDateTime then
      begin
        if tmpValue='1' then
           tmpValue:='2'
        else
           tmpValue:='1';
      end;
      l_ColorList.Add(tmpValue);
      tmpSdate:=tmpCDS.FieldByName('Sdate').AsDateTime;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT500_mps.GetSumQty;
var
  totQty,Qty1,Qty2,Qty3,Qty4,Qty5,Qty6,Qty7,Qty8:Double;
  tmpCDS:TClientDataSet;
begin
  Qty1:=0;
  Qty2:=0;
  Qty3:=0;
  Qty4:=0;
  Qty5:=0;
  Qty6:=0;
  Qty7:=0;
  Qty8:=0;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filtered:=False;
      if RG.ItemIndex=0 then
         Filter:='Machine<>''T6'' And Machine<>''T7'' And Machine<>''T8'' And Lock=1'
      else
         Filter:='(Machine=''T6'' OR Machine=''T7'' OR Machine=''T8'') And Lock=1';
      Filtered:=True;
      while not Eof do
      begin
        if SameText(FieldByName('Machine').AsString,'T1') then
           Qty1:=Qty1+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T2') then
           Qty2:=Qty2+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T3') then
           Qty3:=Qty3+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T4') then
           Qty4:=Qty4+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T5') then
           Qty5:=Qty5+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T6') then
           Qty6:=Qty6+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T7') then
           Qty7:=Qty7+FieldByName('sqty').AsFloat
        else if SameText(FieldByName('Machine').AsString,'T8') then
           Qty8:=Qty8+FieldByName('sqty').AsFloat;
        Next;
      end;
    end;
    totQty:=Qty1+Qty2+Qty3+Qty4+Qty5+Qty6+Qty7+Qty8;
    if RG.ItemIndex=0 then
       Label3.Caption:='T1：'+FloatToStr(Qty1)+'  T2：'+FloatToStr(Qty2)+
                       '  T3：'+FloatToStr(Qty3)+'  T4：'+FloatToStr(Qty4)+
                       '  T5：'+FloatToStr(Qty5)+CheckLang('  總數量：')+FloatToStr(totQty)
    else
       Label3.Caption:='T6：'+FloatToStr(Qty6)
                      +'  T7：'+FloatToStr(Qty7)
                      +'  T8：'+FloatToStr(Qty8)+CheckLang('  總數量：')+FloatToStr(totQty);
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmIPQCT500_mps.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, 'IPQCT500_mps');
  SetGrdCaption(DBGridEh2, 'IPQC500');
  DBGridEh1.FieldColumns['Lock'].Title.Caption:=CheckLang('選擇');
  DBGridEh1.FieldColumns['Lock'].Width:=40;
  DBGridEh2.FieldColumns['checkbox'].Title.Caption:=CheckLang('選擇');
  DBGridEh2.FieldColumns['checkbox'].Width:=40;
  TabSheet1.Caption:=CheckLang('排程資料');
  TabSheet2.Caption:=CheckLang('需求資料');
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=CheckLang('至');
  Label3.Caption:=CheckLang('總數量：0');
  BitBtn4.Caption:=CheckLang('全部選中');
  BitBtn5.Caption:=CheckLang('全部取消');
  RG.Items.DelimitedText:=g_MachinePP;
  RG.Items.Add('DG');
  RG.Items.Add('GZ');
  RG.ItemIndex:=0;
  RG.Columns:=RG.Items.Count;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date+1;
  l_Dno:='';
  l_ColorList:=TStringList.Create;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_XML);
end;

procedure TFrmIPQCT500_mps.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
  FreeAndNil(l_ColorList);
  FreeAndNil(l_CDS);
end;

procedure TFrmIPQCT500_mps.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;
  if l_ColorList.Count>=CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=RGB(255,255,204)
    else
       Background:=RGB(204,236,255);
  end;
end;

procedure TFrmIPQCT500_mps.RGClick(Sender: TObject);
begin
  inherited;
  if not CDS.Active then
     Exit;

  CDS.Filtered:=False;
  if RG.ItemIndex=0 then
     CDS.Filter:='Machine<>''T6'' And Machine<>''T7'' And Machine<>''T8'''
  else
     CDS.Filter:='Machine=''T6'' OR Machine=''T7'' OR Machine=''T8''';
  CDS.Filtered:=True;
  RefreshColor;
end;

procedure TFrmIPQCT500_mps.BitBtn1Click(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpSQL:='Select Simuver,Citem,Jitem,AD,FISno,RC,Machine,Sdate,Wono,Orderno,'
         +' Orderitem,Materialno,Sqty,Adate_new,Custno,Breadth,Fiber,Premark,'
         +' Wostation_qtystr,Orderqty,Orderno2,Orderitem2,Materialno1,Pnlsize1,Pnlsize2,Lock'
         +' From MPS070 Where Bu=''ITEQDG'''
         +' And Sdate>='+Quotedstr(DateToStr(Dtp1.Date))
         +' And Sdate<='+Quotedstr(DateToStr(Dtp2.Date))
         +' And IsNull(ErrorFlag,0)=0 And IsNull(Case_ans2,0)=0'
         +' Order By Machine,Sdate,Jitem,AD,FISno,RC DESC,Fiber,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('Lock').AsBoolean:=False;
        tmpCDS.Post;
        tmpCDS.Next;
      end;
      if tmpCDS.ChangeCount>0 then
         tmpCDS.MergeChangeLog;
      CDS.Data:=tmpCDS.Data;
      RGClick(RG);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmIPQCT500_mps.BitBtn2Click(Sender: TObject);
var
  i:Integer;
  tmpBu,tmpStr,tmpFilter:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  //inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('無數據!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filtered:=False;
      if RG.ItemIndex=0 then
         Filter:='Machine<>''T6'' And Machine<>''T7'' And Machine<>''T8'' And Lock=1'
      else
         Filter:='(Machine=''T6'' OR Machine=''T7'' OR Machine=''T8'') And Lock=1';
      Filtered:=True;
      if isEmpty then
      begin
        ShowMsg('未選擇資料!',48);
        Exit;
      end;

      while not Eof do
      begin
        tmpFilter:=tmpFilter+','+Quotedstr(FieldByName('Simuver').AsString+'@'+IntToStr(FieldByName('Citem').AsInteger));
        Next;
      end;
      Filtered:=False;
      Filter:='';
    end;

    Delete(tmpFilter,1,1);
    if Pos(RG.Items.Strings[RG.ItemIndex],'T1,T2,T3,T4,T5,DG')>0 then
       tmpBu:='ITEQDG'
    else
       tmpBu:='ITEQGZ';
    tmpStr:='Select B.Fiber,A.Breadth,A.Fiber Vendor,B.Code Pno,Sum(A.Sqty) Qty'
           +' From MPS070 A Left Join (Select * From MPS620 Where Bu='+Quotedstr(tmpBu)+') B'
           +' ON (Case When A.Fi=''2313a'' Then ''3313'' Else A.FI End)=B.Fiber'
           +'   And CHARINDEX(A.Breadth, B.Breadth)>0 And A.Fiber=B.Vendor'
           +' Where A.Bu=''ITEQDG'' And A.Simuver+''@''+Cast(A.Citem as varchar(10)) in ('+tmpFilter+')'
           +' And IsNull(A.EmptyFlag,0)=0 And IsNull(A.ErrorFlag,0)=0'
           +' Group By B.Fiber,A.Breadth,A.Fiber,B.Code';
    if not QueryBySQL(tmpStr, Data) then
       Exit;
    l_CDS.EmptyDataSet;
    tmpCDS.Data:=Data;
    while not tmpCDS.Eof do
    begin
      l_CDS.Append;
      for i:=0 to tmpCDS.FieldCount-1 do
      if l_CDS.FindField(tmpCDS.Fields[i].FieldName)<>nil then
         l_CDS.FieldByName(tmpCDS.Fields[i].FieldName).Value:=tmpCDS.Fields[i].Value;
      l_CDS.FieldByName('checkbox').AsBoolean:=False;
      l_CDS.Post;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;
  CDS2.Data:=l_CDS.Data;
  PCL.ActivePageIndex:=1;
end;

procedure TFrmIPQCT500_mps.BitBtn3Click(Sender: TObject);
var
  i:Integer;
  tmpSQL:string;
  isCheckBox:Boolean;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
  begin
    PCL.ActivePageIndex:=1;
    ShowMsg('無數據!',48);
    Exit;
  end;

  if CDS2.State in [dsInsert,dsEdit] then
  begin
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;

  isCheckBox:=False;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=CDS2.Data;
    while not tmpCDS1.Eof do
    begin
      if tmpCDS1.FieldByName('checkbox').AsBoolean then
      begin
        isCheckBox:=True;
        Break;
      end;
      tmpCDS1.Next;
    end;

    if not isCheckBox then
    begin
      PCL.ActivePageIndex:=1;
      ShowMsg('未選擇單據!',48);
      Exit;
    end;

    if ShowMsg('確定對選中的資料建立備料嗎?',33)=IdCancel then
       Exit;

    tmpSQL:='Select * From IPQC500 Where Bu='+Quotedstr(g_UInfo^.BU);
    if Length(l_Dno)>0 then
       tmpSQL:=tmpSQL+' And Dno in ('+l_Dno+')'
    else
       tmpSQL:=tmpSQL+' And 1=2';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS2.Data:=Data;

    i:=1;
    tmpSQL:=GetSno(g_MInfo^.ProcId);
    if Length(l_Dno)>0 then
       l_Dno:=l_Dno+',';
    l_Dno:=l_Dno+Quotedstr(tmpSQL);
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      if tmpCDS1.FieldByName('checkbox').AsBoolean then
      begin
        tmpCDS2.Append;
        tmpCDS2.FieldByName('Bu').AsString:=g_UInfo^.BU;
        tmpCDS2.FieldByName('Dno').AsString:=tmpSQL;
        tmpCDS2.FieldByName('Ditem').AsInteger:=i;
        tmpCDS2.FieldByName('Sdate').AsDateTime:=Date;
        tmpCDS2.FieldByName('Fiber').AsString:=tmpCDS1.FieldByName('Fiber').AsString;
        tmpCDS2.FieldByName('Breadth').AsString:=tmpCDS1.FieldByName('Breadth').AsString;
        tmpCDS2.FieldByName('Vendor').AsString:=tmpCDS1.FieldByName('Vendor').AsString;
        tmpCDS2.FieldByName('Pno').AsString:=tmpCDS1.FieldByName('Pno').AsString;
        tmpCDS2.FieldByName('Qty').AsFloat:=tmpCDS1.FieldByName('Qty').AsFloat;
        tmpCDS2.FieldByName('Conf').AsBoolean:=False;
        tmpCDS2.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
        tmpCDS2.FieldByName('Idate').AsDateTime:=Now;
        tmpCDS2.Post;
        Inc(i);
      end;
      tmpCDS1.Next;
    end;
    if CDSPost(tmpCDS2, 'IPQC500') then
    begin
      FrmIPQCT500.CDS.Data:=tmpCDS2.Data;
      ShowMsg('建立完畢!',64);
    end;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmIPQCT500_mps.CDS2BeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmIPQCT500_mps.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if SameText(Column.FieldName,'Lock') then
  begin
    CDS.Edit;
    CDS.FieldByName('Lock').AsBoolean:=not CDS.FieldByName('Lock').AsBoolean;
    CDS.Post;
  end;
end;

procedure TFrmIPQCT500_mps.CDSAfterPost(DataSet: TDataSet);
begin
  inherited;
  CDS.MergeChangeLog;
  GetSumQty;
end;

procedure TFrmIPQCT500_mps.BitBtn4Click(Sender: TObject);
var
  isCheck:Boolean;
  dsNE:TDataSetNotifyEvent;
begin
  inherited;
  if (PCL.ActivePageIndex<>0) or (not CDS.Active) then
     Exit;

  isCheck:=TBitBtn(Sender).Tag=0;
  with CDS do
  begin
    dsNE:=CDS.AfterPost;
    CDS.AfterPost:=nil;
    DisableControls;
    try
      First;
      while not Eof do
      begin
        if FieldByName('Lock').AsBoolean<>isCheck then
        begin
          Edit;
          FieldByName('Lock').AsBoolean:=isCheck;
          Post;
        end;
        Next;
      end;
      if ChangeCount>0 then
      begin
        MergeChangeLog;
        GetSumQty;
      end;
    finally
      EnableControls;
      CDS.AfterPost:=dsNE;
    end;
  end;
end;

end.
