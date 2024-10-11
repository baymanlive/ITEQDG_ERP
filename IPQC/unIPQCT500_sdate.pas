unit unIPQCT500_sdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient,
  DateUtils;

type
  TFrmIPQCT500_sdate = class(TFrmSTDI051)
    MC: TMonthCalendar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT500_sdate: TFrmIPQCT500_sdate;

implementation

uses unGlobal,unCommon,unIPQCT500;

{$R *.dfm}

procedure TFrmIPQCT500_sdate.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('生產日期');
  MC.Date:=Date;
end;

procedure TFrmIPQCT500_sdate.btn_okClick(Sender: TObject);
var
  tmpStr:string;
  IsFind:Boolean;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  //檢查當天備料是否存在
  tmpStr:='Select Top 1 1 From IPQC500 Where Bu='+Quotedstr(g_Uinfo^.BU)
         +' And Sdate='+Quotedstr(DateToStr(MC.Date));
  if not QueryExists(tmpStr, IsFind) then
     Exit;
  if IsFind then
  begin
    //檢查是否已掃描
    tmpStr:='Select Top 1 1 From IPQC500 A Inner Join IPQC501 B'
           +' On A.Bu=B.Bu And A.Dno=B.Dno And A.Ditem=B.Ditem'
           +' Where A.Bu='+Quotedstr(g_Uinfo^.BU)
           +' And A.Sdate='+Quotedstr(DateToStr(MC.Date));
    if not QueryExists(tmpStr, IsFind) then
       Exit;

    if IsFind then
    begin
      ShowMsg('此生產日期備料已開始掃描,不可再執行此操作!', 48);
      Exit;
    end else
    begin
      if ShowMsg('此生產日期備料已存在,確定覆蓋嗎?', 33)=IdCancel then
         Exit;
    end;
  end else if ShowMsg('確定進行備料計算嗎?', 33)=IdCancel then
    Exit;

  tmpStr:='Select B.Fiber,A.Breadth,A.Fiber Vendor,B.Code Pno,Sum(A.Sqty) Qty'
         +' From MPS070 A Left Join (Select * From MPS620 Where Bu='+Quotedstr(g_UInfo^.BU)+') B'
         +' ON (Case When A.Fi=''2313a'' Then ''3313'' Else A.FI End)=B.Fiber'
         +'   And CHARINDEX(A.Breadth, B.Breadth)>0 And A.Fiber=B.Vendor'
         +' Where A.Bu=''ITEQDG'' And A.Sdate='+Quotedstr(DateToStr(MC.Date))
         +' And IsNull(A.EmptyFlag,0)=0 And IsNull(A.ErrorFlag,0)=0';
  if SameText(g_UInfo^.BU, 'ITEQDG') then
     tmpStr:=tmpStr+' And A.Machine in (''T1'',''T2'',''T3'',''T4'',''T5'')'
  else
     tmpStr:=tmpStr+' And A.Machine in (''T6'',''T7'',''T8'')';
  tmpStr:=tmpStr+' Group By B.Fiber,A.Breadth,A.Fiber,B.Code';
  if not QueryBySQL(tmpStr, Data) then
     Exit;

  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('此生產日期PP排程無資料,或玻布檔無設定!', 48);
      Exit;
    end;

    tmpStr:=GetSno(g_MInfo^.ProcId);
    if tmpStr='' then
       Exit;

    tmpCDS2.Data:=FrmIPQCT500.CDS.Data;
    tmpCDS2.EmptyDataSet;
    while not tmpCDS1.Eof do
    begin
      tmpCDS2.Append;
      tmpCDS2.FieldByName('Bu').AsString:=g_UInfo^.BU;
      tmpCDS2.FieldByName('Dno').AsString:=tmpStr;
      tmpCDS2.FieldByName('Ditem').AsInteger:=tmpCDS1.RecNo;
      tmpCDS2.FieldByName('Sdate').AsDateTime:=EncodeDate(YearOf(MC.Date),MonthOf(MC.Date),DayOf(MC.Date));
      tmpCDS2.FieldByName('Fiber').AsString:=tmpCDS1.FieldByName('Fiber').AsString;
      tmpCDS2.FieldByName('Breadth').AsString:=tmpCDS1.FieldByName('Breadth').AsString;
      tmpCDS2.FieldByName('Vendor').AsString:=tmpCDS1.FieldByName('Vendor').AsString;
      tmpCDS2.FieldByName('Pno').AsString:=tmpCDS1.FieldByName('Pno').AsString;
      tmpCDS2.FieldByName('Qty').AsFloat:=tmpCDS1.FieldByName('Qty').AsFloat;
      tmpCDS2.FieldByName('Conf').AsBoolean:=False;
      tmpCDS2.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
      tmpCDS2.FieldByName('Idate').AsDateTime:=Now;
      tmpCDS2.Post;
      tmpCDS1.Next;
    end;
    if not CDSPost(tmpCDS2, 'IPQC500') then
       Exit;

    tmpStr:='Delete From IPQC500 Where Bu='+Quotedstr(g_Uinfo^.BU)
           +' And Sdate='+Quotedstr(DateToStr(tmpCDS2.FieldByName('Sdate').AsDateTime))
           +' And Dno<>'+Quotedstr(tmpStr);
    if not PostBySQL(tmpStr) then
       ShowMsg('刪除舊資料失敗!', 48);
    FrmIPQCT500.CDS.Data:=tmpCDS2.Data;
  finally
    FreeAndNil(tmpCDS1);
  end;

  inherited;
end;

end.
