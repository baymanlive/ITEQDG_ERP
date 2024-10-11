{*******************************************************}
{                                                       }
{                unMPST010_CalcBooks                    }
{                Author: kaikai                         }
{                Create date: 2015/10/4                 }
{                Description: 計算一天本數              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_CalcBooks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmClacBooks = class(TFrmSTDI051)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Cbb: TComboBox;
    Label2: TLabel;
    Dtp1: TDateTimePicker;
    PageControl1: TPageControl;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure getBoilers(machine:string);
    procedure clearPagecontrol();
  private
    { Private declarations }
  public
    l_Machine:string;
    { Public declarations }
  end;

var
  FrmClacBooks: TFrmClacBooks;

implementation

uses unGlobal, unCommon, unMPST010;

{$R *.dfm}

procedure TFrmClacBooks.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('机台：');
  Label2.Caption:=CheckLang('生產日期：');
  Dtp1.Date:=Date;
  Cbb.Items.DelimitedText:='ALL,' + g_MachineCCL;
  Cbb.ItemIndex:=0;
end;

procedure TFrmClacBooks.FormShow(Sender: TObject);
begin
  inherited;
  with FrmMPST010 do
  if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  begin
    Self.Cbb.ItemIndex:=Self.Cbb.Items.IndexOf(CDS.FieldByName('Machine').AsString);
    Self.Dtp1.Date:=CDS.FieldByName('Sdate').AsDateTime;
  end;
end;

procedure TFrmClacBooks.btn_okClick(Sender: TObject);
var
  i:Integer;
begin
  clearPagecontrol();
  if(SameText(Cbb.Text,'ALL'))then
    for i := 1 to Cbb.Items.Count-1 do
      getBoilers(Cbb.Items.Strings[i])
  else
      getBoilers(Cbb.Text);
end;

// 清除 Pagecontrol 的 Tab 內容
procedure TFrmClacBooks.clearPagecontrol();
var
  i:integer;
begin
  pagecontrol1.TabIndex :=pagecontrol1.PageCount-1 ;
  for i:=pagecontrol1.PageCount-1 downto 0 do
  begin
    pagecontrol1.TabIndex:=i;
    pagecontrol1.Pages[i].Free;
  end;
end;

procedure TFrmClacBooks.getBoilers(machine:string);
var
  Tab: TTabSheet;
  Rich: TRichEdit;
  i,tmpMaxBoiler,tmpLine:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin

  // 新建 Tab 與 文本框
  Tab := TTabSheet.Create(self);
  Tab.PageControl:= PageControl1;
  Tab.Caption := machine;
  PageControl1.ActivePage := Tab;
  Rich := TRichEdit.Create(Self);
  Rich.Parent := Tab;
  Rich.Align := alClient;
  Rich.ReadOnly:=true;

  tmpSQL:='Select CurrentBoiler,Machine,Materialno,Book_qty,IsNull(Sqty,0) Sqty,'
         +' IsNull(EmptyFlag,0) EmptyFlag From MPS010 '
         +' Where Sdate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And Machine='+Quotedstr(machine)
         +' And IsNull(ErrorFlag,0)=0'
         +' Order By Machine,Jitem';

  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpSQL:='';
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        i:=1;
        tmpCDS.Last;
        tmpMaxBoiler:=tmpCDS.FieldByName('CurrentBoiler').AsInteger;
        while i<=tmpMaxBoiler do
        begin
          tmpCDS.Filtered:=False;
          tmpCDS.Filter:='Sqty<>0 and CurrentBoiler='+IntToStr(i);
          tmpCDS.Filtered:=True;
          tmpSQL:=tmpSQL+IntToStr(i)+': '+FloatToStr(FrmMPST010.GetTotBooks(tmpCDS))+#13#10;
          Inc(i);
        end;

        Rich.Text:= CheckLang(machine + ' 各鍋本數')+#13#10+tmpSQL;

        // 不滿鍋標記紅色
        tmpCDS.Filtered:=False;
        i:=1;
        while i<=tmpMaxBoiler do
        begin
          if tmpCDS.Locate('CurrentBoiler;EmptyFlag', VarArrayOf([i,1]), []) then
          begin
            tmpLine:=SendMessage(Rich.Handle,EM_LINEINDEX, i, 0);
            Rich.SelStart:=tmpLine;
            Rich.SelLength:=Length(Rich.Lines.Strings[i]);
            Rich.SelAttributes.Color:=clRed;
          end;
          Inc(i);
        end;
      end;

    finally
      FreeAndNil(tmpCDS);
    end;
  end;

//  inherited;
end;

end.
