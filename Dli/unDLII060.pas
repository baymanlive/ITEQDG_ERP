{*******************************************************}
{                                                       }
{                unDLII060                              }
{                Author: kaikai                         }
{                Create date: 2015/7/3                  }
{                Description: 剝離強度                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII060;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII060 = class(TFrmSTDI031)
    btn_import: TToolButton;
    btn_dlii060: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_importClick(Sender: TObject);
    procedure btn_dlii060Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII060: TFrmDLII060;

implementation

uses unGlobal,unCommon, unDLII060_set;
   
{$R *.dfm}

procedure TFrmDLII060.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI060 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By custno,strip_lower,strip_upper,adhesive,copper,id';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII060.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI060';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('[銅厚]欄位@:RTF &:RTF2 #:VLP [@1:銅厚1 &1:RTF2銅厚1]');
  btn_quit.Left:=btn_import.Left+btn_import.Width;
  btn_import.Visible:=g_MInfo^.R_edit;

  inherited;
end;

procedure TFrmDLII060.CDSBeforePost(DataSet: TDataSet);
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
  if Length(Trim(CDS.FieldByName('Strip_lower').AsString))=0 then
     ShowM('Strip_lower');
  if Length(Trim(CDS.FieldByName('Strip_upper').AsString))=0 then
     ShowM('Strip_upper');
  if Length(Trim(CDS.FieldByName('Adhesive').AsString))=0 then
     ShowM('Adhesive');
  if Length(Trim(CDS.FieldByName('Copper').AsString))=0 then
     ShowM('Copper');
  if Length(Trim(CDS.FieldByName('materi_tail').AsString))=0 then
     ShowM('materi_tail');

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

procedure TFrmDLII060.btn_importClick(Sender: TObject);
begin
  inherited;
  XlsImport(p_TableName, CDS, DBGridEh1);
end;

procedure TFrmDLII060.btn_dlii060Click(Sender: TObject);
begin
  inherited;
  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,你沒有此操作權限!',48);
    Exit;
  end;

  if not Assigned(FrmDLII060_set) then
     FrmDLII060_set:=TFrmDLII060_set.Create(Application);
  FrmDLII060_set.ShowModal;
end;

end.
