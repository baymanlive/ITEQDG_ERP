{*******************************************************}
{                                                       }
{                unMPSR090                              }
{                Author: kaikai                         }
{                Create date: 2016/4/6                  }
{                Description: Call貨日期更改            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR090;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

type
  TFrmMPSR090 = class(TFrmSTDI041)
    PnlRight: TPanel;
    btn_mpsr090A: TBitBtn;
    btn_mpsr090B: TBitBtn;
    btn_mpsr090C: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure btn_mpsr090AClick(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure btn_mpsr090BClick(Sender: TObject);
    procedure btn_mpsr090CClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure CDSAfterPost(DataSet: TDataSet);
  private
    l_CDate:TDateTime;
    l_CDS:TClientDataSet;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR090: TFrmMPSR090;

implementation

uses unGlobal, unCommon, unMPSR090_Query, unMPST040_units,
  unMPSR090_CallDate, unMPSR090_CallDate2;

{$R *.dfm}

procedure TFrmMPSR090.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='exec proc_MPSR090 '+Quotedstr(g_UInfo^.BU)+','+Quotedstr(strFilter);
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSR090.FormCreate(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  p_SysId:='Mps';
  p_TableName:='MPSR090';
  p_GridDesignAns:=True;

  inherited;

  PnlRight.Visible:=g_MInfo^.R_edit;
  l_CDS:=TClientDataSet.Create(Self);
  tmpSQL:='Select Custno,CCL,PP From MPS630 Where Bu='+Quotedstr(g_UInfo^.BU);
  if QueryBySQL(tmpSQL, Data) then
     l_CDS.Data:=Data;
end;

procedure TFrmMPSR090.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR090.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmMPSR090_Query) then
     FrmMPSR090_Query:=TFrmMPSR090_Query.Create(Application);
  if FrmMPSR090_Query.ShowModal=mrok then
     RefreshDS(FrmMPSR090_Query.l_QueryStr);
end;

procedure TFrmMPSR090.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  with CDS do
  if FieldByName('ordpno').AsString<>FieldByName('pno').AsString then
     AFont.Color:=clRed;
end;

procedure TFrmMPSR090.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPSR090.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;

  l_CDate:=CDS.FieldByName('CDate').AsDateTime;
end;

procedure TFrmMPSR090.CDSBeforePost(DataSet: TDataSet);
var
  bo:Boolean;
  tmpBool:Boolean;
  tmpDate1:TDateTime;
  tmpSQL:string;
begin
  inherited;
{  if SameText(CDS.FieldByName('unit').AsString,'PN') then
  begin
    ShowMsg('PN板不可Call貨!', 48);
    Abort;
  end;
}
  if l_CDate<>CDS.FieldByName('CDate').AsDateTime then
  begin
    bo:=l_CDS.Locate('Custno',CDS.FieldByName('Custno').AsString,[]);
    if bo then
    begin
      bo:=(Pos(Copy(CDS.FieldByName('Pno').AsString,1,1),'ET')>0) and l_CDS.FieldByName('CCL').AsBoolean;
      if not bo then
         bo:=(Pos(Copy(CDS.FieldByName('Pno').AsString,1,1),'ET')=0) and l_CDS.FieldByName('PP').AsBoolean;
    end;
    if not bo then
    begin
      ShowMsg('此客戶設定不可CALL貨!', 48);
      Abort;
    end;
  end;

  if (not CDS.FieldByName('Cdate').IsNull) and
     (CDS.FieldByName('Cdate').AsDateTime<Date) then
  begin
    ShowMsg('Call貨日期不能小於當天日期!', 48);
    Abort;
  end;

  tmpSQL:='Select Bu From MPS200 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Flag=1 And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger);
  if not QueryExists(tmpSQL, tmpBool) then
     Abort;

  if tmpBool then
  begin
    ShowMsg('此筆訂單已排出貨,不可更改!', 48);
    Abort;
  end;

  if not CheckLockProc(tmpBool, 'MPST040') then
     Abort;

  if tmpBool then
  begin
    ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
    Abort;
  end;

  if CDS.FieldByName('Cdate').IsNull then
     tmpSQL:='Update MPS200 Set Cdate=null'
  else begin
    tmpDate1:=StrToDate(DateToStr(CDS.FieldByName('Cdate').AsDateTime));
    if CheckConfirm(tmpDate1) then
    begin
      ShowMsg('此日期出貨表已確認,不可更改為此日期!', 48);
      Abort;
    end;

    tmpSQL:='Update MPS200 Set Cdate='+Quotedstr(DateToStr(tmpDate1));
  end;

  tmpSQL:=tmpSQL+',Remark2='+Quotedstr(Trim(CDS.FieldByName('Remark2').AsString))
                +',Muser='+Quotedstr(g_UInfo^.UserId)
                +',Mdate='+Quotedstr(FormatDateTime(g_cLongTimeSP, Now))
                +' Where Bu='+Quotedstr(g_UInfo^.BU)
                +' And Ditem='+IntToStr(CDS.FieldByName('Ditem').AsInteger);
  if not PostBySQL(tmpSQL) then
     Abort;
end;

procedure TFrmMPSR090.CDSAfterPost(DataSet: TDataSet);
begin
  inherited;
  CDS.MergeChangeLog;
end;

procedure TFrmMPSR090.btn_mpsr090AClick(Sender: TObject);
var
  str:string;
begin
  inherited;
  if CDS.Active then
     str:=CDS.FieldByName('pno').AsString;
  GetQueryStock(str, false);
end;

procedure TFrmMPSR090.btn_mpsr090BClick(Sender: TObject);
var
  bo:Boolean;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇一筆訂單資料!', 48);
    Exit;
  end;

  if CDS.FieldByName('Flag').AsString='Y' then
  begin
    ShowMsg('此筆訂單已排出貨,不可更改!', 48);
    Exit;
  end;
{
  if SameText(CDS.FieldByName('unit').AsString,'PN') then
  begin
    ShowMsg('PN板不可Call貨!', 48);
    Exit;
  end;
}
  bo:=l_CDS.Locate('Custno',CDS.FieldByName('Custno').AsString,[]);
  if bo then
  begin
    bo:=(Pos(Copy(CDS.FieldByName('Pno').AsString,1,1),'ET')>0) and l_CDS.FieldByName('CCL').AsBoolean;
    if not bo then
       bo:=(Pos(Copy(CDS.FieldByName('Pno').AsString,1,1),'ET')=0) and l_CDS.FieldByName('PP').AsBoolean;
  end;
  if not bo then
  begin
    ShowMsg('此客戶設定不可CALL貨!', 48);
    Abort;
  end;

  if not Assigned(FrmMPSR090_CallDate) then
     FrmMPSR090_CallDate:=TFrmMPSR090_CallDate.Create(Application);
  FrmMPSR090_CallDate.ShowModal;
end;

procedure TFrmMPSR090.btn_mpsr090CClick(Sender: TObject);
var
  bo:Boolean;
  tmpOrderno:string;
  tmpBool: Boolean;
  tmpCDS:TClientDataSet;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請查詢資料!', 48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpOrderno:=tmpCDS.FieldByName('orderno').AsString;
    while not tmpCDS.Eof do
    begin
      if SameText(tmpCDS.FieldByName('unit').AsString,'PN') then
      begin
        ShowMsg('PN板不可Call貨!', 48);
        Exit;
      end;

      if not SameText(tmpOrderno,tmpCDS.FieldByName('orderno').AsString) then
      begin
        ShowMsg('不是同一訂單,不可CALL貨!', 48);
        Exit;
      end;

      bo:=l_CDS.Locate('Custno',tmpCDS.FieldByName('Custno').AsString,[]);
      if bo then
      begin
        bo:=(Pos(Copy(tmpCDS.FieldByName('Pno').AsString,1,1),'ET')>0) and l_CDS.FieldByName('CCL').AsBoolean;
        if not bo then
           bo:=(Pos(Copy(tmpCDS.FieldByName('Pno').AsString,1,1),'ET')=0) and l_CDS.FieldByName('PP').AsBoolean;
      end;
      if not bo then
      begin
        ShowMsg(tmpCDS.FieldByName('Custno').AsString+'此客戶設定不可CALL貨!', 48);
        Exit;
      end;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;

  if not CheckLockProc(tmpBool, 'MPST040') then
     Exit;

  if tmpBool then
  begin
    ShowMsg('出貨排程被別的使用者暫時鎖定,請重試!', 48);
    Exit;
  end;

  if not Assigned(FrmMPSR090_CallDate2) then
     FrmMPSR090_CallDate2:=TFrmMPSR090_CallDate2.Create(Application);
  FrmMPSR090_CallDate2.ShowModal;
end;

end.
