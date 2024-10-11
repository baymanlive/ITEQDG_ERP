{*******************************************************}
{                                                       }
{                unMPST130                              }
{                Author: kaikai                         }
{                Create date: 2020/10/27                }
{                Description: PNL重工工單產生作業       }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST130;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ComCtrls, ToolWin, StrUtils, unMPST130_Wono;

type
  TFrmMPST130 = class(TFrmSTDI041)
    btn_mpst130: TToolButton;
    chkAll: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure btn_mpst130Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure chkAllClick(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure DBGridEh1DblClick(Sender: TObject);
  private
    l_isDG, l_SelEdit: Boolean;
    l_isCreate, l_isComplete: Integer;
    l_CDS: TClientDataSet;
    l_StrIndex, l_StrIndexDesc: string;
    l_MPST130_Wono: TMPST130_Wono;
    procedure GetDS(xFliter: string);
    procedure GetADate(Bu, Orderno, Orderitem: string; OrdWono: TOrderWono);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST130: TFrmMPST130;

implementation

uses
  unGlobal, unCommon, unMPST130_Query, unMPST130_WonoList;    
                 {(*}
const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="select" fieldtype="boolean"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="orderdate" fieldtype="date"/>'
           +'<FIELD attrname="adate" fieldtype="date"/>'
           +'<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="orderitem" fieldtype="i4"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="oeb11" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="longitude" fieldtype="r8"/>'
           +'<FIELD attrname="latitude" fieldtype="r8"/>'
           +'<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ta_oeb07" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="units" fieldtype="string" WIDTH="4"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="pml20" fieldtype="r8"/>'
           +'<FIELD attrname="outqty" fieldtype="r8"/>'
           +'<FIELD attrname="notqty" fieldtype="r8"/>'
           +'<FIELD attrname="l_pno" fieldtype="string" WIDTH="30"/>'  //大料料號
           +'<FIELD attrname="l_qty" fieldtype="r8"/>'                 //大料數量
           +'<FIELD attrname="w_wono" fieldtype="string" WIDTH="10"/>' //工單號碼
           +'<FIELD attrname="w_qty" fieldtype="r8"/>'                 //開料數量
           +'<FIELD attrname="num" fieldtype="i4"/>'                   //產生次數
           +'<FIELD attrname="iscolor" fieldtype="boolean"/>'          //產生次數
           +'<FIELD attrname="iscreate" fieldtype="string" WIDTH="1"/>'
           +'<FIELD attrname="iscomplete" fieldtype="string" WIDTH="1"/>'
           +'<FIELD attrname="tc_ocm03" fieldtype="i4"/>'
           +'<FIELD attrname="ta_oeb03" fieldtype="string" WIDTH="10"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';
                       {*)}
{$R *.dfm}

procedure TFrmMPST130.GetDS(xFliter: string);
var
  len, i: Integer;
  tmpSQL, tmpSQL2, tmpStr, tmpOraDB, tmpFstCode, tmpOrderno, tmpWono, msg: string;
  Data: OleVariant;
  tmpCDS1, tmpCDS2: TClientDataSet;
  tmpList: TStrings;
begin
  tmpOrderno := '';
  l_CDS.EmptyDataSet;
  chkAll.Tag := 1;
  chkAll.Checked := False;
  g_StatusBar.Panels[0].Text := '正在查詢PNL訂單資料...';
  Application.ProcessMessages;
  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  tmpList := TStringList.Create;
  try
    if l_isDG then
      tmpOraDB := 'ORACLE'
    else
      tmpOraDB := 'ORACLE1';
    Data := null;
//    tmpSQL := 'select C.*,oao06,pmk01,pml02,sfb08 from' +
//              ' (select B.*,ima021 from' +
//              ' (select A.*,occ02 from' +
//              ' (select oea01,oea02,oea04,oeb03,oeb04,oeb05,oeb06,oeb11,oeb12,oeb15,' +
//              ' oeb24,oeb12-oeb24 notqty,ta_oeb01,ta_oeb02,ta_oeb03,ta_oeb04,ta_oeb07,ta_oeb10,' +
//              ' to_char(oea02,''YYYY/MM/DD'') q_oea02' +
//              ' from oea_file inner join oeb_file on oea01=oeb01' +
//              ' where oeaconf=''Y'' and nvl(oeb70,''N'')=''N'') A' +
//              ' inner join occ_file on oea04=occ01 where 1=1 ' + xFliter +
//              ' ) B left join ima_file on oeb04=ima01 ) C '
//            + ' left join( select pmk01,pml02,pmk04,pml06, (case when instr(pml06,'' '')>0 then substr(pml06,1,instr(pml06,'' '')) else pml06||'' '' end) as pml06_1 from pmk_file,pml_file,ima_file where pmk01=pml01 and pml04=ima01 '
//            + ' and pmkacti=''Y'' and length(nvl(pml06,''''))>12 )D on D.pml06_1=(C.oea01||''-''||C.oeb03||'' '') '
//            + ' left join oao_file on oea01=oao01 and oeb03=oao03 order by oea02,oea01,oeb03';
        {(*}
        tmpSQL := 'select B.*,ima021,oao06,pml20,sfb08 from' +
              ' (select A.*,occ02 from' +
              ' (select oea01,oea02,oea04,oeb03,oeb04,oeb05,oeb06,oeb11,oeb12,oeb15,' +
              ' oeb24,oeb12-oeb24 notqty,ta_oeb01,ta_oeb02,ta_oeb03,ta_oeb04,ta_oeb07,ta_oeb10,' +
              ' to_char(oea02,''YYYY/MM/DD'') q_oea02' +
              ' from oea_file inner join oeb_file on oea01=oeb01' +
              ' where oeaconf=''Y'' and nvl(oeb70,''N'')=''N'') A' +
              ' inner join occ_file on oea04=occ01 where 1=1 ' + xFliter +
              ' ) B left join ima_file on oeb04=ima01'+
              ' left join oao_file on oea01=oao01 and oeb03=oao03'+
              ' left join (select pml06,sum(pml20)pml20 from pml_file,pmk_file '+
              ' where pml01=pmk01 and pmkacti=''Y'' and pmk09<>''N012'' and pmk09<>''N018'' '+
              ' group by pml06)c on pml06 like case when instr(pml06,'' '')>0 then oea01||''-''||oeb03||'' %'' else oea01||''-''||oeb03||''%'' end '+
              ' left join (select sfb22,sfb221,sum(sfb08)sfb08 from sfb_file ' +
              ' where sfb01 not like ''516%'''+
              ' and sfb01 not like ''51T%'''+
              ' and sfb01 not like ''513%'''+
              ' and sfb01 not like ''R15%'''+
              ' and sfb01 not like ''R14%'''+
              ' group by sfb22,sfb221)d on oea01=sfb22 and oeb03=sfb221';
        {*)}

    if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
      Exit;
    tmpCDS1.Data := Data;
    with tmpCDS1 do
    begin
      if IsEmpty then
        Exit;
      while not Eof do
      begin
        if Length(FieldByName('oea01').AsString) > 0 then
          if Pos(FieldByName('oea01').AsString, tmpOrderno) = 0 then
            tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('oea01').AsString);

        l_CDS.Append;
        l_CDS.FieldByName('select').AsBoolean := False;
        l_CDS.FieldByName('custno').AsString := FieldByName('oea04').AsString;
        l_CDS.FieldByName('custshort').AsString := FieldByName('occ02').AsString;
        l_CDS.FieldByName('orderdate').AsDateTime := FieldByName('oea02').AsDateTime;
        l_CDS.FieldByName('orderno').AsString := FieldByName('oea01').AsString;
        l_CDS.FieldByName('orderitem').AsInteger := FieldByName('oeb03').AsInteger;
        l_CDS.FieldByName('pno').AsString := FieldByName('oeb04').AsString;
        l_CDS.FieldByName('pname').AsString := FieldByName('oeb06').AsString;
        l_CDS.FieldByName('sizes').AsString := FieldByName('ima021').AsString;
        l_CDS.FieldByName('oeb11').AsString := FieldByName('oeb11').AsString;
        l_CDS.FieldByName('c_sizes').AsString := FieldByName('ta_oeb10').AsString;
        l_CDS.FieldByName('remark').AsString := FieldByName('oao06').AsString;
        l_CDS.FieldByName('longitude').AsString := FieldByName('ta_oeb01').AsString;
        l_CDS.FieldByName('latitude').AsString := FieldByName('ta_oeb02').AsString;
        l_CDS.FieldByName('ta_oeb03').AsString := FieldByName('ta_oeb03').AsString;
        l_CDS.FieldByName('ta_oeb04').AsString := FieldByName('ta_oeb04').AsString;
        l_CDS.FieldByName('ta_oeb07').AsString := FieldByName('ta_oeb07').AsString;
        l_CDS.FieldByName('units').AsString := FieldByName('oeb05').AsString;
        l_CDS.FieldByName('pml20').AsFloat := FieldByName('pml20').AsFloat;
        l_CDS.FieldByName('qty').AsFloat := FieldByName('oeb12').AsFloat;//-tmpCDS1.FieldByName('sfb08').AsFloat-tmpCDS1.FieldByName('pml20').AsFloat;
//        if l_CDS.FieldByName('qty').AsFloat<=0 then
//        begin
//
//        end;
        l_CDS.FieldByName('outqty').AsFloat := FieldByName('oeb24').AsFloat;
        l_CDS.FieldByName('notqty').AsFloat := FieldByName('notqty').AsFloat;
        l_CDS.FieldByName('iscreate').AsString := 'N';
        l_CDS.FieldByName('iscomplete').AsString := 'N';
        l_CDS.FieldByName('tc_ocm03').AsInteger := 0;
        l_CDS.FieldByName('iscolor').AsBoolean := False;

        // pmk01,pml02 longxinjue 20211229
//        l_CDS.FieldByName('pmk01').AsString := FieldByName('pmk01').AsString;
//        l_CDS.FieldByName('pml02').AsString := FieldByName('pml02').AsString;

        l_CDS.Post;

        Next;
      end;
    end;

    //更新已產生的訂單
    g_StatusBar.Panels[0].Text := '正在處理已產生工單資料...';
    Application.ProcessMessages;
    if Length(tmpOrderno) > 0 then
    begin
      Delete(tmpOrderno, 1, 1);
      Data := null;
      tmpSQL := 'select orderno,orderitem,wono,pno,qty,num,iscolor from mps015 where orderno in (' + tmpOrderno + ')';
      tmpSQL2 := 'select orderno,orderitem,adate from mps010 where orderno in (' + tmpOrderno + ')';
      if l_isDG then
      begin
        tmpSQL := tmpSQL + ' and bu=''ITEQDG''';
        tmpSQL2 := tmpSQL2 + ' and bu=''ITEQDG''';
      end
      else
      begin
        tmpSQL := tmpSQL + ' and bu=''ITEQGZ''';
        tmpSQL2 := tmpSQL2 + ' and bu=''ITEQGZ''';
      end;
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS1.Data := Data;
      if not QueryBySQL(tmpSQL2, Data) then
        Exit;
      tmpCDS2.Data := Data;

      if not tmpCDS1.IsEmpty then
      begin
        l_CDS.First;
        while not l_CDS.Eof do
        begin
          if tmpCDS1.Locate('orderno;orderitem', VarArrayOf([l_CDS.FieldByName('orderno').AsString, l_CDS.FieldByName('orderitem').AsInteger]), []) then
          begin
            l_CDS.Edit;
            l_CDS.FieldByName('w_wono').Value := tmpCDS1.FieldByName('wono').Value;             //工單號碼
            l_CDS.FieldByName('l_pno').Value := tmpCDS1.FieldByName('pno').Value;               //大料料號
            l_CDS.FieldByName('w_qty').Value := tmpCDS1.FieldByName('qty').Value;               //開料數量(應為訂單數量,當訂單變更時數量可能會不一致,提醒用)
            l_CDS.FieldByName('num').Value := tmpCDS1.FieldByName('num').Value;                 //開工單資料
            l_CDS.FieldByName('iscolor').AsBoolean := tmpCDS1.FieldByName('iscolor').AsBoolean; //標記了顏色
            if Length(l_CDS.FieldByName('w_wono').AsString) > 0 then
              l_CDS.FieldByName('iscreate').AsString := 'Y';
            l_CDS.Post;
          end;
          if tmpCDS2.Locate('orderno;orderitem', VarArrayOf([l_CDS.FieldByName('orderno').AsString, l_CDS.FieldByName('orderitem').AsInteger]), []) then
          begin
            l_CDS.Edit;
            l_CDS.FieldByName('adate').Value := tmpCDS2.FieldByName('adate').Value;
            l_CDS.Post;
          end;

          l_CDS.Next;
        end;
      end;
    end;

    if l_isCreate <> 2 then
    begin
      with l_CDS do
      begin
        Filtered := False;
        if l_isCreate = 0 then
          Filter := 'iscreate=''Y'''
        else
          Filter := 'iscreate=''N''';
        Filtered := True;
        while not IsEmpty do
          Delete;
        Filtered := False;
        Filter := '';
      end;
    end;

    //轉換大板料號、數量(邏輯與生產排程一樣)
    g_StatusBar.Panels[0].Text := '正在處理大料料號...';
    Application.ProcessMessages;
    tmpList.Clear;
    if not l_CDS.IsEmpty then
    begin
       //PNL板
      Data := null;
      tmpSQL := 'select tc_ocl01,tc_ocl07 from tc_ocl_file';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
        Exit;
      tmpCDS1.Data := Data;

      //PNL板1開几
      Data := null;
      tmpSQL := 'select tc_ocm01,tc_ocm03 from tc_ocm_file';
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
        Exit;
      tmpCDS2.Data := Data;

      l_CDS.First;
      while not l_CDS.Eof do
      begin
        if Length(l_CDS.FieldByName('w_wono').AsString) > 0 then
          if tmpList.IndexOf(l_CDS.FieldByName('w_wono').AsString) = -1 then
            tmpList.Add(l_CDS.FieldByName('w_wono').AsString);

        tmpStr := l_CDS.FieldByName('pno').AsString;
        len := Length(tmpStr);
        tmpFstCode := LeftStr(tmpStr, 1);

        l_CDS.Edit;
        if Pos(tmpFstCode, 'ET') > 0 then
        begin
          if Length(l_CDS.FieldByName('l_pno').AsString) = 0 then //大料料號可編輯,若有內容則視為手工輸入或是之前產生工單所保存的料號
            if tmpCDS1.Locate('tc_ocl01', l_CDS.FieldByName('ta_oeb04').AsString, []) then
            begin
              if len = 11 then
                l_CDS.FieldByName('l_pno').AsString := Copy(tmpStr, 1, 8) + tmpCDS1.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 9, 3)
              else
                l_CDS.FieldByName('l_pno').AsString := Copy(tmpStr, 1, 8) + tmpCDS1.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 17, 3);
            end;

          if tmpCDS2.Locate('tc_ocm01', l_CDS.FieldByName('ta_oeb07').AsString, []) and (tmpCDS2.FieldByName('tc_ocm03').AsInteger > 0) then
          begin
            l_CDS.FieldByName('tc_ocm03').AsInteger := tmpCDS2.FieldByName('tc_ocm03').AsInteger;
            l_CDS.FieldByName('l_qty').AsFloat := l_CDS.FieldByName('qty').AsFloat / tmpCDS2.FieldByName('tc_ocm03').AsInteger;
            if Trunc(l_CDS.FieldByName('l_qty').AsFloat) < l_CDS.FieldByName('l_qty').AsFloat then
              l_CDS.FieldByName('l_qty').AsFloat := Round(l_CDS.FieldByName('l_qty').AsFloat + 0.5);
          end;
        end
        else
        begin
          if tmpFstCode = 'M' then
            tmpFstCode := 'B'
          else
            tmpFstCode := 'R';

          if Length(l_CDS.FieldByName('l_pno').AsString) = 0 then //大料料號可編輯,若有內容則視為手工輸入或是之前產生工單所保存的料號
            if tmpCDS1.Locate('tc_ocl01', l_CDS.FieldByName('ta_oeb04').AsString, []) then
            begin
              if len = 12 then
                l_CDS.FieldByName('l_pno').AsString := tmpFstCode + Copy(tmpStr, 2, 9) + tmpCDS1.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 11, 2)
              else
                l_CDS.FieldByName('l_pno').AsString := tmpFstCode + Copy(tmpStr, 2, 9) + tmpCDS1.FieldByName('tc_ocl07').AsString + Copy(tmpStr, 19, 2);
            end;

          if tmpCDS2.Locate('tc_ocm01', l_CDS.FieldByName('ta_oeb07').AsString, []) and (tmpCDS2.FieldByName('tc_ocm03').AsInteger > 0) then
          begin
            l_CDS.FieldByName('tc_ocm03').AsInteger := tmpCDS2.FieldByName('tc_ocm03').AsInteger;
            l_CDS.FieldByName('l_qty').AsFloat := ((l_CDS.FieldByName('qty').AsFloat / tmpCDS2.FieldByName('tc_ocm03').AsInteger) * l_CDS.FieldByName('longitude').AsFloat * 25.4) / 1000;
            if Trunc(l_CDS.FieldByName('l_qty').AsFloat) < l_CDS.FieldByName('l_qty').AsFloat then
              l_CDS.FieldByName('l_qty').AsFloat := Round(l_CDS.FieldByName('l_qty').AsFloat + 0.5);

            if l_CDS.FieldByName('l_qty').AsInteger mod 10 <> 0 then   //10的倍數
              l_CDS.FieldByName('l_qty').AsFloat := (Trunc(l_CDS.FieldByName('l_qty').AsInteger / 10) + 1) * 10;
          end;

//          tmpCDS1.FieldByName('pml20').AsFloat := tmpCDS1.FieldByName('oeb12').AsFloat - tmpCDS1.FieldByName('pml20').AsFloat - tmpCDS1.FieldByName('sfb08').AsFloat;
//          if tmpCDS1.FieldByName('pml20').AsFloat <= 0 then
//          begin
//            msg := '[' + l_CDS.FieldByName('orderno').AsString + '/' + l_CDS.FieldByName('orderitem').AsString + ']超出訂單數量,是否略過?';
//            case Application.MessageBox(pchar(msg), '提示', MB_YESNOCANCEL + MB_ICONQUESTION) of
//              IDNO:
//                begin
//                  tmpCDS1.Cancel;
//                  l_CDS.Next;
//                  Continue;
//                end;
//              IDCANCEL:
//                exit;
//            end;
//          end;
        end;
        l_CDS.Post;

        l_CDS.Next;
      end;
    end;

    //更新工單完工
    g_StatusBar.Panels[0].Text := '正在處理已完工資料...';
    Application.ProcessMessages;
    if tmpList.Count > 0 then
    begin
      tmpSQL := '';
      tmpWono := '';
      Data := null;
      for i := 0 to tmpList.Count - 1 do
      begin
        tmpWono := tmpWono + ',' + Quotedstr(tmpList.Strings[i]);
        if (i + 1) mod 900 = 0 then  //oracle in 條件不能超過1000個
        begin
          Delete(tmpWono, 1, 1);
          if Length(tmpSQL) > 0 then
            tmpSQL := tmpSQL + ' union all ';
          tmpSQL := tmpSQL + 'select sfb01 from sfb_file where sfb01 in (' + tmpWono + ') and sfb04 in (''7'',''8'')';
          tmpWono := '';
        end;
      end;

      if Length(tmpWono) > 0 then
      begin
        Delete(tmpWono, 1, 1);
        if Length(tmpSQL) > 0 then
          tmpSQL := tmpSQL + ' union all ';
        tmpSQL := tmpSQL + 'select sfb01 from sfb_file where sfb01 in (' + tmpWono + ') and sfb04 in (''7'',''8'')';
      end;
      if not QueryBySQL(tmpSQL, Data, tmpOraDB) then
        Exit;
      tmpCDS1.Data := Data;

      if not tmpCDS1.IsEmpty then
      begin
        l_CDS.First;
        while not l_CDS.Eof do
        begin
          if (Length(l_CDS.FieldByName('w_wono').AsString) > 0) and tmpCDS1.Locate('sfb01', l_CDS.FieldByName('w_wono').AsString, []) then
          begin
            l_CDS.Edit;
            l_CDS.FieldByName('iscomplete').AsString := 'Y';
            l_CDS.Post;
          end;

          l_CDS.Next;
        end;
      end;
    end;

    if l_isComplete <> 2 then
    begin
      with l_CDS do
      begin
        Filtered := False;
        if l_isComplete = 0 then
          Filter := 'iscomplete=''Y'''
        else
          Filter := 'iscomplete=''N''';
        Filtered := True;
        while not IsEmpty do
          Delete;
        Filtered := False;
        Filter := '';
      end;
    end;

    if l_CDS.ChangeCount > 0 then
      l_CDS.MergeChangeLog;
    g_StatusBar.Panels[0].Text := '';
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpList);
    CDS.Data := l_CDS.Data;
    chkAll.Tag := 0;
  end;
end;

procedure TFrmMPST130.RefreshDS(strFilter: string);
begin
  if strFilter = g_cFilterNothing then
    CDS.Data := l_CDS.Data
  else
    GetDS(strFilter);
end;

procedure TFrmMPST130.FormCreate(Sender: TObject);
begin
  p_SysId := 'MPS';
  p_TableName := 'MPST130';
  p_GridDesignAns := True;
  p_SBText := CheckLang('雙擊[產品編碼]欄位可改變底色,[大料料號,工單號碼]欄位可編輯');
  btn_quit.Left := btn_mpst130.Left + btn_mpst130.Width;
  btn_mpst130.Visible := g_MInfo^.R_edit;
  l_CDS := TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_Xml);
  l_isCreate := 0;
  l_isComplete := 0;

  inherited;
end;

procedure TFrmMPST130.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPST130.btn_queryClick(Sender: TObject);
var
  str: string;
begin
//  inherited;
  if not Assigned(FrmMPST130_Query) then
    FrmMPST130_Query := TFrmMPST130_Query.Create(Application);
  if FrmMPST130_Query.ShowModal = mrOK then
  begin
    l_isCreate := FrmMPST130_Query.Rgp2.ItemIndex;
    l_isComplete := FrmMPST130_Query.Rgp3.ItemIndex;
    l_isDG := FrmMPST130_Query.Rgp4.ItemIndex = 0;
    str := ' and q_oea02>=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmMPST130_Query.Dtp1.Date), '-', '/', [rfReplaceAll])) + ' and q_oea02<=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmMPST130_Query.Dtp2.Date), '-', '/', [rfReplaceAll])) + ' and substr(oea01,1,3) not in (''22A'',''226'')' + ' and substr(oeb06,1,7) not in (''IT958TC'',''IT958BS'',''IT968TC'',''IT968BS'',''IT988TC'',''IT988BS'',''IT180GN'')';

    if Length(Trim(FrmMPST130_Query.Edit2.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST130_Query.Edit2.Text))) + ',oea01)>0';
    if Length(Trim(FrmMPST130_Query.Edit1.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST130_Query.Edit1.Text))) + ',oea04)>0';
    if Length(Trim(FrmMPST130_Query.Edit3.Text)) > 0 then
      str := str + ' and oeb04 like ' + Quotedstr(FrmMPST130_Query.Edit3.Text + '%');
    if Length(Trim(FrmMPST130_Query.Edit4.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST130_Query.Edit4.Text))) + ',substr(oeb04,2,1))>0';
    case FrmMPST130_Query.Rgp1.ItemIndex of
      0:
        str := str + ' and oeb05=''PN'' and substr(oeb04,1,1) in (''E'',''T'') and length(oeb04) in (11,19)';
      1:
        str := str + ' and oeb05=''PN'' and substr(oeb04,1,1) in (''M'',''N'') and length(oeb04) in (12,20)';
      2:
        str := str + ' and oeb05=''PN'' and substr(oeb04,1,1) in (''E'',''T'',''M'',''N'') and length(oeb04) in (11,12,19,20)';
    end;

    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(str);
  end;
end;

procedure TFrmMPST130.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST130.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'select') then
  begin
    l_SelEdit := True;
    try
      CDS.Edit;
      CDS.FieldByName('select').AsBoolean := not CDS.FieldByName('select').AsBoolean;
      CDS.Post;
      CDS.MergeChangeLog;
    finally
      l_SelEdit := False;
    end;
  end;
end;

procedure TFrmMPST130.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if DBGridEh1.SelectedField = CDS.FieldByName('pno') then
  begin
    CDS.Edit;
    CDS.FieldByName('iscolor').AsBoolean := not CDS.FieldByName('iscolor').AsBoolean;
    CDS.Post;
    CDS.MergeChangeLog;
  end;
end;

procedure TFrmMPST130.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'iscreate') then
    if CDS.FieldByName('iscreate').AsString = 'N' then
      AFont.Color := clRed;

  if CDS.FieldByName('iscomplete').AsString = 'Y' then
    AFont.Color := clGray
  else if (Length(CDS.FieldByName('w_wono').AsString) > 0) and (CDS.FieldByName('w_qty').AsFloat > 0) and (CDS.FieldByName('w_qty').AsFloat <> CDS.FieldByName('qty').AsFloat) and  //工單數量<>訂單數量
    (CDS.FieldByName('iscomplete').AsString = 'N') then
    AFont.Color := clRed;

  if SameText(Column.FieldName, 'pno') then
    if CDS.FieldByName('iscolor').AsBoolean then
      Background := clYellow
    else
      Background := clWindow;
end;

procedure TFrmMPST130.btn_mpst130Click(Sender: TObject);
var
  i: Integer;
  tmpStr, tmpSQL, tmpOrderno, tmpAllWono: string;
  OrdWono: TOrderWono;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
  dsNE: TDataSetNotifyEvent;
begin
  inherited;
  if Pos(LowerCase(g_UInfo^.BU), 'iteqdg,iteqgz') = 0 then
  begin
    ShowMsg('此程式只適用于ITEQDG/ITEQGZ!', 48);
    Exit;
  end;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇單據!', 48);
    Exit;
  end;

  tmpCDS1 := TClientDataSet.Create(nil);
  tmpCDS2 := TClientDataSet.Create(nil);
  try
    tmpCDS1.Data := CDS.Data;
    with tmpCDS1 do
    begin
      Filtered := False;
      Filter := 'select=1';
      Filtered := True;
      IndexFieldNames := 'orderdate;orderno;orderitem';
      if IsEmpty then
      begin
        ShowMsg('請選擇單據!', 48);
        Exit;
      end;

      First;
      while not Eof do
      begin
        tmpStr := FieldByName('orderno').AsString + '/' + IntToStr(FieldByName('orderitem').AsInteger) + ':';

        if Length(Trim(FieldByName('pno').AsString)) = 0 then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '訂單料號錯誤!', 48);
          Exit;
        end;

        if FieldByName('qty').AsFloat <= 0 then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '訂單數量錯誤!', 48);
          Exit;
        end;

        if Length(Trim(FieldByName('l_pno').AsString)) = 0 then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '未輸入大料料號!', 48);
          Exit;
        end;

        if FieldByName('l_qty').AsFloat <= 0 then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '大料數量錯誤!', 48);
          Exit;
        end;

        if FieldByName('notqty').AsFloat = 0 then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '未交數量=0!', 48);
          Exit;
        end;

        if (Length(Trim(FieldByName('w_wono').AsString)) > 0) or (FieldByName('num').AsInteger > 0) then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '已產生工單,不可重複產生!', 48);
          Exit;
        end;

        if  (FieldByName('pml20').Value > 0) then
        begin
          Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []);
          ShowMsg(tmpStr + '已開出申購單!', 48);
          Exit;
        end;

        Next;
      end;

      if RecordCount > 50 then
      begin
        ShowMsg('最多可選50筆,請重新選擇!', 48);
        Exit;
      end;

      if ShowMsg('確定產生重工工單嗎?', 33) = IdCancel then
        Exit;

      i := 1;
      tmpAllWono := '';
      First;
      while not Eof do
      begin
        OrdWono.Orderno := FieldByName('orderno').AsString;
        OrdWono.Orderitem := FieldByName('orderitem').AsString;
        OrdWono.FstCode := Copy(FieldByName('pno').AsString, 1, 1);
        OrdWono.Pno := FieldByName('pno').AsString;        //主檔料號(小片)
        OrdWono.Qty := FieldByName('qty').AsFloat;
        OrdWono.L_pno := FieldByName('l_pno').AsString;    //明細檔料號(大料)
        OrdWono.L_qty := FieldByName('l_qty').AsFloat;
        OrdWono.ta_oeb03 := FieldByName('ta_oeb03').AsString;
        OrdWono.ta_oeb01 := FieldByName('longitude').AsFloat;
        OrdWono.tc_ocm03 := FieldByName('tc_ocm03').AsInteger;
        OrdWono.IsDG := SameText(g_UInfo^.BU, 'ITEQDG');
        GetADate(IfThen(OrdWono.IsDG, 'ITEQDG', 'ITEQGZ'), OrdWono.Orderno, OrdWono.Orderitem, OrdWono);
        if not Assigned(l_MPST130_Wono) then
          l_MPST130_Wono := TMPST130_Wono.Create;

        if i = 1 then
          if not l_MPST130_Wono.Init(OrdWono.IsDG) then
            Exit;

        tmpStr := '  ' + IntToStr(i) + '/' + IntToStr(RecordCount);
        if l_MPST130_Wono.SetWono(OrdWono, tmpStr) then
        begin
          tmpAllWono := tmpAllWono + #13#10 + tmpStr;
          Edit;
          FieldByName('w_wono').AsString := tmpStr;
          FieldByName('w_qty').AsFloat := OrdWono.Qty;
          FieldByName('num').AsInteger := -1;
          Post;
        end;

        Inc(i);

        Next;
      end;
    end;

    //儲存
    if l_MPST130_Wono.Post(OrdWono.IsDG) then
    begin
      tmpOrderno := '';
      Self.CDS.DisableControls;
      dsNE := Self.CDS.AfterScroll;
      Self.CDS.AfterScroll := nil;
      try
        with tmpCDS1 do
        begin
          First;
          while not Eof do
          begin
            if FieldByName('num').AsInteger = -1 then
            begin
              if Length(FieldByName('orderno').AsString) > 0 then
                if Pos(FieldByName('orderno').AsString, tmpOrderno) = 0 then
                  tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('orderno').AsString);

              if Self.CDS.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []) then
              begin
                Self.CDS.Edit;
                Self.CDS.FieldByName('w_wono').AsString := FieldByName('w_wono').AsString;
                Self.CDS.FieldByName('w_qty').AsFloat := FieldByName('w_qty').AsFloat;
                Self.CDS.FieldByName('num').AsInteger := Self.CDS.FieldByName('num').AsInteger + 1;
                Self.CDS.FieldByName('iscreate').AsString := 'Y';
                Self.CDS.Post;
              end;
            end;
            Next;
          end;
        end;
        Self.CDS.MergeChangeLog;
      finally
        Self.CDS.EnableControls;
        Self.CDS.AfterScroll := dsNE;
        Self.CDS.AfterScroll(Self.CDS);
      end;

      //添加已產生工單記錄
      g_StatusBar.Panels[0].Text := CheckLang('正在添加日誌資料...');
      Application.ProcessMessages;
      if Length(tmpOrderno) > 0 then
      begin
        Delete(tmpOrderno, 1, 1);
        Data := null;
        tmpSQL := 'select * from mps015 where orderno in (' + tmpOrderno + ')';
        if l_isDG then
          tmpSQL := tmpSQL + ' and bu=''ITEQDG'''
        else
          tmpSQL := tmpSQL + ' and bu=''ITEQGZ''';
        if QueryBySQL(tmpSQL, Data) then
        begin
          tmpCDS2.Data := Data;

          with tmpCDS1 do
          begin
            First;
            while not Eof do
            begin
              if FieldByName('num').AsInteger = -1 then
              begin
                if tmpCDS2.Locate('orderno;orderitem', VarArrayOf([FieldByName('orderno').AsString, FieldByName('orderitem').AsString]), []) then
                begin
                  tmpCDS2.Edit;
                  tmpCDS2.FieldByName('wono').AsString := FieldByName('w_wono').AsString;
                  tmpCDS2.FieldByName('pno').AsString := FieldByName('l_pno').AsString;
                  tmpCDS2.FieldByName('qty').AsFloat := FieldByName('w_qty').AsFloat;
                  tmpCDS2.FieldByName('num').AsInteger := tmpCDS2.FieldByName('num').AsInteger + 1;
                  tmpCDS2.FieldByName('iscolor').AsBoolean := FieldByName('iscolor').AsBoolean;
                  tmpCDS2.FieldByName('muser').AsString := g_UInfo^.UserId;
                  tmpCDS2.FieldByName('mdate').AsDateTime := Now;
                  tmpCDS2.Post;
                end
                else
                begin
                  tmpCDS2.Append;
                  if l_isDG then
                    tmpCDS2.FieldByName('bu').AsString := 'ITEQDG'
                  else
                    tmpCDS2.FieldByName('bu').AsString := 'ITEQGZ';
                  tmpCDS2.FieldByName('orderno').AsString := FieldByName('orderno').AsString;
                  tmpCDS2.FieldByName('orderitem').AsInteger := FieldByName('orderitem').AsInteger;
                  tmpCDS2.FieldByName('wono').AsString := FieldByName('w_wono').AsString;
                  tmpCDS2.FieldByName('pno').AsString := FieldByName('l_pno').AsString;
                  tmpCDS2.FieldByName('qty').AsFloat := FieldByName('w_qty').AsFloat;
                  tmpCDS2.FieldByName('num').AsInteger := 1;
                  tmpCDS2.FieldByName('iscolor').AsBoolean := FieldByName('iscolor').AsBoolean;
                  tmpCDS2.FieldByName('iuser').AsString := g_UInfo^.UserId;
                  tmpCDS2.FieldByName('idate').AsDateTime := Now;
                  tmpCDS2.Post;
                end;
              end;
              Next;
            end;
          end;

          CDSPost(tmpCDS2, 'mps015');
        end;
      end;

      if not Assigned(FrmMPST130_WonoList) then
        FrmMPST130_WonoList := TFrmMPST130_WonoList.Create(Self);
      FrmMPST130_WonoList.Memo1.Text := '自動產生工單完畢,工單單號：' + tmpAllWono;
      FrmMPST130_WonoList.ShowModal;
    end
    else
    begin
      if not Assigned(FrmMPST130_WonoList) then
        FrmMPST130_WonoList := TFrmMPST130_WonoList.Create(Self);
      FrmMPST130_WonoList.Memo1.Text := '自動產生工單失敗,請檢查下列工單單號：' + tmpAllWono;
      FrmMPST130_WonoList.ShowModal;
    end;

  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST130.chkAllClick(Sender: TObject);
var
  tmpCDS: TClientDataSet;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (TCheckBox(Sender).Tag <> 0) then
    Exit;

  l_SelEdit := True;
  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;
    with tmpCDS do
    begin
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean := TCheckBox(Sender).Checked;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;

    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    CDS.Data := tmpCDS.Data;
  finally
    FreeAndNil(tmpCDS);
    l_SelEdit := False;
  end;
end;

procedure TFrmMPST130.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST130.CDSBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

//l_pno大料料號、w_wono工單號碼可編輯(手工建立工單再填寫這里)、w_wono雙擊工單號碼改變底色
procedure TFrmMPST130.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL, tmpDBType: string;
  Data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  inherited;
  if l_SelEdit then
    Exit;

  if l_isDG then
    tmpDBType := 'ITEQDG'
  else
    tmpDBType := 'ITEQGZ';
  tmpSQL := 'select * from mps015 where orderno=' + Quotedstr(CDS.FieldByName('orderno').AsString) + ' and orderitem=' + IntToStr(CDS.FieldByName('orderitem').AsInteger) + ' and bu=' + Quotedstr(tmpDBType);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    try
      tmpCDS.Data := Data;
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString := tmpDBType;
        tmpCDS.FieldByName('orderno').AsString := CDS.FieldByName('orderno').AsString;
        tmpCDS.FieldByName('orderitem').AsInteger := CDS.FieldByName('orderitem').AsInteger;
        tmpCDS.FieldByName('wono').Value := CDS.FieldByName('w_wono').Value;
        tmpCDS.FieldByName('pno').Value := CDS.FieldByName('l_pno').Value;
        tmpCDS.FieldByName('iscolor').AsBoolean := CDS.FieldByName('iscolor').AsBoolean;
        tmpCDS.FieldByName('iuser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime := Now;
      end
      else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('wono').Value := CDS.FieldByName('w_wono').Value;
        tmpCDS.FieldByName('pno').Value := CDS.FieldByName('l_pno').Value;
        tmpCDS.FieldByName('iscolor').AsBoolean := CDS.FieldByName('iscolor').AsBoolean;
        tmpCDS.FieldByName('muser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime := Now;
      end;
      tmpCDS.Post;

      CDSPost(tmpCDS, 'mps015');
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmMPST130.GetADate(Bu, Orderno, Orderitem: string; OrdWono: TOrderWono);
var
  s: string;
  data: OleVariant;
  tmpcds: TClientDataSet;
begin
  {(*}
  s:='select Adate,CDate from MPS200 where Bu=%s and Orderno=%s and Orderitem=%s';
  s:=Format(s,[QuotedStr(bu),
               QuotedStr(Orderno),
               QuotedStr(Orderitem)]);   {*)}
  if not QueryBySQL(s, data) then
    exit;
  tmpcds := TClientDataSet.Create(nil);
  try
    tmpcds.data := data;
    if tmpcds.IsEmpty then
      exit;
    if not tmpcds.Fields[1].IsNull then
      OrdWono.Adate := tmpcds.Fields[1].Value
    else if not tmpcds.Fields[0].IsNull then
      OrdWono.Adate := tmpcds.Fields[0].Value;
    //Cdata優先
  finally
    tmpcds.free;
  end;
end;

end.

