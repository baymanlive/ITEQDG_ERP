{*******************************************************}
{                                                       }
{                unDLIR040                              }
{                Author: kaikai                         }
{                Create date: 2015/10/7                 }
{                Description: 已檢貨明細表              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR040;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR040 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_queryClick(Sender: TObject);
  private
    l_index{0:pp 1:ccl 2:all},
    l_index2{0:已出貨,1:未出貨,2:all}:Integer;
    l_saleno,l_orderno:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR040: TFrmDLIR040;

implementation

uses unGlobal, unCommon, unDLIR040_Query;

{$R *.dfm}

procedure TFrmDLIR040.RefreshDS(strFilter: string);
var
  i:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  //參數:公司別、銷貨日期、銷貨單號、0:PP 1:CCL
  if strFilter=g_cFilterNothing then
     strFilter:='1955/1/1';
  tmpSQL:='exec proc_DLIR040 '+Quotedstr(g_UInfo^.BU)+','
                              +Quotedstr(strFilter)+','
                              +Quotedstr(l_saleno)+','
                              +Quotedstr(l_orderno)+','
                              +IntToStr(l_index);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpSQL:='@';
    CDS.Data:=Data;
    with CDS do
    begin
      DisableControls;
      while not Eof do
      begin
        if tmpSQL=FieldByName('Dno').AsString+'@'+FieldByName('Ditem').AsString then
        begin
          Edit;
          for i:=0 to FieldCount-1 do
            if Pos(LowerCase(Fields[i].FieldName), 'dno,ditem,stkplace,stkarea,manfac,qty,sflag,jflag')=0 then
               Fields[i].Clear;
          Post;
        end;
        tmpSQL:=FieldByName('Dno').AsString+'@'+FieldByName('Ditem').AsString;
        Next;
      end;
      if ChangeCount>0 then
         MergeChangeLog;
      First;
      EnableControls;   
    end;
  end;

  case l_index2 of
    0: CDS.Filter :='delcount>0';
    1: CDS.Filter :='delcount=0';
    2: CDS.Filter :=EmptyStr;
  end;
  CDS.Filtered := true;

  inherited;
end;

procedure TFrmDLIR040.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR040';
  p_GridDesignAns:=True;
  l_index:=2;
  l_index2:=2;
  l_saleno:='@';
  l_orderno:='@';

  inherited;
end;

procedure TFrmDLIR040.btn_queryClick(Sender: TObject);
begin
  //inherited;
  if not Assigned(FrmDLIR040_Query) then
     FrmDLIR040_Query:=TFrmDLIR040_Query.Create(Application);
  if FrmDLIR040_Query.ShowModal=mrOK then
  begin
    l_index:=FrmDLIR040_Query.RadioGroup1.ItemIndex;
    l_index2:=FrmDLIR040_Query.RadioGroup2.ItemIndex;
    l_saleno:=Trim(FrmDLIR040_Query.Edit1.Text);
    l_orderno:=Trim(FrmDLIR040_Query.Edit2.Text);
    RefreshDS(DateToStr(FrmDLIR040_Query.Dtp.Date));
  end;
end;

procedure TFrmDLIR040.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if Length(Trim(CDS.FieldByName('Dno_Ditem').AsString))>0 then  //拆單
     AFont.Color:=clBlue;
end;

end.
