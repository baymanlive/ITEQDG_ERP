unit unMPSI711;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin, StrUtils;

type
  TFrmMPSI711 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure FieldChange(Sender: TField);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    function GetAd(pno:string;ds:TDataSet):string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPSI711: TFrmMPSI711;

implementation

uses
  unGlobal, unCommon;

const
  PASS = 'Pass';
  NG = 'NG';

var
  tgcds,adcds: TClientDataSet;
{$R *.dfm}

procedure TFrmMPSI711.FieldChange(Sender: TField);
var
  sql,pno,spec: string;
  data: OleVariant;
  tmpCDS: TClientDataSet;
  ls: TStrings;
  f15,f16:Double;
  tg1,tg2:Integer;
begin
  with Sender, Sender.DataSet do
  begin
    if SameText(Sender.FieldName, 'wono') then
    begin
    {(*}
      sql :='select shb10,tc_sie02,sfb08,oea04,ima02 from shb_file '+
            ' join sfb_file on shb05=sfb01 join oea_file on sfb22=oea01 ' +
            ' join ima_file on sfb05=ima01 ' +
            ' left join tc_sie_file '+
            ' on tc_sie01=shb01 where shb05=' + QuotedStr(Sender.AsString)+
            ' and shb081=1404 and shbacti=''Y'' and ta_shbconf=''Y'' order by tc_sie02 desc';
    {*)}
      if QueryBySQL(sql, data, 'ORACLE') then
      begin
        tmpCDS := TClientDataSet.Create(nil);
        ls := TStringList.create;
        try
          tmpCDS.data := data;
          pno:=tmpCDS.fieldbyname('shb10').asstring;
          CDS.FieldByName('pno').AsString := pno;
          CDS.FieldByName('lot').AsString := tmpCDS.fieldbyname('tc_sie02').asstring;
//          CDS.FieldByName('custno').AsString := tmpCDS.fieldbyname('oea04').asstring;
          ls.Delimiter := '-';
          ls.DelimitedText := tmpCDS.fieldbyname('ima02').asstring;
          if ls.Count > 0 then
            CDS.FieldByName('cu').AsString := ls[ls.count - 1];
        finally
          tmpCDS.Free;
          ls.free;
        end;
      end;
      CDS.FieldByName('ad').AsString := GetAd(pno,adcds);
      if adcds.Locate('firstcode;lastcode', VarArrayOf([Copy(pno, 2, 1), Copy(pno, Length(pno), 1)])
, [loPartialKey]) then
      begin
        //  adcds.fieldbyname('pname').asstring;
      end;
    end
    else if FieldName = 'v01' then
    begin
      FieldByName('v03').Value := format('%.2f', [StrToFloatdef(FieldByName('v01').AsString,0) * 55.88 / 9.8]);
      if FieldByName('v03').AsString='0.00' then
         FieldByName('v03').AsString:='';
    end
    else if FieldName = 'v02' then
    begin
      FieldByName('v04').Value := format('%.2f',  [StrToFloatdef(FieldByName('v02').AsString,0) * 55.88 / 9.8]);
      if FieldByName('v04').AsString='0.00' then
         FieldByName('v04').AsString:='';
    end
    else if FieldName = 'v13' then
    begin
      if StrToFloatdef(Sender.Value, 0) > 20 then
        fieldbyname('v14').Value := PASS
      else
        fieldbyname('v14').Value := NG;
    end
    else if Pos(FieldName, 'v15,v16,v17,v18') > 0 then
    begin {(*}
      if (fieldbyname('v15').Value>fieldbyname('v17').Value and
          fieldbyname('v16').Value>fieldbyname('v17').Value) and
         (fieldbyname('v18').Value<fieldbyname('v19').Value)
      then {*)}
        fieldbyname('v20').Value := PASS
      else
        fieldbyname('v20').Value := NG;
    end;

    if Pos(FieldName, 'wono,v15,v16') > 0 then
    begin {(*}
      if (FieldByName('wono').AsString<>'') and
         (FieldByName('v15').AsString<>'')  and
         (FieldByName('v16').AsString<>'')  then {*)}
      begin
        if tgcds.Locate('ad', Copy(Fieldbyname('pno').AsString, 2, 1), []) then
        begin
          f15:=StrToFloat(FieldByName('v15').AsString);
          f16:=StrToFloat(FieldByName('v16').AsString);
          tg1:=tgcds.FieldByName('tg1').AsInteger;
          tg2:=tgcds.FieldByName('tg2').AsInteger;
          CDS.FieldByName('v17').Value:=tgcds.FieldByName('tg1').AsString;
          CDS.FieldByName('v19').Value:=tgcds.FieldByName('tg2').AsString;
          CDS.FieldByName('v18').AsString:=FloatToStr(Abs(f15-f16));
          CDS.FieldByName('v21').AsString:=tgcds.FieldByName('tgd2').AsString;
          try  {(*}
            if (f15 >= tg1) and (f15 < tg2) and
               (f16 >= tg1) and (f16 < tg2) then
            begin
              if Abs(f15-f16)<=tgcds.FieldByName('tgd1').AsInteger then
                FieldByName('v20').AsString := PASS
              else
                FieldByName('v20').AsString := NG;
              if Abs(f15-f16)<=tgcds.FieldByName('tgd2').AsInteger then
                FieldByName('v22').AsString := PASS
              else
                FieldByName('v22').AsString := NG;
            end;{*)}
          except
            FieldByName('v20').Value := null;
            FieldByName('v22').Value := null;
          end;
        end;
      end;
    end;
  end;
  {(*}
  spec := CDS.FieldByName('v17').AsString + '-' +
          IfThen(StrToFloatdef(CDS.FieldByName('thick').AsString,0)<20,'B','H') + '-' +
          IfThen(StrToFloatdef(CDS.FieldByName('thick').AsString,0)<20,'B','H') + '-' +
          CDS.FieldByName('cuup').AsString + '-' +
          CDS.FieldByName('cu').AsString + '-' +
  {*)}
end;

procedure TFrmMPSI711.FormCreate(Sender: TObject);
var
  sql: string;
  data: OleVariant;
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS711';
  p_GridDesignAns := True;
  tgcds := TClientDataSet.Create(nil);
  adcds := TClientDataSet.Create(nil);
  sql := 'select * from mps714';
  if QueryBySQL(sql, data) then
    tgcds.data := data;
  sql := 'select firstcode,lastcode,pname from ORD150 where bu=''ITEQDG''';
  if QueryBySQL(sql, data) then
    adcds.data := data;
  inherited;
end;

procedure TFrmMPSI711.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
  i: integer;
begin
  tmpSQL := 'Select * From MPS711 Where Bu=''ITEQDG'' ' + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
  for i := 0 to CDS.FieldCount - 1 do
    CDS.Fields[i].OnChange := FieldChange;
end;

procedure TFrmMPSI711.CDSNewRecord(DataSet: TDataSet);
begin
  CDS.FieldByName('ddate').Value:=now;
  inherited;

end;

procedure TFrmMPSI711.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tgcds.free;
  adcds.free;
  inherited;

end;

function TFrmMPSI711.GetAd(pno: string; ds: TDataSet): string;
var s2,sl:string;
begin
  if pno='' then
    exit;
  result:='';
  s2:=Copy(pno,2,1);
  sl:=Copy(pno,Length(pno),1);
  ds.First;
  while not ds.Eof do
  begin
    if (ds.FieldByName('firstcode').AsString=s2) and
       (Pos(sl,ds.FieldByName('lastcode').AsString)>0) then
    begin
      result:=ds.fieldbyname('pname').AsString;
      Break;
    end;
    ds.Next;
  end;
end;

end.

