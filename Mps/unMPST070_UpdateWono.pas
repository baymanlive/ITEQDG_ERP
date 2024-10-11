unit unMPST070_UpdateWono;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, ComCtrls, DBClient;

type
  TFrmMPST070_UpdateWono = class(TFrmSTDI051)
    cbb: TComboBox;
    dtp1: TDateTimePicker;
    dtp2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST070_UpdateWono: TFrmMPST070_UpdateWono;

implementation

uses unGlobal, unCommon, ComObj;

{$R *.dfm}

procedure TFrmMPST070_UpdateWono.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('線別：');
  Label2.Caption:=CheckLang('生產日期(起)：');
  Label3.Caption:=CheckLang('生產日期(迄)：');
  Label4.Caption:=CheckLang('Excel檔案第1行需包含下列欄位：');
  Label5.Caption:=CheckLang('訂單單號、訂單項次、客戶簡稱、生產料號、排制量、工單號');
  Cbb.Items.DelimitedText:=g_MachinePP;
  Cbb.ItemIndex:=0;
  dtp1.Date:=Date;
  dtp2.Date:=Date;  
end;

procedure TFrmMPST070_UpdateWono.btn_okClick(Sender: TObject);
var
  arr:array[0..5] of Integer;
  i,sno,tmpOrderitem,tmpSqty:Integer;
  tmpStr,s1,s2,s3,s4,s5,s6:string;
  tmpCDS:TClientDataSet;
  ExcelApp:Variant;
  OpenDialog: TOpenDialog;
  Data:OleVariant;
begin
  //inherited;
  if cbb.ItemIndex=-1 then
  begin
    ShowMsg('請選擇線別',48);
    Exit;
  end;

  if dtp1.Date<Date then
  begin
    ShowMsg('生產日期(起)不能小于當天日期',48);
    Exit;
  end;
  
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('生產日期(起)不能大于生產日期(迄)',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  OpenDialog:=TOpenDialog.Create(nil);
  OpenDialog.Filter:=CheckLang('Excel檔案(*.xlsx)|*.xlsx|Excel檔案(*.xls)|*.xls');
  if not OpenDialog.Execute then
  begin
    FreeAndNil(OpenDialog);
    Exit;
  end;

  ExcelApp:=CreateOleObject('Excel.Application');
  try
    ExcelApp.WorkBooks.Open(OpenDialog.FileName);
    ExcelApp.WorkSheets[1].Activate;
    sno:=ExcelApp.Worksheets[1].UsedRange.Columns.Count;
    for i:=1 to sno do
    begin
      tmpStr:=Trim(ExcelApp.Cells[1,i].Value);
      if tmpStr=CheckLang('訂單單號') then
         arr[0]:=i
      else if tmpStr=CheckLang('訂單項次') then
         arr[1]:=i
      else if tmpStr=CheckLang('客戶簡稱') then
         arr[2]:=i
      else if tmpStr=CheckLang('生產料號') then
         arr[3]:=i
      else if tmpStr=CheckLang('排制量') then
         arr[4]:=i
      else if tmpStr=CheckLang('工單號') then
         arr[5]:=i;
    end;

    if arr[0]=0 then
    begin
      ShowMsg('Excel表未找到[訂單單號]欄位',48);
      Exit;
    end;

    if arr[1]=0 then
    begin
      ShowMsg('Excel表未找到[訂單項次]欄位',48);
      Exit;
    end;

    if arr[2]=0 then
    begin
      ShowMsg('Excel表未找到[客戶簡稱]欄位',48);
      Exit;
    end;

    if arr[3]=0 then
    begin
      ShowMsg('Excel表未找到[生產料號]欄位',48);
      Exit;
    end;

    if arr[4]=0 then
    begin
      ShowMsg('Excel表未找到[排制量]欄位',48);
      Exit;
    end;

    if arr[5]=0 then
    begin
      ShowMsg('Excel表未找到[工單號]欄位',48);
      Exit;
    end;

    tmpStr:='select bu,simuver,citem,wono,orderno,orderitem,materialno,sqty,'
           +' custno,custom,custom2 from mps070 where bu='+Quotedstr(g_UInfo^.BU)
           +' and machine='+Quotedstr(cbb.Items[cbb.ItemIndex])
           +' and sdate between '+Quotedstr(DateToStr(dtp1.Date))
           +' and '+Quotedstr(DateToStr(dtp2.Date))
           +' and len(isnull(wono,''''))=0 and len(isnull(orderno,''''))>0'
           +' and isnull(errorflag,0)=0 and isnull(emptyflag,0)=0'
           +' and isnull(case_ans2,0)=0';
    if not QueryBySQL(tmpStr,Data) then
       Exit;

    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('此線別、生產時間段無未開工單的資料',48);
      Exit;
    end;

    sno:=0;
    i:=2;
    g_ProgressBar.Position:=0;
    g_ProgressBar.Max:=ExcelApp.Worksheets[1].UsedRange.Rows.Count;
    g_ProgressBar.Visible:=True;
    while True do
    begin
      g_ProgressBar.Position:=g_ProgressBar.Position+1;
      Application.ProcessMessages;

      //全為空值,退出
      s1:=Trim(VarToStr(ExcelApp.Cells[i,arr[0]].Value));
      s2:=Trim(VarToStr(ExcelApp.Cells[i,arr[1]].Value));
      s3:=Trim(VarToStr(ExcelApp.Cells[i,arr[2]].Value));
      s4:=Trim(VarToStr(ExcelApp.Cells[i,arr[3]].Value));
      s5:=Trim(VarToStr(ExcelApp.Cells[i,arr[4]].Value));
      s6:=Trim(VarToStr(ExcelApp.Cells[i,arr[5]].Value));
      if (Length(s1)=0) and (Length(s2)=0) and (Length(s3)=0) and
         (Length(s4)=0) and (Length(s5)=0) and (Length(s6)=0) then
         Break;

      if Length(s1)<>10 then
      begin
        ShowMsg('第'+IntToStr(i-1)+'筆[訂單單號]錯誤',48);
        Exit;
      end;

      tmpOrderitem:=StrToIntDef(s2,0);
      if tmpOrderitem<=0 then
      begin
        ShowMsg('第'+IntToStr(i-1)+'筆[訂單項次]錯誤',48);
        Exit;
      end;

      tmpSqty:=StrToIntDef(s5,0);
      if tmpSqty<=0 then
      begin
        ShowMsg('第'+IntToStr(i-1)+'筆[排制量]錯誤',48);
        Exit;
      end;

      if Length(s6)<>10 then
      begin
        ShowMsg('第'+IntToStr(i-1)+'筆[工單號]錯誤',48);
        Exit;
      end;

      if (Length(s3)>0) and (Length(s4)>0) then
      begin
        tmpCDS.First;
        while not tmpCDS.Eof do
        begin
          if (tmpCDS.FieldByName('orderno').AsString=s1) and
             (tmpCDS.FieldByName('orderitem').AsInteger=tmpOrderitem) and
             (tmpCDS.FieldByName('custom2').AsString=s3) and  //iteqjx:custom2
             (tmpCDS.FieldByName('materialno').AsString=s4) and
             (tmpCDS.FieldByName('sqty').AsInteger=tmpSqty) and
             (Length(tmpCDS.FieldByName('wono').AsString)=0) then
          begin
            tmpCDS.Edit;
            tmpCDS.FieldByName('wono').AsString:=s6;
            tmpCDS.Post;
            Inc(sno);
            Break;
          end;

          tmpCDS.Next;
        end;
      end;

      Inc(i);
    end;

    if CDSPost(tmpCDS, 'MPS070') then
    begin
      ShowMsg('更新完畢,共更新'+IntToStr(sno)+'筆,請重新查詢刷新資料',64);
      Exit;
    end;

  finally
    g_ProgressBar.Visible:=False;
    FreeAndNil(OpenDialog);
    FreeAndNil(tmpCDS);
    ExcelApp.Quit;
  end;
end;

end.
