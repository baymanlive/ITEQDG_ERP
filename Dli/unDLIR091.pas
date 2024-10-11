{*******************************************************}
{                                                       }
{                unDLIR091                              }
{                Author: kaikai                         }
{                Create date: 2015/10/13                }
{                Description: 出貨明細表(批號)          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR091;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, Math;

type
  TFrmDLIR091 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_indate1,l_indate2,l_custno,l_lot:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;


var
  FrmDLIR091: TFrmDLIR091;

implementation

uses unGlobal, unCommon, unDLIR091_Query;

{$R *.dfm}


procedure TFrmDLIR091.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  //參數:公司別、出貨日期起、出貨日期迄、客戶編號、批號
  tmpSQL:='exec proc_DLIR091 '+Quotedstr(g_UInfo^.BU)+','
                              +Quotedstr(l_indate1)+','
                              +Quotedstr(l_indate2)+','
                              +Quotedstr(l_custno)+','
                              +Quotedstr(l_lot);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
     
  inherited;
end;

procedure TFrmDLIR091.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR091';
  p_GridDesignAns:=True;
  l_indate1:='1955/5/5';
  l_indate2:=l_indate1;
  l_custno:='@@';
  l_lot:='@@';

  inherited;
end;

procedure TFrmDLIR091.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR091_Query) then
     FrmDLIR091_Query:=TFrmDLIR091_Query.Create(Application);
  if FrmDLIR091_Query.ShowModal=mrOK then
  begin
    l_indate1:=DateToStr(FrmDLIR091_Query.Dtp1.Date);
    l_indate2:=DateToStr(FrmDLIR091_Query.Dtp2.Date);
    l_custno:=Trim(FrmDLIR091_Query.Edit1.Text+'/'+FrmDLIR091_Query.Edit3.Text);
    l_lot:=Trim(FrmDLIR091_Query.Edit2.Text);
    RefreshDS('');
  end;
end;

end.
