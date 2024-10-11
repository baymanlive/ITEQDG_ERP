unit unSysI070;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, DB, DBClient, MConnect, SConnect, Menus, ImgList,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TFrmSysI070 = class(TFrmSTDI010)
    UserId: TLabel;
    Wk_no: TLabel;
    Password: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    DBEdit11: TDBEdit;
    not_use: TDBCheckBox;
    Bevel3: TBevel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    RightA: TDBCheckBox;
    RightB: TDBCheckBox;
    RightB1: TDBCheckBox;
    RightB3: TDBCheckBox;
    RightC: TDBCheckBox;
    RightC1: TDBCheckBox;
    Coc_no: TLabel;
    DBEdit4: TDBEdit;
    RightB2: TDBCheckBox;
    RightC2: TDBCheckBox;
    RightB4: TDBCheckBox;
    RightB5: TDBCheckBox;
    DBEdit5: TDBEdit;
    username: TLabel;
    GroupBox4: TGroupBox;
    RightD: TDBCheckBox;
    RightD1: TDBCheckBox;
    RightD2: TDBCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmSysI070: TFrmSysI070;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmSysI070.RefreshDS(strFilter:string);
var
  Data:OleVariant;
begin
  if QueryBySQL('Select * From Sys_PDAUser Where Bu='+Quotedstr(g_UInfo^.BU)+strFilter, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmSysI070.FormCreate(Sender: TObject);
begin
  p_SysId:='Sys';
  p_TableName:='Sys_PDAUser';
  p_FocusCtrl:=DBEdit1;

  inherited;
end;

procedure TFrmSysI070.CDSBeforePost(DataSet: TDataSet);
begin
  if CDS.FieldByName('UserId').AsString='' then
  begin
    if DBEdit1.CanFocus then
       DBEdit1.SetFocus;
    ShowMsg('�п�J�ϥΪ̱b��!',48);
    Exit;
  end;
  if CDS.FieldByName('Wk_no').AsString='' then
  begin
    if DBEdit2.CanFocus then
       DBEdit2.SetFocus;
    ShowMsg('�п�J�ϥΪ̤u��!',48);
    Exit;
  end;
  inherited;
end;

end.
