{*******************************************************}
{                                                       }
{                unMPSI290                              }
{                Author: kaikai                         }
{                Create date: 2016/03/04                }
{                Description: 客戶切貨時間              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI290;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, DB, DBClient, Menus, ImgList,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrls, DBCtrlsEh;

type
  TFrmMPSI290 = class(TFrmSTDI010)
    Custno: TLabel;
    Stime: TLabel;
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_postClick(Sender: TObject);
    procedure CDSAfterScroll(DataSet: TDataSet);
    procedure CDSAfterOpen(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
  private
    procedure SetMemo;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI290: TFrmMPSI290;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI290.SetMemo;
begin
  if CDS.Active and (not CDS.IsEmpty) then
     Memo1.Lines.DelimitedText:=CDS.FieldByName('Custno').AsString
  else
     Memo1.Lines.Clear;
end;

procedure TFrmMPSI290.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  Memo1.Lines.Clear;
  tmpSQL:='Select * From MPS290 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI290.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS290';
  p_FocusCtrl:=Memo1;
  p_SBText:=CheckLang('客戶編號之間請使用任意特殊符號做間隔(!@#$%^&*,"、)');

  inherited;

  Custno.Caption:=CheckLang('客戶代號,一行一個');
end;

procedure TFrmMPSI290.btn_postClick(Sender: TObject);
begin
  if Length(Trim(Memo1.Text))=0 then
  begin
    ShowMsg('請輸入[%s]', 48, myStringReplace(Custno.Caption));
    if Memo1.CanFocus then
       Memo1.SetFocus;
    Exit;
  end;
  
  if CDS.FieldByName('Stime').IsNull then
  begin
    ShowMsg('請輸入[%s]', 48, myStringReplace(Custno.Caption));
    if DBDateTimeEditEh1.CanFocus then
       DBDateTimeEditEh1.SetFocus;
    Exit;
  end;

  CDS.FieldByName('Custno').AsString:=Trim(Memo1.Lines.DelimitedText);

  if CDS.State in [dsInsert] then
     CDS.FieldByName('Dno').AsString:=GetSno(g_MInfo^.ProcId);

  inherited;
end;

procedure TFrmMPSI290.CDSAfterScroll(DataSet: TDataSet);
begin
  inherited;
  SetMemo;
end;

procedure TFrmMPSI290.CDSAfterOpen(DataSet: TDataSet);
begin
  inherited;
  if CDS.IsEmpty then
     SetMemo;
end;

procedure TFrmMPSI290.CDSAfterDelete(DataSet: TDataSet);
begin
  inherited;
  if CDS.IsEmpty then
     SetMemo;
end;

end.
