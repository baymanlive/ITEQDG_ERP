{*******************************************************}
{                                                       }
{                unMPST010_BoilerEdit                   }
{                Author: kaikai                         }
{                Create date: 2015/4/22                 }
{                Description: 整鍋對換                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_BoilerEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB, GridsEh,
  DBAxisGridsEh, DBGridEh;

type
  TFrmBoilerEdit = class(TFrmSTDI051)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Dtp1: TDateTimePicker;
    Edit2: TEdit;
    Dtp2: TDateTimePicker;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    l_Machine:string;
    { Public declarations }
  end;

var
  FrmBoilerEdit: TFrmBoilerEdit;

implementation

uses unGlobal, unCommon, unMPST010;

{$R *.dfm}

procedure TFrmBoilerEdit.FormCreate(Sender: TObject);
begin
  inherited;
  Label4.Caption:=CheckLang('機台：');
  Label1.Caption:=CheckLang('鍋次：');
  Label2.Caption:=CheckLang('生產日期：');
  Label3.Caption:=Label1.Caption;
  Label4.Caption:=Label2.Caption;
  Label6.Caption:='↑↓';

  Dtp1.Date:=Date;
  Dtp2.Date:=Dtp1.Date;
  Edit1.Text:='1';
end;

procedure TFrmBoilerEdit.FormShow(Sender: TObject);
begin
  inherited;
  with FrmMPST010 do
  if CDS.Active and (not CDS.IsEmpty) and (PCL.ActivePageIndex=0) then
  begin
    Self.l_Machine:=CDS.FieldByName('Machine').AsString;
    Self.Dtp1.Date:=CDS.FieldByName('Sdate').AsDateTime;
    Self.Edit1.Text:=IntToStr(CDS.FieldByName('CurrentBoiler').AsInteger);
    Self.Dtp2.Date:=Self.Dtp1.Date;
  end;
  Self.Caption:=Self.Caption+'-'+l_Machine;
end;

procedure TFrmBoilerEdit.btn_okClick(Sender: TObject);
var
  tmpSQL,tmpStealno1,tmpStealno2,tmpFilter,tmpSimuver:string;
  Data:OleVariant;
  tmpJitem1,tmpJitem2,tmpCitem:Integer;
  tmpCDS:TClientDataSet;
begin
  if l_Machine='' then
  begin
    ShowMsg('機台不存在!',48);
    Exit;
  end;

  try
    StrToInt(Edit1.Text);
  except
    ShowMsg('請輸入數字!',48);
    Edit1.SetFocus;
    Exit;
  end;

  try
    StrToInt(Edit2.Text);
  except
    ShowMsg('請輸入數字!',48);
    Edit2.SetFocus;
    Exit;
  end;

  if (Dtp1.Date=Dtp2.Date) and (Edit1.Text=Edit2.Text) then
  begin
    ShowMsg('請輸入不同的生產日期、鍋次!',48);
    Edit1.SetFocus;
    Exit;
  end;

  if ShowMsg('確定進行鍋次對換嗎?',33)=IDCancel then
     Exit;

  tmpSQL:='Select Simuver,Citem,Jitem,Sdate,CurrentBoiler,Stealno'
         +' From MPS010 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Machine='+Quotedstr(l_Machine)
         +' And ((Sdate='+Quotedstr(DateToStr(Dtp1.Date))
         +' And CurrentBoiler='+Edit1.Text+')'
         +' OR (Sdate='+Quotedstr(DateToStr(Dtp2.Date))
         +' And CurrentBoiler='+Edit2.Text+'))'
         +' Order By Machine,Jitem,OZ,Materialno,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpSimuver:=FrmMPST010.CDS.FieldByName('Simuver').AsString;
    tmpCitem:=FrmMPST010.CDS.FieldByName('Citem').AsInteger;
    tmpFilter:=FrmMPST010.CDS.Filter;
    FrmMPST010.CDS.Filtered:=False;
    FrmMPST010.CDS.DisableControls;
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
        if not Locate('Sdate;CurrentBoiler',
            VarArrayOf([DateToStr(Dtp1.Date), Edit1.Text]), []) then
        begin
          ShowMsg(Label2.Caption+DateToStr(Dtp1.Date)+' '+
                  Label1.Caption+Edit1.Text+'不存在!',48);
          Exit;
        end;

        tmpJitem1:=FieldByName('Jitem').AsInteger;
        tmpStealno1:=FieldByName('Stealno').AsString;

        if not Locate('Sdate;CurrentBoiler',
            VarArrayOf([DateToStr(Dtp2.Date), Edit2.Text]), []) then
        begin
          ShowMsg(Label4.Caption+DateToStr(Dtp2.Date)+' '+
                  Label3.Caption+Edit2.Text+'不存在!',48);
          Exit;
        end;

        tmpJitem2:=FieldByName('Jitem').AsInteger;
        tmpStealno2:=FieldByName('Stealno').AsString;

        First;
        while not Eof do
        begin
          if not FrmMPST010.CDS.Locate('Simuver;Citem',
                 VarArrayOf([FieldByName('Simuver').AsString,
                 FieldByName('Citem').AsInteger]),[]) then
          begin
            if FrmMPST010.CDS.ChangeCount>0 then
               FrmMPST010.CDS.CancelUpdates;
            ShowMsg('資料不同步,請重新開啟作業!', 48);
            Exit;
          end;

          FrmMPST010.CDS.Edit;
          if FrmMPST010.CDS.FieldByName('Jitem').AsInteger=tmpJitem1 then
          begin
            FrmMPST010.CDS.FieldByName('Jitem').AsInteger:=tmpJitem2;
            FrmMPST010.CDS.FieldByName('Sdate').AsDateTime:=Dtp2.Date;
            FrmMPST010.CDS.FieldByName('CurrentBoiler').AsInteger:=StrToInt(Edit2.Text);
            FrmMPST010.CDS.FieldByName('Stealno').AsString:=tmpStealno2;
          end else
          begin
            FrmMPST010.CDS.FieldByName('Jitem').AsInteger:=tmpJitem1;
            FrmMPST010.CDS.FieldByName('Sdate').AsDateTime:=Dtp1.Date;
            FrmMPST010.CDS.FieldByName('CurrentBoiler').AsInteger:=StrToInt(Edit1.Text);
            FrmMPST010.CDS.FieldByName('Stealno').AsString:=tmpStealno1;
          end;
          FrmMPST010.CDS.Post;
          Next;
        end;
      end;

      if not CDSPost(FrmMPST010.CDS, 'MPS010') then
      if FrmMPST010.CDS.ChangeCount>0 then
      begin
        FrmMPST010.CDS.CancelUpdates;
        Exit;
      end;
    finally
      FrmMPST010.CDS.Filter:=tmpFilter;
      FrmMPST010.CDS.Filtered:=True;
      FrmMPST010.CDS.Locate('Simuver;Citem',VarArrayOf([tmpSimuver,tmpCitem]),[]);
      FrmMPST010.CDS.EnableControls;
      FreeAndNil(tmpCDS);
    end;
  end;

  inherited;
end;

end.
