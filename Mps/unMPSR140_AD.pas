unit unMPSR140_AD;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmMPSR140_AD = class(TFrmSTDI051)
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
  FrmMPSR140_AD: TFrmMPSR140_AD;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSR140_AD.ShowData;
var
  pos1:Integer;
  tmpSQL,str:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Lv.Items.BeginUpdate;
  try
    Lv.Items.Clear;
    tmpSQL:='Select Distinct AD From MPS341 Where AD<>''PP'' and AD<>''CCL''';
    if not QueryBySQL(tmpSQL, Data) then
       Exit;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        with Lv.Items.Add do
          Caption:=tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;

      tmpCDS.First;
      while not tmpCDS.Eof do
      begin
        tmpSQL:=StringReplace(tmpCDS.Fields[0].AsString,'¡A',',',[rfReplaceAll])+',';
        pos1:=Pos(',',tmpSQL);
        while pos1>0 do
        begin
          str:=Copy(tmpSQL,1,pos1-1);
          if length(str)>0 then
          begin
            with Lv.Items.Add do
              Caption:=str;
          end;
          tmpSQL:=Copy(tmpSQL,pos1+1,Length(tmpSQL)-pos1);
          pos1:=Pos(',',tmpSQL);
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

procedure TFrmMPSR140_AD.btn_okClick(Sender: TObject);
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
