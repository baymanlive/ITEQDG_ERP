unit unQuery;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, Menus, ExtCtrls, ToolWin, StdCtrls, unFrmBaseEmpty,
  Buttons, DB, DBClient, Mask, DBCtrls, GridsEh, DBGridEh,
  unGlobal, unCommon, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DBAxisGridsEh, AppEvnts, StrUtils, unDAL;

type
  TFrmQuery = class(TFrmBaseEmpty)
    ToolBar: TToolBar;
    PCL: TPageControl;
    queryObj: TTabSheet;
    btn_insert: TToolButton;
    btn_edit: TToolButton;
    btn_delete: TToolButton;
    ToolButton3: TToolButton;
    DS: TDataSource;
    CDS: TClientDataSet;
    DBGridEh1: TDBGridEh;
    LB: TListBox;
    MonthCalendar1: TMonthCalendar;
    ApplicationEvents1: TApplicationEvents;
    Panel1: TPanel;
    btn_postobj: TToolButton;
    btn_deleteobj: TToolButton;
    PnlRight: TPanel;
    btn_ok: TBitBtn;
    btn_quit: TBitBtn;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSAfterCancel(DataSet: TDataSet);
    procedure CDSAfterEdit(DataSet: TDataSet);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure btn_okClick(Sender: TObject);
    procedure CDSAfterInsert(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure LBClick(Sender: TObject);
    procedure MonthCalendar1Click(Sender: TObject);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure btn_postobjClick(Sender: TObject);
    procedure btn_deleteobjClick(Sender: TObject);
  private
    l_Edit:Boolean;
    l_MS:TMemoryStream;
    procedure SetControls;
    procedure SetPickList;
    procedure SetLB;
    function GetCDSSQL: string;
    procedure GetUserObj(xIndex: Integer);
    procedure SetMonthCalendar(Bool: Boolean);
    function CheckData(Value, vType:string; out Err:string):Integer;
    function ConvertDate(Value:string; var D:TDateTime):Boolean;
    function FormatYYYYMMDD(D:TDateTime):string;
    { Private declarations }
  public
    ResultSQL:string;
    { Public declarations }
  end;

var
  FrmQuery: TFrmQuery;

implementation

Const l_QueryCDSXML='<?xml version="1.0" standalone="yes"?>'
                   +'<DATAPACKET Version="2.0">'
                   +'<METADATA>'
                   +'<FIELDS>'
                   +'<FIELD attrname="Caption" fieldtype="string.uni" WIDTH="100" />'
                   +'<FIELD attrname="FieldName" fieldtype="string.uni" WIDTH="100" />'
                   +'<FIELD attrname="TypeName" fieldtype="string.uni" WIDTH="100" />'
                   +'<FIELD attrname="Expr" fieldtype="string.uni" WIDTH="100" />'
                   +'<FIELD attrname="Expr1" fieldtype="string.uni" WIDTH="100" />'
                   +'<FIELD attrname="Value" fieldtype="string.uni" WIDTH="100" />'
                   +'</FIELDS><PARAMS/>'
                   +'</METADATA>'
                   +'<ROWDATA>'
                   +'</ROWDATA>'
                   +'</DATAPACKET>';
Const l_QueryExpr='等於,不等於,大於,大於等於,小於,小於等於,前匹配,後匹配,任意匹配';
Const l_QueryExpr1='=,<>,>,>=,<,<=,Like,Like,Like';
Const l_Type1='tinyint,smallint,int,real,money,decimal,numeric,smallmoney,bigint,float';
Const l_Type2='varchar,char,nvarchar,nchar';
Const l_Type3='smalldatetime,datetime';
Const l_Type4='bit';
Const l_Type5='ora_date';

{$R *.dfm}

procedure TFrmQuery.SetControls;
var
  cdsState_bo:Boolean;
begin
  if l_Edit then
     Exit;

  cdsState_bo:=not (CDS.State in [dsInsert,dsEdit]);
  btn_insert.Enabled := true;
  btn_edit.Enabled := cdsState_bo and (not CDS.IsEmpty);
  btn_delete.Enabled := not CDS.IsEmpty;
end;

procedure TFrmQuery.SetLB;
var
  tmpCDS:TClientDataSet;
  i,fIndex:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  fIndex:=-1;
  LB.Clear;
  tmpSQL:='Select Iuser From Sys_QueryObj'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And ProcId='+Quotedstr(g_MInfo^.ProcId)
         +' And Tablename='+Quotedstr(g_MInfo^.ProcName);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    i:=0;
    LB.Items.BeginUpdate;
    while not tmpCDS.Eof do
    begin
      LB.Items.Add(tmpCDS.Fields[0].AsString);

      if SameText(tmpCDS.Fields[0].AsString,g_UInfo^.UserId) then
      begin
        fIndex:=i;
        btn_deleteobj.Enabled:=True;
      end;

      Inc(i);
      tmpCDS.Next;
    end;
    LB.Items.EndUpdate;
    if fIndex<>-1 then
    begin
      LB.Selected[fIndex]:=True;
      GetUserObj(fIndex);
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//取使用者方案
procedure TFrmQuery.GetUserObj(xIndex:Integer);
var
  tmpCDS:TClientDataSet;
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select Top 1 QueryObj From Sys_QueryObj'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And ProcId='+Quotedstr(g_MInfo^.ProcId)
         +' And Tablename='+Quotedstr(g_MInfo^.ProcName)
         +' And Iuser='+Quotedstr(LB.Items.Strings[xIndex]);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty or tmpCDS.Fields[0].IsNull then
       CDS.EmptyDataSet
    else
    begin
      l_Edit:=True;
      l_MS.Clear;
      TBlobField(tmpCDS.Fields[0]).SaveToStream(l_MS);
      l_MS.Position:=0;
      CDS.LoadFromStream(l_MS);
      CDS.DisableControls;
      while not CDS.Eof do
      begin
        if DBGridEh1.FieldColumns['Caption'].PickList.IndexOf(CDS.FieldByName('Caption').AsString)=-1 then
           CDS.Delete
        else begin
          CDS.Edit;
          CDS.FieldByName('Value').Clear;
          CDS.Post;
          CDS.Next;
        end;
      end;
      CDS.EnableControls;
      l_Edit:=False;
    end;

    SetControls;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmQuery.SetPickList;
var
  tmpCDS:TClientDataSet;
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:=Quotedstr(g_MInfo^.ProcName);
  tmpSQL:='IF NOT EXISTS (SELECT 1 FROM Sysobjects'
         +' WHERE [Name] = '+tmpSQL+' AND xtype = ''U'')'
         +' SELECT FieldName, Caption, TypeName FROM Sys_TableDetail'
         +' WHERE TableName = '+tmpSQL+' AND IsQuery = 1'
         +' ELSE SELECT A.FieldName, A.Caption, ISNULL(B.TypeName, ''bit'') AS TypeName'
         +' FROM (SELECT FieldName, Caption FROM Sys_TableDetail'
         +' WHERE TableName = '+tmpSQL+' AND IsQuery = 1) A LEFT OUTER JOIN'
         +' (SELECT A.name AS FieldName, LOWER(B.name) AS TypeName'
         +' FROM syscolumns AS A INNER JOIN systypes AS B'
         +' ON A.xusertype = B.xusertype WHERE (A.id = OBJECT_ID('+tmpSQL+'))) B'
         +' ON A.FieldName = B.FieldName';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    while not tmpCDS.Eof do
    begin
      DBGridEh1.FieldColumns['FieldName'].PickList.Add(tmpCDS.Fields[0].AsString);
      DBGridEh1.FieldColumns['Caption'].PickList.Add(tmpCDS.Fields[1].AsString);
      DBGridEh1.FieldColumns['TypeName'].PickList.Add(tmpCDS.Fields[2].AsString);
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;

  DBGridEh1.FieldColumns['Expr'].PickList.DelimitedText:=CheckLang(l_QueryExpr);
  DBGridEh1.FieldColumns['Expr1'].PickList.DelimitedText:=l_QueryExpr1;
  DBGridEh1.FieldColumns['FieldName'].Visible:=False;
  DBGridEh1.FieldColumns['Expr1'].Visible:=False;
  DBGridEh1.FieldColumns['TypeName'].Visible:=False;
end;

//目標sql條件
function TFrmQuery.GetCDSSQL:string;
var
  fDate:TDateTime;
  fIndex,fType:Integer;
  fName,fValue,fExpr:string;
begin
  Result:='';
  with CDS do
  if not IsEmpty then
  begin
    DisableControls;
    try
      First;
      while not Eof do
      begin
        fValue:=FieldByName('Value').AsString;
        if Trim(fValue)<>'' then
        begin
          fName:=FieldByName('Caption').AsString;
          fIndex:=DBGridEh1.FieldColumns['Caption'].PickList.IndexOf(fName);
          fName:=DBGridEh1.FieldColumns['FieldName'].PickList.Strings[fIndex];

          fType:=CheckData(fValue, DBGridEh1.FieldColumns['TypeName'].PickList.Strings[fIndex], fExpr);
          if Length(fExpr)>0 then
          begin
            DBGridEh1.SetFocus;
            DBGridEh1.SelectedIndex:=2;
            if fType<>-1 then
               ShowMsg('[%s]'+fExpr, 48, fValue)
            else
               ShowMsg(fExpr, 48);
            Abort;
          end;

          fExpr:=FieldByName('Expr').AsString;
          fIndex:=DBGridEh1.FieldColumns['Expr'].PickList.IndexOf(fExpr);
          if fIndex=6 then
             Result:=Result+' And ('+fName+' Like '+QuotedStr(fValue+'%')+')'
          else
          if fIndex=7 then
             Result:=Result+' And ('+fName+' Like '+QuotedStr('%'+fValue)+')'
          else
          if fIndex=8 then
             Result:=Result+' And ('+fName+' Like '+QuotedStr('%'+fValue+'%')+')'
          else begin
            fExpr:=DBGridEh1.FieldColumns['Expr1'].PickList.Strings[fIndex];
            if fType=1 then
               Result:=Result+' And ('+fName+fExpr+fValue+')'
            else if fType=2 then
               Result:=Result+' And ('+fName+fExpr+QuotedStr(fValue)+')'
            else if fType=3 then
            begin
              if ConvertDate(fValue, fDate) then
                 Result:=Result+' And (Convert(varchar(10),'+fName+',111)'+fExpr+
                         QuotedStr(FormatYYYYMMDD(fDate))+')'
              else begin
                ShowMsg('[%s]不是有效的日期格式!', 48, fValue);
                Abort;
              end;
            end
            else if fType=5 then
            begin
              if ConvertDate(fValue, fDate) then
                 Result:=Result+' And '+fName+fExpr+'to_date('+
                         QuotedStr(FormatYYYYMMDD(fDate))+',''yyyy/mm/dd'')'
              else begin
                ShowMsg('[%s]不是有效的日期格式!', 48, fValue);
                Abort;
              end;
            end else if fType=4 then
               Result:=Result+' And ('+fName+fExpr+fValue+')';
          end;
        end;
        Next;
      end;
    finally
      EnableControls;
    end;
  end;
end;

//日歷
procedure TFrmQuery.SetMonthCalendar(Bool:Boolean);
var
  fDate:TDateTime;
  Rect:TRect;
begin
  if Bool then
  begin
    if ConvertDate(CDS.FieldByName('Value').AsString, fDate) then
       MonthCalendar1.Date:=fDate
    else
       MonthCalendar1.Date:=Date;
    Rect:= DBGridEh1.CellRect(DBGridEh1.Col, DBGridEh1.Row);
    MonthCalendar1.Left:=DBGridEh1.Left+Rect.Left-40;
    MonthCalendar1.Top:=PCL.Top+DBGridEh1.Top+Rect.Bottom+30;

    MonthCalendar1.Visible:=True;
  end else
    MonthCalendar1.Visible:=False;
end;

//檢查輸入數據與類型是否匹配
function TFrmQuery.CheckData(Value, vType:string; out Err:string):Integer;
var
  fDate:TDateTime;
begin
  Result:=-1;
  Err:='';
  if Pos(vType, l_Type1)>0 then
  begin
    Result:=1;
    try
      StrToInt(Value);
    except
      Err:='不是有效的數字!';
    end;
  end
  else if (Pos(vType, l_Type3)>0)  then
  begin
    Result:=3;
    if not ConvertDate(Value, fDate) then
       Err:='不是有效的日期格式:yyyy/m/d';
  end
  else if (Pos(vType, l_Type5)>0) then
  begin
    Result:=5;
    if not ConvertDate(Value, fDate) then
       Err:='不是有效的日期格式:yyyy/m/d';
  end
  else if Pos(vType, l_Type2)>0 then
    Result:=2
  else if Pos(vType, l_Type4)>0 then
  begin
    Result:=4;
    if (Value<>'0') and (Value<>'1') then
       Err:='不是有效的布爾類型,請輸入0或1';
  end
  else
    Err:='此欄位不可查詢!';
end;

//檢查日期格式
function TFrmQuery.ConvertDate(Value:string; var D:TDateTime):Boolean;
var
  pos1:Integer;
  year1,month1,day1:Word;
  sp,str:string;
begin
  D:=EncodeDate(1912,1,1);
  Result:=False;

  sp:='/';
  str:=Value;
  pos1:=Pos(sp, str);
  if pos1=0 then
  begin
    sp:='-';
    pos1:=Pos(sp, str);
  end;

  if pos1=0 then
     Exit;

  year1:=StrToIntDef(Copy(str, 1, Pos1-1),-1);
  if (year1>2079) or (year1<1912) then
     Exit;

  str:=Copy(str, Pos1+1, 20);
  pos1:=Pos(sp, str);
  if pos1=0 then
     Exit;

  month1:=StrToIntDef(Copy(str, 1, Pos1-1), -1);
  if (month1>12) or (month1<1) then
     Exit;

  day1:=StrToIntDef(Copy(str, Pos1+1, 20), -1);
  if (day1>31) or (day1<1) then
     Exit;

  try
    D:=EncodeDate(year1,month1,day1);
    Result:=True;
  except
    D:=EncodeDate(1912,1,1);
  end;
end;

function TFrmQuery.FormatYYYYMMDD(D:TDateTime):string;
var
  year1,month1,day1:Word;
begin
  DecodeDate(D,year1,month1,day1);
  Result:=IntToStr(year1)+'/'+
    RightStr('0'+IntToStr(month1),2)+'/'+
    RightStr('0'+IntToStr(day1),2);
end;

procedure TFrmQuery.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  SetLength(g_DAL,Length(g_ConnData));
  for i:=Low(g_ConnData) to High(g_ConnData) do
    g_DAL[i]:=TDAL.Create(g_UInfo^.UserId, g_ConnData[i].DBtype, g_ConnData[i].ADOConn);
  l_MS:=TMemoryStream.Create;
  InitCDS(CDS,l_QueryCDSXML);
  SetLabelCaption(Self, '@');
  SetGrdCaption(DBGridEh1, 'FrmQuery');
  SetPickList;
  SetLB;
  SetControls;
  StatusBar1.Panels[1].Text:=CheckLang('若日期不能選擇,請手動輸入,格式:yyyy/mm/dd');
end;

procedure TFrmQuery.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i:Integer;
begin
  DBGridEh1.Free;
  FreeAndNil(l_MS);
  for i:=Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);
  ApplicationEvents1.Free;
end;

procedure TFrmQuery.CDSNewRecord(DataSet: TDataSet);
begin
  if DBGridEh1.FieldColumns['Caption'].PickList.Count>0 then
     DataSet.FieldByName('Caption').AsString:=DBGridEh1.FieldColumns['Caption'].PickList.Strings[0];
  DataSet.FieldByName('Expr').AsString:=DBGridEh1.FieldColumns['Expr'].PickList.Strings[0];
end;

procedure TFrmQuery.CDSAfterInsert(DataSet: TDataSet);
begin
  SetControls;
end;

procedure TFrmQuery.CDSAfterCancel(DataSet: TDataSet);
begin
  SetControls;
end;

procedure TFrmQuery.CDSAfterEdit(DataSet: TDataSet);
begin
  SetControls;
end;

procedure TFrmQuery.CDSAfterScroll(DataSet: TDataSet);
begin
  if DataSet.State=dsBrowse then  //AfterInsert, AfterCancel
     SetControls;
end;

procedure TFrmQuery.CDSAfterPost(DataSet: TDataSet);
begin
  SetControls;
end;

procedure TFrmQuery.CDSBeforePost(DataSet: TDataSet);
var
  tmpStr:string;
begin
  if l_Edit then
     Exit;

  tmpStr:=DataSet.FieldByName('Caption').AsString;
  if DBGridEh1.FieldColumns['Caption'].PickList.IndexOf(tmpStr)=-1 then
  begin
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedIndex:=0;
    ShowMsg('請選擇[%s]', 48, DBGridEh1.FieldColumns['Caption'].Title.Caption);
    Abort;
  end;

  tmpStr:=DataSet.FieldByName('Expr').AsString;
  if DBGridEh1.FieldColumns['Expr'].PickList.IndexOf(tmpStr)=-1 then
  begin
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedIndex:=1;
    ShowMsg('請選擇[%s]', 48, DBGridEh1.FieldColumns['Expr'].Title.Caption);
    Abort;
  end;
end;

procedure TFrmQuery.DBGridEh1EditButtonClick(Sender: TObject);
var
  tmpBool:Boolean;
  tmpIndex:Integer;
  tmpStr:string;
begin       
  tmpBool:=not CDS.IsEmpty;
  if tmpBool then
  begin
    tmpIndex:=DBGridEh1.FieldColumns['Caption'].PickList.IndexOf(CDS.FieldByName('Caption').AsString);
    if tmpIndex<>-1 then
    begin
      tmpStr:=DBGridEh1.FieldColumns['TypeName'].PickList.Strings[tmpIndex];
      tmpBool:=(Pos(tmpStr, l_Type3)>0)or(Pos(tmpStr, l_Type5)>0) ;
    end;
  end;

  if tmpBool then
     SetMonthCalendar(True);
end;

procedure TFrmQuery.MonthCalendar1Click(Sender: TObject);
begin
  CDS.Edit;
  CDS.FieldByName('Value').AsString:=DateToStr(MonthCalendar1.Date);
  CDS.Post;
end;

procedure TFrmQuery.btn_okClick(Sender: TObject);
begin
  if CDS.State in [dsEdit, dsInsert] then
     CDS.Post;

  ResultSQL:=GetCDSSQL;
  ModalResult:=mrOk;
end;

procedure TFrmQuery.btn_quitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmQuery.LBClick(Sender: TObject);
begin
  if LB.ItemIndex<>-1 then
     GetUserObj(LB.ItemIndex);
end;

procedure TFrmQuery.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if ((Msg.Message = WM_LBUTTONDOWN) or (Msg.Message = WM_KEYDOWN)) and
     (Msg.hwnd<>MonthCalendar1.Handle) then
     SetMonthCalendar(False);
end;

procedure TFrmQuery.btn_insertClick(Sender: TObject);
begin
  if CDS.State in [dsInsert,dsEdit] then
     CDS.Post;
  CDS.Append;
end;

procedure TFrmQuery.btn_editClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可更改!', 48)
  else
     CDS.Edit;
end;

procedure TFrmQuery.btn_deleteClick(Sender: TObject);
begin
  if CDS.IsEmpty then
     ShowMsg('無資料可刪除!', 48)
  else
     CDS.Delete;
end;

procedure TFrmQuery.btn_postobjClick(Sender: TObject);
var
  bo:Boolean;
  i:integer;
  tmpCDS:TClientDataSet;
  tmpSQL:string;
  Data:OleVariant;
begin
  if CDS.State in [dsInsert, dsEdit] then
     CDS.Post;
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料可更改!',48);
    Exit;
  end;

  tmpSQL:='Select * From Sys_QueryObj'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And ProcId='+Quotedstr(g_MInfo^.ProcId)
         +' And Tablename='+Quotedstr(g_MInfo^.ProcName)
         +' And Iuser='+Quotedstr(g_UInfo^.UserId);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      tmpCDS.Append;
      tmpCDS.FieldByName('Bu').AsString:=g_UInfo^.BU;
      tmpCDS.FieldByName('ProcId').AsString:=g_MInfo^.ProcId;
      tmpCDS.FieldByName('Tablename').AsString:=g_MInfo^.ProcName;
      tmpCDS.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
    end else
      tmpCDS.Edit;

    tmpCDS.FieldByName('Idate').AsDateTime:=Now;
    l_MS.Clear;
    CDS.SaveToStream(l_MS);
    l_MS.Position:=0;
    TBlobField(tmpCDS.FieldByName('QueryObj')).LoadFromStream(l_MS);
    if CDSPost(tmpCDS, 'Sys_QueryObj') then
    begin
      bo:=False;                               
      for i:=0 to LB.Items.Count-1 do
      begin
        if SameText(g_UInfo^.UserId,LB.Items.Strings[i]) then
        begin
          bo:=True;
          Break;
        end;
      end;

      if not bo then
         LB.Items.Add(g_UInfo^.UserId);

      btn_deleteobj.Enabled:=True;
      ShowMsg('儲存成功!',64);
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmQuery.btn_deleteobjClick(Sender: TObject);
var
  tmpSQL:string;
begin
  if ShowMsg('確定要刪除自己的查詢方案嗎?',33)=IDCancel then
     Exit;

  tmpSQL:='Delete From Sys_QueryObj'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And ProcId='+Quotedstr(g_MInfo^.ProcId)
         +' And Tablename='+Quotedstr(g_MInfo^.ProcName)
         +' And Iuser='+Quotedstr(g_UInfo^.UserId);
  if PostBySQL(tmpSQL) then
     btn_deleteobj.Enabled:=False;
end;

end.
