{*******************************************************}
{                                                       }
{                unStock                                }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: 庫存與未交訂單明細        }
{                  unMPST030、unMPST040、unMPSR090共用  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unStock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, Buttons,
  ExtCtrls, DBClient, StrUtils, ComCtrls, DateUtils, Menus;

type
  TFrmStock = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    lblpno: TLabel;
    Edit3: TEdit;
    DS1: TDataSource;
    CheckBoxE: TCheckBox;
    CheckBoxT: TCheckBox;
    CheckBoxB: TCheckBox;
    CheckBoxR: TCheckBox;
    CheckBoxP: TCheckBox;
    CheckBoxQ: TCheckBox;
    CheckBoxM: TCheckBox;
    CheckBoxN: TCheckBox;
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    btn_query: TBitBtn;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    DBGridEh3: TDBGridEh;
    DS3: TDataSource;
    Splitter1: TSplitter;
    CheckBox1: TCheckBox;
    DBGridEh4: TDBGridEh;
    DS4: TDataSource;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    BitBtn2: TBitBtn;
    Timer1: TTimer;
    Timer2: TTimer;
    DBGridEh5: TDBGridEh;
    DS5: TDataSource;
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh2TitleClick(Column: TColumnEh);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure DBGridEh2DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
  private
    l_isDG, l_Ans, l_edit: Boolean;
    l_StrIndex1, l_StrIndex2, l_StrIndexDesc1, l_StrIndexDesc2: string;
    l_StkCDS, l_SalCDS, l_MpsCDS, l_CDS650, l_occ_file: TClientDataSet;
    l_sql2, l_sql3: string;
    l_list2, l_list3: TStrings;
    l_MPS012_Stock_CDS: TClientDataSet;
    procedure l_SalCDSAfterScroll(DataSet: TDataSet);
    procedure full_MPS012_Stock;
    { Private declarations }
  public
    l_isMPS: Boolean;
    l_sourceProcid: string;
    { Public declarations }
  end;

var
  FrmStock: TFrmStock;


implementation

uses
  unGlobal, unCommon, unStock_booking1, unStock_booking2;

const
  l_Code3 = 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z';

{$R *.dfm}

procedure TFrmStock.l_SalCDSAfterScroll(DataSet: TDataSet);
var
  tmpSQL: string;
begin
  if DataSet.IsEmpty then
  begin
    tmpSQL := 'select null sdate,null stype,null materialno,null materialno1,' + ' null adate,null sqty from sys_bu where 1=2';
    l_list2.Insert(0, tmpSQL);

    tmpSQL := 'select null srcid,null pno,null purqty,null qty,null date4,null date6,' + ' null adate,null adate_new from sys_bu where 1=2';
    l_list3.Insert(0, tmpSQL);
    Exit;
  end;

  if l_isDG then
  begin
    if DataSet.FieldByName('dbtype').AsString = 'DG' then
      tmpSQL := ' and srcflag in (1,3,5)'
    else
      tmpSQL := ' and srcflag in (2,4,6)';

    if Pos(LeftStr(DataSet.FieldByName('oeb04').AsString, 1), 'ET') > 0 then
      tmpSQL := 'select sdate,null stype,materialno,materialno1,adate_new as adate,sqty from mps010' + ' where bu=''ITEQDG''' + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0 ' + tmpSQL + ' union all' + ' select sdate,stype,materialno,materialno1,adate,sqty from mps012' + ' where bu=''ITEQDG''' + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(isempty,0)=0 and isnull(notvisible,0)=0 ' + tmpSQL + ' order by sdate,stype'
    else
      tmpSQL := 'select sdate,null as stype,materialno,materialno1,adate_new as adate,sqty from mps070' + ' where bu=''ITEQDG''' + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0 ' + tmpSQL + ' order by sdate';
    l_list2.Insert(0, tmpSQL);
                                                                                                                                                                                                                             //bu=''iteqdg'' and
    tmpSQL := 'select case left(srcid,2) when ''wx'' then ''外購無錫'' when ''tw'' then ''外購臺灣'' when ''jx'' then ''外購江西'' else ''未知'' end srcid,' + ' pno,purqty,qty,date4,date6,adate,adate_new from mps650 where  isnull(isfinish,0)=0';
    if Pos(LeftStr(DataSet.FieldByName('oea01').AsString, 3), l_Code3) > 0 then  //單別已經決定了廠別,兩廠不會有相同單號,不用oradb條件
      tmpSQL := tmpSQL + ' and orderno2=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem2=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger)
    else
      tmpSQL := tmpSQL + ' and oradb=' + Quotedstr('ITEQ' + DataSet.FieldByName('dbtype').AsString) + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger);
    tmpSQL := tmpSQL + ' order by cdate,cno,sno';
    l_list3.Insert(0, tmpSQL);
  end
  else
  begin
    if Pos(LeftStr(DataSet.FieldByName('oeb04').AsString, 1), 'ET') > 0 then
      tmpSQL := 'select sdate,null stype,materialno,materialno1,adate_new as adate,sqty from mps010' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0' + ' union all' + ' select sdate,stype,materialno,materialno1,adate,sqty from mps012' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(isempty,0)=0 and isnull(notvisible,0)=0' + ' order by sdate,stype'
    else
      tmpSQL := 'select sdate,null as stype,materialno,materialno1,adate_new as adate,sqty from mps070' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and orderno=' + Quotedstr(DataSet.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(DataSet.FieldByName('oeb03').AsInteger) + ' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0' + ' order by sdate';
    l_list2.Insert(0, tmpSQL);

    tmpSQL := 'select null srcid,null pno,null purqty,null qty,null date4,null date6,' + ' null adate,null adate_new from sys_bu where 1=2';

    l_list3.Insert(0, tmpSQL);
  end;

end;

procedure TFrmStock.FormCreate(Sender: TObject);
var
  tmpGrdEh: TGrdEh;
  tmpSQL: string;
  Data: OleVariant;
begin
  inherited;

  SetLength(tmpGrdEh.grdEh, 4);
  SetLength(tmpGrdEh.tb, 4);
  tmpGrdEh.grdEh[0] := DBGridEh1;
  tmpGrdEh.grdEh[1] := DBGridEh2;
  tmpGrdEh.grdEh[2] := DBGridEh3;
  tmpGrdEh.grdEh[3] := DBGridEh4;
  tmpGrdEh.tb[0] := 'MPST040';
  tmpGrdEh.tb[1] := 'MPST040';
  tmpGrdEh.tb[2] := 'Stock_3';
  tmpGrdEh.tb[3] := 'MPS650';
  SetMoreGrdCaption(tmpGrdEh);
  tmpGrdEh.grdEh := nil;
  tmpGrdEh.tb := nil;

  BitBtn1.Caption := btn_quit.Caption;
  BitBtn2.Caption := CheckLang('特采倉');
  PnlRight.Visible := False;
  CheckBoxE.Caption := 'E';
  CheckBoxT.Caption := 'T';
  CheckBoxB.Caption := 'B';
  CheckBoxR.Caption := 'R';
  CheckBoxP.Caption := 'P';
  CheckBoxQ.Caption := 'Q';
  CheckBoxM.Caption := 'M';
  CheckBoxN.Caption := 'N';
  CheckBox1.Caption := '1';

  //Booking權限
  l_edit := False;
  tmpSQL := 'select top 1 a.bu from sys_user a inner join sys_userright b' + ' on a.bu=b.bu and a.userid=b.userid' + ' where a.bu=' + Quotedstr(g_UInfo^.BU) + ' and a.userid=' + Quotedstr(g_UInfo^.UserId) + ' and b.procid=''mpst040'' and isnull(a.not_use,0)=0' + ' and b.r_visible=1 and b.r_edit=1';
  if QueryOneCR(tmpSQL, Data) then
    if not VarIsNull(Data) then
      l_edit := Length(VarToStr(Data)) > 0;

  if l_edit then
    StatusBar1.Panels[1].Text := CheckLang('【右鍵】訂單資料：Booking操作; 【雙擊】庫存資料或訂單資料：查看當筆資料的booking明細');

  l_list2 := TStringList.Create;
  l_list3 := TStringList.Create;
  Timer1.Enabled := True;
  Timer2.Enabled := True;

  // longxinjue 2022.01.10
  SetGrdCaption(DBGridEh5, 'MPS012_Stock');
end;

procedure TFrmStock.FormShow(Sender: TObject);
var
  str: string;
begin
  inherited;
  l_isDG := SameText(g_UInfo^.BU, 'ITEQDG') or SameText(g_UInfo^.BU, 'ITEQGZ');
  str := LeftStr(Edit3.Text, 1);
  if Self.FindComponent('CheckBox' + str) <> nil then
    (Self.FindComponent('CheckBox' + str) as TCheckBox).Checked := True;
  l_StkCDS := TClientDataSet.Create(Self);
  l_SalCDS := TClientDataSet.Create(Self);
  l_MpsCDS := TClientDataSet.Create(Self);
  l_CDS650 := TClientDataSet.Create(Self);
  l_occ_file := TClientDataSet.Create(Self);
  l_SalCDS.IndexFieldNames := 'dbtype;oea01;oeb03';
  DS1.DataSet := l_StkCDS;
  DS2.DataSet := l_SalCDS;
  DS3.DataSet := l_MpsCDS;
  DS4.DataSet := l_CDS650;

  // longxinjue 2022.01.10
  l_MPS012_Stock_CDS := TClientDataSet.Create(Self);
  DS5.DataSet := l_MPS012_Stock_CDS;
end;

procedure TFrmStock.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
  l_Ans := True;

  inherited;

  l_StkCDS.Active := False;
  l_SalCDS.Active := False;
  l_MpsCDS.Active := False;
  l_CDS650.Active := False;
  for i := Low(g_ConnData) to High(g_ConnData) do
  begin
    g_ConnData[i].ADOConn.Connected := False;
    FreeAndNil(g_ConnData[i].ADOConn);
  end;
  SetLength(g_ConnData, 0);

  for i := Low(g_DAL) to High(g_DAL) do
    FreeAndNil(g_DAL[i]);
  SetLength(g_DAL, 0);

  FreeAndNil(l_StkCDS);
  FreeAndNil(l_SalCDS);
  FreeAndNil(l_MpsCDS);
  FreeAndNil(l_CDS650);
  FreeAndNil(l_occ_file);
  FreeAndNil(l_list2);
  FreeAndNil(l_list3);
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;

  // longxinjue 2022.01.10
  FreeAndNil(l_MPS012_Stock_CDS);
  DBGridEh5.Free;
end;

procedure TFrmStock.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(l_StkCDS, Column, l_StrIndex1, l_StrIndexDesc1);
end;

procedure TFrmStock.DBGridEh2TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(l_SalCDS, Column, l_StrIndex2, l_StrIndexDesc2);
end;

procedure TFrmStock.FormResize(Sender: TObject);
var
  halfWidth: Integer;
begin
  inherited;
  if l_Ans then
    Exit;
  halfWidth := Trunc(Self.ClientWidth / 2);
  DBGridEh1.Width := halfWidth;
end;

procedure TFrmStock.btn_queryClick(Sender: TObject);
const
  fstCode = 'ETBRPQMN1';
var
  i: Integer;
  tmpQty: Double;
  Data: OleVariant;
  tmpStr: WideString;
  tmpSQL, tmpPno, tmpOrderno, tmpImgFilter, tmpOebFilter, tmpPPFilter, tmpCCLFilter, tmpTqtyFilter1, tmpTqtyFilter2, tmpImg02: string;
  tmpCDS, tmpCDSX: TClientDataSet;
  tmpList: TStrings;
begin
  tmpStr := Trim(Edit3.Text);
  if Length(tmpStr) < 6 then
  begin
    ShowMsg('請輸入物品料號,最小長度6碼!', 48);
    Edit3.SetFocus;
    Exit;
  end;

  Delete(tmpStr, 1, 1);
  for i := 1 to Length(fstCode) do
  begin
    if (Self.FindComponent('CheckBox' + fstCode[i]) <> nil) and (Self.FindComponent('CheckBox' + fstCode[i]) as TCheckBox).Checked then
    begin
      tmpImgFilter := tmpImgFilter + ' or img01 Like ' + Quotedstr(fstCode[i] + tmpStr + '%');
      tmpOebFilter := tmpOebFilter + ' or oeb04 Like ' + Quotedstr(fstCode[i] + tmpStr + '%');
    end;
  end;

  if Length(tmpImgFilter) = 0 then
  begin
    ShowMsg('請選擇E/T/B/R/P/Q/M/N/1,一個或多個!', 48);
    Edit3.SetFocus;
    Exit;
  end;

  if CheckBox1.Checked then
    if CheckBoxE.Checked or CheckBoxT.Checked or CheckBoxB.Checked or CheckBoxR.Checked or CheckBoxP.Checked or CheckBoxQ.Checked or CheckBoxM.Checked or CheckBoxN.Checked then
    begin
      ShowMsg('E/T/B/R/P/Q/M/N與1不能同時選中!', 48);
      Edit3.SetFocus;
      Exit;
    end;

  tmpCDS := TClientDataSet.Create(nil);
  tmpCDSX := TClientDataSet.Create(nil);
  l_SalCDS.AfterScroll := nil;
  l_SalCDS.DisableControls;
  StatusBar1.Panels[0].Text := CheckLang('正在查詢庫存狀況...');
  btn_ok.Enabled := False;
  Application.ProcessMessages;
  try
    if TBitBtn(Sender).Tag = 0 then
    begin
      //取庫別
      tmpImg02 := '';
      tmpSQL := 'exec proc_GetDepot %s,%s,%s';  
      {(*}
      tmpSQL := Format(tmpSQL,[QuotedStr(g_uinfo^.BU),
                               QuotedStr(l_sourceProcid),
                               QuotedStr(IfThen(CheckBox1.Checked,QuotedStr('qst'),QuotedStr('sst')))]);   {*)}
      if CheckBox1.Checked then
        tmpSQL := ' and qst=1'
      else
        tmpSQL := ' and sst=1';
      if Pos(l_sourceProcid,'MPST012,MPST010,MPST070')>0 then
        tmpSQL := 'Select Depot From MPS210 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' union all ' + 'Select Depot From MPS530 Where Bu=' + Quotedstr(g_UInfo^.BU)
      else
        tmpSQL := 'Select Depot From MPS330 Where Bu=' + Quotedstr(g_UInfo^.BU) + tmpSQL;

      if not QueryBySQL(tmpSQL, Data) then
        Exit;

      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          tmpImg02 := tmpImg02 + ',' + Quotedstr(Fields[0].AsString);
          Next;
        end;
      if Length(tmpImg02) = 0 then
      begin
        ShowMsg('MPS330無庫別,請確認!', 48);
        Edit3.SetFocus;
        Exit;
      end;
      Delete(tmpImg02, 1, 1);
      tmpImg02 := ' And img02 in (' + tmpImg02 + ')';
      //***
    end
    else
      tmpImg02 := ' And img02 in (''Y2CF0'',''N2CF0'')';

    Data := null;
    if l_isDG then
      tmpSQL := 'Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,' + ' ''DG'' dbtype,img04 as cjremark,img10 as bookingqty' + ' From ITEQDG.img_file Where (img01=''@''' + tmpImgFilter + ')' + tmpImg02 + ' And img10>0' + ' Union All' + ' Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,' + ' ''GZ'' as dbtype,img04 as cjremark,img10 as bookingqty' + ' From ITEQGZ.img_file Where (img01=''@''' + tmpImgFilter + ')' + tmpImg02 + ' And img10>0' + ' Order By img01,img02,img03,img04'
    else
      tmpSQL := 'Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,' + Quotedstr(RightStr(g_UInfo^.BU, 2)) + ' dbtype,img04 as cjremark,img10 as bookingqty' + ' From ' + g_UInfo^.BU + '.img_file Where (img01=''@''' + tmpImgFilter + ')' + tmpImg02 + ' And img10>0' + ' Order By img01,img02,img03,img04';
    if QueryBySQL(tmpSQL, Data, 'ORACLE') then
    begin
      RefreshGrdCaption(l_StkCDS, DBGridEh1, l_StrIndex1, l_StrIndexDesc1);
      tmpCDS.Data := Data;

      tmpSQL := '';
      tmpPno := '';
      with tmpCDS do
        while not Eof do
        begin
          tmpPno := tmpPno + ',' + Quotedstr(FieldByName('img01').AsString);
          tmpSQL := tmpSQL + ' or (pno=' + Quotedstr(FieldByName('img01').AsString) + ' and lot=' + Quotedstr(FieldByName('img04').AsString) + ')';

          Edit;
          FieldByName('cjremark').Clear;
          FieldByName('bookingqty').Clear;
          Post;
          Next;
        end;


      //查詢裁檢備注
      if Length(tmpSQL) > 0 then
      begin
        Delete(tmpSQL, 1, 4);
        Data := null;
        tmpSQL := 'select pno,lot,remark from mps400' + ' where bu=' + Quotedstr(g_UInfo^.BU) + ' and (' + tmpSQL + ')';
        if not QueryBySQL(tmpSQL, Data) then
          Exit;
        tmpCDSX.Data := Data;

        if not tmpCDSX.IsEmpty then
          with tmpCDS do
          begin
            First;
            while not Eof do
            begin
              if tmpCDSX.Locate('pno;lot', VarArrayOf([FieldByName('img01').AsString, FieldByName('img04').AsString]), []) then
              begin
                Edit;
                FieldByName('cjremark').AsString := tmpCDSX.FieldByName('remark').AsString;
                Post;
              end;
              Next;
            end;
          end;
      end;


      //查詢Booking數量
      if Length(tmpPno) > 0 then
      begin
        Delete(tmpPno, 1, 1);
        Data := null;
        tmpSQL := 'select * from dli603 where 1=1 and pno in (' + tmpPno + ')';
        if not QueryBySQL(tmpSQL, Data) then
          Exit;
        tmpCDSX.Data := Data;

        if not tmpCDSX.IsEmpty then
          with tmpCDS do
          begin
            First;
            while not Eof do
            begin
              tmpCDSX.Filtered := False;
              tmpCDSX.Filter := 'bu=' + Quotedstr(tmpCDS.FieldByName('dbtype').AsString) + ' and pno=' + Quotedstr(tmpCDS.FieldByName('img01').AsString) + ' and place=' + Quotedstr(tmpCDS.FieldByName('img02').AsString) + ' and area=' + Quotedstr(tmpCDS.FieldByName('img03').AsString) + ' and lot=' + Quotedstr(tmpCDS.FieldByName('img04').AsString);
              tmpCDSX.Filtered := True;
              if not tmpCDSX.IsEmpty then
              begin
                tmpQty := 0;
                while not tmpCDSX.Eof do
                begin
                  tmpQty := tmpQty + tmpCDSX.FieldByName('qty').AsFloat;
                  tmpCDSX.Next;
                end;

                if tmpQty <> 0 then
                begin
                  Edit;
                  FieldByName('bookingqty').AsFloat := tmpQty;
                  Post;
                end;
              end;
              Next;
            end;
          end;
      end;

      if tmpCDS.ChangeCount > 0 then
        tmpCDS.MergeChangeLog;
      l_StkCDS.Data := tmpCDS.Data;

      if CheckBox1.Checked then
        if (not CheckBoxE.Checked) and (not CheckBoxT.Checked) and (not CheckBoxB.Checked) and (not CheckBoxR.Checked) and (not CheckBoxP.Checked) and (not CheckBoxQ.Checked) and (not CheckBoxM.Checked) and (not CheckBoxN.Checked) then
        begin
          if l_SalCDS.Active then
            l_SalCDS.EmptyDataSet;
          if l_MpsCDS.Active then
            l_MpsCDS.EmptyDataSet;
          if l_CDS650.Active then
            l_CDS650.EmptyDataSet;
          Exit;
        end;

      StatusBar1.Panels[0].Text := CheckLang('正在查詢訂單與庫存的關聯狀況...');
      full_MPS012_Stock();

      StatusBar1.Panels[0].Text := CheckLang('正在查詢未交狀況...');
      Application.ProcessMessages;
      Data := null;                           
      tmpSQL := '';
      if l_isDG then
      begin
        if l_isMPS or (pos('MPS',l_sourceProcid)>0) then
          tmpSQL := ' And oea04 not in (''N012'',''N005'') And Substr(oea01,1,3) not in (''228'',''22B'',''22A'',''226'')'
        else
          tmpSQL := ' And Substr(oea01,1,3) not in (''22A'',''226'')';
      end;
      if l_isDG then
        tmpSQL := ' Select Z.* from (Select X.*,occ02,substr(X.oeb04,1,length(X.oeb04)-1) as pno,''DG'' dbtype From (' + ' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,' + ' ta_oeb02,ta_oeb10 adate,ta_oeb10 cdate,oeb12 sqty,oeb12 tqty,oeb12 bookingqty' + ' From ITEQDG.oea_file Inner Join ITEQDG.oeb_file on oea01=oeb01' + ' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')=''N''' + tmpSQL + ' and (oeb04=''@''' + tmpOebFilter + ')) X' + ' Inner Join ITEQDG.occ_file on oea04=occ01' +
          ' Union All' + ' Select Y.*,occ02,substr(Y.oeb04,1,length(Y.oeb04)-1) as pno,''GZ'' dbtype From (' + ' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,' + ' ta_oeb02,ta_oeb10 adate,ta_oeb10 cdate,oeb12 sqty,oeb12 tqty,oeb12 bookingqty' + ' From ITEQGZ.oea_file Inner Join ITEQGZ.oeb_file on oea01=oeb01' + ' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')=''N''' + tmpSQL + ' and (oeb04=''@''' + tmpOebFilter + ')) Y' + ' Inner Join ITEQGZ.occ_file on oea04=occ01) Z' + ' Order By dbtype,oeb04,oea04,oea01,oeb03'
      else
        tmpSQL := ' Select Z.* from (Select X.*,occ02,substr(X.oeb04,1,length(X.oeb04)-1) as pno,' + Quotedstr(RightStr(g_UInfo^.BU, 2)) + ' dbtype From (' + ' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,' + ' ta_oeb02,ta_oeb10 adate,ta_oeb10 cdate,oeb12 sqty,oeb12 tqty,oeb12 bookingqty' + ' From ' + g_UInfo^.BU + '.oea_file Inner Join ' + g_UInfo^.BU + '.oeb_file on oea01=oeb01' + ' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')=''N''' + tmpSQL + ' and (oeb04=''@''' + tmpOebFilter + ')) X' + ' Inner Join ' + g_UInfo^.BU + '.occ_file on oea04=occ01) Z' + ' Order By dbtype,oeb04,oea04,oea01,oeb03';
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        RefreshGrdCaption(l_SalCDS, DBGridEh2, l_StrIndex2, l_StrIndexDesc2);
        l_SalCDS.Data := Data;


        //***排除本地已結案的
        StatusBar1.Panels[0].Text := CheckLang('正在處理訂單結案狀況...');
        Application.ProcessMessages;
        tmpOrderno := '';
        with l_SalCDS do
        begin
          First;
          while not Eof do
          begin
            Edit;
            FieldByName('adate').AsString := '';
            FieldByName('cdate').AsString := '';
            FieldByName('sqty').Clear;
            FieldByName('tqty').Clear;
            FieldByName('bookingqty').Clear;
            Post;
            tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('oea01').AsString);
            Next;
          end;
        end;

        if Length(tmpOrderno) > 0 then
        begin
          Delete(tmpOrderno, 1, 1);
          Data := null;
          tmpSQL := 'Select Right(Bu,2) Bu,Orderno,Orderitem From MPS300' + ' Where Flag=1 And Orderno in (' + tmpOrderno + ')';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data := Data;

            l_SalCDS.First;
            with tmpCDS do
              while not Eof do
              begin
                while l_SalCDS.Locate('dbtype;oea01;oeb03', VarArrayOf([Fields[0].AsString, Fields[1].AsString, Fields[2].AsInteger]), []) do
                  l_SalCDS.Delete;
                Next;
              end;
          end;

          StatusBar1.Panels[0].Text := CheckLang('正在處理booking資料...');
          Application.ProcessMessages;
          Data := null;
          tmpSQL := 'select ordbu,orderno,orderitem,sum(qty) qty from dli603' + ' where orderno in (' + tmpOrderno + ')' + ' group by ordbu,orderno,orderitem';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data := Data;

            if not tmpCDS.IsEmpty then
              with l_SalCDS do
              begin
                First;
                while not Eof do
                begin
                  if tmpCDS.Locate('ordbu;orderno;orderitem', VarArrayOf([FieldByName('dbtype').AsString, FieldByName('oea01').AsString, FieldByName('oeb03').AsInteger]), []) then
                    if tmpCDS.FieldByName('qty').AsFloat <> 0 then
                    begin
                      Edit;
                      FieldByName('bookingqty').AsFloat := tmpCDS.FieldByName('qty').AsFloat;
                      Post;
                    end;
                  Next;
                end;
              end;
          end;
        end;
        //***
        //***達交日期
        StatusBar1.Panels[0].Text := CheckLang('正在處理達交日期...');
        Application.ProcessMessages;
        tmpSQL := '';
        tmpPPFilter := '';
        tmpCCLFilter := '';
        tmpTqtyFilter1 := '';
        tmpTqtyFilter2 := '';
        with l_SalCDS do
        begin
          First;
          while not Eof do
          begin
            tmpSQL := tmpSQL + ',' + Quotedstr(FieldByName('oea01').AsString + '@' + FieldByName('oeb03').AsString);
            if Pos(LeftStr(FieldByName('oeb04').AsString, 1), 'ET') > 0 then
              tmpCCLFilter := tmpCCLFilter + ',' + Quotedstr(FieldByName('oea01').AsString + '@' + FieldByName('oeb03').AsString + '@' + FieldByName('pno').AsString)
            else
              tmpPPFilter := tmpPPFilter + ',' + Quotedstr(FieldByName('oea01').AsString + '@' + FieldByName('oeb03').AsString + '@' + FieldByName('pno').AsString);

            if Pos(LeftStr(FieldByName('oea01').AsString, 3), l_Code3) > 0 then
              tmpTqtyFilter1 := tmpTqtyFilter1 + ',' + Quotedstr(FieldByName('oea01').AsString + '@' + FieldByName('oeb03').AsString + '@' + FieldByName('pno').AsString)
            else
              tmpTqtyFilter2 := tmpTqtyFilter2 + ',' + Quotedstr('ITEQ' + FieldByName('dbtype').AsString + '@' + FieldByName('oea01').AsString + '@' + FieldByName('oeb03').AsString + '@' + FieldByName('pno').AsString);
            Next;
          end;
        end;
        if Length(tmpSQL) > 0 then
        begin
          Delete(tmpSQL, 1, 1);
          Data := null;
          tmpSQL := 'Select Right(Bu,2) Bu,Orderno,Orderitem,Adate,Cdate From MPS200' + ' Where Orderno+''@''+Cast(Orderitem as varchar(10)) in (' + tmpSQL + ')';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data := Data;
            with tmpCDS do
              while not Eof do
              begin
                if l_SalCDS.Locate('dbtype;oea01;oeb03', VarArrayOf([Fields[0].AsString, Fields[1].AsString, Fields[2].AsInteger]), []) then
                begin
                  tmpSQL := Fields[3].AsString;

                  if (Length(tmpSQL) > 0) and (Pos(' ' + tmpSQL + ' ', ' ' + l_SalCDS.FieldByName('adate').AsString + ' ') = 0) then
                  begin
                    tmpSQL := l_SalCDS.FieldByName('adate').AsString + ' ' + tmpSQL;
                    l_SalCDS.Edit;
                    l_SalCDS.FieldByName('adate').AsString := Trim(tmpSQL);
                    l_SalCDS.Post;
                  end;

                  tmpSQL := Fields[4].AsString;

                  if (Length(tmpSQL) > 0) and (Pos(' ' + tmpSQL + ' ', ' ' + l_SalCDS.FieldByName('cdate').AsString + ' ') = 0) then
                  begin
                    tmpSQL := l_SalCDS.FieldByName('cdate').AsString + ' ' + tmpSQL;
                    l_SalCDS.Edit;
                    l_SalCDS.FieldByName('cdate').AsString := Trim(tmpSQL);
                    l_SalCDS.Post;
                  end;
                end;
                Next;
              end;
          end;
        end;
        //***
        //排製數量
        StatusBar1.Panels[0].Text := CheckLang('正在處理排製數量...');
        Application.ProcessMessages;
        if Length(tmpCCLFilter) > 0 then  //ccl
        begin
          Delete(tmpCCLFilter, 1, 1);
          Data := null;
          if l_isDG then
            tmpSQL := 'Select dbtype,Orderno,OrderItem,Pno,SUM(Sqty) Sqty From(' + ' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,' +
            ' Orderno,OrderItem,Substring(Materialno,1,Len(Materialno)-1) Pno,Sqty' +
            ' From MPS010 Where Bu=''ITEQDG'' and len(Materialno)>1 And Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0' +
            ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,Len(Materialno)-1) in (' + tmpCCLFilter + ')' +
              ' Union All' + ' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,' +
              ' Orderno,OrderItem,Substring(Materialno,1,Len(Materialno)-1) Pno,Sqty' + ' From MPS012 Where Bu=''ITEQDG'' And len(Materialno)>1 and Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(IsEmpty,0)=0 And Sqty>0' + ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,Len(Materialno)-1) in (' + tmpCCLFilter + ')) X' + ' Group By Orderno,OrderItem,Pno,dbtype'
          else
            tmpSQL := 'Select dbtype,Orderno,OrderItem,Pno,SUM(Sqty) Sqty From(' + ' Select ' + Quotedstr(RightStr(g_UInfo^.BU, 2)) + ' dbtype,' + ' Orderno,OrderItem,Substring(Materialno,1,Len(Materialno)-1) Pno,Sqty' + ' From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' and len(Materialno)>1 And Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0' + ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,Len(Materialno)-1) in (' + tmpCCLFilter + ')'
              + ' Union All' + ' Select ' + Quotedstr(RightStr(g_UInfo^.BU, 2)) + ' dbtype,' + ' Orderno,OrderItem,Substring(Materialno,1,Len(Materialno)-1) Pno,Sqty' + ' From MPS012 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' and len(Materialno)>1 And Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(IsEmpty,0)=0 And Sqty>0' + ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,Len(Materialno)-1) in (' + tmpCCLFilter + ')) X' + ' Group By Orderno,OrderItem,Pno,dbtype';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data := Data;
            with tmpCDS do
              while not Eof do
              begin
                if l_SalCDS.Locate('dbtype;oea01;oeb03;pno', VarArrayOf([Fields[0].AsString, Fields[1].AsString, Fields[2].AsInteger, Fields[3].AsString]), []) then
                begin
                  l_SalCDS.Edit;
                  l_SalCDS.FieldByName('Sqty').AsFloat := Fields[4].AsFloat;
                  l_SalCDS.Post;
                end;
                Next;
              end;
          end;
        end;

        if Length(tmpPPFilter) > 0 then  //pp
        begin
          Delete(tmpPPFilter, 1, 1);
          Data := null;
          if l_isDG then
            tmpSQL := 'Select dbtype,Orderno,OrderItem,Pno,SUM(Sqty) Sqty From(' + ' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,' + ' Orderno,OrderItem,Substring(Materialno,1,len(Materialno)-1) Pno,Sqty' + ' From MPS070 Where Bu=''ITEQDG'' and len(Materialno)>1 And Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0' + ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,len(Materialno)-1) in (' + tmpPPFilter + ')) X' + ' Group By Orderno,OrderItem,Pno,dbtype'
          else
            tmpSQL := 'Select dbtype,Orderno,OrderItem,Pno,SUM(Sqty) Sqty From(' + ' Select ' + Quotedstr(RightStr(g_UInfo^.BU, 2)) + ' dbtype,' + ' Orderno,OrderItem,Substring(Materialno,1,len(Materialno)-1) Pno,Sqty' + ' From MPS070 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' and len(Materialno)>1 And Sdate>=' + Quotedstr(DateToStr(Date)) + ' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0' + ' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Materialno,1,len(Materialno)-1) in (' + tmpPPFilter + ')) X' + ' Group By Orderno,OrderItem,Pno,dbtype';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data := Data;
            with tmpCDS do
              while not Eof do
              begin
                if l_SalCDS.Locate('dbtype;oea01;oeb03;pno', VarArrayOf([Fields[0].AsString, Fields[1].AsString, Fields[2].AsInteger, Fields[3].AsString]), []) then
                begin
                  l_SalCDS.Edit;
                  l_SalCDS.FieldByName('Sqty').AsFloat := Fields[4].AsFloat;
                  l_SalCDS.Post;
                end;
                Next;
              end;
          end;
        end;
        //***
        //外發數量
        if l_isDG then
        begin
          StatusBar1.Panels[0].Text := CheckLang('正在處理外發數量...');
          Application.ProcessMessages;
          if Length(tmpTqtyFilter1) > 0 then  //兩角訂單
          begin
            Delete(tmpTqtyFilter1, 1, 1);
            Data := null;                                                                                                                                                   //Bu=''ITEQDG'' And
            tmpSQL := 'Select Orderno2,OrderItem2,Pno,SUM(PurQty) PurQty From(' + ' Select Orderno2,OrderItem2,Substring(Pno,1,Len(Pno)-1) Pno,PurQty' + ' From MPS650 Where  isnull(isfinish,0)=0 And PurQty>0' + ' And Orderno2+''@''+Cast(OrderItem2 as varchar(10))+''@''+Substring(Pno,1,Len(Pno)-1) in (' + tmpTqtyFilter1 + ')) X' + ' Group By Orderno2,OrderItem2,Pno';
            if QueryBySQL(tmpSQL, Data) then
            begin
              tmpCDS.Data := Data;
              with tmpCDS do
                while not Eof do
                begin
                  if l_SalCDS.Locate('oea01;oeb03;pno', VarArrayOf([Fields[0].AsString, Fields[1].AsInteger, Fields[2].AsString]), []) then
                  begin
                    l_SalCDS.Edit;
                    l_SalCDS.FieldByName('Tqty').AsFloat := Fields[3].AsFloat;
                    l_SalCDS.Post;
                  end;
                  Next;
                end;
            end;
          end;

          if Length(tmpTqtyFilter2) > 0 then
          begin
            Delete(tmpTqtyFilter2, 1, 1);
            Data := null;                                                                                                                                                           //Bu=''ITEQDG'' And
            tmpSQL := 'Select OraDB,Orderno,OrderItem,Pno,SUM(PurQty) PurQty From(' + ' Select OraDB,Orderno,OrderItem,Substring(Pno,1,Len(Pno)-1) Pno,PurQty' + ' From MPS650 Where  isnull(isfinish,0)=0 And PurQty>0' + ' And OraDB+''@''+Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Substring(Pno,1,Len(Pno)-1) in (' + tmpTqtyFilter2 + ')) X' + ' Group By OraDB,Orderno,OrderItem,Pno';
            if QueryBySQL(tmpSQL, Data) then
            begin
              tmpCDS.Data := Data;
              with tmpCDS do
                while not Eof do
                begin
                  if l_SalCDS.Locate('dbtype;oea01;oeb03;pno', VarArrayOf([RightStr(Fields[0].AsString, 2), Fields[1].AsString, Fields[2].AsInteger, Fields[3].AsString]), []) then
                  begin
                    l_SalCDS.Edit;
                    l_SalCDS.FieldByName('Tqty').AsFloat := Fields[4].AsFloat;
                    l_SalCDS.Post;
                  end;
                  Next;
                end;
            end;
          end;
        end;
        //***
        //ITEQJX實際客戶
        if (not l_SalCDS.IsEmpty) and SameText(g_UInfo^.BU, 'ITEQJX') then
        begin
          StatusBar1.Panels[0].Text := CheckLang('正在處理客戶簡稱...');
          Application.ProcessMessages;
          tmpSQL := '';
          with l_SalCDS do
          begin
            First;
            while not Eof do
            begin
              if Pos('聯茂', FieldByName('occ02').AsString) > 0 then
                tmpSQL := tmpSQL + ' or (oao01=' + Quotedstr(FieldByName('oea01').AsString) + ' and oao03=' + IntToStr(FieldByName('oeb03').AsInteger) + ')';
              Next;
            end;
          end;

          if Length(tmpSQL) > 0 then
          begin
            Delete(tmpSQL, 1, 3);
            Data := null;
            tmpSQL := 'select oao01,oao03,oao06 from ' + g_UInfo^.BU + '.oao_file where ' + tmpSQL;
            if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
              Exit;

            tmpCDS.Data := Data;
            if not tmpCDS.IsEmpty then
            begin
              if not l_occ_file.Active then
              begin
                Data := null;
                tmpSQL := 'select occ01,occ02 from ' + g_UInfo^.BU + '.occ_file';
                if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
                  Exit;
                l_occ_file.Data := Data;
              end;

              tmpList := TStringList.Create;
              try
                //oao06格式:廠別-單別-單號-項次-客戶編號-其它文字(xx-xxx-xxxxxx-xx-xxxxx-x)
                tmpList.Delimiter := '-';
                with l_SalCDS do
                begin
                  First;
                  while not Eof do
                  begin
                    if tmpCDS.Locate('oao01;oao03', VarArrayOf([FieldByName('oea01').AsString, FieldByName('oeb03').AsInteger]), []) then
                    begin
                      tmpList.DelimitedText := tmpCDS.FieldByName('oao06').AsString;
                      if tmpList.Count >= 5 then
                        if l_occ_file.Locate('occ01', tmpList.Strings[4], []) then
                        begin
                          Edit;
                          FieldByName('occ02').AsString := l_occ_file.FieldByName('occ01').AsString + '-' + l_occ_file.FieldByName('occ02').AsString;
                          Post;
                        end;
                    end;
                    Next;
                  end;
                end;
              finally
                FreeAndNil(tmpList);
              end;
            end;
          end;
        end;
        //***

      end;
    end;
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDSX);
    with l_SalCDS do
    begin
      if ChangeCount > 0 then
        MergeChangeLog;
      EnableControls;
      AfterScroll := l_SalCDSAfterScroll;
      if Active then
        First;
    end;
    StatusBar1.Panels[0].Text := '';
    btn_ok.Enabled := True;
  end;
end;

procedure TFrmStock.BitBtn1Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TFrmStock.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if (not l_StkCDS.Active) or l_StkCDS.IsEmpty then
    Exit;

  if (Pos('管制', l_StkCDS.FieldByName('ta_img04').AsString) > 0) or (Pos('管製', l_StkCDS.FieldByName('ta_img04').AsString) > 0) or (Pos('奪秶', l_StkCDS.FieldByName('ta_img04').AsString) > 0) then
    AFont.Color := clRed
  else if Length(l_StkCDS.FieldByName('cjremark').AsString) > 0 then
    AFont.Color := clBlue;
end;

procedure TFrmStock.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  if (not l_edit) or (not l_StkCDS.Active) or (not l_SalCDS.Active) or l_StkCDS.IsEmpty or l_SalCDS.IsEmpty then
    N1.Visible := False
  else
    N1.Visible := True;
end;

procedure TFrmStock.N1Click(Sender: TObject);
var
  tmpNum: string;
  tmpQty: Double;
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if l_SalCDS.FieldByName('bookingqty').AsFloat <> 0 then
    tmpNum := l_SalCDS.FieldByName('bookingqty').AsString;
  if not InputQuery(CheckLang('請輸入booking數量'), 'Qty', tmpNum) then
    Exit;

  tmpNum := Trim(tmpNum);
  if Length(tmpNum) = 0 then
    Exit;

  tmpQty := StrToFloatDef(tmpNum, 0);
  if tmpQty < 0 then
  begin
    ShowMsg('無效的booking數量,請重新輸入!', 48);
    Exit;
  end;

  tmpSQL := 'select * from dli603' + ' where bu=' + Quotedstr(l_StkCDS.FieldByName('dbtype').AsString) + ' and pno=' + Quotedstr(l_StkCDS.FieldByName('img01').AsString) + ' and place=' + Quotedstr(l_StkCDS.FieldByName('img02').AsString) + ' and area=' + Quotedstr(l_StkCDS.FieldByName('img03').AsString) + ' and lot=' + Quotedstr(l_StkCDS.FieldByName('img04').AsString) + ' and ordbu=' + Quotedstr(l_SalCDS.FieldByName('dbtype').AsString) + ' and orderno=' + Quotedstr(l_SalCDS.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(l_SalCDS.FieldByName('oeb03').AsInteger);
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    if tmpQty > 0 then
    begin
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString := l_StkCDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('pno').AsString := l_StkCDS.FieldByName('img01').AsString;
        tmpCDS.FieldByName('place').AsString := l_StkCDS.FieldByName('img02').AsString;
        tmpCDS.FieldByName('area').AsString := l_StkCDS.FieldByName('img03').AsString;
        tmpCDS.FieldByName('lot').AsString := l_StkCDS.FieldByName('img04').AsString;
        tmpCDS.FieldByName('qty').AsFloat := tmpQty;
        tmpCDS.FieldByName('ordbu').AsString := l_SalCDS.FieldByName('dbtype').AsString;
        tmpCDS.FieldByName('orderno').AsString := l_SalCDS.FieldByName('oea01').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger := l_SalCDS.FieldByName('oeb03').AsInteger;
        tmpCDS.FieldByName('iuser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime := Now;
        tmpCDS.Post;
      end
      else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('qty').AsFloat := tmpQty;
        tmpCDS.FieldByName('muser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime := Now;
        tmpCDS.Post;
      end
    end
    else
    begin
      if not tmpCDS.IsEmpty then
        tmpCDS.Delete;
    end;

    if not CDSPost(tmpCDS, 'dli603') then
      Exit;


    //刷新欄位
    Data := null;
    tmpSQL := 'select ''A'' as ftype,sum(qty) qty from dli603' + ' where bu=' + Quotedstr(l_StkCDS.FieldByName('dbtype').AsString) + ' and pno=' + Quotedstr(l_StkCDS.FieldByName('img01').AsString) + ' and place=' + Quotedstr(l_StkCDS.FieldByName('img02').AsString) + ' and area=' + Quotedstr(l_StkCDS.FieldByName('img03').AsString) + ' and lot=' + Quotedstr(l_StkCDS.FieldByName('img04').AsString) + ' group by bu,pno,place,area,lot' + ' union all' + ' select ''B'' as ftype,sum(qty) qty from dli603' + ' where ordbu=' + Quotedstr(l_SalCDS.FieldByName('dbtype').AsString) + ' and orderno=' + Quotedstr(l_SalCDS.FieldByName('oea01').AsString) + ' and orderitem=' + IntToStr(l_SalCDS.FieldByName('oeb03').AsInteger) + ' group by ordbu,orderno,orderitem';
    if not QueryBySQL(tmpSQL, Data) then
      Exit;
    tmpCDS.Data := Data;

    with l_StkCDS do
    begin
      Edit;
      FieldByName('bookingqty').Clear;
      if tmpCDS.Locate('ftype', 'A', []) then
        if tmpCDS.FieldByName('qty').AsFloat <> 0 then
          FieldByName('bookingqty').AsFloat := tmpCDS.FieldByName('qty').AsFloat;
      Post;
      MergeChangeLog;
    end;

    with l_SalCDS do
    begin
      Edit;
      FieldByName('bookingqty').Clear;
      if tmpCDS.Locate('ftype', 'B', []) then
        if tmpCDS.FieldByName('qty').AsFloat <> 0 then
          FieldByName('bookingqty').AsFloat := tmpCDS.FieldByName('qty').AsFloat;
      Post;
      MergeChangeLog;
    end;

  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmStock.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if (not l_StkCDS.Active) or (not l_SalCDS.Active) or l_StkCDS.IsEmpty then
    Exit;

  FrmStock_booking1 := TFrmStock_booking1.Create(nil);
  try
    FrmStock_booking1.l_StkCDS := Self.l_StkCDS;
    FrmStock_booking1.l_SalCDS := Self.l_SalCDS;
    FrmStock_booking1.l_edit := Self.l_edit;
    FrmStock_booking1.ShowModal;
  finally
    FreeAndNil(FrmStock_booking1);
  end;
end;

procedure TFrmStock.DBGridEh2DblClick(Sender: TObject);
begin
  inherited;
  if (not l_StkCDS.Active) or (not l_SalCDS.Active) or l_SalCDS.IsEmpty then
    Exit;

  FrmStock_booking2 := TFrmStock_booking2.Create(nil);
  try
    FrmStock_booking2.l_StkCDS := Self.l_StkCDS;
    FrmStock_booking2.l_SalCDS := Self.l_SalCDS;
    FrmStock_booking2.l_edit := Self.l_edit;
    FrmStock_booking2.ShowModal;
  finally
    FreeAndNil(FrmStock_booking2);
  end;
end;

procedure TFrmStock.Timer1Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if l_Ans then
    Exit;

  Timer1.Enabled := False;
  try
    if l_List2.Count = 0 then
      Exit;

    while l_List2.Count > 1 do
      l_List2.Delete(l_List2.Count - 1);

    tmpSQL := l_List2.Strings[0];
    if tmpSQL = l_SQL2 then
      Exit;
    l_SQL2 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      l_MpsCDS.Data := Data;
  finally
    Timer1.Enabled := True;
  end;
end;

procedure TFrmStock.Timer2Timer(Sender: TObject);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  if l_Ans then
    Exit;

  Timer2.Enabled := False;
  try
    if l_List3.Count = 0 then
      Exit;

    while l_List3.Count > 1 do
      l_List3.Delete(l_List3.Count - 1);

    tmpSQL := l_List3.Strings[0];
    if tmpSQL = l_SQL3 then
      Exit;
    l_SQL3 := tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
      l_CDS650.Data := Data;
  finally
    Timer2.Enabled := True;
  end;
end;

procedure TFrmStock.full_MPS012_Stock();
var
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;

  if (not l_StkCDS.Active) or l_StkCDS.IsEmpty then
    Exit;
  Data := null;

  
  // 1.
  tmpCDS := TClientDataSet.Create(nil);
  tmpCDS.Data := l_StkCDS.Data;
  with tmpCDS do
    while not Eof do
    begin
      tmpSQL := tmpSQL + ' or (batchNo=' + Quotedstr(FieldByName('img04').AsString) + ' and dbtype=' + Quotedstr(FieldByName('dbtype').AsString) + ')';
      Next;
    end;

  Data := null;


  // 2.
  tmpSQL := 'select * from MPS012_Stock Where ((1=2)' + tmpSQL + ')';

  if QueryBySQL(tmpSQL, Data) then
    l_MPS012_Stock_CDS.Data := Data;

end;

procedure TFrmStock.DBGridEh1CellClick(Column: TColumnEh);
var
  batchNo: string;
begin
  inherited;

  if (not l_StkCDS.Active) or (l_StkCDS.IsEmpty) then
    Exit;

  if SameText(Column.FieldName, 'img01') then
    with l_MPS012_Stock_CDS do
    begin
      batchNo := l_StkCDS.FieldByName('img04').AsString;
      Filtered := False;
      Filter := 'batchNo=' + Quotedstr(batchNo);
      Filtered := true;
    end;
end;

end.

