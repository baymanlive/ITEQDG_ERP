{*******************************************************}
{                                                       }
{                unDLIR080_detail                       }
{                Author: kaikai                         }
{                Create date: 2016/7/15                 }
{                Description: ¥X³f³æ©ú²Ó                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR080_detail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, DB, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls,
  Buttons, ExtCtrls, DBCLient;

type
  TFrmDLIR080_detail = class(TFrmSTDI051)
    DS1: TDataSource;
    DBGridEh1: TDBGridEh;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
  public
    { Public declarations }
    l_oga01:string;
  end;

var
  FrmDLIR080_detail: TFrmDLIR080_detail;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIR080_detail.FormCreate(Sender: TObject);
begin
  inherited;
  btn_quit.Top:=btn_ok.Top;
  btn_ok.Visible:=False;
  SetGrdCaption(DBGridEh1, 'DLIR080_detail');
  l_CDS:=TClientDataSet.Create(Self);
  DS1.DataSet:=l_CDS;
end;
 
procedure TFrmDLIR080_detail.FormShow(Sender: TObject);
var
  Data:OleVariant;
  tmpSQL:string;
begin
  inherited;
  tmpSQL:='select C.*,D.oea10 from'
         +' (select A.*,B.oeb11,B.ta_oeb10 from'
         +' (select ogb03,ogb04,ogb05,ogb06,ogb12,ogb31,ogb32'
         +' from ogb_file where ogb01='+Quotedstr(l_oga01)+') A,oeb_file B'
         +' where A.ogb31=B.oeb01 and A.ogb32=B.oeb03) C,oea_file D'
         +' where C.ogb31=D.oea01'
         +' order by ogb03';
  if SameText(g_UInfo^.BU,'ITEQDG') then
  begin
    if QueryBySQL(tmpSQL, Data, 'ORACLE') then
       l_CDS.Data:=Data;
  end else
  begin
    if QueryBySQL(tmpSQL, Data, 'ORACLE1') then
       l_CDS.Data:=Data;
  end;
end;

procedure TFrmDLIR080_detail.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
  DBGridEh1.Free;
end;

end.
