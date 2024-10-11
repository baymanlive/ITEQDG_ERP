{*******************************************************}
{                                                       }
{                unMPST040_ordlist                      }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: DG、GZ未交訂單明細        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_ordlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, ComCtrls, ToolWin, GridsEh, DBAxisGridsEh, DBGridEh, ImgList,
  StdCtrls, Buttons, ExtCtrls, DBClient, Math;

type
  TFrmMPST040_ordlist = class(TFrmSTDI051)
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    ToolBar: TToolBar;
    btn_export: TToolButton;
    btn_query: TToolButton;
    btn1: TToolButton;
    btn2: TToolButton;
    ToolButton5: TToolButton;
    btn3: TToolButton;
    pnlmsg: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_exportClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_img02All, l_img02Out: string;
    l_SalCDS: TClientDataSet;
    procedure SetBtnEnabled(bool: Boolean);
    procedure GetDS(xFliter: string);
    { Private declarations }
  public
    l_bu: string;
    { Public declarations }
  end;

var
  FrmMPST040_ordlist: TFrmMPST040_ordlist;

implementation

uses
  unGlobal, unCommon, unFind, unCCLStruct;

{$R *.dfm}

procedure TFrmMPST040_ordlist.SetBtnEnabled(bool: Boolean);
begin
  btn_query.Enabled := bool;
  btn_export.Enabled := bool;
  btn1.Enabled := bool;
  btn2.Enabled := bool;
  DBGridEh1.Enabled := bool;
end;

procedure TFrmMPST040_ordlist.GetDS(xFliter: string);
var
  Data: OleVariant;
  tmpSQL, tmpOrderno, tmpPriorId, tmpOAO06: string;
  tmpRecNo, tmpPriorSno: Integer;
  tmpCDS: TClientDataSet;
begin
  l_SalCDS.DisableControls;
  pnlmsg.Caption := CheckLang('正在查詢未交訂單...');
  pnlmsg.Visible := True;
  Application.ProcessMessages;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpSQL := 'select oea02,oea01,oeb03,oea04,occ02,' + ' case when substr(oeb04,1,1) in (''R'',''N'',''B'',''M'') then ''PP''' + '	when substr(oeb04,1,1) in (''E'',''T'') and substr(oeb04,1,2) not in (''EI'',''ES'') then ''CCL'' else ''err'' end as ptype,' + ' case when instr(oeb06,''TC'',1,1)>0 then substr(oeb06,1,instr(oeb06,''TC'',1,1)-1)' + ' when instr(oeb06,''BS'',1,1)>0 then substr(oeb06,1,instr(oeb06,''BS'',1,1)-1) else ''err'' end as ad,' +
      ' oeb04,oeb06,ima021,ta_oeb01,ta_oeb02,ta_oeb04,struct,oeb05,oeb12,oeb24,qty,oeb15,adate,' + ' cdate,aremark,bremark,stkremark,oea10,oeb11,ta_oeb10,oao06,ocd221 from' + ' (select C.*,oao06 from' + ' (select B.*,ima021 from' + ' (select A.*,occ02,occ02 stkremark from' + ' (select oea02,oea01,oeb03,oea04,oea044,oeb04,oeb06,ta_oeb01,' + ' ta_oeb02,ta_oeb04,ta_oeb10 struct,oeb05,oeb12,oeb24,oeb12 qty,oeb15,' + ' ta_oeb10 adate,ta_oeb10 cdate,ta_oeb10 aremark,ta_oeb10 bremark,' +
      ' to_char(oea02,''YYYY/MM/DD'') q_oea02,oea10,oeb11,ta_oeb10' + ' from ' + l_bu + '.oea_file inner join ' + l_bu + '.oeb_file on oea01=oeb01' + ' where oeaconf=''Y'' and oeb12>oeb24 and oeb70=''N''' + ' and to_char(oea02,''YYYY/MM/DD'')>=''2016/01/01''' + ' and oea01 not like ''226%''' + ' and oea01 not like ''228%''' + ' and oea01 not like ''22A%''' + ' and oea01 not like ''22B%'''//           +' and oea04 not in(''N012'',''N005'')'
      + ' and (oeb04 like ''B%'' or oeb04 like ''E%'' or oeb04 like ''M%''' + ' or oeb04 like ''N%'' or oeb04 like ''P%'' or oeb04 like ''Q%''' + ' or oeb04 like ''R%'' or oeb04 like ''T%'')' + ' and oeb06 not like ''玻%''' + ' and oeb06 not like ''ML%'') A' + ' inner join ' + l_bu + '.occ_file on oea04=occ01 where 1=1 ' + xFliter + ' ) B left join ' + l_bu + '.ima_file on oeb04=ima01' + ' ) C left join ' + l_bu + '.oao_file on oea01=oao01 and oeb03=oao03' + ' ) D left join ' + l_bu + '.ocd_file on oea04=ocd01 and oea044=ocd02' + ' order by oea02,oea01,oeb03';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;

    tmpPriorId := '@';
    tmpPriorSno := 0;
    tmpRecNo := 1;
    l_SalCDS.Data := Data;
    with l_SalCDS do
    begin
      if IsEmpty then
        Exit;

      First;
      while not Eof do
      begin
        if (FieldByName('oea01').AsString = tmpPriorId) and   //oao_file有多筆時只保留一筆,oao06備註累加
          (FieldByName('oeb03').AsInteger = tmpPriorSno) then
        begin
          tmpOAO06 := FieldByName('oao06').AsString;
          Delete;
          RecNo := tmpRecNo;

          if Length(tmpOAO06) > 0 then
          begin
            Edit;
            if Length(FieldByName('oao06').AsString) > 0 then
              FieldByName('oao06').AsString := FieldByName('oao06').AsString + ',' + tmpOAO06
            else
              FieldByName('oao06').AsString := tmpOAO06;
            Post;
          end;
        end
        else
        begin
          if Pos(FieldByName('oea01').AsString, tmpOrderno) = 0 then
            tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('oea01').AsString);

          Edit;
          FieldByName('qty').AsFloat := RoundTo(FieldByName('oeb12').AsFloat - FieldByName('oeb24').AsFloat, -3);
          FieldByName('adate').Clear;
          FieldByName('cdate').Clear;
          FieldByName('aremark').Clear;
          FieldByName('bremark').Clear;
          FieldByName('stkremark').Clear;
          FieldByName('struct').Clear;
          Post;
        end;

        tmpPriorId := FieldByName('oea01').AsString;
        tmpPriorSno := FieldByName('oeb03').AsInteger;
        tmpRecNo := RecNo;

        Next;
      end;
    end;

    if Length(tmpOrderno) > 0 then
    begin
      pnlmsg.Caption := CheckLang('正在處理已結案資料...');
      Application.ProcessMessages;

      //刪除已結案
      Delete(tmpOrderno, 1, 1);
      Data := null;
      tmpSQL := 'Select Orderno,Orderitem' + ' From MPS300 Where Bu=' + Quotedstr(l_bu) + ' And Orderno in (' + tmpOrderno + ') And Flag=1';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          while l_SalCDS.Locate('oea01;oeb03', VarArrayOf([Fields[0].AsString, Fields[1].AsInteger]), []) do
            l_SalCDS.Delete;

          if l_SalCDS.IsEmpty then
            Exit;
          Next;
        end;

      pnlmsg.Caption := CheckLang('正在更新達交日期...');
      Application.ProcessMessages;
      
      //更新達交日期、CALL貨日期
      Data := null;
      tmpSQL := 'Select Orderno,Orderitem,Adate,CDate,Remark1,Remark2' + ' From MPS200 Where Bu=' + Quotedstr(l_bu) + ' And Orderno in (' + tmpOrderno + ')' + ' And IsNull(GarbageFlag,0)=0';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      with tmpCDS do
      begin
        First;
        while not Eof do
        begin
          if l_SalCDS.Locate('oea01;oeb03', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('Orderitem').AsInteger]), []) then
          begin
            l_SalCDS.Edit;
            if not FieldByName('Adate').IsNull then
            begin
              if l_SalCDS.FieldByName('adate').AsString = '' then
                l_SalCDS.FieldByName('adate').AsString := FieldByName('Adate').AsString
              else if Pos(FieldByName('Adate').AsString, l_SalCDS.FieldByName('adate').AsString) = 0 then
                l_SalCDS.FieldByName('adate').AsString := l_SalCDS.FieldByName('adate').AsString + ',' + FieldByName('Adate').AsString;
            end;

            if not FieldByName('Cdate').IsNull then
            begin
              if l_SalCDS.FieldByName('cdate').AsString = '' then
                l_SalCDS.FieldByName('cdate').AsString := FieldByName('Cdate').AsString
              else if Pos(FieldByName('Cdate').AsString, l_SalCDS.FieldByName('cdate').AsString) = 0 then
                l_SalCDS.FieldByName('cdate').AsString := l_SalCDS.FieldByName('cdate').AsString + ',' + FieldByName('Cdate').AsString;
            end;

            if Length(Trim(FieldByName('Remark1').AsString)) > 0 then
            begin
              if l_SalCDS.FieldByName('aremark').AsString <> '' then
                l_SalCDS.FieldByName('aremark').AsString := l_SalCDS.FieldByName('aremark').AsString + ',' + FieldByName('Remark1').AsString
              else
                l_SalCDS.FieldByName('aremark').AsString := FieldByName('Remark1').AsString;
            end;

            if Length(Trim(FieldByName('Remark2').AsString)) > 0 then
            begin
              if l_SalCDS.FieldByName('bremark').AsString <> '' then
                l_SalCDS.FieldByName('bremark').AsString := l_SalCDS.FieldByName('bremark').AsString + ',' + FieldByName('Remark2').AsString
              else
                l_SalCDS.FieldByName('bremark').AsString := FieldByName('Remark2').AsString;
            end;

            l_SalCDS.Post;
          end;
          Next;
        end;
      end;
    end;

    if l_SalCDS.ChangeCount > 0 then
      l_SalCDS.MergeChangeLog;

    pnlmsg.Caption := CheckLang('正在更新結構...');
    Application.ProcessMessages;
    SetCCLStruct(l_SalCDS, l_bu, 'oeb04', 'struct', 'ta_oeb04');

  finally
    FreeAndNil(tmpCDS);
    if l_SalCDS.Active and (not l_SalCDS.IsEmpty) then
      l_SalCDS.First;
    l_SalCDS.EnableControls;
    pnlmsg.Visible := False;
  end;
end;

procedure TFrmMPST040_ordlist.FormCreate(Sender: TObject);
begin
  inherited;
  btn3.Caption := btn_quit.Caption;
  btn1.Visible := g_MInfo^.R_edit;
  SetGrdCaption(DBGridEh1, 'MPST040');
  l_SalCDS := TClientDataSet.Create(Self);
  DS1.DataSet := l_SalCDS;
end;

procedure TFrmMPST040_ordlist.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SalCDS);
  DBGridEh1.Free;
end;

procedure TFrmMPST040_ordlist.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
  inherited;
  if GetQueryString('MPST040', tmpStr) then
    GetDS(tmpStr);
end;

procedure TFrmMPST040_ordlist.btn_exportClick(Sender: TObject);
begin
  inherited;
  GetExportXls(l_SalCDS, 'MPST040');
end;

procedure TFrmMPST040_ordlist.btn1Click(Sender: TObject);
var
  i: Integer;

  function XDeleteRecord: Boolean;
  var
    tmpSQL: string;
  begin
    tmpSQL := 'if exists(select 1 from mps300 where bu=' + Quotedstr(l_bu) + ' and orderno=' + Quotedstr(l_SalCDS.FieldByName('oea01').AsString) + ' and orderitem=' + l_SalCDS.FieldByName('oeb03').AsString + ' ) update mps300 set flag=1,muser=' + Quotedstr(g_UInfo^.UserId) + ' ,mdate=' + Quotedstr(FormatDateTime(g_cLongTimeSP, Now)) + ' where bu=' + Quotedstr(l_bu) + ' and orderno=' + Quotedstr(l_SalCDS.FieldByName('oea01').AsString) + ' and orderitem=' + l_SalCDS.FieldByName('oeb03').AsString +
      ' and isnull(flag,0)=0 else' + ' insert into mps300(bu,orderno,orderitem,flag,iuser,idate)' + ' values(' + Quotedstr(l_bu) + ',' + Quotedstr(l_SalCDS.FieldByName('oea01').AsString) + ',' + l_SalCDS.FieldByName('oeb03').AsString + ',1,' + Quotedstr(g_UInfo^.UserId) + ',' + Quotedstr(FormatDateTime(g_cLongTimeSP, Now)) + ')';
    Result := PostBySQL(tmpSQL);
  end;

begin
  inherited;
  if (not l_SalCDS.Active) or l_SalCDS.IsEmpty then
    Exit;

  if ShowMsg('確定結案所選的訂單嗎?', 33) = IdCancel then
    Exit;

  if DBGridEh1.SelectedRows.Count = 0 then
  begin
    if XDeleteRecord then
      l_SalCDS.Delete;
  end
  else
  begin
    btn_ok.Enabled := False;
    l_SalCDS.DisableControls;
    try
      for i := 0 to DBGridEh1.SelectedRows.Count - 1 do
      begin
        l_SalCDS.GotoBookmark(Pointer(DBGridEh1.SelectedRows[i]));
        if not XDeleteRecord then
          Break;
      end;
      if i <> 0 then
        DBGridEh1.SelectedRows.Delete;
    finally
      btn_ok.Enabled := True;
      l_SalCDS.EnableControls;
    end;
  end;

  if l_SalCDS.ChangeCount > 0 then
    l_SalCDS.MergeChangeLog;
end;

procedure TFrmMPST040_ordlist.btn2Click(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //當前、開始、結束
  qty1, qty2, qty3: Double;
  Data: OleVariant;
  tmpSQL: string;
  tmpStr: WideString;
  tmpCDS: TClientDataSet;
begin
  inherited;
  if (not l_SalCDS.Active) or l_SalCDS.IsEmpty then
  begin
    ShowMsg('無數據,不可操作!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['stkremark'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('請取消[庫存量]欄位排序標記,再執行此操作!', 48);
    Exit;
  end;

  tmpCRecNo := l_SalCDS.RecNo;
  case ShowMsg('更新全部請按[是]' + #13#10 + '更新當前這筆請按[否]' + #13#10 + '無操作請按[取消]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  l_SalCDS.DisableControls;
  if tmpCRecNo <> 0 then
    l_SalCDS.First;
  SetBtnEnabled(False);
  tmpCDS := TClientDataSet.Create(nil);
  try
    //取庫別
    if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
    begin
      tmpSQL := 'Select Depot,lst,fst From MPS330 Where Bu=' + Quotedstr(l_bu) + ' And (lst=1 or fst=1)';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          if Fields[1].AsBoolean then        //總庫存
            l_img02All := l_img02All + ',' + Quotedstr(Fields[0].AsString);
          if Fields[2].AsBoolean then        //有效庫存
            l_img02Out := l_img02Out + Fields[0].AsString + '/';
          Next;
        end;
      if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
      begin
        ShowMsg('MPS330無庫別,請確認!', 48);
        Exit;
      end;
      Delete(l_img02All, 1, 1);
      l_img02All := ' And img02 in (' + l_img02All + ')';
    end;
    //***

    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := l_SalCDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := Quotedstr(Copy(l_SalCDS.FieldByName('oeb04').AsString, 1, Length(l_SalCDS.FieldByName('oeb04').AsString) - 1))
      else
      begin
        while not l_SalCDS.Eof do
        begin
          if Pos(l_SalCDS.FieldByName('oeb04').AsString, tmpSQL) = 0 then
            tmpSQL := tmpSQL + ',' + Quotedstr(Copy(l_SalCDS.FieldByName('oeb04').AsString, 1, Length(l_SalCDS.FieldByName('oeb04').AsString) - 1));
          tmpERecNo := l_SalCDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //每次取50筆料號查詢庫存
            Break;
          l_SalCDS.Next;
        end;
        Delete(tmpSQL, 1, 1);
      end;

      pnlmsg.Caption := CheckLang('正在處理' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '筆');
      pnlmsg.Visible := True;
      Application.ProcessMessages;
      Data := null;
      if SameText(g_UInfo^.BU, 'ITEQDG') or SameText(g_UInfo^.BU, 'ITEQGZ') then
        tmpSQL := 'Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) as img01x' + ' From ITEQDG.img_file Where substr(img01,1,length(img01)-1) in (' + tmpSQL + ')' + l_img02All + ' And img10>0' + ' Union All' + ' Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) as img01x' + ' From ITEQGZ.img_file Where substr(img01,1,length(img01)-1) in (' + tmpSQL + ')' + l_img02All + ' And img10>0'
      else
        tmpSQL := 'Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) as img01x' + ' From ' + g_UInfo^.BU + '.img_file Where substr(img01,1,length(img01)-1) in (' + tmpSQL + ')' + l_img02All + ' And img10>0';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if l_SalCDS.ChangeCount > 0 then
          l_SalCDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      l_SalCDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((l_SalCDS.RecNo <= tmpERecNo) and (not l_SalCDS.Eof)) do
      begin
        qty1 := 0;
        qty2 := 0;
        qty3 := 0;
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'img01=' + Quotedstr(l_SalCDS.FieldByName('oeb04').AsString);
          Filtered := True;
          First;
          while not Eof do
          begin
            if (SameText(Fields[3].AsString, l_SalCDS.FieldByName('oea04').AsString) or SameText(Fields[3].AsString, l_SalCDS.FieldByName('occ02').AsString)) and (Pos(Fields[1].AsString, l_img02Out) > 0) then
              qty1 := qty1 + Fields[2].AsFloat;
            qty2 := qty2 + Fields[2].AsFloat;
            Next;
          end;
        end;
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'img01x=' + Quotedstr(Copy(l_SalCDS.FieldByName('oeb04').AsString, 1, Length(l_SalCDS.FieldByName('oeb04').AsString) - 1));
          Filtered := True;
          First;
          while not Eof do
          begin
            qty3 := qty3 + Fields[2].AsFloat;
            Next;
          end;
        end;
        l_SalCDS.Edit;
        l_SalCDS.FieldByName('stkremark').AsString := FloatToStr(qty1) + '/' + FloatToStr(qty2) + '/' + FloatToStr(qty3);
        l_SalCDS.Post;
        if tmpCRecNo = 0 then
          Break;
        l_SalCDS.Next;
      end;

      //退出while true
      if l_SalCDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;
    l_SalCDS.MergeChangeLog;

    ShowMsg('更新完筆!', 64);

  finally
    FreeAndNil(tmpCDS);
    if tmpCRecNo <> 0 then
      l_SalCDS.RecNo := tmpCRecNo;
    l_SalCDS.EnableControls;
    SetBtnEnabled(True);
    pnlmsg.Visible := False;
  end;
end;

procedure TFrmMPST040_ordlist.btn_quitClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmMPST040_ordlist.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Shift = [ssCtrl]) and (Key = 70) and l_SalCDS.Active then    //Ctrl+F 查找
  begin
    if not Assigned(FrmFind) then
      FrmFind := TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS := Self.l_SalCDS;
      g_Columns := Self.DBGridEh1.Columns;
      g_DefFname := Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname := 'oea02,oeb03,oeb05,oeb12,oeb15,oeb24,ta_oeb01,ta_oeb02,qty,adate,cdate,stkremark';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh自帶的查找
  end;
end;

end.

