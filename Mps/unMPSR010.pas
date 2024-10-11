{*******************************************************}
{                                                       }
{                unMPSR010                              }
{                Author: kaikai                         }
{                Create date: 2015/4/7                  }
{                Description: 產能負荷表                }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSR010;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ExtCtrls, DB, DBClient, Menus, ImgList,
  StdCtrls, GridsEh, DBAxisGridsEh, DBGridEh, ComCtrls, ToolWin;

type
  TFrmMPSR010 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    l_FnameList:TStrings;
    function GetTop10_Custno:string;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSR010: TFrmMPSR010;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

function TFrmMPSR010.GetTop10_Custno:string;
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  l_FnameList.Clear;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpSQL:='Select Custno From MPS090'
           +' Where Bu='+Quotedstr(g_UInfo^.Bu)
           +' Order By Rank';
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      while not tmpCDS.Eof do
      begin
        l_FnameList.Add(tmpCDS.Fields[0].AsString);
        Result:=Result+',A.nu_capacity as '+tmpCDS.Fields[0].AsString;
        tmpCDS.Next;
      end;
    end;
  finally
    tmpCDS.Free;
  end;

  Result:=Result+',A.nu_capacity oth_capacity';
end;

procedure TFrmMPSR010.RefreshDS(strFilter: string);
var
  i:Integer;
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS:TClientDataSet;
begin
  p_TableName:='MPSR010';
  if strFilter=g_cFilterNothing then
     tmpSQL:='Select null Machine,null Wdate,'
            +' null Boiler_qty,null nu_capacity,null mu_capacity,'
            +' null fu_capacity,null eu_capacity,null ord_capacity,'
            +' null diff_capacity,null top10_capacity,null oth_capacity'
            +' From Sys_Bu Where 1<>1'
  else begin
     tmpSQL:=GetTop10_Custno;
     tmpSQL:='Select * From'
            +' (Select A.Machine,A.Wdate,A.Boiler_qty,'
            +' A.nu_capacity,A.mu_capacity,A.fu_capacity,A.eu_capacity,'
            +' IsNull(B.Sqty,0) ord_capacity,A.nu_capacity as diff_capacity'+tmpSQL
            +' From MPS030 as A'
            +' Left Join (Select Bu,Machine,Sdate,Sum(Sqty) Sqty'
            +' From MPS010 Where Machine<>''stk'' And Bu='+Quotedstr(g_UInfo^.Bu)
            +' And IsNull(EmptyFlag,0)<>1 And IsNull(ErrorFlag,0)<>1'
            +' Group By Bu,Machine,Sdate) as B'
            +' ON A.Bu=B.Bu And A.Machine=B.Machine'
            +' And A.Wdate=B.Sdate'
            +' Where A.Bu='+Quotedstr(g_UInfo^.Bu)
            +' And B.Sdate>getdate()-16) AS X Where 1=1 '+strFilter
            +' Order By Machine,Wdate';
  end;

  if QueryBySQL(tmpSQL, Data) then
  begin
    tmpCDS:=TClientDataSet.Create(nil);
    CDS.DisableControls;
    DBGridEh1.DataSource:=nil;
    try
    CDS.Data:=Data;
    Data:=null;
    tmpSQL:='Select * From'
           +' (Select B.Machine,B.Sdate as Wdate,'
           +' A.Custno,Sum(B.Sqty) Sqty'
           +' From MPS090 A Inner Join MPS010 B'
           +' ON A.Bu=B.Bu and A.Custno=B.Custno'
           +' Where B.Machine<>''stk'' And A.Bu='+Quotedstr(g_UInfo^.Bu)
           +' And B.Sdate>getdate()-16'
           +' And IsNull(B.EmptyFlag,0)<>1 And IsNull(B.ErrorFlag,0)<>1'
           +' Group By B.Machine,B.Sdate,A.Custno) AS X'
           +' Where 1=1 '+strFilter;
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS.Data:=Data;
      with CDS do
      begin
        while not Eof do
        begin
          Edit;
          if FieldByName('nu_capacity').IsNull then
             FieldByName('nu_capacity').AsFloat:=0;
          if FieldByName('mu_capacity').IsNull then
             FieldByName('mu_capacity').AsFloat:=0;
          if FieldByName('fu_capacity').IsNull then
             FieldByName('fu_capacity').AsFloat:=0;
          if FieldByName('eu_capacity').IsNull then
             FieldByName('eu_capacity').AsFloat:=0;
          FieldByName('oth_capacity').AsFloat:=0;
          FieldByName('diff_capacity').AsFloat:=Round(FieldByName('nu_capacity').AsFloat
                                                 -FieldByName('mu_capacity').AsFloat
                                                 -FieldByName('fu_capacity').AsFloat
                                                 -FieldByName('eu_capacity').AsFloat
                                                 -FieldByName('ord_capacity').AsFloat);
          for i:=0 to l_FnameList.Count -1 do
              FieldByName(l_FnameList.Strings[i]).AsFloat:=0;

          tmpCDS.Filtered:=False;
          tmpCDS.Filter:=' Wdate='+Quotedstr(DateToStr(FieldByName('Wdate').AsDateTime))
                        +' And Machine='+Quotedstr(FieldByName('Machine').AsString);
          tmpCDS.Filtered:=True;
          while not tmpCDS.Eof do
          begin
            if FindField(tmpCDS.FieldByName('Custno').AsString)<>nil then
               FieldByName(tmpCDS.FieldByName('Custno').AsString).AsFloat:=tmpCDS.FieldByName('Sqty').AsFloat;
            tmpCDS.Next;
          end;
          for i:=0 to l_FnameList.Count -1 do //oth_capacity暫存十大客戶產能
              FieldByName('oth_capacity').AsFloat:=Round(FieldByName('oth_capacity').AsFloat
                                                  +FieldByName(l_FnameList.Strings[i]).AsFloat);
                                              //其它客戶產能
          FieldByName('oth_capacity').AsFloat:=Round(FieldByName('ord_capacity').AsFloat
                                                 -FieldByName('oth_capacity').AsFloat);
          Post;
          Next;
        end;
      end;
    end;

    finally
      tmpCDS.Free;
      CDS.First;
      CDS.EnableControls;
      DBGridEh1.DataSource:=DS;
    end;

    SetGrdCaption(DBGridEh1, p_TableName);
  end;

  inherited;
end;

procedure TFrmMPSR010.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='@';
  p_GridDesignAns:=False;
  l_FnameList:=TStringList.Create;

  inherited;
end;

procedure TFrmMPSR010.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  FreeAndNil(l_FnameList);
end;

end.
