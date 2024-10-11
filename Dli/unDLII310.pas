{*******************************************************}
{                                                       }
{                unDLII310                              }
{                Author: kaikai                         }
{                Create date: 2015/7/17                 }
{                Description: 特殊項目                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII310;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI010, ExtCtrls, DB, DBClient, Menus,
  ImgList, StdCtrls, Buttons, ComCtrls, ToolWin, Mask, DBCtrls;

type
  TFrmDLII310 = class(TFrmSTDI010)
    GroupBox2: TGroupBox;
    Label32: TLabel;
    DBEdit2: TDBEdit;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    DBEdit9: TDBEdit;
    DBEdit10: TDBEdit;
    Label13: TLabel;
    Label14: TLabel;
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    DBEdit11: TDBEdit;
    DBEdit12: TDBEdit;
    DBEdit13: TDBEdit;
    Label21: TLabel;
    DBEdit14: TDBEdit;
    DBEdit15: TDBEdit;
    DBEdit16: TDBEdit;
    Label22: TLabel;
    Label23: TLabel;
    GroupBox5: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    DBEdit17: TDBEdit;
    DBEdit18: TDBEdit;
    DBEdit19: TDBEdit;
    DBEdit20: TDBEdit;
    Iuser: TLabel;
    Idate: TLabel;
    Muser: TLabel;
    Mdate: TLabel;
    DBEdit21: TDBEdit;
    DBEdit22: TDBEdit;
    DBEdit23: TDBEdit;
    DBEdit24: TDBEdit;
    GroupBox6: TGroupBox;
    Label26: TLabel;
    Label33: TLabel;
    DBEdit25: TDBEdit;
    Label34: TLabel;
    DBEdit26: TDBEdit;
    Label35: TLabel;
    Label36: TLabel;
    DBEdit27: TDBEdit;
    Label37: TLabel;
    DBEdit28: TDBEdit;
    DBEdit29: TDBEdit;
    DBEdit30: TDBEdit;
    Label31: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    Label710: TLabel;
    Label71: TLabel;
    Label72: TLabel;
    DBEdit1: TDBEdit;
    DBEdit5: TDBEdit;
    Label730: TLabel;
    Label73: TLabel;
    Label74: TLabel;
    DBEdit6: TDBEdit;
    DBEdit31: TDBEdit;
    Label750: TLabel;
    Label75: TLabel;
    Label76: TLabel;
    DBEdit32: TDBEdit;
    DBEdit33: TDBEdit;
    Label1: TLabel;
    DBEdit34: TDBEdit;
    DBEdit35: TDBEdit;
    Label78: TLabel;
    Label77: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII310: TFrmDLII310;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII310.SetToolBar;
begin
  inherited;
  btn_insert.Visible:=False;
  btn_delete.Visible:=False;
  btn_copy.Visible:=False;
end;

procedure TFrmDLII310.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From Dli310 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII310.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='Dli310';
  p_FocusCtrl:=DBEdit2;    //value11未用

  inherited;
  Label1.Caption := CheckLang('20mil≦條數≦120mil 膠系U');
  Label3.Caption:=CheckLang('AC109    12mil<條數≦15mil    (尺安參數未設定時)');
  Label4.Caption:=CheckLang('AC394/AC152/AH036/AC844/AC109    條數<=12mil    3oz~7oz');
  Label5.Caption:=CheckLang('AC394/AC844/AC152/AH036    12mil<條數≦20mil');
  Label6.Caption:=CheckLang('經：');
  Label7.Caption:=CheckLang('緯：');
  Label10.Caption:=Label6.Caption;
  Label11.Caption:=Label7.Caption;
  Label12.Caption:=CheckLang('銅厚=PP    條數≦12mil');
  Label13.Caption:=Label6.Caption;
  Label14.Caption:=Label7.Caption;
  Label15.Caption:=CheckLang('AC143/AC097    膠系=1    LCA訂單');
  Label16.Caption:=CheckLang('AC148/AC347    條數<20mil');
  Label17.Caption:=CheckLang('AC148/AC347    條數≧20mil');
  Label18.Caption:=CheckLang('規格要求：');
  Label19.Caption:=CheckLang('測試值：');
  Label20.Caption:=Label18.Caption;
  Label21.Caption:=Label19.Caption;
  Label22.Caption:=Label18.Caption;
  Label23.Caption:=Label19.Caption;
  Label24.Caption:=CheckLang('<20mil 膠系S U');
  Label25.Caption:=CheckLang('20mil≦條數≦120mil 膠系S');
  Label27.Caption:=Label18.Caption;
  Label28.Caption:=Label19.Caption;
  Label29.Caption:=Label18.Caption;
  Label30.Caption:=Label19.Caption;
  Label77.Caption:=Label18.Caption;
  Label78.Caption:=Label19.Caption;
  Label32.Caption:=Label19.Caption;
  Label26.Caption:=CheckLang('條數<20mil');
  Label35.Caption:=CheckLang('條數≧20mil');
  Label33.Caption:=Label18.Caption;
  Label34.Caption:=Label19.Caption;
  Label36.Caption:=Label18.Caption;
  Label37.Caption:=Label19.Caption;
  Label31.Caption:='RTF';

  Label710.Caption:=CheckLang('銅厚=1oz');
  Label730.Caption:=CheckLang('銅厚=2oz');
  Label750.Caption:=CheckLang('銅厚=Hoz');
  Label71.Caption:=Label18.Caption;
  Label72.Caption:=Label19.Caption;
  Label73.Caption:=Label18.Caption;
  Label74.Caption:=Label19.Caption;
  Label75.Caption:=Label18.Caption;
  Label76.Caption:=Label19.Caption;
end;

procedure TFrmDLII310.btn_queryClick(Sender: TObject);
begin
  //inherited;
  RefreshDS('');
end;

end.
