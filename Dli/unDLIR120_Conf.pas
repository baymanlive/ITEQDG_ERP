unit unDLIR120_Conf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR120_Conf = class(TFrmSTDI051)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    Label7: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit4: TEdit;
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIR120_Conf: TFrmDLIR120_Conf;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR120_Conf.FormShow(Sender: TObject);
begin
  inherited;
  Edit1.Text:='';
  Edit2.Text:='';
  Edit3.Text:='';
end;

procedure TFrmDLIR120_Conf.btn_okClick(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    ShowMsg('請輸入車牌號!',48);
    Exit;
  end;
  if Length(Trim(Edit2.Text))=0 then
  begin
    ShowMsg('請輸入電話!',48);
    Exit;
  end;
  if Length(Trim(Edit3.Text))=0 then
  begin
    ShowMsg('請輸入司機姓名!',48);
    Exit;
  end;
  if Length(Trim(Edit4.Text))=0 then
  begin
    ShowMsg('請輸入檔案名稱!',48);
    Exit;
  end;
  inherited;
end;

end.
