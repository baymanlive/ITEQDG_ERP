unit unDLIT800;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, DBClient,
  StrUtils, TWODbarcode;

type
  TFrmDLIT800 = class(TFrmSTDI080)
    Label3: TLabel;
    Edit3: TEdit;
    PnlBottom: TPanel;
    lblrecored: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    lblsp: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Tab: TTabControl;
    Label4: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label5: TLabel;
    Edit6: TEdit;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_printClick(Sender: TObject);
    procedure TabChange(Sender: TObject);
  private
    { Private declarations }
    l_Fm_image:PTIMAGESTRUCT;
    l_CDS:TClientDataSet;
    procedure SetCtrl;
  public
    { Public declarations }
  end;

var
  FrmDLIT800: TFrmDLIT800;

implementation

uses unGlobal, unCommon;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="id" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qty" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qrcode" fieldtype="string" WIDTH="100"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmDLIT800.SetCtrl;
begin
  Label3.Visible:=Tab.TabIndex=0;
  Label4.Visible:=not Label3.Visible;
  Label5.Visible:=Label4.Visible;
  Label6.Visible:=Label4.Visible;

  Edit3.Visible:=Label3.Visible;
  Edit4.Visible:=Label4.Visible;
  Edit5.Visible:=Label4.Visible;
  Edit6.Visible:=Label4.Visible;
end;

procedure TFrmDLIT800.FormCreate(Sender: TObject);
begin
  p_TableName:='@';

  inherited;

  btn_export.Visible:=False;
  btn_query.Visible:=False;
  Edit4.Left:=Edit3.Left;
  Edit4.Top:=Edit3.Top;
  Label4.Left:=Label3.Left;
  Label4.Top:=Label3.Top;
  Label3.Caption:=CheckLang('儲位：');
  Label4.Caption:=CheckLang('料號：');
  Label5.Caption:=CheckLang('批號：');
  Label6.Caption:=CheckLang('數量：');
  Tab.Tabs.Strings[0]:=CheckLang('儲位');
  Tab.Tabs.Strings[1]:=CheckLang('料批數');
  SetCtrl;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_Xml);
  CMDDeleteFile(g_UInfo^.TempPath,'bmp');
  PtInitImage(@l_Fm_image);
end;

procedure TFrmDLIT800.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  PtFreeImage(@l_Fm_image);
end;

procedure TFrmDLIT800.btn_printClick(Sender: TObject);
var
  s3,s4,s5,s6,tmpStr:string;
  ArrPrintData:TArrPrintData;
begin
  inherited;
  if Tab.TabIndex=0 then
  begin
    s3:=UpperCase(Trim(Edit3.Text));

    if Length(s3)=0 then
    begin
      ShowMsg('請輸入儲位!',48);
      Edit3.SetFocus;
      Exit;
    end;

    l_CDS.EmptyDataSet;
    l_CDS.Append;
    l_CDS.FieldByName('id').AsString:=s3;
    tmpStr:=g_UInfo^.TempPath+s3+'.bmp';
    if getcode(s3, tmpStr, l_Fm_image) then
       l_CDS.FieldByName('qrcode').AsString:=tmpStr;
    l_CDS.Post;
  end else
  begin
    s4:=Trim(Edit4.Text);
    s5:=Trim(Edit5.Text);
    s6:=Trim(Edit6.Text);

    if Length(s4)=0 then
    begin
      ShowMsg('請輸入料號!',48);
      Edit4.SetFocus;
      Exit;
    end;

    if Length(s5)=0 then
    begin
      ShowMsg('請輸入批號!',48);
      Edit5.SetFocus;
      Exit;
    end;

    if Length(s6)=0 then
    begin
      ShowMsg('請輸入數量!',48);
      Edit6.SetFocus;
      Exit;
    end;

    if StrToIntDef(s6,0)<=0 then
    begin
      ShowMsg('數量錯誤!',48);
      Edit6.SetFocus;
      Exit;
    end;

    s3:='000-000001;'+s4+';'+s5+';'+s6;
    l_CDS.EmptyDataSet;
    l_CDS.Append;
    l_CDS.FieldByName('id').AsString:=s3;
    l_CDS.FieldByName('pno').AsString:=s4;
    l_CDS.FieldByName('lot').AsString:=s5;
    l_CDS.FieldByName('qty').AsString:=s6;
    tmpStr:=g_UInfo^.TempPath+s4+'.bmp';
    if getcode(s3, tmpStr, l_Fm_image) then
       l_CDS.FieldByName('qrcode').AsString:=tmpStr;
    l_CDS.Post;
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  if Tab.TabIndex=0 then
     GetPrintObj('Dli', ArrPrintData)
  else
     GetPrintObj('Dli', ArrPrintData, 'Other-DLIT800');
  ArrPrintData:=nil;
end;

procedure TFrmDLIT800.TabChange(Sender: TObject);
begin
  inherited;
  SetCtrl;
end;

end.
