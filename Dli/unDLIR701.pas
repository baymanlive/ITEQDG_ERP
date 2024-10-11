{*******************************************************}
{                                                       }
{                unDLIR090                              }
{                Author: kaikai                         }
{                Create date: 2016/7/18                 }
{                Description: 出貨單簽收明細表          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR701;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR701 = class(TFrmSTDI041)
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_custno:string;
    l_d1,l_d2:TDateTime;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR701: TFrmDLIR701;

implementation

uses unGlobal, unCommon, unDLIR701_Query;

{$R *.dfm}

procedure TFrmDLIR701.RefreshDS(strFilter: string);
var
  pos1:Integer;
  tmpSQL,cnt1,cnt2,cnt3,cnt4:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  cnt1:='0';
  cnt2:='0';
  cnt3:='0';
  cnt4:='0';
  if strFilter=g_cFilterNothing then
  begin
    tmpSQL:='exec [dbo].[proc_DLIR701] ''no'',''no'',''1955-5-5'',''1955-5-5''';
    if QueryBySQL(tmpSQL, Data) then
    begin
      CDS.Data:=Data;
      CDS.EmptyDataSet;
    end;
  end else
  begin
    tmpSQL:='exec [dbo].[proc_DLIR701] '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(l_custno)+','+Quotedstr(DateToStr(l_d1))+','+Quotedstr(DateToStr(l_d2));
    if QueryBySQL(tmpSQL, Data) then
    begin
       tmpCDS:=TClientDataSet.Create(nil);
       try
          tmpCDS.Data:=Data;
          if not tmpCDS.IsEmpty then
          begin
            tmpCDS.Last;

            tmpSQL:=tmpCDS.FieldByName('lot').AsString;
            pos1:=Pos(',',tmpSQL);
            cnt1:=Copy(tmpSQL,1,pos1-1);
            tmpSQL:=Copy(tmpSQL,pos1+1,30);

            pos1:=Pos(',',tmpSQL);
            cnt2:=Copy(tmpSQL,1,pos1-1);
            tmpSQL:=Copy(tmpSQL,pos1+1,30);

            pos1:=Pos(',',tmpSQL);
            cnt3:=Copy(tmpSQL,1,pos1-1);
            cnt4:=Copy(tmpSQL,pos1+1,30);

            tmpCDS.Delete;
            tmpCDS.MergeChangeLog;
          end;
          CDS.Data:=tmpCDS.Data;
       finally
        FreeAndNil(tmpCDS);
       end;
    end;
  end;

  Label3.Caption:=CheckLang('上期出貨:'+cnt1+'    上期回收:'+cnt2+'    本期出貨:'+cnt3+'    本期回收:'+cnt4+'    客戶端存量:'+IntToStr(StrToInt(cnt1)+StrToInt(cnt3)-StrToInt(cnt2)-StrToInt(cnt4)));

  inherited;
end;

procedure TFrmDLIR701.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR701';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLIR701.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR701_Query) then
     FrmDLIR701_Query:=TFrmDLIR701_Query.Create(Application);
  if FrmDLIR701_Query.ShowModal<>mrOK then
     Exit;

  l_custno:=Trim(FrmDLIR701_Query.Edit1.Text);
  l_d1:=FrmDLIR701_Query.dtp1.Date;
  l_d2:=FrmDLIR701_Query.dtp2.Date;
  RefreshDS('1');
end;

end.
