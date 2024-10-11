unit unMPS001;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ImgList, StdCtrls,DBClient;

type
  TFrmMPSS001 = class(TFrmBaseEmpty)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSS001: TFrmMPSS001;

implementation

{$R *.dfm}
uses
  unCommon;

const
  fname = 'mpst040l1';
procedure TFrmMPSS001.Button1Click(Sender: TObject);
begin
  inherited;
  PostBySQL('update sys_setting set ' + fname + '=' + QuotedStr(Edit1.text) + ' where id=1');
end;

procedure TFrmMPSS001.FormShow(Sender: TObject);
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

end.
