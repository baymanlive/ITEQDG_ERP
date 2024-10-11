unit unMPST000;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB, Buttons,
  GridsEh, DBAxisGridsEh, DBGridEh, StrUtils;

type
  TFrmMPST000 = class(TFrmSTDI080)
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Splitter1: TSplitter;
    Panel2: TPanel;
    DBGridEh2: TDBGridEh;
    DBGridEh3: TDBGridEh;
    Panel3: TPanel;
    lblpno: TLabel;
    CheckBoxT: TCheckBox;
    Edit3: TEdit;
    CheckBoxE: TCheckBox;
    CheckBoxB: TCheckBox;
    CheckBoxR: TCheckBox;
    CheckBoxP: TCheckBox;
    CheckBoxQ: TCheckBox;
    CheckBoxM: TCheckBox;
    CheckBoxN: TCheckBox;
    CheckBox1: TCheckBox;
    DBGridEh1: TDBGridEh;
    DS3: TDataSource;
    DS2: TDataSource;
    DS1: TDataSource;
    chk: TCheckBox;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh2TitleClick(Column: TColumnEh);
    procedure FormResize(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
  private
    l_Ans,l_isDG:Boolean;
    l_StrIndex1,l_StrIndex2,l_StrIndexDesc1,l_StrIndexDesc2:string;
    l_StkCDS,l_SalCDS,l_MpsCDS:TClientDataSet;
    l_sql2:string;
    l_list2:TStrings;
    procedure l_SalCDSAfterScroll(DataSet:TDataSet);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST000: TFrmMPST000;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST000.l_SalCDSAfterScroll(DataSet:TDataSet);
var
  tmpSQL:string;
begin
  if DataSet.IsEmpty then
  begin
    tmpSQL:='select null sdate,null stype,null custno,null custom,null materialno,'
           +' null materialno1,null adate,null sqty from sys_bu where 1=2';
    l_list2.Insert(0,tmpSQL);
    Exit;
  end;

  if l_isDG then
  begin
    if DataSet.FieldByName('dbtype').AsString='DG' then
       tmpSQL:=' and srcflag in (1,3,5)'
    else
       tmpSQL:=' and srcflag in (2,4,6)';

    if Pos(LeftStr(DataSet.FieldByName('oeb04').AsString,1),'ET')>0 then
       tmpSQL:='select sdate,null stype,materialno,materialno1,adate_new as adate,sqty from mps010'
              +' where bu=''ITEQDG'''
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0 '+tmpSQL
              +' union all'
              +' select sdate,stype,materialno,materialno1,adate,sqty from mps012'
              +' where bu=''ITEQDG'''
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(isempty,0)=0 and isnull(notvisible,0)=0 '+tmpSQL
              +' order by sdate,stype'
    else
       tmpSQL:='select sdate,null as stype,materialno,materialno1,adate_new as adate,sqty from mps070'
              +' where bu=''ITEQDG'''
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0 '+tmpSQL
              +' order by sdate';
  end else
  begin
    if Pos(LeftStr(DataSet.FieldByName('oeb04').AsString,1),'ET')>0 then
       tmpSQL:='select sdate,null stype,materialno,materialno1,adate_new as adate,sqty from mps010'
              +' where bu='+Quotedstr(g_UInfo^.BU)
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0'
              +' union all'
              +' select sdate,stype,materialno,materialno1,adate,sqty from mps012'
              +' where bu='+Quotedstr(g_UInfo^.BU)
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(isempty,0)=0 and isnull(notvisible,0)=0 '+tmpSQL
              +' order by sdate,stype'
    else
       tmpSQL:='select sdate,null as stype,materialno,materialno1,adate_new as adate,sqty from mps070'
              +' where bu='+Quotedstr(g_UInfo^.BU)
              +' and orderno='+Quotedstr(DataSet.FieldByName('oea01').AsString)
              +' and orderitem='+IntToStr(DataSet.FieldByName('oeb03').AsInteger)
              +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0 and isnull(case_ans2,0)=0'
              +' order by sdate';
  end;
  l_list2.Insert(0,tmpSQL);
end;

procedure TFrmMPST000.FormCreate(Sender: TObject);
begin
  p_TableName:='@';
  p_SBText:=CheckLang('生產排程,選中:去掉N012,N005;228,22B,22A,226 未選中:去掉22A,226');
  
  inherited;

  btn_print.Visible:=False;
  btn_export.Visible:=False;
  btn_query.Visible:=True;
  SetGrdCaption(DBGridEh1, 'MPST040');
  SetGrdCaption(DBGridEh2, 'MPST040');
  SetGrdCaption(DBGridEh3, 'Stock_3');
  CheckBoxE.Caption:='E';
  CheckBoxT.Caption:='T';
  CheckBoxB.Caption:='B';
  CheckBoxR.Caption:='R';
  CheckBoxP.Caption:='P';
  CheckBoxQ.Caption:='Q';
  CheckBoxM.Caption:='M';
  CheckBoxN.Caption:='N';
  CheckBox1.Caption:='1';

  l_StkCDS:=TClientDataSet.Create(Self);
  l_SalCDS:=TClientDataSet.Create(Self);
  l_MpsCDS:=TClientDataSet.Create(Self);
  l_SalCDS.IndexFieldNames:='dbtype;oea01;oeb03';
  DS1.DataSet:=l_StkCDS;
  DS2.DataSet:=l_SalCDS;
  DS3.DataSet:=l_MpsCDS;

  chk.Caption:=CheckLang('生產排程');
  l_isDG:=SameText(g_UInfo^.BU,'ITEQDG') or SameText(g_UInfo^.BU,'ITEQGZ');

  l_list2:=TStringList.Create;
  Timer1.Enabled:=True;
end;

procedure TFrmMPST000.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled:=False;
  inherited;
  l_Ans:=True;
  l_StkCDS.Active:=False;
  l_SalCDS.Active:=False;
  l_MpsCDS.Active:=False;
  FreeAndNil(l_StkCDS);
  FreeAndNil(l_SalCDS);
  FreeAndNil(l_MpsCDS);
  FreeAndNil(l_list2);
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
end;

procedure TFrmMPST000.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(l_StkCDS, Column, l_StrIndex1, l_StrIndexDesc1);
end;

procedure TFrmMPST000.DBGridEh2TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(l_SalCDS, Column, l_StrIndex2, l_StrIndexDesc2);
end;

procedure TFrmMPST000.FormResize(Sender: TObject);
var
  halfWidth:Integer;
begin
  inherited;
  if l_Ans then
     Exit;
  halfWidth:=Trunc(Self.ClientWidth/2);
  DBGridEh1.Width:=halfWidth;
end;

procedure TFrmMPST000.btn_queryClick(Sender: TObject);
const fstCode='ETBRPQMN1';
var
  i:Integer;
  Data:OleVariant;
  tmpStr:WideString;
  tmpSQL,tmpImgFilter,tmpOebFilter,tmpPPFilter,tmpCCLFilter,tmpImg02:string;
  tmpCDS,tmpCDSX:TClientDataSet;
begin
//  inherited;
  tmpStr:=Trim(Edit3.Text);
  if Length(tmpStr)<6 then
  begin
    ShowMsg('請輸入物品料號,最小長度6碼!',48);
    Edit3.SetFocus;
    Exit;
  end;

  Delete(tmpStr,1,1);
  for i:=1 to Length(fstCode) do
  begin
    if (Self.FindComponent('CheckBox'+fstCode[i])<>nil) and
       (Self.FindComponent('CheckBox'+fstCode[i]) as TCheckBox).Checked then
    begin
      tmpImgFilter:=tmpImgFilter+' or img01 Like '+Quotedstr(fstCode[i]+tmpStr+'%');
      tmpOebFilter:=tmpOebFilter+' or oeb04 Like '+Quotedstr(fstCode[i]+tmpStr+'%');
    end;
  end;

  if Length(tmpImgFilter)=0 then
  begin
    ShowMsg('請選擇E/T/B/R/P/Q/M/N/1,一個或多個!',48);
    Edit3.SetFocus;
    Exit;
  end;

  if CheckBox1.Checked then
  if CheckBoxE.Checked or CheckBoxT.Checked or
     CheckBoxB.Checked or CheckBoxR.Checked or
     CheckBoxP.Checked or CheckBoxQ.Checked or
     CheckBoxM.Checked or CheckBoxN.Checked then
  begin
    ShowMsg('E/T/B/R/P/Q/M/N與1不能同時選中!',48);
    Edit3.SetFocus;  
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  tmpCDSX:=TClientDataSet.Create(nil);
  l_SalCDS.AfterScroll:=nil;
  l_SalCDS.DisableControls;
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢庫存狀況...');
  Application.ProcessMessages;
  try
    //取庫別
    tmpImg02:='';
    if CheckBox1.Checked then
       tmpSQL:=' and qst=1'
    else
       tmpSQL:=' and sst=1';
    tmpSQL:='Select Depot From MPS330 Where Bu='+Quotedstr(g_UInfo^.BU)+tmpSQL;
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    with tmpCDS do
    while Not Eof do
    begin
      tmpImg02:=tmpImg02+','+Quotedstr(Fields[0].AsString);
      Next;
    end;
    if Length(tmpImg02)=0 then
    begin
      ShowMsg('MPS330無庫別,請確認!',48);
      Edit3.SetFocus;
      Exit;
    end;
    Delete(tmpImg02,1,1);
    tmpImg02:=' And img02 in ('+tmpImg02+')';
    //***

    Data:=null;
    if l_isDG then     //ta_img04
       tmpSQL:='Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''DG'' dbtype,img04 as cjremark'
              +' From ITEQDG.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Union All'
              +' Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,''GZ'' as dbtype,img04 as cjremark'
              +' From ITEQGZ.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Order By img01,img02,img03,img04'
    else
       tmpSQL:='Select img01,img02,img03,img04,img10,ta_img01,ta_img03,ta_img04,ta_img05,'
              +Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype,img04 as cjremark'
              +' From '+g_UInfo^.BU+'.img_file Where (img01=''@''' +tmpImgFilter+')'+tmpImg02
              +' And img10>0'
              +' Order By img01,img02,img03,img04';
    if QueryBySQL(tmpSQL, Data, 'ORACLE') then
    begin
      RefreshGrdCaption(l_StkCDS, DBGridEh1, l_StrIndex1, l_StrIndexDesc1);
      tmpCDS.Data:=Data;

      //查詢裁檢備注
      tmpSQL:='';
      with tmpCDS do
      while not Eof do
      begin
        tmpSQL:=tmpSQL+' or (pno='+Quotedstr(FieldByName('img01').AsString)
                      +' and lot='+Quotedstr(FieldByName('img04').AsString)+')';
        Next;
      end;

      if Length(tmpSQL)>0 then
      begin
        Delete(tmpSQL,1,4);
        Data:=null;
        tmpSQL:='select pno,lot,remark from mps400'
               +' where bu='+Quotedstr(g_UInfo^.BU)
               +' and ('+tmpSQL+')';
        if not QueryBySQL(tmpSQL, Data) then
           Exit;
        tmpCDSX.Data:=Data;

        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            Edit;
            if tmpCDSX.Locate('pno;lot',VarArrayOf([FieldByName('img01').AsString,FieldByName('img04').AsString]),[]) then
               FieldByName('cjremark').AsString:=tmpCDSX.FieldByName('remark').AsString
            else
               FieldByName('cjremark').Clear;
            Post;
            Next;
          end;
         if ChangeCount>0 then
            MergeChangeLog;
        end;
      end;
      l_StkCDS.Data:=tmpCDS.Data;

      if CheckBox1.Checked then
      if (not CheckBoxE.Checked) and (not CheckBoxT.Checked) and
         (not CheckBoxB.Checked) and (not CheckBoxR.Checked) and
         (not CheckBoxP.Checked) and (not CheckBoxQ.Checked) and
         (not CheckBoxM.Checked) and (not CheckBoxN.Checked) then
      begin
        if l_SalCDS.Active then
           l_SalCDS.EmptyDataSet;
        if l_MpsCDS.Active then
           l_MpsCDS.EmptyDataSet;
        Exit;
      end;

      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢未交狀況...');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:='';
      if l_isDG then
      begin
        if chk.Checked then
           tmpSQL:=' And oea04 not in (''N012'',''N005'') And Substr(oea01,1,3) not in (''228'',''22B'',''22A'',''226'')'
        else
           tmpSQL:=' And Substr(oea01,1,3) not in (''22A'',''226'')';
      end;
      if l_isDG then
         tmpSQL:=' Select A.*,occ02,''DG'' dbtype From ('
                +' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,ta_oeb02,ta_oeb10 adate,oeb12 sqty'
                +' From ITEQDG.oea_file Inner Join ITEQDG.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')<>''Y'''+tmpSQL
                +' and (oeb04=''@''' +tmpOebFilter+')) A'
                +' Inner Join ITEQDG.occ_file on oea04=occ01'
                +' Union All'
                +' Select A.*,occ02,''GZ'' dbtype From ('
                +' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,ta_oeb02,ta_oeb10 adate,oeb12 sqty'
                +' From ITEQGZ.oea_file Inner Join ITEQGZ.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')<>''Y'''+tmpSQL
                +' and (oeb04=''@''' +tmpOebFilter+')) A'
                +' Inner Join ITEQGZ.occ_file on oea04=occ01'
      else
         tmpSQL:=' Select A.*,occ02,'+Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype From ('
                +' Select oea01,oea04,oeb03,oeb04,oeb05,oeb12-oeb24 qty,ta_oeb01,ta_oeb02,ta_oeb10 adate,oeb12 sqty'
                +' From '+g_UInfo^.BU+'.oea_file Inner Join '+g_UInfo^.BU+'.oeb_file on oea01=oeb01'
                +' Where oeaconf=''Y'' and oeb12>oeb24 and nvl(oeb70,''N'')<>''Y'''+tmpSQL
                +' and (oeb04=''@''' +tmpOebFilter+')) A'
                +' Inner Join '+g_UInfo^.BU+'.occ_file on oea04=occ01';
      if QueryBySQL(tmpSQL, Data, 'ORACLE') then
      begin
        RefreshGrdCaption(l_SalCDS, DBGridEh2, l_StrIndex2, l_StrIndexDesc2);
        l_SalCDS.Data:=Data;

        //***排除本地已結案的
        g_StatusBar.Panels[0].Text:=CheckLang('正在處理訂單結案狀況...');
        Application.ProcessMessages;
        tmpSQL:='';
        with l_SalCDS do
        begin
          First;
          while not Eof do
          begin
            Edit;
            FieldByName('adate').AsString:='';
            FieldByName('sqty').Clear;
            Post;
            tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('oea01').AsString);
            Next;
          end;
        end;
        if Length(tmpSQL)>0 then
        begin
          Delete(tmpSQL,1,1);
          Data:=null;
          tmpSQL:='Select Right(Bu,2) Bu,Orderno,Orderitem From MPS300'
                 +' Where Flag=1 And Orderno in ('+tmpSQL+')';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data:=Data;
            with tmpCDS do
            while not Eof do
            begin
              while l_SalCDS.Locate('dbtype;oea01;oeb03',
                  VarArrayOf([Fields[0].AsString,
                              Fields[1].AsString,
                              Fields[2].AsInteger]),[]) do
                l_SalCDS.Delete;
              Next;
            end;
          end;
        end;
        //***

        //***達交日期
        g_StatusBar.Panels[0].Text:=CheckLang('正在處理達交日期...');
        Application.ProcessMessages;
        tmpSQL:='';
        tmpPPFilter:='';
        tmpCCLFilter:='';
        with l_SalCDS do
        begin
          First;
          while not Eof do
          begin
            tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('oea01').AsString+'@'+FieldByName('oeb03').AsString);
            if Pos(LeftStr(FieldByName('oeb04').AsString,1),'ET')>0 then
               tmpCCLFilter:=tmpCCLFilter+','+Quotedstr(FieldByName('oea01').AsString+'@'+FieldByName('oeb03').AsString+'@'+FieldByName('oeb04').AsString)
            else
               tmpPPFilter:=tmpPPFilter+','+Quotedstr(FieldByName('oea01').AsString+'@'+FieldByName('oeb03').AsString+'@'+FieldByName('oeb04').AsString);
            Next;
          end;
        end;
        if Length(tmpSQL)>0 then
        begin
          Delete(tmpSQL,1,1);
          Data:=null;
          tmpSQL:='Select Right(Bu,2) Bu,Orderno,Orderitem,Adate,Cdate From MPS200'
                 +' Where Orderno+''@''+Cast(Orderitem as varchar(10)) in ('+tmpSQL+')';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data:=Data;
            with tmpCDS do
            while not Eof do
            begin
              if l_SalCDS.Locate('dbtype;oea01;oeb03',
                  VarArrayOf([Fields[0].AsString,
                              Fields[1].AsString,
                              Fields[2].AsInteger]),[]) then
                begin
                  if Fields[4].IsNull then
                  begin
                    if Fields[3].IsNull then
                       tmpSQL:=''
                    else
                       tmpSQL:= Fields[3].AsString;
                  end else
                    tmpSQL:= Fields[4].AsString;
                  if (Length(tmpSQL)>0) and
                     (Pos(tmpSQL, l_SalCDS.FieldByName('Adate').AsString)=0) then
                  begin
                    tmpSQL:=l_SalCDS.FieldByName('Adate').AsString+' '+tmpSQL;
                    l_SalCDS.Edit;
                    l_SalCDS.FieldByName('Adate').AsString:=Trim(tmpSQL);
                    l_SalCDS.Post;
                  end;
                end;
              Next;
            end;
          end;
        end;
        //***

        //排製數量
        g_StatusBar.Panels[0].Text:=CheckLang('正在處理排製數量...');
        Application.ProcessMessages;
        if Length(tmpCCLFilter)>0 then  //ccl
        begin
          Delete(tmpCCLFilter,1,1);
          Data:=null;
          if l_isDG then
             tmpSQL:='Select dbtype,Orderno,OrderItem,Materialno,SUM(Sqty) Sqty From('
                    +' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS010 Where Bu=''ITEQDG'' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpCCLFilter+')'
                    +' Union All'
                    +' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS012 Where Bu=''ITEQDG'' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(IsEmpty,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpCCLFilter+')) X'
                    +' Group By Orderno,OrderItem,Materialno,dbtype'
          else
             tmpSQL:='Select dbtype,Orderno,OrderItem,Materialno,SUM(Sqty) Sqty From('
                    +' Select '+Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)
                    +' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpCCLFilter+')'
                    +' Union All'
                    +' Select '+Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS012 Where Bu='+Quotedstr(g_UInfo^.BU)
                    +' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(IsEmpty,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpCCLFilter+')) X'
                    +' Group By Orderno,OrderItem,Materialno,dbtype';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data:=Data;
            with tmpCDS do
            while not Eof do
            begin
              if l_SalCDS.Locate('dbtype;oea01;oeb03;oeb04',
                  VarArrayOf([Fields[0].AsString,
                              Fields[1].AsString,
                              Fields[2].AsInteger,
                              Fields[3].AsString]),[]) then
                begin
                  l_SalCDS.Edit;
                  l_SalCDS.FieldByName('Sqty').AsFloat:=Fields[4].AsFloat;
                  l_SalCDS.Post;
                end;
              Next;
            end;
          end;
        end;

        if Length(tmpPPFilter)>0 then  //pp
        begin
          Delete(tmpPPFilter,1,1);
          Data:=null;
          if l_isDG then
             tmpSQL:='Select dbtype,Orderno,OrderItem,Materialno,SUM(Sqty) Sqty From('
                    +' Select Case When SrcFlag in (1,3,5) Then ''DG'' Else ''GZ'' End dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS070 Where Bu=''ITEQDG'' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpPPFilter+')) X'
                    +' Group By Orderno,OrderItem,Materialno,dbtype'
          else
             tmpSQL:='Select dbtype,Orderno,OrderItem,Materialno,SUM(Sqty) Sqty From('
                    +' Select '+Quotedstr(RightStr(g_UInfo^.BU,2))+' dbtype,'
                    +' Orderno,OrderItem,Materialno,Sqty'
                    +' From MPS070 Where Bu='+Quotedstr(g_UInfo^.BU)
                    +' And Sdate>='+Quotedstr(DateToStr(Date))
                    +' And isnull(EmptyFlag,0)=0 and isnull(ErrorFlag,0)=0 And Sqty>0'
                    +' And Orderno+''@''+Cast(OrderItem as varchar(10))+''@''+Materialno in ('+tmpPPFilter+')) X'
                    +' Group By Orderno,OrderItem,Materialno,dbtype';
          if QueryBySQL(tmpSQL, Data) then
          begin
            tmpCDS.Data:=Data;
            with tmpCDS do
            while not Eof do
            begin
              if l_SalCDS.Locate('dbtype;oea01;oeb03;oeb04',
                  VarArrayOf([Fields[0].AsString,
                              Fields[1].AsString,
                              Fields[2].AsInteger,
                              Fields[3].AsString]),[]) then
                begin
                  l_SalCDS.Edit;
                  l_SalCDS.FieldByName('Sqty').AsFloat:=Fields[4].AsFloat;
                  l_SalCDS.Post;
                end;
              Next;
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
      if ChangeCount>0 then
         MergeChangeLog;
      EnableControls;
      AfterScroll:=l_SalCDSAfterScroll;
      if Active then
         First;
    end;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPST000.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (Pos('管制',l_StkCDS.FieldByName('ta_img04').AsString)>0) or
     (Pos('管製',l_StkCDS.FieldByName('ta_img04').AsString)>0) or
     (Pos('專案',l_StkCDS.FieldByName('ta_img04').AsString)>0) then
     AFont.Color:=clRed
  else if Length(l_StkCDS.FieldByName('cjremark').AsString)>0 then
     AFont.Color:=clBlue;
end;

procedure TFrmMPST000.Timer1Timer(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Timer1.Enabled:=False;
  try
    if l_List2.Count=0 then
       Exit;

    while l_List2.Count>1 do
      l_List2.Delete(l_List2.Count-1);

    tmpSQL:=l_List2.Strings[0];
    if tmpSQL=l_SQL2 then Exit;
    l_SQL2:=tmpSQL;
    if QueryBySQL(tmpSQL, Data) then
       l_MpsCDS.Data:=Data;
  finally
    Timer1.Enabled:=True;
  end;
end;

end.
