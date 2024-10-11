unit unMPST100;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI080, ExtCtrls, StdCtrls,
  ImgList, ComCtrls, ToolWin, DBClient, ScktComp, StrUtils, jpeg, DB, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, TLHelp32, IdTCPServer;

type
  TFrmMPST100 = class(TFrmSTDI080)
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    RichEdit1: TRichEdit;
    btn_mpst100A: TToolButton;
    btn_mpst100B: TToolButton;
    btn_mpst100C: TToolButton;
    btn_mpst100D: TToolButton;
    btn_mpst100E: TToolButton;
    RichEdit2: TRichEdit;
    pnlbg: TPanel;
    pnlfont: TPanel;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Label4: TLabel;
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
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Image3: TImage;
    Image4: TImage;
    btn_mpst100F: TToolButton;
    npi: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpst100AClick(Sender: TObject);
    procedure btn_mpst100BClick(Sender: TObject);
    procedure btn_mpst100CClick(Sender: TObject);
    procedure btn_mpst100DClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure btn_mpst100EClick(Sender: TObject);
    procedure btn_mpst100FClick(Sender: TObject);
  private
    server: TIdTCPServer;
    l_Ans: Boolean;
    l_CDS: TClientDataSet;
    procedure LoadPlayer;
    procedure Speak(msg: string);
    function GetOao06(cds: TDataset): string;
    function CheckNpi(wono: string): boolean;
    procedure SetRichEdit(xSourceStr: string);
    procedure AssignJpg(fn: TField; ctl: TImage);
    procedure mps103(custno,pno: string);
    procedure mps104(tmpCustno: string);
    procedure lbl470(tmpPno: string);
    procedure StartTcpServer;
    function GetCustno(str: string): string;
  public    { Public declarations }
  end;

var
  FrmMPST100: TFrmMPST100;
  client: TClientSocket;

implementation

uses
  unGlobal, unCommon, unMPST100_setA, unMPST100_setB, unMPST100_setC, unMPST100_setD, unMPST100_setE, unMPST100_setF;

var
  tts: string;

const
  l_CopperALL = 'QTH1AS2BP34567';               //�ɫp�j�p�ƦC
{$R *.dfm}

procedure TFrmMPST100.AssignJpg(fn: TField; ctl: TImage);
var
  jpg: TJPEGImage;
  bmp: TBitmap;
  ms: TMemoryStream;
begin
  if fn.IsNull then
    exit;
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

procedure TFrmMPST100.SetRichEdit(xSourceStr: string);
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
    RichEdit2.Lines.Add(tmpValue);

    tmpStr := Copy(tmpStr, pos1 + 1, 1024);
    pos1 := Pos('|', tmpStr);
  end;
end;

procedure TFrmMPST100.FormCreate(Sender: TObject);
begin
  p_TableName := '@';
  btn_quit.Left := btn_mpst100F.Left + btn_mpst100F.Width;

  inherited;

  btn_print.Visible := False;
  btn_export.Visible := False;
  btn_query.Visible := True;
  btn_mpst100A.Visible := g_MInfo^.R_edit;
  btn_mpst100B.Visible := g_MInfo^.R_edit;
  btn_mpst100C.Visible := g_MInfo^.R_edit;
  btn_mpst100D.Visible := g_MInfo^.R_edit;
  btn_mpst100E.Visible := g_MInfo^.R_edit;
  btn_mpst100F.Visible := g_MInfo^.R_edit;
  btn_query.Caption := CheckLang('�Ͳ��i�ק�s');
  Label1.Caption := CheckLang('�п�J�s�O�渹');
  Label2.Caption := CheckLang('���ұ��y');
  Label3.Caption := CheckLang('');
  Label4.Caption := CheckLang('�s�O�渹�G');
  Label5.Caption := CheckLang('�Ȥ�G');
  Label6.Caption := CheckLang('�Ƹ��G');
  Label7.Caption := CheckLang('��]�ƶq�G');
  Label8.Caption := CheckLang('�̪O�����G');
  Label9.Caption := CheckLang('�̪O�����G');
  Label10.Caption := CheckLang('�j�����C��G');
  Label11.Caption := CheckLang('�j���ұi�K��m�G');
  Label12.Caption := CheckLang('�p���������G');
  Label13.Caption := CheckLang('�s�P�]�i�K��m�G');
  Label14.Caption := CheckLang('');
  Label15.Caption := CheckLang('');
  l_CDS := TClientDataSet.Create(Self);

  if not isadmin then
    LoadPlayer;
  client := TClientSocket.Create(Self);
  client.Host := '127.0.0.1';
  client.Port := 4444;

  StartTcpServer;
end;

procedure TFrmMPST100.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  l_Ans := True;
  FreeAndNil(l_CDS);
  client.free;
  server.Free;
end;

procedure TFrmMPST100.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if ShowMsg('�T�w��s��?', 33) = IDOK then
    if PostBySQL('exec dbo.proc_UpdateWostation ' + QuotedStr(g_UInfo^.BU)) then
      ShowMsg('��s����', 64);
end;

procedure TFrmMPST100.btn_mpst100AClick(Sender: TObject);
begin
  inherited;
  FrmMPST100_setA := TFrmMPST100_setA.Create(nil);
  FrmMPST100_setA.ShowModal;
  FreeAndNil(FrmMPST100_setA);
end;

procedure TFrmMPST100.btn_mpst100BClick(Sender: TObject);
begin
  inherited;
  FrmMPST100_setB := TFrmMPST100_setB.Create(nil);
  FrmMPST100_setB.ShowModal;
  FreeAndNil(FrmMPST100_setB);
end;

procedure TFrmMPST100.btn_mpst100CClick(Sender: TObject);
begin
  inherited;
  FrmMPST100_setC := TFrmMPST100_setC.Create(nil);
  FrmMPST100_setC.ShowModal;
  FreeAndNil(FrmMPST100_setC);
end;

procedure TFrmMPST100.btn_mpst100DClick(Sender: TObject);
begin
  inherited;
  FrmMPST100_setD := TFrmMPST100_setD.Create(nil);
  FrmMPST100_setD.ShowModal;
  FreeAndNil(FrmMPST100_setD);
end;

procedure TFrmMPST100.FormResize(Sender: TObject);
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

procedure TFrmMPST100.Edit4KeyPress(Sender: TObject; var Key: Char);
var
  i, tmpLine: Integer;
  isBool: Boolean;
  tmpWono, tmpCustno, tmpCustname, tmpPno, tmpCode, tmpSQL, lot, mon: string;
  Data: OleVariant;
  ls: TStringList;
begin
  inherited;
  if Key <> #13 then
    Exit;
//  npi.Visible := False;

  if Pos(Edit3.Text, Edit4.Text) = 0 then
  begin
    Label3.caption := CheckLang('�s�O�渹���ǰt');
    Label3.Font.Color := clRed;
    Exit;
  end;

  tmpWono := Trim(Edit3.Text);
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := 'Y'
  else
    tmpSQL := 'N';

  if not SameText(g_uinfo^.UserId, 'id150515') then
  begin
    tmpSQL := 'exec [dbo].[proc_UpdateBZTime] ' + QuotedStr(tmpSQL) + ',' + QuotedStr(tmpWono);
    if not QueryOneCR(tmpSQL, Data) then
      Exit;
  end;

  ls := SplitString(Trim(Edit4.Text),';');
  try
    if ls.Count < 21 then
    begin
      ShowMsg('�б��y�~�c����');
      Edit4.text := '';
      if Edit4.CanFocus then
        Edit4.SetFocus;
      exit;
    end;

    if Trim(Edit3.Text) <> ls[0] then
    begin
      Label4.caption := CheckLang('�s�O�渹���ǰt');
      Label4.Font.Color := clRed;
      Exit;
    end;

    lot := ls[2];
    if Length(lot) > 8 then
    begin
      mon := Copy(lot, 3, 1);
      if mon = 'A' then
        mon := '10'
      else if mon = 'B' then
        mon := '11'
      else if mon = 'C' then
        mon := '12';
    end;


  Edit3.Text := '';
  Edit4.Text := '';
  Label15.Caption := '';
  with RichEdit1 do
  begin
    if VarToStr(Data) = '1' then
    begin
      Lines.Clear;
      Lines.Add(CheckLang('��s���\'));
      SelStart := 0;
      SelLength := Length(Lines.Strings[0]);
      SelAttributes.Color := clBlue;
      Label3.caption := CheckLang('��s���\');
      Label3.Font.Color := clBlue;
    end
    else
    begin
      Lines.Clear;
      Lines.Add(CheckLang('��Ƥ��s�b�Υ���]�˯�'));
      SelStart := 0;
      SelLength := Length(Lines.Strings[0]);
      SelAttributes.Color := clRed;

      Label3.caption := CheckLang('��Ƥ��s�b�Υ���]�˯�');
      Label3.Font.Color := clRed;
    end;
  end;
  tts := '';
  Data := Null;                        
  {(*}
  tmpSQL := 'select sdate,machine,custno,custno2,custname2,custom,orderno,orderitem,materialno,sqty,' +
            ' isnull(wostation,0) wostation,wostation_qtystr,bz_date' +
            ' from mps010 where bu=''iteqdg'' and wono=' + QuotedStr(tmpWono);
  {*)}
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    tmpSQL := tmpSQL + ' and machine<>''L6'''
  else
    tmpSQL := tmpSQL + ' and machine=''L6''';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
//   ShowAdm(tmpSQL);
  l_CDS.Data := Data;
  if l_CDS.IsEmpty then
  begin
    l_CDS.Append;
    l_CDS.FieldByName('custno2').AsString := ls[14];
    l_CDS.FieldByName('custname2').AsString := occ02(ls[14]);
    l_CDS.FieldByName('materialno').AsString := ls[1];
    tmpCustno := copy(l_CDS.FieldByName('custno2').AsString,1,5);
    tmpCustname := l_CDS.FieldByName('custname2').AsString;
//    with RichEdit1 do
//    begin
//      Lines.Clear;
//      Lines.Add(CheckLang('[' + tmpWono + ']��Ƥ��s�b'));
//      SelStart := 0;
//      SelLength := Length(Lines.Strings[0]);
//      SelAttributes.Color := clRed;
//    end;
//    Label3.caption := CheckLang('[' + tmpWono + ']��Ƥ��s�b');
//    Label3.Font.Color := clRed;
//    Exit;
  end else if l_CDS.FieldByName('custno2').AsString <> '' then
  begin
    tmpCustno := copy(l_CDS.FieldByName('custno2').AsString,1,5);
    tmpCustname := l_CDS.FieldByName('custname2').AsString;
  end
  else
  begin
    tmpCustno := l_CDS.FieldByName('custno').AsString;
    tmpCustname := l_CDS.FieldByName('custom').AsString;
  end;

  begin  //	MISDS-231130
    l_CDS.Edit;
    l_CDS.FieldByName('custno2').AsString := ls[14];
    l_CDS.FieldByName('custname2').AsString := occ02(ls[14]);
    tmpCustno := l_CDS.FieldByName('custno2').AsString;
    tmpCustname := l_CDS.FieldByName('custname2').AsString;
  end;

  tmpPno := l_CDS.FieldByName('materialno').AsString;
//  if tmpCustno = 'AC121' then
//    NPI.Visible := (tmpCustno = 'AC121') and CheckNpi(tmpWono);


  with RichEdit1.Lines do
  begin
    Add(CheckLang('�s�O�渹�G') + tmpWono);
    Label4.Caption := CheckLang('�s�O�渹�G') + tmpWono;

    Add(CheckLang('�Ͳ�����G') + l_CDS.FieldByName('sdate').AsString);
    Add(CheckLang('���O�G') + l_CDS.FieldByName('machine').AsString);

    Add(CheckLang('�Ȥ�G') + l_CDS.FieldByName('custno').AsString + '/' + l_CDS.FieldByName('custom').AsString);
    Label5.Caption := CheckLang('�Ȥ�G') + tmpCustno + '/' + tmpCustname + '/' + GetOao06(l_CDS);

    Add(CheckLang('���~�Ƹ��G') + tmpPno);
    Label6.Caption := CheckLang('���~�Ƹ��G') + tmpPno;

    Add(CheckLang('�q�渹�X�G') + l_CDS.FieldByName('orderno').AsString + '/' + l_CDS.FieldByName('orderitem').AsString);
    Add(CheckLang('�ƻs�ƶq�G') + l_CDS.FieldByName('sqty').AsString);
    if Length(l_CDS.FieldByName('wostation_qtystr').AsString) > 0 then
      Add(CheckLang('�U���ƶq�G') + l_CDS.FieldByName('wostation_qtystr').AsString)
    else
      Add(CheckLang('�U���ƶq�G����s'));
    case l_CDS.FieldByName('wostation').AsInteger of
      0:
        Add(CheckLang('��e���O�G���}�u'));
      1:
        Add(CheckLang('��e���O�GPP������'));
      2:
        Add(CheckLang('��e���O�G���|��'));
      3:
        Add(CheckLang('��e���O�G�զX��'));
      4:
        Add(CheckLang('��e���O�G���X��'));
      5:
        Add(CheckLang('��e���O�GCCL���䯸'));
      6:
        Add(CheckLang('��e���O�GCCL�~�[�ˬd��'));
      7:
        Add(CheckLang('��e���O�GCCL�]�˯�  ') + l_CDS.FieldByName('bz_date').AsString);
      99:
        Add(CheckLang('��e���O�G�w����'));
      88:
        Add(CheckLang('��e���O�G�w���`����'));
    else
      Add(CheckLang('��e���O�G���w�q���O'));
    end;
  end;

  RichEdit2.Lines.Clear;
  pnlbg.Color := Self.Color;
  pnlfont.Color := Self.Color;

  //mps101
  Data := Null;
  tmpSQL := 'select top 1 * from mps101 where bu=' + QuotedStr(g_UInfo^.BU) + ' and (charindex(' + QuotedStr('/' +
    tmpCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' + ' order by custno desc';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  SetRichEdit(CheckLang('���ұi�K��m'));

  l_CDS.Data := Data;
  if l_CDS.IsEmpty then
  begin
    SetRichEdit(CheckLang('���]�w'));
    Label15.caption := ('���]�w');
  end
  else
  begin
//    SetRichEdit(l_CDS.fieldbyname('value').AsString);
    if Length(tmpPno) in [11, 19] then
    begin
      AssignJpg(l_CDS.fieldbyname('img3'), Image2);
      AssignJpg(l_CDS.fieldbyname('img4'), Image4);
      Label15.caption := (l_CDS.fieldbyname('value2').AsString);
    end
    else
    begin
      AssignJpg(l_CDS.fieldbyname('img'), Image2);
      AssignJpg(l_CDS.fieldbyname('img2'), Image4);
      Label15.caption := (l_CDS.fieldbyname('value').AsString);
    end;
  end;

  //mps102
  isBool := False;
  tmpCode := Copy(tmpPno, 2, 1);
  Data := Null;
  tmpSQL := 'select custno,ad,value,img from mps102 where bu=' + QuotedStr(g_UInfo^.BU) + ' and (charindex(' + QuotedStr
    ('/' + tmpCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' + ' and (ad like ' + QuotedStr('%' + tmpCode +
    '%') + ' or ad=''*'')' + ' order by custno desc,ad desc';
  if not QueryBySQL(tmpSQL, Data) then
    Exit;
  SetRichEdit('');
  SetRichEdit(CheckLang('�p���ұi�K����'));
  l_CDS.Data := Data;
  if not l_CDS.IsEmpty then
  begin
    l_CDS.First;
    while not l_CDS.Eof do
    begin
      if (Pos('/' + tmpCustno + '/', '/' + l_CDS.Fields[0].AsString + '/') > 0) and (Pos(tmpCode, l_CDS.Fields[1].AsString)
        > 0) then
      begin
        isBool := True;
        SetRichEdit(l_CDS.Fields[2].AsString);
        Label14.Caption := (l_CDS.Fields[2].AsString);
        if l_CDS.Fields[2].AsString <> '�L�n�D' then
        begin
          tts := l_CDS.Fields[2].AsString;
          tts := StringReplace(tts, '���', mon + '���', []);
        end;

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
        if (Pos('/' + tmpCustno + '/', '/' + l_CDS.Fields[0].AsString + '/') > 0) and (l_CDS.Fields[1].AsString = '*')
          then
        begin
          isBool := True;
          SetRichEdit(l_CDS.Fields[2].AsString);
          Label14.Caption := (l_CDS.Fields[2].AsString);
          AssignJpg(l_CDS.Fields[3], Image3);
          if l_CDS.Fields[2].AsString <> '�L�n�D' then
          begin
            tts := l_CDS.Fields[2].AsString;
            tts := StringReplace(tts, '���', mon + '���', []);
          end;

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
          if l_CDS.Fields[2].AsString <> '�L�n�D' then
          begin
            tts := l_CDS.Fields[2].AsString;
            tts := StringReplace(tts, '���', mon + '���', []);
          end;

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
          if l_CDS.Fields[2].AsString <> '�L�n�D' then
          begin
            tts := l_CDS.Fields[2].AsString;
            tts := StringReplace(tts, '���', mon + '���', []);
          end;

          AssignJpg(l_CDS.Fields[3], Image3);
          Break;
        end;
        l_CDS.Next;
      end;
    end;
  end;
  if not isBool then
  begin
    SetRichEdit(CheckLang('���]�w'));
    Label14.Caption := ('���]�w');
  end;

  //mps103
  mps103(tmpCustno,tmpPno);


  //mps104
  mps104(tmpCustno);

  //lbl470
  lbl470(tmpPno);

  tmpSQL := 'select 1 from tc_shz_file where tc_shz01=%s and tc_shz02=%s and tc_shz03=%s and tc_shz04=%s';
  tmpSQL := Format(tmpSQL, [QuotedStr(tmpWono), QuotedStr(tmpPno), QuotedStr(lot), QuotedStr('MPS100')]);
  if not QueryOneCR(tmpSQL, Data, 'ORACLE') then
    Exit;
  if VarIsNull(Data) then
  begin
    tmpSQL :=
      'insert into tc_shz_file(tc_shz01,tc_shz02,tc_shz03,tc_shz04,tc_shz06,tc_shz07) values(%s,%s,%s,%s,sysdate,%s)';
    tmpSQL := Format(tmpSQL, [QuotedStr(tmpWono), QuotedStr(tmpPno), QuotedStr(lot), QuotedStr('MPS100'), QuotedStr(g_uinfo
      ^.UserId)]);
    PostBySQL(tmpSQL, 'ORACLE');
  end;

  //�]�m���ؼ��D���Ŧ�
  if RichEdit2.Lines.Count > 0 then
  begin
    RichEdit2.SelStart := 0;
    RichEdit2.SelLength := Length(RichEdit2.Lines.Strings[0]);
    RichEdit2.SelAttributes.Color := clBlue;
  end;

  for i := 1 to RichEdit2.Lines.Count - 2 do
  begin
    if Length(Trim(RichEdit2.Lines.Strings[i])) = 0 then
    begin
      tmpLine := SendMessage(RichEdit2.Handle, EM_LINEINDEX, i + 1, 0);
      RichEdit2.SelStart := tmpLine;
      RichEdit2.SelLength := Length(RichEdit2.Lines.Strings[i + 1]);
      RichEdit2.SelAttributes.Color := clBlue;
    end;
  end;
  NPI.Visible := (tmpCustno = 'AC121') and CheckNpi(tmpWono);
  if npi.Visible then
    tts := tts + ' ' + 'NPI����';
  if tts <> '' then
    Speak(Trim(tts));
  Application.ProcessMessages;
  Edit3.Enabled := False;
  Edit4.Enabled := false;
  try
    Edit3.text := '5';
    Edit4.text := '5';
    Sleep(1000);
    Application.ProcessMessages;
    Edit3.text := '4';
    Edit4.text := '4';
    Sleep(1000);
    Application.ProcessMessages;
    Edit3.text := '3';
    Edit4.text := '3';
    Sleep(1000);
    Application.ProcessMessages;
    Edit3.text := '2';
    Edit4.text := '2';
    Sleep(1000);
    Application.ProcessMessages;
    Edit3.text := '1';
    Edit4.text := '1';
    Sleep(1000);
    Application.ProcessMessages;
  finally
    Edit3.text := '';
    Edit4.text := '';
    Edit3.Enabled := True;
    Edit4.Enabled := True;
    Edit3.SetFocus;
  end;
    finally
    ls.free;
  end;
end;

procedure TFrmMPST100.Speak(msg: string);
var
  ss: TStringStream;
begin
  if not isadmin then
  begin
    if not client.Active then
      client.Open;
    ss := TStringStream.Create(msg);
    client.Socket.SendStream(ss);
  end;
end;

procedure TFrmMPST100.Edit3KeyPress(Sender: TObject; var Key: Char);
var
  tmpWono: string;
begin
  inherited;
  //if(Key in [';']) then key:='_';

  tmpWono := Trim(Edit3.Text);
  if Length(tmpWono) = 0 then
    Exit
  else if Length(tmpWono) = 10 then
  begin
    Image1.Picture := nil;
    Image2.Picture := nil;
    Image3.Picture := nil;
    Image4.Picture := nil;
    RichEdit1.Lines.Clear;
    //if (Length(tmpWono) <> 10) or (Copy(tmpWono, 4, 1) <> '-') then
    if (Copy(tmpWono, 4, 1) <> '-') then
    begin
      with RichEdit1 do
      begin
        Lines.Clear;
        Lines.Add(CheckLang('[' + tmpWono + ']�s�O�渹�榡�����T'));
        SelStart := 0;
        SelLength := Length(Lines.Strings[0]);
        SelAttributes.Color := clRed;
      end;
      Label3.caption := CheckLang('�s�O�渹�榡�����T');
      Label3.Font.Color := clRed;
      Exit;
    end;
  //Edit4.SetFocus;
  end;
end;

procedure TFrmMPST100.btn_mpst100EClick(Sender: TObject);
begin
  FrmMPST100_setE := TFrmMPST100_setE.Create(nil);
  FrmMPST100_setE.Caption := TToolButton(Sender).Caption;
  FrmMPST100_setE.ShowModal;
  FreeAndNil(FrmMPST100_setE);
end;

procedure TFrmMPST100.btn_mpst100FClick(Sender: TObject);
begin
  FrmMPST100_setF := TFrmMPST100_setF.Create(nil);
  FrmMPST100_setF.Caption := TToolButton(Sender).Caption;
  FrmMPST100_setF.ShowModal;
  FreeAndNil(FrmMPST100_setF);
end;

function TFrmMPST100.CheckNpi(wono: string): Boolean;
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

function TFrmMPST100.GetOao06(cds: TDataset): string;
var
  sql: string;
  tmpcds: TClientDataSet;
  data: OleVariant;
begin
  if cds.fieldbyname('orderno').AsString='' then
    exit;
  sql := 'select oao06 from oao_file where oao01=%s and oao03=%s';
  sql := Format(sql, [QuotedStr(cds.fieldbyname('orderno').AsString), cds.fieldbyname('orderitem').AsString]);
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

procedure TFrmMPST100.mps103(custno,pno: string);
var
  tmpCode, tmpSql: string;
  data: OleVariant;
begin
  tmpCode := Copy(pno, 7, 1);
  tmpSql := Copy(pno, 8, 1);
  if Pos(tmpCode, l_CopperALL) < Pos(tmpSql, l_CopperALL) then
    tmpCode := tmpSql;
  tmpSql := Copy(pno, 3, 4);
  data := Null;
  tmpSql := 'select top 1 value from mps103 where bu=' + QuotedStr(g_UInfo^.BU) + ' and oz like ' + QuotedStr('%' +
    tmpCode + '%') + ' and (custno like '+ QuotedStr('%'+custno+'%') + ' or custno=''*'') '+
    ' and mil_l<=' + QuotedStr(tmpSql) + ' and mil_h>=' + QuotedStr(tmpSql)+ ' order by custno desc';
  if not QueryBySQL(tmpSql, data) then
    Exit;

  SetRichEdit('');
  SetRichEdit(CheckLang('��]�ƶq'));
  l_CDS.Data := data;
  if l_CDS.IsEmpty then
  begin
    SetRichEdit(CheckLang('���]�w'));
    Label7.caption := CheckLang('��]�ƶq�G���]�w');
  end
  else
  begin
    SetRichEdit(l_CDS.Fields[0].AsString);
    Label7.caption := CheckLang('��]�ƶq�G') + l_CDS.Fields[0].AsString;
  end;
end;

procedure TFrmMPST100.mps104(tmpCustno: string);
var
  tmpSql: string;
  data: OleVariant;
begin
  data := Null;
  tmpSql := 'select top 1 value,img from mps104 where bu=' + QuotedStr(g_UInfo^.BU) + ' and (charindex(' + QuotedStr('/'
    + tmpCustno + '/') + ',''/''+custno+''/'')>0 or custno=''*'')' + ' order by custno desc';
  if not QueryBySQL(tmpSql, data) then
    Exit;

  SetRichEdit('');
  SetRichEdit(CheckLang('�̪O����'));
  l_CDS.Data := data;
  if l_CDS.IsEmpty then
  begin
    Label9.Caption := ('���]�w');
    SetRichEdit(CheckLang('���]�w'));
  end
  else
  begin
    Label9.Caption := (l_CDS.Fields[0].AsString);
    tts := tts + #13 + l_CDS.Fields[0].AsString;
    SetRichEdit(l_CDS.Fields[0].AsString);
    AssignJpg(l_CDS.Fields[1], Image1);
  end;
end;

procedure TFrmMPST100.lbl470(tmpPno: string);
var
  tmpSql: string;
  data: OleVariant;
begin
  tmpSql := 'exec [dbo].[proc_MPST100] ' + QuotedStr(g_UInfo^.BU) + ',' + QuotedStr(tmpPno);
  if not QueryBySQL(tmpSql, data) then
    Exit;

  SetRichEdit('');
  SetRichEdit(CheckLang('�����C��'));
  l_CDS.Data := data;
  if l_CDS.IsEmpty then
    SetRichEdit(CheckLang('���]�w'))
  else
  begin
    SetRichEdit(l_CDS.FieldByName('info').AsString);
    pnlbg.Caption := (l_CDS.FieldByName('info').AsString);
    pnlbg.Color := $ + l_CDS.FieldByName('bgcolor').AsInteger;
    pnlfont.Color := $ + l_CDS.FieldByName('fontcolor').AsInteger;
  end;
end;

procedure TFrmMPST100.LoadPlayer;
const
  app = 'ttsplayer.exe';

  function FindTask(ExeFileName: string): Boolean;
  const
    PROCESS_TERMINATE = $0001;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
  begin
    result := False;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
    while integer(ContinueLoop) <> 0 do
    begin
      if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) = UpperCase(ExtractFileName(ExeFileName))) or (UpperCase
        (FProcessEntry32.szExeFile) = UpperCase(ExeFileName))) then
      begin
        Result := True;
        Break;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    CloseHandle(FSnapshotHandle);
  end;

begin
  if not FindTask(app) then
    WinExec(pChar(app), SW_HIDE);
end;

procedure TFrmMPST100.StartTcpServer;
begin
  server := TIdTCPServer.Create(Self);
  server.DefaultPort := 5555;
  server.Active := True;
end;

function TFrmMPST100.GetCustno(str: string): string;
var
  i: integer;
begin
  str := Trim(str);
  result := '';
  if str = '' then
    exit;
  try
    for i := 1 to Length(str) do
    begin
      if (str[i] in ['0'..'9']) or (str[i] in ['A'..'Z']) then
        result := result + str[i];
    end;
  except
    on ex: Exception do
    begin
      result := '';
      ShowMsg(ex.Message);
    end;
  end;
end;

end.

