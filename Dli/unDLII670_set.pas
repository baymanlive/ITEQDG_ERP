unit unDLII670_set;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient;

type
  TFrmDLII670_set = class(TFrmSTDI051)
    Edit1: TEdit;
    procedure FormShow(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII670_set: TFrmDLII670_set;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII670_set.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select top 1 lastcode from dli671 where bu=''ITEQJX''';
  if not QueryOneCR(tmpSQL, Data) then
     Exit;
  Edit1.Text:=VarToStr(Data);
end;

procedure TFrmDLII670_set.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
begin
  //inherited;
  tmpSQL:=Trim(Edit1.Text);
  if Length(tmpSQL)=0 then
  begin
    ShowMsg('請輸入尾碼!',48);
    Exit;
  end;

  tmpSQL:='update dli671 set lastcode='+Quotedstr(tmpSQL)
         +',muser='+Quotedstr(g_UInfo^.UserId)
         +',mdate='+Quotedstr(FormatDateTime(g_cLongTimeSP,Now))
         +' where bu=''ITEQJX''';
  if PostBySQL(tmpSQL) then
     ShowMsg('設定完畢!',64);
end;

end.
