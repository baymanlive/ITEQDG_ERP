{*******************************************************}
{                                                       }
{                unMPST040_IndateClass                  }
{                Author: kaikai                         }
{                Create date: 2016/03/18                }
{                Description: �s�W�X�f��@�γ椸        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_IndateClass;

interface

uses
  Windows, SysUtils, Classes, DB, DBClient, ComCtrls, DateUtils, Forms,
  Variants, Math, unGlobal, unCommon, unMPST040_units;

type
  TOutQty = Record
    ditem: Integer;
    qty  : Double;
end;

type
  TArrOutQty = array of TOutQty;

type
  TMPST040_IndateClass = class
  private
    FArrOutQty:TArrOutQty;
    FStimeCDS:TClientDataSet;
    FDLI010CDS:TClientDataSet;
    function GetStime(Custno:string): TDateTime;
    procedure ShowSB(msg:string);
    function GetData: OleVariant;
    procedure SetOutQty(Value: TArrOutQty);
  public
    constructor Create;
    destructor Destroy; override;
    function Exec(Indate:TDateTime; MPS200SQL:string;
      IsConfirm:Boolean; var OutMsg:string):Boolean;
  published
    property Data: OleVariant read GetData;
    property ArrOutQty: TArrOutQty write SetOutQty;
  end;

implementation

{ TMPST040_IndateClass }

constructor TMPST040_IndateClass.Create;
begin
  FStimeCDS:=TClientDataSet.Create(nil);
  FDLI010CDS:=TClientDataSet.Create(nil);
end;

destructor TMPST040_IndateClass.Destroy;
begin
  FreeAndNil(FStimeCDS);
  FreeAndNil(FDLI010CDS);

  inherited;
end;

function TMPST040_IndateClass.Exec(Indate:TDateTime; MPS200SQL: string;
  IsConfirm:Boolean; var OutMsg:string): Boolean;
var
  IsLock:Boolean;
  i,j,tmpDitem,tmpSno:Integer;
  tmpBool:Boolean;
  tmpQty:Double;
  tmpSQL,tmpStr,tmpDno,tmpMsg,tmpRemark:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
  tmpList:TStrings;
begin
  Result:=False;
  OutMsg:='';

  if ShowMsg('�T�w�s�W'+DateToStr(Indate)+'������X�f���?', 33)=IdCancel then
     Exit;

  if not CheckLockProc(IsLock) then
     Exit;

  if IsLock then
  begin
    ShowMsg('�X�f�Ƶ{�Q�O���ϥΪ̼Ȯ���w,�Э���!', 48);
    Exit;
  end;

  if not LockProc then
     Exit;

  IsLock:=True;   
  try
    //Indate�X�f��
    tmpSQL:='Select * From DLI010 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(Indate))
           +' And Len(IsNull(Dno_Ditem,''''))=0'
           +' And IsNull(GarbageFlag,0)=0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    FDLI010CDS.Data:=Data;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    tmpCDS3:=TClientDataSet.Create(nil);
    tmpList:=TStringList.Create;
    try
      //�������tmpCDS1
      ShowSB('���b�d�ߩ������...');
      Data:=null;
      if not QueryBySQL(MPS200SQL, Data) then
         Exit;
      tmpCDS1.Data:=Data;
      if tmpCDS1.IsEmpty then
      begin
        OutMsg:='�L�������!';
        Exit;
      end;

      //�Ҧ��q�渹�X
      with tmpCDS1 do
      while not Eof do
      begin
        tmpStr:=tmpStr+','+Quotedstr(FieldByName('Orderno').AsString);
        Next;
      end;
      Delete(tmpStr,1,1);

      //tiptop���tmpCDS2
      ShowSB('���b�d�߭q����...');
      Data:=null;
      tmpSQL:=GetOraSQL(g_UInfo^.BU,' and oea01 in ('+tmpStr+')');
      if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
         Exit;
      tmpCDS2.Data:=Data;

      ShowSB('���b�B�z���...');
      tmpStr:='';
      tmpDno:=GetSno('DLII010');
      tmpSno:=GetMPSSno(Indate);
      tmpDitem:=1;
      tmpCDS1.First;
      g_ProgressBar.Max:=tmpCDS1.RecordCount;
      g_ProgressBar.Position:=0;
      g_ProgressBar.Visible:=True;
      while not tmpCDS1.Eof do
      begin
        g_ProgressBar.Position:=g_ProgressBar.Position+1;
        Application.ProcessMessages;
        
        tmpBool:=False;
        tmpMsg:=tmpCDS1.FieldByName('Orderno').AsString+'/'+
                tmpCDS1.FieldByName('Orderitem').AsString+' ';
        tmpQty:=tmpCDS1.FieldByName('Qty').AsFloat;
        tmpRemark:=Trim(tmpCDS1.FieldByName('Remark1').AsString);
        if Assigned(FArrOutQty) then
        for i:=Low(FArrOutQty) to High(FArrOutQty) do
        if FArrOutQty[i].ditem=tmpCDS1.FieldByName('ditem').AsInteger then
        begin
          tmpQty:=FArrOutQty[i].qty;
          tmpBool:=True;
        end;

        if not tmpCDS2.Locate('oea01;oeb03',VarArrayOf(
              [tmpCDS1.FieldByName('Orderno').AsString,
               tmpCDS1.FieldByName('Orderitem').AsString]),[]) then
           tmpStr:=tmpStr+tmpMsg+' TipTop���s�b'+#13#10
        else if (not IsConfirm) and SameText(g_UInfo^.BU,'ITEQGZ') and
          SameText(tmpCDS2.FieldByName('oea04').AsString,'N005') and
          (Pos(Copy(tmpCDS2.FieldByName('oao06').AsString,1,5),'AC360/AC625/ACB00/AC263')=0) then //���T�{�X�f��:�s�{�X�f��X�F��,����q�o����,�n�q�Ͳ��Ƶ{�i��ƥX�f; �w�T�{:�i�浧�s�W
        begin
          tmpCDS1.Next;
          Continue;
        end
        else if tmpCDS2.FieldByName('oeb70').AsString='Y' then
           tmpStr:=tmpStr+tmpMsg+tmpCDS2.FieldByName('oea04').AsString+' �w����'+#13#10
        else if tmpCDS1.FieldByName('Materialno').AsString<>tmpCDS2.FieldByName('oeb04').AsString then
           tmpStr:=tmpStr+tmpMsg+tmpCDS2.FieldByName('oea04').AsString+' �Ƹ����ۦP'+#13#10
        else if tmpCDS2.FieldByName('oeb12').AsFloat<=0 then
           tmpStr:=tmpStr+tmpMsg+tmpCDS2.FieldByName('oea04').AsString+' �q��q��0'+#13#10
        else if tmpQty>tmpCDS2.FieldByName('notqty').AsFloat then
           tmpStr:=tmpStr+tmpMsg+tmpCDS2.FieldByName('oea04').AsString+' �X�f�ƶq['+FloatToStr(tmpQty)+']�j�󥼥X�ƶq['+FloatToStr(tmpCDS2.FieldByName('notqty').AsFloat)+']'+#13#10
        else begin
          //��sMPS200
          tmpCDS1.Edit;
          if tmpBool then
          begin
            tmpCDS1.FieldByName('Flag').AsInteger:=0;
            tmpCDS1.FieldByName('Qty').AsFloat:=RoundTo(tmpCDS1.FieldByName('Qty').AsFloat-tmpQty, -3);
            tmpCDS1.FieldByName('Remark1').AsString:=Trim(tmpRemark+' '+IntToStr(MonthOf(Indate))+'/'
                +IntToStr(DayOf(Indate))+CheckLang('�w�X')+FloatToStr(tmpQty));
          end else
            tmpCDS1.FieldByName('Flag').AsInteger:=1;
          tmpCDS1.Post;

          tmpList.Add(tmpCDS2.FieldByName('oea01').AsString+'/'+
             IntToStr(tmpCDS2.FieldByName('oeb03').AsInteger));

          //�K�[��ƨ�DLI010�B���T�{�֥[
          with FDLI010CDS do
          begin
            if (not IsConfirm) and  Locate('Orderno;Orderitem;Pno',
                  VarArrayOf([tmpCDS2.FieldByName('oea01').AsString,
                              tmpCDS2.FieldByName('oeb03').AsInteger,
                              tmpCDS2.FieldByName('oeb04').AsString]), []) then
            begin
              Edit;
              FieldByName('Notcount1').AsFloat:=FieldByName('Notcount1').AsFloat+tmpQty;
            end else
            begin
              Append;

              for j:=0 to FieldCount-1 do
              if Fields[j].DataType in [ftBoolean] then
                 Fields[j].AsBoolean:=False
              else if Fields[j].DataType in [ftFloat, ftCurrency, ftBCD, ftSmallint, ftInteger, ftWord] then
                 Fields[j].Value:=0;

              FieldByName('Bu').AsString:=g_UInfo^.BU;
              FieldByName('Dno').AsString:=tmpDno;
              FieldByName('Ditem').AsInteger:=tmpDitem;
              FieldByName('Sno').AsInteger:=tmpSno;
              FieldByName('Indate').AsDateTime:=DateOf(Indate);
              FieldByName('Iuser').AsString:=g_Uinfo^.UserId;
              FieldByName('Idate').AsDateTime:=Now;
              FieldByName('InsFlag').AsBoolean:=IsConfirm;   //�X�f��w�T�{,��ܴ���
              FieldByName('W_pno').Clear;
              FieldByName('W_qty').Clear;

              //tiptop
              FieldByName('Odate').AsDateTime:=DateOf(tmpCDS2.FieldByName('oea02').AsDateTime);
              FieldByName('Ddate').AsDateTime:=DateOf(tmpCDS2.FieldByName('oeb15').AsDateTime);
              FieldByName('Custno').AsString:=tmpCDS2.FieldByName('oea04').AsString;
              FieldByName('Custshort').AsString:=tmpCDS2.FieldByName('occ02').AsString;
              FieldByName('Orderno').AsString:=tmpCDS2.FieldByName('oea01').AsString;
              FieldByName('Orderitem').AsInteger:=tmpCDS2.FieldByName('oeb03').AsInteger;
              FieldByName('Pno').AsString:=tmpCDS2.FieldByName('oeb04').AsString;
              FieldByName('Pname').AsString:=tmpCDS2.FieldByName('oeb06').AsString;
              FieldByName('Sizes').AsString:=tmpCDS2.FieldByName('ima021').AsString;
              FieldByName('Longitude').AsString:=tmpCDS2.FieldByName('ta_oeb01').AsString;
              FieldByName('Latitude').AsString:=tmpCDS2.FieldByName('ta_oeb02').AsString;
              FieldByName('Ordercount').AsFloat:=tmpCDS2.FieldByName('oeb12').AsFloat;
              FieldByName('Notcount').AsFloat:=tmpQty;
              FieldByName('Notcount1').AsFloat:=tmpQty;
              FieldByName('Units').AsString:=tmpCDS2.FieldByName('oeb05').AsString;
              FieldByName('Custorderno').AsString:=tmpCDS2.FieldByName('oea10').AsString;
              FieldByName('Custprono').AsString:=tmpCDS2.FieldByName('oeb11').AsString;
              FieldByName('Custname').AsString:=tmpCDS2.FieldByName('ta_oeb10').AsString;
              FieldByName('Remark').AsString:=tmpCDS2.FieldByName('oao06').AsString;
              FieldByName('SendAddr').AsString:=tmpCDS2.FieldByName('ocd221').AsString;
              case StrToIntDef(tmpCDS2.FieldByName('ta_oeb22').AsString, -1) of
                0:FieldByName('CtrlRemark').AsString:=CheckLang('���ޱ�');
                1:FieldByName('CtrlRemark').AsString:=CheckLang('�i�u��');
                2:FieldByName('CtrlRemark').AsString:=CheckLang('�i�W��');
                3:FieldByName('CtrlRemark').AsString:=CheckLang('���i�u�椣�i�W��');
              end;
              FieldByName('kg').AsString:=tmpCDS2.FieldByName('ima18').AsString;
              //tiptop

              FieldByName('SourceDitem').AsInteger:=tmpCDS1.FieldByName('Ditem').AsInteger;
              FieldByName('Stime').AsDateTime:=GetStime(FieldByName('Custno').AsString);
              FieldByName('Adate').Value:=tmpCDS1.FieldByName('Adate').Value;
              FieldByName('Remark4').AsString:=tmpRemark;                                  //�����ͺ޳Ƶ�
              FieldByName('SaleRemark').AsString:=tmpCDS1.FieldByName('Remark2').AsString; //������޳Ƶ�
              Inc(tmpDitem); Inc(tmpSno);
            end;
            Post;
          end;

          //�Ƶ��@�A�Ƶ��G�A�Ƶ��T��Ƶ{��� (�Ƶ����ɭ��W��J)
          Data:=null;
          if Pos(Copy(FDLI010CDS.FieldByName('Pno').AsString,1,1),'ET')>0 then
             tmpSQL:='1'
          else
             tmpSQL:='0';
          tmpSQL:='exec proc_MPST030_3 '+Quotedstr(g_UInfo^.BU)+','+
                                         Quotedstr(FDLI010CDS.FieldByName('Orderno').AsString)+','+
                                         Quotedstr(FDLI010CDS.FieldByName('Orderitem').AsString)+',1,'+tmpSQL;
          if QueryBySQL(tmpSQL, Data) then
          begin
            i:=1;
            tmpCDS3.Data:=Data;
            with tmpCDS3 do
            while not Eof do
            begin
              FDLI010CDS.Edit;
              FDLI010CDS.FieldByName('Remark'+IntToStr(i)).AsString:=
                      Trim(FieldByName('wono').AsString+' '+
                           IntToStr(MonthOf(FieldByName('sdate').AsDateTime))+'/'+
                           IntToStr(DayOf(FieldByName('sdate').AsDateTime))+' '+
                           FieldByName('machine').AsString+'-'+
                           FieldByName('sqty').AsString);
              if Pos(Copy(FDLI010CDS.FieldByName('Pno').AsString,1,1),'ET')>0 then
                 FDLI010CDS.FieldByName('Remark'+IntToStr(i)).AsString:=FDLI010CDS.FieldByName('Remark'+IntToStr(i)).AsString
                           +' '+FieldByName('currentboiler').AsString+CheckLang('��');
              FDLI010CDS.Post;
              Inc(i);
              if i>3 then
                 Break;
              Next;
            end;
          end;
          //**

        end;

        tmpCDS1.Next;
      end;

      tmpSQL:='�s�W����,�@����'+IntToStr(tmpList.Count)+'��';
      if tmpList.Count=0 then
      begin
        FDLI010CDS.EmptyDataSet;
        FDLI010CDS.MergeChangeLog;
        OutMsg:=tmpSQL+#13#10+tmpStr;
        Result:=True;
        Exit;
      end;

      ShowSB('���b�x�s���...');
      if CDSPost(FDLI010CDS, 'DLI010') then
      begin
        IsLock:=CDSPost(tmpCDS1, 'MPS200');
        if IsLock then
           tmpStr:=tmpSQL+#13#10+tmpStr
        else
           tmpStr:=tmpSQL+#13#10+'��s�аO����,�X�f��N��w,���p���޲z��'+#13#10+tmpStr;

        //�u�O�d���ʪ�
        with FDLI010CDS do
        begin
          First;
          while not Eof do
          begin
            if tmpList.IndexOf(FieldByName('Orderno').AsString+'/'+
                      IntToStr(FieldByName('Orderitem').AsInteger))=-1 then
            begin
              Delete;
              Continue;
            end;
            Next;
          end;
          MergeChangeLog;
        end;

        OutMsg:=tmpStr;
        Result:=True;
      end;
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      FreeAndNil(tmpCDS3);
      FreeAndNil(tmpList);
      g_ProgressBar.Visible:=False;
    end;
  finally
    ShowSB('');
    if IsLock then
       UnLockProc;
  end;
end;

function TMPST040_IndateClass.GetData: OleVariant;
begin
  if FDLI010CDS.Active then
     Result:=FDLI010CDS.Data
  else
     Result:=null;
end;

procedure TMPST040_IndateClass.SetOutQty(Value: TArrOutQty);
begin
  FArrOutQty:=Value;
end;

function TMPST040_IndateClass.GetStime(Custno: string): TDateTime;
var
  Data:OleVariant;
  tmpSQL:string;
begin
  Result:=EncodeDateTime(1955,5,5,0,0,0,0);
  if not FStimeCDS.Active then
  begin
    tmpSQL:='Select Custno,Stime From MPS290 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;

    FStimeCDS.Data:=Data;
  end;

  with FStimeCDS do
  begin
    First;
    while not Eof do
    begin
      if Pos(Custno, Fields[0].AsString)>0 then
      begin
        if not Fields[1].IsNull then
           Result:=EncodeDateTime(1955,5,5,HourOf(Fields[1].AsDateTime),
                                           MinuteOf(Fields[1].AsDateTime),0,0);
        Break;
      end;
      Next;
    end;
  end;
end;

procedure TMPST040_IndateClass.ShowSB(msg: string);
begin
  g_StatusBar.Panels[0].Text:=msg;
  Application.ProcessMessages;
end;

end.
 