unit unIPQCT620;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, DB, ADODB, StdCtrls, ExtCtrls,
  XPMan, DBClient, Provider, ComCtrls, Mask, DBCtrls, DBCtrlsEh, Math, ScktComp, IdTCPServer;

type
  TFrmIPQCT620 = class(TForm)
    Conn: TADOConnection;
    ADOQuery1: TADOQuery;
    Edit1: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    XPManifest1: TXPManifest;
    Bevel1: TBevel;
    Panel2: TPanel;
    Bevel2: TBevel;
    Panel3: TPanel;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button4: TButton;
    Label5: TLabel;
    Label6: TLabel;
    DataSetProvider1: TDataSetProvider;
    CDS: TClientDataSet;
    RichEdit1: TRichEdit;
    DS: TDataSource;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    ADOQuery2: TADOQuery;
    Edit3: TEdit;
    ADOQuery3: TADOQuery;
    Label1: TLabel;
    Edit4: TEdit;
    cbb2: TComboBox;
    ADOQuery4: TADOQuery;
    cbb1: TComboBox;
    Button5: TButton;
    Button6: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    cbb3: TDBComboBoxEh;
    Label11: TLabel;
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure cbb1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    l_pass, l_garbage: Boolean;
    l_bu, l_uid, l_uname, l_tempDir: string;
    l_num: Integer;
    l_qty: Double;
    Server: TServerSocket;
    procedure ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    function CheckUser(pw: string): Boolean;
    function CheckData: Boolean;
    procedure InitLabel;
    procedure UpLabel(IsNext: Boolean);
    procedure GetCbb1(var xml, txt: string);
    procedure LoadData;
  public
    { Public declarations }
  end;

var
  FrmIPQCT620: TFrmIPQCT620;

implementation

uses
  unIPQCT620_login, unIPQCT620_waste_pno;

const
  l_hint = '提示';

var
  msg: string;

{$R *.dfm}

//檢查是否已運行
function CheckIsRunning: Boolean;
var
  aTitle: string;
  hMutex: THandle;
begin
  Result := False;
  aTitle := Application.Title;
  hMutex := CreateMutex(nil, False, PChar(aTitle));
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    CloseHandle(hMutex);
    Application.MessageBox('程式已運行', l_hint, 16);
    Result := True;
  end;
end;

//系統臨時路徑
function GetTempDir: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  GetTempPath(SizeOf(Buffer) - 1, Buffer);
  Result := StrPas(Buffer);
end;

function TFrmIPQCT620.CheckUser(pw: string): Boolean;
begin
  Result := False;

  with ADOQuery2 do
  begin
    Close;
    SQL.Text := 'select a.username,b.r_garbage from sys_user a,sys_userright b' +
      ' where a.bu=b.bu and a.userid=b.userid' + ' and a.bu=' + Quotedstr(l_bu) + ' and a.userid=' + Quotedstr(l_uid) +
      ' and a.password=' + Quotedstr(pw) + ' and isnull(a.not_use,0)=0 and b.procid=''IPQCT620''';
      //and b.r_visible=1 由主畫面啟動,r_visible=1
    try
      Open;
    except
      Exit;
    end;

    if not IsEmpty then
    begin
      l_uname := FieldByName('username').AsString;
      l_garbage := FieldByName('r_garbage').AsBoolean;
      Result := True;
    end;
  end;
end;

function TFrmIPQCT620.CheckData: Boolean;
var
  v1, v2: Double;
  ls: TStrings;
begin
  Result := False;

  if not CDS.FieldByName('istext').AsBoolean then
  begin
    if cbb3.Visible then
      if cbb3.Items.IndexOf(CDS.FieldByName('srcpno').AsString) = -1 then
      begin
        Application.MessageBox('請選擇物料!', l_hint, 48);
        if cbb3.CanFocus then
          cbb3.SetFocus;
        Exit;
      end;

    if CDS.FieldByName('in_kg').IsNull then
    begin
      Application.MessageBox('請輸入實際投入量(kg)!', l_hint, 48);
      if DBEdit1.CanFocus then
        DBEdit1.SetFocus;
      Exit;
    end;

    v1 := RoundTo(CDS.FieldByName('kg').AsFloat - CDS.FieldByName('diff').AsFloat, -3);
    v2 := RoundTo(CDS.FieldByName('kg').AsFloat + CDS.FieldByName('diff').AsFloat, -3);
    if (CDS.FieldByName('in_kg').AsFloat < v1) or (CDS.FieldByName('in_kg').AsFloat > v2) then
    begin
      Application.MessageBox(PAnsiChar('實際投入量(kg),不在設定範圍內(' + FloatToStr(v1) + '~' + FloatToStr(v2) + ')!'),
        l_hint, 48);
      if DBEdit1.CanFocus then
        DBEdit1.SetFocus;
      Exit;
    end;

    if Length(Trim(CDS.FieldByName('srclot').AsString)) = 0 then
    begin
      Application.MessageBox('請輸入原料批號!', l_hint, 48);
      if DBEdit2.CanFocus then
        DBEdit2.SetFocus;
      Exit;
    end;

    if pos('加入', label2.Caption) > 0 then
    begin
      if length(msg) = 0 then
      begin
        Application.MessageBox('請先掃描二維碼!', l_hint, 48);
        Exit;
      end;
      ls := TStringlist.Create;
      try
        ls.Delimiter := ',';
        ls.DelimitedText := msg;
        if ls.Count < 3 then
        begin
          Application.MessageBox('二維碼格式錯誤!', l_hint, 48);
          Exit;
        end;
        if pos('項目：加入'+copy(ls[2],4,3),label2.caption)<>1 then
        begin
          Application.MessageBox('掃描結果不匹配!', l_hint, 48);
          Exit;
        end;
      finally
        ls.free;
      end;
    end;
  end;

  Result := True;
end;

procedure TFrmIPQCT620.InitLabel;
begin
  l_num := 0;
  RichEdit1.Clear;
  Label1.Caption := '0/0';
  Label2.Visible := False;
  Label3.Visible := False;
  Label4.Visible := False;
  Label5.Visible := False;
  Label6.Visible := False;
  Label7.Caption := '投入量：0/0';
  Label9.Caption := '';
  Label10.Visible := False;
  Label11.Visible := False;
  DBEdit1.Visible := False;
  DBEdit2.Visible := False;
  cbb3.Visible := False;
  RichEdit1.Visible := True;
  Button2.Enabled := False;
  Button3.Enabled := False;
  Button4.Enabled := False;
  Button5.Enabled := False;
  Button6.Enabled := False;
end;

procedure TFrmIPQCT620.UpLabel(IsNext: Boolean);
var
  tmpKG1, tmpKG2: Double;
  tmpCDS: TClientDataSet;
  tmpXML, tmpTXT: string;
begin
  GetCbb1(tmpXML, tmpTXT);

  if IsNext and CDS.FieldByName('idate').IsNull then
  begin
    if not (CDS.State in [dsEdit]) then
      CDS.Edit;
    CDS.FieldByName('idate').AsDateTime := Now;     //進料時間
    CDS.FieldByName('iuser').AsString := l_uid;     //操作員id
    CDS.FieldByName('muser').AsString := l_uname;   //操作員
  end;

  if CDS.State in [dsEdit] then
    CDS.Post;

  CDS.RecNo := l_num;
  Label1.Caption := IntToStr(l_num) + '/' + IntToStr(CDS.RecordCount);
  Button2.Enabled := (l_num > 1) and (CDS.RecordCount <> 1);
  Button3.Enabled := l_num < CDS.RecordCount;
  Button4.Enabled := l_num = CDS.RecordCount;
  Button5.Enabled := l_num > 1;
  Button6.Enabled := l_garbage and ((l_num > 1) or FileExists(tmpXML) or FileExists(tmpTXT));

  Label2.Visible := not CDS.FieldByName('istext').AsBoolean;
  Label3.Visible := Label2.Visible;
  Label4.Visible := Label2.Visible;
  Label5.Visible := Label2.Visible;
  Label6.Visible := Label2.Visible;
  Label10.Visible := Label2.Visible and (Length(Trim(CDS.FieldByName('listpno').AsString)) > 0);
  Label11.Visible := Label2.Visible;
  DBEdit1.Visible := Label2.Visible;
  DBEdit2.Visible := Label2.Visible;
  cbb3.Visible := Label10.Visible;
  RichEdit1.Visible := not Label2.Visible;
  if Label2.Visible then
  begin
    Label2.Caption := '項目：' + CDS.FieldByName('item').AsString;
    Label3.Caption := '計劃量(kg)：' + CDS.FieldByName('kg').AsString;
    Label4.Caption := '允許誤差：±' + CDS.FieldByName('diff').AsString;
    Label11.Caption := '掃描結果：';
  end
  else
  begin
    RichEdit1.Clear;
    try
      RichEdit1.Lines.Add('  ' + CDS.FieldByName('item').AsString);
    except  //item有特殊符號報錯:RichEdit line insertion error
    end;
  end;

  if Label10.Visible then
  begin
    cbb3.Items.Clear;
    cbb3.Items.DelimitedText := Trim(CDS.FieldByName('listpno').AsString);
    cbb3.ItemIndex := cbb3.Items.IndexOf(CDS.FieldByName('srcpno').AsString);
  end;

  //操作員不同,不可編輯
  cbb3.Enabled := True;
  DBEdit1.Enabled := True;
  DBEdit2.Enabled := True;
  if (Length(CDS.FieldByName('iuser').AsString) > 0) and (not SameText(CDS.FieldByName('iuser').AsString, l_uid)) then
  begin
    cbb3.Enabled := False;
    DBEdit1.Enabled := False;
    DBEdit2.Enabled := False;
  end;

  //計算總投入量
  tmpKG1 := 0;
  tmpKG2 := 0;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    tmpCDS.IndexFieldNames := CDS.IndexFieldNames;
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        if RecNo < CDS.RecNo then
          tmpKG1 := tmpKG1 + FieldByName('in_kg').AsFloat;
        tmpKG2 := tmpKG2 + FieldByName('in_kg').AsFloat;
        Next;
      end;
    end;
  finally
    FreeAndNil(tmpCDS);
    Label7.Caption := '投入量：' + FloatToStr(tmpKG1) + '/' + FloatToStr(tmpKG2);
  end;
end;

procedure TFrmIPQCT620.GetCbb1(var xml, txt: string);
var
  tmpStr: string;
begin
  tmpStr := 'T620_' + cbb1.Items.Strings[cbb1.ItemIndex];
  txt := l_tempDir + tmpStr + '.txt';
  xml := l_tempDir + tmpStr + '.xml';
end;

procedure TFrmIPQCT620.LoadData;
var
  tmpXML, tmpTXT: string;
  tmpIndex: Integer;
  tmpList: TStrings;
begin
  GetCbb1(tmpXML, tmpTXT);

  //讀取暫存資料
  if FileExists(tmpXML) then
  begin
    l_num := 1;
    CDS.LoadFromFile(tmpXML);
    CDS.First;

    if FileExists(tmpTXT) then
    begin
      tmpList := TStringList.Create;
      try
        tmpList.LoadFromFile(tmpTXT);
        if tmpList.Count >= 1 then
          Edit1.Text := tmpList.Strings[0];
        if tmpList.Count >= 2 then
          cbb2.ItemIndex := cbb2.Items.IndexOf(tmpList.Strings[1])
        else
          cbb2.ItemIndex := -1;
        if tmpList.Count >= 3 then
          Edit3.Text := tmpList.Strings[2];
        if tmpList.Count >= 4 then
        begin
          Edit4.Text := tmpList.Strings[3];
          l_qty := StrToFloatDef(tmpList.Strings[3], 0)
        end;

        if tmpList.Count >= 5 then
        begin
          tmpIndex := StrToIntDef(tmpList.Strings[4], 0);
          if tmpIndex > 0 then
            l_num := tmpIndex;
        end;
      finally
        FreeAndNil(tmpList);
      end;
    end;

    UpLabel(False);
  end;
end;

procedure TFrmIPQCT620.FormCreate(Sender: TObject);
var
  pw: string;
begin
  if CheckIsRunning then
    Halt;

  l_tempDir := GetTempDir;

  Bevel1.Width := Panel1.Width;
  Bevel2.Width := Panel2.Width;

  Edit1.Left := cbb1.Left + cbb1.Width + 5;
  cbb2.Left := Edit1.Left + Edit1.Width + 5;
  cbb2.Width := Panel1.ClientWidth - cbb2.Left - 5;

  Button1.Left := Panel1.ClientWidth - Button1.Width - 10;
  Label8.Left := Button1.Left - Label8.Width - 5;
  Edit4.Left := Label8.Left - Edit4.Width - 5;
  Edit3.Width := Edit4.Left - Edit3.Left - 5;

  Button4.Left := Panel2.ClientWidth - Button4.Width - 10;
  Button3.Left := Button4.Left - Button3.Width - 5;
  Button2.Left := Button3.Left - Button2.Width - 5;

  Button6.Left := Button2.Left - Button6.Width - 30;
  Button5.Left := Button6.Left - Button5.Width - 5;

  Label1.Left := 20;
  Label2.Left := 20;
  Label3.Left := 20;
  Label4.Left := 20;
  Label11.Left := 20;
  Label7.Left := Label1.Left + Label1.Width;
  Label9.Top := Button2.Top;
  Label9.Height := Button2.Height;
  Label9.Left := Label7.Left + Label7.Width;
  Label9.Width := Button5.Left - Label9.Left - 10;
  Label2.Width := Panel3.ClientWidth;
  Label3.Width := Panel3.ClientWidth;
  Label4.Width := Panel3.ClientWidth;
  Label11.Width := Panel3.ClientWidth;

  DBEdit2.Top := Panel3.ClientHeight - DBEdit2.Height - 10;
  DBEdit2.Left := Panel3.ClientWidth - DBEdit2.Width - 10;
  Label6.Left := DBEdit2.Left;
  Label6.Top := DBEdit2.Top - Label6.Height - 5;

  DBEdit1.Top := Label6.Top - DBEdit1.Height - 20;
  DBEdit1.Left := DBEdit2.Left;
  Label5.Left := DBEdit2.Left;
  Label5.Top := DBEdit1.Top - Label5.Height - 5;

  cbb3.Top := Label5.Top - cbb3.Height - 20;
  cbb3.Left := DBEdit2.Left;
  Label10.Left := DBEdit2.Left;
  Label10.Top := cbb3.Top - Label10.Height - 5;

  RichEdit1.Align := alClient;

  InitLabel;

  Conn.Connected := False;

  l_qty := 0;
  l_garbage := False;
  l_uname := '';
  l_bu := Paramstr(1);
  l_uid := Paramstr(2);
  pw := Paramstr(3);
  if (Length(l_bu) > 0) and (Length(l_uid) > 0) and (Length(pw) > 0) then
    l_pass := CheckUser(pw)
  else
    l_pass := False;
  CDS.IndexFieldNames := 'sno';

  Server := TServerSocket.Create(self);
  Server.Port := 4123;
  Server.Active := true;
  Server.OnClientRead := ServerSocketClientRead;
end;

procedure TFrmIPQCT620.FormActivate(Sender: TObject);
begin
  if not l_pass then
  begin
    FrmIPQCT620_login := TFrmIPQCT620_login.Create(nil);
    try
      if FrmIPQCT620_login.ShowModal <> mrOK then
        Close;
      l_bu := FrmIPQCT620_login.l_bu;
      l_uid := FrmIPQCT620_login.Edit1.Text;
      l_uname := FrmIPQCT620_login.l_uname;
      l_garbage := FrmIPQCT620_login.l_garbage;
    finally
      FreeAndNil(FrmIPQCT620_login);
    end;
  end;

  LoadData;
end;

procedure TFrmIPQCT620.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    if Application.MessageBox('確定退出程式嗎?', l_hint, 33) = IdOK then
      Close;
end;

procedure TFrmIPQCT620.FormResize(Sender: TObject);
begin
  Bevel1.Width := Panel1.Width;
  Bevel2.Width := Panel2.Width;
end;

procedure TFrmIPQCT620.ServerSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  idx: integer;
begin
  msg := Socket.ReceiveText;
  idx := pos(':', msg);
  if (idx > 2) and (cbb1.text = copy(msg, 1, idx - 1)) then
  begin
    msg := copy(msg, idx + 1, 255);
    msg := stringreplace(msg, ' ', '', [rfReplaceAll]); 
    Label11.Caption := '掃描結果：' + msg;
  end;               
end;

procedure TFrmIPQCT620.Button1Click(Sender: TObject);
begin
  InitLabel;

  if Length(Trim(Edit1.Text)) = 0 then
  begin
    Application.MessageBox('請輸入膠系!', l_hint, 48);
    Edit1.SetFocus;
    Exit;
  end;

  if cbb2.ItemIndex = -1 then
  begin
    Application.MessageBox('請選擇版本號!', l_hint, 48);
    cbb2.SetFocus;
    Exit;
  end;

  l_qty := StrToFloatDef(Edit4.Text, 0);
  if l_qty <= 0 then
  begin
    Application.MessageBox('請輸入調膠量!', l_hint, 48);
    Edit4.SetFocus;
    Exit;
  end;

  try
    CDS.Active := False;
    ADOQuery1.Close;
    Conn.Connected := False;
    Conn.Connected := True;
  except
    on e: Exception do
    begin
      Application.MessageBox(PAnsiChar('連接服務器失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
      Exit;
    end;
  end;

  ADOQuery1.SQL.Text := 'select a.remark,b.* from ipqc610 a,ipqc611 b' +
    ' where a.bu=b.bu and a.ad=b.ad and a.ver=b.ver' + ' and a.bu=' + Quotedstr(l_bu) + ' and a.conf=1 and a.ad=' +
    Quotedstr(Edit1.Text) + ' and a.ver=' + Quotedstr(cbb2.Items.Strings[cbb2.ItemIndex]) + ' order by b.sno';
  try
    ADOQuery1.Open;
  except
    on e: Exception do
    begin
      Application.MessageBox(PAnsiChar('查詢資料失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
      Exit;
    end;
  end;

  CDS.Active := True;
  if CDS.IsEmpty then
  begin
    Application.MessageBox('此膠系、版本號無資料!', l_hint, 48);
    Exit;
  end;

  if Length(Trim(CDS.FieldByName('remark').AsString)) = 0 then
    Label9.Caption := ''
  else
    Label9.Caption := '備註：' + CDS.FieldByName('remark').AsString;

  with CDS do
  begin
    while not Eof do
    begin
      Edit;
      if not FieldByName('istext').AsBoolean then
        FieldByName('kg').AsFloat := RoundTo(FieldByName('kg').AsFloat * l_qty - FieldByName('keep').AsFloat, -6);
          //計劃量
      FieldByName('in_kg').Clear;    //投入量
      FieldByName('srclot').Clear;   //原料批號
      FieldByName('srcpno').Clear;   //物料
      FieldByName('idate').Clear;    //時間
      FieldByName('iuser').Clear;    //操作員id
      FieldByName('muser').Clear;    //操作員
      Post;
      Next;
    end;
    MergeChangeLog;
    First;
  end;

  l_num := 1;
  UpLabel(False);
end;

procedure TFrmIPQCT620.Button2Click(Sender: TObject);
begin
  Dec(l_num);
  UpLabel(False);
end;

procedure TFrmIPQCT620.Button3Click(Sender: TObject);
var
  tmpXML, tmpTXT: string;
  tmpList: TStrings;
begin
  if not CheckData then
    Exit;

  Inc(l_num);
  UpLabel(True);

  //暫存資料至本地
  GetCbb1(tmpXML, tmpTXT);
  CDS.SaveToFile(tmpXML);
  tmpList := TStringList.Create;
  try
    tmpList.Add(Edit1.Text);
    tmpList.Add(cbb2.Items.Strings[cbb2.ItemIndex]);
    tmpList.Add(Edit3.Text);
    tmpList.Add(Edit4.Text);
    tmpList.Add(IntToStr(CDS.RecNo));
    tmpList.SaveToFile(tmpTXT);
  finally
    FreeAndNil(tmpList);
  end;
end;

procedure TFrmIPQCT620.Button4Click(Sender: TObject);
var
  i: Integer;
  tmpXML, tmpTXT: string;
  tmpAd, tmpVer, tmpLot, tmpWaste_pno, tmpFilter: string;

  procedure DelRec;
  var
    tmpSQL: string;
  begin
    tmpSQL := ' delete from ipqc620 ' + tmpFilter + ' delete from ipqc621 ' + tmpFilter;
    try
      Conn.Execute(tmpSQL);
    except
    end;
  end;

begin
  if not CheckData then
    Exit;

  tmpAd := CDS.FieldByName('ad').AsString;
  tmpVer := CDS.FieldByName('ver').AsString;
  tmpLot := UpperCase(Trim(Edit3.Text));
  if Length(tmpLot) <> 11 then
  begin
    Application.MessageBox('批號錯誤,請重新輸入'#13#10 + '長度應為11碼,只允許數字與字母組合(0..9,A..Z)', l_hint, 48);
    Edit3.SetFocus;
    Exit;
  end;

  for i := 1 to Length(tmpLot) do
    if not (tmpLot[i] in ['0'..'9', 'A'..'Z']) then
    begin
      Application.MessageBox('批號錯誤,請重新輸入'#13#10 + '長度應為11碼,只允許數字與字母組合(0..9,A..Z)', l_hint, 48);
      Edit3.SetFocus;
      Exit;
    end;

  if Application.MessageBox('確定完成嗎?', l_hint, 33) = IDCancel then
    Exit;

  if CDS.FieldByName('idate').IsNull then
  begin
    if not (CDS.State in [dsEdit]) then
      CDS.Edit;
    CDS.FieldByName('idate').AsDateTime := Now;     //進料時間
    CDS.FieldByName('iuser').AsString := l_uid;     //操作員id
    CDS.FieldByName('muser').AsString := l_uname;   //操作員
  end;

  if CDS.State in [dsEdit] then
    CDS.Post;

  tmpWaste_pno := '';
  if not Assigned(FrmIPQCT620_waste_pno) then
    FrmIPQCT620_waste_pno := TFrmIPQCT620_waste_pno.Create(nil);
  if FrmIPQCT620_waste_pno.ShowModal = mrOK then
    tmpWaste_pno := Trim(FrmIPQCT620_waste_pno.Edit1.Text);
  FreeAndNil(FrmIPQCT620_waste_pno);

  try
    ADOQuery2.Close;
    ADOQuery3.Close;
    Conn.Connected := False;
    Conn.Connected := True;
  except
    on e: Exception do
    begin
      Application.MessageBox(PAnsiChar('連接服務器失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
      Exit;
    end;
  end;

  tmpFilter := ' where bu=' + Quotedstr(l_bu) + ' and ad=' + Quotedstr(tmpAd) + ' and ver=' + Quotedstr(tmpVer) +
    ' and lot=' + Quotedstr(tmpLot);

  with ADOQuery2 do
  begin
    Close;
    SQL.Text := 'select * from ipqc620 ' + tmpFilter;
    try
      Open;
    except
      on e: Exception do
      begin
        Application.MessageBox(PAnsiChar('資料儲存失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
        Exit;
      end;
    end;
  end;

  if not ADOQuery2.IsEmpty then
  begin
    if Application.MessageBox(PAnsiChar('[' + tmpAd + ',' + tmpVer + ',' + tmpLot + ']' + #13#10 +
      '此膠系+版本的批號資料已存在,確定覆蓋嗎?'), l_hint, 33) = IdCancel then
      Exit;
  end;

  with ADOQuery3 do
  begin
    Close;
    SQL.Text := 'select * from ipqc621 ' + tmpFilter;
    try
      Open;
    except
      on e: Exception do
      begin
        Application.MessageBox(PAnsiChar('資料儲存失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
        Exit;
      end;
    end;
  end;

  with ADOQuery2 do
    while not IsEmpty do
      Delete;

  with ADOQuery3 do
    while not IsEmpty do
      Delete;

  with ADOQuery2 do
  begin
    Append;
    FieldByName('bu').AsString := l_bu;
    FieldByName('ad').AsString := tmpAd;
    FieldByName('ver').AsString := tmpVer;
    FieldByName('lot').AsString := tmpLot;
    FieldByName('qty').AsFloat := l_qty;
    if Length(tmpWaste_pno) > 0 then
      FieldByName('waste_pno').AsString := tmpWaste_pno;
    FieldByName('iuser').AsString := l_uid;
    FieldByName('idate').AsDateTime := Now;
    try
      Post;
    except
      on e: Exception do
      begin
        Application.MessageBox(PAnsiChar('資料儲存失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
        Exit;
      end;
    end;
  end;

  if CDS.ChangeCount > 0 then
    CDS.MergeChangeLog;
  CDS.First;
  while not CDS.Eof do
  begin
    with ADOQuery3 do
    begin
      Append;
      FieldByName('bu').AsString := l_bu;
      FieldByName('ad').AsString := tmpAd;
      FieldByName('ver').AsString := tmpVer;
      FieldByName('lot').AsString := tmpLot;
      FieldByName('sno').AsInteger := CDS.RecNo;
      FieldByName('item').AsString := CDS.FieldByName('item').AsString;
      FieldByName('istext').AsBoolean := CDS.FieldByName('istext').AsBoolean;
      if not FieldByName('istext').AsBoolean then
      begin
        FieldByName('listpno').AsString := CDS.FieldByName('listpno').AsString;
        FieldByName('kg').AsFloat := CDS.FieldByName('kg').AsFloat;
        FieldByName('keep').AsFloat := CDS.FieldByName('keep').AsFloat;
        FieldByName('diff').AsFloat := CDS.FieldByName('diff').AsFloat;
        FieldByName('srcpno').AsString := CDS.FieldByName('srcpno').AsString;
        FieldByName('in_kg').AsFloat := CDS.FieldByName('in_kg').AsFloat;
        FieldByName('srclot').AsString := CDS.FieldByName('srclot').AsString;
      end;
      FieldByName('stime').AsDateTime := CDS.FieldByName('idate').AsDateTime;
      FieldByName('uid').AsString := CDS.FieldByName('iuser').AsString;
      FieldByName('uname').AsString := CDS.FieldByName('muser').AsString;
      FieldByName('iuser').AsString := l_uid;
      FieldByName('idate').AsDateTime := Now;

      try
        Post;
      except
        on e: Exception do
        begin
          DelRec;
          Application.MessageBox(PAnsiChar('資料儲存失敗,請重試:' + #13#10 + e.Message), l_hint, 48);
          Exit;
        end;
      end;
    end;
    CDS.Next;
  end;

  GetCbb1(tmpXML, tmpTXT);
  if FileExists(tmpXML) then
    DeleteFile(tmpXML);
  if FileExists(tmpTXT) then
    DeleteFile(tmpTXT);
  InitLabel;
  Application.MessageBox(PAnsiChar('資料儲存成功,批號' + #13#10 + tmpLot), l_hint, 64);
end;

procedure TFrmIPQCT620.Button5Click(Sender: TObject);
begin
  l_num := 1;
  UpLabel(False);
end;

procedure TFrmIPQCT620.Button6Click(Sender: TObject);
var
  tmpXML, tmpTXT: string;
begin
  if not l_garbage then
  begin
    Application.MessageBox('對不起,你無作廢權限!', l_hint, 33);
    Exit;
  end;

  if Application.MessageBox('確定作廢嗎?', l_hint, 33) = IdCancel then
    Exit;

  GetCbb1(tmpXML, tmpTXT);
  if FileExists(tmpXML) then
    DeleteFile(tmpXML);
  if FileExists(tmpTXT) then
    DeleteFile(tmpTXT);
  InitLabel;
end;

procedure TFrmIPQCT620.cbb1Change(Sender: TObject);
begin
  InitLabel;
  LoadData;
end;

procedure TFrmIPQCT620.Edit1Change(Sender: TObject);
begin
  cbb2.Text := '';
  cbb2.Items.Clear;

  try
    ADOQuery4.Close;
    Conn.Connected := False;
    Conn.Connected := True;
  except
    Exit;
  end;

  ADOQuery4.SQL.Text := 'select ver from ipqc610' + ' where bu=' + Quotedstr(l_bu) + ' and conf=1 and ad=' + Quotedstr(Edit1.Text)
    + ' order by ver';
  try
    ADOQuery4.Open;
  except
    Exit;
  end;

  with ADOQuery4 do
  begin
    First;
    while not Eof do
    begin
      cbb2.Items.Add(FieldByName('ver').AsString);
      Next;
    end;
  end;

  if cbb2.Items.Count > 0 then
    cbb2.ItemIndex := 0;
end;

procedure TFrmIPQCT620.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Server.free;
end;

end.

