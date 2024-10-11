{*******************************************************}
{                                                       }
{                unDLII020_btnopt                       }
{                Author: kaikai                         }
{                Create date: 2015/12/4                 }
{                Description: DLII020(DLII021)�U����ާ@}
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII020_btnopt;

interface

uses
  Windows, Classes, SysUtils, Controls, Dialogs, DB, DBClient,
  Variants, Math, unGlobal, unCommon, unDLII020_upd;

type
  TDLII020_btnopt = class
  public
    constructor Create;
    destructor Destroy; override;
    function UpdateLot(CDS, CDS2:TClientDataSet):Boolean;
    function SplitQty(CDS:TClientDataSet):Boolean;
    function SplitQtyAll(IsML:Boolean):Boolean;
    function DeleteSaleNo(CDS:TClientDataSet):Boolean;
    function DeleteSaleItem(CDS:TClientDataSet):Boolean;
    function DeleteLot(CDS, CDS2:TClientDataSet):Boolean;
  end;

implementation

constructor TDLII020_btnopt.Create;
begin
  FrmDLII020_upd:=TFrmDLII020_upd.Create(nil);
end;

destructor TDLII020_btnopt.Destroy;
begin
  FreeAndNil(FrmDLII020_upd);
  inherited;
end;

//���ܡB�x�B��
function TDLII020_btnopt.UpdateLot(CDS, CDS2:TClientDataSet):Boolean;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or (not CDS2.Active) or CDS.IsEmpty or CDS2.IsEmpty then
  begin
    ShowMsg('�п�ܭn��諸�帹���', 48);
    Exit;
  end;

  if Trim(CDS.FieldByName('Saleno').AsString)<>'' then
  begin
    ShowMsg('�w���ͥX�f��,���i���!', 48);
    Exit;
  end;

  with FrmDLII020_upd do
  begin
    Edit1.Text:=CDS2.FieldByName('Stkplace').AsString;
    Edit2.Text:=CDS2.FieldByName('Stkarea').AsString;
    Edit3.Text:=CDS2.FieldByName('Manfac').AsString;
    Edit4.Text:=FloatToStr(CDS2.FieldByName('Qty').AsFloat);
    if ShowModal=mrOK then
    begin
      tmpSQL:=' Declare @Bu nvarchar(10)'
             +' Declare @Dno nvarchar(20)'
             +' Declare @Ditem int'
             +' Set @Bu='+Quotedstr(CDS2.FieldByName('Bu').AsString)
             +' Set @Dno='+Quotedstr(CDS2.FieldByName('Dno').AsString)
             +' Set @Ditem='+Quotedstr(CDS2.FieldByName('Ditem').AsString)
             +' Update Dli020 Set Stkplace='+Quotedstr(UpperCase(Trim(Edit1.Text)))
             +' ,Stkarea='+Quotedstr(UpperCase(Trim(Edit2.Text)))
             +' ,Manfac='+Quotedstr(UpperCase(Trim(Edit3.Text)))
             +' ,Qty='+Quotedstr(Trim(Edit4.Text))
             +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem'
             +' And Sno='+CDS2.FieldByName('Sno').AsString
             +' exec dbo.proc_UpdateDelcount @Bu,@Dno,@Ditem'
             +' exec dbo.proc_UpdateBingbao @Bu,@Dno,@Ditem'
             +' Select Delcount,Jcount_old,Jcount_new,Bcount From DLI010'
             +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem';
      if QueryBySQL(tmpSQL, Data) then
      begin
        tmpCDS:=TClientDataSet.Create(nil);
        try
          tmpCDS.Data:=Data;
          CDS.Edit;
          CDS.FieldByName('Delcount').AsFloat:=tmpCDS.Fields[0].AsFloat;
          CDS.FieldByName('Jcount_old').AsFloat:=tmpCDS.Fields[1].AsFloat;
          CDS.FieldByName('Jcount_new').AsFloat:=tmpCDS.Fields[2].AsFloat;
          CDS.FieldByName('Bcount').AsFloat:=tmpCDS.Fields[3].AsFloat;
          CDS.Post;
          CDS.MergeChangeLog;
        finally
          FreeAndNil(tmpCDS);
        end;
        ShowMsg('��s����!', 64);
        Result:=True;
      end;
    end;
  end;
end;

//����ƶq
function TDLII020_btnopt.SplitQty(CDS:TClientDataSet):Boolean;
var
  i,tmpDitem:Integer;
  tmpSQL:string;
  tmpQty1,tmpQty2:Double;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('�п�ܭn��������!', 48);
    Exit;
  end;

  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then
  begin
    ShowMsg('���q��w����L�@��,���i�A��!', 48);
    Exit;
  end;

  if ShowMsg('�T�w���'+CDS.FieldByName('Sno').AsString+
             '���q��['+CDS.FieldByName('Orderno').AsString+'/'+
                       CDS.FieldByName('Orderitem').AsString+
             ']�i��ƶq�����?',33)=IdCancel then
     Exit;

  if not InputQuery(CheckLang('�п�J����'), 'Number', tmpSQL) then
     Exit;
  if tmpSQL = '' then
     Exit;
  try
    tmpQty1:=StrToFloat(tmpSQL);
  except
    ShowMsg('�L�Ī��ƶq!', 48);
    Exit;
  end;

  if tmpQty1<0 then
  begin
    ShowMsg('�L�Ī��ƶq!', 48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='Select Top 1 * From DLI010'
           +' Where Dno='+Quotedstr(CDS.FieldByName('Dno').AsString)
           +' And Ditem='+CDS.FieldByName('Ditem').AsString;
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('��ڤ��s�b!', 48);
      Exit;
    end;

    //�i��PDA��L
    if Length(Trim(tmpCDS.FieldByName('Dno_Ditem').AsString))>0 then
    begin
      ShowMsg('���q��w����L�@��,���i�A��!', 48);
      Exit;
    end;

    if (tmpCDS.FieldByName('delcount').AsFloat=0) and
       (tmpQty1=tmpCDS.FieldByName('notcount').AsFloat) then
    begin
      ShowMsg('�����ƶq���ର0!', 48);
      Exit;
    end;

    tmpQty2:=RoundTo(tmpCDS.FieldByName('notcount').AsFloat-
                     tmpCDS.FieldByName('delcount').AsFloat+
                     tmpCDS.FieldByName('bcount').AsFloat,-3);
    if tmpQty1>tmpQty2 then
    begin
      ShowMsg('�����ƶq:'+FloatToStr(tmpQty1)+#13#10+'����j��'+#13#10+'���X�ƶq-�˳f�ƶq+B�żƶq:'+FloatToStr(tmpQty2), 48);
      Exit;
    end;
    
    Data:=null;
    tmpSQL:='Select IsNull(Max(Ditem),0)+1 AS Sno From Dli010'
           +' Where Bu='+Quotedstr(CDS.FieldByName('Bu').AsString)
           +' And Dno='+Quotedstr(CDS.FieldByName('Dno').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;
    tmpDitem:=StrToInt(VarToStr(Data));

    with CDS do
    begin
      Edit;
      FieldByName('notcount').AsFloat:=RoundTo(tmpCDS.FieldByName('notcount').AsFloat-tmpQty1, -3);
      Post;
      Append;
      for i:=0 to tmpCDS.FieldCount -1 do
          FieldByName(tmpCDS.Fields[i].FieldName).Value:=tmpCDS.Fields[i].Value;
      FieldByName('Ditem').AsInteger:=tmpDitem;
      if Length(FieldByName('Dno_Ditem').AsString)=0 then //�O�s�Q����
         FieldByName('Dno_Ditem').AsString:=tmpCDS.FieldByName('Dno').AsString+'@'+
                                            tmpCDS.FieldByName('Ditem').AsString;
      FieldByName('Saleno').Clear;
      FieldByName('Saleitem').Clear;
      FieldByName('notcount').AsFloat:=tmpQty1;
      FieldByName('notcount1').AsFloat:=0;
      FieldByName('delcount').AsFloat:=0;
      FieldByName('delcount1').AsFloat:=0;
      FieldByName('Jcount_old').AsFloat:=0;
      FieldByName('Jcount_new').AsFloat:=0;
      FieldByName('Bcount').AsFloat:=0;
      FieldByName('Chkcount').AsFloat:=0;
      FieldByName('Coccount').AsFloat:=0;
      FieldByName('Coccount1').AsFloat:=0;
      FieldByName('Check_ans').AsBoolean:=False;
      FieldByName('Check_user').Clear;
      FieldByName('Check_date').Clear;
      FieldByName('BingBao_ans').AsBoolean:=False;
      FieldByName('Coc_ans').AsBoolean:=False;
      FieldByName('Coc_no').Clear;
      FieldByName('Coc_user').Clear;
      FieldByName('Prn_ans').AsBoolean:=False;
      FieldByName('Coc_err').AsBoolean:=False;
      FieldByName('Coc_errid').Clear;
      FieldByName('Coc_erruser').Clear;
      FieldByName('Coc_errdate').Clear;
      FieldByName('Muser').Clear;
      FieldByName('Mdate').Clear;
      FieldByName('Scantime').Clear;
      FieldByName('SourceDitem').AsInteger:=0;
      FieldByName('QtyColor').AsInteger:=0;
      FieldByName('InsFlag').AsBoolean:=False;
      FieldByName('GarbageFlag').AsBoolean:=False;
      Post;
    end;
    if PostBySQLFromDelta(CDS, 'DLI010', 'Bu,Dno,Ditem') then
    begin
      ShowMsg('�������!', 64);
      Result:=True;
    end else
    begin
      if CDS.ChangeCount>0 then
         CDS.CancelUpdates;
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

//���w�X�f����w���ͥX�f�楼�X���f���������
//IsML:True�OM/L False�O�T��O
function TDLII020_btnopt.SplitQtyAll(IsML:Boolean):Boolean;
var
  tmpIndate:TDateTime;
  tmpSQL,tmpFlag:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  tmpSQL:=DateToStr(Date);
  if not InputQuery(CheckLang('�п�J�X�f���'), 'Date', tmpSQL) then
     Exit;
  if not ConvertDate(tmpSQL, tmpIndate) then
  begin
    ShowMsg('����榡���~,�п�Jyyyy/m/d��yyyy-m-d', 48);
    Exit;
  end;

  if ShowMsg('��X�f���['+tmpSQL+']�Ҧ��w���ͥX�f��,�����X���ƶq�����,'+#13#10+
             '�T�w�i����������?',33)=IdCancel then
     Exit;

  if IsML then
     tmpFlag:='1'
  else
     tmpFlag:='0';

  tmpSQL:='exec dbo.proc_SplitDli010_All '+Quotedstr(g_UInfo^.BU)+','+
    Quotedstr(DateToStr(tmpIndate))+','+tmpFlag;
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if tmpCDS.FieldByName('errorcode').AsInteger=0 then
      begin
        ShowMsg('�@'+IntToStr(tmpCDS.FieldByName('cnt').AsInteger)+'���������!', 64);
        Result:=True;
      end else
        ShowMsg('�������!'+IntToStr(tmpCDS.FieldByName('errorcode').AsInteger), 48);
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

//�R����i�X�f��
function TDLII020_btnopt.DeleteSaleNo(CDS:TClientDataSet):Boolean;
var
  P:TBookmark;
  tmpSQL,tmpSaleno:string;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or
     (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    ShowMsg('�п�ܭn�R�����X�f��!', 48);
    Exit;
  end;

  tmpSaleno:=CDS.FieldByName('Saleno').AsString;
  if ShowMsg('�R����,�Ф�ʧ@�oTipTop���������X�f��'#13#10+
             '�T�w�R��['+tmpSaleno+']�X�f�檺�Ҧ�������?',33)=IdCancel then
     Exit;

  tmpSQL:='exec proc_Dli010ClearSaleno '+Quotedstr(CDS.FieldByName('Bu').AsString)+','
                                        +Quotedstr(tmpSaleno)+',-1';  //-1����
  if QueryOneCR(tmpSQL, Data) then
  begin
    if VarToStr(Data)='-1' then
    begin
      ShowMsg('���P�f�渹���s�b,�Э��s�d�߸�ƦA����!', 48);
      Exit;
    end
    else if VarToStr(Data)='1' then
    begin
      ShowMsg('��s����,�Э���!', 48);
      Exit;
    end;

    with CDS do
    begin
      P:=GetBookmark;
      DisableControls;
      try
        First;
        while Locate('Saleno', tmpSaleno,[]) do
        begin
          Edit;
          FieldByName('Prn_ans').AsBoolean:=False;
          FieldByName('Saleno').Clear;
          FieldByName('Saleitem').Clear;
          Post;
        end;
        MergeChangeLog;
      finally
        GotoBookmark(P);
        EnableControls;
      end;
    end;

    ShowMsg('�R������!', 48);
    Result:=True;
  end;
end;

//�R���X�f��Y�@��
function TDLII020_btnopt.DeleteSaleItem(CDS:TClientDataSet):Boolean;
var
  tmpSQL,tmpSaleno,tmpSaleitem:string;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or
     (Length(CDS.FieldByName('Saleno').AsString)=0) then
  begin
    ShowMsg('�п�ܭn�R�����X�f�涵��!', 48);
    Exit;
  end;

  tmpSaleno:=CDS.FieldByName('Saleno').AsString;
  tmpSaleitem:=CDS.FieldByName('Saleitem').AsString;
  if ShowMsg('�R����,�Ф�ʧ��TipTop���������X�f�涵��'#13#10+
             '�T�w�R��['+tmpSaleno+'/'+tmpSaleitem+']�X�f�涵����?',33)=IdCancel then
     Exit;

  tmpSQL:='exec proc_Dli010ClearSaleno '+Quotedstr(CDS.FieldByName('Bu').AsString)+','
                                        +Quotedstr(tmpSaleno)+','
                                        +Quotedstr(tmpSaleitem);
  if QueryOneCR(tmpSQL, Data) then
  begin
    if VarToStr(Data)='-1' then
    begin
      ShowMsg('���P�f�渹���s�b,�Э��s�d�߸�ƦA����!', 48);
      Exit;
    end
    else if VarToStr(Data)='1' then
    begin
      ShowMsg('��s����,�Э���!', 48);
      Exit;
    end;

    with CDS do
    begin
      Edit;
      FieldByName('Prn_ans').AsBoolean:=False;
      FieldByName('Saleno').Clear;
      FieldByName('Saleitem').Clear;
      Post;
      MergeChangeLog;
    end;

    ShowMsg('�R������!', 64);
    Result:=True;
  end;
end;

//�R���Y�@���˳f���(�å]���i�R��)
function TDLII020_btnopt.DeleteLot(CDS, CDS2:TClientDataSet):Boolean;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;

  if (not CDS.Active) or CDS.IsEmpty or (not CDS2.Active) or CDS2.IsEmpty then
  begin
    ShowMsg('�п�ܭn�R�����帹!', 48);
    Exit;
  end;

  if Length(CDS.FieldByName('Saleno').AsString)>0 then
  begin
    ShowMsg('�w���ͥX�f��,���i�R��!', 48);
    Exit;
  end;

  if CDS2.FieldByName('JFlag').AsInteger=2 then
  begin
    ShowMsg('�Х��R��[�å]�T�{]�����!', 48);
    Exit;
  end;

  if ShowMsg('�T�w�R���o���帹��ƶ�,�R���ᤣ�i���?'#13#10'�ܮw�G'+
       CDS2.FieldByName('StkPlace').AsString+#13#10'�x��G'+
       CDS2.FieldByName('StkArea').AsString+#13#10'�帹�G'+
       CDS2.FieldByName('Manfac').AsString+#13#10'�ƶq�G'+
       CDS2.FieldByName('Qty').AsString, 33)=IdCancel then
     Exit;

  tmpSQL:=' Declare @Bu nvarchar(10)'
         +' Declare @Dno nvarchar(20)'
         +' Declare @Ditem int'
         +' Set @Bu='+Quotedstr(CDS2.FieldByName('Bu').AsString)
         +' Set @Dno='+Quotedstr(CDS2.FieldByName('Dno').AsString)
         +' Set @Ditem='+Quotedstr(CDS2.FieldByName('Ditem').AsString)
         +' Delete From DLI020 Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem'
         +' And Sno='+CDS2.FieldByName('Sno').AsString
         +' exec dbo.proc_UpdateDelcount @Bu,@Dno,@Ditem'
         +' exec dbo.proc_UpdateBingbao @Bu,@Dno,@Ditem'
         +' Select Delcount,Jcount_old,Jcount_new,Bcount From DLI010'
         +' Where Bu=@Bu And Dno=@Dno And Ditem=@Ditem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      CDS.Edit;
      CDS.FieldByName('Delcount').AsFloat:=tmpCDS.Fields[0].AsFloat;
      CDS.FieldByName('Jcount_old').AsFloat:=tmpCDS.Fields[1].AsFloat;
      CDS.FieldByName('Jcount_new').AsFloat:=tmpCDS.Fields[2].AsFloat;
      CDS.FieldByName('Bcount').AsFloat:=tmpCDS.Fields[3].AsFloat;
      CDS.Post;
      CDS.MergeChangeLog;
    finally
      FreeAndNil(tmpCDS);
    end;
    ShowMsg('�R������!', 64);
    Result:=True;
  end;
end;

end.
 