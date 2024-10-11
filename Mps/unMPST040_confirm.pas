{*******************************************************}
{                                                       }
{                unMPST040_confirm                      }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: 出貨表確認                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_confirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DBClient,
  DateUtils;

type
  TFrmMPST040_confirm = class(TFrmSTDI050)
    lblindate: TLabel;
    Dtp1: TDateTimePicker;
    Label2: TLabel;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure Dtp1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    function CheckCocOpt:Boolean;
    function CheckDup:Boolean;
    function CheckTipTop:Boolean;
    procedure UpdateConfirm(xConfirm: Boolean);
    procedure SetLbl(xFlag: Boolean);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_confirm: TFrmMPST040_confirm;

implementation

uses unGlobal, unCommon, unMPST040, unMPST040_units;

{$R *.dfm}

const l_ConfirmOK='確認';
const l_ConfirmCancel='取消確認';
const l_Confirm='已確認';
const l_unConfirm='未確認';

procedure TFrmMPST040_confirm.SetLbl(xFlag:Boolean);
begin
  if xFlag then
  begin
    btn_ok.Caption:=CheckLang(l_ConfirmCancel);
    Label2.Caption:=CheckLang(l_Confirm);
  end else
  begin
    btn_ok.Caption:=CheckLang(l_ConfirmOK);
    Label2.Caption:=CheckLang(l_unConfirm);
  end;
end;

function TFrmMPST040_confirm.CheckCocOpt:Boolean;
var
  IsExists:Boolean;
  tmpSQL:string;
begin
  Result:=False;
  tmpSQL:='Select Top 1 1 From Dli010 A Inner Join Dli020 B'
         +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
         +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
         +' And A.Indate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And IsNull(A.GarbageFlag,0)=0'
         +' Union'
         +' Select Top 1 1 From Dli010 A Inner Join Dli040 B'
         +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
         +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
         +' And A.Indate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And IsNull(A.GarbageFlag,0)=0';
  if QueryExists(tmpSQL, IsExists) then
  if IsExists then
  begin
    ShowMsg('此出貨日期已備貨或者已做COC,不可取消!', 48);
    Result:=True;
  end;
end;

function TFrmMPST040_confirm.CheckDup:Boolean;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpSQL:='exec dbo.proc_MPST040 '+Quotedstr(g_UInfo^.BU)+','+
                                   Quotedstr(DateToStr(Dtp1.Date));
  Result:=QueryBySQL(tmpSQL, Data);
  if Result then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
        if not IsEmpty then
        begin
          Memo1.Lines.Add(CheckLang('下列訂單[達交日期+客戶+訂單]重複'));
          Memo1.Lines.Add(CheckLang('系統已自動合並成一筆,請核對結果後再確認'));
          while not Eof do
          begin
            Memo1.Lines.Add(Fields[0].AsString+'/'+Fields[1].AsString);
            Next;
          end;
        end;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

function TFrmMPST040_confirm.CheckTipTop:Boolean;
var
  i,cnt:Integer;
  tmpDate:TDateTime;
  tmpSQL,tmpSQL2:string;
  Data:OleVariant;
  tmpCDS,tmpCDSORA:TClientDataSet;
  tmpList1,tmpList2,tmpList3:TStrings;
begin
  Result:=False;
  tmpSQL:='Select * From DLI010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And Len(IsNull(Dno_Ditem,''''))=0'
         +' And IsNull(GarbageFlag,0)=0'
         +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData);
  if SameText(g_UInfo^.BU, 'ITEQGZ') then
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Custno,Units,right(Pno,1),Pno,Orderno,Orderitem,Dno,Ditem'
  else
     tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Stime,Custno,Units,Pno,Orderno,Orderitem,Dno,Ditem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    g_ProgressBar.Position:=0;
    g_ProgressBar.Visible:=True;
    tmpCDS:=TClientDataSet.Create(nil);
    tmpCDSORA:=TClientDataSet.Create(nil);
    tmpList1:=TStringList.Create;
    tmpList2:=TStringList.Create;
    tmpList3:=TStringList.Create;
    try
      tmpCDS.Data:=Data;
      g_ProgressBar.Max:=tmpCDS.RecordCount;

      cnt:=0;
      tmpSQL:='';
      tmpSQL2:='';
      with tmpCDS do
      while not Eof do
      begin
        Inc(cnt);
        if cnt>999 then
           tmpSQL2:=tmpSQL2+','+Quotedstr(FieldByName('orderno').AsString)
        else
           tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('orderno').AsString);
        Next;
      end;

      if Length(tmpSQL)>0 then
      begin
        Delete(tmpSQL, 1, 1);
        Data:=null;
        tmpSQL:=GetOraSQL(g_UInfo^.BU, ' and oea01 in ('+tmpSQL+')');
        if QueryBySQL(tmpSQL, Data, 'ORACLE') then
        begin
          tmpCDSORA.Data:=Data;
          
          if Length(tmpSQL2)>0 then
          begin
            Delete(tmpSQL2, 1, 1);
            Data:=null;
            tmpSQL:=GetOraSQL(g_UInfo^.BU,' and oea01 in ('+tmpSQL2+')');
            if not QueryBySQL(tmpSQL, Data, 'ORACLE') then
               Exit;
            tmpCDSORA.AppendData(Data,True);
          end;

          tmpDate:=EncodeDate(2000,5,5);
          tmpCDS.First;
          with tmpCDS do
          while not Eof do
          begin
            g_ProgressBar.Position:=g_ProgressBar.Position+1;

            if tmpCDSORA.Locate('oea01;oeb03',VarArrayOf(
                  [FieldByName('Orderno').AsString,
                   FieldByName('Orderitem').AsInteger]),[]) then
            begin
              tmpSQL:=FieldByName('Orderno').AsString+'/'+
                      IntToStr(FieldByName('Orderitem').AsInteger)+'/'+
                      FieldByName('Custno').AsString;

              if tmpCDSORA.FieldByName('oeaconf').AsString<>'Y' then
                 Memo1.Lines.Add(tmpSQL+' 未確認或已作廢')
              else if tmpCDSORA.FieldByName('oeb70').AsString='Y' then
                 Memo1.Lines.Add(tmpSQL+' 已結案')
              else if FieldByName('pno').AsString<>tmpCDSORA.FieldByName('oeb04').AsString then
                 Memo1.Lines.Add(tmpSQL+' 料號不相同')
              else if tmpCDSORA.FieldByName('oeb12').AsFloat<=0 then
                 Memo1.Lines.Add(tmpSQL+' 訂單量為0');

              i:=tmpList1.IndexOf(tmpSQL);
              if i=-1 then
              begin
                tmpList1.Add(tmpSQL);
                tmpList2.Add(FloatToStr(FieldByName('Notcount1').AsFloat));
                tmpList3.Add(FloatToStr(tmpCDSORA.FieldByName('notqty').AsFloat));
              end else
                tmpList2.Strings[i]:=FloatToStr(StrToFloatDef(tmpList2.Strings[i],0)+FieldByName('Notcount1').AsFloat);

              Edit;

              try
                if FieldByName('Odate').AsDateTime<>DateOf(tmpCDSORA.FieldByName('oea02').AsDateTime) then
                begin
                  FieldByName('Odate').AsDateTime:=DateOf(tmpCDSORA.FieldByName('oea02').AsDateTime);
                  if FieldByName('Odate').AsDateTime<tmpDate then
                     FieldByName('Odate').Clear;
                end;
              except
                FieldByName('Odate').Clear;
              end;

              try
                if FieldByName('Ddate').AsDateTime<>DateOf(tmpCDSORA.FieldByName('oeb15').AsDateTime) then
                begin
                   FieldByName('Ddate').AsDateTime:=DateOf(tmpCDSORA.FieldByName('oeb15').AsDateTime);
                   if FieldByName('Ddate').AsDateTime<tmpDate then
                      FieldByName('Ddate').Clear;
                end;
              except
                FieldByName('Ddate').Clear;
              end;

              if FieldByName('Custno').AsString<>tmpCDSORA.FieldByName('oea04').AsString then
                 FieldByName('Custno').AsString:=tmpCDSORA.FieldByName('oea04').AsString;

              if FieldByName('Custshort').AsString<>tmpCDSORA.FieldByName('occ02').AsString then
              if not SameText(FieldByName('Custno').AsString,'N005') then  //不更新N005簡稱
                 FieldByName('Custshort').AsString:=tmpCDSORA.FieldByName('occ02').AsString;

              if FieldByName('Pno').AsString<>tmpCDSORA.FieldByName('oeb04').AsString then
                 FieldByName('Pno').AsString:=tmpCDSORA.FieldByName('oeb04').AsString;

              if FieldByName('Pname').AsString<>tmpCDSORA.FieldByName('oeb06').AsString then
                 FieldByName('Pname').AsString:=tmpCDSORA.FieldByName('oeb06').AsString;

              if FieldByName('Sizes').AsString<>tmpCDSORA.FieldByName('ima021').AsString then
                 FieldByName('Sizes').AsString:=tmpCDSORA.FieldByName('ima021').AsString;

              //if FieldByName('Longitude').AsString<>tmpCDSORA.FieldByName('ta_oeb01').AsString then
              //   FieldByName('Longitude').AsString:=tmpCDSORA.FieldByName('ta_oeb01').AsString;

              //if FieldByName('Latitude').AsString<>tmpCDSORA.FieldByName('ta_oeb02').AsString then
              //   FieldByName('Latitude').AsString:=tmpCDSORA.FieldByName('ta_oeb02').AsString;

              if FieldByName('Ordercount').AsFloat<>tmpCDSORA.FieldByName('oeb12').AsFloat then
                 FieldByName('Ordercount').AsFloat:=tmpCDSORA.FieldByName('oeb12').AsFloat;

              if FieldByName('Units').AsString<>tmpCDSORA.FieldByName('oeb05').AsString then
                 FieldByName('Units').AsString:=tmpCDSORA.FieldByName('oeb05').AsString;

              if FieldByName('Custorderno').AsString<>tmpCDSORA.FieldByName('oea10').AsString then
                 FieldByName('Custorderno').AsString:=tmpCDSORA.FieldByName('oea10').AsString;

              if FieldByName('Custprono').AsString<>tmpCDSORA.FieldByName('oeb11').AsString then
                 FieldByName('Custprono').AsString:=tmpCDSORA.FieldByName('oeb11').AsString;

              if FieldByName('Custname').AsString<>tmpCDSORA.FieldByName('ta_oeb10').AsString then
                 FieldByName('Custname').AsString:=tmpCDSORA.FieldByName('ta_oeb10').AsString;

              if FieldByName('Remark').AsString<>tmpCDSORA.FieldByName('oao06').AsString then
                 FieldByName('Remark').AsString:=tmpCDSORA.FieldByName('oao06').AsString;

              if FieldByName('SendAddr').AsString<>tmpCDSORA.FieldByName('ocd221').AsString then
                 FieldByName('SendAddr').AsString:=tmpCDSORA.FieldByName('ocd221').AsString;

              if FieldByName('kg').AsString<>tmpCDSORA.FieldByName('ima18').AsString then
                 FieldByName('kg').AsString:=tmpCDSORA.FieldByName('ima18').AsString;

              tmpSQL:='';
              case StrToIntDef(tmpCDSORA.FieldByName('ta_oeb22').AsString, -1) of
                0:tmpSQL:=CheckLang('不管控');
                1:tmpSQL:=CheckLang('可短交');
                2:tmpSQL:=CheckLang('可超交');
                3:tmpSQL:=CheckLang('不可短交不可超交');
              end;
              if FieldByName('CtrlRemark').AsString<>tmpSQL then
                 FieldByName('CtrlRemark').AsString:=tmpSQL;

              Post;
            end else
              Memo1.Lines.Add(FieldByName('Orderno').AsString+'/'+
                              FieldByName('Orderitem').AsString+'/'+
                              FieldByName('Custno').AsString+' 訂單不存在');
            Next;
          end;

          for i:=0 to tmpList2.Count -1 do
          if StrToFloatDef(tmpList2.Strings[i], 0)>StrToFloatDef(tmpList3.Strings[i], 0) then
             Memo1.Lines.Add(tmpList1.Strings[i]+' 出貨數量大於未出數量');

          if Memo1.Text<>'' then
          begin
            PCL.ActivePageIndex:=1;
            Exit;
          end;

          //排程項次、應出數量
          i:=1;
          with tmpCDS do
          begin
            First;
            while not Eof do
            begin
              Edit;
              FieldByName('Sno').AsInteger:=i;
              FieldByName('Notcount').AsFloat:=FieldByName('Notcount1').AsFloat;
              Post;
              Next;
              Inc(i);
            end;
          end;

          if CDSPost(tmpCDS, 'DLI010') then
             Result:=True;
        end;
      end;
    finally
      FreeAndNil(tmpCDS);
      FreeAndNil(tmpCDSORA);
      FreeAndNil(tmpList1);
      FreeAndNil(tmpList2);
      FreeAndNil(tmpList3);
      g_ProgressBar.Visible:=False;
    end;
  end;
end;

procedure TFrmMPST040_confirm.UpdateConfirm(xConfirm: Boolean);
var
  tmpSQL:string;
begin
  tmpSQL:=' where bu='+Quotedstr(g_UInfo^.BU)
         +' and indate='+Quotedstr(DateToStr(Dtp1.Date));

  if xConfirm then
     tmpSQL:='if not exists(select 1 from mps320 '+tmpSQL+')'
            +' insert into mps320(bu,indate) values('+Quotedstr(g_UInfo^.BU)
            +','+Quotedstr(DateToStr(Dtp1.Date))+')'
  else
     tmpSQL:=' delete from mps320 '+tmpSQL
            +' update DLI010 set InsFlag=0'+tmpSQL+' and InsFlag=1';
  if PostBySQL(tmpSQL) then
  begin
    tmpSQL:=btn_ok.Caption;
    if FrmMPST040.CDS.Active and (not FrmMPST040.CDS.IsEmpty) and
      (FrmMPST040.CDS.FieldByName('Indate').AsDateTime=Dtp1.Date) then
       FrmMPST040.Image1.Visible:=xConfirm;
    SetLbl(xConfirm);
    ShowMsg(tmpSQL+'完畢!', 64);
  end;
end;

procedure TFrmMPST040_confirm.FormCreate(Sender: TObject);
begin
  inherited;
  Label2.Caption:='';
end;

procedure TFrmMPST040_confirm.FormShow(Sender: TObject);
begin
  inherited;
  PCL.ActivePageIndex:=0;
  Memo1.Lines.Clear;
  Dtp1Change(Dtp1);
end;

procedure TFrmMPST040_confirm.btn_okClick(Sender: TObject);
var
  tmpBool:Boolean;
begin
//  inherited;
  if ShowMsg(btn_ok.Caption+'嗎?', 33)=IdCancel then
     Exit;

  Memo1.Lines.Clear;
  btn_ok.Enabled:=False;
  try
    if btn_ok.Caption=CheckLang(l_ConfirmCancel) then
    begin
      if not CheckCocOpt then    //取消確認檢查備貨、COC
         UpdateConfirm(False)
    end else
    begin
      tmpBool:=CheckDup;        //檢查重複+合並
      if not tmpBool then
         Exit
      else if Trim(Memo1.Text)<>'' then
      begin
        PCL.ActivePageIndex:=1;
        Exit;
      end;

      if CheckTipTop then       //確認檢查tiptop欄位
         UpdateConfirm(True);
    end;
  finally
    btn_ok.Enabled:=True;
  end;
end;

procedure TFrmMPST040_confirm.Dtp1Change(Sender: TObject);
var
  tmpBool:Boolean;
begin
  tmpBool:=CheckConfirm(Dtp1.Date);
  SetLbl(tmpBool);
end;

end.
