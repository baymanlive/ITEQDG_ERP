{*******************************************************}
{                                                       }
{                unMPST060                              }
{                Author: kaikai                         }
{                Create date: 2016/6/23                 }
{                Description: 取樣統計作業              }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST060;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, ExtCtrls, Buttons, ImgList, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

type
  TFrmMPST060 = class(TFrmSTDI041)
    PnlRight: TPanel;
    btn_mpst060: TBitBtn;
    RGP: TRadioGroup;
    Chk: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CDSBeforeInsert(DataSet: TDataSet);
    procedure CDSBeforeEdit(DataSet: TDataSet);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure RGPClick(Sender: TObject);
    procedure ChkClick(Sender: TObject);
    procedure DBGridEh1KeyPress(Sender: TObject; var Key: Char);
    procedure btn_mpst060Click(Sender: TObject);
  private
    l_isDG:Boolean;
    l_ColorList:TStrings;
    procedure RefreshColor;
    procedure FilterData;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST060: TFrmMPST060;

implementation

uses unGlobal, unCommon, unMPST060_qy;

{$R *.dfm}

procedure TFrmMPST060.RefreshColor;
var
  tmpStr,tmpValue:string;
  tmpCDS:TClientdataset;
begin
  l_ColorList.Clear;
  tmpCDS:=TClientdataset.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    tmpCDS.Filter:=CDS.Filter;
    tmpCDS.Filtered:=True;
    tmpCDS.IndexFieldNames:=CDS.IndexFieldNames;
    
    tmpValue:='1';
    tmpStr:='@';
    while not tmpCDS.Eof do
    begin
      if tmpStr<>tmpCDS.FieldByName('Stealno').AsString then
      begin
        if tmpValue='1' then
           tmpValue:='2'
        else
           tmpValue:='1';
      end;
      l_ColorList.Add(tmpValue);
      tmpStr:=tmpCDS.FieldByName('Stealno').AsString;
      tmpCDS.Next;
    end;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPST060.FilterData;
var
  str:string;
begin
  if Chk.Checked then
     str:='qty>0 and ';
  with CDS do
  begin
    Filtered:=False;
    Filter:=str+'machine='+Quotedstr(RGP.Items[RGP.ItemIndex]);
    Filtered:=True;
    IndexFieldNames:='id';
  end;
  if not Chk.Checked then
     RefreshColor;
end;


procedure TFrmMPST060.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  if strFilter='' then
     tmpSQL:='and sdate>='+Quotedstr(DateToStr(Date))
  else
     tmpSQL:=strFilter;
  if tmpSQL<>g_cFilterNothing then
  begin
    tmpSQL:=tmpSQL+' and A.bu='+Quotedstr(g_UInfo^.BU);
    if l_isDG then
       tmpSQL:=tmpSQL+' and machine<>''L6'''
    else
       tmpSQL:=tmpSQL+' and machine=''L6''';
  end;
  tmpSQL:='exec dbo.proc_MPST060 '+Quotedstr(tmpSQL);
  if QueryBySQL(tmpSQL, Data) then
  begin
    CDS.Data:=Data;
    FilterData;
  end;

  inherited;
end;

procedure TFrmMPST060.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPST060';
  p_GridDesignAns:=True;
  p_SBText:=CheckLang('審核操作請在[審核]欄位按空格鍵');
  l_ColorList:=TStringList.Create;
  l_isDG:=Pos('dg', LowerCase(g_UInfo^.BU))>0;
  if not l_isDG then
  begin
    RGP.Items.Clear;
    RGP.Items.Add('L6');
    RGP.ItemIndex:=0;
  end;

  inherited;

  RGP.Caption:=CheckLang('機台');
  Chk.Caption:=CheckLang('只顯示取樣');
end;

procedure TFrmMPST060.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_ColorList);
end;

procedure TFrmMPST060.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or Chk.Checked then
     Exit;

  if CDS.FieldByName('qty').AsInteger>0 then
     AFont.Color:=clRed;
     
  if l_ColorList.Count>=CDS.RecNo then
  begin
    if l_ColorList.Strings[CDS.RecNo-1]='1' then
       Background:=RGB(255,255,204)
    else
       Background:=RGB(204,236,255);
  end;
end;

procedure TFrmMPST060.DBGridEh1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if g_MInfo^.R_edit and (Ord(Key)=VK_SPACE) and CDS.Active and
     SameText(DBGridEh1.SelectedField.FieldName,'qcconf') then
  begin
    CDS.Edit;
    if SameText(CDS.FieldByName('qcconf').AsString,'Y') then
       CDS.FieldByName('qcconf').AsString:='N'
    else
       CDS.FieldByName('qcconf').AsString:='Y';
    CDS.Post;
  end;
end;

procedure TFrmMPST060.RGPClick(Sender: TObject);
begin
  inherited;
  FilterData;
end;

procedure TFrmMPST060.ChkClick(Sender: TObject);
begin
  inherited;
  FilterData;
end;

procedure TFrmMPST060.CDSBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  Abort;
end;

procedure TFrmMPST060.CDSBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not g_MInfo^.R_edit then
     Abort;
  if Length(DataSet.FieldByName('wono').AsString)=0 then
  begin
    ShowMsg('工單號碼未產生,不可更改!', 48);
    Abort;
  end;
end;

procedure TFrmMPST060.CDSAfterPost(DataSet: TDataSet);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;
  tmpSQL:='Select * From MPS060 Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Wono='+Quotedstr(CDS.FieldByName('Wono').AsString);
  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    try
      tmpCDS.Data:=Data;
      with tmpCDS do
      begin
        if IsEmpty then
        begin
          Append;
          FieldByName('Bu').AsString:=g_UInfo^.BU;
          FieldByName('Wono').AsString:=CDS.FieldByName('wono').AsString;
          FieldByName('Qty').AsInteger:=CDS.FieldByName('qty').AsInteger;
          FieldByName('PDAConf').AsString:='N';
          if not CDS.FieldByName('qcqty').IsNull then
             FieldByName('QCQty').AsInteger:=CDS.FieldByName('qcqty').AsInteger;
          FieldByName('QCConf').AsString:=CDS.FieldByName('qcconf').AsString;
          FieldByName('QCIns').AsString:='Y';
          FieldByName('Iuser').AsString:=g_UInfo^.UserId;
          FieldByName('Idate').AsDateTime:=Now;
          Post;
        end else
        begin
          Edit;
          FieldByName('Qty').AsInteger:=CDS.FieldByName('qty').AsInteger;
          if not CDS.FieldByName('qcqty').IsNull then
             FieldByName('QCQty').AsInteger:=CDS.FieldByName('qcqty').AsInteger;
          FieldByName('QCConf').AsString:=CDS.FieldByName('qcconf').AsString;
          FieldByName('Muser').AsString:=g_UInfo^.UserId;
          FieldByName('Mdate').AsDateTime:=Now;
          Post;
        end;
      end;
      if CDSPost(tmpCDS, 'MPS060') then
         CDS.MergeChangeLog
      else if CDS.ChangeCount>0 then
         CDS.CancelUpdates;
    finally
      tmpCDS.Free;
    end;
  end;
end;

procedure TFrmMPST060.btn_mpst060Click(Sender: TObject);
begin
  inherited;
  if not g_MInfo^.R_edit then
  begin
    ShowMsg('對不起,你沒有此操作的權限!', 48);
    Exit;
  end;

  if not Assigned(FrmMPST060_qy) then
     FrmMPST060_qy:=TFrmMPST060_qy.Create(Application);
  FrmMPST060_qy.l_isDG:=Self.l_isDG;
  FrmMPST060_qy.ShowModal;
end;

end.
