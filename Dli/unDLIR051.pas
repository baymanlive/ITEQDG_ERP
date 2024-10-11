{*******************************************************}
{                                                       }
{                unDLIR051                              }
{                Author: kaikai                         }
{                Create date: 2020/03/26                }
{                Description: COC客戶二維碼明細表       }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR051;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR051 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_indate1,l_indate2:TDateTime;
    l_custno:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR051: TFrmDLIR051;

implementation

uses unGlobal, unCommon, unDLIR051_Query;

{$R *.dfm}


procedure TFrmDLIR051.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if l_custno='@' then
  begin
    tmpSQL:='select custno,fdate,ftime,qrcode1,qrcode2,iuser from dli641 where 1=2';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end else
  begin
    tmpSQL:='select custno,idate,qrcode1,qrcode2,iuser'
           +' from dli641'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and charindex(custno,'+Quotedstr(l_custno)+')>0'
           +' and idate between '+Quotedstr(DateToStr(l_indate1))+' and '+Quotedstr(DateToStr(l_indate2+1))
           +' union all'
           +' select custno,idate,qrcode1,qrcode2,iuser'
           +' from dli641_bak'
           +' where bu='+Quotedstr(g_UInfo^.BU)
           +' and charindex(custno,'+Quotedstr(l_custno)+')>0'
           +' and idate between '+Quotedstr(DateToStr(l_indate1))+' and '+Quotedstr(DateToStr(l_indate2+1))
           +' order by custno,idate';

    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end;
//     if SameText('id150515',g_uinfo^.UserId)
//     then
//     ShowMessage(tmpSQL);
  inherited;
end;

procedure TFrmDLIR051.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR051';
  p_GridDesignAns:=True;
  l_custno:='@';

  inherited;
end;

procedure TFrmDLIR051.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR051_Query) then
     FrmDLIR051_Query:=TFrmDLIR051_Query.Create(Application);
  if FrmDLIR051_Query.ShowModal=mrOK then
  begin
    l_indate1:=FrmDLIR051_Query.Dtp1.Date;
    l_indate2:=FrmDLIR051_Query.Dtp2.Date;
    l_custno:=StringReplace(Trim(FrmDLIR051_Query.Edit1.Text),'''','',[rfReplaceAll]);
    RefreshDS('');
  end;
end;

end.
