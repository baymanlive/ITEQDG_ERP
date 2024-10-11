{*******************************************************}
{                                                       }
{                unMPSR060                              }
{                Author: kaikai                         }
{                Create date: 2015/10/10                }
{                Description: 客戶群產能統計表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR110;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmMPSR110 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_queryClick(Sender: TObject);
  private
    l_sdate:TDateTime;
    l_custno,l_ad,l_thinkness1,l_thinkness2:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR110: TFrmMPSR110;

implementation

uses unGlobal, unCommon, unMPSR110_Query;

{$R *.dfm}

procedure TFrmMPSR110.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='exec dbo.proc_MPSR110X '+Quotedstr(g_UInfo^.BU)+','
                                   +Quotedstr(DateToStr(l_sdate))+','
                                   +Quotedstr(l_custno)+','
                                   +Quotedstr(l_ad)+','
                                   +Quotedstr(l_thinkness1)+','
                                   +Quotedstr(l_thinkness2);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSR110.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR110';
  p_GridDesignAns:=True;
  l_sdate:=EncodeDate(2000,1,1);
  l_custno:='@';
  l_ad:='@';

  inherited;
end;

procedure TFrmMPSR110.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR110_Query) then
     FrmMPSR110_Query:=TFrmMPSR110_Query.Create(Application);
  if FrmMPSR110_Query.ShowModal<>mrOK then
     Exit;

  l_sdate:=FrmMPSR110_Query.dtp.Date;
  l_custno:=Trim(FrmMPSR110_Query.Edit1.Text);
  l_ad:=Trim(FrmMPSR110_Query.Edit2.Text);
  l_thinkness1:=Trim(FrmMPSR110_Query.Edit3.Text);
  l_thinkness2:=Trim(FrmMPSR110_Query.Edit4.Text);
  RefreshDS('');
end;

procedure TFrmMPSR110.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if SameText(Column.FieldName,'diff') and (CDS.FieldByName('diff').AsFloat>0) then
     AFont.Color:=clRed;
end;

end.
