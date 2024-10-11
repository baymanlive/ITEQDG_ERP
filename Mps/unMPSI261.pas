{*******************************************************}
{                                                       }
{                unMPSI260                              }
{                Author: terry                          }
{                Create date: 2015/12/7                 }
{                Description: 缺交資料明細設定          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI261;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI261 = class(TFrmSTDI031)
    btn_mpsi260: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_mpsi260Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI261: TFrmMPSI261;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI261.SetToolBar;
begin
  btn_mpsi260.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPSI261.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS260 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' And IsNull(IsDG,0)=0 Order By Custno,Adhesive,Fiber,Code3,LastCode3,TailNo,Vendor';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI261.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS260';
  p_GridDesignAns:=True;
  btn_mpsi260.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_mpsi260.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmMPSI261.CDSNewRecord(DataSet: TDataSet);
var
  i:Integer;
begin
  for i:=0 to DataSet.FieldCount -1 do
  if DataSet.Fields[i].DataType in [ftString,ftWideString] then
  if DataSet.Fields[i].IsNull then
     DataSet.Fields[i].AsString:='*';
  inherited;
end;

procedure TFrmMPSI261.CDSBeforePost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;

  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
     ShowM('Custno');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('Fiber').AsString))=0 then
     ShowM('Fiber');
  if Length(Trim(CDS.FieldByName('Code3').AsString))=0 then
     ShowM('Code3');
  if Length(Trim(CDS.FieldByName('LastCode3').AsString))=0 then
     ShowM('LastCode3');
  if Length(Trim(CDS.FieldByName('TailNo').AsString))=0 then
     ShowM('TailNo');
  if Length(Trim(CDS.FieldByName('Vendor').AsString))=0 then
     ShowM('Vendor');
  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;

  inherited;
end;

procedure TFrmMPSI261.btn_mpsi260Click(Sender: TObject);
var
  dsNE:TDataSetNotifyEvent;
begin
  inherited;
  with CDS do
  begin
    if (not Active) or IsEmpty then
       ShowMsg('無數據,不可操作!',48)
    else begin
      dsNE:=BeforePost;
      try
        Edit;
        if FieldByName('ColorFlag').AsInteger=1 then
           FieldByName('ColorFlag').Clear
        else
           FieldByName('ColorFlag').AsInteger:=1;
        Post;
      finally
        BeforePost:=dsNE;
      end;
    end;
  end;
end;

procedure TFrmMPSI261.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) and SameText(Column.FieldName, 'Fiber') and
     (CDS.FieldByName('ColorFlag').AsInteger=1) then
     Background:=clYellow;
end;

end.
