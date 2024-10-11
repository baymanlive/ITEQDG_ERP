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
  Label1.Caption:=CheckLang('�u�O�G');
  Label2.Caption:=CheckLang('�Ͳ����(�_)�G');
  Label3.Caption:=CheckLang('�Ͳ����(��)�G');
  Label4.Caption:=CheckLang('Excel�ɮײ�1��ݥ]�t�U�C���G');
  Label5.Caption:=CheckLang('�q��渹�B�q�涵���B�Ȥ�²�١B�Ͳ��Ƹ��B�ƨ�q�B�u�渹');
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
    ShowMsg('�п�ܽu�O',48);
    Exit;
  end;

  if dtp1.Date<Date then
  begin
    ShowMsg('�Ͳ����(�_)����p�_��Ѥ��',48);
    Exit;
  end;
  
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�Ͳ����(�_)����j�_�Ͳ����(��)',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  OpenDialog:=TOpenDialog.Create(nil);
  OpenDialog.Filter:=CheckLang('Excel�ɮ�(*.xlsx)|*.xlsx|Excel�ɮ�(*.xls)|*.xls');
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
      if tmpStr=CheckLang('�q��渹') then
         arr[0]:=i
      else if tmpStr=CheckLang('�q�涵��') then
         arr[1]:=i
      else if tmpStr=CheckLang('�Ȥ�²��') then
         arr[2]:=i
      else if tmpStr=CheckLang('�Ͳ��Ƹ�') then
         arr[3]:=i
      else if tmpStr=CheckLang('�ƨ�q') then
         arr[4]:=i
      else if tmpStr=CheckLang('�u�渹') then
         arr[5]:=i;
    end;

    if arr[0]=0 then
    begin
      ShowMsg('Excel�����[�q��渹]���',48);
      Exit;
    end;

    if arr[1]=0 then
    begin
      ShowMsg('Excel�����[�q�涵��]���',48);
      Exit;
    end;

    if arr[2]=0 then
    begin
      ShowMsg('Excel�����[�Ȥ�²��]���',48);
      Exit;
    end;

    if arr[3]=0 then
    begin
      ShowMsg('Excel�����[�Ͳ��Ƹ�]���',48);
      Exit;
    end;

    if arr[4]=0 then
    begin
      ShowMsg('Excel�����[�ƨ�q]���',48);
      Exit;
    end;

    if arr[5]=0 then
    begin
      ShowMsg('Excel�����[�u�渹]���',48);
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
      ShowMsg('���u�O�B�Ͳ��ɶ��q�L���}�u�檺���',48);
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

      //�����ŭ�,�h�X
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
        ShowMsg('��'+IntToStr(i-1)+'��[�q��渹]���~',48);
        Exit;
      end;

      tmpOrderitem:=StrToIntDef(s2,0);
      if tmpOrderitem<=0 then
      begin
        ShowMsg('��'+IntToStr(i-1)+'��[�q�涵��]���~',48);
        Exit;
      end;

      tmpSqty:=StrToIntDef(s5,0);
      if tmpSqty<=0 then
      begin
        ShowMsg('��'+IntToStr(i-1)+'��[�ƨ�q]���~',48);
        Exit;
      end;

      if Length(s6)<>10 then
      begin
        ShowMsg('��'+IntToStr(i-1)+'��[�u�渹]���~',48);
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
      ShowMsg('��s����,�@��s'+IntToStr(sno)+'��,�Э��s�d�ߨ�s���',64);
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
