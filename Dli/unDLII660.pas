{*******************************************************}
{                                                       }
{                unDLII660                              }
{                Author: kaikai                         }
{                Create date: 2020/5/21                 }
{                Description: ������������ܨ���        }
{                Copyright (c) 2015-9999 by ITEQ        }
{                                                       }
{*******************************************************}

unit unDLII660;

interface

uses
Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI031, DBGridEhGrouping, DB, DBClient, 
  Menus, ImgList, StdCtrls, Buttons, ExtCtrls, GridsEh, DBGridEh, ComCtrls,
  ToolWin, ToolCtrlsEh, DBGridEhToolCtrls, DynVarsEh, DBAxisGridsEh;

type
  TFrmDLII660 = class(TFrmSTDI031)
    procedure FormCreate(Sender: TObject);
    procedure CDSBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure RefreshDS(strFilter:string);override;
  end;

var
  FrmDLII660: TFrmDLII660;

implementation

uses unGlobal,unCommon;

{$R *.dfm}

procedure TFrmDLII660.RefreshDS(strFilter:string);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  tmpSQL:='Select * From DLI660 Where Bu='+Quotedstr(g_UInfo^.BU)+' '+strFilter
         +' Order By custno,sno,id';
  if QueryBySQL(tmpSQL, Data) then
     CDS.Data:=Data;

  inherited;
end;

procedure TFrmDLII660.FormCreate(Sender: TObject);
begin
  p_SysId:='Dli';
  p_TableName:='DLI660';
  p_GridDesignAns:=True;
  P_SBText:=CheckLang('����J��ܩ���������(�Ȥᥲ�ݿ�J),�h�ӱ���ȽХ�"/"���j');

  inherited;
end;

procedure TFrmDLII660.CDSBeforePost(DataSet: TDataSet);
var
  SrcId:Integer;
  tmpSQL:string;
  Data:OleVariant;
begin
  if Length(Trim(CDS.FieldByName('Custno').AsString))=0 then
  begin
    ShowMsg('�п�J[%s]', 48, DBGridEh1.FieldColumns['Custno'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Custno');
    Abort;
  end;

  if (Length(Trim(CDS.FieldByName('Code2').AsString))>0) and
     (Length(Trim(CDS.FieldByName('Code2X').AsString))>0) then
  begin
    ShowMsg('[�Ƹ���2�X]�B[�ư��Ƹ���2�X]��줣�i�P�ɿ�J!', 48);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Code2');
    Abort;
  end;

  if (Length(Trim(CDS.FieldByName('Struct').AsString))>0) and
     (Length(Trim(CDS.FieldByName('StructX').AsString))>0) then
  begin
    ShowMsg('[���c]�B[�ư����c]��줣�i�P�ɿ�J!', 48);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Struct');
    Abort;
  end;

  if Length(Trim(CDS.FieldByName('Strip_lower').AsString))>0 then
  if Length(Trim(CDS.FieldByName('Strip_lower').AsString))<>4 then
  begin
    ShowMsg('[%s]�п�J�Ƹ�3-6�X', 48, DBGridEh1.FieldColumns['Strip_lower'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Strip_lower');
    Abort;
  end;

  if Length(Trim(CDS.FieldByName('Strip_upper').AsString))>0 then
  if Length(Trim(CDS.FieldByName('Strip_upper').AsString))<>4 then
  begin
    ShowMsg('[%s]�п�J�Ƹ�3-6�X', 48, DBGridEh1.FieldColumns['Strip_upper'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Strip_upper');
    Abort;
  end;

  SrcId:=DBGridEh1.FieldColumns['SrcValue'].PickList.IndexOf(CDS.FieldByName('SrcValue').AsString);
  if SrcId=-1 then
  begin
    ShowMsg('�п��[%s]', 48, DBGridEh1.FieldColumns['SrcValue'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('SrcValue');
    Abort;
  end;

  CDS.FieldByName('SrcId').AsInteger:=SrcId;

  if (SrcId=0) and (Length(Trim(CDS.FieldByName('Value').AsString))=0) then
  begin
    ShowMsg('���[���w����],�п�J[%s]', 48, DBGridEh1.FieldColumns['Value'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Value');
    Abort;
  end;

  if (SrcId<>0) and (Length(Trim(CDS.FieldByName('Value').AsString))>0) then
  begin
    ShowMsg('�����[���w����],[%s]���ο�J', 48, DBGridEh1.FieldColumns['Value'].Title.Caption);
    DBGridEh1.SetFocus;
    DBGridEh1.SelectedField:=CDS.FieldByName('Value');
    Abort;
  end;

  if DataSet.State in [dsInsert] then
  begin
    tmpSQL:='Select IsNull(Max(Id),0)+1 as Id From '+p_TableName
           +' Where Bu='+Quotedstr(g_UInfo^.BU);
    if not QueryOneCR(tmpSQL, Data) then
       Abort;
    CDS.FieldByName('Id').AsInteger:=StrToIntDef(VarToStr(Data),1);
  end;

  inherited;
end;

end.
