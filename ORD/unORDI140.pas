unit unORDI140;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI030, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ExtCtrls, DB, DBClient, MConnect, SConnect, Menus, ImgList,
  StdCtrls, Buttons, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

type
  TFrmORDI140 = class(TFrmSTDI030)
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    
  end;

var
  FrmORDI140: TFrmORDI140;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmORDI140.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  cds.FieldByName('allcust').asboolean:=false;
  cds.FieldByName('bu').asboolean:='ITEQDG';
end;

procedure TFrmORDI140.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD140';
  p_DBType:=g_MSSQL;
  p_SysId:='Ord';
  p_IsBu:=True;

  inherited;
end;

end.
