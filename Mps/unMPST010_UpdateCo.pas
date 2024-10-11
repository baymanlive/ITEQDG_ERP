unit unMPST010_UpdateCo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ComCtrls, ExtCtrls, ImgList, Buttons;

type
  TFrmUpdateCo = class(TFrmSTDI051)
    rgp: TRadioGroup;
    Label1: TLabel;
    dtp1: TDateTimePicker;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUpdateCo: TFrmUpdateCo;

implementation

uses unGlobal, unCommon,unMPST010;

{$R *.dfm}

procedure TFrmUpdateCo.FormCreate(Sender: TObject);
begin
  inherited;
  Label1.Caption:=CheckLang('生產日期：');
  Label2.Caption:=CheckLang('製令單號：');
  Label3.Caption:=CheckLang('至：');
  if (not SameText(g_UInfo^.Bu, 'ITEQDG')) and (not SameText(g_UInfo^.Bu, 'ITEQGZ')) then
     rgp.Visible:=False;
  dtp1.Date:=Date;
  dtp2.Date:=Date;
end;

procedure TFrmUpdateCo.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
begin
  //inherited;
  if dtp1.Date>dtp2.Date then
  begin
    ShowMsg('開始日期不可大於截止日期',48);
    Exit;
  end;

  if dtp2.Date-dtp1.Date>2 then
  begin
    ShowMsg('日期范圍不可超過3天',48);
    Exit;
  end;

  g_StatusBar.Panels[0].Text:='正在更新...';
  Application.ProcessMessages;
  if rgp.ItemIndex=0 then
     tmpSQL:='Y'
  else
     tmpSQL:='N';
  tmpSQL:='exec [dbo].[proc_UpdateCo] '+Quotedstr(g_UInfo^.Bu)+','+
                                        Quotedstr(DateToStr(dtp1.Date))+','+
                                        Quotedstr(DateToStr(dtp2.Date))+','+
                                        Quotedstr(Trim(Edit1.Text))+','+
                                        Quotedstr(tmpSQL);
  if PostBySQL(tmpSQL) then
     ShowMsg('更新完畢,請在作業中重新查詢顯示結果',64);
  g_StatusBar.Panels[0].Text:='';
end;

end.
