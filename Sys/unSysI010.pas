unit unSysI010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, Mask, DBCtrls, DB, ADODB, ImgList, ComCtrls,
  StdCtrls, ExtCtrls, ToolWin, DBClient;

type
  TFrmSysI010 = class(TFrmSTDI010)
    Bu: TLabel;
    ShortName: TLabel;
    Cname: TLabel;
    Ename: TLabel;
    Address: TLabel;
    Tel: TLabel;
    Fax: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    DBEdit7: TDBEdit;
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;    
  end;

var
  FrmSysI010: TFrmSysI010;

implementation

uses unCommon;

{$R *.dfm}

procedure TFrmSysI010.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_TableName:='Sys_Bu';
  p_FocusCtrl:=DBEdit1;
  inherited;
end;

procedure TFrmSysI010.RefreshDS(strFilter:string);
var
  Data:OleVariant;
begin
  if QueryBySQL('Select * From Sys_Bu Where 1=1 '+strFilter, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmSysI010.CDSBeforePost(DataSet: TDataSet);
begin
  if Trim(CDS.FieldByName('Bu').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(Bu.Caption));
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('ShortName').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(ShortName.Caption));
    if DBEdit2.CanFocus then
       DBEdit2.SetFocus;
    Abort;
  end;
  if Trim(CDS.FieldByName('Cname').AsString)='' then
  begin
    ShowMsg('請輸入[%s]!',48,myStringReplace(Cname.Caption));
    if DBEdit3.CanFocus then
       DBEdit3.SetFocus;
    Abort;
  end;
  
  inherited;
end;

end.
