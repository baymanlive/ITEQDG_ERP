unit unDLIT801_fdate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmDLIT801_fdate = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLIT801_fdate: TFrmDLIT801_fdate;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIT801_fdate.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetGrdCaption(DBGridEh1,'dli801');
  tmpSQL:='select distinct top 30 fdate from dli801'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' order by fdate desc';
  if QueryBySQL(tmpSQL,Data) then
     CDS.Data:=Data;
end;

procedure TFrmDLIT801_fdate.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

end.
