{*******************************************************}
{                                                       }
{                unMPSI030                              }
{                Author: kaikai                         }
{                Create date: 2015/12/20                }
{                Description: ���x����]�w�{��          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI030;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI030 = class(TFrmSTDI031)
    btn_mpsi030: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSNewRecord(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpsi030Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI030: TFrmMPSI030;

implementation

uses unGlobal, unCommon, unSelectCopyDate;

{$R *.dfm}

procedure TFrmMPSI030.SetToolBar;
begin
  btn_mpsi030.Enabled:=g_MInfo^.R_edit and CDS.Active and (not (CDS.State in [dsInsert,dsEdit]));
  inherited;
end;

procedure TFrmMPSI030.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS030 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI030.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS030';
  p_GridDesignAns:=True;
  btn_mpsi030.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_mpsi030.Left:=btn_quit.Left;

  inherited;

  GetMPSMachine;
  DBGridEh1.FieldColumns['machine'].PickList.DelimitedText:=g_MachineCCL;
end;

procedure TFrmMPSI030.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
     RefreshDS(' and wdate>=getdate()-4'+tmpStr);
end;

procedure TFrmMPSI030.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('machine').AsString))=0 then
     ShowM('machine');

  if Pos(CDS.FieldByName('machine').AsString,g_MachineCCL)=0 then
     ShowM('machine');

  if CDS.FieldByName('wdate').IsNull then
     ShowM('wdate');
  inherited;
end;

procedure TFrmMPSI030.CDSNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('wdate').AsDateTime:=Date;
  DataSet.FieldByName('nu_capacity').AsFloat:=0;
  DataSet.FieldByName('mu_capacity').AsFloat:=0;
  DataSet.FieldByName('fu_capacity').AsFloat:=0;
  DataSet.FieldByName('eu_capacity').AsFloat:=0;
end;

procedure TFrmMPSI030.btn_mpsi030Click(Sender: TObject);
var
  tmpDate:TDateTime;
  tmpSQL,Idate:string;
begin
  inherited;
  if not Assigned(FrmSelectCopyDate) then
     FrmSelectCopyDate:=TFrmSelectCopyDate.Create(Application);
  if FrmSelectCopyDate.ShowModal=mrOK then
  begin
    tmpDate:=FrmSelectCopyDate.Dtp2.Date;
    Idate:=StringReplace(FormatDateTime(g_cLongTimeSP, Now),'/','-',[rfReplaceAll]);

    while tmpDate<=FrmSelectCopyDate.Dtp3.Date do
    begin
      if tmpDate<>FrmSelectCopyDate.Dtp1.Date then
      begin
        tmpSQL:='Delete From MPS030 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Wdate='+Quotedstr(DateToStr(tmpDate));
        if not PostBySQL(tmpSQL) then
           Exit;

        tmpSQL:='Insert Into MPS030(Bu,Machine,Wdate,Adhesive,'
               +' Boiler_qty,nh_capacity,nu_capacity,mh_capacity,mu_capacity,fh_capacity,'
               +' fu_capacity,eh_capacity,eu_capacity,Iuser,Idate)'
               +'Select Bu,Machine,'+Quotedstr(DateToStr(tmpDate))+',Adhesive,'
               +' Boiler_qty,nh_capacity,nu_capacity,mh_capacity,mu_capacity,fh_capacity,'
               +' fu_capacity,eh_capacity,eu_capacity,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(Idate)
               +' From MPS030 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Wdate='+Quotedstr(DateToStr(FrmSelectCopyDate.Dtp1.Date));
        if not PostBySQL(tmpSQL) then
           Exit;
      end;

      tmpDate:=tmpDate+1;
    end; //end while

    RefreshDS(' and wdate>=getdate()-4');
    ShowMsg('��ƽƻs����,�Y�L���,�Ы��d�߬d��!', 64);
  end;
end;

end.
