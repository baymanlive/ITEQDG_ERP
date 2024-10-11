unit unMPST070_SwapSdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmMPST070_SwapSdate = class(TFrmSTDI051)
    Label1: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Label3: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_caption:string;
    { Private declarations }
  public
    l_machine:string;
    l_ret:Boolean;
    { Public declarations }
  end;

var
  FrmMPST070_SwapSdate: TFrmMPST070_SwapSdate;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPST070_SwapSdate.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=Label1.Caption;
  Label3.Caption:=CheckLang('↑↓');
  l_caption:=Self.Caption;
end;

procedure TFrmMPST070_SwapSdate.FormShow(Sender: TObject);
begin
  inherited;
  l_ret:=False;
  Self.Caption:=l_caption+'-'+l_machine;
end;

procedure TFrmMPST070_SwapSdate.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  //inherited;
  
  if Dtp1.Date=Dtp2.Date then
  begin
    ShowMsg('請選擇不同的日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Dtp1.Date<Date then
  begin
    ShowMsg('生產日期不可小於當前日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  if Dtp2.Date<Date then
  begin
    ShowMsg('生產日期不可小於當前日期!',48);
    Dtp2.SetFocus;
    Exit;
  end;

  if ShowMsg('確定對換生產日期嗎?', 33)=IdCancel then
     Exit;

  tmpSQL:='Select Bu,Simuver,Citem,Sdate From MPS070'
         +' Where Bu='+Quotedstr(g_UInfo^.Bu)
         +' And Machine='+Quotedstr(l_machine)
         +' And (Sdate='+Quotedstr(DateToStr(Dtp1.Date))
         +' or Sdate='+Quotedstr(DateToStr(Dtp2.Date))+')';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='Sdate='+Quotedstr(DateToStr(Dtp1.Date));
    tmpCDS.Filtered:=True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg(DateToStr(Dtp1.Date)+'無資料!',48);
      Exit;
    end;
    tmpCDS.Filtered:=False;
    tmpCDS.Filter:='Sdate='+Quotedstr(DateToStr(Dtp2.Date));
    tmpCDS.Filtered:=True;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg(DateToStr(Dtp2.Date)+'無資料!',48);
      Exit;
    end;
    tmpCDS.Filtered:=False;
    tmpCDS.First;
    while not tmpCDS.Eof do
    begin
      tmpCDS.Edit;
      if tmpCDS.FieldByName('Sdate').AsDateTime=Dtp1.Date then
         tmpCDS.FieldByName('Sdate').AsDateTime:=Dtp2.Date
      else
         tmpCDS.FieldByName('Sdate').AsDateTime:=Dtp1.Date;
      tmpCDS.Post;
      tmpCDS.Next;
    end;

    if CDSPost(tmpCDS, 'MPS070') then
    begin
      if not l_ret then
         l_ret:=True;
      ShowMsg('更新完畢,請在作業中重新顯示數據!',64);
    end;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

end.
