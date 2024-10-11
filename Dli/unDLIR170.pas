{*******************************************************}
{                                                       }
{                unDLIR170                              }
{                Author: kaikai                         }
{                Create date: 2018/10/8                 }
{                Description: 出貨單明細表axmr620dg     }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR170;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR170 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_oradb:string;
    l_d1,l_d2:TDateTime;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR170: TFrmDLIR170;

implementation

uses unGlobal, unCommon, unDLIR170_Query;

{$R *.dfm}

procedure TFrmDLIR170.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR170';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLIR170.RefreshDS(strFilter: string);
var
  d1,d2:TDateTime;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  if strFilter=g_cFilterNothing then
  begin
    tmpSQL:='exec [dbo].[proc_DLIR170] ''no'',''1955-5-5'',''1955-5-5''';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end else
  begin
    //10天一次查詢
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=CDS.Data;
      tmpCDS.EmptyDataSet;

      d1:=l_d1;
      d2:=l_d1;
      while d2<=l_d2 do
      begin
        d2:=d1+9;
        if d2>l_d2 then
           d2:=l_d2;

        g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+DateToStr(d1)+'~'+DateToStr(d2)+',請待待...');
        Application.ProcessMessages;
        
        Data:=null;
        tmpSQL:='exec [dbo].[proc_DLIR170] '+Quotedstr(l_oradb)+','+Quotedstr(DateToStr(d1))+','+Quotedstr(DateToStr(d2));
        if QueryBySQL(tmpSQL, Data) then
        if Data<>null then
           tmpCDS.AppendData(Data,True);

        d1:=d2+1;
        d2:=d1;
      end;
      CDS.Data:=tmpCDS.Data;
    finally
      FreeAndNil(tmpCDS);
      g_StatusBar.Panels[0].Text:='';
    end;
  end;
  
  inherited;
end;

procedure TFrmDLIR170.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR170_Query) then
     FrmDLIR170_Query:=TFrmDLIR170_Query.Create(Application);
  if FrmDLIR170_Query.ShowModal=mrOK then
  begin
    l_oradb:=FrmDLIR170_Query.rgp.Items.Strings[FrmDLIR170_Query.rgp.ItemIndex];
    l_d1:=FrmDLIR170_Query.dtp1.Date;
    l_d2:=FrmDLIR170_Query.dtp2.Date;
    if l_d2>Date then
       l_d2:=Date;
    RefreshDS('1');
  end;
end;

end.
