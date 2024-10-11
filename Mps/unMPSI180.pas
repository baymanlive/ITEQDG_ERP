{*******************************************************}
{                                                       }
{                unMPSI180                              }
{                Author: kaikai                         }
{                Create date: 2016/06/17                }
{                Description: 客戶群產能                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI180;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, DB, DBClient, Menus, ImgList,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrls, DBCtrlsEh;

type
  TFrmMPSI180 = class(TFrmSTDI010)
    Custno: TLabel;
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    DBMemo1: TDBMemo;
    DBEdit2: TDBEdit;
    ad: TLabel;
    GroupId: TLabel;
    DBEdit1: TDBEdit;
    MaxQty: TLabel;
    DBEdit3: TDBEdit;
    isthin: TDBCheckBox;
    DBMemo2: TDBMemo;
    LockMonth: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI180: TFrmMPSI180;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI180.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS180 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI180.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS180';
  p_FocusCtrl:=DBEdit1;
  p_SBText:=CheckLang('客戶編號之間請使用逗號間隔(,)');

  inherited;
end;

procedure TFrmMPSI180.CDSBeforePost(DataSet: TDataSet);
begin
  if CDS.FieldByName('GroupId').AsString='' then
  begin
    ShowMsg('請輸入[%s]', 48, myStringReplace(GroupId.Caption));
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    Abort;
  end;

  if CDS.FieldByName('Custno').AsString='' then
  begin
    ShowMsg('請輸入[%s]', 48, myStringReplace(Custno.Caption));
    if DBMemo1.CanFocus then
       DBMemo1.SetFocus;
    Abort;
  end;
  
  inherited;
end;

procedure TFrmMPSI180.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('MaxQty').AsInteger:=0;
end;

end.
