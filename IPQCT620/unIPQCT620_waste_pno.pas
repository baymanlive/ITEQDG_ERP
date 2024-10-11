unit unIPQCT620_waste_pno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFrmIPQCT620_waste_pno = class(TForm)
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT620_waste_pno: TFrmIPQCT620_waste_pno;

implementation

{$R *.dfm}

procedure TFrmIPQCT620_waste_pno.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_RETURN then
     SelectNext(ActiveControl, True, True);
end;

procedure TFrmIPQCT620_waste_pno.BitBtn1Click(Sender: TObject);
begin
  if Length(Trim(Edit1.Text))=0 then
  begin
    Application.MessageBox('請輸入過期物料!','提示',48);
    Edit1.SetFocus;
    Exit;
  end;

   ModalResult:=mrOK;
end;

procedure TFrmIPQCT620_waste_pno.BitBtn2Click(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
