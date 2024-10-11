unit unMPST650_pur;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, DBClient, StdCtrls, ExtCtrls, ComCtrls, GridsEh,
  DBAxisGridsEh, DBGridEh, ImgList, Buttons, StrUtils;

type
  TFrmMPST650_pur = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    Dtp1: TDateTimePicker;
    Label2: TLabel;
    Dtp2: TDateTimePicker;
    Panel1: TPanel;
    btn_query: TBitBtn;
    Label3: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    pb: TProgressBar;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_type:Integer; //1:pp 2:ccl 3:pp&ccl 4:自用pp
    { Private declarations }
  public
    l_srcid:string;
    { Public declarations }
  end;

var
  FrmMPST650_pur: TFrmMPST650_pur;

implementation

uses unGlobal, unCommon, unMPST650;

{$R *.dfm}

procedure TFrmMPST650_pur.FormCreate(Sender: TObject);
begin
  inherited;
  Memo1.Visible:=SameText(g_uinfo^.UserId,'ID150515');
  SetGrdCaption(DBGridEh1, 'MPST650_pur');
  CheckBox1.Caption:=CheckLang('請購日期：');
  Label2.Caption:=CheckLang('至');
  Label3.Caption:=CheckLang('請購單號：');
  Dtp1.Date:=Date-2;
  Dtp2.Date:=Date;
end;

procedure TFrmMPST650_pur.FormShow(Sender: TObject);
begin
  inherited;
  if SameText(l_srcid,'pp') then //自用pp
     l_type:=4
  else if Length(l_srcid)=2 then //特殊膠系
     l_type:=3
  else if SameText(Copy(l_srcid,3,10),'pp') then
     l_type:=1
  else
     l_type:=2;
end;

procedure TFrmMPST650_pur.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmMPST650_pur.btn_queryClick(Sender: TObject);
var
  tmpSQL,d1,d2,tmpSrcId:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if CheckBox1.Checked and (Dtp1.Date>Dtp2.Date) then
  begin
    ShowMsg('查詢開始日期不能大于結束日期!',48);
    Exit;
  end;

  if (not CheckBox1.Checked) and (Length(Trim(Edit1.Text))=0) then
  begin
    ShowMsg('未選擇日期查詢時,請輸入[請購單號]查詢!',48);
    Exit;
  end;

  tmpSrcId:=LeftStr(l_srcid,2);
  d1:=StringReplace(FormatDateTime(g_cShortDate1,Dtp1.Date),'/','-',[rfReplaceAll]);
  d2:=StringReplace(FormatDateTime(g_cShortDate1,Dtp2.Date),'/','-',[rfReplaceAll]);
  tmpSQL:='select pmk01,pml02,pmk04,pmk09,pml04,pml041,ima021,pml07,pml09,pml20,'
         +' pml20*pml09 as pml20x,pml06'
         +' from '+g_UInfo^.BU+'.pmk_file,'+g_UInfo^.BU+'.pml_file,'+g_UInfo^.BU+'.ima_file'
         +' where pmk01=pml01 and pml04=ima01 and pmkacti=''Y''';

  if SameText(tmpSrcId,'wx')then
     tmpSQL:=tmpSQL+' and (pmk09 is null or pmk09=''N006'') and length(nvl(pml06,''''))>0'
  else if SameText(tmpSrcId,'tw')then
     tmpSQL:=tmpSQL+' and (pmk09 is null or pmk09=''N023'') and length(nvl(pml06,''''))>0'
  else if SameText(tmpSrcId,'jx')then
     tmpSQL:=tmpSQL+' and (pmk09 is null or pmk09=''N024'') and length(nvl(pml06,''''))>0'
  else if SameText(tmpSrcId,'pp')then
     tmpSQL:=tmpSQL+' and (pmk09 is null or pmk09 in (''N006'',''N023'',''N024''))'
  else
     tmpSQL:=tmpSQL+' and 1=2';

  if l_type=1 then
     tmpSQL:=tmpSQL+' and (pml04 like ''B%'' or pml04 like ''R%'' or pml04 like ''M%'' or pml04 like ''N%'')'
  else if l_type=2 then
     tmpSQL:=tmpSQL+' and (pml04 like ''E%'' or pml04 like ''T%'' or pml04 like ''H%'')'
  else if l_type=4 then
     tmpSQL:=tmpSQL+' and (pml04 like ''P%'' or pml04 like ''Q%'')'
  else
     tmpSQL:=tmpSQL+' and (pml04 like ''E%'' or pml04 like ''T%'' or pml04 like ''H%'' or pml04 like ''B%'' or pml04 like ''R%'' or pml04 like ''M%'' or pml04 like ''N%'')';

  if CheckBox1.Checked then
     tmpSQL:=tmpSQL+' and pmk04 between to_date('+Quotedstr(d1)+',''YYYY-MM-DD'') and to_date('+Quotedstr(d2)+',''YYYY-MM-DD'')';
  if Length(Trim(Edit1.Text))>0 then
     tmpSQL:=tmpSQL+' and pmk01='+Quotedstr(Edit1.Text);

  tmpSQL:='select x.*,occ02 from ('+tmpSQL+') x left join '+g_UInfo^.BU+'.occ_file'
         +' on pmk09=occ01 order by pmk04,pmk01,pml02';
  Memo1.Text:=QuotedStr( tmpsql);
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;

    //刪除已保存的
    if not tmpCDS1.IsEmpty then
    begin
      Data:=null;
      tmpSQL:='select cno,sno from mps650 where bu='+Quotedstr(g_UInfo^.BU);
            // +' and srcid='+Quotedstr(l_srcid);
      if CheckBox1.Checked then
         tmpSQL:=tmpSQL+' and cdate between '+Quotedstr(d1)+' and '+Quotedstr(d2)
      else
         tmpSQL:=tmpSQL+' and cdate>'+Quotedstr(DateToStr(Date-366));
      if Length(Trim(Edit1.Text))>0 then
         tmpSQL:=tmpSQL+' and cno='+Quotedstr(Edit1.Text);
      if not QueryBySQL(tmpSQL, Data) then
         Exit;

      tmpCDS2.Data:=Data;
      while not tmpCDS2.Eof do
      begin
        while tmpCDS1.Locate('pmk01;pml02',VarArrayOf([tmpCDS2.FieldByName('cno').AsString,tmpCDS2.FieldByName('sno').AsInteger]),[loCaseInsensitive]) do
          tmpCDS1.Delete;
        tmpCDS2.Next;
      end;
    end;

    if tmpCDS1.ChangeCount>0 then
       tmpCDS1.MergeChangeLog;

    CDS.Data:=tmpCDS1.Data;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
  end;
end;

procedure TFrmMPST650_pur.btn_okClick(Sender: TObject);
var
  i:Integer;
  tmpSQL,tmpORADB:string;
  tmpCDS,tmpCDS_oea:TClientDataSet;
  tmpList:TStrings;
  Data:OleVariant;

  function AddData:Boolean;
  var
    fstCode:string;
  begin
    Result:=False;
    fstCode:=LeftStr(CDS.FieldByName('pml04').AsString,1);

    if (l_type=1) and (Pos(fstCode,'BRMN')=0) then
    begin
      ShowMsg('請選擇PP',48);
      Exit;
    end else
    if (l_type=2) and (Pos(fstCode,'ETH')=0) then
    begin
      ShowMsg('請選擇CCL',48);
      Exit;
    end else
    if (l_type=3) and (Pos(fstCode,'ETHBRMN')=0) then
    begin
      ShowMsg('請選擇PP/CCL',48);
      Exit;
    end else
    if (l_type=4) and (Pos(fstCode,'PQ')=0) then
    begin
      ShowMsg('請選擇自用PP',48);
      Exit;
    end;

    //pml06:222-040852-1 AC365-方正高密
    //簡稱可能有符號"-"
    tmpList.DelimitedText:=StringReplace(CDS.FieldByName('pml06').AsString,' ','-',[rfReplaceAll]);

    tmpCDS.Append;
    tmpCDS.FieldByName('bu').AsString:=g_UInfo^.BU;
    tmpCDS.FieldByName('dno').AsString:=GetSno('MPS650');
    tmpCDS.FieldByName('srcid').AsString:=l_srcid;
    tmpCDS.FieldByName('cno').AsString:=CDS.FieldByName('pmk01').AsString;
    tmpCDS.FieldByName('sno').AsInteger:=CDS.FieldByName('pml02').AsInteger;
    tmpCDS.FieldByName('cdate').AsDateTime:=CDS.FieldByName('pmk04').AsDateTime;
    tmpCDS.FieldByName('suppno').AsString:=CDS.FieldByName('pmk09').AsString;
    tmpCDS.FieldByName('supplier').AsString:=CDS.FieldByName('occ02').AsString;
    if tmpList.Count>2 then
    if (Length(tmpList.Strings[0])=3) and (Length(tmpList.Strings[1])=6) and (StrToIntDef(tmpList.Strings[2],0)>0) then
    begin
      tmpCDS.FieldByName('orderno').AsString:=tmpList.Strings[0]+'-'+tmpList.Strings[1];
      tmpCDS.FieldByName('orderitem').AsInteger:=StrToInt(tmpList.Strings[2]);

      if (tmpList.Count>3) and (Length(tmpList.Strings[3]) in [4,5]) then
         tmpCDS.FieldByName('custno').AsString:=tmpList.Strings[3];
    end;
    tmpCDS.FieldByName('pno').AsString:=CDS.FieldByName('pml04').AsString;
    tmpCDS.FieldByName('pname').AsString:=CDS.FieldByName('pml041').AsString;
    tmpCDS.FieldByName('sizes').AsString:=CDS.FieldByName('ima021').AsString;
    tmpCDS.FieldByName('units').AsString:=CDS.FieldByName('pml07').AsString;
    tmpCDS.FieldByName('oldpurqty').AsFloat:=CDS.FieldByName('pml20').AsFloat;
    tmpCDS.FieldByName('purqty').AsFloat:=CDS.FieldByName('pml20').AsFloat;
    tmpCDS.FieldByName('qty').AsFloat:=CDS.FieldByName('pml20x').AsFloat;
    tmpCDS.FieldByName('purremark').AsString:=CDS.FieldByName('pml06').AsString;
    tmpCDS.FieldByName('isfinish').AsBoolean:=False;
    tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
    tmpCDS.FieldByName('idate').AsDateTime:=Now;
    tmpCDS.Post;
    Result:=True;
  end;

begin
  if (not CDS.Active) or CDS.IsEmpty then
     ModalResult:=mrCancel
  else begin
    CDS.DisableControls;
    tmpCDS:=TClientDataSet.Create(nil);
    tmpCDS_oea:=TClientDataSet.Create(nil);
    tmpList:=TStringList.Create;
    try
      tmpList.Delimiter:='-';
      tmpCDS.Data:=FrmMPST650.CDS.Data;
      tmpCDS.EmptyDataSet;

      if DBGridEh1.SelectedRows.Count>0 then
      begin
        for i:=0 to DBGridEh1.SelectedRows.Count-1 do
        begin
          CDS.GotoBookmark(Pointer(DBGridEh1.SelectedRows.Items[i]));
          if not AddData then
             Exit;
        end;
      end else
      begin
        if not AddData then
           Exit;
      end;

      //不是自用pp,更新訂單資料
      if l_type<>4 then
      begin
        pb.Position:=0;
        pb.Max:=tmpCDS.RecordCount;
        pb.Visible:=True;
        tmpCDS.First;
        while not tmpCDS.Eof do
        begin
          pb.Position:=pb.Position+1;
          Application.ProcessMessages;

          if (Length(tmpCDS.FieldByName('orderno').AsString)>0) and
             (Length(tmpCDS.FieldByName('custno').AsString)>0) then
          begin
            tmpORADB:=g_UInfo^.BU;

            //查詢兩角訂單號碼
            Data:=null;
            tmpSQL:=tmpCDS.FieldByName('custno').AsString+'-'+
                    tmpCDS.FieldByName('orderno').AsString+'-'+
                    tmpCDS.FieldByName('orderitem').AsString;
            tmpSQL:='select oao01,oao03 from '+tmpORADB+'.oao_file where oao06='+Quotedstr(tmpSQL);
            if not QueryBySQL(tmpSQL,Data,'ORACLE') then
               Exit;
            tmpCDS_oea.Data:=Data;
            if not tmpCDS_oea.IsEmpty then
            begin
              tmpCDS.Edit;
              tmpCDS.FieldByName('orderno2').AsString:=tmpCDS_oea.FieldByName('oao01').AsString;
              tmpCDS.FieldByName('orderitem2').AsInteger:=tmpCDS_oea.FieldByName('oao03').AsInteger;
              tmpCDS.Post;
              if SameText(tmpORADB,'ITEQDG') then
                 tmpORADB:='ITEQGZ'
              else
                 tmpORADB:='ITEQDG';
            end;

            //查詢原訂單
            Data:=null;
            tmpSQL:=' where oea01='+Quotedstr(tmpCDS.FieldByName('orderno').AsString)
                   +' and oeb03='+IntToStr(tmpCDS.FieldByName('orderitem').AsInteger);
            tmpSQL:='select c.*,ocd221 from'
                   +' (select b.*,oao06 from'
                   +' (select a.*,occ02 from'
                   +' (select oea01,oea02,oea04,oea044,oea10,oeb03,oeb15,oeb11,oeb12,oeb12-oeb24 qty,ta_oeb10,'
                   +' case when ta_oea08=1 then ''依樣品流程作業'' when ta_oea08=2 then ''無需依樣品流程作業'' end ta_oea08 '
                   +' from '+tmpORADB+'.oea_file inner join '+tmpORADB+'.oeb_file'
                   +' on oea01=oeb01 '+tmpSQL+') a inner join '+tmpORADB+'.occ_file on oea04=occ01'
                   +' ) b left join '+tmpORADB+'.oao_file on oea01=oao01 and oeb03=oao03'
                   +' ) c left join '+tmpORADB+'.ocd_file on oea04=ocd01 and oea044=ocd02';
            if not QueryBySQL(tmpSQL,Data,'ORACLE') then
               Exit;
            tmpCDS_oea.Data:=Data;
            if not tmpCDS_oea.IsEmpty then
            begin
              tmpCDS.Edit;
              tmpCDS.FieldByName('oradb').AsString:=tmpORADB;
              tmpCDS.FieldByName('orderdate').AsDateTime:=tmpCDS_oea.FieldByName('oea02').AsDateTime;
              tmpCDS.FieldByName('custshort').AsString:=tmpCDS_oea.FieldByName('occ02').AsString;
              try
                tmpCDS.FieldByName('custdate').AsDateTime:=tmpCDS_oea.FieldByName('oeb15').AsDateTime;
              except
              end;
              tmpCDS.FieldByName('orderqty').AsFloat:=tmpCDS_oea.FieldByName('oeb12').AsFloat;
              tmpCDS.FieldByName('ordernotqty').AsFloat:=tmpCDS_oea.FieldByName('qty').AsFloat;
              tmpCDS.FieldByName('c_orderno').AsString:=tmpCDS_oea.FieldByName('oea10').AsString;
              tmpCDS.FieldByName('c_pno').AsString:=tmpCDS_oea.FieldByName('oeb11').AsString;
              tmpCDS.FieldByName('c_sizes').AsString:=tmpCDS_oea.FieldByName('ta_oeb10').AsString;
              tmpCDS.FieldByName('ordremark').AsString:=tmpCDS_oea.FieldByName('oao06').AsString;
              tmpCDS.FieldByName('sendaddr').AsString:=tmpCDS_oea.FieldByName('ocd221').AsString;
              tmpCDS.FieldByName('ta_oea08').AsString:=tmpCDS_oea.FieldByName('ta_oea08').AsString;
              tmpCDS.Post;
            end;
          end;
          tmpCDS.Next;
        end;
      end;

      if CDSPost(tmpCDS, 'MPS650') then
      begin
        FrmMPST650.RefreshGrdCaptionX;
        FrmMPST650.CDS.Data:=tmpCDS.Data;
      end;

    finally
      CDS.EnableControls;
      FreeAndNil(tmpCDS);
      FreeAndNil(tmpCDS_oea);
      FreeAndNil(tmpList);
      pb.Visible:=False;
    end;

    inherited;
  end;
end;

end.
