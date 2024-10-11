{*******************************************************}
{                                                       }
{                unMPSR180                              }
{                Author: kaikai                         }
{                Create date: 2015/10/10                }
{                Description: ½u§O²£¯à­t²üªí            }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR180;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmMPSR180 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure DBGridEh1GetCellParams(Sender: TObject; Column: TColumnEh;
      AFont: TFont; var Background: TColor; State: TGridDrawState);
    procedure btn_queryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    l_CDS:TClientDataSet;
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR180: TFrmMPSR180;

implementation

uses unGlobal, unCommon;

const g_Xml='<?xml version="1.0" standalone="yes"?>'
           +'<DATAPACKET Version="2.0">'
           +'<METADATA><FIELDS>'
           +'<FIELD attrname="sdate" fieldtype="DateTime"/>'
           +'<FIELD attrname="type" fieldtype="string" WIDTH="10"/>'
           +'<FIELD attrname="L1_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L1_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="L2_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L2_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="L3_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L3_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="L4_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L4_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="L5_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L5_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="L6_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="L6_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="Tot_Capacity1" fieldtype="r8"/>'
           +'<FIELD attrname="Tot_Capacity2" fieldtype="r8"/>'
           +'<FIELD attrname="sno" fieldtype="i4"/>'
           +'<FIELD attrname="color" fieldtype="Boolean"/>'
           +'</FIELDS><PARAMS/></METADATA>'
           +'<ROWDATA></ROWDATA>'
           +'</DATAPACKET>';

const l_strsum='¦X­p';

{$R *.dfm}

procedure TFrmMPSR180.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  colorIndex:Boolean;
  tot11,tot12,tot21,tot22,tot31,tot32,tot41,tot42,tot51,tot52,tot61,tot62,totx,toty:Double;
  D1,D2:TDateTime;
  Data1,Data2,Data3:OleVariant;
  tmpCDS1,tmpCDS2,tmpCDS3:TClientDataSet;
begin
  l_CDS.EmptyDataSet;
  if strFilter<>'1' then
  begin
    CDS.Data:=l_CDS.Data;
    inherited;
    Exit;
  end;

  g_StatusBar.Panels[0].Text:=CheckLang('¥¿¦b¬d¸ß...');
  try
    tmpSQL:='select distinct type from mps640 where bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data1) then
       Exit;

    tmpSQL:='select machine,type,capacity from mps640 where bu='+Quotedstr(g_UInfo^.BU);
    if not QueryBySQL(tmpSQL, Data2) then
       Exit;

    tmpSQL:='select sdate,machine,type,sum(sqty) capacity'
           +' from (select sdate,machine,sqty,'
           +' case when (type=''40Á¡'' or type=''40«p'') then ''40Á¡/«p'''
           +' when (type=''55Á¡'' or type=''55«p'') then ''55Á¡/«p'''
           +' when (type=''33Á¡'' or type=''33«p'') then ''33Á¡/«p'''
           +' when (type=''74Á¡'' or type=''74«p'') then ''74Á¡/«p'''
           +' when (type=''82Á¡'' or type=''82«p'') then ''82Á¡/«p'''
           +' when (type=''86Á¡'' or type=''86«p'') then ''86Á¡/«p'' else type end type'
           +' from (select sdate,machine,sqty,'
           +' left(stealno,charindex(''-'',stealno)-1)+case when substring(materialno,3,4)<''0221'' then ''Á¡'' else ''«p'' end type'
           +' from mps010 where bu='+Quotedstr(g_UInfo^.BU)
           +' and sdate>getdate()-1 and isnull(emptyflag,0)=0 and isnull(errorflag,0)=0) x) y'
           +' group by sdate,machine,type'
           +' order by sdate,machine';
    if not QueryBySQL(tmpSQL, Data3) then
       Exit;

    tmpCDS1:=TClientDataSet.Create(nil);
    tmpCDS2:=TClientDataSet.Create(nil);
    tmpCDS3:=TClientDataSet.Create(nil);
    try
      tmpCDS1.Data:=Data1;
      tmpCDS2.Data:=Data2;
      tmpCDS3.Data:=Data3;
      if tmpCDS1.IsEmpty or tmpCDS2.IsEmpty or tmpCDS3.IsEmpty then
      begin
        CDS.Data:=l_CDS.Data;
        inherited;
        Exit;
      end;

      tmpCDS3.First;
      D1:=tmpCDS3.FieldByName('sdate').AsDateTime;
      tmpCDS3.Last;
      D2:=tmpCDS3.FieldByName('sdate').AsDateTime;
      colorIndex:=False;

      //³]©w
      while D1<=D2 do
      begin
        tmpCDS1.First;
        while not tmpCDS1.Eof do
        begin
          l_CDS.Append;
          l_CDS.FieldByName('sdate').AsDateTime:=D1;
          l_CDS.FieldByName('sno').AsInteger:=0;
          l_CDS.FieldByName('color').AsBoolean:=colorIndex;
          l_CDS.FieldByName('type').AsString:=tmpCDS1.FieldByName('type').AsString;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L1',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L1_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L2',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L2_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L3',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L3_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L4',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L4_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L5',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L5_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          if tmpCDS2.Locate('machine;type', VarArrayOf(['L6',tmpCDS1.FieldByName('type').AsString]), []) then
             l_CDS.FieldByName('L6_Capacity1').AsFloat:=tmpCDS2.FieldByName('capacity').AsFloat;
          l_CDS.Post;
          tmpCDS1.Next;
        end;
        colorIndex:=not colorIndex;
        D1:=D1+1;
      end;

      //±Æ²£
      tmpCDS3.First;
      while not tmpCDS3.Eof do
      begin
        if l_CDS.Locate('sdate;type', VarArrayOf([tmpCDS3.FieldByName('sdate').AsDateTime,tmpCDS3.FieldByName('type').AsString]),[]) then
        begin
          l_CDS.Edit;
          if SameText(tmpCDS3.FieldByName('machine').AsString,'L1') then
             l_CDS.FieldByName('L1_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat
          else if SameText(tmpCDS3.FieldByName('machine').AsString,'L2') then
             l_CDS.FieldByName('L2_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat
          else if SameText(tmpCDS3.FieldByName('machine').AsString,'L3') then
             l_CDS.FieldByName('L3_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat
          else if SameText(tmpCDS3.FieldByName('machine').AsString,'L4') then
             l_CDS.FieldByName('L4_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat
          else if SameText(tmpCDS3.FieldByName('machine').AsString,'L5') then
             l_CDS.FieldByName('L5_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat
          else if SameText(tmpCDS3.FieldByName('machine').AsString,'L6') then
             l_CDS.FieldByName('L6_Capacity2').AsFloat:=tmpCDS3.FieldByName('capacity').AsFloat;
          l_CDS.Post;
        end;
        tmpCDS3.Next;
      end;

      //¦æ¦X­p
      with l_CDS do
      begin
        First;
        while not Eof do
        begin
          Edit;
          FieldByName('Tot_Capacity1').AsFloat:=FieldByName('L1_Capacity1').AsFloat+
                                                FieldByName('L2_Capacity1').AsFloat+
                                                FieldByName('L3_Capacity1').AsFloat+
                                                FieldByName('L4_Capacity1').AsFloat+
                                                FieldByName('L5_Capacity1').AsFloat+
                                                FieldByName('L6_Capacity1').AsFloat;
          FieldByName('Tot_Capacity2').AsFloat:=FieldByName('L1_Capacity2').AsFloat+
                                                FieldByName('L2_Capacity2').AsFloat+
                                                FieldByName('L3_Capacity2').AsFloat+
                                                FieldByName('L4_Capacity2').AsFloat+
                                                FieldByName('L5_Capacity2').AsFloat+
                                                FieldByName('L6_Capacity2').AsFloat;
          Post;
          NExt;
        end;
      end;

      //¦C¦X­p
      tmpCDS3.First;
      D1:=tmpCDS3.FieldByName('sdate').AsDateTime;
      tmpCDS3.Data:=l_CDS.Data;
      while D1<=D2 do
      begin
        tot11:=0;tot12:=0;
        tot21:=0;tot22:=0;
        tot31:=0;tot32:=0;
        tot41:=0;tot42:=0;
        tot51:=0;tot52:=0;
        tot61:=0;tot62:=0;
        totx:=0;toty:=0;
        tmpCDS3.Filtered:=False;
        tmpCDS3.Filter:='sdate='+Quotedstr(DateToStr(D1));
        tmpCDS3.Filtered:=True;
        tmpCDS3.First;
        while not tmpCDS3.Eof do
        begin
          tot11:=tot11+tmpCDS3.FieldByName('L1_Capacity1').AsFloat;
          tot12:=tot12+tmpCDS3.FieldByName('L1_Capacity2').AsFloat;
          tot21:=tot21+tmpCDS3.FieldByName('L2_Capacity1').AsFloat;
          tot22:=tot22+tmpCDS3.FieldByName('L2_Capacity2').AsFloat;
          tot31:=tot31+tmpCDS3.FieldByName('L3_Capacity1').AsFloat;
          tot32:=tot32+tmpCDS3.FieldByName('L3_Capacity2').AsFloat;
          tot41:=tot41+tmpCDS3.FieldByName('L4_Capacity1').AsFloat;
          tot42:=tot42+tmpCDS3.FieldByName('L4_Capacity2').AsFloat;
          tot51:=tot51+tmpCDS3.FieldByName('L5_Capacity1').AsFloat;
          tot52:=tot52+tmpCDS3.FieldByName('L5_Capacity2').AsFloat;
          tot61:=tot61+tmpCDS3.FieldByName('L6_Capacity1').AsFloat;
          tot62:=tot62+tmpCDS3.FieldByName('L6_Capacity2').AsFloat;
          totx:=totx+tmpCDS3.FieldByName('Tot_Capacity1').AsFloat;
          toty:=toty+tmpCDS3.FieldByName('Tot_Capacity2').AsFloat;
          tmpCDS3.Next;
        end;

        l_CDS.Append;
        l_CDS.FieldByName('sdate').AsDateTime:=D1;
        l_CDS.FieldByName('sno').AsInteger:=1;
        l_CDS.FieldByName('type').AsString:=l_strsum;
        l_CDS.FieldByName('L1_Capacity1').AsFloat:=tot11;
        l_CDS.FieldByName('L1_Capacity2').AsFloat:=tot12;
        l_CDS.FieldByName('L2_Capacity1').AsFloat:=tot21;
        l_CDS.FieldByName('L2_Capacity2').AsFloat:=tot22;
        l_CDS.FieldByName('L3_Capacity1').AsFloat:=tot31;
        l_CDS.FieldByName('L3_Capacity2').AsFloat:=tot32;
        l_CDS.FieldByName('L4_Capacity1').AsFloat:=tot41;
        l_CDS.FieldByName('L4_Capacity2').AsFloat:=tot42;
        l_CDS.FieldByName('L5_Capacity1').AsFloat:=tot51;
        l_CDS.FieldByName('L5_Capacity2').AsFloat:=tot52;
        l_CDS.FieldByName('L6_Capacity1').AsFloat:=tot61;
        l_CDS.FieldByName('L6_Capacity2').AsFloat:=tot62;
        l_CDS.FieldByName('Tot_Capacity1').AsFloat:=totx;
        l_CDS.FieldByName('Tot_Capacity2').AsFloat:=toty;
        l_CDS.Post;

        D1:=D1+1;
      end;

      if l_CDS.ChangeCount>0 then
         l_CDS.MergeChangeLog;
      CDS.Data:=l_CDS.Data;
      CDS.IndexFieldNames:='sdate;sno;type';
    finally
      FreeAndNil(tmpCDS1);
      FreeAndNil(tmpCDS2);
      FreeAndNil(tmpCDS3);
    end;
  finally
    g_StatusBar.Panels[0].Text:='';
  end;
  inherited;
end;

procedure TFrmMPSR180.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPSR180';
  p_GridDesignAns:=True;
  l_CDS:=TClientDataSet.Create(Self);
  InitCDS(l_CDS, g_xml);

  inherited;
end;

procedure TFrmMPSR180.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmMPSR180.btn_queryClick(Sender: TObject);
begin
//  inherited;
  RefreshDS('1');
end;

procedure TFrmMPSR180.DBGridEh1GetCellParams(Sender: TObject;
  Column: TColumnEh; AFont: TFont; var Background: TColor;
  State: TGridDrawState);
begin
  inherited;
  if CDS.FieldByName('color').AsBoolean then
     Background:=RGB(204,236,255);
  if CDS.FieldByName('type').AsString=l_strsum then
     AFont.Color:=clBlue;
end;

end.
