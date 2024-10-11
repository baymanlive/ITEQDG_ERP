{*******************************************************}
{                                                       }
{                unORDI130                              }
{                Author: terry                          }
{                Create date: 2016/3/17                 }
{                Description:客戶品名特殊設定           }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unORDI130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBGridEhGrouping, DB, DBClient, MConnect, SConnect, ComObj, Menus,
  ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin,
  StrUtils, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh, unSTDI030,
  ADODB;

type
  TFrmORDI130 = class(TFrmSTDI030)
    BitBtn1: TBitBtn;
    OpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    CDSbu: TStringField;
    CDScustno: TStringField;
    CDSsno: TStringField;
    CDScust_pno: TStringField;
    CDScust_pname: TStringField;
    BitBtn2: TBitBtn;
    CDSCustSpec: TStringField;
    BitBtn3: TBitBtn;
    ORD070: TClientDataSet;
    CDSCustSpec2: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure CDScust_pnameChange(Sender: TField);
    procedure CDSsnoChange(Sender: TField);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont:
      TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }
    function BuildStruct(s: string): string;
    procedure GetCustSpec;
  public
    { Public declarations }
  protected
    procedure SetControls; override;
  end;

var
  FrmORDI130: TFrmORDI130;

implementation

uses
  unGlobal, unCommon;
   
{$R *.dfm}

function TFrmORDI130.BuildStruct(s: string): string;
var
  sl: TStringList;
  cnt: string;
  i: integer;

  procedure bs(sl: TStringList);
  var
    i, j: integer;
  begin
    for i := 0 to sl.Count - 1 do
    begin
      for j := 1 to sl.Count - 1 do
      begin
        if (RightStr(sl[i], 1) = RightStr(sl[j], 1)) and (i <> j) then
        begin
          sl[i] := IntToStr(StrToInt(Copy(sl[i], 1, Length(sl[i]) - 1)) +
            StrToInt(Copy(sl[j], 1, Length(sl[j]) - 1))) + RightStr(sl[i], 1);
          sl.Delete(j);
          bs(sl);
          exit;
        end;
      end;
    end;
  end;

begin
  sl := TStringList.Create;
  try
    for i := 1 to Length(s) do
    begin
      if s[i] in ['0'..'9'] then
        cnt := cnt + s[i]
      else
      begin
        sl.Add(cnt + s[i]);
        cnt := '';
      end;
    end;

    bs(sl);

    s := '';
    for i := 0 to sl.Count - 1 do
    begin
      if ORD070.Locate('CodeName2', RightStr(sl[i], 1), []) then
        s := s + ORD070.fieldbyname('CodeName1').AsString + '*' + Copy(sl[i], 1,
          Length(sl[i]) - 1) + '+';
    end;
    Result := Copy(s, 1, length(s) - 1);

  finally
    sl.Free;
  end;
end;

procedure TFrmORDI130.FormCreate(Sender: TObject);
var
  data: OleVariant;
begin
  p_TableName := 'ORD130';
  p_DBType := g_MSSQL;
  p_SysId := 'Ord';
  p_IsBu := True;

  inherited;
  QueryBySQL(Conn, 'select CodeName2 CodeName1,CodeName CodeName2 from ord070',
    g_MSSQL, data);
  ORD070.data := data;
end;

procedure TFrmORDI130.SetControls;
begin
  inherited;
  BitBtn1.Visible := btn_ok.Visible;
  BitBtn2.Visible := btn_ok.Visible;
  BitBtn3.Visible := btn_ok.Visible;
end;

procedure TFrmORDI130.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  CDS.fieldbyname('BU').Value := g_uinfo^.BU;
  CDS.fieldbyname('sno').Value := EmptyStr;
  CDS.fieldbyname('cust_pno').Value := EmptyStr;
end;

procedure TFrmORDI130.BitBtn1Click(Sender: TObject);
var
  i, j: Integer;
  tmpStr: string;
  tmpList: TStrings;
  ExcelApp: Variant;
  IsFind: Boolean;
begin
  inherited;

  if not OpenDialog1.Execute then
    Exit;

  BitBtn1.Enabled := False;
  Application.ProcessMessages;
  tmpList := TStringList.Create;
  ExcelApp := CreateOleObject('Excel.Application');
  IsFind := false;
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    for i := 1 to ExcelApp.Worksheets[1].UsedRange.Columns.Count do
    begin
      tmpStr := Trim(ExcelApp.Cells[1, i].Value);
//      ShowMessage(tmpStr);
      if tmpStr <> '' then
        for j := 0 to CDS.FieldCount - 1 do
          if (CDS.Fields[j].DisplayLabel = tmpStr) then
          begin
            tmpList.Add(IntToStr(j));
            IsFind := True;
            Break;
          end;

      if not IsFind then
        tmpList.Add('-1');
    end;

    if tmpList.Count = 0 then
    begin
      ShowMsg('Excel無欄位,請檢查Excel檔案第一行的欄位名稱是否正確!', 48);
      Exit;
    end;

    ProgressBar1.Position := 0;
    ProgressBar1.Max := ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    ProgressBar1.Visible := True;
    i := 2;

    while i <> 0 do
    begin
      ProgressBar1.Position := ProgressBar1.Position + 1;

      CDS.Append;
      for j := 0 to tmpList.Count - 1 do
        if tmpList.Strings[j] <> '-1' then
          CDS.Fields[StrToInt(tmpList.Strings[j])].asstring := ExcelApp.Cells[i,
            j + 1].value;

      Inc(i);
 

      //下一列全為空值,退出
      for j := 0 to tmpList.Count - 1 do
        if VarToStr(ExcelApp.Cells[i, j + 1].Value) <> '' then
          Break;
      if j >= tmpList.Count then
        i := 0;
    end;
  finally
    ProgressBar1.Visible := False;
    BitBtn1.Enabled := True;
    tmpList.Free;
    ExcelApp.Quit;
  end;
end;

procedure TFrmORDI130.BitBtn2Click(Sender: TObject);
var
  s: string;
  data: OleVariant;
begin
  inherited;
  if InputQuery('請輸入要刪除的資料的客戶編號', '', s) then
  begin
    s := 'delete from ORD130 where bu=' + QuotedStr(g_uinfo^.BU) +
      ' and custno=' + QuotedStr(s) + ';select 1';
    QueryBySQL(Conn, s, g_MSSQL, data);
  end;

end;

procedure TFrmORDI130.GetCustSpec;
var
  s: string;
  ls: TStrings;
  i, idx: integer;
begin
  inherited;
  if CDScustno.AsString <> 'AC111' then
    exit;
  if CDSsno.AsString = '' then
    exit;
  if (CDSsno.AsString[1] in ['E', 'T']) then
  begin
    ls := TStringList.Create;
    try
      ls.Delimiter := ' ';
      ls.DelimitedText := CDScust_pname.AsString;
      idx := -1;
      for i := 0 to ls.Count - 1 do
      begin
        if Pos('IT', ls[i]) > 0 then
          idx := i;
      end;
      Dec(idx);
      if idx - 1 > 0 then
      begin
        s := ls[idx];
        cds.edit;
        CDSCustSpec.AsString := BuildStruct(s);
      end;
    finally
      ls.Free;
    end;
  end;
end;

procedure TFrmORDI130.BitBtn3Click(Sender: TObject);
var
  s: string;
  ls: TStrings;
  i, idx: integer;
begin
  inherited;
  CDS.first;
  while not cds.Eof do
  begin
    if (CDScustno.AsString = 'AC111') and (CDSsno.AsString <> '') and (CDSsno.AsString
      [1] in ['E', 'T']) then
    begin
      ls := TStringList.Create;
      try
        ls.Delimiter := ' ';
        ls.DelimitedText := CDScust_pname.AsString;
        idx := -1;
        for i := 0 to ls.Count - 1 do
        begin
          if Pos('IT', ls[i]) > 0 then
            idx := i;
        end;
        Dec(idx);
        if idx - 1 > 0 then
        begin
          s := ls[idx];
          cds.edit;
          CDSCustSpec.AsString := BuildStruct(s);
        end;
      finally
        ls.Free;
      end;
    end;
    CDSsnoChange(nil);
    CDS.next;
  end;

end;

procedure TFrmORDI130.CDScust_pnameChange(Sender: TField);
begin
  inherited;
  GetCustSpec;
end;

procedure TFrmORDI130.CDSsnoChange(Sender: TField);
var
  s: string;
  zt: Char;
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  inherited;
  if CDScustno.AsString <> 'AC111' then
    exit;
  if not (CDSsno.AsString[1] in ['E', 'T']) then
    Exit;
  zt := ' ';
  if Length(CDSsno.AsString) = 16 then
    zt := CDSsno.AsString[15]
  else if Length(CDSsno.AsString) = 11 then
    zt := CDSsno.AsString[9];
  if zt = ' ' then
    exit;
  s :=
    'select structure from quo010 a inner join ORD150 b on a.Adhesive=''IT''+b.pname' + ' where firstcode='
    + QuotedStr(CDSsno.AsString[2]) + ' and stcode=' + QuotedStr(zt) +
    ' and mil=' + floattostr(strtofloatdef(copy(CDSsno.AsString, 3, 4), 0) / 10);
//     ShowMessage(s);
  QueryBySQL(Conn, s, g_MSSQL, data);
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := data;
    cds.edit;
    CDSCustSpec2.Value := tmpCDS.Fields[0].AsString;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmORDI130.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if (CDScustno.AsString = 'AC111') and (CDSsno.AsString<>'') and (CDSsno.AsString[1] in ['E', 'T']) and (CDSCustSpec2.AsString
    <> CDSCustSpec.AsString) then
    Background := clRed;

end;

end.

