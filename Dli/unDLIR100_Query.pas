unit unDLIR100_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, DBClient;

type
  TFrmDLIR100_Query = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    btn_query: TBitBtn;
    rgp: TRadioGroup;
    Memo1: TMemo;
    procedure btn_okClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    l_lot:string;
    { Public declarations }
  end;

var
  FrmDLIR100_Query: TFrmDLIR100_Query;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR100_Query.btn_okClick(Sender: TObject);
var
  i:Integer;
  s:string;
begin
  l_lot:='';
  for i:=0 to Memo1.Lines.Count-1 do
  begin
    s:=Trim(Memo1.Lines.Strings[i]);
    if Length(s)=0 then
       Continue;
    if Length(l_lot)>0 then
       l_lot:=l_lot+',';
    l_lot:=l_lot+Quotedstr(UpperCase(s));
  end;

  if Length(l_lot)=0 then
  begin
    ShowMsg('請輸入批號!',48);
    Memo1.SetFocus;
    Exit;
  end;

  inherited;
end;

procedure TFrmDLIR100_Query.btn_queryClick(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入批號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  tmpSQL:='Select Distinct Upper(Manfac) AS lot From DLI020'
         +' Where Bu='+QuotedStr(rgp.Items.Strings[rgp.ItemIndex])
         +' And Manfac1='+QuotedStr(Trim(Edit1.Text));
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    Memo1.Lines.Clear;
    Memo1.Lines.BeginUpdate;
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      while not Eof do
      begin
        Memo1.Lines.Add(Fields[0].AsString);
        Next;
      end;
    finally
      tmpCDS.Free;
      Memo1.Lines.EndUpdate;
    end;
  end;
end;

procedure TFrmDLIR100_Query.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  i:=rgp.Items.IndexOf(g_UInfo^.BU);
  if i=-1 then
     rgp.ItemIndex:=0
  else
     rgp.ItemIndex:=i;
end;

end.
