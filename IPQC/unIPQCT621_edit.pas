unit unIPQCT621_edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, Mask, DBCtrls, DB,
  DBCtrlsEh;

type
  TFrmIPQCT621_edit = class(TFrmSTDI051)
    ad: TLabel;
    DBEdit1: TDBEdit;
    ver: TLabel;
    DBEdit2: TDBEdit;
    lot: TLabel;
    DBEdit3: TDBEdit;
    qty: TLabel;
    DBEdit4: TDBEdit;
    c13_1: TLabel;
    DBEdit5: TDBEdit;
    c13_2: TLabel;
    DBEdit6: TDBEdit;
    c13_3: TLabel;
    DBEdit7: TDBEdit;
    c13_4: TLabel;
    DBEdit8: TDBEdit;
    Niandu: TLabel;
    DBEdit9: TDBEdit;
    LudaiQty: TLabel;
    DBEdit10: TDBEdit;
    Spos: TLabel;
    DBEdit11: TDBEdit;
    Spos_time: TLabel;
    Temperature: TLabel;
    DBEdit13: TDBEdit;
    RemainLot: TLabel;
    DBEdit14: TDBEdit;
    AddQty: TLabel;
    DBEdit15: TDBEdit;
    AddSG: TLabel;
    DBEdit16: TDBEdit;
    T1: TLabel;
    DBEdit17: TDBEdit;
    T1_time: TLabel;
    T2: TLabel;
    DBEdit19: TDBEdit;
    T2_time: TLabel;
    T3: TLabel;
    DBEdit21: TDBEdit;
    T3_time: TLabel;
    T4: TLabel;
    DBEdit23: TDBEdit;
    T4_time: TLabel;
    Opt_uid: TLabel;
    DBEdit25: TDBEdit;
    Opt_uname: TLabel;
    DBEdit26: TDBEdit;
    Bevel1: TBevel;
    Conf_uid: TLabel;
    DBEdit27: TDBEdit;
    Conf_uname: TLabel;
    DBEdit28: TDBEdit;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    DBDateTimeEditEh2: TDBDateTimeEditEh;
    DBDateTimeEditEh3: TDBDateTimeEditEh;
    DBDateTimeEditEh4: TDBDateTimeEditEh;
    DBDateTimeEditEh5: TDBDateTimeEditEh;
    DBEdit12: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_quitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmIPQCT621_edit: TFrmIPQCT621_edit;

implementation

uses unGlobal, unCommon, unIPQCT621;

{$R *.dfm}

procedure TFrmIPQCT621_edit.FormCreate(Sender: TObject);
begin
  inherited;
  SetLabelCaption(Self, 'IPQC620');
  if not g_MInfo^.R_edit then
  begin
    btn_quit.Top:=btn_ok.Top;
    btn_ok.Visible:=False;
  end;
end;

procedure TFrmIPQCT621_edit.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  if Length(Trim(FrmIPQCT621.CDS.FieldByName('niandu_std').AsString))=0 then
  begin
    tmpSQL:='select top 1 niandu from ipqc610 where bu='+Quotedstr(g_UInfo^.BU)
           +' and ad='+Quotedstr(FrmIPQCT621.CDS.FieldByName('ad').AsString)
           +' and ver='+Quotedstr(FrmIPQCT621.CDS.FieldByName('ver').AsString);
    if not QueryOneCR(tmpSQL, Data) then
       Exit;

    if not VarIsNull(Data) then
    begin
      tmpSQL:=Trim(VarToStr(Data));
      if Length(tmpSQL)>0 then
      begin
        FrmIPQCT621.CDS.Edit;
        FrmIPQCT621.CDS.FieldByName('niandu_std').AsString:=tmpSQL;
        FrmIPQCT621.CDS.Post;
        if not PostBySQLFromDelta(FrmIPQCT621.CDS, 'IPQC620', 'bu,ad,ver,lot') then
        begin
          FrmIPQCT621.CDS.CancelUpdates;
          ShowMsg('更新粘度標準失敗!',64);
        end;
      end;
    end;
  end;
end;

procedure TFrmIPQCT621_edit.btn_okClick(Sender: TObject);
begin
  //inherited;
  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,無修改權限!',48);
    Exit;
  end;

  with FrmIPQCT621.CDS do
  begin
    if State in [dsEdit] then
       Post;

    if (Length(FieldByName('opt_uid').AsString)>0) and
       (Length(Trim(FieldByName('opt_uname').AsString))=0) then
    begin
      ShowMsg('請輸入測試人員!',48);
      DBEdit25.SetFocus;
      Exit;
    end;

    if (Length(FieldByName('conf_uid').AsString)>0) and
       (Length(Trim(FieldByName('conf_uname').AsString))=0) then
    begin
      ShowMsg('請輸入確認人員!',48);
      DBEdit27.SetFocus;
      Exit;
    end;
  end;

  if PostBySQLFromDelta(FrmIPQCT621.CDS, 'IPQC620', 'bu,ad,ver,lot') then
     ShowMsg('儲存成功',64);
end;

procedure TFrmIPQCT621_edit.btn_quitClick(Sender: TObject);
begin
  with FrmIPQCT621.CDS do
  begin
    if State in [dsEdit] then
       Cancel;
    if ChangeCount>0 then
       CancelUpdates;
  end;

  inherited;
end;

end.
