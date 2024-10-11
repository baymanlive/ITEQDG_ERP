{*******************************************************}
{                                                       }
{                unMPSI400                              }
{                Author: kaikai                         }
{                Create date: 2019/9/19                 }
{                Description: 庫存與未交狀況裁檢備注    }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI400;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI400 = class(TFrmSTDI031)
    btn_mpsi400: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_mpsi400Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI400: TFrmMPSI400;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI400.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS400 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI400.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS400';
  p_GridDesignAns:=True;
  btn_mpsi400.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmMPSI400.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('pno').AsString))=0 then
     ShowM('pno');
  if Length(Trim(CDS.FieldByName('lot').AsString))=0 then
     ShowM('lot');
  inherited;
end;

procedure TFrmMPSI400.btn_mpsi400Click(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active and (not CDS.IsEmpty) then
     str:=CDS.FieldByName('pno').AsString;
  GetQueryStock(str, False);
end;

end.
