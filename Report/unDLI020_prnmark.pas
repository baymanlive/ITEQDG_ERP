{*******************************************************}
{                                                       }
{                unDLI020_prnmark                       }
{                Author: kaikai                         }
{                Create date: 2016/1/25                 }
{                Description: 出貨單異常列印說明        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLI020_prnmark;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, Menus, ImgList, StdCtrls, Buttons, ExtCtrls,
  ComCtrls, ToolWin, DBClient;

type
  TFrmDLII020_prnmark = class(TFrmSTDI050)
    TabSheet2: TTabSheet;
    RichEdit2: TRichEdit;
    RichEdit1: TRichEdit;
    RadioGroup1: TRadioGroup;
    procedure btn_okClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetAllMark(Saleno: string; PrnCnt:Integer);
    { Public declarations }
  end;

var
  FrmDLII020_prnmark: TFrmDLII020_prnmark;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII020_prnmark.SetAllMark(Saleno: string; PrnCnt:Integer);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  tmpSQL:='Select Times,Memo From DLI480 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Saleno='+Quotedstr(Saleno);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        RichEdit2.SelStart:=Length(RichEdit2.Text)+1;
        RichEdit2.SelLength:=Length(FieldByName('Times').AsString);
        RichEdit2.SelAttributes.Color:=clRed;
        RichEdit2.Lines.Add(FieldByName('Times').AsString);
        RichEdit2.Lines.Add(FieldByName('Memo').AsString+#13#10);
        Next;
      end;
    finally
      tmpCDS.Free;
    end;
  end;

  Self.Caption:=Self.Caption+' '+IntToStr(PrnCnt);
end;

procedure TFrmDLII020_prnmark.btn_okClick(Sender: TObject);
begin
  if RadioGroup1.ItemIndex=RadioGroup1.Items.Count-1 then
  begin
    if Length(Trim(RichEdit1.Text))=0 then
    begin
      ShowMsg('請輸入說明!', 48);
      Exit;
    end;

    if Length(RichEdit1.Text)>200 then
    begin
      ShowMsg('說明內容字符長度不能超出200!', 48);
      Exit;
    end;
  end;

  inherited;
end;

procedure TFrmDLII020_prnmark.RadioGroup1Click(Sender: TObject);
begin
  inherited;
  RichEdit1.Enabled:=RadioGroup1.ItemIndex=RadioGroup1.Items.Count-1;
  RichEdit1.Lines.Clear;
  if RichEdit1.CanFocus then
     RichEdit1.SetFocus;
end;

procedure TFrmDLII020_prnmark.FormShow(Sender: TObject);
begin
  inherited;
  if RichEdit1.CanFocus then
     RichEdit1.SetFocus;
end;

end.
