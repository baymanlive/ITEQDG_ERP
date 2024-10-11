unit unIPQCT622;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, ImgList, ComCtrls, ToolWin, StdCtrls, DBClient,
  DB, DBCtrlsEh, Mask, DBCtrls;

type
  TFrmIPQCT622 = class(TFrmSTDI080)
    btn_post: TToolButton;
    ad: TLabel;
    ver: TLabel;
    lot: TLabel;
    sg1_time: TLabel;
    sg1_value1: TLabel;
    sg1_value2: TLabel;
    sg1_value3: TLabel;
    Bevel1: TBevel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DS: TDataSource;
    sg1_cz1: TLabel;
    DBEdit4: TDBEdit;
    sg1_cz2: TLabel;
    DBEdit5: TDBEdit;
    sg1_cz3: TLabel;
    DBEdit12: TDBEdit;
    sg1_std: TLabel;
    DBEdit18: TDBEdit;
    sg1_stdcz: TLabel;
    DBEdit20: TDBEdit;
    SG1_Opt_uid: TLabel;
    DBEdit22: TDBEdit;
    SG1_Opt_uname: TLabel;
    DBEdit24: TDBEdit;
    sg2_atime: TLabel;
    sg2_avalue1: TLabel;
    sg2_avalue2: TLabel;
    sg2_avalue3: TLabel;
    sg2_acz1: TLabel;
    sg2_acz2: TLabel;
    sg2_acz3: TLabel;
    sg2_astd: TLabel;
    sg2_astdcz: TLabel;
    sg2_aOpt_uid: TLabel;
    sg2_aOpt_uname: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBEdit13: TDBEdit;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    DBEdit17: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit21: TDBEdit;
    sg2_btime: TLabel;
    sg2_bvalue1: TLabel;
    sg2_bvalue2: TLabel;
    sg2_bvalue3: TLabel;
    sg2_bcz1: TLabel;
    sg2_bcz2: TLabel;
    sg2_bcz3: TLabel;
    sg2_bstd: TLabel;
    sg2_bstdcz: TLabel;
    sg2_bOpt_uid: TLabel;
    sg2_bOpt_uname: TLabel;
    DBEdit23: TDBEdit;
    DBEdit25: TDBEdit;
    DBEdit26: TDBEdit;
    DBEdit27: TDBEdit;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    DBEdit31: TDBEdit;
    DBEdit32: TDBEdit;
    DBEdit33: TDBEdit;
    sg2_ctime: TLabel;
    sg2_cvalue1: TLabel;
    sg2_cvalue2: TLabel;
    sg2_cvalue3: TLabel;
    sg2_ccz1: TLabel;
    sg2_cstd: TLabel;
    sg2_cOpt_uid: TLabel;
    sg2_cOpt_uname: TLabel;
    DBEdit34: TDBEdit;
    DBEdit35: TDBEdit;
    DBEdit36: TDBEdit;
    DBEdit37: TDBEdit;
    DBEdit38: TDBEdit;
    DBEdit39: TDBEdit;
    DBEdit40: TDBEdit;
    DBEdit41: TDBEdit;
    DBEdit42: TDBEdit;
    DBEdit43: TDBEdit;
    sg3_time: TLabel;
    sg3_value1: TLabel;
    sg3_value2: TLabel;
    sg3_value3: TLabel;
    sg3_std: TLabel;
    SG3_Opt_uid: TLabel;
    SG3_Opt_uname: TLabel;
    DBEdit64: TDBEdit;
    DBEdit65: TDBEdit;
    DBEdit66: TDBEdit;
    DBEdit67: TDBEdit;
    DBEdit68: TDBEdit;
    DBEdit69: TDBEdit;
    DBEdit70: TDBEdit;
    DBEdit71: TDBEdit;
    DBEdit72: TDBEdit;
    DBEdit73: TDBEdit;
    cl: TLabel;
    cl_std: TLabel;
    br: TLabel;
    br_std: TLabel;
    xidu: TLabel;
    xidu_std: TLabel;
    DBEdit74: TDBEdit;
    DBEdit75: TDBEdit;
    DBEdit76: TDBEdit;
    DBEdit77: TDBEdit;
    DBEdit78: TDBEdit;
    DBEdit79: TDBEdit;
    DBText1: TDBText;
    DBText2: TDBText;
    DBText3: TDBText;
    DBText4: TDBText;
    DBText7: TDBText;
    Label1: TLabel;
    Niandu: TLabel;
    Niandu_std: TLabel;
    DBEdit80: TDBEdit;
    DBEdit81: TDBEdit;
    DBEdit44: TDBEdit;
    DBEdit45: TDBEdit;
    DBEdit46: TDBEdit;
    DBEdit47: TDBEdit;
    DBEdit48: TDBEdit;
    Label2: TLabel;
    btn_ipqct622: TToolButton;
    ClientDataSet1: TClientDataSet;
    btn_ipqct622_audit: TToolButton;
    tj_comfirm: TLabel;
    DBEdit49: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_ipqct622Click(Sender: TObject);
    procedure btn_ipqct622_auditClick(Sender: TObject);
  private
    l_UserCDS: TClientDataSet;
    procedure SetCtrlEnabled(IsEnabled: Boolean);
    procedure SetDBTextColor;
    procedure l_CDSAfterEdit(DataSet: TDataSet);
    procedure sgChange(Sender: TField);
    procedure ShowData(Data: OleVariant);
  public
    l_CDS: TClientDataSet;
    { Public declarations }
  protected
    procedure SetToolBar; override;     //設置工具欄按扭
  end;

var
  FrmIPQCT622: TFrmIPQCT622;


implementation

uses
  unGlobal, unCommon, unIPQCT622_query, unIPQCT622_detail;

{$R *.dfm}

procedure TFrmIPQCT622.SetToolBar;
begin
  inherited;
  btn_ipqct622_audit.Enabled := btn_query.Enabled;
end;

function FindNumber(SourceStr: WideString; const StartIndex: Integer = 1): Double;
var
  fstnum: Boolean;
  i, pos1, tmpIndex: Integer;
  tmpResult: WideString;
begin
  fstnum := False;
  pos1 := 0;
  tmpIndex := StartIndex;
  if tmpIndex < 1 then
    tmpIndex := 1;

  for i := tmpIndex to Length(SourceStr) do
  begin
    if Char(SourceStr[i]) in ['0'..'9', '.'] then
    begin
      fstnum := True;
      if SourceStr[i] = '.' then
        pos1 := pos1 + 1;
      if pos1 < 2 then
        tmpResult := tmpResult + SourceStr[i]
      else
        Break;
    end
    else if fstnum then
      Break;
  end;

  if Length(tmpResult) > 0 then
  begin
    pos1 := Pos(tmpResult, SourceStr);
    if (pos1 > 1) and (SourceStr[pos1 - 1] = '-') then
      tmpResult := '-' + tmpResult;
    Result := StrToFloat(tmpResult);
  end
  else
    Result := 0;
end;

procedure TFrmIPQCT622.SetCtrlEnabled(IsEnabled: Boolean);
var
  i: Integer;
begin
  for i := 0 to Self.ControlCount - 1 do
    if (Self.Controls[i].Tag = 1) and (not (Self.Controls[i] is TLabel)) then
      Self.Controls[i].Enabled := IsEnabled and g_MInfo^.R_edit;
end;

procedure TFrmIPQCT622.SetDBTextColor;
begin
  DBText1.Font.Color := clWindowText;
  DBText2.Font.Color := clWindowText;
  DBText3.Font.Color := clWindowText;
  DBText4.Font.Color := clWindowText;
  //DBText5.Font.Color:=clWindowText;
  //DBText6.Font.Color:=clWindowText;
  DBText7.Font.Color := clWindowText;
  if not l_CDS.Active or l_CDS.IsEmpty then
    Exit;

  if SameText(l_CDS.FieldByName('sg1_ret').AsString, 'A') then
    DBText1.Font.Color := clBlue
  else if SameText(l_CDS.FieldByName('sg1_ret').AsString, 'C') then
    DBText1.Font.Color := clRed;

  if SameText(l_CDS.FieldByName('sg2_aret').AsString, 'A') then
    DBText2.Font.Color := clBlue
  else if SameText(l_CDS.FieldByName('sg2_aret').AsString, 'C') then
    DBText2.Font.Color := clRed;

  if SameText(l_CDS.FieldByName('sg2_bret').AsString, 'A') then
    DBText3.Font.Color := clBlue
  else if SameText(l_CDS.FieldByName('sg2_bret').AsString, 'C') then
    DBText3.Font.Color := clRed;

  if SameText(l_CDS.FieldByName('sg2_cret').AsString, 'A') then
    DBText4.Font.Color := clBlue
  else if SameText(l_CDS.FieldByName('sg2_cret').AsString, 'C') then
    DBText4.Font.Color := clRed;
  {
  if SameText(l_CDS.FieldByName('sg2_dret').AsString,'A') then
     DBText5.Font.Color:=clBlue
  else if SameText(l_CDS.FieldByName('sg2_dret').AsString,'C') then
     DBText5.Font.Color:=clRed;

  if SameText(l_CDS.FieldByName('sg2_eret').AsString,'A') then
     DBText6.Font.Color:=clBlue
  else if SameText(l_CDS.FieldByName('sg2_eret').AsString,'C') then
     DBText6.Font.Color:=clRed;
  }
  if SameText(l_CDS.FieldByName('sg3_ret').AsString, 'A') then
    DBText7.Font.Color := clBlue
  else if SameText(l_CDS.FieldByName('sg3_ret').AsString, 'C') then
    DBText7.Font.Color := clRed;
end;

procedure TFrmIPQCT622.l_CDSAfterEdit(DataSet: TDataSet);
begin
  l_CDS.FieldByName('muser_wx').AsString := g_UInfo^.UserId;
  l_CDS.FieldByName('mdate_wx').AsDateTime := now;
end;

procedure TFrmIPQCT622.sgChange(Sender: TField);
var
  tmpStr: string;
  v, diff, minv, maxv: Double;

  //更新測試人員

  procedure SetOpt_uid;
  var
    bo: Boolean;
  begin
    bo := l_CDS.FieldByName(tmpStr + 'value1').IsNull and   //***l_CDS.FieldByName(tmpStr+'time').IsNull and 取樣時間改為自動帶出
      l_CDS.FieldByName(tmpStr + 'cz1').IsNull and l_CDS.FieldByName(tmpStr + 'value2').IsNull and l_CDS.FieldByName(tmpStr + 'cz2').IsNull and l_CDS.FieldByName(tmpStr + 'value3').IsNull and l_CDS.FieldByName(tmpStr + 'cz3').IsNull;
    if bo then
    begin
      l_CDS.FieldByName(tmpStr + 'time').Clear;           //****
      l_CDS.FieldByName(tmpStr + 'Opt_uid').Clear;
      l_CDS.FieldByName(tmpStr + 'Opt_uname').Clear;
    end
    else
    begin
      l_CDS.FieldByName(tmpStr + 'time').AsDateTime := Now; //***
      l_CDS.FieldByName(tmpStr + 'Opt_uid').AsString := g_UInfo^.UserId;
      l_CDS.FieldByName(tmpStr + 'Opt_uname').AsString := g_UInfo^.UserName;
    end;
  end;

  //取標準值
  function GetStd(fname: string): Boolean;
  var
    pos1: Integer;
  begin
    Result := False;

    pos1 := Pos('±', l_CDS.FieldByName(fname).AsString);
    if pos1 > 0 then
    begin
      v := FindNumber(l_CDS.FieldByName(fname).AsString);
      diff := FindNumber(l_CDS.FieldByName(fname).AsString, pos1);
      minv := v - diff;
      maxv := v + diff;

      Result := (minv >= 0) and (maxv >= 0) and (maxv >= minv);
    end;
  end;

  //判定結果
  function CheckData(fname1, fname2, fname3: string): string;
  var
    tmpRet1, tmpRet2, tmpRet3: string;
  begin
    if l_CDS.FieldByName(fname1).IsNull then
      tmpRet1 := ''
    else if (l_CDS.FieldByName(fname1).AsFloat < minv) or (l_CDS.FieldByName(fname1).AsFloat > maxv) then
      tmpRet1 := 'C'
    else
      tmpRet1 := 'A';

    if l_CDS.FieldByName(fname2).IsNull then
      tmpRet2 := ''
    else if (l_CDS.FieldByName(fname2).AsFloat < minv) or (l_CDS.FieldByName(fname2).AsFloat > maxv) then
      tmpRet2 := 'C'
    else
      tmpRet2 := 'A';

    if l_CDS.FieldByName(fname3).IsNull then
      tmpRet3 := ''
    else if (l_CDS.FieldByName(fname3).AsFloat < minv) or (l_CDS.FieldByName(fname3).AsFloat > maxv) then
      tmpRet3 := 'C'
    else
      tmpRet3 := 'A';

    //三種情況:空白,A級,C級(任意一個不在範圍內為C級)
    if (Length(tmpRet1) = 0) and (Length(tmpRet2) = 0) and (Length(tmpRet3) = 0) then
      Result := ''
    else if SameText(tmpRet1, 'C') or SameText(tmpRet2, 'C') or SameText(tmpRet3, 'C') then
      Result := 'C'
    else
      Result := 'A';
  end;

begin
  //判定等級
  if pos('value', LowerCase(TField(Sender).FieldName)) > 0 then
  begin
    if GetStd('sg1_std') then
      l_CDS.FieldByName('sg1_ret').AsString := CheckData('sg1_value1', 'sg1_value2', 'sg1_value3')
    else
      l_CDS.FieldByName('sg1_ret').AsString := '';

    if GetStd('sg2_astd') then
      l_CDS.FieldByName('sg2_aret').AsString := CheckData('sg2_avalue1', 'sg2_avalue2', 'sg2_avalue3')
    else
      l_CDS.FieldByName('sg2_aret').AsString := '';

    if GetStd('sg2_bstd') then
      l_CDS.FieldByName('sg2_bret').AsString := CheckData('sg2_bvalue1', 'sg2_bvalue2', 'sg2_bvalue3')
    else
      l_CDS.FieldByName('sg2_bret').AsString := '';

    if GetStd('sg2_cstd') then
      l_CDS.FieldByName('sg2_cret').AsString := CheckData('sg2_cvalue1', 'sg2_cvalue2', 'sg2_cvalue3')
    else
      l_CDS.FieldByName('sg2_cret').AsString := '';

    if GetStd('sg2_dstd') then
      l_CDS.FieldByName('sg2_dret').AsString := CheckData('sg2_dvalue1', 'sg2_dvalue2', 'sg2_dvalue3')
    else
      l_CDS.FieldByName('sg2_dret').AsString := '';

    if GetStd('sg2_estd') then
      l_CDS.FieldByName('sg2_eret').AsString := CheckData('sg2_evalue1', 'sg2_evalue2', 'sg2_evalue3')
    else
      l_CDS.FieldByName('sg2_eret').AsString := '';

    if GetStd('sg3_std') then
      l_CDS.FieldByName('sg3_ret').AsString := CheckData('sg3_value1', 'sg3_value2', 'sg3_value3')
    else
      l_CDS.FieldByName('sg3_ret').AsString := '';

    SetDBTextColor;
  end;

  tmpStr := Copy(TField(Sender).FieldName, 1, 4);
  if SameText(tmpStr, 'SG1_') or SameText(tmpStr, 'SG3_') then
  begin
    SetOpt_uid;
    Exit;
  end;

  tmpStr := UpperCase(Copy(TField(Sender).FieldName, 1, 5));
  if Pos(',' + tmpStr + ',', ',SG2_A,SG2_B,SG2_C,SG2_D,SG2_E,') > 0 then
  begin
    SetOpt_uid;
    Exit;
  end;
end;

procedure TFrmIPQCT622.ShowData(Data: OleVariant);
var
  i: Integer;
  fname: string;
begin
  l_CDS.Data := Data;
  for i := 0 to l_CDS.FieldCount - 1 do
  begin
    fname := LowerCase(l_CDS.Fields[i].FieldName);
    if SameText('sg', Copy(fname, 1, 2)) and (Pos('std', fname) = 0) and ((Pos('value', fname) > 0) or (Pos('cz', fname) > 0)) then
      l_CDS.FieldByName(fname).OnChange := sgChange;
  end;

  Label2.Visible := Length(Trim(l_CDS.FieldByName('waste_pno').AsString)) > 0;
  if Label2.Visible then
    Label2.Caption := CheckLang('過期物料：') + l_CDS.FieldByName('waste_pno').AsString;

  btn_post.Enabled := not l_CDS.IsEmpty;
  SetCtrlEnabled(not l_CDS.IsEmpty);
  SetDBTextColor;
end;

procedure TFrmIPQCT622.FormCreate(Sender: TObject);
begin
  p_TableName := '@';
  btn_ipqct622_audit.Left := btn_quit.Left;
  btn_post.Left := ToolButton1.Left;
  btn_ipqct622.Left := btn_quit.Left;

  inherited;

  SetLabelCaption(Self, 'IPQC620');
  Label1.Caption := CheckLang('測試項目：SG1：SG、細度及鹵素；SG2：SG、細度；SG3：SG');
  Label2.Visible := False;
  btn_print.Visible := False;
  btn_export.Visible := False;
  btn_post.Enabled := g_MInfo^.R_edit;
  l_UserCDS := TClientDataSet.Create(Self);
  l_CDS := TClientDataSet.Create(Self);
  l_CDS.AfterEdit := l_CDSAfterEdit;
  DS.DataSet := l_CDS;
  SetCtrlEnabled(False);
  SetDBTextColor;
end;

procedure TFrmIPQCT622.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_UserCDS);
  FreeAndNil(l_CDS);
end;

procedure TFrmIPQCT622.btn_queryClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmIPQCT622_query) then
    FrmIPQCT622_query := TFrmIPQCT622_query.Create(Application);
  if FrmIPQCT622_query.ShowModal = mrOK then
    ShowData(FrmIPQCT622_query.l_Data);

end;

procedure TFrmIPQCT622.btn_ipqct622Click(Sender: TObject);
begin
  inherited;
  FrmIPQCT622_detail := TFrmIPQCT622_detail.Create(nil);
  try
    if FrmIPQCT622_detail.ShowModal = mrOK then
      ShowData(FrmIPQCT622_detail.l_Data);
  finally
    FreeAndNil(FrmIPQCT622_detail);
  end
end;

procedure TFrmIPQCT622.btn_postClick(Sender: TObject);
const
  msg = '請輸入測試人員!';
var
  b1, b2, b3: Boolean;
  v: Double;
begin
  inherited;
  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,你無此作業修改權限!', 48);
    Exit;
  end;

  if (not l_CDS.Active) or l_CDS.IsEmpty then
  begin
    ShowMsg('無資料!', 48);
    Exit;
  end;

  if l_CDS.State in [dsEdit] then
    l_CDS.Post;

  //SG1、SG2、SG3需要按順序輸入
  with l_CDS do
  begin
    b1 := FieldByName('sg1_value1').IsNull and FieldByName('sg1_value2').IsNull and FieldByName('sg1_value3').IsNull and FieldByName('sg1_cz1').IsNull and FieldByName('sg1_cz2').IsNull and FieldByName('sg1_cz3').IsNull;

    b2 := FieldByName('sg2_avalue1').IsNull and FieldByName('sg2_avalue2').IsNull and FieldByName('sg2_avalue3').IsNull and FieldByName('sg2_bvalue1').IsNull and FieldByName('sg2_bvalue2').IsNull and FieldByName('sg2_bvalue3').IsNull and FieldByName('sg2_cvalue1').IsNull and FieldByName('sg2_cvalue2').IsNull and FieldByName('sg2_cvalue3').IsNull and FieldByName('sg2_acz1').IsNull and FieldByName('sg2_acz2').IsNull and FieldByName('sg2_acz3').IsNull and FieldByName('sg2_bcz1').IsNull and FieldByName('sg2_bcz2').IsNull and FieldByName('sg2_bcz3').IsNull and FieldByName('sg2_ccz1').IsNull and FieldByName('sg2_ccz2').IsNull and FieldByName('sg2_ccz3').IsNull;

    b3 := FieldByName('sg3_value1').IsNull and FieldByName('sg3_value2').IsNull and FieldByName('sg3_value3').IsNull and FieldByName('sg3_cz1').IsNull and FieldByName('sg3_cz2').IsNull and FieldByName('sg3_cz3').IsNull;
  end;

  if b1 then
    if (not b2) or (not b3) then
    begin
      ShowMsg('請按順序輸入SG1、SG2、SG3', 48);
      Exit;
    end;

  if b2 and (not b3) then
  begin
    ShowMsg('請按順序輸入SG1、SG2、SG3', 48);
    Exit;
  end;

  if (Length(l_CDS.FieldByName('sg1_opt_uid').AsString) > 0) and (Length(Trim(l_CDS.FieldByName('sg1_opt_uname').AsString)) = 0) then
  begin
    ShowMsg(msg, 48);
    DBEdit22.SetFocus;
    Exit;
  end;

  if (Length(l_CDS.FieldByName('sg2_aopt_uid').AsString) > 0) and (Length(Trim(l_CDS.FieldByName('sg2_aopt_uname').AsString)) = 0) then
  begin
    ShowMsg(msg, 48);
    DBEdit19.SetFocus;
    Exit;
  end;

  if (Length(l_CDS.FieldByName('sg2_bopt_uid').AsString) > 0) and (Length(Trim(l_CDS.FieldByName('sg2_bopt_uname').AsString)) = 0) then
  begin
    ShowMsg(msg, 48);
    DBEdit32.SetFocus;
    Exit;
  end;

  if (Length(l_CDS.FieldByName('sg2_copt_uid').AsString) > 0) and (Length(Trim(l_CDS.FieldByName('sg2_copt_uname').AsString)) = 0) then
  begin
    ShowMsg(msg, 48);
    DBEdit42.SetFocus;
    Exit;
  end;
  {
  if (Length(l_CDS.FieldByName('sg2_dopt_uid').AsString)>0) and
     (Length(Trim(l_CDS.FieldByName('sg2_dopt_uname').AsString))=0) then
  begin
    ShowMsg(msg,48);
    DBEdit52.SetFocus;
    Exit;
  end;

  if (Length(l_CDS.FieldByName('sg2_eopt_uid').AsString)>0) and
     (Length(Trim(l_CDS.FieldByName('sg2_eopt_uname').AsString))=0) then
  begin
    ShowMsg(msg,48);
    DBEdit62.SetFocus;
    Exit;
  end;
  }
  if (Length(l_CDS.FieldByName('sg3_opt_uid').AsString) > 0) and (Length(Trim(l_CDS.FieldByName('sg3_opt_uname').AsString)) = 0) then
  begin
    ShowMsg(msg, 48);
    DBEdit72.SetFocus;
    Exit;
  end;

  if (not l_CDS.FieldByName('cl').IsNull) and (Length(l_CDS.FieldByName('cl_std').AsString) > 0) and (l_CDS.FieldByName('cl').AsString <> 'ND') then
  begin
    v := FindNumber(l_CDS.FieldByName('cl_std').AsString, 1);
    if (v > 0) and (l_CDS.FieldByName('cl').AsFloat >= v) then
      ShowMsg('[%s]不在標準內!', 48, MyStringReplace(cl.Caption));
  end;

  if (not l_CDS.FieldByName('br').IsNull) and (Length(l_CDS.FieldByName('br_std').AsString) > 0) then
  begin
    v := FindNumber(l_CDS.FieldByName('br_std').AsString, 1);
    if (v > 0) and (l_CDS.FieldByName('br').AsFloat >= v) then
      ShowMsg('[%s]不在標準內!', 48, MyStringReplace(br.Caption));
  end;

  if (not l_CDS.FieldByName('xidu').IsNull) and (Length(l_CDS.FieldByName('xidu_std').AsString) > 0) then
  begin
    v := FindNumber(l_CDS.FieldByName('xidu_std').AsString, 1);
    if (v > 0) and (l_CDS.FieldByName('xidu').AsFloat >= v) then
      ShowMsg('[%s]不在標準內!', 48, MyStringReplace(xidu.Caption));
  end;

  if PostBySQLFromDelta(l_CDS, 'IPQC620', 'bu,ad,ver,lot') then
    ShowMsg('儲存成功!', 64);
end;

procedure TFrmIPQCT622.btn_ipqct622_auditClick(Sender: TObject);
begin
  inherited;
  DS.DataSet.edit;
  DS.DataSet.FieldByName('confirm').value := g_uinfo^.UserId;
  DS.DataSet.post;
  if not PostBySQLFromDelta(l_CDS, 'IPQC620', 'bu,ad,ver,lot') then
    ShowMsg('操作失敗', 64);
end;

end.

