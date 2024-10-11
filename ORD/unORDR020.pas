 unit unORDR020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Math,
  Dialogs, unSTDI040, DBGridEhGrouping, ExtCtrls, DB, DBClient, MConnect,
  SConnect, Menus, ImgList, StdCtrls, GridsEh, DBGridEh, ComCtrls, ToolWin,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmORDR020 = class(TFrmSTDI040)
    CDSsfb01: TStringField;
    strngfldCDSsfb05: TStringField;
    strngfldCDSoeb06: TStringField;
    bcdfldCDSshb032: TFloatField;
    strngfldCDSoea04: TStringField;
    dtmfldCDSsfb15: TDateTimeField;
    CDStc_iee10: TFloatField;
    CDSb: TFloatField;
    CDSc: TFloatField;
    CDSe: TFloatField;
    CDSf: TFloatField;
    CDSg: TFloatField;
    CDSd: TFloatField;
    CDSc1: TFloatField;
    CDSb1: TFloatField;
    CDSe1: TFloatField;
    CDSf1: TFloatField;
    CDSg1: TFloatField;
    CDSd1: TFloatField;
    CDSaa: TFloatField;
    CDSbb: TFloatField;
    CDScc: TFloatField;
    strngfldCDSerrlist: TStringField;
    strngfldCDSsfb22: TStringField;
    bcdfldCDSsfb08: TFloatField;
    procedure m_queryClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CDSCalcFields(DataSet: TDataSet);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
  private
    { Private declarations }

//    procedure GetLeeData;
//    procedure GetRc;
//    procedure SetGs;
//    procedure SetFilter1;
//    procedure SetFilter2;
//    procedure copydataset;
//    procedure AddDataSet(newDs: OleVariant);
  public
    { Public declarations }
  protected
//    p_GridDesignAns: Boolean;
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmORDR020: TFrmORDR020;

implementation

uses
  unGlobal, unCommon, unORDR020_Query,unGridDesign;

var
  l_indate1, l_indate2, l_wono, l_clno, l_sma119,l_dhdno,l_gx: string;
  b_dtp:boolean;
  l_GridDesign:TGridDesign;

{$R *.dfm}

//procedure TFrmORDR020.AddDataSet(newDs: OleVariant);
//var
//  tmpCDS: TClientDataSet;
//  i:integer;
//begin
//  tmpCDS := TClientDataSet.Create(nil);
//  CDS.DisableControls;
//  try
//    tmpCDS.Data := newDs;
//    tmpCDS.First;
//    while not tmpCDS.Eof do
//    begin
//      CDS.Append;
//      for i := 0 to tmpCDS.FieldCount - 1 do
//        CDS.FieldByName(tmpCDS.Fields[i].FieldName).Value := tmpCDS.Fields[i].Value;
//      tmpCDS.Next;
//    end;
//  finally
//    CDS.EnableControls;
//    tmpCDS.Free;
//  end;
//end;

//procedure TFrmORDR020.copydataset;
//var
//  i: integer;
//begin
//  CDS.EmptyDataSet;
//  CDS.DisableControls;
//  try
//    cdstmp.first;
//    while not cdstmp.Eof do
//    begin
//      CDS.Append;
//      for i := 0 to cdstmp.FieldCount - 1 do
//        CDS.FieldByName(cdstmp.Fields[i].FieldName).Value := cdstmp.Fields[i].Value;
//      cdstmp.Next;
//    end;
//    CDS.First;
//  finally
//    CDS.EnableControls;
//  end;
//end;

//procedure TFrmORDR020.GetRc;
//begin
//
//end;
//
//procedure TFrmORDR020.SetFilter1;
//begin
//  //
//end;
//
//procedure TFrmORDR020.SetFilter2;
//begin
//  //
//end;

//procedure TFrmORDR020.SetGs;
//var
//  sfb05_1, sfb05_42, sfb05_44: string;
//  IsPQ, IsRB: Boolean;
//begin
//  CDS.DisableControls;
//  try
//    CDS.first;
//    while not CDS.Eof do
//    begin
//      sfb05_1 := copy(CDS.fieldbyname('sfb05').asstring, 1, 1);
//      sfb05_42 := copy(CDS.fieldbyname('sfb05').asstring, 4, 2);
//      sfb05_44 := copy(CDS.fieldbyname('sfb05').asstring, 4, 4);
//      IsPQ := Pos(sfb05_1, 'PQ') > 0;
//      IsRB := Pos(sfb05_1, 'RB') > 0;
//
//      CDS.edit;
//                                           //改shb10為sfb05
//      if (pos('R13', CDS.fieldbyname('sfb01').AsString) = 1) or (copy(CDS.fieldbyname
//        ('sfb05').AsString, 2, 1) = 'S') then
//        CDS.FieldByName('gs').AsCurrency := 7.5
//      else if CDS.fieldbyname('tc_shb04').AsString = 'Y' then
//      begin
//        if (IsPQ and (sfb05_42 = '25')) or (IsRB and (sfb05_44 = '2116')) then
//          CDS.FieldByName('gs').AsCurrency := 3.7647
//        else if (IsPQ and (sfb05_42 = '15')) or (IsRB and (sfb05_44 = '1086')) then
//          CDS.FieldByName('gs').AsCurrency := 4.6429
//        else
//          CDS.FieldByName('gs').AsCurrency := 0.0;
//      end
//      else
//      begin
//        if CDS.FieldByName('oea04').AsString = 'AC084' then
//          CDS.FieldByName('gs').AsCurrency := 6.0000
//        else if (IsPQ and (UpperCase(copy(CDS.FieldByName('sfb05').asstring, 13,
//          1)) = 'V') or IsRB and (UpperCase(copy(CDS.FieldByName('sfb05').asstring,
//          18, 1)) = 'V')) then
//          CDS.FieldByName('gs').AsCurrency := 7.2857
//        else
//        begin
//          CDS.FieldByName('recal').AsString := 'Y';
////          if l_sma119 = 'T' then
////            SetFilter1
////          else
////            SetFilter2;
////          CDS.FieldByName('gs').AsCurrency := cdsLee.fieldbyname('tc_iee10').asCurrency;
//        end;
//      end;
//      CDS.Next;
//    end;
//  finally
//    CDS.EnableControls;
//  end;
//end;

//procedure TFrmORDR020.GetLeeData;
//var
//  tmpSql: string;
//  data: OleVariant;
//begin
//  tmpSql :=
//    'select tc_iee01,tc_iee04,tc_iee05,tc_iee06,tc_iee09,tc_iee10 from tc_iee_file';
//  QueryBySQL(conn, tmpSql, 'ORACLE', data);
//  cdsLee.data := data;
//end;

procedure TFrmORDR020.m_queryClick(Sender: TObject);
begin
  if not Assigned(FrmORDR020_Query) then
    FrmORDR020_Query := TFrmORDR020_Query.Create(nil);
  if FrmORDR020_Query.ShowModal = mrOK then
  begin
    l_indate1 := DateToStr(FrmORDR020_Query.Dtp1.Date);
    l_indate2 := DateToStr(FrmORDR020_Query.Dtp2.Date);
    l_wono := trim(FrmORDR020_Query.Edit2.Text);
    l_clno := trim(FrmORDR020_Query.Edit1.Text);
    l_dhdno:= trim(FrmORDR020_Query.Edit3.Text);
    l_gx:=    trim(FrmORDR020_Query.Edit6.Text);
    b_dtp:=FrmORDR020_Query.chk1.Checked;
    if b_dtp then
    begin
      if (FrmORDR020_Query.Dtp2.Date-FrmORDR020_Query.Dtp1.Date) >60 then
      begin
        ShowMessage('日期範圍不能超過60天');
        exit;
      end;
    end
    else
    begin
      if (l_wono='') and (l_dhdno='') then
      begin
        ShowMessage('請輸入工單號或訂單號');
        exit;
      end;
    end;
    RefreshDS('');
  end;
end;

procedure TFrmORDR020.RefreshDS(strFilter: string);
var
  tmpSql: string;
  tmpData: OleVariant;
begin

            
//  GetLeeData;


//  if l_sma119 = 'T' then
  tmpSql :=     //上膠站
    'select sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,cast(shb032 as float)shb032,cast(0 as float) b1,cast(0 as float) c1,cast(0 as float) d1,cast(0 as float) e1,cast(0 as float) f1,cast(0 as float) g1,oea04,'+
    'cast(ceil('+

//    tc_iee10
    '(case when (instr(sfb01,''R13'')=1) or (substr(sfb05,2,1)=''S'') then 7.5 '+
    ' when tc_shb04=''Y'' then '+
    '     (case when ((instr(sfb05,''P'')=1 or instr(sfb05,''Q'')=1) and substr(sfb05,4,2) = ''25'') or ((instr(sfb05,''R'')=1 or instr(sfb05,''B'')=1) and (substr(sfb05,4,4) = ''2116'')) then 3.7647 '+
    '           when ((instr(sfb05,''P'')=1 or instr(sfb05,''Q'')=1) and substr(sfb05,4,2) = ''15'') or ((instr(sfb05,''R'')=1 or instr(sfb05,''B'')=1) and (substr(sfb05,4,4) = ''1086'')) then 4.6429 else 0.0 end) '+
    ' else                                      '+
    '   (case when oea04=''AC084'' then 6.0000  '+
    '         when  (instr(sfb05,''P'')=1 or instr(sfb05,''Q'')=1) and (substr(sfb05,13,1) = ''V'') or '+
    '               (instr(sfb05,''R'')=1 or instr(sfb05,''B'')=1) and (substr(sfb05,18,1) = ''V'') then 7.2857 '+
    '         else tc_iee10 end) end)'+



    '*(shb111+shb112)/60) as float)tc_iee10,'+
    'cast(0 as float) b,cast(0 as float) c,cast(0 as float) d,cast(0 as float) e,cast(0 as float) f,cast(0 as float) g '+
    ' from sfb_file '
    + ' left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    ' left join oea_file on oea01=oeb01 ' +
    ' left join shb_file on shb05=sfb01  left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    ' left join tc_iee_file on tc_iee01 =(case when substr(sfb05,1,1) in (''P'',''Q'') ' +
    ' then substr(sfb05,1,2)||substr(sfb05,4,2) else substr(sfb05,1,2)||substr(sfb05,4,4) end) ' +
    ' where shb082=''上膠'' and TA_SHBCONF=''Y'' and (SFB05 like ''R%'' or SFB05 like ''B%'' or SFB05 like ''P%'' or SFB05 like ''Q%'')';
  if b_dtp then
    tmpSql := tmpSql +
    ' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'') ';
  if l_sma119 = 'T' then
    tmpSql := tmpSql +
      ' and tc_iee04>= (case when  substr(sfb05,1,1) in (''P'',''Q'') ' + ' then substr(sfb05,6,3)/10 else substr(sfb05,8,3)/10 end) '
      + ' and tc_iee05<= (case when  substr(sfb05,1,1) in (''P'',''Q'') ' + ' then substr(sfb05,6,3)/10 else substr(sfb05,8,3)/10 end) '
  else
    tmpSql := tmpSql +
      ' and tc_iee04>  (case when  substr(sfb05,1,1) in (''P'',''Q'') ' + ' then substr(sfb05,6,3)/10 else substr(sfb05,8,3)/10 end) '
      + ' and tc_iee05<= (case when  substr(sfb05,1,1) in (''P'',''Q'') ' +
      ' then substr(sfb05,6,3)/10 else substr(sfb05,8,3)/10 end) ';
  tmpSql := tmpSql + ' and tc_iee06=shb09 AND tc_iee09=''N''';

  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
  begin
    l_clno:=StringReplace(l_clno,'?','_',[rfReplaceAll]);
    l_clno:=StringReplace(l_clno,'*','%',[rfReplaceAll]);
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr(l_clno);
  end;
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
//  ShowMessage(tmpSql);  exit;
//  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
//  cdstmp.Data := tmpData;
//  CDS.Data := tmpData;
//  AddDataSet(tmpData);
//  copydataset;
//  SetGs;



                //PP裁切
  tmpSql := tmpSql +
    'union all(select	sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,shb032,0.0,0.0,0.0,0.0,0.0,oea04,'+
    '0.0,round(sum(nvl(tc_iea09,0)*round(bmb06/bmb20)*sfb08)/60)+1,0.0,0.0,0.0,0.0,0.0 from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 ' + 'left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    'left join bmb_file on sfb05=bmb01 ' +
    'left join tc_iea_file on tc_iea01=substr(bmb03,4,2) ' +
    'and tc_iea06>substr(shb10,9,3)/10  ' +
    'and tc_iea07<=substr(shb10,9,3)/10  ' + 'and tc_iea05=tc_shb04  ' +
    'and tc_iea08=(case when shb09 in (''PC50'',''PC51'',''PC52'',''PC53'',''PC54'',''PC55'')  ' +
    'then ''Y'' else ''N'' end)  ';
  tmpSql := tmpSql + ' where shb082=''PP 裁切''  and TA_SHBCONF=''Y'' and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql +' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'') ';
  tmpSql := tmpSql + '  and bmb01=shb10 and (bmb03 like ''P%'' or bmb03 like ''Q%'') ' +
    'and (bmb04 is null or bmb04<=shb03) ' + 'and (bmb05 is null or bmb05>shb03) ';
  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql + ' group by sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,shb032,oea04,bmb01 )';
//  ShowMessage(tmpSql);    exit;
//  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
//  CDS.Data := tmpData;

                   //堆疊     --tiptop有區分廣州廠東莞廠
  tmpSql := tmpSql +
    'union all (select sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,0.0,shb032,0.0,0.0,0.0,0.0,oea04,0.0,0.0,round(sum(nvl(tc_ieb07,0)*sfb08)/60)+1,0.0,0.0,0.0,0.0 from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 ' + 'left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    'left join bmb_file on sfb05=bmb01 ' +
    'left join tc_ieb_file on tc_ieb01=substr(bmb03,4,2) ' +
    'and tc_ieb03=tc_shb04  and TA_SHBCONF=''Y''  ' +
    'and tc_ieb04=(case when round(bmb06/bmb20)>9 then 9 '+
    'when round(bmb06/bmb20)>0 then round(bmb06/bmb20) end) '+
    ' where  shb082=''堆疊''  and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql + ' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'') ';
  tmpSql := tmpSql + ' and bmb01=shb10 and (bmb03 like ''P%'' or bmb03 like ''Q%'') ' +
    'and (bmb04 is null or bmb04<=shb03) ' + 'and (bmb05 is null or bmb05>shb03) ' +
    'and round(bmb06/bmb20)>0 ';
  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql + ' group by sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,shb032,oea04,bmb01) ';
//  ShowMessage(tmpSql);    exit;
//  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
//  CDS.Data := tmpData;



    //組合
  tmpSql := tmpSql +
    'union all(select	sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,0.0,0.0,tc_shb07,0.0,0.0,0.0,oea04,0.0,0.0,0.0,round(nvl(tc_iec11,0)*sfb08/60)+1,0.0 e,0.0 f,0.0 g from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 ' + 'left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    'left join tc_iec_file on substr(tc_iec01,9,1)=substr(shb10,15,1) '+
		'and tc_iec04=(case when shb09=''BU02'' or shb09=''BU03'' then ''BU01'' else shb09 end) '+
    ' where shb082=''組合''  and TA_SHBCONF=''Y''  and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql + ' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'') ';
  tmpSql := tmpSql + ' and substr(tc_iec01,1,8)=substr(shb10,1,8) ';
  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql +')';
//  ShowMessage(tmpSql);    exit;
//  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
//  CDS.Data := tmpData;

      //壓合
  tmpSql := tmpSql +
    'union all (select sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,0.0,0.0,0.0,shb032,0.0,0.0,oea04,0.0,0.0,0.0,0.0,round(nvl(tc_iec12,0)*sfb08/60)+1,0.0 f,0.0 g  from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    'left join tc_sie_file on tc_sie01=shb01 '+
    'left join tc_iec_file on tc_iec01 like substr(shb10,1,8)||substr(shb10,15,1) '+
    'and tc_iec04=(case when tc_sie07=''BU02'' or tc_sie07=''BU03'' then ''BU01'' else tc_sie07 end) '+
    ' where  shb082=''壓合''  and TA_SHBCONF=''Y''  and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql + ' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'')  ';
  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql +')';
//  ShowMessage(tmpSql);    exit;
//  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
//  CDS.Data := tmpData;

      //CCL裁邊
  tmpSql := tmpSql +
    'union all (select sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,0.0,0.0,0.0,0.0,shb032,0.0,oea04,0.0,0.0,0.0,0.0,0.0,round(nvl(tc_ied04,0)*sfb08/60)+1,0.0  from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ' +
    'left join tc_ied_file on tc_ied01=(case when shb09=''CC02'' or shb09=''CC03'' or shb09=''CC04'' or shb09=''CC05'' '+
    'or shb09=''CC06'' or shb09=''CC07'' or shb09=''CC08'' or shb09=''CC09'' or shb09=''CC10'' '+
    'then ''CC01'' else shb09 end) and tc_ied02=(case when substr(shb10,3,4)/10<=4 then ''A'' '+
    'when substr(shb10,3,4)/10>=4.5 and substr(shb10,3,4)/10<=8 '+
		'then ''B'' when substr(shb10,3,4)/10<=28 and substr(shb10,3,4)/10>=8.5 then ''C'' else ''D'' end) '+
    ' where shb082=''CCL裁邊''  and TA_SHBCONF=''Y''  and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql + ' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'')  ';

  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql +')';



        //CCL外觀檢查
  tmpSql := tmpSql+
    ' union all(select sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,0.0,0.0,0.0,0.0,0.0,0.0,shb032,oea04,0.0,0.0,0.0,0.0,0.0,0.0,round(nvl(tc_ied05,0)*sfb08/60)+1 tc_iee10 from sfb_file ' +
    'left join oeb_file on sfb22=oeb01 and sfb221=oeb03 ' +
    'left join oea_file on oea01=oeb01 left join shb_file on shb05=sfb01 '
    + 'left join tc_shb_file on shb05=tc_shb02 and tc_shb01 = shb01 ';
  if l_sma119 = 'T' then
    tmpSql := tmpSql+'left join tc_ied_file on tc_ied01=''C6'' '
  else
    tmpSql := tmpSql+'left join tc_ied_file on tc_ied01=''CC01'' ';
  tmpSql := tmpSql+
    'and  tc_ied02=(case when substr(shb10,3,4)/10<=4 then ''A''  ' +
		'when substr(shb10,3,4)/10>=4.5 and substr(shb10,3,4)/10<=8 then ''B''  ' +
		'when substr(shb10,3,4)/10>=8.5 and substr(shb10,3,4)/10<28 then ''C''  ' +
		'	else ''D'' end)  ' +
    ' where  shb082=''CCL外觀檢查''  and TA_SHBCONF=''Y'' and (SFB05 like ''E%'' or SFB05 like ''T%'') ';
  if b_dtp then
    tmpSql := tmpSql +' and sfb15 between to_date(' + quotedstr(l_indate1) +
    ',''YYYY/MM/DD'')  ' + ' and to_date(' + quotedstr(l_indate2) +
    ',''YYYY/MM/DD'')  ';
  if l_wono <> EmptyStr then
    tmpSql := tmpSql + ' and sfb01 =' + quotedstr(l_wono);
  if l_clno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('%' + l_clno + '%');
  if l_gx <> EmptyStr then
    tmpSql := tmpSql + ' and sfb05 like ' + quotedstr('_' + l_gx + '%');
  if l_dhdno <> EmptyStr then
    tmpSql := tmpSql + ' and sfb22 = ' + quotedstr(l_dhdno);
  tmpSql := tmpSql +')';
                                                  //errlist
  tmpSql:='select sfb22,sfb01,sfb05,oeb06,sfb15,oea04,sfb08,sum(tc_iee10)tc_iee10,'+
          'sum(b)b,sum(c)c,sum(d)d,sum(e)e,sum(f)f,sum(g)g,'+
          'sum(shb032)shb032,sum(b1)b1,sum(c1)c1,sum(d1)d1,sum(e1)e1,sum(f1)f1,sum(g1)g1 from ('+tmpSql+

   ') group by sfb22,sfb08,sfb01,sfb05,oeb06,sfb15,oea04';

   tmpSql:='select a.*,b.errlist from ('+tmpsql+')a'+
   ' left join (select tc_siy01, translate (ltrim (text, ''/''), ''*/'', ''*,'') errlist '+
   ' from (select row_number () over (partition by tc_siy01 order by tc_siy01,  '+
   '               lvl desc) rn,                                                '+
   '              tc_siy01, text                                                '+
   '         from (select     tc_siy01, level lvl,                              '+
   '                          sys_connect_by_path (tc_siy03,''/'') text           '+
   '                     from (select   tc_siy01, tc_siy03 as tc_siy03,         '+
   '                                    row_number () over (partition by tc_siy01 order by tc_siy01,tc_siy03) x '+
   '                              from(                                         '+
   ' select sfb01 tc_siy01,tc_siy03 from(                                       '+
   ' select tc_siy01, translate (ltrim (text, ''/''), ''*/'', ''*,'') tc_siy03        '+
   ' from (select row_number () over (partition by tc_siy01 order by tc_siy01,  '+
   '               lvl desc) rn,                                                '+
   '              tc_siy01, text                                                '+
   '        from (select     tc_siy01, level lvl,                               '+
   '                          sys_connect_by_path (tc_siy03,''/'') text           '+
   '                     from (select   tc_siy01, tc_siy03 as tc_siy03,         '+
   '                                    row_number () over (partition by tc_siy01 order by tc_siy01,tc_siy03) x '+
   '                               from tc_siy_file                                         '+
   '                           order by tc_siy01, tc_siy03)                                 '+
   '               connect by tc_siy01 = prior tc_siy01 and x - 1 = prior x))               '+
   ' where rn = 1                                                                           '+
   ' order by tc_siy01                                                                      '+
   ' )left join shb_file on shb01=tc_siy01                                                  '+
   '          left join sfb_file on shb05=sfb01                                             '+
   '          )order by tc_siy01, tc_siy03)                                                 '+
   '              connect by tc_siy01 = prior tc_siy01 and x - 1 = prior x)) where rn = 1   '+
   '          )b on a.sfb01=b.tc_siy01        ';     


//  ShowMessage(tmpSql);    exit;      
  querybysql(Conn, tmpSql, 'ORACLE', tmpData);
  CDS.Data := tmpData;
end;

procedure TFrmORDR020.FormShow(Sender: TObject);
var
  tmpSql: string;
  tmpData: OleVariant;
  tmpCDS: TClientDataSet;
begin
  inherited;
  tmpSql := 'select sma119 from sma_file';
  if QueryBySQL(Conn, tmpSql, 'ORACLE', tmpData) then
  begin
    tmpCDS := TClientDataSet.Create(nil);
    tmpCDS.Data := tmpData;
    l_sma119 := tmpCDS.Fields[0].AsString;
    tmpCDS.Free;
  end;
  CDS.CreateDataSet;
  l_GridDesign:=TGridDesign.Create(Conn, DBGridEh1);
end;

procedure TFrmORDR020.CDSCalcFields(DataSet: TDataSet);
begin
  inherited;
  CDSaa.Value:=bcdfldCDSshb032.Value+cdsb1.Value +cdsc1.Value+cdsd1.Value+cdse1.Value+cdsf1.Value+cdsg1.Value;
  CDSbb.Value:=CDStc_iee10.Value+cdsb.Value +cdsc.Value+cdsd.Value+cdse.Value+cdsf.Value+cdsg.Value;
  CDScc.Value:=Roundto(cdsaa.Value-CDSbb.value,-2);
end;

procedure TFrmORDR020.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  l_GridDesign.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmORDR020.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(FrmORDR020_Query) then
    FreeAndNil(FrmORDR020_Query);
  if Assigned(l_GridDesign) then
     FreeAndNil(l_GridDesign);
end;

procedure TFrmORDR020.FormCreate(Sender: TObject);
begin
  p_TableName:='ORDR020';
  inherited;


end;

procedure TFrmORDR020.DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
  AFont: TFont; var Background: TColor; State: TGridDrawState);
var
  bb: Currency;
begin
  inherited;
  bb := CDStc_iee10.Value + cdsb.Value + cdsc.Value + cdsd.Value + cdse.Value +
    cdsf.Value + cdsg.Value;
  if (bb <> 0) and ((cdsaa.Value - CDSbb.value) / bb > 0.1) then
    AFont.Color := clRed;
end;

end.

