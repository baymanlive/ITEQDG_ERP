unit unDLIT700;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, TWODbarcode;

type
  TFrmDLIT700 = class(TFrmSTDI080)
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit5: TEdit;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
  private
    { Private declarations }
    l_Fm_image:PTIMAGESTRUCT;
    l_CDS:TClientDataSet;
  public
    { Public declarations }
  end;

var
  FrmDLIT700: TFrmDLIT700;

implementation

uses unGlobal, unCommon;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="logo" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="sid" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="cmonth" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="sno" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="qrcode" fieldtype="string" WIDTH="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIT700.FormCreate(Sender: TObject);
begin
  p_TableName:='@';

  inherited;

  btn_export.Visible:=False;
  btn_query.Visible:=False;
  Label3.Caption:=CheckLang('供應商代碼：');
  Label5.Caption:=CheckLang('製造月份：');
  Label6.Caption:=CheckLang('起始流水號：');
  Label7.Caption:=CheckLang('至：');
  Edit3.Text:='A';
  Edit5.Text:=FormatDateTime('YYYYMM',Date);
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);
  CMDDeleteFile(g_UInfo^.TempPath,'bmp');
  PtInitImage(@l_Fm_image);
end;

procedure TFrmDLIT700.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  PtFreeImage(@l_Fm_image);
end;

procedure TFrmDLIT700.btn_printClick(Sender: TObject);
var
  s3,s5,s6,s7,tmpStr1,tmpStr2:string;
  num1,num2:Integer;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  s3:=Trim(Edit3.Text);
  s5:=Trim(Edit5.Text);
  s6:=Trim(Edit6.Text);
  s7:=Trim(Edit7.Text);

  if (Length(s3)=0) or (pos(',',s3)>0) then
  begin
    ShowMsg('請輸入供應商代碼,不可出現逗號(,)!',48);
    Edit3.SetFocus;
    Exit;
  end;

  if (Length(s5)=0) or (pos(',',s5)>0) then
  begin
    ShowMsg('請輸入製造月份,不可出現逗號(,)!',48);
    Edit5.SetFocus;
    Exit;
  end;

  if Length(s6)=0 then
  begin
    ShowMsg('請輸入起始流水號!',48);
    Edit6.SetFocus;
    Exit;
  end;

  if Length(s7)=0 then
  begin
    ShowMsg('請輸入截止流水號!',48);
    Edit7.SetFocus;
    Exit;
  end;

  num1:=StrToIntDef(s6,0);
  if (num1<=0) or (num1>9999) then
  begin
    ShowMsg('起始流水號輸入錯誤!',48);
    Edit6.SetFocus;
    Exit;
  end;

  num2:=StrToIntDef(s7,0);
  if (num2<=0) or (num2>9999) then
  begin
    ShowMsg('截止流水號輸入錯誤!',48);
    Edit7.SetFocus;
    Exit;
  end;

  if num1>num2 then
  begin
    ShowMsg('起始流水號不能大於截止流水號',48);
    Edit7.SetFocus;
    Exit;
  end;

  if num2-num1>199 then
  begin
    ShowMsg('每次最多可列印200張,請重新設定流水號范圍!',48);
    Edit7.SetFocus;
    Exit;
  end;

  l_CDS.EmptyDataSet;
  while num1<=num2 do
  begin
    l_CDS.Append;
    l_CDS.FieldByName('logo').AsString:='ITEQ';
    l_CDS.FieldByName('sid').AsString:=s3;
    l_CDS.FieldByName('cmonth').AsString:=s5;
    l_CDS.FieldByName('sno').AsString:=RightStr('0000'+IntToStr(num1),4);
    tmpStr1:='ITEQ,'+s3+','+s5+','+l_CDS.FieldByName('sno').AsString;
    tmpStr2:=g_UInfo^.TempPath+l_CDS.FieldByName('sno').AsString+'.bmp';
    if getcode(tmpStr1, tmpStr2, l_Fm_image) then
       l_CDS.FieldByName('qrcode').AsString:=tmpStr2;
    l_CDS.Post;
    Inc(num1);
  end;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData);
  ArrPrintData:=nil;
end;

end.
