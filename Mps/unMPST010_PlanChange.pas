{*******************************************************}
{                                                       }
{                unMPST010_PlanChange                   }
{                Author: kaikai                         }
{                Create date: 2015/4/23                 }
{                Description: 異常計劃變更              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST010_PlanChange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ComCtrls, StdCtrls, ImgList, Buttons, ExtCtrls, DBClient,
  DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DB, GridsEh,
  DBAxisGridsEh, DBGridEh;

type
  TFrmPlanChange = class(TFrmSTDI051)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Dtp: TDateTimePicker;
    Label3: TLabel;
    Label4: TLabel;
    DBGridEh1: TDBGridEh;
    btn_export: TBitBtn;
    CDS: TClientDataSet;
    DS: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure DtpChange(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_exportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    procedure SetLableCaption;
    { Private declarations }
  public
    l_Machine:string;
    { Public declarations }
  end;

var
  FrmPlanChange: TFrmPlanChange;

implementation

uses unGlobal, unCommon, unMPST010;

{$R *.dfm}

procedure TFrmPlanChange.SetLableCaption;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  Edit1.Text:='0';
  Label3.Caption:=CheckLang('已排：0鍋');
  tmpSQL:='Select Max(CurrentBoiler) CurrentBoiler From MPS010'
         +' Where Machine='+Quotedstr(l_Machine)
         +' And Sdate='+Quotedstr(DateToStr(Dtp.Date))
         +' And Bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      if not tmpCDS.IsEmpty then
      begin
        Edit1.Text:=tmpCDS.Fields[0].AsString;
        Label3.Caption:=CheckLang('已排：'+Edit1.Text+'鍋');
      end;
    finally
      FreeAndNil(tmpCDS);
    end;
  end;
end;

procedure TFrmPlanChange.FormCreate(Sender: TObject);
begin
  inherited;
  SetGrdCaption(DBGridEh1, Self.Name);
  Label1.Caption:=CheckLang('實際生產鍋數：');
  Label2.Caption:=CheckLang('異常生產日期：');
  Label4.Caption:=CheckLang('重整後請在作業中重新查詢資料');
  Dtp.Tag:=1;
  Dtp.Date:=Date;
  Dtp.Tag:=0;
end;

procedure TFrmPlanChange.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  SetLableCaption;
  tmpSQL:='select machine,sdate,max(currentboiler) cnt from mps010'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and sdate>getdate()-1'
         +' group by machine,sdate'
         +' order by machine,sdate';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;
end;

procedure TFrmPlanChange.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  DBGridEh1.Free;
end;

procedure TFrmPlanChange.DtpChange(Sender: TObject);
begin
  inherited;
  if Dtp.Tag=0 then
     SetLableCaption;
end;

procedure TFrmPlanChange.btn_okClick(Sender: TObject);
var
  tmpJitem,IncNum:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  if StrToIntDef(Edit1.Text, -1)<0 then
  begin
    ShowMsg('請輸入數字!',48);
    Edit1.SetFocus;
    Exit;
  end;

  if ShowMsg('確定進行重整嗎?',33)=IDCancel then
     Exit;

  tmpSQL:='Select Bu,Machine,Wdate,Boiler_qty From MPS030'
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Machine='+Quotedstr(l_Machine)
         +' And Wdate>='+Quotedstr(DateToStr(Dtp.Date))
         +' Order By Wdate';
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS1:=TClientDataSet.Create(nil);
    try
      tmpCDS1.Data:=Data;
      with tmpCDS1 do
      begin
        if not Locate('Wdate', DateToStr(Dtp.Date), []) then
        begin
          ShowMsg(DateToStr(Dtp.Date)+'當天產能設定錯誤!',48);
          Exit;
        end;

        Edit;
        FieldByName('Boiler_qty').AsInteger:=StrToInt(Edit1.Text);
        Post;
        Filtered:=False;
        Filter:='Boiler_qty>0';
        Filtered:=True;
        IndexFieldNames:='Wdate';
        First;
      end;

      Data:=null;
      tmpSQL:='Select Bu,Simuver,Citem,Jitem,Sdate,CurrentBoiler From MPS010'
             +' Where Machine='+Quotedstr(l_Machine)
             +' And Sdate>='+Quotedstr(DateToStr(Dtp.Date))
             +' And Bu='+Quotedstr(g_UInfo^.BU)
             +' Order By Machine,Jitem,OZ,Materialno,Simuver,Citem';
      if QueryBySQL(tmpSQL, Data) then
      begin
        IncNum:=0;
        tmpJitem:=-1;
        tmpCDS2:=TClientDataSet.Create(nil);
        try
          tmpCDS2.Data:=Data;

          with tmpCDS2 do
          while not Eof do
          begin
            if FieldByName('Jitem').AsInteger<>tmpJitem then
            begin
              if IncNum=tmpCDS1.FieldByName('Boiler_qty').AsInteger then
              begin
                IncNum:=0;
                tmpCDS1.Next;
              end;
              Inc(IncNum);
            end;

            if (FieldByName('Sdate').AsDateTime<>tmpCDS1.FieldByName('Wdate').AsDateTime) or
               (FieldByName('CurrentBoiler').AsInteger<>IncNum) then
            begin
              Edit;
              FieldByName('Sdate').AsDateTime:=tmpCDS1.FieldByName('Wdate').AsDateTime;
              FieldByName('CurrentBoiler').AsInteger:=IncNum;
              Post;
            end;

            tmpJitem:=FieldByName('Jitem').AsInteger;
            Next;
          end;
          
          If CDSPost(tmpCDS2, 'MPS010') then
             If CDSPost(tmpCDS1, 'MPS030') then
                ShowMsg('重整完畢!', 64)
             else
                ShowMsg('重整完畢,但更新產能失敗,請手動更正產能設定!', 48);
        finally
          FreeAndNil(tmpCDS2);
        end;
      end;
    finally
      FreeAndNil(tmpCDS1);
    end;
  end;

 // inherited;
end;

procedure TFrmPlanChange.btn_exportClick(Sender: TObject);
begin
  inherited;
  GetExportXls(CDS, Self.Name);
end;

end.
