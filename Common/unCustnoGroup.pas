unit unCustnoGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmCustnoGroup = class(TFrmSTDI051)
    Lv: TListView;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_ret:string;
    procedure ShowData;
    { Public declarations }
  end;

var
  FrmCustnoGroup: TFrmCustnoGroup;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmCustnoGroup.ShowData;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Lv.Items.BeginUpdate;
  try
    Lv.Items.Clear;
    tmpSQL:='Select GroupId,Custno From MPS340 Where Bu='+Quotedstr(g_UInfo^.Bu);
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        with Lv.Items.Add do
        begin
          Caption:=tmpCDS.Fields[0].AsString;
          SubItems.Add(tmpCDS.Fields[1].AsString);
        end;
        tmpCDS.Next;
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  finally
    Lv.Items.EndUpdate;
  end;
end;

procedure TFrmCustnoGroup.btn_okClick(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  l_ret:='';
  for i:=0 to Lv.Items.Count-1 do
  begin
    if Lv.Items[i].Checked then
    begin
      if Length(l_ret)>0 then
         l_ret:=l_ret+',';
      l_ret:=l_ret+Lv.Items[i].Caption;
    end;
  end;
end;

end.
