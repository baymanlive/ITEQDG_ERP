unit unDLII620_set;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unSTDI051, ImgList, StdCtrls, Buttons, ExtCtrls, DBClient;

type
  TFrmDLII620_set = class(TFrmSTDI051)
    Label1: TLabel;
    Label2: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    l_ispda:boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmDLII620_set: TFrmDLII620_set;

implementation

uses unGlobal, unCommon;

{$R *.dfm}

procedure TFrmDLII620_set.btn_okClick(Sender: TObject);
var
  tmpSQL:string;
begin
 // inherited;
  if l_ispda then
     tmpSQL:='N'
  else
     tmpSQL:='Y';
  tmpSQL:='declare @bu varchar(10)'
         +' set @bu='+Quotedstr(g_UInfo^.BU)
         +' if not exists(select 1 from dli621 where bu=@bu)'
         +' insert into dli621(bu,iuser,idate) values(@bu,'+Quotedstr(g_UInfo^.UserId)+','+Quotedstr(DateToStr(Date))+')'
         +' update dli621 set ispda='+Quotedstr(tmpSQL)
         +',muser='+Quotedstr(g_UInfo^.UserId)
         +',mdate='+Quotedstr(DateToStr(Date))
         +' where bu=@bu';
  if PostBySQL(tmpSQL) then
  begin
    l_ispda:=not l_ispda;
    if l_ispda then
    begin
      Label1.Caption:=CheckLang('已開啟');
      Label1.Font.Color:=clBlue;
    end else
    begin
      Label1.Caption:=CheckLang('已關閉');
      Label1.Font.Color:=clRed;
    end;
  end
end;

procedure TFrmDLII620_set.FormCreate(Sender: TObject);
begin
  inherited;
  Label2.Caption:=CheckLang('當TipTop異常時，請關閉PDA檢查客戶品名功能');
end;

procedure TFrmDLII620_set.FormShow(Sender: TObject);
var
  tmpSQL:string;
  Data:OleVariant;
begin
  inherited;
  Label1.Caption:=CheckLang('已關閉');
  Label1.Font.Color:=clRed;
  l_ispda:=False;
  tmpSQL:='select top 1 ispda from dli621 where bu='+Quotedstr(g_UInfo^.BU);
  if QueryOneCR(tmpSQL, Data) then
  begin
    if not VarIsNull(Data) then
    if SameText(VarToStr(Data),'Y') then
    begin
      Label1.Caption:=CheckLang('已開啟');
      Label1.Font.Color:=clBlue;
      l_ispda:=True;
    end;
  end;
end;

end.
