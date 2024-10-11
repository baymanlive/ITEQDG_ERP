unit unMPSR140_PGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmMPSR140_PGroup = class(TFrmSTDI051)
    Lv: TListView;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    l_ret:string;
    procedure ShowData;
  end;

var
  FrmMPSR140_PGroup: TFrmMPSR140_PGroup;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR140_PGroup.ShowData;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Lv.Items.BeginUpdate;
  try
    Lv.Items.Clear;
    tmpSQL:='Select Distinct PGroup,Custno From MPS341';
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
      tmpCDS.Free;
    end;
  finally
    Lv.Items.EndUpdate;
  end;
end;

procedure TFrmMPSR140_PGroup.btn_okClick(Sender: TObject);
var
  i:Integer;
begin
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

  inherited;
end;

end.
