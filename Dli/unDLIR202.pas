unit unDLIR202;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, unSTDI031, DBGridEhGrouping,
  ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, ImgList, DB, DBClient, GridsEh, DBAxisGridsEh, DBGridEh, StdCtrls, ExtCtrls,
  ComCtrls, ToolWin, ADODB;

type
  TFrmDLIR202 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure btn_deleteClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmDLIR202: TFrmDLIR202;

implementation

{$R *.dfm}
uses
  unGlobal, unCommon, unDLIR202_query;
{ TFrmDLIR202 }

procedure TFrmDLIR202.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin

  tmpSQL :=
    'select a.*,b.ddate from dli901 a join log002 b on a.orderno=b.dno left join dli014 c on ''JX-''+a.orderno=c.saleno where 1=1 '
    + strFilter;
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmDLIR202.FormCreate(Sender: TObject);
begin
  p_SysId := 'Dli';
  p_TableName := 'DLIR202';
  p_GridDesignAns := True;

  inherited;
end;

procedure TFrmDLIR202.btn_deleteClick(Sender: TObject);
var
  sql: string;
begin
  if ShowMsg('是否刪除單號' + cds.fieldbyname('orderno').AsString + ' ?', 36) = IdYes then
  begin
    sql := 'delete from dli901 where orderno=''%s'' delete from log002 where dno=''%s''';
    sql := format(sql, [cds.fieldbyname('orderno').AsString, cds.fieldbyname('orderno').AsString]);
    if not postbysql(sql) then
      showmsg('刪除失敗');
    RefreshDS('');
  end;
end;

procedure TFrmDLIR202.btn_queryClick(Sender: TObject);
var
  s: string;
begin
  with TFrmDLIR202_query.create(nil) do
  begin
    try
      ShowModal;
      if ModalResult = mrok then
      begin
        if checkbox2.Checked then
          s := s + ' and c.Bu is null '
        else
          s := ' and b.ddate between ' + Quotedstr(datetostr(dtp1.Date)) + ' and ' + Quotedstr(datetostr(dtp2.Date + 1));

        if saleno.Text<>'' then
          s := s + ' and a.orderno like'+quotedstr('%'+trim(saleno.text)+'%');
        RefreshDS(s);  
      end;
    finally
      free;
    end;
  end;
end;

end.

