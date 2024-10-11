unit unMDR010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI080, ExtCtrls, ImgList, ComCtrls, ToolWin, StdCtrls, StrUtils,
  DBClient, TWODbarcode;

type
  TFrmMDR010 = class(TFrmSTDI080)
    Label1: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_printClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Fm_image : PTIMAGESTRUCT;
    l_SysId:string;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMDR010: TFrmMDR010;

implementation

uses unGlobal, unCommon;

const l_xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="id" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="sno" fieldtype="i4"/>'
           +'<FIELD attrname="wono" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="40"/>'
           +'<FIELD attrname="place" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="area" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="lot" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="qty" fieldtype="r8"/>'
           +'<FIELD attrname="custno" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="custom" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="ordqty" fieldtype="r8"/>'
           +'<FIELD attrname="uid" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="uname" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="prncnt" fieldtype="i4"/>'
           +'<FIELD attrname="qrcode" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="cnt" fieldtype="i4"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

procedure TFrmMDR010.FormCreate(Sender: TObject);
begin
  l_SysId:='md';
  btn_export.Visible:=False;
  btn_query.Visible:=False;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, l_xml);

  inherited;

  Label1.Caption:=CheckLang('調拔單號,一行一個');
  PtInitImage(@Fm_image);
end;

procedure TFrmMDR010.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  PtFreeImage(@Fm_image);
end;

procedure TFrmMDR010.btn_printClick(Sender: TObject);
var
  i,pos1,tmpCnt:Integer;
  tmpStr,tmpId,tmpWono,tmpQRCode:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDSX:TClientDataSet;
  ArrPrintData:TArrPrintData;
begin
  //inherited;
  tmpId:='';
  for i:=0 to Memo1.Lines.Count-1 do
  begin
    tmpStr:=UpperCase(Trim(Memo1.Lines[i]));
    if (Length(tmpStr)<>10) or (Pos('-',tmpStr)<>4) then
    begin
      ShowMsg('第'+IntToStr(i+1)+'個調拔單號錯誤,請重新輸入!',48);
      Memo1.SetFocus;
      Exit;
    end;
    if Pos(tmpStr,tmpId)=0 then
       tmpId:=tmpId+','+Quotedstr(tmpStr);
  end;

  if Length(tmpId)=0 then
  begin
    ShowMsg('請輸入調拔單號,一行一個!',48);
    Memo1.SetFocus;
    Exit;
  end;

  Delete(tmpId,1,1);
  tmpStr:='select imm04,imm07,imn01,imn02,imn03,imn15,imn16,imn17,imn22,ta_imn008'
         +' from '+g_UInfo^.BU+'.imm_file,'+g_UInfo^.BU+'.imn_file'
         +' where imm01=imn01 and imm01 in ('+tmpId+')'
         +' order by imn01,imn02';
  if not QueryBySQL(tmpStr, Data, 'ORACLE') then
     Exit;

  l_CDS.EmptyDataSet;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDSX:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('無調拔單號資料',48);
      Memo1.SetFocus;
      Exit;
    end;

    tmpWono:='';
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      if not SameText(tmpCDS1.FieldByName('imm04').AsString,'Y') then
      begin
        ShowMsg('此調拔單未拔出確認:'+tmpCDS1.FieldByName('imn01').AsString,48);
        Memo1.SetFocus;
        Exit;
      end;

      if (Length(tmpCDS1.FieldByName('ta_imn008').AsString)>0) and
         (Pos(tmpCDS1.FieldByName('ta_imn008').AsString,tmpWono)=0) then
         tmpWono:=tmpWono+','+Quotedstr(tmpCDS1.FieldByName('ta_imn008').AsString);
      tmpCDS1.Next;
    end;

    if Length(tmpWono)>0 then
    begin
      Delete(tmpWono,1,1);
      Data:=null;
      tmpStr:='select z.*,oao06 from('
             +' select y.*,occ02,'
             +'(select sum(nvl(oeb12,0)) from '+g_UInfo^.BU+'.oeb_file where oeb01=sfb22 and oeb04=sfb05) ordqty from('
             +' select x.*,oea04 from('
             +' select sfb01,sfb22,sfb05,sfb221 from '+g_UInfo^.BU+'.sfb_file'
             +' where sfb01 in ('+tmpWono+')) x,'+g_UInfo^.BU+'.oea_file'
             +' where sfb22=oea01) y,'+g_UInfo^.BU+'.occ_file where oea04=occ01) z left join '+g_UInfo^.BU+'.oao_file'
             +' on sfb22=oao01 and sfb221=oao03';
      if not QueryBySQL(tmpStr, Data, 'ORACLE') then
         Exit;
      tmpCDS2.Data:=Data;
    end;

    tmpId:='@';
    tmpCnt:=0;
    tmpCDSX.Data:=tmpCDS1.Data;
    tmpCDS1.First;
    while not tmpCDS1.Eof do
    begin
      l_CDS.Append;
      l_CDS.FieldByName('id').AsString:=tmpCDS1.FieldByName('imn01').AsString;
      l_CDS.FieldByName('sno').AsInteger:=tmpCDS1.FieldByName('imn02').AsInteger;
      l_CDS.FieldByName('wono').AsString:=tmpCDS1.FieldByName('ta_imn008').AsString;
      l_CDS.FieldByName('pno').AsString:=tmpCDS1.FieldByName('imn03').AsString;
      l_CDS.FieldByName('place').AsString:=tmpCDS1.FieldByName('imn15').AsString;
      l_CDS.FieldByName('area').AsString:=tmpCDS1.FieldByName('imn16').AsString;
      l_CDS.FieldByName('lot').AsString:=tmpCDS1.FieldByName('imn17').AsString;
      l_CDS.FieldByName('qty').AsFloat:=tmpCDS1.FieldByName('imn22').AsFloat;
      if tmpCDS2.Active and (Length(tmpCDS1.FieldByName('ta_imn008').AsString)>0) then
      begin
        tmpCDS2.Filtered:=False;
        tmpCDS2.Filter:='sfb01='+Quotedstr(tmpCDS1.FieldByName('ta_imn008').AsString);
        tmpCDS2.Filtered:=True;
        if not tmpCDS2.IsEmpty then
        begin
          l_CDS.FieldByName('custno').AsString:=tmpCDS2.FieldByName('oea04').AsString;
          if SameText(l_CDS.FieldByName('custno').AsString,'N012') then
          begin
            pos1:=Pos('-',tmpCDS2.FieldByName('oao06').AsString);
            if pos1>0 then
               l_CDS.FieldByName('custno').AsString:=l_CDS.FieldByName('custno').AsString+'('+LeftStr(tmpCDS2.FieldByName('oao06').AsString,pos1-1)+')';
          end;
          l_CDS.FieldByName('custom').AsString:=tmpCDS2.FieldByName('occ02').AsString;
          l_CDS.FieldByName('ordqty').AsFloat:=tmpCDS2.FieldByName('ordqty').AsFloat;
        end;
      end;
      l_CDS.FieldByName('uid').AsString:=g_UInfo^.UserId;
      l_CDS.FieldByName('uname').AsString:=g_UInfo^.UserName;
      l_CDS.FieldByName('prncnt').AsInteger:=tmpCDS1.FieldByName('imm07').AsInteger;
      if tmpId<>l_CDS.FieldByName('id').AsString then
      begin
        tmpCDSX.Filtered:=False;
        tmpCDSX.Filter:='imn01='+Quotedstr(tmpCDS1.FieldByName('imn01').AsString);
        tmpCDSX.Filtered:=True;
        tmpCnt:=tmpCDSX.RecordCount;

        tmpQRCode:=g_UInfo^.TempPath+l_CDS.FieldByName('id').AsString+'.bmp';
        if getcode(l_CDS.FieldByName('id').AsString, tmpQRCode, Fm_image) then
           l_CDS.FieldByName('qrcode').AsString:=tmpQRCode
        else begin
          ShowMsg('生成二維碼失敗,請重試!',48);
          l_CDS.Cancel;
          Exit;
        end;
      end else
        l_CDS.FieldByName('qrcode').AsString:=tmpQRCode;
      l_CDS.FieldByName('cnt').AsInteger:=tmpCnt;    //為了報表添加空行
      l_CDS.Post;
      tmpId:=l_CDS.FieldByName('id').AsString;
      tmpCDS1.Next;
    end;
  finally
    FreeAndNil(tmpCDS1);
    FreeAndNil(tmpCDS2);
    FreeAndNil(tmpCDSX);
  end;

  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  SetLength(ArrPrintData, 1);
  ArrPrintData[0].Data:=l_CDS.Data;
  ArrPrintData[0].RecNo:=l_CDS.RecNo;
  ArrPrintData[0].IndexFieldNames:=l_CDS.IndexFieldNames;
  ArrPrintData[0].Filter:=l_CDS.Filter;
  GetPrintObj(l_SysId, ArrPrintData);
  ArrPrintData:=nil;
end;

end.
