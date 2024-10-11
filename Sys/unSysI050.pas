unit unSysI050;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmSysI050 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmSysI050: TFrmSysI050;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSysI050.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='select top 100 * from sys_tabledetail'
         +' where tablename not in (select name from sysobjects where xtype=''U'') '+strFilter
         +' order by tablename,fieldname';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmSysI050.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_TableName:='sys_tabledetail';
  p_GridDesignAns:=True;

  inherited;
end;

end.
 