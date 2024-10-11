{*******************************************************}
{                                                       }
{                unMPSI500                              }
{                Author: kaikai                         }
{                Create date: 2016/9/10                 }
{                Description: PP機台產能設定程式        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI500;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI500 = class(TFrmSTDI031)
    btn_mpsi500: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpsi500Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI500: TFrmMPSI500;

implementation

uses unGlobal, unCommon, unSelectCopyDate;

{$R *.dfm}

procedure TFrmMPSI500.SetToolBar;
begin
  btn_mpsi500.Enabled:=g_MInfo^.R_new and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPSI500.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS500 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI500.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS500';
  p_GridDesignAns:=True;
  btn_mpsi500.Visible:=g_MInfo^.R_new;
  if g_MInfo^.R_new then
     btn_mpsi500.Left:=btn_quit.Left;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['Machine'].PickList.DelimitedText:=g_MachinePP;
end;

procedure TFrmMPSI500.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');

  if Pos(CDS.FieldByName('machine').AsString,g_MachinePP)=0 then
     ShowM('machine');

  if CDS.FieldByName('wdate').IsNull then
     ShowM('wdate');

  inherited;
end;

procedure TFrmMPSI500.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('wdate').AsDateTime:=Date;
  DataSet.FieldByName('capacity').AsInteger:=0;
end;

procedure TFrmMPSI500.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
     RefreshDS(' and wdate>=getdate()-4'+tmpStr);
end;

procedure TFrmMPSI500.btn_mpsi500Click(Sender: TObject);
var
  tmpDate:TDateTime;
  tmpSQL:string;
begin
  inherited;

  if not Assigned(FrmSelectCopyDate) then
     FrmSelectCopyDate:=TFrmSelectCopyDate.Create(Application);
  if FrmSelectCopyDate.ShowModal=mrOK then
  begin
    tmpDate:=FrmSelectCopyDate.Dtp2.Date;
    while tmpDate<=FrmSelectCopyDate.Dtp3.Date do
    begin
      if tmpDate<>FrmSelectCopyDate.Dtp1.Date then
      begin
        tmpSQL:='Delete From MPS500 where Bu='+Quotedstr(g_UInfo^.BU)
               +' And wdate='+Quotedstr(DateToStr(tmpDate));
        if not PostBySQL(tmpSQL) then
           Exit;

        tmpSQL:='Insert Into MPS500(Bu,Machine,Wdate,Capacity,Iuser,Idate)'
               +'Select Bu,Machine,'+Quotedstr(DateToStr(tmpDate))
               +',Capacity,'+Quotedstr(g_UInfo^.UserId)
               +','+Quotedstr(FormatDateTime(g_cLongTimeSP, Now))
               +' From MPS500 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And wdate='+Quotedstr(DateToStr(FrmSelectCopyDate.Dtp1.Date));
        if not PostBySQL(tmpSQL) then
           Exit;
      end;

      tmpDate:=tmpDate+1;
    end; //end while

    RefreshDS(' and wdate>=getdate()-4');
    ShowMsg('資料複製完畢,若無顯示,請按查詢查看!', 64);
  end;
end;

end.
