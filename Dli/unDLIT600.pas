{*******************************************************}
{                                                       }
{                unDLIT600                              }
{                Author: kaikai                         }
{                Create date: 2018/2/1                  }
{                Description: 訂單上傳格式產生作業      }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIT600;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI070, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, Menus, GridsEh, DBAxisGridsEh, DBGridEh, ExtCtrls, DB,
  DBClient, ImgList, StdCtrls, Buttons, ComCtrls,
  ToolWin, Math, StrUtils, ExcelXP, unGlobal, unCheckC_sizes;

type
  TFrmDLIT600 = class(TFrmSTDI070)
    PCL: TPageControl;
    DBGridEh1: TDBGridEh;
    btn_dlit600B: TBitBtn;
    btn_dlit600C: TBitBtn;
    OpenDialog1: TOpenDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_dlit600BClick(Sender: TObject);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_dlit600CClick(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure btn_insertClick(Sender: TObject);
    procedure btn_editClick(Sender: TObject);
    procedure btn_copyClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
  private
    { Private declarations }
    l_custno:string;
    procedure SetSMRec_ccl(pno:string; var SMRec_ccl:TSplitMaterialno; var isPN:Boolean);
    procedure SetSMRec_pp(pno:string; var SMRec_pp:TSplitMaterialnoPP; var isPN:Boolean);
    procedure ToXls(ORADB:string; sType:Integer);
  public
    { Public declarations }
  protected
    procedure RefreshDS;override;
  end;

var
  FrmDLIT600: TFrmDLIT600;

implementation

uses unCommon, ComObj, unDLIT600_export, unDLIT600_check;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="c_pno" fieldtype="string" WIDTH="50"/>'
           +'<FIELD attrname="adate" fieldtype="datetime" />'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="price" fieldtype="r8"/>'
           +'<FIELD attrname="oao04" fieldtype="i4"/>'
           +'<FIELD attrname="oao05" fieldtype="string" WIDTH="2"/>'
           +'<FIELD attrname="oao06" fieldtype="string" WIDTH="200"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIT600.SetSMRec_ccl(pno:string; var SMRec_ccl:TSplitMaterialno; var isPN:Boolean);
var
  tmpPno:string;
begin
  isPN:=Length(pno) in [11,19];
  tmpPno:=pno;
  if isPN then
  begin
    if Length(tmpPno)=19 then
       tmpPno:=Copy(tmpPno,1,8)+'999999'+Copy(tmpPno,17,3)
    else
       tmpPno:=Copy(tmpPno,1,8)+'999999'+Copy(tmpPno,9,3);  //后面截取字符中用
  end;
  SMRec_ccl.M1:=Copy(tmpPno,1,1);
  SMRec_ccl.M2:=Copy(tmpPno,2,1);
  SMRec_ccl.M3_6:=StrToFloat(Copy(tmpPno,3,4))/10;
  SMRec_ccl.M7_8:=Copy(tmpPno,7,2);
  SMRec_ccl.M7:=LeftStr(SMRec_ccl.M7_8,1);
  SMRec_ccl.M8:=RightStr(SMRec_ccl.M7_8,1);
  if not isPN then
  begin
    SMRec_ccl.M9_11:=Copy(tmpPno,9,3);
    SMRec_ccl.M12_14:=Copy(tmpPno,12,3);
  end;
  SMRec_ccl.M15:=Copy(tmpPno,15,1);
  SMRec_ccl.MLast_1:=Copy(tmpPno,16,1);              //M16
  SMRec_ccl.MLast:=RightStr(tmpPno,1);               //M17
  if (SMRec_ccl.M2='8') and SameText(SMRec_ccl.MLast,'R') then
     SMRec_ccl.M2:='F';
end;

procedure TFrmDLIT600.SetSMRec_pp(pno:string; var SMRec_pp:TSplitMaterialnoPP; var isPN:Boolean);
var
  tmpPno:string;
begin
  isPN:=Length(pno) in [12,20];
  tmpPno:=pno;
  if isPN then
  begin
    if Length(pno)=20 then
       tmpPno:=Copy(tmpPno,1,10)+'999999'+Copy(tmpPno,19,2)
    else
       tmpPno:=Copy(tmpPno,1,10)+'999999'+Copy(tmpPno,11,2);  //后面截取字符中用
  end;
  SMRec_pp.M1:=Copy(tmpPno,1,1);
  SMRec_pp.M2:=Copy(tmpPno,2,1);
  SMRec_pp.M3:=Copy(tmpPno,3,1);
  SMRec_pp.M4_7:=Copy(tmpPno,4,4);
  SMRec_pp.M8_10:=Copy(tmpPno,8,3);
  if not isPN then
  begin
    SMRec_pp.M11_13:=Copy(tmpPno,11,3);
    SMRec_pp.M14_16:=Copy(tmpPno,14,3);
  end;
  SMRec_pp.M17:=Copy(tmpPno,17,1);
  SMRec_pp.M18:=Copy(tmpPno,18,1);
  if (SMRec_pp.M2='8') and SameText(SMRec_pp.M18,'R') then
     SMRec_pp.M2:='F';
end;

procedure TFrmDLIT600.ToXls(ORADB:string; sType:Integer);
var
  isPN,isAsk,isXlsOK:Boolean;
  row:Integer;
  tmpQty:Double;
  tmpSQL,tmpDef,tmpFilter1,tmpFilter2:string;
  tmpCDS1,tmpCDS2:TClientDataSet;
  Data:OleVariant;
  ExcelApp:Variant;
  SMRec_ccl:TSplitMaterialno;
  SMRec_pp:TSplitMaterialnoPP;
  cs:TCheckC_sizes;

  procedure AddXlsHead(col:Integer; value,comment:string);
  begin
    ExcelApp.Cells[1,col].Value:=value;
    ExcelApp.Cells[1,col].AddComment;     //添加備注
    ExcelApp.Cells[1,col].Comment.Visible:=False;
    ExcelApp.Cells[1,col].Comment.Text(comment);
    if col in [1,2,3,4,6,7,8,9,10,14,18,19] then
       ExcelApp.Columns[col].NumberFormat:='@';
  end;

begin
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    PCL.ActivePageIndex:=0;
    Exit;
  end;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=CDS.Data;
    while not tmpCDS1.Eof do
    begin
      if (Pos(tmpCDS1.FieldByName('custno').AsString,tmpFilter1)=0) and
         (Length(Trim(tmpCDS1.FieldByName('custno').AsString))>0) then
         tmpFilter1:=tmpFilter1+','+Quotedstr(tmpCDS1.FieldByName('custno').AsString);

      if Length(Trim(tmpCDS1.FieldByName('c_pno').AsString))>0 then
         tmpFilter2:=tmpFilter2+','+Quotedstr(tmpCDS1.FieldByName('c_pno').AsString);
      tmpCDS1.Next;
    end;

    if Length(tmpFilter1)>0 then
       Delete(tmpFilter1,1,1);
    if Length(tmpFilter2)>0 then
       Delete(tmpFilter2,1,1);
    if Pos(',',tmpFilter1)>0 then
       ShowMsg('多個客戶!',48);

    //tmpSQL:='Select * From '+p_TableName
    //       +' Where Bu='+Quotedstr(g_UInfo^.BU)
    //       +' And Custno in ('+tmpFilter1+')';
    
    //tmpSQL:='select tc_ocp01,tc_ocp02,tc_ocp03,tc_ocn_file.*'
    //       +' from '+ORADB+'.tc_ocp_file,'+ORADB+'.tc_ocn_file'
    //       +' where tc_ocp02=tc_ocn01 and tc_ocp03=tc_ocn02';

    tmpSQL:='select * from '+ORADB+'.tc_ocn_file where 1=1';
    if (Length(tmpFilter1)=0) and (Length(tmpFilter2)=0) then
        tmpSQL:=tmpSQL+' and 1=2';
    if Length(tmpFilter1)>0 then
       tmpSQL:=tmpSQL+' and tc_ocn01 in ('+tmpFilter1+')';
    if Length(tmpFilter2)>0 then
       tmpSQL:=tmpSQL+' and tc_ocn02 in ('+tmpFilter2+')';
    if sType=0 then
       tmpSQL:=tmpSQL+' and substr(tc_ocn12,1,1) in (''B'',''M'',''T'',''Q'')'
    else
       tmpSQL:=tmpSQL+' and substr(tc_ocn12,1,1) in (''R'',''N'',''E'',''P'')';
    if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
       Exit;
    tmpCDS2.Data:=Data;
    
   { xlsPath:=g_UInfo^.SysPath+'Temp\訂單上傳格式.xlsx';
    if not FileExists(xlsPath) then
    begin
      ShowMsg('[Temp\訂單上傳格式.xlsx]文件不存在',48);
      Exit;
    end; }

    try
      ExcelApp:=CreateOleObject('Excel.Application');
    except
      ShowMsg('創建Excel失敗,請重試',48);
      Exit;
    end;

    isXlsOK:=False;
    Memo1.Lines.Clear;
    cs:=TCheckC_sizes.Create;
    try
      row:=1;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=tmpCDS1.RecordCount+16;
      g_ProgressBar.Visible:=True;
      ExcelApp.DisplayAlerts:=False;
      //ExcelApp.WorkBooks.Open(xlsPath);
      ExcelApp.WorkBooks.Add;
      ExcelApp.WorkSheets[1].Activate;
      ExcelApp.Rows[1].NumberFormat:='@';
      AddXlsHead(1, '產品編號','oeb04');
      AddXlsHead(2, '客戶產品編號','oeb11');
      AddXlsHead(3, '客戶品名','ta_oeb10');
      AddXlsHead(4, '銷售單位','oeb05');
      AddXlsHead(5, '約定交貨日','oeb15');
      AddXlsHead(6, '玻布碼','ta_oeb05');
      AddXlsHead(7, '銅箔碼','ta_oeb06');
      AddXlsHead(8, '單位','ta_oeb03');
      AddXlsHead(9, 'CCL尺寸代碼','ta_oeb04');
      AddXlsHead(10,'裁剪方式','ta_oeb07');
      AddXlsHead(11,'併裁','ta_oeb08');
      AddXlsHead(12,'經度','ta_oeb01');
      AddXlsHead(13,'緯度','ta_oeb02');
      AddXlsHead(14,'導角','ta_oeb09');
      AddXlsHead(15,'數量','oeb12');
      AddXlsHead(16,'未稅單價','oeb13');
      AddXlsHead(17,'備註序號','oao04');
      AddXlsHead(18,'備註列印碼','oao05');
      AddXlsHead(19,'備註','oao06');
      tmpCDS1.First;
      while not tmpCDS1.Eof do
      begin
        Inc(row);
        g_ProgressBar.Position:=g_ProgressBar.Position+1;

        if tmpCDS2.Locate('tc_ocn01;tc_ocn02',
            VarArrayOf([tmpCDS1.FieldByName('custno').AsString,
                        tmpCDS1.FieldByName('c_pno').AsString]),[]) then
        begin
          //客戶品名檢查
          if Pos(LeftStr(tmpCDS2.FieldByName('tc_ocn12').AsString,1),'ET')>0 then
          begin
            SetSMRec_ccl(tmpCDS2.FieldByName('tc_ocn12').AsString,SMRec_ccl,isPN);
            if isPN then
            begin
              SMRec_ccl.M9_11:=FloatToStr(tmpCDS2.FieldByName('ta_ocn01').AsFloat);
              SMRec_ccl.M12_14:=FloatToStr(tmpCDS2.FieldByName('ta_ocn02').AsFloat);
            end;
            SMRec_ccl.Custno:=tmpCDS2.FieldByName('tc_ocn01').AsString;
            tmpDef:=SMRec_ccl.Custno+'/'+tmpCDS2.FieldByName('tc_ocn12').AsString+'/'+tmpCDS2.FieldByName('tc_ocn03').AsString;
            tmpSQL:=cs.CheckCCL_C_sizes(SMRec_ccl,tmpCDS2.FieldByName('tc_ocn03').AsString,isPN);
            if Length(tmpSQL)>0 then
            begin
              Memo1.Lines.Add(tmpDef);
              Memo1.Lines.Add(CheckLang(tmpSQL));
              Memo1.Lines.Add('');
            end;
            tmpSQL:=cs.CheckStruct(SMRec_ccl,tmpCDS2.FieldByName('tc_ocn03').AsString);
            if Length(tmpSQL)>0 then
            begin
              Memo1.Lines.Add(tmpDef);
              Memo1.Lines.Add(CheckLang(tmpSQL));
              Memo1.Lines.Add('');
            end;
            if isPN then
            begin
              tmpSQL:=cs.CheckCCL_PN_sizes(SMRec_ccl,tmpCDS2.FieldByName('tc_ocn03').AsString);
              if Length(tmpSQL)>0 then
              begin
                Memo1.Lines.Add(tmpDef);
                Memo1.Lines.Add(CheckLang(tmpSQL));
                Memo1.Lines.Add('');
              end;
            end;
          end else
          begin
            SetSMRec_pp(tmpCDS2.FieldByName('tc_ocn12').AsString,SMRec_pp,isPN);
            if isPN then
            begin
              SMRec_pp.M11_13:=FloatToStr(tmpCDS2.FieldByName('ta_ocn01').AsFloat);
              SMRec_pp.M14_16:=FloatToStr(tmpCDS2.FieldByName('ta_ocn02').AsFloat);
            end;
            SMRec_pp.Custno:=tmpCDS2.FieldByName('tc_ocn01').AsString;
            tmpDef:=SMRec_pp.Custno+'/'+tmpCDS2.FieldByName('tc_ocn12').AsString+'/'+tmpCDS2.FieldByName('tc_ocn03').AsString;
            tmpSQL:=cs.CheckPP_C_sizes(SMRec_pp,tmpCDS2.FieldByName('tc_ocn03').AsString,isPN,isAsk);
            if Length(tmpSQL)>0 then
            begin
              Memo1.Lines.Add(tmpDef);
              Memo1.Lines.Add(CheckLang(tmpSQL));
              Memo1.Lines.Add('');
            end;
            if isPN then
            begin
              tmpSQL:=cs.CheckPP_PN_sizes(SMRec_pp,tmpCDS2.FieldByName('tc_ocn03').AsString);
              if Length(tmpSQL)>0 then
              begin
                Memo1.Lines.Add(tmpDef);
                Memo1.Lines.Add(CheckLang(tmpSQL));
                Memo1.Lines.Add('');
              end;
            end;
          end;
          //檢查結束

          ExcelApp.Cells[row,1].Value:=tmpCDS2.FieldByName('tc_ocn12').AsString;
          ExcelApp.Cells[row,3].Value:=tmpCDS2.FieldByName('tc_ocn03').AsString;
          ExcelApp.Cells[row,4].Value:=tmpCDS2.FieldByName('tc_ocn19').AsString;
          ExcelApp.Cells[row,6].Value:=tmpCDS2.FieldByName('tc_ocn09').AsString;
          ExcelApp.Cells[row,7].Value:=tmpCDS2.FieldByName('tc_ocn10').AsString;
          ExcelApp.Cells[row,8].Value:=tmpCDS2.FieldByName('tc_ocn08').AsString;
          if Length(tmpCDS2.FieldByName('tc_ocn12').AsString) in [11,12,19,20] then
          begin
            ExcelApp.Cells[row,9].Value:=tmpCDS2.FieldByName('tc_ocn04').AsString;
            ExcelApp.Cells[row,10].Value:=tmpCDS2.FieldByName('tc_ocn05').AsString;
            ExcelApp.Cells[row,12].Value:=tmpCDS2.FieldByName('ta_ocn01').AsFloat;
            ExcelApp.Cells[row,13].Value:=tmpCDS2.FieldByName('ta_ocn02').AsFloat;
          end;
          if not tmpCDS2.FieldByName('tc_ocn11').IsNull then
             ExcelApp.Cells[row,11].Value:=tmpCDS2.FieldByName('tc_ocn11').AsInteger;
          ExcelApp.Cells[row,14].Value:=tmpCDS2.FieldByName('tc_ocn20').AsString;
          if not tmpCDS2.FieldByName('tc_ocn21').IsNull then
             ExcelApp.Cells[row,16].Value:=tmpCDS2.FieldByName('tc_ocn21').AsFloat;
        end;

        ExcelApp.Cells[row,2].Value:=tmpCDS1.FieldByName('c_pno').AsString;
        if not tmpCDS1.FieldByName('adate').IsNull then
           ExcelApp.Cells[row,5].Value:=tmpCDS1.FieldByName('adate').AsDateTime;

        //特殊客戶轉換數量,加上備注
        ExcelApp.Cells[row,19].Value:=tmpCDS1.FieldByName('oao06').AsString;
        tmpQty:=tmpCDS1.FieldByName('qty').AsFloat;
        if Pos(UpperCase(tmpCDS1.FieldByName('custno').AsString),'AC093/AC394/AC152/AH036')>0 then
        begin
          tmpSQL:=ExcelApp.Cells[row,1].Value;
          if Pos(UpperCase(LeftStr(tmpSQL,1)),'BR')>0 then //PP
          begin
            tmpSQL:=Copy(tmpSQL,4,4);       //布種
            if Pos(tmpSQL,'7628/7627/1506')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/164,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS1.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' 1RL=164YDS');
            end
            else if Pos(tmpSQL,'2116/0106/1067/2113/2313/3313')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/218,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS1.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' 1RL=218YDS');
            end
            else if Pos(tmpSQL,'1080/1078/1086')>0 then
            begin
              tmpQty:=RoundTo(tmpQty/328,-3);
              if tmpQty<1 then
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' '+FloatToStr(tmpQty)+'RL='+FloatToStr(tmpCDS1.FieldByName('qty').AsFloat)+'YDS')
              else
                 ExcelApp.Cells[row,19].Value:=Trim(tmpCDS1.FieldByName('oao06').AsString+' 1RL=328YDS');              
            end;
          end;
        end;
        ExcelApp.Cells[row,15].Value:=tmpQty;

        if not tmpCDS1.FieldByName('Price').IsNull then
           ExcelApp.Cells[row,16].Value:=tmpCDS1.FieldByName('Price').AsFloat;
        ExcelApp.Cells[row,17].Value:=tmpCDS1.FieldByName('oao04').Value;
        ExcelApp.Cells[row,18].Value:=tmpCDS1.FieldByName('oao05').AsString;
        tmpCDS1.Next;
      end;

      ExcelApp.Range['A1:S'+IntToStr(row)].Borders.LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideVertical].LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideVertical].Weight:=xlThin;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideHorizontal].LineStyle:=xlContinuous;
      ExcelApp.Range['A1:S'+IntToStr(row)].Borders[xlInsideHorizontal].Weight:=xlThin;
      ExcelApp.Columns.EntireColumn.AutoFit;
      ExcelApp.Range['A2'].Select;
      ExcelApp.Visible:=True;
      isXlsOK:=True;

      if Memo1.Lines.Count=0 then
         Memo1.Lines.Add(CheckLang('恭喜,客戶品名未檢查出錯誤!'));
      PCL.ActivePageIndex:=1;
    finally
      FreeAndNil(cs);
      if not isXlsOK then
         ExcelApp.Quit;
    end;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    g_ProgressBar.Visible:=False;
  end;
end;

procedure TFrmDLIT600.RefreshDS;
begin
  InitCDS(CDS, l_Xml);

  inherited;
end;

procedure TFrmDLIT600.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI601';
  p_DelAll:=True;
  
  inherited;

  TabSheet1.Caption:=CheckLang('訂單資料');
  TabSheet2.Caption:=CheckLang('客戶品名檢核');
  
  with DBGridEh1 do
  begin
    FieldColumns['custno'].Title.Caption:=CheckLang('客戶編號');
    FieldColumns['c_pno'].Title.Caption:=CheckLang('客戶產品編號');
    FieldColumns['adate'].Title.Caption:=CheckLang('約定交貨日');
    FieldColumns['qty'].Title.Caption:=CheckLang('數量');
    FieldColumns['price'].Title.Caption:=CheckLang('未稅單價');
    FieldColumns['oao04'].Title.Caption:=CheckLang('備註序號');
    FieldColumns['oao05'].Title.Caption:=CheckLang('備註列印碼');
    FieldColumns['oao06'].Title.Caption:=CheckLang('備註');
    FieldColumns['custno'].Width:=70;
    FieldColumns['c_pno'].Width:=160;
    FieldColumns['adate'].Width:=80;
    FieldColumns['qty'].Width:=60;
    FieldColumns['price'].Width:=80;
    FieldColumns['oao04'].Width:=70;
    FieldColumns['oao05'].Width:=80;
    FieldColumns['oao06'].Width:=160;
  end;
end;

procedure TFrmDLIT600.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  CDS.Active:=False;
  DBGridEh1.Free;
end;

procedure TFrmDLIT600.btn_quitClick(Sender: TObject);
begin
  if (PCL.ActivePageIndex=0) and (CDS.State in [dsInsert, dsEdit]) then
     CDS.Cancel
  else
     Close;
end;

procedure TFrmDLIT600.btn_editClick(Sender: TObject);
begin
  PCl.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLIT600.btn_insertClick(Sender: TObject);
begin
  PCl.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLIT600.btn_deleteClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLIT600.btn_copyClick(Sender: TObject);
begin
  PCL.ActivePageIndex:=0;
  inherited;
end;

procedure TFrmDLIT600.btn_exportClick(Sender: TObject);
var
  tmpCDS:TClientDataSet;
begin
  //inherited;
  if CDS.IsEmpty then
  begin
    ShowMsg('無資料!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    while not tmpCDS.Eof do
    begin
      if Length(Trim(tmpCDS.FieldByName('custno').AsString))=0 then
      begin
        ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆,客戶編號未輸入!',48);
        Exit;
      end;
      if Length(Trim(tmpCDS.FieldByName('c_pno').AsString))=0 then
      begin
        ShowMsg('第'+IntToStr(tmpCDS.RecNo)+'筆,客戶產品編號未輸入!',48);
        Exit;
      end;
      tmpCDS.Next;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;

  if not Assigned(FrmDLIT600_export) then
     FrmDLIT600_export:=TFrmDLIT600_export.Create(Application);
  if FrmDLIT600_export.ShowModal=mrOK then
     ToXls(FrmDLIT600_export.rgp.Items[FrmDLIT600_export.rgp.ItemIndex],FrmDLIT600_export.rgp2.ItemIndex);
end;

procedure TFrmDLIT600.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  l_custno:=DataSet.FieldByName('custno').AsString;
end;

procedure TFrmDLIT600.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  if Length(l_custno)>0 then
     DataSet.FieldByName('custno').AsString:=l_custno;
end;

procedure TFrmDLIT600.btn_dlit600BClick(Sender: TObject);
var
  isFind,isMerge:Boolean;
  i,j,sno:Integer;
  tmpStr:string;
  tmpDate:TDateTime;
  tmpList:TStrings;
  tmpCDS1,tmpCDS2:TClientDataSet;
  ExcelApp:Variant;

  function ShowMsgXls(xFname:string):string;
  begin
    ShowMsg('第'+IntToStr(i)+'行['+DBGridEh1.FieldColumns[xFname].Title.Caption+']欄位值錯誤!', 48);
  end;

begin
  inherited;
  isMerge:=ShowMsg('相同資料[數量]是否合并?', 36)=IdYes;

  if not OpenDialog1.Execute then
     Exit;

  with DBGridEh1 do
  for i:=0 to Columns.Count -1 do
    CDS.FieldByName(Columns[i].FieldName).DisplayLabel:=Columns[i].Title.Caption;

  tmpList:=TStringList.Create;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog1.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to sno do
    begin
      isFind:=False;
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);

      if tmpStr<>'' then
      for j:=0 to CDS.FieldCount-1 do
      if CDS.Fields[j].DisplayLabel=tmpStr then
      begin
        tmpList.Add(IntToStr(j));
        isFind:=True;
        Break;
      end;

      if not isFind then
         tmpList.Add('-1');
    end;

    if tmpList.Count=0 then
    begin
      ShowMsg('Excel檔案第一行的欄位名稱與[訂單資料]頁面的欄位名稱不符!', 48);
      Exit;
    end;

    tmpDate:=EncodeDate(2011,1,1);
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible:=True;
    tmpCDS1.Data:=CDS.Data;
    i:=2;
    while True do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;

      //全為空值,退出
      for j:=0 to tmpList.Count-1 do
      if VarToStr(ExcelApp.Cells[i,j+1].Value)<>'' then
         Break;
      if j>=tmpList.Count then
         Break;

      tmpCDS1.Append;
      for j:=0 to tmpList.Count-1 do
        if tmpList.Strings[j]<>'-1' then
           tmpCDS1.Fields[StrToInt(tmpList.Strings[j])].Value:=ExcelApp.Cells[i,j+1].Value;
      if Length(Trim(tmpCDS1.FieldByName('custno').AsString))=0 then
      begin
        ShowMsgXls('custno');
        Exit;
      end;
      if Length(Trim(tmpCDS1.FieldByName('c_pno').AsString))=0 then
      begin
        ShowMsgXls('c_pno');
        Exit;
      end;
      tmpCDS1.Post;
      Inc(i);
    end;

    if tmpCDS1.ChangeCount>0 then
       tmpCDS1.MergeChangeLog;
    tmpCDS1.First;
    tmpCDS2.Data:=CDS.Data;
    tmpCDS2.EmptyDataSet;
    while not tmpCDS1.Eof do
    begin
      if isMerge then
      begin
        if tmpCDS1.FieldByName('adate').AsDateTime>tmpDate then
           isFind:=tmpCDS2.Locate('custno;c_pno;oao04;oao05;oao06;adate',
            VarArrayOf([tmpCDS1.FieldByName('custno').AsString,
                        tmpCDS1.FieldByName('c_pno').AsString,
                        tmpCDS1.FieldByName('oao04').AsInteger,
                        tmpCDS1.FieldByName('oao05').AsString,
                        tmpCDS1.FieldByName('oao06').AsString,
                        tmpCDS1.FieldByName('adate').AsDateTime]),[])
        else
           isFind:=tmpCDS2.Locate('custno;c_pno;oao04;oao05;oao06',
            VarArrayOf([tmpCDS1.FieldByName('custno').AsString,
                        tmpCDS1.FieldByName('c_pno').AsString,
                        tmpCDS1.FieldByName('oao04').AsInteger,
                        tmpCDS1.FieldByName('oao05').AsString,
                        tmpCDS1.FieldByName('oao06').AsString]),[]);
      end else
        isFind:=False;

      if isFind then
         tmpCDS2.Edit
      else begin
         tmpCDS2.Append;
         tmpCDS2.FieldByName('custno').AsString:=tmpCDS1.FieldByName('custno').AsString;
         tmpCDS2.FieldByName('c_pno').AsString:=tmpCDS1.FieldByName('c_pno').AsString;
         if tmpCDS1.FieldByName('adate').AsDateTime>tmpDate then
            tmpCDS2.FieldByName('adate').AsDateTime:=tmpCDS1.FieldByName('adate').AsDateTime;
         if tmpCDS1.FieldByName('price').AsFloat>0 then
            tmpCDS2.FieldByName('price').AsFloat:=RoundTo(tmpCDS1.FieldByName('price').AsFloat,-6);
         if tmpCDS1.FieldByName('oao04').AsInteger>0 then
            tmpCDS2.FieldByName('oao04').AsInteger:=tmpCDS1.FieldByName('oao04').AsInteger;
         tmpCDS2.FieldByName('oao05').AsString:=tmpCDS1.FieldByName('oao05').AsString;
         tmpCDS2.FieldByName('oao06').AsString:=tmpCDS1.FieldByName('oao06').AsString;
      end;
      tmpCDS2.FieldByName('qty').AsFloat:=tmpCDS2.FieldByName('qty').AsFloat+tmpCDS1.FieldByName('qty').AsFloat;
      tmpCDS2.Post;
      tmpCDS1.Next;
    end;
    if tmpCDS2.ChangeCount>0 then
       tmpCDS2.MergeChangeLog;
    CDS.Data:=tmpCDS2.Data;
    PCL.ActivePageIndex:=0;
  finally
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    ExcelApp.Quit;
  end;
end;

procedure TFrmDLIT600.btn_dlit600CClick(Sender: TObject);
var
  str,tmpSQL,tmpDef:string;
  isPN,isAsk:Boolean;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  SMRec_ccl:TSplitMaterialno;
  SMRec_pp:TSplitMaterialnoPP;
  cs:TCheckC_sizes;
begin
  inherited;
  if not Assigned(FrmDLIT600_check) then
     FrmDLIT600_check:=TFrmDLIT600_check.Create(Application);
  if FrmDLIT600_check.ShowModal<>mrOK then
     Exit;

  str:=StringReplace(FormatDateTime(g_cShortDate1,FrmDLIT600_check.dtp.Date),'-','/',[rfReplaceAll]);
  tmpSQL:='select oea01,oea04,oeb03,oeb04,ta_oeb01,ta_oeb02,ta_oeb10'
         +' from '+g_UInfo^.BU+'.oea_file inner join '+g_UInfo^.BU+'.oeb_file'
         +' on oea01=oeb01 where to_char(oea02,'''+g_cShortDate1+''')='+Quotedstr(str)
         +' and oeaconf<>''X'' and oeb70<>''Y''';
  if Length(Trim(FrmDLIT600_check.Edit1.Text))>0 then
     tmpSQL:=tmpSQL+' and oea04='+Quotedstr(FrmDLIT600_check.Edit1.Text);
  if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
     Exit;

  Memo1.Lines.Clear;
  tmpCDS:=TClientDataSet.Create(nil);
  cs:=TCheckC_sizes.Create;
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      Memo1.Lines.Add(CheckLang('無訂單資料'));
      Exit;
    end;

    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=tmpCDS.RecordCount;
    g_ProgressBar.Visible:=True;
    while not tmpCDS.Eof do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;

      if Pos(LeftStr(tmpCDS.FieldByName('oeb04').AsString,1),'ET')>0 then
      begin
        SetSMRec_ccl(tmpCDS.FieldByName('oeb04').AsString,SMRec_ccl,isPN);
        if isPN then
        begin
          SMRec_ccl.M9_11:=FloatToStr(tmpCDS.FieldByName('ta_oeb01').AsFloat);
          SMRec_ccl.M12_14:=FloatToStr(tmpCDS.FieldByName('ta_oeb02').AsFloat);
        end;
        SMRec_ccl.Custno:=tmpCDS.FieldByName('oea04').AsString;
        tmpDef:=tmpCDS.FieldByName('oea01').AsString+'/'+tmpCDS.FieldByName('oeb03').AsString+'/'+SMRec_ccl.Custno+'/'
               +tmpCDS.FieldByName('oeb04').AsString+'/'+tmpCDS.FieldByName('ta_oeb10').AsString;
        tmpSQL:=cs.CheckCCL_C_sizes(SMRec_ccl,tmpCDS.FieldByName('ta_oeb10').AsString,isPN);
        if Length(tmpSQL)>0 then
        begin
          Memo1.Lines.Add(tmpDef);
          Memo1.Lines.Add(CheckLang(tmpSQL));
          Memo1.Lines.Add('');
        end;
        tmpSQL:=cs.CheckStruct(SMRec_ccl,tmpCDS.FieldByName('ta_oeb10').AsString);
        if Length(tmpSQL)>0 then
        begin
          Memo1.Lines.Add(tmpDef);
          Memo1.Lines.Add(CheckLang(tmpSQL));
          Memo1.Lines.Add('');
        end;
        if isPN then
        begin
          tmpSQL:=cs.CheckCCL_PN_sizes(SMRec_ccl,tmpCDS.FieldByName('ta_oeb10').AsString);
          if Length(tmpSQL)>0 then
          begin
            Memo1.Lines.Add(tmpDef);
            Memo1.Lines.Add(CheckLang(tmpSQL));
            Memo1.Lines.Add('');
          end;
        end;
      end else
      begin
        SetSMRec_pp(tmpCDS.FieldByName('oeb04').AsString,SMRec_pp,isPN);
        if isPN then
        begin
          SMRec_pp.M11_13:=FloatToStr(tmpCDS.FieldByName('ta_oeb01').AsFloat);
          SMRec_pp.M14_16:=FloatToStr(tmpCDS.FieldByName('ta_oeb02').AsFloat);
        end;
        SMRec_pp.Custno:=tmpCDS.FieldByName('oea04').AsString;
        tmpDef:=tmpCDS.FieldByName('oea01').AsString+'/'+tmpCDS.FieldByName('oeb03').AsString+'/'+SMRec_pp.Custno+'/'
               +tmpCDS.FieldByName('oeb04').AsString+'/'+tmpCDS.FieldByName('ta_oeb10').AsString;
        tmpSQL:=cs.CheckPP_C_sizes(SMRec_pp,tmpCDS.FieldByName('ta_oeb10').AsString,isPN,isAsk);
        if Length(tmpSQL)>0 then
        begin
          Memo1.Lines.Add(tmpDef);
          Memo1.Lines.Add(CheckLang(tmpSQL));
          if isAsk then
             Memo1.Lines.Add(CheckLang('此項檢查只提示,可通過'));
          Memo1.Lines.Add('');
        end;
        if isPN then
        begin
          tmpSQL:=cs.CheckPP_PN_sizes(SMRec_pp,tmpCDS.FieldByName('ta_oeb10').AsString);
          if Length(tmpSQL)>0 then
          begin
            Memo1.Lines.Add(tmpDef);
            Memo1.Lines.Add(CheckLang(tmpSQL));
            Memo1.Lines.Add('');
          end;
        end;
      end;
      tmpCDS.Next;
    end;
  finally
    g_ProgressBar.Visible:=False;
    FreeAndNil(tmpCDS);
    FreeAndNil(tmpCDS);
    FreeAndNil(cs);
    if Memo1.Lines.Count=0 then
    begin
      Memo1.Lines.Add(CheckLang('客戶品名檢查完畢'));
      Memo1.Lines.Add(CheckLang('恭喜,客戶品名未檢查出錯誤!'));
    end;
    PCL.ActivePageIndex:=1;
  end;
end;

end.
