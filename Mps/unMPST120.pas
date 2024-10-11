{*******************************************************}
{                                                       }
{                unMPST120                              }
{                Author: kaikai                         }
{                Create date: 2020/9/21                 }
{                Description: �q������ʳ�              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST120;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI041, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls,
  ComCtrls, ToolWin, StrUtils, Buttons;

type
  TFrmMPST120 = class(TFrmSTDI041)
    btn_mpst120A: TToolButton;
    btn_mpst120B: TToolButton;
    chkAll: TCheckBox;
    PnlRight: TPanel;
    btn_mpsr120A: TBitBtn;
    btn_mpsr120B: TBitBtn;
    btn_mpsr120C: TBitBtn;
    Memo1: TMemo;
    btn_mpsr120D: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure btn_mpst120AClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor; State:
      TGridDrawState);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeDelete(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure btn_mpst120BClick(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_mpsr120AClick(Sender: TObject);
    procedure btn_mpsr120BClick(Sender: TObject);
    procedure btn_mpsr120CClick(Sender: TObject);
    procedure btn_mpsr120DClick(Sender: TObject);
  private
    l_isDG, l_SelEdit: Boolean;
    l_isCreate: Integer;
    l_gen03: string;
    l_CDS: TClientDataSet;
    l_list: TStrings;
    l_StrIndex, l_StrIndexDesc: string;
    l_img02All, l_img02Out: string;
    procedure GetDS(xFliter: string);
    procedure SetBtnEnabled(bool: Boolean);
    function CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS: TClientDataSet; pmk09: string): string;
    { Private declarations }
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST120: TFrmMPST120;

implementation

uses
  unGlobal, unCommon, unMPST120_Query, unFind, unMPST120_supplier, unMPST120_set, unCCLStruct;

const
  l_Xml = '<?xml version="1.0" standalone="yes"?>' + '<DATAPACKET Version="2.0">' + '<METADATA><FIELDS>' +
    '<FIELD attrname="select" fieldtype="boolean"/>' + '<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>' +
    '<FIELD attrname="custshort" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="orderdate" fieldtype="date"/>' +
    '<FIELD attrname="orderno" fieldtype="string" WIDTH="10"/>' + '<FIELD attrname="orderitem" fieldtype="i4"/>' +
    '<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>' + '<FIELD attrname="pname" fieldtype="string" WIDTH="200"/>'
    + '<FIELD attrname="sizes" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="c_orderno" fieldtype="string" WIDTH="50"/>' +
    '<FIELD attrname="oeb11" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="c_sizes" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="ta_oeb30" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="remark" fieldtype="string" WIDTH="200"/>' + '<FIELD attrname="longitude" fieldtype="r8"/>' +
    '<FIELD attrname="latitude" fieldtype="r8"/>' + '<FIELD attrname="struct" fieldtype="string" WIDTH="200"/>' +
    '<FIELD attrname="units" fieldtype="string" WIDTH="4"/>' + '<FIELD attrname="qty" fieldtype="r8"/>' +
    '<FIELD attrname="adate" fieldtype="datetime"/>' + '<FIELD attrname="p_pno" fieldtype="string" WIDTH="30"/>' +
    '<FIELD attrname="p_qty" fieldtype="r8"/>' + '<FIELD attrname="iscreate" fieldtype="string" WIDTH="1"/>' +
    '<FIELD attrname="isdomestic" fieldtype="string" WIDTH="1"/>' +
    '<FIELD attrname="ta_oeb39" fieldtype="string" WIDTH="20"/>'  //�O�s:���ʳ渹-����
    + '<FIELD attrname="ta_oeb04" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="ta_oea08" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="qty1" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="qty2" fieldtype="r8"/>' +
    '<FIELD attrname="qty3" fieldtype="r8"/>' + '<FIELD attrname="cno" fieldtype="string" WIDTH="20"/>' +
    '<FIELD attrname="sno" fieldtype="string" WIDTH="20"/>' + '<FIELD attrname="PurCno" fieldtype="string" WIDTH="20"/>'
    + '<FIELD attrname="PurSno" fieldtype="string" WIDTH="20"/>' + '</FIELDS><PARAMS/></METADATA>' +
    '<ROWDATA></ROWDATA>' + '</DATAPACKET>';

var
  DBType: string;
{$R *.dfm}

procedure TFrmMPST120.GetDS(xFliter: string);
var
  Data: OleVariant;
  tmpSQL, tmpOrderno, tmpDomestic: string;
  tmpCDS: TClientDataSet;
begin
  tmpOrderno := '';
  l_CDS.EmptyDataSet;
  chkAll.Tag := 1;
  chkAll.Checked := False;
  g_StatusBar.Panels[0].Text := '���b�d��...';
  Application.ProcessMessages;
  tmpCDS := TClientDataSet.Create(nil);
  try
    //���P��O
    tmpSQL := 'select top 1 id from mps014 where bu=''ITEQDG''';
    if not QueryOneCR(tmpSQL, Data) then
      Exit;
    tmpDomestic := VarToStr(Data);

    Data := null;      
    {(*}
    tmpSQL := 'select C.*,oao06 from (select B.*,ima021 from (select A.*,occ02 from' +
    ' (select oea01,oea02,oea04,oea10,oeb03,oeb04,oeb05,oeb06,ta_oeb39,pmn01,pmn02,' +
    ' oeb11,oeb12,oeb15,ta_oeb01,ta_oeb02,ta_oeb04,ta_oeb10,ta_oeb30,' +
    ' to_char(oea02,''YYYY/MM/DD'') q_oea02,' +
    ' case when ta_oea08=1 then ''�̼˫~�y�{�@�~'' when ta_oea08=2 then ''�L�ݨ̼˫~�y�{�@�~'' end ta_oea08 '+
    ' from oea_file inner join oeb_file on oea01=oeb01' +
    ' left join pmn_file on pmn24=substr(ta_oeb39,1,10) and pmn25=substr(ta_oeb39,12,10) ' +
    ' where oeaconf=''Y'' and nvl(oeb70,''N'')=''N'' and oeb12>0) A' +
    ' inner join occ_file on oea04=occ01 where 1=1 ' + xFliter + ' ) B left join ima_file on oeb04=ima01 ' +
    ' ) C left join oao_file on oea01=oao01 and oeb03=oao03 order by oea02,oea01,oeb03';
    {*)}
    if l_isDG then
    begin
      Memo1.Text := QuotedStr(tmpSQL);
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        tmpCDS.Data := Data
      else
        Exit;
    end
    else
    begin
      if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
        tmpCDS.Data := Data
      else
        Exit;
    end;

    with tmpCDS do
    begin
      if IsEmpty then
        Exit;
      while not Eof do
      begin
        if Pos(FieldByName('oea01').AsString, tmpOrderno) = 0 then
          tmpOrderno := tmpOrderno + ',' + Quotedstr(FieldByName('oea01').AsString);

        l_CDS.Append;
        l_CDS.FieldByName('select').AsBoolean := False;
        l_CDS.FieldByName('custno').AsString := FieldByName('oea04').AsString;
        l_CDS.FieldByName('Cno').AsString := Copy(FieldByName('ta_oeb39').AsString, 1, 10);
        l_CDS.FieldByName('Sno').AsString := Copy(FieldByName('ta_oeb39').AsString, 12, 10);
        l_CDS.FieldByName('PurCno').AsString := FieldByName('pmn01').AsString;
        l_CDS.FieldByName('PurSno').AsString := FieldByName('pmn02').AsString;
        l_CDS.FieldByName('custshort').AsString := FieldByName('occ02').AsString;
        l_CDS.FieldByName('orderdate').AsDateTime := FieldByName('oea02').AsDateTime;
        l_CDS.FieldByName('orderno').AsString := FieldByName('oea01').AsString;
        l_CDS.FieldByName('orderitem').AsInteger := FieldByName('oeb03').AsInteger;
        l_CDS.FieldByName('pno').AsString := FieldByName('oeb04').AsString;
        l_CDS.FieldByName('pname').AsString := FieldByName('oeb06').AsString;
        l_CDS.FieldByName('sizes').AsString := FieldByName('ima021').AsString;
        l_CDS.FieldByName('c_orderno').AsString := FieldByName('oea10').AsString;
        l_CDS.FieldByName('oeb11').AsString := FieldByName('oeb11').AsString;
        l_CDS.FieldByName('c_sizes').AsString := FieldByName('ta_oeb10').AsString;
        l_CDS.FieldByName('remark').AsString := FieldByName('oao06').AsString;
        l_CDS.FieldByName('longitude').AsString := FieldByName('ta_oeb01').AsString;
        l_CDS.FieldByName('latitude').AsString := FieldByName('ta_oeb02').AsString;
        l_CDS.FieldByName('ta_oeb04').AsString := FieldByName('ta_oeb04').AsString;
        l_CDS.FieldByName('ta_oea08').AsString := FieldByName('ta_oea08').AsString;
        l_CDS.FieldByName('units').AsString := FieldByName('oeb05').AsString;
        l_CDS.FieldByName('ta_oeb30').AsString := FieldByName('ta_oeb30').AsString;
        l_CDS.FieldByName('qty').AsFloat := FieldByName('oeb12').AsFloat;
        try
          l_CDS.FieldByName('adate').AsDateTime := FieldByName('oeb15').AsDateTime;
        except
          l_CDS.FieldByName('adate').Clear;
        end;
        l_CDS.FieldByName('iscreate').AsString := 'N';
        if Pos(Copy(FieldByName('oea01').AsString, 1, 3), tmpDomestic) > 0 then
          l_CDS.FieldByName('isdomestic').AsString := 'Y'
        else
          l_CDS.FieldByName('isdomestic').AsString := 'N';
        l_CDS.Post;

        Next;
      end;
    end;

    //��s���ʮƸ��B�ƶq�B�w���ͪ��q��
    if Length(tmpOrderno) > 0 then
    begin
      Delete(tmpOrderno, 1, 1);
      Data := null;
      tmpSQL := 'select orderno,orderitem,pno,qty,num from mps011 where orderno in (' + tmpOrderno + ')';
      if l_isDG then
        tmpSQL := tmpSQL + ' and bu=''ITEQDG'''
      else
        tmpSQL := tmpSQL + ' and bu=''ITEQGZ''';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;

      tmpCDS.Data := Data;
      if not tmpCDS.IsEmpty then
      begin
        l_CDS.First;
        while not l_CDS.Eof do
        begin
          if tmpCDS.Locate('orderno;orderitem', VarArrayOf([l_CDS.FieldByName('orderno').AsString, l_CDS.FieldByName('orderitem').AsInteger]),
            []) then
          begin
            l_CDS.Edit;
            l_CDS.FieldByName('p_pno').Value := tmpCDS.FieldByName('pno').Value;
            l_CDS.FieldByName('p_qty').Value := tmpCDS.FieldByName('qty').Value;
            if tmpCDS.FieldByName('num').AsInteger > 0 then
              l_CDS.FieldByName('iscreate').AsString := 'Y';
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

    if l_CDS.ChangeCount > 0 then
      l_CDS.MergeChangeLog;

    if l_isDG then
      SetCCLStruct(l_CDS, 'ITEQDG', 'pno', 'struct', 'ta_oeb04')
    else
      SetCCLStruct(l_CDS, 'ITEQGZ', 'pno', 'struct', 'ta_oeb04');

  finally
    FreeAndNil(tmpCDS);
    CDS.Data := l_CDS.Data;
    chkAll.Tag := 0;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST120.RefreshDS(strFilter: string);
begin
  if strFilter = g_cFilterNothing then
    CDS.Data := l_CDS.Data
  else
    GetDS(strFilter);
end;

procedure TFrmMPST120.FormCreate(Sender: TObject);
begin
  Memo1.Visible := SameText(g_UInfo^.UserId, 'ID150515');
  p_SysId := 'MPS';
  p_TableName := 'MPST120';
  p_GridDesignAns := True;
  btn_quit.Left := btn_mpst120A.Left + btn_mpst120A.Width;
  btn_mpst120A.Visible := g_MInfo^.R_edit;
  btn_mpst120B.Visible := g_MInfo^.R_edit;
  l_list := TStringList.Create;
  l_list.Delimiter := '-';
  l_CDS := TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_Xml);
  l_isCreate := 0;

  inherited;
  if g_uinfo^.BU = 'ITEQDG' then
    DBType := 'ORACLE'
  else if g_uinfo^.BU = 'ITEQGZ' then
    DBType := 'ORACLE1';
end;

procedure TFrmMPST120.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_list);
  FreeAndNil(l_CDS);
end;

procedure TFrmMPST120.btn_queryClick(Sender: TObject);
var
  str: string;
begin
//  inherited;
  if not Assigned(FrmMPST120_Query) then
    FrmMPST120_Query := TFrmMPST120_Query.Create(Application);
  if FrmMPST120_Query.ShowModal = mrOK then
  begin
    l_isCreate := FrmMPST120_Query.Rgp2.ItemIndex;
    l_isDG := FrmMPST120_Query.Rgp3.ItemIndex = 0;
    str := ' and q_oea02>=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmMPST120_Query.Dtp1.Date), '-',
      '/', [rfReplaceAll])) + ' and q_oea02<=' + Quotedstr(StringReplace(FormatDateTime(g_cShortDate1, FrmMPST120_Query.Dtp2.Date),
      '-', '/', [rfReplaceAll]));
    if Length(Trim(FrmMPST120_Query.Edit2.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST120_Query.Edit2.Text))) + ',oea01)>0';
    if Length(Trim(FrmMPST120_Query.Edit1.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST120_Query.Edit1.Text))) + ',oea04)>0';
    if Length(Trim(FrmMPST120_Query.Edit3.Text)) > 0 then
      str := str + ' and oeb04 like ' + Quotedstr(FrmMPST120_Query.Edit3.Text + '%');
    if Length(Trim(FrmMPST120_Query.Edit4.Text)) > 0 then
      str := str + ' and instr(' + Quotedstr(UpperCase(Trim(FrmMPST120_Query.Edit4.Text))) + ',substr(oeb04,2,1))>0';
    case FrmMPST120_Query.Rgp1.ItemIndex of
      0:
        str := str + ' and substr(oeb04,1,1) in (''E'',''T'',''H'')';
      1:
        str := str + ' and substr(oeb04,1,1) in (''B'',''R'',''M'',''N'')';
//      2:
//        str := str + ' and substr(oeb04,1,1) in (''B'',''R'',''M'',''N'',''E'',''T'',''H'')';
    end;

    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(str);
  end;
end;

procedure TFrmMPST120.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST120.CDSBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST120.CDSAfterPost(DataSet: TDataSet);
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
  tmpSQL := 'select * from mps011 where orderno=' + Quotedstr(CDS.FieldByName('orderno').AsString) + ' and orderitem=' +
    IntToStr(CDS.FieldByName('orderitem').AsInteger) + ' and bu=' + Quotedstr(tmpDBType);
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
        tmpCDS.FieldByName('pno').Value := CDS.FieldByName('p_pno').Value;
        tmpCDS.FieldByName('qty').Value := CDS.FieldByName('p_qty').Value;
        tmpCDS.FieldByName('num').AsInteger := 0;
        tmpCDS.FieldByName('iuser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime := Now;
      end
      else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('pno').Value := CDS.FieldByName('p_pno').Value;
        tmpCDS.FieldByName('qty').Value := CDS.FieldByName('p_qty').Value;
        tmpCDS.FieldByName('muser').AsString := g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime := Now;
      end;
      tmpCDS.Post;

      CDSPost(tmpCDS, 'mps011');
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmMPST120.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST120.DBGridEh1CellClick(Column: TColumnEh);
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

procedure TFrmMPST120.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
    Exit;

  if SameText(Column.FieldName, 'iscreate') then
    if CDS.FieldByName('iscreate').AsString = 'N' then
      Background := clRed;
end;

procedure TFrmMPST120.DBGridEh1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if (Shift = [ssCtrl]) and (Key = 70) then               //Ctrl+F �d��
  begin
    if not Assigned(FrmFind) then
      FrmFind := TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS := Self.CDS;
      g_Columns := Self.DBGridEh1.Columns;
      g_DefFname := Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname := 'select,orderitem,longitude,latitude,qty,iscreate,isdomestic';
    end;
    FrmFind.ShowModal;
    Key := 0; //DBGridEh�۱a���d��
  end;
end;

procedure TFrmMPST120.btn_mpst120AClick(Sender: TObject);
var
  tmpSQL, tmpDBType, tmpPMK01, tmpPMK02, tmpPMK09: string;
  tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, genCDS: TClientDataSet;
  Data: OleVariant;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('����ܥ�����!', 48);
    Exit;
  end;

  tmpCDS := TClientDataSet.Create(nil);
  oebCDS := TClientDataSet.Create(nil);
  pmkCDS := TClientDataSet.Create(nil);
  pmlCDS := TClientDataSet.Create(nil);
  tc_pmlCDS := TClientDataSet.Create(nil);
  genCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := CDS.Data;

    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'select=1';
    tmpCDS.Filtered := True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('����ܥ�����!', 48);
      Exit;
    end;

    if tmpCDS.RecordCount > 200 then
    begin
      ShowMsg('�̦h�i��200��,�Э��s���!', 48);
      Exit;
    end;

    tmpSQL := '';
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      if not tmpCDS.FieldByName('p_qty').IsNull then
        if tmpCDS.FieldByName('p_qty').AsFloat <= 0 then
        begin
          ShowMsg('���ʼƶq���i�p�_0', 48);
          Exit;
        end;
      tmpSQL := tmpSQL + ' or (oeb01=' + Quotedstr(tmpCDS.FieldByName('orderno').AsString) + ' and oeb03=' + IntToStr(tmpCDS.FieldByName
        ('orderitem').AsInteger) + ')';
      tmpCDS.Next;
    end;

    if tmpCDS.Locate('iscreate', 'Y', []) then
    begin
      if ShowMsg('�s�b�w���ͽ��ʳ檺���' + #13#10 + '�T�w�~�򲣥ͽ��ʳ��?', 33) = IdCancel then
        Exit;
    end;

    if not Assigned(FrmMPST120_supplier) then
      FrmMPST120_supplier := TFrmMPST120_supplier.Create(Application);
    if FrmMPST120_supplier.ShowModal <> mrOK then
      Exit;

    tmpPMK09 := FrmMPST120_supplier.Rgp1.Items.Strings[FrmMPST120_supplier.Rgp1.ItemIndex];
    tmpPMK09 := Copy(tmpPMK09, 1, 4);

    if l_isDG then
      tmpDBType := 'ORACLE'
    else
      tmpDBType := 'ORACLE1';

    //�q����
    g_StatusBar.Panels[0].Text := CheckLang('���b�d�߭q����...');
    Application.ProcessMessages;
    Delete(tmpSQL, 1, 3);
    Data := null;      
    {(*}
    tmpSQL := '  select j.*,pml20 from '+
              ' (select u.*,sfb08 from'+
              ' (select t.*,oao06 from' +
              ' (select z.*,ima02,ima25 from' +
              ' (select y.*,occ02 from' +
              ' (select x.*,oea04 from' +
              ' (select * from oeb_file where ' + tmpSQL + ') x,oea_file' +
              ' where oeb01=oea01) y,occ_file where oea04=occ01) z,ima_file where oeb04=ima01) t' +
              ' left join oao_file on oeb01=oao01 and oeb03=oao03)u' +
                ' left join (select sfb22,sfb221,sum(sfb08)sfb08 from sfb_file group by sfb22,sfb221)j on oeb01=sfb22 and oeb03=sfb221)j '
                +
                ' left join (select pml06,sum(pml20)pml20 from pml_file,pmk_file where pml01=pmk01 and pmkacti=''Y'' group by pml06)k on pml06||'' '' like oeb01||''-''||oeb03||'' %'' '
                ;
    {*)}
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
      Exit;
    oebCDS.Data := Data;

    //�ˬd�q��O�_�s�b
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL := '[' + tmpCDS.FieldByName('orderno').AsString + '/' + tmpCDS.FieldByName('orderitem').AsString + ']';

      if not oebCDS.Locate('oeb01;oeb03', VarArrayOf([tmpCDS.FieldByName('orderno').AsString, tmpCDS.FieldByName('orderitem').AsInteger]),
        []) then
      begin
        ShowMsg(tmpSQL + '�q�椣�s�b!', 48);
        Exit;
      end;

      tmpCDS.Next;
    end;

    if Length(l_gen03) = 0 then
    begin
      //�����s��
      g_StatusBar.Panels[0].Text := CheckLang('���b�d�߳����s��...');
      Application.ProcessMessages;
      Data := null;
      tmpSQL := 'select gen03 from gen_file where gen01=' + Quotedstr(UpperCase(g_UInfo^.UserId));

      if not QueryBySQL(tmpSQL, Data, tmpDBType) then
        Exit;
      genCDS.Data := Data;
      //*

      if not genCDS.IsEmpty then
        l_gen03 := genCDS.Fields[0].AsString;

      if Length(l_gen03) = 0 then
      begin
        ShowMsg('�L�����s��,�нT�{!', 48);
        Exit;
      end;
    end;

    //���ʳ�
    g_StatusBar.Panels[0].Text := CheckLang('���b�d�߽��ʳ���...');
    Application.ProcessMessages;
    Data := null;
    tmpSQL := 'select * from pmk_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
      Exit;
    pmkCDS.Data := Data;

    Data := null;
    tmpSQL := 'select * from pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
      Exit;
    pmlCDS.Data := Data;

    Data := null;
    tmpSQL := 'select * from tc_pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
      Exit;
    tc_pmlCDS.Data := Data;
    //*
    //���P
    g_StatusBar.Panels[1].Text := CheckLang('���b���ͤ��P���ʳ�...');
    Application.ProcessMessages;
    tmpPMK01 := '';
    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'select=1 and isdomestic=''Y''';
    tmpCDS.Filtered := True;
    if not tmpCDS.IsEmpty then
    begin
      tmpPMK01 := CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, tmpPMK09);
      if Length(tmpPMK01) = 0 then
        Exit;
    end;

    //�~�P
    g_StatusBar.Panels[1].Text := CheckLang('���b���ͥ~�P���ʳ�...');
    Application.ProcessMessages;
    tmpPMK02 := '';
    pmkCDS.EmptyDataSet;
    pmlCDS.EmptyDataSet;
    tc_pmlCDS.EmptyDataSet;
    tmpCDS.Filtered := False;
    tmpCDS.Filter := 'select=1 and isdomestic=''N''';
    tmpCDS.Filtered := True;
    if not tmpCDS.IsEmpty then
      tmpPMK02 := CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, tmpPMK09);
    g_StatusBar.Panels[1].Text := '';
    Application.ProcessMessages;

    if Length(tmpPMK02) > 0 then
      if Length(tmpPMK01) > 0 then
        tmpPMK01 := tmpPMK01 + ',' + tmpPMK02
      else
        tmpPMK01 := tmpPMK02;
    if Length(tmpPMK01) > 0 then
      ShowMsg('���槹��,���ʳ渹:' + tmpPMK01, 64);
  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(oebCDS);
    FreeAndNil(pmkCDS);
    FreeAndNil(pmlCDS);
    FreeAndNil(tc_pmlCDS);
    FreeAndNil(genCDS);
    g_StatusBar.Panels[0].Text := '';
    g_StatusBar.Panels[1].Text := '';
  end;
end;

//��^���ʳ渹
function TFrmMPST120.CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS: TClientDataSet; pmk09: string): string;
var
  tmpSQL, tmpDBType, tmpPMK01, tmpFilter, msg: string;
  tmpCDS1, tmpCDS2: TClientDataSet;
  Data: OleVariant;
begin
  Result := '';

  tmpFilter := '';
  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    if not oebCDS.Locate('oeb01;oeb03', VarArrayOf([sourceCDS.FieldByName('orderno').AsString, sourceCDS.FieldByName('orderitem').AsInteger]),
      []) then
    begin
      ShowMsg('[' + sourceCDS.FieldByName('orderno').AsString + '/' + sourceCDS.FieldByName('orderitem').AsString +
        ']�q�椣�s�b!', 48);
      Exit;
    end;

    //pmlCDS���ʳ�樭
    pmlCDS.Append;
    pmlCDS.FieldByName('pml01').AsString := '?';                                        //�渹
    pmlCDS.FieldByName('pml02').AsInteger := pmlCDS.RecordCount + 1;                      //����
    if Length(Trim(sourceCDS.FieldByName('p_pno').AsString)) > 0 then
      pmlCDS.FieldByName('pml04').AsString := sourceCDS.FieldByName('p_pno').AsString  //�Ƹ�
    else
      pmlCDS.FieldByName('pml04').AsString := oebCDS.FieldByName('oeb04').AsString;
    pmlCDS.FieldByName('pml041').AsString := oebCDS.FieldByName('ima02').AsString;      //�~�W
    if SameText(pmk09, 'N005') or SameText(pmk09, 'N012') then
      //�Ƶ�:�F��B�s�{���ʵL�Ȥ�s��+²�١A�O�W�B�L���B������ʦ��Ȥ�s��+²��
    begin
      pmlCDS.FieldByName('pml06').AsString := oebCDS.FieldByName('oeb01').AsString + '-' + oebCDS.FieldByName('oeb03').AsString;
      pmlCDS.FieldByName('pml011').AsString := 'TAP';                                   //��کʽ�:TAP�h���N����
    end
    else
    begin
      pmlCDS.FieldByName('pml06').AsString := oebCDS.FieldByName('oeb01').AsString + '-' + oebCDS.FieldByName('oeb03').AsString
        + ' ' + oebCDS.FieldByName('oea04').AsString + '-' + oebCDS.FieldByName('occ02').AsString;
      pmlCDS.FieldByName('pml011').AsString := 'REG';                                   //��کʽ�:REG�쪫��
    end;

    //�⨤�q��Ƶ�pml06�אּ:��l�q��-�Ȥ�
    //oao06�榡:�Ȥ�s��-��O-�y����-����
    if (Pos(Copy(oebCDS.FieldByName('oeb01').AsString, 1, 3), 'P1T,P1N,P1Y,P1Z,P2N,P2Y,P2Z') > 0) and (Length(oebCDS.FieldByName
      ('oao06').AsString) > 0) then
    begin
      l_list.DelimitedText := oebCDS.FieldByName('oao06').AsString;
      if l_list.Count = 4 then
      begin
        if SameText(pmk09, 'N005') or SameText(pmk09, 'N012') then
          pmlCDS.FieldByName('pml06').AsString := l_list.Strings[1] + '-' + l_list.Strings[2] + '-' + l_list.Strings[3]
        else
        begin
          pmlCDS.FieldByName('pml06').AsString := l_list.Strings[1] + '-' + l_list.Strings[2] + '-' + l_list.Strings[3]
            + ' ' + l_list.Strings[0] + '-';
          pmlCDS.FieldByName('pml12').AsString := l_list.Strings[0];
            //�M�ץN��(����줣�ϥ�),�o���Ȧs���Ȥ�s��,�Z����s�Ȥ�²�٦Z�A�M��
          tmpFilter := tmpFilter + ',' + Quotedstr(l_list.Strings[0]);
        end;
      end;
    end;

    if Length(pmlCDS.FieldByName('pml04').AsString) in [11, 12, 19, 20] then
      //���B�w�s���ima25�B����ഫ�v
    begin
      pmlCDS.FieldByName('pml07').AsString := 'PN';
      pmlCDS.FieldByName('pml08').AsString := 'PN';
      pmlCDS.FieldByName('pml09').AsFloat := 1;
    end
    else if Length(pmlCDS.FieldByName('pml04').AsString) = 18 then
    begin
      pmlCDS.FieldByName('pml07').AsString := 'RL';
      pmlCDS.FieldByName('pml08').AsString := 'M';
      pmlCDS.FieldByName('pml09').AsFloat := StrToInt(Copy(pmlCDS.FieldByName('pml04').AsString, 11, 3));
    end
    else
    begin
      pmlCDS.FieldByName('pml07').AsString := 'SH';
      pmlCDS.FieldByName('pml08').AsString := 'SH';
      pmlCDS.FieldByName('pml09').AsFloat := 1;
    end;
    pmlCDS.FieldByName('pml11').AsString := 'N';                                        //�ᵲ�X
    pmlCDS.FieldByName('pml121').AsInteger := 0;                                        //�M�ץN��-����
    pmlCDS.FieldByName('pml122').AsInteger := 0;                                        //�M�ץN��-����
    pmlCDS.FieldByName('pml13').AsFloat := 0;                                           //���\�i�W��/�u��ƶq��v
    pmlCDS.FieldByName('pml14').AsString := 'Y';                                        //������f�_
    pmlCDS.FieldByName('pml15').AsString := 'Y';                                        //���e��f�_
    pmlCDS.FieldByName('pml16').AsString := '1';                                        //���p�X:0�}��,1�֭�
    pmlCDS.FieldByName('pml18').AsDateTime := EncodeDate(1899, 12, 31);                   //MRP�ݨD���
    if oebCDS.FieldByName('sfb08').AsFloat >0 then
    begin
      msg := '[' + sourceCDS.FieldByName('orderno').AsString + '/' + sourceCDS.FieldByName('orderitem').AsString +
        ']�u��Ͳ��ƶq�j��0,�O�_���L?';
      case Application.MessageBox(pchar(msg), '����', MB_YESNOCANCEL + MB_ICONQUESTION) of
        IDNO:
          begin
            pmlCDS.Cancel;
            sourceCDS.Next;
            Continue;
          end;
        IDCANCEL:
          exit;
      end;
    end;

    if not sourceCDS.FieldByName('p_qty').IsNull then
        pmlCDS.FieldByName('pml20').AsFloat := sourceCDS.FieldByName('p_qty').AsFloat - oebCDS.FieldByName('pml20').AsFloat
          - oebCDS.FieldByName('sfb08').AsFloat    //���ʶq
      else
        pmlCDS.FieldByName('pml20').AsFloat := oebCDS.FieldByName('oeb12').AsFloat - oebCDS.FieldByName('sfb08').AsFloat -
          oebCDS.FieldByName('pml20').AsFloat;

    if pmlCDS.FieldByName('pml20').AsFloat <= 0 then
    begin
      msg := '[' + sourceCDS.FieldByName('orderno').AsString + '/' + sourceCDS.FieldByName('orderitem').AsString +
        ']�W�X�q��ƶq,�O�_���L?';
      case Application.MessageBox(pchar(msg), '����', MB_YESNOCANCEL + MB_ICONQUESTION) of
        IDNO:
          begin
            pmlCDS.Cancel;
            sourceCDS.Next;
            Continue;
          end;
        IDCANCEL:
          exit;
      end;
    end;
    pmlCDS.FieldByName('pml21').AsFloat := 0;                                           //�w����ʶq
    pmlCDS.FieldByName('pml23').AsString := 'Y';                                        //�ҵ|�_
    pmlCDS.FieldByName('pml30').AsFloat := 0;                                           //�����зǻ���
    pmlCDS.FieldByName('pml31').AsFloat := 0;                                           //���|���
    pmlCDS.FieldByName('pml31t').AsFloat := 0;                                          //�t�|���
    pmlCDS.FieldByName('pml32').AsFloat := 0;                                           //���ʻ��t
    pmlCDS.FieldByName('pml33').AsDateTime := sourceCDS.FieldByName('adate').AsDateTime; //Date + 7;                                 //��f���
    pmlCDS.FieldByName('pml34').AsDateTime := pmlCDS.FieldByName('pml33').AsDateTime;   //��t���
    pmlCDS.FieldByName('pml35').AsDateTime := pmlCDS.FieldByName('pml33').AsDateTime;   //��w���
    pmlCDS.FieldByName('pml38').AsString := 'Y';                                        //�i��/���i��
    pmlCDS.FieldByName('pml42').AsString := '0';                                        //���N�X0:��l�ƥ�,���i�Q���N
    pmlCDS.FieldByName('pml43').AsInteger := 0;                                         //�@�~�Ǹ�
    pmlCDS.FieldByName('pml431').AsInteger := 0;                                        //�U�@���@�~�Ǹ�
    pmlCDS.FieldByName('pml67').AsString := l_gen03;                                    //�����s��
    pmlCDS.Post;
    //*
    //�O�s���ʮƸ��B�ƶq
    sourceCDS.Edit;
    sourceCDS.FieldByName('p_pno').AsString := pmlCDS.FieldByName('pml04').AsString;
    sourceCDS.FieldByName('p_qty').AsFloat := pmlCDS.FieldByName('pml20').AsFloat;
    sourceCDS.Post;

    //�X�i���
    tc_pmlCDS.Append;
    //tc_pmlCDS.FieldByName('tc_pml03').AsString:='1' //��� 1.MM 2.INCH  ���|�B�z,���ޤF
    if Length(pmlCDS.FieldByName('pml04').AsString) in [11, 12, 19, 20] then
    begin
      tc_pmlCDS.FieldByName('tc_pml03').AsString := '2';
      tc_pmlCDS.FieldByName('tc_pml01').AsFloat := oebCDS.FieldByName('ta_oeb01').AsFloat;      //�g��
      tc_pmlCDS.FieldByName('tc_pml02').AsFloat := oebCDS.FieldByName('ta_oeb02').AsFloat;      //�n��
      tc_pmlCDS.FieldByName('tc_pml04').AsString := oebCDS.FieldByName('ta_oeb04').AsString;    //CCL�ؤo�N�X
      tc_pmlCDS.FieldByName('tc_pml05').AsString := oebCDS.FieldByName('ta_oeb05').AsString;   //�����X
      tc_pmlCDS.FieldByName('tc_pml06').AsString := oebCDS.FieldByName('ta_oeb06').AsString;   //�ɺ�X
      tc_pmlCDS.FieldByName('tc_pml07').AsString := oebCDS.FieldByName('ta_oeb07').AsString;    //���Ť覡
      tc_pmlCDS.FieldByName('tc_pml08').AsInteger := oebCDS.FieldByName('ta_oeb08').AsInteger;  //�ֵ�
      tc_pmlCDS.FieldByName('tc_pml09').AsString := oebCDS.FieldByName('ta_oeb09').AsString;   //�ɨ�
    end;

    tc_pmlCDS.FieldByName('tc_pml10').AsString := '?';   //���ʳ渹
    tc_pmlCDS.FieldByName('tc_pml11').AsInteger := tc_pmlCDS.RecordCount + 1;  //���ʳ涵��
    tc_pmlCDS.Post;
    //*

    sourceCDS.Next;
  end;

  //pmlCDS���ʳ���Y
  pmkCDS.Append;
  pmkCDS.FieldByName('pmk01').AsString := '?';                                     //�渹
  if SameText(pmk09, 'N005') or SameText(pmk09, 'N012') then
    pmkCDS.FieldByName('pmk02').AsString := 'TAP'                                 //��کʽ�:TAP�h���N����
  else
    pmkCDS.FieldByName('pmk02').AsString := 'REG';                                //��کʽ�:REG�쪫��
  pmkCDS.FieldByName('pmk03').AsInteger := 0;                                      //������ʧǸ�
  pmkCDS.FieldByName('pmk04').AsDateTime := Date;                                  //���ʤ��
  pmkCDS.FieldByName('pmk09').AsString := pmk09;                                   //������
  pmkCDS.FieldByName('pmk12').AsString := UpperCase(g_UInfo^.UserId);              //���ʭ�
  pmkCDS.FieldByName('pmk13').AsString := l_gen03;                                 //���ʳ���
  pmkCDS.FieldByName('pmk14').AsString := l_gen03;                                 //���f����
  pmkCDS.FieldByName('pmk15').AsString := pmkCDS.FieldByName('pmk12').AsString;    //���f�T�{�H
  pmkCDS.FieldByName('pmk18').AsString := 'Y';                                     //�T�{�_
  pmkCDS.FieldByName('pmk25').AsString := '1';                                     //0:�}��,1:�֭�
  pmkCDS.FieldByName('pmk27').AsDateTime := Date;                                  //���p���ʤ��
  pmkCDS.FieldByName('pmk30').AsString := 'Y';                                     //���f��C�L�_
  pmkCDS.FieldByName('pmk40').AsFloat := 0;                                        //����
  pmkCDS.FieldByName('pmk401').AsFloat := 0;                                       //����
  pmkCDS.FieldByName('pmk42').AsFloat := 1;                                        //�ײv
  pmkCDS.FieldByName('pmk43').AsFloat := 0;                                        //�|�v
  pmkCDS.FieldByName('pmk45').AsString := 'Y';                                     //�i��/���i��
  pmkCDS.FieldByName('pmkprno').AsInteger := 0;                                    //�C�L����
  pmkCDS.FieldByName('pmkmksg').AsString := 'N';                                   //�O�_ñ��
  pmkCDS.FieldByName('pmkdays').AsInteger := 0;                                    //ñ�֧����Ѽ�
  pmkCDS.FieldByName('pmksseq').AsInteger := 0;                                    //�wñ�ֶ���
  pmkCDS.FieldByName('pmksmax').AsInteger := 0;                                    //��ñ�ֶ���
  pmkCDS.FieldByName('pmkacti').AsString := 'Y';                                   //��Ʀ��ĽX
  pmkCDS.FieldByName('pmkuser').AsString := pmkCDS.FieldByName('pmk12').AsString;  //��ƩҦ���
  pmkCDS.FieldByName('pmkgrup').AsString := l_gen03;                               //��ƩҦ�����
  pmkCDS.Post;
  //*
  //��s�⨤�q����ʳƵ�:�Ȥ�²��
  if Length(tmpFilter) > 0 then
  begin
    if l_isDG then
      tmpDBType := 'iteqgz'
    else
      tmpDBType := 'iteqdg';

    Delete(tmpFilter, 1, 1);
    Data := null;
    tmpSQL := 'select occ01,occ02 from ' + tmpDBType + '.occ_file where occ01 in (' + tmpFilter + ')';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      Exit;

    tmpCDS1 := TClientDataSet.Create(nil);
    try
      tmpCDS1.Data := Data;

      pmlCDS.First;
      while not pmlCDS.Eof do
      begin
        if Length(pmlCDS.FieldByName('pml12').AsString) > 0 then
        begin
          pmlCDS.Edit;
          if tmpCDS1.Locate('occ01', pmlCDS.FieldByName('pml12').AsString, []) then
            if Pos(pmk09, 'N005,N012') = 0 then
              pmlCDS.FieldByName('pml06').AsString := pmlCDS.FieldByName('pml06').AsString + tmpCDS1.FieldByName('occ02').AsString;
          pmlCDS.FieldByName('pml12').Clear;
          pmlCDS.Post;
        end;
        pmlCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS1);
    end;
  end;
  //*

  if l_isDG then
    tmpDBType := 'ORACLE'
  else
    tmpDBType := 'ORACLE1';

  //��s���ʳ渹
  g_StatusBar.Panels[0].Text := CheckLang('���b�p����ʳ�y����...');
  Application.ProcessMessages;
  if SameText(pmk09, 'N023') then   //TW
  begin
    if sourceCDS.FieldByName('isdomestic').AsString = 'Y' then //���P
      tmpPMK01 := '31E-' + GetYM     //31E
    else
      tmpPMK01 := '313-' + GetYM;    //313
  end
  else if sourceCDS.FieldByName('isdomestic').AsString = 'Y' then
    tmpPMK01 := '317-' + GetYM       //317
  else
    tmpPMK01 := '313-' + GetYM;      //313
  //tmpPMK01:='XXX-'+GetYM;         //���ճ�O
  Data := null;
  tmpSQL := 'select nvl(max(pmk01),'''') as pmk01 from pmk_file' + ' where pmk01 like ''' + tmpPMK01 + '%''';
  if not QueryOneCR(tmpSQL, Data, tmpDBType) then
    Exit;
  tmpPMK01 := GetNewNo(tmpPMK01, VarToStr(Data));

  sourceCDS.First;
  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    pmlCDS.Edit;
    pmlCDS.FieldByName('pml01').AsString := tmpPMK01;
    pmlCDS.Post;

    sourceCDS.Edit;
    sourceCDS.FieldByName('ta_oeb39').AsString := tmpPMK01 + '-' + IntToStr(pmlCDS.FieldByName('pml02').AsInteger);
      //�Z����s�q����ta_oeb39
    sourceCDS.Post;

    pmlCDS.Next;
    sourceCDS.Next;
  end;

  tc_pmlCDS.First;
  while not tc_pmlCDS.Eof do
  begin
    tc_pmlCDS.Edit;
    tc_pmlCDS.FieldByName('tc_pml10').AsString := tmpPMK01;
    tc_pmlCDS.Post;
    tc_pmlCDS.Next;
  end;

  pmkCDS.Edit;
  pmkCDS.FieldByName('pmk01').AsString := tmpPMK01;
  pmkCDS.Post;
  //*
  //�x�s
  g_StatusBar.Panels[0].Text := CheckLang('���b�x�s���...');
  Application.ProcessMessages;
  if not CDSPost(pmkCDS, 'pmk_file', tmpDBType) then
    Exit;

  if not CDSPost(pmlCDS, 'pml_file', tmpDBType) then
  begin
    ShowMsg('�樭����x�s����' + #13#10 + '�жi�Jtiptop�i��@�o�B�z,�渹:' + tmpPMK01, 48);
    Exit;
  end;

  if not CDSPost(tc_pmlCDS, 'tc_pml_file', tmpDBType) then
  begin
    ShowMsg('�X�i����x�s����' + #13#10 + '�жi�Jtiptop�i��@�o�B�z,�渹:' + tmpPMK01, 48);
    Exit;
  end;

  //��soeb_file,ta_oeb39���ʳ渹
  g_StatusBar.Panels[0].Text := CheckLang('���b��s�q���ɽ��ʳ渹...');
  Application.ProcessMessages;

  tmpFilter := '';
  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    tmpSQL := 'update oeb_file set ta_oeb39=' + Quotedstr(sourceCDS.FieldByName('ta_oeb39').AsString) + ' where oeb01='
      + Quotedstr(sourceCDS.FieldByName('orderno').AsString) + ' and oeb03=' + IntToStr(sourceCDS.FieldByName('orderitem').AsInteger);
    if not PostBySQL(tmpSQL, tmpDBType) then
    begin
      ShowMsg('��s�q���ɽ��ʳ渹����' + #13#10 + '�жi�Jtiptop�i��@�o�B�z,�渹:' + tmpPMK01, 48);
      Exit;
    end;

    tmpFilter := tmpFilter + ' or (orderno=' + Quotedstr(sourceCDS.FieldByName('orderno').AsString) + ' and orderitem='
      + IntToStr(sourceCDS.FieldByName('orderitem').AsInteger) + ')';

    sourceCDS.Next;
  end;

  //�K�[�w���ͽ��ʳ�O��
  g_StatusBar.Panels[0].Text := CheckLang('���b�K�[��x���...');
  Application.ProcessMessages;

  if l_isDG then
    tmpDBType := 'ITEQDG'
  else
    tmpDBType := 'ITEQGZ';
  Delete(tmpFilter, 1, 3);
  Data := null;
  tmpSQL := 'select * from mps011 where (' + tmpFilter + ') and bu=' + Quotedstr(tmpDBType);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS2 := TClientDataSet.Create(nil);
    try
      tmpCDS2.Data := Data;

      sourceCDS.First;
      while not sourceCDS.Eof do
      begin
        if tmpCDS2.Locate('orderno;orderitem', VarArrayOf([sourceCDS.FieldByName('orderno').AsString, sourceCDS.FieldByName
          ('orderitem').AsInteger]), []) then
        begin
          tmpCDS2.Edit;
          tmpCDS2.FieldByName('pno').Value := sourceCDS.FieldByName('p_pno').Value;
          tmpCDS2.FieldByName('qty').Value := sourceCDS.FieldByName('p_qty').Value;
          tmpCDS2.FieldByName('num').AsInteger := tmpCDS2.FieldByName('num').AsInteger + 1;
          tmpCDS2.FieldByName('muser').AsString := g_UInfo^.UserId;
          tmpCDS2.FieldByName('mdate').AsDateTime := Now;
        end
        else
        begin
          tmpCDS2.Append;
          tmpCDS2.FieldByName('bu').AsString := tmpDBType;
          tmpCDS2.FieldByName('orderno').AsString := sourceCDS.FieldByName('orderno').AsString;
          tmpCDS2.FieldByName('orderitem').AsInteger := sourceCDS.FieldByName('orderitem').AsInteger;
          tmpCDS2.FieldByName('pno').Value := sourceCDS.FieldByName('p_pno').Value;
          tmpCDS2.FieldByName('qty').Value := sourceCDS.FieldByName('p_qty').Value;
          tmpCDS2.FieldByName('num').AsInteger := 1;
          tmpCDS2.FieldByName('iuser').AsString := g_UInfo^.UserId;
          tmpCDS2.FieldByName('idate').AsDateTime := Now;
        end;
        tmpCDS2.Post;
        sourceCDS.Next;
      end;

      CDSPost(tmpCDS2, 'mps011');
    finally
      FreeAndNil(tmpCDS2);
    end;
  end;

  g_StatusBar.Panels[0].Text := '';
  Application.ProcessMessages;

  Result := tmpPMK01;
end;

procedure TFrmMPST120.btn_mpst120BClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPST120_set) then
    FrmMPST120_set := TFrmMPST120_set.Create(Application);
  FrmMPST120_set.ShowModal;
end;

procedure TFrmMPST120.chkAllClick(Sender: TObject);
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

procedure TFrmMPST120.btn_exportClick(Sender: TObject);
var
  tmpCds: TClientDataSet;
begin
  tmpCds := TClientDataSet.Create(nil);
  try
    tmpCds.Data := CDS.Data;
    tmpCds.Filtered := False;
    tmpCds.Filter := 'select=1';
    tmpCds.Filtered := true;
    if tmpCds.IsEmpty then
    begin
      inherited;
      exit;
    end;
    tmpCds.Filtered := False;
    tmpCds.Last;
    while not tmpCds.Bof do
    begin
      if not tmpCds.FieldByName('select').asboolean then
        tmpCds.Delete
      else
        tmpCds.Prior;
    end;
    GetExportXls(tmpCds, p_TableName);
  finally
    tmpCds.free;
  end;
end;

procedure TFrmMPST120.btn_mpsr120AClick(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //��e�B�}�l�B����
  qty1, qty2: Double;
  Data: OleVariant;
  tmpStr, tmpSQL: string;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('�L�ƾ�,���i�ާ@!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['qty1'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('�Ш���[�w�s�q]���ƧǼаO,�A���榹�ާ@!', 48);
    Exit;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('��s�����Ы�[�O]' + #13#10 + '��s��e�o���Ы�[�_]' + #13#10 + '�L�ާ@�Ы�[����]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    //���w�O
    if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
    begin
      tmpSQL := 'Select Depot,lst,fst From MPS330 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And (lst=1 or fst=1)';
      if not QueryBySQL(tmpSQL, Data) then
        Exit;
      tmpCDS.Data := Data;
      with tmpCDS do
        while not Eof do
        begin
          if Fields[1].AsBoolean then        //�`�w�s
            l_img02All := l_img02All + ',' + Quotedstr(Fields[0].AsString);
          if Fields[2].AsBoolean then        //���Įw�s
            l_img02Out := l_img02Out + Fields[0].AsString + '/';
          Next;
        end;
      if (Length(l_img02All) = 0) and (Length(l_img02Out) = 0) then
      begin
        ShowMsg('MPS330�L�w�O,�нT�{!', 48);
        Exit;
      end;
      Delete(l_img02All, 1, 1);
      l_img02All := ' And img02 in (' + l_img02All + ')';
    end;
    //***

    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := CDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := ' or img01 like ' + Quotedstr(Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString)
          - 1) + '%')
      else
      begin
        while not CDS.Eof do
        begin
          tmpStr := Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString) - 1);
          if Pos(tmpStr, tmpSQL) = 0 then
            tmpSQL := tmpSQL + ' or img01 like ' + Quotedstr(tmpStr + '%');
          tmpERecNo := CDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //�C����50���Ƹ��d�߮w�s
            Break;
          CDS.Next;
        end;
      end;

      g_StatusBar.Panels[0].Text := CheckLang('���b�B�z' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '��');
      Application.ProcessMessages;
      Data := null;            //img01_1�h�����X
      if l_isDG then
        tmpSQL := 'Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1' +
          ' From ITEQDG.img_file Where (img01=''@''' + tmpSQL + ')' + l_img02All + ' And img10>0' + ' Union All' +
          ' Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1' +
          ' From ITEQGZ.img_file Where (img01=''@''' + tmpSQL + ')' + l_img02All + ' And img10>0'
      else
        tmpSQL := 'Select img01,img02,img10,ta_img03,substr(img01,1,length(img01)-1) img01_1' + ' From ' + g_UInfo^.BU +
          '.img_file Where (img01=''@''' + tmpSQL + ')' + l_img02All + ' And img10>0';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      CDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((CDS.RecNo <= tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1 := 0;
        qty2 := 0;
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'img01_1=' + Quotedstr(Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString)
            - 1));
          Filtered := True;
          while not Eof do
          begin
            if CDS.FieldByName('pno').AsString = Fields[0].AsString then
              if (SameText(Fields[3].AsString, CDS.FieldByName('custno').AsString) or SameText(Fields[3].AsString, CDS.FieldByName
                ('custshort').AsString)) and (Pos(Fields[1].AsString, l_img02Out) > 0) then
                qty1 := qty1 + Fields[2].AsFloat;
            qty2 := qty2 + Fields[2].AsFloat;
            Next;
          end;
        end;
        CDS.Edit;
        CDS.FieldByName('qty1').AsString := FloatToStr(qty1) + '/' + FloatToStr(qty2);
        CDS.Post;
        if tmpCRecNo = 0 then
          Break;
        CDS.Next;
      end;

      //�h�Xwhile true
      if CDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;
    if CDS.ChangeCount > 0 then
      CDS.MergeChangeLog;
    ShowMsg('��s����!', 64);

  finally
    tmpCDS.Free;
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST120.btn_mpsr120BClick(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //��e�B�}�l�B����
  qty1, qty2: Double;
  Data: OleVariant;
  tmpSQL: string;
  tmpStr: WideString;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('�L�ƾ�,���i�ާ@!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['qty2'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('�Ш���[����ƶq]���ƧǼаO,�A���榹�ާ@!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['qty3'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('�Ш���[����ƶq]���ƧǼаO,�A���榹�ާ@!', 48);
    Exit;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('��s�����Ы�[�O]' + #13#10 + '��s��e�o���Ы�[�_]' + #13#10 + '�L�ާ@�Ы�[����]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := CDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := ' or oeb04 like ' + Quotedstr(Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString)
          - 1) + '%')
      else
      begin
        while not CDS.Eof do
        begin
          tmpStr := Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString) - 1);
          if Pos(tmpStr, tmpSQL) = 0 then
            tmpSQL := tmpSQL + ' or oeb04 like ' + Quotedstr(tmpStr + '%');
          tmpERecNo := CDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //�C����50���Ƹ��d�߮w�s
            Break;
          CDS.Next;
        end;
      end;

      g_StatusBar.Panels[0].Text := CheckLang('���b�B�z' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '��');
      Application.ProcessMessages;
      Data := null;            //oeb04_1�h�����X
      if l_isDG then
        tmpSQL := ' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1' +
          ' From ITEQDG.oea_file Inner Join ITEQDG.oeb_file on oea01=oeb01' +
          ' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y''' +
          ' and oea04 not in (''N012'',''N005'') and substr(oea01,1,3) not in (''228'',''22B'')' + ' and (oeb04=''@''' +
          tmpSQL + ')' + ' Union All' + ' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1' +
          ' From ITEQGZ.oea_file Inner Join ITEQGZ.oeb_file on oea01=oeb01' +
          ' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y''' +
          ' and oea04 not in (''N012'',''N005'') and substr(oea01,1,3) not in (''228'',''22B'')' + ' and (oeb04=''@''' +
          tmpSQL + ')'
      else
        tmpSQL := ' Select oea04,oeb04,oeb12-oeb24 qty,substr(oeb04,1,length(oeb04)-1) oeb04_1' + ' From ' + g_UInfo^.BU
          + '.oea_file Inner Join ' + g_UInfo^.BU + '.oeb_file on oea01=oeb01' +
          ' Where oeaconf=''Y'' and oeb12>oeb24 and oeb70<>''Y''' + ' and substr(oea01,1,3) not in (''228'',''22B'')' +
          ' and (oeb04=''@''' + tmpSQL + ')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      CDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((CDS.RecNo <= tmpERecNo) and (not CDS.Eof)) do
      begin
        qty1 := 0;
        qty2 := 0;
        with tmpCDS do
        begin
          Filtered := False;
          Filter := 'oea04=' + Quotedstr(CDS.FieldByName('custno').AsString) + ' and oeb04=' + Quotedstr(CDS.FieldByName
            ('pno').AsString);
          Filtered := True;
          while not Eof do
          begin
            qty1 := qty1 + Fields[2].AsFloat;
            Next;
          end;

          Filtered := False;
          Filter := 'oeb04_1=' + Quotedstr(Copy(CDS.FieldByName('pno').AsString, 1, Length(CDS.FieldByName('pno').AsString)
            - 1));
          Filtered := True;
          while not Eof do
          begin
            qty2 := qty2 + Fields[2].AsFloat;
            Next;
          end;
        end;
        CDS.Edit;
        CDS.FieldByName('qty2').AsFloat := qty1;
        CDS.FieldByName('qty3').AsFloat := qty2;
        CDS.Post;
        if tmpCRecNo = 0 then
          Break;
        CDS.Next;
      end;

      //�h�Xwhile true
      if CDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;
    if CDS.ChangeCount > 0 then
      CDS.MergeChangeLog;
    ShowMsg('��s����!', 64);

  finally
    tmpCDS.Free;
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

procedure TFrmMPST120.btn_mpsr120CClick(Sender: TObject);
var
  str: string;
begin
  inherited;
  if CDS.Active then
    str := CDS.FieldByName('pno').AsString;
  GetQueryStock(str, true);
end;

procedure TFrmMPST120.SetBtnEnabled(bool: Boolean);
begin
  btn_mpsr120A.Enabled := bool;
  btn_mpsr120B.Enabled := bool;
  btn_mpsr120C.Enabled := bool;
end;

procedure TFrmMPST120.btn_mpsr120DClick(Sender: TObject);
var
  tmpCRecNo, tmpBRecNo, tmpERecNo: Integer;   //��e�B�}�l�B����
  Data: OleVariant;
  tmpStr, tmpSQL: string;
  tmpCDS: TClientDataSet;
  dsNE1, dsNE2, dsNE3, dsNE4, dsNE5: TDataSetNotifyEvent;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('�L�ƾ�,���i�ާ@!', 48);
    Exit;
  end;

  tmpStr := DBGridEh1.FieldColumns['qty1'].Title.Caption;
  if (Pos(g_Asc, tmpStr) > 0) or (Pos(g_Desc, tmpStr) > 0) then
  begin
    ShowMsg('�Ш���[�w�s�q]���ƧǼаO,�A���榹�ާ@!', 48);
    Exit;
  end;

  tmpCRecNo := CDS.RecNo;
  case ShowMsg('��s�����Ы�[�O]' + #13#10 + '��s��e�o���Ы�[�_]' + #13#10 + '�L�ާ@�Ы�[����]', 35) of
    IdNo:
      tmpCRecNo := 0;
    IdCancel:
      Exit;
  end;

  dsNE1 := CDS.BeforeEdit;
  dsNE2 := CDS.AfterEdit;
  dsNE3 := CDS.BeforePost;
  dsNE4 := CDS.AfterPost;
  dsNE5 := CDS.AfterScroll;
  CDS.BeforeEdit := nil;
  CDS.AfterEdit := nil;
  CDS.BeforePost := nil;
  CDS.AfterPost := nil;
  CDS.AfterScroll := nil;
  CDS.DisableControls;
  if tmpCRecNo <> 0 then
    CDS.First;
  SetBtnEnabled(False);
  DBGridEh1.Enabled := False;
  tmpCDS := TClientDataSet.Create(nil);
  try
    while True do
    begin
      tmpSQL := '';
      tmpBRecNo := CDS.RecNo;
      tmpERecNo := tmpBRecNo;

      if tmpCRecNo = 0 then
        tmpSQL := Format(' or pml06=''%s-%d''', [CDS.FieldByName('orderno').AsString, CDS.FieldByName('orderitem').asinteger])
      else
      begin
        while not CDS.Eof do
        begin
          tmpStr := Format(' or pml06=''%s-%d''', [CDS.FieldByName('orderno').AsString, CDS.FieldByName('orderitem').asinteger]);
          if Pos(tmpStr, tmpSQL) = 0 then
            tmpSQL := tmpSQL + tmpStr;
          tmpERecNo := CDS.RecNo;
          if (tmpERecNo mod 50) = 0 then  //�C����50���Ƹ��d�߮w�s
            Break;
          CDS.Next;
        end;
      end;

      g_StatusBar.Panels[0].Text := CheckLang('���b�B�z' + inttostr(tmpBRecNo) + '...' + inttostr(tmpERecNo) + '��');
      Application.ProcessMessages;
      Data := null;
      tmpSQL := 'Select sum(pml20)qty,pml06||'' '' pml06 From pml_file Where 1=2 ' + tmpSQL + ' group by pml06';

      if not QueryBySQL(tmpSQL, Data, DBType) then
      begin
        if CDS.ChangeCount > 0 then
          CDS.CancelUpdates;
        Exit;
      end;
      tmpCDS.Data := Data;

      CDS.RecNo := tmpBRecNo;
      while (tmpCRecNo = 0) or ((CDS.RecNo <= tmpERecNo) and (not CDS.Eof)) do
      begin
        if tmpCDS.Locate('pml06', CDS.FieldByName('orderno').AsString + '-' + CDS.FieldByName('orderitem').AsString+' ', [loPartialKey])
          then
        begin
          CDS.Edit;
          CDS.FieldByName('p_qty').asfloat := tmpCDS.fieldbyname('qty').asfloat;
          CDS.Post;
        end;
        if tmpCRecNo = 0 then
          Break;
        CDS.Next;
      end;

      //�h�Xwhile true
      if CDS.Eof or (tmpCRecNo = 0) then
        Break;
    end;
    if CDS.ChangeCount > 0 then
      CDS.MergeChangeLog;
    ShowMsg('��s����!', 64);

  finally
    tmpCDS.Free;
    if tmpCRecNo <> 0 then
      CDS.RecNo := tmpCRecNo;
    CDS.BeforeEdit := dsNE1;
    CDS.AfterEdit := dsNE2;
    CDS.BeforePost := dsNE3;
    CDS.AfterPost := dsNE4;
    CDS.AfterScroll := dsNE5;
    CDS.EnableControls;
    SetBtnEnabled(True);
    DBGridEh1.Enabled := True;
    g_StatusBar.Panels[0].Text := '';
  end;
end;

end.

