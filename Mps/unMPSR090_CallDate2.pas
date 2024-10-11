{*******************************************************}
{                                                       }
{                unMPSR090_CallDate2                    }
{                Author: kaikai                         }
{                Create date: 2016/09/22                }
{                Description: 一鍵Call貨日期            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR090_CallDate2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DB;

type
  TFrmMPSR090_CallDate2 = class(TFrmSTDI051)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Dtp: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR090_CallDate2: TFrmMPSR090_CallDate2;

implementation

uses  unGlobal, unCommon, unMPSR090, unMPST040_units;

{$R *.dfm}

procedure TFrmMPSR090_CallDate2.FormCreate(Sender: TObject);
begin
  inherited;
  Dtp.Date:=Date;
end;

procedure TFrmMPSR090_CallDate2.btn_okClick(Sender: TObject);
var
  tmpStr: string;
  tmpBool: Boolean;
  tmpSQL:string;
  P:TBookmark;
  DNE1,DNE2,DNE3,DNE4,DNE5:TDataSetNotifyEvent;
  Data:OleVariant;
begin
  //inherited;

  if Dtp.Date<Date then
  begin
    ShowMsg('Call貨日期不能小於當天日期!', 48);
    Dtp.SetFocus;
    Exit;
  end;

  if ShowMsg('確定把列表中的Call貨日期全部更改為'+DateToStr(Dtp.Date)+'嗎?', 33)=IdCancel then
     Exit;

  if not CheckLockProc(tmpBool, 'MPST040') then
     Exit;

  if tmpBool then
  begin
    ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
    Exit;
  end;

  if CheckConfirm(Dtp.Date) then
  begin
    ShowMsg('此日期出貨表已確認,不可更改為此日期!', 48);
    Exit;
  end;

  tmpStr:='';
  with FrmMPSR090.CDS do
  begin
    P:=GetBookmark;
    DisableControls;
    DNE1:=AfterScroll;
    DNE2:=BeforeEdit;
    DNE3:=AfterEdit;
    DNE4:=BeforePost;
    DNE5:=AfterPost;
    AfterScroll:=nil;
    BeforeEdit:=nil;
    AfterEdit:=nil;
    BeforePost:=nil;
    AfterPost:=nil;
  end;
  try
    with FrmMPSR090.CDS do
    begin
      First;
      while not Eof do
      begin
        tmpStr:=tmpStr+','+IntToStr(FieldByName('Ditem').AsInteger);
        Next;
      end;
    end;

    Delete(tmpStr,1,1);
    tmpSQL:='Select Top 1 Ditem From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Flag=1 And Ditem in ('+tmpStr+')';
    if not QueryOneCR(tmpSQL, Data) then
       Exit;
    tmpSQL:=VarToStr(Data);
    if Length(tmpSQL)>0 then
    begin
      if FrmMPSR090.CDS.Locate('Ditem',StrToInt(tmpSQL),[]) then
         P:=FrmMPSR090.CDS.GetBookmark;
      ShowMsg('存在訂單資料已排出貨,不可更改!', 48);
      Exit;
    end;

    tmpSQL:='Update MPS200 Set Cdate='+Quotedstr(DateToStr(Dtp.Date))
           +',Remark2='+Quotedstr(Trim(Edit1.Text))
           +',Muser='+Quotedstr(g_UInfo^.UserId)
           +',Mdate='+Quotedstr(FormatDateTime(g_cLongTimeSP, Now))
           +' Where Bu='+Quotedstr(g_UInfo^.BU)
           +' And Ditem in ('+tmpStr+')';
    if PostBySQL(tmpSQL) then
    begin
      with FrmMPSR090.CDS do
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('cdate').AsDateTime:=Dtp.Date;
          FieldByName('remark2').AsString:=Trim(Edit1.Text);
          Post;
          Next;
        end;
        MergeChangeLog;
      end;
      ShowMsg('更改完畢!', 64);
    end;

  finally
    with FrmMPSR090.CDS do
    begin
      GotoBookmark(P);
      EnableControls;
      AfterScroll:=DNE1;
      BeforeEdit:=DNE2;
      AfterEdit:=DNE3;
      BeforePost:=DNE4;
      AfterPost:=DNE5;
    end;
  end;
end;

end.
