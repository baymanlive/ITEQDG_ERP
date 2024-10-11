unit RowfilterFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, ExtCtrls, StdCtrls, RzLstBox, RzChkLst;

type
  TfrmRowfilter = class(TForm)
    L_Info: TLabel;
    Shape1: TShape;
    lblFunctionTitle: TLabel;
    lblFunctionDesc: TLabel;
    imgFunctionIcon: TImage;
    Back: TPanel;
    P_Left: TPanel;
    RzCheckList1: TRzCheckList;
    btnOK: TRzBitBtn;
    btnCancel: TRzBitBtn;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    procedure RzBitBtn1Click(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  frmRowfilter: TfrmRowfilter;

implementation

{$R *.dfm}

procedure TfrmRowfilter.RzBitBtn1Click(Sender: TObject);
begin
  RzCheckList1.CheckAll;
end;

procedure TfrmRowfilter.RzBitBtn2Click(Sender: TObject);
begin
  RzCheckList1.UncheckAll;
end;

end.
