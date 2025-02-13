{*******************************************************}
{                                                       }
{                unMPST070_Mps                          }
{                Author: kaikai                         }
{                Create date: 2016/11/28                }
{                Description: PP����Ƶ{                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST070_Mps;

interface

uses
  Windows, Classes, SysUtils, ComCtrls, DB, DBClient, Variants, StrUtils, unGlobal, unCommon, unMPST070_Param;

type
  TMachineLine = packed record
    Machine: string;
    OrderObj: TList;
  end;

type
  TMPST070_Mps = class
  private
    FCDS_ChanNeng: TClientDataSet;
    FLockAns: Boolean;
    FErrList: TStrings;          //�Ƶ{�L�{�����~����
    FErrorIdList: TStrings;      //���`���Ƴ渹
    FArrMachineLine: array of TMachineLine;
    FParam: TMPST070_Param;
    procedure ClrearMachineLine;
    procedure CheckLock(OptLockAns: Boolean);
    procedure SetPData(SourceDS: TClientDataSet; P: POrderRec);
    procedure GetPData(DestDS: TClientDataSet);
    procedure UpdateJXOrders(cds: TClientDataSet);
  public
    constructor Create;
    destructor Destroy; override;
    function ExecMPS(SourceDS, DestDS: TClientDataSet; var OptLockAns: Boolean): Boolean; //�ݱƸ�ơB�Ƶ{���G�B�@�~��w
    function GetSpeed(Machine, Pno: string): Double;
    function GetFiber(Fiber: string): string;
    function GetFiSno(Fiber: string): Integer;
  published
    property LockAns: Boolean read FLockAns write FLockAns;
    property ErrList: TStrings read FErrList;
    property ErrorIdList: TStrings read FErrorIdList;
    property CDS_ChanNeng: TClientDataSet read FCDS_ChanNeng;
  end;

implementation

{ TMPST070_Mps }

constructor TMPST070_Mps.Create;
var
  i: Integer;
begin
  FErrList := TStringList.Create;
  FErrorIdList := TStringList.Create;
  FParam := TMPST070_Param.Create;
  FCDS_ChanNeng := FParam.CDS_ChanNeng;

  FErrList.DelimitedText := g_MachinePP;
  SetLength(FArrMachineLine, FErrList.Count);
  for i := 0 to FErrList.Count - 1 do
  begin
    FArrMachineLine[i].Machine := FErrList.Strings[i];
    FArrMachineLine[i].OrderObj := TList.Create;
  end;
  FErrList.Clear;
end;

destructor TMPST070_Mps.Destroy;
var
  i: Integer;
begin
  FreeAndNil(FErrList);
  FreeAndNil(FErrorIdList);
  FreeAndNil(FParam);
  ClrearMachineLine;
  for i := Low(FArrMachineLine) to High(FArrMachineLine) do
    FArrMachineLine[i].OrderObj.Free;
  FArrMachineLine := nil;

  inherited Destroy;
end;

//�ˬd��w�аO
procedure TMPST070_Mps.CheckLock(OptLockAns: Boolean);
var
  IsLock: Boolean;
begin
  if not FLockAns then
    if CheckLockProc(IsLock) then
      FLockAns := IsLock
    else
      Abort;

  if FLockAns then
  begin
    if OptLockAns then
      ShowMsg('�Ƶ{�w��w,�нT�{�Ƶ{!', 16)
    else
      ShowMsg('�Ƶ{�w��w,�Э��s�d�ߩέ��s�}�ҧ@�~!', 16);
    Abort;
  end;
end;

//�M�����x���
procedure TMPST070_Mps.ClrearMachineLine;
var
  i, j: Integer;
begin
  for i := Low(FArrMachineLine) to High(FArrMachineLine) do
  begin
    for j := 0 to FArrMachineLine[i].OrderObj.Count - 1 do
      Dispose(POrderRec(FArrMachineLine[i].OrderObj[j]));
    FArrMachineLine[i].OrderObj.Clear;
  end;
end;

//��l�ƭq����
procedure TMPST070_Mps.SetPData(SourceDS: TClientDataSet; P: POrderRec);
//var custInfo:TCustInfo;
begin
  with SourceDS do
  begin
    P^.orderdate := FieldByName('orderdate').Value;
    P^.orderno := FieldByName('orderno').Value;
    P^.orderitem := FieldByName('orderitem').Value;
    P^.custno := FieldByName('custno').Value;
//    P^.custno2:=FieldByName('oea04').Value;  //?
//    if JxRemark(FieldbyName('oao06').AsString,custInfo) then
//      P^.custno2:=custInfo.No;
    P^.custom := FieldByName('custom').Value;
    if P^.custno <> 'N024' then
      P^.custom2 := FieldByName('custom2').Value
    else
      P^.custom2 := FieldByName('occ02').Value;
    P^.edate := FieldByName('edate').Value;
    P^.adate := FieldByName('adate').Value;
    P^.materialno := FieldByName('materialno').Value;
    P^.materialno1 := FieldByName('materialno1').Value;
    P^.pnlsize1 := FieldByName('pnlsize1').Value;
    P^.pnlsize2 := FieldByName('pnlsize2').Value;
    if Length(P^.materialno) = 18 then
      P^.breadth := Copy(P^.materialno, 14, 2) + '.' + Copy(P^.materialno, 16, 1)
    else
      P^.breadth := '';
    P^.orderqty := FieldByName('orderqty').Value;
    P^.sqty := FieldByName('sqty').Value;
    P^.errorid := FieldByName('errorid').Value;
    P^.wono := FieldByName('wono').Value;
    P^.orderno2 := FieldByName('orderno2').Value;
    P^.orderitem2 := FieldByName('orderitem2').Value;
    P^.srcflag := FieldByName('srcflag').Value;
    P^.pnlnum := FieldByName('pnlnum').Value;
    if Length(Trim(FieldByName('machine1').AsString)) > 0 then    //2�����w
    begin                                                       //1.���x
      P^.machine1 := UpperCase(FieldByName('machine1').Value);    //2.���x+���

      try
        StrToDate(VarToStr(FieldByName('sdate1').Value));
        P^.sdate1 := FieldByName('sdate1').Value;
      except
        P^.sdate1 := null;
      end;
    end
    else
    begin
      P^.sdate1 := null;
      P^.machine1 := null;
    end;
    if Pos(LeftStr(P^.materialno, 1), 'PQ') > 0 then
      P^.custno := CheckLang('�ۥ�');
  end;
end;

//�K�[�Ƶ{���G
procedure TMPST070_Mps.GetPData(DestDS: TClientDataSet);
var
  pg: string;
  i, j: Integer;
  P: POrderRec;
begin
  FErrorIdList.Clear;
  DestDS.EmptyDataSet;
  for i := Low(FArrMachineLine) to High(FArrMachineLine) do
  begin
    for j := 0 to FArrMachineLine[i].OrderObj.Count - 1 do
    begin
      P := POrderRec(FArrMachineLine[i].OrderObj.List[j]);

      DestDS.Append;
      DestDS.FieldByName('Machine').AsString := FArrMachineLine[i].Machine;
      DestDS.FieldByName('Sdate').Value := P^.sdate;
      DestDS.FieldByName('OrderDate').Value := P^.orderdate;
      DestDS.FieldByName('OrderNo').Value := P^.orderno;
      DestDS.FieldByName('OrderItem').Value := P^.orderitem;
      DestDS.FieldByName('Custno').Value := P^.custno;
      DestDS.FieldByName('Custom').Value := P^.custom;
      DestDS.FieldByName('Custom2').Value := P^.custom2;
      DestDS.FieldByName('Edate').Value := P^.edate;
      if VarIsNull(P^.adate) then
      begin
        if SameText(g_UInfo^.BU, 'ITEQJX') then
        begin
          if Length(VarToStr(P^.materialno1)) > 0 then
            DestDS.FieldByName('Adate').AsDateTime := P^.sdate + 4
          else
            DestDS.FieldByName('Adate').AsDateTime := P^.sdate + 3;
        end
        else
        begin
          if Length(VarToStr(P^.materialno1)) > 0 then
            DestDS.FieldByName('Adate').AsDateTime := P^.sdate + 3
          else
            DestDS.FieldByName('Adate').AsDateTime := P^.sdate + 2;
        end;
      end
      else
        DestDS.FieldByName('Adate').AsDateTime := P^.adate;
      DestDS.FieldByName('Materialno').Value := P^.materialno;
      DestDS.FieldByName('Materialno1').Value := P^.materialno1;
      DestDS.FieldByName('Pnlsize1').Value := P^.pnlsize1;
      DestDS.FieldByName('Pnlsize2').Value := P^.pnlsize2;
      DestDS.FieldByName('Breadth').Value := P^.breadth;
      DestDS.FieldByName('Fiber').Value := P^.fiber;
      DestDS.FieldByName('AD').Value := Copy(P^.materialno, 2, 1);
      if SameText(DestDS.FieldByName('AD').Value, 'J') then
        DestDS.FieldByName('AD').Value := '1';
      if Length(P^.materialno) = 18 then
      begin
        DestDS.FieldByName('FI').Value := Copy(P^.materialno, 4, 4);
        DestDS.FieldByName('RC').Value := Copy(P^.materialno, 8, 3);
      end
      else
      begin
        DestDS.FieldByName('FI').Value := GetFiber(Copy(P^.materialno, 4, 2));
        DestDS.FieldByName('RC').Value := Copy(P^.materialno, 6, 3);
      end;
      DestDS.FieldByName('FISno').AsInteger := GetFiSno(DestDS.FieldByName('FI').AsString);
      if DestDS.FieldByName('FI').AsString = '3313' then //3313<=>2313
        DestDS.FieldByName('FI').AsString := '2313a';
      pg := Copy(P^.materialno, 3, 1);
      if Pos(pg, '36') > 0 then
        pg := '36'
      else if Pos(pg, '8T') > 0 then
        pg := '8T'
      else
        pg := pg + '@';
      DestDS.FieldByName('PG').Value := pg;
      DestDS.FieldByName('Orderqty').Value := P^.orderqty;
      DestDS.FieldByName('Sqty').Value := P^.sqty;
      DestDS.FieldByName('sdate1').Value := P^.sdate1;
      DestDS.FieldByName('machine1').Value := P^.machine1;
      DestDS.FieldByName('ErrorId').Value := P^.errorid;
      DestDS.FieldByName('Wono').Value := P^.wono;
      DestDS.FieldByName('OrderNo2').Value := P^.orderno2;
      DestDS.FieldByName('OrderItem2').Value := P^.orderitem2;
      DestDS.FieldByName('SrcFlag').Value := P^.srcflag;
      DestDS.Post;
      if Length(VarToStr(P^.errorid)) > 0 then
        FErrorIdList.Add(P^.errorid);
    end;
  end;
end;

procedure TMPST070_Mps.UpdateJXOrders(cds: TClientDataSet);
var
  s1, s2: string;
  Data1: OleVariant;
begin
  cds.First;
  s1 := '';
  while not cds.Eof do
  begin
    if cds.FieldByName('custno').AsString = 'N024' then
    begin
      s2 := ' or (oao01=' + QuotedStr(cds.FieldByName('orderno').AsString) + ')';
      if Pos(s2, s1) = 0 then
        s1 := s1 + s2;
    end;
    cds.next;
  end;
  s1 := 'select oao06 from oao_file where 1=2 ' + s1;
  cds.first;
end;

//����Ƶ{
function TMPST070_Mps.ExecMPS(SourceDS, DestDS: TClientDataSet; var OptLockAns: Boolean): Boolean;
var
  i, j, tmpNum: Integer;
  tmpMachine, tmpErrMsg, tmpAdhesive, tmpFiber, tmpLockErrMsg: string;
  tmpSdate: TDateTime;
  isBS, isIgnore, isFiLock: Boolean;
  P, P1: POrderRec;
  tmpCapacity: Integer;          //����:����
  tmpSpeed, tmpSqty: Double;      //��t:��/����
  SMRecPP: TSplitMaterialnoPP;
  SMRecPPCore: TSplitMaterialnoPPCore;
begin
  Result := False;

  if (not SourceDS.Active) or SourceDS.IsEmpty then
  begin
    ShowMsg('�ݱƭq��L���!', 48);
    Exit;
  end;

  if ShowMsg('�T�w�n�i��Ƶ{��?', 33) = IDCancel then
    Exit;

  if DestDS.State in [dsInsert, dsEdit] then
    DestDS.Post;

  if SourceDS.State in [dsInsert, dsEdit] then
    SourceDS.Post;
  UpdateJXOrders(SourceDS);
  //��w�@�~
  if not OptLockAns then
  begin
    CheckLock(OptLockAns);

    OptLockAns := LockProc;
    if not OptLockAns then
      Exit;

    FLockAns := OptLockAns;
  end;

  FErrList.Clear;
  ClrearMachineLine;
  FParam.GetParameData_Exec;
  New(P);
  g_ProgressBar.Visible := True;
  SourceDS.DisableControls;
  try
    g_ProgressBar.Position := 0;
    g_ProgressBar.Max := SourceDS.RecordCount * 2;
    for i := 1 to 2 do
    begin
      SourceDS.First;
      while not SourceDS.Eof do
      begin
        g_ProgressBar.Position := g_ProgressBar.Position + 1;

        if SameText(g_UInfo^.BU, 'ITEQDG') then
        begin
          if Pos(LeftStr(SourceDS.FieldByName('Orderno').AsString, 3), '223,227,237,228,22G,222,22A') > 0 then
          begin
            if Pos(LeftStr(SourceDS.FieldByName('Materialno').AsString, 1), 'T,B,M') = 0 then
            begin
              ShowMsg('��' + IntToStr(SourceDS.RecNo) + '���G�q���O�P�Ƹ�����!', 48);
              Exit;
            end;
          end
          else
          begin
            if Pos(LeftStr(SourceDS.FieldByName('Materialno').AsString, 1), 'E,R,N') = 0 then
            begin
              ShowMsg('��' + IntToStr(SourceDS.RecNo) + '���G�q���O�P�Ƹ�����!', 48);
              Exit;
            end;
          end;
        end;

        if SourceDS.FieldByName('Sqty').AsFloat <= 0 then
        begin
          SourceDS.Next;
          Continue;
        end;

        tmpMachine := Trim(SourceDS.FieldByName('machine1').AsString);
        if i = 1 then              //��2��,���ƫ��w��(�s�b�h�E��while,�ݭץ�)
        begin
          if tmpMachine = '' then
          begin
            SourceDS.Next;
            Continue;
          end;
        end
        else
        begin
          if tmpMachine <> '' then
          begin
            SourceDS.Next;
            Continue;
          end;
        end;

        SetPData(SourceDS, P);
        isBS := Length(P^.materialno) = 18;
        if isBS then
        begin
          FParam.SetBSRec(SMRecPP, P^.materialno);
          tmpMachine := FParam.GetMachineFilter(SMRecPP, P);
          tmpErrMsg := P^.orderno + '/' + VarToStr(P^.orderitem) + ' ' + P^.materialno + ' ';
        end
        else
        begin
          FParam.SetCoreRec(SMRecPPCore, P^.materialno);
          tmpMachine := FParam.GetMachineFilterCore(SMRecPPCore, P);
          P^.breadth := SMRecPPCore.M10;
          tmpErrMsg := P^.materialno + ' ';
        end;

        if Length(tmpMachine) = 0 then
        begin
          if isBS then
            FErrList.Add(tmpErrMsg + '�䤣��BS���w���x�]�w')
          else
            FErrList.Add(tmpErrMsg + '�䤣�줺��Core���w���x�]�w');
          SourceDS.Next;
          Continue;
        end;

        if isBS then
          if FParam.CheckPNLLock(P) then
          begin
            FErrList.Add(tmpErrMsg + 'PN�O�����Q�βv��w');
            SourceDS.Next;
            Continue;
          end;

        if isBS then
          tmpAdhesive := SMRecPP.M2
        else
          tmpAdhesive := SMRecPPCore.M2;

        with FParam.CDS_ChanNeng do
        begin
          Filtered := False;
          Filter := '(' + tmpMachine + ') and capacity>0 and lock=0';
          if not VarIsNull(P^.sdate1) then
            Filter := Filter + ' and wdate=' + Quotedstr(DateToStr(P^.sdate1));
          Filtered := True;
          IndexFieldNames := 'wdate;machine';
          if IsEmpty then
          begin
            if VarIsNull(P^.sdate1) then
              FErrList.Add(tmpErrMsg + tmpMachine + '���ण��')
            else
              FErrList.Add(tmpErrMsg + tmpMachine + '���w�Ͳ����' + DateToStr(P^.sdate1) + '���ण��');
            SourceDS.Next;
            Continue;
          end;

          while not Eof do
          begin
            isIgnore := False;
            tmpMachine := FieldByName('machine').AsString;
            tmpNum := FParam.AdIsPlan(tmpMachine, tmpAdhesive, FieldByName('wdate').AsDateTime);

            if tmpNum = 0 then        //�����t�D�p���Ͳ�,�P�_���x+����O�_�s�b��L���t�p�E�Ͳ�
              if FParam.SdateIsPlan(tmpMachine, FieldByName('wdate').AsDateTime) then
              begin
                if not VarIsNull(P^.sdate1) then
                  isIgnore := True;
                if not isIgnore then
                begin
                  Next;
                  if Eof then
                    FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P^.sqty) + ',�p���ʥͲ����ण��');
                  Continue;
                end;
              end;

            if tmpNum = 1 then        //�����t�p���Ͳ�,�����x�Τ������
            begin
              if not VarIsNull(P^.sdate1) then
                isIgnore := True;
              if not isIgnore then
              begin
                Next;
                if Eof then
                  FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P^.sqty) + ',�p���ʥͲ����ण��');
                Continue;
              end;
            end;

            if isBS then
              tmpSpeed := FParam.GetSpeed(tmpMachine, SMRecPP)
            else
              tmpSpeed := FParam.GetSpeedCore(tmpMachine, SMRecPPCore);
            if tmpSpeed <= 0 then
            begin
              FErrList.Add(tmpErrMsg + '�䤣����t�]�w�γ]�w���~');
              Break;
            end;

            P^.sdate := FieldByName('wdate').Value;
            if (P^.custno = 'N024') and (P^.custno2 <> '') then
              P^.fiber := FParam.GetFiberVendor(tmpMachine, VarToStr(P^.custno2), VarToStr(P^.materialno))
            else
              P^.fiber := FParam.GetFiberVendor(tmpMachine, VarToStr(P^.custno), VarToStr(P^.materialno)); //���ب�����
            if Length(P^.materialno) = 18 then
              tmpFiber := Copy(P^.materialno, 4, 4)
            else                                                                                       //���إN�X(4�X)
              tmpFiber := GetFiber(Copy(P^.materialno, 4, 2));

            //�ˬd������w
            if FParam.CheckFiberLock(tmpMachine, tmpFiber, P^.fiber, P^.breadth, isFiLock, tmpSdate) then
            begin
              if isFiLock then
                tmpLockErrMsg := '������w,���i�Ƶ{!'
              else if VarIsNull(P^.sdate1) then
                tmpLockErrMsg := '���إͲ���������w(��' + DateToStr(tmpSdate) + ')'
              else if P^.sdate1 < tmpSdate then
                tmpLockErrMsg := '���ث��w�Ͳ�����p��]�w���(��' + DateToStr(tmpSdate) + ')'
              else
                tmpLockErrMsg := '';

              if Length(tmpLockErrMsg) > 0 then
              begin
                ShowMsg('��' + IntToStr(SourceDS.RecNo) + '���G' + tmpLockErrMsg, 48);
                Exit;
              end;
            end;
            //�ˬd������w

            New(P1);
            P1^ := P^;
            tmpSqty := P^.sqty;
            tmpCapacity := Round(P^.sqty / tmpSpeed + 0.5);                //�ݭn�Ͳ��ɶ�
            if tmpCapacity <= FieldByName('capacity').AsInteger then   //���ਬ
            begin
              P^.sqty := 0;
              tmpCapacity := Trunc(FieldByName('capacity').AsInteger - tmpCapacity);
            end
            else                                   //����
            begin
              P1^.sqty := Trunc(FieldByName('capacity').AsInteger * tmpSpeed);
              if isBS then //�H���������
              begin
                tmpNum := Trunc(P1^.sqty / StrToInt(SMRecPP.M11_13));
                if tmpNum > 1 then
                  P1^.sqty := tmpNum * StrToInt(SMRecPP.M11_13)
                else
                begin
                  P^.sqty := tmpSqty;
                  Dispose(P1);
                  Next;
                  if Eof then
                    FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P^.sqty) + ',���ण��A');
                  Continue;
                end;
              end;
              P^.sqty := Trunc(P^.sqty - P1^.sqty);
              tmpCapacity := 0;
            end;

            //�����w,�ˬdF/6�@�Ѥ��O�_�W2�ӳW��
            if VarIsNull(P^.sdate1) and FParam.CheckFiberOverCnt(tmpMachine, Copy(P^.materialno, 2, 1), tmpFiber, P^.sdate)
              then
            begin
              P^.sqty := tmpSqty;
              Dispose(P1);
              Next;
              if Eof then
                FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P^.sqty + P1^.sqty) + ',���ण��B');
              Continue;
            end;

            if isIgnore then
              FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P1^.sqty) + '�P�p���ʥͲ�����,������');

            for j := Low(FArrMachineLine) to High(FArrMachineLine) do
              if SameText(FArrMachineLine[j].Machine, tmpMachine) then
                FArrMachineLine[j].OrderObj.Add(P1);

            Edit;
            FieldByName('flag').AsInteger := 2;
            FieldByName('capacity').AsInteger := tmpCapacity;
            Post;
            if P^.sqty <= 0 then
              Break
            else if tmpCapacity = 0 then  //tmpCapacity>0 Filter�w�L�o,�۰�Next
            begin
              if IsEmpty then
                FErrList.Add(tmpErrMsg + '�ƶq:' + FloatToStr(P^.sqty) + ',���ण��C');
              Continue;
            end;

            Next;
          end; //end while
        end;   //end  with

        SourceDS.Next;
      end;
    end;

    GetPData(DestDS);
    Result := True;
  finally
    Dispose(P);
    g_ProgressBar.Visible := False;
    SourceDS.EnableControls;
  end;
end;

//���x�t��
function TMPST070_Mps.GetSpeed(Machine, Pno: string): Double;
var
  SMRecPP: TSplitMaterialnoPP;
  SMRecPPCore: TSplitMaterialnoPPCore;
begin
  if Pos(UpperCase(Copy(Pno, 1, 1)), 'PQ') = 0 then
  begin
    FParam.SetBSRec(SMRecPP, Pno);
    Result := FParam.GetSpeed(Machine, SMRecPP);
  end
  else
  begin
    FParam.SetCoreRec(SMRecPPCore, Pno);
    Result := FParam.GetSpeedCore(Machine, SMRecPPCore);
  end;
end;

//����2�X�ഫ��4�X
function TMPST070_Mps.GetFiber(Fiber: string): string;
begin
  Result := FParam.GetFiber(Fiber);
end;

//���ؤj�p
function TMPST070_Mps.GetFiSno(Fiber: string): Integer;
begin
  Result := FParam.GetFiSno(Fiber);
end;

end.

