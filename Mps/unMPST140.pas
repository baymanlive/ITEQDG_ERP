unit unMPST140;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI080, ExtCtrls, StdCtrls,
  ImgList, ComCtrls, ToolWin, DBClient, StrUtils, jpeg, DB, ScktComp;

type
  TFrmMPST140 = class(TFrmSTDI080)
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    pnlbg: TPanel;
    Label2: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Image2: TImage;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Image3: TImage;
    Label3: TLabel;
    Image5: TImage;
    Label16: TLabel;
    Image6: TImage;
    Label4: TLabel;
    Label13: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ToolButton2: TToolButton;
    Memo1: TMemo;
    ToolButton3: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure ToolButton3Click(Sender: TObject);
  private
    l_Ans: Boolean;
    l_CDS: TClientDataSet;
    Server: TServerSocket;
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    function GetOao06(cds: TDataset): string;
    function CheckNpi(wono: string): boolean;
    procedure SetRichEdit(xSourceStr: string);
    procedure AssignJpg(fn: TField; ctl: TImage);
    procedure mps103(tmpPno: string);
    procedure mps104(tmpCustno: string);
    procedure lbl470(tmpPno: string);
    procedure daojiao(tmpWono: string);
    function GetCustInfo(barcode: string; var custno, custname: string): boolean;
    procedure clear;
  public    { Public declarations }
  end;

var
  FrmMPST140: TFrmMPST140;

implementation

uses
  unGlobal, unCommon;

const
  l_CopperALL = 'QTH1AS2BP34567';               //銅厚大小排列
{$R *.dfm}

procedure TFrmMPST140.AssignJpg(fn: TField; ctl: TImage);
var
  jpg: TJPEGImage;
  bmp: TBitmap;
  ms: TMemoryStream;
begin
  jpg := TJPEGImage.Create;
  ms := TMemoryStream.Create;
  bmp := TBitmap.Create;

  try
    try
      TBlobField(fn).SaveToStream(ms);
      ms.Position := 0;
      jpg.LoadFromStream(ms);
      bmp.Assign(jpg);
      ctl.Picture.Assign(bmp);
    finally
      bmp.free;
      jpg.free;
      ms.Free;
    end;
  except
  end;
end;

procedure TFrmMPST140.SetRichEdit(xSourceStr: string);
var
  pos1: Integer;
  tmpStr: WideString;
  tmpValue: string;
begin
  tmpStr := Trim(xSourceStr) + '|';
  pos1 := Pos('|', tmpStr);
  while pos1 > 0 do
  begin
    tmpValue := Trim(LeftStr(tmpStr, pos1 - 1));

    tmpStr := Copy(tmpStr, pos1 + 1, 1024);
    pos1 := Pos('|', tmpStr);
  end;
end;

procedure TFrmMPST140.FormCreate(Sender: TObject);
begin
  p_TableName := '@';

  inherited;

  btn_print.Visible := False;
  btn_export.Visible := False;
  btn_query.Visible := False;

  btn_query.Caption := CheckLang('生產進度更新');
  Label1.Caption := CheckLang('制令掃描');
  Label2.Caption := CheckLang('標籤掃描');
  Label3.Caption := CheckLang('圓角要求：');
  Label4.Caption := CheckLang('製令單號：');
  Label5.Caption := CheckLang('客戶：');
  Label6.Caption := CheckLang('料號：');
  Label7.Caption := CheckLang('整包數量：');
  Label8.Caption := CheckLang('棧板類型：');
  Label9.Caption := CheckLang(''); //棧板類型：');
  Label10.Caption := CheckLang('大標籤顏色：');
  Label11.Caption := CheckLang('大標籤張貼位置：');
  Label12.Caption := CheckLang('小標籤類型：');
  Label13.Caption := CheckLang('其他注意事項：');
  Label14.Caption := CheckLang('');
  Label15.Caption := CheckLang('');
  Label16.Caption := CheckLang('激光打標：');
  Label17.Caption := CheckLang('');
  Label18.Caption := CheckLang('');
  l_CDS := TClientDataSet.Create(Self);
  Server := TServerSocket.Create(self);
  Server.Port := 4123;
  Server.Active := true;
  Server.OnClientRead := ServerSocketClientRead;
end;

procedure TFrmMPST140.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  received,tmpWono: string;
  ch: char;
begin
  ch := Char(13);
  received := Socket.ReceiveText;
  if Length(received) = 10 then
  begin
    Edit3.Text := received;
    GetCustInfo(Edit3.Text, tmpWono, tmpWono);
//    Edit3KeyPress(nil, ch);
  end
  else
  begin
    Edit4.text := received;
    Edit4KeyPress(nil, ch);
  end;
end;

procedure TFrmMPST140.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  l_Ans := True;
  FreeAndNil(l_CDS);
  Server.Free;
end;

procedure TFrmMPST140.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if ShowMsg('確定更新嗎?', 33) = IDOK then
    if PostBySQL('exec dbo.proc_UpdateWostation ' + QuotedStr(g_UInfo^.BU)) then
      ShowMsg('更新完畢', 64);
end;

procedure TFrmMPST140.FormResize(Sender: TObject);
begin
  inherited;
  if l_Ans then
    Exit;
//  RichEdit1.Height := PnlBottom.Top - RichEdit1.Top - 50;
//  RichEdit2.Width := Self.ClientWidth - RichEdit2.Left - 30;
//  RichEdit2.Height := PnlBottom.Top - RichEdit2.Top - 50;
//  pnlbg.Top := RichEdit2.Top + RichEdit2.Height + 5;
//  pnlfont.Top := pnlbg.Top;
end;

procedure TFrmMPST140.Edit4KeyPress(Sender: TObject; var Key: Char);
var
  isBool: Boolean;
  tmpWono, tmpCustno, realCustno, realCustName, tmpPno, tmpCode, tmpSQL, oao06, barcode: string;
  Data: OleVariant;
  lot: string;
  ls: TStringList;
begin
  inherited;
  if Key <> #13 then
    Exit;
  barcode := Trim(Edit4.Text);

  ls := TStringList.Create;
  try
    ls.Delimiter := ';';
    ls.DelimitedText := Trim(Edit4.Text);

    if ls.Count < 21 then
    begin
      Label4.caption := CheckLang('請掃描外箱標籤');
      Label4.Font.Color := clRed;
      Edit4.text := '';
      if Edit4.CanFocus then
        Edit4.SetFocus;
      exit;
    end;

    if Trim(Edit3.Text) <> ls[0] then
    begin
      Label4.caption := CheckLang('製令單號不匹配');
      Label4.Font.Color := clRed;
      Exit;
    end;

    lot := ls[2];
  finally
    ls.free;
  end;

  tmpWono := Trim(Edit3.Text);
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := 'Y'
  else
    tmpSQL := 'N';

//  tmpSQL := 'exec [dbo].[proc_UpdateBZTime] ' + QuotedStr(tmpSQL) + ',' + QuotedStr(tmpWono);
//  if not QueryOneCR(tmpSQL, Data) then
//    Exit;

  Edit3.Text := '';
  Edit4.Text := '';
  Label15.Caption := '';

  Data := Null;                    
  {(*}
  tmpSQL := 'select oea01,oea04,sfb05,occ02,oeb03 from sfb_file,oea_file,occ_file,oeb_file where ' +
            'sfb22=oea01 and oea04=occ01 and oea01=oeb01 and sfb221=oeb03 and sfb01=' + QuotedStr(tmpWono);
  {*)}
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
    Exit;
  l_CDS.Data := Data;
  if l_CDS.IsEmpty then
  begin
    Exit;
  end;

  tmpCustno := l_CDS.FieldByName('oea04').AsString;
//  oao06 := GetOao06(l_CDS);
//  if LeftStr(tmpCustno, 1) = 'N' then
//    realCustno := LeftStr(oao06, 5)
//  else
//    realCustno := tmpCustno;
  tmpPno := l_CDS.FieldByName('sfb05').AsString;

//  if tmpCustno = 'AC121' then
//    NPI.Visible := CheckNpi(tmpWono);

  Label4.Caption := CheckLang('製令單號：') + tmpWono;
  Label4.Font.Color := clGreen;
  if not GetCustInfo(barcode, realCustno, realCustName) then
    exit;
  Label5.Caption := CheckLang('客戶：') + tmpCustno + '/' + realCustno + '/' + realCustName;
  Label6.Caption := CheckLang('產品料號：') + tmpPno;

  pnlbg.Color := Self.Color;

  Data := Null;
  tmpSQL := 'select top 1 * from mps101 where bu=' + QuotedStr(g_UInfo^.BU) + ' and (charindex(' + QuotedStr('/' +
    tmpCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' + ' order by custno desc';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  SetRichEdit(CheckLang('標籤張貼位置'));

  l_CDS.Data := Data;
  if l_CDS.IsEmpty then
  begin
    SetRichEdit(CheckLang('未設定'));
    Label15.caption := ('未設定');
  end
  else
  begin
//    AssignJpg(l_CDS.fieldbyname('img'), Image2);
//    Label15.caption := (l_CDS.fieldbyname('value').AsString);

    if Length(tmpPno) in [11, 19] then
    begin
      AssignJpg(l_CDS.fieldbyname('img3'), Image2);
//      AssignJpg(l_CDS.fieldbyname('img4'), Image4);
      Label15.caption := (l_CDS.fieldbyname('value2').AsString);
    end
    else
    begin
      AssignJpg(l_CDS.fieldbyname('img'), Image2);
//      AssignJpg(l_CDS.fieldbyname('img2'), Image4);
      Label15.caption := (l_CDS.fieldbyname('value').AsString);
    end;
  end;

  //mps102
  isBool := False;
  tmpCode := Copy(tmpPno, 2, 1);
  Data := Null;                   
  {(*}
  tmpSQL := 'select custno,ad,value,img from mps102 where bu=' + QuotedStr(g_UInfo^.BU) +
            ' and (charindex(' + QuotedStr('/' + realCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' +
            ' and (ad like ' + QuotedStr('%' + tmpCode + '%') + ' or ad=''*'')' + ' order by custno desc,ad desc';
  {*)}
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  SetRichEdit('');
  SetRichEdit(CheckLang('小標籤張貼類型'));
  l_CDS.Data := Data;
  if not l_CDS.IsEmpty then
  begin
    l_CDS.First;
    while not l_CDS.Eof do
    begin
      if (Pos('/' + realCustno + '/', '/' + l_CDS.Fields[0].AsString + '/') > 0) and (Pos(tmpCode, l_CDS.Fields[1].AsString)
        > 0) then
      begin
        isBool := True;
        SetRichEdit(l_CDS.Fields[2].AsString);
        Label14.Caption := (l_CDS.Fields[2].AsString);
        AssignJpg(l_CDS.Fields[3], Image3);
        Break;
      end;
      l_CDS.Next;
    end;

    if not isBool then
    begin
      l_CDS.First;
      while not l_CDS.Eof do
      begin
        if (Pos('/' + realCustno + '/', '/' + l_CDS.Fields[0].AsString + '/') > 0) and (l_CDS.Fields[1].AsString = '*')
          then
        begin
          isBool := True;
          SetRichEdit(l_CDS.Fields[2].AsString);
          Label14.Caption := (l_CDS.Fields[2].AsString);
          AssignJpg(l_CDS.Fields[3], Image3);
          Break;
        end;
        l_CDS.Next;
      end;
    end;

    if not isBool then
    begin
      l_CDS.First;
      while not l_CDS.Eof do
      begin
        if (l_CDS.Fields[0].AsString = '*') and (Pos(tmpCode, l_CDS.Fields[1].AsString) > 0) then
        begin
          isBool := True;
          SetRichEdit(l_CDS.Fields[2].AsString);
          Label14.Caption := (l_CDS.Fields[2].AsString);
          AssignJpg(l_CDS.Fields[3], Image3);
          Break;
        end;
        l_CDS.Next;
      end;
    end;

    if not isBool then
    begin
      l_CDS.First;
      while not l_CDS.Eof do
      begin
        if (l_CDS.Fields[0].AsString = '*') and (l_CDS.Fields[1].AsString = '*') then
        begin
          isBool := True;
          SetRichEdit(l_CDS.Fields[2].AsString);
          Label14.Caption := (l_CDS.Fields[2].AsString);
          AssignJpg(l_CDS.Fields[3], Image3);
          Break;
        end;
        l_CDS.Next;
      end;
    end;
  end;

  if not isBool then
  begin
    SetRichEdit(CheckLang('未設定'));
    Label14.Caption := ('未設定');
  end;

  //mps103
  mps103(tmpPno);


  //mps104
  mps104(realCustno);

  //lbl470
  lbl470(tmpPno);

  //倒角
  daojiao(tmpWono);

  tmpSQL := 'begin delete from tc_shz_file where tc_shz04=''MPS140'' and tc_shz01=' + QuotedStr(tmpWono);
  tmpSQL := tmpSQL +
    '; insert into tc_shz_file(tc_shz01,tc_shz02,tc_shz03,tc_shz04,tc_shz06,tc_shz07) values(%s,%s,%s,%s,sysdate,%s); end;';
  tmpSQL := Format(tmpSQL, [QuotedStr(tmpWono), QuotedStr(''), QuotedStr(''), QuotedStr('MPS140'), QuotedStr(g_uinfo^.UserId)]);
  PostBySQL(tmpSQL, 'ORACLE');
//  Application.ProcessMessages;
//  Edit3.Enabled := False;
//  Edit4.Enabled := false;
//  try
//    Edit3.text := '5';
//    Edit4.text := '5';
//    Sleep(1400);
//    Application.ProcessMessages;
//    Edit3.text := '4';
//    Edit4.text := '4';
//    Sleep(1400);
//    Application.ProcessMessages;
//    Edit3.text := '3';
//    Edit4.text := '3';
//    Sleep(1400);
//    Application.ProcessMessages;
//    Edit3.text := '2';
//    Edit4.text := '2';
//    Sleep(1400);
//    Application.ProcessMessages;
//    Edit3.text := '1';
//    Edit4.text := '1';
//    Sleep(1400);
//    Application.ProcessMessages;
//  finally
//    Edit3.text := '';
//    Edit4.text := '';
//    Edit3.Enabled := True;
//    Edit4.Enabled := True;
//    Edit3.SetFocus;
//  end;
end;

procedure TFrmMPST140.Edit3KeyPress(Sender: TObject; var Key: Char);
var
  tmpWono: string;
begin
  inherited;
  //if(Key in [';']) then key:='_';
//  GetCustInfo(Edit3.Text, tmpWono, tmpWono);
//  tmpWono := Trim(Edit3.Text);
//  if Length(tmpWono) = 0 then
//    Exit
//  else if Length(tmpWono) = 10 then
//  begin
//    Image1.Picture := nil;
//    Image2.Picture := nil;
//    Image3.Picture := nil;
//    Image5.Picture := nil;
//    Image6.Picture := nil;
    //if (Length(tmpWono) <> 10) or (Copy(tmpWono, 4, 1) <> '-') then
//    if (Copy(tmpWono, 4, 1) <> '-') then
//    begin
//      Label4.caption := CheckLang('製令單號格式不正確');
//      Label4.Font.Color := clRed;
//      Exit;
//    end;
//    Edit4.SetFocus;
//  end;
end;

function TFrmMPST140.CheckNpi(wono: string): Boolean;
var
  Data: OleVariant;
  s: string;
begin
  s := 'select oao06 from oao_file join sfb_file on oao01=sfb22 and oao03=sfb221 where sfb01=%s';
  s := Format(s, [QuotedStr(wono)]);
  if not QueryOneCR(s, Data, 'ORACLE') then
    result := False
  else
    result := Pos('NPI', UpperCase(VarToStr(Data))) > 0;
end;

function TFrmMPST140.GetOao06(cds: TDataset): string;
var
  sql: string;
  tmpcds: TClientDataSet;
  data: OleVariant;
begin
  sql := 'select oao06 from oao_file where oao01=%s and oao03=%s';
  sql := Format(sql, [QuotedStr(cds.fieldbyname('oea01').AsString), cds.fieldbyname('oeb03').AsString]);
  tmpcds := TClientDataSet.Create(nil);
  try
    if QueryBySQL(sql, data, 'ORACLE') then
    begin
      tmpcds.Data := data;
      result := tmpcds.fieldbyname('oao06').AsString;
    end
    else
      result := '';
  finally
    tmpcds.free;
  end;
end;

procedure TFrmMPST140.mps103(tmpPno: string);
begin
{
  tmpCode := Copy(tmpPno, 7, 1);
  tmpSql := Copy(tmpPno, 8, 1);
  if Pos(tmpCode, l_CopperALL) < Pos(tmpSql, l_CopperALL) then
    tmpCode := tmpSql;
  tmpSql := Copy(tmpPno, 3, 4);
  data := Null;
  tmpSql := 'select top 1 value from mps103 where bu=' + QuotedStr(g_UInfo^.BU) + ' and oz like ' + QuotedStr('%' + tmpCode + '%') + ' and mil_l<=' + QuotedStr(tmpSql) + ' and mil_h>=' + QuotedStr(tmpSql);
  if not QueryBySQL(tmpSql, data) then
    Exit;

  SetRichEdit('');
  SetRichEdit(CheckLang('整包數量'));
  l_CDS.Data := data;
  if l_CDS.IsEmpty then
  begin
    SetRichEdit(CheckLang('未設定'));
    Label7.caption := CheckLang('整包數量：未設定');
  end
  else
  begin
    SetRichEdit(l_CDS.Fields[0].AsString);
    Label7.caption := CheckLang('整包數量：') + l_CDS.Fields[0].AsString;
  end;
}
end;

procedure TFrmMPST140.mps104(tmpCustno: string);
var
  tmpSql: string;
  data: OleVariant;
begin
  data := Null;
  tmpSql := 'select top 1 value,img from mps104 where bu=' + QuotedStr(g_UInfo^.BU) + ' and (charindex(' + QuotedStr('/'
    + tmpCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' + ' order by custno desc';
  if not QueryBySQL(tmpSql, data) then
    Exit;

  l_CDS.Data := data;
  if l_CDS.IsEmpty then
  begin
    Label9.Caption := ('未設定');
  end
  else
  begin
    Label9.Caption := (l_CDS.Fields[0].AsString);
    AssignJpg(l_CDS.Fields[1], Image1);
  end;
end;

procedure TFrmMPST140.lbl470(tmpPno: string);
var
  tmpSql: string;
  data: OleVariant;
begin
  tmpSql := 'exec [dbo].[proc_MPST100] ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(tmpPno);
  if not QueryBySQL(tmpSql, data) then
    Exit;

  SetRichEdit('');
  SetRichEdit(CheckLang('標籤顏色'));
  l_CDS.Data := data;
  if l_CDS.IsEmpty then
    SetRichEdit(CheckLang('未設定'))
  else
  begin
    SetRichEdit(l_CDS.FieldByName('info').AsString);
    pnlbg.Caption := (l_CDS.FieldByName('info').AsString);
    pnlbg.Color := $ + l_CDS.FieldByName('bgcolor').AsInteger;
//    pnlfont.Color := $ + l_CDS.FieldByName('fontcolor').AsInteger;
  end;
end;

procedure TFrmMPST140.daojiao(tmpWono: string);
var
  tmpSql: string;
  data: OleVariant;
  tmpcds: TClientDataSet;
begin
  tmpSql := 'exec pqar040 ' + QuotedStr(g_uinfo^.BU) + ',' + QuotedStr(tmpWono);
  if not QueryBySQL(tmpSql, data) then
    Exit;
  tmpcds := TClientDataSet.Create(nil);
  tmpcds.data := data;
  try
    AssignJpg(tmpcds.FieldByName('img'), Image5);
    Label17.Caption := tmpcds.FieldByName('degree').asstring;
    Label18.Caption := tmpcds.FieldByName('content').asstring;
    Label16.Caption := CheckLang('激光打標：' + tmpcds.FieldByName('content1').asstring);
    Label7.caption := CheckLang('整包數量：') + tmpcds.FieldByName('pnlzb').asstring
  finally
    tmpcds.free;
  end;
end;

function TFrmMPST140.GetCustInfo(barcode: string; var custno, custname: string): boolean;
var
  idx, j: integer;
  sql: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  for j := 0 to 13 do
  begin
    idx := Pos(';', barcode) + 1;
    barcode := Copy(barcode, idx, Length(barcode));
  end;
  idx := Pos(';', barcode);
  custno := Copy(barcode, 1, idx - 1);
  sql := 'select occ02 from ' + g_uinfo^.BU + '.occ_file where occ01=' + QuotedStr(custno);
  result := QueryOneCR(sql, data, 'ORACLE');

  if Result then
  begin
    custname := VarToStr(data);
  end;
end;

procedure TFrmMPST140.ToolButton3Click(Sender: TObject);
var
  s: string;
begin
  inherited;
  GetCustInfo(memo1.Text, s, s);
end;

procedure TFrmMPST140.clear;
begin
  Edit3.Text := '';
  Edit4.Text := '';
  Edit3.SetFocus;
  Label15.Caption := '';
  Label4.Caption := '';
  Label5.Caption := '';
  Label6.Caption := '';
  Label15.caption := '';
  Label14.caption := '';
  pnlbg.caption := '';
  Label1.Caption := CheckLang('制令掃描');
  Label2.Caption := CheckLang('標籤掃描');
  Label3.Caption := CheckLang('圓角要求：');
  Label4.Caption := CheckLang('製令單號：');
  Label5.Caption := CheckLang('客戶：');
  Label6.Caption := CheckLang('料號：');
  Label7.Caption := CheckLang('整包數量：');
  Label8.Caption := CheckLang('棧板類型：');
  Label9.Caption := CheckLang(''); //棧板類型：');
  Label10.Caption := CheckLang('大標籤顏色：');
  Label11.Caption := CheckLang('大標籤張貼位置：');
  Label12.Caption := CheckLang('小標籤類型：');
  Label13.Caption := CheckLang('其他注意事項：');
  Label14.Caption := CheckLang('');
  Label15.Caption := CheckLang('');
  Label16.Caption := CheckLang('激光打標：');
  Label17.Caption := CheckLang('');
  Label18.Caption := CheckLang('');
  Image1.Picture := nil;
  Image2.Picture := nil;
  Image3.Picture := nil;
  Image5.Picture := nil;
  Image6.Picture := nil;
end;

end.

