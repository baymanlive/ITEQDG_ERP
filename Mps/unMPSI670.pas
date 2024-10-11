{*******************************************************}
{                                                       }
{                unMPSI670                              }
{                Author: kaikai                         }
{                Create date: 2021/5/7                  }
{                Description: 特殊尺寸排製量換算        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unMPSI670;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmMPSI670 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
    procedure CDSAfterPost(DataSet: TDataSet);
    procedure CDSAfterDelete(DataSet: TDataSet);
  private
    procedure SetProc;
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmMPSI670: TFrmMPSI670;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmMPSI670.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From MPS670 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter;
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmMPSI670.FormCreate(Sender: TObject);
begin
  p_SysId:='Mps';
  p_TableName:='MPS670';
  p_GridDesignAns:=True;

  inherited;
end;

procedure TFrmMPSI670.CDSBeforePost(DataSet: TDataSet);
  procedure ShowM(fName:string);
  begin
    ShowMsg('請輸入[%s]', 48, DBGridEh1.FieldColumns[fName].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName(fName);
    Abort;
  end;
begin
  if Length(Trim(CDS.FieldByName('size_l').AsString))=0 then
     ShowM('size_l');
  if Length(Trim(CDS.FieldByName('size_h').AsString))=0 then
     ShowM('size_h');
  if CDS.FieldByName('d').AsInteger<=0 then
     ShowM('d');
  if CDS.FieldByName('m').AsInteger<=0 then
     ShowM('m');
  inherited;
end;

procedure TFrmMPSI670.CDSAfterPost(DataSet: TDataSet);
begin
  inherited;
  SetProc;
end;

procedure TFrmMPSI670.CDSAfterDelete(DataSet: TDataSet);
begin
  inherited;
  SetProc;
end;

procedure TFrmMPSI670.SetProc;
var
  i:Integer;
  tmpSQL:string;
  tmpCDS:TClientDataSet;
  Data:OleVariant;
  tmpList:TStrings;
begin
  tmpSQL:='select lower(bu) bu,size_l,size_h,d,m from mps670 order by bu';
  if not QueryBySQL(tmpSQL, Data) then
     Exit;

  tmpSQL:='';
  tmpList:=TStringList.Create;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    with tmpCDS do
    if not IsEmpty then
    begin
      while not Eof do
      begin
        if tmpList.IndexOf(FieldByName('bu').AsString)=-1 then
           tmpList.Add(FieldByName('bu').AsString);
        Next;
      end;

      tmpSQL:='';
      for i:=0 to tmpList.Count-1 do
      begin
        Filtered:=False;
        Filter:='bu='+Quotedstr(tmpList.Strings[i]);
        Filtered:=True;
        First;
        tmpSQL:=tmpSQL+' 	if @bu='''''+FieldByName('bu').AsString+''''''+#13+' 	begin'+#13;

        while not Eof do
        begin
          if RecNo=1 then
             tmpSQL:=tmpSQL+'	 	if'
          else
             tmpSQL:=tmpSQL+'	 	else if';
          tmpSQL:=tmpSQL+' @code9_11>='''''+FieldByName('size_l').AsString+''''' and @code9_11<='''''+FieldByName('size_h').AsString+''''''+#13
                        +' 	 	 	set @newqty=ceiling(@newqty/'+IntToStr(FieldByName('d').AsInteger)+'*'+IntToStr(FieldByName('m').AsInteger)+')'+#13;
          Next;
        end;

        tmpSQL:=tmpSQL+' 	end'+#13;
      end;
    end;

    tmpSQL:='IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[Get_Sqty]'') AND type=''FN'')'+#13
           +'DROP FUNCTION [dbo].[Get_Sqty]'+#13           +'execute dbo.sp_executesql @statement = N'''+#13           +'CREATE FUNCTION [dbo].[Get_Sqty]'+#13           +'('+#13           +'	@bu nvarchar(20),'+#13           +'	@pno nvarchar(20),'+#13           +'	@sqty float'+#13           +')'+#13           +'Returns float'+#13           +'AS'+#13           +'begin'+#13           +'	declare @code9_11 nvarchar(3)'+#13           +'	declare @newqty float'+#13           +'	set @code9_11=substring(@pno,9,3)'+#13           +'	set @newqty=@sqty'+#13+tmpSQL
           +'	return @newqty'+#13
           +'end''';
    PostBySQL(tmpSQL);
  finally
    FreeAndNil(tmpList);
    FreeAndNil(tmpCDS);
  end;
end;

end.
