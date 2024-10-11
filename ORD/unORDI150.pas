unit unORDI150;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DBGridEhGrouping, DB, DBClient, MConnect, SConnect,
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh,  
  unSTDI030, ADODB;
type
  TFrmORD150 = class(TFrmSTDI030)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmORD150: TFrmORD150;

implementation

uses unGlobal,unCommon;
   
{$R *.dfm}


procedure TFrmORD150.FormCreate(Sender: TObject);
begin
  p_TableName:='ORD150';
  p_DBType:=g_MSSQL;
  p_SysId:='ORD';
  p_IsBu:=True;

  inherited;
end;

end.
