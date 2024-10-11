unit unMPSR020_remark;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, StdCtrls, ExtCtrls, ImgList, Buttons, DBClient;

type
  TFrmMPSR020_remark = class(TFrmSTDI051)
    lblwono: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    Memo1: TMemo;
    rgp: TRadioGroup;
    Label2: TLabel;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMPSR020_remark: TFrmMPSR020_remark;

implementation

uses unGlobal, unCommon, unMPSR020;

{$R *.dfm}

procedure TFrmMPSR020_remark.FormCreate(Sender: TObject);
begin
  inherited;
  rgp.Items.Strings[0]:=CheckLang('東莞工單');
  rgp.Items.Strings[1]:=CheckLang('廣州工單');
end;

procedure TFrmMPSR020_remark.btn_okClick(Sender: TObject);
var
  str1,str2,str3,L6,db:string;
  Data:Olevariant;
  tmpCDS:TClientDataSet;
begin
 // inherited;
  str1:=Trim(Edit1.Text);
  str2:=Trim(Memo1.Text);
  str3:=Trim(Memo2.Text);
  if Length(str1)=0 then
  begin
    ShowMsg('請輸入製令單號!',48);
    Edit1.SetFocus;
    Exit;
  end;

  if Length(str2)>200 then
  begin
    ShowMsg('長度限制200個字符!',48);
    Memo1.SetFocus;
    Exit;
  end;

  if Length(str3)>200 then
  begin
    ShowMsg('長度限制200個字符!',48);
    Memo2.SetFocus;
    Exit;
  end;

  if rgp.ItemIndex=0 then
  begin
    db:='ITEQDG';
    L6:=' and machine<>''L6''';
  end else
  begin
    db:='ITEQGZ';
    L6:=' and machine=''L6''';
  end;

  str1:=' declare @wono varchar(10)'
       +' set @wono='+Quotedstr(str1)
       +' if exists(select 1 from mps010 where bu=''ITEQDG'' and wono=@wono '+L6+')'
       +' begin'
       +'   if exists(select 1 from mps020 where bu='+Quotedstr(db)+' and wono=@wono)'
       +'      update mps020 set remark='+Quotedstr(str2)+',remark2='+Quotedstr(str3)+' where bu='+Quotedstr(db)+' and wono=@wono'
       +'   else'
       +'      insert into mps020(bu,wono,remark,remark2) values('+Quotedstr(db)+',@wono,'+Quotedstr(str2)+','+Quotedstr(str3)+')'
       +'   select simuver,citem from mps010 where bu=''ITEQDG'' and wono=@wono '+L6
       +' end else'
       +'   select 0 as id';
  if not QueryBySQL(str1, Data) then
     Exit;
  tmpCDS:=TClientDataSet.Create(nil);
  try
    tmpCDS.Data:=Data;
    if tmpCDS.FieldCount=1 then
    begin
      ShowMsg('製令單號不存在,請確認!',48);
      Edit1.SetFocus;
      Exit;
    end;

    with FrmMPSR020.CDS do
    if Locate('simuver;citem',VarArrayOf([tmpCDS.Fields[0].AsString, tmpCDS.Fields[1].AsInteger]),[]) then
    begin
      Edit;
      FieldByName('remark').AsString:=str2;
      FieldByName('remark2').AsString:=str3;
      Post;
      MergeChangeLog;
    end;
    ShowMsg('更改完畢!',64);
  finally
    tmpCDS.Free;
  end;
end;

end.
