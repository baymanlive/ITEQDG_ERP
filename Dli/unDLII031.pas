{*******************************************************}
{                                                       }
{                unDLII031                              }
{                Author: kaikai                         }
{                Create date: 2021/8/5                  }
{                Description: µo®ÆÀË¬d                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII031;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh,
  StdCtrls, ExtCtrls, ComCtrls, ToolWin;

type
  TFrmDLII031 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII031: TFrmDLII031;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

{ TFrmDLII031 }

procedure TFrmDLII031.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI031 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' and isnull(not_use,0)=0 order by id,sno';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
     
  inherited;
end;

procedure TFrmDLII031.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI031';
  p_GridDesignAns:=True;

  inherited;
end;

end.
