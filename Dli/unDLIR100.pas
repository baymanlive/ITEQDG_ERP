{*******************************************************}
{                                                       }
{                unDLIR100                              }
{                Author: kaikai                         }
{                Create date: 2016/7/18                 }
{                Description: 出貨批號查詢              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR100;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, DateUtils;

type
  TFrmDLIR100 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_oradb:string;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR100: TFrmDLIR100;

implementation

uses unGlobal, unCommon, unDLIR100_Query;

{$R *.dfm}

procedure TFrmDLIR100.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  g_StatusBar.Panels[0].Text:=CheckLang('正在查詢...');
  Application.ProcessMessages;
  if strFilter=g_cFilterNothing then
  begin
    tmpSQL:='Select bu lot,bu saleno,bu saleitem,bu saledate,bu custno,'
           +' bu custshort,bu orderno,bu orderitem,bu pno,'
           +' bu pname,bu sizes,bu qty,bu units From sys_bu Where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end else
  begin
    tmpSQL:='Select X.ogb092 lot,X.ogb01 saleno,X.ogb03 saleitem,'
           +'       X.oga02 saledate,X.oga04 custno,Y.occ02 custshort,'
           +'       X.ogb31 orderno,X.ogb32 orderitem,X.ogb04 pno,'
           +'       X.ima02 pname,X.ima021 sizes,X.ogb12 qty,X.ogb05 units From'
           +' (Select E.*,F.ima02,ima021 From'
           +' (Select C.*,D.oga02,D.oga04 From'
           +' (Select A.ogb01,A.ogb03,A.ogb04,A.ogb05,A.ogb12,A.ogb31,A.ogb32,B.ogb092 From '+l_oradb+'.ogb_file A'
           +' inner join (Select ogb01,ogb03,ogb092 From '+l_oradb+'.ogb_file'
           +'            Where ogb17=''N'' and ogb092 in ('+strFilter+')'
           +'            Union All'
           +'            Select ogc01,ogc03,ogc092 From '+l_oradb+'.ogc_file'
           +'            Where ogc092 in ('+strFilter+')) B on A.ogb01=B.ogb01 and A.ogb03=B.ogb03) C'
           +' inner join '+l_oradb+'.oga_file D on C.ogb01=D.oga01) E'
           +' inner join '+l_oradb+'.ima_file F on E.ogb04=F.ima01) X'
           +' inner join '+l_oradb+'.occ_file Y on X.oga04=Y.occ01'
           +' Order By X.ogb092,X.ogb01,X.ogb03';
    if QueryBySQL(tmpSQL, Data, 'ORACLE') then
       CDS.Data:=Data;
  end;
  g_StatusBar.Panels[0].Text:='';

  inherited;
end;

procedure TFrmDLIR100.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR100';
  p_GridDesignAns:=True;
  l_oradb:=g_UInfo^.BU;

  inherited;
end;

procedure TFrmDLIR100.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR100_Query) then
     FrmDLIR100_Query:=TFrmDLIR100_Query.Create(Application);
  if FrmDLIR100_Query.ShowModal=mrOK then
  begin
    l_oradb:=FrmDLIR100_Query.rgp.Items.Strings[FrmDLIR100_Query.rgp.ItemIndex];
    RefreshDS(FrmDLIR100_Query.l_lot);
  end;
end;

end.
