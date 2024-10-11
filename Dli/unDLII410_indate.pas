unit unDLII410_indate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, Menus, ImgList, Buttons,
  ExtCtrls, ToolWin, DBClient, StrUtils, Math;

type
  TFrmDLII410_indate = class(TFrmSTDI051)
    MC: TMonthCalendar;
    lblindate: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    function GetKBCnt(Pno:string; Qty:Double):Integer;
    { Private declarations }
  public
    RetData:OleVariant;
    { Public declarations }
  end;

var
  FrmDLII410_indate: TFrmDLII410_indate;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

//計算棧板數
function TFrmDLII410_indate.GetKBCnt(Pno:string; Qty:Double):Integer;
var
  str:string;
begin
  if Pos(UpperCase(LeftStr(Pno,1)),'ET')>0 then
  begin
    if Length(Pno)=17 then
    begin
      str:=Copy(Pno,3,4);
      if str<='0120' then
         Result:=Ceil((Ceil(Qty/30))/20)    //30張一包，20包一個棧板，下同
      else if str<='0240' then
         Result:=Ceil((Ceil(Qty/20))/25)
      else if str<='0360' then
         Result:=Ceil((Ceil(Qty/15))/25)
      else if str<='0590' then
         Result:=Ceil((Ceil(Qty/10))/25)
      else
         Result:=Ceil((Ceil(Qty/5))/30);
    end else
      Result:=1;
  end else
  begin
    if Length(Pno)=18 then
       Result:=Ceil(Qty/12)
    else
       Result:=1;
  end;
end;

procedure TFrmDLII410_indate.FormCreate(Sender: TObject);
begin
  inherited;
  MC.Date:=Date;
end;

procedure TFrmDLII410_indate.btn_okClick(Sender: TObject);
var
  KBCnt:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
begin
  tmpSQL:='Select Top 1 Bu From MPS320 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Indate='+Quotedstr(DateToStr(MC.Date));
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS2:=TClientDataSet.Create(nil);
  tmpCDS3:=TClientDataSet.Create(nil);
  try
    tmpCDS1.Data:=Data;
    if tmpCDS1.IsEmpty then
    begin
      ShowMsg('此日期出貨表不存在或生管未確認!',48);
      Exit;
    end;

    Data:=null;
    tmpSQL:='Select * From DLI410 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Indate='+Quotedstr(DateToStr(MC.Date));
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS1.Data:=Data;
    if not tmpCDS1.IsEmpty then
    begin
      if ShowMsg('此日期已存在出車計劃表資料,重新產生將會被覆蓋,確定嗎?',33)=IdCancel then
         Exit;
    end else
    if ShowMsg('確定產生此日期的出車計劃表嗎?',33)=IdCancel then
       Exit;
    while not tmpCDS1.IsEmpty do
      tmpCDS1.Delete;

    Data:=null;
    tmpSQL:='Select Indate,Right(''00''+Cast(Datepart(hh,Stime) as varchar(2)),2)+'':''+Left(Cast(Datepart(mi,Stime) as varchar(2))+''00'',2) StimeX,'
           +' Custno,Custshort,Pno,Notcount1 From DLI010'
           +' Where Indate='+Quotedstr(DateToStr(MC.Date))
           +' And Bu='+Quotedstr(g_UInfo^.BU)
           +' And Len(IsNull(Dno_ditem,''''))=0 And IsNull(GarbageFlag,0)=0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData)
           +' Order By StimeX,Custno';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS2.Data:=Data;

    Data:=null;
    tmpSQL:='Select Custno,Pathname From DLI400 Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS3.Data:=Data;

    while not tmpCDS2.Eof do
    begin
      KBCnt:=GetKBCnt(tmpCDS2.FieldByName('Pno').AsString,tmpCDS2.FieldByName('Notcount1').AsFloat);
      if tmpCDS3.Locate('Custno',tmpCDS2.FieldByName('Custno').AsString,[]) then
         tmpSQL:=tmpCDS3.FieldByName('Pathname').AsString
      else
         tmpSQL:=CheckLang('未設定路線');

      if not tmpCDS1.Locate('Stime;Pathname',
               VarArrayOf([tmpCDS2.FieldByName('StimeX').AsString,tmpSQL]),[]) then
      begin
        tmpCDS1.Append;
        tmpCDS1.FieldByName('Bu').AsString:=g_UInfo^.BU;
        tmpCDS1.FieldByName('Id').AsInteger:=tmpCDS1.RecordCount+1;
        tmpCDS1.FieldByName('Indate').AsDateTime:=tmpCDS2.FieldByName('Indate').AsDateTime;
        tmpCDS1.FieldByName('Stime').AsString:=tmpCDS2.FieldByName('StimeX').AsString;
        tmpCDS1.FieldByName('Custno').AsString:=tmpCDS2.FieldByName('Custno').AsString;
        tmpCDS1.FieldByName('Custshort').AsString:=tmpCDS2.FieldByName('Custshort').AsString;
        tmpCDS1.FieldByName('Pathname').AsString:=tmpSQL;
        tmpCDS1.FieldByName('Cnt').AsInteger:=1;
        tmpCDS1.FieldByName('KBCnt').AsInteger:=KBCnt;
        tmpCDS1.FieldByName('Iuser').AsString:=g_UInfo^.UserId;
        tmpCDS1.FieldByName('Idate').AsDateTime:=Now;
        tmpCDS1.Post;
      end else
      begin
        tmpCDS1.Edit;
        if Pos(tmpCDS2.FieldByName('Custno').AsString,tmpCDS1.FieldByName('Custno').AsString)=0 then
        begin
          tmpCDS1.FieldByName('Custno').AsString:=tmpCDS1.FieldByName('Custno').AsString+','+tmpCDS2.FieldByName('Custno').AsString;
          tmpCDS1.FieldByName('Custshort').AsString:=tmpCDS1.FieldByName('Custshort').AsString+','+tmpCDS2.FieldByName('Custshort').AsString;
        end;
        tmpCDS1.FieldByName('KBCnt').AsInteger:=tmpCDS1.FieldByName('KBCnt').AsInteger+KBCnt;
        tmpCDS1.FieldByName('Cnt').AsInteger:=tmpCDS1.FieldByName('Cnt').AsInteger+1;
        tmpCDS1.Post;
      end;

      tmpCDS2.Next;
    end;
    if not CDSPost(tmpCDS1, 'DLI410') then
       Exit;
    RetData:=tmpCDS1.Data;
  finally
    tmpCDS1.Free;
    tmpCDS2.Free;
    tmpCDS3.Free;
  end;

  inherited;
end;

end.
