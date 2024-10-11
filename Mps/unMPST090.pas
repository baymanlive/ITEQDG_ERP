unit unMPST090;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI040, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, ComCtrls, StdCtrls, ToolWin, StrUtils, Math, unGridDesign;

type
  TFrmMPST090 = class(TFrmSTDI040)
    TabSheet2: TTabSheet;
    DBGridEh2: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    btn_mpst090: TToolButton;
    btn_mpst090_export: TToolButton;
    ToolButton1: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh1ColWidthsChanged(Sender: TObject);
    procedure DBGridEh2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DBGridEh2ColWidthsChanged(Sender: TObject);
    procedure btn_mpst090Click(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh2CellClick(Column: TColumnEh);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_mpst090_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_gen03:string;
    l_GridDesign1,l_GridDesign2:TGridDesign;
    function CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS:TClientDataSet; isCCL:Boolean):string;
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST090: TFrmMPST090;

implementation

uses unGlobal, unCommon, unMPST090_query, unMPST090_Export;

{$R *.dfm}

procedure TFrmMPST090.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if (strFilter='0') or (strFilter='1') then
  begin
    tmpSQL:='exec dbo.proc_MPST090 0,'+strFilter;
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;

    Data:=null;
    tmpSQL:='exec dbo.proc_MPST090 1,'+strFilter;
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  end else
  begin
    tmpSQL:='select case_ans1 as checkbox,* from mps010 where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;

    Data:=null;
    tmpSQL:='select case_ans1 as checkbox,* from mps070 where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS2.Data:=Data;
  end;

  inherited;
end;

procedure TFrmMPST090.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS010';
  p_GridDesignAns:=False;
  btn_mpst090.Visible:=g_MInfo^.R_edit;
  btn_mpst090_export.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
  begin
    btn_mpst090.Left := btn_quit.Left;
    btn_mpst090_export.Left := btn_quit.Left;
  end;

  inherited;

  TabSheet1.Caption:=CheckLang('CCL�Ƶ{���');
  TabSheet2.Caption:=CheckLang('PP�Ƶ{���');
  SetGrdCaption(DBGridEh2, 'MPS070');
  
  DBGridEh1.FieldColumns['CheckBox'].Title.Caption:=CheckLang('�襤');
  DBGridEh2.FieldColumns['CheckBox'].Title.Caption:=CheckLang('�襤');
  DBGridEh1.FieldColumns['CheckBox'].Width:=40;
  DBGridEh2.FieldColumns['CheckBox'].Width:=40;

  DBGridEh1.FieldColumns['iscreate'].Title.Caption:=CheckLang('�w����');
  DBGridEh2.FieldColumns['iscreate'].Title.Caption:=CheckLang('�w����');
  DBGridEh1.FieldColumns['iscreate'].Width:=50;
  DBGridEh2.FieldColumns['iscreate'].Width:=50;

  DBGridEh1.FieldColumns['isdomestic'].Title.Caption:=CheckLang('���P');
  DBGridEh2.FieldColumns['isdomestic'].Title.Caption:=CheckLang('���P');
  DBGridEh1.FieldColumns['isdomestic'].Width:=50;
  DBGridEh2.FieldColumns['isdomestic'].Width:=50;

  DBGridEh1.FieldColumns['isdg'].Title.Caption:=CheckLang('DG�q��');
  DBGridEh2.FieldColumns['isdg'].Title.Caption:=CheckLang('DG�q��');
  DBGridEh1.FieldColumns['isdg'].Width:=60;
  DBGridEh2.FieldColumns['isdg'].Width:=60;

  l_GridDesign1:=TGridDesign.Create(DBGridEh1, 'MPST090_1');
  l_GridDesign2:=TGridDesign.Create(DBGridEh2, 'MPST090_2');
end;

procedure TFrmMPST090.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS2.Active:=False;
  DBGridEh2.Free;
  FreeAndNil(l_GridDesign1);
  FreeAndNil(l_GridDesign2);
end;

procedure TFrmMPST090.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPST090_query) then
     FrmMPST090_query:=TFrmMPST090_query.Create(Application);
  if FrmMPST090_query.ShowModal=mrOK then
     RefreshDS(IntToStr(FrmMPST090_query.RadioGroup1.ItemIndex));
end;

procedure TFrmMPST090.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'checkbox') then
  begin
    CDS.Edit;
    CDS.FieldByName('checkbox').AsBoolean:=not CDS.FieldByName('checkbox').AsBoolean;
    CDS.Post;
    CDS.MergeChangeLog;
  end;
end;

procedure TFrmMPST090.DBGridEh2CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS2.Active) or CDS2.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'checkbox') then
  begin
    CDS2.Edit;
    CDS2.FieldByName('checkbox').AsBoolean:=not CDS2.FieldByName('checkbox').AsBoolean;
    CDS2.Post;
    CDS2.MergeChangeLog;
  end;
end;

procedure TFrmMPST090.DBGridEh1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign1) then
     l_GridDesign1.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPST090.DBGridEh1ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign1) then
     l_GridDesign1.ColWidthChange;
end;

procedure TFrmMPST090.DBGridEh2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.MouseDown(Button=mbRight, X, Y);
end;

procedure TFrmMPST090.DBGridEh2ColWidthsChanged(Sender: TObject);
begin
  inherited;
  if Assigned(l_GridDesign2) then
     l_GridDesign2.ColWidthChange;
end;

procedure TFrmMPST090.btn_mpst090Click(Sender: TObject);
const gzMachine='L6,T6,T7,T8';
const gzLstCode='G,n,z,w,k,9,r,h,s,v,F';
const dgLstCode='X,N,W,K,H,3,9,R,S,1,V';
var
  isCCL:Boolean;
  tmpSQL,tmpPMK01,tmpPMK02:string;
  tmpCDS,oebCDS,pmkCDS,pmlCDS,tc_pmlCDS,genCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if (PCL.ActivePageIndex=0) and ((not CDS.Active) or CDS.IsEmpty) then
  begin
    ShowMsg('['+PCL.Pages[0].Caption+']����ܥ�����!',48);
    Exit;
  end;

  if (PCL.ActivePageIndex=1) and ((not CDS2.Active) or CDS2.IsEmpty) then
  begin
    ShowMsg('['+PCL.Pages[1].Caption+']����ܥ�����!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  oebCDS:=TClientDataSet.Create(nil);
  pmkCDS:=TClientDataSet.Create(nil);
  pmlCDS:=TClientDataSet.Create(nil);
  tc_pmlCDS:=TClientDataSet.Create(nil);
  genCDS:=TClientDataSet.Create(nil);
  try
    //���
    if PCL.ActivePageIndex=0 then
    begin
      isCCL:=True;
      tmpCDS.Data:=CDS.Data;
    end else
    begin
      isCCL:=False;
      tmpCDS.Data:=CDS2.Data;
    end;
    //*

    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1';
    tmpCDS.Filtered:=True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('['+PCL.Pages[PCL.ActivePageIndex].Caption+']����ܥ�����!',48);
      Exit;
    end;

    if tmpCDS.RecordCount>100 then
    begin
      ShowMsg('�̦h�i��100��,�Э��s���!',48);
      Exit;
    end;

    tmpSQL:='';
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL:=tmpSQL+' or (oeb01='+Quotedstr(tmpCDS.FieldByName('orderno').AsString)
                    +' and oeb03='+IntToStr(tmpCDS.FieldByName('orderitem').AsInteger)+')';

      if (tmpCDS.FieldByName('isdg').AsString='Y') and
         (Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)=0) then
      begin
        ShowMsg('�F��q��F��Ͳ����i���!',48);
        Exit;
      end;

      if (tmpCDS.FieldByName('isdg').AsString='N') and
         (Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)>0) then
      begin
        ShowMsg('�s�{�q��s�{�Ͳ����i���!',48);
        Exit;
      end;

      tmpCDS.Next;
    end;

    if tmpCDS.Locate('iscreate','Y',[]) then
    begin
      if ShowMsg('�s�b�w���ͽ��ʳ檺���'+#13#10+'�T�w�~�򲣥ͽ��ʳ��?',33)=IdCancel then
         Exit;
    end else
    if ShowMsg('�T�w���ͽ��ʳ��?',33)=IdCancel then
       Exit;

    //�q����
    g_StatusBar.Panels[0].Text:=CheckLang('���b�d�߭q����...');
    Application.ProcessMessages;
    Delete(tmpSQL,1,3);
    Data:=null;
    if tmpCDS.FieldByName('isdg').AsString='Y' then
       tmpSQL:='select * from iteqdg.oeb_file where '+tmpSQL
    else
       tmpSQL:='select * from iteqgz.oeb_file where '+tmpSQL;
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    oebCDS.Data:=Data;

    //�ˬd�Ƹ��Χ��X
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpSQL:='['+tmpCDS.FieldByName('orderno').AsString+'/'+tmpCDS.FieldByName('orderitem').AsString+']';

      if not oebCDS.Locate('oeb01;oeb03',
           VarArrayOf([tmpCDS.FieldByName('orderno').AsString,
                       tmpCDS.FieldByName('orderitem').AsInteger]),[]) then
      begin
        ShowMsg(tmpSQL+'�q�椣�s�b!',48);
        Exit;
      end;

      //pn���ˬd
      if not (Length(oebCDS.FieldByName('oeb04').AsString) in [11,12,19,20]) then
      begin
        //if RightStr(oebCDS.FieldByName('oeb04').AsString,1)<>RightStr(tmpCDS.FieldByName('materialno').AsString,1) then
        //begin
        //  ShowMsg(tmpSQL+'�P��l�q����X���ۦP,���i���!',48);
        //  Exit;
        //end;

        if Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)>0 then
        begin
          if Pos(RightStr(tmpCDS.FieldByName('materialno').AsString,1), gzLstCode)=0 then
          begin
            ShowMsg(tmpSQL+'���X�D'+gzLstCode+'���i���!',48);
            Exit;
          end;
        end;

        if Pos(tmpCDS.FieldByName('machine').AsString, gzMachine)=0 then
        begin
          if Pos(RightStr(tmpCDS.FieldByName('materialno').AsString,1), dgLstCode)=0 then
          begin
            ShowMsg(tmpSQL+'���X�D'+dgLstCode+'���i���!',48);
            Exit;
          end;
        end;
      end;

      tmpCDS.Next;
    end;

    if Length(l_gen03)=0 then
    begin
      //�����s��
      g_StatusBar.Panels[0].Text:=CheckLang('���b�d�߳����s��...');
      Application.ProcessMessages;
      Data:=null;
      tmpSQL:='select gen03 from gen_file where gen01='+Quotedstr(UpperCase(g_UInfo^.UserId));
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;
      genCDS.Data:=Data;
      //*

      if not genCDS.IsEmpty then
         l_gen03:=genCDS.Fields[0].AsString;

      if Length(l_gen03)=0 then
      begin
        ShowMsg('�L�����s��,�нT�{!',48);
        Exit;
      end;
    end;

    //���ʳ�
    g_StatusBar.Panels[0].Text:=CheckLang('���b�d�߽��ʳ���...');
    Application.ProcessMessages;
    Data:=null;
    tmpSQL:='select * from pmk_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmkCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    pmlCDS.Data:=Data;

    Data:=null;
    tmpSQL:='select * from tc_pml_file where 1=2';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tc_pmlCDS.Data:=Data;
    //*

    //���P
    g_StatusBar.Panels[1].Text:=CheckLang('���b���ͤ��P���ʳ�...');
    Application.ProcessMessages;
    tmpPMK01:='';
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1 and isdomestic=''Y''';
    tmpCDS.Filtered:=True;
    if not tmpCDS.IsEmpty then
    begin
      tmpPMK01:=CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, isCCL);
      if Length(tmpPMK01)=0 then
         Exit;
    end;

    //�~�P
    g_StatusBar.Panels[1].Text:=CheckLang('���b���ͥ~�P���ʳ�...');
    Application.ProcessMessages;
    tmpPMK02:='';
    pmkCDS.EmptyDataSet;
    pmlCDS.EmptyDataSet;
    tc_pmlCDS.EmptyDataSet;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='checkbox=1 and isdomestic=''N''';
    tmpCDS.Filtered:=True;
    if not tmpCDS.IsEmpty then
       tmpPMK02:=CallData(tmpCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS, isCCL);
    g_StatusBar.Panels[1].Text:='';
    Application.ProcessMessages;

    if isCCL then
       CDS.CancelUpdates
    else
       CDS2.CancelUpdates;

    if Length(tmpPMK02)>0 then
       if Length(tmpPMK01)>0 then
          tmpPMK01:=tmpPMK01+','+tmpPMK02
       else
          tmpPMK01:=tmpPMK02;
    if Length(tmpPMK01)>0 then
       ShowMsg('���槹��,���ʳ渹:'+tmpPMK01,64);

  finally
    FreeAndNil(tmpCDS);
    FreeAndNil(oebCDS);
    FreeAndNil(pmkCDS);
    FreeAndNil(pmlCDS);
    FreeAndNil(tc_pmlCDS);
    FreeAndNil(genCDS);
    g_StatusBar.Panels[0].Text:='';
    g_StatusBar.Panels[1].Text:='';
  end;
end;

//��^���ʳ渹
function TFrmMPST090.CallData(sourceCDS, oebCDS, pmkCDS, pmlCDS, tc_pmlCDS:TClientDataSet;
  isCCL:Boolean):string;
var
  tmpSQL,tmpDBType,tmpPMK01:String;
  tmpCDS,imaCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:='';

  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    if not oebCDS.Locate('oeb01;oeb03',
         VarArrayOf([sourceCDS.FieldByName('orderno').AsString,
                     sourceCDS.FieldByName('orderitem').AsInteger]),[]) then
    begin
      ShowMsg('['+sourceCDS.FieldByName('orderno').AsString+'/'+sourceCDS.FieldByName('orderitem').AsString+']�q�椣�s�b!',48);
      Exit;
    end;

    //pmlCDS���ʳ�樭
    pmlCDS.Append;
    pmlCDS.FieldByName('pml01').AsString:='?';        //�渹
    pmlCDS.FieldByName('pml011').AsString:='TAP';     //��کʽ�:TAP�h���N����
    pmlCDS.FieldByName('pml02').AsInteger:=pmlCDS.RecordCount+1;  //����
    pmlCDS.FieldByName('pml04').AsString:='?';        //�Ƹ�
    pmlCDS.FieldByName('pml041').AsString:='?';       //�~�Wima02
    pmlCDS.FieldByName('pml06').AsString:=oebCDS.FieldByName('oeb01').AsString+'-'+oebCDS.FieldByName('oeb03').AsString; //�Ƶ�
    pmlCDS.FieldByName('pml08').AsString:='?';        //�w�s���ima25
    pmlCDS.FieldByName('pml09').AsFloat:=oebCDS.FieldByName('oeb05_fac').AsFloat;  //����ഫ�v
    pmlCDS.FieldByName('pml11').AsString:='N';        //�ᵲ�X
    pmlCDS.FieldByName('pml121').AsInteger:=0;        //�M�ץN��-����
    pmlCDS.FieldByName('pml122').AsInteger:=0;        //�M�ץN��-����
    pmlCDS.FieldByName('pml13').AsFloat:=0;           //���\�i�W��/�u��ƶq��v
    pmlCDS.FieldByName('pml14').AsString:='Y';        //������f�_
    pmlCDS.FieldByName('pml15').AsString:='Y';        //���e��f�_
    pmlCDS.FieldByName('pml16').AsString:='1';        //���p�X:0�}��,1�֭�
    pmlCDS.FieldByName('pml18').AsDateTime:=EncodeDate(1899,12,31);  //MRP�ݨD���

    //�B�z���ʮƸ�,���,�ƶq
    //dg�q��,�s�{����
    if SourceCDS.FieldByName('isdg').AsString='Y' then
    begin
      if isCCL then
      begin
        if Length(oebCDS.FieldByName('oeb04').AsString) in [11,19] then //ccl pnl
        begin
          pmlCDS.FieldByName('pml07').AsString:='PN';
          pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;         //���ʭ�q��Ƹ�
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end else
        begin
          pmlCDS.FieldByName('pml07').AsString:='SH';
          pmlCDS.FieldByName('pml04').AsString:=SourceCDS.FieldByName('materialno').AsString; //���ʱƵ{�Ƹ�
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end;
      end else
      begin
        if Length(oebCDS.FieldByName('oeb04').AsString) in [12,20] then //pp pnl
        begin
          pmlCDS.FieldByName('pml07').AsString:='RL';
          pmlCDS.FieldByName('pml04').AsString:=SourceCDS.FieldByName('materialno').AsString; //���ʱƵ{�Ƹ�
          pmlCDS.FieldByName('pml20').AsFloat:=RoundTo(SourceCDS.FieldByName('sqty').AsFloat/StrToInt(Copy(SourceCDS.FieldByName('materialno').AsString,11,3)),-3);
        end else
        begin
          pmlCDS.FieldByName('pml07').AsString:='RL';
          pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;         //���ʭ�q��Ƹ�
          pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
        end;
      end;
    end else  //gz�q��,dg����(�LPNL)
    begin
      if Length(oebCDS.FieldByName('oeb04').AsString) in [11,12,19,20] then
         pmlCDS.FieldByName('pml07').AsString:='PN'
      else if Length(oebCDS.FieldByName('oeb04').AsString)=18 then
         pmlCDS.FieldByName('pml07').AsString:='RL'
      else
         pmlCDS.FieldByName('pml07').AsString:='SH';
      pmlCDS.FieldByName('pml04').AsString:=oebCDS.FieldByName('oeb04').AsString;
      pmlCDS.FieldByName('pml20').AsFloat:=oebCDS.FieldByName('oeb12').AsFloat;
    end;

    pmlCDS.FieldByName('pml21').AsFloat:=0;
    pmlCDS.FieldByName('pml23').AsString:='Y';        //�ҵ|�_
    pmlCDS.FieldByName('pml30').AsFloat:=0;           //�����зǻ���
    pmlCDS.FieldByName('pml31').AsFloat:=0;           //���|���
    pmlCDS.FieldByName('pml31t').AsFloat:=0;          //�t�|���
    pmlCDS.FieldByName('pml32').AsFloat:=0;           //���ʻ��t
    pmlCDS.FieldByName('pml33').AsDateTime:=Date+7;   //��f���
    pmlCDS.FieldByName('pml34').AsDateTime:=pmlCDS.FieldByName('pml33').AsDateTime;  //��t���
    pmlCDS.FieldByName('pml35').AsDateTime:=pmlCDS.FieldByName('pml33').AsDateTime;  //��w���
    pmlCDS.FieldByName('pml38').AsString:='Y';        //�i��/���i��
    pmlCDS.FieldByName('pml42').AsString:='0';        //���N�X0:��l�ƥ�,���i�Q���N
    pmlCDS.FieldByName('pml43').AsInteger:=0;         //�@�~�Ǹ�
    pmlCDS.FieldByName('pml431').AsInteger:=0;        //�U�@���@�~�Ǹ�
    pmlCDS.FieldByName('pml67').AsString:=l_gen03;    //�����s��
    pmlCDS.Post;
    //*

    //�O�s���ʮƸ��B�ƶq
    sourceCDS.Edit;
    sourceCDS.FieldByName('p_pno').AsString:=pmlCDS.FieldByName('pml04').AsString;
    sourceCDS.FieldByName('p_qty').AsFloat:=pmlCDS.FieldByName('pml20').AsFloat;
    sourceCDS.Post;

    //�X�i���
    tc_pmlCDS.Append;
    //tc_pmlCDS.FieldByName('tc_pml03').AsString:='1' //��� 1.MM 2.INCH  ���|�B�z,���ޤF
    if Length(pmlCDS.FieldByName('pml04').AsString) in [11,12,19,20] then
    begin
      tc_pmlCDS.FieldByName('tc_pml03').AsString:='2';
      tc_pmlCDS.FieldByName('tc_pml01').AsFloat:=oebCDS.FieldByName('ta_oeb01').AsFloat;      //�g��
      tc_pmlCDS.FieldByName('tc_pml02').AsFloat:=oebCDS.FieldByName('ta_oeb02').AsFloat;      //�n��
      tc_pmlCDS.FieldByName('tc_pml04').AsString:=oebCDS.FieldByName('ta_oeb04').AsString;    //CCL�ؤo�N�X
      tc_pmlCDS.FieldByName('tc_pml05').AsString:=oebCDS.FieldByName('ta_oeb05').AsString ;   //�����X
      tc_pmlCDS.FieldByName('tc_pml06').AsString:=oebCDS.FieldByName('ta_oeb06').AsString ;   //�ɺ�X
      tc_pmlCDS.FieldByName('tc_pml07').AsString:=oebCDS.FieldByName('ta_oeb07').AsString;    //���Ť覡
      tc_pmlCDS.FieldByName('tc_pml08').AsInteger:=oebCDS.FieldByName('ta_oeb08').AsInteger;  //�ֵ�
      tc_pmlCDS.FieldByName('tc_pml09').AsString:=oebCDS.FieldByName('ta_oeb09').AsString ;   //�ɨ�
    end;

    tc_pmlCDS.FieldByName('tc_pml10').AsString:='?';   //���ʳ渹
    tc_pmlCDS.FieldByName('tc_pml11').AsInteger:=tc_pmlCDS.RecordCount+1;  //���ʳ涵��
    tc_pmlCDS.Post;
    //*

    sourceCDS.Next;
  end;

  //pmlCDS���ʳ���Y
  pmkCDS.Append;
  pmkCDS.FieldByName('pmk01').AsString:='?';                                     //�渹
  pmkCDS.FieldByName('pmk02').AsString:='TAP';                                   //��کʽ�:TAP�h���N����
  pmkCDS.FieldByName('pmk03').AsInteger:=0;                                      //������ʧǸ�
  pmkCDS.FieldByName('pmk04').AsDateTime:=Date;                                  //���ʤ��
                                                                                 //������pmk09
  if SourceCDS.FieldByName('isdg').AsString='N' then                             //gz�q��,dg����
     pmkCDS.FieldByName('pmk09').AsString:='N005'
  else if SourceCDS.FieldByName('isdomestic').AsString='Y' then                  //dg�q��,gz����,���P
     pmkCDS.FieldByName('pmk09').AsString:='N012'
  else                                                                           //dg�q��,gz����,�~�P
     pmkCDS.FieldByName('pmk09').AsString:='N018';
  pmkCDS.FieldByName('pmk12').AsString:=UpperCase(g_UInfo^.UserId); //���ʭ�
  pmkCDS.FieldByName('pmk13').AsString:=l_gen03;                                 //���ʳ���
  pmkCDS.FieldByName('pmk14').AsString:=l_gen03;                                 //���f����
  pmkCDS.FieldByName('pmk15').AsString:=pmkCDS.FieldByName('pmk12').AsString;    //���f�T�{�H
  pmkCDS.FieldByName('pmk18').AsString:='Y';                                     //�T�{�_
  pmkCDS.FieldByName('pmk25').AsString:='1';                                     //0:�}��,1:�֭�
  pmkCDS.FieldByName('pmk27').AsDateTime:=Date;                                  //���p���ʤ��
  pmkCDS.FieldByName('pmk30').AsString:='Y';                                     //���f��C�L�_
  pmkCDS.FieldByName('pmk40').AsFloat:=0;                                        //����
  pmkCDS.FieldByName('pmk401').AsFloat:=0;                                       //����
  pmkCDS.FieldByName('pmk42').AsFloat:=1;                                        //�ײv
  pmkCDS.FieldByName('pmk43').AsFloat:=0;                                        //�|�v
  pmkCDS.FieldByName('pmk45').AsString:='Y';                                     //�i��/���i��
  pmkCDS.FieldByName('pmkprno').AsInteger:=0;                                    //�C�L����
  pmkCDS.FieldByName('pmkmksg').AsString:='N';                                   //�O�_ñ��
  pmkCDS.FieldByName('pmkdays').AsInteger:=0;                                    //ñ�֧����Ѽ�
  pmkCDS.FieldByName('pmksseq').AsInteger:=0;                                    //�wñ�ֶ���
  pmkCDS.FieldByName('pmksmax').AsInteger:=0;                                    //��ñ�ֶ���
  pmkCDS.FieldByName('pmkacti').AsString:='Y';                                   //��Ʀ��ĽX
  pmkCDS.FieldByName('pmkuser').AsString:=pmkCDS.FieldByName('pmk12').AsString;  //��ƩҦ���
  pmkCDS.FieldByName('pmkgrup').AsString:=l_gen03;                               //��ƩҦ�����
  pmkCDS.Post;
  //*

  if SourceCDS.FieldByName('isdg').AsString='Y' then
     tmpDBType:='ORACLE'
  else
     tmpDBType:='ORACLE1';

  //�B�z�~�W,�w�s���
  g_StatusBar.Panels[0].Text:=CheckLang('���b�d�ߪ��~���...');
  Application.ProcessMessages;
  tmpSQL:='';
  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    tmpSQL:=tmpSQL+','+Quotedstr(pmlCDS.FieldByName('pml04').AsString);
    pmlCDS.Next;
  end;
  Delete(tmpSQL,1,1);

  imaCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='select ima01,ima02,ima25 from ima_file where ima01 in ('+tmpSQL+')';
    if not QueryBySQL(tmpSQL, Data, tmpDBType) then
       Exit;

    imaCDS.Data:=Data;
    pmlCDS.First;
    while not pmlCDS.Eof do
    begin
      if not imaCDS.Locate('ima01',pmlCDS.FieldByName('pml04').AsString,[]) then
      begin
        ShowMsg('�ƥ�򥻸�Ƨ䤣��['+pmlCDS.FieldByName('pml04').AsString+']',48);
        Exit;
      end;

      pmlCDS.Edit;
      pmlCDS.FieldByName('pml041').AsString:=imaCDS.FieldByName('ima02').AsString;
      pmlCDS.FieldByName('pml08').AsString:=imaCDS.FieldByName('ima25').AsString;
      pmlCDS.Post;
      pmlCDS.Next;
    end;
  finally
    FreeAndNil(imaCDS);
  end;

  //�B�z�渹
  g_StatusBar.Panels[0].Text:=CheckLang('���b�p����ʳ�y����...');
  Application.ProcessMessages;
  if SourceCDS.FieldByName('isdomestic').AsString='Y' then
     tmpPMK01:='317-'+GetYM     //317
  else
     tmpPMK01:='313-'+GetYM;    //313
  //tmpPMK01:='XXX-'+GetYM;       //���ճ�O
  Data:=null;
  tmpSQL:='select nvl(max(pmk01),'''') as pmk01 from pmk_file'
         +' where pmk01 like ''' + tmpPMK01 + '%''';
  if not QueryOneCR(tmpSQL, Data, tmpDBType) then
     Exit;
  tmpPMK01:=GetNewNo(tmpPMK01, VarToStr(Data));

  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    pmlCDS.Edit;
    pmlCDS.FieldByName('pml01').AsString:=tmpPMK01;
    pmlCDS.Post;
    pmlCDS.Next;
  end;

  tc_pmlCDS.First;
  while not tc_pmlCDS.Eof do
  begin
    tc_pmlCDS.Edit;
    tc_pmlCDS.FieldByName('tc_pml10').AsString:=tmpPMK01;
    tc_pmlCDS.Post;
    tc_pmlCDS.Next;
  end;

  pmkCDS.Edit;
  pmkCDS.FieldByName('pmk01').AsString:=tmpPMK01;
  pmkCDS.Post;
  //*

  //�x�s
  g_StatusBar.Panels[0].Text:=CheckLang('���b�x�s���...');
  Application.ProcessMessages;
  if not CDSPost(pmkCDS, 'pmk_file', tmpDBType) then
     Exit;

  if not CDSPost(pmlCDS, 'pml_file', tmpDBType) then
  begin
    ShowMsg('�樭����x�s����'+#13#10+'�жi�Jtiptop�i��@�o�B�z,�渹:'+tmpPMK01,48);
    Exit;
  end;

  if not CDSPost(tc_pmlCDS, 'tc_pml_file', tmpDBType) then
  begin
    ShowMsg('�X�i����x�s����'+#13#10+'�жi�Jtiptop�i��@�o�B�z,�渹:'+tmpPMK01,48);
    Exit;
  end;

  //��soeb_file,ta_oeb39���ʳ渹
  g_StatusBar.Panels[0].Text:=CheckLang('���b��s�q���ɽ��ʳ渹...');
  Application.ProcessMessages;
  pmlCDS.First;
  while not pmlCDS.Eof do
  begin
    tmpSQL:='update oeb_file set ta_oeb39='+Quotedstr(tmpPMK01+'-'+IntToStr(pmlCDS.FieldByName('pml02').AsInteger))
           +' where oeb01='+Quotedstr(LeftStr(pmlCDS.FieldByName('pml06').AsString,10))
           +' and oeb03='+Copy(pmlCDS.FieldByName('pml06').AsString,12,10);
    if not PostBySQL(tmpSQL, tmpDBType) then
    begin
      ShowMsg('��s�q���ɽ��ʳ渹����'+#13#10+'�жi�Jtiptop�i��@�o�B�z,�渹:'+tmpPMK01,48);
      Exit;
    end;

    pmlCDS.Next;
  end;

  //�K�[�w���ͽ��ʳ�O��
  g_StatusBar.Panels[0].Text:=CheckLang('���b�K�[��x���...');
  Application.ProcessMessages;
  tmpSQL:='';
  sourceCDS.First;
  while not sourceCDS.Eof do
  begin
    tmpSQL:=tmpSQL+' or (orderno='+Quotedstr(sourceCDS.FieldByName('orderno').AsString)
                  +' and orderitem='+IntToStr(sourceCDS.FieldByName('orderitem').AsInteger)+')';

    sourceCDS.Next;
  end;
  Delete(tmpSQL,1,3);
  Data:=null;
  if SourceCDS.FieldByName('isdg').AsString='Y' then
     tmpDBType:='ITEQDG'
  else
     tmpDBType:='ITEQGZ';
  tmpSQL:='select * from mps011 where ('+tmpSQL+') and bu='+Quotedstr(tmpDBType);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;

      sourceCDS.First;
      while not sourceCDS.Eof do
      begin
        if tmpCDS.Locate('orderno;orderitem',
            VarArrayOf([sourceCDS.FieldByName('orderno').AsString,
                        sourceCDS.FieldByName('orderitem').AsInteger]),[]) then
        begin
          tmpCDS.Edit;
          tmpCDS.FieldByName('num').AsInteger:=tmpCDS.FieldByName('num').AsInteger+1;
          tmpCDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
          tmpCDS.FieldByName('mdate').AsDateTime:=Now;
        end else
        begin
          tmpCDS.Append;
          tmpCDS.FieldByName('bu').AsString:=tmpDBType;
          tmpCDS.FieldByName('orderno').AsString:=sourceCDS.FieldByName('orderno').AsString;
          tmpCDS.FieldByName('orderitem').AsInteger:=sourceCDS.FieldByName('orderitem').AsInteger;
          tmpCDS.FieldByName('pno').AsString:=sourceCDS.FieldByName('p_pno').AsString;
          tmpCDS.FieldByName('qty').AsFloat:=sourceCDS.FieldByName('p_qty').AsFloat;
          tmpCDS.FieldByName('num').AsInteger:=1;
          tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
          tmpCDS.FieldByName('idate').AsDateTime:=Now;
        end;
        tmpCDS.Post;
        sourceCDS.Next;
      end;

      CDSPost(tmpCDS, 'mps011');
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  g_StatusBar.Panels[0].Text:='';
  Application.ProcessMessages;
  
  Result:=tmpPMK01;
end;

procedure TFrmMPST090.btn_exportClick(Sender: TObject);
begin
  //inherited;
  // if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  if CDS.Active and (PCL.ActivePageIndex=0) then
    GetExportXls(CDS, 'MPS010');

  if CDS2.Active and (PCL.ActivePageIndex=1) then
    GetExportXls(CDS2, 'MPS070');
end;

procedure TFrmMPST090.btn_mpst090_exportClick(Sender: TObject);
begin
  if not Assigned(FrmMPST090_Export) then
     FrmMPST090_Export:=TFrmMPST090_Export.Create(Application);
  FrmMPST090_Export.ShowModal;
end;

end.
