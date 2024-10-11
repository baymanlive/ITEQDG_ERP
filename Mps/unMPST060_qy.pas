unit unMPST060_qy;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmMPST060_qy = class(TFrmSTDI051)
    lblsdate: TLabel;
    Dtp: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l_isDG:Boolean;
  end;

var
  FrmMPST060_qy: TFrmMPST060_qy;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST060_qy.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp.Date:=Date+1;
end;

//1. 銅箔>=3不取
//2. 一鍋中只有一個料號,取數量多的那筆1張
//3. 一鍋中有特殊膠系NEUOHQ,取數量多的那筆1張,其它膠系不取
//無特殊膠系+至少有2個料號不相同,不處理
procedure TFrmMPST060_qy.btn_okClick(Sender: TObject);
const m2='NEUOHQ';
const m7_8='3456789';
var
  tmpBool:Boolean;
  tmpIndex:Integer;
  tmpMCB,tmpSQL,tmpPno,tmpM2:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
  tmpList1,tmpList2,tmpRetList:TStrings;
begin
//  inherited;
  if Dtp.Date<=Date then
  begin
    ShowMsg('請選擇日期大於當天!',48);
    Dtp.SetFocus;
    Exit;
  end;

  if ShowMsg('確定進行取樣計算嗎?',33)=IdCancel then
     Exit;

  if l_isDG then
     tmpSQL:=' and machine<>''L6'''
  else
     tmpSQL:=' and machine=''L6''';
  tmpSQL:=' delete from mps060 where bu='+Quotedstr(g_UInfo^.BU)
         +' and wono in (select wono from mps010 where mps010.bu=mps060.bu'
         +' and sdate='+Quotedstr(DateToStr(Dtp.Date))+tmpSQL+')'
         +' select wono,materialno,sqty,'
         +' machine+''@''+cast(currentboiler as varchar(4)) as mcb'
         +' from mps010 where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate='+Quotedstr(DateToStr(Dtp.Date))+tmpSQL
         +' and len(isnull(wono,''''))>0'
         +' and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0'
         +' order by machine,jitem,oz,simuver,citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpBool:=False;
    tmpMCB:='@';
    tmpList1:=TStringList.Create;     //特殊膠系
    tmpList2:=TStringList.Create;     //同料號
    tmpRetList:=TStringList.Create;   //結果:需取樣工單號碼
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        tmpPno:=tmpCDS.FieldByName('materialno').AsString;
        if (Pos(Copy(tmpPno,7,1), m7_8)=0) and (Pos(Copy(tmpPno,8,1), m7_8)=0) then
        begin
          tmpM2:=Copy(tmpPno,2,1);
          if Pos(tmpM2, m2)>0 then
          begin
            tmpIndex:=tmpList1.IndexOf(tmpM2);
            if tmpIndex=-1 then
            begin
              tmpList1.Add(tmpCDS.FieldByName('wono').AsString);
              tmpList1.Add(tmpM2);
              tmpList1.Add(FloatToStr(tmpCDS.FieldByName('sqty').AsFloat));
            end else
            begin
              if StrToFloat(tmpList1.Strings[tmpIndex+1])<tmpCDS.FieldByName('sqty').AsFloat then
              begin
                tmpList1.Strings[tmpIndex-1]:=tmpCDS.FieldByName('wono').AsString;
                tmpList1.Strings[tmpIndex+1]:=FloatToStr(tmpCDS.FieldByName('sqty').AsFloat);
              end;
            end;
          end
          else if tmpList1.Count=0 then
          begin
            tmpIndex:=tmpList2.IndexOf(tmpPno);
            if tmpIndex=-1 then
            begin
              tmpList2.Add(tmpCDS.FieldByName('wono').AsString);
              tmpList2.Add(tmpPno);
              tmpList2.Add(FloatToStr(tmpCDS.FieldByName('sqty').AsFloat));
            end else
            begin
              if StrToFloat(tmpList2.Strings[tmpIndex+1])<tmpCDS.FieldByName('sqty').AsFloat then
              begin
                tmpList2.Strings[tmpIndex-1]:=tmpCDS.FieldByName('wono').AsString;
                tmpList2.Strings[tmpIndex+1]:=FloatToStr(tmpCDS.FieldByName('sqty').AsFloat);
              end;
            end;
          end;
        end else
          tmpBool:=True;

        tmpMCB:=tmpCDS.FieldByName('mcb').AsString;
        tmpCDS.Next;
        if tmpCDS.Eof or (tmpMCB<>tmpCDS.FieldByName('mcb').AsString) then
        begin
          if tmpList1.Count>0 then
          begin
            tmpIndex:=0;
            while tmpIndex<=tmpList1.Count-1 do
            begin
              tmpRetList.Add(tmpList1.Strings[tmpIndex]);
              Inc(tmpIndex, 3);
            end;
          end else if (not tmpBool) and (tmpList2.Count=3) then
            tmpRetList.Add(tmpList2.Strings[0]);
          tmpList1.Clear;
          tmpList2.Clear;
        end;
      end;

      for tmpIndex:=0 to tmpRetList.Count-1 do
      begin
        tmpSQL:='Insert Into MPS060(Bu,Wono,Qty,PDAConf,QCIns,Iuser,Idate)'
               +' Values ('+Quotedstr(g_UInfo^.BU)+','+
                            Quotedstr(tmpRetList.Strings[tmpIndex])+',1,''N'',''Y'','+
                            Quotedstr(g_UInfo^.UserId)+','+
                            Quotedstr(FormatDateTime(g_cLongTimeSP,Now))+')';
        if not PostBySQL(tmpSQL) then
           Exit;
      end;

      ShowMsg('計算完畢!',64);
    finally
      tmpList1.Free;
      tmpList2.Free;
      tmpRetList.Free;
      tmpCDS.Free;
    end;
  end;
end;

end.
