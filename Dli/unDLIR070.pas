{*******************************************************}
{                                                       }
{                unDLIR070                              }
{                Author: kaikai                         }
{                Create date: 2015/10/7                 }
{                Description: 出貨單流水號統計表        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLIR070;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI041, DBGridEhGrouping, ToolCtrlsEh, DBGridEhToolCtrls,
  DynVarsEh, ImgList, ExtCtrls, DB, DBClient, GridsEh, DBAxisGridsEh,
  DBGridEh, StdCtrls, ComCtrls, ToolWin;

type
  TFrmDLIR070 = class(TFrmSTDI041)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_queryClick(Sender: TObject);
  private
    { Private declarations }
    l_CDS:TClientDataSet;
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLIR070: TFrmDLIR070;

implementation

uses unGlobal, unCommon, unDLIR070_Query;

{$R *.dfm}

const l_CDSXml='<?xml version="1.0" standalone="yes"?>'
                  +'<DATAPACKET Version="2.0">'
                  +'<METADATA><FIELDS>'
                  +'<FIELD attrname="Saleno" fieldtype="string" WIDTH="10"/>'
                  +'<FIELD attrname="Custno" fieldtype="string" WIDTH="10"/>'
                  +'<FIELD attrname="Custshort" fieldtype="string" WIDTH="10"/>'
                  +'<FIELD attrname="Pno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="Custpno" fieldtype="string" WIDTH="20"/>'
                  +'<FIELD attrname="Qty" fieldtype="r8"/>'
                  +'<FIELD attrname="Dealer" fieldtype="string" WIDTH="10"/>'
                  +'<FIELD attrname="Dno" fieldtype="string" WIDTH="11"/>'
                  +'<FIELD attrname="Ditem" fieldtype="i4"/>'
                  +'</FIELDS><PARAMS/></METADATA>'
                  +'<ROWDATA></ROWDATA>'
                  +'</DATAPACKET>';

procedure TFrmDLIR070.RefreshDS(strFilter: string);
var
  tmpSQL:string;
  Data:OleVariant;
  tmpCDS,tmpOraCDS:TClientDataSet;
begin
  l_CDS.EmptyDataSet;
  if l_CDS.ChangeCount>0 then
     l_CDS.MergeChangeLog;

  if strFilter=g_cFilterNothing then
     CDS.Data:=l_CDS.Data
  else
  begin
    tmpSQL:='select saleno,dno,ditem from dli012'
           +' where bu='+Quotedstr(g_UInfo^.BU)+strFilter;     
    if QueryBySQL(tmpSQL, Data) then
    begin
      tmpCDS:=TClientDataSet.Create(nil);
      tmpOraCDS:=TClientDataSet.Create(nil);
      try
        tmpCDS.Data:=Data;
        if tmpCDS.IsEmpty then
           CDS.Data:=l_CDS.Data
        else begin
          tmpSQL:='';
          with tmpCDS do
          while not Eof do
          begin
            tmpSQL:=tmpSQL+','+Quotedstr(FieldByName('saleno').AsString);
            Next;
          end;

          Delete(tmpSQL,1,1);
          Data:=null;
          tmpSQL:=' select X.*,Y.gen02 from'
                 +' (select A.*,B.oeb11 from'
                 +' (select oga01,oga03,oga032,ogb04,ogb12,ogb31,ogb32,ogauser'
                 +' from '+g_UInfo^.BU+'.oga_file inner join '+g_UInfo^.BU+'.ogb_file'
                 +' on oga01=ogb01 where oga01 in ('+tmpSQL+')) A'
                 +' left join '+g_UInfo^.BU+'.oeb_file B'
                 +' on ogb31=oeb01 and ogb32=oeb03) X'
                 +' left join '+g_UInfo^.BU+'.gen_file Y'
                 +' on ogauser=gen01';
          if QueryBySQL(tmpSQL, Data, 'ORACLE') then
          begin
            tmpOraCDS.Data:=Data;
            tmpCDS.First;
            while not tmpCDS.Eof do
            begin
              with l_CDS do
              begin
                Append;
                FieldByName('Saleno').AsString:=tmpCDS.FieldByName('Saleno').AsString;
                FieldByName('Dno').AsString:=tmpCDS.FieldByName('Dno').AsString;
                FieldByName('Ditem').AsInteger:=tmpCDS.FieldByName('Ditem').AsInteger;

                if tmpOraCDS.Locate('oga01', FieldByName('Saleno').AsString, []) then
                begin
                  FieldByName('Custno').AsString:=tmpOraCDS.FieldByName('oga03').AsString;
                  FieldByName('Custshort').AsString:=tmpOraCDS.FieldByName('oga032').AsString;
                  FieldByName('Pno').AsString:=tmpOraCDS.FieldByName('ogb04').AsString;
                  FieldByName('Custpno').AsString:=tmpOraCDS.FieldByName('oeb11').AsString;
                  FieldByName('Qty').AsFloat:=tmpOraCDS.FieldByName('ogb12').AsFloat;
                  FieldByName('Dealer').AsString:=tmpOraCDS.FieldByName('gen02').AsString;
                end;
                Post;
              end;
              tmpCDS.Next;
            end;
            if l_CDS.ChangeCount>0 then
               l_CDS.MergeChangeLog;
            CDS.Data:=l_CDS.Data;   
          end;
        end;
      finally
        tmpCDS.Free;
        tmpOraCDS.Free;
      end;
    end;
  end;

  inherited;
end;

procedure TFrmDLIR070.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLIR070';
  p_GridDesignAns:=True;
  
  l_CDS:=TClientDataSet.Create(nil);
  InitCDS(l_CDS,l_CDSXml);

  inherited;

  CDS.IndexFieldNames:='Dno';
end;

procedure TFrmDLIR070.FormDestroy(Sender: TObject);
begin
  inherited;
  FreeAndNil(l_CDS);
end;

procedure TFrmDLIR070.btn_queryClick(Sender: TObject);
begin
//  inherited;
  if not Assigned(FrmDLIR070_Query) then
     FrmDLIR070_Query:=TFrmDLIR070_Query.Create(Application);
  if FrmDLIR070_Query.ShowModal=mrOK then
     RefreshDS(FrmDLIR070_Query.l_QueryStr);
end;

end.
