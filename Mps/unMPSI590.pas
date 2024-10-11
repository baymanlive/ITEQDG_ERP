{*******************************************************}
{                                                       }
{                unMPSI590                              }
{                Author: kaikai                         }
{                Create date: 2017/04/27                }
{                Description: 布种大小                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI590;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI590 = class(TFrmSTDI031)
    btn_mpsi590: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_mpsi590Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
    { Public declarations }
  end;

var
  FrmMPSI590: TFrmMPSI590;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI590.SetToolBar;
begin
  btn_mpsi590.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPSI590.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS590 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
        +' Order By Sno,Fi';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI590.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS590';
  p_GridDesignAns:=True;
  btn_mpsi590.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_mpsi590.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmMPSI590.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('fi').AsString))=0 then
     ShowM('fi');

  if CDS.FieldByName('sno').AsInteger<=0 then
     ShowM('sno');

  inherited;
end;

procedure TFrmMPSI590.btn_mpsi590Click(Sender: TObject);
var
  tmpStr:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  inherited;
  if ShowMsg('確定更新排程布種順序嗎?', 33)=IdCancel then
     Exit;
  tmpStr:='Select Fi,Sno From MPS590 Where Bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL( tmpStr, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.IsEmpty then
    begin
      ShowMsg('設定無資料!', 48);
      Exit;
    end;

    while not tmpCDS.Eof do
    begin
      tmpStr:=tmpCDS.Fields[0].AsString;
      if tmpStr='3313' then //3313<=>2313
         tmpStr:='2313a';
      tmpStr:='Update MPS070 Set FiSno='+IntToStr(tmpCDS.Fields[1].AsInteger)
             +' Where Bu='+Quotedstr(g_UInfo^.BU)
             +' And Fi='+Quotedstr(tmpStr)
             +' And Sdate>getdate()-1'
             +' And IsNull(FiSno,0)<>'+IntToStr(tmpCDS.Fields[1].AsInteger);
      if not PostBySQL(tmpStr) then
         Exit;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
  ShowMsg('更新完畢!', 64);
end;

end.
