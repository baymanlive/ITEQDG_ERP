{*******************************************************}
{                                                       }
{                unIPQCR010                             }
{                Author: kaikai                         }
{                Create date: 2021/1/8                  }
{                Description: 深南PP檢驗記錄表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unIPQCR010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Math, DateUtils, StrUtils, unGlobal;

type
  TFrmIPQCR010 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_CDS,l_CDSDli340,l_CDSsys_user:TClientDataSet;
    function GetGT_RF(DataSet:TDataSet; SMRec:TSplitMaterialnoPP; var xGT,xRF:string):Boolean;
    procedure GetDli340(xPno:string; var xGT,xRF:string);
    function GetOptname(xId:string):string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmIPQCR010: TFrmIPQCR010;

implementation

uses unCommon, unIPQCR010_query;

const l_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="iteq" fieldtype="string" WIDTH="4"/>'
           +'<FIELD attrname="bu" fieldtype="string" WIDTH="2"/>'
           +'<FIELD attrname="sdate" fieldtype="datetime"/>'
           +'<FIELD attrname="wono" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="pno" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="pname" fieldtype="string" WIDTH="200"/>'
           +'<FIELD attrname="lot" fieldtype="string" WIDTH="30"/>'
           +'<FIELD attrname="rc0" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="bw" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rc1" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rc2" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rc3" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rcavg" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="gt0" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="gt1" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="gt2" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="gt3" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="gtavg" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rf0" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rf1" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rf2" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="rf3" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="vc0" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="vc1" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="ret" fieldtype="string" WIDTH="2"/>'
           +'<FIELD attrname="optname" fieldtype="string" WIDTH="20"/>'
           +'<FIELD attrname="confname" fieldtype="string" WIDTH="20"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

{$R *.dfm}

//與COC一致(DLII030)
{
拉絲法PG1:AK001 AC347 AC388 AC434 AC093(E) AC091/AC094(N)
布種A=C=L=3=6 E=H F=I G=J B=N O=S Q=U R=V 8=T=P
}
function TFrmIPQCR010.GetGT_RF(DataSet:TDataSet;
  SMRec:TSplitMaterialnoPP; var xGT,xRF:string):Boolean;
var
  tmpStr1,tmpStr2,tmpGT,tmpRF:string;
  tmpBo:Boolean;
begin
  if DataSet.IsEmpty then
  begin
    Result:=False;
    Exit;
  end;

  if Pos(SMRec.M3, '36ACL')>0 then
     tmpStr1:=SMRec.M4_7+'3/'+SMRec.M4_7+'6/'+SMRec.M4_7+'A/'+SMRec.M4_7+'C/'+SMRec.M4_7+'L'
  else if Pos(SMRec.M3, 'EH')>0 then
     tmpStr1:=SMRec.M4_7+'E/'+SMRec.M4_7+'H'
  else if Pos(SMRec.M3, 'FI')>0 then
     tmpStr1:=SMRec.M4_7+'F/'+SMRec.M4_7+'I'
  else if Pos(SMRec.M3, 'GJ')>0 then
     tmpStr1:=SMRec.M4_7+'G/'+SMRec.M4_7+'J'
  else if Pos(SMRec.M3, 'BN')>0 then
     tmpStr1:=SMRec.M4_7+'B/'+SMRec.M4_7+'N'
  else if Pos(SMRec.M3, 'OS')>0 then
     tmpStr1:=SMRec.M4_7+'O/'+SMRec.M4_7+'S'
  else if Pos(SMRec.M3, '8PT')>0 then
     tmpStr1:=SMRec.M4_7+'8/'+SMRec.M4_7+'P/'+SMRec.M4_7+'T'
  else if Pos(SMRec.M3, 'QU')>0 then
     tmpStr1:=SMRec.M4_7+'Q/'+SMRec.M4_7+'U'
  else if Pos(SMRec.M3, 'RV')>0 then
     tmpStr1:=SMRec.M4_7+'R/'+SMRec.M4_7+'V'
  else
     tmpStr1:=SMRec.M4_7+SMRec.M3;

  tmpBo:=False;
  with DataSet do
  begin
    First;
    while not Eof do
    begin
      tmpStr2:=RightStr('00000'+FieldByName('Stkname').AsString,5);
      if Pos(tmpStr2, tmpStr1)>0 then
      begin
        if FieldByName('Custno').AsString='@' then
           tmpGT:='' //FieldByName('PG1').AsString
        else
           tmpGT:=FieldByName('PG2').AsString;
        tmpRF:=FieldByName('RF').AsString;
        tmpBo:=True;
        Break;
      end;
      Next;
    end;

    if not tmpBo then
    begin
      First;
      while not Eof do
      begin
        tmpStr2:=RightStr('00000'+FieldByName('Stkname').AsString,4);
        if tmpStr2=SMRec.M4_7 then
        begin
          if FieldByName('Custno').AsString='@' then
             tmpGT:='' //FieldByName('PG1').AsString
          else
             tmpGT:=FieldByName('PG2').AsString;
          tmpRF:=FieldByName('RF').AsString;
          tmpBo:=True;
          Break;
        end;
        Next;
      end;
    end;
  end;
  Result:=tmpBo;

  if Result then
  begin
    xGT:=tmpGT;
    xRF:=tmpRF;
    if Length(xRF)>0 then
    if (Pos('參考',xRF)=0) and (Pos('暫定',xRF)=0) then
       xRF:=xRF+'%';
  end;
end;

procedure TFrmIPQCR010.GetDli340(xPno:string; var xGT,xRF:string);
var
  tmpSQL,tmpRC:string;
  Data:OleVariant;
  SMRec:TSplitMaterialnoPP;
begin
  xGT:='';
  xRF:='';
  if not l_CDSDli340.Active then
  begin
    if l_CDSDli340.Tag=1 then
       Exit;

    tmpSQL:='Select *,Case When Len(IsNull(LastCode,''''))>0 Then LastCode Else ''@'' End LastCode1 From Dli340'
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And (Custno=''@'' OR Custno=''AC111'')';
    if not QueryBySQL(tmpSQL, Data) then
    begin
      l_CDSDli340.Tag:=1;
      Exit;
    end;

    l_CDSDli340.Filtered:=False;
    l_CDSDli340.Data:=Data;
  end;

  l_CDSDli340.Filtered:=False;
  if l_CDSDli340.IsEmpty then
     Exit;

  SMRec.M2:=Copy(xPno,2,1);
  SMRec.M3:=Copy(xPno,3,1);
  SMRec.M4_7:=Copy(xPno,4,4);
  SMRec.M18:=RightStr(xPno,1);
  SMRec.Custno:='AC111';
  tmpRC:=FloatToStr(StrToInt(Copy(xPno,8,3))/10);

  with l_CDSDli340 do
  begin
    Filtered:=False;
    Filter:='Adhesive='+Quotedstr(SMRec.M2)
           +' And RC='+Quotedstr(tmpRC)
           +' And Custno='+Quotedstr(SMRec.Custno)
           +' And LastCode1='+Quotedstr(SMRec.M18);
    Filtered:=True;
    if not GetGT_RF(l_CDSDli340, SMRec, xGT, xRF) then
    begin
      Filtered:=False;
      Filter:='Adhesive='+Quotedstr(SMRec.M2)
             +' And RC='+Quotedstr(tmpRC)
             +' And Custno='+Quotedstr(SMRec.Custno)
             +' And LastCode1=''@''';
      Filtered:=True;
      if not GetGT_RF(l_CDSDli340, SMRec, xGT, xRF) then
      begin
        Filtered:=False;
        Filter:='Adhesive='+Quotedstr(SMRec.M2)
               +' And RC='+Quotedstr(tmpRC)
               +' And Custno=''@'''
               +' And LastCode1='+Quotedstr(SMRec.M18);
        Filtered:=True;
        if not GetGT_RF(l_CDSDli340, SMRec, xGT, xRF) then
        begin
          Filtered:=False;
          Filter:='Adhesive='+Quotedstr(SMRec.M2)
                 +' And RC='+Quotedstr(tmpRC)
                 +' And Custno=''@'''
                 +' And LastCode1=''@''';
          Filtered:=True;
          GetGT_RF(l_CDSDli340, SMRec, xGT, xRF);
        end;
      end;
    end;
    Filtered:=False;
  end;
end;

function TFrmIPQCR010.GetOptname(xId:string):string;
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Result:=xId;
  if Length(xId)=0 then
     Exit;

  if not l_CDSsys_user.Active then
  begin
    if l_CDSsys_user.Tag=1 then
       Exit;

    tmpSQL:='Select UserId,UserName From Sys_user Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
    begin
      l_CDSsys_user.Tag:=1;
      Exit;
    end;

    l_CDSsys_user.Data:=Data;
  end;

  if l_CDSsys_user.IsEmpty then
     Exit;

  if l_CDSsys_user.Locate('UserId',xId,[loCaseInsensitive]) then
     Result:=l_CDSsys_user.FieldByName('UserName').AsString;
end;

procedure TFrmIPQCR010.RefreshDS(strFilter: string);
var
  pos1:Integer;
  tmpSQL,tmpLot_old,tmpLot_new,rc,gt,rf:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  l_CDS.EmptyDataSet;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  if strFilter=g_cFilterNothing then
     CDS.Data:=l_CDS.Data
  else begin
    g_StatusBar.Panels[0].Text:=CheckLang('正在查詢資料...');
    Application.ProcessMessages;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    try
      tmpSQL:='select d.*,ima02 from('
             +' select b.sfb01,b.sfb05,tc_sia02,tc_sia22,tc_sia46,'
             +' tc_sia49,tc_sia50,tc_sia171,tc_sia173,tc_sia175,'
             +' tc_sia193,tc_sia195,tc_sia196,tc_sia183,tc_sia201 from('
             +' select a.*,shb01 from('
             +' select sfb01,sfb05 from '+g_UInfo^.BU+'.oea_file,'+g_UInfo^.BU+'.sfb_file'
             +' ,iteqdg.oeb_file,iteqdg.oao_file'
             +' where oea01=sfb22 and oea01=oeb01 and oao01=oeb01 and oeb03=oao03 and oao06 like ''%AC111%'' and oea02>sysdate-730'
             +' and oeb03=sfb221 and oeaconf=''Y'' and sfbacti=''Y'''
             +' and substr(sfb05,1,1) in (''B'',''R'')) a,'+g_UInfo^.BU+'.shb_file'
             +' where shb05=sfb01 and shbacti=''Y'') b,'+g_UInfo^.BU+'.tc_sia_file c'
             +' where shb01=tc_sia01 and tc_sia02 like '+Quotedstr(strFilter+'%')+') d,'+g_UInfo^.BU+'.ima_file'
             +' where sfb05=ima01'
             +' order by tc_sia02';
      if not QueryBySQL(tmpSQL,Data,'ORACLE') then
      begin
        inherited;
        Exit;
      end;

      tmpCDS1.Data:=Data;
      tmpLot_old:='@';
      g_ProgressBar.Position:=0;
      g_ProgressBar.Max:=tmpCDS1.RecordCount;
      g_ProgressBar.Visible:=True;
      with tmpCDS1 do
      while not Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;

        tmpLot_new:=LeftStr(FieldByName('tc_sia02').AsString,6);
        if tmpLot_old<>tmpLot_new+'@'+FieldByName('sfb05').AsString then
        begin
          rc:=FloatToStr(StrToInt(Copy(FieldByName('sfb05').AsString,8,3))/10);

          GetDli340(FieldByName('sfb05').AsString, gt, rf);

          l_CDS.Append;
          l_CDS.FieldByName('iteq').AsString:='ITEQ';
          l_CDS.FieldByName('bu').AsString:=RightStr(g_UInfo^.BU,2);
          l_CDS.FieldByName('sdate').AsDateTime:=GetLotDate(Copy(FieldByName('tc_sia02').AsString,2,4),Date);
          l_CDS.FieldByName('wono').AsString:=FieldByName('sfb01').AsString;
          l_CDS.FieldByName('pno').AsString:=FieldByName('sfb05').AsString;
          l_CDS.FieldByName('pname').AsString:=FieldByName('ima02').AsString+' RC'+rc+'%';
          l_CDS.FieldByName('lot').AsString:=tmpLot_new;
          l_CDS.FieldByName('rc0').AsString:=rc+'±2%';
          l_CDS.FieldByName('bw').AsString:=FloatToStr(FieldByName('tc_sia22').AsFloat/1000);

          if FieldByName('tc_sia171').IsNull then
             l_CDS.FieldByName('rc1').AsString:=FieldByName('tc_sia171').AsString+'0%'
          else if Pos('.',FieldByName('tc_sia171').AsString)=0 then
             l_CDS.FieldByName('rc1').AsString:=FieldByName('tc_sia171').AsString+'.0%'
          else
             l_CDS.FieldByName('rc1').AsString:=FieldByName('tc_sia171').AsString+'%';

          if FieldByName('tc_sia173').IsNull then
             l_CDS.FieldByName('rc2').AsString:=FieldByName('tc_sia173').AsString+'0%'
          else if Pos('.',FieldByName('tc_sia173').AsString)=0 then
             l_CDS.FieldByName('rc2').AsString:=FieldByName('tc_sia173').AsString+'.0%'
          else
             l_CDS.FieldByName('rc2').AsString:=FieldByName('tc_sia173').AsString+'%';

          if FieldByName('tc_sia175').IsNull then
             l_CDS.FieldByName('rc3').AsString:=FieldByName('tc_sia175').AsString+'0%'
          else if Pos('.',FieldByName('tc_sia175').AsString)=0 then
             l_CDS.FieldByName('rc3').AsString:=FieldByName('tc_sia175').AsString+'.0%'
          else
             l_CDS.FieldByName('rc3').AsString:=FieldByName('tc_sia175').AsString+'%';

          l_CDS.FieldByName('rcavg').AsString:=FloatToStr(RoundTo((FieldByName('tc_sia171').AsFloat+FieldByName('tc_sia173').AsFloat+FieldByName('tc_sia175').AsFloat)/3,-1));
          if Pos('.',l_CDS.FieldByName('rcavg').AsString)=0 then
             l_CDS.FieldByName('rcavg').AsString:=l_CDS.FieldByName('rcavg').AsString+'.0%'
          else
             l_CDS.FieldByName('rcavg').AsString:=l_CDS.FieldByName('rcavg').AsString+'%';

          l_CDS.FieldByName('gt0').AsString:=gt;
          l_CDS.FieldByName('gt1').AsString:=FieldByName('tc_sia196').AsString;
          l_CDS.FieldByName('gt2').AsString:=FieldByName('tc_sia193').AsString;
          l_CDS.FieldByName('gt3').AsString:=FieldByName('tc_sia195').AsString;
          l_CDS.FieldByName('gtavg').AsString:=FloatToStr(RoundTo((FieldByName('tc_sia196').AsFloat+FieldByName('tc_sia193').AsFloat+FieldByName('tc_sia195').AsFloat)/3,0));

          l_CDS.FieldByName('rf0').AsString:=rf;
          l_CDS.FieldByName('rf1').AsString:=FloatToStr(FieldByName('tc_sia49').AsFloat/1000);
          l_CDS.FieldByName('rf2').AsString:=FloatToStr(FieldByName('tc_sia50').AsFloat/1000);
          if FieldByName('tc_sia183').IsNull then
             l_CDS.FieldByName('rf3').AsString:='0.0%'
          else begin
            pos1:=Pos('.',FieldByName('tc_sia183').AsString);
            if pos1=0 then
               l_CDS.FieldByName('rf3').AsString:=FieldByName('tc_sia183').AsString+'.0%'
            else
               l_CDS.FieldByName('rf3').AsString:=Copy(FieldByName('tc_sia183').AsString+'000',1,pos1+1)+'%';
          end;

          l_CDS.FieldByName('vc0').AsString:='1.5';
          if FieldByName('tc_sia201').IsNull then
             l_CDS.FieldByName('vc1').AsString:='0.00%'
          else begin
            pos1:=Pos('.',FieldByName('tc_sia201').AsString);
            if pos1=0 then
               l_CDS.FieldByName('vc1').AsString:=FieldByName('tc_sia201').AsString+'.00%'
            else
               l_CDS.FieldByName('vc1').AsString:=Copy(FieldByName('tc_sia201').AsString+'000',1,pos1+2)+'%';
          end;

          l_CDS.FieldByName('ret').AsString:='OK';
          l_CDS.FieldByName('optname').AsString:=GetOptname(FieldByName('tc_sia46').AsString);
          l_CDS.Post;
        end;
        tmpLot_old:=tmpLot_new+'@'+FieldByName('sfb05').AsString;

        Next;
      end;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      g_StatusBar.Panels[0].Text:='';
      g_ProgressBar.Visible:=False;
    end;

    if l_CDS.ChangeCount>0 then
       l_CDS.MergeChangeLog;
    CDS.Data:=l_CDS.Data;
  end;
  
  inherited;
end;

procedure TFrmIPQCR010.FormCreate(Sender: TObject);
begin
  p_SysId:='IPQC';
  p_TableName:='IPQCR010';
  p_GridDesignAns:=True;
  l_CDS:=TClientDataSet.Create(Self);
  l_CDSDli340:=TClientDataSet.Create(Self);
  l_CDSsys_user:=TClientDataSet.Create(Self);
  InitCDS(l_CDS,l_xml);

  inherited;
end;

procedure TFrmIPQCR010.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
  FreeAndNil(l_CDSDli340);
  FreeAndNil(l_CDSsys_user);
end;

procedure TFrmIPQCR010.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmIPQCR010_query) then
     FrmIPQCR010_query:=TFrmIPQCR010_query.Create(Application);
  if FrmIPQCR010_query.ShowModal=mrOK then
     RefreshDS(FrmIPQCR010_query.lot1_3);
end;

end.
