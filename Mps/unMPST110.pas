{*******************************************************}
{                                                       }
{                unMPST110                              }
{                Author: kaikai                         }
{                Create date: 2020/9/11                 }
{                Description: 重工工單產生作業          }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST110;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin, StrUtils, unMPST110_Wono;

type
  TFrmMPST110 = class(TFrmSTDI041)
    btn_mpst110: TToolButton;
    chkAll: TCheckBox;
    btn_mpst110_export: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure chkAllClick(Sender: TObject);
    procedure btn_mpst110Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_mpst110_exportClick(Sender: TObject);
  private
    { Private declarations }
    l_SelEdit:Boolean;
    l_StrIndex,l_StrIndexDesc:string;
    l_MPST110_Wono:TMPST110_Wono;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST110: TFrmMPST110;

implementation

uses unGlobal, unCommon, unFind, ComObj, unMPST110_WonoList, unMPST110_Dtp;

{$R *.dfm}

procedure TFrmMPST110.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  chkAll.Tag:=1;
  chkAll.Checked:=False;
  try
    tmpSQL:='Select GarbageFlag as ''select'',* From dli010 Where Bu='+Quotedstr(g_UInfo^.Bu)+' '+strFilter
           +' And Len(IsNull(W_pno,''''))>0 And IsNull(W_qty,0)>0 And Len(IsNull(Remark5,''''))=0'
           +' And IsNull(QtyColor,0)<>'+IntToStr(g_CocData) //g_CocData:coc匯入的資料
           +' And IsNull(GarbageFlag,0)=0'
           +' And Len(IsNull(Dno_Ditem,''''))=0';
    if SameText(g_UInfo^.BU, 'ITEQDG') then
       tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Stime,Custno,Custshort,Units,Pno,Orderno,Orderitem,Sno'
    else
       tmpSQL:=tmpSQL+' Order By Indate,InsFlag,Custno,Custshort,Units,right(Pno,1),Pno,Orderno,Orderitem,Sno';
    if QueryBySQL(tmpSQL, Data) then
       CDS.Data:=Data;
  finally
    chkAll.Tag:=0;
  end;
  inherited;
end;

procedure TFrmMPST110.FormCreate(Sender: TObject);
begin
  p_SysId:='MPS';
  p_TableName:='DLI010';
  p_GridDesignAns:=True;

  btn_mpst110_export.Left:=btn_quit.Left;
  btn_mpst110_export.Visible:=g_MInfo^.R_edit;

  btn_mpst110.Left:=btn_quit.Left;
  btn_mpst110.Visible:=g_MInfo^.R_edit;

  inherited;
end;

procedure TFrmMPST110.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Assigned(l_MPST110_Wono) then
     FreeAndNil(l_MPST110_Wono);
end;

procedure TFrmMPST110.CDSAfterPost(DataSet: TDataSet);
begin
  inherited;
  if not l_SelEdit then
     PostBySQLFromDelta(CDS, p_TableName, 'Bu,Dno,Ditem');
end;

procedure TFrmMPST110.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    //應出數量與對貨數量相減
    if Pos('Qry_qty', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_qty', 'isnull(Notcount1,0)-isnull(Chkcount,0)', [rfIgnoreCase]);
    if Pos('Qry_ppccl', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_ppccl', '(Case When Left(Sizes,1)=''R'' Then 0 Else 1 End)', [rfIgnoreCase]);
    if Pos('Qry_isbz', tmpStr)>0 then
       tmpStr:=StringReplace(tmpStr, 'Qry_isbz', 'dbo.Get_Isbz(bu,orderno,orderitem)', [rfIgnoreCase]);
    if Length(tmpStr)=0 then
       tmpStr:=' And Indate='+Quotedstr(DateToStr(Date));
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmMPST110.DBGridEh1CellClick(Column: TColumnEh);
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    l_SelEdit:=True;
    try
      CDS.Edit;
      CDS.FieldByName('select').AsBoolean:=not CDS.FieldByName('select').AsBoolean;
      CDS.Post;
      CDS.MergeChangeLog;
    finally
      l_SelEdit:=False;
    end;
  end;
end;

procedure TFrmMPST110.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST110.DBGridEh1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift=[ssCtrl]) and (Key=70) then               //Ctrl+F 查找
  begin
    if not Assigned(FrmFind) then
       FrmFind:=TFrmFind.Create(Application);
    with FrmFind do
    begin
      g_SrcCDS:=Self.CDS;
      g_Columns:=Self.DBGridEh1.Columns;
      g_DefFname:=Self.DBGridEh1.SelectedField.FieldName;
      g_DelFname:='select,w_qty,indate,sno,adate,odate,stime,orderitem,longitude,'
                 +'latitude,notcount1,delcount1,coccount1,chkcount,remain_ordqty,kg';
    end;
    FrmFind.ShowModal;
    Key:=0; //DBGridEh自帶的查找
  end;
end;

procedure TFrmMPST110.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if not CDS.Active then
     Exit;
  if SameText(Column.FieldName, 'Chkcount') then
  case CDS.FieldByName('QtyColor').AsInteger of
    1:Background:=clLime;
    2:Background:=clYellow;
    3:Background:=clFuchsia;
    4:Background:=clAqua;
    5:Background:=RGB(255,165,0);
  end;
  if CDS.FieldByName('Sdate_err').AsBoolean and
     (Pos(LowerCase(Column.FieldName), 'remark1/remark2/remark3')>0) then
     Background:=clOlive;
  if CDS.FieldByName('InsFlag').AsBoolean then                   //插單
     AFont.Color:=clRed;
end;

procedure TFrmMPST110.chkAllClick(Sender: TObject);
var
  tmpCDS:TClientDataSet;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (TCheckBox(Sender).Tag<>0) then
     Exit;

  l_SelEdit:=True;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    with tmpCDS do
    begin
      while not Eof do
      begin
        Edit;
        FieldByName('select').AsBoolean:=TCheckBox(Sender).Checked;
        Post;
        Next;
      end;
      MergeChangeLog;
    end;

    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    CDS.Data:=tmpCDS.Data;
  finally
    FreeAndNil(tmpCDS);
    l_SelEdit:=False;
  end;
end;

procedure TFrmMPST110.btn_mpst110Click(Sender: TObject);
var
  i:Integer;
  tmpStr,tmpAllWono,tmpS1,tmpS2:string;
  OrdWono:TOrderWono;
  tmpCDS:TClientDataSet;
  dsNE:TDataSetNotifyEvent;
begin
  inherited;
  if Pos(LowerCase(g_UInfo^.BU),'iteqdg,iteqgz')=0 then
  begin
    ShowMsg('此程式只適用于ITEQDG/ITEQGZ!',48);
    Exit;
  end;

  if (not CDS.Active) or CDS.IsEmpty then
  begin
    ShowMsg('請選擇單據!',48);
    Exit;
  end;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=CDS.Data;
    with tmpCDS do
    begin
      Filtered:=False;
      Filter:='select=1';
      Filtered:=True;
      if IsEmpty then
      begin
        ShowMsg('請選擇單據!',48);
        Exit;
      end;

      First;
      while not Eof do
      begin
        tmpStr:=DateToStr(FieldByName('indate').AsDateTime)+'/'+IntToStr(FieldByName('sno').AsInteger)+':';

        if Length(Trim(FieldByName('w_pno').AsString))=0 then
        begin
          Self.CDS.Locate('bu;dno;ditem', VarArrayOf([FieldByName('bu').AsString,
                       FieldByName('dno').AsString,
                       FieldByName('ditem').AsString]), []);
          ShowMsg(tmpStr+'選中的單據未輸入重工料號!',48);
          Exit;
        end;

        if FieldByName('w_qty').AsFloat<=0 then
        begin
          Self.CDS.Locate('bu;dno;ditem', VarArrayOf([FieldByName('bu').AsString,
                       FieldByName('dno').AsString,
                       FieldByName('ditem').AsString]), []);
          ShowMsg(tmpStr+'選中的單據重工數量錯誤!',48);
          Exit;
        end;

        if Length(FieldByName('pno').AsString)<>Length(FieldByName('w_pno').AsString) then
        begin
          ShowMsg(tmpStr+'生產料號與備料料號長度不符!',48);
          Exit;
        end;

        tmpS1:=Copy(FieldByName('pno').AsString,2,1);
        tmpS2:=Copy(FieldByName('w_pno').AsString,2,1);
        if tmpS1<>tmpS2 then
        begin
          ShowMsg(tmpStr+'膠系不符!',48);
          Exit;
//          if (tmpS1='9') and (tmpS2='X') then
//             tmpS1:='@@'
//          else if (tmpS1='X') and (tmpS2='9') then
//             tmpS1:='@@';
//          if tmpS1<>'@@' then
//          begin
//            ShowMsg(tmpStr+'膠系不符(膠系須一致,或9與X)!',48);
//            Exit;
//          end;
        end;



        if Pos(LeftStr(FieldByName('pno').AsString,1),'ET')>0 then
        begin
          tmpS1 := Copy(FieldByName('pno').AsString, 3, 4);
          tmpS2 := Copy(FieldByName('w_pno').AsString, 3, 4);
          if Abs(StrToIntDef(tmpS1, 0) - StrToIntDef(tmpS2, 0)) > 10 then
          begin
            ShowMsg(tmpStr + '板厚不符(超出範圍±1mil)!', 48);
            Exit;
          end;

          tmpS1:=Copy(FieldByName('pno').AsString,7,2);
          tmpS2:=Copy(FieldByName('w_pno').AsString,7,2);
          if tmpS1<>tmpS2 then
          begin
            ShowMsg(tmpStr+'銅厚不符(銅厚須一致)!',48);
            Exit;
          end;

          tmpS1:=LeftStr(RightStr(FieldByName('pno').AsString,3),1);
          tmpS2:=LeftStr(RightStr(FieldByName('w_pno').AsString,3),1);
          if tmpS1<>tmpS2 then
          begin
            ShowMsg(tmpStr+'結構不符(結構須一致)!',48);
            Exit;
          end;

          tmpS1:=Copy(FieldByName('pno').AsString,9,3);
          tmpS2:=Copy(FieldByName('w_pno').AsString,9,3);
          if StrToInt(tmpS1)>StrToInt(tmpS2) then
          begin
            ShowMsg(tmpStr+'尺寸不符(不可小尺寸重工大尺寸)!',48);
            Exit;
          end;



          tmpS1:=LeftStr(RightStr(FieldByName('pno').AsString,2),1);
          tmpS2:=LeftStr(RightStr(FieldByName('w_pno').AsString,2),1);
          ShowMsg('S1:'+tmpS1+'  S2:'+tmpS2);
          if tmpS1<>tmpS2 then
          begin
            if not (((Pos(tmpS1,'RI74')>0) and (Pos(tmpS2,'RI74')>0)) or
                   ((Pos(tmpS1,'CW6')>0) and (Pos(tmpS2,'CW6')>0)) or
                   ((Pos(tmpS1,'ik')>0) and (Pos(tmpS2,'ik')>0)))
            then
            begin
              ShowMsg(tmpStr+'銅箔不符!',48);
              Exit;
            end;
//            if (Pos(tmpS1,'RI74')>0) and (Pos(tmpS2,'RI74')=0) then
//            begin
//              ShowMsg(tmpStr+'[RI74]備料檔中的銅箔和生產料號中的銅箔不可替代!',48);
//              Exit;
//            end;
//
//            if (Pos(tmpS1,'WC63')>0) and (Pos(tmpS2,'WC63')=0) then
//            begin
//              ShowMsg(tmpStr+'[WC63]備料檔中的銅箔和生產料號中的銅箔不可替代!',48);
//              Exit;
//            end;
//
//            if (Pos(tmpS1,'PS')>0) and (Pos(tmpS2,'PS')=0) then
//            begin
//              ShowMsg(tmpStr+'[PS]備料檔中的銅箔和生產料號中的銅箔不可替代!',48);
//              Exit;
//            end;
//
//            if (Pos(tmpS1,'1JL')>0) and (Pos(tmpS2,'1JL')=0) then
//            begin
//              ShowMsg(tmpStr+'[1JL]備料檔中的銅箔和生產料號中的銅箔不可替代!',48);
//              Exit;
//            end;
          end;


        end else
        begin
//          tmpS1:=Copy(FieldByName('pno').AsString,2,1);
//          tmpS2:=Copy(FieldByName('w_pno').AsString,2,1);
//          if tmpS1<>tmpS2 then
//          begin
//            ShowMsg(tmpStr+'膠系不符(膠系須一致,或9與X)!',48);
//            Exit;
//          end;

          tmpS1:=Copy(FieldByName('pno').AsString,4,4);
          tmpS2:=Copy(FieldByName('w_pno').AsString,4,4);
          if tmpS1<>tmpS2 then
          begin
            if not ((Pos(tmpS1, '3313,2313') > 0) and (Pos(tmpS2, '3313,2313') > 0)) then
            begin
              ShowMsg(tmpStr + '規格不符!', 48);
              Exit;
            end;
          end;

          tmpS1:=Copy(FieldByName('pno').AsString,8,3);
          tmpS2:=Copy(FieldByName('w_pno').AsString,8,3);
          if Abs(StrToIntDef(tmpS1,0)-StrToIntDef(tmpS2,0))>10 then
          begin
            ShowMsg(tmpStr+'RC不符(超出範圍±1)!',48);
            Exit;
          end;
        end;

        Next;
      end;

      if RecordCount>50 then
      begin
        ShowMsg('最多可選50筆,請重新選擇!',48);
        Exit;
      end;

      if ShowMsg('確定產生重工工單嗎?',33)=IdCancel then
         Exit;

      i:=1;
      tmpAllWono:='';
      First;
      while not Eof do
      begin
        OrdWono.Orderno:=FieldByName('orderno').AsString;
        OrdWono.Orderitem:=FieldByName('orderitem').AsString;
        OrdWono.FstCode1:=Copy(FieldByName('w_pno').AsString,1,1);
        OrdWono.FstCode2:=Copy(FieldByName('pno').AsString,1,1);
        OrdWono.Pno:=FieldByName('pno').AsString;        //主檔料號
        OrdWono.W_pno:=FieldByName('w_pno').AsString;    //明細檔料號
        OrdWono.W_qty:=FieldByName('w_qty').AsFloat;
        OrdWono.IsDG:=SameText(g_UInfo^.BU, 'ITEQDG');

        //RL換成M
        if (Pos(OrdWono.FstCode1,'BR')>0) and (Length(OrdWono.W_pno)=18) then
           OrdWono.W_qty:=OrdWono.W_qty*StrToIntDef(Copy(OrdWono.W_pno,11,3),1);

        if not Assigned(l_MPST110_Wono) then
           l_MPST110_Wono:=TMPST110_Wono.Create;

        if i=1 then
        if not l_MPST110_Wono.Init(OrdWono.IsDG) then
           Exit;

        tmpStr:='  '+IntToStr(i)+'/'+IntToStr(RecordCount);
        if l_MPST110_Wono.SetWono(OrdWono, tmpStr) then
        begin
          tmpAllWono:=tmpAllWono+#13#10+tmpStr;
          Edit;
          FieldByName('Sno').AsInteger:=-1;
          FieldByName('Remark5').AsString:=tmpStr;
          Post;
        end;

        Inc(i);

        Next;
      end;
    end;

    //儲存
    if l_MPST110_Wono.Post(OrdWono.IsDG) then
    begin
      Self.CDS.DisableControls;
      dsNE:=Self.CDS.AfterScroll;
      Self.CDS.AfterScroll:=nil;
      try
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            if FieldByName('Sno').AsInteger=-1 then
            if Self.CDS.Locate('bu;dno;ditem', VarArrayOf([FieldByName('bu').AsString,
               FieldByName('dno').AsString,
               FieldByName('ditem').AsString]), []) then
            begin
              Self.CDS.Edit;
              Self.CDS.FieldByName('Remark5').AsString:=FieldByName('Remark5').AsString;
              Self.CDS.Post;
            end;
            Next;
          end;
        end;
      finally
         Self.CDS.EnableControls;
         Self.CDS.AfterScroll:=dsNE;
         Self.CDS.AfterScroll(Self.CDS);
      end;

      if not Assigned(FrmMPST110_WonoList) then
         FrmMPST110_WonoList:=TFrmMPST110_WonoList.Create(Self);
      FrmMPST110_WonoList.Memo1.Text:='自動產生工單完畢,工單單號：'+tmpAllWono;
      FrmMPST110_WonoList.ShowModal;
    end else
    begin
      if not Assigned(FrmMPST110_WonoList) then
         FrmMPST110_WonoList:=TFrmMPST110_WonoList.Create(Self);
      FrmMPST110_WonoList.Memo1.Text:='自動產生工單失敗,請檢查下列工單單號：'+tmpAllWono;
      FrmMPST110_WonoList.ShowModal;
    end;

  finally
    FreeAndNil(tmpCDS);
    g_StatusBar.Panels[0].Text:='';
  end;
end;

procedure TFrmMPST110.btn_mpst110_exportClick(Sender: TObject);
begin
  inherited;

  FrmMPST110_Dtp:=TFrmMPST110_Dtp.Create(nil);
  FrmMPST110_Dtp.dtp1.Date := date + 1;
  
  try
    FrmMPST110_Dtp.ShowModal;
  finally
    FreeAndNil(FrmMPST110_Dtp);
  end;

end;

end.
