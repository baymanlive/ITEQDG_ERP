{*******************************************************}
{                                                       }
{                unMPST021                              }
{                Author: kaikai                         }
{                Create date: 2017/5/4                  }
{                Description: PP���ͤu��                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPST021;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, StdCtrls, Buttons, ImgList, ExtCtrls, DB, DBClient, GridsEh,
  DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin, StrUtils, unMPST021_Wono;

type
  TFrmMPST021 = class(TFrmSTDI041)
    btn_mpst020A: TToolButton;
    btn_mpst020B: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGridEh1TitleClick(Column: TColumnEh);
    procedure DBGridEh1CellClick(Column: TColumnEh);
    procedure DBGridEh1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumnEh; State: TGridDrawState);
    procedure btn_mpst020AClick(Sender: TObject);
    procedure btn_mpst020BClick(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_StrIndex,l_StrIndexDesc:string;
    l_SelList:TStrings;
    l_MPST021_Wono:TMPST021_Wono;
    procedure SetBtnEnabled(bool:Boolean);
    function GetDG_GZCustno(var DGCustno,GZCustno:string):Boolean;
    procedure DG;
    function GetADate(Bu,Orderno,Orderitem:string):TDateTime;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPST021: TFrmMPST021;

implementation

uses unGlobal, unCommon, unMPST021_Orderno2, unMPST021_WonoList;

{$R *.dfm}

procedure TFrmMPST021.SetBtnEnabled(bool:Boolean);
begin
  btn_mpst020A.Enabled:=bool;
  btn_mpst020B.Enabled:=bool;
end;

//�F��B�s�{�U��Ȥ�,��^False��ܿ��~
function TFrmMPST021.GetDG_GZCustno(var DGCustno,GZCustno:string):Boolean;
var
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
begin
  Result:=False;
  DGCustno:='';
  DGCustno:='';
  tmpSQL:='Select Upper(Custno) C1,isDG From MPS250'
         +' Where Bu='+Quotedstr(g_UInfo^.BU);
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    while not Eof do
    begin
      if Fields[1].AsBoolean then
         DGCustno:=DGCustno+Fields[0].AsString+'/'
      else
         GZCustno:=GZCustno+Fields[0].AsString+'/';
      Next;
    end;
    if DGCustno<>'' then
       DGCustno:='/'+DGCustno;
    if GZCustno<>'' then
       GZCustno:='/'+GZCustno;
    Result:=True;
  finally
    tmpCDS.Free;
  end;
end;

procedure TFrmMPST021.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS070 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' And IsNull(EmptyFlag,0)=0'
         +' And IsNull(ErrorFlag,0)=0'
         +' And IsNull(Case_ans2,0)=0'
         +' And IsNull(Wostation,0)<'+IntToStr(g_WonoErrorFlag)
         +' Order BY Machine,Sdate,Jitem,AD,Fisno,RC Desc,Fiber,Simuver,Citem';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPST021.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS070';
  p_GridDesignAns:=True;
  btn_mpst020A.Visible:=SameText(g_UInfo^.BU,'ITEQDG') and g_MInfo^.R_edit;
  btn_mpst020B.Visible:=g_MInfo^.R_edit;
  if g_MInfo^.R_edit then
     btn_quit.Left:=btn_mpst020B.Left+btn_mpst020B.Width;

  inherited;

  l_SelList:=TStringList.Create;
end;

procedure TFrmMPST021.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_SelList);
  if Assigned(l_MPST021_Wono) then
     FreeAndNil(l_MPST021_Wono);
end;

procedure TFrmMPST021.DBGridEh1TitleClick(Column: TColumnEh);
begin
  inherited;
  SetAscDesc(CDS, Column, l_StrIndex, l_StrIndexDesc);
end;

procedure TFrmMPST021.btn_queryClick(Sender: TObject);
var
  tmpStr:string;
begin
  //inherited;
  if GetQueryString(p_TableName, tmpStr) then
  begin
    l_SelList.Clear;
    RefreshGrdCaption(CDS, DBGridEh1, l_StrIndex, l_StrIndexDesc);
    RefreshDS(tmpStr);
  end;
end;

procedure TFrmMPST021.DBGridEh1CellClick(Column: TColumnEh);
var
  tmpStr:string;
begin
  inherited;
  if (not CDS.Active) or CDS.IsEmpty or (not g_MInfo^.R_edit) then
     Exit;

  if SameText(Column.FieldName,'select') then
  begin
    tmpStr:=CDS.FieldByName('Simuver').AsString+'@'+
            CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr) =-1 then
       l_SelList.Add(tmpStr)
    else
       l_SelList.Delete(l_SelList.IndexOf(tmpStr));
    DBGridEh1.Repaint;
  end;
end;

procedure TFrmMPST021.DBGridEh1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumnEh;
  State: TGridDrawState);
var
  tmpStr:string;
begin
  inherited;
  if SameText(Column.FieldName, 'select') then
  begin
    tmpStr:=CDS.FieldByName('Simuver').AsString+'@'+
            CDS.FieldByName('Citem').AsString;
    if l_SelList.IndexOf(tmpStr)<>-1 then
       DBGridEh1.Canvas.TextOut(Round((Rect.Left+Rect.Right)/2)-6,
       Round((Rect.Top+Rect.Bottom)/2-6), 'V');
  end;
end;

procedure TFrmMPST021.btn_mpst020AClick(Sender: TObject);
begin
  inherited;
  FrmMPST021_Orderno2:=TFrmMPST021_Orderno2.Create(nil);
  try
    FrmMPST021_Orderno2.ShowModal;
  finally
    FreeAndNil(FrmMPST021_Orderno2);
  end;
end;

procedure TFrmMPST021.btn_mpst020BClick(Sender: TObject);
begin
  inherited;
  if SameText(g_UInfo^.BU,'ITEQDG') then
     DG
  else
     ShowMsg('���{�����i�ϥ�!',48);
end;

procedure TFrmMPST021.DG;
const strCD='/AC121/AC820/ACA97/AC526/AC305/AC625/';  //�s�{�ֱ�
var
  i:Integer;
  tmpStr,tmpAllWono,strDGCustno,strGZCustno:string;
  OrdWono:TOrderWono;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  inherited;

  if (l_SelList.Count=0) or (l_SelList.Count>20) then
  begin
    ShowMsg('�п�ܭn���ͤu�檺�Ƶ{���,�̦h�i���20��!',48);
    Exit;
  end;

  if ShowMsg('�T�w���ͤu���?', 33)=IdCancel then
     Exit;

  tmpStr:='';
  for i:=0 to l_SelList.Count -1 do
  begin
    if tmpStr<>'' then
       tmpStr:=tmpStr+',';
    tmpStr:=tmpStr+Quotedstr(l_SelList.Strings[i])
  end;
  tmpStr:='Select Simuver,Citem,Wono,Machine,Materialno,Custno,Sqty,Breadth,Fiber,'
         +' Orderno,Orderitem,Orderno2,Orderitem2,Premark,SrcFlag From '+p_TableName
         +' Where Bu='+Quotedstr(g_UInfo^.BU)
         +' And Simuver+''@''+Cast(Citem as varchar(10)) in ('+tmpStr+')';
  if not QueryBySQL(tmpStr, Data) then
     Exit;

  SetBtnEnabled(False);
  CDS.DisableControls;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.RecordCount<>l_SelList.Count then
    begin
      ShowMsg('��Ƥ��P�B,�Э��s�d�߸��!',48);
      Exit;
    end;

    tmpStr:='';
    with tmpCDS do
    begin
      while not Eof do
      begin
        if Length(FieldByName('Materialno').AsString)=18 then
        if (Length(FieldByName('Orderno').AsString)=0) or
           (FieldByName('Orderitem').AsInteger<1) then
        begin
          ShowMsg('����g�q�渹�X�ζ���!', 48);
          Exit;
        end;

        if Length(FieldByName('Wono').AsString)>0 then
        begin
          if Length(FieldByName('Materialno').AsString)=18 then
             ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                             FieldByName('Orderitem').AsString+']�w�}�u��!',48)
          else
             ShowMsg('����['+FieldByName('Materialno').AsString+']�w�}�u��!',48);
          Exit;
        end;

        if (tmpStr<>'') and (tmpStr<>FieldByName('Machine').AsString) then
        begin
          ShowMsg('���i��u���ͤu��!', 48);
          Exit;
        end;

        tmpStr:=CDS.FieldByName('Machine').AsString;

        if Pos(tmpStr,'T1,T2,T3,T4,T5')>0 then
        if Pos(RightStr(FieldByName('materialno').AsString,1),g_DGLastCode)=0 then
        begin
          ShowMsg('�F�𲣥ͤu����X���G'+g_DGLastCode, 48);
          Exit;
        end;

        if Pos(tmpStr,'T6,T7,T8')>0 then
        if Pos(RightStr(FieldByName('materialno').AsString,1),g_GZLastCode)=0 then
        begin
          ShowMsg('�s�{���ͤu����X���G'+g_GZLastCode, 48);
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
        if Length(FieldByName('Materialno').AsString)<18 then
        begin
          Next;
          Continue;
        end;

        tmpStr:='/'+UpperCase(FieldByName('Custno').AsString)+'/';
        if (Pos(tmpStr, strDGCustno)=0) and (Pos(tmpStr, strGZCustno)=0) then
        begin
          ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                          FieldByName('Orderitem').AsString+']'+
                  '�U��Ȥ�]�w�L���Ȥ�'+tmpStr, 48);
          Exit;
        end else
        if (Pos(tmpStr, strDGCustno)>0) and (Pos(tmpStr, strGZCustno)>0) then //�o�����p��ƪ�]�p�w�ư�
        begin
          ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                          FieldByName('Orderitem').AsString+']'+
                  '�U��Ȥ�]�w�Ȥ᭫�|'+tmpStr, 48);
          Exit;
        end;

        //strCD:�R�F�Ȥ�S��
        if (Pos(tmpStr, strCD)>0) or (Pos(tmpStr, 'ACD57/N024')>0) then
        begin
          if FieldByName('SrcFlag').AsInteger in [1,3,5] then  //dg�q��
          begin
            //T6,T7,T8�u:GZ�Ͳ�
            if Pos(FieldByName('Machine').AsString, 'T6/T7/T8')>0 then
            begin
              if (Length(FieldByName('Orderno2').AsString)=0) or
                 (FieldByName('Orderitem2').AsInteger<1) then
              begin
                ShowMsg('DG�R�F�q��['+FieldByName('Orderno').AsString+'/'+
                                      FieldByName('Orderitem').AsString+']'+
                        'GZ�Ͳ�������g�⨤�q�渹�X�ζ���'+tmpStr, 48);
                Exit;
              end;
            end else
            begin
              if (Length(FieldByName('Orderno2').AsString)>0) or
                 (not FieldByName('Orderitem2').IsNull) then
              begin
                ShowMsg('DG�R�F�q��['+FieldByName('Orderno').AsString+'/'+
                                      FieldByName('Orderitem').AsString+']'+
                        'DG,T9,T10�Ͳ����ζ�g�⨤�q�渹�X�ζ���'+tmpStr, 48);
                Exit;
              end;
            end;
          end else   //gz�q��
          begin
            //T6,T7,T8�u:GZ�Ͳ�
            if Pos(FieldByName('Machine').AsString, 'T6/T7/T8')>0 then
            begin
              if (Length(FieldByName('Orderno2').AsString)>0) or
                 (not FieldByName('Orderitem2').IsNull) then
              begin
                ShowMsg('GZ�R�F�q��['+FieldByName('Orderno').AsString+'/'+
                                      FieldByName('Orderitem').AsString+']'+
                        'GZ�Ͳ����ζ�g�⨤�q�渹�X�ζ���'+tmpStr, 48);
                Exit;
              end;
            end else
              if (Length(FieldByName('Orderno2').AsString)=0) or
                 (FieldByName('Orderitem2').AsInteger<1) then
              begin
                ShowMsg('GZ�R�F�q��['+FieldByName('Orderno').AsString+'/'+
                                      FieldByName('Orderitem').AsString+']'+
                        'DG,T9,T10�Ͳ�����g�⨤�q�渹�X�ζ���'+tmpStr, 48);
                Exit;
              end;
          end;
        end else //�䥦�Ȥ�
        begin
          //T6,T7,T8�u:GZ�Ͳ�
          if Pos(FieldByName('Machine').AsString, 'T6/T7/T8')>0 then
          begin
            //gz�Ȥᤣ�i��g2���q��
            if (Pos(tmpStr, strGZCustno)>0) and
               ((Length(FieldByName('Orderno2').AsString)>0) or
                (not FieldByName('Orderitem2').IsNull)) then
            begin
              ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                              FieldByName('Orderitem').AsString+']'+
                      'GZ�Ȥᤣ�ζ�g�⨤�q�渹�X�ζ���'+tmpStr, 48);
              Exit;
            end;

            //dg�Ȥ�@�w�n�g2���q��
            if (Pos(tmpStr, strDGCustno)>0) and
               ((Length(FieldByName('Orderno2').AsString)=0) or
                (FieldByName('Orderitem2').AsInteger<1)) then
            begin
              ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                              FieldByName('Orderitem').AsString+']'+
                      'DG�Ȥ᥼��g�⨤�q�渹�X�ζ���'+tmpStr, 48);
              Exit;
            end;
          end else  //T1~T5�u:DG�Ͳ��BT9�BT10
          begin
            //gz�Ȥ�@�w�n�g2���q��
            if (Pos(tmpStr, strGZCustno)>0) and
               ((Length(FieldByName('Orderno2').AsString)=0) or
                (FieldByName('Orderitem2').AsInteger<1)) then
            begin
              ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                              FieldByName('Orderitem').AsString+']'+
                      'GZ�Ȥ᥼��g�⨤�q�渹�X�ζ���'+tmpStr, 48);
              Exit;
            end;

            //dg�Ȥᤣ�i��g2���q��
            if (Pos(tmpStr, strDGCustno)>0) and
               ((Length(FieldByName('Orderno2').AsString)>0) or
                (not FieldByName('Orderitem2').IsNull)) then
            begin
              ShowMsg('�q��['+FieldByName('Orderno').AsString+'/'+
                              FieldByName('Orderitem').AsString+']'+
                      'DG�Ȥᤣ�ζ�g�⨤�q�渹�X�ζ���'+tmpStr, 48);
              Exit;
            end;
          end;
        end;

        Next;
      end;
    end;

    i:=1;
    tmpAllWono:='';
    with tmpCDS do
    begin
      First;
      while not Eof do
      begin
        OrdWono.Machine:=FieldByName('Machine').AsString;
        OrdWono.Pno:=FieldByName('Materialno').AsString;
        OrdWono.Custno:=UpperCase(FieldByName('Custno').AsString);
        OrdWono.Breadth:=FieldByName('Breadth').AsString;
        OrdWono.Fiber:=FieldByName('Fiber').AsString;
        OrdWono.Premark:=FieldByName('Premark').AsString;
        OrdWono.Sqty:=FieldByName('Sqty').AsFloat;
        OrdWono.IsDG:=Pos('/'+OrdWono.Machine+'/', '/T1/T2/T3/T4/T5/T9/T10/')>0;
        if Length(OrdWono.Pno)=18 then
        begin
          if Pos(OrdWono.Custno, strCD)>0 then   //�R�F�Ȥ�
          begin
            if FieldByName('SrcFlag').AsInteger in [1,3,5] then //dg�q��
            begin
              if OrdWono.IsDG then  //T1~T5,T9,T10
              begin
                OrdWono.Orderno:=FieldByName('Orderno').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem').AsString;
              end else              //T6,T7,T8
              begin
                OrdWono.Orderno:=FieldByName('Orderno2').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem2').AsString;
              end;
            end else                                            //gz�q��
            begin
              if OrdWono.IsDG then  //T1~T5,T9,T10
              begin
                OrdWono.Orderno:=FieldByName('Orderno2').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem2').AsString;
              end else              //T6,T7,T8
              begin
                OrdWono.Orderno:=FieldByName('Orderno').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem').AsString;
              end;
            end;
          end else                               //�䥦�Ȥ�
          begin
            if OrdWono.IsDG then    //T1~T5,T9,T10
            begin
              if Pos(OrdWono.Custno, strGZCustno)>0 then
              begin
                OrdWono.Orderno:=FieldByName('Orderno2').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem2').AsString;
              end else
              begin
                OrdWono.Orderno:=FieldByName('Orderno').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem').AsString;
              end;
            end else                //T6,T7,T8
            begin
              if Pos(OrdWono.Custno, strGZCustno)>0 then
              begin
                OrdWono.Orderno:=FieldByName('Orderno').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem').AsString;
              end else
              begin
                OrdWono.Orderno:=FieldByName('Orderno2').AsString;
                OrdWono.Orderitem:=FieldByName('Orderitem2').AsString;
              end;
            end;
          end;
        end;
        OrdWono.Adate := GetADate(IfThen(OrdWono.IsDG,'ITEQDG','ITEQGZ'),OrdWono.Orderno,OrdWono.Orderitem);
        if not Assigned(l_MPST021_Wono) then
           l_MPST021_Wono:=TMPST021_Wono.Create;

        if i=1 then
        if not l_MPST021_Wono.Init(OrdWono.IsDG) then
           Exit;

        tmpStr:='  '+IntToStr(i)+'/'+IntToStr(RecordCount);
        if l_MPST021_Wono.SetWono(OrdWono, tmpStr) then
        begin
          tmpAllWono:=tmpAllWono+#13#10+tmpStr;
          Edit;
          FieldByName('Wono').AsString:=tmpStr;
          Post;
        end;

        Inc(i);
        Next;
      end;
    end;

    //�x�s
    if CDSPost(tmpCDS, p_TableName) then
    begin
      if l_MPST021_Wono.Post(OrdWono.IsDG) then
      begin
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            if Self.CDS.Locate('Simuver;Citem', VarArrayOf([FieldByName('Simuver').AsString,
               FieldByName('Citem').AsString]), []) then
            begin
              Self.CDS.Edit;
              Self.CDS.FieldByName('Wono').AsString:=FieldByName('Wono').AsString;
              Self.CDS.Post;
            end;
            Next;
          end;
        end;
        if Self.CDS.ChangeCount>0 then
           Self.CDS.MergeChangeLog;

        l_SelList.Clear;
        if not Assigned(FrmMPST021_WonoList) then
           FrmMPST021_WonoList:=TFrmMPST021_WonoList.Create(Self);
        FrmMPST021_WonoList.Memo1.Text:='�۰ʲ��ͤu�槹��,�u��渹�G'+tmpAllWono;
        FrmMPST021_WonoList.ShowModal;
      end else
      begin
        if Self.CDS.ChangeCount>0 then
           Self.CDS.CancelUpdates;
        with tmpCDS do
        begin
          First;
          while not Eof do
          begin
            Edit;
            FieldByName('Wono').AsString:='';
            Post;
            Next;
          end;
        end;
        if not CDSPost(tmpCDS, p_TableName) then
        begin
          ShowMsg('���ͤu�楢��,�U�C�u�渹�X�Ф�ʧR��!'+tmpAllWono, 48);
          Exit;
        end;
      end;
    end;
  finally
    SetBtnEnabled(True);
    CDS.EnableControls;
    g_StatusBar.Panels[0].Text:='';
    if l_SelList.Count=0 then
       DBGridEh1.Repaint;
    FreeAndNil(tmpCDS);
  end;
end;

function TFrmMPST021.GetADate(Bu,Orderno,Orderitem:string):TDateTime;
var
  s: string;
  data: OleVariant;
  tmpcds: TClientDataSet;
begin
  Result:=0;
  {(*}

  s:='select Adate,CDate from MPS200 where Bu=%s and Orderno=%s and Orderitem=%s';
  s:=Format(s,[QuotedStr(bu),
               QuotedStr(Orderno),
               QuotedStr(Orderitem)]);   {*)}
  if not QueryBySQL(s, data) then
    exit;
  tmpcds := TClientDataSet.Create(nil);
  try
    tmpcds.data:=data;
    if tmpcds.IsEmpty then
      exit;
    if not tmpcds.Fields[1].isnull then
      result:=tmpcds.Fields[1].Value
    else if not tmpcds.Fields[0].isnull then
      result:=tmpcds.Fields[0].Value;
    //Cdata�u��
  finally
    tmpcds.free;
  end;
end;

end.
