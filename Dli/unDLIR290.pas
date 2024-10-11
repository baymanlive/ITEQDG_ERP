{*******************************************************}
{                                                       }
{                unDLIR050                              }
{                Author: kaikai                         }
{                Create date: 2015/10/13                }
{                Description: COC明細表                 }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR290;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR290 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_index:Integer;
    l_custno,l_uid:string;
    l_indate1,l_indate2:TDateTime;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;


var
  FrmDLIR290: TFrmDLIR290;

implementation

uses unGlobal, unCommon, unDLIR290_Query;

{$R *.dfm}

//5天一次查詢
//proc_DLIR290參數:公司別、出貨日期起、出貨日期迄、掃描人員、客戶編號、0:PP 1:CCL
procedure TFrmDLIR290.RefreshDS(strFilter: string);
var
  d1,d2:TDateTime;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  if strFilter=g_cFilterNothing then
  begin
    tmpSQL:='exec proc_DLIR290 ''no'',''1955-5-5'',''1955-5-5'',''@@'',''@'',0';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  end else
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      d1:=l_indate1;
      d2:=l_indate1;
      while d2<=l_indate2 do
      begin
        d2:=d1+7;
        if d2>l_indate2 then
           d2:=l_indate2;

        g_StatusBar.Panels[0].Text:=CheckLang('正在查詢:'+DateToStr(d1)+'~'+DateToStr(d2)+',請待待...');
        Application.ProcessMessages;

        Data:=null;
        tmpSQL:='exec proc_DLIR290 '+Quotedstr(g_UInfo^.BU)+','
                                    +Quotedstr(DateToStr(d1))+','
                                    +Quotedstr(DateToStr(d2))+','
                                    +Quotedstr(l_uid)+','
                                    +Quotedstr(l_custno)+','
                                    +IntToStr(l_index);
        if SameText(g_uinfo^.UserId,'ID150515') then
          ShowMessage(tmpSQL);
        if QueryBySQL(tmpSQL, Data) then
        begin
          if not VarIsNull(Data) then
          begin
            if tmpCDS.Active then
               tmpCDS.AppendData(Data,True)
            else
               tmpCDS.Data:=Data;
          end;
        end;

        d1:=d2+1;
        d2:=d1;
      end;
    
      if tmpCDS.Active then
         CDS.Data:=tmpCDS.Data;

    finally
      FreeAndNil(tmpCDS);
      g_StatusBar.Panels[0].Text:='';
    end;
  end;

  inherited;
end;

procedure TFrmDLIR290.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR290';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmDLIR290.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR290_Query) then
     FrmDLIR290_Query:=TFrmDLIR290_Query.Create(Application);
  if FrmDLIR290_Query.ShowModal=mrOK then
  begin
    l_index:=FrmDLIR290_Query.RadioGroup1.ItemIndex;
    l_indate1:=FrmDLIR290_Query.Dtp1.Date;
    l_indate2:=FrmDLIR290_Query.Dtp2.Date;
    l_custno:=Trim(FrmDLIR290_Query.Edit1.Text+'/'+FrmDLIR290_Query.Edit3.Text);
    l_uid:=Trim(FrmDLIR290_Query.Edit2.Text);
    RefreshDS('');
  end;
end;

end.
