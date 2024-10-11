unit unDLIT801_area;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, GridsEh, DBAxisGridsEh, DBGridEh, ImgList, StdCtrls, Buttons,
  ExtCtrls, DB, DBClient;

type
  TFrmDLIT801_area = class(TFrmSTDI051)
    DBGridEh1: TDBGridEh;
    CDS: TClientDataSet;
    DS: TDataSource;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    l_fdate:TDateTime;
    { Public declarations }
  end;

var
  FrmDLIT801_area: TFrmDLIT801_area;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLIT801_area.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1,'dli801');
end;

procedure TFrmDLIT801_area.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  tmpSQL:='select distinct area from dli801'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and fdate='+Quotedstr(DateToStr(l_fdate));
  if QueryBySQL(tmpSQL,Data) then
     CDS.Data:=Data;
end;

procedure TFrmDLIT801_area.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

end.
