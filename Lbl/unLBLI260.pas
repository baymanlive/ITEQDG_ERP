unit unLBLI260;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, StdCtrls, ImgList, DBClient;

type
  TFrmLBLI260 = class(TFrmBaseEmpty)
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmLBLI260: TFrmLBLI260;

implementation

{$R *.dfm}
uses
  unCommon;

const
  fname = 'lblgt';

procedure TFrmLBLI260.FormShow(Sender: TObject);
var
  data: OleVariant;
  tmpCDS: TClientDataSet;
begin
  inherited;

  QueryBySQL('select ' + fname + ' from sys_setting where id=1', data);
  tmpCDS := TClientDataSet.create(nil);
  try
    tmpCDS.data := data;
    Edit1.text := tmpCDS.fieldbyname(fname).asstring;
  finally
    tmpCDS.free;
  end;
end;

procedure TFrmLBLI260.Button1Click(Sender: TObject);
begin
  inherited;
  PostBySQL('update sys_setting set ' + fname + '=' + QuotedStr(Edit1.text) + ' where id=1');
end;

end.

