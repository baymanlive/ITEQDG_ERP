{*******************************************************}
{                                                       }
{                unMPSI370                              }
{                Author: kaikai                         }
{                Create date: 2018/7/27                 }
{                Description: 副排程鋼板                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI380;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI380 = class(TFrmSTDI031)
    btn_mpsi380: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_queryClick(Sender: TObject);
    procedure btn_mpsi380Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI380: TFrmMPSI380;

implementation

uses unGlobal, unCommon, unSelectCopyDate;

{$R *.dfm}

procedure TFrmMPSI380.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS380 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI380.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS380';
  p_GridDesignAns:=True;
  btn_mpsi380.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_mpsi380.Left:=btn_quit.Left;

  inherited;
end;

procedure TFrmMPSI380.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('sdate').AsString))=0 then
     ShowM('sdate');

  if Length(Trim(CDS.FieldByName('stealno').AsString))=0 then
     ShowM('stealno');

  if CDS.FieldByName('qty').IsNull then
     ShowM('qty');

  inherited;
end;

procedure TFrmMPSI380.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    if tmpStr='' then
       tmpStr:=' and sdate>getdate()-4';
     RefreshDS(tmpStr);
  end;   
end;

procedure TFrmMPSI380.btn_mpsi380Click(Sender: TObject);
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
        tmpSQL:='Delete From MPS380 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Sdate='+Quotedstr(DateToStr(tmpDate));
        if not PostBySQL(tmpSQL) then
           Exit;

        tmpSQL:='Insert Into MPS380(Bu,Sdate,Stealno,Thickness,Qty,Not_use,Iuser,Idate)'
               +'Select Bu,'+Quotedstr(DateToStr(tmpDate))+',Stealno,'
               +' Thickness,Qty,0,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(Idate)
               +' From MPS380 Where Bu='+Quotedstr(g_UInfo^.BU)
               +' And Sdate='+Quotedstr(DateToStr(FrmSelectCopyDate.Dtp1.Date));
        if not PostBySQL(tmpSQL) then
           Exit;
      end;

      tmpDate:=tmpDate+1;
    end; //end while

    RefreshDS(' and sdate>getdate()-4');
    ShowMsg('資料複製完畢,若無顯示,請按查詢查看!', 64);
  end;
end;

end.
