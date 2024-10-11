unit unMPST020_Orderno2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, StdCtrls, ExtCtrls, ComCtrls, ImgList, Buttons, DBClient;

type
  TFrmMPST020_Orderno2 = class(TFrmSTDI050)
    lblorderdate: TLabel;
    Dtp1: TDateTimePicker;
    RadioGroup1: TRadioGroup;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST020_Orderno2: TFrmMPST020_Orderno2;

implementation

uses unCommon, unGlobal;

{$R *.dfm}

procedure TFrmMPST020_Orderno2.FormCreate(Sender: TObject);
begin
  inherited;
  RadioGroup1.Caption:=CheckLang('線別');
  TabSheet2.Caption:=CheckLang('兩角訂單');
  Dtp1.Date:=Date;
end;

procedure TFrmMPST020_Orderno2.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
  tmpList:TStrings;
begin
//  inherited;
  if ShowMsg('確定更新兩角訂單號碼嗎?', 33)=IdCancel then
     Exit;

  btn_ok.Enabled:=False;
  g_StatusBar.Panels[0].Text:=CheckLang('正在更新...');
  Application.ProcessMessages;
  try
    tmpSQL:='exec dbo.proc_MPST020_OAO '+Quotedstr(g_UInfo^.BU)+','+
          Quotedstr(DateToStr(Dtp1.Date))+','+
          IntToStr(RadioGroup1.ItemIndex);
    if QueryBySQL(tmpSQL, Data) then
    begin
      Memo1.Clear;
      tmpList:=TStringList.Create;
      tmpCDS:=TClientDataSet.Create(nil);
      try
        tmpCDS.Data:=Data;
        with tmpCDS do
        while not Eof do
        begin
          tmpList.Add(FieldByName('sdate').AsString+' '+
                      FieldByName('machine').AsString+'/'+
                      FieldByName('currentboiler').AsString+' '+
                      FieldByName('custno').AsString+'-'+
                      FieldByName('remark').AsString+' '+
                      FieldByName('orderno2').AsString+'/'+
                      FieldByName('orderitem2').AsString);
          Next;
        end;
        Memo1.Lines.Add(CheckLang('本次更新：'));
        Memo1.Lines.AddStrings(tmpList);
        ShowMsg('更新完畢!', 64);
        PCL.ActivePageIndex:=1;
      finally
        tmpList.Free;
        tmpCDS.Free;
      end;
    end;
  finally
    btn_ok.Enabled:=True;
    g_StatusBar.Panels[0].Text:='';
  end;
end;

end.
