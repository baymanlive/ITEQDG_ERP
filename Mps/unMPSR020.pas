{*******************************************************}
{                                                       }
{                unMPSR020                              }
{                Author: kaikai                         }
{                Create date: 2015/3/27                 }
{                Description: 生產進度表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, DB, DBClient,
  GridsEh, DBAxisGridsEh, DBGridEh, ToolWin, DateUtils, StrUtils, unMPS_IcoFlag;
                                     
type
  TFrmMPSR020 = class(TFrmSTDI041)
    PnlRight: TPanel;
    btn_mpsr020A: TBitBtn;
    btn_mpsr020B: TBitBtn;
    btn_mpsr020C: TBitBtn;
    ImageList2: TImageList;
    btn_mpsr020D: TBitBtn;
    btn_mpsr020E: TBitBtn;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_mpsr020AClick(Sender: TObject);
    procedure btn_mpsr020BClick(Sender: TObject);
    procedure btn_mpsr020CClick(Sender: TObject);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh1DblClick(Sender: TObject);
    procedure btn_mpsr020DClick(Sender: TObject);
    procedure btn_mpsr020EClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    l_qry:Boolean;
    l_MPS_IcoFlag:TMPS_IcoFlag;
    l_Img: TBitmap;
    l_StrIndex,l_StrIndexDesc:string;
    function UpdateWostation1(xBu: string):Boolean;
    procedure SetBtnEnabled(bool:Boolean);
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure SetToolBar;override;
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR020: TFrmMPSR020;

implementation

uses unGlobal, unCommon, unMPSR020_remark;

{$R *.dfm}

procedure TFrmMPSR020.SetBtnEnabled(bool:Boolean);
begin
  btn_mpsr020A.Enabled:=bool;
  btn_mpsr020B.Enabled:=bool;
  btn_mpsr020C.Enabled:=bool;
  btn_mpsr020D.Enabled:=bool;
  btn_mpsr020E.Enabled:=bool;
end;

//第7站包裝->PDA掃描工單號碼回寫
function TFrmMPSR020.UpdateWostation1(xBu:string):Boolean;
var
  tmpStr:string;
  Data:OleVariant;
  tmpCDS1,tmpCDS2:TClientDataSet;
begin
  inherited;
  tmpStr:='Select bu,simuver,citem,wono,wostation From MPS010'
         +' Where wostation<'+IntToStr(g_WonoErrorFlag)
         +' And Bu='+Quotedstr(g_UInfo^.BU);
  if SameText(xBu, 'ITEQDG') then
     tmpStr:=tmpStr+' And Machine<>''L6'' And wostation>=6'
  else if SameText(xBu, 'ITEQGZ') then
     tmpStr:=tmpStr+' And Machine=''L6'' And wostation>=6'  //L6 iteqgz資料庫
  else if SameText(xBu, 'ITEQJX') then
     tmpStr:=tmpStr+' And wostation>=4'
  else
     tmpStr:=tmpStr+' And wostation>=6';
  Result:=QueryBySQL(tmpStr, Data);
  if not Result then
     Exit;

  tmpStr:='';
  tmpCDS1:=TClientDataSet.Create(nil);
  tmpCDS1.Data:=Data;
  try
    while not tmpCDS1.Eof do
    begin
      if Length(tmpStr)>0 then
         tmpStr:=tmpStr+' or ';
      tmpStr:=tmpStr+' (sfb01='+Quotedstr(tmpCDS1.FieldByName('wono').AsString)+')';
      tmpCDS1.Next;
    end;

    if Length(tmpStr)=0 then
       Exit;

    Data:=null;
    tmpStr:='Select sfb01 From '+xBu+'.sfb_file Where sfb04=''8'' And ('+tmpStr+')';
    Result:=QueryBySQL(tmpStr, Data, 'ORACLE');
    if Result then
    begin
      tmpCDS2:=TClientDataSet.Create(nil);
      try
        tmpCDS2.Data:=Data;
        g_ProgressBar.Position:= 0;
        g_ProgressBar.Max:=tmpCDS2.RecordCount;
        g_ProgressBar.Visible:=True;
        while not tmpCDS2.Eof do
        begin
          g_ProgressBar.Position:=g_ProgressBar.Position+1;

          if tmpCDS1.Locate('wono',tmpCDS2.FieldByName('sfb01').AsString,[]) then
          begin
            tmpCDS1.Edit;
            tmpCDS1.FieldByName('wostation').AsInteger:=g_WonoNormalFlag;
            tmpCDS1.Post;
          end;
          tmpCDS2.Next;
        end;
        Result:=CDSPost(tmpCDS1, 'MPS010');
      finally
        tmpCDS2.Free;
        g_ProgressBar.Visible:=False;
      end;
    end;
  finally
    tmpCDS1.Free;
  end;
end;

procedure TFrmMPSR020.SetToolBar;
var
  isEdit:Boolean;
begin
  inherited;
  isEdit:=CDS.State in [dsInsert,dsEdit];
  SetPnlRightBtn(PnlRight, isEdit);
end;

procedure TFrmMPSR020.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:=' select bu,simuver,citem,wono,machine,sdate,currentboiler,orderdate,'
         +' orderno,orderitem,materialno,orderqty,sqty,stealno,custno,custom,'
         +' adate_new,orderno2,orderitem2,materialno1,pnlsize1,pnlsize2,premark,'
         +' bz_date,wostation,wostation_qtystr,wostation_d1str,wostation_d2str,'
         +' sy_date,xy_date,cx_date,cb_style,co_str from MPS010'
         +' where bu='+Quotedstr(g_UInfo^.BU)
         +' and len(isnull(wono,''''))>0 '+strFilter;
  if not l_qry then
     tmpSQL:=tmpSQL+' and Isnull(wostation,0)<'+IntToStr(g_WonoErrorFlag);
  tmpSQL:=tmpSQL+' order by machine,jitem,oz,materialno,simuver,citem';
  if QueryBySQL(tmpSQL, Data) then
  begin
    if not Assigned(l_MPS_IcoFlag) then
       l_MPS_IcoFlag:=TMPS_IcoFlag.Create;
    l_MPS_IcoFlag.Data:=Data;
    CDS.Data:=l_MPS_IcoFlag.Data;
  end;
  l_qry:=False;

  inherited;
end;

procedure TFrmMPSR020.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR020';
  p_GridDesignAns:=True;
  
  inherited;

  Label3.Caption:=CheckLang('淺灰色:未報工    深灰色:已報工    綠色:當站已報工,該下一站報工    黃色:提醒    紅色:超時');
  l_Img:=TBitmap.Create;
end;

procedure TFrmMPSR020.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_MPS_IcoFlag) then
     FreeAndNil(l_MPS_IcoFlag);
  FreeAndNil(l_Img);
end;

procedure TFrmMPSR020.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmMPSR020.btn_mpsr020AClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定更新生產進度嗎?',33)=IDCancel then
     Exit;
  SetBtnEnabled(False);
  if PostBySQL('exec dbo.proc_UpdateWostation '+Quotedstr(g_UInfo^.BU)) then
     ShowMsg('更新完畢,請重新查詢顯示資料!', 64);
  SetBtnEnabled(True);
end;

procedure TFrmMPSR020.btn_mpsr020BClick(Sender: TObject);
begin
  inherited;
  if ShowMsg('確定更新工單結案嗎?',33)=IDCancel then
     Exit;
  SetBtnEnabled(False);
  if SameText(g_UInfo^.BU, 'ITEQDG') then
  begin
    if UpdateWostation1('ITEQDG') then
    if UpdateWostation1('ITEQGZ') then
       ShowMsg('更新完畢,請重新查詢顯示資料!', 64);
  end else
  begin
    if UpdateWostation1(g_UInfo^.BU) then
       ShowMsg('更新完畢,請重新查詢顯示資料!', 64);
  end;
  SetBtnEnabled(True);
end;

procedure TFrmMPSR020.btn_mpsr020CClick(Sender: TObject);
var
  i:Integer;
  P:TBookmark;
  procedure UpdateData();
  begin
    CDS.Edit;
    CDS.FieldByName('Wostation').AsInteger:=g_WonoErrorFlag+
      CDS.FieldByName('Wostation').AsInteger;
    CDS.Post;
  end;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if ShowMsg('確定進行工單強制結案嗎?', 33)=IdCancel then
     Exit;

  if DBGridEh1.SelectedRows.Count>0 then
  begin
    P:=CDS.GetBookmark;
    CDS.DisableControls;
    try
    for i:=0 to DBGridEh1.SelectedRows.Count -1 do
    begin
      CDS.GotoBookmark(Pointer(DBGridEh1.SelectedRows[i]));
      UpdateData;
    end;
    finally
      CDS.GotoBookmark(P);
      CDS.EnableControls;
    end;
  end else
    UpdateData;

  if PostBySQLFromDelta(CDS, 'MPS010', 'bu,simuver,citem') then
     ShowMsg('結案完畢!', 64)
  else if CDS.ChangeCount>0 then
    CDS.CancelUpdates;
end;

procedure TFrmMPSR020.btn_mpsr020DClick(Sender: TObject);
var
  tmpStr:string;
begin
  inherited;
  l_qry:=True;
  try
    if not InputQuery(CheckLang('請輸入工單號碼'), 'wono', tmpStr) then
       Exit;
    if tmpStr = '' then
       Exit;
    tmpStr:=' and wono='+Quotedstr(tmpStr);
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  finally
    l_qry:=False;
  end;
end;

procedure TFrmMPSR020.btn_mpsr020EClick(Sender: TObject);
begin
  inherited;
  if not Assigned(FrmMPSR020_remark) then
     FrmMPSR020_remark:=TFrmMPSR020_remark.Create(Application);
  if CDS.Active then
  begin
    FrmMPSR020_remark.Edit1.Text:=CDS.FieldByName('Wono').AsString;
    FrmMPSR020_remark.Memo1.Text:=CDS.FieldByName('Remark').AsString;
    FrmMPSR020_remark.Memo2.Text:=CDS.FieldByName('Remark2').AsString;
    if not CDS.IsEmpty then
       if SameText(CDS.FieldByName('Machine').AsString,'L6') then
          FrmMPSR020_remark.rgp.ItemIndex:=1
       else
          FrmMPSR020_remark.rgp.ItemIndex:=0;
  end;
  FrmMPSR020_remark.ShowModal;
end;

procedure TFrmMPSR020.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  P:TPoint;
  fName:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  fName:=LowerCase(Column.FieldName);
  if Pos('/'+fName+'/', '/s1/s2/s3/s4/s5/s6/s7/')>0 then
  begin
    ImageList2.GetBitmap(CDS.FieldByName(fName+'_ico').AsInteger, l_Img);
    with DBGridEh1.Canvas do
    begin
      FillRect(Rect);
      P.X:=round((Rect.Left+Rect.Right-l_Img.Width)/2)-10;
      P.Y:=round((Rect.Top+Rect.Bottom-l_Img.Height)/2);
      Draw(P.X, P.Y, l_Img);
      TextOut(P.X+l_Img.Width+2, P.Y+2, CDS.FieldByName(fName).AsString);
    end;
  end;
end;

procedure TFrmMPSR020.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPSR020.DBGridEh1DblClick(Sender: TObject);
begin
  inherited;
  with DBGridEh1 do
  begin
    if Tag=0 then
    begin
      Tag:=1;
      Options:=Options+[dgRowSelect,dgMultiSelect]-[dgEditing];
    end else
    begin
      Tag:=0;
      Options:=Options-[dgRowSelect,dgMultiSelect]+[dgEditing];
    end;
  end;
end;

end.
