unit unMPSR220;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils, Menus, Math;
  
const l_Color1=16772300;      //RGB(204,236,255);   //淺藍
const l_Color2=13434879;      //RGB(255,255,204);   //淺黃

type
  TFrmMPSR220 = class(TFrmSTDI041)
    DBGridEh2: TDBGridEh;
    DS2: TDataSource;
    CDS2: TClientDataSet;
    Panel3: TPanel;
    RG1: TRadioGroup;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    btn_mpsr220A: TToolButton;
    Splitter1: TSplitter;
    ToolButton100: TToolButton;
    btn_mpsr220B: TToolButton;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_queryClick(Sender: TObject);
    procedure RG1Click(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure btn_mpsr220AClick(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure btn_mpsr220BClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
    l_ColorList:TStrings;
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR220: TFrmMPSR220;

implementation

uses unGlobal, unCommon, unMPSR220_query, unMPSR220_export;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sno1" fieldtype="i4"/>'
           +'<FIELD attrname="sno2" fieldtype="i4"/>'
           +'<FIELD attrname="sfa03" fieldtype="string" width="30"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="img01" fieldtype="string" width="30"/>'
           +'<FIELD attrname="img02" fieldtype="string" width="20"/>'
           +'<FIELD attrname="img03" fieldtype="string" width="20"/>'
           +'<FIELD attrname="img04" fieldtype="string" width="20"/>'
           +'<FIELD attrname="img10" fieldtype="r8"/>'
           +'<FIELD attrname="ta_img01" fieldtype="string" width="200"/>'
           +'<FIELD attrname="ta_img04" fieldtype="string" width="200"/>'
           +'<FIELD attrname="ta_img05" fieldtype="string" width="200"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';
{$R *.dfm}

procedure TFrmMPSR220.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpSQL:=' and machine in (''L1'',''L2'',''L3'',''L4'',''L5'')'
  else
     tmpSQL:=' and machine=''L6''';
  tmpSQL:='select bu,simuver,citem,jitem,oz,case_ans1 as ''select'',machine,sdate,wono,'
         +' materialno,sqty,stealno,currentboiler,premark,orderno,orderitem,custno,custom'
         +' from mps010 where 1=1 '+strFilter+tmpSQL
         +' and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0'
         +' and left(materialno,1) in (''E'',''T'')';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=False;
        Post;
        Next;
      end;
      tmpCDS.MergeChangeLog;
      CDS.Data:=tmpCDS.Data;
      CDS.IndexFieldNames:='machine;jitem;oz;materialno;simuver;citem';
      RG1Click(RG1);
      CDS2.EmptyDataSet;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;

  inherited;
end;

procedure TFrmMPSR220.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR220';
  p_GridDesignAns:=False;
  btn_quit.Left:=ToolButton100.Width+ToolButton100.Left;

  l_ColorList:=TStringList.Create;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_Xml);
  CDS2.Data:=l_CDS.Data;
  RG1.Tag:=1;

  inherited;

  GetMPSMachine;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     RG1.Items.DelimitedText:=g_MachineCCL_DG
  else if SameText(g_UInfo^.BU, 'ITEQGZ') then
     RG1.Items.DelimitedText:=g_MachineCCL_GZ
  else
     RG1.Items.DelimitedText:=g_MachineCCL;
  RG1.Tag:=0;
  RG1.ItemIndex:=0;
  if SameText(g_UInfo^.BU,'ITEQJX') then
  begin
    Panel3.Width:=Panel3.Width+10;
    RG1.Width:=RG1.Width+10;
    RG1.Height:=RG1.Height+100;
  end;
  SetGrdCaption(DBGridEh2, p_TableName);
end;

procedure TFrmMPSR220.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
  FreeAndNil(l_CDS);
  CDS2.Active:=False;
  DBGridEh2.Free;
end;

procedure TFrmMPSR220.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if not Assigned(FrmMPSR220_query) then
     FrmMPSR220_query:=TFrmMPSR220_query.Create(Application);
  if FrmMPSR220_query.ShowModal=mrOK then
  begin
    tmpStr:=' and sdate between '+Quotedstr(DateToStr(FrmMPSR220_query.dtp1.Date))
           +' and '+Quotedstr(DateToStr(FrmMPSR220_query.dtp2.Date));
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmMPSR220.btn_exportClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmMPSR220_export) then
     FrmMPSR220_export:=TFrmMPSR220_export.Create(Application);
  if FrmMPSR220_export.ShowModal=mrOK then
  begin
    if FrmMPSR220_export.rgp.ItemIndex=0 then
       GetExportXls(CDS, p_TableName)
    else
       GetExportXls(CDS2, p_TableName);
  end;
end;

procedure TFrmMPSR220.btn_printClick(Sender: TObject);
var
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=CDS2.Data;
  ArrPrintData[0].RecNo:=-1;
  ArrPrintData[0].IndexFieldNames:=CDS2.IndexFieldNames;
  ArrPrintData[0].Filter:='sno2>0';
  GetPrintObj(p_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

procedure TFrmMPSR220.RG1Click(Sender: TObject);
var
  tmpValue,tmpStr:string;
  tmpCDS:TClientdataset;
begin
  inherited;
  if (not CDS.Active) or (RG1.Tag=1) then
     Exit;

  with CDS do
  begin
    Filtered:=False;
    if RG1.ItemIndex=-1 then
       Filter:='machine=''@'''
    else
       Filter:='machine='+Quotedstr(RG1.Items[RG1.ItemIndex]);
    Filtered:=True;
  end;

  l_ColorList.Clear;
  tmpCDS:=TClientdataset.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.Filter:=CDS.Filter;
    tmpCDS.Filtered:=True;
    tmpCDS.IndexFieldNames:=CDS.IndexFieldNames;
    tmpValue:='1';
    tmpStr:='@';
    while not tmpCDS.Eof do
    begin
      if tmpStr<>tmpCDS.FieldByName('Stealno').AsString then
      begin
        if tmpValue='1' then
           tmpValue:='2'
        else
           tmpValue:='1';
      end;
      l_ColorList.Add(tmpValue);
      tmpStr:=tmpCDS.FieldByName('Stealno').AsString;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  DBGridEh1.Repaint;
end;

procedure TFrmMPSR220.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if SameText(Column.FieldName,'select') then
  begin
    CDS.Edit;
    if CDS.FieldByName('select').AsBoolean then
       CDS.FieldByName('select').AsBoolean:=False
    else
       CDS.FieldByName('select').AsBoolean:=True;
    CDS.Post;
    CDS.MergeChangeLog;
  end;
end;

procedure TFrmMPSR220.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;
  if l_ColorList.Count>=CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=l_Color2
    else
       Background:=l_Color1;
  end;
end;

procedure TFrmMPSR220.PopupMenu1Popup(Sender: TObject);
var
  isVisible:Boolean;
begin
  inherited;
  isVisible:=(not CDS.Active) or CDS.IsEmpty;
  N1.Visible:=not isVisible;
  N2.Visible:=not isVisible;
  N4.Visible:=not isVisible;
  N5.Visible:=not isVisible;
end;

procedure TFrmMPSR220.N1Click(Sender: TObject);
var
  tmpRecno:Integer;
  tmpSdate:TDateTime;
  tmpCDS:TClientdataset;
begin
  inherited;
  tmpRecno:=CDS.RecNo;
  tmpSdate:=CDS.FieldByName('sdate').AsDateTime;
  tmpCDS:=TClientdataset.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filter:=CDS.Filter;
      Filtered:=True;
      while not Eof do
      begin
        Edit;
        if tmpSdate=FieldByName('sdate').AsDateTime then
           FieldByName('select').AsBoolean:=True
        else
           FieldByName('select').AsBoolean:=False;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;
    CDS.Data:=tmpCDS.Data;
    CDS.RecNo:=tmpRecno;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR220.N2Click(Sender: TObject);
var
  tmpRecno:Integer;
  tmpCDS:TClientdataset;
begin
  inherited;
  tmpRecno:=CDS.RecNo;
  tmpCDS:=TClientdataset.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filter:=CDS.Filter;
      Filtered:=True;
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=True;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;
    CDS.Data:=tmpCDS.Data;
    CDS.RecNo:=tmpRecno;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR220.N4Click(Sender: TObject);
var
  tmpRecno:Integer;
  tmpCDS:TClientdataset;
begin
  inherited;
  tmpRecno:=CDS.RecNo;
  tmpCDS:=TClientdataset.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filter:=CDS.Filter;
      Filtered:=True;
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=False;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;
    CDS.Data:=tmpCDS.Data;
    CDS.RecNo:=tmpRecno;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR220.N5Click(Sender: TObject);
var
  tmpRecno,tmpCurrentBoiler:Integer;
  tmpSdate:TDateTime;
  tmpCDS:TClientdataset;
begin
  inherited;
  tmpRecno:=CDS.RecNo;
  tmpSdate:=CDS.FieldByName('sdate').AsDateTime;
  tmpCurrentBoiler:=CDS.FieldByName('currentboiler').AsInteger;
  tmpCDS:=TClientdataset.Create(nil);
  try
    with tmpCDS do
    begin
      Data:=CDS.Data;
      Filter:=CDS.Filter;
      Filtered:=True;
      while not Eof do
      begin
        Edit;
        if (tmpSdate=FieldByName('sdate').AsDateTime) and
           (tmpCurrentBoiler=FieldByName('currentboiler').AsInteger) then
           FieldByName('select').AsBoolean:=True
        else
           FieldByName('select').AsBoolean:=False;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;
    CDS.Data:=tmpCDS.Data;
    CDS.RecNo:=tmpRecno;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPSR220.btn_mpsr220AClick(Sender: TObject);
var
  i,msgResult,tmpSno:Integer;
  tmpQty:Double;
  tmpSQL,tmpWono,tmpPno,tmpImgFilter,tmpStr:string;
  tmpCDS1,tmpCDS2:TClientdataset;
  Data:OleVariant;

  //添加結果至l_CDS
  procedure AddData;
  begin
    with tmpCDS2 do
    begin
      First;
      while not Eof do
      begin
        tmpStr:=Copy(FieldByName('sfa03').AsString,2,30);     //第1碼P、Q忽略
        if Pos(LeftStr(RightStr(tmpStr,3),2),'6X,6T')>0 then  //倒數3碼的前2碼是6X或6T,忽略尾碼
           tmpStr:=Copy(tmpStr,1,Length(tmpStr)-1)
        else                                                  //忽略后3碼
           tmpStr:=Copy(tmpStr,1,Length(tmpStr)-3);

        if Pos('%'+tmpStr+'%',tmpImgFilter)=0 then
           tmpImgFilter:=tmpImgFilter+' or img01 like '+Quotedstr('%'+tmpStr+'%');

        if l_CDS.Locate('sfa03',tmpStr,[]) then
           l_CDS.Edit
        else begin
          l_CDS.Append;
          l_CDS.FieldByName('sfa03').AsString:=tmpStr;
        end;
        l_CDS.FieldByName('qty').AsFloat:=l_CDS.FieldByName('qty').AsFloat+FieldByName('sfa05').AsFloat;
        l_CDS.Post;

        Next;
      end;
    end;
  end;

begin
  inherited;
  if not CDS.Active then
  begin
    ShowMsg('無排程資料',48);
    Exit;
  end;

  msgResult:=ShowMsg('計算當前線別選中的資料請按[是]'+#13#10+'計算所有線別選中的資料請按[否]'+#13#10+'[取消]無操作',35);
  if msgResult=IdCancel then
     Exit;

  l_CDS.EmptyDataSet;
  tmpCDS1:=TClientdataset.Create(nil);
  tmpCDS2:=TClientdataset.Create(nil);
  try
    with tmpCDS1 do
    begin
      Data:=CDS.Data;
      if msgResult=IdYes then
         Filter:=CDS.Filter+' and select=1'
      else
         Filter:='select=1';
      Filtered:=True;
      if IsEmpty then
      begin
        ShowMsg('未選中任何資料',48);
        Exit;
      end;

      //開了工單,查詢工單資料
      //無工單,查詢BOM資料
      tmpWono:='';
      tmpPno:='';
      First;
      while not Eof do
      begin
        if Length(FieldByName('wono').AsString)>0 then
        begin
          if Pos(FieldByName('wono').AsString,tmpWono)=0 then
             tmpWono:=tmpWono+','+Quotedstr(FieldByName('wono').AsString);
        end else
        begin
          if Length(FieldByName('materialno').AsString)>0 then
          if Pos(FieldByName('materialno').AsString,tmpPno)=0 then
             tmpPno:=tmpPno+','+Quotedstr(FieldByName('materialno').AsString);
        end;
        Next;
      end;
    end;

    //***開始計算應發料號、應發數量***
    tmpImgFilter:='';
    if Length(tmpWono)>0 then
    begin
      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢工單資料...');
      Application.ProcessMessages;
      Delete(tmpWono,1,1);
      Data:=null;
      tmpSQL:='select sfa01,sfa03,sfa05 from '+g_UInfo^.BU+'.sfa_file,'+g_UInfo^.BU+'.sfb_file'
             +' where sfa01=sfb01 and sfa01 in ('+tmpWono+') and (sfa03 like ''P%'' or sfa03 like ''Q%'')';
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;

      tmpCDS2.Data:=Data;
      if tmpCDS2.IsEmpty then
         ShowMsg('所選工單查無工單開立資料!',48)
      else begin
        //判斷選中的工單號碼是否存在
        tmpWono:='';
        with tmpCDS1 do
        begin
          First;
          while not Eof do
          begin
            if Length(FieldByName('wono').AsString)>0 then
            if not tmpCDS2.Locate('sfa01',FieldByName('wono').AsString,[]) then
               tmpWono:=tmpWono+#13#10+FieldByName('wono').AsString;

            Next;
          end;
        end;
        if Length(tmpWono)>0 then
           ShowMsg('無此工單開立資料:'+tmpWono,48);

        AddData;
      end;
    end;

    if Length(tmpPno)>0 then
    begin
      g_StatusBar.Panels[0].Text:=CheckLang('正在查詢BOM資料...');
      Application.ProcessMessages;
      Delete(tmpPno,1,1);
      Data:=null;
      tmpSQL:='select bmb01,bmb03 as sfa03,bmb06,bmb07,bmb08,bmb10_fac as sfa05 from '+g_UInfo^.BU+'.bmb_file'
             +' where bmb01 in ('+tmpPno+') and bmb10=''M''';   //bmb03=>sfa03應發料號、bmb10_fac=>sfa05應發數量
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;

      tmpCDS2.Data:=Data;
      if tmpCDS2.IsEmpty then
         ShowMsg('所選料號查無BOM資料!',48)
      else begin
        //更新應發數量為0
        with tmpCDS2 do
        begin
          First;
          while not Eof do
          begin
            Edit;
            FieldByName('sfa05').AsFloat:=0;
            Post;
            Next;
          end;
        end;

        //判斷選中的料號是否存在BOM資料、并更新應發數量
        tmpPno:='';
        with tmpCDS1 do
        begin
          First;
          while not Eof do
          begin
            if (Length(FieldByName('wono').AsString)=0) and
               (Length(FieldByName('materialno').AsString)>0) then
            begin
              tmpCDS2.Filtered:=False;
              tmpCDS2.Filter:='bmb01='+Quotedstr(FieldByName('materialno').AsString);
              tmpCDS2.Filtered:=True;
              if tmpCDS2.IsEmpty then
                 tmpPno:=tmpPno+#13#10+FieldByName('materialno').AsString
              else begin
                tmpCDS2.First;
                while not tmpCDS2.Eof do
                begin
                  tmpQty:=RoundTo(tmpCDS2.FieldByName('bmb06').AsFloat*
                                   FieldByName('sqty').AsFloat*
                                (1+tmpCDS2.FieldByName('bmb08').AsFloat/100)/
                                   tmpCDS2.FieldByName('bmb07').AsFloat,-3);
                  tmpCDS2.Edit;
                  tmpCDS2.FieldByName('sfa05').AsFloat:=Trunc(tmpQty);
                  tmpCDS2.Post;
                  tmpCDS2.Next;
                end;
              end;
            end;

            Next;
          end;
          Filtered:=False;
        end;
        if Length(tmpPno)>0 then
           ShowMsg('無此料號BOM資料:'+tmpPno,48);

        tmpCDS2.Filtered:=False;
        tmpCDS2.IndexFieldNames:='';
        AddData;
      end;
    end;
    //結束***計算應發料號、應發數量***

    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;

    if Length(tmpImgFilter)=0 then
    begin
      ShowMsg('工單或BOM查無資料',48);
      Exit;
    end;
    tmpCDS1.Filtered:=False;

    //應發料號重新排序
    tmpSno:=0;
    tmpCDS2.Filtered:=False;
    tmpCDS2.IndexFieldNames:='';
    tmpCDS2.Data:=l_CDS.Data;
    tmpCDS2.IndexFieldNames:='sfa03';
    l_CDS.EmptyDataSet;
    with tmpCDS2 do
    begin
      First;
      while not Eof do
      begin
        l_CDS.Append;
        l_CDS.FieldByName('sno1').AsInteger:=tmpSno;
        l_CDS.FieldByName('sno2').AsInteger:=0;
        l_CDS.FieldByName('sfa03').AsString:=FieldByName('sfa03').AsString;
        l_CDS.FieldByName('qty').AsFloat:=FieldByName('qty').AsFloat;
        l_CDS.Post;
        Next;
        Inc(tmpSno);
      end;
    end;
    
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢庫存資料...');
    Application.ProcessMessages;
    Delete(tmpImgFilter,1,4);
    Data:=null;
    tmpSQL:='select img01,img02,img03,img04,img10,ta_img01,ta_img04,ta_img05,'
           +' img01 as img01_1,substr(img04,2,4) lot from '+g_UInfo^.BU+'.img_file'
           +' where (img01 like ''P%'' or img01 like ''Q%'') and ('+tmpImgFilter+')'
           +' and img02 in (''Y2A10'',''N2A10'',''Q3A10'',''Y2A15'',''Y2A16'',''N2AT2'',''Q6ET0'') and img10>0';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;

    //更新料號至img01_1
    tmpCDS1.Data:=Data;
    with tmpCDS1 do
    while not Eof do
    begin
      tmpStr:=Copy(FieldByName('img01').AsString,2,30);     //第1碼P、Q忽略
      if Pos(LeftStr(RightStr(tmpStr,3),2),'6X,6T')>0 then  //倒數3碼的前2碼是6X或6T,忽略尾碼
         tmpStr:=Copy(tmpStr,1,Length(tmpStr)-1)
      else                                                  //忽略后3碼
         tmpStr:=Copy(tmpStr,1,Length(tmpStr)-3);
      Edit;
      FieldByName('img01_1').AsString:=tmpStr;
      Post;
      Next;
    end;

    //更新庫存資料至l_CDS或添加庫存資料至tmpCDS2
    //此處tmpCDS2表結構與l_CDS相同
    tmpCDS2.EmptyDataSet;
    tmpCDS2.IndexFieldNames:=''; 
    l_CDS.First;
    while not l_CDS.Eof do
    begin
      tmpSno:=1;
      tmpCDS1.Filtered:=False;
      tmpCDS1.Filter:='img01_1='+Quotedstr(l_CDS.FieldByName('sfa03').AsString);
      tmpCDS1.Filtered:=True;
      tmpCDS1.IndexFieldNames:='lot;img01;img10;img02;img03';
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        if tmpCDS1.RecNo=1 then
        begin
          l_CDS.Edit;      //sno2=0
          l_CDS.FieldByName('img01').AsString:=tmpCDS1.FieldByName('img01').AsString;
          l_CDS.FieldByName('img02').AsString:=tmpCDS1.FieldByName('img02').AsString;
          l_CDS.FieldByName('img03').AsString:=tmpCDS1.FieldByName('img03').AsString;
          l_CDS.FieldByName('img04').AsString:=tmpCDS1.FieldByName('img04').AsString;
          l_CDS.FieldByName('img10').AsFloat:=tmpCDS1.FieldByName('img10').AsFloat;
          l_CDS.FieldByName('ta_img01').AsString:=tmpCDS1.FieldByName('ta_img01').AsString;
          l_CDS.FieldByName('ta_img04').AsString:=tmpCDS1.FieldByName('ta_img04').AsString;
          l_CDS.FieldByName('ta_img05').AsString:=tmpCDS1.FieldByName('ta_img05').AsString;
          l_CDS.Post;
        end else
        begin
          tmpCDS2.Append;
          tmpCDS2.FieldByName('sno1').AsInteger:=l_CDS.FieldByName('sno1').AsInteger;
          tmpCDS2.FieldByName('sno2').AsInteger:=tmpSno;
          tmpCDS2.FieldByName('img01').AsString:=tmpCDS1.FieldByName('img01').AsString;
          tmpCDS2.FieldByName('img02').AsString:=tmpCDS1.FieldByName('img02').AsString;
          tmpCDS2.FieldByName('img03').AsString:=tmpCDS1.FieldByName('img03').AsString;
          tmpCDS2.FieldByName('img04').AsString:=tmpCDS1.FieldByName('img04').AsString;
          tmpCDS2.FieldByName('img10').AsFloat:=tmpCDS1.FieldByName('img10').AsFloat;
          tmpCDS2.FieldByName('ta_img01').AsString:=tmpCDS1.FieldByName('ta_img01').AsString;
          tmpCDS2.FieldByName('ta_img04').AsString:=tmpCDS1.FieldByName('ta_img04').AsString;
          tmpCDS2.FieldByName('ta_img05').AsString:=tmpCDS1.FieldByName('ta_img05').AsString;
          tmpCDS2.Post;
          Inc(tmpSno);
        end;

        tmpCDS1.Next;
      end;
      l_CDS.Next;
    end;

    //tmpCDS2資料轉移至l_CDS
    with tmpCDS2 do
    begin
      First;
      while not Eof do
      begin
        l_CDS.Append;
        for i:=0 to Fields.Count-1 do
          l_CDS.Fields[i].Value:=Fields[i].Value;
        l_CDS.Post;
        Next;
      end;
    end;

    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
    CDS2.Data:=l_CDS.Data;
    CDS2.IndexFieldNames:='sno1;sno2';
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPSR220.btn_mpsr220BClick(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS2.Active and (not CDS2.IsEmpty) then
     str:=CDS2.FieldByName('img01').AsString
  else if CDS.Active and (not CDS.IsEmpty) then
     str:=CDS.FieldByName('materialno').AsString;
  GetQueryStock(str, False);
end;

end.
