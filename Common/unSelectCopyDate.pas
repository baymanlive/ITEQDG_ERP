unit unSelectCopyDate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unFrmBaseEmpty, ImgList, StdCtrls, Buttons, ComCtrls;

type
  TFrmSelectCopyDate = class(TFrmBaseEmpty)
    lbld1: TLabel;
    lbld2: TLabel;
    lbld3: TLabel;
    Dtp1: TDateTimePicker;
    Dtp2: TDateTimePicker;
    Dtp3: TDateTimePicker;
    btn_quit: TBitBtn;
    btn_ok: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmSelectCopyDate: TFrmSelectCopyDate;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSelectCopyDate.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, Self.Name);
end;

procedure TFrmSelectCopyDate.FormShow(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date-1;
  Dtp2.Date:=Date;
  Dtp3.Date:=Date;
  p_isModalForm:=True;
end;

procedure TFrmSelectCopyDate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  p_isModalForm:=False;
end;

procedure TFrmSelectCopyDate.btn_okClick(Sender: TObject);
begin
  inherited;
  if Dtp2.Date>Dtp3.Date then
  begin
    ShowMsg('開始日期不可大於截止日期!', 48);
    Exit;
  end;
  
  if ShowMsg('確定開始複製資料嗎?', 33)=IDOK then
     ModalResult:=mrOK;
end;

procedure TFrmSelectCopyDate.btn_quitClick(Sender: TObject);
begin
  inherited;
  ModalResult:=mrCancel;
end;

end.
