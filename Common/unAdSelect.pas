unit unAdSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmAdSelect = class(TFrmSTDI051)
    Lv: TListView;
    chkAll: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure chkAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_AdCode,l_AdName:string;
    { Public declarations }
  end;

var
  FrmAdSelect: TFrmAdSelect;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmAdSelect.FormCreate(Sender: TObject);
begin
  inherited;
  with Lv.Columns do
  begin
    BeginUpdate;
    Clear;
    with Add do
    begin
      Caption:=CheckLang('膠系(第2碼)');
      Width:=80;
    end;
    with Add do
    begin
      Caption:=CheckLang('尾碼');
      Width:=200;
    end;
    with Add do
    begin
      Caption:=CheckLang('名稱');
      Width:=140;
    end;
    with Add do
    begin
      Caption:=CheckLang('備註');
      Width:=70;
    end;
    EndUpdate;
  end;
end;

procedure TFrmAdSelect.FormShow(Sender: TObject);
var
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if not QueryBySQL('select * from sys_ad', Data) then
     Exit;

  Lv.Tag:=1;
  chkAll.Checked:=False;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
       Exit;

    with Lv.Items do
    begin
      BeginUpdate;
      Clear;
      while not tmpCDS.Eof do
      begin
        with Add do
        begin
          Caption:=tmpCDS.FieldByName('code2').AsString;
          SubItems.Add(tmpCDS.FieldByName('lastcode').AsString);
          SubItems.Add(tmpCDS.FieldByName('name').AsString);
          SubItems.Add(tmpCDS.FieldByName('remark').AsString);
        end;
        tmpCDS.Next;
      end;
      EndUpdate;
    end;
  finally
    Lv.Tag:=0;
    tmpCDS.Free;
  end;
end;

procedure TFrmAdSelect.chkAllClick(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  if Lv.Tag=1 then
     Exit;

  with Lv do
  for i:=0 to Items.Count-1 do
    Items[i].Checked:=chkAll.Checked;
end;

procedure TFrmAdSelect.btn_okClick(Sender: TObject);
var
  i:Integer;
begin
  inherited;
  l_AdCode:='';
  with Lv do
  for i:=0 to Items.Count-1 do
  begin
    if Items[i].Checked then
    begin
      l_AdCode:=l_AdCode+','+Items[i].Caption;
      l_AdName:=l_AdName+','+Items[i].SubItems[1];
    end;
  end;

  if Length(l_AdCode)>0 then
  begin
    Delete(l_AdCode,1,1);
    Delete(l_AdName,1,1);
  end;
end;

end.
