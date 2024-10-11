{*******************************************************}
{                                                       }
{                unDLII080                              }
{                Author: kaikai                         }
{                Create date: 2020/9/2                  }
{                Description: HDI庫存管理報表參數       }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII080;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII080 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII080: TFrmDLII080;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII080.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI080 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII080.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI080';
  p_GridDesignAns:=True;
  
  inherited;
end;

end.
