unit unDLIR070_Query;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmDLIR070_Query = class(TFrmSTDI051)
    Dtp1: TDateTimePicker;
    Label1: TLabel;
    Edit1: TEdit;
    lblto2: TLabel;
    Dtp2: TDateTimePicker;
    lblsaleno: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    l_QueryStr:string;
    { Public declarations }
  end;

var
  FrmDLIR070_Query: TFrmDLIR070_Query;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmDLIR070_Query.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date;
  Dtp2.Date:=Date;
end;

procedure TFrmDLIR070_Query.btn_okClick(Sender: TObject);
const xformat='YYYYMMDD';
begin
  if Dtp1.Date>Dtp2.Date then
  begin
    ShowMsg('查詢開始日期不能大於截止日期!', 48);
    Exit;
  end;
  l_QueryStr:='';
  if Trim(Edit1.Text)<>'' then
     l_QueryStr:=' and saleno='+Quotedstr(Edit1.Text);
  l_QueryStr:=l_QueryStr+' and dno>='+Quotedstr(FormatDateTime(xformat,Dtp1.Date)+'001')
                        +' and dno<='+Quotedstr(FormatDateTime(xformat,Dtp2.Date)+'999');
  inherited;
end;

end.
