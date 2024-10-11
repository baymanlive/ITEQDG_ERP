{*******************************************************}
{                                                       }
{                unMPST040_Indate                       }
{                Author: kaikai                         }
{                Create date: 2016/02/29                }
{                Description: 根據達交日期產生出貨排程  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST040_Indate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI050, StdCtrls, ComCtrls, ImgList, Buttons, ExtCtrls,
  DBClient, DateUtils, Math, unMPST040_IndateClass;

type
  TFrmMPST040_Indate = class(TFrmSTDI050)
    lblindate: TLabel;
    Dtp1: TDateTimePicker;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_IndateClass:TMPST040_IndateClass;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPST040_Indate: TFrmMPST040_Indate;

implementation

uses unGlobal, unCommon, unMPST040, unMPST040_units;

{$R *.dfm}

procedure TFrmMPST040_Indate.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp1.Date:=Date+1;
  TabSheet2.Caption:=CheckLang('提示信息');
end;

procedure TFrmMPST040_Indate.FormShow(Sender: TObject);
begin
  inherited;
  PCL.ActivePageIndex:=0;
  Memo1.Lines.Clear;
end;

procedure TFrmMPST040_Indate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_IndateClass) then
     FreeAndNil(l_IndateClass);
end;

procedure TFrmMPST040_Indate.btn_okClick(Sender: TObject);
var
  tmpSQL, OutMsg:string;
  IsConfirm:Boolean;
begin
//  inherited;
  if Dtp1.Date<Date then
  begin
    ShowMsg('出貨日期不能小於當前日期!',48);
    Dtp1.SetFocus;
    Exit;
  end;

  IsConfirm:=CheckConfirm(Dtp1.Date);
  if IsConfirm then
  begin
    ShowMsg(DateToStr(Dtp1.Date)+'出貨表已確認,請使用單筆新增!', 48);
    Dtp1.SetFocus;
    Exit;
  end;

  tmpSQL:='Select * From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Isnull(Flag,0)=0 And Qty>0 And (CDate='+Quotedstr(DateToStr(Dtp1.Date))
         +' Or (CDate is null And ADate='+Quotedstr(DateToStr(Dtp1.Date))+'))'
         +' And IsNull(GarbageFlag,0)=0';
  if not Assigned(l_IndateClass) then
     l_IndateClass:=TMPST040_IndateClass.Create;
  l_IndateClass.ArrOutQty:=nil;
  if l_IndateClass.Exec(Dtp1.Date, tmpSQL, IsConfirm, OutMsg) then
  begin
    RefreshGrdCaption(FrmMPST040.CDS,FrmMPST040.DBGridEh1,FrmMPST040.l_StrIndex,FrmMPST040.l_StrIndexDesc);
    FrmMPST040.CDS.Data:=l_IndateClass.Data;
  end;
  if Length(OutMsg)>0 then
  begin
    Memo1.Lines.Text:=OutMsg;
    PCL.ActivePageIndex:=1;
  end;  
end;

end.
