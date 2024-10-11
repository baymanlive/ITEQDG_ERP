unit unDLII431;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, DateUtils, TWODbarcode;

type
  TFrmDLII431 = class(TFrmSTDI080)
    Label3: TLabel;
    Edit3: TEdit;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    rgp: TRadioGroup;
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
  FrmDLII431: TFrmDLII431;

implementation

uses unGlobal, unCommon;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qrcode" fieldtype="string" WIDTH="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';
           
{$R *.dfm}

//取水號
function GetQRCodeSnoX(Kind:string):Integer;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=0;
  tmpSQL:='Select Sno From MPS080 Where Bu=''ITEQDG'''
         +' And Kind='+Quotedstr(Kind)
         +' And Wdate='+Quotedstr(DateToStr(Date));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
         Result:=tmpCDS.Fields[0].AsInteger;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//更新流水號
function SetQRCodeSnoX(Kind:string; Sno:Integer):Boolean;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=False;
  tmpSQL:='Select * From MPS080 Where Bu=''ITEQDG'''
         +' And Kind='+Quotedstr(Kind)
         +' And Wdate='+Quotedstr(DateToStr(Date));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if tmpCDS.IsEmpty then
      begin
        tmpCDS.Append;
        tmpCDS.FieldByName('bu').AsString:='ITEQDG';
        tmpCDS.FieldByName('kind').AsString:=Kind;
        tmpCDS.FieldByName('wdate').AsDateTime:=Date;
        tmpCDS.FieldByName('iuser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('idate').AsDateTime:=Now;
      end else
      begin
        tmpCDS.Edit;
        tmpCDS.FieldByName('muser').AsString:=g_UInfo^.UserId;
        tmpCDS.FieldByName('mdate').AsDateTime:=Now;
      end;
      tmpCDS.FieldByName('sno').AsInteger:=Sno;
      tmpCDS.Post;
      if not CDSPost(tmpCDS, 'MPS080') then
         Exit;

      Result:=True;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmDLII431.FormCreate(Sender: TObject);
begin
  p_TableName:='@';

  inherited;

  btn_export.Visible:=False;
  btn_query.Visible:=False;
  Label3.Caption:=CheckLang('列印份數：');
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);
  CMDDeleteFile(g_UInfo^.TempPath,'bmp');
  PtInitImage(@l_Fm_image);
end;

procedure TFrmDLII431.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  PtFreeImage(@l_Fm_image);
end;

procedure TFrmDLII431.btn_printClick(Sender: TObject);
var
  tmpStr,code,kind:string;
  num,sno:Integer;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  num:=StrToIntDef(Trim(Edit3.Text),0);
  if num<1 then
  begin
    ShowMsg('請輸入列印份數!',48);
    Edit3.SetFocus;
    Exit;
  end;

  if num>200 then
  begin
    ShowMsg('每次最多可列印200份,請重新輸入!',48);
    Edit3.SetFocus;
    Exit;
  end;

  //格式:廠別+年+月+日+4號流水號
  case rgp.ItemIndex of
    0:code:='D';
    1:code:='G';
    2:code:='H';
  end;
  kind:=G_minFO^.ProcId+code;
  code:=code+RightStr(IntToStr(YearOf(Date)),2);
  sno:=MonthOf(Date);
  case sno of
    10:code:=code+'A';
    11:code:=code+'B';
    12:code:=code+'C';
    else
      code:=code+IntToStr(sno);
  end;
  code:=code+RightStr('0'+IntToStr(DayOf(Date)),2);
  sno:=GetQRCodeSnoX(kind);
  l_CDS.EmptyDataSet;
  while num>0 do
  begin
    Inc(sno);
    l_CDS.Append;
    l_CDS.FieldByName('sno').AsString:=code+RightStr('0000'+IntToStr(sno),4);
    tmpStr:=g_UInfo^.TempPath+l_CDS.FieldByName('sno').AsString+'.bmp';
    if getcode(l_CDS.FieldByName('sno').AsString, tmpStr, l_Fm_image) then
       l_CDS.FieldByName('qrcode').AsString:=tmpStr;
    l_CDS.Post;
    Dec(num);
  end;
  SetQRCodeSnoX(kind,sno);
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  GetPrintObj('Dli', ArrPrintData);
  ArrPrintData:=nil;
end;

end.
