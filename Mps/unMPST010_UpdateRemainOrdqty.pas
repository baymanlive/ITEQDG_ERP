unit unMPST010_UpdateRemainOrdqty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls;

type
  TFrmUpdateRemainOrdqty = class(TFrmSTDI051)
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUpdateRemainOrdqty: TFrmUpdateRemainOrdqty;

implementation

uses unGlobal, unCommon,unMPST010;

{$R *.dfm}

procedure TFrmUpdateRemainOrdqty.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('�Ͳ�����G');
  Label2.Caption:=CheckLang('�ܡG');
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmUpdateRemainOrdqty.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
begin
  //inherited;
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('�}�l������i�j��I����',48);
    Exit;
  end;

  if dtp2.Date-dtp1.Date>2 then
  begin
    ShowMsg('����S�򤣥i�W�L3��',48);
    Exit;
  end;

  g_StatusBar.Panels[0].Text:='���b��s...';
  Application.ProcessMessages;
  tmpSQL:='exec [dbo].[proc_UpdateMPS_remain_ordqty] '+Quotedstr(g_UInfo^.Bu)+','+
                                                       Quotedstr(DateToStr(dtp1.Date))+','+
                                                       Quotedstr(DateToStr(dtp2.Date));
  if PostBySQL(tmpSQL) then
     ShowMsg('��s����,�Цb�@�~�����s�d����ܵ��G',64);
  g_StatusBar.Panels[0].Text:='';
end;

end.
