{*******************************************************}
{                                                       }
{                unMPST020                              }
{                Author: kaikai                         }
{                Create date: 2015/3/27                 }
{                Description: ���ͤu��                  }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST020;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, unMPST020_Wono;

type
  TFrmMPST020 = class(TFrmSTDI041)
    btn_mpst020A: TToolButton;
    btn_mpst020B: TToolButton;
    cdsList: TClientDataSet;
    cdsListditem: TIntegerField;
    cdsListdno: TStringField;
    cdsListregulateQty: TIntegerField;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure btn_mpst020AClick(Sender: TObject);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn_mpst020BClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private    { Private declarations }
    l_StrIndex, l_StrIndexDesc: string;
    l_SelList: TStrings;
    l_MPST020_Wono: TMPST020_Wono;
    procedure SetBtnEnabled(bool: Boolean);
    function GetDG_GZCustno(var DGCustno, GZCustno: string): Boolean;
    procedure DG;
    function GetADate(Bu, Orderno, Orderitem: string): TDateTime;    //�g�J�ͺ޹F����
  public    { Public declarations }
  protected
    procedure RefreshDS(strFilter: string); override;
  end;

var
  FrmMPST020: TFrmMPST020;

implementation

uses
  unGlobal, unCommon, unMPST020_WonoList, unMPST020_Orderno2;


{$R *.dfm}

procedure TFrmMPST020.SetBtnEnabled(bool: Boolean);
begin
  btn_mpst020A.Enabled := bool;
  btn_mpst020B.Enabled := bool;
end;

//�F��B�s�{�U��Ȥ�,��^False��ܿ��~
function TFrmMPST020.GetDG_GZCustno(var DGCustno, GZCustno: string): Boolean;
var
  tmpSQL: string;
  tmpCDS: TClientDataSet;
  Data: OleVariant;
begin
  Result := False;
  DGCustno := '';
  DGCustno := '';
  tmpSQL := 'Select Upper(Custno) C1,isDG From MPS250' + ' Where Bu=' + Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data) then
    Exit;

  tmpCDS := TClientDataSet.Create(nil);
  try
    tmpCDS.Data := Data;
    with tmpCDS do
      while not Eof do
      begin
        if Fields[1].AsBoolean then
          DGCustno := DGCustno + Fields[0].AsString + '/'
        else
          GZCustno := GZCustno + Fields[0].AsString + '/';
        Next;
      end;
    if DGCustno <> '' then
      DGCustno := '/' + DGCustno;
    if GZCustno <> '' then
      GZCustno := '/' + GZCustno;
    Result := True;
  finally
    FreeAndNil(tmpCDS);
  end;
end;

procedure TFrmMPST020.RefreshDS(strFilter: string);
var
  tmpSQL: string;
  Data: OleVariant;
begin
  tmpSQL := 'Select * From MPS010 Where Bu=' + Quotedstr(g_UInfo^.BU) + ' ' + strFilter + ' And IsNull(EmptyFlag,0)=0' + ' And IsNull(ErrorFlag,0)=0' + ' And IsNull(Case_ans2,0)=0' + ' And IsNull(Wostation,0)<' + IntToStr(g_WonoErrorFlag) + ' Order BY Machine,Jitem,OZ,Materialno,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
    CDS.Data := Data;

  inherited;
end;

procedure TFrmMPST020.FormCreate(Sender: TObject);
begin
  p_SysId := 'Mps';
  p_TableName := 'MPS010';
  p_GridDesignAns := True;
  btn_mpst020A.Visible := SameText(g_UInfo^.BU, 'ITEQDG') and g_MInfo^.R_edit;
  btn_mpst020B.Visible := g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
    btn_quit.Left := btn_mpst020B.Left + btn_mpst020B.Width;
  cdsList.CreateDataSet;
  inherited;

  l_SelList := TStringList.Create;
end;

procedure TFrmMPST020.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SelList);
  if Assigned(l_MPST020_Wono) then
    FreeAndNil(l_MPST020_Wono);
end;

procedure TFrmMPST020.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST020.btn_queryClick(Sender: TObject);
var
  tmpStr: string;
begin
//  inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    l_SelList.Clear;
    cdsList.EmptyDataSet;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmMPST020.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr: string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
    Exit;

  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) = -1 then
    begin
      l_SelList.Add(tmpStr);
      cdsList.Append;
      cdsListdno.value := CDS.FieldByName('Orderno').AsString;
      cdsListditem.value := CDS.FieldByName('OrderItem').AsInteger;
      cdsListregulateQty.Value := CDS.FieldByName('regulateQty').AsInteger;
    end
    else
    begin
      l_SelList.Delete(l_SelList.IndexOf(tmpStr));
      if cdsList.Locate('dno;ditem', VarArrayOf([CDS.FieldByName('Orderno').AsString, CDS.FieldByName('OrderItem').AsInteger]), []) then
        cdsList.Delete;
    end;
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST020.DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
var
  tmpStr: string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr := CDS.FieldByName('Simuver').AsString + '@' + CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) <> -1 then
      DBGridEh1.Canvas.TextOut(Round((Rect.Left + Rect.Right) / 2) - 6, Round((Rect.Top + Rect.Bottom) / 2 - 6), 'V');
  end;
end;

procedure TFrmMPST020.btn_mpst020AClick(Sender: TObject);
begin
  inherited;
  FrmMPST020_Orderno2 := TFrmMPST020_Orderno2.Create(nil);
  try
    FrmMPST020_Orderno2.ShowModal;
  finally
    FreeAndNil(FrmMPST020_Orderno2);
  end;
end;

procedure TFrmMPST020.btn_mpst020BClick(Sender: TObject);
begin
  inherited;
  if SameText(g_UInfo^.BU, 'ITEQDG') then
    DG
  else
    ShowMsg('���{�����i�ϥ�!', 48);
end;

procedure TFrmMPST020.DG;
const
  strCD = '/AC121/AC820/ACA97/AC526/AC305/AC625/'; //AC625 �s�{�ֱ�
var
  i, j: Integer;
  tmpStr, tmpSql, tmpSql2, tmpAllWono, strDGCustno, strGZCustno, msg: string;
  OrdWono: TOrderWono;
  Data, Data2: OleVariant;
  tmpCDS, tmpCDS2: TClientDataSet;
  str_result: Boolean;
//  orderls:TStrings;
begin
  inherited;

  if (l_SelList.Count = 0) or (l_SelList.Count > 50) then
  begin
    ShowMsg('�п�ܭn���ͤu�檺�Ƶ{���,�̦h�i���50��!', 48);
    Exit;
  end;

  if ShowMsg('�T�w���ͤu���?', 33) = IdCancel then
    Exit;

  if not cdsList.IsEmpty then
  begin
    cdsList.First;
    while not cdsList.Eof do
    begin
      tmpSql2 := tmpSql2 + ' or (oeb01=' + Quotedstr(cdsListdno.AsString) + ' and oeb03=' + cdsListditem.AsString + ')';
      cdsList.Next;
    end;
    Delete(tmpSql2, 1, 3);         
  {(*}
    tmpSql2:='  select j.*,pml20 from '+
              ' (select u.*,sfb08 from'+
              ' (select t.*,oao06 from' +
              ' (select z.*,ima02,ima25 from' +
              ' (select y.*,occ02 from' +
              ' (select x.*,oea04 from' +
              ' (select * from oeb_file where ' + tmpSql2 + ') x,oea_file' +
              ' where oeb01=oea01) y,occ_file where oea04=occ01) z,ima_file where oeb04=ima01) t' +
              ' left join oao_file on oeb01=oao01 and oeb03=oao03)u' +
              ' left join (select sfb22,sfb221,sum(sfb08)sfb08 from sfb_file where sfbacti=''Y'' and (sfb01 like ''516-%'' or sfb01 like ''51T-%'') group by sfb22,sfb221)j on oeb01=sfb22 and oeb03=sfb221)j ' +
              ' left join (select pml06,sum(pml20)pml20 from pml_file,pmk_file where pmk01=pml01 and pmkacti=''Y'' and pmk09<>''N012'' and pmk09<>''N005''  group by pml06)k on pml06 like oeb01||''-''||oeb03||''%'' ';
    {*)}
    if not QueryBySQL(tmpSql2, Data2, 'ORACLE') then
      Exit;
  end;

  tmpStr := '';
  for i := 0 to l_SelList.Count - 1 do
  begin
    if tmpStr <> '' then
      tmpStr := tmpStr + ',';
    tmpStr := tmpStr + Quotedstr(l_SelList.Strings[i])
  end;
  tmpStr := 'Select Simuver,Citem,Wono,Machine,Materialno,Custno,Sqty,' + ' Orderno,Orderitem,Orderno2,Orderitem2,SrcFlag,Premark,Premark2 From ' + p_TableName + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Simuver+''@''+Cast(Citem as varchar(10)) in (' + tmpStr + ')';
  if not QueryBySQL(tmpStr, Data) then
    Exit;

  SetBtnEnabled(False);
  CDS.DisableControls;
  tmpCDS := TClientDataSet.Create(nil);
  if not cdsList.IsEmpty then
    tmpCDS2 := TClientDataSet.Create(nil);
//  orderls:=TStringList.Create;
  try
    tmpCDS.Data := Data;
    if not cdsList.IsEmpty then
      tmpCDS2.Data := Data2;
    if tmpCDS.RecordCount <> l_SelList.Count then
    begin
      ShowMsg('��Ƥ��P�B,�Э��s�d�߸��!', 48);
      Exit;
    end;

    tmpStr := '';
    with tmpCDS do
    begin
      while not Eof do
      begin
        if (Length(FieldByName('Orderno').AsString) = 0) or (FieldByName('Orderitem').AsInteger < 1) then
        begin
          ShowMsg('����g�q�渹�X�ζ���!', 48);
          Exit;
        end;

        if Length(FieldByName('Wono').AsString) > 0 then
        begin
          ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']�w�}�u��!', 48);
          Exit;
        end;

        if (tmpStr <> '') and (tmpStr <> FieldByName('Machine').AsString) then
        begin
          ShowMsg('���i��u���ͤu��!', 48);
          Exit;
        end;

        tmpStr := CDS.FieldByName('Machine').AsString;

        if Pos(tmpStr, 'L1,L2,L3,L4,L5') > 0 then
          if Pos(RightStr(FieldByName('materialno').AsString, 1), g_DGLastCode) = 0 then
          begin
            ShowMsg('�F�𲣥ͤu����X���G' + g_DGLastCode, 48);
            Exit;
          end;

        if SameText(tmpStr, 'L6') then
          if Pos(RightStr(FieldByName('materialno').AsString, 1), g_GZLastCode) = 0 then
          begin
            ShowMsg('�s�{���ͤu����X���G' + g_GZLastCode, 48);
            Exit;
          end;

        Next;
      end;
    end;

    //�s�{�U��Ȥ�
    if not GetDG_GZCustno(strDGCustno, strGZCustno) then
      Exit;

    //�P�_�F��B�s�{�U��Ȥ�2���q���g�O�_���T
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        tmpStr := '/' + UpperCase(FieldByName('Custno').AsString) + '/';
        if (Pos(tmpStr, strDGCustno) = 0) and (Pos(tmpStr, strGZCustno) = 0) then
        begin
          ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + '�U��Ȥ�]�w�L���Ȥ�' + tmpStr, 48);
          Exit;
        end
        else if (Pos(tmpStr, strDGCustno) > 0) and (Pos(tmpStr, strGZCustno) > 0) then //�o�����p��ƪ�]�p�w�ư�
        begin
          ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + '�U��Ȥ�]�w�Ȥ᭫�|' + tmpStr, 48);
          Exit;
        end;

        //strCD:�R�F�Ȥ�S��
        if Pos(tmpStr, strCD) > 0 then
        begin
          if FieldByName('SrcFlag').AsInteger in [1, 3, 5] then  //dg�q��
          begin
            //6�u:GZ�Ͳ�
            if SameText(FieldByName('Machine').AsString, 'L6') then
            begin
              if (Length(FieldByName('Orderno2').AsString) = 0) or (FieldByName('Orderitem2').AsInteger < 1) then
              begin
                ShowMsg('DG�R�F�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'GZ�Ͳ�������g�⨤�q�渹�X�ζ���' + tmpStr, 48);
                Exit;
              end;
            end
            else
            begin
              if (Length(FieldByName('Orderno2').AsString) > 0) or (not FieldByName('Orderitem2').IsNull) then
              begin
                ShowMsg('DG�R�F�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'DG�Ͳ����ζ�g�⨤�q�渹�X�ζ���' + tmpStr, 48);
                Exit;
              end;
            end;
          end
          else   //gz�q��
          begin
            //6�u:GZ�Ͳ�
            if SameText(FieldByName('Machine').AsString, 'L6') then
            begin
              if (Length(FieldByName('Orderno2').AsString) > 0) or (not FieldByName('Orderitem2').IsNull) then
              begin
                ShowMsg('GZ�R�F�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'GZ�Ͳ����ζ�g�⨤�q�渹�X�ζ���' + tmpStr, 48);
                Exit;
              end;
            end
            else if (Length(FieldByName('Orderno2').AsString) = 0) or (FieldByName('Orderitem2').AsInteger < 1) then
            begin
              ShowMsg('GZ�R�F�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'DG�Ͳ�������g�⨤�q�渹�X�ζ���' + tmpStr, 48);
              Exit;
            end;
          end;
        end
        else //�䥦�Ȥ�
        begin
          //6�u:GZ�Ͳ�
          if SameText(FieldByName('Machine').AsString, 'L6') then
          begin
            //gz�Ȥᤣ�i��g2���q��
            if (Pos(tmpStr, strGZCustno) > 0) and ((Length(FieldByName('Orderno2').AsString) > 0) or (not FieldByName('Orderitem2').IsNull)) then
            begin
              ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'GZ�Ȥᤣ�ζ�g�⨤�q�渹�X�ζ���' + tmpStr, 48);
              Exit;
            end;

            //dg�Ȥ�@�w�n�g2���q��
            if (Pos(tmpStr, strDGCustno) > 0) and ((Length(FieldByName('Orderno2').AsString) = 0) or (FieldByName('Orderitem2').AsInteger < 1)) then
            begin
              ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'DG�Ȥ᥼��g�⨤�q�渹�X�ζ���' + tmpStr, 48);
              Exit;
            end;
          end
          else  //L1~L5�u:DG�Ͳ�
          begin
            //gz�Ȥ�@�w�n�g2���q��
            if (Pos(tmpStr, strGZCustno) > 0) and ((Length(FieldByName('Orderno2').AsString) = 0) or (FieldByName('Orderitem2').AsInteger < 1)) then
            begin
              ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'GZ�Ȥ᥼��g�⨤�q�渹�X�ζ���' + tmpStr, 48);
              Exit;
            end;

            //dg�Ȥᤣ�i��g2���q��
            if (Pos(tmpStr, strDGCustno) > 0) and ((Length(FieldByName('Orderno2').AsString) > 0) or (not FieldByName('Orderitem2').IsNull)) then
            begin
              ShowMsg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']' + 'DG�Ȥᤣ�ζ�g�⨤�q�渹�X�ζ���' + tmpStr, 48);
              Exit;
            end;
          end;
        end;

        if Length(FieldByName('Wono').AsString) = 0 then  //�ˬd�q�渹+�����O�_���}�L�u��
        begin
          tmpStr := CDS.FieldByName('Machine').AsString;
          if Pos(tmpStr, 'L1,L2,L3,L4,L5') > 0 then    //�p�GL1~L5?
          begin
            if length(FieldByName('Orderno2').AsString) = 0 then  //DG�Ͳ�
            begin
              tmpSql := 'Select * From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem').AsString) + ' And len(Wono)>0 ' + ' And Machine>=''' + 'L1' + ''' And Machine <=''' + 'L5' + '''';
            end
            else //�s�{�Ͳ�
            begin
              tmpSql := 'Select * From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno2').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem2').AsString) + ' And len(Wono)>0 ' + ' And Machine>=''' + 'L6' + '''';
            end;
          end
          else
          begin  //L6
            if length(FieldByName('Orderno2').AsString) = 0 then  //GZ�Ͳ�
            begin
              tmpSql := 'Select * From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem').AsString) + ' And len(Wono)>0 ' + ' And Machine=''' + 'L6' + '''';
            end
            else //�s�{�Ͳ�
            begin
              tmpSql := 'Select * From MPS010' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno2').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem2').AsString) + ' And len(Wono)>0 ' + ' And Machine>=''' + 'L1' + ''' And Machine <=''' + 'L5' + '''';
            end;
          end;

          if QueryExists(tmpSql, str_result) and (str_result = true) then
          begin
            if MessageDlg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']�w�}�L�u��,�нT�{�O�_�A���}�ߤu��?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            begin
              Exit;
            end;
          end;
        end;

        if (Length(FieldByName('Wono').AsString) = 0) then  //�ˬd�q�渹+�����O�_���~�ʹLMPST650
        begin
          if (Length(FieldByName('Orderno2').AsString) = 0) and (Length(FieldByName('OrderItem').AsString) = 0) then
          begin
            tmpSql := 'Select * From MPS650' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem').AsString) + ' And OraDB=' + Quotedstr(g_UInfo^.BU);
          end
          else
          begin
            tmpSql := 'Select * From MPS650' + ' Where Bu=' + Quotedstr(g_UInfo^.BU) + ' And Orderno=' + Quotedstr(FieldByName('Orderno2').AsString) + ' And Orderitem=' + Quotedstr(FieldByName('Orderitem2').AsString) + ' And OraDB <> ' + Quotedstr(g_UInfo^.BU);
          end;

          if QueryExists(tmpSql, str_result) and (str_result = true) then
          begin
            if MessageDlg('�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']�w���~�ʰO��,�нT�{�O�_�A���}�ߤu��?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
            begin
              Exit;
            end;
          end;
        end;

        Next;
      end;
    end;

    with tmpCDS do
    begin
      first;
      while not Eof do
      begin   {(*}
        if (not cdsList.IsEmpty) and
           (tmpCDS.FieldByName('machine').AsString <> 'L6') and
           (cdsList.Locate('dno;ditem', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('OrderItem').AsInteger]), [])) and
           (tmpCDS2.Locate('oeb01;oeb03', VarArrayOf([FieldByName('Orderno').AsString, FieldByName('OrderItem').AsInteger]), [])) then  {*)}//�ˬd�q�渹+�����O�_�����ʹLMPST120
        begin
          if (tmpCDS2.FieldByName('sfb08').AsFloat + tmpCDS2.FieldByName('pml20').AsFloat + cdsList.FieldByName('regulateQty').AsFloat) > FieldByName('Sqty').AsFloat then
          begin
            msg := msg + #13'�q��[' + FieldByName('Orderno').AsString + '/' + FieldByName('Orderitem').AsString + ']�ƶq�w�W�L�q��ƶq ' + tmpCDS2.FieldByName('pml20').AsString;
            tmpCDS2.Delete;
            if IDNO = Application.MessageBox(pchar(msg + ',�O�_�~��?'), '����', MB_YESNO + MB_ICONSTOP) then
              exit;
          end;
        end;
        next;
      end;
    end;

    i := 1;
    tmpAllWono := '';
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        OrdWono.Machine := FieldByName('Machine').AsString;
        OrdWono.Pno := FieldByName('Materialno').AsString;
        OrdWono.Custno := UpperCase(FieldByName('Custno').AsString);
        OrdWono.Adhesive := Copy(OrdWono.Pno, 2, 1);
        OrdWono.Premark := FieldByName('Premark').AsString + FieldByName('Premark2').AsString;
        OrdWono.Sqty := FieldByName('Sqty').AsFloat;
        OrdWono.IsDG := not SameText(OrdWono.Machine, 'L6');

        if (Pos(OrdWono.Custno, strCD) > 0) or (Pos(OrdWono.Custno, 'ACD57,N024') > 0) then   //�R�F�Ȥ�
        begin
          if FieldByName('SrcFlag').AsInteger in [1, 3, 5] then //dg�q��
          begin
            if OrdWono.IsDG then  //L1~L5
            begin
              OrdWono.Orderno := FieldByName('Orderno').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem').AsString;
            end
            else              //L6
            begin
              OrdWono.Orderno := FieldByName('Orderno2').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem2').AsString;
            end;
          end
          else                                            //gz�q��
          begin
            if OrdWono.IsDG then  //L1~L5
            begin
              OrdWono.Orderno := FieldByName('Orderno2').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem2').AsString;
            end
            else
            begin
              OrdWono.Orderno := FieldByName('Orderno').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem').AsString;
            end;
          end;
        end
        else                               //�䥦�Ȥ�
        begin
          if OrdWono.IsDG then    //L1~L5
          begin
            if Pos(OrdWono.Custno, strGZCustno) > 0 then
            begin
              OrdWono.Orderno := FieldByName('Orderno2').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem2').AsString;
            end
            else
            begin
              OrdWono.Orderno := FieldByName('Orderno').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem').AsString;
            end;
          end
          else                //L6
          begin
            if Pos(OrdWono.Custno, strGZCustno) > 0 then
            begin
              OrdWono.Orderno := FieldByName('Orderno').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem').AsString;
            end
            else
            begin
              OrdWono.Orderno := FieldByName('Orderno2').AsString;
              OrdWono.Orderitem := FieldByName('Orderitem2').AsString;
            end;
          end;
        end;
        OrdWono.Adate := GetADate(IfThen(OrdWono.IsDG, 'ITEQDG', 'ITEQGZ'), OrdWono.Orderno, OrdWono.Orderitem);

        if not Assigned(l_MPST020_Wono) then
          l_MPST020_Wono := TMPST020_Wono.Create;

        if i = 1 then
          if not l_MPST020_Wono.Init(OrdWono.IsDG) then
            Exit;

        tmpStr := '  ' + IntToStr(i) + '/' + IntToStr(RecordCount);
        if l_MPST020_Wono.SetWono(OrdWono, tmpStr) then
        begin
          tmpAllWono := tmpAllWono + #13#10 + tmpStr;
          Edit;
          FieldByName('Wono').AsString := tmpStr;
          Post;
        end;

        Inc(i);
        Next;
      end;
    end;

    if CDSPost(tmpCDS, p_TableName) then
    begin
      if l_MPST020_Wono.Post(OrdWono.IsDG) then
      begin
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            if Self.CDS.Locate('Simuver;Citem', VarArrayOf([FieldByName('Simuver').AsString, FieldByName('Citem').AsString]), []) then
            begin
              Self.CDS.Edit;
              Self.CDS.FieldByName('Wono').AsString := FieldByName('Wono').AsString;
              Self.CDS.Post;
            end;
            Next;
          end;
        end;
        if Self.CDS.ChangeCount > 0 then
          Self.CDS.MergeChangeLog;

        l_SelList.Clear;
        cdsList.EmptyDataSet;
        if not Assigned(FrmMPST020_WonoList) then
          FrmMPST020_WonoList := TFrmMPST020_WonoList.Create(Self);
        FrmMPST020_WonoList.Memo1.Text := '�۰ʲ��ͤu�槹��,�u��渹�G' + tmpAllWono;
        FrmMPST020_WonoList.ShowModal;
      end
      else
      begin
        if Self.CDS.ChangeCount > 0 then
          Self.CDS.CancelUpdates;
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            Edit;
            FieldByName('Wono').AsString := '';
            Post;
            Next;
          end;
        end;
        if not CDSPost(tmpCDS, p_TableName) then
        begin
          ShowMsg('���ͤu�楢��,�U�C�u�渹�X�Ф�ʧR��!' + tmpAllWono, 48);
          Exit;
        end;
      end;
    end;
  finally
    SetBtnEnabled(True);
    CDS.EnableControls;
    g_StatusBar.Panels[0].Text := '';
    if l_SelList.Count = 0 then
      DBGridEh1.Repaint;
    FreeAndNil(tmpCDS);
    if not cdsList.IsEmpty then
      FreeAndNil(tmpCDS2);
//    orderls.FREE;
  end;
end;

function TFrmMPST020.GetADate(Bu, Orderno, Orderitem: string): TDateTime;
var
  s: string;
  data: OleVariant;
  tmpcds: TClientDataSet;
begin
  result := 0;                   
  {(*}
  s:='select Adate,CDate from MPS200 where Bu=%s and Orderno=%s and Orderitem=%s';
  s:=Format(s,[QuotedStr(bu),
               QuotedStr(Orderno),
               QuotedStr(Orderitem)]);   {*)}
  if not QueryBySQL(s, data) then
    exit;
  tmpcds := TClientDataSet.Create(nil);
  try
    tmpcds.data := data;
    if tmpcds.IsEmpty then
      exit;
    if not tmpcds.Fields[1].isnull then
      result := tmpcds.Fields[1].Value
    else if not tmpcds.Fields[0].isnull then
      result := tmpcds.Fields[0].Value;
    //Cdata�u��
  finally
    tmpcds.free;
  end;
end;

end.

