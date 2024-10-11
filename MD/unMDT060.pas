unit unMDT060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, ImgList, ComCtrls, ToolWin, StdCtrls,
  Buttons, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB,
  DBClient, GridsEh, DBAxisGridsEh, DBGridEh, Menus, StrUtils, DateUtils, Math;

type
  TFrmMDT060 = class(TFrmSTDI080)
    DS1: TDataSource;
    CDS1: TClientDataSet;
    Label13: TLabel;
    DBGridEh1: TDBGridEh;
    Label14: TLabel;
    DBGridEh3: TDBGridEh;
    DBGridEh2: TDBGridEh;
    Label16: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    btn_sp: TSpeedButton;
    Edit1: TEdit;
    dtp1: TDateTimePicker;
    Edit2: TEdit;
    dtp2: TDateTimePicker;
    Edit3: TEdit;
    rg1: TRadioGroup;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    chk: TCheckBox;
    Bevel1: TBevel;
    Label15: TLabel;
    Label17: TLabel;
    DBGridEh4: TDBGridEh;
    CDS2: TClientDataSet;
    DS2: TDataSource;
    CDS3: TClientDataSet;
    DS3: TDataSource;
    CDS4: TClientDataSet;
    DS4: TDataSource;
    Bevel2: TBevel;
    qceCDS: TClientDataSet;
    dmaCDS: TClientDataSet;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    PopupMenu2: TPopupMenu;
    N2: TMenuItem;
    PopupMenu3: TPopupMenu;
    N3: TMenuItem;
    PopupMenu4: TPopupMenu;
    N4: TMenuItem;
    Label18: TLabel;
    rgp0: TRadioGroup;
    CDSX: TClientDataSet;
    shbCDS: TClientDataSet;
    tc_silCDS: TClientDataSet;
    tc_sikCDS: TClientDataSet;
    tc_siaCDS: TClientDataSet;
    tc_siyCDS: TClientDataSet;
    tc_shbCDS: TClientDataSet;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_exportClick(Sender: TObject);
    procedure DBGridEh2EditButtonClick(Sender: TObject);
    procedure DBGridEh4EditButtonClick(Sender: TObject);
    procedure CDS2AfterOpen(DataSet: TDataSet);
    procedure CDS4AfterOpen(DataSet: TDataSet);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure PopupMenu3Popup(Sender: TObject);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_spClick(Sender: TObject);
    procedure DBGridEh1EditButtonClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure CDS1BeforePost(DataSet: TDataSet);
    procedure CDS2BeforePost(DataSet: TDataSet);
    procedure CDS3BeforePost(DataSet: TDataSet);
    procedure CDS4BeforePost(DataSet: TDataSet);
    procedure CDS4NewRecord(DataSet: TDataSet);
    procedure CDS1NewRecord(DataSet: TDataSet);
    procedure DBGridEh3EditButtonClick(Sender: TObject);
  private
    { Private declarations }
    procedure GetCode;
    procedure scrapcodeChange(Sender:TField);
    procedure stopcodeChange(Sender:TField);
    function GetMachine: string;
    function CheckWono(var wono:string):Boolean;
    procedure CheckTimeEdt(edt: TEdit);
    procedure CheckTimeGrd;
    function CheckLot:Boolean;
    procedure OpenCDS;
    function Gettc_shb06(machine,wono,pno,custno,tc_shb04:string):Double;
    procedure DelOra(tb,pk,pkvalue:string);
  public
    { Public declarations }
  end;

var
  FrmMDT060: TFrmMDT060;

implementation

uses unGlobal, unCommon, unMDT060_scrapcode, unMDT060_stopcode,
  unMDT060_lot, unMDT060_newlot, unMDT060_img;

const g_Xml1='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="type" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="tc_sia27" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="tc_sia36" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="qty" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml2='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="scrapcode" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="scrapname" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="qty" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml3='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="qty" fieldtype="r8"/>'
            +'<FIELD attrname="img01" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="img02" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="img03" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="ima02" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="ima021" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="img10" fieldtype="r8"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

const g_Xml4='<?xml version="1.0" standalone="yes"?>'
            +'<DATAPACKET Version="2.0">'
            +'<METADATA><FIELDS>'
            +'<FIELD attrname="stopcode" fieldtype="string" WIDTH="20"/>'
            +'<FIELD attrname="stopname" fieldtype="string" WIDTH="100"/>'
            +'<FIELD attrname="date1" fieldtype="date"/>'
            +'<FIELD attrname="time1" fieldtype="string" WIDTH="5"/>'
            +'<FIELD attrname="date2" fieldtype="date"/>'
            +'<FIELD attrname="time2" fieldtype="string" WIDTH="5"/>'
            +'</FIELDS><PARAMS/></METADATA>'
            +'<ROWDATA></ROWDATA>'
            +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMDT060.GetCode;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select qce01,qce03 from '+g_UInfo^.BU+'.qce_file'
         +' where qceacti=''Y'' and length(trim(nvl(qce03,'''')))>0 order by qce01';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     qceCDS.Data:=Data;

  Data:=null;
  tmpSQL:='select dma01,dma02 from '+g_UInfo^.BU+'.dma_file'
         +' where dmaacti=''Y''';
  if QueryBySQL(tmpSQL, Data, 'ORACLE') then
     dmaCDS.Data:=Data;
end;

procedure TFrmMDT060.scrapcodeChange(Sender: TField);
begin
  if not qceCDS.Active then
     GetCode;
  CDS2.FieldByName('scrapname').Clear;
  if qceCDS.Active then
  if qceCDS.Locate('qce01',TField(Sender).AsString,[loCaseInsensitive]) then
     CDS2.FieldByName('scrapname').AsString:=qceCDS.FieldByName('qce03').AsString;
end;

procedure TFrmMDT060.stopcodeChange(Sender: TField);
begin
  if not dmaCDS.Active then
     GetCode;
  CDS4.FieldByName('stopname').Clear;
  if dmaCDS.Active then
  if dmaCDS.Locate('dma01',TField(Sender).AsString,[loCaseInsensitive]) then
     CDS4.FieldByName('stopname').AsString:=dmaCDS.FieldByName('dma02').AsString;
end;

function TFrmMDT060.GetMachine:string;
begin
  case rgp0.ItemIndex of
    0:Result:='TR01';
    1:Result:='TR02';
    2:Result:='TR03';
    3:Result:='TR04';
    4:Result:='TR05';
    else Result:='';
  end;
  if Length(Result)=0 then
     ShowMsg('機臺錯誤!',48);
end;

procedure TFrmMDT060.CheckTimeEdt(edt:TEdit);
var
  s:string;
  v1,v2:Integer;
begin
  s:=edt.Text;
  if Length(s)<>5 then
  begin
    ShowMsg('時間格式錯誤hh:mm',48);
    edt.SetFocus;
    Abort;
  end;
  v1:=StrToIntDef(LeftStr(s,2),-1);
  v2:=StrToIntDef(RightStr(s,2),-1);
  if (v1<0) or (v1>23) or (v2<0) or (v2>59) or (Copy(s,3,1)<>':') then
  begin
    ShowMsg('時間格式錯誤hh:mm',48);
    edt.SetFocus;
    Abort;
  end;
end;

procedure TFrmMDT060.CheckTimeGrd;
var
  s:string;
  v1,v2:Integer;
begin
  s:=CDS4.FieldByName('time1').AsString;
  if Length(s)<>5 then
  begin
    ShowMsg('停機起始時間格式錯誤hh:mm',48);
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('time1');
    Abort;
  end;
  v1:=StrToIntDef(LeftStr(s,2),-1);
  v2:=StrToIntDef(RightStr(s,2),-1);
  if (v1<0) or (v1>23) or (v2<0) or (v2>59) or (Copy(s,3,1)<>':') then
  begin
    ShowMsg('停機起始時間格式錯誤hh:mm',48);
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('time1');
    Abort;
  end;

  s:=CDS4.FieldByName('time2').AsString;
  if Length(s)<>5 then
  begin
    ShowMsg('停機結束時間格式錯誤hh:mm',48);
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('time2');
    Abort;
  end;
  v1:=StrToIntDef(LeftStr(s,2),-1);
  v2:=StrToIntDef(RightStr(s,2),-1);
  if (v1<0) or (v1>23) or (v2<0) or (v2>59) or (Copy(s,3,1)<>':') then
  begin
    ShowMsg('停機結束時間格式錯誤hh:mm',48);
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('time2');
    Abort;
  end;

  if StrToDateTime(DateToStr(CDS4.FieldByName('date1').AsDateTime)+' '+CDS4.FieldByName('time1').AsString)>=
     StrToDateTime(DateToStr(CDS4.FieldByName('date2').AsDateTime)+' '+CDS4.FieldByName('time2').AsString) then
  begin
    ShowMsg('停機起始時間應小于停機結束時間!',48);
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('date1');
    Abort;
  end;
end;

function TFrmMDT060.CheckWono(var wono:string):Boolean;
begin
  Result:=True;
  wono:=UpperCase(Trim(Edit1.Text));
  if (Length(wono)<>10) or (Copy(wono,4,1)<>'-') then
  begin
    ShowMsg('請輸入工單號碼xxx-xxxxxx',48);
    Result:=False;
    Edit1.SetFocus;
  end;
end;

function TFrmMDT060.CheckLot:Boolean;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  tmpWono,tmpMachine:string;
begin
  Result:=False;
  if not CheckWono(tmpWono) then
     Exit;
  tmpMachine:=GetMachine;
  if Length(tmpMachine)=0 then
     Exit;

  tmpSQL:='select tc_six03,tc_six04 from '+g_UInfo^.BU+'.tc_six_file'
         +' where tc_six01='+Quotedstr(tmpWono)
         +' and tc_six08='+Quotedstr(tmpMachine)
         +' and tc_six06=''N''';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with CDS1 do //良品
    begin
      First;
      while not Eof do
      begin
        if not tmpCDS.Locate('tc_six04',UpperCase(FieldByName('lot').AsString),[]) then
        begin
          ShowMsg(FieldByName('lot').AsString+'批號不存在!',48);
          DBGridEh1.SetFocus;
          DBGridEh1.SelectedField:=FieldByName('lot');
          Exit;
        end;
        if tmpCDS.FieldByName('tc_six03').AsInteger=-1 then
        begin
          ShowMsg(FieldByName('lot').AsString+'批號重複!',48);
          DBGridEh1.SetFocus;
          DBGridEh1.SelectedField:=FieldByName('lot');
          Exit;
        end;
        tmpCDS.Edit;
        tmpCDS.FieldByName('tc_six03').AsInteger:=-1;
        tmpCDS.Post;
        tmpCDS.MergeChangeLog;
        Next;
      end;
    end;

    tmpSQL:='';
    with CDS3 do   //領料
    begin
    {  if IsEmpty then
      begin
        ShowMsg('請輸入[%s]',48,myStringReplace(Label16.Caption));
        DBGridEh3.SetFocus;
        DBGridEh3.SelectedField:=FieldByName('lot');
        Exit;
      end;   }
      First;
      while not Eof do
      begin
        tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('lot').AsString);
        Next;
      end;
    end;

    if Length(tmpSQL)>0 then
    begin
      Delete(tmpSQL,1,1);
      Data:=null;
      tmpSQL:='select img01,img02,img03,img04,img10 from '+g_UInfo^.BU+'.img_file'
             +' where img02 in (''N3A12'',''Y3A12'') and img10>0 and img19=''A'''
             +' and img04 in ('+tmpSQL+')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;

      tmpCDS.Data:=Data;
      with CDS3 do
      begin
        First;
        while not Eof do
        begin
          if not tmpCDS.Locate('img04',UpperCase(FieldByName('lot').AsString),[]) then
          begin
            ShowMsg(FieldByName('lot').AsString+'批號不存在!',48);
            DBGridEh3.SetFocus;
            DBGridEh3.SelectedField:=FieldByName('lot');
            Exit;
          end;

          if tmpCDS.FieldByName('img10').AsFloat<FieldByName('qty').AsFloat then
          begin
            ShowMsg(FieldByName('lot').AsString+'庫存量不足,可用庫存量:'+FloatToStr(tmpCDS.FieldByName('img10').AsFloat),48);
            DBGridEh3.SetFocus;
            DBGridEh3.SelectedField:=FieldByName('lot');
            Exit;
          end;

          tmpCDS.Edit;
          tmpCDS.FieldByName('img10').AsFloat:=tmpCDS.FieldByName('img10').AsInteger-FieldByName('qty').AsFloat;
          tmpCDS.Post;
          tmpCDS.MergeChangeLog;

          Edit;
          FieldByName('img01').AsString:=tmpCDS.FieldByName('img01').AsString;
          FieldByName('img02').AsString:=tmpCDS.FieldByName('img02').AsString;
          FieldByName('img03').AsString:=tmpCDS.FieldByName('img03').AsString;
          Post;
          MergeChangeLog;
          Next;
        end;
      end;
    end;

    Result:=True;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMDT060.OpenCDS;
const tmpORA='ORACLE';
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //基本資料
  if not shbCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.shb_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    shbCDS.Data:=Data;
  end else
  begin
    shbCDS.EmptyDataSet;
    shbCDS.MergeChangeLog;
  end;

  //機速
  if not tc_silCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_sil_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    tc_silCDS.Data:=Data;
  end else
  begin
    tc_silCDS.EmptyDataSet;
    tc_silCDS.MergeChangeLog;
  end;

  //入庫
  if not tc_siaCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_sia_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    tc_siaCDS.Data:=Data;
  end else
  begin
    tc_siaCDS.EmptyDataSet;
    tc_siaCDS.MergeChangeLog;
  end;

  //領料
  if not tc_sikCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_sik_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    tc_sikCDS.Data:=Data;
  end else
  begin
    tc_sikCDS.EmptyDataSet;
    tc_sikCDS.MergeChangeLog;
  end;

  //停機
  if not tc_siyCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_siy_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    tc_siyCDS.Data:=Data;
  end else
  begin
    tc_siyCDS.EmptyDataSet;
    tc_siyCDS.MergeChangeLog;
  end;

  //投入工時
  if not tc_shbCDS.Active then
  begin
    Data:=null;
    tmpSQL:='select * from '+g_UInfo^.BU+'.tc_shb_file where 1=0';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    tc_shbCDS.Data:=Data;
  end else
  begin
    tc_shbCDS.EmptyDataSet;
    tc_shbCDS.MergeChangeLog;
  end;
end;

//計算標準工時
function TFrmMDT060.Gettc_shb06(machine,wono,pno,custno,tc_shb04:string):Double;
var
  isPQ:Boolean;
  tmpSQL,tc_iee01:string;
  rc:Double;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=0;

  if (LeftStr(wono,3)='R13') or (Copy(pno,2,1)='S') then
  begin
    Result:=7.5;
    Exit;
  end;

  isPQ:=Pos(LeftStr(pno,1),'PQ')>0;
  if tc_shb04='Y' then
  begin
    if (isPQ and (Copy(pno,4,2)='25')) or ((not isPQ) and (Copy(pno,4,4)='2116')) then
       Result:=3.7647
    else if (isPQ and (Copy(pno,4,2)='15')) or ((not isPQ) and (Copy(pno,4,4)='1086')) then
       Result:=4.6429
    else
       Exit;
  end;

  if custno='AC084' then
  begin
    Result:=6;
    Exit;
  end;

  if (isPQ and (Copy(pno,13,1)='V')) or ((not isPQ) and (Copy(pno,18,1)='V')) then
  begin
    Result:=7.2857;
    Exit;
  end;

  if isPQ then
  begin
    tc_iee01:=LeftStr(Pno,2)+Copy(Pno,4,2);
    try
      rc:=StrToInt(Copy(pno,6,3))/10;
    except
      rc:=0;
    end;
  end else
  begin
    tc_iee01:=LeftStr(Pno,2)+Copy(Pno,4,4);
    try
      rc:=StrToInt(Copy(pno,8,3))/10;
    except
      rc:=0;
    end;
  end;

  tmpSQL:='select tc_iee10 from '+g_UInfo^.Bu+'.tc_iee_file'
         +' where tc_iee01='+Quotedstr(tc_iee01)
         +' and tc_iee04>='+FloatToStr(rc)
         +' and tc_iee05<='+FloatToStr(rc)
         +' and tc_iee06='+Quotedstr(machine)
         +' and tc_iee09=''N''';
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    Result:=tmpCDS.Fields[0].AsFloat;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMDT060.DelOra(tb,pk,pkvalue:string);
var
  tmpSQL:string;
begin
  tmpSQL:='delete from '+tb+' where '+pk+'='+Quotedstr(pkvalue);
  PostBySQL(tmpSQL, 'ORACLE');
end;

procedure TFrmMDT060.FormCreate(Sender: TObject);
begin
  p_TableName:='MDT060';            

  inherited;
  
  Label18.Caption:='';
  btn_print.Caption:=CheckLang('批號預輸入');
  btn_sp.Caption:=btn_query.Caption;
  btn_export.Caption:=CheckLang('重置畫面');
  btn_query.Caption:=CheckLang('確認報工');
  SetGrdCaption(DBGridEh1, p_TableName+'_grd1');
  SetGrdCaption(DBGridEh2, p_TableName+'_grd2');
  SetGrdCaption(DBGridEh3, p_TableName+'_grd3');
  SetGrdCaption(DBGridEh4, p_TableName+'_grd4');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
  InitCDS(CDS1, g_Xml1);
  InitCDS(CDS2, g_Xml2);
  InitCDS(CDS3, g_Xml3);
  InitCDS(CDS4, g_Xml4);
end;

procedure TFrmMDT060.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
  DBGridEh2.Free;
  DBGridEh3.Free;
  DBGridEh4.Free;
end;

procedure TFrmMDT060.DBGridEh1EditButtonClick(Sender: TObject);
var
  tmpWono:string;
begin
  inherited;
  if not CheckWono(tmpWono) then
     Exit;
  FrmMDT060_lot:=TFrmMDT060_lot.Create(nil);
  try
    FrmMDT060_lot.l_wono:=tmpWono;
    if FrmMDT060_lot.ShowModal<>mrOK then
       Exit;
    CDS1.FieldByName('lot').OnChange:=nil;
    if not (CDS1.State in [dsInsert,dsEdit]) then
       CDS1.Edit;
    CDS1.FieldByName('lot').AsString:=FrmMDT060_lot.l_ret;
  finally
    FreeAndNil(FrmMDT060_lot);
  end;
end;

procedure TFrmMDT060.DBGridEh2EditButtonClick(Sender: TObject);
begin
  inherited;
  FrmMDT060_scrapcode:=TFrmMDT060_scrapcode.Create(nil);
  try
    if FrmMDT060_scrapcode.ShowModal<>mrOK then
       Exit;
    CDS2.FieldByName('scrapcode').OnChange:=nil;
    if not (CDS2.State in [dsInsert,dsEdit]) then
       CDS2.Edit;
    CDS2.FieldByName('scrapcode').AsString:=FrmMDT060_scrapcode.l_ret1;
    CDS2.FieldByName('scrapname').AsString:=FrmMDT060_scrapcode.l_ret2;
  finally
    FreeAndNil(FrmMDT060_scrapcode);
    CDS2.FieldByName('scrapcode').OnChange:=scrapcodeChange;
  end;
end;


procedure TFrmMDT060.DBGridEh3EditButtonClick(Sender: TObject);
begin
  inherited;
  FrmMDT060_img:=TFrmMDT060_img.Create(nil);
  try
    if FrmMDT060_img.ShowModal<>mrOK then
       Exit;
    if not (CDS3.State in [dsInsert,dsEdit]) then
       CDS3.Edit;
    CDS3.FieldByName('lot').AsString:=FrmMDT060_img.CDS1.FieldByName('img04').AsString;
    CDS3.FieldByName('ima02').AsString:=FrmMDT060_img.CDS1.FieldByName('ima02').AsString;
    CDS3.FieldByName('ima021').AsString:=FrmMDT060_img.CDS1.FieldByName('ima021').AsString;
    CDS3.FieldByName('img10').AsFloat:=FrmMDT060_img.CDS1.FieldByName('img10').AsFloat;
  finally
    FreeAndNil(FrmMDT060_img);
  end;
end;

procedure TFrmMDT060.DBGridEh4EditButtonClick(Sender: TObject);
begin
  inherited;
  FrmMDT060_stopcode:=TFrmMDT060_stopcode.Create(nil);
  try
    if FrmMDT060_stopcode.ShowModal<>mrOK then
       Exit;
    CDS4.FieldByName('stopcode').OnChange:=nil;
    if not (CDS4.State in [dsInsert,dsEdit]) then
       CDS4.Edit;
    CDS4.FieldByName('stopcode').AsString:=FrmMDT060_stopcode.l_ret1;
    CDS4.FieldByName('stopname').AsString:=FrmMDT060_stopcode.l_ret2;
  finally
    FreeAndNil(FrmMDT060_stopcode);
    CDS4.FieldByName('stopcode').OnChange:=stopcodeChange;
  end;
end;

procedure TFrmMDT060.CDS1NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('type').AsString:=DBGridEh1.FieldColumns['type'].PickList.Strings[2];
  DataSet.FieldByName('tc_sia36').AsString:='X';
  if Length(Label18.Caption)>0 then
  begin
    if Pos(LeftStr(Label18.Caption,1),'PQ')=0 then
    begin
      DataSet.FieldByName('tc_sia27').AsString:='PA01';
      DataSet.FieldByName('qty').AsFloat:=StrToInt(Copy(Label18.Caption,11,3));
    end else
    begin
      DataSet.FieldByName('tc_sia27').AsString:='A0';
      DataSet.FieldByName('qty').AsFloat:=0;
    end;
  end;
end;

procedure TFrmMDT060.CDS4NewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('date1').AsDateTime:=Date;
  DataSet.FieldByName('date2').AsDateTime:=Date;
  DataSet.FieldByName('time1').AsString:='00:01';
  DataSet.FieldByName('time2').AsString:='00:01';
end;

procedure TFrmMDT060.CDS2AfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('scrapcode').OnChange:=scrapcodeChange;
end;

procedure TFrmMDT060.CDS4AfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('stopcode').OnChange:=stopcodeChange;
end;

procedure TFrmMDT060.CDS1BeforePost(DataSet: TDataSet);
begin
  inherited;
  if Length(Trim(CDS1.FieldByName('lot').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh1.FieldColumns['lot'].Title.Caption));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS1.FieldByName('lot');
    ABort;
  end;
  if DBGridEh1.FieldColumns['type'].PickList.IndexOf(CDS1.FieldByName('type').AsString)=-1 then
  begin
    ShowMsg('請選擇[%s]',48,myStringReplace(DBGridEh1.FieldColumns['type'].Title.Caption));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS1.FieldByName('type');
    ABort;
  end;
  if Length(Trim(CDS1.FieldByName('tc_sia27').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh1.FieldColumns['tc_sia27'].Title.Caption));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS1.FieldByName('tc_sia27');
    ABort;
  end;
  if Length(Trim(CDS1.FieldByName('tc_sia36').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh1.FieldColumns['tc_sia36'].Title.Caption));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS1.FieldByName('tc_sia36');
    ABort;
  end;
  if CDS1.FieldByName('qty').AsFloat<=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh1.FieldColumns['qty'].Title.Caption));
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS1.FieldByName('qty');
    ABort;
  end; 
end;

procedure TFrmMDT060.CDS2BeforePost(DataSet: TDataSet);
begin
  inherited;
  if Length(Trim(CDS2.FieldByName('scrapcode').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh2.FieldColumns['scrapcode'].Title.Caption));
    DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=CDS2.FieldByName('scrapcode');
    ABort;
  end;
  if Length(Trim(CDS2.FieldByName('scrapname').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh2.FieldColumns['scrapcode'].Title.Caption));
    DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=CDS2.FieldByName('scrapcode');
    ABort;
  end;
  if CDS2.FieldByName('qty').AsFloat<=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh2.FieldColumns['qty'].Title.Caption));
    DBGridEh2.SetFocus;
    DBGridEh2.SelectedField:=CDS2.FieldByName('qty');
    ABort;
  end;
end;

procedure TFrmMDT060.CDS3BeforePost(DataSet: TDataSet);
begin
  inherited;
  if Length(Trim(CDS3.FieldByName('lot').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh3.FieldColumns['lot'].Title.Caption));
    DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=CDS3.FieldByName('lot');
    ABort;
  end;
  if CDS3.FieldByName('qty').AsFloat<=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh3.FieldColumns['qty'].Title.Caption));
    DBGridEh3.SetFocus;
    DBGridEh3.SelectedField:=CDS3.FieldByName('qty');
    ABort;
  end;
end;

procedure TFrmMDT060.CDS4BeforePost(DataSet: TDataSet);
begin
  inherited;
  if Length(Trim(CDS4.FieldByName('stopcode').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh4.FieldColumns['stopcode'].Title.Caption));
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('stopcode');
    ABort;
  end;
  if Length(Trim(CDS4.FieldByName('stopname').AsString))=0 then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh4.FieldColumns['stopcode'].Title.Caption));
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('stopcode');
    ABort;
  end;
  if CDS4.FieldByName('date1').IsNull then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh4.FieldColumns['date1'].Title.Caption));
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('date1');
    ABort;
  end;
  if CDS4.FieldByName('date2').IsNull then
  begin
    ShowMsg('請輸入[%s]',48,myStringReplace(DBGridEh4.FieldColumns['date2'].Title.Caption));
    DBGridEh4.SetFocus;
    DBGridEh4.SelectedField:=CDS4.FieldByName('date2');
    ABort;
  end;
  CheckTimeGrd;
end;

procedure TFrmMDT060.PopupMenu1Popup(Sender: TObject);
begin
  inherited;
  N1.Visible:=not CDS1.IsEmpty;
end;

procedure TFrmMDT060.PopupMenu2Popup(Sender: TObject);
begin
  inherited;
  N2.Visible:=not CDS2.IsEmpty;
end;

procedure TFrmMDT060.PopupMenu3Popup(Sender: TObject);
begin
  inherited;
  N3.Visible:=not CDS3.IsEmpty;
end;

procedure TFrmMDT060.PopupMenu4Popup(Sender: TObject);
begin
  inherited;
  N4.Visible:=not CDS4.IsEmpty;
end;

procedure TFrmMDT060.N1Click(Sender: TObject);
begin
  inherited;
  CDS1.Delete;
end;

procedure TFrmMDT060.N2Click(Sender: TObject);
begin
  inherited;
  CDS2.Delete;
end;

procedure TFrmMDT060.N3Click(Sender: TObject);
begin
  inherited;
  CDS3.Delete;
end;

procedure TFrmMDT060.N4Click(Sender: TObject);
begin
  inherited;
  CDS4.Delete;
end;

procedure TFrmMDT060.btn_spClick(Sender: TObject);
var
  tmpSQL,tmpWono,tmpMachine:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  if not CheckWono(tmpWono) then
     Exit;

  tmpMachine:=GetMachine;
  if Length(tmpMachine)=0 then
     Exit;

  tmpSQL:='select A.shb10,B.tc_sil02,B.tc_sil03,B.tc_sil04,B.tc_sil05,B.tc_sil06,B.tc_sil07'
         +' from (select shb01,shb10 from '+g_UInfo^.BU+'.shb_file'
         +' where shb01 like ''571-%'' and shb06=1 and ta_shbconf=''Y'''
         +' and shb09='+Quotedstr(tmpMachine)
         +' and shb10=(select sfb05 from '+g_UInfo^.BU+'.sfb_file where sfb01='+Quotedstr(tmpWono)+' and sfbacti=''Y'' and rownum=1)'
         +' order by shb01 desc) A left join '+g_UInfo^.BU+'.tc_sil_file B'
         +' on A.shb01=B.tc_sil01 where rownum=1';   
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if not tmpCDS.IsEmpty then
    begin
      Label18.Caption:=tmpCDS.FieldByName('shb10').AsString;
      Edit6.Text:=tmpCDS.FieldByName('tc_sil02').AsString;
      Edit7.Text:=tmpCDS.FieldByName('tc_sil03').AsString;
      Edit8.Text:=tmpCDS.FieldByName('tc_sil04').AsString;
      Edit9.Text:=tmpCDS.FieldByName('tc_sil05').AsString;
      Edit10.Text:=tmpCDS.FieldByName('tc_sil06').AsString;
      Edit11.Text:=tmpCDS.FieldByName('tc_sil07').AsString;
    end else
    begin
      Edit6.Text:='';
      Edit7.Text:='1';
      Edit8.Text:='1';
      Edit9.Text:='';
      Edit10.Text:='1';
      Edit11.Text:='1';
    end
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMDT060.btn_printClick(Sender: TObject);
var
  tmpWono,tmpMachine:string;
begin
  inherited;
  if not CheckWono(tmpWono) then
     Exit;
  tmpMachine:=GetMachine;
  if Length(tmpMachine)=0 then
     Exit;
  if not Assigned(FrmMDT060_newlot) then
     FrmMDT060_newlot:=TFrmMDT060_newlot.Create(Application);
  FrmMDT060_newlot.l_wono:=tmpWono;
  FrmMDT060_newlot.l_machine:=tmpMachine;
  FrmMDT060_newlot.ShowModal;
end;

procedure TFrmMDT060.btn_exportClick(Sender: TObject);
begin
  inherited;
  Label18.Caption:='';
  Edit1.Text:='';
  Edit2.Text:='00:01';
  Edit3.Text:='00:01';
  Edit6.Text:='';
  Edit7.Text:='1';
  Edit8.Text:='1';
  Edit9.Text:='';
  Edit10.Text:='1';
  Edit11.Text:='1';
  chk.Checked:=False;
  CDS1.EmptyDataSet;
  CDS1.MergeChangeLog;
  CDS2.EmptyDataSet;
  CDS2.MergeChangeLog;
  CDS3.EmptyDataSet;
  CDS3.MergeChangeLog;
  CDS4.EmptyDataSet;
  CDS4.MergeChangeLog;
end;

procedure TFrmMDT060.btn_queryClick(Sender: TObject);
const tmpORA='ORACLE';
var
  tmpSQL,tmpWono,tmpMachine,tmpPno,tmpCustno,tc_sia35,tmpId:string;
  tmpQty,qty1,qty2,qty3:Double;
  Data:OleVariant;
  ret:Boolean;
  
  procedure CheckFloat(edt:TEdit; lbl:TLabel);
  begin
    if Length(edt.Text)=0 then
    begin
      ShowMsg('請輸入[%s]!',48,myStringReplace(lbl.Caption));
      edt.SetFocus;
      Abort;
    end;

    try
      StrToFloat(edt.Text);
    except
      ShowMsg('[%s]輸入錯誤!',48,myStringReplace(lbl.Caption));
      edt.SetFocus;
      Abort;
    end;
  end;
begin
  inherited;
  if ShowMsg('確定進行報工嗎?',33)=IdCancel then
     Exit;

  CDS1.DisableControls;
  CDS2.DisableControls;
  CDS3.DisableControls;
  CDS4.DisableControls;
  g_StatusBar.Panels[0].Text:=CheckLang('正在檢查資料...');
  Application.ProcessMessages;
  try
    tmpMachine:=GetMachine();
    if Length(tmpMachine)=0 then
       Exit;
    if not CheckWono(tmpWono) then
       Exit;
    CheckTimeEdt(Edit2);
    CheckTimeEdt(Edit3);
    if StrToDateTime(DateToStr(dtp1.Date)+' '+Edit2.Text)>=StrToDateTime(DateToStr(dtp2.Date)+' '+Edit3.Text) then
    begin
      ShowMsg('開工日期應小于完工日期!',48);
      dtp2.SetFocus;
      Exit;
    end;

    CheckFloat(Edit6, Label7);
    CheckFloat(Edit7, Label8);
    CheckFloat(Edit8, Label9);
    CheckFloat(Edit9, Label10);
    CheckFloat(Edit10, Label1);
    CheckFloat(Edit11, Label2);

    if CDS1.State in [dsInsert,dsEdit] then
       CDS1.Post;
    if CDS2.State in [dsInsert,dsEdit] then
       CDS2.Post;
    if CDS3.State in [dsInsert,dsEdit] then
       CDS3.Post;
    if CDS4.State in [dsInsert,dsEdit] then
       CDS4.Post;
    if CDS1.ChangeCount>0 then
       CDS1.MergeChangeLog;
    if CDS2.ChangeCount>0 then
       CDS2.MergeChangeLog;
    if CDS3.ChangeCount>0 then
       CDS3.MergeChangeLog;
    if CDS4.ChangeCount>0 then
       CDS4.MergeChangeLog;

    if CDS1.IsEmpty then
    begin
      ShowMsg('請輸入'+Label14.Caption+'資料!',48);
      DBGridEh1.SetFocus;
      Exit;
    end;

    {
    if CDS1.IsEmpty and CDS2.IsEmpty then
    begin
      ShowMsg('請輸入'+Label14.Caption+'或'+Label15.Caption+'資料!',48);
      if CDS1.IsEmpty then
         DBGridEh1.SetFocus
      else
         DBGridEh2.SetFocus;
      Exit;
    end;

    if CDS3.IsEmpty then
    begin
      ShowMsg('請輸'+Label16.Caption,48);
      DBGridEh3.SetFocus;
      Exit;
    end;
    }
    qty1:=0;
    with CDS1 do
    begin
      First;
      while not Eof do
      begin
        qty1:=qty1+FieldByName('qty').AsFloat;
        Next;
      end;
    end;

    qty2:=0;
    with CDS2 do
    begin
      First;
      while not Eof do
      begin
        qty2:=qty2+FieldByName('qty').AsFloat;
        Next;
      end;
    end;

    qty3:=0;
    with CDS3 do
    begin
      First;
      while not Eof do
      begin
        qty3:=qty3+FieldByName('qty').AsFloat;
        Next;
      end;
    end;
    {
    if qty1+qty2<>qty3 then
    begin
      ShowMsg('領料米數<>良品米數+不良品米數!',48);
      DBGridEh1.SetFocus;
      Exit;
    end;
    }
    try
      CDS1.BeforePost:=nil;
      CDS2.BeforePost:=nil;
      CDS3.BeforePost:=nil;
      if not CheckLot then
         Exit;
    finally
      CDS1.BeforePost:=CDS1BeforePost;
      CDS2.BeforePost:=CDS2BeforePost;
      CDS3.BeforePost:=CDS3BeforePost;
    end;

    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢資料...');
    Application.ProcessMessages;

    //檢查工單是否存在
    tmpSQL:='select sfb05,oea04 from '+g_UInfo^.BU+'.sfb_file left join '+g_UInfo^.BU+'.oea_file'
           +' on sfb22=oea01 where sfb01='+Quotedstr(tmpWono)
           +' and sfbacti=''Y'' and rownum=1';
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;

    CDSX.Data:=Data;
    if CDSX.IsEmpty then
    begin
      ShowMsg('工單號碼不存在!',48);
      Edit1.SetFocus;
      Exit;
    end;
    tmpPno:=CDSX.Fields[0].AsString;
    tmpCustno:=CDSX.Fields[1].AsString;

    //tc_sia35
    tc_sia35:='X';
    if (not CDS1.IsEmpty) and (Pos(LeftStr(tmpPno,1),'PQ')=0) then
    begin
      Data:=null;
      tmpSQL:='select occ02 from '+g_UInfo^.BU+'.sfb_file,'+g_UInfo^.BU+'.oea_file,'+g_UInfo^.BU+'.occ_file'
             +' where sfb22=oea01 and sfb87=''Y'' and oeaconf=''Y'' and oea04=occ01 and sfb01='+Quotedstr(tmpWono)
             +' and rownum=1';
      if not QueryBySQL(tmpSQL, Data, tmpORA) then
         Exit;
      CDSX.Data:=Data;
      if not CDSX.IsEmpty then
         tc_sia35:=CDSX.Fields[0].AsString;
    end;

    {自用
    Data:=null;
    tmpSQL:='select ima02 from '+g_UInfo^.BU+'.ima_file where ima01='+Quotedstr(tmpPno);
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;
    CDSX.Data:=Data;
    if CDSX.IsEmpty then
       tc_sia35:='A0'
    else
       tc_sia35:=CDSX.Fields[0].AsString;
    }

     //打開數據集
    OpenCDS;

    g_StatusBar.Panels[0].Text:=CheckLang('正在寫入資料...');
    Application.ProcessMessages;

    //賦值shbCDS基本資料
    shbCDS.Append;
    shbCDS.FieldByName('shb01').AsString:=tmpId;
    shbCDS.FieldByName('shb02').AsDateTime:=dtp1.Date;
    shbCDS.FieldByName('shb021').AsString:=Edit2.Text;
    shbCDS.FieldByName('shb03').AsDateTime:=dtp1.Date;
    shbCDS.FieldByName('shb031').AsString:=Edit3.Text;
    try
      shbCDS.FieldByName('shb032').AsFloat:=MinutesBetween(StrToDateTime(DateToStr(dtp1.Date)+' '+Edit2.Text),
                                                           StrToDateTime(DateToStr(dtp2.Date)+' '+Edit3.Text));
    except
      ShowMsg('計算投入工時失敗!',48);
      Edit2.SetFocus;
      Exit;
    end;
    shbCDS.FieldByName('shb04').AsString:=g_UInfo^.UserId;
    shbCDS.FieldByName('shb05').AsString:=tmpWono;
    shbCDS.FieldByName('shb06').AsInteger:=1;
    shbCDS.FieldByName('shb07').AsString:='11';
    shbCDS.FieldByName('shb08').AsString:=rg1.Items.Strings[rg1.ItemIndex];
    shbCDS.FieldByName('shb081').AsString:='1103';
    shbCDS.FieldByName('shb082').AsString:=CheckLang('上膠');
    shbCDS.FieldByName('shb09').AsString:=tmpMachine;
    shbCDS.FieldByName('shb10').AsString:=tmpPno;
    shbCDS.FieldByName('shb111').AsFloat:=0;
    shbCDS.FieldByName('shb112').AsFloat:=0;
    shbCDS.FieldByName('shb113').AsFloat:=0;
    shbCDS.FieldByName('shb114').AsFloat:=0;
    shbCDS.FieldByName('shb115').AsFloat:=0;
    shbCDS.FieldByName('shb17').AsFloat:=0;
    shbCDS.FieldByName('shbinp').AsDateTime:=Date;
    shbCDS.FieldByName('shbacti').AsString:='Y';
    shbCDS.FieldByName('shbuser').AsString:=g_UInfo^.UserId;
    shbCDS.FieldByName('shbgrup').AsString:='1D1121';
    shbCDS.FieldByName('ta_shbconf').AsString:='N';
    shbCDS.Post;
    //結束賦值shbCDS

    //賦值tc_silCDS機速
    tc_silCDS.Append;
    tc_silCDS.FieldByName('tc_sil01').AsString:=tmpId;
    tc_silCDS.FieldByName('tc_sil02').AsFloat:=StrToFloatDef(Edit6.Text,0);
    tc_silCDS.FieldByName('tc_sil03').AsFloat:=StrToFloatDef(Edit7.Text,0);
    tc_silCDS.FieldByName('tc_sil04').AsFloat:=StrToFloatDef(Edit8.Text,0);
    tc_silCDS.FieldByName('tc_sil05').AsFloat:=StrToFloatDef(Edit9.Text,0);
    tc_silCDS.FieldByName('tc_sil06').AsFloat:=StrToFloatDef(Edit10.Text,0);
    tc_silCDS.FieldByName('tc_sil07').AsFloat:=StrToFloatDef(Edit11.Text,0);
    tc_silCDS.FieldByName('tc_sil08').AsString:=g_UInfo^.UserId;
    tc_silCDS.FieldByName('tc_sil09').AsDateTime:=Date;
    tc_silCDS.Post;
    //結束賦值tc_silCDS

    //賦值tc_siaCDS良品
    with CDS1 do
    begin
      First;
      while not Eof do
      begin
        tc_siaCDS.Append;
        tc_siaCDS.FieldByName('tc_sia01').AsString:=tmpId;
        tc_siaCDS.FieldByName('tc_sia011').AsInteger:=RecNo;
        tc_siaCDS.FieldByName('tc_sia02').AsString:=UpperCase(FieldByName('lot').AsString);
        tc_siaCDS.FieldByName('tc_sia03').AsFloat:=FieldByName('qty').AsFloat;
        tc_siaCDS.FieldByName('tc_sia27').AsString:=UpperCase(FieldByName('tc_sia27').AsString);
        tc_siaCDS.FieldByName('tc_sia35').AsString:=tc_sia35;
        tc_siaCDS.FieldByName('tc_sia36').AsString:=UpperCase(FieldByName('tc_sia36').AsString);
        tc_siaCDS.FieldByName('tc_sia48').AsString:=LeftStr(FieldByName('type').AsString,1);
        tc_siaCDS.Post;
        Next;
      end;
    end;
    //結束賦值tc_siaCDS良品

    //賦值tc_siaCDS不良品
    with CDS2 do
    begin
      First;
      while not Eof do
      begin
        tc_siaCDS.Append;
        tc_siaCDS.FieldByName('tc_sia01').AsString:=tmpId;
        tc_siaCDS.FieldByName('tc_sia011').AsInteger:=100+RecNo;
        //if Length(FieldByName('lot').AsString)=0 then
        //   tc_siaCDS.FieldByName('tc_sia02').AsString:=''
        //else
        //   tc_siaCDS.FieldByName('tc_sia02').AsString:=UpperCase(FieldByName('lot').AsString);
        tc_siaCDS.FieldByName('tc_sia03').AsFloat:=FieldByName('qty').AsFloat;
        tc_siaCDS.FieldByName('tc_sia24').AsString:='E';
        tc_siaCDS.FieldByName('tc_sia27').AsString:='X';
        tc_siaCDS.FieldByName('tc_sia28').AsString:=UpperCase(FieldByName('scrapcode').AsString);
        tc_siaCDS.FieldByName('tc_sia35').AsString:='X';
        //if Length(FieldByName('type').AsString)>0 then
        //   tc_siaCDS.FieldByName('tc_sia48').AsString:=LeftStr(FieldByName('type').AsString,1);
        tc_siaCDS.Post;
        Next;
      end;
    end;
    //結束賦值tc_siaCDS不良品

    //賦值tc_sikCDS玻領料
    with CDS3 do
    begin
      First;
      while not Eof do
      begin
        tc_sikCDS.Append;
        tc_sikCDS.FieldByName('tc_sik01').AsString:=tmpId;
        tc_sikCDS.FieldByName('tc_sik02').AsInteger:=RecNo;
        tc_sikCDS.FieldByName('tc_sik03').AsString:=FieldByName('img01').AsString;
        tc_sikCDS.FieldByName('tc_sik031').AsString:=Copy(tc_sikCDS.FieldByName('tc_sik03').AsString,8,1);
        tc_sikCDS.FieldByName('tc_sik032').AsString:=Copy(tc_sikCDS.FieldByName('tc_sik03').AsString,4,2);
        tc_sikCDS.FieldByName('tc_sik04').AsString:=UpperCase(FieldByName('lot').AsString);
        tc_sikCDS.FieldByName('tc_sik05').AsString:=FieldByName('img02').AsString;
        tc_sikCDS.FieldByName('tc_sik06').AsString:=FieldByName('img03').AsString;
        tc_sikCDS.FieldByName('tc_sik07').AsFloat:=FieldByName('qty').AsFloat;
        tc_sikCDS.Post;
        Next;
      end;
    end;
    //結束賦值tc_sikCDS

    //賦值tc_siyCDS停機信息
    with CDS4 do
    begin
      First;
      while not Eof do
      begin
        tc_siyCDS.Append;
        tc_siyCDS.FieldByName('tc_siy01').AsString:=tmpId;
        tc_siyCDS.FieldByName('tc_siy02').AsInteger:=RecNo;
        tc_siyCDS.FieldByName('tc_siy03').AsString:=UpperCase(FieldByName('stopcode').AsString);
        tc_siyCDS.FieldByName('tc_siy04').AsDateTime:=FieldByName('date1').AsDateTime;
        tc_siyCDS.FieldByName('tc_siy041').AsString:=FieldByName('time1').AsString;
        tc_siyCDS.FieldByName('tc_siy05').AsDateTime:=FieldByName('date2').AsDateTime;
        tc_siyCDS.FieldByName('tc_siy051').AsString:=FieldByName('time2').AsString;
        try
        tc_siyCDS.FieldByName('tc_siy06').AsFloat:=MinutesBetween(StrToDateTime(DateToStr(FieldByName('date1').AsDateTime)+' '+FieldByName('time1').AsString),
                                                                  StrToDateTime(DateToStr(FieldByName('date2').AsDateTime)+' '+FieldByName('time2').AsString));
        except
          ShowMsg('計算停機時間錯誤!',48);
          DBGridEh4.SetFocus;
          DBGridEh4.SelectedField:=FieldByName('date1');
          Exit;
        end;
        tc_siyCDS.Post;
        Next;
      end;
    end;
    //結束賦值tc_siyCDS

    //賦值tc_shbCDS工時
    tmpQty:=Gettc_shb06(tmpMachine, tmpWono, tmpPno, tmpCustno, tc_shbCDS.FieldByName('tc_shb04').AsString);
    tc_shbCDS.Append;
    tc_shbCDS.FieldByName('tc_shb01').AsString:=tmpId;
    tc_shbCDS.FieldByName('tc_shb02').AsString:=tmpWono;
    if chk.Checked then
       tc_shbCDS.FieldByName('tc_shb04').AsString:='Y'
    else
       tc_shbCDS.FieldByName('tc_shb04').AsString:='N';
    tc_shbCDS.FieldByName('tc_shb05').AsFloat:=0;
    tc_shbCDS.FieldByName('tc_shb06').AsFloat:=RoundTo((shbCDS.FieldByName('shb111').AsFloat+shbCDS.FieldByName('shb112').AsFloat)*tmpQty,-4);
    tc_shbCDS.FieldByName('tc_shb07').AsFloat:=0;
    tc_shbCDS.FieldByName('tc_shb12').AsString:='N';
    tc_shbCDS.Post;
    //結束賦值tc_shbCDS

    g_StatusBar.Panels[0].Text:=CheckLang('正在獲取新的移轉單號...');
    Application.ProcessMessages;

    //移轉單號
    tmpId:='571-'+GetYM();
    Data:=null;
    tmpSQL:='select nvl(max(shb01),'''') as shb01 from '+g_UInfo^.BU+'.shb_file'
           +' where shb01 like '+Quotedstr(tmpId+'%');
    if not QueryBySQL(tmpSQL, Data, tmpORA) then
       Exit;

    CDSX.Data:=Data;
    tmpId:=GetNewNo(tmpId, CDSX.Fields[0].AsString);

    shbCDS.Edit;
    shbCDS.FieldByName('shb01').AsString:=tmpId;
    shbCDS.FieldByName('shb111').AsFloat:=qty1;
    shbCDS.FieldByName('shb112').AsFloat:=qty2;
    shbCDS.Post;

    tc_silCDS.Edit;
    tc_silCDS.FieldByName('tc_sil01').AsString:=tmpId;
    tc_silCDS.Post;

    with tc_siaCDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('tc_sia01').AsString:=tmpId;
        Post;
        Next;
      end;
    end;

    with tc_sikCDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('tc_sik01').AsString:=tmpId;
        Post;
        Next;
      end;
    end;

    with tc_siyCDS do
    begin
      First;
      while not Eof do
      begin
        Edit;
        FieldByName('tc_siy01').AsString:=tmpId;
        Post;
        Next;
      end;
    end;

    tc_shbCDS.Edit;
    tc_shbCDS.FieldByName('tc_shb01').AsString:=tmpId;
    tc_shbCDS.Post;

    g_StatusBar.Panels[0].Text:=CheckLang('正在儲存資料...');
    Application.ProcessMessages;

    ret:=CDSPost(shbCDS, 'shb_file', tmpORA);
    if not ret then
       Exit;

    ret:=CDSPost(tc_silCDS, 'tc_sil_file', tmpORA);
    if not ret then
    begin
      DelOra('shb_file', 'shb01', tmpId);
      Exit;
    end;

    ret:=CDSPost(tc_sikCDS, 'tc_sik_file', tmpORA);
    if not ret then
    begin
      DelOra('shb_file','shb01',tmpId);
      DelOra('tc_sil_file', 'tc_sil01', tmpId);
      Exit;
    end;

    ret:=CDSPost(tc_siaCDS, 'tc_sia_file', tmpORA);
    if not ret then
    begin
      DelOra('shb_file','shb01',tmpId);
      DelOra('tc_sil_file', 'tc_sil01', tmpId);
      DelOra('tc_sik_file', 'tc_sik01', tmpId);
      Exit;
    end;

    if not tc_siyCDS.IsEmpty then
    begin
      ret:=CDSPost(tc_siyCDS, 'tc_siy_file', tmpORA);
      if not ret then
      begin
        DelOra('shb_file','shb01',tmpId);
        DelOra('tc_sil_file', 'tc_sil01', tmpId);
        DelOra('tc_sik_file', 'tc_sik01', tmpId);
        DelOra('tc_sia_file', 'tc_sia01', tmpId);
        Exit;
      end;
    end;

    ret:=CDSPost(tc_shbCDS, 'tc_shb_file', tmpORA);
    if not ret then
    begin
      DelOra('shb_file','shb01',tmpId);
      DelOra('tc_sil_file', 'tc_sil01', tmpId);
      DelOra('tc_sik_file', 'tc_sik01', tmpId);
      DelOra('tc_sia_file', 'tc_sia01', tmpId);
      if not tc_siyCDS.IsEmpty then
         DelOra('tc_siy_file', 'tc_siy01', tmpId);
      Exit;
    end;

    if ret then
       ShowMsg('報工完畢,移轉單號:'+tmpId+#13#10+'請進入tiptop進行確認',64);
  finally
    g_StatusBar.Panels[0].Text:='';
    CDS1.EnableControls;
    CDS2.EnableControls;
    CDS3.EnableControls;
    CDS4.EnableControls;
  end;
end;

end.
